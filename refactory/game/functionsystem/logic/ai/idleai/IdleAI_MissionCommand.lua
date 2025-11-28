IdleAI_MissionCommand = class("IdleAI_MissionCommand")
local tempEventArgs = {}

function IdleAI_MissionCommand:ctor()
  self.currentCommand = nil
  self.requestCommand = nil
end

function IdleAI_MissionCommand:Clear(idleElapsed, time, deltaTime, creature)
  if nil ~= self.requestCommand then
    self.requestCommand:Destroy()
    self.requestCommand = nil
  end
  self:_SwitchCommand(nil)
end

function IdleAI_MissionCommand:Prepare(idleElapsed, time, deltaTime, creature)
  if nil ~= creature.ai.parent then
    return false
  end
  if nil ~= self.requestCommand then
    local newCmd = self.requestCommand
    self.requestCommand = nil
    self:_SwitchCommand(newCmd)
  end
  return nil ~= self.currentCommand
end

function IdleAI_MissionCommand:Start(idleElapsed, time, deltaTime, creature)
  self.currentCommand:Launch()
end

function IdleAI_MissionCommand:End(idleElapsed, time, deltaTime, creature)
  if nil ~= self.currentCommand then
    if self.currentCommand.ignoreUpdate == nil then
      self.currentCommand:Update(time, deltaTime)
    end
    if nil ~= self.currentCommand and self.currentCommand.running then
      self.currentCommand:Shutdown()
    else
      self:_SwitchCommand(nil)
    end
  end
end

function IdleAI_MissionCommand:Update(idleElapsed, time, deltaTime, creature)
  self.currentCommand:Update(time, deltaTime)
  if nil ~= self.currentCommand and not self.currentCommand.running then
    self:_SwitchCommand(nil)
    return false
  end
  return true
end

function IdleAI_MissionCommand:_SwitchCommand(newCommand)
  local oldCommand = self.currentCommand
  self.currentCommand = newCommand
  tempEventArgs[1] = oldCommand
  tempEventArgs[2] = newCommand
  EventManager.Me():DispatchEvent(MyselfEvent.MissionCommandChanged, tempEventArgs)
  tempEventArgs[1] = nil
  tempEventArgs[2] = nil
  if nil ~= oldCommand then
    oldCommand:Shutdown()
    oldCommand:Destroy()
  end
end

function IdleAI_MissionCommand:Request_Set(newCommand)
  local oldRequestCmd = self.requestCommand
  self.requestCommand = newCommand
  if nil ~= oldRequestCmd then
    oldRequestCmd:Destroy()
  end
  if self.currentCommand ~= nil and self.requestCommand == nil then
    self:_SwitchCommand(nil)
  end
end
