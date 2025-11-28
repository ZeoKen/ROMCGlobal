TeamInvitePopUp = class("TeamInvitePopUp", ContainerView)
TeamInvitePopUp.ViewType = UIViewType.PopUpLayer
autoImport("WrapCellHelper")
autoImport("TeamInvitee")
autoImport("TeamInviteMembCell")
TeamInvitePopUp.TabName = {
  FriendTog = ZhString.TeamInvitePopUp_FriendTog,
  GHTog = ZhString.TeamInvitePopUp_GuideTog,
  OldFriend = ZhString.TeamInvitePopUp_TeammateTog,
  HireTog = ZhString.TeamInvitePopUp_HireTog
}
local PageIndex = {
  E_Friend = 1,
  E_Guild = 2,
  E_OldFriend = 3,
  E_MercenaryCat = 4
}
local teamProxy
local tabNameTipOffset = {140, -58}

function TeamInvitePopUp:Init()
  teamProxy = TeamProxy.Instance
  self.invitee = TeamInvitee.new()
  self.waitSearchData = {}
  self:MapViewListenEvent()
  self:InitView()
end

function TeamInvitePopUp:InitView()
  local wrapContent = self:FindGO("MemberWrap")
  local wrapConfig = {
    wrapObj = wrapContent,
    pfbNum = 5,
    cellName = "TeamInviteMembCell",
    control = TeamInviteMembCell
  }
  self.wraplist = WrapCellHelper.new(wrapConfig)
  self.wraplist:AddEventListener(MouseEvent.MouseClick, self.ClickMemberEvent, self)
  self.searchRoot = self:FindGO("SearchRoot")
  self.searchContentInputLabel = self:FindComponent("ContentInputLabel", UILabel)
  self.searchContentInputLabel.text = ZhString.Friend_SearchContent
  self.contentInput = self:FindGO("ContentInput"):GetComponent(UIInput)
  EventDelegate.Set(self.contentInput.onChange, function()
    self:OnInputChanged()
  end)
  UIUtil.LimitInputCharacter(self.contentInput, 16)
  local searchBtn = self:FindGO("SearchBtn")
  self.searchLab = self:FindComponent("Label", UILabel, searchBtn)
  self.searchLab.text = ZhString.GuildFindPage_Search
  self:AddClickEvent(searchBtn, function(g)
    self:OnSearch(g)
  end)
  local searchWrapContent = self:FindGO("SearchMemberWrap")
  local searchWrapConfig = {
    wrapObj = searchWrapContent,
    pfbNum = 5,
    cellName = "TeamInviteMembCell",
    control = TeamInviteMembCell
  }
  self.searchWraplist = WrapCellHelper.new(searchWrapConfig)
  self.searchWraplist:AddEventListener(MouseEvent.MouseClick, self.ClickMemberEvent, self)
  self:InitInviteAllGuildMembers()
  local friendTog, guildTog = self:FindGO("FriendTog"), self:FindGO("GHTog")
  self.lastfriendTog, self.hireTog = self:FindGO("OldFriend"), self:FindGO("HireTog")
  self.togMap = {
    friendTog,
    guildTog,
    self.lastfriendTog,
    self.hireTog
  }
  self:AddTabEvent(friendTog, function(go, value)
    self:UpdateMyFriends()
  end)
  self:AddTabEvent(guildTog, function(go, value)
    self:UpdateMyGuildMembers()
  end)
  self:AddTabEvent(self.lastfriendTog, function(go, value)
    self:UpdateNearTeamMembers()
  end)
  self:AddTabEvent(self.hireTog, function(go, value)
    self:QueryMemberCats()
    self:UpdateInfo({})
  end)
  self.noneTip = self:FindGO("NoneTip")
  self.noneTipLabel = self.noneTip:GetComponent(UILabel)
  self.noneTipSp = self:FindGO("NoneTipSp", self.noneTip)
  for i, v in ipairs(self.togMap) do
    local longPress = v:GetComponent(UILongPress)
    
    function longPress.pressEvent(obj, state)
      self:PassEvent(TipLongPressEvent.TeamInvitePopUp, {
        state,
        obj.gameObject
      })
    end
  end
  self:AddEventListener(TipLongPressEvent.TeamInvitePopUp, self.HandleLongPress, self)
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
  self.nowTog = PageIndex.E_Friend
  self:UpdateMyFriends()
end

