autoImport("SgAINpc")
autoImport("SgBoxTrigger")
autoImport("SgBurrowTrigger")
autoImport("SgHockTrigger")
autoImport("SgMachineTrigger")
autoImport("SgPaintingTrigger")
autoImport("SgPlotTrigger")
autoImport("SgPushBoxTrigger")
autoImport("SgResetBirthTrigger")
autoImport("SgRubbleTrigger")
autoImport("SgSavePointTrigger")
autoImport("SgStatueTrigger")
autoImport("SgVictoryTrigger")
autoImport("SgBoxNpcTrigger")
autoImport("SgVisitNpcTrigger")
autoImport("SgNpcPlayPlotTrigger")
autoImport("SgCostItemPlayPlotTrigger")
autoImport("SgPlayThePianoGameTrigger")
autoImport("SgDogHoleTrigger")
autoImport("SgVisitTriggerChildTrigger")
autoImport("SgTrapTrigger")
autoImport("SgPutDownOrTakeOutTrigger")
autoImport("SgCheckBagItemTrigger")
autoImport("SceneTopAttachedInfo")
SgAIManager = class("SgAIManager")
SgAIManager.m_sgi = RO.StealthGame.StealthGame
SgAchievementType = {
  eKillEnemy = 1,
  eShottingScore = 2,
  eGetItems = 3,
  eSceneObjChanged = 4,
  ePlayerDie = 5,
  ePlayerHideCount = 6,
  eMoveBoxDistance = 7,
  eOpenBox = 8,
  eAttractTheEnemy = 9,
  ePlayerBeFound = 10,
  ePlayerUseSkill = 11,
  ePlayerControlEnemy = 12,
  ePlayerWakeUpEnemy = 13,
  eNotKillEnemy = 14
}
local VertigoTime = GameConfig.HeartLock.vertigoTime or 30
local AttachSkillID = 4605001
local DogBreakSkillID = 4607001

function SgAIManager.Me()
  if nil == SgAIManager.me then
    SgAIManager.me = SgAIManager.new()
  end
  return SgAIManager.me
end

function SgAIManager:ctor()
  self.m_isInBattle = false
  self.m_npcList = {}
  self.m_triggerList = {}
  self.m_npcTriggerList = {}
  self.m_alreadyVisitedTrigger = {}
  self.m_alreadyVisitedNpcTrigger = {}
  self.m_playerItem = {}
  self.m_playerUsedItem = {}
  self.playerDoorItemMap = {}
  self:InitSkill()
end

function SgAIManager:getInstance()
  return self.m_sgi.Instance
end

function SgAIManager:Launch()
  local raidId = SceneProxy.Instance:GetCurRaidID()
  local raidInfo = Table_MapRaid[raidId]
  if raidInfo and raidInfo.Type == 63 then
    redlog("进入心锁副本")
    SgAIManager.Me():onStart()
    FunctionCheck.Me():SetSyncMove(FunctionCheck.CannotSyncMoveReason.StealthGame, false)
  end
end

function SgAIManager:onStart()
  if self.m_isInBattle then
    return
  end
  self.m_resetBirthNpcList = {}
  self.m_historyData = nil
  self.m_leaveBattle = false
  self.m_isInBattle = true
  self:setIsFinished(false)
  self.m_isInBurrow = false
  self:getInstance():Init()
  self.m_playerModelTid = self:getInstance().PlayerModelTid
  self.m_getItemIds = {}
  local tmp = self:getInstance().ItemIds
  if tmp ~= nil then
    for i = 1, #tmp do
      table.insert(self.m_getItemIds, tmp[i])
    end
  end
  self.m_getItemPlayPlotIds = {}
  local tmp = self:getInstance().PlotIds
  if tmp ~= nil then
    for i = 1, #tmp do
      table.insert(self.m_getItemPlayPlotIds, tmp[i])
    end
  end
  if self.m_historyData == nil then
    self:setHistoryData()
  end
  local arrNpc = self:getInstance():GetAllNpc()
  if self.m_historyData == nil then
    for k, n in ipairs(arrNpc) do
      local uid, _ = math.modf(n.m_uid)
      local npc = ReusableObject.Create(SgAINpc)
      n:LuaInit(npc)
      npc:initData(n, uid, nil)
      table.insert(self.m_npcList, npc)
    end
  else
    for k, n in ipairs(arrNpc) do
      local uid, _ = math.modf(n.m_uid)
      local tbData = Table_NPCAIxinsuo[uid]
      if tbData.Resurrection == 1 then
        local npc = ReusableObject.Create(SgAINpc)
        n:LuaInit(npc)
        npc:initData(n, uid, nil)
        table.insert(self.m_npcList, npc)
      else
        local historyData = self:getNpcHistoryData(uid)
        if historyData ~= nil then
          local npc = ReusableObject.Create(SgAINpc)
          n:LuaInit(npc)
          npc:initData(n, uid, historyData)
          table.insert(self.m_npcList, npc)
        end
      end
    end
  end
  local arrTrigger = self:getInstance():GetAllTrigger()
  for _, t in ipairs(arrTrigger) do
    self:factoryCreateNormalTrigger(t)
  end
  local arrNpcTrigger = self:getInstance():GetNpcTrigger()
  for _, t in ipairs(arrNpcTrigger) do
    self:factoryCreateNpcTrigger(t)
  end
  if self.m_historyData ~= nil and self.m_historyData.m_playerPosition ~= nil then
    self.m_possessedTickTime = TimeTickManager.Me():CreateTick(500, 0, self.delayChangePlayerPosition, self, 988)
  end
  self:isInvisible(false)
  self:setVertigoTime(VertigoTime)
  self:setIsGameOver(false)
  FunctionPlayerUI.Me():MaskBloodBar(Game.Myself, 999)
  FunctionPlayerUI.Me():MaskNameHonorFactionType(Game.Myself, 888)
  EventManager.Me():AddEventListener(ServiceEvent.PlayerMapChange, self.ShutDown, self)
  EventManager.Me():AddEventListener(StealthGameEvent.ThePlayPinaoResult, self.onThePlayPinaoEnd, self)
  EventManager.Me():AddEventListener(StealthGameEvent.ClickMinMapLeave, self.onLeave, self)
  EventManager.Me():AddEventListener(LoadSceneEvent.FinishLoadScene, self.PlayEndFunc, self)
  self:playerTransfiguration()
  self:setPlayerIsDead(false)
  NCreature.SetForceVisible(true)
  EventManager.Me():PassEvent(StealthGameEvent.RaidItem_Update)
  EventManager.Me():PassEvent(StealthGameEvent.Start)
end

function SgAIManager:onRestart()
  if self.m_leaveBattle then
    return
  end
  self.m_leaveBattle = false
  self.m_isInBattle = true
  self:setIsFinished(false)
  self.m_isInBurrow = false
  self:dispose()
  self:getInstance():Init()
  local arrNpc = self:getInstance():GetAllNpc()
  if self.m_historyData == nil then
    for k, n in ipairs(arrNpc) do
      local uid, _ = math.modf(n.m_uid)
      local npc = ReusableObject.Create(SgAINpc)
      n:LuaInit(npc)
      npc:initData(n, uid, nil)
      table.insert(self.m_npcList, npc)
    end
  else
    for k, n in ipairs(arrNpc) do
      local uid, _ = math.modf(n.m_uid)
      local tbData = Table_NPCAIxinsuo[uid]
      if tbData.Resurrection == 1 then
        local npc = ReusableObject.Create(SgAINpc)
        n:LuaInit(npc)
        npc:initData(n, uid, nil)
        table.insert(self.m_npcList, npc)
      else
        local historyData = self:getNpcHistoryData(uid)
        if historyData ~= nil then
          local npc = ReusableObject.Create(SgAINpc)
          n:LuaInit(npc)
          npc:initData(n, uid, nil)
          table.insert(self.m_npcList, npc)
        end
      end
    end
  end
  local arrTrigger = self:getInstance():GetAllTrigger()
  for _, t in ipairs(arrTrigger) do
    if t.MyType ~= SgTriggerType.eMachine then
      t:ResetAnimation(nil)
    end
    self:factoryCreateNormalTrigger(t)
  end
  local arrNpcTrigger = self:getInstance():GetNpcTrigger()
  for _, t in ipairs(arrNpcTrigger) do
    self:factoryCreateNpcTrigger(t)
  end
  local hasSavePoint = false
  if self.m_historyData ~= nil and self.m_historyData.m_lastSavePoint ~= nil then
    local trigger = self:findTrigger(self.m_historyData.m_lastSavePoint)
    if trigger ~= nil then
      trigger:setPlayerToBirth()
      hasSavePoint = true
    end
  end
  if not hasSavePoint then
    local pos = Game.MapManager:FindBornPoint(1).position
    Game.Myself.logicTransform:PlaceTo(pos)
    FunctionCameraEffect.ResetFreeCameraFocusOffset(Game.Myself.assetRole, true)
  end
  self:getInstance():SetPlayerIsCanBeFound(false)
  self.m_notFoundTick = TimeTickManager.Me():CreateTick(3000, 0, self.onNotFoundEnd, self, 799999)
  self:isInvisible(false)
  self:setIsGameOver(false)
  self:playerTransfiguration()
  self:setPlayerIsDead(false)
  self.m_resetBirthNpcList = {}
  EventManager.Me():PassEvent(StealthGameEvent.RaidItem_Update)
  EventManager.Me():PassEvent(StealthGameEvent.Skill_Update, self)
end

