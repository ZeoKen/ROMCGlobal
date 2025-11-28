local BaseCell = autoImport("BaseCell")
PhotoChooseCell = class("PhotoChooseCell", BaseCell)

function PhotoChooseCell:Init()
  PhotoChooseCell.super.Init(self)
  self:FindObjs()
  self:AddCellClickEvent()
end

function PhotoChooseCell:FindObjs()
  self.texture = self:FindGO("Texture"):GetComponent(UITexture)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.tweenScale = self.gameObject:GetComponent(TweenScale)
  self.nameLabel = self:FindGO("Label"):GetComponent(UILabel)
  self.nameLabelBG = self:FindGO("LabelBG"):GetComponent(UISprite)
end

function PhotoChooseCell:SetData(data)
  self.chooseSymbol:SetActive(false)
  if type(data) == "string" then
    self.texPath = data
    self.nameLabel.gameObject:SetActive(false)
  else
    self.texPath = data and data[2]
    xdlog("图片资源", self.texPath)
    if data and data[1] ~= "" then
      self.nameLabel.gameObject:SetActive(true)
      self.nameLabel.text = data[1]
    end
  end
  self.nameLabelBG.width = self.nameLabel.printedSize.x + 70
  PictureManager.Instance:SetSevenRoyalFamiliesTexture(self.texPath, self.texture)
end

function PhotoChooseCell:SetChoose(bool)
  self.chooseSymbol:SetActive(bool)
  xdlog("SetChoose", bool)
  if bool then
    self.tweenScale:PlayForward()
    self.nameLabel.color = LuaGeometry.GetTempVector4(1, 0.4823529411764706, 0.4823529411764706, 1)
    self.nameLabel.effectColor = LuaGeometry.GetTempVector4(0.24705882352941178, 0.0196078431372549, 0.011764705882352941, 1)
    self.nameLabelBG.color = LuaGeometry.GetTempVector4(0.7098039215686275, 0, 0, 1)
  else
    self.tweenScale:ResetToBeginning()
    self.tweenScale.enabled = false
    self.nameLabel.color = LuaGeometry.GetTempVector4(0.9137254901960784, 0.9921568627450981, 1, 1)
    self.nameLabel.effectColor = LuaGeometry.GetTempVector4(0.11764705882352941, 0.11764705882352941, 0.2235294117647059, 1)
    self.nameLabelBG.color = LuaGeometry.GetTempVector4(0.30980392156862746, 0.32941176470588235, 0.8823529411764706, 1)
  end
end

function PhotoChooseCell:OnDestroy()
  if self.texPath then
    PictureManager.Instance:UnloadSevenRoyalFamiliesTexture(self.texPath, self.texture)
  end
end
