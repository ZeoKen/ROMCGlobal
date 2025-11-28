WildMvpBuffData = class("WildMvpBuffData")
local LimitType = {TimeLimit = 1, CountLimit = 2}
WildMvpBuffData.LimitType = LimitType
local UIValueType = {Percent = 1, Absolute = 2}
WildMvpBuffData.UIValueType = UIValueType

function WildMvpBuffData:ctor(staticData)
  self:SetStaticData(staticData)
end

function WildMvpBuffData:SetStaticData(staticData)
  if not self.id or self.id ~= staticData.id then
    self.isNew = true
  end
  self.id = staticData.id
  self.staticData = staticData
  if staticData.buffId then
    self.buffStaticData = Table_Buffer[staticData.buffId]
  end
end

function WildMvpBuffData:SetServerData(serverData)
  if serverData and serverData.id == self.id then
    if not self.serverData then
      self.serverData = {}
    end
    self.serverData.count = serverData.count
    self.serverData.endTime = {}
    if serverData.end_time and #serverData.end_time > 0 then
      TableUtility.ArrayShallowCopy(self.serverData.endTime, serverData.end_time)
      table.sort(self.serverData.endTime, function(l, r)
        return l < r
      end)
    end
    if self.serverData.accCount then
      if serverData.layer and serverData.layer > 1 and serverData.layer > self.serverData.accCount then
        self.isAccUp = true
        self.isAccDown = false
      elseif not serverData.layer or serverData.layer < self.serverData.accCount then
        self.isAccUp = false
        self.isAccDown = true
      else
        self.isAccUp = false
        self.isAccDown = false
      end
    else
      self.isAccUp = serverData.layer and serverData.layer > 1 and true or false
    end
    self.serverData.accCount = serverData.layer
  end
end

function WildMvpBuffData:GetLimitType()
  if self.staticData then
    return self.staticData.LimitType
  end
end

function WildMvpBuffData:GetAccCount()
  if self.serverData and self.staticData and self.staticData.CanAccum == 1 then
    return self.serverData.accCount
  end
end

function WildMvpBuffData:GetAccDesc()
  if self.staticData then
    local acc = self:GetAccCount() or 1
    local val = self.staticData.UIValue or 0
    val = val * acc
    if self.staticData.UIValueType == UIValueType.Percent then
      val = math.floor(val * 1000 + 0.5)
      local isFloat = false
      if val % 10 == 0 then
        val = math.floor(val / 10 + 0.5)
      else
        val = val / 10
        isFloat = true
      end
      return (0 < val and "+" or "") .. (isFloat and string.format("%.1f", val) or val) .. "%"
    elseif self.staticData.UIValueType == UIValueType.Absolute then
      if 0 < val then
        return "+" .. val
      else
        return tostring(val)
      end
    end
  end
  return ""
end

function WildMvpBuffData:GetMaxCount()
  if self:GetLimitType() == LimitType.CountLimit then
    return self.staticData.LimitParam and self.staticData.LimitParam.count
  end
end

function WildMvpBuffData:GetLeftCount()
  if self.serverData and self:GetLimitType() == LimitType.CountLimit then
    return self.serverData.count
  end
end

function WildMvpBuffData:GetEndTime()
  if self.serverData and self:GetLimitType() == LimitType.TimeLimit then
    return self.serverData.endTime
  end
end

function WildMvpBuffData:GetTimeLeft()
  local endTime = self:GetEndTime()
  if not endTime then
    return
  end
  local curTime = ServerTime.CurServerTime() / 1000
  for i = 1, #endTime do
    if curTime < endTime[i] then
      return endTime[i] - curTime
    end
  end
  return endTime[#endTime] - curTime
end

function WildMvpBuffData:GetDescStr()
  if self.staticData then
    return self.staticData.Desc
  end
  return ""
end

function WildMvpBuffData:GetQualityColor()
  if self.staticData then
    return WildMvpBuffQualityColor[self.staticData.Quality]
  end
end

function WildMvpBuffData:SetNew(b)
  self.isNew = b
end

function WildMvpBuffData:IsNew()
  return self.isNew and true or false
end

function WildMvpBuffData:IsAccUp()
  return self.isAccUp and true or false
end

function WildMvpBuffData:IsAccDown()
  return self.isAccDown and true or false
end

function WildMvpBuffData:ClearBuffChangedStatus()
  self.isNew = nil
  self.isAccUp = nil
  self.isAccDown = nil
end
