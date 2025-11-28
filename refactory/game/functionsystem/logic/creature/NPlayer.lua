autoImport("Creature_SceneUI")
NPlayer = reusableClass("NPlayer", NCreatureWithPropUserdata)
NPlayer.PoolSize = 80
autoImport("NPlayer_Effect")
autoImport("NPlayer_Logic")
local FindCreature = SceneCreatureProxy.FindCreature

function NPlayer:ctor(aiClass)
  NPlayer.super.ctor(self, aiClass)
  self.sceneui = nil
  self.skill = ServerSkill.new()
  self.userDataManager = Game.LogicManager_Player_Userdata
  self.propmanager = Game.LogicManager_Player_Props
end

function NPlayer:GetCreatureType()
  return Creature_Type.Player
end

function NPlayer:GetSceneUI()
  return self.sceneui
end

function NPlayer:AllowSpEffect_OnFloor()
  if nil == self.ai.parent and not self:IsOnSceneSeat() then
    local head = self.data.userdata:Get(UDEnum.HEAD)
    if 45086 == head or 145086 == head then
      return true
    end
  end
  return false
end

local selfUpdateEffect = NPlayer._UpdateEffect
local superUpdate = NPlayer.super.Update

function NPlayer:Update(time, deltaTime)
  superUpdate(self, time, deltaTime)
  selfUpdateEffect(self, time, deltaTime)
end

function NPlayer:InitAssetRole()
  NPlayer.super.InitAssetRole(self)
  local assetRole = self.assetRole
  assetRole:SetGUID(self.data.id)
  assetRole:SetName(self.data:GetName())
  assetRole:SetClickPriority(self.data:GetClickPriority())
  assetRole:SetInvisible(false)
  assetRole:SetShadowEnable(true)
  assetRole:SetRenderEnable(true)
  assetRole:SetColliderEnable(true)
  assetRole:SetWeaponDisplay(true)
  assetRole:SetMountDisplay(true)
  assetRole:SetActionSpeed(1)
  assetRole:SetEnableVisibleByCameraPos(self.data:GetCamp() == RoleDefines_Camp.FRIEND)
  assetRole:MountStatusChangeCallback(function(enable)
    self:UpdateRegisterMultiMount(enable)
  end)
  self:UpdateRegisterMultiMount(true)
  self:HandlerAssetRoleSuffixMap()
end

function NPlayer:SetPeakEffectVisible(v, reason)
  local peak = self.data.userdata:Get(UDEnum.PEAK_EFFECT) or 0
  if peak ~= 1 then
    return false
  end
  local peakEffect = self:GetEffect("Peak_Effect")
  if peakEffect ~= nil then
    peakEffect:SetActive(v, reason)
  elseif v then
    self:PlayPeakEffect()
  end
end

function NPlayer:DeterminPriority()
  if TeamProxy.Instance:IsInMyTeam(self.data.id) then
    return LogicManager_RoleDress.Priority.Team
  end
  if FriendProxy.Instance:IsFriend(self.data.id) then
    return LogicManager_RoleDress.Priority.Friend
  end
  if TeamProxy.Instance:IsInMyGroup(self.data.id) then
    return LogicManager_RoleDress.Priority.GroupTeam
  end
  if GuildProxy.Instance:CheckPlayerInMyGuild(self.data.id) then
    return LogicManager_RoleDress.Priority.Guild
  end
  return LogicManager_RoleDress.Priority.Normal
end

function NPlayer:GetDressPriority()
  return self.priority
end

