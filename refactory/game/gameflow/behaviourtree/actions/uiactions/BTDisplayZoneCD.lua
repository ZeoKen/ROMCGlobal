BTDisplayZoneCD = class("BTDisplayZoneCD", BTAction)
BTDisplayZoneCD.TypeName = "DisplayZoneCD"
BTDefine.RegisterAction(BTDisplayZoneCD.TypeName, BTDisplayZoneCD)
local MsgTypes = {CountDown = 1, KillNum = 2}
BTDisplayZoneCD.MsgTypes = MsgTypes

function BTDisplayZoneCD:ctor(config)
  BTDisplayZoneCD.super.ctor(self, config)
  self.zoneid = config.zoneid
  self.msgtype = config.msgtype
  self.msgid = config.msgid
  self.visible = config.visible
end

function BTDisplayZoneCD:Dispose()
  BTDisplayZoneCD.super.Dispose(self)
end

function BTDisplayZoneCD:Exec(time, deltaTime, context)
  local ret = BTDisplayZoneCD.super.Exec(self, time, deltaTime, context)
  if ret ~= 0 then
    return ret
  end
  if self.visible then
    FloatingPanel.Instance:AddZoneMap(self.zoneid, self.msgid, self.msgtype)
  else
    FloatingPanel.Instance:RemoveZoneMap(self.zoneid)
  end
  return 0
end
