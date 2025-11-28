LogicManager_Creature_Userdata = class("LogicManager_Creature_Userdata")
local ChangeDressData = {
  ProtoCommon_pb.EUSERDATATYPE_FACE,
  ProtoCommon_pb.EUSERDATATYPE_HAIR,
  ProtoCommon_pb.EUSERDATATYPE_BACK,
  ProtoCommon_pb.EUSERDATATYPE_TAIL,
  ProtoCommon_pb.EUSERDATATYPE_LEFTHAND,
  ProtoCommon_pb.EUSERDATATYPE_RIGHTHAND,
  ProtoCommon_pb.EUSERDATATYPE_BODY,
  ProtoCommon_pb.EUSERDATATYPE_HEAD,
  ProtoCommon_pb.EUSERDATATYPE_EYE,
  ProtoCommon_pb.EUSERDATATYPE_MOUNT,
  ProtoCommon_pb.EUSERDATATYPE_MOUTH,
  ProtoCommon_pb.EUSERDATATYPE_HAIRCOLOR,
  ProtoCommon_pb.EUSERDATATYPE_CLOTHCOLOR,
  ProtoCommon_pb.EUSERDATATYPE_RIDING_NPC
}

function LogicManager_Creature_Userdata:ctor()
  self.dirtyCalls = {}
  self.updateCalls = {}
  self.setCalls = {}
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_DIR, self.SetDir)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_BODYSCALE, self.SetScale)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_STATUS, self.SetStatus)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_NORMAL_SKILL, self.SetNormalSkill)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_ROLELEVEL, self.SetRoleLevel)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_PET_PARTNER, self.UpdatePartner)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_HANDID, self.UpdateHandId)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_TWINS_ACTIONID, self.UpdateTwinsActionId)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_RACE, self.UpdateRace)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_SHAPE, self.UpdateShape)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_BOSSTYPE, self.UpdateBossType)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_XDIR, self.SetXDir)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_RIDE_REFORM, self.SetMountForm)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_SHIELD_HP, self.RefreshShieldHp)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_SHIELD_MAXHP, self.RefreshShieldHp)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_ATTRIBUTE_VALUE, self.RefreshAttributeChange)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_ATTRIBUTE_SPEED, self.RefreshAttributeChange)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_RESISTANCE_VALUE, self.RefreshResistance)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_RESISTANCE_SPEED, self.RefreshResistance)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_BALANCE_VALUE, self.RefreshBalance)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_SHIELD, self.RefreshNormalShield)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_UP_CHARID, self.UpdatePlayerRider_Up)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_DOWN_CHARID, self.UpdatePlayerRider_Down)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_DOWN_CHARID_RIDE, self.UpdatePlayerRider_DownRide)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_PVP_CAMP, self.UpdatePvpCamp)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_MOUNT_ROLE, self.UpdateRoleRide)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_DIR, self.UpdateDir)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_NAME, self.UpdateName)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_BODYSCALE, self.UpdateScale)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_STATUS, self.UpdateStatus)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_NORMAL_SKILL, self.SetNormalSkill)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_ROLELEVEL, self.UpdateRoleLevel)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_PET_PARTNER, self.UpdatePartner)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_HANDID, self.UpdateHandId)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_TWINS_ACTIONID, self.UpdateTwinsActionId)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_COOKER_LV, self.UpdateCooklv)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_RACE, self.UpdateRace)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_SHAPE, self.UpdateShape)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_BOSSTYPE, self.UpdateBossType)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_XDIR, self.SetXDir)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_RIDE_REFORM, self.SetMountForm)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_SHIELD_HP, self.RefreshShieldHp)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_SHIELD_MAXHP, self.RefreshShieldHp)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_RESISTANCE_VALUE, self.RefreshResistance)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_RESISTANCE_SPEED, self.RefreshResistance)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_ATTRIBUTE_VALUE, self.RefreshAttributeChange)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_ATTRIBUTE_SPEED, self.RefreshAttributeChange)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_PVP_CAMP, self.UpdatePvpCamp)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_BALANCE_VALUE, self.RefreshBalance)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_SHIELD, self.RefreshNormalShield)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_UP_CHARID, self.UpdatePlayerRider_Up)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_DOWN_CHARID, self.UpdatePlayerRider_Down)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_DOWN_CHARID_RIDE, self.UpdatePlayerRider_DownRide)
  self:AddDirtyCall(ProtoCommon_pb.EUSERDATATYPE_UP_CHARID, self.UpdatePlayerRider_Up)
  self:AddDirtyCall(ProtoCommon_pb.EUSERDATATYPE_DOWN_CHARID, self.UpdatePlayerRider_Down)
  self:AddDirtyCall(ProtoCommon_pb.EUSERDATATYPE_DOWN_CHARID_RIDE, self.UpdatePlayerRider_DownRide)
  self:AddDirtyCall(ProtoCommon_pb.EUSERDATATYPE_MOUNT_ROLE, self.UpdateRoleRide)
  for i = 1, #ChangeDressData do
    self:AddDirtyCall(ChangeDressData[i], self.SetChangeDressDirty)
  end
