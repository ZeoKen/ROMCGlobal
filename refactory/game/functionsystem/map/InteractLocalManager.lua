autoImport("InteractLocalSimple")
autoImport("InteractLocalHug")
autoImport("InteractLocalVisit")
autoImport("InteractLocalCollect")
InteractLocalManager = class("InteractLocalManager")
local GameFacade = GameFacade.Instance
local ArrayPushBack = TableUtility.ArrayPushBack
local ArrayRemove = TableUtility.ArrayRemove
local ArrayClear = TableUtility.ArrayClear
local PartIndex = Asset_Role.PartIndex
local PartIndexEx = Asset_Role.PartIndexEx
local _GameConfig = GameConfig
local tempV2 = LuaVector2.Zero()
local tempV3 = LuaVector2.Zero()

function InteractLocalManager:ctor()
  self.interactNpcMap = {}
  self.interactGroupMap = {}
  self.interactNpcCount = 0
  self.isInTrigger = false
end

function InteractLocalManager.Me()
  if not InteractLocalManager.Instance then
    InteractLocalManager.Instance = InteractLocalManager.new()
  end
  return InteractLocalManager.Instance
end

function InteractLocalManager:Update(time, deltaTime)
  if not self.running then
    return
  end
  self.lockNpcGuid = nil
  if self.interactNpcCount > 0 then
    local isInTrigger, triggerPrompt, triggerIcon = false
    local interactNpcBlock = Game.InteractNpcManager:IsInteractBusy()
    if not self:IsMyselfDuringInteract() and not interactNpcBlock then
      if self.last_lockNpcGuid and self.interactNpcMap[self.last_lockNpcGuid] and self.interactNpcMap[self.last_lockNpcGuid]:Update(time, deltaTime) then
        isInTrigger = true
        triggerPrompt = self.interactNpcMap[self.last_lockNpcGuid]:GetInteractPrompt()
        triggerIcon = self.interactNpcMap[self.last_lockNpcGuid]:GetInteractIcon()
        self.lockNpcGuid = self.last_lockNpcGuid
      end
      if not self.lockNpcGuid then
        for k, v in pairs(self.interactNpcMap) do
          if k ~= self.last_lockNpcGuid and v:Update(time, deltaTime) then
            isInTrigger = true
            triggerPrompt = v:GetInteractPrompt()
            self.lockNpcGuid = k
            self.last_lockNpcGuid = k
            break
          end
        end
      end
    end
    if self.isInTrigger ~= isInTrigger then
      self:_TrySendMyselfTriggerChange(isInTrigger, triggerPrompt, triggerIcon)
      self.isInTrigger = isInTrigger
    end
  end
end

function InteractLocalManager:Launch()
  if self.running then
    return
  end
  self.running = true
  self:OnSceneLoaded()
  EventManager.Me():AddEventListener(LoadSceneEvent.FinishLoadScene, self.OnSceneLoaded, self)
  EventManager.Me():AddEventListener(ServiceEvent.ConnReconnect, self.HandleReconnect, self)
  EventManager.Me():AddEventListener(MyselfEvent.DeathBegin, self.HandleMyselfPlayerDeath, self)
  EventManager.Me():AddEventListener(ServiceEvent.QuestQuestUpdate, self.HandleCheckQuestCondition, self)
  EventManager.Me():AddEventListener(ServiceEvent.QuestQuestList, self.HandleCheckQuestCondition, self)
  EventManager.Me():AddEventListener(ServiceEvent.QuestQuestStepUpdate, self.HandleCheckQuestCondition, self)
  EventManager.Me():AddEventListener(PetEvent.SendHug, self.HandleHugPet, self)
  EventManager.Me():AddEventListener(MyselfEvent.BeginSkillBroadcast, self.HandleSkillBroadcastCheck, self)
  EventManager.Me():AddEventListener(MyselfEvent.BeHited, self.HandleMyselfPlayerBeHit, self)
  EventManager.Me():AddEventListener(ItemEvent.EquipUpdate, self.HandleMyselfMountChange, self)
  EventManager.Me():AddEventListener(EscortEvent.HandStatusBuff, self.TryHandleCollectHugHandStatusBuff, self)
end

