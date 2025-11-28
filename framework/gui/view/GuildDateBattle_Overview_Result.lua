autoImport("GuildDateBattleOverviewResultCell")
GuildDateBattle_Overview_Result = class("GuildDateBattle_Overview_Result", SubView)
local RType = GuildCmd_pb.EGUILDDATEBATTLELISTTYPE_END

function GuildDateBattle_Overview_Result:Init()
  self:InitUI()
  self:MapEvent()
end

function GuildDateBattle_Overview_Result:OnEnter()
  GuildDateBattle_Overview_Result.super.OnEnter(self)
  ServiceGuildCmdProxy.Instance:CallDateBattleListGuildCmd(RType)
end

function GuildDateBattle_Overview_Result:MapEvent()
  self:AddListenEvt(ServiceEvent.GuildCmdDateBattleListGuildCmd, self.UpdateData)
end

function GuildDateBattle_Overview_Result:InitUI()
  local wrap = self:FindGO("FinishedContent")
  local wrapConfig = {
    wrapObj = wrap,
    cellName = "GuildDateBattleOverviewResultCell",
    control = GuildDateBattleOverviewResultCell
  }
  self.finishedCtrl = WrapCellHelper.new(wrapConfig)
end

function GuildDateBattle_Overview_Result:UpdateData(note)
  if not note or note.body.type == RType then
    self:UpdateView()
  end
end

function GuildDateBattle_Overview_Result:UpdateView()
  local data = GuildDateBattleProxy.Instance:GetFinishedRecords()
  self.finishedCtrl:ResetDatas(data)
  self.container.emptyGO:SetActive(#data == 0)
end
