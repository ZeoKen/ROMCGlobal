autoImport("Table_RaidRoom")
autoImport("Table_RaidPushArea")
autoImport("Table_RaidPushAreaObj")
autoImport("RaidPuzzleFun")
autoImport("PushableObjLimitCell")
autoImport("TweenUtility")
RaidPuzzleManager = class("RaidPuzzleManager", EventDispatcher)
RaidPuzzleManager.DebugMode = false
RaidPuzzleManager.RoomTweenDuration = 3

function RaidPuzzleManager.Me()
  if nil == RaidPuzzleManager.me then
    RaidPuzzleManager.me = RaidPuzzleManager.new()
  end
  return RaidPuzzleManager.me
end

function RaidPuzzleManager:ctor()
  self:Init()
end

RaidPuzzleManager.E_RoomStatus = {
  Disable = 1,
  Lock = 2,
  Unlock = 3,
  Passed = 4
}
local _Game = Game
local _VectorUtility = VectorUtility
local _LuaGeometry = LuaGeometry
local _NSceneNpcProxy = NSceneNpcProxy
local _math = math
local _GameFacade = GameFacade
local _TableUtility = TableUtility
local m_updateRoomInterval = 0.1
local m_updateLightInterval = 0.21
local m_baseHeight = 0.1
local m_sendQuestInterval = 10000
local m_pushHalfAngle = 80
local m_pushObjRange = 1
local E_pushNoLimit = 999
local m_objRotateDirections = {
  45,
  135,
  225,
  315
}
local m_updateFunctionInterval = 0.05
local m_updateFunctionNames = {
  "UpdateElevator",
  "UpdateTargetPushableObject",
  "UpdateNpcMoveQuest"
}
local E_TimeTickIDRange = {Torch = 1000, Normal = 3000}
local RotateSkinNameMap = GameConfig.RaidPuzzle.RotateSkinNameMap
RotateSkinNameMap = RotateSkinNameMap or {
  [2200] = "may_1F_jz_a"
}

function RaidPuzzleManager:Init()
  self.objRoomsMap = {}
  self.rendererCtrl_Diss = {}
  self.rendererCtrl_Transparent = {}
  self.roomAreaMap = {}
  self.unlockRoomMap = {}
  self.passedRoomMap = {}
  self.areaObjMap = {}
  self.objAreaRecordMap = {}
  self.objRowRecordMap = {}
  self.objColRecordMap = {}
  self.forbidLightMap = {}
  self.refreshLightArray = {}
  self.roomDarkMaskMap = {}
  self.checkEnterRoomQuestMap = {}
  self.checkExitRoomQuestMap = {}
  self.checkLightQuestMap = {}
  self.checkPushObjResultMap = {}
  self.checkTorchObjList = {}
  self.checkNpcMoveQuestMap = {}
  self.fakeObstacleMap = {}
  self.disableMoveMap = {}
  self.objPushWaitSendMap = {}
  self.pushLimitCells = {}
  self.pushLimitClientRecord = {}
  self.checkSyncTag = {
    light = {}
  }
  self.npcLoadMap = {}
  self.objPosTweenerMap = {}
  self.objRotateTweenerMap = {}
  self.sendQuestMap = {}
  self.nextUpdateRoomTime = 0
  self.nextUpdateLightTime = 0
  self.nextUpdateFunctionTime = 0
  self.updateFunctionIndex = 0
end

function RaidPuzzleManager:Launch()
  self.raidID = _Game.MapManager:GetRaidID()
  if self.raidID == 0 then
    self.raidID = _Game.MapManager:GetImageID()
  end
  local l_raidData = self.raidID and Table_MapRaid[self.raidID]
  local l_raidFeature = l_raidData and l_raidData.Feature
  if not l_raidFeature or l_raidFeature & MapManager.MapRaidFeature.IsRaidPuzzle < 1 then
    return
  end
  if not self:InitRaidPushAreas() then
    return
  end
  if self:IsWorking() then
    return
  end
  EventManager.Me():AddEventListener(ServiceEvent.ConnReconnect, RaidPuzzleManager.HandleReconnect, self)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddNpcs, RaidPuzzleManager.HandleAddNpcs, self)
  self.running = true
  local hideMayPalace = self:GetRaidConfig("HideMayPalace")
  if not hideMayPalace then
    _GameFacade.Instance:sendNotification(PVEEvent.RaidPuzzle_Launch)
    EventManager.Me():PassEvent(PVEEvent.RaidPuzzle_Launch)
  end
end

function RaidPuzzleManager:Shutdown()
  if not self:IsWorking() then
    return
  end
  self.running = false
  _GameFacade.Instance:sendNotification(PVEEvent.RaidPuzzle_Shutdown)
  EventManager.Me():PassEvent(PVEEvent.RaidPuzzle_Shutdown)
  EventManager.Me():RemoveEventListener(ServiceEvent.ConnReconnect, RaidPuzzleManager.HandleReconnect, self)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddNpcs, RaidPuzzleManager.HandleAddNpcs, self)
  self:ClearRaidDatas()
  _GameFacade.Instance:sendNotification(InteractNpcEvent.PushableTargetChange, false)
end

function RaidPuzzleManager:IsWorking()
  return self.running == true
end

function RaidPuzzleManager:InitRaidPushAreas()
  self.raidConfig = GameConfig.RaidPuzzle and GameConfig.RaidPuzzle[self.raidID]
  self.raidPublicConfig = GameConfig.RaidPuzzle and GameConfig.RaidPuzzle.Public
  self.raidRooms = Table_RaidRoom[self.raidID]
  if not self.raidRooms then
    LogUtility.Error("Cannot Find Rooms with raidId " .. self.raidID)
    return false
  end
  self.objRaidRoomRoot = GameObject.Find("RaidRoomRoot")
  local l_cfgInitialRooms = self:GetRaidConfig("InitialRooms")
  local l_objHelper
  for roomID, roomData in pairs(self.raidRooms) do
    local objRoom = _Game.GameObjectUtil:DeepFind(self.objRaidRoomRoot, tostring(roomID))
    if objRoom then
      self.objRoomsMap[roomID] = objRoom
      l_objHelper = _Game.GameObjectUtil:DeepFind(objRoom, "Lit_DissHelper")
      self.rendererCtrl_Diss[roomID] = l_objHelper and l_objHelper:GetComponent(RendererPropertyHelper)
      l_objHelper = _Game.GameObjectUtil:DeepFind(objRoom, "TransparentHelper")
      self.rendererCtrl_Transparent[roomID] = l_objHelper and l_objHelper:GetComponent(RendererPropertyHelper)
      if l_cfgInitialRooms and _TableUtility.ArrayFindIndex(l_cfgInitialRooms, roomID) > 0 then
        self.unlockRoomMap[roomID] = roomData
      elseif not self.unlockRoomMap[roomID] then
        objRoom:SetActive(false)
      end
    else
      LogUtility.Error("Cannot Find Room " .. roomID)
    end
  end
  self.raidAreaMap = Table_RaidPushArea[self.raidID]
  if not self.raidAreaMap then
    LogUtility.Error("Cannot Find AreaMap with raidId " .. self.raidID)
    return false
  end
  if self.raidAreaMap then
    local areaMap
    for areaID, areaData in pairs(self.raidAreaMap) do
      areaMap = self.roomAreaMap[areaData.RoomID] or {}
      areaMap[areaID] = areaData
      self.roomAreaMap[areaData.RoomID] = areaMap
      self.areaObjMap[areaID] = {}
    end
  end
  self.pushObjCfgMap = Table_RaidPushAreaObj[self.raidID]
  self.tsfFakeObstacleRoot = self:FindOrCreateTransform("FakeObstacleRoot")
  m_pushHalfAngle = self:GetRaidConfig("PushObjAngle", 30) / 2
  m_pushObjRange = self:GetRaidConfig("PushObjRange", 1)
  self.mapScale = self:GetRaidConfig("MapScale", 1)
  self.cfgNpcCanBlockLight = self:GetRaidConfig("NpcCanBlockLight")
  RaidPuzzleFun.SetRaidID(self.raidID, self.mapScale)
  return true
end

