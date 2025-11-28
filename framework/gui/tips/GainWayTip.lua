autoImport("BaseTip")
autoImport("GainWayTipCell")
GainWayTip = class("GainWayTip", BaseTip)
GainWayTip.CloseGainWay = "GainWayTip_CloseGainWay"
local TraceNpc = function(npc)
  local map = ReusableTable.CreateTable()
  for i = 1, #npc do
    local npcmap = Table_NpcMap[npc[i]]
    if npcmap ~= nil then
      for k, v in pairs(npcmap) do
        map[k] = npc[i]
      end
    end
  end
  local retMap
  local curMap = Game.MapManager:GetMapID()
  if map[curMap] then
    retMap = curMap
  else
    retMap = MapTeleportUtil.FindNearlyMap(curMap, function(mapId)
      return map[mapId] ~= nil
    end)
  end
  local npcid = map[retMap]
  ReusableTable.DestroyAndClearTable(map)
  if retMap ~= nil then
    local cmdArgs = {
      targetMapID = retMap,
      npcID = npcid,
      npcUID = Table_NpcMap[npcid][retMap]
    }
    local cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandVisitNpc)
    if cmd then
      Game.Myself:Client_SetMissionCommand(cmd)
    end
  end
end
local TraceNpcs = function(data)
  local config = Table_ItemOriginV1[data.id]
  config = config[data.type]
  TraceNpc(config)
end
local TraceShop = function(data)
  local config = Table_ItemOriginV1[data.id]
  config = config[data.type]
  local npc = config.npc
  if npc ~= nil then
    TraceNpc(npc)
  else
    local key = config.key
    if key ~= nil then
      local type = key // 1000
      local id = key % 1000
      local npcFunctionData = Table_NpcFunction[type]
      if npcFunctionData ~= nil then
        FunctionNpcFunc.Me():DoNpcFunc(npcFunctionData, Game.Myself, id)
      end
    end
  end
end
local TraceDeposit = function(data)
  if data.subtype == GainWayData.DepositType.Normal then
    FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_THot)
  elseif data.subtype == GainWayData.DepositType.MonthCard then
    FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TCard)
  elseif data.subtype == GainWayData.DepositType.ROB then
    FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit)
  end
end
local TraceDungeon = function(data)
  local config = Table_PveRaidEntrance[data.value]
  if config ~= nil then
    PveEntranceProxy.Instance:OpenViewByBossId(data.value, data.monsterID)
  end
end
local TraceMonster = function(data)
  local cmdArgs, cmd = ReusableTable.CreateTable()
  cmdArgs.targetMapID = data.value
  cmdArgs.npcID = data.monsterID
  cmdArgs.targetPos = Game.MapManager:GetNpcPos(data.value, data.monsterID)
  cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandSkill)
  Game.Myself:Client_SetMissionCommand(cmd)
  ReusableTable.DestroyAndClearTable(cmdArgs)
end
local TraceCompose = function(data)
  if data.subtype == GainWayData.ComposeType.EquipMake then
    FunctionNpcFunc.JumpPanel(PanelConfig.CommonCombineView, {
      npcdata = nil,
      index = 1,
      tabs = {
        PanelConfig.EquipMfrView
      },
      equipid = data.id
    })
  elseif data.subtype == GainWayData.ComposeType.EquipReplace then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.EquipReplaceNewView
    })
  elseif data.subtype == GainWayData.ComposeType.PicMake then
    if Table_HomeFurniture[data.id] ~= nil then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.HomeTipPopUp,
        viewdata = data.id
      })
    end
  elseif data.subtype == GainWayData.ComposeType.EquipCompose then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.AdventurePanel,
      viewdata = {
        tabId = SceneManual_pb.EMANUALTYPE_RESEARCH,
        selectItemId = data.id
      }
    })
  elseif data.subtype == GainWayData.ComposeType.Artifact then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PersonalArtifactFunctionView,
      viewdata = {
        state = PersonalArtifactFunctionState.Compose,
        itemid = data.id
      }
    })
  end
end
local TraceGuild = function(data)
  local config = Table_GuildBuilding[data.value]
  if config == nil then
    return
  end
  local mapid = 10001
  local npcid = config.NpcID
  local map = Table_Map[mapid]
  if map == nil then
    return
  end
  local uniqueid
  local sceneInfo = autoImport("Scene_" .. map.NameEn)
  if sceneInfo ~= nil then
    sceneInfo = sceneInfo.Raids
    if sceneInfo ~= nil then
      sceneInfo = sceneInfo[mapid]
      if sceneInfo ~= nil then
        local nps = sceneInfo.nps
        if nps ~= nil then
          for i = 1, #nps do
            if nps[i].ID == npcid then
              uniqueid = nps[i].uniqueID
            end
          end
        end
      end
    end
  end
  if uniqueid == nil then
    return
  end
  local info = {}
  local event = {}
  info.Event = event
  event.npcid = npcid
  event.mapid = mapid
  event.uniqueid = uniqueid
  FuncShortCutFunc.Me():RaidJump(info)
