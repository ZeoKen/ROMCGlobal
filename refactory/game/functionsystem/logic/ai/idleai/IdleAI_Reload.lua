autoImport("SkillItemData")
IdleAI_Reload = class("IdleAI_Reload")
local UpdateInterval = 0.5
local TryUseSkillInterval = 3
local ReloadState = {
  None = 0,
  RequestReload = 1,
  InReload = 2
}

function IdleAI_Reload:ctor()
  self.nextUpdateTime = 0
  self.nextTryTime = 0
  self.state = ReloadState.None
end

function IdleAI_Reload:Clear(idleElapsed, time, deltaTime, creature)
  self.nextUpdateTime = 0
  self.nextTryTime = 0
  self.state = ReloadState.None
end

function IdleAI_Reload:Prepare(idleElapsed, time, deltaTime, creature)
  if nil ~= creature.ai.parent then
    return false
  end
  self.myself = Game.Myself
  if self.myselfProps == nil then
    self.myselfProps = Game.Myself.data and Game.Myself.data.props
  end
  if self.myself.data:IsTransformed() then
    return false
  end
  if not self.on then
    return false
  end
  local curBullets = MyselfProxy.Instance:GetCurBullets()
  if curBullets then
    return curBullets <= 0
  else
    return false
  end
end

function IdleAI_Reload:Start(idleElapsed, time, deltaTime, creature)
  self._SkillProxy = SkillProxy.Instance
end

function IdleAI_Reload:End(idleElapsed, time, deltaTime, creature)
  self.nextUpdateTime = 0
end

function IdleAI_Reload:Update(idleElapsed, time, deltaTime, creature)
  if time < self.nextUpdateTime then
    return true
  end
  self.nextUpdateTime = time + UpdateInterval
  if self._SkillProxy and self.skillItemData and self._SkillProxy:IsFitPreCondition(self.skillItemData) then
    self:_TryUseSkill(time, TryUseSkillInterval)
  end
  return true
end

function IdleAI_Reload:_TryUseSkill(time, interval)
  if time < self.nextTryTime then
    return
  end
  self.nextTryTime = time + interval
  FunctionSkill.Me():TryUseSkill(self.skillID)
end

function IdleAI_Reload:_Set(on)
  self.on = on
end

function IdleAI_Reload:Set_AutoReload(skillID)
  self.skillID = skillID
  if self.skillID ~= nil and self.skillID > 0 then
    self.skillItemData = SkillItemData.new(self.skillID, 0, 0, SkillProxy.Instance:GetMyProfession())
    self:_Set(true)
  else
    self.skillItemData = nil
    self:_Set(false)
  end
end
