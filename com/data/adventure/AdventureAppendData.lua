AdventureAppendData = class("AdventureAppendData")
AdventureAppendData.RewardDataType = {
  empty = 1,
  normal = 2,
  special = 3,
  monstUnlock = 4,
  buffer = 5
}

function AdventureAppendData:ctor(serverData)
  self.staticId = serverData.id
  self:initStaticData()
  self:updateData(serverData)
end

function AdventureAppendData:updateData(serverData)
  self.process = serverData.process
  self.finish = serverData.finish
  self.rewardget = serverData.rewardget
  self.index = serverData.index
end

function AdventureAppendData:UpdateDataByCurAppend(curAppendData)
  if not curAppendData or self.staticData.targetID ~= curAppendData.staticData.targetID then
    return
  end
  local complete = false
  if curAppendData.staticId == self.staticId then
    self.process = curAppendData.process
    self.finish = curAppendData.finish
  else
    local dataId = curAppendData.staticId
    local config
    while dataId and dataId ~= 0 and dataId ~= self.staticId do
      config = Table_AdventureAppend[dataId]
      dataId = config and config.PreID and config.PreID[1]
    end
    if dataId and dataId ~= 0 then
      self.finish = true
      self.process = self.staticData.Params and self.staticData.Params[1] or 0
    else
      self.finish = false
      self.process = 0
    end
  end
end

function AdventureAppendData:initStaticData()
  self.staticData = Table_AdventureAppend[self.staticId]
  if self.staticData then
    self.appendName = self.staticData.NameZh
    local rewards = ItemUtil.GetRewardItemIdsByTeamId(self.staticData.Reward) or {}
    if not rewards then
      LogUtility.WarningFormat("can't find reward in Table_Reward reward id:{0} by Table_AdventureAppend id :{1}", self.staticData.Reward, self.staticId)
      return
    end
    table.sort(rewards, function(l, r)
      return l.id < r.id
    end)
    local specialList = {}
    self.rewardItemDatas = {}
    self.normalItemDatas = {}
    self.specialItemDatas = {}
    for i = 1, #rewards do
      local single = rewards[i]
      local itemData = Table_Item[single.id]
      if itemData then
        local data = {}
        if ItemUtil.CheckItemIsSpecialInAdventureAppend(itemData.Type) then
          data.type = AdventureAppendData.RewardDataType.special
          data.text = string.format(ZhString.AdventureAppendRewardPanel_Unlock, itemData.NameZh)
          data.icon = GameConfig.AdventureAppendUnlockItemIcon or "tab_icon_157"
          table.insert(specialList, data)
          table.insert(self.specialItemDatas, single)
        else
          data.type = AdventureAppendData.RewardDataType.normal
          data.text = string.format("%sx%d", itemData.NameZh, single.num)
          data.icon = itemData.Icon
          table.insert(self.rewardItemDatas, data)
          table.insert(self.normalItemDatas, single)
        end
      end
    end
    if #self.rewardItemDatas % 2 ~= 0 then
      local data = {}
      data.type = AdventureAppendData.RewardDataType.empty
      table.insert(self.rewardItemDatas, data)
    end
    for i = 1, #specialList do
      local single = specialList[i]
      table.insert(self.rewardItemDatas, single)
      local data = {}
      data.type = AdventureAppendData.RewardDataType.empty
      table.insert(self.rewardItemDatas, data)
    end
    if self.staticData.BuffID then
      local data = {}
      local str = ItemUtil.getBufferDescByIdNotConfigDes(self.staticData.BuffID) or ""
      data.text = string.format(ZhString.AdventureAppendRewardPanel_BufferUnlock, str)
      data.type = AdventureAppendData.RewardDataType.buffer
      table.insert(self.rewardItemDatas, data)
      data = {}
      data.type = AdventureAppendData.RewardDataType.empty
      table.insert(self.rewardItemDatas, data)
    end
    local isMonster = self.staticData.Type == SceneManual_pb.EMANUALTYPE_MONSTER
    if self:isPhoto() and isMonster then
      self.isMonstUnlock = true
      local data = {}
      data.type = AdventureAppendData.RewardDataType.monstUnlock
      data.text = ZhString.AdventureAppendRewardPanel_MonstUnlock
      data.icon = GameConfig.AdventureAppendUnlockItemIcon or "tab_icon_157"
      table.insert(self.rewardItemDatas, data)
    end
    if self.staticData.UnlockItemIds then
      for _, itemId in ipairs(self.staticData.UnlockItemIds) do
        local itemData = Table_Item[itemId]
        if itemData then
          local data = {}
          data.type = AdventureAppendData.RewardDataType.special
          data.text = string.format(ZhString.HappyShop_UnlockDesc, itemData.NameZh)
          data.icon = GameConfig.AdventureAppendUnlockItemIcon or "tab_icon_157"
          table.insert(self.rewardItemDatas, 1, data)
        end
      end
    end
  end
