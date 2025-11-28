autoImport("BanCardCombineCell")
GuildDateBattleInviteView = class("GuildDateBattleInviteView", ContainerView)
GuildDateBattleInviteView.ViewType = UIViewType.PopUpLayer
GuildDateBattleInviteView.m_helpId = 1838
local _PictureManager, _DateProxy
local _BgTextureName = "sign_7_bg3"
local _WinTextureName = "pvp_bg_win"
local _WinTextureName1 = "pvp_bg_win_blue"
local _LoseTextureName = "pvp_yuezhan_bg_lost"
local _LoseTextureName1 = "pvp_bg_lost"
local _determinedColor = "383838"
local _BgColor = {
  Approval = "daefff",
  Refuse = "ffd1d1",
  PreEnter = "e0ffe5"
}
local GuildDataBattle_ReadyRed = SceneTip_pb.EREDSYS_GUILD_DATEBATTLE_READY

function GuildDateBattleInviteView:Init()
  _DateProxy = GuildDateBattleProxy.Instance
  _PictureManager = PictureManager.Instance
  self:FindObjs()
  self:AddEvts()
end

function GuildDateBattleInviteView:AddEvts()
  self:AddListenEvt(ServiceEvent.GuildCmdDateBattleReplyGuildCmd, self.HandleUpdate)
  self:AddListenEvt(ServiceEvent.GuildCmdDateBattleInviteGuildCmd, self.HandleUpdate)
  self:AddListenEvt(GuildEvent.GuildBattleClientRefused, self.HandleUpdate)
  self:AddListenEvt(GuildDateBattleEvent.ChooseDate, self.SetDate)
  self:AddListenEvt(GuildDateBattleEvent.ChooseClock, self.SetClockTime)
  self:AddListenEvt(GuildDateBattleEvent.ChooseMode, self.SetMode)
end

function GuildDateBattleInviteView:HandleUpdate()
  if not self.data then
    return
  end
  local data = _DateProxy:GetRecordByData(self.data)
  if not data then
    return
  end
  self:ClearCacheDate()
  self.data = data
  self.IsUnderApproval_Other = self.data:IsUnderApproval_Other()
  if self.IsUnderApproval_Other then
    GameFacade.Instance:sendNotification(GuildDateBattleEvent.CloseGuildFindView)
  end
  self.changeToPreEnter = self.data:IsPreEnter()
  self:SetData()
end

