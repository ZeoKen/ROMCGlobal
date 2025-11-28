autoImport("EquipChooseBord")
autoImport("MaterialItemCell")
autoImport("EquipMemoryAttrResultBord")
autoImport("EquipMemoryAttrUnlockCell")
EquipMemoryUpgradeView = class("EquipMemoryUpgradeView", ContainerView)
EquipMemoryUpgradeView.ViewType = UIViewType.NormalLayer
autoImport("EquipMemoryCombineView")
EquipMemoryUpgradeView.BrotherView = EquipMemoryCombineView
local _PACKAGECHECK = GameConfig.PackageMaterialCheck.EquipMemory_levelup or {1, 22}
local _attrUnlockLvStep = {}

function EquipMemoryUpgradeView:OnEnter()
  EquipMemoryUpgradeView.super.OnEnter(self)
  self:UpdateCoins()
  if self.npcdata then
    local rootTrans = self.npcdata.assetRole.completeTransform
    self:CameraFocusAndRotateTo(rootTrans, CameraConfig.SwingMachine_ViewPort, CameraConfig.SwingMachine_Rotation)
  else
    self:CameraFocusToMe()
  end
  local targetEquip = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.itemdata
  if targetEquip and targetEquip.equipMemoryData then
    self:ChooseItem(targetEquip)
    self.chooseBord:SetChoose(targetEquip)
    return
  else
    self:ClickTargetCell()
  end
end

function EquipMemoryUpgradeView:GetAvailableMaxLevel(memoryInfo, quality)
  local curLv = memoryInfo.level or 0
  local excessLv = memoryInfo.excess_lv or 0
  local lastReachable = curLv
  for i = curLv + 1, #Table_ItemMemoryLevel do
    local lvCfg = Table_ItemMemoryLevel[i]
    if not (lvCfg and lvCfg.Attr and lvCfg.Attr[quality]) then
      break
    end
    lastReachable = i
    local hasExcessCost = lvCfg.ExcessCost and next(lvCfg.ExcessCost) ~= nil
    local needExcessLv = lvCfg.NeedExcessLv
    if hasExcessCost and needExcessLv and excessLv < needExcessLv then
      break
    end
  end
  return lastReachable
end

function EquipMemoryUpgradeView:OnShow()
  Game.Myself:UpdateEpNodeDisplay(true)
end

function EquipMemoryUpgradeView:OnExit()
  EquipMemoryUpgradeView.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
  self.particleSystems = nil
  self:CameraReset()
end

function EquipMemoryUpgradeView:Init()
  local viewdata = self.viewdata.viewdata
  self.npcdata = viewdata and viewdata.npcdata
  self.isCombine = viewdata and viewdata.isCombine
  if Table_ItemMemoryLevel then
    local _tempLevel = {}
    for i = 1, #Table_ItemMemoryLevel do
      local single = Table_ItemMemoryLevel[i]
      if single.AttrUnlock and not _attrUnlockLvStep[single.AttrUnlock] then
        xdlog("词条解锁等级", single.id)
        _attrUnlockLvStep[single.AttrUnlock] = single.id
      end
    end
  end
  self.priorChooseList = {}
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:AddMapEvts()
  self:InitView()
end

