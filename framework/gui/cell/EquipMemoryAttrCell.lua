EquipMemoryAttrCell = class("EquipMemoryAttrCell", BaseCell)

function EquipMemoryAttrCell:Init()
  self.attrName = self:FindComponent("AttrName", UILabel)
  self.attrValue = self:FindComponent("AttrValue", UILabel)
  self.chooseSymbol = self:FindGO("ChooseSymbol"):GetComponent(UISprite)
  self.chooseSymbolBg = self:FindGO("ChooseSymbolBg")
  if self.chooseSymbolBg then
    self.chooseSymbolBg = self.chooseSymbolBg:GetComponent(UISprite)
  end
  self.colorSymbol = self:FindGO("ColorSymbol"):GetComponent(UISprite)
  self.bg = self.gameObject:GetComponent(UISprite)
  self:AddClickEvent(self.bg.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self.sizeContainer = self:FindGO("Container"):GetComponent(UIWidget)
  self.lockSymbol = self:FindGO("LockSymbol")
  self:AddCellClickEvent()
end

function EquipMemoryAttrCell:SetData(data)
  self.data = data
  local level = 1
  self.attrValue.text = level
  local attrId = data.id
  local attrConfig = Game.ItemMemoryEffect[attrId]
  if attrConfig then
    local descStr = ""
    local staticId = attrConfig.level and attrConfig.level[level]
    local staticData = staticId and Table_ItemMemoryEffect[staticId]
    if staticData then
      local targetStage = self.data and self.data.excess_lv or 0
      local buffId
      local buffIds = staticData.BuffID
      if type(buffIds) == "table" then
        if not buffIds[0] and 0 < #buffIds then
          buffId = buffIds[1]
        else
          local maxKey
          for k, _ in pairs(buffIds) do
            if type(k) == "number" and k <= targetStage and (not maxKey or k > maxKey) then
              maxKey = k
            end
          end
          local targetBuffId = maxKey ~= nil and buffIds[maxKey] or buffIds[0] or buffIds[1]
          if type(targetBuffId) == "table" then
            buffId = next(targetBuffId) and targetBuffId[next(targetBuffId)]
          else
            buffId = targetBuffId
          end
        end
      end
      local buffData = buffId and Table_Buffer[buffId]
      local dsc = buffData and buffData.Dsc and OverSea.LangManager.Instance():GetLangByKey(buffData.Dsc)
      if type(dsc) == "string" then
        dsc = string.gsub(dsc, "%[AttrValue%]", "")
      end
      descStr = dsc or staticData and staticData.WaxDesc or ""
    end
    self.attrName.text = descStr
    local color = attrConfig.Color or "attack"
    local _iconName = GameConfig.EquipMemory.AttrTypeIcon and GameConfig.EquipMemory.AttrTypeIcon[color].Icon
    self.colorSymbol.spriteName = _iconName
    local height = self.attrName.printedSize.y
    self.bg.height = height + 8
    self.chooseSymbol.height = height + 18
    self.sizeContainer.height = height + 18
    self.lockSymbol:SetActive(false)
    self.colorSymbol.gameObject:SetActive(true)
    self.colorSymbol:MakePixelPerfect()
  else
    if data.unlockLv then
      local formatStr = data.unlockTip or ZhString.EquipMemory_AttrResetUnlockTip
      self.attrName.text = string.format(formatStr, data.unlockLv)
    else
      self.attrName.text = data.text or ""
    end
    self.bg.height = 30
    self.chooseSymbol.height = 40
    self.sizeContainer.height = 40
    self.lockSymbol:SetActive(true)
    self.colorSymbol.gameObject:SetActive(false)
  end
  if self.chooseSymbolBg then
    self.chooseSymbolBg:ResetAndUpdateAnchors()
  end
end

function EquipMemoryAttrCell:SetChoose(bool)
  self.chooseSymbol.gameObject:SetActive(bool)
end

function EquipMemoryAttrCell:SetEnable(bool)
  self.bg.alpha = bool and 1 or 0.6
end

EquipMemoryAttrCellType2 = class("EquipMemoryAttrCellType2", EquipMemoryAttrCell)

function EquipMemoryAttrCellType2:SetData(data)
  self.data = data
  local level = 1
  self.attrValue.text = level
  local attrId = data.id
  local attrConfig = Game.ItemMemoryEffect[attrId]
  if attrConfig then
    local descStr = ""
    local staticId = attrConfig.level and attrConfig.level[level]
    local staticData = staticId and Table_ItemMemoryEffect[staticId]
    if staticData then
      local targetStage = self.data and self.data.excess_lv or 0
      local buffId
      local buffIds = staticData.BuffID
      if type(buffIds) == "table" then
        if not buffIds[0] and 0 < #buffIds then
          buffId = buffIds[1]
        else
          local maxKey
          for k, _ in pairs(buffIds) do
            if type(k) == "number" and k <= targetStage and (not maxKey or k > maxKey) then
              maxKey = k
            end
          end
          local targetBuffId = maxKey ~= nil and buffIds[maxKey] or buffIds[0] or buffIds[1]
          if type(targetBuffId) == "table" then
            buffId = next(targetBuffId) and targetBuffId[next(targetBuffId)]
          else
            buffId = targetBuffId
          end
        end
      end
      local buffData = buffId and Table_Buffer[buffId]
      local dsc = buffData and buffData.Dsc and OverSea.LangManager.Instance():GetLangByKey(buffData.Dsc)
      if type(dsc) == "string" then
        dsc = string.gsub(dsc, "%[AttrValue%]", "")
      end
      descStr = dsc or staticData and staticData.WaxDesc or ""
    end
    self.attrName.text = descStr
    local color = attrConfig.Color or "red"
    local _iconName = GameConfig.EquipMemory.AttrTypeIcon and GameConfig.EquipMemory.AttrTypeIcon[color].Icon
    self.colorSymbol.spriteName = _iconName .. "s"
    local height = self.attrName.printedSize.y
    self.bg.height = height + 20
    self.chooseSymbol.height = height + 25
    self.lockSymbol:SetActive(false)
    self.colorSymbol.gameObject:SetActive(true)
    self.colorSymbol:MakePixelPerfect()
  else
    local formatStr = data.unlockTip or ZhString.EquipMemory_AttrResetUnlockTip
    self.attrName.text = string.format(formatStr, data.unlockLv)
    self.bg.height = 46
    self.chooseSymbol.height = 51
    self.lockSymbol:SetActive(true)
    self.colorSymbol.gameObject:SetActive(false)
  end
  if self.chooseSymbolBg then
    self.chooseSymbolBg:UpdateAnchors()
  end
end

EquipMemoryAttrCellType3 = class("EquipMemoryAttrCellType3", EquipMemoryAttrCell)

function EquipMemoryAttrCellType3:SetData(data)
  self.data = data
  local level = data.level or 1
  self.attrValue.text = level
  local attrId = data.id
  local descStr = ""
  local attrInfoAgg
  if self.data and self.data.stages then
    attrInfoAgg = ItemUtil.BuildMemoryEffectAggregate(attrId, self.data.stages)
  end
  local attrInfo = attrInfoAgg or ItemUtil.GetMemoryEffectInfo(attrId, self.data and self.data.excess_lv)
  if attrInfo then
    local _formatStr = attrInfo[1] and attrInfo[1].FormatStr or attrInfo.FormatStr
    local _valueList = attrInfo[1] and attrInfo[1].AttrValue or attrInfo.AttrValue
    local isAggregate = attrInfoAgg ~= nil
    local multiplier = isAggregate and 1 or level or 1
    if _formatStr and _valueList then
      for m in _formatStr:gmatch("[AttrValue]") do
        local _replaceValue = table.remove(_valueList, 1)
        if _replaceValue then
          local numVal = tonumber(_replaceValue) or 0
          _formatStr = _formatStr:gsub("%[.-]", numVal * multiplier, 1)
        end
      end
      descStr = descStr .. _formatStr
    end
  else
    redlog("no effect info")
  end
  local attrConfig = Game.ItemMemoryEffect[attrId]
  if attrConfig then
    if 3 < level then
      level = 3
    end
    local staticId = attrConfig.level and attrConfig.level[level]
    local staticData = staticId and Table_ItemMemoryEffect[staticId]
    if staticData then
      local waxBuffId = staticData.WaxBuffID
      if waxBuffId and 0 < #waxBuffId then
        for i = 1, #waxBuffId do
          local buffData = Table_Buffer[waxBuffId[i]]
          if buffData and buffData.BuffEffect and not buffData.BuffEffect.NoShow then
            local dsc = buffData and buffData.Dsc
            if dsc and dsc ~= "" then
              if descStr ~= "" then
                descStr = descStr .. "\n"
              end
              descStr = descStr .. dsc
            end
          end
        end
      end
    end
    local color = attrConfig.Color or "red"
    local _iconName = GameConfig.EquipMemory.AttrTypeIcon and GameConfig.EquipMemory.AttrTypeIcon[color].Icon
    self.colorSymbol.spriteName = _iconName .. "s"
    self.colorSymbol:MakePixelPerfect()
  end
  if descStr ~= "" then
    self.attrName.text = descStr
  end
  local height = self.attrName.printedSize.y
  self.bg.height = height + 30
  if self.chooseSymbolBg then
    self.chooseSymbolBg:UpdateAnchors()
  end
end

EquipMemoryAttrCellType5 = class("EquipMemoryAttrCellType5", EquipMemoryAttrCell)

function EquipMemoryAttrCellType5:Init()
  EquipMemoryAttrCellType5.super.Init(self)
  self.waxName = self:FindComponent("WaxName", UILabel)
end

function EquipMemoryAttrCellType5:SetData(data)
  self.data = data
  local level = data.level or 1
  self.attrValue.text = level
  local attrId = data.id
  local descStr = ""
  local attrConfig = Game.ItemMemoryEffect[attrId]
  if attrConfig then
    if 3 < level then
      level = 3
    end
    local staticId = attrConfig.level and attrConfig.level[level]
    local staticData = staticId and Table_ItemMemoryEffect[staticId]
    if staticData then
      local waxBuffId = staticData.WaxBuffID
      if waxBuffId and 0 < #waxBuffId then
        self.waxName.text = OverSea.LangManager.Instance():GetLangByKey(staticData.PreviewDesc) .. string.format("(%d/%d)", level, 3)
        for i = 1, #waxBuffId do
          local buffData = Table_Buffer[waxBuffId[i]]
          if buffData and buffData.BuffEffect and not buffData.BuffEffect.NoShow then
            local dsc = buffData and buffData.Dsc
            if dsc and dsc ~= "" then
              if descStr ~= "" then
                descStr = descStr .. "\n"
              end
              descStr = descStr .. dsc
            end
          end
        end
      end
    end
    local color = attrConfig.Color or "red"
    local _iconName = GameConfig.EquipMemory.AttrTypeIcon and GameConfig.EquipMemory.AttrTypeIcon[color].Icon
    self.colorSymbol.spriteName = _iconName .. "s"
    self.colorSymbol:MakePixelPerfect()
  end
  if descStr ~= "" then
    self.attrName.text = descStr
  end
  local height = self.attrName.printedSize.y
  self.bg.height = height + 60
  if self.chooseSymbolBg then
    self.chooseSymbolBg:UpdateAnchors()
  end
end
