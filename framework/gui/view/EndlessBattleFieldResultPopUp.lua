EndlessBattleFieldResultPopUp = class("EndlessBattleFieldResultPopUp", ContainerView)
EndlessBattleFieldResultPopUp.ViewType = UIViewType.NormalLayer
local SortType = {
  Kill = "kill",
  Death = "death",
  Help = "help",
  PvpDamage = "pvpDamage",
  PveDamage = "pveDamage",
  Heal = "heal"
}
EndlessBattleFieldResultPopUp.SortType = SortType
local SortTypeIndex = {
  [1] = SortType.Kill,
  [2] = SortType.Death,
  [3] = SortType.Help,
  [4] = SortType.PvpDamage,
  [5] = SortType.PveDamage,
  [6] = SortType.Heal
}
local SortOrder = {
  Ascend = 1,
  Descend = 2,
  Max = 3
}
EndlessBattleFieldResultPopUp.SortOrder = SortOrder
autoImport("EndlessBattleFieldResultCell")
autoImport("EndlessBattleFieldResultStatCell")
autoImport("EndlessBattleFieldResultTitleCell")
local WinTexName = "pvp_bg_win"
local WinTexBannerName = "pvp_bg_win_blue"
local LoseTexName = "pvp_yuezhan_bg_lost"
local LoseTexBannerName = "pvp_bg_lost"
local humanBgCol = "9fcbff"
local vampireBgCol = "ffafaf"
local DefaultBottomBgHeight, BottomBgHeightForEnd = 501, 439
local DefaultMyselfPosY, MyselfPosYForEnd = -229, -168
local DefaultResultPanelHeight, ResultPanelHeightForEnd, DefaultResultPanelPosY, ResultPanelPosYForEnd = 360, 298, -7, 20
local DefaultStatsPanelHeight, StatsPanelHeightForEnd, DefaultStatsPanelPosY, StatsPanelPosYForEnd = 360, 298, -7, 20

function EndlessBattleFieldResultPopUp:Init()
  self:InitData()
  self:FindObjs()
end

