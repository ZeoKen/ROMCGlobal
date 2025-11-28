PetComposePreviewPopUp = class("PetComposePreviewPopUp", ContainerView)
PetComposePreviewPopUp.ViewType = UIViewType.PopUpLayer
autoImport("PetComposePreviewCell")
PetComposePreviewPopUp.CellResID = ResourcePathHelper.UICell("PetComposePreviewCell")
local TEX = {
  "pet_bg_bg02",
  "pet_bg_bg03",
  "pet_bg_bg04"
}

function PetComposePreviewPopUp:Init(parent)
  self.petID = self.viewdata.viewdata
  self:FindObjs()
  self:SetData()
end

function PetComposePreviewPopUp:FindObjs()
  self.rootIcon = self:FindComponent("Root", UISprite)
  self:InitTex()
end

function PetComposePreviewPopUp:InitTex()
  self.petbg2 = self:FindComponent("petbg2", UITexture)
  self.petbg3 = self:FindComponent("petbg3", UITexture)
  self.petbg4 = self:FindComponent("petbg4", UITexture)
  PictureManager.Instance:SetUI(TEX[1], self.petbg2)
  PictureManager.Instance:SetUI(TEX[2], self.petbg3)
  PictureManager.Instance:SetUI(TEX[3], self.petbg4)
end

local tempVector3 = LuaVector3.Zero()

function PetComposePreviewPopUp:SetData()
  if self.petID then
    self.gameObject:SetActive(true)
    IconManager:SetNpcMonsterIconByID(self.petID, self.rootIcon)
    local obj = Game.AssetManager_UI:CreateAsset(PetComposePreviewPopUp.CellResID, self.gameObject)
    tempVector3[2] = -288
    obj.transform.localPosition = tempVector3
    obj.transform:SetParent(self.rootIcon.gameObject.transform, false)
    self.root = PetComposePreviewCell.new(obj, self.petID, true)
    local nodeLvCount = self.root.data:GetNodeLevel()
    if 1 < nodeLvCount then
      tempVector3[2] = 209
    else
      tempVector3[2] = 155
    end
    self.rootIcon.gameObject.transform.localPosition = tempVector3
  else
    self.gameObject:SetActive(false)
  end
end
