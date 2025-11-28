MainViewTeamPage = class("MainViewTeamPage", SubView)
autoImport("TMInfoCell")
local teamProxy

function MainViewTeamPage:Init()
  teamProxy = TeamProxy.Instance
  self:InitUI()
  self:MapViewListener()
end

function MainViewTeamPage:InitUI()
  local teamButton = self:FindGO("TeamButton")
  local rClickBg = teamButton:GetComponent(UISprite)
  FunctionUnLockFunc.Me():RegisteEnterBtnByPanelID(PanelConfig.TeamMemberListPopUp.id, teamButton)
  Game.HotKeyTipManager:RegisterHotKeyTip(38, rClickBg, NGUIUtil.AnchorSide.TopLeft, {12, -12})
  self:AddClickEvent(teamButton, function(go)
    if Game.MapManager:MapForbidTeamButton() then
      MsgManager.ShowMsgByIDTable(41344)
      return
    end
    self:PlayUISound(GameConfig.UIAudio.Team)
    if not teamProxy:IHaveTeam() then
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.TeamFindPopUp
      })
    else
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.TeamMemberListPopUp
      })
    end
  end, {hideClickSound = true})
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_TEAMAPPLY, teamButton, 42)
  local teamGrid = self:FindComponent("TeamGrid", UIGrid)
  if teamGrid then
    self.teamCtl = UIGridListCtrl.new(teamGrid, TMInfoCell, "TMInfoCell")
    self.teamCtl:AddEventListener(MouseEvent.MouseClick, self.ClickTeamPlayer, self)
  else
    helplog("if teamGrid then == null")
  end
  self.playerTipStick = self:FindComponent("PlayerTipStick", UIWidget)
end

function MainViewTeamPage:ClickTeamPlayer(cellCtl)
  if NewbieCollegeProxy.Instance.IsInFakeTeam or self.isInDemoRaid == true then
    MsgManager.ShowMsgByIDTable(41344)
    return
  end
  local data = cellCtl.data
  if data == MyselfTeamData.EMPTY_STATE then
    if Game.MapManager:MapForbidTeamButton() then
      MsgManager.ShowMsgByIDTable(41344)
      return
    end
    FunctionPlayerTip.Me():CloseTip()
    self.nowClickMember = nil
    if not teamProxy:IHaveTeam() then
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.TeamFindPopUp
      })
    else
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.TeamInvitePopUp
      })
    end
  elseif data ~= nil then
    if data.teamnpc and data.teamnpc ~= 0 then
      return
    end
    if self.nowClickMember ~= cellCtl then
      local playerTip = FunctionPlayerTip.Me():GetPlayerTip(self.playerTipStick, NGUIUtil.AnchorSide.Right)
      local funckeys
      if data.cat ~= nil and data.cat ~= 0 then
        funckeys = FunctionPlayerTip.Me():GetHireCatFunckey(data)
      elseif data.robot ~= nil and data.robot ~= 0 then
        funckeys = FunctionPlayerTip.Me():GetRobotFunckey(data)
      else
        funckeys = FunctionPlayerTip.Me():GetPlayerFunckey(data.id)
        table.insert(funckeys, "Double_Action")
      end
      table.insert(funckeys, "EnterHomeRoom")
      local playerData = PlayerTipData.new()
      playerData:SetByTeamMemberData(data)
      GmeVoiceProxy.Instance:showTeamPageButton(data, funckeys)
      local tipData = {
        playerData = playerData,
        funckeys = funckeys,
        callback = nil
      }
      playerTip:SetWhereIClickThisIcon(PlayerTipSource.FromTeam)
      playerTip:SetData(tipData)
      
      function playerTip.closecallback()
        self.nowClickMember = nil
      end
      
      playerTip:AddIgnoreBound(cellCtl.gameObject)
      self.nowClickMember = cellCtl
      local role = NSceneUserProxy.Instance:Find(data.id)
      if role == nil then
        role = NSceneNpcProxy.Instance:Find(data.id)
      end
      if role ~= nil then
        Game.Myself:Client_LockTarget(role)
        if FunctionSkillTargetPointLauncher.Me():SetTargetPointPlayer(data.id) then
          Game.Myself:Client_ManualControlled()
          FunctionSkillTargetPointLauncher.Me():LaunchSkill()
          FunctionPlayerTip.Me():CloseTip()
          self.nowClickMember = nil
        end
      elseif TeamProxy.Instance:IsInMyTeam(data.id) then
        local skip = false
        if data.cat and data.cat ~= 0 then
          local expiretime = data.expiretime or 0
          local curtime = ServerTime.CurServerTime() / 1000
          if expiretime ~= 0 and expiretime <= curtime then
            skip = true
          end
        elseif data:IsOffline() then
          skip = true
        end
        if not skip and FunctionSkillTargetPointLauncher.Me():SetTargetPointPlayer(data.id) then
          Game.Myself:Client_ManualControlled()
          FunctionSkillTargetPointLauncher.Me():LaunchSkill()
          FunctionPlayerTip.Me():CloseTip()
          self.nowClickMember = nil
        end
      end
    else
      FunctionPlayerTip.Me():CloseTip()
      self.nowClickMember = nil
    end
  end
