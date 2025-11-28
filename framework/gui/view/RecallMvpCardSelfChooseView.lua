autoImport("CardPrayItemCell")
RecallMvpCardSelfChooseView = class("RecallMvpCardSelfChooseView", ContainerView)
RecallMvpCardSelfChooseView.ViewType = UIViewType.PopUpLayer

function RecallMvpCardSelfChooseView:Init()
  self:FindObjs()
  self.tipData = {}
  self.tipData.funcConfig = {}
end

function RecallMvpCardSelfChooseView:FindObjs()
  local grid = self:FindComponent("CardGrid", UIGrid)
  self.cardListCtl = UIGridListCtrl.new(grid, CardPrayItemCell, "CardPrayItemCell")
  self.cardListCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickCard, self)
  self.cardListCtl:AddEventListener(MouseEvent.LongPress, self.OnPressCard, self)
  local confirmBtn = self:FindGO("ConfirmBtn")
  self:AddClickEvent(confirmBtn, function()
    if self.chooseCardId then
      ServiceRecallCCmdProxy.Instance:CallMvpCardSetUpCardRecallCmd(self.chooseCardId)
      self:CloseSelf()
    end
  end)
  self.chooseCardLabel = self:FindComponent("ChooseCardLabel", UILabel)
  self:AddCloseButtonEvent()
end

function RecallMvpCardSelfChooseView:OnClickCard(cell)
  local data = cell.data and cell.data.staticData
  if not data then
    return
  end
  if self.chooseCardId == data.id then
    return
  end
  self.chooseCardId = data.id
  self.chooseCardLabel.text = data.NameZh
  self:ChooseCard()
end

function RecallMvpCardSelfChooseView:OnPressCard(param)
  local isPressing, cellCtl = param[1], param[2]
  if isPressing and cellCtl and cellCtl.data then
    local data = cellCtl.data
    self.tipData.itemdata = data
    local index = (cellCtl.indexInList - 1) % 6 + 1
    local side = index <= 3 and NGUIUtil.AnchorSide.Right or NGUIUtil.AnchorSide.Left
    local offset = index <= 3 and _offsetR or _offsetL
    TipManager.Instance:ShowItemFloatTip(self.tipData, self.bg, side, offset)
  end
end

function RecallMvpCardSelfChooseView:ChooseCard()
  local cells = self.cardListCtl:GetCells()
  for i = 1, #cells do
    cells[i]:SetChoose(self.chooseCardId)
  end
end

function RecallMvpCardSelfChooseView:SelectFirst()
  local cell = self.cardListCtl:GetCells()[1]
  if cell then
    self:OnClickCard(cell)
  end
end

function RecallMvpCardSelfChooseView:OnEnter()
  local rateUpCards = RecallMvpCardProxy.Instance:GetRateUpCards()
  self.cardListCtl:ResetDatas(rateUpCards)
  self:SelectFirst()
  local cells = self.cardListCtl:GetCells()
  for i = 1, #cells do
    cells[i]:SetLocalScale(1.5)
  end
end
