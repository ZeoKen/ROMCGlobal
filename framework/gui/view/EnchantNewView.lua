autoImport("EquipNewChooseBord")
autoImport("EnchantNewCell")
autoImport("EnchantAttrInfoCell")
autoImport("MaterialItemNewCell")
autoImport("EnchantInfoBord")
EnchantNewView = class("EnchantNewView", BaseView)
EnchantNewView.ViewType = UIViewType.NormalLayer
autoImport("EnchantCombineView")
autoImport("EnchantNewCombineView")
EnchantNewView.BrotherView = EnchantNewCombineView
EnchantNewView.ViewMaskAdaption = {all = 1}
local bg3TexName, enchantTargetPackageCheck, enchantType = "Equipmentopen_bg_bottom_16", {
  2,
  20,
  1
}, SceneItem_pb.EENCHANTTYPE_SENIOR
local bagIns, blackSmith, enchantUtil, zenyId, enchantMatPackageCheck, tickManager, arrayPushBack, tableClear
local advancedCostPosOffset = -40
EnchantNewView.EquipChooseControl = EquipChooseBord

function EnchantNewView:Init()
  if not bagIns then
    bagIns = BagProxy.Instance
    blackSmith = BlackSmithProxy.Instance
    enchantUtil = EnchantEquipUtil.Instance
    zenyId = GameConfig.MoneyId.Zeny
    enchantMatPackageCheck = GameConfig.PackageMaterialCheck.enchant
    tickManager = TimeTickManager.Me()
    arrayPushBack = TableUtility.ArrayPushBack
    tableClear = TableUtility.TableClear
  end
  self.isFromHomeWorkbench = self.viewdata.viewdata and self.viewdata.viewdata.isFromHomeWorkbench
  self.lockedAdvanceCost = self.viewdata.viewdata and self.viewdata.viewdata.lockedAdvanceCost
  self.isCombine = self.viewdata.viewdata and self.viewdata.viewdata.isCombine
  self:FindObjs()
  self:InitView()
  self:AddListenEvts()
  self:InitData()
end

function EnchantNewView:FindObjs()
  self.mainBoardTrans = self:FindGO("MainBoard").transform
  self.closeButton = self:FindGO("CloseButton")
  self.bg3Tex = self:FindComponent("Bg3", UITexture)
  self.targetCellAddIcon = self:FindGO("TargetCellAddIcon")
  self.targetCellContent = self:FindGO("TargetCellContent")
  self.targetIcon = self:FindComponent("Icon", UISprite, self.targetCellContent)
  self.removeTargetObj = self:FindGO("DeleteIcon", self.targetCellContent)
  self:AddClickEvent(self.removeTargetObj, function()
    self:OnRemoveTarget()
  end)
  self.effContainer = self:FindGO("EffectContainer")
  local actionBtn = self:FindGO("ActionBtn")
  self.actionBgSp = actionBtn:GetComponent(UIMultiSprite)
  self.actionLabel = self:FindComponent("ActionLabel", UILabel, actionBtn)
  self.emptyTip = self:FindGO("EmptyTip")
  self.noneTip = self:FindGO("NoneTip")
  self.noneTip_Label = self.noneTip:GetComponent(UILabel)
  self.actionBoard = self:FindGO("ActionBoard")
  self.targetName = self:FindComponent("ItemName", UILabel, self.actionBoard)
  self.enchantNoneTip = self:FindGO("EnchantNoneTip", self.actionBoard)
  self.enchantCellParent = self:FindGO("EnchantCellParent", self.actionBoard)
  self.costBoard = self:FindGO("CostBoard")
  self.fixedCostGrid = self:FindComponent("FixedCostGrid", UIGrid, self.costBoard)
  self.advancedCostAddIcon = self:FindGO("AdvancedAddIcon")
  self.advancedCostContentGrid = self:FindComponent("AdvancedCostContent", UIGrid)
  self.advancedCostDeleteBtn = self:FindGO("DeleteIcon", self.advancedCostContentGrid.gameObject)
  self:AddClickEvent(self.advancedCostDeleteBtn, function()
    self:OnClickAdvancedChooseBordCancel()
  end)
  self.lockCostCellParent = self:FindGO("LockCostCellParent", self.advancedCostContentGrid.gameObject)
  self.enchantResult = self:FindGO("EnchantResult")
  self.enchantResultGrid = self:FindComponent("ResultGrid", UITable)
  self.resultNoneTip = self:FindGO("ResultNoneTip")
  self.giveUpBtn = self:FindGO("GiveUpBtn")
  self:Hide(self.giveUpBtn)
  self.chooseContainer = self:FindGO("ChooseContainer")
  self.enchantInfoBord = self:FindGO("EnchantInfoBoard")
  self.enchantInfoTable = self:FindComponent("EnchantInfoTable", UITable)
  self.collider = self:FindGO("Collider")
  self.tenPullsTog = self:FindGO("TenPullsTog"):GetComponent(UIToggle)
  self.tenPullsTog.value = false
  self.finishPart = self:FindGO("FinishPart")
  self.finish_Label = self:FindGO("Label", self.finishPart):GetComponent(UILabel)
  self:PlayUIEffect(EffectMap.UI.EquipEnchant_Bg, self:FindGO("TargetCell"), nil, function(obj, args, assetEffect)
    local effect = assetEffect
    local ps = effect.effectObj:GetComponentsInChildren(ParticleSystem, true)
    for i = 1, #ps do
      ps[i].gameObject:SetActive(false)
      ps[i].gameObject:SetActive(true)
    end
  end)
  self:RegistShowGeneralHelpByHelpID(35236, self:FindGO("HelpButton"))
