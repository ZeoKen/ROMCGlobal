autoImport("GuildDateBattleOverviewResultCell")
GuildDateBattle_Overview_Going = class("GuildDateBattle_Overview_Going", SubView)
local EType = GuildCmd_pb.EGUILDDATEBATTLELISTTYPE_READY

function GuildDateBattle_Overview_Going:Init()
  self:InitUI()
  self:MapEvent()
end

function GuildDateBattle_Overview_Going:OnEnter()
  GuildDateBattle_Overview_Going.super.OnEnter(self)
  ServiceGuildCmdProxy.Instance:CallDateBattleListGuildCmd(EType)
end

function GuildDateBattle_Overview_Going:InitUI()
  local wrap = self:FindGO("GoingWrapContent")
  local wrapConfig = {
    wrapObj = wrap,
    cellName = "GuildDateBattleOverviewResultCell",
    control = GuildDateBattleOverviewResultCell
  }
  self.goingCtrl = WrapCellHelper.new(wrapConfig)
end

function GuildDateBattle_Overview_Going:MapEvent()
  self:AddListenEvt(ServiceEvent.GuildCmdDateBattleListGuildCmd, self.UpdateData)
end

function GuildDateBattle_Overview_Going:OnTabEnabled()
  self:UpdateView()
end

function GuildDateBattle_Overview_Going:UpdateView()
  local data = GuildDateBattleProxy.Instance:GetGoingRecords()
  self.goingCtrl:ResetDatas(data)
  self.container.emptyGO:SetActive(#data == 0)
end

function GuildDateBattle_Overview_Going:UpdateData(note)
  if not note or note.body.type == EType then
    self:UpdateView()
  end
end
