autoImport("MiniMapWindow")
WorldMapMiniMapWindow = class("WorldMapMiniMapWindow", MiniMapWindow)
local tempV3, tempRot = LuaVector3(), LuaQuaternion()
local IsRunOnEditor = ApplicationInfo.IsRunOnEditor()
local Type = MiniMapWindow.Type

function WorldMapMiniMapWindow:InitView()
  self.sPanel = self:FindComponent("Panel_S", UIPanel)
  self.dPanel = self:FindComponent("Panel_D", UIPanel)
  local panelSize = self.sPanel:GetViewSize()
  self.panelSize = {
    panelSize.x,
    panelSize.y
  }
  
  function self.sPanel.onClipMove()
    self.dPanel.clipOffset = self.sPanel.clipOffset
    self.dPanel.transform.localPosition = self.sPanel.transform.localPosition
  end
  
  self.mapTexture = self:FindComponent("MapTexture", UITexture, self.sPanel.gameObject)
  self.mapLabel = self:FindGO("MapLabel", self.mapTexture.gameObject)
  self.s_symbolParent = self:CreateSymbolsParent(self.mapTexture.transform, "symbolsParent")
  self.d_symbolParent = self:CreateSymbolsParent(self.dPanel, "symbolsParent")
  if self.destTransEffect then
    self.destTransEffect:Destroy()
    self.destTransEffect = nil
  end
  self:PlayUIEffect(EffectMap.UI.MapPoint, self.d_symbolParent.gameObject, false, function(obj, args, assetEffect)
    self.destTransEffect = assetEffect
    self.destTransEffect:RegisterWeakObserver(self)
    self.destTransEffect:SetActive(false)
  end, self)
  if self.tipTransEffect then
    self.tipTransEffect:Destroy()
    self.tipTransEffect = nil
  end
  self:PlayUIEffect(EffectMap.UI.MapPoint2, self.d_symbolParent.gameObject, false, function(obj, args, assetEffect)
    self.tipTransEffect = assetEffect
    self.tipTransEffect:RegisterWeakObserver(self)
    self.tipTransEffect:SetActive(false)
  end, self)
  local eventManager = EventManager.Me()
  eventManager:AddEventListener(LoadSceneEvent.BeginLoadScene, self.OnSceneBeginChanged, self)
end

function WorldMapMiniMapWindow:ObserverDestroyed(obj)
  if obj == self.destTransEffect then
    self.destTransEffect = nil
  elseif obj == self.tipTransEffect then
    self.tipTransEffect = nil
  end
end

function WorldMapMiniMapWindow:UpdateMapTexture(data, size, sceneinfo, map2D, map2DID)
  self.mapdata = data
  if map2DID then
    self.map2DId = map2DID
  end
  self.map2D = map2D
  local mapSceneInfo = sceneinfo
  if self.minimapTextureName ~= nil then
    PictureManager.Instance:UnLoadMiniMap(self.minimapTextureName, self.mapTexture)
  end
  if data then
    local resName = "Scene" .. data.NameEn
    if self.map2DId ~= 0 and self.map2DId ~= nil then
      resName = resName .. "_" .. self.map2DId
    end
    self.minimapTextureName = resName
    PictureManager.Instance:SetMiniMap(self.minimapTextureName, self.mapTexture)
    if size then
      self.mapTexture.width = size[1]
      self.mapTexture.height = size[2]
    end
  else
    self.mapTexture.mainTexture = nil
    self.minimapTextureName = nil
  end
  if self.mapdata then
    local fName = "Scene_" .. self.mapdata.NameEn
    local sceneInfo = autoImport(fName)
    ClearTableFromG(fName)
    if sceneInfo.MapInfo and sceneInfo.MapInfo[self.map2DId] then
      self.sceneSize = sceneInfo.MapInfo[self.map2DId].Size
      self.sceneMinPos = sceneInfo.MapInfo[self.map2DId].MinPos
    else
      LogUtility.Error("指定地图scene文件map2D信息错误", self.mapdata.NameEn)
      if sceneInfo.MapInfo then
        self.sceneSize = sceneInfo.MapInfo.Size
        self.sceneMinPos = sceneInfo.MapInfo.MinPos
      end
    end
  else
    return
  end
  self.mapsize.x = self.mapTexture.width
  self.mapsize.y = self.mapTexture.height
  local minX, minZ, sizeX, sizeZ = map2D:GetMinPosAndSizeForLua()
  self.mapSceneMinPos:Set(minX, minZ)
  self.mapSceneSize:Set(sizeX, sizeZ)
  NGUITools.UpdateWidgetCollider(self.mapTexture.gameObject)
  self:UpdateNpcPoints(mapSceneInfo)
  self:UpdateExitPoints(mapSceneInfo)
  if not self.emptyParama then
    self.emptyParama = {}
  end
  self:UpdateQuestNpcSymbol(self.emptyParama, true)
  self:RefreshMapSymbols()
