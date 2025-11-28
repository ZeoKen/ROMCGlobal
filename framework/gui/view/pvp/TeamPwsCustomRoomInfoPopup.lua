autoImport("TeamPwsCustomRoomMemberCell")
TeamPwsCustomRoomInfoPopup = class("TeamPwsCustomRoomInfoPopup", BaseView)
TeamPwsCustomRoomInfoPopup.ViewType = UIViewType.PopUpLayer
autoImport("BanCardCell")

function TeamPwsCustomRoomInfoPopup:Init()
  local proxy = PvpCustomRoomProxy.Instance
  self.titleLabel = self:FindComponent("TitleLabel", UILabel)
  self.modeLabel = self:FindComponent("ModeLabel", UILabel)
  self.freeFireGO = self:FindGO("FreeFireSprite")
  self:RegistShowGeneralHelpByHelpID(32599, self.freeFireGO)
  local isHost = proxy:IsCurrentRoomHost(Game.Myself.data.id)
  self.readyGO = self:FindGO("ReadySprite")
  self:AddClickEvent(self.readyGO, function()
    self:OnConfirmReadyClicked()
  end)
  self.readyGO:SetActive(isHost)
  self.settingBtnGO = self:FindGO("SettingButton")
  self:AddClickEvent(self.settingBtnGO, function()
    self:OnSettingClicked()
  end)
  self.closeBtnGO = self:FindGO("CloseButton")
  self:AddClickEvent(self.closeBtnGO, function()
    self:OnCloseClicked()
  end)
  self.leaveBtnGO = self:FindGO("LeaveButton")
  self:AddClickEvent(self.leaveBtnGO, function()
    self:OnLeaveClicked()
  end)
  self.startBtnGO = self:FindGO("StartButton")
  self:AddClickEvent(self.startBtnGO, function()
    self:OnStartClicked()
  end)
  self.startBtnGO:SetActive(isHost)
  self.startBtnSprite = self.startBtnGO:GetComponent(UIMultiSprite)
  self.startLabel = self:FindComponent("Label", UILabel, self.startBtnGO)
  self:InitTeamCtl()
  local teamHomeBtnGO = self:FindGO("Team1Btn")
  self:AddClickEvent(teamHomeBtnGO, function()
    self:OnChangeTeamClicked(EROOMTEAMTYPE.EROOMTEAMTYPE_TEAMONE)
  end)
  self.teamHomeWidget = teamHomeBtnGO:GetComponent(UISprite)
  local teamAwayBtnGO = self:FindGO("Team2Btn")
  self:AddClickEvent(teamAwayBtnGO, function()
    self:OnChangeTeamClicked(EROOMTEAMTYPE.EROOMTEAMTYPE_TEAMTWO)
  end)
  self.teamAwayWidget = teamAwayBtnGO:GetComponent(UISprite)
  local teamObBtnBO = self:FindGO("Team3Btn")
  if teamObBtnBO then
    self:AddClickEvent(teamObBtnBO, function()
      self:OnChangeTeamClicked(EROOMTEAMTYPE.EROOMTEAMTYPE_TEAMOB)
    end)
    self.teamObWidget = teamObBtnBO:GetComponent(UISprite)
  end
  self.banCardGO = self:FindGO("BanCard")
  if self.banCardGO then
    self.banCardGrid = self:FindComponent("CardGrid", UIGrid)
    self.banCardListCtrl = UIGridListCtrl.new(self.banCardGrid, BanCardCell, "BagCardCell")
    self.banCardListCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickCardCell, self)
    self.connectBanCardGrid = self:FindComponent("ConnectCardGrid", UIGrid)
    self.connectBanCardListCtrl = UIGridListCtrl.new(self.connectBanCardGrid, BanCardCell, "BagCardCell")
  end
  self:AddListenEvt(ServiceEvent.MatchCCmdReserveRoomLeaveMatchCCmd, self.HandleLeaveRoomResp)
  self:AddListenEvt(ServiceEvent.MatchCCmdReserveRoomInfoMatchCCmd, self.UpdateView)
  self:AddListenEvt(CustomRoomEvent.OnEnterBattle, self.OnBattleChanged)
  self:UpdateView()
