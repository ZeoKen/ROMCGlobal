BWMiniMapWindow = class("BWMiniMapWindow", CoreView)
autoImport("MiniMapTransmitterButton")
autoImport("MiniMapWorldQuestButton")
autoImport("WildMvpMapSymbol")
autoImport("MiniMapSymbol")
BWMiniMapWindow.Event = {
  ClickTransmitterButton = "BWMiniMapWindow.Event.ClickTransmitterButton"
}
BWMiniMapWindow.Type = {
  ExitPoint = 1,
  Npc = 2,
  ServerNpc = 3,
  NpcWalk = 4,
  TeamMember = 5,
  QuestNpc = 6,
  QuestFocus = 7,
  ScenicSpot = 8,
  Seal = 9,
  Transmitter = 10,
  WorldQuestTreasure = 11,
  Monster = 12,
  FixedTreasure = 13,
  TreePoints = 14,
  Player = 15,
  MVP = 16,
  PoringFight = 17,
  TeamPws = 18,
  Thanatos = 19,
  Othello = 20,
  Link = 21,
  CIRCLE = 23,
  RaidPuzzleRoom = 24,
  QuickTarget = 25,
  FlowerCar = 26,
  LocalNpc = 27,
  MetalGvg = 28,
  MetalGvg_GuildIcon = 29,
  MetalGvg_MetalIcon = 30,
  WildMvp = 31,
  GvgStrongHold = 32,
  AreaTips = 33,
  ZoneTips = 34,
  ZoneBlock = 35,
  Yahaha = 36,
  FakeDragon = 37
}
local Type = BWMiniMapWindow.Type
local _Game = Game
local _LuaGeometry = LuaGeometry
local _PictureManager = PictureManager.Instance
local DistanceXZ_Square = VectorUtility.DistanceXZ_Square
local DistanceBy2Value_Square = VectorUtility.DistanceBy2Value_Square
local IsNull = Slua.IsNull
local DistanceXZ = VectorUtility.DistanceXZ
local GetLocalPosition = LuaGameObject.GetLocalPosition
local GetPosition = LuaGameObject.GetPosition
local SetLocalPositionObj = LuaGameObject.SetLocalPositionObj
local SetLocalScaleObj = LuaGameObject.SetLocalScaleObj
local SetLocalRotationObj = LuaGameObject.SetLocalRotationObj
local TableClear = TableUtility.TableClear
local tableInsert = table.insert
BWMiniMapWindow.MAPSCALE_NORMAL = 1
BWMiniMapWindow.MAPSCALE_LARGE = 2.3
local tempV3, tempRot = LuaVector3(), LuaQuaternion()
local tempArgs = {}
local IsRunOnEditor = ApplicationInfo.IsRunOnEditor()
local QuestSymbolConfig = QuestSymbolConfig
local MiniMapSymbolPath = ResourcePathHelper.UICell("MiniMapSymbol")
local MiniMapDataRemoveFunc = function(data)
  data:Destroy()
end

function BWMiniMapWindow:ctor(go, tag, showRange)
  BWMiniMapWindow.super.ctor(self, go)
  self.tag = tag
  self.showRange = showRange
  self:InitDatas()
  self:InitView()
  TEST_BW = self
  
  function TEST_BW.GetAreaConfig()
    return self:PrintBlockCenterInfo()
  end
end

function BWMiniMapWindow:InitDatas()
  self.mapsize = {}
  self.mapSceneSize = LuaVector2(0, 0)
  self.mapSceneMinPos = LuaVector2(0, 0)
  self.allMapDatas = {}
  self.allMapInfos = {}
  self.dirtyMap = {}
  self.focusArrowMap = {}
  self.needFocusFrameMap = {}
  self.monsterActive = true
  self.lastMyPos = LuaVector3()
  self.mapScale = 1
  self.mapDataInfoCache = {}
  self.puzzleRoomsObjAreaMap = {}
  self.puzzleRoomsColliderMap = {}
  self.puzzleRoomsStatusMap = {}
  self:RegisterAllMapInfos()
end

function BWMiniMapWindow:RegisterAllMapInfos()
  self:RegisterMapInfo(Type.ExitPoint, BWMiniMapWindow._CreateExitPoint, BWMiniMapWindow._UpdateExitPoint, BWMiniMapWindow._RemoveExitPoint)
  self:RegisterMapInfo(Type.Npc)
  self:RegisterMapInfo(Type.ServerNpc, BWMiniMapWindow._CreateServerNpcPoint, BWMiniMapWindow._UpdateServerNpcPoint, BWMiniMapWindow._RemoveServerNpcPoint)
  self:RegisterMapInfo(Type.TeamMember, nil, BWMiniMapWindow._UpdateTeamSymbol)
  self:RegisterMapInfo(Type.QuestNpc, BWMiniMapWindow._CreateQuestNpcSymbol, BWMiniMapWindow._UpdateQuestNpcSymbol, BWMiniMapWindow._RemoveQuestNpcSymbol)
  self:RegisterMapInfo(Type.QuestFocus, BWMiniMapWindow._CreateQuestFocus, BWMiniMapWindow._UpdateQuestFocus, BWMiniMapWindow._RemoveQuestFocus)
  self:RegisterMapInfo(Type.ScenicSpot, BWMiniMapWindow._CreateScenicSpot, BWMiniMapWindow._UpdateScenicSpot)
  self:RegisterMapInfo(Type.Seal, BWMiniMapWindow._CreateSealSymbol, BWMiniMapWindow._UpdateSealSymbol)
  self:RegisterMapInfo(Type.Transmitter, BWMiniMapWindow._CreateTransmitterButton, BWMiniMapWindow._UpdateTransmitterButton, BWMiniMapWindow._RemoveTransmitterButton)
  self:RegisterMapInfo(Type.WorldQuestTreasure, BWMiniMapWindow._CreateWorldQuestTreasure, BWMiniMapWindow._UpdateWorldQuestTreasure, BWMiniMapWindow._RemoveWorldQuestTreasure)
  self:RegisterMapInfo(Type.Monster, BWMiniMapWindow._CreateMonsterPoints, BWMiniMapWindow._UpdateMonsterPoints, BWMiniMapWindow._RemoveMonsterPoints)
  self:RegisterMapInfo(Type.MVP, BWMiniMapWindow._CreateMonsterPoints, BWMiniMapWindow._UpdateMonsterPoints, BWMiniMapWindow._RemoveMonsterPoints)
  self:RegisterMapInfo(Type.FixedTreasure, BWMiniMapWindow._CreateFixedTreasurePoints, BWMiniMapWindow._UpdateFixedTreasurePoints, BWMiniMapWindow._RemoveFixedTreasurePoints)
  self:RegisterMapInfo(Type.TreePoints)
  self:RegisterMapInfo(Type.Player, BWMiniMapWindow._CreatePlayerPoints, BWMiniMapWindow._UpdatePlayerPoints)
  self:RegisterMapInfo(Type.CIRCLE, BWMiniMapWindow._CreateMapCircleArea, nil, BWMiniMapWindow._RemoveMapCircleArea)
  self:RegisterMapInfo(Type.LocalNpc, BWMiniMapWindow._CreateLocalNpcPosSymbol)
  self:RegisterMapInfo(Type.AreaTips, BWMiniMapWindow._CreateAreaTips, BWMiniMapWindow._UpdateAreaTips)
  self:RegisterMapInfo(Type.ZoneTips, BWMiniMapWindow._CreateZoneTips, BWMiniMapWindow._UpdateZoneTips)
  self:RegisterMapInfo(Type.ZoneBlock, BWMiniMapWindow._CreateZoneBlock, BWMiniMapWindow._UpdateZoneBlock, BWMiniMapWindow._RemoveZoneBlock)
  self:RegisterMapInfo(Type.WildMvp, BWMiniMapWindow._CreateWildMvpSymbol, BWMiniMapWindow._UpdateWildMvpSymbol, BWMiniMapWindow._RemoveWildMvpSymbol)
  self:RegisterMapInfo(Type.Yahaha, BWMiniMapWindow._CreateYahahaSymbol, BWMiniMapWindow._UpdateYahahaSymbol)
  self:RegisterMapInfo(Type.FakeDragon, BWMiniMapWindow._CreateFakeDragonSymbol, BWMiniMapWindow._UpdateFakeDragonSymbol, BWMiniMapWindow._RemoveFakeDragonSymbol)
end

function BWMiniMapWindow:RegisterMapInfo(type, createFunc, updateFunc, removeFunc)
  local mapInfo = self.allMapInfos[type]
  if not mapInfo then
    mapInfo = {
      cacheMap = {},
      lastPosXMap = {},
      lastPosZMap = {}
    }
    self.allMapInfos[type] = mapInfo
  end
  mapInfo.createFunc = createFunc
  mapInfo.updateFunc = updateFunc
  mapInfo.removeFunc = removeFunc
end

function BWMiniMapWindow:InitView()
  self.mapPanel = self:FindComponent("Panel_Map", UIPanel)
  self.sPanel = self:FindComponent("Panel_S", UIPanel)
  self.dPanel = self:FindComponent("Panel_D", UIPanel)
  self.monsterPanel = self:FindComponent("Panel_Monster", UIPanel)
  self.myselfPanel = self:FindComponent("Panel_Self", UIPanel)
  self.comPanelMoveFollow = self.mapPanel.gameObject:GetComponent(PanelMoveFollow)
  self.mapScrollView = self:FindComponent("Panel_Map", UIScrollView)
  
  function self.mapScrollView.onDragStarted()
    self.vMoved = true
  end
  
  function self.mapScrollView.onStoppedMoving()
    self.vMoved = false
  end
  
  local panelSize = self.sPanel:GetViewSize()
  self.panelSize = {
    panelSize.x,
    panelSize.y
  }
  self.mapTexture = self:FindComponent("MapTexture", UITexture, self.mapPanel.gameObject)
  self.lMapTexture = self:FindComponent("LeftTexture", UITexture, self.mapPanel.gameObject)
  self.rMapTexture = self:FindComponent("RightTexture", UITexture, self.mapPanel.gameObject)
  self.mapLabel = self:FindGO("MapLabel", self.mapTexture.gameObject)
  self.mapBorderTexture = self:FindComponent("MapBorderTexture", UITexture, self.mapPanel.gameObject)
  self.lMapBorderTexture = self:FindComponent("LeftBorderTexture", UITexture, self.mapPanel.gameObject)
  self.rMapBorderTexture = self:FindComponent("RightBorderTexture", UITexture, self.mapPanel.gameObject)
  self.s_symbolParent = self:CreateSymbolsParent(self.sPanel, "symbolsParent")
  self.d_symbolParent = self:CreateSymbolsParent(self.dPanel, "symbolsParent")
  self.monster_symbolParent = self:CreateSymbolsParent(self.monsterPanel, "symbolsParent")
  self.self_symbolParent = self:CreateSymbolsParent(self.myselfPanel, "symbolsParent")
  if self.destTransEffect then
    self.destTransEffect:Destroy()
    self.destTransEffect = nil
  end
  self.destTransEffect = self:PlayUIEffect(EffectMap.UI.MapPoint, self.myselfPanel.gameObject, false)
  self.destTransEffect:RegisterWeakObserver(self)
  self.destTransEffect:SetActive(false)
  if self.tipTransEffect then
    self.tipTransEffect:Destroy()
    self.tipTransEffect = nil
  end
  self.tipTransEffect = self:PlayUIEffect(EffectMap.UI.MapPoint2, self.myselfPanel.gameObject, false)
  self.tipTransEffect:RegisterWeakObserver(self)
  self.tipTransEffect:SetActive(false)
  local myTransSymbol = self:GetMapSymbol("map_mypos", 100, 1, self.myselfPanel.transform)
  self.myTrans = myTransSymbol.transform
  self.cameraSymbol = self:GetMapSymbol("map_face", 99, 1, self.myselfPanel.transform)
  local cameraSymbolSp = self.cameraSymbol:GetComponent(UISprite)
  cameraSymbolSp.pivot = UIWidget.Pivot.Left
  self:UpdateCameraSymbol()
  self:AddClickEvent(self.mapTexture.gameObject, function(go)
    self:OnClickMiniMap()
  end)
