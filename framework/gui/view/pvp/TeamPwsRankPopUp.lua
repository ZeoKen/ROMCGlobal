autoImport("TeamPwsRankCell")
TeamPwsRankPopUp = class("TeamPwsRankPopUp", BaseView)
TeamPwsRankPopUp.ViewType = UIViewType.PopUpLayer
local SelectCol = "B36B24"
local UnselectCol = "3E59A7"

function TeamPwsRankPopUp:Init()
  self:FindObjs()
  self:InitView()
  self:AddButtonEvt()
  self:AddListenEvts()
  self.playerTipOffset = {-70, 14}
  self.playerTipInitData = {}
  self.playerTipFunc = {
    "SendMessage",
    "AddFriend",
    "ShowDetail"
  }
  self.playerTipFunc_Friend = {
    "SendMessage",
    "ShowDetail"
  }
end

function TeamPwsRankPopUp:FindObjs()
  self.objLoading = self:FindGO("LoadingRoot")
  self.objEmptyList = self:FindGO("EmptyList")
  self.inputSearch = self:FindComponent("InputSearch", UIInput)
  self.labRank = self:FindComponent("labRank", UILabel)
  self.labName = self:FindComponent("labName", UILabel)
  self.labGrade = self:FindComponent("labGrade", UILabel)
  self.labScore = self:FindComponent("labScore", UILabel)
  local go = self:FindGO("LastSeason")
  if go then
    self.hasDiffSeason = true
    self.lastSeasonSp = self:FindComponent("LastSeason", UIMultiSprite)
    self.lastSeasonLabel = self:FindComponent("Label", UILabel, self.lastSeasonSp.gameObject)
    self.currentSeasonSp = self:FindComponent("CurrentSeason", UIMultiSprite)
    self.currentSeasonLabel = self:FindComponent("Label", UILabel, self.currentSeasonSp.gameObject)
  end
  local currentSeason = self:FindGO("CurrentSeason")
  if currentSeason then
    currentSeason.gameObject:SetActive(ISNoviceServerType ~= true)
  end
  if go then
    go:SetActive(ISNoviceServerType ~= true)
  end
end

function TeamPwsRankPopUp:InitView()
  self.listRanks = WrapListCtrl.new(self:FindGO("rankContainer"), TeamPwsRankCell, "TeamPwsRankCell", WrapListCtrl_Dir.Vertical)
  self.listRanks:AddEventListener(MouseEvent.MouseClick, self.ClickCellHead, self)
  self.selectLast = false
  if self.hasDiffSeason then
    self:SetButtonState(self.lastSeasonSp, self.lastSeasonLabel, 0)
    self:SetButtonState(self.currentSeasonSp, self.currentSeasonLabel, 1)
  end
end

function TeamPwsRankPopUp:SetButtonState(sp, label, state)
  state = state or 0
  sp.CurrentState = state
  local colStr = state == 1 and SelectCol or UnselectCol
  local _, c = ColorUtil.TryParseHexString(colStr)
  label.color = c
end

function TeamPwsRankPopUp:AddButtonEvt()
  self:AddButtonEvent("SearchButton", function()
    self:ClickButtonSearch()
  end)
  self:AddButtonEvent("Mask", function()
    self:CloseSelf()
  end)
  self:AddButtonEvent("LastSeason", function()
    self:ShowLastRankData()
  end)
  self:AddButtonEvent("CurrentSeason", function()
    self:ShowCurrentRankData()
  end)
end

function TeamPwsRankPopUp:ShowLastRankData()
  self.selectLast = true
  self:SetButtonState(self.lastSeasonSp, self.lastSeasonLabel, 1)
  self:SetButtonState(self.currentSeasonSp, self.currentSeasonLabel, 0)
  self:RefreshRankData(nil, true)
  self:UpdateData()
end

function TeamPwsRankPopUp:ShowCurrentRankData()
  self.selectLast = false
  self:SetButtonState(self.lastSeasonSp, self.lastSeasonLabel, 0)
  self:SetButtonState(self.currentSeasonSp, self.currentSeasonLabel, 1)
  self:RefreshRankData()
  self:UpdateData()
end

function TeamPwsRankPopUp:AddListenEvts()
  self:AddListenEvt(ServiceEvent.MatchCCmdQueryTeamPwsRankMatchCCmd, self.HandleQueryTeamPwsRankMatchCCmd)
end

function TeamPwsRankPopUp:HandleQueryTeamPwsRankMatchCCmd(note)
  self:RefreshRankData(nil, self.selectLast)
  self:UpdateData()
end

function TeamPwsRankPopUp:RefreshRankData(searchInput, last)
  if searchInput and 0 < #searchInput then
    self.data = PvpProxy.Instance:GetTeamPwsRankSearchResult(searchInput, self.selectLast)
  else
    self.data = PvpProxy.Instance:GetTeamPwsRankData(last)
  end
end

function TeamPwsRankPopUp:UpdateData(isLayout)
  self.objLoading:SetActive(false)
  if not self.data then
    return
  end
  if isLayout == nil then
    isLayout = true
  end
  self.objEmptyList:SetActive(#self.data < 1)
  self.listRanks:ResetDatas(self.data, isLayout)
end

function TeamPwsRankPopUp:QueryRankData()
  ServiceMatchCCmdProxy.Instance:CallQueryTeamPwsRankMatchCCmd()
end

function TeamPwsRankPopUp:ClickButtonSearch()
  if self.objLoading.activeSelf then
    return
  end
  self:RefreshRankData(self.inputSearch.value)
  self:UpdateData()
end

function TeamPwsRankPopUp:ClickCellHead(cellCtl)
  local cellData = cellCtl.data
  if cellCtl == self.curCell or cellData.charID == Game.Myself.data.id then
    FunctionPlayerTip.Me():CloseTip()
    self.curCell = nil
    return
  end
  self.curCell = cellCtl
  local playerTip = FunctionPlayerTip.Me():GetPlayerTip(cellCtl.headIcon.frameSp, NGUIUtil.AnchorSide.TopRight, self.playerTipOffset)
  local player = PlayerTipData.new()
  player:SetByTeamPwsRankData(cellData)
  self.playerTipInitData.playerData = player
  self.playerTipInitData.funckeys = FriendProxy.Instance:IsFriend(cellData.charID) and self.playerTipFunc_Friend or self.playerTipFunc
  playerTip:SetData(self.playerTipInitData)
  playerTip:AddIgnoreBound(cellCtl.headIcon.gameObject)
  
  function playerTip.clickcallback(funcData)
    if funcData.key == "SendMessage" then
      self:CloseSelf()
    end
  end
  
  function playerTip.closecallback()
    self.curCell = nil
  end
end

function TeamPwsRankPopUp:OnEnter()
  TeamPwsRankPopUp.super.OnEnter(self)
  self.objLoading:SetActive(true)
  self.objEmptyList:SetActive(false)
  self:RefreshRankData()
  if self.data then
    self:UpdateData()
  else
    self:QueryRankData()
  end
end

function TeamPwsRankPopUp:OnExit()
  PvpProxy.Instance:TeamPwsRankDataUseOver()
  TeamPwsRankPopUp.super.OnExit(self)
end

function TeamPwsRankPopUp:OnDestroy()
  self.listRanks:Destroy()
  TeamPwsRankPopUp.super.OnDestroy(self)
end
