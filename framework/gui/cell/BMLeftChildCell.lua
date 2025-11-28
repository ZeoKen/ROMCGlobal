local BaseCell = autoImport("BaseCell")
BMLeftChildCell = class("BMLeftChildCell", BaseCell)
BMLeftChildCell.ChooseColor = Color(0.9137254901960784, 0.5294117647058824, 0.06274509803921569)
BMLeftChildCell.NormalColor = Color(0.13333333333333333, 0.13333333333333333, 0.13333333333333333)
BMLeftChildCell.ChooseImgColor = Color(0.2196078431372549, 0.2196078431372549, 0.2196078431372549)
BMLeftChildCell.NormalImgColor = Color(0, 0, 0, 1)

function BMLeftChildCell:Init()
  self.label = self:FindComponent("Label", UILabel)
  self.Img = self:FindComponent("Img", UISprite)
  self:AddCellClickEvent()
  self.choose = false
end

function BMLeftChildCell:SetData(data)
  self.data = data
  if data.NameZh then
    self.label.text = data.NameZh
  end
  if data.Name then
    self.label.text = data.Name
  end
end

function BMLeftChildCell:SetLabelName(str)
  self.label.text = str
end

function BMLeftChildCell:IsChoose()
  return self.choose
end

function BMLeftChildCell:SetChoose(choose)
  self.choose = choose
  if self.label then
    self.label.color = self.choose and BMLeftChildCell.ChooseColor or BMLeftChildCell.NormalColor
    self.Img.color = self.choose and BMLeftChildCell.ChooseImgColor or BMLeftChildCell.NormalImgColor
  end
end

function BMLeftChildCell:GetData()
  return self.data
end
