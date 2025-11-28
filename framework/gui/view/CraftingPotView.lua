autoImport("CraftingPotChooseBord")
autoImport("CraftingMaterialCell")
autoImport("EquipChooseBord")
CraftingPotView = class("CraftingPotView", ContainerView)
CraftingPotView.ViewType = UIViewType.NormalLayer
local packageCheck = GameConfig.PackageMaterialCheck and GameConfig.PackageMaterialCheck.purify_products

function CraftingPotView:OnEnter()
  self.PurifyConfig = GameConfig.PurifyProducts
  CraftingPotView.super.OnEnter(self)
  local hasCoupon = false
  local _bagProxy = BagProxy.Instance
  local coupons = self.PurifyConfig and self.PurifyConfig.Coupon
  if coupons then
    for k, v in pairs(coupons) do
      if _bagProxy:GetItemNumByStaticID(k, packageCheck) > 0 then
        hasCoupon = true
        break
      end
    end
  end
  self.couponCheckToggle.gameObject:SetActive(hasCoupon)
  self.checkBtnGrid:Reposition()
end

function CraftingPotView:OnShow()
  Game.Myself:UpdateEpNodeDisplay(true)
end

function CraftingPotView:OnExit()
  CraftingPotView.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
  CraftingPotProxy.Instance:SetChoosePurifyProducts(0)
end

function CraftingPotView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddMapEvts()
  self:InitView()
end

