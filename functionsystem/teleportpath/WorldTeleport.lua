WorldTeleport = class("WorldTeleport")
autoImport("TransferTeleport")
local TransferTeleport = TransferTeleport
autoImport("MapTeleportUtil")
local MapTeleportUtil = MapTeleportUtil
local checkEPValid = function(ep_type)
  if not ep_type or ep_type == 0 then
    return true
  end
  if Game.MapManager:IsPVPMode_GVGDetailed() and ep_type == 1 then
    return GvgProxy.Instance:IsDefSide()
  end
  return true
end
WorldTeleport.DESTINATION_VALID_RANGE = 5
local PositionLockedCountLimit = 60
local tempBPArray = {}
local tempVector3 = LuaVector3.Zero()

function WorldTeleport.GetTransitNPCInfo(sourceMapID, targetMapID)
  if nil == MapOutterTeleport then
    errorLog("MapOutterTeleport is nil")
    return nil
  end
  if nil == MapOutterTeleport[sourceMapID] then
    return nil
  end
  if nil == MapOutterTeleport[sourceMapID][targetMapID] then
    return nil
  end
  local outterInfo = MapOutterTeleport[sourceMapID][targetMapID]
  return outterInfo.transitNPC, outterInfo.transitMap, outterInfo.transitNPCToMap
end

function WorldTeleport.CanArriveMap(sourceMapID, targetMapID)
  if sourceMapID == targetMapID then
    return true
  end
  if nil == MapOutterTeleport then
    errorLog("MapOutterTeleport is nil")
    return false
  end
  if nil == MapOutterTeleport[sourceMapID] then
    return false
  end
  if nil == MapOutterTeleport[sourceMapID][targetMapID] then
    return false
  end
  return true
end

function WorldTeleport.CreateInnerTeleportInfo(sourcePos, targetPos)
  local currentMapID = Game.MapManager:GetMapID()
  if NavMeshUtils.CanArrived(sourcePos, targetPos, WorldTeleport.DESTINATION_VALID_RANGE, true, nil) then
    local innerTeleportInfo = ReusableTable.CreateInnerTeleportInfo()
    innerTeleportInfo.mapID = currentMapID
    if nil ~= targetPos then
      innerTeleportInfo.targetPos = targetPos:Clone()
    end
    return innerTeleportInfo
  end
  if nil == MapInnerTeleport[currentMapID] then
    return nil
  end
  if nil == MapInnerTeleport[currentMapID].inner then
    return nil
  end
  local exitPointMap = Game.MapManager:GetExitPointMap()
  if nil == exitPointMap then
    return nil
  end
  local bps = Game.MapManager:GetBornPointArray()
  if nil == bps or #bps <= 0 then
    return nil
  end
  local endBPs = tempBPArray
  for i = 1, #bps do
    local bp = bps[i]
    local canArrive = false
    local path
    canArrive, path = NavMeshUtils.CanArrived(bp.position, targetPos, WorldTeleport.DESTINATION_VALID_RANGE, true, nil)
    if canArrive then
      table.insert(endBPs, {
        bornPoint = bp,
        cost = NavMeshUtils.GetPathDistance(path)
      })
    end
  end
  if 0 == #endBPs then
    return nil
  end
  local startEP, nextEP, endBP
  local minCost = 9999999999
  for k, v in pairs(MapInnerTeleport[currentMapID].inner) do
    for i = 1, #endBPs do
      local bpInfo = endBPs[i]
      if nil ~= v[bpInfo.bornPoint.ID] then
        local ep = exitPointMap[k]
        local canArrive = false
        local path
        if ep and checkEPValid(ep.exitType) then
          canArrive, path = NavMeshUtils.CanArrived(sourcePos, ep.position, WorldTeleport.DESTINATION_VALID_RANGE, true, nil)
          if canArrive then
            local cost = NavMeshUtils.GetPathDistance(path) + v[bpInfo.bornPoint.ID].totalCost + bpInfo.cost
            if minCost > cost then
              minCost = cost
              startEP = ep
              endBP = bpInfo.bornPoint
              local nextEPID = v[bpInfo.bornPoint.ID].nextEP
              if nil ~= nextEPID then
                nextEP = exitPointMap[nextEPID]
              else
                nextEP = nil
              end
            end
          end
        end
      end
    end
  end
  TableUtility.ArrayClear(endBPs)
  if nil == startEP then
    return nil
  end
  local innerTeleportInfo = ReusableTable.CreateInnerTeleportInfo()
  innerTeleportInfo.mapID = currentMapID
  if nil ~= targetPos then
    innerTeleportInfo.targetPos = targetPos:Clone()
  end
  innerTeleportInfo.ep = startEP
  innerTeleportInfo.nextEP = nextEP
  innerTeleportInfo.targetBPID = endBP.ID
  return innerTeleportInfo
