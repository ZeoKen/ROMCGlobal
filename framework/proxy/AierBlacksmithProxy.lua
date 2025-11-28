AierBlacksmithProxy = class("AierBlacksmithProxy", pm.Proxy)
AierBlacksmithProxy.Instance = nil
AierBlacksmithProxy.NAME = "AierBlacksmithProxy"

function AierBlacksmithProxy:ctor(proxyName, data)
  self.proxyName = proxyName or AierBlacksmithProxy.NAME
  if AierBlacksmithProxy.Instance == nil then
    AierBlacksmithProxy.Instance = self
  end
  if data then
    self:setData(data)
  end
  self:PreprocessConfigData()
  self:ResetProxyData()
  self:AddEvts()
end

function AierBlacksmithProxy:PreprocessConfigData()
  self.configData = self.configData or {}
  TableUtility.TableClear(self.configData)
  self.configData.SmithQuestCountGap = {}
  self.configData.UnlockSmithPartnerGap = {}
  self.configData.PlayUpgradeBehaviorGap = {0}
  self.configData.ModelSceneBossAnime = {}
  self.configData.UpgradeCost = {}
  self.configData.UpgradeCostItem = nil
  self.configData.MaxLevel = 0
  for k, v in pairs(Table_SmithLevel) do
    if v.Effect and type(v.Effect) == "table" and next(v.Effect) then
      for i = 1, #v.Effect do
        local eff = v.Effect[i]
        eff = Table_AssetEffect and Table_AssetEffect[eff]
        if eff.Type and eff.Type == "SmithQuestCount" then
          self.configData.SmithQuestCountGap[k] = eff.Params.count
        elseif eff.Type and eff.Type == "UnlockSmithPartner" then
          self.configData.UnlockSmithPartnerGap[k] = eff.Params.npcid
        end
      end
    end
    if v.Cost and v.Cost[1] then
      self.configData.UpgradeCostItem = v.Cost[1][1]
      self.configData.UpgradeCost[k] = v.Cost[1][2]
    end
    if v.LevelUpEffect and v.LevelUpEffect[2] then
      table.insert(self.configData.PlayUpgradeBehaviorGap, k)
    end
    if k > self.configData.MaxLevel then
      self.configData.MaxLevel = k
    end
  end
  table.sort(self.configData.PlayUpgradeBehaviorGap)
  for i = 2, #self.configData.PlayUpgradeBehaviorGap do
    local lv = self.configData.PlayUpgradeBehaviorGap[i]
    local anim = Table_SmithLevel[lv].LevelUpEffect[2]
    if i == 2 then
      table.insert(self.configData.ModelSceneBossAnime, anim - 1)
    end
    table.insert(self.configData.ModelSceneBossAnime, anim)
  end
end

function AierBlacksmithProxy:AddEvts()
  local eventManager = EventManager.Me()
  eventManager:AddEventListener(ServiceEvent.PlayerMapChange, self.Listen_PlayerMapChange, self)
end

function AierBlacksmithProxy:ResetProxyData()
  self.proxyData = self.proxyData or {}
  TableUtility.TableClear(self.proxyData)
  self.proxyData.level = 0
  self.proxyData.reward_level = 0
  self.proxyData.quests = {}
  self.proxyData.all_partners = {}
  self.proxyData.monster_periodic_reward = {}
end

function AierBlacksmithProxy:Listen_PlayerMapChange(mapInfo)
  if not mapInfo then
    return nil
  end
  local mapId = mapInfo.data
  if not table.ContainsValue(GameConfig.Smithy.ModelMap, mapId) then
    return false
  end
  self.status_Pending_InitSetSceneBossAnime = true
  AierBlacksmithTestMe.Me():CallSmithInfoManorCmd()
end

function AierBlacksmithProxy:TryProcessQuestTrace(questid)
  if not self.proxyData.pending_trace_questid then
    self.proxyData.pending_trace_questid = {}
  end
  if not table.ContainsValue(self.proxyData.pending_trace_questid, questid) then
    table.insert(self.proxyData.pending_trace_questid, questid)
  end
end

function AierBlacksmithProxy:Recv_SmithInfoManorCmd(data)
  self.proxyData.quests = data.quests
  for i = 1, #data.quests do
    local q = data.quests[i]
    if q.quest_state == ESMITHQUESTSTATE.ESMITH_QUEST_ACCEPTED and table.ContainsValue(self.proxyData.pending_trace_questid, q.questid) then
      QuestProxy.Instance:AddTraceList(q.questid)
      TableUtility.ArrayRemove(self.proxyData.pending_trace_questid, q.questid)
    end
  end
  self.proxyData.all_partners = data.all_partners
  if self.proxyData.level ~= data.level then
    local isUpgrade = self.proxyData.level > 0 and data.level > self.proxyData.level
    self.proxyData.level = data.level
    if isUpgrade then
      GameFacade.Instance:sendNotification(ServiceEvent.SceneManorSmithLevelUpManorCmd)
    end
  end
  self.proxyData.reward_level = data.reward_level
  if self.status_Pending_InitSetSceneBossAnime then
    self.status_Pending_InitSetSceneBossAnime = nil
    self:TryInitSetSceneBossAnime()
  end
