ServiceScenePetAutoProxy = class("ServiceScenePetAutoProxy", ServiceProxy)
ServiceScenePetAutoProxy.Instance = nil
ServiceScenePetAutoProxy.NAME = "ServiceScenePetAutoProxy"

function ServiceScenePetAutoProxy:ctor(proxyName)
  if ServiceScenePetAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceScenePetAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceScenePetAutoProxy.Instance = self
  end
end

function ServiceScenePetAutoProxy:Init()
end

function ServiceScenePetAutoProxy:onRegister()
  self:Listen(10, 1, function(data)
    self:RecvPetList(data)
  end)
  self:Listen(10, 2, function(data)
    self:RecvFireCatPetCmd(data)
  end)
  self:Listen(10, 3, function(data)
    self:RecvHireCatPetCmd(data)
  end)
  self:Listen(10, 4, function(data)
    self:RecvEggHatchPetCmd(data)
  end)
  self:Listen(10, 5, function(data)
    self:RecvEggRestorePetCmd(data)
  end)
  self:Listen(10, 6, function(data)
    self:RecvCatchValuePetCmd(data)
  end)
  self:Listen(10, 7, function(data)
    self:RecvCatchResultPetCmd(data)
  end)
  self:Listen(10, 8, function(data)
    self:RecvCatchPetPetCmd(data)
  end)
  self:Listen(10, 12, function(data)
    self:RecvCatchPetGiftPetCmd(data)
  end)
  self:Listen(10, 9, function(data)
    self:RecvPetInfoPetCmd(data)
  end)
  self:Listen(10, 10, function(data)
    self:RecvPetInfoUpdatePetCmd(data)
  end)
  self:Listen(10, 11, function(data)
    self:RecvPetOffPetCmd(data)
  end)
  self:Listen(10, 13, function(data)
    self:RecvGetGiftPetCmd(data)
  end)
  self:Listen(10, 14, function(data)
    self:RecvEquipOperPetCmd(data)
  end)
  self:Listen(10, 15, function(data)
    self:RecvEquipUpdatePetCmd(data)
  end)
  self:Listen(10, 16, function(data)
    self:RecvQueryPetAdventureListPetCmd(data)
  end)
  self:Listen(10, 17, function(data)
    self:RecvPetAdventureResultNtfPetCmd(data)
  end)
  self:Listen(10, 18, function(data)
    self:RecvStartAdventurePetCmd(data)
  end)
  self:Listen(10, 19, function(data)
    self:RecvGetAdventureRewardPetCmd(data)
  end)
  self:Listen(10, 20, function(data)
    self:RecvQueryBattlePetCmd(data)
  end)
  self:Listen(10, 21, function(data)
    self:RecvHandPetPetCmd(data)
  end)
  self:Listen(10, 22, function(data)
    self:RecvGiveGiftPetCmd(data)
  end)
  self:Listen(10, 23, function(data)
    self:RecvUnlockNtfPetCmd(data)
  end)
  self:Listen(10, 24, function(data)
    self:RecvResetSkillPetCmd(data)
  end)
  self:Listen(10, 26, function(data)
    self:RecvChangeNamePetCmd(data)
  end)
  self:Listen(10, 27, function(data)
    self:RecvSwitchSkillPetCmd(data)
  end)
  self:Listen(10, 29, function(data)
    self:RecvStartWorkPetCmd(data)
  end)
  self:Listen(10, 30, function(data)
    self:RecvStopWorkPetCmd(data)
  end)
  self:Listen(10, 32, function(data)
    self:RecvQueryPetWorkDataPetCmd(data)
  end)
  self:Listen(10, 33, function(data)
    self:RecvGetPetWorkRewardPetCmd(data)
  end)
  self:Listen(10, 34, function(data)
    self:RecvWorkSpaceUpdate(data)
  end)
  self:Listen(10, 55, function(data)
    self:RecvWorkSpaceDataUpdatePetCmd(data)
  end)
  self:Listen(10, 35, function(data)
    self:RecvPetExtraUpdatePetCmd(data)
  end)
  self:Listen(10, 36, function(data)
    self:RecvComposePetCmd(data)
  end)
  self:Listen(10, 37, function(data)
    self:RecvPetEquipListCmd(data)
  end)
  self:Listen(10, 38, function(data)
    self:RecvUpdatePetEquipListCmd(data)
  end)
  self:Listen(10, 39, function(data)
    self:RecvChangeWearPetCmd(data)
  end)
  self:Listen(10, 40, function(data)
    self:RecvUpdateWearPetCmd(data)
  end)
  self:Listen(10, 41, function(data)
    self:RecvReplaceCatPetCmd(data)
  end)
  self:Listen(10, 42, function(data)
    self:RecvWorkSpaceMaxCountUpdatePetCmd(data)
  end)
  self:Listen(10, 43, function(data)
    self:RecvCatEquipPetCmd(data)
  end)
  self:Listen(10, 44, function(data)
    self:RecvCatEquipInfoPetCmd(data)
  end)
  self:Listen(10, 45, function(data)
    self:RecvCatSkillOptionPetCmd(data)
  end)
  self:Listen(10, 46, function(data)
    self:RecvBoKiStateQueryPetCmd(data)
  end)
  self:Listen(10, 47, function(data)
    self:RecvBoKiDataUpdatePetCmd(data)
  end)
  self:Listen(10, 48, function(data)
    self:RecvBoKiEquipLevelUpPetCmd(data)
  end)
  self:Listen(10, 49, function(data)
    self:RecvBoKiEquipUpdatePetCmd(data)
  end)
  self:Listen(10, 50, function(data)
    self:RecvBoKiSkillLevelUpPetCmd(data)
  end)
  self:Listen(10, 51, function(data)
    self:RecvBoKiSkillUpdatePetCmd(data)
  end)
  self:Listen(10, 52, function(data)
    self:RecvBoKiSkillInUseUpdatePetCmd(data)
  end)
  self:Listen(10, 53, function(data)
    self:RecvBoKiSkillInUseSetPetCmd(data)
  end)
  self:Listen(10, 54, function(data)
    self:RecvSevenRoyalsFollowNpc(data)
  end)
end

