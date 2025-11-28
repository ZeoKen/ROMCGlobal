local GvgStatkeyStr = {
  [1] = ZhString.GVGStat_Kill,
  [2] = ZhString.GVGStat_Assist,
  [3] = ZhString.GVGStat_Death,
  [4] = ZhString.GVGStat_Relive,
  [5] = ZhString.GVGStat_Expel,
  [6] = ZhString.GVGStat_Damage,
  [7] = ZhString.GVGStat_Heal,
  [8] = ZhString.GVGStat_Occupy,
  [9] = ZhString.GVGStat_OccupyTime,
  [10] = ZhString.GVGStat_MetalDamage
}
autoImport("GVGBlessStatCell")
autoImport("GVGBlessCell")
GVGGuildLeaderBlessView = class("GVGGuildLeaderBlessView", ContainerView)
GVGGuildLeaderBlessView.ViewType = UIViewType.PopUpLayer
GVGGuildLeaderBlessView.BrotherView = GVGRedPacketSendView
local ArrowText = "↓"

function GVGGuildLeaderBlessView:Init()
  self:AddListenEvt(ServiceEvent.GuildCmdGvgFireReportGuildCmd, self.OnQueryStatCmd)
  self:InitData()
  self:FindObjs()
end

function GVGGuildLeaderBlessView:InitData()
  self.redPacketId = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.redPacketId
  self.maxBlessNum = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.maxBlessNum
  self.curBlessNum = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.curBlessNum
end

function GVGGuildLeaderBlessView:FindObjs()
  local help_go = self:FindGO("HelpBtn")
  self:RegistShowGeneralHelpByHelpID(529, help_go)
  local titleGrid = self:FindGO("TitleGrid")
  self.titles = {}
  self.sortBtns = {}
  for i = 1, #GvgStatkeyStr do
    self.sortBtns[i] = self:FindGO("OrderButton_" .. i + 1)
    self:AddClickEvent(self.sortBtns[i], function()
      self:OnSortBtnClicked(i)
    end)
    self.titles[i] = self:FindComponent("DataName_" .. i + 1, UILabel, titleGrid)
    self.titles[i].text = GvgStatkeyStr[i] or ""
  end
  self.emptyGO = self:FindGO("EmptyIcon")
  self.blessNumLabel = self:FindComponent("BlessNum", UILabel)
  self.topTitleScrollView = self:FindComponent("TopTitlePanel", UIScrollView)
  self.statScrollView = self:FindComponent("StatsView", UIScrollView)
  
  function self.statScrollView.onDragStarted()
    self.statScrollViewMoving = true
    self.statLastLocalPos = self.statScrollView.transform.localPosition
  end
  
  function self.statScrollView.onStoppedMoving()
    self.statScrollViewMoving = false
  end
  
  local grid = self:FindComponent("Grid", UIGrid, self.statScrollView.gameObject)
  self.statCtrl = UIGridListCtrl.new(grid, GVGBlessStatCell, "GVGBlessStatCell")
  self.blessScrollView = self:FindComponent("BlessPanel", UIScrollView)
  grid = self:FindComponent("Grid", UIGrid, self.blessScrollView.gameObject)
  self.blessListCtrl = UIGridListCtrl.new(grid, GVGBlessCell, "GVGBlessCell")
  self.blessListCtrl:AddEventListener(RedPacketEvent.OnBlessSelect, self.HandleBlessSelect, self)
  self.dateLab = self:FindComponent("Date", UILabel)
  self.confirmBtn = self:FindGO("ConfirmBtn")
  self:AddClickEvent(self.confirmBtn, function()
    self:OnConfirmBtnClick()
  end)
  self:AddButtonEvent("CancelBtn", function()
    self:ClearBlessSelectState()
    self:sendNotification(RedPacketEvent.OnBlessCancel)
    self:CloseSelf()
  end)
  self.confirmBtnGrey = self:FindGO("ConfirmBtnGrey")
  self:AddClickEvent(self.confirmBtnGrey, function()
    MsgManager.ShowMsgByID(2670)
  end)
end

