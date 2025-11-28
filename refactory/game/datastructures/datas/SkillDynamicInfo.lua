SkillDynamicInfo = class("SkillDynamicInfo")

function SkillDynamicInfo:ctor()
  self.costs = nil
  self.props = nil
  self.targetRange = 0
  self.targetNumChange = 0
  self.changeready = 0
  self.isNoItem = false
  self.spotter = 0
  self.maxspper = 0
  self.isNoCheck = false
  self.isNoBuff = false
  self._hasItemCostChange = false
  self.cd_times = nil
end

function SkillDynamicInfo:SetServerInfo(serverData)
  if serverData ~= nil then
    self:Server_SetProps(serverData.attrs)
    self:Server_SetCosts(serverData.cost)
    if serverData.changerange then
      self:Server_SetTargetRange(serverData.changerange / 1000)
    end
    if serverData.changenum then
      self:Server_SetTargetNumChange(serverData.changenum)
    end
    if serverData.changeready then
      self:Server_SetChangeReady(serverData.changeready)
    end
    self:Server_SetNoItem(serverData.neednoitem)
    if serverData.spotter then
      self:Server_SetSpotter(serverData.spotter)
    end
    if serverData.maxspper then
      self:Server_SetMaxSpPer(serverData.maxspper)
    end
    self:Server_SetNoCheck(serverData.neednocheck)
    self:Server_SetNoBuff(serverData.neednobuff)
    self:Server_SetTrapFollowSpeed(serverData.trap_follow_speed)
    self:Server_SetChantCanUseSkillIDs(serverData.chant_can_use_skill)
    self.cd_times = serverData.cd_times
  end
end

function SkillDynamicInfo:Server_SetProps(serverAttrs)
  if self.props == nil then
    self.props = RolePropsContainer.new()
  end
  local props = self.props
  local sdata
  for i = 1, #serverAttrs do
    sdata = serverAttrs[i]
    if sdata ~= nil then
      props:SetValueById(sdata.type, sdata.value)
    end
  end
end

function SkillDynamicInfo:Server_SetCosts(costs)
  if self.costs == nil then
    self.costs = {}
  end
  local cost, serverCost
  for i = 1, #costs do
    serverCost = costs[i]
    cost = self.costs[serverCost.itemid]
    if cost == nil then
      cost = {}
      self.costs[serverCost.itemid] = cost
    end
    self._hasItemCostChange = true
    cost[1] = serverCost.itemid
    cost[2] = serverCost.changenum
    cost[3] = serverCost.changeper / 1000
    cost[4] = serverCost.type
  end
end

function SkillDynamicInfo:Server_SetTargetRange(range)
  self.targetRange = range
end

function SkillDynamicInfo:GetTargetRange()
  return self.targetRange
end

function SkillDynamicInfo:Server_SetChangeReady(changeready)
  self.changeready = changeready / 1000
end

function SkillDynamicInfo:GetChangeReady()
  return self.changeready
end

function SkillDynamicInfo:Server_SetTargetNumChange(change)
  self.targetNumChange = change
end

function SkillDynamicInfo:GetTargetNumChange()
  return self.targetNumChange
end

function SkillDynamicInfo:Server_SetNoItem(neednoitem)
  self.isNoItem = neednoitem
end

function SkillDynamicInfo:GetIsNoItem()
  return self.isNoItem
end

function SkillDynamicInfo:Server_SetSpotter(spotter)
  self.spotter = spotter / 1000
end

function SkillDynamicInfo:GetSpotter()
  return self.spotter
end

function SkillDynamicInfo:Server_SetMaxSpPer(maxspper)
  self.maxspper = maxspper / 1000
end

function SkillDynamicInfo:GetMaxSpPer()
  return self.maxspper
end

function SkillDynamicInfo:Server_SetNoCheck(neednocheck)
  self.isNoCheck = neednocheck
end

function SkillDynamicInfo:GetIsNoCheck()
  return self.isNoCheck
end

function SkillDynamicInfo:Server_SetNoBuff(neednobuff)
  self.isNoBuff = neednobuff
end

function SkillDynamicInfo:GetIsNoBuff()
  return self.isNoBuff
end

function SkillDynamicInfo:HasItemCostChange()
  return self._hasItemCostChange
end

function SkillDynamicInfo:GetItemNewCost(itemid, originCost)
  if self.isNoItem then
    return 0
  end
  if self.costs ~= nil then
    local cost = self.costs[itemid]
    if cost then
      return math.floor(math.max(0, (originCost + cost[2]) * (1 + cost[3])))
    end
  end
  return originCost
end

function SkillDynamicInfo:GetBuffNewCost(buffid, originCost)
  if self.isNoBuff then
    return 0
  end
  if self.costs ~= nil then
    local cost = self.costs[buffid]
    if cost then
      return math.floor(math.max(0, (originCost + cost[2]) * (1 + cost[3])))
    end
  end
  return originCost
end

function SkillDynamicInfo:Client_SetNoItem(neednoitem)
  self.client_isNoItem = neednoitem
end

function SkillDynamicInfo:GetClientIsNoItem(neednoitem)
  return self.client_isNoItem
end

function SkillDynamicInfo:Server_SetTrapFollowSpeed(trap_follow_speed)
  self.trap_follow_speed = trap_follow_speed
end

function SkillDynamicInfo:GetTrapFollowSpeed()
  return self.trap_follow_speed
end

function SkillDynamicInfo:Server_SetChantCanUseSkillIDs(skills)
  if skills then
    if not self.chantCanUseSkillIDs then
      self.chantCanUseSkillIDs = {}
    else
      TableUtility.ArrayClear(self.chantCanUseSkillIDs)
    end
    TableUtility.ArrayShallowCopy(self.chantCanUseSkillIDs, skills)
  end
end

function SkillDynamicInfo:GetChantCanUseSkill()
  return self.chantCanUseSkillIDs
end

function SkillDynamicInfo:GetCdTimes()
  return self.cd_times
end