end

function MainViewTeamPage:UpdateTeamMember()
  if teamProxy.myTeam and nil == teamProxy.myTeam.hireMemberList_dirty then
    ServiceSessionTeamProxy.Instance:CallQueryMemberCatTeamCmd()
  end
  if teamProxy.myTeam then
    local memberlst = teamProxy.myTeam:GetMemberListWithAdd()
    if memberlst then
      self.teamCtl:ResetDatas(memberlst)
    end
  elseif self.teamCtl then
    self.teamCtl:ResetDatas({
      MyselfTeamData.EMPTY_STATE
    })
  end
  self:UpdateGMEMemberState()
  self:HandleShowTargetPointTip()
  self:UpdateHotKeyTip()
end

function MainViewTeamPage:UpdateTeamMemberHP()
  local cells = self.teamCtl:GetCells()
  if cells == nil then
    return
  end
  local camp = RoleDefines_Camp.FRIEND
  local prop = SkillDynamicManager.Props.HP
  local _SkillDynamicManager = Game.SkillDynamicManager
  for i = 1, #cells do
    local cell = cells[i]
    local data = cell.data
    if data ~= nil and data ~= MyselfTeamData.EMPTY_STATE then
      local hpmax = data.hpmax
      if hpmax ~= nil and hpmax ~= 0 then
        local hp = not data:IsOffline() and _SkillDynamicManager:GetDynamicProps(camp, prop)
        hp = hp or data.hp
        if hp ~= nil then
          cell:UpdateHp(hp / hpmax)
        end
      end
    end
  end
end

function MainViewTeamPage:UpdateTeamMemberDataUpdate(note)
  if not teamProxy.myTeam then
    return
  end
  local data = note.body
  local memberid = data and data.id
  if not memberid then
    return
  end
  local mdata = teamProxy.myTeam:GetMemberByGuid(memberid)
  if not mdata then
    return
  end
  local cells = self.teamCtl:GetCells()
  if not cells then
    return
  end
  local tmCell
  for i = 1, #cells do
    if cells[i].id and cells[i].id == memberid then
      tmCell = cells[i]
      break
    end
  end
  if not tmCell then
    return
  end
  local serverMembers = data.members
  for i = 1, #serverMembers do
    local t = serverMembers[i].type
    if t then
      if tmCell:IsFrequencyCall(t) then
        tmCell:UpdateByServerMemberData(t, mdata)
      else
        tmCell:SetData(mdata)
      end
    end
  end
end

function MainViewTeamPage:UpdateUserItemImager()
  local cells = self.teamCtl:GetCells()
  if not cells then
    return
  end
  for i = 1, #cells do
    cells[i]:UpdateImageCreator()
  end
end

function MainViewTeamPage:UpdateTmInfo(memberid, memberData)
  local cells = self.teamCtl:GetCells()
  if not cells then
    return
  end
  for i = 1, #cells do
    if cells[i].id and cells[i].id == memberid then
      cells[i]:SetData(memberData)
      break
    end
  end
end

function MainViewTeamPage:UpdateMemberPos()
  local cells = self.teamCtl:GetCells()
  for i = 1, #cells do
    cells[i]:UpdateMemberPos()
  end
end

