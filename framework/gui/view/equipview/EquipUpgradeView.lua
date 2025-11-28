autoImport("EquipChooseBord")
autoImport("MaterialItemCell")
EquipUpgradeView = class("EquipUpgradeView", ContainerView)
EquipUpgradeView.ViewType = UIViewType.NormalLayer
autoImport("CommonCombineView")
EquipUpgradeView.BrotherView = CommonCombineView
local _PACKAGECHECK = {
  2,
  1,
  20
}
local _COMPOSEPACKAGECHECK = GameConfig.PackageMaterialCheck.equipcompose

function EquipUpgradeView:OnEnter()
  EquipComposeProxy.Instance:InitData()
  EquipUpgradeView.super.OnEnter(self)
  self:UpdateCoins()
  if self.npcdata then
    local rootTrans = self.npcdata.assetRole.completeTransform
    self:CameraFocusAndRotateTo(rootTrans, CameraConfig.SwingMachine_ViewPort, CameraConfig.SwingMachine_Rotation)
  else
    self:CameraFocusToMe()
  end
  local targetEquip = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.OnClickChooseBordCell_data
  if targetEquip then
    self:ChooseItem(targetEquip)
    self.chooseBord:SetChoose(targetEquip)
    return
  else
    local curOperEquip = EquipComposeProxy.Instance:GetCurOperEquipGuid()
    if curOperEquip then
      local item = BagProxy.Instance:GetItemByGuid(curOperEquip)
      if item then
        self:ChooseItem(item)
        self.chooseBord:SetChoose(item)
        return
      end
    end
  end
  self:ClickTargetCell()
end

function EquipUpgradeView:OnShow()
  Game.Myself:UpdateEpNodeDisplay(true)
end

function EquipUpgradeView:OnExit()
  EquipUpgradeView.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
  self.particleSystems = nil
  self:CameraReset()
end

function EquipUpgradeView:Init()
  local viewdata = self.viewdata.viewdata
  self.npcdata = viewdata and viewdata.npcdata
  self.isCombine = viewdata and viewdata.isCombine
  if not (self.viewdata and self.viewdata.viewdata) or self.viewdata.viewdata.from_AdventureEquipComposeTip then
  end
  self.costEquips = {}
  self.priorChooseList = {}
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:AddMapEvts()
  self:InitView()
  self:AddOrRemoveGuideId(self.addItemButton, 546)
  self:AddOrRemoveGuideId(self.upgradeBtn, 548)
end

function EquipUpgradeView:FindObjs()
  self.closeButton = self:FindGO("CloseButton")
  self.closeButton:SetActive(self.isCombine ~= true)
  local chooseContaienr = self:FindGO("ChooseContainer")
  self.chooseBord = EquipChooseBord_CombineSize.new(chooseContaienr)
  self.chooseBord:SetFilterPopData(GameConfig.EquipChooseFilter)
  self.chooseBord:AddEventListener(EquipChooseBord.ChooseItem, self.ChooseItem, self)
  self.chooseBord:Hide()
  self.composeMatChooseBord = EquipCountChooseBord.new(chooseContaienr)
  self.composeMatChooseBord:AddEventListener(EquipChooseCellEvent.CountChooseChange, self.OnComposeMatCountChooseChange, self)
  self.composeMatChooseBord:AddEventListener(EquipChooseCellEvent.CountChooseCheck, self.OnClickMatCheck, self)
  self.composeMatChooseBord:SetUseItemNum(true)
  self.composeMatChooseBord:Hide()
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
  self.adventureBtn = self:FindGO("AdventureBtn")
  self.adventureBtn_Sprite = self:FindGO("Sprite", self.adventureBtn):GetComponent(UISprite)
  IconManager:SetUIIcon("tab_btn_icon_zhuangbeiguanzhu", self.adventureBtn_Sprite)
  self.title = self:FindGO("Title"):GetComponent(UILabel)
  self.title.text = ZhString.EquipUpgradeView_Title
  self.targetBtn = self:FindGO("TargetCell", self.beforePanel)
  self.materialChooseBord = EquipCountChooseBord.new(chooseContaienr)
  self.materialChooseBord:AddEventListener(EquipChooseCellEvent.CountChooseChange, self.OnUpgradeMatCountChooseChange, self)
  self.materialChooseBord:AddEventListener(EquipChooseCellEvent.CountChooseCheck, self.OnClickUpgradeMatCheck, self)
  self.materialChooseBord:SetUseItemNum(true)
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
  self.commonActivePart = self:FindGO("CommonActivePart")
  local upgradeMaterialPart = self:FindGO("MaterialsPart", self.commonActivePart)
  self.materialScrollView = self:FindGO("MaterialScrollView", upgradeMaterialPart):GetComponent(UIScrollView)
  self.materialGrid = self:FindGO("MaterialGrid", upgradeMaterialPart):GetComponent(UIGrid)
  self.materialCtrl = UIGridListCtrl.new(self.materialGrid, MaterialItemCell, "MaterialItemCell")
  self.materialCtrl:AddEventListener(MouseEvent.MouseClick, self.clickMaterial, self)
  self.materialCtrl:AddEventListener(MouseEvent.LongPress, self.handleLongPress, self)
  self.materialCtrl:AddEventListener(UICellEvent.OnLeftBtnClicked, self.HandleClickMaterialMat, self)
  self.upgradeEffect = self:FindGO("UpgradeEffect", self.commonActivePart)
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
  self.levelUpTip = self:FindGO("LevelUpTip")
  self.curLevel_Label = self:FindGO("CurLevel", self.levelUpTip):GetComponent(UILabel)
  self.nextLevel_Label = self:FindGO("NextLevel", self.levelUpTip):GetComponent(UILabel)
  self.upgradeBtn = self:FindGO("UpgradeBtn")
  self.upgradeBtn_BoxCollider = self.upgradeBtn:GetComponent(BoxCollider)
  self.upgradeBtn_Label = self:FindGO("UpgradeLabel", self.upgradeBtn):GetComponent(UILabel)
  self.composeTip = self:FindGO("ComposeTip", self.commonActivePart):GetComponent(UILabel)
  self.equipComposePart = self:FindGO("EquipComposePart")
  self.curEquipCellBtn = self:FindGO("CurEquipCell", self.equipComposePart)
  self.curEquipCell = BaseItemCell.new(self.curEquipCellBtn)
  self.curEquipCell:AddEventListener(MouseEvent.MouseClick, self.ClickMainMatCell, self)
  self.equipMainMatChooseBord = EquipChooseBord_CombineSize.new(chooseContaienr)
  self.equipMainMatChooseBord:AddEventListener(EquipChooseBord.ChooseItem, self.ChooseMainMat, self)
  self.equipMainMatChooseBord:Hide()
  longPress = self.curEquipCellBtn:AddComponent(UILongPress)
  longPress.pressTime = 0.8
  
  function longPress.pressEvent(obj, isPress)
    if isPress then
      self:handleLongPress(self.curEquipCell)
    end
  end
  
  local targetComposeCellGO = self:FindGO("ComposeTargetCell", self.equipComposePart)
  self.targetComposeCell = BaseItemCell.new(targetComposeCellGO)
  longPress = targetComposeCellGO:AddComponent(UILongPress)
  longPress.pressTime = 0.8
  
  function longPress.pressEvent(obj, isPress)
    if isPress then
      self:handleLongPress(self.targetComposeCell)
    end
  end
  
  self.composeActivePart = self:FindGO("ActivePart", self.equipComposePart)
  self.finishPart = self:FindGO("FinishPart")
  self.finish_Label = self:FindGO("Label", self.finishPart):GetComponent(UILabel)
  self.endSymbol = self:FindGO("EndSymbol", self.finishPart)
  self.successTip = self:FindGO("SuccessTip")
  self.successTip_Label = self.successTip:GetComponent(UILabel)
  self.successSymbol = self:FindGO("SuccessSymbol", self.successTip)
  self.ancientTip = self:FindGO("AncientTip")
  self.rotatePart = self:FindGO("RotatePart")
  self.rotateSelf = self.rotatePart:GetComponent(RotateSelf)
  self.rotateSelf.rotateSpeed = 70
  self.rotateSelf.enabled = false
  self.successTip:SetActive(false)
  self.ancientTip:SetActive(false)
  self.checkBtn = self:FindGO("CheckBtn"):GetComponent(UIToggle)
  self.checkBg = self:FindGO("CheckBg"):GetComponent(UISprite)
  self.checkLabel = self:FindGO("CheckLabel"):GetComponent(UILabel)
  self:AddClickEvent(self.checkBtn.gameObject, function(go)
    if self.curComposeData then
      self:UpdateEquipComposeInfo()
    else
      self:UpdateUpgradeInfo()
    end
  end)
  self:PlayUIEffect(EffectMap.UI.EquipUpgrade_Bg, self:FindGO("RightBg"), nil, function(obj, args, assetEffect)
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

function EquipUpgradeView:InitView()
  self.successTip_Label.text = ZhString.ComodoBuilding_UpgradeSuccessful
  local printX = self.successTip_Label.printedSize.x
  self.successSymbol.transform.localPosition = LuaGeometry.GetTempVector3(-printX / 2 - 20, 0, 0)
  self.showDescDetail = false
  self.autoChooseRefineCheckOn = true
end

function EquipUpgradeView:AddEvts()
  self:AddClickEvent(self.addItemButton, function(go)
    self:ClickTargetCell()
  end)
  self:AddClickEvent(self.targetBtn, function(go)
    self:ClickTargetCell()
  end)
  self:AddClickEvent(self.adventureBtn, function(go)
    local curEquipID
    if self.curComposeData then
      curEquipID = self.curComposeData.composeID
    else
      curEquipID = self.nowdata.staticData.id
    end
    xdlog("跳转至冒险手册", curEquipID)
    if self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.from_AdventureEquipComposeTip then
      self.viewdata.viewdata.from_AdventureEquipComposeTip = false
    end
    EventManager.Me():PassEvent(UIEvent.ExitCallback, nil)
    GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.AdventurePanel,
      viewdata = {
        tabId = SceneManual_pb.EMANUALTYPE_RESEARCH,
        selectItemId = curEquipID,
        isFromEquipIntegrate = 3
      }
    })
  end)
  self:TryOpenHelpViewById(34, nil, self.helpBtn)
  self.upgradeBtn = self:FindGO("UpgradeBtn")
  self:AddClickEvent(self.upgradeBtn, function()
    if self.funcValidTime and ServerTime.CurServerTime() / 1000 < self.funcValidTime then
      return
    end
    if self.curComposeData then
      FunctionSecurity.Me():LevelUpEquip(function()
        self:DoCompose()
      end)
    else
      FunctionSecurity.Me():LevelUpEquip(function()
        self:DoUpgrade()
      end)
    end
  end)
  self:AddClickEvent(self.showDetailBtn, function()
    self.showDescDetail = not self.showDescDetail
    self:PlayDescTween(self.showDescDetail)
  end)
