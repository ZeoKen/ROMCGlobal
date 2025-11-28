autoImport("NoviceExpGuideCell")
NoviceExpGuideView = class("NoviceExpGuideView", BaseView)
NoviceExpGuideView.ViewType = UIViewType.PopUpLayer
local tempPos = LuaVector3.Zero()

function NoviceExpGuideView:Init()
  self:InitView()
  self:AddViewEvt()
  self:InitData()
  self:InitShow()
end

function NoviceExpGuideView:InitView()
  self.title = self:FindGO("Title"):GetComponent(UILabel)
  self.scrollView = self:FindGO("ScrollView"):GetComponent(UIScrollView)
  self.grid = self:FindGO("Grid"):GetComponent(UIGrid)
  self.expGuideCtrl = UIGridListCtrl.new(self.grid, NoviceExpGuideCell, "NoviceExpGuideCell")
  self.expGuideCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickGO, self)
end

function NoviceExpGuideView:AddViewEvt()
  self:AddListenEvt(ServiceEvent.NUserBattleTimelenUserCmd, self.HandleTimelen)
end

function NoviceExpGuideView:InitData()
  local viewdata = self.viewdata and self.viewdata.viewdata
  self.groupid = viewdata and viewdata.groupid or 1
  self.level = viewdata and viewdata.level or MyselfProxy.Instance:RoleLevel()
  self.guideList = {}
  for k, v in pairs(Table_GuideUI) do
    if v.GroupID == self.groupid then
      if not self.titleText then
        self.titleText = v.MainTitle
      end
      table.insert(self.guideList, v)
    end
  end
  table.sort(self.guideList, function(l, r)
    return l.id < r.id
  end)
end

function NoviceExpGuideView:InitShow()
  if not self.guideList or #self.guideList == 0 then
    return
  end
  self.title.text = string.format(self.titleText, self.level) or ""
  self.expGuideCtrl:ResetDatas(self.guideList)
  BattleTimeDataProxy.QueryBattleTimelenUserCmd()
end

function NoviceExpGuideView:RefreshTimeLenStatus()
  if not self.timeLen then
    return
  end
  local cells = self.expGuideCtrl:GetCells()
  for i = 1, #cells do
    local cell = cells[i]
    local data = cell.data
    if data.complete_con == "BattleTime" then
    end
  end
end

function NoviceExpGuideView:HandleTimelen(note)
  local data = note.body
  local timelen = data and data.timelen and math.floor(data.timelen / 60)
  local timeTotal = data and data.totaltime and math.floor(data.totaltime / 60)
  if not timelen or not timeTotal then
    redlog("return", timelen, timeTotal)
    return
  end
  xdlog("时间", timelen, timeTotal)
  local cells = self.expGuideCtrl:GetCells()
  for i = 1, #cells do
    local cell = cells[i]
    local data = cell.data
    if data.complete_con == "BattleTime" then
      cell:SetStatus(timeTotal - timelen < 60)
    end
  end
end

