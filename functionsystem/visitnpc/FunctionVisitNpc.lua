FunctionVisitNpc = class("FunctionVisitNpc")
AccessCustomType = {
  Quest = 1,
  Follow = 2,
  ReviveBySkill = 4,
  UseItem = 5,
  CatchPet = 6,
  UseSkill = 7,
  Furniture = 8,
  Warehouse = 9
}
AutoTriggerQuestMap = {
  [QuestDataType.QuestDataType_MAIN] = 1,
  [QuestDataType.QuestDataType_BRANCH] = 1,
  [QuestDataType.QuestDataType_WANTED] = 1,
  [QuestDataType.QUESTDATATYPE_SATISFACTION] = 1,
  [QuestDataType.QuestDataType_ELITE] = 1,
  [QuestDataType.QuestDataType_Raid_Talk] = 1,
  [QuestDataType.QuestDataType_CCRASTEHAM] = 1,
  [QuestDataType.QuestDataType_CHILD] = 1,
  [QuestDataType.QuestDataType_VERSION or "version"] = 1,
  [QuestDataType.QuestDataType_GUIDINGTASK or "guiding_task"] = 1,
  [QuestDataType.QuestDataType_BOTTLE or "bottle"] = 1,
  [QuestDataType.QuestDataType_ACC_MAIN] = 1,
  [QuestDataType.QuestDataType_ANCIENT_CITY_DAILY or "ancient_city_daily"] = 1
}
local tempV3 = LuaVector3()
local _tutorMatchStatus = TutorProxy.TutorMatchStatus

function FunctionVisitNpc.Me()
  if nil == FunctionVisitNpc.me then
    FunctionVisitNpc.me = FunctionVisitNpc.new()
  end
  return FunctionVisitNpc.me
end

function FunctionVisitNpc:ctor()
  self.visitRef = 0
  self.visitShowMap = {}
  self.directDoNpcFuncList = {}
end

function FunctionVisitNpc:GetTargetId()
  return self.targetId
end

function FunctionVisitNpc:GetTarget()
  if self.targetId then
    return SceneCreatureProxy.FindCreature(self.targetId)
  end
end

function FunctionVisitNpc.AccessGuildFlag(flagid, trans)
  if GameConfig.SystemForbid.GVG then
    return
  end
  if trans == nil then
    return
  end
  LuaVector3.Better_Set(tempV3, LuaGameObject.GetPosition(trans))
  local myPos = Game.Myself:GetPosition()
  local distance = LuaVector3.Distance_Square(tempV3, myPos)
  if 0.01 < distance then
    Game.Myself:Client_MoveTo(tempV3, nil, FunctionVisitNpc._AccessGuildFlag, self, flagid, 1)
  else
    FunctionVisitNpc.Me():_AccessGuildFlag(flagid)
  end
end

function FunctionVisitNpc:_AccessGuildFlag(flagid)
  local staticData = GvgProxy.GetStrongHoldStaticData(flagid)
  if not staticData then
    return
  end
  TipsView.Me():ShowGeneralHelp(staticData.Text, staticData.Name)
end

function FunctionVisitNpc:AccessCatchingPet(target)
  if self.canShowCatchPetMsg then
    self.canShowCatchPetMsg = false
    MsgManager.ShowMsgByIDTable(9016)
  end
  if self.cd_LT then
    self.cd_LT:Destroy()
    self.cd_LT = nil
  end
  self.cd_LT = TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
    self.canShowCatchPetMsg = true
  end, self)
end

function FunctionVisitNpc:RegisterVisitShow(npcguid, dialoglist, callback, callbackParam)
  local d = self.visitShowMap[npcguid]
  if not d then
    d = ReusableTable.CreateTable()
    d.npcguid = npcguid
    self.visitShowMap[npcguid] = d
  end
  d.dialoglist = dialoglist
  d.callback = callback
  d.callbackParam = callbackParam
end

function FunctionVisitNpc:UnRegisterVisitShow(npcguid)
  if not npcguid or not self.visitShowMap[npcguid] then
    return
  end
  ReusableTable.DestroyTable(self.visitShowMap[npcguid])
  self.visitShowMap[npcguid] = nil
end

