PveGeffenMagicSubView = class("PveGeffenMagicSubView", SubView)
autoImport("AsyncPvpRaidWaveEnemyCell")
autoImport("PveDropItemCell")
autoImport("GeffenMagicWaveCell")
autoImport("PveGeffenMagicSeasonRewardCell")

function PveGeffenMagicSubView:Init(param)
  self:LoadPrefab()
  self:FindObjs()
  self:AddEvt()
  self:InitView()
  self:RefreshView()
end

function PveGeffenMagicSubView:AddEvt()
  self:AddListenEvt(ServiceEvent.SceneUser3GeffenMagicRankQueryCmd, self.HandleUpdateSeasonReward)
  self:AddListenEvt(ServiceEvent.FuBenCmdGeffenMagicEnemyInfoQueryCmd, self.HandleUpdateEnemyInfo)
end

function PveGeffenMagicSubView:HandleUpdateEnemyInfo()
  local maxWave = GeffenMagicWaveScoreProxy.Instance:GetMaxWave()
  if not maxWave then
    return
  end
  local waves = {}
  for i = 1, maxWave do
    TableUtility.ArrayPushBack(waves, i)
  end
  self.waveCtl:ResetDatas(waves)
  self:ChooseWave(1)
  self:UpdateBossList()
end

function PveGeffenMagicSubView:InitView()
  GeffenMagicWaveScoreProxy.Instance:QueryRank()
  GeffenMagicWaveScoreProxy.Instance:QueryEnemyInfo()
end

function PveGeffenMagicSubView:LoadPrefab()
  local obj = self:LoadPreferb_ByFullPath(ResourcePathHelper.UIView("PveGeffenMagicSubView"), self.container.heroRoadViewRoot, true)
  obj.name = "PveGeffenMagicSubView"
  self.gameObject = obj
  self.trans = obj.transform
end

function PveGeffenMagicSubView:FindObjs()
  self:InitSubObj()
end

function PveGeffenMagicSubView:InitSubObj()
  self.bossGrid = self:FindComponent("GeffenMagicBossGrid", UIGrid)
  self.bossCtl = UIGridListCtrl.new(self.bossGrid, AsyncPvpRaidWaveEnemyCell, "AsyncPvpRaidWaveEnemyCell")
  self.seasonRewardGrid = self:FindComponent("SeasonRewardGrid", UIGrid)
  self.seasonRewardCtl = UIGridListCtrl.new(self.seasonRewardGrid, PveGeffenMagicSeasonRewardCell, "PveGeffenMagicSeasonRewardCell")
  self.seasonRewardCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickSeasonRewardCell, self)
  self.rewardCountLab = self:FindComponent("RewardCount", UILabel)
  self.highestScoreLab = self:FindComponent("HighestScore", UILabel)
  self.queryScoreBtn = self:FindGO("QueryScoreBtn")
  self:AddClickEvent(self.queryScoreBtn, function()
    self:OnClickQueryScoreBtn()
  end)
  self.changeToCurSeasonRewardBtn = self:FindGO("ChangeToCurSeasonRewardBtn")
  self:AddClickEvent(self.changeToCurSeasonRewardBtn, function()
    self:OnClickChangeSeasonRewardBtn()
  end)
  self.changeToPreSeasonRewardBtn = self:FindGO("ChangeToPreSeasonRewardBtn")
  self:AddClickEvent(self.changeToPreSeasonRewardBtn, function()
    self:OnClickChangeSeasonRewardBtn()
  end)
  self.seasonRewardTitleLab = self:FindComponent("SeasonRewardTitleLab", UILabel)
  self.seasonRewardTitleLab.text = ZhString.Pve_GeffenMagic_Season_Reward_Title
  self.dropTitle = self:FindComponent("DropTitle", UILabel)
  self.dropTitle.text = ZhString.Pve_GeffenMagic_Drop_Title
  self.dropRewardGrid = self:FindComponent("DropRewardGrid", UIGrid)
  self.dropRewardCtl = UIGridListCtrl.new(self.dropRewardGrid, PveDropItemCell, "PveDropItemCell")
  self.dropRewardCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickReward, self)
  self.leftRewardCountLab = self:FindComponent("LeftRewardCountLab", UILabel)
  self.waveGrid = self:FindComponent("WaveGrid", UIGrid)
  self.waveCtl = UIGridListCtrl.new(self.waveGrid, GeffenMagicWaveCell, "GeffenMagicWaveCell")
  self.waveCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickDiffWave, self)
  self.waveCells = self.waveCtl:GetCells()
  self.publicBtn = self:FindGO("PublishBtn")
  self:AddClickEvent(self.publicBtn, function()
    self.container:OnClickPublishBtn()
  end)
  self.publicTitle = self:FindComponent("Label", UILabel, self.publicBtn)
  self.publicTitle.text = ZhString.Pve_GeffenMagic_Public_Title
  self.matchBtn = self:FindGO("MatchBtn")
  self:AddClickEvent(self.matchBtn, function()
    self.container:OnClickMatchBtn()
  end)
  self.matchTitle = self:FindComponent("Label", UILabel, self.matchBtn)
  self.matchTitle.text = ZhString.Pve_GeffenMagic_Match_Title
  self.challengeBtn = self:FindGO("ChallengeBtn")
  self:AddClickEvent(self.challengeBtn, function()
    self.container:OnClickChallengeBtn()
  end)
  self.challengeTitle = self:FindComponent("Label", UILabel, self.challengeBtn)
  self.challengeTitle.text = ZhString.Pve_GeffenMagic_Challenge_Title
  self.affixBtn = self:FindGO("AffixBtn")
  self:AddClickEvent(self.affixBtn, function(go)
    self:OnClickAffix()
  end)
  self.dropTitleLab = self:FindComponent("DropTitle", UILabel)
  self.dropTitleLab.text = ZhString.Pve_DropReward
  self.redTip = self:FindGO("redTip", self.changeToPreSeasonRewardBtn)