function SgAIManager:setSkill()
  if GameConfig.HeartLock.RewardAttackedSkillNpcTrigger == nil then
    return
  end
  local mapid = SceneProxy.Instance:GetCurRaidID() or 0
  local npcTriggerId = -1
  for k, v in pairs(GameConfig.HeartLock.RewardAttackedSkillNpcTrigger) do
    if k == mapid then
      npcTriggerId = v
      break
    end
  end
  if npcTriggerId ~= -1 and self:findNPCTrigger(npcTriggerId) == nil then
    self:AddTriggerSkill(AttachSkillID)
  end
end

function SgAIManager:onNotFoundEnd()
  if self:getInstance() then
    self:getInstance():SetPlayerIsCanBeFound(true)
  end
  TimeTickManager.Me():ClearTick(self, 799999)
  self.m_notFoundTick = nil
end

function SgAIManager:delayChangePlayerPosition()
  local pos = self.m_historyData.m_playerPosition
  Game.Myself.logicTransform:PlaceTo(pos)
  Game.Myself.logicTransform:SetTargetAngleY(self.m_historyData.m_angleY)
  if self.m_historyData.m_lastSavePoint ~= nil then
    local trigger = self:findTrigger(self.m_historyData.m_lastSavePoint)
    if trigger:isUsedHock() then
      self:setIsUseHock(trigger:playerInRange())
    else
      self:setIsUseHock(false)
    end
  end
  TimeTickManager.Me():ClearTick(self, 988)
end

function SgAIManager:addQuest(data)
  redlog("questdata")
  self.m_questData = data
  local bgm = self.m_questData.params.bgm
  if bgm and bgm ~= "" then
    self.m_endingBGM = bgm
  end
end

function SgAIManager:getQuest()
  return self.m_questData
end

function SgAIManager:setIsFinished(value)
  self.m_isFinished = value
end

function SgAIManager:isFinished()
  return self.m_isFinished ~= nil and self.m_isFinished
end

function SgAIManager:tryPlayEndBgm()
  if self.m_endingBGM then
    FunctionBGMCmd.Me():PlayMissionBgm(self.m_endingBGM, 0)
    self.m_endingBGM = nil
  end
end

function SgAIManager:playerTransfiguration()
  if self.m_possessedNpcId ~= nil then
    self:setIsPossessed(true)
    local staticData = Table_Npc[self.m_possessedNpcId]
    local parts = Asset_RoleUtility.CreateRoleParts(staticData)
    Game.Myself.assetRole:Redress(parts)
    GameFacade.Instance:sendNotification(MyselfEvent.ChangeDressByNpcID, self.m_possessedNpcId)
    EventManager.Me():PassEvent(StealthGameEvent.Skill_AttachNPC, self)
  else
    local tid = self:getInstance().PlayerModelTid
    tid = math.modf(tid)
    local tbNpc = Table_Npc[tid]
    if nil == tbNpc then
      Game.Myself:ReDress()
      return
    end
    local parts = Asset_RoleUtility.CreateRoleParts(tbNpc)
    Game.Myself.assetRole:Redress(parts)
    GameFacade.Instance:sendNotification(MyselfEvent.ChangeDressByNpcID, tid)
  end
  Game.Myself.assetRole:SetScale(1)
end

function SgAIManager:setPlayerIsDead(value)
  self.m_playerIsDead = value
  self:ResetSkillEffect()
end

function SgAIManager:playerIsDead()
  if self.m_playerIsDead == nil then
    return false
  end
  return self.m_playerIsDead
end

function SgAIManager:factoryCreateNormalTrigger(sgtrigger)
  local type = sgtrigger.MyType
  local uid, _ = math.modf(sgtrigger.UID)
  if type == SgTriggerType.eBox then
    local trigger = ReusableObject.Create(SgBoxTrigger)
    sgtrigger:LuaInit(trigger)
    trigger:initData(sgtrigger, uid, self:getTriggerHistoryData(uid))
    table.insert(self.m_triggerList, trigger)
  elseif type == SgTriggerType.eBurrow then
    local trigger = ReusableObject.Create(SgBurrowTrigger)
    sgtrigger:LuaInit(trigger)
    trigger:initData(sgtrigger, uid, self:getTriggerHistoryData(uid))
    table.insert(self.m_triggerList, trigger)
  elseif type == SgTriggerType.eHock then
    local trigger = ReusableObject.Create(SgHockTrigger)
    sgtrigger:LuaInit(trigger)
    trigger:initData(sgtrigger, uid, self:getTriggerHistoryData(uid))
    table.insert(self.m_triggerList, trigger)
  elseif type == SgTriggerType.eMachine then
    local trigger = ReusableObject.Create(SgMachineTrigger)
    sgtrigger:LuaInit(trigger)
    trigger:initData(sgtrigger, uid, self:getTriggerHistoryData(uid))
    table.insert(self.m_triggerList, trigger)
  elseif type == SgTriggerType.ePainting then
    local trigger = ReusableObject.Create(SgPaintingTrigger)
    sgtrigger:LuaInit(trigger)
    trigger:initData(sgtrigger, uid, self:getTriggerHistoryData(uid))
    table.insert(self.m_triggerList, trigger)
  elseif type == SgTriggerType.ePlot then
    local trigger = ReusableObject.Create(SgPlotTrigger)
    sgtrigger:LuaInit(trigger)
    trigger:initData(sgtrigger, uid, self:getTriggerHistoryData(uid))
    table.insert(self.m_triggerList, trigger)
  elseif type == SgTriggerType.ePushBox then
    local trigger = ReusableObject.Create(SgPushBoxTrigger)
    sgtrigger:LuaInit(trigger)
    trigger:initData(sgtrigger, uid, self:getTriggerHistoryData(uid))
    table.insert(self.m_triggerList, trigger)
  elseif type == SgTriggerType.eResetBirth2 then
    local trigger = ReusableObject.Create(SgResetBirthTrigger)
    sgtrigger:LuaInit(trigger)
    trigger:initData(sgtrigger, uid, self:getTriggerHistoryData(uid))
    table.insert(self.m_triggerList, trigger)
  elseif type == SgTriggerType.eRubble then
    local trigger = ReusableObject.Create(SgRubbleTrigger)
    sgtrigger:LuaInit(trigger)
    trigger:initData(sgtrigger, uid, self:getTriggerHistoryData(uid))
    table.insert(self.m_triggerList, trigger)
  elseif type == SgTriggerType.eSavePoint then
    local trigger = ReusableObject.Create(SgSavePointTrigger)
    sgtrigger:LuaInit(trigger)
    trigger:initData(sgtrigger, uid, self:getTriggerHistoryData(uid))
    table.insert(self.m_triggerList, trigger)
  elseif type == SgTriggerType.eStatue then
    local trigger = ReusableObject.Create(SgStatueTrigger)
    sgtrigger:LuaInit(trigger)
    trigger:initData(sgtrigger, uid, self:getTriggerHistoryData(uid))
    table.insert(self.m_triggerList, trigger)
  elseif type == SgTriggerType.eVictory then
    local trigger = ReusableObject.Create(SgVictoryTrigger)
    sgtrigger:LuaInit(trigger)
    trigger:initData(sgtrigger, uid, self:getTriggerHistoryData(uid))
    table.insert(self.m_triggerList, trigger)
  elseif type == SgTriggerType.eNpcPlayPlot then
    local trigger = ReusableObject.Create(SgNpcPlayPlotTrigger)
    sgtrigger:LuaInit(trigger)
    trigger:initData(sgtrigger, uid, self:getTriggerHistoryData(uid))
    table.insert(self.m_triggerList, trigger)
  elseif type == SgTriggerType.eCostItemPlayPlot then
    local trigger = ReusableObject.Create(SgCostItemPlayPlotTrigger)
    sgtrigger:LuaInit(trigger)
    trigger:initData(sgtrigger, uid, self:getTriggerHistoryData(uid))
    table.insert(self.m_triggerList, trigger)
  elseif type == SgTriggerType.ePlayThePianoGame then
    local trigger = ReusableObject.Create(SgPlayThePianoGameTrigger)
    sgtrigger:LuaInit(trigger)
    trigger:initData(sgtrigger, uid, self:getTriggerHistoryData(uid))
    table.insert(self.m_triggerList, trigger)
  elseif type == SgTriggerType.eDogHole then
    local trigger = ReusableObject.Create(SgDogHoleTrigger)
    sgtrigger:LuaInit(trigger)
    trigger:initData(sgtrigger, uid, self:getTriggerHistoryData(uid))
    table.insert(self.m_triggerList, trigger)
  elseif type == SgTriggerType.eVisitTriggerChild then
    local trigger = ReusableObject.Create(SgVisitTriggerChildTrigger)
    sgtrigger:LuaInit(trigger)
    trigger:initData(sgtrigger, uid, self:getTriggerHistoryData(uid))
    table.insert(self.m_triggerList, trigger)
  elseif type == SgTriggerType.eTrap then
    local trigger = ReusableObject.Create(SgTrapTrigger)
    sgtrigger:LuaInit(trigger)
    trigger:initData(sgtrigger, uid, self:getTriggerHistoryData(uid))
    table.insert(self.m_triggerList, trigger)
  elseif type == SgTriggerType.ePutDownOrTakeOut then
    local trigger = ReusableObject.Create(SgPutDownOrTakeOutTrigger)
    sgtrigger:LuaInit(trigger)
    trigger:initData(sgtrigger, uid, self:getTriggerHistoryData(uid))
    table.insert(self.m_triggerList, trigger)
  elseif type == SgTriggerType.eCheckBagItem then
    local trigger = ReusableObject.Create(SgCheckBagItemTrigger)
    sgtrigger:LuaInit(trigger)
    trigger:initData(sgtrigger, uid, self:getTriggerHistoryData(uid))
    table.insert(self.m_triggerList, trigger)
  end
