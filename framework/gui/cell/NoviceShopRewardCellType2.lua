autoImport("NoviceShopRewardCell")
NoviceShopRewardCellType2 = class("NoviceShopRewardCellType2", NoviceShopRewardCell)

function NoviceShopRewardCellType2:Init()
  NoviceShopRewardCellType2.super.Init(self)
  self.bgTexture = self:FindGO("BG"):GetComponent(UITexture)
  PictureManager.Instance:SetUI("Noviceactivity_bg5_bottom_03", self.bgTexture)
end

function NoviceShopRewardCellType2:OnCellDestroy()
  PictureManager.Instance:UnLoadUI("Noviceactivity_bg5_bottom_03", self.bgTexture)
end
