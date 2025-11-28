autoImport("BanCardCombineCell")
autoImport("GuildDateBattleRecordCell")
GuildDateBattleEntranceView = class("GuildDateBattleEntranceView", ContainerView)
GuildDateBattleEntranceView.ViewType = UIViewType.NormalLayer
GuildDateBattleEntranceView.m_helpId = 1838
local _PictureManager, _DateProxy
local _BgTextureName = "sign_7_bg3"
local _VSTextureName = "3v3v3_bg_vs"
local GrayUIWidget = ColorUtil.GrayUIWidget
local WhiteUIWidget = ColorUtil.WhiteUIWidget
local SpriteName = {
  Blue = "com_btn_1",
  Green = "com_btn_3",
  Gray = "com_btn_13"
}

function GuildDateBattleEntranceView:Init()
  _DateProxy = GuildDateBattleProxy.Instance
  _PictureManager = PictureManager.Instance
  self:FindObjs()
  self:AddViewEvts()
end

function GuildDateBattleEntranceView:FindObjs()
  self.titleLab = self:FindComponent("Title", UILabel)
  self.titleLab.text = ZhString.GuildDateBattle_Entrance
  local fixedRoot = self:FindGO("Fixed")
  local fixed_Offensive_Side = self:FindComponent("Fixed_OffensiveSide", UILabel, fixedRoot)
  fixed_Offensive_Side.text = ZhString.GuildDateBattle_Offensive_Side
  local fixed_Defensive_Side = self:FindComponent("Fixed_DefensiveSide", UILabel, fixedRoot)
  fixed_Defensive_Side.text = ZhString.GuildDateBattle_Defensive_Side
  local fixed_Date = self:FindComponent("Fixed_TimeCD", UILabel, fixedRoot)
  fixed_Date.text = ZhString.GuildDateBattle_TimeCD
  local fixed_hp = self:FindComponent("Fixed_Hp", UILabel, fixedRoot)
  fixed_hp.text = ZhString.GuildDateBattle_Hp
  local fixed_PerfectDef = self:FindComponent("Fixed_PerfectDef", UILabel, fixedRoot)
  fixed_PerfectDef.text = ZhString.GuildDateBattle_PefectDefCD
  local right = self:FindGO("Right")
  self.descLab = self:FindComponent("Desc", UILabel, right)
  self.durationLab = self:FindComponent("Duration", UILabel, right)
  self.bgTexture = self:FindComponent("BgTexture", UITexture, right)
  self.mapTexture = self:FindComponent("MapTexture", UITexture, right)
  self.vsTexture = self:FindComponent("VSTexture", UITexture, right)
  _PictureManager:SetPaySignIn(_BgTextureName, self.bgTexture)
  _PictureManager:SetTriplePvpTexture(_VSTextureName, self.vsTexture)
  self.texture = self:FindComponent("Texture", UITexture, right)
  self.offensiveSideLab = self:FindComponent("OffensiveSide", UILabel)
  self.defensiveSideLab = self:FindComponent("DefensiveSide", UILabel)
  self.timeCdLab = self:FindComponent("TimeCD", UILabel)
  self.hpLab = self:FindComponent("Hp", UILabel)
  self.perfectDefCD = self:FindComponent("PerfectDefCD", UILabel)
  self.modeLab = self:FindComponent("ModeLab", UILabel, right)
  self.num1Lab = self:FindComponent("Num1", UILabel, right)
  self.num2Lab = self:FindComponent("Num2", UILabel, right)
  self.enterBtn = self:FindComponent("EnterBtn", UISprite)
  self:AddClickEvent(self.enterBtn.gameObject, function()
    self:OnClickEnterBtn()
  end)
  self.enterLab = self:FindComponent("Label", UILabel, self.enterBtn.gameObject)
  self.enterLab.text = ZhString.GuildDateBattle_EnterMap
  self.checkBtn = self:FindComponent("CheckBtn", UISprite)
  self:AddClickEvent(self.checkBtn.gameObject, function()
    self:OnClickCheckBtn()
  end)
  self.checkLab = self:FindComponent("Label", UILabel, self.checkBtn.gameObject)
  self.checkLab.text = ZhString.GuildDateBattle_CheckInfo
  self.banCardTitle = self:FindComponent("BanCardTitle", UILabel)
  self.banCardTitle.text = ZhString.GuildDateBattle_BanCardTitle
  self.banCardGO = self:FindGO("BanCardCombineCell")
  self.banCardCell = BanCardCombineCell.new(self.banCardGO)
