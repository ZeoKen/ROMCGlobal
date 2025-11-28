local ChangeJobEffectWeakKey = "ChangeJobEffectWeakKey"
local NightmareEffectWeakKey = "NightmareEffectWeakKey"

function NMyselfPlayer:OnObserverEffectDestroyed(key, effect)
  if key == ChangeJobEffectWeakKey then
    self:ChangeJobEnd()
  end
end

function NMyselfPlayer:PlayChangeJob()
  FunctionSystem.InterruptMyself()
  self:_PlayChangeJobBeginEffect()
end

function NMyselfPlayer:_PlayChangeJobBeginEffect()
  local effect = NMyselfPlayer.super._PlayChangeJobBeginEffect(self)
  self:SetWeakData(ChangeJobEffectWeakKey, effect)
end

function NMyselfPlayer:ChangeJobEnd()
  GameFacade.Instance:sendNotification(MyselfEvent.ChangeJobEnd, nil)
end

function NMyselfPlayer:PlayNightmareEffect(level)
  self:RemoveEffect(NightmareEffectWeakKey)
  if not self:IsAtNightmareMap() then
    return
  end
  local effectPath = GameConfig.Nightmare and GameConfig.Nightmare.PlayerEffectPath
  effectPath = effectPath and effectPath[level]
  if not effectPath then
    return
  end
  self:PlayEffect(NightmareEffectWeakKey, effectPath, GameConfig.Nightmare and GameConfig.Nightmare.PlayerEffectPoint or 3, nil, true, true)
end
