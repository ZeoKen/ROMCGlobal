ActivityIntegrationView = class("ActivityIntegrationView", ContainerView)
ActivityIntegrationView.ViewType = UIViewType.NormalLayer
autoImport("ActivityIntegrationTabCell")
autoImport("ActivityIntegrationPreviewSubView")
autoImport("ActivityIntegrationShopSubView")
autoImport("ActivityBattlePassView")
autoImport("ActivityFlipCardView")
autoImport("ActivityIntegrationSignInSubView")
autoImport("ActivityIntegrationTaskSubView")
autoImport("ActivityIntegrationQuestSubView")
autoImport("ActivityIntegrationMemorySubView")
autoImport("ActivityIntegrationBriefSubView")
autoImport("ActivitySelfChooseCardView")
autoImport("ActivityExchangeView")
autoImport("ActivityDungeonMvpCardView")
local picIns = PictureManager.Instance
local DefaultDecorateTexName = "activityintegration_bg_bottom_01"

function ActivityIntegrationView:Init()
  self:FindObjs()
  self:AddViewEvts()
  self:AddMapEvts()
  self:InitDatas()
  self:InitShow()
end

function ActivityIntegrationView:FindObjs()
  self.goBTNBack = self:FindGO("BTN_Back", self.gameObject)
  self.u_bgTex = self:FindComponent("MainBG", UITexture, self.gameObject)
  PictureManager.ReFitFullScreen(self.u_bgTex, 1)
  self.tabLine = self:FindGO("TabLine", self.gameObject):GetComponent(UISprite)
  self.tagScrollView = self:FindGO("TagScrollView"):GetComponent(UIScrollView)
  self.tabGrid = self:FindGO("TabGrid"):GetComponent(UIGrid)
  self.tabSelectListCtrl = UIGridListCtrl.new(self.tabGrid, ActivityIntegrationTabCell, "ActivityIntegrationTabCell")
  self.tabSelectListCtrl:AddEventListener(MouseEvent.MouseClick, self.handleClickTabCell, self)
  self.bottom_01 = self:FindComponent("bottom_01", UITexture, self.gameObject)
end

function ActivityIntegrationView:AddMapEvts()
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.CloseSelf)
end

function ActivityIntegrationView:AddViewEvts()
  self:AddClickEvent(self.goBTNBack, function()
    self:CloseSelf()
  end)
end

function ActivityIntegrationView:InitDatas()
  local viewdata = self.viewdata and self.viewdata.viewdata
  self.currentTab = viewdata and viewdata.tab
  self.groupID = viewdata and viewdata.group or 1
  local groupInfo = ActivityIntegrationProxy.Instance:GetGroupInfo(self.groupID)
  self.activityIDs = groupInfo and groupInfo.activityIDs
  self.validIDs = viewdata and viewdata.ids
end

function ActivityIntegrationView:CheckIdValid(id)
  if not self.validIDs then
    return false
  end
  if TableUtility.ArrayFindIndex(self.validIDs, id) > 0 then
    return true
  end
  return false
end

local redtips = {
  [8] = SceneTip_pb.EREDSYS_NEW_YEAR_MEMORY,
  [11] = ActivityExchangeProxy.RedTipId
}

