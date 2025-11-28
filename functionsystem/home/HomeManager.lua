autoImport("EventDispatcher")
autoImport("BuildingGrid")
autoImport("NFurniture")
autoImport("HomeFurniturOutLine")
autoImport("HomeCmd_pb")
autoImport("HomePhonographManager")
autoImport("HomeMagicBookManager")
autoImport("HomeSkadaManager")
HomeManager = class("HomeManager", EventDispatcher)
HomeManager.AccessType = {
  Direct = 1,
  NearBy = 2,
  LookAtSelect = 3,
  NearBySelect = 4,
  IsNPC = 10
}
local m_baseHeight = 0.001
local m_vecUp = LuaVector3.Up()

function HomeManager.Me()
  if nil == HomeManager.me then
    HomeManager.me = HomeManager.new()
  end
  return HomeManager.me
end

function HomeManager:ctor()
  self:Init()
end

local tmpVector3 = LuaVector3(0, 0, 0)
local GetTempVector3 = function(x, y, z, tarVector)
  tarVector = tarVector or tmpVector3
  LuaVector3.Better_Set(tarVector, x, y, z)
  return tarVector
end

function HomeManager:Init()
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
  self.nFurnitureMap = {}
  self.nFurnitureClientMap = {}
  self.relativeCreatureMap = {}
  self.destroyList = {}
  self.groundHeightCache = {}
  self.tabRenovationMap = {}
  self.tabWalls = {}
  self.tabLogicWalls = {}
  self.tmpDataList = {}
  self.phonographManager = HomePhonographManager.new()
  self.magicBookManager = HomeMagicBookManager.new()
  self.skadaManager = HomeSkadaManager.Me()
  EventManager.Me():AddEventListener(HomeWallPicManager.WallPicThumbnailDownloadCompleteCallback, self.PhotoAlbumCompleteCallback, self)
end

function HomeManager:Launch()
  self:Shutdown()
  local homeMapConfig = GameConfig.Home and GameConfig.Home.MapDatas
  local curMapID = Game.MapManager:GetMapID()
  self.curHouseConfig = homeMapConfig and homeMapConfig[curMapID]
  if self.curHouseConfig then
    self.curMapSData = Table_Map[curMapID]
    self.curAtHome = true
    self:InitHomeScene(self.curMapSData.NameEn)
    GameFacade.Instance:sendNotification(HomeEvent.EnterHome)
    EventManager.Me():DispatchEvent(HomeEvent.EnterHome)
    GameFacade.Instance:sendNotification(MainViewEvent.AddDungeonInfoBord, "MainViewSkadaInfoPage")
  end
end

function HomeManager:Shutdown()
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
  self.curBlurPrintData = nil
  self.bpFinishNumMap = nil
  self.clientPrepareBuild = false
  self.curMapSData = nil
  self.curHouseConfig = nil
  self.mapInfo = nil
  self.maxFloorIndex = nil
  self.curGardenHouseID = nil
  self.phonographManager:Shutdown()
end

function HomeManager:_ExitHome()
  self:ClearClientFurnitures(true)
  self:ClearFurnitures(true)
  self:ClearFurnitureFuncList()
  self:ClearRenovationMap()
  self:ClearWallMaps()
  TableUtility.TableClear(self.groundHeightCache)
  TableUtility.TableClear(self.tmpDataList)
  TableUtility.TableClear(self.destroyList)
  self.objRoof = nil
  self.objBuildRoot = nil
  self.tsfFurnituresRoot = nil
  self.tsfGroundColliderRoot = nil
  self.buildingGrid = nil
  HomeProxy.Instance:ClearDatas()
  Game.AssetManager_Furniture:ClearCache()
  Game.GCSystemManager:Collect()
  GameFacade.Instance:sendNotification(HomeEvent.ExitHome)
  EventManager.Me():DispatchEvent(HomeEvent.ExitHome)
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
  GameFacade.Instance:sendNotification(MainViewEvent.RemoveDungeonInfoBord, "MainViewSkadaInfoPage")
end

function HomeManager:InitHomeScene(sceneName)
  self:ClearClientFurnitures(true)
  self:ClearFurnitures(true)
  TableUtility.TableClear(self.groundHeightCache)
  pcall(function()
    autoImport(sceneName)
  end)
  self.mapInfo = _G[sceneName]
  if not self.mapInfo then
    LogUtility.Error(string.format("没有找到场景%s的建造区域数据，无法创建家具或进入建造模式。", tostring(sceneName)))
    return
  end
  self.buildingGrid = BuildingGrid.new(self.mapInfo)
  for id, data in pairs(Table_HomeFurniture) do
    self.buildingGrid:RegisterFurnitureData(data.id, data.Row, data.Col, data.BeginHeight, data.EndHeight, data.FixedPlanes, data.AlternativePlanes, data.NormalType)
  end
  self:FindAndCreateSceneObjs()
  self:GenerateRenovationMap()
  self:CreateGroundColliders()
  self:ResetRenovations()
  self:CreateCurrentFurnitures()
  local curHouseData = HomeProxy.Instance:GetCurHouseData()
  if curHouseData then
    FloatingPanel.Instance:ShowMapName(curHouseData.name, curHouseData.sign)
  end
  self:CreateRandomGiftCell()
end

function HomeManager:FindAndCreateSceneObjs()
  self.objBuildRoot = GameObject.Find("Furniture")
  if not self.objBuildRoot then
    LogUtility.Error("没有找到家园场景的根节点\"Furniture\"，无法创建家具或进入建造模式。")
    return
  end
  self.tsfFurnituresRoot = self:FindOrCreateTransform("NFurnituresRoot", self.objBuildRoot)
  self.tsfFurnituresRoot.parent = nil
  self.tsfFurnituresRoot.position = LuaGeometry.GetTempVector3(0, 0, 0)
  self.tsfGroundColliderRoot = self:FindOrCreateTransform("GroundColliderParent", self.objBuildRoot)
  self.tsfGroundColliderRoot.parent = nil
  self.tsfGroundColliderRoot.position = LuaGeometry.GetTempVector3(0, 0, 0)
  self.tsfDestroyFurnitureRoot = self:FindOrCreateTransform("DestroyFurnitureRoot", self.objBuildRoot)
  self.tsfDestroyFurnitureRoot.gameObject:SetActive(false)
  local l_objHouseModelRoot = Game.GameObjectUtil:DeepFind(self.objBuildRoot, "HouseModelRoot")
  self.tsfHouseModelRoot = l_objHouseModelRoot and l_objHouseModelRoot.transform
  self:ReloadHouseModel()
  self.objRoof = Game.GameObjectUtil:DeepFind(self.objBuildRoot, "Roof")
  self:InitWalls()
end