function CraftingPotView:FindObjs()
  self.closeButton = self:FindGO("CloseButton")
  self.closeButton:SetActive(self.isCombine ~= true)
  self.addItemButton = self:FindGO("AddItemButton")
  self.targetBtn = self:FindGO("TargetCell")
  self.helpBtn = self:FindGO("HelpBtn")
  self.targetBtn:SetActive(false)
  local chooseContaienr = self:FindGO("ChooseContainer")
  self.chooseBord = CraftingPotChooseBord.new(chooseContaienr)
  self.chooseBord:AddEventListener(CraftingPotChooseBord.ChooseItem, self.ChooseItem, self)
  self.chooseBord:Hide()
  self.targetMatBord = EquipChooseBord.new(chooseContaienr, function()
    return self:GetTargetMat()
  end)
  self.targetMatBord:AddEventListener(EquipChooseBord.ChooseItem, self.ChooseMaterial, self)
  self.targetMatBord:SetBordTitle(ZhString.RefinePanel_ChooseMat)
  self.targetMatBord:SetTypeLabelTextGetter(function(data)
    local staticID = data.staticData and data.staticData.id
    if staticID then
      local count = CraftingPotProxy.Instance:GetItemNumByStaticID(staticID)
      local coloredCount
      if count == 0 then
        coloredCount = string.format("[c][ED3431]%s[-][/c]", count)
      else
        coloredCount = string.format("[c][4a9f2d]%s[-][/c]", count)
      end
      return string.format(ZhString.FoodScoreTip_CurNumFormat, coloredCount)
    end
  end)
  self.targetMatBord:Hide()
  self.targetCell = BaseItemCell.new(self.targetBtn)
  self.targetCell:AddEventListener(MouseEvent.MouseClick, self.ClickTargetCell, self)
  local longPress = self.targetBtn:AddComponent(UILongPress)
  longPress.pressTime = 0.5
  
  function longPress.pressEvent(obj, isPress)
    if isPress then
      self:handleLongPress()
    end
  end
  
  self.activePart = self:FindGO("ActivePart")
  self.materialPart = self:FindGO("MaterialsPart")
  self.composeTitle = self:FindGO("ComposeTitle", self.materialPart):GetComponent(UILabel)
  self.composeTitle.text = ZhString.CraftingPot_ComposeTitle
  self.addItemTip = self:FindGO("AddItemTip"):GetComponent(UILabel)
  self.addItemTip.text = ZhString.CraftingPot_AddItemTip
  self.materialScrollView = self:FindGO("MaterialScrollView", self.materialPart):GetComponent(UIScrollView)
  self.materialGrid = self:FindGO("MaterialGrid", self.materialPart):GetComponent(UIGrid)
  self.makeMatCtl = UIGridListCtrl.new(self.materialGrid, CraftingMaterialCell, "CraftingMaterialCell")
  self.makeMatCtl:AddEventListener(MouseEvent.MouseClick, self.clickMaterial, self)
  self.makeMatCtl:AddEventListener("ChooseMaterial", self.handleChooseMaterial, self)
  self.makeMatCtl:AddEventListener("RemoveMaterial", self.handleRemoveMaterial, self)
  self.craftingBtn = self:FindGO("CraftingBtn")
  local craftingBtn_Label = self:FindGO("CraftingLabel"):GetComponent(UILabel)
  craftingBtn_Label.text = ZhString.CraftingPot_Make
  self.quickBuyBtn = self:FindGO("QuickBuyBtn")
  local quickBuyBtn_Label = self:FindGO("QuickBuyLabel"):GetComponentInChildren(UILabel)
  quickBuyBtn_Label.text = ZhString.EquipMake_QuickBuy
  self.countPlusBg = self:FindGO("CountPlusBg"):GetComponent(UISprite)
  self.countPlus = self:FindGO("Plus", self.countPlusBg.gameObject):GetComponent(UISprite)
  self.countSubtractBg = self:FindGO("CountSubtractBg"):GetComponent(UISprite)
  self.countSubtract = self:FindGO("Subtract", self.countSubtractBg.gameObject):GetComponent(UISprite)
  self.countInput = self:FindGO("CountBg"):GetComponent(UIInput)
  self.countInput.value = 1
  self.liziParent = self:FindGO("lizi")
  self.lockTipGO = self:FindGO("LockTip")
  self.lockTipLabel = self:FindGO("LockTipLabel"):GetComponent(UILabel)
  self.quickBuyTipGO = self:FindGO("QuickBuyTip")
  local quickBuyTip = self:FindGO("QuickBuyTipLabel", self.quickBuyTipGO):GetComponent(UILabel)
  quickBuyTip.text = ZhString.CraftingPot_QuickBuyTip
  self.successTip = self:FindGO("SuccessTip")
  self.successTip_Label = self.successTip:GetComponent(UILabel)
  self.successSymbol = self:FindGO("SuccessSymbol", self.successTip)
  self.successTip:SetActive(false)
  local anim = self:FindComponent("53EquipStreng_UI_1", Animator)
  anim:Play("state2002")
  self.limitTip = self:FindGO("LimitTip")
  self.limitTipLabel = self:FindGO("LimitTipLabel"):GetComponent(UILabel)
  self.skipBtn = self:FindGO("SkipBtn"):GetComponent(UISprite)
  self.effContainer = self:FindGO("EffectContainer")
  self.effectTexture = self:FindGO("effectTexture"):GetComponent(UITexture)
  PictureManager.Instance:SetUI("ui_CYL_Bg1", self.effectTexture)
  local uiTitle = self:FindGO("Title"):GetComponent(UILabel)
  uiTitle.text = ZhString.DyeComposeView_Title
  self.checkBtn = self:FindGO("CheckBtn"):GetComponent(UIToggle)
  self.checkBg = self:FindGO("CheckBg"):GetComponent(UISprite)
  self.checkLabel = self:FindGO("CheckLabel"):GetComponent(UILabel)
  self:AddClickEvent(self.checkBtn.gameObject, function(go)
    self:OnCheckToggleChange(self.checkBtn)
  end)
  self.couponCheckToggle = self:FindComponent("CouponCheckBtn", UIToggle)
  self:AddClickEvent(self.couponCheckToggle.gameObject, function(go)
    self:OnCheckToggleChange(self.couponCheckToggle)
  end)
  self.checkBtnGrid = self:FindComponent("CheckBtnGrid", UIGrid)
end

function CraftingPotView:OnCheckToggleChange(toggle)
  if toggle.value then
    local makeData = CraftingPotProxy.Instance:GetProduct(self.curProductID)
    if makeData then
      local left, _ = makeData:GetProductLimit()
      if left < 1 then
        MsgManager.ShowMsgByID(28126)
        return
      end
      self:UpdateItem()
    end
  else
    self:UpdateItem()
  end
end

function CraftingPotView:InitView()
  self.combine_lacMats = {}
  self.materialChoiceCache = {}
end

