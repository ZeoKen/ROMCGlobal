autoImport("BagFashionItemCell")
SnowFashionItemCell = class("SnowFashionItemCell", BagFashionItemCell)

function SnowFashionItemCell:Init()
  SnowFashionItemCell.super.Init(self)
  self:FindSnowFashionObjs()
end

function SnowFashionItemCell:FindSnowFashionObjs()
  self.unlock = self:FindGO("Lock")
  if self.unlock then
    self:Hide(self.unlock)
  end
end

function SnowFashionItemCell:SetData(data)
  local itemData, fashionData
  if type(data) == "table" then
    if data.fashionData then
      fashionData = data.fashionData
      itemData = data.itemData
    elseif data.staticData then
      itemData = data
    end
  end
  self.fashionData = fashionData
  SnowFashionItemCell.super.SetData(self, itemData)
  self:UpdateLockState()
  self:UpdateEquippedState()
  self:RegisterGuide(data)
end

function SnowFashionItemCell:RegisterGuide(data)
  local guideTarget = self:FindGO("Common_BagItemCell") or self.gameObject
  self:AddOrRemoveGuideId(guideTarget)
  if data and data.fashionData and data.fashionData.id == 10 then
    self:AddOrRemoveGuideId(guideTarget, 565)
  end
end

function SnowFashionItemCell:UpdateLockState()
  if self.unlock then
    if self.fashionData and not self.fashionData.isUnlocked then
      self.unlock:SetActive(true)
    else
      self.unlock:SetActive(false)
    end
  end
end

function SnowFashionItemCell:RefreshStatus()
  SnowFashionItemCell.super.RefreshStatus(self)
  self:UpdateEquippedState()
end

function SnowFashionItemCell:UpdateEquippedState()
  if self.objInUse then
    if self.fashionData and self.fashionData.isEquipped then
      self.objInUse:SetActive(true)
    else
      self.objInUse:SetActive(false)
    end
  end
end
