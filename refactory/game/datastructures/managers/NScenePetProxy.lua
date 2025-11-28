NScenePetProxy = class("NScenePetProxy", NSceneNpcProxy)
NScenePetProxy.Instance = nil
NScenePetProxy.NAME = "NScenePetProxy"
local _SqrDistance = LuaVector3.Distance_Square

function NScenePetProxy:ctor(proxyName, data)
  self.clientUserMap = {}
  self.npcGroupMap = {}
  self.npcMap = {}
  self.pippiMap = {}
  self:Reset()
  self:CountClear()
  self.proxyName = proxyName or NScenePetProxy.NAME
  NScenePetProxy.Instance = self
  if data ~= nil then
    self:setData(data)
  end
  if Game and Game.LogicManager_Creature then
    Game.LogicManager_Creature:SetScenePetProxy(self)
  end
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddRoles, self.SceneAddCreaturesHandler, self)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddNpcs, self.SceneAddCreaturesHandler, self)
end

function NScenePetProxy:SceneAddCreaturesHandler(creaturesID)
  for i = 1, #creaturesID do
    self:PetTryFindOwner(creaturesID[i])
  end
end

function NScenePetProxy:Reset()
  if self.userMap == nil then
    self.userMap = {}
  else
    TableUtility.TableClear(self.userMap)
  end
  if self.waitForOwner == nil then
    self.waitForOwner = {}
  else
    TableUtility.TableClear(self.waitForOwner)
  end
  if self.pippiMap == nil then
    self.pippiMap = {}
  else
    TableUtility.TableClear(self.pippiMap)
  end
end

function NScenePetProxy:Add(data, classRef)
  local pet = NScenePetProxy.super.Add(self, data, NPet)
  local master = NSceneUserProxy.Instance:Find(data.owner)
  if pet:IsPippi() and data.owner then
    self.pippiMap[data.owner] = pet.data.id
  end
  if master then
    self:SetPetOwner(pet, master)
  else
    master = NSceneNpcProxy.Instance:Find(data.owner)
    if master then
      self:SetPetOwner(pet, master)
    else
      self:WaitForOwner(pet)
    end
  end
  self:AddPetIntoMap(pet)
  return pet
end

function NScenePetProxy:AddPetIntoMap(pet)
  self.userMap[pet.data.id] = pet
end

function NScenePetProxy:SetOwnerDressEnable(owner, v)
  if owner.data and owner.data.petIDs then
    local petIDs = owner.data.petIDs
    for i = 1, #petIDs do
      local pet = self:Find(petIDs[i])
      if pet then
        pet:SetDressEnable(v)
      end
    end
  end
end

function NScenePetProxy:SetPetOwner(pet, owner)
  local petData = pet.data
  if owner == nil or petData.ownerID ~= owner.data.id or not pet.foundOwner then
    local ownerData = owner.data
    if petData.ownerID then
      local oldOwner = SceneCreatureProxy.FindCreature(petData.ownerID)
      if oldOwner then
        owner.data:RemovePetID(petData.id)
      end
    end
    if owner then
      owner.data:AddPetID(petData.id)
      pet:SetOwner(owner)
    else
      pet:SetOwner(nil)
    end
  end
end

function NScenePetProxy:WaitForOwner(pet)
  self.waitForOwner[pet.data.ownerID] = pet.data.id
end

function NScenePetProxy:PetTryFindOwner(ownerID)
  local petID = self.waitForOwner[ownerID]
  if petID then
    local pet = self:Find(petID)
    if pet then
      local owner = SceneCreatureProxy.FindCreature(ownerID)
      if owner then
        self:SetPetOwner(pet, owner)
        self:RemoveWaitForOwner(owner.id)
      end
    end
  end
end

function NScenePetProxy:RemoveWaitForOwner(ownerID)
  self.waitForOwner[ownerID] = nil
end

function NScenePetProxy:Remove(guid, delay, fadeout)
  local pet = self:Find(guid)
  if pet then
    local ownerID = pet.data.ownerID
    local owner = SceneCreatureProxy.FindCreature(ownerID)
    if owner then
      owner.data:RemovePetID(guid)
    end
    if pet:IsPippi() and ownerID then
      self.pippiMap[ownerID] = nil
    end
    if self.my_Pippi == pet.data.id then
      self.my_Pippi = nil
    end
    self:RemoveWaitForOwner(ownerID)
    if delay ~= nil and 0 < delay or fadeout ~= nil and 0 < fadeout then
      self:DelayRemove(pet, delay, fadeout)
    else
      self:RealRemove(guid)
    end
    return true
  end
  return false
end

function NScenePetProxy:DelayRemove(pet, delay, duration)
  if pet then
    delay = delay or 0
    pet:SetDelayRemove(delay / 1000, duration and duration / 1000)
  end
end

function NScenePetProxy:RealRemove(guid, fade)
  return SceneCreatureProxy.Remove(self, guid)
end

local allServant = GameConfig.Servant.dialogID_Icon
local tmpPets = {}

