autoImport("EquipMfrChooseBord")
autoImport("MakeMaterialCell")
autoImport("TipLabelCell")
EquipMfrView = class("EquipMfrView", ContainerView)
EquipMfrView.ViewType = UIViewType.NormalLayer
autoImport("CommonCombineView")
EquipMfrView.BrotherView = CommonCombineView
EquipMfrView.ClickMaterialQuickMake = "EquipMfrView_ClickMaterialQuickMake"
local _PACKAGECHECK = {
  2,
  1,
  20
}

function EquipMfrView:OnEnter()
  EquipMfrView.super.OnEnter(self)
  EquipMakeProxy.Instance:InitMakeList()
  if self.viewdata.viewdata.toggleSelfProfession ~= nil and self.choosebord then
    self.choosebord:SetToggleSelfProfession(self.viewdata.viewdata.toggleSelfProfession)
  end
  if self.viewdata.viewdata.OnClickChooseBordCell_data then
    self:ChooseItem(self.viewdata.viewdata.OnClickChooseBordCell_data)
  elseif self.viewdata.viewdata.composeid then
    local data = EquipMakeData.new(self.viewdata.viewdata.composeid)
    self:ChooseItem(data)
  elseif self.viewdata.viewdata.equipid then
    local targetComposeId
    local table_compose = EquipMakeProxy.Instance:GetComposeTable()
    for _, d in pairs(table_compose) do
      if d.Product and d.Product.id == self.viewdata.viewdata.equipid and d.Type == 2 and d.Category == 1 and d.BeCostItem then
        targetComposeId = d.id
        break
      end
    end
    if targetComposeId then
      local data = EquipMakeData.new(targetComposeId)
      self:ChooseItem(data)
    end
  else
    self:ChooseItem()
  end
  self:UpdateCoins()
end

function EquipMfrView:OnShow()
  Game.Myself:UpdateEpNodeDisplay(true)
end

function EquipMfrView:OnExit()
  EquipMakeProxy.Instance:ResetCategoryActive()
  EquipMfrView.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
  self.particleSystems = nil
end

function EquipMfrView:Init()
  local viewdata = self.viewdata.viewdata
  self.npcdata = viewdata and viewdata.npcdata
  self.isCombine = viewdata and viewdata.isCombine
  self.maxcount = 99
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:AddMapEvts()
  self:InitView()
end