end

function AdventureAppendData:getNormalRewardItems()
  return self.normalItemDatas
end

function AdventureAppendData:getSpecialRewardItems()
  return self.specialItemDatas
end

function AdventureAppendData:isMonstUnlock()
  return self.isMonstUnlock
end

function AdventureAppendData:isCompleted()
  return self.finish and not self.rewardget
end

function AdventureAppendData:isPhoto()
  return self.staticData and self.staticData.Content == QuestDataStepType.QuestDataStepType_SELFIE
end

function AdventureAppendData:isKill()
  return self.staticData and self.staticData.Content == QuestDataStepType.QuestDataStepType_KILL
end

function AdventureAppendData:getRewardItems()
  return self.rewardItemDatas
end

function AdventureAppendData:getAppendName()
  return self.appendName
end

function AdventureAppendData:getProcessInfo()
  if self.staticData then
    self.traceInfo = self.staticData.Desc
    local tableValue = self:getTranceInfoTable()
    if tableValue == nil then
      return "parse table text is nil:" .. self.traceInfo
    end
    local result = self.traceInfo and string.gsub(self.traceInfo, "%[(%w+)]", tableValue) or ""
    return result
  end
end

function AdventureAppendData:getTranceInfoTable()
  local table = {}
  local questType = self.staticData.Content
  if questType == QuestDataStepType.QuestDataStepType_SELFIE then
    local id = self.staticData.targetID
    local infoTable = Table_Monster[id]
    if infoTable == nil then
      infoTable = Table_Npc[id]
    end
    if infoTable ~= nil then
      table = {
        param2 = nil,
        monsterName = OverSea.LangManager.Instance():GetLangByKey(infoTable.NameZh)
      }
    else
      errorLog("AdventureAppendData can't find mosntData in Table_Monster by targetID:", id)
    end
  elseif questType == QuestDataStepType.QuestDataStepType_KILL then
    local process = self.process
    local id = self.staticData.targetID
    local totalNum = self.staticData.Params[1]
    local infoTable = Table_Monster[id]
    if infoTable == nil then
      infoTable = Table_Npc[id]
    end
    local showProcess = process <= totalNum and process or totalNum
    if infoTable ~= nil then
      table = {
        monsterName = OverSea.LangManager.Instance():GetLangByKey(infoTable.NameZh),
        num = string.format("[c][0077BBFF]%s[-][/c]", showProcess .. "/" .. totalNum)
      }
    else
    end
  elseif questType == "active" then
    local process = self.process
    local totalNum = self.staticData.Params[1]
    table = {
      num = string.format("[c][0077BBFF]%s[-][/c]", tostring(process) .. "/" .. tostring(totalNum))
    }
  end
  return table
end

function AdventureAppendData.GetUnlockDesc(appendId)
  local appendConfig = Table_AdventureAppend[appendId]
  if appendConfig then
    local questType = appendConfig.Content
    if questType == QuestDataStepType.QuestDataStepType_KILL then
      local monsterId = appendConfig.targetID
      local killNum = appendConfig.Params[1]
      local monsterConfig = Table_Monster[monsterId]
      monsterConfig = monsterConfig or Table_Npc[monsterId]
      if monsterConfig then
        local tableValue = {
          monsterName = monsterConfig.NameZh and OverSea.LangManager.Instance():GetLangByKey(monsterConfig.NameZh),
          num = tostring(killNum)
        }
        local desc = appendConfig.Desc
        return desc and string.gsub(desc, "%[(%w+)]", tableValue)
      end
    end
  end
end

function AdventureAppendData:IsPreAppendOf(appendData)
  if not appendData then
    return false
  end
  local config = Table_AdventureAppend[appendData.staticId]
  local preID = config and config.PreID and config.PreID[1]
  while preID do
    if preID == self.staticId then
      return true
    end
    config = Table_AdventureAppend[preID]
    preID = config and config.PreID and config.PreID[1]
  end
  return false
end

function AdventureAppendData:IsProcessOverflow()
  local questType = self.staticData.Content
  if questType == QuestDataStepType.QuestDataStepType_KILL then
    local totalNum = self.staticData.Params[1]
    if totalNum < self.process then
      return true
    end
  end
  return false
end
