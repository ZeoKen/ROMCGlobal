local baseCell = autoImport("BaseCell")
ExchangePriceServerDetail = class("ExchangePriceServerDetail", ItemCell)

function ExchangePriceServerDetail:Init()
  self.cellContainer = self:FindGO("CellContainer")
  if self.cellContainer then
    local obj = self:LoadPreferb("cell/ItemCell", self.cellContainer)
    obj.transform.localPosition = Vector3.zero
  end
  ExchangePriceServerDetail.super.Init(self)
  self.name = self:FindGO("itemname"):GetComponent(UILabel)
  self.price = self:FindGO("Money"):GetComponent(UILabel)
end

function ExchangePriceServerDetail:SetData(data)
  self.data = data
  if data and data.itemid then
    local item = Table_Item[data.itemid]
    if item ~= nil then
      self.name.text = item.NameZh
      UIUtil.WrapLabel(self.name)
    else
      redlog("ExchangePriceServerDetail item nil", data.itemid)
    end
    local itemData = ItemData.new("", data.itemid)
    ExchangePriceServerDetail.super.SetData(self, itemData)
    if data.price then
      self.price.text = StringUtil.NumThousandFormat(data.price)
    else
      redlog("ExchangePriceServerDetail SetData : data.price is nil")
    end
  end
end
