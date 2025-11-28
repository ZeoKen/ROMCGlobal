autoImport("EquipRecoveryFatherCell")
autoImport("MaterialItemNewCell")
EquipRecoveryView = class("EquipRecoveryView", BaseView)
EquipRecoveryView.ViewType = UIViewType.NormalLayer
EquipRecoveryView.ViewMaskAdaption = {all = 1}
local bg3TexName = "Equipmentopen_bg_bottom_02"
local shopIns, bagIns, tickManager, blackSmith, zenyId, packageCheck, arrayPushBack, tableClear

function EquipRecoveryView:Init()
  if not shopIns then
    shopIns = HappyShopProxy.Instance
    bagIns = BagProxy.Instance
    tickManager = TimeTickManager.Me()
    blackSmith = BlackSmithProxy.Instance
    zenyId = GameConfig.MoneyId.Zeny
    packageCheck = GameConfig.PackageMaterialCheck.equip_recovery
    arrayPushBack = TableUtility.ArrayPushBack
    tableClear = TableUtility.TableClear
  end
  self:FindObjs()
  self:InitView()
  self:AddListenEvts()
  self:InitData()
end

function EquipRecoveryView:FindObjs()
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
  self.rewardGrid = self:FindComponent("RewardGrid", UIGrid)
  local actionBtn = self:FindGO("ActionBtn")
  self.actionBgSp = actionBtn:GetComponent(UIMultiSprite)
  self.actionLabel = self:FindComponent("ActionLabel", UILabel, actionBtn)
  self.tip = self:FindGO("Tip")
  self.emptyTip = self:FindGO("EmptyTip")
  self.priceIndicator = self:FindGO("PriceIndicator")
  self.priceTable = self.priceIndicator:GetComponent(UITable)
  self.coinNumLabel = self:FindComponent("CoinNum", UILabel)
  self.coinIcon = self:FindComponent("CoinIcon", UISprite)
  self.chooseBordTween = self:FindComponent("ChooseBord", TweenPosition)
  self.chooseTable = self:FindComponent("ChooseTable", UITable)
  self.chooseNoneTip = self:FindGO("NoneTip", self.chooseBordTween.gameObject)
  self.collider = self:FindGO("Collider")
end

function EquipRecoveryView:InitView()
  local npcFunctionData = self.viewdata.viewdata and self.viewdata.viewdata.npcfunctiondata
  local titleName = npcFunctionData and npcFunctionData.NameZh
  if titleName then
    self.title.text = titleName
  end
  self:InitCostCtrl()
  self.rewardCtrl = ListCtrl.new(self.rewardGrid, MaterialItemNewCell, "MaterialItemNewCell")
  self.rewardCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickRewardCell, self)
  self.chooseListCtrl = ListCtrl.new(self.chooseTable, EquipRecoveryFatherCell, "EquipRecoveryFatherCell")
  self.chooseListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickChooseListCell, self)
  self.chooseListCtrl:AddEventListener(EquipChooseCellEvent.ClickItemIcon, self.OnClickChooseListCellIcon, self)
  IconManager:SetItemIcon(Table_Item[100].Icon, self.coinIcon)
  self.chooseBordTween:SetOnFinished(function()
    if self.isShowingChooseBord then
      return
    end
    self.chooseBordTween.gameObject:SetActive(false)
  end)
  self.chooseBordTween.gameObject:SetActive(false)
  self:AddButtonEvent("TargetCell", function()
    self:OnClickTargetCell()
  end)
  self:AddButtonEvent("ActionBtn", function()
    if not self.targetData then
      return
    end
    local equipInfo = self.targetData.equipInfo
    local site = equipInfo:GetEquipSite()
    local pos, times, targetTimes
    local equipRecoveryCfg = GameConfig.EquipRecovery
    if site then
      for i = 1, #site do
        pos = site[i]
        if pos then
          targetTimes = equipRecoveryCfg[pos]
          if targetTimes then
            times = blackSmith:GetEquipRecoveryTimes(pos, self.isPlus)
            targetTimes = targetTimes[self.isPlus and 1 or 2] or 0
            if times >= targetTimes then
              MsgManager.ShowMsgByID(26104)
              return
            end
          end
        end
      end
    end
    local enough, lackItemId = self:CheckCost()
    if not enough then
      if lackItemId == zenyId then
        MsgManager.ShowMsgByID(1)
      elseif lackItemId and Table_Item[lackItemId] then
        MsgManager.ShowMsgByIDTable(25418, Table_Item[lackItemId].NameZh)
      end
      return
    end
    if not self.actionBtnActive then
      return
    end
    local needRecover, recoverCost = self:CheckNeedRecover()
    if needRecover then
      MsgManager.ConfirmMsgByID(26102, function()
        ServiceItemProxy.Instance:CallRestoreEquipItemCmd(self.targetData.id, false, self.recoverCardIds, false, false, true)
      end, nil, nil, recoverCost)
    elseif self.targetData:HasEnchant() then
      MsgManager.ShowMsgByID(26105)
    else
      MsgManager.ConfirmMsgByID(26103, function()
        FunctionSecurity.Me():NormalOperation(function()
          self:TryPlayEffectThenCall(self._Recovery)
        end)
      end)
    end
  end)
