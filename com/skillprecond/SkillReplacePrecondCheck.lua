autoImport("SkillPrecondCheck")
SkillReplacePrecondCheck = class("SkillReplacePrecondCheck", SkillPrecondCheck)

function SkillReplacePrecondCheck:Init()
  self.notFitReasonType = {}
  self.checkReason = ConditionCheck.new()
  self.checkReason:SetReason(SkillPrecondCheck.CheckReason.Skill)
  local id = self.skillItemData and self.skillItemData:GetID() or 0
  self.skillItemData = SkillItemData.new(id)
end

function SkillReplacePrecondCheck:ReInitBySkillItemData(skillItemData)
  local staticID = skillItemData:GetID()
  if staticID == self.curSkillStaticID and self.conditionCheck then
    self.conditionCheck:Reset()
    return
  end
  self.skillItemData:Reset(staticID, skillItemData.pos, nil, nil, skillItemData.sourceId)
  self:ReInit()
  self.curSkillStaticID = staticID
end

function SkillReplacePrecondCheck:ReInit()
  local staticData = self.skillItemData:GetStaticData()
  if not staticData then
    return
  end
  TableUtility.TableClear(self.notFitReasonType)
  self:SetSkillStaticData(staticData)
  self.skillItemData:SetFitPreCond(true)
end

function SkillReplacePrecondCheck:SetCheckReason(reason)
end

function SkillReplacePrecondCheck:RemoveCheckReason(reason)
end
