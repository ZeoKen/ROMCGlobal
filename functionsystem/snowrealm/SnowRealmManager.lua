autoImport("EventDispatcher")
autoImport("BuildingGrid")
autoImport("NFurniture")
autoImport("HomeFurniturOutLine")
autoImport("HomeCmd_pb")
autoImport("HomePhonographManager")
autoImport("HomeMagicBookManager")
SnowRealmManager = class("SnowRealmManager", EventDispatcher)
local HouseCount = 6
local MessageBoardEffectHideDistance = 25
SnowRealmManager.AccessType = {
  Direct = 1,
  NearBy = 2,
  LookAtSelect = 3,
  NearBySelect = 4,
  IsNPC = 10
}
SnowRealmManager.DirectionRotationMap = {
  [BuildingGrid.EBuildingDirection.EForward] = {
    [180] = 1,
    [270] = 3,
    [0] = 2,
    [90] = 4
  },
  [BuildingGrid.EBuildingDirection.EBack] = {
    [180] = 2,
    [270] = 4,
    [0] = 1,
    [90] = 3
  },
  [BuildingGrid.EBuildingDirection.ELeft] = {
    [180] = 3,
    [270] = 2,
    [0] = 4,
    [90] = 1
  },
  [BuildingGrid.EBuildingDirection.ERight] = {
    [180] = 4,
    [270] = 1,
    [0] = 3,
    [90] = 2
  }
}
local m_baseHeight = 0.001
local m_vecUp = LuaVector3.Up()
local tmpVector3 = LuaVector3(0, 0, 0)
local GetTempVector3 = function(x, y, z, tarVector)
  tarVector = tarVector or tmpVector3
  LuaVector3.Better_Set(tarVector, x, y, z)
  return tarVector
end

function SnowRealmManager.Me()
  if nil == SnowRealmManager.me then
    SnowRealmManager.me = SnowRealmManager.new()
  end
  return SnowRealmManager.me
end

function SnowRealmManager:ctor()
  self:Init()
end

function SnowRealmManager:Init()
  self.roomTriggers = {}
  self.areaTriggerId = nil
  self.objPos = {
    Front = {
      text = ZhString.HomeBuilding_Front,
      index = 1
    },
    Back = {
      text = ZhString.HomeBuilding_Back,
      index = 2
    },
    Left = {
      text = ZhString.HomeBuilding_Left,
      index = 3
    },
    Right = {
      text = ZhString.HomeBuilding_Right,
      index = 4
    }
  }
  self.wallVisibleDefaultConfig = {StartAngle = -90, EndAngle = 90}
  self.nHomeMap = {}
  for i = 1, HouseCount do
    self.nHomeMap[i] = {
      ID = i,
      nFurnitureMap = {},
      nFurnitureClientMap = {},
      tabWalls = {},
      tabLogicWalls = {},
      groundHeightCache = {},
      tabRenovationMap = {},
      tmpDataList = {}
    }
  end
  self.relativeCreatureMap = {}
  self.destroyList = {}
  self.tmpDataList = {}
  self.curHomeIdx = nil
  self.hasEditedFurnitureInThisEditSession = false
  self.phonographManager = HomePhonographManager.new()
  self.magicBookManager = HomeMagicBookManager.new()
  self.furnitureLayerMap = {}
end

local ForEachFurniture = function(self, func, homeIdxOverride)
  local homeIdx = homeIdxOverride
  if not homeIdx or homeIdx <= 0 then
    homeIdx = self.curHomeIdx or 0
  end
  if homeIdx <= 0 then
    return
  end
  local homeData = self.nHomeMap and self.nHomeMap[homeIdx]
  if not homeData then
    return
  end
  if homeData.nFurnitureMap then
    for _, nfur in pairs(homeData.nFurnitureMap) do
      if nfur then
        func(nfur)
      end
    end
  end
  if homeData.nFurnitureClientMap then
    for _, nfur in pairs(homeData.nFurnitureClientMap) do
      if nfur then
        func(nfur)
      end
    end
  end
end

local function ForEachGameObjectInHierarchy(tsf, callback)
  if not tsf or Game.GameObjectUtil:ObjectIsNULL(tsf.gameObject) then
    return
  end
  local go = tsf.gameObject
  callback(go)
  for i = 0, tsf.childCount - 1 do
    ForEachGameObjectInHierarchy(tsf:GetChild(i), callback)
  end
end

function SnowRealmManager:SaveFurnitureLayers(homeIdxOverride)
  if not self.furnitureLayerMap then
    self.furnitureLayerMap = {}
  end
  TableUtility.TableClear(self.furnitureLayerMap)
  ForEachFurniture(self, function(nfur)
    local go = nfur.assetFurniture and nfur.assetFurniture.gameObject
    if go and not Game.GameObjectUtil:ObjectIsNULL(go) then
      ForEachGameObjectInHierarchy(go.transform, function(childGo)
        self.furnitureLayerMap[childGo] = childGo.layer
      end)
    end
  end, homeIdxOverride)
end

function SnowRealmManager:SetAllFurnituresLayer(layerId, homeIdxOverride)
  local idx = homeIdxOverride
  if not idx or idx <= 0 then
    idx = self.curHomeIdx
  end
  if not idx or idx <= 0 then
    idx = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  self:SaveFurnitureLayers(idx)
  ForEachFurniture(self, function(nfur)
    local go = nfur.assetFurniture and nfur.assetFurniture.gameObject
    if go then
      Game.GameObjectUtil:ChangeLayersRecursively(go, layerId)
    end
  end, idx)
end

function SnowRealmManager:ResetFurnitureLayers()
  if not self.furnitureLayerMap then
    return
  end
  for go, layerId in pairs(self.furnitureLayerMap) do
    if go and not Game.GameObjectUtil:ObjectIsNULL(go) then
      go.layer = layerId
    end
  end
  TableUtility.TableClear(self.furnitureLayerMap)
end

function SnowRealmManager:Launch()
  self:Shutdown()
  local homeMapConfig = GameConfig.SnowRealm and GameConfig.SnowRealm.MapDatas
  local curMapID = Game.MapManager:GetMapID()
  self.curHouseConfig = homeMapConfig and homeMapConfig[curMapID]
  if self.curHouseConfig then
    self.curMapSData = Table_Map[curMapID]
    self.curAtHome = true
    self.curHomeIdx = 0
    self:InitHomeScene(self.curMapSData.NameEn)
    GameFacade.Instance:sendNotification(HomeEvent.EnterHome)
    EventManager.Me():DispatchEvent(HomeEvent.EnterHome)
    GameFacade.Instance:sendNotification(MainViewEvent.AddDungeonInfoBord, "MainViewSkadaInfoPage")
    self:CreateRoomTriggers()
    EventManager.Me():AddEventListener(TriggerEvent.EnterSnowRealmRoom, self.HandleEnterSnowRealmRoom, self)
    EventManager.Me():AddEventListener(TriggerEvent.LeaveSnowRealmRoom, self.HandleLeaveSnowRealmRoom, self)
    EventManager.Me():AddEventListener(TriggerEvent.RemoveSnowRealmRoom, self.HandleRemoveSnowRealmRoom, self)
    EventManager.Me():AddEventListener(ServiceEvent.HomeCmdQuerySnowHouseDataHomeCmd, self.HandleQuerySnowHouseDataHomeCmd, self)
    self:CreateSceneEffect()
  elseif curMapID == 155 then
    self:CreateAreaTrigger()
    EventManager.Me():AddEventListener(TriggerEvent.EnterSnowRealmArea, self.HandleEnterSnowRealmArea, self)
    EventManager.Me():AddEventListener(TriggerEvent.LeaveSnowRealmArea, self.HandleLeaveSnowRealmArea, self)
    EventManager.Me():AddEventListener(TriggerEvent.RemoveSnowRealmArea, self.HandleRemoveSnowRealmArea, self)
    self:CreateSceneEffect()
  end
end

function SnowRealmManager:Shutdown()
  if self:IsInEditMode() then
    ServiceHomeCmdProxy.Instance:CallHouseActionHomeCmd(HomeCmd_pb.EHOUSEACTION_FREE_MODE)
    GameFacade.Instance:sendNotification(HomeEvent.EditOver)
    EventManager.Me():DispatchEvent(HomeEvent.EditOver)
  end
  if self.curAtHome then
    self:_ExitHome()
    self.curAtHome = false
  end
  self.isInEditMode = false
  self.clientPrepareBuild = false
  self.curMapSData = nil
  self.curHouseConfig = nil
  self.curHomeIdx = nil
  if nil ~= self.areaTriggerId then
    SceneTriggerProxy.Instance:Remove(self.areaTriggerId)
    self.areaTriggerId = nil
    EventManager.Me():RemoveEventListener(TriggerEvent.EnterSnowRealmArea, self.HandleEnterSnowRealmArea, self)
    EventManager.Me():RemoveEventListener(TriggerEvent.LeaveSnowRealmArea, self.HandleLeaveSnowRealmArea, self)
    EventManager.Me():RemoveEventListener(TriggerEvent.RemoveSnowRealmArea, self.HandleRemoveSnowRealmArea, self)
  end
  if #self.roomTriggers > 0 then
    TableUtility.ArrayClearByDeleter(self.roomTriggers, function(id)
      SceneTriggerProxy.Instance:Remove(id)
    end)
    EventManager.Me():RemoveEventListener(TriggerEvent.EnterSnowRealmRoom, self.HandleEnterSnowRealmRoom, self)
    EventManager.Me():RemoveEventListener(TriggerEvent.LeaveSnowRealmRoom, self.HandleLeaveSnowRealmRoom, self)
    EventManager.Me():RemoveEventListener(TriggerEvent.RemoveSnowRealmRoom, self.HandleRemoveSnowRealmRoom, self)
    EventManager.Me():RemoveEventListener(ServiceEvent.HomeCmdQuerySnowHouseDataHomeCmd, self.HandleQuerySnowHouseDataHomeCmd, self)
  end
  self:DestroySceneEffect()
  self:DestroyMessageBoardEffect()
  self.phonographManager:Shutdown()
end

function SnowRealmManager:_ExitHome()
  self:ClearFurnitureFuncList()
  for i = 1, HouseCount do
    self:ClearFurnituresByHouseIndex(true, i)
    self:ClearRenovationMap(i)
    self:ClearWallMaps(i)
    TableUtility.TableClear(self.nHomeMap[i].groundHeightCache)
    TableUtility.TableClear(self.nHomeMap[i].tabRenovationMap)
    TableUtility.TableClear(self.nHomeMap[i].tabWalls)
    TableUtility.TableClear(self.nHomeMap[i].tabLogicWalls)
    TableUtility.TableClear(self.nHomeMap[i].nFurnitureMap)
    TableUtility.TableClear(self.nHomeMap[i].nFurnitureClientMap)
    self.nHomeMap[i].mapInfo = nil
    self.nHomeMap[i].buildingGrid = nil
    self.nHomeMap[i].objRoof = nil
    self.nHomeMap[i].objBuildRoot = nil
    self.nHomeMap[i].tsfFurnituresRoot = nil
    self.nHomeMap[i].tsfGroundColliderRoot = nil
  end
  TableUtility.TableClear(self.tmpDataList)
  TableUtility.TableClear(self.destroyList)
  self.objBuildRoot = nil
  SnowRealmProxy.Instance:ClearDatas()
  Game.AssetManager_Furniture:ClearCache()
  Game.GCSystemManager:Collect()
  GameFacade.Instance:sendNotification(HomeEvent.ExitHome)
  EventManager.Me():DispatchEvent(HomeEvent.ExitHome)
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
  GameFacade.Instance:sendNotification(MainViewEvent.RemoveDungeonInfoBord, "MainViewSkadaInfoPage")
end

