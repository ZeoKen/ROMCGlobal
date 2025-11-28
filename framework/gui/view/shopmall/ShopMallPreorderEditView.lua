autoImport("PreorderEditOverLapCell")
autoImport("PreorderItemData")
autoImport("PopupGridList")
ShopMallPreorderEditView = class("ShopMallPreorderEditView", ContainerView)
ShopMallPreorderEditView.ViewType = UIViewType.PopUpLayer
local TradeTipPos = {
  [1] = LuaVector3.New(39, -15, 0),
  [2] = LuaVector3.New(39, 232, 0)
}

function ShopMallPreorderEditView:OnExit()
  if self.cell then
    self.cell:OnDestroy()
  end
  if self.introCell then
    self.introCell:OnDestroy()
  end
  self:ShowItemTip()
  self.itemData = nil
  ShopMallPreorderEditView.super.OnExit(self)
end

function ShopMallPreorderEditView:Init()
  self:FindObjs()
  self:InitShow()
  self:AddViewEvts()
  self:AddCloseButtonEvent()
  self:InitFilter()
  self:InitCardFilter()
end

function ShopMallPreorderEditView:FindObjs()
  self.helpButton = self:FindGO("HelpButton")
  self:TryOpenHelpViewById(35279, nil, self.helpButton)
  self.tip = self:FindGO("Tip")
  self.filterGO = self:FindGO("filterPanel")
  self.cardFilterGO = self:FindGO("cardFilterPanel")
  self.tradeCount = self:FindGO("TradeCount"):GetComponent(UILabel)
end

local RefineFilter = GameConfig.PreorderFilter.RefineFilter
local EnchantFilter = GameConfig.PreorderFilter.EnchantFilter
local BrokenFilter = GameConfig.PreorderFilter.BrokenFilter
local DamageConfig = GameConfig.PreorderFilter.ExcludeDamaged
local CardFilter = GameConfig.PreorderFilter.CardFilter

function ShopMallPreorderEditView:InitShow()
  local preorderItemData
  self.tradeCount.text = ""
  if self.viewdata.viewdata and self.viewdata.viewdata.itemid then
    self.itemid = self.viewdata.viewdata.itemid
    self.itemData = ItemData.new("", self.itemid)
    preorderItemData = PreorderItemData.new()
    preorderItemData.itemid = self.itemid
    self.itemData.preorderItemData = preorderItemData
  elseif self.viewdata.viewdata and self.viewdata.viewdata.orderId then
    preorderItemData = ShopMallPreorderProxy.Instance:GetPreorderData(self.viewdata.viewdata.orderId)
    self.itemid = preorderItemData.itemid
    self.itemData = ItemData.new("", self.itemid)
    self.itemData.preorderItemData = preorderItemData
  end
  if self.itemData and preorderItemData then
    local go = self:LoadPreferb("cell/PreorderEditOverLapCell")
    self.cell = PreorderEditOverLapCell.new(go)
    self.cell:SetData(self.itemData, self)
    self.cell:AddEventListener(PreoderEvent.ClosePreorderEditor, self.CloseSelf, self)
    ServiceRecordTradeProxy.Instance:CallPreorderQueryPriceRecordTradeCmd(preorderItemData)
    if ISNoviceServerType then
      QuickBuyProxy.Instance:CallHoldedItemCountTrade(self.itemid)
    end
  end
  if self.itemid and Table_Equip[self.itemid] then
    self.tip:SetActive(true)
    self.filterGO:SetActive(true)
    self.cardFilterGO:SetActive(false)
    self.isEquip = true
    self.cardHasLv = false
    self.tradeCount.gameObject.transform.localPosition = TradeTipPos[1]
  elseif not GameConfig.Exchange.CardLvTradeForbid and Game.CardUpgradeMap and self.itemid and Game.CardUpgradeMap[self.itemid] then
    self.tip:SetActive(true)
    self.filterGO:SetActive(false)
    self.cardFilterGO:SetActive(true)
    self.cardHasLv = true
    self.tradeCount.gameObject.transform.localPosition = TradeTipPos[1]
  else
    self.tip:SetActive(false)
    self.filterGO:SetActive(false)
    self.cardFilterGO:SetActive(false)
    self.isEquip = false
    self.cardHasLv = false
    self.tradeCount.gameObject.transform.localPosition = TradeTipPos[2]
  end
end