end
local TraceAchievement = function(data)
  if data.subtype == GainWayData.AchievementType.System then
    AdventurePanel.OpenAchievePageById(data.value)
  elseif data.subtype == GainWayData.AchievementType.Dungeon then
    TraceDungeon(data)
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PveAchievementPopup,
      viewdata = {
        id = data.value
      }
    })
  end
end
local TraceQuest = function(data)
  local questData = QuestProxy.Instance:getQuestDataByQuestID(data.subtype)
  if questData ~= nil then
    FunctionQuest.Me():executeQuest(questData)
  end
end
local TraceLottery = function(data)
  FunctionLottery.Me():OpenNewLotteryByType(data.lotterytype)
end
local TracePet = function(data)
  if data.subtype == GainWayData.PetType.Capture then
    local cmdArgs, cmd = ReusableTable.CreateTable()
    cmdArgs.targetMapID = data.value
    cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandMove)
    Game.Myself:Client_SetMissionCommand(cmd)
    ReusableTable.DestroyAndClearTable(cmdArgs)
  else
    FunctionPet.Me():OpenPetCompose(data.value)
  end
end
local TraceRecipe = function(data)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.AdventurePanel,
    viewdata = {
      tabId = SceneManual_pb.EMANUALTYPE_FOOD,
      selectItemId = data.id
    }
  })
end
local TraceFunc = function(type)
  if not _TraceFunc then
    _TraceFunc = {
      [GainWayData.Type.Shop] = TraceShop,
      [GainWayData.Type.Deposit] = TraceDeposit,
      [GainWayData.Type.Dungeon] = TraceDungeon,
      [GainWayData.Type.Monster] = TraceMonster,
      [GainWayData.Type.Card] = TraceNpcs,
      [GainWayData.Type.Compose] = TraceCompose,
      [GainWayData.Type.Guild] = TraceGuild,
      [GainWayData.Type.Achievement] = TraceAchievement,
      [GainWayData.Type.Quest] = TraceQuest,
      [GainWayData.Type.Lottery] = TraceLottery,
      [GainWayData.Type.Decompose] = TraceNpcs,
      [GainWayData.Type.Pet] = TracePet,
      [GainWayData.Type.Extract] = TraceNpcs,
      [GainWayData.Type.Recipe] = TraceRecipe
    }
  end
  return _TraceFunc[type]
end

function GainWayTip:ctor(parent, depth)
  self.depth = depth
  GainWayTip.super.ctor(self, "GainWayTip", parent)
end

function GainWayTip:Init()
  self:FindObjs()
  self:InitContentList()
  
  function self.closecomp.callBack(go)
    self:OnExit()
  end
  
  if self.depth then
    self.panel.depth = self.depth
    self.contentScrollView:GetComponent(UIPanel).depth = self.panel.depth + 1
  else
    local temp = self.gameObject.transform.parent:GetComponentInParent(UIPanel)
    if temp then
      self.panel.depth = temp.depth + 1
      self.contentScrollView:GetComponent(UIPanel).depth = self.panel.depth + 1
    end
  end
  self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3()
  self.gameObject:SetActive(false)
  self.closeButton = self:FindGO("CloseButton")
  self:AddClickEvent(self.closeButton, function(go)
    self:OnExit()
  end)
  self.noTip = self:FindGO("NoTip")
end

function GainWayTip:FindObjs()
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  self.contentScrollView = self:FindGO("contentScrollView"):GetComponent(UIScrollView)
  self.contentGrid = self:FindGO("contentGrid"):GetComponent(UIGrid)
  self.panel = self.gameObject:GetComponent(UIPanel)
end

function GainWayTip:InitContentList()
  self.contentList = UIGridListCtrl.new(self.contentGrid, GainWayTipCell, "GainWayTipCell")
  self.contentList:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self.contentList:AddEventListener(GainWayTipCell.AddItemTrace, self.SetData, self)
  self.contentList:AddEventListener(ItemEvent.GoTraceItem, self.GoTraceItem, self)
end

function GainWayTip:GotoAdventureAppend(appendId)
  local appendConfig = Table_AdventureAppend[appendId]
  if not appendConfig then
    return
  end
  local monsterId = appendConfig.targetID
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.AdventurePanel,
    viewdata = {
      tabId = SceneManual_pb.EMANUALTYPE_MONSTER,
      selectItemId = monsterId
    }
  })
end

