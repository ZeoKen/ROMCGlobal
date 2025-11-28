BTPlayerTriggerCollector = class("BTPlayerTriggerCollector", BTService)
BTPlayerTriggerCollector.TypeName = "PlayerTriggerCollector"
BTDefine.RegisterService(BTPlayerTriggerCollector.TypeName, BTPlayerTriggerCollector)
local StatNames = {
  UserCount = 1,
  FoundMe = 2,
  MeStayDuration = 3,
  FoundMeInGroup = 4,
  FoundGroup = 5,
  GroupStayDuration = 6,
  MeHandInHand = 7,
  AnyHandInHand = 8,
  MeFirstIn = 9,
  MeFirstOut = 10,
  UserGuids = 1001,
  HandInHandGuids = 1002
}
BTPlayerTriggerCollector.StatNames = StatNames
BTDefine.RegisterBlackBoardOption(BTPlayerTriggerCollector.TypeName, StatNames)
local TableClear = TableUtility.TableClear
local ArrayClear = TableUtility.ArrayClear

function BTPlayerTriggerCollector:ctor(config)
  BTPlayerTriggerCollector.super.ctor(self, config)
  self.groupRange = config.groupRange or 0
  self.collider = BTCollider.CreateColliderWithConfig(config.collider)
  self.stats = {
    [StatNames.UserCount] = 0,
    [StatNames.FoundMe] = 0,
    [StatNames.MeStayDuration] = 0,
    [StatNames.FoundMeInGroup] = 0,
    [StatNames.FoundGroup] = 0,
    [StatNames.GroupStayDuration] = 0,
    [StatNames.MeHandInHand] = 0,
    [StatNames.AnyHandInHand] = 0,
    [StatNames.MeFirstIn] = 0,
    [StatNames.MeFirstOut] = 0,
    [StatNames.UserGuids] = {},
    [StatNames.HandInHandGuids] = {}
  }
end

function BTPlayerTriggerCollector:Dispose()
end

function BTPlayerTriggerCollector:GetStatValue(key)
  return key and self.stats[key] or 0
end

function BTPlayerTriggerCollector:GetUserCount()
  return self:GetStatValue(StatNames.UserCount)
end

function BTPlayerTriggerCollector:CheckStat(key, val)
  val = val or 0
  return val < self:GetStatValue(key)
end

function BTPlayerTriggerCollector:FoundMe()
  return self:GetStatValue(StatNames.FoundMe) > 0
end

function BTPlayerTriggerCollector:MeHandInHand()
  return self:GetStatValue(StatNames.MeHandInHand) > 0
end

local tempPos, tempPos2
local heightOffset = 0

function BTPlayerTriggerCollector:Exec(time, deltaTime, context)
  if not context then
    return 1
  end
  local bb = context.blackboard
  if not bb then
    return 1
  end
  local proxy = NSceneUserProxy.Instance
  if not proxy then
    return 1
  end
  local userMap = proxy.userMap
  if not userMap then
    return 1
  end
  local stats = self.stats
  local userGuids = stats[StatNames.UserGuids]
  TableClear(userGuids)
  local handInHandGuids = stats[StatNames.HandInHandGuids]
  TableClear(handInHandGuids)
  local userCount = 0
  local foundMeInGroup = 0
  local foundGroup = 0
  local meHandInHand = 0
  local anyHandInHand = 0
  local foundMe = 0
  local collider = self.collider
  local groupRangeSqr = self.groupRange * self.groupRange
  local myself = Game.Myself
  local guid = myself.data.id
  local pos = myself:GetPosition()
  tempPos = tempPos or LuaVector3.Zero()
  tempPos2 = tempPos2 or LuaVector3.Zero()
  LuaVector3.Better_Set(tempPos, pos[1], pos[2] + heightOffset, pos[3])
  local followId = myself:Client_GetFollowLeaderID()
  local isHandFollow = myself:Client_IsFollowHandInHand()
  local handFollowerId = myself:Client_GetHandInHandFollower()
  local handTargetId = isHandFollow and followId or handFollowerId
  if collider:ContainsPoint(tempPos) then
    userCount = userCount + 1
    userGuids[guid] = 1
    foundMe = 1
    if handTargetId and handTargetId ~= 0 then
      meHandInHand = 1
      anyHandInHand = 1
      handInHandGuids[guid] = 1
      handInHandGuids[handTargetId] = 1
    end
    if 0 < groupRangeSqr then
      for _, v in pairs(userMap) do
        if v ~= myself then
          pos = v:GetPosition()
          LuaVector3.Better_Set(tempPos2, pos[1], pos[2] + heightOffset, pos[3])
          if groupRangeSqr > LuaVector3.Distance_Square(tempPos, tempPos2) then
            foundGroup = foundGroup + 1
            foundMeInGroup = foundMeInGroup + 1
          end
        end
      end
    end
  end
  for _, v in pairs(userMap) do
    guid = v.data.id
    pos = v:GetPosition()
    LuaVector3.Better_Set(tempPos, pos[1], pos[2] + heightOffset, pos[3])
    if collider:ContainsPoint(tempPos) then
      userCount = userCount + 1
      userGuids[guid] = 1
      if 0 < groupRangeSqr then
        pos = myself:GetPosition()
        LuaVector3.Better_Set(tempPos2, pos[1], pos[2] + heightOffset, pos[3])
        if groupRangeSqr > LuaVector3.Distance_Square(tempPos, tempPos2) then
          foundGroup = foundGroup + 1
          foundMeInGroup = foundMeInGroup + 1
        end
        for _, nv in pairs(userMap) do
          if nv ~= v and nv ~= myself then
            pos = nv:GetPosition()
            LuaVector3.Better_Set(tempPos2, pos[1], pos[2] + heightOffset, pos[3])
            if groupRangeSqr > LuaVector3.Distance_Square(tempPos, tempPos2) then
              foundGroup = foundGroup + 1
            end
          end
        end
      end
      if handTargetId and handTargetId == guid then
        meHandInHand = 1
        anyHandInHand = 1
        handInHandGuids[guid] = 1
        handInHandGuids[myself.data.id] = 1
      end
    end
  end
  local lastFoundMe = stats[StatNames.FoundMe]
  if lastFoundMe == 0 and 0 < foundMe then
    stats[StatNames.MeFirstIn] = 1
  else
    stats[StatNames.MeFirstIn] = 0
  end
  if 0 < lastFoundMe and foundMe == 0 then
    stats[StatNames.MeFirstOut] = 1
  else
    stats[StatNames.MeFirstOut] = 0
  end
  stats[StatNames.FoundMe] = foundMe
  stats[StatNames.UserCount] = userCount
  stats[StatNames.FoundMeInGroup] = foundMeInGroup
  stats[StatNames.FoundGroup] = foundGroup
  if 0 < foundMe then
    stats[StatNames.MeStayDuration] = (stats[StatNames.MeStayDuration] or 0) + deltaTime
  else
    stats[StatNames.MeStayDuration] = 0
  end
  if 0 < foundGroup then
    stats[StatNames.GroupStayDuration] = (stats[StatNames.GroupStayDuration] or 0) + deltaTime
  else
    stats[StatNames.GroupStayDuration] = 0
  end
  stats[StatNames.MeHandInHand] = meHandInHand
  stats[StatNames.AnyHandInHand] = anyHandInHand
  bb[self.name] = self.stats
  return 0
end