function GuildDateBattleInviteView:FindObjs()
  self.root = self:FindGO("Root")
  self.bgSp = self:FindComponent("Bg", UISprite)
  self.titleLab = self:FindComponent("Title", UILabel)
  self.invalidLab = self:FindComponent("Invalid", UILabel)
  self.invalidLab.text = ZhString.GuildDateBattle_Invalid
  self.titleLab.text = ZhString.GuildDateBattle_InviteTitle
  self.dateRoot = self:FindGO("DateRoot")
  local datebg = self:FindComponent("Bg", UISprite, self.dateRoot)
  self.dateBg = {
    datebg,
    self:FindComponent("Sprite1", UISprite, datebg.gameObject),
    self:FindComponent("Sprite2", UISprite, datebg.gameObject)
  }
  self.approvalLab = self:FindComponent("ApprovalLab", UILabel, self.dateRoot)
  self.approvalRoot = self:FindGO("Approval", self.dateRoot)
  self.approvalAgreeBtn = self:FindGO("AgreeBtn", self.approvalRoot)
  self:AddClickEvent(self.approvalAgreeBtn, function()
    self:OnClickAgreeBtn()
  end)
  self.approvalAgreeLab = self:FindComponent("Label", UILabel, self.approvalAgreeBtn)
  self.approvalAgreeLab.text = ZhString.GuildDateBattle_Agree
  self.approvalRefuseBtn = self:FindGO("RefuseBtn", self.approvalRoot)
  self:AddClickEvent(self.approvalRefuseBtn, function()
    self:OnClickRefuseBtn()
  end)
  self.approvalRefuseLab = self:FindComponent("RefuseLabel", UILabel, self.approvalRefuseBtn)
  self.refusedLab = self:FindComponent("RefusedLab", UILabel, self.dateRoot)
  self.refusedLab.text = ZhString.GuildDateBattle_State_Refused
  self.preEnterLab = self:FindComponent("PreEnterLab", UILabel, self.dateRoot)
  self.preEnterLab.text = ZhString.GuildDateBattle_PreEnter
  self.inviteBtn = self:FindComponent("InviteBtn", UISprite)
  self.inviteLab = self:FindComponent("InviteLabel", UILabel, self.inviteBtn.gameObject)
  self.inviteLab.text = ZhString.GuildDateBattle_Invite
  self:AddClickEvent(self.inviteBtn.gameObject, function()
    self:OnClickInviteBtn()
  end)
  local fixedRoot = self:FindGO("Fixed")
  local fixed_Offensive_Side = self:FindComponent("Fixed_OffensiveSide", UILabel, fixedRoot)
  fixed_Offensive_Side.text = ZhString.GuildDateBattle_Offensive_Side
  local fixed_Defensive_Side = self:FindComponent("Fixed_DefensiveSide", UILabel, fixedRoot)
  fixed_Defensive_Side.text = ZhString.GuildDateBattle_Defensive_Side
  local fixed_Date = self:FindComponent("Fixed_Date", UILabel, fixedRoot)
  fixed_Date.text = ZhString.GuildDateBattle_Date
  self.fixed_DateColider = self:FindComponent("Fixed_DateColider", BoxCollider, fixed_Date.gameObject)
  self.fixed_DateArrow = self:FindGO("Fixed_DateArrow", fixed_Date.gameObject)
  self:AddClickEvent(self.fixed_DateColider.gameObject, function()
    self:OnClickDate()
  end)
  self.datePlayTweens = self.fixed_DateColider.gameObject:GetComponents(UIPlayTween)
  local fixed_Clock = self:FindComponent("Fixed_Clock", UILabel, fixedRoot)
  fixed_Clock.text = ZhString.GuildDateBattle_Time
  self.fixed_ClockColider = self:FindComponent("Fixed_ClockColider", BoxCollider, fixed_Clock.gameObject)
  self.fixed_ClockArrow = self:FindGO("Fixed_ClockArrow", fixed_Clock.gameObject)
  self:AddClickEvent(self.fixed_ClockColider.gameObject, function()
    self:OnClickClock()
  end)
  self.clockPlayTweens = self.fixed_ClockColider.gameObject:GetComponents(UIPlayTween)
  local fixed_Mode = self:FindComponent("Fixed_Mode", UILabel, fixedRoot)
  fixed_Mode.text = ZhString.GuildDateBattle_Record_Mode
  self.fixed_ModeColider = self:FindComponent("Fixed_ModeColider", BoxCollider, fixed_Mode.gameObject)
  self.fixed_ModeArrow = self:FindGO("Fixed_ModeArrow", fixed_Mode.gameObject)
  self:AddClickEvent(self.fixed_ModeColider.gameObject, function()
    self:OnClickMode()
  end)
  self.modePlayTweens = self.fixed_ModeColider.gameObject:GetComponents(UIPlayTween)
  self.baseModeOpen = GuildDateBattleProxy.CheckBaseModeOpen()
  self.fixed_ModeColider.enabled = self.baseModeOpen
  local right = self:FindGO("Right")
  self.modeNameLab = self:FindComponent("ModeName", UILabel, right)
  self.modeDescLab = self:FindComponent("ModeDesc", UILabel, right)
  self.modeDurationLab = self:FindComponent("ModeDuration", UILabel, right)
  self.bgTexture = self:FindComponent("BgTexture", UITexture, right)
  self.mapTexture = self:FindComponent("MapTexture", UITexture, right)
  _PictureManager:SetPaySignIn(_BgTextureName, self.bgTexture)
  self.texture = self:FindComponent("Texture", UITexture, right)
  self.offensiveSideLab = self:FindComponent("OffensiveSide", UILabel)
  self.defensiveSideLab = self:FindComponent("DefensiveSide", UILabel)
  self.defChatBtn = self:FindGO("DefChatBtn")
  self:AddClickEvent(self.defChatBtn, function()
    self:OnClickChatBtn(self.data.defLeaderId, self.data.defGuildName)
  end)
  self.offChatBtn = self:FindGO("OffChatBtn")
  self:AddClickEvent(self.offChatBtn, function()
    self:OnClickChatBtn(self.data.offLeaderId, self.data.atkGuildName)
  end)
  self.dateLab = self:FindComponent("Date", UILabel)
  self.dateLab.text = ZhString.GuildDateBattle_Empty
  self.timeLab = self:FindComponent("Time", UILabel)
  self.timeLab.text = ZhString.GuildDateBattle_Empty
  self.modeLab = self:FindComponent("Mode", UILabel)
  self.dateTipStick = self:FindComponent("DateTipStick", UIWidget)
  self.clockTipStick = self:FindComponent("ClockTipStick", UIWidget)
  self.winTexture = self:FindComponent("WinTexture", UITexture)
  self.winTexture1 = self:FindComponent("WinTexture_1", UITexture, self.winTexture.gameObject)
  self.winLab = self:FindComponent("WinnerLabel", UILabel, self.winTexture.gameObject)
  self.winLab1 = self:FindComponent("Label", UILabel, self.winLab.gameObject)
  self.winLab.text = ZhString.GuildDateBattle_State_Win
  self.winLab1.text = ZhString.GuildDateBattle_State_Win
  self.loseTexture = self:FindComponent("LoseTexture", UITexture)
  self.loseLabel = self:FindComponent("LoseLabel", UILabel, self.loseTexture.gameObject)
  self.loseLabel1 = self:FindComponent("Label", UILabel, self.loseLabel.gameObject)
  self.loseLabel.text = ZhString.GuildDateBattle_State_Failed
  self.loseLabel1.text = ZhString.GuildDateBattle_State_Failed
  self.loseTexture1 = self:FindComponent("LoseTexture_1", UITexture, self.loseTexture.gameObject)
  _PictureManager:SetPVP(_WinTextureName, self.winTexture)
  _PictureManager:SetPVP(_WinTextureName1, self.winTexture1)
  _PictureManager:SetPVP(_LoseTextureName, self.loseTexture)
  _PictureManager:SetPVP(_LoseTextureName1, self.loseTexture1)
  self.determinedColorSuccess, self.determinedColor = ColorUtil.TryParseHexString(_determinedColor)
  self.banCardTitle = self:FindComponent("Fixed_BanCard", UILabel)
  self.banCardTitle.text = ZhString.GuildDateBattle_BanCardTitle
  self.banCardGO = self:FindGO("BanCardCombineCell")
  self.banCardCell = BanCardCombineCell.new(self.banCardGO)
  self:InitGameMode()
  self.uiTable = self:FindComponent("Fixed", UITable)
