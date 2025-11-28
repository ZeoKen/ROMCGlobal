autoImport("LogicManager_Creature_Userdata")
LogicManager_Player_Userdata = class("LogicManager_Player_Userdata", LogicManager_Creature_Userdata)
local PVPTeam = RoleDefines.PVPTeam
local bodyUserdataID, headUserdataID, mountUserdataID = 0, 0, 0

function LogicManager_Player_Userdata:ctor()
  LogicManager_Player_Userdata.super.ctor(self)
  bodyUserdataID = ProtoCommon_pb.EUSERDATATYPE_BODY
  headUserdataID = ProtoCommon_pb.EUSERDATATYPE_HEAD
  mountUserdataID = ProtoCommon_pb.EUSERDATATYPE_MOUNT
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_MUSIC_DEMAND, self.UpdateMusicDJ)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_PVP_COLOR, self.SetPvpColor)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_PEAK_EFFECT, self.UpdatePeakEffect)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_DRESSUP, self.UpdateOnStageHiding)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_PROFESSION, self.SetProfession)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_CHAIR, self.UpdateChair)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_TRAIN, self.UpdateTrain)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_PET_PARTNER, self.UpdatePartner)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_REFINE_HEAD, self.UpdateRefineHead)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_REFINE_FACE, self.UpdateRefineFace)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_REFINE_MOUTH, self.UpdateRefineMouth)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_REFINE_BACK, self.UpdateRefineBack)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_REFINE_TAIL, self.UpdateRefineTail)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_RIDING_CHARID, self.UpdateMultiMount)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_RIDING_POS, self.UpdateMultiMount)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_RIDING_NPC, self.UpdateMultiMountNpc)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_TWELVEPVP_CAMP, self.UpdateTwelvePvpCamp)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_HIDE_NAME, self.UpdateAnonymous)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_EXCELLECT, self.UpdateExcellent)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_BLACK_MUCK, self.UpdateBlackMuck)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_JOBLEVEL, self.UpdateJobLevel)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_JOBEXP, self.UpdateJobExpLevel)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_PROFESSION, self.UpdateProfession)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_MUSIC_DEMAND, self.UpdateMusicDJ)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_PVP_COLOR, self.UpdatePvpColor)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_PEAK_EFFECT, self.UpdatePeakEffect)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_DRESSUP, self.UpdateOnStageHiding)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_CHAIR, self.UpdateChair)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_TRAIN, self.UpdateTrain)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_SEX, self.UpdateSex)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_PET_PARTNER, self.UpdatePartner)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_REFINE_HEAD, self.UpdateRefineHead)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_REFINE_FACE, self.UpdateRefineFace)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_REFINE_MOUTH, self.UpdateRefineMouth)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_REFINE_BACK, self.UpdateRefineBack)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_REFINE_TAIL, self.UpdateRefineTail)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_BACKGROUND, self.UpdateBackground)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_RIDING_CHARID, self.UpdateMultiMount)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_RIDING_POS, self.UpdateMultiMount)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_MOUNT_FASHION, self.UpdateMountFashion)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_PRESTIGE_LEVEL, self.UpdatePrestigeLevel)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_RIDING_NPC, self.UpdateMultiMountNpc)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_TWELVEPVP_CAMP, self.UpdateTwelvePvpCamp)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_HIDE_NAME, self.UpdateAnonymous)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_EXCELLECT, self.UpdateExcellent)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_BLACK_MUCK, self.UpdateBlackMuck)
  self:AddDirtyCall(ProtoCommon_pb.EUSERDATATYPE_MOUNT, self.UpdateMount)
  self:AddDirtyCall(ProtoCommon_pb.EUSERDATATYPE_RIDING_NPC, self.UpdateMultiMountNpc)
end

function LogicManager_Player_Userdata:SetProfession(ncreature, userDataID, oldValue, newValue)
  ncreature:Logic_PartnerVisible()
  ncreature:UpdateSkillOverAction()
end

function LogicManager_Player_Userdata:UpdateRoleLevel(ncreature, userDataID, oldValue, newValue)
  LogicManager_Player_Userdata.super.UpdateRoleLevel(self, ncreature, userDataID, oldValue, newValue)
end

