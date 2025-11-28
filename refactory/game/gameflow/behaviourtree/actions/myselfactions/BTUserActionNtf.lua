BTUserActionNtf = class("BTUserActionNtf", BTAction)
BTUserActionNtf.TypeName = "UserActionNtf"
BTDefine.RegisterAction(BTUserActionNtf.TypeName, BTUserActionNtf)

function BTUserActionNtf:ctor(config)
  BTUserActionNtf.super.ctor(self, config)
  self.actionId = config.actionId
  self.loop = config.loop
end

function BTUserActionNtf:Dispose()
  BTUserActionNtf.super.Dispose(self)
end

function BTUserActionNtf:Exec(time, deltaTime, context)
  local ret = BTUserActionNtf.super.Exec(self, time, deltaTime, context)
  if ret ~= 0 then
    return ret
  end
  if not self.actionId then
    return 0
  end
  local myself = Game.Myself
  if not myself then
    return 0
  end
  myself:Client_PlayHolyActionAndNotifyServer(self.actionId, self.loop)
  return 0
end
