autoImport("Bat")
Atcmi = class("Atcmi", Bat)
local sw, count

function Atcmi:ctor(interval, threshold)
  self.threshold = threshold or 0
  Atcmi.super.ctor(self, interval, self.Send, self)
end

function Atcmi:Init()
  sw = StopwatchManager.Me():CreateStopwatch(self.Record, self)
  self:Reset()
end

function Atcmi:Reset()
  count = 0
end

function Atcmi:Record(interval)
  if self.threshold <= 0 then
    return
  end
  if interval <= self.threshold then
    count = count + 1
    if not self:IsRecording() then
      self:StartRecording()
    end
  end
end

function Atcmi:Send()
  if count <= 0 then
    return
  end
  ServiceNUserProxy.Instance:CallCheatTagUserCmd(count)
  self:Reset()
end

function Atcmi:IsOn()
  return sw and sw.isOn
end

function Atcmi:Start()
  if sw then
    sw:Start()
  end
end

function Atcmi:Clear()
  if sw then
    sw:Clear()
  end
end

function Atcmi:R()
  if sw then
    sw:Pause()
  end
end
