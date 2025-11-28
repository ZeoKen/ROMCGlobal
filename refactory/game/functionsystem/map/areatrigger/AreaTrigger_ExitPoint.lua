AreaTrigger_ExitPoint = class("AreaTrigger_ExitPoint")
local UpdateInterval = 0.1
local Resume_SyncMove_time = 1
local EffectPathMap = GameConfig.EffectPath.SceneExitEffectPath

function AreaTrigger_ExitPoint:ctor()
  self.invisibleEPMap = {}
  self.eps = {}
  self.epEffects = {}
  self.epCullVisibleDataMap = {}
  self.resumeSyncMoveFlag = 0
  self:_Reset()
end

function AreaTrigger_ExitPoint:_Reset()
  TableUtility.ArrayClear(self.eps)
  TableUtility.ArrayClear(self.epEffects)
  TableUtility.TableClear(self.invisibleEPMap)
  TableUtility.TableClear(self.epCullVisibleDataMap)
  self.currentEP = nil
  self.nextUpdateTime = 0
  self.onlyEPID = nil
  self.disable = 0
  self:ResumeSyncMove()
end

local OnEffectCreated = function(effectHandler, ep)
  Game.AreaTrigger_ExitPoint:_OnEffectCreated(effectHandler, ep)
end

function AreaTrigger_ExitPoint:_OnEffectCreated(effectHandler, ep)
end

function AreaTrigger_ExitPoint:_AddEP(ep)
  TableUtility.ArrayPushBack(self.eps, ep)
  local effectPath = EffectPathMap and EffectPathMap[ep.commonEffectID]
  if not effectPath then
    return
  end
  local effect = Asset_Effect.PlayAt(effectPath, ep.position, OnEffectCreated, ep)
  TableUtility.ArrayPushBack(self.epEffects, effect)
end

function AreaTrigger_ExitPoint:_RemoveEP(i)
  local ep = self.eps[i]
  local effect = self.epEffects[i]
  table.remove(self.eps, i)
  table.remove(self.epEffects, i)
  effect:Destroy()
end

function AreaTrigger_ExitPoint:IsInvisible(id)
  return true == self.invisibleEPMap[id]
end

function AreaTrigger_ExitPoint:SetInvisibleEPs(epArray)
  TableUtility.TableClear(self.invisibleEPMap)
  if nil ~= epArray and 0 < #epArray then
    for i = 1, #epArray do
      self.invisibleEPMap[epArray[i]] = true
    end
  end
end

function AreaTrigger_ExitPoint:SetEPEnable(epID, enable)
  if self.running then
    if enable then
      if self.invisibleEPMap[epID] then
        self.invisibleEPMap[epID] = false
        local epMap = Game.MapManager:GetExitPointMap()
        local ep = epMap[epID]
        if nil ~= ep then
          self:_AddEP(ep)
        end
      end
    elseif not self.invisibleEPMap[epID] then
      local epMap = Game.MapManager:GetExitPointMap()
      local ep = epMap[epID]
      if nil ~= ep then
        local i = TableUtility.ArrayFindIndex(self.eps, ep)
        if 0 < i then
          self.invisibleEPMap[epID] = true
          self:_RemoveEP(i)
        end
      end
    end
  else
    self.invisibleEPMap[epID] = not enable
  end
end

function AreaTrigger_ExitPoint:CullingStateChange(epID, isVisible, currentDistance)
  if nil == isVisible then
    return
  end
  self.epCullVisibleDataMap[epID] = isVisible
  local eps = self.eps
  if 0 < #eps then
    for i = 1, #eps do
      local ep = eps[i]
      if epID == ep.ID then
        local epEffect = self.epEffects[i]
        if nil ~= epEffect then
          epEffect:SetActive(0 ~= isVisible and self.filterEnable ~= true)
        end
        return
      end
    end
  end
end

function AreaTrigger_ExitPoint:SetFilterEnable(isTrue)
  self.filterEnable = isTrue
  local eps = self.eps
  for i = 1, #eps do
    local ep = eps[i]
    local epId = ep.ID
    local isVisible = self.epCullVisibleDataMap[epId] or 1
    local epEffect = self.epEffects[i]
    if nil ~= epEffect then
      epEffect:SetActive(0 ~= isVisible and self.filterEnable ~= true)
    end
  end
