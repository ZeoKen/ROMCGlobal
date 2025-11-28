autoImport("DesertWolfRoomInfoCell")
DesertWolfNewView = class("DesertWolfNewView", SubView)

function DesertWolfNewView:LoadSubView()
  local viewPath = ResourcePathHelper.UIView("DesertWolf/DesertWolfNewView")
  local parentView = self:FindGO("DesertWolfView")
  local obj = self:LoadPreferb_ByFullPath(viewPath, parentView, true)
  obj.name = "DesertWolfNewView"
  self.gameObject = obj
end

function DesertWolfNewView:Init()
  self.pvpType = PvpProxy.Type.DesertWolf
  self:LoadSubView()
  self:FindObjs()
  self:AddViewEvts()
  self:UpdateView()
end

function DesertWolfNewView:FindObjs()
  self.emptyGO = self:FindGO("Empty")
  self.refreshBtnGO = self:FindGO("RefreshBtn")
  self:AddClickEvent(self.refreshBtnGO, function()
    self:OnRefreshClicked()
  end)
  self.ruleBtnGO = self:FindGO("RuleBtn")
  local help_id = PanelConfig.DesertWolfNewView.id
  self:RegistShowGeneralHelpByHelpID(help_id, self.ruleBtnGO)
  self.createBtnGO = self:FindGO("CreateBtn")
  self:AddClickEvent(self.createBtnGO, function()
    self:OnCreateClicked()
  end)
  self.createLab = self:FindComponent("Label", UILabel, self.createBtnGO)
  local roomListTable = self:FindComponent("RoomListTable", UITable)
  self.roomListCtrl = ListCtrl.new(roomListTable, DesertWolfRoomInfoCell, "DesertWolf/DesertWolfRoomInfoCell")
  self.roomListCtrl:AddEventListener(UICellEvent.OnRightBtnClicked, self.OnJoinClicked, self)
end

function DesertWolfNewView:OnTabEnabled()
  self:UpdateView()
end

function DesertWolfNewView:OnTabDisabled()
end

function DesertWolfNewView:OnDestroy()
  PvpCustomRoomProxy.Instance:ClearRoomList()
end

function DesertWolfNewView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.MatchCCmdReserveRoomListMatchCCmd, self.RefreshView)
  self:AddDispatcherEvt(CustomRoomEvent.OnCurrentRoomChanged, self.OnCurrentRoomChanged)
end

function DesertWolfNewView:RefreshRoomList()
  PvpCustomRoomProxy.Instance:SendRoomListReq(self.pvpType)
end

function DesertWolfNewView:UpdateView()
  if not self.gameObject.activeInHierarchy then
    return
  end
  self:RefreshRoomList()
end

function DesertWolfNewView:RefreshView()
  if not self.gameObject.activeInHierarchy then
    return
  end
  local proxy = PvpCustomRoomProxy.Instance
  local roomList = proxy:GetRoomList() or {}
  self.roomListCtrl:ResetDatas(roomList)
  self.emptyGO:SetActive(#roomList == 0)
  local myRoomData = PvpCustomRoomProxy.Instance:GetCurrentRoomData()
  if myRoomData and myRoomData.pvptype == self.pvpType then
    self.createLab.text = ZhString.PvpCustomRoom_MyRoom
  else
    self.createLab.text = ZhString.PvpCustomRoom_CreateRoom
  end
end

function DesertWolfNewView:OnRefreshClicked()
  self:UpdateView()
end

function DesertWolfNewView:OnCreateClicked()
  local myRoomData = PvpCustomRoomProxy.Instance:GetCurrentRoomData()
  if myRoomData then
    if myRoomData.pvptype ~= self.pvpType then
      MsgManager.ShowMsgByID(475)
      return
    end
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.DesertWolfRoomInfoPopup
    })
  else
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.DesertWolfCreateRoomPopup
    })
  end
end

function DesertWolfNewView:OnJoinClicked(cell)
  local proxy = PvpCustomRoomProxy.Instance
  if proxy:GetCurrentRoomData() then
    MsgManager.ShowMsgByID(475)
    return
  end
  local roomData = cell and cell.data
  if not roomData then
    return
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.DesertWolfCreateRoomPopup,
    viewdata = {
      mode = PvpCustomRoomProxy.CreateRoomMode.EnterPreview,
      roomdata = roomData
    }
  })
end

function DesertWolfNewView:OnCurrentRoomChanged(evt)
  local data = evt and evt.data
  if data and data.pvptype == PvpProxy.Type.DesertWolf and (data.event == PvpCustomRoomProxy.CurrentRoomDataEvent.Enter or data.event == PvpCustomRoomProxy.CurrentRoomDataEvent.Leave) then
    self:UpdateView()
  end
end
