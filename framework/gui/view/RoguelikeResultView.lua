autoImport("RoguelikeResultStatisticsCell")
RoguelikeResultView = class("RoguelikeResultView", BaseView)
RoguelikeResultView.ViewType = UIViewType.NormalLayer
RoguelikeResultView.TimeUp = 60

function RoguelikeResultView:Init()
  self:FindObjs()
  self:InitView()
  self:AddListenEvts()
end

function RoguelikeResultView:FindObjs()
  self.title = self:FindComponent("Title", UILabel)
  self.scoreLabel = self:FindComponent("Score", UILabel)
  self.infoTable = self:FindComponent("InfoTable", UITable)
  self.statisticsGrid = self:FindComponent("StatisticsGrid", UIGrid)
  self.leaveBtn = self:FindGO("LeaveBtn")
  self.leaveBtnLabel = self:FindComponent("Label", UILabel, self.leaveBtn)
  self.screenShotHelper = self.gameObject:GetComponent(ScreenShotHelper)
end

function RoguelikeResultView:InitView()
  self.infoCtrl = UIGridListCtrl.new(self.infoTable, TipLabelCell, "TipLabelCell")
  self.statisticsCtrl = UIGridListCtrl.new(self.statisticsGrid, RoguelikeResultStatisticsCell, "RoguelikeResultStatisticsCell")
  self:AddClickEvent(self.leaveBtn, function()
    ServiceFuBenCmdProxy.Instance:CallExitMapFubenCmd()
    self:CloseSelf()
  end)
  self.timeUp = ServerTime.CurServerTime() + RoguelikeResultView.TimeUp * 1000
  TimeTickManager.Me():CreateTick(0, 300, self.RefreshTime, self)
end

function RoguelikeResultView:AddListenEvts()
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:AddListenEvt(PVEEvent.Roguelike_Shutdown, self.CloseSelf)
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.CloseSelf)
end

function RoguelikeResultView:RefreshTime()
  local period = math.ceil(self.timeUp - ServerTime.CurServerTime())
  if period < 0 then
    TimeTickManager.Me():ClearTick(self)
    ServiceNUserProxy.Instance:ReturnToHomeCity()
    self:CloseSelf()
    return
  end
  self.leaveBtnLabel.text = string.format(ZhString.Roguelike_ResultButtonFormat, math.ceil(period / 1000))
end

local infoLabelConfig = {labwidth = 240}
local makeInfoData = function(strKeySuffix, ...)
  return {
    hideline = true,
    labelConfig = infoLabelConfig,
    label = string.format(ZhString["Roguelike_ResultAttrFormat_" .. strKeySuffix], ...)
  }
end

function RoguelikeResultView:SetInfoDatas(resultData)
  local datas = ReusableTable.CreateArray()
  local add = function(strKeySuffix, ...)
    TableUtility.ArrayPushBack(datas, makeInfoData(strKeySuffix, ...))
  end
  add("ItemCount", resultData.itemCount or 0)
  add("CoinCount", resultData.coinCount or 0)
  add("DeathCount", resultData.deathCount or 0)
  add("BossRoomCount", resultData.passRoomMap[4] or 0)
  add("MechRoomCount", resultData.passRoomMap[5] or 0)
  add("EnemyRoomCount", resultData.passRoomMap[3] or 0)
  add("TarotRoomCount", resultData.passRoomMap[8] or 0)
  add("EventCount", resultData.eventCount or 0)
  add("Time", resultData.time or 0)
  self.infoCtrl:ResetDatas(datas)
  ReusableTable.DestroyAndClearArray(datas)
end

function RoguelikeResultView:OnEnter()
  RoguelikeResultView.super.OnEnter(self)
  local rData = DungeonProxy.Instance.roguelikeResultData
  if not rData then
    LogUtility.Error("Cannot find roguelikeResultData")
    return
  end
  self.title.text = rData.grade > GameConfig.Roguelike.ScoreLayer and string.format(ZhString.Roguelike_ResultTitleFormat, rData.grade + (rData.isAllPassed and 0 or -1)) or ""
  self.scoreLabel.text = string.format(ZhString.Roguelike_ResultScoreFormat, rData.score)
  self:SetInfoDatas(rData)
  self.statisticsCtrl:ResetDatas(rData.statistics[0] and rData.statistics[0].showdataMap)
end

function RoguelikeResultView:OnExit()
  TimeTickManager.Me():ClearTick(self)
  RoguelikeResultView.super.OnExit(self)
end
