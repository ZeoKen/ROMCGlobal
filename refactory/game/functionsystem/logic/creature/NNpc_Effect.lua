local EffectKey_PlayGuideEffectArrow = "EffectKey_PlayGuideEffectArrow"
local EffectKey_PlayGuideEffectCircle = "EffectKey_PlayGuideEffectCircle"

function NNpc:PlayGuideEffect()
  self:PlayEffect(EffectKey_PlayGuideEffectArrow, EffectMap.Maps.GuideArrow, RoleDefines_EP.Top, nil, true, true)
  self:PlayEffect(EffectKey_PlayGuideEffectCircle, EffectMap.Maps.GuideArea, RoleDefines_EP.Bottom, nil, true, true)
end

function NNpc:DestroyGuideEffect()
  self:RemoveEffect(EffectKey_PlayGuideEffectArrow)
  self:RemoveEffect(EffectKey_PlayGuideEffectCircle)
end

function NNpc:PlayDeathEffect()
  local path = EffectMap.Maps.NPCDead
  if self.data and self.data.staticData and self.data.staticData.DeathEffect ~= nil and self.data.staticData.DeathEffect ~= "" then
    path = self.data.staticData.DeathEffect
  end
  self:PlayEffect(nil, path, RoleDefines_EP.Middle, nil, false, false)
end

local _effectKey_GvgCrystalInvincible = "EffectKey_GvgCrystalInvincible"
local _invincibleEffect

function NNpc:PlayGvgCrystalInvincibleEffect()
  _invincibleEffect = _invincibleEffect or EffectMap.Maps.GvgCrystalInvincible
  self:PlayEffect(_effectKey_GvgCrystalInvincible, _invincibleEffect, RoleDefines_EP.Bottom, nil, true, true)
end

function NNpc:DestroyGvgCrystalInvincibleEffect()
  self:RemoveEffect(_effectKey_GvgCrystalInvincible)
end

local statue_key = "EB_Statue"

function NNpc:PlayEBStatueEffect(score, camp)
  if not score or not camp then
    return
  end
  if not GameConfig.EndlessBattleField then
    return
  end
  local score_statue_offect = GameConfig.EndlessBattleField.score_statue_offect
  if not score_statue_offect then
    return
  end
  local offsets = GameConfig.EndlessBattleField.statue_effect_offset and GameConfig.EndlessBattleField.statue_effect_offset[score]
  if not offsets then
    return
  end
  local path = camp == Camp_Human and EffectMap.Maps.EndlessBattle_Statue_Human or EffectMap.Maps.EndlessBattle_Statue_Vampire
  for i = 1, #offsets do
    local offset = score_statue_offect[offsets[i]]
    local key = statue_key .. offsets[i]
    self:PlayEffect(key, path, RoleDefines_EP.Top, offset, true, true)
  end
end