end

function EquipUpgradeView:AddMapEvts()
  self:AddListenEvt(MyselfEvent.ZenyChange, self.OnZenyChange)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.handleItemUpdate)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateCoins)
  self:AddListenEvt(ItemEvent.EquipUpdate, self.handleItemUpdate)
  self:AddListenEvt(ItemEvent.EquipIntegrate_TrySelectEquip, self.ClickTargetCell)
end

function EquipUpgradeView:AddViewEvts()
end

function EquipUpgradeView:ResetLevelDescription()
  if self.upgradeStr then
    self.nextEffect_Label.text = self.upgradeStr
  end
  if self.showDescDetail then
    self.nextEffect_Label.overflowMethod = 3
  else
    self.nextEffect_Label.overflowMethod = 1
    self.nextEffect_Label.height = self.nextEffect_Label.fontSize + self.nextEffect_Label.spacingY
  end
end

function EquipUpgradeView:ChooseItem(itemData)
  self:sendNotification(ItemEvent.EquipChooseSuccess, itemData)
  local targetGuid = itemData and itemData.id or nil
  EquipComposeProxy.Instance:SetCurOperEquipGuid(targetGuid)
  if not itemData then
    self.curChooseEquipMaterialId = nil
  end
  if self.materialChooseBord.gameObject.activeSelf then
    self.materialChooseBord:Hide()
  end
  if self.composeMatChooseBord.gameObject.activeSelf then
    self.composeMatChooseBord:Hide()
  end
  self.chooseBord:Hide()
  self.beforePanel:SetActive(itemData ~= nil)
  self.addItemButton:SetActive(itemData == nil)
  self.tipLabelGO:SetActive(itemData == nil)
  self.zenyCost:SetActive(itemData ~= nil)
  self.adventureBtn:SetActive(itemData ~= nil and not BranchMgr.IsJapan())
  self.checkBtn.gameObject:SetActive(itemData ~= nil)
  local isCompose = false
  local composeID
  if itemData and ISNoviceServerType then
    local composeData = EquipComposeProxy.Instance:GetComposeDataByMainMatID(itemData.staticData.id)
    if composeData then
      local level = composeData.lv
      composeID = composeData.composeID
      if itemData.equipInfo and itemData.equipInfo.equiplv == level then
        isCompose = true
      end
    end
  end
  if isCompose then
    xdlog("灌注")
    self.equipComposePart:SetActive(true)
    self.targetBtn:SetActive(false)
    local id = itemData.id
    local item = BagProxy.Instance:GetItemByGuid(id)
    if not item then
      local compose_checkBagTypes = BagProxy.Instance:Get_PackageMaterialCheck_BagTypes(BagProxy.MaterialCheckBag_Type.Upgrade)
      local equips = BlackSmithProxy.Instance:GetMaterialEquips_ByEquipId(itemData.staticData.id, nil, false, nil, compose_checkBagTypes)
      if not equips or 0 < #equips then
      end
    end
    local composeConfig = Table_EquipCompose[composeID]
    if composeConfig then
      self.curComposeData = EquipComposeNewItemData.new(composeConfig)
      local item = BagProxy.Instance:GetItemByGuid(itemData.id)
      if item then
        self.curComposeData:SetMainChooseMat(itemData.id)
        self.curEquipCell:SetIconlocked(false)
      else
        redlog("筛选装备")
        local mainMatLv = self.curComposeData.mainMatLv
        local compose_checkBagTypes = {
          1,
          2,
          7,
          9,
          17
        }
        local equips = {}
        for i = 1, #compose_checkBagTypes do
          local items = BagProxy.Instance:GetItemsByStaticID(itemData.staticData.id, compose_checkBagTypes[i])
          if items and 0 < #items then
            for j = 1, #items do
              table.insert(equips, items[j])
            end
          end
        end
        xdlog("目标装备数量", itemData.staticData.id, #equips)
        if equips and 0 < #equips then
          table.sort(equips, function(l, r)
            local l_equiplv = l.equipInfo.equiplv or 0
            local r_equiplv = r.equipInfo.equiplv or 0
            if l_equiplv ~= r_equiplv then
              return l_equiplv > r_equiplv
            end
          end)
          self:ChooseItem(equips[1])
          return
        else
          self:ChooseItem()
          return
        end
      end
      self.nowdata = itemData
      self.curEquipCell:SetData(itemData)
      local targetItemData = ItemData.new("Target", composeID)
      targetItemData.equipInfo:Clone(self.nowdata.equipInfo)
      targetItemData.equipInfo.equiplv = 0
      if self.nowdata:HasEnchant() then
        targetItemData.enchantInfo = self.nowdata.enchantInfo:Clone()
      end
      self.targetComposeCell:SetData(targetItemData)
    end
    self:UpdateEquipComposeInfo()
  else
    self.nowdata = itemData
    self.targetCell:SetData(itemData)
    self:UpdateUpgradeInfo()
    self.curComposeData = nil
  end
  self.isCompose = isCompose
  self.rotateSelf.enabled = itemData ~= nil
  self.rotatePart.transform.localRotation = LuaGeometry.Const_Qua_identity
  if self.particleSystems then
    for i = 1, #self.particleSystems do
      self.particleSystems[i].gameObject:SetActive(itemData ~= nil)
    end
  end
  if self.materialChooseBord.gameObject.activeInHierarchy then
    self.materialChooseBord:Hide()
  end
end

function EquipUpgradeView:OnComposeMatCountChooseChange(cell)
  if not cell then
    return
  end
  local data, chooseCount = cell.data, cell.chooseCount
  if not data then
    return
  end
  if not self.chooseInited then
    return
  end
  if not self.curComposeData then
    redlog("没有灌注目标")
    return
  end
  local curCount, targetCount = self.curComposeData:GetMatCountInfo(data.staticData.id)
  local singleRefData = self.refData[data.staticData.id] or {}
  local isUpdate = false
  for i = 1, #singleRefData do
    if singleRefData[i].id == data.id then
      local offsetCount = cell.chooseCount - singleRefData[i].num
      if targetCount >= curCount + offsetCount then
        singleRefData[i].num = cell.chooseCount
        isUpdate = true
      else
        local otherCount = 0
        for j = 1, #singleRefData do
          if singleRefData[j].id ~= singleRefData[i].id then
            otherCount = otherCount + singleRefData[j].num
          end
        end
        xdlog("修正选择数量", targetCount - otherCount)
        cell:SetChooseCount(targetCount - otherCount)
        self:OnComposeMatCountChooseChange(cell)
        return
      end
    end
  end
  if not isUpdate then
    if targetCount >= curCount + cell.chooseCount then
      local itemData = data:Clone()
      itemData.num = cell.chooseCount
      table.insert(singleRefData, itemData)
      xdlog("新增装备", data.id, itemData.num)
    else
      cell:SetChooseCount(targetCount - curCount)
      self:OnComposeMatCountChooseChange(cell)
      return
    end
  end
  local itemData = data:Clone()
  itemData.num = cell.chooseCount
  self.curComposeData:SetChooseMat(data.staticData.id, itemData)
  curCount = 0
  for i = 1, #singleRefData do
    curCount = curCount + singleRefData[i].num
  end
  if self.curComposeData:CheckChooseMatCount(data.staticData.id) then
    xdlog("数量上限")
    self.composeMatChooseBord:SetCellPlusValid(false)
  else
    self.composeMatChooseBord:SetCellPlusValid(true)
  end
  local cells = self.materialCtrl:GetCells()
  for i = 1, #cells do
    local cell = cells[i]
    if cell.data and cell.data.staticData.id == data.staticData.id then
      local curCount = self.curComposeData:GetChooseMatCount(data.staticData.id)
      local tempData = cell.data
      tempData.num = curCount
      cell:SetData(tempData)
    end
  end
end

function EquipUpgradeView:ChooseMaterial(itemData)
  if not itemData then
    redlog("无装备信息")
    return
  end
  local needRecover, tipEquips = FunctionItemFunc.RecoverEquips({itemData})
  if not needRecover then
    self.materialChooseBord:Hide()
  end
  local chooseData = itemData
  local cells = self.materialCtrl:GetCells()
  for i = 1, #cells do
    if cells[i].data.staticData.id == itemData.staticData.id then
      local targetData = itemData:Clone()
      targetData.num = cells[i].data.num
      targetData.neednum = cells[i].data.neednum
      xdlog("重设数值", targetData.num, targetData.neednum, targetData.id)
      cells[i]:SetData(targetData)
      self.curChooseEquipMaterialId = targetData.id
      self.materialChooseBord:SetChoose(targetData)
    end
  end
end

function EquipUpgradeView:OnClickMatCheck(cell)
  if not cell then
    redlog("找不到目标")
    return
  end
  local chooseCount = cell.chooseCount or 0
  if chooseCount == 0 then
    return
  end
  local targetEquipItems = {}
  table.insert(targetEquipItems, cell.data)
  local cancelCall = function()
    if not cell then
      return
    end
    cell:SetChooseCount(0)
  end
  local needRecover, tipEquips = FunctionItemFunc.RecoverEquips(targetEquipItems, nil, cancelCall)
  if needRecover then
    return
  end
  xdlog("检测错误  请检查代码")
end

function EquipUpgradeView:ClickTargetCell()
  self.autoChooseRefineCheckOn = true
  TableUtility.ArrayClear(self.priorChooseList)
  self:ChooseItem()
  local equipdatas = self:GetValidEquip()
  if 0 < #equipdatas then
    self.chooseBord:Show()
    self.chooseBord:ResetDatas(equipdatas, true)
    self.chooseBord:SetChoose()
    local cells = self.chooseBord.chooseCtl:GetCells()
    if cells and 0 < #cells then
      self:AddOrRemoveGuideId(cells[1].chooseButton, 547)
    end
  else
    MsgManager.ShowMsgByIDTable(43489)
    self.chooseBord:Hide()
  end
  self.chooseBord:SetChoose()
  self:sendNotification(ItemEvent.EquipChooseSuccess)
end

local guideQuest = 322220004
local guidePriorList = {
  44352,
  40698,
  63484,
  41287,
  63163,
  62861,
  40797,
  40972,
  41899,
  40087,
  40401,
  41597,
  62568,
  44647,
  63640,
  63940
}

function EquipUpgradeView:GetValidEquip()
  local _BagProxy = BagProxy.Instance
  local result = {}
  for i = 1, #_PACKAGECHECK do
    local items = _BagProxy:GetBagByType(_PACKAGECHECK[i]):GetItems()
    for j = 1, #items do
      local equip = items[j]
      local valid = false
      if equip and equip.equipInfo and equip.equipInfo:CanUpgrade() and not equip:IsExtraction() then
        valid = true
      end
      if not valid and ISNoviceServerType then
        local composeData = EquipComposeProxy.Instance:GetComposeDataByMainMatID(equip.staticData.id)
        if composeData then
          xdlog("装备可以灌注，添加", equip.staticData.id)
          valid = true
        end
      end
      if valid then
        TableUtility.ArrayPushBack(result, equip)
      end
    end
  end
  local hasGuide = FunctionGuide.Me():checkHasGuide(guideQuest)
  if hasGuide then
    table.sort(result, function(l, r)
      local l_isPrior = TableUtility.ArrayFindIndex(guidePriorList, l.staticData.id) > 0 and 1 or 0
      local r_isPrior = TableUtility.ArrayFindIndex(guidePriorList, r.staticData.id) > 0 and 1 or 0
      if l_isPrior ~= r_isPrior then
        return l_isPrior > r_isPrior
      end
    end)
  end
  return result
end

function EquipUpgradeView:HandleSelect(cellctl)
end

function EquipUpgradeView:PlayDescTween(bool)
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

function EquipUpgradeView:UpdateDesc(text, forceLeft)
  self.upgradeStr = text
  self.nextEffect_Label.overflowMethod = 3
  self.nextEffect_Label.text = text
  self.nextEffect_Label:UpdateAnchors()
  local printSizeY = self.nextEffect_Label.height
  local ratio = printSizeY / (self.nextEffect_Label.fontSize + self.nextEffect_Label.spacingY)
  self.showDetailBtn:SetActive(1 < ratio and true or false)
  if 1 < ratio then
    TimeTickManager.Me():CreateTick(0, 33, function()
      self.scrollView_Panel:UpdateAnchors()
    end, self, 1)
    self.nextEffect_Label.alignment = 1
  else
    TimeTickManager.Me():ClearTick(self, 1)
    self.nextEffect_Label.alignment = forceLeft and 1 or 2
  end
  self.showDescDetail = 1 < ratio and true or false
  self:PlayDescTween(self.showDescDetail)
end

function EquipUpgradeView:UpdateUpgradeInfo()
  self.title.text = ZhString.EquipUpgradeView_Title
  if not self.nowdata then
    redlog("return 11111")
    return
  end
  local equipInfo = self.nowdata.equipInfo
  local curEquipLv = equipInfo and equipInfo.equiplv
  if not curEquipLv then
    redlog("当前强化等级无效，请检查")
    return
  end
  local upgradeData = equipInfo and equipInfo.upgradeData
  if not upgradeData then
    redlog("无升级信息")
    self.commonActivePart:SetActive(false)
    self.finishPart:SetActive(true)
    self.endSymbol:SetActive(false)
    self.finish_Label.text = ZhString.EquipUpgradeView_UpgradeInvalid
    self.upgradeActivePart:SetActive(false)
    self.targetBtn:SetActive(true)
    self.equipComposePart:SetActive(false)
    self.zenyCost:SetActive(false)
    self.adventureBtn:SetActive(false)
    self.checkBtn.gameObject:SetActive(false)
    return
  end
  local maxLv = self:GetExpectedMaxLvOfEquipItem()
  local isUpgradeMax = self:GetCurLvOfEquipItem() >= self:GetUpgradeMaxLvOfEquipItem()
  self.nextEffectLv_Label.gameObject:SetActive(true)
  self.curLevel_Label.text = curEquipLv == 0 and 0 or StringUtil.IntToRoman(curEquipLv)
  self.nextLevel_Label.text = isUpgradeMax and "END" or StringUtil.IntToRoman(curEquipLv + 1)
  self.nextEffectLv_Label.text = isUpgradeMax and "END" or StringUtil.IntToRoman(curEquipLv + 1)
  if curEquipLv == maxLv then
    self.commonActivePart:SetActive(false)
    self.finishPart:SetActive(true)
    self.upgradeActivePart:SetActive(false)
    self.targetBtn:SetActive(true)
    self.equipComposePart:SetActive(false)
    self.composeActivePart:SetActive(false)
    self.zenyCost:SetActive(false)
    self.adventureBtn:SetActive(false)
    self.checkBtn.gameObject:SetActive(false)
    self.endSymbol:SetActive(true)
    return
  end
  if isUpgradeMax then
    self.commonActivePart:SetActive(true)
    self.equipComposePart:SetActive(true)
    self.finishPart:SetActive(false)
    self.composeActivePart:SetActive(true)
    self.upgradeActivePart:SetActive(false)
    self.targetBtn:SetActive(false)
    self.levelUpTip:SetActive(false)
    self.composeTip.gameObject:SetActive(true)
    self.curEquipCell:SetData(self.nowdata)
    local productID = self:GetProductIdOfEquipItem()
    if productID then
      self.productID = productID
    end
    if not productID then
      redlog("没有进化产物  需要检查", self.nowdata.staticData.id)
    end
    local targetRefineLv = self.nowdata.equipInfo.refinelv - 2
    if targetRefineLv < 0 then
      targetRefineLv = 0
    end
    local targetData = ItemData.new("targetData", productID)
    targetData.equipInfo:Clone(self.nowdata.equipInfo)
    targetData.equipInfo.equiplv = 0
    targetData.equipInfo.refinelv = targetRefineLv or 0
    self.targetComposeCell:SetData(targetData)
  else
    self.commonActivePart:SetActive(true)
    self.equipComposePart:SetActive(false)
    self.finishPart:SetActive(false)
    self.upgradeActivePart:SetActive(true)
    self.endSymbol:SetActive(true)
    self.targetBtn:SetActive(true)
    self.levelUpTip:SetActive(true)
    self.composeTip.gameObject:SetActive(false)
  end
  if equipInfo and equipInfo.equipData and equipInfo.equipData.SpiritType then
    self.ancientTip:SetActive(true)
  else
    self.ancientTip:SetActive(false)
  end
  local myClass = MyselfProxy.Instance:GetMyProfession()
  local classDepth = ProfessionProxy.Instance:GetDepthByClassId(myClass)
  local buffids = equipInfo:GetUpgradeBuffIdByEquipLv(curEquipLv + 1)
  local quench = self.nowdata:GetQuenchPer()
  local buffDesc
  if buffids and 0 < #buffids then
    for i = 1, #buffids do
      local buffid = buffids[i]
      local buffInfo = Table_Buffer[buffid]
      if buffInfo then
        buffDesc = ItemUtil.GetBuffDesc(buffInfo.Dsc, quench and quench / 100)
      end
    end
    local canUpgrade, lv = equipInfo:CanUpgrade_ByClassDepth(classDepth, curEquipLv + 1)
    if not canUpgrade then
      buffDesc = string.format(ZhString.ItemTip_NoUpgradeTip, "9d9d9d", ZhString.ChinaNumber[lv])
    elseif curEquipLv + 1 == maxLv then
      local productID = self:GetProductIdOfEquipItem()
      if productID then
        buffDesc = string.format(ZhString.ItemTip_UpEndBuffTip, Table_Item[productID].NameZh, buffDesc)
        self.composeTip.text = string.format(ZhString.EquipCompose_TargetEquip, Table_Item[productID].NameZh)
      end
    end
  end
  self:UpdateDesc(buffDesc, true)
  local canUpgrade, lv = equipInfo:CanUpgrade_ByClassDepth(classDepth, curEquipLv + 1)
  self.upgradeBtn_BoxCollider.enabled = canUpgrade
  if not canUpgrade then
    self:SetTextureGrey(self.upgradeBtn)
  else
    self:SetTextureWhite(self.upgradeBtn, LuaGeometry.GetTempColor(0.6862745098039216, 0.3764705882352941, 0.10588235294117647, 1))
  end
  self.costEquips = self.costEquips or {}
  TableUtility.ArrayClear(self.costEquips)
  if self.materialChooseBord.gameObject.activeSelf then
    self.materialChooseBord:Hide()
  end
  self.upMats = self.upMats or {}
  TableUtility.ArrayClear(self.upMats)
  local _costs = ReusableTable.CreateArray()
  local materialsKey = "Material_" .. curEquipLv + 1
  local cost = upgradeData[materialsKey]
  if self.checkBtn.value then
    local use, has = false, false
    cost, use, has = BlackSmithProxy.Instance:UpdateMaterialListUsingDeduction(cost, GameConfig.PackageMaterialCheck.upgrade)
    if not use then
      if not has then
        MsgManager.ShowMsgByID(28117)
      else
        MsgManager.ShowMsgByID(28118)
      end
      self.checkBtn.value = false
    end
  end
  local costEquipsNum = 0
  local costZeny = 0
  if cost then
    local upgrade_checkBagTypes = BagProxy.Instance:Get_PackageMaterialCheck_BagTypes(BagProxy.MaterialCheckBag_Type.Upgrade)
    for i = 1, #cost do
      local id = cost[i].id
      if id ~= 100 then
        if ItemData.CheckIsEquip(id) then
          self.upMats[id] = cost[i].num
          local equipCount = 0
          local equips = BlackSmithProxy.Instance:GetMaterialEquips_ByEquipId(id, nil, true, self.autoChooseRefineCheckOn and self.AutoChooseFunc or nil, upgrade_checkBagTypes)
          table.sort(equips, function(l, r)
            return self:AutoChooseSort(l, r)
          end)
          for j = 1, #equips do
            if costEquipsNum < cost[i].num then
              local newEquip
              if equips[j].id ~= self.nowdata.id then
                newEquip = equips[j]:Clone()
              elseif 1 < equips[j].num then
                newEquip = equips[j]:Clone()
                newEquip.num = newEquip.num - 1
              end
              if newEquip then
                costEquipsNum = newEquip.num + costEquipsNum
                if costEquipsNum > cost[i].num then
                  newEquip.num = newEquip.num - (costEquipsNum - cost[i].num)
                  xdlog("溢出了数量", costEquipsNum - cost[i].num)
                end
                equipCount = equipCount + newEquip.num
                table.insert(self.costEquips, newEquip)
                xdlog("costEquip 添加", id, newEquip.id, newEquip.num)
              end
            end
          end
          local targetEquip, equipData
          equipData = ItemData.new(MaterialItemCell.MaterialType.ChooseItem, id)
          equipData.neednum = cost[i].num
          equipData.num = equipCount
          if cost[i].deduction then
            equipData.deduction = cost[i].deduction
            equipData.ori_neednum = cost[i].ori_num
          end
          table.insert(_costs, equipData)
        else
          local matData = ItemData.new(MaterialItemCell.MaterialType.Material, id)
          matData.num = BagProxy.Instance:GetItemNumByStaticID(id, GameConfig.PackageMaterialCheck.upgrade)
          matData.neednum = cost[i].num
          if cost[i].deduction then
            matData.deduction = cost[i].deduction
            matData.ori_neednum = cost[i].ori_num
          end
          table.insert(_costs, matData)
        end
      else
        costZeny = costZeny + cost[i].num
      end
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
  self.autoChooseRefineCheckOn = false
  self:UpdateCostZeny(costZeny)
  self:UpdateLackItems()
  self.upgradeBtn_Label.text = 0 < #self.lackItems and ZhString.EquipUpgradePopUp_QuickBuy or ZhString.EquipUpgradePopUp_Upgrade
  ReusableTable.DestroyAndClearArray(_costs)
end

function EquipUpgradeView.AutoChooseFunc(equip)
  if equip and equip.equipInfo and equip.equipInfo.refinelv and equip.equipInfo.refinelv > 0 then
    return false
  end
  local equipCards = equip and equip.equipedCardInfo
  if equipCards and 0 < #equipCards then
    return false
  end
  local equiplv = equip and equip.equipInfo.equiplv
  if 0 < equiplv then
    return false
  end
  return true
end

function EquipUpgradeView:AutoChooseSort(l, r)
  local l_isNew = l.isNew and 1 or 0
  local r_isNew = r.isNew and 1 or 0
  if l_isNew ~= r_isNew then
    return l_isNew > r_isNew
  end
  local l_isPrior = 0 < TableUtility.ArrayFindIndex(self.priorChooseList, l.id) and 1 or 0
  local r_isPrior = 0 < TableUtility.ArrayFindIndex(self.priorChooseList, r.id) and 1 or 0
  if l_isPrior ~= r_isPrior then
    return l_isPrior > r_isPrior
  end
end

function EquipUpgradeView:UpdateEquipComposeInfo()
  self.title.text = ISNoviceServerType and ZhString.EquipUpgradeView_Title or ZhString.EquipCompose_Title
  if not self.nowdata then
    return
  end
  local composeData = EquipComposeProxy.Instance:GetComposeDataByMainMatID(self.nowdata.staticData.id)
  if not composeData then
    redlog("该装备无灌注进化路线，请检查")
    return
  end
  local equipInfo = self.nowdata.equipInfo
  local curEquipLv = equipInfo and equipInfo.equiplv
  if curEquipLv ~= composeData.lv then
    redlog("等级不符合  检查代码")
    return
  end
  self.commonActivePart:SetActive(true)
  self.finishPart:SetActive(false)
  self.composeActivePart:SetActive(true)
  self.levelUpTip:SetActive(false)
  self.composeTip.gameObject:SetActive(true)
  local composeID = composeData.composeID
  local targetItemData = Table_Item[composeID]
  self:UpdateDesc(string.format(ZhString.EquipCompose_TargetEquip, targetItemData and targetItemData.NameZh))
  self.nextEffectLv_Label.gameObject:SetActive(false)
  self.composeTip.text = string.format(ZhString.EquipCompose_TargetEquip, targetItemData and targetItemData.NameZh)
  local cost = {}
  local commonMats = self.curComposeData.material
  for k, v in pairs(commonMats) do
    local singleData = {id = k, num = v}
    table.insert(cost, singleData)
  end
  if self.checkBtn.value then
    local use, has = false, false
    cost, use, has = BlackSmithProxy.Instance:UpdateMaterialListUsingDeduction(cost, GameConfig.PackageMaterialCheck.upgrade)
    if not use then
      if not has then
        MsgManager.ShowMsgByID(28117)
      else
        MsgManager.ShowMsgByID(28118)
      end
      self.checkBtn.value = false
    end
  end
  local _costs = ReusableTable.CreateArray()
  self.refData = {}
  if cost and 0 < #cost then
    local compose_checkBagTypes = BagProxy.Instance:Get_PackageMaterialCheck_BagTypes(BagProxy.MaterialCheckBag_Type.Upgrade)
    for i = 1, #cost do
      local id = cost[i].id
      if ItemData.CheckIsEquip(id) then
        local costEquipNum = 0
        local targetCount = cost[i].num
        local equips = BlackSmithProxy.Instance:GetMaterialEquips_ByEquipId(id, nil, true, nil, compose_checkBagTypes)
        for j = 1, #equips do
          if costEquipNum < targetCount then
            local newEquip
            if self:matCheckFunc(equips[j]) then
              if equips[j].num < targetCount - costEquipNum then
                newEquip = equips[j]:Clone()
              else
                newEquip = equips[j]:Clone()
                newEquip.num = targetCount - costEquipNum
              end
              if newEquip then
                costEquipNum = costEquipNum + newEquip.num
                self.curComposeData:SetChooseMat(id, newEquip)
                if not self.refData[id] then
                  self.refData[id] = {}
                end
                table.insert(self.refData[id], newEquip)
                xdlog("添加已选择的装备", id, newEquip.id, newEquip.num)
              end
            end
          end
        end
        local equipData = ItemData.new("Mat", id)
        equipData.neednum = cost[i].num
        equipData.num = self.curComposeData:GetChooseMatCount(id)
        if cost[i].deduction then
          equipData.deduction = cost[i].deduction
          equipData.ori_neednum = cost[i].ori_num
        end
        table.insert(_costs, equipData)
      else
        local matData = ItemData.new(MaterialItemCell.MaterialType.Material, id)
        matData.num = BagProxy.Instance:GetItemNumByStaticID(id, GameConfig.PackageMaterialCheck.equipcompose)
        matData.neednum = cost[i].num
        if cost[i].deduction then
          matData.deduction = cost[i].deduction
          matData.ori_neednum = cost[i].ori_num
        end
        table.insert(_costs, matData)
      end
    end
  end
  table.sort(_costs, function(l, r)
    local l_IsEquip = l:IsEquip() and 1 or 0
    local r_IsEquip = r:IsEquip() and 1 or 0
    if l_IsEquip ~= r_IsEquip then
      return l_IsEquip > r_IsEquip
    end
  end)
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
  local costZeny = self.curComposeData.cost
  self:UpdateCostZeny(costZeny)
  self:UpdateLackItems()
  self.upgradeBtn_Label.text = #self.lackItems > 0 and ZhString.EquipUpgradePopUp_QuickBuy or ZhString.EquipUpgradePopUp_Upgrade
  ReusableTable.DestroyAndClearArray(_costs)
end

function EquipUpgradeView:InsertOrAddNum(array, item, idKey, numKey)
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

function EquipUpgradeView:GetProductIdOfEquipItem()
  local equipInfo = self:GetEquipInfoOfEquipItem()
  if not equipInfo then
    return
  end
  local upgradeData = equipInfo.upgradeData
  if not upgradeData then
    return
  end
  return upgradeData.Product
end

function EquipUpgradeView:GetEquipInfoOfEquipItem()
  if not self.nowdata then
    return
  end
  return self.nowdata.equipInfo
end

function EquipUpgradeView:GetCurLvOfEquipItem()
  local equipInfo = self:GetEquipInfoOfEquipItem()
  if not equipInfo then
    return
  end
  return equipInfo.equiplv
end

function EquipUpgradeView:GetUpgradeMaxLvOfEquipItem()
  local equipInfo = self:GetEquipInfoOfEquipItem()
  if not equipInfo then
    return
  end
  return equipInfo.upgrade_MaxLv
end

function EquipUpgradeView:GetExpectedMaxLvOfEquipItem()
  local equipInfo = self:GetEquipInfoOfEquipItem()
  if not equipInfo then
    return
  end
  local lv = 0
  while equipInfo:GetUpgradeMaterialsByEquipLv(lv + 1) ~= nil do
    lv = lv + 1
  end
  return lv
end

function EquipUpgradeView:UpdateLackItems()
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

function EquipUpgradeView:DoUpgrade()
  self.productID = nil
  self:UpdateLackItems()
  if self.lackItems and #self.lackItems > 0 and QuickBuyProxy.Instance:TryOpenView(self.lackItems, QuickBuyProxy.QueryType.NoDamage, true) then
    return
  end
  if MyselfProxy.Instance:GetROB() < self:GetCurCostZeny() then
    MsgManager.ShowMsgByID(1)
    return
  end
  local confirmHandler = function()
    self:_DoUpgrade()
  end
  local targetEquips = {}
  for i = 1, #self.costEquips do
    if 0 < self.costEquips[i].num then
      table.insert(targetEquips, self.costEquips[i])
    end
  end
  local needRecover, tipEquips = FunctionItemFunc.RecoverEquips(targetEquips)
  if needRecover then
    return
  end
  if 0 < #tipEquips then
    MsgManager.ConfirmMsgByID(247, confirmHandler, nil, nil, tipEquips[1].equipInfo.refinelv)
    return
  end
  if self:GetCurLvOfEquipItem() >= self:GetUpgradeMaxLvOfEquipItem() then
    xdlog("对比有异常", self:GetCurLvOfEquipItem(), self:GetUpgradeMaxLvOfEquipItem())
    local productID = self:GetProductIdOfEquipItem()
    if productID then
      self.productID = productID
    end
    xdlog("目标产物", productID)
    MsgManager.ConfirmMsgByID(25402, confirmHandler, nil, nil, Table_Item[productID].NameZh)
    return
  end
  confirmHandler()
end

function EquipUpgradeView:_DoUpgrade()
  local chooseMat = {}
  local needCheckAgain = false
  for i = 1, #self.costEquips do
    if self.costEquips[i].num > 0 then
      table.insert(chooseMat, {
        guid = self.costEquips[i].id,
        num = self.costEquips[i].num
      })
      xdlog("手动选材料", self.costEquips[i].id, self.costEquips[i].num)
      if 0 < self.costEquips[i].equipInfo.refinelv then
        needCheckAgain = true
      end
    end
  end
  local func = function()
    ServiceItemProxy.Instance:CallEquipExchangeItemCmd(self.nowdata.id, SceneItem_pb.EEXCHANGETYPE_LEVELUP, chooseMat, nil, 1, self.checkBtn.value)
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
  if needCheckAgain then
    MsgManager.DontAgainConfirmMsgByID(544, func)
  else
    func()
  end
end

function EquipUpgradeView:DoCompose()
  xdlog("执行魔能灌注")
  local curData = self.curComposeData
  if not curData then
    redlog("没有灌注目标")
    return
  end
  self:UpdateLackItems()
  if self.lackItems and #self.lackItems > 0 and QuickBuyProxy.Instance:TryOpenView(self.lackItems, QuickBuyProxy.QueryType.NoDamage) then
    return
  end
  if MyselfProxy.Instance:GetROB() < self:GetCurCostZeny() then
    MsgManager.ShowMsgByID(1)
    return
  end
  if self.curComposeData:IsMatLimited() then
    MsgManager.ShowMsgByID(40013)
    return
  end
  local chooseMat = self.curComposeData.chooseMat
  local serverList = {}
  local testStr = ""
  for equipID, list in pairs(chooseMat) do
    for guid, num in pairs(list) do
      if 0 < num then
        table.insert(serverList, guid)
      end
    end
  end
  local mainMatGuid = self.curComposeData:GetMainChooseMat()
  if mainMatGuid then
    local mainItem = BagProxy.Instance:GetItemByGuid(mainMatGuid)
    if mainItem and mainItem.equipInfo and mainItem.equipInfo.damage then
      MsgManager.ShowMsgByID(40023)
      return
    end
    TableUtility.ArrayPushFront(serverList, mainMatGuid)
  end
  xdlog("灌注目标", curData.composeID)
  local sysmsgData = Table_Sysmsg[26001]
  local text = sysmsgData.Text
  local str = string.format(text, curData.itemStaticData.NameZh)
  UIUtil.PopUpConfirmYesNoView(sysmsgData.Title, str, function()
    ServiceItemProxy.Instance:CallEquipComposeItemCmd(curData.composeID, serverList, nil, self.checkBtn.value)
  end, nil, nil, sysmsgData.button, sysmsgData.buttonF)
end

function EquipUpgradeView:UpdateCostZeny(zeny)
  self.curCostZeny = zeny
  self.zenyCostLabel.text = StringUtil.NumThousandFormat(zeny)
  self.zenyCostLabel.color = zeny > MyselfProxy.Instance:GetROB() and ColorUtil.Red or LuaGeometry.GetTempVector4(0.3333333333333333, 0.3568627450980392, 0.43137254901960786, 1)
end

function EquipUpgradeView:GetCurCostZeny()
  return self.curCostZeny and tonumber(self.curCostZeny) or 0
end

function EquipUpgradeView:OnZenyChange()
  self:UpdateCostZeny(self:GetCurCostZeny())
end

function EquipUpgradeView:UpdateCoins()
  self.robLabel.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetROB())