function EquipMemoryUpgradeView:FindObjs()
  self.closeButton = self:FindGO("CloseButton")
  self.closeButton:SetActive(self.isCombine ~= true)
  self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(self.isCombine and 0 or 50)
  local chooseContaienr = self:FindGO("ChooseContainer")
  self.chooseBord = EquipChooseBord_CombineSize.new(chooseContaienr)
  self.chooseBord:SetBordTitle(ZhString.EquipMemory_ChooseMemory)
  self.chooseBord:SetNoneTip(ZhString.EquipMemory_NoResult)
  self.chooseBord:AddEventListener(EquipChooseBord.ChooseItem, self.HandleChooseItem, self)
  self.chooseBord:SetTypeLabelTextGetter(ItemUtil.GetMemoryTag)
  self.chooseBord:Set_CheckValidFunc(function()
    return true
  end)
  self.chooseBord:Hide()
  self.addItemButton = self:FindGO("AddItemButton")
  self.tipLabelGO = self:FindGO("TipLabel")
  self.left = self:FindGO("LeftBg")
  self.left:SetActive(false)
  self.helpBtn = self:FindGO("HelpBtn")
  local coins = self:FindChild("TopCoins")
  self.userRob = self:FindChild("Silver", coins)
  self.robLabel = self:FindComponent("Label", UILabel, self.userRob)
  local symbol = self:FindComponent("symbol", UISprite, self.userRob)
  IconManager:SetItemIcon(Table_Item[GameConfig.MoneyId.Zeny].Icon, symbol)
  self.beforePanel = self:FindGO("BeforePanel")
  self.zenyCost = self:FindGO("ZenyCost")
  self.zenyCostLabel = self:FindGO("ZenyCostLabel", self.zenyCost):GetComponent(UILabel)
  local sprite = self:FindComponent("Sprite", UISprite, self.zenyCostLabel.gameObject)
  IconManager:SetItemIcon(Table_Item[GameConfig.MoneyId.Zeny].Icon, sprite)
  self.zenyCost:SetActive(false)
  self.title = self:FindGO("Title"):GetComponent(UILabel)
  self.title.text = ZhString.EquipUpgradeView_Title
  self.targetBtn = self:FindGO("TargetCell", self.beforePanel)
  local itemGO = self:FindGO("Item", self.targetBtn)
  self.targetCell = BaseItemCell.new(itemGO)
  self.targetCell:AddEventListener(MouseEvent.MouseClick, self.ClickTargetCell, self)
  
  function self.targetCell.UpdateStrengthLevel()
  end
  
  local longPress = self.targetBtn:AddComponent(UILongPress)
  longPress.pressTime = 0.8
  
  function longPress.pressEvent(obj, isPress)
    if isPress then
      self:handleLongPress(self.targetCell)
    end
  end
  
  self.upgradeActivePart = self:FindGO("ActivePart", self.targetBtn)
  local upgradeMaterialPart = self:FindGO("MaterialsPart", self.upgradeActivePart)
  self.materialScrollView = self:FindGO("MaterialScrollView", upgradeMaterialPart):GetComponent(UIScrollView)
  self.materialGrid = self:FindGO("MaterialGrid", upgradeMaterialPart):GetComponent(UIGrid)
  self.materialCtrl = UIGridListCtrl.new(self.materialGrid, MaterialItemCell, "MaterialItemCell")
  self.materialCtrl:AddEventListener(MouseEvent.MouseClick, self.clickMaterial, self)
  self.materialCtrl:AddEventListener(MouseEvent.LongPress, self.handleLongPress, self)
  self.materialCtrl:AddEventListener(UICellEvent.OnLeftBtnClicked, self.HandleClickUpgradeEquipMat, self)
  self.upgradeEffect = self:FindGO("UpgradeEffect", self.upgradeActivePart)
  self.effectBg = self:FindGO("EffectBg", self.upgradeEffect):GetComponent(UISprite)
  self.effectBg_TweenHeight = self.effectBg.gameObject:GetComponent(TweenHeight)
  self.descScrollView = self:FindGO("DescScrollView", self.upgradeEffect):GetComponent(UIScrollView)
  self.scrollView_Panel = self:FindGO("DescScrollView", self.upgradeEffect):GetComponent(UIPanel)
  local tweenGroupGO = self:FindGO("TweenGroup", self.upgradeEffect)
  self.tweenGroup = tweenGroupGO:GetComponent(TweenPosition)
  self.tweenGroup:SetOnFinished(function()
    self.descScrollView:ResetPosition()
  end)
  self.dragCollider = self:FindGO("DragCollider", self.upgradeEffect):GetComponent(BoxCollider)
  self.showDetailBtn = self:FindGO("ShowDetailBtn", self.upgradeEffect)
  self.showDetailBtn_Sprite = self.showDetailBtn:GetComponent(UISprite)
  self.nextEffectLv_Label = self:FindGO("CurLevel", self.upgradeEffect):GetComponent(UILabel)
  self.nextEffect_Label = self:FindGO("LevelLabel", self.upgradeEffect):GetComponent(UILabel)
  self.nextEffect_Label.overflowMethod = 3
  self.upgradePart = self:FindGO("UpgradePart")
  self.levelUpTip = self:FindGO("LevelUpTip")
  self.curLevel_Label = self:FindGO("CurLevel", self.levelUpTip):GetComponent(UILabel)
  self.nextLevel_Label = self:FindGO("NextLevel", self.levelUpTip):GetComponent(UILabel)
  self.upgradeBtn = self:FindGO("UpgradeBtn")
  self.upgradeBtn_BoxCollider = self.upgradeBtn:GetComponent(BoxCollider)
  self.upgradeBtn_Label = self:FindGO("UpgradeLabel", self.upgradeBtn):GetComponent(UILabel)
  self.excessPart = self:FindGO("ExcessPart")
  self.curExcessLv = self:FindGO("CurExcessLv", self.excessPart):GetComponent(UILabel)
  self.nextExcessLv = self:FindGO("NextExcessLv", self.excessPart):GetComponent(UILabel)
  self.excessLv = self:FindGO("ExcessLv", self.excessPart):GetComponent(UILabel)
  self.finishPart = self:FindGO("FinishPart")
  self.finish_Label = self:FindGO("Label", self.finishPart):GetComponent(UILabel)
  self.endSymbol = self:FindGO("EndSymbol", self.finishPart)
  self.successTip = self:FindGO("SuccessTip")
  self.successTip_Label = self.successTip:GetComponent(UILabel)
  self.successSymbol = self:FindGO("SuccessSymbol", self.successTip)
  self.rotatePart = self:FindGO("RotatePart")
  self.rotateSelf = self.rotatePart:GetComponent(RotateSelf)
  self.rotateSelf.rotateSpeed = 70
  self.rotateSelf.enabled = false
  self.successTip:SetActive(false)
  self.checkBtn = self:FindGO("CheckBtn"):GetComponent(UIToggle)
  self.checkBg = self:FindGO("CheckBg"):GetComponent(UISprite)
  self.checkLabel = self:FindGO("CheckLabel"):GetComponent(UILabel)
  self:AddClickEvent(self.checkBtn.gameObject, function(go)
    xdlog("勾选")
    self:UpdateEquipMemoryInfo()
  end)
  self.checkBtn.gameObject:SetActive(false)
  self.upgradeResult = self:FindGO("UpgradeResult")
  self.upgradeResultScrollView = self:FindGO("ScrollView", self.upgradeResult):GetComponent(UIScrollView)
  self.upgradeResultGrid = self:FindGO("ResultGrid", self.upgradeResult):GetComponent(UITable)
  self.baseAttrChangePart = self:FindGO("BaseAttrChange"):GetComponent(UISprite)
  self.baseAttriGrid = self:FindGO("BaseAttrGrid", self.upgradeResult):GetComponent(UIGrid)
  self.baseAttris = {}
  for i = 1, 4 do
    local attriGO = self:FindGO("AttriCell" .. i, self.baseAttriGrid.gameObject)
    local name = self:FindGO("Name", attriGO):GetComponent(UILabel)
    local oldValue = self:FindGO("OldValue", attriGO):GetComponent(UILabel)
    local targetValue = self:FindGO("TargetValue", attriGO):GetComponent(UILabel)
    local arrow = self:FindGO("Arrow", attriGO)
    self.baseAttris[i] = {
      go = attriGO,
      name = name,
      oldValue = oldValue,
      targetValue = targetValue,
      arrow = arrow
    }
  end
  self.memoryEffectChange_Bg = self:FindGO("EffectChange", self.upgradeResult):GetComponent(UISprite)
  self.memoryAttriGrid = self:FindGO("EffectAttrGrid", self.upgradeResult):GetComponent(UITable)
  self.memoryAttriCtrl = UIGridListCtrl.new(self.memoryAttriGrid, EquipMemoryAttrUnlockCell, "EquipMemoryAttrUnlockCell")
  self.memoryAttriCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickUnlockAttrCell, self)
  local attrTogGO = self:FindGO("AttrTogs")
  self.attrTogs = {}
  self.memoryTog = self:FindGO("Tog1", attrTogGO)
  self.memoryTog_Label = self:FindGO("Tog1Label", self.memoryTog):GetComponent(UILabel)
  self.baseAttrTog = self:FindGO("Tog2", attrTogGO)
  self.baseAttrTog_Label = self:FindGO("Tog2Label", self.baseAttrTog):GetComponent(UILabel)
  self.togChooseSymbol = self:FindGO("ChooseSymbol", attrTogGO)
  self:AddClickEvent(self.memoryTog, function()
    self.memoryAttriGrid.gameObject:SetActive(true)
    self.baseAttriGrid.gameObject:SetActive(false)
    self.memoryTog_Label.color = LuaColor.White()
    self.baseAttrTog_Label.color = LuaGeometry.GetTempVector4(0.30980392156862746, 0.5019607843137255, 0.7686274509803922, 1)
    TweenPosition.Begin(self.togChooseSymbol, 0.3, LuaGeometry.GetTempVector3(-120.65, -2.5, 0))
  end)
  self:AddClickEvent(self.baseAttrTog, function()
    self.memoryAttriGrid.gameObject:SetActive(false)
    self.baseAttriGrid.gameObject:SetActive(true)
    self.memoryTog_Label.color = LuaGeometry.GetTempVector4(0.30980392156862746, 0.5019607843137255, 0.7686274509803922, 1)
    self.baseAttrTog_Label.color = LuaColor.White()
    TweenPosition.Begin(self.togChooseSymbol, 0.3, LuaGeometry.GetTempVector3(120.65, -2.5, 0))
  end)
  self.attrResultBord = EquipMemoryAttrResultBord.new(chooseContaienr)
  self.attrResultBord:Hide()
  self.showAttrBtn = self:FindGO("ShowAttrBtn")
  self:AddClickEvent(self.showAttrBtn, function()
    self.attrResultBord:Show()
    self.attrResultBord:UpdateValidAttrs()
  end)
  self.countPlusBg = self:FindGO("CountPlusBg"):GetComponent(UISprite)
  self.countPlus = self:FindGO("Plus", self.countPlusBg.gameObject):GetComponent(UISprite)
  self.countSubtractBg = self:FindGO("CountSubtractBg"):GetComponent(UISprite)
  self.countSubtract = self:FindGO("Subtract", self.countSubtractBg.gameObject):GetComponent(UISprite)
  self.countInput = self:FindGO("CountBg"):GetComponent(UIInput)
  self.countInput.value = 1
  self.maxcount = 29
  self.maxBtn = self:FindGO("MaxBtn")
  self:PlayUIEffect(EffectMap.UI.EquipMemory_BG, self:FindGO("RightBg"), nil, function(obj, args, assetEffect)
    local effect = assetEffect
    effect:ResetLocalPositionXYZ(-2.93, 159.16, 0)
    local ps = effect.effectObj:GetComponentsInChildren(ParticleSystem, true)
    self.particleSystems = {}
    for i = 1, #ps do
      table.insert(self.particleSystems, ps[i])
      ps[i].gameObject:SetActive(self.nowdata ~= nil)
    end
  end)
  self.targetBtn:SetActive(false)
