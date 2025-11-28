autoImport("EquipChooseBord")
autoImport("MaterialItemCell")
autoImport("EquipMemoryAttrChangeCell")
autoImport("EquipMemoryAttrResultBord")
autoImport("EquipMemoryAttrUnlockCell")
EquipMemoryAdvanceView = class("EquipMemoryAdvanceView", ContainerView)
EquipMemoryAdvanceView.ViewType = UIViewType.NormalLayer
autoImport("EquipMemoryCombineView")
EquipMemoryAdvanceView.BrotherView = EquipMemoryCombineView
local _PACKAGECHECK = GameConfig.PackageMaterialCheck.EquipMemory_levelup or {1, 22}

function EquipMemoryAdvanceView:OnEnter()
  EquipMemoryAdvanceView.super.OnEnter(self)
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

function EquipMemoryAdvanceView:OnShow()
  Game.Myself:UpdateEpNodeDisplay(true)
end

function EquipMemoryAdvanceView:OnExit()
  EquipMemoryAdvanceView.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
  self.particleSystems = nil
  self:CameraReset()
end

function EquipMemoryAdvanceView:Init()
  local viewdata = self.viewdata.viewdata
  self.npcdata = viewdata and viewdata.npcdata
  self.isCombine = viewdata and viewdata.isCombine
  self.priorChooseList = {}
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:AddMapEvts()
  self:InitView()
end

function EquipMemoryAdvanceView:FindObjs()
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
  self.mainCellGrid = self:FindGO("MainCellGrid"):GetComponent(UIGrid)
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
  
  local previewGO = self:FindGO("PreviewResultItem", self.targetBtn)
  self.previewResultCell = BaseItemCell.new(previewGO)
  
  function self.previewResultCell.UpdateStrengthLevel()
  end
  
  self.cellBGGO = self:FindGO("EquipUpgradeBgIcon", self.targetBtn)
  self.arrow = self:FindGO("ArrowBG", self.targetBtn)
  self.upgradeActivePart = self:FindGO("ActivePart", self.targetBtn)
  local upgradeMaterialPart = self:FindGO("MaterialsPart", self.upgradeActivePart)
  self.materialScrollView = self:FindGO("MaterialScrollView", upgradeMaterialPart):GetComponent(UIScrollView)
  self.materialGrid = self:FindGO("MaterialGrid", upgradeMaterialPart):GetComponent(UIGrid)
  self.materialCtrl = UIGridListCtrl.new(self.materialGrid, MaterialItemCell, "MaterialItemCell")
  self.materialCtrl:AddEventListener(MouseEvent.MouseClick, self.clickMaterial, self)
  self.materialCtrl:AddEventListener(MouseEvent.LongPress, self.handleLongPress, self)
  self.materialCtrl:AddEventListener(UICellEvent.OnLeftBtnClicked, self.HandleClickUpgradeEquipMat, self)
  self.levelUpTip = self:FindGO("LevelUpTip")
  self.curLevel_Label = self:FindGO("CurLevel", self.levelUpTip):GetComponent(UILabel)
  self.nextLevel_Label = self:FindGO("NextLevel", self.levelUpTip):GetComponent(UILabel)
  self.upgradeBtn = self:FindGO("UpgradeBtn")
  self.upgradeBtn_BoxCollider = self.upgradeBtn:GetComponent(BoxCollider)
  self.upgradeBtn_Label = self:FindGO("UpgradeLabel", self.upgradeBtn):GetComponent(UILabel)
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
  self.baseAttriGrid = self:FindGO("BaseAttrGrid", self.upgradeResult):GetComponent(UIGrid)
  self.baseAttris = {}
  for i = 1, 3 do
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

function EquipMemoryAdvanceView:InitView()
  self.successTip_Label.text = ZhString.ComodoBuilding_UpgradeSuccessful
  local printX = self.successTip_Label.printedSize.x
  self.successSymbol.transform.localPosition = LuaGeometry.GetTempVector3(-printX / 2 - 20, 0, 0)
  self.showDescDetail = false
end

