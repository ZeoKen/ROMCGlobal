DeComposeView = class("DeComposeView", BaseView)
autoImport("BagCombineItemCell")
autoImport("ItemData")
autoImport("EquipChooseBord")
autoImport("DecomposeItemCell")
DeComposeView.ViewType = UIViewType.NormalLayer
DeComposeView.BrotherView = EquipRecoverCombinedView
local ACTION_DECOMPOSE = "functional_action"

function DeComposeView:Init()
  local viewdata = self.viewdata.viewdata
  self.npcguid = viewdata and viewdata.npcdata and viewdata.npcdata.data.id
  self.tipData = {}
  self:InitUI()
  self:MapEvent()
end

function DeComposeView:InitUI()
  self.decomposeBord = self:FindGO("DecomposeBord")
  self.resultGrid = self:FindComponent("ResultGrid", UIGrid)
  self.resultCtl = UIGridListCtrl.new(self.resultGrid, DecomposeItemCell, "DecomposeItemCell")
  self.resultCtl:AddEventListener(MouseEvent.MouseClick, self.clickResultCell, self)
  self.businessTip = self:FindGO("BusinessTip")
  self.businessTip_1 = self:FindComponent("Tip1", UILabel)
  self.businessTip_2 = self:FindComponent("Tip2", UILabel)
  self.cost = self:FindComponent("Cost", UILabel)
  self.cost.text = 0
  local l_zenyIcon = self:FindComponent("Sprite", UISprite, self.cost.gameObject)
  IconManager:SetItemIcon(Table_Item[100].Icon, l_zenyIcon)
  local coins = self:FindChild("TopCoins")
  self.userRob = self:FindChild("Silver", coins)
  self.robLabel = self:FindComponent("Label", UILabel, self.userRob)
  local symbol = self:FindComponent("symbol", UISprite, self.userRob)
  IconManager:SetItemIcon(Table_Item[GameConfig.MoneyId.Zeny].Icon, symbol)
  self.bg = self:FindComponent("Bg", UISprite)
  self.waittingSymbol = self:FindGO("WaittingSymbol")
  self.chooseBord = EquipChooseBord.new(self:FindGO("ChooseContainer"), function()
    return self:GetDecomposeEquips()
  end)
  self.chooseBord:AddEventListener(EquipChooseBord.ChooseItem, self.ChooseItem, self)
  self.chooseBord:Hide()
  self.addbord = self:FindGO("AddBord")
  self:InitTipLabels()
  self.colliderMask = self:FindGO("ColliderMask")
  self:AddButtonEvent("StartButton", function(go)
    return self:StartDeCompose()
  end)
  self.decomposeBord:SetActive(false)
  local itemContainer = self:FindGO("ChoosenEquipWrap")
  local wrapConfig = {
    wrapObj = itemContainer,
    pfbNum = 10,
    cellName = "BagCombineItemCell",
    control = BagCombineItemCell
  }
  self.chooseCtl = WrapCellHelper.new(wrapConfig)
  self.chooseCtl:AddEventListener(MouseEvent.MouseClick, self.HandleChooseItem, self)
  self.chooseEquips = {}
end

function DeComposeView:InitTipLabels()
  local addTipLab = self:FindComponent("TipLabel", UILabel, self.addbord)
  addTipLab.text = ZhString.DeComposeView_AddTip
end

function DeComposeView:HandleChooseItem(cellCtl)
  if cellCtl then
    self:ChooseItem(cellCtl.data)
  end
end

function DeComposeView:ReUnitData(datas, rowNum)
  self.unitData = self.unitData or {}
  TableUtility.ArrayClear(self.unitData)
  if datas ~= nil and 0 < #datas then
    for i = 1, #datas do
      local i1 = math.floor((i - 1) / rowNum) + 1
      local i2 = math.floor((i - 1) % rowNum) + 1
      self.unitData[i1] = self.unitData[i1] or {}
      self.unitData[i1][i2] = datas[i]
    end
  end
  return self.unitData
end

function DeComposeView:OnEnter()
  DeComposeView.super.OnEnter(self)
  local npcinfo = self:GetCurNpc()
  if npcinfo then
    local npcRootTrans = npcinfo.assetRole.completeTransform
    if npcRootTrans then
      self:CameraFocusOnNpc(npcRootTrans)
    end
  end
  self:UpdateCoins()
  self:UpdateChooseBord()