end

function TeamPwsCustomRoomInfoPopup:InitTeamCtl()
  local listTeamHomeGO = self:FindGO("ListTeamHomeScroll")
  local listTeamHomeGrid = self:FindComponent("ListTeamHome", UIGrid, listTeamHomeGO)
  self.listTeamHome = UIGridListCtrl.new(listTeamHomeGrid, TeamPwsCustomRoomMemberCell, "TeamPwsCustomRoomMemberCell")
  self.listTeamHome:AddEventListener(UICellEvent.OnCellClicked, self.OnRoomCellClicked, self)
  self.listTeamHome:AddEventListener(UICellEvent.OnLeftBtnClicked, self.OnPlayerClicked, self)
  self.listTeamHome:AddEventListener(UICellEvent.OnRightBtnClicked, self.OnKickPlayerClicked, self)
  local listTeamAwayGO = self:FindGO("ListTeamAwayScroll")
  local listTeamAwayGrid = self:FindComponent("ListTeamAway", UIGrid, listTeamAwayGO)
  self.listTeamAway = UIGridListCtrl.new(listTeamAwayGrid, TeamPwsCustomRoomMemberCell, "TeamPwsCustomRoomMemberCell")
  self.listTeamAway:AddEventListener(UICellEvent.OnCellClicked, self.OnRoomCellClicked, self)
  self.listTeamAway:AddEventListener(UICellEvent.OnLeftBtnClicked, self.OnPlayerClicked, self)
  self.listTeamAway:AddEventListener(UICellEvent.OnRightBtnClicked, self.OnKickPlayerClicked, self)
  local listTeamObGO = self:FindGO("ListTeamObScroll")
  if listTeamObGO then
    local listTeamObGrid = self:FindComponent("ListTeamOb", UIGrid, listTeamObGO)
    self.listTeamOb = UIGridListCtrl.new(listTeamObGrid, TeamPwsCustomRoomMemberCell, "TeamPwsCustomRoomMemberCell")
    self.listTeamOb:AddEventListener(UICellEvent.OnCellClicked, self.OnRoomCellClicked, self)
    self.listTeamOb:AddEventListener(UICellEvent.OnLeftBtnClicked, self.OnPlayerClicked, self)
    self.listTeamOb:AddEventListener(UICellEvent.OnRightBtnClicked, self.OnKickPlayerClicked, self)
  end
end

function TeamPwsCustomRoomInfoPopup:OnEnter()
  TeamPwsCustomRoomInfoPopup.super.OnEnter(self)
  PvpCustomRoomProxy.Instance:QueryCurrentRoomInfoIfNeed()
end

function TeamPwsCustomRoomInfoPopup:OnExit()
  self:CloseTip()
  TeamPwsCustomRoomInfoPopup.super.OnExit(self)
end

function TeamPwsCustomRoomInfoPopup:OnChangeTeamClicked(teamtype)
  local proxy = PvpCustomRoomProxy.Instance
  if proxy:IsInBattle() then
    return
  end
  proxy:SendChangeTeamReq(teamtype)
end

function TeamPwsCustomRoomInfoPopup:CheckSettingClickValid()
  local proxy = PvpCustomRoomProxy.Instance
  local roomData = proxy:GetCurrentRoomData()
  return roomData ~= nil
end

function TeamPwsCustomRoomInfoPopup:OnSettingClicked()
  redlog("OnSettingClicked")
  if not self:CheckSettingClickValid() then
    return
  end
  if PvpCustomRoomProxy.Instance:IsInBattle() then
    MsgManager.ShowMsgByID(476)
    return
  end
  local roomData = PvpCustomRoomProxy.Instance:GetCurrentRoomData()
  local mode = not roomData:IsHost(Game.Myself.data.id) and PvpCustomRoomProxy.CreateRoomMode.InRoomPreview
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.TeamPwsCreateRoomPopup,
    viewdata = {
      type = roomData.pvptype,
      roomdata = roomData,
      mode = mode
    }
  })
end

function TeamPwsCustomRoomInfoPopup:OnCloseClicked()
  self:CloseSelf()
