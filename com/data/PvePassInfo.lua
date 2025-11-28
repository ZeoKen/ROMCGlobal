autoImport("PveEntranceData")
autoImport("PveBossInfo")
autoImport("PveServerRewardData")
autoImport("WildMvpAffixData")
local _ArrayClear = TableUtility.ArrayClear
local _TableClear = TableUtility.TableClear
local _ArrayPushBack = TableUtility.ArrayPushBack
local _InsertArray = TableUtil.InsertArray
local _serverMonsterDirty = true
local SpeedUpConfig = GameConfig.SpeedUp
local MVPCostTime = GameConfig.BossScene and GameConfig.BossScene.MVPTimeCost or 3600
local MiniCostTime = GameConfig.BossScene and GameConfig.BossScene.MiniTimeCost or 1800
local _IsMvp = function(id)
  if Table_Monster[id] then
    return Table_Monster[id].Type == "MVP"
  end
  redlog("未配置MonsterID :", id)
  return false
end
local special_icon_bg
local _GetSpecialIconBg = function(id)
  if not special_icon_bg then
    special_icon_bg = GameConfig.Pve and GameConfig.Pve.special_icon_bg
  end
  if special_icon_bg then
    return special_icon_bg[id]
  end
  return nil
end
PvePassInfo = class("PvePassInfo")

function PvePassInfo:ctor(id)
  self.id = id
  self.isFirstPass = false
  self.norlenfirst = false
  self.pass = false
  self.open = false
  self.quick = false
  self.pickup = false
  self.passtime = 0
  self.rewardDirty = true
  self.serverMonsters = {}
  self.monsterList = {}
  self.serverRewards = {}
  self.staticRewardList = {}
  self.allRewards = {}
  self.commonFunReward = {}
  self.staticEntranceData = PveEntranceData.new(self.id)
  self.isBoss = self.staticEntranceData:IsBoss()
  self.mvp_rest_time = 0
  self.mini_rest_time = 0
  self.reset_time = 0
  self.kill_boss_num = 0
  self.activeAffixs = {}
  self:initBoss()
  self:InitRewardCheckFunc()
  self:_resetRewards()
end

function PvePassInfo:InitRewardCheckFunc()
  self.rewardCheckFunc = {}
  self.rewardCheckFunc[PveDropItemData.Type.E_First] = self.checkType_3
  self.rewardCheckFunc[PveDropItemData.Type.E_Pve] = self.checkType_9
  self.rewardCheckFunc[PveDropItemData.Type.E_Pve_Card] = self.checkType_10
  self.rewardCheckFunc[PveDropItemData.Type.E_Pve_Card_NoFirst] = self.checkType_11
  self.rewardCheckFunc[PveDropItemData.Type.E_Pve_Sweep] = self.checkType_12
  self.rewardCheckFunc[PveDropItemData.Type.E_Pve_ThreeStars] = self.checkType_13
  self.rewardCheckFunc[PveDropItemData.Type.E_WeekFirstPass] = self.checkType_14
end

function PvePassInfo:RealFirstPass()
  if self.staticEntranceData:IsPveCard() then
    isFirstPass = self.norlenfirst
  else
    isFirstPass = self.isFirstPass
  end
  return isFirstPass == true
end

function PvePassInfo:checkType_3()
  return not self:RealFirstPass() or self.staticEntranceData:IsAstral()
end

function PvePassInfo:checkType_11()
  return self:RealFirstPass()
end

function PvePassInfo:checkType_12()
  return self.quick == true
end

function PvePassInfo:checkType_9()
  return not self:IsPickup()
end

function PvePassInfo:checkType_14()
  return not self:IsPickup()
end

function PvePassInfo:checkType_10()
  return self:IsPickup()
end

function PvePassInfo:checkType_13()
  local achievements = self.staticEntranceData.staticData.ShowAchievement
  return not self.heroRoadStars or #self.heroRoadStars < #achievements
end

function PvePassInfo:CheckRewardValid(type)
  local func = self.rewardCheckFunc[type]
  if func then
    return func(self)
  end
  return true
end