end

function DeComposeView:OnExit()
  self:CameraReset()
  DeComposeView.super.OnExit(self)
end

function DeComposeView:OnShow()
  Game.Myself:UpdateEpNodeDisplay(true)
end

function DeComposeView:GetCurNpc()
  if self.npcguid then
    return NSceneNpcProxy.Instance:Find(self.npcguid)
  end
  return nil
end

local _isEquipClean

function DeComposeView:GetDecomposeEquips()
  local equips = {}
  local bagEquips = BagProxy.Instance:GetBagEquipItems()
  TableUtil.InsertArray(equips, bagEquips)
  local result, equip, equipInfo, equipData = {}
  for i = 1, #bagEquips do
    equip = bagEquips[i]
    equipInfo = equip.equipInfo
    if not equipInfo then
      LogUtility.ErrorFormat("EquipInfo is nil: {0}", equip.staticData.NameZh)
    end
    equipData = equipInfo.equipData
    local maxrefinelv = GameConfig.Item.decompose_material_max_refine or 10
    if (equipData.DecomposeID ~= nil or next(equipData.NewEquipDecompose) ~= nil) and BagProxy.Instance:CheckIfFavoriteCanBeMaterial(equip) ~= false and maxrefinelv >= equipInfo.refinelv then
      if not self.chooseEquips[equip.id] then
        table.insert(result, equip)
      elseif equip.num > self.chooseEquips[equip.id].num then
        local cloneData = equip:Clone()
        cloneData.num = equip.num - self.chooseEquips[equip.id].num
        table.insert(result, cloneData)
      end
    end
  end
  if _isEquipClean == nil then
    _isEquipClean = BagProxy.CheckEquipIsClean
  end
  table.sort(result, function(a, b)
    local aNeedRecover = not _isEquipClean(a, true, true)
    local bNeedRecover = not _isEquipClean(b, true, true)
    if aNeedRecover == bNeedRecover then
      return a.staticData.id < b.staticData.id
    end
    return not aNeedRecover
  end)
  return result
end

function DeComposeView:UpdateChooseBord()
  local equipdatas = self:GetDecomposeEquips()
  local resetPos = #equipdatas < 5
  self.chooseBord.chooseCtl.scrollView.disableDragIfFits = resetPos
  self.chooseBord:ResetDatas(equipdatas, resetPos)
  self.chooseBord:Show(false, nil, nil, self.checkValidEquipFunc, nil, ZhString.DeComposeView_InvalidTip)
end

function DeComposeView.checkValidEquipFunc(param, data)
  if not _isEquipClean(data, true, true) then
    return false, ZhString.DeComposeView_InvalidTip
  end
  return true
end

function DeComposeView:clickResultCell(cell)
  if self.ShowTip then
    self:ShowItemTip()
  else
    self:ShowItemTip(cell.data, cell.gameObject, function()
      self.ShowTip = false
    end)
  end
  self.ShowTip = not self.ShowTip
end

local tipOffset = {-180, 0}

function DeComposeView:ShowItemTip(data, ignoreBound, callback, funcConfig, tipOffsetX)
  if not data then
    TipManager.CloseTip()
    return
  end
  self.tipData.itemdata = data
  self.tipData.ignoreBounds = ignoreBound
  self.tipData.callback = callback
  self.tipData.funcConfig = funcConfig or _EmptyTable
  tipOffset[1] = tipOffsetX or -180
  return TipManager.Instance:ShowItemFloatTip(self.tipData, self.bg, NGUIUtil.AnchorSide.Left, tipOffset)
end

function DeComposeView:ChooseItem(itemData)
  if not itemData then
    return
  end
  local chooseData = self:GetChooseEquips()
  self.waittingSymbol:SetActive(true)
  if nil == self.chooseEquips[itemData.id] then
    if #chooseData >= self:GetMaxDeComposeCount() then
      MsgManager.ShowMsgByID(244)
      self.waittingSymbol:SetActive(false)
      return
    end
    self.chooseEquips[itemData.id] = itemData
  else
    self.chooseEquips[itemData.id] = nil
  end
  self:DecomposePreview()
end

