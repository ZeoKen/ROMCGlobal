MainViewFairyTaleRaidPage = class("MainViewFairyTaleRaidPage", SubView)
local NormalColor = Color(0.5686274509803921, 0.7803921568627451, 1, 1)
local InfiniteColor = Color(0.996078431372549, 0.9725490196078431, 0.6274509803921569, 1)

function MainViewFairyTaleRaidPage:Init(param)
  self:InitView()
  self:FindObjs()
  self:AddListenEvts()
end

function MainViewFairyTaleRaidPage:InitView()
  local parent = self:FindGO("FairyTaleRaidPageRoot")
  self:ReLoadPerferb("view/MainViewFairyTaleRaidPage")
  self.trans:SetParent(parent.transform, false)
  local parentPanel = Game.GameObjectUtil:FindCompInParents(parent, UIPanel)
  if parentPanel then
    local panel = self.gameObject:GetComponent(UIPanel)
    panel.depth = parentPanel.depth + 1
  end
end

function MainViewFairyTaleRaidPage:FindObjs()
  self.title = self:FindComponent("Title", UILabel)
  self.progressLabel = self:FindComponent("ProgressNum", UILabel)
  self.monsterIcon = self:FindComponent("MonsterIcon", UISprite)
  self.progressBar = self:FindComponent("ProgressBar", UIProgressBar)
  self.countdownLabel = self:FindComponent("Countdown", UILabel)
  self.resetProgressLabel = self:FindComponent("ResetProgress", UILabel)
  local statBtn = self:FindGO("StatBtn")
  self:AddClickEvent(statBtn, function()
    self:OnStatBtnClick()
  end)
  self.inBattle = self:FindGO("InBattle")
  self.inPrepare = self:FindGO("InPrepare")
  self.bg = self:FindComponent("Bg", UISprite)
  self.prepareLabel = self:FindComponent("PrepareLabel", UILabel)
  local npcConfig = Table_Npc[852000]
  self.prepareLabel.text = string.format(ZhString.FairyTaleRaid_GotoNpcStart, npcConfig and npcConfig.NameZh or "")
end

function MainViewFairyTaleRaidPage:AddListenEvts()
  self:AddListenEvt(ServiceEvent.FuBenCmdFairyTaleRaidSyncCmd, self.HandleSyncRaidData)
end

function MainViewFairyTaleRaidPage:OnEnter()
  self:SetTitle()
  self:SetPanelState(false)
end

function MainViewFairyTaleRaidPage:OnExit()
  self:ClearTick()
end

function MainViewFairyTaleRaidPage:HandleSyncRaidData(note)
  redlog("MainViewFairyTaleRaidPage:HandleSyncRaidData")
  local data = note and note.body
  self:RefreshView(data)
end

function MainViewFairyTaleRaidPage:RefreshView(data)
  local raidId = Game.MapManager:GetRaidID()
  local raidMisc = GameConfig.FairyTaleRaid and GameConfig.FairyTaleRaid.RaidMisc
  raidMisc = raidMisc and raidMisc[raidId]
  local totalTrainNum = GameConfig.FairyTaleRaid and GameConfig.FairyTaleRaid.RoundTrainNum or 0
  local curTrainNum = data and data.train_arrival_count or 0
  local nextWaveMonsterType = data and data.next_wave_type or 0
  local nextWaveTime = data and data.next_wave_time or 0
  local totalDamageCount = raidMisc and raidMisc.FailTrainCount or 0
  local curDamageCount = data and data.train_damaged_count or 0
  local round = raidMisc and raidMisc.Round or 0
  local isInfinite = round == 0
  local progressStr = raidMisc and raidMisc.EscortProgressStr or ZhString.FairyTaleRaid_EscortProgress
  if isInfinite then
    self.progressLabel.text = string.format(progressStr, curTrainNum)
  else
    self.progressLabel.text = string.format(progressStr, curTrainNum, totalTrainNum)
  end
  self.monsterIcon.gameObject:SetActive(1 < nextWaveMonsterType)
  self.monsterIcon.spriteName = nextWaveMonsterType == FuBenCmd_pb.EFAIRYTALEWAVETYPE_MVP and "map_mvpboss" or "map_miniboss"
  self:UpdateCountdown(nextWaveTime)
  local resetProgressStr = raidMisc and raidMisc.FailProgressStr or ZhString.FairyTaleRaid_FailProgress
  self.resetProgressLabel.text = string.format(resetProgressStr, curDamageCount, totalDamageCount)
  self:SetPanelState(0 < nextWaveTime)
end

function MainViewFairyTaleRaidPage:SetTitle()
  local raidId = Game.MapManager:GetRaidID()
  local raidMisc = GameConfig.FairyTaleRaid and GameConfig.FairyTaleRaid.RaidMisc
  raidMisc = raidMisc and raidMisc[raidId]
  local round = raidMisc and raidMisc.Round or 0
  local isInfinite = round == 0
  local mapRaidConfig = Table_MapRaid[raidId]
  local raidName = mapRaidConfig and mapRaidConfig.NameZh or ""
  self.title.text = string.format(ZhString.FairyTaleRaid_Title, raidName, isInfinite and ZhString.FairyTaleRaid_InfiniteDifficulty or ZhString.FairyTaleRaid_NormalDifficulty)
  self.title.color = isInfinite and InfiniteColor or NormalColor
end

function MainViewFairyTaleRaidPage:UpdateCountdown(nextTime)
  local remainTime = math.max(0, math.floor(nextTime - ServerTime.CurServerTime() / 1000))
  self:ClearTick()
  local interval = GameConfig.FairyTaleRaid and GameConfig.FairyTaleRaid.TrainInterval or 5
  local totalValue = math.max(interval, remainTime)
  self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, function()
    self.countdownLabel.text = remainTime
    self.progressBar.value = 0 < totalValue and remainTime / totalValue or 0
    remainTime = remainTime - 1
    if remainTime < 0 then
      self:ClearTick()
    end
  end, self)
end

function MainViewFairyTaleRaidPage:ClearTick()
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self)
    self.timeTick = nil
  end
end

function MainViewFairyTaleRaidPage:OnStatBtnClick()
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.FairyTaleStaticsView
  })
end

function MainViewFairyTaleRaidPage:SetPanelState(inBattle)
  self.inBattle:SetActive(inBattle)
  self.inPrepare:SetActive(not inBattle)
  local bgHeight = inBattle and 252 or 139
  self.bg.height = bgHeight
end