function LogicManager_Player_Userdata:UpdateJobLevel(ncreature, userDataID, oldValue, newValue)
  local occ = ncreature.data:GetCurOcc()
  if occ then
    occ:SetLevel(newValue)
  end
  GameFacade.Instance:sendNotification(SceneUserEvent.LevelUp, ncreature, SceneUserEvent.JobLevelUp)
end

function LogicManager_Player_Userdata:UpdateJobExpLevel(ncreature, userDataID, oldValue, newValue)
  local occ = ncreature.data:GetCurOcc()
  if occ then
    occ:SetExp(newValue)
  end
end

function LogicManager_Player_Userdata:SetChangeDressDirty(ncreature, userDataID, oldValue, newValue)
  self.changeDressDirty = true
  if userDataID == bodyUserdataID then
    ncreature:HandlerAssetRoleSuffixMap()
  end
  if userDataID == headUserdataID or userDataID == mountUserdataID then
    NSceneUserProxy.Instance:CheckUpdataUserData(oldValue, newValue)
  end
end

function LogicManager_Player_Userdata:UpdateProfession(ncreature, userDataID, oldValue, newValue)
  ncreature:UpdateProfession()
  ncreature:Logic_PartnerVisible()
  EventManager.Me():PassEvent(SceneUserEvent.ChangeProfession, ncreature)
  if ncreature == Game.Myself:GetLockTarget() then
    EventManager.Me():PassEvent(MyselfEvent.SelectTargetClassChange, ncreature)
  end
end

function LogicManager_Player_Userdata:UpdateMusicDJ(ncreature, userDataID, oldValue, newValue)
  if newValue == 1 then
    FunctionMusicBox.Me():AddDJPlayer(ncreature)
  elseif newValue == 0 then
    FunctionMusicBox.Me():RemoveDJPlayer(ncreature)
  end
end

function LogicManager_Player_Userdata:SetPvpColor(ncreature, userDataID, oldValue, newValue)
  ncreature:PlayTeamCircle(newValue)
end

function LogicManager_Player_Userdata:UpdatePvpColor(ncreature, userDataID, oldValue, newValue)
  ncreature:PlayTeamCircle(newValue)
end

function LogicManager_Player_Userdata:UpdatePeakEffect(ncreature, userDataID, oldValue, newValue)
  if newValue == 1 then
    ncreature:PlayPeakEffect()
  elseif newValue == 0 then
    ncreature:RemovePeakEffect()
  end
end

function LogicManager_Player_Userdata:UpdateOnStageHiding(ncreature, userDataID, oldValue, newValue)
  if newValue ~= 0 then
    FunctionStage.Me():AddPlayerOnStage(ncreature.data.id, ncreature, newValue)
  else
    FunctionStage.Me():RemovePlayerOnStage(ncreature.data.id)
  end
  EventManager.Me():PassEvent(CreatureEvent.Hiding_Change, ncreature.data.id)
end

function LogicManager_Player_Userdata:UpdateChair(ncreature, userDataID, oldValue, newValue)
  if newValue == 0 then
    ncreature:Server_GetOffSeat(newValue, true)
  else
    ncreature:Server_GetOnSeat(newValue, true)
  end
end

function LogicManager_Player_Userdata:UpdateTrain(ncreature, userDataID, oldValue, newValue)
  if newValue == 0 then
    ncreature:SetVisible(true, LayerChangeReason.InteractNpc)
    FunctionPlayerUI.Me():UnMaskAllUI(ncreature, PUIVisibleReason.InteractNpc)
  else
    ncreature:SetVisible(false, LayerChangeReason.InteractNpc)
    FunctionPlayerUI.Me():MaskAllUI(ncreature, PUIVisibleReason.InteractNpc)
  end
end

function LogicManager_Player_Userdata:UpdateMount(ncreature, userDataID, oldValue, newValue)
  self:SetChangeDressDirty(ncreature, userDataID, oldValue, newValue)
  ncreature:Logic_PartnerVisible()
end

function LogicManager_Player_Userdata:UpdateSex(ncreature, userDataID, oldValue, newValue)
  GameFacade.Instance:sendNotification(CreatureEvent.Sex_Change, ncreature)
end