end

function BWMiniMapWindow:UpdateDestPos(destPos)
  if not self.map2D then
    return
  end
  if not self.destTransEffect then
    return
  end
  local nowMyPos = _Game.Myself:GetPosition()
  if destPos and 1.0E-4 < DistanceXZ_Square(destPos, nowMyPos) then
    if not self.destTransEffect:IsActive() then
      self.destTransEffect:SetActive(true)
    end
    self.destTransEffect:ResetLocalPosition(self:ScenePosToMap(destPos))
  elseif self.destTransEffect:IsActive() then
    self.destTransEffect:SetActive(false)
  end
end

function BWMiniMapWindow:OnClickMiniMap()
  if self.lock then
    return
  end
  TipsView.Me():HideTip(QuestDetailTip)
  local inputWorldPos = _LuaGeometry.GetTempVector3(LuaGameObject.GetMousePosition())
  if not UIUtil.IsScreenPosValid(inputWorldPos[1], inputWorldPos[2]) then
    return
  end
  local uiCamera = NGUIUtil:GetCameraByLayername("UI")
  if not uiCamera then
    return
  end
  inputWorldPos = _LuaGeometry.GetTempVector3(LuaGameObject.ScreenToWorldPointByVector3(uiCamera, inputWorldPos))
  tempV3[1], tempV3[2], tempV3[3] = LuaGameObject.InverseTransformPointByVector3(self.mapTexture.transform, inputWorldPos)
  local p = self:MapPosToScene(tempV3)
  if p then
    if _Game.Myself:IsDead() then
      return
    end
    local currentMapID = _Game.MapManager:GetMapID()
    local disableInnerTeleport = Table_Map[currentMapID].MapNavigation
    if nil ~= disableInnerTeleport and 0 ~= disableInnerTeleport then
      _Game.Myself:TryUseQuickRide()
      self:ResetMoveCMD(nil)
      _Game.Myself:Client_MoveTo(p)
    else
      _Game.Myself:Logic_NavMeshPlaceTo(_Game.Myself:GetPosition())
      if self.moveCMD then
        self.moveCMD:ResetTargetPos(currentMapID, p)
        if self.moveCMD.teleport and self.moveCMD.teleport.running then
          self.moveCMD:DoLaunch()
        end
      else
        TableUtility.TableClear(tempArgs)
        tempArgs.targetMapID = currentMapID
        tempArgs.targetPos = p
        tempArgs.showClickGround = true
        tempArgs.allowExitPoint = true
        tempArgs.shutDownWhenChangeMap = true
        local x, y, z = p[1], p[2], p[3]
        
        function tempArgs.callback(cmd, event)
          local nowMapId = _Game.MapManager:GetMapID()
          if cmd.targetMapID ~= nowMapId then
            return
          end
          self.moveCMD = nil
          if MissionCommandMove.CallbackEvent.TeleportFailed == event then
            LuaVector3.Better_Set(tempV3, x, y, z)
            _Game.Myself:Client_MoveTo(tempV3)
          end
        end
        
        function tempArgs.endcallback(cmd)
          self.moveCMD = nil
        end
        
        local cmd = MissionCommandFactory.CreateCommand(tempArgs, MissionCommandMove)
        if cmd then
          _Game.Myself:Client_SetMissionCommand(cmd)
        end
        self:ResetMoveCMD(cmd)
      end
      Game.GameHealthProtector:OnClickTerrain(p)
    end
    _Game.Myself:TryUseQuickRide()
  end
  GameFacade.Instance:sendNotification(GuideEvent.CloseMiniMapAnim)
end

function BWMiniMapWindow:ResetMoveCMD(cmd)
  if nil ~= self.moveCMD then
    self.moveCMD:Shutdown()
  end
  self.moveCMD = cmd
end

function BWMiniMapWindow:ObserverDestroyed(obj)
  if obj == self.tipTransEffect then
    self.tipTransEffect = nil
  elseif obj == self.destTransEffect then
    self.destTransEffect = nil
  end
end

function BWMiniMapWindow:GetSymbolObjMap(type)
  local mapInfo = self.allMapInfos[type]
  return mapInfo and mapInfo.cacheMap
end

function BWMiniMapWindow:CreateSymbolsParent(parent, name)
  local symbolObj = GameObject(name)
  symbolObj = symbolObj.transform
  symbolObj:SetParent(parent.transform, false)
  symbolObj.localPosition = _LuaGeometry.GetTempVector3()
  LuaQuaternion.Better_SetEulerAngles(tempRot, _LuaGeometry.GetTempVector3())
  symbolObj.localRotation = tempRot
  symbolObj.localScale = _LuaGeometry.GetTempVector3(1, 1, 1)
  return symbolObj
end

function BWMiniMapWindow:GetMapSymbol(sname, depth, scale, parent)
  local resultGO = _Game.AssetManager_UI:CreateAsset(MiniMapSymbolPath, parent or self.s_symbolParent)
  resultGO:SetActive(true)
  SetLocalPositionObj(resultGO, 0, 0, 0)
  SetLocalRotationObj(resultGO, 0, 0, 0, 1)
  SetLocalScaleObj(resultGO, 1, 1, 1)
  local sprite = resultGO:GetComponent(UISprite)
  IconManager:SetMapIcon(sname, sprite)
  sprite:MakePixelPerfect()
  scale = scale or 0.7
  sprite.width = sprite.width * scale
  sprite.height = sprite.height * scale
  if depth then
    sprite.depth = depth
  end
  return resultGO
end

function BWMiniMapWindow:PrintBlockCenterInfo()
  local sb = LuaStringBuilder.new()
  for i = 1, 99 do
    local obj = TEST_BW:FindGO("Part" .. i)
    if obj == nil then
      break
    end
    local pos = obj.transform.localPosition * self.mapsize.x / 1024.0
    local tex = TEST_BW:FindGO(string.format("%s_mini_%02d", TEST_BW.mapTexName, i))
    tex.transform.localPosition = pos
    local r = TEST_BW:MapPosToScene(pos)
    sb:AppendLine(string.format("%d\t\t{%s,%s,%s},", i, math.RoundDecimalPlaces(r[1], 2), math.RoundDecimalPlaces(r[2], 2), math.RoundDecimalPlaces(r[3], 2)))
  end
  local text = sb:ToString()
  redlog(text)
  return text
end

function BWMiniMapWindow:MapPosToScene(pos)
  if self.map2D then
    local width, height = self.mapsize.x, self.mapsize.y
    local px = (pos.x + width * 0.5) / width
    local py = (pos.y + height * 0.5) / height
    local x, y, z = self.map2D:GetPositionByXY(px, py)
    tempV3:Set(x, y, z)
    return tempV3
  end
end

local scenePos_mapPos = LuaVector3.Zero()

function BWMiniMapWindow:ScenePosToMap(pos)
  if not self.map2D then
    return
  end
  local mapxPct = (pos[1] - self.mapSceneMinPos[1]) / self.mapSceneSize[1]
  local mapyPct = (pos[3] - self.mapSceneMinPos[2]) / self.mapSceneSize[2]
  local texWidth = self.mapsize.x
  local texHeight = self.mapsize.y
  LuaVector3.Better_Set(scenePos_mapPos, mapxPct * texWidth - texWidth / 2, mapyPct * texHeight - texHeight / 2, 0)
  if self.mapPosOffsetFunc then
    self.mapPosOffsetFunc(self, scenePos_mapPos)
  end
  return scenePos_mapPos
end

function BWMiniMapWindow:HelpUpdatePos(symbol, scenePos)
  local spos = self:ScenePosToMap(scenePos)
  if spos == nil then
    return false
  end
  SetLocalPositionObj(symbol, spos[1], spos[2], spos[3])
  return true
end

function BWMiniMapWindow:ResetMapPos()
  self.mapPanel.clipOffset = _LuaGeometry.Const_V2_zero
  self.mapPanel.transform.localPosition = _LuaGeometry.Const_V3_zero
end

function BWMiniMapWindow:CenterOnMyPos(restrictWithPanel)
  self:CenterOnPosition(_Game.Myself:GetPosition(), restrictWithPanel)
end

local cc, cp, bsize, offset = LuaVector3(), LuaVector3(), LuaVector3(), LuaVector3()

function BWMiniMapWindow:CenterOnPosition(scenePos, restrictWithPanel)
  if self.mapScrollView then
    self.mapScrollView:DisableSpring()
    self.mapScrollView.currentMomentum = LuaGeometry.Const_V3_zero
  end
  local mapPanelTrans = self.mapPanel.transform
  cc[1], cc[2], cc[3] = LuaGameObject.InverseTransformPointByVector3(mapPanelTrans, self.trans.position)
  local rePos = self:ScenePosToMap(scenePos)
  cp:Set(rePos[1], rePos[2], rePos[3])
  if restrictWithPanel then
    local mBound = NGUIMath.CalculateRelativeWidgetBounds(self.mapTexture.transform)
    local mBound_Size = mBound.size
    bsize[1] = mBound_Size.x - self.panelSize[1]
    bsize[2] = mBound_Size.y - self.panelSize[2]
    bsize[3] = 0
    local checkBound = Bounds(mBound.center, bsize)
    if not checkBound:Contains(cp) then
      cp = checkBound:ClosestPoint(cp)
    end
  end
  LuaVector3.Better_Sub(cp, cc, offset)
  local x, y, z = GetLocalPosition(mapPanelTrans)
  mapPanelTrans.localPosition = _LuaGeometry.GetTempVector3(x - offset[1], y - offset[2], offset[3] - z)
  self.mapPanel.clipOffset = self.mapPanel.clipOffset + offset
end

function BWMiniMapWindow:UpdateMapTexture(data, size, map2D, setSide)
  self.mapdata = data
  self.map2D = map2D
  if map2D and data then
    local resName = "Scene" .. data.NameEn
    if map2D.ID > 0 then
      resName = resName .. "_" .. map2D.ID
    end
    self:SetMiniMap(resName, setSide)
    if size then
      self.mapTexture.width = size[1]
      self.mapTexture.height = size[2]
    end
    local minX, minZ, sizeX, sizeZ = map2D:GetMinPosAndSizeForLua()
    LuaVector2.Better_Set(self.mapSceneMinPos, minX, minZ)
    LuaVector2.Better_Set(self.mapSceneSize, sizeX, sizeZ)
    self.mapsize.x = self.mapTexture.width
    self.mapsize.y = self.mapTexture.height
    self:UpdateMyPos(true)
    NGUITools.UpdateWidgetCollider(self.mapTexture.gameObject)
    self.mapInfoChanged = true
  else
    self:SetMiniMap(nil, setSide)
    self.mapTexture.mainTexture = nil
  end
  self:UpdateFixedInfo()
  self.iMoved = true
  self:RefreshMapSymbols()
  self:UpdateFakeDragonSymbol()