function RaidPuzzleManager:ClearRaidDatas()
  self.raidRooms = nil
  self.raidAreaMap = nil
  self.pushObjCfgMap = nil
  self.isMiniMapAllUnlock = nil
  self.tsfFakeObstacleRoot = nil
  self.curRoomID = nil
  self.curRoomData = nil
  self.targetPushableObject = nil
  self.curElevatorInfo = nil
  self.isOnElevator = nil
  self.isInElevatorArea = nil
  self.isPushingObject = false
  self:DisableMove(nil, false)
  _TableUtility.TableClear(self.fakeObstacleMap)
  _TableUtility.TableClear(self.rendererCtrl_Diss)
  _TableUtility.TableClear(self.rendererCtrl_Transparent)
  _TableUtility.TableClear(self.roomAreaMap)
  _TableUtility.TableClear(self.areaObjMap)
  _TableUtility.TableClear(self.objAreaRecordMap)
  _TableUtility.TableClear(self.objRowRecordMap)
  _TableUtility.TableClear(self.objColRecordMap)
  _TableUtility.TableClear(self.unlockRoomMap)
  _TableUtility.TableClear(self.passedRoomMap)
  _TableUtility.TableClear(self.roomDarkMaskMap)
  _TableUtility.TableClear(self.checkTorchObjList)
  _TableUtility.TableClear(self.npcLoadMap)
  _TableUtility.TableClear(self.objPosTweenerMap)
  _TableUtility.TableClear(self.objRotateTweenerMap)
  _TableUtility.TableClear(self.forbidLightMap)
  _TableUtility.TableClear(self.refreshLightArray)
  _TableUtility.TableClear(self.objRoomsMap)
  _TableUtility.TableClear(self.pushLimitClientRecord)
  self:ClearPushLimitCells()
  for index, pbData in pairs(self.objPushWaitSendMap) do
    ReusableTable.DestroyAndClearTable(pbData)
  end
  _TableUtility.TableClear(self.objPushWaitSendMap)
  self:ClearQuestMap()
  self:RefreshDarkMask()
  self:RefreshRoomCameraFilter()
  TimeTickManager.Me():ClearTick(self)
end

function RaidPuzzleManager:ClearQuestMap()
  _TableUtility.TableClear(self.checkEnterRoomQuestMap)
  _TableUtility.TableClear(self.checkExitRoomQuestMap)
  _TableUtility.TableClear(self.checkLightQuestMap)
  _TableUtility.TableClear(self.checkSyncTag.light)
  _TableUtility.TableClear(self.checkPushObjResultMap)
  _TableUtility.TableClear(self.checkNpcMoveQuestMap)
  _TableUtility.TableClear(self.sendQuestMap)
end

function RaidPuzzleManager:RemoveQuestTrigger(questData)
  local questID = questData and questData.id
  if not questID then
    return
  end
  self.checkEnterRoomQuestMap[questID] = nil
  self.checkExitRoomQuestMap[questID] = nil
  self.checkLightQuestMap[questID] = nil
  self.checkSyncTag.light[questID] = nil
  self.checkPushObjResultMap[questID] = nil
  self.checkNpcMoveQuestMap[questID] = nil
  self.sendQuestMap[questID] = nil
end

function RaidPuzzleManager:HandleReconnect()
  self:ClearQuestMap()
  for areaID, areaMap in pairs(self.areaObjMap) do
    _TableUtility.TableClear(areaMap)
  end
  for npcID, objFakeObstacle in pairs(self.fakeObstacleMap) do
    LuaGameObject.DestroyObject(objFakeObstacle)
  end
  _TableUtility.TableClear(self.fakeObstacleMap)
end

function RaidPuzzleManager:HandleAddNpcs(npcList)
  for i = 1, #npcList do
    if npcList[i].data:GetPushableObjID() then
      self:AddPushObject(npcList[i])
    end
  end
end

function RaidPuzzleManager:HandlePuzzleObjChange(ids)
  if not ids or not self:IsWorking() then
    return
  end
  local refreshNpcMap = ReusableTable.CreateTable()
  local singleNpc
  for i = 1, #ids do
    singleNpc = _NSceneNpcProxy.Instance:Find(ids[i])
    if singleNpc then
      refreshNpcMap[ids[i]] = singleNpc
    else
      redlog("HandlePuzzleObjChange: Cannot find npc by guid", tostring(ids[i]))
    end
  end
  local areaID, areaData, curRow, curCol
  for guid, npc in pairs(refreshNpcMap) do
    areaID, curRow, curCol = self:GetObjAreaInfo(npc.data.id)
    areaData = self.raidAreaMap[areaID]
    if curRow and curCol and areaData then
      self.areaObjMap[areaID][curRow * areaData.Col + curCol] = nil
    end
  end
  local position, targetCellIndex
  for guid, npc in pairs(refreshNpcMap) do
    areaID = npc.data.pushStaticData and npc.data.pushStaticData.AreaID
    areaData = self.raidAreaMap[areaID]
    if areaData then
      curRow, curCol = self:PosXZToAreaRowAndCol(areaID, npc.data.pushStaticData.PosX, npc.data.pushStaticData.PosZ)
      curRow = self:ClampRow(curRow, npc.data, areaData, true)
      curCol = self:ClampCol(curCol, npc.data, areaData, true)
      targetCellIndex = curRow * areaData.Col + curCol
      if self.areaObjMap[areaID][targetCellIndex] then
        self:RecordObjAreaInfo(npc.data.id, areaID)
        LogUtility.Error(string.format("Canot put obj into grid! Target cell is not empty! Obj ID: %s, guid: %s, target cell guid: %s", npc.data:GetPushableObjID(), npc.data.id, self.areaObjMap[areaID][targetCellIndex]))
      else
        self:RecordObjAreaInfo(npc.data.id, areaID, curRow, curCol)
        self.areaObjMap[areaID][targetCellIndex] = npc.data.id
      end
      position = _LuaGeometry.GetTempVector3(npc.data.pushStaticData.PosX, npc:GetPosition()[2], npc.data.pushStaticData.PosZ)
      if npc.assetRole.completeTransform then
        npc.assetRole.completeTransform.position = position
      end
      npc.logicTransform:PlaceTo(position)
      self:PlaceFakeObstacle(npc, position)
    end
  end
  ReusableTable.DestroyAndClearTable(refreshNpcMap)
end

function RaidPuzzleManager:RecvRaidPuzzleDataUpdateRaidCmd(serverData)
  local curMaskPercent = self.roomDarkMaskMap[self.curRoomID]
  local roomStatusChanged = false
  local roomInfoNeedRefresh = false
  local roomInfoDescRefresh = false
  local updates = serverData.updates
  local singleData
  for i = 1, #updates do
    singleData = updates[i]
    if singleData.type == RaidCmd_pb.ERAIDPUZZLEDATA_ROOM then
      local rooms = singleData.rooms
      for i = 1, #rooms do
        if not self.unlockRoomMap[rooms[i].roomid] then
          self:SetRoomUnlock(rooms[i].roomid)
          roomStatusChanged = true
        end
        self.roomDarkMaskMap[rooms[i].roomid] = rooms[i].mask / 100
        if self.passedRoomMap[rooms[i].roomid] ~= rooms[i].passed then
          self.passedRoomMap[rooms[i].roomid] = rooms[i].passed
          roomStatusChanged = true
        end
      end
    elseif singleData.type == RaidCmd_pb.ERAIDPUZZLEDATA_MINIMAP_UNLOCK then
      self.isMiniMapAllUnlock = singleData.value == 1
      roomStatusChanged = true
    elseif singleData.type == RaidCmd_pb.ERAIDPUZZLEDATA_TARGET then
      RaidPuzzleProxy.Instance:SetRaidPuzzleTarget(singleData)
      roomInfoNeedRefresh = true
    elseif singleData.type == RaidCmd_pb.ERAIDPUZZLEDATA_DESC then
      RaidPuzzleProxy.Instance:SetRaidDesc(singleData)
      roomInfoDescRefresh = true
    elseif singleData.type == RaidCmd_pb.ERAIDPUZZLEDATA_BOX then
      RaidPuzzleProxy.Instance:SetRaidBox(singleData)
      roomInfoNeedRefresh = true
    elseif singleData.type == RaidCmd_pb.ERAIDPUZZLEDATA_BUFF then
      RaidPuzzleProxy.Instance:SetRaidBuffs(singleData)
      roomInfoNeedRefresh = true
    elseif singleData.type == RaidCmd_pb.ERAIDPUZZLEDATA_LIGHT then
      RaidPuzzleProxy.Instance:SetRaidTorchPuzzle(singleData)
    end
  end
  if not self:IsWorking() then
    redlog("Recieved RecvRaidPuzzleDataUpdateRaidCmd before enter raid puzzle!")
    return
  end
  if self.roomDarkMaskMap[self.curRoomID] ~= curMaskPercent then
    self:RefreshDarkMask()
  end
  if roomStatusChanged then
    GameFacade.Instance:sendNotification(PVEEvent.RaidPuzzle_RoomStatusChange)
  end
  if roomInfoNeedRefresh then
    redlog("刷新美之宫信息面板")
    EventManager.Me():PassEvent(PVEEvent.RaidPuzzle_RefreshBordInfos)
  end
  if roomInfoDescRefresh then
    EventManager.Me():PassEvent(PVEEvent.RaidPuzzle_RefreshDescInfos)
  end
end

function RaidPuzzleManager:GetRaidConfig(key, defaultValue)
  return self.raidConfig and self.raidConfig[key] or self.raidPublicConfig and self.raidPublicConfig[key] or defaultValue
end