end

function GuildDateBattleInviteView:InitGameMode()
  self.unDatedGameMode = self:FindComponent("UnDatedGameMode", UILabel)
  self.unDatedGameMode.text = ZhString.GuildDateBattle_Record_GameMode
  self.baseModeLab = self:FindComponent("Base_Mode", UILabel)
  self.baseModeLab.text = ZhString.GuildDateBattle_Mode_Base
  self.baseModeToggle = self:FindComponent("BaseToggle", UIToggle)
  if self.baseModeToggle then
    EventDelegate.Add(self.baseModeToggle.onChange, function()
      if self.baseModeToggle.value then
        self:OnBaseModeChoosed()
      end
    end)
  end
  self.deathModeLab = self:FindComponent("Death_Mode", UILabel)
  self.deathModeLab.text = ZhString.GuildDateBattle_Mode_Death
  self.deathModeDesc = self:FindComponent("Death_Mode_Desc", UILabel)
  self.deathModeToggle = self:FindComponent("DeathToggle", UIToggle)
  if self.deathModeToggle then
    EventDelegate.Add(self.deathModeToggle.onChange, function()
      if self.deathModeToggle.value then
        self:OnDeathModeChoosed()
      end
    end)
  end
  self.bloodModeLab = self:FindComponent("Blood_Mode", UILabel)
  self.bloodModeDesc = self:FindComponent("Blood_Mode_Desc", UILabel)
  self.bloodModeLab.text = ZhString.GuildDateBattle_Mode_Blood
  self.bloodModeToggle = self:FindComponent("BloodToggle", UIToggle)
  if self.bloodModeToggle then
    EventDelegate.Add(self.bloodModeToggle.onChange, function()
      if self.bloodModeToggle.value then
        self:OnBloodModeChoosed()
      end
    end)
  end
  self.datedGameMode = self:FindComponent("DatedGameMode", UILabel)
  self.datedGameMode.text = ZhString.GuildDateBattle_Record_GameMode
  self.datedGameMode_Base = self:FindGO("BaseMode", self.datedGameMode.gameObject)
  self.datedGameMode_Base_Mode_Desc = self:FindComponent("Base_Mode_Desc", UILabel, self.datedGameMode_Base)
  self.datedGameMode_Other = self:FindGO("OtherMode", self.datedGameMode.gameObject)
  self.datedGameMode_Other_Mode_Desc = self:FindComponent("Other_Mode_Desc", UILabel, self.datedGameMode_Other)
  self.currentSelectedMode = GuildCmd_pb.EGUILDDATEBATTLETYPE_BASE
  local config = GameConfig.GuildDateBattle.type_rule
  self.filterBloodCount = math.floor(config[GuildCmd_pb.EGUILDDATEBATTLETYPE_BLOOD][1])
  self.filterDeathCount = math.floor(config[GuildCmd_pb.EGUILDDATEBATTLETYPE_DEATH][1])
  self:InitDeathFilter()
  self:InitBloodFilter()
  self:UpdateModeUIGrayState()
