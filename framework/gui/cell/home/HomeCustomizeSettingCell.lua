HomeCustomizeSettingCell = class("HomeCustomizeSettingCell", BaseCell)

function HomeCustomizeSettingCell:Init()
  HomeCustomizeSettingCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
end

function HomeCustomizeSettingCell:FindObjs()
  self.labTitle = self:FindComponent("Title", UILabel)
  self.toggle = self.gameObject:GetComponent(UIToggle)
end

function HomeCustomizeSettingCell:AddEvts()
end

function HomeCustomizeSettingCell:SetData(data)
  self.id = data
  self.labTitle.text = HomeProxy.Instance:GetSimpleItemTypeName(self.id)
end

function HomeCustomizeSettingCell:RefreshStatus(isSelect)
  self.toggle.value = isSelect
end
