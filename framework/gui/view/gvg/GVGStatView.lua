autoImport("GVGBlessStatCell")
autoImport("GVGStatCell")
GVGStatView = class("GVGStatView", ContainerView)
GVGStatView.ViewType = UIViewType.PopUpLayer
GVGStatView.BrotherView = GVGRedPacketSendView
GVGStatView.GvgStatkeyStr = {
  [1] = ZhString.GVGStat_Kill,
  [2] = ZhString.GVGStat_Assist,
  [3] = ZhString.GVGStat_Death,
  [4] = ZhString.GVGStat_Relive,
  [5] = ZhString.GVGStat_Expel,
  [6] = ZhString.GVGStat_Damage,
  [7] = ZhString.GVGStat_Heal,
  [8] = ZhString.GVGStat_Occupy,
  [9] = ZhString.GVGStat_OccupyTime,
  [10] = ZhString.GVGStat_MetalDamage,
  [11] = ZhString.GVGStat_MvpDamage
}
local ArrowText = "↓"

function GVGStatView:Init()
  self:AddListenEvt(ServiceEvent.GuildCmdGvgFireReportGuildCmd, self.OnQueryStatCmd)
  self:InitData()
  self:FindObjs()
end

function GVGStatView:InitData()
  self.redPacketId = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.redPacketId
end

function GVGStatView:FindObjs()
  self:AddButtonEvent("HelpBtn", function()
    self:OnClickHelp()
  end)
  self.emptyGO = self:FindGO("EmptyIcon")
  self.topTitleScrollView = self:FindComponent("TopTitlePanel", UIScrollView)
  self.statScrollPanel = self:FindComponent("StatsView", UIPanel)
  self.statScrollPanelInitialWidth = self.statScrollPanel.baseClipRegion.z
  self.statScrollPanelInitialHeight = self.statScrollPanel.baseClipRegion.w
  self.clip = self.statScrollPanel.baseClipRegion
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
  
  function self.blessScrollView.onDragStarted()
    self.blessScrollViewMoving = true
    self.blessScrollViewLastLocalPos = self.blessScrollView.transform.localPosition
  end
  
  function self.blessScrollView.onStoppedMoving()
    self.blessScrollViewMoving = false
  end
  
  grid = self:FindComponent("Grid", UIGrid, self.blessScrollView.gameObject)
  self.ownerListCtrl = UIGridListCtrl.new(grid, GVGStatCell, "GVGBlessCell")
  self.dateLab = self:FindComponent("Date", UILabel)
  self.sortBtns = {}
  self.sortTitles = {}
  local _length = #GvgStatData.SortableKeys
  local titleGrid = self:FindGO("TitleGrid")
  for i = 1, _length do
    self.sortBtns[i] = self:FindGO("OrderButton_" .. i + 1, titleGrid)
    self:AddClickEvent(self.sortBtns[i], function()
      self:OnSortBtnClicked(i)
    end)
    self.sortTitles[i] = self:FindComponent("DataName_" .. i + 1, UILabel, titleGrid)
    self.sortTitles[i].text = GVGStatView.GvgStatkeyStr[i] or ""
  end
  self.myselfStatGO = self:FindGO("MyselfStat")
  self.myselfStatOwner = GVGStatCell.new(self.myselfStatGO)
  self.myselfStatScrollView = self:FindComponent("MyselfPanel", UIScrollView)
  local obj = self:LoadPreferb("cell/GVGBlessStatCell", self.myselfStatScrollView.gameObject)
  obj.transform.localPosition = LuaGeometry.GetTempVector3(-437, 0, 0)
  self.myselfStatData = GVGBlessStatCell.new(obj)
  
  function self.myselfStatScrollView.onDragStarted()
    self.myScrollViewMoving = true
    self.myselfStatLastLocalPos = self.myselfStatScrollView.transform.localPosition
  end
  
  function self.myselfStatScrollView.onStoppedMoving()
    self.myScrollViewMoving = false
  end