function RaidPuzzleManager:FindOrCreateTransform(name, objParent)
  local obj
  if objParent then
    obj = _Game.GameObjectUtil:DeepFind(objParent, name)
  else
    obj = GameObject.Find(name)
  end
  local tsfObj
  if obj then
    tsfObj = obj.transform
    for i = tsfObj.childCount - 1, 0, -1 do
      GameObject.DestroyImmediate(tsfObj:GetChild(i).gameObject)
    end
  else
    tsfObj = GameObject().transform
    if objParent then
      tsfObj:SetParent(objParent.transform, false)
    end
    tsfObj.name = name
    tsfObj.localPosition = _LuaGeometry.GetTempVector3(0, 0, 0)
    tsfObj.localEulerAngles = _LuaGeometry.GetTempVector3(0, 0, 0)
    tsfObj.localScale = _LuaGeometry.GetTempVector3(1, 1, 1)
  end
  return tsfObj
end

function RaidPuzzleManager:StartCheckPuzzleActionQuest(questData)
  self.sendQuestMap[questData.id] = nil
  local action = questData.params.action
  local opt = questData.params.opt
  if action == "enter" then
    if self.curRoomID == questData.params.id then
      redlog("完成进入房间任务，id = " .. tostring(questData.params.id))
      QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
    end
    self.checkEnterRoomQuestMap[questData.id] = questData
  elseif action == "exit" then
    if self.curRoomID ~= questData.params.id then
      redlog("完成离开房间任务，id = " .. tostring(questData.params.id))
      QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
    end
    self.checkExitRoomQuestMap[questData.id] = questData
  elseif action == "checklight" then
    self.checkLightQuestMap[questData.id] = questData
    self:CheckLightQuest()
  elseif action == "checkpushobj" then
    self.checkPushObjResultMap[questData.id] = questData
    self:CheckPushObjResultQuest()
  elseif action == "buffreward" then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.RaidPuzzleChooseBuffView,
      viewdata = questData
    })
  elseif action == "light" then
    if opt == "show" then
      self:HideLightAnimation()
      self:ShowLightAnimation(questData)
    elseif opt == "select" or opt == "switch" then
      self.curTorchPuzzleQuest = questData
    end
  else
    redlog("Unknown raid puzzle command by type: " .. tostring(questData.params.action))
  end
end

function RaidPuzzleManager:StartRefreshPuzzleActionQuest(questData)
  self.sendQuestMap[questData.id] = nil
  local action = questData.params.action
  if action == "light" then
    self:CheckLightQuest()
  else
    redlog("Unknown raid refresh puzzle command by type: " .. tostring(questData.params.action))
  end
  QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
end

function RaidPuzzleManager:StartPuzzleLightQuest(questData)
  self.sendQuestMap[questData.id] = nil
  local opt = questData.params.opt
  helplog("燃炬类型", opt)
  if opt == "show" then
    self:ShowLightAnimation(questData)
  elseif opt == "select" then
    self.curTorchPuzzleQuest = questData
  end
end

function RaidPuzzleManager:StartPuzzleNpcMoveQuest(questData)
  self.sendQuestMap[questData.id] = nil
  self.checkNpcMoveQuestMap[questData.id] = questData
end

local SetRenderersColor = function(listMat_Diss, listMat_Transparent, color)
  local material
  if listMat_Diss then
    for i = 1, #listMat_Diss do
      material = listMat_Diss[i] and listMat_Diss[i].material
      if material then
        material:SetColor("_Color", color)
      end
    end
  end
  if listMat_Transparent then
    for i = 1, #listMat_Transparent do
      material = listMat_Transparent[i] and listMat_Transparent[i].material
      if material then
        material:SetColor("_TintColor", color)
      end
    end
  end
end

function RaidPuzzleManager:SetRoomUnlock(roomID)
  if not self.running then
    return
  end
  self.unlockRoomMap[roomID] = self.raidRooms[roomID]
  local listMat_Diss = self.rendererCtrl_Diss[roomID] and self.rendererCtrl_Diss[roomID].renderersChangeMat
  local listMat_Transparent = self.rendererCtrl_Transparent[roomID] and self.rendererCtrl_Transparent[roomID].renderersChangeMat
  SetRenderersColor(listMat_Diss, listMat_Transparent, _LuaGeometry.GetTempColor(1, 1, 1, 0))
  if listMat_Diss or listMat_Transparent then
    TimeTickManager.Me():CreateTickFromTo(0, 0, 1, RaidPuzzleManager.RoomTweenDuration * 1000, function(owner, deltaTime, curValue)
      SetRenderersColor(listMat_Diss, listMat_Transparent, _LuaGeometry.GetTempColor(1, 1, 1, curValue))
    end, self, roomID)
  end
  if self.objRoomsMap[roomID] then
    self.objRoomsMap[roomID]:SetActive(true)
  end
end

function RaidPuzzleManager:GetMiniMapRoomStringStatusMap(targetMap)
  for roomID, roomData in pairs(self.raidRooms) do
    if self.passedRoomMap[roomID] then
      targetMap[tostring(roomID)] = RaidPuzzleManager.E_RoomStatus.Passed
    elseif self.unlockRoomMap[roomID] then
      targetMap[tostring(roomID)] = RaidPuzzleManager.E_RoomStatus.Unlock
    elseif self.isMiniMapAllUnlock then
      targetMap[tostring(roomID)] = RaidPuzzleManager.E_RoomStatus.Lock
    else
      targetMap[tostring(roomID)] = RaidPuzzleManager.E_RoomStatus.Disable
    end
  end
end

function RaidPuzzleManager:RefreshDarkMask()
  self.darkMaskAlpha = self.roomDarkMaskMap[self.curRoomID]
  if MyselfData.BlindMaskViewInstance == nil then
    if self.darkMaskAlpha and self.darkMaskAlpha > 0 then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.BlindMaskView
      })
    end
  else
    GameFacade.Instance:sendNotification(PVEEvent.RaidPuzzle_RefreshDarkMask)
  end
end

function RaidPuzzleManager:GetDarkMaskAlpha()
  return self.darkMaskAlpha
end

function RaidPuzzleManager:FindAreaInfoByPosXZ(posX, posZ)
  for areaID, areaData in pairs(self.raidAreaMap) do
    if posX >= areaData.MinPosX and posZ >= areaData.MinPosZ and posX <= areaData.MinPosX + areaData.Col * (areaData.CellSize * self.mapScale) and posZ <= areaData.MinPosZ + areaData.Row * (areaData.CellSize * self.mapScale) then
      local row, col = self:PosXZToAreaRowAndCol(areaID, posX, posZ)
      return areaID, row, col
    end
  end
end

function RaidPuzzleManager:PosXZToAreaRowAndCol(areaID, posX, posZ)
  return RaidPuzzleFun.PosZToAreaRow(areaID, posZ), RaidPuzzleFun.PosXToAreaCol(areaID, posX)
end

function RaidPuzzleManager:AreaRowAndColToPosXZ(areaID, row, col)
  return RaidPuzzleFun.AreaColToPosX(areaID, col), RaidPuzzleFun.AreaRowToPosZ(areaID, row)
end

function RaidPuzzleManager:TryPushCurrentTargetObject()
  self:TryPushObject(self.targetPushableObject, self.targetDeltaRow, self.targetDeltaCol)
end

function RaidPuzzleManager:ClampRow(row, npcData, areaData, ignorePushLimit)
  local result = _math.clamp(row, 1, areaData.Row)
  local pushRange = npcData:Push_GetStaticData("RangeRow")
  if pushRange and pushRange ~= E_pushNoLimit then
    local configRow, configCol = npcData:Push_GetConfigRowAndCol()
    if not configRow then
      LogUtility.Error("PushableObj not Inited!!")
      local areaID, curRow, curCol = self:GetObjAreaInfo(npcData.id)
      return curRow
    end
    result = _math.clamp(result, configRow - pushRange, configRow + pushRange)
  end
  local pushLimit = npcData.userdata:Get(UDEnum.BOX_PUSHLIMIT) or 0
  if pushLimit ~= E_pushNoLimit and not ignorePushLimit then
    local clientPushLimit = self.pushLimitClientRecord[npcData.id]
    if clientPushLimit then
      pushLimit = _math.max(pushLimit - clientPushLimit, 0)
    end
    local areaID, curRow, curCol = self:GetObjAreaInfo(npcData.id)
    if curRow and curCol then
      result = _math.clamp(result, curRow - pushLimit, curRow + pushLimit)
    end
  end
  return result, result == row
end

function RaidPuzzleManager:ClampCol(col, npcData, areaData, ignorePushLimit)
  local result = _math.clamp(col, 1, areaData.Col)
  local pushRange = npcData:Push_GetStaticData("RangeCol")
  if pushRange and pushRange ~= E_pushNoLimit then
    local configRow, configCol = npcData:Push_GetConfigRowAndCol()
    if not configCol then
      LogUtility.Error("PushableObj not Inited!!")
      local areaID, curRow, curCol = self:GetObjAreaInfo(npcData.id)
      return curRow
    end
    result = _math.clamp(result, configCol - pushRange, configCol + pushRange)
  end
  local pushLimit = npcData.userdata:Get(UDEnum.BOX_PUSHLIMIT) or 0
  if pushLimit ~= E_pushNoLimit and not ignorePushLimit then
    local clientPushLimit = self.pushLimitClientRecord[npcData.id]
    if clientPushLimit then
      pushLimit = _math.max(pushLimit - clientPushLimit, 0)
    end
    local areaID, curRow, curCol = self:GetObjAreaInfo(npcData.id)
    if curRow and curCol then
      result = _math.clamp(result, curCol - pushLimit, curCol + pushLimit)
    end
  end
  return result, result == col