function PvePassInfo:GetMatchRaidId()
  return self.staticEntranceData:GetMatchRaidId()
end

function PvePassInfo:initBoss()
  if not self.isBoss then
    return
  end
  self.bossIdMap = {}
  self.bossIdMap[Pve_Difficulty_Type.Normal] = {}
  self.bossIdMap[Pve_Difficulty_Type.Difficult] = {}
  self.bossInfoMap = {}
end

function PvePassInfo:_resetBossId()
  for _, ids in pairs(self.bossIdMap) do
    _ArrayClear(ids)
  end
end

function PvePassInfo:HasRedTip()
  local _redProxy = RedTipProxy.Instance
  local groupid = self.staticEntranceData.groupid
  return _redProxy:IsNew(SceneTip_pb.EREDSYS_PVERAID_ENTRANCE, groupid) or _redProxy:IsNew(SceneTip_pb.EREDSYS_PVERAID_ACHIEVE, groupid)
end

function PvePassInfo:SetServerData(serverdata)
  if nil ~= serverdata.firstpass then
    self.isFirstPass = serverdata.firstpass
  end
  if serverdata.passtime then
    self.passtime = serverdata.passtime
  end
  if nil ~= serverdata.open then
    self.open = serverdata.open
  end
  if serverdata.quick ~= nil then
    self.quick = serverdata.quick
  end
  if nil ~= serverdata.pickup then
    self.pickup = serverdata.pickup
  end
  if nil ~= serverdata.norlenfirst then
    self.norlenfirst = serverdata.norlenfirst
  end
  if nil ~= serverdata.pass then
    self.pass = serverdata.pass
  end
  if serverdata.acc_pass ~= nil then
    self.acc_pass = serverdata.acc_pass
  end
  if nil ~= serverdata.grade then
    self.grade = serverdata.grade
  end
  if nil ~= serverdata.reset_time then
    self.reset_time = serverdata.reset_time
  end
  if nil ~= serverdata.kill_boss_num then
    self.kill_boss_num = serverdata.kill_boss_num
  end
  if nil ~= serverdata.free then
    self.is_free = serverdata.free
  end
  if serverdata.stars then
    if not self.heroRoadStars then
      self.heroRoadStars = {}
    end
    for i = 1, #serverdata.stars do
      self.heroRoadStars[i] = serverdata.stars[i]
    end
  end
  if serverdata.astral_pray_group then
    self.astral_pray_group = serverdata.astral_pray_group
  end
  if serverdata.astral_pray_id then
    self.astral_pray_id = serverdata.astral_pray_id
  end
  self:_resetRewards()
  self:_resetCommonFunRewards()
  self:_resetServerMonsters(serverdata.showbossids)
  self:_resetServerRewards(serverdata.showrewards)
  self:_resetBossInfo(serverdata.bossinfo)
  self.mvp_rest_time = serverdata.mvp_rest_time or 0
  self.mini_rest_time = serverdata.mini_rest_time or 0
  self:RecordDisplay(serverdata.no_show_label, serverdata.act_end_time)
  self:SetAffixId(serverdata.affixids)
end

function PvePassInfo:SetAffixId(affixids)
  if not affixids then
    return
  end
  _ArrayClear(self.activeAffixs)
  local _Table_MonsterAffix = Table_MonsterAffix
  for i = 1, #affixids do
    local config = _Table_MonsterAffix[affixids[i]]
    if config then
      _ArrayPushBack(self.activeAffixs, WildMvpAffixData.new(config))
    end
  end
end

function PvePassInfo:GetActiveAffix()
  return self.activeAffixs
end

function PvePassInfo:GetDetailActiveAffix()
  if self.staticEntranceData:IsStarArk() then
    return WildMvpProxy.Instance:GetPveAffixDatas()
  end
  return WildMvpProxy.Instance:GetPveAffixDatas2()
end

function PvePassInfo:RecordDisplay(no_show, act_end_time)
  self.no_show = no_show
  self.act_end_time = act_end_time
  if self.id == 100 then
    redlog("RecordDisplay self.no_show", self.no_show, self.act_end_time)
  end
