MiniMapWindow = class("MiniMapWindow", CoreView)
autoImport("MiniMapTransmitterButton")
autoImport("MiniMapWorldQuestButton")
autoImport("WildMvpMapSymbol")
autoImport("GvgStrongHoldMapSymbol")
autoImport("MiniMapSymbol")
autoImport("GvgSymbol")
autoImport("MiniMapSymbol_FairyTale")
MiniMapWindow.MiniMapSymbolPath = ResourcePathHelper.UICell("MiniMapSymbol")
MiniMapWindow.MiniMapCustomGuildIconPath = ResourcePathHelper.UICell("MiniMapCustomGuildIcon")
MiniMapWindow.GvgSymbolPath = ResourcePathHelper.UICell("MiniMapSymbol_GvgSymbol")
MiniMapWindow.DefaultMapTextureSize = 365
MiniMapWindow.MAPSCALE_NORMAL = 1
MiniMapWindow.MAPSCALE_LARGE = 2.3
local tempV3, tempRot = LuaVector3(), LuaQuaternion()
local IsNull = Slua.IsNull
local TableClear = TableUtility.TableClear
local tableInsert = table.insert
local _Game = Game
local _LuaGeometry = LuaGeometry
local _PictureManager = PictureManager.Instance
local DistanceXZ_Square = VectorUtility.DistanceXZ_Square
local DistanceBy2Value_Square = VectorUtility.DistanceBy2Value_Square
local GetLocalPosition = LuaGameObject.GetLocalPosition
local GetPosition = LuaGameObject.GetPosition
local SetLocalPositionObj = LuaGameObject.SetLocalPositionObj
local SetLocalScaleObj = LuaGameObject.SetLocalScaleObj
local SetLocalRotationObj = LuaGameObject.SetLocalRotationObj
local IsRunOnEditor = ApplicationInfo.IsRunOnEditor()
local MonsterPoint_Path = ResourcePathHelper.UICell("MiniMapSymbol_Monster")
MiniMapWindow.Type = {
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
  GVGDroiyan = 16,
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
  TrainEscort = 37,
  TripleTeams = 38,
  EBFEventArea = 39,
  Astral = 40,
  FakeDragon = 41,
  GvgFightPoint = 42,
  GvgFriendLeaderPoint = 43,
  GvgEnemyLeaderPoint = 44,
  GvgFriendChairmanPoint = 45,
  GvgEnemyChairmanPoint = 46,
  AbyssDragon = 47,
  FairyTale = 48
}
local Type = MiniMapWindow.Type
local MiniMapDataRemoveFunc = function(data)
  data:Destroy()
end

function MiniMapWindow:ctor(go, tag, showRange)
  MiniMapWindow.super.ctor(self, go)
  self.tag = tag
  self.showRange = showRange
  self:InitDatas()
  self:InitView()
end

function MiniMapWindow:Switch(b)
  self.off = not b
end

function MiniMapWindow:IsOn()
  return not self.off
end

function MiniMapWindow:InitDatas()
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
  self.lastMapScale = 1
  self.mapDataInfoCache = {}
  self.puzzleRoomsObjAreaMap = {}
  self.puzzleRoomsColliderMap = {}
  self.puzzleRoomsStatusMap = {}
  self.abyssDragonEffectMap = {}
  self.fairyTaleSymbolMap = {}
  self:RegisterAllMapInfos()
end

function MiniMapWindow:RegisterAllMapInfos()
  self:RegisterMapInfo(Type.ExitPoint, MiniMapWindow._CreateExitPoint, MiniMapWindow._UpdateExitPoint, MiniMapWindow._RemoveExitPoint)
  self:RegisterMapInfo(Type.Npc)
  self:RegisterMapInfo(Type.ServerNpc, MiniMapWindow._CreateServerNpcPoint, MiniMapWindow._UpdateServerNpcPoint, MiniMapWindow._RemoveServerNpcPoint)
  self:RegisterMapInfo(Type.NpcWalk)
  self:RegisterMapInfo(Type.TeamMember, nil, MiniMapWindow._UpdateTeamSymbol)
  self:RegisterMapInfo(Type.QuestNpc, MiniMapWindow._CreateQuestNpcSymbol, MiniMapWindow._UpdateQuestNpcSymbol, MiniMapWindow._RemoveQuestNpcSymbol)
  self:RegisterMapInfo(Type.QuestFocus, MiniMapWindow._CreateQuestFocus, MiniMapWindow._UpdateQuestFocus, MiniMapWindow._RemoveQuestFocus)
  self:RegisterMapInfo(Type.ScenicSpot, MiniMapWindow._CreateScenicSpot, MiniMapWindow._UpdateScenicSpot)
  self:RegisterMapInfo(Type.Seal, MiniMapWindow._CreateSealSymbol, MiniMapWindow._UpdateSealSymbol)
  self:RegisterMapInfo(Type.Transmitter, MiniMapWindow._CreateTransmitterButton, MiniMapWindow._UpdateTransmitterButton, MiniMapWindow._RemoveTransmitterButton)
  self:RegisterMapInfo(Type.WorldQuestTreasure, MiniMapWindow._CreateWorldQuestTreasure, MiniMapWindow._UpdateWorldQuestTreasure, MiniMapWindow._RemoveWorldQuestTreasure)
  self:RegisterMapInfo(Type.Monster, MiniMapWindow._CreateMonsterPoints, MiniMapWindow._UpdateMonsterPoints, MiniMapWindow._RemoveMonsterPoints)
  self:RegisterMapInfo(Type.FixedTreasure, MiniMapWindow._CreateFixedTreasurePoints, MiniMapWindow._UpdateFixedTreasurePoints, MiniMapWindow._RemoveFixedTreasurePoints)
  self:RegisterMapInfo(Type.TreePoints)
  self:RegisterMapInfo(Type.Player, MiniMapWindow._CreatePlayerPoints, MiniMapWindow._UpdatePlayerPoints)
  self:RegisterMapInfo(Type.GVGDroiyan, MiniMapWindow._CreateGvgDroiyanInfos, MiniMapWindow._UpdateGvgDroiyanInfos)
  self:RegisterMapInfo(Type.PoringFight)
  self:RegisterMapInfo(Type.TeamPws)
  self:RegisterMapInfo(Type.TripleTeams)
  self:RegisterMapInfo(Type.Thanatos, MiniMapWindow._CreateThanatosSymbols, MiniMapWindow._UpdateThanatosSymbols, MiniMapWindow._RemoveThanatosSymbols)
  self:RegisterMapInfo(Type.Othello, MiniMapWindow._CreateOthelloInfos, MiniMapWindow._UpdateOthelloInfos)
  self:RegisterMapInfo(Type.Link, MiniMapWindow._CreateLinkInfos, MiniMapWindow._UpdateLinkInfos, MiniMapWindow._RemoveLinkInfos)
  self:RegisterMapInfo(Type.CIRCLE, MiniMapWindow._CreateMapCircleArea, nil, MiniMapWindow._RemoveMapCircleArea)
  self:RegisterMapInfo(Type.RaidPuzzleRoom)
  self:RegisterMapInfo(Type.QuickTarget)
  self:RegisterMapInfo(Type.FlowerCar, MiniMapWindow._CreateMapFlowerCar)
  self:RegisterMapInfo(Type.LocalNpc, MiniMapWindow._CreateLocalNpcPosSymbol)
  self:RegisterMapInfo(Type.CIRCLE, MiniMapWindow._CreateMapCircleArea, nil, MiniMapWindow._RemoveMapCircleArea)
  self:RegisterMapInfo(Type.TrainEscort, MiniMapWindow._CreateMapTrainEscort)
  self:RegisterMapInfo(Type.EBFEventArea, MiniMapWindow._CreateEBFEventAreaSymbol, MiniMapWindow._UpdateEBFEventAreaSymbol, MiniMapWindow._RemoveEBFEventAreaSymbol)
  self:RegisterMapInfo(Type.Astral)
  self:RegisterMapInfo(Type.GvgStrongHold, MiniMapWindow._CreateGvgStrongHold, MiniMapWindow._UpdateGvgStrongHold, MiniMapWindow._RemoveGvgStrongHold)
  self:RegisterMapInfo(Type.MetalGvg_MetalIcon, MiniMapWindow._CreateGvgSymbol, MiniMapWindow._UpdateGvgSymbol, MiniMapWindow._RemoveGvgSymbol)
  self:RegisterMapInfo(Type.WildMvp, MiniMapWindow._CreateWildMvpSymbol, MiniMapWindow._UpdateWildMvpSymbol, MiniMapWindow._RemoveWildMvpSymbol)
  self:RegisterMapInfo(Type.ZoneBlock, MiniMapWindow._CreateZoneBlock, MiniMapWindow._UpdateZoneBlock, MiniMapWindow._RemoveZoneBlock)
  self:RegisterMapInfo(Type.Yahaha, MiniMapWindow._CreateYahahaSymbol, MiniMapWindow._UpdateYahahaSymbol)
  self:RegisterMapInfo(Type.GvgFightPoint, MiniMapWindow._CreateGvgFightPointSymbol)
  self:RegisterMapInfo(Type.GvgFriendLeaderPoint, MiniMapWindow._CreateGvgFriendLeaderPointSymbol)
  self:RegisterMapInfo(Type.GvgEnemyLeaderPoint, MiniMapWindow._CreateGvgEnemyLeaderPointSymbol)
  self:RegisterMapInfo(Type.GvgFriendChairmanPoint, MiniMapWindow._CreateGvgFriendChairmanPointSymbol)
  self:RegisterMapInfo(Type.GvgEnemyChairmanPoint, MiniMapWindow._CreateGvgEnemyChairmanPointSymbol)
  self:RegisterMapInfo(Type.FakeDragon, MiniMapWindow._CreateFakeDragonSymbol, MiniMapWindow._UpdateFakeDragonSymbol, MiniMapWindow._RemoveFakeDragonSymbol)
  self:RegisterMapInfo(Type.FairyTale, MiniMapWindow._CreateFairyTaleSymbol, MiniMapWindow._UpdateFairyTaleSymbol, MiniMapWindow._RemoveFairyTaleSymbol)
end

function MiniMapWindow:RegisterMapInfo(type, createFunc, updateFunc, removeFunc)
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

function MiniMapWindow:ActiveSymbolsByType(type, value)
  local mapInfo = self.allMapInfos[type]
  if not mapInfo then
    return
  end
  mapInfo.hide = not value
  redlog("ActiveSymbolsByType", type, mapInfo.hide)
  self:RefreshSymbolsByType(type)
end

function MiniMapWindow:GetSymbolObjMap(type)
  local mapInfo = self.allMapInfos[type]
  return mapInfo and mapInfo.cacheMap
end

function MiniMapWindow:CreateSymbolsParent(parent, name)
  local symbolObj = GameObject(name)
  symbolObj = symbolObj.transform
  symbolObj:SetParent(parent.transform, false)
  symbolObj.localPosition = _LuaGeometry.GetTempVector3()
  LuaQuaternion.Better_SetEulerAngles(tempRot, _LuaGeometry.GetTempVector3())
  symbolObj.localRotation = tempRot
  symbolObj.localScale = _LuaGeometry.GetTempVector3(1, 1, 1)
  return symbolObj
end

function MiniMapWindow:InitView()
  self.mTrans = self.trans
  self.minimapPanel = self:FindComponent("Panel_MiniMap", UIPanel)
  self.mapPanel = self:FindComponent("Panel_Map", UIPanel)
  self.sPanel = self:FindComponent("Panel_S", UIPanel)
  self.dPanel = self:FindComponent("Panel_D", UIPanel)
  self.monsterPanel = self:FindComponent("Panel_Monster", UIPanel)
  self.myselfPanel = self:FindComponent("Panel_Self", UIPanel)
  self.comPanelMoveFollow = self.mapPanel.gameObject:GetComponent(PanelMoveFollow)
  local panelSize
  if self.minimapPanel then
    panelSize = self.minimapPanel:GetViewSize()
  else
    panelSize = self.sPanel:GetViewSize()
  end
  self.panelSize = {
    panelSize.x,
    panelSize.y
  }
  self.mapTexture = self:FindComponent("MapTexture", UITexture, self.mapPanel.gameObject)
  self.mapBorderTexture = self:FindComponent("MapBorderTexture", UITexture, self.mapPanel.gameObject)
  self.mapLabel = self:FindGO("MapLabel", self.mapTexture.gameObject)
  self.s_symbolParent = self:CreateSymbolsParent(self.sPanel, "symbolsParent")
  self.d_symbolParent = self:CreateSymbolsParent(self.dPanel, "symbolsParent")
  self.monster_symbolParent = self:CreateSymbolsParent(self.monsterPanel, "symbolsParent")
  self.self_symbolParent = self:CreateSymbolsParent(self.myselfPanel, "symbolsParent")
  if self.destTransEffect then
    self.destTransEffect:Destroy()
    self.destTransEffect = nil
  end
  self:PlayUIEffect(EffectMap.UI.MapPoint, self.myselfPanel.gameObject, false, function(obj, args, assetEffect)
    self.destTransEffect = assetEffect
    self.destTransEffect:RegisterWeakObserver(self)
    self.destTransEffect:SetActive(false)
  end, self)
  if self.tipTransEffect then
    self.tipTransEffect:Destroy()
    self.tipTransEffect = nil
  end
  self:PlayUIEffect(EffectMap.UI.MapPoint2, self.myselfPanel.gameObject, false, function(obj, args, assetEffect)
    self.tipTransEffect = assetEffect
    self.tipTransEffect:RegisterWeakObserver(self)
    self.tipTransEffect:SetActive(false)
  end, self)
  local myTransSymbol = self:GetMapSymbol("map_mypos", 100, 1, self.myselfPanel.transform)
  self.myTrans = myTransSymbol.transform
  self.cameraSymbol = self:GetMapSymbol("map_face", 99, 1, self.myselfPanel.transform)
  local cameraSymbolSp = self.cameraSymbol:GetComponent(UISprite)
  cameraSymbolSp.pivot = UIWidget.Pivot.Left
  self:UpdateCameraSymbol()
  local eventManager = EventManager.Me()
  eventManager:AddEventListener(LoadSceneEvent.FinishLoadScene, self.OnSceneBeginChanged, self)
  eventManager:AddEventListener(PVEEvent.NewHeadwearRaid_RemoveNpc, self.RemoveNpcMap, self)
