autoImport("EquipChooseBord1")
autoImport("MaterialItemCell1")
autoImport("RefineCombineView")
autoImport("CostInfoCell2")
RefineTransferView = class("RefineTransferView", BaseView)
RefineTransferView.ViewType = UIViewType.NormalLayer
RefineTransferView.BrotherView = RefineCombineView
RefineTransferView.ViewMaskAdaption = {all = 1}
RefineTransferView.PreviewPartName = "RefinePreview"
RefineTransferView.PreviewPartCellName = "RefineTransferAttributeCell"
RefineTransferView.PreviewPartLocalPosY = -153
RefineTransferView.CostItemIds = {
  GameConfig.MoneyId.Zeny,
  GameConfig.MoneyId.Lottery
}
local BagTypes_RefineCheck = GameConfig.PackageMaterialCheck.refine

function RefineTransferView:Init()
  self.isCombine = self.viewdata.viewdata and self.viewdata.viewdata.isCombine
  self.isfashion = self.viewdata.viewdata and self.viewdata.viewdata.isfashion
  self.isFromBag = self.viewdata.viewdata and self.viewdata.viewdata.isFromBag
  self:InitView()
  self:AddListenEvts()
end

local mReverse_Table_RefineTransfer
local mFInitTransferCostConfig = function()
  if mReverse_Table_RefineTransfer then
    return
  end
  mReverse_Table_RefineTransfer = {}
  for id, data in pairs(Table_RefineTransfer) do
    if not mReverse_Table_RefineTransfer[data.Type] then
      mReverse_Table_RefineTransfer[data.Type] = {}
    end
    mReverse_Table_RefineTransfer[data.Type][data.Lv] = data
  end
end
local CostParamName = {
  [4] = {
    [3] = "FirstToSecond",
    [2] = "FirstToThird",
    [1] = "FirstToThird"
  },
  [3] = {
    [2] = "SecondToThird",
    [1] = "SecondToThird"
  }
}
local mFSameRefine = function(dstRefine, srcRefine)
  if dstRefine == srcRefine then
    return true
  end
  return (dstRefine == 1 or dstRefine == 2) and (srcRefine == 1 or srcRefine == 2)
end

function mFGetTransferCost(srcData, dstData)
  if not srcData or not dstData then
    return nil
  end
  local retCost
  local srcIsHeadType = srcData.equipInfo and srcData.equipInfo:IsHeadEquipType()
  local dstIsHeadType = dstData.equipInfo and dstData.equipInfo:IsHeadEquipType()
  local srcRefine = srcData.equipInfo and srcData.equipInfo.equipData.NewEquipRefine
  local dstRefine = dstData.equipInfo and dstData.equipInfo.equipData.NewEquipRefine
  if srcIsHeadType and dstIsHeadType then
    local refinelv = srcData.equipInfo.refinelv
    retCost = GameConfig.Equip.HeadWearRefineTransferCost and GameConfig.Equip.HeadWearRefineTransferCost[refinelv]
  elseif mFSameRefine(dstRefine, srcRefine) then
    retCost = GameConfig.Equip.RefineTransferItemCost[srcRefine]
  end
  if retCost then
    return retCost
  end
  local costParam = CostParamName[srcRefine] and CostParamName[srcRefine][dstRefine]
  if costParam then
    local refinelv = srcData.equipInfo.refinelv
    local rtype = GameConfig.Equip.EquipTransferType[srcData.staticData.Type]
    if rtype and refinelv then
      if not mReverse_Table_RefineTransfer then
        mFInitTransferCostConfig()
      end
      retCost = mReverse_Table_RefineTransfer[rtype][refinelv] and mReverse_Table_RefineTransfer[rtype][refinelv][costParam]
    end
  end
  return retCost
end

local getTransferType = function(equip)
  local cfg = GameConfig.Equip.EquipTransferType
  if not equip or not cfg then
    return
  end
  return cfg[equip.staticData.Type]
end

function CheckIsSameType(equip1, equip2)
  local t1, t2 = getTransferType(equip1), getTransferType(equip2)
  return t1 ~= nil and t1 == t2
end

local newEquipRefineBan = GameConfig.BanRefineTransfer and GameConfig.BanRefineTransfer.NewEquipRefine
local SrcEquipPredicate = function(equip, dstEquip)
  local equipInfo = equip.equipInfo
  if equipInfo:CanRefineTransfer() and equipInfo.refinelv > 0 and not equipInfo.damage and (not newEquipRefineBan or TableUtility.ArrayFindIndex(newEquipRefineBan, equipInfo.equipData.NewEquipRefine) == 0) then
    if dstEquip then
      return CheckIsSameType(equip, dstEquip)
    end
    return true
  end
  return false
