autoImport("RoguelikeSkillChooseCell")
RoguelikeSkillChooseView = class("RoguelikeSkillChooseView", ContainerView)
RoguelikeSkillChooseView.ViewType = UIViewType.NormalLayer

function RoguelikeSkillChooseView:Init()
  self:FindObjs()
  self:AddListenEvts()
end

function RoguelikeSkillChooseView:FindObjs()
  local mask = self:FindGO("Mask")
  self:AddClickEvent(mask, function()
    self:CloseSelf()
  end)
  local grid = self:FindComponent("Grid", UIGrid)
  self.skillListCtrl = UIGridListCtrl.new(grid, RoguelikeSkillChooseCell, "RoguelikeSkillChooseCell")
  self.skillListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnSkillCellClick, self)
  self.resetBtn = self:FindGO("ResetBtn")
  self:AddClickEvent(self.resetBtn, function()
    self:OnResetBtnClick()
  end)
  self.resetLabel = self:FindComponent("Label", UILabel, self.resetBtn)
  self.resetBtnGrey = self:FindGO("ResetBtnGrey")
end

function RoguelikeSkillChooseView:AddListenEvts()
  self:AddListenEvt(ServiceEvent.FuBenCmdSTIRetUpgradeOptionsCmd, self.HandleSkillListUpdate)
  self:AddListenEvt(PVEEvent.SpeceTimeIllusion_Shutdown, self.HandleSpaceTimeIllusionShutdown)
  self:AddListenEvt(ServiceEvent.FuBenCmdSyncSpaceTimeIllusionInfoFuBenCmd, self.HandleSyncSpaceTimeIllusionInfo)
end

function RoguelikeSkillChooseView:HandleSkillListUpdate()
  self:RefreshView()
end

function RoguelikeSkillChooseView:HandleSpaceTimeIllusionShutdown()
  self:CloseSelf()
end

function RoguelikeSkillChooseView:HandleSyncSpaceTimeIllusionInfo(note)
  local data = note.body
  if data.endtime == 0 then
    self:CloseSelf()
  end
end

function RoguelikeSkillChooseView:OnEnter()
  self:RefreshView()
end

function RoguelikeSkillChooseView:OnExit()
end

function RoguelikeSkillChooseView:RefreshView()
  local skills = RoguelikeSkillProxy.Instance:GetAlternativeSkillList()
  if #skills == 0 then
    redlog("CallSTIGetUpgradeOptionsCmd")
    ServiceFuBenCmdProxy.Instance:CallSTIGetUpgradeOptionsCmd()
    return
  end
  self.skillListCtrl:ResetDatas(skills)
  self:UpdateResetBtn()
end

function RoguelikeSkillChooseView:OnSkillCellClick(cell)
  ServiceFuBenCmdProxy.Instance:CallSTIExecSkillUpgradeCmd(cell.indexInList)
  self:CloseSelf()
end

function RoguelikeSkillChooseView:OnResetBtnClick()
  RoguelikeSkillProxy.Instance:RandomAlternativeSkills(0)
end

function RoguelikeSkillChooseView:UpdateResetBtn()
  local resetNum = RoguelikeSkillProxy.Instance:GetAvailableRefreshAllSkillNumber() or 0
  local maxResetNum = GameConfig.SpaceTimeIllusion and GameConfig.SpaceTimeIllusion.RefreshAllSkillLimit or 0
  self.resetLabel.text = string.format(ZhString.RoguelikeSkill_Reset, resetNum, maxResetNum)
  self.resetBtn:SetActive(0 < resetNum)
  self.resetBtnGrey:SetActive(resetNum <= 0)
end
