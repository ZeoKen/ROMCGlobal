autoImport("ItemNewCell")
autoImport("EquipNewChooseBord")
autoImport("MaterialItemNewCell")
autoImport("EquipMemoryAttrCell")
autoImport("EquipMemoryAttrCombineCell")
autoImport("EquipMemoryAttrResultBord")
autoImport("EquipMemoryFullBodyChangeCell")
EquipMemoryAttrResetView = class("EquipMemoryAttrResetView", ContainerView)
EquipMemoryAttrResetView.ViewType = UIViewType.NormalLayer
autoImport("EquipMemoryCombineView")
EquipMemoryAttrResetView.BrotherView = EquipMemoryCombineView
local arrayClear, arrayPushBack = TableUtility.ArrayClear, TableUtility.ArrayPushBack
local bagIns, lotteryIns, shopIns, tickManager, pictureMgr
local destroyAndClearTable = ReusableTable.DestroyAndClearTable
local createTable = ReusableTable.CreateTable
local enchantPackageCheck = {
  2,
  20,
  1
}
local bg3TexName = "Equipmentopen_bg_bottom_16"
local enchantNewCell_PrefabPath = "cell/EnchantCell"
local resetMatPackageCheck = GameConfig.PackageMaterialCheck.EquipMemory_levelup
local fixedCostTipOffset = {-210, 180}
local inactiveLabelColor = LuaColor.New(0.9372549019607843, 0.9372549019607843, 0.9372549019607843)
local inactiveLabelEffectColor = LuaColor.New(0.5019607843137255, 0.5019607843137255, 0.5019607843137255)
local activeLabelEffectColor = LuaColor.New(0.6862745098039216, 0.3764705882352941, 0.10588235294117647)
local againActiveLabelEffectColor = LuaColor.New(0.6862745098039216, 0.3764705882352941, 0.10588235294117647)
local actionBtnLabs, quickBtnLabs
local _PACKAGECHECK = GameConfig.PackageMaterialCheck.EquipMemory_levelup or {1, 22}
local optionalBtnIntervalTime = 1

function EquipMemoryAttrResetView:Init()
  self:InitData()
  self:FindObjs()
  self:InitView()
  self:AddListenEvts()
  self:AddEvts()
end

function EquipMemoryAttrResetView:InitData()
  actionBtnLabs = {
    ZhString.EquipMemory_AttrReset2,
    ZhString.EquipMemory_AttrRandomReset
  }
  quitBtnLabs = {
    ZhString.EquipMemory_CancelManualChoose,
    ZhString.EquipMemory_ClearResult
  }
  bagIns, lotteryIns, shopIns, pictureMgr = BagProxy.Instance, LotteryProxy.Instance, HappyShopProxy.Instance, PictureManager.Instance
  tickManager = TimeTickManager.Me()
  self.tipData = {}
  self.isCombine = self.viewdata.viewdata and self.viewdata.viewdata.isCombine
end

