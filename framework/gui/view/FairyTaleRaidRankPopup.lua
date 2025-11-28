autoImport("FairyTaleRaidRankCell")
FairyTaleRaidRankPopup = class("FairyTaleRaidRankPopup", ContainerView)
FairyTaleRaidRankPopup.ViewType = UIViewType.PopUpLayer
local playerTipFunc = {
  "SendMessage",
  "AddFriend",
  "ShowDetail"
}
local playerTipFunc_Friend = {
  "SendMessage",
  "ShowDetail"
}

function FairyTaleRaidRankPopup:Init()
  self:FindObjs()
  self.tipData = {}
  self:AddListenEvts()
  self:QueryRankInfo()
end

function FairyTaleRaidRankPopup:FindObjs()
  self.objLoading = self:FindGO("LoadingRoot")
  self.objLoading:SetActive(true)
  self.objEmptyList = self:FindGO("EmptyList")
  self.inputSearch = self:FindComponent("InputSearch", UIInput)
  local searchBtn = self:FindGO("SearchButton")
  self:AddClickEvent(searchBtn, function()
    if self.objLoading.activeSelf then
      return
    end
    self:RefreshView()
  end)
  local container = self:FindGO("rankContainer")
  self.rankListCtrl = WrapListCtrl.new(container, FairyTaleRaidRankCell, "FairyTaleRaidRankCell", WrapListCtrl_Dir.Vertical)
  self.rankListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickCellHead, self)
end

function FairyTaleRaidRankPopup:AddListenEvts()
  self:AddListenEvt(ServiceEvent.SceneUser3FairyTaleRankQueryCmd, self.HandleFairyRankQueryCmd)
end

function FairyTaleRaidRankPopup:HandleFairyRankQueryCmd(note)
  local data = note.body
  if data.is_end then
    self.isQuerying = false
    self:RefreshView()
  end
end

function FairyTaleRaidRankPopup:OnEnter()
  if self.isQuerying then
    return
  end
  self:RefreshView()
end

function FairyTaleRaidRankPopup:OnExit()
end

function FairyTaleRaidRankPopup:QueryRankInfo()
  self.isQuerying = FairyTaleProxy.Instance:QueryRankInfo()
end

function FairyTaleRaidRankPopup:RefreshView()
  local datas
  local searchInput = self.inputSearch.value
  if not StringUtil.IsEmpty(searchInput) then
    datas = FairyTaleProxy.Instance:GetRankInfoSearchResult(searchInput)
  else
    datas = FairyTaleProxy.Instance:GetRankInfo()
  end
  self.objLoading:SetActive(false)
  self.objEmptyList:SetActive(#datas == 0)
  self.rankListCtrl:ResetDatas(datas, true)
end

local playerTipOffset = {-70, 14}

function FairyTaleRaidRankPopup:OnClickCellHead(cell)
  local cellData = cell.data
  if cell == self.curCell or cellData.charId == Game.Myself.data.id then
    FunctionPlayerTip.Me():CloseTip()
    self.curCell = nil
    return
  end
  self.curCell = cell
  local playerTip = FunctionPlayerTip.Me():GetPlayerTip(cell.headIcon.frameSp, NGUIUtil.AnchorSide.TopRight, playerTipOffset)
  local player = PlayerTipData.new()
  player:SetByFairyTaleRankData(cellData)
  self.tipData.playerData = player
  self.tipData.funckeys = FriendProxy.Instance:IsFriend(cellData.charId) and playerTipFunc_Friend or playerTipFunc
  playerTip:SetData(self.tipData)
  playerTip:AddIgnoreBound(cell.headIcon.gameObject)
  
  function playerTip.closecallback()
    self.curCell = nil
  end
end
