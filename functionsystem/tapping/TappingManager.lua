TappingManager = class("TappingManager")
local TappingType = {NPC = 1, POS = 2}
local CondType = {
  LT_MIN = 1,
  GT_MAX = 2,
  STAY_TIME = 4
}
local Distance_Square = LuaVector3.Distance_Square
local outCircleColor = Color(0, 0.25098039215686274, 1, 1)
local circleOffset = LuaVector3(0, 0.14, 0)

function TappingManager.Me()
  if not TappingManager.Instance then
    TappingManager.Instance = TappingManager.new()
  end
  return TappingManager.Instance
end

function TappingManager:ctor()
  self.questMap = {}
  self.effectMap = {}
end

function TappingManager:AddEventListener()
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddNpcs, self.OnSceneAddNpcs, self)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneRemoveNpcs, self.OnSceneRemoveNpcs, self)
end

function TappingManager:RemoveEventListener()
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddNpcs, self.OnSceneAddNpcs, self)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneRemoveNpcs, self.OnSceneRemoveNpcs, self)
end

function TappingManager:StartTappingQuest(questData)
  self.questMap[questData.id] = questData.id
  local params = questData.params
  local type = params.type
  local minRange = params.range[1]
  local maxRange = params.range[2]
  local hideEffect = params.hideEffect
  if not hideEffect or hideEffect == 0 then
    if type == TappingType.NPC then
      local npcId = params.npcid
      self:AddNpcEffect(questData.id, npcId, params.uniqueid, minRange, maxRange)
    elseif type == TappingType.POS then
      local pos = params.pos
      self:AddSceneEffect(questData.id, pos, minRange, maxRange)
    end
  end
end

function TappingManager:EndTappingQuest(questId)
  if self.questMap[questId] then
    self.questMap[questId] = nil
    if self.curQuestId == questId then
      self:ClearTappingProgress()
    end
  end
end