function EquipMemoryAttrResetView:FindObjs()
  self.mainBoard = self:FindGO("MainBoard")
  self.mainBoardTrans = self.mainBoard.transform
  self.closeButton = self:FindGO("CloseButton")
  self.title = self:FindComponent("Title", UILabel, self.mainBoard)
  self.actionBgSp = self:FindComponent("ActionBtn", UIMultiSprite, self.mainBoard)
  self.actionLabel = self:FindComponent("ActionLabel", UILabel, self.actionBgSp.gameObject)
  self.actionBtn_BoxCollider = self:FindComponent("ActionBtn", BoxCollider, self.mainBoard)
  self.actionLabel.text = actionBtnLabs[1]
  self.emptyTip = self:FindComponent("EmptyTip", UILabel, self.mainBoard)
  self.emptyTip.text = ZhString.EquipMemory_AttrReset_EmptyTip
  local choosePanel = self:FindGO("ChoosePanel")
  self.chooseContainer = self:FindGO("ChooseContainer", choosePanel)
  self.targetCellObj = self:FindGO("TargetCell", self.mainBoard)
  self.bg3Tex = self:FindComponent("Bg3", UITexture, self.targetCellObj)
  self.targetCellAddIcon = self:FindGO("TargetCellAddIcon", self.targetCellObj)
  self.targetCellContent = self:FindGO("TargetCellContent", self.targetCellObj)
  self.targetIcon = self:FindComponent("Icon", UISprite, self.targetCellContent)
  self.removeTargetObj = self:FindGO("DeleteIcon", self.targetCellContent)
  self.actionBoard = self:FindGO("ActionBoard", self.mainBoard)
  self.targetName = self:FindComponent("ItemName", UILabel, self.actionBoard)
  self.fixedCostGO = self:FindGO("FixedCost", self.actionBoard)
  self.fixedCostGrid = self:FindComponent("FixedCostGrid", UIGrid, self.actionBoard)
  self.checkBtn = self:FindComponent("CheckBtn", UIToggle, self.mainBoard)
  self.checkBtn.value = false
  self.checkBtn.gameObject:SetActive(false)
  self.memoryPreview = self:FindGO("MemoryPreview", choosePanel)
  local memoryPreviewTitle = self:FindComponent("Title", UILabel, self.memoryPreview)
  memoryPreviewTitle.text = ZhString.EnchantThirdAttrReset_ResultTitle
  self:Hide(self.memoryPreview)
  self.memoryPreviewScrollView = self:FindComponent("ResultScrollView", UIScrollView, self.memoryPreview)
  self.memoryPreviewResultGrid = self:FindComponent("ResultGrid", UITable, self.memoryPreview)
  self.saveBtn = self:FindGO("SaveBtn", self.memoryPreview)
  self.quitBtn = self:FindGO("QuitBtn", self.memoryPreview)
  self.quitBtn_Label = self:FindGO("QuitLabel", self.quitBtn):GetComponent(UILabel)
  self.effContainer = self:FindGO("EffectContainer")
  self:PlayUIEffect(EffectMap.UI.EquipMemory_BG, self:FindGO("RightBg"), nil, function(obj, args, assetEffect)
    local effect = assetEffect
    effect:ResetLocalPositionXYZ(-2.93, 159.16, 0)
    local ps = effect.effectObj:GetComponentsInChildren(ParticleSystem, true)
    for i = 1, #ps do
      ps[i].gameObject:SetActive(false)
      ps[i].gameObject:SetActive(true)
    end
  end)
  self.changeRoot = self:FindGO("Change", self.memoryPreview)
  self.memoryChangeGrid = self:FindGO("ChangeGrid", self.memoryPreview):GetComponent(UIGrid)
end

function EquipMemoryAttrResetView:OnEnter()
  if self.npcdata then
    local rootTrans = self.npcdata.assetRole.completeTransform
    self:CameraFocusAndRotateTo(rootTrans, CameraConfig.SwingMachine_ViewPort, CameraConfig.SwingMachine_Rotation)
  else
    self:CameraFocusToMe()
  end
  if self.viewdata.viewdata.itemdata and self.viewdata.viewdata.itemdata.equipMemoryData then
    self:OnClickChooseBordCell(self.viewdata.viewdata.itemdata)
  else
    self:OnRemoveTarget(true)
  end
end

function EquipMemoryAttrResetView:OnExit()
  EquipMemoryAttrResetView.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
  self:CameraReset()
end

function EquipMemoryAttrResetView:checkChooseBoardValid(itemdata)
  if itemdata and itemdata.equipMemoryData then
    return true
  end
  return false
end

function EquipMemoryAttrResetView:GetChooseBordDataFunc()
  local _BagProxy = BagProxy.Instance
  local result = {}
  local equipedMemory = EquipMemoryProxy.Instance.equipPosData
  if equipedMemory and not TableUtil.TableIsEmpty(equipedMemory) then
    for _pos, _memoryData in pairs(equipedMemory) do
      local _itemData = ItemData.new("EquipedMemory", _memoryData.staticId)
      _itemData.equipMemoryData = _memoryData:Clone()
      _itemData.equiped = 1
      _itemData.sitePos = _pos
      table.insert(result, _itemData)
    end
  end
  for i = 1, #_PACKAGECHECK do
    local items = _BagProxy:GetBagByType(_PACKAGECHECK[i]):GetItems()
    for j = 1, #items do
      if items[j].equipMemoryData then
        table.insert(result, items[j])
      end
    end
  end
  table.sort(result, function(l, r)
    local l_equiped = l.equiped or 0
    local r_equiped = r.equiped or 0
    if l_equiped ~= r_equiped then
      return l_equiped > r_equiped
    end
    local l_power = l.equipMemoryData and l.equipMemoryData:GetValuePower() or 0
    local r_power = r.equipMemoryData and r.equipMemoryData:GetValuePower() or 0
    if l_power ~= r_power then
      return l_power > r_power
    end
    return l.staticData.id > r.staticData.id
  end)
  return result
end