function EquipMemoryAdvanceView:AddEvts()
  self:AddClickEvent(self.addItemButton, function(go)
    self:ClickTargetCell()
  end)
  self:AddClickEvent(self.targetBtn, function(go)
    self:ClickTargetCell()
  end)
  self:TryOpenHelpViewById(32637, nil, self.helpBtn)
  self.upgradeBtn = self:FindGO("UpgradeBtn")
  self:AddClickEvent(self.upgradeBtn, function()
    if self.funcValidTime and ServerTime.CurServerTime() / 1000 < self.funcValidTime then
      return
    end
    self:DoUpgrade()
  end)
end

function EquipMemoryAdvanceView:AddMapEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.handleItemUpdate)
  self:AddListenEvt(ItemEvent.MemoryUpdate, self.handleItemUpdate)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateCoins)
  self:AddListenEvt(ItemEvent.EquipUpdate, self.handleItemUpdate)
  self:AddListenEvt(ItemEvent.EquipIntegrate_TrySelectEquip, self.ClickTargetCell)
end

function EquipMemoryAdvanceView:AddViewEvts()
end

function EquipMemoryAdvanceView:ClickTargetCell()
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

function EquipMemoryAdvanceView:HandleChooseItem(itemData)
  self:ChooseItem(itemData)
end

function EquipMemoryAdvanceView:ChooseItem(itemData)
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

function EquipMemoryAdvanceView:UpdateCost()
end