function FunctionVisitNpc:AccessTarget(target, custom, customType)
  if nil == target then
    self.targetId = 0
    return
  end
  if customType == AccessCustomType.Furniture then
    HomeManager.Me():ArrivedAccessFurniture(target, custom)
    return
  end
  if customType == AccessCustomType.Warehouse then
    ServiceSceneUser3Proxy.Instance:CallWareHouseOperationCmd(EWAREHOUSEOPR.EWAREHOUSE_OPR_ENTER, target.data.id)
    return
  end
  self.targetId = target.data.id
  local visitShowData = self.visitShowMap[self.targetId]
  if visitShowData then
    GameFacade.Instance:sendNotification(VisitNpcEvent.AccessNpc, target)
    EventManager.Me():DispatchEvent(VisitNpcEvent.AccessNpc, target)
    if visitShowData.dialoglist then
      local viewdata = {
        viewname = "DialogView",
        dialoglist = visitShowData.dialoglist,
        npcinfo = target,
        callback = visitShowData.callback,
        callbackData = visitShowData.callbackParam
      }
      GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
    else
      visitShowData.callback(visitShowData.callbackParam)
    end
    return
  end
  local targetStaticID = 0
  if target.data and target.data.staticData then
    targetStaticID = target.data.staticData.id
  end
  local bossStepQuest = QuestProxy.Instance.worldbossQuest
  if targetStaticID == bossStepQuest.npcid then
    local dlist
    if bossStepQuest.dialog_select == 1 then
      dlist = bossStepQuest.yes_dialogs
    elseif bossStepQuest.dialog_select == 2 then
      dlist = bossStepQuest.no_dialogs
    end
    local viewdata = {
      viewname = "DialogView",
      dialoglist = dlist,
      npcinfo = target,
      callback = self.callNextBossStep
    }
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
    return
  end
  target = self:GetTarget()
  if not target then
    return
  end
  local handed, handowner = Game.Myself:IsHandInHand()
  if handed and not handowner then
    MsgManager.ShowMsgByIDTable(824)
    return
  end
  if Game.Myself:IsInBooth() then
    MsgManager.ShowMsgByID(25710)
    return
  end
  if target.data then
    local _PvpTeamRaid = DungeonProxy.Instance:GetConfigPvpTeamRaid()
    if Game.MapManager:IsPVPMode_TeamPws() then
      if target.data.IsElementNpc_Mid and target.data:IsElementNpc_Mid() then
        if not Game.Myself:GetTeamPwsBall() then
          MsgManager.ShowMsgByIDTable(25928)
          return
        end
        local elementSkillID = _PvpTeamRaid.BuffCollectSkillID
        Game.Myself:Client_UseSkill(elementSkillID, target, nil, nil, true)
        return
      end
      if target.data.IsElementNpc and target.data:IsElementNpc() then
        local elementSkillID = _PvpTeamRaid.ElementCollectSkillID
        Game.Myself:Client_UseSkill(elementSkillID, target, nil, nil, true)
        return
      end
    end
  end
  if custom then
    if not customType then
      errorLog("customType Is Nil")
      customType = AccessCustomType.Quest
    end
  else
    customType = nil
  end
  if customType == AccessCustomType.ReviveBySkill then
    if Game.MapManager:IsPVEMode_Roguelike() and not DungeonProxy.Instance:CheckRoguelikeCanRevive() then
      MsgManager.ShowMsgByID(25966)
      return
    end
    local msgID = target.data.id == BokiProxy.Instance:GetBokiGuid() and 41244 or 2513
    MsgManager.ConfirmMsgByID(msgID, function()
      Game.Myself:Client_UseSkill(custom, target, nil, nil, true)
    end, nil, nil, target.data.name)
    return
  elseif customType == AccessCustomType.UseItem then
    FunctionItemFunc.TryUseItem(custom, target)
    return
  elseif customType == AccessCustomType.CatchPet then
    ServiceScenePetProxy.Instance:CallCatchPetPetCmd(custom, false)
    return
  elseif customType == AccessCustomType.UseSkill then
    Game.Myself:Client_UseSkill(custom, target, nil, nil, true)
    return
  end
  if target:GetCreatureType() == Creature_Type.Npc then
    local npcData = target.data.staticData
    if GuildProxy.Instance:ForbiddenUniqueNpc(target.data.uniqueid) then
      return
    end
    if not npcData then
      return
    end
    local ntype = npcData.Type
    if ntype == NpcData.NpcDetailedType.SealNPC then
      FunctionRepairSeal.Me():AccessTarget(target)
      return
    end
    if ntype == NpcData.NpcDetailedType.FoodNpc then
      FunctionFood.Me():AccessFoodNpc(target)
      return
    end
    if ntype == NpcData.NpcDetailedType.PetNpc then
      return
    end
    if ntype == NpcData.NpcDetailedType.CatchNpc then
      return
    end
    if ntype == NpcData.NpcDetailedType.BFBuilding then
      local btype = BFBuildingProxy.GetBuildingType(target.data.staticData.id)
      local anim_status = BFBuildingProxy.Instance:GetBuildAnimStatus(target.data.id)
      if btype ~= BFBuildingProxy.Type.Weather and anim_status == EBUILDSTATUS.EBUILDSTATUS_OPER then
        return
      end
    end
    if customType == AccessCustomType.Quest then
      local questData = QuestProxy.Instance:getQuestDataByIdAndType(custom)
      if not questData then
        redlog("No QuestData !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!", tostring(custom))
        return
      end
      if QuestProxy.Instance.questDebug then
        self:TryCallVisitNpcUserCmd(target.data.id, questData)
        QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
        return
      end
      local questParama = questData.staticData.Params
      local npc = questParama.npc
      if type(npc) == "table" then
        npc = npc[1]
      end
      if npcData.id == npc then
        if self:TryCallVisitNpcUserCmd(target.data.id, questData) then
          self:ExcuteQuestEvent(target, questData)
        else
          MsgManager.ShowMsgByID(43345)
        end
        return
      end
    elseif customType == AccessCustomType.Follow then
      self:TryCallVisitNpcUserCmd(target.data.id)
      local triggerQuest, branchlsts = self:CheckNpcQuest(target, target.data.uniqueid)
      if self:HandleFollowTransfer(triggerQuest, branchlsts, custom) then
        return
      end
    end
    local triggerQuest, branchlsts = self:CheckNpcQuest(target, target.data.uniqueid)
    if triggerQuest then
      if self:TryCallVisitNpcUserCmd(target.data.id, triggerQuest) then
        self:ExcuteQuestEvent(target, triggerQuest)
      else
        MsgManager.ShowMsgByID(43345)
      end
    else
      local confirmConfig = GameConfig.VisitNpcConfirmMsg and GameConfig.VisitNpcConfirmMsg[target.data.staticData.id]
      if confirmConfig and not target.data:IsBoxOpened() then
        if confirmConfig.mapId and 0 < #confirmConfig.mapId then
          if 0 < TableUtility.ArrayFindIndex(confirmConfig.mapId, Game.MapManager:GetMapID()) then
            MsgManager.ConfirmMsgByID(confirmConfig.msgId, function()
              self:TryCallVisitNpcUserCmd(target.data.id)
            end)
          else
            self:TryCallVisitNpcUserCmd(target.data.id)
          end
        else
          MsgManager.ConfirmMsgByID(confirmConfig.msgId, function()
            self:TryCallVisitNpcUserCmd(target.data.id)
          end)
        end
      else
        self:TryCallVisitNpcUserCmd(target.data.id)
      end
      for _, trapId in pairs(GameConfig.TrapNpcID) do
        if npcData.id == trapId then
          return
        end
      end
      self:ExcuteDefaultDialog(target, branchlsts)
    end
    GameFacade.Instance:sendNotification(VisitNpcEvent.AccessNpc, target)
    EventManager.Me():DispatchEvent(VisitNpcEvent.AccessNpc, target)
  end
end

function FunctionVisitNpc:TryCallVisitNpcUserCmd(npcCharId, questData)
  if questData and questData.params and questData.params.is_single then
    if not QuestProxy.Instance:CheckVisitNpcAvailable(npcCharId, Game.Myself.data.id) then
      return false
    end
    ServiceQuestProxy.Instance:CallVisitNpcUserCmd(npcCharId, questData.staticData and questData.staticData.Params.is_single ~= nil)
  else
    ServiceQuestProxy.Instance:CallVisitNpcUserCmd(npcCharId)
  end
  return true
end

function FunctionVisitNpc._HelpDoFollowTransfer(quest, toMapId)
  local params = quest.staticData.Params
  if params.telePath then
    for i = 1, #params.telePath do
      if params.telePath[i][1] == toMapId then
        local optionid
        if params.telePath[i][2] and params.telePath[i][2] ~= 0 then
          optionid = params.telePath[i][2]
        end
        FunctionVisitNpc._DialogEndCall(quest.id, optionid, true, quest.scope)
        return true
      end
    end
  elseif params.teleMap then
    for i = 1, #params.teleMap do
      if params.teleMap[i] == toMapId then
        FunctionVisitNpc._DialogEndCall(quest.id, nil, true, quest.scope)
        return true
      end
    end
  end
  return false
end

function FunctionVisitNpc:HandleFollowTransfer(triggerQuest, branchlsts, followTargetMap)
  if not followTargetMap then
    return false
  end
  if followTargetMap == Game.MapManager:GetMapID() then
    return false
  end
  if not self.checkTime then
    self.checkTime = ServerTime.CurServerTime() / 1000
  elseif ServerTime.CurServerTime() / 1000 - self.checkTime < 0.5 then
    return false
  else
    self.checkTime = ServerTime.CurServerTime() / 1000
  end
  if triggerQuest and FunctionVisitNpc._HelpDoFollowTransfer(triggerQuest, followTargetMap) then
    return true
  end
  if branchlsts then
    for k = 1, #branchlsts do
      if FunctionVisitNpc._HelpDoFollowTransfer(branchlsts[k], followTargetMap) then
        return true
      end
    end
  end
  FunctionSystem.InterruptMyFollow()
  return false
