autoImport("PveDropItemData")
autoImport("PveServerRewardData")
PveBossInfo = class("PveBossInfo")
local rewardTeamids, rate
local hashToArray = TableUtil.HashToArray

function PveBossInfo:ctor(serverdata)
  self.id = serverdata.bossid
  self.monsters = {}
  self.rewards = {}
  self.probabilityRewardMap = {}
  self.fixedRewardMap = {}
  local monsterStaticData = Table_Monster[self.id]
  if monsterStaticData then
    self.isMvp = monsterStaticData.Type == "MVP"
    self:ResetData(serverdata.showrewards, serverdata.randrewardid, serverdata.randnorewardid)
  else
    redlog("Table_Monster 未配置id：", self.id)
  end
end

function PveBossInfo:_preprocessRewardBossId(bossid)
  local _config = Game.BossSceneMonster[bossid]
  if _config then
    self.monsters[#self.monsters + 1] = bossid
    local reward_config = _config.ClientRewards
    if reward_config then
      local reward_type, rewards, rewardMap
      for i = 1, #reward_config do
        reward_type = reward_config[i].type
        rewards = reward_config[i].rewards
        if reward_type == PveDropItemData.Type.E_Probability then
          rewardMap = self.probabilityRewardMap
        else
          rewardMap = self.fixedRewardMap
        end
        for j = 1, #rewards do
          rewardTeamids = ItemUtil.GetRewardItemIdsByTeamId(rewards[j])
          if rewardTeamids then
            for _, data in pairs(rewardTeamids) do
              if BranchMgr.IsJapan() then
                rate = data.jp_rate
              else
                rate = data.rate
              end
              local mapData = rewardMap[data.id]
              if nil ~= mapData and mapData.dropType and mapData.dropType == reward_type then
                mapData.num = mapData.num + data.num
              else
                local item = PveDropItemData.new("PveDropReward", data.id)
                item.num = data.num
                item:SetRate(rate)
                item:SetType(reward_type)
                item:SetRange(data.minnum, data.maxnum)
                rewardMap[data.id] = item
              end
            end
          end
        end
      end
    end
  else
    redlog("Table_BossSceneMonster配置错误,未找到MonsterID: ", rewardBossID)
  end
end

function PveBossInfo:ParseServerRewards(serverRewards)
  if not serverRewards or not next(serverRewards) then
    return
  end
  local rewardMap, itemId, rewardType
  for i = 1, #serverRewards do
    local parseRewardData = PveServerRewardData.new(serverRewards[i])
    local dropItemDatas = parseRewardData:GetRewards()
    for i = 1, #dropItemDatas do
      rewardType = dropItemDatas[i].dropType
      if rewardType == PveDropItemData.Type.E_Probability then
        rewardMap = self.probabilityRewardMap
      else
        rewardMap = self.fixedRewardMap
      end
      itemId = dropItemDatas[i].staticData.id
      local mapData = rewardMap[itemId]
      if nil ~= mapData and mapData.dropType and mapData.dropType == rewardType then
        mapData.num = mapData.num + dropItemDatas[i].num
      else
        rewardMap[itemId] = dropItemDatas[i]
      end
    end
  end
end

function PveBossInfo:ResetData(serverRewards, rewardBossId, monsterIds)
  self:ParseServerRewards(serverRewards)
  if rewardBossId then
    for i = 1, #rewardBossId do
      self:_preprocessRewardBossId(rewardBossId[i])
    end
  end
  if monsterIds and next(monsterIds) then
    for i = 1, #monsterIds do
      self.monsters[#self.monsters + 1] = monsterIds[i]
    end
  end
  table.sort(self.monsters, function(l, r)
    local bossid = self.id
    if l == bossid or r == bossid then
      return l == bossid
    end
    return r < l
  end)
end

function PveBossInfo:GetMonsters()
  return self.monsters
end

function PveBossInfo:setRewards()
  hashToArray(self.fixedRewardMap, self.rewards)
  hashToArray(self.probabilityRewardMap, self.rewards)
  table.sort(self.rewards, function(l, r)
    return l.bossSortId < r.bossSortId
  end)
end

function PveBossInfo:GetRewards()
  if not next(self.rewards) then
    self:setRewards()
  end
  return self.rewards
end