end

function EnchantNewView:OnClickLockThirdAttrBtn(locked)
  self.thirdAttrLocked = locked
  self:ShowLockCostItem()
end

function EnchantNewView:InitView()
  self.closeButton:SetActive(not self.isCombine)
  self.targetChooseBord = self.EquipChooseControl.new(self.chooseContainer)
  self.targetChooseBord:SetFilterPopData(GameConfig.EquipChooseFilter)
  self.targetChooseBord:AddEventListener(EquipChooseBord.ChooseItem, self.OnClickChooseBordCell, self)
  self.fixedCostCtl = ListCtrl.new(self.fixedCostGrid, MaterialItemCell, "MaterialItemCell")
  self.fixedCostCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickFixed, self)
  self.enchantResultCtl = ListCtrl.new(self.enchantResultGrid, EnchantNewCell, "EnchantCell")
  self.enchantResultCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickResult, self)
  self.enchantScrollView = self:FindGO("EnchantCellScrollView"):GetComponent(UIScrollView)
  self.enchantCell = EnchantNewCell.new(self:LoadPreferb("cell/EnchantCell", self.enchantScrollView.gameObject))
  self.enchantCell:HideBG()
  self.enchantCell:AddEventListener(EnchantNewCell.EnchantNewCell_LockEvent, self.OnClickLockThirdAttrBtn, self)
  local lockCostCellObj = self:LoadPreferb("cell/MaterialItemCell", self.lockCostCellParent)
  lockCostCellObj.transform.localPosition = LuaGeometry.GetTempVector3(advancedCostPosOffset, advancedCostPosOffset)
  self.lockCostCell = MaterialItemCell.new(lockCostCellObj)
  local advancedCostCellObj = self:LoadPreferb("cell/MaterialItemCell", self.advancedCostDeleteBtn)
  advancedCostCellObj.transform.localPosition = LuaGeometry.GetTempVector3(advancedCostPosOffset, advancedCostPosOffset)
  self.advancedCostCell = MaterialItemCell.new(advancedCostCellObj)
  self.enchantInfoCtl = ListCtrl.new(self.enchantInfoTable, EnchantAttrInfoNewCell, "EnchantAttrInfoNewCell")
  self.enchantInfoBord = EnchantInfoBord.new(self.chooseContainer)
  self.enchantInfoBord:Hide()
  self:AddButtonEvent("TargetCell", function()
    self.enchantInfoBord:Hide()
    self:OnClickTargetCell()
  end)
  self:AddButtonEvent("ActionBtn", function()
    if not self.actionBtnActive then
      return
    end
    if not self:HasTarget() then
      return
    end
    if self:HasCacheRefreshAttr() then
      MsgManager.ConfirmMsgByID(4305, function()
        EventManager.Me():PassEvent(EnchantEvent.ReturnToReset)
      end)
      return
    end
    if not self:CheckFixedCost() then
      MsgManager.ShowMsgByID(8)
      return
    end
    if not self:CheckAdvancedCost() then
      MsgManager.ConfirmMsgByID(43140, function()
        tableClear(self.selectedAdvancedCosts)
        self.thirdAttrLockedShow = false
        self:UpdateAdvancedCost()
        self:Enchant()
      end)
    elseif self:CheckLockCostLimited() then
      MsgManager.ConfirmMsgByID(4304, function()
        self.enchantCell:ReverseLock()
        self:Enchant()
      end)
    else
      self:Enchant()
    end
  end)
  self:AddButtonEvent("SaveBtn", function()
    if self:HasCacheRefreshAttr() then
      MsgManager.ConfirmMsgByID(4305, function()
        EventManager.Me():PassEvent(EnchantEvent.ReturnToReset)
      end)
      return
    end
    if self:TryCompareEnchantAttr() then
      MsgManager.ConfirmMsgByID(43440, function()
        ServiceItemProxy.Instance:CallProcessEnchantItemCmd(true, self.targetData.id, self.curChooseResultID)
      end)
    else
      ServiceItemProxy.Instance:CallProcessEnchantItemCmd(true, self.targetData.id, self.curChooseResultID)
    end
  end)
  self:AddButtonEvent("QuitBtn", function()
    if self.targetData:HasGoodCacheEnchantAttri() then
      MsgManager.ConfirmMsgByID(3060, function()
        ServiceItemProxy.Instance:CallProcessEnchantItemCmd(false, self.targetData.id)
      end)
      return
    end
    ServiceItemProxy.Instance:CallProcessEnchantItemCmd(false, self.targetData.id)
  end)
  self.enchantInfoBtn = self:FindGO("EnchantInfoBtn")
  self:AddButtonEvent("EnchantInfoBtn", function()
    local curType = self.targetData and self.targetData.staticData.Type or nil
    local _data = {equipType = curType}
    self.enchantInfoBord:Show()
    self.enchantInfoBord:UpdateView(_data)
  end)
  self:AddClickEvent(self.advancedCostAddIcon, function()
    self:OnClickAdvancedCost()
  end)
  self:AddTabEvent(self.tenPullsTog.gameObject, function()
    self:UpdateFixedCost()
    self:UpdateAdvancedCost()
    self:SetActionBtnActive(self:CheckFixedCost())
  end)
