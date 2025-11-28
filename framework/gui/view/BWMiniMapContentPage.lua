BWMiniMapContentPage = class("BWMiniMapContentPage", SubView)
autoImport("BWMiniMapWindow")
local MapManager = Game.MapManager
local miniMapDataDeleteFunc = function(d)
  d:Destroy()
end
local _TableClearByDeleter = TableUtility.TableClearByDeleter
local _TeamProxy = TeamProxy.Instance
local _NSceneNpcProxy = NSceneNpcProxy.Instance
local TransmitFinished = function()
  GameFacade.Instance:sendNotification(LoadSceneEvent.BWTransmitFinished)
end

function BWMiniMapContentPage:Init()
  self:InitDatas()
  self:InitView()
  self:InitEvents()
end

function BWMiniMapContentPage:InitDatas()
  self.windowScale = 1
  self.nowMapID = MapManager:GetMapID()
  self.mapData = Table_Map[self.nowMapID]
  self.questShowDatas = {}
  self.teamMemberMapDatas = {}
  self.tempMap = {}
  self.monsterDataMap = {}
  self.fixedTreasureMap = {}
end

function BWMiniMapContentPage:InitView()
  local bord = self:FindGO("MapBord")
  self.window = BWMiniMapWindow.new(self:FindGO("MapContent", bord), 1)
  self.window:AddEventListener(BWMiniMapWindow.Event.ClickTransmitterButton, self.ClickTransmitterButton, self)
  self.title = self:FindComponent("MapName", UILabel, bord)
  self.title.text = self.mapData.NameZh
  local nearlyButton = self:FindGO("NearlyButton")
  self:AddClickEvent(nearlyButton, function()
    self.infoShow = not self.infoShow
    self.container:ToggleInfoBord(self.infoShow)
  end)
  self.locateButton = self:FindGO("LocateButton")
  local locateButtonIcon = self:FindComponent("Icon", UISprite, self.locateButton)
  IconManager:SetUIIcon("tab_icon_159", locateButtonIcon)
  self:AddClickEvent(self.locateButton, function()
    self.window:CenterOnMyPos(true)
    WorldMapProxy.Instance:DebugPrintZoneProgressInfo()
  end)
  local buttonsGO = self:FindGO("Buttons")
  self.bigMapButton = self:FindGO("BigMapButton")
  self.bigMapLab = self:FindComponent("Label", UILabel, self.bigMapButton)
  self:AddClickEvent(self.bigMapButton, function(go)
    if MapManager:IsRaidMode(true) then
      MsgManager.ConfirmMsgByID(7, function()
        ServiceNUserProxy.Instance:ReturnToHomeCity()
      end)
    else
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.WorldMapView,
        viewdata = {}
      })
      self.container:CloseSelf()
    end
  end)
  self.UseFlyButtonInfo = {}
  self.UseFlyButtonInfo.itemID = 5024
  self.UseFlyButtonInfo.msgID = 25439
  self.UseFlyButtonInfo.msgDoNotHaveID = 25444
  local useFlyWingsGO = self:FindGO("UseFlyWingsButton", buttonsGO)
  self.UseFlyButtonInfo.base = useFlyWingsGO:GetComponent(UISprite)
  self.UseFlyButtonInfo.icon = self:FindComponent("Icon", UISprite, useFlyWingsGO)
  IconManager:SetItemIcon("item_" .. self.UseFlyButtonInfo.itemID, self.UseFlyButtonInfo.icon)
  self:AddClickEvent(self.UseFlyButtonInfo.base.gameObject, function(go)
    self:TryUseFlyWing(self.UseFlyButtonInfo)
  end)
  local enlargeButton = self:FindGO("EnLargeButton", buttonsGO)
  self.enlargeSprite = enlargeButton:GetComponent(GradientUISprite)
  self:AddClickEvent(enlargeButton, function(go)
    self:EnLargeBigMap(not self.bigmapLarge)
  end)
  self.worldLineGO = self:FindGO("Map_WorldLine")
  self.map_currentLine = self:FindComponent("Map_CurrentLine", UILabel)
  self.worldLineChangeBtnSp = self:FindComponent("ChangeWorldLine", UISprite, self.frontMapInfo)
  self:AddClickEvent(self.worldLineChangeBtnSp.gameObject, function()
    ServiceNUserProxy.Instance:CallQueryZoneStatusUserCmd()
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ChangeZoneView
    })
    self.container:CloseSelf()
  end)
  self:UpdateCurrentLine()
  self.beforePanel = self:FindGO("BeforePanel")
  self.beforeCollider = self:FindGO("BeforeCollider")
  self.beforeCollider:SetActive(false)
  self.transferButton = self:FindGO("TransferButton")
  self.transferButton:SetActive(false)
  self:AddClickEvent(self.transferButton, function()
    if self.transferInfo then
      local data, id, state = self.transferInfo.data, self.transferInfo.id, self.transferInfo.state
      if state ~= MiniMapTransmitterButton.E_State.Activated then
        MsgManager.ShowMsgByIDTable(25800)
      else
        local transferConfig = Table_DeathTransferMap[id]
        local buffId = transferConfig and transferConfig.CdBuff
        if buffId and Game.Myself.data:HasBuffID(buffId) then
          MsgManager.ShowMsgByID(49)
          return
        end
        ServiceNUserProxy.Instance:CallUseDeathTransferCmd(0, id)
        FunctionSystem.InterruptMyMissionCommand()
        self:StartLoading()
      end
      self.transferInfo = nil
    end
    self.transferButton:SetActive(false)
  end)
end

function BWMiniMapContentPage:ClickTransmitterButton(button)
  if Game.Myself:IsDead() then
    return
  end
  self.transferButton:SetActive(true)
  local x, y, z = NGUIUtil.GetUIRePositionXYZ(button.gameObject, self.transferButton.transform.parent)
  LuaGameObject.SetLocalPositionGO(self.transferButton, x - 50, y - 30, z)
  self.transferInfo = {
    id = button.id,
    data = button.data,
    state = button.state
  }
  self:CreateLoading()
end

function BWMiniMapContentPage:UpdateCurrentLine()
  local myzoneId = MyselfProxy.Instance:GetZoneId()
  self.map_currentLine.text = ChangeZoneProxy.Instance:ZoneNumToString(myzoneId)
