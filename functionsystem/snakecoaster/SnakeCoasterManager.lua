SnakeCoasterManager = class("SnakeCoasterManager", EventDispatcher)
local DefaultCoasterNpcID = 2000000
local LocalCoasterNpcUniqueIDBase = 2100000000
local RemoteCoasterNpcUniqueIDBase = 2110000000
local DefaultLaneHalfWidth = 3
local DefaultLateralSpeed = 3
local DefaultNormalScore = 50
local DefaultPerfectScore = 100
local SnakeCoasterState = ESNAKECOASTERSTATE

function SnakeCoasterManager.Me()
  if nil == SnakeCoasterManager.me then
    SnakeCoasterManager.me = SnakeCoasterManager.new()
  end
  return SnakeCoasterManager.me
end

function SnakeCoasterManager:ctor()
  self:Init()
end

function SnakeCoasterManager:Init()
  self.currentCoasterInfo = nil
  self.localCoasterNpc = nil
  self.localCoasterNpcUniqueID = nil
  self.localCoasterNpcID = nil
  self.remoteCoasterNpcMap = {}
  self.remoteCoasterNpcUniqueIDMap = {}
  self.remoteCoasterNpcNextIndex = 0
  self.serverInfos = {}
  self.serverInfoMap = {}
  self.serverRecord = nil
  self.serverFinishData = nil
  self.currentDifficulty = nil
  self.currentEndTime = nil
  self.gameState = nil
  self.finishSubmitted = false
  self.serverEventListening = false
  self:_AddServerEventListeners()
end

function SnakeCoasterManager:Shutdown()
  local myself = Game.Myself
  if myself.snakeCoasterMove ~= nil then
    myself:ClearSnakeCoasterGame()
  else
    self:DestroyLocalCoasterNpc()
  end
  self:DestroyAllRemoteCoasterNpc()
  self.currentCoasterInfo = nil
  self.gameState = nil
end

function SnakeCoasterManager:_AddServerEventListeners()
  if self.serverEventListening then
    return
  end
  self.serverEventListening = true
end

function SnakeCoasterManager:_GetServerData(note)
  return note and note.body or note
end

function SnakeCoasterManager:_GetCoasterInfoByMapID(mapID, coasterID)
  local staticData = mapID and Table_Map[mapID] or nil
  if staticData == nil then
    return nil
  end
  local sceneInfo = autoImport("Scene_" .. staticData.NameEn)
  if sceneInfo == nil then
    return nil
  end
  return sceneInfo.Coasters and sceneInfo.Coasters[coasterID] or nil
end

function SnakeCoasterManager:RefreshCoasterInfo(coasterID)
  local mapID = SceneProxy.Instance:GetCurMapID() or nil
  self.currentCoasterInfo = self:_GetCoasterInfoByMapID(mapID, coasterID)
  return self.currentCoasterInfo
end

function SnakeCoasterManager:GetCoasterInfo(difficulty)
  if self.currentCoasterInfo ~= nil then
    return self.currentCoasterInfo
  end
  return self:RefreshCoasterInfo(difficulty)
end

function SnakeCoasterManager:GetCoasterRoadPoints(difficulty)
  local coaster = self:GetCoasterInfo(difficulty)
  return coaster and coaster.CoasterRoadPoints or nil
end

function SnakeCoasterManager:GetCoasterRoadPointMap(difficulty)
  local coaster = self:GetCoasterInfo(difficulty)
  return coaster and coaster.coasterRoadPointMap or nil
end

function SnakeCoasterManager:FindCoasterRoadPoint(difficulty, ID)
  local map = self:GetCoasterRoadPointMap(difficulty)
  return map and map[ID] or nil
end

function SnakeCoasterManager:GetCoasterCheckPoints(difficulty)
  local coaster = self:GetCoasterInfo(difficulty)
  return coaster and coaster.CoasterCheckPoints or nil
end

function SnakeCoasterManager:GetCoasterCheckPointGroups(difficulty)
  local coaster = self:GetCoasterInfo(difficulty)
  return coaster and coaster.coasterCheckPointGroups or nil
end

function SnakeCoasterManager:GetCoasterCheckPointGroup(difficulty, groupID)
  local groups = self:GetCoasterCheckPointGroups(difficulty)
  return groups and groups[groupID] or nil
end

function SnakeCoasterManager:GetRuntimeConfig(difficulty)
  local snakeCoasterConfig = GameConfig.SnakeCoaster
  if snakeCoasterConfig == nil then
    return nil
  end
  local defaultDifficulty = snakeCoasterConfig.DefaultDifficulty or 1
  return self:GetDifficultyConfig(difficulty or self.currentDifficulty or defaultDifficulty)
end

function SnakeCoasterManager:GetCurrentDifficulty()
  return self.currentDifficulty
end