function EquipMemoryAttrResetView:InitView()
  self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(self.isCombine and -50 or 0)
  self.closeButton:SetActive(not self.isCombine)
  self.targetChooseBord = EquipChooseBord_CombineSize.new(self.chooseContainer, function()
    return self:GetChooseBordDataFunc()
  end)
  self.targetChooseBord:AddEventListener(EquipChooseBord.ChooseItem, self.OnClickChooseBordCell, self)
  self.targetChooseBord:SetTypeLabelTextGetter(ItemUtil.GetMemoryTag)
  self.targetChooseBord:SetBordTitle(ZhString.EquipMemory_ChooseMemory)
  self.targetChooseBord:SetNoneTip(ZhString.EquipMemory_NoResult)
  self.targetChooseBord.needSetCheckValidFuncOnShow = true
  self.targetChooseBord:Show(true, nil, nil, self.checkChooseBoardValid, self, ZhString.EnchantThirdAttrReset_InValid)
  self.topTips = self:FindGO("TopTips"):GetComponent(UIWidget)
  self.showDetailBtn = self:FindGO("ShowDetailBtn")
  self.showDetailBtn_Sprite = self.showDetailBtn:GetComponent(UISprite)
  self:AddClickEvent(self.showDetailBtn, function()
    self.extended = not self.extended
    self:RefreshMemoryAttrExtend()
  end)
  self.memoryScrollViewBG = self:FindGO("ScrollViewBg"):GetComponent(UISprite)
  self.memoryScrollViewBG_TweenHeight = self:FindGO("ScrollViewBg"):GetComponent(TweenHeight)
  self.memoryAttrScrollView = self:FindGO("MemoryAttrScrollView"):GetComponent(UIScrollView)
  self.memoryAttrGrid = self:FindGO("MemoryAttrGrid"):GetComponent(UITable)
  self.memoryListCtrl = UIGridListCtrl.new(self.memoryAttrGrid, EquipMemoryAttrCell, "EquipMemoryAttrCellType4")
  self.memoryListCtrl:AddEventListener(MouseEvent.MouseClick, self.handleChooseAttr, self)
  self.fixedCostCtl = ListCtrl.new(self.fixedCostGrid, MaterialItemCell, "MaterialItemCell")
  self.fixedCostCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickFixedCostItemTip, self)
  self.tipData = {
    itemdata = nil,
    funcConfig = _EmptyTable,
    ignoreBounds = {
      self.fixedCostGrid.gameObject
    }
  }
  self.fixedCostItemDatas = {}
  self.costTip = self:FindGO("CostTip")
  self.memoryPreviewCtrl = UIGridListCtrl.new(self.memoryPreviewResultGrid, EquipMemoryAttrCellType2, "EquipMemoryAttrCellType2")
  self.memoryPreviewCtrl:AddEventListener(MouseEvent.MouseClick, self.handleChooseResetResult, self)
  self.memoryChangeCtrl = UIGridListCtrl.new(self.memoryChangeGrid, EquipMemoryFullBodyChangeCell, "EquipMemoryFullBodyChangeCell")
  self.attrResultBord = EquipMemoryAttrResultBord.new(self.chooseContainer)
  self.attrResultBord:Hide()
  self.attrBrifBtn = self:FindGO("AttrBrifBtn")
  self.extended = false
end

function EquipMemoryAttrResetView:OnClickResetResult(cell)
  local index = cell.refreshIndex
  self.chooseResetResultIndex = cell.refreshIndex
  self:UpdateEnchantAttrRefreshIndex()
end

function EquipMemoryAttrResetView:UpdateEnchantAttrRefreshIndex()
  local cells = self.enchantResetResultCtl:GetCells()
  for i = 1, #cells do
    cells[i]:SetChooseId(self.chooseResetResultIndex)
  end
end

function EquipMemoryAttrResetView:OnClickFixedCostItemTip(cell)
  local data = cell.data
  if not BagItemCell.CheckData(data) then
    return
  end
  self.tipData.itemdata = data
  EquipMemoryAttrResetView.super.ShowItemTip(self, self.tipData, cell.icon, NGUIUtil.AnchorSide.Left, fixedCostTipOffset)
end

function EquipMemoryAttrResetView:OnClickChooseBordCell(data)
  self:SetTargetCell(data)
end

function EquipMemoryAttrResetView:SetTargetCell(data)
  if not BagItemCell.CheckData(data) and data.staticData ~= nil then
    data = nil
  end
  local curEnchantItemId = data and data.id or nil
  self.targetData = data
  self.targetName.text = data:GetName()
  self:UpdateViewByTargetCell()
  if data then
    self:sendNotification(ItemEvent.EquipChooseSuccess, data)
  end
end

function EquipMemoryAttrResetView:HasTarget()
  return nil ~= self.targetData and nil ~= self.targetData.staticData
end

function EquipMemoryAttrResetView:OnRemoveTarget()
  self.targetData = nil
  self:UpdateViewByTargetCell()
  self.targetChooseBord:Show(true, nil, nil, self.checkChooseBoardValid, self, ZhString.EnchantThirdAttrReset_InValid)
  self.targetChooseBord:SetChoose(nil)
  self:Hide(self.memoryPreview)
  self.attrResultBord:Hide()
end

