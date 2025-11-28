WorldMapMenuPopUp = class("WorldMapMenuPopUp", BaseView)
WorldMapMenuPopUp.ViewType = UIViewType.PopUpLayer
autoImport("WorldMapCell")
autoImport("MapInfoCell")
autoImport("MonsterHeadCell")
autoImport("WorldMapMiniMapWindow")
autoImport("AdventureIndicatorCell")
local tempArray = {}
local miniMapDataDeleteFunc = function(data)
  data:Destroy()
end

function WorldMapMenuPopUp:Init()
  self:InitUI()
  self:AddListenEvts()
  self:InitData()
end

function WorldMapMenuPopUp:InitUI()
  self.title = self:FindComponent("Title", UILabel)
  local mapGrid = self:FindComponent("MapGrid", UIGrid)
  self.mapList = UIGridListCtrl.new(mapGrid, WorldMapCell, "WorldMapCell")
  self.mapList:AddEventListener(MouseEvent.MouseClick, self.ClickMapCell, self)
  local rightBord = self:FindGO("RightBord")
  self.menuScrollView = self:FindComponent("MenuScrollView", UIScrollView, rightBord)
  self.mapname = self:FindComponent("MapName", UILabel, rightBord)
  self.infoGrid = self:FindComponent("InfoGrid", UIGrid, rightBord)
  self.infoCtl = UIGridListCtrl.new(self.infoGrid, MapInfoCell, "MapInfoCell")
  self.infoCtl:AddEventListener(MouseEvent.MouseClick, self.clickMapInfo, self)
  self.monsterGrid = self:FindComponent("MonsterGrid", UIGrid, rightBord)
  self.monsterCtl = UIGridListCtrl.new(self.monsterGrid, MonsterHeadCell, "MonsterHeadCell")
  self.monsterCtl:AddEventListener(MouseEvent.MouseClick, self.clickMonsterCell, self)
  self.noMonsterTip = self:FindGO("NoMonsterTip")
  local qsGO = self:FindGO("QuestGrid", rightBord)
  self.questSymbolGrid = qsGO:GetComponent(UIGrid)
  self.questSymbol1 = self:FindGO("Symbol1", qsGO)
  self.questSymbol2 = self:FindGO("Symbol2", qsGO)
  self.questSymbol3 = self:FindGO("Symbol3", qsGO)
  self.sealSymbol = self:FindComponent("SealSymbol", UISprite)
  self.questSymbol = self:FindGO("QuestSymbol")
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.goBtn = self:FindGO("GoBtn")
  self.goBtn_label = self:FindComponent("Label", UILabel, self.goBtn)
  self:AddClickEvent(self.goBtn, function(go)
    self:DoGoMap()
  end)
  local contentBord = self:FindGO("ContentBord")
  self.closeComp = contentBord:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closeComp.callBack(go)
    self:CloseSelf()
  end
  
  self.detailBtn = self:FindGO("DetailBtn")
  self.detailBtnLabel = self:FindComponent("DetailLabel", UILabel, self.detailBtn)
  self.detailBtnLine = self:FindGO("Line", self.detailBtn)
  self.questBtn = self:FindGO("QuestBtn")
  self.questBtnLabel = self:FindComponent("QuestLabel", UILabel, self.questBtn)
  self.questBtnLine = self:FindGO("Line", self.questBtn)
  self.detailRoot = self:FindGO("DetailRoot")
  self.questRoot = self:FindGO("QuestRoot")
  local miniMapWindowGO = self:FindGO("MapWindow")
  self.minimapWindow = WorldMapMiniMapWindow.new(miniMapWindowGO)
  self.minimapWindow:AddMapClick()
  self.grid = self:FindComponent("indicatorGrid", UIGrid)
  self.indicatorGrid = UIGridListCtrl.new(self.grid, AdventureIndicatorCell, "AdventureIndicatorCell")
  self.questTable = self:FindComponent("QuestTable", UITable)
  self.questScrollView = self:FindComponent("QuestScrollView", UIScrollView)
  self.Loading = self:FindGO("LoadingTip")
  self.NoneTip = self:FindGO("NoneTip")
  self.questType = {}
  self.listCtrl = WrapScrollViewHelper.new(MapBoardQuestCombineCell, ResourcePathHelper.UICell("MapBoardQuestCombineCell"), self.questScrollView.gameObject, self.questTable, 5)
  self.listCtrl:AddEventListener("ClickBigMapBoardQuestCell", self.ClickQuestCell, self)
  self.listCtrl:AddEventListener("RefreshMapBoardList", self.RefreshTable, self)
  self:AddListenEvt("WorldMapMiniMapWindow_ClickOutterDest", self.RecvCloseCmd)
  self.detailBtnLabel.text = ZhString.WorldMapMenuPopUp_Detail
  self.questBtnLabel.text = ZhString.WorldMapMenuPopUp_Quest
  self:AddClickEvent(self.detailBtn, function()
    self:ShowDetailRoot()
  end)
  self:AddClickEvent(self.questBtn, function()
    self:ShowQuestRoot()
  end)
  self:ShowDetailRoot()
  self.delta = 0
  local dragCollider = self:FindGO("dragCollider")
  self:AddDragEvent(dragCollider, function(obj, delta)
    if math.abs(delta.x) > 20 then
      self.delta = delta.x
    end
  end)
  UIEventListener.Get(dragCollider).onDragEnd = function(obj)
    if math.abs(self.delta) > 20 then
      self:hangDrag(self.delta)
    end
  end