end

function AierBlacksmithProxy:Recv_SmithLevelUpManorCmd(data)
  if data and data.level and data.level > 0 then
    self.proxyData.level = data.level
  end
end

function AierBlacksmithProxy:Recv_SmithAcceptQuestManorCmd(data)
end

function AierBlacksmithProxy:Recv_ReqPeriodicMonsterUserEvent(data)
  local km = data.killed_monsters
  self.proxyData.monster_periodic_reward = {}
  for k, v in pairs(Table_MonsterPeriodicReward) do
    if v.FuncType == "Smithy" then
      local killed = TableUtility.ArrayFindIndex(km, v.MonsterID) > 0
      TableUtility.ArrayPushBack(self.proxyData.monster_periodic_reward, {killed = killed, info = v})
    end
  end
end

function AierBlacksmithProxy:TryInitSetSceneBossAnime()
  local mapId = Game.MapManager:GetMapID()
  if not table.ContainsValue(GameConfig.Smithy.ModelMap, mapId) then
    return
  end
  local anim = self:Query_CurrentSceneBossAnime()
  if Table_SceneBossAnime[anim] then
    local objID = Table_SceneBossAnime[anim].ObjID
    local name = Table_SceneBossAnime[anim].Name
    Game.GameObjectManagers[Game.GameObjectType.SceneBossAnime]:ExplicitlyPlaySceneAnime(objID, name, 1)
  end
end

function AierBlacksmithProxy:TryPlayUpgradeBehavior(restoreViewData)
  local mapId = Game.MapManager:GetMapID()
  if not table.ContainsValue(GameConfig.Smithy.ModelMap, mapId) then
    return
  end
  local level = self.proxyData.level
  local cfg = Table_SmithLevel[level]
  cfg = cfg and cfg.LevelUpEffect
  if cfg and 2 <= #cfg then
    Game.PlotStoryManager:Launch()
    local result = Game.PlotStoryManager:Start_SEQ_PQTLP(tostring(cfg[1]), function()
      if Table_SceneBossAnime[cfg[2]] then
        local objID = Table_SceneBossAnime[cfg[2]].ObjID
        local name = Table_SceneBossAnime[cfg[2]].Name
        Game.GameObjectManagers[Game.GameObjectType.SceneBossAnime]:ExplicitlyPlaySceneAnime(objID, name, 1)
      end
      if restoreViewData then
        FunctionNpcFunc.JumpPanel(PanelConfig.AierBlacksmithPanel, restoreViewData)
      end
    end)
    return result
  end
end

function AierBlacksmithProxy:Query_MainNpcID()
  local changed_b = QuestProxy.Instance:isQuestComplete(GameConfig.Smithy.MainNpcChangeQuestID_B or -1)
  local changed_c = QuestProxy.Instance:isQuestComplete(GameConfig.Smithy.MainNpcChangeQuestID_C or -1)
  if changed_c then
    return GameConfig.Smithy.MainNpcC
  elseif changed_b then
    return GameConfig.Smithy.MainNpcB
  else
    return GameConfig.Smithy.MainNpcA
  end
end

function AierBlacksmithProxy:Query_CurrentSceneBossAnime()
  local level = self.proxyData.level
  for i = #self.configData.PlayUpgradeBehaviorGap, 1, -1 do
    local lv = self.configData.PlayUpgradeBehaviorGap[i]
    if level >= lv then
      return self.configData.ModelSceneBossAnime[i]
    end
  end
end

function AierBlacksmithProxy:Query_IsNpcHelpStatus(npcid)
  if not npcid or npcid == 0 then
    return
  end
  for _, v in ipairs(self.proxyData.quests) do
    if v.help_partner == npcid then
      if v.quest_state ~= ESMITHQUESTSTATE.ESMITH_QUEST_DONE then
        return 0
      else
        return 1
      end
    end
  end
end

