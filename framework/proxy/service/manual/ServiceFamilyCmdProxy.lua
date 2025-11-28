autoImport("ServiceFamilyCmdAutoProxy")
ServiceFamilyCmdProxy = class("ServiceFamilyCmdProxy", ServiceFamilyCmdAutoProxy)
ServiceFamilyCmdProxy.Instance = nil
ServiceFamilyCmdProxy.NAME = "ServiceFamilyCmdProxy"
local tempTable = {}

function ServiceFamilyCmdProxy:ctor(proxyName)
  if ServiceFamilyCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceFamilyCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceFamilyCmdProxy.Instance = self
  end
end

function ServiceFamilyCmdProxy:Init()
  ServiceFamilyCmdProxy.super.Init(self)
  self.familyClueMap, self.clueStateMap = {}, {}
  if Table_FamilyClue then
    local family, list
    for _, data in pairs(Table_FamilyClue) do
      family = data.Family
      list = self.familyClueMap[family] or {}
      TableUtility.ArrayPushBack(list, data.id)
      self.familyClueMap[family] = list
    end
    for _, l in pairs(self.familyClueMap) do
      table.sort(l)
    end
  end
end

function ServiceFamilyCmdProxy:GetClueState(id)
  return self.clueStateMap[id]
end

function ServiceFamilyCmdProxy:GetClueListOfFamily(family)
  return self.familyClueMap[family]
end

function ServiceFamilyCmdProxy:_ForEachClueIdOfFamily(family, action)
  local clues = self:GetClueListOfFamily(family)
  if clues then
    for i = 1, #clues do
      action(clues[i])
    end
  end
end

function ServiceFamilyCmdProxy:GetFinishedClueCountOfFamily(family)
  local num = 0
  self:_ForEachClueIdOfFamily(family, function(clue)
    if self.clueStateMap[clue] == FamilyCmd_pb.EFAMILYCLUE_STATE_REWARD then
      num = num + 1
    end
  end)
  return num
end

function ServiceFamilyCmdProxy:GetAvailableClueCountOfFamily(family)
  local num = 0
  self:_ForEachClueIdOfFamily(family, function(clue)
    if self:ClueCanGetRewardPredicate(clue) then
      num = num + 1
    end
  end)
  return num
end

function ServiceFamilyCmdProxy:GetUnlockedMapEffectIds()
  TableUtility.TableClear(tempTable)
  local t = Table_FamilyClue
  if t then
    for clueId, state in pairs(self.clueStateMap) do
      if state == FamilyCmd_pb.EFAMILYCLUE_STATE_UNLOCK or state == FamilyCmd_pb.EFAMILYCLUE_STATE_REWARD then
        TableUtility.ArrayPushBack(tempTable, t[clueId].EffectId)
      end
    end
    if 1 < #tempTable then
      table.sort(tempTable)
    end
  end
  return tempTable
end

function ServiceFamilyCmdProxy:ClueCanGetRewardPredicate(clueId)
  return self.clueStateMap[clueId] == FamilyCmd_pb.EFAMILYCLUE_STATE_UNLOCK and Table_FamilyClue ~= nil and FunctionUnLockFunc.Me():CheckCanOpen(Table_FamilyClue[clueId].FinishMenuId)
end

function ServiceFamilyCmdProxy:RecvClueDataElement(data)
  if not data then
    return
  end
  self.clueStateMap[data.id] = data.state
end

function ServiceFamilyCmdProxy:RecvClueDataNtfFamilyCmd(data)
  data = data.datas
  for i = 1, #data do
    self:RecvClueDataElement(data[i])
  end
  ServiceFamilyCmdProxy.super.RecvClueDataNtfFamilyCmd(self, data)
end

function ServiceFamilyCmdProxy:RecvClueUnlockFamilyCmd(data)
  self:RecvClueDataElement(data.data)
  ServiceFamilyCmdProxy.super.RecvClueUnlockFamilyCmd(self, data)
end

function ServiceFamilyCmdProxy:RecvClueRewardFamilyCmd(data)
  self:RecvClueDataElement(data.data)
  ServiceFamilyCmdProxy.super.RecvClueRewardFamilyCmd(self, data)
end

function ServiceFamilyCmdProxy:IsClueAllFinish()
  if self.isAllFinish then
    return true
  end
  if not self.clueStateMap then
    return false
  end
  for k, v in pairs(Table_FamilyClue) do
    if not self.clueStateMap[k] or self.clueStateMap[k] == FamilyCmd_pb.EFAMILYCLUE_STATE_INIT or self.clueStateMap[k] == FamilyCmd_pb.EFAMILYCLUE_STATE_UNLOCK then
      return false
    end
  end
  self.isAllFinish = true
  return true
end
