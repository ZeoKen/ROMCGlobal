LogicManager_RoleDress = class("LogicManager_RoleDress")
LogicManager_RoleDress.Priority = {
  Normal = 1,
  Friend = 2,
  Guild = 3,
  GroupTeam = 4,
  Team = 5,
  _Count = 5
}
local GetSystemMemorySize = ApplicationInfo.GetSystemMemorySize
local ScreenCountHighLM = 20
local ScreenCountMidLM = 10
local ScreenCountLowLM = 5
local ArrayPushBack = TableUtility.ArrayPushBack
local ArrayPopBack = TableUtility.ArrayPopBack
local ArrayRemove = TableUtility.ArrayRemove
local FindHighAndLowPriorityCreature = function(creatures, highPriorityCreature, highPriority, lowPriorityCreature, lowPriority, enemyFirstPriority)
  local highIndex = 0
  local lowIndex = 0
  local creatureCount = #creatures
  local creature, priority, cellPriority
  local firstCellPriority, lastCellPriority = 999999, 0
  local priorityCount = LogicManager_RoleDress.Priority._Count
  if enemyFirstPriority then
    if highPriority == 1 then
      highPriority = highPriority + priorityCount
    end
    if lowPriority == 1 then
      lowPriority = lowPriority + priorityCount
    end
  end
  if 0 < creatureCount then
    for i = 1, creatureCount do
      creature = creatures[i]
      priority = creature:GetDressPriority()
      cellPriority = creature:GetCellPriority()
      if enemyFirstPriority and priority == 1 then
        priority = priority + priorityCount
      else
        if highPriority < priority or priority == highPriority and firstCellPriority > cellPriority then
          highPriorityCreature = creature
          highPriority = priority
          firstCellPriority = cellPriority
          highIndex = i
        end
        if lowPriority > priority or priority == lowPriority and lastCellPriority < cellPriority then
          lowPriorityCreature = creature
          lowPriority = priority
          lastCellPriority = cellPriority
          lowIndex = i
        end
      end
    end
  end
  if enemyFirstPriority then
    if priorityCount < highPriority then
      highPriority = highPriority - priorityCount
    end
    if priorityCount < lowPriority then
      lowPriority = lowPriority - priorityCount
    end
  end
  return highPriorityCreature, highPriority, highIndex, lowPriorityCreature, lowPriority, lowIndex
end
local FindHighPriorityCreature = function(creatures, highPriorityCreature, highPriority, enemyFirstPriority)
  local index = 0
  local creatureCount = #creatures
  local creature, priority, cellPriority
  local firstCellPriority = 9999999
  local priorityCount = LogicManager_RoleDress.Priority._Count
  if enemyFirstPriority and highPriority == 1 then
    highPriority = highPriority + priorityCount
  end
  if 0 < creatureCount then
    for i = 1, creatureCount do
      creature = creatures[i]
      priority = creature:GetDressPriority()
      cellPriority = creature:GetCellPriority()
      if enemyFirstPriority and priority == 1 then
        priority = priority + priorityCount
      end
      if highPriority < priority or priority == highPriority and firstCellPriority > cellPriority then
        highPriorityCreature = creature
        highPriority = priority
        firstCellPriority = cellPriority
        index = i
      end
    end
  end
  if enemyFirstPriority and priorityCount < highPriority then
    highPriority = highPriority - priorityCount
  end
  return highPriorityCreature, highPriority, index
end

function LogicManager_RoleDress:ctor()
  self.dressedCreatures = {}
  self.dressedCount = 0
  self.dressedEnemyCount = 0
  self.undressedCreatures = {}
  self.undressedCount = 0
  for i = 1, LogicManager_RoleDress.Priority._Count do
    self.dressedCreatures[i] = {}
    self.undressedCreatures[i] = {}
  end
  self.limitCount = 0
  self.dressDisable = false
  self.waitingDressedCreatures = {}
  self.waitingUndressedCreatures = {}
end

function LogicManager_RoleDress:Add(creature)
  if creature:IsDressEnable() then
    ArrayPushBack(self.waitingDressedCreatures, creature)
  else
    ArrayPushBack(self.waitingUndressedCreatures, creature)
  end
end

function LogicManager_RoleDress:Remove(creature)
  local priority = creature:GetDressPriority()
  if creature:IsDressEnable() then
    if 0 < self:RemoveFromDressedArray(creature, priority) then
      return
    end
    ArrayRemove(self.waitingDressedCreatures, creature)
  else
    if 0 < self:RemoveFromUndressedArray(creature, priority) then
      return
    end
    ArrayRemove(self.waitingUndressedCreatures, creature)
  end
