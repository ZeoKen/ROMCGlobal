autoImport("ItemNewCell")
CraftingItemChooseCell = class("CraftingItemChooseCell", ItemNewCell)
CraftingItemChooseCell.PfbPath = "cell/CraftingItemChooseCell"

function CraftingItemChooseCell:Init()
  CraftingItemChooseCell.super.Init(self)
  self:initView()
  self:AddViewEvents()
end

function CraftingItemChooseCell:initView()
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
  self.itemName = self:FindGO("ItemName"):GetComponent(UILabel)
  self.itemLimit = self:FindGO("ItemLimit"):GetComponent(UILabel)
  self.chooseButton = self:FindGO("ChooseButton")
  if self.chooseButton then
    self.chooseButtonLabel = self:FindComponent("Label", UILabel, self.chooseButton)
    self:AddClickEvent(self.chooseButton, function()
      self:PassEvent(MouseEvent.MouseClick, self)
    end)
  end
end

function CraftingItemChooseCell:AddViewEvents()
end

function CraftingItemChooseCell:SetData(data)
  CraftingItemChooseCell.super.SetData(self, data)
  if data then
    self.gameObject:SetActive(true)
    local staticData = Table_Item[data.productItemID]
    if not IconManager:SetItemIcon(staticData.Icon, self.icon) then
      IconManager:SetItemIcon("item_45001", self.icon)
    end
    self.itemName.text = staticData.NameZh
    self.itemLimit.text = string.format(ZhString.CraftingPot_ItemLimit, data.leftTimes)
  else
    self.gameObject:SetActive(false)
  end
end

function CraftingItemChooseCell:SetChooseIds(chooseIds)
  self.chooseIds = chooseIds
  self:UpdateChoose()
end