end

function MiniMapWindow:RemoveNpcMap()
  self:ClearNpc()
end

function MiniMapWindow:ObserverDestroyed(obj)
  if obj == self.tipTransEffect then
    self.tipTransEffect = nil
  elseif obj == self.destTransEffect then
    self.destTransEffect = nil
  end
end

function MiniMapWindow._DestTransEffectHandle(effectHandle, self)
  if self then
    local tipGO = effectHandle.gameObject
    MiniMapWindow._AdjustEffectTextureDepth(tipGO)
  end
end

function MiniMapWindow._TipTransEffectHandle(effectHandle, self)
  if self and effectHandle then
    local tipGO = effectHandle.gameObject
    MiniMapWindow._AdjustEffectTextureDepth(tipGO)
  end
end

function MiniMapWindow._AdjustEffectTextureDepth(go)
  local sps = UIUtil.GetAllComponentsInChildren(go, UITexture)
  local minDepth = 50
  for i = 1, #sps do
    sps[i].depth = minDepth + sps[i].depth % 10
  end
end

function MiniMapWindow:IsActive()
  return self.active ~= false
end

function MiniMapWindow:IsActiveInHierarchy()
  return self:IsActive() and self.isParentActive
end

function MiniMapWindow:Show()
  self.active = true
  self.gameObject:SetActive(true)
  self:PlayQuestSymbolShow()
  Game.GUISystemManager:AddMonoUpdateFunction(self.Update, self)
end

function MiniMapWindow:Hide()
  self.active = false
  self.gameObject:SetActive(false)
  self:CloseCheckMyPos()
  TipsView.Me():HideTip(QuestDetailTip)
  self:StopDelayShowObjList()
  self:ClearSymbolHintParam()
  Game.GUISystemManager:ClearMonoUpdateFunction(self)
end

function MiniMapWindow:Update(time, deltaTime)
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

function MiniMapWindow:OnViewShow()
  self.isParentActive = true
end

function MiniMapWindow:OnViewHide()
  self.isParentActive = false
end

function MiniMapWindow:SetLock(b)
  self.lock = b
  self.mapTexture:GetComponent(BoxCollider).enabled = not b
end

function MiniMapWindow:SetPanelMoveFollowUpdateFrameInterval(frameCount)
  if self.comPanelMoveFollow then
    self.comPanelMoveFollow.nRefreshFrameInterval = frameCount
  end
end

function MiniMapWindow:GetMapSymbol(sname, depth, scale, parent)
  local resultGO = _Game.AssetManager_UI:CreateAsset(MiniMapWindow.MiniMapSymbolPath, parent or self.s_symbolParent)
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

function MiniMapWindow:GetGuildIconSymbol(miniMapData)
  local go = _Game.AssetManager_UI:CreateAsset(MiniMapWindow.MiniMapCustomGuildIconPath, parent or self.s_symbolParent)
  go:SetActive(true)
  go.transform.localPosition = _LuaGeometry.Const_V3_zero
  go.transform.localRotation = _LuaGeometry.Const_Qua_identity
  go.transform.localScale = _LuaGeometry.Const_V3_one
  return go
end

function MiniMapWindow:UpdateMapSymbol(symbol, scale, depth)
  local sprite = symbol:GetComponent(UISprite)
  if sprite then
    scale = scale or 0.7
    sprite:MakePixelPerfect()
    sprite.width = sprite.width * scale
    sprite.height = sprite.height * scale
    if depth then
      sprite.depth = depth
    end
  end
end

function MiniMapWindow:RemoveMiniMapSymbol(obj)
  if not IsNull(obj) then
    _Game.GOLuaPoolManager:AddToUIPool(MiniMapWindow.MiniMapSymbolPath, obj)
  end
end

function MiniMapWindow:ResetMoveCMD(cmd)
  if nil ~= self.moveCMD then
    self.moveCMD:Shutdown()
  end
  self.moveCMD = cmd
end

function MiniMapWindow:OnSceneBeginChanged()
  self:ResetMoveCMD(nil)
  self:RemoveAllMapSymbols()
end

local tempArgs = {}

function MiniMapWindow:AddMapClick()
  self:AddClickEvent(self.mapTexture.gameObject, function(go)
    if self.forbidMapTextureClick then
      return
    end
    self:OnClickMiniMap()
  end)
end

function MiniMapWindow:OnClickMiniMap()
  if self.lock then
    return
  end
  TipsView.Me():HideTip(QuestDetailTip)
  local uiCamera = NGUIUtil:GetCameraByLayername("UI")
  if not uiCamera then
    redlog("Cannot find ui camera!")
    return
  end
  local inputWorldPos = _LuaGeometry.GetTempVector3(LuaGameObject.GetMousePosition())
  if not UIUtil.IsScreenPosValid(inputWorldPos[1], inputWorldPos[2]) then
    if not ApplicationInfo.IsRunOnEditor() then
      LogUtility.Error(string.format("MiniMapWindow MousePosition is Invalid! x: %s, y: %s", inputWorldPos[1], inputWorldPos[3]))
    end
    return
  end
  inputWorldPos = _LuaGeometry.GetTempVector3(LuaGameObject.ScreenToWorldPointByVector3(uiCamera, inputWorldPos))
  tempV3[1], tempV3[2], tempV3[3] = LuaGameObject.InverseTransformPointByVector3(self.mapTexture.transform, inputWorldPos)
  local p = self:MapPosToScene(tempV3)
  if p then
    if PvpObserveProxy.Instance:ObserverFlash(p[1], p[2], p[3]) then
      return
    end
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

function MiniMapWindow:UpdateMapTexture(data, size, map2D)
  self.mapdata = data
  self.map2D = map2D
  if map2D and data then
    local resName = "Scene" .. data.NameEn
    if map2D.ID > 0 then
      resName = resName .. "_" .. map2D.ID
    end
    self:SetMiniMap(resName)
    if size then
      self.mapTexture.width = size[1]
      self.mapTexture.height = size[2]
      self:UpdateMiniMapGOScale()
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
    self:SetMiniMap(nil)
    self.mapTexture.mainTexture = nil
  end
  self:UpdateFixedInfo()
  self.iMoved = true
  self:RefreshMapSymbols()
end

function MiniMapWindow:UpdateFixedInfo()
  self:UpdateNpcPoints()
  self:UpdateExitPoints()
  self:UpdatePuzzleAreaMap()
  self:UpdatePuzzleMapSize()
end

function MiniMapWindow:ClearNpc()
  if self.npcMapDatas then
    TableUtility.TableClearByDeleter(self.npcMapDatas, MiniMapDataRemoveFunc)
  end
  self.allMapDatas[Type.Npc] = {}
  self:RemoveAllSymbolsByType(Type.Npc)
end

function MiniMapWindow:ClearFixedInfo()
  self:ClearNpc()
  if self.exitMapDatas then
    TableUtility.TableClearByDeleter(self.exitMapDatas, MiniMapDataRemoveFunc)
  end
  self.allMapDatas[Type.ExitPoint] = {}
  self:RemoveAllSymbolsByType(Type.ExitPoint)
  if self.zoneBlockMap then
    TableUtility.TableClearByDeleter(self.zoneBlockMap, MiniMapDataRemoveFunc)
  end
  self.allMapDatas[Type.ZoneBlock] = {}
  self:RemoveAllSymbolsByType(Type.ZoneBlock)
  if self.fakeDragonDatas then
    TableUtility.TableClearByDeleter(self.fakeDragonDatas, MiniMapDataRemoveFunc)
  end
end

local miniMapPrefab = GameConfig.MiniMapPrefab or {}

function MiniMapWindow:SetMiniMap(name)
  local mapTexName = self.mapTexName
  if mapTexName == name then
    return
  end
  local texture = self.mapTexture
  if mapTexName ~= nil then
    _PictureManager:UnLoadMiniMap(mapTexName, texture)
  end
  if self.miniMapGO and not Slua.IsNull(self.miniMapGO) then
    GameObject.Destroy(self.miniMapGO)
    self.miniMapGO = nil
  end
  if name ~= nil then
    if miniMapPrefab[name] then
      self.miniMapGO = self:LoadPreferb("minimap/" .. miniMapPrefab[name], self.mapTexture.gameObject)
    else
      _PictureManager:SetMiniMap(name, texture)
    end
  end
  if _Game.MapManager:IsBigWorld() then
    self:SetMiniMapBorder(name)
  else
    self:SetMiniMapBorder(nil)
  end
  self.mapTexName = name
  self:UpdateMiniMapGOScale()
end

function MiniMapWindow:UpdateMiniMapGOScale()
  if not self.miniMapGO then
    return
  end
  local tex = self.miniMapGO:GetComponent(UITexture)
  LuaGameObject.SetLocalScaleGO(self.miniMapGO, self.mapTexture.width / tex.width, self.mapTexture.height / tex.height, 1)
end

function MiniMapWindow:SetMiniMapPart(name, b)
  if not name then
    return
  end
  if Slua.IsNull(self.miniMapGO) then
    return
  end
  if type(name) == "table" then
    for _, sname in pairs(name) do
      local p = self:FindGO(sname, self.miniMapGO)
      if p then
        p:SetActive(b)
      end
    end
  elseif type(name) == "string" then
    local p = self:FindGO(name, self.miniMapGO)
    if p then
      p:SetActive(b)
    end
  end
end

function MiniMapWindow:SetMapScale(scale)
  if scale and scale ~= self.lastMapScale then
    local pct = scale / self.lastMapScale
    local symbolPct = (scale * 0.5 + 0.5) / (self.lastMapScale * 0.5 + 0.5)
    self.mapsize.x = self.mapsize.x * pct
    self.mapsize.y = self.mapsize.y * pct
    self.mapTexture.width = self.mapsize.x
    self.mapTexture.height = self.mapsize.y
    NGUITools.UpdateWidgetCollider(self.mapTexture.gameObject)
    self:UpdateMiniMapGOScale()
    local symbol, scalePct
    for i = 1, self.s_symbolParent.childCount do
      symbol = self.s_symbolParent:GetChild(i - 1)
      _LuaGeometry.TempGetLocalPosition(symbol, tempV3)
      LuaVector3.Mul(tempV3, pct)
      symbol.localPosition = tempV3
      scalePct = string.find(symbol.name, "Sliced", 1, true) and pct or symbolPct
      _LuaGeometry.TempGetLocalScale(symbol, tempV3)
      LuaVector3.Mul(tempV3, scalePct)
      symbol.localScale = tempV3
    end
    for i = 1, self.d_symbolParent.childCount do
      symbol = self.d_symbolParent:GetChild(i - 1)
      _LuaGeometry.TempGetLocalPosition(symbol, tempV3)
      LuaVector3.Mul(tempV3, pct)
      symbol.localPosition = tempV3
      scalePct = string.find(symbol.name, "Sliced", 1, true) and pct or symbolPct
      _LuaGeometry.TempGetLocalScale(symbol, tempV3)
      LuaVector3.Mul(tempV3, scalePct)
      symbol.localScale = tempV3
    end
    for i = 1, self.self_symbolParent.childCount do
      symbol = self.self_symbolParent:GetChild(i - 1)
      _LuaGeometry.TempGetLocalPosition(symbol, tempV3)
      LuaVector3.Mul(tempV3, pct)
      symbol.localPosition = tempV3
      scalePct = string.find(symbol.name, "Sliced", 1, true) and pct or symbolPct
      _LuaGeometry.TempGetLocalScale(symbol, tempV3)
      LuaVector3.Mul(tempV3, scalePct)
      symbol.localScale = tempV3
    end
    for i = 1, self.monster_symbolParent.childCount do
      symbol = self.monster_symbolParent:GetChild(i - 1)
      _LuaGeometry.TempGetLocalPosition(symbol, tempV3)
      LuaVector3.Mul(tempV3, pct)
      symbol.localPosition = tempV3
      scalePct = string.find(symbol.name, "Sliced", 1, true) and pct or symbolPct
      _LuaGeometry.TempGetLocalScale(symbol, tempV3)
      LuaVector3.Mul(tempV3, scalePct)
      symbol.localScale = tempV3
    end
    _LuaGeometry.TempGetLocalPosition(self.myTrans, tempV3)
    LuaVector3.Mul(tempV3, pct)
    self.myTrans.localPosition = tempV3
    _LuaGeometry.TempGetLocalScale(self.myTrans, tempV3)
    LuaVector3.Mul(tempV3, symbolPct)
    self.myTrans.localScale = tempV3
    self.lastMapScale = scale
    self:UpdatePuzzleMapSize()
  end
end

function MiniMapWindow:MapPosToScene(pos)
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

function MiniMapWindow:ScenePosToMap(pos)
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

function MiniMapWindow:IsScenePosValid(posX, posZ)
  if not self.map2D then
    return
  end
  return posX >= self.mapSceneMinPos[1] and posX <= self.mapSceneMinPos[1] + self.mapSceneSize[1] and posZ >= self.mapSceneMinPos[2] and posZ <= self.mapSceneMinPos[2] + self.mapSceneSize[2]
end