function EquipMfrView:FindObjs()
  self.closeButton = self:FindGO("CloseButton")
  self.closeButton:SetActive(self.isCombine ~= true)
  self.addItemButton = self:FindGO("AddItemButton")
  self.left = self:FindGO("LeftBg")
  self.targetBtn = self:FindGO("TargetCell")
  self.costInfo = self:FindGO("ZenyCost")
  self.zenyCostLabel = self:FindGO("ZenyCostLabel"):GetComponent(UILabel)
  local sprite = self:FindComponent("Sprite", UISprite, self.zenyCostLabel.gameObject)
  IconManager:SetItemIcon(Table_Item[GameConfig.MoneyId.Zeny].Icon, sprite)
  self.costInfo:SetActive(false)
  self.helpBtn = self:FindGO("HelpBtn")
  local coins = self:FindChild("TopCoins")
  self.userRob = self:FindChild("Silver", coins)
  self.robLabel = self:FindComponent("Label", UILabel, self.userRob)
  local symbol = self:FindComponent("symbol", UISprite, self.userRob)
  IconManager:SetItemIcon(Table_Item[GameConfig.MoneyId.Zeny].Icon, symbol)
  self.targetBtn:SetActive(false)
  self:PlayUIEffect(EffectMap.UI.EquipMfrView_Bg, self:FindGO("RightBg"), nil, function(obj, args, assetEffect)
    local effect = assetEffect
    effect:ResetLocalPositionXYZ(1.42, 183.7, 0)
    local ps = effect.effectObj:GetComponentsInChildren(ParticleSystem, true)
    self.particleSystems = {}
    for i = 1, #ps do
      table.insert(self.particleSystems, ps[i])
      ps[i].gameObject:SetActive(self.nowdata ~= nil)
    end
  end)
  local chooseContaienr = self:FindGO("ChooseContainer")
  self.chooseBord = EquipMfrChooseBord.new(chooseContaienr)
  self.chooseBord:SetFilterPopData(GameConfig.EquipMfrType)
  self.chooseBord:AddEventListener(EquipMfrChooseBord.ChooseItem, self.ChooseItem, self)
  self.chooseBord:Hide()
  self.targetCell = BaseItemCell.new(self.targetBtn)
  self.targetCell:AddEventListener(MouseEvent.MouseClick, self.ClickTargetCell, self)
  local longPress = self.targetBtn:AddComponent(UILongPress)
  longPress.pressTime = 0.5
  
  function longPress.pressEvent(obj, isPress)
    if isPress then
      self:handleLongPress()
    end
  end
  
  function self.targetCell.UpdateStrengthLevel()
  end
  
  self.activePart = self:FindGO("ActivePart")
  self.materialPart = self:FindGO("MaterialsPart")
  self.makeTitle = self:FindGO("TIPLabel", self.materialPart):GetComponent(UILabel)
  self.materialScrollView = self:FindGO("MaterialScrollView", self.materialPart):GetComponent(UIScrollView)
  self.materialGrid = self:FindGO("MaterialGrid", self.materialPart):GetComponent(UIGrid)
  self.makeMatCtl = UIGridListCtrl.new(self.materialGrid, MakeMaterialCell, "EquipMfrMakeMaterialCell")
  self.makeMatCtl:AddEventListener(MouseEvent.MouseClick, self.clickMaterial, self)
  self.makeMatCtl:AddEventListener(EquipMfrView.ClickMaterialQuickMake, self.clickMaterialQuickMake, self)
  self.mfrBtn = self:FindGO("MfrBtn")
  self.mfrBtn_BoxCollider = self.mfrBtn:GetComponent(BoxCollider)
  self.mfrBtn_Label = self.mfrBtn:GetComponentInChildren(UILabel)
  self.mfrBtn_Label.text = ZhString.EquipMake_Make
  self.quickBuyBtn = self:FindGO("QuickBuyBtn")
  self.quickBuyBtn_Label = self:FindGO("QuickBuyLabel", self.quickBuyBtn):GetComponent(UILabel)
  self.quickBuyBtn_BoxCollider = self.quickBuyBtn:GetComponent(BoxCollider)
  self.countPlusBg = self:FindGO("CountPlusBg"):GetComponent(UISprite)
  self.countPlus = self:FindGO("Plus", self.countPlusBg.gameObject):GetComponent(UISprite)
  self.countSubtractBg = self:FindGO("CountSubtractBg"):GetComponent(UISprite)
  self.countSubtract = self:FindGO("Subtract", self.countSubtractBg.gameObject):GetComponent(UISprite)
  self.countInput = self:FindGO("CountBg"):GetComponent(UIInput)
  self.countInput.value = 1
  self.liziParent = self:FindGO("lizi")
  self:PlayUIEffect(EffectMap.UI.EquipMakeView, self.liziParent)
  self.tip = self:FindGO("Tip"):GetComponent(UILabel)
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
    self:UpdateItem()
    self:UpdateCost()
  end)
  self.attriScrollView = self:FindGO("InfoScrollView"):GetComponent(UIScrollView)
  self.attriTable = self:FindComponent("AttriTable", UITable)
  self.attriCtl = UIGridListCtrl.new(self.attriTable, TipLabelCell, "TipLabelCell")
  self.contextDatas = {}
end

function EquipMfrView:InitView()
  self.successTip_Label.text = ZhString.EquipMake_Success
  local printX = self.successTip_Label.printedSize.x
  self.successSymbol.transform.localPosition = LuaGeometry.GetTempVector3(-printX / 2 - 20, 0, 0)
  self.showDescDetail = false
end

function EquipMfrView:AddEvts()
  self:AddClickEvent(self.addItemButton, function(go)
    self:ClickTargetCell()
  end)
  self:AddClickEvent(self.targetBtn, function(go)
    self:ClickTargetCell()
  end)
  self:TryOpenHelpViewById(35, nil, self.helpBtn)
  self:AddClickEvent(self.mfrBtn, function()
    FunctionSecurity.Me():NormalOperation(function()
      self:DoMakeEquip()
    end)
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
  self:AddClickEvent(self.quickBuyBtn, function()
    self:DoBuyItem()
  end)
end

function EquipMfrView:AddMapEvts()
  self:AddListenEvt(MyselfEvent.ZenyChange, self.OnZenyChange)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.handleItemUpdate)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateCoins)