end

function RefineTransferView:GetSrcChooseDatas()
  self.srcDatas = self.srcDatas or {}
  TableUtility.ArrayClear(self.srcDatas)
  local equips = BlackSmithProxy.Instance:GetRefineEquips(BlackSmithProxy.GetRefineEquipTypeMap())
  for i = 1, #equips do
    if SrcEquipPredicate(equips[i], self.dstData) then
      TableUtility.ArrayPushBack(self.srcDatas, equips[i])
    end
  end
  return self.srcDatas
end

local DstEquipPredicate = function(equip, compareTarget)
  local equipInfo = equip.equipInfo
  if not mFGetTransferCost(compareTarget, equip) then
    return false
  end
  return equipInfo:CanRefineTransfer() and equipInfo.refinelv < compareTarget.equipInfo.refinelv and not equipInfo.damage and CheckIsSameType(equip, compareTarget) and equip.id ~= compareTarget.id and (not newEquipRefineBan or TableUtility.ArrayFindIndex(newEquipRefineBan, equipInfo.equipData.NewEquipRefine) == 0)
end

function RefineTransferView:GetDstChooseDatas()
  self.dstDatas = self.dstDatas or {}
  TableUtility.ArrayClear(self.dstDatas)
  local equips = BlackSmithProxy.Instance:GetRefineEquips(BlackSmithProxy.GetRefineEquipTypeMap())
  for i = 1, #equips do
    if DstEquipPredicate(equips[i], self.srcData) then
      TableUtility.ArrayPushBack(self.dstDatas, equips[i])
    end
  end
  return self.dstDatas
end

function RefineTransferView:OnChooseDstItem(data)
  if data then
    self.dstData = data:Clone()
    self.dstData.showDelete = true
    self.dstData.num = 1
    self:HideChooseBord()
    if not self.srcData then
      self:ShowChooseSrcBord()
    end
  else
    self.dstData = nil
    self:ShowChooseDstBord()
  end
  self:UpdateMainBoard()
end

function RefineTransferView:OnChooseSrcItem(data)
  if data then
    self.srcData = data:Clone()
    self.srcData.showDelete = true
    self.srcData.num = 1
    self:HideChooseBord()
    if not self.dstData then
      self:ShowChooseDstBord()
    end
  else
    self.srcData = nil
    self:ShowChooseSrcBord()
  end
  self:UpdateMainBoard()
end

function RefineTransferView:ShowChooseDstBord()
  self.chooseBord:ResetDatas(self:GetDstChooseDatas(), true)
  self.chooseBord:Show(nil, self.OnChooseDstItem, self)
end

function RefineTransferView:ShowChooseSrcBord()
  self.chooseBord:ResetDatas(self:GetSrcChooseDatas(), true)
  self.chooseBord:Show(nil, self.OnChooseSrcItem, self)
end

function RefineTransferView:HideChooseBord()
  self.chooseBord:Hide()
end

function RefineTransferView:ClickDstItem(cell)
  if self.transferLocked then
    return
  end
  if not self.srcData and not self.dstData then
    return
  end
  self:OnChooseDstItem()
  if not self.srcData then
    self:ShowChooseSrcBord()
  else
    self:ShowChooseDstBord()
  end
end

function RefineTransferView:ClickSrcItem(cell)
  if self.transferLocked then
    return
  end
  self:OnChooseSrcItem(nil)
  self:ShowChooseSrcBord()
end

