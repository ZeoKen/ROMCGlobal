autoImport("PvpCustomRoomData")
PvpCustomRoomProxy = class("PvpCustomRoomProxy", pm.Proxy)
PvpCustomRoomProxy.Instance = nil
PvpCustomRoomProxy.NAME = "PvpCustomRoomProxy"
local MinCustomRoomReqInterval_1 = 500
local MinCustomRoomReqInterval_2 = 1000
local MinCustomRoomReqInterval_3 = 3000
PvpCustomRoomProxy.CreateRoomMode = {EnterPreview = 1, InRoomPreview = 2}
local CurrentRoomDataEvent = {
  Enter = 1,
  Leave = 2,
  Update = 3
}
local EmptyTable = {}
local _RoomPopupConfig

function PvpCustomRoomProxy.GetRoomPopup(type)
  if not _RoomPopupConfig then
    _RoomPopupConfig = {
      [PvpProxy.Type.TwelvePVPRelax] = PanelConfig.PvpCustomRoomPopup,
      [PvpProxy.Type.FreeBattle] = PanelConfig.TeamPwsCustomRoomInfoPopup
    }
  end
  return _RoomPopupConfig[type]
end

PvpCustomRoomProxy.CurrentRoomDataEvent = CurrentRoomDataEvent

function PvpCustomRoomProxy:ctor(proxyName, data)
  self.proxyName = proxyName or PvpCustomRoomProxy.NAME
  if PvpCustomRoomProxy.Instance == nil then
    PvpCustomRoomProxy.Instance = self
  end
  if data ~= nil then
    self:SetData(data)
  end
  self:Init()
end

function PvpCustomRoomProxy:Init()
  self.roomList = {}
  self.roomListPage = 0
  self.currentRoom = nil
  self.savedBanList = {}
end

function PvpCustomRoomProxy:GetTeamHomeList()
  return self.currentRoom and self.currentRoom.homeMembers or nil
end

function PvpCustomRoomProxy:GetTeamAwayList()
  return self.currentRoom and self.currentRoom.awayMembers or nil
end

function PvpCustomRoomProxy:GetTeamObList()
  return self.currentRoom and self.currentRoom.obMembers or nil
end

function PvpCustomRoomProxy:SendRoomListReq(etype, raidid)
  local curClientTime = ServerTime.CurClientTime()
  if self.lastQueryRoomListTime and curClientTime - self.lastQueryRoomListTime < MinCustomRoomReqInterval_1 then
    MsgManager.ShowMsgByID(49)
    return
  end
  self.lastQueryRoomListTime = curClientTime
  if self.lastQueryRaidId ~= raidid then
    self.lastQueryRaidId = raidid
    self.roomListPage = nil
  end
  local page = self.roomListPage and self.roomListPage + 1 or 1
  ServiceMatchCCmdProxy.Instance:CallReserveRoomListMatchCCmd(etype, raidid or 0, page)
end

function PvpCustomRoomProxy:GetRoomList()
  return self.roomList
end

function PvpCustomRoomProxy:ClearRoomList()
  self.roomList = nil
end

function PvpCustomRoomProxy:HandleRoomListResp(data)
  if not data then
    return
  end
  if not self.roomList then
    self.roomList = {}
  end
  self.roomListPage = data.page or 1
  local lastLen = #self.roomList
  local curLen = data.roominfo and #data.roominfo or 0
  for i = 1, curLen do
    if i <= lastLen then
      self.roomList[i]:SetData(data.roominfo[i])
    else
      self.roomList[i] = PvpCustomRoomData.new(data.roominfo[i])
    end
  end
  for i = lastLen, curLen + 1, -1 do
    table.remove(self.roomList)
  end
end

function PvpCustomRoomProxy:GetRoomMenuList(type)
  if not self.raidModeList then
    self.raidModeList = {
      [MatchCCmd_pb.EPVPTYPE_TEAMPWS_RELAX] = {
        {
          etype = MatchCCmd_pb.EPVPTYPE_TEAMPWS_RELAX,
          raidid = 0,
          name = ZhString.TeamFindPopUp_AllTeam
        }
      },
      [MatchCCmd_pb.EPVPTYPE_TWELVE_RELAX] = {}
    }
    local raidConfig = GameConfig.ReserveRoom and GameConfig.ReserveRoom.RaidMaps
    if raidConfig then
      for _, v in ipairs(raidConfig) do
        local array = self.raidModeList[v.etype]
        if array then
          array[#array + 1] = {
            etype = v.etype,
            raidid = v.raidid,
            name = v.name
          }
        end
      end
    else
      redlog("未找到配置 GameConfig.ReserveRoom.RaidMaps")
    end
  end
  return self.raidModeList[type] or {}
