local BaseCell = autoImport("BaseCell")
HairCutCell = class("HairCutCell", BaseCell)
local _shopType, _shopID

function HairCutCell:Init()
  _shopType = ShopDressingProxy.Instance.shopType
  _shopID = ShopDressingProxy.Instance.shopID
  HairCutCell.super.Init(self)
  self:FindObjs()
  self:AddCellClickEvent()
end

function HairCutCell:FindObjs()
  self.empty = self:FindGO("empty")
  self.item = self:FindGO("Item")
  self.chooseImg = self:FindGO("chooseImg")
  self.icon = self:FindComponent("icon", UISprite)
  self.lockFlag = self:FindGO("lockFlag")
  self.equiped = self:FindGO("Equiped")
end

function HairCutCell:SetChoose(id)
  self.chooseId = id
  self:UpdateChoose()
end

function HairCutCell:UpdateChoose()
  if self.data and self.data.id and self.data.id == self.chooseId then
    self.chooseImg:SetActive(true)
  else
    self.chooseImg:SetActive(false)
  end
end

function HairCutCell:SetData(data)
  self.data = data
  if data and data.id then
    self:Show(self.item)
    self:Hide(self.empty)
    local tableData = ShopProxy.Instance:GetShopItemDataByTypeId(_shopType, _shopID, data.id)
    if nil ~= tableData and tableData.goodsID then
      local hairstyleID = ShopDressingProxy.Instance:GetHairStyleIDByItemID(tableData.goodsID)
      if nil == hairstyleID then
        return
      end
      self.hairstyleID = hairstyleID
      self:UpdateUnlock()
      local hairTableData = Table_HairStyle[hairstyleID]
      self:SetEquiped()
      if hairTableData and hairTableData.Icon then
        local success = IconManager:SetHairStyleIcon(hairTableData.Icon, self.icon)
        if not success then
        end
      end
    end
    self:UpdateChoose()
  else
    self:Hide(self.item)
    self:Show(self.empty)
  end
end

function HairCutCell:UpdateUnlock()
  if not self.hairstyleID then
    return
  end
  local unlock = ShopDressingProxy.Instance:bActived(self.hairstyleID, ShopDressingProxy.DressingType.HAIR)
  if self.unlock == unlock then
    return
  end
  self.unlock = unlock
  if unlock then
    self:Hide(self.lockFlag)
    self:SetTextureWhite(self.icon.gameObject)
  else
    self:Show(self.lockFlag)
    self:SetTextureGrey(self.icon.gameObject)
  end
end

function HairCutCell:SetEquiped()
  if self.equiped then
    self.equiped:SetActive(self.hairstyleID == ShopDressingProxy.Instance.originalHair)
  end
end
