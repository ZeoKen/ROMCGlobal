autoImport("EquipNewChooseBord")
autoImport("MaterialItemNewCell")
autoImport("MaterialSelectItemNewCell")
EquipReplaceNewView = class("EquipReplaceNewView", BaseView)
EquipReplaceNewView.ViewType = UIViewType.NormalLayer
EquipReplaceNewView.ViewMaskAdaption = {all = 1}
local bg3TexName, targetCellClickTickId = "Equipmentopen_bg_bottom_02", 2380
local shopIns, bagIns, tickManager, replaceMatPackageCheck, replaceTargetPackageCheck, equipTable, composeTable, zenyId, arrayPushBack, tableClear

function EquipReplaceNewView:Init()
  if not shopIns then
    shopIns = HappyShopProxy.Instance
    bagIns = BagProxy.Instance
    tickManager = TimeTickManager.Me()
    replaceMatPackageCheck = GameConfig.PackageMaterialCheck.equipexchange
    replaceTargetPackageCheck = GameConfig.PackageMaterialCheck.equipexmainchange or replaceMatPackageCheck
    equipTable = Table_Equip
    composeTable = Table_Compose
    zenyId = GameConfig.MoneyId.Zeny
    arrayPushBack = TableUtility.ArrayPushBack
    tableClear = TableUtility.TableClear
  end
  self:FindObjs()
  self:InitView()
  self:AddListenEvts()
  self.tipData = {
    funcConfig = _EmptyTable,
    callback = function()
      if not Slua.IsNull(self.matChooseSymbol) then
        self.matChooseSymbol:SetActive(false)
      end
    end,
    ignoreBounds = {
      self.lastGenMatGrid.gameObject
    }
  }
  self.matDatas = {}
end

function EquipReplaceNewView:FindObjs()
  self.mainBoardTrans = self:FindGO("MainBoard").transform
  self.costSp = self:FindComponent("CostCtrl", UISprite)
  self.costLabel = self:FindComponent("CostLabel", UILabel)
  self.costAddBtn = self:FindGO("AddBtn", self.costSp.gameObject)
  self.title = self:FindComponent("Title", UILabel)
  self.bg3Tex = self:FindComponent("Bg3", UITexture)
  self.addIcon = self:FindGO("AddIcon")
  self.targetCellContent = self:FindGO("TargetCellContent")
  self.targetIcon = self:FindComponent("Icon", UISprite, self.targetCellContent)
  self.targetNameLabel = self:FindComponent("TargetName", UILabel, self.targetCellContent)
  self.effectContainer = self:FindGO("EffectContainer")
  self.nextGenMatGrid = self:FindComponent("NextGenMatGrid", UIGrid)
  self.lastGenMatGrid = self:FindComponent("LastGenMatGrid", UIGrid)
  self.scrollView = self:FindComponent("ScrollView", UIScrollView)
  self.matChooseSymbol = self:FindGO("MatChooseSymbol")
  self.matChooseSymbolTrans = self.matChooseSymbol.transform
  local actionBtn = self:FindGO("ActionBtn")
  self.actionBgSp = actionBtn:GetComponent(UIMultiSprite)
  self.actionLabel = self:FindComponent("ActionLabel", UILabel, actionBtn)
  self.tip = self:FindGO("Tip")
  self.tip_label = self.tip:GetComponent(UILabel)
  self.emptyTip = self:FindGO("EmptyTip")
  self.priceIndicator = self:FindGO("PriceIndicator")
  self.priceTable = self.priceIndicator:GetComponent(UITable)
  self.coinNumLabel = self:FindComponent("CoinNum", UILabel)
  self.coinIcon = self:FindComponent("CoinIcon", UISprite)
  self.chooseContainer = self:FindGO("ChooseContainer")
  self.askBuyBoard = self:FindGO("AskBuyBoard")
  self.askBuyGrid = self:FindComponent("Grid", UIGrid, self.askBuyBoard)
  self.collider = self:FindGO("Collider")
end