function EquipMemoryAdvanceView:UpdateEquipMemoryInfo()
  self.title.text = ZhString.EquipMemory_Advance
  if not self.nowdata then
    return
  end
  local memoryInfo = self.nowdata.equipMemoryData
  if not memoryInfo then
    redlog("记忆数据缺失")
    self.finishPart:SetActive(true)
    self.endSymbol:SetActive(false)
    self.finish_Label.text = ZhString.EquipMemory_AdvanceUnvalid
    self.upgradeActivePart:SetActive(false)
    return
  end
  local memoryStaticData = Table_ItemMemory[memoryInfo.staticId]
  if not memoryStaticData then
    redlog("异常 非装备记忆道具", memoryInfo.staticId)
    return
  end
  local quality = memoryStaticData.Quality or 2
  local upgradeID = memoryStaticData.UpgradeID
  local canUpgrade = upgradeID ~= nil
  local curLv = memoryInfo.level
  if not canUpgrade then
    self.finishPart:SetActive(true)
    self.upgradeActivePart:SetActive(false)
    self.endSymbol:SetActive(true)
    self.previewResultCell.gameObject:SetActive(false)
    self.cellBGGO.transform:SetParent(self.targetCell.trans)
    self.cellBGGO.transform.localPosition = LuaGeometry.Const_V3_zero
    self.arrow:SetActive(false)
  else
    self.finishPart:SetActive(false)
    self.upgradeActivePart:SetActive(true)
    self.endSymbol:SetActive(true)
    self.previewResultCell.gameObject:SetActive(true)
    self.cellBGGO.transform:SetParent(self.previewResultCell.trans)
    self.cellBGGO.transform.localPosition = LuaGeometry.Const_V3_zero
    self.arrow:SetActive(true)
  end
  self.mainCellGrid:Reposition()
  if upgradeID then
    local _itemData = ItemData.new("Preview", upgradeID)
    _itemData.equipMemoryData = memoryInfo:Clone()
    self.previewResultCell:SetData(_itemData)
  end
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
  if canUpgrade then
    local _costList = {}
    local upgradeCost = memoryStaticData.UpgradeCost
    if upgradeCost then
      for i = 1, #upgradeCost do
        _costList[upgradeCost[i][1]] = upgradeCost[i][2]
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
  local curBaseLvAttrConfig = Table_ItemMemoryLevel[curLv].Attr[quality]
  local targetLvAttrConfig = Table_ItemMemoryLevel[curLv].Attr[quality == 5 and quality or quality + 1]
  local attrList = {}
  local order = 0
  local orderList = {}
  for _attr, _value in pairs(targetLvAttrConfig) do
    order = order + 1
    local _tempData = {}
    local attrConfig = Game.Config_PropName[_attr]
    if attrConfig then
      if attrConfig.PropName == "MaxHp" then
        _tempData.name = ZhString.EquipMemory_MaxHp
        orderList[ZhString.EquipMemory_MaxHp] = order
      else
        _tempData.name = attrConfig.PropName
        orderList[attrConfig.PropName] = order
      end
      if attrConfig.IsPercent == 1 then
        _tempData.targetValue = _value * 100 .. "%"
      else
        _tempData.targetValue = _value
      end
      if curBaseLvAttrConfig[_attr] then
        _tempData.curValue = curBaseLvAttrConfig[_attr]
      end
      if _tempData.curValue and not attrList[_tempData.curValue] then
        attrList[_tempData.curValue] = {}
      end
      if _tempData.targetValue and not attrList[_tempData.curValue][_tempData.targetValue] then
        attrList[_tempData.curValue][_tempData.targetValue] = {}
      end
      table.insert(attrList[_tempData.curValue][_tempData.targetValue], _tempData.name)
    end
  end
  local attrResult = {}
  for _curValue, _info in pairs(attrList) do
    for _targetValue, _nameList in pairs(_info) do
      local order
      local _tempData = {curValue = _curValue, targetValue = _targetValue}
      local _nameStr = ""
      for i = 1, #_nameList do
        _nameStr = _nameStr .. _nameList[i]
        if i < #_nameList then
          _nameStr = _nameStr .. ZhString.ItemTip_ChAnd
        end
        order = order or orderList[_nameList[i]] or 999
      end
      _tempData.order = order
      _tempData.name = _nameStr
      table.insert(attrResult, _tempData)
    end
  end
  table.sort(attrResult, function(l, r)
    return l.order < r.order
  end)
  for i = 1, 3 do
    if attrResult[i] then
      self.baseAttris[i].go:SetActive(true)
      self.baseAttris[i].name.text = attrResult[i].name
      self.baseAttris[i].targetValue.text = attrResult[i].targetValue
      self.baseAttris[i].oldValue.text = attrResult[i].curValue ~= attrResult[i].targetValue and attrResult[i].curValue or ""
      self.baseAttris[i].arrow:SetActive(attrResult[i].curValue ~= attrResult[i].targetValue)
    else
      self.baseAttris[i].go:SetActive(false)
    end
  end
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
  for i = 1, maxAttrCount do
    if attrs[i] and attrs[i].previewid ~= nil and 0 < #attrs[i].previewid then
      local _tempData = {
        id = attrs[i].id,
        text = ZhString.EquipMemory_NotChosen,
        canUnlock = attrs[i].id == 0 and true or false,
        isFourth = i == maxAttrCount
      }
      table.insert(effectList, _tempData)
    else
      local _tempData = {
        id = 0,
        unlockLv = unlockLvs[i],
        canUnlock = false
      }
      table.insert(effectList, _tempData)
    end
  end
  if canUpgrade then
    local _tempData = {
      id = 0,
      canUnlock = canUpgrade,
      text = ZhString.EquipMemory_MemoryAdvanceUnlockAttr
    }
    table.insert(effectList, _tempData)
  end
  self.memoryAttriCtrl:ResetDatas(effectList)
  self:handleClickMemoryEffect()
  self.upgradeBtn_Label.text = ZhString.EquipUpgradePopUp_Upgrade
  ReusableTable.DestroyAndClearArray(_costs)
  self.upgradeResultScrollView:ResetPosition()
end