function NoviceExpGuideView:HandleClickGO(cellCtrl)
  local data = cellCtrl and cellCtrl.data
  if not data then
    return
  end
  if cellCtrl.isFinish and data.Sysmsg then
    MsgManager.ShowMsgByID(data.Sysmsg)
    return
  end
  local params = data.Params
  local mapid = params and params.mapid
  local curMap = Game.MapManager:GetMapID()
  if mapid and mapid ~= curMap then
    local cmdArgs = {targetMapID = mapid}
    local cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandMove)
    Game.Myself:Client_SetMissionCommand(cmd)
    GameFacade.Instance:sendNotification(ShortCut.MoveToPos, cmdArgs.targetMapID)
    self:CloseSelf()
    xdlog("地图不符合  走路过去")
    return
  end
  local completeCheck = data.complete_con
  if completeCheck and completeCheck == "Wanted" then
    xdlog("看板特殊处理")
    FunctionVisitNpc.openWantedQuestPanel(101, nil, false)
    self:CloseSelf()
  elseif completeCheck == "Teleport" then
    UIMapMapList.AutoChoose = self.level
    local targetMap = 1
    for k, v in pairs(Table_Map) do
      if v.LvRange and v.LvRange[1] and v.LvRange[1] <= self.level and v.LvRange[2] >= self.level then
        targetMap = v.id
        break
      end
    end
    local cmdArgs = {}
    local canTransfer = MapTeleportUtil.CanTargetTransferTo(targetMap)
    if not canTransfer then
      cmdArgs.targetMapID = targetMap
      cmdClass = MissionCommandMove
    else
      local nowMapID = Game.MapManager:GetMapID()
      local transferID1, transferID2, transferPos, targetNpcUID = WorldTeleport.TryGetTransferMapInfo(nowMapID, targetMap)
      cmdArgs.targetMapID = transferID1 or nowMapID
      cmdArgs.targetPos = LuaVector3.Zero()
      cmdArgs.npcUID = targetNpcUID
      cmdClass = MissionCommandVisitNpc
      FunctionVisitNpc.Me():AddDirectDoNpcFuncList(3001)
    end
    Game.Myself:TryUseQuickRide()
    Game.AutoBattleManager:AutoBattleOff()
    local cmd = MissionCommandFactory.CreateCommand(cmdArgs, cmdClass)
    Game.Myself:Client_SetMissionCommand(cmd)
    self:CloseSelf()
  elseif completeCheck == "PrestigeQuest" then
    local mapid = params and params.mapid or 149
    local zoneUnlockInfo = WorldMapProxy.Instance:GetUnlockBWZoneByMapID(mapid)
    if not zoneUnlockInfo or #zoneUnlockInfo == 0 then
      redlog("一片解锁的区域都没有")
      return
    end
    local isAllFinish = true
    local BWQuestMap = GameConfig.Quest.BWMapQuest
    local knightMap = BWQuestMap and BWQuestMap[mapid]
    if knightMap then
      for groupid, questIds in pairs(knightMap) do
        if zoneUnlockInfo[groupid] then
          for i = 1, #questIds do
            local questData = QuestProxy.Instance:GetQuestDataBySameQuestID(questIds[i])
            if questData then
              isAllFinish = false
              xdlog("有未完成的任务", questIds[i])
              break
            end
          end
        end
      end
    end
    if isAllFinish then
      local msgid = data.Sysmsg
      if msgid then
        MsgManager.ShowMsgByID(msgid)
      end
      return
    end
    local shortCutPowerId = data.Shortcutpower
    if shortCutPowerId then
      FuncShortCutFunc.Me():CallByID(shortCutPowerId)
      self:CloseSelf()
    end
  elseif completeCheck == "WorldQuest" then
    local mapid = params and params.mapid or 149
    local worldQuestGroup = Game.MapManager:GetWorldQuestGroupByMapID(mapid)
    if not worldQuestGroup then
      redlog("当前地图不在冒险任务组内")
      return
    end
    local curProcess = QuestProxy.Instance:GetWorldCount(worldQuestGroup)
    if 4 <= curProcess then
      local msgid = data.Sysmsg
      if msgid then
        MsgManager.ShowMsgByID(msgid)
      end
      return
    end
    local shortCutPowerId = data.Shortcutpower
    if shortCutPowerId then
      FuncShortCutFunc.Me():CallByID(shortCutPowerId)
      self:CloseSelf()
    end
  elseif completeCheck == "WildMvp" then
    local mapid = params and params.mapid
    if not mapid then
      return
    end
    WorldMapProxy.Instance:UpdateBWZoneInfo(mapid)
    WorldMapProxy.Instance:RefreshBWZoneInfo()
    local zoneUnlockInfo = WorldMapProxy.Instance:GetUnlockBWZoneByMapID(mapid)
    if not zoneUnlockInfo or #zoneUnlockInfo == 0 then
      redlog("一片解锁的区域都没有")
      return
    end
    local typeList = params and params.type
    local isAllKill = true
    local monsterDatas = WildMvpProxy.Instance:GetMiniMapMonsterDataByMap(mapid)
    if not monsterDatas then
      redlog("没有怪物")
      return
    end
    for monsterid, monsterData in pairs(monsterDatas) do
      if monsterData:IsUnlocked() then
        local mapZoneID = monsterData:GetMapZoneID()
        if mapZoneID and zoneUnlockInfo[mapZoneID] then
          local symbolType = monsterData:GetSymbolType()
          if not typeList or 0 < TableUtility.ArrayFindIndex(typeList, symbolType) then
            local noPosHide = monsterData.noPosHide
            local progress, isAlive = monsterData:GetMapSymbolProgress()
            if not monsterData.noPosHide and isAlive then
              isAllKill = false
              xdlog("有没杀的怪物", monsterid)
              break
            end
          else
            redlog("SymbolType不符合", monsterid)
          end
        else
          redlog("地图区域未解锁", monsterid, mapZoneID)
        end
      else
        redlog("没解锁的怪物", monsterid)
      end
    end
    if isAllKill then
      local msgid = data.Sysmsg
      if msgid then
        MsgManager.ShowMsgByID(msgid)
      end
      return
    end
    local shortCutPowerId = data.Shortcutpower
    if shortCutPowerId then
      FuncShortCutFunc.Me():CallByID(shortCutPowerId)
      self:CloseSelf()
    end
  else
    local msgPop = false
    if mapid and mapid == curMap then
      msgPop = true
    end
    if msgPop and data.Sysmsg then
      MsgManager.ShowMsgByID(data.Sysmsg)
    end
    local shortCutPowerId = data.Shortcutpower
    if shortCutPowerId then
      FuncShortCutFunc.Me():CallByID(shortCutPowerId)
      self:CloseSelf()
    end
  end
end