function InteractLocalManager:Shutdown()
  if not self.running then
    return
  end
  self.running = false
  EventManager.Me():RemoveEventListener(LoadSceneEvent.FinishLoadScene, self.OnSceneLoaded, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.ConnReconnect, self.HandleReconnect, self)
  EventManager.Me():RemoveEventListener(MyselfEvent.DeathBegin, self.HandleMyselfPlayerDeath, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.QuestQuestUpdate, self.HandleCheckQuestCondition, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.QuestQuestList, self.HandleCheckQuestCondition, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.QuestQuestStepUpdate, self.HandleCheckQuestCondition, self)
  EventManager.Me():RemoveEventListener(PetEvent.SendHug, self.HandleHugPet, self)
  EventManager.Me():RemoveEventListener(MyselfEvent.BeginSkillBroadcast, self.HandleSkillBroadcastCheck, self)
  EventManager.Me():RemoveEventListener(MyselfEvent.BeHited, self.HandleMyselfPlayerBeHit, self)
  EventManager.Me():RemoveEventListener(ItemEvent.EquipUpdate, self.HandleMyselfMountChange, self)
  EventManager.Me():RemoveEventListener(EscortEvent.HandStatusBuff, self.TryHandleCollectHugHandStatusBuff, self)
  self:OnLeaveScene()
  self:Clear()
end

function InteractLocalManager:Clear()
  redlog("InteractLocalManager:Clear")
  for k, v in pairs(self.interactGroupMap) do
    if v.config.type ~= "serversimple" then
      v:Destroy()
      self.interactGroupMap[k] = nil
    end
  end
  self.interactNpcMap = {}
  self.interactNpcCount = 0
  if self.myselfDuringInteractGuid then
    self.myselfDuringInteractGuid = nil
    GameFacade:sendNotification(InteractLocalEvent.MyselfInteractChange, false)
  end
  self:ClearTrigger()
  self:ClearKeepOnSuccessCreatures()
end

function InteractLocalManager:ClearTrigger()
  self.isInTrigger = false
  GameFacade:sendNotification(InteractLocalEvent.MyselfTriggerChange, {trigger = false})
end

function InteractLocalManager:RegisterInteractNpc(staticid, id)
  local data = Table_InteractNpc[staticid]
  if data == nil then
    return
  end
  self:_Register(data, id)
end

function InteractLocalManager:UnregisterInteractNpc(id)
  local count = self.interactNpcCount
  self:_Unregister(id)
  if 0 < count and self.interactNpcCount == 0 then
    self:ClearTrigger()
  end
end

function InteractLocalManager:_Register(data, id)
  local interactNpc = self.interactNpcMap[id]
  if interactNpc ~= nil then
    return
  end
  local interactGroup = self:GetInteractNpcGroup(id)
  if not interactGroup then
    return
  end
  if interactGroup.config.type == "placeto" then
    interactNpc = InteractLocalHug.Create(data, id)
  else
    interactNpc = InteractLocalSimple.Create(data, id)
  end
  interactGroup:AddInteractNpc(interactNpc)
  self.interactNpcMap[id] = interactNpc
  self.interactNpcCount = self.interactNpcCount + 1
end

function InteractLocalManager:_Unregister(id)
  local interactNpc = self.interactNpcMap[id]
  if interactNpc ~= nil then
    interactNpc:RequestGetOffAll()
    local interactGroup = self:GetInteractNpcGroup(interactNpc)
    interactGroup:RemoveInteractNpc(interactNpc)
    interactNpc:Destroy()
    self.interactNpcMap[id] = nil
    self.interactNpcCount = self.interactNpcCount - 1
  end
end

function InteractLocalManager:RegisterInteractServerNpc(staticid, id)
  local data = Table_InteractNpc[staticid]
  if data == nil then
    return
  end
  self:_RegisterServerNpc(InteractNpc, data, id)
end

function InteractLocalManager:UnregisterInteractServerNpc(id)
  local count = self.interactNpcCount
  self:_UnregisterServerNpc(id)
  if 0 < count and self.interactNpcCount == 0 then
    self:ClearTrigger()
  end
end

function InteractLocalManager:_RegisterServerNpc(class, data, id)
  local interactNpc = self.interactNpcMap[id]
  if interactNpc ~= nil then
    return
  end
  interactNpc = class.Create(data, id)
  if not interactNpc.noInteractGroup then
    local interactGroup = self:GetInteractServerNpcGroup(id)
    if interactGroup then
      interactGroup:AddInteractNpc(interactNpc)
    end
  end
  self.interactNpcMap[id] = interactNpc
  self.interactNpcCount = self.interactNpcCount + 1
end

