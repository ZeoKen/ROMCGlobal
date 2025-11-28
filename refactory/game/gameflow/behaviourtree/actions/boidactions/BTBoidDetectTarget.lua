BTBoidDetectTarget = class("BTBoidDetectTarget", BTTargetAction)
BTBoidDetectTarget.TypeName = "BoidDetectTarget"
BTDefine.RegisterAction(BTBoidDetectTarget.TypeName, BTBoidDetectTarget)
local EmptyArray = {}

function BTBoidDetectTarget:ctor(config)
  BTBoidDetectTarget.super.ctor(self, config)
  self.goalService = config.goalService
  self.goalBBKey = config.goalBBKey
  self.obstacleService = config.obstacleService
  self.obstacleBBKey = config.obstacleBBKey
  self.goalGuids = {}
  self.obstacleGuids = {}
end

function BTBoidDetectTarget:Dispose()
  BTBoidDetectTarget.super.Dispose(self)
end

function BTBoidDetectTarget:Exec(time, deltaTime, context)
  local ret = BTBoidDetectTarget.super.Exec(self, time, deltaTime, context)
  if ret ~= 0 then
    return ret
  end
  if not self.boidGroups then
    self.boidGroups = self.target:GetComponentsInChildren(BoidGroup)
    if not self.boidGroups or #self.boidGroups == 0 then
      self.enabled = false
      return 1
    end
  end
  if not context then
    return 0
  end
  local bb = context.blackboard
  if not bb then
    return 0
  end
  local serviceData, guids
  serviceData = bb[self.goalService]
  if serviceData then
    guids = serviceData[self.goalBBKey]
    self:UpdateGoals(guids)
  end
  serviceData = bb[self.obstacleService]
  if serviceData then
    guids = serviceData[self.obstacleBBKey]
    self:UpdateObstacles(guids)
  end
  return 0
end

function BTBoidDetectTarget:GetUserTransform(guid)
  local creature = NSceneUserProxy.Instance:Find(guid)
  if not creature then
    return
  end
  local role = creature:GetRoleComplete()
  if not role then
    return
  end
  return role.transform
end

function BTBoidDetectTarget:AddGoal(guid)
  local transform = self:GetUserTransform(guid)
  if not transform then
    return
  end
  for _, boidGroup in ipairs(self.boidGroups) do
    boidGroup:AddGoal(transform)
  end
end

function BTBoidDetectTarget:RemoveGoal(guid)
  local transform = self:GetUserTransform(guid)
  if not transform then
    return
  end
  for _, boidGroup in ipairs(self.boidGroups) do
    boidGroup:RemoveGoal(transform)
  end
end

function BTBoidDetectTarget:AddObstacle(guid)
  local transform = self:GetUserTransform(guid)
  if not transform then
    return
  end
  for _, boidGroup in ipairs(self.boidGroups) do
    boidGroup:AddObstacle(transform)
  end
end

function BTBoidDetectTarget:RemoveObstacle(guid)
  local transform = self:GetUserTransform(guid)
  if not transform then
    return
  end
  for _, boidGroup in ipairs(self.boidGroups) do
    boidGroup:RemoveObstacle(transform)
  end
end

function BTBoidDetectTarget:UpdateGoals(guids)
  guids = guids or EmptyArray
  for id, _ in pairs(self.goalGuids) do
    if not guids[id] then
      self:RemoveGoal(id)
      self.goalGuids[id] = nil
    end
  end
  for id, _ in pairs(guids) do
    if not self.goalGuids[id] then
      self:AddGoal(id)
      self.goalGuids[id] = 1
    end
  end
end

function BTBoidDetectTarget:UpdateObstacles(guids)
  guids = guids or EmptyArray
  for id, _ in pairs(self.obstacleGuids) do
    if not guids[id] then
      self:RemoveObstacle(id)
      self.obstacleGuids[id] = nil
    end
  end
  for id, _ in pairs(guids) do
    if not self.obstacleGuids[id] then
      self:AddObstacle(id)
      self.obstacleGuids[id] = 1
    end
  end
end