end

function GuildDateBattleInviteView:OnBaseModeChoosed()
  self.currentSelectedMode = GuildCmd_pb.EGUILDDATEBATTLETYPE_BASE
  self:UpdateModeUIGrayState()
end

function GuildDateBattleInviteView:OnDeathModeChoosed()
  self.currentSelectedMode = GuildCmd_pb.EGUILDDATEBATTLETYPE_DEATH
  self:UpdateModeUIGrayState()
end

function GuildDateBattleInviteView:OnBloodModeChoosed()
  self.currentSelectedMode = GuildCmd_pb.EGUILDDATEBATTLETYPE_BLOOD
  self:UpdateModeUIGrayState()
end

function GuildDateBattleInviteView:InitDeathFilter()
  self.deathPopupObj = self:FindGO("DeathPopupList")
  self.deathlistContainer = self:FindGO("listContainer", self.deathPopupObj)
  self.deathFilterColider = self.deathPopupObj:GetComponent(BoxCollider)
  if not self.deathPopupList then
    self.deathPopupList = PopupGridList.new(self.deathPopupObj, function(self, data)
      if self.selectDeathTabData ~= data then
        self.selectDeathTabData = data
        self.filterDeathCount = math.floor(data.num)
      end
    end, self, self:FindComponent("DeathFilterPanel", UIPanel).depth + 2, nil, nil, true, 150, true)
    self:SetDeathFilter()
  end
end

local deathListPopUpItems = {}

function GuildDateBattleInviteView:SetDeathFilter()
  TableUtility.ArrayClear(deathListPopUpItems)
  local options = GameConfig.GuildDateBattle.type_rule[GuildCmd_pb.EGUILDDATEBATTLETYPE_DEATH]
  for i = 1, #options do
    local data = {}
    data.name = tostring(options[i])
    data.num = options[i]
    table.insert(deathListPopUpItems, data)
  end
  self.deathPopupList:SetData(deathListPopUpItems)
end

function GuildDateBattleInviteView:InitBloodFilter()
  self.bloodPopupObj = self:FindGO("BloodPopupList")
  self.bloodlistContainer = self:FindGO("listContainer", self.bloodPopupObj)
  self.bloodFilterColider = self.bloodPopupObj:GetComponent(BoxCollider)
  if not self.bloodPopupList then
    self.bloodPopupList = PopupGridList.new(self.bloodPopupObj, function(self, data)
      if self.selectBloodTabData ~= data then
        self.selectBloodTabData = data
        self.filterBloodCount = math.floor(data.num)
      end
    end, self, self:FindComponent("BloodFilterPanel", UIPanel).depth + 2, nil, nil, true, 150, true)
    self:SetBloodFilter()
  end
end

local bloodListPopUpItems = {}

function GuildDateBattleInviteView:SetBloodFilter()
  TableUtility.ArrayClear(bloodListPopUpItems)
  local options = GameConfig.GuildDateBattle.type_rule[GuildCmd_pb.EGUILDDATEBATTLETYPE_BLOOD]
  for i = 1, #options do
    local data = {}
    data.name = tostring(options[i])
    data.num = options[i]
    table.insert(bloodListPopUpItems, data)
  end
  self.bloodPopupList:SetData(bloodListPopUpItems)
end

function GuildDateBattleInviteView:SetUILabelGray(label, isGray)
  if not label then
    return
  end
  if isGray then
    label.color = ColorUtil.NGUIGray
  else
    label.color = ColorUtil.PVPBlackLabel
  end
