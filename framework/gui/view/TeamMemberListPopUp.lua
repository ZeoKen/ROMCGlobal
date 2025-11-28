TeamMemberListPopUp = class("TeamMemberListPopUp", ContainerView)
TeamMemberListPopUp.ViewType = UIViewType.NormalLayer
autoImport("TeamMemberCell")
autoImport("GroupMemberCell")

function TeamMemberListPopUp:Init()
  self:InitView()
  self:MapEvent()
  self.tabEmpty = {}
  if TeamMemberListPopUp.ShowStaticPicture == nil then
    TeamMemberListPopUp.ShowStaticPicture = not BackwardCompatibilityUtil.CompatibilityMode_V54 or ApplicationInfo.IsIphone7P_or_Worse() or ApplicationInfo.IsIpad6_or_Worse()
  end
end

function TeamMemberListPopUp:InitView()
  self.teamName = self:FindComponent("TeamName", UILabel)
  self.pickUpMode = self:FindComponent("PickUpMode", UILabel)
  self.pickUpMode.gameObject:SetActive(GameConfig.SystemForbid.TeamPickUpMode == nil)
  local reposition = self:FindComponent("TLReposition", UIGrid)
  reposition.repositionNow = true
  self.teamLevel = self:FindComponent("TeamLevel", UILabel)
  self.objTeamGrid = self:FindGO("MemberGrid")
  self.memberlist = UIGridListCtrl.new(self.objTeamGrid:GetComponent(UIGrid), TeamMemberCell, "TeamMemberCell")
  self.memberlist:AddEventListener(MouseEvent.MouseClick, self.ClickTeamMember, self)
  self.memberlist:AddEventListener(TeamEvent.TeamInviteBtnClick, self.ClickTeamInviteBtn, self)
  self.objRaidMembers = self:FindGO("RaidMembers")
  self.listRaidTeams = {
    [1] = UIGridListCtrl.new(self:FindComponent("gridRaidTeam1", UIGrid, self.objRaidMembers), GroupMemberCell, "GroupMemberCell"),
    [2] = UIGridListCtrl.new(self:FindComponent("gridRaidTeam2", UIGrid, self.objRaidMembers), GroupMemberCell, "GroupMemberCell")
  }
  self.listRaidTeams[1]:AddEventListener(MouseEvent.MouseClick, self.ClickTeamMember, self)
  self.listRaidTeams[2]:AddEventListener(MouseEvent.MouseClick, self.ClickTeamMember, self)
  self.listRaidTeams[1]:AddEventListener(TeamEvent.CancelMemberSelect, self.CancelMemberSelect, self)
  self.listRaidTeams[2]:AddEventListener(TeamEvent.CancelMemberSelect, self.CancelMemberSelect, self)
  self.listRaidTeams[1]:AddEventListener(TeamEvent.TeamInviteBtnClick, self.ClickTeamInviteBtn, self)
  self.listRaidTeams[2]:AddEventListener(TeamEvent.TeamInviteBtnClick, self.ClickTeamInviteBtn, self)
  local applyPageButton = self:FindGO("ApplyListButton")
  self.applyPageButton = applyPageButton:GetComponent(UIButton)
  self:AddClickEvent(applyPageButton, function(go)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TeamApplyListPopUp
    })
  end)
  local applyPageButtonBg = applyPageButton:GetComponent(UISprite)
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_TEAMAPPLY, applyPageButtonBg, 25)
  local findTeamBtn = self:FindGO("FindTeamBtn")
  self:AddClickEvent(findTeamBtn, function(go)
    if Game.MapManager:IsPvPMode_TeamTwelve() then
      MsgManager.ShowMsgByID(26257)
      return
    end
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TeamFindPopUp
    })
  end)
  local leaveButton = self:FindGO("LeaveTeamButton")
  self:AddClickEvent(leaveButton, function(go)
    FunctionPlayerTip.LeaverTeam()
  end)
  local inviteMemberButton = self:FindGO("InviteMemberButton")
  self.inviteMemberButton = inviteMemberButton:GetComponent(UIButton)
  self:AddClickEvent(inviteMemberButton, function(go)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TeamInvitePopUp
    })
  end)
  self.optionButton = self:FindGO("OptionButton")
  self:AddClickEvent(self.optionButton, function(go)
    if TeamProxy.Instance:IHaveGroup() and not TeamProxy.Instance:CheckIHaveGroupLeaderAuthority() then
      MsgManager.ShowMsgByID(25970)
      return
    end
    local viewData = {
      goal = TeamProxy.Instance.myTeam.type,
      ispublish = false
    }
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TeamOptionPopUp,
      viewdata = viewData
    })
  end)
  self.inviteAllButton = self:FindGO("InviteAllFollowButton")
  self:AddClickEvent(self.inviteAllButton, function()
    FunctionTeam.Me():InviteMemberFollow()
  end)
  self.objOrganizeRaidBtn = self:FindGO("OrganizeRaidBtn")
  self:AddClickEvent(self.objOrganizeRaidBtn, function()
    if TeamProxy.Instance:IHaveGroup() or not TeamProxy.Instance:CheckIHaveLeaderAuthority() then
      return
    end
    if PvpProxy.Instance:IsInPreparation() then
      MsgManager.ShowMsgByID(39102)
      return
    end
    if PvpProxy.Instance:Is12PvpInMatch() then
      MsgManager.ShowMsgByID(25984)
      return
    end
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.GroupInvitePopUp
    })
  end)
  self.objDissolutionRaidBtn = self:FindGO("DissolutionRaidBtn")
  self:AddClickEvent(self.objDissolutionRaidBtn, function()
    if not TeamProxy.Instance:CheckIHaveLeaderAuthority() then
      return
    end
    if PvpProxy.Instance:IsInPreparation() then
      MsgManager.ShowMsgByID(39102)
      return
    end
    if PvpProxy.Instance:Is12PvpInMatch() then
      MsgManager.ShowMsgByID(25984)
      return
    end
    if Game.MapManager:IsPveMode_Thanatos() then
      MsgManager.ShowMsgByID(25953)
      return
    end
    if Game.MapManager:IsPvPMode_TeamTwelve() then
      MsgManager.ShowMsgByID(25953)
      return
    end
    MsgManager.ConfirmMsgByID(25947, function()
      ServiceSessionTeamProxy.Instance:CallDissolveGroupTeamCmd()
    end, nil)
  end)
  self.autoFollowTog = self:FindComponent("AutoFollowTog", UIToggle)
  self.autoFollowLab = self:FindComponent("Label", UILabel, self.autoFollowTog.gameObject)
  self.autoFollowLab.text = ZhString.TeamMemberListPopUp_Auto_Follow_Ready
  self:AddClickEvent(self.autoFollowTog.gameObject, function()
    local togValue = self.autoFollowTog.value
    local isAutoFollow = TeamProxy.Instance:CheckMyselfAutoFollowIsOpen()
    if togValue ~= isAutoFollow then
      helplog("CallSetMemberOptionTeamCmd", togValue)
      local changeOption = {}
      local autofollowOp = {
        type = SessionTeam_pb.EMEMBERDATA_AUTOFOLLOW,
        value = togValue and 1 or 0
      }
      table.insert(changeOption, autofollowOp)
      ServiceSessionTeamProxy.Instance:CallSetMemberOptionTeamCmd(nil, changeOption)
    end
  end)
  self.objGroupOnMarkBtn = self:FindGO("GroupOnMarkBtn"):GetComponent(UIButton)
  self.objGroupOnMarkBtn.gameObject:SetActive(TeamProxy.Instance:IHaveGroup() and TeamProxy.Instance:CheckIHaveGroupLeaderAuthority())
  self.objGroupOnMarkBtn.isEnabled = GroupRaidProxy.Instance:CheckShowOnMark()
  self.onmarkBG = self.objGroupOnMarkBtn.gameObject:GetComponent(UISprite)
  self.onmarkIcon = self:FindGO("Icon", self.objGroupOnMarkBtn.gameObject):GetComponent(UISprite)
  self:AddClickEvent(self.objGroupOnMarkBtn.gameObject, function()
    if GroupRaidProxy.Instance:CheckShowOnMark() then
      ServiceTeamGroupRaidProxy.Instance:CallInviteConfirmRaidTeamGroupCmd()
    else
      return
    end
  end)
  self.teamChatIntervalTime = GameConfig.Team.chatTeamIntervalTime or 30
  self.teamChatBtn = self:FindGO("TeamChatBtn")
  self:AddClickEvent(self.teamChatBtn, function(go)
    self:OnClickTeamChat()
  end)
  self:UpdateTeamChatBtn()
  self.switchMemberBtnGO = self:FindGO("SwitchMemberBtn")
  self.switchMemberBtnSp = self.switchMemberBtnGO:GetComponent(UISprite)
  self.switchMemberBtnIcon = self:FindComponent("Icon", UISprite, self.switchMemberBtnGO)
  self.switchMemberBtn = self.switchMemberBtnGO:GetComponent(UIButton)
  self:AddClickEvent(self.switchMemberBtnGO, function()
    self:OnSwitchMemberBtnClick()
  end)
  self:UpdateSwitchMemberBtn()
  self.switchMemberEditor = self:FindGO("SwitchMemberEditor")
  self.switchMemberEditor:SetActive(false)
  self.completeSwitchMemberBtn = self:FindGO("completeBtn", self.switchMemberEditor)
  self:AddClickEvent(self.completeSwitchMemberBtn, function()
    self:OnSwitchMemberCompleteBtnClick()
  end)
  self.quitSwitchMemberBtn = self:FindGO("cancelBtn", self.switchMemberEditor)
  self:AddClickEvent(self.quitSwitchMemberBtn, function()
    self:OnSwitchMemberQuitBtnClick()
  end)
