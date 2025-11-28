FunctionUtility = class("FunctionUtility")

function FunctionUtility.Me()
  if nil == FunctionUtility.me then
    FunctionUtility.me = FunctionUtility.new()
  end
  return FunctionUtility.me
end

function FunctionUtility:ctor()
  self:Init()
end

function FunctionUtility:Init()
  self.delayCallList = {}
  self.requestCounter = 0
end

function FunctionUtility:Update(time, deltaTime)
  local curTime = ServerTime.CurServerTime()
  local functionData, callback, param1, param2
  for i = #self.delayCallList, 1, -1 do
    functionData = self.delayCallList[i]
    if curTime >= functionData.callTime then
      callback, param1, param2 = functionData.callback, functionData.param1, functionData.param2
      ReusableTable.DestroyAndClearTable(functionData)
      table.remove(self.delayCallList, i)
      callback(param1, param2)
    end
  end
end

function FunctionUtility:DelayCall(callback, delayTime, mark, param1, param2)
  if not callback then
    redlog("Cannot do delayCall because callback is nil!")
    return
  end
  local functionData = ReusableTable.CreateTable()
  functionData.callback = callback
  functionData.mark = mark
  functionData.param1 = param1
  functionData.param2 = param2
  functionData.callTime = ServerTime.CurServerTime() + (delayTime or 0)
  functionData.uniqueIndex = self:GetUniqueIndex()
  self.delayCallList[#self.delayCallList + 1] = functionData
  return functionData.uniqueIndex
end

function FunctionUtility:GetUniqueIndex()
  self.requestCounter = self.requestCounter + 1
  if self.requestCounter > 100000000 and #self.delayCallList < self.requestCounter then
    self.requestCounter = 0
  end
  return self.requestCounter
end

function FunctionUtility:CancelDelayCall(uniqueIndex)
  if not uniqueIndex then
    return
  end
  for i = #self.delayCallList, 1, -1 do
    if self.delayCallList[i].uniqueIndex == uniqueIndex then
      ReusableTable.DestroyAndClearTable(self.delayCallList[i])
      table.remove(self.delayCallList, i)
      return
    end
  end
end

function FunctionUtility:CancelDelayCallByMark(mark)
  if not mark then
    return
  end
  for i = #self.delayCallList, 1, -1 do
    if self.delayCallList[i].mark == mark then
      ReusableTable.DestroyAndClearTable(self.delayCallList[i])
      table.remove(self.delayCallList, i)
    end
  end
end
