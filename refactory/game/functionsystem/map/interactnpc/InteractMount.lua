InteractMount = class("InteractMount", InteractBase)
local VectorDistanceXZ = VectorUtility.DistanceXZ_Square
local LuaGetPosition = LuaGameObject.GetPosition
local Const_V3_zero = LuaGeometry.Const_V3_zero
DoubleMount = {
  [0] = "double_motor_wait",
  [1] = "double_motor_walk"
}

function InteractMount.Create(data, id)
  local args = InteractBase.GetArgs(data, id)
  return ReusableObject.Create(InteractMount, false, args)
end

function InteractMount:Update(time, deltaTime)
  if not self.cpInited then
    self:TryInitCpTransform()
  end
end

function InteractMount:SetNpcID(npcID)
  self.npcid = npcID
end

function InteractMount:PassengerAction(actionType)
  if self.fakeCreature and DoubleMount[actionType] then
    local assetrole = self.fakeCreature.assetRole
    if assetrole and assetrole:HasActionRaw(DoubleMount[actionType]) then
      assetrole:PlayAction_Simple(DoubleMount[actionType])
    end
  end
end

function InteractMount:GetOn(cpid, charid, npcid, masterid, ncreature)
  local creature = self:GetCreature(charid)
  if charid == Game.Myself.data.id then
    FunctionSystem.InterruptMyselfAll()
  elseif creature then
    FunctionSystem.InterruptCreature(creature)
  end
  local lastCount = self.cpCount
  if not self.cpInited then
    self.waitCpMap[cpid] = charid
  else
    InteractMount.super.GetOn(self, cpid, charid, npcid, masterid, ncreature)
  end
  if self.cpCount == lastCount then
    return
  end
  if creature then
    creature:Client_NoAction(true)
    creature.logicTransform:SetAngleY(0)
    creature:Logic_LockRotation(true)
  end
  if self.cpMap[cpid] == Game.Myself.data.id then
    Game.Myself:Client_NoMove(true)
    Game.Myself.data:Client_SetProps(MyselfData.ClientProps.DisableRotateInPhotographMode, true)
  end
end

function InteractMount:GetOff(charid, lastNpc)
  local lastCount = self.cpCount
  if not self.cpInited then
    InteractMount.super.RemoveWatchPlayerGuid(self, charid)
    for k, v in pairs(self.waitCpMap) do
      if v == charid then
        self.waitCpMap[k] = nil
        break
      end
    end
  else
    InteractMount.super.GetOff(self, charid)
  end
  if self.cpCount == lastCount then
    return
  end
  local creature = self:GetCreature(charid)
  if creature then
    creature:Client_NoAction(false)
    creature:Logic_LockRotation(false)
  end
  if charid == Game.Myself.data.id and not lastNpc then
    Game.Myself:Client_NoMove(false)
    Game.Myself.data:Client_SetProps(MyselfData.ClientProps.DisableRotateInPhotographMode, false)
  end
end

function InteractMount:PlayOnAction(creature, name)
  creature.assetRole:PlayAction_Simple(name)
end

function InteractMount:TryNotifyGetOn()
  if Game.MapManager:IsForbidMultiMount() then
    MsgManager.ShowMsgByID(41343)
    return false
  end
  if self:IsFull() and not self:HasFakeCreature() then
    MsgManager.ShowMsgByID(28000)
    return false
  end
  ServiceNUserProxy.Instance:CallRideMultiMountUserCmd(self.id, self:GetNearestCP())
  return true
end

function InteractMount:TryNotifyGetOff()
  ServiceNUserProxy.Instance:CallRideMultiMountUserCmd(0)
  return true
end

function InteractMount:TryChangeSeat()
  local cpid = self:GetRandomCP()
  if not cpid then
    MsgManager.ShowMsgByID(40565)
    return
  end
  ServiceNUserProxy.Instance:CallRideMultiMountUserCmd(self.id, cpid)
end

function InteractMount:CheckPosition(npc)
  return not self:IsFull()
end

function InteractMount:GetNearestCP()
  if not self.cpInited or self:IsFull() then
    return nil
  end
  local myselfPos = Game.Myself:GetPosition()
  local tmpArray = ReusableTable.CreateArray()
  local cpInfo
  for cpID, tsfCP in pairs(self.cpTransform) do
    cpInfo = ReusableTable.CreateTable()
    cpInfo.id = cpID
    cpInfo.distance = VectorDistanceXZ(LuaGeometry.GetTempVector3(LuaGetPosition(tsfCP)), myselfPos)
    tmpArray[#tmpArray + 1] = cpInfo
  end
  table.sort(tmpArray, function(l, r)
    return l.distance < r.distance
  end)
  local nearestID = tmpArray[1].id
  for i = 1, #tmpArray do
    ReusableTable.DestroyAndClearTable(tmpArray[i])
  end
  ReusableTable.DestroyAndClearArray(tmpArray)
  return nearestID
end

function InteractMount:GetRandomCP()
  if not self.cpInited or self:IsFull() then
    return nil
  end
  local cps = ReusableTable.CreateArray()
  for cpID, tsfCP in pairs(self.cpTransform) do
    if not self.cpMap[cpID] then
      cps[#cps + 1] = cpID
    end
  end
  local value = 0 < #cps and cps[math.random(#cps)] or nil
  ReusableTable.DestroyAndClearArray(cps)
  return value
end

function InteractMount:GetNpc()
  return SceneCreatureProxy.FindCreature(self.id)
end

function InteractMount:GetCP(npc, cpid)
  return self:TryInitCpTransform() and self.cpTransform[cpid]
end

function InteractMount:TryInitCpTransform()
  if self.cpInited then
    return true
  end
  local master = SceneCreatureProxy.FindCreature(self.id)
  if not master then
    return false
  end
  local complete = master.assetRole.complete
  local comMount = complete and complete.mount
  if not comMount then
    return false
  end
  for cpID, actionID in pairs(self.staticData.MountInfo) do
    self.cpTransform[cpID] = comMount:GetCP(cpID - 1)
  end
  self.cpInited = true
  for k, v in pairs(self.waitCpMap) do
    self:GetOn(k, v)
    self.waitCpMap[k] = nil
  end
  return true
end

function InteractMount:DoConstruct(asArray, data)
  InteractMount.super.DoConstruct(self, asArray, data)
  self.cpInited = false
  self.cpTransform = {}
  self.waitCpMap = {}
  self:TryInitCpTransform()
end

function InteractMount:DoDeconstruct(asArray)
  InteractMount.super.DoDeconstruct(self, asArray)
  self.cpInited = nil
  self.cpTransform = nil
  self.waitCpMap = nil
  self.npcid = nil
end
