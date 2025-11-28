autoImport("TeamPwsRankPopUp")
autoImport("RoguelikeRankCell")
RoguelikeRankPopUp = class("RoguelikeRankPopUp", TeamPwsRankPopUp)
RoguelikeRankPopUp.ViewType = UIViewType.PopUpLayer
local dataCountPerPage = 20

function RoguelikeRankPopUp:FindObjs()
  RoguelikeRankPopUp.super.FindObjs(self)
  self.title = self:FindComponent("Title", UILabel)
end

function RoguelikeRankPopUp:InitView()
  self.isSingleMode = true
  local viewData = self.viewdata.viewdata
  if viewData and viewData.isSingleMode ~= nil then
    self.isSingleMode = viewData.isSingleMode
  end
  self.singleRequestedPageCount = 0
  self.multiRequestedPageCount = 0
  self.listRanks = WrapListCtrl.new(self:FindGO("rankContainer"), RoguelikeRankCell, "TeamPwsRankCell", WrapListCtrl_Dir.Vertical)
  self.listRanks:AddEventListener(MouseEvent.MouseClick, self.ClickCellHead, self)
  self.listCells = self.listRanks:GetCells()
  self:InitScrollView()
  self.title.text = ZhString.Roguelike_RankPopUpTitle
  local updateTab = function(isSingle)
    self.isSingleMode = isSingle and true or false
    self:RefreshRankData()
    self:UpdateData(true)
  end
  self:AddButtonEvent("SingleTab", function()
    updateTab(true)
  end)
  self:AddButtonEvent("MultiTab", function()
    updateTab(false)
  end)
end

function RoguelikeRankPopUp:InitScrollView()
  self.scrollView = self:FindComponent("RankScrollView", UIScrollView)
  
  function self.scrollView.onMomentumMove()
    if self.onScrollMomentumMoveDisabled then
      return
    end
    self.onScrollMomentumMoveDisabled = true
    self:DelayCall(function()
      self.onScrollMomentumMoveDisabled = nil
    end, 750)
    local pageCount, rank = self:GetRequestedPageCount()
    if pageCount >= math.ceil(GameConfig.Roguelike.RankShowNum / dataCountPerPage) then
      return
    end
    for _, cell in pairs(self.listCells) do
      rank = cell.data and cell.data.rank
      if rank and rank == pageCount * dataCountPerPage - 5 then
        DungeonProxy.RequestRoguelikeRankInfo(self.isSingleMode, pageCount + 1)
        break
      end
    end
  end
end

function RoguelikeRankPopUp:AddListenEvts()
  self:AddListenEvt(ServiceEvent.RoguelikeCmdRoguelikeRankInfoCmd, self.OnRecvRankInfo)
end

function RoguelikeRankPopUp:OnEnter()
  RoguelikeRankPopUp.super.OnEnter(self)
  DungeonProxy.RequestRoguelikeRankInfo(true, 1)
  DungeonProxy.RequestRoguelikeRankInfo(false, 1)
end

function RoguelikeRankPopUp:OnExit()
  RoguelikeRankPopUp.super.super.OnExit(self)
end

function RoguelikeRankPopUp:OnRecvRankInfo(note)
  if note.body then
    if note.body.multi == 0 then
      self.singleRequestedPageCount = self.singleRequestedPageCount + 1
    else
      self.multiRequestedPageCount = self.multiRequestedPageCount + 1
    end
  end
  self:RefreshRankData()
  self:UpdateData(self:GetRequestedPageCount() == 1)
end

function RoguelikeRankPopUp:RefreshRankData(searchInput)
  local range = self:GetRequestedPageCount() * dataCountPerPage
  if searchInput and 0 < #searchInput then
    self.data = DungeonProxy.Instance:GetRoguelikeRankSearchResult(self.isSingleMode, searchInput, range)
  else
    self.data = DungeonProxy.Instance:GetRoguelikeRankData(self.isSingleMode, range)
  end
end

function RoguelikeRankPopUp:ClickCellHead(data)
  local headCellCtl = data.headCell
  if headCellCtl == self.clickedHeadCell then
    FunctionPlayerTip.Me():CloseTip()
    self.clickedHeadCell = nil
    return
  end
  self.clickedHeadCell = headCellCtl
  local playerData, player = data.userData, PlayerTipData.new()
  local playerTip = FunctionPlayerTip.Me():GetPlayerTip(headCellCtl.frameSp, NGUIUtil.AnchorSide.TopRight, self.playerTipOffset)
  player:SetByRoguelikeUserData(playerData)
  TableUtility.TableClear(self.playerTipInitData)
  self.playerTipInitData.playerData = player
  self.playerTipInitData.funckeys = FriendProxy.Instance:IsFriend(playerData.charid) and self.playerTipFunc_Friend or self.playerTipFunc
  playerTip:SetData(self.playerTipInitData)
  playerTip:HideGuildInfo()
  playerTip:AddIgnoreBound(headCellCtl.gameObject)
  
  function playerTip.clickcallback(funcData)
    if funcData.key == "SendMessage" then
      self:CloseSelf()
    end
  end
  
  function playerTip.closecallback()
    self.clickedHeadCell = nil
  end
end

function RoguelikeRankPopUp:GetRequestedPageCount()
  return self.isSingleMode and self.singleRequestedPageCount or self.multiRequestedPageCount
end
