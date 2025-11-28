local BaseCell = autoImport("BaseCell")
SettingViewToggleCell = class("SettingViewToggleCell", BaseCell)

function SettingViewToggleCell:Init()
  self.tog = self.gameObject:GetComponent(UIToggle)
  self.label = self.gameObject:GetComponent(UILabel)
  self.line = self:FindGO("Line")
  self:AddCellClickEvent()
end

function SettingViewToggleCell:SetData(data)
  self.label.text = data.Title
end

function SettingViewToggleCell:SetActive(b)
  if b then
    self.tog.value = true
    self.label.fontSize = 24
    local _, c = ColorUtil.TryParseHexString("497cc2")
    self.label.color = c
    self.line:SetActive(true)
  else
    self.tog.value = false
    self.label.fontSize = 22
    local _, c = ColorUtil.TryParseHexString("899398")
    self.label.color = c
    self.line:SetActive(false)
  end
end