function RefineTransferView:InitView()
  self.closeButton = self:FindGO("CloseButton")
  self.closeButton:SetActive(self.isCombine ~= true)
  self.title = self:FindComponent("Title", UILabel)
  self.transferIconTex = self:FindComponent("TransferIcon", UITexture)
  self.priceIndicator = self:FindGO("PriceIndicator")
  self.priceTable = self.priceIndicator:GetComponent(UITable)
  self.priceSp = self:FindComponent("PriceIcon", UISprite)
  self.priceNumLabel = self:FindComponent("PriceNum", UILabel)
  self.dstItem = MaterialItemCell1.new(self:FindGO("DstItem"))
  self.dstItem:AddEventListener(MouseEvent.MouseClick, self.ClickDstItem, self)
  self.dstItem:AddEventListener(MaterialItemCell1.Event.Delete, self.ClickDstItem, self)
  self.srcItem = MaterialItemCell1.new(self:FindGO("SrcItem"))
  self.srcItem:AddEventListener(MouseEvent.MouseClick, self.ClickSrcItem, self)
  self.srcItem:AddEventListener(MaterialItemCell1.Event.Delete, self.ClickSrcItem, self)
  self.attriDstLabel = self:FindComponent("AttrLabelDst", UILabel)
  self.attriSrcLabel = self:FindComponent("AttrLabelSrc", UILabel)
  self.effectDstLabel = self:FindComponent("EffectDstLabel", UILabel)
  self.effectDstLabel_Tween = self.effectDstLabel:GetComponent(TweenAlpha)
  self.transferSuccessGo = self:FindGO("TransferSuccessCell")
  self.chooseContainer = self:FindGO("ChooseContainer")
  self.chooseBord = EquipChooseBord1_CombineSize.new(self.chooseContainer)
  self.chooseBord:SetFilterPopData(GameConfig.EquipChooseFilter)
  self.chooseBord:Hide()
  self.costCtl = UIGridListCtrl.new(self:FindComponent("CostGrid", UIGrid), CostInfoCell2, "CostInfoCell2")
  self.costCtl:AddEventListener(CostInfoCell2.ClickTrace, self.ShowGetPath, self)
  self.tipGO = self:FindGO("Tip")
  self.tipLabel = self.tipGO:GetComponent(UILabel)
  self.effContainer = self:FindGO("EffectContainer")
  self.helpBtn = self:FindGO("HelpButton")
  self.actionBtn = self:FindGO("ActionBtn")
  self:AddClickEvent(self.actionBtn, function()
    self:ClickTransfer()
  end)
  self.confirmBtn = self:FindGO("ConfirmBtn")
  self:AddClickEvent(self.confirmBtn, function()
    self:Reset()
  end)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.effectContainer = self:FindGO("EffectContainer")
  self.transferBord = self:FindGO("TransferBord")
  self.previewTitleLabel = self:FindComponent("PreviewTitle", UILabel, self.transferBord)
  local lvGO = self:FindGO("RefineLv", self.transferBord)
  self.nowRefineLv = self:FindComponent("Now", UILabel, lvGO)
  self.nextRefineLv = self:FindComponent("Next", UILabel, lvGO)
  local effectGO = self:FindGO("RefineAttri", self.transferBord)
  self.refineEffect = self:FindComponent("Name", UILabel, effectGO)
  self.nowEffect = self:FindComponent("Now", UILabel, effectGO)
  self.nextEffect = self:FindComponent("Next", UILabel, effectGO)
  self.transferCost = self:FindGO("RefinePreview/TransferCost")
  self.transferCostCtl = ListCtrl.new(self:FindComponent("Grid", UIGrid, self.transferCost), MaterialItemCell1, "MaterialItemCell1")
  self.transferCostCtl:AddEventListener(MouseEvent.MouseClick, self.ClickCostItem, self)
  self.helpBtn:SetActive(self:GetNextGen())
  if not self:GetNextGen() then
    ServiceItemProxy.Instance:CallQueryLotteryHeadItemCmd()
  end
  self:UpdateMainBoard()
  self:UpdateCost()
end

function RefineTransferView:ClickCostItem(cell)
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
    self:ShowItemTip(self.tipdata, self.tipStick, NGUIUtil.AnchorSide.Left, {-370, 0})
  else
    self:ShowItemTip()
  end
end

function RefineTransferView:ShowGetPath()
  FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit, FunctionNewRecharge.InnerTab.Deposit_Zeny)
end

function RefineTransferView:GetNextGen()
  return self.viewdata.viewdata and self.viewdata.viewdata.isnew or false
end

local CostDatas = {100}

function RefineTransferView:UpdateCost()
  if not self.isCombine then
    self.costCtl:ResetDatas(CostDatas)
  end
end

function RefineTransferView:AddListenEvts()
  self:AddListenEvt(MyselfEvent.ZenyChange, self.UpdateCost)
  self:AddListenEvt(ServiceEvent.ItemEquipRefineTransferItemCmd, self.OnRefineTransfer)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateTransferCost)
end

function RefineTransferView:OnRefineTransfer(note)
  if note.body.success then
    self:SetTransferSuccess()
  end