end

function TeamMemberListPopUp:OnClickTeamChat()
  local isAuthority = TeamProxy.Instance:CheckIHaveLeaderAuthority()
  if TeamProxy.Instance:IHaveGroup() then
    isAuthority = TeamProxy.Instance:CheckIHaveGroupLeaderAuthority()
  end
  if isAuthority then
    local state = TeamProxy.Instance.myTeam.state
    if state ~= SessionTeam_pb.ETEAMSTATE_PUBLISH and state ~= SessionTeam_pb.ETEAMSTATE_PUBLISH_GROUP then
      MsgManager.ShowMsgByID(28100)
      return
    end
    local curType = TeamProxy.Instance.myTeam.type
    local str = ChatRoomProxy.Instance:TryParseTeamGoalToString(curType)
    if str then
      local now = UnityUnscaledTime
      local _refreshTime = TeamProxy.Instance:GetChatTeamFreshTime()
      if _refreshTime and now - _refreshTime < self.teamChatIntervalTime then
        MsgManager.ShowMsgByID(49)
        return
      else
        TeamProxy.Instance:SetChatTeamFreshTime(now)
      end
      ServiceSessionTeamProxy.Instance:CallReqRecruitPublishTeamCmd()
      MsgManager.ShowMsgByIDTable(28101)
    end
  end
