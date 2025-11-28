autoImport("ServiceScenePetAutoProxy")
ServiceScenePetProxy = class("ServiceScenePetProxy", ServiceScenePetAutoProxy)
ServiceScenePetProxy.Instance = nil
ServiceScenePetProxy.NAME = "ServiceScenePetProxy"

function ServiceScenePetProxy:ctor(proxyName)
  if ServiceScenePetProxy.Instance == nil then
    self.proxyName = proxyName or ServiceScenePetProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceScenePetProxy.Instance = self
  end
end

function ServiceScenePetProxy:CallFireCatPetCmd(catid)
  ServiceScenePetProxy.super.CallFireCatPetCmd(self, catid)
end

function ServiceScenePetProxy:CallCatchPetGiftPetCmd(npcguid)
  ServiceScenePetProxy.super.CallCatchPetGiftPetCmd(self, npcguid)
end

function ServiceScenePetProxy:CallCatchPetPetCmd(npcguid, isstop)
  ServiceScenePetProxy.super.CallCatchPetPetCmd(self, npcguid, isstop)
end

function ServiceScenePetProxy:CallQueryPetAdventureListPetCmd()
  if not PetAdventureProxy.Instance.recvQuestComplete then
    return
  end
  ServiceScenePetProxy.super.CallQueryPetAdventureListPetCmd(self)
end

function ServiceScenePetProxy:CallQueryBattlePetCmd()
  ServiceScenePetProxy.super.CallQueryBattlePetCmd(self)
end

function ServiceScenePetProxy:CallStartAdventurePetCmd(id, petids, specid, useticket)
  ServiceScenePetProxy.super.CallStartAdventurePetCmd(self, id, petids, specid, useticket)
end

function ServiceScenePetProxy:CallGetAdventureRewardPetCmd(id)
  ServiceScenePetProxy.super.CallGetAdventureRewardPetCmd(self, id)
end

function ServiceScenePetProxy:RecvPetAdventureResultNtfPetCmd(data)
  PetAdventureProxy.Instance:HandleQuestResultData(data.item, data.times)
  self:Notify(ServiceEvent.ScenePetPetAdventureResultNtfPetCmd, data)
end

function ServiceScenePetProxy:RecvQueryPetAdventureListPetCmd(data)
  PetAdventureProxy.Instance:SetQuestData(data.items, data.times, data.isend)
  self:Notify(ServiceEvent.ScenePetQueryPetAdventureListPetCmd, data)
end

function ServiceScenePetProxy:RecvCatchValuePetCmd(data)
  FunctionPet.Me():CatchValueChange(data.npcguid, data.value, data.from_npcid)
  self:Notify(ServiceEvent.ScenePetCatchValuePetCmd, data)
end

function ServiceScenePetProxy:RecvCatchResultPetCmd(data)
  FunctionPet.Me():CatchResult(data.npcguid, data.success)
  self:Notify(ServiceEvent.ScenePetCatchResultPetCmd, data)
end

function ServiceScenePetProxy:RecvPetInfoPetCmd(data)
  PetProxy.Instance:Server_UpdateMyPetInfos(data.petinfo)
  self:Notify(ServiceEvent.ScenePetPetInfoPetCmd, data)
end

function ServiceScenePetProxy:RecvPetInfoUpdatePetCmd(data)
  PetProxy.Instance:Server_PetInfoUpdate(data.petid, data.datas)
  self:Notify(ServiceEvent.ScenePetPetInfoUpdatePetCmd, data)
end

function ServiceScenePetProxy:CallEggHatchPetCmd(name, guid)
  ServiceScenePetProxy.super.CallEggHatchPetCmd(self, name, guid)
end

function ServiceScenePetProxy:RecvPetOffPetCmd(data)
  PetProxy.Instance:Server_RemovePetInfoData(data.petid)
  self:Notify(ServiceEvent.ScenePetPetOffPetCmd, data)
end

function ServiceScenePetProxy:RecvEquipUpdatePetCmd(data)
  PetProxy.Instance:Server_UpdatePetEquip(data.petid, data.update, data.del)
  self:Notify(ServiceEvent.ScenePetEquipUpdatePetCmd, data)
end

function ServiceScenePetProxy:CallGiveGiftPetCmd(petid, itemguid)
  ServiceScenePetProxy.super.CallGiveGiftPetCmd(self, petid, itemguid)
end

function ServiceScenePetProxy:RecvGiveGiftPetCmd(data)
  self:Notify(ServiceEvent.ScenePetGiveGiftPetCmd, data)
end

function ServiceScenePetProxy:CallEquipOperPetCmd(oper, petid, guid)
  ServiceScenePetProxy.super.CallEquipOperPetCmd(self, oper, petid, guid)
end

function ServiceScenePetProxy:RecvUnlockNtfPetCmd(data)
  PetProxy.Instance:Server_UpdateUnlockInfo(data.petid, data.equipids, data.bodys)
  self:Notify(ServiceEvent.ScenePetUnlockNtfPetCmd, data)
end

function ServiceScenePetProxy:CallEggRestorePetCmd(petid)
  ServiceScenePetProxy.super.CallEggRestorePetCmd(self, petid)
end

