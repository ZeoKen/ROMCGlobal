local ServicePlayerProxy = class("ServicePlayerProxy", ServiceProxy)
ServicePlayerProxy.Instance = nil
ServicePlayerProxy.NAME = "ServicePlayerProxy"

function ServicePlayerProxy:ctor(proxyName)
  if ServicePlayerProxy.Instance == nil then
    self.proxyName = proxyName or ServicePlayerProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    ServicePlayerProxy.Instance = self
  end
end

function ServicePlayerProxy:onRegister()
  self:Listen(5, 22, function(data)
    self:ChangeDress(data)
  end)
  self:Listen(5, 13, function(data)
    self:AddMapNpc(data)
  end)
  self:Listen(5, 16, function(data)
    self:MoveTo(data)
  end)
  self:Listen(5, 1, function(data)
    self:UserAttrSyncCmd(data)
  end)
  self:Listen(5, 27, function(data)
    self:SkillBroadcast(data)
  end)
  self:Listen(5, 53, function(data)
    self:ObserverMode(data)
  end)
  self:Listen(5, 12, function(data)
    self:MapOtherUserIn(data)
  end)
  self:Listen(5, 23, function(data)
    self:MapChange(data)
  end)
  self:Listen(5, 18, function(data)
    self:MapOtherUserOut(data)
  end)
  self:Listen(5, 38, function(data)
    self:MapObjectData(data)
  end)
  self:Listen(5, 51, function(data)
    self:NpcWalkTraceInfo(data)
  end)
  self:Listen(5, 52, function(data)
    self:ReqHideUserCmd(data)
  end)
end

function ServicePlayerProxy:CallChangeMap(mapName, x, y, z, mapID)
  if NetConfig.PBC then
    local msgId = ProtoReqInfoList.ChangeSceneUserCmd.id
    local msgParam = {}
    msgParam.mapID = mapID
    msgParam.mapName = mapName
    msgParam.pos = {}
    msgParam.pos.x = x
    msgParam.pos.y = y
    msgParam.pos.z = z
    self:SendProto2(msgId, msgParam)
  else
    local msg = SceneUser_pb.ChangeSceneUserCmd()
    msg.mapID = mapID
    msg.mapName = mapName
    msg.pos.x = x
    msg.pos.y = y
    msg.pos.z = z
    self:SendProto(msg)
  end
  if not self.isAlreadyLogin then
    self.isAlreadyLogin = true
    ServiceLoginUserCmdProxy.Instance:CallOfflineDetectUserCmd(216)
  end
end

function ServicePlayerProxy:CallChangeDress(charid, male, body, hair, rightHand, profession, accessory, wing)
  if NetConfig.PBC then
    local msgId = ProtoReqInfoList.ChangeBodyUserCmd.id
    local msgParam = {}
    msgParam.charid = charid
    msgParam.male = male
    msgParam.body = body
    msgParam.hair = hair
    msgParam.rightHand = rightHand
    msgParam.profession = profession
    msgParam.accessory = accessory
    msgParam.wing = wing
    self:SendProto2(msgId, msgParam)
  else
    local msg = SceneUser_pb.ChangeBodyUserCmd()
    msg.charid = charid
    msg.male = male
    msg.body = body
    msg.hair = hair
    msg.rightHand = rightHand
    msg.profession = profession
    msg.accessory = accessory
    msg.wing = wing
    self:SendProto(msg)
  end
end

function ServicePlayerProxy:CallMoveTo(tx, ty, tz)
  if NetConfig.PBC then
    local msgId = ProtoReqInfoList.ReqMoveUserCmd.id
    local msgParam = {}
    msgParam.target = {}
    msgParam.target.x = self:ToServerFloat(tx)
    msgParam.target.y = self:ToServerFloat(ty)
    msgParam.target.z = self:ToServerFloat(tz)
    self:SendProto2(msgId, msgParam)
  else
    local msg = SceneUser_pb.ReqMoveUserCmd()
    msg.target.x = self:ToServerFloat(tx)
    msg.target.y = self:ToServerFloat(ty)
    msg.target.z = self:ToServerFloat(tz)
    self:SendProto(msg)
  end