end

function EquipMfrView:AddViewEvts()
end

function EquipMfrView:PlusPressCount(isPressed)
  if isPressed then
    self.countChangeRate = 1
    TimeTickManager.Me():CreateTick(0, 150, function(owner, deltaTime)
      self:UpdateCount(1)
    end, self, 1001)
  else
    TimeTickManager.Me():ClearTick(self, 1001)
  end
end

function EquipMfrView:SubtractPressCount(isPressed)
  if isPressed then
    self.countChangeRate = 1
    TimeTickManager.Me():CreateTick(0, 150, function(owner, deltaTime)
      self:UpdateCount(-1)
    end, self, 1002)
  else
    TimeTickManager.Me():ClearTick(self, 1002)
  end
end

function EquipMfrView:UpdateCount(change)
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
  self:UpdateItem()
  self:UpdateCost()
end

function EquipMfrView:InputOnChange()
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
  self:UpdateItem()
  self:UpdateCost()
end

function EquipMfrView:SetCountPlus(alpha)
  if self.countPlusBg.color.a ~= alpha then
    self:SetSpritAlpha(self.countPlusBg, alpha)
    self:SetSpritAlpha(self.countPlus, alpha)
  end
end

function EquipMfrView:SetCountSubtract(alpha)
  if self.countSubtractBg.color.a ~= alpha then
    self:SetSpritAlpha(self.countSubtractBg, alpha)
    self:SetSpritAlpha(self.countSubtract, alpha)
  end
end

function EquipMfrView:SetSpritAlpha(sprit, alpha)
  sprit.color = Color(sprit.color.r, sprit.color.g, sprit.color.b, alpha)
end

function EquipMfrView:ChooseItem(data)
  if data then
    if self.curComposeId and self.curComposeId ~= data.composeId then
      self:SetChooseMakeData(false)
    end
    self.curComposeId = data.composeId
    self.countInput.value = 1
    self:SetCountSubtract(0.5)
    self:SetCountPlus(1)
    self:SetChooseMakeData(true)
  else
    self:SetChooseMakeData(false)
    self.curComposeId = nil
    self.countInput.value = 1
  end
  self:SetChooseCell()
  self:UpdateTargetCell()
  if self.curComposeId then
    local makeData = EquipMakeProxy.Instance:GetMakeData(self.curComposeId)
    if makeData and makeData:IsLock() then
      self.tip.gameObject:SetActive(true)
      self:UpdateTip()
    else
      self.tip.gameObject:SetActive(false)
      self:UpdateCost()
    end
  else
    self.chooseBord:Show(true)
    self.left:SetActive(false)
  end
  self.targetBtn:SetActive(self.curComposeId ~= nil)
  self.addItemButton:SetActive(self.curComposeId == nil)
  self.rotateSelf.enabled = self.curComposeId ~= nil
  self.rotatePart.transform.localRotation = LuaGeometry.Const_Qua_identity
  if self.particleSystems then
    for i = 1, #self.particleSystems do
      self.particleSystems[i].gameObject:SetActive(self.curComposeId ~= nil)
    end
  end
  self:UpdateItem()
end

function EquipMfrView:ClickTargetCell()
  self:ChooseItem()
end

function EquipMfrView:HandleSelect(cellctl)
end

function EquipMfrView:InsertOrAddNum(array, item, idKey, numKey)
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

function EquipMfrView:GetProductIdOfEquipItem()
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

function EquipMfrView:GetEquipInfoOfEquipItem()
  if not self.nowdata then
    return
  end
  return self.nowdata.equipInfo
end

function EquipMfrView:GetCurLvOfEquipItem()
  local equipInfo = self:GetEquipInfoOfEquipItem()
  if not equipInfo then
    return
  end
  return equipInfo.equiplv
end