end

function BWMiniMapContentPage:UpdateMapChangeEvents()
  self:UpdateTeamMembersPos()
end

function BWMiniMapContentPage:UpdateWildMvpMonsters()
  if self.window then
    self.window:UpdateWildMvpSymbols(true, true)
  end
end

function BWMiniMapContentPage:EnLargeBigMap(b, notCenterMyPos)
  if self.window.lock then
    return
  end
  if b then
    self.bigmapLarge = true
    self.window:SetMapScale(self.mapScale)
    if notCenterMyPos == nil or notCenterMyPos == false then
      self.window:CenterOnMyPos(true)
    end
    self.window:EnableDrag(true)
    self.enlargeSprite.spriteName = "com_icon_narrow2"
    self.window:ActiveSymbolsByType(BWMiniMapWindow.Type.Npc, true)
    self.window:ActiveSymbolsByType(BWMiniMapWindow.Type.Monster, true)
    self.window:ActiveSymbolsByType(BWMiniMapWindow.Type.QuestNpc, true)
    self.window:ActiveSymbolsByType(BWMiniMapWindow.Type.AreaTips, false)
    self.window:ActiveSymbolsByType(BWMiniMapWindow.Type.ZoneTips, true)
    self.window:ActiveSymbolsByType(BWMiniMapWindow.Type.ServerNpc, true)
    self.window:ActiveSymbolsByType(BWMiniMapWindow.Type.ScenicSpot, true)
    self.window:ActiveSymbolsByType(BWMiniMapWindow.Type.Yahaha, true)
    self.window:ActiveSymbolsByType(BWMiniMapWindow.Type.FakeDragon, true)
    self.window:ActiveFocusArrowUpdate(true)
    self.window:ForceUpdateFocusArrowPos()
  else
    self.bigmapLarge = false
    self.window:SetMapScale(1)
    self.window:ResetMapPos()
    self.window:EnableDrag(false)
    self.enlargeSprite.spriteName = "com_icon_enlarge2"
    self.window:ActiveSymbolsByType(BWMiniMapWindow.Type.Npc, false)
    self.window:ActiveSymbolsByType(BWMiniMapWindow.Type.Monster, false)
    self.window:ActiveSymbolsByType(BWMiniMapWindow.Type.QuestNpc, false)
    self.window:ActiveSymbolsByType(BWMiniMapWindow.Type.AreaTips, true)
    self.window:ActiveSymbolsByType(BWMiniMapWindow.Type.ZoneTips, false)
    self.window:ActiveSymbolsByType(BWMiniMapWindow.Type.ServerNpc, false)
    self.window:ActiveSymbolsByType(BWMiniMapWindow.Type.ScenicSpot, false)
    self.window:ActiveSymbolsByType(BWMiniMapWindow.Type.Yahaha, false)
    self.window:ActiveFocusArrowUpdate(true)
    self.window:ForceUpdateFocusArrowPos()
    self.window:ActiveFocusArrowUpdate(false)
  end
end

function BWMiniMapContentPage:TryUseFlyWing(info)
  local item = BagProxy.Instance:GetItemByStaticID(info.itemID, BagProxy.BagType.MainBag)
  if nil == item then
    item = BagProxy.Instance:GetItemByStaticID(info.itemID, BagProxy.BagType.Temp)
  end
  if nil ~= item then
    local dont = LocalSaveProxy.Instance:GetDontShowAgain(info.msgID)
    if nil == dont then
      MsgManager.DontAgainConfirmMsgByID(info.msgID, function()
        FunctionItemFunc.TryUseItem(item)
      end)
    else
      local raidReward = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_HAS_USERRETURN_RAID_AWARD) or 0
      if 0 < raidReward then
        MsgManager.ConfirmMsgByID(42085, function()
          FunctionItemFunc.TryUseItem(item)
        end, nil)
      else
        FunctionItemFunc.TryUseItem(item)
      end
    end
  else
    item = Table_Item[info.itemID]
    if nil ~= item then
      MsgManager.ShowMsgByID(info.msgDoNotHaveID, item.NameZh)
    else
      redlog("Cannot Find Item Data: " .. info.itemID)
    end
  end
  self:RefreshFlyWingStatus(info)
end

function BWMiniMapContentPage:UpdateFlyWingsStatus(note)
  local recordMap = note.body
  if recordMap then
    local info = self.UseFlyButtonInfo
    for id, _ in pairs(recordMap) do
      local item = BagProxy.Instance:GetItemByGuid(id)
      if item and item.staticData and item.staticData.id == info.itemID then
        self:RefreshFlyWingStatus(info)
        break
      end
    end
  end
end

function BWMiniMapContentPage:RefreshFlyWingStatus(info)
  local item = BagProxy.Instance:GetItemByStaticID(info.itemID, BagProxy.BagType.MainBag)
  item = item and BagProxy.Instance:GetItemByStaticID(info.itemID, BagProxy.BagType.Temp)
  if item then
    self:SetTextureGrey(info.base)
    self:SetTextureGrey(info.icon)
  else
    self:SetTextureWhite(info.base)
    self:SetTextureWhite(info.icon)
  end
end

