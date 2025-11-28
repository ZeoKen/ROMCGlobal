HeadwearRaidTowerUpgradeSkillCell = class("HeadwearRaidTowerUpgradeSkillCell", BaseCell)
local cellPfbName = "PetSkillCell"

function HeadwearRaidTowerUpgradeSkillCell:Init()
  self.skillCellParent = self:FindGO("skillCellParent")
  self.skillDesc = self:FindComponent("skillDesc", UILabel)
  self.skillDescsv = self:FindComponent("skillDescScrollview", UIScrollView)
end

function HeadwearRaidTowerUpgradeSkillCell:SetData(data)
  if not self.skillcell then
    local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cellPfbName))
    if cellpfb == nil then
      error("can not find cellpfb" .. cellPfbName)
    end
    cellpfb.transform:SetParent(self.skillCellParent.transform, false)
    self.skillcell = PetSkillCell.new(cellpfb)
  end
  self.skillcell:SetData(data)
  self.skillcell.level.text = ""
  self.skillDesc.text = self:GetDesc(data)
  self.skillDescsv:ResetPosition()
end

function HeadwearRaidTowerUpgradeSkillCell:GetDesc(data)
  local desc = ""
  local config
  data = Table_Skill[data]
  for i = 1, #data.Desc do
    config = data.Desc[i]
    if Table_SkillDesc[config.id] and Table_SkillDesc[config.id].Desc then
      if config.params then
        desc = desc .. string.format(Table_SkillDesc[config.id].Desc, unpack(config.params)) .. (i ~= #data.Desc and "\n" or "")
      else
        desc = desc .. Table_SkillDesc[config.id].Desc .. (i ~= #data.Desc and "\n" or "")
      end
    end
  end
  return desc
end
