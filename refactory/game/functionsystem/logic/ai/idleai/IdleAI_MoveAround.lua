IdleAI_MoveAround = class("IdleAI_MoveAround")
local tempV3 = LuaVector3()
local tempV3_1 = LuaVector3()
local Better_MoveTowards = LuaVector3.Better_MoveTowards
local Phase_None = 0
local Phase_Moving = 1
local DefaultDistance = 5
local DefaultAngularSpeed = 45
local StopMoveSpeed = 15
local UpdateInterval = 0.05

function IdleAI_MoveAround:ctor()
  self.targetCreatureID = nil
  self.requestTargetCreatureID = nil
  self.centerPos = nil
  self.requestCenterPos = nil
  self.distance = DefaultDistance
  self.angularSpeed = DefaultAngularSpeed
  self.currentAngle = 0
  self.faceAngleOffset = 0
  self.stopTargetAngle = nil
  self.targetDistance = nil
  self.orbitMoveSpeed = nil
  self.targetAngularSpeed = nil
  self.angularLerpDuration = 0.5
  self.angularLerpElapsed = 0
  self.phase = Phase_None
  self.isActive = false
  self.nextUpdateTime = 0
  self.priority = 2
end

function IdleAI_MoveAround:Request_Set(targetCreatureID, distance, angularSpeed, centerPos, orbitMoveSpeed, moveSpeed, requestAngle)
  self.requestTargetCreatureID = targetCreatureID or 0
  self.requestCenterPos = centerPos
  self.requestAngle = requestAngle
  if distance then
    if self.distance ~= 0 and distance ~= self.distance and orbitMoveSpeed ~= nil and 0 < orbitMoveSpeed then
      self.targetDistance = distance
      self.orbitMoveSpeed = orbitMoveSpeed
    else
      self.distance = distance
      self.targetDistance = nil
      self.orbitMoveSpeed = nil
    end
  end
  if angularSpeed then
    if angularSpeed == 0 then
      self.angularSpeed = 0
      self.targetAngularSpeed = nil
      self.angularLerpElapsed = 0
    else
      self.targetAngularSpeed = angularSpeed
      self.angularLerpElapsed = 0
    end
  end
  self.dirtyFlag = true
end

function IdleAI_MoveAround:Clear(idleElapsed, time, deltaTime, creature)
  self.targetCreatureID = nil
  self.requestTargetCreatureID = nil
  self.centerPos = nil
  self.requestCenterPos = nil
  self.targetDistance = nil
  self.orbitMoveSpeed = nil
  self.targetAngularSpeed = nil
  self.angularLerpElapsed = 0
  self.requestAngle = nil
  self.phase = Phase_None
  self.isActive = false
  self.currentAngle = 0
  self.faceAngleOffset = 0
  self.stopTargetAngle = nil
  self.nextUpdateTime = 0
  self.dirtyFlag = false
end

function IdleAI_MoveAround:Prepare(idleElapsed, time, deltaTime, creature)
  if self.dirtyFlag then
    self.dirtyFlag = false
    self.targetCreatureID = self.requestTargetCreatureID or 0
    self.isActive = self.targetCreatureID > 0
    self.requestTargetCreatureID = nil
    self.centerPos = self.requestCenterPos
    self.requestCenterPos = nil
    if self.isActive or self.centerPos ~= nil then
      local creaturePos = creature:GetPosition()
      local targetPos
      if self.targetCreatureID ~= nil and self.targetCreatureID ~= 0 then
        local targetCreature = SceneCreatureProxy.FindCreature(self.targetCreatureID)
        if targetCreature ~= nil then
          targetPos = targetCreature:GetPosition()
        end
      elseif self.centerPos ~= nil then
        targetPos = self.centerPos
      end
      if self.requestAngle ~= nil then
        if self.angularSpeed == 0 and self.targetAngularSpeed == nil then
          self.stopTargetAngle = self.requestAngle
        else
          self.currentAngle = self.requestAngle
          self.stopTargetAngle = nil
        end
        self.requestAngle = nil
      elseif nil ~= creaturePos and nil ~= targetPos then
        local dx = creaturePos.x - targetPos.x
        local dz = creaturePos.z - targetPos.z
        self.currentAngle = math.deg(math.atan2(dz, dx))
      end
    end
    if not self.isActive and self.centerPos == nil then
      return false
    end
    return true
  end
  return true
end