end

local _RedColor = Color(0.8941176470588236, 0.34901960784313724, 0.23921568627450981, 1)
local _NewBlackColor = Color(0.3333333333333333, 0.3568627450980392, 0.43137254901960786, 1)

function PveGeffenMagicSubView:UpdateLeftReward()
  local left = self.container.curData:GetLeftRewardTime(true)
  local max = self.container.curData:GetMaxChallengeCnt(true)
  self.leftRewardCountLab.text = string.format(ZhString.PveView_LeftTime_Common, left, max)
  self.leftRewardCountLab.color = left <= 0 and _RedColor or _NewBlackColor
end

function PveGeffenMagicSubView:OnClickSeasonRewardCell(cell)
  if cell.hasReward then
    ServiceSceneUser3Proxy.Instance:CallGeffenMagicGetRewardUserCmd()
  end
end

function PveGeffenMagicSubView:OnClickAffix()
  self.container:OnClickCheckAffix(GeffenMagicWaveScoreProxy.Instance:GetWeeklyAffixIds())
end

function PveGeffenMagicSubView:RefreshView(_)
  self:UpdateSeasonReward()
  self:UpdateDropList()
  self:UpdateRewardCount()
  self:UpdateHighestScore()
  self:HandleUpdateEnemyInfo()
end

function PveGeffenMagicSubView:UpdateSeasonReward()
  local isShowCurSeasonReward = GeffenMagicWaveScoreProxy.Instance:IsShowCurSeasonReward()
  self.seasonRewardTitleLab.text = isShowCurSeasonReward and ZhString.Pve_GeffenMagic_Season_Reward_Title or ZhString.Pve_GeffenMagic_LastSeason_Reward_Title
  self.changeToPreSeasonRewardBtn:SetActive(isShowCurSeasonReward)
  self.changeToCurSeasonRewardBtn:SetActive(not isShowCurSeasonReward)
  local rankRewards = GeffenMagicWaveScoreProxy.Instance:GetRankReward()
  self.seasonRewardCtl:ResetDatas(rankRewards)
  self.seasonRewardCtl:ResetPosition()
  self.redTip:SetActive(GeffenMagicWaveScoreProxy.Instance:LastSeasonHasReward())
end

function PveGeffenMagicSubView:UpdateDropList()
end

function PveGeffenMagicSubView:UpdateBossList()
  local waveBossMap = GeffenMagicWaveScoreProxy.Instance:GetEnemyInfo(self.curWave)
  self.bossCtl:ResetDatas(waveBossMap)
  self.bossCtl:ResetPosition()
end

function PveGeffenMagicSubView:UpdateRewardCount()
  local all_rewards = self.container:GetAllDrops()
  self.dropRewardCtl:ResetDatas(all_rewards)
end

function PveGeffenMagicSubView:UpdateHighestScore()
  if not GeffenMagicWaveScoreProxy.Instance:IsShowCurSeasonReward() then
    self:Hide(self.highestScoreLab)
    return
  end
  self:Show(self.highestScoreLab)
  local totalScore = GeffenMagicWaveScoreProxy.Instance:GetTotalScore()
  if not totalScore or totalScore <= 0 then
    self.highestScoreLab.text = ZhString.Pve_GeffenMagic_Highest_Score_None
  else
    local rankPercent = GeffenMagicWaveScoreProxy.Instance:GetRankPercent() / 10
    self.highestScoreLab.text = string.format(ZhString.Pve_GeffenMagic_Highest_Score, totalScore, rankPercent)
  end
end

function PveGeffenMagicSubView:OnClickQueryScoreBtn()
  ServiceSceneUser3Proxy.Instance:CallGeffenMagicWaveScoreQueryCmd()
end

function PveGeffenMagicSubView:OnClickReward(cell)
  self.container:OnClickRewardItem(cell)
end

function PveGeffenMagicSubView:OnClickDiffWave(cell)
  self:ChooseWave(cell.data)
  self:UpdateBossList()
end

function PveGeffenMagicSubView:ChooseWave(wave)
  self.curWave = wave
  self:SetChooseWave(self.curWave)
end

function PveGeffenMagicSubView:SetChooseWave(wave)
  for i = 1, #self.waveCells do
    self.waveCells[i]:SetChoosen(wave)
  end
end

function PveGeffenMagicSubView:OnClickChangeSeasonRewardBtn()
  GeffenMagicWaveScoreProxy.Instance:SwitchSeasonReward()
  self:HandleUpdateSeasonReward()
end

function PveGeffenMagicSubView:HandleUpdateSeasonReward()
  self:UpdateHighestScore()
  self:UpdateSeasonReward()
end