function LogicManager_Player_Userdata:UpdatePartner(ncreature, userDataID, oldValue, newValue)
  LogicManager_Player_Userdata.super.UpdatePartner(self, ncreature, userDataID, oldValue, newValue)
  ncreature:Logic_PartnerVisible()
end

function LogicManager_Player_Userdata:UpdateRefineHead(ncreature, userDataID, oldValue, newValue)
  ncreature:UpdateRefinePerformance(Asset_Role.PartIndex.Head, oldValue, newValue)
end

function LogicManager_Player_Userdata:UpdateRefineFace(ncreature, userDataID, oldValue, newValue)
  ncreature:UpdateRefinePerformance(Asset_Role.PartIndex.Face, oldValue, newValue)
end

function LogicManager_Player_Userdata:UpdateRefineMouth(ncreature, userDataID, oldValue, newValue)
  ncreature:UpdateRefinePerformance(Asset_Role.PartIndex.Mouth, oldValue, newValue)
end

function LogicManager_Player_Userdata:UpdateRefineBack(ncreature, userDataID, oldValue, newValue)
  ncreature:UpdateRefinePerformance(Asset_Role.PartIndex.Wing, oldValue, newValue)
end

function LogicManager_Player_Userdata:UpdateRefineTail(ncreature, userDataID, oldValue, newValue)
  ncreature:UpdateRefinePerformance(Asset_Role.PartIndex.Tail, oldValue, newValue)
end

function LogicManager_Player_Userdata:UpdateBackground(ncreature, userDataID, oldValue, newValue)
  GameFacade.Instance:sendNotification(CreatureEvent.Background_Change, ncreature)
end

function LogicManager_Player_Userdata:UpdateMultiMount(ncreature, userDataID, oldValue, newValue)
  redlog("UpdateMultiMount", ncreature.data:GetName(), oldValue, newValue)
  if oldValue or newValue ~= 0 then
    ncreature:UpdateMultiMountStatus()
  end
end

function LogicManager_Player_Userdata:UpdateMountFashion(ncreature, id, oldValue, value, bytes)
  if StringUtil.IsEmpty(bytes) then
    return
  end
  self.changeDressDirty = true
end

function LogicManager_Player_Userdata:UpdatePrestigeLevel()
  GameFacade.Instance:sendNotification(CreatureEvent.PrestigeChange, ncreature)
end

function LogicManager_Player_Userdata:UpdateMultiMountNpc(ncreature, userDataID, oldValue, newValue)
  redlog("UpdateMultiMountNpc", ncreature.data:GetName(), oldValue, newValue)
  if oldValue ~= newValue then
    self:SetChangeDressDirty(ncreature, userDataID, oldValue, newValue)
    ncreature:UpdateMultiMountStatus()
  end
end

function LogicManager_Player_Userdata:UpdateTwelvePvpCamp(ncreature, userDataID, oldValue, newValue)
  if newValue and newValue ~= 0 and Game.MapManager:IsPvPMode_TeamTwelve() then
    ncreature.data:Camp_SetIsInPVP(true)
    ncreature.data:Camp_SetIsInMyTeam(newValue == Game.Myself.data:GetTwelvePVPCamp())
  end
end

function LogicManager_Player_Userdata:UpdateAnonymous(ncreature, id, oldValue, newValue)
  newValue = newValue or 0
  if oldValue and oldValue ~= newValue then
    local sceneUI = ncreature:GetSceneUI()
    if sceneUI then
      sceneUI.roleBottomUI:HandleChangeTitle(ncreature)
      sceneUI.roleBottomUI:HandlerPlayerFactionChange(ncreature)
    end
    ncreature:ReDress()
    GameFacade.Instance:sendNotification(PlayerEvent.AnonymousStateChange, ncreature)
  end
end

function LogicManager_Player_Userdata:UpdateExcellent(ncreature, id, oldValue, newValue)
  oldValue = oldValue or 0
  newValue = newValue or 0
  if oldValue ~= newValue then
    GvgProxy.Instance:RefreshExcellentRewardRedTip()
  end
end

function LogicManager_Player_Userdata:UpdateBlackMuck(ncreature, userDataID, oldValue, newValue)
  local ui = ncreature:GetSceneUI()
  if ui then
    ui.roleBottomUI:UpdateBlackMuck(ncreature)
  end
end
