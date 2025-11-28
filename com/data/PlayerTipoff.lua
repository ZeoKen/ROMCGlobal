autoImport("TipoffReason")
PlayerTipoff = class("PlayerTipoff")

function PlayerTipoff:ctor(id)
  self.charId = id
  self.reasonMap = {}
end

function PlayerTipoff:SetData(data)
  self.lastReportTime = data.last_report_time
  self.nextValidTime = ClientTimeUtil.GetNextDailyRefreshTimeByTimeStamp(self.lastReportTime)
  local reasons = data.reasons
  if not reasons then
    return
  end
  for i = 1, #reasons do
    self.reasonMap[reasons[i].reason_id] = TipoffReason.new(reasons[i])
  end
end

function PlayerTipoff:IsRecord()
  local now = ServerTime.CurServerTime() / 1000
  if self.nextValidTime then
    return now < self.nextValidTime
  end
  return false
end