end

function WorldTeleport.DestroyInnerTeleportInfo(info)
  ReusableTable.DestroyInnerTeleportInfo(info)
end

function WorldTeleport.CreateOutterTeleportInfo(sourcePos, targetMapID, targetBPID, targetPos)
  local currentMapID = Game.MapManager:GetMapID()
  if nil == MapOutterTeleport[currentMapID] then
    LogUtility.InfoFormat("<color=red>WorldTeleport.CreateOutterTeleportInfo failed: </color>MapOutterTeleport[{0}] is nil", LogUtility.ToString(currentMapID))
    return nil
  end
  if nil == MapOutterTeleport[currentMapID][targetMapID] then
    LogUtility.InfoFormat("<color=red>WorldTeleport.CreateOutterTeleportInfo failed: </color>MapOutterTeleport[{0}][{1}] is nil", LogUtility.ToString(currentMapID), LogUtility.ToString(targetMapID))
    return nil
  end
  local outterInfo, outterInfoEPID, outterInfoBPID = MapTeleportUtil.GetMinCostOutterInfo(currentMapID, targetMapID, targetBPID)
  local outterTeleportInfo, innerTeleportInfo
  local exitPointMap = Game.MapManager:GetExitPointMap()
  if outterInfo and exitPointMap then
    local outterEP = exitPointMap[outterInfoEPID]
    if outterEP then
      local p = outterEP.position
      LuaVector3.Better_Set(tempVector3, p[1], p[2], p[3])
      if not innerTeleportInfo then
        innerTeleportInfo = WorldTeleport.CreateInnerTeleportInfo(sourcePos, tempVector3)
      else
        innerTeleportInfo.ep = outterEP
      end
      outterTeleportInfo = ReusableTable.CreateOutterTeleportInfo()
      outterTeleportInfo.targetMapID = targetMapID
      outterTeleportInfo.mapID = currentMapID
      outterTeleportInfo.epID = outterEP.ID
      outterTeleportInfo.nextMapID = outterEP.nextSceneID
      outterTeleportInfo.nextBPID = outterEP.nextSceneBornPointID
      outterTeleportInfo.nextEPID = outterInfo.nextEP
    end
  end
  local npcUID, npcMapID, npcToMapID = WorldTeleport.GetTransitNPCInfo(currentMapID, targetMapID)
  if npcUID then
    outterTeleportInfo = outterTeleportInfo or ReusableTable.CreateOutterTeleportInfo()
    outterTeleportInfo.targetMapID = targetMapID
    outterTeleportInfo.transfer_npcUID = npcUID
    outterTeleportInfo.transfer_npcMapID = npcMapID
    outterTeleportInfo.transfer_npcToMapID = npcToMapID
    if currentMapID == npcMapID then
      local npcPointMap = Game.MapManager:GetNPCPointMap()
      if npcPointMap then
        local p = npcPointMap[npcUID] and npcPointMap[npcUID].position
        if p then
          local targetPos = LuaVector3.New(p[1], p[2], p[3])
          if not innerTeleportInfo then
            innerTeleportInfo = WorldTeleport.CreateInnerTeleportInfo(sourcePos, targetPos)
            if innerTeleportInfo == nil then
              redlog("寻路失败，当前地图传送npc无法寻路过去.", npcMapID, npcUID)
              return outterTeleportInfo, innerTeleportInfo
            end
          else
            innerTeleportInfo.targetPos = targetPos
          end
          innerTeleportInfo.transfer_npcUID = npcUID
          innerTeleportInfo.transfer_npcToMapID = npcToMapID
          innerTeleportInfo.access_range = Table_Npc[npcUID] and Table_Npc[npcUID].AccessRange or 2
        end
      end
    else
      local _, npcOutterEP, npcOutterBp = MapTeleportUtil.GetMinCostOutterInfo(currentMapID, npcMapID, targetBPID)
      if exitPointMap and exitPointMap[npcOutterEP] then
        local p = exitPointMap[npcOutterEP].position
        local targetPos = LuaVector3.New(p[1], p[2], p[3])
        innerTeleportInfo = innerTeleportInfo or WorldTeleport.CreateInnerTeleportInfo(sourcePos, targetPos)
        if innerTeleportInfo then
          innerTeleportInfo.ep = exitPointMap[npcOutterEP]
        end
      end
    end
  end
  if outterTeleportInfo then
    if nil ~= targetPos then
      outterTeleportInfo.targetPos = targetPos:Clone()
    end
    outterTeleportInfo.targetBPID = outterInfoBPID
  end
  return outterTeleportInfo, innerTeleportInfo