function InteractLocalManager:_UnregisterServerNpc(id)
  local interactNpc = self.interactNpcMap[id]
  if interactNpc ~= nil then
    interactNpc:RequestGetOffAll()
    local interactGroup = self:GetInteractServerNpcGroup(interactNpc)
    if interactGroup then
      interactGroup:RemoveInteractNpc(interactNpc)
    end
    interactNpc:Destroy()
    self.interactNpcMap[id] = nil
    self.interactNpcCount = self.interactNpcCount - 1
  end
end

function InteractLocalManager:MyselfManualClick()
  self:TryStartInteract()
end

function InteractLocalManager:TryStartInteract(id)
  id = id or self.lockNpcGuid
  if id ~= nil and not self:IsMyselfDuringInteract() and self.lockNpcGuid ~= nil then
    local interactNpc = self.interactNpcMap[self.lockNpcGuid]
    if interactNpc and (interactNpc.interactGroup ~= nil or interactNpc.noInteractGroup) then
      self:SetMyselfDuringInteract(interactNpc.id)
      interactNpc:StartInteract()
      if interactNpc.interactGroup then
        interactNpc.interactGroup:StartInteract(interactNpc.id)
      end
      return true
    end
  end
  return false
end

function InteractLocalManager:EndInteract()
  if self:IsMyselfDuringInteract() then
    local interactNpc = self.interactNpcMap[self.myselfDuringInteractGuid]
    local groupInteractEnd = true
    self:SetMyselfDuringInteract()
    if interactNpc and (interactNpc.interactGroup ~= nil or interactNpc.noInteractGroup) and interactNpc.interactGroup then
      groupInteractEnd = interactNpc.interactGroup:EndInteract(interactNpc.id)
    end
  end
end

function InteractLocalManager:GetOffAll()
  for k, v in pairs(self.interactNpcMap) do
    if v.RequestGetOffAll then
      v:RequestGetOffAll()
    end
  end
end

function InteractLocalManager:GetInteractPrompt()
end

function InteractLocalManager:GroupInteractEnd(interactGroup)
  if self:IsMyselfDuringInteract() then
    local interactNpc = self.interactNpcMap[self.myselfDuringInteractGuid]
    if interactNpc and interactNpc.interactGroup == interactGroup then
      self:SetMyselfDuringInteract()
    end
  end
end

function InteractLocalManager:IsInteractBusy()
  return not self.running or self:IsMyselfDuringInteract() or self:IsMyselfGetOnInteract()
end

function InteractLocalManager:IsMyselfDuringInteract()
  return self.myselfDuringInteractGuid ~= nil
end

function InteractLocalManager:IsMyselfGetOnInteract()
  if self.lockNpcGuid ~= nil then
    local interactNpc = self.interactNpcMap[self.lockNpcGuid]
    if interactNpc and interactNpc.IsHug and interactNpc:IsHug() then
      return true
    end
  end
end

function InteractLocalManager:SetMyselfDuringInteract(id)
  self.myselfDuringInteractGuid = id
  GameFacade:sendNotification(InteractLocalEvent.MyselfInteractChange, self.myselfDuringInteractGuid ~= nil)
end

function InteractLocalManager:AddInteractObject(id)
  self:RegisterInteractNpc(id, id)
end

function InteractLocalManager:RemoveInteractObject(id)
  self:UnregisterInteractNpc(id)
end

function InteractLocalManager:_TrySendMyselfTriggerChange(isInTrigger, triggerPrompt, triggerIcon)
  if isInTrigger and self.myselfOnNpcStaticID ~= nil then
    isInTrigger = InteractLocalManager.CheckMyselfInNpcInteractArea(self.myselfOnNpcStaticID)
  end
  GameFacade:sendNotification(InteractLocalEvent.MyselfTriggerChange, {
    trigger = isInTrigger,
    prompt = triggerPrompt,
    icon = triggerIcon
  })
end

function InteractLocalManager.CheckMyselfInNpcInteractArea(npcID)
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

function InteractLocalManager:OnSceneLoaded()
  redlog("InteractLocalManager", "OnSceneLoaded / SwitchLine / Reconnect")
  self:Clear()
end

function InteractLocalManager:OnLeaveScene()
  redlog("InteractLocalManager", "OnLeaveScene")
end

function InteractLocalManager:HandleReconnect()
  redlog("InteractLocalManager", "HandleReconnect")
end

function InteractLocalManager:HandleMyselfPlayerDeath(note)
  self:EndInteract()
  self:GetOffAll()
end

function InteractLocalManager:HandleHugPet(note)
  if note.isHug then
    self:BreakInteractLocalHug()
    self.hugPetIdCache = note.id
  else
    self.hugPetIdCache = nil
  end
