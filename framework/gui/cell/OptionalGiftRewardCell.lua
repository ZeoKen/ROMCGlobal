autoImport("TechTreeSandExchangeCell")
OptionalGiftRewardCell = class("OptionalGiftRewardCell", TechTreeSandExchangeCell)
OptionalGiftRewardCell.InputChange = "OptionalGiftRewardCell_InputChange"
OptionalGiftRewardCell.InputSubmit = "OptionalGiftRewardCell_InputSubmit"
local _PACKAGECHECK = {
  1,
  2,
  4,
  6,
  7,
  8,
  9,
  12,
  17
}

function OptionalGiftRewardCell:InitItem()
  local itemCellObjName = "Common_ItemCell"
  local itemContainer = self:FindGO("ItemContainer")
  local itemCell = self:FindGO(itemCellObjName)
  if not itemCell then
    local go = self:LoadPreferb("cell/ItemCell", itemContainer)
    go.name = itemCellObjName
  end
  self:AddClickEvent(itemContainer, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self.adventureStoreStateSp = self:FindComponent("AdventureStoreState", UISprite)
  self.refineLabel = self:FindComponent("refineLV", UILabel)
  self.getSymbol = self:FindGO("GetSymbol")
end

function OptionalGiftRewardCell:SetData(data)
  self.gameObject:SetActive(data ~= nil)
  if not data then
    return
  end
  self.empty:SetActive(false)
  self.rewardId = data[1]
  self.rewardCount = data[2]
  self.refineLV = data.refine_lv
  self.countInput.value = 0
  if self.refineLV and self.refineLV > 0 then
    self.refineLabel.text = string.format("+%d", self.refineLV)
  else
    self.refineLabel.text = ""
  end
  local rewardData = Table_Item[self.rewardId]
  local ret = IconManager:SetItemIcon(rewardData and rewardData.Icon, self.icon)
  if ret then
    self.icon:MakePixelPerfect()
  end
  self:SetPic(rewardData.Type, rewardData)
  self:UpdateNumLabel(self.rewardCount)
  self:UpdateAdventureStoreState(rewardData)
  local itemData = ItemData.new("ItemData", self.rewardId)
  itemData:SetItemNum(self.rewardCount)
  self:SetCardInfo(itemData)
end

function OptionalGiftRewardCell:UpdateAdventureStoreState(staticData)
  local advProxy = AdventureDataProxy.Instance
  local storeStatus = 0
  if storeStatus == 0 then
    if advProxy:IsHeadFashionStored(self.rewardId) then
      storeStatus = 2
    elseif advProxy:IsFashionUnlock(self.rewardId) then
      storeStatus = 1
    elseif AdventureDataProxy.Instance:CheckEquipCanStore(self.rewardId) and 0 < BagProxy.Instance:GetItemNumByStaticID(self.rewardId, _PACKAGECHECK) then
      storeStatus = 3
    end
  end
  if storeStatus == 0 then
    if advProxy:IsMountStored(self.rewardId) then
      storeStatus = 2
    elseif advProxy:IsMountUnlock(self.rewardId) then
      storeStatus = 1
    elseif Table_Mount[self.rewardId] and 0 < BagProxy.Instance:GetItemNumByStaticID(self.rewardId, _PACKAGECHECK) then
      storeStatus = 3
    end
  end
  local isCard = false
  if storeStatus == 0 then
    local cardInfo = Table_Card[self.rewardId]
    if cardInfo then
      isCard = true
      if advProxy:IsCardStored(self.rewardId) then
        storeStatus = 2
      elseif advProxy:IsCardUnlock(self.rewardId) then
        storeStatus = 1
      elseif 0 < BagProxy.Instance:GetItemNumByStaticID(self.rewardId, _PACKAGECHECK) then
        storeStatus = 3
      end
    end
  end
  if storeStatus == 0 then
    local petData = PetProxy.Instance:GetPetDataByEggID(self.rewardId)
    if petData then
      local petID = petData.id
      local inManual, manualData = advProxy:checkPetIsInManual(petID)
      if petID and inManual and manualData.status ~= SceneManual_pb.EMANUALSTATUS_DISPLAY then
        storeStatus = 3
      elseif petID and 0 < BagProxy.Instance:GetItemNumByStaticID(self.rewardId, _PACKAGECHECK) then
        storeStatus = 3
      end
    end
  end
  if storeStatus == 0 then
    local composeID = staticData and staticData.ComposeID
    local composeConfig = Table_Compose[composeID]
    local productID = composeConfig and composeConfig.Product and composeConfig.Product.id
    if productID then
      if advProxy:IsHeadFashionStored(productID) then
        storeStatus = 2
      elseif advProxy:IsFashionStored(productID) then
        storeStatus = 2
      elseif advProxy:IsFashionOrMountUnlock(productID) then
        storeStatus = 1
      elseif 0 < BagProxy.Instance:GetItemNumByStaticID(productID, _PACKAGECHECK) then
        storeStatus = 3
      end
    end
  end
  if storeStatus == 0 then
    local isGain = AdventureDataProxy.Instance:IsCollectionGained(self.rewardId)
    if isGain then
      storeStatus = 3
    end
  end
  self:Hide(self.adventureStoreStateSp.gameObject)
  self:Hide(self.getSymbol)
  if isCard then
    self.adventureStoreStateSp.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(22.57, 31.3, 0)
    self.getSymbol.transform.localPosition = LuaGeometry.GetTempVector3(-13.3, 20.8, 0)
  else
    self.adventureStoreStateSp.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(-31.3, 31.3, 0)
    self.getSymbol.transform.localPosition = LuaGeometry.GetTempVector3(-21.75, 20.8, 0)
  end
  if storeStatus == 1 or storeStatus == 2 then
    self:Show(self.adventureStoreStateSp.gameObject)
    self.adventureStoreStateSp.spriteName = "Adventure_icon_0" .. storeStatus
  elseif storeStatus == 3 then
    self:Show(self.getSymbol)
  end
end

function OptionalGiftRewardCell:GetInputChangeEvtStr()
  return OptionalGiftRewardCell.InputChange
end

function OptionalGiftRewardCell:GetInputSubmitEvtStr()
  return OptionalGiftRewardCell.InputSubmit
end