end

function BWMiniMapWindow:ClearFixedInfo()
  if self.npcMapDatas then
    TableUtility.TableClearByDeleter(self.npcMapDatas, MiniMapDataRemoveFunc)
  end
  self.allMapDatas[Type.Npc] = {}
  self:RemoveAllSymbolsByType(Type.Npc)
  if self.exitMapDatas then
    TableUtility.TableClearByDeleter(self.exitMapDatas, MiniMapDataRemoveFunc)
  end
  self.allMapDatas[Type.ExitPoint] = {}
  self:RemoveAllSymbolsByType(Type.ExitPoint)
end

function BWMiniMapWindow:UpdateFixedInfo()
  self:UpdateNpcPoints()
  self:UpdateExitPoints()
  self:UpdateTransmitterPoints()
  self:UpdateAreaTips()
  self:UpdateWildMvpSymbols()
end

function BWMiniMapWindow:UpdateNpcPoints(showBuildingSymbol)
  if nil == self.npcMapDatas then
    self.npcMapDatas = {}
  else
    TableUtility.TableClearByDeleter(self.npcMapDatas, MiniMapDataRemoveFunc)
  end
  local npcList
  local imgId = ServicePlayerProxy.Instance:GetCurMapImageId()
  if imgId ~= nil and imgId ~= 0 then
    npcList = nil
  else
    npcList = _Game.MapManager:GetNPCPointArray()
  end
  if npcList then
    for i = 1, #npcList do
      local v = npcList[i]
      if v and v.ID and v.position then
        local npcData = Table_Npc[v.ID]
        local mapIcon = npcData and npcData.MapIcon
        if mapIcon and mapIcon ~= "" and npcData.NoShowMapIcon ~= 1 and FunctionNpcFunc.checkNPCValid(npcData.id) then
          local isUnlock = true
          if npcData.MenuId then
            isUnlock = FunctionUnLockFunc.Me():CheckCanOpen(npcData.MenuId)
          end
          if isUnlock and FunctionNpcFunc.checkNPCValid(v.uniqueID) then
            local combineID = v.ID .. v.uniqueID
            local npcMapData = self.npcMapDatas[combineID]
            if not npcMapData then
              npcMapData = MiniMapData.CreateAsTable(combineID)
              self.npcMapDatas[combineID] = npcMapData
            end
            npcMapData:SetPos(v.position[1], v.position[2], v.position[3])
            npcMapData:SetParama("Symbol", mapIcon)
          end
        end
      end
    end
  end
  self:UpdateMapSymbolDatas(Type.Npc, self.npcMapDatas)
end

function BWMiniMapWindow:IsScenePosValid(posX, posZ)
  if not self.map2D then
    return
  end
  return posX >= self.mapSceneMinPos[1] and posX <= self.mapSceneMinPos[1] + self.mapSceneSize[1] and posZ >= self.mapSceneMinPos[2] and posZ <= self.mapSceneMinPos[2] + self.mapSceneSize[2]
end

function BWMiniMapWindow:UpdateExitPoints()
  if nil == self.exitMapDatas then
    self.exitMapDatas = {}
  else
    TableUtility.TableClearByDeleter(self.exitMapDatas, MiniMapDataRemoveFunc)
  end
  local exitList = _Game.MapManager:GetExitPointArray()
  local forbidInnerEp = _Game.MapManager:IsMapForbidInnerExitPoint(_Game.MapManager:GetMapID())
  if exitList then
    local table_Map = Table_Map
    for i = 1, #exitList do
      local v = exitList[i]
      if v and v.ID and v.position and self:IsScenePosValid(v.position[1], v.position[3]) then
        local exitData = self.exitMapDatas[v.ID]
        if exitData == nil then
          exitData = MiniMapData.CreateAsTable(v.ID, v.position)
        end
        exitData:SetPos(v.position[1], v.position[2], v.position[3])
        local active = _Game.AreaTrigger_ExitPoint:IsInvisible(v.ID) == false
        exitData:SetParama("active", active)
        exitData:SetParama("index", i)
        if v.nextSceneID ~= nil then
          exitData:SetParama("nextSceneID", v.nextSceneID)
          local nextMapData = table_Map[v.nextSceneID]
          if nextMapData ~= nil then
            if nextMapData.IsDangerous then
              exitData:SetParama("Symbol", "map_gateway1")
            else
              exitData:SetParama("Symbol", "map_gateway")
            end
          elseif not forbidInnerEp then
            exitData:SetParama("Symbol", "map_gateway")
          else
            exitData:SetParama("Symbol", "map_purple")
          end
        end
        self.exitMapDatas[v.ID] = exitData
      end
    end
  end
  self:UpdateMapSymbolDatas(Type.ExitPoint, self.exitMapDatas)
end

function BWMiniMapWindow:UpdateAreaTips()
  if not self.areaTipMap then
    self.areaTipMap = {}
  else
    TableUtility.TableClearByDeleter(self.areaTipMap, MiniMapDataRemoveFunc)
  end
  local areaList = WorldMapProxy.Instance:GetBWAreaTips()
  if areaList then
    for _, data in pairs(areaList) do
      local miniMapData = MiniMapData.CreateAsTable(data.id)
      self.areaTipMap[data.id] = miniMapData
      miniMapData:SetParama("Text", data.NameZh)
      miniMapData:SetParama("depth", 31)
      miniMapData:SetPos(data.Center[1], data.Center[2], data.Center[3])
    end
  end
  if not self.zoneTipMap then
    self.zoneTipMap = {}
  else
    TableUtility.TableClearByDeleter(self.zoneTipMap, MiniMapDataRemoveFunc)
  end
  if not self.zoneBlockMap then
    self.zoneBlockMap = {}
  else
    TableUtility.TableClearByDeleter(self.zoneBlockMap, MiniMapDataRemoveFunc)
  end
  local zoneMap = WorldMapProxy.Instance:GetZoneMap()
  if zoneMap then
    for id, zoneData in pairs(zoneMap) do
      local center = zoneData:GetCenter()
      if center then
        zoneData:RefreshData()
        self.zoneTipMap[id] = MiniMapData.CreateAsTable(id)
        local text = string.format(ZhString.BWMiniMapWindow_ProgressTip, zoneData:GetName(), zoneData:GetProgressPct())
        self.zoneTipMap[id]:SetParama("Text", text)
        self.zoneTipMap[id]:SetParama("depth", 31)
        self.zoneTipMap[id]:SetPos(center[1], center[2], center[3])
      end
      local blockCenter = zoneData:GetBlockCenter() or center
      if blockCenter then
        local group_id = zoneData:GetGroupId()
        self.zoneBlockMap[id] = MiniMapData.CreateAsTable(id)
        self.zoneBlockMap[id]:SetParama("depth", 32)
        self.zoneBlockMap[id]:SetParama("group_id", group_id)
        self.zoneBlockMap[id]:SetParama("Texture", string.format("%s_mini_%02d", self.mapTexName, group_id))
        self.zoneBlockMap[id]:SetParama("unlocked", self.blockUnlockInfo[group_id])
        self.zoneBlockMap[id]:SetPos(blockCenter[1], blockCenter[2], blockCenter[3])
      end
    end
  end
  self:UpdateMapSymbolDatas(Type.AreaTips, self.areaTipMap, true)
  self:UpdateMapSymbolDatas(Type.ZoneTips, self.zoneTipMap, true)
  self:UpdateMapSymbolDatas(Type.ZoneBlock, self.zoneBlockMap, true)
  self:UpdateMapBorderUnlock()
end

function BWMiniMapWindow:UpdateZoneTipsProgress()
  if not self.zoneTipMap then
    return
  end
  local zoneMap = WorldMapProxy.Instance:GetZoneMap()
  for k, v in pairs(self.zoneTipMap) do
    local zoneData = zoneMap[k]
    if zoneData then
      zoneData:RefreshData()
      local text = string.format(ZhString.BWMiniMapWindow_ProgressTip, zoneData:GetName(), zoneData:GetProgressPct())
      v:SetParama("Text", text)
    end
  end
  self:UpdateMapSymbolDatas(Type.ZoneTips, self.zoneTipMap, true, -1)
end

function BWMiniMapWindow:SetMiniMap(name, setSide)
  local mapTexName = self.mapTexName
  if mapTexName == name then
    return
  end
  if mapTexName then
    PictureManager.Instance:UnLoadMiniMap(mapTexName, self.mapTexture)
    PictureManager.Instance:UnLoadMiniMap(mapTexName .. "_border", self.mapBorderTexture)
    if setSide then
      PictureManager.Instance:UnLoadMiniMap(mapTexName .. "l", self.lMapTexture)
      PictureManager.Instance:UnLoadMiniMap(mapTexName .. "r", self.rMapTexture)
      PictureManager.Instance:UnLoadMiniMap(mapTexName .. "l_border", self.lMapBorderTexture)
      PictureManager.Instance:UnLoadMiniMap(mapTexName .. "r_border", self.rMapBorderTexture)
    end
  end
  if self.miniMapGO and not Slua.IsNull(self.miniMapGO) then
    GameObject.Destroy(self.miniMapGO)
    self.miniMapGO = nil
  end
  if name then
    _PictureManager:SetMiniMap(name, self.mapTexture)
    _PictureManager:SetMiniMap(name .. "_border", self.mapBorderTexture)
    if setSide then
      _PictureManager:SetMiniMap(name .. "l", self.lMapTexture)
      _PictureManager:SetMiniMap(name .. "r", self.rMapTexture)
      _PictureManager:SetMiniMap(name .. "l_border", self.lMapBorderTexture)
      _PictureManager:SetMiniMap(name .. "r_border", self.rMapBorderTexture)
    end
  end
  self.mapTexName = name
end

function BWMiniMapWindow:UpdateMapSymbolDatas(type, datas, isRemoveOther, checkDistance, clickEvent)
  local mapInfo = self.allMapInfos[type]
  if not mapInfo then
    redlog("MiniMapWindow recieved unknown type: ", tostring(type))
    return
  end
  mapInfo.isRemoveOther = isRemoveOther
  mapInfo.checkDistance = checkDistance
  mapInfo.clickEvent = clickEvent
  self.allMapDatas[type] = datas or {}
  if not self.showRange then
    self.dirtyMap[type] = true
  end
end

function BWMiniMapWindow:RemoveMiniMapSymbol(obj)
  if not IsNull(obj) then
    GameObject.Destroy(obj)
  end
end

function BWMiniMapWindow:RemoveAllSymbolsByType(type)
  local mapInfo = self.allMapInfos[type]
  if mapInfo then
    for key, symbolObj in pairs(mapInfo.cacheMap) do
      if mapInfo.removeFunc then
        mapInfo.removeFunc(self, key, symbolObj)
      else
        self:RemoveMiniMapSymbol(symbolObj)
      end
    end
    TableClear(mapInfo.cacheMap)
    TableClear(mapInfo.lastPosXMap)
    TableClear(mapInfo.lastPosZMap)
  end
end

function BWMiniMapWindow:RemoveSymbolImmediate(type, key)
  local datas = self.allMapDatas[type]
  if datas and datas[key] then
    datas[key]:Destroy()
    datas[key] = nil
  end
  local mapInfo = self.allMapInfos[type]
  if mapInfo then
    local symbolObj = mapInfo.cacheMap[key]
    if symbolObj then
      if mapInfo.removeFunc then
        mapInfo.removeFunc(self, key, symbolObj)
      else
        self:RemoveMiniMapSymbol(symbolObj)
      end
    end
    mapInfo.cacheMap[key] = nil
    mapInfo.lastPosXMap[key] = nil
    mapInfo.lastPosZMap[key] = nil
  end
