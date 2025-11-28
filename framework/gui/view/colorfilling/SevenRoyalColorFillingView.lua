autoImport("ColorFillingView")
SevenRoyalColorFillingView = class("SevenRoyalColorFillingView", ColorFillingView)
SevenRoyalColorFillingView.ViewType = UIViewType.NormalLayer
local area0_bg = "qws_pic_a_aback"
local decoration_bg1 = "Sevenroyalfamilies_bg_decoration15"
local decoration_bg2 = "Sevenroyalfamilies_bg_decoration21"
local decoration_bg3 = "calendar_bg1_picture2"

function SevenRoyalColorFillingView:InitView()
  SevenRoyalColorFillingView.super.InitView(self)
  self.areaBg = self:FindComponent("area0_bg", UITexture)
  self.decorationBg1 = self:FindComponent("bg4", UITexture)
  self.decorationBg2 = self:FindComponent("bg11", UITexture)
  self.decorationBg3 = self:FindComponent("bg12", UITexture)
end

function SevenRoyalColorFillingView:LoadFillingAreaBg()
  SevenRoyalColorFillingView.super.LoadFillingAreaBg(self)
  PictureManager.Instance:SetColorFillingTexture(area0_bg, self.areaBg)
  PictureManager.Instance:SetSevenRoyalFamiliesTexture(decoration_bg1, self.decorationBg1)
  PictureManager.Instance:SetSevenRoyalFamiliesTexture(decoration_bg2, self.decorationBg2)
  PictureManager.Instance:SetUI(decoration_bg3, self.decorationBg3)
end

function SevenRoyalColorFillingView:UnloadFillingAreaBg()
  SevenRoyalColorFillingView.super.UnloadFillingAreaBg(self)
  PictureManager.Instance:UnloadColorFillingTexture(area0_bg, self.areaBg)
  PictureManager.Instance:UnloadSevenRoyalFamiliesTexture(decoration_bg1, self.decorationBg1)
  PictureManager.Instance:UnloadSevenRoyalFamiliesTexture(decoration_bg2, self.decorationBg2)
  PictureManager.Instance:UnLoadUI(decoration_bg3, self.decorationBg3)
end