end

function WorldMapMenuPopUp:hangDrag(delta)
  if delta < 0 then
    self:goRight()
  elseif 0 < delta then
    self:goLeft()
  end
end

function WorldMapMenuPopUp:goLeft()
  helplog("往←走判断参数" .. self.mapInfoNum, self.curShowIndex)
  if self.curShowIndex > 1 then
    self.curShowIndex = self.curShowIndex - 1
    self:SwitchMiniMap()
  end
end

function WorldMapMenuPopUp:goRight()
  helplog("往→走判断参数" .. self.mapInfoNum, self.curShowIndex)
  if self.curShowIndex < self.mapInfoNum then
    self.curShowIndex = self.curShowIndex + 1
    self:SwitchMiniMap()
  end
end

function WorldMapMenuPopUp:InitData()
  _NSceneNpcProxy = NSceneNpcProxy.Instance
  _TableClearByDeleter = TableUtility.TableClearByDeleter
  _TableClear = TableUtility.TableClear
  _SuperGvgProxy = SuperGvgProxy.Instance
  _TeamProxy = TeamProxy.Instance
  self.questShowDatas = {}
  self.sceneInfo = nil
  self.questList = {}
  self.map2Did = 0
end

function WorldMapMenuPopUp:DoGoMap()
  if self.chooseData == nil then
    return
  end
  if Game.Myself:IsDead() then
    MsgManager.ShowMsgByIDTable(2500)
    return
  end
  local activeMaps = WorldMapProxy.Instance.activeMaps
  local id = self.chooseData.id
  if activeMaps[id] and (self.isFromFurniture or Game.MapManager:IsEndlessBattleMap(id)) then
    ServiceNUserProxy.Instance:CallGoToGearUserCmd(id, SceneUser2_pb.EGoToGearType_Single, nil)
  else
    TableUtility.TableClear(tempArray)
    tempArray.targetMapID = id
    local cmd = MissionCommandFactory.CreateCommand(tempArray, MissionCommandMove)
    if cmd then
      Game.Myself:TryUseQuickRide()
      Game.Myself:Client_SetMissionCommand(cmd)
    end
  end
  self:sendNotification(WorldMapEvent.StartTrace)
  self:CloseSelf()
end

function WorldMapMenuPopUp:ClickMapCell(cell)
  self.curCell = cell
  self:UpdateChooseData(cell.data)
  cell:SetChoose(self.chooseSymbol)
  local cells = self.mapList:GetCells()
  for i = 1, #cells do
    if cells[i] == self.curCell then
      cells[i]:SetChooseLabel(true)
    else
      cells[i]:SetChooseLabel(false)
    end
  end