function AierBlacksmithProxy:Query_AllNpcList()
  local info = {}
  for k, v in pairs(self.configData.UnlockSmithPartnerGap) do
    local p = {lv = k, npcid = v}
    if TableUtility.ArrayFindIndex(self.proxyData.all_partners, v) > 0 then
      p.unlocked = true
      local help_status = self:Query_IsNpcHelpStatus(v)
      p.help = help_status == 0
      p.help_fin = help_status == 1
    end
    info[#info + 1] = p
  end
  table.sort(info, function(a, b)
    return a.lv < b.lv
  end)
  return info
end

function AierBlacksmithProxy:Query_GetFirstFreeHelper()
  local info, inf = self:Query_AllNpcList()
  for i = 1, #info do
    inf = info[i]
    if not inf.help and not inf.help_fin and inf.unlocked then
      return inf
    end
  end
end

function AierBlacksmithProxy:Query_HelperCountInfo()
  local info, ca, cb = self:Query_AllNpcList(), 0, 0
  for i = 1, #info do
    if info[i].help_fin or info[i].help then
      ca = ca + 1
    end
    if info[i].unlocked then
      cb = cb + 1
    end
  end
  return ca, cb
end

function AierBlacksmithProxy:Query_GetFirstCanAcceptQuest()
  local q
  for i = 1, #self.proxyData.quests do
    q = self.proxyData.quests[i]
    if q.quest_state == ESMITHQUESTSTATE.ESMITH_QUEST_MIN then
      return q
    end
  end
  for i = 1, #self.proxyData.quests do
    q = self.proxyData.quests[i]
    if q.quest_state == ESMITHQUESTSTATE.ESMITH_QUEST_ACCEPTED then
      return q, true
    end
  end
end

function AierBlacksmithProxy:Query_NextLevelReward()
  local maxLevel = #Table_SmithLevel
  if maxLevel <= self.proxyData.level then
    return
  end
  local info = Table_SmithLevel[self.proxyData.level + 1]
  info = info and info.Reward
  info = info and ItemUtil.GetRewardItemIdsByTeamId(info)
  return info
end

function AierBlacksmithProxy:Query_UpgradeNeedItemCount(lv)
  return self.configData.UpgradeCost[lv] or 0
end

function AierBlacksmithProxy:Query_UpgradeItemCount()
  return BagProxy.Instance:GetItemNumByStaticID(self.configData.UpgradeCostItem)
end

function AierBlacksmithProxy:Query_SubQuestInfo()
  local check_quest, finished
  self.proxyData.sub_quests = {}
  local group, group_a, group_f, v = {}, {}, {}
  for i = 1, #Table_SmithSubQuest do
    v = Table_SmithSubQuest[i]
    if v.NextVersion ~= 1 and #v.QuestID > 0 then
      check_quest = v.QuestID[#v.QuestID]
      finished = QuestProxy.Instance:isQuestComplete(check_quest)
    else
      finished = false
    end
    if v.GroupID then
      if not group_a[v.GroupID] then
        if finished then
          group_f[v.GroupID] = i
        else
          group_a[v.GroupID] = i
        end
      end
      if 0 >= TableUtility.ArrayFindIndex(group, v.GroupID) then
        group[#group + 1] = v.GroupID
      end
    else
      TableUtility.ArrayPushBack(self.proxyData.sub_quests, {
        ids = v.QuestID,
        finished = finished,
        info = v
      })
    end
  end
  local a, f
  for i = 1, #group do
    a = group_a[group[i]]
    f = group_f[group[i]]
    if a then
      v = Table_SmithSubQuest[a]
      TableUtility.ArrayPushBack(self.proxyData.sub_quests, {
        ids = v.QuestID,
        finished = false,
        info = v
      })
    elseif f then
      v = Table_SmithSubQuest[f]
      TableUtility.ArrayPushBack(self.proxyData.sub_quests, {
        ids = v.QuestID,
        finished = true,
        info = v
      })
    end
  end
  for i = 1, #self.proxyData.sub_quests do
    local v = self.proxyData.sub_quests[i]
    local level_ok = v.info.UnlockLevel <= self.proxyData.level
    local pre_quest_ok = not v.info.PreQuestID or v.info.PreQuestID == 0 or QuestProxy.Instance:isQuestComplete(v.info.PreQuestID)
    local order = 1
    if v.info.NextVersion == 1 then
      order = 4
    elseif v.finished then
      order = 3
    elseif not level_ok or not pre_quest_ok then
      order = 2
    end
    v.level_ok = level_ok
    v.pre_quest_ok = pre_quest_ok
    v.order = order
  end
  table.sort(self.proxyData.sub_quests, function(a, b)
    if a.order ~= b.order then
      return a.order < b.order
    end
    return a.info.id < b.info.id
  end)
end

local pageCells = 6

function AierBlacksmithProxy:Query_MonsterPeriodicRewardPageCount()
  local sum = #self.proxyData.monster_periodic_reward
  return math.ceil(sum / pageCells)
end

function AierBlacksmithProxy:Query_MonsterPeriodicRewardPage(page)
  local content = {}
  local sum = #self.proxyData.monster_periodic_reward
  local maxp = math.ceil(sum / pageCells)
  if page <= maxp then
    local s = pageCells * (page - 1) + 1
    local e = math.min(sum, pageCells * page)
    for i = s, e do
      content[#content + 1] = self.proxyData.monster_periodic_reward[i]
    end
  end
  return content
end

function AierBlacksmithProxy:Query_GetRandomTalk()
  local idx
  if self.proxyData.level > 0 then
    idx = math.floor(math.max(0, self.proxyData.level - 1) / 5) + 2
  else
    idx = 1
  end
  local randomTalk = GameConfig.Smithy.RandomTalkCfg[idx]
  idx = math.random(1, #randomTalk)
  return randomTalk[idx]
end

function AierBlacksmithProxy:RedTip_UpdateUpgradeTip()
  local lv = AierBlacksmithProxy.Instance.proxyData.level or 0
  local max_lv = AierBlacksmithProxy.Instance.configData.MaxLevel
  local next_lv = math.min(lv + 1, max_lv)
  local needCount = AierBlacksmithProxy.Instance:Query_UpgradeNeedItemCount(next_lv)
  local haveCount = AierBlacksmithProxy.Instance:Query_UpgradeItemCount()
  if lv >= max_lv or needCount > haveCount then
    return false
  else
    return true
  end
end

function AierBlacksmithProxy:RedTip_Update()
  if self:RedTip_UpdateUpgradeTip() then
    RedTipProxy.Instance:UpdateRedTip(GameConfig.Smithy.UpgradeRedTip)
  else
    RedTipProxy.Instance:RemoveWholeTip(GameConfig.Smithy.UpgradeRedTip)
  end
end

AierBlacksmithTestMe = class("AierBlacksmithTestMe")
local TEST = false
local server_delay = 1000
local _quests, _all_partners, _level, _killed_monsters

function AierBlacksmithTestMe.Me()
  if nil == AierBlacksmithTestMe.me then
    AierBlacksmithTestMe.me = AierBlacksmithTestMe.new()
  end
  return AierBlacksmithTestMe.me
end

function AierBlacksmithTestMe:ctor()
  self:___GenerateData()
end

function AierBlacksmithTestMe:___GenerateData()
  _quests = {
    {
      questid = 100643,
      quest_state = ESMITHQUESTSTATE.ESMITH_QUEST_ACCEPTED
    },
    {
      questid = 100646,
      quest_state = ESMITHQUESTSTATE.ESMITH_QUEST_HELPED,
      has_finished = true,
      help_partner = 1013,
      help_finish_time = ServerTime.CurServerTime() + 1000000
    },
    {
      questid = 100649,
      quest_state = ESMITHQUESTSTATE.ESMITH_QUEST_DONE
    },
    {
      questid = 100650,
      quest_state = ESMITHQUESTSTATE.ESMITH_QUEST_MIN,
      has_finished = true
    },
    {
      questid = 100651,
      quest_state = ESMITHQUESTSTATE.ESMITH_QUEST_MIN
    }
  }
  _all_partners = {1013}
  _level = 11
  _killed_monsters = {
    10001,
    10002,
    10003,
    10004,
    10005,
    10006,
    10007,
    10008,
    10009,
    10010,
    10011,
    10012,
    10013,
    10014,
    10015
  }
end

function AierBlacksmithTestMe:CallSmithInfoManorCmd()
  if TEST then
    local data = {
      quests = _quests,
      all_partners = _all_partners,
      level = _level
    }
    TimeTickManager.Me():CreateOnceDelayTick(server_delay, function()
      ServiceSceneManorProxy.Instance:RecvSmithInfoManorCmd(data)
    end, self)
  else
    ServiceSceneManorProxy.Instance:CallSmithInfoManorCmd()
  end
end

function AierBlacksmithTestMe:CallSmithLevelUpManorCmd()
  if TEST then
    _level = _level + 1
    local data = {
      quests = _quests,
      all_partners = _all_partners,
      level = _level
    }
    TimeTickManager.Me():CreateOnceDelayTick(server_delay, function()
      ServiceSceneManorProxy.Instance:RecvSmithInfoManorCmd(data)
    end, self)
  else
    ServiceSceneManorProxy.Instance:CallSmithLevelUpManorCmd()
  end
end

function AierBlacksmithTestMe:CallSmithAcceptQuestManorCmd(questid, help_npcid)
  AierBlacksmithProxy.Instance:TryProcessQuestTrace(questid)
  if TEST then
  else
    ServiceSceneManorProxy.Instance:CallSmithAcceptQuestManorCmd(questid, help_npcid)
  end
end

function AierBlacksmithTestMe:CallReqPeriodicMonsterUserEvent()
  if TEST then
    local data = {killed_monsters = _killed_monsters}
    TimeTickManager.Me():CreateOnceDelayTick(server_delay, function()
      ServiceUserEventProxy.Instance:RecvReqPeriodicMonsterUserEvent(data)
    end, self)
  else
    ServiceUserEventProxy.Instance:CallReqPeriodicMonsterUserEvent()
  end
end