end

function WorldTeleport.DestroyOutterTeleportInfo(info)
  ReusableTable.DestroyOutterTeleportInfo(info)
end

function WorldTeleport:ctor()
  self:Reset()
end

function WorldTeleport:Reset()
  self.pausing = false
  self.running = false
  if nil ~= self.innerTeleportInfo then
    local innerTargetPos = self.innerTeleportInfo.ep and self.innerTeleportInfo.epTargetPos or self.innerTeleportInfo.targetPos
    if nil ~= innerTargetPos then
      LuaVector3.Better_Set(tempVector3, innerTargetPos[1], innerTargetPos[2], innerTargetPos[3])
      if nil ~= Game.Myself.logicTransform.targetPosition and LuaVector3.Equal(innerTargetPos, Game.Myself.logicTransform.targetPosition) then
        Game.Myself:Logic_StopMove()
        Game.Myself:Logic_PlayAction_Idle()
      end
    end
    WorldTeleport.DestroyInnerTeleportInfo(self.innerTeleportInfo)
    self.innerTeleportInfo = nil
  end
  if nil ~= self.outterTeleportInfo then
    WorldTeleport.DestroyOutterTeleportInfo(self.outterTeleportInfo)
    self.outterTeleportInfo = nil
  end
  self.targetMapID = 0
  self.targetBPID = 0
  if nil ~= self.targetPos then
    self.targetPos:Destroy()
    self.targetPos = nil
  end
  self.innerMoving = false
  if self.clickGroundDisplaying then
    self.clickGroundDisplaying = false
    Game.ClickGroundEffectManager:HideEffect()
  end
  self.showClickGround = false
  if nil ~= self.prevPosition then
    self.prevPosition:Destroy()
    self.prevPosition = nil
  end
  self.positionLockedCount = 0
end

function WorldTeleport:ResetPath()
  if nil ~= self.innerTeleportInfo then
    WorldTeleport.DestroyInnerTeleportInfo(self.innerTeleportInfo)
    self.innerTeleportInfo = nil
  end
  if nil ~= self.outterTeleportInfo then
    WorldTeleport.DestroyOutterTeleportInfo(self.outterTeleportInfo)
    self.outterTeleportInfo = nil
  end
  Game.Myself:Logic_SamplePosition()
  local myPosition = Game.Myself:GetPosition()
  local currentMapID = Game.MapManager:GetMapID()
  if currentMapID == self.targetMapID then
    if nil ~= self.targetPos then
      self.innerTeleportInfo = WorldTeleport.CreateInnerTeleportInfo(myPosition, self.targetPos)
      if nil == self.innerTeleportInfo then
        return false
      end
    else
      return false
    end
  else
    local outterTeleportInfo, innerTeleportInfo = WorldTeleport.CreateOutterTeleportInfo(myPosition, self.targetMapID, self.targetBPID, self.targetPos)
    redlog("<color=green>WorldTeleport:ResetPath</color> outter", outterTeleportInfo, innerTeleportInfo)
    if nil == outterTeleportInfo or nil == innerTeleportInfo then
      return false
    end
    self.outterTeleportInfo = outterTeleportInfo
    self.innerTeleportInfo = innerTeleportInfo
  end
  return true