end

function EquipUpgradeView:handleItemUpdate()
  self.funcValidTime = ServerTime.CurServerTime() / 1000 + 0.5
  if self.curChooseEquipMaterialId then
    local item = BagProxy.Instance:GetItemByGuid(self.curChooseEquipMaterialId)
    if not item then
      self.curChooseEquipMaterialId = nil
    end
  end
  if self.composeMatChooseBord.gameObject.activeSelf then
    self.composeMatChooseBord:Hide()
  end
  local guid = self.nowdata and self.nowdata.id
  local item = BagProxy.Instance:GetItemByGuid(guid)
  if guid and not item then
    local targetID
    if self.productID then
      targetID = self.productID
    elseif self.curComposeData then
      targetID = self.curComposeData.composeID
    end
    local equipInfo = self.nowdata.equipInfo
    local hasenchant = self.nowdata.enchantInfo and self.nowdata.enchantInfo:HasAttri() or false
    local hasCard = false
    local equipedCards = self.nowdata.equipedCardInfo
    if equipedCards then
      for i = 1, self.nowdata.cardSlotNum do
        if equipedCards[i] then
          hasCard = true
          break
        end
      end
    end
    local refineLv = equipInfo.refinelv
    local targetRefineLv = refineLv - 2 > 0 and refineLv - 2 or 0
    local isDamage = equipInfo.damage
    if targetID then
      local items = BagProxy.Instance:GetMaterialItems_ByItemId(targetID, _PACKAGECHECK)
      if items and 0 < #items then
        for i = 1, #items do
          local equip = items[i]
          if equip and equip.equipInfo and equip.equipInfo.equiplv == 0 then
            local _refineLv = equip.equipInfo.refinelv
            if targetRefineLv == _refineLv then
              local _hasenchant = equip.enchantInfo and equip.enchantInfo:HasAttri() or false
              local _isDamage = equip.equipInfo.damage
              local _hasCard = false
              local _equipedCards = equip.equipedCardInfo
              if _equipedCards then
                for j = 1, equip.cardSlotNum do
                  if _equipedCards[j] then
                    _hasCard = true
                    break
                  end
                end
              end
              if _hasenchant == hasenchant and hasCard == _hasCard and isDamage == _isDamage and not equip:IsExtraction() then
                GameFacade.Instance:sendNotification(ItemEvent.EquipUpgradeSuccess, equip)
                self:ChooseItem(equip)
                return
              end
            end
          end
        end
      end
      self:ChooseItem()
    else
      self:ChooseItem()
    end
    return
  end
  self.autoChooseRefineCheckOn = false
  self:ChooseItem(item)