end

function WorldMapMenuPopUp:ShowDetailRoot()
  self.detailBtnLine.gameObject:SetActive(true)
  self.questBtnLine.gameObject:SetActive(false)
  self.detailBtnLabel.color = LuaGeometry.GetTempVector4(0.10980392156862745, 0.4117647058823529, 0.7176470588235294, 1)
  self.questBtnLabel.color = LuaGeometry.GetTempVector4(0.6901960784313725, 0.6901960784313725, 0.6901960784313725, 1)
  self.detailRoot.gameObject:SetActive(true)
  self.questRoot.gameObject:SetActive(false)
  self.infoGrid:Reposition()
  self.monsterGrid:Reposition()
end

function WorldMapMenuPopUp:ShowQuestRoot()
  self.detailBtnLine.gameObject:SetActive(false)
  self.questBtnLine.gameObject:SetActive(true)
  self.detailBtnLabel.color = LuaGeometry.GetTempVector4(0.6901960784313725, 0.6901960784313725, 0.6901960784313725, 1)
  self.questBtnLabel.color = LuaGeometry.GetTempVector4(0.10980392156862745, 0.4117647058823529, 0.7176470588235294, 1)
  self.detailRoot.gameObject:SetActive(false)
  self.questRoot.gameObject:SetActive(true)
  self:RefreshList()
end

function WorldMapMenuPopUp:clickMapInfo(mapInfo)
  local data = mapInfo.data
  if not data then
    return
  end
  local cmd
  if data.type == MapInfoType.Npc then
    local cmdArgs = {
      targetMapID = self.chooseData.id,
      npcID = data.id,
      npcUID = data.uid
    }
    cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandVisitNpc)
  elseif data.type == MapInfoType.ExitPoint then
    local cmdArgs = {
      targetMapID = data.id
    }
    cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandMove)
  end
  if cmd then
    Game.Myself:TryUseQuickRide()
    Game.Myself:Client_SetMissionCommand(cmd)
    self:sendNotification(WorldMapEvent.StartTrace)
    self:CloseSelf()
  end
end

function WorldMapMenuPopUp:clickMonsterCell(monsterCell)
  local data = monsterCell.data
  if data then
    local oriMonster = Table_MonsterOrigin[data.id] or {}
    local oriPos
    for i = 1, #oriMonster do
      if oriMonster[i].mapID == self.chooseData.id then
        oriPos = oriMonster[i].pos
      end
    end
    local cmdArgs = {
      targetMapID = self.chooseData.id,
      npcID = data.id
    }
    if oriPos then
      cmdArgs.targetPos = TableUtil.Array2Vector3(oriPos)
    end
    local cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandSkill)
    if cmd then
      Game.Myself:TryUseQuickRide()
      Game.Myself:Client_SetMissionCommand(cmd)
      self:sendNotification(WorldMapEvent.StartTrace)
      self:CloseSelf()
    end
  end
end

function WorldMapMenuPopUp:UpdateMapList(data)
  self.data = data
  if data == nil then
    return
  end
  self.chooseSymbol.transform:SetParent(self.gameObject.transform)
  local validMapList = {}
  local childMaps = data.childMaps
  for i = 1, #childMaps do
    if not self:IsMapBannedByFuncState(childMaps[i].id) then
      table.insert(validMapList, data.childMaps[i])
    end
  end
  self.mapList:ResetDatas(validMapList)
  self.title.text = data.staticData.NameZh
end

