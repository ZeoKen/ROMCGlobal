AchieveRewardProxy = class("AchieveRewardProxy", pm.Proxy)
AchieveRewardProxy.Instance = nil
AchieveRewardProxy.NAME = "AbyssLakeProxy"

function AchieveRewardProxy:ctor(proxyName, data)
  self.proxyName = proxyName or AchieveRewardProxy.NAME
  if AchieveRewardProxy.Instance == nil then
    AchieveRewardProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function AchieveRewardProxy:Init()
  self.rewardNotifyMap = {}
  self.areaMaps = {}
  self.sendGroupID = {}
end

function AchieveRewardProxy:RecvNewNpcAchieveNtfAchCmd(data)
  local groupids = data.groupid
  if groupids and 0 < #groupids then
    for i = 1, #groupids do
      local groupid = groupids[i]
      self.rewardNotifyMap[groupid] = 1
      xdlog("有奖励可领取", groupid)
      self:SendSysmsg(groupid)
    end
  end
end

function AchieveRewardProxy:SendSysmsg(groupid)
  local shortCutPowerID = GameConfig.NpcAchieve and GameConfig.NpcAchieve[groupid]
  if shortCutPowerID then
    local shortCutPowerData = Table_ShortcutPower[shortCutPowerID]
    local npcid = shortCutPowerData and shortCutPowerData.Event and shortCutPowerData.Event.npcid
    if npcid then
      local npcData = Table_Npc[npcid]
      local str = string.format(ZhString.Abyss_AchieveNotice, npcData and npcData.NameZh or "")
      ChatRoomProxy.Instance:AddSystemMessage(7, string.format("[url=achievereward;%s]%s[/url]", groupid, str))
    end
  end
end

function AchieveRewardProxy:SetSendGroupID(groupid)
  if not groupid then
    return
  end
  self.sendGroupID[groupid] = 1
end

function AchieveRewardProxy:RecvUpdateNpcAchieveAchCmd(data)
  local datas = data.datas
  if datas and 0 < #datas then
    for i = 1, #datas do
      local data = datas[i]
      local id = data.id
      local process = data.process
      local finish_time = data.finish_time
      local reward_get = data.reward_get
      local can_get_reward = data.can_get_reward
      self.areaMaps[id] = {
        id = id,
        process = process,
        finish_time = finish_time,
        reward_get = reward_get,
        can_get_reward = can_get_reward
      }
    end
  end
  self:UpdateRewardNotify()
end

function AchieveRewardProxy:UpdateRewardNotify()
  local canGetGroups = {}
  for _id, _data in pairs(self.areaMaps) do
    local staticData = Table_NpcAchieve[_id]
    if staticData then
      local groupID = staticData and staticData.GroupID
      local _canGet = _data.finish_time > 0 and _data.reward_get == false and _data.can_get_reward == true
      if not canGetGroups[groupID] or canGetGroups[groupID] == 0 then
        canGetGroups[groupID] = _canGet and 1 or 0
      end
    end
  end
  for groupID, _ in pairs(self.sendGroupID) do
    if canGetGroups[groupID] and canGetGroups[groupID] == 0 then
      self.rewardNotifyMap[groupID] = nil
    end
  end
  for groupID, _status in pairs(canGetGroups) do
    if _status == 1 then
      self.rewardNotifyMap[groupID] = 1
    end
  end
end

function AchieveRewardProxy:GetAchieveRewardByGroup(groupid)
  if not self.areaMaps then
    return nil
  end
  local result = {}
  for _id, _data in pairs(self.areaMaps) do
    local staticData = Table_NpcAchieve[_id]
    if staticData and staticData.GroupID == groupid then
      table.insert(result, _data)
    end
  end
  return result
end

function AchieveRewardProxy:CheckAchieveRewardStatusCmd(groupid)
  if not self.rewardNotifyMap then
    return false
  end
  return self.rewardNotifyMap[groupid] ~= nil
end