function EquipMemoryAttrResetView:AddEvts()
  self:AddClickEvent(self.targetCellObj, function()
    if self:HasTarget() then
      return
    end
    if self.targetChooseBord:ActiveSelf() then
      return
    end
    self.targetChooseBord:Show(true, nil, nil, self.checkChooseBoardValid, self, ZhString.EnchantThirdAttrReset_InValid)
    self.attrResultBord:Hide()
  end)
  self:AddClickEvent(self.removeTargetObj, function()
    self:OnRemoveTarget()
  end)
  self:AddClickEvent(self.actionBgSp.gameObject, function()
    self:OnClickActionBtn()
  end)
  self:AddClickEvent(self.saveBtn, function()
    if self:IsRandomResult() then
      self:_OptionAttrResult(true)
    else
      xdlog("自选模式二次提示")
      if not self.resetCostEnough then
        MsgManager.ShowMsgByID(3703)
        return
      end
      FunctionSecurity.Me():NormalOperation(function()
        local cost = {}
        for i = 1, #self.fixedCostItemDatas do
          local _itemData = ItemData.new("CostItem", self.fixedCostItemDatas[i].staticData.id)
          _itemData.num = self.fixedCostItemDatas[i].neednum
          table.insert(cost, _itemData)
        end
        UIUtil.PopUpItemConfirmYesNoView("", ZhString.EquipMemory_ManualSaveConfirm, cost, function()
          self:_OptionAttrResult(true)
        end, nil, nil, ZhString.UniqueConfirmView_Confirm, ZhString.UniqueConfirmView_CanCel)
      end)
    end
  end)
  self:AddClickEvent(self.quitBtn, function()
    if self:IsRandomResult() then
      xdlog("随机结果时  取消缓存结果")
      self:_OptionAttrResult(false)
    else
      xdlog("通常情况时，隐藏自选界面")
      self:Hide(self.memoryPreview)
      self:updateFixedCostItems()
      self:SetActionBtnActive()
    end
  end)
  self:AddClickEvent(self.checkBtn.gameObject, function()
    self:updateFixedCostItems()
    self:SetActionBtnActive()
    self:RefreshAttrChoose()
  end)
  self:AddButtonEvent("AttrBrifBtn", function()
    local staticID = self.targetData and self.targetData.staticData.id
    local staticData = staticID and Table_ItemMemory[staticID]
    local groups = {}
    if staticData then
      local targetStaticData = staticData
      if staticData.UpgradeID then
        local upgradeStaticData = Table_ItemMemory[staticData.UpgradeID]
        if upgradeStaticData then
          targetStaticData = upgradeStaticData
        end
      end
      local randomAttr = targetStaticData.RandomAttr
      for _, info in pairs(randomAttr) do
        table.insert(groups, info.group)
      end
    end
    self.attrResultBord:Show()
    self.attrResultBord:UpdateValidAttrs(groups)
  end)
  TipsView.Me():TryShowGeneralHelpByHelpId(32615, self:FindGO("HelpButton"))
end

function EquipMemoryAttrResetView:_OptionAttrResult(save)
  if resetClickTime and UnityUnscaledTime - resetClickTime < optionalBtnIntervalTime then
    MsgManager.ShowMsgByID(49)
    return
  end
  if not self:HasTarget() then
    return
  end
  local itemid = self.targetData.id
  helplog("[记忆确认] CallProcessEnchantRefreshAttr save|itemid|index ", save, itemid, self.chooseResetResultIndex)
  self.manualOption = true
  if not self.chosenEffectId then
    redlog("没有选择词条  return")
    return
  end
  if not self.targetEffectIndex or self.targetEffectIndex == 0 then
    redlog("没有选择词条就尝试重置")
    return
  end
  FunctionSecurity.Me():NormalOperation(function()
    local _targetEffect = self.targetEffectIndex - 1
    if self.targetData.sitePos then
      xdlog("身上装备的", self.targetData.sitePos)
      ServiceItemProxy.Instance:CallMemoryEffectOperItemCmd(save and SceneItem_pb.EMEMORY_EFFECT_OPER_SAVE or SceneItem_pb.EMEMORY_EFFECT_OPER_CLEAR, self.targetData.sitePos, nil, _targetEffect, self.chosenEffectId)
    else
      xdlog("普通记忆本体", self.targetData.id, self.chosenEffectId)
      ServiceItemProxy.Instance:CallMemoryEffectOperItemCmd(save and SceneItem_pb.EMEMORY_EFFECT_OPER_SAVE or SceneItem_pb.EMEMORY_EFFECT_OPER_CLEAR, nil, self.targetData.id, _targetEffect, self.chosenEffectId)
    end
  end)
end