function MainViewTeamPage:UpdateGMEMemberState()
  local GMEProxy = GmeVoiceProxy.Instance
  local members = self.teamCtl:GetCells()
  for _, member in pairs(members) do
    local data = member.data
    if data ~= nil and data ~= MyselfTeamData.EMPTY_STATE then
      if GMEProxy:IsInRoom() then
        member:_UpdateGME(GMEProxy:GetMemberById(data.accid))
      else
        member:_UpdateGME(nil)
      end
    end
  end
end

function MainViewTeamPage:MapViewListener()
  self:AddListenEvt(ServiceEvent.SessionTeamEnterTeam, self.UpdateTeamMember)
  self:AddListenEvt(ServiceEvent.SessionTeamExitTeam, self.UpdateTeamMember)
  self:AddListenEvt(ServiceEvent.SessionTeamTeamMemberUpdate, self.UpdateTeamMember)
  self:AddListenEvt(ServiceEvent.SessionTeamMemberDataUpdate, self.UpdateTeamMemberDataUpdate)
  self:AddListenEvt(ServiceEvent.NUserItemImageUserNtfUserCmd, self.UpdateUserItemImager)
  self:AddListenEvt(ServiceEvent.SessionTeamExchangeLeader, self.UpdateTeamMember)
  self:AddListenEvt(ServiceEvent.SessionTeamTeamDataUpdate, self.UpdateTeamMember)
  self:AddListenEvt(TeamEvent.MemberOffline, self.UpdateTeamMember)
  EventManager.Me():AddEventListener(GMEEvent.OnEnterRoom, self.UpdateGMEMemberState, self)
  EventManager.Me():AddEventListener(GMEEvent.OnExitRoom, self.UpdateGMEMemberState, self)
  self:AddListenEvt(ServiceEvent.SessionTeamQuickEnter, self.HandleQuickEnter)
  self:AddListenEvt(ServiceEvent.NUserBeFollowUserCmd, self.HandleFollowStateChange)
  self:AddDispatcherEvt(FunctionFollowCaptainEvent.StateChanged, self.HandleFollowStateChange)
  EventManager.Me():AddEventListener(TeamEvent.VoiceChange, self.HandleVoiceChange, self)
  EventManager.Me():AddEventListener(TeamEvent.VoiceBan, self.HandleVoiceBan, self)
  EventManager.Me():AddEventListener(GMEEvent.OnMemberUpdate, self.HandleGMEMemberUpdate, self)
  EventManager.Me():AddEventListener(GMEEvent.OnMemberExit, self.HandleGMEMemberExit, self)
  self:AddListenEvt(SkillEvent.DynamicProps, self.UpdateTeamMemberHP)
  self:AddListenEvt(SkillEvent.ShowTargetPointTip, self.HandleShowTargetPointTip)
  self:AddListenEvt(SkillEvent.HideTargetPointTip, self.HandleHideTargetPointTip)
  self:AddListenEvt(HotKeyEvent.SelectMember, self.HandleHotKeySelectMember)
end

function MainViewTeamPage:HandleGMEMemberUpdate(memberData)
  local members = self.teamCtl:GetCells()
  for _, member in pairs(members) do
    local data = member.data
    if data ~= nil and data ~= MyselfTeamData.EMPTY_STATE and tostring(data.accid) == tostring(memberData.UserId) then
      member:_UpdateGME(memberData)
      return
    end
  end
end

function MainViewTeamPage:HandleGMEMemberExit(memberId)
  local members = self.teamCtl:GetCells()
  for _, member in pairs(members) do
    local data = member.data
    if data ~= nil and data ~= MyselfTeamData.EMPTY_STATE and tostring(data.accid) == tostring(memberId) then
      member:_UpdateGME(nil)
      return
    end
  end
end

function MainViewTeamPage:HandleVoiceChange(note)
  if note then
    local members = self.teamCtl:GetCells()
    for _, member in pairs(members) do
      if member and member.id and tonumber(member.id) == tonumber(note.userId) then
        member.teamHead:UpdateVoice(note.showMic)
      end
    end
  else
    local members = self.teamCtl:GetCells()
    for _, member in pairs(members) do
      member.teamHead:UpdateVoice(false)
    end
  end
end

