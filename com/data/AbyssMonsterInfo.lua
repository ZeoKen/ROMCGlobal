AbyssMonsterInfo = class("AbyssMonsterInfo")

function AbyssMonsterInfo:ctor(mapstepid, unique)
  self.mapstepid = mapstepid
  self.unique = unique
end

function AbyssMonsterInfo:UpdateBossProgress(serverdata)
  self.npcID = serverdata.npcid
  self.summon_process = serverdata.summon_process
  if self.unique then
    local npcs = NSceneNpcProxy.Instance:FindNpcByUniqueId(self.unique)
    if npcs and npcs[1] then
      local npc = npcs[1]
      local roleTopUI = npc:GetSceneUI().roleTopUI
      if not roleTopUI then
        return
      end
      roleTopUI:UpdateSummonProgress(self.summon_process, self.npcID)
    end
  end
end

function AbyssMonsterInfo:SetPos(pos)
  self.pos = pos
end

function AbyssMonsterInfo:GetPos()
  return self.pos
end

function AbyssMonsterInfo:GetSummonProgress()
  return self.npcID, self.summon_process
end
