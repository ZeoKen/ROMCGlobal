local BaseCell = autoImport("BaseCell")
QuestTraceBaseCombineCell = class("QuestTraceBaseCombineCell", BaseCell)

function QuestTraceBaseCombineCell:Init()
  self.gameObject:SetActive(true)
  self.fatherObj = self:FindGO("FatherGoal")
  self.childContainer = self:FindGO("ChildContainer")
  self.tweenScale = self.childContainer:GetComponent(TweenScale)
  self.groupLabel = self:FindGO("GroupLabel", self.fatherObj):GetComponent(UILabel)
  self.groupLabel_BG = self:FindGO("GroupLabelBG", self.fatherObj):GetComponent(UISprite)
  self.arrowBG = self:FindGO("ArrowBg")
  self.arrow = self:FindGO("Arrow", self.arrowBG):GetComponent(UISprite)
  self.arrowBG_TweenScale = self.arrowBG:GetComponent(TweenScale)
  self.father_TweenPos = self.fatherObj:GetComponent(TweenPosition)
  self.father_TweenAlpha = self.fatherObj:GetComponent(TweenAlpha)
  self.ChildContainer = self:FindGO("ChildContainer")
  self.ChildGoals = self:FindGO("ChildGoals", self.ChildContainer)
  self.ChildGoals_UIGrid = self.ChildGoals:GetComponent(UIGrid)
  self.childSpace = self.ChildGoals_UIGrid.cellHeight
  self:AddClickEvent(self.fatherObj, function()
    self:ClickFather()
  end)
  self.tweenScale:SetOnFinished(function()
    self:OnTweenScaleOnFinished()
  end)
  self.folderState = true
  self.sizeContainer = self:FindGO("Container"):GetComponent(UIWidget)
  self.sizeContainer.height = 2
end

function QuestTraceBaseCombineCell:ClickFather(cellCtrl)
  xdlog("ClickFather")
  self.folderState = not self.folderState
  self:SetFolderState(self.folderState)
  self:PassEvent(MouseEvent.MouseClick, {
    type = "Father",
    father = self,
    index = self.indexInList
  })
  self:RefreshArrow()
  self.arrowBG_TweenScale:ResetToBeginning()
  self.arrowBG_TweenScale:PlayForward()
end

function QuestTraceBaseCombineCell:SetData(data)
  self.sizeContainer.height = 2
end

function QuestTraceBaseCombineCell:SwitchToTargetQuest(questid)
  local cells = self.childCtl:GetCells()
  for i = 1, #cells do
    if cells[i].data and cells[i].data.id == questid then
      self:ClickChild(cells[i])
      return cells[i]
    end
  end
  return false
end

function QuestTraceBaseCombineCell:SetDefaultChoose()
  local cells = self.childCtl:GetCells()
  if cells and 0 < #cells then
    self:ClickChild(cells[1])
  end
end

function QuestTraceBaseCombineCell:SetFolderState(bool)
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

function QuestTraceBaseCombineCell:RefreshArrow()
  self.arrow.gameObject.transform.localPosition = self.folderState and LuaGeometry.GetTempVector3(0, -20, 0) or LuaGeometry.GetTempVector3(0, -11, 0)
  self.arrow.flip = self.folderState and 2 or 0
end

function QuestTraceBaseCombineCell:OnTweenScaleOnFinished()
  if self.folderState then
  else
  end
end

function QuestTraceBaseCombineCell:PlayChildTween()
  local cells = self.childCtl:GetCells()
  if cells and 0 < #cells then
    for i = 1, #cells do
      cells[i]:PlayTween()
    end
  end
end

function QuestTraceBaseCombineCell:PlayChildTweenReverse()
  local cells = self.childCtl:GetCells()
  if cells and 0 < #cells then
    for i = 1, #cells do
      cells[i]:PlayReverse()
    end
  end
end

function QuestTraceBaseCombineCell:PlayFatherTween()
  self.father_TweenPos:ResetToBeginning()
  self.father_TweenPos:PlayForward()
  self.father_TweenAlpha:ResetToBeginning()
  self.father_TweenAlpha:PlayForward()
end

function QuestTraceBaseCombineCell:RefillContainer()
end

function QuestTraceBaseCombineCell:OnCellDestroy()
  QuestTraceBaseCombineCell.super.OnCellDestroy(self)
  local cells = self.childCtl:GetCells()
  if cells and 0 < #cells then
    for i = 1, #cells do
      cells[i]:OnCellDestroy()
    end
  end
  TimeTickManager.Me():ClearTick(self)
end
