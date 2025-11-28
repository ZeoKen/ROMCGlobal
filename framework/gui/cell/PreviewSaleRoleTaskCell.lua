local BaseCell = autoImport("BaseCell")
PreviewSaleRoleTaskCell = class("PreviewSaleRoleTaskCell", BaseCell)
autoImport("PreviewSaleRoleTaskItemCell")

function PreviewSaleRoleTaskCell:Init()
  PreviewSaleRoleTaskCell.super.Init(self)
  self:FindObjs()
end

function PreviewSaleRoleTaskCell:FindObjs()
  self.itemContainer = self:FindGO("ItemContainer")
  self.levelLabel = self:FindGO("LevelLabel"):GetComponent(UILabel)
  self.descLabel = self:FindGO("DescLabel"):GetComponent(UILabel)
  self.finishSymbol = self:FindGO("FinishSymbol")
  self.processDot = self:FindGO("ProcessDot")
  self.processFinish = self:FindGO("ProcessFinish")
  self.greenLine = self:FindGO("GreenLine"):GetComponent(UISprite)
  self.emptyLine = self:FindGO("EmptyLine"):GetComponent(UISprite)
  self.timeRoot = self:FindGO("TimeRoot")
  self.timeLabel = self:FindGO("TimeLabel"):GetComponent(UILabel)
  self.traceBtn = self:FindGO("traceBtn")
  self:AddClickEvent(self.traceBtn, function()
    local staticData = Table_Map[Game.MapManager:GetMapID()]
    if staticData ~= nil and WorldMapProxy.Instance:IsCloneMap() then
      ServiceMapProxy.Instance:CallChangeCloneMapCmd(staticData.CloneMap)
      return
    end
    if self.questData then
      EventManager.Me():DispatchEvent(QuestManualEvent.BeforeGoClick, {
        data = {
          questData = self.questData,
          type = 1
        }
      })
      if QuestProxy.Instance:checkIsShowDirAndDis(self.questData) then
        FunctionQuest.Me():executeManualQuest(self.questData)
      else
        FunctionQuest.Me():executeQuest(self.questData)
      end
    end
    GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
  end)
end

local p = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
local parseStamp = function(str)
  local year, month, day, hour, min, sec = str:match(p)
  return os.time({
    year = year,
    month = month,
    day = day,
    hour = hour,
    min = min,
    sec = sec
  })
end

function PreviewSaleRoleTaskCell:SetData(data)
  self.data = data
  local isFinish = false
  local achieved = false
  local unlock = false
  if self.data.status ~= nil then
    self.timeRoot:SetActive(false)
    if self.data.status == EQUESTHEROSTATUS.EQUESTHEROSTATUS_PROCESS then
      achieved = true
      isFinish = false
      self.traceBtn:SetActive(true)
      self.levelLabel.gameObject:SetActive(true)
    elseif self.data.status == EQUESTHEROSTATUS.EQUESTHEROSTATUS_DONE then
      achieved = true
      isFinish = true
      self.traceBtn:SetActive(false)
      self.levelLabel.gameObject:SetActive(false)
    else
      unlock = true
      isFinish = false
      achieved = false
      self.timeRoot:SetActive(true)
      self.timeLabel.text = ZhString.Warband_Empty_NoSeason
      self.traceBtn:SetActive(false)
      self.levelLabel.gameObject:SetActive(true)
    end
  else
    unlock = true
    isFinish = false
    achieved = false
    self.timeRoot:SetActive(true)
    self.traceBtn:SetActive(false)
    self.levelLabel.gameObject:SetActive(true)
  end
  self.cfg = Table_QuestHero[self.data.id]
  if self.cfg ~= nil then
    self.descLabel.text = self.cfg.Title
    for i = 1, #self.cfg.QuestIDs do
      local questData = QuestProxy.Instance:getSameQuestID(self.cfg.QuestIDs[i])
      if questData and questData.complete == false then
        self.questData = questData
        break
      end
    end
    local cell = PreviewSaleRoleTaskItemCell.new(self.itemContainer)
    local data = ItemData.new("PreviewSaleRoleTaskItem", self.cfg.Params.itemid)
    data.num = self.cfg.Params.num
    data.unlock = unlock
    cell:SetData(data)
    cell:AddEventListener(MouseEvent.MouseClick, self.OnClickCell, self)
    if cell.bg then
      cell.bg.alpha = isFinish and 0.5 or 1
    end
    if cell.numLab then
      cell.numLab.alpha = isFinish and 0.5 or 1
    end
    if cell.icon then
      cell.icon.alpha = isFinish and 0.5 or 1
    end
    local isReleaseBranch = EnvChannel.IsReleaseBranch()
    local startTime
    if isReleaseBranch then
      startTime = parseStamp(self.cfg.StartTime)
    else
      startTime = parseStamp(self.cfg.TFStartTime)
    end
    self.timeLabel.text = self:GetUnlockDesc()
  end
  self.levelLabel.text = self.indexInList
  self.finishSymbol:SetActive(isFinish)
  self.greenLine.gameObject:SetActive(achieved)
  self.processFinish:SetActive(achieved)
  self.descLabel.alpha = isFinish and 0.5 or 1