function EquipMemoryAdvanceView:GetValidEquip()
  local _BagProxy = BagProxy.Instance
  local result = {}
  local equipedMemory = EquipMemoryProxy.Instance.equipPosData
  if equipedMemory and not TableUtil.TableIsEmpty(equipedMemory) then
    for _pos, _memoryData in pairs(equipedMemory) do
      if _memoryData:CheckCanAdvance() then
        local _itemData = ItemData.new("EquipedMemory", _memoryData.staticId)
        _itemData.equipMemoryData = _memoryData:Clone()
        _itemData.equiped = 1
        _itemData.sitePos = _pos
        xdlog("加入装备中的记忆列表", _memoryData.staticId)
        table.insert(result, _itemData)
      end
    end
  end
  for i = 1, #_PACKAGECHECK do
    local items = _BagProxy:GetBagByType(_PACKAGECHECK[i]):GetItems()
    xdlog("背包数量", _PACKAGECHECK[i], #items)
    for j = 1, #items do
      if items[j].equipMemoryData and items[j].equipMemoryData:CheckCanAdvance() then
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
  end)
  xdlog("装备记忆数量", #result)
  return result
end

function EquipMemoryAdvanceView:UpdateLackItems()
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

function EquipMemoryAdvanceView:DoUpgrade()
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

function EquipMemoryAdvanceView:_DoUpgrade()
  local chooseMat = {}
  local func = function()
    xdlog("强化目标", self.nowdata.id, self.nextLevel_Label.text)
    local memoryData = self.nowdata.equipMemoryData
    local equipGuid = memoryData.itemGuid
    if self.nowdata.sitePos then
      ServiceItemProxy.Instance:CallMemoryUpgradeItemCmd(nil, self.nowdata.sitePos)
    else
      ServiceItemProxy.Instance:CallMemoryUpgradeItemCmd(equipGuid)
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

function EquipMemoryAdvanceView:UpdateCostZeny(zeny)
  self.curCostZeny = zeny
  self.zenyCostLabel.text = StringUtil.NumThousandFormat(zeny)
  self.zenyCostLabel.color = zeny > MyselfProxy.Instance:GetROB() and ColorUtil.Red or LuaGeometry.GetTempVector4(0.3333333333333333, 0.3568627450980392, 0.43137254901960786, 1)
end

function EquipMemoryAdvanceView:GetCurCostZeny()
  return tonumber(self.curCostZeny)
end

function EquipMemoryAdvanceView:UpdateCoins()
  self.robLabel.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetROB())
end

function EquipMemoryAdvanceView:handleItemUpdate()
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

function EquipMemoryAdvanceView:clickMaterial(cell)
  local data = cell.data
  if data == nil then
    return
  end
  self:ShowItemInfo(cell)
end

function EquipMemoryAdvanceView:ShowItemInfo(cellCtrl)
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

function EquipMemoryAdvanceView:handleLongPress(cell)
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

function EquipMemoryAdvanceView:handleClickMemoryEffect(cell)
  if cell then
    cell:SwitchFolderState()
  end
  self.memoryAttriGrid:Reposition()
  local size = NGUIMath.CalculateRelativeWidgetBounds(self.memoryAttriGrid.transform)
  self.memoryEffectChange_Bg.height = size.size.y + 55
end

function EquipMemoryAdvanceView:HandleClickUnlockAttrCell(cell)
  local data = cell.data
  if data == nil then
    return
  end
  local isFourth = data.isFourth
  local canUnlock = data.canUnlock
  xdlog("第四词条 跳转", isFourth, canUnlock)
  if isFourth and canUnlock then
    EventManager.Me():PassEvent(EquipMemoryEvent.JumpToAttrReset)
  end
end

function EquipMemoryAdvanceView:PlusPressCount(isPressed)
  if isPressed then
    self.countChangeRate = 1
    TimeTickManager.Me():CreateTick(0, 150, function(owner, deltaTime)
      self:UpdateCount(1)
    end, self, 1001)
  else
    TimeTickManager.Me():ClearTick(self, 1001)
  end
end

function EquipMemoryAdvanceView:SubtractPressCount(isPressed)
  if isPressed then
    self.countChangeRate = 1
    TimeTickManager.Me():CreateTick(0, 150, function(owner, deltaTime)
      self:UpdateCount(-1)
    end, self, 1002)
  else
    TimeTickManager.Me():ClearTick(self, 1002)
  end
end

function EquipMemoryAdvanceView:UpdateCount(change)
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

function EquipMemoryAdvanceView:OnZenyChange()
end
