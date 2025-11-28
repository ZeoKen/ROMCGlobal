autoImport("LotteryData")
HeadLotteryData = class("HeadLotteryData")
local _ArrayClear = TableUtility.ArrayClear
local _TableClear = TableUtility.TableClear
local _ArrayPush = TableUtility.ArrayPushBack

function HeadLotteryData:ctor()
  self.yearLotteryMap = {}
  self.lotteryDataList = {}
  self.yearFilterConfig = {}
  self.monthFilterConfigMap = {}
end

function HeadLotteryData.IsConfigYear(k)
  return k < 1000
end

function HeadLotteryData:SetData(server_data)
  if not server_data then
    return
  end
  _TableClear(self.yearLotteryMap)
  _ArrayClear(self.yearFilterConfig)
  _TableClear(self.monthFilterConfigMap)
  _ArrayClear(self.lotteryDataList)
  self.isSingleMonth = #server_data.infos == 1
  for i = 1, #server_data.infos do
    local data = LotteryData.new(server_data.infos[i], LotteryType.Head)
    local year = data.clientYear or data.year
    local lotteryData = self:GetLotteryDataByYear(year)
    if not lotteryData then
      self.yearLotteryMap[year] = {}
    end
    _ArrayPush(self.yearLotteryMap[year], data)
  end
  local serverTime = ServerTime.CurServerTime() / 1000
  local curYear = os.date("*t", serverTime).year
  local _Year = ZhString.Lottery_Head_Year
  local _CurYear = ZhString.Lottery_CurYear
  for k, lotteryDatas in pairs(self.yearLotteryMap) do
    table.sort(lotteryDatas, function(a, b)
      return a.month > b.month
    end)
    for i = 1, #lotteryDatas do
      _ArrayPush(self.lotteryDataList, lotteryDatas[i])
    end
    local popup_config = {}
    popup_config.year = k
    if HeadLotteryData.IsConfigYear(k) then
      popup_config.name = GameConfig.Lottery.TimeShow[k]
    else
      popup_config.name = curYear == k and _CurYear or tostring(k) .. _Year
    end
    _ArrayPush(self.yearFilterConfig, popup_config)
  end
  table.sort(self.yearFilterConfig, function(a, b)
    return a.year > b.year
  end)
  self.todayCount = server_data.today_cnt
  self.maxCount = server_data.max_cnt
  self.todayExtraCount = server_data.today_extra_cnt
  self.maxExtraCount = server_data.max_extra_cnt
  if #self.lotteryDataList > 0 then
    self.dressMap = FunctionLottery.SetDressData(LotteryType.Head, self.lotteryDataList[1].items)
  end
end

function HeadLotteryData:GetInitializedDressData()
  return self.dressMap
end

function HeadLotteryData:GetAllLotteryDataList()
  return self.lotteryDataList
end

function HeadLotteryData:GetYearFilter()
  return self.yearFilterConfig
end

function HeadLotteryData:GetMonthFilter(year)
  if not self.monthFilterConfigMap[year] then
    self:_AddMonthFilter(year)
  end
  return self.monthFilterConfigMap[year]
end

function HeadLotteryData:_AddMonthFilter(year)
  local data = self:GetLotteryDataByYear(year)
  local monthFilter = {}
  local _Month = ZhString.Lottery_Head_Month
  for i = 1, #data do
    local popup_config = {}
    popup_config.month = data[i].month
    popup_config.name = tostring(data[i].month) .. _Month
    _ArrayPush(monthFilter, popup_config)
  end
  self.monthFilterConfigMap[year] = monthFilter
end

function HeadLotteryData:GetLotteryDataByYear(year)
  return self.yearLotteryMap[year]
end

function HeadLotteryData:GetFirstMonthData(year)
  local datas = self.yearLotteryMap[year]
  if datas then
    return datas[1]
  end
end

function HeadLotteryData:GetLotteryData(year, month)
  local list = self:GetLotteryDataByYear(year)
  if not list then
    return
  end
  for i = 1, #list do
    if list[i].month == month then
      return list[i]
    end
  end
end

function HeadLotteryData:SetTodayCount(today_cnt, max_cnt)
  self.todayCount = today_cnt
  if nil ~= max_cnt then
    self.maxCount = max_cnt
  end
end

function HeadLotteryData:SetTodayTenCount(todayTenCount, maxTenCount)
  self.todayTenCount = todayTenCount
  if nil ~= maxTenCount then
    self.maxTenCount = maxTenCount
  end
end

function HeadLotteryData:SetTodayExtraCount(today_extra_cnt, max_extra_cnt)
  self.todayExtraCount = today_extra_cnt
  if nil ~= max_extra_cnt then
    self.maxExtraCount = max_extra_cnt
  end
end

function HeadLotteryData:SetOnceMaxCount(once_max_cnt)
  self.onceMaxCount = once_max_cnt
end

function HeadLotteryData:SetFreeCount(free_cnt)
  self.freeCount = free_cnt
end
