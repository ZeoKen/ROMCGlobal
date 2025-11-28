autoImport("RaidSelectCardCell")
RaidSelectCardView = class("RaidSelectCardView", BaseView)
RaidSelectCardView.ViewType = UIViewType.PopUpLayer
local tickManager, arrayPushBack

function RaidSelectCardView:Init()
  if not tickManager then
    tickManager = TimeTickManager.Me()
    arrayPushBack = TableUtility.ArrayPushBack
  end
  self:AddListenEvt(ServiceEvent.RaidCmdRaidSelectCardResetCmd, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.RaidCmdRaidSelectCardResultRes, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.CloseSelf)
  self:InitData()
  self.cardParent = self:FindGO("Cards")
  self.countdownLabel = self:FindComponent("Countdown", UILabel)
  self.confirmBtn = self:FindGO("ConfirmBtn")
  self.fakeConfirmBtn = self:FindGO("FakeConfirmBtn")
  self:AddClickEvent(self.confirmBtn, function()
    local id = self.selectedIndex and self.cardIds[self.selectedIndex]
    if not id then
      LogUtility.Warning("There's no data of selected card.")
      return
    end
    ServiceRaidCmdProxy.Instance:CallRaidSelectCardResultCmd(Game.Myself.data.id, id)
  end)
  self.cardCtrl = ListCtrl.new(self.cardParent:GetComponent(UIGrid), RaidSelectCardCell, "RaidSelectCardCell")
  self.cards = self.cardCtrl:GetCells()
  self.cardCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickCard, self)
end

function RaidSelectCardView:InitData()
  local viewData = self.viewdata.viewdata or _EmptyTable
  if not viewData or not next(viewData) then
    LogUtility.Error("RaidSelectCardView: viewdata is nothing")
  end
  self.endTime = viewData.endTime
  self.cardIds = viewData.cardIds
end

function RaidSelectCardView:OnEnter()
  UIManagerProxy.Instance:NeedEnableAndroidKey(false)
  RaidSelectCardView.super.OnEnter(self)
  self:UpdateCards()
  self:SetSelected()
  tickManager:CreateTick(0, 33, self.UpdateTick, self)
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
end

function RaidSelectCardView:OnExit()
  tickManager:ClearTick(self)
  self.cardCtrl:Destroy()
  RaidSelectCardView.super.OnExit(self)
  UIManagerProxy.Instance:NeedEnableAndroidKey(true, UIManagerProxy.GetDefaultNeedEnableAndroidKeyCallback())
end

function RaidSelectCardView:OnClickCard(card)
  for i, c in pairs(self.cards) do
    if card and c.data == card.data then
      self:SetSelected(i)
      break
    end
  end
end

function RaidSelectCardView:SetSelected(index)
  if self.selectedIndex then
    local card = self.cards[self.selectedIndex]
    if card then
      card:PlayTween(false)
    end
  end
  self.selectedIndex = index
  self:UpdateSelected()
end

function RaidSelectCardView:UpdateSelected()
  local card = self.cards[self.selectedIndex]
  if card then
    card:PlayTween()
  end
  local canConfirm = self.selectedIndex ~= nil
  self.confirmBtn:SetActive(canConfirm)
  self.fakeConfirmBtn:SetActive(not canConfirm)
end

function RaidSelectCardView:UpdateTick(interval)
  if not self.endTime then
    tickManager:ClearTick(self)
    return
  end
  local countdown = self.endTime - ServerTime.CurServerTime() / 1000
  self.countdownLabel.text = string.format("%d", math.ceil(countdown))
  if countdown < 0 then
    self:CloseSelf()
  end
end

function RaidSelectCardView:UpdateCards()
  self.cardCtrl:ResetDatas(self.cardIds)
end