end

function RefineTransferView:SetTransferSuccess()
  self.transferLocked = true
  self.srcItem:SetIconAlpha(0.5)
  self.dstData.equipInfo.refinelv = self.srcData.equipInfo.refinelv
  self.dstData.showDelete = false
  self.srcData.showDelete = false
  self:UpdateMainBoard()
  self:SetAttriLabel(nil, "+" .. self.srcData.equipInfo.refinelv, nil, ZhString.RefineTransferView_RedColor)
  self.effectDstLabel.text = string.format(ZhString.RefineTransferView_TransferLabel, self.srcData.equipInfo.refinelv)
  self.effectDstLabel_Tween:ResetToBeginning()
  self.effectDstLabel_Tween:PlayForward()
  self.priceIndicator:SetActive(false)
  self.chooseSymbol:SetActive(false)
  self.actionBtn:SetActive(false)
  self.confirmBtn:SetActive(true)
end

function RefineTransferView:Reset()
  self.transferLocked = false
  self.dstData = nil
  self.srcData = nil
  self.srcItem:SetIconAlpha(1)
  self.priceIndicator:SetActive(true)
  self.actionBtn:SetActive(true)
  self.confirmBtn:SetActive(false)
  self:UpdateMainBoard()
end

function RefineTransferView:UpdateMainBoard()
  self.dstItem:SetData(self.dstData)
  self.srcItem:SetData(self.srcData)
  self.dstToLv = nil
  if self.dstData and self.srcData then
    self.dstToLv = self.srcData.equipInfo.refinelv
    self:SetAttriLabel("+" .. self.srcData.equipInfo.refinelv)
    self.chooseSymbol:SetActive(false)
    local proName, now, next = ItemUtil.GetRefineAttrPreview(self.dstData.equipInfo, self.srcData.equipInfo.refinelv)
    if proName then
      self.refineEffect.text = proName
      self.nowRefineLv.text = "+" .. self.dstData.equipInfo.refinelv
      self.nextRefineLv.text = "+" .. self.srcData.equipInfo.refinelv
      self.nowEffect.text = now
      self.nextEffect.text = next
    end
    self.tipGO:SetActive(false)
    self.transferBord:SetActive(true)
    self:UpdateTransferCost()
    self.previewTitleLabel.text = self.dstData.staticData.NameZh
    self:sendNotification(ItemEvent.EquipChooseSuccess, self.dstData)
  elseif self.srcData then
    self:SetAttriLabel("+" .. self.srcData.equipInfo.refinelv)
    self.chooseSymbol.transform:SetParent(self.dstItem.gameObject.transform)
    self.chooseSymbol:SetActive(true)
    self.chooseSymbol.transform.localPosition = LuaVector3.Zero()
    self.tipGO:SetActive(true)
    self.transferBord:SetActive(false)
    self.tipLabel.text = ZhString.RefineTransferView_ChooseTargetOutFirst
  else
    self:SetAttriLabel()
    self.chooseSymbol.transform:SetParent(self.srcItem.gameObject.transform)
    self.chooseSymbol:SetActive(true)
    self.chooseSymbol.transform.localPosition = LuaVector3.Zero()
    self.tipGO:SetActive(true)
    self.transferBord:SetActive(false)
    self.tipLabel.text = ZhString.RefineTransferView_ChooseTargetInFirst
    self:sendNotification(ItemEvent.EquipChooseSuccess)
  end
end

function RefineTransferView:SetAttriLabel(src, dst, srcCOlor, dstColor)
  if src then
    self.attriSrcLabel.alpha = 1
    srcCOlor = srcCOlor or ZhString.RefineTransferView_RedColor
    self.attriSrcLabel.text = string.format(srcCOlor, src)
  else
    self.attriSrcLabel.alpha = 0
  end
  if dst then
    self.attriDstLabel.alpha = 1
    dstColor = dstColor or ZhString.RefineTransferView_GreenColor
    self.attriDstLabel.text = string.format(dstColor, dst)
  else
    self.attriDstLabel.alpha = 0
  end
end

function RefineTransferView:DoTransfer()
  ServiceItemProxy.Instance:CallEquipRefineTransferItemCmd(self.srcData.id, self.dstData.id)
  self.clickDisabled = false
end

local _checkCost = function(itemid, num)
  return num <= BagProxy.Instance:GetItemNumByStaticID(itemid, BagTypes_RefineCheck)