function EquipMfrView:GetUpgradeMaxLvOfEquipItem()
  local equipInfo = self:GetEquipInfoOfEquipItem()
  if not equipInfo then
    return
  end
  return equipInfo.upgrade_MaxLv
end

function EquipMfrView:GetExpectedMaxLvOfEquipItem()
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

function EquipMfrView:GetCurCostZeny()
  return tonumber(self.curCostZeny)
end

function EquipMfrView:OnZenyChange()
  self:UpdateCost()
end

function EquipMfrView:UpdateCoins()
  self.robLabel.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetROB())
end

function EquipMfrView:handleItemUpdate()
  self:UpdateItem()
end

function EquipMfrView:clickMaterial(cell)
  local data = cell.itemData
  if data == nil then
    return
  end
  local sdata = {
    itemdata = data,
    funcConfig = {}
  }
  self:ShowItemTip(sdata, cell.icon, NGUIUtil.AnchorSide.Left, {-220, 0})
end

function EquipMfrView:handleLongPress()
  local data = self.nowdata
  if data == nil then
    return
  end
  local sdata = {
    itemdata = data,
    funcConfig = {}
  }
  self:ShowItemTip(sdata, self.targetCell.icon, NGUIUtil.AnchorSide.Left, {-200, 0})
end

function EquipMfrView:clickMaterialQuickMake(cell)
  if cell.qmfr_lackCount and cell.qmfr_staticId then
    self:OpenQuickMakePopup(cell.qmfr_staticId, cell.qmfr_lackCount)
  end
end

function EquipMfrView:DoMakeEquip()
  if self.curComposeId == nil then
    return
  end
  if self.validStamp and ServerTime.CurServerTime() / 1000 < self.validStamp then
    return
  end
  self.validStamp = ServerTime.CurServerTime() / 1000 + 0.2
  local enoughMaterial = self.total - self.need
  local table_compose = EquipMakeProxy.Instance:GetComposeTable()
  local data = table_compose[self.curComposeId]
  local robCost = data.ROB * tonumber(self.countInput.value) or 0
  local enoughROB = MyselfProxy.Instance:GetROB() - robCost
  local makeData = EquipMakeProxy.Instance:GetMakeData(self.curComposeId)
  if enoughMaterial < 0 then
    MsgManager.ShowMsgByID(8)
    return
  elseif enoughROB < 0 then
    MsgManager.ShowMsgByID(1)
    return
  elseif makeData:IsLock() then
    local composeData = table_compose[self.curComposeId]
    if composeData and composeData.MenuID then
      local menuData = Table_Menu[composeData.MenuID]
      if menuData and menuData.sysMsg and menuData.sysMsg.id then
        MsgManager.ShowMsgByID(menuData.sysMsg.id)
      end
    end
    return
  end
  local upgrade_items
  if table_compose[self.curComposeId].Type == 2 then
    upgrade_items = {}
    local cells = self.makeMatCtl:GetCells()
    local hasMatEquip = false
    for i = 1, #cells do
      local serverItemInfo = NetConfig.PBC and {} or SceneItem_pb.ItemInfo()
      local data = cells[i].data
      local equipInfo = cells[i].itemData and cells[i].itemData.equipInfo
      serverItemInfo.id = data.id
      serverItemInfo.count = data.num
      if equipInfo then
        hasMatEquip = true
        serverItemInfo.id = equipInfo.equipData.id
        serverItemInfo.guid = cells[i].itemData.id
      end
      TableUtility.ArrayPushBack(upgrade_items, serverItemInfo)
    end
    if not hasMatEquip then
      upgrade_items = nil
    end
  end
  ServiceItemProxy.Instance:CallProduce(SceneItem_pb.EPRODUCETYPE_EQUIP, self.curComposeId, self.npcdata and self.npcdata.data.id or 0, nil, tonumber(self.countInput.value), nil, self.checkBtn.value, upgrade_items)
end

function EquipMfrView:UpdateMakeList()
  local data = EquipMakeProxy.Instance:GetMakeList()
  if self.isSelfProfession then
    data = EquipMakeProxy.Instance:GetSelfProfessionMakeList()
  end
  self.itemWrapHelper:UpdateInfo(data)
  local isEmpty = #data == 0
  if isEmpty then
    self:UpdateEmpty()
  end
  self.emptyTip:SetActive(isEmpty)
  return isEmpty
