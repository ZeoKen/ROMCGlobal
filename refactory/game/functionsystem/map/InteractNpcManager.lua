autoImport("InteractBase")
autoImport("InteractNpc")
autoImport("InteractTrain")
autoImport("InteractFlowerCar")
autoImport("InteractFurniture")
autoImport("InteractNpc2Furniture")
autoImport("InteractMount")
autoImport("InteractMountNpc")
autoImport("InteractSceneObject")
InteractNpcManager = class("InteractNpcManager")
local TableInteractFurnitureName = "Table_InteractFurniture"
local GameFacade = GameFacade.Instance
local ArrayPushBack = TableUtility.ArrayPushBack
local ArrayRemove = TableUtility.ArrayRemove
local ArrayClear = TableUtility.ArrayClear
local PartIndex = Asset_Role.PartIndex
local PartIndexEx = Asset_Role.PartIndexEx
local _GameConfig = GameConfig

function InteractNpcManager:ctor()
  self.interactNpcMap = {}
  self.interactMountMap = {}
  self.interactMountLinkMap = {}
  self.interactMountRideMap = {}
  self.assetRoleMap = {}
  self.interactFlowerCarCtrlMap = {}
  self.interactNpcCount = 0
  self.interactMountCount = 0
  self.isInTrigger = false
end

function InteractNpcManager:Update(time, deltaTime)
  if not self.running then
    return
  end
  if self.interactNpcCount > 0 then
    local isInTrigger = false
    local interactLocalBlock = InteractLocalManager.Me():IsInteractBusy()
    if not interactLocalBlock then
      self.lockNpcGuid = nil
      if not self:IsMyselfOnInteractMount() then
        for k, v in pairs(self.interactNpcMap) do
          if v:Update(time, deltaTime) then
            isInTrigger = true
            self.lockNpcGuid = k
            break
          end
        end
      end
    end
    if self.isInTrigger ~= isInTrigger then
      self:_TrySendMyselfTriggerChange(isInTrigger)
      self.isInTrigger = isInTrigger
    end
  end
  if 0 < self.interactMountCount then
    for k, v in pairs(self.interactMountMap) do
      v:Update(time, deltaTime)
    end
  end
  for _, v in pairs(self.interactNpcMap) do
    if v.flowerCarId then
      v:UpdatePhase(time, deltaTime)
    end
  end
end

function InteractNpcManager:Launch()
  if self.running then
    return
  end
  self.running = true
  local assetRole = Game.Myself and Game.Myself.assetRole
  if assetRole then
    self:UpdateRegisterInteractMount(Game.Myself.data.id, assetRole:GetPartID(Asset_Role.PartIndex.Mount))
  end
  self:UpdateMultiMountStatus(Game.Myself)
  self:OnSceneLoaded()
  EventManager.Me():AddEventListener(LoadSceneEvent.FinishLoadScene, self.OnSceneLoaded, self)
  EventManager.Me():AddEventListener(ServiceEvent.ConnReconnect, self.HandleReconnect, self)
end

function InteractNpcManager:Shutdown()
  if not self.running then
    return
  end
  self.running = false
  EventManager.Me():RemoveEventListener(LoadSceneEvent.FinishLoadScene, self.OnSceneLoaded, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.ConnReconnect, self.HandleReconnect, self)
  self:OnLeaveScene()
  self:Clear()
end

function InteractNpcManager:Clear()
  self:ClearMoveMountInter()
  for k, v in pairs(self.interactNpcMap) do
    v:Destroy()
    self.interactNpcMap[k] = nil
  end
  self.interactNpcCount = 0
  self.interactMountCount = 0
  if self.fakeUserdata ~= nil then
    self.fakeUserdata:Destroy()
    self.fakeUserdata = nil
  end
  if self.fakeParts ~= nil then
    Asset_Role.DestroyPartArray(self.fakeParts)
    self.fakeParts = nil
  end
  for k, v in pairs(self.interactMountMap) do
    if k == self.myselfOnMountGuid then
      v:RequestGetOffAll()
    end
    v:Destroy()
    self.interactMountMap[k] = nil
  end
  for k, v in pairs(self.interactMountLinkMap) do
    ReusableTable.DestroyAndClearTable(v)
  end
  TableUtility.TableClear(self.interactMountLinkMap)
  TableUtility.TableClear(self.interactMountRideMap)
  local myselfID = Game.Myself and Game.Myself.data and Game.Myself.data.id
  self.lockMountMasterGuid = nil
  self.myselfRideInteractMount = nil
  if self.myselfOnMountGuid then
    self.myselfOnMountGuid = nil
    GameFacade:sendNotification(InteractNpcEvent.MyselfOnOffMountChange, false)
  end
  self:ClearTrigger()