function NScenePetProxy:PureAddSome(datas)
  local data
  for i = 1, #datas do
    data = datas[i]
    if data ~= nil then
      tmpPets[#tmpPets + 1] = self:Add(data)
    end
  end
  if tmpPets and 0 < #tmpPets then
    BokiProxy.Instance:AddBoki(tmpPets)
    GameFacade.Instance:sendNotification(SceneUserEvent.SceneAddPets, tmpPets)
    EventManager.Me():PassEvent(SceneUserEvent.SceneAddPets, tmpPets)
    for i = 1, #tmpPets do
      if tmpPets[i].data.ownerID == Game.Myself.data.id and nil ~= allServant[tmpPets[i].data.staticData.id] then
        self.myservant = tmpPets[i]
        break
      elseif tmpPets[i].data.ownerID == Game.Myself.data.id and tmpPets[i].data.staticData.id == 580400 then
        self.my_Pippi = tmpPets[i].data.id
        GameFacade.Instance:sendNotification(MyselfEvent.MyPippiChange)
      end
    end
    TableUtility.ArrayClear(tmpPets)
  end
end

function NScenePetProxy:RemoveSome(guids, delay, fadeout)
  BokiProxy.Instance:RemoveBoki(guids)
  local pets = SceneObjectProxy.RemoveSome(self, guids, delay, fadeout)
  if pets and 0 < #pets then
    GameFacade.Instance:sendNotification(SceneUserEvent.SceneRemovePets, pets)
    EventManager.Me():PassEvent(SceneUserEvent.SceneRemovePets, pets)
    self:ResetSome(pets)
  end
end

function NScenePetProxy:Clear()
  local pets = SceneCreatureProxy.Clear(self)
  if pets and 0 < #pets then
    GameFacade.Instance:sendNotification(SceneUserEvent.SceneRemovePets, pets)
    EventManager.Me():PassEvent(SceneUserEvent.SceneRemovePets, pets)
    self.myservant = nil
  end
  self:Reset()
  BokiProxy.Instance:ClearMyBoki()
end

function NScenePetProxy:ResetSome(guids)
  if not self.myservant then
    return
  end
  for i = 1, #guids do
    if nil == self.myservant.data or guids[i] == self.myservant.data.id then
      self.myservant = nil
      break
    end
  end
end

local tempPos = LuaVector3.Zero()

function NScenePetProxy:FindNearestPet(position, distance, filter)
  if Game.LogicManager_MapCell:IsCreatureUpdateWorking() then
    return Game.LogicManager_MapCell:FindNearestCreatureAround(position, filter, distance, Creature_Type.Pet)
  end
  LuaVector3.Better_Set(tempPos, position[1], position[2], position[3])
  local nearestPet
  local minDistSq = distance * distance
  for k, pet in pairs(self.userMap) do
    local dist = _SqrDistance(pet:GetPosition(), tempPos)
    if minDistSq >= dist and (nil == filter or filter(pet)) then
      minDistSq = dist
      nearestPet = pet
    end
  end
  return nearestPet
end

local nearPetList = {}

function NScenePetProxy:FindNearPets(position, distance, filter)
  if Game.LogicManager_MapCell:IsCreatureUpdateWorking() then
    return Game.LogicManager_MapCell:GetCreaturesAround(position, filter, distance, Creature_Type.Pet)
  end
  LuaVector3.Better_Set(tempPos, position[1], position[2], position[3])
  TableUtility.TableClear(nearPetList)
  local sqrDis = distance * distance
  for k, pet in pairs(self.userMap) do
    if sqrDis >= _SqrDistance(pet:GetPosition(), tempPos) and (nil == filter or filter(pet)) then
      table.insert(nearPetList, pet)
    end
  end
  return nearPetList
end

function NScenePetProxy:TraversingCreatureAround(position, distance, action)
  if Game.LogicManager_MapCell:IsCreatureUpdateWorking() then
    Game.LogicManager_MapCell:TraversingCreatureAround(position, action, distance, Creature_Type.Pet)
    return
  end
  if not action then
    return
  end
  LuaVector3.Better_Set(tempPos, position[1], position[2], position[3])
  local sqrDis = distance * distance
  for k, v in pairs(self.npcMap) do
    for i = 1, #v do
      if sqrDis >= _SqrDistance(v[i]:GetPosition(), tempPos) then
        action(v[i])
      end
    end
  end
end

function NScenePetProxy:RefreshAllPetCamp()
  for _, pet in pairs(self.userMap) do
    pet:HandleCampChange()
  end
end

function NScenePetProxy:GetMyPipipi()
  return self.my_Pippi
end

local nearPippiList = {}

function NScenePetProxy:FindNearPippi(position, distance, filter)
  LuaVector3.Better_Set(tempPos, position[1], position[2], position[3])
  TableUtility.TableClear(nearPippiList)
  local sqrDis = distance * distance
  local userMap = self.userMap
  local pet
  for _, petguid in pairs(self.pippiMap) do
    pet = userMap[petguid]
    if pet and sqrDis >= _SqrDistance(pet:GetPosition(), tempPos) and (nil == filter or filter(pet)) then
      table.insert(nearPippiList, pet)
    end
  end
  return nearPippiList
end

function NScenePetProxy:GetMyPipipiCreature()
  if self.my_Pippi and self.userMap then
    return self.userMap[self.my_Pippi]
  end
end
