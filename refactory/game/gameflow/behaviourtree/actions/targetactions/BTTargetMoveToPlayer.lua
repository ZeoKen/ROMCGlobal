BTTargetMoveToPlayer = class("BTTargetMoveToPlayer", BTTargetAction)
BTTargetMoveToPlayer.TypeName = "TargetMoveToPlayer"
BTDefine.RegisterAction(BTTargetMoveToPlayer.TypeName, BTTargetMoveToPlayer)
local curPos = LuaVector3 and LuaVector3.Zero()
local newPos = LuaVector3 and LuaVector3.Zero()

function BTTargetMoveToPlayer:ctor(config)
  BTTargetMoveToPlayer.super.ctor(self, config)
  self.speed = config.speed or 0
  self.offset = config.offset and LuaVector3.New(config.offset[1], config.offset[2], config.offset[3]) or LuaVector3.Zero()
end

function BTTargetMoveToPlayer:Dispose()
  BTTargetMoveToPlayer.super.Dispose(self)
end

function BTTargetMoveToPlayer:Exec(time, deltaTime, context)
  local ret = BTTargetMoveToPlayer.super.Exec(self, time, deltaTime, context)
  if ret ~= 0 then
    return 0
  end
  local myself = Game.Myself
  if not myself then
    return 0
  end
  local myPosition = myself:GetPosition()
  LuaVector3.Better_Add(myPosition, self.offset, newPos)
  local go = self.target.gameObject
  if self.speed == 0 then
    LuaGameObject.SetPositionGO(go, newPos[1], newPos[2], newPos[3])
  else
    curPos[1], curPos[2], curPos[3] = LuaGameObject.GetPositionGO(go)
    LuaVector3.Better_MoveTowards(curPos, myPosition, newPos, deltaTime * self.speed)
    LuaGameObject.SetPositionGO(go, newPos[1], newPos[2], newPos[3])
    LuaUtils.SetRotation(go, newPos, myPosition)
  end
  return 0
end
