ServiceSkillAutoProxy = class("ServiceSkillAutoProxy", ServiceProxy)
ServiceSkillAutoProxy.Instance = nil
ServiceSkillAutoProxy.NAME = "ServiceSkillAutoProxy"

function ServiceSkillAutoProxy:ctor(proxyName)
  if ServiceSkillAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceSkillAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSkillAutoProxy.Instance = self
  end
end

function ServiceSkillAutoProxy:Init()
end

function ServiceSkillAutoProxy:onRegister()
  self:Listen(7, 1, function(data)
    self:RecvReqSkillData(data)
  end)
  self:Listen(7, 2, function(data)
    self:RecvSkillUpdate(data)
  end)
  self:Listen(7, 3, function(data)
    self:RecvLevelupSkill(data)
  end)
  self:Listen(7, 4, function(data)
    self:RecvEquipSkill(data)
  end)
  self:Listen(7, 5, function(data)
    self:RecvResetSkill(data)
  end)
  self:Listen(7, 6, function(data)
    self:RecvSkillValidPos(data)
  end)
  self:Listen(7, 7, function(data)
    self:RecvChangeSkillCmd(data)
  end)
  self:Listen(7, 8, function(data)
    self:RecvUpSkillInfoSkillCmd(data)
  end)
  self:Listen(7, 9, function(data)
    self:RecvSelectRuneSkillCmd(data)
  end)
  self:Listen(7, 10, function(data)
    self:RecvMarkSkillNpcSkillCmd(data)
  end)
  self:Listen(7, 11, function(data)
    self:RecvTriggerSkillNpcSkillCmd(data)
  end)
  self:Listen(7, 12, function(data)
    self:RecvSkillOptionSkillCmd(data)
  end)
  self:Listen(7, 13, function(data)
    self:RecvDynamicSkillCmd(data)
  end)
  self:Listen(7, 14, function(data)
    self:RecvUpdateDynamicSkillCmd(data)
  end)
  self:Listen(7, 15, function(data)
    self:RecvSyncDestPosSkillCmd(data)
  end)
  self:Listen(7, 16, function(data)
    self:RecvResetTalentSkillCmd(data)
  end)
  self:Listen(7, 17, function(data)
    self:RecvMultiSkillOptionUpdateSkillCmd(data)
  end)
  self:Listen(7, 18, function(data)
    self:RecvMultiSkillOptionSyncSkillCmd(data)
  end)
  self:Listen(7, 20, function(data)
    self:RecvSkillEffectSkillCmd(data)
  end)
  self:Listen(7, 21, function(data)
    self:RecvSyncSkillEffectSkillCmd(data)
  end)
  self:Listen(7, 19, function(data)
    self:RecvMaskSkillRandomOneSkillCmd(data)
  end)
  self:Listen(7, 22, function(data)
    self:RecvStopBossSkillUsageSkillCmd(data)
  end)
  self:Listen(7, 23, function(data)
    self:RecvChangeAutoShortCutCmd(data)
  end)
  self:Listen(7, 24, function(data)
    self:RecvClearOptionSkillCmd(data)
  end)
  self:Listen(7, 25, function(data)
    self:RecvSyncBulletNumSkillCmd(data)
  end)
  self:Listen(7, 26, function(data)
    self:RecvStopSniperModeSkillCmd(data)
  end)
  self:Listen(7, 27, function(data)
    self:RecvJudgeChantResultSkillCmd(data)
  end)
  self:Listen(7, 28, function(data)
    self:RecvSkillPerceptAbilityLvUpCmd(data)
  end)
  self:Listen(7, 29, function(data)
    self:RecvSkillPerceptAbilityNtf(data)
  end)
  self:Listen(7, 30, function(data)
    self:RecvSetCastPosSkillCmd(data)
  end)
  self:Listen(7, 31, function(data)
    self:RecvMarkSunMoonSkillCmd(data)
  end)
  self:Listen(7, 32, function(data)
    self:RecvTriggerKickSkillSkillCmd(data)
  end)
  self:Listen(7, 33, function(data)
    self:RecvTimeDiskSkillCmd(data)
  end)
  self:Listen(7, 34, function(data)
    self:RecvUseSkillSuccessSync(data)
  end)
  self:Listen(7, 35, function(data)
    self:RecvUpdateMasterSkill(data)
  end)
  self:Listen(7, 36, function(data)
    self:RecvUpdateMasterSkillEquip(data)
  end)
  self:Listen(7, 37, function(data)
    self:RecvSwitchMasterSkill(data)
  end)
  self:Listen(7, 38, function(data)
    self:RecvUpdateInheritSkillCmd(data)
  end)
  self:Listen(7, 39, function(data)
    self:RecvLoadInheritSkillCmd(data)
  end)
  self:Listen(7, 40, function(data)
    self:RecvExtendInheritSkillCmd(data)
  end)
  self:Listen(7, 41, function(data)
    self:RecvSyncBlockMasterSkill(data)
  end)
end

