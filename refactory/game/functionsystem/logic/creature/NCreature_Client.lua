local tempVector3 = LuaVector3.Zero()
local TempOffsetMap = {
  [RoleDefines_EP.Top] = LuaVector3.New(0, 1.8, 0)
}
local SpEffectGuid = 1
local TableCustomSeatName = "Table_CustomSeat"

function NCreature:Client_RegisterFollow(transform, offset, epID, lostCallback, lostCallbackArg, tempOffset, isFixedOffset)
  if nil == offset then
    LuaVector3.Better_Set(tempVector3, 0, 0, 0)
    offset = tempVector3
  end
  if nil == epID then
    epID = 0
  end
  if nil == tempOffset then
    if 0 < epID then
      tempOffset = TempOffsetMap[epID]
    end
    if nil == tempOffset then
      tempOffset = LuaGeometry.Const_V3_zero
    end
  end
  isFixedOffset = isFixedOffset or false
  Game.RoleFollowManager:RegisterFollow(transform, self.assetRole.complete, offset, tempOffset, epID, lostCallback, lostCallbackArg, isFixedOffset)
end

function NCreature:Client_UnregisterFollow(transform)
  Game.RoleFollowManager:UnregisterFollow(transform)
end

function NCreature:Client_RegisterFollowCP(transform, cpID, lostCallback, lostCallbackArg)
  if nil == cpID then
    cpID = 0
  end
  Game.RoleFollowManager:RegisterFollowCP(transform, self.assetRole.complete, cpID, lostCallback, lostCallbackArg)
end

function NCreature:Client_UnregisterFollowCP(transform)
  Game.RoleFollowManager:UnregisterFollow(transform)
end

function NCreature:Client_PlayAction(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd, actionSpeed, spExpression, blendContext, ignoreWeapon)
  if not self:IsDressed() then
    return
  end
  self.ai:PushCommand(FactoryAICMD.GetPlayActionCmd(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd, actionSpeed, spExpression, blendContext, ignoreWeapon), self)
end

function NCreature:Client_PlayAction2(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd, actionSpeed, spExpression)
  if not self:HasAllPartLoaded() then
    return
  end
  self.ai:PushCommand(FactoryAICMD.GetPlayActionCmd(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd, actionSpeed, spExpression), self)
end

function NCreature:Client_PlayActionMove(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd, spExpression, ignoreWeapon)
  if not self:IsDressed() then
    return
  end
  name = name or self:GetMoveAction()
  local moveActionScale = 1
  local staticData = self.data.staticData
  if nil ~= staticData and nil ~= staticData.MoveSpdRate then
    moveActionScale = staticData.MoveSpdRate
  end
  local moveSpeed = self.data.props:GetPropByName("MoveSpd"):GetValue()
  local actionSpeed = self.moveActionSpd or moveActionScale * moveSpeed
  self.ai:PushCommand(FactoryAICMD.GetPlayActionCmd(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd, actionSpeed, spExpression, nil, ignoreWeapon), self)
end

function NCreature:Client_PlayActionIdle(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd, actionSpeed, spExpression, ignoreWeapon)
  if not self:IsDressed() then
    return
  end
  name = name or self:GetIdleAction()
  self.ai:PushCommand(FactoryAICMD.GetPlayActionCmd(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd, actionSpeed, spExpression, nil, ignoreWeapon), self)
end

function NCreature:Client_SetDirCmd(mode, dir, noSmooth)
  self.ai:PushCommand(FactoryAICMD.GetSetAngleYCmd(mode, dir, noSmooth), self)
end

function NCreature:Client_PlaceXYZTo(x, y, z, div, ignoreNavMesh)
  LuaVector3.Better_Set(tempVector3, x, y, z)
  if div ~= nil then
    LuaVector3.Div(tempVector3, div)
  end
  self:Server_SetPosCmd(tempVector3, ignoreNavMesh)
end

function NCreature:Client_PlaceTo(p, ignoreNavMesh)
  self.ai:PushCommand(FactoryAICMD.GetPlaceToCmd(p, ignoreNavMesh), self)
end

function NCreature:Client_SetMoveSpeed(moveSpeed)
  self.logicTransform:SetMoveSpeed(self.data:ReturnMoveSpeedWithFactor(moveSpeed))
end

function NCreature:Client_GetMoveSpeed()
  local rawSpeed = self.logicTransform:GetMoveSpeed()
  return rawSpeed and rawSpeed / CreatureData.MoveSpeedFactor or 1
end

function NCreature:Client_DirMove(dir, ignoreNavMesh, customMoveActionName)
  self.ai:PushCommand(FactoryAICMD.GetDirMoveCmd(dir, ignoreNavMesh, customMoveActionName))
end

function NCreature:Client_DirMoveEnd(customIdleAction)
  self.ai:PushCommand(FactoryAICMD.GetDirMoveEndCmd(customIdleAction))
end

local spEKeyArray = {}

function NCreature:GetClientSpEffectKey(targetGUID, effectID)
  return "Client_" .. self.data.id .. "_" .. targetGUID .. "_" .. effectID
end