end

function PvePassInfo:GetActivityEndTime()
  return self.act_end_time
end

function PvePassInfo:CheckActivityValid()
  return self.no_show == false and self.act_end_time > ServerTime.CurServerTime() / 1000
end

function PvePassInfo:Forbidden()
  if self.no_show then
    return true
  elseif self.act_end_time and self.act_end_time ~= 0 then
    return self.act_end_time < ServerTime.CurServerTime() / 1000
  end
  return false
end

function PvePassInfo:GetLeftRewardTime(ignore_sweep)
  if self.isBoss then
    local id = FunctionPve.Me().viewBossId
    if id then
      if _IsMvp(id) then
        return self.mvp_rest_time
      else
        return self.mini_rest_time
      end
    end
    return 0
  else
    return math.max(0, self:GetMaxChallengeCnt(ignore_sweep) - self:GetPassTime(ignore_sweep))
  end
end

function PvePassInfo:GetConfigMaxChallengeCount()
  if not self.configMaxChallengeCnt then
    self.configMaxChallengeCnt = self.staticEntranceData.staticData.ChallengeCount
  end
  return self.configMaxChallengeCnt
end

function PvePassInfo:GetMaxChallengeCnt(ignore_sweep)
  if self.isBoss then
    local id = FunctionPve.Me().viewBossId
    if id then
      if _IsMvp(id) then
        return GameConfig.BossScene and GameConfig.BossScene.MVPWeeklyRewardLimit or 5
      else
        return GameConfig.BossScene and GameConfig.BossScene.MiniWeeklyRewardLimit or 10
      end
    end
    return 0
  else
    local static_challenge_count = self:GetConfigMaxChallengeCount()
    if self:HasSweepReward() then
      if self.quick and not ignore_sweep then
        return static_challenge_count - 1
      else
        return 1
      end
    else
      return static_challenge_count
    end
  end
end

function PvePassInfo:HasSweepReward()
  return self.staticEntranceData:HasSweepReward()
end

function PvePassInfo:CheckSweepShow()
  if self.staticEntranceData.staticData.ShowSweep == 0 then
    return false
  end
  local is_open = PveEntranceProxy.Instance:IsOpen(self.id)
  if not is_open then
    return false
  end
  if self:HasSweepReward() then
    is_open = self:GetQuick() or self:GetLeftRewardTime() == 0
  end
  return is_open
end

function PvePassInfo:CheckPublishShow()
  if self.staticEntranceData:IsHeadWear() then
    return false
  end
  local goal = self.staticEntranceData.staticData.Goal
  if not goal or goal <= 0 then
    return false
  end
  if self:HasSweepReward() then
    if self:GetQuick() then
      return false
    end
    if self:GetLeftRewardTime() == 0 then
      return false
    end
  end
  return true
end

function PvePassInfo:CheckExtraSweepShow()
  if self:HasSweepReward() then
    return self:GetQuick() or self:GetLeftRewardTime() == 0
  end
  return false
end

