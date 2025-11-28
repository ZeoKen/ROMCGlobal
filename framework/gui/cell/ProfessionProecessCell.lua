BaseCell = autoImport("BaseCell")
ProfessionProecessCell = class("ProfessionProecessCell", BaseCell)

function ProfessionProecessCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end

function ProfessionProecessCell:FindObjs()
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
  self.processName = self:FindGO("Name"):GetComponent(UILabel)
  self.processLabel = self:FindGO("ProcessLabel"):GetComponent(UILabel)
end

function ProfessionProecessCell:SetData(data)
  self.data = data
  self.staticData = data.staticData
  local icon = self.staticData.Icon
  IconManager:SetUIIcon(icon, self.icon)
  local name = self.staticData.Name
  self.processName.text = name
  local curValue = data.curValue
  local maxValue = data.maxValue
  local str = ""
  if data.isPercent then
    if maxValue then
      str = math.floor(curValue / maxValue * 100) .. "%"
    else
      str = curValue .. "%"
    end
  else
    str = curValue .. "/" .. maxValue
  end
  self.processLabel.text = str
end