end

local miniMapRemoveFunc = function(data)
  data:Destroy()
end

function WorldMapMiniMapWindow:Show()
  self.active = true
  self.gameObject:SetActive(true)
  self:PlayQuestSymbolShow()
  TimeTickManager.Me():CreateTick(10, 1000, self.RefreshMapSymbols, self, 10086)
end

function WorldMapMiniMapWindow:UpdateNpcPoints(mapSceneInfo)
  if nil == self.npcMapDatas then
    self.npcMapDatas = {}
  else
    TableUtility.TableClearByDeleter(self.npcMapDatas, miniMapRemoveFunc)
  end
  if mapSceneInfo then
    local npcList = mapSceneInfo.nps
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
            if isUnlock and FunctionNpcFunc.checkNPCValid(v.uniqueID) then
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
    else
      redlog("Cur Sceneinfo's nps is nil, please check")
    end
  end
  self:UpdateMapSymbolDatas(Type.Npc, self.npcMapDatas)
end

function WorldMapMiniMapWindow:UpdateExitPoints(mapSceneInfo)
  if nil == self.exitMapDatas then
    self.exitMapDatas = {}
  else
    TableUtility.TableClearByDeleter(self.exitMapDatas, miniMapRemoveFunc)
  end
  if mapSceneInfo then
    local exitList = mapSceneInfo.eps
    local forbidInnerEp = Game.MapManager:IsMapForbidInnerExitPoint(self.mapdata.id)
    if exitList then
      local table_Map = Table_Map
      for i = 1, #exitList do
        local v = exitList[i]
        if v and v.ID and v.position then
          local exitData = self.exitMapDatas[v.ID]
          if exitData == nil then
            exitData = MiniMapData.CreateAsTable(v.ID, v.position, parama)
          end
          exitData:SetPos(v.position[1], v.position[2], v.position[3])
          local active = Game.AreaTrigger_ExitPoint:IsInvisible(v.ID) == false
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
              exitData:SetParama("index", 64)
            end
          end
          self.exitMapDatas[v.ID] = exitData
        end
      end
    end
  end
  self:UpdateMapSymbolDatas(Type.ExitPoint, self.exitMapDatas)
end

function WorldMapMiniMapWindow:UpdateMyPos(forceUpdate)
  local role = Game.Myself
  if role then
    local nowMyPos = role:GetPosition()
    if not nowMyPos then
      return
    end
    if self.mapdata then
      helplog("地图对比，", Game.MapManager:GetMapID(), self.mapdata.id)
      if Game.MapManager:GetMapID() ~= self.mapdata.id then
        redlog("地图不通，不显示自己标记")
        self.myTrans.gameObject:SetActive(false)
      else
        self.myTrans.gameObject:SetActive(true)
      end
    else
      return
    end
    if forceUpdate or VectorUtility.DistanceXZ_Square(self.lastMyPos, nowMyPos) > 1.0E-4 then
      self:HelpUpdatePos(self.myTrans, nowMyPos)
      local angleY = role:GetAngleY()
      if angleY then
        LuaQuaternion.Better_SetEulerAngles(tempRot, LuaGeometry.GetTempVector3(0, 0, -angleY))
        self.myTrans.rotation = tempRot
      end
      if self.updateEvent then
        self.updateEvent(self.updateEventOwner, self)
      end
      self.iMoved = true
      self.lastMyPos:Set(nowMyPos[1], 0, nowMyPos[3])
    else
      self.iMoved = false
    end
    self:UpdateFocusArrowPos()
  end
