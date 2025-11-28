ServiceSceneManualAutoProxy = class("ServiceSceneManualAutoProxy", ServiceProxy)
ServiceSceneManualAutoProxy.Instance = nil
ServiceSceneManualAutoProxy.NAME = "ServiceSceneManualAutoProxy"

function ServiceSceneManualAutoProxy:ctor(proxyName)
  if ServiceSceneManualAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceSceneManualAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSceneManualAutoProxy.Instance = self
  end
end

function ServiceSceneManualAutoProxy:Init()
end

function ServiceSceneManualAutoProxy:onRegister()
  self:Listen(23, 1, function(data)
    self:RecvQueryVersion(data)
  end)
  self:Listen(23, 2, function(data)
    self:RecvQueryManualData(data)
  end)
  self:Listen(23, 3, function(data)
    self:RecvPointSync(data)
  end)
  self:Listen(23, 4, function(data)
    self:RecvManualUpdate(data)
  end)
  self:Listen(23, 5, function(data)
    self:RecvGetAchieveReward(data)
  end)
  self:Listen(23, 6, function(data)
    self:RecvUnlock(data)
  end)
  self:Listen(23, 7, function(data)
    self:RecvSkillPointSync(data)
  end)
  self:Listen(23, 8, function(data)
    self:RecvLevelSync(data)
  end)
  self:Listen(23, 9, function(data)
    self:RecvGetQuestReward(data)
  end)
  self:Listen(23, 10, function(data)
    self:RecvStoreManualCmd(data)
  end)
  self:Listen(23, 11, function(data)
    self:RecvGetManualCmd(data)
  end)
  self:Listen(23, 12, function(data)
    self:RecvGroupActionManualCmd(data)
  end)
  self:Listen(23, 13, function(data)
    self:RecvQueryUnsolvedPhotoManualCmd(data)
  end)
  self:Listen(23, 14, function(data)
    self:RecvUpdateSolvedPhotoManualCmd(data)
  end)
  self:Listen(23, 15, function(data)
    self:RecvNpcZoneDataManualCmd(data)
  end)
  self:Listen(23, 16, function(data)
    self:RecvNpcZoneRewardManualCmd(data)
  end)
  self:Listen(23, 17, function(data)
    self:RecvCollectionRewardManualCmd(data)
  end)
  self:Listen(23, 18, function(data)
    self:RecvUnlockQuickManualCmd(data)
  end)
  self:Listen(23, 19, function(data)
    self:RecvGetQuestRewardQuickManualCmd(data)
  end)
end

