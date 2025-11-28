AppStorePurchase = class("AppStorePurchase")

function AppStorePurchase.Ins()
  if AppStorePurchase.ins == nil then
    AppStorePurchase.ins = AppStorePurchase.new()
  end
  return AppStorePurchase.ins
end

function AppStorePurchase:AddListener()
  self.listenerAdded = false
  EventManager.Me():AddEventListener(LoadSceneEvent.FinishLoadScene, self.OnReceiveFinishLoadScene, self)
end

function AppStorePurchase:OnReceiveFinishLoadScene()
  if not self.listenerAdded then
    self.listenerAdded = true
    self:SetCallbackAppStorePurchase()
  end
end

function AppStorePurchase:SetCallbackAppStorePurchase()
  if not BackwardCompatibilityUtil.CompatibilityMode_V81 then
    FunctionSDK.Instance:SetCallbackAppStorePurchase(function(x)
      self:ShowProduct(x)
      FunctionSDK.Instance:ClearPurchaseFromAppStore()
    end)
  else
    FunctionXDSDK.Ins:SetCallbackAppStorePurchase(function(x)
      self:ShowProduct(x)
      FunctionXDSDK.Ins:ClearPurchaseFromAppStore()
    end)
  end
end

function AppStorePurchase:ShowProduct(product_id)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.AppStorePurchase,
    viewdata = product_id
  })
end

function AppStorePurchase:GetPanelConfigFromProductID(product_id)
  for k, v in pairs(Table_Deposit) do
    if v.ProductID == product_id then
      if v.Type == 1 then
        return PanelConfig.ZenyShop
      elseif v.Type == 2 or v.Type == 5 then
        return PanelConfig.ZenyShopMonthlyVIP
      elseif v.Type == 3 or v.Type == 4 then
        return PanelConfig.ZenyShopGachaCoin
      end
    end
  end
  return nil
end

function AppStorePurchase:ClearCallbackAppStorePurchase()
  if not BackwardCompatibilityUtil.CompatibilityMode_V81 then
    FunctionSDK.Instance:SetCallbackAppStorePurchase(nil)
  else
    FunctionXDSDK.Ins:SetCallbackAppStorePurchase(nil)
  end
end
