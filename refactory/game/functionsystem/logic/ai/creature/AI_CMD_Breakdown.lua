AI_CMD_Breakdown = {}

function AI_CMD_Breakdown:ResetArgs(args)
  self.args[1] = args[2]
  self.times = {}
  self.played = {}
end

function AI_CMD_Breakdown:Construct(args)
  self.args[1] = args[2]
  self.effect = {}
  return 1
end

function AI_CMD_Breakdown:Deconstruct()
  AI_CMD_Breakdown.ClearLoopEffect(self)
end

function AI_CMD_Breakdown:Start(time, deltaTime, creature)
  self.BalanceConfig = creature.data:GetBalanceConfig()
  if not self.BalanceConfig then
    return false
  end
  local userdata = creature.data.userdata
  local curbodyID = userdata:Get(UDEnum.BODY)
  local AnimationTime = self.BalanceConfig.AnimationTime
  local times = AnimationTime[curbodyID]
  if not times then
    return false
  end
  local passedTime = creature.data:GetPassedBreakTime() or 0
  self.endtime = time - passedTime / 1000 + self.args[1]
  self.played = {
    false,
    false,
    false
  }
  self.times = {}
  self.times[1] = times[1] / 1000 + time
  self.times[3] = times[2] / 1000 + time
  self.times[2] = self.args[1] - (times[1] + times[2]) / 1000 + time
  return true
end

function AI_CMD_Breakdown:PlayStiffEffect(stage, effectConfig, creature)
  if effectConfig then
    for _, config in pairs(effectConfig) do
      local effect = creature:PlayStiffEffect(config[1], config[2], config.loop)
      if config.loop then
        if not self.effect[stage] then
          self.effect[stage] = {}
        end
        local list = self.effect[stage]
        list[#list + 1] = effect
      end
    end
  end
end

function AI_CMD_Breakdown:ClearLoopEffect(stage)
  if self.effect then
    for s, effectlist in pairs(self.effect) do
      if not stage or stage == s then
        for i = #effectlist, 1, -1 do
          if effectlist[i] then
            effectlist[i]:Destroy()
            effectlist[i] = nil
          end
        end
      end
    end
  end
end

function AI_CMD_Breakdown:End(time, deltaTime, creature)
  AI_CMD_Breakdown.ClearLoopEffect(self)
end

function AI_CMD_Breakdown:Update(time, deltaTime, creature)
  local BreakdownActions = self.BalanceConfig.BreakdownAction
  if time < self.times[1] and not self.played[1] then
    self.played[1] = true
    local params = Asset_Role.GetPlayActionParams(BreakdownActions[1])
    params[8] = self.instanceID
    self.args[10] = creature:Logic_PlayAction(params)
    local effectConfig = self.BalanceConfig.BreakEffect[1]
    AI_CMD_Breakdown.PlayStiffEffect(self, 1, effectConfig, creature)
    if self.BalanceConfig.BreakAudioEffect then
      creature.assetRole:PlaySEOneShotOn(self.BalanceConfig.BreakAudioEffect)
    end
  elseif time > self.times[1] and time < self.times[2] and not self.played[2] then
    self.played[2] = true
    local params = Asset_Role.GetPlayActionParams(BreakdownActions[2])
    creature:Logic_PlayAction(params)
    AI_CMD_Breakdown.ClearLoopEffect(self, 1)
    local effectConfig = self.BalanceConfig.BreakEffect[2]
    AI_CMD_Breakdown.PlayStiffEffect(self, 2, effectConfig, creature)
  elseif time > self.times[2] and not self.played[3] then
    self.played[3] = true
    local params = Asset_Role.GetPlayActionParams(BreakdownActions[3])
    creature.assetRole:PlayAction(params)
    local effectConfig = self.BalanceConfig.BreakEffect[3]
    AI_CMD_Breakdown.ClearLoopEffect(self, 2)
    AI_CMD_Breakdown.PlayStiffEffect(self, 3, effectConfig, creature)
  elseif time >= self.endtime and not self.played[4] then
    self.played[4] = true
    local effectConfig = self.BalanceConfig.BreakEffect[4]
    AI_CMD_Breakdown.ClearLoopEffect(self, 3)
    AI_CMD_Breakdown.PlayStiffEffect(self, 4, effectConfig, creature)
  end
end

function AI_CMD_Breakdown.ToString()
  return "AI_CMD_Breakdown", AI_CMD_Breakdown
end