end

function TeamMemberListPopUp:ClickTeamMember(cellCtl)
  if self.inSwitchMemberEditor then
    local guid
    if not self.switchMemberSelectedId then
      if cellCtl:IsEmpty() then
        return
      end
      if cellCtl.data:IsHireMember() then
        return
      end
      if cellCtl.data:IsRobotMember() then
        MsgManager.ShowMsgByID(43165)
        return
      end
      guid = cellCtl.data.id
      self.switchMemberSelectedId = guid
      cellCtl:SetSelectedState(true)
      local teamId = cellCtl.data.groupTeamIndex
      for i = 1, #self.listRaidTeams do
        local cells = self.listRaidTeams[i]:GetCells()
        for j = 1, #cells do
          local cell = cells[j]
          if cellCtl ~= cell then
            cell:SetSelectedState(false)
          end
          if i ~= teamId and (not (not cell:IsEmpty() and cell.data:IsHireMember()) or not cell.data:IsRobotMember()) then
            cell:SetSwitchTargetState(true)
          else
            cell:SetSwitchTargetState(false)
          end
        end
      end
    else
      if TeamProxy.Instance:IsLastPlayerInTeam(self.switchMemberSelectedId) and (cellCtl:IsEmpty() or cellCtl.data:IsHireMember() or cellCtl.data:IsRobotMember()) then
        MsgManager.ShowMsgByID(491)
        return
      end
      if cellCtl:IsEmpty() then
        if TeamProxy.Instance:IsInMyTeam(self.switchMemberSelectedId) then
          if cellCtl.data == MyselfTeamData.EMPTY_STATE then
            return
          end
        elseif TeamProxy.Instance:IsInMyGroup(self.switchMemberSelectedId) and cellCtl.data == MyselfTeamData.EMPTY_STATE_GROUP then
          return
        end
      else
        guid = cellCtl.data.id
      end
      if self.switchMemberSelectedId ~= guid and not TeamProxy.Instance:IsInSameTeam(self.switchMemberSelectedId, guid) then
        self:SwitchMember(guid)
      end
    end
  elseif cellCtl ~= self.nowCell and not cellCtl:IsEmpty() then
    local clickMy = cellCtl.data and cellCtl.data.id == Game.Myself.data.id
    if cellCtl and cellCtl.data and cellCtl.data:IsTeamNpc() then
      return
    end
    if not clickMy then
      self.nowCell = cellCtl
      local memberData = cellCtl.data
      local playerTip = FunctionPlayerTip.Me():GetPlayerTip(cellCtl.bg, NGUIUtil.AnchorSide.TopRight, {-70, 14})
      local playerData = PlayerTipData.new()
      playerData:SetByTeamMemberData(memberData)
      local funckeys
      if memberData.cat ~= nil and memberData.cat ~= 0 then
        funckeys = FunctionPlayerTip.Me():GetHireCatFunckey(memberData)
      elseif memberData.robot ~= nil and memberData.robot ~= 0 then
        funckeys = FunctionPlayerTip.Me():GetRobotFunckey(memberData)
      else
        funckeys = FunctionPlayerTip.Me():GetPlayerFunckey(memberData.id)
      end
      table.insert(funckeys, "EnterHomeRoom")
      GmeVoiceProxy.Instance:showTeamPageButton(memberData, funckeys)
      local tipData = {playerData = playerData, funckeys = funckeys}
      playerTip:SetData(tipData)
      playerTip:AddIgnoreBound(cellCtl.gameObject)
      
      function playerTip.closecallback()
        self.nowCell = nil
      end
      
      function playerTip.clickcallback(funcConfig)
        if funcConfig.key == "LeaverTeam" then
          self:CloseSelf()
        end
      end
    else
      FunctionPlayerTip.Me():CloseTip()
      self.nowCell = nil
    end
  else
    FunctionPlayerTip.Me():CloseTip()
    self.nowCell = nil
  end