function BWMiniMapContentPage:InitEvents()
  self:AddListenEvt(ServiceEvent.QuestQuestList, self.UpdateQuestMapSymbol)
  self:AddListenEvt(ServiceEvent.QuestQuestUpdate, self.UpdateQuestMapSymbol)
  self:AddListenEvt(ServiceEvent.QuestQuestStepUpdate, self.UpdateQuestMapSymbol)
  self:AddListenEvt(MainViewEvent.AddQuestFocus, self.HandleAddQuestFocus)
  self:AddListenEvt(MainViewEvent.RemoveQuestFocus, self.HandleRemoveQuestFocus)
  self:AddListenEvt(MiniMapEvent.ShowMiniMapDirEffect, self.HandlePlayQuestDirEffect)
  self:AddListenEvt(MiniMapEvent.AddCircleArea, self.HandleAddCircleArea)
  self:AddListenEvt(MiniMapEvent.RemoveCircleArea, self.HandleRemoveCircleArea)
  self:AddListenEvt(ServiceEvent.NUserNtfVisibleNpcUserCmd, self.UpdateShowNpcPos)
  self:AddListenEvt(ServiceEvent.SceneSealUpdateSeal, self.UpdateMapSealPoint)
  self:AddListenEvt(ServiceEvent.SceneSealQuerySeal, self.UpdateMapSealPoint)
  self:AddListenEvt(ServiceEvent.SessionTeamMemberPosUpdate, self.HandleTeamMemberPosUpdate)
  self:AddListenEvt(TeamEvent.MemberChangeMap, self.HandleTeamMemberPosUpdate)
  self:AddListenEvt(TeamEvent.MemberOffline, self.HandleTeamMemberPosUpdate)
  self:AddListenEvt(TeamEvent.MemberExitTeam, self.HandleTeamMemberPosUpdate)
  self:AddListenEvt(TeamEvent.ExitTeam, self.ClearTeamMemberPos)
  self:AddListenEvt(MiniMapEvent.CreatureScenicChange, self.HandleCreatureScenicChange)
  self:AddListenEvt(MiniMapEvent.CreatureScenicAdd, self.HandleCreatureScenicAdd)
  self:AddListenEvt(MiniMapEvent.CreatureScenicRemove, self.HandleCreatureScenicRemove)
  self:AddListenEvt(FunctionScenicSpot.Event.StateChanged, self.RefreshScenicSpots)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateFlyWingsStatus)
  self:AddListenEvt(MyselfEvent.TargetPositionChange, self.HandleUpdateDestPos)
  self:AddListenEvt(MyselfEvent.ZoneIdChange, self.UpdateCurrentLine)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.UpdateMapChangeEvents)
  self:AddListenEvt(ServiceEvent.SceneGoToUserCmd, self.UpdateLoading)
  self:AddListenEvt(LoadSceneEvent.BWTransmitFinished, self.UpdateTransmitFinished)
  self:AddDispatcherEvt(WildMvpEvent.OnMiniMapMonsterUpdated, self.UpdateWildMvpMonsters)
  self:AddListenEvt(ServiceEvent.MessCCmdSyncMapStepForeverRewardInfo, self.UpdateZoneTipsProgress)
  self:AddListenEvt(FakeDragonEvent.UpdateFakeDragonPoses, self.UpdateFakeDragonSymbol)
end

function BWMiniMapContentPage:HandleUpdateDestPos(note)
  self.window:UpdateDestPos(note.body)
end

function BWMiniMapContentPage:ResetWindow()
  local map2d = Game.Map2DManager:GetMap2D()
  if map2d then
    if self.window.map2D ~= map2d then
      self.window:Reset()
      if self.mapData.MapScale then
        local defaultSize = 530
        self.window:UpdateMapTexture(self.mapData, LuaGeometry.GetTempVector3(defaultSize, defaultSize), map2d, true)
        self.mapScale = 3.75
      else
        local DefaultWindowSize = LuaGeometry.GetTempVector3(MiniMapWindow.DefaultMapTextureSize, MiniMapWindow.DefaultMapTextureSize)
        self.window:UpdateMapTexture(self.mapData, DefaultWindowSize, map2d, true)
      end
      self.bigmapLarge = false
      self.window:EnableDrag(false)
      self.window:ActiveSymbolsByType(BWMiniMapWindow.Type.Npc, false)
      self.window:ActiveSymbolsByType(BWMiniMapWindow.Type.QuestNpc, false)
    end
    self.window:SetMapScale(self.windowScale)
    self:UpdateQuestMapSymbol()
    self:UpdateMapSealPoint()
    self:RefreshScenicSpots()
    self:UpdateTeamMembersPos()
    self:UpdateNearlyMonsters()
    self:UpdateNearlyTreasures()
    self:UpdateShowNpcPos()
    self:UpdateShowingCircleAreaMap()
    self:RefreshYahahaSymbol()
    self:UpdateFakeDragonSymbol()
    self.window:UpdateQuestFocuses(self.focusMap)
    self:UpdateTransmitter()
    self:UpdateBigMapButton()
    self.window:UpdateServerNpcPointMap(self.showNpcs, true)
    self.window:Show()
  else
    self.window:Reset()
    self.window:Hide()
  end
end

function BWMiniMapContentPage:UpdateZoneEvents()
  if not self.zoneEventMapDatas then
    self.zoneEventMapDatas = {}
  else
    _TableClearByDeleter(self.zoneEventMapDatas, miniMapDataDeleteFunc)
  end
end

function BWMiniMapContentPage:GetMapNpcPointByNpcId(npcid)
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

