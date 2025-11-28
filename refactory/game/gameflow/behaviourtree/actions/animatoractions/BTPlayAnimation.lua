BTPlayAnimation = class("BTPlayAnimation", BTAnimatorAction)
BTPlayAnimation.TypeName = "PlayAnimation"
BTDefine.RegisterAction(BTPlayAnimation.TypeName, BTPlayAnimation)

function BTPlayAnimation:ctor(config)
  BTPlayAnimation.super.ctor(self, config)
  self.stateName = config.stateName
  self.stateHash = self.stateName and Animator.StringToHash(self.stateName) or 0
  self.forceReplay = config.forceReplay
  self.layer = config.layer or -1
  self.normalizedTime = config.normalizedTime or 0
end

function BTPlayAnimation:Dispose()
  BTPlayAnimation.super.Dispose(self)
end

function BTPlayAnimation:Exec(time, deltaTime, context)
  local ret = BTPlayAnimation.super.Exec(self, time, deltaTime, context)
  if ret ~= 0 then
    return ret
  end
  if not self:ValidateAnimators(context, function(animator)
    local stateLayer = self.layer
    if not stateLayer or stateLayer < 0 then
      stateLayer = 0
    end
    if animator:HasState(stateLayer, self.stateHash) then
      return true
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
      local stateLayer = self.layer
      if not stateLayer or stateLayer < 0 then
        stateLayer = 0
      end
      local shouldPlay = self.forceReplay
      if not self.forceReplay then
        local lastState = v:GetCurrentAnimatorStateInfo(stateLayer)
        if lastState.shortNameHash ~= self.stateHash then
          shouldPlay = true
        end
      end
      if shouldPlay then
        v:Play(self.stateHash, self.layer, self.normalizedTime)
      end
    end
  end
  return 0
end
