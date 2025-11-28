BTSetAnimatorEnabled = class("BTSetAnimatorEnabled", BTAnimatorAction)
BTSetAnimatorEnabled.TypeName = "SetAnimatorEnabled"
BTDefine.RegisterAction(BTSetAnimatorEnabled.TypeName, BTSetAnimatorEnabled)
local ParamTypes = BTDefine.ParamTypes

function BTSetAnimatorEnabled:ctor(config)
  BTSetAnimatorEnabled.super.ctor(self, config)
  self.setEnabled = config.enabled or false
end

function BTSetAnimatorEnabled:Dispose()
  BTSetAnimatorEnabled.super.Dispose(self)
end

function BTSetAnimatorEnabled:Exec(time, deltaTime, context)
  local ret = BTSetAnimatorEnabled.super.Exec(self, time, deltaTime, context)
  if ret ~= 0 then
    return ret
  end
  if not self:ValidateAnimators(context) then
    return 0
  end
  if self.animators then
    for _, v in ipairs(self.animators) do
      if LuaGameObject.ObjectIsNull(v) then
        redlog("[bt] object is nil, disabled")
        self.enabled = false
        break
      end
      if v.enabled ~= self.setEnabled then
        v.enabled = self.setEnabled
      end
    end
  end
  return 0
end