end

function FunctionVisitNpc:HandleNpcTransfer(dstMap, npcUID)
  local targets = NSceneNpcProxy.Instance:FindNpcByUniqueId(npcUID)
  redlog("Npc传送 1-->", dstMap, npcUID)
  if 0 < #targets and targets[1] then
    local nowMap = Game.MapManager:GetMapID()
    local transInfo = NpcTransferTeleport[nowMap] and NpcTransferTeleport[nowMap][dstMap]
    local questID = transInfo and transInfo.questID
    if questID then
      if questID == "ERROR" then
      end
      redlog("Npc传送 2-->", questID, targets[1].data.id, questID, transInfo.SubGroup)
      ServiceQuestProxy.Instance:CallVisitNpcUserCmd(targets[1].data.id)
      QuestProxy.Instance:notifyQuestState("cityScope", questID, transInfo.SubGroup)
    end
  end
end

function FunctionVisitNpc:ExcuteQuestEvent(target, questData)
  if not questData.staticData then
    errorLog("QUEST ERROR ~!~")
    return
  end
  local isValid = false
  local params = questData.staticData.Params
  if params.uniqueid then
    isValid = target.data.uniqueid == params.uniqueid
  elseif type(params.npc) == "number" then
    isValid = target.data.staticData.id == params.npc
  elseif type(params.npc) == "table" then
    for _, npcid in pairs(params.npc) do
      if npcid == target.data.staticData.id then
        isValid = true
        break
      end
    end
  elseif params.monster == target.data.staticData.id then
    isValid = true
  elseif params.npcfunctionid then
    local npcFunc = target.data.staticData.NpcFunction
    if npcFunc then
      for i = 1, #npcFunc do
        local funcType = npcFunc[i].type
        if funcType == params.npcfunctionid then
          isValid = true
          break
        end
      end
    end
  end
  isValid = isValid and not QuestProxy.Instance:IsQuestInNotifyCD(questData.id)
  local stepType = questData.questDataStepType
  if isValid then
    if stepType == QuestDataStepType.QuestDataStepType_COLLECT then
      local collectSkillId = GameConfig.NewRole.riskskill[1]
      local skillid = questData.params.skillid
      if skillid then
        local validSkills = GameConfig.NewRole.collectskill
        if validSkills and TableUtility.ArrayFindIndex(validSkills, skillid) > 0 then
          collectSkillId = skillid
        end
      end
      Game.Myself:Client_UseSkill(collectSkillId, target, nil, nil, true)
    elseif stepType == QuestDataStepType.QuestDataStepType_VISIT then
      self:ExcuteDialogEvent(target, questData)
    elseif stepType == "stepvisit" then
      helplog("多次推进型visit")
      self:ExecuteStepVisitEvent(target, questData)
    end
  else
    helplog("Visit Npc is illegal")
  end
end

function FunctionVisitNpc._SortQuest(a, b)
  local aPriority, bPriority = 1, 1
  if a.type ~= b.type then
    if a.scope == QuestDataScopeType.QuestDataScopeType_FUBEN then
      aPriority = 1
    elseif a.type == QuestDataType.QuestDataType_MAIN then
      aPriority = 2
    elseif a.type == QuestDataType.QuestDataType_WANTED then
      aPriority = 3
    elseif a.type == QuestDataType.QuestDataType_BRANCH then
      aPriority = 4
    else
      aPriority = 5
    end
    if b.scope == QuestDataScopeType.QuestDataScopeType_FUBEN then
      bPriority = 1
    elseif b.type == QuestDataType.QuestDataType_MAIN then
      bPriority = 2
    elseif b.type == QuestDataType.QuestDataType_WANTED then
      bPriority = 3
    elseif b.type == QuestDataType.QuestDataType_BRANCH then
      bPriority = 4
    else
      bPriority = 5
    end
  end
  if aPriority ~= bPriority then
    return aPriority < bPriority
  end
  return a.id < b.id
end

function FunctionVisitNpc:CheckRaidValid(target, questData)
  local boxid = target.data:GetPushableObjID()
  if not boxid or boxid == 0 then
    return true
  end
  if questData.staticData.Params.boxid and questData.staticData.Params.boxid == boxid then
    return true
  else
    return false
  end
end