function BWMiniMapContentPage:UpdateQuestMapSymbol()
  local inRaid = MapManager:IsRaidMode()
  if not inRaid then
    local imgId = ServicePlayerProxy.Instance:GetCurMapImageId()
    inRaid = imgId ~= nil and imgId ~= 0
  end
  local questlst
  if inRaid then
    questlst = QuestProxy.Instance:getCurRaidQuest()
  else
    questlst = inRaid and not MapManager:IsInGuildMap() and {} or QuestProxy.Instance:getQuestListByMapAndSymbol(self.nowMapID)
  end
  _TableClearByDeleter(self.questShowDatas, miniMapDataDeleteFunc)
  for _, q in pairs(questlst) do
    local params = q.staticData and q.staticData.Params
    if params.ShowSymbol ~= 2 and params.ShowSymbol ~= 3 then
      local symbolType = QuestSymbolCheck.GetQuestSymbolByQuest(q)
      if symbolType then
        local combineId, npcPoint
        local uniqueid, npcid = params.uniqueid, params.npc
        npcid = type(npcid) == "table" and npcid[1] or npcid
        if uniqueid then
          npcPoint = MapManager:FindNPCPoint(uniqueid)
        elseif npcid then
          npcPoint = self:GetMapNpcPointByNpcId(npcid)
          uniqueid = npcPoint and npcPoint.uniqueID or 0
        else
          combineId = q.questDataStepType .. q.id
        end
        combineId = combineId or QuestDataStepType.QuestDataStepType_VISIT .. tostring(npcid) .. tostring(uniqueid)
        local miniMapData = self.questShowDatas[combineId]
        if not miniMapData then
          local pos = params.pos
          if not pos and npcPoint then
            pos = npcPoint.position
          end
          if pos then
            miniMapData = self.questShowDatas[combineId]
            if miniMapData == nil then
              miniMapData = MiniMapData.CreateAsTable(combineId)
            end
            miniMapData:SetPos(pos[1], pos[2], pos[3])
            miniMapData:SetParama("questId", q.id)
            miniMapData:SetParama("npcid", npcid)
            miniMapData:SetParama("uniqueid", uniqueid)
            miniMapData:SetParama("SymbolType", symbolType)
            miniMapData:SetParama("combineId", combineId)
            self.questShowDatas[combineId] = miniMapData
          end
        else
          local cacheSymbolType = miniMapData:GetParama("SymbolType")
          if symbolType < cacheSymbolType then
            miniMapData:SetParama("SymbolType", symbolType)
          end
        end
      end
    end
  end
  local npcList = MapManager:GetNPCPointArray()
  if npcList then
    for i = 1, #npcList do
      local npcPoint = npcList[i]
      local npcid, uniqueid = npcPoint.ID, npcPoint.uniqueID
      local combineId = QuestDataStepType.QuestDataStepType_VISIT .. npcPoint.ID .. npcPoint.uniqueID
      local miniMapData = self.questShowDatas[combineId]
      if not miniMapData then
        local npcSData = Table_Npc[npcid]
        if QuestSymbolCheck.HasDailySymbol(npcSData) then
          miniMapData = self.questShowDatas[combineId]
          if not miniMapData then
            miniMapData = MiniMapData.CreateAsTable(combineId)
            self.questShowDatas[combineId] = miniMapData
          end
          miniMapData:SetPos(npcPoint.position[1], npcPoint.position[2], npcPoint.position[3])
          miniMapData:SetParama("npcid", npcid)
          miniMapData:SetParama("uniqueid", uniqueid)
          miniMapData:SetParama("SymbolType", QuestSymbolType.Daily)
        end
      end
    end
  end
  self.window:UpdateQuestNpcSymbol(self.questShowDatas, true)
  self:UpdateZoneTipsProgress()
end

function BWMiniMapContentPage:UpdateZoneTipsProgress()
  self.window:UpdateZoneTipsProgress()
end

function BWMiniMapContentPage:UpdateMapSealPoint()
  local nowMapId = self.nowMapID
  local data = SealProxy.Instance:GetSealData(nowMapId)
  if data then
    if not self.sealDatasMap then
      self.sealDatasMap = {}
    else
      _TableClearByDeleter(self.sealDatasMap, miniMapDataDeleteFunc)
    end
    for k, v in pairs(data.itemMap) do
      local symbol = v.issealing and "map_whirlpool2" or "map_whirlpool"
      local sealMapData = self.sealDatasMap[k]
      if sealMapData == nil then
        sealMapData = MiniMapData.CreateAsTable(k)
        self.sealDatasMap[k] = sealMapData
      end
      sealMapData:SetPos(v.pos[1], v.pos[2], v.pos[3])
      sealMapData:SetParama("Symbol", symbol)
    end
    self.window:UpdateSealSymbol(self.sealDatasMap, true)
  end
end

local circleColorMap = {
  [1] = "new_main_bg_task",
  [2] = "new_main_bg_task_02"
}

function BWMiniMapContentPage:UpdateShowingCircleAreaMap()
  if not self.circleAreaMap then
    self.circleAreaMap = {}
  else
    TableUtility.TableClearByDeleter(self.circleAreaMap, miniMapDataDeleteFunc)
  end
  local circleMap = Game.QuestMiniMapEffectManager:GetShowingCircleAreaMap()
  if circleMap then
    for id, array in pairs(circleMap) do
      local questId, pos, radius, color = array[1], array[2], array[3], array[4]
      local data = self.circleAreaMap[questId]
      if not data then
        data = MiniMapData.CreateAsTable(questId)
        data:SetParama("questId", questId)
        data:SetParama("areaSymbol", circleColorMap[color])
        data:SetParama("areaSymbolDepth", 100)
        self.circleAreaMap[questId] = data
      end
      data:SetPos(pos[1], pos[2], pos[3])
      data:SetParama("radius", radius)
    end
  end
  self.window:UpdateMapCircleAreas(self.circleAreaMap, true)
end

function BWMiniMapContentPage:UpdateShowNpcPos()
  local showNpcMap = NSceneNpcProxy.Instance:GetVisibleNpcMap() or {}
  if not self.showNpcs then
    self.showNpcs = {}
  end
  for id, npc in pairs(showNpcMap) do
    local mapData = self.showNpcs[npc.uniqueid]
    local sData = Table_Npc[npc.npcid]
    if not sData then
      if mapData then
        mapData:Destroy()
        self.showNpcs[npc.uniqueid] = nil
      end
    else
      if not mapData then
        mapData = MiniMapData.CreateAsTable(npc.uniqueid)
        self.showNpcs[npc.uniqueid] = mapData
      end
      mapData:SetPos(npc.pos[1], npc.pos[2], npc.pos[3])
      mapData:SetParama("Symbol", sData.MapIcon)
      mapData:SetParama("Symbol_Disabled", sData.MapIconDisabled)
      mapData:SetParama("active_time", npc.active_time)
      mapData:SetParama("total_time", npc.total_need_time)
      mapData.symbolSize = 22
    end
  end
  for id, mapData in pairs(self.showNpcs) do
    if not showNpcMap[mapData.id] then
      mapData:Destroy()
      self.showNpcs[id] = nil
    end
  end
  self.window:UpdateServerNpcPointMap(self.showNpcs, true)
end

function BWMiniMapContentPage:_UpdateSceneSpot(scenicSpot, forceUpdate)
  if not AdventureDataProxy.Instance:IsSceneryHasTakePic(scenicSpot.ID) then
    local spotConfig = Table_Viewspot[scenicSpot.ID]
    if spotConfig and (spotConfig.Type == 1 or spotConfig.Type == 3) then
      local p = scenicSpot.position
      if p then
        local guid = scenicSpot.ID
        if scenicSpot.guid then
          guid = scenicSpot.ID .. "_" .. scenicSpot.guid
        end
        local spotData = self.spotDatas[guid]
        if not spotData then
          spotData = MiniMapData.CreateAsTable(guid)
          self.spotDatas[guid] = spotData
        end
        spotData:SetPos(p[1], p[2], p[3])
        spotData:SetParama("Symbol", "map_Lookout_lock")
      end
    end
  end