end

function EnchantNewView:AddListenEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.OnItemUpdate)
  self:AddListenEvt(ItemEvent.EquipUpdate, self.OnItemUpdate)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.OnItemUpdate)
  self:AddListenEvt(ServiceEvent.ItemEnchantEquip, self.OnEnchant)
  self:AddListenEvt(ServiceEvent.ItemEnchantHighestBuffNotify, self.OnShowShare)
  self:AddListenEvt(ItemEvent.EquipIntegrate_TrySelectEquip, self.OnClickTargetCell)
end

function EnchantNewView:InitData()
  self.tipData = {
    funcConfig = _EmptyTable,
    ignoreBounds = {
      self.fixedCostGrid.gameObject
    }
  }
  self.selectedAdvancedCosts = {}
  if self.lockedAdvanceCost then
    xdlog("选定高级消耗道具", self.lockedAdvanceCost.staticData.id, self.lockedAdvanceCost.num)
    self.selectedAdvancedCosts[1] = self.lockedAdvanceCost
  end
  self.enchantInfoDatas = {}
  self.fixedCostItemDatas = {}
  self.thirdAttrLocked = false
  self:ShowLockCostItem()
end

function EnchantNewView:OnEnter()
  EnchantNewView.super.OnEnter(self)
  PictureManager.Instance:SetUI(bg3TexName, self.bg3Tex)
  self.npcData = self.viewdata.viewdata and self.viewdata.viewdata.npcdata
  if self.npcData then
    self:CameraFocusOnNpc(self.npcData.assetRole.completeTransform)
  else
    self:CameraRotateToMe()
  end
  if self.selectedAdvancedCosts[1] then
    self:OnRemoveTarget(true)
    return
  end
  if self.viewdata.viewdata.OnClickChooseBordCell_data then
    self:OnClickChooseBordCell(self.viewdata.viewdata.OnClickChooseBordCell_data)
  else
    local curEnchantId = EnchantEquipUtil.Instance:GetCurEnchantId()
    if curEnchantId then
      local item = bagIns:GetItemByGuid(curEnchantId, enchantTargetPackageCheck)
      if item then
        if self.lockedAdvanceCost then
          local costID = self.lockedAdvanceCost.staticData.id
          local config = Table_EnchantMustBuff[costID]
          local positions = config and config.Position
          if positions and TableUtility.ArrayFindIndex(positions, item.equipInfo.equipData.Type) > 0 then
            self:OnClickChooseBordCell(item)
            return
          end
        else
          self:OnClickChooseBordCell(item)
          return
        end
      end
    end
    self:OnRemoveTarget(true)
  end
end

function EnchantNewView:OnShowShare(data)
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.EnchantNewShareView,
    viewdata = {
      enchantAttrList = self.targetData.enchantInfo.enchantAttrs,
      combineEffectList = self.targetData.enchantInfo.combineEffectlist,
      itemdata = self.targetData
    }
  })
end

function EnchantNewView:_DestroyReusableAttr()
  if nil == self.arr then
    return
  end
  for i = 1, #self.arr do
    ReusableTable.DestroyAndClearTable(self.arr[i])
  end
  ReusableTable.DestroyAndClearArray(self.arr)
  self.arr = nil
end

function EnchantNewView:OnExit()
  self:_DestroyReusableAttr()
  PictureManager.Instance:UnLoadUI(bg3TexName, self.bg3Tex)
  self:CameraReset()
  tickManager:ClearTick(self)
  EnchantNewView.super.OnExit(self)
  if self.viewdata.viewdata and self.viewdata.viewdata.lockedAdvanceCost then
    EventManager.Me():PassEvent(EnchantEvent.ResetLockedAdvCost)
    tableClear(self.selectedAdvancedCosts)
    self.viewdata.viewdata.lockedAdvanceCost = nil
  end
end

function EnchantNewView:OnItemUpdate()
  if self.enchantComplete then
    self.enchantComplete = nil
    tickManager:CreateOnceDelayTick(33, function(self)
      self:UpdateTargetCell()
    end, self)
  else
    self:UpdateTargetCell()
  end
  self.enchantInfoBord:Hide()
end

function EnchantNewView:OnEnchant(data)
  self.enchantComplete = true
  self.curChooseResultID = nil
end

function EnchantNewView:OnClickTargetCell()
  if self:HasTarget() then
    self:OnRemoveTarget()
    return
  else
    self:OnRemoveTarget()
    return
  end
  if self.targetChooseBord:ActiveSelf() then
    return
  end
  self.targetChooseBord:Show()
  self.targetChooseBord:SetChoose()
end