function ActivityIntegrationView:InitShow()
  local tabList = {}
  if self.activityIDs and #self.activityIDs > 0 then
    local curServer = FunctionLogin.Me():getCurServerData()
    local curServerID = curServer.linegroup or 1
    for i = 1, #self.activityIDs do
      local single = self.activityIDs[i]
      local staticData = Table_ActivityIntegration[single]
      if staticData then
        local isTF = EnvChannel.IsTFBranch()
        local type = staticData.Type
        if type == 1 then
          local activityId = staticData.Params.ActivityId
          local startTime = ActivityBattlePassProxy.Instance:GetStartTime(activityId)
          local endTime = ActivityBattlePassProxy.Instance:GetEndTime(activityId)
          local format = "%d-%d-%d %d:%d:%d"
          local startTimeTable = os.date("*t", startTime)
          local endTimeTable = os.date("*t", endTime)
          startTime = string.format(format, startTimeTable.year, startTimeTable.month, startTimeTable.day, startTimeTable.hour, startTimeTable.min, startTimeTable.sec)
          endTime = string.format(format, endTimeTable.year, endTimeTable.month, endTimeTable.day, endTimeTable.hour, endTimeTable.min, endTimeTable.sec)
          local timeValid = ActivityBattlePassProxy.Instance:IsBPAvailable(activityId)
          if timeValid then
            local data = {
              startTime = startTime,
              endTime = endTime,
              id = single,
              staticData = staticData,
              Redtip = SceneTip_pb.EREDSYS_ACT_BP,
              subRedtip = activityId
            }
            table.insert(tabList, data)
          end
        elseif type == 2 then
          local activityId = staticData.Params.ActivityId
          local signInFinish = ActivityIntegrationProxy.Instance:CheckSuperSignInFinish(activityId)
          if not signInFinish then
            local serverValid = true
            local serverList = staticData.ServerID
            if serverList and 0 < #serverList and TableUtility.ArrayFindIndex(serverList, curServerID) == 0 then
              serverValid = false
            end
            if serverValid then
              local actData = ActivityIntegrationProxy.Instance:GetSuperSignInActInfo(activityId)
              if actData then
                local startTime = actData.starttime
                local endTime = actData.endtime
                local format = "%d-%d-%d %d:%d:%d"
                local startTimeTable = os.date("*t", startTime)
                local endTimeTable = os.date("*t", endTime)
                startTime = string.format(format, startTimeTable.year, startTimeTable.month, startTimeTable.day, startTimeTable.hour, startTimeTable.min, startTimeTable.sec)
                endTime = string.format(format, endTimeTable.year, endTimeTable.month, endTimeTable.day, endTimeTable.hour, endTimeTable.min, endTimeTable.sec)
                local data = {
                  startTime = startTime,
                  endTime = endTime,
                  id = single,
                  staticData = staticData,
                  Redtip = 10757,
                  subRedtip = activityId
                }
                table.insert(tabList, data)
              else
                local startTime, endTime, duration
                if isTF then
                  duration = staticData.TFDuration
                else
                  duration = staticData.Duration
                end
                if duration and duration ~= _EmptyTable then
                  startTime = duration[1]
                  endTime = duration[2]
                  if startTime ~= "" and endTime ~= "" then
                    if KFCARCameraProxy.Instance:CheckDateValid(startTime, endTime) or self:CheckIdValid(single) then
                      local data = {
                        startTime = startTime,
                        endTime = endTime,
                        id = single,
                        staticData = staticData,
                        Redtip = 10757,
                        subRedtip = activityId
                      }
                      table.insert(tabList, data)
                    end
                  else
                    xdlog("签到 非正常时间配置")
                    local canSign = ActivityIntegrationProxy.Instance:CheckSuperSignInCanSign(activityId)
                    if canSign then
                      local data = {
                        id = single,
                        staticData = staticData,
                        Redtip = 10757,
                        subRedtip = activityId
                      }
                      table.insert(tabList, data)
                    end
                  end
                end
              end
            end
          end
        elseif type == 5 then
          local activityId = staticData.Params.ActivityId
          local timeValid = ActivityFlipCardProxy.Instance:IsActivityAvailable(activityId)
          if timeValid then
            local config = Table_ActPersonalTimer[activityId]
            if config then
              local isTFBranch = EnvChannel.IsTFBranch()
              local startTimeStr = isTFBranch and config.TfStartTime or config.StartTime
              local endTimeStr = isTFBranch and config.TfEndTime or config.EndTime
              local data = {
                startTime = startTimeStr,
                endTime = endTimeStr,
                id = single,
                staticData = staticData,
                Redtip = ActivityFlipCardProxy.RedTipId,
                subRedtip = activityId
              }
              table.insert(tabList, data)
            end
          end
        elseif type == 6 then
          local activityId = staticData.Params.ActivityId
          local timeValid = ActivityIntegrationProxy.Instance:CheckActPersinalActValid(activityId)
          xdlog("任务页  是否满足", timeValid)
          if timeValid then
            local actPersonalData = Table_ActPersonalTimer[activityId]
            local createDayBase = ActivityIntegrationProxy.Instance:IsActBasedOnCreateDay(activityId)
            if createDayBase then
              local allFinish = ActivityIntegrationProxy.Instance:IsChallengeAllFinish(activityId)
              if not allFinish then
                local closeOnDay = actPersonalData and actPersonalData.CloseOnAccDay
                if closeOnDay then
                  local createDay = ActivityIntegrationProxy.Instance.createDay or 1
                  local startTime = ActivityIntegrationProxy.Instance:GetUnlockTime(actPersonalData.OpenOnAccDay)
                  local endTime = ActivityIntegrationProxy.Instance:GetUnlockTime(closeOnDay)
                  local format = "%d-%d-%d %d:%d:%d"
                  local startTimeTable = os.date("*t", startTime)
                  local endTimeTable = os.date("*t", endTime)
                  startTime = string.format(format, startTimeTable.year, startTimeTable.month, startTimeTable.day, startTimeTable.hour, startTimeTable.min, startTimeTable.sec)
                  endTime = string.format(format, endTimeTable.year, endTimeTable.month, endTimeTable.day, endTimeTable.hour, endTimeTable.min, endTimeTable.sec)
                  local data = {
                    startTime = startTime,
                    endTime = endTime,
                    id = single,
                    staticData = staticData,
                    Redtip = SceneTip_pb.EREDSYS_NEW_SERVER_CHALLENGE,
                    subRedtip = activityId
                  }
                  table.insert(tabList, data)
                else
                  local data = {
                    startTime = nil,
                    endTime = nil,
                    id = single,
                    staticData = staticData,
                    Redtip = SceneTip_pb.EREDSYS_NEW_SERVER_CHALLENGE,
                    subRedtip = activityId
                  }
                  table.insert(tabList, data)
                end
              elseif actPersonalData.CloseDay then
                local format = "%d-%d-%d %d:%d:%d"
                local createDay = ActivityIntegrationProxy.Instance.createDay or 0
                local startTime = ActivityIntegrationProxy.Instance:GetUnlockTime(actPersonalData.OpenOnAccDay)
                local startTimeTable = os.date("*t", startTime)
                startTime = string.format(format, startTimeTable.year, startTimeTable.month, startTimeTable.day, startTimeTable.hour, startTimeTable.min, startTimeTable.sec)
                local actInfo = ActivityIntegrationProxy.Instance:GetActPersonalActInfo(activityId)
                local endTime = actInfo.endtime
                local endTimeTable = os.date("*t", endTime)
                endTime = string.format(format, endTimeTable.year, endTimeTable.month, endTimeTable.day, endTimeTable.hour, endTimeTable.min, endTimeTable.sec)
                local data = {
                  startTime = startTime,
                  endTime = endTime,
                  id = single,
                  staticData = staticData,
                  Redtip = SceneTip_pb.EREDSYS_NEW_SERVER_CHALLENGE,
                  subRedtip = activityId
                }
                table.insert(tabList, data)
              else
                xdlog("任务类已全部完成  不显示页签", activityId)
              end
            else
              local actInfo = ActivityIntegrationProxy.Instance:GetActPersonalActInfo(activityId)
              local startTime = actInfo.starttime
              local endTime = actInfo.endtime
              local format = "%d-%d-%d %d:%d:%d"
              local startTimeTable = os.date("*t", startTime)
              local endTimeTable = os.date("*t", endTime)
              startTime = string.format(format, startTimeTable.year, startTimeTable.month, startTimeTable.day, startTimeTable.hour, startTimeTable.min, startTimeTable.sec)
              endTime = string.format(format, endTimeTable.year, endTimeTable.month, endTimeTable.day, endTimeTable.hour, endTimeTable.min, endTimeTable.sec)
              local data = {
                startTime = startTime,
                endTime = endTime,
                id = single,
                staticData = staticData,
                Redtip = SceneTip_pb.EREDSYS_NEW_SERVER_CHALLENGE,
                subRedtip = activityId
              }
              table.insert(tabList, data)
            end
          end
        elseif type == 9 then
          local data = {id = single, staticData = staticData}
          table.insert(tabList, data)
        elseif type == 10 then
          local activityId = staticData.Params.ActivityId
          local isValid = ActivitySelfChooseProxy.Instance:IsActivityAvailable(activityId)
          if isValid then
            local config = Table_ActPersonalTimer[activityId]
            if config then
              local startTimeStr
              if not config.OpenOnAccDay then
                local isTFBranch = EnvChannel.IsTFBranch()
                if isTFBranch then
                  startTimeStr = config.TfStartTime
                else
                  startTimeStr = config.StartTime
                end
              end
              local endTime = ActivitySelfChooseProxy.Instance:GetEndTime(activityId)
              local endTimeStr = StringUtil.FormatTimeStamp2NormalTimeStr(endTime)
              local data = {
                startTime = startTimeStr,
                endTime = endTimeStr,
                id = single,
                staticData = staticData,
                Redtip = ActivitySelfChooseProxy.RedTipId,
                subRedtip = activityId
              }
              table.insert(tabList, data)
            end
          end
        else
          local activityId = staticData.Params.ActivityId
          local serverValid = true
          local serverList = staticData.ServerID
          if serverList and 0 < #serverList and TableUtility.ArrayFindIndex(serverList, curServerID) == 0 then
            serverValid = false
          end
          if serverValid then
            local startTime, endTime, duration
            if isTF then
              duration = staticData.TFDuration
            else
              duration = staticData.Duration
            end
            startTime = duration[1]
            endTime = duration[2]
            if startTime and endTime then
              if KFCARCameraProxy.Instance:CheckDateValid(startTime, endTime) or self:CheckIdValid(single) then
                local data = {
                  startTime = startTime,
                  endTime = endTime,
                  id = single,
                  staticData = staticData,
                  Redtip = redtips and redtips[type],
                  subRedtip = activityId
                }
                table.insert(tabList, data)
              end
            elseif type == 4 then
              local data = {
                startTime = nil,
                endTime = nil,
                id = single,
                staticData = staticData
              }
              table.insert(tabList, data)
            end
          end
        end
      end
    end
  end
  table.sort(tabList, function(l, r)
    local l_id = l.id
    local r_id = r.id
    return l.id < r.id
  end)
  self.tabSelectListCtrl:ResetDatas(tabList)
  self.tabLine.width = 42 + (#tabList - 1) * 148.2
  self:LoadSubView(tabList)
  local cells = self.tabSelectListCtrl:GetCells()
  for i = 1, #cells do
    if cells[i].data.Redtip then
      self:RegisterRedTipCheck(cells[i].data.Redtip, cells[i].gameObject, 42, {-90, -30}, nil, cells[i].data.subRedtip)
    end
  end
  local targetCell
  if cells and 0 < #cells then
    if self.currentTab then
      for i = 1, #cells do
        if cells[i].id == self.currentTab then
          self:handleClickTabCell(cells[i])
          targetCell = cells[i]
          break
        end
      end
    elseif self.validIDs then
      for i = 1, #cells do
        if 0 < TableUtility.ArrayFindIndex(self.validIDs, cells[i].id) then
          self:handleClickTabCell(cells[i])
          targetCell = cells[i]
          break
        end
      end
    else
      self:handleClickTabCell(cells[1])
    end
  end
  if targetCell then
    local panel = self.tagScrollView.panel
    local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, targetCell.gameObject.transform)
    local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
    offset = Vector3(0, offset.y, 0)
    self.tagScrollView:MoveRelative(offset)
  end
