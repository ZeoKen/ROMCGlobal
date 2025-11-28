autoImport("BMLeftComineCell")
autoImport("DMMapListChildCell")
DMMapListComineCell = class("DMMapListComineCell", BMLeftComineCell)

function DMMapListComineCell:Init()
  self.super.Init(self)
  self.childCtl = UIGridListCtrl.new(self.ChildGoals_UIGrid, DMMapListChildCell, "DMMapListChildCell")
  if self.childCtl == nil then
    helplog("if self.childCtl == nil then")
  end
  self.childCtl:AddEventListener(MouseEvent.MouseClick, self.ClickChild, self)
end

function DMMapListComineCell:SetData(data)
  self.data = data
  if data.fatherGoal then
    self.fatherCell:SetData(data.fatherGoal)
    self.childCtl:ResetDatas(data.childGoals)
    if #data.childGoals > 0 then
      self:Show(self.fatherSymbol)
      self.ChildContainer.gameObject:SetActive(true)
      self.childBg.height = self.childSpace * #data.childGoals
    else
      self:Hide(self.fatherSymbol)
      self.ChildContainer.gameObject:SetActive(false)
    end
  else
    helplog("if(data.fatherGoal)then == nil")
  end
end