function PvePassInfo:_resetCommonFunRewards()
  local raidType = self.staticEntranceData.raidType
  local checkConfig = GameConfig.Pve.SpecialExpCalcType
  if not (checkConfig and raidType) or not checkConfig[raidType] then
    return
  end
  local roleLv, maxlv, difficulty, baseSpeedUpRatio, jobSpeedUpRatio, expRatio
  roleLv = MyselfProxy.Instance:RoleLevel()
  if roleLv <= 0 then
    return
  end
  self.rewardDirty = true
  _ArrayClear(self.commonFunReward)
  maxlv = self.staticEntranceData.crackRaidRewardRecommendLv or roleLv
  difficulty = self.staticEntranceData.staticData.Difficulty
  local MaterialRaidConfig = GameConfig.CommonMaterialsRaid and GameConfig.CommonMaterialsRaid.RewardInfos
  if raidType == PveRaidType.NormalMaterials and MaterialRaidConfig then
    maxlv = MaterialRaidConfig[difficulty].recommendLv
    difficulty = MaterialRaidConfig[difficulty].difficulty
  end
  expRatio = 1
  if SpeedUpConfig and SpeedUpConfig.BaseTimeCost then
    expRatio = self:GetStaticCostTime() / SpeedUpConfig.BaseTimeCost
  end
  local base_speedup = SpeedUpConfig and SpeedUpConfig.where_to_methods.base[3]
  baseSpeedUpRatio = 100
  baseSpeedUpRatio = baseSpeedUpRatio * 0.01
  local BaseExpNum = CommonFun.CalcRiftBaseExp(roleLv, maxlv, difficulty, baseSpeedUpRatio, expRatio, raidType)
  if BaseExpNum and 0 < BaseExpNum then
    local baseExp = PveDropItemData.new("PveDropReward", 300)
    baseExp.num = BaseExpNum
    baseExp:SetType(PveDropItemData.Type.E_Normal)
    _ArrayPushBack(self.commonFunReward, baseExp)
  end
  local job_speedup = SpeedUpConfig and SpeedUpConfig.where_to_methods.job[3]
  local jobSpeedUpRatio = 100
  jobSpeedUpRatio = jobSpeedUpRatio * 0.01
  local JobExpNum = CommonFun.CalcRiftJobExp(roleLv, maxlv, difficulty, jobSpeedUpRatio, expRatio, raidType)
  if JobExpNum and 1 < JobExpNum then
    local jobExp = PveDropItemData.new("PveDropReward", 400)
    jobExp.num = JobExpNum
    jobExp:SetType(PveDropItemData.Type.E_Normal)
    _ArrayPushBack(self.commonFunReward, jobExp)
  end
end

local rewardTeamids, reward_type, rewards, itemRewardType, valid, rate

function PvePassInfo:_resetRewards()
  local isFirstPass
  if self.staticEntranceData:IsPveCard() then
    isFirstPass = self.norlenfirst
  else
    isFirstPass = self.isFirstPass
  end
  local isQuick = self:GetQuick()
  local pickUp = self:IsPickup()
  local heroRoadStarCount = self:GetHeroRoadStarCount()
  local isAstral = self.staticEntranceData:IsAstral()
  if self.cacheQuick == isQuick and self.cacheFirstPass == isFirstPass and self.cachePickUp == pickUp and self.cacheHeroRoadStarCount == heroRoadStarCount and not isAstral then
    return
  end
  self.cacheQuick = isQuick
  self.cacheFirstPass = isFirstPass
  self.cachePickUp = pickUp
  self.cacheHeroRoadStarCount = heroRoadStarCount
  _ArrayClear(self.staticRewardList)
  self.rewardDirty = true
  local needInsert = false
  local reward_config = self.staticEntranceData.staticData and self.staticEntranceData.staticData.ClientRewards
  if reward_config then
    local hasSweepReward = self.staticEntranceData:HasSweepReward()
    for i = 1, #reward_config do
      reward_type = reward_config[i].type
      rewards = reward_config[i].rewards
      valid = self:CheckRewardValid(reward_type)
      if valid and hasSweepReward then
        if reward_type == PveDropItemData.Type.E_Pve_Sweep then
          valid = self:checkType_12()
        else
          valid = not self:checkType_12()
        end
      end
      if valid then
        for j = 1, #rewards do
          rewardTeamids = ItemUtil.GetRewardItemIdsByTeamId(rewards[j])
          if rewardTeamids then
            for _, data in pairs(rewardTeamids) do
              local item = PveDropItemData.new("PveDropReward", data.id)
              if BranchMgr.IsJapan() then
                rate = data.jp_rate
              else
                rate = data.rate
              end
              if rate then
                item:SetRate(rate)
              end
              item.num = data.num
              if PveDropItemData.CheckNeedInsert(reward_type) then
                needInsert = true
                if reward_type == PveDropItemData.Type.E_Pve then
                  itemRewardType = isFirstPass and PveDropItemData.Type.E_Pve or PveDropItemData.Type.E_First
                elseif reward_type == PveDropItemData.Type.E_WeekFirstPass then
                  itemRewardType = reward_type
                else
                  itemRewardType = PveDropItemData.Type.E_Normal
                end
                item:SetOwnPveId(self.id)
              else
                itemRewardType = reward_type
                if needInsert then
                  self.pveCardRewardIndex = #self.staticRewardList + 1
                  needInsert = false
                end
              end
              item:SetType(itemRewardType)
              item:SetRange(data.minnum, data.maxnum)
              item:SetSpecialBgName(_GetSpecialIconBg(data.id))
              local received = isAstral and reward_type == PveDropItemData.Type.E_First and isFirstPass or false
              item:SetReceived(received)
              _ArrayPushBack(self.staticRewardList, item)
            end
          end
        end
      end
    end
  end
  if isAstral then
    local season = AstralProxy.Instance:GetSeason()
    local config = Table_AstralSeason[season]
    if config and config.FashionReward then
      for diff, data in pairs(config.FashionReward) do
        if diff == self.staticEntranceData.staticDifficulty and data[1] and data[2] then
          local item = PveDropItemData.new("PveDropReward", data[1])
          item.num = data[2]
          item:SetType(PveDropItemData.Type.E_First)
          item:SetReceived(isFirstPass)
          _ArrayPushBack(self.staticRewardList, item)
        end
      end
    end
  end
