TimeTick = class("TimeTick")

function TimeTick:ctor(delay, interval, updateFunc, owner, id, rawSecond, loopCount, from, to, timeTotal)
  self.isTicking = false
  self:ResetData(delay, interval, updateFunc, owner, id, rawSecond, loopCount, from, to, timeTotal)
end

function TimeTick:ResetData(delay, interval, updateFunc, owner, id, rawSecond, loopCount, fromValue, toValue, timeTotal)
  self.updateFun = updateFunc
  self.owner = owner
  self.id = id
  self.delay = delay
  self.interval = interval
  self.duration = interval
  self.rawSecond = rawSecond
  self.loopCount = loopCount or -1
  self.fromValue = fromValue or nil
  self.toValue = toValue or nil
  self.timeTotal = timeTotal or 0
  self.diffValue = fromValue and toValue and toValue - fromValue or 0
  self.curValue = nil
  self.firstIn = true
  self.timeCounter = 0
  self.timePassed = 0
  self.isCallUpdateFunc = true
  self.isComplete = false
  self.completeFunc = nil
  self.needDestroy = false
  self.errorMsg = nil
end

function TimeTick:Restart()
  self:StopTick()
  self:StartTick()
end

function TimeTick:StartTick()
  if self.isTicking then
    return
  end
  self.isTicking = true
  self.timeCounter = 0
end

function TimeTick:StopTick()
  self.isTicking = false
end

function TimeTick:ContinueTick()
  if self.needDestroy then
    return
  end
  self.isTicking = true
end

function TimeTick:ClearTick()
  self:StopTick()
  self.needDestroy = true
end

function TimeTick:Destroy()
  self:ClearTick()
end

function TimeTick:_CallUpdateFunc(intervalTime, curValue)
  if self.updateFun ~= nil then
    self.updateFun(self.owner, self.rawSecond and intervalTime / 1000 or intervalTime, curValue ~= nil and curValue or self.curValue)
  end
end

local safeCallUpdateFunc = function(self)
  self:_CallUpdateFunc(self.timeCounter, self.curValue)
end

function TimeTick:Update(time, deltaTime)
  if not self.isTicking then
    return
  end
  self.timeCounter = self.timeCounter + deltaTime * 1000
  if self.timeCounter >= (self.firstIn and self.delay or self.interval) then
    self.firstIn = false
    if self.diffValue ~= 0 and self.timeTotal ~= 0 then
      self.isCallUpdateFunc = true
      self.timePassed = self.timePassed + self.timeCounter
      self.curValue = self.fromValue + self.diffValue * self.timePassed / self.timeTotal
      if self.timePassed >= self.timeTotal then
        self.curValue = self.diffValue > 0 and math.min(self.curValue, self.toValue) or math.max(self.curValue, self.toValue)
        self.isComplete = true
      end
    else
      self.isCallUpdateFunc = (self.fromValue == nil or self.toValue == nil) and true or false
    end
    if self.isCallUpdateFunc then
      local success, errorMsg = xpcall(safeCallUpdateFunc, debug.traceback, self)
      if not success then
        if ApplicationInfo.IsRunOnEditor() then
          LogUtility.Error(errorMsg)
        elseif self.errorMsg ~= errorMsg then
          self.errorMsg = errorMsg
          Debug.LogError(errorMsg)
        end
      end
    end
    self.timeCounter = 0
    if 0 < self.loopCount then
      self.loopCount = self.loopCount - 1
    end
    if self.loopCount == 0 or self.isComplete then
      self:Destroy()
      if self.completeFunc then
        local success, errorMsg = xpcall(self.completeFunc, debug.traceback, self.owner, self.id)
        if not success then
          if ApplicationInfo.IsRunOnEditor() then
            LogUtility.Error(errorMsg)
          elseif self.errorMsg ~= errorMsg then
            self.errorMsg = errorMsg
            Debug.LogError(errorMsg)
          end
        end
      end
    end
  end
end

function TimeTick:SetCompleteFunc(completeFunc)
  self.completeFunc = completeFunc
end