end

function BWMiniMapWindow:ActiveSymbolsByType(type, value)
  local mapInfo = self.allMapInfos[type]
  if not mapInfo then
    return
  end
  mapInfo.hide = not value
  self:RefreshSymbolsByType(type)
end

function BWMiniMapWindow:RefreshSymbolsByType(type)
  local mapInfo = self.allMapInfos[type]
  if not mapInfo then
    return
  end
  if mapInfo.hide then
    self:RemoveAllSymbolsByType(type)
    return
  end
  local datas
  if self.showRange then
    local nowMyPos = _Game.Myself:GetPosition()
    local allData = self.allMapDatas[type]
    if allData then
      datas = {}
      for key, data in pairs(allData) do
        local pos = data.pos
        local showRange = data.showRange or self.showRange
        if showRange < 0 or showRange >= DistanceXZ(nowMyPos, data.pos) then
          datas[key] = data
        end
      end
    end
  else
    datas = self.allMapDatas[type]
  end
  if not datas then
    roerr(string.format("not find datas:%s", type))
    return
  end
  local cacheMap = mapInfo.cacheMap
  local lastPosXMap = mapInfo.lastPosXMap
  local lastPosZMap = mapInfo.lastPosZMap
  for key, data in pairs(datas) do
    local lastPosX, lastPosZ = lastPosXMap[key], lastPosZMap[key]
    local checkDistance = mapInfo.checkDistance or 1
    local curPos = data.pos
    if curPos then
      local needUpdate = not lastPosX or self.mapInfoChanged or checkDistance < 0 or DistanceBy2Value_Square(lastPosX, lastPosZ, curPos[1], curPos[3]) > checkDistance * checkDistance
      if needUpdate and self:IsScenePosValid(curPos[1], curPos[3]) then
        local symbolObj = cacheMap[key]
        if not symbolObj then
          if mapInfo.createFunc then
            symbolObj = mapInfo.createFunc(self, data, key, mapInfo.clickEvent)
          else
            symbolObj = self:GetMapSymbol(data:GetParama("Symbol"), data:GetParama("depth") or 5)
            symbolObj.name = tostring(data.id)
          end
        elseif mapInfo.updateFunc then
          symbolObj = mapInfo.updateFunc(self, symbolObj, data, key, mapInfo.clickEvent)
        end
        if self:HelpUpdatePos(symbolObj, curPos) then
          lastPosXMap[key] = curPos[1]
          lastPosZMap[key] = curPos[3]
        end
        cacheMap[key] = symbolObj
      end
    end
  end
  if mapInfo.isRemoveOther then
    for key, symbolObj in pairs(cacheMap) do
      if not datas[key] then
        if mapInfo.removeFunc then
          mapInfo.removeFunc(self, key, symbolObj)
        else
          self:RemoveMiniMapSymbol(symbolObj)
        end
        cacheMap[key] = nil
        lastPosXMap[key] = nil
        lastPosZMap[key] = nil
      end
    end
  end
end

function BWMiniMapWindow:Show()
  self:PlayQuestSymbolShow()
  Game.GUISystemManager:AddMonoUpdateFunction(self.Update, self)
end

function BWMiniMapWindow:PlayQuestSymbolShow()
  local tempMap = {}
  local cacheMap = self:GetSymbolObjMap(Type.QuestNpc)
  for _, obj in pairs(cacheMap) do
    if not IsNull(obj) then
      tableInsert(tempMap, obj)
    end
  end
  self:DelayShowObjLst(tempMap, 100, function(obj)
    local animator = obj:GetComponent(Animator)
    if animator then
      animator:Play("map_icon_task", -1, 0)
    end
  end)
end

function BWMiniMapWindow:DelayShowObjLst(objlst, spacetime, showCall)
  self:StopDelayShowObjList()
  if type(objlst) == "table" and 0 < #objlst then
    for i = 1, #objlst do
      if not IsNull(objlst[i]) then
        objlst[i].gameObject:SetActive(false)
      end
    end
    spacetime = spacetime or 300
    local index = 0
    TimeTickManager.Me():CreateTick(0, spacetime, function(self)
      index = index + 1
      if not IsNull(objlst[index]) then
        objlst[index].gameObject:SetActive(true)
        if type(showCall) == "function" then
          showCall(objlst[index].gameObject)
        end
      end
      if index >= #objlst then
        TimeTickManager.Me():ClearTick(self, 2)
      end
    end, self, 2)
  end
end

function BWMiniMapWindow:StopDelayShowObjList()
  TimeTickManager.Me():ClearTick(self, 2)
end

function BWMiniMapWindow:Hide()
  Game.GUISystemManager:ClearMonoUpdateFunction(self)
end

function BWMiniMapWindow:RefreshMapSymbols()
  if Slua.IsNull(self.gameObject) then
    return
  end
  if self.showRange then
    for type, datas in pairs(self.allMapDatas) do
      self:RefreshSymbolsByType(type)
    end
  else
    for type, _ in pairs(self.dirtyMap) do
      self:RefreshSymbolsByType(type)
    end
    TableUtility.TableClear(self.dirtyMap)
  end
  self.mapInfoChanged = false
end

function BWMiniMapWindow:EnableDrag(b)
  if not self.mapDragScrollView then
    self.mapDragScrollView = self.mapTexture:GetComponent(UIDragScrollView)
    self.lmapDragScrollView = self.lMapTexture:GetComponent(UIDragScrollView)
    self.rmapDragScrollView = self.rMapTexture:GetComponent(UIDragScrollView)
  end
  self.mapDragScrollView.enabled = b
  self.lmapDragScrollView.enabled = b
  self.rmapDragScrollView.enabled = b
end

function BWMiniMapWindow:SetUpdateEvent(event, owner)
  self.updateEvent = event
  self.updateEventOwner = owner
end

function BWMiniMapWindow:Update(time, deltaTime)
  self:UpdateMyPos()
  self:UpdateFocusArrowPos()
  self:UpdateCameraPos()
  if not self.refreshSymbolTime or UnityTime - self.refreshSymbolTime > 1 then
    self.refreshSymbolTime = UnityTime
    self:RefreshMapSymbols()
  end
  if self.updateEvent then
    self.updateEvent(self.updateEventOwner, self)
  end
end

function BWMiniMapWindow:UpdateMyPos(forceUpdate)
  local role = _Game.Myself
  if role then
    local nowMyPos = role:GetPosition()
    if not nowMyPos then
      return
    end
    if forceUpdate or DistanceXZ_Square(self.lastMyPos, nowMyPos) > 1.0E-4 then
      self:HelpUpdatePos(self.myTrans, nowMyPos)
      local angleY = role:GetAngleY()
      if angleY then
        LuaQuaternion.Better_SetEulerAngles(tempRot, _LuaGeometry.GetTempVector3(0, 0, -angleY))
        self.myTrans.rotation = tempRot
      end
      self.iMoved = true
      LuaVector3.Better_Set(self.lastMyPos, nowMyPos[1], 0, nowMyPos[3])
    else
      self.iMoved = false
    end
  end
end

local dirV3 = LuaVector3()

function BWMiniMapWindow:ForceUpdateFocusArrowPos()
  self.questFocusDirty = true
  self:UpdateFocusArrowPos()
end

function BWMiniMapWindow:UpdateFocusArrowPos()
  if not self.updateFocusArrow then
    return
  end
  if not self.questFocusDirty and not self.vMoved and not self.iMoved then
    return
  end
  self.questFocusDirty = false
  local cacheMap = self:GetSymbolObjMap(Type.QuestFocus)
  local myPos_x, myPos_y = GetLocalPosition(self.myTrans)
  for key, focus in pairs(cacheMap) do
    local pHalfSize_x, pHalfSize_y = self.panelSize[1] / 2, self.panelSize[2] / 2
    local focusPos_x, focusPos_y = GetLocalPosition(focus.transform)
    local arrow = self.focusArrowMap[key]
    local clipOffset = self.mapPanel.clipOffset
    local outSight = pHalfSize_x < math.abs(focusPos_x - clipOffset.x) or pHalfSize_y < math.abs(focusPos_y - clipOffset.y)
    if outSight then
      local myOutSight = pHalfSize_x < math.abs(myPos_x - clipOffset.x) or pHalfSize_y < math.abs(myPos_y - clipOffset.y)
      if myOutSight then
        myPos_x = clipOffset.x
        myPos_y = clipOffset.y
      end
      LuaVector3.Better_Set(dirV3, focusPos_x - myPos_x, focusPos_y - myPos_y, 0)
      local dx = dirV3[1] > 0 and 1 or -1
      local dy = dirV3[2] > 0 and 1 or -1
      pHalfSize_x = math.abs(dx * pHalfSize_x - (myPos_x - clipOffset.x))
      pHalfSize_y = math.abs(dy * pHalfSize_y - (myPos_y - clipOffset.y))
      focus:SetActive(false)
      local tsfArrow
      if Slua.IsNull(arrow) then
        arrow = self:GetMapSymbol("map_dir", 100, nil, self.self_symbolParent)
        tsfArrow = arrow.transform
        tsfArrow.localScale = _LuaGeometry.GetTempVector3(1.5, 1.5, 1.5)
        self.focusArrowMap[key] = arrow
      else
        tsfArrow = arrow.transform
      end
      local pct = 1
      if math.abs(dirV3[2]) / math.abs(dirV3[1]) > math.abs(pHalfSize_y) / math.abs(pHalfSize_x) then
        pct = (pHalfSize_y - 10) / math.abs(dirV3[2])
      else
        pct = (pHalfSize_x - 10) / math.abs(dirV3[1])
      end
      tsfArrow.localPosition = _LuaGeometry.GetTempVector3(dirV3[1] * pct + myPos_x, dirV3[2] * pct + myPos_y, 0)
      LuaVector3.Better_Set(tempV3, 0, 1, 0)
      local angle = LuaVector3.Angle(tempV3, dirV3)
      angle = dirV3[1] > 0 and -angle or angle
      LuaQuaternion.Better_SetEulerAngles(tempRot, _LuaGeometry.GetTempVector3(0, 0, angle))
      tsfArrow.localRotation = tempRot
      if self.needFocusFrameMap[key] then
        self:PlayFocusFrameEffect(key)
      end
    else
      if self.isShowCircleArea then
        focus:SetActive(false)
      else
        focus:SetActive(true)
      end
      self:RemoveMiniMapSymbol(arrow)
      self.focusArrowMap[key] = nil
    end
  end
end

function BWMiniMapWindow._AdjustEffectTextureDepth(go)
  local sps = UIUtil.GetAllComponentsInChildren(go, UITexture)
  local minDepth = 50
  for i = 1, #sps do
    sps[i].depth = minDepth + sps[i].depth % 10
  end
end

function BWMiniMapWindow._PlayFocusFrameEffect(effectHandle, args)
  if effectHandle and args then
    effectHandle.transform.position = _LuaGeometry.GetTempVector3(args[1], args[2], args[3])
    BWMiniMapWindow._AdjustEffectTextureDepth(effectHandle.gameObject)
  end
end

