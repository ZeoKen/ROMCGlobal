local BaseCell = autoImport("BaseCell")
TeamGoalCombineCell = class("TeamGoalCombineCell", BaseCell)
autoImport("TeamGoalCell")
autoImport("TeamGoalChildCell")

function TeamGoalCombineCell:Init()
  self.tweenScale = self:FindComponent("ChildContainer", TweenScale)
  local fahterObj = self:FindGO("FatherGoal")
  self.fatherSprite = self:FindComponent("FatherGoal", UIMultiSprite)
  self.fatherLabel = self:FindComponent("Label", UILabel, self.fatherSprite.gameObject)
  self.fatherSymbol = self:FindGO("Symbol", fahterObj)
  self.fatherSymbolSp = self.fatherSymbol:GetComponent(UISprite)
  self.fatherCell = TeamGoalCell.new(fahterObj)
  self.fatherCell:AddEventListener(MouseEvent.MouseClick, self.ClickFather, self)
  local grid = self:FindComponent("ChildGoals", UIGrid)
  self.childCtl = UIGridListCtrl.new(grid, TeamGoalChildCell, "TeamGoalChildCell")
  self.childCtl:AddEventListener(MouseEvent.MouseClick, self.ClickChild, self)
  self.childSpace = grid.cellHeight
  self.childBg = self:FindComponent("ChildBg", UISprite)
  self:SetFolderState(false)
end

function TeamGoalCombineCell:ClickFather(cellCtl)
  if self.isAvailable == false then
    return
  end
  cellCtl = cellCtl or self.fatherCell
  self:SetChoose(true)
  self:PassEvent(MouseEvent.MouseClick, {
    type = "Father",
    combine = self,
    father = cellCtl
  })
end

function TeamGoalCombineCell:GetchildCtl()
  return self.childCtl
end

function TeamGoalCombineCell:ClickChild(cellCtl)
  if cellCtl ~= self.nowChild then
    if self.nowChild then
      self.nowChild:SetChoose(false)
    end
    cellCtl:SetChoose(true)
    self.nowChild = cellCtl
  else
    self.nowChild:SetChoose(false)
    self.nowChild = nil
  end
  self:PassEvent(MouseEvent.MouseClick, {
    type = "Child",
    combine = self,
    child = self.nowChild
  })
end

function TeamGoalCombineCell:SetData(data)
  self.data = data
  if data.fatherGoal then
    self.fatherCell:SetData(data.fatherGoal)
    if data.childGoals then
      self.childCtl:ResetDatas(data.childGoals)
    end
    if data.childGoals and #data.childGoals > 0 then
      self:Show(self.childBg)
      self:Show(self.fatherSymbol)
      self.childBg.height = 60 + self.childSpace * #data.childGoals
    else
      self:Hide(self.childBg)
      self:Hide(self.fatherSymbol)
    end
  end
  if data.avaliable then
    self:SetAvailable(true)
  end
end

local chooseEffectColor, notChooseEffectColor = Color(0.6235294117647059, 0.30980392156862746, 0.03529411764705882), Color(0.11372549019607843, 0.17647058823529413, 0.4627450980392157)

function TeamGoalCombineCell:SetChoose(choose)
  if not self.isAvailable then
    return
  end
  self.fatherSprite.CurrentState = choose and 1 or 0
  self.fatherLabel.effectColor = choose and chooseEffectColor or notChooseEffectColor
  if self.nowChild then
    self.nowChild:SetChoose(false)
    self.nowChild = nil
  end
end

function TeamGoalCombineCell:SetAvailable(isAvailable)
  self.isAvailable = isAvailable and true or false
  self.fatherSprite.CurrentState = isAvailable and 0 or 2
  self.fatherLabel.effectColor = isAvailable and notChooseEffectColor or ColorUtil.NGUIGray
  if self.nowChild then
    self.nowChild:SetChoose(false)
    self.nowChild = nil
  end
end

function TeamGoalCombineCell:GetFolderState()
  return self.folderState == true
end

function TeamGoalCombineCell:PlayReverseAnimation()
  self:SetFolderState(not self.folderState)
end

local tempRot = LuaQuaternion()

function TeamGoalCombineCell:SetFolderState(isOpen)
  if self.folderState ~= isOpen then
    self.folderState = isOpen
    local z = isOpen and -90 or 90
    if isOpen then
      self.tweenScale:PlayForward()
    else
      self.tweenScale:PlayReverse()
    end
    LuaQuaternion.Better_SetEulerAngles(tempRot, LuaGeometry.GetTempVector3(0, 0, z))
  end
end
