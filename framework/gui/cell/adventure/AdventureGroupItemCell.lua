AdventureGroupItemCell = class("AdventureGroupItemCell", ItemCell)

function AdventureGroupItemCell:Init()
  self.itemObj = self:LoadPreferb("cell/ItemCell", self:FindGO("ItemRoot"))
  self.itemObj.transform.localPosition = LuaGeometry.GetTempVector3()
  AdventureGroupItemCell.super.Init(self)
  self.packageStoreState = self:FindComponent("packageStoreState", UISprite)
  self.objSelect = self:FindGO("BagChooseSymbol")
  self:AddCellClickEvent()
end

function AdventureGroupItemCell:SetData(data)
  self.groupItemData = data
  AdventureGroupItemCell.super.SetData(self, data.itemData)
  self:ActiveNewTag(false)
  self.staticId = data.itemData.staticData.id
  self.store = data.store
  self.isUnlock = data.isUnlock
  self:SetPackageStoreState()
  self:SetSelect(false)
  if data.type == SceneManual_pb.EMANUALTYPE_MOUNT and data.itemData:IsMountPet() then
    IconManager:SetPetMountIcon(data.itemData, self.icon)
  end
end

function AdventureGroupItemCell:SetPackageStoreState()
  if self.store then
    self:Show(self.packageStoreState.gameObject)
    self.packageStoreState.spriteName = "Adventure_icon_02"
    self:SetIconGrey(false)
  elseif self.staticId and BagProxy.Instance:GetItemByStaticIDWithoutCard(self.staticId) then
    self:Show(self.packageStoreState.gameObject)
    self.packageStoreState.spriteName = "Adventure_icon_01"
    self:SetIconGrey(false)
  else
    self:Hide(self.packageStoreState.gameObject)
    self:SetIconGrey(not self.isUnlock)
  end
end

function AdventureGroupItemCell:SetSelect(isSelect)
  if self.isSelect ~= isSelect then
    self.objSelect:SetActive(isSelect)
    self.isSelect = isSelect
  end
end