end

function PvpCustomRoomProxy:GetRaidConfigs(pvpType)
  if not pvpType then
    return
  end
  if not self.raidConfigMap then
    self.raidConfigMap = {}
  end
  local raidConfigs = self.raidConfigMap[pvpType]
  if not raidConfigs then
    raidConfigs = {}
    local raidMaps = GameConfig.ReserveRoom.RaidMaps
    for _, v in ipairs(raidMaps) do
      if v.etype == pvpType then
        table.insert(raidConfigs, {
          etype = v.etype,
          raidid = v.raidid,
          name = v.name
        })
      end
    end
    self.raidConfigMap[pvpType] = raidConfigs
  end
  return raidConfigs
end

function PvpCustomRoomProxy:GetRaidConfigByRaidId(raidid, pvptype)
  local raidConfigs = self:GetRaidConfigs(pvptype)
  if not raidConfigs then
    return
  end
  for _, v in ipairs(raidConfigs) do
    if v.raidid == raidid then
      return v
    end
  end
end

function PvpCustomRoomProxy:GetCurrentRoomData()
  return self.currentRoom
end

function PvpCustomRoomProxy:GetCurrentRoomDataOfType(pvpType)
  if self.currentRoom and self.currentRoom.pvptype == pvpType then
    return self.currentRoom
  end
end

function PvpCustomRoomProxy:DoesCurrentRoomSupportDiffServer()
  return self.currentRoom and TeamProxy.Instance:CheckRaidIdSupportDiffServer(self.currentRoom.raidid) or false
end

function PvpCustomRoomProxy:IsCurrentRoomHost(guid)
  return self.currentRoom and self.currentRoom:IsHost(guid) or false
end

function PvpCustomRoomProxy:SendCreateRoomReq(eType, raidId, isFreeFire, passwd, profession, relics, food, artifact, bancards, isforbidcard)
  local curClientTime = ServerTime.CurClientTime()
  if self.lastCreateRoomReqTime and curClientTime - self.lastCreateRoomReqTime < MinCustomRoomReqInterval_3 then
    MsgManager.ShowMsgByID(49)
    return
  end
  self.lastCreateRoomReqTime = curClientTime
  self.openRoomPanelOnNextUpdate = true
  ServiceMatchCCmdProxy.Instance:CallReserveRoomBuildMatchCCmd(eType, raidId, isFreeFire, passwd, profession, relics, food, artifact, bancards, isforbidcard)
  return true
end

function PvpCustomRoomProxy:HandleCurrentRoomInfoResp(data)
  if not data then
    return
  end
  local roomDataEvent = self.currentRoom == nil and CurrentRoomDataEvent.Enter or CurrentRoomDataEvent.Update
  if not self.currentRoom then
    self.currentRoom = PvpCustomRoomData.new()
  end
  local lastInBattle = self.currentRoom.inbattle
  self.currentRoom:DeleteMembers(data.delmembers)
  self.currentRoom:SetData(data.myroom, data.teamone, data.teamtwo, data.teamob)
  EventManager.Me():DispatchEvent(CustomRoomEvent.OnCurrentRoomChanged, {
    event = roomDataEvent,
    pvptype = self.currentRoom.pvptype
  })
  if lastInBattle ~= nil and self.currentRoom.inbattle ~= lastInBattle then
    if self.currentRoom.inbattle then
      GameFacade.Instance:sendNotification(CustomRoomEvent.OnEnterBattle, self.currentRoom.inbattle)
    else
      GameFacade.Instance:sendNotification(CustomRoomEvent.OnExitBattle, self.currentRoom.inbattle)
    end
  end
  local readyDirty = false
  if data.teamone and self.readyHomeMembers then
    for _, v in ipairs(data.teamone) do
      for _, member in ipairs(self.readyHomeMembers) do
        if member.charid == v.charid then
          member:SetData(v)
          readyDirty = true
          break
        end
      end
    end
  end
  if data.teamtwo and self.readyAwayMembers then
    for _, v in ipairs(data.teamtwo) do
      for _, member in ipairs(self.readyAwayMembers) do
        if member.charid == v.charid then
          member:SetData(v)
          readyDirty = true
          break
        end
      end
    end
  end
  if readyDirty then
    EventManager.Me():DispatchEvent(CustomRoomEvent.OnReadyStateUpdate)
  end
  if self.openRoomPanelOnNextUpdate then
    self.openRoomPanelOnNextUpdate = nil
    self:OpenRoomInfoPopup()
  end
