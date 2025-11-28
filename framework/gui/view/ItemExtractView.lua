autoImport("EquipNewCountChooseCell")
autoImport("ItemExtractMatCell")
ItemExtractView = class("ItemExtractView", BaseView)
ItemExtractView.ViewType = UIViewType.NormalLayer
ItemExtractView.ViewMaskAdaption = {all = 1}
local texObjStaticNameMap = {
  Bg3 = "Equipmentopen_bg_bottom_02",
  ProgressBg = "Equipmentopen_bg_bottom_06",
  ForeProgress = "Equipmentopen_bg_bottom_06",
  BackProgress = "Equipmentopen_bg_bottom_06",
  OverflowProgress = "Equipmentopen_bg_bottom_06"
}
local picIns, bagIns, tickManager
local animTickId, animCycleTime, extAnimDelay, animThreshold = 237, 500, 200, 0.002

function ItemExtractView:Init()
  if not picIns then
    picIns = PictureManager.Instance
    bagIns = BagProxy.Instance
    tickManager = TimeTickManager.Me()
  end
  self:InitData()
  self:FindObjs()
  self:InitView()
  self:AddEvents()
end

function ItemExtractView:InitData()
  self.selectedItemMap = {}
  self.tipData = {
    funcConfig = _EmptyTable,
    callback = function()
      self:ShowMatChooseSymbol()
    end
  }
  local npcFunctionData = self.viewdata.viewdata and self.viewdata.viewdata.npcfunctiondata
  self.titleName = npcFunctionData and npcFunctionData.NameZh
  self.npcFunctionId = npcFunctionData and npcFunctionData.id
  local cfg = GameConfig.EquipPower[self.npcFunctionId]
  if not cfg then
    LogUtility.ErrorFormat("Cannot find equippower cfg of npc function id: {0}", self.npcFunctionId)
    return
  end
  self.exchangeItem, self.exchangeCfg, self.ratio = cfg.EquipPowerItem, cfg.EquipPowerExchange, cfg.EquipPowerExchangeRatio
end

function ItemExtractView:FindObjs()
  for objName, _ in pairs(texObjStaticNameMap) do
    self[objName] = self:FindComponent(objName, UITexture)
  end
  self.title = self:FindComponent("Title", UILabel)
  self.bg3Tex = self:FindComponent("Bg3", UITexture)
  self.targetIcon = self:FindComponent("Icon", UISprite)
  self.progressLabel = self:FindComponent("ProgressLabel", UILabel)
  self.matParentTrans = self:FindGO("Materials").transform
  self.matTable = self:FindComponent("MatTable", UITable)
  self.actionLabel = self:FindComponent("ActionLabel", UILabel)
  self.effectContainer = self:FindGO("EffectContainer")
  self.countChooseGrid = self:FindComponent("ChooseGrid", UIGrid)
  self.countChooseNoneTip = self:FindGO("NoneTip")
  self.itemGetBoard = self:FindGO("ItemGetBoard")
  self.itemGetGrid = self:FindComponent("Grid", UIGrid, self.itemGetBoard)
  self.itemGetLabel = self:FindComponent("Tip", UILabel, self.itemGetBoard)
  self.tweenColor = self.ForeProgress:GetComponent(TweenColor)
  self.matChooseSymbol = self:FindGO("MatChooseSymbol")
  self.collider = self:FindGO("Collider")
end

