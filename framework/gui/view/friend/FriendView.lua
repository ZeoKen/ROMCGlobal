autoImport("WrapCellHelper")
autoImport("FriendProxy")
autoImport("FriendInfoCell")
FriendView = class("FriendView", SubView)
local addFavoriteItems = {}
local delFavoriteItems = {}
local refreshSymbolHeight = 29
local originPanelHeight = 474

function FriendView:OnEnter()
  self.super.OnEnter(self)
  TableUtility.ArrayClear(addFavoriteItems)
  TableUtility.ArrayClear(delFavoriteItems)
  ServiceSessionSocialityProxy.Instance:CallFrameStatusSocialCmd(true)
end

function FriendView:OnExit()
  ServiceSessionSocialityProxy.Instance:CallFrameStatusSocialCmd(false)
  self.super.OnExit(self)
end

function FriendView:Init()
  self:FindObj()
  self:InitShow()
  self:AddButtonEvt()
  self:AddViewEvt()
end

function FriendView:FindObj()
  self.RequestInfoBtn = self:FindGO("RequestInfoBtn")
  self.ListTip = self:FindGO("ListTip"):GetComponent(UILabel)
  self.listTipGO = self.ListTip.gameObject
  self.loading = self:FindGO("Loading")
  self.pullstopSV = self:FindGO("ContentScrollView"):GetComponent(PullStopScrollView)
  self.refreshSymbol = self:FindGO("RefreshSymbol")
  self.refreshSymbol:SetActive(true)
  self.markFavoriteControls = self:FindGO("MarkFavoriteControls")
  self.markFavoriteControls:SetActive(false)
  self.pullstopSVPanel = self.pullstopSV.panel
end

function FriendView:InitShow()
  self.ListTip.text = ZhString.Friend_ListTip
  self.funkey = {
    "AddFriend",
    "InviteMember",
    "SendMessage",
    "DeleteFriend",
    "ShowDetail",
    "AddBlacklist",
    "InviteEnterGuild",
    "GuildMercenaryInvite",
    "GuildMercenaryApply",
    "Tutor_InviteBeTutor",
    "Tutor_InviteBeStudent",
    "EnterHomeRoom",
    "ApplyEnterGuild"
  }
  self.funkeyOffline = {
    "AddFriend",
    "SendMessage",
    "DeleteFriend",
    "ShowDetail",
    "AddBlacklist",
    "InviteEnterGuild",
    "EnterHomeRoom",
    "ApplyEnterGuild"
  }
  self.tipData = {}
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_SOCIAL_FRIEND_APPLY, self.RequestInfoBtn, 4, {-5, -5})
  local contentContainer = self:FindGO("ContentContainer")
  local wrapConfig = {
    wrapObj = contentContainer,
    pfbNum = 5,
    cellName = "FriendInfoCell",
    control = FriendInfoCell,
    dir = 1,
    disableDragIfFit = false
  }
  self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
  self.itemWrapHelper:AddEventListener(FriendEvent.SelectHead, self.HandleClickItem, self)
  self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.ClickFriendCell, self)
  self.itemCells = self.itemWrapHelper:GetCellCtls()
  self.favoriteFriend = {}
  self.favoriteCheck = false
  self:UpdateFriendData()
end

function FriendView:HandleClickItem(cellctl)
  if self.markingFavoriteMode then
    self:ClickFriendCell(cellctl)
  else
    local data = cellctl.data
    local playerData = PlayerTipData.new()
    playerData:SetByFriendData(cellctl.data)
    FunctionPlayerTip.Me():CloseTip()
    TableUtility.TableClear(self.tipData)
    self.tipData.playerData = playerData
    if data.offlinetime == 0 then
      self.tipData.funckeys = self.funkey
    else
      self.tipData.funckeys = self.funkeyOffline
    end
    FunctionPlayerTip.Me():GetPlayerTip(cellctl.headIcon.clickObj, NGUIUtil.AnchorSide.Left, {-380, 60}, self.tipData)
  end
end

function FriendView:AddButtonEvt()
  self:AddClickEvent(self.RequestInfoBtn, function(g)
    self:CheckFavoriteModeOnExit(function()
      self:ExitMarkingFavoriteMode()
      self:ApplyInfo(g)
    end)
  end)
  local AddFriendBtn = self:FindGO("AddFriendBtn")
  self:AddClickEvent(AddFriendBtn, function(g)
    self:CheckFavoriteModeOnExit(function()
      self:ExitMarkingFavoriteMode()
      self:AddFriend(g)
    end)
  end)
  local BlacklistBtn = self:FindGO("BlacklistBtn")
  self:AddClickEvent(BlacklistBtn, function()
    self:CheckFavoriteModeOnExit(function()
      self:ExitMarkingFavoriteMode()
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.BlacklistView
      })
    end)
  end)
  self:AddButtonEvent("MarkFavoriteButton", function(go)
    local switchModeOnAction = function()
      self:SwitchMarkingFavoriteMode(true)
    end
    local dont = LocalSaveProxy.Instance:GetDontShowAgain(32601)
    if not dont then
      MsgManager.DontAgainConfirmMsgByID(32601, switchModeOnAction, switchModeOnAction)
    else
      switchModeOnAction()
    end
  end)
  self:AddButtonEvent("MarkFavoriteButtonFake", function(go)
    self:SwitchMarkingFavoriteMode()
  end)
  self:AddButtonEvent("FreshButton", function(go)
    self:UpdateFriendData()
    self.pullstopSV:Revert()
  end)
  self:AddClickEvent(self:FindGO("allTab"), function()
    self.favoriteCheck = false
    self:UpdateFriendData()
  end)
  self:AddClickEvent(self:FindGO("favoriteTab"), function()
    self.favoriteCheck = true
    self:UpdateFriendData()
  end)