end

function WorldTeleport:ResetTarget(targetMapID, targetBPID, targetPos, showClickGround)
  self.targetMapID = targetMapID
  self.targetBPID = targetBPID
  if nil ~= targetPos then
    self.targetPos = VectorUtility.Asign_3(self.targetPos, targetPos)
  elseif nil ~= self.targetPos then
    self.targetPos:Destroy()
    self.targetPos = nil
  end
  self.showClickGround = showClickGround or false
  if self:ResetPath() then
    self:InnerTeleportMove()
    return true
  else
    return false
  end
end

function WorldTeleport:Launch(targetMapID, targetBPID, targetPos, showClickGround, allowExitPoint, customMoveAction)
  if self.running then
    self:Shutdown()
  end
  self.realTargetMapID = targetMapID
  self.running = self:TryTransferToDestination(targetMapID, targetBPID, targetPos, showClickGround)
  if self.running then
    if not allowExitPoint then
      self.exitPointDisabled = true
      Game.AreaTrigger_ExitPoint:SetDisable(true)
    end
    local eventManager = EventManager.Me()
    eventManager:AddEventListener(MyselfEvent.PlaceTo, self.OnMyselfPlaceTo, self)
    eventManager:AddEventListener(MyselfEvent.LeaveScene, self.OnMyselfLeaveScene, self)
    self.customMoveAction = customMoveAction
  end
  return self.running
end

function WorldTeleport:Update()
  if not self.running then
    return
  end
  if self.pausing then
    return
  end
  self:OutterTeleportUpdate()
  local positionLocked = self:InnerTeleportUpdate()
  self:TransferTeleportUpdate()
  if positionLocked or self:OutterArrived() and self:InnerArrived() then
    self.positionLockedCount = 0
    self:Shutdown()
  end
end

function WorldTeleport:Shutdown()
  if not self.running then
    return
  end
  Game.AreaTrigger_ExitPoint:ClearOnlyEP()
  if self.exitPointDisabled then
    self.exitPointDisabled = false
    Game.AreaTrigger_ExitPoint:SetDisable(false)
  end
  self:Reset()
  local eventManager = EventManager.Me()
  eventManager:RemoveEventListener(MyselfEvent.PlaceTo, self.OnMyselfPlaceTo, self)
  eventManager:RemoveEventListener(MyselfEvent.LeaveScene, self.OnMyselfLeaveScene, self)
end

function WorldTeleport:Pause()
  if self.pausing then
    return
  end
  self.pausing = true
end

function WorldTeleport:Resume()
  if not self.pausing then
    return
  end
  self.pausing = false
  if self.running then
    if nil ~= self.outterTeleportInfo then
      local currentMapID = Game.MapManager:GetMapID()
      if currentMapID ~= self.outterTeleportInfo.mapID then
        self:ResetPath()
        return
      end
    end
    if nil == self.innerTeleportInfo then
      self:ResetPath()
    else
      local currentMapID = Game.MapManager:GetMapID()
      if currentMapID ~= self.targetMapID then
        self:ResetPath()
      end
    end
    if nil ~= self.innerTeleportInfo then
      self:InnerTeleportMove()
    end
  end
end

function WorldTeleport:OutterArrived()
  return Game.MapManager:GetMapID() == self.realTargetMapID
end