end

function InteractNpcManager:ClearTrigger()
  self.isInTrigger = false
  GameFacade:sendNotification(InteractNpcEvent.MyselfTriggerChange, false)
end

function InteractNpcManager:RegisterInteractNpc(staticid, id)
  local data = Table_InteractNpc[staticid]
  if data == nil then
    return
  end
  self:_Register(InteractNpc, data, id)
end

function InteractNpcManager:UnregisterInteractNpc(id)
  local count = self.interactNpcCount
  self:_Unregister(id)
  if 0 < count and self.interactNpcCount == 0 then
    self:ClearTrigger()
  end
end

function InteractNpcManager:AddInteractObject(id)
  self:RegisterInteractNpc(id, id)
end

function InteractNpcManager:RemoveInteractObject(id)
  self:UnregisterInteractNpc(id)
end

function InteractNpcManager:RegisterInteractFurniture(staticid, id)
  if _G[TableInteractFurnitureName] == nil then
    autoImport(TableInteractFurnitureName)
  end
  local data = Table_InteractFurniture[staticid]
  if data == nil then
    return
  end
  self:_Register(InteractFurniture, data, id)
end

function InteractNpcManager:UnregisterInteractFurniture(id)
  self:_Unregister(id)
end

function InteractNpcManager:UpdateRegisterInteractMount(id, bodyid, creature)
  if not self.running then
    return
  end
  local data = bodyid and Table_InteractMount[bodyid]
  local curMount = self.interactMountMap[id]
  if data then
    if curMount and curMount.staticData.id ~= bodyid then
      self:_UnregisterInteractMount(id)
      curMount = nil
    end
    if not curMount then
      self:_RegisterInteractMount(id, data)
      if creature then
        local charid = creature.data.id
        local masterid = creature.data.userdata:Get(UDEnum.RIDING_CHARID) or 0
        local ridingNpc = creature.data.userdata:Get(UDEnum.RIDING_NPC)
        if masterid == 0 and ridingNpc ~= 0 then
          local interactMount = self:GetInteractMount(charid)
          if interactMount then
            interactMount:RequestGetOn(2, 0, ridingNpc)
          end
        end
      end
    end
  elseif curMount then
    self:_UnregisterInteractMount(id)
  end
end

function InteractNpcManager:_RegisterInteractMount(id, data)
  if not data or self.interactMountMap[id] then
    return
  end
  if Game.Myself and Game.Myself.data and id == Game.Myself.data.id then
    local isRidingInteractMount = data ~= nil
    local curIsOnInteractMount = self:IsMyselfOnInteractMount()
    self.myselfRideInteractMount = isRidingInteractMount
    self.myselfOnMountGuid = isRidingInteractMount and id or nil
    if curIsOnInteractMount ~= isRidingInteractMount then
      GameFacade:sendNotification(InteractNpcEvent.MyselfOnOffMountChange, isRidingInteractMount)
    end
  end
  local interactMount = InteractMount.Create(data, id)
  self.interactMountMap[id] = interactMount
  self.interactMountCount = self.interactMountCount + 1
  local passengerMap = self.interactMountLinkMap[id]
  if passengerMap then
    for passengerID, v in pairs(passengerMap) do
      self:UpdateMultiMountStatus(NSceneUserProxy.Instance:Find(passengerID))
    end
  end
end

function InteractNpcManager:_UnregisterInteractMount(id)
  local interactMount = self.interactMountMap[id]
  if interactMount then
    local cpMap = interactMount:GetCPMap()
    for cpID, passengerID in pairs(cpMap) do
      self.interactMountRideMap[passengerID] = nil
    end
    interactMount:RequestGetOffAll()
    interactMount:Destroy()
    self.interactMountMap[id] = nil
    self.interactMountCount = self.interactMountCount - 1
  end
  local myselfID = Game.Myself and Game.Myself.data and Game.Myself.data.id
  if id == myselfID or id == self.myselfOnMountGuid then
    self.myselfRideInteractMount = false
    self.myselfOnMountGuid = nil
    self.lockMountMasterGuid = nil
    GameFacade:sendNotification(InteractNpcEvent.MyselfOnOffMountChange, false)
  end
