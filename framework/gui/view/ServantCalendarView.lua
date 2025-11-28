autoImport("WrapCellHelper")
autoImport("ServantCalendarMonthCombineItemCell")
autoImport("ServantCalendarWeekTimeLineCell")
autoImport("ServantCalendarWeekContainerCell")
autoImport("ServantWeekIntervalCell")
autoImport("ServantCalendarWeekBgCell")
ServantCalendarView = class("ServantCalendarView", SubView)
local Prefab_Path = ResourcePathHelper.UIView("ServantCalendarView")
local ReUniteCellData = function(datas, perRowNum)
  local newData = {}
  if datas ~= nil and 0 < #datas then
    for i = 1, #datas do
      local i1 = math.floor((i - 1) / perRowNum) + 1
      local i2 = math.floor((i - 1) % perRowNum) + 1
      newData[i1] = newData[i1] or {}
      if datas[i] == nil then
        newData[i1][i2] = nil
      else
        newData[i1][i2] = datas[i]
      end
    end
  end
  return newData
end

function ServantCalendarView:Init()
  ServantCalendarProxy.Instance:InitCalendar()
  self.weekIndex = 1
  self.monthIndex = 1
  self:LoadSubView()
  self:FindObjs()
  self:AddUIEvts()
  self:AddViewEvts()
  self:InitView()
end

function ServantCalendarView:LoadSubView()
  local container = self:FindGO("calendarView")
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, container, true)
  obj.name = "ServantCalendarView"
end

function ServantCalendarView:FindObjs()
  local dateObj = self:FindGO("DatePos")
  self.dateLab = dateObj:GetComponent(UILabel)
  self.monthRoot = self:FindGO("MonthWrap")
  self.weekRoot = self:FindGO("WeekWrap")
  self.nextBtn = self:FindGO("NextBtn")
  self.previousBtn = self:FindGO("PreviousBtn")
  self.monthScrollView = self:FindGO("MonthScrollView"):GetComponent("UIScrollView")
  self.monthPos = self:FindGO("MonthPos")
  self.weekPos = self:FindGO("WeekPos")
  self.curTimeLine = self:FindGO("CurTimeLine")
  self.curTimeLabel = self:FindComponent("CurTime", UILabel, self.curTimeLine)
  self.weekToggle = self:FindGO("WeekToggle"):GetComponent(UIToggle)
  self.monthToggle = self:FindGO("MonthToggle"):GetComponent(UIToggle)
  self.weekToggleLab = self.weekToggle.gameObject:GetComponent(UILabel)
  self.weekToggleLab.text = ZhString.Servant_Calendar_WeekTog
  self.monthToggleLab = self.monthToggle.gameObject:GetComponent(UILabel)
  self.monthToggleLab.text = ZhString.Servant_Calendar_MonthTog
  self.helpBtn = self:FindGO("CalendarHelpBtn")
  local weekDayGrid = self:FindGO("WeekDayGrid")
  self.weekContainerPos = self:FindGO("ContainerPos")
  self.weekdayLab = {}
  for i = 1, 7 do
    self.weekdayLab[i] = self:FindGO("day" .. i, weekDayGrid):GetComponent(UILabel)
  end
end

function ServantCalendarView:AddUIEvts()
  self:RegistShowGeneralHelpByHelpID(30001, self.helpBtn)
  self:AddClickEvent(self.nextBtn, function(go)
    self:OnClickNext()
  end)
  self:AddClickEvent(self.previousBtn, function(go)
    self:OnClickPrevious()
  end)
  self:AddToggleChange(self.weekToggle, self.weekToggleLab, ServantRecommendView._ColorEffectBlue, ServantRecommendView._ColorTitleGray, self.OnClickWeekTog)
  self:AddToggleChange(self.monthToggle, self.monthToggleLab, ServantRecommendView._ColorEffectBlue, ServantRecommendView._ColorTitleGray, self.OnClickMonthTog)
end

function ServantCalendarView:AddToggleChange(toggle, label, toggleColor, normalColor, handler)
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

function ServantCalendarView:OnClickWeekTog()
  self:Show(self.weekPos)
  self:Hide(self.monthPos)
  self:ShowWeek()
end

function ServantCalendarView:OnClickMonthTog()
  self:Show(self.monthPos)
  self:Hide(self.weekPos)
  self:ShowMonth()