function EnchantNewView:OnRemoveTarget(init)
  self.curChooseResultID = nil
  self:OnClickEnchantInfoCloseBtn()
  self.enchantResult:SetActive(false)
  if self.lockedAdvanceCost then
    self.targetChooseBord:ResetDatas(self:GetValidEquipByAdvancedCost(), init)
    self.targetChooseBord:ActiveFilterPop(false)
  else
    self.targetChooseBord:ResetDatas(self:GetTargetChooseBordDatas(), init)
    self.targetChooseBord:ActiveFilterPop(true)
  end
  self.targetChooseBord:Show()
  self.targetChooseBord:SetChoose()
  if self.advancedChooseBord then
    self.advancedChooseBord:Hide()
  end
  if not self.lockedAdvanceCost then
    tableClear(self.selectedAdvancedCosts)
  end
  self:ResetThirdAttrLock()
  self:SetTargetCell()
end

function EnchantNewView:OnClickChooseBordCell(data)
  self:SetTargetCell(data)
end

function EnchantNewView:OnClickAdvancedChooseBordChoose(data)
  xdlog("添加高级消耗")
  self.selectedAdvancedCosts[1] = data
  self:UpdateAdvancedCost()
  self.advancedChooseBord:Hide()
  self:TryShowEnchantResult()
end

function EnchantNewView:OnClickAdvancedChooseBordCancel(data)
  xdlog("OnClickAdvancedChooseBordCancel移除高级消耗")
  self.selectedAdvancedCosts[1] = nil
  if self.lockedAdvanceCost then
    self.lockedAdvanceCost = nil
    self.targetChooseBord:ResetDatas(self:GetTargetChooseBordDatas(), init)
    self.targetChooseBord:ActiveFilterPop(true)
  end
  self:ResetThirdAttrLock()
  self:UpdateAdvancedCost()
end

function EnchantNewView:ResetThirdAttrLock()
  self.thirdAttrLockedShow = false
  self.thirdAttrLocked = false
  self.enchantCell:ResetAttrLocked()
end

function EnchantNewView:OnClickFixed(cell)
  self:ShowItemTip(cell)
end

function EnchantNewView:OnClickResult(cell)
  self.curChooseResultID = cell.index
  local cells = self.enchantResultCtl:GetCells()
  for i = 1, #cells do
    cells[i]:SetChooseId(cell.index)
  end
end

function EnchantNewView:OnClickEnchantInfoCloseBtn()
  self.enchantInfoBord:SetActive(false)
end

local advancedChooseBordTypeLabelTextGetter = function(data)
  return data and data.staticData and data.staticData.Desc
end

function EnchantNewView:OnClickAdvancedCost()
  self.enchantResult:SetActive(false)
  self:OnClickEnchantInfoCloseBtn()
  if not self.advancedChooseBord then
    self.advancedChooseBord = EquipMultiChooseBord_CombineSize.new(self.chooseContainer)
    self.advancedChooseBord:SetBordTitle(ZhString.EnchantView_AdvancedChooseBordTitle)
    self.advancedChooseBord:SetNoneTip(ZhString.EnchantView_AdvancedChooseBordNoneTip)
    self.advancedChooseBord:SetTypeLabelTextGetter(advancedChooseBordTypeLabelTextGetter)
    self.advancedChooseBord:AddEventListener(EquipChooseBord.ChooseItem, self.OnClickAdvancedChooseBordChoose, self)
    self.advancedChooseBord:SetChooseReference(self.selectedAdvancedCosts)
  end
  if self.advancedChooseBord.gameObject.activeSelf then
    self.advancedChooseBord:ResetDatas(self:GetAdvancedChooseBordDatas())
  else
    self.advancedChooseBord:ResetDatas(self:GetAdvancedChooseBordDatas(), true)
    self.advancedChooseBord:Show()
  end
end

function EnchantNewView:SetTargetCell(data)
  if not BagItemCell.CheckData(data) or data.staticData == nil then
    data = nil
  end
  self:ResetThirdAttrLock()
  local curEnchantItemId = data and data.id or nil
  enchantUtil:SetCurrentEnchantId(curEnchantItemId)
  self.targetData = data
  self:UpdateTargetCell()
  if data then
    self:sendNotification(ItemEvent.EquipChooseSuccess, data)
  end
end

local iconScale = 1

