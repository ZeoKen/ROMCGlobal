SkadaSettingToggleCell = class("SkadaSettingToggleCell", BaseCell)

function SkadaSettingToggleCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end

function SkadaSettingToggleCell:FindObjs()
  self.labTitle = self:FindComponent("Title", UILabel)
  self.toggle = self:FindComponent("Toggle", UIToggle)
end

function SkadaSettingToggleCell:SetData(data)
  self.data = data
  self.id = data.id
  self.labTitle.text = data.NameZh
end

function SkadaSettingToggleCell:SetIsSelect(isSelect)
  if self.isSelected == isSelect then
    return
  end
  self.toggle.value = isSelect == true
  self.isSelected = isSelect
end