function WorldTeleport:OutterTeleportUpdate()
  local currentMapID = Game.MapManager:GetMapID()
  if nil == self.outterTeleportInfo then
    if currentMapID ~= self.targetMapID then
      Game.Myself:Logic_PlayAction_Idle()
      self:ResetPath()
    end
    return
  end
  local outterTeleportInfo = self.outterTeleportInfo
  local targetMapID = outterTeleportInfo.targetMapID
  if currentMapID == targetMapID then
    self:ResetPath()
  elseif currentMapID == outterTeleportInfo.nextMapID then
    local bpID = outterTeleportInfo.nextBPID
    local epID = outterTeleportInfo.nextEPID
    local targetBPID = outterTeleportInfo.targetBPID
    local outterInfo = MapOutterTeleport[currentMapID][targetMapID][epID][targetBPID]
    local exitPointMap = Game.MapManager:GetExitPointMap()
    local ep = exitPointMap[epID]
    outterTeleportInfo.mapID = currentMapID
    outterTeleportInfo.nextMapID = ep.nextSceneID
    outterTeleportInfo.nextBPID = ep.nextSceneBornPointID
    outterTeleportInfo.nextEPID = outterInfo.nextEP
    local innerTeleportInfo = ReusableTable.CreateInnerTeleportInfo()
    local p = ep.position
    innerTeleportInfo.targetPos = LuaVector3.New(p[1], p[2], p[3])
    local innerOutterInfo = MapInnerTeleport[currentMapID].outter[bpID][epID]
    if nil ~= innerOutterInfo.startEP then
      local innerInnerInfo = MapInnerTeleport[currentMapID].inner[innerOutterInfo.startEP][innerOutterInfo.endBP]
      local startEP = exitPointMap[innerOutterInfo.startEP]
      local nextEP = exitPointMap[innerInnerInfo.nextEP]
      innerTeleportInfo.ep = startEP
      innerTeleportInfo.nextEP = nextEP
      innerTeleportInfo.targetBPID = innerOutterInfo.endBP
    end
    if nil ~= self.innerTeleportInfo then
      WorldTeleport.DestroyInnerTeleportInfo(self.innerTeleportInfo)
    end
    self.innerTeleportInfo = innerTeleportInfo
    self:InnerTeleportMove()
  elseif currentMapID == self.outterTeleportInfo.mapID then
  elseif outterTeleportInfo.transfer_npcUID then
    if currentMapID == outterTeleportInfo.transfer_npcMapID then
      local innerTeleportInfo = self.innerTeleportInfo
      if not innerTeleportInfo then
        innerTeleportInfo = ReusableTable.CreateInnerTeleportInfo()
        self.innerTeleportInfo = innerTeleportInfo
      end
      if not innerTeleportInfo.transfer_npcUID then
        local npcPointMap = Game.MapManager:GetNPCPointMap()
        if npcPointMap then
          local np = npcPointMap[outterTeleportInfo.transfer_npcUID] and npcPointMap[outterTeleportInfo.transfer_npcUID].position
          if np then
            innerTeleportInfo.transfer_npcUID = outterTeleportInfo.transfer_npcUID
            innerTeleportInfo.transfer_npcToMapID = outterTeleportInfo.npcToMapID
            innerTeleportInfo.targetPos = LuaVector3.New(np[1], np[2], np[3])
            outterTeleportInfo.transfer_npcUID = nil
            outterTeleportInfo.transfer_npcMapID = nil
            outterTeleportInfo.transfer_npcToMapID = nil
            self:InnerTeleportMove()
          end
        end
      end
    end
  else
    Game.Myself:Logic_PlayAction_Idle()
    self:ResetPath()
  end
end

