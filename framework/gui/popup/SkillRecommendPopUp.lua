autoImport("SkillRecommendCell")
SkillRecommendPopUp = class("SkillRecommendPopUp", ContainerView)
SkillRecommendPopUp.ViewType = UIViewType.PopUpLayer

function SkillRecommendPopUp:Init()
  self:FindObj()
  self:AddViewEvts()
  self:InitView()
end

function SkillRecommendPopUp:FindObj()
  self.grid = self:FindGO("Grid"):GetComponent(UIGrid)
  self.gridCtrl = UIGridListCtrl.new(self.grid, SkillRecommendCell, "SkillRecommendCell")
  self.gridCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickCell)
  self.closecomp = self:FindComponent("Container", CloseWhenClickOtherPlace)
  
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
end

function SkillRecommendPopUp:AddViewEvts()
  self:AddListenEvt(SkillRecommendEvent.CloseRecommendView, self.CloseSelf)
end

function SkillRecommendPopUp:InitView()
  local myClass = MyselfProxy.Instance:GetMyProfession()
  local mySolution = ProfessionProxy.Instance:GetSkillPointSolution(myClass)
  if not mySolution or #mySolution == 0 then
    redlog("mySolution nil", myClass)
    self:CloseSelf()
    return
  end
  local tempArray = {}
  for i = 1, #mySolution do
    local single = {}
    single.professionid = myClass
    single.solutionid = mySolution[i]
    table.insert(tempArray, single)
  end
  self.gridCtrl:ResetDatas(tempArray)
  local cells = self.gridCtrl:GetCells()
  for i = 1, #cells do
    self:AddIgnoreBounds(cells[i].gameObject)
  end
end

function SkillRecommendPopUp:OnClickCell(cell)
end

function SkillRecommendPopUp:AddIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end

function SkillRecommendPopUp:OnExit()
  for i = 1, #self.gridCtrl do
    self.gridCtrl[i]:OnCellDestroy()
  end
end