function WorldMapMenuPopUp:UpdateQuestMapSymbol()
  local inRaid = MapManager:IsRaidMode()
  if not inRaid then
    local imgId = ServicePlayerProxy.Instance:GetCurMapImageId()
    inRaid = imgId ~= nil and imgId ~= 0
  end
  local questlst = WorldMapProxy.Instance:GetQueryQuestList(self.chooseData.id)
  TableUtility.TableClearByDeleter(self.questShowDatas, miniMapDataDeleteFunc)
  for _, q in pairs(questlst) do
    local params = q.staticData and q.staticData.Params
    if params.ShowSymbol ~= 2 and params.ShowSymbol ~= 3 then
      local symbolType = QuestSymbolCheck.GetQuestSymbolByQuest(q)
      if symbolType then
        local combineId, npcPoint
        local uniqueid, npcid = params.uniqueid, params.npc
        npcid = type(npcid) == "table" and npcid[1] or npcid
        if uniqueid then
          npcPoint = self:FindNPCPoint(uniqueid)
        elseif npcid then
          npcPoint = self:GetMapNpcPointByNpcId(npcid)
          uniqueid = npcPoint and npcPoint.uniqueID or 0
        else
          combineId = q.questDataStepType .. q.id
        end
        if nil == combineId then
          if npcid == nil and uniqueid == nil then
            errorLog("Not Find Npc (questId:%s)", q.id)
          end
          combineId = QuestDataStepType.QuestDataStepType_VISIT .. tostring(npcid) .. tostring(uniqueid)
        end
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
  self.minimapWindow:UpdateQuestNpcSymbol(self.questShowDatas, true)
  self.minimapWindow:RefreshMapSymbols()
end

function WorldMapMenuPopUp:UpdateChooseData(data)
  self.chooseData = data
  self.mapname.text = data.NameZh
  local nowScene = SceneProxy.Instance.currentScene
  local nowMapId = nowScene.mapID
  self:GetCurChooseMapInfo()
  self:UpdateMapInfo()
  self:UpdateQuestSymbol()
  self:UpdateSealSymbol()
  self:CallQuestList()
  self:UpdateMap2D()
  self.menuScrollView:DisableSpring()
  self.menuScrollView:ResetPosition()
  self:UpdateGoBtn(data)
  if self.map2Did then
    self.map2Did = 0
  end
end

function WorldMapMenuPopUp:GetCurChooseMapInfo()
  local id = self.chooseData.id
  if not id or not Table_MapInfo then
    redlog("无地图信息")
    return
  end
  local data = self.chooseData
  local mode = data.Mode
  local sceneName = data.NameEn
  local sceneInfoName = "Scene_" .. sceneName
  local sceneInfo = autoImport(sceneInfoName)
  local scenePartUInfo
  if MapManager.Mode.PVE == mode then
    scenePartInfo = sceneInfo.PVE
  elseif MapManager.Mode.PVP == mode then
    scenePartInfo = sceneInfo.PVP
  elseif MapManager.Mode.Raid == mode then
    scenePartInfo = sceneInfo.Raids[id]
  end
  if nil ~= scenePartInfo then
    Game.DoPreprocess_ScenePartInfo(scenePartInfo, sceneInfoName)
  end
  self.sceneInfo = scenePartInfo
  self.mapInfoNum = 1
  self.curShowIndex = 1
  if sceneInfo.MapInfo and sceneInfo.MapInfo[1] then
    for i = 0, #sceneInfo.MapInfo do
      local single = sceneInfo.MapInfo[i]
      if single then
        self.mapInfoNum = i + 1
      end
    end
  end
  self:UpdateIndicator()
end

function WorldMapMenuPopUp:UpdateIndicator()
  local list = {}
  for i = 1, self.mapInfoNum do
    local data = {}
    if i == self.curShowIndex then
      data.cur = true
    end
    table.insert(list, data)
  end
  self.indicatorGrid:ResetDatas(list)
  if list and 1 < #list then
    self.grid.gameObject:SetActive(true)
  else
    self.grid.gameObject:SetActive(false)
  end
end

function WorldMapMenuPopUp:GetNPCPointArray(ID)
  if self.sceneInfo then
    return self.sceneInfo and self.sceneInfo.nps or nil
  else
    redlog("sceneInfo is nil")
  end
end

function WorldMapMenuPopUp:FindNPCPoint(ID)
  if self.sceneInfo then
    local map = self.sceneInfo.npMap
    return map and map[ID] or nil
  end
