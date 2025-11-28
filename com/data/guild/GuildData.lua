GuildData = class("GuildData")
autoImport("GuildHeadData")
autoImport("GuildMemberData")
GuildSummaryType = {
  initType1 = "createtime",
  OtherGuildSummary1 = "curmember",
  OtherGuildSummary2 = "maxmember",
  OtherGuildSummary3 = "chairmanname",
  OtherGuildSummary4 = "guildname",
  OtherGuildSummary5 = "recruitinfo",
  OtherGuildSummary6 = "chairmangender",
  OtherGuildSummary7 = "gvglevel",
  OtherGuildSummary8 = "needlevel",
  OtherGuildSummary9 = "nextzoneid",
  OtherGuildSummary10 = "curmercenary",
  OccupiedCityId = "occupy_city",
  BattleGroup = "battle_group",
  NextBattleGroup = "next_battle_group",
  DateBattleMvp = "datebattle_mvp",
  ChairmanId = "chairmanid"
}
GuildData.RegionColor = {
  [1] = LuaColor.New(0.5960785, 0.7215686, 1, 1),
  [2] = LuaColor.New(0.572549, 0.8509804, 0.4784314, 1),
  [3] = LuaColor.New(0.9372549, 0.7294118, 0.4313726, 1),
  [4] = LuaColor.New(0.8078431, 0.6509804, 0.9098039, 1)
}
local mapGuildEnumProp = function(enum, propName)
  if enum then
    GuildSummaryType[enum] = propName
  else
    helplog("enum is nil! propName is", propName)
  end
end
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_ID, "guid")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_NAME, "name")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_LEVEL, "level")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_PORTRAIT, "portrait")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_ASSET, "asset")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_DISMISSTIME, "dismisstime")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_BOARDINFO, "boardinfo")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_RECRUITINFO, "recruitinfo")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_QUEST_RESETTIME, "questresettime")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_ZONEID, "zoneid")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_ZONETIME, "zonetime")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_NEXTZONE, "nextzone")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_DONATETIME1, "donatetime1")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_DONATETIME2, "donatetime2")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_ASSET_DAY, "assettoday")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_OPEN_FUNCTION, "openfunction")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_TREASURE_GVG_COUNT, "gvg_treasure_count")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_TREASURE_GUILD_COUNT, "guild_treasure_count")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_TREASURE_BCOIN_COUNT, "bcoin_treasure_count")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_SUPERGVG, "insupergvg")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_SUPERGVG_LV, "supergvg_lv")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_MATERIAL_MACHINE_COUNT, "material_machine_count")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_GVG_GROUP_TIME, "change_group_time")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_DATEBATTLE_INVITE_COUNT, "datebattle_invite_count")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_DATEBATTLE_MVP, "datebattle_mvp")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_CITYID, "cityid")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_CITY_GIVEUP_CD, "citygiveuptime")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_ASSEMBLY_NUM, "assembly_complete_num")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_NO_ATTACK_METAL, "no_attack_metal")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_MERCENARY_COUNT, "curmercenary")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_GVG_GROUP, "battle_group")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_GVG_GROUP_DEST, "next_battle_group")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_APPLIED, "applied")
mapGuildEnumProp(GuildCmd_pb.EGUILDDATA_MERCENARY, "mercenary")
GuildData.PropertyTypeMap = {
  name = "string",
  boardinfo = "string",
  recruitinfo = "string",
  chairmanname = "string",
  guildname = "string",
  portrait = "string",
  cityid = "table",
  citygiveuptime = "table",
  no_attack_metal = "boolean",
  applied = "boolean",
  mercenary = "mercenary"
}
GuildJobType = {
  Chairman = GuildCmd_pb.EGUILDJOB_CHAIRMAN,
  ViceChairman = GuildCmd_pb.EGUILDJOB_VICE_CHAIRMAN,
  Member1 = GuildCmd_pb.EGUILDJOB_MEMBER1,
  Member2 = GuildCmd_pb.EGUILDJOB_MEMBER2,
  Member3 = GuildCmd_pb.EGUILDJOB_MEMBER3,
  Member4 = GuildCmd_pb.EGUILDJOB_MEMBER4,
  Member5 = GuildCmd_pb.EGUILDJOB_MEMBER5,
  Member6 = GuildCmd_pb.EGUILDJOB_MEMBER6,
  Member7 = GuildCmd_pb.EGUILDJOB_MEMBER7,
  Member8 = GuildCmd_pb.EGUILDJOB_MEMBER8,
  Member9 = GuildCmd_pb.EGUILDJOB_MEMBER9,
  Member10 = GuildCmd_pb.EGUILDJOB_MEMBER10
}