end

function BWMiniMapContentPage:_RemoveSceneSpot(scenicSpot)
  local ID, guid = scenicSpot.ID, scenicSpot.guid
  guid = guid and ID .. "_" .. guid
  local spotData = self.spotDatas[guid]
  if spotData ~= nil then
    spotData:Destroy()
  end
  self.spotDatas[guid] = nil
end

function BWMiniMapContentPage:UpdateSceneSpots(validScenicSpots)
  if self.spotDatas then
    _TableClearByDeleter(self.spotDatas, miniMapDataDeleteFunc)
  else
    self.spotDatas = {}
  end
  for k, v in pairs(validScenicSpots) do
    if v.ID then
      self:_UpdateSceneSpot(v)
    else
      for i = 1, #v do
        if v[i].ID then
          self:_UpdateSceneSpot(v[i])
        end
      end
    end
  end
  self.window:UpdateScenicSpotSymbol(self.spotDatas)
end

function BWMiniMapContentPage:RefreshScenicSpots()
  self:UpdateSceneSpots(FunctionScenicSpot.Me():GetAllScenicSpot())
end

function BWMiniMapContentPage:HandleCreatureScenicChange(note)
  local spotDatas = note.body
  if spotDatas then
    for i = 1, #spotDatas do
      self:_UpdateSceneSpot(spotDatas[i])
    end
    self.window:UpdateScenicSpotSymbol(self.spotDatas)
  end
end

function BWMiniMapContentPage:HandleCreatureScenicAdd(note)
  local sceneSpots = note.body
  for i = 1, #sceneSpots do
    self:_UpdateSceneSpot(sceneSpots[i])
  end
  self.window:UpdateScenicSpotSymbol(self.spotDatas)
end

function BWMiniMapContentPage:HandleCreatureScenicRemove(note)
  self:_RemoveSceneSpot(note.body)
  self.window:UpdateScenicSpotSymbol(self.spotDatas)
end

function BWMiniMapContentPage:RefreshYahahaSymbol()
  self:UpdateYahahaSymbol()
end

function BWMiniMapContentPage:_UpdateYahahaDatas()
  if self.yahahaDatas then
    _TableClearByDeleter(self.yahahaDatas, miniMapDataDeleteFunc)
  else
    self.yahahaDatas = {}
  end
  local curMapId = MapManager:GetMapID()
  local yahahaStaticConfigs = Table_YahahaQuest
  for k, v in pairs(yahahaStaticConfigs) do
    local data = self.yahahaDatas[k]
    local mapValid = v.MapID == curMapId
    local show = FunctionUnLockFunc.Me():CheckCanOpen(v.QuestMenu) and mapValid
    local fin = FunctionUnLockFunc.Me():CheckCanOpen(v.Menu)
    if show then
      if not data then
        data = MiniMapData.CreateAsTable(k)
        self.yahahaDatas[k] = data
        data:SetParama("Depth", 36)
      end
      local p = v.Pos
      data:SetPos(p[1], p[2], p[3])
      if fin then
        data:SetParama("Symbol", "map_icon_Emoelf2")
      else
        data:SetParama("Symbol", "map_icon_Emoelf1")
      end
    else
      if data ~= nil then
        data:Destroy()
      end
      self.yahahaDatas[k] = nil
    end
  end
end

function BWMiniMapContentPage:UpdateYahahaSymbol()
  self:_UpdateYahahaDatas()
  self.window:UpdateYahahaSymbol(self.yahahaDatas, true)
end

function BWMiniMapContentPage:_GetScenePlayerSymbolName(player, includeMyself)
  if player == Game.Myself and not includeMyself then
    return
  end
  local myPvpColor = MyselfProxy.Instance:GetPvpColor()
  local isOb = _PvpObProxy:IsRunning()
  local playerid = player.data.id
  local playerSymbolName
  if player.data:GetCamp() == RoleDefines_Camp.ENEMY then
    playerSymbolName = "map_dot"
  end
  if playerSymbolName == nil and not self.teamMemberMapDatas[playerid] and _TeamProxy:IsInMyTeam(playerid) then
    playerSymbolName = "map_teammate"
  end
  local hideValue = player.data.props:GetPropByName("Hiding"):GetValue()
  if 0 < hideValue then
    playerSymbolName = nil
  end
  return playerSymbolName
end

function BWMiniMapContentPage:_UpdatePlayerSymbolData(player)
  if not player then
    return
  end
  local playerid = player.data.id
  local playerSymbolName = self:_GetScenePlayerSymbolName(player)
  local miniMapData = self.playerMap[playerid]
  if playerSymbolName then
    if not miniMapData then
      miniMapData = MiniMapData.CreateAsTable(playerid)
      self.playerMap[playerid] = miniMapData
    end
    local pos = player:GetPosition()
    if pos then
      miniMapData:SetPos(pos[1], pos[2], pos[3])
    end
    miniMapData:SetParama("Symbol", playerSymbolName)
    miniMapData:SetParama("depth", 4)
  elseif miniMapData then
    miniMapData:Destroy()
    self.playerMap[playerid] = nil
  end
end

function BWMiniMapContentPage:HandleTeamMemberPosUpdate(note)
  self:UpdateTeamMemberPos(note.body.id)
end

function BWMiniMapContentPage:RemoveTeamMemberPos(id)
  if not id then
    return
  end
  local miniMapData = self.teamMemberMapDatas[id]
  if miniMapData then
    miniMapData:Destroy()
  end
  self.teamMemberMapDatas[id] = nil
  self.window:RemoveTeamMemberSymbol(id)
end

function BWMiniMapContentPage:ClearTeamMemberPos()
  for id, _ in pairs(self.teamMemberMapDatas) do
    self:RemoveTeamMemberPos(id)
  end
end

function BWMiniMapContentPage:UpdateTeamMateSymbol(id, miniMapData)
  if not _TeamProxy:IHaveTeam() then
    return
  end
  local myTeam = _TeamProxy.myTeam
  local memData = myTeam:GetMemberByGuid(id)
  if not memData then
    return
  end
  local symbolName
  if memData.dead then
    symbolName = "map_teamdied"
  else
    symbolName = "map_teammate"
  end
  miniMapData:SetParama("Symbol", symbolName)
end

