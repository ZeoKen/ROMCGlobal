GvgStatData = class("GvgStatData")
local SortableKeys = {
  [1] = "kill",
  [2] = "helpnum",
  [3] = "death",
  [4] = "revive",
  [5] = "expelnum",
  [6] = "damage",
  [7] = "heal",
  [8] = "occupynum",
  [9] = "occupytime",
  [10] = "metaldamage",
  [11] = "mvp_damage"
}
GvgStatData.SortableKeys = SortableKeys

function GvgStatData:ctor()
  self.stars = {}
end

function GvgStatData:SetServerData(serverData)
  if not serverData then
    return
  end
  self.charid = serverData.charid
  self.profession = serverData.profession
  self.name = serverData.username
  self.kill = serverData.killusernum
  self.death = serverData.dienum
  self.occupynum = serverData.pointnum
  self.occupytime = serverData.pointtime
  self.heal = serverData.healhp
  self.revive = serverData.relivenum
  self.metaldamage = serverData.metaldamage
  self.helpnum = serverData.helpnum
  self.expelnum = serverData.expelnum
  self.damage = serverData.damage
  self.mvp_damage = serverData.mvp_damage
end

function GvgStatData:IsEmpty()
  return not self.charid or not (self.charid > 0)
end

function GvgStatData:FillWithMyselfData()
  local myselfData = Game.Myself and Game.Myself.data
  if myselfData then
    self.name = myselfData:GetName()
    self.profession = myselfData:GetProfesstion()
  end
end

function GvgStatData:GetValueByIndex(i)
  return self[SortableKeys[i]]
end

function GvgStatData:SetStar(key, b)
  self.stars[key] = b
end

function GvgStatData:IsStar(key)
  return self.stars[key] or false
end

function GvgStatData:IsStarByIndex(index)
  return self.stars[SortableKeys[index]] or false
end

function GvgStatData:IsMySelf()
  return self.charid == Game.Myself.data.id
end