function FunctionVisitNpc:CheckNpcQuest(target, uniqueid)
  local triggerlsts, branchlsts = {}, {}
  local questlst = QuestProxy.Instance:getDialogQuestListByNpcId(target.data.staticData.id, uniqueid) or {}
  for i = 1, #questlst do
    local d = questlst[i]
    if (AutoTriggerQuestMap[d.type] or d.scope == QuestDataScopeType.QuestDataScopeType_FUBEN or d.scope == QuestDataScopeType.QuestDataScopeType_DAHUANG) and d.staticData.Params.ManualTrigger ~= 1 and self:CheckRaidValid(target, d) then
      table.insert(triggerlsts, d)
    end
    local autoFinishTag = d.staticData and d.staticData.Params and d.staticData.Params.ifAccessFc
    if (d.type == QuestDataType.QuestDataType_SMITHY or d.type == "abyss_daily") and autoFinishTag then
    else
      table.insert(branchlsts, d)
    end
  end
  local triggerQuest
  if #triggerlsts == 1 then
    triggerQuest = triggerlsts[1]
  elseif Game.MapManager:IsRaidPuzzle() then
    triggerQuest = triggerlsts[#triggerlsts]
  else
    local collectlst = QuestProxy.Instance:getCollectQuestListByNpcId(target.data.staticData.id)
    triggerQuest = collectlst and collectlst[1]
  end
  table.sort(branchlsts, FunctionVisitNpc._SortQuest)
  return triggerQuest, branchlsts
end

function FunctionVisitNpc._DialogEndCall(questId, optionid, isSuccess, scope)
  if isSuccess and questId then
    LogUtility.Info(string.format("NotifyQuestState: questId:%s optionId:%s ", tostring(questId), tostring(optionid)))
    QuestProxy.Instance:notifyQuestState(scope, questId, optionid)
  end
end

local SpecialQuestType = {
  [QuestDataType.QuestDataType_WANTED] = 1,
  [QuestDataType.QuestDataType_VERSION or "version"] = 1,
  [QuestDataType.QuestDataType_SMITHY or "smithy"] = 1,
  abyss_daily = 1
}

function FunctionVisitNpc:ExcuteDialogEvent(target, questData)
  local questParama = questData.staticData.Params
  local ifAccessFc = questParama.ifAccessFc
  local questId = questData.id
  if ifAccessFc then
    if SpecialQuestType[questData.type] then
    else
      QuestProxy.Instance:notifyQuestState(questData.scope, questData.id)
    end
    self:ExcuteDefaultDialog(target)
    return
  end
  local dialoglist = questParama.dialog or {}
  local viewName = questParama.isExtendDialog == 1 and "ExtendDialogView" or "DialogView"
  if questParama.only_captain and not TeamProxy.Instance:CheckIHaveLeaderAuthority() then
    self:ExcuteDefaultDialog(target)
    return
  end
  local viewdata = {
    viewname = viewName,
    dialoglist = dialoglist,
    dialognpcs = questParama.npc,
    npcinfo = target,
    camera = questParama.camera,
    wait = questParama.finish_wait,
    questId = questId,
    turnToMe = questParama.turntome,
    callback = FunctionVisitNpc._DialogEndCall,
    callbackData = questId,
    questScope = questData.scope,
    showPurikura = questData.params.showpurikura,
    forceNotify = false,
    keepOpen = questParama.keepOpen == 1,
    noFocus = questParama.noFocus or questParama.isExtendDialog == 1,
    isExtendDialog = questParama.isExtendDialog == 1
  }
  local profession = questParama.profession
  if profession then
    if dialoglist and 0 < #dialoglist then
      local commonDialogList = {}
      for i = 1, #dialoglist do
        local dialogData = DialogUtil.GetDialogData(dialoglist[i])
        local optionStr = dialogData and dialogData.Option
        if not dialogData.SubViewId then
          if optionStr and optionStr ~= "" then
            local optionConfig = StringUtil.AnalyzeDialogOptionConfig(OverSea.LangManager.Instance():GetLangByKey(optionStr))
            if optionConfig and 0 < #optionConfig then
              for j = 1, #optionConfig do
                if optionConfig[j].id and optionConfig[j].id == 0 then
                  table.insert(commonDialogList, dialoglist[i])
                  break
                end
              end
            else
              table.insert(commonDialogList, dialoglist[i])
            end
          else
            table.insert(commonDialogList, dialoglist[i])
          end
        end
      end
      viewdata.dialoglist = commonDialogList
    end
    
    function viewdata.callback()
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.TransferProfessionPreviewView,
        viewdata = {
          questData = questData,
          classid = profession,
          isNpcFuncView = true,
          npc = target
        }
      })
    end
  end
  if type(viewdata.dialoglist) == "table" and #viewdata.dialoglist == 0 then
    FunctionVisitNpc._DialogEndCall(questId, nil, true, questData.scope)
    GameFacade.Instance:sendNotification(DialogEvent.CloseDialog)
  else
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
  end
end

function FunctionVisitNpc:ExecuteStepVisitEvent(target, questData)
  local dialoglist = questData.params.dialog or {}
  if questData.params.nospeakframe then
    local dialogID = dialoglist[1]
    local dialogData = DialogUtil.GetDialogData(dialogID)
    if dialogData then
      local text = dialogData.Text or ""
      target:GetSceneUI().roleTopUI:Speak(text)
    else
      redlog("DialogID" .. dialogID .. "有错误")
    end
  else
    local tempList = {}
    table.insert(tempList, dialoglist[1])
    local viewdata = {
      viewname = "DialogView",
      dialoglist = tempList,
      questId = questData.id,
      questScope = questData.scope,
      camera = questData.staticData.Params.camera
    }
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
  end
  QuestProxy.Instance:updateStepVisitQuestData(questData.id)
  if #dialoglist == 0 then
    helplog("推进任务")
    FunctionVisitNpc._DialogEndCall(questData.id, nil, true, questData.scope)
  end
end

function FunctionVisitNpc:ExcuteDefaultDialog(target, events)
  target = target or self:GetTarget()
  if target then
    local npcData = target.data.staticData
    local npcfunc = npcData.NpcFunction
    local musicNpcConfig = GameConfig.System.musicboxnpc
    if npcData.id == musicNpcConfig or musicNpcConfig[npcData.id] then
      GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
        viewname = "SoundBoxView",
        npcInfo = target,
        viewdata = {isNpcFuncView = true}
      })
      return
    elseif npcData.id == 1200 then
      FunctionVisitNpc.VisitEndLessTower(target, events)
      return
    elseif HeadwearRaidProxy.Instance:IsHeadwearRaidTower(npcData.id) then
      FunctionVisitNpc.VisitHeadwearRaidTower(target, events)
      return
    elseif npcfunc then
      for i = 1, #npcfunc do
        local single = npcfunc[i]
        if single.type then
          local funcCfg = Table_NpcFunction and Table_NpcFunction[single.type]
          if funcCfg and funcCfg.Type then
            local configFunc = FunctionVisitNpc.SNpcFuncMap[funcCfg.Type]
            if configFunc and configFunc(npcfunc, target, events) then
              return
            elseif TableUtility.ArrayFindIndex(self.directDoNpcFuncList, funcCfg.id) > 0 then
              configFunc = FunctionVisitNpc.SNpcFuncMap.DirectDoNpcFunc
              if configFunc and configFunc(npcfunc, target, events) then
                return
              end
            end
          end
        end
      end
    end
    local defaultDialog = FunctionVisitNpc.GetDefaultDialog(target)
    if npcData.DefaultDialog == nil then
      return
    end
    local needRequireNpcFunc = npcData.NeedRequireNpcFunction
    if needRequireNpcFunc and needRequireNpcFunc == 1 then
      ServiceNUserProxy.Instance:CallRequireNpcFuncUserCmd(npcData.id)
    end
    local viewdata = {
      viewname = "DialogView",
      tasks = events,
      npcinfo = target,
      defaultDialog = defaultDialog,
      showPurikura = 2
    }
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
  else
    printRed("找不到该Npc 或者 该Npc不在配置表之内")
  end
end