end

function RefineTransferView:CheckCost()
  local costs = self:GetTransferCost()
  if costs then
    for i = 1, #costs do
      if not _checkCost(costs[i][1], costs[i][2]) then
        return false
      end
    end
  end
  return true
end

function RefineTransferView:ClickTransfer()
  if not self.dstData then
    return
  end
  if not self.srcData then
    return
  end
  if self.clickDisabled then
    return
  end
  local isValidHeadWearType = self.srcData.equipInfo:IsHeadWearTypeTransferValid()
  if isValidHeadWearType then
    local zenyNotEnough = false
    local lackItems = {}
    local costs = self:GetTransferCost()
    for i = 1, #costs do
      local ownCount = BagProxy.Instance:GetItemNumByStaticID(costs[i][1], BagTypes_RefineCheck)
      if ownCount < costs[i][2] then
        if costs[i][1] == 100 then
          zenyNotEnough = true
        else
          table.insert(lackItems, {
            id = costs[i][1],
            count = costs[i][2] - ownCount
          })
        end
      end
    end
    if zenyNotEnough then
      MsgManager.ShowMsgByIDTable(1)
      return
    elseif 0 < #lackItems then
      QuickBuyProxy.Instance:TryOpenView(lackItems)
      return
    end
  elseif not self:CheckCost() then
    MsgManager.ShowMsgByIDTable(8)
    return
  end
  local callFunc = function()
    self.clickDisabled = true
    self:PlayUIEffect(EffectMap.UI.RefineTransfer, self.effectContainer, true)
    TimeTickManager.Me():CreateOnceDelayTick(800, self.DoTransfer, self)
  end
  if isValidHeadWearType then
    MsgManager.ConfirmMsgByID(43587, function()
      callFunc()
    end)
  else
    callFunc()
  end
end

function RefineTransferView:UpdateTransferCost()
  local costs = self:GetTransferCost()
  if not costs then
    self.priceIndicator:SetActive(false)
  else
    local matDatas = {}
    for i = 1, #costs do
      local cost = costs[i]
      if cost[1] == 100 then
        self.needZenyType = cost[1]
        self.needZeny = cost[2]
      else
        local matItem
        for i = 1, #BagTypes_RefineCheck do
          matItem = BagProxy.Instance:GetItemByStaticID(cost[1], BagTypes_RefineCheck[i])
          if matItem then
            break
          end
        end
        if not matItem then
          matItem = ItemData.new("RefineTransferCost", cost[1])
          matItem.num = 0
        else
          matItem = matItem:Clone()
        end
        matItem.neednum = cost[2]
        table.insert(matDatas, matItem)
      end
    end
    if 0 < #matDatas then
      self.transferCost:SetActive(true)
      self.transferCostCtl:ResetDatas(matDatas)
    else
      self.transferCost:SetActive(false)
    end
    if self.needZenyType then
      self.priceIndicator:SetActive(true)
      local iconName = Table_Item[self.needZenyType] and Table_Item[self.needZenyType].Icon or ""
      IconManager:SetItemIcon(iconName, self.priceSp)
      self.priceNum = self.needZeny or 0
      if _checkCost(self.needZenyType, self.needZeny) then
        self.priceNumLabel.text = self.priceNum
      else
        self.priceNumLabel.text = string.format("[c][fb725f]%s[-][/c]", self.priceNum)
      end
    else
      self.priceIndicator:SetActive(false)
    end
  end
end

function RefineTransferView:GetTransferCost()
  return mFGetTransferCost(self.srcData, self.dstData)
end

function RefineTransferView:OnEnter()
  RefineTransferView.super.OnEnter(self)
  self:ShowChooseSrcBord()
  self.npcInfo = self.viewdata.viewdata and self.viewdata.viewdata.npcdata
  if self.npcInfo then
    local rootTrans = self.npcInfo.assetRole.completeTransform
    if self.isfashion then
      self:CameraFocusAndRotateTo(rootTrans, CameraConfig.SwingMachine_ViewPort, CameraConfig.SwingMachine_Rotation)
    else
      self:CameraFocusAndRotateTo(rootTrans, CameraConfig.SwingMachine_ViewPort, CameraConfig.SwingMachine_Rotation)
    end
  else
    self:CameraFocusToMe()
  end
end

function RefineTransferView:OnExit()
  self:CameraReset()
  RefineTransferView.super.OnExit(self)
end