function NPlayer:OnAvatarPriorityChanged()
  local newPriority = self:DeterminPriority()
  if newPriority == self.priority then
    LogUtility.InfoFormat("<color=red>Bug!!! Same priority: </color>{0}", newPriority)
    return
  end
  local oldPriority = self.priority
  self.priority = newPriority
  local isIsolated = Game.Myself.data:GetWithoutTeammate()
  if newPriority ~= LogicManager_RoleDress.Priority.Team then
    self:SetClientIsolate(false)
  elseif isIsolated and newPriority == LogicManager_RoleDress.Priority.Team then
    self:SetClientIsolate(true)
  elseif not isIsolated then
    self:SetClientIsolate(false)
  end
  Game.LogicManager_RoleDress:RefreshPriority(self, oldPriority, newPriority)
end

function NPlayer:ReDress()
  if self._changeJobTimeFlag then
    return
  end
  NPlayer.super.ReDress(self)
end

function NPlayer:Sever_SetTitleID(serverTitleData)
  if serverTitleData then
    self.data:SetAchievementtitle(serverTitleData.id)
    local sceneUI = self:GetSceneUI() or nil
    if sceneUI then
      sceneUI.roleBottomUI:HandleChangeTitle(self)
    end
  end
end

function NPlayer:RegisterRoleDress()
  Game.LogicManager_RoleDress:Add(self)
end

function NPlayer:UnregisterRoleDress()
  Game.LogicManager_RoleDress:Remove(self)
end

local _ClickTopChatRoom = function(playerID)
  FunctionSecurity.Me():TryDoRealNameCentify(function(go)
    local isInGagTime, time = MyselfProxy.Instance:IsInGagTime()
    if isInGagTime then
      MsgManager.ShowMsgByID(92, math.floor(time / 60))
      return
    end
    local player = NSceneUserProxy.Instance:Find(playerID)
    local zoomInfo
    if player ~= nil then
      zoomInfo = player.data.chatRoomData
    end
    if not zoomInfo then
      return
    end
    if zoomInfo.curnum >= zoomInfo.maxnum then
      MsgManager.ShowMsgByIDTable(808)
    elseif ChatZoomProxy.Instance:CachedZoomInfo() then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.ChatRoomPage,
        viewdata = {key = "ChatZone"}
      })
    elseif zoomInfo.pswd == "" then
      ServiceChatRoomProxy.Instance:CallJoinChatRoom(zoomInfo.roomid, "")
    else
      GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
        viewname = "InputSecretChatZoom"
      })
      GameFacade.Instance:sendNotification(ChatZoomEvent.TransmitChatZoomSummary, zoomInfo)
    end
  end, callbackParam)
end

function NPlayer:CreateChatRoom(chatRoomInfo)
  self.data:InitChatRoomData(chatRoomInfo)
  local chatRoomData = self.data.chatRoomData
  if chatRoomData and self.sceneui then
    local icon = chatRoomData.roomtype == SceneChatRoom_pb.ECHATROOMTYPE_PUBLIC and "69" or "70"
    local str1 = chatRoomData.name
    local str2 = "(" .. chatRoomData.curnum .. "/" .. chatRoomData.maxnum .. ")"
    local text = {left = str1, right = str2}
    self.sceneui.roleTopUI:SetTopFuncFrame(text, icon, _ClickTopChatRoom, chatRoomData.ownerid, self)
  end
end

function NPlayer:UpdateChatRoom(chatRoomInfo)
  self:DestroyChatRoom()
  self:CreateChatRoom(chatRoomInfo)
end

function NPlayer:DestroyChatRoom(withData)
  if self.sceneui then
    self.sceneui.roleTopUI:RemoveTopFuncFrame()
  end
  if withData and self.data.chatRoomData then
    self.data.chatRoomData:Destroy()
    self.data.chatRoomData = nil
  end
end

local _ClickTopBooth = function(playerID)
  local player = NSceneUserProxy.Instance:Find(playerID)
  if player == nil then
    return
  end
  BoothProxy.Instance:SafeJumpBoothMainView(playerID)
end