function HomeManager:InitWalls()
  self:ClearWallMaps()
  local tsfWallsRoot, tsfParent, floorName, startPos, floorIndex, wallName, wallConfigID, tsfFloor, tsfWall, vecPos, vecForward, wallData, floorWallMap, logicFloorWallMap
  local l_objWallsRoot = Game.GameObjectUtil:DeepFind(self.objBuildRoot, "Hidden_Wall")
  if l_objWallsRoot then
    tsfWallsRoot = l_objWallsRoot.transform
    for i = 0, tsfWallsRoot.childCount - 1 do
      tsfParent = tsfWallsRoot:GetChild(i)
      for j = 0, tsfParent.childCount - 1 do
        tsfFloor = tsfParent:GetChild(j)
        floorName = tsfFloor.name
        startPos = string.find(string.reverse(floorName), "_")
        floorIndex = startPos and tonumber(string.sub(floorName, string.len(floorName) - startPos + 2, string.len(floorName)))
        floorWallMap = self.tabWalls[floorIndex]
        if not floorWallMap then
          floorWallMap = {}
          self.tabWalls[floorIndex] = floorWallMap
        end
        logicFloorWallMap = self.tabLogicWalls[floorIndex]
        if not logicFloorWallMap then
          logicFloorWallMap = {}
          self.tabLogicWalls[floorIndex] = logicFloorWallMap
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
            visibleConfig = Table_HomeWallVisibleConfig[wallConfigID] or self.wallVisibleDefaultConfig,
            activeSelf = true
          }
          floorWallMap[#floorWallMap + 1] = wallData
          if not string.find(wallName, "Pillar") then
            wallData.id = self.buildingGrid:GetWallId(floorIndex, vecPos.x, vecPos.z)
            logicFloorWallMap[wallData.id] = wallData
          end
        end
      end
    end
  end
  local l_objUnHiddenWall = Game.GameObjectUtil:DeepFind(self.objBuildRoot, "UnHidden_Wall")
  if l_objUnHiddenWall then
    tsfWallsRoot = l_objUnHiddenWall.transform
    for i = 0, tsfWallsRoot.childCount - 1 do
      tsfParent = tsfWallsRoot:GetChild(i)
      for j = 0, tsfParent.childCount - 1 do
        tsfFloor = tsfParent:GetChild(j)
        floorName = tsfFloor.name
        startPos = string.find(string.reverse(floorName), "_")
        floorIndex = startPos and tonumber(string.sub(floorName, string.len(floorName) - startPos + 2, string.len(floorName)))
        logicFloorWallMap = self.tabLogicWalls[floorIndex]
        if not logicFloorWallMap then
          logicFloorWallMap = {}
          self.tabLogicWalls[floorIndex] = logicFloorWallMap
        end
        for x = 0, tsfFloor.childCount - 1 do
          tsfWall = tsfFloor:GetChild(x)
          if not string.find(tsfWall.name, "Pillar") then
            vecPos = LuaVector3(LuaGameObject.GetPosition(tsfWall))
            vecForward = tsfWall.forward
            wallData = {
              id = self.buildingGrid:GetWallId(floorIndex, vecPos.x, vecPos.z),
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

function HomeManager:ClearWallMaps()
  for floorIndex, floorMap in pairs(self.tabWalls) do
    for index, wallData in pairs(floorMap) do
      TableUtility.TableClear(wallData)
    end
  end
  TableUtility.TableClear(self.tabWalls)
  for floorIndex, floorMap in pairs(self.tabLogicWalls) do
    for wallID, wallData in pairs(floorMap) do
      TableUtility.TableClear(wallData)
    end
  end
  TableUtility.TableClear(self.tabLogicWalls)
end

function HomeManager:FindOrCreateTransform(name, objParent)
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

function HomeManager:ReloadHouseModel()
  if not self:IsAtHome() or not self.tsfHouseModelRoot then
    return
  end
  local curHouseData = HomeProxy.Instance:GetCurHouseData()
  local newGardenHouseID = curHouseData and curHouseData:GetGardenHouseID()
  if not newGardenHouseID or self.curGardenHouseID == newGardenHouseID then
    return
  end
  if self.objHouseModel then
    self:_AddObjToDestroyList(self.objHouseModel)
  end
  self.curGardenHouseID = newGardenHouseID
  Game.AssetManager_Furniture:CreateGardenHouse(self.curGardenHouseID, self.tsfHouseModelRoot, function(obj)
    self.objHouseModel = obj
  end)
end

function HomeManager:GenerateRenovationMap()
  self:ClearRenovationMap()
  self.maxFloorIndex = 0
  local renovationTypes = ReusableTable.CreateTable()
  local renovationDatas = HomeProxy.Instance:GetBuidingDatas(HomeProxy.BuildType.Renovation)
  for typeID, datas in pairs(renovationDatas) do
    renovationTypes[typeID] = Table_FurnitureType[typeID].Type
  end
  local meshRenderers = Game.GameObjectUtil:DeepFind(self.objBuildRoot, "RenovationRoot"):GetComponentsInChildren(MeshRenderer, true)
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
        if floorIndex > self.maxFloorIndex then
          self.maxFloorIndex = floorIndex
        end
        tabFloorDatas = self.tabRenovationMap[floorIndex]
        if not tabFloorDatas then
          tabFloorDatas = {}
          self.tabRenovationMap[floorIndex] = tabFloorDatas
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
        if self:IsRenovationTypeDivideByPos(typeID) then
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

function HomeManager:ClearRenovationMap()
  for floorIndex, floorData in pairs(self.tabRenovationMap) do
    for typeID, typeData in ipairs(floorData) do
      for index, matData in pairs(typeData) do
        TableUtility.TableClear(matData)
      end
    end
  end
  TableUtility.TableClear(self.tabRenovationMap)
end

function HomeManager:CreateGroundColliders()
  self:ResetGroundHeight(0)
  local l_objFloorModel = Game.GameObjectUtil:DeepFind(self.objBuildRoot, "Floor")
  if not l_objFloorModel then
    LogUtility.Error("未找到地板模型'Floor'，请检查场景模型结构")
    return
  end
  local l_objGroundColliderRoot = GameObject.Instantiate(l_objFloorModel, self.tsfGroundColliderRoot, true)
  local mrGrounds = l_objGroundColliderRoot:GetComponentsInChildren(MeshRenderer, true)
  local objGround, floorName, startPos, floorIndex
  for i = 1, #mrGrounds do
    objGround = mrGrounds[i].gameObject
    if string.find(objGround.name, "NotGround") then
      objGround:SetActive(false)
    else
      floorName = objGround.transform.parent.name
      startPos = string.find(string.reverse(floorName), "_")
      floorIndex = tonumber(string.sub(floorName, string.len(floorName) - startPos + 2, string.len(floorName)))
      objGround.name = floorIndex
      objGround.gameObject.layer = Game.ELayer.HomeGround
      objGround:AddComponent(MeshCollider)
      mrGrounds[i].enabled = false
    end
  end
  local info = self.mapInfo[1]
  objGround = GameObject()
  local tsfDefaultGround = objGround.transform
  objGround.name = "0"
  objGround.layer = Game.ELayer.HomeDefaultGround
  tsfDefaultGround.position = GetTempVector3(info.x, info.y, info.z)
  local collider = objGround:AddComponent(BoxCollider)
  collider.size = GetTempVector3(4096, 0.1, 4096)
  collider.isTrigger = true
  tsfDefaultGround.parent = self.tsfGroundColliderRoot
end

function HomeManager:CreateCurrentFurnitures()
  local furnitureDatas = HomeProxy.Instance:GetFurnitureDatas()
  for id, nFurnitureData in pairs(furnitureDatas) do
    self:UpdateFurniture(nFurnitureData)
  end
end

function HomeManager:IsAtHome()
  return self.curAtHome == true
end

function HomeManager:IsAtMyselfHome()
  return self:IsAtHome() and HomeProxy.Instance:IsServerAtMyselfHome()
end

function HomeManager:GetCurMapSData()
  return self.curMapSData
end

function HomeManager:GetCurHouseConfig()
  return self.curHouseConfig
end

function HomeManager:GetCurMaxFloorIndex()
  return self.maxFloorIndex or 0
end

function HomeManager:EnterEditMode()
  if not self:IsAtMyselfHome() then
    MsgManager.ShowMsgByID(38010)
    return
  end
  self.clientPrepareBuild = true
  if HomeManager.ClientTest then
    self:EnterEditMode_Server()
    return
  end
  ServiceHomeCmdProxy.Instance:CallHouseActionHomeCmd(HomeCmd_pb.EHOUSEACTION_EDIT_MODE)
end

function HomeManager:EnterEditMode_Server()
  if not (self.clientPrepareBuild and self:IsAtMyselfHome()) or self:IsInEditMode() then
    return
  end
  if not HomeManager.ClientTest and not HomeProxy.Instance:IsServerInEditMode() then
    return
  end
  FunctionSystem.InterruptMyself()
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.HomeBuildingView
  })
  self.isInEditMode = true
  self.clientPrepareBuild = false
  if self.objRoof then
    self.objRoof:SetActive(false)
  end
  self:ResetGroundHeight(0)
  local furnitures = self:GetFurnituresMap()
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
  local feedingPets = HomeProxy.Instance:GetCurFeedingPet()
  if nil ~= feedingPets then
    for _, pet in ipairs(feedingPets) do
      stopPatrol(pet)
    end
  end
  FunctionPet.Me():PetGiftActiveSelf(false)
