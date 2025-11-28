autoImport("HomeManager")
IdleAI_Patrol = class("IdleAI_Patrol")
IdleAI_Patrol.PatrolType = {
  Random = 1,
  Furniture = 2,
  Point = 3,
  Follow = 4,
  Stay = 5
}
local OnPatrolStepStart = {}
local OnPatrolStepUpdate = {}
local OnPatrolStepEnd = {}
local OnVisitNpcEnd = {}
local OnStop = {}
local InnerRange = 0.25
local OutterRange = 3

function IdleAI_Patrol:ctor(loop, patrolDatas, followData)
  self.priority = 19
  self.enable = true
  self.patrolLoop = loop
  self.patrolIndex = 1
  if patrolDatas == nil then
    self.patrolList = nil
  else
    self.furniture = nil
    self.interact = nil
    self.patrolIndex = 1
    self.patrolList = {}
    for i, v in ipairs(patrolDatas) do
      local data = {isEnd = false, currentTimes = 0}
      for k, j in pairs(v) do
        if k == "toPoint" or k == "fromPoint" then
          data[k] = LuaVector3(j[1], j[2], j[3])
        else
          data[k] = j
        end
      end
      if data.jumpTo ~= nil then
        data.currentJumpCount = 0
      end
      self.patrolList[i] = data
    end
  end
  self.follow = followData ~= nil and 0 < #followData
  self.followStep = 0
  if self.follow then
    self.patrolFollow = {isEnd = false}
    for k, v in pairs(followData[1]) do
      self.patrolFollow[k] = v
    end
  end
  self.prePosition = LuaVector3(0, 0, 0)
  self.stayDuration = 0
end

function IdleAI_Patrol:Prepare(idleElapsed, time, deltaTime, creature)
  return self.patrolList ~= nil or self.follow
end

function IdleAI_Patrol:Start(idleElapsed, time, deltaTime, creature)
  if self.patrolList ~= nil then
    local currentData = self.patrolList[self.patrolIndex]
    if currentData ~= nil then
      OnPatrolStepStart[currentData.patrolType](self, currentData, creature)
    end
  end
end

function IdleAI_Patrol:End(idleElapsed, time, deltaTime, creature)
  self.enable = false
end

function IdleAI_Patrol:Update(idleElapsed, time, deltaTime, creature)
  if self.enable then
    if self:CheckFollow(creature) and self.follow then
      self.follow = false
      if self.patrolList == nil then
        self.patrolList = {
          self.patrolFollow
        }
      else
        table.insert(self.patrolList, self.patrolIndex, self.patrolFollow)
      end
      self:Start(idleElapsed, time, deltaTime, creature)
    else
      local currentData = self.patrolList[self.patrolIndex]
      OnPatrolStepUpdate[currentData.patrolType](self, deltaTime, currentData, creature)
      if currentData.isEnd then
        OnPatrolStepEnd[currentData.patrolType](self, currentData, creature)
        self:Start(idleElapsed, time, deltaTime, creature)
      end
    end
  end
  return true
end

function IdleAI_Patrol:Clear(idleElapsed, time, deltaTime, creature)
end

function IdleAI_Patrol:_Follow(creature)
  if 2 == self.followStep then
    return
  end
  self.followStep = 2
  if self.patrolFollow.walkAnimName == nil then
    creature:Logic_PlayAction_Move()
  else
    creature:Logic_PlayAction_Simple(self.patrolFollow.walkAnimName)
  end
end

function IdleAI_Patrol:_Idle(creature)
  if 1 == self.followStep then
    return
  end
  self.followStep = 1
  self:_StopMove(creature)
end