function ItemExtractView:InitView()
  self.tipData.ignoreBounds = {
    self.countChooseGrid.gameObject,
    self.targetIcon.gameObject,
    self.matTable.gameObject
  }
  self.matCtrl = ListCtrl.new(self.matTable, ItemExtractMatCell, "MaterialSelectItemNewCell")
  self.matCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickMatCell, self)
  self.matCtrl:AddEventListener(MouseEvent.LongPress, self.OnLongPressMatCell, self)
  self.matCtrl:AddEventListener(ItemEvent.ItemDeselect, self.OnDeselectMatCell, self)
  self.matCells = self.matCtrl:GetCells()
  self.itemGetCtrl = ListCtrl.new(self.itemGetGrid, BagItemNewCell, "BagItemNewCell")
  self.countChooseCtl = ListCtrl.new(self.countChooseGrid, EquipNewCountChooseCell, "EquipNewChooseCell")
  self.countChooseCtl:AddEventListener(EquipChooseCellEvent.CountChooseChange, self.OnCountChooseChange, self)
  self.countChooseCtl:AddEventListener(EquipChooseCellEvent.ClickItemIcon, self.OnClickChooseCellIcon, self)
  self.countChooseCells = self.countChooseCtl:GetCells()
  if self.titleName then
    self.title.text = self.titleName
  end
  IconManager:SetItemIcon(Table_Item[self.exchangeItem].Icon, self.targetIcon)
  self.selectedItems = {}
  for id, _ in pairs(self.exchangeCfg) do
    TableUtility.ArrayPushBack(self.selectedItems, ItemData.new("Select", id))
  end
  table.sort(self.selectedItems, function(l, r)
    local lId, rId = l.staticData.id, r.staticData.id
    local lCfg, rCfg = self.exchangeCfg[lId] or 0, self.exchangeCfg[rId] or 0
    if lCfg ~= rCfg then
      return lCfg < rCfg
    end
    return lId < rId
  end)
  self.countChooseCtl:ResetDatas(self.selectedItems)
  self.countChooseNoneTip:SetActive(#self.selectedItems == 0)
  local max = 12
  local exchangeCount = self:GetEquipExchangeCount()
  if max < exchangeCount then
    max = math.ceil(exchangeCount / 6) * 6
  end
  for i = #self.selectedItems + 1, max do
    self.selectedItems[i] = BagItemEmptyType.Empty
  end
  self.matCtrl:ResetDatas(self.selectedItems)
  for _, cell in pairs(self.matCells) do
    cell:SetSelectReference(self.selectedItemMap)
  end
  self:UpdateEquipPowerItem()
  self:UpdateExchangeOfCountChoose()
end

function ItemExtractView:AddEvents()
  self:AddButtonEvent("TargetCell", function()
    if not self.targetData then
      self.targetData = ItemData.new("Target", self.exchangeItem)
    end
    self:ShowItemTip(self.targetData, self.targetIcon)
  end)
  self:AddButtonEvent("ActionBtn", function()
    if not self.ep then
      return
    end
    self:ShowMatChooseSymbol()
    if self.actionLabel.text == ZhString.ItemExtract_ActionBtnInput then
      local count = 0
      for _, c in pairs(self.selectedItemMap) do
        count = count + c
      end
      if count == 0 then
        MsgManager.FloatMsg(nil, ZhString.ItemExtract_NoMat)
        return
      end
    elseif bagIns:CheckBagIsFull(BagProxy.BagType.MainBag) then
      MsgManager.ShowMsgByIDTable(3101)
      return
    end
    self:_Extract()
  end)
  self:AddButtonEvent("BgCollider", function()
    self.itemGetBoard:SetActive(false)
  end)
  self:AddListenEvt(ServiceEvent.ItemEquipPowerQuery, self.OnEquipPowerUpdate)
  self:AddListenEvt(ServiceEvent.ItemEquipPowerInputItemCmd, self.OnEquipPowerInput)
  self:AddListenEvt(ServiceEvent.ItemEquipPowerOutputItemCmd, self.OnEquipPowerOutput)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.OnItemUpdate)
end

function ItemExtractView:OnEnter()
  ItemExtractView.super.OnEnter(self)
  ServiceItemProxy.Instance:CallEquipPowerQuery()
  for objName, texName in pairs(texObjStaticNameMap) do
    picIns:SetUI(texName, self[objName])
  end
  local npcData = self.viewdata.viewdata and self.viewdata.viewdata.npcdata
  if npcData then
    self:CameraFocusOnNpc(npcData.assetRole.completeTransform)
  else
    self:CameraRotateToMe()
  end
  self:ClearSelect()
end

function ItemExtractView:OnExit()
  for objName, texName in pairs(texObjStaticNameMap) do
    picIns:UnLoadUI(texName, self[objName])
  end
  self:CameraReset()
  tickManager:ClearTick(self)
  self.tweenColor.enabled = false
  ItemExtractView.super.OnExit(self)
end