end

function EquipUpgradeView:clickMaterial(cell)
  local data = cell.data
  if data == nil then
    return
  end
  self:ShowItemInfo(cell)
end

function EquipUpgradeView:HandleClickMaterialMat(cell)
  if self.isCompose then
    self:clickComposeEquipMat(cell)
  else
    self:ShowChooseMaterialBord(cell)
  end
end

function EquipUpgradeView:HandleClickUpgradeEquipMat(cell)
  self:ShowChooseMaterialBord(cell)
end

function EquipUpgradeView:ShowChooseMaterialBord(cellCtrl)
  local data = cellCtrl.data
  if data == nil then
    return
  end
  if not self.nowdata then
    return
  end
  local id = data.id
  local equipID = data.staticData.id
  local upgrade_checkBagTypes = BagProxy.Instance:Get_PackageMaterialCheck_BagTypes(BagProxy.MaterialCheckBag_Type.Upgrade)
  local equips = BlackSmithProxy.Instance:GetMaterialEquips_ByEquipId(equipID, nil, true, nil, upgrade_checkBagTypes)
  table.sort(equips, function(l, r)
    return self:AutoChooseSort(l, r)
  end)
  local equipList = {}
  for i = 1, #equips do
    local newEquip
    if equips[i].id == self.nowdata.id then
      if 1 < equips[i].num then
        newEquip = equips[i]:Clone()
        newEquip.num = newEquip.num - 1
      end
    else
      newEquip = equips[i]:Clone()
    end
    table.insert(equipList, newEquip)
  end
  local checkFunc = function(cell)
    local item = cell.data
    if not item then
      return false
    end
    return self:matCheckFunc(item)
  end
  self.materialChooseBord:Show(nil, nil, nil, nil, nil, nil, checkFunc)
  self.chooseInited = false
  self.materialChooseBord:ResetDatas(equipList)
  self.chooseInited = true
  self.materialChooseBord:SetChooseReference(self.costEquips, self.costEquips)
