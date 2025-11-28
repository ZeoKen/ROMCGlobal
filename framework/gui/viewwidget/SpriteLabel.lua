SpriteLabel = reusableClass("SpriteLabel")
SpriteLabel.PoolSize = 10
SpriteLabel.PatternMap = {
  item = "({itemicon=(%d+)})",
  ui = "({uiicon=(.+)})",
  map = "({mapicon=(.+)})",
  buff = "({bufficon=(.+)})",
  equipupgrade = "({equipupgradeicon=(.+)})",
  tasktrace = "({taskuiicon=(.+)})",
  equipcard = "({equipcardicon=(.+)})",
  price = "({priceicon=(.+)})",
  profession = "({professionicon=(%d+)})",
  lottery = "({cardicon=(.+)})",
  nature = "({natureicon=(.+)})",
  magic = "{(.-)magicicon=(.-)}",
  inlinebutton = "({inlinebutton=(.+)})",
  quickcopy = "({quickcopyicon=(.+)})",
  communityicon = "({communityicon=(.+)})",
  inheritskill = "({inheritskill=(.+)})",
  roguelikeskillicon = "({roguelikeskillicon=(.+)})"
}
SpriteLabel.SpriteForceColorMap = {
  ["new-com_icon_tips"] = "8693ae",
  tips_icon_11 = "24b3ff",
  tips_icon_07 = "4a5a7d",
  tips_icon_08 = "4a5a7d",
  tips_icon_10x = "4a5a7d",
  tips_icon_09 = "4a5a7d",
  persona_icon_dot = "7D6951",
  guild_icon_front = "A8CEEF",
  ["main_icon_The-server"] = "EDB3B3",
  rune_lb_drop_01 = "919191"
}
SpriteLabel.useLuaVersion = not BranchMgr.IsChina() and not BranchMgr.IsTW()
local bbpattern = "%[%g-%]"
local bbplaceholder = "\031"
local exclude_pattern = "%[%d%]"
local exclude_placeholder = "\006"
local iconpattern = "{%g-}"
local iconplaceholder = "\003 \003 \003 \003 \003 "
local activeEquipUpgradeColor, inactiveEquipUpgradeColor = LuaColor.New(0.43137254901960786, 0.5372549019607843, 0.8196078431372549, 1), LuaColor.New(0.6392156862745098, 0.6588235294117647, 0.6980392156862745, 1)
local spriteForcePixelPerfectMap = {}
local spriteOptPattern = "%[(.-)=(.-)%]"
local rllog = function(arg1, arg2, arg3, arg4, arg5)
end

function SpriteLabel:ctor(label, width, iconWidth, iconHeight, iconCenterInLine, iconScale, iconColorHexStr)
  SpriteLabel.super.ctor(self)
  if label ~= nil then
    self.iconWidth = iconWidth or 30
    self.iconHeight = iconHeight or 30
    self.iconScale = iconScale or 1
    self.iconColorHexStr = iconColorHexStr
    self.richLabel = label.gameObject:GetComponent(UIRichLabel)
    if self.richLabel == nil then
      self.richLabel = label.gameObject:AddComponent(UIRichLabel)
    end
    self.richLabelTrans = self.richLabel.transform
    self:SetIconCenterInLine(iconCenterInLine)
    self.richLabel.keepCrispWhenShrunk = UILabel.Crispness.Never
    if BranchMgr.IsJapan() then
      if self.richLabel.useFloatSpacing then
        if self.richLabel.spacingX == 0 then
          self.richLabel.spacingX = 1
        end
      elseif self.richLabel.floatSpacingX == 0 then
        self.richLabel.floatSpacingX = 1
      end
      self.richLabel.space = string.rep(" ", math.ceil(self.iconWidth / (math.floor(self.richLabel.defaultFontSize / 2) + self.richLabel.effectiveSpacingX)))
    else
      self.richLabel.space = string.rep(" ", math.floor(self.iconWidth / (self.richLabel.defaultFontSize / 4)))
    end
    self.richLabel.iconSize = LuaGeometry.GetTempVector2(self.iconWidth, self.iconHeight)
    self.richLabel.m_offsetX = -self.iconWidth / 2
    self.trueText = nil
    self.lineWidth = width or self.richLabel.width
    self.richLabel.BASELINEWIDTH = self.lineWidth
    self.richLabel:ProcessText()
    self:Reset()
    if SpriteLabel.useLuaVersion then
      if BranchMgr.IsJapan() then
        iconplaceholder = string.rep("\003 ", math.ceil(self.iconWidth / (math.floor(self.richLabel.defaultFontSize / 2) + self.richLabel.effectiveSpacingX)))
      else
        iconplaceholder = string.rep("\003 ", math.floor(self.iconWidth / (self.richLabel.defaultFontSize / 4)))
      end
    end
  end
  self:TryInitSpriteForcePixelPerfectMap()
end

