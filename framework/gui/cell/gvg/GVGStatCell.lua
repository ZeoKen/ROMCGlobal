GVGStatCell = class("GVGStatCell", BaseCell)

function GVGStatCell:Init()
  self:FindObjs()
end

function GVGStatCell:FindObjs()
  self.dataTable = self:FindComponent("DataTable", UITable)
  self.professionIcon = self:FindComponent("Career", UISprite, self.dataTable.gameObject)
  self.nameLabel = self:FindComponent("Data1", UILabel, self.dataTable.gameObject)
  self.nameLabel.skipTranslation = true
end

function GVGStatCell:SetData(data)
  self.data = data
  if data then
    self.nameLabel.text = data.name or ""
    local config = Table_Class[data.profession]
    if config then
      IconManager:SetProfessionIcon(config.icon, self.professionIcon)
    end
    self.nameLabel:ProcessText()
    self.dataTable:Reposition()
  end
end