end

function AreaTrigger_ExitPoint:SetOnlyEP(epID)
  self.onlyEPID = epID
end

function AreaTrigger_ExitPoint:ClearOnlyEP()
  self.onlyEPID = nil
end

function AreaTrigger_ExitPoint:SetDisable(disable)
  if disable then
    self.disable = self.disable + 1
  else
    self.disable = self.disable - 1
  end
end

function AreaTrigger_ExitPoint:Launch()
  if self.running then
    return
  end
  self.running = true
  local curMapId
  local curImageId = ServicePlayerProxy.Instance:GetCurMapImageId()
  if curImageId ~= 0 then
    curMapId = curImageId
  end
  local epArray = Game.MapManager:GetExitPointArray(curMapId)
  if nil ~= epArray and 0 < #epArray then
    for i = 1, #epArray do
      local ep = epArray[i]
      if not self.invisibleEPMap[ep.ID] then
        self:_AddEP(ep)
      end
    end
  end
end

function AreaTrigger_ExitPoint:Shutdown()
  if not self.running then
    return
  end
  self.running = false
  for i = 1, #self.epEffects do
    local effect = self.epEffects[i]
    effect:Destroy()
  end
  self:_Reset()
end

function AreaTrigger_ExitPoint:Update(time, deltaTime)
  if not self.running then
    return
  end
  if time < self.nextUpdateTime then
    return
  end
  self.nextUpdateTime = time + UpdateInterval
  if self.resumeSyncMoveFlag > 0 and time >= self.resumeSyncMoveFlag then
    self:ResumeSyncMove()
  end
  local myselfPosition = Game.Myself:GetPosition()
  if nil ~= self.currentEP then
    local distance = VectorUtility.DistanceXZ_Square(myselfPosition, self.currentEP.position)
    if distance < self.currentEP.range * self.currentEP.range then
      return
    else
      self.currentEP = nil
    end
  end
  local eps = self.eps
  if 0 < #eps then
    for i = 1, #eps do
      local ep = eps[i]
      local distance = VectorUtility.DistanceXZ_Square(myselfPosition, ep.position)
      if distance < ep.range * ep.range then
        self.currentEP = ep
        LogUtility.InfoFormat("<color=blue>Enter Exit Point: </color>{0}, {1}, {2}", ep.ID, self.disable, self.onlyEPID)
        if 0 < self.disable then
          if nil ~= self.onlyEPID and self.onlyEPID == ep.ID then
            self:EnterExitRange(ep)
          end
          break
        end
        self:EnterExitRange(ep)
        break
      end
    end
  end
end

function AreaTrigger_ExitPoint:OnDrawGizmos()
  local eps = self.eps
  if 0 < #eps then
    local myselfPosition = Game.Myself and Game.Myself:GetPosition() or nil
    for i = 1, #eps do
      local ep = eps[i]
      local color = LuaGeometry.Const_Col_blue
      if nil ~= myselfPosition then
        local distance = VectorUtility.DistanceXZ_Square(myselfPosition, ep.position)
        if distance < ep.range * ep.range then
          color = LuaGeometry.Const_Col_red
        end
      end
      DebugUtils.DrawCircle(ep.position, LuaGeometry.Const_Qua_identity, ep.range, 50, color)
    end
  end
end

function AreaTrigger_ExitPoint:EnterExitRange(ep)
  local myself = Game.Myself
  myself:Client_MoveHandler(myself:GetPosition())
  myself:Client_EnterExitRangeHandler(ep)
  if self.resumeSyncMoveFlag == 0 then
    FunctionCheck.Me():SetSyncMove(FunctionCheck.CannotSyncMoveReason.ExitPoint, false)
  end
  self.resumeSyncMoveFlag = UnityTime + Resume_SyncMove_time
end

function AreaTrigger_ExitPoint:ResumeSyncMove()
  if self.resumeSyncMoveFlag > 0 then
    FunctionCheck.Me():SetSyncMove(FunctionCheck.CannotSyncMoveReason.ExitPoint, true)
  end
  self.resumeSyncMoveFlag = 0
end
