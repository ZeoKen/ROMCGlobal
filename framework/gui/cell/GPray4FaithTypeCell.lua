local BaseCell = autoImport("BaseCell")
GPray4FaithTypeCell = class("GPray4FaithTypeCell", BaseCell)

function GPray4FaithTypeCell:Init()
  self.name = self:FindComponent("NameLabel", UILabel)
  self.attriAdd = self:FindComponent("AttriAdd", UILabel)
end

local _format = "%s +%.1f"

function GPray4FaithTypeCell:SetData(data)
  if data then
    self.name.text = OverSea.LangManager.Instance():GetLangByKey(data[1])
    self.attriAdd.text = string.format(_format, data[2], data[3])
  end
end