function MiniMapWindow:IsScenePosInUnlockedZone(posX, posY, posZ)
  if not self.blockUnlockInfo then
    return true
  end
  local pos = {
    posX,
    posY or 0,
    posZ
  }
  local groupId = WorldMapProxy.Instance:GetZoneGroupIdByPos(pos)
  if groupId then
    local isUnlocked = self.blockUnlockInfo[groupId]
    return isUnlocked ~= false
  end
  return true
end

function MiniMapWindow:SceneSizeToMap(sizeX, sizeZ)
  if not self.map2D then
    return 0, 0
  end
  return sizeX / self.mapSceneSize[1] * self.mapsize.x, sizeZ / self.mapSceneSize[2] * self.mapsize.y
end

function MiniMapWindow:SetUpdateEvent(event, owner)
  self.updateEvent = event
  self.updateEventOwner = owner
end

function MiniMapWindow:CloseCheckMyPos()
  TimeTickManager.Me():ClearTick(self, 1)
end

function MiniMapWindow:UpdateMyPos(forceUpdate)
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

function MiniMapWindow:RefreshSymbolByRange()
end

function MiniMapWindow:UpdateDestPos(destPos)
  if self.map2D == nil then
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

function MiniMapWindow:SetTipPos(pos)
  if not self.tipTransEffect then
    return
  end
  if pos then
    self.tipTransEffect:SetActive(true)
    self.tipTransEffect:ResetLocalPosition(self:ScenePosToMap(pos))
    if self.tipPosLt then
      self.tipPosLt:Destroy()
      self.tipPosLt = nil
    end
    self.tipPosLt = TimeTickManager.Me():CreateOnceDelayTick(3000, function(owner, deltaTime)
      self.tipTransEffect:SetActive(false)
      self.tipPosLt = nil
    end, self, 9)
  else
    self.tipTransEffect:SetActive(false)
  end
end

function MiniMapWindow:HelpUpdatePos(symbol, scenePos)
  local spos = self:ScenePosToMap(scenePos)
  if spos == nil then
    return false
  end
  SetLocalPositionObj(symbol, spos[1], spos[2], spos[3])
  return true
end

function MiniMapWindow:CenterOnMyPos(restrictWithPanel)
  self:CenterOnTrans(self.myTrans, restrictWithPanel)
end

local cc, cp, bsize, offset = LuaVector3(), LuaVector3(), LuaVector3(), LuaVector3()

function MiniMapWindow:CenterOnTrans(trans, restrictWithPanel)
  if not trans or not self:IsActiveInHierarchy() then
    return
  end
  local mapPanelTrans = self.mapPanel.transform
  cc[1], cc[2], cc[3] = LuaGameObject.InverseTransformPointByVector3(mapPanelTrans, self.mTrans.position)
  cp[1], cp[2], cp[3] = LuaGameObject.InverseTransformPointByVector3(mapPanelTrans, trans.position)
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

function MiniMapWindow:ResetMapPos()
  self.mapPanel.clipOffset = _LuaGeometry.Const_V2_zero
  self.mapPanel.transform.localPosition = _LuaGeometry.Const_V3_zero
end

function MiniMapWindow:EnableDrag(b)
  local dragScrollView = self.mapTexture:GetComponent(UIDragScrollView)
  dragScrollView = dragScrollView or self.mapTexture:AddComponent(UIDragScrollView)
  dragScrollView.enabled = b
end

function MiniMapWindow:ShowOrHideExitInfo(b)
  local cacheMap = self:GetSymbolObjMap(Type.ExitPoint)
  for k, exitObj in pairs(cacheMap) do
    if not IsNull(exitObj) and exitObj.transform.childCount > 0 then
      local info = exitObj.transform:GetChild(0)
      if not IsNull(info.gameObject) then
        info.gameObject:SetActive(b)
      end
    end
  end
end

function MiniMapWindow:ActiveSymbols(b)
  self.s_symbolParent.gameObject:SetActive(b)
  self.d_symbolParent.gameObject:SetActive(b)
end

function MiniMapWindow:UpdateMapSymbolDatas(t, datas, isRemoveOther, checkDistance, clickEvent)
  local mapInfo = self.allMapInfos[t]
  if not mapInfo then
    redlog("MiniMapWindow recieved unknown type: ", tostring(t))
    return
  end
  if type(datas) ~= "table" then
    redlog("MiniMapWindow:UpdateMapSymbolDatas - datas must be a table, error type: ", t)
    return
  end
  mapInfo.isRemoveOther = isRemoveOther
  mapInfo.checkDistance = checkDistance
  mapInfo.clickEvent = clickEvent
  self.allMapDatas[t] = datas
  if not self.showRange then
    self.dirtyMap[t] = true
  end
end

function MiniMapWindow:RefreshMapSymbols()
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
  self:UpdateWildMvpSymbolProgress()
  self:UpdateServerNpcProgress()
end

function MiniMapWindow:RefreshSymbolsByType(t)
  local mapInfo = self.allMapInfos[t]
  if not mapInfo then
    return
  end
  if mapInfo.hide then
    self:RemoveAllSymbolsByType(t)
    return
  end
  local datas
  if self.showRange then
    local nowMyPos = _Game.Myself:GetPosition()
    local allData = self.allMapDatas[t]
    if allData then
      datas = {}
      for key, data in pairs(allData) do
        local pos = data.pos
        local showRange = data.showRange or self.showRange
        if showRange < 0 or nowMyPos ~= nil and pos ~= nil and showRange >= VectorUtility.DistanceXZ(nowMyPos, pos) then
          datas[key] = data
        end
      end
    end
  else
    datas = self.allMapDatas[t]
  end
  local cacheMap = mapInfo.cacheMap
  local lastPosXMap = mapInfo.lastPosXMap
  local lastPosZMap = mapInfo.lastPosZMap
  for key, data in pairs(datas) do
    local lastPosX, lastPosZ = lastPosXMap[key], lastPosZMap[key]
    local checkDistance = mapInfo.checkDistance or 1
    local curPos = data.pos
    if curPos then
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
      local needUpdate = not lastPosX or self.mapInfoChanged or checkDistance < 0 or DistanceBy2Value_Square(lastPosX, lastPosZ, curPos[1], curPos[3]) > checkDistance * checkDistance
      if needUpdate and self:IsScenePosValid(curPos[1], curPos[3]) and self:HelpUpdatePos(symbolObj, curPos) then
        lastPosXMap[key] = curPos[1]
        lastPosZMap[key] = curPos[3]
      end
      cacheMap[key] = symbolObj
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

function MiniMapWindow:RemoveSymbolImmediate(type, key)
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

function MiniMapWindow:RemoveAllSymbolsByType(type)
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

function MiniMapWindow:RemoveAllMapSymbols()
  for type, _ in pairs(self.allMapInfos) do
    if type ~= Type.ExitPoint and type ~= Type.Npc then
      self:RemoveAllSymbolsByType(type)
    end
  end
end

local changeIntegerToAlphabet = function(i)
  if 64 <= i then
    return
  end
  return string.char(math.floor(i + 64))
end

function MiniMapWindow.SetLetterOfExitPoint(epLabel, data)
  if not epLabel or not data then
    return
  end
  epLabel.text = changeIntegerToAlphabet(data:GetParama("index")) or ""
end

function MiniMapWindow:_CreateExitPoint(data)
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
        MiniMapWindow.SetLetterOfExitPoint(label, data)
      end
    end
  end
  return symbolObj
end

function MiniMapWindow:_UpdateExitPoint(symbolObj, data)
  if not IsNull(symbolObj) then
    symbolObj.gameObject:SetActive(data:GetParama("active"))
    local sp = symbolObj.gameObject:GetComponent(UISprite)
    sp.spriteName = data:GetParama("Symbol")
    local info = symbolObj.transform:GetChild(0)
    local nextSceneID = data:GetParama("nextSceneID")
    if info and info.name ~= tostring(nextSceneID) then
      info.name = tostring(nextSceneID)
      MiniMapWindow.SetLetterOfExitPoint(info:GetComponent(UILabel), data)
    end
  end
  return symbolObj
end

function MiniMapWindow:_RemoveExitPoint(key, symbolObj)
  if Slua.IsNull(symbolObj) then
    return
  end
  LuaGameObject.DestroyGameObject(symbolObj.transform:GetChild(0))
  self:RemoveMiniMapSymbol(symbolObj)
end

function MiniMapWindow:UpdateNpcPoints(showBuildingSymbol)
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
          if npcData.MenuId ~= nil then
            isUnlock = FunctionUnLockFunc.Me():CheckCanOpen(npcData.MenuId)
          end
          if isUnlock and FunctionNpcFunc.checkNPCValid(v.uniqueID) and self:CheckIsBuilding(v.ID) then
            local combineID = v.ID .. v.uniqueID
            local npcMapData = self.npcMapDatas[combineID]
            if npcMapData == nil then
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

function MiniMapWindow:CheckIsBuilding(npcid)
  if Table_BuildingCooperate and Table_BuildingCooperate[npcid] then
    return false
  else
    return true
  end
end

function MiniMapWindow:UpdateExitPoints()
  if nil == self.exitMapDatas then
    self.exitMapDatas = {}
  else
    TableUtility.TableClearByDeleter(self.exitMapDatas, MiniMapDataRemoveFunc)
  end
  local exitList
  local imgId = ServicePlayerProxy.Instance:GetCurMapImageId()
  if imgId ~= nil and imgId ~= 0 then
    exitList = nil
  elseif _Game.MapManager:IsPVEMode_Roguelike() then
    exitList = nil
  else
    exitList = _Game.MapManager:GetExitPointArray()
  end
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

function MiniMapWindow:RemoveNpcPointMap(npcid)
  if npcid == nil then
    return
  end
  self:RemoveSymbolImmediate(Type.Npc, npcid)
end

function MiniMapWindow:UpdateNpcPointState(npcid, state)
  local cacheMap = self:GetSymbolObjMap(Type.Npc)
  if npcid and not IsNull(cacheMap[npcid]) then
    cacheMap[npcid].gameObject:SetActive(state)
  end
end

function MiniMapWindow:UpdateExitPointMapState(id, state)
  local cacheMap = self:GetSymbolObjMap(Type.ExitPoint)
  if self.exitMapDatas and self.exitMapDatas[id] then
    self.exitMapDatas[id]:SetParama("active", state)
  end
  if not IsNull(cacheMap[id]) then
    cacheMap[id].gameObject:SetActive(state)
  end
end

function MiniMapWindow:UpdateServerNpcPointMap(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.ServerNpc, datas, isRemoveOther)
end

function MiniMapWindow:UpdateServerNpcProgress()
  if self.serverNpcMap then
    for _, v in pairs(self.serverNpcMap) do
      if v then
        v:UpdateProgress()
      end
    end
  end
end

local ServerNpcSymbolPath = ResourcePathHelper.UICell("MiniMapSymbol_ServerNpc")

function MiniMapWindow:_CreateServerNpcPoint(data)
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

function MiniMapWindow:_UpdateServerNpcPoint(obj, data)
  if obj and data and self.serverNpcMap then
    local symbol = self.serverNpcMap[data.id]
    if symbol then
      symbol:SetData(data)
    end
  end
  return obj
end

function MiniMapWindow:_RemoveServerNpcPoint(id, symbolObj)
  if not Slua.IsNull(symbolObj) then
    _Game.GOLuaPoolManager:AddToUIPool(ServerNpcSymbolPath, symbolObj)
  end
  if self.serverNpcMap then
    self.serverNpcMap[id] = nil
  end
end

function MiniMapWindow:RefreshServerBuildingPoint(bool)
  local cacheMap = self:GetSymbolObjMap(Type.ServerNpc)
  if bool then
    for k, v in pairs(cacheMap) do
      if not IsNull(v) then
        v:SetActive(bool)
      end
    end
  else
    for k, v in pairs(cacheMap) do
      if not IsNull(v) then
        local uisprite = v:GetComponent(UISprite)
        if uisprite and uisprite.spriteName == "map_icon_building" then
          v:SetActive(bool)
        end
      end
    end
  end
end

function MiniMapWindow:RemoveServerNpcPointMap(npcid)
  if npcid == nil then
    return
  end
  self:RemoveSymbolImmediate(Type.ServerNpc, npcid)
end

function MiniMapWindow:UpdateNpcWalkPointMap(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.NpcWalk, datas, isRemoveOther)
end

function MiniMapWindow:RemoveeNpcWalkPointMap(npcid)
  if npcid == nil then
    return
  end
  self:RemoveSymbolImmediate(Type.NpcWalk, npcid)
end

function MiniMapWindow:UpdateBossSymbol(pos)
  if pos then
    if IsNull(self.bossSymbol) then
      self.bossSymbol = self:GetMapSymbol("map_boss", 8)
    end
    self:HelpUpdatePos(self.bossSymbol, pos)
  else
    self:RemoveMiniMapSymbol(self.bossSymbol)
    self.bossSymbol = nil
  end
end

function MiniMapWindow:UpdateBigCatSymbol(pos)
  if pos then
    if IsNull(self.bigCatSymbol) then
      self.bigCatSymbol = self:GetMapSymbol("map_boss", 9)
    end
    self:HelpUpdatePos(self.bigCatSymbol, pos)
  else
    self:RemoveMiniMapSymbol(self.bigCatSymbol)
    self.bigCatSymbol = nil
  end
end

function MiniMapWindow:_UpdateTeamSymbol(obj, data)
  if not IsNull(obj) then
    local symbol = data:GetParama("Symbol")
    local sp = obj:GetComponent(UISprite)
    if sp.spriteName ~= symbol then
      sp.spriteName = symbol
    end
  end
  return obj
end

function MiniMapWindow:UpdateTeamMemberSymbol(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.TeamMember, datas, isRemoveOther)
end

function MiniMapWindow:RemoveTeamMemberSymbol(key)
  self:RemoveSymbolImmediate(Type.TeamMember, key)
end