function SnowRealmManager:InitHomeScene(sceneName)
  for i = 1, HouseCount do
    self:ClearFurnituresByHouseIndex(true, i)
    TableUtility.TableClear(self.nHomeMap[i].groundHeightCache)
    local fName = sceneName .. "_home_" .. i
    pcall(function()
      autoImport(fName)
    end)
    local mapInfo = _G[fName]
    if not mapInfo then
      LogUtility.Error(string.format("没有找到场景%s的建造区域数据，无法创建家具或进入建造模式。", tostring(sceneName)))
    else
      do
        local buildingGrid = BuildingGrid.new(mapInfo)
        buildingGrid:SetDirectionRotationMap(SnowRealmManager.DirectionRotationMap)
        for id, data in pairs(Table_HomeFurniture) do
          buildingGrid:RegisterFurnitureData(data.id, data.Row, data.Col, data.BeginHeight, data.EndHeight, data.FixedPlanes, data.AlternativePlanes, data.NormalType)
        end
        self.nHomeMap[i].mapInfo = mapInfo
        self.nHomeMap[i].buildingGrid = buildingGrid
        self:FindAndCreateSceneObjs(i)
        self:GenerateRenovationMap(i)
        self:CreateGroundColliders(i)
        self:ResetRenovations(i)
        self:CreateCurrentFurnitures(i)
      end
    end
  end
  self.objBuildRoot = GameObject.Find("Furniture")
  self.tsfDestroyFurnitureRoot = self:FindOrCreateTransform("DestroyFurnitureRoot", self.objBuildRoot)
  self.tsfDestroyFurnitureRoot.gameObject:SetActive(false)
end

function SnowRealmManager:LateUpdate(time, deltaTime)
  if self:IsInEditMode() then
    return
  end
  for houseIndex = 1, HouseCount do
    for id, nFurniture in pairs(self.nHomeMap[houseIndex].nFurnitureMap) do
      nFurniture:LateUpdate(time, deltaTime)
    end
  end
end

function SnowRealmManager:Update(time, deltaTime)
  if SceneProxy.Instance:IsLoading() then
    return
  end
  if self.messageBoardEffect and Game.Myself then
    local playerPos = Game.Myself:GetPosition()
    local effectPos = self.messageBoardEffect:GetPosition()
    effectPos = effectPos or self.messageBoardEffect:GetLocalPosition()
    if playerPos and effectPos then
      local dist = LuaVector3.Distance_Square(playerPos, effectPos)
      self.messageBoardEffect:SetActive(dist >= MessageBoardEffectHideDistance * MessageBoardEffectHideDistance)
    end
  end
  for i = 1, HouseCount do
    local allPets = SnowRealmProxy.Instance:GetCurFeedingPet(i)
    if allPets ~= nil then
      for _, pet in ipairs(allPets) do
        pet:Update(time, deltaTime)
      end
    end
  end
  local destroyListNum = #self.destroyList
  if 0 < destroyListNum then
    Game.AssetManager_Furniture:DestroyFurniture(self.destroyList[destroyListNum])
    self.destroyList[destroyListNum] = nil
  end
  self.phonographManager:Update(deltaTime)
end

function SnowRealmManager:EnterEditMode()
  if not self:IsAtMyselfHome() and not self.currentUseNpcFunction then
    MsgManager.ShowMsgByID(38010)
    return
  end
  self.clientPrepareBuild = true
  ServiceHomeCmdProxy.Instance:CallHouseActionHomeCmd(HomeCmd_pb.EHOUSEACTION_EDIT_MODE)
end

function SnowRealmManager:EnterEditMode_Server()
  if not (self.clientPrepareBuild and self:IsAtMyselfHome()) or self:IsInEditMode() then
    return
  end
  if not SnowRealmProxy.Instance:IsServerInEditMode() then
    return
  end
  FunctionSystem.InterruptMyself()
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.HomeBuildingView
  })
  self.isInEditMode = true
  self.hasEditedFurnitureInThisEditSession = false
  self.clientPrepareBuild = false
  local houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  if nil == houseIndex or houseIndex == 0 then
    return
  end
  self:ResetGroundHeight(0, houseIndex)
  local furnitures = self:GetFurnituresMap(houseIndex)
  for id, nFurniture in pairs(furnitures) do
    nFurniture:SetColliderLayer(Game.ELayer.HomeFurniture)
    nFurniture:OnEnterEditMode()
  end
  GameFacade.Instance:sendNotification(HomeEvent.EditStart)
  EventManager.Me():DispatchEvent(HomeEvent.EditStart)
  local stopPatrol = function(creature)
    local patrolAI = creature.ai.idleAI_Patrol
    if patrolAI ~= nil then
      patrolAI:StopPatrol(creature)
      creature.logicTransform:PlaceTo(LuaVector3(-100000, -100000, -100000))
    end
  end
  local npcs = NSceneNpcProxy.Instance:GetAll()
  for _, npc in pairs(npcs) do
    stopPatrol(npc)
  end
  local feedingPets = SnowRealmProxy.Instance:GetCurFeedingPet(houseIndex)
  if nil ~= feedingPets then
    for _, pet in ipairs(feedingPets) do
      stopPatrol(pet)
    end
  end
end

function SnowRealmManager:ExitEditMode(skipFurnitureLayerChange)
  self.isInEditMode = false
  self.hasEditedFurnitureInThisEditSession = false
  if self.currentUseNpcFunction then
    self:HandleLeaveSnowRealmRoom(self.curHomeIdx)
    self.currentUseNpcFunction = nil
  end
  local houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  if nil == houseIndex or houseIndex == 0 then
    return
  end
  if not LuaGameObject.ObjectIsNull(self.nHomeMap[houseIndex].objBuildRoot) then
    self:ResetWallsAndPillarsStatus(houseIndex)
    self:ResetGroundHeight(0, houseIndex)
    self:ResetClientFurnitures(true, houseIndex)
    self:ResetRenovations(houseIndex)
    local furnitures = self:GetFurnituresMap(houseIndex)
    for id, nFurniture in pairs(furnitures) do
      if not skipFurnitureLayerChange then
        nFurniture:SetColliderLayer(nFurniture:HaveFunction() and Game.ELayer.Accessable or Game.ELayer.Default)
      end
      nFurniture:OnExitEditMode()
    end
  end
  ServiceHomeCmdProxy.Instance:CallHouseActionHomeCmd(HomeCmd_pb.EHOUSEACTION_FREE_MODE)
  GameFacade.Instance:sendNotification(HomeEvent.EditOver)
  EventManager.Me():DispatchEvent(HomeEvent.EditOver)
  local resumePatrol = function(creature)
    local patrolAI = creature.ai.idleAI_Patrol
    if patrolAI ~= nil then
      patrolAI:ResumePatrol(creature)
      local pos = self:GetHomeSafePoint(creature)
      creature.logicTransform:PlaceTo(LuaVector3(pos[1], pos[2], pos[3]))
    end
  end
  local npcs = NSceneNpcProxy.Instance:GetAll()
  for _, npc in pairs(npcs) do
    resumePatrol(npc)
  end
  local feedingPets = SnowRealmProxy.Instance:GetCurFeedingPet(houseIndex)
  if nil ~= feedingPets then
    for _, pet in ipairs(feedingPets) do
      resumePatrol(pet)
    end
  end
  self.phonographManager:ExitEditMode()
  self.magicBookManager:ExitEditMode()
end