end

function GuildDateBattleInviteView:UpdateModeUIGrayState()
  if self.currentSelectedMode == GuildCmd_pb.EGUILDDATEBATTLETYPE_DEATH then
    self:SetUILabelGray(self.bloodModeLab, true)
    self:SetUILabelGray(self.bloodModeDesc, true)
    self:SetUILabelGray(self.deathPopupList.labCurrent, false)
    self:SetUILabelGray(self.bloodPopupList.labCurrent, true)
    self:SetUILabelGray(self.deathModeLab, false)
    self:SetUILabelGray(self.deathModeDesc, false)
    self:SetUILabelGray(self.baseModeLab, true)
    self.bloodFilterColider.enabled = false
    self.deathFilterColider.enabled = true
  elseif self.currentSelectedMode == GuildCmd_pb.EGUILDDATEBATTLETYPE_BLOOD then
    self:SetUILabelGray(self.baseModeLab, true)
    self:SetUILabelGray(self.deathModeLab, true)
    self:SetUILabelGray(self.deathModeDesc, true)
    self:SetUILabelGray(self.bloodPopupList.labCurrent, false)
    self:SetUILabelGray(self.deathPopupList.labCurrent, true)
    self:SetUILabelGray(self.bloodModeLab, false)
    self:SetUILabelGray(self.bloodModeDesc, false)
    self.deathFilterColider.enabled = false
    self.bloodFilterColider.enabled = true
  elseif self.currentSelectedMode == GuildCmd_pb.EGUILDDATEBATTLETYPE_BASE then
    self:SetUILabelGray(self.deathModeLab, true)
    self:SetUILabelGray(self.deathModeDesc, true)
    self:SetUILabelGray(self.bloodModeLab, true)
    self:SetUILabelGray(self.bloodModeDesc, true)
    self:SetUILabelGray(self.baseModeLab, false)
    self:SetUILabelGray(self.bloodPopupList.labCurrent, true)
    self:SetUILabelGray(self.deathPopupList.labCurrent, true)
    self.deathFilterColider.enabled = false
    self.bloodFilterColider.enabled = false
  end
end

function GuildDateBattleInviteView:CombineBanCards()
  return self.banCardCell:GetID()
end

function GuildDateBattleInviteView:OnEnter()
  self.data = self.viewdata.viewdata and self.viewdata.viewdata.data
  GuildDateBattleInviteView.super.OnEnter(self)
  self:SetData()
end

function GuildDateBattleInviteView:OnExit()
  self:ClearCacheDate()
  TimeTickManager.Me():ClearTick(self)
  _PictureManager:UnLoadPaySignIn(_BgTextureName, self.bgTexture)
  _PictureManager:UnLoadPVP(_WinTextureName, self.winTexture)
  _PictureManager:UnLoadPVP(_WinTextureName1, self.winTexture1)
  _PictureManager:UnLoadPVP(_LoseTextureName, self.loseTexture)
  _PictureManager:UnLoadPVP(_LoseTextureName1, self.loseTexture1)
  _PictureManager:UnLoadMiniMap(self.mapTextureName, self.mapTexture)
  if self.changeToPreEnter then
    _DateProxy:BrowseRedtip(GuildDataBattle_ReadyRed, self.data.id)
  end
  GuildDateBattleInviteView.super.OnExit(self)
end

function GuildDateBattleInviteView:OnClickDate()
  local data = _DateProxy:GetStampData()
  if data then
    self:PlayRevertTween(self.clockPlayTweens)
    self:PlayRevertTween(self.modePlayTweens)
    TipsView.Me():HideCurrent()
    local callback = function()
      if self.__destroyed then
        return
      end
      self:PlayRevertTween(self.datePlayTweens)
    end
    local sdata = {
      data = data,
      callback = callback,
      callbackParam = self
    }
    TipManager.Instance:ShowGuildDateBattleTip(sdata, self.dateTipStick, NGUIUtil.AnchorSide.Right, {0, 200})
  end
end

