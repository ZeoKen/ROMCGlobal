autoImport("AbyssQuestCell")
SnowRealmQuestCell = class("SnowRealmQuestCell", AbyssQuestCell)

function SnowRealmQuestCell:SetReward(data)
  local conf = Table_SnowRealmDailyQuest[data.id]
  if conf then
    local reward = conf.Reward
    local items = ItemUtil.GetRewardItemIdsByTeamId(reward and reward[1])
    if items then
      local itemId = items[1] and items[1].id
      IconManager:SetItemIconById(itemId, self.rewardIcon)
      local itemConf = Table_Item[itemId]
      self.rewardLabel.text = itemConf and itemConf.NameZh or ""
    end
  end
end

function SnowRealmQuestCell:SetUnlockTip(data)
  if data.crownLv < data.myCrownLv and data.unlockLv <= data.myCrownLv then
    self.unlockTip.text = ZhString.Abyss_QuestUnlocked
    self.lock:SetActive(false)
  else
    self.unlockTip.text = string.format(ZhString.SnowRealm_QuestUnlockTip, data.unlockLv)
    self.lock:SetActive(true)
  end
end
