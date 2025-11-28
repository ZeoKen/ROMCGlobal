GuildMemberData = class("GuildMemberData")
GuildMemberDataType = {}
local mapGuildEnumProp = function(enum, propName)
  if enum then
    GuildMemberDataType[enum] = propName
  else
    redlog(string.format("GuildCmd_pb enum is nil! propName is %s", propName))
  end
end
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_NAME, "name")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_BASELEVEL, "baselevel")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_PORTRAIT, "portrait")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_FRAME, "frame")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_PROFESSION, "profession")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_CONTRIBUTION, "contribution")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_TOTALCONTRIBUTION, "totalcontribution")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_WEEKCONTRIBUTION, "weekcontribution")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_WEEKASSET, "weekasset")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_ENTERTIME, "entertime")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_OFFLINETIME, "offlinetime")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_JOB, "job")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_HAIR, "hair")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_EYE, "eye")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_HAIRCOLOR, "haircolor")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_BODY, "body")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_HEAD, "head")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_FACE, "face")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_MOUTH, "mouth")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_LEVELUPEFFECT, "levelupeffect")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_ZONEID, "zoneid")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_GENDER, "gender")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_WEEKBCOIN, "weekbcoin")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_TOTALBCOIN, "totalcoin")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_REALTIMEVOICE, "realtimevoice")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_HOME_ROOMID, "roomid")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_TEAMNAME, "teamname")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_PORTRAIT_FRAME, "portrait_frame")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_RETURNUSER, "userreturnendtime")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_ASSEMBLY_STATUS, "assemblystatus")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_IN_GVG_FIRE, "ingvgfire")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_IN_GVG_SUPER, "ingvgsuper")
mapGuildEnumProp(GuildCmd_pb.EGUILDMEMBERDATA_MERCENARY_GUILDID, "mercenary_guild_id")
GuildSummaryStringType = {name = 1, teamname = 1}

function GuildMemberData:ctor(guildMemberData, guildData)
  self.guildData = guildData
  self:SetData(guildMemberData)
end

function GuildMemberData:SetData(gmdata)
  if gmdata then
    self.id = gmdata.charid
    self.name = gmdata.name
    self.accid = gmdata.accid
    if gmdata and gmdata.building then
      self.buildingLevelUp = gmdata.building.buildings
    end
    local updateStr = "GuildMemberData(Init): "
    updateStr = updateStr .. string.format("| %s:%s", "name", tostring(self.name))
    for _, key in pairs(GuildMemberDataType) do
      if gmdata[key] then
        self[key] = gmdata[key]
        updateStr = updateStr .. string.format("| %s:%s", key, gmdata[key])
      end
    end
    if self.realtimevoice == nil then
      self.realtimevoice = false
    end
  end
end

function GuildMemberData:UpdateData(updateDatas)
  local updateStr = "GuildMemberData(Update): "
  updateStr = updateStr .. string.format("| %s:%s", "name", self.name)
  local oldJob = member.job
  local cacheContribution = member.contribution
  for i = 1, #updateDatas do
    local data = updateDatas[i]
    local key = GuildMemberDataType[data.type]
    if key then
      if GuildSummaryStringType[key] then
        self[key] = data.data
      else
        self[key] = data.value
      end
      updateStr = updateStr .. string.format("| %s:%s", key, tostring(data.value))
    end
  end
  if self.id == Game.Myself.data.id then
    if oldJob ~= self.job then
      FunctionGuild.Me():MyGuildJobChange(oldJob, self.job)
    end
    if cacheContribution ~= self.contribution then
      GameFacade.Instance:sendNotification(GuildEvent.GuildUpgrade)
    end
  end
end

function GuildMemberData:GetJobName()
  if self.guildData and self.job then
    return self.guildData:GetJobName(self.job)
  end
end

function GuildMemberData:IsOffline()
  if self.offlinetime then
    return self.offlinetime ~= 0
  end
  return false
end

function GuildMemberData:GetEyeID()
  if 0 == self.eye then
    if PlayerData.CheckRace(self.profession, ECHARRACE.ECHARRACE_CAT) then
      return 3
    elseif self:IsBoy() then
      return 1
    else
      return 2
    end
  else
    return self.eye
  end
end

function GuildMemberData:IsBoy()
  return self.gender == ProtoCommon_pb.EGENDER_MALE
end

function GuildMemberData:NeedPlayLevelUpEffect()
  return self.levelupeffect == true or self.levelupeffect == 1
end

function GuildMemberData:GetBuildingLevelup()
  return self.buildingLevelUp
end

function GuildMemberData:IsRealtimevoice()
  return self.realtimevoice == true or self.realtimevoice == 1
end

function GuildMemberData:SetRealtimevoiceValue(value)
  self.realtimevoice = value
end

function GuildMemberData:GetCharId()
  return self.id
end

function GuildMemberData:IsAssembleComplete()
  return self.assemblystatus == 2
end

function GuildMemberData:IsAssembleInMyGuild()
  return self.assemblyincurguild == 1
end

function GuildMemberData:IsMercenary()
  return self.job == GuildCmd_pb.EGUILDJOB_MERCENARY
end

function GuildMemberData:IsMercenaryApply()
  return self.job == GuildCmd_pb.EGUILDJOB_APPLY_MERCENARY
end

function GuildMemberData:IsMercenaryOfOtherGuild()
  return self.mercenary_guild_id and self.mercenary_guild_id > 0
end
