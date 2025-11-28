BTSystem = class("BTSystem")

function BTSystem:ctor(obj, config)
  self.btRoot = nil
  self.blackboard = nil
  self.enabled = true
  self:Init(obj, config)
end

function BTSystem:Init(obj, config)
  self.targetObject = obj
  self.blackboard = BTBlackBoard.new()
  self.gid = config.gid or 0
  self.btRoot = BTNode.CreateNode(config)
end

function BTSystem:Dispose()
  if self.btRoot then
    self.btRoot:Dispose()
    self.btRoot = nil
  end
  if self.blackboard then
    self.blackboard:Dispose()
    self.blackboard = nil
  end
end

function BTSystem:Update(time, deltaTime)
  if self.enabled == false then
    return
  end
  if self.blackboard then
    self.blackboard:Exec(time, deltaTime)
  end
  if self.btRoot then
    self.btRoot:Exec(time, deltaTime, self)
  end
end