end

function EquipRecoveryView:InitCostCtrl()
  IconManager:SetItemIcon(Table_Item[zenyId].Icon, self.costSp)
  self:UpdateCostCtrl()
  self:AddClickEvent(self.costAddBtn, function()
    FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit, FunctionNewRecharge.InnerTab.Deposit_Zeny)
  end)
end

function EquipRecoveryView:AddListenEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.OnItemUpdate)
  self:AddListenEvt(MyselfEvent.ZenyChange, self.OnZenyChange)
  self:AddListenEvt(ServiceEvent.ItemEquipRecoveryItemCmd, self.OnRecoveryComplete)
  self:AddListenEvt(ServiceEvent.ItemEquipRecoveryQueryItemCmd, self.OnRecoveryQuery)
end

function EquipRecoveryView:InitData()
  self.isPlus = self.viewdata.viewdata and self.viewdata.viewdata.plus and true or false
  self:RegistShowGeneralHelpByHelpID(self.isPlus and 35084 or 35085, self:FindGO("HelpButton"))
  self.tipData = {
    funcConfig = _EmptyTable,
    ignoreBounds = {
      self.rewardGrid.gameObject
    }
  }
end

function EquipRecoveryView:OnEnter()
  EquipRecoveryView.super.OnEnter(self)
  ServiceItemProxy.Instance:CallEquipRecoveryQueryItemCmd()
  PictureManager.Instance:SetUI(bg3TexName, self.bg3Tex)
  local npcData = self.viewdata.viewdata and self.viewdata.viewdata.npcdata
  if npcData then
    self:CameraFocusOnNpc(npcData.assetRole.completeTransform)
  else
    self:CameraRotateToMe()
  end
end

function EquipRecoveryView:OnExit()
  PictureManager.Instance:UnLoadUI(bg3TexName, self.bg3Tex)
  self:CameraReset()
  tickManager:ClearTick(self)
  EquipRecoveryView.super.OnExit(self)
end

function EquipRecoveryView:OnItemUpdate()
  if self.recoveryComplete then
    self.recoveryComplete = nil
    ServiceItemProxy.Instance:CallEquipRecoveryQueryItemCmd()
  else
    self:UpdateTargetCell()
  end
end

function EquipRecoveryView:OnZenyChange()
  self:UpdateCostCtrl()
end

function EquipRecoveryView:OnRecoveryComplete()
  self.recoveryComplete = true
end

function EquipRecoveryView:OnRecoveryQuery()
  self:OnClickTargetCell()
end

function EquipRecoveryView:OnClickTargetCell()
  local datas = self:GetChooseListDatas()
  self.chooseListCtrl:ResetDatas(datas, true)
  tickManager:CreateOnceDelayTick(16, function(self)
    self.chooseTable:Reposition()
  end, self)
  local itemCount = 0
  for _, d in pairs(datas) do
    itemCount = itemCount + #d.items
  end
  self.chooseNoneTip:SetActive(itemCount == 0)
  self.isShowingChooseBord = true
  self.chooseBordTween.gameObject:SetActive(true)
  self.chooseBordTween.enabled = true
  self.chooseBordTween:PlayForward()
  self.chooseBordTween:ResetToBeginning()
  self.chooseBordTween:PlayForward()
  self:SetTargetCell()
end

function EquipRecoveryView:OnClickChooseListCell(cellCtl)
  self:SetTargetCell(cellCtl and cellCtl.data)
end

local cellIconTipOffset = {216, -290}