function MiniMapWindow:_CreateQuestNpcSymbol(data)
  local symbolType = data:GetParama("SymbolType")
  local config = QuestSymbolConfig[symbolType]
  if not config then
    redlog("QuestSymbolConfig缺少配置", symbolType)
  end
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
  if Slua.IsNull(obj) then
    redlog("ERROR SYMBOL:", symbolPath)
    return
  end
  if config and not config.UISymbol and config and config.UISpriteName then
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

function MiniMapWindow:_UpdateQuestNpcSymbol(obj, data)
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

function MiniMapWindow:_RemoveQuestNpcSymbol(id, symbolObj)
  if Slua.IsNull(symbolObj) then
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

function MiniMapWindow:UpdateQuestNpcSymbol(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.QuestNpc, datas, isRemoveOther)
end

function MiniMapWindow:ClickWorldQuestButton(button)
  local data = button.questId
  local questData = QuestProxy.Instance:GetQuestDataBySameQuestID(data)
  if questData then
    TipsView.Me():ShowStickTip(QuestDetailTip, questData, NGUIUtil.AnchorSide.TopLeft, button.sprIcon, {0, 0})
  else
    redlog("任务ID" .. data .. "找不到任务信息")
  end
end

function MiniMapWindow:PlayQuestSymbolShow()
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

function MiniMapWindow:PlayChooseQuestSymbolAnimation(questData)
  local npcid = questData.params.npc
  local uniqueid = questData.params.uniqueid
  local combineID
  npcid = type(npcid) == "table" and npcid[1] or npcid
  if uniqueid then
    npcPoint = MapManager:FindNPCPoint(uniqueid)
  elseif npcid then
    npcPoint = self:GetMapNpcPointByNpcId(npcid)
    uniqueid = npcPoint and npcPoint.uniqueID or 0
  else
    combineID = questData.questDataStepType .. questData.id
  end
  if nil == combineID then
    if npcid == nil and uniqueid == nil then
      errorLog("Not Find Npc (questId:%s)", questData.id)
    end
    combineID = QuestDataStepType.QuestDataStepType_VISIT .. tostring(npcid) .. tostring(uniqueid)
  end
  local cacheMap = self:GetSymbolObjMap(Type.QuestNpc)
  if cacheMap[combineID] then
    local animator = cacheMap[combineID]:GetComponent(Animator)
    if animator then
      animator:Play("map_icon_task", -1, 0)
    end
  end
end

function MiniMapWindow:GetMapNpcPointByNpcId(npcid)
  local npcList = MapManager:GetNPCPointArray()
  if npcList then
    for i = 1, #npcList do
      local npcPoint = npcList[i]
      if npcPoint and npcPoint.ID == npcid then
        return npcPoint
      end
    end
  end
end

function MiniMapWindow:DelayShowObjLst(objlst, spacetime, showCall)
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

function MiniMapWindow:StopDelayShowObjList()
  TimeTickManager.Me():ClearTick(self, 2)
end

local QUEST_FOCUS_PATH = ResourcePathHelper.EffectUI(EffectMap.UI.MapIndicates)

function MiniMapWindow:_CreateQuestFocus(data)
  local obj = _Game.AssetManager_UI:CreateAsset(QUEST_FOCUS_PATH, self.self_symbolParent)
  MiniMapWindow._AdjustEffectTextureDepth(obj)
  local hideSymbol = data:GetParama("hideSymbol")
  if hideSymbol then
    obj:SetActive(false)
  else
    obj:SetActive(true)
  end
  SetLocalScaleObj(obj, 1, 1, 1)
  local questId = data:GetParama("questId")
  obj.name = tostring(questId)
  return obj
end

function MiniMapWindow:_UpdateQuestFocus(obj, data)
  local hideSymbol = data:GetParama("hideSymbol")
  if hideSymbol then
    obj:SetActive(false)
  else
    obj:SetActive(true)
    self:HelpUpdatePos(obj.transform, data.pos)
  end
  return obj
end

function MiniMapWindow:_RemoveQuestFocus(key, symbolObj)
  self.questFocusDirty = true
  if not Slua.IsNull(symbolObj) then
    _Game.GOLuaPoolManager:AddToUIPool(QUEST_FOCUS_PATH, symbolObj)
  end
  if not key then
    return
  end
  local arrow = self.focusArrowMap[key]
  if not Slua.IsNull(arrow) then
    self:RemoveMiniMapSymbol(arrow)
  end
  self.focusArrowMap[key] = nil
end

function MiniMapWindow:UpdateQuestFocuses(datas, isRemoveOther)
  self.questFocusDirty = true
  self:UpdateMapSymbolDatas(Type.QuestFocus, datas, isRemoveOther)
end

function MiniMapWindow:ActiveFocusArrowUpdate(b)
  self.updateFocusArrow = b
end

function MiniMapWindow:ActiveCenterMiniMapWindow(active)
  local l_comCenterOnSelf = self.mapPanel.gameObject:GetComponent(PanelCenterOn)
  if active then
    if not l_comCenterOnSelf then
      l_comCenterOnSelf = self.mapPanel.gameObject:AddComponent(PanelCenterOn)
      l_comCenterOnSelf.tsfCenter = self.myTrans
    end
    l_comCenterOnSelf.enabled = true
  elseif l_comCenterOnSelf then
    l_comCenterOnSelf.enabled = false
  end
end

local dirV3 = LuaVector3()

function MiniMapWindow:UpdateFocusArrowPos()
  if not self.updateFocusArrow then
    return
  end
  if not self.questFocusDirty and not self.iMoved then
    return
  end
  self.questFocusDirty = false
  local cacheMap = self:GetSymbolObjMap(Type.QuestFocus)
  local myPos_x, myPos_y = GetLocalPosition(self.myTrans)
  for key, focus in pairs(cacheMap) do
    local pHalfSize_x, pHalfSize_y = self.panelSize[1] / 2, self.panelSize[2] / 2
    local focusPos_x, focusPos_y = GetLocalPosition(focus.transform)
    LuaVector3.Better_Set(dirV3, focusPos_x - myPos_x, focusPos_y - myPos_y, 0)
    local arrow = self.focusArrowMap[key]
    if pHalfSize_x < math.abs(dirV3[1]) or pHalfSize_y < math.abs(dirV3[2]) then
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

function MiniMapWindow._PlayFocusFrameEffect(effectHandle, args)
  if effectHandle and args then
    effectHandle.transform.position = _LuaGeometry.GetTempVector3(args[1], args[2], args[3])
    MiniMapWindow._AdjustEffectTextureDepth(effectHandle.gameObject)
  end
end

function MiniMapWindow:PlayFocusFrameEffect(id)
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
  local myPos_x, myPos_y = LuaGameObject.InverseTransformPointByTransform(self.dPanel.transform, self.mTrans.transform, Space.World)
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
    self:PlayUIEffect(EffectMap.UI.MapPoint, parent, true, MiniMapWindow._PlayFocusFrameEffect, args)
  end
end

function MiniMapWindow:RemoveQuestFocusByQuestId(questId)
  self:RemoveSymbolImmediate(Type.QuestFocus, questId)
end

function MiniMapWindow:_CreateScenicSpot(data)
  local pos = data.pos
  if pos and not self:IsScenePosInUnlockedZone(pos[1], pos[2], pos[3]) then
    return nil
  end
  local symbol = data:GetParama("Symbol")
  local obj = self:GetMapSymbol(symbol, 6, nil, self.d_symbolParent)
  obj.name = symbol
  return obj
end

function MiniMapWindow:_UpdateScenicSpot(obj, data)
  local pos = data.pos
  if pos and not self:IsScenePosInUnlockedZone(pos[1], pos[2], pos[3]) then
    if not IsNull(obj) then
      self:RemoveMiniMapSymbol(obj)
    end
    return nil
  end
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

function MiniMapWindow:_CreateGvgSymbol(data)
  self.gvgSymbols = self.gvgSymbols or {}
  local symbol = _Game.AssetManager_UI:CreateAsset(MiniMapWindow.GvgSymbolPath, self.s_symbolParent)
  self.gvgSymbols[data.id] = GvgSymbol.new(symbol)
  self:_UpdateGvgSymbol(symbol, data)
  return symbol
end

function MiniMapWindow:_UpdateGvgSymbol(obj, data)
  if not IsNull(obj) then
    local symbol = self.gvgSymbols[data.id]
    if symbol then
      symbol:SetData(data)
    end
  end
  return obj
end

function MiniMapWindow:_RemoveGvgSymbol(id, symbolObj)
  if not Slua.IsNull(symbolObj) then
    _Game.GOLuaPoolManager:AddToUIPool(MiniMapWindow.GvgSymbolPath, symbolObj)
  end
  if self.gvgSymbols then
    self.gvgSymbols[id] = nil
  end
end

function MiniMapWindow:UpdateScenicSpotSymbol(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.ScenicSpot, datas, isRemoveOther)
end

function MiniMapWindow:_CreateSealSymbol(data)
  local symbol = data:GetParama("Symbol")
  local obj = self:GetMapSymbol(symbol, 8)
  obj.name = symbol
  return obj
end

function MiniMapWindow:_UpdateSealSymbol(obj, data)
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

function MiniMapWindow:UpdateSealSymbol(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.Seal, datas, isRemoveOther)
end

function MiniMapWindow:UpdateTransmitterPoints(enlarge, forbidUse)
  if self.transmitterButtons == nil then
    self.transmitterButtons = {}
  else
    TableUtility.TableClearByDeleter(self.transmitterButtons, MiniMapDataRemoveFunc)
  end
  local curGroupID = self:GetCurTransmitterGroup()
  local curIsMainTransfer, isAllActivated = false, true
  local activePoints = WorldMapProxy.Instance.activeTransmitterPoints
  local transferPoint, transferID, found
  local mapDatas = WorldMapProxy.Instance:GetTransmitterMapByGroup(curGroupID)
  local curMapID = _Game.MapManager:GetMapID()
  local cellState, tarIsMainTransfer, buttonData, button
  for mapID, transfers in pairs(mapDatas) do
    for i = 1, #transfers do
      transferPoint = transfers[i]
      if transferPoint.MapID == curMapID then
        transferID = transferPoint.id
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
        buttonData:SetParama("Enlarge", enlarge)
        buttonData:SetParama("ForbidUse", forbidUse)
        self.transmitterButtons[transferPoint.id] = buttonData
      end
    end
  end
  self:UpdateTransmitterButton(self.transmitterButtons, true, true)
end

function MiniMapWindow:RemoveTransmitterPoints()
  self:UpdateTransmitterButton(_EmptyTable, true)
end

function MiniMapWindow:UpdateTransmitterButton(datas, isRemoveOther, forceUpdate)
  local checkDistance
  if forceUpdate then
    checkDistance = -1
  end
  self:UpdateMapSymbolDatas(Type.Transmitter, datas, isRemoveOther, checkDistance)
end

function MiniMapWindow:_CreateTransmitterButton(data)
  local symbolObj = self:CreateTransmitterSymbolButton(data)
  symbolObj.name = data:GetParama("name")
  local enlarge = data:GetParama("Enlarge")
  if enlarge then
    local scale = _LuaGeometry.TempGetLocalScale(symbolObj.transform)
    scale:Mul(1.65)
    symbolObj.transform.localScale = scale
  end
  return symbolObj
end

function MiniMapWindow:CreateTransmitterSymbolButton(data)
  parent = parent or self.d_symbolParent
  local obj = _Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("MiniMapTransmitterButton"))
  local button = MiniMapTransmitterButton.new(obj)
  if self.transmitterButtonMap == nil then
    self.transmitterButtonMap = {}
  end
  if self.transmitterButtonMap[data.id] then
    self.transmitterButtonMap[data.id]:OnCellDestroy()
  end
  self.transmitterButtonMap[data.id] = button
  button.name = tostring(npcID)
  button.trans:SetParent(self.d_symbolParent, false)
  button:SetData(data:GetParama("data"), data:GetParama("ForbidUse"))
  button:AddEventListener(MouseEvent.MouseClick, self.ClickTransmitterButton, self)
  return obj
end

function MiniMapWindow:_UpdateTransmitterButton(obj, data)
  if not IsNull(obj) then
    if self.transmitterButtonMap == nil then
      self.transmitterButtonMap = {}
    end
    local button
    if self.transmitterButtonMap[data.id] then
      button = self.transmitterButtonMap[data.id]
    else
      button = MiniMapTransmitterButton.new(obj)
      self.transmitterButtonMap[data.id] = button
    end
    self.transmitterButtonMap[data.id] = button
    button.trans:SetParent(self.d_symbolParent, false)
    button:SetData(data:GetParama("data"), data:GetParama("ForbidUse"))
    button:AddEventListener(MouseEvent.MouseClick, self.ClickTransmitterButton, self)
  end
  self:HelpUpdatePos(obj, data.pos)
  return obj
end

function MiniMapWindow:_RemoveTransmitterButton(key, symbolObj)
  LuaGameObject.DestroyObject(symbolObj)
  if self.transmitterButtonMap and self.transmitterButtonMap[key] then
    self.transmitterButtonMap[key]:OnCellDestroy()
    self.transmitterButtonMap[key] = nil
  end
end

function MiniMapWindow:ClickTransmitterButton(button)
  local data = button.data
  local id = button.id
  helplog("点击按钮的ID", id)
  if button.state ~= MiniMapTransmitterButton.E_State.Activated then
    MsgManager.ShowMsgByIDTable(25800)
  else
    local transferConfig = Table_DeathTransferMap[id]
    local buffId = transferConfig and transferConfig.CdBuff
    if buffId and Game.Myself.data:HasBuffID(buffId) then
      MsgManager.ShowMsgByID(49)
      return
    end
    helplog("执行传送")
    ServiceNUserProxy.Instance:CallUseDeathTransferCmd(0, id)
  end
end

