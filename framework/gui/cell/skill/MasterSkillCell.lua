autoImport("SkillCell")
MasterSkillCell = class("MasterSkillCell", SkillCell)
MasterSkillCell.SimulationUpgrade = "MasterSkillCell_SimulationUpgrade"
MasterSkillCell.SimulationDowngrade = "MasterSkillCell_SimulationDowngrade"

function MasterSkillCell:InitCell()
  MasterSkillCell.super.InitCell(self)
  self.maskBg = self.clickCell:GetComponent(UIMultiSprite)
  self.skillCellGO = self:FindGO("SkillCell")
  self.emptyGO = self:FindGO("Empty")
end

function MasterSkillCell:AddSimulateButtonEvent()
  self:AddClickEvent(self.upgradeBtn.gameObject, function()
    self:PassEvent(MasterSkillCell.SimulationUpgrade, self)
  end)
  self:AddClickEvent(self.levelDelBtn.gameObject, function()
    self:PassEvent(MasterSkillCell.SimulationDowngrade, self)
  end)
end

function MasterSkillCell:SetData(data)
  if data ~= SkillItemData.Empty then
    MasterSkillCell.super.SetData(self, data)
    self:UpdateMaskBg()
  else
    self.data = nil
  end
  self.skillCellGO:SetActive(data ~= SkillItemData.Empty)
  self.emptyGO:SetActive(data == SkillItemData.Empty)
end

function MasterSkillCell:UpdateMaskBg()
  local config = Table_SkillMould[self.data.sortID * 1000 + 1]
  if config and config.Atktype and config.Atktype == 1 then
    self.maskBg.CurrentState = 0
  else
    self.maskBg.CurrentState = 1
  end
end

function MasterSkillCell:UpdateUpgradeBtn(skillData)
  if self.data:GetNextID(SkillProxy.Instance:GetSkillCanBreak()) ~= nil and self.data.active then
    self:ShowUpgrade(true)
  else
    self:ShowUpgrade(false)
  end
end

function MasterSkillCell:GetGridXY()
  local x, y = MasterSkillCell.super.GetGridXY(self)
  local groupIndex = SkillProxy.Instance:GetMasterSkillGroupIndexByFamilyId(self.data.sortID)
  y = groupIndex + 1
  return x, y
end