end

function GVGStatView:OnClickHelp()
  local helpid = self:GetHelpId()
  local helpData = Table_Help[helpid]
  if helpData then
    TipsView.Me():ShowGeneralHelp(helpData.Desc)
  end
end

function GVGStatView:GetHelpId()
  return PanelConfig.GVGStatView.id
end

function GVGStatView:SetDate()
  local statTime = SuperGvgProxy.Instance:GetLastGvgStatsTime()
  if statTime then
    self.dateLab.text = ClientTimeUtil.FormatTimeTick(statTime)
  end
end

function GVGStatView:OnEnter()
  self:QueryStat()
  self:AddMonoUpdateFunction(self.Update)
  GVGStatView.super.OnEnter(self)
end

function GVGStatView:OnExit()
  self:RemoveMonoUpdateFunction()
  GVGStatView.super.OnExit(self)
end

function GVGStatView:QueryStat()
  SuperGvgProxy.Instance:QueryLastGvgStats()
end

function GVGStatView:OnQueryStatCmd()
  self:SetDate()
  SuperGvgProxy.Instance:SortLastGvgStatsByKey(GvgStatData.SortableKeys[1])
  self:RefreshView()
  self:UpdateMyselfData()
end

function GVGStatView:UpdateMyselfData()
  local data = SuperGvgProxy.Instance:GetMyLastGvgStats()
  self.myselfStatData:SetData(data)
  self.myselfStatOwner:SetData(data)
end

function GVGStatView:RefreshView()
  local datas = SuperGvgProxy.Instance:GetLastGvgStats()
  self.statCtrl:ResetDatas(datas)
  local array = ReusableTable.CreateArray()
  for i = 1, #datas do
    local data = clone(datas[i])
    array[#array + 1] = data
  end
  self.ownerListCtrl:ResetDatas(array)
  ReusableTable.DestroyArray(array)
  if not datas or #datas == 0 then
    self.emptyGO:SetActive(true)
    self.myselfStatData:SetColider(true)
  else
    self.emptyGO:SetActive(false)
    self.myselfStatData:SetColider(false)
  end
end

function GVGStatView:OnSortBtnClicked(i)
  if self.lastSelectedSortIndex ~= i then
    if self.lastSelectedSortIndex then
      self.sortTitles[self.lastSelectedSortIndex].text = GVGStatView.GvgStatkeyStr[self.lastSelectedSortIndex]
    end
    self.lastSelectedSortIndex = i
    self.sortTitles[i].text = GVGStatView.GvgStatkeyStr[i] .. ArrowText
    SuperGvgProxy.Instance:SortLastGvgStatsByKey(GvgStatData.SortableKeys[i])
    self:RefreshView()
  end
end

function GVGStatView:Update()
  if self.statScrollViewMoving then
    local relative = self.statScrollView.transform.localPosition - self.statLastLocalPos
    self.topTitleScrollView:MoveRelative(relative)
    self.myselfStatScrollView:MoveRelative(relative)
    self.statLastLocalPos = self.statScrollView.transform.localPosition
  end
  if self.myScrollViewMoving then
    local relative = self.myselfStatScrollView.transform.localPosition - self.myselfStatLastLocalPos
    self.topTitleScrollView:MoveRelative(relative)
    self.myselfStatLastLocalPos = self.myselfStatScrollView.transform.localPosition
  end
  if self.blessScrollViewMoving then
    local relative = self.blessScrollView.transform.localPosition.y - self.blessScrollViewLastLocalPos.y
    local height = self.statScrollPanel.baseClipRegion.w
    local clip_height = math.max(self.statScrollPanelInitialHeight, height + relative * 2)
    self.statScrollPanel.baseClipRegion = LuaGeometry.GetTempVector4(self.clip.x, self.clip.y, self.statScrollPanelInitialWidth, clip_height)
    self.blessScrollViewLastLocalPos = self.blessScrollView.transform.localPosition
  end
end