end

function WorldMapMenuPopUp:FindExitPoint(ID)
  if self.sceneInfo then
    local map = self.sceneInfo.epMap
    return map and map[ID] or nil
  end
end

function WorldMapMenuPopUp:FindBornPoint(ID)
  if self.sceneInfo then
    local map = self.sceneInfo.bpMap
    return map and map[ID] or nil
  end
end

function WorldMapMenuPopUp:GetMapNpcPointByNpcId(npcid)
  local npcList = self:GetNPCPointArray()
  if npcList then
    for i = 1, #npcList do
      local npcPoint = npcList[i]
      if npcPoint and npcPoint.ID == npcid then
        return npcPoint
      end
    end
  end
end

function WorldMapMenuPopUp:UpdateGoBtn(data)
  self.goBtn:SetActive(SceneProxy.Instance.currentScene.mapID ~= data.id)
  if self.isFromFurniture then
    self.goBtn_label.text = ZhString.WorldMapMenuPopUp_Transfer
  else
    self.goBtn_label.text = ZhString.WorldMapMenuPopUp_MoveTo
  end
end

function WorldMapMenuPopUp:UpdateQuestSymbol()
  local hasMain, hasBranch, hasDaily = false, false, false
  if self.chooseData then
    local list = QuestProxy.Instance:getQuestListByMapAndSymbol(self.chooseData.id) or {}
    for i = 1, #list do
      local quest = list[i]
      if quest.type == QuestDataType.QuestDataType_MAIN then
        hasMain = true
      elseif quest.type == QuestDataType.QuestDataType_DAILY then
        hasDaily = true
      else
        hasBranch = true
      end
      if hasMain and hasBranch and hasDaily then
        break
      end
    end
  end
  if hasMain == false or hasBranch == false or hasDaily == false then
    local questMapInfo = WorldMapProxy.Instance:GetWorldQuestInfo(self.chooseData.id)
    if questMapInfo then
      hasMain = questMapInfo[1] == true
      hasBranch = questMapInfo[2] == true
      hasDaily = questMapInfo[3] == true
    end
  end
  if hasDaily == false then
    hasDaily = self.hasDailyFunc == true
  end
  self.questSymbol1:SetActive(hasMain)
  self.questSymbol2:SetActive(hasBranch)
  self.questSymbol3:SetActive(hasDaily)
  self.questSymbolGrid:Reposition()
end

local CheckHasSealByMapId = function(mapid)
  local hasSeal, issealing
  local sealData = SealProxy.Instance:GetSealData(mapid)
  if sealData then
    for _, item in pairs(sealData.itemMap) do
      hasSeal = true
      if item.issealing then
        issealing = true
        break
      end
    end
  end
  return hasSeal, issealing
end

function WorldMapMenuPopUp:UpdateSealSymbol()
  local hasSeal, issealing = false, false
  if type(self.chooseData) ~= "table" then
    return
  end
  local mapid = self.chooseData and self.chooseData.id
  if mapid then
    hasSeal, issealing = CheckHasSealByMapId(mapid)
  end
  if hasSeal then
    self.sealSymbol.gameObject:SetActive(true)
    if issealing then
      self.sealSymbol.spriteName = "seal_icon_02"
    else
      self.sealSymbol.spriteName = "seal_icon_01"
    end
    self.questSymbolGrid:Reposition()
  else
    self.sealSymbol.gameObject:SetActive(false)
  end
end

local GetEventInfos = function(mapid)
  TableUtility.ArrayClear(tempArray)
  local events = FunctionActivity.Me():GetMapEvents(mapid)
  for i = 1, #events do
    if events[i].running then
      local mapInfo = events[i]:GetMapInfo()
      if mapInfo then
        local info = {
          type = MapInfoType.Event,
          id = events[i].id,
          icon = mapInfo.icon,
          label = mapInfo.label,
          iconScale = mapInfo.iconScale
        }
        table.insert(tempArray, info)
      end
    end
  end
  return tempArray