end

function ActivityIntegrationView:LoadSubView(tabList)
  local loadPreviewPage = function()
    if not self.previewView then
      self.previewView = self:AddSubView("ActivityIntegrationPreviewSubView", ActivityIntegrationPreviewSubView)
      self.previewView.parentView = self
    end
    return self.previewView
  end
  local loadSignInPage = function()
    if not self.signInView then
      self.signInView = self:AddSubView("ActivityIntegrationSignInSubView", ActivityIntegrationSignInSubView)
      self.signInView.parentView = self
    end
    return self.signInView
  end
  local loadShopPage = function()
    if not self.shopView then
      self.shopView = self:AddSubView("ActivityIntegrationShopSubView", ActivityIntegrationShopSubView)
      self.shopView.parentView = self
    end
    return self.shopView
  end
  local loadBPPage = function(viewdata)
    if not self.bpView then
      self.bpView = self:AddSubView("ActivityBattlePassView", ActivityBattlePassView, nil, viewdata)
      self.bpView.parentView = self
    end
    return self.bpView
  end
  local loadFlipCardPage = function(viewdata)
    if not self.flipCardView then
      self.flipCardView = self:AddSubView("ActivityFlipCardView", ActivityFlipCardView, nil, viewdata)
      self.flipCardView.parentView = self
    end
    return self.flipCardView
  end
  local loadTaskPage = function(viewdata)
    if not self.taskPage then
      self.taskPage = self:AddSubView("ActivityIntegrationTaskSubView", ActivityIntegrationTaskSubView, nil, viewdata)
      self.taskPage.parentView = self
    end
    return self.taskPage
  end
  local loadDailyQuestPage = function(viewdata)
    if not self.questPage then
      self.questPage = self:AddSubView("ActivityIntegrationQuestSubView", ActivityIntegrationQuestSubView, nil, viewdata)
      self.questPage.parentView = self
    end
    return self.questPage
  end
  local loadMemoryPage = function(viewdata)
    if not self.memoryPage then
      YearMemoryProxy.Instance:InitStaticData()
      self.memoryPage = self:AddSubView("ActivityIntegrationMemorySubView", ActivityIntegrationMemorySubView, nil, viewdata)
      self.memoryPage.parentView = self
      local year = viewdata and viewdata.Year
      if year then
        YearMemoryProxy.Instance:CallQueryYearMemoryUserCmd(year)
      end
    end
    return self.memoryPage
  end
  local loadBriefPage = function(viewdata)
    if not self.briefPage then
      self.briefPage = self:AddSubView("ActivityIntegrationBriefSubView", ActivityIntegrationBriefSubView, nil, viewdata)
      self.briefPage.parentView = self
    end
    return self.briefPage
  end
  local loadSelfChooseCardPage = function(viewdata)
    if not self.selfChooseCardView then
      self.selfChooseCardView = self:AddSubView("ActivitySelfChooseCardView", ActivitySelfChooseCardView, nil, viewdata)
      self.selfChooseCardView.parentView = self
    end
    return self.selfChooseCardView
  end
  local loadExchangePage = function(viewdata)
    if not self.exchangeView then
      self.exchangeView = self:AddSubView("ActivityExchangeView", ActivityExchangeView, nil, viewdata)
      self.exchangeView.parentView = self
    end
    return self.exchangeView
  end
  local loadDungeonMvpCardPage = function(viewdata)
    if not self.dungeonMvpCardView then
      self.dungeonMvpCardView = self:AddSubView("ActivityDungeonMvpCardView", ActivityDungeonMvpCardView, nil, viewdata)
      self.dungeonMvpCardView.parentView = self
    end
    return self.dungeonMvpCardView
  end
  self.subViews = {}
  self.subViews[1] = loadBPPage
  self.subViews[2] = loadSignInPage
  self.subViews[3] = loadPreviewPage
  self.subViews[4] = loadShopPage
  self.subViews[5] = loadFlipCardPage
  self.subViews[6] = loadTaskPage
  self.subViews[7] = loadDailyQuestPage
  self.subViews[8] = loadMemoryPage
  self.subViews[9] = loadBriefPage
  self.subViews[10] = loadSelfChooseCardPage
  self.subViews[11] = loadExchangePage
  self.subViews[12] = loadDungeonMvpCardPage
  for i = 1, #tabList do
    local staticData = tabList[i].staticData
    if staticData then
      local subView = self.subViews[staticData.Type] and self.subViews[staticData.Type](staticData.Params)
      if subView then
        subView.gameObject:SetActive(false)
      end
    end
  end