function CraftingPotView:AddEvts()
  self:AddClickEvent(self.addItemButton, function(go)
    self:ClickTargetCell()
  end)
  self:AddClickEvent(self.targetBtn, function(go)
    self:ClickTargetCell()
  end)
  self:TryOpenHelpViewById(32623, nil, self.helpBtn)
  self:AddClickEvent(self.craftingBtn, function()
    self:DoMakeProduct()
  end)
  self:AddPressEvent(self.countPlusBg.gameObject, function(g, b)
    self:PlusPressCount(b)
  end)
  self:AddPressEvent(self.countSubtractBg.gameObject, function(g, b)
    self:SubtractPressCount(b)
  end)
  EventDelegate.Set(self.countInput.onChange, function()
    self:InputOnChange()
  end)
  self:AddClickEvent(self.quickBuyBtn, function()
    self:DoBuyItem()
  end)
  self:AddClickEvent(self.skipBtn.gameObject, function()
    self:Skip()
  end)
end

function CraftingPotView:Skip()
  TipManager.Instance:ShowSkipAnimationTip(SKIPTYPE.Crafting, self.skipBtn, NGUIUtil.AnchorSide.Right, {150, 0})
end

function CraftingPotView:AddMapEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.handleItemUpdate)
  self:AddListenEvt(CraftingPotViewEvent.UpdateProduct, self.HandelMakeProduct)
  self:AddListenEvt(ServiceEvent.MessCCmdPurifyProductsMaterialsMessCCmd, self.HandleUpdateProductList)
end

function CraftingPotView:HandelMakeProduct()
  self:handleItemUpdate()
  self:UpdateTargetCell()
  self:PlayUIEffect(EffectMap.UI.EquipReplaceNew, self.effContainer, true)
end

function CraftingPotView:HandleUpdateProductList()
  if self.curProductID then
    return
  end
  self:ClickTargetCell()
end

function CraftingPotView:PlusPressCount(isPressed)
  if isPressed then
    self.countChangeRate = 1
    TimeTickManager.Me():CreateTick(0, 150, function(owner, deltaTime)
      self:UpdateCount(1)
    end, self, 1001)
  else
    TimeTickManager.Me():ClearTick(self, 1001)
  end
end

function CraftingPotView:SubtractPressCount(isPressed)
  if isPressed then
    self.countChangeRate = 1
    TimeTickManager.Me():CreateTick(0, 150, function(owner, deltaTime)
      self:UpdateCount(-1)
    end, self, 1002)
  else
    TimeTickManager.Me():ClearTick(self, 1002)
  end
end

function CraftingPotView:UpdateCount(change)
  if nil == tonumber(self.countInput.value) then
    self.countInput.value = 1
  end
  local count = tonumber(self.countInput.value) + self.countChangeRate * change
  if count < 1 then
    self.countChangeRate = 1
    return
  elseif count > self.maxcount then
    self.countChangeRate = 1
    return
  end
  if tonumber(self.countInput.value) ~= count then
    self.countInput.value = count
  end
  if self.countChangeRate <= 3 then
    self.countChangeRate = self.countChangeRate + 1
  end
  self:UpdateItem()
  self:UpdateCost()
end

function CraftingPotView:InputOnChange()
  local count = tonumber(self.countInput.value)
  if not count then
    self.countInput.value = 1
    return
  end
  if count <= 1 then
    count = 1
    self:SetCountPlus(1)
    self:SetCountSubtract(0.5)
  elseif count >= self.maxcount then
    count = self.maxcount
    self:SetCountPlus(0.5)
    self:SetCountSubtract(1)
  else
    self:SetCountPlus(1)
    self:SetCountSubtract(1)
  end
  if self.countInput.value ~= tostring(count) then
    self.countInput.value = count
  end
  self:UpdateItem()
  self:UpdateCost()
end

function CraftingPotView:SetCountPlus(alpha)
  if self.countPlusBg.color.a ~= alpha then
    self:SetSpritAlpha(self.countPlusBg, alpha)
    self:SetSpritAlpha(self.countPlus, alpha)
  end
end

function CraftingPotView:SetCountSubtract(alpha)
  if self.countSubtractBg.color.a ~= alpha then
    self:SetSpritAlpha(self.countSubtractBg, alpha)
    self:SetSpritAlpha(self.countSubtract, alpha)
  end