end

function GuildDateBattleEntranceView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.GuildCmdDateBattleReportGuildCmd, self.UpdateView)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.GuildCmdDateBattleOpenGuildCmd, self.HandleEntrance)
end

function GuildDateBattleEntranceView:HandleEntrance()
  local hasGuild = GuildProxy.Instance:IHaveGuild()
  local isOpen = _DateProxy:IsOpen() and hasGuild
  if not isOpen then
    self:CloseSelf()
    return
  end
  self:UpdateBtn()
end

function GuildDateBattleEntranceView:OnExit()
  if nil ~= self.mapTextureName then
    _PictureManager:UnLoadMiniMap(self.mapTextureName, self.mapTexture)
  end
  _PictureManager:UnLoadPaySignIn(_BgTextureName, self.bgTexture)
  _PictureManager:UnloadTriplePvpTexture(_VSTextureName, self.vsTexture)
  self:ClearTick()
  ServiceGuildCmdProxy.Instance:CallDateBattleReportUIStateCmd(false)
  GuildDateBattleEntranceView.super.OnExit(self)
end

function GuildDateBattleEntranceView:OnEnter()
  ServiceGuildCmdProxy.Instance:CallDateBattleReportUIStateCmd(true)
  GuildDateBattleEntranceView.super.OnEnter(self)
  self:UpdateView()
  ServiceGuildCmdProxy.Instance:CallDateBattleReportGuildCmd()
end

function GuildDateBattleEntranceView:OnClickEnterBtn()
  if not _DateProxy:IsOpen() then
    return
  end
  if Game.MapManager:IsGVG_Date() then
    MsgManager.ShowMsgByID(2245)
    return
  end
  _DateProxy:EnterBattleMap(self.entranceData:GetId())
  self:CloseSelf()
end

function GuildDateBattleEntranceView:OnClickCheckBtn()
  if not _DateProxy:IsOpen() then
    return
  end
  ServiceGuildCmdProxy.Instance:CallDateBattleDetailGuildCmd()
end

function GuildDateBattleEntranceView:UpdateBtn()
  local isActive = _DateProxy:IsOpen()
  if isActive then
    self.enterBtn.spriteName = SpriteName.Green
    self.checkBtn.spriteName = SpriteName.Blue
    WhiteUIWidget(self.enterLab)
    WhiteUIWidget(self.checkLab)
    self.enterLab.effectStyle = UILabel.Effect.Outline
    self.checkLab.effectStyle = UILabel.Effect.Outline
  else
    self.enterBtn.spriteName = SpriteName.Gray
    self.checkBtn.spriteName = SpriteName.Gray
    GrayUIWidget(self.enterLab)
    GrayUIWidget(self.checkLab)
    self.enterLab.effectStyle = UILabel.Effect.None
    self.checkLab.effectStyle = UILabel.Effect.None
  end
end

