autoImport("PveSkillCell")
PvePhaseCell = class("PvePhaseCell", BaseCell)

function PvePhaseCell:Init()
  PvePhaseCell.super.Init(self)
  self:FindObj()
end

function PvePhaseCell:FindObj()
  self.uitable = self.gameObject:GetComponent(UITable)
  self.phaseLab = self:FindComponent("PhaseLab", UILabel)
  self.phaseDescLab = self:FindComponent("PhaseDescLab", UILabel, self.phaseLab.gameObject)
  self.descLab = self:FindComponent("DescLab", UILabel)
  local skillTable = self:FindComponent("Table", UITable)
  self.skillCtl = UIGridListCtrl.new(skillTable, PveSkillCell, "PveSkillCell")
end

function PvePhaseCell:SetData(skill_content_id)
  local staticData = Table_PveMonsterSkillContent[skill_content_id]
  if not staticData then
    redlog("请检查配置 Table_PveMonsterSkillContent ，errorID : ", skill_content_id)
    return
  end
  self.data = skill_content_id
  if StringUtil.IsEmpty(staticData.Title) then
    self.phaseLab.enabled = false
  else
    self.phaseLab.enabled = true
    self.phaseLab.text = staticData.Title
  end
  if StringUtil.IsEmpty(staticData.Condition) then
    self.phaseDescLab.enabled = false
  else
    self.phaseDescLab.enabled = true
    self.phaseDescLab.text = staticData.Condition
    self.phaseDescLab.transform.localPosition = LuaGeometry.GetTempVector3(self.phaseLab.width + 10, 0)
  end
  self.descLab.text = staticData.Desc
  self.skillCtl:ResetDatas(staticData.Skill, nil, true)
  self.uitable:Reposition()
end
