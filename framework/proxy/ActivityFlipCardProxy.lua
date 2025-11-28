ActivityFlipCardProxy = class("ActivityFlipCardProxy", pm.Proxy)
ActivityFlipCardProxy.Instance = nil
ActivityFlipCardProxy.NAME = "ActivityFlipCardProxy"
ActivityFlipCardProxy.RedTipId = 10754

function ActivityFlipCardProxy.GetGridIndexByRowAndCol(act_id, row, column)
  local config = Table_ActPersonalTimer[act_id]
  if not config then
    return
  end
  local maxColumn = config.Misc.side_length or 6
  return maxColumn * (row - 1) + column
end

function ActivityFlipCardProxy:ctor(proxyName, data)
  self.proxyName = proxyName or ActivityFlipCardProxy.NAME
  if ActivityFlipCardProxy.Instance == nil then
    ActivityFlipCardProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function ActivityFlipCardProxy:Init()
  self.flipCardInfo = {}
end

function ActivityFlipCardProxy:SyncFlipCardInfo(data)
  local config = Table_ActPersonalTimer[data.act_id]
  if not config then
    return
  end
  local info = self.flipCardInfo[data.act_id]
  if not info then
    info = {}
    info.grids = {}
    info.rewards = {}
    local isTFBranch = EnvChannel.IsTFBranch()
    local phaseTime = StringUtil.FormatTime2TimeStamp2
    info.startTime = isTFBranch and phaseTime(config.TfStartTime) or phaseTime(config.StartTime)
    info.endTime = isTFBranch and phaseTime(config.TfEndTime) or phaseTime(config.EndTime)
    self.flipCardInfo[data.act_id] = info
    local maxLength = config.Misc.side_length or 6
    for i = 1, maxLength do
      for j = 1, maxLength do
        local index = ActivityFlipCardProxy.GetGridIndexByRowAndCol(data.act_id, i, j)
        info.grids[index] = false
      end
    end
  end
  info.flipChance = data.flip_chance
  info.getChanceByAct = data.get_chance_by_act
  for i = 1, #data.gotten_grids do
    local grid = data.gotten_grids[i]
    local index = ActivityFlipCardProxy.GetGridIndexByRowAndCol(data.act_id, grid.row, grid.column)
    info.grids[index] = true
  end
  for i = 1, #data.gotten_rewards do
    local id = data.gotten_rewards[i]
    info.rewards[i] = id
  end
  if self:IsHaveCardCanFlip(data.act_id) then
    RedTipProxy.Instance:UpdateRedTip(ActivityFlipCardProxy.RedTipId, {
      data.act_id
    })
  else
    RedTipProxy.Instance:RemoveWholeTip(ActivityFlipCardProxy.RedTipId)
  end
end