end

function TeamMemberListPopUp:OnEnter()
  TeamMemberListPopUp.super.OnEnter(self)
  UIModelUtil.Instance:ResetAllTextures()
  self:UpdateTeamInfo()
  self:QueryGroupUniteTeamList()
  Game.PerformanceManager:LODHigh()
end

function TeamMemberListPopUp:UpdateTeamInfo()
  if TeamProxy.Instance:IHaveTeam() then
    local myTeam = TeamProxy.Instance.myTeam
    self.teamName.text = myTeam:GetStrStatus()
    local type, goalStr = myTeam.type
    if type and Table_TeamGoals[type] then
      goalStr = Table_TeamGoals[type].NameZh
    end
    self.teamLevel.text = string.format("%s[%s~%s]", tostring(goalStr), tostring(myTeam.minlv), tostring(myTeam.maxlv))
    local pickUpMode = myTeam.pickupmode or 0
    if pickUpMode == 0 then
      self.pickUpMode.text = ZhString.TeamMemberListPopUp_FreePick
    elseif pickUpMode == 1 then
      self.pickUpMode.text = ZhString.TeamMemberListPopUp_RandomPick
    end
    local leaderAuthority = TeamProxy.Instance:CheckIHaveLeaderAuthority()
    self.applyPageButton.gameObject:SetActive(leaderAuthority)
    self.inviteMemberButton.gameObject:SetActive(leaderAuthority)
    self.optionButton.gameObject:SetActive(leaderAuthority)
    self.inviteAllButton.gameObject:SetActive(leaderAuthority)
    local showAutoTog = not leaderAuthority
    if showAutoTog then
      self:Show(self.autoFollowTog)
      local myMemberData = TeamProxy.Instance:GetMyTeamMemberData()
      if myMemberData then
        self.autoFollowTog.value = myMemberData.autofollow == 1
      else
        self.autoFollowTog.value = false
      end
    else
      self:Hide(self.autoFollowTog)
    end
    local inGroup = TeamProxy.Instance:IHaveGroup()
    self.objRaidMembers:SetActive(inGroup)
    local inTeam = not inGroup and TeamProxy.Instance:IHaveTeam()
    self.objTeamGrid:SetActive(inTeam)
    self.objOrganizeRaidBtn:SetActive(inTeam and leaderAuthority and not GameConfig.SystemForbid.Group)
    self.objDissolutionRaidBtn:SetActive(inGroup and leaderAuthority)
    self:UpdateSwitchMemberBtn()
    self:UpdateMemberList()
    self:UpdateTeamChatBtn()
  end
end

function TeamMemberListPopUp:UpdateTeamChatBtn()
  local state = TeamProxy.Instance:CheckIHaveLeaderAuthority()
  if TeamProxy.Instance:IHaveGroup() then
    state = TeamProxy.Instance:CheckIHaveGroupLeaderAuthority()
  end
  self.teamChatBtn:SetActive(state)
