BTSetAnimatorParam = class("BTSetAnimatorParam", BTAnimatorAction)
BTSetAnimatorParam.TypeName = "SetAnimatorParam"
BTDefine.RegisterAction(BTSetAnimatorParam.TypeName, BTSetAnimatorParam)
local ParamTypes = BTDefine.ParamTypes

function BTSetAnimatorParam:ctor(config)
  BTSetAnimatorParam.super.ctor(self, config)
  self.paramHash = config.paramName and Animator.StringToHash(config.paramName)
  self.paramVal = config.paramVal
  self.paramType = config.paramType or ParamTypes.integer
end

function BTSetAnimatorParam:Dispose()
  BTSetAnimatorParam.super.Dispose(self)
end

function BTSetAnimatorParam:Exec(time, deltaTime, context)
  local ret = BTSetAnimatorParam.super.Exec(self, time, deltaTime, context)
  if ret ~= 0 then
    return ret
  end
  if not self:ValidateAnimators(context, function(animator)
    local count = animator.parameterCount
    if count == 0 then
      return false
    end
    for i = 0, count - 1 do
      local parameter = animator:GetParameter(i)
      if parameter.nameHash == self.paramHash then
        return true
      end
    end
    return false
  end) then
    return 0
  end
  if self.animators then
    for _, v in ipairs(self.animators) do
      if LuaGameObject.ObjectIsNull(v) then
        redlog("[bt] object is nil, disabled")
        self.enabled = false
        break
      end
      if self.paramType == ParamTypes.integer then
        if v:GetInteger(self.paramHash) ~= self.paramVal then
          v:SetInteger(self.paramHash, self.paramVal)
        end
      elseif self.paramType == ParamTypes.number then
        if v:GetFloat(self.paramHash) ~= self.paramVal then
          v:SetFloat(self.paramHash, self.paramVal)
        end
      elseif self.paramType == ParamTypes.boolean then
        if v:GetBool(self.paramHash) ~= self.paramVal then
          v:SetBool(self.paramHash, not not self.paramVal)
        end
      elseif self.paramType == ParamTypes.trigger then
        if self.paramVal then
          v:SetTrigger(self.paramHash)
        else
          v:ResetTrigger(self.paramHash)
        end
      end
    end
  end
  return 0
end