end

function EquipUpgradeView:OnUpgradeMatCountChooseChange(cell)
  if not cell then
    return
  end
  local data, chooseCount = cell.data, cell.chooseCount
  if not data then
    return
  end
  if not self.chooseInited then
    return
  end
  local targetCount = self.upMats[data.staticData.id] or 0
  local curCount = 0
  for i = 1, #self.costEquips do
    local single = self.costEquips[i]
    curCount = curCount + single.num
  end
  local isUpdate = false
  for i = 1, #self.costEquips do
    local single = self.costEquips[i]
    if single.id == data.id then
      local offsetCount = cell.chooseCount - single.num
      if targetCount >= curCount + offsetCount then
        single.num = cell.chooseCount
        isUpdate = true
      else
        local otherCount = 0
        for j = 1, #self.costEquips do
          if self.costEquips[j].id ~= single.id then
            otherCount = otherCount + self.costEquips[j].num
          end
        end
        cell:SetChooseCount(targetCount - otherCount)
        self:OnUpgradeMatCountChooseChange(cell)
        return
      end
    end
  end
  if not isUpdate and 0 < chooseCount then
    if targetCount >= curCount + cell.chooseCount then
      local itemData = data:Clone()
      itemData.num = cell.chooseCount
      table.insert(self.costEquips, itemData)
      xdlog("添加装备", itemData.id, itemData.num)
    else
      cell:SetChooseCount(targetCount - curCount)
      self:OnUpgradeMatCountChooseChange(cell)
      return
    end
  end
  curCount = 0
  for i = 1, #self.costEquips do
    curCount = curCount + self.costEquips[i].num
  end
  if targetCount <= curCount then
    self.materialChooseBord:SetCellPlusValid(false)
  else
    self.materialChooseBord:SetCellPlusValid(true)
  end
  local cells = self.materialCtrl:GetCells()
  for i = 1, #cells do
    local cell = cells[i]
    if cell.data and cell.data.staticData.id == data.staticData.id then
      local tempData = cell.data
      tempData.num = curCount
      cell:SetData(tempData)
    end
  end
  self:UpdateLackItems()
  self.upgradeBtn_Label.text = 0 < #self.lackItems and ZhString.EquipUpgradePopUp_QuickBuy or ZhString.EquipUpgradePopUp_Upgrade