end

function LogicManager_Creature_Userdata:SetUserData(init, creature, userdata, id, value, bytes, changeJob)
  if self.dirtyCalls[id] ~= nil then
    userdata:DirtyUpdateByID(id, value, bytes)
  elseif not init then
    local oldValue = userdata:UpdateByID(id, value, bytes)
    local call = self.updateCalls[id]
    if call ~= nil then
      call(self, creature, id, oldValue, value, bytes, changeJob)
    end
  else
    userdata:SetByID(id, value, bytes)
    local call = self.setCalls[id]
    if call ~= nil then
      call(self, creature, id, nil, value, bytes, changeJob)
    end
  end
end

function LogicManager_Creature_Userdata:IsDirty(id)
  return self.dirtyCalls[id] ~= nil
end

function LogicManager_Creature_Userdata:AddDirtyCall(id, func)
  self.dirtyCalls[id] = func
end

function LogicManager_Creature_Userdata:AddUpdateCall(id, func)
  self.updateCalls[id] = func
end

function LogicManager_Creature_Userdata:AddSetCall(id, func)
  self.setCalls[id] = func
end

function LogicManager_Creature_Userdata:RemoveDirtyCall(id)
  self.dirtyCalls[id] = nil
end

function LogicManager_Creature_Userdata:RemoveUpdateCall(id)
  self.updateCalls[id] = nil
end

function LogicManager_Creature_Userdata:RemoveSetCall(id)
  self.setCalls[id] = nil
end

function LogicManager_Creature_Userdata:CheckDirtyDatas(ncreature)
  local userDatas = ncreature.data.userdata
  local call
  if userDatas and userDatas.hasDirtyDatas then
    for k, v in pairs(userDatas.dirtyIDs) do
      call = self.dirtyCalls[k]
      if call ~= nil then
        call(self, ncreature, k, v, userDatas:GetById(k))
      end
      userDatas.dirtyIDs[k] = nil
    end
    userDatas.hasDirtyDatas = false
  end
  self:CheckDressDirty(ncreature)
end

function LogicManager_Creature_Userdata:CheckDressDirty(ncreature)
  if self.changeDressDirty then
    self.changeDressDirty = false
    ncreature:ReDress()
  end
end

function LogicManager_Creature_Userdata:CheckHasAnyDressData(ncreature)
  if ncreature ~= nil and ncreature.data ~= nil then
    local userDatas = ncreature.data.userdata
    if userDatas then
      local v
      for i = 1, #ChangeDressData do
        v = userDatas:GetById(ChangeDressData[i])
        if v ~= nil and v ~= 0 then
          return true
        end
      end
    end
  end
  return false
end

function LogicManager_Creature_Userdata:SetChangeDressDirty(ncreature, userDataID, oldValue, newValue)
  self.changeDressDirty = true
end

function LogicManager_Creature_Userdata:CheckUpdateDataCall(ncreature, userDataID, oldValue, newValue, newData)
  local call = self.updateCalls[userDataID]
  if call then
    call(self, ncreature, userDataID, oldValue, newValue, newData)
  end
end