end

function EquipMemoryUpgradeView:InitView()
  self.successTip_Label.text = ZhString.ComodoBuilding_UpgradeSuccessful
  local printX = self.successTip_Label.printedSize.x
  self.successSymbol.transform.localPosition = LuaGeometry.GetTempVector3(-printX / 2 - 20, 0, 0)
  self.showDescDetail = false
end

function EquipMemoryUpgradeView:AddEvts()
  self:AddClickEvent(self.addItemButton, function(go)
    self:ClickTargetCell()
  end)
  self:AddClickEvent(self.targetBtn, function(go)
    self:ClickTargetCell()
  end)
  self:TryOpenHelpViewById(32614, nil, self.helpBtn)
  self.upgradeBtn = self:FindGO("UpgradeBtn")
  self:AddClickEvent(self.upgradeBtn, function()
    if self.funcValidTime and ServerTime.CurServerTime() / 1000 < self.funcValidTime then
      return
    end
    self:DoUpgrade()
  end)
  self:AddClickEvent(self.showDetailBtn, function()
    self.showDescDetail = not self.showDescDetail
    self:PlayDescTween(self.showDescDetail)
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
  self:AddClickEvent(self.maxBtn, function()
    local memoryInfo = self.nowdata and self.nowdata.equipMemoryData
    if memoryInfo then
      local curLv = memoryInfo.level
      local quality = Table_Item[memoryInfo.staticId].Quality or 2
      local availableMaxLv = self:GetAvailableMaxLevel(memoryInfo, quality)
      local curLvConfig = Table_ItemMemoryLevel[curLv]
      local needBreakthrough = false
      if curLvConfig then
        local excessCost = curLvConfig.ExcessCost
        local hasExcessCost = excessCost and next(excessCost) ~= nil
        local needExcessLv = curLvConfig.NeedExcessLv
        if hasExcessCost and needExcessLv and needExcessLv > (memoryInfo.excess_lv or 0) then
          needBreakthrough = true
        end
      end
      if needBreakthrough then
        self.countInput.value = 1
      else
        self.countInput.value = availableMaxLv - curLv
      end
    end
  end)
end

function EquipMemoryUpgradeView:AddMapEvts()
  self:AddListenEvt(MyselfEvent.ZenyChange, self.OnZenyChange)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.handleItemUpdate)
  self:AddListenEvt(ItemEvent.MemoryUpdate, self.handleItemUpdate)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateCoins)
  self:AddListenEvt(ItemEvent.EquipUpdate, self.handleItemUpdate)
  self:AddListenEvt(ItemEvent.EquipIntegrate_TrySelectEquip, self.ClickTargetCell)
