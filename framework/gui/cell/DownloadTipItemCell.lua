DownloadTipItemCell = class("DownloadTipItemCell", CoreView)

function DownloadTipItemCell:ctor(obj)
  DownloadTipItemCell.super.ctor(self, obj)
  self:Init()
end

function DownloadTipItemCell:Init()
  self.itemIcon = self:FindComponent("ItemIcon", UISprite)
  self.numLabel = self:FindComponent("NumLabel", UILabel)
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function DownloadTipItemCell:SetData(data)
  local flag = data ~= nil and next(data) ~= nil
  self.gameObject:SetActive(flag)
  if not flag then
    return
  end
  self.itemId, self.num = data.itemId or data.itemid, data.num and tonumber(data.num) or 0
  self:UpdateItemIcon()
  self:UpdateNum()
end

function DownloadTipItemCell:UpdateItemIcon()
  local itemSData = self.itemId and Table_Item[self.itemId]
  local succ = itemSData and IconManager:SetItemIcon(itemSData.Icon, self.itemIcon) or false
  if not succ then
    IconManager:SetItemIcon("item_45001", self.itemIcon)
  end
end

function DownloadTipItemCell:UpdateNum()
  self.numLabel.text = self.num > 1 and tostring(self.num) or ""
end
