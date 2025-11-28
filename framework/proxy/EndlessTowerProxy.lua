autoImport("EndlessTowerLayerInfo")
autoImport("EndlessTowerMemberData")
EndlessTowerProxy = class("EndlessTowerProxy", pm.Proxy)
EndlessTowerProxy.Instance = nil
EndlessTowerProxy.NAME = "EndlessTowerProxy"

function EndlessTowerProxy:ctor(proxyName, data)
  self.proxyName = proxyName or EndlessTowerProxy.NAME
  if EndlessTowerProxy.Instance == nil then
    EndlessTowerProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function EndlessTowerProxy:Init()
  EventManager.Me():AddEventListener(DungeonManager.Event.Launched, self.DungeonLaunched, self)
end

function EndlessTowerProxy:RecvTeamTowerSummary(data)
  self.myTeamID = data.teamtower.teamid
  self.curChallengeLayer = data.teamtower.layer
  self.maxlayer = data.maxlayer
  self.refreshtime = data.refreshtime
  self.leaderOldmaxlayer = data.teamtower.leadertower.oldmaxlayer
  self.leaderCurmaxlayer = data.teamtower.leadertower.curmaxlayer
  self.leaderLayersDic = {}
  for i = 1, #data.teamtower.leadertower.layers do
    local layer = data.teamtower.leadertower.layers[i]
    local temp = EndlessTowerLayerInfo.new(layer.layer, layer.rewarded, layer.utime)
    self.leaderLayersDic[temp.layer] = temp
  end
  local everpasslayers = data.teamtower.leadertower.everpasslayers
  self:UpdateEverPassLayers(everpasslayers)
end

function EndlessTowerProxy:RecvUserTowerInfo(data)
  local towerInfo = data.usertower
  self.maxLaunchLayerIndex = nil
  self.historyMaxLayer = towerInfo.oldmaxlayer
  self.weekMaxLayer = towerInfo.curmaxlayer
  self.myMaxLayer = towerInfo.maxlayer
  self.myLayersInfo = {}
  for i = 1, #towerInfo.layers do
    local layer = towerInfo.layers[i]
    local temp = EndlessTowerLayerInfo.new(layer.layer, layer.rewarded, layer.utime)
    self.myLayersInfo[temp.layer] = temp
  end
  self:UpdateEverPassLayers(towerInfo.everpasslayers)
end

function EndlessTowerProxy:GetMaxLaunchLayer()
  return self.myMaxLayer or 0
end

function EndlessTowerProxy:RecvNewEverLayerTowerCmd(data)
  self:UpdateEverSinglePasslayers(data.layers)
end

function EndlessTowerProxy:GetMyLayersInfo(layer)
  if self.myLayersInfo == nil then
    return
  end
  return self.myLayersInfo[layer]
end

function EndlessTowerProxy:UpdateEverPassLayers(everpasslayers)
  if everpasslayers then
    self.history_passedlayerMap = {}
    for i = 1, #everpasslayers do
      local layer = everpasslayers[i]
      local temp = EndlessTowerLayerInfo.new(layer.layer, layer.rewarded, layer.utime)
      self.history_passedlayerMap[temp.layer] = temp
    end
  end
end

function EndlessTowerProxy:UpdateEverSinglePasslayers(everpasslayer)
  if everpasslayer and not self.history_passedlayerMap then
    self.history_passedlayerMap = {}
  end
  if everpasslayer and 0 < #everpasslayer then
    for i = 1, #everpasslayer do
      local layer = everpasslayer[i]
      local temp = EndlessTowerLayerInfo.new(layer.layer, layer.rewarded, layer.utime)
      self.history_passedlayerMap[temp.layer] = temp
    end
  end
end

function EndlessTowerProxy:RecvTowerInfo(data)
  self.maxlayer = data.maxlayer
  self.refreshtime = data.refreshtime
end

function EndlessTowerProxy:RecvTowerLayerSyncTowerCmd(data)
  redlog("RecvTowerLayerSyncTowerCmd", data.layer)
  self.curChallengeLayer = data.layer
  self.isClearAll = false
end