end

function SgAIManager:factoryCreateNpcTrigger(sgClass)
  local type = sgClass.MyType
  local store = sgClass.Score
  local uid = math.modf(sgClass.UID)
  local tid = math.modf(sgClass.TID)
  if self:npcTriggerIsVisited(uid) and sgClass.IsCanDelete then
    return
  end
  if sgClass.EnableType == SgNpcTriggerEnableType.eStore then
    if 0 == store then
      if type == SgNpcTriggerType.eBox then
        local trigger = ReusableObject.Create(SgBoxNpcTrigger)
        trigger:initData(sgClass, uid, tid, nil)
        table.insert(self.m_npcTriggerList, trigger)
      elseif type == SgNpcTriggerType.eVisit then
        local trigger = ReusableObject.Create(SgVisitNpcTrigger)
        trigger:initData(sgClass, uid, tid, nil)
        table.insert(self.m_npcTriggerList, trigger)
      end
    end
  elseif sgClass.EnableType == SgNpcTriggerEnableType.ePDBSuccessed then
    local triggerid = math.modf(sgClass.TriggerId)
    if self:triggetIsMaxBox(triggerid) then
      if type == SgNpcTriggerType.eBox then
        local trigger = ReusableObject.Create(SgBoxNpcTrigger)
        trigger:initData(sgClass, uid, tid, nil)
        table.insert(self.m_npcTriggerList, trigger)
      elseif type == SgNpcTriggerType.eVisit then
        local trigger = ReusableObject.Create(SgVisitNpcTrigger)
        trigger:initData(sgClass, uid, tid, nil)
        table.insert(self.m_npcTriggerList, trigger)
      end
    end
  elseif sgClass.EnableType == SgNpcTriggerEnableType.eChildCompleted and self:checkChildTriggerCompleted(sgClass) then
    if type == SgNpcTriggerType.eBox then
      local trigger = ReusableObject.Create(SgBoxNpcTrigger)
      trigger:initData(sgClass, uid, tid, nil)
      table.insert(self.m_npcTriggerList, trigger)
    elseif type == SgNpcTriggerType.eVisit then
      local trigger = ReusableObject.Create(SgVisitNpcTrigger)
      trigger:initData(sgClass, uid, tid, nil)
      table.insert(self.m_npcTriggerList, trigger)
    end
  end
end

function SgAIManager:onPlayerPossessedSuccess(tid, time, step)
  local staticData = Table_Npc[tid]
  local parts = Asset_RoleUtility.CreateRoleParts(staticData)
  Game.Myself.assetRole:Redress(parts)
  GameFacade.Instance:sendNotification(MyselfEvent.ChangeDressByNpcID, tid)
  if staticData.Scale ~= nil then
    Game.Myself.assetRole:SetScale(staticData.Scale)
  end
  self.m_possessedNpcId = tid
  if self.m_possessedTickTime then
    TimeTickManager.Me():ClearTick(self, 999)
    self.m_possessedTickTime = nil
  end
  if time ~= nil then
    self.m_possessedTickTime = TimeTickManager.Me():CreateTick(time, 0, self.updatePlayerProssessed, self, 999)
  end
  self:setIsPossessed(true)
  self.m_maxAttachedDistance = step
  self:enableDogSkill(true)
  if self.m_maxAttachedDistance ~= nil and 0 < self.m_maxAttachedDistance then
    if self.m_attachedUI == nil and self.m_attachedUIClass == nil then
      local path = SceneTopAttachedInfo.resId
      local container = SceneUIManager.Instance:GetSceneUIContainer(SceneUIType.RoleTopAttachedInfo)
      if container then
        self.m_attachedUI = GameObject("AttachedUI")
        local followTransform = self.m_attachedUI.transform
        followTransform:SetParent(container.transform, false)
        self.m_attachedUI.layer = container.layer
        local go = Game.AssetManager_UI:CreateSceneUIAsset(path, followTransform)
        go.transform:SetParent(followTransform, false)
        self.m_attachedUIClass = SceneTopAttachedInfo.CreateAsArray(nil)
        self.m_attachedUIClass:onSetObj(go)
        self.m_attachedUIClass:onShow()
      else
        redlog("not AttachedUI container")
      end
    else
      self.m_attachedUIClass:onShow()
    end
  elseif self.m_attachedUIClass ~= nil then
    self.m_attachedUIClass:onHide()
  end
  self:recordHistoryData(nil)
end

function SgAIManager:updatePlayerProssessed()
  self:CancelAttachNPC()
  if self.m_possessedTickTime then
    TimeTickManager.Me():ClearTick(self, 999)
    self.m_possessedTickTime = nil
  end
end

function SgAIManager:setIsGameOver(value)
  self:getInstance():SetIsGameOver(value)
  for _, v in ipairs(self.m_triggerList) do
    v:onStopPlot()
  end
end

function SgAIManager:setCurrentTrigger(uid)
  self.m_curTriggerUid = uid
end

function SgAIManager:setIsPossessed(value)
  self:getInstance():SetIsPossessed(value)
end

function SgAIManager:setIsUseHock(value)
  self.m_isUseHock = value
end

function SgAIManager:isUseHock()
  if nil == self.m_isUseHock then
    return false
  end
  return self.m_isUseHock
end

function SgAIManager:OnClickTrigger(obj)
  for _, value in ipairs(self.m_triggerList) do
    if value:isClickTrigger() and obj.ID == value:getUid() then
      value:onClick(obj)
    end
  end
  local manager = Game.GameObjectManagers[Game.GameObjectType.StealthGame]
  manager:ClickObject(obj)
end

function SgAIManager:isInvisible(flag)
  if self.equippedSkills ~= nil then
    for i = 1, #self.equippedSkills do
      local skillItem = self.equippedSkills[i]
      if skillItem and (skillItem.id == AttachSkillID or skillItem.id == DogBreakSkillID) then
        skillItem:SetShadow(flag)
        self.status = true
        EventManager.Me():PassEvent(StealthGameEvent.Skill_Update, self)
      end
    end
  end
  self:getInstance():SetIsInvisible(flag)
end

function SgAIManager:playerIsInBurrow()
  return self.m_isInBurrow
end

function SgAIManager:playerInBurrow(uid)
  local trigger = self:getCurTrigger()
  if trigger == nil then
    self:setCurrentTrigger(uid)
    trigger = self:getCurTrigger()
    self.m_isInBurrow = true
    if trigger ~= nil then
      trigger:showOutLine()
    end
    local nextTirgger = self:findTrigger(trigger.m_nextUid)
    if nextTirgger ~= nil then
      nextTirgger:showOutLine()
    end
    self:Handle_Hiding(true)
    EventManager.Me():PassEvent(StealthGameEvent.HideIn, false)
    redlog("进入洞穴")
  elseif trigger:getUid() == uid then
    trigger:hideOutLine()
    local nextTirgger = self:findTrigger(trigger.m_nextUid)
    if nextTirgger ~= nil then
      nextTirgger:hideOutLine()
    end
    self.m_isInBurrow = false
    self:Handle_Hiding(false)
    EventManager.Me():PassEvent(StealthGameEvent.HideIn, false)
    redlog("走出洞穴")
  elseif trigger.m_nextUid == uid then
    trigger = self:findTrigger(uid)
    if trigger ~= nil then
      self:setCurrentTrigger(uid)
      trigger:hideOutLine()
      local nextTirgger = self:findTrigger(trigger.m_nextUid)
      if nextTirgger ~= nil then
        nextTirgger:hideOutLine()
      end
      self.m_isInBurrow = false
      self:Handle_Hiding(false)
      EventManager.Me():PassEvent(StealthGameEvent.HideIn, false)
      redlog("走出洞穴")
    end
  end
end

function SgAIManager:findTrigger(uid)
  for _, trigger in ipairs(self.m_triggerList) do
    if trigger:getUid() == uid then
      return trigger
    end
  end
  return nil
end

function SgAIManager:getCurTrigger()
  return self:findTrigger(self.m_curTriggerUid)
end

function SgAIManager:getNpcArroundInVertigo(npc)
  local dis = 9999999
  local tpNpc
  for _, n in ipairs(self.m_npcList) do
    if n:getUid() ~= npc:getUid() and not n:isDead() and n:IsVertigo() then
      local pos = n:getPosition()
      if npc:inView(pos[1], pos[2], pos[3]) then
        local d = LuaVector3.Distance(npc:getPosition(), n:getPosition())
        if dis >= d then
          tpNpc = n
        end
      end
    end
  end
  return tpNpc
end

function SgAIManager:setVertigoTime(value)
  self.m_vertigoTime = value
end

function SgAIManager:vertigoTime()
  return self.m_vertigoTime
end