end

local OnPushObjectBodyLoad = function(assetRole, npc)
  local selfClass = RaidPuzzleManager.Me()
  local body = assetRole and assetRole:GetPartObject(Asset_Role.PartIndex.Body)
  if not body or not selfClass:IsWorking() then
    return
  end
  npc = npc or _NSceneNpcProxy.Instance:Find(assetRole.complete.GUID)
  if not npc then
    selfClass.npcLoadMap[assetRole.complete.GUID] = nil
    return
  end
  selfClass.npcLoadMap[npc.data.id] = nil
  local areaID, curRow, curCol = selfClass:GetObjAreaInfo(npc.data.id)
  local position = npc:GetPosition()
  if curRow and curCol then
    local posX, posZ = selfClass:AreaRowAndColToPosXZ(areaID, curRow, curCol)
    position = _LuaGeometry.GetTempVector3(posX, position[2], posZ)
  end
  selfClass:PlaceFakeObstacle(npc, position)
  local name = RotateSkinNameMap and RotateSkinNameMap[npc.data.staticData.Body] or "may_1F_jz_a"
  local objRotateRoot = _Game.GameObjectUtil:DeepFind(body.gameObject, name)
  if objRotateRoot then
    objRotateRoot.transform.localEulerAngles = _LuaGeometry.GetTempVector3(0, m_objRotateDirections[npc.data:Push_GetDirection()], 0)
  end
  local objBlockLight = _Game.GameObjectUtil:DeepFind(body.gameObject, "BlockSunLight")
  if objBlockLight then
    NGUITools.SetLayer(objBlockLight, _Game.ELayer.Cam_Filter)
  end
  local comPushTarget = body:GetComponentInChildren(LineReflectionTarget, true)
  if comPushTarget then
    NGUITools.SetLayer(comPushTarget.gameObject, _Game.ELayer.Cam_Filter)
  end
  if not selfClass:CheckNpcLoading() then
    selfClass:CheckLightQuest()
  end
end

function RaidPuzzleManager:AddPushObject(npc)
  local objID = npc.data:GetPushableObjID()
  if not objID or objID == 0 then
    return
  end
  local objConfig = objID and self.pushObjCfgMap[objID]
  if not objConfig then
    LogUtility.Error("Cannot find obj config for id: " .. tostring(objID))
    return
  end
  local areaData = self.raidAreaMap[objConfig.AreaID]
  if not areaData then
    LogUtility.Error("AddPushObject: Cannot Find AreaID " .. tostring(objConfig.AreaID))
    return
  end
  local configRow, configCol = self:PosXZToAreaRowAndCol(objConfig.AreaID, objConfig.PosX, objConfig.PosZ)
  npc.data:Push_InitData(objConfig, configRow, configCol)
  local areaID, curRow, curCol = self:GetObjAreaInfo(npc.data.id)
  local position = npc:GetPosition()
  if areaID and curRow and curCol then
    local posX, posZ = self:AreaRowAndColToPosXZ(areaID, curRow, curCol)
    npc.logicTransform:PlaceTo(_LuaGeometry.GetTempVector3(posX, position[2], posZ))
  else
    curRow, curCol = self:PosXZToAreaRowAndCol(objConfig.AreaID, position[1], position[3])
    local isSame = true
    curRow, isSame = self:ClampRow(curRow, npc.data, areaData, true)
    if not isSame then
      LogUtility.Error(string.format("npcid: %s row is illegal! posZ: %s, areaID: %s, objID: %s", npc.data.id, position[3], objConfig.AreaID, objID))
    end
    curCol, isSame = self:ClampCol(curCol, npc.data, areaData, true)
    if not isSame then
      LogUtility.Error(string.format("npcid: %s col is illegal! posX: %s, areaID: %s, objID: %s", npc.data.id, position[1], objConfig.AreaID, objID))
    end
  end
  if objConfig.ObjNpc or self.cfgNpcCanBlockLight and _TableUtility.ArrayFindIndex(self.cfgNpcCanBlockLight, npc.data:GetStaticID()) then
    npc:ReDressImmediate()
    self.npcLoadMap[npc.data.id] = ServerTime.CurServerTime()
  end
  local targetCellIndex = curRow * areaData.Col + curCol
  local curCellGUID = self.areaObjMap[objConfig.AreaID][targetCellIndex]
  if curCellGUID and curCellGUID ~= npc.data.id then
    LogUtility.Error(string.format("Canot put obj into grid! Target cell is not empty! Obj ID: %s, guid: %s, target cell guid: %s", objID, npc.data.id, self.areaObjMap[objConfig.AreaID][targetCellIndex]))
    self:RecordObjAreaInfo(npc.data.id, objConfig.AreaID)
  else
    self:RecordObjAreaInfo(npc.data.id, objConfig.AreaID, curRow, curCol)
    self.areaObjMap[objConfig.AreaID][targetCellIndex] = npc.data.id
  end
  npc.assetRole:SetCallbackOnBodyChanged(OnPushObjectBodyLoad)
  OnPushObjectBodyLoad(npc.assetRole, npc)
  self:ShowObjPushLimit(npc)
end

function RaidPuzzleManager:RemovePushObject(npc)
  if not self:IsWorking() then
    return
  end
  local npcID = npc.data.id
  self:RemoveFakeObstacle(npcID)
  self:DestroyObjPushLimitCell(npc)
  self.npcLoadMap[npcID] = nil
  if self.objPosTweenerMap[npcID] then
    self.objPosTweenerMap[npcID].enabled = false
    self.objPosTweenerMap[npcID] = nil
  end
  if self.objRotateTweenerMap[npcID] then
    self.objRotateTweenerMap[npcID].enabled = false
    self.objRotateTweenerMap[npcID] = nil
  end
  local areaID, curRow, curCol = self:GetObjAreaInfo(npcID)
  if not (areaID and curRow) or not curCol then
    return
  end
  local areaData = self.raidAreaMap[areaID]
  if not areaData then
    LogUtility.Error("RemovePushObject: Cannot Find AreaID " .. tostring(areaID))
    return
  end
  local targetCellIndex = curRow * areaData.Col + curCol
  local curID = self.areaObjMap[areaID][targetCellIndex]
  if curID and curID ~= npcID then
    LogUtility.Error(string.format("Remove obj from grid but target id is not match! npc ID: %s, target cell ID: %s", npcID, curID))
  end
  self.areaObjMap[areaID][targetCellIndex] = nil
  self:RecordObjAreaInfo(npcID)
end

function RaidPuzzleManager:CheckNpcLoading()
  local time = ServerTime.CurServerTime()
  for guid, loadTime in pairs(self.npcLoadMap) do
    if time - loadTime < 8000 then
      return true
    else
      self.npcLoadMap[guid] = nil
    end
  end
  return false
end

