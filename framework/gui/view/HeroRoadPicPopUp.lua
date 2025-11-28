HeroRoadPicPopUp = class("HeroRoadPicPopUp", ContainerView)
HeroRoadPicPopUp.ViewType = UIViewType.PopUpLayer

function HeroRoadPicPopUp:Init()
  self:InitData()
  self:FindObjs()
end

function HeroRoadPicPopUp:InitData()
  self.id = self.viewdata and self.viewdata.viewdata
end

function HeroRoadPicPopUp:FindObjs()
  self:AddButtonEvent("CloseBtn", function()
    self:CloseSelf()
  end)
  self.picTex = self:FindComponent("Picture", UITexture)
  self.nameLabel = self:FindComponent("Name", UILabel)
end

function HeroRoadPicPopUp:OnEnter()
  local config = Table_HeroJourneyNode[self.id]
  if config then
    self.picName = config.Picture_L
    self.nameLabel.text = config.PictureName
    if not StringUtil.IsEmpty(self.picName) then
      PictureManager.Instance:SetHeroRoadTexture(self.picName, self.picTex)
    end
  end
end

function HeroRoadPicPopUp:OnExit()
  if not StringUtil.IsEmpty(self.picName) then
    PictureManager.Instance:UnloadHeroRoadTexture(self.picName, self.picTex)
  end
end
