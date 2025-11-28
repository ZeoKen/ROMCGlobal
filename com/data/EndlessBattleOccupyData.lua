local _TableClear = TableUtility.TableClear
autoImport("OccupyPointData")
EndlessBattleOccupyData = class("EndlessBattleOccupyData")

function EndlessBattleOccupyData:ctor()
  self.pointMap = {}
  self.del_points = {}
end

function EndlessBattleOccupyData:UpdatePoints(updates, dels)
  self:SetDels(dels)
  self:SetPoints(updates)
end

function EndlessBattleOccupyData:SetPoints(updates)
  if not updates then
    return
  end
  for i = 1, #updates do
    self:SetPoint(updates[i])
  end
end

function EndlessBattleOccupyData:SetPoint(data)
  local point = self:GetPoint(data.point_id)
  if not point then
    point = self:AddPoint(data)
  else
    point:Update(data)
  end
  EventManager.Me():PassEvent(EndlessBattleFieldEvent.PointUpdate, point)
end

function EndlessBattleOccupyData:SetDels(dels)
  if not dels then
    return
  end
  for i = 1, #dels do
    self.del_points[dels[i]] = 1
  end
end

function EndlessBattleOccupyData:Reset()
  _TableClear(self.pointMap)
  _TableClear(self.del_points)
end

function EndlessBattleOccupyData:GetProgress(id)
  local p = self:GetPoint(id)
  if p then
    return p:GetProgress()
  end
  return 0
end

function EndlessBattleOccupyData:GetOccupyEffectPath(id)
  local p = self:GetPoint(id)
  if p then
    return p:GetOccupyEffectPath()
  end
end

function EndlessBattleOccupyData:AddPoint(data)
  if not data or not data.point_id then
    return
  end
  local id = data and data.point_id
  local pt = OccupyPointData.new(id)
  pt:Update(data)
  self.pointMap[id] = pt
  return pt
end

function EndlessBattleOccupyData:GetPoint(id)
  return self.pointMap[id]
end