end

function FriendView:ApplyInfo()
  local datas = FriendProxy.Instance:GetApplyData()
  if 0 < #datas then
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.FriendApplyInfoView
    })
  else
    RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_SOCIAL_FRIEND_APPLY)
    MsgManager.ShowMsgByIDTable(423)
  end
end

function FriendView:AddFriend()
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.AddFriendView
  })
end

function FriendView:AddViewEvt()
  self:AddListenEvt(ServiceEvent.SessionSocialityQuerySocialData, self.UpdateFriendData)
  self:AddListenEvt(ServiceEvent.SessionSocialitySocialUpdate, self.RefreshFriendData)
  self:AddListenEvt(ServiceEvent.SessionSocialitySocialDataUpdate, self.RefreshFriendData)
  self:AddListenEvt(ServiceEvent.UserEventQueryFavoriteFriendUserEvent, self.UpdateFriendData)
  self:AddListenEvt(ServiceEvent.UserEventUpdateFavoriteFriendUserEvent, self.UpdateFriendData)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
end

function FriendView:RefreshFriendData(note)
  local fDatas = FriendProxy.Instance.FriendData
  if #fDatas ~= #self.curDatas then
    self:UpdateFriendData()
    return
  end
  local oldData
  if self.favoriteCheck then
    if not self.favoriteFriend then
      self:UpdateFriendData()
      return
    end
    for i = 1, #self.favoriteFriend do
      oldData = self.favoriteFriend[i]
      if oldData then
        local newData = FriendProxy.Instance:GetFriendById(oldData.guid)
        if newData then
          self.favoriteFriend[i] = newData
        end
      end
    end
    self.itemWrapHelper:UpdateInfo(self:ReUnitData(self.favoriteFriend, 3), false)
    self.listTipGO:SetActive(#self.favoriteFriend == 0)
    self.ListTip.text = ZhString.Friend_FavoriteListTip
  else
    if not self.curDatas then
      self:UpdateFriendData()
      return
    end
    for i = 1, #self.curDatas do
      oldData = self.curDatas[i]
      if oldData then
        local newData = FriendProxy.Instance:GetFriendById(oldData.guid)
        if newData then
          self.curDatas[i] = newData
        end
      end
    end
    self.itemWrapHelper:UpdateInfo(self:ReUnitData(self.curDatas, 3), false)
    self.listTipGO:SetActive(#self.curDatas == 0)
    self.ListTip.text = ZhString.Friend_ListTip
  end
  self:UpdateFavoriteTip()
end

local afkCheck = AfkProxy.ParseIsAfk
local lIsOnline, lAfk
local SortFunc = function(l, r)
  local isFavoritel = FriendProxy.Instance:CheckIsFavorite(l.guid)
  local isFavoriter = FriendProxy.Instance:CheckIsFavorite(r.guid)
  if isFavoritel ~= isFavoriter then
    return isFavoritel
  end
  lIsOnline = l:IsOnline()
  if lIsOnline ~= r:IsOnline() then
    return lIsOnline
  end
  lAfk = afkCheck(l.afk)
  if lAfk ~= afkCheck(r.afk) then
    return lAfk
  end
  if l.serverid ~= r.serverid then
    return l.serverid == MyselfProxy.Instance:GetServerId()
  end
  if lIsOnline and l.level ~= r.level then
    return l.level > r.level
  end
  return l.offlinetime > r.offlinetime
end

function FriendView:UpdateFriendData()
  local isQuerySocialData = ServiceSessionSocialityProxy.Instance:IsQuerySocialData()
  local datas = FriendProxy.Instance:GetFriendData()
  table.sort(datas, SortFunc)
  if self.favoriteCheck then
    TableUtility.ArrayClear(self.favoriteFriend)
    for i = 1, #datas do
      if FriendProxy.Instance:CheckIsFavorite(datas[i].guid) then
        table.insert(self.favoriteFriend, datas[i])
      end
    end
  end
  if not self.curDatas then
    self.curDatas = {}
  else
    TableUtility.ArrayClear(self.curDatas)
  end
  for i = 1, #datas do
    self.curDatas[i] = datas[i]
  end
  if isQuerySocialData then
    if self.favoriteCheck then
      self.itemWrapHelper:UpdateInfo(self:ReUnitData(self.favoriteFriend, 3))
      self.listTipGO:SetActive(#self.favoriteFriend == 0)
      self.ListTip.text = ZhString.Friend_FavoriteListTip
    else
      self.itemWrapHelper:UpdateInfo(self:ReUnitData(self.curDatas, 3))
      self.listTipGO:SetActive(#self.curDatas == 0)
      self.ListTip.text = ZhString.Friend_ListTip
    end
    self:UpdateFavoriteTip()
  else
    self.listTipGO:SetActive(false)
  end
  self.loading:SetActive(not isQuerySocialData)
end

function FriendView:ReUnitData(datas, fullNum)
  if not self.unitData then
    self.unitData = {}
  else
    TableUtility.ArrayClear(self.unitData)
  end
  if datas ~= nil and 0 < #datas then
    if fullNum > #datas then
      for i = 1, fullNum do
        self.unitData[i] = datas[i] or {}
      end
    else
      return datas
    end
  end
  return self.unitData
end

function FriendView:UpdateSocial(note)
  self:UpdateFriendData()
end

function FriendView:UpdateSocialData(data)
  self:UpdateFriendData()
  local itemList = self.itemWrapHelper:GetCellCtls()
  for i = 1, #itemList do
    local cellctl = itemList[i]
    if cellctl.data and cellctl.data.guid == data.body.guid and data.body.type == SessionSociality_pb.ESOCIALDATA_OFFLINETIME then
      cellctl:RefreshOfflinetime()
    end
  end
end

function FriendView:SwitchMarkingFavoriteMode(on)
  local isOn = on == true and true or false
  self.markingFavoriteMode = on
  self.markFavoriteControls:SetActive(isOn)
  self.refreshSymbol:SetActive(not isOn)
  if not on and (next(addFavoriteItems) or next(delFavoriteItems)) then
    self:TrySendFavorite()
    self:UpdateFriendData()
  end
  local tmpClipRegion = self.pullstopSVPanel.baseClipRegion
  tmpClipRegion.y = on and -refreshSymbolHeight / 3 or refreshSymbolHeight
  tmpClipRegion.w = tmpClipRegion.w + refreshSymbolHeight * 3 * (on and -1 or 1)
  self.pullstopSVPanel.baseClipRegion = tmpClipRegion
end

function FriendView:ClickFriendCell(cellCtl)
  if not cellCtl then
    return
  end
  local data = cellCtl and cellCtl.data
  if not data then
    return
  end
  if self.markingFavoriteMode then
    cellCtl:NegateFavoriteTip()
    local friendGuid = data.guid
    TableUtility.ArrayRemove(addFavoriteItems, friendGuid)
    TableUtility.ArrayRemove(delFavoriteItems, friendGuid)
    local wasFavorite = FriendProxy.Instance:CheckIsFavorite(friendGuid)
    local newFavorite = cellCtl:GetFavoriteTipActive()
    if wasFavorite ~= newFavorite then
      local arrToAdd = newFavorite and addFavoriteItems or delFavoriteItems
      TableUtility.ArrayPushBack(arrToAdd, friendGuid)
      cellCtl:ShowMask()
    else
      cellCtl:HideMask()
    end
    return
  end
end

function FriendView:TrySendFavorite()
  ServiceUserEventProxy.Instance:CallActionFavoriteFriendUserEvent(addFavoriteItems, delFavoriteItems)
  self:ResetSelectMask()
end

function FriendView:UpdateFavoriteTip()
  if self.itemCells then
    for _, cell in pairs(self.itemCells) do
      cell:UpdateFavoriteTip()
    end
  end
end

function FriendView:CheckFavoriteModeOnExit(checkCompleteHandler)
  if self.markingFavoriteMode and (next(addFavoriteItems) or next(delFavoriteItems)) then
    MsgManager.ConfirmMsgByID(32600, function()
      self:TrySendFavorite()
      checkCompleteHandler()
    end, checkCompleteHandler)
  else
    checkCompleteHandler()
  end
end

function FriendView:ExitMarkingFavoriteMode()
  self.markingFavoriteMode = false
  self.markFavoriteControls:SetActive(false)
  self.refreshSymbol:SetActive(true)
  local tmpClipRegion = self.pullstopSVPanel.baseClipRegion
  tmpClipRegion.y = on and -refreshSymbolHeight / 3 or refreshSymbolHeight
  tmpClipRegion.w = originPanelHeight
  self.pullstopSVPanel.baseClipRegion = tmpClipRegion
  self:ResetSelectMask()
  self:UpdateFavoriteTip()
end

function FriendView:ResetSelectMask()
  if not self.itemCells then
    return
  end
  for _, cell in pairs(self.itemCells) do
    cell:HideMask()
  end
  TableUtility.ArrayClear(addFavoriteItems)
  TableUtility.ArrayClear(delFavoriteItems)
end