function FunctionVisitNpc.GetDefaultDialog(npc)
  if npc == nil then
    return
  end
  local npcData = npc.data.staticData
  local npc_static_id = npcData.id
  local activity_defaultDlg = Activity_NpcDefaultDialog
  if activity_defaultDlg ~= nil then
    local cfg = activity_defaultDlg[npc_static_id]
    if cfg then
      local choose_did, closeest_time
      for aid, dialogid in pairs(cfg) do
        local adata = FunctionActivity.Me():GetActivityData(aid)
        if adata ~= nil then
          if closeest_time == nil then
            closeest_time = adata.starttime
            choose_did = dialogid
          elseif closeest_time < adata.starttime then
            closeest_time = adata.starttime
            choose_did = dialogid
          end
        end
      end
      if choose_did ~= nil then
        return choose_did
      end
    end
  end
  local gameconfig_wedding = GameConfig.Wedding
  if gameconfig_wedding then
    local engage_Npc = gameconfig_wedding and gameconfig_wedding.Engage_Npc
    local weddingCememony_ID = gameconfig_wedding and gameconfig_wedding.Cememony_Npc
    if npc_static_id == weddingCememony_ID then
      if WeddingProxy.Instance:IsSelfInWeddingTime() then
        return gameconfig_wedding.Cememony_Dialog
      end
    elseif npc_static_id == engage_Npc then
      if WeddingProxy.Instance:IsSelfMarried() then
        return gameconfig_wedding.married
      elseif WeddingProxy.Instance:IsSelfEngage() then
        return gameconfig_wedding.engaged
      elseif WeddingProxy.Instance:IsSelfSingle() then
        return gameconfig_wedding.single
      end
    end
  end
  local specialDefaultDialog_class1 = npcData.DefaultDialog_class1
  if specialDefaultDialog_class1 then
    local myClass = MyselfProxy.Instance:GetMyProfession()
    local Race = Table_Class[myClass].Race
    if Race == 2 then
      return npcData.DefaultDialog_class1
    end
  end
  local gameconfig_dressing = GameConfig.DressingFilter
  if gameconfig_dressing and gameconfig_dressing.DressingNpcID and npc_static_id == gameconfig_dressing.DressingNpcID then
    local var = Game.Myself.data.userdata:Get(UDEnum.PROFESSION) % 10
    if var < 4 then
      return gameconfig_dressing.DialogID1
    elseif var == 4 then
      return gameconfig_dressing.DialogID2
    else
      return gameconfig_dressing.DialogID3
    end
  end
  if npc_static_id == GameConfig.GVGConfig.StatuePedestalNpcID and GvgProxy.Instance:GetStatueInfo() == nil then
    return GameConfig.GVGConfig.EmptyStatueDialogID or 396137
  end
  if GameConfig.GVGConfig.GvgStatue and GameConfig.GVGConfig.GvgStatue.StatuePedestalNpcID == npc_static_id then
    local statue_city_id = GvgProxy.GetStatueCity(npc.data.uniqueid)
    if statue_city_id and GvgProxy.Instance:CheckMyGroupCityStatueEmpty(statue_city_id) then
      return GameConfig.GVGConfig.GvgStatue.EmptyStatueDialogID or 396860
    end
  end
  local stype = PvpProxy.Instance:GetStatueType(npcData.id)
  if stype then
    local PvpStatueConfig = GameConfig.PvpStatue
    if not PvpProxy.Instance:GetStatueInfo(stype) then
      return PvpStatueConfig and PvpStatueConfig.DefaultDialog[stype]
    end
  end
  return npcData.DefaultDialog
end

autoImport("EndLessTowerCountDownInfo")

function FunctionVisitNpc.VisitEndLessTower(target, events)
  ServiceUserEventProxy.Instance:CallQueryResetTimeEventCmd(AERewardType.Tower)
  local midShowFuncParam
  local hideFunc = function(gameObject)
    midShowFuncParam:OnExit()
  end
  local midShowFunc = function(gameObject)
    local top = Game.GameObjectUtil:DeepFind(gameObject, "Anchor_Top")
    midShowFuncParam = EndLessTowerCountDownInfo.new(top)
    midShowFuncParam:CreateSelf()
    midShowFuncParam:OnEnter()
    return hideFunc
  end
  local viewdata = {
    viewname = "DialogView",
    tasks = events,
    npcinfo = target,
    midShowFunc = midShowFunc,
    midShowFuncParam = midShowFuncParam
  }
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
  GameFacade.Instance:sendNotification(DialogEvent.AddUpdateSetTextCall, {
    FunctionVisitNpc.UpdateEndlessTowerDefaultDialog,
    target
  })
end

function FunctionVisitNpc.VisitHeadwearRaidTower(target, events)
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
    viewname = "HeadwearRaidTowerUpgradeView",
    npcdata = target
  })
end

function FunctionVisitNpc:AddVisitRef()
  self.visitRef = self.visitRef + 1
  if self.visitRef == 1 then
    self:PreVisit()
  end
end

function FunctionVisitNpc:RemoveVisitRef(sync_scene)
  self.visitRef = self.visitRef - 1
  if self.visitRef <= 0 then
    self:EndVisit(sync_scene)
    self.visitRef = 0
  end
end

function FunctionVisitNpc:AddDirectDoNpcFuncList(npcfunctionid)
  if TableUtility.ArrayFindIndex(self.directDoNpcFuncList, npcfunctionid) == 0 then
    table.insert(self.directDoNpcFuncList, npcfunctionid)
  end
end

function FunctionVisitNpc:RemoveDirectDoNpcFuncList(npcfunctionid)
  TableUtility.ArrayRemove(self.directDoNpcFuncList, npcfunctionid)
end

function FunctionVisitNpc:PreVisit()
  Game.Myself:Client_PauseIdleAI()
  FunctionSystem.WeakInterruptMyself(true)
  local lnpc = self:GetTarget()
  if lnpc == nil and HomeManager.Me():IsAtHome() then
    Game.Myself:GetLockTarget()
  end
  if lnpc and lnpc.data and lnpc.data.staticData then
    local patrolAI = lnpc.ai.idleAI_Patrol
    if lnpc:CheckIsVeer() == 1 and (patrolAI == nil or patrolAI.interact == nil) then
      self:NpcTurnToMe(lnpc)
    end
    if patrolAI ~= nil then
      patrolAI:SetEnable(false, lnpc)
    end
    local visitVocal = lnpc.data.staticData.VisitVocal
    if visitVocal ~= "" then
      FunctionPlotCmd.Me():PlayNpcVisitVocal(visitVocal)
    end
    local sceneUI = lnpc:GetSceneUI()
    if sceneUI then
      sceneUI.roleTopUI:ActiveQuestSymbolEffect(false)
    end
    if lnpc.data.staticData.id == 2160 then
      ServiceSessionSocialityProxy.Instance:CallOperateQuerySocialCmd(SessionSociality_pb.EOperateType_Summer)
      ServiceSessionSocialityProxy.Instance:CallOperateQuerySocialCmd(SessionSociality_pb.EOperateType_Autumn)
      ServiceSessionSocialityProxy.Instance:CallOperateQuerySocialCmd(SessionSociality_pb.EOperateType_Charge)
      ServiceSessionSocialityProxy.Instance:CallOperateQuerySocialCmd(SessionSociality_pb.EOperateType_CodeBW)
      ServiceSessionSocialityProxy.Instance:CallOperateQuerySocialCmd(SessionSociality_pb.EOperateType_CodeMX)
      ServiceSessionSocialityProxy.Instance:CallOperateQuerySocialCmd(SessionSociality_pb.EOperateType_MonthCard)
      ServiceSessionSocialityProxy.Instance:CallOperateQuerySocialCmd(SessionSociality_pb.EOperateType_OpenServer)
      ServiceSessionSocialityProxy.Instance:CallOperateQuerySocialCmd(SessionSociality_pb.EOperateType_WeiJingOpenServer)
    elseif lnpc.data.staticData.id == 2186 then
      local activityData = FunctionActivity.Me():GetActivityData(ACTIVITYTYPE.EACTIVITYTYPE_READBAG)
      if activityData then
        ServiceSessionSocialityProxy.Instance:CallOperateQuerySocialCmd(SessionSociality_pb.EOperateType_RedBag)
      end
    elseif lnpc.data.staticData.id == 4285 then
      ServiceSessionSocialityProxy.Instance:CallOperateQuerySocialCmd(SessionSociality_pb.EOperateType_Phone)
    elseif lnpc.data.staticData.id == 600003 or lnpc.data.staticData.id == 600032 or lnpc.data.staticData.id == 600033 then
      ServiceSessionSocialityProxy.Instance:CallOperateQuerySocialCmd(SessionSociality_pb.EOperateType_MonthCard)
    elseif lnpc.data.staticData.id == 807074 then
      ServiceNUserProxy.Instance:CallFastTransGemQueryUserCmd()
    end
  end
