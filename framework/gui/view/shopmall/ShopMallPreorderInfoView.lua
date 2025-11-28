autoImport("PreorderInfoOverLapCell")
ShopMallPreorderInfoView = class("ShopMallPreorderInfoView", ContainerView)
ShopMallPreorderInfoView.ViewType = UIViewType.PopUpLayer
local NoEnchantStr = GameConfig.PreorderFilter.EnchantFilter[1].enchantName

function ShopMallPreorderInfoView:Init()
  self:FindObjs()
  self:InitShow()
  self:AddViewEvts()
end

function ShopMallPreorderInfoView:FindObjs()
  self.helpButton = self:FindGO("HelpButton")
  self:TryOpenHelpViewById(35279, nil, self.helpButton)
  self.lowerFilterLabel = self:FindGO("LowerFilterLabel"):GetComponent(UILabel)
  self.upperFilterLabel = self:FindGO("UpperFilterLabel"):GetComponent(UILabel)
  self.enchantLabel = self:FindGO("enchantLabel"):GetComponent(UILabel)
  self.brokenLabel = self:FindGO("brokenLabel"):GetComponent(UILabel)
  self.successTip = self:FindGO("SuccessTip"):GetComponent(UILabel)
  self.filterContainer = self:FindGO("FilterContainer")
  self.tipContainer = self:FindGO("TipContainer")
  self.cardFilterContainer = self:FindGO("CardFilter")
  self.lowerCardFilterLabel = self:FindGO("LowerCardFilterLabel"):GetComponent(UILabel)
  self.upperCardFilterLabel = self:FindGO("UpperCardFilterLabel"):GetComponent(UILabel)
end

local tempV3 = LuaVector3()

function ShopMallPreorderInfoView:InitShow()
  if self.viewdata.viewdata and self.viewdata.viewdata then
    local orderid = self.viewdata.viewdata.orderid
    local preorderItemData = ShopMallPreorderProxy.Instance:GetPreorderItemdata(orderid)
    local itemid = preorderItemData.itemid
    self.itemData = ItemData.new("", itemid)
    self.itemData.preorderItemData = preorderItemData
    local go = self:LoadPreferb("cell/PreorderInfoOverLapCell")
    self.cell = PreorderInfoOverLapCell.new(go)
    self.cell:SetData(self.itemData)
    self.cell:AddEventListener(PreoderEvent.ClosePreorderInfo, self.CloseSelf, self)
    if itemid and Table_Equip[itemid] then
      self.tipContainer.transform.localPosition = LuaGeometry.Const_V3_zero
      self.filterContainer:SetActive(true)
      self.cardFilterContainer:SetActive(false)
      self:SetDetail(preorderItemData)
    elseif not GameConfig.Exchange.CardLvTradeForbid and Game.CardUpgradeMap and itemid and Game.CardUpgradeMap[itemid] then
      self.tipContainer.transform.localPosition = LuaGeometry.Const_V3_zero
      self.filterContainer:SetActive(false)
      self.cardFilterContainer:SetActive(true)
      self:SetCardDetail(preorderItemData)
    else
      LuaVector3.Better_Set(tempV3, 0, 185, 0)
      self.tipContainer.transform.localPosition = tempV3
      self.filterContainer:SetActive(false)
      self.cardFilterContainer:SetActive(false)
    end
    self.successTip.text = string.format(ZhString.ShopMallPreorder_SuccessTip, preorderItemData.buycount or 0)
  end
end

function ShopMallPreorderInfoView:AddViewEvts()
  EventManager.Me():AddEventListener(PreoderEvent.ClosePreorderInfo, self.CloseSelf)
end

function ShopMallPreorderInfoView:SetDetail(preorderItemData)
  self.lowerFilterLabel.text = preorderItemData.refinelvmin
  self.upperFilterLabel.text = preorderItemData.refinelvmax
  local buffid = preorderItemData.buffid
  if 0 < buffid then
    local buffName = Table_Buffer[buffid] and Table_Buffer[buffid].BuffName or ""
    self.enchantLabel.text = OverSea.LangManager.Instance():GetLangByKey(buffName)
  else
    self.enchantLabel.text = NoEnchantStr
  end
  if preorderItemData.damage then
    self.brokenLabel.text = ZhString.ShopMallPreorder_Broken
  else
    self.brokenLabel.text = ZhString.ShopMallPreorder_UnBroken
  end
end

function ShopMallPreorderInfoView:SetCardDetail(preorderItemData)
  self.lowerCardFilterLabel.text = preorderItemData.cardlvmin or 0
  self.upperCardFilterLabel.text = preorderItemData.cardlvmax or 0
end

function ShopMallPreorderInfoView:OnExit()
  if self.cell then
    self.cell:OnDestroy()
  end
  if self.attriCtl then
    self.attriCtl:Destroy()
  end
  ShopMallPreorderInfoView.super.OnExit(self)
end
