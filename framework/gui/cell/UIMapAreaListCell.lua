local baseCell = autoImport("BaseCell")
UIMapAreaListCell = class("UIMapAreaListCell", baseCell)

function UIMapAreaListCell:Init()
  self.labName = self:FindGO("Name"):GetComponent(UILabel)
  self.goCurrency = self:FindGO("Currency")
  local l_zenyIcon = self:FindComponent("Icon", UISprite, self.goCurrency)
  IconManager:SetItemIcon(Table_Item[100].Icon, l_zenyIcon)
  self.goTransfer = self:FindGO("Transfer")
  self.goCurrency:SetActive(false)
  self.goTransfer:SetActive(false)
  self:AddCellClickEvent()
end

function UIMapAreaListCell:SetData(data)
  self.data = data
  self.labName.text = data.name
  if AppBundleConfig.GetSDKLang() == "pt" then
    self.labName.text = self.labName.text:gsub("Área", ""):gsub(" ", "")
  end
end