function ItemExtractView:OnEquipPowerUpdate(param)
  local epExists = self.ep and true or false
  local exEp = self.ep or 0
  local t = type(param)
  if t == "table" then
    local data = param.body.data
    if data then
      for i = 1, #data do
        if data[i].npcfunction == self.npcFunctionId then
          self.ep = data[i].power / self.ratio
        end
      end
    end
  elseif t == "number" then
    self.ep = param / self.ratio
  end
  if not self.ep then
    self.ep = 0
  end
  if epExists then
    if exEp > self.ep then
      self:DoExtractAnim(exEp, self.ep)
    elseif exEp < self.ep then
      self:DoInputAnim(exEp, self.ep)
    end
  else
    self:RefreshProgress()
  end
end

function ItemExtractView:OnEquipPowerInput(note)
  if not note or not note.body then
    return
  end
  self:OnEquipPowerUpdate(note.body.after_power)
end

function ItemExtractView:OnEquipPowerOutput(note)
  if not note or not note.body then
    return
  end
  self:OnEquipPowerUpdate(note.body.after_power)
end

function ItemExtractView:OnItemUpdate()
  local nowNum = self:GetItemNum(self.exchangeItem)
  if nowNum > self.epItemSnapshot then
    self.itemGetBoard:SetActive(true)
    local delta = nowNum - self.epItemSnapshot
    self.itemGetDatas = self.itemGetDatas or {
      ItemData.new("ItemGet", self.exchangeItem)
    }
    self.itemGetDatas[1].num = delta
    self.itemGetCtrl:ResetDatas(self.itemGetDatas)
    self.itemGetLabel.text = string.format("%s x%s", Table_Item[self.exchangeItem].NameZh, delta)
    if not self.itemGetTween then
      self.itemGetTween = self.itemGetBoard:GetComponent(TweenScale)
    end
    self.itemGetTween:ResetToBeginning()
    self.itemGetTween:PlayForward()
  end
  self:UpdateEquipPowerItem()
  for _, c in pairs(self.countChooseCells) do
    c:SetData(c.data)
  end
  self:UpdateExchangeOfCountChoose()
end

function ItemExtractView:OnClickMatCell(cell)
  if self.isClickOnMatDisabled then
    self.isClickOnMatDisabled = nil
    return
  end
  if not self.ep then
    return
  end
  if not BagItemCell.CheckData(cell.data) then
    return
  end
  local id = cell.data.staticData.id
  if self.nowMaxNumMap[id] == 0 then
    MsgManager.ShowMsgByID(8)
    return
  end
  if self.selectedItemMap[id] >= self.nowMaxNumMap[id] then
    MsgManager.FloatMsg(nil, ZhString.ItemExtract_MatFullTip)
    return
  end
  self.selectedItemMap[id] = self.selectedItemMap[id] + 1
  self:UpdateSelect()
end

function ItemExtractView:OnLongPressMatCell(data)
  if not data[1] then
    return
  end
  if not self.ep then
    return
  end
  local cell = data[2]
  if cell and BagItemCell.CheckData(cell.data) then
    self:ShowItemTip(cell.data, cell.icon)
    self:ShowMatChooseSymbol(cell.gameObject)
    self.isClickOnMatDisabled = true
  end
end

function ItemExtractView:OnDeselectMatCell(cell)
  if not self.ep then
    return
  end
  if not BagItemCell.CheckData(cell.data) then
    return
  end
  self.selectedItemMap[cell.data.staticData.id] = 0
  self:UpdateSelect()
end

function ItemExtractView:OnCountChooseChange(cell)
  if not self.ep then
    return
  end
  if not BagItemCell.CheckData(cell.data) then
    return
  end
  self.selectedItemMap[cell.data.staticData.id] = cell.chooseCount or 0
  self:UpdateSelect()
end

local chooseCellTipOffset = {200, -200}

function ItemExtractView:OnClickChooseCellIcon(cell)
  if not self.ep then
    return
  end
  if not BagItemCell.CheckData(cell.data) then
    return
  end
  self:ShowItemTip(cell.data, cell.icon, NGUIUtil.AnchorSide.Right, chooseCellTipOffset)
end

