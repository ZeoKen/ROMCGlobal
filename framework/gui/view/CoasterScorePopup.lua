CoasterScorePopup = class("CoasterScorePopup", BaseView)
CoasterScorePopup.ViewType = UIViewType.PopUpLayer

function CoasterScorePopup:Init()
  self.score = 0
  self.displayScore = 0
  self.coasterID = 9999
  self.scoreLabel = self:FindComponent("LabelScore", UILabel)
  self.tweenScale = self.scoreLabel.gameObject:GetComponent(TweenScale)
  self.scoreLabel.transform.localScale = Vector3.one
  self:AddListenEvt(SnakeCoasterEvent.ScoreUpdate, self.HandleScoreUpdate)
  self:AddListenEvt(SnakeCoasterEvent.EndCoaster, self.HandleEndCoaster)
end

function CoasterScorePopup:OnEnter()
  CoasterScorePopup.super.OnEnter(self)
  local viewdata = self.viewdata and (self.viewdata.viewdata or self.viewdata) or nil
  self.coasterID = viewdata and viewdata.coasterID or 9999
  local coasterMove = Game.Myself.snakeCoasterMove
  local score = viewdata and viewdata.score
  if score == nil and coasterMove ~= nil then
    score = coasterMove:GetScore()
  end
  self:SetScore(score or 0, true)
end

function CoasterScorePopup:OnExit()
  TimeTickManager.Me():ClearTick(self, "scoreRoll")
  CoasterScorePopup.super.OnExit(self)
end

function CoasterScorePopup:OnDestroy()
  TimeTickManager.Me():ClearTick(self, "scoreRoll")
  self.scoreLabel = nil
  self.coasterID = nil
  self.score = 0
  self.displayScore = 0
end

function CoasterScorePopup:HandleScoreUpdate(note)
  local data = note and note.body
  if data == nil then
    return
  end
  if data.coasterID ~= nil and data.coasterID ~= self.coasterID then
    return
  end
  self:SetScore(data.score)
end

function CoasterScorePopup:SetScore(score, immediate)
  if score == self.score and not immediate then
    return
  end
  self.score = math.max(0, math.floor(tonumber(score) or 0))
  if immediate then
    TimeTickManager.Me():ClearTick(self, "scoreRoll")
    self.displayScore = self.score
    self:RefreshScore()
  else
    self.tweenScale:ResetToBeginning()
    self.tweenScale:PlayForward()
    self:RollScoreTo(self.score, 0.5)
  end
end

function CoasterScorePopup:RefreshScore()
  if self.scoreLabel ~= nil then
    self.scoreLabel.text = tostring(self.displayScore or 0)
  end
end

function CoasterScorePopup:RollScoreTo(to, duration)
  to = math.max(0, math.floor(tonumber(to) or 0))
  duration = duration or 1
  local from = self.displayScore or 0
  if from == to then
    TimeTickManager.Me():ClearTick(self, "scoreRoll")
    self.displayScore = to
    self:RefreshScore()
    return
  end
  if duration <= 0 then
    TimeTickManager.Me():ClearTick(self, "scoreRoll")
    self.displayScore = to
    self:RefreshScore()
    self:OnScoreRollArrive()
    return
  end
  TimeTickManager.Me():CreateTickFromTo(0, from, to, duration * 1000, function(owner, deltaTime, curValue)
    self.displayScore = math.floor(curValue + 0.5)
    self:RefreshScore()
  end, self, "scoreRoll"):SetCompleteFunc(function(owner, id)
    self.displayScore = to
    self:RefreshScore()
    self:OnScoreRollArrive()
  end)
end

function CoasterScorePopup:OnScoreRollArrive()
end

function CoasterScorePopup:HandleEndCoaster(note)
  self:CloseSelf()
end