end

function PvePassInfo:_resetServerMonsters(showbossids)
  if showbossids then
    _serverMonsterDirty = true
    _ArrayClear(self.serverMonsters)
    for i = 1, #showbossids do
      _ArrayPushBack(self.serverMonsters, showbossids[i])
    end
  end
end

function PvePassInfo:_resetServerRewards(showrewards)
  if showrewards then
    _ArrayClear(self.serverRewards)
    self.rewardDirty = true
    for i = 1, #showrewards do
      local serverRewardData = PveServerRewardData.new(showrewards[i])
      local rewards = serverRewardData:GetRewards()
      for i = 1, #rewards do
        _ArrayPushBack(self.serverRewards, rewards[i])
      end
    end
  end
end

function PvePassInfo:TryGetExtraRewards()
  local extra_rewards, extra_reward_valid = ActivityEventProxy.Instance:GetRewardByRaidType(self.staticEntranceData.raidType)
  if not (extra_rewards and extra_reward_valid) or not next(extra_rewards) then
    return
  end
  local items = {}
  for i = 1, #extra_rewards do
    local item = PveDropItemData.new("PveDropReward", extra_rewards[i].id)
    item:SetItemNum(extra_rewards[i].count)
    item:SetType(PveDropItemData.Type.E_Extra)
    item:SetSpecialBgName(_GetSpecialIconBg(extra_rewards[i].id))
    _ArrayPushBack(items, item)
  end
  return items
end

local special_PveCard_ItemID = {
  [4611] = 1,
  [4612] = 1,
  [4613] = 1
}

function PvePassInfo:_getRewards()
  if self.rewardDirty then
    _ArrayClear(self.allRewards)
    if self.staticEntranceData:IsHeadWear() then
      _InsertArray(self.allRewards, self.staticRewardList)
      _InsertArray(self.allRewards, self.serverRewards)
    elseif self.staticEntranceData:IsPveCard() then
      _InsertArray(self.allRewards, self.staticRewardList)
      for i = 1, #self.serverRewards do
        if nil ~= self.pveCardRewardIndex and nil ~= special_PveCard_ItemID[self.serverRewards[i].staticData.id] then
          table.insert(self.allRewards, self.pveCardRewardIndex, self.serverRewards[i])
        else
          table.insert(self.allRewards, self.serverRewards[i])
        end
      end
    else
      _InsertArray(self.allRewards, self.serverRewards)
      _InsertArray(self.allRewards, self.staticRewardList)
    end
    _InsertArray(self.allRewards, self.commonFunReward)
    self.rewardDirty = false
  end
  return self.allRewards
end

function PvePassInfo:IsFree()
  return self.is_free == true
end