function SgAIManager:ShutDown()
  if self.m_isInBattle then
    self:setIsGameOver(true)
    self:recordHistoryData(nil)
    self:dispose()
    self.m_isInBattle = false
    FunctionPlayerUI.Me():UnMaskBloodBar(Game.Myself, 999)
    FunctionPlayerUI.Me():UnMaskNameHonorFactionType(Game.Myself, 888)
    if self.m_attachedUIClass ~= nil then
      self.m_attachedUIClass:onHide()
      ReusableObject.Destroy(self.m_attachedUIClass)
      self.m_attachedUIClass = nil
      self.m_attachedUI = nil
    end
    self.m_historyData = nil
    self.m_alreadyVisitedTrigger = {}
    self.m_alreadyVisitedNpcTrigger = {}
    self.m_playerItem = {}
    self.m_playerUsedItem = {}
    NCreature.SetForceVisible(false)
    EventManager.Me():RemoveEventListener(ServiceEvent.PlayerMapChange, self.ShutDown, self)
    EventManager.Me():RemoveEventListener(StealthGameEvent.ThePlayPinaoResult, self.onThePlayPinaoEnd, self)
    EventManager.Me():RemoveEventListener(StealthGameEvent.ClickMinMapLeave, self.onLeave, self)
    FunctionCheck.Me():SetSyncMove(FunctionCheck.CannotSyncMoveReason.StealthGame, true)
    EventManager.Me():PassEvent(StealthGameEvent.End)
  end
end

function SgAIManager:PlayEndFunc()
  if not self.m_isInBattle then
    self:tryPlayEndBgm()
    EventManager.Me():RemoveEventListener(LoadSceneEvent.FinishLoadScene, self.ShutDown, self)
  end
end

function SgAIManager:dispose()
  for i = #self.m_npcList, 1, -1 do
    ReusableObject.Destroy(self.m_npcList[i])
    table.remove(self.m_npcList, i)
  end
  for i = #self.m_triggerList, 1, -1 do
    ReusableObject.Destroy(self.m_triggerList[i])
    table.remove(self.m_triggerList, i)
  end
  for i = #self.m_npcTriggerList, 1, -1 do
    ReusableObject.Destroy(self.m_npcTriggerList[i])
    table.remove(self.m_npcTriggerList, i)
  end
  self:RemoveNPCSkill(self.currentAttachNPC)
  Game.Myself:ReDress()
  GameFacade.Instance:sendNotification(MyselfEvent.ChangeDress)
  self:ResetSkillEffect()
end

function SgAIManager:playerRedress()
  self:setIsPossessed(false)
  self:playerTransfiguration()
end

function SgAIManager:removeNpcTrigger(uid)
  for i = #self.m_npcTriggerList, 1, -1 do
    if uid == self.m_npcTriggerList[i]:getUid() then
      ReusableObject.Destroy(self.m_npcTriggerList[i])
      table.remove(self.m_npcTriggerList, i)
      break
    end
  end
end

function SgAIManager:findNPCTrigger(uid)
  for _, trigger in ipairs(self.m_npcTriggerList) do
    if trigger:getUid() == uid then
      return trigger
    end
  end
  return nil
end

function SgAIManager:getAllNpcs()
  return self.m_npcList
end

function SgAIManager:getAllTriggers()
  return self.m_triggerList
end

function SgAIManager:addAchievement(type, data)
  if nil == data then
    return
  end
  if self.m_achievementList == nil then
    self.m_achievementList = {}
  end
  self.m_achievementList[type] = data
end

function SgAIManager:getAchievementByType(type)
  return self.m_achievementList[type]
end

function SgAIManager:getAchievementList()
  if self.m_achievementList == nil then
    return {}
  end
  return self.m_achievementList
end

function SgAIManager:recordHistoryData(triggerUid, forceReset)
  local info = {}
  if forceReset or self:isFinished() then
    self.m_historyData = nil
  else
    if triggerUid ~= nil then
      info.m_lastSavePoint = triggerUid
    elseif self.m_historyData ~= nil then
      info.m_lastSavePoint = self.m_historyData.m_lastSavePoint
    end
    info.m_npcInfos = {}
    info.m_triggerInfos = {}
    info.m_visitedTrigger = self.m_alreadyVisitedTrigger
    info.m_visitedNpcTrigger = self.m_alreadyVisitedNpcTrigger
    info.m_playerItem = {}
    for k, v in pairs(self.m_playerItem) do
      for i = 1, v do
        table.insert(info.m_playerItem, k)
      end
    end
    info.m_playerUsedItem = {}
    for k, v in pairs(self.m_playerUsedItem) do
      for i = 1, v do
        table.insert(info.m_playerUsedItem, k)
      end
    end
    local pos = Game.Myself:GetPosition()
    info.m_playerPosition = {}
    info.m_playerPosition[1] = pos[1]
    info.m_playerPosition[2] = pos[2]
    info.m_playerPosition[3] = pos[3]
    info.m_angleY = Game.Myself:GetAngleY()
    for _, n in ipairs(self.m_npcList) do
      if not n:isDead() then
        table.insert(info.m_npcInfos, n:getData())
      end
    end
    for _, t in ipairs(self.m_triggerList) do
      table.insert(info.m_triggerInfos, t:getData())
    end
    if self.equippedSkills and #self.equippedSkills > 0 then
      info.m_curSkills = {}
      for _, v in ipairs(self.equippedSkills) do
        if not v:CheckVertigoCount() then
          table.insert(info.m_curSkills, v:GetID())
        end
      end
      if self.usedCount ~= nil then
        info.m_skillUseCount = self.usedCount
      end
    end
    info.m_doorInfo = {}
    info.m_doorItemCount = {}
    info.m_doorItemInfo = {}
    for id, items in pairs(self.playerDoorItemMap) do
      table.insert(info.m_doorInfo, id)
      local count = 0
      for itemID, num in pairs(items) do
        count = count + num
        for i = 1, num do
          table.insert(info.m_doorItemInfo, itemID)
        end
      end
      table.insert(info.m_doorItemCount, count)
    end
    self.m_historyData = info
  end
  local raidId = SceneProxy.Instance:GetCurRaidID()
  DungeonProxy.Instance:SaveClientRaid(raidId, info)
end

function SgAIManager:setHistoryData()
  local raidId = SceneProxy.Instance:GetCurRaidID()
  local historyBattleData = DungeonProxy.Instance:GetClientRaidSaveData(raidId)
  if historyBattleData == "" then
    historyBattleData = nil
  end
  if nil ~= historyBattleData then
    self.m_historyData = json.decode(historyBattleData)
    local hasData = false
    for _, _ in pairs(self.m_historyData) do
      hasData = true
      break
    end
    if not hasData then
      self.m_historyData = nil
    end
  end
  if nil == self.m_historyData then
    self.m_historyData = nil
    self.m_alreadyVisitedTrigger = {}
    self.m_alreadyVisitedNpcTrigger = {}
    self.m_playerItem = {}
    self.m_playerUsedItem = {}
    self.playerDoorItemMap = {}
  else
    if self.m_historyData.m_visitedTrigger ~= nil then
      for _, v in ipairs(self.m_historyData.m_visitedTrigger) do
        self:visitedTrigger(v)
      end
    end
    if self.m_historyData.m_visitedNpcTrigger ~= nil then
      for _, v in ipairs(self.m_historyData.m_visitedNpcTrigger) do
        self:visitedNpcTrigger(v)
      end
    end
    if self.m_historyData.m_playerItem ~= nil then
      for _, id in pairs(self.m_historyData.m_playerItem) do
        self:playerAddItem(id, 1)
      end
    end
    if self.m_historyData.m_playerUsedItem ~= nil then
      for _, id in pairs(self.m_historyData.m_playerUsedItem) do
        self:addToUsedItem(id, 1)
      end
    end
    if self.m_historyData.m_doorInfo ~= nil then
      local goMgr = Game.GameObjectManagers[Game.GameObjectType.StealthGame]
      local itemIndex = 1
      for k, doorId in ipairs(self.m_historyData.m_doorInfo) do
        local itemInfo = {}
        local count = self.m_historyData.m_doorItemCount[k]
        for i = 1, count do
          for j = itemIndex, #self.m_historyData.m_doorItemInfo do
            local itemId = self.m_historyData.m_doorItemInfo[j]
            if itemInfo[itemId] == nil then
              itemInfo[itemId] = 1
            else
              itemInfo[itemId] = itemInfo[itemId] + 1
            end
          end
        end
        self.playerDoorItemMap[doorId] = itemInfo
        itemIndex = itemIndex + count
        goMgr:DisplayDoorEquipPlot(doorId)
      end
    end
  end
  if raidId == 1003567 then
    local errorSavePoints = {
      [40001] = 1,
      [40008] = 1
    }
    local savePoint = self.m_historyData and self.m_historyData.m_lastSavePoint
    local goMgr = Game.GameObjectManagers[Game.GameObjectType.StealthGame]
    if savePoint and errorSavePoints[savePoint] and self.m_historyData.m_visitedTrigger then
      for k, v in pairs(self.m_historyData.m_visitedTrigger) do
        if v == 10205 then
          self.m_historyData.m_playerPosition = {
            2.37,
            2.25,
            -7.9
          }
          self.m_historyData.m_lastSavePoint = 40000
          break
        end
      end
    end
  end
end

function SgAIManager:getNpcHistoryData(uid)
  if nil ~= self.m_historyData and nil ~= self.m_historyData.m_npcInfos then
    for _, value in ipairs(self.m_historyData.m_npcInfos) do
      if value.m_uid == uid then
        return value
      end
    end
  end
  return nil
end

function SgAIManager:getTriggerHistoryData(uid)
  if nil ~= self.m_historyData and nil ~= self.m_historyData.m_triggerInfos then
    for _, value in ipairs(self.m_historyData.m_triggerInfos) do
      if value.m_uid == uid then
        return value
      end
    end
  end
  return nil
end

function SgAIManager:isFindPlayer()
  for _, npc in ipairs(self.m_npcList) do
    if npc:isFindPlayer() then
      return true
    end
  end
  return false
end