end

function ServicePlayerProxy:CallSkillBroadcast(random, data, creature, targetCreatureGUID, istrigger, manual)
  if NetConfig.PBC then
    local msg = SceneUser_pb.SkillBroadcastUserCmd()
    msg.charid = Game.Myself.data.id
    msg.random = random or 0
    msg.trigger = istrigger or false
    msg.touch = manual or false
    msg.is_client_use = true
    data:ToServerData(msg, creature, targetCreatureGUID)
    self:SendProto(msg)
  else
    local msg = SceneUser_pb.SkillBroadcastUserCmd()
    msg.charid = Game.Myself.data.id
    msg.random = random or 0
    msg.trigger = istrigger or false
    msg.touch = manual or false
    msg.is_client_use = true
    data:ToServerData(msg, creature, targetCreatureGUID)
    self:SendProto(msg)
  end
end

function ServicePlayerProxy:CallUserAttrPointCmd(Ptype, etype)
  if NetConfig.PBC then
    local msgId = ProtoReqInfoList.UserAttrPointCmd.id
    local msgParam = {}
    msgParam.type = etype or SceneUser_pb.POINTTYPE_ADD
    msgParam.ptype = Ptype
    self:SendProto2(msgId, msgParam)
  else
    local msg = SceneUser_pb.UserAttrPointCmd()
    msg.type = etype or SceneUser_pb.POINTTYPE_ADD
    msg.ptype = Ptype
    self:SendProto(msg)
  end
end

function ServicePlayerProxy:CallMapObjectData(guid)
  if NetConfig.PBC then
    local msgId = ProtoReqInfoList.MapObjectData.id
    local msgParam = {}
    msgParam.guid = guid
    self:SendProto2(msgId, msgParam)
  else
    local msg = SceneUser_pb.MapObjectData()
    msg.guid = guid
    self:SendProto(msg)
  end
end

function ServicePlayerProxy:MapOtherUserOut(data)
  SceneObjectProxy.RemoveObjs(data.list, data.delay_del, data.fadeout)
  self:Notify(ServiceEvent.PlayerMapOtherUserOut, data)
end

ServicePlayerProxy.mapChangeForCreateRole = false

function ServicePlayerProxy:MapChange(data)
  self.map_imageid = data.imageid
  Game.MapManager:SetImageID(self.map_imageid)
  if ServicePlayerProxy.mapChangeForCreateRole then
    if NetConfig.PBC then
      EventManager.Me():PassEvent(CreateRoleViewEvent.PlayerMapChange, data)
    else
      local cloneData = SceneUser_pb.ChangeSceneUserCmd()
      cloneData:MergeFrom(data)
      EventManager.Me():PassEvent(CreateRoleViewEvent.PlayerMapChange, cloneData)
    end
    return
  end
  self:Notify(ServiceEvent.PlayerMapChange, data, LoadSceneEvent.StartLoad)
end

function ServicePlayerProxy:GetCurMapImageId()
  return self.map_imageid
end

function ServicePlayerProxy:MapObjectData(data)
  self:Notify(ServiceEvent.PlayerMapObjectData, data, LoadSceneEvent.StartLoad)
end

function ServicePlayerProxy:ChangeDress(data)
  UserProxy.Instance:ChangeDress(data)
  self:Notify(ServiceEvent.PlayerChangeDress, data)
end

local isPathFidingOptOn = true

function ServicePlayerProxy.SetOptimizePathFidingOn(b)
  isPathFidingOptOn = b
end

function ServicePlayerProxy.IsOptimizePathFidingOn()
  return isPathFidingOptOn
end

