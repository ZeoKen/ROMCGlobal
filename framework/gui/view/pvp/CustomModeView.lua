autoImport("TeamPwsCustomRoomInfoCell")
CustomModeView = class("CustomModeView", SubView)

function CustomModeView:LoadSubView()
  local viewPath = ResourcePathHelper.UIView("CustomModeView")
  self.objRoot = self:FindGO("CustomModeView")
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.objRoot, true)
  obj.name = "CustomModeView"
  self.gameObject = obj
end

function CustomModeView:Init()
  self:LoadSubView()
  self:FindObjs()
  self:AddViewEvts()
  self:UpdateView()
end

function CustomModeView:FindObjs()
  self.emptyGO = self:FindGO("Empty")
  self.refreshBtnGO = self:FindGO("RefreshBtn")
  self:AddClickEvent(self.refreshBtnGO, function()
    self:OnRefreshClicked()
  end)
  self.createBtnGO = self:FindGO("CreateBtn")
  self:AddClickEvent(self.createBtnGO, function()
    self:OnCreateClicked()
  end)
  self.createLab = self:FindComponent("Label", UILabel, self.createBtnGO)
  local roomListTable = self:FindComponent("RoomListTable", UITable)
  self.roomListCtrl = ListCtrl.new(roomListTable, TeamPwsCustomRoomInfoCell, "TeamPwsCustomRoomInfoCell")
  self.roomListCtrl:AddEventListener(UICellEvent.OnRightBtnClicked, self.OnJoinClicked, self)
end

function CustomModeView:OnEnter()
  CustomModeView.super.OnEnter(self)
  PvpCustomRoomProxy.Instance:ClearRoomList()
end

function CustomModeView:OnTabEnabled()
  self:UpdateView()
end

function CustomModeView:OnTabDisabled()
end

function CustomModeView:OnDestroy()
  PvpCustomRoomProxy.Instance:ClearRoomList()
end

function CustomModeView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.MatchCCmdReserveRoomListMatchCCmd, self.RefreshView)
  self:AddDispatcherEvt(CustomRoomEvent.OnCurrentRoomChanged, self.OnCurrentRoomChanged)
end

function CustomModeView:RefreshRoomList()
  PvpCustomRoomProxy.Instance:SendRoomListReq(self.pvpType)
end

function CustomModeView:UpdateView()
  if not self.gameObject.activeInHierarchy then
    return
  end
  self:RefreshRoomList()
end

function CustomModeView:RefreshView()
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

function CustomModeView:OnRefreshClicked()
  self:UpdateView()
end

function CustomModeView:OnCreateClicked()
  local myRoomData = PvpCustomRoomProxy.Instance:GetCurrentRoomData()
  if myRoomData then
    if myRoomData.pvptype ~= self.pvpType then
      MsgManager.ShowMsgByID(475)
      return
    end
    local config = PvpCustomRoomProxy.GetRoomPopup(myRoomData.pvptype)
    if config then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = config})
    end
  else
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TeamPwsCreateRoomPopup,
      viewdata = {
        type = self.pvpType
      }
    })
  end
end

function CustomModeView:OnJoinClicked(cell)
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

function CustomModeView:OnCurrentRoomChanged(evt)
  local data = evt and evt.data
  if data and data.pvptype == self.pvpType and (data.event == PvpCustomRoomProxy.CurrentRoomDataEvent.Enter or data.event == PvpCustomRoomProxy.CurrentRoomDataEvent.Leave) then
    self:UpdateView()
  end
end

function CustomModeView:CallMatch()
  local raidId = self.selectCell.id
  if not self.selectCell or self.disableClick then
    return
  end
  if TeamProxy.Instance:ForbiddenByRaidID(raidId) or TeamProxy.Instance:ForbiddenByMatchRaidID(self.pwsConfig.matchid) then
    MsgManager.ShowMsgByID(42041)
    return
  end
  if PvpCustomRoomProxy.Instance:GetCurrentRoomData() ~= nil then
    MsgManager.ShowMsgByID(475)
    return
  end
  ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(T_PVP_TYPE, raidId, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, self.onlyMatchMyServerTog.value)
  self.disableClick = true
  self.ltDisableClick = TimeTickManager.Me():CreateOnceDelayTick(3000, function(owner, deltaTime)
    self.disableClick = false
    self.ltDisableClick = nil
  end, self)
  self.container:CloseSelf()
end

function CustomModeView:OnExit()
  PictureManager.Instance:UnLoadPVP(multiPvpTexName, self.multiPvpTex)
  PictureManager.Instance:UnLoadPVP(JP_Eu_TexUp, self.jp_Eu_Tex)
  if self.ltDisableClick then
    self.ltDisableClick:Destroy()
    self.ltDisableClick = nil
  end
  MultiPvpFreeModeView.super.OnExit(self)
end