function SgAIManager:visitedTrigger(uid)
  if not self:triggerIsVisited(uid) then
    table.insert(self.m_alreadyVisitedTrigger, uid)
    local trigger = self:findTrigger(uid)
    if trigger ~= nil then
      local dialog = trigger:getMemoryDialog()
      if dialog and 0 < #dialog then
        self:AddMemory(dialog)
        RedTipProxy.Instance:UpdateRedTip(711)
        EventManager.Me():PassEvent(StealthGameEvent.Update_MemoryInfo)
      end
    end
  end
end

function SgAIManager:triggerIsVisited(uid)
  for _, v in ipairs(self.m_alreadyVisitedTrigger) do
    if v == uid then
      return true
    end
  end
  return false
end

function SgAIManager:visitedNpcTrigger(uid)
  if not self:triggerIsVisited(uid) then
    table.insert(self.m_alreadyVisitedNpcTrigger, uid)
  end
end

function SgAIManager:npcTriggerIsVisited(uid)
  for _, v in ipairs(self.m_alreadyVisitedNpcTrigger) do
    if v == uid then
      return true
    end
  end
  return false
end

function SgAIManager:playerAddItem(id, count)
  if count == 0 then
    return
  end
  if self.m_playerItem[id] == nil then
    self.m_playerItem[id] = count
    for i = 1, #self.m_getItemIds do
      if self.m_getItemIds[i] == id then
        Game.PlotStoryManager:Start_PQTLP(self.m_getItemPlayPlotIds[i], nil, nil, nil, false, nil, nil, false)
      end
    end
  else
    self.m_playerItem[id] = self.m_playerItem[id] + count
  end
  local sData = Table_Item[id]
  if sData then
    if id == 13611 or id == 13612 or id == 13613 or id == 13614 then
      MsgManager.ShowMsgByIDTable(42120, {
        id,
        id,
        count
      }, Game.Myself.data.id)
    else
      MsgManager.ShowMsgByIDTable(6, {
        id,
        id,
        count
      }, Game.Myself.data.id)
    end
  end
  EventManager.Me():PassEvent(StealthGameEvent.RaidItem_Add, id)
end

function SgAIManager:playerUseItem(id, count, forever)
  if self.m_playerItem[id] == nil then
    return false
  end
  self.m_playerItem[id] = self.m_playerItem[id] - count
  if self.m_playerItem[id] <= 0 then
    self.m_playerItem[id] = nil
  end
  local sData = Table_Item[id]
  if sData then
    MsgManager.ShowMsgByIDTable(75, {
      id,
      id,
      count
    }, Game.Myself.data.id)
  end
  if forever == nil or forever == false then
    if self.m_playerUsedItem[id] == nil then
      self.m_playerUsedItem[id] = count
    else
      self.m_playerUsedItem[id] = self.m_playerUsedItem[id] + count
    end
  end
  EventManager.Me():PassEvent(StealthGameEvent.RaidItem_Del, self)
  return true
end

function SgAIManager:addToUsedItem(id, count)
  if self.m_playerUsedItem[id] == nil then
    self.m_playerUsedItem[id] = count
  else
    self.m_playerUsedItem[id] = self.m_playerUsedItem[id] + count
  end
end

function SgAIManager:getPlayerItem()
  return self.m_playerItem
end

function SgAIManager:getItemById(id)
  return self.m_playerItem[id]
end

function SgAIManager:isUsedItem(id)
  if self.m_playerUsedItem[id] == nil then
    return false
  end
  return self.m_playerUsedItem[id] > 0
end

function SgAIManager:GetPlayerItemdatas()
  local result = {}
  if self.m_playerItem then
    for itemid, num in pairs(self.m_playerItem) do
      local itemdata = ItemData.new("RaidItem", itemid)
      itemdata.num = num
      table.insert(result, itemdata)
    end
    table.sort(result, function(a, b)
      return a.staticData.id > b.staticData.id
    end)
  end
  return result
end

function SgAIManager:getMemory()
  if not self.memorylist then
    return nil
  end
  if not self.memory then
    self.memory = {}
  else
    TableUtility.ArrayClear(self.memory)
  end
  for _, m in ipairs(self.memorylist) do
    local single = DialogUtil.GetDialogData(m)
    table.insert(self.memory, single.Text)
  end
  return self.memory
end

function SgAIManager:AddMemory(dialoglist)
  if not self.memorylist then
    self.memorylist = {}
  end
  for _, m in ipairs(dialoglist) do
    if TableUtility.ArrayFindIndex(self.memorylist, m) == 0 then
      table.insert(self.memorylist, m)
    end
  end
end

function SgAIManager:curretTriggetIsMaxBox()
  return self:triggetIsMaxBox(self.m_curTriggerUid)
end

function SgAIManager:triggetIsMaxBox(uid)
  local curTrigger = self:findTrigger(uid)
  if curTrigger == nil then
    return false
  end
  if curTrigger ~= nil and SgTriggerType.ePushBox and curTrigger:isMaxBox() then
    return true
  end
  return false
end

function SgAIManager:boxIsUsed(uid)
  for _, v in ipairs(self.m_triggerList) do
    if v:getType() == SgTriggerType.ePushBox and v:hasBox(uid) then
      return true
    end
  end
  return false
end

function SgAIManager:setIsShowPushBoxOutLine(value)
  for _, v in ipairs(self.m_triggerList) do
    if v:getType() == SgTriggerType.ePushBox then
      if value then
        if v:isMaxBox() then
          v:hideOutLine()
        else
          v:showOutLine()
        end
      else
        v:hideOutLine()
      end
    end
  end
end

function SgAIManager:putDownBox(uid)
  local curTrigger = self:getCurTrigger()
  if curTrigger ~= nil and SgTriggerType.ePushBox then
    curTrigger:addBox(uid)
  end
end

function SgAIManager:pickUpBox(uid)
  local curTrigger = self:getCurTrigger()
  if curTrigger ~= nil and SgTriggerType.ePushBox then
    curTrigger:removeBox(uid)
  end
end

function SgAIManager:playerDogBarking(uid)
  Game.PlotStoryManager:Start_PQTLP("11196", nil, nil, nil, false, nil, {
    myself = Game.Myself.data.id
  }, false)
  local pos = Game.Myself:GetPosition()
  local voiceRadius = GameConfig.HeartLock.VoiceDistance
  for _, target in ipairs(self.m_npcList) do
    if not target:IsVertigo() and not target:isDead() and not target.m_stateMachine:isType(AIBehaviourType.eAlertPatrol) and not target:doubtIslookAtTarget() then
      local dis = math.abs(LuaVector3.Distance(pos, target:getPosition()))
      if voiceRadius >= dis then
        target:setDogPos(pos)
        if target.m_stateMachine:isType(AIBehaviourType.eLethargy) then
          local playEnd = function(result)
            target:getStateMachine():breakSwitch(AIBehaviourType.eDoubtMoveTo, 4, true)
          end
          Game.PlotStoryManager:Start_PQTLP("3035", playEnd, nil, nil, false, nil, {
            myself = target.m_creature.data.id
          }, false)
        else
          target:getStateMachine():breakSwitch(AIBehaviourType.eDoubtMoveTo, 4, true)
        end
      end
    end
  end
end

function SgAIManager:shootingCompleted(value)
  self.m_curShootingScore = value
  local arrNpcTrigger = self:getInstance():GetNpcTrigger()
  for _, t in ipairs(arrNpcTrigger) do
    local type = t.MyType
    local store = t.Score
    local uid = math.modf(t.UID)
    local tid = math.modf(t.TID)
    if 0 < store then
      local isCanCreate = true
      if self:npcTriggerIsVisited(uid) and t.IsCanDelete then
        isCanCreate = false
      end
      local alreadHas = false
      for _, v in ipairs(self.m_npcTriggerList) do
        if v:getUid() == uid then
          alreadHas = true
          break
        end
      end
      if value >= store and not alreadHas and t.EnableType == SgNpcTriggerEnableType.eStore and isCanCreate then
        if type == SgNpcTriggerType.eBox then
          local trigger = ReusableObject.Create(SgBoxNpcTrigger)
          trigger:initData(t, uid, tid, nil)
          table.insert(self.m_npcTriggerList, trigger)
        elseif type == SgNpcTriggerType.eVisit then
          local trigger = ReusableObject.Create(SgVisitNpcTrigger)
          trigger:initData(t, uid, tid, nil)
          table.insert(self.m_npcTriggerList, trigger)
        end
      end
    end
  end
end

function SgAIManager:onChildTriggerCompleted()
  local arrNpcTrigger = self:getInstance():GetNpcTrigger()
  for _, t in ipairs(arrNpcTrigger) do
    local type = t.MyType
    local uid = math.modf(t.UID)
    local tid = math.modf(t.TID)
    local triggerid = math.modf(t.TriggerId)
    local alreadHas = false
    for _, v in ipairs(self.m_npcTriggerList) do
      if v:getUid() == uid then
        alreadHas = true
        break
      end
    end
    if not alreadHas and t.EnableType == SgNpcTriggerEnableType.eChildCompleted and self:checkChildTriggerCompleted(t) then
      if type == SgNpcTriggerType.eBox then
        local trigger = ReusableObject.Create(SgBoxNpcTrigger)
        trigger:initData(t, uid, tid, nil)
        table.insert(self.m_npcTriggerList, trigger)
      elseif type == SgNpcTriggerType.eVisit then
        local trigger = ReusableObject.Create(SgVisitNpcTrigger)
        trigger:initData(t, uid, tid, nil)
        table.insert(self.m_npcTriggerList, trigger)
      end
    end
  end
