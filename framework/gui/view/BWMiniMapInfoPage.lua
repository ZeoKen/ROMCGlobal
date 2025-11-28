BWMiniMapInfoPage = class("BWMiniMapInfoPage", SubView)
autoImport("BWNearlyCreatureCell")
local MapManager = Game.MapManager
local MiniMapSymbolPath = ResourcePathHelper.UICell("MiniMapSymbol")
autoImport("MiniMapData")
local IsNull = Slua.IsNull
local _TableClear = TableUtility.TableClear
local _TableClearByDeleter = TableUtility.TableClearByDeleter
local Table_Npc = Table_Npc
local _GuildProxy = GuildProxy.Instance
local miniMapDataDeleteFunc = function(d)
  d:Destroy()
end

function BWMiniMapInfoPage:Init()
  self.nearlyPlayers = {}
  self.npcRoles = {}
  self.serverNpcs = {}
  self.exitPoints = {}
  self.infoBord = self:FindGO("InfoBord")
  self.layerTipStick = self:FindComponent("PlayerTipStick", UIWidget, self.nearlyBord)
  self.playerTog = self:FindComponent("PlayerTog", UIToggle, self.infoBord)
  self:AddClickEvent(self.playerTog.gameObject, function()
    self:SwitchNearlyList(1, true)
  end)
  self.npcTog = self:FindComponent("NPCTog", UIToggle, self.infoBord)
  self:AddClickEvent(self.npcTog.gameObject, function()
    self:SwitchNearlyList(2, true)
  end)
  self.mapTog = self:FindComponent("MapTog", UIToggle, self.infoBord)
  self:AddClickEvent(self.mapTog.gameObject, function()
    self:SwitchNearlyList(3, true)
  end)
  self.nearlyCreaturesCtl = WrapCellHelper.new({
    wrapObj = self:FindGO("InfoGrid", self.infoBord),
    cellName = "BWNearlyCreatureCell",
    control = BWNearlyCreatureCell,
    dir = 1
  })
  self.nearlyCreaturesCtl:AddEventListener(MouseEvent.MouseClick, self.ClickNearlyCell, self)
  self.noPlayerTip = self:FindGO("PlayerNoneTip", self.infoBord)
  self.noNpcTip = self:FindGO("NpcNoneTip", self.infoBord)
end

function BWMiniMapInfoPage:InitEvents()
  self:AddListenEvt(SceneUserEvent.SceneAddRoles, self.HandleRolesUpdate)
  self:AddListenEvt(SceneUserEvent.SceneRemoveRoles, self.HandleRolesUpdate)
end

function BWMiniMapInfoPage:HandleRolesUpdate(note)
  if self.nowNearlyTog == 1 then
    self:SwitchNearlyList(1, false)
  end
end

local tempArgs = {}

