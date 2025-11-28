autoImport("GuildDateBattleRecordCell")
GuildDateBattleRecordView = class("GuildDateBattleRecordView", ContainerView)
GuildDateBattleRecordView.ViewType = UIViewType.NormalLayer
local titleStr = {
  [1] = ZhString.GuildDateBattle_Record_Date,
  [2] = ZhString.GuildDateBattle_Record_Guild,
  [3] = ZhString.GuildDateBattle_Record_Mode,
  [4] = ZhString.GuildDateBattle_Record_State
}
local GuildDataBattle_InviteRed = SceneTip_pb.EREDSYS_GUILD_DATEBATTLE_INVITE
local GuildDataBattle_ReadyRed = SceneTip_pb.EREDSYS_GUILD_DATEBATTLE_READY
local EmptyTextureName = "new_taskmanual_bg_bottom02"
local _Proxy

function GuildDateBattleRecordView:Init()
  _Proxy = GuildDateBattleProxy.Instance
  self:AddListenEvt(ServiceEvent.GuildCmdDateBattleInfoGuildCmd, self.UpdateRecords)
  self:AddListenEvt(ServiceEvent.GuildCmdDateBattleReplyGuildCmd, self.UpdateRecords)
  self:AddListenEvt(ServiceEvent.GuildCmdDateBattleInviteGuildCmd, self.UpdateRecords)
  self:AddListenEvt(GuildEvent.GuildBattleClientRefused, self.UpdateRecords)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:FindObjs()
  self:UpdateInvite()
  self:UpdateRecords()
end

function GuildDateBattleRecordView:FindObjs()
  self.titleLab = self:FindComponent("Title", UILabel)
  self.titleLab.text = ZhString.GuildDateBattle_Record_Title
  self.emptyGO = self:FindGO("EmptyIcon")
  self.emptyTex = self:FindComponent("EmptyTex", UITexture, self.emptyGO)
  PictureManager.Instance:SetUI(EmptyTextureName, self.emptyTex)
  self.emptyLab = self:FindComponent("EmptyLab", UILabel, self.emptyGO)
  self.emptyLab.text = ZhString.Common_Empty
  self.emptyLab1 = self:FindComponent("Lab", UILabel, self.emptyLab.gameObject)
  self.emptyLab1.text = ZhString.GuildDateBattle_InviteEmpty
  local titleNameRoot = self:FindGO("TitleName")
  for i = 1, #titleStr do
    local titleLab = self:FindComponent("TitleName_" .. tostring(i), UILabel, titleNameRoot)
    if titleLab then
      titleLab.text = titleStr[i]
    end
  end
  self.inviteBtn = self:FindComponent("InviteBtn", UISprite)
  self.inviteLab = self:FindComponent("InviteLabel", UILabel, self.inviteBtn.gameObject)
  self.inviteLab.text = ZhString.GuildDateBattle_Invite
  self:AddClickEvent(self.inviteBtn.gameObject, function()
    self:OnClickInvite()
  end)
  self.wrap = self:FindGO("WrapContent")
  local wrapConfig = {
    wrapObj = self.wrap,
    pfbNum = 7,
    cellName = "GuildDateBattleRecordCell",
    control = GuildDateBattleRecordCell
  }
  self.recordCtrl = WrapCellHelper.new(wrapConfig)
  self.recordCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickRecord, self)
end

function GuildDateBattleRecordView:OnEnter()
  GuildDateBattleRecordView.super.OnEnter(self)
  if ServiceGuildCmdProxy.Instance.CallDateBattleInfoGuildCmd then
    ServiceGuildCmdProxy.Instance:CallDateBattleInfoGuildCmd(0)
  end
end

function GuildDateBattleRecordView:OnExit()
  GuildDateBattleRecordView.super.OnExit(self)
  PictureManager.Instance:UnLoadUI(EmptyTextureName, self.emptyTex)
end

function GuildDateBattleRecordView:UpdateInvite()
  if GuildProxy.Instance:ImGuildChairman() then
    self.inviteBtn.spriteName = "com_btn_1"
    self.inviteLab.effectColor = ColorUtil.TitleBlue
  else
    self.inviteBtn.spriteName = "com_btn_13"
    self.inviteLab.effectColor = ColorUtil.TitleGray
  end
end

function GuildDateBattleRecordView:OnClickInvite()
  if not GuildProxy.Instance:ImGuildChairman() then
    MsgManager.ShowMsgByID(43560)
    return
  end
  local max = GameConfig.GuildDateBattle and GameConfig.GuildDateBattle.max_count or 12
  local cur = _Proxy:GetCurDateCount()
  if max <= cur then
    MsgManager.ShowMsgByID(43558)
    return
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.GuildFindView,
    viewdata = {isGuildDate = true}
  })
  self:CloseSelf()
end

function GuildDateBattleRecordView:OnClickRecord(cell)
  local record_data = cell.data
  if not record_data then
    return
  end
  local db_id = record_data.id
  _Proxy:BrowseRedtip(GuildDataBattle_InviteRed, db_id)
  _Proxy:BrowseRedtip(GuildDataBattle_ReadyRed, db_id)
  _Proxy:OpenViewByState(record_data)
end

function GuildDateBattleRecordView:UpdateRecords()
  local datas = _Proxy:GetRecords()
  local isEmpty = #datas == 0
  if isEmpty then
    self:Show(self.emptyGO)
    self:Hide(self.wrap)
  else
    self:Hide(self.emptyGO)
    self:Show(self.wrap)
    self.recordCtrl:ResetDatas(datas)
  end
end
