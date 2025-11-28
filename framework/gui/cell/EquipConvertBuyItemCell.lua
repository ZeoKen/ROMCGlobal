autoImport("HappyShopBuyItemCell")
EquipConvertBuyItemCell = class("EquipConvertBuyItemCell", ItemTipComCell)
local hideType = {hideClickSound = true, hideClickEffect = false}

function EquipConvertBuyItemCell:Init()
  EquipConvertBuyItemCell.super.Init(self)
  self.confirmButton = self:FindGO("ConfirmButton")
  self.confirmSprite = self.confirmButton:GetComponent(UIMultiSprite)
  self:AddClickEvent(self.confirmButton, function()
    self:CloseGetPath()
    if not self:CheckMoney() then
      local itemName = Table_Item[self.costItemId] and Table_Item[self.costItemId].NameZh
      MsgManager.ShowMsgByIDTable(itemName and 9620 or 10154, itemName)
      return
    end
    if not self:CheckCanBuy() then
      MsgManager.ShowMsgByID(3436)
      return
    end
    local goodsId = self.shopdata.goodsID
    MsgManager.ConfirmMsgByID(4047, function()
      self:Confirm()
    end, nil, nil, Table_Item[goodsId] and Table_Item[goodsId].NameZh or "")
  end, hideType)
  local itemContainer = self:FindGO("ItemContainer", self.confirmButton)
  self.price = self:FindComponent("Num", UILabel, itemContainer)
  self.priceIcon = self:FindComponent("Icon", UISprite, itemContainer)
  self.gpContainer = self:FindGO("GetPathContainer")
  local gpPanel, selfPanel = self.gpContainer:GetComponentInParent(UIPanel), self.gameObject:GetComponentInParent(UIPanel)
  if selfPanel then
    gpPanel.depth = selfPanel.depth + 9
  end
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  self:AddEventListener(ItemTipEvent.ShowGetPath, self.ShowGetPath, self)
end

function EquipConvertBuyItemCell:SetData(data)
  self:CloseGetPath()
  if not data then
    LogUtility.Warning("Cannot set data of EquipConvertBuyItemCell when data == nil")
    return
  end
  self.shopdata = data
  local item = data:GetItemData()
  if self.convertView and self.convertView.useRandomPreview then
    item.equipInfo.isFromShopButRandomPreview = true
  else
    item.equipInfo.isFromShop = true
  end
  EquipConvertBuyItemCell.super.SetData(self, item)
  self.costItemId, self.cost = data.ItemID, data.ItemCount
  local moneyData = Table_Item[self.costItemId]
  if moneyData then
    IconManager:SetItemIcon(moneyData.Icon, self.priceIcon)
  end
  self.price.text = self:CheckMoney() and self:CheckCanBuy() and self.cost or string.format("[c]%s%s[-][/c]", CustomStrColor.BanRed, self.cost)
end

function EquipConvertBuyItemCell:Confirm()
  local item = HappyShopProxy.Instance:GetSelectId()
  if item then
    HappyShopProxy.Instance:BuyItem(item, 1)
    self:PlayUISound(AudioMap.UI.Click)
    self.gameObject:SetActive(false)
  end
end

function EquipConvertBuyItemCell:CheckMoney()
  return HappyShopProxy.Instance:GetItemNum(self.costItemId) >= (self.cost or math.huge)
end

function EquipConvertBuyItemCell:CheckCanBuy()
  local canBuyCount = HappyShopProxy.Instance:GetCanBuyCount(self.shopdata)
  if canBuyCount and self.shopdata.LimitNum and canBuyCount == 0 then
    return false
  end
  return true
end

function EquipConvertBuyItemCell:ShowGetPath()
  if self.bdt then
    self.bdt:OnExit()
  else
    local x = LuaGameObject.InverseTransformPointByTransform(UIManagerProxy.Instance.UIRoot.transform, self.gameObject.transform, Space.World)
    self.gpContainer.transform.position = self.gameObject.transform.position
    local lx, ly = LuaGameObject.GetLocalPosition(self.gpContainer.transform)
    local tempV3 = LuaGeometry.GetTempVector3()
    if 0 < x then
      tempV3:Set(lx - 210, ly + 280, 0)
    else
      tempV3:Set(lx + 210, ly + 280, 0)
    end
    self.gpContainer.transform.localPosition = tempV3
    if self.data and self.data.staticData then
      self.bdt = GainWayTip.new(self.gpContainer)
      self.bdt:SetAnchorPos(x <= 0)
      self.bdt:SetData(self.data.staticData.id)
      self.bdt:AddEventListener(ItemEvent.GoTraceItem, function()
        self:CloseConvertView()
      end, self)
      self.bdt:AddIgnoreBounds(self.gameObject)
      self:AddIgnoreBounds(self.bdt.gameObject)
      self.bdt:AddEventListener(GainWayTip.CloseGainWay, self.GetPathCloseCall, self)
    end
  end
end

function EquipConvertBuyItemCell:GetPathCloseCall()
  if self.closecomp then
    self.closecomp:ReCalculateBound()
  end
  self.bdt = nil
end

function EquipConvertBuyItemCell:CloseGetPath()
  if self.bdt then
    self.bdt:OnExit()
    self.bdt = nil
  end
end

function EquipConvertBuyItemCell:AddIgnoreBounds(obj)
  if self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end

function EquipConvertBuyItemCell:CloseConvertView()
  if self.convertView then
    self.convertView:CloseSelf()
  end
end