function NPlayer:UpdateBooth(boothInfo, serverid)
  if serverid then
    local groupid = ChangeZoneProxy.Instance:GetTradeGroupID(serverid)
    if not MyselfProxy.Instance:IsSameTradeGroup(groupid) then
      return
    end
  end
  if self.sceneui and boothInfo and #boothInfo.name > 0 then
    self.data:UpdateBoothData(boothInfo)
    local boothData = self.data.boothData
    local icon = ""
    local scoreConfig = GameConfig.Booth.score[boothData:GetSign()]
    if scoreConfig ~= nil then
      icon = scoreConfig.icon
    end
    self.sceneui.roleTopUI:SetTopFuncFrame(boothData:GetName(), icon, _ClickTopBooth, self.data.id, self, SceneUIType.RoleTopBoothInfo)
  end
end

function NPlayer:DestroyBooth()
  if self.sceneui then
    self.sceneui.roleTopUI:RemoveTopFuncFrame()
  end
  self.data:ClearBoothData()
end

function NPlayer:IsInBooth()
  return self.data.boothData ~= nil
end

local BuffToBallMap
local Init_BuffToBallMap = function()
  if BuffToBallMap ~= nil then
    return
  end
  BuffToBallMap = {}
  local _PvpTeamRaid = GameConfig.PvpTeamRaid
  for raidId, config in pairs(_PvpTeamRaid) do
    BuffToBallMap[raidId] = {}
    local npcsID = config.ElementNpcsID
    for k, v in pairs(npcsID) do
      BuffToBallMap[raidId][v.buffid] = v
    end
  end
end

function NPlayer:GetTeamPwsBall()
  if not Game.MapManager:IsPVPMode_TeamPws() then
    return
  end
  local buffs = self.buffs
  if buffs == nil then
    return
  end
  Init_BuffToBallMap()
  local nowRaid = Game.MapManager:GetRaidID()
  local map = BuffToBallMap[nowRaid] or next(BuffToBallMap)
  for buffid, _ in pairs(buffs) do
    if map[buffid] then
      return true
    end
  end
end

function NPlayer:_InitData(serverData)
  if self.data == nil then
    return PlayerData.CreateAsTable(serverData)
  end
  return nil
end

function NPlayer:IsnotFriendOrGroupTeammate()
  local isnotFriendPet = not FriendProxy.Instance:IsFriend(self.data.id)
  local isnotGroupTeammetePet = not TeamProxy.Instance:IsInMyGroup(self.data.id)
  return isnotFriendPet and isnotGroupTeammetePet
end

function NPlayer:UpdatePartner(pos)
  if self.partner ~= nil then
    self.partner:SetPos(nil, pos)
  end
end

function NPlayer:UpdateRegisterMultiMount(enable)
  if enable then
    Game.InteractNpcManager:UpdateRegisterInteractMount(self.data.id, self.assetRole:GetPartID(Asset_Role.PartIndex.Mount), self)
  else
    local isMyselfRide = Game.InteractNpcManager:IsMyselfRideInteractMount()
    Game.InteractNpcManager:UpdateRegisterInteractMount(self.data.id)
    local myselfID = Game.Myself and Game.Myself.data and Game.Myself.data.id
    if isMyselfRide and self.data.id == myselfID then
      ServiceNUserProxy.Instance:CallKickOffPassengerUserCmd(0, true, false)
    end
  end
end

function NPlayer:UpdateSkillOverAction()
  local profession = self.data.userdata:Get(UDEnum.PROFESSION)
  local data = Table_Class[profession]
  self.skillOverAction = data ~= nil and data.Feature ~= nil and data.Feature & FeatureDefines_Class.SkillOverAction > 0
end

function NPlayer:Server_SetSkillMove(x, y, z)
  return self.skill:SetAttackWorkerMove(self, x, y, z)
end

function NPlayer:UpdateProfession()
  self.data:UpdateProfession()
  self:HandlerAssetRoleSuffixMap()
  self:UpdateSkillOverAction()
  if self.sceneui then
    if self.data:IsAnonymous() then
      self.sceneui.roleBottomUI:HandleChangeTitle(self)
    end
    self.sceneui.roleBottomUI:HandlerPlayerFactionChange(self)
  end
