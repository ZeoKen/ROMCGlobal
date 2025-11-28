CameraAdditiveEffectShake = class("CameraAdditiveEffectShake", CameraPositionOffsetEffect)
CameraAdditiveEffectShake.CURVE_DEGRESSION = 1
CameraAdditiveEffectShake.CURVE_UNIFORM = 2
CameraAdditiveEffectShake.INFINITE_DURATION = -999
local shakeOffset = LuaVector3(0, 0, 0)

function CameraAdditiveEffectShake:SetParams(range, duration, curve)
  self.maxRange = range or 0.3
  self.duration = duration or -1
  self.curve = curve or CameraAdditiveEffectShake.CURVE_DEGRESSION
end

function CameraAdditiveEffectShake:OnStart()
  CameraAdditiveEffectShake.super.OnStart(self)
  if self.maxRange == 0 or 0 >= self.duration and self.duration > CameraAdditiveEffectShake.INFINITE_DURATION then
    self:Shutdown()
    return
  end
  self.range = self.maxRange
  self.timeEscaped = 0
  TimeTickManager.Me():CreateTick(0, 16, self.Update, self)
end

function CameraAdditiveEffectShake:OnEnd()
  CameraAdditiveEffectShake.super.OnEnd(self)
  TimeTickManager.Me():ClearTick(self)
  LuaVector3.Better_Set(shakeOffset, 0, 0, 0)
  self:Apply(shakeOffset)
  self:SetParams()
end

function CameraAdditiveEffectShake:Update(deltaTime)
  local deltaTimeSeconds = deltaTime / 1000
  LuaVector3.Better_Set(shakeOffset, RandomUtil.RandomInSphere(self.range))
  self:Apply(shakeOffset)
  self.timeEscaped = self.timeEscaped + deltaTimeSeconds
  if 0 < self.duration then
    if self.timeEscaped >= self.duration then
      self:Shutdown()
    elseif CameraAdditiveEffectShake.CURVE_DEGRESSION == self.curve then
      local progress = self.timeEscaped / self.duration
      self.range = self.maxRange * (1 - progress)
    end
  end
end
