autoImport("ServiceSkillAutoProxy")
ServiceSkillProxy = class("ServiceSkillProxy", ServiceSkillAutoProxy)
ServiceSkillProxy.Instance = nil
ServiceSkillProxy.NAME = "ServiceSkillProxy"

function ServiceSkillProxy:ctor(proxyName)
  if ServiceSkillProxy.Instance == nil then
    self.proxyName = proxyName or ServiceSkillProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSkillProxy.Instance = self
  end
end

function ServiceSkillProxy:CallReqSkillData()
  if NetConfig.PBC then
    local msgId = ProtoReqInfoList.ReqSkillData.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  else
    local msg = SceneSkill_pb.ReqSkillData()
    self:SendProto(msg)
  end
end

local tempPos = {}

function ServiceSkillProxy:CallSyncDestPosSkillCmd(skillid, pos)
  ProtolUtility.C2S_Vector3(pos, tempPos)
  ServiceSkillProxy.super.CallSyncDestPosSkillCmd(self, skillid, tempPos)
end

function ServiceSkillProxy:RecvSkillValidPos(data)
  ShortCutProxy.Instance:UnLockSkillShortCuts(data)
  self:Notify(ServiceEvent.SkillSkillValidPos, data)
end

function ServiceSkillProxy:RecvChangeSkillCmd(data)
  local skillBuffs = MyselfProxy.Instance.myself.skillBuffs
  if data.isadd == 0 then
    skillBuffs:Remove(data.skillid, data.type, BuffConfig.changeskill, data.key)
  elseif data.isadd == 1 then
    skillBuffs:Add(data.skillid, data.type, BuffConfig.changeskill, data.key)
  end
  self:Notify(ServiceEvent.SkillChangeSkillCmd, data)
end

function ServiceSkillProxy:TakeOffSkill(skillid, sourceid, efrom, beingID)
  self:CallEquipSkill(skillid, 0, sourceid, efrom, SceneSkill_pb.ESKILLSHORTCUT_MIN, beingID)
end

function ServiceSkillProxy:RecvUpSkillInfoSkillCmd(data)
  SkillProxy.Instance:Server_UpdateDynamicSkillInfos(data)
  self:Notify(ServiceEvent.SkillUpSkillInfoSkillCmd, data)
end

function ServiceSkillProxy:RecvMarkSkillNpcSkillCmd(data)
  local npc = NSceneNpcProxy.Instance:Find(data.npcguid)
  if npc == nil then
    npc = NScenePetProxy.Instance:Find(data.npcguid)
  end
  if npc then
    npc:SetSkillNpc(Table_Skill[data.skillid])
  end
end

function ServiceSkillProxy:RecvTriggerSkillNpcSkillCmd(data)
  if data.etype == SceneSkill_pb.ETRIGTSKILL_BTRANS then
    Game.AreaTrigger_Skill:SkillTransport_ResumeSyncMove(true)
  end
end

function ServiceSkillProxy:RecvSkillOptionSkillCmd(data)
  Game.SkillOptionManager:RecvServerOpts(data.all_opts)
  self:Notify(ServiceEvent.SkillSkillOptionSkillCmd, data)
end

function ServiceSkillProxy:RecvDynamicSkillCmd(data)
  SkillProxy.Instance:UpdateTransformedSkills(data.skills)
  self:Notify(ServiceEvent.SkillDynamicSkillCmd, data)
end

function ServiceSkillProxy:RecvUpdateDynamicSkillCmd(data)
  SkillProxy.Instance:UpdateTransformedSkills(data.update, data.del)
  self:Notify(ServiceEvent.SkillUpdateDynamicSkillCmd, data)
end

function ServiceSkillProxy:RecvMultiSkillOptionSyncSkillCmd(data)
  Game.SkillOptionManager:RecvMultiSkillOptionSyncSkillCmd(data)
  EventManager.Me():PassEvent(ServiceEvent.SkillMultiSkillOptionSyncSkillCmd, data)
end

function ServiceSkillProxy:CallMultiSkillOptionUpdateSkillCmd(opt, value, values, guid, subvalues, datas, param1)
  local data = ReusableTable.CreateTable()
  data.opt = opt
  data.value = value
  data.values = values
  data.guid = guid
  data.subvalues = subvalues
  data.datas = datas
  data.param1 = param1
  ServiceSkillProxy.super.CallMultiSkillOptionUpdateSkillCmd(self, data)
  ReusableTable.DestroyAndClearTable(data)
end

function ServiceSkillProxy:RecvMultiSkillOptionUpdateSkillCmd(data)
  Game.SkillOptionManager:RecvMultiSkillOptionUpdateSkillCmd(data)
  EventManager.Me():PassEvent(ServiceEvent.SkillMultiSkillOptionUpdateSkillCmd, data)
end

function ServiceSkillProxy:RecvMaskSkillRandomOneSkillCmd(data)
  SkillProxy.Instance:SetRandomSkillID(data.randomskillid)
  self:Notify(ServiceEvent.SkillMaskSkillRandomOneSkillCmd, data)
end

function ServiceSkillProxy:RecvSyncSkillEffectSkillCmd(data)
  WarbandProxy.Instance:HandleSkillEff(data)
  self:Notify(ServiceEvent.SkillSyncSkillEffectSkillCmd, data)
end