function MiniMapWindow:UpdateWorldQuestTreasure(data, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.WorldQuestTreasure, data, isRemoveOther)
end

function MiniMapWindow:_CreateWorldQuestTreasure(data)
  local go = _Game.AssetManager_UI:CreateAsset(MonsterPoint_Path, self.d_symbolParent)
  self:_UpdateWorldQuestTreasure(go, data)
  return go
end

function MiniMapWindow:_UpdateWorldQuestTreasure(obj, data)
  if Slua.IsNull(obj) then
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

function MiniMapWindow:_RemoveWorldQuestTreasure(key, symbolObj)
  if Slua.IsNull(symbolObj) then
    return
  end
  _Game.GOLuaPoolManager:AddToUIPool(MonsterPoint_Path, symbolObj)
end

function MiniMapWindow:_CreateMonsterPoints(data, key)
  local go = _Game.AssetManager_UI:CreateAsset(MonsterPoint_Path, self.monster_symbolParent)
  self:_UpdateMonsterPoints(go, data, key)
  return go
end

local Format_MonsterObjId = function(symbol, depth, monster_icon)
  return string.format("%s_%s_%s", symbol, depth or "", monster_icon or "")
end

function MiniMapWindow:_UpdateMonsterPoints(obj, data, key)
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
  if self.lastMapScale and self.lastMapScale ~= MiniMapWindow.MAPSCALE_NORMAL then
    local symbolPct = self.lastMapScale * 0.5 + 0.5
    SetLocalScaleObj(obj, 1, 1, 1)
  end
  return obj
end

function MiniMapWindow:_RemoveMonsterPoints(key, symbolObj)
  self.mapDataInfoCache[key] = nil
  if Slua.IsNull(symbolObj) then
    return
  end
  _Game.GOLuaPoolManager:AddToUIPool(MonsterPoint_Path, symbolObj)
end

function MiniMapWindow:UpdateMonstersPoses(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.Monster, datas, isRemoveOther, 1)
end

function MiniMapWindow:_CreateFixedTreasurePoints(data, key)
  local go = _Game.AssetManager_UI:CreateAsset(MonsterPoint_Path, self.self_symbolParent)
  self:_UpdateFixedTreasurePoints(go, data, key)
  return go
end

function MiniMapWindow:_UpdateFixedTreasurePoints(obj, data, key)
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

function MiniMapWindow:_RemoveFixedTreasurePoints(key, symbolObj)
  self.mapDataInfoCache[key] = nil
  if Slua.IsNull(symbolObj) then
    return
  end
  _Game.GOLuaPoolManager:AddToUIPool(MonsterPoint_Path, symbolObj)
end

function MiniMapWindow:UpdateFixedTreasurePoses(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.FixedTreasure, datas, isRemoveOther)
end

function MiniMapWindow:UpdateTreePoints(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.TreePoints, datas, isRemoveOther)
end

function MiniMapWindow:RemoveTreePoint(key)
  self:RemoveSymbolImmediate(Type.TreePoints, key)
end

function MiniMapWindow:_CreatePlayerPoints(data)
  if not IsNull(self.gameObject) then
    local symbolName = data:GetParama("Symbol")
    local depth = data:GetParama("depth")
    local symbol = self:GetMapSymbol(symbolName, 7, 0.7)
    symbol:GetComponent(UISprite).depth = 21 + depth
    symbol:SetActive(self.monsterActive)
    return symbol
  end
end

function MiniMapWindow:_UpdatePlayerPoints(obj, data)
  if not IsNull(obj) then
    local symbol = data:GetParama("Symbol")
    local sp = obj:GetComponent(UISprite)
    if sp.spriteName ~= symbol then
      sp.spriteName = symbol
    end
  end
  return obj
end

function MiniMapWindow:UpdatePlayerPoses(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.Player, datas, isRemoveOther)
end

function MiniMapWindow:_CreateGvgDroiyanInfos(data)
  local symbolName = data:GetParama("Symbol")
  local symbol = self:GetMapSymbol(symbolName, 27, 0.7)
  self:_UpdateGvgDroiyanInfos(symbol, data)
  return symbol
end

function MiniMapWindow:_UpdateGvgDroiyanInfos(obj, data)
  local symbolName = data:GetParama("Symbol")
  local sp = obj:GetComponent(UISprite)
  if sp.spriteName ~= symbolName then
    sp.spriteName = symbolName
  end
  local child = self:FindGO("metal_live", obj)
  if Slua.IsNull(child) then
    child = self:GetMapSymbol("map_Empelium", 28, 1, obj.transform)
    child.gameObject.name = "metal_live"
  end
  local metal_live = data:GetParama("metal_live")
  if metal_live == nil then
    child:SetActive(false)
  else
    child:SetActive(true)
    if metal_live == 0 then
      child:GetComponent(UISprite).color = ColorUtil.NGUIGray
    elseif metal_live == 1 then
      child:GetComponent(UISprite).color = ColorUtil.NGUIWhite
    end
  end
  return obj
end

function MiniMapWindow:UpdateGvgDroiyanInfos(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.GVGDroiyan, datas, isRemoveOther)
end

function MiniMapWindow:UpdatePoringFightMapItems(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.PoringFight, datas, isRemoveOther)
end

function MiniMapWindow:UpdateTeamPwsInfo(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.TeamPws, datas, isRemoveOther)
end

function MiniMapWindow:_CreateThanatosSymbols(data, key)
  local go = _Game.AssetManager_UI:CreateAsset(MonsterPoint_Path, self.s_symbolParent)
  go.name = key
  self:_UpdateThanatosSymbols(go, data, key)
  return go
end

function MiniMapWindow:_UpdateThanatosSymbols(obj, data, key)
  local symbol = data:GetParama("Symbol") or ""
  local symbolBg = data:GetParama("SymbolBg") or ""
  local objId = symbol .. "_" .. symbolBg
  if objId == self.mapDataInfoCache[key] then
    return obj
  end
  self.mapDataInfoCache[key] = objId
  local sp = obj:GetComponent(UISprite)
  IconManager:SetMapIcon(symbol, sp)
  sp.depth = 31
  sp:MakePixelPerfect()
  local bg = self:FindGO("Bg", obj)
  if bg then
    bg:SetActive(symbolBg ~= "")
    if symbolBg ~= "" then
      local bgSp = bg:GetComponent(UISprite)
      IconManager:SetMapIcon(symbolBg, bgSp)
      bgSp:MakePixelPerfect()
      bgSp.depth = 30
    end
  end
  return obj
end

function MiniMapWindow:_RemoveThanatosSymbols(key, symbolObj)
  self.mapDataInfoCache[key] = nil
  if Slua.IsNull(symbolObj) then
    return
  end
  local bg = self:FindGO("Bg", symbolObj)
  if bg then
    bg:SetActive(true)
  end
  _Game.GOLuaPoolManager:AddToUIPool(MonsterPoint_Path, symbolObj)
end

function MiniMapWindow:UpdateThanatosInfo(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.Thanatos, datas, isRemoveOther)
end

function MiniMapWindow:Reset()
  self:SetMapScale(1)
  self:UpdateMapTexture(nil)
  if self.miniMapGO and not Slua.IsNull(self.miniMapGO) then
    GameObject.Destroy(self.miniMapGO)
    self.miniMapGO = nil
  end
  self:ClearFixedInfo()
end

function MiniMapWindow:UpdateOthelloInfos(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.Othello, datas, isRemoveOther)
end

function MiniMapWindow:_CreateOthelloInfos(data)
  local symbolName = data:GetParama("check_Symbol")
  local symbol = self:GetMapSymbol(symbolName, 27, 0.7)
  self:_UpdateOthelloInfos(symbol, data)
  return symbol
end

function MiniMapWindow:_UpdateOthelloInfos(obj, data)
  local symbolName = data:GetParama("check_Symbol")
  local sp = obj:GetComponent(UISprite)
  IconManager:SetMapIcon(symbolName, sp)
  sp:MakePixelPerfect()
  sp.depth = 30
  return obj
end

function MiniMapWindow:UpdateGvgStrongHoldSymbols(isRemoveOther)
  local datas = GvgProxy.Instance:GetGvgStrongHoldDatas()
  if not datas then
    return
  end
  self:UpdateMapSymbolDatas(Type.GvgStrongHold, datas, isRemoveOther)
end

local GvgStrongHoldSymbolPath = ResourcePathHelper.UICell("MiniMapSymbol_GvgStrongHold")

function MiniMapWindow:_CreateGvgStrongHold(data)
  local symbol = _Game.AssetManager_UI:CreateAsset(GvgStrongHoldSymbolPath, self.s_symbolParent)
  if not IsNull(symbol) then
    symbol:SetActive(true)
    symbol.transform.localRotation = _LuaGeometry.Const_Qua_identity
    symbol.transform.localScale = _LuaGeometry.Const_V3_one
    if self.gvgStrongHoldSymbols == nil then
      self.gvgStrongHoldSymbols = {}
    end
    if self.tag == 1 then
      self.gvgStrongHoldSymbols[data.id] = GvgStrongHoldMapSymbol.new(symbol, data, false)
    else
      self.gvgStrongHoldSymbols[data.id] = GvgStrongHoldMapSymbol.new(symbol, data, function()
        self:OnClickMiniMap()
      end)
    end
    self:_UpdateGvgStrongHold(symbol, data)
  end
  return symbol
end

function MiniMapWindow:_UpdateGvgStrongHold(obj, data)
  if obj and data and self.gvgStrongHoldSymbols then
    local symbol = self.gvgStrongHoldSymbols[data.id]
    symbol:SetData(data)
  end
  return obj
end

function MiniMapWindow:_RemoveGvgStrongHold(id, symbolObj)
  if not Slua.IsNull(symbolObj) then
    _Game.GOLuaPoolManager:AddToUIPool(GvgStrongHoldSymbolPath, symbolObj)
  end
  if self.gvgStrongHoldSymbols then
    self.gvgStrongHoldSymbols[id] = nil
  end
end

function MiniMapWindow:UpdateGvgStrongHoldProgress()
  if self.gvgStrongHoldSymbols then
    for _, v in pairs(self.gvgStrongHoldSymbols) do
      if v then
        v:UpdateProgress()
      end
    end
  end
end

function MiniMapWindow:UpdateLinkInfos(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.Link, datas, isRemoveOther)
end

local LinkPoint_Path = ResourcePathHelper.UICell("MiniMapSymbol_Link")

function MiniMapWindow:_CreateLinkInfos(data)
  local go = _Game.AssetManager_UI:CreateSceneUIAsset(LinkPoint_Path, self.s_symbolParent)
  self:_UpdateLinkInfos(go, data)
  return go
end

function MiniMapWindow:_UpdateLinkInfos(obj, data)
  local sprite = obj:GetComponent(UISprite)
  sprite.width = data:GetParama("width")
  sprite.height = 6
  sprite.spriteName = data:GetParama("spriteName")
  local angle = data:GetParama("angle")
  tempV3:Set(0, 0, angle)
  LuaQuaternion.Better_SetEulerAngles(tempRot, tempV3)
  obj.transform.localRotation = tempRot
  local display = data:GetParama("display") == true
  obj:SetActive(display)
  return obj
end

function MiniMapWindow:_RemoveLinkInfos(key, symbolObj)
  LuaGameObject.DestroyObject(symbolObj)
end

function MiniMapWindow:UpdateRoguelikeMap(datas, totalRoomCount, unlockRoomTypeMap, roomClickEnabled)
  self.roguelikeMapTotalRoomCount = totalRoomCount
  self.roguelikeMapUnlockRoomTypeMap = unlockRoomTypeMap
  self.roguelikeRoomClickEnabled = roomClickEnabled
  self.roguelikeCacheMap = self.roguelikeCacheMap or {}
  local symbol
  for key, data in pairs(datas) do
    symbol = self.roguelikeCacheMap[key]
    if symbol then
      self:_UpdateRoguelikeMapInfo(symbol, data)
    else
      symbol = self:_CreateRoguelikeMapInfo(data)
    end
    self.roguelikeCacheMap[key] = symbol
  end
  for key, obj in pairs(self.roguelikeCacheMap) do
    if not datas[key] then
      self:_RemoveRoguelikeMapInfo(obj)
      self.roguelikeCacheMap[key] = nil
    end
  end
  self:SetMiniMap("roguelike_" .. totalRoomCount)
  self.mapPosOffsetFunc = self._RoguelikeMapPosOffsetFunc
end

function MiniMapWindow:ClearRoguelikeMap()
  if self.roguelikeCacheMap then
    for _, obj in pairs(self.roguelikeCacheMap) do
      self:_RemoveRoguelikeMapInfo(obj)
    end
    TableUtility.TableClear(self.roguelikeCacheMap)
  end
  self.mapPosOffsetFunc = nil
end

local getRoguelikeMapSymbol = function(parent)
  local result = _Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("MiniMapSymbol_Roguelike"), parent)
  result:SetActive(true)
  result.transform.localPosition = _LuaGeometry.Const_V3_zero
  result.transform.localRotation = _LuaGeometry.Const_Qua_identity
  result.transform.localScale = _LuaGeometry.Const_V3_one
  return result
end
local needCheckRoomTypeMap = {
  [3] = true,
  [4] = true,
  [5] = true,
  [8] = true
}

