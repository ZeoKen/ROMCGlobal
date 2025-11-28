autoImport("BaseTip")
MixShopTip = class("MixShopTip", BaseTip)

function MixShopTip:Init()
  self:InitCell()
end

function MixShopTip:InitCell()
  self.itemContainer = self:FindGO("ItemContainer")
  local cell = self:LoadPreferb("cell/ItemCell", self.itemContainer)
  cell.transform.localPosition = LuaVector3.Zero()
  self.itemCell = ItemCell.new(cell)
  self.text = SpriteLabel.new(self:FindGO("Text"), nil, nil, nil, true)
  self.confirmBtn = self:FindGO("ConfirmBtn")
  self:AddClickEvent(self.confirmBtn, function()
    FunctionLottery.Me():DoPurchase()
    self:CloseSelf()
  end)
  self.CancelBtn = self:FindGO("CancelBtn")
  self:AddClickEvent(self.CancelBtn, function()
    self:CloseSelf()
  end)
  self.itemName = self:FindComponent("ItemName", UILabel)
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
  
  self:AddButtonEvent("CloseButton", function(go)
    self:CloseSelf()
  end)
end

function MixShopTip:CloseSelf()
  TipsView.Me():HideCurrent()
end

function MixShopTip:SetData(data)
  self.text:Reset()
  local sb = LuaStringBuilder.CreateAsTable()
  sb:Append(string.format(ZhString.Lottery_MixShop_Rich, data.ItemID, data.ItemCount))
  ReusableTable.DestroyAndClearArray(arr)
  self.text:SetText(sb:GetCount() > 0 and sb:ToString() or "")
  local itemdata = data:GetItemData()
  self.itemCell:SetData(itemdata)
  self.itemName.text = itemdata.staticData.NameZh
  sb:Destroy()
end

function MixShopTip:DestroySelf()
  if not Slua.IsNull(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end