function GainWayTip:GoTraceItem(data)
  if GainWayTipProxy.V1 then
    local func = TraceFunc(data.type)
    if func ~= nil then
      self:OnExit()
      func(data)
    end
    return
  end
  local id = data.addWayID
  local gotoMode = Table_AddWay[id] and Table_AddWay[id].GotoMode
  if data.ShouldGotoUnlock and data:ShouldGotoUnlock() then
    local lockType = data.context.lockType
    local lockArg = data.context.lockArg
    if lockType == ShopItemData.LockType.AdventureAppend then
      if type(lockArg) == "string" then
        lockArg = tonumber(lockArg)
      end
      self:GotoAdventureAppend(lockArg)
    end
    return
  end
  if (id == GainWayTipProxy.MonsterAddWayID or id == GainWayItemData.MonsterList_ID) and data.shortCutMapParam then
    local myself = Game.Myself
    if Game.MapManager:GetMapID() == data.shortCutMapParam then
      if data.tracePos then
        local cmdArgs, cmd = ReusableTable.CreateTable()
        cmdArgs.targetMapID = data.shortCutMapParam
        cmdArgs.targetPos = LuaGeometry.GetTempVector3(data.tracePos[1] or 0, data.tracePos[2] or 0, data.tracePos[3] or 0)
        cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandMove)
        myself:Client_SetMissionCommand(cmd)
        ReusableTable.DestroyAndClearTable(cmdArgs)
      else
        myself:Client_SetAutoBattleLockID(data.monsterID)
        myself:Client_SetAutoBattle(true)
      end
    elseif Game.MapManager:IsInGVG() then
      ServiceNUserProxy.Instance:ReturnToHomeCity()
      FunctionChangeScene.Me():SetSceneLoadFinishActionForOnce(function()
        local cmdArgs, cmd = ReusableTable.CreateTable()
        cmdArgs.targetMapID = data.shortCutMapParam
        if data.tracePos then
          cmdArgs.targetPos = LuaGeometry.GetTempVector3(data.tracePos[1] or 0, data.tracePos[2] or 0, data.tracePos[3] or 0)
          cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandMove)
        else
          cmdArgs.npcID = data.monsterID
          cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandSkill)
        end
        myself:Client_SetMissionCommand(cmd)
        ReusableTable.DestroyAndClearTable(cmdArgs)
      end)
    else
      local cmdArgs, cmd = ReusableTable.CreateTable()
      cmdArgs.targetMapID = data.shortCutMapParam
      if data.tracePos then
        cmdArgs.targetPos = LuaGeometry.GetTempVector3(data.tracePos[1] or 0, data.tracePos[2] or 0, data.tracePos[3] or 0)
        cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandMove)
      else
        cmdArgs.npcID = data.monsterID
        cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandSkill)
      end
      myself:Client_SetMissionCommand(cmd)
      ReusableTable.DestroyAndClearTable(cmdArgs)
    end
    GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
  elseif gotoMode then
    GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
    if Game.MapManager:IsInGVG() then
      ServiceNUserProxy.Instance:ReturnToHomeCity()
      FunctionChangeScene.Me():SetSceneLoadFinishActionForOnce(function()
        FuncShortCutFunc.Me():CallByID(gotoMode, {
          itemid = self.itemStaticID
        })
      end)
    else
      FuncShortCutFunc.Me():CallByID(gotoMode, {
        itemid = self.itemStaticID
      })
    end
  end
  self:PassEvent(ItemEvent.GoTraceItem, self.data)
end

function GainWayTip:HandleClickItem(cellctl)
  local data = cellctl.data
  self.selectItemData = data
  if data.isOpen then
  else
    MsgManager.FloatMsgTableParam(nil, ZhString.GainWayTip_notOpen)
  end
end

function GainWayTip:SetData(itemStaticID, context)
  if itemStaticID then
    self.itemStaticID = itemStaticID
  end
  if self.itemStaticID then
    self.data = GainWayTipProxy.Instance:GetDataByStaticID(self.itemStaticID)
    if self.data then
      local t = self.data.datas
      for i = #t, 1, -1 do
        if not (t[i].name or t[i].icon) or not t[i].isOpen then
          table.remove(t, i)
        else
          t[i]:SetContext(context)
        end
      end
      self:SetListDatas(self.data.datas)
    end
  end
end

function GainWayTip:SetListDatas(datas)
  if not datas then
    return
  end
  self.contentList:ResetDatas(datas)
  self.contentScrollView:ResetPosition()
  self.noTip:SetActive(#datas == 0)
  self.gameObject:SetActive(true)
end

function GainWayTip:OnEnter()
end

function GainWayTip:OnExit()
  GainWayTipProxy.Instance.GainWayItemDataDic = {}
  GameObject.Destroy(self.gameObject)
  self:PassEvent(GainWayTip.CloseGainWay)
  return true
end

function GainWayTip:AddIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end

function GainWayTip:SetAnchorPos(isright)
  self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(isright and 0 or -490, 0, 0)
end

function GainWayTip:SetPivotOffset(offsetX, offsetY)
  local x, y, z = LuaGameObject.GetLocalPositionGO(self.gameObject)
  LuaGameObject.SetLocalPositionGO(self.gameObject, offsetX and x + offsetX or x, offsetY and y + offsetY or y, z)
end

function GainWayTip:SetLocalPos(x, y, z)
  LuaGameObject.SetLocalPositionGO(self.gameObject, x, y, z)
end
