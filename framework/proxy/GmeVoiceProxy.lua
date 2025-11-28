GmeVoiceProxy = class("GmeVoiceProxy", pm.Proxy)
GmeVoiceProxy.Instance = nil
GmeVoiceProxy.NAME = "GmeVoiceProxy"
GmeVoiceProxy.eTeamType = {
  eNone = 0,
  eSingle = 1,
  eGroup = 2
}
GmeVoiceProxy.memberOffLineTime = 120

function GmeVoiceProxy:ctor(proxyName)
  self.proxyName = proxyName or GmeVoiceProxy.NAME
  if GmeVoiceProxy.Instance == nil then
    GmeVoiceProxy.Instance = self
    self:InitData()
  end
end

function GmeVoiceProxy:Init()
  if BackwardCompatibilityUtil.CompatibilityMode_V64 then
    redlog("GME -> INIT CompatibilityMode_V64")
    return false
  end
  if not self.m_isInit then
    if self.m_gmeMgr == nil then
      local go = GameObject.Find("_gmeMgr")
      if go == nil then
        go = GameObject("_gmeMgr")
        GameObject.DontDestroyOnLoad(go)
      end
      self.m_gmeMgr = go:AddComponent(GMEMgr)
    end
    local openId = Game.Myself.data.id
    redlog("open id : " .. tostring(openId))
    self.m_gmeMgr:AddEvents()
    self.m_gmeMgr:GME_Init(openId, nil)
  end
  return true
end

function GmeVoiceProxy:InitData()
  self.m_roomDisconnect = false
  self.m_isInit = false
  self.memberMap = {}
  self.m_gmeMgr = nil
  if not BackwardCompatibilityUtil.CompatibilityMode_V64 then
    local go = GameObject.Find("_gmeMgr")
    if go == nil then
      go = GameObject("_gmeMgr")
      GameObject.DontDestroyOnLoad(go)
    end
    self.m_gmeMgr = go:AddComponent(GMEMgr)
    self:AddEvents()
  else
    redlog("GME -> InitData CompatibilityMode_V64")
  end
end

function GmeVoiceProxy:AddEvents()
  if self.m_gmeMgr ~= nil then
    function self.m_gmeMgr.onUpdateMember(member)
      self:UpdateMember(member)
    end
    
    function self.m_gmeMgr.onExitRoomCallback(userId)
      if userId ~= "" then
        self:MemberExitRoom(userId)
      end
    end
  end
end

function GmeVoiceProxy:RemoveEvents()
  if self.m_gmeMgr ~= nil then
    self.m_gmeMgr:RemoveEvents()
    self.m_gmeMgr.onUpdateMember = nil
    self.m_gmeMgr.onExitRoomCallback = nil
  end
end

function GmeVoiceProxy:UpdateRoomId()
  local teamProxy = TeamProxy.Instance
  local curServer = FunctionLogin.Me():getCurServerData()
  local team = teamProxy.myTeam
  local groupid, teamid
  if teamProxy:IHaveTeam() then
    teamid = team.id
  end
  if teamProxy:IHaveGroup() then
    groupid = team.uniteteamid
  end
  if groupid ~= nil and teamid ~= nil then
    if teamid < groupid then
      self.roomId = tostring(curServer.serverid) .. "_" .. tostring(groupid) .. "_" .. tostring(teamid)
    else
      self.roomId = tostring(curServer.serverid) .. "_" .. tostring(teamid) .. "_" .. tostring(groupid)
    end
  else
    self.roomId = tostring(curServer.serverid) .. "_" .. tostring(teamid)
  end
end

function GmeVoiceProxy:UpdateMember(member)
  self.memberMap[member.UserId] = member
  EventManager.Me():PassEvent(GMEEvent.OnMemberUpdate, member)
end

function GmeVoiceProxy:GetMemberById(userId)
  return self.memberMap[tostring(userId)]
end

function GmeVoiceProxy:MemberExitRoom(userId)
  redlog("GME ->  MemberExitRoom " .. tostring(userId))
  if self.memberMap[userId] ~= nil then
    self.memberMap[userId] = nil
    EventManager.Me():PassEvent(GMEEvent.OnMemberExit, userId)
  end
end

function GmeVoiceProxy:EnterRoom()
  self:UpdateRoomId()
  local userId = FunctionGetIpStrategy.Me():getAccId()
  helplog("GME -> roomid: " .. tostring(self.roomId) .. " memberId :" .. tostring(userId))
  if self.m_gmeMgr ~= nil then
    self.m_gmeMgr:EnterRoom(self.roomId, userId)
  end