end

function EquipMfrView:DoBuyItem()
  if self.curComposeId == nil then
    return
  end
  if self.validStamp and ServerTime.CurServerTime() / 1000 < self.validStamp then
    return
  end
  self.validStamp = ServerTime.CurServerTime() / 1000 + 0.2
  local enoughMaterial = self.total - self.need
  local table_compose = EquipMakeProxy.Instance:GetComposeTable()
  local data = table_compose[self.curComposeId]
  local robCost = data.ROB * tonumber(self.countInput.value) or 0
  local enoughROB = MyselfProxy.Instance:GetROB() - robCost
  local makeData = EquipMakeProxy.Instance:GetMakeData(self.curComposeId)
  if enoughMaterial < 0 then
    local needList = ReusableTable.CreateArray()
    local cells = self.makeMatCtl:GetCells()
    for i = 1, #cells do
      if cells[i].data and cells[i].data.id ~= 100 then
        local needCount = cells[i]:NeedCount()
        if 0 < needCount then
          local needData = ReusableTable.CreateTable()
          needData.id = cells[i].data.id
          needData.count = needCount
          TableUtility.ArrayPushBack(needList, needData)
        end
      end
    end
    if not QuickBuyProxy.Instance:TryOpenView(needList) then
      MsgManager.ShowMsgByID(8)
    end
    for i = 1, #needList do
      ReusableTable.DestroyAndClearTable(needList[i])
    end
    ReusableTable.DestroyArray(needList)
    return
  else
    MsgManager.ShowMsgByID(542)
  end
end

function EquipMfrView:UpdateItem()
  self:UpdateMakeMaterial()
  self:UpdateMakeTitle()
  self:UpdateEquipInfo()
end

function EquipMfrView:UpdateMakeMaterial()
  local result = {}
  local table_compose = EquipMakeProxy.Instance:GetComposeTable()
  local data = table_compose[self.curComposeId]
  if data then
    for i = 1, #data.BeCostItem do
      result[#result + 1] = {
        id = data.BeCostItem[i].id,
        num = data.BeCostItem[i].num * tonumber(self.countInput.value)
      }
    end
    if data.ROB and data.ROB > 0 then
      result[#result + 1] = {
        id = 100,
        num = data.ROB * tonumber(self.countInput.value)
      }
    end
  end
  if self.checkBtn.value and 0 < #result then
    local use, has = false, false
    result, use, has = BlackSmithProxy.Instance:UpdateMaterialListUsingDeduction(result, GameConfig.PackageMaterialCheck.produce)
    if not use then
      if not has then
        MsgManager.ShowMsgByID(28117)
      else
        MsgManager.ShowMsgByID(28118)
      end
      self.checkBtn.value = false
    end
  end
  result = self:PreprocessMatResult4EquipMat(result)
  local checkEnough = function(data)
    local count
    if data.preprocessed then
      count = data.preprocessed.count
    else
      count = EquipMakeProxy.Instance:GetItemNumByStaticID(data.id, GameConfig.PackageMaterialCheck.produce)
    end
    return count >= data.num
  end
  table.sort(result, function(l, r)
    local l_id = l.id
    local r_id = r.id
    local l_enough = checkEnough(l)
    local r_enough = checkEnough(r)
    local l_isEquip = ItemData.CheckIsEquip(l_id)
    local r_isEquip = ItemData.CheckIsEquip(r_id)
    local l_quality = Table_Item[l_id] and Table_Item[l_id].Quality or 0
    local r_quality = Table_Item[r_id] and Table_Item[r_id].Quality or 0
    local l_isZeny = l_id and l_id == 100
    local r_isZeny = r_id and r_id == 100
    if l_isEquip ~= r_isEquip then
      return l_isEquip
    end
    if l_isZeny ~= r_isZeny then
      return l_isZeny
    end
    if l_enough ~= r_enough then
      return r_enough
    end
    if l_quality ~= r_quality then
      return l_quality > r_quality
    end
    return l.id < r.id
  end)
  self.makeMatCtl:ResetDatas(result)
  self.materialGrid.repositionNow = true
  local cells = self.makeMatCtl:GetCells()
  if cells and 5 <= #cells then
    self.materialScrollView.contentPivot = UIWidget.Pivot.Left
  else
    self.materialScrollView.contentPivot = UIWidget.Pivot.Center
  end
  self.materialScrollView:ResetPosition()