function LogicManager_Creature_Userdata:CheckSetDataCall(ncreature, userDataID, oldValue, newValue, newData)
  local call = self.setCalls[userDataID]
  if call then
    call(self, ncreature, userDataID, oldValue, newValue, newData)
  end
end

function LogicManager_Creature_Userdata:SetDir(ncreature, userDataID, oldValue, newValue)
  ncreature:Server_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, newValue / 1000, true)
end

function LogicManager_Creature_Userdata:UpdateDir(ncreature, userDataID, oldValue, newValue)
  ncreature:Server_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, newValue / 1000)
end

function LogicManager_Creature_Userdata:SetScale(ncreature, userDataID, oldValue, newValue)
  ncreature:Server_SetScaleCmd(newValue / 100, true)
end

function LogicManager_Creature_Userdata:UpdateScale(ncreature, userDataID, oldValue, newValue)
  ncreature:Server_SetScaleCmd(newValue / 100)
end

function LogicManager_Creature_Userdata:SetStatus(ncreature, userDataID, oldValue, newValue)
  self:_RefreshStatus(ncreature, newValue, true)
end

function LogicManager_Creature_Userdata:UpdateStatus(ncreature, userDataID, oldValue, newValue)
  self:_RefreshStatus(ncreature, newValue, false, oldValue)
end

function LogicManager_Creature_Userdata:SetRoleLevel(ncreature, userDataID, oldValue, newValue)
  ncreature.data:SetBaseLv(newValue)
end

function LogicManager_Creature_Userdata:UpdateRoleLevel(ncreature, userDataID, oldValue, newValue)
  ncreature.data:SetBaseLv(newValue)
end

function LogicManager_Creature_Userdata:UpdatePartner(ncreature, userDataID, oldValue, newValue)
  ncreature:SetPartner(newValue)
end

function LogicManager_Creature_Userdata:UpdateName(ncreature, userDataID, oldValue, newValue)
  ncreature.data.name = ncreature.data.userdata:GetBytes(UDEnum.NAME)
  GameFacade.Instance:sendNotification(CreatureEvent.Name_Change, ncreature)
end

function LogicManager_Creature_Userdata:_RefreshStatus(ncreature, value, isSet, oldValue)
  if value == ProtoCommon_pb.ECREATURESTATUS_DEAD then
    self:_Die(ncreature, isSet)
    if ncreature:GetCreatureType() == Creature_Type.Me then
      GameFacade.Instance:sendNotification(MainViewEvent.ShowOrHide, false)
      GameFacade.Instance:sendNotification(MyselfEvent.DeathStatus)
      EventManager.Me():PassEvent(MyselfEvent.DeathStatus)
    elseif ncreature:GetCreatureType() == Creature_Type.Player then
      GameFacade.Instance:sendNotification(PlayerEvent.DeathStatusChange, ncreature)
      EventManager.Me():PassEvent(PlayerEvent.DeathStatusChange, ncreature)
    elseif ncreature:IsRobotNpc() then
      GameFacade.Instance:sendNotification(PlayerEvent.DeathStatusChange, ncreature)
    else
      Game.Myself:TryCheckLockTarget(ncreature.data.id)
    end
  elseif value == ProtoCommon_pb.ECREATURESTATUS_LIVE then
    if ncreature:GetCreatureType() == Creature_Type.Me then
      GameFacade.Instance:sendNotification(MainViewEvent.ShowOrHide, true)
      GameFacade.Instance:sendNotification(MyselfEvent.ReliveStatus)
      if MyselfProxy.Instance:IsProfessionAlinia() then
        Game.Myself:ResetCamera(Game.Myself)
      end
    elseif ncreature:GetCreatureType() == Creature_Type.Player then
      GameFacade.Instance:sendNotification(PlayerEvent.DeathStatusChange, ncreature)
    elseif ncreature:IsRobotNpc() then
      GameFacade.Instance:sendNotification(PlayerEvent.DeathStatusChange, ncreature)
    end
    self:_Revive(ncreature, oldValue)
  elseif value == ProtoCommon_pb.ECREATURESTATUS_PHOTO and ncreature:GetCreatureType() ~= Creature_Type.Me then
  elseif value == ProtoCommon_pb.ECREATURESTATUS_FAKEDEAD then
    self:_FakeDie(ncreature)
  elseif value == ProtoCommon_pb.ECREATURESTATUS_INRELIVE and ncreature:GetCreatureType() == Creature_Type.Player then
    GameFacade.Instance:sendNotification(PlayerEvent.DeathStatusChange, ncreature)
  end
