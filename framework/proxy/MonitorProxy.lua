MonitorProxy = class("MonitorProxy", pm.Proxy)
MonitorProxy.NAME = "MonitorProxy"

function MonitorProxy:ctor(proxyName, data)
  self.proxyName = proxyName or self.NAME
  if not _G[self.proxyName].Instance then
    _G[self.proxyName].Instance = self
  end
  if data then
    self:setData(data)
  end
  self:Init()
end

function MonitorProxy:Init()
  EventManager.Me():AddEventListener(LoadSceneEvent.FinishLoadScene, self.OnFinishLoadScene, self)
end

function MonitorProxy:OnFinishLoadScene()
  if self.monitorTarget then
    self:SetMyPositionXYZ()
  end
end

function MonitorProxy:RecvBeginMonitor(charId)
  self.monitorTarget = charId
  local creature = SceneCreatureProxy.FindCreature(charId)
  if creature then
    self:ClearMyBag()
    FunctionBuff.Me():ResetSubject(creature)
    self:SetMyRole(creature.assetRole.completeTransform)
    Game.HandUpManager:MaunalClose()
  else
    LogUtility.WarningFormat("Cannot find creature with id = {0}. FunctionBuff will not act as expected.", charId)
  end
end

function MonitorProxy:RecvStopMonitor()
  self:ClearMyBag()
  FunctionBuff.Me():ResetSubject()
  self:SetMyRole()
  Game.HandUpManager:MaunalOpen()
  SceneObjectProxy.ClearAll()
  self.monitorTarget = nil
end

function MonitorProxy:SetMyRole(monitorTargetRoleTrans)
  local myself = Game.Myself
  if not myself then
    return
  end
  local myRole, reason = myself.assetRole, 203927
  myRole:SetInvisible(monitorTargetRoleTrans ~= nil)
  if monitorTargetRoleTrans then
    FunctionSystem.InterruptMyselfAll()
    Game.InputManager.disableMove = Game.InputManager.disableMove + 1
    myself.data:Client_SetProps(MyselfData.ClientProps.DisableRotateInPhotographMode, true)
    myself:SetParent(monitorTargetRoleTrans)
    self.myRoleLocalPos = myRole.completeTransform.localPosition
    FunctionPlayerUI.Me():MaskAllUI(myself, reason)
  else
    Game.InputManager.disableMove = Game.InputManager.disableMove - 1
    myself.data:Client_SetProps(MyselfData.ClientProps.DisableRotateInPhotographMode, false)
    myself:SetParent(nil)
    FunctionPlayerUI.Me():UnMaskAllUI(myself, reason)
  end
  local pos = not monitorTargetRoleTrans and self.myRoleLocalPos or LuaGeometry.Const_V3_zero
  self:SetMyPositionXYZ(pos[1], pos[2], pos[3])
end

function MonitorProxy:SetMyPositionXYZ(x, y, z)
  x = x or 0
  y = y or 0
  z = z or 0
  if self.delayedSetPos then
    self.delayedSetPos:Destroy()
  end
  self.delayedSetPos = TimeTickManager.Me():CreateOnceDelayTick(100, function(self)
    Game.Myself.assetRole:SetPosition(LuaGeometry.GetTempVector3(x, y, z))
    self.delayedSetPos = nil
  end, self)
end

function MonitorProxy:ClearMyBag()
  for _, bag in pairs(BagProxy.Instance.bagMap) do
    bag:Reset()
  end
end