function TeamInvitePopUp:InitInviteAllGuildMembers()
  self.inviteAllGuildMemberRoot = self:FindGO("InviteAllGuildMemberRoot")
  self.inviteAllGuildMemberBtn = self:FindComponent("InviteAllBtn", UISprite, self.inviteAllGuildMemberRoot)
  self:AddClickEvent(self.inviteAllGuildMemberBtn.gameObject, function()
    self:InviteAllGuildMember()
  end)
  self.inviteAllLab = self:FindComponent("InviteAllLab", UILabel, self.inviteAllGuildMemberRoot)
  self.inviteAllLab.text = ZhString.PvpCustomRoom_InviteAllGuildMembers
  local inviteAllGuildMemberWrapContent = self:FindGO("InviteAllGuildMemberWrap")
  local wrapConfig = {
    wrapObj = inviteAllGuildMemberWrapContent,
    pfbNum = 5,
    cellName = "TeamInviteMembCell",
    control = TeamInviteMembCell
  }
  self.inviteAllGuildMemberWraplist = WrapCellHelper.new(wrapConfig)
  self.inviteAllGuildMemberWraplist:AddEventListener(MouseEvent.MouseClick, self.ClickMemberEvent, self)
end

function TeamInvitePopUp:OnSearch()
  if not self.isWarbandInvite then
    return
  end
  local result = {}
  local curContent = self.searchContentInputLabel.text
  if curContent ~= ZhString.Friend_SearchContent then
    local waitData = self.waitSearchData
    if nil ~= waitData then
      for i = 1, #waitData do
        local len = string.len(waitData[i].data.name)
        local waitName = string.sub(waitData[i].data.name, 1, len - 2)
        local isOnline
        if self.nowTog == PageIndex.E_Friend then
          isOnline = waitData[i].data:IsOnline()
        else
          isOnline = true
        end
        if isOnline and (tostring(waitData[i].id) == curContent or waitName == curContent) then
          result[#result + 1] = waitData[i]
        end
      end
    end
    self:UpdateInfo(result)
    if #result == 0 then
      MsgManager.ShowMsgByIDTable(28091)
    end
  else
    MsgManager.ShowMsgByIDTable(418)
  end
end

function TeamInvitePopUp:InviteAllGuildMember()
  local myGuildData = GuildProxy.Instance.myGuildData
  if not myGuildData then
    return
  end
  local members = GuildProxy.Instance.myGuildData:GetMemberList()
  local RoomProxy = PvpCustomRoomProxy.Instance
  local my_id = Game.Myself.data.id
  for i = 1, #members do
    local gmemb = members[i]
    if gmemb.id and gmemb.id ~= my_id and not gmemb:IsOffline() and not RoomProxy:IsUserInCurrentRoom(gmemb.id) then
      RoomProxy:SendInviteReq(gmemb.id, self.teamtype)
    end
  end
  self.allGuildMemberInvited = true
  self:UpdateInviteAllBtnState()
end

function TeamInvitePopUp:UpdateInviteAllBtnState()
  if self.allGuildMemberInvited then
    self.inviteAllGuildMemberBtn.spriteName = "com_btn_13s"
    self.inviteAllLab.effectColor = ColorUtil.NGUIGray
  else
    self.inviteAllGuildMemberBtn.spriteName = "com_btn_2s"
    self.inviteAllLab.effectColor = ColorUtil.ButtonLabelOrange
  end
end

function TeamInvitePopUp:ClickMemberEvent(cellCtl)
  self.inviteeCellCtl = nil
  if cellCtl then
    redlog("cellCtl.eventType: ", cellCtl.eventType)
    if cellCtl.eventType == "CloseUI" then
      self:CloseSelf()
    elseif cellCtl.eventType == "Invite" then
      local data = cellCtl.data
      if self.proxy then
        if not self.proxy:CheckInMyBand(data.id) then
          local myband = self.proxy.myWarband
          local bandName = myband:GetTeamName()
          local leaderName = myband:GetLeaderName()
          self.proxy:DoCallInviter(data.id, bandName, leaderName)
          cellCtl:ActiveInviteButton(false)
        end
        return
      elseif self.isWarbandInvite then
        if not WarbandProxy.Instance:CheckInMyBand(data.id) then
          local myband = WarbandProxy.Instance.myWarband
          local bandName = myband:GetTeamName()
          local leaderName = myband:GetLeaderName()
          redlog("CallTwelveWarbandInviterMatchCCmd 邀请加入战队｜ ", data.id, bandName, leaderName)
          ServiceMatchCCmdProxy.Instance:CallTwelveWarbandInviterMatchCCmd(data.id, bandName, leaderName)
          cellCtl:ActiveInviteButton(false)
        end
        return
      end
      if self.isCustomRoomInvite then
        PvpCustomRoomProxy.Instance:SendInviteReq(data.id, self.teamtype)
        cellCtl:ActiveInviteButton(false)
        return
      end
      local myTeam = TeamProxy.Instance.myTeam
      if myTeam and #myTeam:GetPlayerMemberList(true, true) >= GameConfig.Team.maxmember then
        if self.isOperateUniteGroupTeam then
          local uniteTeam = TeamProxy.Instance:GetGroupUniteTeamData()
          if uniteTeam and #uniteTeam:GetPlayerMemberList(true) >= GameConfig.Team.maxmember then
            MsgManager.ShowMsgByIDTable(331)
            return
          else
            self.isOperateUniteGroupTeam = true
          end
        else
          MsgManager.ShowMsgByIDTable(331)
          return
        end
      elseif myTeam and #myTeam:GetMembersList() >= GameConfig.Team.maxmember then
        local uniteTeam = TeamProxy.Instance:GetGroupUniteTeamData()
        if uniteTeam and #uniteTeam:GetMembersList() < GameConfig.Team.maxmember then
          self.isOperateUniteGroupTeam = true
        end
      end
      if data.type == TeamInviteMemberType.MemberCat then
        if TeamProxy.Instance:IHaveTeam() and not TeamProxy.Instance:CheckIHaveLeaderAuthority() then
          MsgManager.ShowMsgByIDTable(5001)
          return
        end
        if Game.MapManager:IsPVEMode_Roguelike() then
          MsgManager.ShowMsgByIDTable(26235)
          return
        end
        self.invitee:SetId(data.id, data.data.cat)
        self.invitee:IsGroupInvite(self.isOperateUniteGroupTeam)
        FunctionTeamInvite.Me():InviteMember(self.invitee)
      else
        if teamProxy:IsInMyGroup(data.id) then
          MsgManager.ShowMsgByIDTable(333)
          return
        end
        self.inviteeCellCtl = cellCtl
        ServiceSessionTeamProxy.Instance:CallQueryUserTeamInfoTeamCmd(data.id)
      end
    elseif cellCtl.eventType == "Hire" then
      local sdata = cellCtl.data.data
      if sdata then
        self:sendNotification(UIEvent.ShowUI, {
          viewname = "HireCatPopUp",
          catid = sdata.cat
        })
        self:CloseSelf()
      end
    end
  end
end

function TeamInvitePopUp:HandleQueryUserTeamInfo(note)
  local data = note.body
  local id = data and data.charid
  if not id then
    return
  end
  local query_char_id = self.inviteeCellCtl and self.inviteeCellCtl.data and self.inviteeCellCtl.data.id
  if not query_char_id then
    return
  end
  if id ~= query_char_id then
    return
  end
  self.invitee:SetId(id, nil)
  self.invitee:SetTeamInfo(data)
  self.invitee:IsGroupInvite(self.isOperateUniteGroupTeam)
  local invite_callback = function()
    self.inviteeCellCtl:ActiveInviteButton(false)
  end
  FunctionTeamInvite.Me():InviteMember(self.invitee, invite_callback)
end

local index

function TeamInvitePopUp:UpdateMyFriends()
  index = PageIndex.E_Friend
  self:SetChooseInviteTogState(index)
  self.nowTog = index
  local list = {}
  local friendDatas = FriendProxy.Instance:GetOnlineFriendData()
  local insertValid
  for i = 1, #friendDatas do
    local guid = friendDatas[i].guid
    if guid then
      if self.proxy then
        insertValid = not self.proxy:CheckInMyBand(guid)
      elseif self.isWarbandInvite then
        insertValid = not WarbandProxy.Instance:CheckInMyBand(guid)
      elseif self.isCustomRoomInvite then
        insertValid = not PvpCustomRoomProxy.Instance:IsUserInCurrentRoom(guid)
      else
        insertValid = not teamProxy:IsInMyGroup(guid)
      end
      if insertValid then
        local inviteData = {}
        inviteData.id = friendDatas[i].guid
        inviteData.type = TeamInviteMemberType.Friend
        inviteData.data = friendDatas[i]
        inviteData.isWarband = self.isWarbandInvite
        inviteData.proxy = self.proxy
        inviteData.isCustomRoomInvite = self.isCustomRoomInvite
        table.insert(list, inviteData)
      end
    end
  end
  self.waitSearchData = list
  self:UpdateInfo(list)
end

function TeamInvitePopUp:UpdateMyGuildMembers()
  index = PageIndex.E_Guild
  self:SetChooseInviteTogState(index)
  self.nowTog = index
  local list = {}
  local myGuildData = GuildProxy.Instance.myGuildData
  if myGuildData then
    local gmembers = GuildProxy.Instance.myGuildData:GetMemberList()
    local insertValid
    for i = 1, #gmembers do
      local gmemb = gmembers[i]
      if nil ~= gmemb.id and gmemb.id ~= Game.Myself.data.id then
        if self.proxy then
          insertValid = not self.proxy:CheckInMyBand(gmemb.id)
        elseif self.isWarbandInvite then
          insertValid = not WarbandProxy.Instance:CheckInMyBand(gmemb.id)
        elseif self.isCustomRoomInvite then
          insertValid = not PvpCustomRoomProxy.Instance:IsUserInCurrentRoom(gmemb.id)
        else
          insertValid = not teamProxy:IsInMyGroup(gmemb.id)
        end
        if insertValid then
          local inviteData = {}
          inviteData.id = gmemb.id
          inviteData.type = TeamInviteMemberType.GuildMember
          inviteData.data = gmemb
          inviteData.isWarband = self.isWarbandInvite
          inviteData.proxy = self.proxy
          inviteData.isCustomRoomInvite = self.isCustomRoomInvite
          table.insert(list, inviteData)
        end
      end
    end
  end
  self.waitSearchData = list
  self:UpdateInfo(list)
end

function TeamInvitePopUp:UpdateNearTeamMembers()
  index = PageIndex.E_OldFriend
  self:SetChooseInviteTogState(index)
  self.nowTog = index
  local list = {}
  local teamMembers = FriendProxy.Instance:GetRecentTeamMember()
  for i = 1, #teamMembers do
    local isInGroup = false
    isInGroup = teamProxy:IsInMyGroup(teamMembers[i].guid)
    if not isInGroup then
      local inviteData = {}
      inviteData.id = teamMembers[i].guid
      inviteData.type = TeamInviteMemberType.NearlyTeamMember
      inviteData.data = teamMembers[i]
      table.insert(list, inviteData)
    end
  end
  self:UpdateInfo(list)
end

function TeamInvitePopUp:QueryMemberCats()
  index = PageIndex.E_MercenaryCat
  self:SetChooseInviteTogState(index)
  self.nowTog = index
  ServiceSessionTeamProxy.Instance:CallQueryMemberCatTeamCmd()
end

function TeamInvitePopUp:UpdateMemberCats()
  local list = {}
  local hireCats = teamProxy:GetMyHireTeamMembers()
  for i = 1, #hireCats do
    local catData = hireCats[i]
    if not teamProxy:IsInMyGroup(catData.id) then
      local inviteData = {}
      inviteData.id = catData.id
      inviteData.type = TeamInviteMemberType.MemberCat
      inviteData.data = catData
      table.insert(list, inviteData)
    end
  end
  self:UpdateInfo(list)
end

function TeamInvitePopUp:SetChooseInviteTogState(index)
  local chooseColor, unchooseColor = Color(0.18823529411764706, 0.2549019607843137, 0.5764705882352941), Color(0.615686274509804, 0.615686274509804, 0.615686274509804)
  for i = 1, #self.togMap do
    if self.usingIcon then
      if index == i then
        self.tabIconSpList[i].color = chooseColor
      else
        self.tabIconSpList[i].color = unchooseColor
      end
    elseif index == i then
      self.tabLabelList[i].color = chooseColor
    else
      self.tabLabelList[i].color = unchooseColor
    end
  end
end

function TeamInvitePopUp:UpdateInfo(list)
  if self.isWarbandInvite then
    self:Hide(self.inviteAllGuildMemberRoot)
    self.wraplist:UpdateInfo({})
    self.searchWraplist:UpdateInfo(list)
    self.searchWraplist:ResetPosition()
  elseif self.isTwelvePvpRoom and self.nowTog and self.nowTog == PageIndex.E_Guild and 0 < #list then
    self:Show(self.inviteAllGuildMemberRoot)
    self:UpdateInviteAllBtnState()
    self.searchWraplist:UpdateInfo({})
    self.wraplist:UpdateInfo({})
    self.inviteAllGuildMemberWraplist:UpdateInfo(list)
    self.inviteAllGuildMemberWraplist:ResetPosition()
  else
    self:Hide(self.inviteAllGuildMemberRoot)
    self.searchWraplist:UpdateInfo({})
    self.wraplist:UpdateInfo(list)
    self.wraplist:ResetPosition()
  end
  if self.nowTog == PageIndex.E_MercenaryCat then
    self.noneTipLabel.text = ZhString.TeamInvitePopUp_NoCatTip
  else
    self.noneTipLabel.text = ZhString.TeamInvitePopUp_NoMemberTip
  end
  self.noneTip:SetActive(#list == 0)
end

function TeamInvitePopUp:MapViewListenEvent()
  self:AddListenEvt(ServiceEvent.SessionSocialityQuerySocialData, self.HandleGetSocialityClientQuerySocialData)
  self:AddListenEvt(ServiceEvent.SessionSocialityQueryTeamData, self.HandleSocialityQueryTeamData)
  self:AddListenEvt(ServiceEvent.SessionSocialitySocialDataUpdate, self.HandleSocialDataUpdate)
  self:AddListenEvt(ServiceEvent.SessionTeamMemberCatUpdateTeam, self.HandleUpdateMemberCat)
  self:AddListenEvt(ServiceEvent.SessionTeamTeamMemberUpdate, self.HandleUpdateMemberCat)
  self:AddListenEvt(ServiceEvent.SessionTeamQueryUserTeamInfoTeamCmd, self.HandleQueryUserTeamInfo)
end

function TeamInvitePopUp:OnInputChanged()
  if StringUtil.IsEmpty(self.contentInput.value) then
    if self.nowTog == PageIndex.E_Friend then
      self:UpdateMyFriends()
    elseif self.nowTog == PageIndex.E_Guild then
      self:UpdateMyGuildMembers()
    end
  end
end

function TeamInvitePopUp:HandleSocialityQueryTeamData(note)
  helplog("Handle-->SocialityQueryTeamData")
  if self.nowTog == PageIndex.E_OldFriend then
    self:UpdateNearTeamMembers()
  end
end

function TeamInvitePopUp:HandleSocialDataUpdate(note)
  if self.nowTog == PageIndex.E_Friend then
    self:UpdateMyFriends()
  end
end

function TeamInvitePopUp:HandleGetSocialityClientQuerySocialData(note)
  helplog("Handle-->GetSocialityClientQuerySocialData")
  if self.nowTog == PageIndex.E_Friend then
    self:UpdateMyFriends()
  elseif self.nowTog == PageIndex.E_OldFriend then
    self:UpdateNearTeamMembers()
  end
end

function TeamInvitePopUp:HandleUpdateMemberCat(note)
  if self.nowTog == PageIndex.E_MercenaryCat then
    self:UpdateMemberCats()
  end
end

function TeamInvitePopUp:OnEnter()
  TeamInvitePopUp.super.OnEnter(self)
  ServiceSessionSocialityProxy.Instance:CallFrameStatusSocialCmd(true)
  self.isOperateUniteGroupTeam = self.viewdata.viewdata and self.viewdata.viewdata.IsOperateUniteGroupTeam
  self.proxy = self.viewdata.viewdata and self.viewdata.viewdata.proxy
  if self.viewdata.viewdata and self.viewdata.viewdata.isWarbandInvite or self.proxy then
    self.isWarbandInvite = true
  else
    self.isWarbandInvite = false
  end
  local viewdata = self.viewdata.viewdata
  self.etype = viewdata and viewdata.etype
  self.isTwelvePvpRoom = self.etype == PvpProxy.Type.TwelvePVPRelax
  if viewdata then
    self.isCustomRoomInvite = viewdata.isCustomRoomInvite and true or false
    self.teamtype = self.viewdata.viewdata.teamType
  else
    self.isCustomRoomInvite = false
    self.teamtype = nil
  end
  self.lastfriendTog:SetActive(not self.isWarbandInvite and not self.isCustomRoomInvite)
  self.hireTog:SetActive(not self.isWarbandInvite and not self.isCustomRoomInvite)
  self.searchRoot:SetActive(self.isWarbandInvite)
  if self.isWarbandInvite or self.isCustomRoomInvite then
    self:UpdateMyFriends()
  end
end

function TeamInvitePopUp:OnExit()
  self.inviteeCellCtl = nil
  self.contentInput.onChange = nil
  TeamInvitePopUp.super.OnExit(self)
  self:UpdateInfo({})
  ServiceSessionSocialityProxy.Instance:CallFrameStatusSocialCmd(false)
  if self.isCustomRoomInvite then
    local config = PvpCustomRoomProxy.GetRoomPopup(self.etype)
    if config then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = config})
    end
  end
end

function TeamInvitePopUp:HandleLongPress(param)
  local isPressing, go = param[1], param[2]
  TabNameTip.OnLongPress(isPressing, TeamInvitePopUp.TabName[go.name], true, self:FindComponent("Sprite", UISprite, go), nil, tabNameTipOffset)
end