function GuildData:ctor(guildData)
  self.id = nil
  self.memberNum = 0
  self.maxMemberNum = 0
  self.mercenaryNum = 0
  self.maxMercenaryNum = GameConfig.Guild and GameConfig.Guild.MaxMercenaryMemberCount or 0
  self.membersMap = {}
  self.applysMap = {}
  self.mercenaryApplyMap = {}
  self.jobMap = {}
  self:InitTableUpdateFunc()
  self:SetData(guildData)
end

function GuildData:GetPropertyType(key)
  return GuildData.PropertyTypeMap[key] or "number"
end

function GuildData:SetData(gdata)
  if gdata then
    for _, key in pairs(GuildSummaryType) do
      if gdata[key] then
        self[key] = gdata[key]
      else
        local summary = gdata.summary
        self:_updateCitys(summary.cityid)
        if summary and summary[key] ~= nil and "table" ~= self:GetPropertyType(key) then
          self[key] = summary[key]
        end
      end
    end
    self.id = self.guid
    self:UpdateStaticData()
    self:UpdateGuildJobInfos(gdata.jobs)
    self:_updateCityGiveupCD(gdata.citygiveuptime)
    self:SetMembers(gdata.members)
    self:SetApplys(gdata.applys)
    GvgProxy.Instance:Debug("NewGVG 自己公会zoneid : ", self.zoneid)
  end
end

function GuildData:UpdateGuildJobInfos(server_jobs)
  if server_jobs and 0 < #server_jobs then
    local jobInfo
    for i = 1, #server_jobs do
      self:UpdateGuildJobInfo(server_jobs[i])
    end
  end
end

function GuildData:GetChairManId()
  return self.chairmanid or 0
end

function GuildData:UpdateGuildJobInfo(single)
  local jobId = single.job
  if jobId then
    local config = Table_GuildJob[jobId]
    if config == nil then
      helplog("Error Server Data ", tostring(jobId))
      return
    end
    local jobInfo = self.jobMap[jobId]
    if jobInfo == nil then
      jobInfo = {}
      jobInfo.id = jobId
      self.jobMap[jobId] = jobInfo
    end
    if single.name ~= nil and single.name ~= "" then
      jobInfo.name = single.name
    else
      jobInfo.name = config.Name
    end
    jobInfo.auth = single.auth
    jobInfo.auth2 = single.auth2 or 0
    jobInfo.limitlv = config.OpenLevel
    jobInfo.editauth = single.editauth or 0
    jobInfo.editauth2 = single.editauth2 or 0
  end
end