function ActivityFlipCardProxy:UpdateFlipCardInfo(data)
  local config = Table_ActPersonalTimer[data.act_id]
  if not config then
    return
  end
  local info = self.flipCardInfo[data.act_id]
  if info then
    info.flipChance = info.flipChance - 1
    if data.grid then
      local index = ActivityFlipCardProxy.GetGridIndexByRowAndCol(data.act_id, data.grid.row, data.grid.column)
      info.grids[index] = true
    end
    if data.reward and not self:IsRewardReceived(data.act_id, data.reward) then
      info.rewards[#info.rewards + 1] = data.reward
    end
  end
end

function ActivityFlipCardProxy:IsCardFliped(act_id, row, column)
  local info = self.flipCardInfo[act_id]
  if info then
    local index = ActivityFlipCardProxy.GetGridIndexByRowAndCol(act_id, row, column)
    return info.grids[index] or false
  end
  return false
end

function ActivityFlipCardProxy:IsRewardReceived(act_id, id)
  local info = self.flipCardInfo[act_id]
  if info then
    return TableUtility.ArrayFindIndex(info.rewards, id) > 0
  end
  return false
end

function ActivityFlipCardProxy:GetRemainFlipChance(act_id)
  local info = self.flipCardInfo[act_id]
  return info and info.flipChance or 0
end

function ActivityFlipCardProxy:IsHaveFlipChance(act_id)
  local flipChance = self:GetRemainFlipChance(act_id)
  return 0 < flipChance
end

function ActivityFlipCardProxy:GetByActChance(act_id)
  local info = self.flipCardInfo[act_id]
  return info and info.getChanceByAct or 0
end

function ActivityFlipCardProxy:IsChanceCanBuy(act_id)
  local maxChance = self:GetMaxChanceCanBuy(act_id)
  return 0 < maxChance
end

function ActivityFlipCardProxy:IsHaveCardCanFlip(act_id)
  local info = self.flipCardInfo[act_id]
  if info then
    local flipedNum = 0
    for i = 1, #info.grids do
      if info.grids[i] then
        flipedNum = flipedNum + 1
      end
    end
    return flipedNum < #info.grids and self:IsHaveFlipChance(act_id)
  end
  return false
end

function ActivityFlipCardProxy:GetMaxChanceCanBuy(act_id)
  local info = self.flipCardInfo[act_id]
  local upflipedNum = 0
  if info then
    for i = 1, #info.grids do
      upflipedNum = upflipedNum + (not info.grids[i] and 1 or 0)
    end
  end
  local flipChance = self:GetRemainFlipChance(act_id)
  return upflipedNum - flipChance
end

function ActivityFlipCardProxy:GetStartTime(act_id)
  local info = self.flipCardInfo[act_id]
  return info and info.startTime or 0
end

function ActivityFlipCardProxy:GetEndTime(act_id)
  local info = self.flipCardInfo[act_id]
  return info and info.endTime or 0
end

function ActivityFlipCardProxy:IsActivityAvailable(act_id)
  local startTime = self:GetStartTime(act_id)
  local endTime = self:GetEndTime(act_id)
  local curTime = ServerTime.CurServerTime() / 1000
  return startTime <= curTime and endTime > curTime
end

function ActivityFlipCardProxy:CheckIfLinkRowLine(act_id, row)
  local config = Table_ActPersonalTimer[act_id]
  if not config then
    return false
  end
  local info = self.flipCardInfo[act_id]
  if not info then
    return false
  end
  local maxColumn = config.Misc.side_length or 6
  for i = 1, maxColumn do
    local index = ActivityFlipCardProxy.GetGridIndexByRowAndCol(act_id, row, i)
    if not info.grids[index] then
      return false
    end
  end
  return true
end

function ActivityFlipCardProxy:CheckIfLinkColumnLine(act_id, column)
  local config = Table_ActPersonalTimer[act_id]
  if not config then
    return false
  end
  local info = self.flipCardInfo[act_id]
  if not info then
    return false
  end
  local maxRow = config.Misc.side_length or 6
  for i = 1, maxRow do
    local index = ActivityFlipCardProxy.GetGridIndexByRowAndCol(act_id, i, column)
    if not info.grids[index] then
      return false
    end
  end
  return true
end

function ActivityFlipCardProxy:CheckIfLinkDiagonal(act_id)
  local config = Table_ActPersonalTimer[act_id]
  if not config then
    return false
  end
  local info = self.flipCardInfo[act_id]
  if not info then
    return false
  end
  local maxLength = config.Misc.side_length or 6
  for i = 1, maxLength do
    local index = ActivityFlipCardProxy.GetGridIndexByRowAndCol(act_id, i, i)
    if not info.grids[index] then
      return false
    end
  end
  return true
end

function ActivityFlipCardProxy:GetLinkLineCount(act_id)
  local count = 0
  local info = self.flipCardInfo[act_id]
  if info then
    local config = Table_ActPersonalTimer[act_id]
    if config then
      local maxLength = config.Misc.side_length or 6
      local rows, columns = {}, {}
      local diagonal = 0
      for i = 1, maxLength do
        rows[i] = 0
        for j = 1, maxLength do
          columns[j] = columns[j] or 0
          local index = ActivityFlipCardProxy.GetGridIndexByRowAndCol(act_id, i, j)
          if info.grids[index] then
            rows[i] = rows[i] + 1
            columns[j] = columns[j] + 1
            if i == j then
              diagonal = diagonal + 1
            end
          end
        end
      end
      for i = 1, maxLength do
        if rows[i] == maxLength then
          count = count + 1
        end
        if columns[i] == maxLength then
          count = count + 1
        end
      end
      count = diagonal == maxLength and count + 1 or count
    end
  end
  return count
end
