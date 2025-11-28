EquipMemoryWaxView = class("EquipMemoryWaxView", ContainerView)
autoImport("EquipMemoryCombineView")
EquipMemoryWaxView.BrotherView = EquipMemoryCombineView
autoImport("EquipMemoryAttrCell")
autoImport("EquipMemoryAttrResultBord")
autoImport("EquipMemoryAttrDetailCell")
local arrayClear, arrayPushBack = TableUtility.ArrayClear, TableUtility.ArrayPushBack
local bagIns, lotteryIns, shopIns, tickManager, pictureMgr
local destroyAndClearTable = ReusableTable.DestroyAndClearTable
local createTable = ReusableTable.CreateTable
local resetMatPackageCheck = GameConfig.PackageMaterialCheck.EquipMemory_levelup
local fixedCostTipOffset = {-210, 180}
local inactiveLabelColor = LuaColor.New(0.9372549019607843, 0.9372549019607843, 0.9372549019607843)
local inactiveLabelEffectColor = LuaColor.New(0.5019607843137255, 0.5019607843137255, 0.5019607843137255)
local activeLabelEffectColor = LuaColor.New(0.6862745098039216, 0.3764705882352941, 0.10588235294117647)
local againActiveLabelEffectColor = LuaColor.New(0.6862745098039216, 0.3764705882352941, 0.10588235294117647)
local actionBtnLabs
local _PACKAGECHECK = {
  1,
  2,
  20,
  22
}
local optionalBtnIntervalTime = 1

function EquipMemoryWaxView:Init()
  self:InitData()
  self:FindObjs()
  self:InitView()
  self:AddListenEvts()
  self:AddEvts()
end

function EquipMemoryWaxView:InitData()
  actionBtnLabs = {
    ZhString.EquipMemory_AddWax,
    ZhString.EnchantThirdAttrReset_ActionBtnAgainDesc
  }
  bagIns, lotteryIns, shopIns, pictureMgr = BagProxy.Instance, LotteryProxy.Instance, HappyShopProxy.Instance, PictureManager.Instance
  tickManager = TimeTickManager.Me()
  self.tipData = {}
  self.isCombine = self.viewdata.viewdata and self.viewdata.viewdata.isCombine
end

function EquipMemoryWaxView:FindObjs()
  self.mainBoard = self:FindGO("MainBoard")
  self.mainBoardTrans = self.mainBoard.transform
  self.closeButton = self:FindGO("CloseButton")
  self.title = self:FindComponent("Title", UILabel, self.mainBoard)
  self.actionBgSp = self:FindComponent("ActionBtn", UIMultiSprite, self.mainBoard)
  self.actionLabel = self:FindComponent("ActionLabel", UILabel, self.actionBgSp.gameObject)
  self.actionLabel.text = actionBtnLabs[1]
  self.emptyTip = self:FindComponent("EmptyTip", UILabel, self.mainBoard)
  self.emptyTip.text = ZhString.EnchantThirdAttrReset_EmptyTip
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
  self.enchantNoneTip = self:FindComponent("EnchantNoneTip", UILabel, self.actionBoard)
  self.enchantNoneTip.text = ZhString.EnchantAttrUp_EnchantNoneTip
  self.enchantCellParent = self:FindGO("EnchantCellParent", self.actionBoard)
  self.fixedCost = self:FindGO("FixedCost")
  self.fixedCostGrid = self:FindComponent("FixedCostGrid", UIGrid, self.actionBoard)
  self.finishPart = self:FindGO("FinishPart")
  self.waxItemResult = self:FindGO("WaxItemResult")
  self.waxResultGrid = self:FindGO("ResultGrid", self.waxItemResult):GetComponent(UIGrid)
  self.waxItemCtrl = UIGridListCtrl.new(self.waxResultGrid, EquipChooseCell, "EquipChooseCell")
  self:PlayUIEffect(EffectMap.UI.EquipMemory_BG, self:FindGO("RightBg"), nil, function(obj, args, assetEffect)
    local effect = assetEffect
    effect:ResetLocalPositionXYZ(-2.93, 159.16, 0)
    local ps = effect.effectObj:GetComponentsInChildren(ParticleSystem, true)
    for i = 1, #ps do
      ps[i].gameObject:SetActive(false)
      ps[i].gameObject:SetActive(true)
    end
  end)
  self.fullBodyEffect = self:FindGO("FullBodyEffect")
  self.fullBodyEffect_Bg = self:FindGO("ResultBg", self.fullBodyEffect):GetComponent(UISprite)
  self.fullBodyEffect_Pattern = self:FindGO("Pattern", self.fullBodyEffect):GetComponent(UISprite)
  self.effectUpperShadow = self:FindGO("UpperShadow", self.fullBodyEffect):GetComponent(UISprite)
  self.extendBtn = self:FindGO("Arrow", self.fullBodyEffect)
  self.extendBtn_Sprite = self.extendBtn:GetComponent(UISprite)
  self.isEffectExtend = false
  self.effectScrollView = self:FindGO("ScrollView", self.fullBodyEffect):GetComponent(UIScrollView)
  self.effectScrollView_Panel = self.effectScrollView.panel
  self.effectGrid = self:FindGO("EffectGrid", self.fullBodyEffect):GetComponent(UITable)
  self.effectCtrl = UIGridListCtrl.new(self.effectGrid, EquipMemoryAttrDetailCell, "EquipMemoryAttrDetailCell")
  self.effectCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleSwitchSingle, self)