end

function HomeManager:ExitEditMode()
  self.isInEditMode = false
  self.curBlurPrintData = nil
  self.bpFinishNumMap = nil
  if not LuaGameObject.ObjectIsNull(self.objBuildRoot) then
    if self.objRoof then
      self.objRoof:SetActive(true)
    end
    self:ResetWallsAndPillarsStatus()
    self:ResetGroundHeight(0)
    self:ResetClientFurnitures(true)
    self:ResetRenovations()
    local furnitures = self:GetFurnituresMap()
    for id, nFurniture in pairs(furnitures) do
      nFurniture:SetColliderLayer(nFurniture:HaveFunction() and Game.ELayer.Accessable or Game.ELayer.Default)
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
      local mapId = Game.MapManager:GetMapID()
      local pos = GameConfig.Home.home_safe_point[mapId][creature.data.staticData.id]
      if pos == nil then
        pos = GameConfig.Home.home_safe_point[mapId].default_safe_pos
      end
      creature.logicTransform:PlaceTo(LuaVector3(pos[1], pos[2], pos[3]))
    end
  end
  local npcs = NSceneNpcProxy.Instance:GetAll()
  for _, npc in pairs(npcs) do
    resumePatrol(npc)
  end
  local feedingPets = HomeProxy.Instance:GetCurFeedingPet()
  if nil ~= feedingPets then
    for _, pet in ipairs(feedingPets) do
      resumePatrol(pet)
    end
  end
  FunctionPet.Me():PetGiftActiveSelf(true)
  self.phonographManager:ExitEditMode()
  self.magicBookManager:ExitEditMode()
end

function HomeManager:IsInEditMode()
  return self:IsAtMyselfHome() and self.isInEditMode == true
end

function HomeManager:IsBluePrintMode()
  return self:IsInEditMode() and self.curBlurPrintData ~= nil
end

function HomeManager:SetBluePrintMode(bluePrintData)
  if not self:IsInEditMode() then
    return
  end
  self.curBlurPrintData = bluePrintData
  if not bluePrintData then
    self.bpFinishNumMap = nil
  end
end

function HomeManager:SetBluePrintFinishNumMap(bpFinishNumMap)
  self.bpFinishNumMap = bpFinishNumMap
end

function HomeManager:GetBluePrintFurnitureFinishedNum(staticID)
  local num = self.bpFinishNumMap and self.bpFinishNumMap[staticID]
  return num or 0
end

function HomeManager:GetCurBluePrintData()
  return self.curBlurPrintData
end

local dataTypesArray = {}

function HomeManager:GetDataTypesArray(buildType, seriesType)
  TableUtility.ArrayClear(dataTypesArray)
  if not buildType or not seriesType then
    LogUtility.Error("类型为空，不能取得数据")
    return dataTypesArray
  end
  local typeDatas, homeContentDatas
  if buildType == HomeProxy.BuildType.Furniture then
    typeDatas = HomeProxy.Instance:GetDatasByType(buildType, seriesType)
    homeContentDatas = typeDatas
  else
    typeDatas = self.tabRenovationMap[seriesType]
    homeContentDatas = HomeProxy.Instance:GetDatasByType(buildType)
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

local homeContentDatasArray = {}

function HomeManager:GetHomeContentDatasArray(buildType, seriesType, dataType)
  TableUtility.ArrayClear(homeContentDatasArray)
  if not (buildType and seriesType) or not dataType then
    LogUtility.Error("类型为空，不能取得数据")
    return homeContentDatasArray
  end
  local homeContentDatas
  if buildType == HomeProxy.BuildType.Furniture then
    if dataType == GameConfig.Home.SpecialType_Owned then
      return self:GetOwnedFurniureContentDatasArray(seriesType)
    end
    homeContentDatas = HomeProxy.Instance:GetDatasByType(buildType, seriesType, dataType)
  else
    homeContentDatas = HomeProxy.Instance:GetDatasByType(buildType, dataType)
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

function HomeManager:GetHomeContentDatasArrayByName(name)
  TableUtility.TableClear(homeContentDatasMap)
  TableUtility.ArrayClear(homeContentDatasArray)
  local furnitureDatas = HomeProxy.Instance:GetDatasByType(HomeProxy.BuildType.Furniture, HomeProxy.FurnitureSpecialCatagory.All)
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

