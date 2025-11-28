SkillHitWork_Delay = class("SkillHitWork_Delay", ReusableObject)
if not SkillHitWork_Delay.SkillHitWorkDelay_Inited then
  SkillHitWork_Delay.SkillHitWorkDelay_Inited = true
  SkillHitWork_Delay.PoolSize = 100
end

function SkillHitWork_Delay.ClearArgs(args)
  TableUtility.ArrayClear(args)
end

function SkillHitWork_Delay.Create(hitWorker, interval, fireIndex, fireCount, args)
  local owner = ReusableObject.Create(SkillHitWork_Delay, true, args)
  TimeTickManager.Me():CreateOnceDelayTick(interval, function()
    hitWorker:Work(fireIndex, fireCount)
    hitWorker:Destroy()
  end, owner, UnityFrameCount)
  return owner
end

function SkillHitWork_Delay:ctor()
  self.args = {}
end

function SkillHitWork_Delay:Update(time, deltaTime)
end

function SkillHitWork_Delay:DoConstruct(asArray, args)
end

function SkillHitWork_Delay:DoDeconstruct(asArray)
end
