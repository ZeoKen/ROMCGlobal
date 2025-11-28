autoImport("AreaTrigger_ExitPoint")
autoImport("AreaTrigger_Mission")
autoImport("AreaTrigger_Common")
autoImport("AreaTrigger_Skill")
autoImport("AreaTrigger_Buff")
autoImport("AreaTrigger_Npc")
AreaTriggerManager = class("AreaTriggerManager")

function AreaTriggerManager:ctor()
  self.atExitPoint = AreaTrigger_ExitPoint.new()
  self.atMission = AreaTrigger_Mission.new()
  self.atCommon = AreaTrigger_Common.new()
  self.atSkill = AreaTrigger_Skill.CreateAsTable()
  self.atBuff = AreaTrigger_Buff.CreateAsTable()
  self.atNpc = AreaTrigger_Npc.new()
  Game.AreaTrigger_ExitPoint = self.atExitPoint
  Game.AreaTrigger_Mission = self.atMission
  Game.AreaTrigger_Common = self.atCommon
  Game.AreaTrigger_Skill = self.atSkill
  Game.AreaTrigger_Buff = self.atBuff
  Game.AreaTrigger_Npc = self.atNpc
  self.ignoreCount = 0
  self:SetIgnore(true)
end

function AreaTriggerManager:SetIgnore(ignore)
  if ignore then
    self.ignoreCount = self.ignoreCount + 1
  else
    self.ignoreCount = self.ignoreCount - 1
  end
  LuaLuancher.Instance.ignoreAreaTrigger = ignore
end

function AreaTriggerManager:ResetIgnoreAndSyncIgnore(is_ignore)
  self:ResetIgnoreAndSyncIgnoreCount(is_ignore and 1 or 0)
end

function AreaTriggerManager:ResetIgnoreAndSyncIgnoreCount(ignoreCount)
  local csIgnore = LuaLuancher.Instance.ignoreAreaTrigger
  while LuaLuancher.Instance.ignoreAreaTrigger == csIgnore do
    LuaLuancher.Instance.ignoreAreaTrigger = not csIgnore
  end
  self.ignoreCount = LuaLuancher.Instance.ignoreAreaTrigger and 1 or 0
  while self.ignoreCount ~= ignoreCount do
    self:SetIgnore(ignoreCount - self.ignoreCount > 0)
  end
end

function AreaTriggerManager:Launch()
  if self.running then
    return
  end
  self.running = true
  self:SetIgnore(false)
  self.atExitPoint:Launch()
  self.atMission:Launch()
  self.atCommon:Launch()
  self.atSkill:Launch()
  self.atBuff:Launch()
  self.atNpc:Launch()
end

function AreaTriggerManager:Shutdown()
  if not self.running then
    return
  end
  self.running = false
  self:ResetIgnoreAndSyncIgnoreCount(2)
  self.atExitPoint:Shutdown()
  self.atMission:Shutdown()
  self.atCommon:Shutdown()
  self.atSkill:Shutdown()
  self.atBuff:Shutdown()
  self.atNpc:Shutdown()
end

function AreaTriggerManager:Update(time, deltaTime)
  if not self.running then
    return
  end
  self.atMission:Update(time, deltaTime)
  self.atCommon:Update(time, deltaTime)
  self.atSkill:Update(time, deltaTime)
  self.atBuff:Update(time, deltaTime)
  self.atNpc:Update(time, deltaTime)
  if 0 < self.ignoreCount then
    return
  end
  self.atExitPoint:Update(time, deltaTime)
end
