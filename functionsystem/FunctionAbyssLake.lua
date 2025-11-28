FunctionAbyssLake = class("FunctionAbyssLake")

function FunctionAbyssLake.Me()
  if nil == FunctionAbyssLake.me then
    FunctionAbyssLake.me = FunctionAbyssLake.new()
  end
  return FunctionAbyssLake.me
end

function FunctionAbyssLake:ctor()
  self.running = false
  self.triggerDatas = {}
end

function FunctionAbyssLake:Launch()
  local curMap = Game.MapManager:GetMapID()
  if curMap ~= 154 then
    return
  end
  self.running = true
  self.objStateRecord = {}
  self:InitBattleTriggers()
end

function FunctionAbyssLake:InitBattleTriggers()
  local AbyssBossTable = Table_AbyssBoss
  local config
  self.summonMap = {}
  for _, v in pairs(AbyssBossTable) do
    config = v.AreaPos
    self:AddBattleTrigger(v.id, config.center, config.range)
    for _, v1 in pairs(v.MonsterMini) do
      self.summonMap[v1.unique] = {
        mapstepID = v1.mapstepid,
        areaID = v.id
      }
    end
  end
end

function FunctionAbyssLake:AddBattleTrigger(index, pos, triggerArea)
  self:RemoveBattleTrigger(index)
  local triggerData = ReusableTable.CreateTable()
  triggerData.id = index
  triggerData.type = AreaTrigger_Common_ClientType.AybssLake_BattlePoint
  local triggerPos = LuaVector3(pos[1], pos[2], pos[3])
  triggerData.pos = triggerPos
  triggerData.range = triggerArea or 5
  self.triggerDatas[index] = triggerData
  SceneTriggerProxy.Instance:Add(triggerData)
end

function FunctionAbyssLake:RemoveBattleTrigger(index)
  if not self.triggerDatas then
    return
  end
  local triggerData = self.triggerDatas[index]
  if triggerData == nil then
    return
  end
  SceneTriggerProxy.Instance:Remove(index)
  if triggerData.pos then
    triggerData.pos:Destroy()
    triggerData.pos = nil
  end
  ReusableTable.DestroyTable(triggerData)
  self.triggerDatas[index] = nil
end

function FunctionAbyssLake:ClearTirggerDatas()
  if not self.triggerDatas then
    return
  end
  for index, _ in pairs(self.triggerDatas) do
    self:RemoveBattleTrigger(index)
  end
end

function FunctionAbyssLake:Shutdown()
  self:ClearTirggerDatas()
  self.objStateRecord = nil
end

function FunctionAbyssLake:TrySetSummonProgress(uniqueid, ncreature)
  if not self.running or not ncreature then
    return false
  end
  if not uniqueid or not self.summonMap[uniqueid] then
    return false
  end
  local mapsteid, areaid = self.summonMap[uniqueid].mapstepID, self.summonMap[uniqueid].areaID
  local roleTopUI = ncreature:GetSceneUI().roleTopUI
  if not roleTopUI then
    return false
  end
  roleTopUI:SetSummonProgress(ncreature, areaid, mapsteid)
  return true
end

function FunctionAbyssLake:RecordObjState(objID, anim)
  if not self.running or not objID then
    return
  end
  if not self.objStateRecord then
    self.objStateRecord = {}
  end
  self.objStateRecord[objID] = anim
end

function FunctionAbyssLake:GetObjState(objID)
  if not self.running then
    return false
  end
  return self.objStateRecord[objID]
end