end

function CraftingPotView:SetSpritAlpha(sprit, alpha)
  sprit.color = Color(sprit.color.r, sprit.color.g, sprit.color.b, alpha)
end

function CraftingPotView:ChooseItem(data)
  if data then
    local previousProductID = self.curProductID
    if self.curProductID and self.curProductID ~= data.productItemID then
      CraftingPotProxy.Instance:SetChoosePurifyProducts(data.productItemID)
    end
    self.curProductID = data.productItemID
    if previousProductID ~= self.curProductID then
      self.materialChoiceCache = {}
    end
    local makeData = CraftingPotProxy.Instance:GetProduct(self.curProductID)
    local left, max = makeData:GetProductLimit()
    self.countInput.value = 0 < left and 1 or 0
    self.checkBtn.value = false
    self:SetCountSubtract(0.5)
    self:SetCountPlus(1)
    self:SetChooseMakeData(true)
  else
    CraftingPotProxy.Instance:SetChoosePurifyProducts(0)
    self.curProductID = nil
    self.countInput.value = 0
    self.materialChoiceCache = {}
  end
  self:SetChooseCell()
  self:UpdateTargetCell()
  if self.curProductID then
    self.chooseBord:Hide()
    self.targetMatBord:Hide()
  else
    self.chooseBord:Show(true)
    self.targetMatBord:Hide()
  end
  self.selectedSlotIndex = nil
  self:UpdateChooseSymbolDisplay()
  self.targetBtn:SetActive(self.curProductID ~= nil)
  self.addItemButton:SetActive(self.curProductID == nil)
  self:UpdateItem()
end

function CraftingPotView:ChooseMaterial(data)
  if data and self.selectedSlotIndex then
    self.materialChoiceCache[self.selectedSlotIndex] = {
      itemid = data.staticData.id
    }
    self.selectedSlotIndex = nil
    self:UpdateMakeMaterial()
    local nextEmptySlot
    local cells = self.makeMatCtl:GetCells()
    for i = 1, #cells do
      local cellData = cells[i].data
      if cellData and cellData.isEmpty then
        nextEmptySlot = cellData
        break
      end
    end
    if nextEmptySlot then
      self.selectedSlotIndex = nextEmptySlot.slotIndex
      self:UpdateChooseSymbolDisplay()
      self.targetMatBord:Show(true)
    else
      self:UpdateChooseSymbolDisplay()
      self.targetMatBord:Hide()
      self.chooseBord:Show()
    end
    self:UpdateButton()
  end
end

