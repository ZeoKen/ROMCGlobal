GroupRaidKillDataType = {PlayerType = 1, GuildType = 2}
GroupRaidKillUserData = class("GroupRaidKillUserData")

function GroupRaidKillUserData:ctor(data)
  self.charid = data.charid
  self.profession = data.profession
  self.level = data.level
  self.name = data.name
  if data.portrait then
    local portrait = data.portrait
    self.portrait = portrait.portrait
    self.hairID = portrait.hair
    self.haircolor = portrait.haircolor
    self.bodyID = portrait.body
    self.headID = portrait.head
    self.faceID = portrait.face
    self.mouthID = portrait.mouth
    self.eyeID = portrait.eye
  end
  self.guildid = data.guildid
  self.guildname = data.guildname
  self.datatype = GroupRaidKillDataType.PlayerType
end

function GroupRaidKillUserData:SetTime(servertime)
  self.time = servertime
end

GroupRaidKillGuildData = class("GroupRaidKillGuildData")

function GroupRaidKillGuildData:ctor(data)
  self.guildid = data.guildid
  self.guildname = data.guildname
  self.guildportrait = data.guildportrait
  self:ProcessGuildPortrait(self.guildportrait)
  self.rank = data.rank
  self.datatype = GroupRaidKillDataType.GuildType
end

function GroupRaidKillGuildData:ProcessGuildPortrait(guildportrait)
  local iconId = guildportrait
  if iconId == "" then
    iconId = "1"
  end
  if iconId then
    local sps = string.split(iconId, "_")
    iconId = sps[1]
    local cfgIconId = tonumber(iconId)
    if sps[2] then
      self.customIconUpTime = tonumber(sps[2])
      self.picType = sps[3]
      if self.customIconUpTime then
        self.customIconIndex = cfgIconId
      end
      self.icon = nil
    else
      local iconCfg = cfgIconId and Table_Guild_Icon[cfgIconId]
      self.icon = iconCfg and iconCfg.Icon or iconId
      self.customIconIndex = nil
      self.customIconUpTime = nil
      self.picType = nil
    end
  else
    self.icon = nil
    self.customIconIndex = nil
    self.customIconUpTime = nil
    self.picType = nil
  end
end

function GroupRaidKillGuildData:GetGuildPortrait()
  self.icon = nil
  self.customIconIndex = nil
  self.customIconUpTime = nil
  self.picType = nil
end

function GroupRaidKillGuildData:SetTime(servertime)
  self.time = servertime
end

GroupRaidKillData = class("GroupRaidKillData")

function GroupRaidKillData:ctor(serverdata)
  if serverdata then
    self.raidid = serverdata.raid
    self.time = serverdata.time
    self.usersList = {}
    local entry
    if serverdata.users then
      local users = serverdata.users
      for i = 1, #users do
        entry = GroupRaidKillUserData.new(users[i])
        entry:SetTime(serverdata.time)
        table.insert(self.usersList, entry)
      end
    end
    self.guildList = {}
    if serverdata.guilds then
      local guilds = serverdata.guilds
      for i = 1, #guilds do
        entry = GroupRaidKillGuildData.new(guilds[i])
        entry:SetTime(guilds[i].time)
        table.insert(self.guildList, entry)
      end
    end
  end
end

function GroupRaidKillData:CheckClearTime()
  return self.time
end

function GroupRaidKillData:GetUsersList()
  return self.usersList
end

function GroupRaidKillData:GetGuildList()
  return self.guildList
end