function MiniMapWindow:_CreateRoguelikeMapInfo(data)
  if IsNull(self.gameObject) then
    return
  end
  local symbol, index = getRoguelikeMapSymbol(self.s_symbolParent), data.id
  if not IsNull(symbol) then
    self:_UpdateRoguelikeMapInfo(symbol, data)
    if self.roguelikeRoomClickEnabled then
      self:AddClickEvent(symbol, function()
        if not self.roguelikeMapUnlockRoomTypeMap[index] then
          return
        end
        if not TeamProxy.Instance:CheckIHaveLeaderAuthority() then
          return
        end
        local raid = DungeonProxy.Instance.roguelikeRaid
        if not raid then
          return
        end
        if raid.curRoomIndex == index then
          return
        end
        local curRoomType = DungeonProxy.GetRoguelikeRoomTypeByIndex(raid.curRoomIndex)
        if needCheckRoomTypeMap[curRoomType] then
          if not raid.finishRoomMap[raid.curRoomIndex] then
            return
          end
        elseif not curRoomType then
          return
        end
        ServiceRoguelikeCmdProxy.Instance:CallRoguelikeGoRoomCmd(index)
      end)
    end
  end
  return symbol
end

local roguelikeUiSubSceneIntervals = {
  [9] = 121,
  [16] = 87
}
local roguelikeOldUiSubSceneIntervals = {
  [9] = 140,
  [16] = 102.2
}
local roguelikeUiRoomRatios = {
  [9] = 1.95,
  [16] = 1.75
}
local _fakeSqrt = {
  [9] = 3,
  [16] = 4
}
local roguelikeUiSymbolOffsets = {
  [9] = LuaVector3.New(-0.9, 1.6),
  [16] = LuaVector3.New(0.3, -0.2)
}
local roguelikeRoomTypeSpriteMap = {
  [1] = "birth",
  [2] = "exit",
  [3] = "monster",
  [4] = "boss",
  [5] = "gear",
  [6] = "shop",
  [7] = "sleep",
  [8] = "tarot"
}

function MiniMapWindow:_GetRoguelikeLocalPosFromId(id, totalRoomCount, subSceneIntervals)
  local side = totalRoomCount and _fakeSqrt[totalRoomCount]
  if not side or not subSceneIntervals then
    return _LuaGeometry.GetTempVector3()
  end
  local widthRemainder = (id - 1) % side + 1
  local heightRemainder = (id - widthRemainder) / side + 1
  local widthRatio = widthRemainder - (1 + side) / 2
  local heightRatio = -(heightRemainder - (1 + side) / 2)
  local uiInterval = (subSceneIntervals[totalRoomCount] or 0) * self.lastMapScale
  return _LuaGeometry.GetTempVector3(widthRatio * uiInterval, heightRatio * uiInterval)
end

local setRoguelikeMapSymbol = function(obj, name, typeName, atlasName, spriteName, isPixelPerfect, colliderEnabled)
  typeName = typeName or "Simple"
  atlasName = atlasName or "NewCom"
  obj.name = name
  local sp, collider = obj:GetComponent(UISprite), obj:GetComponent(BoxCollider)
  sp.type = E_UIBasicSprite_Type[typeName]
  sp.atlas = RO.AtlasMap.GetAtlas(atlasName)
  sp.spriteName = spriteName
  if isPixelPerfect then
    sp:MakePixelPerfect()
  end
  if collider then
    collider.enabled = colliderEnabled and true or false
  end
end

function MiniMapWindow:_UpdateRoguelikeMapInfo(obj, data)
  if IsNull(self.gameObject) or IsNull(obj) then
    return
  end
  local child = obj.transform:GetChild(0).gameObject
  child:SetActive(false)
  local totalRoomCount, roomType, hasFakeFog = self.roguelikeMapTotalRoomCount, data:GetParama("RoomType"), data:GetParama("FakeFog")
  if totalRoomCount then
    local w, h = roguelikeUiSubSceneIntervals[totalRoomCount] + 1, roguelikeUiSubSceneIntervals[totalRoomCount] + 1
    if hasFakeFog then
      setRoguelikeMapSymbol(obj, "FakeFog" .. data.id, "Sliced", "NewCom", "com_icon_shadow")
      local sp = obj:GetComponent(UISprite)
      sp.width = w
      sp.height = h
      if roomType then
        child:SetActive(true)
        setRoguelikeMapSymbol(child, data.id, "Simple", "NewUI5", roguelikeRoomTypeSpriteMap[roomType], true)
      end
    elseif roomType then
      local collider = obj:GetComponent(BoxCollider)
      if self.roguelikeRoomClickEnabled and not collider then
        collider = obj:AddComponent(BoxCollider)
        local ratio = 0.6666666666666666
        collider.size = _LuaGeometry.GetTempVector3(math.floor(w * ratio), math.floor(h * ratio))
      elseif collider and not self.roguelikeRoomClickEnabled then
        Object.DestroyImmediate(collider)
      end
      setRoguelikeMapSymbol(obj, data.id, "Simple", "NewUI5", roguelikeRoomTypeSpriteMap[roomType or 7], true, true)
    end
  end
  obj.transform.localPosition = self:_GetRoguelikeLocalPosFromId(data.id, totalRoomCount, roguelikeUiSubSceneIntervals)
end

function MiniMapWindow:_RemoveRoguelikeMapInfo(symbolObj)
  local sp = symbolObj:GetComponent(UISprite)
  sp.type = E_UIBasicSprite_Type.Simple
  self:AddClickEvent(symbolObj)
  LuaGameObject.DestroyObject(symbolObj)
end

function MiniMapWindow:_RoguelikeMapPosOffsetFunc(pos)
  if not (self.roguelikeMapTotalRoomCount and self.roguelikeMapUnlockRoomTypeMap) or not pos then
    return pos
  end
  local totalRoomCount, roomLocalPos, radiusSquare = self.roguelikeMapTotalRoomCount
  for i = 1, totalRoomCount do
    roomLocalPos = self:_GetRoguelikeLocalPosFromId(i, totalRoomCount, roguelikeOldUiSubSceneIntervals)
    LuaVector3.Better_Mul(roguelikeUiSymbolOffsets[totalRoomCount], self.lastMapScale, tempV3)
    LuaVector3.Add(roomLocalPos, tempV3)
    radiusSquare = math.pow(roguelikeOldUiSubSceneIntervals[totalRoomCount] / 2.1 * self.lastMapScale, 2)
    if radiusSquare > LuaVector3.Distance_Square(roomLocalPos, pos) then
      if not self.roguelikeMapUnlockRoomTypeMap[i] then
        LuaVector3.Better_Set(pos, -10000, -10000, 0)
      else
        LuaVector3.Better_Sub(pos, roomLocalPos, tempV3)
        LuaVector3.Better_Mul(tempV3, roguelikeUiRoomRatios[totalRoomCount], tempV3)
        roomLocalPos = self:_GetRoguelikeLocalPosFromId(i, totalRoomCount, roguelikeUiSubSceneIntervals)
        LuaVector3.Better_Add(roomLocalPos, tempV3, pos)
      end
    end
  end
end

function MiniMapWindow:UpdateStealthGame(datas)
  self:UpdateMyPos(true)
  self.stealthGameCacheMap = self.stealthGameCacheMap or {}
  local symbol
  for key, data in pairs(datas) do
    symbol = self.stealthGameCacheMap[key]
    if symbol then
      self:_UpdateStealthGameInfo(symbol, data)
    else
      symbol = self:_CreateStealthGameInfo(data)
    end
    self.stealthGameCacheMap[key] = symbol
  end
  for key, obj in pairs(self.stealthGameCacheMap) do
    if not datas[key] then
      self:_RemoveStealthGameInfo(obj)
      self.stealthGameCacheMap[key] = nil
    end
  end
end

function MiniMapWindow:ClearStealthGame()
  if self.stealthGameCacheMap then
    for _, obj in pairs(self.stealthGameCacheMap) do
      self:_RemoveStealthGameInfo(obj)
    end
    TableUtility.TableClear(self.stealthGameCacheMap)
  end
end

function MiniMapWindow:_CreateStealthGameInfo(data)
  if IsNull(self.gameObject) then
    return
  end
  local go = _Game.AssetManager_UI:CreateAsset(MonsterPoint_Path, self.self_symbolParent)
  self:_UpdateStealthGameInfo(go, data)
  return go
end

function MiniMapWindow:_UpdateStealthGameInfo(obj, data)
  if IsNull(self.gameObject) or IsNull(obj) then
    return
  end
  local symbol = data:GetParama("Symbol") or "map_dot"
  local depth, iconSize = data:GetParama("depth") or 0, data:GetParama("iconSize")
  local x, z = data:GetParama("X") or 0, data:GetParama("Z") or 0
  local sp = obj:GetComponent(UISprite)
  sp.depth = depth + 22
  local bg = self:FindGO("Bg", obj)
  bg:SetActive(false)
  IconManager:SetMapIcon(symbol, sp)
  sp:MakePixelPerfect()
  if iconSize ~= 1 then
    sp.width = sp.width * (iconSize or 0.6)
    sp.height = sp.height * (iconSize or 0.6)
  end
  self:HelpUpdatePos(obj, _LuaGeometry.GetTempVector3(x, 0, z))
  return obj
end

function MiniMapWindow:_RemoveStealthGameInfo(symbolObj)
  if Slua.IsNull(symbolObj) then
    return
  end
  _Game.GOLuaPoolManager:AddToUIPool(MonsterPoint_Path, symbolObj)
  LuaGameObject.DestroyObject(symbolObj)
end

function MiniMapWindow:GetCurTransmitterGroup()
  local mapid = _Game.MapManager:GetMapID()
  for id, transferData in pairs(Table_DeathTransferMap) do
    if mapid == transferData.MapID then
      return transferData.MapGroup
    end
  end
  return nil
end