function ServiceSkillAutoProxy:CallReqSkillData(data, talentdata, forth_skill_fulled, auto_shortcut, master_skill_data, inherit_skill_data)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.ReqSkillData()
    if data ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      for i = 1, #data do
        table.insert(msg.data, data[i])
      end
    end
    if talentdata ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.talentdata == nil then
        msg.talentdata = {}
      end
      for i = 1, #talentdata do
        table.insert(msg.talentdata, talentdata[i])
      end
    end
    if forth_skill_fulled ~= nil then
      msg.forth_skill_fulled = forth_skill_fulled
    end
    if auto_shortcut ~= nil then
      msg.auto_shortcut = auto_shortcut
    end
    if master_skill_data ~= nil and master_skill_data.pro ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.master_skill_data == nil then
        msg.master_skill_data = {}
      end
      msg.master_skill_data.pro = master_skill_data.pro
    end
    if master_skill_data ~= nil and master_skill_data.skill_ids ~= nil then
      if msg.master_skill_data == nil then
        msg.master_skill_data = {}
      end
      if msg.master_skill_data.skill_ids == nil then
        msg.master_skill_data.skill_ids = {}
      end
      for i = 1, #master_skill_data.skill_ids do
        table.insert(msg.master_skill_data.skill_ids, master_skill_data.skill_ids[i])
      end
    end
    if master_skill_data ~= nil and master_skill_data.equip_skill_family_id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.master_skill_data == nil then
        msg.master_skill_data = {}
      end
      msg.master_skill_data.equip_skill_family_id = master_skill_data.equip_skill_family_id
    end
    if master_skill_data ~= nil and master_skill_data.shortcuts ~= nil then
      if msg.master_skill_data == nil then
        msg.master_skill_data = {}
      end
      if msg.master_skill_data.shortcuts == nil then
        msg.master_skill_data.shortcuts = {}
      end
      for i = 1, #master_skill_data.shortcuts do
        table.insert(msg.master_skill_data.shortcuts, master_skill_data.shortcuts[i])
      end
    end
    if master_skill_data ~= nil and master_skill_data.unlock_limit_skill_index ~= nil then
      if msg.master_skill_data == nil then
        msg.master_skill_data = {}
      end
      if msg.master_skill_data.unlock_limit_skill_index == nil then
        msg.master_skill_data.unlock_limit_skill_index = {}
      end
      for i = 1, #master_skill_data.unlock_limit_skill_index do
        table.insert(msg.master_skill_data.unlock_limit_skill_index, master_skill_data.unlock_limit_skill_index[i])
      end
    end
    if inherit_skill_data ~= nil and inherit_skill_data.items ~= nil then
      if msg.inherit_skill_data == nil then
        msg.inherit_skill_data = {}
      end
      if msg.inherit_skill_data.items == nil then
        msg.inherit_skill_data.items = {}
      end
      for i = 1, #inherit_skill_data.items do
        table.insert(msg.inherit_skill_data.items, inherit_skill_data.items[i])
      end
    end
    if inherit_skill_data ~= nil and inherit_skill_data.extendpoints ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.inherit_skill_data == nil then
        msg.inherit_skill_data = {}
      end
      msg.inherit_skill_data.extendpoints = inherit_skill_data.extendpoints
    end
    if inherit_skill_data ~= nil and inherit_skill_data.version ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.inherit_skill_data == nil then
        msg.inherit_skill_data = {}
      end
      msg.inherit_skill_data.version = inherit_skill_data.version
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReqSkillData.id
    local msgParam = {}
    if data ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      for i = 1, #data do
        table.insert(msgParam.data, data[i])
      end
    end
    if talentdata ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.talentdata == nil then
        msgParam.talentdata = {}
      end
      for i = 1, #talentdata do
        table.insert(msgParam.talentdata, talentdata[i])
      end
    end
    if forth_skill_fulled ~= nil then
      msgParam.forth_skill_fulled = forth_skill_fulled
    end
    if auto_shortcut ~= nil then
      msgParam.auto_shortcut = auto_shortcut
    end
    if master_skill_data ~= nil and master_skill_data.pro ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.master_skill_data == nil then
        msgParam.master_skill_data = {}
      end
      msgParam.master_skill_data.pro = master_skill_data.pro
    end
    if master_skill_data ~= nil and master_skill_data.skill_ids ~= nil then
      if msgParam.master_skill_data == nil then
        msgParam.master_skill_data = {}
      end
      if msgParam.master_skill_data.skill_ids == nil then
        msgParam.master_skill_data.skill_ids = {}
      end
      for i = 1, #master_skill_data.skill_ids do
        table.insert(msgParam.master_skill_data.skill_ids, master_skill_data.skill_ids[i])
      end
    end
    if master_skill_data ~= nil and master_skill_data.equip_skill_family_id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.master_skill_data == nil then
        msgParam.master_skill_data = {}
      end
      msgParam.master_skill_data.equip_skill_family_id = master_skill_data.equip_skill_family_id
    end
    if master_skill_data ~= nil and master_skill_data.shortcuts ~= nil then
      if msgParam.master_skill_data == nil then
        msgParam.master_skill_data = {}
      end
      if msgParam.master_skill_data.shortcuts == nil then
        msgParam.master_skill_data.shortcuts = {}
      end
      for i = 1, #master_skill_data.shortcuts do
        table.insert(msgParam.master_skill_data.shortcuts, master_skill_data.shortcuts[i])
      end
    end
    if master_skill_data ~= nil and master_skill_data.unlock_limit_skill_index ~= nil then
      if msgParam.master_skill_data == nil then
        msgParam.master_skill_data = {}
      end
      if msgParam.master_skill_data.unlock_limit_skill_index == nil then
        msgParam.master_skill_data.unlock_limit_skill_index = {}
      end
      for i = 1, #master_skill_data.unlock_limit_skill_index do
        table.insert(msgParam.master_skill_data.unlock_limit_skill_index, master_skill_data.unlock_limit_skill_index[i])
      end
    end
    if inherit_skill_data ~= nil and inherit_skill_data.items ~= nil then
      if msgParam.inherit_skill_data == nil then
        msgParam.inherit_skill_data = {}
      end
      if msgParam.inherit_skill_data.items == nil then
        msgParam.inherit_skill_data.items = {}
      end
      for i = 1, #inherit_skill_data.items do
        table.insert(msgParam.inherit_skill_data.items, inherit_skill_data.items[i])
      end
    end
    if inherit_skill_data ~= nil and inherit_skill_data.extendpoints ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.inherit_skill_data == nil then
        msgParam.inherit_skill_data = {}
      end
      msgParam.inherit_skill_data.extendpoints = inherit_skill_data.extendpoints
    end
    if inherit_skill_data ~= nil and inherit_skill_data.version ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.inherit_skill_data == nil then
        msgParam.inherit_skill_data = {}
      end
      msgParam.inherit_skill_data.version = inherit_skill_data.version
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallSkillUpdate(update, del, talent_update, talent_del, forth_skill_fulled_change)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.SkillUpdate()
    if update ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.update == nil then
        msg.update = {}
      end
      for i = 1, #update do
        table.insert(msg.update, update[i])
      end
    end
    if del ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.del == nil then
        msg.del = {}
      end
      for i = 1, #del do
        table.insert(msg.del, del[i])
      end
    end
    if talent_update ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.talent_update == nil then
        msg.talent_update = {}
      end
      for i = 1, #talent_update do
        table.insert(msg.talent_update, talent_update[i])
      end
    end
    if talent_del ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.talent_del == nil then
        msg.talent_del = {}
      end
      for i = 1, #talent_del do
        table.insert(msg.talent_del, talent_del[i])
      end
    end
    if forth_skill_fulled_change ~= nil then
      msg.forth_skill_fulled_change = forth_skill_fulled_change
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SkillUpdate.id
    local msgParam = {}
    if update ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.update == nil then
        msgParam.update = {}
      end
      for i = 1, #update do
        table.insert(msgParam.update, update[i])
      end
    end
    if del ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.del == nil then
        msgParam.del = {}
      end
      for i = 1, #del do
        table.insert(msgParam.del, del[i])
      end
    end
    if talent_update ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.talent_update == nil then
        msgParam.talent_update = {}
      end
      for i = 1, #talent_update do
        table.insert(msgParam.talent_update, talent_update[i])
      end
    end
    if talent_del ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.talent_del == nil then
        msgParam.talent_del = {}
      end
      for i = 1, #talent_del do
        table.insert(msgParam.talent_del, talent_del[i])
      end
    end
    if forth_skill_fulled_change ~= nil then
      msgParam.forth_skill_fulled_change = forth_skill_fulled_change
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallLevelupSkill(type, skillids)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.LevelupSkill()
    if type ~= nil then
      msg.type = type
    end
    if skillids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.skillids == nil then
        msg.skillids = {}
      end
      for i = 1, #skillids do
        table.insert(msg.skillids, skillids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.LevelupSkill.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if skillids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.skillids == nil then
        msgParam.skillids = {}
      end
      for i = 1, #skillids do
        table.insert(msgParam.skillids, skillids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallEquipSkill(skillid, pos, sourceid, efrom, eto, beingid)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.EquipSkill()
    if skillid ~= nil then
      msg.skillid = skillid
    end
    if pos ~= nil then
      msg.pos = pos
    end
    if sourceid ~= nil then
      msg.sourceid = sourceid
    end
    if efrom ~= nil then
      msg.efrom = efrom
    end
    if eto ~= nil then
      msg.eto = eto
    end
    if beingid ~= nil then
      msg.beingid = beingid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EquipSkill.id
    local msgParam = {}
    if skillid ~= nil then
      msgParam.skillid = skillid
    end
    if pos ~= nil then
      msgParam.pos = pos
    end
    if sourceid ~= nil then
      msgParam.sourceid = sourceid
    end
    if efrom ~= nil then
      msgParam.efrom = efrom
    end
    if eto ~= nil then
      msgParam.eto = eto
    end
    if beingid ~= nil then
      msgParam.beingid = beingid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallResetSkill(type, casttype)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.ResetSkill()
    if type ~= nil then
      msg.type = type
    end
    if casttype ~= nil then
      msg.casttype = casttype
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ResetSkill.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if casttype ~= nil then
      msgParam.casttype = casttype
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallSkillValidPos(shortcuts)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.SkillValidPos()
    if shortcuts ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.shortcuts == nil then
        msg.shortcuts = {}
      end
      for i = 1, #shortcuts do
        table.insert(msg.shortcuts, shortcuts[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SkillValidPos.id
    local msgParam = {}
    if shortcuts ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.shortcuts == nil then
        msgParam.shortcuts = {}
      end
      for i = 1, #shortcuts do
        table.insert(msgParam.shortcuts, shortcuts[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallChangeSkillCmd(skillid, type, isadd, key)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.ChangeSkillCmd()
    if skillid ~= nil then
      msg.skillid = skillid
    end
    if type ~= nil then
      msg.type = type
    end
    if isadd ~= nil then
      msg.isadd = isadd
    end
    if key ~= nil then
      msg.key = key
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ChangeSkillCmd.id
    local msgParam = {}
    if skillid ~= nil then
      msgParam.skillid = skillid
    end
    if type ~= nil then
      msgParam.type = type
    end
    if isadd ~= nil then
      msgParam.isadd = isadd
    end
    if key ~= nil then
      msgParam.key = key
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallUpSkillInfoSkillCmd(specinfo, allskillInfo, all)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.UpSkillInfoSkillCmd()
    if specinfo ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.specinfo == nil then
        msg.specinfo = {}
      end
      for i = 1, #specinfo do
        table.insert(msg.specinfo, specinfo[i])
      end
    end
    if msg.allskillInfo == nil then
      msg.allskillInfo = {}
    end
    msg.allskillInfo.id = allskillInfo.id
    if allskillInfo ~= nil and allskillInfo.attrs ~= nil then
      if msg.allskillInfo == nil then
        msg.allskillInfo = {}
      end
      if msg.allskillInfo.attrs == nil then
        msg.allskillInfo.attrs = {}
      end
      for i = 1, #allskillInfo.attrs do
        table.insert(msg.allskillInfo.attrs, allskillInfo.attrs[i])
      end
    end
    if allskillInfo ~= nil and allskillInfo.cost ~= nil then
      if msg.allskillInfo == nil then
        msg.allskillInfo = {}
      end
      if msg.allskillInfo.cost == nil then
        msg.allskillInfo.cost = {}
      end
      for i = 1, #allskillInfo.cost do
        table.insert(msg.allskillInfo.cost, allskillInfo.cost[i])
      end
    end
    if allskillInfo ~= nil and allskillInfo.changerange ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.allskillInfo == nil then
        msg.allskillInfo = {}
      end
      msg.allskillInfo.changerange = allskillInfo.changerange
    end
    if allskillInfo ~= nil and allskillInfo.changenum ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.allskillInfo == nil then
        msg.allskillInfo = {}
      end
      msg.allskillInfo.changenum = allskillInfo.changenum
    end
    if allskillInfo ~= nil and allskillInfo.changeready ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.allskillInfo == nil then
        msg.allskillInfo = {}
      end
      msg.allskillInfo.changeready = allskillInfo.changeready
    end
    if allskillInfo ~= nil and allskillInfo.neednoitem ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.allskillInfo == nil then
        msg.allskillInfo = {}
      end
      msg.allskillInfo.neednoitem = allskillInfo.neednoitem
    end
    if allskillInfo ~= nil and allskillInfo.spotter ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.allskillInfo == nil then
        msg.allskillInfo = {}
      end
      msg.allskillInfo.spotter = allskillInfo.spotter
    end
    if allskillInfo ~= nil and allskillInfo.maxspper ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.allskillInfo == nil then
        msg.allskillInfo = {}
      end
      msg.allskillInfo.maxspper = allskillInfo.maxspper
    end
    if allskillInfo ~= nil and allskillInfo.neednocheck ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.allskillInfo == nil then
        msg.allskillInfo = {}
      end
      msg.allskillInfo.neednocheck = allskillInfo.neednocheck
    end
    if allskillInfo ~= nil and allskillInfo.neednobuff ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.allskillInfo == nil then
        msg.allskillInfo = {}
      end
      msg.allskillInfo.neednobuff = allskillInfo.neednobuff
    end
    if allskillInfo ~= nil and allskillInfo.trap_follow_speed ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.allskillInfo == nil then
        msg.allskillInfo = {}
      end
      msg.allskillInfo.trap_follow_speed = allskillInfo.trap_follow_speed
    end
    if allskillInfo ~= nil and allskillInfo.chant_can_use_skill ~= nil then
      if msg.allskillInfo == nil then
        msg.allskillInfo = {}
      end
      if msg.allskillInfo.chant_can_use_skill == nil then
        msg.allskillInfo.chant_can_use_skill = {}
      end
      for i = 1, #allskillInfo.chant_can_use_skill do
        table.insert(msg.allskillInfo.chant_can_use_skill, allskillInfo.chant_can_use_skill[i])
      end
    end
    if allskillInfo ~= nil and allskillInfo.cd_times ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.allskillInfo == nil then
        msg.allskillInfo = {}
      end
      msg.allskillInfo.cd_times = allskillInfo.cd_times
    end
    if all ~= nil then
      msg.all = all
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpSkillInfoSkillCmd.id
    local msgParam = {}
    if specinfo ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.specinfo == nil then
        msgParam.specinfo = {}
      end
      for i = 1, #specinfo do
        table.insert(msgParam.specinfo, specinfo[i])
      end
    end
    if msgParam.allskillInfo == nil then
      msgParam.allskillInfo = {}
    end
    msgParam.allskillInfo.id = allskillInfo.id
    if allskillInfo ~= nil and allskillInfo.attrs ~= nil then
      if msgParam.allskillInfo == nil then
        msgParam.allskillInfo = {}
      end
      if msgParam.allskillInfo.attrs == nil then
        msgParam.allskillInfo.attrs = {}
      end
      for i = 1, #allskillInfo.attrs do
        table.insert(msgParam.allskillInfo.attrs, allskillInfo.attrs[i])
      end
    end
    if allskillInfo ~= nil and allskillInfo.cost ~= nil then
      if msgParam.allskillInfo == nil then
        msgParam.allskillInfo = {}
      end
      if msgParam.allskillInfo.cost == nil then
        msgParam.allskillInfo.cost = {}
      end
      for i = 1, #allskillInfo.cost do
        table.insert(msgParam.allskillInfo.cost, allskillInfo.cost[i])
      end
    end
    if allskillInfo ~= nil and allskillInfo.changerange ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.allskillInfo == nil then
        msgParam.allskillInfo = {}
      end
      msgParam.allskillInfo.changerange = allskillInfo.changerange
    end
    if allskillInfo ~= nil and allskillInfo.changenum ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.allskillInfo == nil then
        msgParam.allskillInfo = {}
      end
      msgParam.allskillInfo.changenum = allskillInfo.changenum
    end
    if allskillInfo ~= nil and allskillInfo.changeready ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.allskillInfo == nil then
        msgParam.allskillInfo = {}
      end
      msgParam.allskillInfo.changeready = allskillInfo.changeready
    end
    if allskillInfo ~= nil and allskillInfo.neednoitem ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.allskillInfo == nil then
        msgParam.allskillInfo = {}
      end
      msgParam.allskillInfo.neednoitem = allskillInfo.neednoitem
    end
    if allskillInfo ~= nil and allskillInfo.spotter ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.allskillInfo == nil then
        msgParam.allskillInfo = {}
      end
      msgParam.allskillInfo.spotter = allskillInfo.spotter
    end
    if allskillInfo ~= nil and allskillInfo.maxspper ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.allskillInfo == nil then
        msgParam.allskillInfo = {}
      end
      msgParam.allskillInfo.maxspper = allskillInfo.maxspper
    end
    if allskillInfo ~= nil and allskillInfo.neednocheck ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.allskillInfo == nil then
        msgParam.allskillInfo = {}
      end
      msgParam.allskillInfo.neednocheck = allskillInfo.neednocheck
    end
    if allskillInfo ~= nil and allskillInfo.neednobuff ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.allskillInfo == nil then
        msgParam.allskillInfo = {}
      end
      msgParam.allskillInfo.neednobuff = allskillInfo.neednobuff
    end
    if allskillInfo ~= nil and allskillInfo.trap_follow_speed ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.allskillInfo == nil then
        msgParam.allskillInfo = {}
      end
      msgParam.allskillInfo.trap_follow_speed = allskillInfo.trap_follow_speed
    end
    if allskillInfo ~= nil and allskillInfo.chant_can_use_skill ~= nil then
      if msgParam.allskillInfo == nil then
        msgParam.allskillInfo = {}
      end
      if msgParam.allskillInfo.chant_can_use_skill == nil then
        msgParam.allskillInfo.chant_can_use_skill = {}
      end
      for i = 1, #allskillInfo.chant_can_use_skill do
        table.insert(msgParam.allskillInfo.chant_can_use_skill, allskillInfo.chant_can_use_skill[i])
      end
    end
    if allskillInfo ~= nil and allskillInfo.cd_times ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.allskillInfo == nil then
        msgParam.allskillInfo = {}
      end
      msgParam.allskillInfo.cd_times = allskillInfo.cd_times
    end
    if all ~= nil then
      msgParam.all = all
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallSelectRuneSkillCmd(skillid, runespecid, selectswitch, beingid)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.SelectRuneSkillCmd()
    if msg == nil then
      msg = {}
    end
    msg.skillid = skillid
    if runespecid ~= nil then
      msg.runespecid = runespecid
    end
    if selectswitch ~= nil then
      msg.selectswitch = selectswitch
    end
    if beingid ~= nil then
      msg.beingid = beingid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SelectRuneSkillCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.skillid = skillid
    if runespecid ~= nil then
      msgParam.runespecid = runespecid
    end
    if selectswitch ~= nil then
      msgParam.selectswitch = selectswitch
    end
    if beingid ~= nil then
      msgParam.beingid = beingid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallMarkSkillNpcSkillCmd(npcguid, skillid)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.MarkSkillNpcSkillCmd()
    if msg == nil then
      msg = {}
    end
    msg.npcguid = npcguid
    if msg == nil then
      msg = {}
    end
    msg.skillid = skillid
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MarkSkillNpcSkillCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.npcguid = npcguid
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.skillid = skillid
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallTriggerSkillNpcSkillCmd(npcguid, etype)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.TriggerSkillNpcSkillCmd()
    if msg == nil then
      msg = {}
    end
    msg.npcguid = npcguid
    if etype ~= nil then
      msg.etype = etype
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TriggerSkillNpcSkillCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.npcguid = npcguid
    if etype ~= nil then
      msgParam.etype = etype
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallSkillOptionSkillCmd(set_opt, all_opts)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.SkillOptionSkillCmd()
    if msg.set_opt == nil then
      msg.set_opt = {}
    end
    msg.set_opt.opt = set_opt.opt
    if set_opt ~= nil and set_opt.value ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.set_opt == nil then
        msg.set_opt = {}
      end
      msg.set_opt.value = set_opt.value
    end
    if all_opts ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.all_opts == nil then
        msg.all_opts = {}
      end
      for i = 1, #all_opts do
        table.insert(msg.all_opts, all_opts[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SkillOptionSkillCmd.id
    local msgParam = {}
    if msgParam.set_opt == nil then
      msgParam.set_opt = {}
    end
    msgParam.set_opt.opt = set_opt.opt
    if set_opt ~= nil and set_opt.value ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.set_opt == nil then
        msgParam.set_opt = {}
      end
      msgParam.set_opt.value = set_opt.value
    end
    if all_opts ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.all_opts == nil then
        msgParam.all_opts = {}
      end
      for i = 1, #all_opts do
        table.insert(msgParam.all_opts, all_opts[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallDynamicSkillCmd(skills)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.DynamicSkillCmd()
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
    local msgId = ProtoReqInfoList.DynamicSkillCmd.id
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

function ServiceSkillAutoProxy:CallUpdateDynamicSkillCmd(update, del)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.UpdateDynamicSkillCmd()
    if update ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.update == nil then
        msg.update = {}
      end
      for i = 1, #update do
        table.insert(msg.update, update[i])
      end
    end
    if del ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.del == nil then
        msg.del = {}
      end
      for i = 1, #del do
        table.insert(msg.del, del[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateDynamicSkillCmd.id
    local msgParam = {}
    if update ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.update == nil then
        msgParam.update = {}
      end
      for i = 1, #update do
        table.insert(msgParam.update, update[i])
      end
    end
    if del ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.del == nil then
        msgParam.del = {}
      end
      for i = 1, #del do
        table.insert(msgParam.del, del[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallSyncDestPosSkillCmd(skillid, pos)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.SyncDestPosSkillCmd()
    if skillid ~= nil then
      msg.skillid = skillid
    end
    if pos ~= nil and pos.x ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.pos == nil then
        msg.pos = {}
      end
      msg.pos.x = pos.x
    end
    if pos ~= nil and pos.y ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.pos == nil then
        msg.pos = {}
      end
      msg.pos.y = pos.y
    end
    if pos ~= nil and pos.z ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.pos == nil then
        msg.pos = {}
      end
      msg.pos.z = pos.z
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncDestPosSkillCmd.id
    local msgParam = {}
    if skillid ~= nil then
      msgParam.skillid = skillid
    end
    if pos ~= nil and pos.x ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.pos == nil then
        msgParam.pos = {}
      end
      msgParam.pos.x = pos.x
    end
    if pos ~= nil and pos.y ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.pos == nil then
        msgParam.pos = {}
      end
      msgParam.pos.y = pos.y
    end
    if pos ~= nil and pos.z ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.pos == nil then
        msgParam.pos = {}
      end
      msgParam.pos.z = pos.z
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallResetTalentSkillCmd()
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.ResetTalentSkillCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ResetTalentSkillCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallMultiSkillOptionUpdateSkillCmd(opt)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.MultiSkillOptionUpdateSkillCmd()
    if opt ~= nil and opt.opt ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.opt == nil then
        msg.opt = {}
      end
      msg.opt.opt = opt.opt
    end
    if opt ~= nil and opt.value ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.opt == nil then
        msg.opt = {}
      end
      msg.opt.value = opt.value
    end
    if opt ~= nil and opt.values ~= nil then
      if msg.opt == nil then
        msg.opt = {}
      end
      if msg.opt.values == nil then
        msg.opt.values = {}
      end
      for i = 1, #opt.values do
        table.insert(msg.opt.values, opt.values[i])
      end
    end
    if opt ~= nil and opt.guid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.opt == nil then
        msg.opt = {}
      end
      msg.opt.guid = opt.guid
    end
    if opt ~= nil and opt.subvalues ~= nil then
      if msg.opt == nil then
        msg.opt = {}
      end
      if msg.opt.subvalues == nil then
        msg.opt.subvalues = {}
      end
      for i = 1, #opt.subvalues do
        table.insert(msg.opt.subvalues, opt.subvalues[i])
      end
    end
    if opt ~= nil and opt.datas ~= nil then
      if msg.opt == nil then
        msg.opt = {}
      end
      if msg.opt.datas == nil then
        msg.opt.datas = {}
      end
      for i = 1, #opt.datas do
        table.insert(msg.opt.datas, opt.datas[i])
      end
    end
    if opt ~= nil and opt.param1 ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.opt == nil then
        msg.opt = {}
      end
      msg.opt.param1 = opt.param1
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MultiSkillOptionUpdateSkillCmd.id
    local msgParam = {}
    if opt ~= nil and opt.opt ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.opt == nil then
        msgParam.opt = {}
      end
      msgParam.opt.opt = opt.opt
    end
    if opt ~= nil and opt.value ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.opt == nil then
        msgParam.opt = {}
      end
      msgParam.opt.value = opt.value
    end
    if opt ~= nil and opt.values ~= nil then
      if msgParam.opt == nil then
        msgParam.opt = {}
      end
      if msgParam.opt.values == nil then
        msgParam.opt.values = {}
      end
      for i = 1, #opt.values do
        table.insert(msgParam.opt.values, opt.values[i])
      end
    end
    if opt ~= nil and opt.guid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.opt == nil then
        msgParam.opt = {}
      end
      msgParam.opt.guid = opt.guid
    end
    if opt ~= nil and opt.subvalues ~= nil then
      if msgParam.opt == nil then
        msgParam.opt = {}
      end
      if msgParam.opt.subvalues == nil then
        msgParam.opt.subvalues = {}
      end
      for i = 1, #opt.subvalues do
        table.insert(msgParam.opt.subvalues, opt.subvalues[i])
      end
    end
    if opt ~= nil and opt.datas ~= nil then
      if msgParam.opt == nil then
        msgParam.opt = {}
      end
      if msgParam.opt.datas == nil then
        msgParam.opt.datas = {}
      end
      for i = 1, #opt.datas do
        table.insert(msgParam.opt.datas, opt.datas[i])
      end
    end
    if opt ~= nil and opt.param1 ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.opt == nil then
        msgParam.opt = {}
      end
      msgParam.opt.param1 = opt.param1
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallMultiSkillOptionSyncSkillCmd(opts)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.MultiSkillOptionSyncSkillCmd()
    if opts ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.opts == nil then
        msg.opts = {}
      end
      for i = 1, #opts do
        table.insert(msg.opts, opts[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MultiSkillOptionSyncSkillCmd.id
    local msgParam = {}
    if opts ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.opts == nil then
        msgParam.opts = {}
      end
      for i = 1, #opts do
        table.insert(msgParam.opts, opts[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallSkillEffectSkillCmd(charid, effects)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.SkillEffectSkillCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    if effects ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.effects == nil then
        msg.effects = {}
      end
      for i = 1, #effects do
        table.insert(msg.effects, effects[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SkillEffectSkillCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if effects ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.effects == nil then
        msgParam.effects = {}
      end
      for i = 1, #effects do
        table.insert(msgParam.effects, effects[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallSyncSkillEffectSkillCmd(proeffects)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.SyncSkillEffectSkillCmd()
    if proeffects ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.proeffects == nil then
        msg.proeffects = {}
      end
      for i = 1, #proeffects do
        table.insert(msg.proeffects, proeffects[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncSkillEffectSkillCmd.id
    local msgParam = {}
    if proeffects ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.proeffects == nil then
        msgParam.proeffects = {}
      end
      for i = 1, #proeffects do
        table.insert(msgParam.proeffects, proeffects[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallMaskSkillRandomOneSkillCmd(randomskillid)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.MaskSkillRandomOneSkillCmd()
    if randomskillid ~= nil then
      msg.randomskillid = randomskillid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.MaskSkillRandomOneSkillCmd.id
    local msgParam = {}
    if randomskillid ~= nil then
      msgParam.randomskillid = randomskillid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallStopBossSkillUsageSkillCmd(bossid, skillid)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.StopBossSkillUsageSkillCmd()
    if bossid ~= nil then
      msg.bossid = bossid
    end
    if skillid ~= nil then
      msg.skillid = skillid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.StopBossSkillUsageSkillCmd.id
    local msgParam = {}
    if bossid ~= nil then
      msgParam.bossid = bossid
    end
    if skillid ~= nil then
      msgParam.skillid = skillid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallChangeAutoShortCutCmd(shortcut)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.ChangeAutoShortCutCmd()
    if shortcut ~= nil then
      msg.shortcut = shortcut
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ChangeAutoShortCutCmd.id
    local msgParam = {}
    if shortcut ~= nil then
      msgParam.shortcut = shortcut
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallClearOptionSkillCmd()
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.ClearOptionSkillCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ClearOptionSkillCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallSyncBulletNumSkillCmd(num)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.SyncBulletNumSkillCmd()
    if num ~= nil then
      msg.num = num
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncBulletNumSkillCmd.id
    local msgParam = {}
    if num ~= nil then
      msgParam.num = num
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallStopSniperModeSkillCmd()
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.StopSniperModeSkillCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.StopSniperModeSkillCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallJudgeChantResultSkillCmd(cursorvalue)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.JudgeChantResultSkillCmd()
    if cursorvalue ~= nil then
      msg.cursorvalue = cursorvalue
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.JudgeChantResultSkillCmd.id
    local msgParam = {}
    if cursorvalue ~= nil then
      msgParam.cursorvalue = cursorvalue
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallSkillPerceptAbilityLvUpCmd(skill, count)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.SkillPerceptAbilityLvUpCmd()
    if skill ~= nil then
      msg.skill = skill
    end
    if count ~= nil then
      msg.count = count
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SkillPerceptAbilityLvUpCmd.id
    local msgParam = {}
    if skill ~= nil then
      msgParam.skill = skill
    end
    if count ~= nil then
      msgParam.count = count
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallSkillPerceptAbilityNtf(skills)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.SkillPerceptAbilityNtf()
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
    local msgId = ProtoReqInfoList.SkillPerceptAbilityNtf.id
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

function ServiceSkillAutoProxy:CallSetCastPosSkillCmd(pos)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.SetCastPosSkillCmd()
    if pos ~= nil and pos.x ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.pos == nil then
        msg.pos = {}
      end
      msg.pos.x = pos.x
    end
    if pos ~= nil and pos.y ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.pos == nil then
        msg.pos = {}
      end
      msg.pos.y = pos.y
    end
    if pos ~= nil and pos.z ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.pos == nil then
        msg.pos = {}
      end
      msg.pos.z = pos.z
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SetCastPosSkillCmd.id
    local msgParam = {}
    if pos ~= nil and pos.x ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.pos == nil then
        msgParam.pos = {}
      end
      msgParam.pos.x = pos.x
    end
    if pos ~= nil and pos.y ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.pos == nil then
        msgParam.pos = {}
      end
      msgParam.pos.y = pos.y
    end
    if pos ~= nil and pos.z ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.pos == nil then
        msgParam.pos = {}
      end
      msgParam.pos.z = pos.z
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallMarkSunMoonSkillCmd(datas)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.MarkSunMoonSkillCmd()
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
    local msgId = ProtoReqInfoList.MarkSunMoonSkillCmd.id
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

function ServiceSkillAutoProxy:CallTriggerKickSkillSkillCmd(skillid)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.TriggerKickSkillSkillCmd()
    if skillid ~= nil then
      msg.skillid = skillid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TriggerKickSkillSkillCmd.id
    local msgParam = {}
    if skillid ~= nil then
      msgParam.skillid = skillid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallTimeDiskSkillCmd(sundisk, move, smallgrid, suspendendtime, begintime)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.TimeDiskSkillCmd()
    if sundisk ~= nil then
      msg.sundisk = sundisk
    end
    if move ~= nil then
      msg.move = move
    end
    if smallgrid ~= nil then
      msg.smallgrid = smallgrid
    end
    if suspendendtime ~= nil then
      msg.suspendendtime = suspendendtime
    end
    if begintime ~= nil then
      msg.begintime = begintime
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TimeDiskSkillCmd.id
    local msgParam = {}
    if sundisk ~= nil then
      msgParam.sundisk = sundisk
    end
    if move ~= nil then
      msgParam.move = move
    end
    if smallgrid ~= nil then
      msgParam.smallgrid = smallgrid
    end
    if suspendendtime ~= nil then
      msgParam.suspendendtime = suspendendtime
    end
    if begintime ~= nil then
      msgParam.begintime = begintime
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallUseSkillSuccessSync(skillid)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.UseSkillSuccessSync()
    if skillid ~= nil then
      msg.skillid = skillid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UseSkillSuccessSync.id
    local msgParam = {}
    if skillid ~= nil then
      msgParam.skillid = skillid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallUpdateMasterSkill(add_ids, del_ids, updates, unlock_skill_index)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.UpdateMasterSkill()
    if add_ids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.add_ids == nil then
        msg.add_ids = {}
      end
      for i = 1, #add_ids do
        table.insert(msg.add_ids, add_ids[i])
      end
    end
    if del_ids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.del_ids == nil then
        msg.del_ids = {}
      end
      for i = 1, #del_ids do
        table.insert(msg.del_ids, del_ids[i])
      end
    end
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
    if unlock_skill_index ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.unlock_skill_index == nil then
        msg.unlock_skill_index = {}
      end
      for i = 1, #unlock_skill_index do
        table.insert(msg.unlock_skill_index, unlock_skill_index[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateMasterSkill.id
    local msgParam = {}
    if add_ids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.add_ids == nil then
        msgParam.add_ids = {}
      end
      for i = 1, #add_ids do
        table.insert(msgParam.add_ids, add_ids[i])
      end
    end
    if del_ids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.del_ids == nil then
        msgParam.del_ids = {}
      end
      for i = 1, #del_ids do
        table.insert(msgParam.del_ids, del_ids[i])
      end
    end
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
    if unlock_skill_index ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.unlock_skill_index == nil then
        msgParam.unlock_skill_index = {}
      end
      for i = 1, #unlock_skill_index do
        table.insert(msgParam.unlock_skill_index, unlock_skill_index[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallUpdateMasterSkillEquip(equip_skill_family_id, shortcuts)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.UpdateMasterSkillEquip()
    if equip_skill_family_id ~= nil then
      msg.equip_skill_family_id = equip_skill_family_id
    end
    if shortcuts ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.shortcuts == nil then
        msg.shortcuts = {}
      end
      for i = 1, #shortcuts do
        table.insert(msg.shortcuts, shortcuts[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateMasterSkillEquip.id
    local msgParam = {}
    if equip_skill_family_id ~= nil then
      msgParam.equip_skill_family_id = equip_skill_family_id
    end
    if shortcuts ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.shortcuts == nil then
        msgParam.shortcuts = {}
      end
      for i = 1, #shortcuts do
        table.insert(msgParam.shortcuts, shortcuts[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallSwitchMasterSkill(skill_family_id)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.SwitchMasterSkill()
    if skill_family_id ~= nil then
      msg.skill_family_id = skill_family_id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SwitchMasterSkill.id
    local msgParam = {}
    if skill_family_id ~= nil then
      msgParam.skill_family_id = skill_family_id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallUpdateInheritSkillCmd(items)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.UpdateInheritSkillCmd()
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
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateInheritSkillCmd.id
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
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallLoadInheritSkillCmd(id, replaceid, opt)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.LoadInheritSkillCmd()
    if id ~= nil then
      msg.id = id
    end
    if replaceid ~= nil then
      msg.replaceid = replaceid
    end
    if opt ~= nil then
      msg.opt = opt
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.LoadInheritSkillCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if replaceid ~= nil then
      msgParam.replaceid = replaceid
    end
    if opt ~= nil then
      msgParam.opt = opt
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallExtendInheritSkillCmd(extendpoints)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.ExtendInheritSkillCmd()
    if extendpoints ~= nil then
      msg.extendpoints = extendpoints
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ExtendInheritSkillCmd.id
    local msgParam = {}
    if extendpoints ~= nil then
      msgParam.extendpoints = extendpoints
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:CallSyncBlockMasterSkill(block_skills)
  if not NetConfig.PBC then
    local msg = SceneSkill_pb.SyncBlockMasterSkill()
    if block_skills ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.block_skills == nil then
        msg.block_skills = {}
      end
      for i = 1, #block_skills do
        table.insert(msg.block_skills, block_skills[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncBlockMasterSkill.id
    local msgParam = {}
    if block_skills ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.block_skills == nil then
        msgParam.block_skills = {}
      end
      for i = 1, #block_skills do
        table.insert(msgParam.block_skills, block_skills[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSkillAutoProxy:RecvReqSkillData(data)
  self:Notify(ServiceEvent.SkillReqSkillData, data)
end

function ServiceSkillAutoProxy:RecvSkillUpdate(data)
  self:Notify(ServiceEvent.SkillSkillUpdate, data)
end

function ServiceSkillAutoProxy:RecvLevelupSkill(data)
  self:Notify(ServiceEvent.SkillLevelupSkill, data)
end

function ServiceSkillAutoProxy:RecvEquipSkill(data)
  self:Notify(ServiceEvent.SkillEquipSkill, data)
end

function ServiceSkillAutoProxy:RecvResetSkill(data)
  self:Notify(ServiceEvent.SkillResetSkill, data)
end

function ServiceSkillAutoProxy:RecvSkillValidPos(data)
  self:Notify(ServiceEvent.SkillSkillValidPos, data)
end

function ServiceSkillAutoProxy:RecvChangeSkillCmd(data)
  self:Notify(ServiceEvent.SkillChangeSkillCmd, data)
end

function ServiceSkillAutoProxy:RecvUpSkillInfoSkillCmd(data)
  self:Notify(ServiceEvent.SkillUpSkillInfoSkillCmd, data)
end

function ServiceSkillAutoProxy:RecvSelectRuneSkillCmd(data)
  self:Notify(ServiceEvent.SkillSelectRuneSkillCmd, data)
end

function ServiceSkillAutoProxy:RecvMarkSkillNpcSkillCmd(data)
  self:Notify(ServiceEvent.SkillMarkSkillNpcSkillCmd, data)
end

function ServiceSkillAutoProxy:RecvTriggerSkillNpcSkillCmd(data)
  self:Notify(ServiceEvent.SkillTriggerSkillNpcSkillCmd, data)
end

function ServiceSkillAutoProxy:RecvSkillOptionSkillCmd(data)
  self:Notify(ServiceEvent.SkillSkillOptionSkillCmd, data)
end

function ServiceSkillAutoProxy:RecvDynamicSkillCmd(data)
  self:Notify(ServiceEvent.SkillDynamicSkillCmd, data)
end

function ServiceSkillAutoProxy:RecvUpdateDynamicSkillCmd(data)
  self:Notify(ServiceEvent.SkillUpdateDynamicSkillCmd, data)
end

function ServiceSkillAutoProxy:RecvSyncDestPosSkillCmd(data)
  self:Notify(ServiceEvent.SkillSyncDestPosSkillCmd, data)
end

function ServiceSkillAutoProxy:RecvResetTalentSkillCmd(data)
  self:Notify(ServiceEvent.SkillResetTalentSkillCmd, data)
end

function ServiceSkillAutoProxy:RecvMultiSkillOptionUpdateSkillCmd(data)
  self:Notify(ServiceEvent.SkillMultiSkillOptionUpdateSkillCmd, data)
end

function ServiceSkillAutoProxy:RecvMultiSkillOptionSyncSkillCmd(data)
  self:Notify(ServiceEvent.SkillMultiSkillOptionSyncSkillCmd, data)
end

function ServiceSkillAutoProxy:RecvSkillEffectSkillCmd(data)
  self:Notify(ServiceEvent.SkillSkillEffectSkillCmd, data)
end

function ServiceSkillAutoProxy:RecvSyncSkillEffectSkillCmd(data)
  self:Notify(ServiceEvent.SkillSyncSkillEffectSkillCmd, data)
end

function ServiceSkillAutoProxy:RecvMaskSkillRandomOneSkillCmd(data)
  self:Notify(ServiceEvent.SkillMaskSkillRandomOneSkillCmd, data)
end

function ServiceSkillAutoProxy:RecvStopBossSkillUsageSkillCmd(data)
  self:Notify(ServiceEvent.SkillStopBossSkillUsageSkillCmd, data)
end

function ServiceSkillAutoProxy:RecvChangeAutoShortCutCmd(data)
  self:Notify(ServiceEvent.SkillChangeAutoShortCutCmd, data)
end

function ServiceSkillAutoProxy:RecvClearOptionSkillCmd(data)
  self:Notify(ServiceEvent.SkillClearOptionSkillCmd, data)
end

function ServiceSkillAutoProxy:RecvSyncBulletNumSkillCmd(data)
  self:Notify(ServiceEvent.SkillSyncBulletNumSkillCmd, data)
end

function ServiceSkillAutoProxy:RecvStopSniperModeSkillCmd(data)
  self:Notify(ServiceEvent.SkillStopSniperModeSkillCmd, data)
end

function ServiceSkillAutoProxy:RecvJudgeChantResultSkillCmd(data)
  self:Notify(ServiceEvent.SkillJudgeChantResultSkillCmd, data)
end

function ServiceSkillAutoProxy:RecvSkillPerceptAbilityLvUpCmd(data)
  self:Notify(ServiceEvent.SkillSkillPerceptAbilityLvUpCmd, data)
end

function ServiceSkillAutoProxy:RecvSkillPerceptAbilityNtf(data)
  self:Notify(ServiceEvent.SkillSkillPerceptAbilityNtf, data)
end

function ServiceSkillAutoProxy:RecvSetCastPosSkillCmd(data)
  self:Notify(ServiceEvent.SkillSetCastPosSkillCmd, data)
end

function ServiceSkillAutoProxy:RecvMarkSunMoonSkillCmd(data)
  self:Notify(ServiceEvent.SkillMarkSunMoonSkillCmd, data)
end

function ServiceSkillAutoProxy:RecvTriggerKickSkillSkillCmd(data)
  self:Notify(ServiceEvent.SkillTriggerKickSkillSkillCmd, data)
end

function ServiceSkillAutoProxy:RecvTimeDiskSkillCmd(data)
  self:Notify(ServiceEvent.SkillTimeDiskSkillCmd, data)
end

function ServiceSkillAutoProxy:RecvUseSkillSuccessSync(data)
  self:Notify(ServiceEvent.SkillUseSkillSuccessSync, data)
end

function ServiceSkillAutoProxy:RecvUpdateMasterSkill(data)
  self:Notify(ServiceEvent.SkillUpdateMasterSkill, data)
end

function ServiceSkillAutoProxy:RecvUpdateMasterSkillEquip(data)
  self:Notify(ServiceEvent.SkillUpdateMasterSkillEquip, data)
end

function ServiceSkillAutoProxy:RecvSwitchMasterSkill(data)
  self:Notify(ServiceEvent.SkillSwitchMasterSkill, data)
end

function ServiceSkillAutoProxy:RecvUpdateInheritSkillCmd(data)
  self:Notify(ServiceEvent.SkillUpdateInheritSkillCmd, data)
end

function ServiceSkillAutoProxy:RecvLoadInheritSkillCmd(data)
  self:Notify(ServiceEvent.SkillLoadInheritSkillCmd, data)
end

function ServiceSkillAutoProxy:RecvExtendInheritSkillCmd(data)
  self:Notify(ServiceEvent.SkillExtendInheritSkillCmd, data)
end

function ServiceSkillAutoProxy:RecvSyncBlockMasterSkill(data)
  self:Notify(ServiceEvent.SkillSyncBlockMasterSkill, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.SkillReqSkillData = "ServiceEvent_SkillReqSkillData"
ServiceEvent.SkillSkillUpdate = "ServiceEvent_SkillSkillUpdate"
ServiceEvent.SkillLevelupSkill = "ServiceEvent_SkillLevelupSkill"
ServiceEvent.SkillEquipSkill = "ServiceEvent_SkillEquipSkill"
ServiceEvent.SkillResetSkill = "ServiceEvent_SkillResetSkill"
ServiceEvent.SkillSkillValidPos = "ServiceEvent_SkillSkillValidPos"
ServiceEvent.SkillChangeSkillCmd = "ServiceEvent_SkillChangeSkillCmd"
ServiceEvent.SkillUpSkillInfoSkillCmd = "ServiceEvent_SkillUpSkillInfoSkillCmd"
ServiceEvent.SkillSelectRuneSkillCmd = "ServiceEvent_SkillSelectRuneSkillCmd"
ServiceEvent.SkillMarkSkillNpcSkillCmd = "ServiceEvent_SkillMarkSkillNpcSkillCmd"
ServiceEvent.SkillTriggerSkillNpcSkillCmd = "ServiceEvent_SkillTriggerSkillNpcSkillCmd"
ServiceEvent.SkillSkillOptionSkillCmd = "ServiceEvent_SkillSkillOptionSkillCmd"
ServiceEvent.SkillDynamicSkillCmd = "ServiceEvent_SkillDynamicSkillCmd"
ServiceEvent.SkillUpdateDynamicSkillCmd = "ServiceEvent_SkillUpdateDynamicSkillCmd"
ServiceEvent.SkillSyncDestPosSkillCmd = "ServiceEvent_SkillSyncDestPosSkillCmd"
ServiceEvent.SkillResetTalentSkillCmd = "ServiceEvent_SkillResetTalentSkillCmd"
ServiceEvent.SkillMultiSkillOptionUpdateSkillCmd = "ServiceEvent_SkillMultiSkillOptionUpdateSkillCmd"
ServiceEvent.SkillMultiSkillOptionSyncSkillCmd = "ServiceEvent_SkillMultiSkillOptionSyncSkillCmd"
ServiceEvent.SkillSkillEffectSkillCmd = "ServiceEvent_SkillSkillEffectSkillCmd"
ServiceEvent.SkillSyncSkillEffectSkillCmd = "ServiceEvent_SkillSyncSkillEffectSkillCmd"
ServiceEvent.SkillMaskSkillRandomOneSkillCmd = "ServiceEvent_SkillMaskSkillRandomOneSkillCmd"
ServiceEvent.SkillStopBossSkillUsageSkillCmd = "ServiceEvent_SkillStopBossSkillUsageSkillCmd"
ServiceEvent.SkillChangeAutoShortCutCmd = "ServiceEvent_SkillChangeAutoShortCutCmd"
ServiceEvent.SkillClearOptionSkillCmd = "ServiceEvent_SkillClearOptionSkillCmd"
ServiceEvent.SkillSyncBulletNumSkillCmd = "ServiceEvent_SkillSyncBulletNumSkillCmd"
ServiceEvent.SkillStopSniperModeSkillCmd = "ServiceEvent_SkillStopSniperModeSkillCmd"
ServiceEvent.SkillJudgeChantResultSkillCmd = "ServiceEvent_SkillJudgeChantResultSkillCmd"
ServiceEvent.SkillSkillPerceptAbilityLvUpCmd = "ServiceEvent_SkillSkillPerceptAbilityLvUpCmd"
ServiceEvent.SkillSkillPerceptAbilityNtf = "ServiceEvent_SkillSkillPerceptAbilityNtf"
ServiceEvent.SkillSetCastPosSkillCmd = "ServiceEvent_SkillSetCastPosSkillCmd"
ServiceEvent.SkillMarkSunMoonSkillCmd = "ServiceEvent_SkillMarkSunMoonSkillCmd"
ServiceEvent.SkillTriggerKickSkillSkillCmd = "ServiceEvent_SkillTriggerKickSkillSkillCmd"
ServiceEvent.SkillTimeDiskSkillCmd = "ServiceEvent_SkillTimeDiskSkillCmd"
ServiceEvent.SkillUseSkillSuccessSync = "ServiceEvent_SkillUseSkillSuccessSync"
ServiceEvent.SkillUpdateMasterSkill = "ServiceEvent_SkillUpdateMasterSkill"
ServiceEvent.SkillUpdateMasterSkillEquip = "ServiceEvent_SkillUpdateMasterSkillEquip"
ServiceEvent.SkillSwitchMasterSkill = "ServiceEvent_SkillSwitchMasterSkill"
ServiceEvent.SkillUpdateInheritSkillCmd = "ServiceEvent_SkillUpdateInheritSkillCmd"
ServiceEvent.SkillLoadInheritSkillCmd = "ServiceEvent_SkillLoadInheritSkillCmd"
ServiceEvent.SkillExtendInheritSkillCmd = "ServiceEvent_SkillExtendInheritSkillCmd"
ServiceEvent.SkillSyncBlockMasterSkill = "ServiceEvent_SkillSyncBlockMasterSkill"
