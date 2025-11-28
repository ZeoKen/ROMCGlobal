local baseCell = autoImport("BaseCell")
QuestTraceBaseTogCell = class("QuestTraceBaseTogCell", baseCell)

function QuestTraceBaseTogCell:Init()
  QuestTraceBaseTogCell.super.Init(self)
  self:FindObjs()
  self:AddCellClickEvent()
end

function QuestTraceBaseTogCell:FindObjs()
  self.titleIcon = self:FindGO("TitleIcon"):GetComponent(UISprite)
  self.title = self:FindGO("Title"):GetComponent(UILabel)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.toggle = self:FindGO("Toggle"):GetComponent(UIToggle)
  self.toggleGO = self.toggle.gameObject
  self:AddClickEvent(self.toggleGO, function()
    local limit = QuestProxy.Instance:CheckTraceLimit(self.toggle.value)
    if limit then
      MsgManager.ShowMsgByID(298)
      self.toggle.value = false
      return
    end
    self:PassEvent(QuestEvent.QuestTraceChange, self)
  end)
  self.newSymbol = self:FindGO("NewSymbol")
  self.newSymbol:SetActive(false)
  local root = self:FindGO("Root")
  self.tweenPos = root:GetComponent(TweenPosition)
  self.tweenAlpha = root:GetComponent(TweenAlpha)
end

function QuestTraceBaseTogCell:SetData(data)
  self.questList = nil
  self.curChoose = nil
  self.isCombined = false
  local isNew = false
  if data.isCombined and data.groupid then
    self.isCombined = data.isCombined
    self.questList = data.questList
    self.data = self.questList[1]
    self.curChoose = self.questList[1]
    local curTraceQuest = data.curTraceQuest or nil
    if curTraceQuest then
      for i = 1, #self.questList do
        if self.questList[i].id == curTraceQuest and not self.questList[i].isFinish then
          self.curChoose = self.questList[i]
          break
        end
        for j = 1, #self.questList do
          if not self.questList[j].isFinish then
            self.curChoose = self.questList[j]
            break
          end
        end
      end
    end
    for i = 1, #self.questList do
      if self.questList[i].newstatus == 1 then
        isNew = true
        break
      end
    end
  else
    self.isCombined = data.isCombined or false
    self.data = data
    isNew = data.newstatus == 1 and true or false
  end
  self.title.text = self.data.traceTitle or "???"
  local tarMap = self.data.map
  tarMap = tarMap or Game.MapManager:GetMapID()
  local mapData = Table_Map[tarMap]
  if not mapData then
    redlog("任务缺少地图配置", tarMap, self.data.id)
    self.mapLabel.text = "地图不存在请检查"
  else
    self.mapLabel.text = mapData.CallZh
  end
  local curWorldQuestGroup = Game.MapManager:getCurWorldQuestGroup()
  local isCurWorldGroupAllFinish = Game.MapManager:GetWorldQuestProcessAllFinish(curWorldQuestGroup)
  local status = QuestProxy.Instance:CheckQuestIsTrace(self.data.id)
  local isTrace = false
  if curWorldQuestGroup and not isCurWorldGroupAllFinish then
    if status and status == 3 then
      local version = Table_WorldQuest[self.data.id] and Table_WorldQuest[self.data.id].Version
      if version == curWorldQuestGroup then
        isTrace = true
      end
    elseif status and status == 1 then
      isTrace = true
    end
  elseif status and status == 1 then
    isTrace = true
  else
    isTrace = false
  end
  self.toggle.value = isTrace
  self:SetQuestIcon()
  self:SetChooseStatus(false)
  self.newSymbol:SetActive(isNew)
  TimeTickManager.Me():ClearTick(self, 1)
  self.tweenPos:ResetToBeginning()
  self.tweenPos.enabled = false
  self.tweenAlpha:ResetToBeginning()
  self.tweenAlpha.enabled = false
end

function QuestTraceBaseTogCell:SetChooseStatus(bool)
  if self.chooseSymbol then
    self.chooseSymbol:SetActive(bool)
  else
    redlog("no chooseSymbol")
  end
end

function QuestTraceBaseTogCell:SetQuestIcon()
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

function QuestTraceBaseTogCell:SwitchTracedQuestInCombinedGroup()
  for i = 1, #self.questList do
    if self.curChoose.id == self.questList[i].id then
      for j = i, #self.questList do
        if self.questList[j + 1] and not self.questList[j + 1].isFinish then
          self.curChoose = self.questList[j + 1]
          self.data = self.curChoose
          self.title.text = self.curChoose.traceTitle
          return
        end
      end
      for k = 1, #self.questList do
        if not self.questList[k].isFinish and self.questList[k].id ~= self.curChoose.id then
          self.curChoose = self.questList[k]
          break
        end
      end
      self.data = self.curChoose
      self.title.text = self.curChoose.traceTitle
      break
    end
  end
end

function QuestTraceBaseTogCell:SetNewSymbol(bool)
  self.newSymbol:SetActive(bool)
end

function QuestTraceBaseTogCell:PlayTween()
  if self.indexInList >= 6 then
    self.tweenPos.enabled = false
    self.tweenAlpha.enabled = false
    self.tweenPos:PlayForward()
    self.tweenAlpha:PlayForward()
    return
  end
  self.tweenPos.delay = 0.1 * self.indexInList
  self.tweenPos.enabled = false
  self.tweenPos:ResetToBeginning()
  self.tweenPos:PlayForward()
  self.tweenAlpha.delay = 0.1 * self.indexInList
  self.tweenAlpha.enabled = false
  self.tweenAlpha:ResetToBeginning()
  self.tweenAlpha:PlayForward()
end

function QuestTraceBaseTogCell:PlayReverse()
  self.tweenPos:ResetToBeginning()
  self.tweenAlpha:ResetToBeginning()
end

function QuestTraceBaseTogCell:OnCellDestroy()
  QuestTraceBaseTogCell.super.OnCellDestroy(self)
  TimeTickManager.Me():ClearTick(self)
end
