local BaseCell = autoImport("BaseCell")
BMLeftFatherCell = class("BMLeftFatherCell", BaseCell)
BMLeftFatherCell.ChooseColor = Color(0.10588235294117647, 0.3686274509803922, 0.6941176470588235)
BMLeftFatherCell.NormalColor = Color(0.13333333333333333, 0.13333333333333333, 0.13333333333333333)
BMLeftFatherCell.ChooseImgColor = Color(0.12156862745098039, 0.4549019607843137, 0.7490196078431373)
BMLeftFatherCell.NormalImgColor = Color(0, 0, 0, 1)

function BMLeftFatherCell:Init()
  self.label = self:FindComponent("Label", UILabel)
  self.Img = self:FindComponent("Img", UISprite)
  self.Img2 = self:FindComponent("Img2", UISprite)
  self.Img3 = self:FindComponent("Img3", UISprite)
  self.ImgGrid = self:FindComponent("ImgGrid", UIGrid)
  self:AddCellClickEvent()
  self.choose = false
end

function BMLeftFatherCell:SetData(data)
  self.data = data
  if data.NameZh then
    self.label.text = data.NameZh
  end
  if data.Name then
    self.label.text = data.Name
  end
  if self.Img then
    self.Img.gameObject:SetActive(false)
  end
  if data.isMapIntroCell and data.Img and self.ImgGrid then
    self.Img2.gameObject:SetActive(false)
    self.Img3.gameObject:SetActive(false)
    if data.Img[1] then
      self.Img.gameObject:SetActive(true)
      IconManager:SetMapIcon(data.Img[1], self.Img)
      self.Img.width = 25
      self.Img.height = 25
    end
    if data.Img[2] then
      self.Img2.gameObject:SetActive(true)
      IconManager:SetMapIcon(data.Img[2], self.Img2)
      self.Img2.width = 25
      self.Img2.height = 25
    end
    if data.Img[3] then
      self.Img3.gameObject:SetActive(true)
      IconManager:SetMapIcon(data.Img[3], self.Img3)
      self.Img3.width = 25
      self.Img3.height = 25
    end
    self.ImgGrid:Reposition()
  end
end

function BMLeftFatherCell:GetFatherName()
  if self.data and self.data.NameZh then
    return self.data.NameZh
  else
    return "unknown"
  end
end

function BMLeftFatherCell:IsChoose()
  return self.choose
end

function BMLeftFatherCell:SetChoose(choose)
  self.choose = choose
end

function BMLeftFatherCell:GetData()
  return self.data
end
