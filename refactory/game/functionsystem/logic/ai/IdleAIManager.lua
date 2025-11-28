autoImport("MissionCommand")
autoImport("MissionCommandMove")
autoImport("MissionCommandVisitNpc")
autoImport("MissionCommandSkill")
autoImport("MissionCommandFactory")
autoImport("IdleAI_PlayShow")
autoImport("IdleAI_HandInHand")
autoImport("IdleAI_BeHolded")
autoImport("IdleAI_DoubleAction")
autoImport("IdleAI_Photographer")
autoImport("IdleAI_Attack")
autoImport("IdleAI_FearRun")
autoImport("IdleAI_FlyFollow")
autoImport("IdleAI_WalkFollow")
autoImport("IdleAI_AutoBattle")
autoImport("IdleAI_MissionCommand")
autoImport("IdleAI_Patrol")
autoImport("IdleAI_FollowLeader")
autoImport("IdleAI_LookAt")
autoImport("IdleAI_FakeDead")
autoImport("IdleAI_EndlessTowerSweep")
autoImport("IdleAI_SkillTargetPoint")
autoImport("IdleAI_SkillOverAction")
autoImport("IdleAI_Reload")
IdleAIManager = class("IdleAIManager")
local selfSwitchAI

function IdleAIManager:ctor()
  self.ais = {}
  self.currentAI = nil
  self.pausing = 0
end

function IdleAIManager:Clear(idleElapsed, time, deltaTime, creature)
  self:Break(idleElapsed, time, deltaTime, creature)
  for i = 1, #self.ais do
    self.ais[i]:Clear(idleElapsed, time, deltaTime, creature)
  end
  TableUtility.ArrayClear(self.ais)
end

function IdleAIManager:PushAI(ai)
  TableUtility.ArrayPushBack(self.ais, ai)
end

function IdleAIManager:PushAI_Sort(ai)
  TableUtility.InsertSort(self.ais, ai, function(iN, iNsert)
    return iNsert.priority > iN.priority
  end)
end

function IdleAIManager:RemoveAI(ai)
  TableUtility.ArrayRemove(self.ais, ai)
end

function IdleAIManager:Break(idleElapsed, time, deltaTime, creature)
  if nil ~= self.currentAI then
    self.currentAI:End(idleElapsed, time, deltaTime, creature)
    self.currentAI = nil
  end
end

function IdleAIManager:Pause(creature)
  self.pausing = self.pausing + 1
end

function IdleAIManager:Resume(creature)
  self.pausing = self.pausing - 1
end

function IdleAIManager:IsPausing(creature)
  return self.pausing > 0
end

function IdleAIManager:Update(idleElapsed, time, deltaTime, creature)
  if 0 < self.pausing then
    selfSwitchAI(self, nil, idleElapsed, time, deltaTime, creature)
    return
  end
  local newAI
  for i = 1, #self.ais do
    if self.ais[i]:Prepare(idleElapsed, time, deltaTime, creature) then
      newAI = self.ais[i]
      break
    end
  end
  selfSwitchAI(self, newAI, idleElapsed, time, deltaTime, creature)
  if nil ~= self.currentAI then
    local currentAI = self.currentAI
    if not currentAI:Update(idleElapsed, time, deltaTime, creature) and self.currentAI == currentAI then
      currentAI:End(idleElapsed, time, deltaTime, creature)
      self.currentAI = nil
    end
  end
  return nil ~= self.currentAI
end

function IdleAIManager:UpdateCurrentAI(idleElapsed, time, deltaTime, creature)
  if nil ~= self.currentAI then
    local currentAI = self.currentAI
    if (not currentAI:Prepare(idleElapsed, time, deltaTime, creature) or not currentAI:Update(idleElapsed, time, deltaTime, creature)) and self.currentAI == currentAI then
      currentAI:End(idleElapsed, time, deltaTime, creature)
      self.currentAI = nil
    end
  end
  return nil ~= self.currentAI
end

function IdleAIManager:GetCurrentAI()
  return self.currentAI
end

function IdleAIManager:_SwitchAI(newAI, idleElapsed, time, deltaTime, creature)
  if self.currentAI == newAI then
    return
  end
  if nil ~= self.currentAI then
    self.currentAI:End(idleElapsed, time, deltaTime, creature)
  end
  self.currentAI = newAI
  if nil ~= self.currentAI then
    self.currentAI:Start(idleElapsed, time, deltaTime, creature)
  end
end

selfSwitchAI = IdleAIManager._SwitchAI