function SnakeCoasterManager:GetDifficultyConfig(difficulty)
  local snakeCoasterConfig = GameConfig.SnakeCoaster
  local difficulties = snakeCoasterConfig and snakeCoasterConfig.Difficulties or nil
  if difficulties == nil or difficulty == nil then
    return nil
  end
  return difficulties[difficulty] or difficulties[tostring(difficulty)]
end

function SnakeCoasterManager:GetDefaultCoasterNpcID()
  return DefaultCoasterNpcID
end

function SnakeCoasterManager:GetLocalCoasterNpc()
  return self.localCoasterNpc
end

function SnakeCoasterManager:_BuildLocalCoasterNpcUniqueID(coasterID)
  local numericCoasterID = coasterID or 0
  return LocalCoasterNpcUniqueIDBase + numericCoasterID
end

function SnakeCoasterManager:_BuildRemoteCoasterNpcUniqueID(ownerID)
  local uniqueID = self.remoteCoasterNpcUniqueIDMap[ownerID]
  if uniqueID ~= nil then
    return uniqueID
  end
  self.remoteCoasterNpcNextIndex = self.remoteCoasterNpcNextIndex + 1
  uniqueID = RemoteCoasterNpcUniqueIDBase + self.remoteCoasterNpcNextIndex
  self.remoteCoasterNpcUniqueIDMap[ownerID] = uniqueID
  return uniqueID
end

function SnakeCoasterManager:_CreateCoasterNpc(uniqueID, npcID, position, dir)
  if uniqueID == nil or position == nil or NSceneNpcProxy.Instance == nil then
    return nil
  end
  npcID = npcID or DefaultCoasterNpcID
  local posX = position[1] or 0
  local posY = position[2] or 0
  local posZ = position[3] or 0
  local clientData = NpcData.CreateClientData({
    ID = npcID,
    guid = uniqueID,
    uniqueID = uniqueID,
    position = {
      posX,
      posY,
      posZ
    },
    dir = dir
  })
  if clientData == nil then
    return nil
  end
  autoImport("NCoasterNpc")
  local coasterNpc = NCoasterNpc.CreateAsTable(clientData)
  NSceneNpcProxy.Instance:AddClientNpc(coasterNpc, true)
  return coasterNpc
end

function SnakeCoasterManager:DestroyLocalCoasterNpc()
  local localCoasterNpc = self.localCoasterNpc
  local uniqueID = self.localCoasterNpcUniqueID
  if uniqueID ~= nil and NSceneNpcProxy.Instance ~= nil then
    if localCoasterNpc == nil then
      localCoasterNpc = NSceneNpcProxy.Instance:GetClientNpc(uniqueID)
    end
    NSceneNpcProxy.Instance:RemoveFromClientMap(uniqueID)
  end
  if localCoasterNpc ~= nil then
    localCoasterNpc:Destroy()
  end
  self.localCoasterNpc = nil
  self.localCoasterNpcUniqueID = nil
  self.localCoasterNpcID = nil
end

function SnakeCoasterManager:CreateLocalCoasterNpc(coasterID, npcID, position, dir)
  if position == nil or NSceneNpcProxy.Instance == nil then
    return nil
  end
  npcID = npcID or DefaultCoasterNpcID
  local uniqueID = self:_BuildLocalCoasterNpcUniqueID(coasterID)
  self:DestroyLocalCoasterNpc()
  local localCoasterNpc = self:_CreateCoasterNpc(uniqueID, npcID, position, dir)
  if localCoasterNpc == nil then
    return nil
  end
  self.localCoasterNpc = localCoasterNpc
  self.localCoasterNpcUniqueID = uniqueID
  self.localCoasterNpcID = npcID
  return localCoasterNpc
end

function SnakeCoasterManager:DestroyRemoteCoasterNpc(ownerID)
  if ownerID == nil then
    return
  end
  local remoteCoasterNpc = self.remoteCoasterNpcMap[ownerID]
  local uniqueID = self.remoteCoasterNpcUniqueIDMap[ownerID]
  if uniqueID ~= nil and NSceneNpcProxy.Instance ~= nil then
    if remoteCoasterNpc == nil then
      remoteCoasterNpc = NSceneNpcProxy.Instance:GetClientNpc(uniqueID)
    end
    NSceneNpcProxy.Instance:RemoveFromClientMap(uniqueID)
  end
  if remoteCoasterNpc ~= nil then
    remoteCoasterNpc:Destroy()
  end
  self.remoteCoasterNpcMap[ownerID] = nil
  self.remoteCoasterNpcUniqueIDMap[ownerID] = nil
end