function EquipReplaceNewView:InitView()
  local npcFunctionData = self.viewdata.viewdata and self.viewdata.viewdata.npcfunctiondata
  local titleName = npcFunctionData and npcFunctionData.NameZh
  if titleName then
    self.title.text = titleName
  end
  self:InitCostCtrl()
  self.nextGenMatCtrl = ListCtrl.new(self.nextGenMatGrid, MaterialItemNewCell, "MaterialItemNewCell")
  self.nextGenMatCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickNextGenMatCell, self)
  self.lastGenMatCtrl = ListCtrl.new(self.lastGenMatGrid, MaterialSelectItemNewCell, "MaterialSelectItemNewCell")
  self.lastGenMatCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickLastGenMatCell, self)
  self.lastGenMatCtrl:AddEventListener(ItemEvent.ItemDeselect, self.OnClickLastGenMatCell, self)
  self.lastGenMatCtrl:AddEventListener(MouseEvent.LongPress, self.OnLongPressLastGenMatCell, self)
  self.lastGenMatCtrl:AddEventListener(ItemEvent.ItemDeselectLongPress, self.OnLongPressLastGenMatCell, self)
  self.chooseBord = EquipNewChooseBord.new(self.chooseContainer)
  self.chooseBord:AddEventListener(EquipChooseBord.ChooseItem, self.OnClickChooseBordCell, self)
  self.multiChooseBord = EquipNewCountChooseBord.new(self.chooseContainer)
  self.multiChooseBord:Hide()
  self.multiChooseBord:AddEventListener(EquipChooseCellEvent.CountChooseChange, self.OnCountChooseChange, self)
  self.askBuyCtrl = ListCtrl.new(self.askBuyGrid, MaterialItemNewCell, "MaterialItemNewCell")
  self.askBuyCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickAskBuyItemCell, self)
  IconManager:SetItemIcon(Table_Item[100].Icon, self.coinIcon)
  self:AddButtonEvent("TargetCell", function()
    self:OnClickTargetCell()
  end)
  self:AddButtonEvent("ActionBtn", function()
    if not self.targetData then
      return
    end
    if not self:CheckZeny() then
      MsgManager.ShowMsgByID(1)
      return
    end
    if not self:CheckMat() then
      self:UpdateLackItems()
      if #self.lackItems > 0 then
        self:UpdateAskBuyGrid()
        self.askBuyBoard:SetActive(true)
      end
      return
    end
    if not self.actionBtnActive then
      return
    end
    local action = function()
      self:TryPlayEffectThenCall(self._Replace)
    end
    if self:IsTargetNextGen() then
      action()
    else
      local hasEnchant, data = false
      for i = 1, #self.matDatas do
        data = self.matDatas[i]
        hasEnchant = hasEnchant or BagItemCell.CheckData(data) and data:HasEnchant()
      end
      if hasEnchant then
        MsgManager.ConfirmMsgByID(234, action)
      else
        action()
      end
    end
  end)
  self:AddButtonEvent("AskBuyBtn", function()
    if self.lackItems then
      QuickBuyProxy.Instance:TryOpenView(self.lackItems, QuickBuyProxy.QueryType.NoDamage)
    else
      LogUtility.Warning("Cannot find lackItems. There must be sth wrong")
    end
    self.askBuyBoard:SetActive(false)
  end)
  self:AddButtonEvent("AskBuyCloseBtn", function()
    self.askBuyBoard:SetActive(false)
  end)
  self:AddButtonEvent("BgCollider", function()
    self.askBuyBoard:SetActive(false)
  end)
end

function EquipReplaceNewView:InitCostCtrl()
  IconManager:SetItemIcon(Table_Item[zenyId].Icon, self.costSp)
  self:UpdateCostCtrl()
  self:AddClickEvent(self.costAddBtn, function()
    FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit, FunctionNewRecharge.InnerTab.Deposit_Zeny)
  end)
end

function EquipReplaceNewView:AddListenEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.OnItemUpdate)
  self:AddListenEvt(MyselfEvent.ZenyChange, self.OnZenyChange)
  self:AddListenEvt(ServiceEvent.ItemEquipExchangeItemCmd, self.OnReplaceComplete)
end