function ServiceScenePetAutoProxy:CallPetList(datas)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.PetList()
    if datas ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.datas == nil then
        msg.datas = {}
      end
      for i = 1, #datas do
        table.insert(msg.datas, datas[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PetList.id
    local msgParam = {}
    if datas ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.datas == nil then
        msgParam.datas = {}
      end
      for i = 1, #datas do
        table.insert(msgParam.datas, datas[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallFireCatPetCmd(catid)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.FireCatPetCmd()
    if catid ~= nil then
      msg.catid = catid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FireCatPetCmd.id
    local msgParam = {}
    if catid ~= nil then
      msgParam.catid = catid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallHireCatPetCmd(catid, etype)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.HireCatPetCmd()
    if catid ~= nil then
      msg.catid = catid
    end
    if etype ~= nil then
      msg.etype = etype
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HireCatPetCmd.id
    local msgParam = {}
    if catid ~= nil then
      msgParam.catid = catid
    end
    if etype ~= nil then
      msgParam.etype = etype
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallEggHatchPetCmd(name, guid)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.EggHatchPetCmd()
    if name ~= nil then
      msg.name = name
    end
    if guid ~= nil then
      msg.guid = guid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EggHatchPetCmd.id
    local msgParam = {}
    if name ~= nil then
      msgParam.name = name
    end
    if guid ~= nil then
      msgParam.guid = guid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallEggRestorePetCmd(petid)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.EggRestorePetCmd()
    if petid ~= nil then
      msg.petid = petid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EggRestorePetCmd.id
    local msgParam = {}
    if petid ~= nil then
      msgParam.petid = petid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallCatchValuePetCmd(npcguid, value, from_npcid)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.CatchValuePetCmd()
    if msg == nil then
      msg = {}
    end
    msg.npcguid = npcguid
    if value ~= nil then
      msg.value = value
    end
    if from_npcid ~= nil then
      msg.from_npcid = from_npcid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CatchValuePetCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.npcguid = npcguid
    if value ~= nil then
      msgParam.value = value
    end
    if from_npcid ~= nil then
      msgParam.from_npcid = from_npcid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallCatchResultPetCmd(success, npcguid)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.CatchResultPetCmd()
    if success ~= nil then
      msg.success = success
    end
    if npcguid ~= nil then
      msg.npcguid = npcguid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CatchResultPetCmd.id
    local msgParam = {}
    if success ~= nil then
      msgParam.success = success
    end
    if npcguid ~= nil then
      msgParam.npcguid = npcguid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallCatchPetPetCmd(npcguid, isstop)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.CatchPetPetCmd()
    if npcguid ~= nil then
      msg.npcguid = npcguid
    end
    if isstop ~= nil then
      msg.isstop = isstop
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CatchPetPetCmd.id
    local msgParam = {}
    if npcguid ~= nil then
      msgParam.npcguid = npcguid
    end
    if isstop ~= nil then
      msgParam.isstop = isstop
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallCatchPetGiftPetCmd(npcguid)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.CatchPetGiftPetCmd()
    if npcguid ~= nil then
      msg.npcguid = npcguid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CatchPetGiftPetCmd.id
    local msgParam = {}
    if npcguid ~= nil then
      msgParam.npcguid = npcguid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallPetInfoPetCmd(petinfo)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.PetInfoPetCmd()
    if petinfo ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.petinfo == nil then
        msg.petinfo = {}
      end
      for i = 1, #petinfo do
        table.insert(msg.petinfo, petinfo[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PetInfoPetCmd.id
    local msgParam = {}
    if petinfo ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.petinfo == nil then
        msgParam.petinfo = {}
      end
      for i = 1, #petinfo do
        table.insert(msgParam.petinfo, petinfo[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallPetInfoUpdatePetCmd(petid, datas)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.PetInfoUpdatePetCmd()
    if msg == nil then
      msg = {}
    end
    msg.petid = petid
    if datas ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.datas == nil then
        msg.datas = {}
      end
      for i = 1, #datas do
        table.insert(msg.datas, datas[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PetInfoUpdatePetCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.petid = petid
    if datas ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.datas == nil then
        msgParam.datas = {}
      end
      for i = 1, #datas do
        table.insert(msgParam.datas, datas[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallPetOffPetCmd(petid)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.PetOffPetCmd()
    if msg == nil then
      msg = {}
    end
    msg.petid = petid
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PetOffPetCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.petid = petid
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallGetGiftPetCmd(petid)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.GetGiftPetCmd()
    if petid ~= nil then
      msg.petid = petid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GetGiftPetCmd.id
    local msgParam = {}
    if petid ~= nil then
      msgParam.petid = petid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallEquipOperPetCmd(oper, petid, guid)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.EquipOperPetCmd()
    if oper ~= nil then
      msg.oper = oper
    end
    if petid ~= nil then
      msg.petid = petid
    end
    if guid ~= nil then
      msg.guid = guid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EquipOperPetCmd.id
    local msgParam = {}
    if oper ~= nil then
      msgParam.oper = oper
    end
    if petid ~= nil then
      msgParam.petid = petid
    end
    if guid ~= nil then
      msgParam.guid = guid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallEquipUpdatePetCmd(petid, update, del)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.EquipUpdatePetCmd()
    if petid ~= nil then
      msg.petid = petid
    end
    if update.base ~= nil and update.base.guid ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.guid = update.base.guid
    end
    if update.base ~= nil and update.base.id ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.id = update.base.id
    end
    if update.base ~= nil and update.base.count ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.count = update.base.count
    end
    if update.base ~= nil and update.base.index ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.index = update.base.index
    end
    if update.base ~= nil and update.base.createtime ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.createtime = update.base.createtime
    end
    if update.base ~= nil and update.base.cd ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.cd = update.base.cd
    end
    if update.base ~= nil and update.base.type ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.type = update.base.type
    end
    if update.base ~= nil and update.base.bind ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.bind = update.base.bind
    end
    if update.base ~= nil and update.base.expire ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.expire = update.base.expire
    end
    if update.base ~= nil and update.base.quality ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.quality = update.base.quality
    end
    if update.base ~= nil and update.base.equipType ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.equipType = update.base.equipType
    end
    if update.base ~= nil and update.base.source ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.source = update.base.source
    end
    if update.base ~= nil and update.base.isnew ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.isnew = update.base.isnew
    end
    if update.base ~= nil and update.base.maxcardslot ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.maxcardslot = update.base.maxcardslot
    end
    if update.base ~= nil and update.base.ishint ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.ishint = update.base.ishint
    end
    if update.base ~= nil and update.base.isactive ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.isactive = update.base.isactive
    end
    if update.base ~= nil and update.base.source_npc ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.source_npc = update.base.source_npc
    end
    if update.base ~= nil and update.base.refinelv ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.refinelv = update.base.refinelv
    end
    if update.base ~= nil and update.base.chargemoney ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.chargemoney = update.base.chargemoney
    end
    if update.base ~= nil and update.base.overtime ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.overtime = update.base.overtime
    end
    if update.base ~= nil and update.base.quota ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.quota = update.base.quota
    end
    if update.base ~= nil and update.base.usedtimes ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.usedtimes = update.base.usedtimes
    end
    if update.base ~= nil and update.base.usedtime ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.usedtime = update.base.usedtime
    end
    if update.base ~= nil and update.base.isfavorite ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.isfavorite = update.base.isfavorite
    end
    if update ~= nil and update.base.mailhint ~= nil then
      if msg.update.base == nil then
        msg.update.base = {}
      end
      if msg.update.base.mailhint == nil then
        msg.update.base.mailhint = {}
      end
      for i = 1, #update.base.mailhint do
        table.insert(msg.update.base.mailhint, update.base.mailhint[i])
      end
    end
    if update.base ~= nil and update.base.subsource ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.subsource = update.base.subsource
    end
    if update.base ~= nil and update.base.randkey ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.randkey = update.base.randkey
    end
    if update.base ~= nil and update.base.sceneinfo ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.sceneinfo = update.base.sceneinfo
    end
    if update.base ~= nil and update.base.local_charge ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.local_charge = update.base.local_charge
    end
    if update.base ~= nil and update.base.charge_deposit_id ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.charge_deposit_id = update.base.charge_deposit_id
    end
    if update.base ~= nil and update.base.issplit ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.issplit = update.base.issplit
    end
    if update.base.tmp ~= nil and update.base.tmp.none ~= nil then
      if msg.update.base == nil then
        msg.update.base = {}
      end
      if msg.update.base.tmp == nil then
        msg.update.base.tmp = {}
      end
      msg.update.base.tmp.none = update.base.tmp.none
    end
    if update.base.tmp ~= nil and update.base.tmp.num_param ~= nil then
      if msg.update.base == nil then
        msg.update.base = {}
      end
      if msg.update.base.tmp == nil then
        msg.update.base.tmp = {}
      end
      msg.update.base.tmp.num_param = update.base.tmp.num_param
    end
    if update.base.tmp ~= nil and update.base.tmp.from_reward ~= nil then
      if msg.update.base == nil then
        msg.update.base = {}
      end
      if msg.update.base.tmp == nil then
        msg.update.base.tmp = {}
      end
      msg.update.base.tmp.from_reward = update.base.tmp.from_reward
    end
    if update.base ~= nil and update.base.mount_fashion_activated ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.mount_fashion_activated = update.base.mount_fashion_activated
    end
    if update.base ~= nil and update.base.no_trade_reason ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.base == nil then
        msg.update.base = {}
      end
      msg.update.base.no_trade_reason = update.base.no_trade_reason
    end
    if update.base.card_info ~= nil and update.base.card_info.lv ~= nil then
      if msg.update.base == nil then
        msg.update.base = {}
      end
      if msg.update.base.card_info == nil then
        msg.update.base.card_info = {}
      end
      msg.update.base.card_info.lv = update.base.card_info.lv
    end
    if update ~= nil and update.equiped ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.update == nil then
        msg.update = {}
      end
      msg.update.equiped = update.equiped
    end
    if update ~= nil and update.battlepoint ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.update == nil then
        msg.update = {}
      end
      msg.update.battlepoint = update.battlepoint
    end
    if update.equip ~= nil and update.equip.strengthlv ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.equip == nil then
        msg.update.equip = {}
      end
      msg.update.equip.strengthlv = update.equip.strengthlv
    end
    if update.equip ~= nil and update.equip.refinelv ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.equip == nil then
        msg.update.equip = {}
      end
      msg.update.equip.refinelv = update.equip.refinelv
    end
    if update.equip ~= nil and update.equip.strengthCost ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.equip == nil then
        msg.update.equip = {}
      end
      msg.update.equip.strengthCost = update.equip.strengthCost
    end
    if update ~= nil and update.equip.refineCompose ~= nil then
      if msg.update.equip == nil then
        msg.update.equip = {}
      end
      if msg.update.equip.refineCompose == nil then
        msg.update.equip.refineCompose = {}
      end
      for i = 1, #update.equip.refineCompose do
        table.insert(msg.update.equip.refineCompose, update.equip.refineCompose[i])
      end
    end
    if update.equip ~= nil and update.equip.cardslot ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.equip == nil then
        msg.update.equip = {}
      end
      msg.update.equip.cardslot = update.equip.cardslot
    end
    if update ~= nil and update.equip.buffid ~= nil then
      if msg.update.equip == nil then
        msg.update.equip = {}
      end
      if msg.update.equip.buffid == nil then
        msg.update.equip.buffid = {}
      end
      for i = 1, #update.equip.buffid do
        table.insert(msg.update.equip.buffid, update.equip.buffid[i])
      end
    end
    if update.equip ~= nil and update.equip.damage ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.equip == nil then
        msg.update.equip = {}
      end
      msg.update.equip.damage = update.equip.damage
    end
    if update.equip ~= nil and update.equip.lv ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.equip == nil then
        msg.update.equip = {}
      end
      msg.update.equip.lv = update.equip.lv
    end
    if update.equip ~= nil and update.equip.color ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.equip == nil then
        msg.update.equip = {}
      end
      msg.update.equip.color = update.equip.color
    end
    if update.equip ~= nil and update.equip.breakstarttime ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.equip == nil then
        msg.update.equip = {}
      end
      msg.update.equip.breakstarttime = update.equip.breakstarttime
    end
    if update.equip ~= nil and update.equip.breakendtime ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.equip == nil then
        msg.update.equip = {}
      end
      msg.update.equip.breakendtime = update.equip.breakendtime
    end
    if update.equip ~= nil and update.equip.strengthlv2 ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.equip == nil then
        msg.update.equip = {}
      end
      msg.update.equip.strengthlv2 = update.equip.strengthlv2
    end
    if update.equip ~= nil and update.equip.quenchper ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.equip == nil then
        msg.update.equip = {}
      end
      msg.update.equip.quenchper = update.equip.quenchper
    end
    if update ~= nil and update.equip.strengthlv2cost ~= nil then
      if msg.update.equip == nil then
        msg.update.equip = {}
      end
      if msg.update.equip.strengthlv2cost == nil then
        msg.update.equip.strengthlv2cost = {}
      end
      for i = 1, #update.equip.strengthlv2cost do
        table.insert(msg.update.equip.strengthlv2cost, update.equip.strengthlv2cost[i])
      end
    end
    if update ~= nil and update.equip.attrs ~= nil then
      if msg.update.equip == nil then
        msg.update.equip = {}
      end
      if msg.update.equip.attrs == nil then
        msg.update.equip.attrs = {}
      end
      for i = 1, #update.equip.attrs do
        table.insert(msg.update.equip.attrs, update.equip.attrs[i])
      end
    end
    if update.equip ~= nil and update.equip.extra_refine_value ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.equip == nil then
        msg.update.equip = {}
      end
      msg.update.equip.extra_refine_value = update.equip.extra_refine_value
    end
    if update ~= nil and update.card ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.card == nil then
        msg.update.card = {}
      end
      for i = 1, #update.card do
        table.insert(msg.update.card, update.card[i])
      end
    end
    if update.enchant ~= nil and update.enchant.type ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.enchant == nil then
        msg.update.enchant = {}
      end
      msg.update.enchant.type = update.enchant.type
    end
    if update ~= nil and update.enchant.attrs ~= nil then
      if msg.update.enchant == nil then
        msg.update.enchant = {}
      end
      if msg.update.enchant.attrs == nil then
        msg.update.enchant.attrs = {}
      end
      for i = 1, #update.enchant.attrs do
        table.insert(msg.update.enchant.attrs, update.enchant.attrs[i])
      end
    end
    if update ~= nil and update.enchant.extras ~= nil then
      if msg.update.enchant == nil then
        msg.update.enchant = {}
      end
      if msg.update.enchant.extras == nil then
        msg.update.enchant.extras = {}
      end
      for i = 1, #update.enchant.extras do
        table.insert(msg.update.enchant.extras, update.enchant.extras[i])
      end
    end
    if update ~= nil and update.enchant.patch ~= nil then
      if msg.update.enchant == nil then
        msg.update.enchant = {}
      end
      if msg.update.enchant.patch == nil then
        msg.update.enchant.patch = {}
      end
      for i = 1, #update.enchant.patch do
        table.insert(msg.update.enchant.patch, update.enchant.patch[i])
      end
    end
    if update.enchant ~= nil and update.enchant.israteup ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.enchant == nil then
        msg.update.enchant = {}
      end
      msg.update.enchant.israteup = update.enchant.israteup
    end
    if update.prenchant ~= nil and update.prenchant.type ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.prenchant == nil then
        msg.update.prenchant = {}
      end
      msg.update.prenchant.type = update.prenchant.type
    end
    if update ~= nil and update.prenchant.attrs ~= nil then
      if msg.update.prenchant == nil then
        msg.update.prenchant = {}
      end
      if msg.update.prenchant.attrs == nil then
        msg.update.prenchant.attrs = {}
      end
      for i = 1, #update.prenchant.attrs do
        table.insert(msg.update.prenchant.attrs, update.prenchant.attrs[i])
      end
    end
    if update ~= nil and update.prenchant.extras ~= nil then
      if msg.update.prenchant == nil then
        msg.update.prenchant = {}
      end
      if msg.update.prenchant.extras == nil then
        msg.update.prenchant.extras = {}
      end
      for i = 1, #update.prenchant.extras do
        table.insert(msg.update.prenchant.extras, update.prenchant.extras[i])
      end
    end
    if update ~= nil and update.prenchant.patch ~= nil then
      if msg.update.prenchant == nil then
        msg.update.prenchant = {}
      end
      if msg.update.prenchant.patch == nil then
        msg.update.prenchant.patch = {}
      end
      for i = 1, #update.prenchant.patch do
        table.insert(msg.update.prenchant.patch, update.prenchant.patch[i])
      end
    end
    if update.prenchant ~= nil and update.prenchant.israteup ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.prenchant == nil then
        msg.update.prenchant = {}
      end
      msg.update.prenchant.israteup = update.prenchant.israteup
    end
    if update.refine ~= nil and update.refine.lastfail ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.refine == nil then
        msg.update.refine = {}
      end
      msg.update.refine.lastfail = update.refine.lastfail
    end
    if update.refine ~= nil and update.refine.repaircount ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.refine == nil then
        msg.update.refine = {}
      end
      msg.update.refine.repaircount = update.refine.repaircount
    end
    if update.refine ~= nil and update.refine.lastfailcount ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.refine == nil then
        msg.update.refine = {}
      end
      msg.update.refine.lastfailcount = update.refine.lastfailcount
    end
    if update.refine ~= nil and update.refine.history_fix_rate ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.refine == nil then
        msg.update.refine = {}
      end
      msg.update.refine.history_fix_rate = update.refine.history_fix_rate
    end
    if update.refine ~= nil and update.refine.cost_count ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.refine == nil then
        msg.update.refine = {}
      end
      msg.update.refine.cost_count = update.refine.cost_count
    end
    if update ~= nil and update.refine.cost_counts ~= nil then
      if msg.update.refine == nil then
        msg.update.refine = {}
      end
      if msg.update.refine.cost_counts == nil then
        msg.update.refine.cost_counts = {}
      end
      for i = 1, #update.refine.cost_counts do
        table.insert(msg.update.refine.cost_counts, update.refine.cost_counts[i])
      end
    end
    if update.egg ~= nil and update.egg.exp ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.exp = update.egg.exp
    end
    if update.egg ~= nil and update.egg.friendexp ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.friendexp = update.egg.friendexp
    end
    if update.egg ~= nil and update.egg.rewardexp ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.rewardexp = update.egg.rewardexp
    end
    if update.egg ~= nil and update.egg.id ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.id = update.egg.id
    end
    if update.egg ~= nil and update.egg.lv ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.lv = update.egg.lv
    end
    if update.egg ~= nil and update.egg.friendlv ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.friendlv = update.egg.friendlv
    end
    if update.egg ~= nil and update.egg.body ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.body = update.egg.body
    end
    if update.egg ~= nil and update.egg.relivetime ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.relivetime = update.egg.relivetime
    end
    if update.egg ~= nil and update.egg.hp ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.hp = update.egg.hp
    end
    if update.egg ~= nil and update.egg.restoretime ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.restoretime = update.egg.restoretime
    end
    if update.egg ~= nil and update.egg.time_happly ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.time_happly = update.egg.time_happly
    end
    if update.egg ~= nil and update.egg.time_excite ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.time_excite = update.egg.time_excite
    end
    if update.egg ~= nil and update.egg.time_happiness ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.time_happiness = update.egg.time_happiness
    end
    if update.egg ~= nil and update.egg.time_happly_gift ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.time_happly_gift = update.egg.time_happly_gift
    end
    if update.egg ~= nil and update.egg.time_excite_gift ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.time_excite_gift = update.egg.time_excite_gift
    end
    if update.egg ~= nil and update.egg.time_happiness_gift ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.time_happiness_gift = update.egg.time_happiness_gift
    end
    if update.egg ~= nil and update.egg.touch_tick ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.touch_tick = update.egg.touch_tick
    end
    if update.egg ~= nil and update.egg.feed_tick ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.feed_tick = update.egg.feed_tick
    end
    if update.egg ~= nil and update.egg.name ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.name = update.egg.name
    end
    if update.egg ~= nil and update.egg.var ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.var = update.egg.var
    end
    if update ~= nil and update.egg.skillids ~= nil then
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      if msg.update.egg.skillids == nil then
        msg.update.egg.skillids = {}
      end
      for i = 1, #update.egg.skillids do
        table.insert(msg.update.egg.skillids, update.egg.skillids[i])
      end
    end
    if update ~= nil and update.egg.equips ~= nil then
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      if msg.update.egg.equips == nil then
        msg.update.egg.equips = {}
      end
      for i = 1, #update.egg.equips do
        table.insert(msg.update.egg.equips, update.egg.equips[i])
      end
    end
    if update.egg ~= nil and update.egg.buff ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.buff = update.egg.buff
    end
    if update ~= nil and update.egg.unlock_equip ~= nil then
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      if msg.update.egg.unlock_equip == nil then
        msg.update.egg.unlock_equip = {}
      end
      for i = 1, #update.egg.unlock_equip do
        table.insert(msg.update.egg.unlock_equip, update.egg.unlock_equip[i])
      end
    end
    if update ~= nil and update.egg.unlock_body ~= nil then
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      if msg.update.egg.unlock_body == nil then
        msg.update.egg.unlock_body = {}
      end
      for i = 1, #update.egg.unlock_body do
        table.insert(msg.update.egg.unlock_body, update.egg.unlock_body[i])
      end
    end
    if update.egg ~= nil and update.egg.version ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.version = update.egg.version
    end
    if update.egg ~= nil and update.egg.skilloff ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.skilloff = update.egg.skilloff
    end
    if update.egg ~= nil and update.egg.exchange_count ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.exchange_count = update.egg.exchange_count
    end
    if update.egg ~= nil and update.egg.guid ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.guid = update.egg.guid
    end
    if update ~= nil and update.egg.defaultwears ~= nil then
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      if msg.update.egg.defaultwears == nil then
        msg.update.egg.defaultwears = {}
      end
      for i = 1, #update.egg.defaultwears do
        table.insert(msg.update.egg.defaultwears, update.egg.defaultwears[i])
      end
    end
    if update ~= nil and update.egg.wears ~= nil then
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      if msg.update.egg.wears == nil then
        msg.update.egg.wears = {}
      end
      for i = 1, #update.egg.wears do
        table.insert(msg.update.egg.wears, update.egg.wears[i])
      end
    end
    if update.egg ~= nil and update.egg.cdtime ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.egg == nil then
        msg.update.egg = {}
      end
      msg.update.egg.cdtime = update.egg.cdtime
    end
    if update.letter ~= nil and update.letter.sendUserName ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.letter == nil then
        msg.update.letter = {}
      end
      msg.update.letter.sendUserName = update.letter.sendUserName
    end
    if update.letter ~= nil and update.letter.bg ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.letter == nil then
        msg.update.letter = {}
      end
      msg.update.letter.bg = update.letter.bg
    end
    if update.letter ~= nil and update.letter.configID ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.letter == nil then
        msg.update.letter = {}
      end
      msg.update.letter.configID = update.letter.configID
    end
    if update.letter ~= nil and update.letter.content ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.letter == nil then
        msg.update.letter = {}
      end
      msg.update.letter.content = update.letter.content
    end
    if update.letter ~= nil and update.letter.content2 ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.letter == nil then
        msg.update.letter = {}
      end
      msg.update.letter.content2 = update.letter.content2
    end
    if update.code ~= nil and update.code.code ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.code == nil then
        msg.update.code = {}
      end
      msg.update.code.code = update.code.code
    end
    if update.code ~= nil and update.code.used ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.code == nil then
        msg.update.code = {}
      end
      msg.update.code.used = update.code.used
    end
    if update.wedding ~= nil and update.wedding.id ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.wedding == nil then
        msg.update.wedding = {}
      end
      msg.update.wedding.id = update.wedding.id
    end
    if update.wedding ~= nil and update.wedding.zoneid ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.wedding == nil then
        msg.update.wedding = {}
      end
      msg.update.wedding.zoneid = update.wedding.zoneid
    end
    if update.wedding ~= nil and update.wedding.charid1 ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.wedding == nil then
        msg.update.wedding = {}
      end
      msg.update.wedding.charid1 = update.wedding.charid1
    end
    if update.wedding ~= nil and update.wedding.charid2 ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.wedding == nil then
        msg.update.wedding = {}
      end
      msg.update.wedding.charid2 = update.wedding.charid2
    end
    if update.wedding ~= nil and update.wedding.weddingtime ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.wedding == nil then
        msg.update.wedding = {}
      end
      msg.update.wedding.weddingtime = update.wedding.weddingtime
    end
    if update.wedding ~= nil and update.wedding.photoidx ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.wedding == nil then
        msg.update.wedding = {}
      end
      msg.update.wedding.photoidx = update.wedding.photoidx
    end
    if update.wedding ~= nil and update.wedding.phototime ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.wedding == nil then
        msg.update.wedding = {}
      end
      msg.update.wedding.phototime = update.wedding.phototime
    end
    if update.wedding ~= nil and update.wedding.myname ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.wedding == nil then
        msg.update.wedding = {}
      end
      msg.update.wedding.myname = update.wedding.myname
    end
    if update.wedding ~= nil and update.wedding.partnername ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.wedding == nil then
        msg.update.wedding = {}
      end
      msg.update.wedding.partnername = update.wedding.partnername
    end
    if update.wedding ~= nil and update.wedding.starttime ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.wedding == nil then
        msg.update.wedding = {}
      end
      msg.update.wedding.starttime = update.wedding.starttime
    end
    if update.wedding ~= nil and update.wedding.endtime ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.wedding == nil then
        msg.update.wedding = {}
      end
      msg.update.wedding.endtime = update.wedding.endtime
    end
    if update.wedding ~= nil and update.wedding.notified ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.wedding == nil then
        msg.update.wedding = {}
      end
      msg.update.wedding.notified = update.wedding.notified
    end
    if update.sender ~= nil and update.sender.charid ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.sender == nil then
        msg.update.sender = {}
      end
      msg.update.sender.charid = update.sender.charid
    end
    if update.sender ~= nil and update.sender.name ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.sender == nil then
        msg.update.sender = {}
      end
      msg.update.sender.name = update.sender.name
    end
    if update.furniture ~= nil and update.furniture.id ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      msg.update.furniture.id = update.furniture.id
    end
    if update.furniture ~= nil and update.furniture.angle ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      msg.update.furniture.angle = update.furniture.angle
    end
    if update.furniture ~= nil and update.furniture.lv ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      msg.update.furniture.lv = update.furniture.lv
    end
    if update.furniture ~= nil and update.furniture.row ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      msg.update.furniture.row = update.furniture.row
    end
    if update.furniture ~= nil and update.furniture.col ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      msg.update.furniture.col = update.furniture.col
    end
    if update.furniture ~= nil and update.furniture.floor ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      msg.update.furniture.floor = update.furniture.floor
    end
    if update.furniture ~= nil and update.furniture.rewardtime ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      msg.update.furniture.rewardtime = update.furniture.rewardtime
    end
    if update.furniture ~= nil and update.furniture.state ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      msg.update.furniture.state = update.furniture.state
    end
    if update.furniture ~= nil and update.furniture.guid ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      msg.update.furniture.guid = update.furniture.guid
    end
    if update.furniture ~= nil and update.furniture.old_guid ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      msg.update.furniture.old_guid = update.furniture.old_guid
    end
    if update.furniture ~= nil and update.furniture.var ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      msg.update.furniture.var = update.furniture.var
    end
    if update ~= nil and update.furniture.seats ~= nil then
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      if msg.update.furniture.seats == nil then
        msg.update.furniture.seats = {}
      end
      for i = 1, #update.furniture.seats do
        table.insert(msg.update.furniture.seats, update.furniture.seats[i])
      end
    end
    if update ~= nil and update.furniture.seatskills ~= nil then
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      if msg.update.furniture.seatskills == nil then
        msg.update.furniture.seatskills = {}
      end
      for i = 1, #update.furniture.seatskills do
        table.insert(msg.update.furniture.seatskills, update.furniture.seatskills[i])
      end
    end
    if update ~= nil and update.furniture.photos ~= nil then
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      if msg.update.furniture.photos == nil then
        msg.update.furniture.photos = {}
      end
      for i = 1, #update.furniture.photos do
        table.insert(msg.update.furniture.photos, update.furniture.photos[i])
      end
    end
    if update.furniture.npc ~= nil and update.furniture.npc.race ~= nil then
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      if msg.update.furniture.npc == nil then
        msg.update.furniture.npc = {}
      end
      msg.update.furniture.npc.race = update.furniture.npc.race
    end
    if update.furniture.npc ~= nil and update.furniture.npc.shape ~= nil then
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      if msg.update.furniture.npc == nil then
        msg.update.furniture.npc = {}
      end
      msg.update.furniture.npc.shape = update.furniture.npc.shape
    end
    if update.furniture.npc ~= nil and update.furniture.npc.nature ~= nil then
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      if msg.update.furniture.npc == nil then
        msg.update.furniture.npc = {}
      end
      msg.update.furniture.npc.nature = update.furniture.npc.nature
    end
    if update.furniture.npc ~= nil and update.furniture.npc.hpreduce ~= nil then
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      if msg.update.furniture.npc == nil then
        msg.update.furniture.npc = {}
      end
      msg.update.furniture.npc.hpreduce = update.furniture.npc.hpreduce
    end
    if update.furniture.npc ~= nil and update.furniture.npc.naturelv ~= nil then
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      if msg.update.furniture.npc == nil then
        msg.update.furniture.npc = {}
      end
      msg.update.furniture.npc.naturelv = update.furniture.npc.naturelv
    end
    if update ~= nil and update.furniture.npc.history_max ~= nil then
      if msg.update.furniture.npc == nil then
        msg.update.furniture.npc = {}
      end
      if msg.update.furniture.npc.history_max == nil then
        msg.update.furniture.npc.history_max = {}
      end
      for i = 1, #update.furniture.npc.history_max do
        table.insert(msg.update.furniture.npc.history_max, update.furniture.npc.history_max[i])
      end
    end
    if update ~= nil and update.furniture.npc.day_max ~= nil then
      if msg.update.furniture.npc == nil then
        msg.update.furniture.npc = {}
      end
      if msg.update.furniture.npc.day_max == nil then
        msg.update.furniture.npc.day_max = {}
      end
      for i = 1, #update.furniture.npc.day_max do
        table.insert(msg.update.furniture.npc.day_max, update.furniture.npc.day_max[i])
      end
    end
    if update.furniture.npc ~= nil and update.furniture.npc.bosstype ~= nil then
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      if msg.update.furniture.npc == nil then
        msg.update.furniture.npc = {}
      end
      msg.update.furniture.npc.bosstype = update.furniture.npc.bosstype
    end
    if update.furniture.npc ~= nil and update.furniture.npc.wood_type ~= nil then
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      if msg.update.furniture.npc == nil then
        msg.update.furniture.npc = {}
      end
      msg.update.furniture.npc.wood_type = update.furniture.npc.wood_type
    end
    if update.furniture.npc ~= nil and update.furniture.npc.monster_id ~= nil then
      if msg.update.furniture == nil then
        msg.update.furniture = {}
      end
      if msg.update.furniture.npc == nil then
        msg.update.furniture.npc = {}
      end
      msg.update.furniture.npc.monster_id = update.furniture.npc.monster_id
    end
    if update.attr ~= nil and update.attr.id ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.attr == nil then
        msg.update.attr = {}
      end
      msg.update.attr.id = update.attr.id
    end
    if update.attr ~= nil and update.attr.lv ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.attr == nil then
        msg.update.attr = {}
      end
      msg.update.attr.lv = update.attr.lv
    end
    if update.attr ~= nil and update.attr.exp ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.attr == nil then
        msg.update.attr = {}
      end
      msg.update.attr.exp = update.attr.exp
    end
    if update.attr ~= nil and update.attr.pos ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.attr == nil then
        msg.update.attr = {}
      end
      msg.update.attr.pos = update.attr.pos
    end
    if update.attr ~= nil and update.attr.time ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.attr == nil then
        msg.update.attr = {}
      end
      msg.update.attr.time = update.attr.time
    end
    if update.attr ~= nil and update.attr.charid ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.attr == nil then
        msg.update.attr = {}
      end
      msg.update.attr.charid = update.attr.charid
    end
    if update.skill ~= nil and update.skill.id ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.skill == nil then
        msg.update.skill = {}
      end
      msg.update.skill.id = update.skill.id
    end
    if update.skill ~= nil and update.skill.pos ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.skill == nil then
        msg.update.skill = {}
      end
      msg.update.skill.pos = update.skill.pos
    end
    if update.skill ~= nil and update.skill.charid ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.skill == nil then
        msg.update.skill = {}
      end
      msg.update.skill.charid = update.skill.charid
    end
    if update.skill ~= nil and update.skill.issame ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.skill == nil then
        msg.update.skill = {}
      end
      msg.update.skill.issame = update.skill.issame
    end
    if update ~= nil and update.skill.buffs ~= nil then
      if msg.update.skill == nil then
        msg.update.skill = {}
      end
      if msg.update.skill.buffs == nil then
        msg.update.skill.buffs = {}
      end
      for i = 1, #update.skill.buffs do
        table.insert(msg.update.skill.buffs, update.skill.buffs[i])
      end
    end
    if update ~= nil and update.skill.carves ~= nil then
      if msg.update.skill == nil then
        msg.update.skill = {}
      end
      if msg.update.skill.carves == nil then
        msg.update.skill.carves = {}
      end
      for i = 1, #update.skill.carves do
        table.insert(msg.update.skill.carves, update.skill.carves[i])
      end
    end
    if update.skill ~= nil and update.skill.isforbid ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.skill == nil then
        msg.update.skill = {}
      end
      msg.update.skill.isforbid = update.skill.isforbid
    end
    if update.skill ~= nil and update.skill.isfull ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.skill == nil then
        msg.update.skill = {}
      end
      msg.update.skill.isfull = update.skill.isfull
    end
    if update.home ~= nil and update.home.ownerid ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.home == nil then
        msg.update.home = {}
      end
      msg.update.home.ownerid = update.home.ownerid
    end
    if update ~= nil and update.artifact.attrs ~= nil then
      if msg.update.artifact == nil then
        msg.update.artifact = {}
      end
      if msg.update.artifact.attrs == nil then
        msg.update.artifact.attrs = {}
      end
      for i = 1, #update.artifact.attrs do
        table.insert(msg.update.artifact.attrs, update.artifact.attrs[i])
      end
    end
    if update ~= nil and update.artifact.preattrs ~= nil then
      if msg.update.artifact == nil then
        msg.update.artifact = {}
      end
      if msg.update.artifact.preattrs == nil then
        msg.update.artifact.preattrs = {}
      end
      for i = 1, #update.artifact.preattrs do
        table.insert(msg.update.artifact.preattrs, update.artifact.preattrs[i])
      end
    end
    if update.artifact ~= nil and update.artifact.art_state ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.artifact == nil then
        msg.update.artifact = {}
      end
      msg.update.artifact.art_state = update.artifact.art_state
    end
    if update ~= nil and update.artifact.art_fragment ~= nil then
      if msg.update.artifact == nil then
        msg.update.artifact = {}
      end
      if msg.update.artifact.art_fragment == nil then
        msg.update.artifact.art_fragment = {}
      end
      for i = 1, #update.artifact.art_fragment do
        table.insert(msg.update.artifact.art_fragment, update.artifact.art_fragment[i])
      end
    end
    if update ~= nil and update.artifact.noattrs ~= nil then
      if msg.update.artifact == nil then
        msg.update.artifact = {}
      end
      if msg.update.artifact.noattrs == nil then
        msg.update.artifact.noattrs = {}
      end
      for i = 1, #update.artifact.noattrs do
        table.insert(msg.update.artifact.noattrs, update.artifact.noattrs[i])
      end
    end
    if update.cupinfo ~= nil and update.cupinfo.name ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.cupinfo == nil then
        msg.update.cupinfo = {}
      end
      msg.update.cupinfo.name = update.cupinfo.name
    end
    if update ~= nil and update.previewattr ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.previewattr == nil then
        msg.update.previewattr = {}
      end
      for i = 1, #update.previewattr do
        table.insert(msg.update.previewattr, update.previewattr[i])
      end
    end
    if update ~= nil and update.previewenchant ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.previewenchant == nil then
        msg.update.previewenchant = {}
      end
      for i = 1, #update.previewenchant do
        table.insert(msg.update.previewenchant, update.previewenchant[i])
      end
    end
    if update.red_packet ~= nil and update.red_packet.config_id ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.red_packet == nil then
        msg.update.red_packet = {}
      end
      msg.update.red_packet.config_id = update.red_packet.config_id
    end
    if update.red_packet ~= nil and update.red_packet.min_num ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.red_packet == nil then
        msg.update.red_packet = {}
      end
      msg.update.red_packet.min_num = update.red_packet.min_num
    end
    if update.red_packet ~= nil and update.red_packet.max_num ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.red_packet == nil then
        msg.update.red_packet = {}
      end
      msg.update.red_packet.max_num = update.red_packet.max_num
    end
    if update.red_packet ~= nil and update.red_packet.min_money ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.red_packet == nil then
        msg.update.red_packet = {}
      end
      msg.update.red_packet.min_money = update.red_packet.min_money
    end
    if update.red_packet ~= nil and update.red_packet.max_money ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.red_packet == nil then
        msg.update.red_packet = {}
      end
      msg.update.red_packet.max_money = update.red_packet.max_money
    end
    if update ~= nil and update.red_packet.multi_items ~= nil then
      if msg.update.red_packet == nil then
        msg.update.red_packet = {}
      end
      if msg.update.red_packet.multi_items == nil then
        msg.update.red_packet.multi_items = {}
      end
      for i = 1, #update.red_packet.multi_items do
        table.insert(msg.update.red_packet.multi_items, update.red_packet.multi_items[i])
      end
    end
    if update.red_packet ~= nil and update.red_packet.gvg_cityid ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.red_packet == nil then
        msg.update.red_packet = {}
      end
      msg.update.red_packet.gvg_cityid = update.red_packet.gvg_cityid
    end
    if update ~= nil and update.red_packet.gvg_charids ~= nil then
      if msg.update.red_packet == nil then
        msg.update.red_packet = {}
      end
      if msg.update.red_packet.gvg_charids == nil then
        msg.update.red_packet.gvg_charids = {}
      end
      for i = 1, #update.red_packet.gvg_charids do
        table.insert(msg.update.red_packet.gvg_charids, update.red_packet.gvg_charids[i])
      end
    end
    if update.gem_secret_land ~= nil and update.gem_secret_land.id ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.gem_secret_land == nil then
        msg.update.gem_secret_land = {}
      end
      msg.update.gem_secret_land.id = update.gem_secret_land.id
    end
    if update.gem_secret_land ~= nil and update.gem_secret_land.color ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.gem_secret_land == nil then
        msg.update.gem_secret_land = {}
      end
      msg.update.gem_secret_land.color = update.gem_secret_land.color
    end
    if update.gem_secret_land ~= nil and update.gem_secret_land.lv ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.gem_secret_land == nil then
        msg.update.gem_secret_land = {}
      end
      msg.update.gem_secret_land.lv = update.gem_secret_land.lv
    end
    if update.gem_secret_land ~= nil and update.gem_secret_land.max_lv ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.gem_secret_land == nil then
        msg.update.gem_secret_land = {}
      end
      msg.update.gem_secret_land.max_lv = update.gem_secret_land.max_lv
    end
    if update.gem_secret_land ~= nil and update.gem_secret_land.exp ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.gem_secret_land == nil then
        msg.update.gem_secret_land = {}
      end
      msg.update.gem_secret_land.exp = update.gem_secret_land.exp
    end
    if update ~= nil and update.gem_secret_land.buffs ~= nil then
      if msg.update.gem_secret_land == nil then
        msg.update.gem_secret_land = {}
      end
      if msg.update.gem_secret_land.buffs == nil then
        msg.update.gem_secret_land.buffs = {}
      end
      for i = 1, #update.gem_secret_land.buffs do
        table.insert(msg.update.gem_secret_land.buffs, update.gem_secret_land.buffs[i])
      end
    end
    if update ~= nil and update.gem_secret_land.char_data ~= nil then
      if msg.update.gem_secret_land == nil then
        msg.update.gem_secret_land = {}
      end
      if msg.update.gem_secret_land.char_data == nil then
        msg.update.gem_secret_land.char_data = {}
      end
      for i = 1, #update.gem_secret_land.char_data do
        table.insert(msg.update.gem_secret_land.char_data, update.gem_secret_land.char_data[i])
      end
    end
    if update.memory ~= nil and update.memory.itemid ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.memory == nil then
        msg.update.memory = {}
      end
      msg.update.memory.itemid = update.memory.itemid
    end
    if update.memory ~= nil and update.memory.lv ~= nil then
      if msg.update == nil then
        msg.update = {}
      end
      if msg.update.memory == nil then
        msg.update.memory = {}
      end
      msg.update.memory.lv = update.memory.lv
    end
    if update ~= nil and update.memory.effects ~= nil then
      if msg.update.memory == nil then
        msg.update.memory = {}
      end
      if msg.update.memory.effects == nil then
        msg.update.memory.effects = {}
      end
      for i = 1, #update.memory.effects do
        table.insert(msg.update.memory.effects, update.memory.effects[i])
      end
    end
    if update ~= nil and update.deletetime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.update == nil then
        msg.update = {}
      end
      msg.update.deletetime = update.deletetime
    end
    if del ~= nil then
      msg.del = del
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EquipUpdatePetCmd.id
    local msgParam = {}
    if petid ~= nil then
      msgParam.petid = petid
    end
    if update.base ~= nil and update.base.guid ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.guid = update.base.guid
    end
    if update.base ~= nil and update.base.id ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.id = update.base.id
    end
    if update.base ~= nil and update.base.count ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.count = update.base.count
    end
    if update.base ~= nil and update.base.index ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.index = update.base.index
    end
    if update.base ~= nil and update.base.createtime ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.createtime = update.base.createtime
    end
    if update.base ~= nil and update.base.cd ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.cd = update.base.cd
    end
    if update.base ~= nil and update.base.type ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.type = update.base.type
    end
    if update.base ~= nil and update.base.bind ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.bind = update.base.bind
    end
    if update.base ~= nil and update.base.expire ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.expire = update.base.expire
    end
    if update.base ~= nil and update.base.quality ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.quality = update.base.quality
    end
    if update.base ~= nil and update.base.equipType ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.equipType = update.base.equipType
    end
    if update.base ~= nil and update.base.source ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.source = update.base.source
    end
    if update.base ~= nil and update.base.isnew ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.isnew = update.base.isnew
    end
    if update.base ~= nil and update.base.maxcardslot ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.maxcardslot = update.base.maxcardslot
    end
    if update.base ~= nil and update.base.ishint ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.ishint = update.base.ishint
    end
    if update.base ~= nil and update.base.isactive ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.isactive = update.base.isactive
    end
    if update.base ~= nil and update.base.source_npc ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.source_npc = update.base.source_npc
    end
    if update.base ~= nil and update.base.refinelv ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.refinelv = update.base.refinelv
    end
    if update.base ~= nil and update.base.chargemoney ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.chargemoney = update.base.chargemoney
    end
    if update.base ~= nil and update.base.overtime ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.overtime = update.base.overtime
    end
    if update.base ~= nil and update.base.quota ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.quota = update.base.quota
    end
    if update.base ~= nil and update.base.usedtimes ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.usedtimes = update.base.usedtimes
    end
    if update.base ~= nil and update.base.usedtime ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.usedtime = update.base.usedtime
    end
    if update.base ~= nil and update.base.isfavorite ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.isfavorite = update.base.isfavorite
    end
    if update ~= nil and update.base.mailhint ~= nil then
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      if msgParam.update.base.mailhint == nil then
        msgParam.update.base.mailhint = {}
      end
      for i = 1, #update.base.mailhint do
        table.insert(msgParam.update.base.mailhint, update.base.mailhint[i])
      end
    end
    if update.base ~= nil and update.base.subsource ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.subsource = update.base.subsource
    end
    if update.base ~= nil and update.base.randkey ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.randkey = update.base.randkey
    end
    if update.base ~= nil and update.base.sceneinfo ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.sceneinfo = update.base.sceneinfo
    end
    if update.base ~= nil and update.base.local_charge ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.local_charge = update.base.local_charge
    end
    if update.base ~= nil and update.base.charge_deposit_id ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.charge_deposit_id = update.base.charge_deposit_id
    end
    if update.base ~= nil and update.base.issplit ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.issplit = update.base.issplit
    end
    if update.base.tmp ~= nil and update.base.tmp.none ~= nil then
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      if msgParam.update.base.tmp == nil then
        msgParam.update.base.tmp = {}
      end
      msgParam.update.base.tmp.none = update.base.tmp.none
    end
    if update.base.tmp ~= nil and update.base.tmp.num_param ~= nil then
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      if msgParam.update.base.tmp == nil then
        msgParam.update.base.tmp = {}
      end
      msgParam.update.base.tmp.num_param = update.base.tmp.num_param
    end
    if update.base.tmp ~= nil and update.base.tmp.from_reward ~= nil then
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      if msgParam.update.base.tmp == nil then
        msgParam.update.base.tmp = {}
      end
      msgParam.update.base.tmp.from_reward = update.base.tmp.from_reward
    end
    if update.base ~= nil and update.base.mount_fashion_activated ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.mount_fashion_activated = update.base.mount_fashion_activated
    end
    if update.base ~= nil and update.base.no_trade_reason ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      msgParam.update.base.no_trade_reason = update.base.no_trade_reason
    end
    if update.base.card_info ~= nil and update.base.card_info.lv ~= nil then
      if msgParam.update.base == nil then
        msgParam.update.base = {}
      end
      if msgParam.update.base.card_info == nil then
        msgParam.update.base.card_info = {}
      end
      msgParam.update.base.card_info.lv = update.base.card_info.lv
    end
    if update ~= nil and update.equiped ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.update == nil then
        msgParam.update = {}
      end
      msgParam.update.equiped = update.equiped
    end
    if update ~= nil and update.battlepoint ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.update == nil then
        msgParam.update = {}
      end
      msgParam.update.battlepoint = update.battlepoint
    end
    if update.equip ~= nil and update.equip.strengthlv ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.equip == nil then
        msgParam.update.equip = {}
      end
      msgParam.update.equip.strengthlv = update.equip.strengthlv
    end
    if update.equip ~= nil and update.equip.refinelv ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.equip == nil then
        msgParam.update.equip = {}
      end
      msgParam.update.equip.refinelv = update.equip.refinelv
    end
    if update.equip ~= nil and update.equip.strengthCost ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.equip == nil then
        msgParam.update.equip = {}
      end
      msgParam.update.equip.strengthCost = update.equip.strengthCost
    end
    if update ~= nil and update.equip.refineCompose ~= nil then
      if msgParam.update.equip == nil then
        msgParam.update.equip = {}
      end
      if msgParam.update.equip.refineCompose == nil then
        msgParam.update.equip.refineCompose = {}
      end
      for i = 1, #update.equip.refineCompose do
        table.insert(msgParam.update.equip.refineCompose, update.equip.refineCompose[i])
      end
    end
    if update.equip ~= nil and update.equip.cardslot ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.equip == nil then
        msgParam.update.equip = {}
      end
      msgParam.update.equip.cardslot = update.equip.cardslot
    end
    if update ~= nil and update.equip.buffid ~= nil then
      if msgParam.update.equip == nil then
        msgParam.update.equip = {}
      end
      if msgParam.update.equip.buffid == nil then
        msgParam.update.equip.buffid = {}
      end
      for i = 1, #update.equip.buffid do
        table.insert(msgParam.update.equip.buffid, update.equip.buffid[i])
      end
    end
    if update.equip ~= nil and update.equip.damage ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.equip == nil then
        msgParam.update.equip = {}
      end
      msgParam.update.equip.damage = update.equip.damage
    end
    if update.equip ~= nil and update.equip.lv ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.equip == nil then
        msgParam.update.equip = {}
      end
      msgParam.update.equip.lv = update.equip.lv
    end
    if update.equip ~= nil and update.equip.color ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.equip == nil then
        msgParam.update.equip = {}
      end
      msgParam.update.equip.color = update.equip.color
    end
    if update.equip ~= nil and update.equip.breakstarttime ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.equip == nil then
        msgParam.update.equip = {}
      end
      msgParam.update.equip.breakstarttime = update.equip.breakstarttime
    end
    if update.equip ~= nil and update.equip.breakendtime ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.equip == nil then
        msgParam.update.equip = {}
      end
      msgParam.update.equip.breakendtime = update.equip.breakendtime
    end
    if update.equip ~= nil and update.equip.strengthlv2 ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.equip == nil then
        msgParam.update.equip = {}
      end
      msgParam.update.equip.strengthlv2 = update.equip.strengthlv2
    end
    if update.equip ~= nil and update.equip.quenchper ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.equip == nil then
        msgParam.update.equip = {}
      end
      msgParam.update.equip.quenchper = update.equip.quenchper
    end
    if update ~= nil and update.equip.strengthlv2cost ~= nil then
      if msgParam.update.equip == nil then
        msgParam.update.equip = {}
      end
      if msgParam.update.equip.strengthlv2cost == nil then
        msgParam.update.equip.strengthlv2cost = {}
      end
      for i = 1, #update.equip.strengthlv2cost do
        table.insert(msgParam.update.equip.strengthlv2cost, update.equip.strengthlv2cost[i])
      end
    end
    if update ~= nil and update.equip.attrs ~= nil then
      if msgParam.update.equip == nil then
        msgParam.update.equip = {}
      end
      if msgParam.update.equip.attrs == nil then
        msgParam.update.equip.attrs = {}
      end
      for i = 1, #update.equip.attrs do
        table.insert(msgParam.update.equip.attrs, update.equip.attrs[i])
      end
    end
    if update.equip ~= nil and update.equip.extra_refine_value ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.equip == nil then
        msgParam.update.equip = {}
      end
      msgParam.update.equip.extra_refine_value = update.equip.extra_refine_value
    end
    if update ~= nil and update.card ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.card == nil then
        msgParam.update.card = {}
      end
      for i = 1, #update.card do
        table.insert(msgParam.update.card, update.card[i])
      end
    end
    if update.enchant ~= nil and update.enchant.type ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.enchant == nil then
        msgParam.update.enchant = {}
      end
      msgParam.update.enchant.type = update.enchant.type
    end
    if update ~= nil and update.enchant.attrs ~= nil then
      if msgParam.update.enchant == nil then
        msgParam.update.enchant = {}
      end
      if msgParam.update.enchant.attrs == nil then
        msgParam.update.enchant.attrs = {}
      end
      for i = 1, #update.enchant.attrs do
        table.insert(msgParam.update.enchant.attrs, update.enchant.attrs[i])
      end
    end
    if update ~= nil and update.enchant.extras ~= nil then
      if msgParam.update.enchant == nil then
        msgParam.update.enchant = {}
      end
      if msgParam.update.enchant.extras == nil then
        msgParam.update.enchant.extras = {}
      end
      for i = 1, #update.enchant.extras do
        table.insert(msgParam.update.enchant.extras, update.enchant.extras[i])
      end
    end
    if update ~= nil and update.enchant.patch ~= nil then
      if msgParam.update.enchant == nil then
        msgParam.update.enchant = {}
      end
      if msgParam.update.enchant.patch == nil then
        msgParam.update.enchant.patch = {}
      end
      for i = 1, #update.enchant.patch do
        table.insert(msgParam.update.enchant.patch, update.enchant.patch[i])
      end
    end
    if update.enchant ~= nil and update.enchant.israteup ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.enchant == nil then
        msgParam.update.enchant = {}
      end
      msgParam.update.enchant.israteup = update.enchant.israteup
    end
    if update.prenchant ~= nil and update.prenchant.type ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.prenchant == nil then
        msgParam.update.prenchant = {}
      end
      msgParam.update.prenchant.type = update.prenchant.type
    end
    if update ~= nil and update.prenchant.attrs ~= nil then
      if msgParam.update.prenchant == nil then
        msgParam.update.prenchant = {}
      end
      if msgParam.update.prenchant.attrs == nil then
        msgParam.update.prenchant.attrs = {}
      end
      for i = 1, #update.prenchant.attrs do
        table.insert(msgParam.update.prenchant.attrs, update.prenchant.attrs[i])
      end
    end
    if update ~= nil and update.prenchant.extras ~= nil then
      if msgParam.update.prenchant == nil then
        msgParam.update.prenchant = {}
      end
      if msgParam.update.prenchant.extras == nil then
        msgParam.update.prenchant.extras = {}
      end
      for i = 1, #update.prenchant.extras do
        table.insert(msgParam.update.prenchant.extras, update.prenchant.extras[i])
      end
    end
    if update ~= nil and update.prenchant.patch ~= nil then
      if msgParam.update.prenchant == nil then
        msgParam.update.prenchant = {}
      end
      if msgParam.update.prenchant.patch == nil then
        msgParam.update.prenchant.patch = {}
      end
      for i = 1, #update.prenchant.patch do
        table.insert(msgParam.update.prenchant.patch, update.prenchant.patch[i])
      end
    end
    if update.prenchant ~= nil and update.prenchant.israteup ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.prenchant == nil then
        msgParam.update.prenchant = {}
      end
      msgParam.update.prenchant.israteup = update.prenchant.israteup
    end
    if update.refine ~= nil and update.refine.lastfail ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.refine == nil then
        msgParam.update.refine = {}
      end
      msgParam.update.refine.lastfail = update.refine.lastfail
    end
    if update.refine ~= nil and update.refine.repaircount ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.refine == nil then
        msgParam.update.refine = {}
      end
      msgParam.update.refine.repaircount = update.refine.repaircount
    end
    if update.refine ~= nil and update.refine.lastfailcount ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.refine == nil then
        msgParam.update.refine = {}
      end
      msgParam.update.refine.lastfailcount = update.refine.lastfailcount
    end
    if update.refine ~= nil and update.refine.history_fix_rate ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.refine == nil then
        msgParam.update.refine = {}
      end
      msgParam.update.refine.history_fix_rate = update.refine.history_fix_rate
    end
    if update.refine ~= nil and update.refine.cost_count ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.refine == nil then
        msgParam.update.refine = {}
      end
      msgParam.update.refine.cost_count = update.refine.cost_count
    end
    if update ~= nil and update.refine.cost_counts ~= nil then
      if msgParam.update.refine == nil then
        msgParam.update.refine = {}
      end
      if msgParam.update.refine.cost_counts == nil then
        msgParam.update.refine.cost_counts = {}
      end
      for i = 1, #update.refine.cost_counts do
        table.insert(msgParam.update.refine.cost_counts, update.refine.cost_counts[i])
      end
    end
    if update.egg ~= nil and update.egg.exp ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.exp = update.egg.exp
    end
    if update.egg ~= nil and update.egg.friendexp ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.friendexp = update.egg.friendexp
    end
    if update.egg ~= nil and update.egg.rewardexp ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.rewardexp = update.egg.rewardexp
    end
    if update.egg ~= nil and update.egg.id ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.id = update.egg.id
    end
    if update.egg ~= nil and update.egg.lv ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.lv = update.egg.lv
    end
    if update.egg ~= nil and update.egg.friendlv ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.friendlv = update.egg.friendlv
    end
    if update.egg ~= nil and update.egg.body ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.body = update.egg.body
    end
    if update.egg ~= nil and update.egg.relivetime ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.relivetime = update.egg.relivetime
    end
    if update.egg ~= nil and update.egg.hp ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.hp = update.egg.hp
    end
    if update.egg ~= nil and update.egg.restoretime ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.restoretime = update.egg.restoretime
    end
    if update.egg ~= nil and update.egg.time_happly ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.time_happly = update.egg.time_happly
    end
    if update.egg ~= nil and update.egg.time_excite ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.time_excite = update.egg.time_excite
    end
    if update.egg ~= nil and update.egg.time_happiness ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.time_happiness = update.egg.time_happiness
    end
    if update.egg ~= nil and update.egg.time_happly_gift ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.time_happly_gift = update.egg.time_happly_gift
    end
    if update.egg ~= nil and update.egg.time_excite_gift ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.time_excite_gift = update.egg.time_excite_gift
    end
    if update.egg ~= nil and update.egg.time_happiness_gift ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.time_happiness_gift = update.egg.time_happiness_gift
    end
    if update.egg ~= nil and update.egg.touch_tick ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.touch_tick = update.egg.touch_tick
    end
    if update.egg ~= nil and update.egg.feed_tick ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.feed_tick = update.egg.feed_tick
    end
    if update.egg ~= nil and update.egg.name ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.name = update.egg.name
    end
    if update.egg ~= nil and update.egg.var ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.var = update.egg.var
    end
    if update ~= nil and update.egg.skillids ~= nil then
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      if msgParam.update.egg.skillids == nil then
        msgParam.update.egg.skillids = {}
      end
      for i = 1, #update.egg.skillids do
        table.insert(msgParam.update.egg.skillids, update.egg.skillids[i])
      end
    end
    if update ~= nil and update.egg.equips ~= nil then
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      if msgParam.update.egg.equips == nil then
        msgParam.update.egg.equips = {}
      end
      for i = 1, #update.egg.equips do
        table.insert(msgParam.update.egg.equips, update.egg.equips[i])
      end
    end
    if update.egg ~= nil and update.egg.buff ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.buff = update.egg.buff
    end
    if update ~= nil and update.egg.unlock_equip ~= nil then
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      if msgParam.update.egg.unlock_equip == nil then
        msgParam.update.egg.unlock_equip = {}
      end
      for i = 1, #update.egg.unlock_equip do
        table.insert(msgParam.update.egg.unlock_equip, update.egg.unlock_equip[i])
      end
    end
    if update ~= nil and update.egg.unlock_body ~= nil then
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      if msgParam.update.egg.unlock_body == nil then
        msgParam.update.egg.unlock_body = {}
      end
      for i = 1, #update.egg.unlock_body do
        table.insert(msgParam.update.egg.unlock_body, update.egg.unlock_body[i])
      end
    end
    if update.egg ~= nil and update.egg.version ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.version = update.egg.version
    end
    if update.egg ~= nil and update.egg.skilloff ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.skilloff = update.egg.skilloff
    end
    if update.egg ~= nil and update.egg.exchange_count ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.exchange_count = update.egg.exchange_count
    end
    if update.egg ~= nil and update.egg.guid ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.guid = update.egg.guid
    end
    if update ~= nil and update.egg.defaultwears ~= nil then
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      if msgParam.update.egg.defaultwears == nil then
        msgParam.update.egg.defaultwears = {}
      end
      for i = 1, #update.egg.defaultwears do
        table.insert(msgParam.update.egg.defaultwears, update.egg.defaultwears[i])
      end
    end
    if update ~= nil and update.egg.wears ~= nil then
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      if msgParam.update.egg.wears == nil then
        msgParam.update.egg.wears = {}
      end
      for i = 1, #update.egg.wears do
        table.insert(msgParam.update.egg.wears, update.egg.wears[i])
      end
    end
    if update.egg ~= nil and update.egg.cdtime ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.egg == nil then
        msgParam.update.egg = {}
      end
      msgParam.update.egg.cdtime = update.egg.cdtime
    end
    if update.letter ~= nil and update.letter.sendUserName ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.letter == nil then
        msgParam.update.letter = {}
      end
      msgParam.update.letter.sendUserName = update.letter.sendUserName
    end
    if update.letter ~= nil and update.letter.bg ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.letter == nil then
        msgParam.update.letter = {}
      end
      msgParam.update.letter.bg = update.letter.bg
    end
    if update.letter ~= nil and update.letter.configID ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.letter == nil then
        msgParam.update.letter = {}
      end
      msgParam.update.letter.configID = update.letter.configID
    end
    if update.letter ~= nil and update.letter.content ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.letter == nil then
        msgParam.update.letter = {}
      end
      msgParam.update.letter.content = update.letter.content
    end
    if update.letter ~= nil and update.letter.content2 ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.letter == nil then
        msgParam.update.letter = {}
      end
      msgParam.update.letter.content2 = update.letter.content2
    end
    if update.code ~= nil and update.code.code ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.code == nil then
        msgParam.update.code = {}
      end
      msgParam.update.code.code = update.code.code
    end
    if update.code ~= nil and update.code.used ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.code == nil then
        msgParam.update.code = {}
      end
      msgParam.update.code.used = update.code.used
    end
    if update.wedding ~= nil and update.wedding.id ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.wedding == nil then
        msgParam.update.wedding = {}
      end
      msgParam.update.wedding.id = update.wedding.id
    end
    if update.wedding ~= nil and update.wedding.zoneid ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.wedding == nil then
        msgParam.update.wedding = {}
      end
      msgParam.update.wedding.zoneid = update.wedding.zoneid
    end
    if update.wedding ~= nil and update.wedding.charid1 ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.wedding == nil then
        msgParam.update.wedding = {}
      end
      msgParam.update.wedding.charid1 = update.wedding.charid1
    end
    if update.wedding ~= nil and update.wedding.charid2 ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.wedding == nil then
        msgParam.update.wedding = {}
      end
      msgParam.update.wedding.charid2 = update.wedding.charid2
    end
    if update.wedding ~= nil and update.wedding.weddingtime ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.wedding == nil then
        msgParam.update.wedding = {}
      end
      msgParam.update.wedding.weddingtime = update.wedding.weddingtime
    end
    if update.wedding ~= nil and update.wedding.photoidx ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.wedding == nil then
        msgParam.update.wedding = {}
      end
      msgParam.update.wedding.photoidx = update.wedding.photoidx
    end
    if update.wedding ~= nil and update.wedding.phototime ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.wedding == nil then
        msgParam.update.wedding = {}
      end
      msgParam.update.wedding.phototime = update.wedding.phototime
    end
    if update.wedding ~= nil and update.wedding.myname ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.wedding == nil then
        msgParam.update.wedding = {}
      end
      msgParam.update.wedding.myname = update.wedding.myname
    end
    if update.wedding ~= nil and update.wedding.partnername ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.wedding == nil then
        msgParam.update.wedding = {}
      end
      msgParam.update.wedding.partnername = update.wedding.partnername
    end
    if update.wedding ~= nil and update.wedding.starttime ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.wedding == nil then
        msgParam.update.wedding = {}
      end
      msgParam.update.wedding.starttime = update.wedding.starttime
    end
    if update.wedding ~= nil and update.wedding.endtime ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.wedding == nil then
        msgParam.update.wedding = {}
      end
      msgParam.update.wedding.endtime = update.wedding.endtime
    end
    if update.wedding ~= nil and update.wedding.notified ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.wedding == nil then
        msgParam.update.wedding = {}
      end
      msgParam.update.wedding.notified = update.wedding.notified
    end
    if update.sender ~= nil and update.sender.charid ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.sender == nil then
        msgParam.update.sender = {}
      end
      msgParam.update.sender.charid = update.sender.charid
    end
    if update.sender ~= nil and update.sender.name ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.sender == nil then
        msgParam.update.sender = {}
      end
      msgParam.update.sender.name = update.sender.name
    end
    if update.furniture ~= nil and update.furniture.id ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      msgParam.update.furniture.id = update.furniture.id
    end
    if update.furniture ~= nil and update.furniture.angle ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      msgParam.update.furniture.angle = update.furniture.angle
    end
    if update.furniture ~= nil and update.furniture.lv ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      msgParam.update.furniture.lv = update.furniture.lv
    end
    if update.furniture ~= nil and update.furniture.row ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      msgParam.update.furniture.row = update.furniture.row
    end
    if update.furniture ~= nil and update.furniture.col ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      msgParam.update.furniture.col = update.furniture.col
    end
    if update.furniture ~= nil and update.furniture.floor ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      msgParam.update.furniture.floor = update.furniture.floor
    end
    if update.furniture ~= nil and update.furniture.rewardtime ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      msgParam.update.furniture.rewardtime = update.furniture.rewardtime
    end
    if update.furniture ~= nil and update.furniture.state ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      msgParam.update.furniture.state = update.furniture.state
    end
    if update.furniture ~= nil and update.furniture.guid ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      msgParam.update.furniture.guid = update.furniture.guid
    end
    if update.furniture ~= nil and update.furniture.old_guid ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      msgParam.update.furniture.old_guid = update.furniture.old_guid
    end
    if update.furniture ~= nil and update.furniture.var ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      msgParam.update.furniture.var = update.furniture.var
    end
    if update ~= nil and update.furniture.seats ~= nil then
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      if msgParam.update.furniture.seats == nil then
        msgParam.update.furniture.seats = {}
      end
      for i = 1, #update.furniture.seats do
        table.insert(msgParam.update.furniture.seats, update.furniture.seats[i])
      end
    end
    if update ~= nil and update.furniture.seatskills ~= nil then
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      if msgParam.update.furniture.seatskills == nil then
        msgParam.update.furniture.seatskills = {}
      end
      for i = 1, #update.furniture.seatskills do
        table.insert(msgParam.update.furniture.seatskills, update.furniture.seatskills[i])
      end
    end
    if update ~= nil and update.furniture.photos ~= nil then
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      if msgParam.update.furniture.photos == nil then
        msgParam.update.furniture.photos = {}
      end
      for i = 1, #update.furniture.photos do
        table.insert(msgParam.update.furniture.photos, update.furniture.photos[i])
      end
    end
    if update.furniture.npc ~= nil and update.furniture.npc.race ~= nil then
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      if msgParam.update.furniture.npc == nil then
        msgParam.update.furniture.npc = {}
      end
      msgParam.update.furniture.npc.race = update.furniture.npc.race
    end
    if update.furniture.npc ~= nil and update.furniture.npc.shape ~= nil then
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      if msgParam.update.furniture.npc == nil then
        msgParam.update.furniture.npc = {}
      end
      msgParam.update.furniture.npc.shape = update.furniture.npc.shape
    end
    if update.furniture.npc ~= nil and update.furniture.npc.nature ~= nil then
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      if msgParam.update.furniture.npc == nil then
        msgParam.update.furniture.npc = {}
      end
      msgParam.update.furniture.npc.nature = update.furniture.npc.nature
    end
    if update.furniture.npc ~= nil and update.furniture.npc.hpreduce ~= nil then
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      if msgParam.update.furniture.npc == nil then
        msgParam.update.furniture.npc = {}
      end
      msgParam.update.furniture.npc.hpreduce = update.furniture.npc.hpreduce
    end
    if update.furniture.npc ~= nil and update.furniture.npc.naturelv ~= nil then
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      if msgParam.update.furniture.npc == nil then
        msgParam.update.furniture.npc = {}
      end
      msgParam.update.furniture.npc.naturelv = update.furniture.npc.naturelv
    end
    if update ~= nil and update.furniture.npc.history_max ~= nil then
      if msgParam.update.furniture.npc == nil then
        msgParam.update.furniture.npc = {}
      end
      if msgParam.update.furniture.npc.history_max == nil then
        msgParam.update.furniture.npc.history_max = {}
      end
      for i = 1, #update.furniture.npc.history_max do
        table.insert(msgParam.update.furniture.npc.history_max, update.furniture.npc.history_max[i])
      end
    end
    if update ~= nil and update.furniture.npc.day_max ~= nil then
      if msgParam.update.furniture.npc == nil then
        msgParam.update.furniture.npc = {}
      end
      if msgParam.update.furniture.npc.day_max == nil then
        msgParam.update.furniture.npc.day_max = {}
      end
      for i = 1, #update.furniture.npc.day_max do
        table.insert(msgParam.update.furniture.npc.day_max, update.furniture.npc.day_max[i])
      end
    end
    if update.furniture.npc ~= nil and update.furniture.npc.bosstype ~= nil then
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      if msgParam.update.furniture.npc == nil then
        msgParam.update.furniture.npc = {}
      end
      msgParam.update.furniture.npc.bosstype = update.furniture.npc.bosstype
    end
    if update.furniture.npc ~= nil and update.furniture.npc.wood_type ~= nil then
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      if msgParam.update.furniture.npc == nil then
        msgParam.update.furniture.npc = {}
      end
      msgParam.update.furniture.npc.wood_type = update.furniture.npc.wood_type
    end
    if update.furniture.npc ~= nil and update.furniture.npc.monster_id ~= nil then
      if msgParam.update.furniture == nil then
        msgParam.update.furniture = {}
      end
      if msgParam.update.furniture.npc == nil then
        msgParam.update.furniture.npc = {}
      end
      msgParam.update.furniture.npc.monster_id = update.furniture.npc.monster_id
    end
    if update.attr ~= nil and update.attr.id ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.attr == nil then
        msgParam.update.attr = {}
      end
      msgParam.update.attr.id = update.attr.id
    end
    if update.attr ~= nil and update.attr.lv ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.attr == nil then
        msgParam.update.attr = {}
      end
      msgParam.update.attr.lv = update.attr.lv
    end
    if update.attr ~= nil and update.attr.exp ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.attr == nil then
        msgParam.update.attr = {}
      end
      msgParam.update.attr.exp = update.attr.exp
    end
    if update.attr ~= nil and update.attr.pos ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.attr == nil then
        msgParam.update.attr = {}
      end
      msgParam.update.attr.pos = update.attr.pos
    end
    if update.attr ~= nil and update.attr.time ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.attr == nil then
        msgParam.update.attr = {}
      end
      msgParam.update.attr.time = update.attr.time
    end
    if update.attr ~= nil and update.attr.charid ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.attr == nil then
        msgParam.update.attr = {}
      end
      msgParam.update.attr.charid = update.attr.charid
    end
    if update.skill ~= nil and update.skill.id ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.skill == nil then
        msgParam.update.skill = {}
      end
      msgParam.update.skill.id = update.skill.id
    end
    if update.skill ~= nil and update.skill.pos ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.skill == nil then
        msgParam.update.skill = {}
      end
      msgParam.update.skill.pos = update.skill.pos
    end
    if update.skill ~= nil and update.skill.charid ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.skill == nil then
        msgParam.update.skill = {}
      end
      msgParam.update.skill.charid = update.skill.charid
    end
    if update.skill ~= nil and update.skill.issame ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.skill == nil then
        msgParam.update.skill = {}
      end
      msgParam.update.skill.issame = update.skill.issame
    end
    if update ~= nil and update.skill.buffs ~= nil then
      if msgParam.update.skill == nil then
        msgParam.update.skill = {}
      end
      if msgParam.update.skill.buffs == nil then
        msgParam.update.skill.buffs = {}
      end
      for i = 1, #update.skill.buffs do
        table.insert(msgParam.update.skill.buffs, update.skill.buffs[i])
      end
    end
    if update ~= nil and update.skill.carves ~= nil then
      if msgParam.update.skill == nil then
        msgParam.update.skill = {}
      end
      if msgParam.update.skill.carves == nil then
        msgParam.update.skill.carves = {}
      end
      for i = 1, #update.skill.carves do
        table.insert(msgParam.update.skill.carves, update.skill.carves[i])
      end
    end
    if update.skill ~= nil and update.skill.isforbid ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.skill == nil then
        msgParam.update.skill = {}
      end
      msgParam.update.skill.isforbid = update.skill.isforbid
    end
    if update.skill ~= nil and update.skill.isfull ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.skill == nil then
        msgParam.update.skill = {}
      end
      msgParam.update.skill.isfull = update.skill.isfull
    end
    if update.home ~= nil and update.home.ownerid ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.home == nil then
        msgParam.update.home = {}
      end
      msgParam.update.home.ownerid = update.home.ownerid
    end
    if update ~= nil and update.artifact.attrs ~= nil then
      if msgParam.update.artifact == nil then
        msgParam.update.artifact = {}
      end
      if msgParam.update.artifact.attrs == nil then
        msgParam.update.artifact.attrs = {}
      end
      for i = 1, #update.artifact.attrs do
        table.insert(msgParam.update.artifact.attrs, update.artifact.attrs[i])
      end
    end
    if update ~= nil and update.artifact.preattrs ~= nil then
      if msgParam.update.artifact == nil then
        msgParam.update.artifact = {}
      end
      if msgParam.update.artifact.preattrs == nil then
        msgParam.update.artifact.preattrs = {}
      end
      for i = 1, #update.artifact.preattrs do
        table.insert(msgParam.update.artifact.preattrs, update.artifact.preattrs[i])
      end
    end
    if update.artifact ~= nil and update.artifact.art_state ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.artifact == nil then
        msgParam.update.artifact = {}
      end
      msgParam.update.artifact.art_state = update.artifact.art_state
    end
    if update ~= nil and update.artifact.art_fragment ~= nil then
      if msgParam.update.artifact == nil then
        msgParam.update.artifact = {}
      end
      if msgParam.update.artifact.art_fragment == nil then
        msgParam.update.artifact.art_fragment = {}
      end
      for i = 1, #update.artifact.art_fragment do
        table.insert(msgParam.update.artifact.art_fragment, update.artifact.art_fragment[i])
      end
    end
    if update ~= nil and update.artifact.noattrs ~= nil then
      if msgParam.update.artifact == nil then
        msgParam.update.artifact = {}
      end
      if msgParam.update.artifact.noattrs == nil then
        msgParam.update.artifact.noattrs = {}
      end
      for i = 1, #update.artifact.noattrs do
        table.insert(msgParam.update.artifact.noattrs, update.artifact.noattrs[i])
      end
    end
    if update.cupinfo ~= nil and update.cupinfo.name ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.cupinfo == nil then
        msgParam.update.cupinfo = {}
      end
      msgParam.update.cupinfo.name = update.cupinfo.name
    end
    if update ~= nil and update.previewattr ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.previewattr == nil then
        msgParam.update.previewattr = {}
      end
      for i = 1, #update.previewattr do
        table.insert(msgParam.update.previewattr, update.previewattr[i])
      end
    end
    if update ~= nil and update.previewenchant ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.previewenchant == nil then
        msgParam.update.previewenchant = {}
      end
      for i = 1, #update.previewenchant do
        table.insert(msgParam.update.previewenchant, update.previewenchant[i])
      end
    end
    if update.red_packet ~= nil and update.red_packet.config_id ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.red_packet == nil then
        msgParam.update.red_packet = {}
      end
      msgParam.update.red_packet.config_id = update.red_packet.config_id
    end
    if update.red_packet ~= nil and update.red_packet.min_num ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.red_packet == nil then
        msgParam.update.red_packet = {}
      end
      msgParam.update.red_packet.min_num = update.red_packet.min_num
    end
    if update.red_packet ~= nil and update.red_packet.max_num ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.red_packet == nil then
        msgParam.update.red_packet = {}
      end
      msgParam.update.red_packet.max_num = update.red_packet.max_num
    end
    if update.red_packet ~= nil and update.red_packet.min_money ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.red_packet == nil then
        msgParam.update.red_packet = {}
      end
      msgParam.update.red_packet.min_money = update.red_packet.min_money
    end
    if update.red_packet ~= nil and update.red_packet.max_money ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.red_packet == nil then
        msgParam.update.red_packet = {}
      end
      msgParam.update.red_packet.max_money = update.red_packet.max_money
    end
    if update ~= nil and update.red_packet.multi_items ~= nil then
      if msgParam.update.red_packet == nil then
        msgParam.update.red_packet = {}
      end
      if msgParam.update.red_packet.multi_items == nil then
        msgParam.update.red_packet.multi_items = {}
      end
      for i = 1, #update.red_packet.multi_items do
        table.insert(msgParam.update.red_packet.multi_items, update.red_packet.multi_items[i])
      end
    end
    if update.red_packet ~= nil and update.red_packet.gvg_cityid ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.red_packet == nil then
        msgParam.update.red_packet = {}
      end
      msgParam.update.red_packet.gvg_cityid = update.red_packet.gvg_cityid
    end
    if update ~= nil and update.red_packet.gvg_charids ~= nil then
      if msgParam.update.red_packet == nil then
        msgParam.update.red_packet = {}
      end
      if msgParam.update.red_packet.gvg_charids == nil then
        msgParam.update.red_packet.gvg_charids = {}
      end
      for i = 1, #update.red_packet.gvg_charids do
        table.insert(msgParam.update.red_packet.gvg_charids, update.red_packet.gvg_charids[i])
      end
    end
    if update.gem_secret_land ~= nil and update.gem_secret_land.id ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.gem_secret_land == nil then
        msgParam.update.gem_secret_land = {}
      end
      msgParam.update.gem_secret_land.id = update.gem_secret_land.id
    end
    if update.gem_secret_land ~= nil and update.gem_secret_land.color ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.gem_secret_land == nil then
        msgParam.update.gem_secret_land = {}
      end
      msgParam.update.gem_secret_land.color = update.gem_secret_land.color
    end
    if update.gem_secret_land ~= nil and update.gem_secret_land.lv ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.gem_secret_land == nil then
        msgParam.update.gem_secret_land = {}
      end
      msgParam.update.gem_secret_land.lv = update.gem_secret_land.lv
    end
    if update.gem_secret_land ~= nil and update.gem_secret_land.max_lv ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.gem_secret_land == nil then
        msgParam.update.gem_secret_land = {}
      end
      msgParam.update.gem_secret_land.max_lv = update.gem_secret_land.max_lv
    end
    if update.gem_secret_land ~= nil and update.gem_secret_land.exp ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.gem_secret_land == nil then
        msgParam.update.gem_secret_land = {}
      end
      msgParam.update.gem_secret_land.exp = update.gem_secret_land.exp
    end
    if update ~= nil and update.gem_secret_land.buffs ~= nil then
      if msgParam.update.gem_secret_land == nil then
        msgParam.update.gem_secret_land = {}
      end
      if msgParam.update.gem_secret_land.buffs == nil then
        msgParam.update.gem_secret_land.buffs = {}
      end
      for i = 1, #update.gem_secret_land.buffs do
        table.insert(msgParam.update.gem_secret_land.buffs, update.gem_secret_land.buffs[i])
      end
    end
    if update ~= nil and update.gem_secret_land.char_data ~= nil then
      if msgParam.update.gem_secret_land == nil then
        msgParam.update.gem_secret_land = {}
      end
      if msgParam.update.gem_secret_land.char_data == nil then
        msgParam.update.gem_secret_land.char_data = {}
      end
      for i = 1, #update.gem_secret_land.char_data do
        table.insert(msgParam.update.gem_secret_land.char_data, update.gem_secret_land.char_data[i])
      end
    end
    if update.memory ~= nil and update.memory.itemid ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.memory == nil then
        msgParam.update.memory = {}
      end
      msgParam.update.memory.itemid = update.memory.itemid
    end
    if update.memory ~= nil and update.memory.lv ~= nil then
      if msgParam.update == nil then
        msgParam.update = {}
      end
      if msgParam.update.memory == nil then
        msgParam.update.memory = {}
      end
      msgParam.update.memory.lv = update.memory.lv
    end
    if update ~= nil and update.memory.effects ~= nil then
      if msgParam.update.memory == nil then
        msgParam.update.memory = {}
      end
      if msgParam.update.memory.effects == nil then
        msgParam.update.memory.effects = {}
      end
      for i = 1, #update.memory.effects do
        table.insert(msgParam.update.memory.effects, update.memory.effects[i])
      end
    end
    if update ~= nil and update.deletetime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.update == nil then
        msgParam.update = {}
      end
      msgParam.update.deletetime = update.deletetime
    end
    if del ~= nil then
      msgParam.del = del
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallQueryPetAdventureListPetCmd(items, times, isend)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.QueryPetAdventureListPetCmd()
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    if times ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.times == nil then
        msg.times = {}
      end
      for i = 1, #times do
        table.insert(msg.times, times[i])
      end
    end
    if isend ~= nil then
      msg.isend = isend
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryPetAdventureListPetCmd.id
    local msgParam = {}
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    if times ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.times == nil then
        msgParam.times = {}
      end
      for i = 1, #times do
        table.insert(msgParam.times, times[i])
      end
    end
    if isend ~= nil then
      msgParam.isend = isend
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallPetAdventureResultNtfPetCmd(item, times)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.PetAdventureResultNtfPetCmd()
    if item ~= nil and item.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.id = item.id
    end
    if item ~= nil and item.starttime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.starttime = item.starttime
    end
    if item ~= nil and item.status ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.status = item.status
    end
    if item ~= nil and item.eggs ~= nil then
      if msg.item == nil then
        msg.item = {}
      end
      if msg.item.eggs == nil then
        msg.item.eggs = {}
      end
      for i = 1, #item.eggs do
        table.insert(msg.item.eggs, item.eggs[i])
      end
    end
    if item ~= nil and item.steps ~= nil then
      if msg.item == nil then
        msg.item = {}
      end
      if msg.item.steps == nil then
        msg.item.steps = {}
      end
      for i = 1, #item.steps do
        table.insert(msg.item.steps, item.steps[i])
      end
    end
    if item ~= nil and item.raresreward ~= nil then
      if msg.item == nil then
        msg.item = {}
      end
      if msg.item.raresreward == nil then
        msg.item.raresreward = {}
      end
      for i = 1, #item.raresreward do
        table.insert(msg.item.raresreward, item.raresreward[i])
      end
    end
    if item ~= nil and item.specid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.specid = item.specid
    end
    if item ~= nil and item.eff ~= nil then
      if msg.item == nil then
        msg.item = {}
      end
      if msg.item.eff == nil then
        msg.item.eff = {}
      end
      for i = 1, #item.eff do
        table.insert(msg.item.eff, item.eff[i])
      end
    end
    if item ~= nil and item.rewardinfo ~= nil then
      if msg.item == nil then
        msg.item = {}
      end
      if msg.item.rewardinfo == nil then
        msg.item.rewardinfo = {}
      end
      for i = 1, #item.rewardinfo do
        table.insert(msg.item.rewardinfo, item.rewardinfo[i])
      end
    end
    if item ~= nil and item.extrarewardinfo ~= nil then
      if msg.item == nil then
        msg.item = {}
      end
      if msg.item.extrarewardinfo == nil then
        msg.item.extrarewardinfo = {}
      end
      for i = 1, #item.extrarewardinfo do
        table.insert(msg.item.extrarewardinfo, item.extrarewardinfo[i])
      end
    end
    if item ~= nil and item.limitstart ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.limitstart = item.limitstart
    end
    if item ~= nil and item.limitend ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.limitend = item.limitend
    end
    if times ~= nil and times.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.times == nil then
        msg.times = {}
      end
      msg.times.id = times.id
    end
    if times ~= nil and times.times ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.times == nil then
        msg.times = {}
      end
      msg.times.times = times.times
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PetAdventureResultNtfPetCmd.id
    local msgParam = {}
    if item ~= nil and item.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.id = item.id
    end
    if item ~= nil and item.starttime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.starttime = item.starttime
    end
    if item ~= nil and item.status ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.status = item.status
    end
    if item ~= nil and item.eggs ~= nil then
      if msgParam.item == nil then
        msgParam.item = {}
      end
      if msgParam.item.eggs == nil then
        msgParam.item.eggs = {}
      end
      for i = 1, #item.eggs do
        table.insert(msgParam.item.eggs, item.eggs[i])
      end
    end
    if item ~= nil and item.steps ~= nil then
      if msgParam.item == nil then
        msgParam.item = {}
      end
      if msgParam.item.steps == nil then
        msgParam.item.steps = {}
      end
      for i = 1, #item.steps do
        table.insert(msgParam.item.steps, item.steps[i])
      end
    end
    if item ~= nil and item.raresreward ~= nil then
      if msgParam.item == nil then
        msgParam.item = {}
      end
      if msgParam.item.raresreward == nil then
        msgParam.item.raresreward = {}
      end
      for i = 1, #item.raresreward do
        table.insert(msgParam.item.raresreward, item.raresreward[i])
      end
    end
    if item ~= nil and item.specid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.specid = item.specid
    end
    if item ~= nil and item.eff ~= nil then
      if msgParam.item == nil then
        msgParam.item = {}
      end
      if msgParam.item.eff == nil then
        msgParam.item.eff = {}
      end
      for i = 1, #item.eff do
        table.insert(msgParam.item.eff, item.eff[i])
      end
    end
    if item ~= nil and item.rewardinfo ~= nil then
      if msgParam.item == nil then
        msgParam.item = {}
      end
      if msgParam.item.rewardinfo == nil then
        msgParam.item.rewardinfo = {}
      end
      for i = 1, #item.rewardinfo do
        table.insert(msgParam.item.rewardinfo, item.rewardinfo[i])
      end
    end
    if item ~= nil and item.extrarewardinfo ~= nil then
      if msgParam.item == nil then
        msgParam.item = {}
      end
      if msgParam.item.extrarewardinfo == nil then
        msgParam.item.extrarewardinfo = {}
      end
      for i = 1, #item.extrarewardinfo do
        table.insert(msgParam.item.extrarewardinfo, item.extrarewardinfo[i])
      end
    end
    if item ~= nil and item.limitstart ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.limitstart = item.limitstart
    end
    if item ~= nil and item.limitend ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.limitend = item.limitend
    end
    if times ~= nil and times.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.times == nil then
        msgParam.times = {}
      end
      msgParam.times.id = times.id
    end
    if times ~= nil and times.times ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.times == nil then
        msgParam.times = {}
      end
      msgParam.times.times = times.times
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallStartAdventurePetCmd(id, petids, specid, useticket)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.StartAdventurePetCmd()
    if id ~= nil then
      msg.id = id
    end
    if petids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.petids == nil then
        msg.petids = {}
      end
      for i = 1, #petids do
        table.insert(msg.petids, petids[i])
      end
    end
    if specid ~= nil then
      msg.specid = specid
    end
    if useticket ~= nil then
      msg.useticket = useticket
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.StartAdventurePetCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if petids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.petids == nil then
        msgParam.petids = {}
      end
      for i = 1, #petids do
        table.insert(msgParam.petids, petids[i])
      end
    end
    if specid ~= nil then
      msgParam.specid = specid
    end
    if useticket ~= nil then
      msgParam.useticket = useticket
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallGetAdventureRewardPetCmd(id)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.GetAdventureRewardPetCmd()
    if id ~= nil then
      msg.id = id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GetAdventureRewardPetCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallQueryBattlePetCmd(pets)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.QueryBattlePetCmd()
    if pets ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.pets == nil then
        msg.pets = {}
      end
      for i = 1, #pets do
        table.insert(msg.pets, pets[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryBattlePetCmd.id
    local msgParam = {}
    if pets ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.pets == nil then
        msgParam.pets = {}
      end
      for i = 1, #pets do
        table.insert(msgParam.pets, pets[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallHandPetPetCmd(petguid, breakup)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.HandPetPetCmd()
    if msg == nil then
      msg = {}
    end
    msg.petguid = petguid
    if breakup ~= nil then
      msg.breakup = breakup
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HandPetPetCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.petguid = petguid
    if breakup ~= nil then
      msgParam.breakup = breakup
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallGiveGiftPetCmd(petid, itemguid)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.GiveGiftPetCmd()
    if msg == nil then
      msg = {}
    end
    msg.petid = petid
    if itemguid ~= nil then
      msg.itemguid = itemguid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GiveGiftPetCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.petid = petid
    if itemguid ~= nil then
      msgParam.itemguid = itemguid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallUnlockNtfPetCmd(petid, equipids, bodys)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.UnlockNtfPetCmd()
    if petid ~= nil then
      msg.petid = petid
    end
    if equipids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.equipids == nil then
        msg.equipids = {}
      end
      for i = 1, #equipids do
        table.insert(msg.equipids, equipids[i])
      end
    end
    if bodys ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.bodys == nil then
        msg.bodys = {}
      end
      for i = 1, #bodys do
        table.insert(msg.bodys, bodys[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UnlockNtfPetCmd.id
    local msgParam = {}
    if petid ~= nil then
      msgParam.petid = petid
    end
    if equipids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.equipids == nil then
        msgParam.equipids = {}
      end
      for i = 1, #equipids do
        table.insert(msgParam.equipids, equipids[i])
      end
    end
    if bodys ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.bodys == nil then
        msgParam.bodys = {}
      end
      for i = 1, #bodys do
        table.insert(msgParam.bodys, bodys[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallResetSkillPetCmd(id)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.ResetSkillPetCmd()
    if id ~= nil then
      msg.id = id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ResetSkillPetCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallChangeNamePetCmd(petid, name)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.ChangeNamePetCmd()
    if petid ~= nil then
      msg.petid = petid
    end
    if name ~= nil then
      msg.name = name
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ChangeNamePetCmd.id
    local msgParam = {}
    if petid ~= nil then
      msgParam.petid = petid
    end
    if name ~= nil then
      msgParam.name = name
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallSwitchSkillPetCmd(petid, open)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.SwitchSkillPetCmd()
    if petid ~= nil then
      msg.petid = petid
    end
    if open ~= nil then
      msg.open = open
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SwitchSkillPetCmd.id
    local msgParam = {}
    if petid ~= nil then
      msgParam.petid = petid
    end
    if open ~= nil then
      msgParam.open = open
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallStartWorkPetCmd(id, pets, type)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.StartWorkPetCmd()
    if id ~= nil then
      msg.id = id
    end
    if pets ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.pets == nil then
        msg.pets = {}
      end
      for i = 1, #pets do
        table.insert(msg.pets, pets[i])
      end
    end
    if type ~= nil then
      msg.type = type
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.StartWorkPetCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if pets ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.pets == nil then
        msgParam.pets = {}
      end
      for i = 1, #pets do
        table.insert(msgParam.pets, pets[i])
      end
    end
    if type ~= nil then
      msgParam.type = type
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallStopWorkPetCmd(id)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.StopWorkPetCmd()
    if id ~= nil then
      msg.id = id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.StopWorkPetCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallQueryPetWorkDataPetCmd(datas, extras, max_space, card_expiretime)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.QueryPetWorkDataPetCmd()
    if datas ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.datas == nil then
        msg.datas = {}
      end
      for i = 1, #datas do
        table.insert(msg.datas, datas[i])
      end
    end
    if extras ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.extras == nil then
        msg.extras = {}
      end
      for i = 1, #extras do
        table.insert(msg.extras, extras[i])
      end
    end
    if max_space ~= nil then
      msg.max_space = max_space
    end
    if card_expiretime ~= nil then
      msg.card_expiretime = card_expiretime
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryPetWorkDataPetCmd.id
    local msgParam = {}
    if datas ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.datas == nil then
        msgParam.datas = {}
      end
      for i = 1, #datas do
        table.insert(msgParam.datas, datas[i])
      end
    end
    if extras ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.extras == nil then
        msgParam.extras = {}
      end
      for i = 1, #extras do
        table.insert(msgParam.extras, extras[i])
      end
    end
    if max_space ~= nil then
      msgParam.max_space = max_space
    end
    if card_expiretime ~= nil then
      msgParam.card_expiretime = card_expiretime
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallGetPetWorkRewardPetCmd(id)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.GetPetWorkRewardPetCmd()
    if id ~= nil then
      msg.id = id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GetPetWorkRewardPetCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallWorkSpaceUpdate(updates)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.WorkSpaceUpdate()
    if updates ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.updates == nil then
        msg.updates = {}
      end
      for i = 1, #updates do
        table.insert(msg.updates, updates[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.WorkSpaceUpdate.id
    local msgParam = {}
    if updates ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.updates == nil then
        msgParam.updates = {}
      end
      for i = 1, #updates do
        table.insert(msgParam.updates, updates[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallWorkSpaceDataUpdatePetCmd(spaceid, datas)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.WorkSpaceDataUpdatePetCmd()
    if spaceid ~= nil then
      msg.spaceid = spaceid
    end
    if datas ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.datas == nil then
        msg.datas = {}
      end
      for i = 1, #datas do
        table.insert(msg.datas, datas[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.WorkSpaceDataUpdatePetCmd.id
    local msgParam = {}
    if spaceid ~= nil then
      msgParam.spaceid = spaceid
    end
    if datas ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.datas == nil then
        msgParam.datas = {}
      end
      for i = 1, #datas do
        table.insert(msgParam.datas, datas[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallPetExtraUpdatePetCmd(updates)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.PetExtraUpdatePetCmd()
    if updates ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.updates == nil then
        msg.updates = {}
      end
      for i = 1, #updates do
        table.insert(msg.updates, updates[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PetExtraUpdatePetCmd.id
    local msgParam = {}
    if updates ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.updates == nil then
        msgParam.updates = {}
      end
      for i = 1, #updates do
        table.insert(msgParam.updates, updates[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallComposePetCmd(id, eggguids)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.ComposePetCmd()
    if msg == nil then
      msg = {}
    end
    msg.id = id
    if eggguids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.eggguids == nil then
        msg.eggguids = {}
      end
      for i = 1, #eggguids do
        table.insert(msg.eggguids, eggguids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ComposePetCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.id = id
    if eggguids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.eggguids == nil then
        msgParam.eggguids = {}
      end
      for i = 1, #eggguids do
        table.insert(msgParam.eggguids, eggguids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallPetEquipListCmd(unlockinfo)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.PetEquipListCmd()
    if unlockinfo ~= nil and unlockinfo.items ~= nil then
      if msg.unlockinfo == nil then
        msg.unlockinfo = {}
      end
      if msg.unlockinfo.items == nil then
        msg.unlockinfo.items = {}
      end
      for i = 1, #unlockinfo.items do
        table.insert(msg.unlockinfo.items, unlockinfo.items[i])
      end
    end
    if unlockinfo ~= nil and unlockinfo.bodyitems ~= nil then
      if msg.unlockinfo == nil then
        msg.unlockinfo = {}
      end
      if msg.unlockinfo.bodyitems == nil then
        msg.unlockinfo.bodyitems = {}
      end
      for i = 1, #unlockinfo.bodyitems do
        table.insert(msg.unlockinfo.bodyitems, unlockinfo.bodyitems[i])
      end
    end
    if unlockinfo ~= nil and unlockinfo.version ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.unlockinfo == nil then
        msg.unlockinfo = {}
      end
      msg.unlockinfo.version = unlockinfo.version
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PetEquipListCmd.id
    local msgParam = {}
    if unlockinfo ~= nil and unlockinfo.items ~= nil then
      if msgParam.unlockinfo == nil then
        msgParam.unlockinfo = {}
      end
      if msgParam.unlockinfo.items == nil then
        msgParam.unlockinfo.items = {}
      end
      for i = 1, #unlockinfo.items do
        table.insert(msgParam.unlockinfo.items, unlockinfo.items[i])
      end
    end
    if unlockinfo ~= nil and unlockinfo.bodyitems ~= nil then
      if msgParam.unlockinfo == nil then
        msgParam.unlockinfo = {}
      end
      if msgParam.unlockinfo.bodyitems == nil then
        msgParam.unlockinfo.bodyitems = {}
      end
      for i = 1, #unlockinfo.bodyitems do
        table.insert(msgParam.unlockinfo.bodyitems, unlockinfo.bodyitems[i])
      end
    end
    if unlockinfo ~= nil and unlockinfo.version ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.unlockinfo == nil then
        msgParam.unlockinfo = {}
      end
      msgParam.unlockinfo.version = unlockinfo.version
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallUpdatePetEquipListCmd(additems, addbodyitems)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.UpdatePetEquipListCmd()
    if additems ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.additems == nil then
        msg.additems = {}
      end
      for i = 1, #additems do
        table.insert(msg.additems, additems[i])
      end
    end
    if addbodyitems ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.addbodyitems == nil then
        msg.addbodyitems = {}
      end
      for i = 1, #addbodyitems do
        table.insert(msg.addbodyitems, addbodyitems[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdatePetEquipListCmd.id
    local msgParam = {}
    if additems ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.additems == nil then
        msgParam.additems = {}
      end
      for i = 1, #additems do
        table.insert(msgParam.additems, additems[i])
      end
    end
    if addbodyitems ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.addbodyitems == nil then
        msgParam.addbodyitems = {}
      end
      for i = 1, #addbodyitems do
        table.insert(msgParam.addbodyitems, addbodyitems[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallChangeWearPetCmd(petid, wearinfo)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.ChangeWearPetCmd()
    if msg == nil then
      msg = {}
    end
    msg.petid = petid
    if wearinfo ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.wearinfo == nil then
        msg.wearinfo = {}
      end
      for i = 1, #wearinfo do
        table.insert(msg.wearinfo, wearinfo[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ChangeWearPetCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.petid = petid
    if wearinfo ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.wearinfo == nil then
        msgParam.wearinfo = {}
      end
      for i = 1, #wearinfo do
        table.insert(msgParam.wearinfo, wearinfo[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallUpdateWearPetCmd(petid, wearinfo)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.UpdateWearPetCmd()
    if msg == nil then
      msg = {}
    end
    msg.petid = petid
    if wearinfo ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.wearinfo == nil then
        msg.wearinfo = {}
      end
      for i = 1, #wearinfo do
        table.insert(msg.wearinfo, wearinfo[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateWearPetCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.petid = petid
    if wearinfo ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.wearinfo == nil then
        msgParam.wearinfo = {}
      end
      for i = 1, #wearinfo do
        table.insert(msgParam.wearinfo, wearinfo[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallReplaceCatPetCmd(oldcatid, newcatid)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.ReplaceCatPetCmd()
    if oldcatid ~= nil then
      msg.oldcatid = oldcatid
    end
    if newcatid ~= nil then
      msg.newcatid = newcatid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReplaceCatPetCmd.id
    local msgParam = {}
    if oldcatid ~= nil then
      msgParam.oldcatid = oldcatid
    end
    if newcatid ~= nil then
      msgParam.newcatid = newcatid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallWorkSpaceMaxCountUpdatePetCmd(max_count)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.WorkSpaceMaxCountUpdatePetCmd()
    if max_count ~= nil then
      msg.max_count = max_count
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.WorkSpaceMaxCountUpdatePetCmd.id
    local msgParam = {}
    if max_count ~= nil then
      msgParam.max_count = max_count
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallCatEquipPetCmd(catid, oper, pos, equipid)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.CatEquipPetCmd()
    if catid ~= nil then
      msg.catid = catid
    end
    if oper ~= nil then
      msg.oper = oper
    end
    if pos ~= nil then
      msg.pos = pos
    end
    if equipid ~= nil then
      msg.equipid = equipid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CatEquipPetCmd.id
    local msgParam = {}
    if catid ~= nil then
      msgParam.catid = catid
    end
    if oper ~= nil then
      msgParam.oper = oper
    end
    if pos ~= nil then
      msgParam.pos = pos
    end
    if equipid ~= nil then
      msgParam.equipid = equipid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallCatEquipInfoPetCmd(lv, infos, update)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.CatEquipInfoPetCmd()
    if lv ~= nil then
      msg.lv = lv
    end
    if infos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.infos == nil then
        msg.infos = {}
      end
      for i = 1, #infos do
        table.insert(msg.infos, infos[i])
      end
    end
    if update ~= nil then
      msg.update = update
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CatEquipInfoPetCmd.id
    local msgParam = {}
    if lv ~= nil then
      msgParam.lv = lv
    end
    if infos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.infos == nil then
        msgParam.infos = {}
      end
      for i = 1, #infos do
        table.insert(msgParam.infos, infos[i])
      end
    end
    if update ~= nil then
      msgParam.update = update
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallCatSkillOptionPetCmd(skillid, select, selectskill)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.CatSkillOptionPetCmd()
    if skillid ~= nil then
      msg.skillid = skillid
    end
    if select ~= nil then
      msg.select = select
    end
    if selectskill ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.selectskill == nil then
        msg.selectskill = {}
      end
      for i = 1, #selectskill do
        table.insert(msg.selectskill, selectskill[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CatSkillOptionPetCmd.id
    local msgParam = {}
    if skillid ~= nil then
      msgParam.skillid = skillid
    end
    if select ~= nil then
      msgParam.select = select
    end
    if selectskill ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.selectskill == nil then
        msgParam.selectskill = {}
      end
      for i = 1, #selectskill do
        table.insert(msgParam.selectskill, selectskill[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallBoKiStateQueryPetCmd(state)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.BoKiStateQueryPetCmd()
    if state ~= nil and state.exp ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.state == nil then
        msg.state = {}
      end
      msg.state.exp = state.exp
    end
    if state ~= nil and state.level ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.state == nil then
        msg.state = {}
      end
      msg.state.level = state.level
    end
    if state ~= nil and state.stage ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.state == nil then
        msg.state = {}
      end
      msg.state.stage = state.stage
    end
    if state ~= nil and state.equips ~= nil then
      if msg.state == nil then
        msg.state = {}
      end
      if msg.state.equips == nil then
        msg.state.equips = {}
      end
      for i = 1, #state.equips do
        table.insert(msg.state.equips, state.equips[i])
      end
    end
    if state ~= nil and state.skills ~= nil then
      if msg.state == nil then
        msg.state = {}
      end
      if msg.state.skills == nil then
        msg.state.skills = {}
      end
      for i = 1, #state.skills do
        table.insert(msg.state.skills, state.skills[i])
      end
    end
    if state ~= nil and state.skill_in_use ~= nil then
      if msg.state == nil then
        msg.state = {}
      end
      if msg.state.skill_in_use == nil then
        msg.state.skill_in_use = {}
      end
      for i = 1, #state.skill_in_use do
        table.insert(msg.state.skill_in_use, state.skill_in_use[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BoKiStateQueryPetCmd.id
    local msgParam = {}
    if state ~= nil and state.exp ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.state == nil then
        msgParam.state = {}
      end
      msgParam.state.exp = state.exp
    end
    if state ~= nil and state.level ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.state == nil then
        msgParam.state = {}
      end
      msgParam.state.level = state.level
    end
    if state ~= nil and state.stage ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.state == nil then
        msgParam.state = {}
      end
      msgParam.state.stage = state.stage
    end
    if state ~= nil and state.equips ~= nil then
      if msgParam.state == nil then
        msgParam.state = {}
      end
      if msgParam.state.equips == nil then
        msgParam.state.equips = {}
      end
      for i = 1, #state.equips do
        table.insert(msgParam.state.equips, state.equips[i])
      end
    end
    if state ~= nil and state.skills ~= nil then
      if msgParam.state == nil then
        msgParam.state = {}
      end
      if msgParam.state.skills == nil then
        msgParam.state.skills = {}
      end
      for i = 1, #state.skills do
        table.insert(msgParam.state.skills, state.skills[i])
      end
    end
    if state ~= nil and state.skill_in_use ~= nil then
      if msgParam.state == nil then
        msgParam.state = {}
      end
      if msgParam.state.skill_in_use == nil then
        msgParam.state.skill_in_use = {}
      end
      for i = 1, #state.skill_in_use do
        table.insert(msgParam.state.skill_in_use, state.skill_in_use[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallBoKiDataUpdatePetCmd(datas)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.BoKiDataUpdatePetCmd()
    if datas ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.datas == nil then
        msg.datas = {}
      end
      for i = 1, #datas do
        table.insert(msg.datas, datas[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BoKiDataUpdatePetCmd.id
    local msgParam = {}
    if datas ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.datas == nil then
        msgParam.datas = {}
      end
      for i = 1, #datas do
        table.insert(msgParam.datas, datas[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallBoKiEquipLevelUpPetCmd(pos)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.BoKiEquipLevelUpPetCmd()
    if pos ~= nil then
      msg.pos = pos
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BoKiEquipLevelUpPetCmd.id
    local msgParam = {}
    if pos ~= nil then
      msgParam.pos = pos
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallBoKiEquipUpdatePetCmd(equips)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.BoKiEquipUpdatePetCmd()
    if equips ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.equips == nil then
        msg.equips = {}
      end
      for i = 1, #equips do
        table.insert(msg.equips, equips[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BoKiEquipUpdatePetCmd.id
    local msgParam = {}
    if equips ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.equips == nil then
        msgParam.equips = {}
      end
      for i = 1, #equips do
        table.insert(msgParam.equips, equips[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallBoKiSkillLevelUpPetCmd(skills)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.BoKiSkillLevelUpPetCmd()
    if skills ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.skills == nil then
        msg.skills = {}
      end
      for i = 1, #skills do
        table.insert(msg.skills, skills[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BoKiSkillLevelUpPetCmd.id
    local msgParam = {}
    if skills ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.skills == nil then
        msgParam.skills = {}
      end
      for i = 1, #skills do
        table.insert(msgParam.skills, skills[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallBoKiSkillUpdatePetCmd(skills)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.BoKiSkillUpdatePetCmd()
    if skills ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.skills == nil then
        msg.skills = {}
      end
      for i = 1, #skills do
        table.insert(msg.skills, skills[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BoKiSkillUpdatePetCmd.id
    local msgParam = {}
    if skills ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.skills == nil then
        msgParam.skills = {}
      end
      for i = 1, #skills do
        table.insert(msgParam.skills, skills[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallBoKiSkillInUseUpdatePetCmd(skills)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.BoKiSkillInUseUpdatePetCmd()
    if skills ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.skills == nil then
        msg.skills = {}
      end
      for i = 1, #skills do
        table.insert(msg.skills, skills[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BoKiSkillInUseUpdatePetCmd.id
    local msgParam = {}
    if skills ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.skills == nil then
        msgParam.skills = {}
      end
      for i = 1, #skills do
        table.insert(msgParam.skills, skills[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallBoKiSkillInUseSetPetCmd(skill)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.BoKiSkillInUseSetPetCmd()
    if skill ~= nil and skill.pos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.skill == nil then
        msg.skill = {}
      end
      msg.skill.pos = skill.pos
    end
    if skill ~= nil and skill.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.skill == nil then
        msg.skill = {}
      end
      msg.skill.id = skill.id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BoKiSkillInUseSetPetCmd.id
    local msgParam = {}
    if skill ~= nil and skill.pos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.skill == nil then
        msgParam.skill = {}
      end
      msgParam.skill.pos = skill.pos
    end
    if skill ~= nil and skill.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.skill == nil then
        msgParam.skill = {}
      end
      msgParam.skill.id = skill.id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:CallSevenRoyalsFollowNpc(npcids, create)
  if not NetConfig.PBC then
    local msg = ScenePet_pb.SevenRoyalsFollowNpc()
    if npcids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.npcids == nil then
        msg.npcids = {}
      end
      for i = 1, #npcids do
        table.insert(msg.npcids, npcids[i])
      end
    end
    if create ~= nil then
      msg.create = create
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SevenRoyalsFollowNpc.id
    local msgParam = {}
    if npcids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.npcids == nil then
        msgParam.npcids = {}
      end
      for i = 1, #npcids do
        table.insert(msgParam.npcids, npcids[i])
      end
    end
    if create ~= nil then
      msgParam.create = create
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceScenePetAutoProxy:RecvPetList(data)
  self:Notify(ServiceEvent.ScenePetPetList, data)
end

function ServiceScenePetAutoProxy:RecvFireCatPetCmd(data)
  self:Notify(ServiceEvent.ScenePetFireCatPetCmd, data)
end

function ServiceScenePetAutoProxy:RecvHireCatPetCmd(data)
  self:Notify(ServiceEvent.ScenePetHireCatPetCmd, data)
end

function ServiceScenePetAutoProxy:RecvEggHatchPetCmd(data)
  self:Notify(ServiceEvent.ScenePetEggHatchPetCmd, data)
end

function ServiceScenePetAutoProxy:RecvEggRestorePetCmd(data)
  self:Notify(ServiceEvent.ScenePetEggRestorePetCmd, data)
end

function ServiceScenePetAutoProxy:RecvCatchValuePetCmd(data)
  self:Notify(ServiceEvent.ScenePetCatchValuePetCmd, data)
end

function ServiceScenePetAutoProxy:RecvCatchResultPetCmd(data)
  self:Notify(ServiceEvent.ScenePetCatchResultPetCmd, data)
end

function ServiceScenePetAutoProxy:RecvCatchPetPetCmd(data)
  self:Notify(ServiceEvent.ScenePetCatchPetPetCmd, data)
end

function ServiceScenePetAutoProxy:RecvCatchPetGiftPetCmd(data)
  self:Notify(ServiceEvent.ScenePetCatchPetGiftPetCmd, data)
end

function ServiceScenePetAutoProxy:RecvPetInfoPetCmd(data)
  self:Notify(ServiceEvent.ScenePetPetInfoPetCmd, data)
end

function ServiceScenePetAutoProxy:RecvPetInfoUpdatePetCmd(data)
  self:Notify(ServiceEvent.ScenePetPetInfoUpdatePetCmd, data)
end

function ServiceScenePetAutoProxy:RecvPetOffPetCmd(data)
  self:Notify(ServiceEvent.ScenePetPetOffPetCmd, data)
end

function ServiceScenePetAutoProxy:RecvGetGiftPetCmd(data)
  self:Notify(ServiceEvent.ScenePetGetGiftPetCmd, data)
end

function ServiceScenePetAutoProxy:RecvEquipOperPetCmd(data)
  self:Notify(ServiceEvent.ScenePetEquipOperPetCmd, data)
end

function ServiceScenePetAutoProxy:RecvEquipUpdatePetCmd(data)
  self:Notify(ServiceEvent.ScenePetEquipUpdatePetCmd, data)
end

function ServiceScenePetAutoProxy:RecvQueryPetAdventureListPetCmd(data)
  self:Notify(ServiceEvent.ScenePetQueryPetAdventureListPetCmd, data)
end

function ServiceScenePetAutoProxy:RecvPetAdventureResultNtfPetCmd(data)
  self:Notify(ServiceEvent.ScenePetPetAdventureResultNtfPetCmd, data)
end

function ServiceScenePetAutoProxy:RecvStartAdventurePetCmd(data)
  self:Notify(ServiceEvent.ScenePetStartAdventurePetCmd, data)
end

function ServiceScenePetAutoProxy:RecvGetAdventureRewardPetCmd(data)
  self:Notify(ServiceEvent.ScenePetGetAdventureRewardPetCmd, data)
end

function ServiceScenePetAutoProxy:RecvQueryBattlePetCmd(data)
  self:Notify(ServiceEvent.ScenePetQueryBattlePetCmd, data)
end

function ServiceScenePetAutoProxy:RecvHandPetPetCmd(data)
  self:Notify(ServiceEvent.ScenePetHandPetPetCmd, data)
end

function ServiceScenePetAutoProxy:RecvGiveGiftPetCmd(data)
  self:Notify(ServiceEvent.ScenePetGiveGiftPetCmd, data)
end

function ServiceScenePetAutoProxy:RecvUnlockNtfPetCmd(data)
  self:Notify(ServiceEvent.ScenePetUnlockNtfPetCmd, data)
end

function ServiceScenePetAutoProxy:RecvResetSkillPetCmd(data)
  self:Notify(ServiceEvent.ScenePetResetSkillPetCmd, data)
end

function ServiceScenePetAutoProxy:RecvChangeNamePetCmd(data)
  self:Notify(ServiceEvent.ScenePetChangeNamePetCmd, data)
end

function ServiceScenePetAutoProxy:RecvSwitchSkillPetCmd(data)
  self:Notify(ServiceEvent.ScenePetSwitchSkillPetCmd, data)
end

function ServiceScenePetAutoProxy:RecvStartWorkPetCmd(data)
  self:Notify(ServiceEvent.ScenePetStartWorkPetCmd, data)
end

function ServiceScenePetAutoProxy:RecvStopWorkPetCmd(data)
  self:Notify(ServiceEvent.ScenePetStopWorkPetCmd, data)
end

function ServiceScenePetAutoProxy:RecvQueryPetWorkDataPetCmd(data)
  self:Notify(ServiceEvent.ScenePetQueryPetWorkDataPetCmd, data)
end

function ServiceScenePetAutoProxy:RecvGetPetWorkRewardPetCmd(data)
  self:Notify(ServiceEvent.ScenePetGetPetWorkRewardPetCmd, data)
end

function ServiceScenePetAutoProxy:RecvWorkSpaceUpdate(data)
  self:Notify(ServiceEvent.ScenePetWorkSpaceUpdate, data)
end

function ServiceScenePetAutoProxy:RecvWorkSpaceDataUpdatePetCmd(data)
  self:Notify(ServiceEvent.ScenePetWorkSpaceDataUpdatePetCmd, data)
end

function ServiceScenePetAutoProxy:RecvPetExtraUpdatePetCmd(data)
  self:Notify(ServiceEvent.ScenePetPetExtraUpdatePetCmd, data)
end

function ServiceScenePetAutoProxy:RecvComposePetCmd(data)
  self:Notify(ServiceEvent.ScenePetComposePetCmd, data)
end

function ServiceScenePetAutoProxy:RecvPetEquipListCmd(data)
  self:Notify(ServiceEvent.ScenePetPetEquipListCmd, data)
end

function ServiceScenePetAutoProxy:RecvUpdatePetEquipListCmd(data)
  self:Notify(ServiceEvent.ScenePetUpdatePetEquipListCmd, data)
end

function ServiceScenePetAutoProxy:RecvChangeWearPetCmd(data)
  self:Notify(ServiceEvent.ScenePetChangeWearPetCmd, data)
end

function ServiceScenePetAutoProxy:RecvUpdateWearPetCmd(data)
  self:Notify(ServiceEvent.ScenePetUpdateWearPetCmd, data)
end

function ServiceScenePetAutoProxy:RecvReplaceCatPetCmd(data)
  self:Notify(ServiceEvent.ScenePetReplaceCatPetCmd, data)
end

function ServiceScenePetAutoProxy:RecvWorkSpaceMaxCountUpdatePetCmd(data)
  self:Notify(ServiceEvent.ScenePetWorkSpaceMaxCountUpdatePetCmd, data)
end

function ServiceScenePetAutoProxy:RecvCatEquipPetCmd(data)
  self:Notify(ServiceEvent.ScenePetCatEquipPetCmd, data)
end

function ServiceScenePetAutoProxy:RecvCatEquipInfoPetCmd(data)
  self:Notify(ServiceEvent.ScenePetCatEquipInfoPetCmd, data)
end

function ServiceScenePetAutoProxy:RecvCatSkillOptionPetCmd(data)
  self:Notify(ServiceEvent.ScenePetCatSkillOptionPetCmd, data)
end

function ServiceScenePetAutoProxy:RecvBoKiStateQueryPetCmd(data)
  self:Notify(ServiceEvent.ScenePetBoKiStateQueryPetCmd, data)
end

function ServiceScenePetAutoProxy:RecvBoKiDataUpdatePetCmd(data)
  self:Notify(ServiceEvent.ScenePetBoKiDataUpdatePetCmd, data)
end

function ServiceScenePetAutoProxy:RecvBoKiEquipLevelUpPetCmd(data)
  self:Notify(ServiceEvent.ScenePetBoKiEquipLevelUpPetCmd, data)
end

function ServiceScenePetAutoProxy:RecvBoKiEquipUpdatePetCmd(data)
  self:Notify(ServiceEvent.ScenePetBoKiEquipUpdatePetCmd, data)
end

function ServiceScenePetAutoProxy:RecvBoKiSkillLevelUpPetCmd(data)
  self:Notify(ServiceEvent.ScenePetBoKiSkillLevelUpPetCmd, data)
end

function ServiceScenePetAutoProxy:RecvBoKiSkillUpdatePetCmd(data)
  self:Notify(ServiceEvent.ScenePetBoKiSkillUpdatePetCmd, data)
end

function ServiceScenePetAutoProxy:RecvBoKiSkillInUseUpdatePetCmd(data)
  self:Notify(ServiceEvent.ScenePetBoKiSkillInUseUpdatePetCmd, data)
end

function ServiceScenePetAutoProxy:RecvBoKiSkillInUseSetPetCmd(data)
  self:Notify(ServiceEvent.ScenePetBoKiSkillInUseSetPetCmd, data)
end

function ServiceScenePetAutoProxy:RecvSevenRoyalsFollowNpc(data)
  self:Notify(ServiceEvent.ScenePetSevenRoyalsFollowNpc, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.ScenePetPetList = "ServiceEvent_ScenePetPetList"
ServiceEvent.ScenePetFireCatPetCmd = "ServiceEvent_ScenePetFireCatPetCmd"
ServiceEvent.ScenePetHireCatPetCmd = "ServiceEvent_ScenePetHireCatPetCmd"
ServiceEvent.ScenePetEggHatchPetCmd = "ServiceEvent_ScenePetEggHatchPetCmd"
ServiceEvent.ScenePetEggRestorePetCmd = "ServiceEvent_ScenePetEggRestorePetCmd"
ServiceEvent.ScenePetCatchValuePetCmd = "ServiceEvent_ScenePetCatchValuePetCmd"
ServiceEvent.ScenePetCatchResultPetCmd = "ServiceEvent_ScenePetCatchResultPetCmd"
ServiceEvent.ScenePetCatchPetPetCmd = "ServiceEvent_ScenePetCatchPetPetCmd"
ServiceEvent.ScenePetCatchPetGiftPetCmd = "ServiceEvent_ScenePetCatchPetGiftPetCmd"
ServiceEvent.ScenePetPetInfoPetCmd = "ServiceEvent_ScenePetPetInfoPetCmd"
ServiceEvent.ScenePetPetInfoUpdatePetCmd = "ServiceEvent_ScenePetPetInfoUpdatePetCmd"
ServiceEvent.ScenePetPetOffPetCmd = "ServiceEvent_ScenePetPetOffPetCmd"
ServiceEvent.ScenePetGetGiftPetCmd = "ServiceEvent_ScenePetGetGiftPetCmd"
ServiceEvent.ScenePetEquipOperPetCmd = "ServiceEvent_ScenePetEquipOperPetCmd"
ServiceEvent.ScenePetEquipUpdatePetCmd = "ServiceEvent_ScenePetEquipUpdatePetCmd"
ServiceEvent.ScenePetQueryPetAdventureListPetCmd = "ServiceEvent_ScenePetQueryPetAdventureListPetCmd"
ServiceEvent.ScenePetPetAdventureResultNtfPetCmd = "ServiceEvent_ScenePetPetAdventureResultNtfPetCmd"
ServiceEvent.ScenePetStartAdventurePetCmd = "ServiceEvent_ScenePetStartAdventurePetCmd"
ServiceEvent.ScenePetGetAdventureRewardPetCmd = "ServiceEvent_ScenePetGetAdventureRewardPetCmd"
ServiceEvent.ScenePetQueryBattlePetCmd = "ServiceEvent_ScenePetQueryBattlePetCmd"
ServiceEvent.ScenePetHandPetPetCmd = "ServiceEvent_ScenePetHandPetPetCmd"
ServiceEvent.ScenePetGiveGiftPetCmd = "ServiceEvent_ScenePetGiveGiftPetCmd"
ServiceEvent.ScenePetUnlockNtfPetCmd = "ServiceEvent_ScenePetUnlockNtfPetCmd"
ServiceEvent.ScenePetResetSkillPetCmd = "ServiceEvent_ScenePetResetSkillPetCmd"
ServiceEvent.ScenePetChangeNamePetCmd = "ServiceEvent_ScenePetChangeNamePetCmd"
ServiceEvent.ScenePetSwitchSkillPetCmd = "ServiceEvent_ScenePetSwitchSkillPetCmd"
ServiceEvent.ScenePetStartWorkPetCmd = "ServiceEvent_ScenePetStartWorkPetCmd"
ServiceEvent.ScenePetStopWorkPetCmd = "ServiceEvent_ScenePetStopWorkPetCmd"
ServiceEvent.ScenePetQueryPetWorkDataPetCmd = "ServiceEvent_ScenePetQueryPetWorkDataPetCmd"
ServiceEvent.ScenePetGetPetWorkRewardPetCmd = "ServiceEvent_ScenePetGetPetWorkRewardPetCmd"
ServiceEvent.ScenePetWorkSpaceUpdate = "ServiceEvent_ScenePetWorkSpaceUpdate"
ServiceEvent.ScenePetWorkSpaceDataUpdatePetCmd = "ServiceEvent_ScenePetWorkSpaceDataUpdatePetCmd"
ServiceEvent.ScenePetPetExtraUpdatePetCmd = "ServiceEvent_ScenePetPetExtraUpdatePetCmd"
ServiceEvent.ScenePetComposePetCmd = "ServiceEvent_ScenePetComposePetCmd"
ServiceEvent.ScenePetPetEquipListCmd = "ServiceEvent_ScenePetPetEquipListCmd"
ServiceEvent.ScenePetUpdatePetEquipListCmd = "ServiceEvent_ScenePetUpdatePetEquipListCmd"
ServiceEvent.ScenePetChangeWearPetCmd = "ServiceEvent_ScenePetChangeWearPetCmd"
ServiceEvent.ScenePetUpdateWearPetCmd = "ServiceEvent_ScenePetUpdateWearPetCmd"
ServiceEvent.ScenePetReplaceCatPetCmd = "ServiceEvent_ScenePetReplaceCatPetCmd"
ServiceEvent.ScenePetWorkSpaceMaxCountUpdatePetCmd = "ServiceEvent_ScenePetWorkSpaceMaxCountUpdatePetCmd"
ServiceEvent.ScenePetCatEquipPetCmd = "ServiceEvent_ScenePetCatEquipPetCmd"
ServiceEvent.ScenePetCatEquipInfoPetCmd = "ServiceEvent_ScenePetCatEquipInfoPetCmd"
ServiceEvent.ScenePetCatSkillOptionPetCmd = "ServiceEvent_ScenePetCatSkillOptionPetCmd"
ServiceEvent.ScenePetBoKiStateQueryPetCmd = "ServiceEvent_ScenePetBoKiStateQueryPetCmd"
ServiceEvent.ScenePetBoKiDataUpdatePetCmd = "ServiceEvent_ScenePetBoKiDataUpdatePetCmd"
ServiceEvent.ScenePetBoKiEquipLevelUpPetCmd = "ServiceEvent_ScenePetBoKiEquipLevelUpPetCmd"
ServiceEvent.ScenePetBoKiEquipUpdatePetCmd = "ServiceEvent_ScenePetBoKiEquipUpdatePetCmd"
ServiceEvent.ScenePetBoKiSkillLevelUpPetCmd = "ServiceEvent_ScenePetBoKiSkillLevelUpPetCmd"
ServiceEvent.ScenePetBoKiSkillUpdatePetCmd = "ServiceEvent_ScenePetBoKiSkillUpdatePetCmd"
ServiceEvent.ScenePetBoKiSkillInUseUpdatePetCmd = "ServiceEvent_ScenePetBoKiSkillInUseUpdatePetCmd"
ServiceEvent.ScenePetBoKiSkillInUseSetPetCmd = "ServiceEvent_ScenePetBoKiSkillInUseSetPetCmd"
ServiceEvent.ScenePetSevenRoyalsFollowNpc = "ServiceEvent_ScenePetSevenRoyalsFollowNpc"