end

function ServantCalendarView:RefreshCurrentTimeLine(minValue, maxValue)
  if not (ServantCalendarProxy.Instance:IsTodayForeachWeek() and minValue) or not maxValue then
    self.curTimeLine:SetActive(false)
    return
  end
  local curServerTime = ServerTime.CurServerTime() / 1000
  self.curTimeLabel.text = os.date("%H:%M", curServerTime)
  local hour = tonumber(os.date("%H", curServerTime))
  local min = tonumber(os.date("%M", curServerTime))
  local cur = hour + min / 60
  if minValue < cur and cur < maxValue + 1 then
    self.curTimeLine:SetActive(true)
    local y = self.initCurTimeLinePos - (cur - minValue) * 220
    self.curTimeLine.transform.localPosition = LuaGeometry.GetTempVector3(0, y, 0)
  else
    self.curTimeLine:SetActive(false)
  end
end

function ServantCalendarView:OnClickNext()
  local viewStatus = ServantCalendarProxy.Instance:GetViewStatus()
  if viewStatus == ServantCalendarProxy.EViewStatus.WEEK then
    if nil == ServantCalendarProxy.Instance:GetWeekCalendar(self.weekIndex + 1) then
      MsgManager.ShowMsgByID(34001)
      return
    else
      self.weekIndex = self.weekIndex + 1
      self:ShowWeek()
    end
  elseif viewStatus == ServantCalendarProxy.EViewStatus.MONTH then
    if nil == ServantCalendarProxy.Instance:GetMonthCalendar(self.monthIndex + 1) then
      MsgManager.ShowMsgByID(34001)
      return
    else
      self.monthIndex = self.monthIndex + 1
      self:ShowMonth()
    end
  end
end

function ServantCalendarView:OnClickPrevious()
  local viewStatus = ServantCalendarProxy.Instance:GetViewStatus()
  if viewStatus == ServantCalendarProxy.EViewStatus.WEEK then
    if nil == ServantCalendarProxy.Instance:GetWeekCalendar(self.weekIndex - 1) then
      MsgManager.ShowMsgByID(34000)
      return
    else
      self.weekIndex = self.weekIndex - 1
      self:ShowWeek()
    end
  elseif viewStatus == ServantCalendarProxy.EViewStatus.MONTH then
    if nil == ServantCalendarProxy.Instance:GetMonthCalendar(self.monthIndex - 1) then
      MsgManager.ShowMsgByID(34000)
      return
    else
      self.monthIndex = self.monthIndex - 1
      self:ShowMonth()
    end
  end
end

function ServantCalendarView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.NUserServantReservationUserCmd, self.RefreshUI)
end

function ServantCalendarView:RefreshUI()
  local viewStatus = ServantCalendarProxy.Instance:GetViewStatus()
  if viewStatus == ServantCalendarProxy.EViewStatus.WEEK then
    self:ShowWeek()
  else
    self:ShowMonth()
  end
end

function ServantCalendarView:InitView()
  local wrapConfig = {
    wrapObj = self.monthRoot,
    pfbNum = 4,
    cellName = "ServantCalendarMonthCombineItemCell",
    control = ServantCalendarMonthCombineItemCell
  }
  self.monthWrapHelper = WrapCellHelper.new(wrapConfig)
  self.monthWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClickMonthCell, self)
  self.weekScroll = self:FindGO("WeekScrollView"):GetComponent(UIScrollView)
  self.initCurTimeLinePos = self.curTimeLine.transform.localPosition.y
  self.lineTimeGrid = self:FindGO("LineContainer"):GetComponent(UIGrid)
  self.timeLineCtl = UIGridListCtrl.new(self.lineTimeGrid, ServantCalendarWeekTimeLineCell, "ServantCalendarWeekTimeLineCell")
  local weekGrid = self:FindGO("WeekContainer"):GetComponent(UIGrid)
  self.weekDayCtl = UIGridListCtrl.new(weekGrid, ServantCalendarWeekContainerCell, "ServantCalendarWeekContainerCell")
  self.weekDayCtl:AddEventListener(MouseEvent.MouseClick, self.HandleClickWeekCell, self)
  local weekGrid = self:FindGO("WeekBgContainer"):GetComponent(UIGrid)
  self.weekBgCtl = UIGridListCtrl.new(weekGrid, ServantCalendarWeekBgCell, "ServantCalendarWeekBgCell")
  self.weekBgCtl:AddEventListener(MouseEvent.MouseClick, self.HandleClickWeekCell, self)
  local weekConsoleGrid = self:FindGO("WeekConsoleActContainer"):GetComponent(UIGrid)
  self.weekConsoleCtl = UIGridListCtrl.new(weekConsoleGrid, ServantWeekIntervalCell, "ServantWeekIntervalCell")
  self:ShowWeek()
  ServantCalendarProxy.Instance:SetWeekIndex(self.weekIndex)
  ServantCalendarProxy.Instance:SetMonthIndex(self.monthIndex)
