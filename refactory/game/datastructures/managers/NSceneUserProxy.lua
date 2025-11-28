autoImport("SceneCreatureProxy")
NSceneUserProxy = class("NSceneUserProxy", SceneCreatureProxy)
NSceneUserProxy.Instance = nil
NSceneUserProxy.NAME = "NSceneUserProxy"
local GROUP_EFFECT_CFG = GameConfig.GroupEquip
local ArrayFindIndex = TableUtility.ArrayFindIndex
local _SqrDistance = LuaVector3.Distance_Square

function NSceneUserProxy:ctor(proxyName, data)
  self:CountClear()
  self.userMap = {}
  if NSceneUserProxy.Instance == nil then
    NSceneUserProxy.Instance = self
  end
  self.proxyName = proxyName or NSceneUserProxy.NAME
  if Game and Game.LogicManager_Creature then
    Game.LogicManager_Creature:SetSceneUserProxy(self)
  end
end

function NSceneUserProxy:FindOtherRole(guid)
  if Game.Myself and Game.Myself.data and Game.Myself.data.id == guid then
    return nil
  end
  return self:Find(guid)
end

function NSceneUserProxy:Find(guid)
  if Game.Myself and Game.Myself.data and Game.Myself.data.id == guid then
    return Game.Myself
  end
  return self.userMap[guid]
end

function NSceneUserProxy:SyncMove(data, isPathFidingOptOn)
  local role = self:FindOtherRole(data.charid)
  if nil ~= role then
    local pos = data.pos
    if not role:Server_SetSkillMove(pos.x, pos.y, pos.z) then
      role:Server_MoveToXYZCmd(pos.x, pos.y, pos.z)
      MyselfProxy.Instance:UpdateObPosition(role.data.id, pos.x, pos.y, pos.z)
    end
    return true
  end
  return false
end

function NSceneUserProxy:SyncServerSkill(data)
  if nil ~= data.petid and 0 ~= data.petid then
    if data.petid > 0 then
      return self:SyncServerPetSkill(data)
    elseif not self:NotifyUseSkill(data) then
      return NSceneUserProxy.super.SyncServerSkill(self, data)
    end
  else
    return NSceneUserProxy.super.SyncServerSkill(self, data)
  end
end

function NSceneUserProxy:Add(data, classRef)
  local role
  if Game.Myself.data.id == data.guid then
    role = Game.Myself
    role.data:SetAchievementtitle(data.achievetitle)
    local sceneUI = role:GetSceneUI() or nil
    if sceneUI and sceneUI.roleBottomUI then
      sceneUI.roleBottomUI:HandleChangeTitle(role)
    end
    role.data:SetTeamID(data.teamid)
    role:Server_SetUserDatas(data.datas)
  else
    role = self:Find(data.guid)
    if nil ~= role then
      return role
    end
    role = NPlayer.CreateAsTable(data)
    self.userMap[data.guid] = role
    self:CountPlus()
    Game.InteractNpcManager:UpdateMultiMountStatus(role)
    local chantskill = data.chantskill
    if chantskill then
      role:SetChantSkill(chantskill)
    end
  end
  self:HandleAddScenicBuffs(data)
  local spEffectDatas = data.speffectdata
  if nil ~= spEffectDatas then
    for i = 1, #spEffectDatas do
      role:Server_AddSpEffect(spEffectDatas[i])
    end
  end
  local skilleffects = data.skilleffects
  if skilleffects ~= nil then
    local _SkillDynamicManager = Game.SkillDynamicManager
    for i = 1, #skilleffects do
      _SkillDynamicManager:AddDynamicEffect(data.guid, skilleffects[i])
    end
  end
  role.data:ClearSecretLand()
  local secret_land_gem = data.secret_land_gem
  if nil ~= secret_land_gem then
    for i = 1, #secret_land_gem do
      role.data:UpdateSecretLand(secret_land_gem[i].id, secret_land_gem[i].lv)
    end
  end
  role:RegistCulling()
  role.data:SyncBuffSource(data.syncbuff)
  SceneAINpcProxy.Instance:AddHandNpc(role, data.handnpc, data.pos)
  SceneAINpcProxy.Instance:AddExpressNpc(role, data.givenpcdatas, data.pos)
  return role
