local BaseCell = autoImport("BaseCell")
autoImport("PersonalArtifactFormulaCell")
PersonalArtifactFormulaFatherCell = class("PersonalArtifactFormulaFatherCell", BaseCell)

function PersonalArtifactFormulaFatherCell:Init()
  self.tweenScale = self:FindComponent("ChildContainer", TweenScale)
  self.arrow = self:FindGO("Arrow")
  local fatherObj = self:FindGO("Father")
  if fatherObj then
    self:Hide(fatherObj)
  end
  self.childCtl = ListCtrl.new(self:FindComponent("Children", UIGrid), PersonalArtifactFormulaCell, "PersonalArtifactFormulaCell")
  self.childCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickChild, self)
  self.childCtl:AddEventListener(EquipChooseCellEvent.ClickItemIcon, self.OnClickChildIcon, self)
  self.childCells = self.childCtl:GetCells()
  self:SetFold(false, false)
end

function PersonalArtifactFormulaFatherCell:SetData(data)
  self.data = data
  if not data then
    return
  end
  self.childCtl:ResetDatas(data)
  self:SetFold(true, false)
end

function PersonalArtifactFormulaFatherCell:OnClickChild(cellCtl)
  self:PassEvent(MouseEvent.MouseClick, cellCtl)
end

function PersonalArtifactFormulaFatherCell:OnClickChildIcon(data)
  self:PassEvent(EquipChooseCellEvent.ClickItemIcon, data)
end

function PersonalArtifactFormulaFatherCell:ReverseFold(withAnimation)
  self:SetFold(not self.isFold, withAnimation)
end

local tempRot = LuaQuaternion()

function PersonalArtifactFormulaFatherCell:SetFold(isOpen, withAnimation)
  if self.isFold == isOpen then
    return
  end
  if withAnimation == nil then
    withAnimation = true
  end
  self.isFold = isOpen
  if withAnimation then
    if isOpen then
      self.tweenScale:PlayForward()
    else
      self.tweenScale:PlayReverse()
    end
  else
    self.tweenScale:Sample(isOpen and 1 or 0, true)
  end
  LuaQuaternion.Better_SetEulerAngles(tempRot, LuaGeometry.GetTempVector3(0, 0, isOpen and -90 or 90))
  self.arrow.transform.rotation = tempRot
end
