PvpObserveProxy = class("PvpObserveProxy", pm.Proxy)
PvpObserveProxy.Instance = nil
PvpObserveProxy.NAME = "PvpObserveProxy"
local _FubenCmd = FuBenCmd_pb
PvpObserveProxy.UIType = {
  Crystal = _FubenCmd.ETWELVEPVP_UI_CRYSTAL,
  Item = _FubenCmd.ETWELVEPVP_OBSERVER_UI_ITEM
}
local _debugUIType = {
  [_FubenCmd.ETWELVEPVP_UI_CRYSTAL] = "水晶等级界面",
  [_FubenCmd.ETWELVEPVP_OBSERVER_UI_ITEM] = "观战者查看道具界面"
}
local _TableClear = TableUtility.TableClear
local _ArrayClear = TableUtility.ArrayClear

function PvpObserveProxy:ctor(proxyName, data)
  self.proxyName = proxyName or PvpObserveProxy.NAME
  if PvpObserveProxy.Instance == nil then
    PvpObserveProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
  self.debugEnable = false
end

function PvpObserveProxy:Init()
  self.playerMap = {}
  self.friendCampMap = {}
  self.playerGold = {}
end

function PvpObserveProxy:Reset()
  self.attachId = nil
  self.selectedId = nil
  self.checkingPlayerId = nil
  self.curMode = nil
  _TableClear(self.playerMap)
  _TableClear(self.friendCampMap)
  _TableClear(self.playerGold)
  self:ClearKillNums()
  FunctionPvpObserver.Me():SwitchToTarget(nil)
  FunctionCheck.Me():SetSyncMove(FunctionCheck.CannotSyncMoveReason.AttachOb, true)
end

function PvpObserveProxy:CallAttach(id)
  ServiceFuBenCmdProxy.Instance:CallObserverAttachFubenCmd(id)
end

function PvpObserveProxy:CallSelecte(id)
  ServiceFuBenCmdProxy.Instance:CallObserverSelectFubenCmd(id)
end

function PvpObserveProxy:CallBeginCheckUI(uiType)
  if not self.checkingPlayerId then
    return
  end
  ServiceFuBenCmdProxy.Instance:CallTwelvePvpUIOperCmd(uiType, true)
end

function PvpObserveProxy:CallEndCheckUI(uiType)
  ServiceFuBenCmdProxy.Instance:CallTwelvePvpUIOperCmd(uiType, false)
end

function PvpObserveProxy:HandleModeChanged(on_off)
  if self.running == on_off then
    return
  end
  self.running = on_off
  self:Reset()
  self:_onModeChanged()
end

function PvpObserveProxy:HandleAttach(data)
  local attachID = data.attach_player
  if not attachID then
    return
  end
  if 0 == attachID then
    attachID = nil
    self.selectedId = nil
  end
  local oldAttachPlayerId = self.attachId
  self.attachId = attachID
  if self.checkingPlayerId ~= attachID then
    self.checkingPlayerId = attachID
    self:CheckingPlayerChanged()
  end
  FunctionCheck.Me():SetSyncMove(FunctionCheck.CannotSyncMoveReason.AttachOb, nil == attachID)
  FunctionPvpObserver.Me():SwitchToTarget(attachID)
  GameFacade.Instance:sendNotification(MyselfEvent.ObservationAttachChanged, {oldAttachPlayerId, attachID})
  EventManager.Me():PassEvent(ServiceEvent.FuBenCmdObserverAttachFubenCmd, data)
end

function PvpObserveProxy:HandleRecvSelectedId(data)
  local selectedId = data.select_player
  if not selectedId then
    return
  end
  if 0 == selectedId then
    selectedId = nil
  end
  self.selectedId = selectedId
  local nowCheckId = self.attachId or selectedId
  if self.checkingPlayerId ~= nowCheckId then
    self.checkingPlayerId = nowCheckId
    self:CheckingPlayerChanged()
  end
  EventManager.Me():PassEvent(ServiceEvent.FuBenCmdObserverSelectFubenCmd, data)
end

function PvpObserveProxy:HandleFlashMove(x, y, z)
  MyselfProxy.Instance:ResetMyPos(x, y, z)
end

function PvpObserveProxy:HandleObserverPlayerInfoInit(serverDatas)
  if not serverDatas then
    return
  end
  for i = 1, #serverDatas do
    self:_SetCampPlayerInfo(serverDatas[i])
  end
  NScenePetProxy.Instance:RefreshAllPetCamp()
  GameFacade.Instance:sendNotification(MyselfEvent.ObservationPlayerInited)
  EventManager.Me():PassEvent(ServiceEvent.MatchCCmdObInitInfoFubenCmd, serverDatas)
end

function PvpObserveProxy:CheckingPlayerChanged()
  GameFacade.Instance:sendNotification(MyselfEvent.ObservationGoldUpdate)
  EventManager.Me():PassEvent(MyselfEvent.ObservationGoldUpdate)
  TwelvePvPProxy.Instance:ClearItem()
end

function PvpObserveProxy:TryUpdateCheckPlayerGold(playerId)
  if playerId == self.checkingPlayerId then
    GameFacade.Instance:sendNotification(MyselfEvent.ObservationGoldUpdate)
    EventManager.Me():PassEvent(MyselfEvent.ObservationGoldUpdate)
  end
end

function PvpObserveProxy:SetObGoldMap(charid, value)
  self.playerGold[charid] = value
end

