autoImport("InteractNpc")
InteractSceneObject = class("InteractSceneObject", InteractNpc)
local GameObjectType = Game.GameObjectType.InteractNpc
local VectorDistanceXZ = VectorUtility.DistanceXZ_Square
local Const_V3_zero = LuaGeometry.Const_V3_zero

function InteractSceneObject:GetNpc()
  return Game.GameObjectManagers[GameObjectType]:GetInteractObject(self.id)
end

function InteractSceneObject:GetCP(npc, cpid)
  return self.cpTransform[cpid]
end

function InteractSceneObject:DoConstruct(asArray, data)
  InteractSceneObject.super.DoConstruct(self, asArray, data)
  local objData = self:GetNpc()
  local property = objData:GetProperty(0)
  local cpCount = property and tonumber(property) or 0
  self.cpTransform = {}
  for i = 1, cpCount do
    self.cpTransform[i] = objData:GetComponentProperty(i - 1)
  end
  self.getOnState = InteractNpc.GetOnState.Ready
  self.isrunning = true
end

function InteractSceneObject:DoDeconstruct(asArray)
  InteractSceneObject.super.DoDeconstruct(self, asArray)
  self.cpTransform = nil
  self.isrunning = nil
end

function InteractSceneObject:AddCpCount(cpid)
  local mountInfo = self.staticData.MountInfo
  if mountInfo[cpid] then
    self.cpCount = self.cpCount + 1
  end
end

function InteractSceneObject:MinusCpCount(cpid)
  local mountInfo = self.staticData.MountInfo
  if mountInfo[cpid] then
    self.cpCount = self.cpCount - 1
  end
end

function InteractSceneObject:CheckPosition(npc)
  if not self.isrunning then
    return false
  end
  local npcPos = LuaGeometry.TempGetPosition(npc.transform)
  return InteractNpcManager.CheckMyselfInNpcInteractArea(self.staticData.id) and VectorDistanceXZ(npcPos, Game.Myself:GetPosition()) < self.triggerCheckRange * self.triggerCheckRange
end

function InteractSceneObject:TryNotifyGetOn()
  if self:IsFull() then
    MsgManager.ShowMsgByID(28000)
    return false
  end
  redlog("ServiceInteractCmdProxy.Instance:CallConfirmMoveMountInterCmd", tostring(self.id))
  ServiceInteractCmdProxy.Instance:CallConfirmMoveMountInterCmd(self.id)
  return true
end

function InteractSceneObject:TryNotifyGetOff()
  ServiceInteractCmdProxy.Instance:CallCancelMoveMountInterCmd(self.id)
  return true
end

function InteractSceneObject:FakeGetOn(cpid, charid)
  if self.cpMap[cpid] == charid then
    return
  end
  local cpTransform = self:GetCP(nil, cpid)
  if cpTransform == nil then
    return
  end
  local assetRole = Game.InteractNpcManager:GetFakeAssetRole(charid)
  if assetRole == nil then
    return
  end
  self.cpCount = self.cpCount + 1
  self.cpMap[cpid] = charid
  assetRole:SetParent(cpTransform, true)
  assetRole:SetPosition(Const_V3_zero)
  assetRole:SetEulerAngles(Const_V3_zero)
  assetRole:SetScale(1)
  assetRole:SetShadowEnable(false)
  assetRole:SetMountDisplay(false)
  assetRole:SetWingDisplay(false)
  assetRole:SetTailDisplay(false)
  local actionID = self.staticData.MountInfo[cpid]
  if actionID ~= nil then
    local actionInfo = Table_ActionAnime[actionID]
    if actionInfo == nil then
      return
    end
    local animParams = Asset_Role.GetPlayActionParams(actionInfo.Name)
    assetRole:PlayAction(animParams)
  end
end

function InteractSceneObject:FakeGetOff(charid)
  for k, v in pairs(self.cpMap) do
    if v == charid then
      self.cpMap[k] = nil
      self.cpCount = self.cpCount - 1
      break
    end
  end
end

function InteractSceneObject:UpdateState(state, arrivetime)
end

function InteractSceneObject:SetRunningState(state)
  self.isrunning = state
end
