UseCardPopUp = class("UseCardPopUp", BaseView)
UseCardPopUp.ViewType = UIViewType.PopUpLayer
autoImport("EquipTipCell")

function UseCardPopUp:Init()
  if self.viewdata.viewdata then
    self.carddata = self.viewdata.viewdata.carddata
    self.equipdatas = self.viewdata.viewdata.equipdatas
  end
  self:InitUI()
  self:MapEvent()
end

function UseCardPopUp:InitUI()
  self.itemCtl = WrapListCtrl.new(self:FindGO("ItemGrid"), EquipTipCell, "EquipTipCell", 2, nil, nil, true)
  self.itemCtl:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self)
  self:UpdateData()
end

function UseCardPopUp:ClickItem(cellCtl)
  local data = cellCtl.data
  if data then
    self.nowcell = cellCtl
    self:sendNotification(UIEvent.ShowUI, {
      viewname = "CardPosChoosePopUp",
      itemData = data
    })
  end
end

function UseCardPopUp:UpdateData()
  if self.carddata and self.carddata.cardInfo then
    local pos = self.carddata.cardInfo.Position
    local filterDatas = self.equipdatas or BagProxy.Instance:FilterEquipedCardItems(pos)
    self.itemCtl:ResetDatas(filterDatas)
    self.equipdatas = nil
  end
end

function UseCardPopUp:MapEvent()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleCardUseSuc)
  self:AddListenEvt(ItemEvent.EquipUpdate, self.HandleCardUseSuc)
  self:AddListenEvt(CardPosChoosePopUpEvent.ChoosePos, self.HandleChoosePos)
end

function UseCardPopUp:HandleChoosePos(note)
  local pos = note.body and note.body[1]
  local has_cost = note.body and note.body[2] and note.body[2] > 0
  local data = self.nowcell and self.nowcell.data
  if data then
    local carddata = self.carddata
    ServiceItemProxy.Instance:CallEquipCard(SceneItem_pb.ECARDOPER_EQUIPON, carddata.id, data.id, pos)
    self.callServer = true
  end
end

function UseCardPopUp:HandleCardUseSuc(note)
  if self.callServer then
    self.callServer = false
    self:CloseSelf()
  end
end

function UseCardPopUp:OnExit()
  local cells = self.itemCtl:GetCells()
  for i = 1, #cells do
    cells[i]:Exit()
  end
end
