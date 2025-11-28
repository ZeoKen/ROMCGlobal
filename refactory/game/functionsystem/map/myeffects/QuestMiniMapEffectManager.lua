QuestMiniMapEffectManager = class("QuestMiniMapEffectManager")
local tempVector3 = LuaVector3.Zero()
local tempVector3_2 = LuaVector3.Zero()
local GuidePos = LuaVector3.Zero()
local GuideInterval = 3.5
local GuideMaxCount = 10
local GuideEffectPath = "Common/cfx_task_guide_prf"
local ParallelEffectMap = GameConfig.Quest.ParallelEffectMap

function QuestMiniMapEffectManager:ctor()
  self.deltaTime = 0
  self.guideTime = 0
  self.questMap = {}
  self.guideEffects = {}
  self._effectPath = EffectMap.Maps.TaskAperture
  self._effectPath2 = "Common/113TaskAperture_map"
  self.myPos = LuaVector3.Zero()
end

function QuestMiniMapEffectManager:Launch()
  if self.running then
    return
  end
  self.running = true
end

function QuestMiniMapEffectManager:RemoveQuestEffect(id)
  local map = self.questMap[id]
  if map then
    WorldMapProxy.Instance:RemoveCurQuestPosData(id)
    GameFacade.Instance:sendNotification(MainViewEvent.RemoveQuestFocus, id)
    ReusableTable.DestroyAndClearArray(self.questFocus)
    self.questFocus = nil
    self:HideCircleArea(id)
    self:HideEffect(id)
    TableUtility.TableClear(map)
    self.questMap[id] = nil
  end
end

function QuestMiniMapEffectManager:TryRemoveOtherQuest(excludeID)
  for k, v in pairs(self.questMap) do
    if k ~= excludeID then
      self:RemoveQuestEffect(k)
    end
  end
end

function QuestMiniMapEffectManager:AddQuestEffect(id, showLight)
  if ParallelEffectMap and TableUtility.ArrayFindIndex(ParallelEffectMap, Game.MapManager:GetMapID()) > 0 then
  else
    self:TryRemoveOtherQuest(id)
  end
  local map = self.questMap[id]
  if map then
    map.hasNotifiy = false
  else
    map = {
      effect = nil,
      hasNotifiy = false,
      creating = false,
      creatingLight = false,
      isShow = false,
      id = id,
      showLight = showLight or false
    }
    self.questMap[id] = map
    self:Update(UnityTime)
  end
end

function QuestMiniMapEffectManager:Shutdown()
  if not self.running then
    return
  end
  for i = #self.guideEffects, 1, -1 do
    self.guideEffects[i]:Destroy()
    self.guideEffects[i] = nil
  end
  self.running = false
  self:_DestroyEffect()
  self.guideWorkCount = 0
  self.guideTime = 0
  self.guideEffectHidingTime = nil
  self.curGuideShow = nil
  self.corners = nil
  self.distance = nil
end