end

function LogicManager_RoleDress:RefreshPriority(creature, oldPriority, newPriority)
  if oldPriority == newPriority then
    return
  end
  if creature:IsDressEnable() then
    if 0 < self:RemoveFromDressedArray(creature, oldPriority) then
      if oldPriority < newPriority then
        self:PushToDressedArray(creature, newPriority)
      else
        ArrayPushBack(self.waitingDressedCreatures, creature)
      end
    end
  elseif 0 < self:RemoveFromUndressedArray(creature, oldPriority) then
    if newPriority < oldPriority then
      self:PushToUndressedArray(creature, newPriority)
      ArrayPushBack(self.undressedCreatures[newPriority], creature)
    else
      ArrayPushBack(self.waitingUndressedCreatures, creature)
    end
  end
end

function LogicManager_RoleDress:SetLimitCount(count)
  count = self:UpdateLimitCount(count)
  if self.limitCount == count then
    return
  end
  self.limitCount = count
  redlog("LogicManager_RoleDress:SetLimitCount", count)
end

function LogicManager_RoleDress:UpdateLimitCount(count)
  if GetSystemMemorySize() <= 2048 then
    local func = FunctionPerformanceSetting.Me()
    local setting = func:GetSetting()
    local screenCountLevel = func:GetScreenCountLevel(setting.screenCount)
    if screenCountLevel == EScreenCountLevel.High and setting.screenCount == count then
      return ScreenCountHighLM
    elseif screenCountLevel == EScreenCountLevel.Mid and setting.screenCount == count then
      return ScreenCountMidLM
    elseif screenCountLevel == EScreenCountLevel.Low and setting.screenCount == count then
      return ScreenCountLowLM
    end
  end
  return count
end

function LogicManager_RoleDress:GetLimitCount(count)
  if self.dressDisable then
    return 0
  end
  return self.limitCount
end

function LogicManager_RoleDress:SetDressDisable(disable)
  self.dressDisable = disable
end

function LogicManager_RoleDress:Update(time, deltaTime)
  if self.dressedCount < self:GetLimitCount() and 0 >= #self.waitingDressedCreatures and 0 >= #self.waitingUndressedCreatures and 0 >= self.undressedCount then
    return
  end
  local highPriorityCreature
  local highPriority = 0
  local highPriorityCreatureArray
  local highPriorityIndex = 0
  local lowPriorityCreature
  local lowPriority = 9999999
  local lowPriorityIndex = 0
  local enemyFirstPriority = self:ShouldDressEnemy()
  local creatures = self.waitingDressedCreatures
  highPriorityCreature, highPriority, highPriorityIndex, lowPriorityCreature, lowPriority, lowPriorityIndex = FindHighAndLowPriorityCreature(self.waitingDressedCreatures, highPriorityCreature, highPriority, lowPriorityCreature, lowPriority, enemyFirstPriority)
  if 0 < highPriorityIndex then
    highPriorityCreatureArray = self.waitingDressedCreatures
  end
  local newHighPriorityCreature, newHighPriority, newHighPriorityIndex = FindHighPriorityCreature(self.waitingUndressedCreatures, highPriorityCreature, highPriority, enemyFirstPriority)
  if 0 < newHighPriorityIndex then
    highPriorityCreatureArray = self.waitingUndressedCreatures
    highPriorityCreature = newHighPriorityCreature
    highPriority = newHighPriority
    highPriorityIndex = newHighPriorityIndex
  end
  if nil ~= highPriorityCreature and self:_TryDress(highPriorityCreature, highPriority) then
    table.remove(highPriorityCreatureArray, highPriorityIndex)
    if highPriorityCreature == lowPriorityCreature then
      lowPriorityCreature = nil
    end
  else
    self:_TryDressOne()
  end
  if nil ~= lowPriorityCreature and self:_TryUndress(lowPriorityCreature, lowPriority) then
    table.remove(self.waitingDressedCreatures, lowPriorityIndex)
  else
    self:_TryUndressOne()
  end
end

