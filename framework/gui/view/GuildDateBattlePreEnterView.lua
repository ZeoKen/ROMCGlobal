autoImport("BanCardCombineCell")
GuildDateBattlePreEnterView = class("GuildDateBattlePreEnterView", ContainerView)
GuildDateBattlePreEnterView.ViewType = UIViewType.PopUpLayer
GuildDateBattlePreEnterView.m_helpId = 1838
local _PictureManager, _DateProxy
local _BgTextureName = "sign_7_bg3"

function GuildDateBattlePreEnterView:Init()
  _DateProxy = GuildDateBattleProxy.Instance
  _PictureManager = PictureManager.Instance
  self:FindObjs()
  self:AddEvts()
end

function GuildDateBattlePreEnterView:AddEvts()
  self:AddListenEvt(ServiceEvent.GuildCmdDateBattleOpenGuildCmd, self.HandleEntrance)
end

function GuildDateBattlePreEnterView:HandleEntrance()
  if not self.data then
    return
  end
  if _DateProxy:IsOpen() then
    self:CloseSelf()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.GuildDateBattleEntranceView
    })
  end
end

function GuildDateBattlePreEnterView:FindObjs()
  self.root = self:FindGO("Root")
  self.bgSp = self:FindComponent("Bg", UISprite)
  self.titleLab = self:FindComponent("Title", UILabel)
  self.titleLab.text = ZhString.GuildDateBattle_PreEnterTitle
  self.preEntranceDateRoot = self:FindGO("EntrancePreEnter")
  self.enterLab = self:FindComponent("EnterLabel", UILabel, self.preEntranceDateRoot)
  self.enterLab.text = ZhString.GuildDateBattle_EnterMap
  self.checkLab = self:FindComponent("CheckLabel", UILabel, self.preEntranceDateRoot)
  self.checkLab.text = ZhString.GuildDateBattle_CheckInfo
  local fixedRoot = self:FindGO("Fixed")
  local fixed_Offensive_Side = self:FindComponent("Fixed_OffensiveSide", UILabel, fixedRoot)
  fixed_Offensive_Side.text = ZhString.GuildDateBattle_Offensive_Side
  local fixed_Defensive_Side = self:FindComponent("Fixed_DefensiveSide", UILabel, fixedRoot)
  fixed_Defensive_Side.text = ZhString.GuildDateBattle_Defensive_Side
  local fixed_Date = self:FindComponent("Fixed_Date", UILabel, fixedRoot)
  fixed_Date.text = ZhString.GuildDateBattle_Date
  local fixed_Clock = self:FindComponent("Fixed_Clock", UILabel, fixedRoot)
  fixed_Clock.text = ZhString.GuildDateBattle_Time
  local fixed_Mode = self:FindComponent("Fixed_Mode", UILabel, fixedRoot)
  fixed_Mode.text = ZhString.GuildDateBattle_Record_Mode
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
  self.defChatBtn = self:FindGO("DefChatBtn", right)
  self:AddClickEvent(self.defChatBtn, function()
    self:OnClickChatBtn(self.data.defLeaderId, self.data.defGuildName)
  end)
  self.offChatBtn = self:FindGO("OffChatBtn", right)
  self:AddClickEvent(self.offChatBtn, function()
    self:OnClickChatBtn(self.data.offLeaderId, self.data.atkGuildName)
  end)
  self.dateLab = self:FindComponent("Date", UILabel)
  self.dateLab.text = ZhString.GuildDateBattle_Empty
  self.timeLab = self:FindComponent("Time", UILabel)
  self.timeLab.text = ZhString.GuildDateBattle_Empty
  self.modeLab = self:FindComponent("Mode", UILabel)
  self.banCardTitle = self:FindComponent("BanCardTitle", UILabel)
  self.banCardTitle.text = ZhString.GuildDateBattle_BanCardTitle
  self.banCardGO = self:FindGO("BanCardCombineCell")
  self.banCardCell = BanCardCombineCell.new(self.banCardGO)
end

function GuildDateBattlePreEnterView:OnEnter()
  self.data = self.viewdata.viewdata and self.viewdata.viewdata.data
  GuildDateBattlePreEnterView.super.OnEnter(self)
  self:SetData()
end

function GuildDateBattlePreEnterView:OnExit()
  _PictureManager:UnLoadPaySignIn(_BgTextureName, self.bgTexture)
  _PictureManager:UnLoadMiniMap(self.mapTextureName, self.mapTexture)
  GuildDateBattlePreEnterView.super.OnExit(self)
end

function GuildDateBattlePreEnterView:OnClickChatBtn(guid, name)
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

function GuildDateBattlePreEnterView:SetData()
  self:SetDatedTime()
  self:SetChat()
  self:SetByConfig()
  self:SetGuild()
  self:SetBanCard()
end

function GuildDateBattlePreEnterView:SetBanCard()
  if not self.data then
    return
  end
  self.banCardCell:SetData(self.data:GetBanCardIds(true))
  self.banCardCell:SetOptionEnable(false)
end

function GuildDateBattlePreEnterView:SetDatedTime()
  if not self.data then
    return
  end
  self.dateLab.text = string.format(ZhString.GuildDateBattle_DateFmt, self.data.year, self.data.month, self.data.day)
  self.timeLab.text = string.format(ZhString.GuildDateBattle_Clock, self.data.hour)
end

function GuildDateBattlePreEnterView:SetChat()
  if not self.data then
    return
  end
  local my_guild_id = GuildProxy.Instance:GetOwnGuildID()
  self.defChatBtn:SetActive(self.data.atkGuildid == my_guild_id)
  self.offChatBtn:SetActive(self.data.defGuildid == my_guild_id)
end

function GuildDateBattlePreEnterView:SetByConfig()
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

function GuildDateBattlePreEnterView:SetGuild()
  if not self.data then
    return
  end
  self.offensiveSideLab.text = self.data.atkGuildName
  self.defensiveSideLab.text = self.data.defGuildName
end