function IdleAI_Patrol:_MoveTo(p, creature, patrolData)
  if not creature.logicTransform:NavMeshMoveTo(p) then
    creature.logicTransform:MoveTo(p)
  end
  self.targetPosition = VectorUtility.Asign_3(creature.logicTransform.targetPosition, p)
  if patrolData == nil then
    patrolData = self.patrolList[self.patrolIndex]
  end
  if patrolData.walkAnimName == nil then
    creature:Logic_PlayAction_Move()
  else
    creature:Logic_PlayAction_Simple(patrolData.walkAnimName)
  end
end

function IdleAI_Patrol:_StopMove(creature)
  creature:Logic_StopMove()
  creature:Logic_PlayAction_Idle()
end

function IdleAI_Patrol:HandlePatrolDataOnStepEnd(patrolData)
  if patrolData.jumpTo ~= nil then
    patrolData.currentJumpCount = patrolData.currentJumpCount + 1
    if patrolData.currentJumpCount <= patrolData.jumpCount then
      self.patrolIndex = patrolData.jumpTo
      return
    end
  end
  self.patrolIndex = self.patrolIndex + 1
  if self.patrolIndex > #self.patrolList then
    if self.patrolLoop then
      self.patrolIndex = 1
      self:ResetPatrolData()
    else
      self.patrolList = nil
    end
  end
end

function IdleAI_Patrol:ResetPatrolData()
  for _, v in ipairs(self.patrolList) do
    if v.jumpTo ~= nil then
      v.currentJumpCount = 0
    end
  end
end

function IdleAI_Patrol:SetEnable(enable, creature)
  self.enable = enable
  if enable then
    local patrolData = self.patrolList[self.patrolIndex]
    OnVisitNpcEnd[patrolData.patrolType](self, patrolData, creature)
  elseif self.interact == nil then
    self:_StopMove(creature)
  end
end

function IdleAI_Patrol:StopPatrol(creature)
  self.enable = false
  if self.patrolList ~= nil then
    local patrolData = self.patrolList[self.patrolIndex]
    OnStop[patrolData.patrolType](self, patrolData, creature)
  end
end

function IdleAI_Patrol:ResumePatrol(creature)
  self.enable = true
  self:Start(nil, nil, nil, creature)
end

function IdleAI_Patrol:PlayEmojiAndTalk(patrolData, creature)
  if patrolData.emoji ~= nil then
    creature:GetSceneUI().roleTopUI:PlayEmojiById(patrolData.emoji)
  end
  if patrolData.talkId ~= nil then
    local msg = DialogUtil.GetDialogData(patrolData.talkId).Text
    creature:GetSceneUI().roleTopUI:Speak(msg, creature)
  end
end

function IdleAI_Patrol:PlayAction(patrolData, creature)
  if patrolData.animName ~= nil then
    creature:Logic_PlayAction_Simple(patrolData.animName)
  else
    creature:Logic_PlayAction_Idle()
  end
end

function IdleAI_Patrol:PlayInteractAction(patrolData, creature, isOn)
  if self.furniture ~= nil and patrolData.interactid ~= nil then
    if isOn then
      self.interact = self:GetInteract(self.furniture, patrolData.interactid)
      local cpCount = self.furniture.data.staticData.SeatCount or 1
      for i = 1, cpCount do
        local charId = Game.InteractNpcManager:GetCharid(self.furniture.id, i)
        local npcId = self.interact:GetCharid(i)
        if charId == nil and npcId == nil then
          self.interact:GetOn(i, creature.data.id)
          creature.ai:SetForceUpdate(true)
          if BackwardCompatibilityUtil.CompatibilityMode_V36 then
            creature.assetRole:SetForceColliderEnable(false)
          end
          return
        end
      end
      self.interact = nil
    else
      self.interact:GetOff(creature.data.id)
      self.interact = nil
      creature.ai:SetForceUpdate(false)
      if BackwardCompatibilityUtil.CompatibilityMode_V36 then
        creature.assetRole:SetForceColliderEnable(nil)
      end
    end
  else
    creature:Logic_PlayAction_Idle()
  end
end