function RaidPuzzleManager:TryPushObject(npc, deltaRow, deltaCol, startSpeed)
  if not (npc and npc.data and not npc.data:Push_IsLockPush() and not npc.data:Push_GetFeature_ForbidPush() and npc:GetRoleComplete()) or not FunctionUnLockFunc.Me():CheckCanOpen(9923) then
    self:FinishPushObj()
    return
  end
  local areaID, curRow, curCol = self:GetObjAreaInfo(npc.data.id)
  local areaData = self.raidAreaMap[areaID]
  if not (areaData and curRow) or not curCol then
    LogUtility.Error(string.format("TryPushObject Wrong Data! areaID: %s, areaData: %s, curRow: %s, curCol: %s", areaID, areaData, curRow, curCol))
    self:FinishPushObj()
    return
  end
  local targetRow, targetCol, moveCellCount = self:GetTargetRowAndCol(npc, deltaRow, deltaCol, areaData, startSpeed)
  if moveCellCount < 1 then
    self:TryPushNextObject(npc, areaData, deltaRow, deltaCol, startSpeed)
    return
  end
  local targetCellIndex = targetRow * areaData.Col + targetCol
  if self.areaObjMap[areaID][targetCellIndex] then
    self:FinishPushObj()
    return
  end
  if curRow and curCol then
    self.areaObjMap[areaID][curRow * areaData.Col + curCol] = nil
  end
  self.areaObjMap[areaID][targetCellIndex] = npc.data.id
  local pushLimit = npc.data.userdata:Get(UDEnum.BOX_PUSHLIMIT) or 0
  if pushLimit ~= E_pushNoLimit then
    self.pushLimitClientRecord[npc.data.id] = (self.pushLimitClientRecord[npc.data.id] or 0) + 1
  end
  self.isPushingObject = true
  local posX, posZ = self:AreaRowAndColToPosXZ(areaID, targetRow, targetCol)
  local posY = npc:GetPosition()[2]
  self:RecordObjAreaInfo(npc.data.id, areaID, targetRow, targetCol)
  _Game.InputManager:Interrupt()
  FunctionSystem.InterruptMyselfAll()
  _Game.Myself:LookAt(npc:GetPosition())
  _Game.Myself:Client_PlayAction(Table_ActionAnime[self:GetRaidConfig("PushActionAnim", 0)].Name, nil, false)
  npc.data:Push_LockPush(true)
  local targetPos = _LuaGeometry.GetTempVector3(posX, posY, posZ)
  self:PlaceFakeObstacle(npc, targetPos)
  npc:PlayAudio(AudioMap.Maps.RaidPuzzle_PushObj)
  local tweener, endSpeed
  if npc.data:Push_GetFeature_IsIceBox() then
    startSpeed = startSpeed or self:GetRaidConfig("IceStartSpeed", 1)
    endSpeed = _math.max(startSpeed - self:GetRaidConfig("IceSpeedPerCell", 1) * moveCellCount, 0)
    tweener = TweenUtility.BeginIceMove(npc:GetRoleComplete().gameObject, targetPos, startSpeed, endSpeed)
  else
    tweener = TweenPosition.Begin(npc:GetRoleComplete().gameObject, 1, targetPos, true)
    tweener.method = 2
  end
  self.objPosTweenerMap[npc.data.id] = tweener
  tweener:SetOnFinished(function()
    npc.data:Push_LockPush(false)
    npc.logicTransform:PlaceTo(_LuaGeometry.GetTempVector3(posX, posY, posZ))
    self.objPushWaitSendMap[#self.objPushWaitSendMap + 1] = self:SetPbData_PushObj(ReusableTable.CreateTable(), npc.data.id, posX, posY, posZ)
    self:TryPushNextObject(npc, areaData, deltaRow, deltaCol, endSpeed)
  end)
end

function RaidPuzzleManager:TryPushNextObject(npc, areaData, deltaRow, deltaCol, startSpeed)
  if npc.data:Push_GetFeature_IsIceBox() then
    local areaID, curRow, curCol = self:GetObjAreaInfo(npc.data.id)
    local nextRow, nextCol = _math.clamp(curRow + (deltaRow or 0), 1, areaData.Row), _math.clamp(curCol + (deltaCol or 0), 1, areaData.Col)
    if nextRow ~= curRow or nextCol ~= curCol then
      local nextGUID = self.areaObjMap[areaID][nextRow * areaData.Col + nextCol]
      local targetNpc = nextGUID and _NSceneNpcProxy.Instance:Find(nextGUID)
      if targetNpc and targetNpc.data:Push_GetFeature_IsIceBox() then
        TimeTickManager.Me():CreateOnceDelayTick(0, function(owner, deltaTime)
          owner:TryPushObject(targetNpc, deltaRow, deltaCol, startSpeed)
        end, self, E_TimeTickIDRange.Normal + 1)
        return
      end
    end
  end
  self:FinishPushObj()
end

function RaidPuzzleManager:FinishPushObj()
  self.isPushingObject = false
  if #self.objPushWaitSendMap < 1 then
    return
  end
  ServiceRaidCmdProxy.Instance:CallRaidPuzzlePushObjRaidCmd(self.objPushWaitSendMap)
  for index, pbData in pairs(self.objPushWaitSendMap) do
    ReusableTable.DestroyAndClearTable(pbData)
  end
  TableUtility.TableClear(self.objPushWaitSendMap)
  self:CheckPushObjResultQuest()
  self:UpdateNpcMoveQuest(true)
end

function RaidPuzzleManager:GetTargetRowAndCol(npc, deltaRow, deltaCol, areaData, startSpeed)
  local areaID, curRow, curCol = self:GetObjAreaInfo(npc.data.id)
  curRow, curCol = curRow or 1, curCol or 1
  local targetRow, targetCol = curRow, curCol
  local singleAreaMap = self.areaObjMap[areaID]
  local maxMoveDelta = startSpeed and startSpeed / self:GetRaidConfig("IceSpeedPerCell", 1) or _math.max(areaData.Row, areaData.Col)
  if deltaRow and deltaRow ~= 0 then
    if npc.data:Push_GetFeature_IsIceBox() then
      local index, found
      if deltaRow < 0 then
        local maxLimit = _math.max(1, curRow - maxMoveDelta)
        for i = curRow + deltaRow, maxLimit, -1 do
          index = i * areaData.Col + curCol
          if singleAreaMap[index] then
            targetRow = i + 1
            found = true
            break
          elseif self:IsHole(areaID, i, curCol) then
            targetRow = i
            found = true
            break
          end
        end
        if not found then
          targetRow = maxLimit
        end
      else
        local maxLimit = _math.min(areaData.Row, curRow + maxMoveDelta)
        for i = curRow + deltaRow, maxLimit do
          index = i * areaData.Col + curCol
          if singleAreaMap[index] then
            targetRow = i - 1
            found = true
            break
          elseif self:IsHole(areaID, i, curCol) then
            targetRow = i
            found = true
            break
          end
        end
        if not found then
          targetRow = maxLimit
        end
      end
    else
      targetRow = targetRow + deltaRow
    end
    targetRow = self:ClampRow(targetRow, npc.data, areaData)
  end
  if deltaCol and deltaCol ~= 0 then
    if npc.data:Push_GetFeature_IsIceBox() then
      local index, found
      if deltaCol < 0 then
        local maxLimit = _math.max(1, curCol - maxMoveDelta)
        for i = curCol + deltaCol, maxLimit, -1 do
          index = curRow * areaData.Col + i
          if singleAreaMap[index] then
            targetCol = i + 1
            found = true
            break
          elseif self:IsHole(areaID, curRow, i) then
            targetCol = i
            found = true
            break
          end
        end
        if not found then
          targetCol = maxLimit
        end
      else
        local maxLimit = _math.min(areaData.Col, curCol + maxMoveDelta)
        for i = curCol + deltaCol, maxLimit do
          index = curRow * areaData.Col + i
          if singleAreaMap[index] then
            targetCol = i - 1
            found = true
            break
          elseif self:IsHole(areaID, curRow, i) then
            targetCol = i
            found = true
            break
          end
        end
        if not found then
          targetCol = maxLimit
        end
      end
    else
      targetCol = targetCol + deltaCol
    end
    targetCol = self:ClampCol(targetCol, npc.data, areaData)
  end
  return targetRow, targetCol, _math.max(_math.abs(targetRow - curRow), _math.abs(targetCol - curCol))
end

function RaidPuzzleManager:IsHole(areaID, row, col)
  local cfgHoles = self:GetRaidConfig("PushHoles")
  local openAnim = self:GetRaidConfig("PushHoleStatus_Open")
  local areaHoles = cfgHoles and cfgHoles[areaID]
  if not areaHoles then
    return false
  end
  if not openAnim then
    LogUtility.Error("Cannot find GameConfig.RaidPuzzle.Public.PushHoleStatus_Open")
    return false
  end
  local sceneBossAnimeManager = _Game.GameObjectManagers[_Game.GameObjectType.SceneBossAnime]
  for i = 1, #areaHoles do
    if row == areaHoles[i].row and col == areaHoles[i].col then
      return areaHoles[i].isStatic or sceneBossAnimeManager:GetCurAnimState(areaHoles[i].objID) == openAnim
    end
  end
  return false
end

function RaidPuzzleManager:RecordObjAreaInfo(guid, areaID, row, col)
  self.objAreaRecordMap[guid] = areaID
  self.objRowRecordMap[guid] = row
  self.objColRecordMap[guid] = col
  if RaidPuzzleManager.DebugMode then
    local npc = _NSceneNpcProxy.Instance:Find(guid)
    if npc and npc.assetRole and npc.assetRole.completeTransform then
      npc.assetRole.completeTransform.name = string.format("%s_%s_%s_%s_%s", npc.data:GetName(), npc.data:GetPushableObjID(), areaID, row, col)
    end
  end
end

function RaidPuzzleManager:GetObjAreaInfo(guid)
  return self.objAreaRecordMap[guid], self.objRowRecordMap[guid], self.objColRecordMap[guid]
end

function RaidPuzzleManager:SetPbData_PushObj(table, guid, posX, posY, posZ)
  table.guid = guid
  table.x = posX
  table.y = posY
  table.z = posZ
  return table
end

function RaidPuzzleManager:PlaceFakeObstacle(npc, targetPos)
  if not targetPos or not self:IsWorking() then
    return
  end
  local objFakeObstacle = self.fakeObstacleMap[npc.data.id]
  if not objFakeObstacle then
    local complete = npc:GetRoleComplete()
    local body = complete and complete.body
    if not body then
      return
    end
    local objObstacle = _Game.GameObjectUtil:DeepFind(body.gameObject, "Obstacle")
    if objObstacle then
      objObstacle:SetActive(false)
      objFakeObstacle = GameObject.Instantiate(objObstacle, self.tsfFakeObstacleRoot)
      objFakeObstacle.name = npc.data.id
      NGUITools.SetLayer(objFakeObstacle, _Game.ELayer.Default)
      self.fakeObstacleMap[npc.data.id] = objFakeObstacle
    end
  end
  if not objFakeObstacle then
    return
  end
  objFakeObstacle:SetActive(true)
  objFakeObstacle.transform.position = targetPos
end

function RaidPuzzleManager:RemoveFakeObstacle(npcID)
  local objFakeObstacle = self.fakeObstacleMap[npcID]
  if objFakeObstacle then
    objFakeObstacle:SetActive(false)
  end
end

function RaidPuzzleManager:DisableMove(id, isDisable)
  local lastIsDisableMove = next(self.disableMoveMap) ~= nil
  if isDisable then
    if id then
      self.disableMoveMap[id] = true
    end
  elseif id then
    self.disableMoveMap[id] = nil
  else
    _TableUtility.TableClear(self.disableMoveMap)
  end
  local curIsDisableMove = next(self.disableMoveMap) ~= nil
  if lastIsDisableMove == curIsDisableMove then
    return
  end
  _Game.InputManager.disableMove = _Game.InputManager.disableMove + (curIsDisableMove and 1 or -1)
end

local vecMyForward = LuaVector3(0, 0, 0)
local vecNpcToMe = LuaVector3(0, 0, 0)
local CheckNpcIsTargetPushableObject = function(npc)
  if npc.data:Push_IsLockPush() or npc.data:Push_GetFeature_ForbidPush() then
    return
  end
  _VectorUtility.Asign_3(vecNpcToMe, npc:GetPosition())
  local myselfPos = _Game.Myself:GetPosition()
  LuaVector3.Sub(vecNpcToMe, myselfPos)
  local selfClass = RaidPuzzleManager.Me()
  local areaID, curRow, curCol = selfClass:GetObjAreaInfo(npc.data.id)
  local areaData = selfClass.raidAreaMap[areaID]
  if not areaData then
    return
  end
  local myRow, myCol = selfClass:PosXZToAreaRowAndCol(areaID, myselfPos[1], myselfPos[3])
  if myRow ~= curRow and myCol ~= curCol then
    return
  end
  local targetRow, targetCol = curRow or 1, curCol or 1
  if _math.abs(vecNpcToMe[3]) > _math.abs(vecNpcToMe[1]) then
    targetRow = selfClass:ClampRow(targetRow + (vecNpcToMe[3] > 0 and 1 or -1), npc.data, areaData)
  else
    targetCol = selfClass:ClampCol(targetCol + (vecNpcToMe[1] > 0 and 1 or -1), npc.data, areaData)
  end
  if targetRow == curRow and targetCol == curCol then
    return
  end
  return not selfClass.areaObjMap[areaID][targetRow * areaData.Col + targetCol] and LuaVector3.Angle(vecNpcToMe, vecMyForward) < m_pushHalfAngle
end
local GetTransformForward = LuaGameObject.GetTransformForward

function RaidPuzzleManager:UpdateTargetPushableObject(time, deltaTime)
  if not FunctionUnLockFunc.Me():CheckCanOpen(9923) or self.isPushingObject then
    return
  end
  local lastHaveTarget = self.targetPushableObject ~= nil
  LuaVector3.Better_Set(vecMyForward, GetTransformForward(_Game.Myself.assetRole.completeTransform))
  self.targetPushableObject = _NSceneNpcProxy.Instance:FindNearestInNearNpc(_Game.Myself:GetPosition(), m_pushObjRange, CheckNpcIsTargetPushableObject)
  if self.targetPushableObject then
    _VectorUtility.Asign_3(vecNpcToMe, self.targetPushableObject:GetPosition())
    LuaVector3.Sub(vecNpcToMe, _Game.Myself:GetPosition())
    self.targetDeltaRow, self.targetDeltaCol = vecNpcToMe[3], vecNpcToMe[1]
    if _math.abs(self.targetDeltaRow) > _math.abs(self.targetDeltaCol) then
      self.targetDeltaCol = 0
      self.targetDeltaRow = self.targetDeltaRow > 0 and 1 or -1
    else
      self.targetDeltaRow = 0
      self.targetDeltaCol = self.targetDeltaCol > 0 and 1 or -1
    end
  end
  local curHaveTarget = self.targetPushableObject ~= nil
  if lastHaveTarget ~= curHaveTarget then
    _GameFacade.Instance:sendNotification(InteractNpcEvent.PushableTargetChange, curHaveTarget)
  end
end

function RaidPuzzleManager:CheckPushObjResultQuest()
  local areaData, npcID, npc, npcSID
  for questID, questData in pairs(self.checkPushObjResultMap) do
    areaData = self.raidAreaMap[questData.params.areaid]
    if areaData then
      npcID = self.areaObjMap[areaData.id][questData.params.row * areaData.Col + questData.params.col]
      npc = npcID and _NSceneNpcProxy.Instance:Find(npcID)
      npcSID = npc and npc.data:GetStaticID()
      if npcSID and (not questData.params.npcsid or npcSID == questData.params.npcsid) then
        QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, npc.data:GetPushableObjID())
      end
    else
      LogUtility.Error(string.format("CheckPushObjResultQuest: Cannot Find AreaID %s When Do Quest %s", tostring(questData.params.areaid), tostring(questID)))
    end
  end