function MainViewTeamPage:HandleVoiceBan(note)
  if note then
    local members = self.teamCtl:GetCells()
    for _, member in pairs(members) do
      if member and member.id and tonumber(member.id) == tonumber(note.userId) then
        if note.ban == true then
          member.teamHead:SetVoiceBan(true)
        else
          member.teamHead:SetVoiceBan(false)
        end
      end
    end
  else
    local members = self.teamCtl:GetCells()
    for _, member in pairs(members) do
      member.teamHead:UpdateVoice(false)
    end
  end
end

function MainViewTeamPage:HandleQuickEnter(note)
  local members = self.teamCtl:GetCells()
  for _, member in pairs(members) do
    member:UpdateEmptyState()
  end
end

function MainViewTeamPage:HandleFollowStateChange(note)
  local members = self.teamCtl:GetCells()
  for _, member in pairs(members) do
    member:UpdateFollow()
  end
  self:BreakOrJoinHandTip()
end

function MainViewTeamPage:BreakOrJoinHandTip()
  local followId = Game.Myself:Client_GetFollowLeaderID()
  local isHandFollow = Game.Myself:Client_IsFollowHandInHand()
  local handFollowerId = Game.Myself:Client_GetHandInHandFollower()
  local handTargetId = isHandFollow and followId or handFollowerId
  if self.cacheHandTargetId == handTargetId then
    return
  end
  if 0 ~= handTargetId then
    if nil ~= self.cacheHandTargetName then
      MsgManager.ShowMsgByIDTable(886, self.cacheHandTargetName)
    end
    self.cacheHandTargetId = handTargetId
    local memberData = teamProxy.myTeam and teamProxy.myTeam:GetMemberByGuid(handTargetId)
    if memberData then
      self.cacheHandTargetName = memberData.name
      if nil ~= self.cacheHandTargetName then
        MsgManager.ShowMsgByIDTable(885, self.cacheHandTargetName)
      end
    else
      self.cacheHandTargetName = nil
    end
  elseif nil ~= self.cacheHandTargetId then
    if nil ~= self.cacheHandTargetName then
      MsgManager.ShowMsgByIDTable(886, self.cacheHandTargetName)
    end
    self.cacheHandTargetId = nil
    self.cacheHandTargetName = nil
  end
end

function MainViewTeamPage:OnEnter()
  MainViewTeamPage.super.OnEnter(self)
  self:UpdateTeamMember()
end

function MainViewTeamPage:OnDemoRaidLaunch()
  self.isInDemoRaid = true
end

function MainViewTeamPage:OnDemoRaidShutdown()
  self.isInDemoRaid = false
end

function MainViewTeamPage:HandleShowTargetPointTip()
  local skillID = Game.SkillClickUseManager.currentSelectPhaseSkillID
  if skillID == 0 then
    self:HandleHideTargetPointTip(skillID)
  else
    self:ShowTargetPointTip(skillID)
  end
end

function MainViewTeamPage:ShowTargetPointTip(skillID)
  local skillinfo = Game.LogicManager_Skill:GetSkillInfo(skillID)
  if skillinfo and skillinfo:CheckCamps_Friend() then
    local cells = self.teamCtl:GetCells()
    for i = 1, #cells do
      cells[i]:ShowEffect()
    end
  end
end

function MainViewTeamPage:HandleHideTargetPointTip()
  local cells = self.teamCtl:GetCells()
  for i = 1, #cells do
    cells[i]:ClearEffect()
  end
end

function MainViewTeamPage:HandleHotKeySelectMember(note)
  local index = note and note.body and note.body.index
  if not index or index <= 0 then
    return
  end
  local cells = self.teamCtl:GetCells()
  if not cells or index > #cells then
    return
  end
  local cell = cells[index]
  if cell.data ~= MyselfTeamData.EMPTY_STATE then
    self:ClickTeamPlayer(cell)
  end
end

function MainViewTeamPage:UpdateHotKeyTip()
  local cells = self.teamCtl:GetCells()
  local scale = 1.6666666666666667
  for i = 1, #cells do
    local ui = cells[i].widget
    if cells[i].data ~= MyselfTeamData.EMPTY_STATE then
      Game.HotKeyTipManager:RegisterHotKeyTip(8 + i, ui, NGUIUtil.AnchorSide.TopLeft, nil, {
        scale,
        scale,
        scale
      })
    else
      Game.HotKeyTipManager:RemoveHotKeyTip(8 + i, ui)
    end
  end
end