end

function InteractNpcManager:IsInteractBusy()
  return self.running and self:IsMyselfPassenger()
end

function InteractNpcManager:IsMyselfRideInteractMount()
  return self.myselfRideInteractMount == true
end

function InteractNpcManager:GetMyselfRidingMultiMountGuid()
  return self.myselfOnMountGuid
end

function InteractNpcManager:IsMyselfOnInteractMount()
  return self:GetMyselfRidingMultiMountGuid() ~= nil
end

function InteractNpcManager:IsMyselfPassenger()
  return self:IsMyselfOnInteractMount() and not self:IsMyselfRideInteractMount()
end

function InteractNpcManager:GetMultiMountMasterID(id)
  return self.interactMountRideMap[id]
end

function InteractNpcManager:GetInteractMount(id)
  return id and self.interactMountMap[id]
end

function InteractNpcManager:TryCheckInteraceMountPosition(id)
  local interactMount = self:GetInteractMount(id)
  return interactMount and interactMount:CheckPosition()
end

function InteractNpcManager:SetTargetInteractMountID(id)
  local lastIsTrigger = self:GetTargetInteractMountID() ~= nil
  local nowIsTrigger = id ~= nil
  self.lockMountMasterGuid = id
  if lastIsTrigger ~= nowIsTrigger then
    GameFacade:sendNotification(InteractNpcEvent.MyselfTriggerMountChange, nowIsTrigger)
  end
end

function InteractNpcManager:GetTargetInteractMountID()
  return self.lockMountMasterGuid
end

function InteractNpcManager:MyselfManualClickMount()
  if self:TryNotifyGetOff() then
    return
  end
  local interactMount = self:GetInteractMount(self:GetTargetInteractMountID())
  if interactMount then
    interactMount:TryNotifyGetOn()
  end
end

function InteractNpcManager:TryNotifyGetOffMount()
  local interactMount = self:GetInteractMount(self.myselfOnMountGuid)
  if interactMount then
    interactMount:TryNotifyGetOff()
  end
end

function InteractNpcManager:TryChangeSeat()
  local interactMount = self:GetInteractMount(self.myselfOnMountGuid)
  if interactMount then
    interactMount:TryChangeSeat()
  end
end

function InteractNpcManager:OnCreatureRecycle(id)
  local cachedMasterID = self.interactMountRideMap[id]
  if not cachedMasterID then
    return
  end
  local interactMount = self:GetInteractMount(cachedMasterID)
  if interactMount then
    interactMount:RequestGetOff(id)
  end
  self.interactMountRideMap[id] = nil
  local passengerMap = self.interactMountLinkMap[cachedMasterID]
  if passengerMap then
    passengerMap[id] = nil
  end
end

