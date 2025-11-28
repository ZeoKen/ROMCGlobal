autoImport("HomeSkadaDamageMonitor")
HomeSkadaManager = class("HomeSkadaManager")

function HomeSkadaManager.Me()
  if not HomeSkadaManager.me then
    HomeSkadaManager.me = HomeSkadaManager.new()
  end
  return HomeSkadaManager.me
end

function HomeSkadaManager:ctor()
  EventManager.Me():AddEventListener(ServiceEvent.PlayerSkillBroadcast, self.OnReceiveSkillDamageData, self)
  EventManager.Me():AddEventListener(ServiceEvent.UserEventBuffDamageUserEvent, self.OnReceiveBuffDamageData, self)
  EventManager.Me():AddEventListener(HomeEvent.SkadaRecordOver, self.OnForceStopRecord, self)
  self.skadaDamageMonitors = {}
end

function HomeSkadaManager:OnReceiveSkillDamageData(data)
  local phaseData = data and data.data
  local skillStaticData = phaseData.skillID and Table_Skill[phaseData.skillID]
  local damageType = skillStaticData and (skillStaticData.RollType or CommonFun.RollType.Attack) or DamageMonitorType.Other
  if next(self.skadaDamageMonitors) and phaseData and phaseData.data and phaseData.data.hitedTargets then
    local isSelf = false
    if phaseData.charid == Game.Myself.data.id then
      isSelf = true
    else
      local skillCaster = SceneCreatureProxy.FindCreature(phaseData and phaseData.charid)
      isSelf = skillCaster and skillCaster.data and skillCaster.data.ownerID == Game.Myself.data.id
    end
    if isSelf then
      local hittargets = phaseData.data.hitedTargets
      local hit, sharehit
      for i = 1, #hittargets do
        hit = hittargets[i]
        if hit.damage >= 0 and self.skadaDamageMonitors[hit.charid] then
          self.skadaDamageMonitors[hit.charid]:AddDamage(damageType, hit.damage)
        end
        for j = 1, #hit.shareTargets do
          sharehit = hit.shareTargets[j]
          if sharehit.damage >= 0 and self.skadaDamageMonitors[sharehit.charid] then
            self.skadaDamageMonitors[sharehit.charid]:AddDamage(damageType, sharehit.damage)
          end
        end
      end
    end
  end
end

function HomeSkadaManager:OnReceiveBuffDamageData(data)
  local damageData = data and data.data
  if damageData and self.skadaDamageMonitors[damageData.charid] and damageData.fromid == Game.Myself.data.id then
    self.skadaDamageMonitors[damageData.charid]:AddDamage(DamageMonitorType.Other, damageData.damage)
  end
end

function HomeSkadaManager:OnForceStopRecord(data)
  local skadaMonitor = self.skadaDamageMonitors and data.data and self.skadaDamageMonitors[data.data]
  if skadaMonitor then
    skadaMonitor:ResetMonitor()
  end
end

function HomeSkadaManager:EnterEditMode()
end

function HomeSkadaManager:ExitEditMode()
end

function HomeSkadaManager:GetSkadaMonitor(id)
  return self.skadaDamageMonitors and self.skadaDamageMonitors[id]
end

function HomeSkadaManager:RemoveSkadaMonitor(npc)
  if not npc then
    for _, v in self.skadaDamageMonitors, nil, nil do
      v:OnRemove()
    end
    TableUtility.TableClear(self.skadaDamageMonitors)
    return
  end
  local mo = self.skadaDamageMonitors[npc.data.id]
  if mo then
    mo:OnRemove()
    self.skadaDamageMonitors[npc.data.id] = nil
  end
end

function HomeSkadaManager:CreateSkadaMonitor(npc)
  if not npc then
    return
  end
  local mo = self.skadaDamageMonitors[npc.data.id]
  if mo then
    mo:ResetMonitor()
  else
    self.skadaDamageMonitors[npc.data.id] = HomeSkadaDamageMonitor.new()
  end
end
