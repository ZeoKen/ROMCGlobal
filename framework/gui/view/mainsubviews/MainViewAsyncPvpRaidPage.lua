MainViewAsyncPvpRaidPage = class("MainViewAsyncPvpRaidPage", SubView)

function MainViewAsyncPvpRaidPage:Init(param)
  self:InitView()
  self:FindObjs()
  self:AddListenEvts()
end

function MainViewAsyncPvpRaidPage:InitView()
  local parent = self:FindGO("RaidPageRoot")
  local traceInfoBoard = self:FindGO("TraceInfoBord")
  traceInfoBoard:SetActive(false)
  self:ReLoadPerferb("view/MainViewAsyncPvpRaidPage")
  self.trans:SetParent(parent.transform, false)
  local parentPanel = Game.GameObjectUtil:FindCompInParents(parent, UIPanel)
  if parentPanel then
    local panel = self.gameObject:GetComponent(UIPanel)
    panel.depth = parentPanel.depth + 1
  end
end

function MainViewAsyncPvpRaidPage:FindObjs()
  self.waveLabel = self:FindComponent("Wave", UILabel)
  self.timeLabel = self:FindComponent("Time", UILabel)
  self.timeScoreLabel = self:FindComponent("TimeScore", UILabel)
  self.damageLabel = self:FindComponent("Damage", UILabel)
  self.takeDamageLabel = self:FindComponent("TakeDamage", UILabel)
  self.takeDamageScoreLabel = self:FindComponent("TakeDamageScore", UILabel)
  self.reviveLabel = self:FindComponent("Revive", UILabel)
  self.reviveScoreLabel = self:FindComponent("ReviveScore", UILabel)
  self.ratioLabel = self:FindComponent("Ratio", UILabel)
  local ruleBtn = self:FindGO("RuleBtn")
  self:AddClickEvent(ruleBtn, function()
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.AsyncPvpRaidDiffSetView,
      viewdata = true
    })
  end)
  local statBtn = self:FindGO("StatBtn")
  self:AddClickEvent(statBtn, function()
    ServiceSceneUser3Proxy.Instance:CallGeffenMagicWaveScoreQueryCmd()
  end)
end

function MainViewAsyncPvpRaidPage:AddListenEvts()
  self:AddListenEvt(ServiceEvent.FuBenCmdGeffenMagicStatUpdateCmd, self.HandleGeffenMagicStatUpdate)
  self:AddListenEvt(ServiceEvent.FuBenCmdGeffenMagicWinCmd, self.HandleSyncWaveResult)
end

function MainViewAsyncPvpRaidPage:OnEnter()
  self.timeLabel.text = "--"
  self.timeScoreLabel.text = 0
  self.damageLabel.text = 0
  self.takeDamageLabel.text = 0
  self.takeDamageScoreLabel.text = 0
  self.reviveLabel.text = 0
  self.reviveScoreLabel.text = 0
  self:UpdateScoreRate()
end

function MainViewAsyncPvpRaidPage:RefreshView()
  self:ClearTimeTick()
  local totalWave = GameConfig.GeffenMagic and GameConfig.GeffenMagic.TotalWave or 4
  self.waveLabel.text = string.format(ZhString.AsyncPvpRaid_Wave, AsyncPvpRaidProxy.Instance:GetCurWave(), totalWave)
  local startTime = AsyncPvpRaidProxy.Instance:GetStartTime()
  local isInBattle = AsyncPvpRaidProxy.Instance:IsInBattle()
  if 0 < startTime and isInBattle then
    local timeCount = math.floor(ServerTime.CurServerTime() / 1000 - startTime)
    if timeCount < 0 then
      timeCount = 0
    end
    self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, function()
      self:UpdateTimeStat(timeCount)
      timeCount = timeCount + 1
    end, self)
    self:UpdateStatData()
    self:UpdateScoreRate()
  end
end

function MainViewAsyncPvpRaidPage:UpdateStatData()
  local damageStatData = AsyncPvpRaidProxy.Instance:GetDamageStatData()
  self.damageLabel.text = damageStatData and damageStatData.value or 0
  local takeDamageStatData = AsyncPvpRaidProxy.Instance:GetTakeDamageStatData()
  self.takeDamageLabel.text = takeDamageStatData and takeDamageStatData.value or 0
  self.takeDamageScoreLabel.text = CommonFun.calcGeffenMagicScoreTakeDamage(takeDamageStatData and takeDamageStatData.value or 0)
  local reviveStatData = AsyncPvpRaidProxy.Instance:GetReviveStatData()
  self.reviveLabel.text = reviveStatData and reviveStatData.value or 0
  self.reviveScoreLabel.text = CommonFun.calcGeffenMagicScoreRelive(reviveStatData and reviveStatData.value or 0)
end

function MainViewAsyncPvpRaidPage:UpdateScoreRate()
  local selectedAffixes = AsyncPvpRaidProxy.Instance:GetSelectedAffixes()
  local scoreRate = 1
  for i = 1, #selectedAffixes do
    local id = selectedAffixes[i]
    local config = Table_MonsterAffix[id]
    local type = config and config.Type
    local affixConfig = GameConfig.GeffenMagic and GameConfig.GeffenMagic.Affix and GameConfig.GeffenMagic.Affix[type]
    scoreRate = scoreRate + (affixConfig and affixConfig.ScoreRate or 0)
  end
  local diff = AsyncPvpRaidProxy.Instance:GetDifficulty()
  diff = diff ~= 0 and diff or GameConfig.GeffenMagic.DefaultDifficulty or 4
  local config = GameConfig.GeffenMagic and GameConfig.GeffenMagic.Difficulties and GameConfig.GeffenMagic.Difficulties[diff]
  scoreRate = scoreRate + (config and config.Ratio or 0)
  local scoreRatePercent = NumberUtility.RoundToInt(scoreRate * 100)
  self.ratioLabel.text = string.format("x%d%%", scoreRatePercent)
end

function MainViewAsyncPvpRaidPage:UpdateTimeStat(timeCount)
  local min = math.floor(timeCount / 60)
  local sec = timeCount % 60
  self.timeLabel.text = string.format("%02d:%02d", min, sec)
  self.timeScoreLabel.text = CommonFun.calcGeffenMagicScoreTime(timeCount)
end

function MainViewAsyncPvpRaidPage:HandleGeffenMagicStatUpdate()
  self:UpdateStatData()
  local timeStatData = AsyncPvpRaidProxy.Instance:GetTimeStatData()
  if timeStatData and timeStatData.value > 0 then
    self:UpdateTimeStat(timeStatData.value)
  end
end

function MainViewAsyncPvpRaidPage:HandleSyncWaveResult()
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.AsyncPvpRaidWaveResultPopup
  })
end

function MainViewAsyncPvpRaidPage:ClearTimeTick()
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self)
    self.timeTick = nil
  end
end