end

function LogicManager_Creature_Userdata:_FakeDie(ncreature)
  FunctionSystem.InterruptCreature(ncreature)
  ncreature:Server_PlayActionCmd(Asset_Role.ActionName.Die, 1, false, true)
end

function LogicManager_Creature_Userdata:_Die(ncreature, isSet)
  ncreature:Server_DieCmd(isSet)
  NSceneNpcProxy.Instance:CheckNpcType(ncreature.data.id)
end

function LogicManager_Creature_Userdata:_Revive(ncreature, oldValue)
  ncreature:Server_ReviveCmd()
end

function LogicManager_Creature_Userdata:SetNormalSkill(ncreature, userDataID, oldValue, newValue)
  local needUpdate = newValue ~= ncreature.data.normalAtkID
  ncreature.data.normalAtkID = newValue
  if ncreature:GetCreatureType() == Creature_Type.Me and needUpdate then
    GameFacade.Instance:sendNotification(SkillEvent.SkillUpdate, ncreature)
  end
end

local UpdateHandInHand = function(ncreature, handId, twinsActId)
  if handId and handId ~= 0 then
    if twinsActId and twinsActId ~= 0 then
      ncreature:Server_SetDoubleAction(handId, true)
    else
      ncreature:Server_SetHandInHand(handId, true)
    end
  else
    ncreature:Server_SetHandInHand(0, false)
    ncreature:Server_SetDoubleAction(0, false)
  end
end

function LogicManager_Creature_Userdata:UpdateHandId(ncreature, userDataID, oldValue, newValue)
  if newValue then
    local userDatas = ncreature.data.userdata
    local twinsActId = userDatas:Get(UDEnum.TWINS_ACTIONID)
    UpdateHandInHand(ncreature, newValue, twinsActId)
  end
end

function LogicManager_Creature_Userdata:UpdateTwinsActionId(ncreature, userDataID, oldValue, newValue)
  if newValue then
    ncreature:Server_SetTwinsActionId(newValue, oldValue)
    local userDatas = ncreature.data.userdata
    local handMasterId = userDatas:Get(UDEnum.HANDID)
    UpdateHandInHand(ncreature, handMasterId, newValue)
  end
end

function LogicManager_Creature_Userdata:UpdateCooklv(ncreature, userDataID, oldValue, newValue)
  if oldValue < newValue then
  end
end

function LogicManager_Creature_Userdata:UpdateBossType(ncreature, userDataID, oldValue, newValue)
  if newValue then
    ncreature.data:SetBossType(newValue)
  end
end

function LogicManager_Creature_Userdata:UpdateRace(ncreature, userDataID, oldValue, newValue)
  if newValue then
    ncreature.data.race = newValue
  end
end

function LogicManager_Creature_Userdata:UpdateShape(ncreature, userDataID, oldValue, newValue)
  if newValue then
    ncreature.data.shape = CreatureData.ShapeIndex[newValue] or ncreature.data.shape
  end
end

function LogicManager_Creature_Userdata:SetXDir(ncreature, userDataID, oldValue, newValue)
  if newValue and oldValue ~= newValue then
    ncreature.logicTransform:SetAngleX(newValue / 1000)
  end
end

function LogicManager_Creature_Userdata:SetMountForm(ncreature, userDataID, oldValue, newValue)
  if oldValue ~= newValue then
    ncreature:Logic_SetAssetRoleMountForm(newValue)
    return true
  end
end

function LogicManager_Creature_Userdata:RefreshShieldHp(ncreature, userDataID, oldValue, newValue)
  local userdata = ncreature.data.userdata
  local hp = userdata:Get(UDEnum.SHIELD_HP)
  local maxhp = userdata:Get(UDEnum.SHIELD_MAXHP)
  local sceneUI = ncreature:GetSceneUI()
  if sceneUI then
    sceneUI.roleBottomUI:SetShieldHp(hp, maxhp)
  end