end

function GmeVoiceProxy:ExitRoom()
  if self.m_gmeMgr ~= nil and self.m_gmeMgr:IsRoomEntered() then
    redlog("GME -> CALL EXIT ROOM")
    self.m_gmeMgr:ExitRoom()
  end
end

function GmeVoiceProxy:SetMic(isOn)
  if self.m_gmeMgr ~= nil then
    self.m_gmeMgr:SwitchMic(isOn)
  end
end

function GmeVoiceProxy:GetMic()
  if self.m_gmeMgr ~= nil then
    return GMEMgr.GetMicState() == 1
  end
  return false
end

function GmeVoiceProxy:SetSpeaker(isOn)
  if self.m_gmeMgr ~= nil then
    self.m_gmeMgr:SwitchSpeaker(isOn)
  end
end

function GmeVoiceProxy:GetSpeaker()
  if self.m_gmeMgr ~= nil then
    return GMEMgr.GetSpeakerState() == 1
  end
  return false
end

function GmeVoiceProxy:SetVolumn(mute)
  if self.m_gmeMgr ~= nil then
    self.m_gmeMgr:SetVolumn(not mute)
  end
end

function GmeVoiceProxy:IsInRoom()
  return self.m_gmeMgr ~= nil and self.m_gmeMgr:IsRoomEntered()
end

function GmeVoiceProxy:setIsBan(id, isBan)
  if self:IsInRoom() then
    if isBan then
      self.m_gmeMgr:BanAudio(id)
    else
      self.m_gmeMgr:RemoveBan(id)
    end
  end
end

function GmeVoiceProxy:addToMyselfBanList(id)
  if self.m_myselfBanList == nil then
    self.m_myselfBanList = {}
  end
  self:setIsBan(id, true)
  table.insert(self.m_myselfBanList, id)
end

function GmeVoiceProxy:removeMyselfBanList(id)
  for i = #self.m_myselfBanList, 1, -1 do
    if self.m_myselfBanList[i] == id then
      self:setIsBan(id, false)
      table.remove(self.m_myselfBanList, i)
      break
    end
  end
end

function GmeVoiceProxy:clearMyselfBanList()
  if self.m_myselfBanList == nil then
    return
  end
  for i = #self.m_myselfBanList, 1, -1 do
    self:setIsBan(self.m_myselfBanList[i], false)
    table.remove(self.m_myselfBanList, i)
  end
  self.m_myselfBanList = {}
end

function GmeVoiceProxy:isInMyselfBanList(id)
  if self.m_myselfBanList == nil then
    return false
  end
  for _, v in ipairs(self.m_myselfBanList) do
    if v == id then
      return true
    end
  end
  return false
end

function GmeVoiceProxy:OnDestroy()
  self.roomId = nil
  self.teamId = nil
  self.groupId = nil
  self:RemoveEvents()
end

function GmeVoiceProxy:CanEnterRoom()
  if BackwardCompatibilityUtil.CompatibilityMode_V64 then
    redlog("GME -> CompatibilityMode_V64")
    MsgManager.ShowMsgByID(43023)
    return false
  end
  if self.m_gmeMgr == nil then
    return false
  end
  return true
end

function GmeVoiceProxy:checkIsNeedChangeRoom(memberCount, onlineCount)
  if self:IsInRoom() then
    local code = self:isCanUseGME(memberCount, onlineCount)
    if code == 0 then
      self:UpdateRoomId()
      local oldRoomId = self.m_gmeMgr:GetRoomID()
      if oldRoomId ~= "" and oldRoomId ~= self.roomId then
        redlog("GME -> changed room form id = " .. oldRoomId .. " to " .. self.roomId)
        self.m_gmeMgr:ChangeRoom(self.roomId)
      end
    end
  end
end

function GmeVoiceProxy:isCanUseGME(memberCount, onlineCount)
  redlog("GME -> CURRENT MEMBER COUNT = " .. memberCount .. " ONLINE COUNT = " .. onlineCount)
  if TeamProxy.Instance:IHaveTeam() or TeamProxy.Instance:IHaveGroup() then
    if 2 <= onlineCount and onlineCount <= memberCount then
      return 0
    elseif onlineCount < 2 then
      return 2
    end
  end
  return 1
end

function GmeVoiceProxy:unInit()
  if self.m_gmeMgr ~= nil then
    self.m_gmeMgr:GME_UnInit()
    self:RemoveEvents()
    redlog("GME -> uninit.")
  end
  self.m_isInit = false
end