function EndlessBattleFieldResultPopUp:InitData()
  self.players = {}
  local infos = EndlessBattleFieldProxy.Instance:GetEBFUserStatInfos()
  for _, info in pairs(infos) do
    self.players[#self.players + 1] = info
  end
  self.sortOrder = SortOrder.Descend
end

function EndlessBattleFieldResultPopUp:FindObjs()
  self.titleLabel = self:FindComponent("Title", UILabel)
  self.winnerTex = self:FindComponent("WinnerTex", UITexture)
  self.winBannerTex = self:FindComponent("Texture", UITexture, self.winnerTex.gameObject)
  self.winGO = self:FindGO("WinnerLabel")
  self.loseGO = self:FindGO("LoseLabel")
  self:AddButtonEvent("CloseBtn", function()
    self:CloseSelf()
  end)
  self.leaveBtn = self:FindGO("LeaveBtn")
  self:AddClickEvent(self.leaveBtn, function()
    self:OnLeaveBtnClick()
  end)
  self.nextRoundBtn = self:FindGO("NextRoundBtn")
  self:AddClickEvent(self.nextRoundBtn, function()
    self:OnNextRoundBtnClick()
  end)
  self.leaveBtnLabel = self:FindComponent("LeaveLabel", UILabel)
  self.myselfDataBg = self:FindComponent("MyselfDataBg", UISprite)
  self.topTitleScrollView = self:FindComponent("TopTitlePanel", UIScrollView)
  self.titleGrid = self:FindComponent("TitleGrid", UIGrid)
  self.titleList = {}
  local childList = self.titleGrid:GetChildList()
  for i = 0, childList.Count - 1 do
    local child = childList[i].gameObject
    local cell = EndlessBattleFieldResultTitleCell.new(child)
    cell:AddEventListener(MouseEvent.MouseClick, self.OnTitleCellClick, self)
    cell:SetData(SortTypeIndex[i + 1])
    self.titleList[#self.titleList + 1] = cell
  end
  self.resultPanel = self:FindComponent("ResultPanel", UIPanel)
  self.resultScrollView = self.resultPanel.gameObject:GetComponent(UIScrollView)
  self.resultGrid = self:FindComponent("Grid", UIGrid, self.resultPanel.gameObject)
  self.resultListCtrl = UIGridListCtrl.new(self.resultGrid, EndlessBattleFieldResultCell, "EndlessBattleFieldResultCell")
  self.resultScrollViewForEnd = self:FindComponent("ResultPanelForEnd", UIScrollView)
  local grid = self:FindComponent("Grid", UIGrid, self.resultScrollViewForEnd.gameObject)
  self.resultListCtrlForEnd = UIGridListCtrl.new(grid, EndlessBattleFieldResultCell, "EndlessBattleFieldResultCell")
  self.statsPanel = self:FindComponent("StatsView", UIPanel)
  self.statScrollView = self.statsPanel.gameObject:GetComponent(UIScrollView)
  self.statGrid = self:FindComponent("Grid", UIGrid, self.statsPanel.gameObject)
  self.statsListCtrl = UIGridListCtrl.new(self.statGrid, EndlessBattleFieldResultStatCell, "EndlessBattleFieldResultStatCell")
  self.statScrollViewForEnd = self:FindComponent("StatsViewForEnd", UIScrollView)
  grid = self:FindComponent("Grid", UIGrid, self.statScrollViewForEnd.gameObject)
  self.statsListCtrlForEnd = UIGridListCtrl.new(grid, EndlessBattleFieldResultStatCell, "EndlessBattleFieldResultStatCell")
  self.bottomBg = self:FindComponent("bottom", UISprite)
  self.myselfGO = self:FindGO("Myself")
  self.myselfScrollView = self:FindComponent("MyselfPanel", UIScrollView)
  self.myselfStatGO = self:FindGO("MyselfStat")
  self.myselfProfessionIcon = self:FindComponent("Career", UISprite, self.myselfGO)
  self.myselfNameLabel = self:FindComponent("Data1", UILabel, self.myselfGO)
end

function EndlessBattleFieldResultPopUp:OnEnter()
  local _proxy = EndlessBattleFieldProxy.Instance
  local isEnd = _proxy:IsWaitingForStart()
  self.winner = EndlessBattleGameProxy.Instance:GetWinner()
  self.leaveBtn:SetActive(isEnd)
  self.nextRoundBtn:SetActive(isEnd)
  local myCamp = Game.Myself.data:GetNormalPVPCamp()
  redlog("EndlessBattleFieldResultPopUp:OnEnter", tostring(isEnd), "winner:" .. tostring(self.winner), "myCamp:" .. tostring(myCamp))
  self.winGO:SetActive(isEnd and self.winner == myCamp or false)
  self.loseGO:SetActive(isEnd and self.winner and self.winner ~= FuBenCmd_pb.ETEAMPWS_MIN and self.winner ~= myCamp or false)
  local isDrawed = self.winner and self.winner == FuBenCmd_pb.ETEAMPWS_MIN or false
  self.titleLabel.gameObject:SetActive(not isEnd or isDrawed)
  self.titleLabel.text = isEnd and isDrawed and ZhString.EndlessBattleEvent_Draw or ZhString.EndlessBattleEvent_ResultStat
  self.winnerTex.gameObject:SetActive(isEnd and not isDrawed)
  local colStr = myCamp == FuBenCmd_pb.ETEAMPWS_RED and humanBgCol or vampireBgCol
  local _, c = ColorUtil.TryParseHexString(colStr)
  self.myselfDataBg.color = c
  if isEnd and not isDrawed then
    self.texName = self.winner == myCamp and WinTexName or LoseTexName
    self.bannerName = self.winner == myCamp and WinTexBannerName or LoseTexBannerName
    PictureManager.Instance:SetPVP(self.texName, self.winnerTex)
    PictureManager.Instance:SetPVP(self.bannerName, self.winBannerTex)
  end
  self.bottomBg.height = isEnd and BottomBgHeightForEnd or DefaultBottomBgHeight
  local x, y, z = LuaGameObject.GetLocalPositionGO(self.myselfGO)
  y = isEnd and MyselfPosYForEnd or DefaultMyselfPosY
  LuaGameObject.SetLocalPositionGO(self.myselfGO, x, y, z)
  if isEnd then
    local kickout = _proxy:GetKickOutTimeStamp()
    if kickout and 0 < kickout then
      local cd = kickout - math.floor(ServerTime.CurServerTime() / 1000)
      self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, function()
        self.leaveBtnLabel.text = string.format(ZhString.TwelvePVP_Exit, cd)
        cd = math.max(cd - 1, 0)
        if cd <= 0 then
          self:CloseSelf()
        end
      end, self)
    else
      self.leaveBtnLabel.text = ZhString.DialogView_Left
    end
    self.resultListCtrl = self.resultListCtrlForEnd
    self.statsListCtrl = self.statsListCtrlForEnd
    self.resultScrollView = self.resultScrollViewForEnd
    self.statScrollView = self.statScrollViewForEnd
  end
  self.resultLastLocalPos = self.resultScrollView.transform.localPosition
  
  function self.statScrollView.onDragStarted()
    self.statScrollViewMoving = true
    self.statLastLocalPos = self.statScrollView.transform.localPosition
  end
  
  function self.statScrollView.onStoppedMoving()
    self.statScrollViewMoving = false
  end
  
  self:ClickTitleCell(SortType.Kill)
  local go = self:LoadPreferb("cell/EndlessBattleFieldResultStatCell", self.myselfStatGO)
  go:GetComponent(UIDragScrollView).enabled = false
  self.myselfStatCell = EndlessBattleFieldResultStatCell.new(go)
  local myselfData = TableUtility.ArrayFindByPredicate(self.players, function(v, args)
    return v.charid == args
  end, Game.Myself.data.id)
  self.myselfStatCell:SetData(myselfData)
  self.myselfNameLabel.text = myselfData.username
  local proConfig = Table_Class[myselfData.profession]
  IconManager:SetProfessionIcon(proConfig and proConfig.icon, self.myselfProfessionIcon)
  self:AddMonoUpdateFunction(self.Update)
end

function EndlessBattleFieldResultPopUp:OnExit()
  if self.texName then
    PictureManager.Instance:UnLoadPVP(self.texName, self.winnerTex)
    PictureManager.Instance:UnLoadPVP(self.bannerName, self.winBannerTex)
  end
  self.winner = nil
  self:ClearTick()
  self:RemoveMonoUpdateFunction()
end

function EndlessBattleFieldResultPopUp:ClearTick()
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self)
    self.timeTick = nil
  end