end

local RotateSkinNameMap = GameConfig.RaidPuzzle.RotateSkinNameMap
RotateSkinNameMap = RotateSkinNameMap or {
  [2200] = "may_1F_jz_a"
}

function RaidPuzzleManager:RotatePushableObject(npc)
  if not (npc and npc.data) or npc.data:Push_IsLockRotate() then
    return
  end
  if not npc.data:Push_GetFeature_CanRotate() then
    return
  end
  local curDirection = npc.data:Push_GetDirection() + 1
  local angleFix = 0
  if curDirection > #m_objRotateDirections then
    curDirection = 1
    angleFix = 360
  end
  npc.assetRole:ChangeColorFromTo(_LuaGeometry.Const_Col_white, _LuaGeometry.Const_Col_whiteClear, 0.5)
  npc.data:Push_SetDirection(curDirection)
  local name = RotateSkinNameMap and RotateSkinNameMap[npc.data.staticData.Body] or "may_1F_jz_a"
  local objRotateRoot = _Game.GameObjectUtil:DeepFind(npc:GetRoleComplete().gameObject, name)
  if not objRotateRoot then
    LogUtility.Error("Cannot find child may_1F_jz_a from npc: " .. npc:GetRoleComplete().name)
    return
  end
  npc.data:Push_LockRotate(true)
  npc:PlayAudio(AudioMap.Maps.RaidPuzzle_RotateObj)
  local tweener = TweenRotation.Begin(objRotateRoot, 0.5, _LuaGeometry.GetTempVector3(0, m_objRotateDirections[curDirection] + angleFix, 0))
  self.objRotateTweenerMap[npc.data.id] = tweener
  local areaID, curRow, curCol = self:GetObjAreaInfo(npc.data.id)
  self:ForbidAreaLightRefresh(areaID, true)
  tweener:SetOnFinished(function()
    self:OnRotatePushableObjectOver(npc)
  end)
end

function RaidPuzzleManager:OnRotatePushableObjectOver(npc)
  if not (npc and npc:Alive()) or not RaidPuzzleManager.Me():IsWorking() then
    return
  end
  npc.data:Push_LockRotate(false)
  local areaID, curRow, curCol = self:GetObjAreaInfo(npc.data.id)
  self:ForbidAreaLightRefresh(areaID, false)
  self:CheckPushObjResultQuest()
  ServiceRaidCmdProxy.Instance:CallRaidPuzzleRotateObjRaidCmd(npc.data.id, npc.data:Push_GetDirection())
end

function RaidPuzzleManager:ShowObjPushLimit(npc, reset)
  if not npc or not self:IsWorking() then
    return
  end
  local pushLimit = npc.data and npc.data.userdata:Get(UDEnum.BOX_PUSHLIMIT)
  local pushCell = self.pushLimitCells[npc.data.id]
  if not pushLimit or pushLimit == E_pushNoLimit or pushLimit == 0 then
    if pushCell then
      self:DestroyObjPushLimitCell(npc)
    end
    return
  end
  if not pushCell then
    local container = SceneUIManager.Instance:GetSceneUIContainer(SceneUIType.RoleTopInfo)
    local objCell = _Game.AssetManager_UI:CreateSceneUIAsset(PushableObjLimitCell.ResID, container)
    objCell.transform.localRotation = _LuaGeometry.Const_Qua_identity
    objCell.transform.localScale = _LuaGeometry.GetTempVector3(1, 1, 1)
    pushCell = PushableObjLimitCell.new(objCell)
    npc:Client_RegisterFollow(pushCell.trans, nil, RoleDefines_EP.Top, OnLostCreatureFollow, npc.data.id)
    self.pushLimitCells[npc.data.id] = pushCell
  end
  if reset then
    self.pushLimitClientRecord[npc.data.id] = 0
  end
  pushCell:SetPushLimitInfo(npc.data.id, pushLimit)
end

