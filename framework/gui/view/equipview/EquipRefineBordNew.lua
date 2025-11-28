autoImport("EquipNewChooseBord")
autoImport("MaterialChooseBord1")
autoImport("EquipRepairMatCell")
autoImport("BaseItemNewCell")
autoImport("MaterialItemCell1")
autoImport("SafeRefineChooseBord")
EquipRefineBordNew = class("EquipRefineBordNew", CoreView)
EquipRefineBordNew.RefineMode = {
  None = 0,
  Normal = 1,
  Safe = 2,
  Repair = 3
}
EquipRefineBordNew.Event = {
  ClickTargetCell = "ClickTargetCell",
  ClickMatCell = "ClickMatCell",
  DoRefine = "DoRefine",
  DoRepair = "DoRepair",
  DoUseTicket = "DoUseTicket",
  TicketChange = "TicketChange"
}
local DEFAULT_MATERIAL_SEARCH_BAGTYPES, REFINE_MATERIAL_SEARCH_BAGTYPES, REPAIR_MATERIAL_SEARCH_BAGTYPES, LOTTERY_REPAIR_MATERIAL_CFG, EQUIP_REPAIR_MATERIAL_CFG
local Mat_MaxRefineLv = GameConfig.EquipRefine.repair_stuff_max_lv or 12
local itemTipOffset, tempTable, tempArr = {-370, 0}, {}, {}
local resultTickId = 788
local DefaultAddDatas = {"Add"}
local DefaultAdd2Datas = {"Add2"}
local GetLackItem = function(id, count)
  return {id = id, count = count}
end

function EquipRefineBordNew:ctor(go, isFashion, isFromBag, isCombineSize)
  EquipRefineBordNew.super.ctor(self, go)
  if not DEFAULT_MATERIAL_SEARCH_BAGTYPES then
    DEFAULT_MATERIAL_SEARCH_BAGTYPES = GameConfig.PackageMaterialCheck and GameConfig.PackageMaterialCheck.default or {1, 9}
    REFINE_MATERIAL_SEARCH_BAGTYPES = GameConfig.PackageMaterialCheck and GameConfig.PackageMaterialCheck.refine or DEFAULT_MATERIAL_SEARCH_BAGTYPES
    REPAIR_MATERIAL_SEARCH_BAGTYPES = GameConfig.PackageMaterialCheck and GameConfig.PackageMaterialCheck.repair or DEFAULT_MATERIAL_SEARCH_BAGTYPES
    LOTTERY_REPAIR_MATERIAL_CFG = GameConfig.Lottery.repair_material
    EQUIP_REPAIR_MATERIAL_CFG = GameConfig.Lottery.repair_EquipMaterial
  end
  self:Init(isFashion, isFromBag, isCombineSize)
end

function EquipRefineBordNew:Init(isFashion, isFromBag, isCombineSize)
  self.isFromBag = isFromBag
  self:InitData(isFashion)
  self:InitBord()
  self:InitChooseBords(isCombineSize)
  ServiceItemProxy.Instance:CallQueryLotteryHeadItemCmd()
end

function EquipRefineBordNew:InitData(isFashion)
  self.refineMode = EquipRefineBordNew.RefineMode.Normal
  self.maxRefineLv = 0
  self.isBeliever = false
  self.refine_npcguid = nil
end

function EquipRefineBordNew:ForbidTicket(b)
  self.forbidTicket = b
end

function EquipRefineBordNew:ForbidSafeRefine(b)
  self.forbidSafe = b
end

function EquipRefineBordNew:InitBord()
  self.tipStick = self:FindComponent("TipStick", UIWidget)
  self.effContainerRq = self:FindComponent("EffectContainer", ChangeRqByTex)
  self.targetCellGO = self:FindGO("TargetCell")
  local itemGO = self:FindGO("ItemCell", self.targetCellGO)
  self.targetItemCell = ItemCell.new(itemGO)
  self.targetCell_ChooseSymbol = self:FindGO("ChooseSymbol", self.targetCellGO)
  self:AddClickEvent(itemGO, function()
    self:ClickTargetCell()
  end)
  self.emptyBord = self:FindGO("EmptyBord")
  self.refineBord = self:FindGO("RefineBord")
  self.targetRefineInfo = self:FindGO("TargetRefineInfo")
  self.itemName = self:FindComponent("ItemName", UILabel, self.targetRefineInfo)
  self.refineAttr = self:FindGO("RefineAttr", self.targetRefineInfo)
  self.currentRefineLevel = self:FindComponent("CurrentRefineLevel", UILabel, self.refineAttr)
  self.nextRefineLevel = self:FindComponent("NextRefineLevel", UILabel, self.refineAttr)
  self.refineEffect = self:FindComponent("RefineEffect", UILabel, self.refineAttr)
  self.nowEffect = self:FindComponent("NowEffect", UILabel, self.refineAttr)
  self.nextEffect = self:FindComponent("NextEffect", UILabel, self.refineAttr)
  self.refineArrow1 = self:FindGO("RefineArrow1")
  self.refineArrow2 = self:FindGO("RefineArrow2")
  self.refineValSliderGO = self:FindGO("RefineValSlider", self.hRefineBord)
  self.refineValSlider = self.refineValSliderGO:GetComponent(UISlider)
  self.refineValLabel = self:FindComponent("RefineValLabel", UILabel)
  self.refineValAddSliderGO = self:FindGO("AddSlider", self.refineValSliderGO)
  self.refineValAddSlider_Sp = self:FindComponent("Sprite", UISprite, self.refineValAddSliderGO)
  self.refineValAddSlider = self.refineValAddSliderGO:GetComponent(UISlider)
  self.successTip = self:FindGO("SuccessTip")
  self.successTip_Label = self:FindGO("Label", self.successTip):GetComponent(UILabel)
  self.successTip_Symbol = self:FindGO("SuccessSymbol", self.successTip)
  self.refineBreak = self:FindGO("RefineBreak")
  self.costs = self:FindGO("Costs")
  self.safeRefineCost = self:FindGO("SafeRefineCost", self.costs)
  self.safeRefineCost_Split = self:FindGO("Split", self.safeRefineCost)
  self.safeRefineCtl_Static = UIGridListCtrl.new(self:FindComponent("StaticGrid", UIGrid, self.safeRefineCost), MaterialItemCell1, "MaterialItemCell1")
  self.safeRefineCtl_Static:AddEventListener(MouseEvent.MouseClick, self.ClickRefineMatItem, self)
  self.safeRefineCtl_Static:AddEventListener(MouseEvent.MouseClick, self.ClickRefineMatItem, self)
  self.safeRefineCtl_ScrollView = self:FindComponent("ScrollView", UIScrollView, self.safeRefineCost)
  self.safeRefineCtl = UIGridListCtrl.new(self:FindComponent("ScrollView/Grid", UIGrid, self.safeRefineCost), MaterialItemCell1, "MaterialItemCell1")
  self.safeRefineCtl:AddEventListener(MouseEvent.MouseClick, self.ClickRefineMatItem, self)
  self.safeRefineCtl:AddEventListener(MaterialItemCell1.Event.Delete, self.DeleteSafeMat, self)
  self.staticCost = self:FindGO("StaticCost", self.costs)
  self.staticCostCtl = ListCtrl.new(self:FindComponent("ScrollView/Grid", UIGrid, self.staticCost), MaterialItemCell1, "MaterialItemCell1")
  self.staticCostCtl:AddEventListener(MouseEvent.MouseClick, self.ClickStaticMatItem, self)
  self.priceHolder = self:FindGO("PriceHolder", self.costs)
  self.priceLabel = self:FindComponent("Price", UILabel, self.priceHolder)
  self.priceIcon = self:FindGO("Symbol", self.priceHolder):GetComponent(UISprite)
  IconManager:SetItemIcon(Table_Item[100].Icon, self.priceIcon)
  self.repairCost = self:FindGO("RepairCost", self.costs)
  self.repairCostCtl = ListCtrl.new(self:FindComponent("Grid", UIGrid, self.repairCost), MaterialItemCell1, "MaterialItemCell1")
  self.repairCostCtl:AddEventListener(MouseEvent.MouseClick, self.ClickRepairItem, self)
  self.repairValTip = self:FindGO("RepairValTip", self.repairCost)
  self.ticketCost = self:FindGO("TicketCost", self.costs)
  self.ticketCostCtl = ListCtrl.new(self:FindComponent("Grid", UIGrid, self.ticketCost), MaterialItemCell1, "MaterialItemCell1")
  self.ticketCostCtl:AddEventListener(MouseEvent.MouseClick, self.ClickTicketItem, self)
  self.ticketCostCtl:AddEventListener(MaterialItemCell1.Event.Delete, self.DeleteSelectTicket, self)
  self.refineFull = self:FindGO("RefineFull")
  self.refineButtons = self:FindGO("RefineButtons")
  self.refineFull_label = self.refineFull:GetComponent(UILabel)
  self.refineButton = self:FindGO("RefineBtn", self.refineButtons)
  self:AddClickEvent(self.refineButton, function()
    self:ClickRefine()
  end)
  self.safeRefineButton = self:FindGO("SafeRefineBtn", self.refineButtons)
  self:AddClickEvent(self.safeRefineButton, function()
    self:ClickRefine()
  end)
  self.safeRefineToggle = self:FindGO("SafeRefineToggle", self.refineButtons)
  self.safeRefineToggleCheckmark = self:FindGO("Checkmark", self.safeRefineToggle)
  self:AddClickEvent(self.safeRefineToggle, function()
    if self.refineMode == EquipRefineBordNew.RefineMode.Safe then
      self:HideAllChooseBord()
      self:ChangeRefineMode(EquipRefineBordNew.RefineMode.Normal, true)
    elseif self.refineMode == EquipRefineBordNew.RefineMode.Normal then
      self:ChangeRefineMode(EquipRefineBordNew.RefineMode.Safe, true)
    end
  end)
  self.repairButton = self:FindGO("RepairButton", self.refineButtons)
  self:AddClickEvent(self.repairButton, function()
    self:ClickRepair()
  end)
  self.refineDiscount = self:FindGO("Discount", self.refineButtons)
  self.refineDiscount_Label = self:FindComponent("Label", UILabel, self.refineDiscount)
  self.refineAnim = self:FindComponent("53EquipStreng_UI_1", Animator)
