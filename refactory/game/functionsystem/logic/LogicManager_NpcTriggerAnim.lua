LogicManager_NpcTriggerAnim = class("LogicManager_NpcTriggerAnim")
local E_PlayerTrigger = {Myself = 1}
local _TableUtility = TableUtility
local _NSceneNpcProxy = NSceneNpcProxy
local _DistanceXZ_Square = VectorUtility.DistanceXZ_Square
local _Game = Game
local m_updateNumPerFrame = 5

function LogicManager_NpcTriggerAnim:ctor()
  self.npcMap = {}
  self.statusMap = {}
  self.cfgTrigger = GameConfig.NpcTriggerAnim
  self.updateStep = 0
  self.frameUpdateNum = 0
  self.npcArray = {}
end

function LogicManager_NpcTriggerAnim:OnAddNpc(npc)
  local staticID = npc.data:GetStaticID()
  local config = self.cfgTrigger and self.cfgTrigger[staticID]
  if not config then
    return
  end
  local npcID = npc.data.id
  self.npcMap[npcID] = npc
  self.statusMap[npcID] = false
end

function LogicManager_NpcTriggerAnim:OnRemoveNpc(npc)
  local npcID = npc.data and npc.data.id
  if not npcID or not self.npcMap[npcID] then
    return
  end
  self.npcMap[npcID] = nil
  self.statusMap[npcID] = nil
  self.updateStep = 0
end

function LogicManager_NpcTriggerAnim:CheckSingleNpc(npc)
  if not npc or not npc:Alive() then
    return
  end
  local config = self.cfgTrigger and self.cfgTrigger[npc.data:GetStaticID()]
  if not config then
    self.npcMap[npc.data.id] = nil
    self.statusMap[npcID] = nil
    redlog("NpcTriggerAnim Error: Cannot find config!", npc.data:GetStaticID(), npc.data.id)
  end
  local position = npc:GetPosition()
  local range = config.Range or 1
  local sqrRange = range * range
  local isTrigger = false
  if config.TriggerPlayer and config.TriggerPlayer & E_PlayerTrigger.Myself > 0 then
    isTrigger = sqrRange > _DistanceXZ_Square(_Game.Myself:GetPosition(), position)
  end
  if not isTrigger and config.TriggerNpcIDs then
    local nearNpcs = _NSceneNpcProxy.Instance:FindNearNpcs(position, range)
    for i = 1, #nearNpcs do
      if 0 < _TableUtility.ArrayFindIndex(config.TriggerNpcIDs, nearNpcs[i].data:GetStaticID()) then
        isTrigger = true
        break
      end
    end
  end
  if self.statusMap[npc.data.id] ~= isTrigger then
    self.statusMap[npc.data.id] = isTrigger
    npc.assetRole:PlayAction_Simple(isTrigger and config.TriggerAnim or config.NormalAnim)
  end
end

function LogicManager_NpcTriggerAnim:Update(time, deltaTime)
  if self.updateStep == 0 then
    _TableUtility.TableClear(self.npcArray)
    for id, nnpc in pairs(self.npcMap) do
      self.npcArray[#self.npcArray + 1] = nnpc
    end
    self.updateStep = 1
    return
  end
  for i = self.updateStep, math.min(self.updateStep + m_updateNumPerFrame, #self.npcArray) do
    self:CheckSingleNpc(self.npcArray[i])
  end
  self.updateStep = self.updateStep + m_updateNumPerFrame
  if self.updateStep >= #self.npcArray then
    self.updateStep = 0
    return
  end
end
