local baseCell = autoImport("BaseCell")
QuestTraceSubCell = class("QuestTraceSubCell", baseCell)

function QuestTraceSubCell:Init()
  QuestTraceSubCell.super.Init(self)
  self:FindObjs()
end

function QuestTraceSubCell:FindObjs()
  self.titleIcon = self:FindGO("TraceIcon"):GetComponent(UISprite)
  self.title = self:FindGO("TitleLabel"):GetComponent(UILabel)
  self.gotoBtn = self:FindGO("GoToBtn")
  self.finishSymbol = self:FindGO("FinishSymbol")
  self.gotoBtn:SetActive(false)
  self.finishSymbol:SetActive(false)
  self:AddClickEvent(self.gotoBtn, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function QuestTraceSubCell:SetData(data)
  self.data = data.questData
  self.status = data.questType
  self.title.text = self.data.traceTitle or ""
  self:SetQuestIcon()
  if self.status == 1 then
    local questid = self.data.id
    self.gotoBtn:SetActive(true)
    self.finishSymbol:SetActive(false)
  else
    self.gotoBtn:SetActive(false)
    self.finishSymbol:SetActive(true)
  end
end

function QuestTraceSubCell:SetQuestIcon()
  if not self.data then
    return
  end
  local colorFromServer = self.data.staticData and self.data.staticData.ColorFromServer
  local specialIcon = self.data.staticData and self.data.staticData.headIcon
  colorFromServer = specialIcon ~= 0 and GameConfig.Quest.TraceIcon[specialIcon] and specialIcon or colorFromServer
  if colorFromServer and GameConfig.Quest.TraceIcon[colorFromServer] then
    local atlasStr = GameConfig.Quest.TraceIcon[colorFromServer][2]
    local spriteNameStr = GameConfig.Quest.TraceIcon[colorFromServer][1]
    local iconScale = GameConfig.Quest.TraceIcon[colorFromServer][3]
    local needMakePixelPerfect = GameConfig.Quest.TraceIcon[colorFromServer][4]
    if atlasStr and spriteNameStr then
      if IconManager:SetIconByType(spriteNameStr, self.titleIcon, atlasStr) then
        self.titleIcon.gameObject:SetActive(true)
        if needMakePixelPerfect then
          self.titleIcon:MakePixelPerfect()
        end
        if iconScale then
          self.titleIcon.gameObject.transform.localScale = Vector3(iconScale, iconScale, iconScale)
        elseif GameConfig and GameConfig.Quest and GameConfig.Quest.TitleIconScale then
          self.titleIcon.gameObject.transform.localScale = Vector3(GameConfig.Quest.TitleIconScale, GameConfig.Quest.TitleIconScale, GameConfig.Quest.TitleIconScale)
        end
        return
      end
      local ui1Atlas = RO.AtlasMap.GetAtlas(atlasStr)
      if ui1Atlas == nil then
        redlog("没有图集！" .. atlasStr)
        self.titleIcon.gameObject:SetActive(false)
        return
      end
      self.titleIcon.atlas = ui1Atlas
      self.titleIcon.spriteName = spriteNameStr
      self.titleIcon.gameObject:SetActive(true)
      if needMakePixelPerfect then
        self.titleIcon:MakePixelPerfect()
      end
      if iconScale then
        self.titleIcon.gameObject.transform.localScale = Vector3(iconScale, iconScale, iconScale)
      elseif GameConfig and GameConfig.Quest and GameConfig.Quest.TitleIconScale then
        self.titleIcon.gameObject.transform.localScale = Vector3(GameConfig.Quest.TitleIconScale, GameConfig.Quest.TitleIconScale, GameConfig.Quest.TitleIconScale)
      end
      return
    end
  else
    self.titleIcon.gameObject:SetActive(false)
  end
end