function IdleAI_Patrol:GetInteract(furniture, interactid)
  local interact = furniture.extraInteract
  if interact == nil then
    local data = Table_InteractFurniture[interactid]
    interact = InteractNpc2Furniture.Create(data, furniture.id)
    furniture.extraInteract = interact
  end
  return interact
end

function IdleAI_Patrol:CheckFollow(creature)
  local pos = creature:GetPosition()
  local myPos = Game.Myself:GetPosition()
  return VectorUtility.DistanceXZ_Square(pos, myPos) < OutterRange and self.interact == nil
end

function IdleAI_Patrol:OnVisitNpcEnd_Normal(patrolData, creature)
  if patrolData.currentAnimTime == nil then
    self:_MoveTo(self.targetPosition, creature)
  end
end

function IdleAI_Patrol:OnVisitNpcEnd_None(patrolData, creature)
end

function IdleAI_Patrol:OnPatrolStepStart_Random(patrolData, creature)
  patrolData.currentAnimTime = nil
  patrolData.isEnd = false
  local targetPos = HomeManager.Me():GetRandomPosInCurrentHome()
  self:_MoveTo(targetPos, creature)
  local p = creature.logicTransform.currentPosition
  LuaVector3.Better_Set(self.prePosition, p[1], p[2], p[3])
  self.stayDuration = 0
end

function IdleAI_Patrol:OnPatrolStepUpdate_Random(deltaTime, patrolData, creature)
  if creature.logicTransform.targetPosition ~= nil then
    creature.logicTransform:SamplePosition()
  end
  local p = creature.logicTransform.currentPosition
  if LuaVector3.Distance_Square(self.prePosition, p) < 1.0E-5 then
    self.stayDuration = self.stayDuration + deltaTime
  else
    LuaVector3.Better_Set(self.prePosition, p[1], p[2], p[3])
    self.stayDuration = 0
  end
  if patrolData.currentAnimTime ~= nil then
    patrolData.currentAnimTime = patrolData.currentAnimTime + deltaTime
    if patrolData.currentAnimTime >= patrolData.animTime then
      patrolData.isEnd = true
    end
  elseif creature.logicTransform.targetPosition == nil or self.stayDuration > 1.0 then
    if patrolData.animTime == 0 then
      self:PlayEmojiAndTalk(patrolData, creature)
      patrolData.isEnd = true
    else
      patrolData.currentAnimTime = 0
      self:PlayAction(patrolData, creature)
      self:PlayEmojiAndTalk(patrolData, creature)
    end
  end
end

function IdleAI_Patrol:OnPatrolStepEnd_Random(patrolData, creature)
  patrolData.currentTimes = patrolData.currentTimes + 1
  if patrolData.currentTimes == patrolData.times then
    patrolData.currentTimes = 0
    self:HandlePatrolDataOnStepEnd(patrolData)
  end
end

function IdleAI_Patrol:OnStop_Random(patrolData, creature)
  self:OnPatrolStepEnd_Random(patrolData, creature)
end

OnPatrolStepStart[IdleAI_Patrol.PatrolType.Random] = IdleAI_Patrol.OnPatrolStepStart_Random
OnPatrolStepUpdate[IdleAI_Patrol.PatrolType.Random] = IdleAI_Patrol.OnPatrolStepUpdate_Random
OnPatrolStepEnd[IdleAI_Patrol.PatrolType.Random] = IdleAI_Patrol.OnPatrolStepEnd_Random
OnVisitNpcEnd[IdleAI_Patrol.PatrolType.Random] = IdleAI_Patrol.OnVisitNpcEnd_Normal
OnStop[IdleAI_Patrol.PatrolType.Random] = IdleAI_Patrol.OnStop_Random