function ServiceSkillProxy:RecvSkillEffectSkillCmd(data)
  local creature = NSceneUserProxy.Instance:Find(data.charid)
  if creature == nil then
    helplog("SkillEffectSkillCmd接收异常，请联系zyb", data.charid)
    return
  end
  local effect
  local _SkillDynamicManager = Game.SkillDynamicManager
  local dels = ReusableTable.CreateArray()
  local updates = ReusableTable.CreateArray()
  _SkillDynamicManager:Clear(data.charid)
  for i = 1, #data.effects do
    effect = data.effects[i]
    if effect.effect ~= 0 then
      updates[#updates + 1] = effect.id
    end
  end
  for i = 1, #updates do
    _SkillDynamicManager:AddDynamicEffect(data.charid, updates[i])
  end
  self:Notify(ServiceEvent.SkillSkillEffectSkillCmd, data)
  ReusableTable.DestroyAndClearArray(dels)
  ReusableTable.DestroyAndClearArray(updates)
end

function ServiceSkillProxy:RecvClearOptionSkillCmd(data)
  Game.SkillOptionManager:RecvClearSkillOption(data)
end

function ServiceSkillProxy:RecvSyncBulletNumSkillCmd(data)
  redlog("RecvSyncBulletNumSkillCmd", data.num)
  local ncreature = Game.Myself
  MyselfProxy.Instance:SetCurBullets(data.num)
  if not Game.Myself then
    return
  end
  local profession = ncreature.data.userdata:Get(UDEnum.PROFESSION)
  local myTypeBranch = ProfessionProxy.GetTypeBranchFromProf(profession)
  if myTypeBranch ~= 111 then
    return
  end
  newValue = data.num
  if newValue then
    local sceneUI = ncreature:GetSceneUI() or nil
    if sceneUI then
      sceneUI.roleBottomUI:UpdateBullets(newValue)
    end
    EventManager.Me():PassEvent(MyselfEvent.CurBulletsChange, ncreature)
  end
  self:Notify(ServiceEvent.SkillSyncBulletNumSkillCmd, data)
end

local CursorNpcs = GameConfig.CursorNpcs

function ServiceSkillProxy:RecvJudgeChantResultSkillCmd(data)
  if CursorNpcs then
    for i = 1, #CursorNpcs do
      local npcs = NSceneNpcProxy.Instance:FindNpcs(CursorNpcs[i])
      if npcs then
        for j = 1, #npcs do
          local role = npcs[j]
          role:GetSceneUI().roleTopUI:UpdateCursorInfo(data.cursorvalue, role)
        end
      end
    end
  end
  self:Notify(ServiceEvent.SkillJudgeChantResultSkillCmd, data)
end

function ServiceSkillProxy:RecvSkillPerceptAbilityLvUpCmd(data)
  xdlog("洞察技能升级callback")
  SevenRoyalFamiliesProxy.Instance:RecvSkillPerceptAbilityLvUpCmd(data)
  self:Notify(ServiceEvent.SkillSkillPerceptAbilityLvUpCmd, data)
end

function ServiceSkillProxy:RecvSkillPerceptAbilityNtf(data)
  xdlog("洞察技能参数")
  SevenRoyalFamiliesProxy.Instance:RecvSkillPerceptAbilityNtf(data)
  self:Notify(ServiceEvent.SkillSkillPerceptAbilityNtf, data)
end

function ServiceSkillProxy:RecvMarkSunMoonSkillCmd(data)
  SkillProxy.Instance:RecvMarkSunMoonSkillCmd(data.datas)
  self:Notify(ServiceEvent.SkillMarkSunMoonSkillCmd, data)
end

function ServiceSkillProxy:RecvTriggerKickSkillSkillCmd(data)
  Game.SkillComboManager:RecvTriggerKickSkillSkillCmd(data.skillid)
  self:Notify(ServiceEvent.SkillTriggerKickSkillSkillCmd, data)
end

function ServiceSkillProxy:RecvTimeDiskSkillCmd(data)
  redlog("RecvTimeDiskSkillCmd", data.sundisk, data.move, data.starttime)
  SkillProxy.Instance:RecvTimeDiskSkillCmd(data)
  self:Notify(ServiceEvent.SkillTimeDiskSkillCmd, data)
end

function ServiceSkillProxy:RecvUseSkillSuccessSync(data)
  SkillProxy.Instance:RecvUseSkillSuccessSync(data)
  self:Notify(ServiceEvent.SkillUseSkillSuccessSync, data)
end

function ServiceSkillProxy:RecvUpdateMasterSkill(data)
  SkillProxy.Instance:UpdateMasterSkill(data)
  self:Notify(ServiceEvent.SkillUpdateMasterSkill, data)
end

function ServiceSkillProxy:RecvUpdateMasterSkillEquip(data)
  SkillProxy.Instance:UpdateMasterSkillShortcuts(data.equip_skill_family_id, data.shortcuts)
  self:Notify(ServiceEvent.SkillUpdateMasterSkillEquip, data)
end

function ServiceSkillProxy:RecvUpdateInheritSkillCmd(data)
  InheritSkillProxy.Instance:UpdateInheritSkills(data.items)
  self:Notify(ServiceEvent.SkillUpdateInheritSkillCmd, data)
end

function ServiceSkillProxy:RecvExtendInheritSkillCmd(data)
  redlog("ServiceSkillProxy:RecvExtendInheritSkillCmd", tostring(data.extendpoints))
  InheritSkillProxy.Instance:UpdateExtendedCostPoints(data.extendpoints)
  self:Notify(ServiceEvent.SkillExtendInheritSkillCmd, data)
end

function ServiceSkillProxy:RecvSyncBlockMasterSkill(data)
  SkillProxy.Instance:SyncBlockMasterSkill(data.block_skills)
  self:Notify(ServiceEvent.SkillSyncBlockMasterSkill, data)
end