function WorldTeleport:InnerArrived()
  if nil == self.innerTeleportInfo then
    return true
  end
  if Game.MapManager:GetMapID() ~= self.innerTeleportInfo.mapID then
    return true
  end
  local squareDistance = VectorUtility.DistanceXZ_Square(Game.Myself:GetPosition(), self.innerTeleportInfo.targetPos)
  local accessRange = self.innerTeleportInfo.access_range or 0.01
  if squareDistance < accessRange then
    if nil ~= self.innerTeleportInfo.nextEP then
      return false
    end
    if nil ~= self.innerTeleportInfo.ep and nil ~= self.targetPos then
      return false
    end
    if self.targetPos and self.targetMapID == Game.MapManager:GetMapID() and not VectorUtility.AlmostEqual_3_XZ(self.innerTeleportInfo.targetPos, self.targetPos) then
      self:ResetPath()
      return false
    end
    return true
  end
  return false
end

local transferCdCheck = {}
local TransferCdCheck = function(mapid)
  if not mapid then
    return false
  end
  if not transferCdCheck[mapid] then
    transferCdCheck[mapid] = UnityFrameCount
    return true
  end
  if UnityFrameCount - transferCdCheck[mapid] < 20 then
    return false
  end
  transferCdCheck[mapid] = UnityFrameCount
  return true
end

function WorldTeleport:InnerTeleportUpdate()
  if nil == self.innerTeleportInfo then
    return false
  end
  if not Game.Myself:IsMoving() then
    if self:InnerArrived() then
      if self.innerTeleportInfo.transfer_npcUID and TransferCdCheck(self.innerTeleportInfo.transfer_npcToMapID) then
        FunctionVisitNpc.Me():HandleNpcTransfer(self.innerTeleportInfo.transfer_npcToMapID, self.innerTeleportInfo.transfer_npcUID)
      end
      WorldTeleport.DestroyInnerTeleportInfo(self.innerTeleportInfo)
      self.innerTeleportInfo = nil
      if self.innerMoving then
        Game.Myself:Logic_PlayAction_Idle()
        self.innerMoving = false
      end
      return
    end
    self:InnerTeleportMove()
  else
    Game.Myself:Logic_SamplePosition(time)
    local newPosition = Game.Myself:GetPosition()
    if nil ~= self.prevPosition and LuaVector3.Equal(self.prevPosition, newPosition) then
      self.positionLockedCount = self.positionLockedCount + 1
      if PositionLockedCountLimit < self.positionLockedCount then
        return true
      end
    else
      self.prevPosition = VectorUtility.Asign_3(self.prevPosition, newPosition)
      self.positionLockedCount = 0
    end
  end
  return false
end

function WorldTeleport:InnerTeleportMove()
  if self.pausing then
    return
  end
  local innerTeleportInfo = self.innerTeleportInfo
  if nil ~= innerTeleportInfo then
    if self.showClickGround then
      self.clickGroundDisplaying = true
      if nil == self.outterTeleportInfo and nil ~= self.targetPos then
        Game.ClickGroundEffectManager:SetPos(self.targetPos)
      else
        Game.ClickGroundEffectManager:SetPos(innerTeleportInfo.targetPos)
      end
    end
    Game.Myself:Logic_PlayAction_Move(self.customMoveAction)
    if nil ~= innerTeleportInfo.ep then
      local epPos = innerTeleportInfo.ep.position
      Game.AreaTrigger_ExitPoint:SetOnlyEP(innerTeleportInfo.ep.ID)
      Game.Myself:Logic_NavMeshMoveTo(epPos)
      local targetPosition = Game.Myself.logicTransform.targetPosition
      if nil ~= targetPosition then
        innerTeleportInfo.epTargetPos = VectorUtility.Asign_3(innerTeleportInfo.epTargetPos, targetPosition)
      end
    else
      if nil ~= self.outterTeleportInfo and self.outterTeleportInfo.epID then
        Game.AreaTrigger_ExitPoint:SetOnlyEP(self.outterTeleportInfo.epID)
      else
        Game.AreaTrigger_ExitPoint:ClearOnlyEP()
      end
      Game.Myself:Logic_NavMeshMoveTo(innerTeleportInfo.targetPos)
      local targetPosition = Game.Myself.logicTransform.targetPosition
      if nil ~= targetPosition then
        innerTeleportInfo.targetPos = VectorUtility.Asign_3(innerTeleportInfo.targetPos, targetPosition)
      end
    end
    self.innerMoving = true
  end
