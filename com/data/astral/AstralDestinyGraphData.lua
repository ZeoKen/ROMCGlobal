AstralDestinyGraphData = class("AstralDestinyGraphData")

function AstralDestinyGraphData:ctor(season)
  self.season = season
  self.points = {}
  self:InitPoints()
end

function AstralDestinyGraphData:InitPoints()
  if Game.AstralDestinyGraphSeasonPointMap and Game.AstralDestinyGraphSeasonPointMap[self.season] then
    for i = 1, #Game.AstralDestinyGraphSeasonPointMap[self.season] do
      local pointData = AstralDestinyGraphPointData.new(self.season, i, self)
      self.points[i] = pointData
    end
  end
end

function AstralDestinyGraphData:GetPointData(index)
  return self.points[index]
end

function AstralDestinyGraphData:GetFirstNoLightenPoint()
  for i = 1, #self.points do
    local pointData = self.points[i]
    if pointData:IsNoLighten() then
      return pointData
    end
  end
end

function AstralDestinyGraphData:GetLightenPointNum()
  local num = 0
  for i = 1, #self.points do
    if self.points[i]:IsLighten() then
      num = num + 1
    end
  end
  return num
end

function AstralDestinyGraphData:GetTotalPointNum()
  return #self.points
end

AstralDestinyGraphPointData = class("AstralDestinyGraphPointData")

function AstralDestinyGraphPointData:ctor(season, index, graph)
  self.season = season
  self.index = index
  self.staticData = Game.AstralDestinyGraphSeasonPointMap and Game.AstralDestinyGraphSeasonPointMap[season] and Game.AstralDestinyGraphSeasonPointMap[season][index]
  self.state = MessCCmd_pb.EGRAPH_POINT_STATE_LOCKED
  self.graph = graph
end

function AstralDestinyGraphPointData:SetState(state)
  self.state = state
end

function AstralDestinyGraphPointData:GetScale()
  if self.staticData and self.staticData.Scale then
    return self.staticData.Scale
  end
  return 1
end

function AstralDestinyGraphPointData:IsSpecialPoint()
  return self.staticData and self.staticData.IsSpecial == 1 or false
end

function AstralDestinyGraphPointData:IsLocked()
  return self.state == MessCCmd_pb.EGRAPH_POINT_STATE_LOCKED
end

function AstralDestinyGraphPointData:IsNoLighten()
  return self.state == MessCCmd_pb.EGRAPH_POINT_STATE_UNLOCKED
end

function AstralDestinyGraphPointData:IsLighten()
  return self.state == MessCCmd_pb.EGRAPH_POINT_STATE_LIGHT
end

function AstralDestinyGraphPointData:CanLighten()
  local firstNoLightenPoint = self.graph:GetFirstNoLightenPoint()
  return firstNoLightenPoint and firstNoLightenPoint.index == self.index or false
end

function AstralDestinyGraphPointData:GetBuffEffects()
  local buffEffects = {}
  local buffs = self.staticData.Buff
  for i = 1, #buffs do
    local buffId = buffs[i]
    local config = Table_Buffer[buffId]
    for k, v in pairs(config.BuffEffect) do
      if Game.Config_PropName[k] then
        buffEffects[k] = buffEffects[k] or 0
        buffEffects[k] = buffEffects[k] + v
      end
    end
  end
  return buffEffects
end

function AstralDestinyGraphPointData:GetLightenCost()
  local curSeason = AstralProxy.Instance:GetSeason()
  local discount = 1
  local discountConfig = GameConfig.Astral and GameConfig.Astral.DiscountInfos
  if discountConfig then
    local deltaSeason = curSeason - self.season
    local maxDelta = 0
    for delta in pairs(discountConfig) do
      if delta <= deltaSeason then
        maxDelta = math.max(delta, maxDelta)
      end
    end
    discount = discountConfig[maxDelta] or discount
  end
  return math.ceil(self.staticData.LightenNum * discount)
end