function BWMiniMapWindow:PlayFocusFrameEffect(id)
  local parent = FloatingPanel.Instance.gameObject
  if not id or Slua.IsNull(parent) then
    return
  end
  local cacheMap = self:GetSymbolObjMap(Type.QuestFocus)
  local focus = cacheMap[id]
  if Slua.IsNull(focus) then
    return
  end
  local pos_x, pos_y, pos_z
  local focusPos_x, focusPos_y = LuaGameObject.InverseTransformPointByTransform(self.dPanel.transform, focus.transform, Space.World)
  local myPos_x, myPos_y = LuaGameObject.InverseTransformPointByTransform(self.dPanel.transform, self.trans, Space.World)
  local pHalfSize_x, pHalfSize_y = self.panelSize[1] / 2, self.panelSize[2] / 2
  if pHalfSize_x < math.abs(focusPos_x - myPos_x) or pHalfSize_y < math.abs(focusPos_y - myPos_y) then
    local arrow = self.focusArrowMap[id]
    if Slua.IsNull(arrow) then
      self.needFocusFrameMap[id] = true
      return
    else
      self.needFocusFrameMap[id] = nil
      pos_x, pos_y, pos_z = GetPosition(arrow.transform)
    end
  else
    pos_x, pos_y, pos_z = GetPosition(focus.transform)
  end
  if pos_x and pos_y and pos_z then
    local args = {
      pos_x,
      pos_y,
      pos_z
    }
    self:PlayUIEffect(EffectMap.UI.MapPoint, parent, true, BWMiniMapWindow._PlayFocusFrameEffect, args)
  end
end

function BWMiniMapWindow:RemoveQuestFocusByQuestId(questId)
  self:RemoveSymbolImmediate(Type.QuestFocus, questId)
end

local changeIntegerToAlphabet = function(i)
  if 64 <= i then
    return
  end
  return string.char(math.floor(i + 64))
end

function BWMiniMapWindow.SetLetterOfExitPoint(epLabel, data)
  if not epLabel or not data then
    return
  end
  epLabel.text = changeIntegerToAlphabet(data:GetParama("index")) or ""
end

function BWMiniMapWindow:_CreateExitPoint(data)
  local symbolObj = self:GetMapSymbol(data:GetParama("Symbol"), 6, nil, self.d_symbolParent)
  if not IsNull(symbolObj) then
    symbolObj.gameObject:SetActive(data:GetParama("active"))
    local nextSceneID = data:GetParama("nextSceneID")
    if nextSceneID then
      local info = self:CopyGameObject(self.mapLabel, symbolObj.transform)
      if info then
        info.name = tostring(nextSceneID)
        SetLocalScaleObj(info, 0.85, 0.85, 0.85)
        local label = info:GetComponent(UILabel)
        label.depth = 31
        label.skipTranslation = true
        BWMiniMapWindow.SetLetterOfExitPoint(label, data)
      end
    end
  end
  return symbolObj
end

function BWMiniMapWindow:_UpdateExitPoint(symbolObj, data)
  if not IsNull(symbolObj) then
    symbolObj.gameObject:SetActive(data:GetParama("active"))
    local sp = symbolObj.gameObject:GetComponent(UISprite)
    sp.spriteName = data:GetParama("Symbol")
    local info = symbolObj.transform:GetChild(0)
    local nextSceneID = data:GetParama("nextSceneID")
    if info and info.name ~= tostring(nextSceneID) then
      info.name = tostring(nextSceneID)
      BWMiniMapWindow.SetLetterOfExitPoint(info:GetComponent(UILabel), data)
    end
  end
  return symbolObj
end

function BWMiniMapWindow:_RemoveExitPoint(key, symbolObj)
  if Slua.IsNull(symbolObj) then
    return
  end
  LuaGameObject.DestroyGameObject(symbolObj.transform:GetChild(0))
  self:RemoveMiniMapSymbol(symbolObj)
end

local ServerNpcSymbolPath = ResourcePathHelper.UICell("MiniMapSymbol_ServerNpc")

function BWMiniMapWindow:_CreateServerNpcPoint(data)
  local symbol = _Game.AssetManager_UI:CreateAsset(ServerNpcSymbolPath, self.s_symbolParent)
  if not IsNull(symbol) then
    symbol:SetActive(true)
    symbol.transform.localRotation = _LuaGeometry.Const_Qua_identity
    symbol.transform.localScale = _LuaGeometry.Const_V3_one
    if IsRunOnEditor then
      symbol.name = "MiniMapSymbol_ServerNpc_" .. data.id
    end
    if self.serverNpcMap == nil then
      self.serverNpcMap = {}
    end
    self.serverNpcMap[data.id] = MiniMapSymbol.new(symbol, data)
    self:_UpdateServerNpcPoint(symbol, data)
  end
  return symbol
end

function BWMiniMapWindow:_UpdateServerNpcPoint(obj, data)
  if obj and data and self.serverNpcMap then
    local symbol = self.serverNpcMap[data.id]
    if symbol then
      symbol:SetData(data)
    end
  end
  return obj
end

function BWMiniMapWindow:_RemoveServerNpcPoint(id, symbolObj)
  if not Slua.IsNull(symbolObj) then
    _Game.GOLuaPoolManager:AddToUIPool(ServerNpcSymbolPath, symbolObj)
  end
  if self.serverNpcMap then
    self.serverNpcMap[id] = nil
  end
end

function BWMiniMapWindow:UpdateServerNpcPointMap(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.ServerNpc, datas, isRemoveOther)
end

function BWMiniMapWindow:UpdateTeamMemberSymbol(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.TeamMember, datas, isRemoveOther)
end

function BWMiniMapWindow:RemoveTeamMemberSymbol(key)
  self:RemoveSymbolImmediate(Type.TeamMember, key)
end

function BWMiniMapWindow:_UpdateTeamSymbol(obj, data)
  if not IsNull(obj) then
    local symbol = data:GetParama("Symbol")
    local sp = obj:GetComponent(UISprite)
    if sp.spriteName ~= symbol then
      sp.spriteName = symbol
    end
  end
  return obj
end

function BWMiniMapWindow:UpdateQuestNpcSymbol(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.QuestNpc, datas, isRemoveOther)
end

function BWMiniMapWindow:ClickWorldQuestButton(button)
  local data = button.questId
  local questData = QuestProxy.Instance:GetQuestDataBySameQuestID(data)
  if questData then
    TipsView.Me():ShowStickTip(QuestDetailTip, questData, NGUIUtil.AnchorSide.TopLeft, button.sprIcon, {0, 0})
  else
    redlog("任务ID" .. data .. "找不到任务信息")
  end
end

function BWMiniMapWindow:_CreateQuestNpcSymbol(data)
  local symbolType = data:GetParama("SymbolType")
  local config = QuestSymbolConfig[symbolType]
  local symbolKey = config and config.UISymbol
  symbolKey = symbolKey or "44map_icon_talk"
  local symbolPath = ResourcePathHelper.EffectUI(symbolKey)
  local obj = _Game.AssetManager_UI:CreateAsset(symbolPath, self.d_symbolParent)
  if symbolType == 20 or symbolType == 24 or symbolType == 25 then
    local clickableIcon = MiniMapWorldQuestButton.new(obj)
    clickableIcon:SetData(data:GetParama("questId"))
    clickableIcon:AddEventListener(MouseEvent.MouseClick, self.OnClickMiniMap, self)
    local longPress = obj:GetComponent(UILongPress)
    if longPress then
      function longPress.pressEvent()
        self:ClickWorldQuestButton(clickableIcon)
      end
    end
  end
  if IsNull(obj) then
    redlog("ERROR SYMBOL:", symbolPath)
    return
  end
  if not config.UISymbol and config and config.UISpriteName then
    local sprite = obj:GetComponent(UISprite)
    IconManager:SetMapIcon(config.UISpriteName, sprite)
    sprite:MakePixelPerfect()
  end
  obj.name = symbolType
  if IsRunOnEditor then
    local info = self:FindGO("info", obj)
    local questData = QuestProxy.Instance:getQuestDataByIdAndType(data:GetParama("questId"), SceneQuest_pb.EQUESTLIST_ACCEPT)
    local infoName = string.format("%s-%s-%s-%s", data.id, questData and questData.staticData.QuestName or "NODATA", data:GetParama("npcid"), data:GetParama("uniqueid"))
    if info == nil then
      info = GameObject(infoName)
      info.transform:SetParent(obj.transform, false)
    else
      info.name = infoName
    end
  end
  local widget = UIUtil.GetAllComponentInChildren(obj, UIWidget)
  if widget then
    widget.depth = 11
  end
  return obj
end

function BWMiniMapWindow:_UpdateQuestNpcSymbol(obj, data)
  if obj then
    local symbolType = data:GetParama("SymbolType")
    if obj.name ~= tostring(symbolType) then
      self:RemoveMiniMapSymbol(obj)
      obj = self:_CreateQuestNpcSymbol(data)
    end
    if IsRunOnEditor then
      local info = obj.transform:GetChild(0)
      local questData = QuestProxy.Instance:getQuestDataByIdAndType(data:GetParama("questId"), SceneQuest_pb.EQUESTLIST_ACCEPT)
      local infoName = string.format("%s-%s-%s-%s", data.id, questData and questData.staticData.QuestName or "NODATA", data:GetParama("npcid"), data:GetParama("uniqueid"))
      if info == nil then
        info = GameObject(infoName)
        info.transform:SetParent(obj.transform, false)
      else
        info.gameObject.name = infoName
      end
    end
    self:HelpUpdatePos(obj, data.pos)
  end
  return obj
end

function BWMiniMapWindow:_RemoveQuestNpcSymbol(id, symbolObj)
  if IsNull(symbolObj) then
    return
  end
  local symbolType = symbolObj.name
  local config = QuestSymbolConfig[symbolType]
  if config and config.UISymbol then
    local symbolPath = ResourcePathHelper.EffectUI(config.UISymbol)
    _Game.AssetManager_UI:AddToUIPool(symbolPath, symbolObj)
  else
    LuaGameObject.DestroyObject(symbolObj)
  end
end

function BWMiniMapWindow:UpdateQuestFocuses(datas, isRemoveOther)
  self.questFocusDirty = true
  self:UpdateMapSymbolDatas(Type.QuestFocus, datas, isRemoveOther)
end

function BWMiniMapWindow:ActiveFocusArrowUpdate(b)
  self.updateFocusArrow = b
end

local QUEST_FOCUS_PATH = ResourcePathHelper.EffectUI(EffectMap.UI.MapIndicates)

function BWMiniMapWindow:_CreateQuestFocus(data)
  local obj = _Game.AssetManager_UI:CreateAsset(QUEST_FOCUS_PATH, self.self_symbolParent)
  BWMiniMapWindow._AdjustEffectTextureDepth(obj)
  local hideSymbol = data:GetParama("hideSymbol")
  if hideSymbol then
    obj:SetActive(false)
  else
    obj:SetActive(true)
  end
  SetLocalScaleObj(obj, 1, 1, 1)
  local questId = data:GetParama("questId")
  obj.name = tostring(questId)
  self.questFocusDirty = true
  return obj
end

function BWMiniMapWindow:_UpdateQuestFocus(obj, data)
  local hideSymbol = data:GetParama("hideSymbol")
  if hideSymbol then
    obj:SetActive(false)
  else
    obj:SetActive(true)
    self:HelpUpdatePos(obj.transform, data.pos)
  end
  return obj
end

