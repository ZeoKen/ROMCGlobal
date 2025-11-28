MiniMapGvgStrongHoldData = class("MiniMapGvgStrongHoldData")

function MiniMapGvgStrongHoldData:ctor(id, config, data)
  self.id = type(id) == "string" and tonumber(id) or id
  self.depth = 1
  self:SetConfig(config)
  self:SetData(data)
end

function MiniMapGvgStrongHoldData:SetConfig(config)
  if config.pos then
    if self.pos then
      LuaVector3.Better_SetPos(self.pos, config.pos)
    else
      self.pos = LuaVector3.New(config.pos[1], config.pos[2], config.pos[3])
    end
  else
    self.pos = LuaVector3.Zero()
  end
end

function MiniMapGvgStrongHoldData:SetData(data)
  self.data = data
end

function MiniMapGvgStrongHoldData:HasData()
  return self.data ~= nil
end

function MiniMapGvgStrongHoldData:IsActive()
  if self.data then
    return self.data:CanGetRewardFromThisHold()
  end
  return false
end

function MiniMapGvgStrongHoldData:ForceHideIcon()
  return Game.MapManager:IsGVG_DateBattle()
end

function MiniMapGvgStrongHoldData:GetMapSymbolDepth()
  return self.depth
end

function MiniMapGvgStrongHoldData:GetIndex()
  return self.id or 0
end

function MiniMapGvgStrongHoldData:IsOccupied()
  if self.data then
    return self.data:IsOccupied()
  end
  return false
end

function MiniMapGvgStrongHoldData:IsScrambling()
  if self:IsOccupied() then
    return false
  end
  return self:GetProgress() > 0
end

function MiniMapGvgStrongHoldData:GetHoldGuildPortrait()
  return self.data and self.data:GetOccupyGuildPortrait()
end

function MiniMapGvgStrongHoldData:GetHoldGuildId()
  return self.data and self.data:GetGuildID()
end

function MiniMapGvgStrongHoldData:HasScore()
  return self.data and self.data:CheckScore() == true
end

function MiniMapGvgStrongHoldData:GetHoldGuildName()
  return self.data and self.data.guildName
end

function MiniMapGvgStrongHoldData:GetProgress()
  return self.data and self.data:GetOccupyProcess() or 0
end