end

function WorldMapMenuPopUp:UpdateMap2D()
  local id = self.chooseData.id
  if Table_Map[id] then
    self.mapdata = Table_Map[id]
  else
    redlog("Map表不存在id" .. id)
  end
  self.minimapWindow:Reset()
  local map2DId = self.map2Did or 0
  local fName = "Scene_" .. self.mapdata.NameEn
  local sceneInfo = autoImport(fName)
  ClearTableFromG(fName)
  if sceneInfo.MapInfo and sceneInfo.MapInfo[map2DId] then
  else
    self.map2Did = 0
    map2DId = 0
  end
  local map2d = Game.Map2DManager:GetMap2D()
  self.minimapWindow:UpdateMapTexture(self.mapdata, LuaGeometry.GetTempVector3(325, 325), self.sceneInfo, map2d, map2DId)
end

local endlessBattleFieldGroup = {151, 152}

function WorldMapMenuPopUp:CallQuestList()
  self.questScrollView.gameObject:SetActive(false)
  self.Loading.gameObject:SetActive(true)
  self.NoneTip.gameObject:SetActive(false)
  if not self.forbidApply then
    self.clickTime = UnityUnscaledTime
    self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.updateApplyCtrl, self, 1, true)
    if 0 < TableUtility.ArrayFindIndex(endlessBattleFieldGroup, self.chooseData.id) then
      for i = 1, #endlessBattleFieldGroup do
        ServiceQuestProxy.Instance:CallQueryQuestListQuestCmd(endlessBattleFieldGroup[i], nil)
      end
    else
      ServiceQuestProxy.Instance:CallQueryQuestListQuestCmd(self.chooseData.id, nil)
    end
    helplog("申请ID", self.chooseData.id)
    self.previousApplyID = self.chooseData.id
    self.forbidApply = true
  end
end

function WorldMapMenuPopUp:updateApplyCtrl(deltaTime)
  if UnityUnscaledTime - self.clickTime > 5 then
    self.forbidApply = false
  end
end

function WorldMapMenuPopUp:applyQuestList()
  if not self.chooseData then
    return
  end
  if self.forbidApply then
    return
  else
    local mapid = self.chooseData.id
    if self.previousApplyID == mapid then
      return
    else
      ServiceQuestProxy.Instance:CallQueryQuestListQuestCmd(mapid, nil)
      helplog("申请ID", mapid)
      self.previousApplyID = mapid
    end
  end
end

function WorldMapMenuPopUp:UpdateMapInfo()
  local id = self.chooseData.id
  if not id or not Table_MapInfo then
    return
  end
  local upInfos, monsters = {}, {}
  local eventInfos = GetEventInfos(id)
  if eventInfos then
    for i = 1, #eventInfos do
      table.insert(upInfos, eventInfos[i])
    end
  end
  local mapInfo = Table_MapInfo[id]
  if mapInfo then
    local units = mapInfo.units
    if units then
      self.hasDailyFunc = false
      local monsterIDMap = {}
      for id, unit in pairs(units) do
        local idShadow = unit[1]
        local npcdata = id and Table_Npc[id]
        if npcdata then
          if not self.hasDailyFunc then
            self.hasDailyFunc = QuestSymbolCheck.HasDailySymbol(npcdata)
          end
          if npcdata.MapIcon ~= "" and npcdata.NoShowMapIcon ~= 1 then
            local isUnlock = true
            if npcdata.MenuId ~= nil then
              isUnlock = FunctionUnLockFunc.Me():CheckCanOpen(npcdata.MenuId)
            end
            if isUnlock then
              local temp = {
                id = id,
                uid = idShadow,
                type = MapInfoType.Npc,
                icon = npcdata.MapIcon,
                label = npcdata.NameZh
              }
              table.insert(upInfos, temp)
            end
          end
        else
          local monsterdata = id and Table_Monster[id]
          if monsterdata and monsterdata.Hide ~= 1 and monsterdata.WmapHide ~= 1 and not monsterIDMap[id] then
            monsterIDMap[id] = 1
            table.insert(monsters, monsterdata)
          end
        end
      end
    end
    local exitPoints = mapInfo.exitPoints
    if exitPoints then
      for i = 1, #exitPoints do
        if exitPoints[i] ~= id then
          local mapdata = Table_Map[exitPoints[i]]
          if mapdata then
            local temp = {
              id = exitPoints[i],
              type = MapInfoType.ExitPoint,
              icon = "map_portal",
              label = mapdata.NameZh
            }
            table.insert(upInfos, temp)
          end
        end
      end
    end
  end
  self.infoCtl:ResetDatas(upInfos)
  self.monsterCtl:ResetDatas(monsters)
  if monsters and 0 < #monsters then
    self.noMonsterTip.gameObject:SetActive(false)
  else
    self.noMonsterTip.gameObject:SetActive(true)
  end