function BWMiniMapWindow:_RemoveQuestFocus(key, symbolObj)
  self.questFocusDirty = true
  if not IsNull(symbolObj) then
    _Game.GOLuaPoolManager:AddToUIPool(QUEST_FOCUS_PATH, symbolObj)
  end
  if not key then
    return
  end
  local arrow = self.focusArrowMap[key]
  if not IsNull(arrow) then
    self:RemoveMiniMapSymbol(arrow)
  end
  self.focusArrowMap[key] = nil
end

function BWMiniMapWindow:UpdateLocalNpcPos(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.LocalNpc, datas, isRemoveOther)
end

function BWMiniMapWindow:_CreateLocalNpcPosSymbol(data)
  local symbol = self:GetMapSymbol(data:GetParama("Symbol"), data:GetParama("depth"), 1.5, self.d_symbolParent)
  symbol.name = tostring(data.id)
  return symbol
end

function BWMiniMapWindow:UpdateScenicSpotSymbol(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.ScenicSpot, datas, isRemoveOther)
end

function BWMiniMapWindow:_CreateScenicSpot(data)
  local symbol = data:GetParama("Symbol")
  local obj = self:GetMapSymbol(symbol, 6, nil, self.d_symbolParent)
  obj.name = symbol
  return obj
end

function BWMiniMapWindow:_UpdateScenicSpot(obj, data)
  if not IsNull(obj) then
    local symbol = data:GetParama("Symbol")
    if symbol ~= obj.name then
      local sp = obj:GetComponent(UISprite)
      sp.spriteName = symbol
      obj.name = symbol
    end
  end
  return obj
end

function BWMiniMapWindow:UpdateSealSymbol(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.Seal, datas, isRemoveOther)
end

function BWMiniMapWindow:_CreateSealSymbol(data)
  local symbol = data:GetParama("Symbol")
  local obj = self:GetMapSymbol(symbol, 8)
  obj.name = symbol
  return obj
end

function BWMiniMapWindow:_UpdateSealSymbol(obj, data)
  if not IsNull(obj) then
    local symbol = data:GetParama("Symbol")
    if symbol ~= obj.name then
      local sp = obj:GetComponent(UISprite)
      sp.spriteName = symbol
      obj.name = symbol
    end
  end
  return obj
end

local MonsterPoint_Path = ResourcePathHelper.UICell("MiniMapSymbol_Monster")

function BWMiniMapWindow:UpdateWorldQuestTreasure(data, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.WorldQuestTreasure, data, isRemoveOther)
end

function BWMiniMapWindow:_CreateWorldQuestTreasure(data)
  local go = _Game.AssetManager_UI:CreateAsset(MonsterPoint_Path, self.d_symbolParent)
  self:_UpdateWorldQuestTreasure(go, data)
  return go
end

function BWMiniMapWindow:_UpdateWorldQuestTreasure(obj, data)
  if IsNull(obj) then
    return
  end
  local symbol = data:GetParama("Symbol") or ""
  local depth = data:GetParama("depth") or 0
  obj.name = data:GetParama("npcid")
  local sp = obj:GetComponent(UISprite)
  IconManager:SetMapIcon(symbol, sp)
  sp.depth = depth + 22
  local bg = self:FindGO("Bg", obj)
  bg:SetActive(false)
  sp:MakePixelPerfect()
  sp.width = sp.width * 0.8
  sp.height = sp.height * 0.8
  return obj
end

function BWMiniMapWindow:_RemoveWorldQuestTreasure(key, symbolObj)
  if IsNull(symbolObj) then
    return
  end
  _Game.GOLuaPoolManager:AddToUIPool(MonsterPoint_Path, symbolObj)
end

function BWMiniMapWindow:_CreateMonsterPoints(data, key)
  local go = _Game.AssetManager_UI:CreateAsset(MonsterPoint_Path, self.monster_symbolParent)
  self:_UpdateMonsterPoints(go, data, key)
  return go
end

local Format_MonsterObjId = function(symbol, depth, monster_icon)
  return string.format("%s_%s_%s", symbol, depth or "", monster_icon or "")
end

function BWMiniMapWindow:_UpdateMonsterPoints(obj, data, key)
  local symbol = data:GetParama("Symbol") or ""
  local depth = data:GetParama("depth") or 0
  local monsterIcon = data:GetParama("monster_icon")
  local iconSize = data:GetParama("iconSize")
  local objId = Format_MonsterObjId(symbol, depth, monsterIcon)
  if self.mapDataInfoCache[key] == objId then
    return obj
  end
  self.mapDataInfoCache[key] = objId
  local sp = obj:GetComponent(UISprite)
  sp.depth = depth + 22
  local bg = self:FindGO("Bg", obj)
  if bg then
    bg:SetActive(monsterIcon ~= nil)
  end
  if monsterIcon ~= nil then
    IconManager:SetFaceIcon(monsterIcon, sp)
    sp:MakePixelPerfect()
    if iconSize ~= 1 then
      sp.width = sp.width * (iconSize or 0.35)
      sp.height = sp.height * (iconSize or 0.35)
    end
  else
    IconManager:SetMapIcon(symbol, sp)
    sp:MakePixelPerfect()
    if iconSize ~= 1 then
      sp.width = sp.width * (iconSize or 0.6)
      sp.height = sp.height * (iconSize or 0.6)
    end
  end
  if self.mapScale and self.mapScale ~= BWMiniMapWindow.MAPSCALE_NORMAL then
    local symbolPct = self.mapScale * 0.5 + 0.5
    SetLocalScaleObj(obj, 1, 1, 1)
  end
  return obj
end

function BWMiniMapWindow:_RemoveMonsterPoints(key, symbolObj)
  self.mapDataInfoCache[key] = nil
  if Slua.IsNull(symbolObj) then
    return
  end
  _Game.GOLuaPoolManager:AddToUIPool(MonsterPoint_Path, symbolObj)
end

function BWMiniMapWindow:UpdateMonstersPoses(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.Monster, datas, isRemoveOther, 1)
end

function BWMiniMapWindow:UpdateMvpPoses(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.MVP, datas, isRemoveOther, 1)
end

function BWMiniMapWindow:UpdateFakeDragonPoses(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.FakeDragon, datas, isRemoveOther, 1)
end

function BWMiniMapWindow:UpdateFixedTreasurePoses(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.FixedTreasure, datas, isRemoveOther)
end

function BWMiniMapWindow:_CreateFixedTreasurePoints(data, key)
  local go = _Game.AssetManager_UI:CreateAsset(MonsterPoint_Path, self.self_symbolParent)
  self:_UpdateFixedTreasurePoints(go, data, key)
  return go
end

function BWMiniMapWindow:_UpdateFixedTreasurePoints(obj, data, key)
  local symbol = data:GetParama("Symbol") or ""
  local depth = data:GetParama("depth") or 0
  local objId = Format_MonsterObjId(symbol, depth, monsterIcon)
  if self.mapDataInfoCache[key] == objId then
    return obj
  end
  self.mapDataInfoCache[key] = objId
  local sp = obj:GetComponent(UISprite)
  IconManager:SetMapIcon(symbol, sp)
  sp.depth = depth + 22
  local bg = self:FindGO("Bg", obj)
  bg:SetActive(false)
  sp:MakePixelPerfect()
  sp.width = sp.width * 0.8
  sp.height = sp.height * 0.8
  return obj
end

function BWMiniMapWindow:_RemoveFixedTreasurePoints(key, symbolObj)
  self.mapDataInfoCache[key] = nil
  if IsNull(symbolObj) then
    return
  end
  _Game.GOLuaPoolManager:AddToUIPool(MonsterPoint_Path, symbolObj)
end

function BWMiniMapWindow:UpdateTreePoints(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.TreePoints, datas, isRemoveOther)
end

function BWMiniMapWindow:RemoveTreePoint(key)
  self:RemoveSymbolImmediate(Type.TreePoints, key)
end

function BWMiniMapWindow:UpdatePlayerPoses(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.Player, datas, isRemoveOther)
end

function BWMiniMapWindow:_CreatePlayerPoints(data)
  if not IsNull(self.gameObject) then
    local symbolName = data:GetParama("Symbol")
    local depth = data:GetParama("depth")
    local symbol = self:GetMapSymbol(symbolName, 7, 0.7)
    symbol:GetComponent(UISprite).depth = 21 + depth
    symbol:SetActive(self.monsterActive)
    return symbol
  end
end

function BWMiniMapWindow:_UpdatePlayerPoints(obj, data)
  if not IsNull(obj) then
    local symbol = data:GetParama("Symbol")
    local sp = obj:GetComponent(UISprite)
    if sp.spriteName ~= symbol then
      sp.spriteName = symbol
    end
  end
  return obj
end

function BWMiniMapWindow:UpdateMapCircleAreas(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.CIRCLE, datas, isRemoveOther)
end

function BWMiniMapWindow:_CreateMapCircleArea(data)
  local texture = self.mapTexture.mainTexture
  if not texture then
    return
  end
  if not IsNull(self.gameObject) then
    local symbolName = data:GetParama("areaSymbol")
    local depth = data:GetParama("areaSymbolDepth")
    local radius = data:GetParama("radius")
    if symbolName then
      local symbol = self:GetMapSymbol(symbolName, depth, radius, self.d_symbolParent)
      symbol.transform.localScale = _LuaGeometry.GetTempVector3(self.mapsize.x / texture.width, self.mapsize.y / texture.height, 1)
      self.isShowCircleArea = true
      return symbol
    end
  end
end

function BWMiniMapWindow:_RemoveMapCircleArea(id, symbolObj)
  self:RemoveMiniMapSymbol(symbolObj)
  self.isShowCircleArea = false
end

function BWMiniMapWindow:GetCurTransmitterGroup()
  local mapid = _Game.MapManager:GetMapID()
  for id, transferData in pairs(Table_DeathTransferMap) do
    if mapid == transferData.MapID then
      return transferData.MapGroup
    end
  end
  return nil
end

function BWMiniMapWindow:UpdateTransmitterPoints()
  if self.transmitterButtons == nil then
    self.transmitterButtons = {}
  else
    TableUtility.TableClearByDeleter(self.transmitterButtons, MiniMapDataRemoveFunc)
  end
  if self.blockUnlockInfo == nil then
    self.blockUnlockInfo = {}
  else
    TableUtility.TableClear(self.blockUnlockInfo)
  end
  local curGroupID = self:GetCurTransmitterGroup()
  local curIsMainTransfer, isAllActivated = false, true
  local activePoints = WorldMapProxy.Instance.activeTransmitterPoints
  local transferPoint, transferID, found
  local mapDatas = WorldMapProxy.Instance:GetTransmitterMapByGroup(curGroupID)
  local curMapID = _Game.MapManager:GetMapID()
  if mapDatas then
    local cellState, tarIsMainTransfer, buttonData, button
    for mapID, transfers in pairs(mapDatas) do
      for i = 1, #transfers do
        transferPoint = transfers[i]
        if transferPoint.MapID == curMapID then
          transferID = transferPoint.id
          self.blockUnlockInfo[i] = activePoints[transferID] == 1
          local buttonData = MiniMapData.CreateAsTable(transferID)
          local cellState
          if activePoints[transferID] == 1 then
            cellState = MiniMapTransmitterButton.E_State.Activated
          else
            cellState = MiniMapTransmitterButton.E_State.Unactivated
          end
          local staticData = {staticdata = transferPoint, state = cellState}
          buttonData:SetPos(transferPoint.Position[1], transferPoint.Position[2], transferPoint.Position[3])
          buttonData:SetParama("index", transferPoint.id)
          buttonData:SetParama("data", staticData)
          self.transmitterButtons[transferPoint.id] = buttonData
        end
      end
    end
  end
  self:UpdateTransmitterButton(self.transmitterButtons, nil, true)
