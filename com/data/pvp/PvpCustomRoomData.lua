autoImport("HeadImageData")
autoImport("PvpCustomRoomMemberData")
PvpCustomRoomData = class("PvpCustomRoomData")
local ArrayClear = TableUtility.ArrayClear

function PvpCustomRoomData:ctor(data, homeMembers, awayMembers, obMembers)
  self:SetData(data, homeMembers, awayMembers, obMembers)
end

function PvpCustomRoomData:SetData(data, homeMembers, awayMembers, obMembers)
  if data then
    if self.pvptype ~= data.etype then
      self:InitTeamMemberList(data.etype)
    end
    self.pvptype = data.etype
    self.id = data.roomid
    self.inbattle = data.isbattle
    self.roomid = data.roomid
    self.raidid = data.raidid
    self.roomname = data.roomname
    self.iscode = data.iscode
    self.isfull = data.isfull
    self.isfire = data.isfire
    self.leaderid = data.leaderid
    self.teamonenum = data.teamonenum
    self.teamtwonum = data.teamtwonum
    self.teamobnum = data.teamobnum
    if not self.portrait then
      self.portrait = HeadImageData.new()
    end
    self.portrait:TransByPortraitData(data.portrait)
    self.profession = data.limitpro
    self.relics = data.personalartifact
    self.food = data.food
    self.artifact = data.guidartifact
    self.server = data.serverid
    self.password = data.password
    self.bancardsList = data.forbidcards
    self.isforbidcard = data.isforbidcard
  end
  if homeMembers then
    self:SetHomeMembers(homeMembers)
  end
  if awayMembers then
    self:SetAwayMembers(awayMembers)
  end
  if obMembers then
    self:SetObMembers(obMembers)
  end
  self:SortAllTeams()
end

function PvpCustomRoomData:InitTeamMemberList(pvptype)
  self.homeMembers = {}
  self.awayMembers = {}
  self.obMembers = {}
  for i = 1, self:GetMaxTeamCout(pvptype) do
    self.homeMembers[i] = PvpCustomRoomMemberData.new(nil, EROOMTEAMTYPE.EROOMTEAMTYPE_TEAMONE)
    self.awayMembers[i] = PvpCustomRoomMemberData.new(nil, EROOMTEAMTYPE.EROOMTEAMTYPE_TEAMTWO)
  end
  for i = 1, self:GetMaxObCount(pvptype) do
    self.obMembers[i] = PvpCustomRoomMemberData.new(nil, EROOMTEAMTYPE.EROOMTEAMTYPE_TEAMOB)
  end
end

function PvpCustomRoomData:SetHomeMembers(members)
  self:UpsertMembers(members, self.homeMembers)
end

function PvpCustomRoomData:SetAwayMembers(members)
  self:UpsertMembers(members, self.awayMembers)
end

function PvpCustomRoomData:SetObMembers(members)
  self:UpsertMembers(members, self.obMembers)
end

function PvpCustomRoomData:UpsertMembers(serverMembersData, list)
  if not serverMembersData then
    return
  end
  for i, v in ipairs(serverMembersData) do
    local index = self:FindUpsertIndex(v.charid, list)
    if index then
      self.dirty = true
      list[index]:SetData(v)
    end
  end
end

function PvpCustomRoomData:FindUpsertIndex(charid, list)
  local index
  for i, v in ipairs(list) do
    if v.id == charid then
      index = i
      break
    elseif not v.id and not index then
      index = i
    end
  end
  return index
end

function PvpCustomRoomData:DeleteMembers(delMembers)
  if not delMembers then
    return
  end
  for _, v in ipairs(delMembers) do
    if self:DeleteMember(v, self.homeMembers) then
    elseif self:DeleteMember(v, self.awayMembers) then
    elseif self:DeleteMember(v, self.obMembers) then
    end
  end
end

function PvpCustomRoomData:DeleteMember(id, list)
  for _, v in ipairs(list) do
    if v.id == id then
      v:Clear()
      self.dirty = true
      return true
    end
  end
  return false
end

function PvpCustomRoomData:GetMaxTeamCout(pvptype)
  pvptype = pvptype or self.pvptype or 9
  local config = GameConfig.ReserveRoom
  config = config and GameConfig.ReserveRoom.TeamMemberNum[pvptype]
  return config and config[1] or 6
end

function PvpCustomRoomData:GetMaxObCount(pvptype)
  pvptype = pvptype or self.pvptype or 9
  local config = GameConfig.ReserveRoom
  config = config and GameConfig.ReserveRoom.TeamMemberNum[pvptype]
  return config and config[2] or 0
end

function PvpCustomRoomData:CanStart()
  return self:CanDesertWolfStart()
end

function PvpCustomRoomData:GetTeamNum(memberList)
  local count = 0
  if memberList then
    for _, v in ipairs(memberList) do
      if v.id and 0 < v.id then
        count = count + 1
      end
    end
  end
  return count
end

function PvpCustomRoomData:CanDesertWolfStart()
  return not self:IsInBattle() and self:GetTeamNum(self.homeMembers) > 0 and 0 < self:GetTeamNum(self.awayMembers)
end

function PvpCustomRoomData:IsFull()
  return self.isfull and true or false
end

function PvpCustomRoomData:IsHost(guid)
  return self.leaderid == guid
end

function PvpCustomRoomData:IsFreeFire()
  return not not self.isfire
end

function PvpCustomRoomData:NeedPasswd()
  return not not self.iscode
end

function PvpCustomRoomData:SortAllTeams()
  if not self.dirty then
    return
  end
  self.dirty = nil
  self:SortTeam(self.homeMembers)
  self:SortTeam(self.awayMembers)
  self:SortTeam(self.obMembers)
end

function PvpCustomRoomData:SortTeam(list)
  table.sort(list, function(a, b)
    if a.index and not b.index then
      return true
    elseif a.index and b.index and a.index < b.index then
      return true
    end
    return false
  end)
end

function PvpCustomRoomData:ContainsUser(charid)
  for _, v in ipairs(self.homeMembers) do
    if v.charid == charid then
      return true
    end
  end
  for _, v in ipairs(self.awayMembers) do
    if v.charid == charid then
      return true
    end
  end
  for _, v in ipairs(self.obMembers) do
    if v.charid == charid then
      return true
    end
  end
  return false
end

local defaultSuffix = "的房间"

function PvpCustomRoomData:GetRoomName()
  local roomName = self.roomname or ""
  local suffix = defaultSuffix
  roomName = roomName:gsub(suffix, OverSea.LangManager.Instance():GetLangByKey(suffix))
  return roomName
end

function PvpCustomRoomData:IsInBattle()
  if self.inbattle then
    return true
  end
  return false
end

function PvpCustomRoomData:IsOb(charid)
  if self.obMembers then
    for _, ob in ipairs(self.obMembers) do
      if ob.id == charid then
        return true
      end
    end
  end
  return false
end

function PvpCustomRoomData:GetBanCardList()
  if self.bancardsList then
    return self.bancardsList
  end
  return {}
end
