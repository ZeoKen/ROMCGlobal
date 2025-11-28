BaseRewardItemCell = class("BaseRewardItemCell", CoreView)

function BaseRewardItemCell:ctor(obj)
  BaseRewardItemCell.super.ctor(self, obj)
  self:Init()
end

function BaseRewardItemCell:Init()
  self.itemIcon = self:FindComponent("ItemIcon", UISprite)
  self.numLabel = self:FindComponent("NumLabel", UILabel)
  self.got = self:FindGO("Got")
end

function BaseRewardItemCell:SetData(data)
  local flag = data ~= nil and next(data) ~= nil
  self.gameObject:SetActive(flag)
  if not flag then
    return
  end
  self.itemId, self.num, self.rewardId = data.itemId or data.itemid, data.num and tonumber(data.num) or 0, data.rewardId or data.rewardid
  self.gotPredicate = type(data.gotPredicate) == "function" and data.gotPredicate or nil
  self:UpdateItemIcon()
  self:UpdateNum()
  self:UpdateGot()
end

function BaseRewardItemCell:UpdateItemIcon()
  local itemSData = self.itemId and Table_Item[self.itemId]
  local succ = itemSData and IconManager:SetItemIcon(itemSData.Icon, self.itemIcon) or false
  if not succ then
    IconManager:SetItemIcon("item_45001", self.itemIcon)
  end
end

function BaseRewardItemCell:UpdateNum()
  self.numLabel.text = self.num > 1 and tostring(self.num) or ""
end

function BaseRewardItemCell:UpdateGot()
  local result = self.gotPredicate and self.gotPredicate(self.rewardId, self.itemId, self.num)
  self.got:SetActive(result and true or false)
  self.itemIcon.alpha = result and 0.5 or 1
end