end

function EquipUpgradeView:OnClickUpgradeMatCheck(cell)
  if not cell then
    redlog("找不到目标")
    return
  end
  local chooseCount = cell.chooseCount or 0
  if chooseCount == 0 then
    return
  end
  local targetEquipItems = {}
  table.insert(targetEquipItems, cell.data)
  local cancelCall = function()
    if not cell then
      return
    end
    cell:SetChooseCount(0)
    self:OnUpgradeMatCountChooseChange(cell)
  end
  local confirmCall = function()
    local guid = cell and cell.data and cell.data.id
    if TableUtility.ArrayFindIndex(self.priorChooseList, guid) == 0 then
      TableUtility.ArrayPushBack(self.priorChooseList, guid)
    end
  end
  local needRecover, tipEquips = FunctionItemFunc.RecoverEquips(targetEquipItems, confirmCall, cancelCall)
  if needRecover then
    return
  end
  xdlog("检测错误  请检查代码")
end

function EquipUpgradeView:ShowItemInfo(cellCtrl)
  local data = cellCtrl.data
  if data == nil then
    return
  end
  local sdata = {
    itemdata = data,
    funcConfig = {}
  }
  self:ShowItemTip(sdata, cellCtrl.icon, nil, {-280, 0})
end

function EquipUpgradeView:clickComposeEquipMat(cell)
  local data = cell.data
  if data == nil then
    return
  end
  if data.id == MaterialItemCell.MaterialType.Material then
    self:ShowItemInfo(cell)
  else
    self:ShowComposeEquipMatBord(cell)
  end