end

function ActivityIntegrationView:handleClickTabCell(cellCtrl)
  local data = cellCtrl.staticData
  local id = data.id
  local type = data.Type
  xdlog(type)
  local subView = self.subViews[type]()
  if self.currentType and self.currentType ~= type then
    local curSubView = self.subViews[self.currentType]()
    curSubView.gameObject:SetActive(false)
    curSubView:OnHide()
  end
  self.currentType = type
  if self.currentID and self.currentID == id then
    return
  end
  self.currentID = id
  subView.gameObject:SetActive(true)
  subView:OnShow()
  subView:OnEnter(id)
  self:ChangeSubSelectorOnSelect(data.id)
  self:HandleSwitchBG(data.BgTextture)
end

function ActivityIntegrationView:ChangeSubSelectorOnSelect(id)
  local ssCells = self.tabSelectListCtrl:GetCells()
  for i = 1, #ssCells do
    local sstab = ssCells[i].data.staticData.id
    ssCells[i]:SetSelect(sstab == id)
  end
end

function ActivityIntegrationView:HandleClickHelpBtn(helpid)
  local helpConfig = Table_Help[helpid]
  if helpConfig then
    self:OpenHelpView(helpConfig)
  end
end

function ActivityIntegrationView:HandleSwitchBG(textureName)
  if self.textureName and textureName == self.textureName then
    return
  end
  if self.textureName then
    PictureManager.Instance:UnLoadUI(self.textureName, self.u_bgTex)
  end
  self.textureName = textureName
  PictureManager.Instance:SetUI(self.textureName, self.u_bgTex)
end

function ActivityIntegrationView:SetBottomBg(textureName)
  self:UnloadBottomBg()
  picIns:SetUI(textureName, self.bottom_01)
  self.currentBottomTexName = textureName
end

function ActivityIntegrationView:ResetBottomBg()
  self:SetBottomBg(DefaultDecorateTexName)
end

function ActivityIntegrationView:UnloadBottomBg()
  if self.currentBottomTexName then
    picIns:UnLoadUI(self.currentBottomTexName, self.bottom_01)
  end
end

function ActivityIntegrationView:OnEnter(id)
  if not self.currentBottomTexName then
    self:ResetBottomBg()
  end
end

function ActivityIntegrationView:OnExit()
  ActivityIntegrationView.super.OnExit(self)
  self:UnloadBottomBg()
end
