ReturnActivityProxy = class("ReturnActivityProxy", pm.Proxy)

function ReturnActivityProxy:ctor(proxyName, data)
  self.proxyName = proxyName or "ReturnActivityProxy"
  if ReturnActivityProxy.Instance == nil then
    ReturnActivityProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function ReturnActivityProxy:Init()
  self.globalActMap = {}
  self.isFirstOpen = true
  self.userReturnInviteData = {}
  self.userReturnInviteData.invitenum = 0
  self.userInviteData = {}
  self.userInviteData.awardid = {}
  self.userInviteData.records = {}
end

function ReturnActivityProxy:RecvUserReturnInfoCmd(data)
  self.activityEndTime = data.endtime
  self.loginDay = data.loginday
  if not self.awardDays then
    self.awardDays = {}
  end
  TableUtility.TableShallowCopy(self.awardDays, data.awardday)
  if not self.quests then
    self.quests = {}
  end
  local quests = data.quests
  if quests and 0 < #quests then
    for i = 1, #quests do
      local single = quests[i]
      local id = single.id
      if Table_Mission[id] then
        local data = {}
        TableUtility.TableShallowCopy(data, single)
        if data.process >= data.goal then
          data.finish = true
        end
        data.finish = data.process >= data.goal
        self.quests[id] = data
      end
    end
  end
  self.bBind = data.bBind
end

function ReturnActivityProxy:RecvUserReturnQuestAddCmd(data)
  local quest = data.quest
  local id = quest.id
  if Table_Mission[id] then
    local data = {}
    TableUtility.TableShallowCopy(data, quest)
    data.finish = data.process >= data.goal
    self.quests[id] = data
  end
end

function ReturnActivityProxy:RecvUserReturnLoginAwardCmd(data)
  local days = data.day
  if days and 0 < #days then
    if not self.awardDays then
      self.awardDays = {}
    end
    for i = 1, #days do
      local day = days[i]
      table.insert(self.awardDays, day)
    end
  end
end

function ReturnActivityProxy:RecvUserReturnQuestAwardCmd(data)
  local id = data.id
  local rewarded = data.success
  xdlog("rewarded", rewarded)
  if not self.quests[id] or not rewarded then
    redlog("任务列表不存在任务ID", id)
    return
  end
  xdlog("任务奖励切换", id, rewarded)
  self.quests[id].awarded = rewarded
end

function ReturnActivityProxy:RecvUserReturnInviteActivityNtfCmd(data)
  local id = data.activityid
  self.userReturnInviteID = id
end

function ReturnActivityProxy:RecvUserReturnBindCmd(data)
  local success = data.success
  if success then
    self.bBind = true
  end
end

function ReturnActivityProxy:RecvUserInviteCmd(data)
  self.userInviteData.code = data.code
  self.userInviteData.hasnewinvite = data.hasnewinvite
  self.userInviteData.awardid = {}
  if data.awardid then
    for i = 1, #data.awardid do
      self.userInviteData.awardid[data.awardid[i]] = data.awardid[i]
    end
  end
  self.userInviteData.records = {}
end

function ReturnActivityProxy:RecvUserInviteAwardCmd(data)
  if data.awardid then
    for i = 1, #data.awardid do
      self.userInviteData.awardid[data.awardid[i]] = data.awardid[i]
    end
  end
end

function ReturnActivityProxy:GetActivityState(id)
  local state = EAWARDSTATE.EAWARD_STATE_PROHIBIT
  for i = 1, #ReturnActivityProxy.Instance.userInviteData.awardid do
    if ReturnActivityProxy.Instance.userInviteData.awardid[i].id == id then
      state = ReturnActivityProxy.Instance.userInviteData.awardid[i].state
      break
    end
  end
  return state
end

function ReturnActivityProxy:RecvUserReturnInviteCmd(data)
  self.userReturnInviteData.code = data.code
  self.userReturnInviteData.hasnewinvite = data.hasnewinvite
  self.userReturnInviteData.invitenum = data.invitenum
  self.userReturnInviteData.got_share_reward = data.got_share_reward
  self.userReturnInviteData.records = {}
  if data.records then
    for i = 1, #data.records do
      self.userReturnInviteData.records[i] = {}
      self.userReturnInviteData.records[i] = data.records[i]
    end
  end
  if data.awardid then
    self.userReturnInviteData.awardid = {}
    for i = 1, #data.awardid do
      self.userReturnInviteData.awardid[data.awardid[i]] = data.awardid[i]
    end
  end
end