end

function WorldTeleport:InnerTeleportSwitch()
  local innerTeleportInfo = self.innerTeleportInfo
  innerTeleportInfo.ep = innerTeleportInfo.nextEP
  innerTeleportInfo.nextEP = nil
  if nil ~= innerTeleportInfo.ep then
    local currentMapID = Game.MapManager:GetMapID()
    local innerInnerInfo = MapInnerTeleport[currentMapID].inner[innerTeleportInfo.ep.ID][innerTeleportInfo.targetBPID]
    if nil ~= innerInnerInfo.nextEP then
      innerTeleportInfo.nextEP = Game.MapManager:GetExitPointMap()[innerInnerInfo.nextEP]
    end
  elseif nil == self.outterTeleportInfo then
    if nil ~= self.targetPos then
      innerTeleportInfo.targetPos = VectorUtility.Asign_3(innerTeleportInfo.targetPos, self.targetPos)
    else
      innerTeleportInfo.targetPos = VectorUtility.Asign_3(innerTeleportInfo.targetPos, Game.Myself:GetPosition())
      return
    end
  end
  self:InnerTeleportMove()
end

function WorldTeleport:OnMyselfPlaceTo(event)
  if not event.data then
    return
  end
  local innerTeleportInfo = self.innerTeleportInfo
  if nil == innerTeleportInfo then
    return
  end
  if Game.MapManager:GetMapID() ~= innerTeleportInfo.mapID then
    if nil == self.outterTeleportInfo then
      self:Shutdown()
    end
    return
  end
  self:InnerTeleportSwitch()
end

function WorldTeleport:OnMyselfLeaveScene(event)
  LogUtility.Info("<color=yellow>OnMyselfLeaveScene</color>")
  local innerTeleportInfo = self.innerTeleportInfo
  if nil == innerTeleportInfo then
    return
  end
  WorldTeleport.DestroyInnerTeleportInfo(self.innerTeleportInfo)
  self.innerTeleportInfo = nil
  if self.innerMoving then
    Game.Myself:Logic_PlayAction_Idle()
    self.innerMoving = false
  end
  if nil == self.outterTeleportInfo then
    self:Shutdown()
  end
end

function WorldTeleport:TransferTeleportUpdate()
  if not self.targetTransferMapID then
    return
  end
  local accessRange = self.innerTeleportInfo and self.innerTeleportInfo.access_range or 1
  if self.transferPos and accessRange > LuaVector3.Distance(self.transferPos, Game.Myself:GetPosition()) then
    local npcs = NSceneNpcProxy.Instance:FindNpcByUniqueId(self.targetNpcUID)
    if npcs and 0 < #npcs then
      redlog("WorldTeleport CallVisitNpcUserCmd", npcs[1].data.id)
      ServiceQuestProxy.Instance:CallVisitNpcUserCmd(npcs[1].data.id)
    end
    redlog("WorldTeleport CallGoToGearUserCmd", self.targetTransferMapID, self.targetNpcUID)
    ServiceNUserProxy.Instance:CallGoToGearUserCmd(self.targetTransferMapID, SceneUser2_pb.EGoToGearType_Single, nil, true)
    self.targetTransferMapID = nil
  end
end

local GetTransferToInfo = function(targetMapID)
  local ret = TransferTeleport[targetMapID] and TransferTeleport[targetMapID][3]
  if ret and MapTeleportUtil.CanTargetTransferTo(targetMapID) then
    return ret
  end
  return nil
end
local GetNowInnerDistance = function(srcPos, dstPos)
  local canArrive, path = NavMeshUtils.CanArrived(srcPos, dstPos, WorldTeleport.DESTINATION_VALID_RANGE, true, nil)
  if canArrive then
    return true, NavMeshUtils.GetPathDistance(path)
  end
  return false
