NpcAIState_Photograph = class("NpcAIState_Photograph", NpcAIState)

function NpcAIState_Photograph:DoDeconstruct()
  NpcAIState_Photograph.super.DoDeconstruct(self)
  self.updateRange = nil
  self.updateAngle = nil
end

function NpcAIState_Photograph:OnEnter()
  local data = Table_AICondition[self.id]
  local params = data.Params
  self.updateRange = params and params.updateRange
  self.updateAngle = params and params.updateAngle
  self.randomPos = self:RandomPosInRange(self.updateRange)
  NpcAIState_Photograph.super.OnEnter(self)
end

function NpcAIState_Photograph:OnUpdate(time, deltaTime)
  if not self.isPlaying then
    return
  end
  local creature = NSceneNpcProxy.Instance:Find(self.ai.id)
  if not creature then
    return
  end
  local target = NSceneUserProxy.Instance:Find(self.targetId)
  if not target then
    self:Dispose()
  else
    local sqrDis = self.updateRange * self.updateRange
    if sqrDis < LuaVector3.Distance_Square(target:GetPosition(), creature:GetPosition()) then
      self.ai:StopEvent()
      self:CheckNpcPosition(target)
    else
      self:CheckNpcDirection(target)
    end
  end
end

function NpcAIState_Photograph:CheckNpcPosition(target)
  local creature = NSceneNpcProxy.Instance:Find(self.ai.id)
  if not creature then
    return
  end
  self.randomPos = self:RandomPosInRange(self.updateRange)
  local pos = self.randomPos
  self.ai:Transition(self.randomPos, function()
    if not self.isPlaying then
      return
    end
    if not self.ai:IsInTransition() then
      return
    end
    if pos ~= self.randomPos then
      return
    end
    local dir = target:GetAngleY()
    creature:Server_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, dir)
    self.ai:OnTransitionEnd()
  end)
end

local tempV1 = LuaVector3.Zero()
local tempV2 = LuaVector3.Zero()

function NpcAIState_Photograph:CheckNpcDirection(target)
  if not self.updateAngle then
    return
  end
  local creature = NSceneNpcProxy.Instance:Find(self.ai.id)
  if not creature then
    return
  end
  local x, y, z = LuaGameObject.GetTransformForward(creature.assetRole.complete)
  tempV1 = LuaGeometry.GetTempVector3(x, y, z, tempV1)
  x, y, z = LuaGameObject.GetTransformForward(target.assetRole.complete)
  tempV2 = LuaGeometry.GetTempVector3(x, y, z, tempV2)
  local dot = LuaVector3.Dot(tempV1, tempV2)
  if dot < math.cos(math.rad(self.updateAngle)) then
    local angle = target:GetAngleY()
    creature:Server_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, angle)
  end
end