end

local tempArgs = {}

function WorldMapMiniMapWindow:AddMapClick()
  local uiCamera = NGUIUtil:GetCameraByLayername("UI")
  self:AddClickEvent(self.mapTexture.gameObject, function(go)
    helplog("WorldMapMiniMapWindow:MapClick")
    if self.lock then
      return
    end
    local inputWorldPos = uiCamera:ScreenToWorldPoint(Input.mousePosition)
    tempV3[1], tempV3[2], tempV3[3] = LuaGameObject.InverseTransformPointByVector3(self.mapTexture.transform, inputWorldPos)
    local p = self:MapPosToScene(tempV3)
    if p then
      local currentMapID = Game.MapManager:GetMapID()
      local disableInnerTeleport = Table_Map[currentMapID].MapNavigation
      helplog("地图信息", self.mapdata.id, currentMapID, self.mapdata.id == currentMapID)
      if nil ~= disableInnerTeleport and 0 ~= disableInnerTeleport and self.mapdata.id == currentMapID then
        helplog("同地图")
        Game.Myself:TryUseQuickRide()
        self:ResetMoveCMD(nil)
        Game.Myself:Client_MoveTo(p)
      else
        redlog("非同地图移动，目标pos", p)
        TableUtility.TableClear(tempArgs)
        tempArgs.targetMapID = self.mapdata.id
        tempArgs.targetPos = p
        tempArgs.showClickGround = true
        tempArgs.allowExitPoint = true
        Game.Myself:Logic_NavMeshPlaceTo(Game.Myself:GetPosition())
        local x, y, z = p[1], p[2], p[3]
        
        function tempArgs.callback(cmd, event)
          local nowMapId = Game.MapManager:GetMapID()
          if cmd.targetMapID ~= nowMapId then
            return
          end
          if MissionCommandMove.CallbackEvent.TeleportFailed == event then
            LuaVector3.Better_Set(tempV3, x, y, z)
            Game.Myself:Client_MoveTo(tempV3)
          end
        end
        
        local cmd = MissionCommandFactory.CreateCommand(tempArgs, MissionCommandMove)
        if cmd then
          Game.Myself:TryUseQuickRide()
          Game.Myself:Client_SetMissionCommand(cmd)
          GameFacade.Instance:sendNotification("WorldMapMiniMapWindow_ClickOutterDest", true)
        end
      end
    else
      redlog("p is nil")
    end
  end)
end

local scenePos_mapPos = LuaVector3.Zero()

function WorldMapMiniMapWindow:ScenePosToMap(pos)
  local mapPct = math.clamp((pos[1] - self.sceneMinPos.x) / self.sceneSize.x, 0, 1)
  scenePos_mapPos[1] = mapPct * self.mapsize.x - self.mapsize.x / 2
  mapPct = math.clamp((pos[3] - self.sceneMinPos.y) / self.sceneSize.y, 0, 1)
  scenePos_mapPos[2] = mapPct * self.mapsize.y - self.mapsize.y / 2
  return scenePos_mapPos
end

function WorldMapMiniMapWindow:IsScenePosValid(posX, posZ)
  return true
end

function WorldMapMiniMapWindow:OnDestroy()
  self:UpdateMapTexture()
  self.sPanel.onClipMove = nil
  if self.destTransEffect then
    self.destTransEffect:Destroy()
    self.destTransEffect = nil
  end
  if self.tipTransEffect then
    self.tipTransEffect:Destroy()
    self.tipTransEffect = nil
  end
  EventManager.Me():RemoveEventListener(LoadSceneEvent.BeginLoadScene, self.OnSceneBeginChanged, self)
end
