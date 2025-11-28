DailyMonsterData = class("DailyMonsterData")

function DailyMonsterData:ctor(id, mode)
  self.id = id
  self.staticData = Table_Monster[id]
  self.diffMode = mode
  if not self.staticData then
    return
  end
  self.name = self.staticData.NameZh
  self.lv = self.staticData.Level
  self.manualMap = self.staticData.ManualMap
  self.headData = HeadImageData.new()
  self.headData:TransByMonsterData(self.staticData)
  self:SetReward()
end

function DailyMonsterData:SetReward()
  self.rewards = {}
  local filterRewardByItemType = GameConfig.MonsterAgent and GameConfig.MonsterAgent.FilterRewardByItemType
  if not filterRewardByItemType then
    return
  end
  local dead_reward = self.staticData.Dead_Reward
  local _Table_Item = Table_Item
  if dead_reward then
    for i = 1, #dead_reward do
      local list = ItemUtil.GetRewardItemIdsByTeamId(dead_reward[i])
      if list then
        for j = 1, #list do
          local itemStaticData = _Table_Item[list[j].id]
          if itemStaticData then
            local itemType = itemStaticData.Type
            if nil ~= filterRewardByItemType[itemType] then
              self.rewards[#self.rewards + 1] = ItemData.new("DailyMonsterItemData", list[j].id)
            end
          end
        end
      end
    end
  end
end

function DailyMonsterData:GetHeadData()
  return self.headData
end

function DailyMonsterData:GetRewardData()
  return self.rewards or {}
end

function DailyMonsterData:GetName()
  return self.name or ""
end

function DailyMonsterData:GetLevel()
  return self.lv or 0
end

function DailyMonsterData:GetManualMap()
  return self.manualMap
end