function EquipRecoveryView:OnClickChooseListCellIcon(cellCtl)
  local data = cellCtl and cellCtl.data
  local go = cellCtl and cellCtl.itemIcon
  local newClickId = data and data.id or 0
  if self.chooseListIconClickId ~= newClickId then
    self.chooseListIconClickId = newClickId
    self.tipData.itemdata = data
    self.tipData.ignoreBounds[2] = go
    EquipRecoveryView.super.ShowItemTip(self, self.tipData, go:GetComponent(UIWidget), nil, cellIconTipOffset)
  else
    EquipRecoveryView.super.ShowItemTip(self)
    self.chooseListIconClickId = 0
  end
  for _, cell in pairs(self.chooseListCtrl:GetCells()) do
    cell:SetItemIconChooseId(self.chooseListIconClickId)
  end
end

function EquipRecoveryView:OnClickRewardCell(cell)
  self:ShowItemTip(cell)
end

function EquipRecoveryView:SetTargetCell(data)
  if not BagItemCell.CheckData(data) or data.staticData == nil then
    data = nil
  end
  self.targetData = data
  self:UpdateTargetCell()
end

function EquipRecoveryView:UpdateTargetCell()
  self.recoverySData = self:GetRecoveryStaticData()
  local hasData = self.targetData ~= nil and self.targetData.staticData ~= nil
  self.targetCellContent:SetActive(hasData)
  self.addIcon:SetActive(not hasData)
  self.tip:SetActive(hasData)
  self.emptyTip:SetActive(not hasData)
  self.priceIndicator:SetActive(hasData)
  self:UpdateReward()
  self:UpdateZeny()
  self:SetActionBtnActive(hasData and self:CheckCost())
  if hasData then
    IconManager:SetItemIcon(self.targetData.staticData.Icon, self.targetIcon)
    self.targetIcon:MakePixelPerfect()
    local scale = 0.8
    self.targetIcon.transform.localScale = LuaGeometry.GetTempVector3(scale, scale, scale)
    self.targetNameLabel.text = string.format("+%d%s", self.targetData.equipInfo.refinelv, self.targetData.staticData.NameZh)
    self.isShowingChooseBord = nil
    self.chooseBordTween:PlayReverse()
    self.chooseBordTween:ResetToBeginning()
    self.chooseBordTween:PlayReverse()
  end
end

local predicate = function(element, site)
  return element.site == site
end

function EquipRecoveryView:GetChooseListDatas()
  if not self.chooseDatas then
    self.chooseDatas = {}
    local index = 1
    for site, _ in pairs(GameConfig.EquipRecovery) do
      if type(site) == "number" then
        self.chooseDatas[index] = {
          site = site,
          plus = self.isPlus,
          items = {}
        }
        index = index + 1
      end
    end
    table.sort(self.chooseDatas, function(l, r)
      return l.site < r.site
    end)
  end
  for _, data in pairs(self.chooseDatas) do
    tableClear(data.items)
  end
  local minRefineLv = self.isPlus and 15 or 11
  local maxRefineLv = self.isPlus and 15 or 14
  local items, item, equipInfo, refineLv, site, config, d
  for i = 1, #packageCheck do
    items = bagIns:GetBagByType(packageCheck[i]):GetItems()
    if items then
      for j = 1, #items do
        item = items[j]
        equipInfo = item.equipInfo
        if equipInfo and not BagProxy.Instance:CheckIsFavorite(item) then
          refineLv, site, config = equipInfo.refinelv, equipInfo:GetEquipSite() or _EmptyTable, Game.Config_EquipRecovery[item.staticData.id]
          if minRefineLv <= refineLv and maxRefineLv >= refineLv and config and config[refineLv] then
            for k = 1, #site do
              d = TableUtility.ArrayFindByPredicate(self.chooseDatas, predicate, site[k])
              if d then
                arrayPushBack(d.items, item)
              end
            end
          end
        end
      end
    end
  end
  return self.chooseDatas
end

function EquipRecoveryView:UpdateReward()
  self.rewardDatas = self.rewardDatas or {}
  local rewardCfg, item = self.recoverySData and self.recoverySData.RewardItem or _EmptyTable
  for i = 1, #rewardCfg do
    item = self.rewardDatas[i] or ItemData.new()
    item:ResetData(MaterialItemCell.MaterialType.Material, rewardCfg[i][1])
    item.num = rewardCfg[i][2]
    self.rewardDatas[i] = item
  end
  for i = #rewardCfg + 1, #self.rewardDatas do
    self.rewardDatas[i] = nil
  end
  self.rewardCtrl:ResetDatas(self.rewardDatas)