function QuestMiniMapEffectManager:Update(time, deltaTime)
  if not self.running or Game.EffectManager:IsFiltered() then
    return
  end
  if not next(self.questMap) then
    return
  end
  if self.guideEffectHidingTime and time > self.guideEffectHidingTime then
    self.guideEffectHidingTime = nil
    if self.curGuideShow then
      self:UpdateGuideEffect()
    else
      self:HideGuideEffect()
    end
  end
  if self.deltaTime < 1 and deltaTime then
    self.deltaTime = self.deltaTime + deltaTime
    return
  end
  self.deltaTime = 0
  for k, v in pairs(self.questMap) do
    if not v.hasNotifiy then
      local id = k
      local pos, epId, tarMapId = FunctionQuestDisChecker.Me():getTargetPos(id)
      if epId and pos then
        if not Game.AreaTrigger_ExitPoint:IsInvisible(epId) then
          self:ShowEffect(id, pos)
        else
          self:HideEffect(id)
        end
        self:HideCircleArea(id)
      elseif pos then
        self:ShowEffect(id, pos, tarMapId)
        local curMapId = Game.MapManager:GetMapID()
        if curMapId == tarMapId then
          self:ShowCircleArea(id, pos)
        else
          self:HideCircleArea(id)
        end
      else
        self:HideEffect(id)
        self:HideCircleArea(id)
        self:HideGuideEffect()
      end
    end
    if v.lightEffect then
      if v.lightEffectHidingTime then
        if time > v.lightEffectHidingTime then
          v.lightEffectHidingTime = nil
          self:SetShowLightEffect(v, v.curLightShow)
        end
      elseif LuaVector3.Distance_Square(GuidePos, Game.Myself:GetPosition()) > 50 then
        self:SetShowLightEffect(v, true)
      else
        self:SetShowLightEffect(v, false)
      end
    end
  end
  if self.guideEffectHidingTime == nil then
    if time < self.guideTime then
      local myself = Game.Myself
      if myself:IsMoving() then
        local distance = LuaVector3.Distance_Square(myself:GetPosition(), GuidePos)
        if distance < self.distance then
          self:RefreshGuideEffect(distance)
        end
      elseif LuaVector3.Distance_Square(self.myPos, myself:GetPosition()) > 2 then
        self:SetShowGuideEffect(true)
      end
    elseif self.guideTime ~= 0 then
      self.guideTime = 0
      self:SetShowGuideEffect(false)
    end
  end
end

function QuestMiniMapEffectManager:_DestroyEffect()
  for k, v in pairs(self.questMap) do
    self:RemoveQuestEffect(k)
  end
end

function QuestMiniMapEffectManager:ShowMiniMapDirEffect(id)
  local map = self.questMap[id]
  if map and map.isShow then
    GameFacade.Instance:sendNotification(MiniMapEvent.ShowMiniMapDirEffect, id)
  end
end

function QuestMiniMapEffectManager:HideEffect(id)
  local map = self.questMap[id]
  if map then
    if map.effect then
      map.effect:Destroy()
      map.effect = nil
    end
    if map.lightEffect then
      map.lightEffect:Destroy()
      map.lightEffect = nil
      map.lightEffectHidingTime = nil
      map.curLightShow = nil
    end
    map.isShow = false
    map.hasNotifiy = false
    ReusableTable.DestroyAndClearArray(self.questFocus)
    self.questFocus = nil
    WorldMapProxy.Instance:RemoveCurQuestPosData(id)
    GameFacade.Instance:sendNotification(MainViewEvent.RemoveQuestFocus, id)
  end
end

local mEffectTempV3 = LuaVector3.Zero()