function EnchantNewView:UpdateTargetCell()
  local hasData = self:HasTarget()
  local canEnchant = self.targetData and self.targetData.equipInfo and self.targetData.equipInfo:CanEnchant() or false
  if hasData and not canEnchant then
    redlog("无法附魔的装备")
    self.finishPart:SetActive(true)
    self.finish_Label.text = ZhString.EnchantView_EnchantInvalid
    self.enchantInfoBtn:SetActive(false)
    self.targetCellContent:SetActive(true)
    self.targetCellAddIcon:SetActive(false)
    self.emptyTip:SetActive(false)
    self.noneTip:SetActive(false)
    self.actionBoard:SetActive(false)
    self.costBoard:SetActive(false)
    self.actionBgSp.gameObject:SetActive(false)
    self.tenPullsTog.gameObject:SetActive(false)
    IconManager:SetItemIcon(self.targetData.staticData.Icon, self.targetIcon)
    self.targetIcon:MakePixelPerfect()
    self.targetIcon.transform.localScale = LuaGeometry.GetTempVector3(iconScale, iconScale, iconScale)
    self.targetName.text = self.targetData:GetName()
    self.targetChooseBord:Hide()
    self.enchantResult:SetActive(false)
    self:Hide(self.collider)
    return
  end
  self.enchantInfoBtn:SetActive(true)
  self.finishPart:SetActive(false)
  self.targetCellContent:SetActive(hasData)
  self.targetCellAddIcon:SetActive(not hasData)
  self.emptyTip:SetActive(not hasData)
  self.noneTip:SetActive(not hasData)
  self.actionBoard:SetActive(hasData)
  self.costBoard:SetActive(hasData)
  self.actionLabel.text = ZhString.EnchantView_Enchant
  self.hasUnsavedAttri = false
  if hasData then
    self.actionBgSp.gameObject:SetActive(true)
    self.tenPullsTog.gameObject:SetActive(true)
    IconManager:SetItemIcon(self.targetData.staticData.Icon, self.targetIcon)
    self.targetIcon:MakePixelPerfect()
    self.targetIcon.transform.localScale = LuaGeometry.GetTempVector3(iconScale, iconScale, iconScale)
    self.targetName.text = self.targetData:GetName()
    self.targetChooseBord:Hide()
    self:UpdateEnchantResult()
    self:UpdateCurrentEnchant()
    self:UpdateFixedCost()
    self:UpdateAdvancedCost()
    self:UpdateEnchantInfo()
  else
    self.actionBgSp.gameObject:SetActive(false)
    self.tenPullsTog.gameObject:SetActive(false)
    if self.lockedAdvanceCost then
      xdlog("有高级消耗")
      self.actionBoard:SetActive(true)
      self.emptyTip:SetActive(false)
      self.costBoard:SetActive(true)
      self:UpdateEmptyFixedCost()
      self:UpdateCurrentEnchant()
      self:UpdateFixedCost()
      self:UpdateAdvancedCost()
      self:UpdateEnchantInfo()
    end
  end
  self:SetActionBtnActive(hasData and self:CheckFixedCost())
  self:TryShowEnchantResult()
  self:Hide(self.collider)
end

function EnchantNewView:GetTargetChooseBordDatas()
  self.targetChooseDatas = self.targetChooseDatas or {}
  tableClear(self.targetChooseDatas)
  local items, equipInfo
  for i = 1, #enchantTargetPackageCheck do
    items = bagIns.bagMap[enchantTargetPackageCheck[i]]:GetItems()
    if items then
      for j = 1, #items do
        equipInfo = items[j] and items[j].equipInfo
        if equipInfo and equipInfo:CanEnchant() then
          arrayPushBack(self.targetChooseDatas, items[j])
        end
      end
    end
  end
  return self.targetChooseDatas
end

function EnchantNewView:GetAdvancedChooseBordDatas()
  self.advancedChooseDatas = self.advancedChooseDatas or {}
  tableClear(self.advancedChooseDatas)
  if self:HasTarget() then
    local targetIsGvgEquip = self:CheckTargetIsGvgEquip()
    local costCfg, itemId, item = self:GetTargetAdvancedEnchantCostConfig()
    for i = 1, #costCfg do
      itemId = costCfg[i].itemid
      if targetIsGvgEquip or not BlackSmithProxy.Instance:IsGvgSeasonItem(itemId) then
        for j = 1, #enchantMatPackageCheck do
          item = bagIns:GetItemByStaticID(itemId, enchantMatPackageCheck[j])
          if item then
            arrayPushBack(self.advancedChooseDatas, item)
            break
          end
        end
      end
    end
    table.sort(self.advancedChooseDatas, function(l, r)
      return l.staticData.id < r.staticData.id
    end)
  end
  return self.advancedChooseDatas
end

function EnchantNewView:GetTargetAdvancedEnchantCostConfig()
  return self:HasTarget() and blackSmith:GetAdvancedEnchantCostConfig(self.targetData.equipInfo.equipData.Type) or _EmptyTable
end

function EnchantNewView:GetValidEquipByAdvancedCost()
  self.advCostValidEquips = self.advCostValidEquips or {}
  tableClear(self.advCostValidEquips)
  self.selectedAdvancedCosts = self.selectedAdvancedCosts or {}
  if #self.selectedAdvancedCosts == 0 then
    return
  end
  local advCostID = self.selectedAdvancedCosts[1].staticData.id
  if not advCostID then
    return
  end
  xdlog("高级消耗ID", advCostID)
  for k, v in pairs(Table_EnchantMustBuff) do
    if v.ItemID == advCostID then
      local positions = v.Position
      for i = 1, #enchantTargetPackageCheck do
        local items = bagIns.bagMap[enchantTargetPackageCheck[i]]:GetItems()
        for j = 1, #items do
          local equipInfo = items[j] and items[j].equipInfo
          if equipInfo and equipInfo:CanEnchant() and (v.UseType ~= "gvg" or ItemUtil.IsGVGSeasonEquip(equipInfo.equipData.id)) then
            local Type = equipInfo.equipData.Type
            if Type and 0 < TableUtility.ArrayFindIndex(positions, Type) then
              arrayPushBack(self.advCostValidEquips, items[j])
            end
          end
        end
      end
      break
    end
  end
  return self.advCostValidEquips
end