end

function EquipMemoryUpgradeView:AddViewEvts()
end

function EquipMemoryUpgradeView:ClickTargetCell()
  self.autoChooseRefineCheckOn = true
  TableUtility.ArrayClear(self.priorChooseList)
  self:ChooseItem()
  local equipdatas = self:GetValidEquip()
  if 0 < #equipdatas then
    self.chooseBord:Show()
    self.chooseBord:ResetDatas(equipdatas, true)
    self.chooseBord:SetChoose()
  else
    MsgManager.ShowMsgByIDTable(43547)
    self.chooseBord:Hide()
  end
  self.chooseBord:SetChoose()
  self.attrResultBord:Hide()
  self:sendNotification(ItemEvent.EquipChooseSuccess)
  self.upgradeResult:SetActive(false)
end

function EquipMemoryUpgradeView:HandleChooseItem(itemData)
  self:ChooseItem(itemData)
end

function EquipMemoryUpgradeView:ChooseItem(itemData)
  xdlog("选中目标圣遗物")
  if itemData then
    self:sendNotification(ItemEvent.EquipChooseSuccess, itemData)
  end
  local targetGuid = itemData and itemData.id or nil
  self.chooseBord:Hide()
  self.beforePanel:SetActive(itemData ~= nil)
  self.addItemButton:SetActive(itemData == nil)
  self.tipLabelGO:SetActive(itemData == nil)
  self.targetBtn:SetActive(true)
  self.nowdata = itemData
  self.targetCell:SetData(itemData)
  self.countInput.value = 1
  self:UpdateEquipMemoryInfo()
  self.rotateSelf.enabled = itemData ~= nil
  self.rotatePart.transform.localRotation = LuaGeometry.Const_Qua_identity
  if self.particleSystems then
    for i = 1, #self.particleSystems do
      self.particleSystems[i].gameObject:SetActive(itemData ~= nil)
    end
  end
end

function EquipMemoryUpgradeView:UpdateCost()
end