function PvpObserveProxy:HandleObserverPlayerHpSpUpdate(updates)
  if not updates then
    return
  end
  local updatePlayerIds = ReusableTable.CreateArray()
  for i = 1, #updates do
    local charid = updates[i].charid
    if charid then
      local updateInfo = self.playerMap[charid]
      if updateInfo then
        updateInfo:ResetObserverHpSp(updates[i].hpper, updates[i].spper)
        updatePlayerIds[#updatePlayerIds + 1] = charid
      end
    end
  end
  if 0 < #updatePlayerIds then
    GameFacade.Instance:sendNotification(MyselfEvent.ObservationPlayerHpSpUpdate, updatePlayerIds)
    EventManager.Me():PassEvent(MyselfEvent.ObservationPlayerHpSpUpdate, updatePlayerIds)
  end
  ReusableTable.DestroyAndClearArray(updatePlayerIds)
end

function PvpObserveProxy:HandleObPlayerOffline(playerId)
  if not playerId then
    return
  end
  local playerHead = self.playerMap[playerId]
  if playerHead then
    playerHead:SetObserverOfflineFlag()
  end
  GameFacade.Instance:sendNotification(MyselfEvent.ObservationPlayerOffline, playerId)
  EventManager.Me():PassEvent(MyselfEvent.ObservationPlayerOffline, playerId)
end

function PvpObserveProxy:IsInFriendCamp(playerid)
  return self.friendCampMap[playerid] == true
end

function PvpObserveProxy:_SetCampPlayerInfo(info)
  local playerid = info.charid
  if not playerid then
    return
  end
  local isFriend = not Game.MapManager:IsPVPMode_3Teams() and info.camp == FuBenCmd_pb.EGROUPCAMP_RED
  self.friendCampMap[playerid] = isFriend
  self:SetCamp(playerid, isFriend)
  EventManager.Me():PassEvent(MyselfEvent.ObservationAddPlayer, {playerid, isFriend})
  local player = self.playerMap[playerid]
  if player then
    player:TransByObserverPlayerData(info)
  else
    local headData = HeadImageData.new()
    headData:TransByObserverPlayerData(info)
    self.playerMap[playerid] = headData
  end
end

function PvpObserveProxy:SetCamp(playerid, isFriend)
  local nSceneUserProxy = NSceneUserProxy.Instance
  local player = nSceneUserProxy:Find(playerid)
  if not player then
    return
  end
  player.data:Camp_SetIsInMyTeam(isFriend)
end

function PvpObserveProxy:HandleRaidKillSync(data)
  if not data or not data.kill_nums then
    return
  end
  if not self.killNums then
    self.killNums = {}
  end
  for _, v in ipairs(data.kill_nums) do
    self.killNums[v.camp] = v.kill_num
  end
  EventManager.Me():PassEvent(ServiceEvent.FuBenCmdRaidKillNumSyncCmd)
end

function PvpObserveProxy:GetKillNum(camp)
  if not self.killNums then
    return 0
  end
  return self.killNums[camp] or 0
end

function PvpObserveProxy:ClearKillNums()
  self.killNums = nil
end

function PvpObserveProxy:_onModeChanged()
  if self.running then
    FunctionSystem.InterruptMyselfAll()
  end
  InputJoystickProcesser.ForceInivisble = self.running
end

function PvpObserveProxy:TryBeGhost()
  self:CallAttach(nil)
  self:CallSelecte(nil)
end

function PvpObserveProxy:BeGhost()
  local oldAttachPlayerId = self.attachId
  self.attachId = nil
  GameFacade.Instance:sendNotification(MyselfEvent.ObservationAttachChanged, {oldAttachPlayerId})
  self.checkingPlayerId = nil
  self.selectedId = nil
end

function PvpObserveProxy:ObserverFlash(x, y, z)
  if not self:IsRunning() then
    return false
  end
  ServiceFuBenCmdProxy.Instance:CallObserverFlashFubenCmd(x, y, z)
  return true
end

function PvpObserveProxy:TryAttach(guid)
  self:CallAttach(guid)
end

function PvpObserveProxy:TrySelect(guid)
  self:CallSelecte(guid)
  EventManager.Me():PassEvent(MyselfEvent.ObservationSelectPlayer, guid)
end

function PvpObserveProxy:Debug(...)
  if self.debugEnable then
    helplog(...)
  end
end

function PvpObserveProxy:IsRunning()
  return self.running == true
end

function PvpObserveProxy:GetCheckingPlayerId()
  return self.checkingPlayerId
end

function PvpObserveProxy:GetAttachPlayer()
  return self.attachId
end

function PvpObserveProxy:IsAttachingPlayer(id)
  return self:IsRunning() and self.attachId and self.attachId == id
end

function PvpObserveProxy:GetSelectPlayer()
  return self.selectedId
end

function PvpObserveProxy:GetPlayerDataByCamp(camp)
  local datas = {}
  for _, v in pairs(self.playerMap) do
    if camp == v.camp then
      datas[#datas + 1] = v
    end
  end
  return datas
end

function PvpObserveProxy:IsAttaching()
  return self:IsRunning() and nil ~= self.attachId
end

function PvpObserveProxy:IsChecking()
  return self:IsRunning() and nil ~= self.checkingPlayerId
end

function PvpObserveProxy:IsGhost()
  return self:IsRunning() and nil == self.attachId
end

function PvpObserveProxy:GetPlayerDataById(guid)
  return self.playerMap[guid]
end

function PvpObserveProxy:GetCheckingPlayerGold()
  if self:IsChecking() then
    return self.playerGold[self.checkingPlayerId] or 0
  end
  return 0
end
