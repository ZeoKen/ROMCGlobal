autoImport("IdleAI_MoveAround")
AI_CreatureMoveAround = class("AI_CreatureMoveAround", AI_Creature)

function AI_CreatureMoveAround:AttachMoveAround()
  if self.ai_moveAround == nil then
    self.ai_moveAround = IdleAI_MoveAround.new()
  end
  self.idleAIManager:RemoveAI(self.ai_moveAround)
  self.idleAIManager:PushAI_Sort(self.ai_moveAround)
end

function AI_CreatureMoveAround:MoveAroundTarget(targetCreatureID, distance, angularSpeed, centerPos, orbitMoveSpeed, moveSpeed)
  if self.ai_moveAround == nil then
    self.ai_moveAround = IdleAI_MoveAround.new()
    self.idleAIManager:PushAI_Sort(self.ai_moveAround)
  end
  self.ai_moveAround:Request_Set(targetCreatureID, distance, angularSpeed, centerPos, orbitMoveSpeed, moveSpeed)
end

function AI_CreatureMoveAround:StopMoveAround()
  if self.ai_moveAround ~= nil then
    self.ai_moveAround:Request_Set(nil)
  end
end

function AI_CreatureMoveAround:Request_Set(targetCreatureID, distance, angularSpeed, centerPos, orbitMoveSpeed, moveSpeed, requestAngle)
  if self.ai_moveAround ~= nil then
    self.ai_moveAround:Request_Set(targetCreatureID, distance, angularSpeed, centerPos, orbitMoveSpeed, moveSpeed, requestAngle)
  end
end

function AI_CreatureMoveAround:SetAngularSpeed(angularSpeed)
  if self.ai_moveAround ~= nil then
    self.ai_moveAround:SetAngularSpeed(angularSpeed)
  end
end

function AI_CreatureMoveAround:SetDistance(distance)
  if self.ai_moveAround ~= nil then
    self.ai_moveAround:SetDistance(distance)
  end
end

function AI_CreatureMoveAround:SetFaceAngleOffset(angle)
  if self.ai_moveAround ~= nil then
    self.ai_moveAround:SetFaceAngleOffset(angle)
  end
end

function AI_CreatureMoveAround:GetCurrentAngle()
  if self.ai_moveAround ~= nil then
    return self.ai_moveAround:GetCurrentAngle()
  end
  return 0
end

function AI_CreatureMoveAround:SetCurrentAngle(angle)
  if self.ai_moveAround ~= nil then
    self.ai_moveAround:SetCurrentAngle(angle)
  end
end

function AI_CreatureMoveAround:IsRotating()
  if self.ai_moveAround ~= nil then
    return self.ai_moveAround:IsRotating()
  end
  return false
end
