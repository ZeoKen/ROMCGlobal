RedPacketRestItemCell = class("RedPacketRestItemCell", BaseCell)

function RedPacketRestItemCell:Init()
  self:FindObjs()
  local obj = self:LoadPreferb("cell/ItemCell", self.itemContainer)
  obj.transform.localPosition = LuaGeometry.GetTempVector3()
  self.itemCell = ItemCell.new(obj)
end

function RedPacketRestItemCell:FindObjs()
  self.nameLabel = self:FindComponent("name", UILabel)
  self.restNumLabel = self:FindComponent("restNum", UILabel)
  self.itemContainer = self:FindGO("itemContainer")
end

function RedPacketRestItemCell:SetData(data)
  local staticData = Table_Item[data.itemid]
  self.nameLabel.text = staticData.NameZh
  self.restNumLabel.text = data.restNum .. "/" .. data.totalNum
  local itemData = ItemData.new("item", data.itemid)
  self.itemCell:SetData(itemData)
end
