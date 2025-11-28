local BaseCell = autoImport("BaseCell")
BMTopToggleCell = class("BMTopToggleCell", BaseCell)

function BMTopToggleCell:Init()
  self.Label1 = self:FindGO("Label1")
  self.Label2 = self:FindGO("Label2")
  self.Label1_UILabel = self.Label1:GetComponent(UILabel)
  self.Label2_UILabel = self.Label2:GetComponent(UILabel)
  self:AddClickEvent(self.gameObject, function(obj)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function BMTopToggleCell:setSelected(isSelected)
  self.isSelected = isSelected
end

function BMTopToggleCell:SetData(data)
  self.data = data
  self.Label1_UILabel.text = data.NameZh
  self.Label2_UILabel.text = data.NameZh
  self:SetChoose(false)
end

function BMTopToggleCell:IsChoose()
  return self.choose
end

function BMTopToggleCell:SetChoose(choose)
  self.choose = choose
  if choose then
    self.Label1.gameObject:SetActive(false)
    self.Label2.gameObject:SetActive(true)
  else
    self.Label1.gameObject:SetActive(true)
    self.Label2.gameObject:SetActive(false)
  end
end

function BMTopToggleCell:GetData()
  return self.data
end