function GuildDateBattleInviteView:OnClickClock()
  local clock_array = GuildDateBattleProxy.GetStaticSchedule()
  if clock_array then
    self:PlayRevertTween(self.datePlayTweens)
    self:PlayRevertTween(self.modePlayTweens)
    TipsView.Me():HideCurrent()
    local callback = function()
      if self.__destroyed then
        return
      end
      self:PlayRevertTween(self.clockPlayTweens)
    end
    local sdata = {
      data = clock_array,
      callback = callback,
      callbackParam = self
    }
    TipManager.Instance:ShowGuildDateBattleClockTip(sdata, self.clockTipStick, NGUIUtil.AnchorSide.Right, {0, 200})
  end
end

function GuildDateBattleInviteView:OnClickMode()
  local mode_array = GuildDateBattleProxy.Instance:GetModeTipData()
  if mode_array then
    self:PlayRevertTween(self.datePlayTweens)
    self:PlayRevertTween(self.clockPlayTweens)
    TipsView.Me():HideCurrent()
    local callback = function()
      if self.__destroyed then
        return
      end
      self:PlayRevertTween(self.modePlayTweens)
    end
    local sdata = {
      data = mode_array,
      callback = callback,
      callbackParam = self
    }
    TipManager.Instance:ShowGuildDateBattleModeTip(sdata, self.dateTipStick, NGUIUtil.AnchorSide.Right, {0, -65})
  end
end

function GuildDateBattleInviteView:OnClickChatBtn(guid, name)
  local tempArray = ReusableTable.CreateArray()
  tempArray[1] = guid
  ServiceSessionSocialityProxy.Instance:CallAddRelation(tempArray, SocialManager.PbRelation.Chat)
  ReusableTable.DestroyArray(tempArray)
  local ptdata = PlayerTipData.new()
  ptdata.id = guid
  ptdata.name = ""
  ptdata.headData = HeadImageData.new()
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.ChatRoomPage,
    viewdata = {
      key = "PrivateChat"
    }
  })
  GameFacade.Instance:sendNotification(ChatRoomEvent.UpdateSelectChat, ptdata)
  self:CloseSelf()
end

function GuildDateBattleInviteView:OnClickInviteBtn()
  if not self.data then
    return
  end
  if not GuildProxy.Instance:ImGuildChairman() then
    MsgManager.ShowMsgByID(43560)
    return
  end
  local def_guild_id = self.data.defGuildid
  if not def_guild_id then
    return
  end
  local y, m, d, h = _DateProxy:GetDate()
  if not y or not h then
    return
  end
  if self:CheckDateExipire() then
    MsgManager.ShowMsgByID(43548)
    return
  end
  local stamp = os.time({
    year = y,
    month = m,
    day = d,
    hour = h,
    min = 0,
    sec = 0
  })
  self.data.stamp = math.floor(stamp)
  local ban_cards = self:CombineBanCards()
  local target_count = 0
  if self.currentSelectedMode == GuildCmd_pb.EGUILDDATEBATTLETYPE_DEATH then
    target_count = self.filterDeathCount
  elseif self.currentSelectedMode == GuildCmd_pb.EGUILDDATEBATTLETYPE_BLOOD then
    target_count = self.filterBloodCount
  end
  _DateProxy:CallInvite(def_guild_id, ban_cards, self.currentSelectedMode, target_count)
end

function GuildDateBattleInviteView:OnClickAgreeBtn()
  if not self.data then
    return
  end
  _DateProxy:CallAgreeInvite(self.data.id)
end

function GuildDateBattleInviteView:OnClickRefuseBtn()
  if not self.data then
    return
  end
  local name = self.data:GetOppositeGuildName()
  _DateProxy:CallRefuseInvite(self.data.id, name)
end

