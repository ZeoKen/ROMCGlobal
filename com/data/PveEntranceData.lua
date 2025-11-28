local daySeconds = 86400
local _DifficultyDescType_Roman = 9
PveEntranceData = class("PveEntranceData")

function PveEntranceData:ctor(id)
  self.id = id
  self.staticData = Table_PveRaidEntrance[id]
  if nil == self.staticData then
    redlog("Table_PveRaidEntrance 未配置id： ", id)
  end
  self.raidType = self.staticData.RaidType
  self.feature = GameConfig.Pve.RaidFeatureDesc and GameConfig.Pve.RaidFeatureDesc[self.raidType] or ""
  self.lv = self.staticData.RecommendLv
  self.name = self.staticData.Name
  if self:HasShopConfig() then
    self.shopid, self.shoptype = self.staticData.Shop.shopid, self.staticData.Shop.type
  end
  self.staticDifficultyDescType = self.staticData.DifficultyName[1]
  self.staticDifficulty = self.staticData.DifficultyName[2]
  if nil ~= Game.difficultyRaidMap[self.raidType] then
    self.difficultyIgoreType = self.staticDifficulty % 10000
    self.difficultyType = math.floor(self.staticDifficulty / 10000)
  end
  if self:IsRugelike() then
    self.difficultyType = self:IsHardMode() and Pve_Difficulty_Type.Normal or Pve_Difficulty_Type.Difficult
  end
  self.unlockMsgId = self.staticData.UnlockMsgId
  self.groupid = self.staticData.GroupId
  if nil == GameConfig.Pve.RaidType[self.groupid] then
    redlog("GameConfig未配置groupid: ", self.groupid)
  end
  self.configSortID = GameConfig.Pve.RaidType[self.groupid] and GameConfig.Pve.RaidType[self.groupid].sortID
  self.UnlockLv = self.staticData.UnlockLv
  if nil == self.configSortID then
    redlog("策划未配置GameConfig.Pve.RaidType 对应的sortID。错误GroupId | ID : ", self.groupid, self.id)
    self.configSortID = 1
  end
  self.difficultyRaid = self.staticData.Difficulty
  if self:IsCrack() then
    if GameConfig.CrackRaidReward and GameConfig.CrackRaidReward.RaidInfos and GameConfig.CrackRaidReward.RaidInfos[self.difficultyRaid] then
      self.crackRaidRewardRecommendLv = GameConfig.CrackRaidReward.RaidInfos[self.difficultyRaid].recommendLv
    end
    if not self.crackRaidRewardRecommendLv then
      redlog("PveEntranceData | 检查配置 GameConfig.CrackRaidReward.RaidInfos Difficulty:", self.difficultyRaid)
    end
  end
  self.showKillBoss = self.staticData.ShowKillBoss
  self:setMatchId()
end

function PveEntranceData:HasSweepReward()
  if nil == self.hasSweepReward then
    self.hasSweepReward = false
    local reward_config = self.staticData and self.staticData.ClientRewards
    if reward_config then
      for i = 1, #reward_config do
        if reward_config[i].type == PveDropItemData.Type.E_Pve_Sweep then
          self.hasSweepReward = true
          break
        end
      end
    end
  end
  return self.hasSweepReward
end

function PveEntranceData:IsLeftRewardType()
  return self.staticData.ChallengeContent == 2
end

function PveEntranceData:IsHardMode()
  return self.difficultyType == Pve_Difficulty_Type.Difficult
end

function PveEntranceData:HasShopConfig()
  local staticData = self.staticData
  if staticData and staticData.Shop and nil ~= next(staticData.Shop) then
    return true
  end
  return false
end

function PveEntranceData:setMatchId()
  if not self.staticData then
    return
  end
  local goalId = self.staticData.Goal
  if not goalId then
    return
  end
  if not Table_TeamGoals[goalId] then
    return
  end
  local matchRaidId = Table_TeamGoals[goalId].RaidType
  if not matchRaidId then
    return
  end
  if not Table_MatchRaid[matchRaidId] then
    return
  end
  self.matchRaidId = Table_MatchRaid[matchRaidId].RaidConfigID
end

function PveEntranceData:GetMatchRaidId()
  return self.matchRaidId
end

function PveEntranceData:IsPveCard()
  return self.raidType == PveRaidType.PveCard
end

function PveEntranceData:IsThanatos()
  return self.raidType == PveRaidType.Thanatos
end

function PveEntranceData:IsHeadWear()
  return self.raidType == PveRaidType.Headwear
end

function PveEntranceData:IsCrack()
  return self.raidType == PveRaidType.Crack
end

function PveEntranceData:IsBoss()
  return self.raidType == PveRaidType.Boss
end

function PveEntranceData:IsInfiniteTower()
  return self.raidType == PveRaidType.InfiniteTower
end

function PveEntranceData:IsElement()
  return self.raidType == PveRaidType.Element
end

function PveEntranceData:IsStarArk()
  return self.raidType == PveRaidType.StarArk
end

function PveEntranceData:IsRugelike()
  return self.raidType == PveRaidType.Rugelike
end

function PveEntranceData:IsRoadOfHero()
  return self.raidType == PveRaidType.RoadOfHero
end

function PveEntranceData:IsMemoryRaid()
  return self.raidType == PveRaidType.MemoryRaid
end

function PveEntranceData:IsNew()
  local openTime = self.groupid and GameConfig.Pve.RaidType[self.groupid] and GameConfig.Pve.RaidType[self.groupid].openTime
  if not openTime then
    return false
  end
  if not StringUtil.IsEmpty(openTime) then
    local dateTime = ClientTimeUtil.GetOSDateTime(openTime)
    local curServerTime = ServerTime.CurServerTime() / 1000
    local delta = curServerTime - dateTime
    if 0 < delta and delta < GameConfig.Pve.NewRaidInterval * daySeconds then
      return true
    end
  end
  return false
end

function PveEntranceData:IsRaidCombined()
  local status = PveEntranceProxy.Instance:GetRaidCombinedStatus(self.id)
  return status ~= ServerMergeStatus.None
end

function PveEntranceData:GetDifficultyDesc()
  if self.staticDifficultyDescType == _DifficultyDescType_Roman then
    return StringUtil.IntToRoman(self.difficultyIgoreType)
  else
    return GameConfig.Pve.Difficulty[self.staticDifficultyDescType][self.staticDifficulty]
  end
end

function PveEntranceData:IsNormalMaterials()
  return self.raidType == PveRaidType.NormalMaterials
end

function PveEntranceData:IsAstral()
  return self.raidType == PveRaidType.Astral
end

function PveEntranceData:IsSpaceTimeIllusion()
  return self.raidType == PveRaidType.SpaceTimeIllusion
end