end

local GetSafeMaterialVal = function(data, num)
  if not data then
    return 0
  end
  if data:IsEquip() then
    num = num or data.num
    return data.equipInfo:GetSafeRefineMatVal() * num
  end
  return num or data.num
end

function EquipRefineBordNew:DoFillSafeRefineMats()
  if self.isSafeFull then
    return
  end
  local currentlv = self.itemData.equipInfo.refinelv
  if currentlv >= self.safeClamp_max then
    return
  end
  local nowVal, nowMaxVal = self.itemData.equipInfo:GetSafeRefineValInfo(self.safeInDiscount)
  local needVal = nowMaxVal - nowVal
  local selectedMap = {}
  local selectVal = 0
  for i = 1, #self.selectSafeRefineMats do
    local data = self.selectSafeRefineMats[i]
    selectVal = selectVal + GetSafeMaterialVal(data)
    for j = 1, #self.safeRefineMats do
      if self.safeRefineMats[j].id == data.id then
        selectedMap[data.id] = j
        break
      end
    end
  end
  local lackVal = needVal - selectVal
  for i = 1, #self.selectSafeRefineMats do
    local data = self.selectSafeRefineMats[i]
    local matData = self.safeRefineMats[selectedMap[data.id]]
    local deltaNum = matData.num - data.num
    if 0 < deltaNum then
      local singleVal = GetSafeMaterialVal(data, 1)
      local lackNum = math.ceil(lackVal / singleVal)
      if deltaNum >= lackNum then
        data.num = data.num + lackNum
        lackVal = 0
      else
        data.num = data.num + deltaNum
        lackVal = lackVal - deltaNum * singleVal
      end
    end
    if lackVal <= 0 then
      break
    end
  end
  if 0 < lackVal then
    local fillDatas = BlackSmithProxy.Instance:DoFitEquipRefineVal(self.safeRefineMats, lackVal, EquipRefineBordNew.CheckItemCanRefine)
    if fillDatas then
      for i = 1, #fillDatas do
        local index, num = fillDatas[i].index, fillDatas[i].num
        if not selectedMap[fillDatas[i].id] then
          local data = self.safeRefineMats[index]:Clone()
          self.safeRefineMats[index].chooseCount = num
          data.num = num
          table.insert(self.selectSafeRefineMats, data)
        end
      end
    end
  end
  self:UpdateRefineAttr()
  self:UpdateRefineMaterialsCtrl()
  self:ShowSafeRefineMaterialBord(true)
  self:HideAllChooseBord()
end

function EquipRefineBordNew:ClickTargetCell()
  TipManager.CloseTip()
  self:SetTargetItem()
  self:HideAllChooseBord()
  self:PassEvent(EquipRefineBordNew.Event.ClickTargetCell, self)
  self:sendNotification(ItemEvent.EquipChooseSuccess)
end

function EquipRefineBordNew:ChangeRefineMode(refineMode, fromClickEvent)
  local nowData = self.itemData
  if nowData == nil then
    return
  end
  if fromClickEvent and self.forbiddenRefineMode then
    return
  end
  self.refineMode = refineMode
  self:Refresh()
end

function EquipRefineBordNew:ClickRefineMatItem(cellCtl)
  local d = cellCtl.data
  if type(d) == "table" and d.isStaticCost then
    self:ShowItemInfoTip(cellCtl)
  elseif type(cellCtl.data) == "table" then
    self:ShowSafeRefineMaterialBord()
  elseif Table_Exchange[self.itemData.staticData.id] then
    local lackNum = self.itemData.equipInfo:GetSafeRefineCostNum(self.itemData.equipInfo.refinelv + 1)
    if self.selectSafeRefineMats and #self.selectSafeRefineMats > 0 then
      for i = 1, #self.selectSafeRefineMats do
        lackNum = lackNum - GetSafeMaterialVal(self.selectSafeRefineMats[i])
      end
    end
    if 0 < lackNum then
      self:TryOpenQuickBuyView(self.safeMatDefaultData.staticData.id, lackNum)
    end
  end
end

function EquipRefineBordNew:DeleteSafeMat(cellCtl)
  local data = cellCtl.data
  if type(data) ~= "table" then
    return
  end
  for i = #self.selectSafeRefineMats, 1, -1 do
    if self.selectSafeRefineMats[i].id == cellCtl.data.id then
      table.remove(self.selectSafeRefineMats, i)
      break
    end
  end
  self.refineChooseBord:SetChooseReference(self.selectSafeRefineMats, true)
  self:UpdateRefineAttr()
  self:UpdateRefineMaterialsCtrl()
end

function EquipRefineBordNew:ClickStaticMatItem(cellCtl)
  self:ShowItemInfoTip(cellCtl)
end

function EquipRefineBordNew:ClickRepairItem(cellCtl)
  local data = cellCtl.data
  if data and data.neednum and data.neednum > data.num then
    return self:TryOpenQuickBuyView(data.staticData.id, data.neednum - data.num)
  end
  self:ShowRepairMaterialBord()
end

function EquipRefineBordNew:ClickTicketItem(cellCtl)
  if self.forbidTicket then
    return
  end
  local d = cellCtl.data
  if type(d) == "table" and d.showDelete then
    self:ShowItemInfoTip(cellCtl)
  else
    self:ShowRefineTicketsBord()
  end
end

function EquipRefineBordNew:DeleteSelectTicket()
  self:mSelectTicket(nil)
  self:Refresh()
  self:HideAllChooseBord()
  if self.itemData then
    self:ShowRefineTicketsBord()
  end
  self:PassEvent(EquipRefineBordNew.Event.TicketChange, self)
end

function EquipRefineBordNew:ShowItemInfoTip(cell)
  if type(cell.data) ~= "table" then
    return
  end
  if not self.ShowTip then
    if not self.tipdata then
      self.tipdata = {
        callback = function()
          self.ShowTip = false
        end
      }
    end
    self.tipdata.itemdata = cell.data
    self.tipdata.ignoreBounds = cell.gameObject
    self:ShowItemTip(self.tipdata, self.tipStick, NGUIUtil.AnchorSide.Left, itemTipOffset)
  else
    self:ShowItemTip()
  end
end

function EquipRefineBordNew:ClickRefine()
  local nowData = self.itemData
  if nowData then
    if nowData.equipInfo.refinelv >= 4 then
      TableUtility.TableClear(tempTable)
      tempTable.itemData = nowData
      FunctionSecurity.Me():RefineEquip(function()
        self:DoRefine(nowData)
      end, tempTable)
    else
      self:DoRefine(nowData)
    end
  else
    MsgManager.ShowMsgByIDTable(216)
  end
end

function EquipRefineBordNew:DoRefineAnim()
  self.refineAnim:Play("state2001")
end

local callSafeRefine = function(self, nowData)
  local selectSafeEquipIds = {}
  local equips = {}
  for i = 1, #self.selectSafeRefineMats do
    selectSafeEquipIds[i] = self.selectSafeRefineMats[i]:ExportServerItemInfo()
    if self.selectSafeRefineMats[i]:IsEquip() then
      table.insert(equips, self.selectSafeRefineMats[i])
    end
  end
  if FunctionItemFunc.RecoverEquips(equips) then
    return
  end
  redlog("安全精炼", nowData.id, self.safeComposeID, innerString(selectSafeEquipIds))
  ServiceItemProxy.Instance:CallEquipRefine(nowData.id, nil, nil, nil, self.refine_npcguid, true, selectSafeEquipIds, self.refineTolv)
  self:DoRefineAnim()
  self:PassEvent(EquipRefineBordNew.Event.DoRefine, self)
  self:sendNotification(HomeEvent.WorkbenchStartWork)
end

function EquipRefineBordNew:DoRefine(nowData)
  local equipInfo = nowData.equipInfo
  if equipInfo.refinelv >= self.maxRefineLv then
    MsgManager.ShowMsgByIDTable(217)
    return
  end
  if equipInfo.damage then
    MsgManager.ShowMsgByIDTable(228)
    return
  end
  if BagProxy.Instance:CheckBagIsFull(BagProxy.BagType.MainBag) then
    MsgManager.ShowMsgByIDTable(3101)
    return
  end
  if self.needROB and MyselfProxy.Instance:GetROB() < self.needROB then
    MsgManager.ShowMsgByIDTable(40803)
    return
  end
  if self.outStaticCostMats then
    for i = 1, #self.outStaticCostMats do
      local d = self.outStaticCostMats[i]
      if d.num < d.neednum then
        MsgManager.ShowMsgByID(25418, d:GetName())
        return
      end
    end
  end
  if self.staticCostMats then
    for i = 1, #self.staticCostMats do
      local d = self.staticCostMats[i]
      if d.num < d.neednum then
        if d.staticData.id == 100 then
          MsgManager.ShowMsgByID(25418, d:GetName())
        else
          self:TryOpenQuickBuyView(d.staticData.id, d.neednum - d.num)
        end
        return
      end
    end
  end
  if self.refineMode == EquipRefineBordNew.RefineMode.Safe then
    if not self.isSafeMatEnough then
      MsgManager.ShowMsgByID(43298)
      return
    end
    if self.isSafeMatOverFlow and self.selectSafeRefineMats and #self.selectSafeRefineMats > 0 then
      MsgManager.ConfirmMsgByID(43300, function()
        callSafeRefine(self, nowData)
      end, nil, nil, tostring(self.refineTolv))
    else
      callSafeRefine(self, nowData)
    end
  else
    redlog("精炼", nowData.id, self.refineTolv)
    if self.outStaticCostMats and #self.outStaticCostMats > 0 then
      MsgManager.ConfirmMsgByID(42137, function()
        ServiceItemProxy.Instance:CallItemUse(self.outStaticCostMats[1], nil, nil, nil, {
          nowData.id
        })
        self:DoRefineAnim()
        self:PassEvent(EquipRefineBordNew.Event.DoRefine, self)
        self:sendNotification(HomeEvent.WorkbenchStartWork)
      end, nil, nil, string.format("+%s", self.outset_maxrefine))
    elseif self.selectTickets and 0 < #self.selectTickets then
      redlog("使用精炼券", nowData.id)
      self:DoRefineAnim()
      ServiceItemProxy.Instance:CallItemUse(self.selectTickets[1], nil, nil, nil, {
        nowData.id
      })
      self:PassEvent(EquipRefineBordNew.Event.DoUseTicket, self)
      self:mSelectTicket(nil)
    else
      ServiceItemProxy.Instance:CallEquipRefine(nowData.id, nil, nil, nil, self.refine_npcguid, false, nil, nil)
      self:DoRefineAnim()
      self:PassEvent(EquipRefineBordNew.Event.DoRefine, self)
      self:sendNotification(HomeEvent.WorkbenchStartWork)
    end
  end