function QuestMiniMapEffectManager:ShowEffect(id, pos, tarMapId)
  local map = self.questMap[id]
  if map then
    if pos then
      local questData = QuestProxy.Instance:getQuestDataByIdAndType(id)
      if not questData then
        return
      end
      local effectPos = mEffectTempV3
      LuaVector3.Better_Set(effectPos, pos[1], pos[2], pos[3])
      if not questData.params or questData.params.ignorenavmesh ~= 1 then
        NavMeshUtility.SelfSample(effectPos)
      end
      map.isShow = true
      local hideSymbol
      local curMapId = Game.MapManager:GetMapID()
      if questData.params and questData.params.circle == 1 and curMapId == tarMapId then
        hideSymbol = true
      end
      if not hideSymbol then
        if not map.effect then
          map.effect = Asset_Effect.PlayAt(self._effectPath, LuaGeometry.GetTempVector3(-9999, -9999, -9999))
        end
        map.effect:ResetLocalPosition(effectPos)
      elseif map.effect then
        map.effect:Destroy()
        map.effect = nil
      end
      if map.showLight then
        if questData.params and questData.params.BeamPos then
          local beamPos = questData.params.BeamPos
          LuaVector3.Better_Set(GuidePos, beamPos[1], beamPos[2], beamPos[3])
        else
          LuaVector3.Better_Set(GuidePos, effectPos[1], effectPos[2], effectPos[3])
        end
        if not map.lightEffect then
          map.lightEffect = Asset_Effect.PlayAt(self._effectPath2, LuaGeometry.GetTempVector3(-9999, -9999, -9999))
        end
        map.lightEffect:ResetLocalPosition(GuidePos)
        if not ParallelEffectMap or TableUtility.ArrayFindIndex(ParallelEffectMap, curMapId) == 0 then
          self:CreateGuideEffect()
        end
      elseif map.lightEffect then
        map.lightEffect:Destroy()
        map.lightEffect = nil
      end
      if not self.questFocus then
        self.questFocus = ReusableTable.CreateArray()
      end
      self.questFocus[1] = id
      self.questFocus[2] = effectPos
      self.questFocus[3] = hideSymbol
      WorldMapProxy.Instance:SetCurQuestPosData(id, effectPos)
      GameFacade.Instance:sendNotification(MainViewEvent.AddQuestFocus, self.questFocus)
      map.hasNotifiy = true
      FunctionGuide.Me():AddMapGuide(questData)
    else
      self:HideEffect(id)
    end
  end
end

function QuestMiniMapEffectManager:ShowCircleArea(id, pos)
  local questData = QuestProxy.Instance:getQuestDataByIdAndType(id)
  if not questData then
    return
  end
  if questData.params.circle == 1 then
    local radius = questData.params.radius
    if radius then
      if not self.circleMap then
        self.circleMap = {}
      end
      local array = self.circleMap[id]
      if not array then
        array = {}
        self.circleMap[id] = array
      end
      array[1] = id
      array[2] = pos
      array[3] = radius
      array[4] = questData.params.circlecolor or 1
      GameFacade.Instance:sendNotification(MiniMapEvent.AddCircleArea, self.circleMap[id])
    else
      redlog("缺少radius字段！")
    end
  end
end

function QuestMiniMapEffectManager:HideCircleArea(id)
  if self.circleMap and self.circleMap[id] then
    self.circleMap[id] = nil
  end
  GameFacade.Instance:sendNotification(MiniMapEvent.RemoveCircleArea, id)
end

function QuestMiniMapEffectManager:GetShowingCircleAreaMap()
  return self.circleMap
end

function QuestMiniMapEffectManager:SetEffectVisible(isVisible, id)
  local map = self.questMap[id]
  if not map or Slua.IsNull(map.effectObj) then
  else
    map.effectObj:SetActive(isVisible)
  end
end

function QuestMiniMapEffectManager:CreateGuideEffect()
  self.guideTime = UnityTime + 30
  self:UpdateGuideEffect()
end

function QuestMiniMapEffectManager:UpdateGuideEffect()
  self.myPos:SetPos(Game.Myself:GetPosition())
  tempVector3:SetPos(self.myPos)
  self.distance = LuaVector3.Distance_Square(self.myPos, GuidePos)
  local canArrive, path = NavMeshUtils.CanArrived(tempVector3, GuidePos, WorldTeleport.DESTINATION_VALID_RANGE, true, nil)
  if canArrive then
    self.guideWorkCount = 0
    self.corners = path.corners
    self.cornerIndex = 2
    for i = 2, self.corners.Length do
      LuaVector3.Better_Sub(self.corners[i], self.corners[i - 1], tempVector3_2)
      LuaVector3.Normalized(tempVector3_2)
      LuaVector3.Mul(tempVector3_2, GuideInterval)
      local angleY = VectorHelper.GetAngleByAxisY(self.corners[i - 1], self.corners[i])
      while LuaVector3.Distance(tempVector3, self.corners[i]) > GuideInterval and self.guideWorkCount < GuideMaxCount do
        self.guideWorkCount = self.guideWorkCount + 1
        tempVector3:Add(tempVector3_2)
        local effect = self.guideEffects[self.guideWorkCount]
        if effect == nil then
          effect = Asset_Effect.PlayAt(GuideEffectPath, tempVector3)
          self.guideEffects[self.guideWorkCount] = effect
        else
          effect:ResetLocalPosition(tempVector3)
          effect:SetActive(true)
        end
        effect:ResetLocalEulerAnglesXYZ(0, angleY, 0)
        self.cornerIndex = i
      end
    end
    self:ShowGuideEffect(true)
    for i = self.guideWorkCount + 1, #self.guideEffects do
      self.guideEffects[i]:SetActive(false)
    end
  end