end

function InteractLocalManager:HandleSkillBroadcastCheck(note)
  self:BreakInteractLocalHug()
end

function InteractLocalManager:HandleMyselfPlayerBeHit(note)
  TimeTickManager.Me():CreateOnceDelayTick(10, function(owner, deltaTime)
    self:BreakInteractLocalHug()
  end, self)
end

function InteractLocalManager:HandleMyselfMountChange()
  local mount = BagProxy.Instance.roleEquip:GetMount()
  if mount then
    self:BreakInteractLocalHug()
  end
end

function InteractLocalManager:HandleCheckQuestCondition(note)
  for k, v in pairs(self.interactGroupMap) do
    v:CheckQuestCondition()
  end
end

local checkHugNpcId = {
  850042,
  850043,
  850044
}

function InteractLocalManager:TryHandleCollectHugHandStatusBuff(note)
  local data = note.data
  local buffId, npcId = unpack(data)
  if TableUtility.ArrayFindIndex(checkHugNpcId, npcId) > 0 then
    for k, v in pairs(self.interactNpcMap) do
      if v.__cname == "InteractLocalCollectHug" and v:IsHug() then
        v:SetServerHoldPet(buffId, npcId)
        return
      end
    end
  end
end

function InteractLocalManager:OnInteractLocalHugBreakOther()
  if Game.Myself.data:IsTransformed() then
  end
  if Game.Myself.data:IsInMagicMachine() then
  end
  if Game.Myself.data:IsOnWolf() then
    local skill = SkillProxy.Instance:GetLearnedSkillBySortID(1240)
    if skill then
      Game.Myself:Client_UseSkill(skill.staticData.id)
    end
  end
  if self.hugPetIdCache then
    ServiceScenePetProxy.Instance:CallHandPetPetCmd(self.hugPetIdCache, true)
  end
  local mount = BagProxy.Instance.roleEquip:GetMount()
  if mount then
    FunctionItemFunc.OffEquip_Equip(mount)
  end
end

function InteractLocalManager:BreakInteractLocalHug()
  for k, v in pairs(self.interactNpcMap) do
    if v.IsHug and v:IsHug() and k == self.lockNpcGuid then
      self:TryStartInteract()
      return
    end
  end
end

