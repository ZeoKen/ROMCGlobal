SkillSolo = class("SkillSolo", ReusableObject)
SkillSolo.PoolSize = 5
local VectorZero = LuaVector3.Zero()

function SkillSolo.Create()
  return ReusableObject.Create(SkillSolo, true)
end

function SkillSolo:StartSolo(creature, skillid)
  local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillid)
  if skillInfo then
    self.soloAction = skillInfo:GetAttackAction(creature)
  else
    self.soloAction = nil
  end
  creature:Logic_PlayAction_Idle()
  self:PlaySEOn(creature, skillid)
end

function SkillSolo:EndSolo(creature)
  local action = self.soloAction
  self.soloAction = nil
  if creature.assetRole:IsPlayingAction(action) then
    creature:Logic_PlayAction_Idle()
  end
  self:StopSEOn()
end

function SkillSolo:PlaySEOn(creature, skillid)
  local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillid)
  if skillInfo == nil then
    return
  end
  local sePath = skillInfo:GetBgSEPath()
  if sePath == nil then
    return
  end
  local trans = creature.assetRole.completeTransform
  local clip = AudioUtility.GetAudioClip(sePath)
  local x, y, z = LuaGameObject.GetPosition(trans)
  self.audioSource = AudioHelper.PlayLoop_At(clip, x, y, z, 0, AudioSourceType.SKILL_Bg)
  local volume = AudioUtility.GetVolume()
  self:UpdateVolume(volume)
  FunctionBGMCmd.Me():StartSolo()
end

function SkillSolo:StopSEOn()
  if self.audioSource ~= nil then
    FunctionBGMCmd.Me():EndSolo()
  end
  self:ClearAudioSource()
end

function SkillSolo:ClearAudioSource()
  if self.audioSource ~= nil and not Slua.IsNull(self.audioSource) then
    self.audioSource:Stop()
  end
  self.audioSource = nil
end

function SkillSolo:GetSoloAction()
  return self.soloAction
end

function SkillSolo:UpdateVolume(volume)
  local source = self.audioSource and self.audioSource.audioSource
  if source then
    source.volume = volume
  end
end

function SkillSolo:DoConstruct(asArray, args)
end

function SkillSolo:DoDeconstruct(asArray)
  self.soloAction = nil
  self:ClearAudioSource()
end
