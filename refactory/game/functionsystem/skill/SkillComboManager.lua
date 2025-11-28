SkillComboManager = class("SkillComboManager")
local State = {
  Launch = 1,
  End = 2,
  Interrupt = 3
}
local SkillAutoReplaceID = {
  [2010] = {
    2011,
    2012,
    2013
  },
  [2400] = {
    2410,
    2412,
    2428,
    2430
  },
  [2503] = {
    2515,
    2516,
    2517
  },
  [2523] = {
    2524,
    2525,
    2526
  },
  [2731] = {
    2732,
    2733,
    2734
  }
}
local KickSkillReplaceID = 2400
local ThanatosComboID = 2503
local ThanatosComboID2 = 2523

function SkillComboManager:ctor()
  self.state = nil
  self.skillid = nil
  self.autoReplaceSortID = nil
  self.allowAutoInterrupt = nil
  self.kickSkillID = 0
  self:InitAutoReplaceSkill()
  EventManager.Me():AddEventListener(AutoBattleManagerEvent.StateChanged, self.AutoBattle, self)
end

function SkillComboManager:Reset()
  self.skillid = nil
end

function SkillComboManager:OnLaunch(skillid)
  self.state = State.Launch
end

function SkillComboManager:OnEnd(skillid, autoInterrupt)
  self.state = State.End
  local sortid = self:GetSortID(skillid)
  local parentid = self.autoReplaceSkill[sortid]
  if autoInterrupt and self.allowAutoInterrupt then
    if ThanatosComboID == parentid or ThanatosComboID2 == parentid then
      return false
    end
    self.skillid = self:GetReplaceSkillID(skillid)
    if self.skillid ~= nil then
      self:AutoReplaceSkill(skillid, self.skillid)
    end
  end
  local _waitForComboID = Game.SkillClickUseManager:GetWaitForCombo()
  if not _waitForComboID then
    self:ResetReplaceSkill()
    self:Reset()
  end
end

function SkillComboManager:OnInterrupt(skillid)
  self.state = State.Interrupt
  self:UseSkill(skillid)
end

function SkillComboManager:PushSkill(skillid)
  if self.state ~= State.Launch and self.state ~= State.Interrupt then
    return false
  end
  local sortid = self:GetSortID(skillid)
  local parentid = self.autoReplaceSkill[sortid]
  if KickSkillReplaceID == parentid and skillid // 1000 ~= KickSkillReplaceID then
    return false
  end
  if ThanatosComboID == parentid or ThanatosComboID2 == parentid then
    return false
  end
  if self.skillid ~= nil then
    return true
  end
  self.skillid = self:GetReplaceSkillID(skillid)
  self:UseSkill(skillid)
  return self.skillid ~= nil
end

function SkillComboManager:CanPushSkill(skillid)
  if self.state ~= State.Launch and self.state ~= State.Interrupt then
    return false
  end
  if self.skillid ~= nil then
    return true
  end
  self.skillid = self:GetReplaceSkillID(skillid)
  return self.skillid ~= nil
end

function SkillComboManager:UseSkill(skillid)
  if self.skillid == nil then
    return false
  end
  if self.state ~= State.Interrupt and self.state ~= State.End then
    return false
  end
  local replaceskillid = self:AutoReplaceSkill(skillid, self.skillid)
  if replaceskillid == nil then
    return false
  end
  Game.Myself:Client_UseSkill(replaceskillid)
  return true
end

function SkillComboManager:AutoBattle()
  self.allowAutoInterrupt = Game.AutoBattleManager.on
end

function SkillComboManager:InitAutoReplaceSkill()
  local autoReplaceSkill = {}
  for k, v in pairs(SkillAutoReplaceID) do
    autoReplaceSkill[k] = k
    for i = #v, 1, -1 do
      autoReplaceSkill[v[i]] = k
    end
  end
  self.autoReplaceSkill = autoReplaceSkill
end

function SkillComboManager:AutoReplaceSkill(skillid, replaceskillid)
  local sortid = self:GetSortID(skillid)
  local parentid = self.autoReplaceSkill[sortid]
  if not parentid then
    return
  end
  local replaceskillid = self:SetReplaceSkill(parentid, replaceskillid)
  self.autoReplaceSortID = parentid
  return replaceskillid
end

function SkillComboManager:ResetReplaceSkill()
  if self.skillid ~= nil then
    return
  end
  local autoReplaceSortID = self.autoReplaceSortID
  if autoReplaceSortID == nil then
    return
  end
  self:SetReplaceSkill(autoReplaceSortID)
  self.autoReplaceSortID = nil
end

function SkillComboManager:SetReplaceSkill(sortid, replaceskillid)
  local skillid, skillitem = self:GetSkillID(sortid)
  if skillitem ~= nil then
    if replaceskillid == nil then
      skillitem:SetReplaceID(0)
    else
      skillitem:SetReplaceID(skillid == replaceskillid and 0 or replaceskillid)
    end
  end
  local myselfData = Game.Myself.data
  if skillid ~= replaceskillid and skillid == myselfData.normalAtkID then
    myselfData:SetReplaceNormalAtkID(replaceskillid)
  else
    myselfData:SetReplaceNormalAtkID()
  end
  return replaceskillid
end

function SkillComboManager:GetReplaceSkillID(skillid)
  local sortid = self:GetSortID(skillid)
  local parentid = self.autoReplaceSkill[sortid]
  if not parentid then
    return nil
  end
  local config = SkillAutoReplaceID[parentid]
  if KickSkillReplaceID == parentid then
    return self:GetSkillID(KickSkillReplaceID)
  end
  if sortid == parentid then
    if ThanatosComboID ~= parentid and ThanatosComboID2 ~= parentid then
      return self:GetSkillID(config[1])
    elseif not self:CheckComboCondition(skillid) then
      return self:GetSkillID(parentid)
    else
      local _, currentID = Game.SkillClickUseManager:GetWaitForCombo()
      return self:GetSkillID(currentID and currentID // 1000 or config[1])
    end
  end
  local index = TableUtility.ArrayFindIndex(config, sortid) + 1
  if index > #config then
    return self:GetSkillID(parentid)
  end
  if ThanatosComboID ~= parentid and ThanatosComboID2 ~= parentid then
    return self:GetSkillID(config[index])
  elseif not self:CheckComboCondition(skillid) then
    return self:GetSkillID(parentid)
  else
    return self:GetSkillID(config[index])
  end
end

function SkillComboManager:GetSortID(skillid)
  return math.floor(skillid / 1000)
end

function SkillComboManager:GetSkillID(sortid)
  local skillitem = SkillProxy.Instance:GetLearnedSkillBySortID(sortid)
  if skillitem ~= nil then
    return skillitem.id, skillitem
  end
  return sortid * 1000 + 1
end

function SkillComboManager:RecvTriggerKickSkillSkillCmd(skillid)
  if not ProfessionProxy.IsTaekwon() then
    return
  end
  if not skillid or skillid == 0 then
    self.kickSkillID = nil
  else
    self.kickSkillID = skillid
  end
end

function SkillComboManager:GetTriggerKickSkillID()
  return self.kickSkillID
end

function SkillComboManager:CheckComboCondition(skillid)
  local skillinfo = Game.LogicManager_Skill:GetSkillInfo(skillid)
  if not skillinfo then
    return false
  end
  local conditinSkillID = skillinfo:GetComboConditionSkill()
  if not conditinSkillID then
    return true
  end
  return SkillProxy.Instance:HasLearnedSkillBySort(conditinSkillID)
end