end

function TeamPwsCustomRoomInfoPopup:OnConfirmReadyClicked()
  local proxy = PvpCustomRoomProxy.Instance
  if proxy:IsInBattle() then
    return
  end
  proxy:SendReadyAskReq()
end

function TeamPwsCustomRoomInfoPopup:OnLeaveClicked()
  local msg_id = PvpCustomRoomProxy.Instance:IsCurrentRoomHost(Game.Myself.data.id) and 477 or 471
  MsgManager.ConfirmMsgByID(msg_id, function()
    PvpCustomRoomProxy.Instance:SendLeaveRoomReq()
  end, nil, nil)
end

function TeamPwsCustomRoomInfoPopup:OnStartClicked()
  PvpCustomRoomProxy.Instance:SendStartGameReq()
end

function TeamPwsCustomRoomInfoPopup:UpdateView()
  local proxy = PvpCustomRoomProxy.Instance
  local roomData = proxy:GetCurrentRoomData()
  if not roomData then
    self:CloseSelf()
    return
  end
  local myselfId = Game.Myself.data.id
  local isRoomHost = roomData:IsHost(myselfId)
  self.settingBtnGO:SetActive(isRoomHost)
  self.titleLabel.text = roomData:GetRoomName()
  local raidConfig = proxy:GetRaidConfigByRaidId(roomData.raidid, roomData.pvptype)
  self.modeLabel.text = raidConfig and raidConfig.name or ""
  self.freeFireGO:SetActive(roomData:IsFreeFire())
  self:UpdateHomeAwayMembers()
  if self.toggledCell and not self.toggledCell.isBtnGroupShown then
    self.toggledCell = nil
  end
  local currentTeamIndex = proxy:GetCurrentTeamIndex(myselfId)
  self.teamHomeWidget.alpha = currentTeamIndex == EROOMTEAMTYPE.EROOMTEAMTYPE_TEAMONE and 0.4 or 1.0
  self.teamAwayWidget.alpha = currentTeamIndex == EROOMTEAMTYPE.EROOMTEAMTYPE_TEAMTWO and 0.4 or 1.0
  if self.teamObWidget then
    self.teamObWidget.alpha = currentTeamIndex == EROOMTEAMTYPE.EROOMTEAMTYPE_TEAMOB and 0.4 or 1.0
  end
  if roomData:CanStart() then
    self.startBtnSprite.CurrentState = 0
    self.startLabel.effectColor = ColorUtil.ButtonLabelOrange
  else
    self.startBtnSprite.CurrentState = 1
    self.startLabel.effectColor = ColorUtil.TitleGray
  end
  local banCardIds = roomData:GetBanCardList()
  local isForbidCard = roomData.isforbidcard
  if isForbidCard and banCardIds and 0 < #banCardIds then
    self.banCardGO:SetActive(true)
    local result = {}
    local connectResult = {}
    for i = 1, #banCardIds do
      local id = banCardIds[i]
      local itemData = ItemData.new("CardBan", id)
      itemData.isBan = true
      table.insert(result, itemData)
      local cardConfig = Table_Card[id]
      if cardConfig and cardConfig.ForbidCards and cardConfig.ForbidCards[1] then
        local connectCardItemData = ItemData.new("CardBan", cardConfig.ForbidCards[1])
        connectCardItemData.isBan = true
        table.insert(connectResult, connectCardItemData)
      else
        table.insert(connectResult, BagItemEmptyType.Empty)
      end
    end
    self.banCardListCtrl:ResetDatas(result)
    self.connectBanCardListCtrl:ResetDatas(connectResult)
    local cells = self.connectBanCardListCtrl:GetCells()
    for i = 1, #cells do
      if cells[i].data == BagItemEmptyType.Empty then
        cells[i].widget.alpha = 0
      else
        cells[i].widget.alpha = 1
      end
    end
  else
    self.banCardGO:SetActive(false)
  end
end

function TeamPwsCustomRoomInfoPopup:UpdateHomeAwayMembers()
  local roomData = PvpCustomRoomProxy.Instance:GetCurrentRoomData()
  if not roomData then
    return
  end
  self.listTeamHome:ResetDatas(roomData.homeMembers)
  self.listTeamAway:ResetDatas(roomData.awayMembers)
  if self.listTeamOb then
    self.listTeamOb:ResetDatas(roomData.obMembers)
  end