function EquipMemoryAttrResetView:OnClickActionBtn()
  if not self:HasTarget() then
    return
  end
  if self:HasRefreshAttr() then
    self:_UpdateMemoryPreviewResult()
    self:updateFixedCostItems()
    self:SetActionBtnActive()
    return
  end
  if not self.resetCostEnough then
    MsgManager.ShowMsgByID(8)
    return
  end
  if resetClickTime and UnityUnscaledTime - resetClickTime < optionalBtnIntervalTime then
    return
  end
  local _actionFunc = function()
    local memoryData = self.targetData.equipMemoryData
    local equipGuid = memoryData.itemGuid
    xdlog("请求重置", equipGuid, self.targetData.id, self.targetEffectIndex)
    if not self.targetEffectIndex or self.targetEffectIndex == 0 then
      redlog("词条选择错误")
      return
    end
    FunctionSecurity.Me():NormalOperation(function()
      local isRand = false
      if self.targetEffectIndex <= 2 then
        isRand = false
      else
        isRand = self.checkBtn.value
      end
      local targetOperEffectIndex = self.targetEffectIndex ~= 0 and self.targetEffectIndex - 1
      if self.targetData.sitePos then
        xdlog("请求刷新装备中的记忆", self.targetData.sitePos, targetOperEffectIndex, self.checkBtn.value)
        ServiceItemProxy.Instance:CallMemoryEffectOperItemCmd(1, self.targetData.sitePos, nil, self.targetEffectIndex, targetOperEffectIndex, isRand)
      else
        xdlog("请求刷新普通记忆", self.targetData.id, targetOperEffectIndex, self.checkBtn.value)
        ServiceItemProxy.Instance:CallMemoryEffectOperItemCmd(1, nil, equipGuid, self.targetEffectIndex, targetOperEffectIndex, isRand)
      end
      resetClickTime = UnityUnscaledTime
      self:PlayUIEffect(EffectMap.UI.EquipReplaceNew, self.effContainer, true)
      self:PlayUISound(AudioMap.UI.EnchantThireResetSuc)
    end)
  end
  FunctionSecurity.Me():NormalOperation(function()
    _actionFunc()
  end)
end

function EquipMemoryAttrResetView:AddListenEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.OnItemUpdate)
  self:AddListenEvt(ItemEvent.MemoryUpdate, self.OnItemUpdate)
  self:AddListenEvt(ItemEvent.EquipUpdate, self.OnItemUpdate)
  self:AddListenEvt(ServiceEvent.ItemUpdateMemoryPosItemCmd, self.OnItemUpdate)
end

function EquipMemoryAttrResetView:OnItemUpdate()
  if self.targetData and self.targetData.sitePos then
    local posData = EquipMemoryProxy.Instance:GetPosData(self.targetData.sitePos)
    if posData then
      local _itemData = ItemData.new("EquipedMemory", posData.staticId)
      _itemData.equipMemoryData = posData:Clone()
      _itemData.equiped = 1
      _itemData.sitePos = self.targetData.sitePos
      self:SetTargetCell(_itemData)
    end
  else
    local guid = self.targetData and self.targetData.id
    local item = guid and bagIns:GetItemByGuid(guid)
    if item and item.equipMemoryData then
      if not item:IsMemory() then
        local _itemData = ItemData.new(item.id, item.equipMemoryData.staticId)
        _itemData:Copy(item)
        _itemData.embeded = true
        _itemData.equiped = item.equiped
        self:SetTargetCell(_itemData)
      else
        self:SetTargetCell(item)
      end
    end
  end
  if self.manualOption and self.memoryPreview.activeSelf then
    self:Hide(self.memoryPreview)
    self.manualOption = nil
    self:SetActionBtnActive()
  end
end

local iconScale = 1

function EquipMemoryAttrResetView:UpdateViewByTargetCell()
  if not self:HasTarget() then
    self:Hide(self.actionBoard)
    self:Hide(self.targetCellContent)
    self:Show(self.emptyTip)
    self:Hide(self.attrBrifBtn)
    self:Show(self.targetCellAddIcon)
    self:Hide(self.checkBtn.gameObject)
    self:SetActionBtnActive(false)
    return
  end
  self:Hide(self.emptyTip)
  self:Show(self.attrBrifBtn)
  self:Hide(self.targetCellAddIcon)
  self:Show(self.actionBoard)
  self:Show(self.targetCellContent)
  self:Show(self.checkBtn.gameObject)
  local memoryStaticID = self.targetData.equipMemoryData.staticId
  IconManager:SetItemIcon(Table_Item[memoryStaticID].Icon, self.targetIcon)
  self.targetIcon:MakePixelPerfect()
  self.targetIcon.transform.localScale = LuaGeometry.GetTempVector3(iconScale, iconScale, iconScale)
  self:updateTargetMemoryInfo()
  self:updateFixedCostItems()
  self:SetActionBtnActive()
  if self.memoryPreview.activeSelf then
    self:_UpdateMemoryPreviewResult()
  end
  self.targetChooseBord:Hide()
