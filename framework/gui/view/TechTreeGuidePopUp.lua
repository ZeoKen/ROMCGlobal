TechTreeGuidePopUp = class("TechTreeGuidePopUp", ContainerView)
autoImport("TechTreeGuideCell")
TechTreeGuidePopUp.ViewType = UIViewType.PopUpLayer

function TechTreeGuidePopUp:Init()
  self.ctrl = UIGridListCtrl.new(self:FindComponent("Grid", UIGrid), TechTreeGuideCell, "TechTreeGuideCell")
end

function TechTreeGuidePopUp:OnEnter()
  local datas = {
    Table_Recommend[2002],
    Table_Recommend[2009]
  }
  self.ctrl:ResetDatas(datas)
end