function EquipReplaceNewView:OnEnter()
  EquipReplaceNewView.super.OnEnter(self)
  PictureManager.Instance:SetUI(bg3TexName, self.bg3Tex)
  local npcData = self.viewdata.viewdata and self.viewdata.viewdata.npcdata
  if npcData then
    self:CameraFocusOnNpc(npcData.assetRole.completeTransform)
  else
    self:CameraRotateToMe()
  end
  self:OnClickTargetCell()
  self.askBuyBoard:SetActive(false)
  if self.viewdata.viewdata.OnClickChooseBordCell_data then
    self:OnClickChooseBordCell(self.viewdata.viewdata.OnClickChooseBordCell_data)
  else
    local lastOperGuid = BagProxy.Instance:GetLastOperEquip()
    if lastOperGuid then
      local item = BagProxy.Instance:GetItemByGuid(lastOperGuid)
      if item then
        self:OnClickChooseBordCell(item)
      end
    end
  end
end

function EquipReplaceNewView:OnExit()
  PictureManager.Instance:UnLoadUI(bg3TexName, self.bg3Tex)
  self:CameraReset()
  tickManager:ClearTick(self)
  EquipReplaceNewView.super.OnExit(self)
end

function EquipReplaceNewView:OnItemUpdate()
  if self.replaceComplete then
    self.replaceComplete = nil
    tickManager:CreateOnceDelayTick(50, function(self)
      self:OnClickTargetCell()
    end, self)
  else
    self:UpdateTargetCell()
  end
end

function EquipReplaceNewView:OnZenyChange()
  self:UpdateCostCtrl()
end

function EquipReplaceNewView:OnReplaceComplete()
  self.replaceComplete = true
end

function EquipReplaceNewView:OnClickTargetCell()
  self.multiChooseBord:SetTweenActive(false)
  self.multiChooseBord:Hide()
  self.chooseBord:SetTweenActive(true)
  self.chooseBord:ResetDatas(self:GetChooseBordDatas(), true)
  self.chooseBord:Show()
  self.chooseBord:SetChoose()
  tickManager:ClearTick(self, targetCellClickTickId)
  tickManager:CreateOnceDelayTick(330, function(self)
    self.chooseBord:SetTweenActive(false)
  end, self, targetCellClickTickId)
  self:SetTargetCell()
end

function EquipReplaceNewView:OnClickChooseBordCell(data)
  self:SetTargetCell(data)
end

function EquipReplaceNewView:OnCountChooseChange(cell)
  if not cell then
    return
  end
  local data, chooseCount = cell.data, cell.chooseCount
  if data and chooseCount then
    local leftMatCount = self.totalMatCount
    local matData, index
    for i = 1, #self.matDatas do
      local d = self.matDatas[i]
      if type(d) == "table" then
        if d.id == data.id then
          matData = d
          index = i
        else
          leftMatCount = leftMatCount - d.num
        end
      end
    end
    if chooseCount > leftMatCount then
      chooseCount = leftMatCount
      cell:SetChooseCount(leftMatCount)
      MsgManager.ShowMsgByID(542)
    end
    if matData then
      if chooseCount == 0 then
        table.remove(self.matDatas, index)
      else
        matData.num = chooseCount
      end
    elseif 0 < chooseCount then
      matData = data:Clone()
      matData.num = chooseCount
      table.insert(self.matDatas, matData)
    end
    self:UpdateMultiChoose(true)
  end
end

function EquipReplaceNewView:OnClickNextGenMatCell(cell)
  self:ShowItemTip(cell, true)
end

function EquipReplaceNewView:OnClickLastGenMatCell(cell)
  if self:IsTargetNextGen() then
    return
  end
  if self.isClickOnLastGenMatCtrlDisabled then
    self.isClickOnLastGenMatCtrlDisabled = nil
    return
  end
  local d = cell.data
  if type(d) == "table" and d.num == 1 then
    for i = #self.matDatas, 1, -1 do
      if self.matDatas[i].id == d.id then
        table.remove(self.matDatas, i)
        break
      end
    end
  end
  self:TryShowMultiChooseBord()
  self:UpdateMultiChoose(true)
end

function EquipReplaceNewView:OnClickAskBuyItemCell(cell)
  self:ShowItemTip(cell)
end

