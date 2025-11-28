autoImport("AbyssMonsterInfo")
autoImport("AbyssAreaInfo")
AbyssLakeProxy = class("AbyssLakeProxy", pm.Proxy)
AbyssLakeProxy.Instance = nil
AbyssLakeProxy.NAME = "AbyssLakeProxy"

function AbyssLakeProxy:ctor(proxyName, data)
  self.proxyName = proxyName or AbyssLakeProxy.NAME
  if AbyssLakeProxy.Instance == nil then
    AbyssLakeProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function AbyssLakeProxy:Init()
  self.areaMaps = {}
end

function AbyssLakeProxy:GetMonsterDataByStepId(stepId)
  return self.monsterData and self.monsterData[stepId]
end

function AbyssLakeProxy:GetMvpMonsters()
  return self.currentArea and self.areaMaps and self.areaMaps[self.currentArea]:GetMvpMonsters()
end

function AbyssLakeProxy:GetMiniMonsters()
  return self.currentArea and self.areaMaps and self.areaMaps[self.currentArea]:GetMiniMonsters()
end

function AbyssLakeProxy:RecvAbyssBossUpdateCmd(data)
  if not self.currentAreaID then
    return
  end
  if not self.areaMaps[data.area] then
    self.areaMaps[data.area] = AbyssAreaInfo.new(data.area)
  end
  self.currentArea = data.area
  self.areaMaps[data.area]:UpdateBossProgress(data.boss_infos)
end

function AbyssLakeProxy:GetRewardData(baseRewardId)
  local baseReward = ItemUtil.GetRewardItemIdsByTeamId(baseRewardId)
  local extraRewards = self.extraRewardDatas and self.extraRewardDatas[baseRewardId]
  if extraRewards then
    for i = 1, #extraRewards do
      baseReward[#baseReward + 1] = extraRewards[i]
    end
  end
  local result = {}
  local itemMap = {}
  if baseReward and 0 < #baseReward then
    for i = 1, #baseReward do
      local itemId = baseReward[i].id
      local itemNum = baseReward[i].num
      if itemMap[itemId] then
        itemMap[itemId] = itemMap[itemId] + itemNum
      else
        itemMap[itemId] = itemNum
      end
    end
    for itemId, itemNum in pairs(itemMap) do
      local item = ItemData.new("AbyssLake", itemId)
      item:SetItemNum(itemNum)
      result[#result + 1] = item
    end
  end
  return result
end

function AbyssLakeProxy:RecvExtraRewardUpdateMapCmd(data)
  self.rewardData = data
  if not data then
    return
  end
  if not self.extraRewardDatas then
    self.extraRewardDatas = {}
  end
  local key = 0
  if data.datas then
    for i = 1, #data.datas do
      local rewards = data.datas[i]
      if rewards and rewards.rewardid then
        key = rewards.rewardid
        if not self.extraRewardDatas[key] then
          self.extraRewardDatas[key] = {}
        end
        local extraReward = self.extraRewardDatas[key]
        for j = 1, #rewards.extrareward do
          local processedRewards = ItemUtil.GetRewardItemIdsByTeamId(rewards.extrareward[j])
          if processedRewards then
            for k = 1, #processedRewards do
              extraReward[#extraReward + 1] = processedRewards[k]
            end
          end
        end
      end
    end
  end
end

function AbyssLakeProxy:ClearExtraRewards()
  if self.extraRewardDatas then
    self.extraRewardDatas = {}
  end
end

function AbyssLakeProxy:GetSummonProgress(area, mapStepId)
  local areaInfo = area and self.areaMaps and self.areaMaps[area]
  if not areaInfo then
    return
  end
  return areaInfo:GetSummonProgress(mapStepId)
end

function AbyssLakeProxy:Enter_AybssLakeBattleArea(area)
  self.currentAreaID = area
end

function AbyssLakeProxy:Leave_AybssLakeBattleArea()
  self.currentAreaID = nil
end
