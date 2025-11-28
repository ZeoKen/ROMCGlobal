autoImport("QuestTraceBaseCombineCell")
QuestTraceCombineCell = class("QuestTraceCombineCell", QuestTraceBaseCombineCell)
autoImport("QuestTraceTogCell")
autoImport("QuestTraceRewardCell")

function QuestTraceCombineCell:Init()
  QuestTraceCombineCell.super.Init(self)
  self.gameObject:SetActive(true)
  self.processPart = self:FindGO("ProcessPart", self.fatherObj)
  self.processCell = {}
  for i = 1, 4 do
    self.processCell[i] = {}
    local go = self:FindGO("Process" .. i, self.processPart)
    self.processCell[i].mark = self:FindGO("Mark", go)
  end
  self.rewardStatus = self:FindGO("RewardStatus", self.processPart):GetComponent(UIMultiSprite)
  self.rewardLight = self:FindGO("RewardLight")
  self.rewardLight:SetActive(false)
  self.finishSymbol = self:FindGO("FinishSymbol", self.processPart)
  self.finishSymbol:SetActive(false)
  self.rewardGrid = self:FindGO("RewardGrid"):GetComponent(UIGrid)
  self.rewardCtrl = UIGridListCtrl.new(self.rewardGrid, QuestTraceRewardCell, "QuestTraceRewardCell")
  self.childCtl = UIGridListCtrl.new(self.ChildGoals_UIGrid, QuestTraceTogCell, "QuestTraceTogCell")
  self.childCtl:AddEventListener(MouseEvent.MouseClick, self.ClickChild, self)
  self.childCtl:AddEventListener(QuestEvent.QuestTraceChange, self.HandleTraceUpdate, self)
  self.tweenScale:SetOnFinished(function()
    self:OnTweenScaleOnFinished()
  end)
  self.folderState = true
end

function QuestTraceCombineCell:ClickFather(cellCtrl)
  self.folderState = not self.folderState
  self:SetFolderState(self.folderState)
  self:PassEvent(MouseEvent.MouseClick, {
    type = "Father",
    combine = self,
    index = self.indexInList
  })
  self:RefreshArrow()
  self.arrowBG_TweenScale:ResetToBeginning()
  self.arrowBG_TweenScale:PlayForward()
end

function QuestTraceCombineCell:RefreshArrow()
  self.arrow.gameObject.transform.localPosition = self.folderState and LuaGeometry.GetTempVector3(0, -20, 0) or LuaGeometry.GetTempVector3(0, -11, 0)
  self.arrow.flip = self.folderState and 2 or 0
end

function QuestTraceCombineCell:ClickChild(cellCtrl)
  if cellCtrl ~= self.nowChild then
    cellCtrl:SetChooseStatus(true)
    self.nowChild = cellCtrl
  end
  self:PassEvent(MouseEvent.MouseClick, {
    type = "Child",
    combine = self,
    child = self.nowChild
  })
end

function QuestTraceCombineCell:SetData(data)
  QuestTraceCombineCell.super.SetData(self, data)
  self.data = data
  if data.fatherGoal then
    self.fatherObj:SetActive(not data.fatherGoal.isHide)
    if data.fatherGoal.isWorldQuest then
      if not data.fatherGoal.isHide then
        self.groupLabel.text = GameConfig.Quest.worldquestmap and GameConfig.Quest.worldquestmap[data.fatherGoal.version].Title or "???"
      end
    elseif data.fatherGoal.title then
      self.groupLabel.text = data.fatherGoal.title
    else
      local nameConfig = GameConfig.Quest.QuestSort[data.fatherGoal.area]
      self.groupLabel.text = nameConfig and nameConfig.name or data.fatherGoal.area
    end
    local curProcess = QuestProxy.Instance:GetWorldCount(data.fatherGoal.version)
    for i = 1, 4 do
      self.processCell[i].mark:SetActive(i <= curProcess)
    end
    self.rewardStatus.CurrentState = 4 <= curProcess and 1 or 0
    self.groupLabel_BG.width = self.groupLabel.printedSize.x + 30
    self.isAllFinish = 4 <= curProcess
    self.childCtl:ResetDatas(data.childGoals)
    self.ChildGoals.transform.localPosition = self.fatherObj.activeSelf and LuaGeometry.GetTempVector3(0, -115, 0) or LuaGeometry.GetTempVector3(0, 0, 0)
    local curVersion = data.fatherGoal.version
    if curVersion then
      local config = GameConfig.Quest.worldquestmap and GameConfig.Quest.worldquestmap[curVersion]
      if config and config.reward and config.reward[4] then
        self.processPart:SetActive(true)
        self.groupLabel.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(11, 21.6, 0)
        local rewardid = config.reward[4]
        local itemList = ItemUtil.GetRewardItemIdsByTeamId(rewardid)
        if itemList and 0 < #itemList then
          local rewardList = {}
          for i = 1, #itemList do
            local itemData = ItemData.new("Reward", itemList[i].id)
            itemData.num = itemList[i].num
            if itemList[i].refinelv and itemData:IsEquip() then
              itemData.equipInfo:SetRefine(itemList[i].refinelv)
            end
            if #rewardList < 2 then
              table.insert(rewardList, itemData)
            end
          end
          self.rewardCtrl:ResetDatas(rewardList)
        end
      else
        self.processPart:SetActive(false)
        self.groupLabel.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(11, 1, 0)
      end
    end
    local cells = self.rewardCtrl:GetCells()
    for i = 1, #cells do
      cells[i]:SetFinish(self.isAllFinish)
    end
    local folderState = data.fatherGoal.folderState
    if folderState then
      self.folderState = true
      self.tweenScale.duration = 0
      self.tweenScale:PlayForward()
      self.tweenScale.enabled = false
      self:PlayChildTween()
    else
      self.folderState = false
      self.tweenScale.duration = 0
      self:PlayChildTweenReverse()
      self.tweenScale:ResetToBeginning()
      self.tweenScale.enabled = false
    end
    self:PlayFatherTween()
    self:RefreshArrow()
  end
