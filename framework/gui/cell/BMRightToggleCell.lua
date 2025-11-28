local BaseCell = autoImport("BaseCell")
BMRightToggleCell = class("BMRightToggleCell", BaseCell)
BMRightToggleCell.ChooseColor = Color(0.10588235294117647, 0.3686274509803922, 0.6941176470588235)
BMRightToggleCell.NormalColor = Color(0.13333333333333333, 0.13333333333333333, 0.13333333333333333)
BMRightToggleCell.ChooseImgColor = Color(0, 0, 0, 1)
BMRightToggleCell.NormalImgColor = Color(0.12156862745098039, 0.4549019607843137, 0.7490196078431373)

function BMRightToggleCell:Init()
  self.label = self:FindComponent("Label", UILabel)
  self.Img = self:FindComponent("Img", UISprite)
  self:AddCellClickEvent()
  self.choose = false
  self.sprite1 = self:FindGO("sprite1")
  self.sprite2 = self:FindGO("sprite2")
  self.sprite1_spriteCenter = self:FindGO("spriteCenter", self.sprite1)
  self.sprite1_Label1 = self:FindGO("Label1", self.sprite1)
  self.sprite1_spriteCenter_UISprite = self.sprite1_spriteCenter:GetComponent(UISprite)
  self.sprite1_Label1_UILabel = self.sprite1_Label1:GetComponent(UILabel)
  self.sprite2_spriteCenter = self:FindGO("spriteCenter", self.sprite2)
  self.sprite2_Label1 = self:FindGO("Label1", self.sprite2)
  self.sprite2_spriteCenter_UISprite = self.sprite2_spriteCenter:GetComponent(UISprite)
  self.sprite2_Label1_UILabel = self.sprite2_Label1:GetComponent(UILabel)
  self:AddClickEvent(self.gameObject, function(obj)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function BMRightToggleCell:SetData(data)
  self.data = data
  self.sprite1_Label1_UILabel.text = data.NameZh
  self.sprite2_Label1_UILabel.text = data.NameZh
  local atla = RO.AtlasMap.GetAtlas("NewUI4")
  self.sprite1_spriteCenter_UISprite.atlas = atla
  self.sprite1_spriteCenter_UISprite.spriteName = data.iconName_yellow
  self.sprite2_spriteCenter_UISprite.atlas = atla
  self.sprite2_spriteCenter_UISprite.spriteName = data.iconName_blue
end

function BMRightToggleCell:SetLabelName(str)
  self.label.text = str
end

function BMRightToggleCell:IsChoose()
  return self.choose
end

function BMRightToggleCell:SetChoose(choose)
  self.choose = choose
  self.label.color = self.choose and BMRightToggleCell.ChooseColor or BMRightToggleCell.NormalColor
  self.Img.color = self.choose and BMRightToggleCell.ChooseImgColor or BMRightToggleCell.NormalImgColor
end

function BMRightToggleCell:GetData()
  return self.data
end