function GmeVoiceProxy:showTeamPageButton(data, funckeys)
  if data.offline == 0 and data.cat == 0 and data.accid ~= 0 then
    local gme = GmeVoiceProxy.Instance
    if gme:IsInRoom() then
      if gme:isInMyselfBanList(data.id) then
        table.insert(funckeys, "GME_VoiceScreenDecoding")
      else
        table.insert(funckeys, "GME_VoiceShielding")
      end
      if TeamProxy.Instance:CheckIHaveLeaderAuthority() then
        local isInMyTeam = false
        local team = TeamProxy.Instance.myTeam
        local list = team:GetMembersList()
        for _, v in pairs(list) do
          if v.accid == data.accid then
            isInMyTeam = true
            break
          end
        end
        if isInMyTeam then
          if data.mute ~= 0 then
            table.insert(funckeys, "GME_LiftingTheBan")
          else
            table.insert(funckeys, "GME_ForbiddenWords")
          end
        end
      end
    end
  end
end

function GmeVoiceProxy:isInitSuccess()
  return self.m_isInit
end

function GmeVoiceProxy:onDealyCheckExitRoom(tb, func)
  self:removeExitRoomTickTime()
  self.m_checkSelf = tb
  self.m_checkFunc = func
  self.m_checkExitRoomTickTime = TimeTickManager.Me():CreateTick(0, 33, self.onCheckIsCanExitRoom, self, 9999)
end

function GmeVoiceProxy:onCheckIsCanExitRoom()
  self.m_curTime = self.m_curTime + 0.033
  if self.m_curTime < self.memberOffLineTime then
    return
  end
  if self.m_checkSelf ~= nil and self.m_checkFunc ~= nil then
    self.m_checkFunc(self.m_checkSelf)
  end
  self:removeExitRoomTickTime()
end

function GmeVoiceProxy:removeExitRoomTickTime()
  if self.m_checkExitRoomTickTime ~= nil then
    TimeTickManager.Me():ClearTick(self, 9999)
    self.m_checkExitRoomTickTime = nil
  end
  self.m_curTime = 0
end

function GmeVoiceProxy:clearGmeData()
  self:ExitRoom()
  if self.m_gmeMgr ~= nil then
    GameObject.DestroyImmediate(self.m_gmeMgr.gameObject)
    self.m_gmeMgr = nil
  end
end

function GmeVoiceProxy:onGMEInitCB(isSuccess, code)
  redlog("GME -> Init Success")
  if isSuccess or code == 7015 then
    self.m_isInit = true
  else
    self.m_isInit = false
    redlog("GME -> Init failed code = " .. code)
  end
end

function GmeVoiceProxy:onGMEDestroyCB()
  self.m_roomDisconnect = false
  self:ExitRoom()
  self:unInit()
  self.m_gmeMgr = nil
  redlog("GME -> destory.")
end

function GmeVoiceProxy:onEnterRoomCompleteCB(code, infoMsg)
  if tonumber(code) == 0 then
    self.m_roomDisconnect = false
    self:SetMic(false)
    self:SetSpeaker(true)
    EventManager.Me():PassEvent(GMEEvent.OnEnterRoom)
  else
    redlog("GME -> enter room failed. code = " .. code .. " errinfo = " .. infoMsg)
  end
end

function GmeVoiceProxy:onExitRoomCompleteCB()
  EventManager.Me():PassEvent(GMEEvent.OnExitRoom)
  self.m_roomDisconnect = false
  self:clearMyselfBanList()
end

function GmeVoiceProxy:onEventCallBack(type, subType, data)
  redlog(string.format("GME -> onEventCallBack | type = %s subType = %s data = %s", tostring(type), tostring(subType), tostring(data)))
end

function GmeVoiceProxy:onCommonEventCallback(type, param0, param1)
  redlog(string.format("GME -> onCommonEventCallback | type = %s param0 = %s param1 = %s", tostring(type), tostring(param0), tostring(param1)))
end

function GmeVoiceProxy:onRoomChangeQualityCallback(nQualityEVA, fLostRate, nDealy)
end

function GmeVoiceProxy:onAudioReadyCallback()
end

function GmeVoiceProxy:onRoomTypeChangedEventCB(nRoomType)
end

function GmeVoiceProxy:onRoomDisconnectCB(code, infoMsg)
  EventManager.Me():DispatchEvent(GMEEvent.OnDisconnect)
  self.m_roomDisconnect = true
  redlog(string.format("GME -> disconnect. | code = %s infomsg = %s", tostring(code), tostring(infoMsg)))
end