end

function EndlessBattleFieldResultPopUp:OnTitleCellClick(cell)
  if self.sortType == cell.type then
    self.sortOrder = SortOrder.Max - self.sortOrder
  else
    self.sortOrder = SortOrder.Descend
  end
  self.sortType = cell.type
  self:SortByType(self.sortType)
  self.resultListCtrl:ResetDatas(self.players)
  self.statsListCtrl:ResetDatas(self.players)
  local cells = self.statsListCtrl:GetCells()
  for i = 1, #cells do
    local cell = cells[i]
    cell.dragScrollView.scrollView = self.resultScrollView
  end
  cell:SwitchSortOrder(self.sortOrder)
  local cells = self.titleList
  for i = 1, #cells do
    local c = cells[i]
    if c ~= cell then
      c:SwitchSortOrder()
    end
  end
end

function EndlessBattleFieldResultPopUp:ClickTitleCell(sortType)
  local cells = self.titleList
  local cell = TableUtility.ArrayFindByPredicate(cells, function(v, args)
    return v.type == args
  end, sortType)
  self:OnTitleCellClick(cell)
end

function EndlessBattleFieldResultPopUp:SortByType(type)
  type = type or SortType.Kill
  if self.sortOrder == SortOrder.Descend then
    table.sort(self.players, function(l, r)
      return l[type] > r[type]
    end)
  elseif self.sortOrder == SortOrder.Ascend then
    table.sort(self.players, function(l, r)
      return l[type] < r[type]
    end)
  end
end

function EndlessBattleFieldResultPopUp:OnLeaveBtnClick()
  MsgManager.ConfirmMsgByID(7, function()
    ServiceNUserProxy.Instance:ReturnToHomeCity()
    self:CloseSelf()
  end)
end

function EndlessBattleFieldResultPopUp:OnNextRoundBtnClick()
  if not EndlessBattleFieldProxy.Instance:IsContinue() then
    ServiceFuBenCmdProxy.Instance:CallEBFContinueCmd()
  end
  self:CloseSelf()
end

function EndlessBattleFieldResultPopUp:Update()
  if self.statScrollViewMoving then
    local relative = self.statScrollView.transform.localPosition - self.statLastLocalPos
    self.topTitleScrollView:MoveRelative(relative)
    self.myselfScrollView:MoveRelative(relative)
    self.statLastLocalPos = self.statScrollView.transform.localPosition
  end
  local relative = self.resultScrollView.transform.localPosition - self.resultLastLocalPos
  self.statScrollView:MoveRelative(relative)
  self.resultLastLocalPos = self.resultScrollView.transform.localPosition
end