end

function QuestTraceCombineCell:SwitchToTargetQuest(questid)
  local cells = self.childCtl:GetCells()
  for i = 1, #cells do
    if cells[i].data.id == questid then
      self:ClickChild(cells[i])
      return cells[i]
    end
  end
  return false
end

function QuestTraceCombineCell:SetDefaultChoose()
  local cells = self.childCtl:GetCells()
  if cells and 0 < #cells then
    self:ClickChild(cells[1])
    return cells[1]
  end
end

function QuestTraceCombineCell:OnTweenScaleOnFinished()
  if self.folderState then
  else
  end
end

function QuestTraceCombineCell:SetFolderState(bool)
  if bool then
    self.tweenScale.duration = 0
    self.tweenScale.delay = 0
    self.tweenScale:PlayForward()
    self:PlayChildTween()
  else
    self.tweenScale.duration = 0
    self.tweenScale.delay = 0
    self:PlayChildTweenReverse()
    self.tweenScale:PlayReverse()
  end
end

function QuestTraceCombineCell:HandleTraceUpdate(cellCtrl)
  self:PassEvent(QuestEvent.QuestTraceChange, cellCtrl)
end

function QuestTraceCombineCell:SetNewTag(bool)
  local cells = self.childCtl:GetCells()
  for i = 1, #cells do
    cells[i]:SetNewSymbol(bool)
  end
end

function QuestTraceCombineCell:CancelNewTag()
  local newUpdateList = {}
  local cells = self.childCtl:GetCells()
  for i = 1, #cells do
    local cell = cells[i]
    cell:SetNewSymbol(false)
    if cell.questList then
      for j = 1, #cell.questList do
        if cell.questList[j].newstatus == 1 then
          table.insert(newUpdateList, cell.questList[j].id)
        end
      end
    elseif cell.data.newstatus == 1 then
      table.insert(newUpdateList, cell.data.id)
    end
  end
  if 0 < #newUpdateList then
    QuestProxy.Instance:RemoveClientNewQuestByQuesIds(newUpdateList)
  end
end

function QuestTraceCombineCell:PlayChildTween()
  local cells = self.childCtl:GetCells()
  if cells and 0 < #cells then
    for i = 1, #cells do
      cells[i]:PlayTween()
    end
  end
end

function QuestTraceCombineCell:PlayChildTweenReverse()
  local cells = self.childCtl:GetCells()
  if cells and 0 < #cells then
    for i = 1, #cells do
      cells[i]:PlayReverse()
    end
  end
end

function QuestTraceCombineCell:PlayFatherTween()
  self.father_TweenPos:ResetToBeginning()
  self.father_TweenPos:PlayForward()
  self.father_TweenAlpha:ResetToBeginning()
  self.father_TweenAlpha:PlayForward()
end

function QuestTraceCombineCell:RefillContainer()
  local cells = self.childCtl:GetCells()
  local height = self.ChildGoals_UIGrid.cellHeight * #cells
  self.sizeContainer.height = height
end

function QuestTraceCombineCell:OnCellDestroy()
  QuestTraceCombineCell.super.OnCellDestroy(self)
  local cells = self.childCtl:GetCells()
  if cells and 0 < #cells then
    for i = 1, #cells do
      cells[i]:OnCellDestroy()
    end
  end
  self.nowChild = nil
  TimeTickManager.Me():ClearTick(self)
end
