local baseCell = autoImport("BaseCell")
AdventureHomeUserDataCell = class("AdventureHomeUserDataCell", baseCell)

function AdventureHomeUserDataCell:Init()
  self:FindObjs()
end

function AdventureHomeUserDataCell:FindObjs()
  self.title = self:FindComponent("Title", UILabel)
  self.value = self:FindComponent("Attr", UILabel)
end

function AdventureHomeUserDataCell:SetData(data)
  self.cellData = data
  if data then
    local value = data.value
    local propStaticData = data.prop
    local name = propStaticData.PropName
    local symbol = ""
    if value < 0 then
      symbol = "-"
    elseif 0 < value then
      symbol = "+"
    end
    if propStaticData.IsPercent == 1 then
      value = string.format("%.1f%%", value * 100)
    else
      value = math.floor(value)
    end
    self.title.text = name
    self.value.text = symbol .. value
  end
end