function IdleAI_MoveAround:Start(idleElapsed, time, deltaTime, creature)
  self.phase = Phase_Moving
  self.nextUpdateTime = time
end

function IdleAI_MoveAround:End(idleElapsed, time, deltaTime, creature)
  if self.phase == Phase_Moving then
    creature:Logic_StopMove()
  end
  self.phase = Phase_None
end

function IdleAI_MoveAround:Update(idleElapsed, time, deltaTime, creature)
  if self.phase == Phase_Moving then
    local target = SceneCreatureProxy.FindCreature(self.targetCreatureID or 0)
    if self.targetDistance ~= nil and self.orbitMoveSpeed ~= nil and 0 < self.orbitMoveSpeed then
      local maxStep = self.orbitMoveSpeed * deltaTime
      local diff = self.targetDistance - self.distance
      if maxStep >= math.abs(diff) then
        self.distance = self.targetDistance
        self.targetDistance = nil
      else
        self.distance = self.distance + (0 < diff and maxStep or -maxStep)
      end
    end
    if self.targetAngularSpeed ~= nil and 0 < self.angularLerpDuration then
      self.angularLerpElapsed = math.min(self.angularLerpElapsed + deltaTime, self.angularLerpDuration)
      local t = self.angularLerpElapsed / self.angularLerpDuration
      self.angularSpeed = self.angularSpeed + (self.targetAngularSpeed - self.angularSpeed) * t
      if self.angularLerpElapsed >= self.angularLerpDuration then
        self.angularSpeed = self.targetAngularSpeed
        self.targetAngularSpeed = nil
        self.angularLerpElapsed = 0
      end
    end
    local creaturePos = creature:GetPosition()
    local targetPos
    local useCenterPos = false
    if target ~= nil then
      targetPos = target:GetPosition()
    elseif self.centerPos ~= nil then
      targetPos = self.centerPos
      useCenterPos = true
    end
    if nil == creaturePos or nil == targetPos then
      return true
    end
    self.currentAngle = self.currentAngle + self.angularSpeed * deltaTime
    if self.currentAngle >= 360 then
      self.currentAngle = self.currentAngle - 360
    elseif 0 > self.currentAngle then
      self.currentAngle = self.currentAngle + 360
    end
    local radian = math.rad(self.currentAngle)
    local targetX = targetPos.x + self.distance * math.sin(radian)
    local targetZ = targetPos.z + self.distance * math.cos(radian)
    LuaVector3.Better_Set(tempV3, targetX, targetPos.y + 0.5, targetZ)
    local tangentAngle = self.currentAngle + (0 <= self.angularSpeed and 90 or -90)
    creature.logicTransform:SetTargetAngleY(tangentAngle + self.faceAngleOffset)
    if self.stopTargetAngle ~= nil and math.abs(self.angularSpeed) < 0.001 then
      local stopRadian = math.rad(self.stopTargetAngle)
      local stopTargetX = targetPos.x + self.distance * math.sin(stopRadian)
      local stopTargetZ = targetPos.z + self.distance * math.cos(stopRadian)
      LuaVector3.Better_Set(tempV3_1, stopTargetX, targetPos.y + 0.5, stopTargetZ)
      Better_MoveTowards(creaturePos, tempV3_1, tempV3, StopMoveSpeed * deltaTime)
      creature.logicTransform:PlaceTo(tempV3)
      if VectorUtility.DistanceXZ_Square(tempV3, tempV3_1) < 0.01 then
        self.currentAngle = self.stopTargetAngle
        self.stopTargetAngle = nil
      end
    else
      creature.logicTransform:PlaceTo(tempV3)
    end
  end
  return true
end

function IdleAI_MoveAround:GetCurrentAngle()
  return self.currentAngle
end

function IdleAI_MoveAround:SetCurrentAngle(angle)
  if angle ~= nil then
    self.currentAngle = angle
  end
end

function IdleAI_MoveAround:SetAngularSpeed(angularSpeed)
  self.angularSpeed = angularSpeed
end

function IdleAI_MoveAround:SetDistance(distance)
  self.distance = distance
end

function IdleAI_MoveAround:SetFaceAngleOffset(angle)
  if angle ~= nil then
    self.faceAngleOffset = angle
  end
end

function IdleAI_MoveAround:IsRotating()
  return false
end

function IdleAI_MoveAround:IsMovingToOrbit()
  return self.isActive and self.phase == Phase_Moving
end