function GuildData:UpdateStaticData(updateDatas)
  if self.level then
    local key = math.max(1, self.level)
    key = math.min(self.level, #Table_Guild)
    self.staticData = Table_Guild[key]
    self.maxMemberNum = self.staticData and self.staticData.MemberNum or 0
  end
end

function GuildData:_updateCitys(values)
  if not values then
    return
  end
  if not self.cityids then
    self.cityids = {}
  else
    TableUtility.ArrayClear(self.cityids)
  end
  for i = 1, #values do
    self.cityids[#self.cityids + 1] = values[i]
  end
end

function GuildData:HasClassicModeCity()
  if self.cityids then
    local classic_mode = GuildCmd_pb.EGUILDDATEBATTLEMODE_CLASSIC
    local staticCity
    for i = 1, #self.cityids do
      staticCity = GvgProxy.GetStrongHoldStaticData(self.cityids[i])
      if staticCity and staticCity.Mode == classic_mode then
        return true
      end
    end
  end
  return false
end

function GuildData:_updateCityGiveupCD(values)
  if not values then
    return
  end
  if not self.cityGiveupCdMap then
    self.cityGiveupCdMap = {}
  else
    TableUtility.TableClear(self.cityGiveupCdMap)
  end
  for i = 1, #values, 2 do
    self.cityGiveupCdMap[values[i]] = values[i + 1]
  end
end

function GuildData:GetCitys()
  return self.cityids
end

function GuildData:GetClientGvgGroup()
  local group = self.battle_group or 0
  return GvgProxy.ClientGroupId(group)
end

function GuildData:GetGiveupCityTime()
  if not next(self.cityids) then
    return 0
  end
  local cityid = self.cityids[1]
  if not cityid then
    return 0
  end
  return self.cityGiveupCdMap and self.cityGiveupCdMap[cityid] or 0
end

function GuildData:InitTableUpdateFunc()
  self.tableUpdateFuncs = {}
  self.tableUpdateFuncs[GuildCmd_pb.EGUILDDATA_CITYID] = self._updateCitys
  self.tableUpdateFuncs[GuildCmd_pb.EGUILDDATA_CITY_GIVEUP_CD] = self._updateCityGiveupCD
end

function GuildData:UpdateData(updateDatas)
  redlog("GuildData UpdateData")
  local updateStr = "GuildData(Update): "
  updateStr = updateStr .. string.format("| %s:%s", "name", self.name)
  local jobNameUpdate = false
  for i = 1, #updateDatas do
    local single = updateDatas[i]
    local type, value, data, values = single.type, single.value, single.data, single.values
    local key = GuildSummaryType[type]
    if key then
      local propertyType = self:GetPropertyType(key)
      if propertyType == "string" then
        self[key] = data or ""
      elseif propertyType == "number" then
        self[key] = value
      elseif propertyType == "boolean" then
        self[key] = value == 1
      else
        local updateFunc = self.tableUpdateFuncs[type]
        if updateFunc then
          updateFunc(self, values)
        else
          redlog("GuildData:UpdateData 未定义更新函数，类型为 : ", type)
        end
      end
      updateStr = updateStr .. string.format("| %s:%s", key, tostring(self[key]))
    end
  end
  if jobNameUpdate then
    for _, member in pairs(self.membersMap) do
      member:UpdateJobInfo(self.jobInfo)
    end
  end
  self:UpdateStaticData()
  helplog(updateStr)
end

function GuildData:SetMembers(smDatas)
  if smDatas then
    for i = 1, #smDatas do
      member = self:SetMember(smDatas[i])
    end
  end
end

function GuildData:SetMember(serviceGuildMember)
  local member = self:GetMemberByGuid(serviceGuildMember.charid)
  if not member then
    member = self:AddMember(serviceGuildMember)
  else
    local cacheOffline = member:IsOffline()
    member:SetData(serviceGuildMember)
  end
  return member
end

function GuildData:AddMember(serviceGuildMember)
  if serviceGuildMember then
    local newMember = GuildMemberData.new(serviceGuildMember, self)
    self.membersMap[serviceGuildMember.charid] = newMember
    if newMember:IsMercenary() then
      self.mercenaryNum = self.mercenaryNum + 1
    else
      self.memberNum = self.memberNum + 1
    end
    return newMember
  end
end

function GuildData:RemoveMembers(dels)
  for i = 1, #dels do
    self:RemoveMember(dels[i])
  end
end

function GuildData:RemoveMember(guid)
  local catchMember = self:GetMemberByGuid(guid)
  if catchMember then
    self.membersMap[guid] = nil
    if catchMember:IsMercenary() then
      self.mercenaryNum = self.mercenaryNum - 1
    else
      self.memberNum = self.memberNum - 1
    end
  end
  return catchMember
end

function GuildData:GetMemberByGuid(guid)
  return self.membersMap[guid]
end

function GuildData:GetMemberList()
  local result = {}
  for k, v in pairs(self.membersMap) do
    table.insert(result, v)
  end
  return result
end

function GuildData:SetApplys(applys)
  if applys and 0 < #applys then
    for i = 1, #applys do
      self:SetApply(applys[i])
    end
  end
end

function GuildData:SetApply(serviceGuildApply)
  if serviceGuildApply and serviceGuildApply.job == GuildCmd_pb.EGUILDJOB_APPLY_MERCENARY then
    self:SetMercenaryApply(serviceGuildApply)
    return
  end
  local catchApply = self:GetApplyByGuid(serviceGuildApply.charid)
  if not catchApply then
    catchApply = self:AddApply(serviceGuildApply)
  else
    catchApply:SetData(serviceGuildApply)
  end
  return catchApply
end

function GuildData:AddApply(apply)
  if apply and apply.charid then
    local catchApply = GuildMemberData.new(apply)
    self.applysMap[apply.charid] = catchApply
    return catchApply
  end
end

function GuildData:RemoveApplys(dels)
  for i = 1, #dels do
    self:RemoveApply(dels[i])
  end
end

function GuildData:RemoveApply(guid)
  local catchApply = self:GetApplyByGuid(guid)
  if catchApply then
    self.applysMap[guid] = nil
  end
  return catchApply
end

function GuildData:GetApplyByGuid(guid)
  return self.applysMap[guid]
end

function GuildData:GetApplyList()
  local result = {}
  for k, v in pairs(self.applysMap) do
    table.insert(result, v)
  end
  for _, v in pairs(self.mercenaryApplyMap) do
    table.insert(result, v)
  end
  table.sort(result, function(a, b)
    return a.entertime and b.entertime and a.entertime < b.entertime
  end)
  return result
end

function GuildData:ClearApplyList()
  self.applysMap = {}
end

function GuildData:SetMercenaryApply(applyData)
  local newApply = self:GetMercenaryApplyById(applyData.charid)
  if newApply then
    newApply:SetData(applyData)
  else
    newApply = self:AddMercenaryApply(applyData)
  end
  return newApply
end

function GuildData:AddMercenaryApply(applyData)
  if applyData and applyData.charid then
    local apply = GuildMemberData.new(applyData)
    self.mercenaryApplyMap[applyData.charid] = apply
    return apply
  end
end

function GuildData:GetMercenaryApplyById(guid)
  return self.mercenaryApplyMap and self.mercenaryApplyMap[guid]
end

function GuildData:RemoveMercenaryApplies(dels)
  if dels then
    for _, guid in ipairs(dels) do
      self:RemoveMercenaryApply(guid)
    end
  end
end

function GuildData:RemoveMercenaryApply(guid)
  local apply = self:GetMercenaryApplyById(guid)
  self.mercenaryApplyMap[guid] = nil
  return apply
end

function GuildData:ClearMercenaryApplyList()
  if self.mercenaryApplyMap then
    TableUtility.TableClear(self.mercenaryApplyMap)
  end
end

function GuildData:GetChairMan()
  for _, member in pairs(self.membersMap) do
    if member.job == GuildJobType.Chairman then
      return member
    end
  end
  local _, errorChairMan = next(self.membersMap)
  return errorChairMan
end

function GuildData:GetViceChairmanList()
  local result = {}
  for _, member in pairs(self.membersMap) do
    if member.job == GuildJobType.ViceChairman then
      table.insert(result, member)
    end
  end
  return result
end

function GuildData:GetOnlineMembers()
  local result = {}
  for _, member in pairs(self.membersMap) do
    if not member:IsOffline() then
      table.insert(result, member)
    end
  end
  return result
end

function GuildData:GetUpgradeConfig()
  return self:GetGuildConfig(self.level + 1)
end

function GuildData:GetGuildConfig(level)
  level = level or self.level
  local maxlv = 1
  for lv, _ in pairs(Table_Guild) do
    maxlv = math.max(maxlv, lv)
  end
  level = math.min(level, maxlv)
  level = math.max(1, level)
  return Table_Guild[level]
end

function GuildData:GetNextDonateTime()
  if self.donatetime1 and self.donatetime2 then
    local curServerTime = ServerTime.CurServerTime() / 1000
    if self.donatetime1 < self.donatetime2 then
      if curServerTime > self.donatetime1 then
        return self.donatetime2
      else
        return self.donatetime1
      end
    elseif curServerTime > self.donatetime2 then
      return self.donatetime1
    else
      return self.donatetime2
    end
  end
  return 0
end

function GuildData:GetJobMap()
  return self.jobMap
end

function GuildData:GetJobAuthValue(job)
  if self.jobMap[job] then
    return self.jobMap[job].auth, self.jobMap[job].auth2
  end
end

function GuildData:GetJobName(job)
  if job == GuildCmd_pb.EGUILDJOB_MERCENARY then
    return ZhString.GuildMemberJobMercenary
  end
  if self.jobMap[job] then
    return self.jobMap[job].name
  end
end

function GuildData:GetJobEditAuth(job)
  if self.jobMap[job] then
    return self.jobMap[job].editauth, self.jobMap[job].editauth2
  end
end

function GuildData:CheckFunctionOpen(etype)
  local v = 1 << etype - 1
  local openfunction = self.openfunction or 0
  return 0 < v & openfunction
end

function GuildData:Exit()
end

function GuildData:GetOccupiedCityConfig()
  if self.occupy_city then
    return GvgProxy.GetStrongHoldStaticData(self.occupy_city)
  end
end

function GuildData:GetOccupiedCityName()
  local config = self:GetOccupiedCityConfig()
  return config and config.Name or ""
end