end

function PreviewSaleRoleTaskCell:GetUnlockDesc()
  local startTime = self.data.first[1].config.StartTime or 0
  local offlineSec = startTime - ServerTime.CurServerTime() / 1000
  local mylv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
  local ret = ""
  if 0 < offlineSec then
    ret = self:GetStartTimeFormat(startTime)
    ret = ret .. "解锁"
  elseif mylv < self.data.first[1].config.Level then
    if self.data.first[1].config.Level > GameConfig.System.maxbaselevel then
      ret = ZhString.Warband_Empty_NoSeason
    else
      ret = string.format(ZhString.QuestManual_Level, self.data.first[1].config.Level)
    end
  elseif self.data.first[1].config.MustPreQuest and self.data.first[1].config.MustPreQuest[1] then
    ret = ZhString.QuestManual_NeedToComplete
    local questName = QuestProxy.Instance:GetPreviewSaleRoleTaskName(self.data.first[1].config.MustPreQuest[1])
    if questName then
      ret = ret .. string.format(ZhString.QuestManual_QuestName, questName)
    end
  elseif self.data.first[1].config.PreQuest and self.data.first[1].config.PreQuest[1] then
    ret = ZhString.QuestManual_NeedToComplete
    local questName = QuestProxy.Instance:GetPreviewSaleRoleTaskName(self.data.first[1].config.PreQuest[1])
    if questName then
      ret = ret .. string.format(ZhString.QuestManual_QuestName, questName)
    end
  end
  return ret
end

function PreviewSaleRoleTaskCell:RefreshStatus(data)
end

function PreviewSaleRoleTaskCell:HandleClickReward(cellCtrl)
end

function PreviewSaleRoleTaskCell:CheckIsFinish()
  return self.finishSymbol.activeSelf
end

function PreviewSaleRoleTaskCell:GetStartTimeFormat(startTime)
  local offlineSec = startTime - ServerTime.CurServerTime() / 1000
  local offlineMin = math.floor(offlineSec / 60)
  if 0 <= offlineSec then
    if offlineMin < 1 then
      return ZhString.ClientTimeUtil_OfflineSecondAfter
    elseif offlineMin < 60 then
      return string.format(ZhString.ClientTimeUtil_OfflineMinuteAfter, offlineMin)
    else
      local offlineHour = math.floor(offlineMin / 60)
      if offlineHour < 24 then
        return string.format(ZhString.ClientTimeUtil_OfflineHourAfter, offlineHour)
      else
        local offlineDay = math.floor(offlineHour / 24)
        if offlineDay < 7 then
          return string.format(ZhString.ClientTimeUtil_OfflineDayAfter, offlineDay)
        else
          local offlineWeek = math.floor(offlineDay / 7)
          if offlineWeek < 4 or offlineDay < 30 then
            return string.format(ZhString.ClientTimeUtil_OfflineWeekAfter, offlineWeek)
          else
            local offlineMonth = math.floor(offlineWeek / 4)
            return string.format(ZhString.ClientTimeUtil_OfflineMonthAfter, offlineMonth)
          end
        end
      end
    end
  end
  return ZhString.ClientTimeUtil_OfflineSecondAfter
end

function PreviewSaleRoleTaskCell:CancelChooseReward()
  self:ShowItemTip()
end

function PreviewSaleRoleTaskCell:OnClickCell(cell)
  local callback = function()
    self:CancelChooseReward()
  end
  local stick = cell.gameObject:GetComponent(UIWidget)
  local sdata = {
    itemdata = cell.data,
    funcConfig = {},
    callback = callback,
    ignoreBounds = {
      cell.gameObject
    }
  }
  TipManager.Instance:ShowItemFloatTip(sdata, stick, NGUIUtil.AnchorSide.Left, {-250, 0})
end