function BWMiniMapInfoPage:ClickNearlyCell(cellCtl)
  local id = cellCtl.id
  local creatureType = cellCtl.creatureType
  if cellCtl.isExitPoint then
    local currentMapID = MapManager:GetMapID()
    local disableInnerTeleport = Table_Map[currentMapID].MapNavigation
    if nil ~= disableInnerTeleport and 0 ~= disableInnerTeleport then
      MsgManager.ShowMsgByIDTable(50)
    else
      tempArgs.targetPos = cellCtl.pos
      tempArgs.showClickGround = true
      tempArgs.allowExitPoint = true
      local cmd = MissionCommandFactory.CreateCommand(tempArgs, MissionCommandMove)
      if cmd then
        Game.Myself:TryUseQuickRide()
        Game.Myself:Client_SetMissionCommand(cmd)
      end
      _TableClear(tempArgs)
    end
  elseif creatureType == Creature_Type.Player then
    local creature = SceneCreatureProxy.FindCreature(id)
    if creature then
      if GuildProxy.Instance:GetMercenaryGuildName(creature.data) ~= nil then
        MsgManager.ShowMsgByID(2669)
        return
      end
      local playerData = PlayerTipData.new()
      playerData:SetByCreature(creature)
      if creature ~= self.lastCreature then
        local playerTip = FunctionPlayerTip.Me():GetPlayerTip(self.layerTipStick, NGUIUtil.AnchorSide.Right, {-356, 0})
        local tipData = {playerData = playerData}
        tipData.funckeys = FunctionPlayerTip.Me():GetPlayerFunckey(id)
        table.insert(tipData.funckeys, "Booth")
        table.insert(tipData.funckeys, "EnterHomeRoom")
        playerTip:SetData(tipData)
        
        function playerTip.closecallback(go)
          self.lastCreature = nil
        end
        
        playerTip:AddIgnoreBound(cellCtl.gameObject)
        self.lastCreature = creature
      else
        FunctionPlayerTip.Me():CloseTip()
        self.lastCreature = nil
      end
    end
  elseif creatureType == Creature_Type.Npc then
    local pos = cellCtl.pos
    local window = self.container:GetWindow()
    if window then
      window:UpdateDestPos(pos)
    end
    local npcid, uniqueid = cellCtl.npcid, cellCtl.uniqueid
    tempArgs.targetMapID = MapManager:GetMapID()
    tempArgs.npcID = npcid
    tempArgs.npcUID = uniqueid
    tempArgs.targetPos = pos
    local cmd = MissionCommandFactory.CreateCommand(tempArgs, MissionCommandVisitNpc)
    Game.Myself:TryUseQuickRide()
    Game.Myself:Client_SetMissionCommand(cmd)
    _TableClear(tempArgs)
  end
end

function BWMiniMapInfoPage:SwitchNearlyList(tog, rePosition)
  self.nowNearlyTog = tog
  if tog == 1 then
    self:UpdateNearlyPlayer(rePosition)
  elseif tog == 2 then
    self:UpdateNearlyMonsters(rePosition)
  elseif tog == 3 then
    self:UpdateNearlyMapInfos(rePosition)
  end
end