function BWMiniMapContentPage:UpdateTeamMemberPos(id)
  local myGuid = Game.Myself.data.id
  if not id or Game.Myself and id == myGuid then
    return
  end
  if not _TeamProxy:IHaveTeam() then
    return
  end
  local nowMapid = self.nowMapID
  local nowSceneid = MapManager:GetSceneID()
  local myTeam = _TeamProxy.myTeam
  local mymData = myTeam:GetMemberByGuid(myGuid)
  local memData = myTeam:GetMemberByGuid(id)
  if not (memData and (memData.mapid == nowMapid or memData.raid == nowMapid) and memData.offline ~= 1 and (memData:IsSameline() or memData:IsInCommonlineMap())) or mymData and nowSceneid ~= memData.sceneid then
    self:RemoveTeamMemberPos(id)
    return
  end
  local miniMapData = self.teamMemberMapDatas[id]
  if not miniMapData then
    miniMapData = MiniMapData.CreateAsTable(id)
    miniMapData:SetParama("Symbol", "map_teammate")
    self.teamMemberMapDatas[id] = miniMapData
  end
  local pos = memData.pos
  miniMapData:SetPos(pos[1], pos[2], pos[3])
  self:UpdateTeamMateSymbol(id, miniMapData)
  self.window:UpdateTeamMemberSymbol(self.teamMemberMapDatas, true)
end

function BWMiniMapContentPage:UpdateTeamMembersPos()
  if _TeamProxy:IHaveTeam() then
    local myTeam = _TeamProxy.myTeam
    local memberMap = myTeam:GetMemberMap()
    for id, member in pairs(memberMap) do
      self:UpdateTeamMemberPos(member.id)
    end
    for id, data in pairs(self.teamMemberMapDatas) do
      if not myTeam:GetMemberByGuid(id) then
        self:RemoveTeamMemberPos(id)
      end
    end
  else
    self:ClearTeamMemberPos()
  end
end

function BWMiniMapContentPage:ActiveCheckMonstersPoses(open)
  if open then
    TimeTickManager.Me():CreateTick(0, 1000, self.UpdateNearlyMonsters, self, 1)
  else
    TimeTickManager.Me():ClearTick(self, 1)
  end
end

function BWMiniMapContentPage:UpdateNearlyMonsters()
  self.monsterDataMap, self.tempMap = self.tempMap, self.monsterDataMap
  if not self.monsterDataMap then
    self.monsterDataMap = {}
  end
  if not self.bossDataMap then
    self.bossDataMap = {}
  end
  local monsterList = FunctionMonster.Me():FilterMonster()
  local rolelv = MyselfProxy.Instance:RoleLevel()
  local curImageId = ServicePlayerProxy.Instance:GetCurMapImageId() or 0
  local isRaid = MapManager:IsRaidMode() or 0 < curImageId
  local isInGVGDetailedRaid = MapManager:IsInGVGDetailedRaid()
  local _roleDefunes_Camp = RoleDefines_Camp
  local recordMap = {}
  for i = 1, #monsterList do
    local monster = monsterList[i]
    if monster.data.userdata:Get(UDEnum.OPTION) ~= 1 then
      recordMap[monster.data.id] = 1
      local staticMonsterId = monster.data.staticData and monster.data.staticData.id or 0
      local mMapData = self.monsterDataMap[monster.data.id] or self.bossDataMap[monster.data.id]
      if not mMapData then
        local isBoss = true
        local symbolName, depth
        local sData = monster.data.staticData
        if monster:GetBossType() == 3 then
          symbolName = "ui_mvp_dead11_JM"
          depth = 2
        elseif sData.Type == "MVP" then
          if staticMonsterId == 276614 then
            symbolName = "map_icon_shikonglong"
          else
            symbolName = "map_mvpboss"
          end
          depth = 3
        elseif sData.Type == "MINI" then
          symbolName = "map_miniboss"
          depth = 2
        elseif sData.Type == "RareElite" then
          symbolName = "map_jingying"
          depth = 2
        elseif sData.Type == "WorldBoss" then
          symbolName = "map_worldboss"
          depth = 2
        elseif sData.Type == "StormBoss" then
          symbolName = "main_icon_StormBoss"
          depth = 2
        elseif _roleDefunes_Camp.FRIEND == monster.data:GetCamp() then
          symbolName = "map_green"
          depth = 1
        else
          isBoss = false
          if sData.MmapHide ~= 1 then
            if isRaid then
              if not isInGVGDetailedRaid or isInGVGDetailedRaid and staticMonsterId ~= GvgProxy.MetalID then
                symbolName = "map_dot"
              end
            elseif Game.Myself:IsAtNightmareMap() and monster.data:IsNightmareMonster() and not monster.data:IsNightmareStatus() then
              symbolName = "map_green"
            else
              local search = monster.data.search or 0
              local searchrange = monster.data.searchrange or 0
              if 0 < search or 0 < searchrange then
                local mdata = monster.data.staticData
                if mdata.PassiveLv and rolelv >= mdata.PassiveLv then
                  symbolName = "map_dot"
                else
                  symbolName = "map_green"
                end
              else
                symbolName = "map_green"
              end
            end
            depth = 1
          end
        end
        mMapData = MiniMapData.CreateAsTable(monster.data.id)
        if isBoss then
          self.bossDataMap[monster.data.id] = mMapData
        else
          self.monsterDataMap[monster.data.id] = mMapData
        end
        mMapData:SetParama("Symbol", symbolName)
        mMapData:SetParama("depth", depth)
      end
      local pos = monster:GetPosition()
      mMapData:SetPos(pos[1], pos[2], pos[3])
    end
  end
  for id, mapData in pairs(self.monsterDataMap) do
    if not recordMap[id] then
      mapData:Destroy()
      self.monsterDataMap[id] = nil
    end
  end
  for id, bossData in pairs(self.bossDataMap) do
    if not recordMap[id] then
      bossData:Destroy()
      self.bossDataMap[id] = nil
    end
  end
  self.window:UpdateMonstersPoses(self.monsterDataMap, true)
  self.window:UpdateMvpPoses(self.bossDataMap, true)
  local data = self.fakeDragonDatas and self.fakeDragonDatas[1]
  local uniqueID, fakeDragonPos = AbyssFakeDragonProxy.Instance:GetFakeDragonPosition()
  if data and uniqueID then
    data:SetPos(fakeDragonPos[1], fakeDragonPos[2], fakeDragonPos[3])
  elseif uniqueID then
    local data = MiniMapData.CreateAsTable(uniqueID)
    data:SetParama("Symbol", "map_icon_shikonglong")
    data:SetPos(fakeDragonPos[1], fakeDragonPos[2], fakeDragonPos[3])
    if not self.fakeDragonDatas then
      self.fakeDragonDatas = {}
    end
    self.fakeDragonDatas[1] = data
  end
  self.window:UpdateFakeDragonPoses(self.fakeDragonDatas, true)