function SnowRealmManager:AddFurnitureItem(nFurniture, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  self.nHomeMap[houseIndex].nFurnitureMap[nFurniture.data.id] = nil
  self.nHomeMap[houseIndex].nFurnitureClientMap[nFurniture.data.id] = nFurniture
end

function SnowRealmManager:ConfirmPlaceFurniture(nFurniture, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  if nFurniture:IsMoved() or not nFurniture.data:IsServerInited() then
    self.hasEditedFurnitureInThisEditSession = true
    self:AddFurnitureItem(nFurniture, houseIndex)
    nFurniture:PlaceOnCurCell()
    nFurniture.assetFurniture:SetAlpha(0.5)
    nFurniture.assetFurniture:SetColliderEnable(false)
    local tmpArray = ReusableTable.CreateArray()
    tmpArray[#tmpArray + 1] = self:ParseFurnitureToPbMsg(nFurniture)
    local action = nFurniture.data:IsServerInited() and HomeCmd_pb.EFURNITUREACTION_EDIT or HomeCmd_pb.EFURNITUREACTION_PUTON
    ServiceHomeCmdProxy.Instance:CallFurnitureActionHomeCmd(action, tmpArray)
    ReusableTable.DestroyAndClearArray(tmpArray)
  else
    self.nHomeMap[houseIndex].nFurnitureMap[nFurniture.data.id] = nFurniture
    self.nHomeMap[houseIndex].nFurnitureClientMap[nFurniture.data.id] = nil
  end
end

function SnowRealmManager:HasEditedFurnitureInThisEditSession()
  return self.hasEditedFurnitureInThisEditSession == true
end

function SnowRealmManager:HasAnyFurnitureInPlacementMaps(snowHouseIdx)
  local houseIndex = snowHouseIdx
  if nil == houseIndex or houseIndex <= 0 then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  if nil == houseIndex or houseIndex <= 0 then
    return false
  end
  local home = self.nHomeMap[houseIndex]
  if not home then
    return false
  end
  for _, nFurniture in pairs(home.nFurnitureMap) do
    if nFurniture then
      return true
    end
  end
  for _, nFurniture in pairs(home.nFurnitureClientMap) do
    if nFurniture then
      return true
    end
  end
  return false
end

function SnowRealmManager:_AddObjToDestroyList(obj)
  if LuaGameObject.ObjectIsNull(obj) then
    return
  end
  self.destroyList[#self.destroyList + 1] = obj
  obj.transform.parent = self.tsfDestroyFurnitureRoot
end

function SnowRealmManager:FindAndCreateSceneObjs(houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  local objBuildRoot = GameObject.Find("Home_" .. houseIndex)
  if not objBuildRoot then
    LogUtility.Error(string.format("没有找到家园场景的根节点\"%s\"，无法创建家具或进入建造模式。", "Home_" .. houseIndex))
    return
  end
  local tsfFurnituresRoot = self:FindOrCreateTransform("NFurnituresRoot", objBuildRoot)
  tsfFurnituresRoot.parent = objBuildRoot.transform
  tsfFurnituresRoot.position = LuaGeometry.GetTempVector3(0, 0, 0)
  local tsfGroundColliderRoot = self:FindOrCreateTransform("GroundColliderParent", objBuildRoot)
  tsfGroundColliderRoot.parent = objBuildRoot.transform
  tsfGroundColliderRoot.position = LuaGeometry.GetTempVector3(0, 0, 0)
  local objRoof = Game.GameObjectUtil:DeepFind(objBuildRoot, "Roof")
  self.nHomeMap[houseIndex].objRoof = objRoof
  self.nHomeMap[houseIndex].objBuildRoot = objBuildRoot
  self.nHomeMap[houseIndex].tsfFurnituresRoot = tsfFurnituresRoot
  self.nHomeMap[houseIndex].tsfGroundColliderRoot = tsfGroundColliderRoot
  self:InitWalls(houseIndex)
end

function SnowRealmManager:GenerateRenovationMap(houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  self:ClearRenovationMap(houseIndex)
  self.nHomeMap[houseIndex].maxFloorIndex = 0
  local renovationTypes = ReusableTable.CreateTable()
  local renovationDatas = SnowRealmProxy.Instance:GetBuidingDatas(SnowRealmProxy.BuildType.Renovation)
  for typeID, datas in pairs(renovationDatas) do
    renovationTypes[typeID] = Table_FurnitureType[typeID].Type
  end
  local meshRenderers = Game.GameObjectUtil:DeepFind(self.nHomeMap[houseIndex].objBuildRoot, "RenovationRoot"):GetComponentsInChildren(MeshRenderer, true)
  local mr, tsfParent, objName, startPos, name, tabMat, matFolderName, tabFloorDatas, tabMatTypeMap, floorIndex, wallFound
  for i = 1, #meshRenderers do
    mr = meshRenderers[i]
    name = mr.name
    for typeID, typeName in pairs(renovationTypes) do
      if string.find(name, typeName) then
        startPos = string.find(string.reverse(name), "_")
        matFolderName = startPos and string.sub(name, string.len(name) - startPos + 2, string.len(name))
        tsfParent = mr.transform.parent
        if typeName == "Wall" or typeName == "Pillar" or typeName == "Door" then
          objName = tsfParent.parent.name
        else
          objName = tsfParent.name
        end
        startPos = string.find(string.reverse(objName), "_")
        floorIndex = startPos and tonumber(string.sub(objName, string.len(objName) - startPos + 2, string.len(objName)))
        if not floorIndex then
          LogUtility.Error(string.format("无法确定物体%s的所在楼层，请检查场景模型结构", objName))
          break
        end
        if floorIndex > self.nHomeMap[houseIndex].maxFloorIndex then
          self.nHomeMap[houseIndex].maxFloorIndex = floorIndex
        end
        tabFloorDatas = self.nHomeMap[houseIndex].tabRenovationMap[floorIndex]
        if not tabFloorDatas then
          tabFloorDatas = {}
          self.nHomeMap[houseIndex].tabRenovationMap[floorIndex] = tabFloorDatas
        end
        tabMatTypeMap = tabFloorDatas[typeID]
        if not tabMatTypeMap then
          tabMatTypeMap = {}
          tabFloorDatas[typeID] = tabMatTypeMap
        end
        tabMat = {
          meshRenderer = mr,
          id = mr:GetInstanceID(),
          gameObject = mr.gameObject,
          name = tsfParent.name,
          floorIndex = floorIndex,
          dataType = typeID,
          matFolderName = matFolderName
        }
        if self:IsRenovationTypeDivideByPos(typeID, houseIndex) then
          wallFound = false
          for key, posInfo in pairs(self.objPos) do
            objName = tsfParent.name
            if string.find(objName, key) then
              tabMat.posText = posInfo.text
              tabMatTypeMap[posInfo.index] = tabMat
              wallFound = true
            end
          end
          if not wallFound then
            LogUtility.Error(string.format("无法确定墙%s的摆放位置，请检查名字拼写", objName))
          end
        else
          tabMatTypeMap[#tabMatTypeMap + 1] = tabMat
        end
      end
    end
  end
  ReusableTable.DestroyAndClearTable(renovationTypes)
end

function SnowRealmManager:IsRenovationTypeDivideByPos(typeID, houseIndex)
  return false
end

function SnowRealmManager:CreateGroundColliders(houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  self:ResetGroundHeight(0, houseIndex)
  local l_objFloorModel = Game.GameObjectUtil:DeepFind(self.nHomeMap[houseIndex].objBuildRoot, "Floor")
  if not l_objFloorModel then
    LogUtility.Error("未找到地板模型'Floor'，请检查场景模型结构")
    return
  end
  local l_objGroundColliderRoot = GameObject.Instantiate(l_objFloorModel, self.nHomeMap[houseIndex].tsfGroundColliderRoot, true)
  local mrGrounds = l_objGroundColliderRoot:GetComponentsInChildren(MeshRenderer, true)
  local objGround, floorName, startPos, floorIndex
  for i = 1, #mrGrounds do
    objGround = mrGrounds[i].gameObject
    if string.find(objGround.name, "NotGround") then
      objGround:SetActive(false)
    else
      local tsf = objGround.transform
      while tsf ~= nil do
        if tsf.name and string.sub(tsf.name, 1, 5) == "Floor" then
          floorName = tsf.name
          break
        end
        tsf = tsf.parent
      end
      startPos = string.find(string.reverse(floorName), "_")
      floorIndex = tonumber(string.sub(floorName, string.len(floorName) - startPos + 2, string.len(floorName)))
      objGround.name = floorIndex
      objGround.gameObject.layer = Game.ELayer.HomeGround
      objGround:AddComponent(MeshCollider)
      mrGrounds[i].enabled = false
    end
  end
  local info = self.nHomeMap[houseIndex].mapInfo[1]
  objGround = GameObject()
  local tsfDefaultGround = objGround.transform
  objGround.name = "0"
  objGround.layer = Game.ELayer.HomeDefaultGround
  tsfDefaultGround.position = GetTempVector3(info.x, info.y, info.z)
  local collider = objGround:AddComponent(BoxCollider)
  collider.size = GetTempVector3(23.5, 0.1, 23.5)
  collider.isTrigger = true
  tsfDefaultGround.parent = self.nHomeMap[houseIndex].tsfGroundColliderRoot
end

function SnowRealmManager:UpdateRenovation(floorIndex, houseIndex)
  if self:IsInEditMode() then
    return
  end
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  local curHouseData = SnowRealmProxy.Instance:GetHouseData(houseIndex)
  if not curHouseData then
    return
  end
  local serverRenovationMap = curHouseData:GetRenovationDataMapByFloor(floorIndex)
  if not serverRenovationMap then
    return
  end
  for typeID, materialSData in pairs(serverRenovationMap) do
    self:ChangeObjMaterial(materialSData.id, floorIndex, nil, nil, houseIndex)
  end
end

function SnowRealmManager:ResetRenovations(houseIndex)
  if self:IsInEditMode() then
    return
  end
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  local curHouseData = SnowRealmProxy.Instance:GetHouseData(houseIndex)
  local renovationMap = self:GetRenovationMap(houseIndex)
  local targetMaterialID
  for floorIndex, floorMap in pairs(renovationMap) do
    for typeID, typeMap in pairs(floorMap) do
      if self:IsRenovationTypeDivideByPos(typeID, houseIndex) then
      else
        targetMaterialID = curHouseData and curHouseData:GetRenovationMaterialID(floorIndex, typeID) or self:GetDefaultMatIDByType(typeID)
        self:ChangeObjMaterial(targetMaterialID, floorIndex, nil, nil, houseIndex)
      end
    end
  end
end

function SnowRealmManager:InitWalls(houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  self:ClearWallMaps(houseIndex)
  local tsfWallsRoot, tsfParent, floorName, startPos, floorIndex, wallName, wallConfigID, tsfFloor, tsfWall, vecPos, vecForward, wallData, floorWallMap, logicFloorWallMap
  local l_objWallsRoot = Game.GameObjectUtil:DeepFind(self.nHomeMap[houseIndex].objBuildRoot, "Hidden_Wall")
  if l_objWallsRoot then
    tsfWallsRoot = l_objWallsRoot.transform
    for i = 0, tsfWallsRoot.childCount - 1 do
      tsfParent = tsfWallsRoot:GetChild(i)
      for j = 0, tsfParent.childCount - 1 do
        tsfFloor = tsfParent:GetChild(j)
        floorName = tsfFloor.name
        startPos = string.find(string.reverse(floorName), "_")
        floorIndex = startPos and tonumber(string.sub(floorName, string.len(floorName) - startPos + 2, string.len(floorName)))
        floorWallMap = self.nHomeMap[houseIndex].tabWalls[floorIndex]
        if not floorWallMap then
          floorWallMap = {}
          self.nHomeMap[houseIndex].tabWalls[floorIndex] = floorWallMap
        end
        logicFloorWallMap = self.nHomeMap[houseIndex].tabLogicWalls[floorIndex]
        if not logicFloorWallMap then
          logicFloorWallMap = {}
          self.nHomeMap[houseIndex].tabLogicWalls[floorIndex] = logicFloorWallMap
        end
        for x = 0, tsfFloor.childCount - 1 do
          tsfWall = tsfFloor:GetChild(x)
          wallName = tsfWall.name
          startPos = string.find(string.reverse(wallName), "_")
          wallConfigID = startPos and tonumber(string.sub(wallName, string.len(wallName) - startPos + 2, string.len(wallName)))
          vecPos = LuaVector3(LuaGameObject.GetPosition(tsfWall))
          vecForward = tsfWall.forward
          wallData = {
            id = "Wall_" .. wallConfigID,
            gameObject = tsfWall.gameObject,
            transform = tsfWall,
            floorIndex = floorIndex,
            position = vecPos,
            forward = LuaVector3(vecForward.x, vecForward.y, vecForward.z),
            visibleConfig = self.wallVisibleDefaultConfig,
            activeSelf = true
          }
          floorWallMap[#floorWallMap + 1] = wallData
          if not string.find(wallName, "Pillar") then
            wallData.id = self.nHomeMap[houseIndex].buildingGrid:GetWallId(floorIndex, vecPos.x, vecPos.z)
            logicFloorWallMap[wallData.id] = wallData
          end
        end
      end
    end
  end
  local l_objUnHiddenWall = Game.GameObjectUtil:DeepFind(self.nHomeMap[houseIndex].objBuildRoot, "UnHidden_Wall")
  if l_objUnHiddenWall then
    tsfWallsRoot = l_objUnHiddenWall.transform
    for i = 0, tsfWallsRoot.childCount - 1 do
      tsfParent = tsfWallsRoot:GetChild(i)
      for j = 0, tsfParent.childCount - 1 do
        tsfFloor = tsfParent:GetChild(j)
        floorName = tsfFloor.name
        startPos = string.find(string.reverse(floorName), "_")
        floorIndex = startPos and tonumber(string.sub(floorName, string.len(floorName) - startPos + 2, string.len(floorName)))
        logicFloorWallMap = self.nHomeMap[houseIndex].tabLogicWalls[floorIndex]
        if not logicFloorWallMap then
          logicFloorWallMap = {}
          self.nHomeMap[houseIndex].tabLogicWalls[floorIndex] = logicFloorWallMap
        end
        for x = 0, tsfFloor.childCount - 1 do
          tsfWall = tsfFloor:GetChild(x)
          if not string.find(tsfWall.name, "Pillar") then
            vecPos = LuaVector3(LuaGameObject.GetPosition(tsfWall))
            vecForward = tsfWall.forward
            wallData = {
              id = self.nHomeMap[houseIndex].buildingGrid:GetWallId(floorIndex, vecPos.x, vecPos.z),
              gameObject = tsfWall.gameObject,
              transform = tsfWall,
              floorIndex = floorIndex,
              position = vecPos,
              forward = LuaVector3(vecForward.x, vecForward.y, vecForward.z),
              visibleConfig = self.wallVisibleDefaultConfig
            }
            logicFloorWallMap[wallData.id] = wallData
          end
        end
      end
    end
  end
end

function SnowRealmManager:ChangeObjMaterial(materialStaticID, floorIndex, posKey, callBack, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  local materialStaticData = Table_HomeFurnitureMaterial[materialStaticID]
  if not materialStaticData then
    return false
  end
  local typeID = materialStaticData.Type
  local objMap = self.nHomeMap[houseIndex].tabRenovationMap[floorIndex]
  objMap = objMap and objMap[typeID]
  if not objMap then
    LogUtility.Error(string.format("没有找到目标物体！楼层：%s，类型ID：%s", tostring(floorIndex), tostring(typeID)))
    if callBack then
      callBack(nil)
    end
    return
  end
  if posKey then
    local tabObjInfo = objMap[posKey]
    if tabObjInfo and tabObjInfo.meshRenderer then
      if self:IsSameMatetialByName(materialStaticData.NameEn, tabObjInfo.meshRenderer.material.name) or not materialStaticID then
        return false
      end
      Game.AssetManager_Furniture:LoadHomeMaterialAlbedo(materialStaticID, tabObjInfo.matFolderName, function(tex, meshRenderer)
        if not tex then
          LogUtility.Error(string.format("加载材质Albedo贴图id: %s 失败！", tostring(materialStaticID)))
        elseif not Slua.IsNull(meshRenderer) then
          local material = meshRenderer.material
          if material then
            if material:HasProperty("_MainTex") then
              material:SetTexture("_MainTex", tex)
            end
            if material:HasProperty("_BaseMap") then
              material:SetTexture("_BaseMap", tex)
            end
          end
        end
        if callBack then
          callBack(tex)
        end
      end, tabObjInfo.meshRenderer)
    else
      LogUtility.Error(string.format("没有找到目标物体！楼层：%s，类型ID：%s，位置ID：%s", tostring(floorIndex), tostring(typeID), tostring(posKey)))
    end
  else
    for _, tabObjInfo in pairs(objMap) do
      if tabObjInfo.meshRenderer then
        if self:IsSameMatetialByName(materialStaticData.NameEn, tabObjInfo.meshRenderer.material.name) or not materialStaticID then
          return false
        end
        Game.AssetManager_Furniture:LoadHomeMaterialAlbedo(materialStaticID, tabObjInfo.matFolderName, function(tex, meshRenderer)
          if not tex then
            LogUtility.Error(string.format("加载材质Albedo贴图id: %s 失败！", tostring(materialStaticID)))
          elseif not Slua.IsNull(meshRenderer) then
            local material = meshRenderer.material
            if material then
              if material:HasProperty("_MainTex") then
                material:SetTexture("_MainTex", tex)
              end
              if material:HasProperty("_BaseMap") then
                material:SetTexture("_BaseMap", tex)
              end
            end
          end
          if callBack then
            callBack(tex)
          end
        end, tabObjInfo.meshRenderer)
      end
    end
  end
end

function SnowRealmManager:IsSameMatetialByName(targetMaterialName, currentMatetialName)
  return targetMaterialName == currentMatetialName or targetMaterialName .. " (Instance)" == currentMatetialName
end

function SnowRealmManager:ClearWallMaps(houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  local tabWalls = self.nHomeMap[houseIndex].tabWalls
  for floorIndex, floorMap in pairs(tabWalls) do
    for index, wallData in pairs(floorMap) do
      TableUtility.TableClear(wallData)
    end
  end
  TableUtility.TableClear(self.nHomeMap[houseIndex].tabWalls)
  local tabLogicWalls = self.nHomeMap[houseIndex].tabLogicWalls
  for floorIndex, floorMap in pairs(tabLogicWalls) do
    for wallID, wallData in pairs(floorMap) do
      TableUtility.TableClear(wallData)
    end
  end
  TableUtility.TableClear(self.nHomeMap[houseIndex].tabLogicWalls)
end

function SnowRealmManager:ClearRenovationMap(houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  for floorIndex, floorData in pairs(self.nHomeMap[houseIndex].tabRenovationMap) do
    for typeID, typeData in ipairs(floorData) do
      for index, matData in pairs(typeData) do
        TableUtility.TableClear(matData)
      end
    end
  end
  TableUtility.TableClear(self.nHomeMap[houseIndex].tabRenovationMap)
end

function SnowRealmManager:FindOrCreateTransform(name, objParent)
  local obj
  if objParent then
    obj = Game.GameObjectUtil:DeepFind(objParent, name)
  else
    obj = GameObject.Find(name)
  end
  local tsfObj
  if obj then
    tsfObj = obj.transform
    for i = tsfObj.childCount - 1, 0, -1 do
      GameObject.DestroyImmediate(tsfObj:GetChild(i).gameObject)
    end
  else
    tsfObj = GameObject().transform
    if objParent then
      tsfObj:SetParent(objParent.transform, false)
    end
    tsfObj.name = name
    tsfObj.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
    tsfObj.localEulerAngles = LuaGeometry.GetTempVector3(0, 0, 0)
    tsfObj.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
  end
  return tsfObj
end

function SnowRealmManager:ClearFurnituresByHouseIndex(includeOperateFurniture, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  local home = self.nHomeMap[houseIndex]
  local homeFurnitureMap = home.nFurnitureMap or {}
  for id, nFurniture in pairs(homeFurnitureMap) do
    if not (not includeOperateFurniture and nFurniture) or not nFurniture.isSelect then
      self:_DestroyFurniture(nFurniture, houseIndex)
      homeFurnitureMap[id] = nil
    end
  end
  local homeFurnitureClientMap = home.nFurnitureClientMap or {}
  for id, nFurniture in pairs(homeFurnitureClientMap) do
    if not (not includeOperateFurniture and nFurniture) or not nFurniture.isSelect then
      self:_DestroyFurniture(nFurniture, houseIndex)
      homeFurnitureClientMap[id] = nil
    end
  end
end

function SnowRealmManager:ClearFurnitures(includeOperateFurniture)
  for i = 1, HouseCount do
    self:ClearFurnituresByHouseIndex(includeOperateFurniture, i)
  end
end

function SnowRealmManager:CreateCurrentFurnitures(houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  local furnitureDatas = SnowRealmProxy.Instance:GetFurnitureDatas(houseIndex)
  for id, nFurnitureData in pairs(furnitureDatas) do
    self:UpdateFurniture(nFurnitureData, nil, nil, houseIndex)
  end
end

function SnowRealmManager:UpdateFurniture(nFurnitureData, customCallback, customCallbackArg, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  local nFurniture = self:FindFurniture(nFurnitureData.id, true, houseIndex) or self:FindFurniture(nFurnitureData.oldID, true, houseIndex)
  self.nHomeMap[houseIndex].nFurnitureClientMap[nFurnitureData.id] = nil
  self.nHomeMap[houseIndex].nFurnitureMap[nFurnitureData.oldID] = nil
  self.nHomeMap[houseIndex].nFurnitureClientMap[nFurnitureData.oldID] = nil
  if nFurniture then
    if not nFurniture.inited then
      return
    end
    nFurniture:SetData(nFurnitureData)
    self:UpdateFurnitureCallBack(houseIndex, nFurniture, 0.2, customCallback, customCallbackArg)
  else
    nFurniture = NFurniture.new(nFurnitureData.id, nFurnitureData.staticID, self.nHomeMap[houseIndex].tsfFurnituresRoot, function(furniture)
      if self.nHomeMap[houseIndex].buildingGrid == nil then
        return
      end
      if not furniture.inited then
        LogUtility.Error(string.format("家具%s资源加载失败，将被移除！", tostring(nFurnitureData.staticID)))
        if self:IsAtMyselfHome() then
          self:FurnitureItemPlaceFailed(furniture.id, nil, houseIndex)
        end
        return
      end
      furniture:SetData(nFurnitureData)
      furniture.assetFurniture:SetAlpha(0)
      if self:IsInEditMode() then
        furniture.assetFurniture:SetColliderLayer(Game.ELayer.HomeFurniture)
      else
        furniture:SetColliderLayer(furniture:HaveFunction() and Game.ELayer.Accessable or Game.ELayer.Default)
      end
      self:UpdateFurnitureCallBack(houseIndex, furniture, 0.5, customCallback, customCallbackArg)
    end)
  end
  self.nHomeMap[houseIndex].nFurnitureMap[nFurnitureData.id] = nFurniture
end

function SnowRealmManager:RemoveFurnitureItem(id, force, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  local tmpArray = ReusableTable.CreateArray()
  tmpArray[#tmpArray + 1] = id
  self:RemoveFurnitureItems(tmpArray, force, houseIndex)
  ReusableTable.DestroyAndClearArray(tmpArray)
end

function SnowRealmManager:FurnitureItemPlaceFailed(id, msg, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  self:RemoveFurnitureItem(id, true, houseIndex)
end

function SnowRealmManager:RemoveFurnitureItems(ids, force, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  local tmpArray = ReusableTable.CreateArray()
  local singleID, nFurniture, pbFurniture
  for i = 1, #ids do
    singleID = ids[i]
    nFurniture = self:FindFurniture(singleID, true, houseIndex)
    if nFurniture then
      if not nFurniture.data:IsServerInited() then
        self:RemoveFurnitureItem_Server(singleID, houseIndex)
      else
        self.nHomeMap[houseIndex].nFurnitureClientMap[singleID] = nFurniture
        self.nHomeMap[houseIndex].nFurnitureMap[singleID] = nil
        nFurniture.assetFurniture:SetAlpha(0.5)
        nFurniture.assetFurniture:SetColliderEnable(false)
        pbFurniture = self:ParseFurnitureToPbMsg(nFurniture)
      end
    else
      pbFurniture = SceneItem_pb.Furniture()
      table.guid = singleID
    end
    tmpArray[#tmpArray + 1] = pbFurniture
  end
  if 0 < #tmpArray then
    self.hasEditedFurnitureInThisEditSession = true
    ServiceHomeCmdProxy.Instance:CallFurnitureActionHomeCmd(HomeCmd_pb.EFURNITUREACTION_PUTOFF, tmpArray, force)
  end
  ReusableTable.DestroyAndClearArray(tmpArray)
end

function SnowRealmManager:RemoveFurnitureItem_Server(id, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  local nFurniture = self:FindFurniture(id, true, houseIndex)
  self:_DestroyFurniture(nFurniture, houseIndex)
  self.nHomeMap[houseIndex].nFurnitureMap[id] = nil
  self.nHomeMap[houseIndex].nFurnitureClientMap[id] = nil
end

function SnowRealmManager:FindFurniture(id, includeClientFurniture, houseIndex)
  if houseIndex and 0 < houseIndex then
    local nFurniture = self:FindFurnitureByHouseIndex(id, includeClientFurniture, houseIndex)
    if nFurniture then
      return nFurniture
    end
  end
  for k, v in pairs(self.nHomeMap) do
    local nFurniture = self:FindFurnitureByHouseIndex(id, includeClientFurniture, k)
    if nFurniture then
      return nFurniture
    end
  end
end

function SnowRealmManager:FindFurnitureByHouseIndex(id, includeClientFurniture, houseIndex)
  if houseIndex and 0 < houseIndex then
    local nFurniture = self.nHomeMap[houseIndex].nFurnitureMap[id]
    if not nFurniture and includeClientFurniture then
      nFurniture = self.nHomeMap[houseIndex].nFurnitureClientMap[id]
    end
    if nFurniture and not nFurniture.inited and not includeClientFurniture then
      return
    end
    return nFurniture
  end
end

function SnowRealmManager:UpdateFurnitureCallBack(houseIndex, nFurniture, fadeTime, customCallback, customCallbackArg)
  if not nFurniture.inited then
    return
  end
  nFurniture.assetFurniture:SetColliderEnable(true)
  nFurniture:SetRotationAngle(nFurniture.placeAngle)
  local targetRow, targetCol = nFurniture.placeRow, nFurniture.placeCol
  local result, right, wrong, placeRow, placeCol = self:PlaceFurniture_T(nFurniture, nFurniture.placeFloor, targetRow, targetCol, nFurniture:GetRotationAngle(), nil, houseIndex)
  if nFurniture:GetRotationAngle() ~= nFurniture.placeAngle then
    LogUtility.Warning(string.format("服务器角度: %s, 本地修正为: %s", tostring(nFurniture.placeAngle), tostring(nFurniture:GetRotationAngle())))
  end
  if result == BuildingGrid.EPlaceFurnitureResult.ESuccess then
    nFurniture:PlaceOnCurCell()
    local pos = self:GetBuildPosByCells(nFurniture.placeFloor, right, wrong, houseIndex)
    nFurniture.assetFurniture:SetPosition(pos)
    nFurniture.assetFurniture:AlphaTo(1, fadeTime)
    if nFurniture:IsHideWithWall() then
      nFurniture.assetFurniture:SetParent(self:GetNearestWall(nFurniture.placeFloor, pos.x, pos.z, houseIndex).transform, true)
    end
    local relativeCreatureID = self.relativeCreatureMap[nFurniture.data.id]
    local nCreature = relativeCreatureID and SceneCreatureProxy.FindCreature(relativeCreatureID)
    if nCreature then
      nCreature:UpdateWithRelativeFurniture()
    end
    EventManager.Me():DispatchEvent(HomeEvent.UpdateFurniture, nFurniture)
    if customCallback then
      customCallback(customCallbackArg, nFurniture, nFurniture.data)
    end
    return nFurniture
  else
    LogUtility.Error(string.format("服务器刷新家具失败！家具id: %s将被移除。尝试摆放在{floor: %s, row:%s, col%s, angle:%s}, 摆放结果: %s", tostring(nFurniture.id), tostring(nFurniture.placeFloor), tostring(targetRow), tostring(targetCol), tostring(nFurniture.placeAngle), tostring(result)))
    if self:IsAtMyselfHome() then
      self:FurnitureItemPlaceFailed(nFurniture.id, nil, houseIndex)
    end
    self:RemoveFurnitureItem_Server(nFurniture.id)
    if customCallback then
      customCallback(customCallbackArg)
    end
  end
end

function SnowRealmManager:PlaceFurniture_T(nFurniture, floorIndex, targetRow, targetCol, angle, isTry, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  angle = angle or nFurniture:GetRotationAngle()
  local result, right, wrong, placeRow, placeCol, isNearWall = self.nHomeMap[houseIndex].buildingGrid:PlaceFurniture_T(nFurniture.tag, nFurniture.staticID, floorIndex, targetRow, targetCol, angle, isTry == true)
  nFurniture:SetCurCell(floorIndex, placeRow, placeCol)
  if targetRow ~= placeRow or targetCol ~= placeCol then
    LogUtility.Error(string.format("看到此条请报给前端! 家具: %s(floor: %s, angle: %s)尝试摆放在{row: %s, col: %s}, 但实际摆放在了{row: %s, col: %s}, 摆放结果: %s。", tostring(nFurniture and nFurniture.staticID), tostring(floorIndex), tostring(angle), tostring(targetRow), tostring(targetCol), tostring(placeRow), tostring(placeCol), tostring(result)))
  end
  return result, right, wrong, placeRow, placeCol, isNearWall
end

function SnowRealmManager:IsInEditMode()
  return self:IsAtMyselfHome() and self.isInEditMode == true
end

function SnowRealmManager:SetFurnitureColliderLayerToNormal()
  local houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  if nil == houseIndex or houseIndex == 0 then
    return
  end
  local furnitures = self:GetFurnituresMap(houseIndex)
  for id, nFurniture in pairs(furnitures) do
    nFurniture:SetColliderLayer(nFurniture:HaveFunction() and Game.ELayer.Accessable or Game.ELayer.Default)
  end
end

function SnowRealmManager:IsAtMyselfHome()
  if nil == self.curHomeIdx or self.curHomeIdx <= 0 then
    return false
  end
  local myHomeIndex = SnowRealmProxy and SnowRealmProxy.Instance and SnowRealmProxy.Instance:GetMySelfHomeIndex()
  return self.curHomeIdx == myHomeIndex
end

function SnowRealmManager:_DestroyFurniture(nFurniture, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  if not nFurniture then
    return
  end
  self:_DestroyFurnitureInteract(nFurniture)
  local insID = nFurniture:GetInstanceID()
  if insID then
    HomeFurniturOutLine.Me():RemoveTarget(insID)
  end
  self:RemoveFurnitureFromGrid(nFurniture.tag, houseIndex)
  nFurniture:Destroy(true)
end

function SnowRealmManager:RemoveFurnitureFromGrid(tag, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  return self.nHomeMap[houseIndex].buildingGrid:RemoveFurniture(tag)
end

function SnowRealmManager:_DestroyFurnitureInteract(nFurniture)
  if nFurniture.extraInteract == nil then
    return
  end
  local stopPatrol = function(creature)
    local patrolAI = creature.ai.idleAI_Patrol
    if patrolAI ~= nil and patrolAI.interact == nFurniture.extraInteract then
      patrolAI:StopPatrol(creature)
      patrolAI:ResumePatrol(creature)
    end
  end
  local npcs = NSceneNpcProxy.Instance:GetAll()
  for _, npc in pairs(npcs) do
    stopPatrol(npc)
  end
  local feedingPets = SnowRealmProxy.Instance:GetCurFeedingPet()
  if nil ~= feedingPets then
    for _, pet in ipairs(feedingPets) do
      stopPatrol(pet)
    end
  end
end

local vecCellPos = LuaVector3(0, 0, 0)

function SnowRealmManager:GetBuildPosByCells(floorIndex, right, wrong, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  local curGroundHeight = self.curGroundHeight or 0
  if curGroundHeight ~= 0 then
    self:ResetGroundHeight(0, houseIndex)
  end
  local i = 1
  local posX, posZ, minX, maxX, minZ, maxZ
  if right then
    for j = 1, #right do
      posX, posZ = self:ConvertRowAndColToWorldPosition(floorIndex, right[j].row, right[j].col, houseIndex)
      if not minX or posX < minX then
        minX = posX
      end
      if not maxX or maxX < posX then
        maxX = posX
      end
      if not minZ or minZ > posZ then
        minZ = posZ
      end
      if not maxZ or maxZ < posZ then
        maxZ = posZ
      end
      i = i + 1
    end
  end
  if wrong then
    for j = 1, #wrong do
      posX, posZ = self:ConvertRowAndColToWorldPosition(floorIndex, wrong[j].row, wrong[j].col, houseIndex)
      if not minX or posX < minX then
        minX = posX
      end
      if not maxX or posX > maxX then
        maxX = posX
      end
      if not minZ or minZ > posZ then
        minZ = posZ
      end
      if not maxZ or maxZ < posZ then
        maxZ = posZ
      end
      i = i + 1
    end
  end
  if curGroundHeight ~= 0 then
    self:ResetGroundHeight(curGroundHeight, houseIndex)
  end
  posX, posZ = ((minX or 0) + (maxX or 0)) / 2, ((minZ or 0) + (maxZ or 0)) / 2
  return GetTempVector3(posX, self:GetWorldPosYByXZ(floorIndex, posX, posZ, houseIndex), posZ, vecCellPos)
end

function SnowRealmManager:ConvertRowAndColToWorldPosition(floorIndex, row, col, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  return self.nHomeMap[houseIndex].buildingGrid:ConvertRowAndColToWorldPosition(floorIndex, row, col)
end

function SnowRealmManager:ResetGroundHeight(height, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  local pos = self.nHomeMap[houseIndex].tsfGroundColliderRoot.position
  pos.y = height or 0
  self.nHomeMap[houseIndex].tsfGroundColliderRoot.position = pos
  self.nHomeMap[houseIndex].curGroundHeight = height
end

function SnowRealmManager:GetNearestWall(floorIndex, posX, posZ, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  local logicWallID = self.nHomeMap[houseIndex].buildingGrid:GetWallId(floorIndex, posX, posZ)
  local wall = logicWallID and self.nHomeMap[houseIndex].tabLogicWalls[floorIndex][logicWallID]
  if wall then
    return wall
  else
    LogUtility.Error(string.format("没有在%s楼找到墙壁id: %s", tostring(floorIndex), tostring(logicWallID)))
    return self:GetFurnitureRootTransform()
  end
end

function SnowRealmManager:FindOrCreateTransform(name, objParent)
  local obj
  if objParent then
    obj = Game.GameObjectUtil:DeepFind(objParent, name)
  else
    obj = GameObject.Find(name)
  end
  local tsfObj
  if obj then
    tsfObj = obj.transform
    for i = tsfObj.childCount - 1, 0, -1 do
      GameObject.DestroyImmediate(tsfObj:GetChild(i).gameObject)
    end
  else
    tsfObj = GameObject().transform
    if objParent then
      tsfObj:SetParent(objParent.transform, false)
    end
    tsfObj.name = name
    tsfObj.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
    tsfObj.localEulerAngles = LuaGeometry.GetTempVector3(0, 0, 0)
    tsfObj.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
  end
  return tsfObj
end

function SnowRealmManager:GetCurMaxFloorIndex(houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  return self.nHomeMap[houseIndex].maxFloorIndex or 0
end

function SnowRealmManager:GetRenovationMap(houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  return self.nHomeMap[houseIndex].tabRenovationMap
end

function SnowRealmManager:GetDefaultMatIDByType(typeID, isTry)
  local matConfig = GameConfig.HomeRenovationDefaultMat[typeID]
  if not matConfig then
    if not isTry then
      LogUtility.Error(string.format("没有在GameConfig.HomeRenovationDefaultMat中找到装潢类型: %s的默认材质id，请检查配置！", tostring(typeID)))
    end
    return
  end
  return self.curMapSData and matConfig[self.curMapSData.id] or matConfig.default
end

function SnowRealmManager:GetFurnitureFunctionsList(nFurniture)
  self:ClearFurnitureFuncList()
  self.listFurnitureFunc = ReusableTable.CreateArray()
  local functions = nFurniture.data.staticData.FurnitureFunction
  if not nFurniture:IsAccessible() or not functions then
    return self.listFurnitureFunc
  end
  local funcStatus, singleData, furnitureFuncSData, functionParam, contentText
  for i = 1, #functions do
    furnitureFuncSData = Table_FurnitureFunction[functions[i].type]
    functionParam = functions[i].param or furnitureFuncSData.Parama
    contentText = functions[i].name or furnitureFuncSData.NameZh
    if furnitureFuncSData then
      funcStatus = FunctionFurnitureFunc.Me():CheckFuncState(furnitureFuncSData.NameEn, nFurniture, functionParam)
      if funcStatus ~= FurnitureFuncState.InActive then
        singleData = ReusableTable.CreateTable()
        singleData.functionStaticData = furnitureFuncSData
        singleData.status = funcStatus
        singleData.param = functionParam
        singleData.content = contentText
        self.listFurnitureFunc[#self.listFurnitureFunc + 1] = singleData
      end
    end
  end
  return self.listFurnitureFunc
end

function SnowRealmManager:ClearFurnitureFuncList()
  if not self.listFurnitureFunc then
    return
  end
  for i = 1, #self.listFurnitureFunc do
    ReusableTable.DestroyAndClearTable(self.listFurnitureFunc[i])
  end
  ReusableTable.DestroyAndClearArray(self.listFurnitureFunc)
  self.listFurnitureFunc = nil
end

function SnowRealmManager:GetFurnituresMap(houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  return self.nHomeMap[houseIndex].nFurnitureMap
end

function SnowRealmManager:GetClientFurnituresMap(houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  return self.nHomeMap[houseIndex].nFurnitureClientMap
end

function SnowRealmManager:FindFurnituresByStaticID(staticID, includeClientFurniture, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  TableUtility.TableClear(self.tmpDataList)
  local furnitures = self:GetFurnituresMap(houseIndex)
  for id, nFurniture in pairs(furnitures) do
    if nFurniture.data.staticID == staticID then
      self.tmpDataList[#self.tmpDataList + 1] = nFurniture
    end
  end
  if not includeClientFurniture then
    return self.tmpDataList
  end
  furnitures = self:GetClientFurnituresMap(houseIndex)
  for id, nFurniture in pairs(furnitures) do
    if nFurniture.data.staticID == staticID then
      self.tmpDataList[#self.tmpDataList + 1] = nFurniture
    end
  end
  return self.tmpDataList
end

function SnowRealmManager:GetFurnituresIDListByStaticID(staticID, includeClientFurniture, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  TableUtility.TableClear(self.tmpDataList)
  local furnitures = self:GetFurnituresMap(houseIndex)
  for id, nFurniture in pairs(furnitures) do
    if nFurniture.data.staticID == staticID then
      self.tmpDataList[#self.tmpDataList + 1] = id
    end
  end
  if not includeClientFurniture then
    return self.tmpDataList
  end
  furnitures = self:GetClientFurnituresMap(houseIndex)
  for id, nFurniture in pairs(furnitures) do
    if nFurniture.data.staticID == staticID then
      self.tmpDataList[#self.tmpDataList + 1] = id
    end
  end
  return self.tmpDataList
end

function SnowRealmManager:GetFurnituresByStaticType(t, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  if houseIndex == 0 then
    return {}
  end
  TableUtility.ArrayClear(self.tmpDataList)
  for _, nFurniture in pairs(self.nHomeMap[houseIndex].nFurnitureMap) do
    if nFurniture.data and nFurniture.data:GetItemType() == t then
      TableUtility.ArrayPushBack(self.tmpDataList, nFurniture)
    end
  end
  return self.tmpDataList
end

function SnowRealmManager:SetRelativeCreature(furnitureID, creatureID)
  if StringUtil.IsEmpty(furnitureID) or StringUtil.IsEmpty(creatureID) then
    return
  end
  self.relativeCreatureMap[furnitureID] = creatureID
end

function SnowRealmManager:RemoveRelativeCreature(furnitureID)
  if StringUtil.IsEmpty(furnitureID) then
    return
  end
  self.relativeCreatureMap[furnitureID] = nil
end

function SnowRealmManager:UpdateRelativeCreatures()
  local nCreature
  for furnitureID, creatureID in pairs(self.relativeCreatureMap) do
    nCreature = SceneCreatureProxy.FindCreature(creatureID)
    if nCreature then
      nCreature:UpdateWithRelativeFurniture()
    end
  end
end

function SnowRealmManager:ResetWallsAndPillarsStatus(houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  for floorIndex, floorWallMap in pairs(self.nHomeMap[houseIndex].tabWalls) do
    for id, wall in pairs(floorWallMap) do
      if not wall.activeSelf then
        wall.gameObject:SetActive(true)
        wall.activeSelf = true
      end
    end
  end
end

function SnowRealmManager:ResetClientFurnitures(includeOperateFurniture, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  local tmpArray = ReusableTable.CreateTable()
  for id, nFurniture in pairs(self.nHomeMap[houseIndex].nFurnitureClientMap) do
    if not (not includeOperateFurniture and nFurniture) or not nFurniture.isSelect then
      if nFurniture and nFurniture.data:IsServerInited() then
        tmpArray[#tmpArray + 1] = nFurniture.data
      else
        self:_DestroyFurniture(nFurniture, houseIndex)
        self.nHomeMap[houseIndex].nFurnitureClientMap[id] = nil
      end
    end
  end
  for id, nFurnitureData in pairs(tmpArray) do
    self:UpdateFurniture(nFurnitureData, nil, nil, houseIndex)
  end
  ReusableTable.DestroyAndClearTable(tmpArray)
end

local vecObjToMe = LuaVector3(0, 0, 0)

function SnowRealmManager:ProcessWallsAndPillarsShow(cameraPosX, cameraPosY, cameraPosZ, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  local isWallStatusChanged = false
  local cameraPos = GetTempVector3(cameraPosX, cameraPosY, cameraPosZ)
  local angle, visibleConfig, isActive
  for floorIndex, floorWallMap in pairs(self.nHomeMap[houseIndex].tabWalls) do
    for id, wall in pairs(floorWallMap) do
      LuaVector3.Better_Set(vecObjToMe, wall.position.x, wall.position.y, wall.position.z)
      LuaVector3.Sub(vecObjToMe, cameraPos)
      vecObjToMe[2] = 0
      angle = Vector3.SignedAngle(LuaVector3.Normalize(vecObjToMe), wall.forward, m_vecUp)
      visibleConfig = wall.visibleConfig
      if angle < 0 then
        angle = angle + 360
      end
      if visibleConfig.EndAngle > visibleConfig.StartAngle then
        isActive = angle > visibleConfig.StartAngle and angle < visibleConfig.EndAngle
      else
        isActive = angle > visibleConfig.StartAngle or angle < visibleConfig.EndAngle
      end
      if wall.activeSelf ~= isActive then
        wall.gameObject:SetActive(isActive)
        wall.activeSelf = isActive
        isWallStatusChanged = true
      end
    end
  end
  if isWallStatusChanged then
    PpLua:Refresh()
  end
end

function SnowRealmManager:GetCurHouseConfig()
  LogUtility.Error("SnowRealmManager:GetCurHouseConfig not implemented yet")
end

function SnowRealmManager:ClearFurnitureRewards()
  local houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  if nil == houseIndex or houseIndex <= 0 then
    return
  end
  for id, nFurniture in pairs(self.nHomeMap[houseIndex].nFurnitureMap) do
    if nFurniture then
      nFurniture:ClearReward()
    end
  end
end

function SnowRealmManager:IsAtHome()
  return self.curAtHome == true
end

function SnowRealmManager:GetCurBluePrintData()
  return self.curBlurPrintData
end

function SnowRealmManager:IsSameMatetial(materialStaticID, currentMatetialName)
  local materialStaticData = Table_HomeFurnitureMaterial[materialStaticID]
  if not materialStaticData then
    LogUtility.Error("Table_HomeFurnitureMaterial中没有ID: " .. tostring(materialStaticID))
    return false
  end
  return self:IsSameMatetialByName(materialStaticData.NameEn, currentMatetialName)
end

function SnowRealmManager:IsSameMatetialByName(targetMaterialName, currentMatetialName)
  return targetMaterialName == currentMatetialName or targetMaterialName .. " (Instance)" == currentMatetialName
end

function SnowRealmManager:Renovation(materialStaticID, floorIndex, posKey, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  local sended
  self:ChangeObjMaterial(materialStaticID, floorIndex, posKey, function(obj)
    if obj and sended == nil then
      sended = true
      local table = HomeCmd_pb.HouseDecorate()
      table.floor = floorIndex
      table.ids[#table.ids + 1] = materialStaticID
      ServiceHomeCmdProxy.Instance:CallHouseActionHomeCmd(HomeCmd_pb.EHOUSEACTION_DEC, table)
    end
  end, houseIndex)
end

function SnowRealmManager:IsBluePrintMode()
  return self:IsInEditMode() and self.curBlurPrintData ~= nil
end

function SnowRealmManager:GetBluePrintFurnitureFinishedNum(staticID)
  local num = self.bpFinishNumMap and self.bpFinishNumMap[staticID]
  return num or 0
end

function SnowRealmManager:TryGetHomeWorkbenchDiscount(key)
  return HomeManager.GetInstance():TryGetHomeWorkbenchDiscount(key)
end

function SnowRealmManager:RegisterWorkingHomeStore(furniture)
  self.workingHomeStore = furniture
end

function SnowRealmManager:GetMyselfDistanceToFurniture(nFurniture)
  return LuaVector3.Distance(nFurniture:GetPosition(), Game.Myself:GetPosition())
end

function SnowRealmManager:GetCurMapSData()
  return self.curMapSData
end

function SnowRealmManager:GetFurnitureRootTransform(houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  return self.nHomeMap[houseIndex].tsfFurnituresRoot
end

function SnowRealmManager:TryPlaceFurniture(tag, staticID, floorIndex, posX, posZ, angle, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  return self.nHomeMap[houseIndex].buildingGrid:TryPlaceFurniture(tag, staticID, floorIndex, posX, posZ, angle)
end

function SnowRealmManager:RotateFurniture(nFurniture, floorIndex, row, col, angle, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  angle = angle or nFurniture:GetRotationAngle()
  local result, right, wrong, placeRow, placeCol = self.nHomeMap[houseIndex].buildingGrid:RotateFurniture(nFurniture.tag, nFurniture.staticID, floorIndex, row, col, angle)
  nFurniture:SetCurCell(floorIndex, placeRow, placeCol)
  return result, right, wrong, placeRow, placeCol
end

function SnowRealmManager:SetBluePrintMode(bluePrintData)
  if not self:IsInEditMode() then
    return
  end
  self.curBlurPrintData = bluePrintData
  if not bluePrintData then
    self.bpFinishNumMap = nil
  end
end

function SnowRealmManager:SetBluePrintFinishNumMap(bpFinishNumMap)
  self.bpFinishNumMap = bpFinishNumMap
end

local dataTypesArray = {}

function SnowRealmManager:GetDataTypesArray(buildType, seriesType, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  TableUtility.ArrayClear(dataTypesArray)
  if not buildType or not seriesType then
    LogUtility.Error("类型为空，不能取得数据")
    return dataTypesArray
  end
  local typeDatas, homeContentDatas
  if buildType == SnowRealmProxy.BuildType.Furniture then
    typeDatas = SnowRealmProxy.Instance:GetDatasByType(buildType, seriesType)
    homeContentDatas = typeDatas
  else
    typeDatas = self.nHomeMap[houseIndex].tabRenovationMap[seriesType]
    homeContentDatas = SnowRealmProxy.Instance:GetDatasByType(buildType)
  end
  if not typeDatas or not homeContentDatas then
    return dataTypesArray
  end
  for typeID, data in pairs(typeDatas) do
    if homeContentDatas[typeID] then
      dataTypesArray[#dataTypesArray + 1] = typeID
    end
  end
  table.sort(dataTypesArray, function(a, b)
    local dataA = Table_FurnitureType[a]
    local dataB = Table_FurnitureType[b]
    if not dataA then
      return false
    end
    if not dataB then
      return true
    end
    return dataA.Sort < dataB.Sort
  end)
  return dataTypesArray
end

function SnowRealmManager:GetMapInfo(houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  return self.nHomeMap[houseIndex].mapInfo
end

local homeContentDatasArray = {}

function SnowRealmManager:GetHomeContentDatasArray(buildType, seriesType, dataType, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  TableUtility.ArrayClear(homeContentDatasArray)
  if not (buildType and seriesType) or not dataType then
    LogUtility.Error("类型为空，不能取得数据")
    return homeContentDatasArray
  end
  local homeContentDatas
  if buildType == SnowRealmProxy.BuildType.Furniture then
    if dataType == GameConfig.Home.SpecialType_Owned then
      return self:GetOwnedFurniureContentDatasArray(seriesType, houseIndex)
    end
    homeContentDatas = SnowRealmProxy.Instance:GetDatasByType(buildType, seriesType, dataType)
  else
    homeContentDatas = SnowRealmProxy.Instance:GetDatasByType(buildType, dataType)
  end
  if not homeContentDatas then
    return homeContentDatasArray
  end
  local defaultMatID = self:GetDefaultMatIDByType(dataType, true)
  for staticID, singleData in pairs(homeContentDatas) do
    if staticID ~= defaultMatID and singleData:CanShowInBuildView(true) then
      homeContentDatasArray[#homeContentDatasArray + 1] = singleData
    end
  end
  return homeContentDatasArray
end

local homeContentDatasMap = {}

function SnowRealmManager:GetHomeContentDatasArrayByName(name)
  TableUtility.TableClear(homeContentDatasMap)
  TableUtility.ArrayClear(homeContentDatasArray)
  local furnitureDatas = SnowRealmProxy.Instance:GetDatasByType(SnowRealmProxy.BuildType.Furniture, SnowRealmProxy.FurnitureSpecialCatagory.All)
  if not furnitureDatas then
    return homeContentDatasMap
  end
  local defaultMatID
  for typeID, typeDatas in pairs(furnitureDatas) do
    defaultMatID = self:GetDefaultMatIDByType(typeID, true)
    for staticID, contentData in pairs(typeDatas) do
      if staticID ~= defaultMatID and not homeContentDatasMap[staticID] then
        homeContentDatasMap[staticID] = 1
        if not name or string.find(contentData.nameZh, name) and contentData:CanShowInBuildView(true) then
          homeContentDatasArray[#homeContentDatasArray + 1] = contentData
        end
      end
    end
  end
  TableUtility.TableClear(homeContentDatasMap)
  return homeContentDatasArray
end

function SnowRealmManager:GetOwnedFurniureContentDatasArray(seriesType, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  TableUtility.TableClear(homeContentDatasMap)
  TableUtility.ArrayClear(homeContentDatasArray)
  local contentData
  local furnitures = self:GetFurnituresMap(houseIndex)
  for id, nFurniture in pairs(furnitures) do
    if nFurniture.data and not homeContentDatasMap[nFurniture.data.staticID] then
      homeContentDatasMap[nFurniture.data.staticID] = 1
      if not seriesType or SnowRealmProxy.Instance:CheckCategory(nFurniture.data.staticData, seriesType) then
        contentData = SnowRealmProxy.Instance:FindContentDataBySID(nFurniture.data.staticID, SnowRealmProxy.BuildType.Furniture)
        if contentData then
          contentData:RefreshStatus()
          homeContentDatasArray[#homeContentDatasArray + 1] = contentData
        end
      end
    end
  end
  furnitures = self:GetClientFurnituresMap(houseIndex)
  for id, nFurniture in pairs(furnitures) do
    if not homeContentDatasMap[nFurniture.data.staticID] then
      homeContentDatasMap[nFurniture.data.staticID] = 1
      if not seriesType or SnowRealmProxy.Instance:CheckCategory(nFurniture.data.staticData, seriesType) then
        contentData = SnowRealmProxy.Instance:FindContentDataBySID(nFurniture.data.staticID, SnowRealmProxy.BuildType.Furniture)
        if contentData then
          contentData:RefreshStatus()
          homeContentDatasArray[#homeContentDatasArray + 1] = contentData
        end
      end
    end
  end
  local bagItems = BagProxy.Instance.bagMap[BagProxy.BagType.Furniture].wholeTab:GetItems()
  local singleItem
  for i = 1, #bagItems do
    singleItem = bagItems[i]
    if not homeContentDatasMap[singleItem.staticData.id] then
      homeContentDatasMap[singleItem.staticData.id] = 1
      if not seriesType or SnowRealmProxy.Instance:CheckCategory(singleItem:GetFurnitureSData(), seriesType) then
        contentData = SnowRealmProxy.Instance:FindContentDataBySID(singleItem.staticData.id, SnowRealmProxy.BuildType.Furniture)
        if contentData and contentData:CanShowInBuildView(true) then
          contentData:RefreshStatus()
          homeContentDatasArray[#homeContentDatasArray + 1] = contentData
        end
      end
    end
  end
  TableUtility.TableClear(homeContentDatasMap)
  return homeContentDatasArray
end

function SnowRealmManager:GetRenovationObjs(floorIndex, typeID, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  local objMap = self.nHomeMap[houseIndex].tabRenovationMap[floorIndex]
  objMap = objMap and objMap[typeID]
  if objMap then
    return objMap
  else
    LogUtility.Error("没有找到目标物体！楼层：%s，类型ID：%s", tostring(floorIndex), tostring(typeID))
  end
end

function SnowRealmManager:GetPlacedFurnitureCells(tag, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  return self.nHomeMap[houseIndex].buildingGrid:GetPlacedFurnitureCells(tag)
end

function SnowRealmManager:CalculateRotationCloseToNearestWall(staticID, posX, posZ, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  return self.nHomeMap[houseIndex].buildingGrid:CalculateRotationCloseToNearestWall(staticID, posX, posZ)
end

function SnowRealmManager:GetWorldPosYByXZ(floorIndex, posX, posZ, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  local row, col = self:ConvertWorldPositionToRowAndCol(floorIndex, posX, posZ, houseIndex)
  return self:GetWorldPosYByRowAndCol(floorIndex, row, col, houseIndex)
end

function SnowRealmManager:GetWorldPosYByRowAndCol(floorIndex, row, col, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  local posX, posY, posZ = self:GetWorldPosByRowAndCol(floorIndex, row, col, houseIndex)
  return posY
end

local luaVecDown = LuaVector3(0, -1, 0)

function SnowRealmManager:GetWorldPosByRowAndCol(floorIndex, row, col, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  local posX, posZ = self:ConvertRowAndColToWorldPosition(floorIndex, row, col, houseIndex)
  local floorHeightMap = self.nHomeMap[houseIndex].groundHeightCache[floorIndex]
  if not floorHeightMap then
    floorHeightMap = {}
    self.nHomeMap[houseIndex].groundHeightCache[floorIndex] = floorHeightMap
  end
  local rowHeightMap = floorHeightMap[row]
  if not rowHeightMap then
    rowHeightMap = {}
    floorHeightMap[row] = rowHeightMap
  end
  if rowHeightMap[col] then
    return posX, rowHeightMap[col], posZ
  end
  local vecOrigin = GetTempVector3(posX, self.nHomeMap[houseIndex].mapInfo[floorIndex].y + 10, posZ)
  local posY
  local curGroundHeight = self.nHomeMap[houseIndex].curGroundHeight or 0
  if curGroundHeight ~= 0 then
    self:ResetGroundHeight(0, houseIndex)
  end
  local isHit, hitInfo = Physics.Raycast(vecOrigin, luaVecDown, LuaOut, 10000, 1 << Game.ELayer.HomeGround)
  if isHit then
    posY = hitInfo.point.y
  else
    isHit, hitInfo = Physics.Raycast(vecOrigin, luaVecDown, LuaOut, 10000, 1 << Game.ELayer.HomeDefaultGround)
    if isHit then
      posY = hitInfo.point.y
    end
  end
  if not (hitInfo and hitInfo.collider) or tonumber(hitInfo.collider.name) ~= floorIndex then
    posY = self.nHomeMap[houseIndex].mapInfo[floorIndex].y
  end
  if curGroundHeight ~= 0 then
    self:ResetGroundHeight(curGroundHeight, houseIndex)
  end
  posY = posY + m_baseHeight
  rowHeightMap[col] = posY
  return posX, posY, posZ
end

function SnowRealmManager:ConvertWorldPositionToRowAndCol(floorIndex, posX, posZ, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  return self.nHomeMap[houseIndex].buildingGrid:ConvertWorldPositionToRowAndCol(floorIndex, posX, posZ)
end

function SnowRealmManager:GetCurHouseConfig()
  return self.curHouseConfig
end

function SnowRealmManager:MoveFurniture(nFurniture, floorIndex, currentRow, currentCol, currentRotation, deltaRow, deltaCol, closeToWall, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  return self.nHomeMap[houseIndex].buildingGrid:MoveFurniture(nFurniture.tag, nFurniture.staticID, floorIndex, currentRow, currentCol, currentRotation, deltaRow, deltaCol, closeToWall)
end

function SnowRealmManager:IsCellAvaliableTypeByPos(floorIndex, worldX, worldZ, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  return self.nHomeMap[houseIndex].buildingGrid:IsCellAvaliableTypeByPos(floorIndex, worldX, worldZ)
end

function SnowRealmManager:TryPutHomeStore(data, count)
  if data and not data:CanStorage(BagProxy.BagType.Home) then
    MsgManager.ShowMsgByID(38)
    return
  end
  self:TryCallHomeStoreOper(HomeCmd_pb.EFURNITUREOPER_PUTSTORE, data, count)
end

function SnowRealmManager:TryPutOffHomeStore(data, count)
  self:TryCallHomeStoreOper(HomeCmd_pb.EFURNITUREOPER_OFFSTORE, data, count)
end

function SnowRealmManager:TryCallHomeStoreOper(oper, data, count)
  if not oper or not data then
    LogUtility.Error("ArgumentNilException")
    return
  end
  if not self.workingHomeStore then
    LogUtility.Error("You're trying to put item of home store when there's no working home repository!")
    return
  end
  count = count or data.num or 1
  ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(oper, self.workingHomeStore.data.id, count, nil, data.id)
end

function SnowRealmManager:RemoveAllFurnitures()
  self.hasEditedFurnitureInThisEditSession = true
  ServiceHomeCmdProxy.Instance:CallFurnitureActionHomeCmd(HomeCmd_pb.EFURNITUREACTION_PUTOFFALL)
end

function SnowRealmManager:ArrivedAccessFurniture(nFurniture, custom)
  if self:IsInEditMode() or not self:IsAtHome() then
    return
  end
  if nFurniture.data.staticData.AccessType == SnowRealmManager.AccessType.NearBy then
    self:DirectUseFurniture(nFurniture)
    return
  end
  local functionList = self:GetFurnitureFunctionsList(nFurniture)
  if 0 < #functionList then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.FurnitureDialogView,
      viewdata = {nFurniture = nFurniture, functions = functionList}
    })
  end
end

function SnowRealmManager:DirectUseFurniture(nFurniture, functionData)
  functionData = functionData or self:GetFurnitureFunctionsList(nFurniture)[1]
  if functionData and functionData.status == FurnitureFuncState.Active then
    nFurniture:AccessStart()
    FunctionFurnitureFunc.Me():DoFurnitureFunc(functionData.functionStaticData, nFurniture, functionData.param)
  end
  self:ClearFurnitureFuncList()
end

function SnowRealmManager:GetRandomPosInCurrentHome(houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  if not houseIndex or houseIndex <= 0 then
    return nil
  end
  local mapInfo = self.nHomeMap[houseIndex].mapInfo
  if not mapInfo then
    local configName = "sc_xhzd_home_" .. tostring(houseIndex)
    pcall(function()
      autoImport(configName)
    end)
    mapInfo = _G[configName]
  end
  if not mapInfo then
    return nil
  end
  while true do
    local floor = mapInfo[1]
    local cellRow = math.random(1, floor.row)
    local cellCol = math.random(1, floor.col)
    local cellValue = BuildingGrid.GetCellData(nil, floor, cellRow, cellCol, 1)
    if BuildingGrid.IsEmptyOfCell(nil, cellValue) and BuildingGrid.GetTypeOfCell(nil, cellValue) == BuildingGrid.EBuildingCellType.EGround then
      local worldX = (cellCol - 0.5 - floor.col * 0.5) * BuildingGrid.m_CellSize + floor.x
      local worldY = floor.y
      local worldZ = (floor.row * 0.5 - cellRow + 0.5) * BuildingGrid.m_CellSize + floor.z
      return LuaVector3.New(worldX, worldY, worldZ)
    end
  end
end

function SnowRealmManager:GetRandomFurnitureByFurnitureType(itemType, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  local items = {}
  for k, v in pairs(self.nHomeMap[houseIndex].nFurnitureMap) do
    if v.data.itemStaticData.Type == itemType then
      table.insert(items, v)
    end
  end
  local count = #items
  if count == 0 then
    return nil
  else
    local index = math.random(1, count)
    return items[index]
  end
end

function SnowRealmManager:IsFurnitureNearWallSide(tag, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  return self.nHomeMap[houseIndex].buildingGrid:IsFurnitureNearWallSide(tag)
end

function SnowRealmManager:ClickFurniture(id, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  if self:IsInEditMode() or not self:IsAtHome() then
    return
  end
  local nFurniture = self:FindFurniture(id, nil, houseIndex)
  if not nFurniture then
    LogUtility.Error(string.format("Cannot find NFurniture by ID: %s", tostring(id)))
    return
  end
  local staticData = nFurniture.data.staticData
  if not staticData then
    redlog("没有找到StaticData!")
    return
  end
  if Game.Myself.data:IsTransformed() and staticData.id ~= 39002 and TableUtility.ArrayFindIndex(GameConfig.Home.trans_oper_forbid, nFurniture.data:GetItemType()) > 0 then
    MsgManager.ShowMsgByID(38014)
    return
  end
  local functionList = self:GetFurnitureFunctionsList(nFurniture)
  if #functionList < 1 then
    Game.Myself:Client_MoveTo(nFurniture:GetPosition())
    return
  end
  FunctionSystem.InterruptMyself()
  nFurniture:OnClick()
  if staticData.AccessType == SnowRealmManager.AccessType.Direct then
    self:DirectUseFurniture(nFurniture, functionList[1])
  elseif staticData.AccessType == SnowRealmManager.AccessType.LookAtSelect then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.FurnitureDialogView,
      viewdata = {nFurniture = nFurniture, functions = functionList}
    })
  else
    local accessRange = nFurniture.data:GetAccessRange()
    if VectorUtility.DistanceXZ_Square(nFurniture:GetPosition(), Game.Myself:GetPosition()) < accessRange * accessRange then
      self:ArrivedAccessFurniture(nFurniture)
    else
      Game.Myself:Client_AccessTarget(nFurniture, nil, nil, AccessCustomType.Furniture, accessRange)
    end
  end
end

function SnowRealmManager:CreateAreaTrigger()
  local areaRaidInfo = GameConfig.SnowRealm and GameConfig.SnowRealm.HouseRaid
  if not areaRaidInfo or not areaRaidInfo.RaidID then
    LogUtility.Error("没有找到雪花之地区域触发器！")
    self.areaTriggerId = nil
    return
  end
  local bpPointRange = areaRaidInfo.RaidID == Game.MapManager:GetMapID() and areaRaidInfo.RaidBpPointRange or areaRaidInfo.BpPointRange
  if bpPointRange and 4 <= #bpPointRange then
    local rectPos = {}
    for i = 1, 4 do
      local bp = Game.MapManager:FindBornPoint(bpPointRange[i])
      if not bp then
        LogUtility.Error("雪花之地区域触发器 BpPointRange 点位无效:", bpPointRange[i])
        self.areaTriggerId = nil
        return
      end
      rectPos[i] = {
        bp.position[1],
        bp.position[2],
        bp.position[3]
      }
    end
    local trigger = ReusableTable.CreateTable()
    trigger.id = areaRaidInfo.RaidID
    trigger.rectPos = rectPos
    
    function trigger.distanceCheck(trigger, myPos, pos2)
      return LuaGeometry.IsPointInRect_XZ(myPos, trigger.rectPos[1], trigger.rectPos[2], trigger.rectPos[3], trigger.rectPos[4])
    end
    
    trigger.type = AreaTrigger_Common_ClientType.SnowRealm_Area
    SceneTriggerProxy.Instance:Add(trigger)
    ReusableTable.DestroyTable(trigger)
    self.areaTriggerId = areaRaidInfo.RaidID
  else
    LogUtility.Error("没有找到雪花之地区域触发器（需 BpPointRange 四点）！")
    self.areaTriggerId = nil
  end
end

function SnowRealmManager:HandleEnterSnowRealmArea(trigger)
  redlog("HandleEnterSnowRealmArea", trigger)
  ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(PvpProxy.Type.SnowRealm)
end

function SnowRealmManager:HandleLeaveSnowRealmArea(trigger)
  redlog("HandleLeaveSnowRealmArea", trigger)
end

function SnowRealmManager:HandleRemoveSnowRealmArea(trigger)
  redlog("HandleRemoveSnowRealmArea", trigger)
end

function SnowRealmManager:CreateRoomTriggers()
  local fName = "Scene_" .. (self.curMapSData and self.curMapSData.NameEn or "")
  local sceneInfo = autoImport(fName)
  if not sceneInfo then
    return
  end
  local curMapID = Game.MapManager:GetMapID()
  local raidInfo = sceneInfo.Raids[curMapID] or nil
  local hps = raidInfo and raidInfo.hps or nil
  if not hps then
    return
  end
  for i = 1, #hps do
    local hp = hps[i]
    local trigger = ReusableTable.CreateTable()
    trigger.id = hp.ID
    trigger.rectPos = {
      hp.RectPos[1],
      hp.RectPos[2],
      hp.RectPos[3],
      hp.RectPos[4]
    }
    
    function trigger.distanceCheck(trigger, myPos, pos2)
      return LuaGeometry.IsPointInRect_XZ(myPos, trigger.rectPos[1], trigger.rectPos[2], trigger.rectPos[3], trigger.rectPos[4])
    end
    
    trigger.type = AreaTrigger_Common_ClientType.SnowRealm_Room
    SceneTriggerProxy.Instance:Add(trigger)
    ReusableTable.DestroyTable(trigger)
    self.roomTriggers[#self.roomTriggers + 1] = hp.ID
  end
end

function SnowRealmManager:HandleEnterSnowRealmRoom(trigger)
  redlog("HandleEnterSnowRealmRoom", trigger)
  if self.curHomeIdx ~= trigger then
    self.curHomeIdx = trigger
  end
  if HomePointManager.Instance then
    HomePointManager.Instance:SetInHome(trigger, true)
  end
end

function SnowRealmManager:HandleLeaveSnowRealmRoom(trigger)
  redlog("HandleLeaveSnowRealmRoom", trigger)
  if self.curHomeIdx == trigger then
    self.curHomeIdx = 0
    self.phonographManager:PauseMusic()
  end
  if HomePointManager.Instance then
    HomePointManager.Instance:SetInHome(trigger, false)
  end
end

function SnowRealmManager:HandleRemoveSnowRealmRoom(trigger)
  redlog("HandleRemoveSnowRealmRoom", trigger)
end

function SnowRealmManager:GetHomeName(mapName)
  local houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  return mapName .. "_home_" .. houseIndex
end

function SnowRealmManager:GetHomeConfig()
  return GameConfig.SnowRealm
end

function SnowRealmManager:ParseFurnitureToPbMsg(nFurniture)
  local tb
  if not NetConfig.PBC then
    tb = SceneItem_pb.Furniture()
    tb.guid = nFurniture.id
    tb.row = nFurniture.placeRow
    tb.col = nFurniture.placeCol
    tb.angle = nFurniture:GetRotationAngle()
    tb.floor = nFurniture.placeFloor
  else
    tb = {}
    tb.guid = nFurniture.id
    tb.row = nFurniture.placeRow
    tb.col = nFurniture.placeCol
    tb.angle = nFurniture:GetRotationAngle()
    tb.floor = nFurniture.placeFloor
  end
  return tb
end

function SnowRealmManager:PlaceFurniture(nFurniture, floorIndex, posX, posZ, angle, houseIndex)
  if nil == houseIndex then
    houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  end
  angle = angle or nFurniture:GetRotationAngle()
  local result, right, wrong, placeRow, placeCol = self.nHomeMap[houseIndex].buildingGrid:PlaceFurniture(nFurniture.tag, nFurniture.staticID, floorIndex, posX, posZ, angle)
  nFurniture:SetCurCell(floorIndex, placeRow, placeCol)
  return result, right, wrong, placeRow, placeCol
end

function SnowRealmManager:GetCameraMinPos(curMapID)
  local houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  if nil == houseIndex or houseIndex <= 0 then
    LogUtility.Error("houseIndex is nil or less than 0")
  end
  local mapInfo = self.nHomeMap[houseIndex].mapInfo[1]
  local offset = GameConfig.SnowRealm.CameraMinPosOffset[curMapID]
  if not mapInfo or not offset then
    LogUtility.Error("mapInfo or offset is nil")
  end
  return {
    mapInfo.x + offset[1],
    mapInfo.z + offset[2]
  }
end

function SnowRealmManager:GetCameraMaxPos(curMapID)
  local houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  if nil == houseIndex or houseIndex <= 0 then
    LogUtility.Error("houseIndex is nil or less than 0")
  end
  local mapInfo = self.nHomeMap[houseIndex].mapInfo[1]
  local offset = GameConfig.SnowRealm.CameraMaxPosOffset[curMapID]
  if not mapInfo or not offset then
    LogUtility.Error("mapInfo or offset is nil")
  end
  return {
    mapInfo.x + offset[1],
    mapInfo.z + offset[2]
  }
end

function SnowRealmManager:GetCameraStartPos(curMapID)
  local houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  if nil == houseIndex or houseIndex <= 0 then
    LogUtility.Error("houseIndex is nil or less than 0")
  end
  local mapInfo = self.nHomeMap[houseIndex].mapInfo[1]
  local offset = GameConfig.SnowRealm.CameraStartPosOffset[curMapID]
  if not mapInfo or not offset then
    LogUtility.Error("mapInfo or offset is nil")
  end
  return {
    mapInfo.x + offset[1],
    mapInfo.y + offset[2],
    mapInfo.z + offset[3]
  }
end

function SnowRealmManager:GetHomeSafePoint(creature)
  local mapId = Game.MapManager:GetMapID()
  local pos = GameConfig.SnowRealm.home_safe_point[mapId][creature.data.staticData.id]
  if pos == nil then
    local houseIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
    if nil == houseIndex or houseIndex <= 0 then
      pos = GameConfig.SnowRealm.home_safe_point[mapId].default_safe_pos
    end
    local mapInfo = self.nHomeMap[houseIndex].mapInfo and self.nHomeMap[houseIndex].mapInfo[1]
    if not mapInfo then
      local configName = "sc_xhzd_home_" .. tostring(houseIndex)
      pcall(function()
        autoImport(configName)
      end)
      local config = _G[configName]
      mapInfo = config and config[1]
    end
    if not mapInfo then
      LogUtility.Error("mapInfo or offset is nil")
    end
    pos = {
      mapInfo.x,
      mapInfo.y,
      mapInfo.z
    }
  end
  return pos
end

function SnowRealmManager:SetHomeState(houseIndex, empty)
  if HomePointManager.Instance then
    HomePointManager.Instance:SetHomeState(houseIndex, empty)
    redlog("SetHomeState", houseIndex, empty)
  end
end

function SnowRealmManager:GetCurHomeIdx()
  return self.curHomeIdx
end

function SnowRealmManager:IsSnowRealmMap(mapId)
  return true
end

function SnowRealmManager:CreateSceneEffect()
  local curMapID = Game.MapManager:GetMapID()
  local snowCfg = GameConfig.SnowRealm
  local effectPos = LuaVector3.Zero()
  if not self.sceneEffect then
    local sceneEffectCfg = snowCfg and snowCfg.SceneEffect
    if sceneEffectCfg and sceneEffectCfg.Effect then
      local areaRaidInfo = snowCfg and snowCfg.HouseRaid
      local bpPoint = areaRaidInfo and curMapID == areaRaidInfo.RaidID and sceneEffectCfg.RaidBp or sceneEffectCfg.BpPoint
      if bpPoint ~= nil then
        local bp = Game.MapManager:FindBornPoint(bpPoint)
        if bp then
          local path = "Common/" .. sceneEffectCfg.Effect
          LuaVector3.Better_Set(effectPos, bp.position[1], bp.position[2], bp.position[3])
          self.sceneEffect = Asset_Effect.PlayAt(path, effectPos)
        end
      end
    end
  end
  if not self.mvpBossRaidSceneEffect and curMapID == 155 then
    local mvpCfg = snowCfg and snowCfg.MVPBossRaidEffect
    if mvpCfg and mvpCfg.Effect and mvpCfg.BpPoint then
      local bp = Game.MapManager:FindBornPoint(mvpCfg.BpPoint)
      if bp then
        local effectName = mvpCfg.Effect
        local path = effectName
        if type(effectName) == "string" and string.sub(effectName, 1, 7) ~= "Common/" then
          path = "Common/" .. effectName
        end
        LuaVector3.Better_Set(effectPos, bp.position[1], bp.position[2], bp.position[3])
        self.mvpBossRaidSceneEffect = Asset_Effect.PlayAt(path, effectPos)
      end
    end
  end
end

function SnowRealmManager:DestroySceneEffect()
  if self.sceneEffect then
    self.sceneEffect:Destroy()
    self.sceneEffect = nil
  end
  if self.mvpBossRaidSceneEffect then
    self.mvpBossRaidSceneEffect:Destroy()
    self.mvpBossRaidSceneEffect = nil
  end
end

function SnowRealmManager:HandleQuerySnowHouseDataHomeCmd(serdata)
  local data = serdata.data
  local houseIndex = data and data.index
  if houseIndex and 0 < houseIndex then
    local homeData = self.nHomeMap[houseIndex]
    local objBuildRoot = homeData and homeData.objBuildRoot
    if objBuildRoot and not LuaGameObject.ObjectIsNull(objBuildRoot) then
      self:ResetRenovations(houseIndex)
    end
  end
  self:CreateMessageBoardEffect()
end

function SnowRealmManager:CreateMessageBoardEffect()
  self:DestroyMessageBoardEffect()
  local myHomeIndex = SnowRealmProxy.Instance:GetMySelfHomeIndex()
  if myHomeIndex and 0 < myHomeIndex then
    local configName = "sc_xhzd_home_" .. tostring(myHomeIndex)
    pcall(function()
      autoImport(configName)
    end)
    local mapInfo = _G[configName]
    local data = mapInfo and mapInfo[1]
    if data and data.x and data.y and data.z then
      do
        local path = EffectMap.Maps[GameConfig.SnowRealm and GameConfig.SnowRealm.MessageBoardEffect or ""]
        if path then
          local effect = Asset_Effect.PlayAtXYZ(path, data.x, data.y, data.z)
          self.messageBoardEffect = effect
        end
      end
    end
  end
end

function SnowRealmManager:DestroyMessageBoardEffect()
  if self.messageBoardEffect then
    self.messageBoardEffect:Destroy()
    self.messageBoardEffect = nil
  end
end

function SnowRealmManager:EnterEditModeUseNpcFunction()
  self.currentUseNpcFunction = true
  local myHomeIndex = SnowRealmProxy and SnowRealmProxy.Instance and SnowRealmProxy.Instance:GetMySelfHomeIndex()
  self:HandleEnterSnowRealmRoom(myHomeIndex)
  self:EnterEditMode()
end