function GuildDateBattleEntranceView:UpdateView()
  self.entranceData = _DateProxy:GetEntranceData()
  if not self.entranceData then
    return
  end
  self.descLab.text = self.entranceData:GetModeDesc()
  self.modeLab.text = self.entranceData:GetModeName()
  self.num1Lab.text = self.entranceData.atk_member_count
  self.num2Lab.text = self.entranceData.def_member_count
  self:ClearTick()
  self.cdTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateTimeCD, self, 1)
  local hp = self.entranceData.hp or 1000
  self.hpLab.text = string.format(ZhString.GuildDateBattle_HpPer, hp / 10)
  self.offensiveSideLab.text = self.entranceData:GetOffGuildName()
  self.defensiveSideLab.text = self.entranceData:GetDefGuildName()
  local mode = self.entranceData:GetModel() or 1
  self.mapTextureName = _DateProxy:GetMiniMapTextureName(mode)
  _PictureManager:SetMiniMap(self.mapTextureName, self.mapTexture)
  self:UpdatePerfectDefense()
  self:UpdateBtn()
  self:SetBanCard()
end

function GuildDateBattleEntranceView:SetBanCard()
  if not self.entranceData then
    return
  end
  self.banCardCell:SetData(self.entranceData:GetBanCardIds(true))
  self.banCardCell:SetOptionEnable(false)
end

function GuildDateBattleEntranceView:UpdatePerfectDefense()
  self.perfectTimeInfo = self.entranceData.perfect_end_time
  if not self.perfectTimeInfo then
    self:ClearPerfectDefTick()
    return
  end
  if self:TrySetPausePerfectTime() then
    return
  end
  if not self.perfectDefTick then
    self.perfectDefTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdatePerfectDefCD, self, 2)
  end
end

function GuildDateBattleEntranceView:TrySetPausePerfectTime()
  if not self.perfectTimeInfo then
    return false
  end
  if not self.perfectTimeInfo.pause then
    return false
  end
  self:PausePerfectDefenseTick()
  local leftTime = self.perfectTimeInfo.time
  local min, sec = ClientTimeUtil.GetFormatSecTimeStr(leftTime)
  self.perfectDefCD.text = orginStringFormat(ZhString.MainViewGvgPage_LeftTime, min, sec)
  return true
end

function GuildDateBattleEntranceView:PausePerfectDefenseTick()
  if not self.perfectDefTick then
    return
  end
  self.perfectDefTick:StopTick()
end

function GuildDateBattleEntranceView:HandleDefensePerfectSuccess()
  self:ClearPerfectDefTick()
  self.perfectDefCD.text = ZhString.MainViewGvgPage_PerfectDefense_Success
end

function GuildDateBattleEntranceView:UpdateTimeCD()
  if not self.entranceData then
    self:ClearCDTick()
    return
  end
  local end_time = self.entranceData:GetEndTime()
  if not end_time or end_time <= 0 then
    self:ClearCDTick()
    return
  end
  local cur_time = ServerTime.CurServerTime() / 1000
  local left = end_time - cur_time
  if left <= 0 then
    self:ClearCDTick()
    return
  end
  local min, sec = ClientTimeUtil.GetFormatSecTimeStr(left)
  self.timeCdLab.text = string.format(ZhString.MainViewGvgPage_LeftTime, min, sec)
end

function GuildDateBattleEntranceView:UpdatePerfectDefCD()
  if not self.perfectTimeInfo then
    return
  end
  if self:TrySetPausePerfectTime() then
    return
  end
  local cur_time = ServerTime.CurServerTime() / 1000
  local left = self.perfectTimeInfo.time - ServerTime.CurServerTime() / 1000
  if left <= 0 then
    self:HandleDefensePerfectSuccess()
    return
  end
  local min, sec = ClientTimeUtil.GetFormatSecTimeStr(left)
  self.perfectDefCD.text = string.format(ZhString.MainViewGvgPage_LeftTime, min, sec)
end

function GuildDateBattleEntranceView:ClearCDTick()
  if self.cdTick then
    TimeTickManager.Me():ClearTick(self, 1)
    self.cdTick = nil
  end
end

function GuildDateBattleEntranceView:ClearPerfectDefTick()
  if self.perfectDefTick then
    TimeTickManager.Me():ClearTick(self, 2)
    self.perfectDefTick = nil
  end
end

function GuildDateBattleEntranceView:ClearTick()
  self:ClearCDTick()
  self:ClearPerfectDefTick()
end