end

function PvpCustomRoomProxy:IsInReadyMemberList(charid)
  if self.readyHomeMembers then
    for _, member in ipairs(self.readyHomeMembers) do
      if member.charid == charid then
        return true
      end
    end
  end
  if self.readyAwayMembers then
    for _, member in ipairs(self.readyAwayMembers) do
      if member.charid == charid then
        return true
      end
    end
  end
  return false
end

function PvpCustomRoomProxy:SendLeaveRoomReq()
  local curClientTime = ServerTime.CurClientTime()
  if self.lastLeaveRoomReqTime and curClientTime - self.lastLeaveRoomReqTime < MinCustomRoomReqInterval_2 then
    MsgManager.ShowMsgByID(49)
    return
  end
  self.lastLeaveRoomReqTime = curClientTime
  ServiceMatchCCmdProxy.Instance:CallReserveRoomLeaveMatchCCmd()
end

function PvpCustomRoomProxy:HandleLeaveRoomResp(data)
  local pvpType = self.currentRoom and self.currentRoom.pvptype
  self.currentRoom = nil
  EventManager.Me():DispatchEvent(CustomRoomEvent.OnCurrentRoomChanged, {
    event = CurrentRoomDataEvent.Leave,
    pvptype = pvpType
  })
  self:StopReadyCountdown()
end

function PvpCustomRoomProxy:SendKickMemberReq(charid)
  if not charid then
    return
  end
  if not self:IsCurrentRoomHost(Game.Myself.data.id) then
    return
  end
  local curClientTime = ServerTime.CurClientTime()
  if self.lastKickReqTime and curClientTime - self.lastKickReqTime < MinCustomRoomReqInterval_2 then
    MsgManager.ShowMsgByID(49)
    return
  end
  self.lastKickReqTime = curClientTime
  ServiceMatchCCmdProxy.Instance:CallReserveRoomKickMatchCCmd(charid)
end

function PvpCustomRoomProxy:SendEnterRoomReq(roomid, password)
  if not roomid then
    return
  end
  if self.currentRoom ~= nil then
    MsgManager.ShowMsgByID(475)
    return
  end
  local curMatchState = PvpProxy.Instance:GetCurMatchStatus()
  if curMatchState then
    MsgManager.ShowMsgByID(476)
  end
  local curClientTime = ServerTime.CurClientTime()
  if self.lastEnterRoomReqTime and curClientTime - self.lastEnterRoomReqTime < MinCustomRoomReqInterval_1 then
    MsgManager.ShowMsgByID(49)
    return
  end
  self.lastEnterRoomReqTime = curClientTime
  self.openRoomPanelOnNextUpdate = true
  ServiceMatchCCmdProxy.Instance:CallReserveRoomApplyMatchCCmd(roomid, password)
end

function PvpCustomRoomProxy:GetCurrentTeamIndex(guid)
  local teamList = self:GetTeamHomeList()
  if teamList then
    for _, v in ipairs(teamList) do
      if v.charid == guid then
        return EROOMTEAMTYPE.EROOMTEAMTYPE_TEAMONE
      end
    end
  end
  teamList = self:GetTeamAwayList()
  if teamList then
    for _, v in ipairs(teamList) do
      if v.charid == guid then
        return EROOMTEAMTYPE.EROOMTEAMTYPE_TEAMTWO
      end
    end
  end
  teamList = self:GetTeamObList()
  if teamList then
    for _, v in ipairs(teamList) do
      if v.charid == guild then
        return EROOMTEAMTYPE.EROOMTEAMTYPE_TEAMOB
      end
    end
  end
