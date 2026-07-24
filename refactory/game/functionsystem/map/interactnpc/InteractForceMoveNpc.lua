InteractForceMoveNpc = class("InteractForceMoveNpc", InteractNpc)

function InteractForceMoveNpc.Create(data, id)
  local args = InteractBase.GetArgs(data, id)
  return ReusableObject.Create(InteractForceMoveNpc, false, args)
end

function InteractForceMoveNpc:IsForceMoveNpc()
  return true
end

function InteractForceMoveNpc:IsNotifyChange()
  return false
end

function InteractForceMoveNpc:DoConstruct(asArray, data)
  InteractForceMoveNpc.super.DoConstruct(self, asArray, data)
  local config = self.staticData and self.staticData.Param
  self.triggerCheckRange = config and config.CheckRange or 0
end

function InteractForceMoveNpc:GetInteractPrompt(isMyselfOnNpc)
  return ZhString.InteractLocal_ForceMove
end

function InteractForceMoveNpc:GetHitTargetConfig()
  local forceMoveConfig = self.staticData and self.staticData.Param
  if not forceMoveConfig then
    return nil, nil
  end
  local hitNpcID = forceMoveConfig.HitToNpcId
  local hitNpcRange = forceMoveConfig.HitToNpcRange
  if hitNpcID and hitNpcRange then
    return hitNpcID, hitNpcRange
  end
  return nil, nil
end

function InteractForceMoveNpc:CheckPlayerBuffLimit()
  local forceMoveConfig = self.staticData and self.staticData.Param
  local buffLimit = forceMoveConfig and forceMoveConfig.PlayerAnyBuffLimit
  if not buffLimit then
    return true
  end
  local myselfData = Game.Myself.data
  for i = 1, #buffLimit do
    if myselfData:GetBuffActive(buffLimit[i]) then
      return true
    end
  end
  return false
end

function InteractForceMoveNpc:GetHitTargetNpc(npc)
  local hitNpcID, hitNpcRange = self:GetHitTargetConfig()
  if not (hitNpcID and hitNpcRange) or hitNpcRange <= 0 then
    return nil
  end
  local targetNpc, targetDist = NSceneNpcProxy.Instance:FindNearestNpc(npc:GetPosition(), hitNpcID, nil, nil, true)
  if targetNpc and targetDist and hitNpcRange >= targetDist and not targetNpc:IsDead() then
    return targetNpc
  end
  return nil
end

function InteractForceMoveNpc:CheckPosition(npc)
  if not InteractForceMoveNpc.super.CheckPosition(self, npc) then
    return false
  end
  if not self:CheckPlayerBuffLimit() then
    return false
  end
  if self:GetHitTargetConfig() == nil then
    return true
  end
  return self:GetHitTargetNpc(npc) ~= nil
end

function InteractForceMoveNpc:TryNotifyGetOn()
  local forceMoveConfig = self.staticData and self.staticData.Param
  local skillID = forceMoveConfig and forceMoveConfig.UseSkillId
  if not skillID or skillID == 0 then
    return false
  end
  local npc = self:GetNpc()
  if not npc then
    return false
  end
  if not self:CheckPlayerBuffLimit() then
    return false
  end
  if self:GetHitTargetConfig() ~= nil and not self:GetHitTargetNpc(npc) then
    return false
  end
  return Game.Myself:Client_UseSkill(skillID, npc, nil, nil, true)
end

function InteractForceMoveNpc:TryNotifyGetOff()
  return false
end