function ServiceSceneManualAutoProxy:CallQueryVersion(versions)
  if not NetConfig.PBC then
    local msg = SceneManual_pb.QueryVersion()
    if versions ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.versions == nil then
        msg.versions = {}
      end
      for i = 1, #versions do
        table.insert(msg.versions, versions[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryVersion.id
    local msgParam = {}
    if versions ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.versions == nil then
        msgParam.versions = {}
      end
      for i = 1, #versions do
        table.insert(msgParam.versions, versions[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneManualAutoProxy:CallQueryManualData(type, item)
  if not NetConfig.PBC then
    local msg = SceneManual_pb.QueryManualData()
    if type ~= nil then
      msg.type = type
    end
    if item ~= nil and item.type ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.type = item.type
    end
    if item ~= nil and item.version ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.version = item.version
    end
    if item ~= nil and item.items ~= nil then
      if msg.item == nil then
        msg.item = {}
      end
      if msg.item.items == nil then
        msg.item.items = {}
      end
      for i = 1, #item.items do
        table.insert(msg.item.items, item.items[i])
      end
    end
    if item ~= nil and item.quests ~= nil then
      if msg.item == nil then
        msg.item = {}
      end
      if msg.item.quests == nil then
        msg.item.quests = {}
      end
      for i = 1, #item.quests do
        table.insert(msg.item.quests, item.quests[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryManualData.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if item ~= nil and item.type ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.type = item.type
    end
    if item ~= nil and item.version ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.version = item.version
    end
    if item ~= nil and item.items ~= nil then
      if msgParam.item == nil then
        msgParam.item = {}
      end
      if msgParam.item.items == nil then
        msgParam.item.items = {}
      end
      for i = 1, #item.items do
        table.insert(msgParam.item.items, item.items[i])
      end
    end
    if item ~= nil and item.quests ~= nil then
      if msgParam.item == nil then
        msgParam.item = {}
      end
      if msgParam.item.quests == nil then
        msgParam.item.quests = {}
      end
      for i = 1, #item.quests do
        table.insert(msgParam.item.quests, item.quests[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneManualAutoProxy:CallPointSync(point)
  if not NetConfig.PBC then
    local msg = SceneManual_pb.PointSync()
    if point ~= nil then
      msg.point = point
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PointSync.id
    local msgParam = {}
    if point ~= nil then
      msgParam.point = point
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneManualAutoProxy:CallManualUpdate(update)
  if not NetConfig.PBC then
    local msg = SceneManual_pb.ManualUpdate()
    if update ~= nil and update.type ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.update == nil then
        msg.update = {}
      end
      msg.update.type = update.type
    end
    if update ~= nil and update.version ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.update == nil then
        msg.update = {}
      end
      msg.update.version = update.version
    end
    if update ~= nil and update.items ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.items == nil then
        msg.update.items = {}
      end
      for i = 1, #update.items do
        table.insert(msg.update.items, update.items[i])
      end
    end
    if update ~= nil and update.quests ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.quests == nil then
        msg.update.quests = {}
      end
      for i = 1, #update.quests do
        table.insert(msg.update.quests, update.quests[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ManualUpdate.id
    local msgParam = {}
    if update ~= nil and update.type ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.update == nil then
        msgParam.update = {}
      end
      msgParam.update.type = update.type
    end
    if update ~= nil and update.version ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.update == nil then
        msgParam.update = {}
      end
      msgParam.update.version = update.version
    end
    if update ~= nil and update.items ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.items == nil then
        msgParam.update.items = {}
      end
      for i = 1, #update.items do
        table.insert(msgParam.update.items, update.items[i])
      end
    end
    if update ~= nil and update.quests ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.quests == nil then
        msgParam.update.quests = {}
      end
      for i = 1, #update.quests do
        table.insert(msgParam.update.quests, update.quests[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneManualAutoProxy:CallGetAchieveReward(id)
  if not NetConfig.PBC then
    local msg = SceneManual_pb.GetAchieveReward()
    if id ~= nil then
      msg.id = id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GetAchieveReward.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneManualAutoProxy:CallUnlock(type, id)
  if not NetConfig.PBC then
    local msg = SceneManual_pb.Unlock()
    if type ~= nil then
      msg.type = type
    end
    if id ~= nil then
      msg.id = id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.Unlock.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if id ~= nil then
      msgParam.id = id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneManualAutoProxy:CallSkillPointSync(skillpoint)
  if not NetConfig.PBC then
    local msg = SceneManual_pb.SkillPointSync()
    if skillpoint ~= nil then
      msg.skillpoint = skillpoint
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SkillPointSync.id
    local msgParam = {}
    if skillpoint ~= nil then
      msgParam.skillpoint = skillpoint
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneManualAutoProxy:CallLevelSync(level)
  if not NetConfig.PBC then
    local msg = SceneManual_pb.LevelSync()
    if level ~= nil then
      msg.level = level
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.LevelSync.id
    local msgParam = {}
    if level ~= nil then
      msgParam.level = level
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneManualAutoProxy:CallGetQuestReward(appendid)
  if not NetConfig.PBC then
    local msg = SceneManual_pb.GetQuestReward()
    if appendid ~= nil then
      msg.appendid = appendid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GetQuestReward.id
    local msgParam = {}
    if appendid ~= nil then
      msgParam.appendid = appendid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneManualAutoProxy:CallStoreManualCmd(type, guid)
  if not NetConfig.PBC then
    local msg = SceneManual_pb.StoreManualCmd()
    if type ~= nil then
      msg.type = type
    end
    if guid ~= nil then
      msg.guid = guid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.StoreManualCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if guid ~= nil then
      msgParam.guid = guid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneManualAutoProxy:CallGetManualCmd(type, itemid)
  if not NetConfig.PBC then
    local msg = SceneManual_pb.GetManualCmd()
    if type ~= nil then
      msg.type = type
    end
    if itemid ~= nil then
      msg.itemid = itemid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GetManualCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneManualAutoProxy:CallGroupActionManualCmd(action, group_id)
  if not NetConfig.PBC then
    local msg = SceneManual_pb.GroupActionManualCmd()
    if action ~= nil then
      msg.action = action
    end
    if group_id ~= nil then
      msg.group_id = group_id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GroupActionManualCmd.id
    local msgParam = {}
    if action ~= nil then
      msgParam.action = action
    end
    if group_id ~= nil then
      msgParam.group_id = group_id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneManualAutoProxy:CallQueryUnsolvedPhotoManualCmd(photos, time)
  if not NetConfig.PBC then
    local msg = SceneManual_pb.QueryUnsolvedPhotoManualCmd()
    if photos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.photos == nil then
        msg.photos = {}
      end
      for i = 1, #photos do
        table.insert(msg.photos, photos[i])
      end
    end
    if time ~= nil then
      msg.time = time
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryUnsolvedPhotoManualCmd.id
    local msgParam = {}
    if photos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.photos == nil then
        msgParam.photos = {}
      end
      for i = 1, #photos do
        table.insert(msgParam.photos, photos[i])
      end
    end
    if time ~= nil then
      msgParam.time = time
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneManualAutoProxy:CallUpdateSolvedPhotoManualCmd(charid, sceneryid)
  if not NetConfig.PBC then
    local msg = SceneManual_pb.UpdateSolvedPhotoManualCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    if sceneryid ~= nil then
      msg.sceneryid = sceneryid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateSolvedPhotoManualCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if sceneryid ~= nil then
      msgParam.sceneryid = sceneryid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneManualAutoProxy:CallNpcZoneDataManualCmd(datas, bupdate)
  if not NetConfig.PBC then
    local msg = SceneManual_pb.NpcZoneDataManualCmd()
    if datas ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.datas == nil then
        msg.datas = {}
      end
      for i = 1, #datas do
        table.insert(msg.datas, datas[i])
      end
    end
    if bupdate ~= nil then
      msg.bupdate = bupdate
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NpcZoneDataManualCmd.id
    local msgParam = {}
    if datas ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.datas == nil then
        msgParam.datas = {}
      end
      for i = 1, #datas do
        table.insert(msgParam.datas, datas[i])
      end
    end
    if bupdate ~= nil then
      msgParam.bupdate = bupdate
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneManualAutoProxy:CallNpcZoneRewardManualCmd(id, type)
  if not NetConfig.PBC then
    local msg = SceneManual_pb.NpcZoneRewardManualCmd()
    if id ~= nil then
      msg.id = id
    end
    if type ~= nil then
      msg.type = type
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NpcZoneRewardManualCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if type ~= nil then
      msgParam.type = type
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneManualAutoProxy:CallCollectionRewardManualCmd(items)
  if not NetConfig.PBC then
    local msg = SceneManual_pb.CollectionRewardManualCmd()
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CollectionRewardManualCmd.id
    local msgParam = {}
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneManualAutoProxy:CallUnlockQuickManualCmd(lists, foodlists)
  if not NetConfig.PBC then
    local msg = SceneManual_pb.UnlockQuickManualCmd()
    if lists ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.lists == nil then
        msg.lists = {}
      end
      for i = 1, #lists do
        table.insert(msg.lists, lists[i])
      end
    end
    if foodlists ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.foodlists == nil then
        msg.foodlists = {}
      end
      for i = 1, #foodlists do
        table.insert(msg.foodlists, foodlists[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UnlockQuickManualCmd.id
    local msgParam = {}
    if lists ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.lists == nil then
        msgParam.lists = {}
      end
      for i = 1, #lists do
        table.insert(msgParam.lists, lists[i])
      end
    end
    if foodlists ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.foodlists == nil then
        msgParam.foodlists = {}
      end
      for i = 1, #foodlists do
        table.insert(msgParam.foodlists, foodlists[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneManualAutoProxy:CallGetQuestRewardQuickManualCmd(appendids)
  if not NetConfig.PBC then
    local msg = SceneManual_pb.GetQuestRewardQuickManualCmd()
    if appendids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.appendids == nil then
        msg.appendids = {}
      end
      for i = 1, #appendids do
        table.insert(msg.appendids, appendids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GetQuestRewardQuickManualCmd.id
    local msgParam = {}
    if appendids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.appendids == nil then
        msgParam.appendids = {}
      end
      for i = 1, #appendids do
        table.insert(msgParam.appendids, appendids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneManualAutoProxy:RecvQueryVersion(data)
  self:Notify(ServiceEvent.SceneManualQueryVersion, data)
end

function ServiceSceneManualAutoProxy:RecvQueryManualData(data)
  self:Notify(ServiceEvent.SceneManualQueryManualData, data)
end

function ServiceSceneManualAutoProxy:RecvPointSync(data)
  self:Notify(ServiceEvent.SceneManualPointSync, data)
end

function ServiceSceneManualAutoProxy:RecvManualUpdate(data)
  self:Notify(ServiceEvent.SceneManualManualUpdate, data)
end

function ServiceSceneManualAutoProxy:RecvGetAchieveReward(data)
  self:Notify(ServiceEvent.SceneManualGetAchieveReward, data)
end

function ServiceSceneManualAutoProxy:RecvUnlock(data)
  self:Notify(ServiceEvent.SceneManualUnlock, data)
end

function ServiceSceneManualAutoProxy:RecvSkillPointSync(data)
  self:Notify(ServiceEvent.SceneManualSkillPointSync, data)
end

function ServiceSceneManualAutoProxy:RecvLevelSync(data)
  self:Notify(ServiceEvent.SceneManualLevelSync, data)
end

function ServiceSceneManualAutoProxy:RecvGetQuestReward(data)
  self:Notify(ServiceEvent.SceneManualGetQuestReward, data)
end

function ServiceSceneManualAutoProxy:RecvStoreManualCmd(data)
  self:Notify(ServiceEvent.SceneManualStoreManualCmd, data)
end

function ServiceSceneManualAutoProxy:RecvGetManualCmd(data)
  self:Notify(ServiceEvent.SceneManualGetManualCmd, data)
end

function ServiceSceneManualAutoProxy:RecvGroupActionManualCmd(data)
  self:Notify(ServiceEvent.SceneManualGroupActionManualCmd, data)
end

function ServiceSceneManualAutoProxy:RecvQueryUnsolvedPhotoManualCmd(data)
  self:Notify(ServiceEvent.SceneManualQueryUnsolvedPhotoManualCmd, data)
end

function ServiceSceneManualAutoProxy:RecvUpdateSolvedPhotoManualCmd(data)
  self:Notify(ServiceEvent.SceneManualUpdateSolvedPhotoManualCmd, data)
end

function ServiceSceneManualAutoProxy:RecvNpcZoneDataManualCmd(data)
  self:Notify(ServiceEvent.SceneManualNpcZoneDataManualCmd, data)
end

function ServiceSceneManualAutoProxy:RecvNpcZoneRewardManualCmd(data)
  self:Notify(ServiceEvent.SceneManualNpcZoneRewardManualCmd, data)
end

function ServiceSceneManualAutoProxy:RecvCollectionRewardManualCmd(data)
  self:Notify(ServiceEvent.SceneManualCollectionRewardManualCmd, data)
end

function ServiceSceneManualAutoProxy:RecvUnlockQuickManualCmd(data)
  self:Notify(ServiceEvent.SceneManualUnlockQuickManualCmd, data)
end

function ServiceSceneManualAutoProxy:RecvGetQuestRewardQuickManualCmd(data)
  self:Notify(ServiceEvent.SceneManualGetQuestRewardQuickManualCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.SceneManualQueryVersion = "ServiceEvent_SceneManualQueryVersion"
ServiceEvent.SceneManualQueryManualData = "ServiceEvent_SceneManualQueryManualData"
ServiceEvent.SceneManualPointSync = "ServiceEvent_SceneManualPointSync"
ServiceEvent.SceneManualManualUpdate = "ServiceEvent_SceneManualManualUpdate"
ServiceEvent.SceneManualGetAchieveReward = "ServiceEvent_SceneManualGetAchieveReward"
ServiceEvent.SceneManualUnlock = "ServiceEvent_SceneManualUnlock"
ServiceEvent.SceneManualSkillPointSync = "ServiceEvent_SceneManualSkillPointSync"
ServiceEvent.SceneManualLevelSync = "ServiceEvent_SceneManualLevelSync"
ServiceEvent.SceneManualGetQuestReward = "ServiceEvent_SceneManualGetQuestReward"
ServiceEvent.SceneManualStoreManualCmd = "ServiceEvent_SceneManualStoreManualCmd"
ServiceEvent.SceneManualGetManualCmd = "ServiceEvent_SceneManualGetManualCmd"
ServiceEvent.SceneManualGroupActionManualCmd = "ServiceEvent_SceneManualGroupActionManualCmd"
ServiceEvent.SceneManualQueryUnsolvedPhotoManualCmd = "ServiceEvent_SceneManualQueryUnsolvedPhotoManualCmd"
ServiceEvent.SceneManualUpdateSolvedPhotoManualCmd = "ServiceEvent_SceneManualUpdateSolvedPhotoManualCmd"
ServiceEvent.SceneManualNpcZoneDataManualCmd = "ServiceEvent_SceneManualNpcZoneDataManualCmd"
ServiceEvent.SceneManualNpcZoneRewardManualCmd = "ServiceEvent_SceneManualNpcZoneRewardManualCmd"
ServiceEvent.SceneManualCollectionRewardManualCmd = "ServiceEvent_SceneManualCollectionRewardManualCmd"
ServiceEvent.SceneManualUnlockQuickManualCmd = "ServiceEvent_SceneManualUnlockQuickManualCmd"
ServiceEvent.SceneManualGetQuestRewardQuickManualCmd = "ServiceEvent_SceneManualGetQuestRewardQuickManualCmd"
