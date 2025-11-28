InteractNpc = class("InteractNpc", InteractBase)
InteractNpc.GetOnState = {Wait = 1, Ready = 2}
InteractNpc.InteractType = {
  Normal = 1,
  Train = 2,
  FlowerCar = 4,
  SceneObject = 5,
  LocalSimple = 6,
  LocalHug = 7,
  LocalVisit = 8,
  LocalCollect = 9,
  LocalServerSimple = 10,
  LocalCollectHug = 11
}
InteractNpc.Features = {ForbidMove = 1}
local updateInterval = 1
local cameraDuration = 0.3
local cameraViewPort = LuaVector3()
local cameraRotation = LuaVector3()
local VectorDistanceXZ = VectorUtility.DistanceXZ_Square
local TableClear = TableUtility.TableClear
local PartIndexBody = Asset_Role.PartIndex.Body
local Asign_3 = VectorUtility.Asign_3
local Vector3Equal = LuaVector3.Equal

function InteractNpc.Create(data, id)
  local args = InteractBase.GetArgs(data, id)
  local interactType = data.Type
  if interactType == InteractNpc.InteractType.Normal then
    return ReusableObject.Create(InteractNpc, false, args)
  elseif interactType == InteractNpc.InteractType.Train then
    return ReusableObject.Create(InteractTrain, false, args)
  elseif interactType == InteractNpc.InteractType.FlowerCar then
    return ReusableObject.Create(InteractFlowerCar, false, args)
  elseif interactType == InteractNpc.InteractType.SceneObject then
    return ReusableObject.Create(InteractSceneObject, false, args)
  elseif interactType == InteractNpc.InteractType.LocalSimple then
    return ReusableObject.Create(InteractLocalSimple, false, args)
  elseif interactType == InteractNpc.InteractType.LocalHug then
    return ReusableObject.Create(InteractLocalHug, false, args)
  elseif interactType == InteractNpc.InteractType.LocalVisit then
    return ReusableObject.Create(InteractLocalVisit, false, args)
  elseif interactType == InteractNpc.InteractType.LocalCollect then
    return ReusableObject.Create(InteractLocalCollect, false, args)
  elseif interactType == InteractNpc.InteractType.LocalServerSimple then
    return ReusableObject.Create(InteractLocalServerSimple, false, args)
  elseif interactType == InteractNpc.InteractType.LocalCollectHug then
    return ReusableObject.Create(InteractLocalCollectHug, false, args)
  end
end

function InteractNpc:ctor()
  InteractNpc.super.ctor(self)
  self.waitCpMap = {}
end

function InteractNpc:Update(time, deltaTime)
  if self.id == nil then
    return false
  end
  if self:CheckLockCondition() == false then
    return false
  end
  local npc
  if self.getOnState == self.GetOnState.Wait then
    npc = self:GetNpc()
    if npc ~= nil and npc.assetRole:GetPartObject(PartIndexBody) ~= nil then
      local hasPlayer = false
      for k, v in pairs(self.waitCpMap) do
        self:GetOn(k, v)
        self.waitCpMap[k] = nil
        hasPlayer = true
      end
      if hasPlayer then
        local actionid = self.staticData.ActionID
        if actionid then
          local actionName = string.format("state%d", actionid)
          npc:Server_PlayActionCmd(actionName, nil, false)
        end
      end
      self.getOnState = self.GetOnState.Ready
    end
  end
  if time < self.nextUpdateTime then
    return self.isInTrigger
  end
  if self.needNotifyMyself then
    local myself = Game.Myself
    local angleY = myself.assetRole.completeTransform.eulerAngles.y
    if self.prevNotifyAngleY == nil or self.prevNotifyAngleY ~= angleY then
      myself:Client_SyncRotationY(angleY)
      self.prevNotifyAngleY = angleY
    end
    local ret, pos = NavMeshUtility.Better_Sample(myself:GetPosition(), LuaGeometry.GetTempVector3())
    if not ret then
      pos = myself:GetPosition()
    end
    if self.prevNotifyPosition == nil or not Vector3Equal(self.prevNotifyPosition, pos) then
      ServiceInteractCmdProxy.Instance:CallPosUpdateInterCmd(pos)
      self.prevNotifyPosition = Asign_3(self.prevNotifyPosition, pos)
    end
  end
  self.nextUpdateTime = time + updateInterval
  if self.needCheckTrigger == false then
    return false
  end
  if self.triggerCheckRange == nil then
    return false
  end
  npc = self:GetNpc()
  if npc == nil then
    return false
  end
  self.isInTrigger = self:CheckPosition(npc) or self.needNotifyMyself
  return self.isInTrigger
end