end

function EquipMemoryAttrResetView:updateTargetMemoryInfo()
  local memoryData = self.targetData and self.targetData.equipMemoryData
  if not memoryData then
    redlog("没有记忆属性")
  end
  local maxAttrCount = memoryData.maxAttrCount or 0
  local attrs = memoryData.memoryAttrs
  local firstValidAttrIndex = 0
  local result = {}
  for i = 1, maxAttrCount do
    if attrs[i] and attrs[i].previewid ~= nil and 0 < #attrs[i].previewid then
      local _tempData = {
        id = attrs[i].id
      }
      local curExcess = memoryData.excess_lv or 0
      local excessCfg = GameConfig and GameConfig.EquipMemory and GameConfig.EquipMemory.Excess and GameConfig.EquipMemory.Excess.LvIndexUnlock
      if type(excessCfg) == "table" and curExcess and 0 < curExcess then
        for stageKey, mappedKey in pairs(excessCfg) do
          local slotIndex = type(mappedKey) == "number" and math.floor(mappedKey / 10) or nil
          if slotIndex and slotIndex == i then
            if stageKey <= curExcess then
              _tempData.excess_lv = curExcess
            end
            break
          end
        end
      end
      if i == maxAttrCount then
        _tempData.text = ZhString.EquipMemory_NotChosen
        _tempData.CanUnlock = true
        if attrs[i].id == 0 then
          firstValidAttrIndex = i
        end
      end
      table.insert(result, _tempData)
      if firstValidAttrIndex == 0 then
        firstValidAttrIndex = i
      end
    else
      local _tempData = {
        id = 0,
        unlockLv = i * 10,
        unlockTip = ZhString.EquipMemory_AttrResetUnlockTip
      }
      table.insert(result, _tempData)
    end
  end
  self.memoryListCtrl:ResetDatas(result)
  self:RefreshMemoryAttrExtend()
  if not self.targetEffectIndex then
    if firstValidAttrIndex == 0 then
      local hasCacheAttr, cacheIndex = self.targetData.equipMemoryData:HasCacheRefreshAttr()
      if hasCacheAttr then
        self.targetEffectIndex = cacheIndex
      else
        self.targetEffectIndex = firstValidAttrIndex
      end
    else
      self.targetEffectIndex = firstValidAttrIndex
    end
  elseif maxAttrCount < self.targetEffectIndex then
    self.targetEffectIndex = firstValidAttrIndex
  elseif not attrs[self.targetEffectIndex] then
    self.targetEffectIndex = firstValidAttrIndex ~= 0 and firstValidAttrIndex or 0
  end
  self.checkBtn.gameObject:SetActive(false)
  self:RefreshAttrChoose()
  if self.targetEffectIndex == 0 then
    self:SetActionBtnActive(false)
  end
end

function EquipMemoryAttrResetView:RefreshMemoryAttrExtend()
  self.showDetailBtn_Sprite.flip = self.extended and 2 or 0
  local size = NGUIMath.CalculateRelativeWidgetBounds(self.memoryAttrGrid.transform)
  local height = size.size.y + 5
  if height < 128 then
    self.extended = false
    self.showDetailBtn:SetActive(false)
  else
    self.showDetailBtn:SetActive(true)
  end
  if self.extended and 127 < height then
    height = height + 40
  else
    height = 167
  end
  self.memoryScrollViewBG.height = height
  local panel = self.memoryAttrScrollView.panel
  panel:UpdateAnchors()
  self.memoryAttrScrollView:ResetPosition()
  local widget = self.attrBrifBtn:GetComponent(UISprite)
  widget:UpdateAnchors()
  self.topTips:UpdateAnchors()
end