local ONE_THOUSAND = 1000
local TEN_THOUSAND = 10000
local getmetalrate = function(itemData)
  if itemData.equipInfo:IsNextGen() then
    return
  end
  local decomposeID = itemData.equipInfo.equipData.DecomposeID
  local decomposeData = decomposeID and Table_EquipDecompose[decomposeID]
  if decomposeData and decomposeData.Material then
    local myselfData = Game.Myself and Game.Myself.data
    if not myselfData then
      return
    end
    if not (GameConfig.Decompose and GameConfig.Decompose.price and calcDecomposeFloatParam) or not CommonFun.calcDecomposeCount1 then
      return
    end
    for i = 1, #decomposeData.Material do
      local decomposenum = Table_Equip[itemData.staticData.id].DecomposeNum
      local metalrate = decomposeData.Material[i].rate / TEN_THOUSAND
      local metalid = decomposeData.Material[i].id
      local metalprice = GameConfig.Decompose.price[metalid] or 0
      local refinelv = itemData.equipInfo.refinelv
      local fminparam = calcDecomposeFloatParam(1)
      local fmaxparam = calcDecomposeFloatParam(2)
      local minEquipId = BlackSmithProxy.GetEquipMinVID(itemData.staticData.id)
      local costNum = 1
      if minEquipId ~= itemData.staticData.id then
        local cid = Table_Equip[minEquipId].SubstituteID
        local beCost = cid and Table_Compose[cid] and Table_Compose[cid].BeCostItem
        if beCost then
          for i = 1, #beCost do
            if beCost[i].id == minEquipId then
              costNum = beCost[i].num
              break
            end
          end
        end
      end
      local decomposeorinum = minEquipId and Table_Equip[minEquipId].DecomposeNum or decomposenum
      local fmin = CommonFun.calcDecomposeCount1(myselfData, decomposenum, decomposeorinum, nil, metalrate, metalprice, refinelv, fminparam, costNum)
      local fmax = CommonFun.calcDecomposeCount1(myselfData, decomposenum, decomposeorinum, nil, metalrate, metalprice, refinelv, fmaxparam, costNum)
      local data = ReusableTable.CreateTable()
      data.min_count = fmin * ONE_THOUSAND
      data.max_count = fmax * ONE_THOUSAND
      data.id = metalid
      return data
    end
  end
end
local tempEquips = {}

function DeComposeView:GetChooseEquips()
  TableUtility.ArrayClear(tempEquips)
  local cost = 0
  for _, item in pairs(self.chooseEquips) do
    TableUtility.ArrayPushBack(tempEquips, item)
    cost = cost + self:GetCoinCost(item)
  end
  return tempEquips, cost
end

function DeComposeView:GetCoinCost(item)
  local equipInfo = item and item.equipInfo
  if equipInfo then
    if equipInfo:IsNextGen() then
      return GameConfig.Equip.EquipDecomposeZenyCost * item.num
    else
      local decomposeID = equipInfo.equipData.DecomposeID
      local decomposeData = decomposeID and Table_EquipDecompose[decomposeID]
      if decomposeData and decomposeData.Cost then
        return decomposeData.Cost * item.num
      end
    end
  end
  return 0
end

function DeComposeView:UpdateCoins()
  self.robLabel.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetROB())
end

function DeComposeView:CheckCoins(showTip)
  local _, totalCost = self:GetChooseEquips()
  if totalCost and totalCost > MyselfProxy.Instance:GetROB() then
    if showTip then
      MsgManager.ShowMsgByID(1)
    end
    return false
  end
  return true
end

function DeComposeView:MapEvent()
  self:AddListenEvt(ServiceEvent.ItemEquipDecompose, self.HandleEquipCompose)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateCoins)
end

local MATH_MODF = math.modf

