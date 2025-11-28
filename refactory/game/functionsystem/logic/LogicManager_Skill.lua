autoImport("SkillHitWorker")
autoImport("SkillComboHitWorker")
autoImport("SkillComboEmitWorker")
autoImport("SubSkillProjectile")
autoImport("SkillLogic_Base")
autoImport("SkillLogic_TargetNone")
autoImport("SkillLogic_TargetCreature")
autoImport("SkillLogic_TargetPoint")
autoImport("SkillTargetBehindRect")
autoImport("SkillInfo")
autoImport("SkillHitWork_Delay")
autoImport("SkillPhaseData")
autoImport("SkillBase")
autoImport("ServerSkill")
autoImport("ClientSkill")
autoImport("SkillFreeCast")
autoImport("SkillFreeCast_Client")
autoImport("SkillSolo")
autoImport("SkillLogic_TargetPoint_Normal")
LogicManager_Skill = class("LogicManager_Skill")

function LogicManager_Skill:ctor()
  self.logicClassMap = {}
  self.logicClassMap.SkillNone = autoImport("SkillLogic_None")
  self.logicClassMap.SkillSelfRange = autoImport("SkillLogic_SelfRange")
  self.logicClassMap.SkillForwardRect = autoImport("SkillLogic_ForwardRect")
  self.logicClassMap.SkillTargetBehindRect = autoImport("SkillTargetBehindRect")
  self.logicClassMap.SkillMountTransform = autoImport("SkillLogic_MountTransform")
  self.logicClassMap.SkillPointRange = autoImport("SkillLogic_PointRange")
  self.logicClassMap.SkillPointRect = autoImport("SkillLogic_PointRect")
  self.logicClassMap.SkillRandomRange = autoImport("SkillLogic_RandomRange")
  self.logicClassMap.SkillDirectionRect = autoImport("SkillLogic_DirectionRect")
  self.logicClassMap.SkillCenterRange = autoImport("SkillLogic_RandomRange")
  self.logicClassMap.SkillTargetCross = autoImport("SkillLogic_SelfRange")
  self.logicClassMap.SkillMeToPointRect = autoImport("SkillLogic_PointRange")
  self.logicClassMap.TransferServe = autoImport("SkillLogic_PointRange")
  self.logicClassMap.SkillLockedTarget = autoImport("SkillLogic_Single")
  self.logicClassMap.SkillTargetRect = autoImport("SkillLogic_TargetRect")
  self.logicClassMap.SkillTargetPoint = autoImport("SkillLogic_TargetPoint_Normal")
  self.logicClassMap.MultiLockedTarget = autoImport("SkillLogic_Single")
  self.skillInfoMap = {}
end

function LogicManager_Skill:GetLogic(name)
  return self.logicClassMap[name]
end

function LogicManager_Skill:GetSkillInfo(skillID)
  if skillID == 0 then
    return nil
  end
  local skill = self.skillInfoMap[skillID]
  if skill == nil then
    local data = Table_Skill[skillID]
    if data ~= nil then
      skill = SkillInfo.new(data, self:GetLogic(data.Logic or "SkillNone"))
      self.skillInfoMap[skillID] = skill
    end
  end
  return skill
end

function LogicManager_Skill:Update(time, deltaTime)
end

function LogicManager_Skill:CheckInstantAttack(skillid)
  local skillinfo = self:GetSkillInfo(skillid)
  if skillinfo then
    return skillinfo:CheckInstantAttack()
  else
    return false
  end
end
