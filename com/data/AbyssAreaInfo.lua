autoImport("AbyssMonsterInfo")
AbyssAreaInfo = class("AbyssAreaInfo")

function AbyssAreaInfo:ctor(areaID)
  self.areaID = areaID
  self:InitStepMonsters()
end

function AbyssAreaInfo:InitStepMonsters()
  local StaticConfig = Table_AbyssBoss[self.areaID]
  if not StaticConfig then
    redlog("AbyssAreaInfo:InitStepMonsters error, areaID not found", self.areaID)
    return
  end
  self.mvps = {}
  self.minis = {}
  local stepId = 0
  if StaticConfig.MonsterMVP then
    local infos = StaticConfig.MonsterMVP
    for i = 1, #infos do
      stepId = infos[i].mapstepid
      self.mvps[stepId] = AbyssMonsterInfo.new(stepId)
      self.mvps[stepId]:SetPos(infos[i].pos)
    end
  end
  if StaticConfig.MonsterMini then
    local infos = StaticConfig.MonsterMini
    for i = 1, #infos do
      stepId = infos[i].mapstepid
      self.minis[stepId] = AbyssMonsterInfo.new(stepId, infos[i].unique)
      self.minis[stepId]:SetPos(infos[i].pos)
    end
  end
end

function AbyssAreaInfo:UpdateBossProgress(boss_infos)
  if boss_infos then
    local infos = boss_infos
    local stepId = 0
    for i = 1, #infos do
      stepId = infos[i].mapstep_id
      if self.mvps[stepId] then
        self.mvps[stepId]:UpdateBossProgress(infos[i])
      elseif self.minis[stepId] then
        self.minis[stepId]:UpdateBossProgress(infos[i])
      else
        redlog("AbyssAreaInfo:UpdateBossProgress error, stepId not found", stepId)
      end
    end
  end
end

function AbyssAreaInfo:GetMvpMonsters()
  if not self.mvps then
    return {}
  end
  local result = {}
  for _, info in pairs(self.mvps) do
    result[#result + 1] = info
  end
  table.sort(result, function(a, b)
    return a.mapstepid < b.mapstepid
  end)
  return result
end

function AbyssAreaInfo:GetMiniMonsters()
  if not self.minis then
    return {}
  end
  local result = {}
  for _, info in pairs(self.minis) do
    result[#result + 1] = info
  end
  table.sort(result, function(a, b)
    return a.mapstepid < b.mapstepid
  end)
  return result
end

function AbyssAreaInfo:GetSummonProgress(mapStepId)
  if self.mvps and self.mvps[mapStepId] then
    return self.mvps[mapStepId]:GetSummonProgress()
  end
  if self.minis and self.minis[mapStepId] then
    return self.minis[mapStepId]:GetSummonProgress()
  end
  return nil
end
