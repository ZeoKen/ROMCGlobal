autoImport("PushBaseCell")
QuestUpdateCell = class("QuestUpdateCell", PushBaseCell)
QuestUpdateCell.resID = ResourcePathHelper.UICell("QuestUpdateCell")

function QuestUpdateCell:ctor(parent)
  self.speed = 300
  self.previous = nil
  self.follow = nil
  self.floating = false
  self.targetY = 0
  self.gameObject = self:CreateObj(parent)
  self:Init()
end

function QuestUpdateCell:Init()
  self:FindObjs()
end

function QuestUpdateCell:FindObjs()
  self.nameLabel = self:FindGO("Label"):GetComponent(UILabel)
  self.titleIcon = self:FindGO("Icon"):GetComponent(UISprite)
end

function QuestUpdateCell:SetData(data)
  self.questData = data
  self.nameLabel.text = self.questData.traceTitle or "???"
  local specialIcon = self.questData.staticData.headIcon
  self:ShowTaskIcon()
end

function QuestUpdateCell:ShowTaskIcon()
  if not GameConfig.Quest.TraceIcon then
    return
  end
  local config = GameConfig.Quest.TraceIcon
  local IconFromServer = self.questData.staticData.IconFromServer
  local specialIcon = self.questData.staticData.headIcon
  local iconIndex
  if config[specialIcon] then
    iconIndex = specialIcon
  elseif config[IconFromServer] then
    iconIndex = IconFromServer
  else
    return
  end
  local spriteNameStr = config[iconIndex][1]
  local atlasStr = config[iconIndex][2]
  local iconScale = config[iconIndex][3]
  local needMakePixelPerfect = config[iconIndex][4]
  if atlasStr and spriteNameStr then
    if IconManager:SetIconByType(spriteNameStr, self.titleIcon, atlasStr) then
      if needMakePixelPerfect then
        self.titleIcon:MakePixelPerfect()
      end
      if iconScale then
        self.titleIcon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(iconScale, iconScale, iconScale)
      elseif GameConfig and GameConfig.Quest and GameConfig.Quest.TitleIconScale then
        self.titleIcon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(GameConfig.Quest.TitleIconScale, GameConfig.Quest.TitleIconScale, GameConfig.Quest.TitleIconScale)
      end
      return
    end
    local uiAtlas = RO.AtlasMap.GetAtlas(atlasStr)
    if not uiAtlas then
      return
    end
    self.titleIcon.atlas = uiAtlas
    self.titleIcon.spriteName = spriteNameStr
    if needMakePixelPerfect then
      self.titleIcon:MakePixelPerfect()
    end
    if iconScale then
      self.titleIcon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(iconScale, iconScale, iconScale)
    elseif GameConfig and GameConfig.Quest and GameConfig.Quest.TitleIconScale then
      self.titleIcon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(GameConfig.Quest.TitleIconScale, GameConfig.Quest.TitleIconScale, GameConfig.Quest.TitleIconScale)
    end
    return
  end
end

function QuestUpdateCell:CreateObj(parent)
  return Game.AssetManager_UI:CreateAsset(QuestUpdateCell.resID, parent)
end

function QuestUpdateCell:Destroy()
  self.data = nil
  if self.spriteLabel then
    self.spriteLabel:Destroy()
    self.spriteLabel = nil
  end
  Game.GOLuaPoolManager:AddToUIPool(QuestUpdateCell.resID, self.gameObject)
end

function QuestUpdateCell:SetY(y)
  local pos = self.gameObject.transform.localPosition
  pos.y = y
  self.gameObject.transform.localPosition = pos
end

function QuestUpdateCell:GetY()
  local x, y, z = LuaGameObject.GetLocalPosition(self.gameObject.transform)
  return y
end

function QuestUpdateCell:GetH()
  return 55
end

function QuestUpdateCell:Parsed()
  return self.data == nil or self.data.parsed == true
end

function QuestUpdateCell:NextToPush()
  self.data.parsed = true
  if self.data.params ~= nil and type(self.data.params) == "table" then
    self.data.text = MsgParserProxy.Instance:TryParse(self.data.text, unpack(self.data.params))
  else
    self.data.text = MsgParserProxy.Instance:TryParse(self.data.text, self.data.params)
  end
  self:SetMsg(self.data.text)
end
