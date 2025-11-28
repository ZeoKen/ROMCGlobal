autoImport("EquipCardChooseCell")
autoImport("EquipCardEditCell")
autoImport("EquipChooseBord")
EquipCardView = class("EquipCardView", ContainerView)
EquipCardView.BrotherView = EquipIntegrateView
EquipCardView.ViewType = UIViewType.NormalLayer

function EquipCardView:Init()
  self:InitView()
  self:MapEvent()
end

function EquipCardView:InitView()
  self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(-50, 0, 0)
  self.cardResultPanel = self:FindGO("CardResult")
  self.resultGrid = self:FindGO("ResultGrid", self.cardResultPanel):GetComponent(UIGrid)
  self.cardCtrl = UIGridListCtrl.new(self.resultGrid, EquipCardChooseCell, "EquipCardChooseCell")
  self.cardCtrl:AddEventListener(UICellEvent.OnMidBtnClicked, self.handleEquipCard, self)
  self.cardCtrl:AddEventListener(UICellEvent.OnRightBtnClicked, self.handleRemoveCard, self)
  self.cardResultPanel:SetActive(false)
  self.closeChooseBtn = self:FindGO("CloseChooseBtn")
  self:AddClickEvent(self.closeChooseBtn, function()
    self.cardResultPanel:SetActive(false)
  end)
  self.slotSV = self:FindGO("SlotScrollView")
  self.slotsGrid = self:FindGO("Slots"):GetComponent(UIGrid)
  self.slotsCtrl = UIGridListCtrl.new(self.slotsGrid, EquipCardEditCell, "EquipCardEditCell")
  self.slotsCtrl:AddEventListener(MouseEvent.MouseClick, self.handleChooseSlots, self)
  self.slotsCtrl:AddEventListener(UICellEvent.OnMidBtnClicked, self.handleOpenCardList, self)
  self.slotsCtrl:AddEventListener(UICellEvent.OnRightBtnClicked, self.handleGoToHole, self)
  self.targetCell = self:FindGO("TargetCell")
  local obj = self:FindGO("ItemCell", self.targetCell)
  obj.transform.localPosition = LuaGeometry.GetTempVector3()
  obj.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
  self.itemCell = ItemCell.new(obj)
  self.itemCell:InitEquipPart()
  local sps = Game.GameObjectUtil:GetAllComponentsInChildren(obj, UIWidget, true)
  for i = 1, #sps do
    sps[i].depth = 10 + sps[i].depth
  end
  self.finishPart = self:FindGO("FinishPart")
  self:AddClickEvent(self.targetCell, function(go)
    self:ClickTargetCell()
  end)
  local chooseContaienr = self:FindGO("ChooseContainer")
  self.chooseBord = EquipChooseBord_CombineSize.new(chooseContaienr)
  self.chooseBord:SetFilterPopData(GameConfig.EquipChooseFilter)
  self.chooseBord:AddEventListener(EquipChooseBord.ChooseItem, self.ChooseItem, self)
  self.chooseBord:Hide()
  self:PlayUIEffect(EffectMap.UI.CardEquipView, self.targetCell, false)
  self.noneTip = self:FindGO("NoneTip")
  self.title = self:FindGO("Title"):GetComponent(UILabel)
  self.title.text = ZhString.EquipIntegrate_EquipCard
end

function EquipCardView:MapEvent()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleCardUseSuc)
  self:AddListenEvt(ItemEvent.EquipUpdate, self.HandleCardUseSuc)
  self:AddListenEvt(ItemEvent.EquipIntegrate_TrySelectEquip, self.ClickTargetCell)
end

function EquipCardView:OnEnter()
  EquipCardView.super.OnEnter(self)
  local targetEquip = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.itemdata
  if targetEquip then
    self:UpdateView(targetEquip)
  else
    self:ClickTargetCell()
    redlog("没有装备")
  end
  if self.npcdata then
    local rootTrans = self.npcdata.assetRole.completeTransform
    self:CameraFocusAndRotateTo(rootTrans, CameraConfig.SwingMachine_ViewPort, CameraConfig.SwingMachine_Rotation)
  else
    self:CameraFocusToMe()
  end
end

function EquipCardView:OnExit()
  EquipCardView.super.OnExit(self)
  self.itemCell = nil
  self:CameraReset()
end

function EquipCardView:UpdateView(data)
  self.itemdata = data
  self:sendNotification(ItemEvent.EquipChooseSuccess, data)
  if not self.itemdata then
    self.noneTip:SetActive(true)
    self.itemCell:SetData()
    self.slotSV:SetActive(false)
    return
  end
  self.slotSV:SetActive(true)
  self.noneTip:SetActive(false)
  self.pos = ItemUtil.getEquipPos(data.staticData.id)
  xdlog("装备", data.staticData.id, self.pos)
  self.itemCell:SetData(self.itemdata)
  self.itemCell:UpdateNumLabel(1)
  self.itemCell:ActiveNewTag(false)
  self:UpdateEquipSlots()
  self:UpdateCards()
  self.chooseBord:Hide()
end

function EquipCardView:UpdateEquipSlots()
  local equipCardInfo = self.itemdata.equipedCardInfo or {}
  local cardSlotNum = self.itemdata.cardSlotNum or 0
  local maxSlotNum = self.itemdata.GetMaxCardSlot and self.itemdata:GetMaxCardSlot() or 0
  self.finishPart:SetActive(maxSlotNum == 0)
  local cardSlots = {}
  for i = 1, maxSlotNum do
    if equipCardInfo[i] then
      table.insert(cardSlots, equipCardInfo[i])
    elseif i <= cardSlotNum then
      table.insert(cardSlots, EquipCardChooseCell.Status.Empty)
    elseif i <= maxSlotNum then
      table.insert(cardSlots, EquipCardChooseCell.Status.Lock)
    end
  end
  self.slotsCtrl:ResetDatas(cardSlots)
  local cells = self.slotsCtrl:GetCells()
  if not self.curSlotPos then
    for i = 1, #cells do
      if cells[i].data ~= EquipCardChooseCell.Status.Lock then
        cells[i]:SetChoose(true)
        self.curSlotPos = cells[i].indexInList
        break
      end
    end
  end
