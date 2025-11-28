RaidStatisticsView = class("RaidStatisticsView", ContainerView)
RaidStatisticsView.ViewType = UIViewType.NormalLayer
autoImport("PlayerRaidRankingCell")
autoImport("RaidinfoView")
autoImport("RaidMapView")
local _ColorTitleGray = ColorUtil.TitleGray
local _ColorBlue = LuaColor.New(0.25882352941176473, 0.4823529411764706, 0.7568627450980392, 1)

function RaidStatisticsView:Init()
  self:FindObj()
  self:AddEvts()
  self:AddListenEvts()
  self:InitView()
  self.isinit = true
end

function RaidStatisticsView:FindObj()
  local toggleroot = self:FindGO("ToggleRoot")
  self.combatInfoTog = self:FindGO("CombatInfoTog", toggleroot):GetComponent(UIToggle)
  self.raidMapTog = self:FindGO("RaidMapTog", toggleroot):GetComponent(UIToggle)
  self.combatInfoTogLab = self.combatInfoTog.gameObject:GetComponent(UILabel)
  self.raidMapTogLab = self.raidMapTog.gameObject:GetComponent(UILabel)
  self.combatinfo = self:FindGO("CombatInfo")
  self.compareFilterL = self:FindGO("CompareFilterL", self.combatinfo):GetComponent(UIPopupList)
  self.recordFilterL = self:FindGO("RecordFilterL", self.combatinfo):GetComponent(UIPopupList)
  self.compareFilterR = self:FindGO("CompareFilterR", self.combatinfo):GetComponent(UIPopupList)
  self.recordFilterR = self:FindGO("RecordFilterR", self.combatinfo):GetComponent(UIPopupList)
  self.compareSVL = self:FindGO("CompareScrollViewL", self.combatinfo):GetComponent(UIScrollView)
  self.compareSVR = self:FindGO("CompareScrollViewR", self.combatinfo):GetComponent(UIScrollView)
  self.compareGridL = self:FindGO("CompareGridL", self.combatinfo):GetComponent(UIGrid)
  self.compareGridR = self:FindGO("CompareGridR", self.combatinfo):GetComponent(UIGrid)
  self.compareCtlL = UIGridListCtrl.new(self.compareGridL, PlayerRaidRankingCell, "PlayerRaidRankingCell")
  self.compareCtlR = UIGridListCtrl.new(self.compareGridR, PlayerRaidRankingCell, "PlayerRaidRankingCell")
  self.raidInfo = self:FindGO("RaidInfo")
  self.raidMap = self:FindGO("RaidMap")
end

function RaidStatisticsView:AddToggleChange(toggle, label, toggleColor, normalColor, handler)
  EventDelegate.Add(toggle.onChange, function()
    if toggle.value then
      label.color = toggleColor
      if handler ~= nil then
        handler(self)
      end
    else
      label.color = normalColor
    end
  end)
end

function RaidStatisticsView:AddEvts()
  self:AddToggleChange(self.combatInfoTog, self.combatInfoTogLab, _ColorBlue, _ColorTitleGray, self.OnClickCombatInfoTog)
  self:AddToggleChange(self.raidMapTog, self.raidMapTogLab, _ColorBlue, _ColorTitleGray, self.OnClickRaidMapTog)
  EventDelegate.Add(self.compareFilterL.onChange, function()
    if self.compareFilterL.data == nil then
      return
    end
    if self.filterDataL ~= self.compareFilterL.data then
      self.filterDataL = self.compareFilterL.data
      self:UpdatePlayerList(self.compareCtlL, self.filterDataL, self.recordDataL)
    end
  end)
  EventDelegate.Add(self.compareFilterR.onChange, function()
    if self.compareFilterR.data == nil then
      return
    end
    if self.filterDataR ~= self.compareFilterR.data then
      self.filterDataR = self.compareFilterR.data
      self:UpdatePlayerList(self.compareCtlR, self.filterDataR, self.recordDataR)
    end
  end)
  EventDelegate.Add(self.recordFilterL.onChange, function()
    if self.recordFilterL.data == nil then
      return
    end
    if self.recordDataL ~= self.recordFilterL.data then
      self.recordDataL = self.recordFilterL.data
      self:UpdatePlayerList(self.compareCtlL, self.filterDataL, self.recordDataL)
    end
  end)
  EventDelegate.Add(self.recordFilterR.onChange, function()
    if self.recordFilterR.data == nil then
      return
    end
    if self.recordDataR ~= self.recordFilterR.data then
      self.recordDataR = self.recordFilterR.data
      self:UpdatePlayerList(self.compareCtlR, self.filterDataR, self.recordDataR)
    end
  end)
end

function RaidStatisticsView:AddListenEvts()
  self:AddListenEvt(ServiceEvent.FuBenCmdQueryTeamGroupRaidUserInfo, self.HandleRecvQueryInfo)