function EquipMemoryAttrResetView:updateFixedCostItems()
  if not self:HasTarget() then
    return
  end
  arrayClear(self.fixedCostItemDatas)
  if not self.targetEffectIndex or self.targetEffectIndex == 0 then
    redlog("无可选择词条")
    self.resetCostEnough = false
    self.fixedCostGO:SetActive(false)
    return
  end
  self.fixedCostGO:SetActive(true)
  self.resetCostEnough = true
  if not self:IsRandomResult() and not self.memoryPreview.activeSelf then
    self.resetCostEnough = false
    self.fixedCostCtl:RemoveAll()
    self.costTip:SetActive(true)
    return
  end
  local config = GameConfig.EquipMemory and GameConfig.EquipMemory.SingleCost
  if config then
    local costConfig
    if self.targetData.equipMemoryData:CheckHasPreviewAttr(self.targetEffectIndex) then
      if self.targetEffectIndex == 4 and self.targetData.equipMemoryData:GetAttrID(self.targetEffectIndex) == 0 then
        xdlog("首次免费！")
        costConfig = {}
      else
        costConfig = config and config.save
      end
    else
      costConfig = config and config.rand
    end
    if costConfig then
      xdlog("index", self.targetEffectIndex)
      costConfig = costConfig[self.targetEffectIndex]
      if costConfig then
        local itemCostData = ItemData.new(MaterialItemCell.MaterialType.Material, costConfig[1])
        if costConfig[1] == GameConfig.MoneyId.Zeny then
          itemCostData.num = MyselfProxy.Instance:GetROB()
        else
          itemCostData.num = bagIns:GetItemNumByStaticID(costConfig[1], resetMatPackageCheck)
        end
        itemCostData.neednum = costConfig[2]
        if itemCostData.num < itemCostData.neednum then
          self.resetCostEnough = false
        end
        arrayPushBack(self.fixedCostItemDatas, itemCostData)
      else
        redlog("no data")
      end
    end
  end
  if self.fixedCostItemDatas and #self.fixedCostItemDatas > 0 then
    self.fixedCostCtl:ResetDatas(self.fixedCostItemDatas)
    self.costTip:SetActive(false)
  else
    self.fixedCostCtl:RemoveAll()
  end
end

function EquipMemoryAttrResetView:_UpdateMemoryPreviewResult()
  local hasCacheRefreshAttr, cacheIndex
  if self.targetData.equipMemoryData then
    hasCacheRefreshAttr, cacheIndex = self.targetData.equipMemoryData:HasCacheRefreshAttr()
  end
  if not hasCacheRefreshAttr then
    redlog("没有候选刷新数据")
    self:Hide(self.memoryPreview)
    return
  end
  local openBefore = self.memoryPreview.activeSelf
  xdlog("刷新中的条目", cacheIndex, self.targetEffectIndex)
  local attrs = self.targetData.equipMemoryData.memoryAttrs
  local chooseList = {}
  if self.targetEffectIndex and attrs[self.targetEffectIndex] then
    local previewids = attrs[self.targetEffectIndex].previewid
    if not previewids or #previewids == 0 then
      redlog("当前选择的词条不存在预览id")
      self:Hide(self.memoryPreview)
      return
    else
      local curAttrID = attrs[self.targetEffectIndex].id
      local passExcess
      do
        local curExcess = self.targetData.equipMemoryData.excess_lv or 0
        local excessCfg = GameConfig and GameConfig.EquipMemory and GameConfig.EquipMemory.Excess and GameConfig.EquipMemory.Excess.LvIndexUnlock
        if type(excessCfg) == "table" and curExcess and 0 < curExcess then
          for stageKey, mappedKey in pairs(excessCfg) do
            local slotIndex = type(mappedKey) == "number" and math.floor(mappedKey / 10) or nil
            if slotIndex and slotIndex == self.targetEffectIndex then
              if stageKey <= curExcess then
                passExcess = curExcess
              end
              break
            end
          end
        end
      end
      for i = 1, #previewids do
        if previewids[i] ~= curAttrID then
          local _tempData = {
            id = previewids[i]
          }
          if passExcess then
            _tempData.excess_lv = passExcess
          end
          table.insert(chooseList, _tempData)
        end
      end
    end
  elseif cacheIndex and attrs[cacheIndex] then
    local previewids = attrs[cacheIndex].previewid
    if previewids and 0 < #previewids then
      local passExcess
      do
        local curExcess = self.targetData.equipMemoryData.excess_lv or 0
        local excessCfg = GameConfig and GameConfig.EquipMemory and GameConfig.EquipMemory.Excess and GameConfig.EquipMemory.Excess.LvIndexUnlock
        if type(excessCfg) == "table" and curExcess and 0 < curExcess then
          for stageKey, mappedKey in pairs(excessCfg) do
            local slotIndex = type(mappedKey) == "number" and math.floor(mappedKey / 10) or nil
            if slotIndex and cacheIndex and slotIndex == cacheIndex then
              if stageKey <= curExcess then
                passExcess = curExcess
              end
              break
            end
          end
        end
      end
      for i = 1, #previewids do
        local _tempData = {
          id = previewids[i]
        }
        if passExcess then
          _tempData.excess_lv = passExcess
        end
        table.insert(chooseList, _tempData)
      end
    end
  end
  self.targetChooseBord:Hide()
  self:Show(self.memoryPreview)
  self.attrResultBord:Hide()
  self.memoryPreviewCtrl:ResetDatas(chooseList)
  local cells = self.memoryPreviewCtrl:GetCells()
  if cells and 0 < #cells then
    local hasChosen = false
    for i = 1, #cells do
      if cells[i].data and cells[i].data.id == self.chosenEffectId then
        hasChosen = true
        cells[i]:SetChoose(true)
      else
        cells[i]:SetChoose(false)
      end
    end
    if not hasChosen and cells[1] then
      cells[1]:SetChoose(true)
      self.chosenEffectId = cells[1].data.id
      xdlog("默认选择", self.chosenEffectId)
    end
  end
  if not openBefore then
    self.memoryPreviewScrollView:ResetPosition()
  end
  self:SetActionBtnActive()