end

local memberDatas = {}

function TeamMemberListPopUp:UpdateMemberList()
  local myTeam = TeamProxy.Instance.myTeam
  local memberList = myTeam:GetMembersList()
  TableUtility.ArrayClear(memberDatas)
  for i = 1, #memberList do
    table.insert(memberDatas, memberList[i])
  end
  if #memberDatas < GameConfig.Team.maxmember then
    table.insert(memberDatas, MyselfTeamData.EMPTY_STATE)
  end
  if TeamProxy.Instance:IHaveGroup() then
    self.memberlist:ResetDatas(self.tabEmpty)
    self.listRaidTeams[myTeam:GetGroupTeamIndex()]:ResetDatas(memberDatas)
    self:UpdateGroupUniteTeamList()
  elseif TeamProxy.Instance:IHaveTeam() then
    for index, listGroupTeam in pairs(self.listRaidTeams) do
      listGroupTeam:ResetDatas(self.tabEmpty)
    end
    self.memberlist:ResetDatas(memberDatas)
  end
  self:UpdateOnMarkBtn()
end

local uniteMemberDatas = {}

function TeamMemberListPopUp:UpdateGroupUniteTeamList()
  local uniteTeam = TeamProxy.Instance:GetGroupUniteTeamData()
  if not uniteTeam then
    return
  end
  local memberList = uniteTeam:GetMembersList()
  TableUtility.ArrayClear(uniteMemberDatas)
  for i = 1, #memberList do
    table.insert(uniteMemberDatas, memberList[i])
  end
  if TeamProxy.Instance:CheckIHaveGroupLeaderAuthority() and #uniteMemberDatas < GameConfig.Team.maxmember then
    table.insert(uniteMemberDatas, MyselfTeamData.EMPTY_STATE_GROUP)
  end
  self.listRaidTeams[uniteTeam:GetGroupTeamIndex()]:ResetDatas(uniteMemberDatas)
end

function TeamMemberListPopUp:QueryGroupUniteTeamList()
  if TeamProxy.Instance:IHaveGroup() then
    ServiceSessionTeamProxy.Instance:CallQueryMemberTeamCmd(TeamProxy.Instance.myTeam.uniteteamid)
  end
end

function TeamMemberListPopUp:MapEvent()
  self:AddListenEvt(ServiceEvent.SessionTeamEnterTeam, self.UpdateTeamInfo)
  self:AddListenEvt(ServiceEvent.SessionTeamTeamDataUpdate, self.UpdateTeamInfo)
  self:AddListenEvt(ServiceEvent.SessionTeamTeamMemberUpdate, self.UpdateMemberList)
  self:AddListenEvt(ServiceEvent.SessionTeamMemberDataUpdate, self.UpdateTeamInfo)
  self:AddListenEvt(ServiceEvent.SessionTeamExitTeam, self.HandleExitTeam)
  self:AddListenEvt(ServiceEvent.NUserBeFollowUserCmd, self.UpdateMemberList)
  self:AddListenEvt(ServiceEvent.SessionTeamQueryMemberTeamCmd, self.UpdateGroupUniteTeamList)
  self:AddListenEvt(PVEEvent.ReplyInvite, self.UpdateOnMarkBtn)
  self:AddListenEvt(PVEEvent.CancelInvite, self.UpdateOnMarkBtn)
end

function TeamMemberListPopUp:HandleExitTeam(note)
  if self.doNotCloseself then
    self.doNotCloseself = nil
    return
  end
  self:CloseSelf()
end

function TeamMemberListPopUp:OnExit()
  local cells = self.memberlist:GetCells() or {}
  for i = 1, #cells do
    cells[i]:OnDestroy()
  end
  self.memberlist:ResetDatas(self.tabEmpty)
  for index, listGroupTeam in pairs(self.listRaidTeams) do
    listGroupTeam:ResetDatas(self.tabEmpty)
  end
  Game.PerformanceManager:ResetLOD()
  TeamMemberListPopUp.super.OnExit(self)
  FunctionPlayerTip.Me():CloseTip()
end

local tempColor = LuaColor(1, 1, 1, 1)