end

function QuestMiniMapEffectManager:RefreshGuideEffect(distance)
  local dirtys = {}
  for i = 1, self.guideWorkCount do
    if distance < LuaVector3.Distance_Square(self.guideEffects[i]:GetLocalPosition(), GuidePos) then
      dirtys[#dirtys + 1] = i
    end
  end
  if self.corners ~= nil then
    local index = 0
    for i = self.cornerIndex, self.corners.Length do
      LuaVector3.Better_Sub(self.corners[i], self.corners[i - 1], tempVector3_2)
      LuaVector3.Normalized(tempVector3_2)
      LuaVector3.Mul(tempVector3_2, GuideInterval)
      local angleY = VectorHelper.GetAngleByAxisY(self.corners[i - 1], self.corners[i])
      while LuaVector3.Distance(tempVector3, self.corners[i]) > GuideInterval and index < #dirtys do
        index = index + 1
        tempVector3:Add(tempVector3_2)
        local effect = self.guideEffects[dirtys[index]]
        if effect ~= nil then
          effect:ResetLocalPosition(tempVector3)
        end
        effect:ResetLocalEulerAnglesXYZ(0, angleY, 0)
        self.cornerIndex = i
      end
    end
  end
end

function QuestMiniMapEffectManager:SetShowGuideEffect(isShow)
  self.curGuideShow = isShow
  self.guideEffectHidingTime = UnityTime + 0.5
  self:ShowGuideEffect(false)
end

function QuestMiniMapEffectManager:ShowGuideEffect(isShow)
  local name = isShow and "cfx_task_guide_state1001" or "cfx_task_guide_state2001"
  for i = 1, self.guideWorkCount do
    self.guideEffects[i]:ResetAction(name, 0, true)
  end
end

function QuestMiniMapEffectManager:HideGuideEffect()
  if self.curGuideShow then
    for i = 1, self.guideWorkCount do
      self.guideEffects[i]:SetActive(false)
    end
  end
end

function QuestMiniMapEffectManager:SetShowLightEffect(map, isShow)
  if not (map and map.lightEffect) or map.curLightShow == isShow then
    return
  end
  map.curLightShow = isShow
  map.lightEffectHidingTime = UnityTime + 0.5
  isShow = isShow and self.filterEnable ~= true
  local name = isShow and "cfx_113tasck_map_stat001" or "cfx_113tasck_map_state2001"
  map.lightEffect:ResetAction(name, 0, true)
end

function QuestMiniMapEffectManager:_OnFilter_SetShowLightEffect(map)
  if not map or not map.lightEffect then
    return
  end
  local isShow = map.curLightShow
  map.lightEffectHidingTime = UnityTime + 0.5
  isShow = isShow and self.filterEnable ~= true
  local name = isShow and "cfx_113tasck_map_stat001" or "cfx_113tasck_map_state2001"
  map.lightEffect:ResetAction(name, 0, true)
  map.lightEffect:SetActive(isShow)
end

function QuestMiniMapEffectManager:SetFilterEnable(isTrue)
  self.filterEnable = isTrue
  for k, v in pairs(self.questMap) do
    self:_OnFilter_SetShowLightEffect(v)
  end
end