end

function EquipMemoryWaxView:InitView()
  self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(self.isCombine and -50 or 0)
  self.closeButton:SetActive(not self.isCombine)
  self.targetChooseBord = EquipChooseBord_CombineSize.new(self.chooseContainer, function()
    return self:GetChooseBordDataFunc()
  end)
  self.targetChooseBord:SetFilterPopData(GameConfig.EquipChooseFilter)
  self.targetChooseBord:AddEventListener(EquipChooseBord.ChooseItem, self.OnClickChooseBordCell, self)
  self.targetChooseBord:SetTypeLabelTextGetter(ItemUtil.GetMemoryTag)
  self.targetChooseBord.needSetCheckValidFuncOnShow = true
  self.targetChooseBord:Show(true, nil, nil, self.checkChooseBoardValid, self, ZhString.EnchantThirdAttrReset_InValid)
  self.memoryAttrScrollView = self:FindGO("MemoryAttrScrollView"):GetComponent(UIScrollView)
  local memoryAttrGrid = self:FindGO("MemoryAttrGrid"):GetComponent(UIGrid)
  self.memoryListCtrl = UIGridListCtrl.new(memoryAttrGrid, EquipMemoryAttrCell, "EquipMemoryAttrCell")
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
  self.attrResultBord = EquipMemoryAttrResultBord.new(self.chooseContainer)
  self.attrResultBord:Hide()
end

function EquipMemoryWaxView:OnEnter()
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
  self:UpdateActiveEffect()
end

function EquipMemoryWaxView:OnExit()
  EquipMemoryWaxView.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
  self:CameraReset()
end

function EquipMemoryWaxView:AddEvts()
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
  self:AddButtonEvent("AttrBrifBtn", function()
    self.attrResultBord:UpdateValidAttrs()
    self.attrResultBord:Show()
  end)
  self:AddClickEvent(self.extendBtn, function()
    self.isEffectExtend = not self.isEffectExtend
    if self.isEffectExtend then
      self.fullBodyEffect_Bg.height = 738
      self.extendBtn_Sprite.flip = 2
    else
      self.fullBodyEffect_Bg.height = 242
      self.extendBtn_Sprite.flip = 0
    end
    self.effectScrollView_Panel:UpdateAnchors()
    self.effectScrollView:ResetPosition()
    self.effectUpperShadow:UpdateAnchors()
    self.extendBtn_Sprite:UpdateAnchors()
    self.fullBodyEffect_Pattern:UpdateAnchors()
  end)
  TipsView.Me():TryShowGeneralHelpByHelpId(33, self:FindGO("HelpButton"))
end

function EquipMemoryWaxView:AddListenEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.OnItemUpdate)
  self:AddListenEvt(ItemEvent.MemoryUpdate, self.OnItemUpdate)
  self:AddListenEvt(ItemEvent.EquipUpdate, self.OnItemUpdate)
end

function EquipMemoryWaxView:OnClickChooseBordCell(data)
  self:SetTargetCell(data)
end

function EquipMemoryWaxView:SetTargetCell(data)
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

function EquipMemoryWaxView:HasTarget()
  return nil ~= self.targetData and nil ~= self.targetData.staticData