function IdleAI_Patrol:OnPatrolStepStart_Furniture(patrolData, creature)
  patrolData.currentAnimTime = nil
  patrolData.isEnd = false
  self.furniture = HomeManager.Me():GetRandomFurnitureByFurnitureType(patrolData.toType)
  if self.furniture == nil then
    patrolData.isEnd = true
    patrolData.currentTimes = patrolData.times
  else
    self:_MoveTo(self.furniture:GetPosition(), creature)
    local p = creature.logicTransform.currentPosition
    LuaVector3.Better_Set(self.prePosition, p[1], p[2], p[3])
    self.stayDuration = 0
  end
end

function IdleAI_Patrol:OnPatrolStepUpdate_Furniture(deltaTime, patrolData, creature)
  if patrolData.isEnd then
    return
  end
  if creature.logicTransform.targetPosition ~= nil then
    creature.logicTransform:SamplePosition()
  end
  local p = creature.logicTransform.currentPosition
  if LuaVector3.Distance_Square(self.prePosition, p) < 1.0E-5 then
    self.stayDuration = self.stayDuration + deltaTime
  else
    LuaVector3.Better_Set(self.prePosition, p[1], p[2], p[3])
    self.stayDuration = 0
  end
  if patrolData.currentAnimTime ~= nil then
    patrolData.currentAnimTime = patrolData.currentAnimTime + deltaTime
    if patrolData.currentAnimTime >= patrolData.animTime and self.interact == nil then
      patrolData.isEnd = true
    elseif self.interact ~= nil then
      if self.interact:IsOff(creature.data.id) then
        patrolData.isEnd = true
      elseif patrolData.currentAnimTime >= patrolData.offTime then
        self:PlayInteractAction(patrolData, creature, false)
      end
    end
  elseif creature.logicTransform.targetPosition == nil or self.stayDuration > 1.0 then
    if patrolData.animTime == 0 then
      self:PlayEmojiAndTalk(patrolData, creature)
      patrolData.isEnd = true
    else
      patrolData.currentAnimTime = 0
      if patrolData.interactid == nil then
        self:PlayAction(patrolData, creature)
        self:PlayEmojiAndTalk(patrolData, creature)
      else
        self:PlayInteractAction(patrolData, creature, true)
        if self.interact == nil then
          self:PlayAction(patrolData, creature)
          patrolData.isEnd = true
        else
          self:PlayEmojiAndTalk(patrolData, creature)
        end
      end
    end
  end
end

function IdleAI_Patrol:OnPatrolStepEnd_Furniture(patrolData, creature)
  self.furniture = nil
  self.interact = nil
  patrolData.currentTimes = patrolData.currentTimes + 1
  if patrolData.currentTimes >= patrolData.times then
    patrolData.currentTimes = 0
    self:HandlePatrolDataOnStepEnd(patrolData)
  else
    local fromType = patrolData.fromType
    patrolData.fromType = patrolData.toType
    patrolData.toType = fromType
  end
end

function IdleAI_Patrol:OnStop_Furniture(patrolData, creature)
  if self.interact ~= nil then
    self:PlayInteractAction(patrolData, creature, false)
  end
  self:OnPatrolStepEnd_Furniture(patrolData, creature)
end

OnPatrolStepStart[IdleAI_Patrol.PatrolType.Furniture] = IdleAI_Patrol.OnPatrolStepStart_Furniture
OnPatrolStepUpdate[IdleAI_Patrol.PatrolType.Furniture] = IdleAI_Patrol.OnPatrolStepUpdate_Furniture
OnPatrolStepEnd[IdleAI_Patrol.PatrolType.Furniture] = IdleAI_Patrol.OnPatrolStepEnd_Furniture
OnVisitNpcEnd[IdleAI_Patrol.PatrolType.Furniture] = IdleAI_Patrol.OnVisitNpcEnd_Normal
OnStop[IdleAI_Patrol.PatrolType.Furniture] = IdleAI_Patrol.OnStop_Furniture