function InteractNpcManager:UpdateMultiMountStatus(creature)
  if not creature or not self.running then
    return
  end
  local charid = creature.data.id
  local masterid = creature.data.userdata:Get(UDEnum.RIDING_CHARID) or 0
  local cachedMasterID = self.interactMountRideMap[charid]
  local ridingNpc = creature.data.userdata:Get(UDEnum.RIDING_NPC)
  if masterid ~= 0 then
    local passengerMap = self.interactMountLinkMap[masterid]
    if not passengerMap then
      passengerMap = ReusableTable.CreateTable()
      self.interactMountLinkMap[masterid] = passengerMap
    end
    passengerMap[charid] = true
  elseif cachedMasterID then
    local passengerMap = self.interactMountLinkMap[cachedMasterID]
    if passengerMap then
      passengerMap[charid] = nil
    end
  else
    for masterID, passengerMap in pairs(self.interactMountLinkMap) do
      passengerMap[charid] = nil
    end
  end
  if masterid == 0 and ridingNpc ~= 0 then
    local interactMount = self:GetInteractMount(charid)
    if interactMount then
      interactMount.npcid = ridingNpc
      interactMount:RequestGetOn(2, 0, ridingNpc)
      GameFacade:sendNotification(InteractNpcEvent.MyselfPassengerChange)
    end
  elseif ridingNpc == 0 then
    local interactMount = self:GetInteractMount(charid)
    if interactMount and interactMount.npcid ~= 0 then
      interactMount:RequestGetOff(charid, not self:IsMyselfPassenger())
      GameFacade:sendNotification(InteractNpcEvent.MyselfPassengerChange)
    end
  end
  if not (masterid ~= 0 or cachedMasterID) or masterid == cachedMasterID then
    return
  end
  local interactMount = self:GetInteractMount(masterid)
  local myselfID = Game.Myself and Game.Myself.data and Game.Myself.data.id
  local posid = creature.data.userdata:Get(UDEnum.RIDING_POS) or 0
  if posid == 0 or masterid == 0 then
    interactMount = interactMount or self:GetInteractMount(cachedMasterID)
    if interactMount then
      interactMount:RequestGetOff(charid, not self:IsMyselfPassenger())
    end
    self.interactMountRideMap[charid] = nil
    if charid == myselfID then
      self.myselfOnMountGuid = nil
      self.lockMountMasterGuid = nil
      GameFacade:sendNotification(InteractNpcEvent.MyselfOnOffMountChange, false)
    elseif cachedMasterID == myselfID then
      MsgManager.ShowMsgByID(40564, creature.data:GetName())
      GameFacade:sendNotification(InteractNpcEvent.MyselfPassengerChange)
    end
  else
    if not interactMount or not creature.assetRole then
      return
    end
    interactMount:RequestGetOff(charid)
    interactMount:RequestGetOn(posid, charid)
    local cpMap = interactMount:GetCPMap()
    if cpMap[posid] ~= charid then
      return
    end
    self.interactMountRideMap[charid] = masterid
    if charid == myselfID then
      self.myselfOnMountGuid = masterid
      self.lockMountMasterGuid = nil
      GameFacade:sendNotification(InteractNpcEvent.MyselfOnOffMountChange, true)
    elseif masterid == myselfID then
      GameFacade:sendNotification(InteractNpcEvent.MyselfPassengerChange)
    end
  end
end

function InteractNpcManager:_Register(class, data, id)
  local interactNpc = self.interactNpcMap[id]
  if interactNpc ~= nil then
    return
  end
  interactNpc = class.Create(data, id)
  self.interactNpcMap[id] = interactNpc
  self.interactNpcCount = self.interactNpcCount + 1
end

function InteractNpcManager:_Unregister(id)
  local interactNpc = self.interactNpcMap[id]
  if interactNpc ~= nil then
    interactNpc:RequestGetOffAll()
    if id == self.myselfOnNpcGuid then
      self:_ChangeMyselfOnOff(nil, interactNpc)
    end
    interactNpc:Destroy()
    self.interactNpcMap[id] = nil
    self.interactNpcCount = self.interactNpcCount - 1
  end
end

function InteractNpcManager:MyselfManualGetOff()
  self:TryNotifyGetOff()
end

function InteractNpcManager:MyselfManualClick()
  if not self:TryNotifyGetOff() then
    self:TryNotifyGetOn()
  end
end

function InteractNpcManager:Client_MyselfGetOff(interactNpc)
  interactNpc:RequestGetOff(Game.Myself.data.id)
  self:_ChangeMyselfOnOff(nil, interactNpc)
end

function InteractNpcManager:AddMountInter(npcguid, mountid, charid)
  local interactNpc = self.interactNpcMap[npcguid]
  if interactNpc ~= nil then
    interactNpc:RequestGetOn(mountid, charid)
    if charid == Game.Myself.data.id then
      self:_ChangeMyselfOnOff(npcguid, interactNpc)
    end
  end
end

function InteractNpcManager:DelMountInter(npcguid, charid)
  local interactNpc = self.interactNpcMap[npcguid]
  if interactNpc ~= nil then
    interactNpc:RequestGetOff(charid)
    if charid == Game.Myself.data.id then
      self:_ChangeMyselfOnOff(nil, interactNpc)
    end
  end
end

function InteractNpcManager:AddMoveMountInter(data)
  local interactNpc = self.interactNpcMap[data.npcid]
  if interactNpc ~= nil then
    local args = ReusableTable.CreateArray()
    args[1] = RandomAIManager.TriggerConditionEnum.INTERACTNPC
    args[2] = data.user.user.charid
    args[3] = data.npcid
    EventManager.Me():PassEvent(PlayerBehaviourEvent.OnTrigger, args)
    ReusableTable.DestroyAndClearArray(args)
    self:_GetOnMoveMount(interactNpc, data.user, data.npcid)
  end