end

function SgAIManager:onTriggerExecuteSuccessed(_uid)
  local arrNpcTrigger = self:getInstance():GetNpcTrigger()
  for _, t in ipairs(arrNpcTrigger) do
    local type = t.MyType
    local uid = math.modf(t.UID)
    local tid = math.modf(t.TID)
    local triggerid = math.modf(t.TriggerId)
    local isCanCreate = true
    if _uid ~= triggerid then
      isCanCreate = false
    end
    if self:npcTriggerIsVisited(uid) and t.IsCanDelete then
      isCanCreate = false
    end
    local alreadHas = false
    for _, v in ipairs(self.m_npcTriggerList) do
      if v:getUid() == uid then
        alreadHas = true
        break
      end
    end
    if isCanCreate and not alreadHas and t.EnableType == SgNpcTriggerEnableType.ePDBSuccessed then
      if type == SgNpcTriggerType.eBox then
        local trigger = ReusableObject.Create(SgBoxNpcTrigger)
        trigger:initData(t, uid, tid, nil)
        table.insert(self.m_npcTriggerList, trigger)
      elseif type == SgNpcTriggerType.eVisit then
        local trigger = ReusableObject.Create(SgVisitNpcTrigger)
        trigger:initData(t, uid, tid, nil)
        table.insert(self.m_npcTriggerList, trigger)
      end
    end
  end
end

function SgAIManager:LaunchSkill()
  self:ClearSkills()
  self:InitSkill()
  local skillsconfig = GameConfig.HeartLock.InitSkills
  local mapid = SceneProxy.Instance:GetCurRaidID() or 0
  if self.m_historyData ~= nil and self.m_historyData.m_curSkills ~= nil and 0 < #self.m_historyData.m_curSkills then
    for _, v in ipairs(self.m_historyData.m_curSkills) do
      self:AddSkill(v)
    end
    local count = self.m_historyData.m_skillUseCount
    if count ~= nil and 0 < count then
      for _, v in ipairs(self.equippedSkills) do
        v:SetUsedCount(count)
      end
    end
    EventManager.Me():PassEvent(StealthGameEvent.Skill_Update, self)
  else
    local skills = skillsconfig and skillsconfig[mapid]
    if skills then
      for i = 1, #skills do
        self:AddSkill(skills[i])
      end
    end
  end
end

function SgAIManager:InitSkill()
  self.skillFuncMap = {}
  self.skillFuncMap[1] = self.HandleSkill_Insight
  self.skillFuncMap[4] = self.HandleSkill_Shooting
  self.skillFuncMap[5] = self.HandleSkill_AttachNPC
  self.skillFuncMap[6] = self.HandleSkill_Vertigo
  self.skillFuncMap[7] = self.HandleSkill_Barking
  self.usedCount = 0
  self.status = true
  local eventManager = EventManager.Me()
  eventManager:AddEventListener(MyselfEvent.StartToMove, self.CancelInsight, self)
end

function SgAIManager:onBeginUseSkill(target)
  if self.m_useSkillId ~= nil then
    redlog("not museskillid")
    return
  end
  self.targetCheckNPC = target
  self.isBreak = false
  if self.m_useSkillId ~= nil then
    TimeTickManager.Me():ClearTick(self, 100)
    self.m_useSkillId = nil
  end
  self.m_useSkillId = TimeTickManager.Me():CreateTick(0, 100, self.onCheckBreakSkill, self, 100, true, 100)
end

function SgAIManager:onCheckBreakSkill()
  if not self.targetCheckNPC then
    return
  end
  local pos
  self.isBreak = false
  local uid = self.targetCheckNPC:getUid()
  for _, n in ipairs(self.m_npcList) do
    if uid ~= n:getUid() and not n:isDead() and not n:IsVertigo() and not n:getStateMachine():isType(AIBehaviourType.eLethargy) then
      pos = self.targetCheckNPC:getPosition()
      if n:inView(pos[1], pos[2], pos[3]) then
        local playEnd = function()
          self.m_attachPlotId = nil
        end
        if not n:isAlert() and not n:isAlertPatron() then
          Game.PlotStoryManager:Start_PQTLP("11109", playEnd, nil, nil, false, nil, {
            myself = n:getUid()
          }, false)
        end
        self.isBreak = true
        if nil == self.m_attachPlotId then
          self.m_attachPlotId = Game.PlotStoryManager:Start_PQTLP("3038", playEnd, nil, nil, false, nil, nil, false)
        end
        break
      end
    end
  end
  if self.isBreak then
    EventManager.Me():PassEvent(StealthGameEvent.Break_Skill, {
      data = Game.Myself
    })
    TimeTickManager.Me():ClearTick(self, 100)
    self.m_useSkillId = nil
  end
end

function SgAIManager:onUseSkillSuccess()
  if self.m_useSkillId ~= nil then
    TimeTickManager.Me():ClearTick(self, 100)
    self.m_useSkillId = nil
    self.isBreak = false
  end
end

function SgAIManager:AddSkill(skillid)
  if not self.equippedSkills then
    self.equippedSkills = {}
  end
  for _, v in ipairs(self.equippedSkills) do
    if v:GetID() == skillid then
      return
    end
  end
  local pos = #self.equippedSkills + 1
  local skillItem = SkillItemData.new(skillid, pos, nil, nil, nil, pos)
  self.equippedSkills[pos] = skillItem
  if skillItem:CheckVertigoCount() then
    self.usedCount = 0
    skillItem:SetAllCount(2)
    skillItem:SetUsedCount(0)
  end
  if skillid == AttachSkillID and not self.initedCheckNPC then
    local skillInfo = Game.LogicManager_Skill:GetSkillInfo(AttachSkillID)
    local range = 0
    if skillInfo then
      range = skillInfo:GetLaunchRange(Game.Myself)
    end
    Game.Myself:LaunchHeartLockCheck(range)
    self.initedCheckNPC = true
  end
end

function SgAIManager:UpdateVertigoSkillCount(v)
  if not self.equippedSkills then
    return
  end
  for i = #self.equippedSkills, 1, -1 do
    local skillItem = self.equippedSkills[i]
    if skillItem and skillItem:CheckVertigoCount() then
      skillItem:SetAllCount(2)
      skillItem:SetUsedCount(v)
      if 2 <= v then
        skillItem.shadow = true
        table.remove(self.equippedSkills, i)
        break
      end
    end
  end
  EventManager.Me():PassEvent(StealthGameEvent.Skill_Update, self)
end

function SgAIManager:RemoveSkill(skillid)
  for i = #self.equippedSkills, 1, -1 do
    if self.equippedSkills[i].id == skillid then
      table.remove(self.equippedSkills, i)
      if skillid == AttachSkillID then
        Game.Myself:ShutDownHeartLockCheck()
        self.initedCheckNPC = false
      end
      return i
    end
  end
end

function SgAIManager:GetEquippedSkills()
  return self.equippedSkills
end

function SgAIManager:ClearSkills()
  if self.equippedSkills then
    TableUtility.TableClear(self.equippedSkills)
  end
  self.usedCount = 0
  self.currentAttachNPC = nil
  self.currentAttachNPCGUID = nil
  self.currentCarrying = nil
  self.status = true
  self.initedCheckNPC = false
  Game.Myself:ShutDownHeartLockCheck()
  local eventManager = EventManager.Me()
  eventManager:RemoveEventListener(MyselfEvent.StartToMove, self.CancelInsight, self)
end

function SgAIManager:PickNearest(skillinfo)
  if not self.m_npcList then
    return nil
  end
  local dis = skillinfo and skillinfo:GetLaunchRange()
  if not dis then
    return
  end
  local target
  local myPos = Game.Myself:GetPosition()
  for _, n in ipairs(self.m_npcList) do
    if not n:isDead() then
      local d = LuaVector3.Distance(myPos, n:getPosition())
      if dis >= d then
        target = n
      end
    end
  end
  return target
end

function SgAIManager:Client_UseSkill(skilltype, skillinfo)
  if not skilltype then
    return
  end
  if self.castTick then
    return
  end
  if self:playerIsDead() then
    return
  end
  local skillFunc = self.skillFuncMap[skilltype]
  if skillFunc then
    skillFunc(self, skillinfo)
  else
    redlog("skillFunc nil")
  end
end

function SgAIManager:ResetSkillEffect()
  self.m_possessedNpcId = nil
  self:CancelInsight()
  self:CancelPush()
  if self.ishiding then
    self:Handle_Hiding(false)
    EventManager.Me():PassEvent(StealthGameEvent.HideIn, false)
  end
  EventManager.Me():PassEvent(StealthGameEvent.Skill_CancelAttachNPC, self)
end

function SgAIManager:HandleSkill_Insight(skillinfo)
  self.insightRange = skillinfo and skillinfo:GetLaunchRange()
  FunctionSkill.Me():HandleSkill_Insight(skillinfo)
end

function SgAIManager:CancelInsight()
  FunctionSkill.Me():CancelInsight()
end

function SgAIManager:Handle_PushBox(npcid, triggerid)
  if not self.isCarrying then
    Game.Myself:Client_AddHugRole(npcid)
    self:pickUpBox(triggerid)
    self.isCarrying = true
    self.currentCarrying = triggerid
    self:setIsShowPushBoxOutLine(true)
    EventManager.Me():PassEvent(StealthGameEvent.CarryBox, true)
  end
end