function ItemExtractView:DoInputAnim(from, to)
  self.inputAnimAmount, self.inputAnimTo = from, to
  self.inputAnimFillAmount, self.inputAnimFillTo = from / 100 - math.floor(from / 100), 200 <= to and 2 or to / 100 - math.floor(to / 100)
  if self.inputAnimFillAmount - self.inputAnimFillTo >= -math.Epsilon then
    self.inputAnimFillTo = self.inputAnimFillTo + 1
  end
  local totalTime = math.ceil(self.inputAnimFillTo - self.inputAnimFillAmount) * animCycleTime
  self.inputAnimTickStep, self.inputAnimFillTickStep = (self.inputAnimTo - self.inputAnimAmount) / totalTime, (self.inputAnimFillTo - self.inputAnimFillAmount) / totalTime
  tickManager:ClearTick(self, animTickId)
  tickManager:CreateTick(0, 16, self._DoInputAnim, self, animTickId)
end

function ItemExtractView:_DoInputAnim(interval)
  self.inputAnimAmount = self.inputAnimAmount + self.inputAnimTickStep * interval
  self:UpdateProgressLabel(self.inputAnimAmount, self.inputAnimTo - self.inputAnimAmount)
  self.inputAnimFillAmount = self.inputAnimFillAmount + self.inputAnimFillTickStep * interval
  local fillAmount = self.inputAnimFillAmount - math.floor(self.inputAnimFillAmount)
  self.ForeProgress.fillAmount = math.clamp(self.inputAnimFillAmount, 0, 1)
  self.OverflowProgress.fillAmount = self.inputAnimFillAmount > 1 and fillAmount or 0
  if fillAmount < 0.05 then
    self:PlayShiningProgressColor()
  end
  if self.inputAnimFillTo - self.inputAnimFillAmount < animThreshold then
    tickManager:ClearTick(self, animTickId)
    self:ClearSelect()
  end
end

function ItemExtractView:DoExtractAnim(from, to)
  self.BackProgress.fillAmount = 0
  self:PlayUIEffect(EffectMap.UI.EquipReplaceNew, self.effectContainer, true)
  self.extAnimAmount, self.extAnimTo = from, to
  self.extAnimFillAmount, self.extAnimFillTo = 200 <= from and 2 or from / 100 - math.floor(from / 100), to / 100 - math.floor(to / 100)
  if self.extAnimFillTo - self.extAnimFillAmount >= -math.Epsilon then
    self.extAnimFillAmount = self.extAnimFillAmount + 1
  end
  local totalTime = math.ceil(self.extAnimFillAmount - self.extAnimFillTo) * animCycleTime
  self.extAnimTickStep, self.extAnimFillTickStep = (self.extAnimTo - self.extAnimAmount) / totalTime, (self.extAnimFillTo - self.extAnimFillAmount) / totalTime
  tickManager:ClearTick(self, animTickId)
  tickManager:CreateTick(extAnimDelay, 16, self._DoExtractAnim, self, animTickId)
end

function ItemExtractView:_DoExtractAnim(interval)
  self.extAnimAmount = self.extAnimAmount + self.extAnimTickStep * interval
  self:UpdateProgressLabel(self.extAnimAmount)
  self.extAnimFillAmount = self.extAnimFillAmount + self.extAnimFillTickStep * interval
  local fillAmount = self.extAnimFillAmount - math.floor(self.extAnimFillAmount)
  self.ForeProgress.fillAmount = math.clamp(self.extAnimFillAmount, 0, 1)
  self.OverflowProgress.fillAmount = self.extAnimFillAmount > 1 and fillAmount or 0
  if fillAmount < 0.05 then
    self:PlayShiningProgressColor()
  end
  if self.extAnimFillAmount - self.extAnimFillTo < animThreshold then
    tickManager:ClearTick(self, animTickId)
    self:ClearSelect()
  end
end

function ItemExtractView:UpdateEquipPowerItem()
  self.epItemSnapshot = self:GetItemNum(self.exchangeItem)
  self.nowMaxNumMap = self.nowMaxNumMap or {}
  for id, _ in pairs(self.exchangeCfg) do
    self.nowMaxNumMap[id] = math.clamp(self:GetItemNum(id), 0, 99999)
  end
end

function ItemExtractView:UpdateExchangeOfCountChoose()
  local id
  for _, cell in pairs(self.countChooseCells) do
    id = cell.data.staticData.id
    cell.curCountLabel.text = string.format(ZhString.ItemExtract_CountChooseFormat, self.exchangeCfg[id] / self.ratio)
  end