end

function FunctionVisitNpc:EndVisit(sync_scene)
  Game.Myself:Client_ResumeIdleAI()
  ServiceQuestProxy.Instance:CallLeaveVisitNpcQuestCmd(sync_scene)
  local lnpc = self:GetTarget()
  if lnpc == nil and HomeManager.Me():IsAtHome() then
    Game.Myself:GetLockTarget()
  end
  if lnpc and lnpc.data and lnpc.data.staticData then
    local patrolAI = lnpc.ai.idleAI_Patrol
    if patrolAI ~= nil then
      patrolAI:SetEnable(true, lnpc)
    else
      self:NpcTurnBack(lnpc)
    end
    local endVocal = lnpc.data.staticData.EndVocal
    if endVocal ~= "" then
      FunctionPlotCmd.Me():PlayNpcVisitVocal(endVocal)
    end
    local sceneUI = lnpc:GetSceneUI()
    if sceneUI then
      sceneUI.roleTopUI:ActiveQuestSymbolEffect(true)
    end
  end
  self:AccessTarget(nil)
  GameFacade.Instance:sendNotification(VisitNpcEvent.AccessNpcEnd, lnpc)
  EventManager.Me():DispatchEvent(VisitNpcEvent.AccessNpcEnd, lnpc)
end

function FunctionVisitNpc:NpcTurnToMe(lnpc)
  if lnpc then
    lnpc:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.LookAtCreature, Game.Myself.data.id)
    Game.Myself:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.LookAtCreature, lnpc.data.id)
  end
end

function FunctionVisitNpc:NpcTurnBack(lnpc)
  if lnpc == nil then
    return
  end
  local F_StayVisit = lnpc.data.GetFeature_StayVisitRot
  if F_StayVisit and F_StayVisit(lnpc.data) then
    return
  end
  local originalRotY = lnpc.originalRotation
  lnpc:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, originalRotY)
end

function FunctionVisitNpc.openWantedQuestPanel(wantedid, target, isNewKanBan)
  local isInWantedQuestActivity = QuestProxy.Instance:isInWantedQuestInActivity()
  if isInWantedQuestActivity then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.AnnounceQuestActivityPanel,
      viewdata = {
        wanted = wantedid,
        npcTarget = target,
        isNpcFuncView = true
      }
    })
  elseif isNewKanBan then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.AnnounceQuestPanelNew,
      viewdata = {
        wanted = wantedid,
        npcTarget = target,
        isNpcFuncView = true
      }
    })
  else
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.AnnounceQuestPanel,
      viewdata = {
        wanted = wantedid,
        npcTarget = target,
        isNpcFuncView = true
      }
    })
  end
end

FunctionVisitNpc.SNpcFuncMap = {}

function FunctionVisitNpc.SNpcFuncMap.seal(npcfunction, target)
  local funcID = 0
  for i = 1, #npcfunction do
    local type = npcfunction[i].type
    local funcData = type and Table_NpcFunction[type]
    if funcData.NameEn == "seal" then
      funcID = type
    end
  end
  if FunctionUnLockFunc.Me():CheckCanOpenByPanelId(funcID) then
    local viewdata = {
      viewname = "DialogView",
      dialoglist = {5},
      npcinfo = target,
      addconfig = npcfunction
    }
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
    return true
  end
  return false
end

function FunctionVisitNpc.SNpcFuncMap.Raid(npcfunction, target)
  local canOpen = FunctionUnLockFunc.Me():CheckCanOpenByPanelId(PanelConfig.RaidInfoPopUp.id)
  if canOpen then
    local single = npcfunction[1]
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.RaidInfoPopUp,
      viewdata = {
        raidid = single.param
      }
    })
    return true
  end
  return false
end

function FunctionVisitNpc.SNpcFuncMap.wanted(npcfunction, target)
  local canOpen = FunctionUnLockFunc.Me():CheckCanOpenByPanelId(PanelConfig.AnnounceQuestPanel.id)
  if canOpen then
    local wantedid = npcfunction[1] and npcfunction[1].param
    NewLookBoardProxy.Instance:SetOpenNewPanel(false)
    FunctionVisitNpc.openWantedQuestPanel(wantedid, target, false)
  else
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, {viewname = "DialogView", npcinfo = target})
  end
  return true
end

function FunctionVisitNpc.SNpcFuncMap.newwanted(npcfunction, target)
  local npcfunc = npcfunction[1] and npcfunction[1].type
  npcfunc = npcfunc and Table_NpcFunction and Table_NpcFunction[npcfunc]
  local menuLock = npcfunc and npcfunc.Parama and npcfunc.Parama.menu
  menuLock = menuLock and not FunctionUnLockFunc.Me():CheckCanOpen(menuLock)
  if not menuLock then
    FunctionVisitNpc.openWantedQuestPanel(wantedid, target, true)
  else
    MsgManager.ShowMsgByIDTable(npcfunc.Parama.msgID or 0)
  end
  return true
end

function FunctionVisitNpc.SNpcFuncMap.PhotoStand(npcfunction, target)
  local npcfunc = npcfunction[1] and npcfunction[1].type
  npcfunc = npcfunc and Table_NpcFunction and Table_NpcFunction[npcfunc]
  local menuLock = npcfunc and npcfunc.Parama and npcfunc.Parama.menu
  menuLock = menuLock and not FunctionUnLockFunc.Me():CheckCanOpen(menuLock)
  if not menuLock then
    if not FunctionPhotoStand.Me().isRunning then
      MsgManager.FloatMsgTableParam(nil, ZhString.DisneyOverview_Time_OpenLater)
    elseif not FunctionPhotoStand.Me().slide_info or not next(FunctionPhotoStand.Me().slide_info) then
      MsgManager.FloatMsgTableParam(nil, ZhString.PhotoStand_Prompt_NoList)
    else
      local slide_info = FunctionPhotoStand.Me().slide_info[target.data.staticData.id]
      local slide_list = PhotoStandProxy.Instance.slideList[target.data.staticData.id]
      if not (slide_info and slide_list and slide_list.sum) or slide_list.sum <= 0 then
        MsgManager.FloatMsgTableParam(nil, ZhString.PhotoStand_Prompt_NoList4Npc)
      else
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.PhotoStandPanel,
          viewdata = {npcTarget = target, isNpcFuncView = true}
        })
      end
    end
  else
    MsgManager.ShowMsgByIDTable(npcfunc.Parama.msgID or 0)
  end
  return true