function SpriteLabel:Init(label, width, iconWidth, iconHeight, iconCenterInLine, iconScale, iconColorHexStr)
  self.iconWidth = iconWidth or 30
  self.iconHeight = iconHeight or 30
  self.iconScale = iconScale or 1
  self.iconColorHexStr = iconColorHexStr
  self.richLabel = label.gameObject:GetComponent(UIRichLabel)
  if self.richLabel == nil then
    self.richLabel = label.gameObject:AddComponent(UIRichLabel)
  end
  self.richLabelTrans = self.richLabel.transform
  self:SetIconCenterInLine(iconCenterInLine)
  self.richLabel.keepCrispWhenShrunk = UILabel.Crispness.Never
  self.richLabel.space = string.rep(" ", math.floor(self.iconWidth / (self.richLabel.defaultFontSize / 4)))
  self.richLabel.iconSize = LuaGeometry.GetTempVector2(self.iconWidth, self.iconHeight)
  self.richLabel.m_offsetX = -self.iconWidth / 2
  self.trueText = nil
  self.lineWidth = width or self.richLabel.width
  self.richLabel.BASELINEWIDTH = self.lineWidth
  self:Reset()
  if SpriteLabel.useLuaVersion then
    if BranchMgr.IsJapan() then
      iconplaceholder = string.rep("\003 ", math.ceil(self.iconWidth / (math.floor(self.richLabel.defaultFontSize / 2) + self.richLabel.effectiveSpacingX)))
    else
      iconplaceholder = string.rep("\003 ", math.floor(self.iconWidth / (self.richLabel.defaultFontSize / 4)))
    end
  end
end

function SpriteLabel:ResetLineWidth(width)
  self.lineWidth = width or self.richLabel.width
  self.richLabel.BASELINEWIDTH = self.lineWidth
end

function SpriteLabel:TryInitSpriteForcePixelPerfectMap()
  if next(spriteForcePixelPerfectMap) then
    return
  end
  for _, spriteName in pairs(ItemTipPropIcon) do
    spriteForcePixelPerfectMap[spriteName] = true
  end
  for spriteName, _ in pairs(SpriteLabel.SpriteForceColorMap) do
    spriteForcePixelPerfectMap[spriteName] = true
  end
end

function SpriteLabel:SetIconCenterInLine(value)
  if value == nil then
    value = false
  end
  self.iconCenterInLine = value
end

function SpriteLabel:SetText(text, autoAddSps)
  text = OverSea.LangManager.Instance():GetLangByKey(text)
  self:Reset()
  text = OverseaHostHelper:FilterLangStr(text)
  if string.match(text, "icon") ~= nil then
    if autoAddSps == nil then
      autoAddSps = true
    end
    self.trueText = text
    text = OverseaHostHelper:SpecialProcess(RemoveSpecialChara(text))
    local parsedText = ""
    if not SpriteLabel.useLuaVersion then
      local excludes = {}
      for m in text:gmatch(exclude_pattern) do
        table.insert(excludes, m)
      end
      if #excludes ~= 0 then
        text = text:gsub(exclude_pattern, exclude_placeholder)
        rllog("替换不需要处理的情况", text)
      end
      local bbcodes = {}
      if text:find("%[/c%]") or text:find("%[%-%]") then
        for m in text:gmatch(bbpattern) do
          table.insert(bbcodes, m)
        end
        if #bbcodes ~= 0 then
          text = text:gsub(bbpattern, bbplaceholder)
          rllog("替换 bbcode", text)
        end
      end
      parsedText = text and self.richLabel:ParseText(text) or ""
      if #bbcodes ~= 0 then
        for m in parsedText:gmatch(bbplaceholder) do
          local replacement = table.remove(bbcodes, 1)
          if replacement then
            parsedText = parsedText:gsub(bbplaceholder, replacement, 1)
          end
        end
        rllog("恢复 bbcode", parsedText)
      end
      if self.richLabel.overflowMethod == 2 then
        self.richLabel.text = parsedText
        self.richLabel:ParseText(text)
      end
    else
      parsedText = text and self:SetRichLabel(text, self:CheckSpace()) or ""
      if self.richLabel.overflowMethod == 2 then
        self.richLabel.text = parsedText
        self:SetRichLabel(text, self:CheckSpace())
      end
    end
    self:UpdateMinHeight()
    self.richLabel.text = parsedText
    if autoAddSps then
      self:AddSprites()
    end
  else
    self.richLabel.text = text
  end
end

function SpriteLabel:UpdateMinHeight()
  local lines = self.richLabel.Lines
  local height = self.richLabel:GetSpLineTotalHeight(lines)
  self.richLabel.MinHeight = height
end

