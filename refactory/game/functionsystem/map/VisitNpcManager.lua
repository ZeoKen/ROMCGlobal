VisitNpcManager = class("VisitNpcManager")
local CheckRangeInterval = 1

function VisitNpcManager:ctor()
  self.nextCheckRangeTime = 0
end

function VisitNpcManager:Launch()
  if self.running then
    return
  end
  self.running = true
  self:AddEventListener()
end

function VisitNpcManager:Shutdown()
  if not self.running then
    return
  end
  self.running = false
  self.nextCheckRangeTime = 0
  self:RemoveEventListener()
end

function VisitNpcManager:Update(time, deltaTime)
  if not self.running then
    return
  end
  if time >= self.nextCheckRangeTime then
    self.nextCheckRangeTime = time + CheckRangeInterval
    self:UpdateRangeNpcs()
  end
end

function VisitNpcManager:AddEventListener()
  EventManager.Me():AddEventListener(SceneUserEvent.SceneRemoveNpcs, self.UpdateRangeNpcs, self)
end

function VisitNpcManager:RemoveEventListener()
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneRemoveNpcs, self.UpdateRangeNpcs, self)
end

function VisitNpcManager:UpdateRangeNpcs()
  local myPos = Game.Myself:GetPosition()
  local npcs = NSceneNpcProxy.Instance:FindNearNpcs(myPos, 5, function(npc)
    local npcid = npc.data.staticData.id
    local npcData = Table_Npc[npcid]
    if npcData then
      local accessRange = npcData and npcData.AccessRange or 1
      if accessRange * accessRange >= LuaVector3.Distance_Square(npc:GetPosition(), myPos) then
        return true
      end
    end
  end)
  local result = {}
  for i = 1, #npcs do
    local npc = npcs[i]
    if npc:GetCreatureType() == Creature_Type.Npc then
      local npcid = npc.data.staticData.id
      local npcData = Table_Npc[npcid]
      local ntype = npcData.Type
      if ntype == NpcData.NpcDetailedType.GiftNpc then
        if npc.data.postcard and npc.data.postcard ~= 0 and HomeManager.Me():IsAtMyselfHome() and not result[npcid] then
          result[npcid] = {npcid = npcid, state = 3}
        end
      else
        local questList = QuestProxy.Instance:getDialogQuestListByNpcId(npc.data.staticData.id, npc.data.uniqueid)
        if questList and 0 < #questList then
          if self:HandleQuestShow(questList) then
            local npcid = npc.data.staticData.id
            if not result[npcid] then
              result[npcid] = {npcid = npcid, state = 1}
            end
          end
        else
          local collectQuestList = QuestProxy.Instance:getCollectQuestListByNpcId(npc.data.staticData.id)
          if collectQuestList and 0 < #collectQuestList then
            local npcid = npc.data.staticData.id
            if not result[npcid] then
              result[npcid] = {
                npcid = npcid,
                state = 2,
                count = 1
              }
            else
              result[npcid].count = result[npcid].count + 1
            end
          end
        end
      end
    end
  end
  if not self.nearlyMap then
    self.nearlyMap = result
    GameFacade.Instance:sendNotification(InteractNpcEvent.RefreshNpcVisitList, result)
  else
    local isEqual = true
    local count_A = 0
    local count_B = 0
    for k, v in pairs(self.nearlyMap) do
      count_A = count_A + 1
    end
    for k, v in pairs(result) do
      count_B = count_B + 1
    end
    if count_A ~= count_B then
      isEqual = false
    end
    if isEqual then
      for npcid, info in pairs(self.nearlyMap) do
        if not result[npcid] then
          isEqual = false
          break
        end
        local count_Pre = info.count or 1
        local count_Now = result[npcid].count or 1
        if count_Pre ~= count_Now then
          isEqual = false
          break
        end
      end
    end
    if not isEqual then
      self.nearlyMap = result
      GameFacade.Instance:sendNotification(InteractNpcEvent.RefreshNpcVisitList, result)
    end
  end
end

function VisitNpcManager:HandleQuestShow(questList)
  for i = 1, #questList do
    if VisitSymbolLimitType and TableUtility.ArrayFindIndex(VisitSymbolLimitType, questList[i].type) > 0 then
      return false
    end
    local showSymbol = questList[i].staticData and questList[i].staticData.Params.ShowSymbol
    showSymbol = tonumber(showSymbol)
    if showSymbol ~= 3 then
      return true
    end
  end
  return false
end