end

function PvpCustomRoomProxy:SendChangeTeamReq(teamtype)
  local currentTeam = self:GetCurrentTeamIndex(Game.Myself.data.id)
  if currentTeam == teamtype then
    return
  end
  local curClientTime = ServerTime.CurClientTime()
  if self.lastChangeTeamReqTime and curClientTime - self.lastChangeTeamReqTime < MinCustomRoomReqInterval_1 then
    MsgManager.ShowMsgByID(49)
    return
  end
  self.lastChangeTeamReqTime = curClientTime
  ServiceMatchCCmdProxy.Instance:CallReserveRoomChangeMatchCCmd(teamtype)
  return true
end

function PvpCustomRoomProxy:SendStartGameReq()
  if not self.currentRoom then
    return
  end
  if not self:IsCurrentRoomHost(Game.Myself.data.id) then
    return
  end
  if not self.currentRoom:CanStart() then
    return
  end
  local curClientTime = ServerTime.CurClientTime()
  if self.lastStartGameReqTime and curClientTime - self.lastStartGameReqTime < MinCustomRoomReqInterval_3 then
    MsgManager.ShowMsgByID(49)
    return
  end
  self.lastStartGameReqTime = curClientTime
  ServiceMatchCCmdProxy.Instance:CallReserveRoomStartMatchCCmd()
  return true
end

function PvpCustomRoomProxy:SendInviteReq(charid, teamtype)
  ServiceMatchCCmdProxy.Instance:CallReserveRoomInviterMatchCCmd(charid, nil, teamtype)
end

function PvpCustomRoomProxy:SendInviteResp(accept, name)
  ServiceMatchCCmdProxy.Instance:CallReserveRoomInviteeMatchCCmd(accept, name)
  if accept then
    self.openRoomPanelOnNextUpdate = true
  end
end

function PvpCustomRoomProxy:SendReadyResp(isask, prepare)
  local curClientTime = ServerTime.CurClientTime()
  if self.lastReadyReqTime and curClientTime - self.lastReadyReqTime < MinCustomRoomReqInterval_1 then
    MsgManager.ShowMsgByID(49)
    return
  end
  self.lastReadyReqTime = curClientTime
  ServiceMatchCCmdProxy.Instance:CallReserveRoomPrepareMatchCCmd(isask, prepare)
end

function PvpCustomRoomProxy:SendReadyAskReq()
  if not self:IsCurrentRoomHost(Game.Myself.data.id) then
    return
  end
  if self:IsReadyActive() then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TeamPwsCustomRoomReadyPopup
    })
    return
  end
  ServiceMatchCCmdProxy.Instance:CallReserveRoomPrepareMatchCCmd(true)
end

local readyDuration = GameConfig.ReserveRoom and GameConfig.ReserveRoom.PrepareTimeout or 30

function PvpCustomRoomProxy:HandleReadyResp(data)
  if not self.currentRoom then
    return
  end
  local currentTime = ServerTime.CurClientTime() / 1000
  self:StartReadyCoundown(currentTime, currentTime + readyDuration)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.TeamPwsCustomRoomReadyPopup
  })
end