function SpriteLabel:AddSprites()
  if SpriteLabel.useLuaVersion then
    if self.icons_info then
      self.labelPivot = self.richLabel.pivotOffset
      rllog("使用 lua 版本显示 icon", self.richLabel.width, self.richLabel.height)
      self.halfHeight = self.richLabel.height / 2
      rllog("self.halfHeight", self.halfHeight, #self.icons_info)
      for jj = 1, #self.icons_info do
        self:AddSprite2(self.icons_info[jj])
      end
    end
    return
  end
  self.labelPivot = self.richLabel.pivotOffset
  local spDatas = self.richLabel.symbols
  self.fontSize = self.richLabel.defaultFontSize
  self.paddingY = self.richLabel.effectiveSpacingY
  self.halfHeight = self.richLabel.height / 2
  for i = 0, spDatas.Count - 1 do
    self:AddSprite(spDatas[i])
  end
end

function SpriteLabel:AddSprite(data)
  local icon, itemData
  for str, id in string.gmatch(data.info, SpriteLabel.PatternMap.item) do
    icon, itemData = self:CreateSprite(), Table_Item[tonumber(id)]
    if itemData then
      if itemData.Type == 1200 then
        IconManager:SetFaceIcon(itemData.Icon, icon)
      else
        IconManager:SetItemIcon(itemData.Icon, icon)
      end
      self:TryForceSpritePixelPerfect(icon)
      self:SetSpritePos(icon, data.pos, data.lineWidth)
      self:TryForceSpriteColor(icon)
    else
      printRed("Cannot Find Item" .. id)
    end
  end
  for str, name in string.gmatch(data.info, SpriteLabel.PatternMap.ui) do
    icon = self:CreateSprite()
    IconManager:SetUIIcon(name, icon)
    self:TryForceSpritePixelPerfect(icon)
    self:SetSpritePos(icon, data.pos, data.lineWidth)
    self:TryForceSpriteColor(icon)
  end
  for str, name in string.gmatch(data.info, SpriteLabel.PatternMap.map) do
    icon = self:CreateSprite()
    if not IconManager:SetMapIcon(name, icon) then
      IconManager:SetEffectIcon(name, icon)
    end
    self:TryForceSpritePixelPerfect(icon)
    self:SetSpritePos(icon, data.pos, data.lineWidth)
    self:TryForceSpriteColor(icon)
  end
  for optsStr, iconName in string.gmatch(data.info, SpriteLabel.PatternMap.magic) do
    icon = self:CreateSprite()
    IconManager:SetItemIcon(iconName, icon)
    icon.keepAspectRatio = 0
    icon:MakePixelPerfect()
    icon.keepAspectRatio = 2
    icon.height = self.iconHeight
    self:SetSpritePos(icon, data.pos, data.lineWidth)
    if optsStr and optsStr ~= "" then
      self:ApplySpriteOptions(icon, optsStr)
    end
  end
  for str, name in string.gmatch(data.info, SpriteLabel.PatternMap.buff) do
    icon = self:CreateSprite()
    IconManager:SetSkillIconByProfess(name, icon, MyselfProxy.Instance:GetMyProfessionType())
    self:TryForceSpritePixelPerfect(icon)
    self:SetSpritePos(icon, data.pos, data.lineWidth)
    self:TryForceSpriteColor(icon)
  end
  for _, str in string.gmatch(data.info, SpriteLabel.PatternMap.equipupgrade) do
    local indicatorSp, indicatorLabel = self:CreateEquipUpgradeIndicator()
    if indicatorSp then
      self:SetSpritePos(indicatorSp, data.pos, data.lineWidth)
      local level = tonumber(str)
      if level then
        indicatorSp.color = 0 < level and activeEquipUpgradeColor or inactiveEquipUpgradeColor
        indicatorLabel.text = StringUtil.IntToRoman(math.abs(level))
      elseif string.lower(str) == "end" then
        indicatorSp.color = inactiveEquipUpgradeColor
        indicatorLabel.text = "End"
      end
    end
  end
  for _, str in string.gmatch(data.info, SpriteLabel.PatternMap.equipcard) do
    local indicatorBg, indicatorSp = self:CreateEquipCardIndicator()
    if indicatorBg then
      self:SetSpritePos(indicatorBg, data.pos, data.lineWidth)
      local number = tonumber(str)
      if number == 0 then
        indicatorSp.spriteName = "new-com_icon_card_5"
      elseif number and 0 < number and number < 5 then
        indicatorSp.spriteName = "new-com_icon_card_" .. number
      else
        indicatorSp.spriteName = "new-com_icon_card_6"
      end
    end
  end
  for _, str in string.gmatch(data.info, SpriteLabel.PatternMap.price) do
    local indicatorSp, indicatorLabel = self:CreatePriceIndicator()
    if indicatorSp then
      self:SetSpritePos(indicatorSp, data.pos, data.lineWidth)
      local arr = string.split(str, ",")
      if arr and 1 < #arr then
        local itemId, price = tonumber(arr[1]), tonumber(arr[2])
        if itemId and Table_Item[itemId] and price and 0 <= price then
          IconManager:SetItemIcon(Table_Item[itemId].Icon, indicatorSp)
          indicatorLabel.text = StringUtil.NumThousandFormat(price)
        end
      end
    end
  end
  for str, name in string.gmatch(data.info, SpriteLabel.PatternMap.tasktrace) do
    icon = self:CreateSprite()
    IconManager:SetUIIcon(name, icon)
    self:TryForceSpritePixelPerfect(icon)
    self:SetTaskQuestCellPos(icon, data.pos, self.halfHeight, data.lineWidth)
    self:TryForceSpriteColor(icon)
  end
  local classData
  for str, id in string.gmatch(data.info, SpriteLabel.PatternMap.profession) do
    icon, classData = self:CreateSprite(), Table_Class[tonumber(id)]
    if classData then
      IconManager:SetNewProfessionIcon(classData.icon, icon)
      self:TryForceSpritePixelPerfect(icon)
      self:SetSpritePos(icon, data.pos, data.lineWidth)
      self:TryForceSpriteColor(icon)
    else
      redlog("Cannot Find Class" .. id)
    end
  end
  for str, iconstr in string.gmatch(data.info, SpriteLabel.PatternMap.lottery) do
    icon = self:CreateSprite()
    local atlas = RO.AtlasMap.GetAtlas("UI_Lottery")
    icon.atlas = atlas
    icon.spriteName = iconstr
    self:SetSpritePos(icon, data.pos, data.lineWidth)
  end
  for str, iconstr in string.gmatch(data.info, SpriteLabel.PatternMap.nature) do
    icon = self:CreateSprite()
    IconManager:SetUIIcon(iconstr, icon)
    self:SetSpritePos(icon, data.pos, data.lineWidth)
  end
  for _, str in string.gmatch(data.info, SpriteLabel.PatternMap.inlinebutton) do
    icon = self:CreateEquipInlineButton()
    local pos
    local buttonCfg = string.split(str, ",")
    if #buttonCfg == 2 then
      if not self.inlineBtns then
        self.inlineBtns = {}
      end
      self.inlineBtns[buttonCfg[2]] = icon
    end
    IconManager:SetUIIcon(buttonCfg[1], icon)
    if buttonCfg[2] == "k_quench" then
      ColorUtil.WhiteUIWidget(icon)
      icon.width = 36
      icon.height = 28
    end
    self:SetSpritePos(icon, data.pos, data.lineWidth)
  end
  for _, str in string.gmatch(data.info, SpriteLabel.PatternMap.quickcopy) do
    icon = self:CreateQuickCopyButton(str)
    self:SetSpritePos(icon, data.pos, data.lineWidth)
  end
  for _, str in string.gmatch(data.info, SpriteLabel.PatternMap.communityicon) do
    icon = self:CreateSprite()
    local atlas = RO.AtlasMap.GetAtlas("NewUI10")
    icon.atlas = atlas
    icon.spriteName = str
    self:TryForceSpritePixelPerfect(icon)
    self:SetSpritePos(icon, data.pos, data.lineWidth)
  end
  for _, iconName in string.gmatch(data.info, SpriteLabel.PatternMap.inheritskill) do
    icon = self:CreateSprite()
    local atlas = RO.AtlasMap.GetAtlas("UI_InheritSkill")
    icon.atlas = atlas
    icon.spriteName = iconName
    self:SetSpritePos(icon, data.pos, data.lineWidth)
  end
  for _, iconName in string.gmatch(data.info, SpriteLabel.PatternMap.roguelikeskillicon) do
    icon = self:CreateSprite()
    local atlas = RO.AtlasMap.GetAtlas("UI_Gem")
    icon.atlas = atlas
    icon.spriteName = iconName
    self:TryForceSpritePixelPerfect(icon)
    self:TryForceSpriteColor(icon)
    self:SetSpritePos(icon, data.pos, data.lineWidth)
  end
end

function SpriteLabel:SetSpritePos(sp, pos, inLineWidth)
  if not sp then
    return
  end
  if self.iconCenterInLine then
    pos.y = -self.richLabel:GetSpLineTotalHeight(math.floor(pos.y)) - (self.fontSize + sp.height) / 2
  else
    pos.y = -self.richLabel:GetSpLineTotalHeight(math.floor(pos.y)) - self.halfHeight * 2
  end
  if self.labelPivot.y == 0.5 then
    pos.y = pos.y + self.halfHeight
  end
  if self.labelPivot.x == 0 then
    pos.x = pos.x + inLineWidth / 2
  end
  sp.transform.localPosition = pos
end

function SpriteLabel:SetTaskQuestCellPos(sp, pos, halfHeight, inLineWidth)
  pos.y = -self.richLabel:GetSpLineTotalHeight(math.floor(pos.y))
  pos.y = pos.y - sp.height
  if self.labelPivot.x == 0 then
    pos.x = pos.x + inLineWidth / 2
  end
  sp.transform.localPosition = pos
end

function SpriteLabel:CreateSprite()
  local obj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("SpriteForSpriteLabel"), self.richLabel.gameObject)
  if not obj then
    LogUtility.Warning("Cannot create asset SpriteForSpriteLabel")
    return
  end
  local sp = obj:GetComponent(UISprite)
  sp.depth = self.richLabel.depth + 1
  sp.width = self.iconWidth
  sp.height = self.iconHeight
  self.richLabel.sprites:Add(sp)
  return sp