function PvePassInfo:_resetBossInfo(bossinfo)
  if not self.isBoss then
    return
  end
  if not bossinfo or not next(bossinfo) then
    return
  end
  _TableClear(self.bossInfoMap)
  self:_resetBossId()
  local pveBossInfo
  for i = 1, #bossinfo do
    pveBossInfo = self.bossInfoMap[bossinfo[i].bossid]
    if not pveBossInfo then
      pveBossInfo = PveBossInfo.new(bossinfo[i])
      self.bossInfoMap[bossinfo[i].bossid] = pveBossInfo
    else
      pveBossInfo:ResetData(bossinfo[i].showrewards, bossinfo[i].randrewardid, bossinfo[i].randnorewardid)
    end
  end
  for id, bossInfo in pairs(self.bossInfoMap) do
    local boss_type = bossInfo.isMvp and Pve_Difficulty_Type.Normal or Pve_Difficulty_Type.Difficult
    _ArrayPushBack(self.bossIdMap[boss_type], id)
  end
end

function PvePassInfo:getMonsters()
  _ArrayClear(self.monsterList)
  _InsertArray(self.monsterList, self.serverMonsters)
  _InsertArray(self.monsterList, self.staticEntranceData.staticData.Monster)
  return self.monsterList
end

function PvePassInfo:GetMonsters(bossid)
  if self.isBoss then
    local info = self.bossInfoMap[bossid]
    if info then
      return info:GetMonsters()
    end
  else
    return self:getMonsters()
  end
end

local FinalRewards = {}

function PvePassInfo:GetAllRewards(bossid)
  if self.isBoss then
    if not bossid then
      return {}
    end
    local info = self.bossInfoMap[bossid]
    local bossRewards = info and info:GetRewards() or {}
    _ArrayClear(FinalRewards)
    self:_resetCommonFunRewards()
    _InsertArray(FinalRewards, bossRewards)
    _InsertArray(FinalRewards, self.commonFunReward)
    return FinalRewards
  else
    return self:_getRewards()
  end
end

function PvePassInfo:HasBossInfo(bossid)
  return nil ~= self.bossInfoMap and nil ~= self.bossInfoMap[bossid]
end

function PvePassInfo:GetServerBoss(type)
  if self.isBoss then
    return self.bossIdMap[type] or _EmptyTable
  end
  return _EmptyTable
end

function PvePassInfo:IsPickup()
  return self.pickup == true
end

function PvePassInfo:GetGradeDesc()
  if self.grade then
    return GameConfig.StarArk and GameConfig.StarArk.GradingText and GameConfig.StarArk.GradingText[self.grade] or ""
  end
  return ""
end

function PvePassInfo:GetPassTime(ignore_sweep)
  if ignore_sweep then
    return self:GetPassTime_IgnoreSweep()
  else
    return self.passtime
  end
end

function PvePassInfo:GetPassTime_IgnoreSweep()
  if self:HasSweepReward() then
    if self.passtime >= 1 then
      return 1
    else
      return self.passtime
    end
  else
    return self.passtime
  end
end

function PvePassInfo:CheckPass()
  return self.pass
end

function PvePassInfo:CheckAccPass()
  return self.acc_pass
end

function PvePassInfo:GetQuick()
  return self.quick
end

function PvePassInfo:GetSortId()
  if self:Forbidden() then
    return PveSortEnum.Forbidden
  elseif PveEntranceProxy.Instance:IsOpen(self.id) then
    return PveSortEnum.Open
  else
    return PveSortEnum.Lock
  end
end

function PvePassInfo:GetStaticCostTime()
  if self.isBoss then
    local id = FunctionPve.Me().viewBossId
    if id then
      if _IsMvp(id) then
        return MVPCostTime
      else
        return MiniCostTime
      end
    end
    return 0
  end
  return self.staticEntranceData.staticData.TimeCost
end

function PvePassInfo:GetHeroRoadStarCount()
  if self.heroRoadStars then
    return #self.heroRoadStars
  end
  return 0
end

function PvePassInfo:IsMyProAstralPrayed()
  local myPro = MyselfProxy.Instance:GetMyProfession()
  return AstralProxy.Instance:IsProAstralPrayed(myPro, self.astral_pray_group)
end
