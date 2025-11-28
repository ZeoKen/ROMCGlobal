LogicManager_Npc_Userdata = class("LogicManager_Creature_Userdata", LogicManager_Creature_Userdata)

function LogicManager_Npc_Userdata:ctor()
  LogicManager_Npc_Userdata.super.ctor(self)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_ALPHA, self.SetAlpha)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_CHAIR, self.UpdateChair)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_BUILD_STATUS, self.SetBuildStatus)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_HEAD_TEXT, self.SetHeadText)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_PROFESSION, self.SetProfession)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_PARTNER_STATE, self.UpdatePartnerState)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_BOX_PUSHLIMIT, self.UpdateObjPushLimit)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_WALKACTION, self.SetWalkAction)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_ALPHA, self.UpdateAlpha)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_HAIR, self.SetChangeDressDirty)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_LEFTHAND, self.SetChangeDressDirty)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_RIGHTHAND, self.SetChangeDressDirty)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_HEAD, self.SetChangeDressDirty)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_BACK, self.SetChangeDressDirty)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_CHAIR, self.UpdateChair)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_BUILD_STATUS, self.UpdateBuildStatus)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_HEAD_TEXT, self.UpdateHeadText)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_NPC_BEHAVIOUR, self.UpdateBehaviour)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_PARTNER_STATE, self.UpdatePartnerState)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_BOX_PUSHLIMIT, self.UpdateObjPushLimit)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_SHOWNAME, self.UpdateShowName)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_WALKACTION, self.SetWalkAction)
end

function LogicManager_Npc_Userdata:SetAlpha(ncreature, userDataID, oldValue, newValue)
  local value = newValue / 1000
  ncreature:Server_SetAlpha(value)
end

function LogicManager_Npc_Userdata:UpdateAlpha(ncreature, userDataID, oldValue, newValue)
  local value = newValue / 1000
  ncreature:Server_SetAlpha(value)
end

function LogicManager_Npc_Userdata:SetChangeDressDirty(ncreature, userDataID, oldValue, newValue)
  self.changeDressDirty = true
  if newValue ~= 0 and ncreature ~= nil and ncreature.data ~= nil then
    ncreature.data:SetUseServerDressData(true)
  end
  if ncreature and ncreature.data and ncreature.data:IsPet() then
    GameFacade.Instance:sendNotification(PetCreatureEvent.PetChangeDress, ncreature)
  end
end

local superCheckDressDirty = LogicManager_Npc_Userdata.super.CheckDressDirty

function LogicManager_Npc_Userdata:CheckDressDirty(ncreature)
  if self.changeDressDirty and not self:CheckHasAnyDressData(ncreature) then
    ncreature.data:SetUseServerDressData(false)
  end
  superCheckDressDirty(self, ncreature)
end

function LogicManager_Npc_Userdata:UpdateChair(ncreature, userDataID, oldValue, newValue)
  if newValue == 0 then
    ncreature:Client_PlayAction(Asset_Role.ActionName.Idle, nil, true)
  else
    ncreature:Client_PlayAction(Asset_Role.ActionName.Sitdown, nil, true)
  end
end

function LogicManager_Npc_Userdata:SetBuildStatus(ncreature, userDataID, oldValue, newValue)
  if newValue then
    BFBuildingProxy.Instance:SwitchBuildingAnimByStatus(ncreature, newValue, nil, true)
  end
end

function LogicManager_Npc_Userdata:UpdateBuildStatus(ncreature, userDataID, oldValue, newValue)
  if newValue then
    BFBuildingProxy.Instance:SwitchBuildingAnimByStatus(ncreature, newValue, oldValue, true)
  end
end

function LogicManager_Npc_Userdata:SetHeadText(ncreature, userDataID, oldValue, newValue, newData)
  if newData and newData ~= "" then
    SceneUIManager.Instance:AddRoleTopFuncWords(ncreature, nil, newData, nil, true)
  end
end

function LogicManager_Npc_Userdata:UpdateHeadText(ncreature, userDataID, oldValue, newValue, newData)
  if newData and newData ~= "" then
    helplog("NPCheadtext信息变更", newData)
    SceneUIManager.Instance:AddRoleTopFuncWords(ncreature, nil, newData, nil, true)
  end
end

function LogicManager_Npc_Userdata:UpdateBehaviour(ncreature, userDataID, oldValue, newValue)
  ncreature.data:SetBehaviourData(newValue)
end

function LogicManager_Npc_Userdata:SetProfession(ncreature, userDataID, oldValue, newValue)
  ncreature:HandlerAssetRoleSuffixMap()
end

function LogicManager_Npc_Userdata:SetStatus(ncreature, userDataID, oldValue, newValue)
  LogicManager_Npc_Userdata.super.SetStatus(self, ncreature, userDataID, oldValue, newValue)
  self:_RefreshBokiStatus(ncreature, newValue)
end

function LogicManager_Npc_Userdata:UpdateStatus(ncreature, userDataID, oldValue, newValue)
  LogicManager_Npc_Userdata.super.UpdateStatus(self, ncreature, userDataID, oldValue, newValue)
  self:_RefreshBokiStatus(ncreature, newValue)
end

function LogicManager_Npc_Userdata:_RefreshBokiStatus(ncreature, value)
  if ncreature.data.staticData and ncreature.data.staticData.Type == NpcData.NpcDetailedType.Boki and (value == ProtoCommon_pb.ECREATURESTATUS_DEAD or value == ProtoCommon_pb.ECREATURESTATUS_LIVE or value == ProtoCommon_pb.ECREATURESTATUS_INRELIVE) then
    GameFacade.Instance:sendNotification(PlayerEvent.DeathStatusChange, ncreature)
  end
end

function LogicManager_Npc_Userdata:UpdatePartnerState(ncreature, userDataID, oldValue, newValue)
  ncreature:SetPartnerState(newValue)
end

function LogicManager_Npc_Userdata:UpdateObjPushLimit(ncreature, userDataID, oldValue, newValue)
  RaidPuzzleManager.Me():ShowObjPushLimit(ncreature, true)
end

function LogicManager_Npc_Userdata:UpdateShowName(ncreature, userDataID, oldValue, newValue)
  local ui = ncreature:GetSceneUI()
  if ui then
    ui.roleBottomUI:isNameFactionVisible(ncreature)
  else
    redlog("not sceneui")
  end
end

function LogicManager_Npc_Userdata:SetWalkAction(ncreature, userDataID, oldValue, newValue)
  if newValue ~= 0 then
    local config = Table_ActionAnime[newValue]
    if config ~= nil then
      ncreature:SetDefaultWalkAnime(config.Name)
    end
  end
end