end

function EquipUpgradeView:ShowItemInfo(cellCtrl)
  local data = cellCtrl.data
  if data == nil then
    return
  end
  local sdata = {
    itemdata = data,
    funcConfig = {}
  }
  self:ShowItemTip(sdata, self.tipStick, nil, {-190, 0})
end

function EquipUpgradeView:matCheckFunc(item)
  if not item then
    return false
  end
  for i = 1, #self.costEquips do
    if self.costEquips[i].id == item.id and self.costEquips[i].num == item.num then
      return true
    end
  end
  local equipInfo = item.equipInfo
  local hasenchant = item.enchantInfo and item.enchantInfo:HasAttri() or false
  local hasupgrade = equipInfo.equiplv > 0
  local hasCard = false
  local equipedCards = item.equipedCardInfo
  if equipedCards then
    for i = 1, item.cardSlotNum do
      if equipedCards[i] then
        hasCard = true
        break
      end
    end
  end
  if hasenchant or hasupgrade or hasCard then
    redlog("装备非白版 需要检测")
    return false
  end
  return true
end

function EquipUpgradeView:ShowComposeEquipMatBord(cellCtrl)
  xdlog("点击灌注装备查看")
  local data = cellCtrl.data
  if data == nil then
    return
  end
  if not self.nowdata then
    return
  end
  local id = data.id
  local equipID = data.staticData.id
  local compose_checkBagTypes = BagProxy.Instance:Get_PackageMaterialCheck_BagTypes(BagProxy.MaterialCheckBag_Type.EquipCompose)
  local equips = BlackSmithProxy.Instance:GetMaterialEquips_ByEquipId(equipID, nil, true, nil, compose_checkBagTypes)
  local checkFunc = function(cell)
    local item = cell.data
    if not item then
      return false
    end
    return self:matCheckFunc(item)
  end
  self.composeMatChooseBord:Show(nil, nil, nil, nil, nil, nil, checkFunc)
  self.chooseInited = false
  self.composeMatChooseBord:ResetDatas(equips)
  self.chooseInited = true
  local refData = self.refData[equipID]
  self.composeMatChooseBord:SetChooseReference(refData)
  self.equipMainMatChooseBord:Hide()
