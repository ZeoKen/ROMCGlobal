IdleAI_SkillTargetPoint = class("IdleAI_SkillTargetPoint")

function IdleAI_SkillTargetPoint:ctor()
  self:Clear()
end

function IdleAI_SkillTargetPoint:Prepare(idleElapsed, time, deltaTime, creature)
  if not self.requestOn then
    return false
  end
  return true
end

function IdleAI_SkillTargetPoint:Start(idleElapsed, time, deltaTime, creature)
  local actionName = FunctionSkillTargetPointLauncher.Me():GetPointAction()
  if actionName ~= nil then
    local params = Asset_Role.GetPlayActionParams(actionName)
    params[5] = true
    creature:Logic_PlayAction(params)
  end
end

function IdleAI_SkillTargetPoint:End(idleElapsed, time, deltaTime, creature)
  creature:Client_PlayAction(Asset_Role.ActionName.Idle)
end

function IdleAI_SkillTargetPoint:Update(idleElapsed, time, deltaTime, creature)
  local point = FunctionSkillTargetPointLauncher.Me():GetPoint()
  local angleY = VectorHelper.GetAngleByAxisY(creature:GetPosition(), point)
  if self.angleY ~= angleY then
    creature.logicTransform:SetAngleY(angleY)
    self.angleY = angleY
  end
  return true
end

function IdleAI_SkillTargetPoint:Clear(idleElapsed, time, deltaTime, creature)
  self.requestOn = nil
  self.angleY = nil
end

function IdleAI_SkillTargetPoint:Request_Set(on)
  self.requestOn = on
  if on == false then
    self.angleY = nil
  end
end