function EnchantNewView:GetTargetAdvancedEnchantCostNeedNum(itemId)
  local neednum = 0
  for _, d in pairs(self:GetTargetAdvancedEnchantCostConfig()) do
    if d.itemid == itemId then
      neednum = d.num
      break
    end
  end
  return neednum
end

function EnchantNewView:GetEnchantInfoDatas()
  tableClear(self.enchantInfoDatas)
  if self:HasTarget() then
    local type = self.targetData.staticData.Type
    local enchantDatas = enchantUtil:GetEnchantDatasByEnchantType(enchantType)
    local attriMenuType, pos, infoData, cbdata
    for attriType, data in pairs(enchantDatas) do
      attriMenuType, pos = enchantUtil:GetMenuType(attriType)
      infoData = self.enchantInfoDatas[attriMenuType]
      if not infoData then
        infoData = {}
        infoData.attriMenuType = attriMenuType
        infoData.attris = {}
        self.enchantInfoDatas[attriMenuType] = infoData
      end
      cbdata = {}
      cbdata.attriMenuType = attriMenuType
      cbdata.equipType = type
      cbdata.enchantData, cbdata.canGet = data:Get(type)
      cbdata.pos = pos
      arrayPushBack(infoData.attris, cbdata)
    end
    local combineEffects = enchantUtil:GetCombineEffects(enchantType)
    if next(combineEffects) then
      infoData = {}
      infoData.attriMenuType = EnchantMenuType.CombineAttri
      infoData.attris = {}
      arrayPushBack(self.enchantInfoDatas, infoData)
      local nameKeysMap, canGet = {}
      for _, data in pairs(combineEffects) do
        if nameKeysMap[data.Name] == nil then
          cbdata = {}
          cbdata.attriMenuType = EnchantMenuType.CombineAttri
          cbdata.equipType = type
          cbdata.enchantData = data
          cbdata.pos = data.id
          cbdata.canGet = enchantUtil:CanGetCombineEffect(data, type)
          arrayPushBack(infoData.attris, cbdata)
          nameKeysMap[data.Name] = #infoData.attris
        else
          canGet = enchantUtil:CanGetCombineEffect(data, type)
          if canGet then
            cbdata = infoData.attris[nameKeysMap[data.Name]]
            cbdata.enchantData = data
            cbdata.pos = data.id
            cbdata.canGet = true
          end
        end
      end
    end
  end
  return self.enchantInfoDatas
end

function EnchantNewView:GetCellDataFromEnchantInfo(enchantInfo, index, isCache)
  if enchantInfo and self:HasTarget() then
    local attrs = enchantInfo.enchantAttrs
    if attrs and 0 < #attrs then
      local cellData = self:_GetCellData(index)
      cellData.enchantAttrList = attrs
      cellData.combineEffectList = enchantInfo.combineEffectlist
      if not isCache then
        cellData.thirdAttrType = enchantInfo:GetThirdAttrType()
      end
      return cellData
    end
  end
end

function EnchantNewView:_GetCellData(index)
  local cellData = ReusableTable.CreateTable()
  cellData.index = index
  return cellData
end

function EnchantNewView:UpdateEnchantResult()
  self:_DestroyReusableAttr()
  self.arr = ReusableTable.CreateArray()
  if self.targetData:HasUnSaveAttri() then
    local cacheEnchants = self.targetData:GetCacheEnchants()
    for i = 1, #cacheEnchants do
      arrayPushBack(self.arr, self:GetCellDataFromEnchantInfo(cacheEnchants[i], cacheEnchants[i].serverIndex, true, true))
    end
  end
  local hasElement = #self.arr > 0
  if hasElement then
    local openBefore = self.enchantResult.activeSelf
    self.enchantResult:SetActive(hasElement)
    self.enchantResultCtl:ResetDatas(self.arr)
    local cells = self.enchantResultCtl:GetCells()
    local targetCell
    for i = 1, #cells do
      if self.curChooseResultID and cells[i].index == self.curChooseResultID then
        targetCell = cells[i]
        break
      end
    end
    if targetCell then
      self:OnClickResult(targetCell)
    elseif cells and cells[1] then
      self:OnClickResult(cells[1])
    end
    self.enchantResultGrid:Reposition()
    if not openBefore then
      self.enchantResultCtl:ResetPosition()
    end
    if self.enchantInfoBord.activeSelf then
      self:OnClickEnchantInfoCloseBtn()
    end
    if self.advancedChooseBord then
      self.advancedChooseBord:Hide()
    end
    self.resultNoneTip:SetActive(false)
  else
    self.resultNoneTip:SetActive(true)
  end
end

function EnchantNewView:UpdateCurrentEnchant()
  local flag = self.targetData and self.targetData:HasEnchant()
  if not self.targetData then
    self.enchantNoneTip:SetActive(false)
  else
    self.enchantNoneTip:SetActive(not self.targetData:HasEnchant())
  end
  if flag then
    local data = self:GetCellDataFromEnchantInfo(self.targetData.enchantInfo, nil, false)
    self.enchantCell:SetData(data)
    ReusableTable.DestroyAndClearTable(data)
    self.hasUnsavedAttri = self.targetData:HasUnSaveAttri()
    self.actionLabel.text = self.hasUnsavedAttri and ZhString.EnchantView_Re_Enchant or ZhString.EnchantView_Enchant
    local combineAttr = self.targetData.enchantInfo:GetCombineAttrMap()
    if combineAttr then
      self.enchantScrollView.contentPivot = UIWidget.Pivot.TopLeft
    else
      self.enchantScrollView.contentPivot = UIWidget.Pivot.Center
    end
  else
    self.enchantCell:SetData(nil)
  end
  self.enchantScrollView:ResetPosition()
  self.thirdAttrLockedShow = self.enchantCell:CheckLockActiveValid()
  self:ShowLockCostItem()