function EndlessTowerProxy:RecvMonsterCountUserCmd(data)
  redlog("RecvMonsterCountUserCmd", data.num)
  if Game.MapManager:IsEndlessTower() then
    self.isClearAll = data.num == 0
  end
end

function EndlessTowerProxy:DungeonLaunched()
  self.isClearAll = false
end

local temp = {}

function EndlessTowerProxy:GetNextLayer()
  TableUtility.ArrayClear(temp)
  if not self.leaderLayersDic then
    return 1
  end
  if not TeamProxy.Instance:IHaveTeam() then
    for k, v in pairs(self.myLayersInfo) do
      TableUtility.ArrayPushBack(temp, v)
    end
  else
    for k, v in pairs(self.leaderLayersDic) do
      TableUtility.ArrayPushBack(temp, v)
    end
  end
  local maxlayer = 0
  for i = 1, #temp do
    if maxlayer < temp[i].layer then
      maxlayer = temp[i].layer
    end
  end
  if temp and 0 < #temp then
    local layer = maxlayer + 1
    if layer > self.maxlayer then
      layer = self.maxlayer
    end
    return layer
  else
    return 1
  end
end

function EndlessTowerProxy:IsCurLayerCanChallenge(layer)
  local haveTeam = TeamProxy.Instance:IHaveTeam()
  if haveTeam and self.leaderLayersDic and self.leaderLayersDic[layer] ~= nil then
    return true
  end
  if self.myLayersInfo and self.myLayersInfo[layer] ~= nil then
    return true
  end
  local nextLayer = self:GetNextLayer()
  if nextLayer ~= nil then
    return layer <= nextLayer
  end
  return false
end

function EndlessTowerProxy:IsCurLayerHasChallenged(layer)
  if self.history_passedlayerMap == nil then
    return
  end
  return self.history_passedlayerMap[layer] ~= nil
end

function EndlessTowerProxy:IsTeamMembersFighting()
  if TeamProxy.Instance:IHaveTeam() then
    for k, v in pairs(TeamProxy.Instance.myTeam:GetPlayerMemberList(false, true)) do
      if v.raid and v.offline == 0 then
        local data = Table_MapRaid[v.raid]
        if data and data.Type == FuBenCmd_pb.ERAIDTYPE_TOWER then
          return true
        end
      end
    end
  end
  return false
end

local result = {}

function EndlessTowerProxy:GetWaitData()
  TableUtility.ArrayClear(result)
  local members = TeamProxy.Instance.myTeam:GetPlayerMemberList(false, true)
  for i = 1, #members do
    local data = EndlessTowerMemberData.new(members[i])
    TableUtility.ArrayPushBack(result, data)
  end
  return result
end

function EndlessTowerProxy:GetTowerInfoData()
  if self.towerList == nil then
    self.towerList = {}
    for i = EndlessTowerProxy.Instance.maxlayer, 1, -1 do
      table.insert(self.towerList, i)
    end
  end
  return self.towerList
end

function EndlessTowerProxy:CheckClearAll()
  return self.isClearAll
end

function EndlessTowerProxy:Server_SerResetTime(resettime)
  self.resettime = resettime
end

function EndlessTowerProxy:Get_ResetTime()
  return self.resettime
end

function EndlessTowerProxy:CanSweep()
  return self.curChallengeLayer ~= GameConfig.EndlessTower.deadboss
end

function EndlessTowerProxy:RecvTowerPrivateLayerInfo(data)
  redlog("RecvTowerPrivateLayerInfo")
  self.currentFloorInfo = {}
  local curFloorMonsters = {}
  local curFloorBoss
  if data.monsters and #data.monsters > 0 then
    for i = 1, #data.monsters do
      local single = data.monsters[i]
      if single.type == 1 then
        redlog("BOSSDATA")
        local bossData = single
        curFloorBoss = bossData
      else
        table.insert(curFloorMonsters, single)
      end
    end
  end
  self.currentFloorInfo.currentFloor = data.layer
  self.currentFloorInfo.curFloorBoss = curFloorBoss
  self.currentFloorInfo.curFloorMonsters = curFloorMonsters
  self.currentFloorInfo.curFloorReward = data.rewards
end
