OccupyPointData = class("OccupyPointData")

function OccupyPointData:ctor(id)
  self.id = id
  self:init()
end

function OccupyPointData:init()
  if not Game.AltarPoint then
    redlog("[无尽战场] 祭坛表Table_EndlessBattleFieldEvent未找到配置Misc.occupy_points")
    return
  end
  local data = Game.AltarPoint[self.id]
  if not data then
    redlog("[无尽战场] 祭坛表Table_EndlessBattleFieldEvent Misc.occupy_points 未配置据点ID", self.id)
    return
  end
  self:_initPointData(data)
end

function OccupyPointData:_initPointData(data)
  self.eventId = data.eventId
  self.static_data = data.config
  self.center = self.static_data.center
  self.total_score = self.static_data.occupy_score
  self.rotation = self.static_data.rotation or {
    0,
    0,
    0
  }
  self.scale = self.static_data.scale or {
    0,
    0,
    0
  }
end

function OccupyPointData:Update(data)
  self.camp = data.occupying_camp or Camp_Neutral
  local occupied = data.occupied
  if nil == occupied then
    occupied = false
  end
  self:SetOccupied(occupied)
  self:UpdateScore(data.cur_occupy_score or 0)
end

function OccupyPointData:SetOccupied(boolean)
  self.occupied = boolean
  if boolean then
    EventManager.Me():PassEvent(PVPEvent.EndlessBattleField_Event_PointOccypied, self)
  end
end

function OccupyPointData:UpdateScore(server_score)
  local old = self.score
  self.score = server_score
  if nil ~= old and old ~= server_score then
    GameFacade.Instance:sendNotification(EndlessBattleFieldEvent.OccupyScoreUpdate, self.id)
  end
end

function OccupyPointData:GetProgress()
  return self.score and self.total_score and self.score / self.total_score or 0
end

function OccupyPointData:IsOccupied()
  return self.occupied == true
end

local occupied_effect = {
  [Camp_Human] = EffectMap.Maps.EndlessBattle_OccupySuccess_Human,
  [Camp_Vampire] = EffectMap.Maps.EndlessBattle_OccupySuccess_Vampire
}
local occupying_effect = {
  [Camp_Human] = EffectMap.Maps.EndlessBattle_Occupy_Human,
  [Camp_Vampire] = EffectMap.Maps.EndlessBattle_Occupy_Vampire,
  [Camp_Neutral] = EffectMap.Maps.EndlessBattle_Occupy_Neutral
}
local occupy_progress_effect = {
  [Camp_Human] = EffectMap.Maps.EndlessBattle_OccupyProgress_Human,
  [Camp_Vampire] = EffectMap.Maps.EndlessBattle_OccupyProgress_Vampire
}

function OccupyPointData:GetOccupyEffectPath()
  return occupying_effect[self.camp]
end

function OccupyPointData:GetOccupySuccessEffect()
  return occupied_effect[self.camp]
end

function OccupyPointData:GetProgressEffectPath()
  return occupy_progress_effect[self.camp]
end

function OccupyPointData:GetOccupyEffectPos()
  return self.center
end

function OccupyPointData:GetScale()
  return self.scale
end

function OccupyPointData:GetRotation()
  return self.rotation
end