end

function EquipUpgradeView:handleLongPress(cell)
  local data = cell.data
  if data == nil then
    return
  end
  local sdata = {
    itemdata = data,
    funcConfig = {}
  }
  self:ShowItemTip(sdata, self.targetCell.icon, NGUIUtil.AnchorSide.Left, {-200, 0})
end

function EquipUpgradeView:ChooseMainMat(itemData)
  if not itemData then
    redlog("无装备信息")
    return
  end
  if itemData.id == "BuyItem" then
    xdlog("跳转购买")
    self.equipMainMatChooseBord:Hide()
    self.equipMainMatChooseBord:SetChoose()
    local compose_checkBagTypes = BagProxy.Instance:Get_PackageMaterialCheck_BagTypes(BagProxy.MaterialCheckBag_Type.Upgrade)
    local equips = BlackSmithProxy.Instance:GetMaterialEquips_ByEquipId(itemData.staticData.id, nil, false, nil, compose_checkBagTypes)
    local lackLvEquip
    local targetLv = itemData.equipInfo.equiplv
    for i = 1, #equips do
      local equiplv = equips[i].equipInfo and equips[i].equipInfo.equiplv
      if not lackLvEquip then
        lackLvEquip = equips[i]
      elseif equiplv > lackLvEquip.equipInfo.equiplv then
        lackLvEquip = equips[i]
      end
    end
    local levelUpCount = lackLvEquip and lackLvEquip.equipInfo.equiplv and targetLv - lackLvEquip.equipInfo.equiplv
    local lackItems = {}
    local costs, costZeny = EquipUtil.CalcEquipUpgradeCost(itemData.staticData.id, targetLv)
    for i = 1, #costs do
      local ownNum = BagProxy.Instance:GetItemNumByStaticID(costs[i].id, compose_checkBagTypes)
      if ownNum < costs[i].num then
        local lackItem = {
          id = costs[i].id,
          count = costs[i].num - ownNum
        }
        TableUtility.ArrayPushBack(lackItems, lackItem)
      end
    end
    if lackLvEquip then
      self:ChooseItem(lackLvEquip)
    end
    if 0 < #lackItems then
      QuickBuyProxy.Instance:TryOpenView(lackItems, QuickBuyProxy.QueryType.NoDamage, true)
      return
    end
    return
  end
  if self.curComposeData and self.curComposeData.mainMatID ~= itemData.staticData.id then
    self:ChooseItem(itemData)
    self.equipMainMatChooseBord:Hide()
    return
  end
  self.equipMainMatChooseBord:Hide()
  self.curComposeData:SetMainChooseMat(itemData.id)
  self.equipMainMatChooseBord:SetChoose(self.nowdata)
  self.nowdata = itemData
  self.curEquipCell:SetData(itemData)
  self.curEquipCell:SetIconlocked(false)
end

function EquipUpgradeView:ClickMainMatCell(cell)
  if self.lockEquipCompose then
    xdlog("锁定灌注  打开面板 ")
    self:ShowMainMatChooseBord()
  else
    self:ClickTargetCell()
  end
end

function EquipUpgradeView:ShowMainMatChooseBord()
  xdlog("主材料候选")
  if not self.curComposeData then
    redlog("没有灌注信息")
    return
  end
  local mainMatID = self.curComposeData.mainMatID
  local mainMatIDs = {}
  table.insert(mainMatIDs, mainMatID)
  local replaceID = math.floor(mainMatID % 100000)
  if replaceID == mainMatID then
    replaceID = 100000 + mainMatID
  end
  local tempComposeData = EquipComposeProxy.Instance:GetComposeDataByMainMatID(replaceID)
  if tempComposeData then
    xdlog("异孔装备存在", replaceID, mainMatID)
    table.insert(mainMatIDs, replaceID)
  end
  local _BagProxy = BagProxy.Instance
  local result = {}
  for i = 1, #_PACKAGECHECK do
    local items = _BagProxy:GetBagByType(_PACKAGECHECK[i]):GetItems()
    for j = 1, #items do
      local equip = items[j]
      local valid = false
      if TableUtility.ArrayFindIndex(mainMatIDs, equip.staticData.id) > 0 then
        local composeData = EquipComposeProxy.Instance:GetComposeDataByMainMatID(equip.staticData.id)
        if composeData then
          local level = composeData.lv
          if equip.equipInfo and equip.equipInfo.equiplv == level then
            valid = true
          end
        end
      end
      if valid then
        TableUtility.ArrayPushBack(result, equip)
      end
    end
  end
  self.composeMatChooseBord:Hide()
  if 0 < #result then
    self.equipMainMatChooseBord:Show()
    self.equipMainMatChooseBord:ResetDatas(result)
    self.equipMainMatChooseBord:SetChoose(self.nowdata)
    local cells = self.equipMainMatChooseBord.chooseCtl:GetCells()
    for i = 1, #cells do
      cells[i]:SetChooseButtonText(ZhString.PersonalArtifact_FormulaChoose)
    end
  else
    xdlog("没有候选，  添加购买")
    local buyList = {}
    for i = 1, #mainMatIDs do
      local tempData = ItemData.new("BuyItem", mainMatIDs[i])
      local composeData = EquipComposeProxy.Instance:GetComposeDataByMainMatID(mainMatIDs[i])
      tempData.equipInfo.equiplv = composeData and composeData.lv
      table.insert(buyList, tempData)
    end
    self.equipMainMatChooseBord:Show()
    self.equipMainMatChooseBord:ResetDatas(buyList)
    local cells = self.equipMainMatChooseBord.chooseCtl:GetCells()
    for i = 1, #cells do
      cells[i]:SetChooseButtonText(ZhString.EquipUpgradeView_Purchanse)
    end
  end
end
