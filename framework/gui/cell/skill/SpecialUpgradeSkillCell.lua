SpecialUpgradeSkillCell = class("SpecialUpgradeSkillCell", SkillBaseCell)

function SpecialUpgradeSkillCell:Init()
  self:FindObjs()
end

function SpecialUpgradeSkillCell:FindObjs()
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self.icon = self.gameObject:GetComponent(UISprite)
  self.levelLabel = self:FindComponent("Level", UILabel)
  self.selectGO = self:FindGO("Selected")
end

function SpecialUpgradeSkillCell:SetData(data)
  self.data = data
  self.upgradeStaticData = Table_KnightSkill[data:GetSortID()]
  IconManager:SetSkillIconByProfess(data.staticData.Icon, self.icon, 0)
  self.levelLabel.text = data.level .. "/" .. data.maxLevel
  local isLocked = self:IsLocked()
  self:EnableGrey(isLocked)
end

function SpecialUpgradeSkillCell:GetUpgradeCostItem()
  if self.upgradeStaticData then
    local costTable = self.upgradeStaticData.LvUpCost
    return self.upgradeStaticData.LvUpItem, costTable[self.data.level + 1]
  end
end

function SpecialUpgradeSkillCell:GetActiveDesc()
  if self.upgradeStaticData then
    return self.upgradeStaticData.Desc
  end
end

function SpecialUpgradeSkillCell:GetCurSkillDesc()
  return SkillProxy.GetDesc(self.data.id)
end

function SpecialUpgradeSkillCell:GetNextSkillDesc()
  local nextId = self.data:GetNextID()
  return SkillProxy.GetDesc(nextId)
end

function SpecialUpgradeSkillCell:SetSelectState(state)
  self.selectGO:SetActive(state)
end

function SpecialUpgradeSkillCell:IsLocked()
  return self.data.level == 0
end

function SpecialUpgradeSkillCell:IsMaxLevel()
  return self.data.level == self.data.maxLevel
end

function SpecialUpgradeSkillCell:EnableGrey(value)
  if value then
    ColorUtil.ShaderGrayUIWidget(self.icon)
    self.icon.alpha = 0.5
  else
    ColorUtil.WhiteUIWidget(self.icon)
    self.icon.alpha = 1
  end
end
