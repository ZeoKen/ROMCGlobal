autoImport("SnakeCoasterManager")
SnakeCoasterResultView = class("SnakeCoasterResultView", BaseView)
SnakeCoasterResultView.ViewType = UIViewType.PopUpLayer
local ScoreRollDuration = 1
local ScoreRollTickID = "scoreRoll"

function SnakeCoasterResultView:Init()
  self.manager = SnakeCoasterManager.Me()
  self:InitData()
  self:FindObjs()
  self:AddEvts()
  self:InitView()
end

function SnakeCoasterResultView:InitData()
  local viewData = self.viewdata.viewdata or _EmptyTable
  self.score = math.max(0, math.floor(tonumber(viewData.score) or 0))
  self.difficulty = viewData.difficulty or self.manager:GetCurrentDifficulty()
  self.isNewRecord = viewData.new_record == true
end

function SnakeCoasterResultView:FindObjs()
  self.exitBtn = self:FindGO("exitBtn")
  self.retryBtn = self:FindGO("retryBtn")
  self.recordPart = self:FindGO("RecordPart")
  self.scoreLabel = self:FindComponent("scoreLabel", UILabel)
end

function SnakeCoasterResultView:AddEvts()
  self:AddClickEvent(self.exitBtn, function()
    self:CloseSelf()
  end)
  self:AddClickEvent(self.retryBtn, function()
    self:OnClickRetry()
  end)
end

function SnakeCoasterResultView:InitView()
  self.recordPart:SetActive(self.isNewRecord)
  self:PlayScoreRoll()
end

function SnakeCoasterResultView:PlayScoreRoll()
  TimeTickManager.Me():ClearTick(self, ScoreRollTickID)
  local from = math.floor(self.score / 2)
  self.scoreLabel.text = tostring(from)
  if from == self.score then
    return
  end
  TimeTickManager.Me():CreateTickFromTo(0, from, self.score, ScoreRollDuration * 1000, function(owner, deltaTime, curValue)
    self.scoreLabel.text = tostring(math.floor(curValue + 0.5))
  end, self, ScoreRollTickID):SetCompleteFunc(function(owner, id)
    self.scoreLabel.text = tostring(self.score)
  end)
end

function SnakeCoasterResultView:OnClickRetry()
  if self.difficulty == nil then
    return
  end
  if (Game.Myself.handInHandAction or 0) ~= 0 then
    MsgManager.ShowMsgByID(856)
    return
  end
  if not self.manager:RequestServerStart(self.difficulty) then
    return
  end
  self:CloseSelf()
end

function SnakeCoasterResultView:OnExit()
  TimeTickManager.Me():ClearTick(self, ScoreRollTickID)
  SnakeCoasterResultView.super.OnExit(self)
end