function LogicManager_RoleDress:_TryDress(creature, priority)
  if self.dressedCount < self:GetLimitCount() then
    self:PushToDressedArray(creature, priority)
    creature:SetDressEnable(true)
    return true
  end
  local startIndex = 1
  local endIndex = priority - 1
  local priorityCount = LogicManager_RoleDress.Priority._Count
  if self:ShouldDressEnemy() then
    startIndex = 2
    if priority == 1 then
      endIndex = priorityCount + 1
    end
  end
  for i = startIndex, endIndex do
    local priorityIndex = i > priorityCount and i - priorityCount or i
    local replacedCreature = self:PopFromDressedArray(priorityIndex)
    if replacedCreature ~= nil then
      self:PushToUndressedArray(replacedCreature, priorityIndex)
      replacedCreature:SetDressEnable(false)
      self:PushToDressedArray(creature, priority)
      creature:SetDressEnable(true)
      return true
    end
  end
  return false
end

function LogicManager_RoleDress:_TryUndress(creature, priority)
  if self.dressedCount < self:GetLimitCount() then
    return false
  end
  self:PushToUndressedArray(creature, priority)
  creature:SetDressEnable(false)
  return true
end

function LogicManager_RoleDress:_TryDressOne()
  if self.dressedCount >= self:GetLimitCount() then
    return false
  end
  local endIndex = 1
  if self:ShouldDressEnemy() then
    endIndex = 2
    local creature = self:PopFromUndressedArray(1)
    if creature ~= nil then
      self:PushToDressedArray(creature, 1)
      creature:SetDressEnable(true)
      return true
    end
  end
  for i = LogicManager_RoleDress.Priority._Count, endIndex, -1 do
    local creature = self:PopFromUndressedArray(i)
    if creature ~= nil then
      self:PushToDressedArray(creature, i)
      creature:SetDressEnable(true)
      return true
    end
  end
  return false
end

function LogicManager_RoleDress:_TryUndressOne()
  if self.dressedCount <= self:GetLimitCount() then
    return false
  end
  local startIndex = 1
  if self:ShouldDressEnemy() then
    startIndex = 2
  end
  for i = startIndex, LogicManager_RoleDress.Priority._Count do
    local creature = self:PopFromDressedArray(i)
    if creature ~= nil then
      self:PushToUndressedArray(creature, i)
      creature:SetDressEnable(false)
      return true
    end
  end
  return false
end

function LogicManager_RoleDress:PushToDressedArray(creature, priority)
  ArrayPushBack(self.dressedCreatures[priority], creature)
  self.dressedCount = self.dressedCount + 1
  if priority == 1 then
    self.dressedEnemyCount = self.dressedEnemyCount + 1
  end
end

function LogicManager_RoleDress:PopFromDressedArray(priority)
  local arr = self.dressedCreatures[priority]
  if not arr or #arr <= 0 then
    return nil
  end
  local creature = ArrayPopBack(arr)
  if creature then
    self.dressedCount = self.dressedCount - 1
    if priority == 1 then
      self.dressedEnemyCount = self.dressedEnemyCount - 1
    end
  end
  return creature
end

function LogicManager_RoleDress:RemoveFromDressedArray(creature, priority)
  local arr = self.dressedCreatures[priority]
  if not arr then
    return 0
  end
  local ret = ArrayRemove(arr, creature)
  if 0 < ret then
    self.dressedCount = self.dressedCount - 1
    if priority == 1 then
      self.dressedEnemyCount = self.dressedEnemyCount - 1
    end
  end
  return ret
end

function LogicManager_RoleDress:PushToUndressedArray(creature, priority)
  ArrayPushBack(self.undressedCreatures[priority], creature)
  self.undressedCount = self.undressedCount + 1
end

function LogicManager_RoleDress:PopFromUndressedArray(priority)
  local arr = self.undressedCreatures[priority]
  if not arr or #arr <= 0 then
    return nil
  end
  local creature = ArrayPopBack(arr)
  if creature then
    self.undressedCount = self.undressedCount - 1
  end
  return creature
end

function LogicManager_RoleDress:RemoveFromUndressedArray(creature, priority)
  local arr = self.undressedCreatures[priority]
  if not arr then
    return 0
  end
  local ret = ArrayRemove(arr, creature)
  if 0 < ret then
    self.undressedCount = self.undressedCount - 1
  end
  return ret
end

local BalanceEnemyModelInMapIds = GameConfig and GameConfig.GVGConfig and GameConfig.GVGConfig.BalanceEnemyModelInMapIds

function LogicManager_RoleDress:ShouldDressEnemy()
  local curMapId = Game.MapManager:GetMapID()
  if not (curMapId and BalanceEnemyModelInMapIds) or not BalanceEnemyModelInMapIds[curMapId] then
    return false
  end
  return self.dressedEnemyCount < math.floor(self.dressedCount / 2.0)
end