end

function BWMiniMapContentPage:ClearMonsterDatas()
  if self.monsterDataMap then
    _TableClearByDeleter(self.monsterDataMap, miniMapDataDeleteFunc)
  end
  if self.bossDataMap then
    _TableClearByDeleter(self.bossDataMap, miniMapDataDeleteFunc)
  end
end

function BWMiniMapContentPage:UpdateNearlyTreasures()
  _TableClearByDeleter(self.fixedTreasureMap, miniMapDataDeleteFunc)
  local treasure = _NSceneNpcProxy:FindNearNpcs(Game.Myself:GetPosition(), 10, function(npc)
    for i = 1, #GameConfig.Quest.TreasureNpcID do
      local singleId = GameConfig.Quest.TreasureNpcID[i]
      if singleId == npc.data.staticData.id then
        return true
      end
    end
  end)
  if treasure and 0 < #treasure then
    local single = treasure[1]
    local pos = single:GetPosition()
    if pos then
      local treasureData = MiniMapData.CreateAsTable(single.data.id)
      treasureData:SetPos(pos[1], pos[2], pos[3])
      treasureData:SetParama("Symbol", "main_icon_Treasure-chest")
      treasureData:SetParama("depth", 3)
      self.fixedTreasureMap[treasureData.id] = treasureData
    end
    if self.minimapTreasureInfo[single.data.id] then
      QuestProxy.Instance:RemoveSingleWorldQuestTreause(single.data.id)
      self:UpdateWorldQuestTreasure()
    end
  end
  self.window:UpdateFixedTreasurePoses(self.fixedTreasureMap, true)
end

function BWMiniMapContentPage:SetWorldQuestTreasureTimer(note)
  if note and note.body.type == SceneQuest_pb.EOTHERDATA_WORLDTREASURE then
    self:UpdateWorldQuestTreasure()
    self.treasureTimeTick = TimeTickManager.Me():CreateTick(0, 1000, self.updateTreasureShow, self, 18)
    self.treasureTickClickTime = UnityUnscaledTime
  end
end

function BWMiniMapContentPage:updateTreasureShow(deltaTime)
  if UnityUnscaledTime - self.treasureTickClickTime > 300 then
    TimeTickManager.Me():ClearTick(self, 18)
    self:RemoveTreasureShow()
    self.treasureTimeTick = nil
  end
end

function BWMiniMapContentPage:RemoveTreasureShow()
  _TableClearByDeleter(self.minimapTreasureInfo, miniMapDataDeleteFunc)
  self.window:UpdateWorldQuestTreasure(self.minimapTreasureInfo, true)
  QuestProxy.Instance:RemoveWorldQuestTreasure()
end

function BWMiniMapContentPage:UpdateWorldQuestTreasure()
  local treasures = QuestProxy.Instance:GetWorldQuestTreasure()
  if treasures and 0 < #treasures then
    _TableClearByDeleter(self.minimapTreasureInfo, miniMapDataDeleteFunc)
    for i = 1, #treasures do
      local q = treasures[i]
      local combineId = q.npcid
      local pos = q.pos
      if pos then
        local treasureData = self.minimapTreasureInfo[combineId]
        treasureData = treasureData or MiniMapData.CreateAsTable(combineId)
        treasureData:SetPos(pos[1], pos[2], pos[3])
        treasureData:SetParama("npcid", q.npcid)
        treasureData:SetParama("Symbol", "main_icon_Treasure-chest")
        treasureData:SetParama("depth", 3)
        self.minimapTreasureInfo[combineId] = treasureData
      end
    end
    self.window:UpdateWorldQuestTreasure(self.minimapTreasureInfo, true)
  else
    _TableClearByDeleter(self.minimapTreasureInfo, miniMapDataDeleteFunc)
    self.window:UpdateWorldQuestTreasure(self.minimapTreasureInfo, true)
  end
end

function BWMiniMapContentPage:IsCurMapHasTransmitter()
  for mapID, status in pairs(WorldMapProxy.Instance.availableTransmitterMap) do
    if mapID == self.nowMapID or mapID == MapManager:GetRaidID() then
      return true
    end
  end
  return false
end

function BWMiniMapContentPage:UpdateTransmitter()
  if self:IsCurMapHasTransmitter() then
    self.window:UpdateTransmitterPoints(self.bigmapLarge or false)
  else
    self.window:RemoveTransmitterPoints()
  end
end

function BWMiniMapContentPage:HandleUpdateTransmitter()
  self.window:RemoveTransmitterPoints()
  self:UpdateTransmitter()
end

function BWMiniMapContentPage:HandleAddQuestFocus(note)
  if not self.focusMap then
    self.focusMap = {}
  end
  local questId, pos, hideSymbol = note.body[1], note.body[2], note.body[3]
  local focusData = self.focusMap[questId]
  if not focusData then
    focusData = MiniMapData.CreateAsTable(questId)
    focusData:SetParama("questId", questId)
    self.focusMap[questId] = focusData
  end
  focusData:SetPos(pos[1], pos[2], pos[3])
  focusData:SetParama("hideSymbol", hideSymbol)
  focusData:SetShowRange(-1)
  self.window:UpdateQuestFocuses(self.focusMap)
end

function BWMiniMapContentPage:HandleRemoveQuestFocus(note)
  local questId = note.body
  if questId and self.focusMap then
    local focusData = self.focusMap[questId]
    if focusData then
      focusData:Destroy()
    end
    self.focusMap[questId] = nil
    self.window:UpdateQuestFocuses(self.focusMap)
  end
end

function BWMiniMapContentPage:HandlePlayQuestDirEffect(note)
  self.window:PlayFocusFrameEffect(note.body)
