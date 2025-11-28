autoImport("RaidStatisticsView")
RoguelikeStatisticsView = class("RoguelikeStatisticsView", RaidStatisticsView)
RoguelikeStatisticsView.ViewType = UIViewType.NormalLayer

function RoguelikeStatisticsView:AddListenEvts()
  self:AddListenEvt(ServiceEvent.RoguelikeCmdRoguelikeFightInfo, self.HandleRecvQueryInfo)
  self:AddListenEvt(PVEEvent.Roguelike_Shutdown, self.CloseSelf)
end

function RoguelikeStatisticsView:InitView()
  RoguelikeStatisticsView.super.InitView(self)
  self.raidMapTog.gameObject:SetActive(false)
end

function RoguelikeStatisticsView:OnEnter()
  RoguelikeStatisticsView.super.super.OnEnter(self)
  DungeonProxy.RequestRoguelikeStatistics()
end

function RoguelikeStatisticsView:HandleRecvQueryInfo()
  RoguelikeStatisticsView.super.HandleRecvQueryInfo(self)
  local str = DungeonProxy.GetGradeStr(DungeonProxy.Instance.roguelikeRaid.grade)
  self.recordFilterL.value = str
  self.recordFilterR.value = str
end

local recordFilter = {}

function RoguelikeStatisticsView:GetRecordFilter()
  TableUtility.TableClear(recordFilter)
  recordFilter[0] = ZhString.Roguelike_Total
  local raid, statistics = DungeonProxy.Instance.roguelikeRaid, DungeonProxy.Instance.roguelikeStatistics
  if not raid or not statistics then
    return
  end
  for i = raid.grade, raid.grade - 4, -1 do
    if 0 < i and statistics[i] then
      TableUtility.ArrayPushBack(recordFilter, DungeonProxy.GetGradeStr(i))
    end
  end
  return recordFilter
end

function RoguelikeStatisticsView:UpdatePlayerList(gridCtl, filter, recorddata)
  if not recorddata then
    return
  end
  local ins = DungeonProxy.Instance
  local grade
  if recorddata == 0 then
    grade = 0
  else
    grade = ins.roguelikeRaid.grade + 1 - recorddata
  end
  local datas = ins:GetRoguelikeStatistics(grade, filter)
  local weights = ins:GetRoguelikeStatisticsWeight(grade)
  if datas then
    self:SortByFilter(filter, datas)
    for i = 1, #datas do
      datas[i]:SetPercentage(weights, filter)
    end
    gridCtl:ResetDatas(datas)
  end
end