end

local PlayerRightTipOffset = {-20, 14}
local PlayerLeftTipOffset = {-354, 14}

function TeamPwsCustomRoomInfoPopup:OnPlayerClicked(cell)
  local funcPlayerTip = FunctionPlayerTip.Me()
  local memberData = cell.data
  if cell == self.selectedCell or memberData.id == Game.Myself.data.id or memberData.cat and memberData.cat ~= 0 then
    funcPlayerTip:CloseTip()
    self.selectedCell = nil
    return
  end
  self.selectedCell = cell
  local anchor = cell.data.teamtype == EROOMTEAMTYPE.EROOMTEAMTYPE_TEAMOB and NGUIUtil.AnchorSide.TopLeft or NGUIUtil.AnchorSide.TopRight
  local offset = cell.data.teamtype == EROOMTEAMTYPE.EROOMTEAMTYPE_TEAMOB and PlayerLeftTipOffset or PlayerRightTipOffset
  local playerTip = funcPlayerTip:GetPlayerTip(cell.btnGroupBg, anchor, offset)
  local playerData = PlayerTipData.new()
  playerData:SetByCustomRoomMemberData(memberData)
  local funckeys = funcPlayerTip:GetPlayerFunckey(memberData.id)
  playerTip:SetData({playerData = playerData, funckeys = funckeys})
  playerTip:AddIgnoreBound(cell.btnGroupBg.gameObject)
  
  function playerTip.closecallback()
    self:OnPlayerTipClosed()
  end
  
  function playerTip.clickcallback(funcConfig)
    if funcConfig.key == "SendMessage" then
      self:CloseSelf()
    end
  end
end

function TeamPwsCustomRoomInfoPopup:CloseTip()
  FunctionPlayerTip.Me():CloseTip()
  self.selectedCell = nil
end

function TeamPwsCustomRoomInfoPopup:OnPlayerTipClosed()
  self.selectedCell = nil
end

function TeamPwsCustomRoomInfoPopup:OnKickPlayerClicked(cell)
  MsgManager.ConfirmMsgByID(470, function()
    PvpCustomRoomProxy.Instance:SendKickMemberReq(cell.data.id)
  end, nil, nil, cell.data.name)
end

function TeamPwsCustomRoomInfoPopup:OnRoomCellClicked(cell)
  if PvpCustomRoomProxy.Instance:IsInBattle() then
    return
  end
  self:CloseTip()
  self:ToggleCellMenu(cell)
  if cell:IsEmpty() then
    local roomData = PvpCustomRoomProxy.Instance:GetCurrentRoomData()
    local type = roomData and roomData.pvptype
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TeamInvitePopUp,
      viewdata = {
        isCustomRoomInvite = true,
        etype = type or PvpProxy.Type.FreeBattle,
        teamType = cell.data and cell.data.teamtype
      }
    })
  end
end

function TeamPwsCustomRoomInfoPopup:ToggleCellMenu(cell)
  if self.toggledCell == cell then
    if cell then
      cell:ToggleBtnGroup(false)
      self.toggledCell = nil
    end
    return
  end
  if self.toggledCell then
    self.toggledCell:ToggleBtnGroup(false)
  end
  if cell and not cell:IsEmpty() and cell.data.id ~= Game.Myself.data.id then
    self.toggledCell = cell
    self.toggledCell:ToggleBtnGroup(true)
  else
    self.toggledCell = nil
  end
end

function TeamPwsCustomRoomInfoPopup:HandleLeaveRoomResp()
  self:CloseSelf()
end

function TeamPwsCustomRoomInfoPopup:OnBattleChanged()
  self:CloseSelf()
end

function TeamPwsCustomRoomInfoPopup:HandleClickCardCell(cell)
  local data = cell.data
  local tipData = {}
  tipData.itemdata = data
  self:ShowItemTip(tipData, cell.widget, NGUIUtil.AnchorSide.Right, {200, 0})
end
