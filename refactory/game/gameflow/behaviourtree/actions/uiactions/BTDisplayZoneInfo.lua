BTDisplayZoneInfo = class("BTDisplayZoneInfo", BTAction)
BTDisplayZoneInfo.TypeName = "DisplayZoneInfo"
BTDefine.RegisterAction(BTDisplayZoneInfo.TypeName, BTDisplayZoneInfo)

function BTDisplayZoneInfo:ctor(config)
  BTDisplayZoneInfo.super.ctor(self, config)
  self.zoneId = config.zoneId
  self.duration = not config.duration and GameConfig.Weather and GameConfig.Weather.zone_display_time
  self.zoneConfig = Table_MapZone and Table_MapZone[self.zoneId]
end

function BTDisplayZoneInfo:Dispose()
  BTDisplayZoneInfo.super.Dispose(self)
end

function BTDisplayZoneInfo:Exec(time, deltaTime, context)
  local ret = BTDisplayZoneInfo.super.Exec(self, time, deltaTime, context)
  if ret ~= 0 then
    return ret
  end
  if not self.zoneConfig then
    self.enabled = false
    return 1
  end
  FloatingPanel.Instance:ShowMapName(self.zoneConfig.Name, self.zoneConfig.Desc, true, true, "tip/MapNameTip_1", self.duration)
  return 0
end
