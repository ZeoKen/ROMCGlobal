VersionPrestigeProxy = class("VersionPrestigeProxy", pm.Proxy)
VersionPrestigeProxy.Instance = nil
VersionPrestigeProxy.NAME = "VersionPrestigeProxy"

function VersionPrestigeProxy:ctor(proxyName, data)
  self.proxyName = proxyName or VersionPrestigeProxy.NAME
  if VersionPrestigeProxy.Instance == nil then
    VersionPrestigeProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function VersionPrestigeProxy:Init()
  self.versionPrestigeInfo = {}
  self.staticPrestigeInfo = {}
  self:InitPrestigeLevel()
end

function VersionPrestigeProxy:InitPrestigeLevel()
  if not Table_PrestigeLevel then
    return
  end
  for k, v in pairs(Table_PrestigeLevel) do
    local type = v.Type
    if not self.staticPrestigeInfo[type] then
      self.staticPrestigeInfo[type] = {}
    end
    if not self.staticPrestigeInfo[type].StartIndex or self.staticPrestigeInfo[type].StartIndex > v.id then
      self.staticPrestigeInfo[type].StartIndex = v.id
    end
    if not self.staticPrestigeInfo[type].EndIndex or self.staticPrestigeInfo[type].EndIndex < v.id then
      self.staticPrestigeInfo[type].EndIndex = v.id
    end
    if not self.staticPrestigeInfo[type].MaxLevel then
      self.staticPrestigeInfo[type].MaxLevel = 1
    else
      self.staticPrestigeInfo[type].MaxLevel = self.staticPrestigeInfo[type].MaxLevel + 1
    end
    if not self.staticPrestigeInfo[type].PrestigeValue then
      self.staticPrestigeInfo[type].PrestigeValue = {}
    end
    local unlockCondition = v.UnlockCondition or {}
    for i = 1, #unlockCondition do
      local conditionConfig = Table_PrestigeUnlockCondition[unlockCondition[i]]
      if conditionConfig and conditionConfig.Condition == "prestige" then
        local targetPrestige = conditionConfig.TargetNum
        self.staticPrestigeInfo[type].PrestigeValue[k] = targetPrestige
      end
    end
  end
  if self.staticPrestigeInfo[1] then
    xdlog("声望等级数据", self.staticPrestigeInfo[1].MaxLevel, self.staticPrestigeInfo[1].StartIndex, self.staticPrestigeInfo[1].EndIndex)
  end
end

function VersionPrestigeProxy:GetStaticPrestigeInfo(type)
  if not self.staticPrestigeInfo[type] then
    return nil
  end
  return self.staticPrestigeInfo[type]
end

function VersionPrestigeProxy:ParseLevelToIndex(type, level)
  if not type or not level then
    return
  end
  local staticInfo = self.staticPrestigeInfo[type]
  if not staticInfo then
    return
  end
  local startIndex = staticInfo.StartIndex
  return startIndex + (level - 1)
end

function VersionPrestigeProxy:RecvQueryPrestigeCmd(data)
  local type = data.type
  if not self.versionPrestigeInfo[type] then
    self.versionPrestigeInfo[type] = {}
  end
  TableUtility.TableClear(self.versionPrestigeInfo[type])
  local tempData = {
    level = data.level,
    value = data.value,
    dailyLimit = data.day_num_from_limit
  }
  tempData.condDatas = {}
  local cond_datas = data.cond_datas
  if cond_datas and 0 < #cond_datas then
    for i = 1, #cond_datas do
      local singleCond = cond_datas[i]
      tempData.condDatas[singleCond.level] = {}
      local conds = singleCond.conds
      for j = 1, #conds do
        local cond = {
          id = conds[j].id,
          state = conds[j].state,
          process = conds[j].process
        }
        table.insert(tempData.condDatas[singleCond.level], cond)
      end
    end
  end
  local rewarded_levels = data.rewarded_levels
  if rewarded_levels and 0 < #rewarded_levels then
    local list = {}
    TableUtility.ArrayShallowCopy(list, rewarded_levels)
    tempData.rewarded_levels = list
  end
  self.versionPrestigeInfo[type] = tempData
end

function VersionPrestigeProxy:RecvPrestigeLevelUpNotifyCmd(data)
  local type = data.type
  local origin_level = data.origin_level
  local new_level = data.new_level
  local origin_value = data.origin_value
  local new_value = data.new_value
  if self.versionPrestigeInfo[type] then
    self.versionPrestigeInfo[type].level = new_level
    self.versionPrestigeInfo[type].levelUpNotify = true
  end
  FloatingPanel.Instance:ShowPrestigeUpdate(data)
end

function VersionPrestigeProxy:RecvPrestigeRewardCmd(data)
  local type = data.type
  local level = data.level
  if self.versionPrestigeInfo[type] then
    local rewarded_levels = self.versionPrestigeInfo[type].rewarded_levels or {}
    if TableUtility.ArrayFindIndex(rewarded_levels, level) == 0 then
      table.insert(rewarded_levels, level)
    end
    self.versionPrestigeInfo[type].rewarded_levels = rewarded_levels
  end
end

function VersionPrestigeProxy:BrowseLevelUpNotify(type)
  if not self.versionPrestigeInfo[type] then
    return
  end
  self.versionPrestigeInfo[type].levelUpNotify = false
end

function VersionPrestigeProxy:GetPrestigeInfo(type)
  if not self.versionPrestigeInfo then
    return nil
  end
  if not self.versionPrestigeInfo[type] then
    return nil
  end
  return self.versionPrestigeInfo[type]
end

function VersionPrestigeProxy:GetPrestigeLevelConditions(type, level)
  if not self.versionPrestigeInfo[type] then
    return nil
  end
  local condDatas = self.versionPrestigeInfo[type].condDatas
  if condDatas and condDatas[level] then
    return condDatas[level]
  end
end

function VersionPrestigeProxy:GetTypeByGroup(group)
  local config = GameConfig.Quest.worldquestmap
  local prestigeMap = GameConfig.Prestige and GameConfig.Prestige.ValidMap
  if not config or not prestigeMap then
    return
  end
  if config and config[group] then
    local maps = config[group].map
    for i = 1, #maps do
      if prestigeMap[maps[i]] then
        return prestigeMap[maps[i]]
      end
    end
  end
end

function VersionPrestigeProxy:GetVersionAllFinish(type)
  local prestigeInfo = self:GetPrestigeInfo(type)
  if not prestigeInfo then
    ServiceSceneUser3Proxy.Instance:CallQueryPrestigeCmd(type)
    return false
  end
  local curLv = prestigeInfo.level
  local staticData = self:GetStaticPrestigeInfo(type)
  local maxLevel = staticData and staticData.MaxLevel
  if maxLevel == curLv then
    return true
  end
  return false
end