end

function ItemExtractView:ClearSelect()
  self.collider:SetActive(false)
  for id, _ in pairs(self.exchangeCfg) do
    self.selectedItemMap[id] = 0
  end
  self:UpdateSelect()
  self:ShowMatChooseSymbol()
end

function ItemExtractView:UpdateSelect()
  for _, cell in pairs(self.matCells) do
    cell:UpdateSelect()
  end
  for _, cell in pairs(self.countChooseCells) do
    cell:SetChooseCount(self.selectedItemMap[cell.data.staticData.id] or 0)
  end
  self:RefreshProgress()
end

function ItemExtractView:CalculateTempProgress()
  local tmp = 0
  for id, count in pairs(self.selectedItemMap) do
    tmp = tmp + count * self.exchangeCfg[id] / self.ratio
  end
  return tmp
end

function ItemExtractView:RefreshProgress()
  if not self.ep then
    return
  end
  self.tmpProgress = self:CalculateTempProgress()
  self.ForeProgress.fillAmount = math.clamp(self.ep / 100, 0, 1)
  self.BackProgress.fillAmount = math.clamp((self.ep + self.tmpProgress) / 100, 0, 1)
  self.OverflowProgress.fillAmount = math.clamp((self.ep + self.tmpProgress - 100) / 100, 0, 1)
  self:UpdateProgressLabel(self.ep, self.tmpProgress)
  self.actionLabel.text = self.ep >= 100 and self.tmpProgress <= 0 and ZhString.ItemExtract_ActionBtnExtract or ZhString.ItemExtract_ActionBtnInput
end

function ItemExtractView:UpdateProgressLabel(value, delta)
  local count = math.floor(math.log(self.ratio, 10))
  local format = string.format("%%.%df%%%%", count)
  self.progressLabel.text = string.format(format, value) .. (delta and 0 < delta and " [c][149b81]+" .. string.format(format, delta) .. "[-][/c]" or "")
end

function ItemExtractView:_Extract()
  self.collider:SetActive(true)
  if self.ep >= 100 and self.tmpProgress <= 0 then
    ServiceItemProxy.Instance:CallEquipPowerOutputItemCmd(self.npcFunctionId)
  else
    local arr, data, sId, sitem = ReusableTable.CreateArray()
    for i = 1, #self.selectedItems do
      data = self.selectedItems[i]
      if BagItemCell.CheckData(data) then
        sId = data.staticData.id
        if 0 < self.selectedItemMap[sId] then
          sitem = NetConfig.PBC and {} or SceneItem_pb.SItem()
          sitem.id, sitem.count = sId, self.selectedItemMap[sId]
          TableUtility.ArrayPushBack(arr, sitem)
        end
      end
    end
    ServiceItemProxy.Instance:CallEquipPowerInputItemCmd(arr, self.npcFunctionId)
    ReusableTable.DestroyAndClearArray(arr)
  end
end

function ItemExtractView:PlayShiningProgressColor()
  self.tweenColor:ResetToBeginning()
  self.tweenColor:PlayForward()
end

function ItemExtractView:ShowMatChooseSymbol(go)
  if Slua.IsNull(self.matChooseSymbol) then
    return
  end
  if go then
    self.matChooseSymbol.transform:SetParent(go.transform, false)
    self.matChooseSymbol.transform.localPosition = LuaGeometry.Const_V3_zero
    self.matChooseSymbol:SetActive(true)
  else
    self.matChooseSymbol.transform:SetParent(self.matParentTrans, false)
    self.matChooseSymbol:SetActive(false)
  end
end

function ItemExtractView:GetItemNum(staticId)
  return bagIns:GetItemNumByStaticID(staticId, GameConfig.PackageMaterialCheck.equip_power)
end

local tipOffset = {-210, 180}

function ItemExtractView:ShowItemTip(data, stick, side, offset)
  if not data then
    return
  end
  self.tipData.itemdata = data
  ItemExtractView.super.ShowItemTip(self, self.tipData, stick, side or NGUIUtil.AnchorSide.Left, offset or tipOffset)
end

function ItemExtractView:GetEquipExchangeCount()
  local count = 0
  for _ in pairs(self.exchangeCfg) do
    count = count + 1
  end
  return count
end