end

function EnchantNewView:UpdateFixedCost()
  if not self:HasTarget() then
    self:UpdateEmptyFixedCost()
    return
  end
  tableClear(self.fixedCostItemDatas)
  local itemCost, zenyCost, actDiscount, homeDiscount = blackSmith:GetEnchantCost(enchantType, self.targetData.staticData.Type)
  itemCost = itemCost and itemCost[1]
  local isTenPulls = self.tenPullsTog.value
  if itemCost and itemCost.num and itemCost.num > 0 then
    local itemCostData = ItemData.new(MaterialItemCell.MaterialType.Material, itemCost.itemid)
    itemCostData.num = bagIns:GetItemNumByStaticID(itemCost.itemid, enchantMatPackageCheck)
    itemCostData.discount = actDiscount or 100
    itemCostData.neednum = math.floor(itemCost.num * (isTenPulls and 10 or 1) * itemCostData.discount / 100 + 0.01)
    arrayPushBack(self.fixedCostItemDatas, itemCostData)
  end
  if zenyCost and 0 < zenyCost then
    local zenyData = ItemData.new(MaterialItemCell.MaterialType.Material, zenyId)
    zenyData.num = MyselfProxy.Instance:GetROB()
    zenyData.discount = actDiscount or homeDiscount or 100
    zenyData.neednum = math.floor(zenyCost * (isTenPulls and 10 or 1) * zenyData.discount / 100 + 0.01)
    arrayPushBack(self.fixedCostItemDatas, zenyData)
  end
  self.fixedCostCtl:ResetDatas(self.fixedCostItemDatas)
end

function EnchantNewView:UpdateEmptyFixedCost()
  self.fixedCostCtl:SetEmptyDatas(2)
  local cells = self.fixedCostCtl:GetCells()
  for i = 1, #cells do
    cells[i]:HideIcon()
  end
  self.fixedCostGrid:Reposition()
end

function EnchantNewView:UpdateAdvancedCost()
  local hasAdvanced = self:HasAdvancedCostSelected()
  self.advancedCostAddIcon:SetActive(not hasAdvanced)
  self.advancedCostContentGrid.gameObject:SetActive(hasAdvanced)
  if hasAdvanced then
    local isTenPulls = self.tenPullsTog.value
    local sId = self.selectedAdvancedCosts[1].staticData.id
    self.enchantCell:UpdateLockTog(nil ~= Game.EnchantMustBuff[sId])
    self.selectedAdvancedItemData = self.selectedAdvancedItemData or ItemData.new()
    self.selectedAdvancedItemData:ResetData(MaterialItemCell.MaterialType.Material, sId)
    self.selectedAdvancedItemData.num = bagIns:GetItemNumByStaticID(sId, enchantMatPackageCheck)
    self.selectedAdvancedItemData.neednum = self:GetTargetAdvancedEnchantCostNeedNum(sId) * (isTenPulls and 10 or 1)
    self.advancedCostCell:SetData(self.selectedAdvancedItemData)
  else
    self.enchantCell:UpdateLockTog(false)
  end
  self:UpdateLockCostCell()
  self.thirdAttrLockedShow = self.enchantCell:CheckLockActiveValid()
  self:ShowLockCostItem()
end

function EnchantNewView:UpdateEnchantInfo()
  if not self:HasTarget() then
    return
  end
  self.enchantInfoCtl:ResetDatas(self:GetEnchantInfoDatas())
end

function EnchantNewView:CheckFixedCost()
  if not self:HasTarget() then
    return false
  end
  local costEnough = true
  for _, item in pairs(self.fixedCostItemDatas) do
    if item.num < item.neednum then
      costEnough = false
      break
    end
  end
  return costEnough
end

function EnchantNewView:CheckAdvancedCost()
  if not self:HasTarget() then
    return false
  end
  if not self:HasAdvancedCostSelected() then
    return true
  end
  local item = self.selectedAdvancedItemData
  return item.num >= item.neednum
end

function EnchantNewView:CheckLockCostLimited()
  return self.thirdAttrLockedShow and self.thirdAttrLocked and self.lockCostItemData.num < self.lockCostItemData.neednum
end

function EnchantNewView:Enchant()
  if self.targetData:HasGoodCacheEnchantAttri() then
    MsgManager.ConfirmMsgByID(3060, function()
      self:_Enchant()
    end)
    return
  end
  self:_Enchant()
end

function EnchantNewView:_Enchant()
  FunctionSecurity.Me():EnchantingEquip(function(self)
    self:Show(self.collider)
    self:SetActionBtnActive(false)
    self:PlayUIEffect(EffectMap.UI.EquipReplaceNew, self.effContainer, true)
    self:PlayUISound(AudioMap.UI.EnchantSuc)
    self.curChooseResultID = nil
    tickManager:CreateOnceDelayTick(800, self.CallEnchant, self)
  end, self)