end

function EquipMfrView:InsertOrAddNum(array, item, idKey, numKey)
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

function EquipMfrView:PreprocessMatResult4EquipMat(cost)
  autoImport("EquipUpgradeView")
  if not cost then
    return
  end
  local _costEquipsNum = 0
  local _costEquips = {}
  local _curChooseEquipMaterialId
  local _checkBagTypes = BagProxy.Instance:Get_PackageMaterialCheck_BagTypes(BagProxy.MaterialCheckBag_Type.Produce)
  for i = 1, #cost do
    local id = cost[i].id
    if id ~= 100 and ItemData.CheckIsEquip(id) then
      local equipCount, _equip = 0
      local equips = BlackSmithProxy.Instance:GetMaterialEquips_ByEquipId(id, nil, true, nil, _checkBagTypes)
      for j = 1, #equips do
        _equip = equips[j]
        local can1 = 0 >= _equip.equipInfo.refinelv
        local can2 = not _equip.enchantInfo or not _equip.enchantInfo:HasAttri()
        local can3 = 0 >= _equip.equipInfo.strengthlv2
        local can4 = 0 >= _equip.equipInfo.strengthlv
        local can5 = 0 >= _equip.equipInfo.equiplv
        local can6 = not _equip.equipedCardInfo or not (0 < #_equip.equipedCardInfo)
        local can7 = _equip.equipInfo:GetCardSlot() < 2
        local can = can1 and can2 and can3 and can4 and can5 and can6 and can7
        if can then
          if _costEquipsNum < cost[i].num then
            local newEquip
            if _equip.id ~= self.nowdata.id then
              newEquip = _equip:Clone()
            elseif 1 < _equip.num then
              newEquip = _equip:Clone()
              newEquip.num = newEquip.num - 1
            end
            if newEquip then
              _costEquipsNum = newEquip.num + _costEquipsNum
              EquipMfrView.InsertOrAddNum(nil, _costEquips, newEquip)
            end
          end
          if _equip.id == self.nowdata.id then
            if 1 < _equip.num then
              equipCount = equipCount + _equip.num - 1
            end
          else
            equipCount = equipCount + _equip.num
          end
        end
      end
      local targetEquip, equipData
      if _costEquips and 0 < #_costEquips then
        if _curChooseEquipMaterialId then
          targetEquip = BagProxy.Instance:GetItemByGuid(_curChooseEquipMaterialId)
          equipData = targetEquip:Clone()
        end
        if not targetEquip then
          targetEquip = BagProxy.Instance:GetItemByGuid(_costEquips[1].id)
          if targetEquip then
            _curChooseEquipMaterialId = targetEquip.id
            equipData = targetEquip:Clone()
          end
        end
      else
        equipData = ItemData.new(MaterialItemCell.MaterialType.ChooseItem, id)
      end
      xdlog("筛选出来的装备", targetEquip and targetEquip.id or "没有啊")
      equipData.neednum = cost[i].num
      equipData.num = equipCount
      if cost[i].deduction then
        equipData.deduction = cost[i].deduction
        equipData.ori_neednum = cost[i].ori_num
      end
      cost[i].preprocessed = {itemData = equipData, count = equipCount}
    end
  end
  return cost
end

function EquipMfrView:UpdateTargetCell()
  local makeData = EquipMakeProxy.Instance:GetMakeData(self.curComposeId)
  if makeData then
    self.targetCell:SetData(makeData.itemData)
    self.nowdata = makeData.itemData
  else
    self.nowdata = nil
    self.targetCell.nameLab.text = ""
    self.targetCell.normalItem:SetActive(false)
  end
end

function EquipMfrView:UpdateMakeTitle()
  local cells = self.makeMatCtl:GetCells()
  self.need = #cells
  self.total = 0
  for i = 1, self.need do
    local cell = cells[i]
    if cell:IsEnough() then
      self.total = self.total + 1
    end
  end
  self.makeTitle.text = string.format(ZhString.EquipMake_Title, self.total, self.need)
  if self.total < self.need then
    self:SetTextureGrey(self.mfrBtn)
  else
    self:SetTextureWhite(self.mfrBtn, LuaGeometry.GetTempVector4(0.6862745098039216, 0.3764705882352941, 0.10588235294117647, 1))
  end
end

function EquipMfrView:UpdateCost()
end

function EquipMfrView:UpdateTip()
  local table_compose = EquipMakeProxy.Instance:GetComposeTable()
  local data = table_compose[self.curComposeId]
  self.tip.text = data and data.MenuDes or ""
end

function EquipMfrView:SetChooseMakeData(isChoose)
  local makeData = EquipMakeProxy.Instance:GetMakeData(self.curComposeId)
  if makeData then
    makeData:SetChoose(isChoose)
  end
end

function EquipMfrView:SetChooseCell()
  self.chooseBord:SetChoose(self.curComposeId)
end

function EquipMfrView:OpenQuickMakePopup(targetID, count)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.QuickMfrPopUp,
    viewdata = {id = targetID, count = count}
  })