end

function InteractNpcManager:DelMoveMountInter(data)
  local interactNpc = self.interactNpcMap[data.npcid]
  if interactNpc ~= nil then
    local charid
    for i = 1, #data.charids do
      charid = data.charids[i]
      if charid == Game.Myself.data.id then
        self:Client_MyselfGetOff(interactNpc)
        self.onMountTrainGUID = nil
      else
        local assetRole = self.assetRoleMap[charid]
        if assetRole ~= nil then
          assetRole:Destroy()
          self.assetRoleMap[charid] = nil
        end
        interactNpc:FakeGetOff(charid)
      end
      local args = ReusableTable.CreateArray()
      args[1] = RandomAIManager.TriggerConditionEnum.INTERACTNPC
      args[2] = charid
      args[3] = data.npcid
      EventManager.Me():PassEvent(PlayerBehaviourEvent.OnExit, args)
      ReusableTable.DestroyAndClearArray(args)
    end
  end
end

function InteractNpcManager:ClearMoveMountInter()
  if self.onMountTrainGUID then
    local onMountTrain = self.interactNpcMap and self.interactNpcMap[self.onMountTrainGUID]
    self.onMountTrainGUID = nil
    if onMountTrain then
      self:Client_MyselfGetOff(onMountTrain)
    end
  end
  for k, v in pairs(self.assetRoleMap) do
    v:Destroy()
    self.assetRoleMap[k] = nil
  end
end

function InteractNpcManager:UpdateTrainStateInter(data)
  local interactNpc = self.interactNpcMap[data.npcid]
  if interactNpc ~= nil then
    interactNpc:UpdateState(data.state)
  end
end

function InteractNpcManager:TrainUserSyncInter(data)
  local interactNpc = self.interactNpcMap[data.npcid]
  if interactNpc ~= nil then
    interactNpc:UpdateState(data.state, data.arrivetime)
    for i = 1, #data.users do
      self:_GetOnMoveMount(interactNpc, data.users[i], data.npcid)
    end
  end
end

function InteractNpcManager:TryNotifyGetOn(id, param)
  id = id or self.lockNpcGuid
  if id ~= nil then
    local interactNpc = self.interactNpcMap[id]
    if interactNpc ~= nil then
      local config = Table_InteractNpc[id]
      if config and config.Param and config.Param.MyselfActionId then
        Game.Myself:Client_PlayMotionAction(config.Param.MyselfActionId)
        self:_ChangeMyselfOnOff(id, interactNpc)
        return true
      end
      return interactNpc:TryNotifyGetOn(param)
    end
  end
  return false
end

function InteractNpcManager:TryNotifyGetOff()
  local myselfOnNpcGuid = self.myselfOnNpcGuid
  if myselfOnNpcGuid ~= nil then
    local interactNpc = self.interactNpcMap[myselfOnNpcGuid]
    if interactNpc ~= nil then
      local config = Table_InteractNpc[myselfOnNpcGuid]
      if config and config.Param and config.Param.MyselfActionId then
        Game.Myself:Client_PlayMotionAction(0)
        self:_ChangeMyselfOnOff(nil, interactNpc)
        return true
      end
      local notify, clientGetOff = interactNpc:TryNotifyGetOff(myselfOnNpcGuid)
      if clientGetOff then
        self:Client_MyselfGetOff(interactNpc)
      end
      return notify
    end
  end
  return false
end

function InteractNpcManager:TryDelMountInter(id, cpid)
  local interactNpc = self.interactNpcMap[id]
  if interactNpc ~= nil then
    local charid = interactNpc:GetCharid(cpid)
    if charid ~= nil then
      self:DelMountInter(id, charid)
    end
  end
end

function InteractNpcManager:_ChangeMyselfOnOff(npcguid, interactNpc)
  self.myselfOnNpcGuid = npcguid
  self.myselfOnNpcStaticID = npcguid and interactNpc and interactNpc.staticData.id
  if interactNpc:IsNotifyChange() then
    GameFacade:sendNotification(InteractNpcEvent.MyselfOnOffChange, npcguid ~= nil)
  end
  if interactNpc:IsAuto() then
    self:_TrySendMyselfTriggerChange(npcguid ~= nil)
  end
