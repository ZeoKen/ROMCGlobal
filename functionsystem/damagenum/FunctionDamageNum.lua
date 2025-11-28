FunctionDamageNum = class("FunctionDamageNum")
autoImport("StaticHurtNum")
autoImport("DynamicHurtNum")
autoImport("DynamicMissNum")
local table_remove = table.remove
local table_insert = table.insert
local LODLevel = {
  High = 0,
  Mid = 1,
  Low = 2,
  Invisible = 3
}
local MaxHurtNumPerFrame = 5

function FunctionDamageNum.Me()
  if nil == FunctionDamageNum.me then
    FunctionDamageNum.me = FunctionDamageNum.new()
  end
  return FunctionDamageNum.me
end

function FunctionDamageNum:ctor()
  self.dynamicCellPool = {}
  self.missCellPool = {}
  self.staticCellPool = {}
  self.sNumArrayMap = {
    [HurtNumColorType.Combo] = {}
  }
  self.dNumArrayMap = {}
  for k, v in pairs(HurtNumColorType) do
    self.dNumArrayMap[v] = {}
  end
  self.missNumArray = {}
  self.lastUpdateFrame = 0
  self.hurtNumCreatedLastFrame = 0
end

local hurtNumArgs = {}
local hurtNumPos = LuaVector3.Zero()

function FunctionDamageNum:GetStaticHurtLabelWorker()
  hurtNumArgs[3] = HurtNumType.DamageNum_U
  hurtNumArgs[4] = HurtNumColorType.Combo
  local hurtHum = self:mGetStaticCellFromPool(hurtNumArgs)
  local colorType = HurtNumColorType.Combo
  local comboArray = self.sNumArrayMap[colorType]
  if #comboArray >= HurtNumLimit[colorType] then
    local numCell = table_remove(comboArray, 1)
    self:mAddStaticCellToPool(numCell)
  end
  table_insert(comboArray, hurtHum)
  return hurtHum
end

function FunctionDamageNum:ShowDynamicHurtNum(pos, text, type, hurtNumColorType, critType, isFromMe, isToMe)
  if UnityFrameCount ~= self.lastUpdateFrame then
    self.lastUpdateFrame = UnityFrameCount
    self.hurtNumCreatedLastFrame = 0
  end
  local isMyself = isFromMe or isToMe
  if isToMe and critType == HurtNum_CritType.None and hurtNumColorType ~= HurtNumColorType.Treatment and hurtNumColorType ~= HurtNumColorType.Treatment_Sp then
    hurtNumColorType = HurtNumColorType.Player
  end
  if not isMyself then
    if self.hurtNumCreatedLastFrame > MaxHurtNumPerFrame then
      return
    end
    if not Game.MapManager:IsIgnoreSceneUIMapCellLod() and Game.LogicManager_MapCell:MapCellLodLevelByPos(pos[1], pos[3]) ~= LODLevel.High then
      return
    end
  end
  self.hurtNumCreatedLastFrame = self.hurtNumCreatedLastFrame + 1
  LuaVector3.Better_Set(hurtNumPos, pos[1], pos[2], pos[3])
  TableUtility.ArrayClear(hurtNumArgs)
  hurtNumArgs[1] = hurtNumPos
  hurtNumArgs[2] = text
  hurtNumArgs[3] = type
  hurtNumArgs[4] = hurtNumColorType
  hurtNumArgs[5] = critType or HurtNum_CritType.None
  hurtNumArgs[6] = isMyself
  local hurtHum
  if HurtNumType.Miss == type then
    hurtHum = self:mGetMissCellFromPool(hurtNumArgs)
  else
    hurtHum = self:mGetDynamicCellFromPool(hurtNumArgs)
  end
  if hurtNumColorType then
    local cellArray
    if HurtNumType.Miss == type then
      cellArray = self.missNumArray
    else
      cellArray = self.dNumArrayMap[hurtNumColorType]
    end
    if #cellArray >= HurtNumLimit[hurtNumColorType] then
      local numCell = table_remove(cellArray, 1)
      if HurtNumType.Miss == numCell.type then
        self:mAddMissCellToPool(numCell)
      else
        self:mAddDynamicCellToPool(numCell)
      end
    end
    table_insert(cellArray, hurtHum)
  end
  return hurtHum
end

function FunctionDamageNum:Update(time, deltaTime)
  for _, array in pairs(self.dNumArrayMap) do
    self:mHelpUpdateUsedCells(array, deltaTime, self.dynamicCellPool)
  end
  for _, array in pairs(self.sNumArrayMap) do
    self:mHelpUpdateUsedCells(array, deltaTime, self.staticCellPool)
  end
  self:mHelpUpdateUsedCells(self.missNumArray, deltaTime, self.missCellPool)
end

function FunctionDamageNum:mHelpUpdateUsedCells(array, deltaTime, pool)
  local cell
  local arrayCount = #array
  for i = arrayCount, 1, -1 do
    cell = array[i]
    if cell:Alive() then
      cell:Update(deltaTime)
      if not cell:IsLifeEnd() then
        cell:Show()
      else
        table_remove(array, i)
        if HurtNum.HideLogic then
          cell:Hide()
          self:mHelpAddCellToPool(cell, pool)
        else
          cell:Destroy()
        end
      end
    else
      table_remove(array, i)
    end
  end
end

function FunctionDamageNum:mGetStaticCellFromPool(initArgs)
  return self:mHelpGetCellFromPool(self.staticCellPool, initArgs, StaticHurtNum)
end

function FunctionDamageNum:mGetDynamicCellFromPool(initArgs)
  return self:mHelpGetCellFromPool(self.dynamicCellPool, initArgs, DynamicHurtNum)
end

function FunctionDamageNum:mGetMissCellFromPool(initArgs)
  return self:mHelpGetCellFromPool(self.missCellPool, initArgs, DynamicMissNum)
end

function FunctionDamageNum:mHelpGetCellFromPool(pool, initArgs, cls)
  local cell
  for i = #pool, 1, -1 do
    cell = table.remove(pool, i)
    if cell:Alive() then
      break
    end
    cell = nil
  end
  if cell then
    cell:InitArgs(initArgs)
  else
    cell = cls.CreateAsTable(initArgs)
  end
  return cell
end

function FunctionDamageNum:mAddStaticCellToPool(cell)
  self:mHelpAddCellToPool(cell, self.staticCellPool)
end

function FunctionDamageNum:mAddDynamicCellToPool(cell)
  self:mHelpAddCellToPool(cell, self.dynamicCellPool)
end

function FunctionDamageNum:mAddMissCellToPool(cell)
  self:mHelpAddCellToPool(cell, self.missCellPool)
end

function FunctionDamageNum:mHelpAddCellToPool(cell, pool)
  if cell == nil or not cell:Alive() then
    return
  end
  cell:Hide()
  table_insert(pool, cell)
end