function EquipMemoryUpgradeView:UpdateEquipMemoryInfo()
  self.title.text = ZhString.EquipMemory_Upgrade
  if not self.nowdata then
    return
  end
  local memoryInfo = self.nowdata.equipMemoryData
  if not memoryInfo then
    redlog("记忆数据缺失")
    self.finishPart:SetActive(true)
    self.endSymbol:SetActive(false)
    self.finish_Label.text = ZhString.EquipUpgradeView_UpgradeInvalid
    self.upgradeActivePart:SetActive(false)
    return
  end
  local memoryStaticData = Table_ItemMemory[memoryInfo.staticId]
  if not memoryStaticData then
    redlog("异常 非装备记忆道具", memoryInfo.staticId)
    return
  end
  local quality = Table_Item[memoryInfo.staticId].Quality or 2
  local curLv = memoryInfo.level
  local maxLv = self:GetAvailableMaxLevel(memoryInfo, quality)
  local curLvConfig = Table_ItemMemoryLevel[curLv]
  local needBreakthrough = false
  local needExcessStage
  if curLvConfig then
    local excessCost = curLvConfig.ExcessCost
    local hasExcessCost = excessCost and next(excessCost) ~= nil
    local needExcessLv = curLvConfig.NeedExcessLv
    if hasExcessCost and needExcessLv and needExcessLv > (memoryInfo.excess_lv or 0) then
      needBreakthrough = true
      needExcessStage = needExcessLv
    end
  end
  self._needBreakthrough = needBreakthrough
  if curLv == maxLv and not needBreakthrough then
    self.finishPart:SetActive(true)
    self.upgradeActivePart:SetActive(false)
    self.endSymbol:SetActive(true)
    self.countInput.gameObject:SetActive(false)
    self.maxBtn:SetActive(false)
  else
    self.finishPart:SetActive(false)
    self.upgradeActivePart:SetActive(true)
    self.endSymbol:SetActive(true)
    self.countInput.gameObject:SetActive(true)
    self.maxBtn:SetActive(true)
  end
  local target_lv
  if needBreakthrough then
    target_lv = curLv
  else
    target_lv = curLv + tonumber(self.countInput.value)
  end
  if maxLv < target_lv then
    target_lv = maxLv
  end
  self.maxcount = needBreakthrough and 1 or maxLv - curLv
  self.curLevel_Label.text = curLv == 0 and 0 or curLv
  self.nextLevel_Label.text = target_lv
  self.nextEffectLv_Label.text = target_lv
  local canUpgrade = needBreakthrough or curLv < maxLv
  self.upgradeBtn_BoxCollider.enabled = canUpgrade
  if not canUpgrade then
    self:SetTextureGrey(self.upgradeBtn)
  else
    self:SetTextureWhite(self.upgradeBtn, LuaGeometry.GetTempColor(0.6862745098039216, 0.3764705882352941, 0.10588235294117647, 1))
  end
  local _costs = ReusableTable.CreateArray()
  if not Table_ItemMemoryLevel then
    redlog("异常 升级表Table_ItemMemoryLevel缺失")
    return
  end
  self.upgradePart:SetActive(not needBreakthrough)
  self.excessPart:SetActive(needBreakthrough)
  if needBreakthrough then
    local curExcess = memoryInfo.excess_lv or 0
    local nextExcess = needExcessStage or curExcess + 1
    self.curExcessLv.text = tostring(curExcess)
    self.nextExcessLv.text = tostring(nextExcess)
    local computeAfterMaxLv = function(stageAfter, quality)
      local lastReachable = 0
      for i = 1, #Table_ItemMemoryLevel do
        local lvCfg = Table_ItemMemoryLevel[i]
        if not (lvCfg and lvCfg.Attr and lvCfg.Attr[quality]) then
          break
        end
        lastReachable = i
        local hasExcessCost = lvCfg.ExcessCost and next(lvCfg.ExcessCost) ~= nil
        local needExcessLv2 = lvCfg.NeedExcessLv
        if hasExcessCost and needExcessLv2 and stageAfter < needExcessLv2 then
          break
        end
      end
      return lastReachable
    end
    local afterMaxLv = computeAfterMaxLv(nextExcess, quality)
    self.excessLv.text = string.format(ZhString.EquipMemory_ExcessLv, curLv, afterMaxLv)
  end
  if needBreakthrough then
    local excess = curLvConfig and curLvConfig.ExcessCost and curLvConfig.ExcessCost[quality]
    if excess and 0 < #excess then
      for i = 1, #excess do
        local _itemId = excess[i][1]
        local _itemCount = excess[i][2]
        local costItem = ItemData.new(MaterialItemCell.MaterialType.Material, _itemId)
        costItem.num = BagProxy.Instance:GetItemNumByStaticID(_itemId, _PACKAGECHECK)
        costItem.neednum = _itemCount
        table.insert(_costs, costItem)
      end
    end
    self.materialCtrl:ResetDatas(_costs)
    local cells = self.materialCtrl:GetCells()
    for i = 1, #cells do
      local dragScrollView = cells[i].gameObject:GetComponent(UIDragScrollView)
      if not dragScrollView then
        cells[i].gameObject:AddComponent(UIDragScrollView)
      end
    end
    if cells and 5 <= #cells then
      self.materialScrollView.contentPivot = UIWidget.Pivot.Left
    else
      self.materialScrollView.contentPivot = UIWidget.Pivot.Center
    end
    self.materialScrollView:ResetPosition()
  elseif curLv < target_lv then
    local _costList = {}
    for i = curLv, target_lv - 1 do
      local _levelConfig = Table_ItemMemoryLevel[i]
      local needItem = _levelConfig and _levelConfig.NeedItem and _levelConfig.NeedItem[quality]
      if needItem then
        local _itemId = needItem[1]
        local _itemCount = needItem[2]
        if not _costList[_itemId] then
          _costList[_itemId] = _itemCount
        else
          _costList[_itemId] = _costList[_itemId] + _itemCount
        end
      else
        redlog("等级缺少配置", i, quality)
      end
    end
    for _itemId, _count in pairs(_costList) do
      local costItem = ItemData.new(MaterialItemCell.MaterialType.Material, _itemId)
      costItem.num = BagProxy.Instance:GetItemNumByStaticID(_itemId, _PACKAGECHECK)
      costItem.neednum = _count
      table.insert(_costs, costItem)
    end
    self.materialCtrl:ResetDatas(_costs)
    local cells = self.materialCtrl:GetCells()
    for i = 1, #cells do
      local dragScrollView = cells[i].gameObject:GetComponent(UIDragScrollView)
      if not dragScrollView then
        cells[i].gameObject:AddComponent(UIDragScrollView)
      end
    end
    if cells and 5 <= #cells then
      self.materialScrollView.contentPivot = UIWidget.Pivot.Left
    else
      self.materialScrollView.contentPivot = UIWidget.Pivot.Center
    end
    self.materialScrollView:ResetPosition()
  end
  self.upgradeResult:SetActive(true)
  local curBaseLvAttrConfig = Table_ItemMemoryLevel[curLv] and Table_ItemMemoryLevel[curLv].Attr and Table_ItemMemoryLevel[curLv].Attr[quality] or {}
  local targetLvAttrConfig = Table_ItemMemoryLevel[target_lv] and Table_ItemMemoryLevel[target_lv].Attr and Table_ItemMemoryLevel[target_lv].Attr[quality] or {}
  local mergableAttrs = {}
  local separateAttrs = {}
  local orderList = {}
  local order = 0
  local getAttrDisplayName = function(propName)
    return propName == "MaxHp" and ZhString.EquipMemory_MaxHp or propName
  end
  local isHpAttr = function(propName)
    return propName == "MaxHp" or propName == "BaseHp"
  end
  local createAttrData = function(name, curValue, targetValue, order)
    return {
      name = name,
      curValue = curValue or "",
      targetValue = targetValue or "",
      order = order
    }
  end
  local formatAttrValue = function(value, isPercent)
    if isPercent == 1 then
      return value * 100 .. "%"
    else
      return value
    end
  end
  for attrId, targetValue in pairs(targetLvAttrConfig) do
    order = order + 1
    local attrConfig = Game.Config_PropName[attrId]
    if attrConfig then
      local propName = attrConfig.PropName
      local displayName = getAttrDisplayName(propName)
      local formattedTargetValue = formatAttrValue(targetValue, attrConfig.IsPercent)
      local curValue = curBaseLvAttrConfig[attrId]
      local formattedCurValue = curValue and formatAttrValue(curValue, attrConfig.IsPercent) or nil
      if isHpAttr(attrConfig.VarName) then
        local hpOrder = attrConfig.VarName == "MaxHp" and 998 or 999
        table.insert(separateAttrs, createAttrData(displayName, formattedCurValue, formattedTargetValue, hpOrder))
      else
        local curKey = formattedCurValue ~= nil and tostring(formattedCurValue) or "__nil__"
        local targetKey = formattedTargetValue ~= nil and tostring(formattedTargetValue) or "__nil__"
        if not mergableAttrs[curKey] then
          mergableAttrs[curKey] = {}
        end
        if not mergableAttrs[curKey][targetKey] then
          mergableAttrs[curKey][targetKey] = {}
        end
        table.insert(mergableAttrs[curKey][targetKey], propName)
        orderList[propName] = attrConfig.id
      end
    end
  end
  local attrResult = {}
  for curValue, targetInfo in pairs(mergableAttrs) do
    for targetValue, nameList in pairs(targetInfo) do
      local combinedName = table.concat(nameList, ZhString.ItemTip_ChAnd)
      local attrOrder = orderList[nameList[1]] or 999
      local displayCurValue = curValue ~= "__nil__" and curValue or ""
      local displayTargetValue = targetValue ~= "__nil__" and targetValue or ""
      table.insert(attrResult, createAttrData(combinedName, displayCurValue, displayTargetValue, attrOrder))
    end
  end
  for _, attrData in ipairs(separateAttrs) do
    table.insert(attrResult, attrData)
  end
  table.sort(attrResult, function(a, b)
    return a.order < b.order
  end)
  local attrNum = 0
  for i = 1, 4 do
    if attrResult[i] then
      self.baseAttris[i].go:SetActive(true)
      self.baseAttris[i].name.text = attrResult[i].name
      self.baseAttris[i].targetValue.text = attrResult[i].targetValue
      self.baseAttris[i].oldValue.text = attrResult[i].curValue ~= attrResult[i].targetValue and attrResult[i].curValue or ""
      self.baseAttris[i].arrow:SetActive(attrResult[i].curValue ~= attrResult[i].targetValue)
      attrNum = attrNum + 1
    else
      self.baseAttris[i].go:SetActive(false)
    end
  end
  self.baseAttrChangePart.height = attrNum * 35 + 53
  local curEffectLevel = Table_ItemMemoryLevel[curLv].EffectLevel
  local targetEffectLevel = Table_ItemMemoryLevel[target_lv].EffectLevel
  local effectList = {}
  local attrs = memoryInfo.memoryAttrs
  local randomAttr = memoryStaticData.RandomAttr
  local tempLvs = {}
  for _level, info in pairs(randomAttr) do
    table.insert(tempLvs, _level)
  end
  table.sort(tempLvs, function(l, r)
    return l < r
  end)
  local unlockLvs = {}
  for i = 1, #tempLvs do
    unlockLvs[i] = tempLvs[i]
  end
  local maxAttrCount = memoryInfo.maxAttrCount or 1
  if needBreakthrough then
    local breakthroughStage = needExcessStage or (memoryInfo.excess_lv or 0) + 1
    local upgradeAttrIndex
    local excessCfg = GameConfig and GameConfig.EquipMemory and GameConfig.EquipMemory.Excess and GameConfig.EquipMemory.Excess.LvIndexUnlock
    local mappedKey = excessCfg and excessCfg[breakthroughStage]
    if type(mappedKey) == "number" and 10 <= mappedKey then
      upgradeAttrIndex = math.floor(mappedKey / 10)
    end
    local passExcessForSlot = {}
    do
      local curExcess = memoryInfo.excess_lv or 0
      local excessCfg = GameConfig and GameConfig.EquipMemory and GameConfig.EquipMemory.Excess and GameConfig.EquipMemory.Excess.LvIndexUnlock
      if type(excessCfg) == "table" and curExcess and 0 < curExcess then
        for stageKey, mappedKey in pairs(excessCfg) do
          local slotIndex = type(mappedKey) == "number" and math.floor(mappedKey / 10) or nil
          if slotIndex and stageKey <= curExcess then
            passExcessForSlot[slotIndex] = curExcess
          end
        end
      end
    end
    for i = 1, maxAttrCount do
      if attrs[i] and attrs[i].id and attrs[i].id ~= 0 then
        local _tempData = {
          id = attrs[i].id,
          excess_lv = passExcessForSlot[i],
          isExcessMode = upgradeAttrIndex ~= nil and i == upgradeAttrIndex or false,
          excess_stage = upgradeAttrIndex ~= nil and i == upgradeAttrIndex and breakthroughStage or nil,
          isFourth = i == 4
        }
        table.insert(effectList, _tempData)
      end
    end
  else
    local passExcessForSlot = {}
    do
      local curExcess = memoryInfo.excess_lv or 0
      local excessCfg = GameConfig and GameConfig.EquipMemory and GameConfig.EquipMemory.Excess and GameConfig.EquipMemory.Excess.LvIndexUnlock
      if type(excessCfg) == "table" and curExcess and 0 < curExcess then
        for stageKey, mappedKey in pairs(excessCfg) do
          local slotIndex = type(mappedKey) == "number" and math.floor(mappedKey / 10) or nil
          if slotIndex and stageKey <= curExcess then
            passExcessForSlot[slotIndex] = curExcess
          end
        end
      end
    end
    for i = 1, maxAttrCount do
      if attrs[i] and attrs[i].previewid ~= nil and 0 < #attrs[i].previewid then
        local _tempData = {
          id = attrs[i].id,
          excess_lv = passExcessForSlot[i],
          canUnlock = attrs[i].id == 0 and true or false,
          text = ZhString.EquipMemory_NotChosen,
          isFourth = i == 4
        }
        table.insert(effectList, _tempData)
      elseif i == maxAttrCount and quality == 5 then
        local _tempData = {
          id = 0,
          canUnlock = false,
          text = ZhString.EquipMemory_MemoryAdvanceUnlockAttr
        }
        table.insert(effectList, _tempData)
      else
        local _tempData = {
          id = 0,
          unlockLv = unlockLvs[i],
          canUnlock = target_lv >= unlockLvs[i]
        }
        table.insert(effectList, _tempData)
      end
    end
  end
  self.memoryAttriCtrl:ResetDatas(effectList)
  self:handleClickMemoryEffect()
  self.upgradeBtn_Label.text = needBreakthrough and ZhString.EquipMemory_Breakthrough or ZhString.EquipUpgradePopUp_Upgrade
  ReusableTable.DestroyAndClearArray(_costs)
  self.upgradeResultGrid:Reposition()
  self.upgradeResultScrollView:ResetPosition()