end

function SpriteLabel:CreateEquipUpgradeIndicator()
  local obj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("EquipUpgradeIndicator"), self.richLabel.gameObject)
  if not obj then
    LogUtility.Warning("Cannot create asset EquipUpgradeIndicator")
    return
  end
  local labelObj = Game.GameObjectUtil:DeepFind(obj, "Label")
  if not labelObj then
    return
  end
  local sp, label = obj:GetComponent(UISprite), labelObj:GetComponent(UILabel)
  sp.depth = self.richLabel.depth + 1
  label.depth = sp.depth + 1
  self.richLabel.sprites:Add(sp)
  self.iconHeight = 24
  self.iconWidth = 24
  return sp, label
end

function SpriteLabel:CreateEquipCardIndicator()
  local obj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("EquipCardIndicator"), self.richLabel.gameObject)
  if not obj then
    LogUtility.Warning("Cannot create asset EquipCardIndicator")
    return
  end
  local spObj = Game.GameObjectUtil:DeepFind(obj, "Sprite")
  if not spObj then
    return
  end
  local bg, sp = obj:GetComponent(UISprite), spObj:GetComponent(UISprite)
  bg.depth = self.richLabel.depth + 1
  sp.depth = bg.depth + 1
  self.richLabel.sprites:Add(bg)
  self.iconHeight = 16
  self.iconWidth = 16
  return bg, sp
end

function SpriteLabel:CreatePriceIndicator()
  local obj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("PriceIndicator"), self.richLabel.gameObject)
  if not obj then
    LogUtility.Warning("Cannot create asset PriceIndicator")
    return
  end
  local labelObj = Game.GameObjectUtil:DeepFind(obj, "Label")
  if not labelObj then
    return
  end
  local itemSp, label = obj:GetComponent(UISprite), labelObj:GetComponent(UILabel)
  itemSp.depth = self.richLabel.depth + 1
  label.depth = itemSp.depth
  self.richLabel.sprites:Add(itemSp)
  return itemSp, label