end

local circleColorMap = {
  [1] = "new_main_bg_task",
  [2] = "new_main_bg_task_02"
}

function BWMiniMapContentPage:HandleAddCircleArea(note)
  if not self.circleAreaMap then
    self.circleAreaMap = {}
  end
  local questId, pos, radius, color = note.body[1], note.body[2], note.body[3], note.body[4]
  local data = self.circleAreaMap[questId]
  if not data then
    data = MiniMapData.CreateAsTable(questId)
    data:SetParama("questId", questId)
    data:SetParama("areaSymbol", circleColorMap[color])
    data:SetParama("areaSymbolDepth", 100)
    self.circleAreaMap[questId] = data
  end
  data:SetPos(pos[1], pos[2], pos[3])
  data:SetParama("radius", radius)
  self.window:UpdateMapCircleAreas(self.circleAreaMap, true)
end

function BWMiniMapContentPage:HandleRemoveCircleArea(note)
  local questId = note.body
  if questId and self.circleAreaMap then
    local data = self.circleAreaMap[questId]
    if data then
      data:Destroy()
    end
    self.circleAreaMap[questId] = nil
    self.window:UpdateMapCircleAreas(self.circleAreaMap, true)
  end
end

function BWMiniMapContentPage:CreateLoading()
  local effect = self.loadingeffect
  if effect ~= nil then
    return
  end
  local map_id = Game.MapManager:GetMapID()
  local effect_path = map_id and GameConfig.BigMapUIEffect and GameConfig.BigMapUIEffect[map_id] or "ufx_map_transfer_prf"
  effect = self:PlayUIEffect(effect_path, self.trans)
  effect:SetActive(false)
  self.loadingeffect = effect
end

function BWMiniMapContentPage:StartLoading()
  local effect = self.loadingeffect
  if effect ~= nil then
    effect:SetActive(true)
    effect:ResetAction("state1001", 0)
  end
  self.loadingtime = UnityTime
  TimeTickManager.Me():ClearTick(self, 2)
  TimeTickManager.Me():CreateOnceDelayTick(30000, self.StopLoading, self, 2)
end

function BWMiniMapContentPage:StopLoading()
  if self.loadingtime == nil then
    return
  end
  TimeTickManager.Me():ClearTick(self, 2)
  self.loadingtime = nil
  local effect = self.loadingeffect
  if effect ~= nil then
    effect:ResetAction("state2001", 0)
  end
end

function BWMiniMapContentPage:UpdateLoading()
  BigWorld.BigWorldManager.Instance:Transmit(Game.Myself:GetPosition(), TransmitFinished)
end

function BWMiniMapContentPage:UpdateTransmitFinished()
  local time = self.loadingtime
  if time == nil then
    return
  end
  self:StopLoading()
end

function BWMiniMapContentPage:UpdateBigMapButton()
  self.bigMapLab.text = MapManager:IsRaidMode(true) and ZhString.MainViewMiniMap_ReturnHome or ZhString.MainViewMiniMap_WorldMap
end

function BWMiniMapContentPage:OnEnter()
  BWMiniMapContentPage.super.OnEnter(self)
  self:InitQuestFocus()
  self:ResetWindow()
  self:ActiveCheckMonstersPoses(true)
  self:EnLargeBigMap(true)
  if self.container.viewdata and self.container.viewdata.viewdata then
    local block_unlock = self.container.viewdata.viewdata.block_unlock
    if block_unlock then
      self.beforeCollider:SetActive(true)
      self.window:PlayZoneBlockAlphaTween(block_unlock)
      self.container.viewdata.viewdata.block_unlock = nil
    end
  end
  if self.container.viewdata and self.container.viewdata.viewdata then
    local hint_param = self.container.viewdata.viewdata.hint_param
    if hint_param then
      self.window:SetSymbolHintParam(hint_param)
      self.container.viewdata.viewdata.hint_param = nil
    end
  end
end

function BWMiniMapContentPage:OnExit()
  self.window:OnExit()
  BWMiniMapContentPage.super.OnExit(self)
  if self.showSpot ~= self.saveShowSpot then
    LocalSaveProxy.Instance:SetBWMiniMapContentPage_ShowSceneSpot(self.showSpot)
  end
  self:ActiveCheckMonstersPoses(false)
  if self.window then
    self.window:Hide()
  end
end

function BWMiniMapContentPage:InitQuestFocus()
  local currentQuestFocus = Game.QuestMiniMapEffectManager.questFocus
  if not currentQuestFocus then
    return
  end
  if not self.focusMap then
    self.focusMap = {}
  end
  local questId, pos, hideSymbol = currentQuestFocus[1], currentQuestFocus[2], currentQuestFocus[3]
  local focusData = self.focusMap[questId]
  if not focusData then
    focusData = MiniMapData.CreateAsTable(questId)
    focusData:SetParama("questId", questId)
    self.focusMap[questId] = focusData
  end
  focusData:SetPos(pos[1], pos[2], pos[3])
  focusData:SetParama("hideSymbol", hideSymbol)
  focusData:SetShowRange(-1)
end

function BWMiniMapContentPage:_UpdateFakeDragonDatas()
  if self.fakeDragonDatas then
    _TableClearByDeleter(self.fakeDragonDatas, miniMapDataDeleteFunc)
  else
    self.fakeDragonDatas = {}
  end
  local uniqueID, fakeDragonPos = AbyssFakeDragonProxy.Instance:GetFakeDragonPosition()
  local data = self.fakeDragonDatas[1]
  if fakeDragonPos then
    if not data then
      data = MiniMapData.CreateAsTable(uniqueID)
      self.fakeDragonDatas[1] = data
      data:SetParama("Depth", 32)
    end
    data:SetPos(fakeDragonPos[1], fakeDragonPos[2], fakeDragonPos[3])
    data:SetParama("Symbol", "map_icon_shikonglong")
  else
    if data ~= nil then
      data:Destroy()
    end
    self.fakeDragonDatas[1] = nil
  end
end

function BWMiniMapContentPage:UpdateFakeDragonSymbol()
  self:_UpdateFakeDragonDatas()
  redlog("UpdateFakeDragonSymbol", self.fakeDragonDatas)
  self.window:UpdateFakeDragonSymbol(self.fakeDragonDatas, true)
end