function InteractNpc:RequestGetOn(cpid, charid)
  if self.getOnState == self.GetOnState.Wait then
    self.waitCpMap[cpid] = charid
  else
    self:GetOn(cpid, charid)
  end
end

function InteractNpc:RequestGetOff(charid)
  if self.getOnState == self.GetOnState.Wait then
    for k, v in pairs(self.waitCpMap) do
      if v == charid then
        self.waitCpMap[k] = nil
        break
      end
    end
  else
    self:GetOff(charid)
  end
end

function InteractNpc:GetOn(cpid, charid)
  local lastCount = self.cpCount
  InteractNpc.super.GetOn(self, cpid, charid)
  local myself = Game.Myself
  if charid == myself.data.id then
    local configViewPort = self.staticData.CameraViewPort
    local configRotation = self.staticData.CameraRotation
    if 0 < #configViewPort and 0 < #configRotation then
      LuaVector3.Better_Set(cameraViewPort, configViewPort[1], configViewPort[2], configViewPort[3])
      LuaVector3.Better_Set(cameraRotation, configRotation[1], configRotation[2], configRotation[3])
      local viewport, offset = FunctionCameraEffect.Me():AdjustCameraViewportAndFocusoffset(CameraController.singletonInstance, cameraViewPort, nil, configRotation[1])
      self.cft = CameraEffectFocusAndRotateTo.new(myself.assetRole.completeTransform, offset, viewport, cameraRotation, cameraDuration)
      FunctionCameraEffect.Me():Start(self.cft)
    end
    if self:IsForbidMove() and self.cpCount ~= lastCount then
      Game.InputManager.disableMove = Game.InputManager.disableMove + 1
      Game.Myself.data:Client_SetProps(MyselfData.ClientProps.DisableRotateInPhotographMode, true)
    end
    if self.staticData.Param.MoveMultiMount then
      self.needNotifyMyself = true
    end
  end
end

function InteractNpc:GetOff(charid)
  local lastCount = self.cpCount
  InteractNpc.super.GetOff(self, charid)
  if charid == Game.Myself.data.id then
    if self.cft ~= nil then
      FunctionCameraEffect.Me():End(self.cft)
      self.cft = nil
    end
    if self:IsForbidMove() and self.cpCount ~= lastCount then
      Game.InputManager.disableMove = Game.InputManager.disableMove - 1
      Game.Myself.data:Client_SetProps(MyselfData.ClientProps.DisableRotateInPhotographMode, false)
    end
    MsgManager.ShowMsgByID(28001)
    self.needNotifyMyself = nil
  end
end

function InteractNpc:TryNotifyGetOn()
  if self:IsFull() then
    MsgManager.ShowMsgByID(28000)
    return false
  end
  ServiceInteractCmdProxy.Instance:CallConfirmMountInterCmd(self.id)
  return true
end

function InteractNpc:TryNotifyGetOff()
  ServiceInteractCmdProxy.Instance:CallCancelMountInterCmd(self.id)
  return true
end

function InteractNpc:CheckPosition(npc)
  return InteractNpcManager.CheckMyselfInNpcInteractArea(self.staticData.id) and VectorDistanceXZ(npc:GetPosition(), Game.Myself:GetPosition()) < self.triggerCheckRange * self.triggerCheckRange
end

function InteractNpc:GetNpc()
  return NSceneNpcProxy.Instance:Find(self.id)
end

function InteractNpc:GetCP(npc, cpid)
  return npc.assetRole:GetCP(cpid)
end

function InteractNpc:IsNotifyChange()
  return true
end

function InteractNpc:IsAuto()
  return self.staticData.Auto == 1
end

function InteractNpc:PlayOffAction(creature)
  creature:Client_PlayAction(creature:GetIdleAction())
end

function InteractNpc:IsForbidMove()
  return self.staticData.Features and self.staticData.Features & InteractNpc.Features.ForbidMove > 0
end

function InteractNpc:DoConstruct(asArray, data)
  InteractNpc.super.DoConstruct(self, asArray, data)
  self.needCheckTrigger = not self:IsAuto()
  if self.needCheckTrigger then
    self.triggerCheckRange = self.staticData.Range
  end
  self.nextUpdateTime = 0
  self.getOnState = self.GetOnState.Wait
end

function InteractNpc:DoDeconstruct(asArray)
  self.nextUpdateTime = nil
  self.isInTrigger = nil
  self.needCheckTrigger = nil
  self.triggerCheckRange = nil
  self.getOnState = nil
  self.cft = nil
  self.needNotifyMyself = nil
  self.prevNotifyAngleY = nil
  if self.prevNotifyPosition ~= nil then
    self.prevNotifyPosition:Destroy()
    self.prevNotifyPosition = nil
  end
  TableClear(self.waitCpMap)
  InteractNpc.super.DoDeconstruct(self, asArray)
end