function DeComposeView:DecomposePreview()
  self.waittingSymbol:SetActive(false)
  local results, cfg, data = ReusableTable.CreateArray()
  for _, item in pairs(self.chooseEquips) do
    if item.equipInfo:IsNextGen() then
      cfg = item.equipInfo.equipData.NewEquipDecompose
      for i = 1, #cfg do
        data = ReusableTable.CreateTable()
        data.id, data.num = cfg[i][1], cfg[i][2]
        if ISNoviceServerType and item.equipInfo:IsNoviceEquip() then
          data.num = data.num + item.equipInfo:GetNoviceRefineDecomposeNum()
        end
        TableUtility.ArrayPushBack(results, data)
      end
    else
      TableUtility.ArrayPushBack(results, getmetalrate(item))
    end
  end
  self.resultMap = self.resultMap or {}
  TableUtility.TableClear(self.resultMap)
  local itemData, id, num, minrate, maxrate
  for i = 1, #results do
    id, num, minrate, maxrate = results[i].id, results[i].num, results[i].min_count, results[i].max_count
    itemData = self.resultMap[id] or ItemData.new("Decompose", id)
    if num then
      itemData.num = itemData.num + num
    elseif minrate and maxrate then
      itemData.minrate = (itemData.minrate or 0) + MATH_MODF(minrate / ONE_THOUSAND)
      itemData.maxrate = (itemData.maxrate or 0) + MATH_MODF(maxrate / ONE_THOUSAND)
    end
    self.resultMap[id] = itemData
    ReusableTable.DestroyAndClearTable(results[i])
  end
  TableUtility.ArrayClear(results)
  for _, item in pairs(self.resultMap) do
    TableUtility.ArrayPushBack(results, item)
  end
  table.sort(results, function(l, r)
    return l.staticData.id < r.staticData.id
  end)
  self.resultCtl:ResetDatas(results)
  ReusableTable.DestroyAndClearArray(results)
  self:UpdateBusinessTip()
  local chooseData, totalCost = self:GetChooseEquips()
  self.decomposeBord:SetActive(0 < #chooseData)
  self.addbord:SetActive(#chooseData <= 0)
  chooseData = self:ReUnitData(chooseData, 5)
  self.chooseCtl:UpdateInfo(chooseData)
  self:UpdateChooseBord()
  if 0 < totalCost then
    if totalCost > MyselfProxy.Instance:GetROB() then
      self.cost.text = string.format("[c]%s%s[-][/c]", CustomStrColor.BanRed, totalCost)
    else
      self.cost.text = tostring(totalCost)
    end
  else
    self.cost.text = 0
  end
end

function DeComposeView:UpdateBusinessTip()
  if CommonFun.calcOrideconResearch then
    local pct = CommonFun.calcOrideconResearch(Game.Myself.data) or 0
    if pct == 0 then
      self:SetBusinessTip(false)
    else
      pct = math.floor(pct * ONE_THOUSAND) / 10
      self:SetBusinessTip(true, pct)
    end
  else
    self:SetBusinessTip(false)
  end
end

function DeComposeView:SetBusinessTip(active, pct)
  if active then
    self.businessTip:SetActive(true)
    self.businessTip_1.text = ZhString.DecomposeView_BusinessTip1
    self.businessTip_2.text = string.format(ZhString.DecomposeView_BusinessTip2, pct)
  else
    self.businessTip:SetActive(false)
  end
end

function DeComposeView:HandleEquipCompose(note)
  TableUtility.TableClear(self.chooseEquips)
  self.resultCtl:ResetDatas({})
  self.chooseCtl:UpdateInfo({})
  self.cost.text = 0
  self.decomposeBord:SetActive(false)
  self.addbord:SetActive(true)
  self.waitingCallback = false
end

function DeComposeView:GetGUIDs()
  local result = {}
  for k, v in pairs(self.chooseEquips) do
    result[#result + 1] = k
  end
  return result
end

function DeComposeView:GetMaxDeComposeCount()
  return 50
end

function DeComposeView:StartDeCompose()
  if not self:CheckCoins(true) then
    return
  end
  local result = {}
  local valid = true
  for k, v in pairs(self.chooseEquips) do
    if not BagProxy.CheckEquipIsClean(v, true, true) then
      valid = false
      break
    end
    table.insert(result, v:ExportServerItemInfo())
  end
  if not valid then
    MsgManager.FloatMsg(nil, ZhString.DeComposeView_InvalidTip)
    return
  end
  if 0 < #result then
    if self.waitingCallback then
      return
    end
    self.waitingCallback = true
    FunctionSecurity.Me():NormalOperation(function()
      local npcinfo = self:GetCurNpc()
      if npcinfo then
        npcinfo:Client_PlayAction(ACTION_DECOMPOSE, nil, false)
      end
      ServiceItemProxy.Instance:CallEquipDecompose(result)
    end)
  else
    MsgManager.ShowMsgByIDTable(400)
  end
end