end

function EnchantNewView:TryShowEnchantResult()
  self.enchantResult:SetActive(self.hasUnsavedAttri or false)
  self:OnClickEnchantInfoCloseBtn()
end

function EnchantNewView:CallEnchant()
  if self:HasTarget() then
    if self.clickTimeStamp and self.clickTimeStamp + 1 > ServerTime.CurServerTime() / 1000 then
      redlog("点太快！")
      return
    end
    local isImprove, mustBuffItem = false
    if self:HasAdvancedCostSelected() then
      for _, d in pairs(self:GetTargetAdvancedEnchantCostConfig()) do
        if d.itemid == self.selectedAdvancedCosts[1].staticData.id then
          if d.isMustBuff then
            mustBuffItem = d.itemid
            break
          end
          isImprove = true
          break
        end
      end
    end
    self.clickTimeStamp = ServerTime.CurServerTime() / 1000
    local realLock = self.thirdAttrLocked and self.thirdAttrLockedShow and self.lockCostItemData.num >= self.lockCostItemData.neednum
    ServiceItemProxy.Instance:CallEnchantEquip(enchantType, self.targetData.id, isImprove, mustBuffItem, self.tenPullsTog.value and 10 or 1, realLock)
    if self.enchantResult.activeSelf then
      self.enchantResultCtl:ResetPosition()
    end
  end
end

function EnchantNewView:SetActionBtnActive(isActive)
  self.actionBtnActive = isActive and true or false
  self:UpdateActionBtnActive()
end

local inactiveLabelColor, activeLabelEffectColor, inactiveLabelEffectColor = LuaColor.New(0.9372549019607843, 0.9372549019607843, 0.9372549019607843), LuaColor.New(0.6862745098039216, 0.3764705882352941, 0.10588235294117647), LuaColor.New(0.5019607843137255, 0.5019607843137255, 0.5019607843137255)

function EnchantNewView:UpdateActionBtnActive()
  local isActive = self.actionBtnActive
  self.actionBgSp.CurrentState = isActive and 1 or 0
  self.actionLabel.color = isActive and ColorUtil.NGUIWhite or inactiveLabelColor
  self.actionLabel.effectColor = isActive and activeLabelEffectColor or inactiveLabelEffectColor
end

function EnchantNewView:HasTarget()
  return self.targetData ~= nil and self.targetData.staticData ~= nil
end

function EnchantNewView:CheckTargetIsGvgEquip()
  if not self:HasTarget() then
    return
  end
  return ItemUtil.IsGVGSeasonEquip(self.targetData.staticData.id)
end

function EnchantNewView:HasCacheRefreshAttr()
  if not self:HasTarget() then
    return
  end
  return self.targetData:HasCacheEnchantRefreshAttr()
end

function EnchantNewView:TryCompareEnchantAttr()
  if not self.targetData or not self.curChooseResultID then
    return
  end
  local curChooseEnchantInfo
  local cacheEnchants = self.targetData:GetCacheEnchants()
  for i = 1, #cacheEnchants do
    if cacheEnchants[i].serverIndex == self.curChooseResultID then
      curChooseEnchantInfo = cacheEnchants[i]
    end
  end
  if not curChooseEnchantInfo then
    return
  end
  local curCombineSortValue = self.targetData.enchantInfo and self.targetData.enchantInfo:GetCombineEffectSortValue()
  local chooseCombineSortValue = curChooseEnchantInfo:GetCombineEffectSortValue()
  if curCombineSortValue > chooseCombineSortValue then
    return true
  end
  return false
end

function EnchantNewView:HasAdvancedCostSelected()
  return #self.selectedAdvancedCosts > 0
end

local tipOffset = {-210, 180}

function EnchantNewView:ShowItemTip(cell)
  local data = cell.data
  if not BagItemCell.CheckData(data) then
    return
  end
  self.tipData.itemdata = data
  EnchantNewView.super.ShowItemTip(self, self.tipData, cell.icon, NGUIUtil.AnchorSide.Left, tipOffset)
end

function EnchantNewView:UpdateLockCostCell()
  self.staticLockCostId = self.staticLockCostId or GameConfig.EnchantFunc.lockItem[1]
  self.staticLockCostNum = self.staticLockCostNum or GameConfig.EnchantFunc.lockItem[2]
  self.lockCostItemData = self.lockCostItemData or ItemData.new()
  self.lockCostItemData:ResetData(MaterialItemCell.MaterialType.Material, self.staticLockCostId)
  self.lockCostItemData.num = bagIns:GetItemNumByStaticID(self.staticLockCostId, enchantMatPackageCheck)
  self.lockCostItemData.neednum = self.staticLockCostNum * (self.tenPullsTog.value and 10 or 1)
  self.lockCostCell:SetData(self.lockCostItemData)
end

function EnchantNewView:ShowLockCostItem()
  self.lockCostCellParent:SetActive(self.thirdAttrLockedShow == true and self.thirdAttrLocked == true)
  self.advancedCostContentGrid:Reposition()
end