function TappingManager:AddNpcEffect(questId, npcId, uniqueId, minRange, maxRange)
  local npcs = NSceneNpcProxy.Instance:FindNpcs(npcId)
  if npcs then
    local npc
    if uniqueId and uniqueId ~= 0 then
      npc = TableUtility.ArrayFindByPredicate(npcs, function(npc, arg)
        return npc.data.uniqueid == arg
      end, uniqueId)
    else
      if 1 < #npcs then
        redlog("more than one npc with the same npcid, but no uniqueid!!!npcid =", tostring(npcId))
        return
      end
      npc = npcs[1]
    end
    if npc then
      local effects = self.effectMap[npc.data.id]
      if not effects then
        effects = {}
        self.effectMap[npc.data.id] = effects
      end
      local effect1 = npc.assetRole:PlayEffectOn(EffectMap.Maps.VisionScope, RoleDefines_EP.Bottom, circleOffset, function(obj, args, effect)
        self:OnTappingEffectAdd(obj, minRange, ColorUtil.NGUILabelRed)
      end)
      effects[#effects + 1] = effect1
      local effect2 = npc.assetRole:PlayEffectOn(EffectMap.Maps.VisionScope, RoleDefines_EP.Bottom, circleOffset, function(obj, args, effect)
        self:OnTappingEffectAdd(obj, maxRange, outCircleColor)
      end)
      effects[#effects + 1] = effect2
    end
  end
end

function TappingManager:AddSceneEffect(questId, pos, minRange, maxRange)
  pos[2] = pos[2] + circleOffset[2]
  NSceneEffectProxy.Instance:Client_AddSceneEffect(questId .. "_1", pos, EffectMap.Maps.VisionScope, nil, nil, nil, nil, function(obj, args, effect)
    self:OnTappingEffectAdd(obj, minRange, ColorUtil.NGUILabelRed)
  end)
  NSceneEffectProxy.Instance:Client_AddSceneEffect(questId .. "_2", pos, EffectMap.Maps.VisionScope, nil, nil, nil, nil, function(obj, args, effect)
    self:OnTappingEffectAdd(obj, maxRange, outCircleColor)
  end)
end

function TappingManager:OnTappingEffectAdd(obj, radius, color)
  local circleDrawer = obj:GetComponent(CircleDrawer)
  if not circleDrawer then
    return
  end
  circleDrawer.radius = radius
  local lineRenderer = circleDrawer.renderer
  if lineRenderer and color then
    lineRenderer.startColor = color
    lineRenderer.endColor = color
  end
  circleDrawer:Draw()
end

function TappingManager:RemoveNpcEffect(guid)
  local effects = self.effectMap[guid]
  if effects then
    TableUtility.ArrayClearByDeleter(effects, function(effect)
      if effect:Alive() then
        effect:Destroy()
      end
    end)
    self.effectMap[guid] = nil
  end
end

function TappingManager:RemoveSceneEffect(questId)
  NSceneEffectProxy.Instance:Client_RemoveSceneEffect(questId .. "_1")
  NSceneEffectProxy.Instance:Client_RemoveSceneEffect(questId .. "_2")
end

function TappingManager:CheckTapping(questData, pos, curTime, roleId, params)
  if roleId and 0 < roleId then
    local npcs = NSceneNpcProxy.Instance:FindNpcs(roleId)
    if npcs then
      for i = 1, #npcs do
        local role = npcs[i]
        if self:CheckRole(questData, role, pos, curTime, params) then
          return true
        end
      end
    end
  else
    local role = Game.Myself
    return self:CheckRole(questData, role, pos, curTime, params)
  end
end

function TappingManager:CheckRole(questData, role, pos, curTime, params)
  local sqrDis = Distance_Square(role:GetPosition(), pos)
  local minRange = params.range[1]
  local maxRange = params.range[2]
  local sqrMinRange = minRange * minRange
  local sqrMaxRange = maxRange * maxRange
  local finishCond = params.finishCond or CondType.STAY_TIME
  local failCond = params.failCond or CondType.LT_MIN
  if sqrDis > sqrMinRange and sqrDis <= sqrMaxRange then
    self.curQuestId = questData.id
    if finishCond == CondType.STAY_TIME or failCond == CondType.STAY_TIME then
      local stayTime = params.stayTime
      local hideSceneUI = params.hideSceneUI
      local msg = params.msg
      local state
      if finishCond == CondType.STAY_TIME then
        state = questData.staticData.FinishJump
      else
        state = questData.staticData.FailJump
      end
      if not self.tappingStartTime then
        self.tappingStartTime = curTime
        if not hideSceneUI or hideSceneUI == 0 then
          self:ShowTappingProgressSceneUI(role, stayTime, msg)
        end
      end
      local interval = curTime - self.tappingStartTime
      if stayTime <= interval then
        self:NotifyQuestState(questData.scope, questData.id, state)
        return true
      end
    end
  elseif sqrDis <= sqrMinRange then
    if finishCond == CondType.LT_MIN then
      self:NotifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
      return true
    elseif failCond == CondType.LT_MIN then
      self:NotifyQuestState(questData.scope, questData.id, questData.staticData.FailJump)
      return true
    else
      self:ClearTappingProgress()
    end
  elseif finishCond == CondType.GT_MAX then
    self:NotifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
    return true
  elseif failCond == CondType.GT_MAX then
    self:NotifyQuestState(questData.scope, questData.id, questData.staticData.FailJump)
    return true
  else
    self:ClearTappingProgress()
  end
end

function TappingManager:NotifyQuestState(scope, questId, state)
  QuestProxy.Instance:notifyQuestState(scope, questId, state)
  self.questMap[questId] = nil
  self:ClearTappingProgress()
end

function TappingManager:ShowTappingProgressSceneUI(role, time, msg)
  local sceneUI = role:GetSceneUI()
  if sceneUI then
    self.topSingUI = sceneUI.roleTopUI:createOrGetTopSingUI()
    if self.topSingUI then
      self.topSingUI.id = role.data.id
      self.topSingUI.processTime = time
      self.topSingUI:SetActive(true)
      self.topSingUI:startProcess()
      if msg then
        self.speakUI = sceneUI.roleTopUI:SpeakSkill(msg, nil, time * 1000)
      end
    end
  end
end

function TappingManager:ClearTappingProgress()
  if self.topSingUI then
    self.topSingUI:stopProcess()
    self.topSingUI = nil
  end
  if self.speakUI then
    self.speakUI:SetActive(false)
    self.speakUI = nil
  end
  self.tappingStartTime = nil
  self.curQuestId = nil
end

function TappingManager:Launch()
  self.isrunning = true
  self:AddEventListener()
end

function TappingManager:Shutdown()
  self.isrunning = false
  self:RemoveEventListener()
  self:ClearTappingProgress()
end

function TappingManager:Update(time, deltaTime)
  if not self.isrunning then
    return
  end
  for questId, _ in pairs(self.questMap) do
    if not self.curQuestId or self.curQuestId == questId then
      local questData = QuestProxy.Instance:getQuestDataByIdAndType(questId)
      if questData then
        local params = questData.params
        local type = params.type
        local hideEffect = params.hideEffect
        local roleId = params.roleid
        if type == TappingType.NPC then
          local npcId = params.npcid
          local npcs = NSceneNpcProxy.Instance:FindNpcs(npcId)
          if npcs then
            for j = 1, #npcs do
              local npc = npcs[j]
              local result = self:CheckTapping(questData, npc:GetPosition(), time, roleId, params)
              if result and (not hideEffect or hideEffect == 0) then
                self:RemoveNpcEffect(npc.data.id)
              end
            end
          end
        elseif type == TappingType.POS then
          local pos = params.pos
          local result = self:CheckTapping(questData, pos, time, roleId, params)
          if result and (not hideEffect or hideEffect == 0) then
            self:RemoveSceneEffect(questId)
          end
        end
      end
    end
  end
end

function TappingManager:OnSceneAddNpcs(npcs)
  for questId, _ in pairs(self.questMap) do
    local questData = QuestProxy.Instance:getQuestDataByIdAndType(questId)
    if questData then
      local params = questData.params
      if not params.hideEffect or params.hideEffect == 0 then
        local minRange = params.range[1]
        local maxRange = params.range[2]
        if params.type == TappingType.NPC then
          local npcId = params.npcid
          local uniqueId = params.uniqueid
          local args = ReusableTable.CreateArray()
          args[1] = npcId
          args[2] = uniqueId or 0
          if TableUtility.ArrayFindByPredicate(npcs, function(npc, args)
            return npc.data.staticData.id == args[1] and npc.data.uniqueid == args[2]
          end, args) then
            self:AddNpcEffect(questId, npcId, uniqueId, minRange, maxRange)
          end
          ReusableTable.DestroyArray(args)
        end
      end
    end
  end
end

function TappingManager:OnSceneRemoveNpcs(npcs)
  for i = 1, #npcs do
    local guid = npcs[i]
    self:RemoveNpcEffect(guid)
  end
end