function ServicePlayerProxy:MoveTo(data)
  if data.pos ~= nil then
    data.pos.x = self:ToFloat(data.pos.x)
    data.pos.y = self:ToFloat(data.pos.y)
    data.pos.z = self:ToFloat(data.pos.z)
    if NSceneUserProxy.Instance:SyncMove(data, isPathFidingOptOn) then
      return
    end
    if NSceneNpcProxy.Instance:SyncMove(data, isPathFidingOptOn) then
      return
    end
    if NScenePetProxy.Instance:SyncMove(data, isPathFidingOptOn) then
      return
    end
  else
    helplog("move data error", data)
  end
end

function ServicePlayerProxy:NpcWalkTraceInfo(data)
  GameFacade.Instance:sendNotification(SceneUserEvent.AddNpcPosEffect, data)
end

function ServicePlayerProxy:AddMapNpc(data)
  SceneNpcProxy.Instance:AddSome(data.list)
  self:Notify(ServiceEvent.PlayerAddMapNpc, data)
end

function ServicePlayerProxy:UserAttrSyncCmd(data)
  self:Notify(ServiceEvent.PlayerSAttrSyncData, data)
end

local SKILL_LOD_SKIP_THREAD = 3
local SkillLodFreqCount = 0

function ServicePlayerProxy:SkillBroadcast(data)
  local FindCreature = SceneCreatureProxy.FindCreature
  if data.data.number == SkillPhase.Hit and data.is_client_use then
    local isEmpty = true
    local hitedTargets = data.data.hitedTargets
    for i = 1, #hitedTargets do
      if FindCreature(hitedTargets[i].charid) ~= nil then
        isEmpty = false
        break
      end
    end
    if isEmpty then
      return
    end
  end
  local creature = SceneCreatureProxy.FindCreature(data.charid)
  local skillInfo = Game.LogicManager_Skill:GetSkillInfo(data.skillID)
  if creature ~= nil then
    local effectType = skillInfo:IsMapSkill() and Asset_Effect.EffectTypes.Map or nil
    local priority = SkillInfo.GetEffectPriority(creature, effectType, nil, skillInfo.camps)
    if Game.EffectManager:GetLodLevel(priority, effectType) == -1 then
      SkillLodFreqCount = SkillLodFreqCount + 1
      if SkillLodFreqCount >= SKILL_LOD_SKIP_THREAD then
        SkillLodFreqCount = 0
        return
      end
    end
  end
  SceneCreatureProxy.ParsePhaseData(data)
  mylog("SkillBroadcast --------------------- Time", UnityFrameCount)
  mylog("SkillBroadcast", data.charid, data.skillID, data.data.number)
  if not NSceneUserProxy.Instance:SyncServerSkill(data) and not NSceneNpcProxy.Instance:SyncServerSkill(data) and not NScenePetProxy.Instance:SyncServerSkill(data) then
    SceneCreatureProxy.HitTargetByPhaseData(data)
  end
  EventManager.Me():DispatchEvent(ServiceEvent.PlayerSkillBroadcast, data)
end

function ServicePlayerProxy:ObserverMode(data)
  local onoff = data.mode
  if nil == onoff then
    return
  end
  if onoff then
    GameFacade.Instance:sendNotification(MyselfEvent.ObservationModeStart)
  else
    GameFacade.Instance:sendNotification(MyselfEvent.ObservationModeEnd)
  end
  PvpObserveProxy.Instance:HandleModeChanged(onoff)
  Game.ClickGroundEffectManager:SetForbidden(onoff)
end

function ServicePlayerProxy:CallUserRejectSettingNotifyService()
  if NetConfig.PBC then
    local msgId = ProtoReqInfoList.UserRejectSettingNotifyServiceCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  else
    local msg = SceneUser_pb.UserRejectSettingNotifyServiceCmd()
    self:SendProto(msg)
  end
end

function ServicePlayerProxy:CallReqHideUserCmd(hide)
  if NetConfig.PBC then
    local msgId = ProtoReqInfoList.ReqHideUserCmd.id
    local msgParam = {}
    msgParam.hide = hide
    self:SendProto2(msgId, msgParam)
  else
    local msg = SceneUser_pb.ReqHideUserCmd()
    msg.hide = hide
    self:SendProto(msg)
  end
end

return ServicePlayerProxy