function EquipReplaceNewView:OnLongPressLastGenMatCell(param)
  local isPressing, cell = param[1], param[2]
  if isPressing then
    self:ShowItemTip(cell, true)
    self.isClickOnLastGenMatCtrlDisabled = true
  end
end

function EquipReplaceNewView:SetTargetCell(data)
  if not BagItemCell.CheckData(data) or data.staticData == nil then
    data = nil
  end
  self.targetData = data
  self:UpdateTargetCell()
end

function EquipReplaceNewView:UpdateTargetCell()
  local hasData = self.targetData ~= nil and self.targetData.staticData ~= nil
  self.targetCellContent:SetActive(hasData)
  self.addIcon:SetActive(not hasData)
  self.tip:SetActive(hasData)
  self.emptyTip:SetActive(not hasData)
  self.priceIndicator:SetActive(hasData)
  self:UpdateMat()
  self:UpdateZeny()
  self:SetActionBtnActive(hasData and self:CheckMat() and self:CheckZeny())
  if hasData then
    IconManager:SetItemIcon(self.targetData.staticData.Icon, self.targetIcon)
    self.targetIcon:MakePixelPerfect()
    local scale = 0.8
    self.targetIcon.transform.localScale = LuaGeometry.GetTempVector3(scale, scale, scale)
    self.targetNameLabel.text = self.targetData.staticData.NameZh
    self.chooseBord:SetTweenActive(self:IsTargetNextGen() or self:CheckMat())
    self.chooseBord:Hide()
  end
end

local tempMatDatas = {}

