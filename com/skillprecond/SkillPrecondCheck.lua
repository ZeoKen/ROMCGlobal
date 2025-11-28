autoImport("ConditionCheck")
SkillPrecondCheck = class("SkillPrecondCheck")
SkillPrecondCheck.PreConditionType = {
  AfterUseSkill = 1,
  WearEquip = 2,
  HpMoreThan = 3,
  MyselfState = 4,
  Partner = 5,
  Buff = 6,
  LearnedSkill = 7,
  BeingState = 8,
  EquipTakeOff = 9,
  EquipBreak = 10,
  Map = 11,
  BuffActive = 12,
  Pet = 13,
  Bullets = 14,
  DressPartMount = 15,
  TargetHpLessThan = 16,
  InterferenceValue = 17,
  IsRideOnTeammate = 18
}
SkillPrecondCheck.CheckReason = {Skill = 1, SubSkill = 2}
local MapMsgID = {
  [SkillPrecondCheck.PreConditionType.AfterUseSkill] = 609,
  [SkillPrecondCheck.PreConditionType.WearEquip] = 609,
  [SkillPrecondCheck.PreConditionType.HpMoreThan] = 609,
  [SkillPrecondCheck.PreConditionType.MyselfState] = 609,
  [SkillPrecondCheck.PreConditionType.Partner] = 609,
  [SkillPrecondCheck.PreConditionType.Buff] = 609,
  [SkillPrecondCheck.PreConditionType.LearnedSkill] = 609,
  [SkillPrecondCheck.PreConditionType.BeingState] = 609,
  [SkillPrecondCheck.PreConditionType.EquipTakeOff] = 609,
  [SkillPrecondCheck.PreConditionType.EquipBreak] = 609,
  [SkillPrecondCheck.PreConditionType.Map] = 609,
  [SkillPrecondCheck.PreConditionType.BuffActive] = 609,
  [SkillPrecondCheck.PreConditionType.Pet] = 609,
  [SkillPrecondCheck.PreConditionType.Bullets] = 609,
  [SkillPrecondCheck.PreConditionType.DressPartMount] = 43254,
  [SkillPrecondCheck.PreConditionType.TargetHpLessThan] = 609,
  [SkillPrecondCheck.PreConditionType.InterferenceValue] = 609,
  [SkillPrecondCheck.PreConditionType.IsRideOnTeammate] = 609
}

function SkillPrecondCheck:ctor(skillItemData)
  self.skillItemData = skillItemData
  self:Init()
  self:ReInit()
end

function SkillPrecondCheck:Init()
end

function SkillPrecondCheck:ReInit()
  self.notFitReasonType = {}
  self:SetSkillStaticData(self.skillItemData.staticData)
  self.checkReason = ConditionCheck.new()
end

function SkillPrecondCheck:SetSkillStaticData(staticData)
  if staticData.PreCondition.both and staticData.PreCondition.both == 1 then
    self.conditionCheck = LogicalConditionCheckWithDirty.new(LogicalConditionCheckWithDirty.And)
  else
    self.conditionCheck = LogicalConditionCheckWithDirty.new(LogicalConditionCheckWithDirty.Or)
  end
  for i = 1, #staticData.PreCondition do
    self.conditionCheck:RemoveReason(self:GetKey(staticData.PreCondition[i]))
  end
end

