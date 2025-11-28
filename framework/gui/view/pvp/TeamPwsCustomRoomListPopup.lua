autoImport("TeamPwsCustomRoomInfoCell")
autoImport("TeamPwsCustomRoomMenuCell")
TeamPwsCustomRoomListPopup = class("TeamPwsCustomRoomListPopup", BaseView)
TeamPwsCustomRoomListPopup.ViewType = UIViewType.PopUpLayer

function TeamPwsCustomRoomListPopup:Init()
  self.closeBtnGO = self:FindGO("CloseButton")
  self:AddClickEvent(self.closeBtnGO, function()
    self:OnCloseClicked()
  end)
  self.refreshBtnGO = self:FindGO("RefreshButton")
  self:AddClickEvent(self.refreshBtnGO, function()
    self:OnRefreshclicked()
  end)
  self.createRoomBtnGO = self:FindGO("CreateRoomBtn")
  self:AddClickEvent(self.createRoomBtnGO, function()
    self:OnCreateRoomClicked()
  end)
  self.createRoomLabel = self:FindComponent("Label", UILabel, self.createRoomBtnGO)
  self.etype = self.viewdata.viewdata.etype or PvpProxy.Type.FreeBattle
  self.menuScroll = self:FindComponent("MenuScroll", ROUIScrollView)
  self.menuGrid = self:FindComponent("Menu", UIGrid, self.menuScroll.gameObject)
  self.menuList = UIGridListCtrl.new(self.menuGrid, TeamPwsCustomRoomMenuCell, "TeamPwsCustomRoomMenuCell")
  self.menuList:AddEventListener(UICellEvent.OnCellClicked, self.OnMenuClicked, self)
  local roomMenuList = PvpCustomRoomProxy.Instance:GetRoomMenuList(self.etype)
  self.menuList:ResetDatas(roomMenuList)
  self.menuCells = self.menuList:GetCells()
  self.selectedMenuCell = self.menuCells[1]
  self:UpdateSelectedCell()
  self.roomListScroll = self:FindComponent("RoomListScroll", ROUIScrollView)
  self.roomListGrid = self:FindComponent("RoomList", UIGrid, self.roomListScroll.gameObject)
  self.roomList = UIGridListCtrl.new(self.roomListGrid, TeamPwsCustomRoomInfoCell, "TeamPwsCustomRoomInfoCell")
  self.roomList:AddEventListener(UICellEvent.OnRightBtnClicked, self.OnJoinClicked, self)
  self.emptyHint = self:FindGO("EmptyHint")
  self:UpdateView()
  self:AddListenEvt(ServiceEvent.MatchCCmdReserveRoomListMatchCCmd, self.UpdateView)
  self:AddDispatcherEvt(CustomRoomEvent.OnCurrentRoomChanged, self.OnCurrentRoomChanged)
end

function TeamPwsCustomRoomListPopup:OnEnter()
  TeamPwsCustomRoomListPopup.super.OnEnter(self)
  PvpCustomRoomProxy.Instance:ClearRoomList()
  self:RefreshRoomList()
end

function TeamPwsCustomRoomListPopup:RefreshRoomList()
  if not self.selectedMenuCell then
    return
  end
  PvpCustomRoomProxy.Instance:SendRoomListReq(self.selectedMenuCell.data.etype, self.selectedMenuCell.data.raidid)
end

function TeamPwsCustomRoomListPopup:OnCloseClicked()
  self:CloseSelf()
end

function TeamPwsCustomRoomListPopup:OnRefreshclicked()
  self:RefreshRoomList()
end

function TeamPwsCustomRoomListPopup:UpdateView()
  local proxy = PvpCustomRoomProxy.Instance
  local roomList = proxy:GetRoomList()
  self.roomList:ResetDatas(roomList)
  self.emptyHint:SetActive(not roomList or #roomList == 0)
  self.createRoomLabel.text = proxy:GetCurrentRoomDataOfType(PvpProxy.Type.FreeBattle) == nil and ZhString.PvpCustomRoom_CreateRoom or ZhString.PvpCustomRoom_MyRoom
end

function TeamPwsCustomRoomListPopup:UpdateSelectedCell()
  if not self.menuCells then
    return
  end
  for _, v in ipairs(self.menuCells) do
    v:SetSelected(v == self.selectedMenuCell)
  end
end

function TeamPwsCustomRoomListPopup:OnMenuClicked(cell)
  self.selectedMenuCell = cell
  self:UpdateSelectedCell()
  self:RefreshRoomList()
end

function TeamPwsCustomRoomListPopup:OnJoinClicked(cell)
  local proxy = PvpCustomRoomProxy.Instance
  if proxy:GetCurrentRoomData() ~= nil then
    MsgManager.ShowMsgByID(475)
    return
  end
  local roomData = cell and cell.data
  if not roomData then
    return
  end
  if roomData.iscode then
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
      viewname = "PasswordPopup",
      confirmCallback = function(target, pwd)
        proxy:SendEnterRoomReq(roomData.roomid, pwd)
      end,
      callbackTarget = self,
      title = roomData:GetRoomName()
    })
  else
    proxy:SendEnterRoomReq(roomData.roomid)
  end
end

function TeamPwsCustomRoomListPopup:OnCreateRoomClicked()
  local myRoomData = PvpCustomRoomProxy.Instance:GetCurrentRoomData()
  if myRoomData then
    if myRoomData.pvptype ~= PvpProxy.Type.FreeBattle then
      MsgManager.ShowMsgByID(475)
      return
    end
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TeamPwsCustomRoomInfoPopup
    })
  else
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TeamPwsCreateRoomPopup,
      viewdata = {
        type = self.etype
      }
    })
  end
  self:CloseSelf()
end

function TeamPwsCustomRoomListPopup:OnCurrentRoomChanged(evt)
  local data = evt and evt.data
  if data and data.pvptype == PvpProxy.Type.FreeBattle and data.event == PvpCustomRoomProxy.CurrentRoomDataEvent.Enter then
    self:CloseSelf()
  end
end
