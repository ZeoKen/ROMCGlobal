BTTargetSetActive = class("BTTargetSetActive", BTTargetAction)
BTTargetSetActive.TypeName = "TargetSetActive"
BTDefine.RegisterAction(BTTargetSetActive.TypeName, BTTargetSetActive)

function BTTargetSetActive:ctor(config)
  BTTargetSetActive.super.ctor(self, config)
  self.active = config.active and true or false
end

function BTTargetSetActive:Dispose()
  BTTargetSetActive.super.Dispose(self)
end

function BTTargetSetActive:Exec(time, deltaTime, context)
  local ret = BTTargetSetActive.super.Exec(self, time, deltaTime, context)
  if ret ~= 0 then
    return 0
  end
  self.target.gameObject:SetActive(self.active)
  return 0
end