function IdleAI_Patrol:OnPatrolStepStart_Point(patrolData, creature)
  patrolData.currentAnimTime = nil
  patrolData.isEnd = false
  self:_MoveTo(patrolData.toPoint, creature)
  local p = creature.logicTransform.currentPosition
  LuaVector3.Better_Set(self.prePosition, p[1], p[2], p[3])
  self.stayDuration = 0
end

function IdleAI_Patrol:OnPatrolStepUpdate_Point(deltaTime, patrolData, creature)
  if creature.logicTransform.targetPosition ~= nil then
    creature.logicTransform:SamplePosition()
  end
  local p = creature.logicTransform.currentPosition
  if LuaVector3.Distance_Square(self.prePosition, p) < 1.0E-5 then
    self.stayDuration = self.stayDuration + deltaTime
  else
    LuaVector3.Better_Set(self.prePosition, p[1], p[2], p[3])
    self.stayDuration = 0
  end
  if patrolData.currentAnimTime ~= nil then
    patrolData.currentAnimTime = patrolData.currentAnimTime + deltaTime
    if patrolData.currentAnimTime >= patrolData.animTime then
      patrolData.isEnd = true
    end
  elseif creature.logicTransform.targetPosition == nil or self.stayDuration > 1.0 then
    if patrolData.animTime == 0 then
      self:PlayEmojiAndTalk(patrolData, creature)
      patrolData.isEnd = true
    else
      patrolData.currentAnimTime = 0
      self:PlayAction(patrolData, creature)
      self:PlayEmojiAndTalk(patrolData, creature)
    end
  end
end

function IdleAI_Patrol:OnPatrolStepEnd_Point(patrolData, creature)
  patrolData.currentTimes = patrolData.currentTimes + 1
  if patrolData.currentTimes == patrolData.times then
    patrolData.currentTimes = 0
    self:HandlePatrolDataOnStepEnd(patrolData)
  else
    local fromPoint = patrolData.fromPoint
    patrolData.fromPoint = patrolData.toPoint
    patrolData.toPoint = fromPoint
  end
end

function IdleAI_Patrol:OnStop_Point(patrolData, creature)
  self:OnPatrolStepEnd_Point(patrolData, creature)
end

OnPatrolStepStart[IdleAI_Patrol.PatrolType.Point] = IdleAI_Patrol.OnPatrolStepStart_Point
OnPatrolStepUpdate[IdleAI_Patrol.PatrolType.Point] = IdleAI_Patrol.OnPatrolStepUpdate_Point
OnPatrolStepEnd[IdleAI_Patrol.PatrolType.Point] = IdleAI_Patrol.OnPatrolStepEnd_Point
OnVisitNpcEnd[IdleAI_Patrol.PatrolType.Point] = IdleAI_Patrol.OnVisitNpcEnd_Normal
OnStop[IdleAI_Patrol.PatrolType.Point] = IdleAI_Patrol.OnStop_Point

function IdleAI_Patrol:OnPatrolStepStart_Follow(patrolData, creature)
  patrolData.currentFollowTime = 0
  self:PlayEmojiAndTalk(patrolData, creature)
  self:_MoveTo(creature:GetPosition(), creature)
  self.followStep = 2
end