function MiniMapWindow:CreatePuzzleMap(raidID, forbidOriginClick, addClick)
  self:RemovePuzzleMap()
  self.objPuzzleMap = _Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIView("MiniMapPuzzleMap_" .. raidID))
  if self.objPuzzleMap == nil then
    LogUtility.Error(string.format("MiniMapPuzzleMap is null ! raidID: %s", raidID))
    return
  end
  local transform = self.objPuzzleMap.transform
  transform:SetParent(self.mapTexture.transform, false)
  transform.localPosition = _LuaGeometry.GetTempVector3(0, 0, 0)
  transform.localScale = _LuaGeometry.GetTempVector3(1, 1, 1)
  self.forbidMapTextureClick = forbidOriginClick
  self.curActivePuzzleAreaID = self.map2D and tostring(self.map2D.ID)
  local tsfArea, tsfRoom, colRoom, roomMap
  for i = 0, transform.childCount - 1 do
    tsfArea = transform:GetChild(i)
    self.puzzleRoomsObjAreaMap[tsfArea.name] = tsfArea.gameObject
    tsfArea.gameObject:SetActive(self.curActivePuzzleAreaID ~= nil and tsfArea.name == self.curActivePuzzleAreaID)
    for j = 0, tsfArea.childCount - 1 do
      tsfRoom = tsfArea:GetChild(j)
      roomMap = self.puzzleRoomsColliderMap[tsfRoom.name] or ReusableTable.CreateTable()
      colRoom = self:_ProcessSinglePuzzleRoom(tsfRoom, addClick)
      if colRoom then
        roomMap[#roomMap + 1] = colRoom
      end
      for x = 0, tsfRoom.childCount - 1 do
        colRoom = self:_ProcessSinglePuzzleRoom(tsfRoom:GetChild(x), addClick)
        if colRoom then
          roomMap[#roomMap + 1] = colRoom
        end
      end
      self.puzzleRoomsColliderMap[tsfRoom.name] = roomMap
    end
  end
  self:UpdatePuzzleMapSize()
end

function MiniMapWindow:_ProcessSinglePuzzleRoom(transform, addClick)
  local widget = transform:GetComponent(UIWidget)
  if widget then
    widget.alpha = 0
  end
  local colRoom = transform:GetComponent(Collider)
  if colRoom then
    colRoom.enabled = false
    if addClick then
      self:AddClickEvent(transform.gameObject, function()
        self:OnClickMiniMap()
      end)
    end
  end
  return colRoom
end

function MiniMapWindow:UpdatePuzzleAreaMap()
  if not self.objPuzzleMap then
    return
  end
  local objArea = self.puzzleRoomsObjAreaMap[self.curActivePuzzleAreaID]
  if objArea then
    objArea:SetActive(false)
  end
  self.curActivePuzzleAreaID = self.map2D and tostring(self.map2D.ID)
  objArea = self.puzzleRoomsObjAreaMap[self.curActivePuzzleAreaID]
  if objArea then
    objArea:SetActive(true)
  end
end

function MiniMapWindow:UpdatePuzzleMap(roomStatusMap)
  local tarStatus, tarColor
  local duration = self:IsActive() and RaidPuzzleManager.RoomTweenDuration or 0
  for name, roomMap in pairs(self.puzzleRoomsColliderMap) do
    tarStatus = roomStatusMap[name] or RaidPuzzleManager.E_RoomStatus.Disable
    if self.puzzleRoomsStatusMap[name] ~= tarStatus then
      if tarStatus == RaidPuzzleManager.E_RoomStatus.Passed then
        tarColor = _LuaGeometry.GetTempColor(0.5803921568627451, 1.0, 0.8352941176470589, 1)
      elseif tarStatus == RaidPuzzleManager.E_RoomStatus.Lock then
        tarColor = _LuaGeometry.GetTempColor(0.39215686274509803, 0.39215686274509803, 0.39215686274509803, 1)
      elseif tarStatus == RaidPuzzleManager.E_RoomStatus.Unlock then
        tarColor = _LuaGeometry.GetTempColor(1, 1, 1, 1)
      else
        tarColor = _LuaGeometry.GetTempColor(1, 1, 1, 0)
      end
      for i = 1, #roomMap do
        if roomMap[i] then
          TweenColor.Begin(roomMap[i].gameObject, duration, tarColor)
          if self.forbidMapTextureClick then
            roomMap[i].enabled = tarStatus ~= RaidPuzzleManager.E_RoomStatus.Disable and tarStatus ~= RaidPuzzleManager.E_RoomStatus.Lock
          end
        end
      end
      self.puzzleRoomsStatusMap[name] = tarStatus
    end
  end
end

function MiniMapWindow:RemovePuzzleMap()
  self.forbidMapTextureClick = nil
  for roomID, roomMap in pairs(self.puzzleRoomsColliderMap) do
    ReusableTable.DestroyAndClearTable(roomMap)
  end
  TableUtility.TableClear(self.puzzleRoomsColliderMap)
  TableUtility.TableClear(self.puzzleRoomsStatusMap)
  TableUtility.TableClear(self.puzzleRoomsObjAreaMap)
  if self.objPuzzleMap then
    LuaGameObject.DestroyObject(self.objPuzzleMap)
  end
  self.objPuzzleMap = nil
  self.curActivePuzzleAreaID = nil
end

function MiniMapWindow:UpdatePuzzleMapSize()
  if not self.objPuzzleMap or not self.mapTexture then
    return
  end
  local texture = self.mapTexture.mainTexture
  if not texture then
    return
  end
  self.objPuzzleMap.transform.localScale = _LuaGeometry.GetTempVector3(self.mapsize.x / texture.width, self.mapsize.y / texture.height, 1)
end

function MiniMapWindow:UpdateMapCircleAreas(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.CIRCLE, datas, isRemoveOther)
end

function MiniMapWindow:_CreateMapCircleArea(data)
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
      symbol.name = "Sliced" .. tostring(data.id)
      return symbol
    end
  end
end

function MiniMapWindow:_RemoveMapCircleArea(id, symbolObj)
  self:RemoveMiniMapSymbol(symbolObj)
  self.isShowCircleArea = false
end

function MiniMapWindow:_CreateMapFlowerCar(data)
  local symbol = self:GetMapSymbol(data:GetParama("Symbol"), data:GetParama("depth") or 5, nil, self.self_symbolParent)
  symbol.name = "FC_" .. tostring(data.id)
  return symbol
end

function MiniMapWindow:_CreateMapTrainEscort(data)
  local symbol = self:GetMapSymbol(data:GetParama("Symbol"), data:GetParama("depth") or 5, nil, self.self_symbolParent)
  symbol.name = "TE_" .. tostring(data.id)
  return symbol
end

function MiniMapWindow:UpdateLocalNpcPos(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.LocalNpc, datas, isRemoveOther)
end

function MiniMapWindow:_CreateLocalNpcPosSymbol(data)
  local symbol = self:GetMapSymbol(data:GetParama("Symbol"), data:GetParama("depth"), 1.5, self.d_symbolParent)
  symbol.name = tostring(data.id)
  return symbol
end

local AreaTips_Path = ResourcePathHelper.UICell("MiniMapSymbol_AreaTips")

function MiniMapWindow:UpdateAreaTips(datas)
  self.areaTipsCacheMap = self.areaTipsCacheMap or {}
  local symbol
  for key, data in pairs(datas) do
    symbol = self.areaTipsCacheMap[key]
    if symbol then
      self:_UpdateAreaTips(symbol, data)
    else
      symbol = self:_CreateAreaTips(data)
    end
    self.areaTipsCacheMap[key] = symbol
  end
  for key, obj in pairs(self.areaTipsCacheMap) do
    if not datas[key] then
      self:_RemoveAreaTips(obj)
      self.areaTipsCacheMap[key] = nil
    end
  end
end

function MiniMapWindow:_CreateAreaTips(data)
  if not self:IsAreaTipsUnlocked(data) then
    return nil
  end
  local symbol = _Game.AssetManager_UI:CreateAsset(AreaTips_Path, self.s_symbolParent)
  if not IsNull(symbol) then
    symbol:SetActive(true)
    symbol.transform.localRotation = _LuaGeometry.Const_Qua_identity
    symbol.transform.localScale = _LuaGeometry.Const_V3_one
    self:_UpdateAreaTips(symbol, data)
  end
  return symbol
end

function MiniMapWindow:_UpdateAreaTips(symbolObj, data)
  if not self:IsAreaTipsUnlocked(data) then
    if not IsNull(symbolObj) then
      LuaGameObject.DestroyObject(symbolObj)
    end
    return nil
  end
  local scale = math.min(self.mapsize.x, self.mapsize.y) / self.DefaultMapTextureSize
  local tempV3 = LuaGeometry.GetTempVector3()
  LuaVector3.Better_Mul(data.pos, scale, tempV3)
  symbolObj.transform.localPosition = tempV3
  local label = symbolObj:GetComponent(UILabel)
  label.text = data:GetParama("Text") or ""
  label.fontSize = math.floor(14 * scale)
end

function MiniMapWindow:IsAreaTipsUnlocked(data)
  if not self.blockUnlockInfo then
    return true
  end
  local pos = data.pos
  if not pos then
    return true
  end
  local zoneMap = WorldMapProxy.Instance:GetZoneMap()
  if not zoneMap then
    return true
  end
  local checkRadius = 500
  local hasUnlockedZone = false
  for id, zoneData in pairs(zoneMap) do
    local center = zoneData:GetCenter()
    if center and #center == 3 then
      local dx = center[1] - pos[1]
      local dy = center[2] - pos[2]
      local dz = center[3] - pos[3]
      local dist = math.sqrt(dx * dx + dy * dy + dz * dz)
      if checkRadius > dist then
        local groupId = zoneData:GetGroupId()
        if groupId and self.blockUnlockInfo[groupId] ~= false then
          hasUnlockedZone = true
          break
        end
      end
    end
  end
  return hasUnlockedZone
end

function MiniMapWindow:_RemoveAreaTips(symbolObj)
  LuaGameObject.DestroyObject(symbolObj)
end

function MiniMapWindow:UpdateGvgSymbol(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.MetalGvg_MetalIcon, datas, isRemoveOther)
end

function MiniMapWindow:UpdateWildMvpSymbols(isRemoveOther, forceUpdate)
  local datas = WildMvpProxy.Instance:GetCurMiniMapMonsterData()
  if not datas then
    return
  end
  local checkDistance
  if forceUpdate then
    checkDistance = -1
  end
  self:UpdateMapSymbolDatas(Type.WildMvp, datas, isRemoveOther, checkDistance)
end

function MiniMapWindow:UpdateWildMvpSymbolProgress()
  if self.wildMvpSymbols then
    for _, v in pairs(self.wildMvpSymbols) do
      if v then
        v:UpdateProgress()
      end
    end
  end
end

local WildMvpSymbolPath = ResourcePathHelper.UICell("MiniMapSymbol_WildMvp")

function MiniMapWindow:_CreateWildMvpSymbol(data)
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

function MiniMapWindow:_UpdateWildMvpSymbol(obj, data)
  if obj and data and self.wildMvpSymbols then
    local symbol = self.wildMvpSymbols[data.id]
    symbol:SetData(data)
  end
  return obj
end

function MiniMapWindow:_RemoveWildMvpSymbol(id, symbolObj)
  if not Slua.IsNull(symbolObj) then
    _Game.GOLuaPoolManager:AddToUIPool(WildMvpSymbolPath, symbolObj)
  end
  if self.wildMvpSymbols then
    self.wildMvpSymbols[id] = nil
  end
end

local _current_max_block_size = 370

function MiniMapWindow:UpdateZoneBlocks()
  local curMapId = self.mapdata and self.mapdata.id or _Game.MapManager:GetMapID()
  if not _Game.MapManager.IsMapBigWorld(curMapId) then
    return
  end
  if not self.zoneBlockMap then
    self.zoneBlockMap = {}
  else
    TableUtility.TableClearByDeleter(self.zoneBlockMap, MiniMapDataRemoveFunc)
  end
  if self.blockUnlockInfo == nil then
    self.blockUnlockInfo = {}
  else
    TableUtility.TableClear(self.blockUnlockInfo)
  end
  local curGroupID = self:GetCurTransmitterGroup()
  local activePoints = WorldMapProxy.Instance.activeTransmitterPoints
  local transferPoint, transferID
  local mapDatas = WorldMapProxy.Instance:GetTransmitterMapByGroup(curGroupID)
  local curMapID = _Game.MapManager:GetMapID()
  if mapDatas then
    for mapID, transfers in pairs(mapDatas) do
      for i = 1, #transfers do
        transferPoint = transfers[i]
        if transferPoint.MapID == curMapID then
          transferID = transferPoint.id
          self.blockUnlockInfo[i] = activePoints[transferID] == 1
        end
      end
    end
  end
  local zoneMap = WorldMapProxy.Instance:GetZoneMap()
  if zoneMap then
    for id, zoneData in pairs(zoneMap) do
      local blockCenter = zoneData.GetBlockCenter and zoneData:GetBlockCenter()
      if blockCenter then
        local group_id = zoneData:GetGroupId()
        self.zoneBlockMap[id] = MiniMapData.CreateAsTable(id)
        self.zoneBlockMap[id]:SetParama("depth", 30)
        self.zoneBlockMap[id]:SetParama("group_id", group_id)
        self.zoneBlockMap[id]:SetParama("Texture", string.format("%s_mini_%02d", self.mapTexName, group_id))
        self.zoneBlockMap[id]:SetParama("unlocked", self.blockUnlockInfo[group_id])
        self.zoneBlockMap[id]:SetPos(blockCenter[1], blockCenter[2], blockCenter[3])
        local defaultShowRange = (math.max(self.panelSize[1], self.panelSize[2]) + self.mapsize.x / 1024 * _current_max_block_size) / 2
        if self.map2D then
          defaultShowRange = self.map2D.size.x / self.mapsize.x * defaultShowRange
        end
        self.zoneBlockMap[id]:SetShowRange(defaultShowRange)
      end
    end
  end
  self:UpdateMapSymbolDatas(Type.ZoneBlock, self.zoneBlockMap, true, -1)
  self:UpdateMapBorderUnlock()
  self:RefreshScenicSpotsByUnlockChange()
end

function MiniMapWindow:RefreshScenicSpotsByUnlockChange()
  local scenicSpotDatas = self.allMapDatas[Type.ScenicSpot]
  if scenicSpotDatas then
    self:UpdateMapSymbolDatas(Type.ScenicSpot, scenicSpotDatas, true, -1)
  end
  if self.areaTipsCacheMap then
    for key, symbol in pairs(self.areaTipsCacheMap) do
    end
  end
end

function MiniMapWindow:RemoveZoneBlocks()
  self:UpdateMapSymbolDatas(Type.ZoneBlock, _EmptyTable, true)
  self:UpdateMapBorderUnlock(false)
end

local ZoneBlock_Path = ResourcePathHelper.UICell("MiniMapSymbol_ZoneBlock")

function MiniMapWindow:_CreateZoneBlock(data)
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

function MiniMapWindow:_UpdateZoneBlock(symbolObj, data)
  local tex = symbolObj:GetComponent(UITexture)
  local texName = data:GetParama("Texture") or ""
  local oldName = tex.gameObject.name
  if texName ~= oldName then
    if oldName ~= "" then
      _PictureManager:UnLoadMiniMap(oldName, tex)
      data:SetShowRange(0)
    end
    if texName ~= "" then
      _PictureManager:SetMiniMap(texName, tex)
      tex.gameObject.name = texName
      local pct = self.mapsize.x / 1024
      tex:MakePixelPerfect()
      tex.width = tex.width * pct
      tex.height = tex.height * pct
      local showRange = (math.max(tex.width, tex.height) + math.max(self.panelSize[1], self.panelSize[2])) / 2
      if self.map2D then
        showRange = self.map2D.size.x / self.mapsize.x * showRange
      end
      data:SetShowRange(showRange)
    end
  end
  tex.depth = data:GetParama("depth") or 10
  tex.alpha = data:GetParama("unlocked") and 0 or 1
  return symbolObj
end

function MiniMapWindow:_RemoveZoneBlock(id, symbolObj)
  local tex = symbolObj:GetComponent(UITexture)
  local oldName = tex.gameObject.name
  if oldName ~= "" then
    _PictureManager:UnLoadMiniMap(oldName, tex)
  end
  if not Slua.IsNull(symbolObj) then
    _Game.GOLuaPoolManager:AddToUIPool(ZoneBlock_Path, symbolObj)
  end
end

function MiniMapWindow:SetMiniMapBorder(name)
  local mapTexName = self.mapTexName
  if mapTexName == name then
    return
  end
  local texture = self.mapBorderTexture
  if mapTexName ~= nil then
    _PictureManager:UnLoadMiniMap(mapTexName .. "_border", texture)
  end
  if name ~= nil and not miniMapPrefab[name] then
    _PictureManager:SetMiniMap(name .. "_border", texture)
  end
end

function MiniMapWindow:UpdateMapBorderUnlock(forceSetValue)
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
  if not IsNull(self.mapBorderTexture) then
    self.mapBorderTexture.alpha = borderUnlock and 0 or 1
  end
end

function MiniMapWindow:_CreateGvgFightPointSymbol(data)
  local symbol = data:GetParama("Symbol")
  local depth = data:GetParama("Depth")
  local obj = self:GetMapSymbol(symbol, depth, nil, self.s_symbolParent)
  obj.name = "GvG_FightPoint"
  SetLocalPositionObj(obj, 10000, 10000, 10000)
  return obj
end

function MiniMapWindow:UpdateGvgFightPointSymbol(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.GvgFightPoint, datas, isRemoveOther)
end

local GVG_POINT_TYPES = {
  FRIEND_LEADER = {
    type = Type.GvgFriendLeaderPoint,
    name = "GvG_FriendLeaderPoint"
  },
  ENEMY_LEADER = {
    type = Type.GvgEnemyLeaderPoint,
    name = "GvG_EnemyLeaderPoint"
  },
  FRIEND_CHAIRMAN = {
    type = Type.GvgFriendChairmanPoint,
    name = "GvG_FriendChairmanPoint"
  },
  ENEMY_CHAIRMAN = {
    type = Type.GvgEnemyChairmanPoint,
    name = "GvG_EnemyChairmanPoint"
  }
}

function MiniMapWindow:_CreateGvgPointSymbol(data, pointType)
  local symbol = data:GetParama("Symbol")
  local depth = data:GetParama("Depth")
  local obj = self:GetMapSymbol(symbol, depth, nil, self.s_symbolParent)
  obj.name = pointType.name
  return obj
end

function MiniMapWindow:UpdateGvgPointSymbol(datas, pointType, isRemoveOther)
  self:UpdateMapSymbolDatas(pointType.type, datas, isRemoveOther)
end

function MiniMapWindow:_CreateGvgFriendLeaderPointSymbol(data)
  return self:_CreateGvgPointSymbol(data, GVG_POINT_TYPES.FRIEND_LEADER)
end

function MiniMapWindow:_CreateGvgEnemyLeaderPointSymbol(data)
  return self:_CreateGvgPointSymbol(data, GVG_POINT_TYPES.ENEMY_LEADER)
end

function MiniMapWindow:_CreateGvgFriendChairmanPointSymbol(data)
  return self:_CreateGvgPointSymbol(data, GVG_POINT_TYPES.FRIEND_CHAIRMAN)
end

function MiniMapWindow:_CreateGvgEnemyChairmanPointSymbol(data)
  return self:_CreateGvgPointSymbol(data, GVG_POINT_TYPES.ENEMY_CHAIRMAN)
end

function MiniMapWindow:UpdateGvgFriendLeaderPointSymbol(datas, isRemoveOther)
  self:UpdateGvgPointSymbol(datas, GVG_POINT_TYPES.FRIEND_LEADER, isRemoveOther)
end

function MiniMapWindow:UpdateGvgEnemyLeaderPointSymbol(datas, isRemoveOther)
  self:UpdateGvgPointSymbol(datas, GVG_POINT_TYPES.ENEMY_LEADER, isRemoveOther)
end

function MiniMapWindow:UpdateGvgFriendChairmanPointSymbol(datas, isRemoveOther)
  self:UpdateGvgPointSymbol(datas, GVG_POINT_TYPES.FRIEND_CHAIRMAN, isRemoveOther)
end

function MiniMapWindow:UpdateGvgEnemyChairmanPointSymbol(datas, isRemoveOther)
  self:UpdateGvgPointSymbol(datas, GVG_POINT_TYPES.ENEMY_CHAIRMAN, isRemoveOther)
end

function MiniMapWindow:_CreateYahahaSymbol(data)
  local symbol = data:GetParama("Symbol")
  local obj = self:GetMapSymbol(symbol, 6, nil, self.d_symbolParent)
  obj.name = symbol
  self:_UpdateYahahaSymbol(obj, data)
  return obj
end

function MiniMapWindow:_UpdateYahahaSymbol(obj, data)
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

function MiniMapWindow:UpdateYahahaSymbol(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.Yahaha, datas, isRemoveOther)
end

function MiniMapWindow:BeginCheckSymbolHintParam()
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

function MiniMapWindow:CheckSymbolHintParam(cacheMap, datas, type)
  if self.symbolHintParam and self.symbolHintParam[type] then
    local symbolData
    if typeof(self.symbolHintParam[type]) == "table" then
      for key, symbolObj in pairs(cacheMap) do
        symbolData = datas[key]
        if self:_CheckSymbolHintParam(symbolData, self.symbolHintParam[type], type) then
          self:PlaySymbolHint(symbolObj, symbolData)
        end
      end
    else
      for key, symbolObj in pairs(cacheMap) do
        symbolData = datas[key]
        self:PlaySymbolHint(symbolObj, symbolData)
      end
    end
  end
end

function MiniMapWindow:SetSymbolHintParam(param)
  if not param then
    return
  end
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
        for _, icon in pairs(v.icons) do
          self.symbolHintParam[t][icon] = true
        end
      else
        self.symbolHintParam[t] = true
      end
    end
  end
  self:BeginCheckSymbolHintParam()
end

function MiniMapWindow:ClearSymbolHintParam()
  self.symbolHintParam = nil
end

local symbolHintCountMax = 20
local symbolHintScale = 0.15

function MiniMapWindow:PlaySymbolHint(symbolObj, symbolData)
  if self.symbolHintCount >= symbolHintCountMax then
    return
  end
  self.symbolHintCount = self.symbolHintCount + 1
  self:PlayUIEffect(EffectMap.UI.MapHintSymbol, symbolObj.gameObject, true, nil, nil, symbolHintScale)
end

function MiniMapWindow:_CheckSymbolHintParam(symbolData, symbolHintParam, type)
  if not symbolData or not symbolHintParam then
    return
  end
  if type == Type.QuestNpc then
    local symbolType = symbolData:GetParama("SymbolType")
    local config = QuestSymbolConfig[symbolType]
    if config then
      local symbol = config.UISpriteName or config.UISymbol
      return symbol and symbolHintParam[symbol]
    end
  elseif type == Type.QuestFocus then
  elseif type == Type.Transmitter then
  elseif type == Type.CIRCLE then
  elseif type == Type.WildMvp then
    local symbol = symbolData:GetActiveMapSymbolIcon()
    return symbol and symbolHintParam[symbol]
  elseif type == Type.AreaTips then
  elseif type == Type.ZoneTips then
  elseif type == Type.ZoneBlock then
  else
    local symbol = symbolData:GetParama("Symbol")
    return symbol and symbolHintParam[symbol]
  end
end

function MiniMapWindow:UpdateCameraPos()
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

function MiniMapWindow:UpdateCameraSymbol()
  if FunctionCameraEffect.Me():IsFreeCameraLocked() then
    self.cameraSymbol:SetActive(false)
  else
    self.cameraSymbol:SetActive(true)
  end
end

function MiniMapWindow:UpdateTripleTeamsSymbol(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.TripleTeams, datas, isRemoveOther)
end

function MiniMapWindow:UpdateEBFEventAreaSymbol(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.EBFEventArea, datas, isRemoveOther)
end

function MiniMapWindow:_CreateEBFEventAreaSymbol(data)
  if not self.ebfEventAreaEffectMap then
    self.ebfEventAreaEffectMap = {}
  end
  local texture = self.mapTexture.mainTexture
  if not texture then
    return
  end
  local symbol = self:GetEBFMapSymbol(data, 4)
  symbol.transform.localScale = _LuaGeometry.GetTempVector3(self.mapsize.x / texture.width, self.mapsize.y / texture.height, 1)
  symbol.name = "EBF_" .. tostring(data.id)
  return symbol
end

function MiniMapWindow:_UpdateEBFEventAreaSymbol(symbolObj, data)
  if IsNull(symbolObj) then
    return
  end
  local areaSymbol = data:GetParama("areaSymbol")
  local range = data:GetParama("range")
  local size = range and self:SceneSizeToMap(range, range)
  self:SetEBFAreaSymbol(symbolObj, areaSymbol, size)
  local nextEventId = EndlessBattleFieldProxy.Instance:GetNextEventId()
  if EndlessBattleFieldProxy.Instance:IsEventActive(data.id) or data.id == nextEventId then
    local effectContainer = symbolObj.transform:Find("effectContainer")
    self:CreateEBFEventAreaEffect(data.id, effectContainer)
  else
    self:DestroyEBFEventAreaEffect(data.id)
  end
  return symbolObj
end

function MiniMapWindow:_RemoveEBFEventAreaSymbol(key, symbolObj)
  if IsNull(symbolObj) then
    return
  end
  self:DestroyEBFEventAreaEffect(key)
  GameObject.DestroyImmediate(symbolObj)
end

local EBFMapSymbolPath = ResourcePathHelper.UICell("MiniMapSymbol_EBF")

function MiniMapWindow:GetEBFMapSymbol(miniMapData, depth, parent)
  local resultGO = _Game.AssetManager_UI:CreateAsset(EBFMapSymbolPath, parent or self.s_symbolParent)
  resultGO:SetActive(true)
  SetLocalPositionObj(resultGO, 0, 0, 0)
  SetLocalRotationObj(resultGO, 0, 0, 0, 1)
  SetLocalScaleObj(resultGO, 1, 1, 1)
  local centerSymbol = miniMapData:GetParama("Symbol")
  local areaSymbol = miniMapData:GetParama("areaSymbol")
  local range = miniMapData:GetParama("range")
  local size = range and self:SceneSizeToMap(range, range)
  local centerSp = resultGO:GetComponent(UISprite)
  IconManager:SetMapIcon(centerSymbol, centerSp)
  centerSp:MakePixelPerfect()
  local areaSp, effectContainer = self:SetEBFAreaSymbol(resultGO, areaSymbol, size)
  if depth then
    centerSp.depth = depth + 1
    if areaSp then
      areaSp.depth = depth
    end
    if effectContainer then
      effectContainer.depth = depth - 1
    end
  end
  return resultGO
end

function MiniMapWindow:SetEBFAreaSymbol(symbolObj, areaSymbol, size)
  local areaTrans = symbolObj.transform:Find("Area")
  local areaSp = areaTrans and areaTrans.gameObject:GetComponent(UISprite)
  if areaSp then
    IconManager:SetMapIcon(areaSymbol, areaSp)
    areaSp:MakePixelPerfect()
  end
  local effectContainerTrans = symbolObj.transform:Find("effectContainer")
  local effectContainer = effectContainerTrans and effectContainerTrans.gameObject:GetComponent(ChangeRqByTex)
  return areaSp, effectContainer
end

function MiniMapWindow:CreateEBFEventAreaEffect(id, effectContainer)
  if not self.ebfEventAreaEffectMap[id] and effectContainer then
    local effect = self:PlayUIEffect(EffectMap.UI.EndlessBattle_ActiveEventArea, effectContainer.gameObject)
    self.ebfEventAreaEffectMap[id] = effect
  end
end

function MiniMapWindow:DestroyEBFEventAreaEffect(id)
  local effect = self.ebfEventAreaEffectMap[id]
  if effect and effect:Alive() then
    effect:Destroy()
    self.ebfEventAreaEffectMap[id] = nil
  end
end

function MiniMapWindow:UpdateAstralTowerSymbol(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.Astral, datas, isRemoveOther)
end

function MiniMapWindow:_CreateFakeDragonSymbol(data)
  local symbol = data:GetParama("Symbol")
  local obj = self:GetMapSymbol(symbol, 32, nil, self.monster_symbolParent)
  obj.name = symbol
  self:_UpdateFakeDragonSymbol(obj, data)
  return obj
end

function MiniMapWindow:_RemoveFakeDragonSymbol(id, symbolObj)
  redlog("MiniMapWindow:_RemoveFakeDragonSymbol", symbolObj, data)
  if not Slua.IsNull(symbolObj) then
    _Game.GOLuaPoolManager:AddToUIPool(MonsterPoint_Path, symbolObj)
  end
end

function MiniMapWindow:_UpdateFakeDragonSymbol(obj, data)
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
    self:HelpUpdatePos(obj, data.pos)
  end
  return obj
end

function MiniMapWindow:UpdateAbyssDragonSymbol(datas, isRemoveOther)
  for id, effect in pairs(self.abyssDragonEffectMap) do
    if not datas[id] then
      self:_RemoveAbyssDragonSymbol(id, effect)
    end
  end
  for id, data in pairs(datas) do
    if not self.abyssDragonEffectMap[id] then
      self:_CreateAbyssDragonSymbol(data)
    else
      self:_UpdateAbyssDragonSymbol(self.abyssDragonEffectMap[id], data)
    end
  end
end

function MiniMapWindow:_CreateAbyssDragonSymbol(data)
  local path = data:GetParama("effect")
  local pos = data:GetPos()
  if path then
    local effect = self:PlayUIEffect(path, self.myselfPanel.gameObject, false)
    self.abyssDragonEffectMap[data.id] = effect
    pos = self:ScenePosToMap(pos)
    if pos then
      effect:ResetLocalPosition(pos)
    end
  end
end

function MiniMapWindow:_UpdateAbyssDragonSymbol(effect, data)
  local pos = data:GetPos()
  pos = self:ScenePosToMap(pos)
  if effect and pos then
    effect:ResetLocalPosition(pos)
  end
end

function MiniMapWindow:_RemoveAbyssDragonSymbol(id, effect)
  if effect then
    effect:Destroy()
    self.abyssDragonEffectMap[id] = nil
  end
end

function MiniMapWindow:UpdateFakeDragonSymbol(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.FakeDragon, datas, isRemoveOther)
end

function MiniMapWindow:UpdateFairyTaleSymbol(datas, isRemoveOther)
  self:UpdateMapSymbolDatas(Type.FairyTale, datas, isRemoveOther)
end

local FairyTaleMapSymbolPath = ResourcePathHelper.UICell("MiniMapSymbol_FairyTale")

function MiniMapWindow:_CreateFairyTaleSymbol(data)
  local resultGO = _Game.AssetManager_UI:CreateAsset(FairyTaleMapSymbolPath, self.d_symbolParent)
  resultGO:SetActive(true)
  SetLocalPositionObj(resultGO, 0, 0, 0)
  SetLocalRotationObj(resultGO, 0, 0, 0, 1)
  SetLocalScaleObj(resultGO, 1, 1, 1)
  local symbol = MiniMapSymbol_FairyTale.new(resultGO)
  symbol:SetData(data)
  self.fairyTaleSymbolMap[data.id] = symbol
  return resultGO
end

function MiniMapWindow:_UpdateFairyTaleSymbol(symbolObj, data)
  local symbol = self.fairyTaleSymbolMap[data.id]
  if symbol then
    symbol:SetData(data)
  end
  return symbolObj
end

function MiniMapWindow:_RemoveFairyTaleSymbol(key, symbolObj)
  if not IsNull(symbolObj) then
    GameObject.DestroyImmediate(symbolObj)
  end
  self.fairyTaleSymbolMap[key] = nil
end