function SnakeCoasterManager:DestroyAllRemoteCoasterNpc()
  local ownerIDs = {}
  for ownerID, _ in pairs(self.remoteCoasterNpcUniqueIDMap) do
    ownerIDs[#ownerIDs + 1] = ownerID
  end
  for i = 1, #ownerIDs do
    self:DestroyRemoteCoasterNpc(ownerIDs[i])
  end
end

function SnakeCoasterManager:CreateRemoteCoasterNpc(ownerID, npcID, position, dir)
  if ownerID == nil or position == nil or NSceneNpcProxy.Instance == nil then
    return nil
  end
  self:DestroyRemoteCoasterNpc(ownerID)
  local uniqueID = self:_BuildRemoteCoasterNpcUniqueID(ownerID)
  local remoteCoasterNpc = self:_CreateCoasterNpc(uniqueID, npcID, position, dir)
  if remoteCoasterNpc == nil then
    self.remoteCoasterNpcUniqueIDMap[ownerID] = nil
    return nil
  end
  self.remoteCoasterNpcMap[ownerID] = remoteCoasterNpc
  return remoteCoasterNpc
end

function SnakeCoasterManager:StartCoasterGame(difficulty)
  local snakeCoasterConfig = GameConfig.SnakeCoaster
  if snakeCoasterConfig == nil then
    return false
  end
  difficulty = difficulty or self.currentDifficulty or snakeCoasterConfig.DefaultDifficulty or 1
  local difficultyConfig = self:GetRuntimeConfig(difficulty)
  if difficultyConfig == nil then
    return false
  end
  self.currentDifficulty = difficulty
  local player = Game.Myself
  local nowMapId = SceneProxy.Instance:GetCurMapID()
  local staticData = Table_Map[nowMapId]
  if staticData == nil then
    return false
  end
  local coasterInfo = self:GetCoasterInfo(difficulty)
  if coasterInfo == nil then
    return false
  end
  local paths = coasterInfo.CoasterRoadPoints
  if paths == nil or #paths == 0 then
    return false
  end
  local coasterMove = player:CreateSnakeCoasterGame()
  if not coasterMove then
    return false
  end
  local curPos = player:GetPosition()
  if curPos == nil then
    return false
  end
  local startPos = difficultyConfig.StartPos
  local originPos = startPos or curPos
  local moveSpeed = player.logicTransform:GetMoveSpeed()
  if moveSpeed <= 0 then
    moveSpeed = 1
  end
  local coasterNpcID = difficultyConfig.CoasterNpcID or self:GetDefaultCoasterNpcID()
  local configMoveSpeed = difficultyConfig.MoveSpeed or 0
  local laneHalfWidth = difficultyConfig.LaneHalfWidth or DefaultLaneHalfWidth
  local lateralSpeed = difficultyConfig.LateralSpeed or DefaultLateralSpeed
  local normalScore = difficultyConfig.NormalScore or DefaultNormalScore
  local perfectScore = difficultyConfig.PerfectScore or DefaultPerfectScore
  local cameraParams = snakeCoasterConfig.CameraParams or {}
  local cameraBackTraceDistance = cameraParams.BackTraceDistance or 3
  local cameraBackTracePitch = cameraParams.BackTracePitch or 10
  local cameraBackTraceFollowLerpTime = cameraParams.BackTraceFollowLerpTime or 0.08
  local cameraBackTraceSwitchDuration = cameraParams.BackTraceSwitchDuration or 0.08
  local cameraBackTraceFocusDistance = cameraParams.BackTraceFocusDistance or 5
  local cameraBackTraceFocusHeight = cameraParams.BackTraceFocusHeight or 1
  local cameraLookUpHeight = cameraParams.LookUpHeight or 0
  local cameraLockBehind = cameraParams.LockBehind or false
  local cameraLockBehindPitch = cameraParams.LockBehindPitch or 20
  local cameraLockBehindDistance = cameraParams.LockBehindDistance or 8
  FunctionSystem.InterruptMyselfAll()
  coasterMove:Reset()
  if startPos ~= nil then
    player:Client_PlaceTo(LuaVector3.New(startPos[1] or 0, startPos[2] or 0, startPos[3] or 0), true)
  end
  local roadPoints = {}
  roadPoints[1] = {
    ID = 0,
    position = {
      originPos[1] or 0,
      originPos[2] or 0,
      originPos[3] or 0
    }
  }
  for i = 1, #paths do
    roadPoints[#roadPoints + 1] = paths[i]
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.MiniGameSnakeCoasterPage
  })
  local ret = coasterMove:Launch({
    coasterID = difficulty,
    coasterNpcID = coasterNpcID,
    roadPoints = roadPoints,
    moveSpeed = 0 < configMoveSpeed and configMoveSpeed or moveSpeed,
    laneHalfWidth = laneHalfWidth,
    lateralSpeed = lateralSpeed,
    normalScore = normalScore,
    perfectScore = perfectScore,
    cameraBackTraceDistance = cameraBackTraceDistance,
    cameraBackTracePitch = cameraBackTracePitch,
    cameraBackTraceFollowLerpTime = cameraBackTraceFollowLerpTime,
    cameraBackTraceSwitchDuration = cameraBackTraceSwitchDuration,
    cameraBackTraceFocusDistance = cameraBackTraceFocusDistance,
    cameraBackTraceFocusHeight = cameraBackTraceFocusHeight,
    cameraLookUpHeight = cameraLookUpHeight
  })
  if not ret then
    self:ClearCoasterGame()
  end
  return ret
