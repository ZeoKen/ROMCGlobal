autoImport("NewRechargeCombinePackItemCell")
NewRechargeCombinePackPurchaseItemCell = class("NewRechargeCombinePackPurchaseItemCell", NewRechargeCombinePackItemCell)

function NewRechargeCombinePackPurchaseItemCell:RegisterClickEvent()
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(NewRechargeEvent.CombinePackItemCell_Toggle, self)
  end)
  self:AddClickEvent(self.selectToggle.gameObject, function(obj)
    self.data.select = self.selectToggle.value
    self:PassEvent(NewRechargeEvent.CombinePackItemCell_Toggle, self)
  end)
end

function NewRechargeCombinePackPurchaseItemCell:Set_SoldOutMark(active)
  NewRechargeCombinePackPurchaseItemCell.super.Set_SoldOutMark(self, active)
  if active then
    self.selectToggle.value = false
    self.data.select = false
    self.u_container.alpha = 0.5
    self.selectToggle.gameObject:SetActive(false)
    self.gameObject:SetActive(false)
  else
    self.u_container.alpha = 1
    self.selectToggle.gameObject:SetActive(true)
    self.gameObject:SetActive(true)
  end
  if not self.u_soldOutMark then
    return
  end
  self.u_soldOutMark:SetActive(active)
  if self.SetAlpha then
    self:SetAlpha(active and 0.5 or 1)
  end
end

function NewRechargeCombinePackPurchaseItemCell:Set_BuyTimesMark(active, buy_times)
  if not self.u_buyTimes then
    return
  end
  self.u_buyTimes.gameObject:SetActive(false)
end

function NewRechargeCombinePackPurchaseItemCell:SetCell()
  NewRechargeCombinePackPurchaseItemCell.super.SetCell(self)
  UIUtil.TempLimitIconSize(self.u_spItemIcon, 100, 100)
end
