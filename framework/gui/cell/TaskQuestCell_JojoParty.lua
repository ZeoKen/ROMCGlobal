autoImport("UIAutoScrollCtrl")
TaskQuestCell_JojoParty = class("TaskQuestCell_JojoParty", BaseCell)
local PrepareStage = FuBenCmd_pb.ESNOW_REALM_PARTY_STAGE_PREPARE
local MonsterStage = FuBenCmd_pb.ESNOW_REALM_PARTY_STAGE_MONSTER
local BossStage = FuBenCmd_pb.ESNOW_REALM_PARTY_STAGE_BOSS
local SuccessStage = FuBenCmd_pb.ESNOW_REALM_PARTY_STAGE_SUCCESS
local FailStage = FuBenCmd_pb.ESNOW_REALM_PARTY_STAGE_FAIL
local StageTips = {
  [PrepareStage] = "Prepare phase",
  [MonsterStage] = "Defeat the monsters",
  [BossStage] = "Defeat the boss",
  [SuccessStage] = "Boss defeated",
  [FailStage] = "Activity failed"
}

function TaskQuestCell_JojoParty:ctor(obj)
  TaskQuestCell_JojoParty.super.ctor(self, obj)
  self:AddGameObjectComp()
end

function TaskQuestCell_JojoParty:Init()
  self:FindObjs()
end

function TaskQuestCell_JojoParty:FindObjs()
  self.titlePanel = self:FindComponent("titleScrol", UIPanel)
  self.stageTipPanel = self:FindComponent("StageTipPanel", UIPanel)
  self.title = self:FindComponent("Title", UILabel)
  self.bossProgress = self:FindComponent("BossProgress", UISlider)
  self.bossHpLabel = self:FindComponent("BossHp", UILabel)
  self.prepareProgressGO = self:FindGO("PrepareProgress")
  self.prepareLabel = self:FindComponent("PrepareLabel", UILabel)
  self.monsterProgressGO = self:FindGO("MonsterProgress")
  self.monsterLabel = self:FindComponent("MonsterLabel", UILabel)
  self.rewardLabel = self:FindComponent("RewardLabel", UILabel)
  self.rewardProgressGO = self:FindGO("RewardProgress")
  self.rewardIcon = self:FindComponent("icon", UISprite, self.rewardProgressGO)
  IconManager:SetUIIcon("miniro_icon_longbaoxiang", self.rewardIcon)
  self.countdownLabel = self:FindComponent("CountdownTime", UILabel)
  self.tipScroll = self:FindComponent("StageTipPanel", UIScrollView)
  self.stageTip = self:FindComponent("StageTip", UILabel)
  self.stageTipCtrl = UIAutoScrollCtrl.new(self.tipScroll, self.stageTip, 8, 40)
end

function TaskQuestCell_JojoParty:SetPanelDepth(parentDepth)
  if not parentDepth then
    return
  end
  if self.titlePanel then
    self.titlePanel.depth = parentDepth + 1
  end
  if self.stageTipPanel then
    self.stageTipPanel.depth = parentDepth + 1
  end
end

function TaskQuestCell_JojoParty:OnEnable()
  TaskQuestCell_JojoParty.super.OnEnable(self)
  self:StartStageTipScroll(true)
end

function TaskQuestCell_JojoParty:OnDisable()
  TaskQuestCell_JojoParty.super.OnDisable(self)
  if self.stageTipCtrl then
    self.stageTipCtrl:Stop(true)
  end
end

function TaskQuestCell_JojoParty:OnDestroy()
  TaskQuestCell_JojoParty.super.OnDestroy(self)
  self:OnExit()
end

function TaskQuestCell_JojoParty:StartStageTipScroll(immediate)
  if not (self.stageTipCtrl and self.stageTip) or StringUtil.IsEmpty(self.stageTip.text) then
    return
  end
  self.stageTipCtrl:Stop(true)
  self.stageTip:ProcessText()
  self.stageTipCtrl:Start(immediate, true, true)
end