end

function EquipMfrView:UpdateEquipInfo()
  local makeData = EquipMakeProxy.Instance:GetMakeData(self.curComposeId)
  if makeData then
    local itemData = makeData.itemData
    xdlog("当前目标制作", itemData.staticData.id)
    TableUtility.TableClear(self.contextDatas)
    local equipInfo = itemData.equipInfo
    if equipInfo then
      local singleData = ItemTipBaseCell.GetEquipBaseAttriByItemData(itemData, nil, ItemTipEquipAttriVStrColorStr)
      if singleData then
        self.contextDatas[ItemTipAttriType.EquipBaseAttri] = singleData
      end
      singleData = ItemTipBaseCell.GetEquipPvpBaseAttri(equipInfo, nil, ItemTipEquipAttriVStrColorStr)
      if singleData then
        self.contextDatas[ItemTipAttriType.Pvp_EquipBaseAttri] = singleData
      end
      singleData = ItemTipBaseCell.GetEquipSpecial(equipInfo)
      if singleData then
        self.contextDatas[ItemTipAttriType.EquipSpecial] = singleData
      end
      singleData = ItemTipBaseCell.GetEquipUpgrade(equipInfo, itemData, self)
      if singleData then
        self.contextDatas[ItemTipAttriType.EquipUpInfo] = singleData
      end
      local canStrength, canRefine, canEnchant = equipInfo:CanStrength(), equipInfo:CanRefine(), equipInfo:CanEnchant()
      local sb = LuaStringBuilder.CreateAsTable()
      if not canStrength then
        sb:Append(ZhString.ItemTip_NoStrength)
      end
      if not canRefine then
        if sb:GetCount() > 0 then
          sb:Append("/")
        end
        sb:Append(ZhString.ItemTip_NoRefine)
      end
      if not canEnchant then
        if sb:GetCount() > 0 then
          sb:Append("/")
        end
        sb:Append(ZhString.ItemTip_NoEnchant)
      end
      if sb:GetCount() > 0 then
        table.insert(sb.content, 1, "[c]")
        table.insert(sb.content, 2, ItemTipBanRedColorStr)
        table.insert(sb.content, 3, ZhString.ItemTip_EquipCanTip)
        sb:Append("[-][/c]")
        self.contextDatas[ItemTipAttriType.EquipCanInfo] = {
          label = sb:ToString()
        }
      end
    end
  end
  self.listDatas = self.listDatas or {}
  TableUtility.ArrayClear(self.listDatas)
  for i = ItemTipAttriType.MIN_INDEX + 1, ItemTipAttriType.MAX_INDEX do
    if self.contextDatas[i] then
      self.contextDatas[i].lineTab = {455, 170}
      self.contextDatas[i].labelConfig = {labwidth = 430}
      table.insert(self.listDatas, self.contextDatas[i])
    end
  end
  if resetPos == nil then
    resetPos = true
  end
  self.attriCtl:ResetDatas(self.listDatas, true, resetPos)
  self.attriTable:Reposition()
  self.attriScrollView:ResetPosition()
end