function GVGGuildLeaderBlessView:InitView()
  local statTime = SuperGvgProxy.Instance:GetLastGvgStatsTime()
  if statTime then
    self.dateLab.text = ClientTimeUtil.FormatTimeTick(statTime)
  end
  self:UpdateBlessNum()
end

function GVGGuildLeaderBlessView:OnEnter()
  self:QueryStat()
  self:AddMonoUpdateFunction(self.Update)
end

function GVGGuildLeaderBlessView:OnExit()
  self:RemoveMonoUpdateFunction()
end

function GVGGuildLeaderBlessView:QueryStat()
  SuperGvgProxy.Instance:QueryLastGvgStats()
end

function GVGGuildLeaderBlessView:OnQueryStatCmd()
  self:InitView()
  self:RefreshView()
end

function GVGGuildLeaderBlessView:RefreshView()
  local datas = SuperGvgProxy.Instance:GetLastGvgStats()
  self.statCtrl:ResetDatas(datas)
  local array = ReusableTable.CreateArray()
  for i = 1, #datas do
    local data = clone(datas[i])
    local state = RedPacketProxy.Instance:IsBlessSelected(self.redPacketId, data.charid)
    data.isBlessSelected = state
    data.showCheck = true
    array[#array + 1] = data
  end
  self.blessListCtrl:ResetDatas(array)
  ReusableTable.DestroyArray(array)
  if not datas or #datas == 0 then
    self.emptyGO:SetActive(true)
  else
    self.emptyGO:SetActive(false)
  end
end

function GVGGuildLeaderBlessView:UpdateBlessNum()
  self.blessNumLabel.text = string.format(ZhString.RedPacket_BlessNum, self.curBlessNum, self.maxBlessNum)
  self:SetConfirmBtnState(self.curBlessNum == self.maxBlessNum)
end

function GVGGuildLeaderBlessView:OnConfirmBtnClick()
  local blessCharIds = {}
  local cells = self.blessListCtrl:GetCells()
  for i = 1, #cells do
    if cells[i]:IsSelected() then
      blessCharIds[#blessCharIds + 1] = cells[i].data.charid
    end
  end
  self:sendNotification(RedPacketEvent.OnBlessConfirm, blessCharIds)
  self:CloseSelf()
end

function GVGGuildLeaderBlessView:OnSortBtnClicked(i)
  if self.lastSelectedSortIndex ~= i then
    if self.lastSelectedSortIndex then
      self.titles[self.lastSelectedSortIndex].text = GvgStatkeyStr[self.lastSelectedSortIndex]
    end
    self.lastSelectedSortIndex = i
    self.titles[i].text = GvgStatkeyStr[i] .. ArrowText
    SuperGvgProxy.Instance:SortLastGvgStatsByKey(GvgStatData.SortableKeys[i])
    self:RefreshView()
  end
end

function GVGGuildLeaderBlessView:HandleBlessSelect(cell)
  if cell:IsSelected() then
    self.curBlessNum = self.curBlessNum + 1
  else
    self.curBlessNum = self.curBlessNum - 1
  end
  if self.curBlessNum > self.maxBlessNum then
    cell:SetSelectState(false)
  end
  self.curBlessNum = math.min(self.curBlessNum, self.maxBlessNum)
  self:UpdateBlessNum()
  local state = cell:IsSelected() or false
  RedPacketProxy.Instance:SetBlessSelect(self.redPacketId, cell.data.charid, state)
end

function GVGGuildLeaderBlessView:ClearBlessSelectState()
  RedPacketProxy.Instance:ClearBlessSelectState(self.redPacketId)
end

function GVGGuildLeaderBlessView:SetConfirmBtnState(state)
  self.confirmBtn:SetActive(state)
  self.confirmBtnGrey:SetActive(not state)
end

function GVGGuildLeaderBlessView:Update()
  if not self.statScrollViewMoving then
    return
  end
  local relative = self.statScrollView.transform.localPosition - self.statLastLocalPos
  self.topTitleScrollView:MoveRelative(relative)
  self.statLastLocalPos = self.statScrollView.transform.localPosition
end