function ShopMallPreorderEditView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.RecordTradePreorderQueryPriceRecordTradeCmd, self.RecvPreorderInfo)
  EventManager.Me():AddEventListener(PreoderEvent.ClosePreorderEditor, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.RecordTradeQueryHoldedItemCountTradeCmd, self.RecvTradeCount)
end

function ShopMallPreorderEditView:RecvPreorderInfo(note)
  if self.cell then
    local preorderItemData = note.body.item
    local itemid = preorderItemData.itemid
    local itemData = ItemData.new("", itemid)
    itemData.preorderItemData = preorderItemData
    self.cell:UpdateData(preorderItemData, true)
  end
end

local popupItems = {}

function ShopMallPreorderEditView:InitFilter()
  if not self.isEquip or not self.itemid then
    return
  end
  self.filterPanel = self:FindGO("filterPanel"):GetComponent(UIPanel)
  self.init = false
  self.lowerFilterGrid = PopupGridList.new(self:FindGO("lowerFilterTabs"), function(self, data)
    if self.selectLowerFilterData ~= data then
      self.selectLowerFilterData = data
      self.lowerLv = tonumber(self.selectLowerFilterData.lowerLv) or 0
      self:ResetUpperLvFilter()
      self:CheckDamageFilter()
      self:OnClickFilter()
    end
  end, self, self.filterPanel.depth + 2, nil, 2)
  TableUtility.ArrayClear(popupItems)
  for k, v in pairs(RefineFilter) do
    local data = ReusableTable.CreateTable()
    data.name = string.format(ZhString.ShopMallPreorder_Refine_Text, v.name)
    data.lowerLv = k
    table.insert(popupItems, data)
  end
  for i = 1, 15 do
    local data = ReusableTable.CreateTable()
    data.name = string.format(ZhString.ShopMallPreorder_Refine_Num, tostring(i))
    data.lowerLv = i
    table.insert(popupItems, data)
  end
  table.sort(popupItems, function(l, r)
    return l.lowerLv < r.lowerLv
  end)
  self.lowerFilterGrid:SetData(popupItems)
  self.upperFilterGrid = PopupGridList.new(self:FindGO("upperFilterTabs"), function(self, data)
    if self.selectUpperFilterData ~= data then
      self.selectUpperFilterData = data
      self.upperLv = tonumber(self.selectUpperFilterData.upperLv) or 0
      self:ResetLowerLvFilter()
      self:CheckDamageFilter()
      self:OnClickFilter()
    end
  end, self, self.filterPanel.depth + 2, nil, 2)
  TableUtility.ArrayClear(popupItems)
  for k, v in pairs(RefineFilter) do
    local data = ReusableTable.CreateTable()
    data.name = string.format(ZhString.ShopMallPreorder_Refine_Text, v.name)
    data.upperLv = k
    table.insert(popupItems, data)
  end
  for i = 1, 15 do
    local data = ReusableTable.CreateTable()
    data.name = string.format(ZhString.ShopMallPreorder_Refine_Num, tostring(i))
    data.upperLv = i
    table.insert(popupItems, data)
  end
  table.sort(popupItems, function(l, r)
    return l.upperLv < r.upperLv
  end)
  self.upperFilterGrid:SetData(popupItems)
  local itemType = Table_Item[self.itemid].Type
  local equipKey = GameConfig.NewClassEquip.EnchantEquipTypeRateMap[itemType]
  self.enchantFilterGrid = PopupGridList.new(self:FindGO("enchantFilterTabs"), function(self, data)
    if self.selectEnchantFilterData ~= data then
      self.selectEnchantFilterData = data
      self.buffid = tonumber(self.selectEnchantFilterData.buffid)
      self:OnClickFilter()
    end
  end, self, self.filterPanel.depth + 2, nil, 2)
  TableUtility.ArrayClear(popupItems)
  for k, v in pairs(EnchantFilter) do
    if v.buffid == 0 or EnchantEquipUtil.Instance:CheckEquipEnchantBuff(v.buffid, equipKey, v.UniqIDs) then
      local data = ReusableTable.CreateTable()
      data.id = k
      data.name = string.format(ZhString.ShopMallPreorder_Enchant_Text, v.enchantName)
      data.buffid = v.buffid
      table.insert(popupItems, data)
    end
  end
  table.sort(popupItems, function(l, r)
    return l.id < r.id
  end)
  self.enchantFilterGrid:SetData(popupItems)
  self.brokenFilterGrid = PopupGridList.new(self:FindGO("brokenFilterTabs"), function(self, data)
    if self.selectBrokenFilterData ~= data then
      self.selectBrokenFilterData = data
      self.damage = self.selectBrokenFilterData.state == 1
      self:OnClickFilter()
    end
  end, self, self.filterPanel.depth + 2, nil, 2)
  local exclude = DamageConfig[self.lowerLv]
  TableUtility.ArrayClear(popupItems)
  for k, v in pairs(BrokenFilter) do
    if exclude ~= k then
      local data = ReusableTable.CreateTable()
      data.id = k
      data.name = string.format(ZhString.ShopMallPreorder_Broken_Text, v.name)
      data.state = k
      table.insert(popupItems, data)
    end
  end
  table.sort(popupItems, function(l, r)
    return l.id > r.id
  end)
  self.brokenFilterGrid:SetData(popupItems, exclude == 1)
  self.init = true