function BWMiniMapInfoPage:UpdateNearlyPlayer(rePosition)
  _TableClearByDeleter(self.nearlyPlayers, miniMapDataDeleteFunc)
  local allRole = NSceneUserProxy.Instance.userMap
  for _, role in pairs(allRole) do
    local playerMapData = MiniMapData.CreateAsTable(role.data.id)
    playerMapData:SetParama("name", role.data.name)
    playerMapData:SetParama("creatureType", Creature_Type.Player)
    playerMapData:SetParama("Profession", role.data.userdata:Get(UDEnum.PROFESSION))
    playerMapData:SetParama("gender", role.data.userdata:Get(UDEnum.SEX))
    playerMapData:SetParama("level", role.data.userdata:Get(UDEnum.ROLELEVEL))
    table.insert(self.nearlyPlayers, playerMapData)
  end
  self.noNpcTip:SetActive(false)
  if self.nowNearlyTog == 1 then
    self.playerTog.value = true
    self.nearlyCreaturesCtl:ResetDatas(self.nearlyPlayers)
    self.noPlayerTip:SetActive(#self.nearlyPlayers == 0)
    if rePosition then
      self.nearlyCreaturesCtl:ResetPosition()
    end
  end
end

local npcRolesMap = {}

function BWMiniMapInfoPage:UpdateNearlyMonsters(rePosition)
  _TableClearByDeleter(self.npcRoles, miniMapDataDeleteFunc)
  _TableClear(npcRolesMap)
  local npcList = MapManager:GetNPCPointArray()
  if npcList then
    for i = 1, #npcList do
      local point = npcList[i]
      local npcData = Table_Npc[point.ID]
      if npcData and npcData.MapIcon ~= "" and npcData.NoShowMapIcon ~= 1 and FunctionNpcFunc.checkNPCValid(npcData.id) and (not npcData.MenuId or FunctionUnLockFunc.Me():CheckCanOpen(npcData.MenuId)) then
        local combineId = QuestDataStepType.QuestDataStepType_VISIT .. point.ID .. point.uniqueID
        local npcMapData = npcRolesMap[combineId]
        npcMapData = npcMapData or MiniMapData.CreateAsTable(combineId)
        npcMapData:SetParama("creatureType", Creature_Type.Npc)
        npcMapData:SetParama("npcid", npcData.id)
        npcMapData:SetParama("uniqueid", point.uniqueID)
        npcMapData:SetParama("name", npcData.NameZh)
        npcMapData:SetParama("icon", npcData.MapIcon)
        npcMapData:SetParama("PositionTip", npcData.Position)
        npcMapData:SetPos(point.position[1], point.position[2], point.position[3])
        npcRolesMap[combineId] = npcMapData
        table.insert(self.npcRoles, npcMapData)
      end
    end
  end
  for npcCombineId, npcInfo in pairs(self.serverNpcs) do
    if npcInfo.nearShow then
      local npcid = npcInfo.staticId
      local combineId = QuestDataStepType.QuestDataStepType_VISIT .. npcCombineId
      local npcMapData = npcRolesMap[combineId]
      npcMapData = npcMapData or MiniMapData.CreateAsTable(combineId)
      local npcData = Table_Npc[npcid]
      npcMapData:SetParama("creatureType", Creature_Type.Npc)
      npcMapData:SetParama("npcid", npcid)
      npcMapData:SetParama("name", npcData.NameZh)
      npcMapData:SetParama("icon", npcData.MapIcon)
      npcMapData:SetParama("PositionTip", npcData.Position)
      npcMapData:SetPos(npcInfo.pos[1], npcInfo.pos[2], npcInfo.pos[3])
      npcRolesMap[combineId] = npcMapData
      table.insert(self.npcRoles, npcMapData)
    end
  end
  table.sort(self.npcRoles, function(qa, qb)
    return qa:GetParama("npcid") < qb:GetParama("npcid")
  end)
  self.noPlayerTip:SetActive(false)
  if self.nowNearlyTog == 2 then
    self.npcTog.value = true
    self.nearlyCreaturesCtl:ResetDatas(self.npcRoles)
    self.noNpcTip:SetActive(#self.npcRoles == 0)
    if rePosition then
      self.nearlyCreaturesCtl:ResetPosition()
    end
  end
end

function BWMiniMapInfoPage:UpdateNearlyMapInfos(rePosition)
  _TableClearByDeleter(self.exitPoints, miniMapDataDeleteFunc)
  local exitPointArray = MapManager:GetExitPointArray()
  if exitPointArray then
    for i = 1, #exitPointArray do
      local edata = exitPointArray[i]
      if edata and edata.nextSceneID and edata.nextSceneID ~= 0 and not Game.AreaTrigger_ExitPoint:IsInvisible(edata.ID) then
        local data = MiniMapData.CreateAsTable(edata.ID)
        data:SetParama("isExitPoint", true)
        data:SetParama("nextSceneID", edata.nextSceneID)
        data:SetParama("index", i)
        data:SetPos(edata.position[1], edata.position[2], edata.position[3])
        table.insert(self.exitPoints, data)
      end
    end
  end
  self.noPlayerTip:SetActive(false)
  self.noNpcTip:SetActive(false)
  if self.nowNearlyTog == 3 then
    self.mapTog.value = true
    self.nearlyCreaturesCtl:ResetDatas(self.exitPoints)
    if rePosition then
      self.nearlyCreaturesCtl:ResetPosition()
    end
  end
end

function BWMiniMapInfoPage:Show()
  self.infoBord:SetActive(true)
end

function BWMiniMapInfoPage:Hide()
  self.infoBord:SetActive(false)
end

function BWMiniMapInfoPage:OnEnter()
  BWMiniMapInfoPage.super.OnEnter(self)
  self:SwitchNearlyList(2, true)
end

function BWMiniMapInfoPage:OnExit()
  BWMiniMapInfoPage.super.OnExit(self)
end
