BTBBChangeTarget = class("BTBBChangeTarget", BTNode)
BTBBChangeTarget.TypeName = "BBChangeTarget"
BTDefine.RegisterService(BTBBChangeTarget.TypeName, BTBBChangeTarget)

function BTBBChangeTarget:ctor(config)
  BTBBChangeTarget.super.ctor(self, config)
  self.tag = config.tag
  self.id = config.id
end

function BTBBChangeTarget:Dispose()
  BTBBChangeTarget.super.Dispose(self)
end

function BTBBChangeTarget:Exec(time, deltaTime, context)
  local bb = context and context.blackboard
  if bb then
    local target = BTDefine.GetTarget(self.tag, self.id, context)
    bb:SetTarget(target)
  end
  return 0
end