function InteractLocalManager.GetGroupCenterPos(config)
  if config and config.pos then
    local pos = LuaVector3.Zero()
    for i = 1, #config.pos do
      LuaVector3.Better_Add(pos, config.pos[i], pos)
    end
    LuaVector3.Better_Mul(pos, 1 / #config.pos, pos)
    return pos
  end
end

function InteractLocalManager:TryGetInteractGroup(id)
  return self.interactGroupMap[id]
end

function InteractLocalManager:CreateInteractGroup(id, config, successCallback, failCallback)
  local interactGroup = self.interactGroupMap[id]
  if interactGroup == nil then
    interactGroup = InteractLocalGroup.Create(config)
    interactGroup:Init(id, config, successCallback, failCallback)
    self.interactGroupMap[id] = interactGroup
  end
  return interactGroup
end

function InteractLocalManager:DestroyInteractGroup(id, keepOnSuccess)
  local interactGroup = self.interactGroupMap[id]
  if interactGroup ~= nil then
    interactGroup:Destroy(keepOnSuccess)
    self.interactGroupMap[id] = nil
  end
end

function InteractLocalManager:ActivateInteractGroup(id)
  local interactGroup = self.interactGroupMap[id]
  if interactGroup ~= nil then
    interactGroup:Activate()
  end
end

function InteractLocalManager:DeactivateInteractGroup(id)
  local interactGroup = self.interactGroupMap[id]
  if interactGroup ~= nil then
    interactGroup:Deactivate()
  end
end

function InteractLocalManager:GetInteractNpcGroup(interactNpc)
  if type(interactNpc) == "number" then
    local groupID = math.floor(interactNpc / 100)
    return self.interactGroupMap[groupID]
  end
  if interactNpc.interactGroup then
    return interactNpc.interactGroup
  end
  local groupID = math.floor(interactNpc.id / 100)
  return self.interactGroupMap[groupID]
end

function InteractLocalManager:GetInteractServerNpcGroup(interactNpc)
  if type(interactNpc) == "number" then
    local groupID = interactNpc
    return self.interactGroupMap[groupID]
  end
  if interactNpc.interactGroup then
    return interactNpc.interactGroup
  end
  local groupID = interactNpc.id
  return self.interactGroupMap[groupID]
end

function InteractLocalManager:AddKeepOnSuccessCreature(uid)
  if not self.keepOnSuccessCreatures then
    self.keepOnSuccessCreatures = {}
  end
  self.keepOnSuccessCreatures[uid] = true
end

function InteractLocalManager:ClearKeepOnSuccessCreatures()
  if self.keepOnSuccessCreatures then
    for k, v in pairs(self.keepOnSuccessCreatures) do
      NSceneNpcProxy.Instance:Remove(k)
    end
    self.keepOnSuccessCreatures = nil
  end
end

function InteractLocalManager:ManualUnregisterInteractNpc(uid, interactLocal)
  local npc = interactLocal:GetNpc()
  if npc then
    npc:UnregisterInteractNpc()
  end
end

local tempV3, tempRot = LuaVector3(), LuaQuaternion()
InteractLocalGroup = class("InteractLocalGroup")

function InteractLocalGroup:ctor()
  self.uid = 0
  self.interactNpcInGroup = {}
end

function InteractLocalGroup:Init(uid, config, successCallback, failCallback)
  self.uid = uid
  self.config = config
  self.pos = InteractLocalManager.GetGroupCenterPos(config)
  self.successCallback = successCallback
  self.failCallback = failCallback
end

function InteractLocalGroup:Destroy(keepOnSuccess)
  self:Deactivate(keepOnSuccess, true)
  self.interactNpcInGroup = nil
  self.uid = 0
end

function InteractLocalGroup:AddInteractNpc(interactNpc)
  self.interactNpcInGroup[interactNpc.id] = interactNpc
  interactNpc:BindGroup(self)
end

function InteractLocalGroup:RemoveInteractNpc(interactNpc)
  if self.interactNpcInGroup then
    self.interactNpcInGroup[interactNpc.id] = nil
  end
  interactNpc:UnbindGroup()
end

function InteractLocalGroup:_CreateCreature(uid, nid, pos, dir, npc_uid)
  local creature = NSceneNpcProxy.Instance:Find(uid)
  if not creature then
    local data = {}
    data.ID = nid
    data.guid = uid
    data.uniqueID = npc_uid
    local posX, posY, posZ = 0, 0, 0
    if pos then
      posX = pos.x or pos[1] or posX
      posY = pos.y or pos[2] or posY
      posZ = pos.z or pos[3] or posZ
    end
    data.position = {
      posX,
      posY,
      posZ
    }
    data.dir = dir
    data.isInteractLocal = true
    local clientData = NpcData.CreateClientData(data)
    if clientData then
      clientData.isInteractLocal = true
      local regByUniqueId = npc_uid and npc_uid ~= 0 or false
      if regByUniqueId then
        local clientNpc, id = NSceneNpcProxy.Instance:GetClientNpcInfo(nil, npc_uid)
        if clientNpc then
          NSceneNpcProxy.Instance:RemoveFromClientMap(id)
          clientNpc.data:InitByClient(clientData)
          clientNpc:Init(clientData)
          creature = clientNpc
        else
          creature = NNpc.CreateAsTable(clientData)
        end
      else
        creature = NNpc.CreateAsTable(clientData)
      end
      NSceneNpcProxy.Instance:AddClientNpc(creature, regByUniqueId)
    end
    local staticData = creature.data.staticData
    if staticData then
      if staticData.ShowName then
        creature.data.userdata:Set(UDEnum.SHOWNAME, staticData.ShowName)
      end
      if staticData.Scale then
        creature:Server_SetScaleCmd(staticData.Scale, true)
      end
      if staticData.Behaviors then
        creature.data:SetBehaviourData(staticData.Behaviors)
      end
    end
    local noAccessable = creature.data:NoAccessable()
    creature.assetRole:SetColliderEnable(not noAccessable)
  else
    redlog("InteractLocalGroup WYF:存在已有的npc[2]", self.uid, uid)
  end
end

function InteractLocalGroup:_RemoveCreature(uid)
  NSceneNpcProxy.Instance:Remove(uid)
end

function InteractLocalGroup:Activate()
  if self.isActive then
    return
  end
  self.isActive = true
  local member, uid, pos, npc_uid
  for i = 1, #self.config.members do
    member = self.config.members[i]
    uid = self.uid * 100 + i
    pos = self.config.pos[i]
    npc_uid = self.config.member_uids and self.config.member_uids[i]
    local interactNpc = self.interactNpcInGroup[uid]
    if not interactNpc then
      self:_CreateCreature(uid, member, pos, pos[4], npc_uid)
    end
  end
end

function InteractLocalGroup:Deactivate(keepOnSuccess, isDestroy)
  self.isActive = false
  for uid, interactLocal in pairs(self.interactNpcInGroup) do
    if isDestroy then
      InteractLocalManager.Me():ManualUnregisterInteractNpc(uid, interactLocal)
    elseif interactLocal.RequestGetOffAll then
      interactLocal:RequestGetOffAll()
    end
    if keepOnSuccess then
      InteractLocalManager.Me():AddKeepOnSuccessCreature(uid)
    else
      self:_RemoveCreature(uid)
    end
  end
  self:ResetCheck()
end

function InteractLocalGroup:IsActive()
  return self.isActive == true
end

function InteractLocalGroup:StartInteract(id)
  self.inInteract = true
end

function InteractLocalGroup:EndInteract(id)
  self.inInteract = false
  return not self:FinalCheck(id)
end

function InteractLocalGroup:FinalCheck(id)
  if self.config.check_quest and #self.config.check_quest > 0 then
    for i = 1, #self.config.check_quest do
      if not QuestProxy.Instance:isQuestComplete(self.config.check_quest[i]) then
        return false
      end
    end
  end
  return self:Check(id)
end

function InteractLocalGroup:CheckQuestCondition()
  if self.inInteract then
    return
  end
  if self.config.check_quest and #self.config.check_quest > 0 then
    self:FinalCheck()
  end
end

function InteractLocalGroup:ResetCheck()
end

function InteractLocalGroup:DoGroupAction(plot, finishCb)
  self:PlayGroupFreePlot(plot, finishCb)
end

function InteractLocalGroup:PlayGroupFreePlot(plot_id, end_cb, end_cb_args)
  if plot_id then
    local targets = {}
    for _, v in pairs(self.interactNpcInGroup) do
      table.insert(targets, v.id)
    end
    targets._is_multi = true
    local anchorPos, anchorDir = self:_GetPlotAnchorSetting()
    self.actionInstanceId = Game.PlotStoryManager:Start_PQTLP(plot_id, function()
      if end_cb then
        end_cb(end_cb_args)
      end
      self.actionInstanceId = nil
    end, nil, nil, false, nil, {
      myself = targets,
      player = Game.Myself.data.id
    }, nil, nil, nil, nil, nil, nil, anchorPos, anchorDir)
  end
end

function InteractLocalGroup:_GetPlotAnchorSetting()
  local anchorPos, anchorDir
  local uniqueId = self.config.cutSceneTargetUniqueId
  if uniqueId then
    local npcId = Game.MapManager:GetNpcIDByUniqueID(uniqueId)
    anchorPos = Game.MapManager:GetNpcPosByUniqueID(uniqueId)
    local npcConfig = Table_Npc[npcId]
    if npcConfig and npcConfig.Feature == 64 then
      NavMeshUtility.SelfSample(anchorPos, 1)
    end
    local dir = Game.MapManager:GetNpcDirByUniqueID(uniqueId)
    if dir then
      anchorDir = LuaVector3.Zero()
      LuaVector3.Better_Set(anchorDir, 0, dir, 0)
    end
  elseif self.config.cutSceneAnchorPlayer == 1 then
    anchorPos = Game.Myself:GetPosition()
    local dir = Game.Myself:GetAngleY()
    anchorDir = LuaVector3.Zero()
    LuaVector3.Better_Set(anchorDir, 0, dir, 0)
  end
  return anchorPos, anchorDir
end

function InteractLocalGroup:OnInteractSuccess()
  if self.config.fin_act then
    self:DoGroupAction(self.config.fin_act, self.successCallback)
  elseif self.successCallback then
    self.successCallback()
  end
end

function InteractLocalGroup:OnInteractFail()
  if self.config.fail_act then
    self:DoGroupAction(self.config.fail_act, self.failCallback)
  elseif self.failCallback then
    self.failCallback()
  end
end

function InteractLocalGroup.Create(config)
  if config.type == "seq" then
    return InteractLocalGroup_Seq.new()
  elseif config.type == "dir" then
    return InteractLocalGroup_Dir.new()
  elseif config.type == "placeto" then
    return InteractLocalGroup_PlaceTo.new()
  elseif config.type == "serversimple" then
    return InteractLocalGroup_ServerSimple.new()
  end
end

InteractLocalGroup_ServerSimple = class("InteractLocalGroup_ServerSimple", InteractLocalGroup)

function InteractLocalGroup_ServerSimple:Init(uid, config, successCallback, failCallback)
  InteractLocalGroup.Init(self, uid, config, successCallback, failCallback)
  self.config.max_interact_times = 1
end

function InteractLocalGroup_ServerSimple:Check(id)
  self:OnInteractSuccess()
  return true
end

function InteractLocalGroup_ServerSimple:AddInteractNpc(interactNpc, id)
  self.interactNpcInGroup[id or interactNpc.id] = interactNpc
  interactNpc:BindGroup(self)
end

function InteractLocalGroup_ServerSimple:Activate()
  self.isActive = true
  local uid = self.config.npc
  if not self.interactNpcInGroup[uid] then
    local interactNpc = InteractLocalManager.Me().interactNpcMap[uid]
    if interactNpc then
      self:AddInteractNpc(interactNpc, uid)
    end
  end
end

function InteractLocalGroup_ServerSimple:Deactivate()
  self.isActive = false
  self:ResetCheck()
end

InteractLocalGroup_Seq = class("InteractLocalGroup_Seq", InteractLocalGroup)

function InteractLocalGroup_Seq:Init(uid, config, successCallback, failCallback)
  InteractLocalGroup.Init(self, uid, config, successCallback, failCallback)
  self.config.max_interact_times = 1
  
  function self.failCallback()
    for _, v in pairs(self.interactNpcInGroup) do
      v:ResetInteract()
    end
    self:ResetCheck()
  end
end

function InteractLocalGroup_Seq:Check(id)
  if id then
    local interactNpc = self.interactNpcInGroup[id]
    local groupID = interactNpc:GetIdInGroup()
    if not self.record_seq then
      self.record_seq = {}
    end
    ArrayPushBack(self.record_seq, groupID)
  end
  local check_param = self.config.check
  local found_match = false
  local found_match_all = false
  for i = 1, #check_param do
    for j = 1, #check_param[i] do
      if not self.record_seq[j] then
        found_match = true
        break
      else
        if self.record_seq[j] ~= check_param[i][j] then
          break
        end
        if j == #check_param[i] then
          found_match_all = true
          break
        end
      end
    end
    if found_match or found_match_all then
      break
    end
  end
  if found_match_all then
    self:OnInteractSuccess()
    return true
  elseif found_match then
  else
    self:OnInteractFail()
    return true
  end
end

function InteractLocalGroup_Seq:ResetCheck()
  self.record_seq = nil
end

InteractLocalGroup_Dir = class("InteractLocalGroup_Dir", InteractLocalGroup)
local format_dir = {
  [0] = 0,
  [1] = 90,
  [2] = 180,
  [3] = 270
}
local normalize_dir = function(dir)
  dir = dir % 360
  if dir < 0 then
    dir = dir + 360
  end
  dir = math.round(dir / 90)
  dir = dir % 4
  return dir
end
local format2_dir = function(dir)
  dir = dir % 360
  if dir < 0 then
    dir = dir + 360
  end
  return dir
end
local check_dir_equal = function(a, b)
  return math.abs(format2_dir(a) - format2_dir(b)) < 10
end

function InteractLocalGroup_Dir:Init(uid, config, successCallback, failCallback)
  InteractLocalGroup.Init(self, uid, config, successCallback, failCallback)
end

function InteractLocalGroup_Dir:Check(id)
  if not self.record_dir then
    self.record_dir = {}
  end
  for _, v in pairs(self.interactNpcInGroup) do
    local dir = v:GetDir()
    self.record_dir[v:GetIdInGroup()] = dir
  end
  local check_param = self.config.check
  local found_match_all = false
  local found_match_id
  for i = 1, #check_param do
    for j = 1, #check_param[i] do
      if not (self.record_dir[j] and check_dir_equal(self.record_dir[j], check_param[i][j])) then
        break
      end
      if j == #check_param[i] then
        found_match_all = true
        break
      end
    end
    if found_match_all then
      found_match_id = i
      break
    end
  end
  if found_match_all then
    self:OnCheckSuccessResetNpcParams()
    self:OnInteractSuccess()
    return true
  else
  end
end

function InteractLocalGroup_Dir:OnCheckSuccessResetNpcParams()
  for _, v in pairs(self.interactNpcInGroup) do
    local npc = v:GetNpc()
    npc:SyncPosAndDirToClientData()
  end
end

function InteractLocalGroup_Dir:ResetCheck()
  self.record_dir = nil
end

InteractLocalGroup_PlaceTo = class("InteractLocalGroup_PlaceTo", InteractLocalGroup)

function InteractLocalGroup_PlaceTo:Init(uid, groupID, config, successCallback, failCallback)
  InteractLocalGroup_PlaceTo.super.Init(self, uid, groupID, config, successCallback, failCallback)
  self.check_pos = {}
  for i = 1, #self.config.slots do
    self.check_pos[i] = LuaVector3.Better_Clone(self.config.slots[i])
  end
end

function InteractLocalGroup_PlaceTo:GetInitialPos()
  return self.pos
end

function InteractLocalGroup_PlaceTo:GetSafeInBoundPos(pos)
  local center_pos = InteractLocalManager.GetGroupCenterPos(self.config)
  local distance_xz = VectorUtility.DistanceXZ(pos, center_pos)
  local safe_distance = self.config.distance * 0.98
  if distance_xz > safe_distance then
    VectorUtility.TryLerpUnclamped_3(pos, center_pos, pos, safe_distance / distance_xz)
  end
  return pos
end

function InteractLocalGroup_PlaceTo:CheckSafeInBoundPos(pos)
  local center_pos = InteractLocalManager.GetGroupCenterPos(self.config)
  local distance_xz = VectorUtility.DistanceXZ(pos, center_pos)
  local safe_distance = self.config.distance * 0.98
  return distance_xz <= safe_distance
end

local max_match_dist_sqr = 4

function InteractLocalGroup_PlaceTo:TryMatchBestSlot(pos)
  local best_slot = 0
  local best_dist = 0
  local matched_slot = {}
  local slot_dir
  for _, v in pairs(self.interactNpcInGroup) do
    local slot = v:GetPlaceSlot()
    if slot then
      matched_slot[slot] = true
    end
  end
  local check_pos = self.check_pos
  LuaVector2.Better_Set(tempV2, pos[1], pos[3])
  for i = 1, #check_pos do
    if not matched_slot[i] then
      local dist = LuaVector2.Distance_Square(tempV2, check_pos[i])
      if dist < max_match_dist_sqr and (best_slot == 0 or best_dist > dist) then
        best_slot = i
        best_dist = dist
      end
    end
  end
  if 0 < best_slot then
    LuaVector3.Better_Set(tempV3, check_pos[best_slot][1], pos[2], check_pos[best_slot][2])
    slot_dir = check_pos[best_slot][3]
  end
  return best_slot, tempV3, slot_dir
end

function InteractLocalGroup_PlaceTo:Check(id)
  if not self.record_slot then
    self.record_slot = {}
  end
  for _, v in pairs(self.interactNpcInGroup) do
    if v:IsHug() then
      return
    end
    local slot = v:GetPlaceSlot()
    if not slot or slot < 1 then
      return
    end
    self.record_slot[v:GetIdInGroup()] = slot
  end
  local check_param = self.config.check
  local found_match_all = false
  local found_match_id
  for i = 1, #check_param do
    for j = 1, #check_param[i] do
      if not self.record_slot[j] or self.record_slot[j] ~= check_param[i][j] then
        break
      end
      if j == #check_param[i] then
        found_match_all = true
        break
      end
    end
    if found_match_all then
      found_match_id = i
      break
    end
  end
  if found_match_all then
    self:OnCheckSuccessResetNpcParams()
    self:OnInteractSuccess()
    return true
  else
  end
end

function InteractLocalGroup_PlaceTo:OnCheckSuccessResetNpcParams()
  local temp_start_id = 11451419
  local temp_map = {}
  for _, v in pairs(self.interactNpcInGroup) do
    local ori_index = v:GetIdInGroup()
    local final_index = self.record_slot[ori_index]
    local npc = v:GetNpc()
    if ori_index ~= final_index then
      local npc_uid = self.config.member_uids and self.config.member_uids[final_index]
      if npc_uid then
        NSceneNpcProxy:ChangeClientNpc(npc.data.uniqueid, temp_start_id)
        npc.data.uniqueid = npc_uid
        temp_map[temp_start_id] = npc_uid
        temp_start_id = temp_start_id + 1
      end
    end
    npc:SyncPosAndDirToClientData()
  end
  for k, v in pairs(temp_map) do
    NSceneNpcProxy:ChangeClientNpc(k, v)
  end
end

function InteractLocalGroup_PlaceTo:ResetCheck()
  self.record_slot = nil
end