end

function ShopMallPreorderEditView:ResetLowerLvFilter()
  if self.lowerFilterGrid and self.init then
    TableUtility.ArrayClear(popupItems)
    for k, v in pairs(RefineFilter) do
      local data = ReusableTable.CreateTable()
      data.name = string.format(ZhString.ShopMallPreorder_Refine_Text, v.name)
      data.lowerLv = k
      table.insert(popupItems, data)
    end
    for i = 1, 15 do
      if i <= self.upperLv or self.upperLv == 0 then
        local data = ReusableTable.CreateTable()
        data.name = string.format(ZhString.ShopMallPreorder_Refine_Num, tostring(i))
        data.lowerLv = i
        table.insert(popupItems, data)
      end
    end
    table.sort(popupItems, function(l, r)
      return l.lowerLv < r.lowerLv
    end)
    self.lowerFilterGrid:SetData(popupItems, true, true)
  end
end

function ShopMallPreorderEditView:CheckDamageFilter()
  if not self.init then
    return
  end
  local exclude = DamageConfig[self.lowerLv]
  local excludeUpper = DamageConfig[self.upperLv]
  TableUtility.ArrayClear(popupItems)
  local skipDamage = false
  for k, v in pairs(BrokenFilter) do
    if self.lowerLv == 0 and self.upperLv == 0 or self.lowerLv > 0 and exclude then
      skipDamage = true
    end
    if exclude ~= k or not skipDamage then
      local data = ReusableTable.CreateTable()
      data.id = k
      data.name = string.format(ZhString.ShopMallPreorder_Broken_Text, v.name)
      data.state = k
      table.insert(popupItems, data)
    end
  end
  table.sort(popupItems, function(l, r)
    return l.id > r.id
  end)
  self.brokenFilterGrid:SetData(popupItems, exclude == 1 or excludeUpper == 1)
end

function ShopMallPreorderEditView:ResetUpperLvFilter()
  if self.upperFilterGrid and self.init then
    TableUtility.ArrayClear(popupItems)
    if self.lowerLv == 0 then
      for k, v in pairs(RefineFilter) do
        local data = ReusableTable.CreateTable()
        data.name = string.format(ZhString.ShopMallPreorder_Refine_Text, v.name)
        data.upperLv = k
        table.insert(popupItems, data)
      end
    end
    for i = 1, 15 do
      if i >= self.lowerLv then
        local data = ReusableTable.CreateTable()
        data.name = string.format(ZhString.ShopMallPreorder_Refine_Num, tostring(i))
        data.upperLv = i
        table.insert(popupItems, data)
      end
    end
    table.sort(popupItems, function(l, r)
      return l.upperLv < r.upperLv
    end)
    self.upperFilterGrid:SetData(popupItems, true, true)
    if self.lowerLv >= self.upperLv then
      local firstcelldata = self.upperFilterGrid:ClickFirstCell(true)
      if firstcelldata then
        self.selectUpperFilterData = firstcelldata
        self.upperLv = tonumber(self.selectUpperFilterData.upperLv)
      end
    end
  end
end

function ShopMallPreorderEditView:OnClickFilter()
  local preorderItemData = PreorderItemData.new()
  preorderItemData.itemid = self.itemid
  preorderItemData.refinelvmin = self.lowerLv
  preorderItemData.refinelvmax = self.upperLv
  preorderItemData.buffid = self.buffid
  preorderItemData.damage = self.damage
  preorderItemData.cardlvmin = self.lowerCardLv
  preorderItemData.cardlvmax = self.upperCardLv
  ServiceRecordTradeProxy.Instance:CallPreorderQueryPriceRecordTradeCmd(preorderItemData)
end