function CraftingPotView:GetTargetMat()
  if self.selectedSlotIndex and self.slotMaterials[self.selectedSlotIndex] then
    local result = {}
    local materials = self.slotMaterials[self.selectedSlotIndex]
    for i = 1, #materials do
      local material = materials[i]
      local itemData = ItemData.new(nil, material.itemid)
      result[#result + 1] = itemData
    end
    return result
  end
  return {}
end

function CraftingPotView:UpdateChooseSymbolDisplay()
  local cells = self.makeMatCtl:GetCells()
  for i = 1, #cells do
    local cell = cells[i]
    local cellData = cell.data
    if cellData and cellData.slotIndex then
      local isSelected = self.selectedSlotIndex == cellData.slotIndex
      cell:SetChooseSymbol(isSelected)
    end
  end
end

function CraftingPotView:UpdateLimit()
  self.limitTip:SetActive(self.curProductID ~= nil)
  local makeData = CraftingPotProxy.Instance:GetProduct(self.curProductID)
  if makeData then
    local left, max = makeData:GetProductLimit()
    if left < tonumber(self.countInput.value) then
      self.countInput.value = left
    end
    if max then
      self.limitTipLabel.text = string.format(ZhString.CraftingPot_ItemLimitWithMax, left, max)
    else
      self.limitTipLabel.text = string.format(ZhString.CraftingPot_ItemLimit, max)
    end
  end
end

function CraftingPotView:ClickTargetCell()
  self:ChooseItem()
end

function CraftingPotView:InsertOrAddNum(array, item, idKey, numKey)
  if type(array) ~= "table" or type(item) ~= "table" then
    return
  end
  idKey = idKey or "id"
  numKey = numKey or "num"
  local element
  for i = 1, #array do
    element = array[i]
    if element[idKey] == item[idKey] then
      element[numKey] = element[numKey] + item[numKey]
      return
    end
  end
  local copy = {}
  copy.GetName = item.GetName
  TableUtility.TableShallowCopy(copy, item)
  TableUtility.ArrayPushBack(array, copy)
end

function CraftingPotView:handleItemUpdate()
  self:UpdateItem()
end

function CraftingPotView:clickMaterial(cell)
  local data = cell.itemData
  if data == nil then
    return
  end
  local sdata = {
    itemdata = data,
    funcConfig = {}
  }
  self:ShowItemTip(sdata, cell.icon, NGUIUtil.AnchorSide.Left, {-220, 0})
end

function CraftingPotView:handleChooseMaterial(cellData)
  if not self.curProductID then
    return
  end
  if cellData and cellData.slotIndex then
    self.selectedSlotIndex = cellData.slotIndex
    self:UpdateChooseSymbolDisplay()
    self.chooseBord:Hide()
    self.targetMatBord:Show(true)
  end
end

function CraftingPotView:handleRemoveMaterial(cellData)
  if not self.curProductID then
    return
  end
  if cellData and cellData.slotIndex then
    self.materialChoiceCache[cellData.slotIndex] = nil
    self.selectedSlotIndex = cellData.slotIndex
    self:UpdateItem()
    self:UpdateChooseSymbolDisplay()
    self.chooseBord:Hide()
    self.targetMatBord:Show(true)
  end
end

function CraftingPotView:handleLongPress()
  local data = self.nowdata
  if data == nil then
    return
  end
  local sdata = {
    itemdata = data,
    funcConfig = {}
  }
  self:ShowItemTip(sdata, self.targetCell.icon, NGUIUtil.AnchorSide.Left, {-200, 0})
end

function CraftingPotView:DoMakeProduct()
  if not self.curProductID then
    return
  end
  local makeData = CraftingPotProxy.Instance:GetProduct(self.curProductID)
  if makeData then
    local left, max = makeData:GetProductLimit()
    if left < 1 then
      MsgManager.ShowMsgByID(43569)
      return
    end
  end
  if self.validStamp and ServerTime.CurServerTime() / 1000 < self.validStamp then
    return
  end
  self.validStamp = ServerTime.CurServerTime() / 1000 + 0.2
  local enoughMaterial = self.total - self.need
  redlog("CraftingPotView:DoMakeProduct", self.total, self.need)
  if 0 <= enoughMaterial then
    local choosematerial = {}
    for slotIndex, choice in pairs(self.materialChoiceCache or {}) do
      if choice and choice.itemid then
        table.insert(choosematerial, choice.itemid)
        xdlog("选择的材料", choice.itemid)
      end
    end
    redlog("CallPurifyProductsRefineMessCCmd", self.curProductID, tonumber(self.countInput.value), tostring(self.checkBtn.value), tostring(self.couponCheckToggle.value), choosematerial)
    ServiceMessCCmdProxy.Instance:CallPurifyProductsRefineMessCCmd(self.curProductID, tonumber(self.countInput.value), self.checkBtn.value == true, self.couponCheckToggle.value, choosematerial)
  end
end

function CraftingPotView:UpdateLackMaterials(srcDatas)
  srcDatas = srcDatas or self.materialsData
  self.canCompose = true
  local cdata = Table_Compose[self.data.staticData.ComposeID]
  TableUtility.ArrayClear(self.combine_lacMats)
  for i = 1, #srcDatas do
    local data = srcDatas[i]
    if data.num < data.neednum then
      local lackItem = {
        id = data.staticData.id,
        count = data.neednum - data.num
      }
      table.insert(self.combine_lacMats, lackItem)
      self.canCompose = false
    end
  end
  for i = 1, #cdata.BeCostItem do
    local v = cdata.BeCostItem[i]
    local config = Table_Item[v.id]
    if config.Type == 50 then
      local num = self:GetItemNum(v.id)
      if num < v.num then
        local lackItem = {
          id = v.id,
          count = v.num - num
        }
        table.insert(self.combine_lacMats, lackItem)
        self.canCompose = false
      end
    end
  end
end

function CraftingPotView:DoBuyItem()
  if self.curProductID == nil then
    return
  end
  if self.validStamp and ServerTime.CurServerTime() / 1000 < self.validStamp then
    return
  end
  self.validStamp = ServerTime.CurServerTime() / 1000 + 0.2
  local enoughMaterial = self.total - self.need
  if enoughMaterial < 0 then
    local needList = ReusableTable.CreateArray()
    local cells = self.makeMatCtl:GetCells()
    for i = 1, #cells do
      local needCount = cells[i]:NeedCount()
      if 0 < needCount then
        local needData = ReusableTable.CreateTable()
        needData.id = cells[i].data.id
        needData.count = needCount
        TableUtility.ArrayPushBack(needList, needData)
      end
    end
    if not QuickBuyProxy.Instance:TryOpenView(needList) then
      MsgManager.ShowMsgByID(8)
    end
    for i = 1, #needList do
      ReusableTable.DestroyAndClearTable(needList[i])
    end
    ReusableTable.DestroyArray(needList)
    return
  else
    MsgManager.ShowMsgByID(542)
  end
end

function CraftingPotView:UpdateItem()
  self:UpdateMakeMaterial()
  self:UpdateButton()
  self:UpdateLimit()
end

function CraftingPotView:UpdateButton()
  local makeData = CraftingPotProxy.Instance:GetProduct(self.curProductID)
  if not makeData then
    return
  end
  local IsSeasonItem, tip = makeData:IsSeasonItem()
  if IsSeasonItem then
    self.craftingBtn:SetActive(false)
    self.quickBuyBtn:SetActive(false)
    self.lockTipGO:SetActive(true)
    self.quickBuyTipGO:SetActive(false)
    self.lockTipLabel.text = tip or ""
    return
  end
  local cells = self.makeMatCtl:GetCells()
  local hasEmptySlot = false
  local materialsSufficient = true
  self.need = #cells
  self.total = 0
  for i = 1, #cells do
    local cell = cells[i]
    local cellData = cell.data
    if cellData and cellData.isEmpty then
      hasEmptySlot = true
      materialsSufficient = false
    elseif cell:IsEnough() then
      self.total = self.total + 1
    else
      materialsSufficient = false
    end
  end
  if hasEmptySlot then
    self.craftingBtn:SetActive(false)
    self.quickBuyBtn:SetActive(false)
    self.lockTipGO:SetActive(false)
    self.quickBuyTipGO:SetActive(true)
    local quickBuyTip = self:FindGO("QuickBuyTipLabel", self.quickBuyTipGO):GetComponent(UILabel)
    quickBuyTip.text = ZhString.CraftingPot_IncompleteMaterialTip
  elseif not materialsSufficient then
    self.craftingBtn:SetActive(false)
    self.quickBuyBtn:SetActive(true)
    self.lockTipGO:SetActive(false)
    self.quickBuyTipGO:SetActive(true)
    local quickBuyTip = self:FindGO("QuickBuyTipLabel", self.quickBuyTipGO):GetComponent(UILabel)
    quickBuyTip.text = ZhString.CraftingPot_QuickBuyTip
  else
    self.craftingBtn:SetActive(true)
    self.quickBuyBtn:SetActive(false)
    self.lockTipGO:SetActive(false)
    self.quickBuyTipGO:SetActive(false)
  end
end

function CraftingPotView:UpdateMakeMaterial()
  local result = {}
  local data = CraftingPotProxy.Instance:GetComposingItems(self.curProductID)
  self.slotMaterials = {}
  if data then
    for slotIndex, slotData in pairs(data) do
      local adjustedRequiredNum = slotData.requiredNum * tonumber(self.countInput.value)
      local slotItem = {
        id = 0,
        num = 0,
        quality = slotData.quality,
        requiredNum = adjustedRequiredNum,
        slotIndex = slotIndex,
        isEmpty = true,
        selectedMaterial = nil
      }
      result[#result + 1] = slotItem
      self.slotMaterials[slotIndex] = {}
      for i = 1, #slotData.materials do
        local material = slotData.materials[i]
        self.slotMaterials[slotIndex][#self.slotMaterials[slotIndex] + 1] = {
          itemid = material.itemid,
          itemNum = adjustedRequiredNum
        }
      end
    end
  end
  local finalResult = {}
  for i = 1, #result do
    local slotItem = result[i]
    local cachedChoice = self.materialChoiceCache[slotItem.slotIndex]
    if cachedChoice then
      local adjustedCachedChoice = {
        itemid = cachedChoice.itemid,
        itemNum = slotItem.requiredNum
      }
      finalResult[#finalResult + 1] = {
        id = cachedChoice.itemid,
        num = slotItem.requiredNum,
        quality = slotItem.quality,
        slotIndex = slotItem.slotIndex,
        selectedMaterial = adjustedCachedChoice
      }
    elseif slotItem.selectedMaterial then
      finalResult[#finalResult + 1] = {
        id = slotItem.selectedMaterial.itemid,
        num = slotItem.selectedMaterial.itemNum,
        quality = slotItem.quality,
        slotIndex = slotItem.slotIndex
      }
    else
      finalResult[#finalResult + 1] = slotItem
    end
  end
  if self.couponCheckToggle.value then
    local use, has = false, false
    finalResult, use, has = CraftingPotProxy.Instance:UpdateMaterialListUsingCoupon(finalResult, packageCheck)
    if not use then
      if not has then
        MsgManager.ShowMsgByID(28127)
      else
        MsgManager.ShowMsgByID(28128)
      end
      self.couponCheckToggle.value = false
    end
  end
  if self.checkBtn.value and self.curProductID ~= nil then
    local use, has = false, false
    finalResult, use, has = CraftingPotProxy.Instance:UpdateMaterialListUsingDeduction(finalResult, packageCheck)
    if not self.couponCheckToggle.value then
      local allSlotsFilled = true
      for i = 1, #finalResult do
        if finalResult[i].isEmpty then
          allSlotsFilled = false
          break
        end
      end
      if not use and allSlotsFilled then
        if not has then
          MsgManager.ShowMsgByID(28117)
        else
          MsgManager.ShowMsgByID(28118)
        end
        self.checkBtn.value = false
      end
    end
  end
  self.makeMatCtl:ResetDatas(finalResult)
  self.materialGrid.repositionNow = true
  self.materialScrollView:ResetPosition()
end

function CraftingPotView:InsertOrAddNum(array, item, idKey, numKey)
  if type(array) ~= "table" or type(item) ~= "table" then
    return
  end
  idKey = idKey or "id"
  numKey = numKey or "num"
  local element
  for i = 1, #array do
    element = array[i]
    if element[idKey] == item[idKey] then
      element[numKey] = element[numKey] + item[numKey]
      return
    end
  end
  local copy = {}
  copy.GetName = item.GetName
  TableUtility.TableShallowCopy(copy, item)
  TableUtility.ArrayPushBack(array, copy)
end

function CraftingPotView:UpdateTargetCell()
  local makeData = CraftingPotProxy.Instance:GetProduct(self.curProductID)
  if makeData then
    local itemdata = ItemData.new("product", makeData.productItemID)
    self.targetCell:SetData(itemdata)
    self.nowdata = itemdata
    if makeData.totalTimes then
      self.maxcount = makeData.leftTimes
    else
      self.maxcount = 99
    end
  else
    self.nowdata = nil
    self.targetCell.nameLab.text = ""
    self.targetCell.normalItem:SetActive(false)
  end
end

function CraftingPotView:UpdateCost()
end

function CraftingPotView:UpdateTip()
  local table_compose = EquipMakeProxy.Instance:GetComposeTable()
  local data = table_compose[self.curProductID]
  self.tip.text = data and data.MenuDes or ""
end

function CraftingPotView:SetChooseMakeData(isChoose)
  local makeData = EquipMakeProxy.Instance:GetMakeData(self.curProductID)
  if makeData then
    makeData:SetChoose(isChoose)
  end
end

function CraftingPotView:SetChooseCell()
  self.chooseBord:SetChoose(self.curProductID)
end

function CraftingPotView:OnExit()
  PictureManager.Instance:UnLoadUI("ui_CYL_Bg1", self.effectTexture)
  CraftingPotView.super.OnExit(self)
end