function EquipReplaceNewView:UpdateMultiChoose(ignoreBordShow)
  local matEnough = self:CheckMat()
  local matDatas
  if not matEnough and self.targetData then
    tableClear(tempMatDatas)
    for i = 1, #self.matDatas do
      tempMatDatas[i] = self.matDatas[i]
    end
    tempMatDatas[#tempMatDatas + 1] = BagItemEmptyType.Empty
    matDatas = tempMatDatas
  else
    matDatas = self.matDatas
  end
  if 5 < #matDatas then
    self.lastGenMatGrid.pivot = 3
    LuaGameObject.SetLocalPositionGO(self.lastGenMatGrid.gameObject, -200, 0, 0)
  else
    self.lastGenMatGrid.pivot = 4
    LuaGameObject.SetLocalPositionGO(self.lastGenMatGrid.gameObject, 0, 0, 0)
  end
  self.lastGenMatCtrl:ResetDatas(matDatas)
  for _, cell in pairs(self.lastGenMatCtrl:GetCells()) do
    if cell.data ~= BagItemEmptyType.Empty then
      cell:TrySetShowDeselect(true)
      cell:UnShowInvalid()
    end
  end
  self:SetActionBtnActive(matEnough and self:CheckZeny())
  local matCount, totalMatCount = self:GetMaterialDataCount(), self.totalMatCount
  if matCount >= totalMatCount then
    self.tip_label.text = string.format(ZhString.EquipReplaceNewView_MatTip, "4A5A7D", matCount, totalMatCount)
  else
    self.tip_label.text = string.format(ZhString.EquipReplaceNewView_MatTip, "ff0000", matCount, totalMatCount)
  end
  if not ignoreBordShow then
    if matEnough then
      if self.multiChooseBord.gameObject.activeSelf then
        self.multiChooseBord:SetTweenActive(true)
        self.multiChooseBord:Hide()
      end
    else
      self:TryShowMultiChooseBord()
    end
  end
end

local getComposeDataFromItem = function(item)
  local sId, cId
  sId = item and item.staticData.id
  cId = equipTable[sId] and equipTable[sId].SubstituteID
  return cId and composeTable[cId]
end
local getComposeCfgFromItemByField = function(item, field)
  local cData = getComposeDataFromItem(item)
  return cData and cData[field]
end
local replaceablePredicate = function(item)
  if not getComposeDataFromItem(item) then
    return false
  end
  local equipInfo = item.equipInfo
  if equipInfo.damage then
    return false
  end
  return true
end

function EquipReplaceNewView:GetChooseBordDatas()
  self.chooseDatas = self.chooseDatas or {}
  tableClear(self.chooseDatas)
  local items, item
  for i = 1, #replaceTargetPackageCheck do
    items = bagIns:GetBagByType(replaceTargetPackageCheck[i]):GetItems()
    if items then
      for j = 1, #items do
        item = items[j]
        if replaceablePredicate(item) then
          arrayPushBack(self.chooseDatas, item)
        end
      end
    end
  end
  BlackSmithProxy.SortEquips(self.chooseDatas)
  return self.chooseDatas
end

local lastGenReplaceMatPredicate = function(item)
  if bagIns:CheckIfFavoriteCanBeMaterial(item) == false then
    return false
  end
  if item.equipedCardInfo and next(item.equipedCardInfo) then
    return false
  end
  local equipInfo = item.equipInfo
  if equipInfo.damage then
    return false
  end
  if equipInfo.refinelv > GameConfig.Item.material_max_refine then
    return false
  end
  return true
end
local getMaterialEquips = function(id)
  local equips, equip = BlackSmithProxy.Instance:GetMaterialEquips_ByEquipId(id, nil, true, nil, replaceMatPackageCheck)
  for i = #equips, 1, -1 do
    equip = equips[i]
    if not equip.equipInfo:IsNextGen() and not lastGenReplaceMatPredicate(equip) then
      table.remove(equips, i)
    end
  end
  return equips
end

function EquipReplaceNewView:GetMultiChooseBordDatas()
  self.multiChooseDatas = self.multiChooseDatas or {}
  tableClear(self.multiChooseDatas)
  if self.targetData then
    local costItemCfg = getComposeCfgFromItemByField(self.targetData, "BeCostItem")
    if costItemCfg then
      local items
      for i = 1, #costItemCfg do
        items = getMaterialEquips(costItemCfg[i].id)
        for j = 1, #items do
          if items[j].id ~= self.targetData.id or 1 < items[j].num then
            local item = items[j]:Clone()
            item.id = items[j].id
            if item.id == self.targetData.id then
              item.num = item.num - 1
            end
            arrayPushBack(self.multiChooseDatas, item)
          end
        end
      end
    end
  end
  return self.multiChooseDatas
end

local updateMatElements_NextGen = function(datas, targetData)
  local totalCount, costItemCfg = 0, getComposeCfgFromItemByField(targetData, "BeCostItem")
  if costItemCfg then
    local cfg, data
    for i = 1, #costItemCfg do
      cfg = costItemCfg[i]
      data = datas[i] or ItemData.new()
      data:ResetData(MaterialItemCell.MaterialType.Material, cfg.id)
      data.num = shopIns:GetItemNum(cfg.id) or 0
      data.neednum = cfg.num
      totalCount = totalCount + cfg.num
      datas[i] = data
    end
  end
  local matCount = costItemCfg and #costItemCfg or 0
  for i = matCount + 1, #datas do
    datas[i] = nil
  end
  return totalCount
end
local updateMatElements_LastGen = function(datas, targetData)
  local matCount, totalCount, costItemCfg, cfg, items, item = 0, 0, getComposeCfgFromItemByField(targetData, "BeCostItem")
  local totalLeftCount = 0
  if costItemCfg then
    for i = 1, #costItemCfg do
      cfg = costItemCfg[i]
      totalCount = totalCount + cfg.num
      items = getMaterialEquips(cfg.id)
      local leftCount = totalCount
      for j = 1, #items do
        item = items[j]
        item = item:Clone()
        if item.id == targetData.id then
          item.num = item.num - 1
        end
        if leftCount < item.num then
          item.num = leftCount
          leftCount = 0
          arrayPushBack(datas, item)
          break
        elseif 0 < item.num then
          arrayPushBack(datas, item)
          leftCount = leftCount - item.num
        end
        if leftCount <= 0 then
          break
        end
      end
      totalLeftCount = totalLeftCount + math.max(0, leftCount)
    end
  end
  return totalCount
end

function EquipReplaceNewView:UpdateMat()
  self.matChooseSymbolTrans:SetParent(self.mainBoardTrans)
  tableClear(self.matDatas)
  local isNextGen = self:IsTargetNextGen()
  self.nextGenMatGrid.gameObject:SetActive(isNextGen)
  self.lastGenMatGrid.gameObject:SetActive(not isNextGen)
  local updateElementsFunc = isNextGen and updateMatElements_NextGen or updateMatElements_LastGen
  self.totalMatCount = updateElementsFunc(self.matDatas, self.targetData)
  if isNextGen then
    self.nextGenMatCtrl:ResetDatas(self.matDatas)
  else
    self:UpdateMultiChoose()
    self.scrollView:Scroll(self:GetMaterialDataCount() >= self.totalMatCount / 2 and 1 or -1)
    self.scrollView:UpdatePosition()
  end
  self.matChooseSymbol:SetActive(false)
end

function EquipReplaceNewView:UpdateZeny()
  local s = getComposeCfgFromItemByField(self.targetData, "ROB") or 0
  if self:CheckZeny() then
    self.coinNumLabel.text = s
  else
    self.coinNumLabel.text = string.format("[c][fb725f]%s[-][/c]", s)
  end
  tickManager:CreateOnceDelayTick(16, function(self)
    self.priceTable:Reposition()
  end, self)
end

function EquipReplaceNewView:UpdateCostCtrl()
  self.costLabel.text = StringUtil.NumThousandFormat(shopIns:GetItemNum(zenyId)) or 0
end

local updateLackItems_NextGen = function(lackItems, datas)
  local count, matData, num, neednum, lackData = 0
  for i = 1, #datas do
    matData = datas[i]
    num, neednum = matData.num, matData.neednum
    if num < neednum then
      count = count + 1
      lackData = lackItems[count] or {}
      lackData.id = matData.staticData.id
      lackData.count = neednum - num
      lackItems[count] = lackData
    end
  end
  for i = count + 1, #lackItems do
    lackItems[i] = nil
  end
end
local updateLackItems_LastGen = function(lackItems, selectData, targetData)
  local costItemCfg, count = getComposeCfgFromItemByField(targetData, "BeCostItem"), 0
  if costItemCfg then
    local cfg, num, lackData
    for i = 1, #costItemCfg do
      cfg, num = costItemCfg[i], 0
      for j = 1, #selectData do
        if BagItemCell.CheckData(selectData[j]) and selectData[j].staticData.id == cfg.id then
          num = num + selectData[j].num
        end
      end
      if num < cfg.num then
        count = count + 1
        lackData = lackItems[count] or {}
        lackData.id = cfg.id
        lackData.count = cfg.num - num
        lackItems[count] = lackData
      end
    end
  end
  for i = count + 1, #lackItems do
    lackItems[i] = nil
  end
end

function EquipReplaceNewView:UpdateLackItems()
  self.lackItems = self.lackItems or {}
  tableClear(self.lackItems)
  if self:IsTargetNextGen() then
    updateLackItems_NextGen(self.lackItems, self.matDatas)
  else
    updateLackItems_LastGen(self.lackItems, self.matDatas, self.targetData)
  end
end

function EquipReplaceNewView:UpdateAskBuyGrid()
  self.askBuyItems = self.askBuyItems or {}
  local data, lackData
  for i = 1, #self.lackItems do
    data, lackData = self.askBuyItems[i] or ItemData.new(), self.lackItems[i]
    data:ResetData(MaterialItemCell.MaterialType.Material, lackData.id)
    data.num = lackData.count
    self.askBuyItems[i] = data
  end
  for i = #self.lackItems + 1, #self.askBuyItems do
    self.askBuyItems[i] = nil
  end
  self.askBuyCtrl:ResetDatas(self.askBuyItems)
end

local getDataCount = function(datas)
  local count = 0
  for i = 1, #datas do
    if BagItemCell.CheckData(datas[i]) then
      count = count + datas[i].num
    end
  end
  return count
end
local checkMat_NextGen = function(datas)
  local enough, data = true
  for i = 1, #datas do
    data = datas[i]
    enough = enough and data.neednum <= data.num
  end
  return enough
end
local checkMat_LastGen = function(datas, totalMatCount)
  local deltaCount = getDataCount(datas) - totalMatCount
  return 0 <= deltaCount, deltaCount
end

function EquipReplaceNewView:CheckMat()
  if not self.targetData then
    return false
  end
  if not self.matDatas then
    return false
  end
  if self:IsTargetNextGen() then
    return checkMat_NextGen(self.matDatas)
  else
    return checkMat_LastGen(self.matDatas, self.totalMatCount)
  end
end

function EquipReplaceNewView:CheckZeny()
  local myZeny, robCfg = MyselfProxy.Instance:GetROB(), getComposeCfgFromItemByField(self.targetData, "ROB") or 0
  return myZeny >= robCfg
end

function EquipReplaceNewView:TryShowMultiChooseBord()
  if self.multiChooseBord.gameObject.activeSelf then
    self.multiChooseBord:ResetDatas(self:GetMultiChooseBordDatas())
  else
    self.multiChooseBord:SetTweenActive(true)
    self.multiChooseBord:ResetDatas(self:GetMultiChooseBordDatas(), true)
    self.multiChooseBord:Show()
  end
  self.multiChooseBord:SetChooseReference(self.matDatas)
  self.multiChooseBord:SetUseItemNum(true)
end

function EquipReplaceNewView:TryPlayEffectThenCall(func)
  self.collider:SetActive(true)
  self:SetActionBtnActive(false)
  self:PlayUIEffect(EffectMap.UI.EquipReplaceNew, self.effectContainer, true)
  tickManager:CreateOnceDelayTick(1000, func, self)
end

function EquipReplaceNewView:_Replace()
  if self.targetData then
    local materials, data
    if not self:IsTargetNextGen() then
      materials = {}
      for i = 1, #self.matDatas do
        data = self.matDatas[i]
        if BagItemCell.CheckData(data) then
          local msg = NetConfig.PBC and {} or SceneItem_pb.ExchangeMaterial()
          msg.guid = data.id
          msg.num = data.num
          arrayPushBack(materials, msg)
        end
      end
    end
    local id = self.targetData.id
    FunctionSecurity.Me():HoleEquip(function()
      ServiceItemProxy.Instance:CallEquipExchangeItemCmd(id, SceneItem_pb.EEXCHANGETYPE_EXCHANGE, materials)
    end)
  end
  self.collider:SetActive(false)
end

function EquipReplaceNewView:IsTargetNextGen()
  if not self.targetData or not self.targetData.equipInfo then
    return false
  end
  return self.targetData.equipInfo:IsNextGen()
end

function EquipReplaceNewView:SetActionBtnActive(isActive)
  self.actionBtnActive = isActive and true or false
  self:UpdateActionBtnActive()
end

function EquipReplaceNewView:GetMaterialDataCount()
  return getDataCount(self.matDatas)
end

local inactiveLabelColor, activeLabelEffectColor, inactiveLabelEffectColor = LuaColor.New(0.9372549019607843, 0.9372549019607843, 0.9372549019607843), LuaColor.New(0.7686274509803922, 0.5254901960784314, 0), LuaColor.New(0.39215686274509803, 0.40784313725490196, 0.4627450980392157)

function EquipReplaceNewView:UpdateActionBtnActive()
  local isActive = self.actionBtnActive
  self.actionBgSp.CurrentState = isActive and 1 or 0
  self.actionLabel.color = isActive and ColorUtil.NGUIWhite or inactiveLabelColor
  self.actionLabel.effectColor = isActive and activeLabelEffectColor or inactiveLabelEffectColor
  self:UpdateZeny()
end

local tipOffset = {-210, 180}

function EquipReplaceNewView:ShowItemTip(cell, showChooseSymbol)
  local data = cell.data
  if not BagItemCell.CheckData(data) then
    return
  end
  self.tipData.itemdata = data
  self.tipData.showUpTip = false
  EquipReplaceNewView.super.ShowItemTip(self, self.tipData, cell.icon, NGUIUtil.AnchorSide.Left, tipOffset)
  showChooseSymbol = showChooseSymbol and true or false
  if showChooseSymbol then
    self.matChooseSymbolTrans:SetParent(cell.gameObject.transform)
    self.matChooseSymbolTrans.localPosition = LuaGeometry.Const_V3_zero
  end
  self.matChooseSymbol:SetActive(showChooseSymbol)
end