end

function SpriteLabel:CreateEquipInlineButton()
  local obj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("EquipInlineButton"), self.richLabel.gameObject)
  if not obj then
    LogUtility.Warning("Cannot create asset EquipInlineButton")
    return
  end
  local go = Game.GameObjectUtil:DeepFind(obj, "go")
  local picSp = obj:GetComponent(UISprite)
  local goSp = go:GetComponent(UISprite)
  picSp.depth = self.richLabel.depth + 1
  goSp.depth = self.richLabel.depth + 2
  self.richLabel.sprites:Add(picSp)
  return picSp
end

function SpriteLabel:CreateQuickCopyButton(context_str)
  local obj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("QuickCopyButton"), self.richLabel.gameObject)
  if not obj then
    LogUtility.Warning("Cannot create asset QuickCopyButton")
    return
  end
  local picSp = obj:GetComponent(UISprite)
  local obj2 = Game.GameObjectUtil:DeepFind(obj, "Icon")
  local picSp2 = obj2:GetComponent(UISprite)
  picSp.depth = self.richLabel.depth + 1
  picSp2.depth = self.richLabel.depth + 2
  self.richLabel.sprites:Add(picSp)
  local cpStr = context_str
  if context_str == "PLAYER_ID" then
    cpStr = Game.Myself.data.id
  end
  UIUtil.AddClickEvent(obj, function(go)
    local result = ApplicationInfo.CopyToSystemClipboard(cpStr)
    if result then
      MsgManager.ShowMsgByID(40580)
    end
  end)
  return picSp
end

function SpriteLabel:Reset()
  if SpriteLabel.useLuaVersion and self.richLabel and self.icons_info then
    for i = 1, #self.icons_info do
      self.icons_info[i] = nil
    end
  end
  if self.richLabel then
    self.richLabel.MinHeight = 2
    self.richLabel:Reset()
    self.richLabel:RemoveSprites()
    if BranchMgr.IsJapan() and self.richLabel and (not self.richLabel.useFloatSpacing or self.richLabel.floatSpacingY ~= 8) then
      self.richLabel.useFloatSpacing = true
      local sizeDeltaY = 8 - self.richLabel.effectiveSpacingY
      if 0 < sizeDeltaY and 2 > self.richLabel.overflowMethod then
        self.richLabel.height = self.richLabel.height + math.ceil(sizeDeltaY)
      end
      self.richLabel.floatSpacingY = 8
      self:Translate(nil, -4, nil)
    end
  end
end

function SpriteLabel:SetLabelColor(color)
  if type(color) == "string" then
    local succ, pColor = ColorUtil.TryParseHexString(color)
    color = succ and pColor
  end
  if type(color) ~= "table" then
    LogUtility.Warning("SpriteLabel: SetLabelColor failed.")
    return
  end
  self.richLabel.color = color
end

function SpriteLabel:TryForceSpritePixelPerfect(sp)
  if not sp or not spriteForcePixelPerfectMap[sp.spriteName] then
    return
  end
  sp:MakePixelPerfect()
  sp.width = math.floor(sp.width * self.iconScale)
  sp.height = math.floor(sp.height * self.iconScale)
end

function SpriteLabel:TryForceSpriteColor(sp)
  if not sp then
    return
  end
  local colorStr = not StringUtil.IsEmpty(self.iconColorHexStr) and self.iconColorHexStr or SpriteLabel.SpriteForceColorMap[sp.spriteName]
  if not colorStr then
    return
  end
  local succ, pColor = ColorUtil.TryParseHexString(colorStr)
  if succ then
    sp.color = pColor
  end
end

function SpriteLabel:SetLocalPos(x, y, z)
  self.richLabelTrans.localPosition = LuaGeometry.GetTempVector3(x or 0, y or 0, z or 0)
end

function SpriteLabel:Translate(dX, dY, dZ)
  local x, y, z = LuaGameObject.GetLocalPosition(self.richLabelTrans)
  if dX then
    x = x + dX
  end
  if dY then
    y = y + dY
  end
  if dZ then
    z = z + dZ
  end
  self:SetLocalPos(x, y, z)
end

function SpriteLabel:DoConstruct(asArray, data)
end

function SpriteLabel:DoDeconstruct(asArray)
  if self.richLabel and not Slua.IsNull(self.richLabel.gameObject) then
    self.richLabel.pivot = UIWidget.Pivot.Center
  end
  self:Reset()
  self.richLabel = nil
  self.richLabelTrans = nil
end

local charsize = function(ch)
  if not ch then
    return 0
  elseif 251 < ch then
    return 6
  elseif 247 < ch then
    return 5
  elseif 239 < ch then
    return 4
  elseif 223 < ch then
    return 3
  elseif 191 < ch then
    return 2
  else
    return 1
  end
end

function utf8len(str)
  local len = 0
  local aNum = 0
  local hNum = 0
  local currentIndex = 1
  while currentIndex <= #str do
    local char = string.byte(str, currentIndex)
    local cs = charsize(char)
    currentIndex = currentIndex + cs
    len = len + 1
    if cs == 1 then
      aNum = aNum + 1
    elseif 2 <= cs then
      hNum = hNum + 1
    end
  end
  return len, aNum, hNum
end