end

function BWMiniMapWindow:RemoveTransmitterPoints()
  self:UpdateTransmitterButton(_EmptyTable, nil)
end

function BWMiniMapWindow:UpdateTransmitterButton(datas, isRemoveOther, forceUpdate)
  local checkDistance
  if forceUpdate then
    checkDistance = -1
  end
  self:UpdateMapSymbolDatas(Type.Transmitter, datas, isRemoveOther, checkDistance)
end

function BWMiniMapWindow:_CreateTransmitterButton(data)
  local symbolObj = self:CreateTransmitterSymbolButton(data)
  symbolObj.name = data:GetParama("name")
  return symbolObj
end

function BWMiniMapWindow:CreateTransmitterSymbolButton(data)
  local obj = _Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("MiniMapTransmitterButton"))
  local button = MiniMapTransmitterButton.new(obj)
  button.name = "MiniMapTransmitterButton_" .. tostring(data:GetParama("index"))
  button.trans:SetParent(self.d_symbolParent, false)
  button:SetData(data:GetParama("data"))
  button:AddEventListener(MouseEvent.MouseClick, self.ClickTransmitterButton, self)
  return obj
end

function BWMiniMapWindow:_UpdateTransmitterButton(obj, data)
  if not IsNull(obj) then
    local button = MiniMapTransmitterButton.new(obj)
    button.trans:SetParent(self.d_symbolParent, false)
    button:SetData(data:GetParama("data"))
    button:AddEventListener(MouseEvent.MouseClick, self.ClickTransmitterButton, self)
  end
  self:HelpUpdatePos(obj, data.pos)
  return obj
end

function BWMiniMapWindow:_RemoveTransmitterButton(key, symbolObj)
  LuaGameObject.DestroyObject(symbolObj)
end

function BWMiniMapWindow:ClickTransmitterButton(button)
  self:PassEvent(BWMiniMapWindow.Event.ClickTransmitterButton, button)
end

local AreaTips_Path = ResourcePathHelper.UICell("MiniMapSymbol_AreaTips")

function BWMiniMapWindow:_CreateAreaTips(data)
  local symbol = _Game.AssetManager_UI:CreateAsset(AreaTips_Path, self.d_symbolParent)
  if not IsNull(symbol) then
    if IsRunOnEditor then
      symbol.name = "MiniMapSymbol_AreaTips" .. data.id
    end
    symbol:SetActive(true)
    symbol.transform.localRotation = _LuaGeometry.Const_Qua_identity
    symbol.transform.localScale = _LuaGeometry.Const_V3_one
    self:_UpdateAreaTips(symbol, data)
  end
  return symbol
end

function BWMiniMapWindow:_UpdateAreaTips(symbolObj, data)
  local label = symbolObj:GetComponent(UILabel)
  label.text = data:GetParama("Text") or ""
  label.depth = data:GetParama("depth") or 10
  label.fontSize = 18
  return symbolObj
end

local ZoneTips_Path = ResourcePathHelper.UICell("MiniMapSymbol_AreaTips")

function BWMiniMapWindow:_CreateZoneTips(data)
  local symbol = _Game.AssetManager_UI:CreateAsset(ZoneTips_Path, self.d_symbolParent)
  if not IsNull(symbol) then
    if IsRunOnEditor then
      symbol.name = "MiniMapSymbol_ZoneTips" .. data.id
    end
    symbol:SetActive(true)
    symbol.transform.localRotation = _LuaGeometry.Const_Qua_identity
    symbol.transform.localScale = _LuaGeometry.Const_V3_one
    self:_UpdateZoneTips(symbol, data)
  end
  return symbol
end

function BWMiniMapWindow:_UpdateZoneTips(symbolObj, data)
  local label = symbolObj:GetComponent(UILabel)
  label.text = data:GetParama("Text") or ""
  label.depth = data:GetParama("depth") or 10
  label.fontSize = 16
  return symbolObj
end

local ZoneBlock_Path = ResourcePathHelper.UICell("MiniMapSymbol_ZoneBlock")

function BWMiniMapWindow:_CreateZoneBlock(data)
  local symbol = _Game.AssetManager_UI:CreateAsset(ZoneBlock_Path, self.d_symbolParent)
  if not IsNull(symbol) then
    if IsRunOnEditor then
      symbol.name = "MiniMapSymbol_ZoneBlock" .. data.id
    end
    symbol:SetActive(true)
    symbol.transform.localRotation = _LuaGeometry.Const_Qua_identity
    symbol.transform.localScale = _LuaGeometry.Const_V3_one
    local tex = symbol:GetComponent(UITexture)
    if not IsNull(tex) then
      tex.gameObject.name = ""
    end
    self:_UpdateZoneBlock(symbol, data)
  end
  return symbol
end

function BWMiniMapWindow:_UpdateZoneBlock(symbolObj, data)
  local tex = symbolObj:GetComponent(UITexture)
  local texName = data:GetParama("Texture") or ""
  local oldName = tex.gameObject.name
  if texName ~= oldName then
    if oldName ~= "" then
      _PictureManager:UnLoadMiniMap(oldName, tex)
    end
    if texName ~= "" then
      _PictureManager:SetMiniMap(texName, tex)
      tex.gameObject.name = texName
      local pct = self.mapsize.x / 1024
      tex:MakePixelPerfect()
      tex.width = tex.width * pct
      tex.height = tex.height * pct
    end
  end
  tex.depth = data:GetParama("depth") or 10
  tex.alpha = data:GetParama("unlocked") and 0 or 1
  return symbolObj
end

function BWMiniMapWindow:_RemoveZoneBlock(id, symbolObj)
  local tex = symbolObj:GetComponent(UITexture)
  local oldName = tex.gameObject.name
  if oldName ~= "" then
    _PictureManager:UnLoadMiniMap(oldName, tex)
  end
  self:RemoveMiniMapSymbol(symbolObj)
end

function BWMiniMapWindow:UpdateWildMvpSymbols(isRemoveOther, forceUpdate)
  local datas = WildMvpProxy.Instance:GetCurMiniMapMonsterData()
  if datas then
    local checkDistance
    if forceUpdate then
      checkDistance = -1
    end
    self:UpdateMapSymbolDatas(Type.WildMvp, datas, isRemoveOther, checkDistance)
  end
end

function BWMiniMapWindow:UpdateWildMvpSymbolProgress()
  if self.wildMvpSymbols then
    for _, v in pairs(self.wildMvpSymbols) do
      if v then
        v:UpdateProgress()
      end
    end
  end
end

local WildMvpSymbolPath = ResourcePathHelper.UICell("MiniMapSymbol_WildMvp")

function BWMiniMapWindow:_CreateWildMvpSymbol(data)
  local symbol = _Game.AssetManager_UI:CreateAsset(WildMvpSymbolPath, self.s_symbolParent)
  if not IsNull(symbol) then
    symbol:SetActive(true)
    symbol.transform.localRotation = _LuaGeometry.Const_Qua_identity
    symbol.transform.localScale = _LuaGeometry.Const_V3_one
    if self.wildMvpSymbols == nil then
      self.wildMvpSymbols = {}
    end
    self.wildMvpSymbols[data.id] = WildMvpMapSymbol.new(symbol, data)
    self:_UpdateWildMvpSymbol(symbol, data)
  end
  return symbol
end

function BWMiniMapWindow:_UpdateWildMvpSymbol(obj, data)
  if obj and data and self.wildMvpSymbols then
    local symbol = self.wildMvpSymbols[data.id]
    symbol:SetData(data)
  end
  return obj
end

function BWMiniMapWindow:_RemoveWildMvpSymbol(id, symbolObj)
  if not Slua.IsNull(symbolObj) then
    _Game.GOLuaPoolManager:AddToUIPool(WildMvpSymbolPath, symbolObj)
  end
  if self.wildMvpSymbols then
    self.wildMvpSymbols[id] = nil
  end
end

function BWMiniMapWindow:_CreateYahahaSymbol(data)
  local symbol = data:GetParama("Symbol")
  local obj = self:GetMapSymbol(symbol, 6, nil, self.d_symbolParent)
  obj.name = symbol
  self:_UpdateYahahaSymbol(obj, data)
  return obj
end

function BWMiniMapWindow:_UpdateYahahaSymbol(obj, data)
  if not IsNull(obj) then
    local symbol = data:GetParama("Symbol")
    local sp = obj:GetComponent(UISprite)
    if symbol ~= obj.name then
      sp.spriteName = symbol
      obj.name = symbol
    end
    local depth = data:GetParama("Depth")
    if depth then
      sp.depth = depth
    end
  end
  return obj
end

function BWMiniMapWindow:UpdateYahahaSymbol(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.Yahaha, datas, isRemoveOther)
end

function BWMiniMapWindow:_CreateFakeDragonSymbol(data)
  local go = _Game.AssetManager_UI:CreateAsset(MonsterPoint_Path, self.monster_symbolParent)
  self:_UpdateFakeDragonSymbol(go, data)
  return go
end

function BWMiniMapWindow:_UpdateFakeDragonSymbol(obj, data)
  if not IsNull(obj) then
    local symbol = data:GetParama("Symbol")
    local sp = obj:GetComponent(UISprite)
    if symbol ~= obj.name then
      sp.spriteName = symbol
      obj.name = symbol
      IconManager:SetMapIcon("map_icon_shikonglong", sp)
      sp:MakePixelPerfect()
    end
    local depth = data:GetParama("Depth")
    if depth then
      sp.depth = depth
    end
  end
  self:HelpUpdatePos(obj, data.pos)
  return obj
end

function BWMiniMapWindow:_RemoveFakeDragonSymbol(id, symbolObj)
  if not Slua.IsNull(symbolObj) then
    _Game.GOLuaPoolManager:AddToUIPool(MonsterPoint_Path, symbolObj)
  end
  return symbolObj
end

function BWMiniMapWindow:Reset()
  self:SetMapScale(1)
  self:UpdateMapTexture(nil)
  self:ClearFixedInfo()
end

function BWMiniMapWindow:OnExit()
  self:Reset()
  if self.destTransEffect then
    self.destTransEffect:Destroy()
    self.destTransEffect = nil
  end
  if self.tipTransEffect then
    self.tipTransEffect:Destroy()
    self.tipTransEffect = nil
  end
  TableUtility.TableClear(self)
end