end

function WorldTeleport.TryGetTransferMapInfo(srcID, dstID)
  local transferCost = 0
  local myPosition = Game.Myself:GetPosition()
  local transferID2
  local transferInfo2 = GetTransferToInfo(dstID)
  if transferInfo2 then
    transferID2 = dstID
    transferCost = transferCost + 0
  else
    local transferCost2
    transferID2, transferCost2 = MapTeleportUtil.FindNearlyMap(dstID, function(nSID)
      return GetTransferToInfo(nSID) ~= nil
    end)
    local transferInnerCost = 0
    if transferID2 ~= dstID then
      transferInnerCost = MapTeleportUtil.GetInnerMinCost(transferID2, dstID) or 0
    end
    transferCost = transferCost + transferCost2 + MapTeleportUtil.EstimateNpcTransCost + transferInnerCost
  end
  if transferID2 == srcID then
    return nil
  end
  local transferID1, transferPos, targetNpcUID
  local transferInfo1 = TransferTeleport[srcID] and TransferTeleport[srcID][1]
  if transferInfo1 then
    transferID1 = srcID
    local minCost = math.huge
    for _, posInfo in pairs(transferInfo1) do
      local canArrive, cost = GetNowInnerDistance(myPosition, posInfo[1])
      if canArrive and minCost > cost then
        minCost = cost
        transferPos = posInfo[1]
        targetNpcUID = posInfo[2]
      end
    end
    if transferPos == nil then
      transferPos = transferInfo1[1][1]
      targetNpcUID = transferInfo1[1][2]
      minCost = 100
    end
    transferCost = transferCost + minCost
  else
    local transferCost1
    transferID1, transferCost1 = MapTeleportUtil.FindNearlyMap(srcID, function(nSID)
      return TransferTeleport[nSID] and TransferTeleport[nSID][1] ~= nil
    end)
    transferCost = transferCost + transferCost1 + MapTeleportUtil.EstimateNpcTransCost + MapTeleportUtil.GetTransferInnerCost(srcID, transferID1)
  end
  local walkCost, walkEp = MapTeleportUtil.GetMinCost(srcID, dstID)
  local sceneInfo = Game.MapManager:GetSceneInfo()
  if sceneInfo and sceneInfo.eps then
    for _, ep in pairs(sceneInfo.eps) do
      if ep.ID == walkEp then
        local canArrive, cost = GetNowInnerDistance(myPosition, ep.position)
        if canArrive then
          walkCost = walkCost + cost
        end
        break
      end
    end
  end
  redlog("WalkCost", walkCost, transferCost)
  if walkCost ~= 0 and transferCost >= walkCost then
    return nil
  end
  return transferID1, transferID2, transferPos, targetNpcUID
end

local transferPosV3 = LuaVector3.New()

function WorldTeleport:TryTransferToDestination(targetMapID, targetBPID, targetPos, showClickGround)
  self.targetTransferMapID = nil
  local nowMapID = Game.MapManager:GetMapID()
  if targetMapID == nowMapID then
    return self:ResetTarget(targetMapID, targetBPID, targetPos, showClickGround)
  end
  if not MapOutterTeleport[nowMapID] then
    return self:ResetTarget(targetMapID, targetBPID, targetPos, showClickGround)
  end
  local transferID1, transferID2, transferPos, targetNpcUID = WorldTeleport.TryGetTransferMapInfo(nowMapID, targetMapID)
  self.targetTransferMapID = transferID2
  if transferPos then
    LuaVector3.Better_Set(transferPosV3, transferPos[1], transferPos[2], transferPos[3])
    self.transferPos = transferPosV3
  else
    self.transferPos = nil
  end
  self.targetNpcUID = targetNpcUID
  if transferID1 and transferID2 then
    redlog("Transfer:", transferID1, transferID2)
    return self:ResetTarget(transferID1, targetBPID, self.transferPos, false)
  end
  return self:ResetTarget(targetMapID, targetBPID, targetPos, showClickGround)
end