function ShopMallPreorderEditView:RecvTradeCount()
  local left, holding, limit = QuickBuyProxy.Instance:GetTradeCount(self.itemid)
  if limit and 0 < limit then
    self.tradeCount.text = string.format(GameConfig.Exchange.ShopMallPreorder_TradeCount, left, holding, math.max(0, limit - left - holding))
  end
end

function ShopMallPreorderEditView:InitCardFilter()
  if not (self.cardHasLv and self.itemid) or not CardFilter then
    return
  end
  self.cardFilterPanel = self:FindGO("cardFilterPanel"):GetComponent(UIPanel)
  self.initCard = false
  self.lowerCardFilterGrid = PopupGridList.new(self:FindGO("lowerCardFilterTabs"), function(self, data)
    if self.selectLowerCardFilterData ~= data then
      self.selectLowerCardFilterData = data
      self.lowerCardLv = tonumber(self.selectLowerCardFilterData.lowerCardLv) or 0
      self:ResetUpperCardLvFilter()
      self:OnClickFilter()
    end
  end, self, self.cardFilterPanel.depth + 2, nil, 2)
  TableUtility.ArrayClear(popupItems)
  for k, v in pairs(CardFilter) do
    local data = ReusableTable.CreateTable()
    if v.name then
      data.name = string.format(ZhString.ShopMallPreorder_Refine_Text, v.name)
    else
      data.name = string.format(ZhString.ShopMallPreorder_Refine_Num, v.lv)
    end
    data.lowerCardLv = k
    table.insert(popupItems, data)
  end
  table.sort(popupItems, function(l, r)
    return l.lowerCardLv < r.lowerCardLv
  end)
  self.lowerCardFilterGrid:SetData(popupItems)
  self.upperCardFilterGrid = PopupGridList.new(self:FindGO("upperCardFilterTabs"), function(self, data)
    if self.selectUpperCardFilterData ~= data then
      self.selectUpperCardFilterData = data
      self.upperCardLv = tonumber(self.selectUpperCardFilterData.upperCardLv) or 0
      self:ResetLowerCardLvFilter()
      self:OnClickFilter()
    end
  end, self, self.cardFilterPanel.depth + 2, nil, 2)
  TableUtility.ArrayClear(popupItems)
  for k, v in pairs(CardFilter) do
    local data = ReusableTable.CreateTable()
    if v.name then
      data.name = string.format(ZhString.ShopMallPreorder_Refine_Text, v.name)
    else
      data.name = string.format(ZhString.ShopMallPreorder_Refine_Num, v.lv)
    end
    data.upperCardLv = k
    table.insert(popupItems, data)
  end
  table.sort(popupItems, function(l, r)
    return l.upperCardLv < r.upperCardLv
  end)
  self.upperCardFilterGrid:SetData(popupItems)
  self.initCard = true
end

function ShopMallPreorderEditView:ResetUpperCardLvFilter()
  if self.upperCardFilterGrid and self.initCard then
    TableUtility.ArrayClear(popupItems)
    for k, v in pairs(CardFilter) do
      if self.lowerCardLv <= v.lv then
        local data = ReusableTable.CreateTable()
        if v.name then
          data.name = string.format(ZhString.ShopMallPreorder_Refine_Text, v.name)
        else
          data.name = string.format(ZhString.ShopMallPreorder_Refine_Num, v.lv)
        end
        data.upperCardLv = k
        table.insert(popupItems, data)
      end
    end
    table.sort(popupItems, function(l, r)
      return l.upperCardLv < r.upperCardLv
    end)
    self.upperCardFilterGrid:SetData(popupItems, true, true)
    if self.lowerCardLv >= self.upperCardLv then
      local firstcelldata = self.upperCardFilterGrid:ClickFirstCell(true)
      if firstcelldata then
        self.selectUpperCardFilterData = firstcelldata
        self.upperCardLv = tonumber(self.selectUpperCardFilterData.upperCardLv)
      end
    end
  end
end

function ShopMallPreorderEditView:ResetLowerCardLvFilter()
  if self.lowerCardFilterGrid and self.initCard then
    TableUtility.ArrayClear(popupItems)
    for k, v in pairs(CardFilter) do
      local data = ReusableTable.CreateTable()
      data.name = string.format(ZhString.ShopMallPreorder_Refine_Num, v.name or v.lv)
      data.lowerCardLv = k
      table.insert(popupItems, data)
    end
    table.sort(popupItems, function(l, r)
      return l.lowerCardLv < r.lowerCardLv
    end)
    self.lowerCardFilterGrid:SetData(popupItems, true, true)
  end
end