local OnLostCreatureFollow = function(transform, creatureGUID)
  local pushCell = self.pushLimitCells and self.pushLimitCells[creatureGUID]
  if not pushCell then
    return
  end
  LuaGameObject.DestroyObject(pushCell.gameObject)
  self.pushLimitCells[creatureGUID] = nil
end

function RaidPuzzleManager:DestroyObjPushLimitCell(npc)
  local pushCell = self.pushLimitCells[npc.data.id]
  if not pushCell then
    return
  end
  npc:Client_UnregisterFollow(pushCell.trans)
  LuaGameObject.DestroyObject(pushCell.gameObject)
  self.pushLimitCells[npc.data.id] = nil
end

function RaidPuzzleManager:ClearPushLimitCells()
  if not self.pushLimitCells then
    return
  end
  local player
  for charID, pushCell in pairs(self.pushLimitCells) do
    if pushCell then
      player = _NSceneNpcProxy.Instance:Find(pushCell.masterID)
      if player then
        player:Client_UnregisterFollow(pushCell.trans)
      end
      LuaGameObject.DestroyObject(pushCell.gameObject)
    end
  end
  TableUtility.TableClear(self.pushLimitCells)
end

function RaidPuzzleManager:ForbidAreaLightRefresh(areaID, isForbid)
  local lightAreaMap = self:GetRaidConfig("LightAreaMap")
  local lightMap = lightAreaMap and lightAreaMap[areaID]
  if lightMap then
    local result = isForbid and true or nil
    for i = 1, #lightMap do
      self.forbidLightMap[lightMap[i]] = result
    end
  end
end

function RaidPuzzleManager:RefreshLight(id, check)
  _Game.GameObjectManagers[_Game.GameObjectType.RaidPuzzle_Light]:RefreshLight(id, check and RaidPuzzleManager.OnLightRefreshFinish or nil)
end

function RaidPuzzleManager.OnLightRefreshFinish(objLight)
  RaidPuzzleManager.Me():CheckLightQuest()
end

function RaidPuzzleManager:CheckLightQuest()
  if self:CheckNpcLoading() then
    return
  end
  local lightManager = _Game.GameObjectManagers[_Game.GameObjectType.RaidPuzzle_Light]
  local hitObj
  for questID, questData in pairs(self.checkLightQuestMap) do
    if not self.checkSyncTag.light[questID] then
      hitObj = lightManager:GetLastHitGameObject(questData.params.lightid)
      if (hitObj and hitObj.name == questData.params.targetname) == true == not questData.params.checknolight then
        self.checkSyncTag.light[questID] = 1
        QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
      end
    end
  end
end

function RaidPuzzleManager:UpdateCurrentRoom(time, deltaTime)
  local myselfPos = _Game.Myself:GetPosition()
  if self.curRoomData and myselfPos[1] > self.curRoomData.MinPosX and myselfPos[3] > self.curRoomData.MinPosZ and myselfPos[1] < self.curRoomData.MaxPosX and myselfPos[3] < self.curRoomData.MaxPosZ then
    return
  end
  local newRoomData
  for roomID, roomData in pairs(self.raidRooms) do
    if myselfPos[1] > roomData.MinPosX and myselfPos[3] > roomData.MinPosZ and myselfPos[1] < roomData.MaxPosX and myselfPos[3] < roomData.MaxPosZ then
      newRoomData = roomData
      break
    end
  end
  if self.curRoomData == newRoomData then
    return
  end
  self:_CurrentRoomChange(self.curRoomData, newRoomData)
end

function RaidPuzzleManager:_CurrentRoomChange(lastRoomData, curRoomData)
  self.curRoomData = curRoomData
  self.curRoomID = curRoomData and curRoomData.id
  redlog("当前房间ID", self.curRoomID)
  local myselfPos = _Game.Myself:GetPosition()
  local roomData
  if lastRoomData then
    for questID, questData in pairs(self.checkExitRoomQuestMap) do
      roomData = self.raidRooms[questData.params.id]
      if not roomData or roomData.id == lastRoomData.id then
        if not roomData then
          redlog("Cannot find room by command id: " .. tostring(questData.params.id))
        end
        redlog("完成离开房间任务，id = " .. tostring(questData.params.id))
        QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
      end
    end
  end
  if curRoomData then
    for questID, questData in pairs(self.checkEnterRoomQuestMap) do
      roomData = self.raidRooms[questData.params.id]
      if not roomData or roomData.id == curRoomData.id then
        if not roomData then
          redlog("Cannot find room by command id: " .. tostring(questData.params.id))
        end
        redlog("完成进入房间任务，id = " .. tostring(questData.params.id))
        QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
      end
    end
  end
  self:RefreshDarkMask()
  self:RefreshCurRoomElevator()
  self:RefreshRoomCameraFilter()
end

function RaidPuzzleManager:GetCurrentRoomID()
  return self.curRoomID
end

function RaidPuzzleManager:RefreshRoomCameraFilter()
  local roomCameraCfg = self:GetRaidConfig("RoomCameraFilter")
  local curCfID = roomCameraCfg and roomCameraCfg[self.curRoomID]
  if curCfID then
    if curCfID ~= self.curCfID then
      local cfData = Table_CameraFilters[curCfID]
      if not cfData then
        redlog("Cannot find CameraFilter data by id", curCfID)
      end
      self:_SetCameraFilterData(cfData, curCfID)
    end
  elseif self.curCfID then
    self:_SetCameraFilterData()
  end
end

function RaidPuzzleManager:_SetCameraFilterData(cfData, curCfID)
  if cfData then
    CameraFilterProxy.Instance:CFSetEffectAndSpEffect(cfData.FilterName, cfData.SpecialEffectsName)
    CameraFilterProxy.Instance:SetForbidPlayerOperation(RaidPuzzleManager, true)
    self.curCfID = curCfID
  elseif self.curCfID then
    CameraFilterProxy.Instance:SetForbidPlayerOperation(RaidPuzzleManager, false)
    CameraFilterProxy.Instance:CFQuit()
    self.curCfID = nil
  end
end

function RaidPuzzleManager:ShowLightAnimation(questData)
  local params = questData.params
  local animeId = params.animid
  redlog("点火展示")
  local torches = RaidPuzzleProxy.Instance.puzzleRaidTorches or {}
  local id = 1
  if torches and 0 < #torches then
    while torches[id] do
      local boxid = torches[id]
      local box = self.pushObjCfgMap[boxid]
      if not box then
        redlog("缺少boxid", torches[id])
        break
      end
      local npcId = box.NpcID
      TimeTickManager.Me():CreateOnceDelayTick(1000 * id, function(owner, deltaTime)
        local npcs = _NSceneNpcProxy.Instance:FindNpcs(npcId)
        if npcs and 0 < #npcs then
          for i = 1, #npcs do
            if npcs[i].data:GetPushableObjID() == boxid then
              local actionName = Table_ActionAnime[animeId].Name
              if npcs[i] then
                helplog("点亮", boxid)
                npcs[i]:Server_PlayActionCmd(actionName, nil, true)
              end
            end
          end
        end
      end, self, E_TimeTickIDRange.Torch + id)
      id = id + 1
    end
    TimeTickManager.Me():CreateOnceDelayTick(1000 * id, function(owner, deltaTime)
      QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
    end, self, E_TimeTickIDRange.Torch + id)
  end
end

function RaidPuzzleManager:HideLightAnimation()
  local torchNpcId = 817520
  local actionName = Table_ActionAnime[501].Name
  local npcs = _NSceneNpcProxy.Instance:FindNpcs(torchNpcId)
  if npcs and 0 < #npcs then
    for i = 1, #npcs do
      npcs[i]:Server_PlayActionCmd(actionName, nil, true)
    end
  end
end

function RaidPuzzleManager:InteractTorchObj(npc)
  if not npc or not npc.data then
    return
  end
  if not self.curTorchPuzzleQuest then
    return
  end
  local boxid = npc.data:GetPushableObjID()
  xdlog("当前对象boxid", boxid)
  if not boxid or boxid == 0 then
    return
  end
  npc.assetRole:ChangeColorFromTo(_LuaGeometry.Const_Col_white, _LuaGeometry.Const_Col_whiteClear, 0.5)
  QuestProxy.Instance:notifyQuestState(self.curTorchPuzzleQuest.scope, self.curTorchPuzzleQuest.id, npc.data.id)
  xdlog("申请点燃目标GUID", npc.data.id)
end

function RaidPuzzleManager:RefreshCurRoomElevator()
  if self.isOnElevator then
    return
  end
  local cfgElevator = self:GetRaidConfig("RoomElevator")
  self.curElevatorInfo = cfgElevator and cfgElevator[self.curRoomID]
end

function RaidPuzzleManager:UpdateElevator()
  if not self.curElevatorInfo then
    self.isOnElevator = false
    return
  end
  if self.isOnElevator then
    if ServerTime.CurServerTime() > self.offElevatorTime then
      self:GetOffElevator()
    end
    return
  end
  self:TryGetOnElevator()
end