end

local callEquipRepair = function(self, itemData, matData)
  local matId = matData and matData.id
  if matId then
    local realMatData = BagProxy.Instance:GetItemByGuid(matId)
    if BagProxy.Instance:CheckIsFavorite(realMatData) then
      MsgManager.ShowMsgByIDTable(233)
      return
    end
  end
  ServiceItemProxy.Instance:CallEquipRepair(itemData.id, nil, matId)
  self:PassEvent(EquipRefineBordNew.Event.DoRepair, self)
  self:HideAllChooseBord()
end

function EquipRefineBordNew:ClickRepair()
  local nowData = self.itemData
  if nowData == nil then
    MsgManager.ShowMsgByIDTable(224)
    return
  end
  if nowData.equipInfo.extra_refine_value > 0 then
    callEquipRepair(self, nowData)
    return
  end
  local matdata = self.selectRepairDatas[1]
  if not matdata or matdata == self.repairDefaultData then
    local lackNum = self.repairDefaultData.neednum - self.repairDefaultData.num
    self:TryOpenQuickBuyView(self.repairDefaultData.staticData.id, lackNum)
    return
  end
  if matdata:IsEquip() then
    local matRefinelv = matdata.equipInfo.refinelv
    local tipRefinelv = GameConfig.EquipRefine.repair_stuff_msg_lv or 4
    local maxRevinelv = GameConfig.EquipRefine.repair_stuff_max_lv or 6
    if matRefinelv > maxRevinelv then
      MsgManager.ShowMsgByIDTable(241)
      return
    end
    if FunctionItemFunc.RecoverEquips({matdata}) then
      return
    end
    if 1 < matdata.equipInfo:GetSafeRefineMatVal() then
      MsgManager.ConfirmMsgByID(43301, function()
        callEquipRepair(self, nowData, matdata)
      end, nil, nil)
    elseif matRefinelv >= tipRefinelv then
      MsgManager.ConfirmMsgByID(934, function()
        callEquipRepair(self, nowData, matdata)
      end, nil, nil, matRefinelv)
    else
      callEquipRepair(self, nowData, matdata)
    end
  else
    callEquipRepair(self, nowData, matdata)
  end
end

function EquipRefineBordNew:Refresh()
  local nowData = self.itemData
  local canRefine = nowData and nowData.equipInfo and nowData.equipInfo:CanRefine() or false
  self.targetItemCell:SetData(nowData)
  self.targetItemCell:ActiveNewTag(false)
  local ticket = self:GetSelectTicket()
  if ticket and not EquipRefineBordNew.mIsTicketValid(ticket, nowData) then
    self:mSelectTicket(nil)
  end
  self:UpdateRefineUI()
  self:UpdateRefineAttr()
  self:UpdateRefineMaterialsCtrl()
  if nowData then
    self.targetRefineInfo:SetActive(canRefine)
    self.refineBord:SetActive(true)
    self.emptyBord:SetActive(false)
    self.itemName.text = string.format("+%s%s", nowData.equipInfo.refinelv, nowData:GetName(true, true))
    self.refineAnim:Play("state2002")
  else
    self.targetRefineInfo:SetActive(false)
    if self.selectTickets and #self.selectTickets > 0 then
      self.refineBord:SetActive(true)
      LuaGameObject.SetLocalPositionObj(self.emptyBord, 7, -260, 0)
    else
      self.refineBord:SetActive(false)
      LuaGameObject.SetLocalPositionObj(self.emptyBord, 7, -260, 0)
    end
    self.emptyBord:SetActive(true)
    self.refineAnim:Play("state1002")
  end
end

local EmptyTicketStaticDatas = {
  MaterialItemCell1.EmptyData.Space,
  MaterialItemCell1.EmptyData.Space
}