function ReturnActivityProxy:RecvUserReturnInviteRecordCmd(data)
  if data.records then
    self.userReturnInviteData.records = {}
    self.userInviteData.records = {}
    for i = 1, #data.records do
      self.userReturnInviteData.records[i] = {}
      self.userReturnInviteData.records[i].charid = data.records[i].charid
      self.userReturnInviteData.records[i].name = data.records[i].name
      self.userReturnInviteData.records[i].time = data.records[i].time
      self.userReturnInviteData.records[i].portrait = {}
      TableUtility.TableShallowCopy(self.userReturnInviteData.records[i].portrait, data.records[i].portrait)
      self.userInviteData.records[i] = {}
      self.userInviteData.records[i].charid = data.records[i].charid
      self.userInviteData.records[i].name = data.records[i].name
      self.userInviteData.records[i].time = data.records[i].time
      self.userInviteData.records[i].portrait = {}
      TableUtility.TableShallowCopy(self.userInviteData.records[i].portrait, data.records[i].portrait)
    end
  end
end

function ReturnActivityProxy:RecvUserReturnInviteAwardCmd(data)
  if data.success and data.awardid and data.awardid[1] then
    if self.userReturnInviteData.awardid then
      self.userReturnInviteData.awardid[data.awardid[1]] = data.awardid[1]
    else
      self.userReturnInviteData.awardid = {}
      self.userReturnInviteData.awardid[data.awardid[1]] = data.awardid[1]
    end
  end
end

function ReturnActivityProxy:RecvUserReturnShareAwardCmd(data)
  if self.userReturnInviteData then
    self.userReturnInviteData.got_share_reward = true
  end
end

function ReturnActivityProxy:GetReturnLoginInfo()
  if self.awardDays then
    return self.awardDays
  end
end

function ReturnActivityProxy:GetReturnTaskInfo()
  if self.quests then
    return self.quests
  end
end

function ReturnActivityProxy:GetActivityEnterValid()
  local flag = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_USERRETURN_FLAG) or 0
  if flag ~= 0 then
    self.curActID = flag
    self.shopID = GameConfig.Return.Feature[self.curActID] and GameConfig.Return.Feature[self.curActID].ShopID or 1
    self.costID = GameConfig.Return.Feature[self.curActID] and GameConfig.Return.Feature[self.curActID].ShopItemID or 3004942
    self.shopType = GameConfig.Return.Feature[self.curActID] and GameConfig.Return.Feature[self.curActID].ShopType or 20262
    self.shopType2 = GameConfig.Return.Feature[self.curActID] and GameConfig.Return.Feature[self.curActID].ShopType2 or 20262
    return true
  end
  self.curActID = nil
  return false
end

function ReturnActivityProxy:CheckInvitationValid(actid)
  if not actid then
    return
  end
  if not GameConfig.Invitation then
    return false
  end
  for id, info in pairs(GameConfig.Invitation) do
    if info.ReturnActivityId and info.ReturnActivityId == actid then
      return true
    end
  end
  return false
end

function ReturnActivityProxy:IsUserReturnInviteValid(k)
  if self.userReturnInviteID and self.userReturnInviteID == k then
    return true
  end
  return false
end

function ReturnActivityProxy:TryGetLoginReward()
  if not self.loginDay then
    return
  end
  local days = {}
  for i = 1, self.loginDay do
    if self.awardDays and TableUtility.ArrayFindIndex(self.awardDays, i) == 0 then
      xdlog("未签到日期", i)
      table.insert(days, i)
    end
  end
  if 0 < #days then
    xdlog("申请签到")
    ServiceActivityCmdProxy.Instance:CallUserReturnLoginAwardCmd(days)
  end
end

function ReturnActivityProxy:GetActivityEndTime()
  if not self.activityEndTime then
    return
  end
  local leftDay, leftHour, leftMin, leftSec = ClientTimeUtil.GetFormatRefreshTimeStr(self.activityEndTime)
  return leftDay, leftHour, leftMin, leftSec
end

function ReturnActivityProxy:RecommendActData(data)
  self.recommendactData = {}
  for k, v in pairs(data) do
    self.recommendactData[k] = v
  end
end

function ReturnActivityProxy:IsRecommendActOpen(k)
  if self.recommendactData and self.recommendactData.id == k and self.recommendactData.open then
    return true
  end
  return false
end

function ReturnActivityProxy:GetReturnBufferID()
  self:GetActivityEnterValid()
  if not self.curActID then
    return
  end
  local buffID = GameConfig.Return.Feature[self.curActID].BuffID
  return buffID
end
