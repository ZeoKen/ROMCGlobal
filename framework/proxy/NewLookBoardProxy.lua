NewLookBoardProxy = class("NewLookBoardProxy", pm.Proxy)
NewLookBoardProxy.Instance = nil
NewLookBoardProxy.NAME = "NewLookBoardProxy"
NewLookBoardProxy.ShowCardType = {
  Type_CardBack = 1,
  Type_VersionTask = 2,
  Type_DailyTask = 3,
  Type_WeeklyTask = 4
}
NewLookBoardProxy.BaseTaskCard = {
  TaskLinkName = 1,
  SonTaskName = 2,
  SongTaskDesc = 3,
  TaskProgress = 4,
  SonTaskReceiveState = 5,
  Bonus = 6,
  HeadIconNpcName = 7,
  TaskName,
  TaskDesc,
  TraceFrameInfo,
  TaskReceiveState
}
NewLookBoardProxy.FanThreeCardsTable = {
  [1] = {
    id = 1,
    NameZh = "日常任务",
    TextureNameFromPic = "Rewardtask_cardback_blue",
    CardBelong = NewLookBoardProxy.ShowCardType.Type_DailyTask,
    defaultDesc = "剩余时间24:00"
  },
  [2] = {
    id = 2,
    NameZh = "版本任务",
    TextureNameFromPic = "Rewardtask_cardback_red",
    CardBelong = NewLookBoardProxy.ShowCardType.Type_VersionTask,
    defaultDesc = "任务时间无限制"
  },
  [3] = {
    id = 3,
    NameZh = "周长任务",
    TextureNameFromPic = "Rewardtask_cardback_green",
    CardBelong = NewLookBoardProxy.ShowCardType.Type_WeeklyTask,
    defaultDesc = "剩余时间：2天"
  }
}

function NewLookBoardProxy:ctor(proxyName, data)
  self.proxyName = proxyName or NewLookBoardProxy.NAME
  if NewLookBoardProxy.Instance == nil then
    NewLookBoardProxy.Instance = self
  end
  self.CardBackTable = {}
  self.VersionTaskTable = {}
  self.DailyTaskTable = {}
  self.WeeklyTaskTable = {}
  local cell1 = {}
  cell1.cardBackType = NewLookBoardProxy.ShowCardType.Type_VersionTask
  local cell2 = {}
  cell2.cardBackType = NewLookBoardProxy.ShowCardType.Type_DailyTask
  local cell3 = {}
  cell3.cardBackType = NewLookBoardProxy.ShowCardType.Type_WeeklyTask
  table.insert(self.CardBackTable, cell1)
  table.insert(self.CardBackTable, cell2)
  table.insert(self.CardBackTable, cell3)
end

function NewLookBoardProxy:SortTheseCardsToThreeCardStack(cardArray)
  if cardArray == nil then
    return
  end
  self.VersionTaskTable = {}
  self.DailyTaskTable = {}
  self.WeeklyTaskTable = {}
  for k, v in pairs(cardArray) do
    if v and v.staticData and v.staticData.Type then
      if v.staticData.Type == "version" then
        table.insert(self.VersionTaskTable, v)
      elseif v.staticData.Type == "wanted_day" then
        table.insert(self.DailyTaskTable, v)
      elseif v.staticData.Type == "wanted_week" then
        table.insert(self.WeeklyTaskTable, v)
      end
    else
      helplog("v == nil ")
    end
  end
  helplog("#self.VersionTaskTable:" .. #self.VersionTaskTable)
  helplog("#self.DailyTaskTable:" .. #self.DailyTaskTable)
  helplog("#self.WeeklyTaskTable:" .. #self.WeeklyTaskTable)
end

function NewLookBoardProxy:GetCardTableByCardType(cardType)
  if cardType == NewLookBoardProxy.ShowCardType.Type_CardBack then
    return self.CardBackTable or {}
  elseif cardType == NewLookBoardProxy.ShowCardType.Type_VersionTask then
    return self.VersionTaskTable or {}
  elseif cardType == NewLookBoardProxy.ShowCardType.Type_DailyTask then
    return self.DailyTaskTable or {}
  elseif cardType == NewLookBoardProxy.ShowCardType.Type_WeeklyTask then
    return self.WeeklyTaskTable or {}
  else
    helplog("no what you what check code")
    return {}
  end
end

function NewLookBoardProxy:ReturnBool()
  if self.TypeBool then
    return self.TypeBool
  end
end

function NewLookBoardProxy:IsSelfDebug()
  return self.bOpenNewPanel or false
end

function NewLookBoardProxy:SetOpenNewPanel(b)
  self.bOpenNewPanel = b
end

function NewLookBoardProxy:SetCurrentShowCardType(cardType)
  self.currentShowCardType = cardType or NewLookBoardProxy.ShowCardType.Type_CardBack
end

function NewLookBoardProxy:GetCurrentShowCardType()
  return self.currentShowCardType or NewLookBoardProxy.ShowCardType.Type_CardBack
end

function NewLookBoardProxy:SetCurrentBool(bool)
  self.TypeBool = bool or true
end

function NewLookBoardProxy:GetCurrentBool()
  return self.TypeBool
end

function NewLookBoardProxy:SetBtnCartType(cardType)
  self.currentCardType = cardType
end

function NewLookBoardProxy:GetBtnCartType()
  return self.currentCardType
end

return NewLookBoardProxy