end

function InteractNpcManager:_GetOnMoveMount(interactNpc, user, interactNpcID)
  local charid = user.user.charid
  if charid == Game.Myself.data.id then
    self.onMountTrainGUID = interactNpcID
    interactNpc:RequestGetOn(user.mountid, charid)
    self:_ChangeMyselfOnOff(interactNpc.id, interactNpc)
  else
    local parts = self:_GetDressParts(user.user.datas)
    local assetRole = self.assetRoleMap[charid]
    if assetRole == nil then
      assetRole = Asset_Role.Create(parts)
      self.assetRoleMap[charid] = assetRole
    end
    assetRole:Redress(parts)
    interactNpc:FakeGetOn(user.mountid, charid)
  end
end

function InteractNpcManager:_ResetUserData(serverdata)
  if self.fakeUserdata == nil then
    self.fakeUserdata = UserData.CreateAsTable()
  end
  self.fakeUserdata:Reset()
  local sdata
  for i = 1, #serverdata do
    sdata = serverdata[i]
    if sdata ~= nil then
      self.fakeUserdata:SetByID(sdata.type, sdata.value, sdata.data)
    end
  end
  return self.fakeUserdata
end

function InteractNpcManager:_GetDressParts(serverdata)
  local userdata = self:_ResetUserData(serverdata)
  if self.fakeParts == nil then
    self.fakeParts = Asset_Role.CreatePartArray()
  end
  local parts = self.fakeParts
  if userdata then
    parts[PartIndex.Body] = userdata:Get(UDEnum.BODY) or 0
    parts[PartIndex.Hair] = userdata:Get(UDEnum.HAIR) or 0
    parts[PartIndex.LeftWeapon] = userdata:Get(UDEnum.LEFTHAND) or 0
    parts[PartIndex.RightWeapon] = userdata:Get(UDEnum.RIGHTHAND) or 0
    parts[PartIndex.Head] = userdata:Get(UDEnum.HEAD) or 0
    parts[PartIndex.Wing] = userdata:Get(UDEnum.BACK) or 0
    parts[PartIndex.Face] = userdata:Get(UDEnum.FACE) or 0
    parts[PartIndex.Tail] = userdata:Get(UDEnum.TAIL) or 0
    parts[PartIndex.Eye] = userdata:Get(UDEnum.EYE) or 0
    parts[PartIndex.Mouth] = userdata:Get(UDEnum.MOUTH) or 0
    parts[PartIndexEx.Gender] = userdata:Get(UDEnum.SEX) or 0
    parts[PartIndexEx.HairColorIndex] = userdata:Get(UDEnum.HAIRCOLOR) or 0
    parts[PartIndexEx.EyeColorIndex] = userdata:Get(UDEnum.EYECOLOR) or 0
    parts[PartIndexEx.BodyColorIndex] = userdata:Get(UDEnum.CLOTHCOLOR) or 0
    parts[PartIndexEx.SmoothDisplay] = 0.3
  else
    for i = 1, 16 do
      parts[i] = 0
    end
  end
  return parts
end

function InteractNpcManager:_TrySendMyselfTriggerChange(isInTrigger)
  if isInTrigger and self.myselfOnNpcStaticID ~= nil then
    isInTrigger = InteractNpcManager.CheckMyselfInNpcInteractArea(self.myselfOnNpcStaticID)
  end
  GameFacade:sendNotification(InteractNpcEvent.MyselfTriggerChange, isInTrigger)
end

function InteractNpcManager:IsMyselfOnNpc()
  return self.myselfOnNpcGuid ~= nil
end

function InteractNpcManager:GetFakeAssetRole(charid)
  return self.assetRoleMap[charid]
end

function InteractNpcManager:GetCharid(npcguid, cpid)
  local interactNpc = self.interactNpcMap[npcguid]
  if interactNpc ~= nil then
    return interactNpc:GetCharid(cpid)
  end
end