function NCreature:Client_AddSpEffect(targetGUID, effectID, duration)
  local data = Table_SpEffect[effectID]
  if data == nil then
    return
  end
  local effectType = data.Type
  local EffectClass = SpEffectWorkerClass[effectType]
  if EffectClass == nil then
    return
  end
  if self.spEffects == nil then
    self.spEffects = {}
  end
  spEKeyArray[1] = "Client"
  spEKeyArray[2] = self.data.id
  spEKeyArray[3] = targetGUID
  spEKeyArray[4] = effectID
  local key = table.concat(spEKeyArray, "_")
  local effect = self:GetClientSpEffect(key)
  if effect == nil then
    effect = EffectClass.Create(effectID)
    self.spEffects[key] = {effect}
    SpEffectGuid = SpEffectGuid + 1
  end
  local args = ReusableTable.CreateArray()
  args[1] = targetGUID
  args[2] = duration
  effect:SetArgs(args, self)
  ReusableTable.DestroyArray(args)
end

function NCreature:GetClientSpEffect(key)
  local spEffects = self.spEffects
  if spEffects == nil then
    return
  end
  spEffects = spEffects[key]
  if spEffects == nil then
    return
  end
  return spEffects[1]
end

function NCreature:Client_RemoveSpEffect(key)
  if self.spEffects == nil then
    return
  end
  local effect = self.spEffects[key]
  if nil ~= effect then
    for _, v in ipairs(effect) do
      v:Destroy()
    end
    self.spEffects[key] = nil
  end
end

function NCreature:Client_GetOnSeat(seatID)
  if self.customSeat ~= nil then
    self.customSeat:Destroy()
  end
  if _G[TableCustomSeatName] == nil then
    autoImport(TableCustomSeatName)
  end
  local data = Table_CustomSeat[seatID]
  if data ~= nil then
    self.customSeat = CustomSeat.Create(data)
    self.customSeat:GetOn(self)
  end
end

function NCreature:Client_GetOffSeat()
  if self.customSeat ~= nil then
    self.customSeat:GetOff(self)
    self.customSeat:Destroy()
    self.customSeat = nil
  end
end

function NCreature:Client_SetIsMoveToWorking(isWorking, customMoveActionName)
  self.isMoveToWorking = isWorking
  self.customMoveActionName = customMoveActionName
end

function NCreature:Client_IsMoveToWorking()
  return self.isMoveToWorking == true
end

function NCreature:Client_SetMoveToCustomActionName(customMoveActionName)
  self.customMoveActionName = customMoveActionName
end

function NCreature:Client_GetMoveToCustomActionName()
  return self.customMoveActionName
end

function NCreature:Client_IsMoving()
  return self:Client_IsMoveToWorking() or self:Client_IsDirMoving()
end

function NCreature:Client_SetIsDirMoving(isDirMove, customMoveActionName)
  self.isDirMoving = isDirMove
  self.customMoveActionName = customMoveActionName
end

function NCreature:Client_IsDirMoving()
  return self.isDirMoving
end

local HugNpcGUID = 0

function NCreature:Client_AddHugRole(npcId, dirX, dirY, offset, scale)
  if not self.buffHugRole then
    HugNpcGUID = HugNpcGUID + 1
    self.buffHugRole = FakeNPlayer.CreateNpc(HugNpcGUID, npcId, self:GetPosition())
  elseif self.buffHugRole.data.npcid ~= npcId then
    self.buffHugRole:Destroy()
    HugNpcGUID = HugNpcGUID + 1
    self.buffHugRole = FakeNPlayer.CreateNpc(HugNpcID, npcId, self:GetPosition())
  else
    self.buffHugRole:Server_SetPosCmd(self:GetPosition())
  end
  if not scale then
    local npcConfig = Table_Npc[npcId]
    scale = npcConfig and npcConfig.Scale or 1
  end
  self.buffHugRole:SetBeHoldedInfo(dirX, dirY, offset, scale)
  self.buffHugRole:Server_SetScaleCmd(scale, true)
  self.buffHugRole:Server_SetHandInHand(self.data.id, true, true)
  redlog("Server_SetHandInHand", self.data.id)
  if self.assetRole:MountDisplaying() then
    local parts, partsNoDestroy = self:GetDressParts()
    if parts then
      parts[Asset_Role.PartIndex.Mouth] = 0
      self.assetRole:Redress(parts, isLoadFirst)
      self:DestroyDressParts(parts, partsNoDestroy)
      self.client_NeedRedress = true
    end
  end
  self.dressLocked = true
  self:FreezeHold(true)
  local skillConfig = GameConfig.HugNpcSkill[npcId]
  if skillConfig then
    self:Client_HandlerHugSkillPopUp(true, skillConfig.skillid)
  end
end

function NCreature:Client_RemoveHugRole()
  self:FreezeHold(false)
  if not self.buffHugRole then
    return
  end
  self.dressLocked = false
  if self.buffHugRole then
    self.buffHugRole:Server_SetHandInHand(self.data.id, false)
    self.buffHugRole:Destroy()
  end
  self.buffHugRole = nil
  if self.client_NeedRedress then
    self:ReDress()
    self.client_NeedRedress = nil
  end
  self:Client_HandlerHugSkillPopUp(false)
end

function NCreature:Client_HandlerHugSkillPopUp(isAdd, skillid)
end

function NCreature:Client_PlayUseSkill(phaseData)
  local skillID = phaseData:GetSkillID()
  local staticData = Table_Skill[skillID]
  local speakName = staticData.NameZh and OverSea.LangManager.Instance():GetLangByKey(staticData.NameZh) .. "!!" or nil
  if speakName then
    local logicParam = staticData.Logic_Param or {}
    if logicParam and logicParam.noSpeak == 1 then
    else
      local sceneUI = self:GetSceneUI()
      if nil ~= sceneUI then
        sceneUI.roleTopUI:SpeakSkill(speakName)
      end
    end
  end
  return true
end
