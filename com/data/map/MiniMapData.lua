MiniMapData = reusableClass("MiniMapData")
MiniMapData.PoolSize = 50

function MiniMapData:SetPos(x, y, z)
  if not self.pos then
    self.pos = LuaVector3()
  end
  LuaVector3.Better_Set(self.pos, x, y, z)
end

function MiniMapData:GetPos()
  return self.pos
end

function MiniMapData:SetParama(key, value)
  if not key then
    return
  end
  if not self._parama then
    self._parama = {}
  end
  self._parama[key] = value
end

function MiniMapData:GetParama(key)
  if self._parama then
    return self._parama[key]
  end
end

function MiniMapData:DoConstruct(asArray, id)
  self.id = id
end

function MiniMapData:DoDeconstruct(asArray)
  self.id = nil
  if self.pos then
    LuaVector3.Destroy(self.pos)
  end
  self.pos = nil
  if self._parama then
    TableUtility.TableClear(self._parama)
  end
  self.staticId = nil
  self.showRange = nil
end

function MiniMapData:GetMapSymbolProgress()
  local activeTime = self:GetParama("active_time")
  local totalTime = self:GetParama("total_time")
  local progress = 1
  local isActive = true
  if activeTime and 0 < activeTime and totalTime and 0 < totalTime then
    local serverTime = ServerTime.CurServerTime() / 1000
    local leftTime = activeTime - serverTime
    if 0 < leftTime then
      progress = (totalTime - leftTime) / totalTime
      if progress < 0 then
        progress = 0
      end
      isActive = false
    end
  end
  return progress, isActive
end

function MiniMapData:SetServerData(npc)
  self.staticId = npc.npcid
  self.nearShow = npc.near_show
end

function MiniMapData:SetShowRange(showRange)
  self.showRange = showRange
end