end

function FunctionVisitNpc.SNpcFuncMap.GuildBuildingSubmit(npcfunction, target)
  local typeID = npcfunction[1] and npcfunction[1].param
  if typeID then
    local buildingData = GuildBuildingProxy.Instance:GetCurBuilding(typeID)
    if buildingData then
      if buildingData.isbuilding and 0 == buildingData.level then
        GuildBuildingProxy.Instance:InitBuilding(target, typeID)
        GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
          viewname = "GuildBuildingMatSubmitView",
          npcinfo = target
        })
        return true
      else
        return false
      end
    else
      return false
    end
  end
end

function FunctionVisitNpc.SNpcFuncMap.Guild(npcfunction, target)
  local triggerQuest, branchlsts = FunctionVisitNpc.Me():CheckNpcQuest(target, target.data.uniqueid)
  FunctionGuild.Me():ShowGuildDialog(target, branchlsts)
  return true
end

function FunctionVisitNpc.SNpcFuncMap.Common_GuildRaid(npcfunction, target)
  FunctionGuild.Me():ShowGuildRaidDialog(target)
  return true
end

function FunctionVisitNpc.SNpcFuncMap.ShakeTree(npcfunction, target)
  FunctionShakeTree.Me():TryShakeTree(target)
  return true
end

function FunctionVisitNpc.SNpcFuncMap.ChangeLine(npcfunction, target)
  local dialogID = npcfunction[1].param or 1312545
  ServiceNUserProxy.Instance:CallQueryZoneStatusUserCmd()
  local ChangeLine = {
    event = function(npcinfo)
      FunctionNpcFunc.JumpPanel(PanelConfig.ChangeZoneView, npcinfo)
    end,
    closeDialog = true,
    NameZh = ZhString.ChangeZone_ChangeLine
  }
  local BackGuildLine = {
    event = function(npcinfo)
      if GuildProxy.Instance:IHaveGuild() then
        local zoneid = GuildProxy.Instance.myGuildData.zoneid
        ServiceNUserProxy.Instance:CallJumpZoneUserCmd(npcinfo.data.id, zoneid)
      end
    end,
    closeDialog = true,
    NameZh = ZhString.ChangeZone_BackGuildLine
  }
  local viewdata = {
    viewname = "DialogView",
    dialoglist = {dialogID},
    npcinfo = target,
    addfunc = {ChangeLine}
  }
  if GuildProxy.Instance:IHaveGuild() and MyselfProxy.Instance:GetZoneId() ~= GuildProxy.Instance.myGuildData.zoneid then
    viewdata.addfunc[#viewdata.addfunc + 1] = BackGuildLine
  end
  FunctionNpcFunc.ShowUI(viewdata)
  return true
end

function FunctionVisitNpc.SNpcFuncMap.EquipReplace(npcfunction, target)
  FunctionSecurity.Me():HoleEquip(function()
    FunctionDialogEvent.SetDialogEventEnter(DialogEventType.EquipReplace, target)
  end)
  return true
end

function FunctionVisitNpc.UpdateAuctionDialog(npcid)
  local time = AuctionProxy.Instance:GetAuctionTime() or 0
  local nowtime = ServerTime.CurServerTime() / 1000
  if time < nowtime then
    local npcData = Table_Npc[npcid]
    local defaultDialogId = npcData.DefaultDialog or 417
    return true, DialogUtil.GetDialogData(defaultDialogId).Text
  end
  local timeInfo = os.date("*t", time)
  local nowInfo = os.date("*t", nowtime)
  local openText = ""
  local count = 0
  if timeInfo.month > nowInfo.month then
    count = count + 1
    openText = timeInfo.month .. ZhString.FunctionVisitNpc_AuctionDialog_Month
  end
  count = count + 1
  openText = openText .. timeInfo.day .. ZhString.FunctionVisitNpc_AuctionDialog_Day
  if count < 2 then
    openText = openText .. timeInfo.hour .. ZhString.FunctionVisitNpc_AuctionDialog_Hour
  end
  return false, string.format(ZhString.FunctionVisitNpc_AuctionDialog_OpenTip, openText)
end

function FunctionVisitNpc.SNpcFuncMap.Auction(npcfunction, target, events)
  for k, v in pairs(npcfunction) do
    helplog(k, v)
  end
  local viewdata = {
    viewname = "DialogView",
    tasks = events,
    npcinfo = target
  }
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
  GameFacade.Instance:sendNotification(DialogEvent.AddUpdateSetTextCall, {
    FunctionVisitNpc.UpdateAuctionDialog,
    target.data.staticData.id
  })
  return true
end

function FunctionVisitNpc:callNextBossStep()
  local bossStepQuest = QuestProxy.Instance.worldbossQuest
  if bossStepQuest.dialog_select and bossStepQuest.dialog_select == 1 then
    ServiceBossCmdProxy.Instance:CallStepSyncBossCmd(nil)
  end
  return
end

function FunctionVisitNpc.SNpcFuncMap.FastClassChange(npcfunction, target, events)
  local professionid = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
  if professionid == 1 or professionid == 150 or professionid % 10 == 1 then
    redlog("未满足转职条件")
    local viewdata = {
      viewname = "DialogView",
      tasks = events,
      npcinfo = target,
      dialoglist = {550602}
    }
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
    return true
  end
end

function FunctionVisitNpc.SNpcFuncMap.Roguelike(npcfunc, target, events)
  local raid = DungeonProxy.Instance.roguelikeRaid
  local map = raid and raid.npcVisitorMap
  if type(map) == "table" and Game.MapManager:IsPVEMode_Roguelike() then
    local visitor = map[target.data.id]
    if visitor then
      MsgManager.ShowMsgByID(40715, visitor)
      return true
    end
  end
end

function FunctionVisitNpc.SNpcFuncMap.RoguelikeScoreModel(npcfunc, target, events)
  if Game.MapManager:IsPVEMode_Roguelike() then
    if not TeamProxy.Instance:CheckIHaveLeaderAuthority() then
      MsgManager.ShowMsgByID(40738)
      return true
    end
    if DungeonProxy.Instance.isRoguelikeScoreMode then
      MsgManager.ShowMsgByID(40736)
      return true
    end
  end
end

function FunctionVisitNpc.SNpcFuncMap.BFBuilding(npcfunction, target, events)
  local unlockMenu = BFBuildingProxy.GetBuildingUnlockMenu(target.data.staticData.id)
  if not FunctionUnLockFunc.Me():CheckCanOpen(unlockMenu) then
    local msg = Table_Menu[unlockMenu] and Table_Menu[unlockMenu].sysMsg and Table_Menu[unlockMenu].sysMsg.id
    MsgManager.ShowMsgByID(msg or 66)
    return false
  end
  local viewdata = {
    viewname = "BFBuildingPanel",
    tasks = events,
    npcinfo = target
  }
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
  return true
end

function FunctionVisitNpc.SNpcFuncMap.QuestionAnswer(npcfunction, target, events)
  ServiceMapProxy.Instance:CallUserSecretQueryMapCmd()
  return false
end

function FunctionVisitNpc.SNpcFuncMap.PurifyStake(npcfunction, target, events)
  FunctionDialogEvent.SetDialogEventEnter("Func_NightmareDialogStart", npc)
  return true
end

function FunctionVisitNpc.SNpcFuncMap.CatLitterBox(npcfunction, target, events)
  FunctionDialogEvent.SetDialogEventEnter("Func_CatLitterBox", target)
  return true
end

function FunctionVisitNpc.SNpcFuncMap.EditDefaultDialog(npcfunction, target, events)
  local viewdata = {
    viewname = "DialogView",
    tasks = events,
    npcinfo = target
  }
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
  GameFacade.Instance:sendNotification(DialogEvent.AddUpdateSetTextCall, {
    FunctionVisitNpc.UpdateNpcEditDefaultDialog,
    target
  })
  return true
end

function FunctionVisitNpc.SNpcFuncMap.DirectDoNpcFunc(npcfunction, target, events)
  local single, staticData
  for i = 1, #npcfunction do
    single = npcfunction[i]
    staticData = Table_NpcFunction[single.type]
    if staticData and FunctionNpcFunc.Me():CheckFuncState(staticData.NameEn, target, single.param, single.type) == NpcFuncState.Active then
      FunctionNpcFunc.Me():DoNpcFunc(staticData, target, single.param)
    end
  end
  return true
end

function FunctionVisitNpc.UpdateNpcEditDefaultDialog(target)
  local defaultDialog = target.data.userdata:GetBytes(UDEnum.NPC_DIALOG)
  if defaultDialog ~= nil and defaultDialog ~= "" then
    return false, defaultDialog
  elseif Table_Npc[target.data.staticData.id] then
    local npcData = Table_Npc[target.data.staticData.id]
    local defaultDialogId = npcData.DefaultDialog
    return true, DialogUtil.GetDialogData(defaultDialogId).Text
  end
end

function FunctionVisitNpc.SNpcFuncMap.PersonalEndlessTower(npcfunction, target, events)
  local viewdata = {
    viewname = "DialogView",
    tasks = events,
    npcinfo = target
  }
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
  GameFacade.Instance:sendNotification(DialogEvent.AddUpdateSetTextCall, {
    FunctionVisitNpc.UpdatPersonalEndlessTowerDefaultDialog,
    target
  })
  return true
end

function FunctionVisitNpc.UpdatPersonalEndlessTowerDefaultDialog(target)
  local maxLayer = GameConfig.endlessPrivate.MaxLevel or 100
  local layer = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_ENDLESS_PRIVATE_LAYER) or 0
  if maxLayer <= layer then
    local npcData = Table_Npc[target.data.staticData.id]
    local defaultDialogId = npcData.DefaultDialog
    return false, DialogUtil.GetDialogData(defaultDialogId).Text
  elseif Table_Npc[target.data.staticData.id] then
    local defaultDialogId = 483458
    return true, DialogUtil.GetDialogData(defaultDialogId).Text
  end
