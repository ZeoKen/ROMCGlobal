local BaseCell = autoImport("BuffCell")
RaidBuffCell = class("RaidBuffCell", BuffCell)
RaidBuffCellEvent = {
  BuffEnd = "BuffCellEvent_BuffEnd"
}
local BUFFTYPE_DOUBLEEXPCARD = "MultiTime"

function RaidBuffCell:Init()
  RaidBuffCell.super.Init(self)
  self.time = self:FindComponent("Time", UILabel)
  self.time.text = ""
  self:AddCellClickEvent()
end

function RaidBuffCell:SetData(data)
  self.data = data
  if self.data then
    RaidBuffCell.super.SetData(self, self.data)
    if data.endtime == 0 then
      self.time.text = "N/A"
    end
  end
end

function RaidBuffCell:OnRemove()
  TimeTickManager.Me():ClearTick(self, 1)
end

function RaidBuffCell:UpdateCDTime()
  if not self.data then
    return
  end
  local starttime, endtime = self.data.starttime, self.data.endtime
  local totalDeltaTime = endtime - starttime
  if totalDeltaTime <= 0 then
    self:PassEvent(RaidBuffCellEvent.BuffEnd, self.data)
    return
  end
  TimeTickManager.Me():ClearTick(self, 1)
  TimeTickManager.Me():CreateTick(0, 34, function(self, deltatime)
    local nowDelteTime = math.max((endtime - ServerTime.CurServerTime()) / 1000, 0)
    if 0 < nowDelteTime then
      self.time.text = string.format("%ds", nowDelteTime)
    else
      self.time.text = "0s"
      self:PassEvent(RaidBuffCellEvent.BuffEnd, self.data)
      TimeTickManager.Me():ClearTick(self, 1)
    end
  end, self, 1)
end