function IdleAI_Patrol:OnPatrolStepUpdate_Follow(deltaTime, patrolData, creature)
  if creature.logicTransform.targetPosition ~= nil then
    creature.logicTransform:SamplePosition()
  end
  patrolData.currentFollowTime = patrolData.currentFollowTime + deltaTime
  if patrolData.currentFollowTime >= patrolData.followTime then
    patrolData.isEnd = true
  else
    local currentPosition = creature:GetPosition()
    if nil == currentPosition then
      self:_Idle(creature)
      return true
    end
    local targetPosition = Game.Myself:GetPosition()
    if nil == targetPosition then
      self:_Idle(creature)
      return true
    end
    if nil ~= self.prevTargetPosition then
      local targetChangedDistance = VectorUtility.DistanceXZ_Square(self.prevTargetPosition, targetPosition)
      if targetChangedDistance < InnerRange then
        self:_Idle(creature)
        return true
      end
    end
    local distance = VectorUtility.DistanceXZ_Square(currentPosition, targetPosition)
    if distance < InnerRange then
      self:_Idle(creature)
      return true
    end
    if distance > OutterRange then
      self:_Follow(creature)
    end
    if 2 == self.followStep then
      local prevTargetPosition = creature.logicTransform.targetPosition
      if nil == prevTargetPosition or VectorUtility.DistanceXZ_Square(prevTargetPosition, targetPosition) > InnerRange then
        if creature:Logic_NavMeshMoveTo(targetPosition) then
          if nil ~= self.prevTargetPosition then
            self.prevTargetPosition:Destroy()
            self.prevTargetPosition = nil
          end
        else
          self.prevTargetPosition = VectorUtility.Asign_3(self.prevTargetPosition, targetPosition)
          self:_Idle(creature)
        end
      end
    end
    return true
  end
end

function IdleAI_Patrol:OnPatrolStepEnd_Follow(patrolData, creature)
  table.remove(self.patrolList, self.patrolIndex)
  if #self.patrolList == 0 then
    self.patrolList = nil
  end
end

function IdleAI_Patrol:OnStop_Follow(patrolData, creature)
  self:OnPatrolStepEnd_Follow(patrolData, creature)
end

OnPatrolStepStart[IdleAI_Patrol.PatrolType.Follow] = IdleAI_Patrol.OnPatrolStepStart_Follow
OnPatrolStepUpdate[IdleAI_Patrol.PatrolType.Follow] = IdleAI_Patrol.OnPatrolStepUpdate_Follow
OnPatrolStepEnd[IdleAI_Patrol.PatrolType.Follow] = IdleAI_Patrol.OnPatrolStepEnd_Follow
OnVisitNpcEnd[IdleAI_Patrol.PatrolType.Follow] = IdleAI_Patrol.OnVisitNpcEnd_None
OnStop[IdleAI_Patrol.PatrolType.Follow] = IdleAI_Patrol.OnStop_Follow

function IdleAI_Patrol:OnPatrolStepStart_Stay(patrolData, creature)
  patrolData.currentAnimTime = 0
  patrolData.isEnd = false
  self:PlayEmojiAndTalk(patrolData, creature)
end

function IdleAI_Patrol:OnPatrolStepUpdate_Stay(deltaTime, patrolData, creature)
  patrolData.currentAnimTime = patrolData.currentAnimTime + deltaTime
  if patrolData.currentAnimTime >= patrolData.animTime then
    patrolData.isEnd = true
  end
end

function IdleAI_Patrol:OnPatrolStepEnd_Stay(patrolData, creature)
  patrolData.currentTimes = patrolData.currentTimes + 1
  if patrolData.currentTimes == patrolData.times then
    patrolData.currentTimes = 0
    self:HandlePatrolDataOnStepEnd(patrolData)
  end
end

function IdleAI_Patrol:OnStop_Stay(patrolData, creature)
  self:OnPatrolStepEnd_Stay(patrolData, creature)
end

OnPatrolStepStart[IdleAI_Patrol.PatrolType.Stay] = IdleAI_Patrol.OnPatrolStepStart_Stay
OnPatrolStepUpdate[IdleAI_Patrol.PatrolType.Stay] = IdleAI_Patrol.OnPatrolStepUpdate_Stay
OnPatrolStepEnd[IdleAI_Patrol.PatrolType.Stay] = IdleAI_Patrol.OnPatrolStepEnd_Stay
OnVisitNpcEnd[IdleAI_Patrol.PatrolType.Stay] = IdleAI_Patrol.OnVisitNpcEnd_None
OnStop[IdleAI_Patrol.PatrolType.Stay] = IdleAI_Patrol.OnPatrolStepEnd_Stay