end

function LogicManager_Creature_Userdata:RefreshResistance(ncreature, userDataID, oldValue, newValue)
  ncreature.data:UpdateResistanceValue()
  local sceneUI = ncreature:GetSceneUI()
  if sceneUI then
    sceneUI.roleBottomUI:SetResistance(ncreature)
  end
end

function LogicManager_Creature_Userdata:RefreshAttributeChange(ncreature, userDataID, oldValue, newValue)
  ncreature.data:UpdateAttributeValue()
  EventManager.Me():PassEvent(CreatureEvent.NatureResistanceChange, ncreature)
end

function LogicManager_Creature_Userdata:RefreshBalance(ncreature, userDataID, oldValue, newValue)
  local BalanceConfig = ncreature.data:GetBalanceConfig()
  if not BalanceConfig then
    return
  end
  local ShakeScreenConfig = BalanceConfig.shakeScreen_breakdown
  ncreature.data:UpdateBalanceValue()
  local sceneUI = ncreature:GetSceneUI()
  if sceneUI then
    sceneUI.roleBottomUI:SetBalance(ncreature)
  end
  local value, speed = ncreature.data:GetBalanceValue()
  ncreature.data:SetInBreak(newValue >= BalanceConfig.MaxValue * 1000)
  if newValue >= BalanceConfig.MaxValue * 1000 or speed < 0 and 0 < newValue then
    ncreature:Logic_Breakdown(BalanceConfig.MaxValue / BalanceConfig.DecSpd)
    local range = ShakeScreenConfig.amplitude / 100
    local duration = ShakeScreenConfig.msec / 1000
    local curve = ShakeScreenConfig.shaketype
    CameraAdditiveEffectManager.Me():StartShake(range, duration, curve)
  elseif newValue <= 0 then
    ncreature:Logic_BreakdownEnd()
  end
end

function LogicManager_Creature_Userdata:RefreshNormalShield(ncreature, userDataID, oldValue, newValue)
  local userdata = ncreature.data.userdata
  local shield = userdata:Get(UDEnum.SHIELD)
  local maxhp = ncreature.data.props:GetPropByName("MaxHp"):GetValue()
  local sceneUI = ncreature:GetSceneUI()
  if sceneUI then
    sceneUI.roleBottomUI:SetNormalShield(newValue, maxhp)
  end
end

function LogicManager_Creature_Userdata:UpdatePlayerRider_Up(ncreature, userDataID, oldValue, newValue)
  redlog("UpdatePlayerRider_Up", oldValue, newValue)
  self:SetChangeDressDirty(ncreature, userDataID, oldValue, newValue)
  ncreature:UpdatePlayerRider_Up(newValue)
end

function LogicManager_Creature_Userdata:UpdatePlayerRider_Down(ncreature, userDataID, oldValue, newValue)
  redlog("UpdatePlayerRider_Down", oldValue, newValue)
  ncreature.data:SetDownID(newValue)
  self:SetChangeDressDirty(ncreature, userDataID, oldValue, newValue)
  ncreature:UpdatePlayerRider_Down(false)
end

function LogicManager_Creature_Userdata:UpdatePlayerRider_DownRide(ncreature, userDataID, oldValue, newValue)
  redlog("UpdatePlayerRider_DownRide", oldValue, newValue)
  ncreature.data:SetDownID(newValue)
  self:SetChangeDressDirty(ncreature, userDataID, oldValue, newValue)
  ncreature:UpdatePlayerRider_Down(true)
end

function LogicManager_Creature_Userdata:UpdatePvpCamp(ncreature, userDataID, oldValue, newValue)
  if oldValue ~= newValue then
    local sceneUI = ncreature:GetSceneUI()
    if sceneUI then
      sceneUI.roleBottomUI:SetPvpCamp()
    end
    GameFacade.Instance:sendNotification(PVPEvent.PVP_CampChange, ncreature)
  end
end

function LogicManager_Creature_Userdata:UpdateRoleRide(ncreature, userDataID, oldValue, newValue)
  ncreature:UpdateRoleRide()
end