end

function FunctionVisitNpc.UpdateEndlessTowerDefaultDialog(target)
  local adata = FunctionActivity.Me():GetActivityData(1017)
  if adata ~= nil then
    local activityDialogId = 164323
    local str = DialogUtil.GetDialogData(activityDialogId).Text
    local activityStart = adata.whole_starttime
    local activityEnd = adata.whole_endtime
    local startTime = os.date("%Y-%m-%d %H:%M:%S", activityStart)
    local endTime = os.date("%Y-%m-%d %H:%M:%S", activityEnd)
    str = string.format(str, startTime, endTime)
    return true, str
  else
    local npcData = Table_Npc[target.data.staticData.id]
    if npcData then
      local defaultDialogId = npcData.DefaultDialog
      return false, DialogUtil.GetDialogData(defaultDialogId).Text
    end
  end
end

function FunctionVisitNpc.SNpcFuncMap.ReturnPlayerRaidReward(npcfunc, target, events)
  FunctionDialogEvent.SetDialogEventEnter("Func_ReturnActivityReward", target)
  return true
end

function FunctionVisitNpc.SNpcFuncMap.OpenSandTable(npcfunction, target, events)
  local viewdata = {
    viewname = "DialogView",
    tasks = events,
    npcinfo = target
  }
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
  GameFacade.Instance:sendNotification(DialogEvent.AddUpdateSetTextCall, {
    FunctionVisitNpc.UpdateSandTableDefaultDialog,
    target
  })
  return true
end

function FunctionVisitNpc.UpdateSandTableDefaultDialog(target)
  local b = GvgProxy.Instance:GetGvgOpenFireState()
  if not b then
    local sysmsg = Table_Sysmsg[40003]
    if sysmsg then
      local str = sysmsg.Text
      target:GetSceneUI().roleTopUI:Speak(str)
      return true, str
    end
  else
    local npcData = Table_Npc[target.data.staticData.id]
    if npcData then
      local defaultDialogId = npcData.DefaultDialog
      return false, DialogUtil.GetDialogData(defaultDialogId).Text
    end
  end
end

function FunctionVisitNpc.SNpcFuncMap.firework(npcfunction, target, events)
  local ownerid = target and target.data and target.data.ownerID
  local isMyFirework = ownerid and ownerid == Game.Myself.data.id
  local dialog = DialogUtil.GetDialogData(171987)
  local dialogStr = dialog.Text or "...."
  if isMyFirework then
    local viewdata = {
      viewname = "DialogView",
      tasks = events,
      npcinfo = target
    }
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
    GameFacade.Instance:sendNotification(DialogEvent.AddUpdateSetTextCall, {
      FunctionVisitNpc.UpdateFireworkDefaultDialog,
      target
    })
    return true
  end
  return false
end

function FunctionVisitNpc.SNpcFuncMap.PveRaidEntrance(npcfunction, target)
  for i = 1, #npcfunction do
    local single = npcfunction[i]
    if single.param and single.param.groupid then
      local menuId = single.param.menuid
      local datas
      if FunctionUnLockFunc.Me():CheckCanOpen(menuId) and not AstralProxy.Instance:IsSeasonEnd() then
        FunctionPve.QueryPvePassInfo()
        local diffs = PveEntranceProxy.Instance:GetDifficultyData(single.param.groupid)
        datas = {}
        for j = 1, #diffs do
          if diffs[j] ~= PveEntranceProxy.EmptyDiff then
            datas[#datas + 1] = diffs[j]
          end
        end
      end
      local viewdata = {
        viewname = "DialogView",
        pveRaidEntrances = datas,
        npcinfo = target
      }
      GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
      return true
    end
  end
  return false
end

function FunctionVisitNpc.UpdateFireworkDefaultDialog(target)
  local dialog = DialogUtil.GetDialogData(171987)
  return true, dialog.Text
end