end

function NPlayer:DoConstruct(asArray, serverData)
  self:CreateWeakData()
  local data = self:_InitData(serverData)
  NPlayer.super.DoConstruct(self, asArray, data)
  self:InitAssetRole()
  self:InitLogicTransform(serverData.pos.x, serverData.pos.y, serverData.pos.z, nil, nil)
  self:Server_SetUserDatas(serverData.datas, true)
  self:Server_SetAttrs(serverData.attrs)
  self.sceneui = Creature_SceneUI.CreateAsTable(self)
  self:InitBuffs(serverData)
  local dest = serverData.dest
  if dest and not PosUtil.IsZero(dest) then
    self:Server_MoveToXYZCmd(dest.x, dest.y, dest.z, 1000)
  end
  FunctionPvpObserver.Me():ReAddCreature(self)
  if nil ~= serverData.seatid and 0 ~= serverData.seatid then
    self:Server_GetOnSeat(serverData.seatid)
  end
  if serverData.motionactionid and serverData.motionactionid ~= 0 then
    local actionData = Table_ActionAnime[serverData.motionactionid]
    if actionData then
      local actionName = actionData.Name
      self:Server_PlayActionCmd(actionName, nil, true)
    end
  end
  self:CreateChatRoom(serverData.chatroom)
  self:UpdateBooth(serverData.info, serverData.serverid)
  if self:IsInBooth() then
    self:Update(0, 0)
    EventManager.Me():DispatchEvent(BoothEvent.OpenBooth, self)
  end
  self.priority = self:DeterminPriority()
  self:RegisterRoleDress()
  self:UpdatePartner(serverData.pos)
  self.serverid = serverData.serverid
end

function NPlayer:DoDeconstruct(asArray)
  self:ResetRiderCamera()
  self:PlayTeamCircle(0)
  Game.InteractNpcManager:OnCreatureRecycle(self.data.id)
  Game.InteractNpcManager:UpdateRegisterInteractMount(self.data.id)
  self:UnRegistCulling()
  self:UnregisterRoleDress()
  NPlayer.super.DoDeconstruct(self, asArray)
  if self.sceneui then
    self.sceneui:Destroy()
    self.sceneui = nil
  end
  self.assetRole:Destroy()
  self.assetRole = nil
  self._changeJobTimeFlag = nil
  self.skillOverAction = nil
  self.serverid = nil
end

function NPlayer:ResetRiderCamera()
  local myself = Game.Myself
  if self == myself then
    return
  end
  local myDownID = myself.data:GetDownID()
  if myDownID and myDownID ~= 0 and myDownID == self.data.id then
    myself:ResetCamera(myself)
  end
  if myself.last_down_roleID == self.data.id then
    myself:ResetCamera(myself)
  end
  if myself.last_down_roleID == self.data.id then
    myself:SwitchCamera(myself)
  end
end

local differentRaceHandActionMap = {
  [Asset_Role.ActionName.IdleHandIn] = Asset_Role.ActionName.IdleHandIn .. "2",
  [Asset_Role.ActionName.IdleInHand] = Asset_Role.ActionName.IdleInHand .. "2",
  [Asset_Role.ActionName.MoveHandIn] = Asset_Role.ActionName.MoveHandIn .. "2",
  [Asset_Role.ActionName.MoveInHand] = Asset_Role.ActionName.MoveInHand .. "2"
}