end

function WorldMapMenuPopUp:QuestQuestList(data)
  helplog("recv function WorldMapMenuPopUp:QuestQuestList(data)")
  local type = data.type
  local list = self.questList[type] or {}
  if type == SceneQuest_pb.EQUESTLIST_CANACCEPT then
    list = {}
  end
  if data.clear and 0 < #list then
    for k, v in pairs(list) do
      FunctionQuest.Me():stopTrigger(v)
      ReusableObject.Destroy(v)
    end
    TableUtility.ArrayClear(list)
  end
  for i = 1, #data.list do
    local single = data.list[i]
    if single.id ~= 0 then
      self:tryRemoveQuestId(single.id, type)
      local questData = QuestData.CreateAsArray(QuestDataScopeType.QuestDataScopeType_CITY)
      questData:setQuestData(single)
      questData:setQuestListType(type)
      table.insert(list, questData)
    end
  end
  self.questList[type] = list
end

function WorldMapMenuPopUp:RefreshList(note)
  self.Loading.gameObject:SetActive(false)
  local list = WorldMapProxy.Instance:GetQueryQuestList(self.chooseData.id)
  if list and 0 < #list then
    helplog("list length" .. #list)
    self.questScrollView.gameObject:SetActive(true)
    self.NoneTip.gameObject:SetActive(false)
    local resultTable = self:MakeQuestFatherTable()
    self.listCtrl:ResetPosition(resultTable)
    self:UpdateQuestMapSymbol()
  else
    redlog("无任务")
    self.questScrollView.gameObject:SetActive(false)
    self.NoneTip.gameObject:SetActive(true)
  end
end

function WorldMapMenuPopUp:MakeQuestFatherTable()
  if self.questType then
    TableUtility.TableClear(self.questType)
  end
  local mapid = self.chooseData.id
  local list = WorldMapProxy.Instance:GetQueryQuestList(mapid)
  for i = 1, #list do
    local single = list[i]
    if not self.questType[single.staticData.ColorFromServer] and single.staticData.ColorFromServer ~= 0 and single.staticData.ColorFromServer ~= 6 and self:CheckQuestTypeShownInList(single.staticData.ColorFromServer) then
      fatherTagItem = ReusableTable.CreateTable()
      fatherTagItem.ColorFromServer = single.staticData.ColorFromServer
      self.questType[single.staticData.ColorFromServer] = fatherTagItem
    end
  end
  local resultTable = {}
  for k, v in pairs(self.questType) do
    local newGoal = ReusableTable.CreateTable()
    newGoal.fatherTag = v
    newGoal.childQuests = {}
    for i = 1, #list do
      local questData = list[i]
      if questData.staticData.ColorFromServer == 6 then
        questData.staticData.ColorFromServer = 1
      end
      if questData.staticData.ColorFromServer == v.ColorFromServer and questData.traceInfo ~= "" then
        table.insert(newGoal.childQuests, questData)
      end
    end
    table.insert(resultTable, newGoal)
  end
  if GameConfig.Quest and GameConfig.Quest.QuestSort then
    local QuestSort = GameConfig.Quest.QuestSort
    table.sort(resultTable, function(l, r)
      local leftSortOrder = QuestSort[l.fatherTag.ColorFromServer].sortorder or 99
      local rightSortOrder = QuestSort[r.fatherTag.ColorFromServer].sortorder or 99
      if leftSortOrder == 99 or rightSortOrder == 99 then
        redlog("tag颜色为" .. l.fatherTag.ColorFromServer .. "或者" .. r.fatherTag.ColorFromServer .. "未配置sort值")
      end
      if leftSortOrder ~= rightSortOrder then
        return leftSortOrder > rightSortOrder
      end
    end)
  end
  return resultTable
end

local checkList = {
  "main",
  "branch",
  "world",
  "acc_world",
  "acc_daily_world"
}

function WorldMapMenuPopUp:CheckQuestTypeShownInList(questType)
  for i = 1, #checkList do
    local validType = checkList[i]
    if questType == validType then
      return true
    end
  end
  return false
end

local checkColorList = {
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  20
}

function WorldMapMenuPopUp:CheckQuestTypeShownInList(ColorFromServer)
  for i = 1, #checkColorList do
    local validColor = checkColorList[i]
    if ColorFromServer == validColor then
      return true
    end
  end
  return false
end

function WorldMapMenuPopUp:SwitchMiniMap()
  local curShowMap2DIndex = self.curShowIndex - 1
  self.map2Did = curShowMap2DIndex
  helplog("显示目标2D" .. self.map2Did)
  self:UpdateIndicator()
  self:UpdateMap2D()
end

function WorldMapMenuPopUp:RemoveCells()
  self.listCtrl:RemoveAll()
end

function WorldMapMenuPopUp:RefreshTable()
  self.questTable:Reposition()
  self.questScrollView:ResetPosition()
  self.questScrollView:DisableSpring()
end

function WorldMapMenuPopUp:RunQuestSymbolAnimator(note)
  if not note or not note.body then
    return
  end
  local cellCtrl = note.body.cellCtrl
  local questData = cellCtrl.data
  self.minimapWindow:PlayChooseQuestSymbolAnimation(questData)
end

function WorldMapMenuPopUp:RecvCloseCmd()
  helplog("监听消息")
  self:sendNotification(WorldMapEvent.StartTrace)
  self:CloseSelf()
end

function WorldMapMenuPopUp:AddListenEvts()
  self:AddListenEvt(ServiceEvent.QuestQueryQuestListQuestCmd, self.RefreshList)
  self:AddListenEvt("ClickBigMapBoardQuestCell", self.RunQuestSymbolAnimator)
end

function WorldMapMenuPopUp:IsMapBannedByFuncState(mapid)
  local funcstateId = 118
  if FunctionUnLockFunc.checkFuncStateValid(funcstateId) then
    return false
  end
  local bannedMapid = Table_FuncState[funcstateId] and Table_FuncState[funcstateId].MapID
  if not bannedMapid then
    return false
  end
  if TableUtility.ArrayFindIndex(bannedMapid, mapid) > 0 then
    return true
  end
end

function WorldMapMenuPopUp:OnEnter()
  WorldMapMenuPopUp.super.OnEnter(self)
  EventManager.Me():AddEventListener(MyselfEvent.MissionCommandChanged, self.RecvCloseCmd, self)
  local viewdata = self.viewdata.viewdata
  self.isFromFurniture = viewdata.isFromFurniture
  self:UpdateMapList(viewdata.data)
  local cells = self.mapList:GetCells()
  self:ClickMapCell(cells[1])
  TimeTickManager.Me():CreateTick(0, 1000, self.applyQuestList, self, 2)
end

function WorldMapMenuPopUp:OnExit()
  WorldMapMenuPopUp.super.OnExit(self)
  EventManager.Me():RemoveEventListener(MyselfEvent.MissionCommandChanged, self.RecvCloseCmd, self)
  self.mapList:ResetDatas(tempArray)
  self.minimapWindow:OnDestroy()
  TimeTickManager.Me():ClearTick(self)
end