function HomeManager:GetOwnedFurniureContentDatasArray(seriesType)
  TableUtility.TableClear(homeContentDatasMap)
  TableUtility.ArrayClear(homeContentDatasArray)
  local contentData
  local furnitures = self:GetFurnituresMap()
  for id, nFurniture in pairs(furnitures) do
    if nFurniture.data and not homeContentDatasMap[nFurniture.data.staticID] then
      homeContentDatasMap[nFurniture.data.staticID] = 1
      if not seriesType or HomeProxy.Instance:CheckCategory(nFurniture.data.staticData, seriesType) then
        contentData = HomeProxy.Instance:FindContentDataBySID(nFurniture.data.staticID, HomeProxy.BuildType.Furniture)
        if contentData then
          contentData:RefreshStatus()
          homeContentDatasArray[#homeContentDatasArray + 1] = contentData
        end
      end
    end
  end
  furnitures = self:GetClientFurnituresMap()
  for id, nFurniture in pairs(furnitures) do
    if not homeContentDatasMap[nFurniture.data.staticID] then
      homeContentDatasMap[nFurniture.data.staticID] = 1
      if not seriesType or HomeProxy.Instance:CheckCategory(nFurniture.data.staticData, seriesType) then
        contentData = HomeProxy.Instance:FindContentDataBySID(nFurniture.data.staticID, HomeProxy.BuildType.Furniture)
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
      if not seriesType or HomeProxy.Instance:CheckCategory(singleItem:GetFurnitureSData(), seriesType) then
        contentData = HomeProxy.Instance:FindContentDataBySID(singleItem.staticData.id, HomeProxy.BuildType.Furniture)
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

function HomeManager:GetFurnituresMap()
  return self.nFurnitureMap
end

function HomeManager:GetClientFurnituresMap()
  return self.nFurnitureClientMap
end

function HomeManager:GetWorldRootObj()
  return self.objBuildRoot
end

function HomeManager:GetFurnitureRootTransform()
  return self.tsfFurnituresRoot
end

function HomeManager:GetDefaultMatIDByType(typeID, isTry)
  local matConfig = GameConfig.HomeRenovationDefaultMat[typeID]
  if not matConfig then
    if not isTry then
      LogUtility.Error(string.format("没有在GameConfig.HomeRenovationDefaultMat中找到装潢类型: %s的默认材质id，请检查配置！", tostring(typeID)))
    end
    return
  end
  return self.curMapSData and matConfig[self.curMapSData.id] or matConfig.default
end

function HomeManager:ResetGroundHeight(height)
  local pos = self.tsfGroundColliderRoot.position
  pos.y = height or 0
  self.tsfGroundColliderRoot.position = pos
  self.curGroundHeight = height
end

local vecObjToMe = LuaVector3(0, 0, 0)

function HomeManager:ProcessWallsAndPillarsShow(cameraPosX, cameraPosY, cameraPosZ)
  local isWallStatusChanged = false
  local cameraPos = GetTempVector3(cameraPosX, cameraPosY, cameraPosZ)
  local angle, visibleConfig, isActive
  for floorIndex, floorWallMap in pairs(self.tabWalls) do
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

function HomeManager:ResetWallsAndPillarsStatus()
  for floorIndex, floorWallMap in pairs(self.tabWalls) do
    for id, wall in pairs(floorWallMap) do
      if not wall.activeSelf then
        wall.gameObject:SetActive(true)
        wall.activeSelf = true
      end
    end
  end
end

function HomeManager:GetRenovationMap()
  return self.tabRenovationMap
end

function HomeManager:GetMapInfo()
  return self.mapInfo
end

function HomeManager:GetGroundHeightByPos(vecOrigin, floorIndex)
  local curGroundHeight = self.curGroundHeight or 0
  if curGroundHeight ~= 0 then
    self:ResetGroundHeight(0)
  end
  local hitInfos = Physics.RaycastAll(vecOrigin, luaVecDown, 10000, 1 << Game.ELayer.HomeGround)
  local singleHitInfo, height
  for i = 1, #hitInfos do
    singleHitInfo = hitInfos[i]
    if singleHitInfo.collider.name == floorIndex then
      height = singleHitInfo.point.y
      break
    end
  end
  if not height then
    local isHit, hitInfo = Physics.Raycast(vecOrigin, luaVecDown, LuaOut, 10000, 1 << Game.ELayer.HomeDefaultGround)
    if isHit then
      height = hitInfo.point.y
    end
  end
  height = height or self.mapInfo[floorIndex].y
  if curGroundHeight ~= 0 then
    self:ResetGroundHeight(curGroundHeight)
  end
  return height
end

local luaVecDown = LuaVector3(0, -1, 0)

function HomeManager:GetWorldPosByRowAndCol(floorIndex, row, col)
  local posX, posZ = self:ConvertRowAndColToWorldPosition(floorIndex, row, col)
  local floorHeightMap = self.groundHeightCache[floorIndex]
  if not floorHeightMap then
    floorHeightMap = {}
    self.groundHeightCache[floorIndex] = floorHeightMap
  end
  local rowHeightMap = floorHeightMap[row]
  if not rowHeightMap then
    rowHeightMap = {}
    floorHeightMap[row] = rowHeightMap
  end
  if rowHeightMap[col] then
    return posX, rowHeightMap[col], posZ
  end
  local vecOrigin = GetTempVector3(posX, self.mapInfo[floorIndex].y + 10, posZ)
  local posY
  local curGroundHeight = self.curGroundHeight or 0
  if curGroundHeight ~= 0 then
    self:ResetGroundHeight(0)
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
  if not hitInfo or tonumber(hitInfo.collider.name) ~= floorIndex then
    posY = self.mapInfo[floorIndex].y
  end
  if curGroundHeight ~= 0 then
    self:ResetGroundHeight(curGroundHeight)
  end
  posY = posY + m_baseHeight
  rowHeightMap[col] = posY
  return posX, posY, posZ
end

function HomeManager:GetWorldPosYByRowAndCol(floorIndex, row, col)
  local posX, posY, posZ = self:GetWorldPosByRowAndCol(floorIndex, row, col)
  return posY
end

function HomeManager:GetWorldPosYByXZ(floorIndex, posX, posZ)
  return self:GetWorldPosYByRowAndCol(floorIndex, self:ConvertWorldPositionToRowAndCol(floorIndex, posX, posZ))
end

function HomeManager:AddFurnitureItem(nFurniture)
  self.nFurnitureMap[nFurniture.data.id] = nil
  self.nFurnitureClientMap[nFurniture.data.id] = nFurniture
end

function HomeManager:ConfirmPlaceFurniture(nFurniture)
  if HomeManager.ClientTest then
    nFurniture:PlaceOnCurCell()
    self.nFurnitureMap[nFurniture.data.id] = nFurniture
    self.nFurnitureClientMap[nFurniture.data.id] = nil
    return
  end
  if nFurniture:IsMoved() or not nFurniture.data:IsServerInited() then
    self:AddFurnitureItem(nFurniture)
    nFurniture:PlaceOnCurCell()
    nFurniture.assetFurniture:SetAlpha(0.5)
    nFurniture.assetFurniture:SetColliderEnable(false)
    local tmpArray = ReusableTable.CreateArray()
    tmpArray[#tmpArray + 1] = self:ParseFurnitureToPbMsg(nFurniture)
    local action = nFurniture.data:IsServerInited() and HomeCmd_pb.EFURNITUREACTION_EDIT or HomeCmd_pb.EFURNITUREACTION_PUTON
    ServiceHomeCmdProxy.Instance:CallFurnitureActionHomeCmd(action, tmpArray)
    ReusableTable.DestroyAndClearArray(tmpArray)
  else
    self.nFurnitureMap[nFurniture.data.id] = nFurniture
    self.nFurnitureClientMap[nFurniture.data.id] = nil
  end
end

function HomeManager:ManualCall(action, items)
  local msg = HomeCmd_pb.FurnitureActionHomeCmd()
  if action ~= nil then
    msg.action = action
  end
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
  ServiceHomeCmdProxy.Instance:SendProto(msg)
end

function HomeManager:FindFurniture(id, includeClientFurniture)
  local nFurniture = self.nFurnitureMap[id]
  if not nFurniture and includeClientFurniture then
    nFurniture = self.nFurnitureClientMap[id]
  end
  if nFurniture and not nFurniture.inited and not includeClientFurniture then
    return
  end
  return nFurniture
end

function HomeManager:FindFurnituresByStaticID(staticID, includeClientFurniture)
  TableUtility.TableClear(self.tmpDataList)
  local furnitures = self:GetFurnituresMap()
  for id, nFurniture in pairs(furnitures) do
    if nFurniture.data.staticID == staticID then
      self.tmpDataList[#self.tmpDataList + 1] = nFurniture
    end
  end
  if not includeClientFurniture then
    return self.tmpDataList
  end
  furnitures = self:GetClientFurnituresMap()
  for id, nFurniture in pairs(furnitures) do
    if nFurniture.data.staticID == staticID then
      self.tmpDataList[#self.tmpDataList + 1] = nFurniture
    end
  end
  return self.tmpDataList
end

function HomeManager:GetFurnituresIDListByStaticID(staticID, includeClientFurniture)
  TableUtility.TableClear(self.tmpDataList)
  local furnitures = self:GetFurnituresMap()
  for id, nFurniture in pairs(furnitures) do
    if nFurniture.data.staticID == staticID then
      self.tmpDataList[#self.tmpDataList + 1] = id
    end
  end
  if not includeClientFurniture then
    return self.tmpDataList
  end
  furnitures = self:GetClientFurnituresMap()
  for id, nFurniture in pairs(furnitures) do
    if nFurniture.data.staticID == staticID then
      self.tmpDataList[#self.tmpDataList + 1] = id
    end
  end
  return self.tmpDataList
end

function HomeManager:RemoveAllFurnitures()
  if HomeManager.ClientTest then
    self:ClearFurnitures(true)
    self:ClearClientFurnitures(true)
    return
  end
  ServiceHomeCmdProxy.Instance:CallFurnitureActionHomeCmd(HomeCmd_pb.EFURNITUREACTION_PUTOFFALL)
end

function HomeManager:RemoveFurnitureItems(ids, force)
  local tmpArray = ReusableTable.CreateArray()
  local singleID, nFurniture, pbFurniture
  for i = 1, #ids do
    singleID = ids[i]
    nFurniture = self:FindFurniture(singleID, true)
    if nFurniture then
      if not nFurniture.data:IsServerInited() or HomeManager.ClientTest then
        self:RemoveFurnitureItem_Server(singleID)
      else
        self.nFurnitureClientMap[singleID] = nFurniture
        self.nFurnitureMap[singleID] = nil
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
    ServiceHomeCmdProxy.Instance:CallFurnitureActionHomeCmd(HomeCmd_pb.EFURNITUREACTION_PUTOFF, tmpArray, force)
  end
  ReusableTable.DestroyAndClearArray(tmpArray)
end

function HomeManager:RemoveFurnitureItem(id, force)
  local tmpArray = ReusableTable.CreateArray()
  tmpArray[#tmpArray + 1] = id
  self:RemoveFurnitureItems(tmpArray, force)
  ReusableTable.DestroyAndClearArray(tmpArray)
end

function HomeManager:FurnitureItemPlaceFailed(id, msg)
  self:RemoveFurnitureItem(id, true)
end

function HomeManager:RemoveFurnitureItem_Server(id)
  local nFurniture = self:FindFurniture(id, true)
  self:_DestroyFurniture(nFurniture)
  self.nFurnitureMap[id] = nil
  self.nFurnitureClientMap[id] = nil
end

function HomeManager:_DestroyFurniture(nFurniture)
  if not nFurniture then
    return
  end
  self:_DestroyFurnitureInteract(nFurniture)
  local insID = nFurniture:GetInstanceID()
  if insID then
    HomeFurniturOutLine.Me():RemoveTarget(insID)
  end
  self:RemoveFurnitureFromGrid(nFurniture.tag)
  nFurniture:Destroy(true)
end

function HomeManager:_DestroyFurnitureInteract(nFurniture)
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
  local feedingPets = HomeProxy.Instance:GetCurFeedingPet()
  if nil ~= feedingPets then
    for _, pet in ipairs(feedingPets) do
      stopPatrol(pet)
    end
  end
end

function HomeManager:ClearFurnitures(includeOperateFurniture)
  for id, nFurniture in pairs(self.nFurnitureMap) do
    if not (not includeOperateFurniture and nFurniture) or not nFurniture.isSelect then
      self:_DestroyFurniture(nFurniture)
      self.nFurnitureMap[id] = nil
    end
  end
end

function HomeManager:ResetClientFurnitures(includeOperateFurniture)
  local tmpArray = ReusableTable.CreateTable()
  for id, nFurniture in pairs(self.nFurnitureClientMap) do
    if not (not includeOperateFurniture and nFurniture) or not nFurniture.isSelect then
      if nFurniture and nFurniture.data:IsServerInited() then
        tmpArray[#tmpArray + 1] = nFurniture.data
      else
        self:_DestroyFurniture(nFurniture)
        self.nFurnitureClientMap[id] = nil
      end
    end
  end
  for id, nFurnitureData in pairs(tmpArray) do
    self:UpdateFurniture(nFurnitureData)
  end
  ReusableTable.DestroyAndClearTable(tmpArray)
end

function HomeManager:ClearClientFurnitures(includeOperateFurniture)
  for id, nFurniture in pairs(self.nFurnitureClientMap) do
    if not (not includeOperateFurniture and nFurniture) or not nFurniture.isSelect then
      self:_DestroyFurniture(nFurniture)
      self.nFurnitureClientMap[id] = nil
    end
  end
end

function HomeManager:ResetRenovations()
  if not self:IsAtHome() or self:IsInEditMode() then
    return
  end
  local curHouseData = HomeProxy.Instance:GetCurHouseData()
  local renovationMap = self:GetRenovationMap()
  local targetMaterialID
  for floorIndex, floorMap in pairs(renovationMap) do
    for typeID, typeMap in pairs(floorMap) do
      if self:IsRenovationTypeDivideByPos(typeID) then
      else
        targetMaterialID = curHouseData and curHouseData:GetRenovationMaterialID(floorIndex, typeID) or self:GetDefaultMatIDByType(typeID)
        self:ChangeObjMaterial(targetMaterialID, floorIndex)
      end
    end
  end
end

function HomeManager:UpdateRenovation(floorIndex)
  if not self:IsAtHome() or self:IsInEditMode() then
    return
  end
  local curHouseData = HomeProxy.Instance:GetCurHouseData()
  if not curHouseData then
    return
  end
  local serverRenovationMap = curHouseData:GetRenovationDataMapByFloor(floorIndex)
  if not serverRenovationMap then
    return
  end
  for typeID, materialSData in pairs(serverRenovationMap) do
    self:ChangeObjMaterial(materialSData.id, floorIndex)
  end
end

function HomeManager:UpdateFurniture(nFurnitureData, customCallback, customCallbackArg)
  if not self:IsAtHome() then
    return
  end
  local nFurniture = self:FindFurniture(nFurnitureData.id, true) or self:FindFurniture(nFurnitureData.oldID, true)
  self.nFurnitureClientMap[nFurnitureData.id] = nil
  self.nFurnitureMap[nFurnitureData.oldID] = nil
  self.nFurnitureClientMap[nFurnitureData.oldID] = nil
  if nFurniture then
    if not nFurniture.inited then
      return
    end
    nFurniture:SetData(nFurnitureData)
    self:UpdateFurnitureCallBack(nFurniture, 0.2, customCallback, customCallbackArg)
  else
    nFurniture = NFurniture.new(nFurnitureData.id, nFurnitureData.staticID, self.tsfFurnituresRoot, function(furniture)
      if self.buildingGrid == nil then
        return
      end
      if not furniture.inited then
        LogUtility.Error(string.format("家具%s资源加载失败，将被移除！", tostring(nFurnitureData.staticID)))
        if self:IsAtMyselfHome() then
          self:FurnitureItemPlaceFailed(furniture.id)
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
      self:UpdateFurnitureCallBack(furniture, 0.5, customCallback, customCallbackArg)
    end)
  end
  self.nFurnitureMap[nFurnitureData.id] = nFurniture
end

function HomeManager:UpdateFurnitureCallBack(nFurniture, fadeTime, customCallback, customCallbackArg)
  if not nFurniture.inited or not self:IsAtHome() then
    return
  end
  nFurniture.assetFurniture:SetColliderEnable(true)
  nFurniture:SetRotationAngle(nFurniture.placeAngle)
  local targetRow, targetCol = nFurniture.placeRow, nFurniture.placeCol
  local result, right, wrong, placeRow, placeCol = self:PlaceFurniture_T(nFurniture, nFurniture.placeFloor, targetRow, targetCol, nFurniture:GetRotationAngle())
  if nFurniture:GetRotationAngle() ~= nFurniture.placeAngle then
    LogUtility.Warning(string.format("服务器角度: %s, 本地修正为: %s", tostring(nFurniture.placeAngle), tostring(nFurniture:GetRotationAngle())))
  end
  if result == BuildingGrid.EPlaceFurnitureResult.ESuccess then
    nFurniture:PlaceOnCurCell()
    local pos = self:GetBuildPosByCells(nFurniture.placeFloor, right, wrong)
    nFurniture.assetFurniture:SetPosition(pos)
    nFurniture.assetFurniture:AlphaTo(1, fadeTime)
    if nFurniture:IsHideWithWall() then
      nFurniture.assetFurniture:SetParent(self:GetNearestWall(nFurniture.placeFloor, pos.x, pos.z).transform, true)
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
      self:FurnitureItemPlaceFailed(nFurniture.id)
    end
    self:RemoveFurnitureItem_Server(nFurniture.id)
    if customCallback then
      customCallback(customCallbackArg)
    end
  end
end

function HomeManager:ClearFurnitureRewards()
  for id, nFurniture in pairs(self.nFurnitureMap) do
    if nFurniture then
      nFurniture:ClearReward()
    end
  end
end

function HomeManager:GetRenovationObjs(floorIndex, typeID)
  local objMap = self.tabRenovationMap[floorIndex]
  objMap = objMap and objMap[typeID]
  if objMap then
    return objMap
  else
    LogUtility.Error("没有找到目标物体！楼层：%s，类型ID：%s", tostring(floorIndex), tostring(typeID))
  end
end

function HomeManager:IsRenovationTypeDivideByPos(typeID)
  return false
end

function HomeManager:Renovation(materialStaticID, floorIndex, posKey)
  if HomeManager.ClientTest then
    return
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
  end)
end

function HomeManager:ChangeObjMaterial(materialStaticID, floorIndex, posKey, callBack)
  local materialStaticData = Table_HomeFurnitureMaterial[materialStaticID]
  if not materialStaticData then
    return false
  end
  local typeID = materialStaticData.Type
  local objMap = self.tabRenovationMap[floorIndex]
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
      Game.AssetManager_Furniture:LoadHomeMaterial(materialStaticID, tabObjInfo.matFolderName, function(mat, meshRenderer)
        if not mat then
          LogUtility.Error(string.format("加载材质id: %s 失败！", tostring(materialStaticID)))
        elseif not Slua.IsNull(meshRenderer) then
          meshRenderer.material = mat
        end
        if callBack then
          callBack(mat)
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
        Game.AssetManager_Furniture:LoadHomeMaterial(materialStaticID, tabObjInfo.matFolderName, function(mat, meshRenderer)
          if not mat then
            LogUtility.Error(string.format("加载材质id: %s 失败！", tostring(materialStaticID)))
          elseif not Slua.IsNull(meshRenderer) then
            meshRenderer.material = mat
          end
          if callBack then
            callBack(mat)
          end
        end, tabObjInfo.meshRenderer)
      end
    end
  end
end

function HomeManager:IsSameMatetial(materialStaticID, currentMatetialName)
  local materialStaticData = Table_HomeFurnitureMaterial[materialStaticID]
  if not materialStaticData then
    LogUtility.Error("Table_HomeFurnitureMaterial中没有ID: " .. tostring(materialStaticID))
    return false
  end
  return self:IsSameMatetialByName(materialStaticData.NameEn, currentMatetialName)
end

function HomeManager:IsSameMatetialByName(targetMaterialName, currentMatetialName)
  return targetMaterialName == currentMatetialName or targetMaterialName .. " (Instance)" == currentMatetialName
end

local vecCellPos = LuaVector3(0, 0, 0)

function HomeManager:GetBuildPosByCells(floorIndex, right, wrong)
  local curGroundHeight = self.curGroundHeight or 0
  if curGroundHeight ~= 0 then
    self:ResetGroundHeight(0)
  end
  local i = 1
  local posX, posZ, minX, maxX, minZ, maxZ
  if right then
    for j = 1, #right do
      posX, posZ = self:ConvertRowAndColToWorldPosition(floorIndex, right[j].row, right[j].col)
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
      posX, posZ = self:ConvertRowAndColToWorldPosition(floorIndex, wrong[j].row, wrong[j].col)
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
    self:ResetGroundHeight(curGroundHeight)
  end
  posX, posZ = ((minX or 0) + (maxX or 0)) / 2, ((minZ or 0) + (maxZ or 0)) / 2
  return GetTempVector3(posX, self:GetWorldPosYByXZ(floorIndex, posX, posZ), posZ, vecCellPos)
end

function HomeManager:ParseFurnitureToPbMsg(nFurniture)
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

function HomeManager:GetNearestWall(floorIndex, posX, posZ)
  local logicWallID = self.buildingGrid:GetWallId(floorIndex, posX, posZ)
  local wall = logicWallID and self.tabLogicWalls[floorIndex][logicWallID]
  if wall then
    return wall
  else
    LogUtility.Error(string.format("没有在%s楼找到墙壁id: %s", tostring(floorIndex), tostring(logicWallID)))
    return self:GetFurnitureRootTransform()
  end
end

function HomeManager:GetPlacedFurnitureCells(tag)
  return self.buildingGrid:GetPlacedFurnitureCells(tag)
end

function HomeManager:ConvertWorldPositionToRowAndCol(floorIndex, posX, posZ)
  return self.buildingGrid:ConvertWorldPositionToRowAndCol(floorIndex, posX, posZ)
end

function HomeManager:ConvertRowAndColToWorldPosition(floorIndex, row, col)
  return self.buildingGrid:ConvertRowAndColToWorldPosition(floorIndex, row, col)
end

function HomeManager:CalculateRotationCloseToNearestWall(staticID, posX, posZ)
  return self.buildingGrid:CalculateRotationCloseToNearestWall(staticID, posX, posZ)
end

function HomeManager:PlaceFurniture(nFurniture, floorIndex, posX, posZ, angle)
  angle = angle or nFurniture:GetRotationAngle()
  local result, right, wrong, placeRow, placeCol = self.buildingGrid:PlaceFurniture(nFurniture.tag, nFurniture.staticID, floorIndex, posX, posZ, angle)
  nFurniture:SetCurCell(floorIndex, placeRow, placeCol)
  return result, right, wrong, placeRow, placeCol
end

function HomeManager:PlaceFurniture_T(nFurniture, floorIndex, targetRow, targetCol, angle, isTry)
  angle = angle or nFurniture:GetRotationAngle()
  local result, right, wrong, placeRow, placeCol, isNearWall = self.buildingGrid:PlaceFurniture_T(nFurniture.tag, nFurniture.staticID, floorIndex, targetRow, targetCol, angle, isTry == true)
  nFurniture:SetCurCell(floorIndex, placeRow, placeCol)
  if targetRow ~= placeRow or targetCol ~= placeCol then
    LogUtility.Error(string.format("看到此条请报给前端! 家具: %s(floor: %s, angle: %s)尝试摆放在{row: %s, col: %s}, 但实际摆放在了{row: %s, col: %s}, 摆放结果: %s。", tostring(nFurniture and nFurniture.staticID), tostring(floorIndex), tostring(angle), tostring(targetRow), tostring(targetCol), tostring(placeRow), tostring(placeCol), tostring(result)))
  end
  return result, right, wrong, placeRow, placeCol, isNearWall
end

function HomeManager:TryPlaceFurniture(tag, staticID, floorIndex, posX, posZ, angle)
  return self.buildingGrid:TryPlaceFurniture(tag, staticID, floorIndex, posX, posZ, angle)
end

function HomeManager:RotateFurniture(nFurniture, floorIndex, row, col, angle)
  angle = angle or nFurniture:GetRotationAngle()
  local result, right, wrong, placeRow, placeCol = self.buildingGrid:RotateFurniture(nFurniture.tag, nFurniture.staticID, floorIndex, row, col, angle)
  nFurniture:SetCurCell(floorIndex, placeRow, placeCol)
  return result, right, wrong, placeRow, placeCol
end

function HomeManager:RemoveFurnitureFromGrid(tag)
  return self.buildingGrid:RemoveFurniture(tag)
end

function HomeManager:MoveFurniture(nFurniture, floorIndex, currentRow, currentCol, currentRotation, deltaRow, deltaCol, closeToWall)
  return self.buildingGrid:MoveFurniture(nFurniture.tag, nFurniture.staticID, floorIndex, currentRow, currentCol, currentRotation, deltaRow, deltaCol, closeToWall)
end

function HomeManager:IsFurnitureNearWallSide(tag)
  return self.buildingGrid:IsFurnitureNearWallSide(tag)
end

function HomeManager:IsCellAvaliableTypeByPos(floorIndex, worldX, worldZ)
  return self.buildingGrid:IsCellAvaliableTypeByPos(floorIndex, worldX, worldZ)
end

function HomeManager:IsCellAvaliableType(floorIndex, row, col)
  return self.buildingGrid:IsCellAvaliableType(floorIndex, row, col)
end

function HomeManager:ClickFurniture(id)
  if self:IsInEditMode() or not self:IsAtHome() then
    return
  end
  local nFurniture = self:FindFurniture(id)
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
  if staticData.AccessType == HomeManager.AccessType.Direct then
    self:DirectUseFurniture(nFurniture, functionList[1])
  elseif staticData.AccessType == HomeManager.AccessType.LookAtSelect then
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

function HomeManager:ArrivedAccessFurniture(nFurniture, custom)
  if self:IsInEditMode() or not self:IsAtHome() then
    return
  end
  if nFurniture.data.staticData.AccessType == HomeManager.AccessType.NearBy then
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

function HomeManager:DirectUseFurniture(nFurniture, functionData)
  functionData = functionData or self:GetFurnitureFunctionsList(nFurniture)[1]
  if functionData and functionData.status == FurnitureFuncState.Active then
    nFurniture:AccessStart()
    FunctionFurnitureFunc.Me():DoFurnitureFunc(functionData.functionStaticData, nFurniture, functionData.param)
  end
  self:ClearFurnitureFuncList()
end

function HomeManager:GetFurnitureFunctionsList(nFurniture)
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

function HomeManager:ClearFurnitureFuncList()
  if not self.listFurnitureFunc then
    return
  end
  for i = 1, #self.listFurnitureFunc do
    ReusableTable.DestroyAndClearTable(self.listFurnitureFunc[i])
  end
  ReusableTable.DestroyAndClearArray(self.listFurnitureFunc)
  self.listFurnitureFunc = nil
end

function HomeManager:GetMyselfDistanceToFurniture(nFurniture)
  return LuaVector3.Distance(nFurniture:GetPosition(), Game.Myself:GetPosition())
end

function HomeManager:SetRelativeCreature(furnitureID, creatureID)
  if StringUtil.IsEmpty(furnitureID) or StringUtil.IsEmpty(creatureID) then
    return
  end
  self.relativeCreatureMap[furnitureID] = creatureID
end

function HomeManager:RemoveRelativeCreature(furnitureID)
  if StringUtil.IsEmpty(furnitureID) then
    return
  end
  self.relativeCreatureMap[furnitureID] = nil
end

function HomeManager:UpdateRelativeCreatures()
  local nCreature
  for furnitureID, creatureID in pairs(self.relativeCreatureMap) do
    nCreature = SceneCreatureProxy.FindCreature(creatureID)
    if nCreature then
      nCreature:UpdateWithRelativeFurniture()
    end
  end
end

function HomeManager:_AddObjToDestroyList(obj)
  if LuaGameObject.ObjectIsNull(obj) then
    return
  end
  self.destroyList[#self.destroyList + 1] = obj
  obj.transform.parent = self.tsfDestroyFurnitureRoot
end

function HomeManager:Update(time, deltaTime)
  if not self:IsAtHome() or SceneProxy.Instance:IsLoading() then
    return
  end
  local allPets = HomeProxy.Instance:GetCurFeedingPet()
  if allPets ~= nil then
    for _, pet in ipairs(allPets) do
      pet:Update(time, deltaTime)
    end
  end
  local destroyListNum = #self.destroyList
  if 0 < destroyListNum then
    Game.AssetManager_Furniture:DestroyFurniture(self.destroyList[destroyListNum])
    self.destroyList[destroyListNum] = nil
  end
  if self:IsInEditMode() then
    return
  end
  for id, nFurniture in pairs(self.nFurnitureMap) do
    nFurniture:Update(time, deltaTime)
  end
  self.phonographManager:Update(deltaTime)
end

function HomeManager:GetRandomPosInCurrentHome()
  while true do
    local floorIndex = math.random(1, #self.mapInfo)
    local floor = self.mapInfo[floorIndex]
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

function HomeManager:GetRandomFurnitureByFurnitureType(itemType)
  local items = {}
  for k, v in pairs(self:GetFurnituresMap()) do
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

function HomeManager:TryGetHomeWorkbenchDiscount(key)
  local buff = Table_HomeBuff[HomeProxy.Instance:GetMyHomeScoreLv()]
  if not buff or not next(buff) then
    return 100
  end
  local data
  if key == "Refine" then
    data = buff.Func.refinereduce
  elseif key == "Enchant" then
    data = buff.Func.enchantreduce
  end
  return data and data[1] / 100 or 100
end

function HomeManager:PhotoAlbumCompleteCallback(note)
  local photoData = note.data.photoData
  local texture = note.data.texture
  if not photoData or not texture then
    return
  end
  local furnitures, photo = self:GetFurnituresMap()
  for _, furniture in pairs(furnitures) do
    photo = furniture.data and furniture.data.photo
    if photo and photo.sourceid == photoData.sourceid and photo.source == photoData.source and photo.time == photoData.time and photo.charid == photoData.charid then
      furniture:UpdatePhoto(texture)
    end
  end
end

function HomeManager:TryPutHomeStore(data, count)
  if data and not data:CanStorage(BagProxy.BagType.Home) then
    MsgManager.ShowMsgByID(38)
    return
  end
  self:TryCallHomeStoreOper(HomeCmd_pb.EFURNITUREOPER_PUTSTORE, data, count)
end

function HomeManager:TryPutOffHomeStore(data, count)
  self:TryCallHomeStoreOper(HomeCmd_pb.EFURNITUREOPER_OFFSTORE, data, count)
end

function HomeManager:TryCallHomeStoreOper(oper, data, count)
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

function HomeManager:RegisterWorkingHomeStore(furniture)
  self.workingHomeStore = furniture
end

function HomeManager:GetFurnituresByStaticType(t)
  TableUtility.ArrayClear(self.tmpDataList)
  for _, nFurniture in pairs(self.nFurnitureMap) do
    if nFurniture.data and nFurniture.data:GetItemType() == t then
      TableUtility.ArrayPushBack(self.tmpDataList, nFurniture)
    end
  end
  return self.tmpDataList
end

function HomeManager:CreateRandomGiftCell()
  local randomCount = HomeProxy.Instance:GetRandomCount()
  if randomCount == 0 then
    return
  end
  local randomTry = 1
  while randomCount >= randomTry do
    local floorIndex, cellRow, cellCol = self:GetRandomGiftCellInCurrentHomeNearExit(true)
    if floorIndex and cellRow and cellCol then
      HomeProxy.Instance:AddOccupyGiftCell(cellRow, cellCol, floorIndex)
    else
      redlog("随机失败  可能全满？")
      local floorIndex, cellRow, cellCol = self:GetRandomGiftCellInCurrentHomeNearExit()
      if floorIndex and cellRow and cellCol then
        HomeProxy.Instance:AddOccupyGiftCell(cellRow, cellCol, floorIndex)
      end
    end
    randomTry = randomTry + 1
  end
  HomeProxy.Instance:CallRandHomeGiftBoxGridCmd()
end

function HomeManager:IsCellOccupiedByGift(rol, col, floorIndex)
  local giftCells = HomeProxy.Instance:GetOccupyGiftCells() or {}
  if giftCells and 0 < #giftCells then
    for i = 1, #giftCells do
      local singleCell = giftCells[i]
      if singleCell.row == rol and singleCell.col == col and singleCell.floor_index == floorIndex then
        return true
      end
    end
  end
  return false
end

function HomeManager:GetRandomGiftCellInCurrentHome(needCheck)
  local tryCount = 0
  while tryCount < 100 do
    local floorIndex = math.random(1, #self.mapInfo)
    local floor = self.mapInfo[floorIndex]
    local cellRow = math.random(1, floor.row)
    local cellCol = math.random(1, floor.col)
    local cellValue = BuildingGrid.GetCellData(nil, floor, cellRow, cellCol, 1)
    if needCheck then
      if BuildingGrid.IsEmptyOfCell(nil, cellValue) and BuildingGrid.GetTypeOfCell(nil, cellValue) == BuildingGrid.EBuildingCellType.EGround and not self:IsCellOccupiedByGift(cellRow, cellCol, floorIndex) then
        return floorIndex, cellRow, cellCol
      end
    elseif not self:IsCellOccupiedByGift(cellRow, cellCol, floorIndex) then
      return floorIndex, cellRow, cellCol
    end
    tryCount = tryCount + 1
  end
end

function HomeManager:GetRandomGiftCellInCurrentHomeNearExit(needCheck)
  local bornList = Game.MapManager:GetBornPointArray()
  if not bornList then
    redlog("当前地图 无出生点")
    return
  end
  local bornPos = LuaVector3.Zero()
  for i = 1, #bornList do
    local v = bornList[i]
    if v and v.ID and v.position then
      LuaVector3.Better_Set(bornPos, v.position[1], v.position[2], v.position[3])
      break
    end
  end
  local mapName = Table_Map[Game.MapManager:GetMapID()].NameEn
  local floor = 1
  local row = HomeFun.ConvertWorldPosZToRow(mapName, floor, bornPos[3])
  local col = HomeFun.ConvertWorldPosXToCol(mapName, floor, bornPos[1])
  local floorInfo = self.mapInfo[floor]
  local range = 5
  local tryCount = 0
  while tryCount < 100 do
    local rowMax = 42
    local cellRow = math.random(row - range, math.min(rowMax, row + range))
    local cellCol = math.random(col - range, col + range)
    if 0 < cellRow and 0 < cellCol then
      local cellValue = BuildingGrid.GetCellData(nil, floorInfo, cellRow, cellCol, 1)
      if needCheck then
        if BuildingGrid.IsEmptyOfCell(nil, cellValue) and BuildingGrid.GetTypeOfCell(nil, cellValue) == BuildingGrid.EBuildingCellType.EGround and not self:IsCellOccupiedByGift(cellRow, cellCol, floor) then
          return floor, cellRow, cellCol
        end
      elseif not self:IsCellOccupiedByGift(cellRow, cellCol, floor) then
        return floor, cellRow, cellCol
      end
    end
    tryCount = tryCount + 1
    if 20 <= tryCount then
      range = math.ceil(tryCount / 4)
    end
  end
end