end

function EquipMemoryUpgradeView:GetValidEquip()
  local _BagProxy = BagProxy.Instance
  local result = {}
  local equipedMemory = EquipMemoryProxy.Instance.equipPosData
  if equipedMemory and not TableUtil.TableIsEmpty(equipedMemory) then
    for _pos, _memoryData in pairs(equipedMemory) do
      local _itemData = ItemData.new("EquipedMemory", _memoryData.staticId)
      _itemData.equipMemoryData = _memoryData:Clone()
      _itemData.equiped = 1
      _itemData.sitePos = _pos
      xdlog("加入装备中的记忆列表", _memoryData.staticId)
      table.insert(result, _itemData)
    end
  end
  for i = 1, #_PACKAGECHECK do
    local items = _BagProxy:GetBagByType(_PACKAGECHECK[i]):GetItems()
    xdlog("背包数量", _PACKAGECHECK[i], #items)
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
  xdlog("装备记忆数量", #result)
  return result
end

function EquipMemoryUpgradeView:UpdateLackItems()
  self.lackItems = self.lackItems or {}
  TableUtility.ArrayClear(self.lackItems)
  local targetListCtrl = self.materialCtrl
  local cells, lackitemid, lacknum = targetListCtrl:GetCells()
  for i = 1, #cells do
    local data = cells[i].data
    lackitemid = data.staticData.id
    lacknum = data.neednum - data.num
    if lackitemid and 0 < lacknum then
      table.insert(self.lackItems, {id = lackitemid, count = lacknum})
    end
  end
end

function EquipMemoryUpgradeView:DoUpgrade()
  self.productID = nil
  self:UpdateLackItems()
  if self.lackItems and #self.lackItems > 0 then
    MsgManager.ShowMsgByID(3703)
    return
  end
  local confirmHandler = function()
    self:_DoUpgrade()
  end
  confirmHandler()
end

function EquipMemoryUpgradeView:_DoUpgrade()
  local chooseMat = {}
  local func = function()
    xdlog("强化目标", self.nowdata.id, self.nextLevel_Label.text)
    local memoryData = self.nowdata.equipMemoryData
    local equipGuid = memoryData.itemGuid
    if self._needBreakthrough then
      if not self.nowdata.sitePos then
        xdlog("记忆本体突破", equipGuid)
        ServiceItemProxy.Instance:CallMemoryExcessItemCmd(equipGuid, nil)
      else
        xdlog("装备记忆突破", self.nowdata.sitePos)
        ServiceItemProxy.Instance:CallMemoryExcessItemCmd(nil, self.nowdata.sitePos)
      end
    elseif not self.nowdata.sitePos then
      xdlog("记忆本体升级", equipGuid)
      ServiceItemProxy.Instance:CallMemoryLevelupItemCmd(equipGuid, nil, self.nextLevel_Label.text)
    else
      xdlog("装备记忆升级", self.nowdata.sitePos)
      ServiceItemProxy.Instance:CallMemoryLevelupItemCmd(nil, self.nowdata.sitePos, self.nextLevel_Label.text)
    end
    self.rotateSelf.rotateSpeed = 100
    TimeTickManager.Me():ClearTick(self, 2)
    TimeTickManager.Me():ClearTick(self, 4)
    TimeTickManager.Me():CreateOnceDelayTick(500, function()
      self.successTip:SetActive(true)
    end, self, 4)
    TimeTickManager.Me():CreateOnceDelayTick(2000, function()
      self.successTip:SetActive(false)
      self.rotateSelf.rotateSpeed = 70
    end, self, 2)
    self.upgradeBtn_BoxCollider.enabled = false
    TimeTickManager.Me():ClearTick(self, 3)
    TimeTickManager.Me():CreateOnceDelayTick(500, function()
      self.upgradeBtn_BoxCollider.enabled = true
    end, self, 3)
    self:PlayUIEffect(EffectMap.UI.EquipUpgrade_Success, self.targetBtn, true)
  end
  func()
end

function EquipMemoryUpgradeView:PlayDescTween(bool)
  self.showDetailBtn_Sprite.flip = bool and 2 or 0
  self.dragCollider.enabled = bool
  self.descScrollView:ResetPosition()
  if bool then
    self.tweenGroup:PlayForward()
    self.effectBg_TweenHeight:PlayForward()
  else
    self.tweenGroup:PlayReverse()
    self.effectBg_TweenHeight:PlayReverse()
  end
end

function EquipMemoryUpgradeView:UpdateCostZeny(zeny)
  self.curCostZeny = zeny
  self.zenyCostLabel.text = StringUtil.NumThousandFormat(zeny)
  self.zenyCostLabel.color = zeny > MyselfProxy.Instance:GetROB() and ColorUtil.Red or LuaGeometry.GetTempVector4(0.3333333333333333, 0.3568627450980392, 0.43137254901960786, 1)
end

function EquipMemoryUpgradeView:GetCurCostZeny()
  return tonumber(self.curCostZeny)
end

function EquipMemoryUpgradeView:OnZenyChange()
end

function EquipMemoryUpgradeView:UpdateCoins()
  self.robLabel.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetROB())
end

function EquipMemoryUpgradeView:handleItemUpdate()
  xdlog("item update")
  local sitePos = self.nowdata and self.nowdata.sitePos
  if sitePos then
    local posData = EquipMemoryProxy.Instance:GetPosData(sitePos)
    if posData then
      local _itemData = ItemData.new("EquipedMemory", posData.staticId)
      _itemData.equipMemoryData = posData:Clone()
      _itemData.equiped = 1
      _itemData.sitePos = sitePos
      self:ChooseItem(_itemData)
    end
    xdlog("原部位刷新")
  else
    local guid = self.nowdata and self.nowdata.id
    if guid then
      local itemData = BagProxy.Instance:GetItemByGuid(guid)
      if itemData and itemData.equipMemoryData then
        self:ChooseItem(itemData)
      else
        self:ChooseItem()
      end
    end
  end
end

function EquipMemoryUpgradeView:clickMaterial(cell)
  local data = cell.data
  if data == nil then
    return
  end
  self:ShowItemInfo(cell)
end

function EquipMemoryUpgradeView:ShowItemInfo(cellCtrl)
  local data = cellCtrl.data
  if data == nil then
    return
  end
  local sdata = {
    itemdata = data,
    funcConfig = {},
    hideGetPath = true
  }
  self:ShowItemTip(sdata, self.tipStick, nil, {-190, 0})
end

function EquipMemoryUpgradeView:handleLongPress(cell)
  local data = cell.data
  if data == nil then
    return
  end
  local sdata = {
    itemdata = data,
    funcConfig = {},
    hideGetPath = true
  }
  self:ShowItemTip(sdata, self.targetCell.icon, NGUIUtil.AnchorSide.Left, {-200, 0})
end

function EquipMemoryUpgradeView:handleClickMemoryEffect(cell)
  if cell then
    cell:SwitchFolderState()
  end
  self.memoryAttriGrid:Reposition()
  local size = NGUIMath.CalculateRelativeWidgetBounds(self.memoryAttriGrid.transform)
  self.memoryEffectChange_Bg.height = size.size.y + 55
end

function EquipMemoryUpgradeView:HandleClickUnlockAttrCell(cell)
  local data = cell.data
  if data == nil then
    return
  end
  local isFourth = data.isFourth
  local canUnlock = data.canUnlock
  if isFourth and canUnlock then
    EventManager.Me():PassEvent(EquipMemoryEvent.JumpToAttrReset)
  end
end

function EquipMemoryUpgradeView:PlusPressCount(isPressed)
  if isPressed then
    self.countChangeRate = 1
    TimeTickManager.Me():CreateTick(0, 150, function(owner, deltaTime)
      self:UpdateCount(1)
    end, self, 1001)
  else
    TimeTickManager.Me():ClearTick(self, 1001)
  end
end

function EquipMemoryUpgradeView:SubtractPressCount(isPressed)
  if isPressed then
    self.countChangeRate = 1
    TimeTickManager.Me():CreateTick(0, 150, function(owner, deltaTime)
      self:UpdateCount(-1)
    end, self, 1002)
  else
    TimeTickManager.Me():ClearTick(self, 1002)
  end
end

function EquipMemoryUpgradeView:UpdateCount(change)
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
  self:UpdateEquipMemoryInfo()
end

function EquipMemoryUpgradeView:InputOnChange()
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
  self:UpdateEquipMemoryInfo()
end

function EquipMemoryUpgradeView:SetCountPlus(alpha)
  if self.countPlusBg.color.a ~= alpha then
    self:SetSpritAlpha(self.countPlusBg, alpha)
    self:SetSpritAlpha(self.countPlus, alpha)
  end
end

function EquipMemoryUpgradeView:SetCountSubtract(alpha)
  if self.countSubtractBg.color.a ~= alpha then
    self:SetSpritAlpha(self.countSubtractBg, alpha)
    self:SetSpritAlpha(self.countSubtract, alpha)
  end
end

function EquipMemoryUpgradeView:SetSpritAlpha(sprit, alpha)
  sprit.color = Color(sprit.color.r, sprit.color.g, sprit.color.b, alpha)
end