end

function EquipCardView:UpdateCards()
  local equipCards, cards = self.itemdata.equipedCardInfo or {}, {}
  local curEquipedCardInfo = equipCards[self.curSlotPos]
  for pos, equipCard in pairs(equipCards) do
    if curEquipedCardInfo and curEquipedCardInfo.id == equipCard.id then
      equipCard.used = true
      table.insert(cards, equipCard)
      break
    end
  end
  local items = BagProxy.Instance.bagData:GetItems()
  for i = 1, #items do
    local item = items[i]
    local cardInfo = item.cardInfo
    if cardInfo and cardInfo.Position == self.pos and (not curEquipedCardInfo or curEquipedCardInfo.staticData.id ~= cardInfo.id) then
      table.insert(cards, item)
    end
  end
  table.sort(cards, EquipCardView.CardSortRule)
  self.cardCtrl:ResetDatas(cards)
end

function EquipCardView.CardSortRule(a, b)
  if a.used ~= b.used then
    return b.used ~= true
  end
  if a.used and b.used then
    return a.index < b.index
  end
  if a.staticData.Quality ~= b.staticData.Quality then
    return a.staticData.Quality > b.staticData.Quality
  end
  return a.staticData.id < b.staticData.id
end

function EquipCardView:handleEquipCard(cell)
  xdlog("安装卡片")
  local data = cell.data
  if not self.curSlotPos then
    redlog("未选择卡槽差")
    return
  end
  ServiceItemProxy.Instance:CallEquipCard(SceneItem_pb.ECARDOPER_EQUIPON, data.id, self.itemdata.id, self.curSlotPos)
end

function EquipCardView:handleRemoveCard(cell)
  local data = cell.data
  local cardid = data and data.id
  if not self.itemdata then
    return
  end
  if not self.curSlotPos then
    return
  end
  xdlog("移除卡片", self.itemdata.id, self.curSlotPos)
  ServiceItemProxy.Instance:CallEquipCard(SceneItem_pb.ECARDOPER_EQUIPOFF, nil, self.itemdata.id, self.curSlotPos)
end

function EquipCardView:handleChooseSlots(cell)
  if not cell then
    return
  end
  if cell.data == EquipCardChooseCell.Status.Lock then
    redlog("锁定的卡位")
    return
  end
  local cells = self.slotsCtrl:GetCells()
  for i = 1, #cells do
    cells[i]:SetChoose(cells[i].indexInList == cell.indexInList)
  end
  local pos = cell.indexInList
  self.curSlotPos = pos
  xdlog("当前选择卡位", self.curSlotPos)
  self:UpdateCards()
end

function EquipCardView:handleOpenCardList(cell)
  self.cardResultPanel:SetActive(true)
  self:handleChooseSlots(cell)
  self.chooseBord:Hide()
end

function EquipCardView:handleGoToHole(cell)
  redlog("前往打洞")
  local isDamage = self.itemdata.equipInfo and self.itemdata.equipInfo.damage or false
  if isDamage then
    MsgManager.ShowMsgByID(43387)
    return
  end
  EventManager.Me():PassEvent(UIEvent.ExitCallback)
  local layer = UIManagerProxy.Instance:GetLayerByType(UIViewType.NormalLayer)
  if layer then
    local panelCtrl = layer:FindNodeByName("EquipIntegrateView")
    if panelCtrl and panelCtrl.viewCtrl then
      UIManagerProxy.Instance:CloseUI(panelCtrl.viewCtrl)
    end
  end
  FunctionNpcFunc.JumpPanel(PanelConfig.EquipReplaceNewView, {
    OnClickChooseBordCell_data = self.itemdata
  })
end

function EquipCardView:HandleCardUseSuc(note)
  if not self.itemdata then
    return
  end
  local item = BagProxy.Instance:GetItemByGuid(self.itemdata.id)
  if item then
    xdlog("找到装备，重新设定")
    self:UpdateView(item)
  end
end

function EquipCardView:ChooseItem(itemData)
  self:UpdateView(itemData)
end

function EquipCardView:ClickTargetCell()
  self:ChooseItem(nil)
  self.cardResultPanel:SetActive(false)
  local equipdatas = self:GetValidEquips()
  if 0 < #equipdatas then
    self.chooseBord:Show()
    self.chooseBord:ResetDatas(equipdatas, true)
    self.chooseBord:SetChoose(self.itemdata)
  else
    MsgManager.ShowMsgByIDTable(43489)
    self.chooseBord:Hide()
  end
end

local _PACKAGECHECK = {
  2,
  1,
  20
}

function EquipCardView:GetValidEquips()
  local _BagProxy = BagProxy.Instance
  local result = {}
  for i = 1, #_PACKAGECHECK do
    local items = _BagProxy:GetBagByType(_PACKAGECHECK[i]):GetItems()
    for j = 1, #items do
      local data = items[j]
      local valid = false
      local maxSlotNum = data.GetMaxCardSlot and data:GetMaxCardSlot() or 0
      valid = 0 < maxSlotNum
      if valid then
        TableUtility.ArrayPushBack(result, data)
      end
    end
  end
  return result
end
