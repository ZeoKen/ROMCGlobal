CollectSaleConfirmPopUp = class("CollectSaleConfirmPopUp", BaseView)
CollectSaleConfirmPopUp.ViewType = UIViewType.PopUpLayer
local _QuickSellPackageCheck = GameConfig.PackageMaterialCheck.quick_sell or {1, 8}
local tempV3 = LuaVector3()

function CollectSaleConfirmPopUp:Init()
  self.content = self:FindComponent("Content", UILabel)
  self.confirmButton = self:FindGO("ConfirmButton")
  self.zenyCost = self:FindComponent("ZenyCostLabel", UILabel)
  self.noSaleTip = self:FindGO("NoSaleTip")
  self.sellDiscount = self:FindGO("SellDiscount")
  self.sellDiscountDesc = self:FindComponent("DiscountDesc", UILabel, self.sellDiscount)
  local saleIcon = self:FindComponent("Sprite", UISprite, self:FindGO("SaleInfo"))
  self.autoSellToggle = self:FindGO("AutoSell"):GetComponent("UIToggle")
  local autosell = Game.Myself.data.userdata:Get(UDEnum.AUTOSELL) or 0
  if autosell == 0 then
    self.autoSellToggle.value = false
  else
    self.autoSellToggle.value = true
  end
  EventDelegate.Add(self.autoSellToggle.onChange, function()
    ServiceItemProxy.Instance:CallAutoSellItemCmd(self.autoSellToggle.value)
    redlog("autoSellToggle")
  end)
  IconManager:SetItemIcon(Table_Item[GameConfig.MoneyId.Zeny].Icon, saleIcon)
  self.autoSellToggle = self:FindGO("AutoSell"):GetComponent("UIToggle")
  local autosell = Game.Myself.data.userdata:Get(UDEnum.AUTOSELL) or 0
  if autosell == 0 then
    self.autoSellToggle.value = false
  else
    self.autoSellToggle.value = true
  end
  EventDelegate.Add(self.autoSellToggle.onChange, function()
    ServiceItemProxy.Instance:CallAutoSellItemCmd(self.autoSellToggle.value)
    redlog("autoSellToggle")
  end)
  self:AddClickEvent(self.confirmButton, function(go)
    self:DoConfirm()
  end)
  self:AddListenEvt(MyselfEvent.AutoSell, self.HandleAutoSellChanged)
end

function CollectSaleConfirmPopUp:HandleAutoSellChanged()
end

local server_items = {}

function CollectSaleConfirmPopUp:DoConfirm()
  if #self.mt == 0 then
    MsgManager.ShowMsgByIDTable(25428)
    return
  end
  if self.packMailId then
    ServiceItemProxy.Instance:CallPackMailActionItemCmd(SceneItem_pb.EPACKMAILACTION_SELL, self.packMailId)
    self:CloseSelf()
    return
  end
  for i = 1, #self.mt do
    local item = self.mt[i]
    local sitem = NetConfig.PBC and {} or SceneItem_pb.SItem()
    sitem.guid, sitem.count = item.id, item.num or 0
    table.insert(server_items, sitem)
  end
  ServiceItemProxy.Instance:CallQuickSellItemCmd(server_items)
  TableUtility.ArrayClear(server_items)
  self:CloseSelf()
end

function CollectSaleConfirmPopUp:MtFuncDefault()
  self.mt = ReusableTable.CreateArray()
  local _BagMrg = BagProxy.Instance
  for i = 1, #_QuickSellPackageCheck do
    _BagMrg:CollectQuickSaleItems(self.mt, _QuickSellPackageCheck[i])
  end
end

function CollectSaleConfirmPopUp:MtFuncPackMail()
  self.mt = ReusableTable.CreateArray()
  local _BagMrg = BagProxy.Instance
  local packMailItems = self.packMailItems
  if packMailItems then
    for i = 1, #packMailItems do
      if _BagMrg:CanQuickSell(packMailItems[i]) then
        self.mt[#self.mt + 1] = packMailItems[i]
      end
    end
  end
end

function CollectSaleConfirmPopUp:UpdateInfo()
  if not self.packMailId then
    self:MtFuncDefault()
  else
    self:MtFuncPackMail()
  end
  local length = #self.mt
  if 0 < length then
    local zenyCost = 0
    local noDiscountCost = 0
    local addZenyCost = 0
    local itemMap = self.itemMap
    if itemMap == nil then
      itemMap = {}
      self.itemMap = {}
    end
    local disCount = Game.Myself.data.props:GetPropByName("SellDiscount")
    if disCount then
      disCount = disCount:GetValue()
    else
      disCount = 0
    end
    local shopProxy = ShopSaleProxy.Instance
    for i = 1, length do
      local item = self.mt[i]
      local sname = item.staticData.NameZh
      local num = item.num
      if itemMap[sname] == nil then
        itemMap[sname] = num
      else
        itemMap[sname] = num + itemMap[sname]
      end
      local price = (shopProxy:GetPrice(item) or 0) * num
      local purePrice = (shopProxy:GetPurePrice(item) or 0) * num
      zenyCost = zenyCost + purePrice
      noDiscountCost = noDiscountCost + (price - purePrice)
    end
    if disCount ~= 0 then
      addZenyCost = math.floor(disCount * zenyCost / 1000)
    end
    local namesList = self.namesList
    if namesList == nil then
      namesList = {}
      self.namesList = namesList
    end
    for sname, count in pairs(itemMap) do
      table.insert(namesList, sname .. "x" .. count)
    end
    TableUtility.TableClear(itemMap)
    table.sort(namesList, function(a, b)
      return a < b
    end)
    local name = ""
    for i = 1, #namesList do
      if i % 3 == 0 then
        name = name .. namesList[i] .. "\n"
      else
        name = name .. namesList[i] .. "      "
      end
    end
    TableUtility.ArrayClear(namesList)
    local zhstringTip = self.packMailId and ZhString.CollectSaleConfirmPopUp_MailSaleTip or ZhString.CollectSaleConfirmPopUp_SaleTip
    self.content.text = string.format(zhstringTip, name)
    self.zenyCost.text = zenyCost + noDiscountCost + addZenyCost
    if 0 < addZenyCost then
      self.sellDiscount:SetActive(true)
      self.sellDiscountDesc.text = string.format(ZhString.CollectSaleConfirmPopUp_SellDiscountDesc, math.floor(disCount / 10), addZenyCost)
      LuaVector3.Better_Set(tempV3, -3, -170, 0)
      self.confirmButton.transform.localPosition = tempV3
    else
      self.sellDiscount:SetActive(false)
      LuaVector3.Better_Set(tempV3, -3, -160, 0)
      self.confirmButton.transform.localPosition = tempV3
    end
    self.noSaleTip.gameObject:SetActive(false)
  else
    self.content.text = ""
    self.zenyCost.text = 0
    self.sellDiscount:SetActive(false)
    self.noSaleTip.gameObject:SetActive(true)
  end
end

function CollectSaleConfirmPopUp:OnEnter()
  self.packMailItems = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.PackMailItems or nil
  self.packMailId = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.PackMailId or nil
  CollectSaleConfirmPopUp.super.OnEnter(self)
  self:UpdateInfo()
end

function CollectSaleConfirmPopUp:OnExit()
  CollectSaleConfirmPopUp.super.OnExit(self)
  if self.mt ~= nil then
    ReusableTable.DestroyAndClearArray(self.mt)
    self.mt = nil
  end
end
