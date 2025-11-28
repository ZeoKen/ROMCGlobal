local _EmptyTeamMemberData = MyselfTeamData.EMPTY_STATE
autoImport("PveMatchTeammateCell")
PveMatchPopup = class("PveMatchPopup", ContainerView)
PveMatchPopup.ViewType = UIViewType.PopUpLayer

function PveMatchPopup:Init()
  self.raidName = self.viewdata.viewdata and self.viewdata.viewdata.raidName or ""
  self.confirmCallback = self.viewdata.viewdata and self.viewdata.viewdata.confirmCallback
  self.initialProfession = nil
  self:FindObj()
  self:InitUI()
end

function PveMatchPopup:FindObj()
  self.aiTip = self:FindComponent("AITipLab", UILabel)
  self.aiTip.text = ZhString.TeamPws_AITip
  self.title = self:FindComponent("TitleLab", UILabel)
  self.title.text = ZhString.PveMatchPopup_Title
  self.tipLab = self:FindComponent("TipLab", UILabel)
  self.tipLab.text = ZhString.PveMatchPopup_Tip
  self.raidLab = self:FindComponent("RaidLab", UILabel)
  self.closeLab = self:FindComponent("CloseLab", UILabel)
  self.closeLab.text = ZhString.PveMatchPopup_Close
  self.confirmLab = self:FindComponent("ConfirmLab", UILabel)
  self.confirmLab.text = ZhString.PveMatchPopup_Confirm
  self.confirmBtn = self:FindGO("ConfirmBtn")
  self:AddClickEvent(self.confirmBtn, function()
    if self.confirmCallback then
      self.confirmCallback(self.aiToggle.value, self.healProfessionToggle.value)
      self:CloseSelf()
    end
  end)
  self.healProfessionToggle = self:FindComponent("HealProfessionToggle", UIToggle)
  local healLab = self:FindComponent("ToggleSet", UILabel, self.healProfessionToggle.gameObject)
  healLab.text = ZhString.PveMatchPopup_HealProfession
  self.aiToggle = self:FindComponent("AIToggle", UIToggle)
  local aiLab = self:FindComponent("ToggleSet", UILabel, self.aiToggle.gameObject)
  aiLab.text = ZhString.PveMatchPopup_AI
  EventDelegate.Add(self.aiToggle.onChange, function()
    self:UpdateAITip()
  end)
  EventDelegate.Add(self.healProfessionToggle.onChange, function()
    self:UpdateAITip()
  end)
  self.teammateGrid = self:FindComponent("TeammateGrid", UIGrid)
  self.teammateCtl = UIGridListCtrl.new(self.teammateGrid, PveMatchTeammateCell, "PveMatchTeammateCell")
  self.teammateCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickTeammateProfession, self)
end

function PveMatchPopup:UpdateAITip()
  if not self.aiToggle.value and self.healProfessionToggle.value then
    self:Show(self.aiTip)
  else
    self:Hide(self.aiTip)
  end
end

function PveMatchPopup:InitUI()
  local var_healProfession = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_NEED_HEAL_PROFESSION) or 0
  local var_ai = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_NEED_ROBOT_NPC) or 0
  self.healProfessionToggle.value = var_healProfession == 1
  self.aiToggle.value = var_ai == 1
  self:UpdateAITip()
  self.raidLab.text = string.format(ZhString.PveMatchPopup_Raid, self.raidName)
  self:InitTeammates()
end

function PveMatchPopup:InitTeammates()
  local teammates
  if TeamProxy.Instance:IHaveTeam() then
    teammates = TeamProxy.Instance.myTeam:GetPlayerMemberList(true, true)
  else
    teammates = {
      {
        id = Game.Myself.data.id
      }
    }
  end
  local emptyCount = 6 - #teammates
  if 0 < emptyCount then
    for i = 1, emptyCount do
      teammates[#teammates + 1] = _EmptyTeamMemberData
    end
  end
  self.teammateCtl:ResetDatas(teammates)
end

function PveMatchPopup:OnClickTeammateProfession(cell)
end