end

local tmpRoles = {}

function NSceneUserProxy:PureAddSome(datas)
  for i = 1, #datas do
    if datas[i] ~= nil then
      local role = self:Add(datas[i])
      if role ~= nil then
        tmpRoles[#tmpRoles + 1] = role
      end
    end
  end
  GameFacade.Instance:sendNotification(SceneUserEvent.SceneAddRoles, tmpRoles)
  EventManager.Me():PassEvent(SceneUserEvent.SceneAddRoles, tmpRoles)
  SceneCarrierProxy.Instance:PureAddSome(datas)
  TableUtility.TableClear(tmpRoles)
end

function NSceneUserProxy:FindCreateByGuild(guild, array)
  TableUtility.TableClear(array)
  for k, user in pairs(self.userMap) do
    local guildData = user.data:GetGuildData()
    if guildData and guildData.id == guild then
      array[#array + 1] = user
    end
  end
  local myself = Game.Myself
  local myGuildData = myself and myself.data and myself.data:GetGuildData()
  if myGuildData and myGuildData.id == guild then
    array[#array + 1] = myself
  end
end

function NSceneUserProxy:CheckUpdataUserData(oldValue, newValue)
  local activeFunc = FunctionActivity.Me()
  if activeFunc:CheckIsKfcEffectEquip(oldValue) or activeFunc:CheckIsKfcEffectEquip(newValue) then
    self:FindGroupUserByPath()
  end
end

function NSceneUserProxy:RemoveSome(guids)
  local roles = NSceneUserProxy.super.RemoveSome(self, guids)
  if roles and 0 < #roles then
    GameFacade.Instance:sendNotification(SceneUserEvent.SceneRemoveRoles, roles)
    EventManager.Me():PassEvent(SceneUserEvent.SceneRemoveRoles, roles)
    self:HandleRemoveScenicBuffs(roles)
  end
end

local tempPos = LuaVector3.Zero()
local nearUserList = {}

function NSceneUserProxy:FindNearUsers(position, distance, filter)
  if Game.LogicManager_MapCell:IsCreatureUpdateWorking() then
  end
  LuaVector3.Better_Set(tempPos, position[1], position[2], position[3])
  TableUtility.TableClear(nearUserList)
  local sqrDis = distance * distance
  for k, user in pairs(self.userMap) do
    if sqrDis >= _SqrDistance(user:GetPosition(), tempPos) and (nil == filter or filter(user)) then
      table.insert(nearUserList, user)
    end
  end
  return nearUserList
end

function NSceneUserProxy:FindTeamMemberInRange(position, distance, filter)
  local myTeamData = TeamProxy.Instance.myTeam
  if not myTeamData then
    return
  end
  local memberList = myTeamData:GetPlayerMemberList(false, true)
  LuaVector3.Better_Set(tempPos, position[1], position[2], position[3])
  local minDistSqr = distance * distance
  local player, userdata, distSqr
  for _, memberData in ipairs(memberList) do
    if memberData then
      player = self:Find(memberData.id)
      if player then
        distSqr = _SqrDistance(player:GetPosition(), tempPos)
        if minDistSqr >= distSqr and (nil == filter or filter(player)) then
          return player
        end
      end
    end
  end
end

function NSceneUserProxy:FindUserInRange(position, distance, filter)
  if Game.LogicManager_MapCell:IsCreatureUpdateWorking() then
    return Game.LogicManager_MapCell:FindCreatureAround(position, filter, distance, Creature_Type.Player)
  end
  LuaVector3.Better_Set(tempPos, position[1], position[2], position[3])
  local minDistSq = distance * distance
  for k, user in pairs(self.userMap) do
    if minDistSq >= _SqrDistance(user:GetPosition(), tempPos) and (nil == filter or filter(user)) then
      return user
    end
  end
end

function NSceneUserProxy:FindNearestUser(position, distance, filter)
  if Game.LogicManager_MapCell:IsCreatureUpdateWorking() then
    return Game.LogicManager_MapCell:FindNearestCreatureAround(position, filter, distance, Creature_Type.Player)
  end
  LuaVector3.Better_Set(tempPos, position[1], position[2], position[3])
  local nearestUser
  local minDistSq = distance * distance
  local dist
  for k, user in pairs(self.userMap) do
    dist = _SqrDistance(user:GetPosition(), tempPos)
    if minDistSq >= dist and (nil == filter or filter(user)) then
      minDistSq = dist
      nearestUser = user
    end
  end
  return nearestUser
end

function NSceneUserProxy:TraversingCreatureAround(position, distance, action)
  if Game.LogicManager_MapCell:IsCreatureUpdateWorking() then
    Game.LogicManager_MapCell:TraversingCreatureAround(position, action, distance, Creature_Type.Player)
    return
  end
  if not action then
    return
  end
  LuaVector3.Better_Set(tempPos, position[1], position[2], position[3])
  local sqrDis = distance * distance
  for k, user in pairs(self.userMap) do
    if sqrDis >= _SqrDistance(user:GetPosition(), tempPos) then
      action(user)
    end
  end
end

function NSceneUserProxy:FindGroupUserByPath()
  if nil == GROUP_EFFECT_CFG then
    return
  end
  self:ClearGroupEff()
  for path, groupIDs in pairs(GROUP_EFFECT_CFG) do
    for p = 1, #groupIDs do
      self:CheckGroupUser(groupIDs[p], path)
    end
  end
end

function NSceneUserProxy:CheckUserInRange(guid, position, distance)
  local user = self:Find(guid)
  if not user then
    return
  end
  if distance then
    LuaVector3.Better_Set(tempPos, position[1], position[2], position[3])
    local sqrDis = distance * distance
    if sqrDis >= _SqrDistance(user:GetPosition(), tempPos) then
      return user, true
    end
  else
    return user, false
  end
end

function NSceneUserProxy:ClearGroupEff()
  for k, v in pairs(self.userMap) do
    v:RemoveGroupEffect()
  end
  Game.Myself:RemoveGroupEffect()
end

local uData = {}
local _GetUserData = function(userdata)
  TableUtility.ArrayClear(uData)
  uData[#uData + 1] = userdata:Get(UDEnum.HEAD) or 0
  uData[#uData + 1] = userdata:Get(UDEnum.MOUNT) or 0
  return uData
end
local Limited_GroupCount = 2

function NSceneUserProxy:CheckGroupUser(group, path)
  local list = {}
  local myself = Game.Myself
  local myguid = myself.data.id
  local allEquip = {}
  local groupMap = {}
  for i = 1, #group do
    groupMap[group[i]] = 1
  end
  local allEquipCount = 0
  for guid, user in pairs(self.userMap) do
    if nil == list[guid] then
      list[guid] = {}
    end
    local userdata = _GetUserData(user.data.userdata)
    for i = 1, #userdata do
      local equip = userdata[i]
      if nil ~= groupMap[equip] then
        if list[guid][equip] == nil then
          list[guid][equip] = 1
        end
        if allEquip[equip] == nil then
          allEquip[equip] = 1
          allEquipCount = allEquipCount + 1
        end
      end
    end
  end
  if nil == list[myguid] then
    list[myguid] = {}
  end
  local myUserdata = _GetUserData(myself.data.userdata)
  for i = 1, #myUserdata do
    local equip = myUserdata[i]
    if nil ~= groupMap[equip] then
      if list[myguid][equip] == nil then
        list[myguid][equip] = 1
      end
      if allEquip[equip] == nil then
        allEquip[equip] = 1
        allEquipCount = allEquipCount + 1
      end
    end
  end
  self.groupEffectUser = self.groupEffectUser or {}
  if allEquipCount >= Limited_GroupCount then
    for roleID, _ in pairs(list) do
      self:Find(roleID):PlayGropEquipEffect(path)
      self.groupEffectUser[roleID] = 1
    end
  end
end

function NSceneUserProxy:Clear()
  local clears = NSceneUserProxy.super.Clear(self)
  if clears and 0 < #clears then
    GameFacade.Instance:sendNotification(SceneUserEvent.SceneRemoveRoles, clears)
    EventManager.Me():PassEvent(SceneUserEvent.SceneRemoveRoles, clears)
  end
end

function NSceneUserProxy:AddScenicBuff(guid, buffId)
  local buffData = Table_Buffer[buffId]
  if buffData and buffData.BuffEffect.type == "Scenery" then
    local data = FunctionScenicSpot.Me():AddCreatureScenicSpot(guid, buffData.BuffEffect.scenic)
    if data then
      GameFacade.Instance:sendNotification(MiniMapEvent.CreatureScenicAdd, {data})
    end
  end
end

function NSceneUserProxy:UpdateTwelveCamp(my_camp)
  if not Game.MapManager:IsPvPMode_TeamTwelve() then
    return
  end
  for k, v in pairs(self.userMap) do
    v.data:Camp_SetIsInPVP(true)
    v.data:Camp_SetIsInMyTeam(v.data:GetTwelvePVPCamp() == my_camp)
  end
end

local tempArray = {}

function NSceneUserProxy:HandleAddScenicBuffs(serverData)
  TableUtility.ArrayClear(tempArray)
  local buffDatas = serverData.buffs
  if buffDatas and 0 < #buffDatas then
    for i = 1, #buffDatas do
      local scenic = self:AddScenicBuff(serverData.guid, buffDatas[i].id)
      if scenic then
        tempArray[#tempArray + 1] = scenic
      end
    end
  end
end

function NSceneUserProxy:RemoveScenicBuff(guid, buffId)
  local ssId
  if buffId then
    local buffData = Table_Buffer[buffId]
    if buffData and buffData.BuffEffect.type == "Scenery" then
      ssId = buffData.BuffEffect.scenic
      FunctionScenicSpot.Me():RemoveCreatureScenicSpot(guid, ssId)
    end
  end
end

function NSceneUserProxy:UpdatePlayerFashion()
  local _Conf_EquipHideMapRaid = GameConfig.Setting.EquipExteriorMapRaid
  if not _Conf_EquipHideMapRaid or not Game.MapManager:IsMapRaidTypeForbid(_Conf_EquipHideMapRaid) then
    return
  end
  for _, v in pairs(self.userMap) do
    v:ReDress()
  end
end

function NSceneUserProxy:HandleRemoveScenicBuffs(guids)
  for i = 1, #guids do
    FunctionScenicSpot.Me():RemoveCreatureScenicSpot(guids[i])
  end
end

function NSceneUserProxy:AddLoopSfxUser(guid)
  if not self.userMap_loopSfx then
    self.userMap_loopSfx = {}
  end
  if guid then
    self.userMap_loopSfx[guid] = 1
  end
end

function NSceneUserProxy:UpdateLoopSfxVolume(volume)
  if not self.userMap_loopSfx then
    return
  end
  local myGuid = Game.Myself.data.id
  local myself = Game.Myself
  local FindCreature = SceneCreatureProxy.FindCreature
  for guid, value in pairs(self.userMap_loopSfx) do
    if guid == myGuid then
      myself:UpdateVolume(volume)
    else
      local role = FindCreature(guid)
      if role then
        role:UpdateVolume(volume)
      end
    end
  end
end

function NSceneUserProxy:RemoveLoopSfxUser(guid)
  if not self.userMap_loopSfx then
    return
  end
  if guid then
    self.userMap_loopSfx[guid] = nil
  end
end