function SkillPrecondCheck:GetKey(preCond)
  if preCond.type == SkillPrecondCheck.PreConditionType.AfterUseSkill then
    return preCond.type .. "_" .. preCond.skillid
  elseif preCond.type == SkillPrecondCheck.PreConditionType.WearEquip then
    local itemtype = preCond.itemtype or ""
    local itemid = preCond.itemid or ""
    local equipFeature = preCond.equipFeature or ""
    return preCond.type .. "_" .. itemtype .. "_" .. itemid .. "_" .. equipFeature
  elseif preCond.type == SkillPrecondCheck.PreConditionType.HpMoreThan then
    return preCond.type .. "_" .. (preCond.value or preCond.spvalue)
  elseif preCond.type == SkillPrecondCheck.PreConditionType.MyselfState or preCond.type == SkillPrecondCheck.PreConditionType.BeingState then
    local propName
    for k, v in pairs(preCond) do
      if k ~= "type" then
        propName = k
        break
      end
    end
    return preCond.type .. "_" .. propName
  elseif preCond.type == SkillPrecondCheck.PreConditionType.Partner then
    return preCond.type
  elseif preCond.type == SkillPrecondCheck.PreConditionType.EquipTakeOff or preCond.type == SkillPrecondCheck.PreConditionType.EquipBreak then
    return preCond.type .. "_" .. preCond.value
  elseif preCond.type == SkillPrecondCheck.PreConditionType.Buff then
    local layer = preCond.layer or ""
    return preCond.type .. "_" .. preCond.id .. "_" .. layer
  elseif preCond.type == SkillPrecondCheck.PreConditionType.Map then
    return preCond.type .. "_" .. preCond.id
  elseif preCond.type == SkillPrecondCheck.PreConditionType.BuffActive then
    return preCond.type .. "_" .. preCond.buffid
  elseif preCond.type == SkillPrecondCheck.PreConditionType.Pet then
    return preCond.type .. "_" .. preCond.npctype
  elseif preCond.type == SkillPrecondCheck.PreConditionType.Bullets then
    return preCond.type .. "_" .. preCond.num
  elseif preCond.type == SkillPrecondCheck.PreConditionType.DressPartMount then
    local feature = preCond.equipFeature or ""
    return preCond.type .. "_" .. feature
  elseif preCond.type == SkillPrecondCheck.PreConditionType.TargetHpLessThan then
    return preCond.type .. "_" .. (preCond.hpvalue or preCond.spvalue)
  elseif preCond.type == SkillPrecondCheck.PreConditionType.InterferenceValue then
    return preCond.type .. "_" .. preCond.value
  elseif preCond.type == SkillPrecondCheck.PreConditionType.IsRideOnTeammate then
    return preCond.type .. "_" .. preCond.value
  end
  errorLog(string.format("SkillPrecondCheck hasnt support %s type precondition check", preCond.type))
  return "whatfuck?"
end

function SkillPrecondCheck:GetPrecondtionsByType(t)
  if self.skillItemData then
    return self.skillItemData:GetPrecondtionsByType(t)
  end
end

function SkillPrecondCheck:SetReason(preCondition)
  self.notFitReasonType[preCondition.type] = nil
  self.conditionCheck:SetReason(self:GetKey(preCondition))
end

function SkillPrecondCheck:RemoveReason(preCondition)
  self.notFitReasonType[preCondition.type] = preCondition
  self.conditionCheck:RemoveReason(self:GetKey(preCondition))
end

function SkillPrecondCheck:GetFirstReason()
  local index, value = next(self.notFitReasonType)
  return index, value
end

function SkillPrecondCheck:MsgReason()
  local index, value = self:GetFirstReason()
  if index then
    local msgID = MapMsgID[index]
    if index == SkillPrecondCheck.PreConditionType.BeingState then
      if value.not_exist then
        msgID = 614
      elseif value.died then
        msgID = 609
      elseif value.alive then
        msgID = 612
      end
    end
    MsgManager.ShowMsgByIDTable(msgID)
  end
end

function SkillPrecondCheck:HasReason()
  return self.conditionCheck:HasReason()
end

function SkillPrecondCheck:IsDirty()
  return self.conditionCheck:IsDirty()
end

function SkillPrecondCheck:SetCheckReason(reason)
  self.checkReason:SetReason(reason)
end

function SkillPrecondCheck:RemoveCheckReason(reason)
  self.checkReason:RemoveReason(reason)
end

function SkillPrecondCheck:HasCheckReason()
  return self.checkReason:HasReason()
end

function SkillPrecondCheck:Reset()
  self.conditionCheck:Reset()
end
