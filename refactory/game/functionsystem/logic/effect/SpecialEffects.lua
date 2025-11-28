ViewRangeEffect = reusableClass("ViewRangeEffect")
ViewRangeEffect.PoolSize = 10

function ViewRangeEffect:ShowRange(range)
  self[4] = range
  if Slua.IsNull(self[3]) == false then
    local smooth = self[3]
    smooth.radius = self[4]
    smooth:SmoothSet()
  end
end

function ViewRangeEffect:SetEffectGO(go)
  local smooth = go:GetComponent(CircleDrawerSmooth)
  self[3] = smooth
  if self[4] and Slua.IsNull(smooth) == false then
    smooth.radius = self[4]
    smooth:SmoothSet()
  end
end

function ViewRangeEffect.OnEffectCreated(eObj, instance, assetEffect)
  if not instance then
    return
  end
  instance[2] = assetEffect
  instance:SetEffectGO(eObj)
  local followCreature = SceneCreatureProxy.FindCreature(instance[1])
  if followCreature then
    followCreature:Client_RegisterFollow(eObj.transform, nil, nil, ViewRangeEffect.OnEffectLostFollow, instance)
  end
end

function ViewRangeEffect.OnEffectLostFollow(transform, instance)
  if Slua.IsNull(instance[3]) == false then
    Game.RoleFollowManager:UnregisterFollow(instance[3].transform)
  end
end

function ViewRangeEffect:DoConstruct(asArray, creatureID)
  self[1] = creatureID
  self[2] = Asset_Effect.PlayAtXYZ(EffectMap.Maps.VisionScope, 0, 0, 0, self.OnEffectCreated, self)
end

function ViewRangeEffect:DoDeconstruct(asArray)
  self[1] = nil
  if self[2] then
    self[2]:Destroy()
  end
  self[2] = nil
  self[3] = nil
  self[4] = nil
end

TrackEffect = reusableClass("TrackEffect")
TrackEffect.PoolSize = 10

function TrackEffect:Spawn(path, pos, isStatic, callBack)
  self.assetEffect = Asset_Effect.PlayAtXYZ(path, pos[1], pos[2], pos[3])
  self.assetEffect:RegisterWeakObserver(self)
end

function TrackEffect:ObserverDestroyed(obj)
  if obj == self.assetEffect then
    self.assetEffect = nil
  end
end

function TrackEffect:GetLocalPosition()
  if self.assetEffect then
    return self.assetEffect:GetLocalPosition()
  end
end

function TrackEffect:ResetLocalPosition(p)
  if self.assetEffect then
    self.assetEffect:ResetLocalPosition(p)
  end
end

function TrackEffect:SetHitCall(call, arg1, arg2)
  self.callback = call
  self.callback_arg1 = arg1
  self.callback_arg2 = arg2
end

function TrackEffect:SetSpeed(s)
  self.speed = s
end

function TrackEffect:SetBezierRadius(radius, limitUp)
  if not self.bezierStartTangent then
    local curPos = self:GetLocalPosition()
    self.bezierStart = LuaVector3.New(curPos[1], curPos[2], curPos[3])
    local y
    if limitUp then
      y = math.random(0, radius)
    else
      y = math.random(radius * -1, radius)
    end
    self.bezierStartTangent = LuaVector3.New(curPos[1] + math.random(radius * -1, radius), curPos[2] + y, curPos[3] + math.random(radius * -1, radius))
  end
end

function TrackEffect:GetSpeed()
  return self.speed
end

function TrackEffect:Hit()
  if self.callback then
    self.callback(self, self.callback_arg1, self.callback_arg2)
  end
end

function TrackEffect:SetEndPostion(p)
  LuaVector3.Better_Set(self.endPos, p[1], p[2], p[3])
end

function TrackEffect:GetEndPostion()
  return self.endPos
end

local Better_MoveTowards = LuaVector3.Better_MoveTowards
local Better_Bezier = VectorUtility.Better_Bezier
local tempVector3 = LuaVector3.Zero()

function TrackEffect:Update(time, deltaTime)
  if not self.assetEffect then
    return false
  end
  if self.bezierStart then
    if not self.progress then
      self.progress = 1 * deltaTime
    else
      self.progress = self.progress + self.speed * deltaTime / 10
    end
    if self.progress > 1 then
      self.progress = 1
    end
    Better_Bezier(self.bezierStart, self.bezierStartTangent, self.endPos, tempVector3, self.progress)
  else
    Better_MoveTowards(self.assetEffect:GetLocalPosition(), self.endPos, tempVector3, self.speed * deltaTime)
  end
  if VectorUtility.AlmostEqual_3(tempVector3, self.endPos) then
    self:Hit()
    return false
  end
  self:ResetLocalPosition(tempVector3)
  return true
end

function TrackEffect:DoConstruct(asArray, effectPath)
  self.speed = 0
  self.endPos = LuaVector3.Zero()
end

function TrackEffect:DoDeconstruct(asArray)
  if self.assetEffect then
    self.assetEffect:Destroy()
    self.assetEffect = nil
  end
  if self.endPos then
    self.endPos:Destroy()
    self.endPos = nil
  end
  if self.bezierStart then
    self.bezierStart:Destroy()
    self.bezierStart = nil
  end
  if self.bezierStartTangent then
    self.bezierStartTangent:Destroy()
    self.bezierStartTangent = nil
  end
  self.progress = nil
  self.callback = nil
  self.callback_arg1 = nil
  self.callback_arg2 = nil
end