end

function RaidStatisticsView:InitView()
  self.raidInfoSub = self:AddSubView("RaidinfoView", RaidinfoView)
  self.raidMapSub = self:AddSubView("RaidMapView", RaidMapView)
end

function RaidStatisticsView:OnEnter()
  RaidStatisticsView.super.OnEnter(self)
  ServiceFuBenCmdProxy.Instance:CallQueryTeamGroupRaidUserInfo()
end

function RaidStatisticsView:HandleRecvQueryInfo()
  self:OnClickCombatInfoTog()
  self.isinit = false
end

function RaidStatisticsView:OnClickCombatInfoTog()
  self.combatinfo:SetActive(true)
  self.raidInfo:SetActive(false)
  self.raidMap:SetActive(false)
  self:InitCombatInfo()
  if not self.isinit then
    self:UpdatePlayerList(self.compareCtlL, self.filterDataL, self.recordDataL)
    self:UpdatePlayerList(self.compareCtlR, self.filterDataR, self.recordDataR)
    self.isinit = true
  end
end

function RaidStatisticsView:OnClickRaidMapTog()
  self.combatinfo:SetActive(false)
  self.raidInfo:SetActive(false)
  self.raidMap:SetActive(true)
end

local pulicConfig = GameConfig.Thanatos_Public
local StatisticFilterConfig = pulicConfig.StatisticFilterConfig

function RaidStatisticsView:InitCombatInfo()
  local recordFilter = self:GetRecordFilter()
  local statisticFilterConfig = self:GetStatisticFilter()
  local leftFilter = self:GetLeftFilter()
  local rightFilter = self:GetRightFilter()
  self:InitFilter(self.compareFilterL, leftFilter, self.filterDataL, statisticFilterConfig)
  self:InitFilter(self.recordFilterL, recordFilter, self.recordDataL)
  self:InitFilter(self.compareFilterR, rightFilter, self.filterDataR, statisticFilterConfig)
  self:InitFilter(self.recordFilterR, recordFilter, self.recordDataR)
  self:UpdatePlayerList(self.compareCtlL, self.filterDataL, self.recordDataL)
  self:UpdatePlayerList(self.compareCtlR, self.filterDataR, self.recordDataR)
end

function RaidStatisticsView:GetRecordFilter()
  return GroupRaidProxy.Instance:GetRecordFilter()
end

function RaidStatisticsView:GetStatisticFilter()
  return StatisticFilterConfig
end

function RaidStatisticsView:GetLeftFilter()
  return pulicConfig.LeftFilter
end

function RaidStatisticsView:GetRightFilter()
  return pulicConfig.RightFilter
end

function RaidStatisticsView:InitFilter(filter, filterConfig, currentFilter, extraCofig)
  filterConfig = filterConfig or _EmptyTable
  filter:Clear()
  if extraCofig then
    for i = 1, #filterConfig do
      local filterData = extraCofig[filterConfig[i]]
      filter:AddItem(filterData, filterConfig[i])
    end
  else
    for i = 0, #filterConfig do
      if filterConfig[i] then
        filter:AddItem(filterConfig[i], i)
      end
    end
  end
  if 0 < #filterConfig then
    local range, filterData
    if extraCofig then
      range = filterConfig[1]
      filterData = extraCofig[range]
    else
      range = filterConfig[0]
      filterData = filterConfig[range]
    end
    filter.value = filterData
    currentFilter = filter.data
    self.filterData = range
  end
end

local filter = {}

function RaidStatisticsView:getFilter(filterData)
  TableUtility.ArrayClear(filter)
  for k, v in pairs(filterData) do
    table.insert(filter, k)
  end
  return filter
end

function RaidStatisticsView:UpdatePlayerList(gridctl, filtervalue, recordtime)
  local datas = GroupRaidProxy.Instance:GetDataByIndex(recordtime, filtervalue)
  local weights = GroupRaidProxy.Instance:GetWeightMapByTime(recordtime)
  if datas then
    self:SortByFilter(filtervalue, datas)
    for i = 1, #datas do
      datas[i]:SetPercentage(weights, filtervalue)
    end
    gridctl:ResetDatas(datas)
  else
  end
end

function RaidStatisticsView:SortByFilter(filtervalue, datas)
  if filtervalue == 1 then
    table.sort(datas, function(a, b)
      return a.damage > b.damage
    end)
  elseif filtervalue == 2 then
    table.sort(datas, function(a, b)
      return a.bedamage > b.bedamage
    end)
  elseif filtervalue == 3 then
    table.sort(datas, function(a, b)
      return a.heal > b.heal
    end)
  elseif filtervalue == 4 then
    table.sort(datas, function(a, b)
      return a.dienum > b.dienum
    end)
  elseif filtervalue == 5 then
    table.sort(datas, function(a, b)
      return a.hatetime > b.hatetime
    end)
  end
end