function utf8sub(str, startChar, numChars)
  local startIndex = 1
  while 1 < startChar do
    local char = string.byte(str, startIndex)
    startIndex = startIndex + charsize(char)
    startChar = startChar - 1
  end
  local currentIndex = startIndex
  while 0 < numChars and currentIndex <= #str do
    local char = string.byte(str, currentIndex)
    currentIndex = currentIndex + charsize(char)
    numChars = numChars - 1
  end
  return str:sub(startIndex, currentIndex - 1)
end

function SpriteLabel:SetRichLabelByLine(text, lineIdx, checkSpace)
  rllog("SetRichLabelByLine", text, self.richLabel.BASELINEWIDTH)
  local excludes = {}
  for m in text:gmatch(exclude_pattern) do
    table.insert(excludes, m)
  end
  if #excludes ~= 0 then
    text = text:gsub(exclude_pattern, exclude_placeholder)
    rllog("替换不需要处理的情况", text)
  end
  local bbcodes = {}
  if text:find("%[/c%]") or text:find("%[%-%]") then
    for m in text:gmatch(bbpattern) do
      table.insert(bbcodes, m)
    end
    if #bbcodes ~= 0 then
      text = text:gsub(bbpattern, bbplaceholder)
      rllog("替换 bbcode", text)
    end
  end
  if #excludes ~= 0 then
    for m in text:gmatch(exclude_placeholder) do
      local replacement = table.remove(excludes, 1)
      text = text:gsub(exclude_placeholder, replacement, 1)
    end
    rllog("恢复不需要处理的情况", text)
  end
  local icons = {}
  for m in text:gmatch(iconpattern) do
    table.insert(icons, m)
  end
  if #icons ~= 0 then
    text = text:gsub(iconpattern, iconplaceholder)
    rllog("替换 icon", text)
  end
  self.richLabel:UpdateNGUIText()
  NGUIText.finalSize = Mathf.RoundToInt(self.richLabel.defaultFontSize / NGUIText.pixelDensity)
  NGUIText.regionWidth = NGUIText.regionWidth + math.floor(self.richLabel.iconSize.x)
  local curText = ""
  local curChar = ""
  local res = ""
  local curWidth = 0
  local length = utf8len(text)
  local processIcon = -1
  for i = 1, length do
    curChar = utf8sub(text, i, 1)
    if i <= processIcon then
      curText = curText .. curChar
      if i == processIcon then
        local iconStr = table.remove(icons, 1)
        rllog(curText, NGUIText.CalculatePrintedSize(curText).x, self.iconWidth)
        local d = {}
        d.info = iconStr
        d.posX = NGUIText.CalculatePrintedSize(curText).x - self.iconWidth / 2
        d.posY = self.richLabelLines
        rllog("显示图片", iconStr, d.posX, d.posY)
        table.insert(self.icons_info, d)
      end
    else
      local breakWithinIcon = false
      if curChar == "\003" and i <= length then
        processIcon = i + utf8len(iconplaceholder) - 1
        local tmp = curText .. iconplaceholder
        if NGUIText.CalculatePrintedSize(tmp).x > self.richLabel.BASELINEWIDTH then
          rllog("在icon处换行", tmp, processIcon)
          breakWithinIcon = true
        end
      end
      curText = curText .. curChar
      curWidth = NGUIText.CalculatePrintedSize(curText).x
      if curWidth > self.richLabel.BASELINEWIDTH or breakWithinIcon then
        local curTextLen = utf8len(curText)
        local oneline = ""
        if checkSpace then
          local lastSpaceIndex = curTextLen
          for j = curTextLen, 1, -1 do
            if utf8sub(curText, j, 1) == " " then
              lastSpaceIndex = j
              break
            end
          end
          oneline = utf8sub(curText, 1, lastSpaceIndex - 1)
          if lastSpaceIndex ~= curTextLen and oneline ~= iconplaceholder and oneline ~= iconplaceholder .. " " and oneline ~= utf8sub(iconplaceholder, 1, utf8len(iconplaceholder) - 1) and not BranchMgr.IsKorea() then
            oneline = utf8sub(curText, 1, lastSpaceIndex - 1)
            res = res .. oneline .. "\n"
            rllog("空格换行", curText, oneline, lastSpaceIndex)
            curText = utf8sub(curText, lastSpaceIndex + 1, curTextLen - lastSpaceIndex)
          else
            rllog("空格换行但没找到空格", curText, curWidth)
            oneline = utf8sub(curText, 1, utf8len(curText) - 1)
            res = res .. oneline .. "\n"
            curText = curChar
          end
        else
          rllog("任意换行", curText, curWidth)
          oneline = utf8sub(curText, 1, utf8len(curText) - 1)
          res = res .. oneline .. "\n"
          curText = curChar
        end
        self.richLabelLines = self.richLabelLines + 1
        if #self.icons_info ~= 0 then
          for ii = 1, #self.icons_info do
            local tmp_info = self.icons_info[ii]
            if not tmp_info.lineWidth then
              tmp_info.lineWidth = NGUIText.CalculatePrintedSize(oneline).x
              tmp_info.posX = tmp_info.posX - tmp_info.lineWidth / 2
              rllog("有换行时显示图片", oneline, tmp_info.lineWidth)
            end
          end
        end
      end
    end
  end
  res = res .. curText
  if #self.icons_info ~= 0 then
    for ii = 1, #self.icons_info do
      local tmp_info = self.icons_info[ii]
      if not tmp_info.lineWidth then
        local lines = string.split(res, "\n")
        if #lines == 0 then
          table.insert(lines, text)
        end
        local oneline = lines[#lines]
        tmp_info.lineWidth = NGUIText.CalculatePrintedSize(oneline).x
        tmp_info.posX = tmp_info.posX - tmp_info.lineWidth / 2
        rllog("无换行时显示图片", oneline, tmp_info.lineWidth)
      end
    end
  end
  rllog("SetRichLabelByLine res", res)
  if #bbcodes ~= 0 then
    for m in res:gmatch(bbplaceholder) do
      local replacement = table.remove(bbcodes, 1)
      res = res:gsub(bbplaceholder, replacement, 1)
    end
    rllog("恢复 bbcode", res)
  end
  return res
end

function SpriteLabel:AddSprite2(data)
  local icon, itemData
  for str, id in string.gmatch(data.info, SpriteLabel.PatternMap.item) do
    icon, itemData = self:CreateSprite(), Table_Item[tonumber(id)]
    if itemData then
      if itemData.Type == 1200 then
        IconManager:SetFaceIcon(itemData.Icon, icon)
      else
        IconManager:SetItemIcon(itemData.Icon, icon)
      end
      self:TryForceSpritePixelPerfect(icon)
      self:SetSpritePos2(icon, data)
      self:TryForceSpriteColor(icon)
    else
      printRed("Cannot Find Item" .. id)
    end
  end
  for str, name in string.gmatch(data.info, SpriteLabel.PatternMap.ui) do
    icon = self:CreateSprite()
    IconManager:SetUIIcon(name, icon)
    self:TryForceSpritePixelPerfect(icon)
    self:SetSpritePos2(icon, data)
    self:TryForceSpriteColor(icon)
  end
  for str, name in string.gmatch(data.info, SpriteLabel.PatternMap.map) do
    icon = self:CreateSprite()
    if not IconManager:SetMapIcon(name, icon) then
      IconManager:SetEffectIcon(name, icon)
    end
    self:TryForceSpritePixelPerfect(icon)
    self:SetSpritePos2(icon, data)
    self:TryForceSpriteColor(icon)
  end
  for optsStr, iconName in string.gmatch(data.info, SpriteLabel.PatternMap.magic) do
    icon = self:CreateSprite()
    IconManager:SetUIIcon(iconName, icon)
    icon.keepAspectRatio = 0
    icon:MakePixelPerfect()
    icon.keepAspectRatio = 2
    icon.height = self.iconHeight
    self:SetSpritePos2(icon, data)
    if optsStr and optsStr ~= "" then
      self:ApplySpriteOptions(icon, optsStr)
    end
  end
  for str, name in string.gmatch(data.info, SpriteLabel.PatternMap.buff) do
    icon = self:CreateSprite()
    IconManager:SetSkillIconByProfess(name, icon, MyselfProxy.Instance:GetMyProfessionType())
    self:TryForceSpritePixelPerfect(icon)
    self:SetSpritePos2(icon, data)
    self:TryForceSpriteColor(icon)
  end
  for _, str in string.gmatch(data.info, SpriteLabel.PatternMap.equipupgrade) do
    local indicatorSp, indicatorLabel = self:CreateEquipUpgradeIndicator()
    if indicatorSp then
      self:SetSpritePos2(indicatorSp, data)
      local level = tonumber(str)
      if level then
        indicatorSp.color = 0 < level and activeEquipUpgradeColor or inactiveEquipUpgradeColor
        indicatorLabel.text = StringUtil.IntToRoman(math.abs(level))
      elseif string.lower(str) == "end" then
        indicatorSp.color = inactiveEquipUpgradeColor
        indicatorLabel.text = "End"
      end
    end
  end
  for _, str in string.gmatch(data.info, SpriteLabel.PatternMap.equipcard) do
    local indicatorBg, indicatorSp = self:CreateEquipCardIndicator()
    if indicatorBg then
      self:SetSpritePos2(indicatorBg, data)
      local number = tonumber(str)
      if number == 0 then
        indicatorSp.spriteName = "new-com_icon_card_5"
      elseif number and 0 < number and number < 5 then
        indicatorSp.spriteName = "new-com_icon_card_" .. number
      else
        indicatorSp.spriteName = "new-com_icon_card_6"
      end
    end
  end
  for _, str in string.gmatch(data.info, SpriteLabel.PatternMap.price) do
    local indicatorSp, indicatorLabel = self:CreatePriceIndicator()
    if indicatorSp then
      self:SetSpritePos2(indicatorSp, data)
      local arr = string.split(str, ",")
      if arr and 1 < #arr then
        local itemId, price = tonumber(arr[1]), tonumber(arr[2])
        if itemId and Table_Item[itemId] and price and -1 < price then
          IconManager:SetItemIcon(Table_Item[itemId].Icon, indicatorSp)
          indicatorLabel.text = StringUtil.NumThousandFormat(price)
        end
      end
    end
  end
  local classData
  for str, id in string.gmatch(data.info, SpriteLabel.PatternMap.profession) do
    icon, classData = self:CreateSprite(), Table_Class[tonumber(id)]
    if classData then
      IconManager:SetProfessionIcon(classData.icon, icon)
      self:TryForceSpritePixelPerfect(icon)
      self:SetSpritePos2(icon, data)
      self:TryForceSpriteColor(icon)
    else
      redlog("Cannot Find Class" .. id)
    end
  end
  for str, iconstr in string.gmatch(data.info, SpriteLabel.PatternMap.lottery) do
    icon = self:CreateSprite()
    local atlas = RO.AtlasMap.GetAtlas("UI_Lottery")
    icon.atlas = atlas
    icon.spriteName = iconstr
    icon.transform.localPosition = LuaGeometry.GetTempVector3(data.posX, 0 - self.halfHeight, 0)
  end
  for str, iconstr in string.gmatch(data.info, SpriteLabel.PatternMap.nature) do
    icon = self:CreateSprite()
    IconManager:SetUIIcon(iconstr, icon)
    self:SetSpritePos2(icon, data.pos, data.lineWidth)
  end
  for _, str in string.gmatch(data.info, SpriteLabel.PatternMap.inlinebutton) do
    icon = self:CreateEquipInlineButton()
    local pos
    local buttonCfg = string.split(str, ",")
    if #buttonCfg == 2 then
      if not self.inlineBtns then
        self.inlineBtns = {}
      end
      self.inlineBtns[buttonCfg[2]] = icon
    end
    IconManager:SetUIIcon(buttonCfg[1], icon)
    if buttonCfg[2] == "k_quench" then
      ColorUtil.WhiteUIWidget(icon)
    end
    self:SetSpritePos2(icon, data, data.lineWidth)
  end
  for _, str in string.gmatch(data.info, SpriteLabel.PatternMap.quickcopy) do
    icon = self:CreateQuickCopyButton(str)
    self:SetSpritePos2(icon, data, data.lineWidth)
  end
  for _, str in string.gmatch(data.info, SpriteLabel.PatternMap.communityicon) do
    icon = self:CreateSprite()
    local atlas = RO.AtlasMap.GetAtlas("NewUI10")
    icon.atlas = atlas
    icon.spriteName = str
    self:TryForceSpritePixelPerfect(icon)
    self:SetSpritePos2(icon, data, data.lineWidth)
  end
end

function SpriteLabel:ApplySpriteOptions(icon, optionStr)
  if not optionStr then
    return
  end
  for k, v in string.gmatch(optionStr, spriteOptPattern) do
    if k == "c" then
      local succ, pColor = ColorUtil.TryParseHexString(v)
      if succ then
        icon.color = pColor
      end
    end
  end
end

function SpriteLabel:SetSpritePos2(sp, iconinfo)
  if not sp then
    return
  end
  rllog("SetSpritePos2", self.halfHeight, iconinfo.lineWidth, self.labelPivot)
  rllog("SetSpritePos2_Pos", iconinfo.posX, iconinfo.posY)
  if self.iconCenterInLine then
    iconinfo.posY = -self.richLabel:GetSpLineTotalHeight(math.floor(iconinfo.posY)) - (self.fontSize + sp.height) / 2
    rllog("iconCenterInLine pos.y", iconinfo.posY)
  else
    iconinfo.posY = -self.richLabel:GetSpLineTotalHeight(math.floor(iconinfo.posY)) - self.fontSize
    rllog("not iconCenterInLine pos.y", iconinfo.posY)
  end
  if self.labelPivot.y == 0.5 then
    iconinfo.posY = iconinfo.posY + self.halfHeight
    rllog("居中 pos.y", iconinfo.posY)
  end
  if self.labelPivot.x == 0 then
    iconinfo.posX = iconinfo.posX + iconinfo.lineWidth / 2
    rllog("左对齐 pos.x", iconinfo.posX)
  end
  sp.transform.localPosition = LuaGeometry.GetTempVector3(iconinfo.posX, iconinfo.posY, 0)
end

function SpriteLabel:InitSettings()
  self.labelPivot = self.richLabel.pivotOffset
  self.fontSize = self.richLabel.defaultFontSize
  self.paddingY = self.richLabel.effectiveSpacingY
end

function SpriteLabel:SetRichLabel(text, checkSpace)
  if not text then
    return ""
  end
  self:InitSettings()
  self.richLabelLines = 0
  self.richLabel:Reset()
  self.icons_info = {}
  local lines = string.split(text, "\n")
  if #lines == 0 then
    table.insert(lines, text)
  end
  local sb = LuaStringBuilder.CreateAsTable()
  for i = 1, #lines do
    sb:Append(self:SetRichLabelByLine(lines[i], self.richLabelLines, checkSpace))
    if i ~= #lines then
      sb:Append("\n")
    end
    self.richLabelLines = self.richLabelLines + 1
  end
  local res = sb:ToString()
  sb:Destroy()
  return res
end

function SpriteLabel:CheckSpace()
  if AppBundleConfig.GetSDKLang() == "cn" or AppBundleConfig.GetSDKLang() == "jp" then
    return false
  end
  return true
end

function SpriteLabel:SetSpriteColor(spIndex, color)
  if not spIndex or not color then
    return
  end
  if self.richLabel.sprites then
    local sprites = self.richLabel.sprites
    if sprites[spIndex] then
      sprites[spIndex].color = color
    end
  end
end

function SpriteLabel:GetSprite(spIndex)
  if not spIndex then
    return
  end
  if self.richLabel.sprites then
    local sprites = self.richLabel.sprites
    if sprites[spIndex] then
      return sprites[spIndex]
    end
  end
end

function SpriteLabel:ForEachSprite(action, ...)
  if not action then
    return
  end
  local sprites = self.richLabel.sprites
  if sprites then
    local count = sprites.Count
    for i = 0, count - 1 do
      action(sprites[i], ...)
    end
  end
end
