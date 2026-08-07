autoImport("MonokumaAnnounceEffect")
MonokumaAnnounceManager = class("MonokumaAnnounceManager")
local kEffectHeightOffset = 0

function MonokumaAnnounceManager:ctor()
  self.running = false
  self.activeEffects = {}
  self.liveTime = 0
  self.showEffect = ""
  self.buffSkillSet = nil
end

function MonokumaAnnounceManager:Launch()
  self.running = true
end

function MonokumaAnnounceManager:Shutdown()
  self.running = false
  self:Clear()
end

function MonokumaAnnounceManager:SaveKumaBuffInfo(buffInfo)
  if self.buffSkillSet == nil then
    local buffEffect = buffInfo and buffInfo.BuffEffect
    local skillList = buffEffect and buffEffect.special_skill_ids
    self.showEffect = buffEffect and buffEffect.monokuma_effect or ""
    self.liveTime = buffEffect and buffEffect.live_time or 0
    if skillList then
      self.buffSkillSet = {}
      for i, id in ipairs(skillList) do
        self.buffSkillSet[id] = true
      end
    end
  end
end

function MonokumaAnnounceManager:IsKumaAnnounceSkill(skillID)
  if self.buffSkillSet == nil or skillID == nil then
    return false
  end
  return self.buffSkillSet[skillID // 1000] == true
end

function MonokumaAnnounceManager:OnPlayerSkillSpeak(skillID, caster)
  if not self.running or skillID == nil or caster == nil then
    return
  end
  self:TryShowAnnounce(skillID, caster)
end

function MonokumaAnnounceManager:TryShowAnnounce(skillID, caster)
  if not self.running or caster == nil then
    return
  end
  if not self:IsKumaAnnounceSkill(skillID) then
    return
  end
  local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillID)
  if skillInfo == nil then
    return
  end
  local skillName = skillInfo:GetSpeakName(caster)
  if skillName == nil or skillInfo:NoSpeak(caster) then
    return
  end
  local pos = caster:GetPosition()
  if pos == nil then
    return
  end
  local announceEffect = MonokumaAnnounceEffect.new()
  announceEffect:Init(caster, skillName, self.showEffect, pos, kEffectHeightOffset, self.liveTime)
  table.insert(self.activeEffects, announceEffect)
end

function MonokumaAnnounceManager:Update(time, deltaTime)
  if not self.running then
    return
  end
  local list = self.activeEffects
  for i = #list, 1, -1 do
    local e = list[i]
    if e:IsExpired() then
      e:Destroy()
      table.remove(list, i)
    end
  end
end

function MonokumaAnnounceManager:Clear()
  self.buffSkillSet = nil
  local list = self.activeEffects
  for i = #list, 1, -1 do
    list[i]:Destroy()
    list[i] = nil
  end
end