function ServiceScenePetProxy:CallGetGiftPetCmd(petid)
  ServiceScenePetProxy.super.CallGetGiftPetCmd(self, petid)
end

function ServiceScenePetProxy:CallResetSkillPetCmd(id)
  ServiceScenePetProxy.super.CallResetSkillPetCmd(self, id)
end

function ServiceScenePetProxy:CallQueryGotItemPetCmd(items)
  ServiceScenePetProxy.super.CallGetGiftPetCmd(self, petid)
end

function ServiceScenePetProxy:RecvQueryGotItemPetCmd(data)
  self:Notify(ServiceEvent.ScenePetQueryGotItemPetCmd, data)
end

function ServiceScenePetProxy:RecvQueryPetWorkDataPetCmd(data)
  helplog("Recv-->RecvQueryPetWorkDataPetCmd")
  PetWorkSpaceProxy.Instance:SetPetWorkData(data.datas)
  PetWorkSpaceProxy.Instance:SetExtra(data)
  self:Notify(ServiceEvent.ScenePetQueryPetWorkDataPetCmd, data)
end

function ServiceScenePetProxy:RecvWorkSpaceDataUpdatePetCmd(data)
  PetWorkSpaceProxy.Instance:RecvWorkSpaceDataUpdatePetCmd(data)
  self:Notify(ServiceEvent.ScenePetWorkSpaceDataUpdatePetCmd, data)
end

function ServiceScenePetProxy:RecvWorkSpaceMaxCountUpdatePetCmd(data)
  PetWorkSpaceProxy.Instance:SetMaxWorkSpace(data.max_count)
  self:Notify(ServiceEvent.ScenePetWorkSpaceMaxCountUpdatePetCmd, data)
end

function ServiceScenePetProxy:RecvWorkSpaceUpdate(data)
  helplog("Recv-->RecvWorkSpaceUpdate")
  PetWorkSpaceProxy.Instance:SetPetWorkData(data.updates)
  self:Notify(ServiceEvent.ScenePetWorkSpaceUpdate, data)
end

function ServiceScenePetProxy:RecvPetExtraUpdatePetCmd(data)
  PetWorkSpaceProxy.Instance:SetExchangeMap(data.updates)
  self:Notify(ServiceEvent.ScenePetPetExtraUpdatePetCmd, data)
end

function ServiceScenePetProxy:RecvPetEquipListCmd(data)
  PetComposeProxy.Instance:InitPetEquipList(data.unlockinfo)
  self:Notify(ServiceEvent.ScenePetPetEquipListCmd, data)
end

function ServiceScenePetProxy:RecvUpdatePetEquipListCmd(data)
  PetComposeProxy.Instance:UpdatePetEquipList(data)
  self:Notify(ServiceEvent.ScenePetUpdatePetEquipListCmd, data)
end

function ServiceScenePetProxy:RecvUpdateWearPetCmd(data)
  self:Notify(ServiceEvent.ScenePetUpdateWearPetCmd, data)
end

function ServiceScenePetProxy:RecvCatSkillOptionPetCmd(data)
  MercenaryCatProxy.Instance:HandleCatSkillOptionPetCmd(data.selectskill)
  self:Notify(ServiceEvent.ScenePetCatSkillOptionPetCmd, data)
end

function ServiceScenePetProxy:RecvCatEquipInfoPetCmd(data)
  MercenaryCatProxy.Instance:HandleCatEquipInfo(data)
  self:Notify(ServiceEvent.ScenePetCatEquipInfoPetCmd, data)
end

function ServiceScenePetProxy:RecvBoKiStateQueryPetCmd(data)
  BokiProxy.Instance:HandleBokiQuery(data.state)
  self:Notify(ServiceEvent.ScenePetBoKiStateQueryPetCmd, data)
end

function ServiceScenePetProxy:RecvBoKiDataUpdatePetCmd(data)
  BokiProxy.Instance:HandleBokiDataUpdate(data.datas)
  self:Notify(ServiceEvent.ScenePetBoKiDataUpdatePetCmd, data)
end

function ServiceScenePetProxy:RecvBoKiEquipUpdatePetCmd(data)
  BokiProxy.Instance:HandleEquipUpdate(data.equips)
  self:Notify(ServiceEvent.ScenePetBoKiEquipUpdatePetCmd, data)
end

function ServiceScenePetProxy:RecvBoKiSkillUpdatePetCmd(data)
  BokiProxy.Instance:HandleSkillUpdate(data.skills)
  self:Notify(ServiceEvent.ScenePetBoKiSkillUpdatePetCmd, data)
end

function ServiceScenePetProxy:RecvBoKiSkillInUseUpdatePetCmd(data)
  BokiProxy.Instance:HandleSkillInUseUpdate(data.skills)
  self:Notify(ServiceEvent.ScenePetBoKiSkillInUseUpdatePetCmd, data)
end

function ServiceScenePetProxy:RecvSevenRoyalsFollowNpc(data)
  redlog("ServiceScenePetProxy:RecvSevenRoyalsFollowNpc")
  FollowNpcAIManager.Me():SetFollowNpc(data.npcids)
  self:Notify(ServiceEvent.ScenePetSevenRoyalsFollowNpc, data)
end