end

function SnakeCoasterManager:TestStartCoasterGame(difficulty)
  local ret = self:StartCoasterGame(difficulty or 1)
  if ret then
    self.gameState = SnakeCoasterState.ESNAKECOASTER_STATE_RUNNING
    self.finishSubmitted = false
    EventManager.Me():PassEvent(SnakeCoasterEvent.InnerGameStart)
  end
  return ret
end

function SnakeCoasterManager:RequestServerInfo()
  ServiceSceneUser3Proxy.Instance:CallSnakeCoasterInfoCmd()
end

function SnakeCoasterManager:RequestServerStart(difficulty)
  if difficulty == nil then
    return false
  end
  ServiceSceneUser3Proxy.Instance:CallSnakeCoasterStartCmd(difficulty)
  return true
end

function SnakeCoasterManager:QuitCoasterGame()
  self:ClearCoasterGame()
  ServiceSceneUser3Proxy.Instance:CallSnakeCoasterLeaveCmd()
end

function SnakeCoasterManager:SubmitServerFinish(score)
  if self.gameState ~= SnakeCoasterState.ESNAKECOASTER_STATE_RUNNING or self.finishSubmitted then
    return false
  end
  self.finishSubmitted = true
  ServiceSceneUser3Proxy.Instance:CallSnakeCoasterFinishCmd(nil, score)
  return true
end

function SnakeCoasterManager:OnLocalCoasterFinish(score)
  return self:SubmitServerFinish(score)
end

function SnakeCoasterManager:IsServerGameRunning()
  return self.gameState == SnakeCoasterState.ESNAKECOASTER_STATE_RUNNING
end

function SnakeCoasterManager:GetGameState()
  return self.gameState
end

function SnakeCoasterManager:GetServerInfos()
  return self.serverInfos
end

function SnakeCoasterManager:GetServerInfo(difficulty)
  return self.serverInfoMap[difficulty]
end

function SnakeCoasterManager:GetServerRecord()
  return self.serverRecord
end

function SnakeCoasterManager:HandleSnakeCoasterInfoCmd(note)
  local data = self:_GetServerData(note)
  if data == nil then
    return
  end
  self.serverInfos = data.infos or {}
  TableUtility.TableClear(self.serverInfoMap)
  for i = 1, #self.serverInfos do
    local info = self.serverInfos[i]
    if info ~= nil and info.difficulty ~= nil then
      self.serverInfoMap[info.difficulty] = info
    end
  end
  self.serverRecord = data.record
  GameFacade.Instance:sendNotification(SnakeCoasterEvent.InfoUpdate, data)
end

function SnakeCoasterManager:HandleSnakeCoasterStateNtf(note)
  local data = self:_GetServerData(note)
  if data == nil then
    return
  end
  self.gameState = data.state
  self.currentDifficulty = data.difficulty or self.currentDifficulty
  self.currentEndTime = data.endtime
  self.finishSubmitted = false
  GameFacade.Instance:sendNotification(SnakeCoasterEvent.StateUpdate, data)
  xdlog(string.format("CoasterGameStateNtf: %d", data.state))
  if data.state == SnakeCoasterState.ESNAKECOASTER_STATE_WAIT then
    self:StartCoasterGame(self.currentDifficulty)
  elseif data.state == SnakeCoasterState.ESNAKECOASTER_STATE_RUNNING then
    EventManager.Me():PassEvent(SnakeCoasterEvent.InnerGameStart)
  elseif data.state == SnakeCoasterState.ESNAKECOASTER_STATE_FAIL then
    self:ClearCoasterGame()
  elseif data.state == SnakeCoasterState.ESNAKECOASTER_STATE_EXIT then
    self:ClearCoasterGame()
    ServiceSceneUser3Proxy.Instance:CallSnakeCoasterLeaveCmd()
  end
end

function SnakeCoasterManager:HandleSnakeCoasterFinishCmd(note)
  local data = self:_GetServerData(note)
  if data == nil then
    return
  end
  self.serverFinishData = data
  self.gameState = SnakeCoasterState.ESNAKECOASTER_STATE_FINISH
  if data.record ~= nil then
    self.serverRecord = data.record
  end
end

function SnakeCoasterManager:ClearCoasterGame()
  Game.Myself:ClearSnakeCoasterGame()
  self.currentCoasterInfo = nil
  self.gameState = nil
end