end

function EquipMemoryAttrResetView:HasRefreshAttr()
  if not self:HasTarget() then
    return
  end
  return self.targetData.equipMemoryData and self.targetData.equipMemoryData:HasCacheRefreshAttr() or false
end

function EquipMemoryAttrResetView:IsRandomResult()
  if not self:HasTarget() then
    return
  end
  return self.targetData.equipMemoryData and self.targetData.equipMemoryData:IsRandomResult() or false
end

function EquipMemoryAttrResetView:SetActionBtnActive(active)
  xdlog("SetActionBtnActive", active)
  if not (active ~= false and self.targetEffectIndex) or self.targetEffectIndex == 0 then
    self.actionBgSp.gameObject:SetActive(false)
    self.actionBtn_BoxCollider.enabled = false
    return
  else
    self.actionBgSp.gameObject:SetActive(true)
    self.actionBtn_BoxCollider.enabled = true
  end
  local hasRefreshAttr = self:HasRefreshAttr()
  local isRandomResult = self:IsRandomResult()
  if active == nil then
    local costEnough = self.resetCostEnough
    if not isRandomResult then
      local isPreviewPageOpen = self.memoryPreview.activeSelf
      xdlog("左侧是否亮", isPreviewPageOpen)
      self.actionBgSp.CurrentState = isPreviewPageOpen and 0 or 1
      self.actionLabel.color = ColorUtil.NGUIWhite
      self.actionLabel.effectColor = isPreviewPageOpen and inactiveLabelEffectColor or activeLabelEffectColor
      self.actionBtn_BoxCollider.enabled = not isPreviewPageOpen
      self.actionLabel.text = actionBtnLabs[1]
      self.quitBtn_Label.text = quitBtnLabs[1]
    else
      if costEnough and not hasRefreshAttr then
        self.actionBgSp.CurrentState = hasRefreshAttr and 0 or 1
        self.actionLabel.color = ColorUtil.NGUIWhite
        self.actionLabel.effectColor = hasRefreshAttr and inactiveLabelEffectColor or activeLabelEffectColor
        self.actionBtn_BoxCollider.enabled = true
      else
        self.actionBgSp.CurrentState = 0
        self.actionLabel.color = inactiveLabelColor
        self.actionLabel.effectColor = inactiveLabelEffectColor
        self.actionBtn_BoxCollider.enabled = false
      end
      self.actionLabel.text = actionBtnLabs[2]
      self.quitBtn_Label.text = quitBtnLabs[2]
    end
  end
end

function EquipMemoryAttrResetView:SetActionBtnStatus(type)
  self.actionLabel.text = actionBtnLabs[type]
  if type == 1 then
    self.actionLabel.text = actionBtnLabs[type]
  end
end

function EquipMemoryAttrResetView:RefreshAttrChoose()
  local cells = self.memoryListCtrl:GetCells()
  if cells and 0 < #cells then
    for i = 1, #cells do
      if i == self.targetEffectIndex then
        cells[i]:SetChoose(true)
      else
        cells[i]:SetChoose(false)
      end
    end
  end
  if 1 < self.targetEffectIndex then
    self.extended = true
    self:RefreshMemoryAttrExtend()
  end
end

function EquipMemoryAttrResetView:handleChooseAttr(cell)
  xdlog("选择重置目标")
  if cell.data and cell.data.id and cell.data.id == 0 and not cell.data.CanUnlock then
    redlog("未随机的词条不可选")
    return
  end
  local cells = self.memoryListCtrl:GetCells()
  for i = 1, #cells do
    cells[i]:SetChoose(cells[i] == cell)
  end
  self.targetEffectIndex = cell.indexInList
  xdlog("目标index", self.targetEffectIndex)
  self:updateFixedCostItems()
  if self.memoryPreview.activeSelf then
    self:_UpdateMemoryPreviewResult()
  end
  self:SetActionBtnActive()
  self.checkBtn.gameObject:SetActive(false)
end

function EquipMemoryAttrResetView:handleChooseResetResult(cell)
  xdlog("选择结果")
  if not cell then
    return
  end
  local cells = self.memoryPreviewCtrl:GetCells()
  for i = 1, #cells do
    cells[i]:SetChoose(cell == cells[i])
  end
  local data = cell.data
  self.chosenEffectId = data.id
  xdlog("目标id", self.chosenEffectId)
end
