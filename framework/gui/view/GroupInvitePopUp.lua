GroupInvitePopUp = class("GroupInvitePopUp", ContainerView)
GroupInvitePopUp.ViewType = UIViewType.PopUpLayer
autoImport("WrapCellHelper")
autoImport("TeamInvitee")
autoImport("GroupInviteMembCell")
GroupInvitePopUp.TabName = {
  FriendTog = ZhString.TeamInvitePopUp_FriendTog,
  GHTog = ZhString.TeamInvitePopUp_GuideTog
}
local teamProxy
local tabNameTipOffset = {140, -58}

function GroupInvitePopUp:Init()
  teamProxy = TeamProxy.Instance
  self:MapViewListenEvent()
  self:InitView()
end

function GroupInvitePopUp:InitView()
  local wrapContent = self:FindGO("MemberWrap")
  local wrapConfig = {
    wrapObj = wrapContent,
    pfbNum = 5,
    cellName = "GroupInviteMembCell",
    control = GroupInviteMembCell
  }
  self.wraplist = WrapCellHelper.new(wrapConfig)
  self.wraplist:AddEventListener(MouseEvent.MouseClick, self.ClickMemberEvent, self)
  local friendTog, guildTog = self:FindGO("FriendTog"), self:FindGO("GHTog")
  self.togMap = {friendTog, guildTog}
  self:AddTabEvent(friendTog, function(go, value)
    self:UpdateMyFriends()
  end)
  self:AddTabEvent(guildTog, function(go, value)
    self:UpdateMyGuildMembers()
  end)
  self.noneTip = self:FindGO("NoneTip")
  self.noneTipLabel = self.noneTip:GetComponent(UILabel)
  self.noneTipSp = self:FindGO("NoneTipSp", self.noneTip)
  for i, v in ipairs(self.togMap) do
    local longPress = v:GetComponent(UILongPress)
    
    function longPress.pressEvent(obj, state)
      self:PassEvent(TipLongPressEvent.GroupInvitePopUp, {
        state,
        obj.gameObject
      })
    end
  end
  self:AddEventListener(TipLongPressEvent.GroupInvitePopUp, self.HandleLongPress, self)
  if not GameConfig.SystemForbid.TabNameTip then
    self.usingIcon = true
  else
    self.usingIcon = false
  end
  self.tabLabelList = {}
  self.tabIconSpList = {}
  for i, v in ipairs(self.togMap) do
    local icon = Game.GameObjectUtil:DeepFindChild(v, "Icon")
    icon:SetActive(self.usingIcon)
    self.tabIconSpList[#self.tabIconSpList + 1] = icon:GetComponent(UISprite)
    local label = Game.GameObjectUtil:DeepFindChild(v, "Label")
    label:SetActive(not self.usingIcon)
    self.tabLabelList[#self.tabLabelList + 1] = label:GetComponent(UILabel)
  end
  self.nowTog = 1
  self:UpdateMyFriends()
end

function GroupInvitePopUp:ClickMemberEvent(cellCtl)
  if cellCtl then
    if cellCtl.eventType == "CloseUI" then
      self:CloseSelf()
    elseif cellCtl.eventType == "Invite" then
      local data = cellCtl.data
      if not teamProxy:CheckIHaveLeaderAuthority() then
        return
      end
      if not self.invitee then
        self.invitee = TeamInvitee.new()
      end
      self.invitee:SetId(data.id, nil)
      local cb = function()
        cellCtl:ActiveInviteButton(false)
      end
      FunctionTeamInvite.Me():InviteGroup(self.invitee, cb)
    end
  end
end

function GroupInvitePopUp:UpdateMyFriends()
  self:SetChooseInviteTogState(1)
  self.nowTog = 1
  local list = {}
  local friendDatas = FriendProxy.Instance:GetOnlineFriendData()
  for i = 1, #friendDatas do
    local isInGroup = false
    if friendDatas[i].guid then
      isInGroup = teamProxy:IsInMyGroup(friendDatas[i].guid)
    end
    if not isInGroup then
      local inviteData = {}
      inviteData.id = friendDatas[i].guid
      inviteData.type = TeamInviteMemberType.Friend
      inviteData.teamname = friendDatas[i].teamname
      inviteData.data = friendDatas[i]
      table.insert(list, inviteData)
    end
  end
  self:UpdateInfo(list)
end

function GroupInvitePopUp:UpdateMyGuildMembers()
  self:SetChooseInviteTogState(2)
  self.nowTog = 2
  local list = {}
  local myGuildData = GuildProxy.Instance.myGuildData
  if myGuildData then
    local gmembers = GuildProxy.Instance.myGuildData:GetMemberList()
    for i = 1, #gmembers do
      local gmemb = gmembers[i]
      if gmemb.id ~= Game.Myself.data.id then
        local isInGroup = teamProxy:IsInMyGroup(gmemb.id)
        if not isInGroup then
          local inviteData = {}
          inviteData.id = gmemb.id
          inviteData.type = TeamInviteMemberType.GuildMember
          inviteData.teamname = gmemb.teamname
          inviteData.data = gmemb
          table.insert(list, inviteData)
        end
      end
    end
  end
  self:UpdateInfo(list)
end

function GroupInvitePopUp:SetChooseInviteTogState(tog)
  local chooseColor, unchooseColor = Color(0.18823529411764706, 0.2549019607843137, 0.5764705882352941), Color(0.615686274509804, 0.615686274509804, 0.615686274509804)
  for i = 1, #self.togMap do
    if self.usingIcon then
      if tog == i then
        self.tabIconSpList[i].color = chooseColor
      else
        self.tabIconSpList[i].color = unchooseColor
      end
    elseif tog == i then
      self.tabLabelList[i].color = chooseColor
    else
      self.tabLabelList[i].color = unchooseColor
    end
  end
end

function GroupInvitePopUp:UpdateInfo(list)
  self.wraplist:UpdateInfo(list)
  self.wraplist:ResetPosition()
  self.noneTipLabel.text = ZhString.TeamInvitePopUp_NoMemberTip
  self.noneTip:SetActive(#list == 0)
end

function GroupInvitePopUp:MapViewListenEvent()
  self:AddListenEvt(ServiceEvent.SessionSocialityQuerySocialData, self.HandleGetSocialityClientQuerySocialData)
  self:AddListenEvt(ServiceEvent.SessionSocialitySocialDataUpdate, self.HandleSocialDataUpdate)
  self:AddListenEvt(ServiceEvent.GuildCmdGuildMemberUpdateGuildCmd, self.HandleGuildDataUpdate)
  self:AddListenEvt(ServiceEvent.GuildCmdGuildMemberDataUpdateGuildCmd, self.HandleGuildDataUpdate)
  self:AddListenEvt(ServiceEvent.SessionTeamTeamDataUpdate, self.HandleTeamDataUpdate)
end

function GroupInvitePopUp:HandleGuildDataUpdate(note)
  if self.nowTog == 2 then
    self:UpdateMyGuildMembers()
  end
end

function GroupInvitePopUp:HandleSocialDataUpdate(note)
  if self.nowTog == 1 then
    self:UpdateMyFriends()
  end
end

function GroupInvitePopUp:HandleGetSocialityClientQuerySocialData(note)
  helplog("Handle-->GetSocialityClientQuerySocialData")
  if self.nowTog == 1 then
    self:UpdateMyFriends()
  end
end

function GroupInvitePopUp:HandleTeamDataUpdate(note)
  if TeamProxy.Instance:IHaveGroup() then
    self:CloseSelf()
  end
end

function GroupInvitePopUp:OnEnter()
  GroupInvitePopUp.super.OnEnter(self)
  ServiceSessionSocialityProxy.Instance:CallFrameStatusSocialCmd(true)
  ServiceGuildCmdProxy.Instance:CallFrameStatusGuildCmd(true)
end

function GroupInvitePopUp:OnExit()
  self:UpdateInfo({})
  ServiceSessionSocialityProxy.Instance:CallFrameStatusSocialCmd(false)
  ServiceGuildCmdProxy.Instance:CallFrameStatusGuildCmd(false)
  GroupInvitePopUp.super.OnExit(self)
end

function GroupInvitePopUp:OnDestroy()
  self.wraplist:Destroy()
  GroupInvitePopUp.super.OnDestroy(self)
end

function GroupInvitePopUp:HandleLongPress(param)
  local isPressing, go = param[1], param[2]
  TabNameTip.OnLongPress(isPressing, GroupInvitePopUp.TabName[go.name], true, self:FindComponent("Sprite", UISprite, go), nil, tabNameTipOffset)
end