function RaidPuzzleManager:TryGetOnElevator()
  if self.isOnElevator then
    return
  end
  local myselfPos = _Game.Myself:GetPosition()
  local checkPoints = self.curElevatorInfo.AreaCenters
  if not checkPoints then
    return
  end
  local sqrRange = self.curElevatorInfo.Range and self.curElevatorInfo.Range * self.curElevatorInfo.Range or 1
  local sceneBossAnimeManager = _Game.GameObjectManagers[_Game.GameObjectType.SceneBossAnime]
  for index = 1, #checkPoints do
    if sqrRange > _VectorUtility.DistanceBy2Value_Square(myselfPos[1], myselfPos[3], checkPoints[index][1], checkPoints[index][2]) then
      if self.isInElevatorArea then
        return
      end
      local animator = sceneBossAnimeManager:GetAnimator(self.curElevatorInfo.ObjID)
      if not animator then
        redlog("TryGetOnElevator: Cannot find animator by id: " .. tostring(self.curElevatorInfo.ObjID))
        return
      end
      local pointName = self.curElevatorInfo.AreaPoints[index] or self.curElevatorInfo.AreaPoints[1]
      local objPoint = pointName and _Game.GameObjectUtil:DeepFind(animator.gameObject, pointName)
      if not objPoint then
        LogUtility.Error(string.format("TryGetOnElevator: Cannot find point: %s from id: %s", pointName, self.curElevatorInfo.ObjID))
        return
      end
      local curState = sceneBossAnimeManager:GetCurAnimState(self.curElevatorInfo.ObjID)
      local stateNames = self.curElevatorInfo.AnimStates
      if not stateNames then
        LogUtility.Error("TryGetOnElevator: No Anim States!")
        return
      end
      self.elevatorStartIndex = index
      self.elevatorTargetIndex = index + 1
      local stateList, nextStateName
      for i = 1, #stateNames do
        stateList = stateNames[i]
        for j = 1, #stateList do
          if stateList[j] == curState then
            nextStateName = (stateNames[i + 1] or stateNames[1])[1]
            self.elevatorTargetIndex = index + (i % 2 == 0 and 1 or -1)
            break
          end
        end
        if nextStateName then
          break
        end
      end
      if not sceneBossAnimeManager:PlayAnimation(self.curElevatorInfo.ObjID, nextStateName or stateNames[1][1]) then
        LogUtility.Error("TryGetOnElevator: Play Animation Failed! id: " .. self.curElevatorInfo.ObjID)
        return
      end
      AudioUtility.PlayOneShotAt_Path(AudioMap.Maps.RaidPuzzle_Elevator, myselfPos[1], myselfPos[2], myselfPos[3], AudioSourceType.SCENE)
      if self.elevatorTargetIndex > #checkPoints then
        self.elevatorTargetIndex = 1
      elseif 1 > self.elevatorTargetIndex then
        self.elevatorTargetIndex = #checkPoints
      end
      _Game.InputManager:Interrupt()
      _Game.Myself:SetParent(objPoint.transform, true)
      local partner = _Game.Myself.partner
      if partner ~= nil then
        partner:SetVisible(false, LayerChangeReason.InteractNpc)
      end
      _Game.Myself:Client_NoMove(true)
      _Game.Myself.data:Client_SetProps(MyselfData.ClientProps.DisableRotateInPhotographMode, true)
      FunctionSystem.InterruptMyselfAll()
      _Game.Myself:Client_PlayAction(Asset_Role.ActionName.Idle)
      self.offElevatorTime = ServerTime.CurServerTime() + self.curElevatorInfo.AnimDuration
      self.isOnElevator = true
      self.isInElevatorArea = true
      break
    end
  end
  if not self.isOnElevator then
    self.isInElevatorArea = false
  end
end

function RaidPuzzleManager:GetOffElevator()
  if not self.isOnElevator then
    return
  end
  self.isOnElevator = false
  _Game.Myself:SetParent(nil, true)
  _Game.Myself:Logic_NavMeshPlaceTo(_LuaGeometry.TempGetPosition(_Game.Myself.assetRole.completeTransform))
  local partner = _Game.Myself.partner
  if partner ~= nil then
    partner:SetVisible(true, LayerChangeReason.InteractNpc)
  end
  _Game.Myself:Client_NoMove(false)
  _Game.Myself.data:Client_SetProps(MyselfData.ClientProps.DisableRotateInPhotographMode, false)
  local myselfPos = _Game.Myself:GetPosition()
  local curState = _Game.GameObjectManagers[_Game.GameObjectType.SceneBossAnime]:GetCurAnimState(self.curElevatorInfo.ObjID)
  local stateNames = self.curElevatorInfo.AnimStates
  if stateNames then
    local stateList, found
    for i = 1, #stateNames do
      stateList = stateNames[i]
      for j = 1, #stateList do
        if stateList[j] == curState then
          found = true
          curState = stateList[#stateList]
          break
        end
      end
      if found then
        break
      end
    end
  end
  ServiceRaidCmdProxy.Instance:CallRaidPuzzleElevatorRaidCmd(self.curElevatorInfo.ObjID, curState, self.elevatorStartIndex, self.elevatorTargetIndex, myselfPos[1], myselfPos[3])
  self:RefreshCurRoomElevator()
end

local m_vecLastMyPos = LuaVector3(0, 0, 0)

function RaidPuzzleManager:UpdateNpcMoveQuest(force)
  local myselfPos = _Game.Myself:GetPosition()
  if _VectorUtility.AlmostEqual_3(m_vecLastMyPos, myselfPos) and not force then
    return
  end
  local checkpos, posPassed, singlePos
  local _FindNpc = function(npc)
    local staticID = npc.data and npc.data:GetStaticID()
    return staticID and (staticID == self.npcMoveQuest_npcid or self.npcMoveQuest_npcids and _TableUtility.ArrayFindIndex(self.npcMoveQuest_npcids, staticID) > 0)
  end
  local time = ServerTime.CurServerTime()
  for questID, questData in pairs(self.checkNpcMoveQuestMap) do
    if not self.sendQuestMap[questID] or time - self.sendQuestMap[questID] > m_sendQuestInterval then
      checkpos = questData.params.checkpos
      self.npcMoveQuest_npcid = questData.params.npcid
      self.npcMoveQuest_npcids = questData.params.npcids
      posPassed = true
      for i = 1, #checkpos do
        singlePos = checkpos[i]
        if _VectorUtility.DistanceBy2Value_Square(singlePos[1], singlePos[3], myselfPos[1], myselfPos[3]) >= questData.params.range * questData.params.range and not _NSceneNpcProxy.Instance:FindNpcInRange(_LuaGeometry.GetTempVector3(singlePos[1], myselfPos[2], singlePos[3]), questData.params.range, _FindNpc, true) then
          posPassed = false
          break
        end
      end
      if posPassed then
        if not questData.params.out_check then
          QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
          self.sendQuestMap[questID] = time
        end
      elseif questData.params.out_check then
        QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
        self.sendQuestMap[questID] = time
      end
    end
  end
  LuaVector3.Better_Set(m_vecLastMyPos, myselfPos[1], myselfPos[2], myselfPos[3])
end

function RaidPuzzleManager:IsPositionUnlocked(posX, posZ)
  if not self:IsWorking() then
    return true
  end
  for roomID, roomData in pairs(self.unlockRoomMap) do
    if posX > roomData.MinPosX and posZ > roomData.MinPosZ and posX < roomData.MaxPosX and posZ < roomData.MaxPosZ then
      return true
    end
  end
  return false
end

function RaidPuzzleManager:Update(time, deltaTime)
  if not self.running then
    return
  end
  if time > self.nextUpdateRoomTime then
    self.nextUpdateRoomTime = time + m_updateRoomInterval
    self:UpdateCurrentRoom(time, deltaTime)
  end
  if time > self.nextUpdateLightTime then
    self.nextUpdateLightTime = time + m_updateLightInterval
    self.refreshLightStep = (self.refreshLightStep or -1) + 1
    if self.refreshLightStep < 1 then
      _TableUtility.TableClear(self.refreshLightArray)
      for lightID, _ in pairs(_Game.GameObjectManagers[_Game.GameObjectType.RaidPuzzle_Light]:GetLightObjMap()) do
        self.refreshLightArray[#self.refreshLightArray + 1] = lightID
      end
    elseif self.refreshLightStep > #self.refreshLightArray then
      self.refreshLightStep = -1
    elseif self.refreshLightArray[self.refreshLightStep] then
      local lightID = self.refreshLightArray[self.refreshLightStep]
      if not self.forbidLightMap[lightID] then
        self:RefreshLight(lightID, true)
      end
    end
  end
  if time < self.nextUpdateFunctionTime then
    return
  end
  self.nextUpdateFunctionTime = time + m_updateFunctionInterval
  self.updateFunctionIndex = self.updateFunctionIndex + 1
  if self.updateFunctionIndex > #m_updateFunctionNames then
    self.updateFunctionIndex = 1
  end
  self[m_updateFunctionNames[self.updateFunctionIndex]](self, time, deltaTime)
end
