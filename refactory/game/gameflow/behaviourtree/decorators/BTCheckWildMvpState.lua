BTCheckWildMvpState = class("BTCheckWildMvpState", BTCondition)
BTCheckWildMvpState.TypeName = "CheckWildMvpState"
BTDefine.RegisterDecorator(BTCheckWildMvpState.TypeName, BTCheckWildMvpState)
BTCheckWildMvpState.MonsterStates = {
  Alive = 1,
  Dead = 2,
  Unknown = 3
}
local CompareFunc = BTDefine.LogicCompare

function BTCheckWildMvpState:ctor(config)
  BTCompareBB2.super.ctor(self, config)
  self.monsterId = config.monsterid
  self.state = config.state
  self.op = config.op
end

function BTCheckWildMvpState:Dispose()
  BTCheckWildMvpState.super.Dispose(self)
end

function BTCheckWildMvpState:Exec(time, deltaTime, context)
  local ret = 0
  if not self.monsterData then
    local proxy = WildMvpProxy.Instance
    self.monsterData = proxy:GetCurMiniMapMonsterDataById(self.monsterId)
  end
  if self.monsterData then
    local status = self.monsterData:GetStatus()
    if status and self.state then
      ret = CompareFunc(self.state, status, self.op) and 0 or 1
    else
      ret = 1
    end
  else
    ret = 1
  end
  ret = self:ProcessResult(ret)
  if ret == 0 then
    return ret, self.passRet
  else
    return ret, self.failRet
  end
end
