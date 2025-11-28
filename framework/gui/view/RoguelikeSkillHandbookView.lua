autoImport("RoguelikeSkillHandbookCell")
RoguelikeSkillHandbookView = class("RoguelikeSkillHandbookView", ContainerView)
RoguelikeSkillHandbookView.ViewType = UIViewType.PopUpLayer

function RoguelikeSkillHandbookView:Init()
  self:FindObjs()
end

function RoguelikeSkillHandbookView:FindObjs()
  self:AddCloseButtonEvent()
  local grid = self:FindComponent("Grid", UIGrid)
  self.skillListCtrl = UIGridListCtrl.new(grid, RoguelikeSkillHandbookCell, "RoguelikeSkillHandbookCell")
  self.skillListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnSkillCellClick, self)
  for i = 1, 3 do
    local tab = self:FindGO("Tab" .. i)
    self:AddTabChangeEvent(tab, nil, i)
  end
end

function RoguelikeSkillHandbookView:OnEnter()
  self:TabChangeHandler(1)
end

function RoguelikeSkillHandbookView:OnExit()
end

function RoguelikeSkillHandbookView:OnSkillCellClick(cell)
  local data = cell.data
  if data then
    TipsView.Me():ShowTip(RoguelikeSkillTip, data)
  end
end

function RoguelikeSkillHandbookView:TabChangeHandler(key)
  self.curTab = key
  self:RefreshView()
end

function RoguelikeSkillHandbookView:RefreshView()
  local skills = RoguelikeSkillProxy.Instance:GetSkillsByType(self.curTab)
  self.skillListCtrl:ResetDatas(skills)
  self.skillListCtrl:ResetPosition()
end