function SgAIManager:CancelPush()
  if self.isCarrying and self.currentCarrying then
    local myself = Game.Myself
    myself:Client_RemoveHugRole()
    local myPos = myself:GetPosition()
    self:putDownBox(self.currentCarrying)
    local trigger = self:findNPCTrigger(self.currentCarrying)
    if trigger and trigger.SetBoxVisible then
      trigger:SetBoxVisible(true)
      trigger:Box_PlaceTo(myPos)
      self:setIsShowPushBoxOutLine(false)
    end
    self.isCarrying = false
    self.currentCarrying = nil
    EventManager.Me():PassEvent(StealthGameEvent.CarryBox, false)
  end
end

function SgAIManager:HandleSkill_Shooting(skillinfo)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.GunShootLocalPanel
  })
end

function SgAIManager:HandleSkill_AttachNPC(skillinfo)
  local myself = Game.Myself
  local targetNPC = self:PickNearest(skillinfo)
  if not targetNPC then
    redlog("no targetnpc")
    return
  end
  local myPos = myself:GetPosition()
  local delta = myPos - targetNPC:getPosition()
  local x, y, z = targetNPC:getForward()
  local dot = LuaVector3.Dot({
    x,
    y,
    z
  }, delta)
  if dot < 0 then
    self.currentAttachNPC = targetNPC.m_id
    self.currentAttachNPCGUID = targetNPC:getUid()
    self:CastBegin(skillinfo)
    self:onBeginUseSkill(targetNPC)
  else
    redlog("wrong direction")
  end
end

function SgAIManager:AttachSuccess()
  if self.lastAttachNPC then
    self:RemoveNPCSkill(self.lastAttachNPC)
  end
  if self.currentAttachNPC then
    self.lastAttachNPC = self.currentAttachNPC
  end
  self:AddNPCSkill(self.currentAttachNPC)
  local targetNPC
  for _, n in ipairs(self.m_npcList) do
    if not n:isDead() and n:getUid() == self.currentAttachNPCGUID then
      targetNPC = n
      break
    end
  end
  if targetNPC then
    targetNPC:onDead()
    if nil ~= self.m_attachPlotId then
      Game.PlotStoryManager:StopFreeProgress(self.m_attachPlotId, true)
    end
    EventManager.Me():PassEvent(StealthGameEvent.Skill_AttachNPC, self)
  end
end

function SgAIManager:CastBegin(skillinfo)
  local myself = Game.Myself
  if myself and skillinfo then
    self.castTime = skillinfo:GetCastInfo(myself)
    if self.castTime > 0 and not self.castTick then
      myself:Client_NoMove(true)
      EventManager.Me():PassEvent(StealthGameEvent.Skill_CastStart, {creature = myself, skill = skillinfo})
      self.castStartTime = ServerTime.CurServerTime()
      self.castTick = TimeTickManager.Me():CreateTick(0, 33, self.CastUpdate, self, 20)
      local playEnd = function()
        self.m_npcBreakPlotId = nil
      end
      if nil == self.m_npcBreakPlotId then
        self.m_npcBreakPlotId = Game.PlotStoryManager:Start_PQTLP("11100", playEnd, nil, nil, false, nil, nil, false)
      end
      local targetNPC
      for _, n in ipairs(self.m_npcList) do
        if not n:isDead() and n:getUid() == self.currentAttachNPCGUID then
          targetNPC = n
          break
        end
      end
      if targetNPC then
        targetNPC:getStateMachine():breakSwitch(AIBehaviourType.eEmpty)
      end
    end
  end
end

local deltaT = 0

function SgAIManager:CastUpdate()
  if self.isBreak then
    self:CastEnd(false)
  end
  deltaT = (ServerTime.CurServerTime() - self.castStartTime) / 1000
  if deltaT >= self.castTime then
    self:CastEnd(true)
  end
end

function SgAIManager:CastEnd(Success)
  local myself = Game.Myself
  if myself then
    if self.castTime > 0 then
      myself:Client_NoMove(false)
    end
    if self.castTick then
      TimeTickManager.Me():ClearTick(self, 20)
      self.castTick = nil
    end
    if Success then
      self:onUseSkillSuccess()
      self:AttachSuccess()
    else
      local targetNPC
      for _, n in ipairs(self.m_npcList) do
        if not n:isDead() and n:getUid() == self.currentAttachNPCGUID then
          targetNPC = n
          break
        end
      end
      if targetNPC then
        targetNPC:getStateMachine():switchLastState()
      end
      self.currentAttachNPC = nil
      self.currentAttachNPCGUID = nil
    end
    if nil ~= self.m_npcBreakPlotId then
      Game.PlotStoryManager:StopFreeProgress(self.m_npcBreakPlotId, true)
    end
  end
end

function SgAIManager:CancelAttachNPC()
  if self.castTick then
    return
  end
  self.m_possessedNpcId = nil
  self:RemoveNPCSkill(self.lastAttachNPC)
  self:playerRedress()
  EventManager.Me():PassEvent(StealthGameEvent.Skill_CancelAttachNPC, self)
  self.currentAttachNPC = nil
  self.currentAttachNPCGUID = nil
  if self.m_attachedUIClass ~= nil then
    self.m_attachedUIClass:onHide()
  end
  self:enableDogSkill(false)
end

function SgAIManager:AddNPCSkill(npcid)
  local single = npcid and Table_NPCAIxinsuo[npcid]
  if not single or #single.Transform_Skill == 0 then
    return
  end
  local skills = single.Transform_Skill
  for i = 1, #skills do
    self:AddSkill(skills[i])
  end
  EventManager.Me():PassEvent(StealthGameEvent.Skill_Update, self)
end

function SgAIManager:AddTriggerSkill(skillid)
  if skillid then
    self:AddSkill(skillid)
    EventManager.Me():PassEvent(StealthGameEvent.Skill_Update, self)
  end
end

function SgAIManager:RemoveNPCSkill(npcid)
  local single = npcid and Table_NPCAIxinsuo[npcid]
  if not single or #single.Transform_Skill == 0 then
    return
  end
  local skills = single.Transform_Skill
  for i = 1, #skills do
    self:RemoveSkill(skills[i])
  end
  EventManager.Me():PassEvent(StealthGameEvent.Skill_Update, self)
end

function SgAIManager:IsSkillEquipped(skillid)
end

function SgAIManager:HandleSkill_Vertigo(skillinfo)
  local targetNPC = self:PickNearest(skillinfo)
  if not targetNPC then
    return
  end
  self:setVertigoTime(VertigoTime)
  targetNPC:getStateMachine():breakSwitch(AIBehaviourType.eVertigo)
  self.usedCount = self.usedCount + 1
  self:UpdateVertigoSkillCount(self.usedCount)
  self:SkillEmitFire(Game.Myself, targetNPC, skillinfo)
  CDProxy.Instance:Client_AddSkillCD(skillinfo:GetSkillID(), ServerTime.CurServerTime() + 1000, 1, 1)
  GameFacade.Instance:sendNotification(SkillEvent.SkillStartEvent)
end

local tempVector3 = LuaVector3.Zero()

function SgAIManager:SkillEmitFire(creature, targetCreature, skillInfo)
  local fireEP = skillInfo:GetFireEP()
  LuaVector3.Better_Set(tempVector3, creature.assetRole:GetEPOrRootPosition(fireEP))
  local hitWorker = SkillHitWorker.Create()
  hitWorker:Init(skillInfo, creature:GetPosition(), creature.data and creature.data.id or 0, creature.assetRole:GetWeaponID())
  hitWorker:SetForceEffectPath(skillInfo:GetMainHitEffectPath(creature))
  hitWorker:AddTarget(targetCreature:getUid(), 1, 0, nil, nil, 0)
  local emitParams = skillInfo:GetEmitParams(creature)
  local args = SubSkillProjectile.GetArgs(emitParams, hitWorker, true, tempVector3, nil, 1, 1)
  Game.SkillWorkerManager:CreateWorker_SubSkillProjectile(args)
  SubSkillProjectile.ClearArgs(args)
end

function SgAIManager:HandleSkill_Barking(skillinfo)
  if self:isPossessed() then
    MsgManager.ShowMsgByID(42136)
    return
  end
  if self:IsHiding() then
    return
  end
  self:playerDogBarking(self.currentAttachNPCGUID)
end

function SgAIManager:Handle_Hiding(visible)
  local _Game = Game
  local myself = _Game.Myself
  if self.ishiding ~= visible then
    if visible then
      myself.assetRole:PlayEffectOneShotAt(EffectMap.Maps.Hiding_Eff, 2, nil, function()
        if nil == self.m_playerIsDead or false == self.m_playerIsDead then
          myself:SetVisible(false, LayerChangeReason.HidingSkill)
        end
      end)
    else
      myself:SetVisible(not visible, LayerChangeReason.HidingSkill)
    end
    myself:Client_NoMove(visible)
    self.ishiding = visible
    local trigger = self:getCurTrigger()
    if trigger ~= nil and not visible then
      trigger:setPlayerToBirth()
      self:setCurrentTrigger(-1)
    end
    if trigger then
      trigger:SetTopUIActive(visible)
      if trigger:getType() == SgTriggerType.eBurrow or trigger:getType() == SgTriggerType.ePainting then
        trigger:playSound(visible)
      end
    end
    self:isInvisible(visible)
  end
end

function SgAIManager:IsHiding()
  return self.ishiding == true
end

function SgAIManager:SetisInsight(v)
  self.isInsight = v
end

