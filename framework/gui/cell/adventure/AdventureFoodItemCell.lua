autoImport("BaseCell")
AdventureFoodItemCell = class("AdventureFoodItemCell", ItemCell)

function AdventureFoodItemCell:Init()
  self.unlockClient = self:FindGO("unlockClient"):GetComponent(UISprite)
  self.BagChooseSymbol = self:FindGO("BagChooseSymbol")
  self.effectContainer = self:FindGO("EffectContainer")
  self.canMake = self:FindGO("CanMake")
  self.itemObj = self:LoadPreferb("cell/ItemCell", self.gameObject)
  self.itemObj.transform.localPosition = LuaGeometry.GetTempVector3()
  AdventureFoodItemCell.super.Init(self)
  self:AddCellClickEvent()
end

function AdventureFoodItemCell:setIsSelected(isSelected)
  if self.isSelected ~= isSelected then
    self.isSelected = isSelected
    if isSelected then
      self:Show(self.BagChooseSymbol)
    else
      self:Hide(self.BagChooseSymbol)
    end
  end
end

function AdventureFoodItemCell:SetData(data)
  self.itemObj:SetActive(true)
  local itemData
  if data then
    itemData = data.itemData
  end
  AdventureFoodItemCell.super.SetData(self, itemData)
  self.data = data
  if not data then
    self.canMake:SetActive(false)
    self.unlockClient.gameObject:SetActive(false)
    return
  end
  self:PassEvent(AdventureFoodPage.CheckHashSelected, self)
  if data.status == SceneFood_pb.EFOODSTATUS_ADD then
    self.unlockClient.gameObject:SetActive(true)
    self:SetIconlocked(true)
    self.foodStars[0]:SetActive(true)
  elseif data.status == SceneFood_pb.EFOODSTATUS_CLICKED then
    self.unlockClient.gameObject:SetActive(false)
    self.foodStars[0]:SetActive(true)
    self:SetIconlocked(false)
  else
    self.unlockClient.gameObject:SetActive(false)
    self:SetIconlocked(true)
  end
  self:SetCanMake(itemData)
end

function AdventureFoodItemCell:SetCanMake(itemData)
  local foodIns, status = FunctionFood.Me(), self.data and self.data.status
  local recipe = foodIns:GetRecipeByFoodId(itemData.staticData.id)
  self.canMake:SetActive(status ~= SceneFood_pb.EFOODSTATUS_CLICKED and recipe ~= nil and foodIns:Match_MakeNum(recipe.id) > 0)
end

function AdventureFoodItemCell:PlayUnlockEffect()
  self:PlayUIEffect(EffectMap.UI.Activation, self.effectContainer, true)
  self:SetIconlocked(false)
end

function AdventureFoodItemCell:SetActiveSymbol(active)
end

function AdventureFoodItemCell:SetQuestIcon(itemType)
end

function AdventureFoodItemCell:SetShopCorner(itemType)
end

function AdventureFoodItemCell:SetPetFlag(itemType)
end

function AdventureFoodItemCell:SetUseItemInvalid(data)
end

function AdventureFoodItemCell:SetInvalid(b)
end

function AdventureFoodItemCell:SetLimitTimeCorner(data)
end

function AdventureFoodItemCell:UpdateNumLabel(scount, x, y, z)
end