end

function EquipMemoryWaxView:TargetHasMaxWax()
  if not self:HasTarget() then
    return
  end
  local waxCount = self.targetData and self.targetData.equipMemoryData and self.targetData.equipMemoryData:GetWaxCount()
  return waxCount == #self.targetData.equipMemoryData.memoryAttrs
end

function EquipMemoryWaxView:OnRemoveTarget()
  self.targetData = nil
  self:UpdateViewByTargetCell()
  self.targetChooseBord:Show(true, nil, nil, self.checkChooseBoardValid, self, ZhString.EnchantThirdAttrReset_InValid)
  self.targetChooseBord:SetChoose(nil)
  self.attrResultBord:Hide()
end

function EquipMemoryWaxView:checkChooseBoardValid(itemdata)
  if itemdata and itemdata.equipMemoryData then
    return true
  end
  return false
end

function EquipMemoryWaxView:GetChooseBordDataFunc()
  local _BagProxy = BagProxy.Instance
  local result = {}
  for i = 1, #_PACKAGECHECK do
    local items = _BagProxy:GetBagByType(_PACKAGECHECK[i]):GetItems()
    for j = 1, #items do
      if items[j].equipMemoryData then
        if not items[j]:IsMemory() then
          local _itemData = ItemData.new(items[j].id, items[j].equipMemoryData.staticId)
          _itemData:Copy(items[j])
          _itemData.embeded = true
          _itemData.equiped = items[j].equiped
          table.insert(result, _itemData)
        else
          table.insert(result, items[j])
        end
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
  end)
  return result
end

function EquipMemoryWaxView:OnClickActionBtn()
  if not self:HasTarget() then
    return
  end
  if self:HasRefreshAttr() then
    redlog("有重置内容")
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
    if not self.targetData.embeded then
      xdlog("记忆本体打封蜡", equipGuid)
      ServiceItemProxy.Instance:CallMemoryWaxItemCmd(nil, equipGuid)
    else
      xdlog("装备中记忆打封蜡", equipGuid)
      ServiceItemProxy.Instance:CallMemoryWaxItemCmd(equipGuid, nil)
    end
    resetClickTime = UnityUnscaledTime
    self:PlayUIEffect(EffectMap.UI.EquipReplaceNew, self.effContainer, true)
    self:PlayUISound(AudioMap.UI.EnchantThireResetSuc)
  end
  _actionFunc()
end

function EquipMemoryWaxView:OnItemUpdate()
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
  if self.manualOption and self.memoryPreview.activeSelf then
    self:Hide(self.memoryPreview)
    self.manualOption = nil
    self:SetActionBtnActive()
  end
  self:UpdateActiveEffect()
end

local iconScale = 1

function EquipMemoryWaxView:UpdateViewByTargetCell()
  if not self:HasTarget() then
    self:Hide(self.actionBoard)
    self:Hide(self.targetCellContent)
    self:Show(self.emptyTip)
    self:Show(self.targetCellAddIcon)
    self:SetActionBtnActive(false)
    self:Hide(self.finishPart)
    self:Hide(self.fullBodyEffect)
    return
  elseif self:TargetHasMaxWax() then
    self:Show(self.actionBoard)
    self:Hide(self.fixedCost)
    self:Hide(self.emptyTip)
    self:Hide(self.targetCellAddIcon)
    self:Show(self.targetCellContent)
    local memoryStaticID = self.targetData.equipMemoryData.staticId
    IconManager:SetItemIcon(Table_Item[memoryStaticID].Icon, self.targetIcon)
    self.targetIcon:MakePixelPerfect()
    self.targetIcon.transform.localScale = LuaGeometry.GetTempVector3(iconScale, iconScale, iconScale)
    self:Show(self.finishPart)
    self:updateTargetMemoryInfo()
    self:SetActionBtnActive(false)
    self:Show(self.fullBodyEffect)
    self.targetChooseBord:Hide()
    return
  end
  self.targetEffectIndex = 1
  self.chosenEffectId = nil
  self:Hide(self.emptyTip)
  self:Hide(self.targetCellAddIcon)
  self:Show(self.actionBoard)
  self:Show(self.fixedCost)
  self:Show(self.targetCellContent)
  self:Hide(self.finishPart)
  self:Show(self.fullBodyEffect)
  local memoryStaticID = self.targetData.equipMemoryData.staticId
  IconManager:SetItemIcon(Table_Item[memoryStaticID].Icon, self.targetIcon)
  self.targetIcon:MakePixelPerfect()
  self.targetIcon.transform.localScale = LuaGeometry.GetTempVector3(iconScale, iconScale, iconScale)
  self:updateTargetMemoryInfo()
  self:updateFixedCostItems()
  self:SetActionBtnActive()
  self.targetChooseBord:Hide()
