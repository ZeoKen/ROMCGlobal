GVGBlessCell = class("GVGBlessCell", BaseCell)

function GVGBlessCell:Init()
  self:FindObjs()
end

function GVGBlessCell:FindObjs()
  self.dataTable = self:FindComponent("DataTable", UITable)
  self.professionIcon = self:FindComponent("Career", UISprite)
  self.nameLabel = self:FindComponent("Data1", UILabel)
  self.nameLabel.skipTranslation = true
  self.check = self:FindGO("Check")
  self.checkBg = self:FindGO("CheckBg")
  self:AddButtonEvent("CheckBg", function()
    self:OnBlessSelect()
  end)
end

function GVGBlessCell:SetData(data)
  self.data = data
  if data then
    self.isBlessSelected = data.isBlessSelected
    self.nameLabel.text = data.name or ""
    local config = Table_Class[data.profession]
    if config then
      IconManager:SetProfessionIcon(config.icon, self.professionIcon)
    end
    self.nameLabel:ProcessText()
    self.dataTable:Reposition()
    self.checkBg:SetActive(data.showCheck == true)
    self:SetSelectState(self.isBlessSelected or false)
  end
end

function GVGBlessCell:SetSelectState(state)
  self.isBlessSelected = state
  self.check:SetActive(state)
end

function GVGBlessCell:OnBlessSelect()
  self:SetSelectState(not self.isBlessSelected)
  self:PassEvent(RedPacketEvent.OnBlessSelect, self)
end

function GVGBlessCell:IsSelected()
  return self.isBlessSelected
end
