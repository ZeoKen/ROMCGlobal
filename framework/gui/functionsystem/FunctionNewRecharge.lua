FunctionNewRecharge = class("FunctionNewRecharge")

function FunctionNewRecharge.Instance()
  if FunctionNewRecharge.instance == nil then
    FunctionNewRecharge.instance = FunctionNewRecharge.new()
  end
  return FunctionNewRecharge.instance
end

FunctionNewRecharge.InnerTab = {
  Deposit_ROB = 1,
  Deposit_Zeny = 2,
  Card_MonthlyVIP = 1,
  Card_EP = 2,
  Shop_Recommend = 1,
  Shop_Normal1 = 2,
  Shop_Normal2 = 3,
  MixRecommend = 1
}

function FunctionNewRecharge:OpenUIDefaultPage(innerTab)
  self:OpenUI(PanelConfig.NewRecharge_THot, innerTab)
end

function FunctionNewRecharge:OpenUI(subSection, InnerSection, vdata)
  if FunctionNewRecharge.isWindowsZenyShopForbid() then
    MsgManager.ShowMsgByID(28004)
    return
  end
  if self:IsChuXinServer() and not GameConfig.NewRecharge.TabDef.Hot and subSection ~= PanelConfig.NewRecharge_TCard then
    subSection = PanelConfig.NewRecharge_TDeposit
    InnerSection = self.InnerTab.Deposit_Zeny
  end
  if NewRechargeProxy.Ins.UseCompatVer then
    if subSection.id == PanelConfig.NewRecharge_TShop.id then
      if InnerSection == self.InnerTab.Shop_Normal1 or InnerSection == self.InnerTab.Shop_Normal2 then
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.ZenyShopItem,
          viewdata = vdata
        })
      else
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.ZenyShopGachaCoin,
          viewdata = vdata
        })
      end
    elseif subSection.id == PanelConfig.NewRecharge_TCard.id then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.ZenyShopMonthlyVIP,
        viewdata = vdata
      })
    elseif subSection.id == PanelConfig.NewRecharge_TDeposit.id then
      if InnerSection == self.InnerTab.Deposit_Zeny then
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.ZenyShop,
          viewdata = vdata
        })
      else
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.ZenyShopGachaCoin,
          viewdata = vdata
        })
      end
    end
    return
  end
  if BranchMgr.IsJapan() and InnerSection == self.InnerTab.Deposit_Zeny and subSection.id == PanelConfig.NewRecharge_TDeposit.id then
    return
  end
  vdata = vdata or {}
  if not vdata.innerTab then
    vdata.innerTab = InnerSection
  end
  if not vdata.reEntnerNotDestory then
    vdata.reEntnerNotDestory = true
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = subSection, viewdata = vdata})
end

function FunctionNewRecharge.isWindowsZenyShopForbid()
  return ApplicationInfo.IsWindows() and GameConfig.System.openWindowsZenyShop == 0
end

function FunctionNewRecharge:AddProductPurchase(product_id, purchase_function)
  if self.productPurchase == nil then
    self.productPurchase = {}
  end
  self.productPurchase[product_id] = purchase_function
  EventManager.Me():PassEvent(NewRechargeEvent.CanPurchase, product_id)
end

function FunctionNewRecharge:ClearProductPurchase()
  if self.productPurchase ~= nil then
    TableUtility.TableClear(self.productPurchase)
  end
end

function FunctionNewRecharge:TryPurchaseProduct(product_id)
  local purchaseFunction = self.productPurchase[product_id]
  if purchaseFunction ~= nil then
    purchaseFunction()
    return true
  end
  return false
end

function FunctionNewRecharge.FormatMilComma(int_number)
  if int_number then
    local isMinus = int_number < 0
    if isMinus then
      int_number = int_number * -1
    end
    local str = tostring(int_number)
    local tab = {}
    local count = 0
    for i = #str, 1, -1 do
      local char = string.sub(str, i, i)
      if char == "." then
        count = 10086
      end
      table.insert(tab, char)
      count = count + 1
      if count == 3 and 1 < i then
        table.insert(tab, ",")
        count = 0
      end
    end
    local result = ""
    for j = #tab, 1, -1 do
      local char = tab[j]
      result = result .. char
    end
    if isMinus then
      result = "-" .. result
    end
    return result
  end
  return nil
end

FunctionNewRecharge.colorPurchaseTimes = "4185C6FF"
FunctionNewRecharge.colorMorePurchaseTimes = "41c419"

function FunctionNewRecharge.PaintColorPurchaseTimes(str)
  return "[" .. FunctionNewRecharge.colorPurchaseTimes .. "]" .. str .. "[-]"
end

function FunctionNewRecharge.PaintColorMorePurchaseTimes(str)
  return "[" .. FunctionNewRecharge.colorMorePurchaseTimes .. "]" .. str .. "[-]"
end

function FunctionNewRecharge:IsChuXinServer()
  return GameConfig.NewRecharge.IsChuXinServer ~= nil and GameConfig.NewRecharge.IsChuXinServer == true
end

function FunctionNewRecharge:ChuXinServerCheck_SubSection(value)
  return value == 3 or value == 2
end

function FunctionNewRecharge:ChuXinServerCheck_InnerSection(sub, inner)
  return sub == 3 and inner == 2 or sub == 2 and inner == 1
end