end

local coinNumLabelEnoughColor, coinNumLabelNotEnoughColor = LuaColor.New(0.3176470588235294, 0.30980392156862746, 0.4823529411764706), LuaColor.New(1, 0.3764705882352941, 0.12941176470588237)

function EquipRecoveryView:UpdateZeny()
  self.coinNumLabel.text = self:GetZenyCostConfig()
  self.coinNumLabel.color = self:CheckCost() and coinNumLabelEnoughColor or coinNumLabelNotEnoughColor
  tickManager:CreateOnceDelayTick(16, function(self)
    self.priceTable:Reposition()
  end, self)
end

function EquipRecoveryView:UpdateCostCtrl()
  self.costLabel.text = StringUtil.NumThousandFormat(shopIns:GetItemNum(zenyId)) or 0
end

function EquipRecoveryView:CheckCost()
  local costCfg = self.recoverySData and self.recoverySData.CostItem
  if costCfg then
    local itemId
    for i = 1, #costCfg do
      itemId = costCfg[i][1]
      if shopIns:GetItemNum(itemId) < costCfg[i][2] then
        return false, itemId
      end
    end
    return true
  else
    return false
  end
end

function EquipRecoveryView:TryPlayEffectThenCall(func)
  self.collider:SetActive(true)
  self:SetActionBtnActive(false)
  self:PlayUIEffect(EffectMap.UI.EquipReplaceNew, self.effectContainer, true)
  tickManager:CreateOnceDelayTick(1000, func, self)
end

function EquipRecoveryView:_Recovery()
  if self.targetData then
    ServiceItemProxy.Instance:CallEquipRecoveryItemCmd(self.targetData.id)
  end
  self.collider:SetActive(false)
end

function EquipRecoveryView:CheckNeedRecover()
  local item = self.targetData
  if not item then
    return
  end
  self.recoverCardIds = self.recoverCardIds or {}
  tableClear(self.recoverCardIds)
  local equipInfo, equipedCards, result, recoverCost = item.equipInfo, item.equipedCardInfo, false
  if equipInfo then
    if equipedCards then
      for i = 1, item.cardSlotNum do
        if equipedCards[i] then
          arrayPushBack(self.recoverCardIds, equipedCards[i].id)
        end
      end
    end
    recoverCost = EquipUtil.GetRecoverCost(item, true, false, true, false, true)
    result = 0 < recoverCost
  end
  return result, recoverCost
end

function EquipRecoveryView:SetActionBtnActive(isActive)
  self.actionBtnActive = isActive and true or false
  self:UpdateActionBtnActive()
end

local inactiveLabelColor, activeLabelEffectColor, inactiveLabelEffectColor = LuaColor.New(0.9372549019607843, 0.9372549019607843, 0.9372549019607843), LuaColor.New(0.7686274509803922, 0.5254901960784314, 0), LuaColor.New(0.39215686274509803, 0.40784313725490196, 0.4627450980392157)

function EquipRecoveryView:UpdateActionBtnActive()
  local isActive = self.actionBtnActive
  self.actionBgSp.CurrentState = isActive and 1 or 0
  self.actionLabel.color = isActive and ColorUtil.NGUIWhite or inactiveLabelColor
  self.actionLabel.effectColor = isActive and activeLabelEffectColor or inactiveLabelEffectColor
  self:UpdateZeny()
end

local tipOffset = {-210, 180}

function EquipRecoveryView:ShowItemTip(cell)
  local data = cell.data
  if not BagItemCell.CheckData(data) then
    return
  end
  self.tipData.itemdata = data
  self.tipData.ignoreBounds[2] = nil
  EquipRecoveryView.super.ShowItemTip(self, self.tipData, cell.icon, NGUIUtil.AnchorSide.Left, tipOffset)
end

function EquipRecoveryView:GetRecoveryStaticData()
  local sData = self.targetData and self.targetData.staticData
  if not sData then
    return
  end
  local map, equipInfo = Game.Config_EquipRecovery[sData.id], self.targetData.equipInfo
  return map and equipInfo and map[equipInfo.refinelv]
end

function EquipRecoveryView:GetZenyCostConfig()
  local costCfg = self.recoverySData and self.recoverySData.CostItem
  if costCfg then
    for i = 1, #costCfg do
      if costCfg[i][1] == zenyId then
        return costCfg[i][2]
      end
    end
  end
  return 0
end