function BWMiniMapWindow:SetMapScale(scale)
  if scale and scale ~= self.mapScale then
    if self.mapScrollView then
      self.mapScrollView:DisableSpring()
      self.mapScrollView.currentMomentum = LuaGeometry.Const_V3_zero
    end
    local pct = scale / self.mapScale
    local symbolPct = (scale * 0.5 + 0.5) / (self.mapScale * 0.5 + 0.5)
    self.mapsize.x = self.mapsize.x * pct
    self.mapsize.y = self.mapsize.y * pct
    self.mapTexture.width = self.mapsize.x
    self.mapTexture.height = self.mapsize.y
    self.mapBorderTexture.width = self.mapsize.x
    self.mapBorderTexture.height = self.mapsize.y
    NGUITools.UpdateWidgetCollider(self.mapTexture.gameObject)
    local symbol, scalePct, symbolTex
    for i = 1, self.s_symbolParent.childCount do
      symbol = self.s_symbolParent:GetChild(i - 1)
      _LuaGeometry.TempGetLocalPosition(symbol, tempV3)
      LuaVector3.Mul(tempV3, pct)
      symbol.localPosition = tempV3
      scalePct = string.find(symbol.name, "Sliced", 1, true) and pct or symbolPct
      _LuaGeometry.TempGetLocalScale(symbol, tempV3)
      LuaVector3.Mul(tempV3, scalePct)
      symbolTex = symbol:GetComponentInChildren(UITexture)
      if not IsNull(symbolTex) then
        symbolTex.width = symbolTex.width * pct
        symbolTex.height = symbolTex.height * pct
      end
    end
    for i = 1, self.d_symbolParent.childCount do
      symbol = self.d_symbolParent:GetChild(i - 1)
      _LuaGeometry.TempGetLocalPosition(symbol, tempV3)
      LuaVector3.Mul(tempV3, pct)
      symbol.localPosition = tempV3
      scalePct = string.find(symbol.name, "Sliced", 1, true) and pct or symbolPct
      _LuaGeometry.TempGetLocalScale(symbol, tempV3)
      LuaVector3.Mul(tempV3, scalePct)
      symbolTex = symbol:GetComponentInChildren(UITexture)
      if not IsNull(symbolTex) then
        symbolTex.width = symbolTex.width * pct
        symbolTex.height = symbolTex.height * pct
      end
    end
    for i = 1, self.self_symbolParent.childCount do
      symbol = self.self_symbolParent:GetChild(i - 1)
      _LuaGeometry.TempGetLocalPosition(symbol, tempV3)
      LuaVector3.Mul(tempV3, pct)
      symbol.localPosition = tempV3
      scalePct = string.find(symbol.name, "Sliced", 1, true) and pct or symbolPct
      _LuaGeometry.TempGetLocalScale(symbol, tempV3)
      LuaVector3.Mul(tempV3, scalePct)
    end
    for i = 1, self.monster_symbolParent.childCount do
      symbol = self.monster_symbolParent:GetChild(i - 1)
      _LuaGeometry.TempGetLocalPosition(symbol, tempV3)
      LuaVector3.Mul(tempV3, pct)
      symbol.localPosition = tempV3
      scalePct = string.find(symbol.name, "Sliced", 1, true) and pct or symbolPct
      _LuaGeometry.TempGetLocalScale(symbol, tempV3)
      LuaVector3.Mul(tempV3, scalePct)
    end
    _LuaGeometry.TempGetLocalPosition(self.myTrans, tempV3)
    LuaVector3.Mul(tempV3, pct)
    self.myTrans.localPosition = tempV3
    _LuaGeometry.TempGetLocalScale(self.myTrans, tempV3)
    LuaVector3.Mul(tempV3, symbolPct)
    _LuaGeometry.TempGetLocalScale(self.myTrans, tempV3)
    _LuaGeometry.TempGetLocalPosition(self.lMapTexture.transform, tempV3)
    LuaVector3.Mul(tempV3, pct)
    self.lMapTexture.transform.localPosition = tempV3
    _LuaGeometry.TempGetLocalPosition(self.rMapTexture.transform, tempV3)
    LuaVector3.Mul(tempV3, pct)
    self.rMapTexture.transform.localPosition = tempV3
    self.lMapTexture.height = self.mapsize.y
    self.rMapTexture.height = self.mapsize.y
    self.lMapBorderTexture.height = self.mapsize.y
    self.rMapBorderTexture.height = self.mapsize.y
    self.mapScale = scale
  end
end

function BWMiniMapWindow:UpdateMapBorderUnlock(forceSetValue)
  local borderUnlock = forceSetValue
  if borderUnlock == nil then
    borderUnlock = true
    for _, v in pairs(self.blockUnlockInfo) do
      if v == false then
        borderUnlock = false
        break
      end
    end
  end
  self.mapBorderTexture.alpha = borderUnlock and 0 or 1
  self.lMapBorderTexture.alpha = borderUnlock and 0 or 1
  self.rMapBorderTexture.alpha = borderUnlock and 0 or 1
end

function BWMiniMapWindow:PlayZoneBlockAlphaTween(zoneGroupId)
  local datas = self.allMapDatas[Type.ZoneBlock]
  local zoneId, zoneData
  for k, v in pairs(datas) do
    if v:GetParama("group_id") == zoneGroupId then
      zoneId = k
      zoneData = v
      break
    end
  end
  if zoneId then
    local symbol = self:GetSymbolObjMap(Type.ZoneBlock)
    symbol = symbol and symbol[zoneId]
    if IsNull(symbol) then
      return
    end
    self:CenterOnPosition(zoneData.pos, true)
    self:UpdateMapBorderUnlock(false)
    local tween = symbol:GetComponent(TweenAlpha)
    if tween then
      tween.enabled = true
      tween:ResetToBeginning()
      tween:PlayForward()
      tween:SetOnFinished(function()
        self:UpdateMapBorderUnlock()
      end)
    end
  end
end

function BWMiniMapWindow:BeginCheckSymbolHintParam()
  if not self.symbolHintParam then
    return
  end
  for type, param in pairs(self.symbolHintParam) do
    local datas = self.allMapDatas[type]
    local cacheMap = self:GetSymbolObjMap(type)
    if cacheMap and datas then
      self:CheckSymbolHintParam(cacheMap, datas, type)
    end
  end
end

local typeof = type

function BWMiniMapWindow:CheckSymbolHintParam(cacheMap, datas, type)
  if self.symbolHintParam and self.symbolHintParam[type] then
    local symbolData
    if typeof(self.symbolHintParam[type]) == "table" then
      for key, symbolObj in pairs(cacheMap) do
        symbolData = datas[key]
        if self:_CheckSymbolHintParam(symbolData, self.symbolHintParam[type], type) then
          self:RegisterSymbolHint(symbolObj, symbolData)
        end
      end
    else
      for key, symbolObj in pairs(cacheMap) do
        symbolData = datas[key]
        self:RegisterSymbolHint(symbolObj, symbolData)
      end
    end
  end
end

function BWMiniMapWindow:CenterSymbolHint(restrictWithPanel)
  if self.symbolHintCenterOnPos then
    self:CenterOnPosition(self.symbolHintCenterOnPos, restrictWithPanel)
    self.symbolHintCenterOnPos = nil
  end
end

local myselfPos
local minDisSqr = 999999

function BWMiniMapWindow:SetSymbolHintParam(param)
  if not param then
    return
  end
  myselfPos = nil
  minDisSqr = 999999
  self.symbolHintCenterOnPos = nil
  self.symbolHintCount = 0
  if not self.symbolHintParam then
    self.symbolHintParam = {}
  else
    TableUtility.TableClear(self.symbolHintParam)
  end
  if not param[1] then
    param = {param}
  end
  for _, v in pairs(param) do
    local tt = v.types or Type
    for _, t in pairs(tt) do
      if not self.symbolHintParam[t] then
        self.symbolHintParam[t] = {}
      end
      if v.icons and type(self.symbolHintParam[t]) == "table" then
        local iconhints = {}
        for _, icon in pairs(v.icons) do
          iconhints[icon] = true
        end
        self.symbolHintParam[t].icons = iconhints
        if v.activeonly then
          self.symbolHintParam[t].activeonly = 1
        end
      else
        self.symbolHintParam[t] = true
      end
    end
  end
  self:BeginCheckSymbolHintParam()
  self:BeginPlaySymbolHint()
  self:CenterSymbolHint(true)
end

function BWMiniMapWindow:RegisterSymbolHint(symbolObj, symbolData)
  if not self.registeredSymbolHint then
    self.registeredSymbolHint = {}
  end
  self.registeredSymbolHint[#self.registeredSymbolHint + 1] = {symbolObj, symbolData}
  if not myselfPos then
    myselfPos = _Game.Myself:GetPosition()
  end
  local dis = DistanceXZ_Square(myselfPos, symbolData.pos)
  if dis < minDisSqr then
    minDisSqr = dis
    self.symbolHintCenterOnPos = symbolData.pos
  end
end

local symbolHintCountMax = 20

function BWMiniMapWindow:BeginPlaySymbolHint()
  if not self.registeredSymbolHint or #self.registeredSymbolHint == 0 then
    return
  end
  table.sort(self.registeredSymbolHint, function(a, b)
    local disA = DistanceXZ_Square(self.symbolHintCenterOnPos, a[2].pos)
    local disB = DistanceXZ_Square(self.symbolHintCenterOnPos, b[2].pos)
    return disA < disB
  end)
  local playCount = math.min(#self.registeredSymbolHint, symbolHintCountMax)
  for i = 1, playCount do
    self:PlaySymbolHint(self.registeredSymbolHint[i][1], self.registeredSymbolHint[i][2])
  end
  self.registeredSymbolHint = nil
end

local symbolHintScale = 0.15

function BWMiniMapWindow:PlaySymbolHint(symbolObj, symbolData)
  local animator = symbolObj:GetComponent(Animator)
  if animator then
    animator.enabled = false
  end
  self:PlayUIEffect(EffectMap.UI.MapHintSymbol, symbolObj.gameObject, true, nil, nil, symbolHintScale)
end

function BWMiniMapWindow:_CheckSymbolHintParam(symbolData, symbolHintParam, type)
  if type == Type.QuestNpc then
    local symbolType = symbolData:GetParama("SymbolType")
    local config = QuestSymbolConfig[symbolType]
    if config then
      local symbol = config.UISpriteName or config.UISymbol
      local icons = symbolHintParam.icons
      return symbol and icons and icons[symbol]
    end
  elseif type == Type.QuestFocus then
  elseif type == Type.Transmitter then
  elseif type == Type.CIRCLE then
  elseif type == Type.WildMvp then
    local symbol = symbolData:GetActiveMapSymbolIcon()
    local activeOnly = symbolHintParam.activeonly
    if activeOnly then
      local _, isAlive = symbolData:GetMapSymbolProgress()
      if not isAlive then
        return false
      end
    end
    local icons = symbolHintParam.icons
    return symbol and icons and icons[symbol]
  elseif type == Type.AreaTips then
  elseif type == Type.ZoneTips then
  elseif type == Type.ZoneBlock then
  else
    local symbol = symbolData:GetParama("Symbol")
    return symbol and symbolHintParam[symbol]
  end
end

function BWMiniMapWindow:UpdateCameraPos()
  if FunctionCameraEffect.Me():IsFreeCameraLocked() then
    return
  end
  local cameraController = CameraController.Instance or CameraController.singletonInstance
  if not cameraController then
    return
  end
  local myPos_x, myPos_y = GetLocalPosition(self.myTrans)
  SetLocalPositionObj(self.cameraSymbol, myPos_x, myPos_y, 0)
  local eulerAngles = cameraController.cameraRotationEuler
  LuaQuaternion.Better_SetEulerAngles(tempRot, _LuaGeometry.GetTempVector3(0, 0, -eulerAngles.y + 90))
  self.cameraSymbol.transform.rotation = tempRot
end

function BWMiniMapWindow:UpdateCameraSymbol()
  if FunctionCameraEffect.Me():IsFreeCameraLocked() then
    self.cameraSymbol:SetActive(false)
  else
    self.cameraSymbol:SetActive(true)
  end
end

function BWMiniMapWindow:UpdateFakeDragonSymbol(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.FakeDragon, datas, isRemoveOther)
end