function NPlayer:GetHandActionFrom(actionTypeMap)
  local originalHandAction = actionTypeMap[self.handInHandAction]
  if self.handInHandAction == HandInActionType.Hold or self.handInHandAction == HandInActionType.BeHolded then
    return originalHandAction
  end
  if not originalHandAction then
    return
  end
  if self.data.IsHuman and self.data:IsHuman() then
    return originalHandAction
  end
  local gameMyHandTargetId = Game.Myself:Client_IsFollowHandInHand() and Game.Myself:Client_GetFollowLeaderID() or Game.Myself:Client_GetHandInHandFollower()
  if not gameMyHandTargetId or gameMyHandTargetId == 0 then
    return originalHandAction
  end
  local isOtherAHuman
  if self.data.id == Game.Myself.data.id then
    local gameMyHandTarget = SceneCreatureProxy.FindCreature(gameMyHandTargetId)
    isOtherAHuman = gameMyHandTarget and gameMyHandTarget.data.IsHuman and gameMyHandTarget.data:IsHuman()
    if isOtherAHuman == nil then
      isOtherAHuman = true
    end
  elseif self.data.id == gameMyHandTargetId then
    isOtherAHuman = Game.Myself.data:IsHuman()
  end
  return isOtherAHuman and differentRaceHandActionMap[originalHandAction] or originalHandAction
end

local doubleActionBuffCfg

function NPlayer:TryUpdateSpecialBuff(buffInfo, active, fromID, layer, maxLayer, level)
  NPlayer.super.TryUpdateSpecialBuff(self, buffInfo, active, fromID, layer, maxLayer, level)
  if not doubleActionBuffCfg then
    doubleActionBuffCfg = Game.Config_DoubleActionBuff
  end
  if doubleActionBuffCfg[buffInfo.id] then
    LogUtility.InfoFormat("DoubleActionBuff {0} updated to target {1} with active == {2}", self.data.id, buffInfo.id, active)
    if active and self.data.id == Game.Myself.data.id then
      GameFacade.Instance:sendNotification(MyselfEvent.DoubleAction_Ready, buffInfo.id)
    end
    local sceneUi = self:GetSceneUI()
    if sceneUi then
      sceneUi.roleTopUI:UpdateDoubleActionReady(buffInfo.id, active)
    end
  end
end

local checkFlag = false

function NPlayer:SetDressEnable(v)
  checkFlag = v ~= self.data.dressEnable
  local showCombine = false
  if self.data and checkFlag then
    redlog("SetDressEnable", v)
    local myselfID = Game.Myself and Game.Myself.data and Game.Myself.data.id
    local upID = self.data:GetUpID()
    local downID = self.data:GetDownID()
    local upRole = 0 ~= upID and FindCreature(upID)
    local downRole = 0 ~= downID and FindCreature(downID)
    redlog("SetDressEnable", upID, downID, self.data.id, myselfID)
    if upID == myselfID or downID == myselfID then
      showCombine = true
    elseif v and (upRole and upRole.data:IsDressEnable() or downRole and downRole.data:IsDressEnable()) then
      showCombine = true
    end
    if showCombine then
      if upRole then
        if not upRole.data:IsDressEnable() then
          upRole.data.dressEnable = true
          upRole:ReDress()
        end
        self.assetRole:PutInCreatureToCP(RoleDefines_CP.Wing, upRole)
      end
      redlog("showCombine", downRole and downRole.data:IsDressEnable())
      if downRole then
        if not downRole.data:IsDressEnable() then
          downRole.data.dressEnable = true
          downRole:ReDress()
        end
        if not downRole.data:IsPippi() then
          downRole.assetRole:PutInCreatureToCP(RoleDefines_CP.Wing, self)
        end
        self:ReDress()
      end
    else
      if downRole then
        downRole.assetRole:TakeOutCreatureInCP(RoleDefines_CP.Wing)
      else
        redlog("downRole", downID)
      end
      if upRole then
        self.assetRole:TakeOutCreatureInCP(RoleDefines_CP.Wing)
      else
        redlog("upRole", upID)
      end
    end
  end
  redlog("NPlayer SetDressEnable", self.data.id, showCombine or v)
  NPlayer.super.SetDressEnable(self, showCombine or v)
end