function InteractNpcManager.CheckMyselfInNpcInteractArea(npcID)
  local cfgNpcArea = _GameConfig.Interact and _GameConfig.Interact.NpcInteractArea
  local npcAreas = cfgNpcArea and cfgNpcArea[npcID]
  if not npcAreas then
    return true
  end
  local myselfPos = Game.Myself:GetPosition()
  for i = 1, #npcAreas do
    if myselfPos[1] > npcAreas[i].MinX and myselfPos[3] > npcAreas[i].MinZ and myselfPos[1] < npcAreas[i].MaxX and myselfPos[3] < npcAreas[i].MaxZ then
      return true
    end
  end
  return false
end

function InteractNpcManager:AddInteractMountNPC(npcguid, mountid, charid)
  local interactNpc = self.interactNpcMap[npcguid]
  if not interactNpc then
    local data = Table_InteractNpc[mountid]
    if data == nil then
      return
    end
    self:_Register(InteractMountNpc, data, npcguid)
  end
  interactNpc = self.interactNpcMap[npcguid]
  if interactNpc then
    interactNpc:RequestGetOn(1, charid)
    if charid == Game.Myself.data.id then
      self:_ChangeMyselfOnOff(npcguid, interactNpc)
    end
  end
end

function InteractNpcManager:DelInteractMountNPC(charid)
  if not self.interactNpcMap then
    return
  end
  for npcguid, interactNpc in pairs(self.interactNpcMap) do
    if interactNpc:RequestGetOff(charid) then
      if charid == Game.Myself.data.id then
        self:_ChangeMyselfOnOff(nil, interactNpc)
      end
      break
    end
  end
end

function InteractNpcManager:SetMagnetLockTarget(id)
  if id and self.interactNpcMap[id] then
    self.magnetLockGuid = id
  else
    self.magnetLockGuid = nil
  end
end

function InteractNpcManager:ExecuteMagnet()
  if self.magnetLockGuid then
    self.interactNpcMap[self.magnetLockGuid]:EnableMagnet()
    self:DoPlayerCustomAction()
  end
end

function InteractNpcManager:CancelMagnet()
  if self.magnetLockGuid then
    self.interactNpcMap[self.magnetLockGuid]:DisableMagnet()
  end
end

function InteractNpcManager:DoPlayerCustomAction()
  if self.magnetLockGuid then
    self.interactNpcMap[self.magnetLockGuid]:PlayerDoMagnetAction()
  end
end

function InteractNpcManager:EnableFlowerCar()
  for npcguid, interactNpc in pairs(self.interactNpcMap) do
    if interactNpc.flowerCarId then
      interactNpc:TryEnable()
    end
  end
end

function InteractNpcManager:DisableFlowerCar()
  for npcguid, interactNpc in pairs(self.interactNpcMap) do
    if interactNpc.flowerCarId then
      interactNpc:Disable()
    end
  end
end

function InteractNpcManager:GetOffFlowerCar(guid)
  local interactNpc = self.interactNpcMap[guid]
  if interactNpc.flowerCarId then
    interactNpc:GetOff()
  end
end

function InteractNpcManager:TestFlowerCarTryEnable()
  self:EnableFlowerCar()
end

function InteractNpcManager:TestResetFlowerCar()
  self:DisableFlowerCar()
end

function InteractNpcManager:TestSetFlowerCarStart(startTimeMS)
  for npcguid, interactNpc in pairs(self.interactNpcMap) do
    if interactNpc.flowerCarId then
      interactNpc:Start(startTimeMS)
    end
  end
end

function InteractNpcManager:SetTestRunTimeConfig(oriStr)
  redlog("SetTestRunTimeConfig", oriStr)
  local cfg = loadstring("return {" .. oriStr .. "}")()
  self.testFlowerCarRunTime = {
    day = cfg[1],
    hour = cfg[2],
    min = cfg[3],
    duration = cfg[4]
  }
  redlog("testFlowerCarRunTime", self.testFlowerCarRunTime)
end

function InteractNpcManager:OnSceneLoaded()
  redlog("InteractNpcManager", "OnSceneLoaded / SwitchLine / Reconnect")
  self:ClearMoveMountInter()
  self:DisableFlowerCar()
  self:EnableFlowerCar()
end

function InteractNpcManager:OnLeaveScene()
  redlog("InteractNpcManager", "OnLeaveScene")
  self:DisableFlowerCar()
end

function InteractNpcManager:HandleReconnect()
  redlog("InteractNpcManager", "HandleReconnect")
end