function PvpCustomRoomProxy:CopyReadyMembers()
  if not self.currentRoom then
    return
  end
  self.readyHomeMembers = {}
  for _, v in ipairs(self.currentRoom.homeMembers) do
    if v.id then
      local member = PvpCustomRoomMemberData.new(v, v.teamtype)
      member.prepare = v.id == self.currentRoom.leaderid and true or nil
      self.readyHomeMembers[#self.readyHomeMembers + 1] = member
    end
  end
  self.readyAwayMembers = {}
  for _, v in ipairs(self.currentRoom.awayMembers) do
    if v.id then
      local member = PvpCustomRoomMemberData.new(v, v.teamtype)
      member.prepare = v.id == self.currentRoom.leaderid and true or nil
      self.readyAwayMembers[#self.readyAwayMembers + 1] = member
    end
  end
end

function PvpCustomRoomProxy:StartReadyCoundown(startTime, endTime)
  self:StopReadyCountdown()
  self.readyStartTime = startTime
  self.readyEndTime = endTime
  self.readyCurrentTime = startTime
  self.readyTimeLeft = endTime - startTime
  self.readyLeftTimePercent = 1.0
  self:CopyReadyMembers()
  EventManager.Me():DispatchEvent(CustomRoomEvent.OnReadyStart)
  self.readyCDTicker = TimeTickManager.Me():CreateTick(0, 33, self.UpdateReadyCountdown, self)
end

function PvpCustomRoomProxy:StopReadyCountdown()
  if self.readyCDTicker then
    self.readyCDTicker:Destroy()
    self.readyCDTicker = nil
  end
  self.readyHomeMembers = nil
  self.readyAwayMembers = nil
  self.readyTimeLeft = nil
  self.readyLeftTimePercent = nil
  EventManager.Me():DispatchEvent(CustomRoomEvent.OnReadyEnd)
end

function PvpCustomRoomProxy:UpdateReadyCountdown(deltaTime)
  self.readyCurrentTime = ServerTime.CurClientTime() / 1000
  local duration = self.readyEndTime - self.readyStartTime
  local timeLeft = self.readyEndTime - self.readyCurrentTime
  if timeLeft <= 0 then
    timeLeft = 0
  end
  self.readyTimeLeft = timeLeft
  self.readyLeftTimePercent = timeLeft / duration
  if 0 < timeLeft then
    EventManager.Me():DispatchEvent(CustomRoomEvent.OnReadyUpdate)
  else
    self:StopReadyCountdown()
  end
end

function PvpCustomRoomProxy:IsReadyActive()
  return self.readyTimeLeft and self.readyTimeLeft > 0 or false
end

function PvpCustomRoomProxy:IsOb(charid)
  if self.currentRoom and self.currentRoom:IsOb(charid) then
    return true
  end
  return false
end

function PvpCustomRoomProxy:IsUserReady(id)
  if self.readyHomeMembers then
    for _, v in ipairs(self.readyHomeMembers) do
      if v.id == id then
        return v.prepare
      end
    end
  end
  if self.readyAwayMembers then
    for _, v in ipairs(self.readyAwayMembers) do
      if v.id == id then
        return v.prepare
      end
    end
  end
end

function PvpCustomRoomProxy:IsUserInCurrentRoom(id)
  return self.currentRoom and self.currentRoom:ContainsUser(id) or false
end

local panelTable = {
  [PvpProxy.Type.DesertWolf] = PanelConfig.DesertWolfRoomInfoPopup,
  [PvpProxy.Type.TwelvePVPRelax] = PanelConfig.PvpCustomRoomPopup,
  [PvpProxy.Type.FreeBattle] = PanelConfig.TeamPwsCustomRoomInfoPopup
}

function PvpCustomRoomProxy:OpenRoomInfoPopup()
  local curRoomData = self:GetCurrentRoomData()
  if curRoomData then
    local type = curRoomData.pvptype
    local table = panelTable[type]
    if table then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = table})
    end
  end
end

function PvpCustomRoomProxy:IsInBattle()
  local curRoomData = self:GetCurrentRoomData()
  if curRoomData and curRoomData:IsInBattle() then
    return true
  end
  return false
end

function PvpCustomRoomProxy:QueryCurrentRoomInfoIfNeed()
  local myRoomData = self:GetCurrentRoomData()
  if myRoomData and myRoomData:IsInBattle() and not Game.MapManager:IsPVPRaidMode() then
    ServiceMatchCCmdProxy.Instance:CallReserveRoomInfoMatchCCmd(nil, EmptyTable)
  end
end

function PvpCustomRoomProxy:GetBanCardList()
  local myRoomData = self:GetCurrentRoomData()
  if myRoomData then
    return myRoomData:GetBanCardList()
  end
  return {20001, 20004}
end

function PvpCustomRoomProxy:RecvSyncForbidCardsMessCCmd(data)
  local datas = data.datas
  if datas and 0 < #datas then
    for i = 1, #datas do
      local single = datas[i]
      self.savedBanList[single.eType] = single.forbid_cards
    end
  end
end

function PvpCustomRoomProxy:GetSavedForbidCards(eType)
  if self.savedBanList[eType] then
    xdlog("获取指定副本的预存ban卡列表", eType, #self.savedBanList[eType])
    return self.savedBanList[eType]
  end
  return {}
end