function TaskQuestCell_JojoParty:SetData(data)
  local proxy = SnowRealmActivityProxy.Instance
  self.data = data or proxy and proxy:GetActivityInfo() or {}
  local stage = self.data.stage or proxy and proxy:GetStage() or PrepareStage
  self.title.text = GameConfig.SnowRealm and GameConfig.SnowRealm.Party and GameConfig.SnowRealm.Party.PartyName or self.data.title or ""
  self.rewardLabel.text = self.data.is_finish == true and "1/1" or "0/1"
  self.bossProgress.gameObject:SetActive(stage == BossStage or stage == SuccessStage or stage == FailStage)
  self.prepareProgressGO:SetActive(stage == PrepareStage)
  self.monsterProgressGO:SetActive(stage == MonsterStage)
  self:SetStageTip(stage)
  if stage == PrepareStage then
    local maxPlayerNum = proxy and proxy:GetMaxPlayerNum() or self.data.maxPlayerNum or self.data.max_player_num or 0
    local curPlayerNum = proxy and proxy:GetCurPlayerNum() or self.data.curPlayerNum or self.data.cur_player_num or 0
    self.prepareLabel.text = string.format("%d/%d", curPlayerNum, maxPlayerNum)
  elseif stage == MonsterStage then
    local maxMonsterNum = proxy and proxy:GetMaxMonsterNum() or self.data.maxMonsterNum or self.data.max_monster_num or 0
    local killedMonsterNum = proxy and proxy:GetKilledMonsterNum() or self.data.killedMonsterNum or self.data.killed_monster_num or 0
    self.monsterLabel.text = string.format(ZhString.SnowRealm_ActivityMonsterNum, killedMonsterNum, maxMonsterNum)
  elseif stage == BossStage then
    self:UpdateBossHp()
    self.bossProgress.alpha = 1
  elseif stage == SuccessStage then
    self.bossHpLabel.text = "0%"
    self.bossProgress.value = 0
    self.bossProgress.alpha = 0.3
  elseif stage == FailStage then
    self:UpdateBossHp()
    self.bossProgress.alpha = 0.3
  else
    self.bossHpLabel.text = ""
    self.bossProgress.value = 0
    self.bossProgress.alpha = 0.3
  end
  self:SetTimeTick()
end

function TaskQuestCell_JojoParty:UpdateBossHp(bossGuid)
  local proxy = SnowRealmActivityProxy.Instance
  local curBossGuid = proxy and proxy:GetBossGuid() or 0
  if bossGuid and bossGuid ~= curBossGuid then
    return
  end
  local stage = self.data and self.data.stage or proxy and proxy:GetStage()
  local percent = stage == BossStage and 1 or 0
  if curBossGuid and curBossGuid ~= 0 then
    local bossCreature = NSceneNpcProxy.Instance:Find(curBossGuid)
    if bossCreature then
      local props = bossCreature.data.props
      local maxHp = props:GetPropByName("MaxHp"):GetValue()
      if maxHp and 0 < maxHp then
        percent = math.max(0, math.min(1, bossCreature.data:GetHP() / maxHp))
      end
    end
  end
  self.bossHpLabel.text = string.format("%d%%", math.floor(percent * 100))
  self.bossProgress.value = percent
end

function TaskQuestCell_JojoParty:SetStageTip(stage)
  local tip = not self.data or self.data.stageTip or self.data.stage_tip
  if StringUtil.IsEmpty(tip) then
    local config = GameConfig.SnowRealm and GameConfig.SnowRealm.Party
    stage = stage == FailStage and SuccessStage or stage
    tip = config and config.StageDesc and config.StageDesc[stage] or StageTips[stage] or ""
  end
  self.stageTip.text = tip
  if self.gameObject.activeInHierarchy then
    self:StartStageTipScroll(true)
  end
end

function TaskQuestCell_JojoParty:SetTimeTick()
  if self.tick then
    TimeTickManager.Me():ClearTick(self)
    self.tick = nil
  end
  local now = ServerTime.CurServerTime() / 1000
  local proxy = SnowRealmActivityProxy.Instance
  local data = self.data or {}
  self.targetTime = data.targetTime or data.target_time or data.endTime or data.end_time
  if not self.targetTime then
    local remainTime = data.leftTime or data.left_time or data.countdown or data.count_down or data.remainTime or data.remain_time
    if remainTime then
      self.targetTime = now + remainTime
    elseif proxy and proxy.GetTargetTime then
      self.targetTime = proxy:GetTargetTime()
    end
  end
  if not self.targetTime then
    self.countdownLabel.text = ""
    return
  end
  self:UpdateTime()
  self.tick = TimeTickManager.Me():CreateTick(0, 1000, function()
    self:UpdateTime()
  end, self)
end

function TaskQuestCell_JojoParty:UpdateTime()
  if not self.targetTime then
    self.countdownLabel.text = ""
    return
  end
  local remainTime = math.max(0, math.floor(self.targetTime - ServerTime.CurServerTime() / 1000))
  local minutes = math.floor(remainTime / 60)
  local seconds = remainTime % 60
  self.countdownLabel.text = string.format("%d:%02d", minutes, seconds)
  if remainTime <= 0 and self.tick then
    TimeTickManager.Me():ClearTick(self)
    self.tick = nil
  end
end

function TaskQuestCell_JojoParty:OnExit()
  if self.tick then
    TimeTickManager.Me():ClearTick(self)
    self.tick = nil
  end
  if self.stageTipCtrl then
    self.stageTipCtrl:Destroy()
    self.stageTipCtrl = nil
  end
end