function GuildDateBattleInviteView:SetByConfig()
  if not self.data then
    return
  end
  self.modeDurationLab.text = string.format(ZhString.GuildDateBattle_Duration, self.data:GetModeDuration() // 60)
  self.modeDescLab.text = self.data:GetModeDesc()
  self.modeLab.text = self.data:GetModeName()
  self.modeNameLab.text = self.data:GetModeName()
  self.mapTextureName = _DateProxy:GetMiniMapTextureName(self.data.mode)
  _PictureManager:SetMiniMap(self.mapTextureName, self.mapTexture)
end

function GuildDateBattleInviteView:SetDate(note)
  local date = note.body
  if not date then
    return
  end
  if self.chooseDate ~= date then
    _DateProxy:SetCurDate(date)
    self.chooseDate = date
    local curDate = os.date("*t", date)
    self.dateLab.text = string.format(ZhString.GuildDateBattle_DateFmt, curDate.year, curDate.month, curDate.day)
    self.dateLab.color = self.determinedColor
    self:PlayRevertTween(self.datePlayTweens)
    self:TrySetInviteBtnGray()
  end
end

function GuildDateBattleInviteView:ClearCacheDate()
  self.chooseDate = nil
  _DateProxy:ClearCacheDate()
end

function GuildDateBattleInviteView:SetDatedTime()
  if not self.data then
    return
  end
  self.dateLab.text = string.format(ZhString.GuildDateBattle_DateFmt, self.data.year, self.data.month, self.data.day)
  self.dateLab.color = self.determinedColor
  self.timeLab.text = string.format(ZhString.GuildDateBattle_Clock, self.data.hour)
  self.timeLab.color = self.determinedColor
end

function GuildDateBattleInviteView:TrySetInviteBtnGray()
  local y, m, d, h = _DateProxy:GetDate()
  local isLeader = GuildProxy.Instance:ImGuildChairman()
  if not (y and h) or not isLeader then
    self:GrayInviteBtn(true)
  elseif self:CheckDateExipire() then
    self:GrayInviteBtn(true)
  else
    self:GrayInviteBtn(false)
  end
end

function GuildDateBattleInviteView:CheckDateExipire()
  local y, m, d, h = _DateProxy:GetDate()
  if not y or not h then
    return
  end
  local stamp = os.time({
    year = y,
    month = m,
    day = d,
    hour = h,
    min = 0,
    sec = 0
  })
  local curServerTime = ServerTime.CurServerTime() / 1000
  if stamp <= curServerTime then
    return true
  end
  local last_approval_time = GameConfig.GuildDateBattle and GameConfig.GuildDateBattle.last_approval_time or 600
  if last_approval_time > stamp - curServerTime then
    return true
  end
  return false
end

function GuildDateBattleInviteView:SetClockTime(note)
  local clock = note.body
  if not clock then
    return
  end
  _DateProxy:SetCurClock(clock)
  self.timeLab.text = string.format(ZhString.GuildDateBattle_Clock, clock)
  self.timeLab.color = self.determinedColor
  self:PlayRevertTween(self.clockPlayTweens)
  self:TrySetInviteBtnGray()
end

function GuildDateBattleInviteView:SetMode(note)
  local mode = note.body
  if not mode then
    return
  end
  _DateProxy:SetCurMode(mode)
  self.data:ResetMode(mode)
  self.modeLab.text = GuildDateBattleProxy.GetModeName(mode)
  self:PlayRevertTween(self.modePlayTweens)
  self:SetByConfig()
end

function GuildDateBattleInviteView:PlayRevertTween(tweens)
  for i = 1, #tweens do
    tweens[i]:Play(false)
  end
end

function GuildDateBattleInviteView:SetData()
  self:SetState()
  self:UpdateChat()
  self:SetByConfig()
  self:SetGuild()
  self:SetBanCard()
  self.uiTable:Reposition()
end

function GuildDateBattleInviteView:SetBanCard()
  if not self.data then
    return
  end
  self.banCardCell:SetData(self.data:GetBanCardIds())
end

function GuildDateBattleInviteView:SetGuild()
  if not self.data then
    return
  end
  self.offensiveSideLab.text = self.data.atkGuildName
  self.defensiveSideLab.text = self.data.defGuildName
end

function GuildDateBattleInviteView:UpdateChat()
  if not self.data then
    return
  end
  local isDated = _DateProxy:IsDated(self.data.id)
  local isLeader = GuildProxy.Instance:ImGuildChairman()
  if not isLeader or self.data.id == 0 or not isDated then
    self:Hide(self.defChatBtn)
    self:Hide(self.offChatBtn)
    return
  end
  local my_guild_id = GuildProxy.Instance:GetOwnGuildID()
  self.defChatBtn:SetActive(self.data.atkGuildid == my_guild_id)
  self.offChatBtn:SetActive(self.data.defGuildid == my_guild_id)
end

function GuildDateBattleInviteView:SetState()
  self:ClearTick()
  local isDated = _DateProxy:IsDated(self.data.id)
  self.fixed_DateColider.enabled = not isDated
  self.fixed_ClockColider.enabled = not isDated
  self.fixed_ModeColider.enabled = not isDated
  self.banCardCell:SetOptionEnable(not isDated)
  self.fixed_DateArrow:SetActive(not isDated)
  self.fixed_ClockArrow:SetActive(not isDated)
  self.fixed_ModeArrow:SetActive(not isDated and self.baseModeOpen)
  self.unDatedGameMode.gameObject:SetActive(not isDated)
  self.datedGameMode.gameObject:SetActive(isDated)
  if isDated then
    self:Hide(self.inviteBtn)
    self:Show(self.dateRoot)
    self:SetDateState()
    local gameMode = self.data:GetGameMode()
    if gameMode == GuildCmd_pb.EGUILDDATEBATTLETYPE_BASE then
      self.datedGameMode_Base:SetActive(true)
      self.datedGameMode_Other:SetActive(false)
      self.datedGameMode_Base_Mode_Desc.text = self.data:GetDatedModeDesc()
    elseif gameMode == GuildCmd_pb.EGUILDDATEBATTLETYPE_DEATH or gameMode == GuildCmd_pb.EGUILDDATEBATTLETYPE_BLOOD then
      self.datedGameMode_Base:SetActive(false)
      self.datedGameMode_Other:SetActive(true)
      self.datedGameMode_Other_Mode_Desc.text = self.data:GetDatedModeDesc()
    end
  else
    _DateProxy:QueryTargetGuild(self.data.defGuildid)
    self:Hide(self.dateRoot)
    self:Show(self.inviteBtn)
    self:TrySetInviteBtnGray()
  end
  self.winTexture.gameObject:SetActive(self.data:IsWin())
  self.loseTexture.gameObject:SetActive(self.data:IsFailed())
  local finished = self.data:IsFinished()
  self.titleLab.gameObject:SetActive(not finished)
  self.invalidLab.gameObject:SetActive(self.data:IsInValid())
  self.bgSp.height = finished and 570 or 636
  local yAxisOffset = finished and -40 or 0
  LuaGameObject.SetLocalPositionGO(self.root, 0, yAxisOffset, 0)
end

function GuildDateBattleInviteView:GrayInviteBtn(var)
  if var then
    self.inviteBtn.spriteName = "com_btn_13"
    self.inviteLab.effectColor = ColorUtil.TitleGray
  else
    self.inviteBtn.spriteName = "com_btn_1"
    self.inviteLab.effectColor = ColorUtil.TitleBlue
  end
end

function GuildDateBattleInviteView:SetDateState()
  if not self.data then
    return
  end
  self:SetDatedTime()
  local bgColor
  if self.data:IsUnderApproval() then
    if GuildProxy.Instance:ImGuildChairman() and self.data:IsUnderApproval_Me() then
      self:Hide(self.approvalLab)
      self:Show(self.approvalRoot)
      self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateAutoRefuse, self)
    else
      self:Hide(self.approvalRoot)
      self:Show(self.approvalLab)
      self.approvalLab.text = self.data:GetComplexStateStr()
      bgColor = _BgColor.Approval
    end
  else
    self:Hide(self.approvalRoot)
    self:Hide(self.approvalLab)
  end
  if self.data:IsRefused() then
    bgColor = _BgColor.Refuse
  elseif self.data:IsPreEnter() then
    bgColor = _BgColor.PreEnter
  end
  if nil ~= bgColor then
    self:Show(self.dateBg[1])
    local _, c = ColorUtil.TryParseHexString(bgColor)
    for k, v in pairs(self.dateBg) do
      v.color = c
    end
  else
    self:Hide(self.dateBg[1])
  end
  self.refusedLab.gameObject:SetActive(self.data:IsRefused())
  self.preEnterLab.gameObject:SetActive(self.data:IsPreEnter())
end

function GuildDateBattleInviteView:ClearTick()
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self)
    self.timeTick = nil
  end
end

local day_hour = 24

function GuildDateBattleInviteView:UpdateAutoRefuse()
  local refuseStamp = self.data:GetAutoRefuseTime()
  local curTime = ServerTime.CurServerTime() / 1000
  local delta = refuseStamp - curTime
  if delta <= 0 then
    _DateProxy:SetClientRefused(self.data.id)
    self:ClearTick()
  else
    local d, h, m, s = ClientTimeUtil.FormatTimeBySec(delta)
    self.approvalRefuseLab.text = string.format(ZhString.GuildDateBattle_RefuseCD, d * day_hour + h, m, s)
  end
end