end

function EquipMemoryWaxView:updateTargetMemoryInfo()
  local memoryData = self.targetData and self.targetData.equipMemoryData
  if not memoryData then
    redlog("没有记忆属性")
  end
  local attrs = memoryData.memoryAttrs
  self.memoryListCtrl:ResetDatas(attrs)
end

function EquipMemoryWaxView:updateFixedCostItems()
  if not self:HasTarget() then
    return
  end
  arrayClear(self.fixedCostItemDatas)
  self.resetCostEnough = true
  local costConfig = GameConfig.EquipMemory.WaxCost
  if not costConfig then
    redlog("封蜡道具缺失GameConfig.EquipMemory.WaxCost")
    return
  end
  local waxCount = self.targetData.equipMemoryData:GetWaxCount() or 0
  xdlog("当前封蜡数量", waxCount)
  if waxCount == #self.targetData.equipMemoryData.memoryAttrs then
    redlog("封蜡已满")
    self.finishPart:SetActive(true)
    return
  end
  local single = costConfig[waxCount + 1]
  local itemCostData = ItemData.new(MaterialItemCell.MaterialType.Material, single[1])
  itemCostData.num = bagIns:GetItemNumByStaticID(single[1], resetMatPackageCheck)
  itemCostData.neednum = single[2]
  arrayPushBack(self.fixedCostItemDatas, itemCostData)
  self.fixedCostCtl:ResetDatas(self.fixedCostItemDatas)
end

function EquipMemoryWaxView:SetActionBtnActive(active)
  if active == false then
    self.actionBgSp.gameObject:SetActive(active)
    return
  else
    self.actionBgSp.gameObject:SetActive(true)
  end
  local hasRefreshAttr = self:HasRefreshAttr()
  xdlog("SetActionBtnActive", active)
  if active == nil then
    local costEnough = self.resetCostEnough
    xdlog("Active=false", costEnough, hasRefreshAttr)
    if costEnough and not hasRefreshAttr then
      self.actionBgSp.CurrentState = hasRefreshAttr and 2 or 1
      self.actionLabel.color = ColorUtil.NGUIWhite
      self.actionLabel.effectColor = hasRefreshAttr and againActiveLabelEffectColor or activeLabelEffectColor
    else
      self.actionBgSp.CurrentState = 0
      self.actionLabel.color = inactiveLabelColor
      self.actionLabel.effectColor = inactiveLabelEffectColor
    end
  end
end

function EquipMemoryWaxView:HasRefreshAttr()
  if not self:HasTarget() then
    return
  end
  return self.targetData.equipMemoryData and self.targetData.equipMemoryData:HasCacheRefreshAttr() or false
end

function EquipMemoryWaxView:OnClickFixedCostItemTip(cell)
  local data = cell.data
  if not BagItemCell.CheckData(data) then
    return
  end
  self.tipData.itemdata = data
  EquipMemoryWaxView.super.ShowItemTip(self, self.tipData, cell.icon, NGUIUtil.AnchorSide.Left, fixedCostTipOffset)
end

function EquipMemoryWaxView:UpdateActiveEffect()
  local result = {}
  local memoryLevel = BagProxy.Instance:GetTotalEquipMemoryLevels()
  for _attrid, _info in pairs(memoryLevel) do
    local _tempData = {
      attrid = _attrid,
      levels = {},
      wax_level = _info.wax_level
    }
    local _levels = _info.levels
    for i = 1, #_levels do
      if i <= 3 then
        table.insert(_tempData.levels, _levels[i])
      end
    end
    table.insert(result, _tempData)
  end
  self.effectCtrl:ResetDatas(result)
  self.effectScrollView:ResetPosition()
end

function EquipMemoryWaxView:HandleSwitchSingle(cell)
  if cell then
    cell:SwitchFolderState()
  end
  self.effectGrid:Reposition()
end