function TeamMemberListPopUp:UpdateOnMarkBtn()
  local _showMarkEnable = GroupRaidProxy.Instance:CheckShowOnMark()
  self.objGroupOnMarkBtn.isEnabled = _showMarkEnable
  self.objGroupOnMarkBtn.gameObject:SetActive(TeamProxy.Instance:IHaveGroup() and TeamProxy.Instance:CheckIHaveGroupLeaderAuthority())
  if _showMarkEnable then
    LuaColor.Better_Set(tempColor, 1, 1, 1, 1)
  else
    LuaColor.Better_Set(tempColor, 0.00392156862745098, 0.00784313725490196, 0.011764705882352941)
  end
  self.onmarkBG.color = tempColor
  self.onmarkIcon.color = tempColor
end

function TeamMemberListPopUp:UpdateSwitchMemberBtn()
  local IAmGroupLeader = TeamProxy.Instance:CheckImTheGroupLeader()
  self.switchMemberBtnGO:SetActive(IAmGroupLeader)
  if IAmGroupLeader then
    local enabled = TeamProxy.Instance:IsSwitchMemberEnabled()
    self.switchMemberBtn.isEnabled = enabled
    if enabled then
      LuaColor.Better_Set(tempColor, 1, 1, 1, 1)
    else
      LuaColor.Better_Set(tempColor, 0.00392156862745098, 0.00784313725490196, 0.011764705882352941)
    end
    self.switchMemberBtnSp.color = tempColor
    self.switchMemberBtnIcon.color = tempColor
  end
end

function TeamMemberListPopUp:OnSwitchMemberBtnClick()
  if self.inSwitchMemberEditor then
    return
  end
  if TeamProxy.Instance:HasRobotInTeam() then
    MsgManager.ShowMsgByID(43166)
    return
  end
  self.inSwitchMemberEditor = true
  self.switchMemberEditor:SetActive(true)
end

function TeamMemberListPopUp:OnSwitchMemberCompleteBtnClick()
  MsgManager.ConfirmMsgByID(490, function()
    local mainteam_mems = TeamProxy.Instance:GetMainTeamMemberIds()
    local subteam_mems = TeamProxy.Instance:GetSubTeamMemberIds()
    ServiceSessionTeamProxy.Instance:CallChangeGroupMemberTeamCmd(mainteam_mems, subteam_mems)
    self.inSwitchMemberEditor = false
    self.switchMemberEditor:SetActive(false)
    TeamProxy.Instance:ClearStoredTeamData()
    self:UpdateMemberList()
    self:ResetSwitchMemberSelectState()
    for i = 1, #subteam_mems do
      local guid = subteam_mems[i]
      if guid == Game.Myself.data.id then
        self.doNotCloseself = true
        break
      end
    end
  end)
end

function TeamMemberListPopUp:OnSwitchMemberQuitBtnClick()
  if not self.inSwitchMemberEditor then
    return
  end
  self.inSwitchMemberEditor = false
  self.switchMemberEditor:SetActive(false)
  TeamProxy.Instance:RestoreTeamData()
  self:UpdateMemberList()
  self:ResetSwitchMemberSelectState()
end

function TeamMemberListPopUp:CancelMemberSelect(cellCtrl)
  for i = 1, #self.listRaidTeams do
    if i ~= cellCtrl.data.groupTeamIndex then
      local cells = self.listRaidTeams[i]:GetCells()
      for j = 1, #cells do
        local cell = cells[j]
        cell:SetSwitchTargetState(false)
      end
    end
  end
  self.switchMemberSelectedId = nil
end

function TeamMemberListPopUp:SwitchMember(targetSwitchId)
  if self.switchMemberSelectedId and self.switchMemberSelectedId ~= targetSwitchId then
    TeamProxy.Instance:SwitchTeamMember(self.switchMemberSelectedId, targetSwitchId)
    self:UpdateMemberList()
    self:ResetSwitchMemberSelectState()
  end
end

function TeamMemberListPopUp:ClickTeamInviteBtn(cellCtrl)
  if self.inSwitchMemberEditor then
    self:ClickTeamMember(cellCtrl)
  else
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TeamInvitePopUp,
      viewdata = {
        IsOperateUniteGroupTeam = cellCtrl.data == MyselfTeamData.EMPTY_STATE_GROUP
      }
    })
  end
end

function TeamMemberListPopUp:ResetSwitchMemberSelectState()
  for i = 1, #self.listRaidTeams do
    local cells = self.listRaidTeams[i]:GetCells()
    for j = 1, #cells do
      local cell = cells[j]
      cell:SetSelectedState(false)
      cell:SetSwitchTargetState(false)
    end
  end
  self.switchMemberSelectedId = nil
end