function SgAIManager:CheckNpcRange(range, myPos)
  if not range or not myPos then
    return
  end
  local dirty = false
  if self.isInsight then
    if self.m_beWatchedList == nil or #self.m_beWatchedList > 0 then
      self.m_beWatchedList = {}
    end
    local checkIsBeWatched = function(uid)
      for _, v in ipairs(self.m_beWatchedList) do
        if v == uid then
          return true
        end
      end
      return false
    end
    local addToBeWatched = function(uid)
      if not checkIsBeWatched(uid) then
        table.insert(self.m_beWatchedList, uid)
      end
    end
    for _, n in ipairs(self.m_npcList) do
      if not n:isDead() then
        for _, n2 in ipairs(self.m_npcList) do
          if not n2:isDead() and n ~= n2 and not checkIsBeWatched(n2:getUid()) then
            local pos = n2:getPosition()
            if n:inView(pos[1], pos[2], pos[3]) then
              addToBeWatched(n2:getUid())
            end
          end
        end
      end
    end
    for _, n in ipairs(self.m_npcList) do
      if not n:isDead() then
        local pos = n:getPosition()
        if LuaVector3.Distance(myPos, pos) <= self.insightRange then
          if not checkIsBeWatched(n:getUid()) then
            n:showOutLine("GreyOutlinePP", 0.611764705882353, 0.9921568627450981, 0.6039215686274509)
          else
            n:showOutLine("GreyOutlinePP", 0.9725490196078431, 0.35294117647058826, 0.35294117647058826)
          end
        end
      end
    end
  else
    local canShowList = {}
    for _, n in ipairs(self.m_npcList) do
      if not n:isDead() and range >= LuaVector3.Distance(myPos, n:getPosition()) then
        local delta = myPos - n:getPosition()
        local x, y, z = n:getForward()
        local dot = LuaVector3.Dot({
          x,
          y,
          z
        }, delta)
        if dot < 0 then
          dirty = true
          table.insert(canShowList, n:getUid())
        end
      end
    end
    local funcIsCanShow = function(uid)
      for _, v in ipairs(canShowList) do
        if uid == v then
          return true
        end
      end
      return false
    end
    for _, n in ipairs(self.m_npcList) do
      if not n:isDead() then
        if funcIsCanShow(n:getUid()) then
          n:showOutLine("OutLinePP", 0.7529411764705882, 0.7529411764705882, 0.7529411764705882)
        else
          n:hideOutLine()
        end
      end
    end
  end
  if dirty ~= self.status and not self:IsHiding() then
    self.status = dirty
    for i = 1, #self.equippedSkills do
      local skillItem = self.equippedSkills[i]
      if skillItem and skillItem.id == AttachSkillID then
        skillItem:SetShadow(not self.status)
      end
    end
    EventManager.Me():PassEvent(StealthGameEvent.Skill_Update, self)
  end
end

function SgAIManager:playerUseDoorItem(doorID, itemID, count)
  redlog("尝试装备门上的道具", doorID, itemID, count)
  if not self.playerDoorItemMap then
    self.playerDoorItemMap = {}
  end
  if not self.playerDoorItemMap[doorID] then
    self.playerDoorItemMap[doorID] = {}
  end
  local hasCount = self.m_playerItem[itemID] or 0
  local usedCount = math.min(hasCount, count)
  self:playerUseItem(itemID, usedCount)
  if not self.playerDoorItemMap[doorID][itemID] then
    self.playerDoorItemMap[doorID][itemID] = usedCount
  else
    self.playerDoorItemMap[doorID][itemID] = self.playerDoorItemMap[doorID][itemID] + usedCount
  end
  redlog("成功装备门上的道具", doorID, itemID, usedCount)
end

function SgAIManager:playerTakeOutDoorItem(doorID, itemID, count)
  redlog("尝试取出门上的道具", doorID, itemID, count)
  if not self.playerDoorItemMap then
    return
  end
  if not self.playerDoorItemMap[doorID] then
    return
  end
  local hasCount = self.playerDoorItemMap[doorID][itemID]
  if not hasCount then
    return
  end
  local takeOut = math.min(hasCount, count)
  self.playerDoorItemMap[doorID][itemID] = hasCount - takeOut
  self:playerAddItem(itemID, takeOut)
  redlog("成功取出门上的道具", doorID, itemID, takeOut)
end

function SgAIManager:isDoorEquipItem(doorID, itemID, count)
  if not self.playerDoorItemMap then
    return false
  end
  if not self.playerDoorItemMap[doorID] then
    return false
  end
  local hasCount = self.playerDoorItemMap[itemID]
  if not hasCount or count > hasCount then
    return false
  end
  return true
end

function SgAIManager:checkDoorCanEquip(doorID, needItemMap)
  if not needItemMap then
    return true
  end
  for itemID, count in pairs(needItemMap) do
    local hasCount = self.m_playerItem[itemID] or 0
    if count > hasCount then
      return false
    end
  end
  return true
end

function SgAIManager:checkDoorCanOpen(doorID, needItemMap)
  if not needItemMap then
    return true
  end
  if not self.playerDoorItemMap then
    return false
  end
  local equipItemMap = self.playerDoorItemMap[doorID]
  if not equipItemMap then
    return false
  end
  for itemID, count in pairs(needItemMap) do
    if not equipItemMap[itemID] or count > equipItemMap[itemID] then
      return false
    end
  end
  return true
end

function SgAIManager:RemoveLookAtEffect()
  if self.m_npcList then
    local myself = Game.Myself
    for _, n in ipairs(self.m_npcList) do
      myself:RemoveLookAtEffect(n:getUid())
    end
  end
end

function SgAIManager:getMaxAttachedDistance()
  if self.m_maxAttachedDistance == nil then
    return 0
  end
  return self.m_maxAttachedDistance
end

function SgAIManager:onTryUsePlayThePianoItem(uid)
  local trigger = self:findTrigger(uid)
  if trigger ~= nil and trigger:getType() == SgTriggerType.ePlayThePianoGame then
    trigger:onUseItem()
  end
end

function SgAIManager:onThePlayPinaoEnd(value)
  redlog("弹琴结束")
  if value.Success == 1 then
    local trigger = self:findTrigger(value.TriggerID)
    if trigger ~= nil then
      trigger:onPlaySuccess()
    end
  else
    if value.Success == 2 then
      self:onTryUsePlayThePianoItem(value.TriggerID)
    else
    end
  end
end

function SgAIManager:onLeave()
  self.m_leaveBattle = true
end

function SgAIManager:isDog(value)
  local tb = Table_NPCAIxinsuo[value]
  return tb ~= nil and tb.smell ~= nil and tb.smell > 0
end

function SgAIManager:isPossessedDog()
  return self.m_possessedNpcId ~= nil and self:isDog(self.m_possessedNpcId)
end

function SgAIManager:isPossessed()
  return self.currentAttachNPCGUID ~= nil
end

function SgAIManager:checkChildTriggerCompleted(_trigger)
  local tmp = _trigger.ChildTriggers
  for i = 1, #tmp do
    local id = math.modf(tmp[i])
    local trigger = self:findTrigger(id)
    if trigger ~= nil and not trigger:isCompleted() then
      return false
    end
  end
  return true
end

function SgAIManager:enableDogSkill(value)
  for i = #self.equippedSkills, 1, -1 do
    local skillItem = self.equippedSkills[i]
    if skillItem and skillItem:CheckDog() then
      skillItem.shadow = value
      break
    end
  end
  EventManager.Me():PassEvent(StealthGameEvent.Skill_Update, self)
end

function SgAIManager:onEnableAttachedUI(value)
  if self.m_attachedUIClass ~= nil and self.m_attachedUIClass:isShow() then
    if value then
      self.m_attachedUIClass:enable()
    else
      self.m_attachedUIClass:disable()
    end
  end
end

function SgAIManager:npcResetBirth(value)
  if self.m_resetBirthNpcList == nil then
    self.m_resetBirthNpcList = {}
  end
  if not self:isResetBirth(value) then
    table.insert(self.m_resetBirthNpcList, value)
  end
end

function SgAIManager:isResetBirth(value)
  if self.m_resetBirthNpcList == nil then
    return false
  end
  for _, v in ipairs(self.m_resetBirthNpcList) do
    if v == value then
      return true
    end
  end
  return false
end

function SgAIManager:resetAll()
  local raidId = SceneProxy.Instance:GetCurRaidID()
  if self.playerDoorItemMap then
    local goMgr = Game.GameObjectManagers[Game.GameObjectType.StealthGame]
    for doorId, itemid in pairs(self.playerDoorItemMap) do
      self.playerDoorItemMap[doorId] = nil
      goMgr:DisplayDoorEquipPlot(doorId)
    end
  end
  local enterSwitchAnim = GameConfig.HeartLock.EnterSwitchStateAnim
  enterSwitchAnim = enterSwitchAnim and enterSwitchAnim[raidId]
  if enterSwitchAnim then
    local goMgr = Game.GameObjectManagers[Game.GameObjectType.StealthGame]
    for objID, animName in pairs(enterSwitchAnim) do
      local obj = goMgr:GetObject(objID)
      if obj and obj.components and obj.components[1] then
        obj.components[1]:Play(animName)
      end
    end
  end
  self:recordHistoryData(nil, true)
  local enterTrigger = GameConfig.HeartLock.EnterTriggerId
  local triggerId = enterTrigger and enterTrigger[raidId]
  Game.PlotStoryManager:Start_PQTLP("10180", function()
    self:setHistoryData()
    self.m_alreadyVisitedTrigger[1] = triggerId
    self:LaunchSkill()
    self:onRestart()
  end, nil, nil, false, nil, {
    myself = Game.Myself.data.id
  }, false)
end
