local BaseCell = autoImport("BaseCell")
TeamGoalCombineCellForER = class("TeamGoalCombineCellForER", BaseCell)
autoImport("TeamGoalCellForER")

function TeamGoalCombineCellForER:Init()
  local fahterObj = self:FindGO("FatherGoal")
  self.tweenScale = self:FindComponent("ChildContainer", TweenScale)
  self.arrow = self:FindGO("Arrow")
  self.fatherTog = fahterObj:GetComponent(UIToggle)
  self.fatherSprite = self:FindComponent("FatherGoal", UIMultiSprite)
  self.fatherLabel = self:FindComponent("Label", UILabel, self.fatherSprite.gameObject)
  self.fatherSymbol = self:FindGO("Symbol", fahterObj)
  self.fatherCell = TeamGoalCellForER.new(fahterObj)
  self.fatherCell:AddEventListener(MouseEvent.MouseClick, self.ClickFather, self)
  local grid = self:FindComponent("ChildGoals", UIGrid)
  self.childCtl = UIGridListCtrl.new(grid, TeamGoalCellForER, "TeamGoalCellForER")
  self.childCtl:AddEventListener(MouseEvent.MouseClick, self.ClickChild, self)
  self.childSpace = grid.cellHeight
  self.childBg = self:FindComponent("ChildBg", UISprite)
  self:SetFolderState(false)
end

function TeamGoalCombineCellForER:ClickFather(cellCtl)
  cellCtl = cellCtl or self.fatherCell
  self:SetChoose(true)
  self:PassEvent(MouseEvent.MouseClick, {
    type = "Father",
    combine = self,
    father = cellCtl
  })
end

function TeamGoalCombineCellForER:ClickChild(cellCtl)
  local goalCells = self.childCtl:GetCells()
  cellCtl = cellCtl or goalCells[1]
  if cellCtl ~= self.nowChild then
    self.nowChild = cellCtl
  end
  self:PassEvent(MouseEvent.MouseClick, {
    type = "Child",
    combine = self,
    child = self.nowChild
  })
end

function TeamGoalCombineCellForER:GetchildCtl()
  return self.childCtl
end

function TeamGoalCombineCellForER:SetData(data)
  self.data = data
  if data.fatherGoal then
    self.fatherCell:SetData(data.fatherGoal)
    self.childCtl:ResetDatas(data.childGoals)
    if #data.childGoals > 0 then
      self:Show(self.childBg)
      self:Show(self.fatherSymbol)
      self.childBg.height = 44 + self.childSpace * #data.childGoals
    else
      self:Hide(self.childBg)
      self:Hide(self.fatherSymbol)
    end
  else
    helplog("data.fatherGoal is nil")
  end
end

function TeamGoalCombineCellForER:SetChoose(choose)
  self.fatherSprite.CurrentState = choose and 1 or 0
  self.fatherLabel.effectColor = choose and Color(0.6235294117647059, 0.30980392156862746, 0.03529411764705882) or Color(0.11372549019607843, 0.17647058823529413, 0.4627450980392157)
end

function TeamGoalCombineCellForER:GetFolderState()
  return self.folderState == true
end

function TeamGoalCombineCellForER:PlayReverseAnimation()
  self:SetFolderState(not self.folderState)
end

function TeamGoalCombineCellForER:ShowArrow(isShow)
  isShow = isShow and (self.data.childGoals and #self.data.childGoals > 0 or false)
  self.arrow.gameObject:SetActive(isShow)
  self.childBg.gameObject:SetActive(isShow)
  self.fatherSymbol.gameObject:SetActive(isShow)
end

local tempRot = LuaQuaternion()

function TeamGoalCombineCellForER:SetFolderState(isOpen)
  if self.folderState ~= isOpen then
    self.folderState = isOpen
    if isOpen then
      self.tweenScale:PlayForward()
    else
      self.tweenScale:PlayReverse()
    end
    LuaQuaternion.Better_SetEulerAngles(tempRot, LuaGeometry.GetTempVector3(0, 0, isOpen and 90 or -90))
    self.arrow.transform.rotation = tempRot
  end
end