end

function ServantCalendarView:ShowWeek()
  ServantCalendarProxy.Instance:SetViewStatus(ServantCalendarProxy.EViewStatus.WEEK)
  ServantCalendarProxy.Instance:SetWeekIndex(self.weekIndex)
  local viewdata = ServantCalendarProxy.Instance:GetCurWeekData()
  self.weekDayCtl:ResetDatas(viewdata)
  self.weekBgCtl:ResetDatas(viewdata)
  local weekConsoleActData, maxNum = ServantCalendarProxy.Instance:GetWeekConsoleData()
  self.weekConsoleCtl:ResetDatas(weekConsoleActData)
  local minValue, maxValue = ServantCalendarProxy.Instance:GetMinMaxTimeGap(viewdata)
  self:RefreshCurrentTimeLine(minValue, maxValue)
  local gap = maxValue - minValue
  local timelineDatas = {}
  local hasWeekConolseData = 0 < maxNum
  maxNum = math.min(maxNum, 3)
  local cal_minTime
  if hasWeekConolseData then
    cal_minTime = minValue
  else
    cal_minTime = minValue + 1
  end
  self.weekContainerPos.transform.localPosition = LuaGeometry.GetTempVector3(0, -(maxNum - 3) * 70, 0)
  local y = hasWeekConolseData and -15 or -215
  local x = self.lineTimeGrid.gameObject.transform.localPosition.x
  self.lineTimeGrid.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(x, y, 0)
  for i = cal_minTime, maxValue do
    timelineDatas[#timelineDatas + 1] = i
  end
  self.timeLineCtl:ResetDatas(timelineDatas)
  local days = ServantCalendarProxy.Instance:GetWeekDays()
  for i = 1, 7 do
    self.weekdayLab[i].text = days[i]
  end
  local y, m = ServantCalendarProxy.Instance:ViewDate()
  self.container:SetSeasonTexture(m)
  self.dateLab.text = string.format(ZhString.Servant_Calendar_Date, y, m)
  self.weekScroll:ResetPosition()
  self.weekToggle.value = true
end

function ServantCalendarView:ShowMonth()
  ServantCalendarProxy.Instance:SetViewStatus(ServantCalendarProxy.EViewStatus.MONTH)
  ServantCalendarProxy.Instance:SetMonthIndex(self.monthIndex)
  local viewdata = ServantCalendarProxy.Instance:GetMonthCalendar(self.monthIndex)
  local y, m = ServantCalendarProxy.Instance:ViewDate()
  self.container:SetSeasonTexture(m)
  self.dateLab.text = string.format(ZhString.Servant_Calendar_Date, y, m)
  local newData = ReUniteCellData(viewdata, 7)
  self.monthWrapHelper:UpdateInfo(newData)
  self.monthWrapHelper:ResetPosition()
  self.monthScrollView:ResetPosition()
end

function ServantCalendarView:HandleClickSingleDay(d)
  ServantCalendarProxy.Instance:SetChooseDayData(d)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.ServantActivityInfoView,
    viewdata = d
  })
end

function ServantCalendarView:HandleClickMonthCell(cellCtl)
  local cellData = cellCtl and cellCtl.data
  if not cellData then
    return
  end
  if cellData:IsExpired() then
    MsgManager.ShowMsgByID(34002)
    return
  end
  self:HandleClickSingleDay(cellData)
end

function ServantCalendarView:HandleClickWeekCell(cellCtl)
  local cellData = cellCtl and cellCtl.data
  if not cellData then
    return
  end
  if cellData:IsExpired() then
    MsgManager.ShowMsgByID(34002)
    return
  end
  self:HandleClickSingleDay(cellData)
end
