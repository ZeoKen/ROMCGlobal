autoImport("TopicTargetData")
TopicProxy = class("TopicProxy", pm.Proxy)
TopicProxy.Instance = nil
TopicProxy.NAME = "TopicProxy"

function TopicProxy:ctor(proxyName, data)
  self.proxyName = proxyName or TopicProxy.NAME
  if TopicProxy.Instance == nil then
    TopicProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function TopicProxy:Init()
  self.topicList = {}
  self.topicLayer = {}
  self:InitStatic()
end

function TopicProxy:HandleServantTarget(server_datas)
  redlog("TopicProxy:HandleServantTarget")
  TableUtil.Print(server_datas)
  if not server_datas then
    return
  end
  for i = 1, #server_datas do
    self:UpdateServantQuestDatas(server_datas[i])
  end
end

function TopicProxy:UpdateServantQuestDatas(server_data)
  local id = server_data.id
  local staticData = Table_ServantChallenge[id]
  if not staticData then
    redlog("前后端表不一致 服务器ServantChallenge表ID: ", id)
    return
  end
  local topic = staticData.Day
  local targetData = self:GetQuestData(topic, id)
  if targetData then
    targetData:Update(server_data)
  end
  if self.topicList[topic] then
    TableUtility.ArrayClear(self.topicList[topic])
  end
end

function TopicProxy:GetQuestData(topic, id)
  if self.topicMap[topic] then
    return self.topicMap[topic][id]
  end
end

function TopicProxy:GetQuests(topic)
  local list = self.topicList[topic]
  if not list or not next(list) then
    list = TableUtil.HashToArray(self.topicMap[topic])
    table.sort(list, function(a, b)
      if a.sort == b.sort then
        return a.id < b.id
      else
        return a.sort < b.sort
      end
    end)
    self.topicList[topic] = list
  end
  return list
end

function TopicProxy:InitQuestStaticData()
  if not Table_ServantChallenge then
    return
  end
  if self.topicMap then
    return
  end
  self.topicMap = {}
  self.topicIDs = {}
  local _TopicMap
  for k, v in pairs(Table_ServantChallenge) do
    if v.Day and v.id then
      _TopicMap = self.topicMap[v.Day]
      if not _TopicMap then
        _TopicMap = {}
        self.topicIDs[#self.topicIDs + 1] = v.Day
      end
      local data = TopicTargetData.new(v.id)
      _TopicMap[data.id] = data
      self.topicMap[v.Day] = _TopicMap
    end
  end
  table.sort(self.topicIDs)
  self.curMinTopic = self.topicIDs[1]
  self.curMaxTopic = self.topicIDs[1]
  self.maxTopic = self.topicIDs[#self.topicIDs]
end

function TopicProxy:InitStatic()
  self:InitQuestStaticData()
  self:InitLayerStaticData()
end

function TopicProxy:InitLayerStaticData()
  local layerConfig = Table_ServantChallengeLayer
  if not layerConfig then
    return
  end
  local list, topic
  for i = 1, #layerConfig do
    topic = layerConfig[i].Topic
    list = self.topicLayer[topic]
    list = list or {}
    list[#list + 1] = {
      staticData = layerConfig[i]
    }
    self.topicLayer[topic] = list
  end
end

function TopicProxy:GetLayerDataByTopic(t)
  return self.topicLayer[t]
end

function TopicProxy:GetCurTopicIndex()
  return self.curMaxTopic, self.curMinTopic
end

function TopicProxy:CheckTopicUnlock(t)
  local questMap = self.topicMap[t]
  for id, data in pairs(questMap) do
    if not data:IsRewarded() then
      return false
    end
  end
  return true
end

function TopicProxy:ResetCurMaxTopic()
  local challengeTowerLayer = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_CHALLENGE_ENDLESS) or 0
  local maxTopic
  for i = 1, #self.topicLayer do
    if maxTopic then
      break
    end
    for j = 1, #self.topicLayer[i] do
      if challengeTowerLayer < self.topicLayer[i][j].staticData.id then
        maxTopic = i
        break
      end
    end
  end
  self.curMaxTopic = maxTopic or #self.topicLayer
end