function EquipRefineBordNew:mSetStaticCostCtrl(datas)
  if (not datas or #datas == 0) and self.selectTickets and self.selectTickets[1] then
    datas = EmptyTicketStaticDatas
  end
  if 2 < #datas then
    LuaGameObject.SetLocalPositionObj(self.staticCostCtl.layoutCtrl, -98.6, 0, 0)
    self.staticCostCtl.layoutCtrl.pivot = 3
  else
    LuaGameObject.SetLocalPositionObj(self.staticCostCtl.layoutCtrl, 0, 0, 0)
    self.staticCostCtl.layoutCtrl.pivot = 4
  end
  self.staticCostCtl:ResetDatas(datas)
end

function EquipRefineBordNew:UpdateRefineMaterialsCtrl()
  local nowData = self.itemData
  local refinelv, extra_refine_value = 0, 0
  if nowData then
    refinelv, extra_refine_value = nowData.equipInfo.refinelv, nowData.equipInfo.extra_refine_value
  end
  if self.maxRefineLv ~= 0 and refinelv >= self.maxRefineLv then
    self.costs:SetActive(false)
    return
  end
  self:UpdateStaticCostMats()
  if self.refineMode ~= EquipRefineBordNew.RefineMode.Repair and self.refineMode ~= EquipRefineBordNew.RefineMode.None and self.needROB then
    self.priceHolder:SetActive(true)
    self.priceLabel.text = StringUtil.NumThousandFormat(self.needROB)
    self.priceLabel.color = MyselfProxy.Instance:GetROB() < self.needROB and ColorUtil.Red or LuaGeometry.GetTempVector4(0.3333333333333333, 0.3568627450980392, 0.43137254901960786, 1)
  else
    self.priceHolder:SetActive(false)
  end
  if self.refineMode == EquipRefineBordNew.RefineMode.Repair then
    if 0 < extra_refine_value then
      self.repairCostCtl:ResetDatas(_EmptyTable)
      self.repairValTip:SetActive(true)
    else
      self.repairValTip:SetActive(false)
      if not self.staticCostUIDatas then
        self.staticCostUIDatas = {}
      else
        TableUtility.ArrayClear(self.staticCostUIDatas)
      end
      if #self.selectRepairDatas == 0 then
        if self.repairDefaultData then
          table.insert(self.staticCostUIDatas, self.repairDefaultData)
        end
        self.isRepairMatFull = false
      else
        self.isRepairMatFull = true
        local d
        for i = 1, #self.selectRepairDatas do
          d = self.selectRepairDatas[i]
          if d.num < d.neednum then
            self.isRepairMatFull = false
          end
          table.insert(self.staticCostUIDatas, d)
        end
      end
      self.repairCostCtl:ResetDatas(self.staticCostUIDatas)
    end
  elseif self.refineMode == EquipRefineBordNew.RefineMode.Safe then
    if self.materialPosDirty then
      self.materialPosDirty = false
      self:ShowSafeRefineMaterialBord()
    else
      self:ShowSafeRefineMaterialBord(true)
    end
    local staticDatas = self.outStaticCostMats or self.staticCostMats
    if not staticDatas or #staticDatas == 0 then
      staticDatas = DefaultAdd2Datas
    end
    self.safeRefineCtl_Static:ResetDatas(staticDatas)
    LuaGameObject.SetLocalPositionGO(self.safeRefineCost_Split, -232 + 95 * #staticDatas, -17, 0)
    if not self.safeUIDatas then
      self.safeUIDatas = {}
    else
      TableUtility.ArrayClear(self.safeUIDatas)
    end
    for i = 1, #self.selectSafeRefineMats do
      table.insert(self.safeUIDatas, self.selectSafeRefineMats[i])
    end
    local addlen = math.max(#self.safeUIDatas + 1, 5)
    for i = #self.safeUIDatas + 1, addlen do
      table.insert(self.safeUIDatas, MaterialItemCell1.EmptyData.Add)
    end
    self.safeRefineCtl:ResetDatas(self.safeUIDatas)
    self.safeRefineCtl_ScrollView.panel:UpdateAnchors()
    self.safeRefineCtl_ScrollView:ResetPosition()
  else
    if self.outStaticCostMats then
      self:mSetStaticCostCtrl(self.outStaticCostMats)
    elseif self.staticCostMats then
      self:mSetStaticCostCtrl(self.staticCostMats)
    else
      self:mSetStaticCostCtrl(_EmptyTable)
    end
    if self.forbidTicket then
      self.ticketCostCtl:ResetDatas(DefaultAddDatas)
    elseif not self.selectTickets or #self.selectTickets == 0 then
      self.ticketCostCtl:ResetDatas(DefaultAdd2Datas)
    else
      self.ticketCostCtl:ResetDatas(self.selectTickets)
    end
  end
end

function EquipRefineBordNew:ActiveRefineButton(b)
  if not self.refineButtonSp then
    self.refineButtonSp = self.refineButton:GetComponent(UISprite)
    self.refineButtonCollider = self.refineButton:GetComponent(BoxCollider)
    self.refineButtonLabel = self:FindComponent("Label", UILabel, self.refineButton)
  end
  if b then
    self.refineButtonSp.color = LuaGeometry.GetTempColor(1, 1, 1, 1)
    self.refineButtonCollider.enabled = true
    self.refineButtonLabel.effectColor = LuaGeometry.GetTempColor(0.6862745098039216, 0.3686274509803922, 0 / 255, 1)
  else
    self.refineButtonSp.color = LuaGeometry.GetTempColor(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)
    self.refineButtonCollider.enabled = false
    self.refineButtonLabel.effectColor = LuaGeometry.GetTempColor(0.6862745098039216, 0.6862745098039216, 0.6862745098039216, 1)
  end
end

function EquipRefineBordNew:UpdateRefineUI()
  local nowData = self.itemData
  local refinelv = nowData and nowData.equipInfo.refinelv or 0
  local canRefine = nowData and nowData.equipInfo and nowData.equipInfo:CanRefine() or false
  local equipType = nowData and nowData.equipInfo and nowData.equipInfo.equipData.EquipType
  if canRefine and self.isFashion and self.selectTickets[1] == nil then
    canRefine = GuildBuildingProxy.Instance:GetMiyinRefineValid(equipType)
    xdlog("首饰合法", canRefine)
  end
  if nowData and not canRefine then
    self.refineFull:SetActive(true)
    if self.isFashion then
      local miyinRefineUnlockLv = GuildBuildingProxy.Instance:GetMiyinRefineUnlockLv(equipType)
      if miyinRefineUnlockLv then
        local equipTypeConfig = GameConfig.EquipType[equipType]
        local equipTypeName = equipTypeConfig and equipTypeConfig.name
        self.refineFull_label.text = string.format(ZhString.EquipRefineBordNew_RefineTip_UnlockTip, miyinRefineUnlockLv, equipTypeName)
      else
        self.refineFull_label.text = ZhString.EquipRefineBordNew_RefineInvalid
      end
    else
      self.refineFull_label.text = ZhString.EquipRefineBordNew_RefineInvalid
    end
    self.safeRefineToggle:SetActive(false)
    self.refineButtons:SetActive(false)
    self.costs:SetActive(false)
    self.refineBreak:SetActive(false)
  elseif refinelv >= self.maxRefineLv then
    self.refineFull:SetActive(true)
    if self.isFashion and self.maxRefineLv < 15 then
      local nextRefineMaxLv = GuildBuildingProxy.Instance:GetNextRefineMaxUpLv(self.maxRefineLv) or 1
      self.refineFull_label.text = string.format(ZhString.EquipRefineBordNew_RefineTip_MaxUp, nextRefineMaxLv)
    else
      self.refineFull_label.text = ZhString.EquipRefineBordNew_RefineTip_Full
    end
    self.safeRefineToggle:SetActive(false)
    self.refineButtons:SetActive(false)
    self.costs:SetActive(false)
    self.refineBreak:SetActive(false)
  elseif self.refineMode == EquipRefineBordNew.Safe and refinelv >= self.safeClamp_max then
    self.refineFull:SetActive(true)
    self.refineFull_label.text = string.format(ZhString.EquipRefineBordNew_TopSafeRefine, self.safeClamp_max)
    self.safeRefineToggle:SetActive(false)
    self.refineButtons:SetActive(false)
    self.costs:SetActive(false)
    self.refineBreak:SetActive(false)
  else
    self.refineFull:SetActive(false)
    self.costs:SetActive(true)
    self.refineButtons:SetActive(true)
    if self.refineMode == EquipRefineBordNew.RefineMode.Repair then
      self.repairCost:SetActive(true)
      self.staticCost:SetActive(false)
      self.ticketCost:SetActive(false)
      self.safeRefineCost:SetActive(false)
      self.refineButton:SetActive(false)
      self.safeRefineButton:SetActive(false)
      self.repairButton:SetActive(true)
      self.safeRefineToggleCheckmark:SetActive(false)
      self.safeRefineToggle:SetActive(false)
      self.refineBreak:SetActive(true)
    else
      self.refineBreak:SetActive(false)
      local isUsingFashionTicket = self.isFashion and self.isFromBag
      if self.refineMode == EquipRefineBordNew.RefineMode.Safe then
        self.repairCost:SetActive(false)
        self.staticCost:SetActive(false)
        self.ticketCost:SetActive(false)
        self.safeRefineCost:SetActive(true)
        self.refineButton:SetActive(false)
        self.safeRefineButton:SetActive(true)
        self.repairButton:SetActive(false)
        self.safeRefineToggleCheckmark:SetActive(true)
        self.refineDiscount:SetActive(self.safeInDiscount)
        if self.safeInDiscount then
          self.refineDiscount_Label.text = string.format("%d%%", 100 - self.safeDiscount)
        end
      else
        self.repairCost:SetActive(false)
        self.staticCost:SetActive(true)
        self.ticketCost:SetActive(true)
        self.safeRefineCost:SetActive(false)
        self.refineButton:SetActive(self.itemData ~= nil)
        if isUsingFashionTicket and self.itemData then
          self:ActiveRefineButton(self.selectTickets[1] ~= nil)
        end
        self.safeRefineButton:SetActive(false)
        self.repairButton:SetActive(false)
        self.safeRefineToggleCheckmark:SetActive(false)
        if self.refineMode ~= EquipRefineBordNew.RefineMode.None then
          self.refineDiscount:SetActive(self.normalInDiscount == true)
          if self.discount then
            self.refineDiscount_Label.text = string.format("%d%%", 100 - self.discount)
          end
        else
          self.refineDiscount:SetActive(false)
        end
      end
      if self.forbidSafe or isUsingFashionTicket then
        self.safeRefineToggle:SetActive(false)
      else
        self.safeRefineToggle:SetActive(refinelv < self.safeClamp_max and refinelv >= self.safeClamp_min - 1)
      end
    end
  end
end

function EquipRefineBordNew:ActiveTargetCellChooseSymbol(b)
  if self.targetCell_ChooseSymbol then
    self.targetCell_ChooseSymbol:SetActive(b)
  end
end

function EquipRefineBordNew:UpdateRefineAttr()
  local nowData = self.itemData
  if not nowData then
    self:SetRefineValSlider(0, 0)
    return
  end
  self.isSafeFull = false
  local nowval, nowMaxval = nowData.equipInfo:GetSafeRefineValInfo(self.safeInDiscount)
  local currentLv = nowData.equipInfo.refinelv
  if self.refineMode == EquipRefineBordNew.RefineMode.Repair then
    self.refineTolv = nil
    local proName, now, next = ItemUtil.GetRefineAttrPreview(nowData.equipInfo, nil, true)
    self.refineArrow1:SetActive(false)
    self.refineArrow2:SetActive(false)
    LuaGameObject.SetLocalPositionObj(self.nextRefineLevel, -42, 0, 0)
    LuaGameObject.SetLocalPositionObj(self.nextEffect, -42, 0, 0)
    self.currentRefineLevel.text = ""
    self.nextRefineLevel.text = string.format(ZhString.EquipRefineBordNew_RedColor, "+" .. currentLv)
    self.refineEffect.text = proName
    self.nowEffect.text = ""
    self.nextEffect.text = string.format(ZhString.EquipRefineBordNew_RedColor, now)
    self.refineValSliderGO:SetActive(true)
    self.refineValAddSliderGO:SetActive(false)
    if 0 < nowval then
      self:SetRefineValSlider((nowval - 1) / nowval, 1 / nowval, string.format("%s/%s", nowval - 1, nowval == EquipInfo.MaxRefineVal and "-" or nowval), "concise_line_bg4")
    else
      self:SetRefineValSlider(0, 0)
    end
  else
    local nowData = self.itemData
    local currentlv = nowData.equipInfo.refinelv
    local leftCost, nextCost
    self.refineTolv = nil
    if self.refineMode == EquipRefineBordNew.RefineMode.Safe then
      self.refineValSliderGO:SetActive(currentlv < self.maxRefineLv)
      local addval = 0
      if self.selectSafeRefineMats then
        for i = 1, #self.selectSafeRefineMats do
          addval = addval + GetSafeMaterialVal(self.selectSafeRefineMats[i])
        end
      end
      self.refineTolv, leftCost, nextCost = nowData.equipInfo:CalSafeRefineResult(addval, self.safeInDiscount)
      addval = addval + nowval
      self.isSafeFull = self.refineTolv >= self.safeClamp_max
      self.isSafeMatEnough = currentlv < self.refineTolv
      self.isSafeMatOverFlow = nextCost < addval
      local progress
      if nowMaxval == 0 then
        progress = 0
      else
        progress = math.clamp(nowval / nowMaxval, 0, 1)
      end
      local deltaProgress = math.min(addval / nextCost, 1) - progress
      local text
      if self.isSafeMatEnough then
        text = string.format("%s/%s", addval, nextCost == EquipInfo.MaxRefineVal and "-" or nextCost)
      else
        text = string.format("[c][FF6021]%s/%s[-][/c]", addval, nextCost == EquipInfo.MaxRefineVal and "-" or nextCost)
      end
      self:SetRefineValSlider(progress, deltaProgress, text)
    elseif self.refineMode == EquipRefineBordNew.RefineMode.Normal then
      if self.selectTickets[1] then
        local useData = Table_UseItem[self.selectTickets[1].staticData.id]
        local useEffect = useData and useData.UseEffect
        if useEffect then
          self.refineTolv = useEffect.refine_lv or useEffect.refine_level
        end
        if not self.refineTolv then
          self.refineTolv = currentLv + 1
        end
      else
        self.refineTolv = currentLv + 1
      end
      local progress = 0
      if nowMaxval ~= 0 then
        progress = math.min(nowval / nowMaxval, 1)
      end
      self:SetRefineValSlider(progress, nil, string.format("%s/%s", nowval, nowMaxval == EquipInfo.MaxRefineVal and "-" or nowMaxval))
    else
      self:SetRefineValSlider()
    end
    local proName, now, next = ItemUtil.GetRefineAttrPreview(nowData.equipInfo, self.refineTolv, true)
    local isMax = currentLv >= self.maxRefineLv
    if self.isFashion then
      local equipType = nowData and nowData.equipInfo and nowData.equipInfo.equipData.EquipType
      local canRefine = GuildBuildingProxy.Instance:GetMiyinRefineValid(equipType)
      if not canRefine then
        isMax = true
      end
    end
    self.refineArrow1:SetActive(not isMax)
    self.refineArrow2:SetActive(not isMax)
    if not StringUtil.IsEmpty(proName) then
      self.refineEffect.text = proName
    end
    if isMax then
      LuaGameObject.SetLocalPositionObj(self.nextRefineLevel, -43, 0, 0)
      LuaGameObject.SetLocalPositionObj(self.nextEffect, -43, 0, 0)
      self.currentRefineLevel.text = ""
      self.nextRefineLevel.text = "+" .. currentLv
      self.nowEffect.text = ""
      self.nextEffect.text = now
    else
      LuaGameObject.SetLocalPositionObj(self.nextRefineLevel, 94.6, 0, 0)
      LuaGameObject.SetLocalPositionObj(self.nextEffect, 94.6, 0, 0)
      self.currentRefineLevel.text = "+" .. currentLv
      self.nextRefineLevel.text = string.format(ZhString.EquipRefineBordNew_GreenColor, "+" .. self.refineTolv)
      self.nowEffect.text = now
      self.nextEffect.text = string.format(ZhString.EquipRefineBordNew_GreenColor, next)
    end
  end
end

function EquipRefineBordNew:SetRefineValSlider(progress, addProgress, text, spriteName)
  if not progress then
    self.refineValSliderGO:SetActive(false)
    self.refineValAddSliderGO:SetActive(false)
    self.successTip:SetActive(false)
    return
  end
  addProgress = addProgress or 0
  if self.refineMode == EquipRefineBordNew.RefineMode.Repair then
    self.successTip:SetActive(false)
  elseif self.refineMode == EquipRefineBordNew.RefineMode.Safe then
    self.successTip:SetActive(1 <= progress + addProgress)
    self.successTip_Label.text = string.format(ZhString.EquipRefineBordNew_RefineRate, 100 .. "%")
    self.successTip_Label.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(4.67, -0.4, 0)
    self.successTip_Symbol:SetActive(true)
  elseif self.itemData and self.selectTickets[1] then
    self.successTip:SetActive(true)
    self.successTip_Label.text = string.format(ZhString.EquipRefineBordNew_RefineRate, 100 .. "%")
    self.successTip_Label.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(4.67, -0.4, 0)
    self.successTip_Symbol:SetActive(true)
  else
    local nowData = self.itemData
    local currentlv = nowData and nowData.equipInfo.refinelv
    local refineToLv = self.refineTolv
    local maxRefineLv = self.maxRefineLv
    if self.isFashion then
      local equipType = nowData and nowData.equipInfo and nowData.equipInfo.equipData.EquipType
      local canRefine = GuildBuildingProxy.Instance:GetMiyinRefineValid(equipType)
      if not canRefine then
        maxRefineLv = 0
      end
    else
      local canRefine = nowData and nowData.equipInfo and nowData.equipInfo:CanRefine()
      if not canRefine then
        maxRefineLv = 0
      end
    end
    local rate = GameConfig.EquipRefine and GameConfig.EquipRefine.Rate and GameConfig.EquipRefine.Rate[refineToLv]
    if rate and currentlv < maxRefineLv then
      self.successTip:SetActive(true)
      self.successTip_Label.text = string.format(ZhString.EquipRefineBordNew_RefineRate, rate .. "%")
      self.successTip_Label.gameObject.transform.localPosition = 100 <= rate and LuaGeometry.GetTempVector3(4.67, -0.4, 0) or LuaGeometry.GetTempVector3(-10, -0.4, 0)
      self.successTip_Symbol:SetActive(100 <= rate)
    else
      self.refineValSliderGO:SetActive(false)
      self.refineValAddSliderGO:SetActive(false)
      self.successTip:SetActive(false)
    end
  end
  self.refineValSlider.value = math.clamp(progress, 0, 1)
  if addProgress and 0 < addProgress then
    self.refineValAddSliderGO:SetActive(true)
    self.refineValAddSlider_Sp.spriteName = spriteName or "concise_line_bg3"
    LuaGameObject.SetLocalPositionGO(self.refineValAddSliderGO, 478 * progress, 0, 0)
    self.refineValAddSlider.value = addProgress
  else
    self.refineValAddSliderGO:SetActive(false)
  end
  self.refineValLabel.text = text
end

function EquipRefineBordNew:TryOpenQuickBuyView(id, num, noSetLimit)
  local datas = {}
  local vidCache = EquipRepairProxy.Instance:GetEquipVIDCache(id)
  if vidCache and not ItemData.SIsFashion(id) then
    for k, v in pairs(vidCache) do
      local baseVal = 1 + EquipInfo.SGetSafeRefineMatVal_SlotExtra(v.id)
      table.insert(datas, {
        id = v.id,
        count = math.ceil(num / baseVal)
      })
    end
  else
    table.insert(datas, {id = id, count = num})
  end
  if not noSetLimit then
    QuickBuyProxy.Instance:SetSafeRefineLimitVal(num)
  end
  return QuickBuyProxy.Instance:TryOpenView(datas)
end

function EquipRefineBordNew:InitChooseBords(isCombineSize)
  local chooseContainer = self:FindGO("ChooseContainer")
  self.chooseBord = EquipNewChooseBord.new(chooseContainer)
  local _safeRefineControl = isCombineSize and SafeRefineChooseBord_CombineSize or SafeRefineChooseBord
  self.refineChooseBord = _safeRefineControl.new(chooseContainer)
  self.refineChooseBord:AddEventListener(MaterialChooseBord1.Event.CountChooseChange, self.OnCountChooseChange_SafeRefine, self)
  self.refineChooseBord:SetBordTitle(ZhString.EquipRefineBordNew_SafeRefineTitle)
  self.refineChooseBord:SetAutoFillEvent(self.DoFillSafeRefineMats, self)
  self.refineChooseBord:SetValidEvent(self.CheckItemCanRefine, self)
  self.repairChooseBord = MaterialChooseBord1_CombineSize.new(chooseContainer)
  self.repairChooseBord:AddEventListener(MaterialChooseBord1.Event.CountChooseChange, self.OnCountChooseChange_Repair, self)
  self.repairChooseBord:SetBordTitle(ZhString.EquipRefineBordNew_RepairTitle)
  self.repairChooseBord:SetValidEvent(self.CheckItemCanRefine, self)
  self.ticketChooseBord = MaterialChooseBord1_CombineSize.new(chooseContainer)
  self.ticketChooseBord:SetBordTitle(ZhString.EquipRefineBordNew_TicketTitle)
  self.ticketChooseBord:SetValidEvent(self.CheckTicketValid, self, 43390)
  self:HideAllChooseBord()
end

function EquipRefineBordNew.mIsTicketValid(ticket, itemData)
  if not itemData then
    return true
  end
  return BlackSmithProxy.IsTicketCanUseFor(ticket, itemData)
end

function EquipRefineBordNew:CheckTicketValid(ticket)
  return EquipRefineBordNew.mIsTicketValid(ticket, self.itemData)
end

function EquipRefineBordNew:OnCountChooseChange_SafeRefine(cell)
  local data, chooseCount = cell.data, cell.chooseCount
  if not data or not chooseCount then
    return
  end
  local matData, index
  local selectedVal = 0
  for i = 1, #self.selectSafeRefineMats do
    selectedVal = selectedVal + GetSafeMaterialVal(self.selectSafeRefineMats[i])
    if self.selectSafeRefineMats[i].id == data.id then
      matData = self.selectSafeRefineMats[i]
      index = i
    end
  end
  local totalCount = 0
  local equipInfo = self.itemData.equipInfo
  for i = equipInfo.refinelv + 1, self.safeClamp_max do
    totalCount = totalCount + equipInfo:GetSafeRefineCostNum(i, self.safeInDiscount)
  end
  local leftCount = totalCount - (selectedVal + self.itemData.equipInfo.extra_refine_value)
  leftCount = math.max(0, leftCount)
  leftCount = math.ceil(leftCount / GetSafeMaterialVal(data, 1))
  if matData then
    leftCount = leftCount + matData.num
    if chooseCount > leftCount then
      matData.num = leftCount
      cell:SetChooseCount(leftCount)
      MsgManager.ShowMsgByID(43299)
    elseif chooseCount == 0 then
      table.remove(self.selectSafeRefineMats, index)
    else
      matData.num = chooseCount
    end
  elseif 0 < chooseCount then
    if leftCount == 0 then
      cell:SetChooseCount(0)
      MsgManager.ShowMsgByID(43299)
      return
    else
      matData = data:Clone()
      if chooseCount > leftCount then
        matData.num = leftCount
        cell:SetChooseCount(leftCount)
        MsgManager.ShowMsgByID(43299)
      else
        matData.num = chooseCount
      end
      table.insert(self.selectSafeRefineMats, matData)
    end
  end
  for i = 1, #self.selectSafeRefineMats do
    self.selectSafeRefineMats[i].showDelete = true
  end
  self.refineChooseBord:SetChooseReference(self.selectSafeRefineMats, true)
  self:UpdateRefineAttr()
  self:UpdateRefineMaterialsCtrl()
end

function EquipRefineBordNew:OnCountChooseChange_Repair(cell)
  local data, chooseCount = cell.data, cell.chooseCount
  if not data or not chooseCount then
    return
  end
  if not self.selectRepairDatas then
    return
  end
  local matData, index
  local leftCount = self.repairMatNeedCount
  for i = 1, #self.selectRepairDatas do
    leftCount = leftCount - GetSafeMaterialVal(self.selectRepairDatas[i], 1)
    if self.selectRepairDatas[i].id == data.id then
      matData = self.selectRepairDatas[i]
      index = i
    end
  end
  leftCount = math.max(leftCount, 0)
  leftCount = math.ceil(leftCount / GetSafeMaterialVal(data, 1))
  leftCount = matData and leftCount + matData.num or leftCount
  if chooseCount > leftCount then
    chooseCount = leftCount
    cell:SetChooseCount(leftCount)
    MsgManager.ShowMsgByID(542)
  end
  if matData then
    if chooseCount == 0 then
      table.remove(self.selectRepairDatas, index)
    else
      matData.num = chooseCount
    end
  elseif 0 < chooseCount then
    matData = data:Clone()
    matData.num = chooseCount
    table.insert(self.selectRepairDatas, matData)
  end
  local leftCount = self.repairMatNeedCount
  for i = 1, #self.selectRepairDatas do
    leftCount = leftCount - self.selectRepairDatas[i].num
    self.selectRepairDatas[i].neednum = math.max(self.selectRepairDatas[i].num, leftCount)
  end
  self.repairChooseBord:SetChooseReference(self.selectRepairDatas, true)
  self:UpdateRefineAttr()
  self:UpdateRefineMaterialsCtrl()
end

function EquipRefineBordNew:ShowSafeRefineMaterialBord(noRetPos)
  self:HideAllChooseBord()
  if self.itemData then
    self.refineChooseBord:Show(nil, nil, nil, EquipRefineBordNew.CheckItemCanRefine)
    self.refineChooseBord:ResetDatas(self.safeRefineMats, not noRetPos)
    self.refineChooseBord:SetUseItemNum(true)
    self.refineChooseBord:SetChooseReference(self.selectSafeRefineMats, true)
  end
end

function EquipRefineBordNew:ShowRepairMaterialBord()
  self:HideAllChooseBord()
  if self.itemData then
    self.repairChooseBord:Show(nil, nil, nil, EquipRefineBordNew.CheckItemCanRefine)
    self.repairChooseBord:ResetDatas(self.repairMatDatas)
    self.repairChooseBord:SetUseItemNum(true)
    self.repairChooseBord:SetChooseReference(self.selectRepairDatas, true)
  end
end

local fmtTicketData = function(item)
  local clone = item:Clone()
  clone.showDelete = true
  local useItem = Table_UseItem[clone.staticData.id]
  if useItem then
    clone:SetSpecialName(string.format(ZhString.EquipRefineBordNew_RefineTicketName, clone.staticData.NameZh, clone.num, tostring(useItem.UseEffect.refine_lv or useItem.UseEffect.refine_level)))
  end
  return clone
end

function EquipRefineBordNew:mSelectTicket(data)
  self.selectTickets = self.selectTickets or {}
  if data then
    self.selectTickets[1] = fmtTicketData(data)
    self.selectTickets[1].num = 1
  else
    self.selectTickets[1] = nil
  end
  self:ResetMaxRefineLevel()
end

function EquipRefineBordNew:ClickChooseRefineTicket(data)
  self:mSelectTicket(data)
  self:Refresh()
  self:HideAllChooseBord()
  self:PassEvent(EquipRefineBordNew.Event.TicketChange, self)
end

function EquipRefineBordNew:ShowRefineTicketsBord()
  self:HideAllChooseBord()
  self.ticketChooseBord:Show(false, self.ClickChooseRefineTicket, self, nil)
  self.ticketChooseBord:ResetDatas(self.refineTickets, true)
end

function EquipRefineBordNew.CheckItemCanRefine(param, item)
  local equipInfo = item.equipInfo
  if item and item.equipInfo then
    if item.equiped == 1 then
      return false, ZhString.EquipRefineBordNew_InValidMatTip2
    end
    if item.equipInfo.refinelv > Mat_MaxRefineLv then
      return false, ZhString.EquipRefineBordNew_InValidMatTip
    end
  end
  return true
end

function EquipRefineBordNew:GetNowItemData()
  return self.itemData
end

local miyin_refine_equiptype = {
  8,
  9,
  10,
  11,
  13
}
local should_miyin_refine = function(itemData)
  local equipInfo = itemData.equipInfo
  if not equipInfo then
    return
  end
  if TableUtility.ArrayFindIndex(miyin_refine_equiptype, equipInfo.equipData.EquipType) > 0 then
    return true
  end
end

function EquipRefineBordNew:SetTargetItem(itemData)
  self.itemChanged = self.itemData ~= itemData
  self.itemData = itemData
  self.isFashion = self.itemData and should_miyin_refine(self.itemData) or false
  xdlog("SetTargetItem  isFashion", self.isFashion)
  self:ResetMaxRefineLevel()
  if itemData then
    if itemData.equipInfo.damage then
      self.refineMode = EquipRefineBordNew.RefineMode.Repair
    elseif self.refineMode == EquipRefineBordNew.RefineMode.Safe then
      if itemData.equipInfo.refinelv >= self.safeClamp_max or self.itemChanged then
        self.refineMode = EquipRefineBordNew.RefineMode.Normal
      end
    else
      self.refineMode = EquipRefineBordNew.RefineMode.Normal
    end
  else
    self.refineMode = EquipRefineBordNew.RefineMode.None
  end
  self.materialPosDirty = true
  self:UpdateRefineParams()
  if self.refineMode == EquipRefineBordNew.RefineMode.Repair then
    self:DoFillRepairSelectDatas()
  end
  self:Refresh()
end

function EquipRefineBordNew:ResetMaxRefineLevel()
  if self.isFashion and self.selectTickets[1] == nil then
    local buildingData = GuildBuildingProxy.Instance:GetBuildingDataByType(GuildBuildingProxy.Type.EGUILDBUILDING_MAGIC_SEWING)
    if buildingData then
      local unlockParam = buildingData.staticData and buildingData.staticData.UnlockParam
      local equipConfig = unlockParam.equip
      if equipConfig and equipConfig.refinemaxlv then
        self:SetMaxRefineLv(equipConfig.refinemaxlv)
      end
    else
      xdlog("公会进度判断")
      local guildTaskData = GuildBuildingProxy.Instance:GetGuildBuildingTaskInfo(GuildBuildingProxy.Type.EGUILDBUILDING_MAGIC_SEWING)
      if guildTaskData then
        local taskID = guildTaskData.id
        local sData = Table_GuildBuilding[taskID]
        if sData then
          local unlockParam = sData.UnlockParam
          local equipConfig = unlockParam and unlockParam.equip
          if equipConfig and equipConfig.refinemaxlv then
            self:SetMaxRefineLv(equipConfig.refinemaxlv)
          end
        end
      else
        redlog("无缝纫机 or 无公会")
        self:SetMaxRefineLv(0)
      end
    end
  else
    self:SetMaxRefineLv(15)
  end
end

local Func_GetLotteryHeadwearRepairMat = function(itemStaticId)
  local sData = Table_HeadwearRepair[itemStaticId]
  if not sData then
    return
  end
  return sData.HeadID, sData.RepairNum
end
local _qualityRepairMatMap = {}
local Func_GetLotteryEquipRepairMatByQuality = function(quality)
  if not next(_qualityRepairMatMap) then
    local repairMat, q
    for id, cfg in pairs(LOTTERY_REPAIR_MATERIAL_CFG) do
      for i = 1, #cfg do
        q = cfg[i].quality
        repairMat = _qualityRepairMatMap[q] or {}
        repairMat[id] = cfg[i].count
        _qualityRepairMatMap[q] = repairMat
      end
    end
  end
  return _qualityRepairMatMap[quality]
end

function EquipRefineBordNew:UpdateRefineParams()
  local nowData = self.itemData
  if nowData then
    self.isBeliever = nowData and LotteryProxy.Instance:IsLotteryEquip(nowData.staticData.id) or false
    local ds = BlackSmithProxy.Instance:GetEquipOptDiscounts(ActivityCmd_pb.GACTIVITY_NORMAL_REFINE)
    if ds and ds[1] and ds[1] < 100 then
      self.discount = ds[1]
    end
    local ds = BlackSmithProxy.Instance:GetEquipOptDiscounts(ActivityCmd_pb.GACTIVITY_SAFE_REFINE)
    if ds and ds[1] and ds[1] < 100 then
      self.safeCostDiscount = ds and ds[1]
    end
    local safeds = BlackSmithProxy.Instance:GetEquipOptDiscounts(ActivityCmd_pb.GACTIVITY_SAFE_REFINE_DISCOUNT)
    if safeds and safeds[1] and safeds and safeds[1] < 100 then
      self.safeDiscount = safeds[1]
    end
    self.homeDisCount = HomeManager.Me():TryGetHomeWorkbenchDiscount("Refine")
    if self.homeDisCount == 100 then
      self.homeDisCount = nil
    end
    self.normalInDiscount = self.discount ~= nil
    self.safeInDiscount = self.safeDiscount ~= nil
    self.maxRefineLv = BlackSmithProxy.Instance:MaxRefineLevelByData(nowData.staticData)
    if self.outset_maxrefine and self.outset_maxrefine < self.maxRefineLv then
      self.maxRefineLv = self.outset_maxrefine
    end
    self.safeClamp_min, self.safeClamp_max = BlackSmithProxy.Instance:GetSafeRefineClampNew(nowData)
    local safeMatEquipId
    self.maxSafeCostNum, self.safeMatItemIds, safeMatEquipId = BlackSmithProxy.Instance:GetSafeRefineCostEquipInfo(nowData, self.safeClamp_max)
    if safeMatEquipId then
      self.safeMatDefaultData = ItemData.new(MaterialItemCell.MaterialType.Material, safeMatEquipId)
    else
      self.safeMatDefaultData = nil
    end
    self.repairItemMatID = nil
    self.repairMatNeedCount = 1
    local HeadRepairItemMatID, HeadRepairMatNeedCount = Func_GetLotteryHeadwearRepairMat(nowData.staticData.id)
    if HeadRepairItemMatID and HeadRepairMatNeedCount then
      self.repairItemMatID = HeadRepairItemMatID
      self.repairMatNeedCount = HeadRepairMatNeedCount
      self.repairDefaultData = ItemData.new(MaterialItemCell.MaterialType.MaterialItem, self.repairItemMatID)
      self.repairDefaultData.num = 0
      self.repairDefaultData.neednum = self.repairMatNeedCount
    else
      if nowData.equipInfo:IsNextGen() then
        local repairCfg = nowData.equipInfo.equipData.NewEquipRepair
        if repairCfg and repairCfg[1] then
          self.repairItemMatID = repairCfg[1][1]
          self.repairMatNeedCount = repairCfg[1][2] or 1
        end
      else
        for itemId, cfg in pairs(EQUIP_REPAIR_MATERIAL_CFG) do
          for k, v in pairs(cfg) do
            if v.type == nowData.staticData.Type then
              self.repairItemMatID = itemId
              self.repairMatNeedCount = v.count
            end
          end
        end
      end
      if self.repairItemMatID and self.itemData.equipInfo:IsNextGen() then
        self.repairDefaultData = ItemData.new(MaterialItemCell.MaterialType.MaterialItem, self.repairItemMatID)
        self.repairDefaultData.num = 0
        self.repairDefaultData.neednum = self.repairMatNeedCount
      elseif safeMatEquipId then
        self.repairDefaultData = ItemData.new(MaterialItemCell.MaterialType.MaterialItem, safeMatEquipId)
        self.repairDefaultData.num = 0
        self.repairDefaultData.neednum = self.repairMatNeedCount
      end
    end
    self:UpdateSafeRefineMats(true)
    self:UpdateRepairMats(true)
    self:UpdateRefineTickets(true)
  else
    self.isBeliever = false
    self.maxRefineLv = 15
    self.refineTolv = nil
    self.safeClamp_min = 4
    self.safeClamp_max = 12
    self.maxSafeCostNum = nil
    self.safeMatItemIds = nil
    self.safeMatDefaultData = nil
    self.repairItemMatID = nil
    self.repairMatNeedCount = 1
    self.discount = nil
    self.homeDisCount = nil
    self.safeDiscount = nil
    self.safeCostDiscount = nil
    self.safeInDiscount = nil
  end
end

local FindRefineMatBagNums = function(sId)
  if sId == 100 then
    return MyselfProxy.Instance:GetROB()
  end
  local items = BagProxy.Instance:GetMaterialItems_ByItemId(sId, REFINE_MATERIAL_SEARCH_BAGTYPES)
  local bagNum = 0
  for j = 1, #items do
    if not items[j]:HasQuench() then
      bagNum = bagNum + items[j].num
    end
  end
  return bagNum
end

function EquipRefineBordNew:UpdateStaticCostMats(isSafe)
  if not self.staticCostMats then
    self.staticCostMats = {}
  else
    TableUtility.TableClear(self.staticCostMats)
  end
  local nowData = self.itemData
  if not nowData or nowData.equipInfo.refinelv >= self.maxRefineLv then
    return
  end
  self.needROB = nil
  if self:GetSelectTicket() and self.refineMode == EquipRefineBordNew.RefineMode.Normal then
    local selectTicket = self.selectTickets and self.selectTickets[1]
    local ticketID = selectTicket and selectTicket.staticData.id
    local useItem = Table_UseItem[ticketID]
    local useEffect = useItem and useItem.UseEffect
    if useEffect.type == "refine_new_ticket" then
      self.needROB = GameConfig.SafeRefineNewConfig.ticket_cost_zeny or 10000
    end
    return
  end
  local nowlv = nowData.equipInfo.refinelv
  local tolv = self.refineTolv
  if not tolv or nowlv >= tolv then
    tolv = nowlv + 1
  end
  local isSafe = self.refineMode == EquipRefineBordNew.RefineMode.Safe
  local tempMap = {}
  for i = nowlv, tolv - 1 do
    local composeData = BlackSmithProxy.Instance:GetRefineComposeData(nowData.staticData.id, i + 1, isSafe)
    self.composeID = composeData.id
    local discount = isSafe and self.safeCostDiscount or self.discount
    if composeData then
      local robNum
      local robDiscount = discount or self.homeDisCount
      if robDiscount then
        robNum = math.floor(composeData.ROB * robDiscount / 100 + 0.01)
      else
        robNum = composeData.ROB
      end
      if not self.needROB then
        self.needROB = robNum
      else
        self.needROB = robNum + self.needROB
      end
      local data, items, bagNum
      for i = 1, #composeData.BeCostItem do
        data = composeData.BeCostItem[i]
        local id = data.id
        if discount then
          neednum = math.floor(data.num * (discount / 100))
          if 1 > neednum then
            neednum = 1
          end
        else
          neednum = data.num
        end
        if not tempMap[id] then
          local itemData = ItemData.new(MaterialItemCell.MaterialType.MaterialItem, id)
          itemData.num = FindRefineMatBagNums(id)
          itemData.isStaticCost = true
          table.insert(self.staticCostMats, itemData)
          itemData.neednum = neednum
          tempMap[id] = itemData
        else
          tempMap[id].neednum = tempMap[id].neednum + neednum
        end
      end
    end
  end
end

function EquipRefineBordNew:SetMaterial(...)
  if not self.outStaticCostMats then
    self.outStaticCostMats = {}
  else
    TableUtility.TableClear(self.outStaticCostMats)
  end
  local findRet = false
  local matIds = {
    ...
  }
  for i = 1, #matIds do
    local itemData = BagProxy.Instance:GetItemByStaticID(matIds[i])
    if itemData then
      findRet = true
      itemData = itemData:Clone()
    else
      itemData = ItemData.new(MaterialItemCell.MaterialType.MaterialItem, matIds[i])
    end
    itemData.neednum = 1
    table.insert(self.outStaticCostMats, itemData)
  end
  return findRet
end

local MatSortRule = function(a, b)
  local alv = a and a:IsEquip() and a.equipInfo.refinelv
  alv = alv or 0
  local blv = b and b:IsEquip() and b.equipInfo.refinelv
  blv = blv or 0
  return alv < blv
end

function EquipRefineBordNew:UpdateSafeRefineMats(clearSelect)
  if not self.safeRefineMats then
    self.safeRefineMats = {}
  else
    TableUtility.TableClear(self.safeRefineMats)
  end
  if not self.selectSafeRefineMats then
    self.selectSafeRefineMats = {}
  elseif clearSelect then
    TableUtility.TableClear(self.selectSafeRefineMats)
  end
  local nowData = self.itemData
  if not nowData then
    return
  end
  if self.safeMatItemIds then
    for i = 1, #self.safeMatItemIds do
      local items = BagProxy.Instance:GetMaterialItems_ByItemId(self.safeMatItemIds[i], REFINE_MATERIAL_SEARCH_BAGTYPES)
      for j = 1, #items do
        if not items[j]:HasQuench() then
          local d = items[j]:Clone()
          d.showRefineval = true
          d.chooseCount = 0
          table.insert(self.safeRefineMats, d)
        end
      end
    end
  end
  if self.safeMatDefaultData then
    local matEquips
    if self.itemData.equipInfo:IsNextGen() then
      matEquips = BlackSmithProxy.Instance:GetMaterialEquips_ByNewEquipRefine(self.safeMatDefaultData, REFINE_MATERIAL_SEARCH_BAGTYPES, nil, nil, nil, true, 15)
    else
      matEquips = BlackSmithProxy.Instance:GetMaterialEquips_ByVID(self.safeMatDefaultData, REFINE_MATERIAL_SEARCH_BAGTYPES, nil, nil, nil, true, 15)
    end
    if matEquips then
      for i = 1, #matEquips do
        local cpyData
        if matEquips[i].id == nowData.id then
          if 1 < matEquips[i].num then
            cpyData = matEquips[i]:Clone()
            cpyData.num = cpyData.num - 1
          end
        elseif not matEquips[i]:HasQuench() then
          cpyData = matEquips[i]:Clone()
        end
        if cpyData then
          cpyData.showRefineval = cpyData.equipInfo.refinelv <= Mat_MaxRefineLv
          cpyData.chooseCount = 0
          table.insert(self.safeRefineMats, cpyData)
        end
      end
    end
  end
  table.sort(self.safeRefineMats, MatSortRule)
end

function EquipRefineBordNew:UpdateRefineTickets()
  if not self.refineTickets then
    self.refineTickets = {}
  else
    TableUtility.TableClear(self.refineTickets)
  end
  if self.forbidTicket then
    return
  end
  local nowData = self.itemData
  local nowTicketType = BlackSmithProxy.GetRefineTicketType(nowData)
  local mTable_UseItem = Table_UseItem
  local tickets = BlackSmithProxy.Instance:GetRefineTickets(function(a, b)
    local aUseEffect = mTable_UseItem[a.staticData.id].UseEffect
    local bUseEffect = mTable_UseItem[b.staticData.id].UseEffect
    local aIsOld = aUseEffect.type == "refine" and 1 or 0
    local bIsOld = bUseEffect.type == "refine" and 1 or 0
    if nowData then
      local a_CanUseFor = EquipRefineBordNew.mIsTicketValid(a, nowData) and 1 or 0
      local b_CanUseFor = EquipRefineBordNew.mIsTicketValid(b, nowData) and 1 or 0
      if a_CanUseFor ~= b_CanUseFor then
        return a_CanUseFor > b_CanUseFor
      end
      if aIsOld ~= bIsOld then
        return aIsOld > bIsOld
      end
      if aIsOld == 1 then
        local aRefinelv = aUseEffect.refine_level or 0
        local bRefinelv = bUseEffect.refine_level or 0
        return aRefinelv > bRefinelv
      end
      local a_IsType = nowTicketType == aUseEffect.ticket_type and 1 or 0
      local b_IsType = nowTicketType == bUseEffect.ticket_type and 1 or 0
      if a_IsType ~= b_IsType then
        return a_IsType > b_IsType
      end
    end
    if aIsOld ~= bIsOld then
      return aIsOld > bIsOld
    end
    if aIsOld == 1 then
      local aRefinelv = aUseEffect.refine_level or 0
      local bRefinelv = bUseEffect.refine_level or 0
      return aRefinelv > bRefinelv
    end
    if aUseEffect.ticket_type ~= bUseEffect.ticket_type then
      return aUseEffect.ticket_type < bUseEffect.ticket_type
    end
    if aUseEffect.refine_lv ~= bUseEffect.refine_lv then
      return aUseEffect.refine_lv > bUseEffect.refine_lv
    end
    return a.staticData.id < b.staticData.id
  end)
  if tickets then
    for i = 1, #tickets do
      table.insert(self.refineTickets, fmtTicketData(tickets[i]))
    end
  end
end

function EquipRefineBordNew:UpdateRepairMats(clearSelect)
  local nowData = self.itemData
  if not nowData or not nowData.equipInfo.damage then
    return nil
  end
  if not self.repairMatDatas then
    self.repairMatDatas = {}
  else
    TableUtility.TableClear(self.repairMatDatas)
  end
  if not self.selectRepairDatas then
    self.selectRepairDatas = {}
  elseif clearSelect then
    TableUtility.TableClear(self.selectRepairDatas)
  end
  if self.repairItemMatID then
    local items = BagProxy.Instance:GetMaterialItems_ByItemId(self.repairItemMatID, REPAIR_MATERIAL_SEARCH_BAGTYPES)
    for i = 1, #items do
      if not items[i]:HasQuench() then
        local cloneItem = items[i]:Clone()
        cloneItem.showRefineval = true
        cloneItem.chooseCount = 0
        table.insert(self.repairMatDatas, cloneItem)
      end
    end
  end
  if self.safeMatDefaultData then
    local repairMats
    if self.safeMatDefaultData.equipInfo and self.safeMatDefaultData.equipInfo:IsNextGen() then
      repairMats = BlackSmithProxy.Instance:GetMaterialEquips_ByNewEquipRefine(self.safeMatDefaultData, REPAIR_MATERIAL_SEARCH_BAGTYPES, nil, nil, nil, true, 15)
    else
      repairMats = BlackSmithProxy.Instance:GetMaterialEquips_ByVID(self.safeMatDefaultData, REPAIR_MATERIAL_SEARCH_BAGTYPES, nil, nil, nil, true, 15)
    end
    local cloneItem
    for i = #repairMats, 1, -1 do
      cloneItem = nil
      if repairMats[i].id == nowData.id then
        if 1 < repairMats[i].num then
          cloneItem = repairMats[i]:Clone()
          cloneItem.num = cloneItem.num - 1
        end
      else
        cloneItem = repairMats[i]:Clone()
      end
      if cloneItem then
        cloneItem.showRefineval = cloneItem.equipInfo.refinelv <= Mat_MaxRefineLv
        cloneItem.chooseCount = 0
        table.insert(self.repairMatDatas, cloneItem)
      end
    end
  end
  table.sort(self.repairMatDatas, MatSortRule)
end

function EquipRefineBordNew:RefreshDatas(dirtyMap)
  return self:mRefreshStaticDatas(dirtyMap), self:mRefreshRefineDatas(dirtyMap), self:mRefreshRepairDatas(dirtyMap)
end

function EquipRefineBordNew:mRefreshStaticDatas(dirtyMap)
  local dirty = false
  if self.staticCostMats then
    for k, data in pairs(self.staticCostMats) do
      if dirtyMap[data.id] then
        local item = BagProxy.Instance:GetItemByGuid(data.id)
        if item then
          data:Copy(item)
        end
        dirty = true
      end
    end
  end
  return dirty
end

function EquipRefineBordNew:mRefreshRefineDatas(dirtyMap)
  self:UpdateSafeRefineMats(false)
  local dirty = false
  if self.selectSafeRefineMats then
    for k, data in pairs(self.selectSafeRefineMats) do
      if dirtyMap[data.id] then
        local item = BagProxy.Instance:GetItemByGuid(data.id)
        if item then
          data:Copy(item)
        end
        dirty = true
      end
    end
  end
  if self.refineChooseBord:ActiveSelf() then
    self.refineChooseBord:ResetDatas(self.safeRefineMats, false)
    self.refineChooseBord:SetChooseReference(self.selectSafeRefineMats, true)
  end
  return dirty
end

function EquipRefineBordNew:mRefreshRepairDatas(dirtyMap)
  local dirty = false
  self:UpdateRepairMats(false)
  if self.selectRepairDatas and #self.selectRepairDatas > 0 then
    for k, data in pairs(self.selectRepairDatas) do
      local item = BagProxy.Instance:GetItemByGuid(data.id)
      if item then
        local num = data.num
        local neednum = data.neednum
        data:Copy(item)
        data.num = num
        data.neednum = neednum
        if dirtyMap[item.id] then
          dirty = true
        end
      end
    end
  else
    self:DoFillRepairSelectDatas()
  end
  if self.repairChooseBord:ActiveSelf() then
    self.repairChooseBord:ResetDatas(self.repairMatDatas, false)
    self.repairChooseBord:SetChooseReference(self.selectRepairDatas, true)
  end
  return dirty
end

function EquipRefineBordNew:DoFillRepairSelectDatas()
  if not self.repairMatDatas then
    return
  end
  local len = #self.repairMatDatas
  local tempArray = {}
  for i = 1, #self.repairMatDatas do
    tempArray[i] = self.repairMatDatas[i]
  end
  table.sort(tempArray, function(a, b)
    local ia = EQUIP_REPAIR_MATERIAL_CFG[a.staticData.id] and 1 or 0
    local ib = EQUIP_REPAIR_MATERIAL_CFG[b.staticData.id] and 1 or 0
    if ia ~= ib then
      return ia < ib
    end
    local ca = EquipRefineBordNew.CheckItemCanRefine(nil, a) and 1 or 0
    local cb = EquipRefineBordNew.CheckItemCanRefine(nil, b) and 1 or 0
    if ca ~= cb then
      return ca > cb
    end
    return MatSortRule(a, b)
  end)
  local lackNum = self.repairMatNeedCount
  for i = 1, len do
    if EquipRefineBordNew.CheckItemCanRefine(nil, tempArray[i]) then
      local d = tempArray[i]:Clone()
      if self.repairItemMatID and self.repairItemMatID == d.staticData.id then
        if lackNum <= d.num then
          d.num = lackNum
          d.neednum = lackNum
          table.insert(self.selectRepairDatas, d)
          break
        end
      else
        d.num = 1
        d.neednum = 1
        table.insert(self.selectRepairDatas, d)
        break
      end
    end
  end
end

function EquipRefineBordNew:SetNpcguid(npcguid)
  self.refine_npcguid = npcguid
end

function EquipRefineBordNew:SetMaxRefineLv(maxRefinelv)
  xdlog("设置最大等级", maxRefinelv)
  self.outset_maxrefine = maxRefinelv
end

function EquipRefineBordNew:SetSelectTicket(item)
  self:mSelectTicket(item)
end

function EquipRefineBordNew:GetSelectTicket()
  return self.selectTickets and self.selectTickets[1]
end

function EquipRefineBordNew:HideAllChooseBord()
  self.chooseBord:Hide()
  self.refineChooseBord:Hide()
  self.repairChooseBord:Hide()
  self.ticketChooseBord:Hide()
end

function EquipRefineBordNew:ShowTempResult(result)
  if result == SceneItem_pb.EREFINERESULT_SUCCESS then
    self:PlaySuccessEffect()
  else
    self:PlayFailEffect()
  end
end

function EquipRefineBordNew:PlaySuccessEffect()
  self:PlayUIEffect(EffectMap.UI.ForgingSuccess, self.effContainerRq.gameObject, true, self.ForgingSuccessEffectHandle, self)
end

function EquipRefineBordNew:PlayFailEffect()
  local effect = self:PlayUIEffect(EffectMap.UI.ForgingFail, self.effContainerRq.gameObject, true, self.ForgingSuccessEffectHandle, self)
  if effect then
    effect:ResetLocalPositionXYZ(0, 16.7, 0)
  end
end

function EquipRefineBordNew.ForgingSuccessEffectHandle(effectHandle, owner)
  if owner then
    owner.effContainerRq:AddChild(effectHandle.gameObject)
  end
end

function EquipRefineBordNew:ActiveFilterPop_ChooseBord(b)
  self.chooseBord:ActiveFilterPop(b)
end

function EquipRefineBordNew:OnExit()
  TimeTickManager.Me():ClearTick(self)
  if self.chooseBord and self.chooseBord.datas then
    for _, data in pairs(self.chooseBord.datas) do
      if data.isShowRedTip then
        data.isShowRedTip = nil
      end
    end
  end
end

function EquipRefineBordNew:__OnViewDestroy()
  if self.__destroyed then
    return
  end
  self.__destroyed = true
  self:OnComponentDestroy()
  TableUtility.TableClear(self)
end

function EquipRefineBordNew:Show()
  self.gameObject:SetActive(true)
end

function EquipRefineBordNew:Hide()
  self.gameObject:SetActive(false)
  self:HideAllChooseBord()
end
