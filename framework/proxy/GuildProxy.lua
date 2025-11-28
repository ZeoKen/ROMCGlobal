local _ArrayClear = TableUtility.ArrayClear
local _TableClear = TableUtility.TableClear
GuildProxy = class("GuildProxy", pm.Proxy)
GuildProxy.Instance = nil
GuildProxy.NAME = "GuildProxy"
autoImport("MyselfGuildData")
GuildItemConfig = {GuildItemId = 5500}
GuildAuthorityMap = {
  InviteJoin = 1,
  PermitJoin = 2,
  SetBordInfo = 4,
  SetRecruitInfo = 5,
  SetIcon = 6,
  UpgradeGuild = 7,
  KickMember = 11,
  SetJob = 13,
  SetJobname = 14,
  ChangePresident = 15,
  DismissGuild = 16,
  ChangeLine = 17,
  OpenGuildRaid = 18,
  EditPicture = 19,
  ChangeName = 20,
  GiveUpLand = 21,
  OpenGuildFunction = 22,
  Guild = 23,
  ArtifactQuest = 24,
  ArtifactProduce = 25,
  ArtifactOption = 26,
  Treasure = 27,
  Shop = 28,
  Voice = 29,
  Approve_Applied = 30,
  Approve_Checked = 31,
  Approve_NeedLevel = 32,
  EditAuth = 33,
  CanBeMercenary = 34,
  DeletePicture = 35,
  GvgCity = 36
}
Guild_GateState = {
  Lock = FuBenCmd_pb.EGUILDGATESTATE_LOCK,
  Close = FuBenCmd_pb.EGUILDGATESTATE_CLOSE,
  Open = FuBenCmd_pb.EGUILDGATESTATE_OPEN,
  Open_Enter = FuBenCmd_pb.EGUILDGATESTATE_OPEN_Enter
}

function GuildProxy:ctor(proxyName, data)
  self.proxyName = proxyName or GuildProxy.NAME
  if GuildProxy.Instance == nil then
    GuildProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:InitProxy()
end

function GuildProxy:InitProxy()
  self.guildList = {}
  self.sceneGuildDataMap = {}
  self.sceneGuildGateMap = {}
  self.guildGateList = {}
  self.donateItems = {}
  self.myGuildData = nil
  self.hasReward = false
end

function GuildProxy:SetGuildDateBattleFind(var)
  self.bDataBattleFind = var
end

function GuildProxy:UpdateGuildList(guildSummarys)
  local my_guild_id = GuildProxy.Instance:GetOwnGuildID()
  self.guildList = {}
  for i = 1, #guildSummarys do
    local gd = {
      summary = guildSummarys[i]
    }
    local guildData = GuildData.new(gd)
    if not self.bDataBattleFind or my_guild_id ~= guildData.id then
      table.insert(self.guildList, guildData)
    end
  end
end

function GuildProxy:GetGuildList()
  return self.guildList
end

local cfg = {
  [0] = "全部",
  [1] = "无需审批",
  [2] = "符合等级"
}
local filterCFG = GameConfig.Guild.guildListFilter or cfg
local postFilter = {}

function GuildProxy:GetGuildListFilter()
  _ArrayClear(postFilter)
  for k, v in pairs(filterCFG) do
    table.insert(postFilter, k)
  end
  return postFilter
end

function GuildProxy:GetGuildCitys()
  return self.myGuildData and self.myGuildData:GetCitys()
end

function GuildProxy:GetGuildCityFilterConfig()
  if not self.cityFilterNameConfig then
    self.cityFilterNameConfig = {
      [1] = ZhString.GuildCityAll,
      [2] = ZhString.GuildCityLarge,
      [3] = ZhString.GUildCityMedium,
      [4] = ZhString.GuildCitySmall
    }
  end
  if not self.cityFilterValueConfig then
    self.cityFilterValueConfig = {
      [1] = -1,
      [2] = GuildCmd_pb.EQUERYGUILD_CITY_LARGE,
      [3] = GuildCmd_pb.EQUERYGUILD_CITY_MIDDLE,
      [4] = GuildCmd_pb.EQUERYGUILD_CITY_SMALL
    }
  end
  return GameConfig.Guild.CityFilterNames or self.cityFilterNameConfig, GameConfig.Guild.CityFilterValues or self.cityFilterValueConfig
end

function GuildProxy:GetAllGvgGroupFilterConfig()
  if not self.gvgGroupFilterNameConfig then
    local max = GvgProxy.Instance:GetGroupCnt()
    local guild = self:GetMyGuildClientGvgGroup()
    self.gvgGroupFilterNameConfig = {
      [1] = string.format(ZhString.GuildFindPage_AllGvgGroup, max),
      [2] = string.format(ZhString.GuildFindPage_CurGvgGroup, guild)
    }
  end
  if not self.gvgGroupFilterValueConfig then
    self.gvgGroupFilterValueConfig = {
      [1] = -1,
      [2] = GuildCmd_pb.EQUERYGUILD_CUR_GVGGROUP
    }
  end
  return self.gvgGroupFilterNameConfig, self.gvgGroupFilterValueConfig
end

function GuildProxy:QueryGuildData(guildId)
  if not self.guildData_Inited then
    return false
  end
  guildId = guildId or 0
  if guildId == 0 or self.guildId == guildId then
    return false
  end
  self.guildId = guildId
  self:ExitGuild()
  local temp = {
    summary = {}
  }
  ServiceGuildCmdProxy.Instance:CallEnterGuildGuildCmd(temp)
  return true
end

function GuildProxy:InitMyGuildData(guildData)
  if self:IsMercenaryGuildData(guildData) then
    self:InitMyMercenaryGuildData(guildData)
    GvgProxy.Instance:DoQueryGvgZoneGroup(true)
    return
  end
  if not self.guildData_Inited then
    self.guildData_Inited = true
  end
  local new_guild_guid = guildData.summary.guid
  if self.myGuildData ~= nil then
    if self.guildId ~= new_guild_guid then
      self:ExitGuild()
    else
      self.myGuildData = nil
    end
  end
  self.myGuildData = MyselfGuildData.new(guildData)
  self.guildId = self.myGuildData.id
  UnionLogo.Ins():SetUnionID(self.myGuildData.id)
  GvgProxy.Instance:DoQueryGvgZoneGroup(true)
  GvgProxy.Instance:QueryCityInfo()
end

function GuildProxy:UpdateMyGuildData(data)
  if self.myGuildData ~= nil and self.guildId == data.guildid then
    self.myGuildData:UpdateData(data.updates)
  end
  if self.myMercenaryGuild ~= nil and self.myMercenaryGuildId == data.guildid then
    self.myMercenaryGuild:UpdateData(data.updates)
  end
end

function GuildProxy:UpdateMyGuildJob(server_job)
  if not self.myGuildData then
    return
  end
  self.myGuildData:UpdateGuildJobInfo(server_job)
end

function GuildProxy:GetMyGuildCreateTime()
  if self:IHaveGuild() then
    return self.myGuildData.createtime
  end
  return nil
end

function GuildProxy:GetMyGuildOccupyCity()
  if self:IHaveGuild() then
    return self.myGuildData.occupy_city
  end
  return nil
end

function GuildProxy:UpdateMyMembers(guildMembers, dels)
  if not self.myGuildData then
    errorLog("Not Find MyGuildData (UpdateMyMembers)")
    return
  end
  if guildMembers then
    self.myGuildData:SetMembers(guildMembers)
  end
  if dels then
    self.myGuildData:RemoveMembers(dels)
  end
end

function GuildProxy:UpdateMyGuildMemberData(charid, updates)
  if not self.myGuildData then
    errorLog("Not Find MyGuildData (UpdateMyGuildMemberData)")
    return
  end
  local memberData = self.myGuildData:GetMemberByGuid(charid)
  if memberData then
    memberData:UpdateData(updates)
  end
end

function GuildProxy:UpdateMyGuildApplyData(charid, updates)
  if not self.myGuildData then
    errorLog("Not Find MyGuildData (UpdateMyGuildApplyData)")
    return
  end
  local applyData = self.myGuildData:GetApplyByGuid(charid)
  if applyData then
    applyData:UpdateData(updates)
  end
end

function GuildProxy:UpdateMyApplys(guildApplys, dels, mercenaryDels)
  if not self.myGuildData then
    errorLog("Not Find MyGuildData (UpdateMyApplys)")
    return
  end
  if guildApplys then
    self.myGuildData:SetApplys(guildApplys)
  end
  if dels then
    self.myGuildData:RemoveApplys(dels)
  end
  if mercenaryDels then
    self.myGuildData:RemoveMercenaryApplies(mercenaryDels)
  end
end

function GuildProxy:UpdateRewardState(data)
  if data.has then
    self.hasReward = true
  else
    self.hasReward = false
  end
end

function GuildProxy:GetRewardState()
  return self.hasReward
end

function GuildProxy:ExitGuild(guildid)
  if guildid and self:IsMyMercenaryGuild(guildid) then
    self:ExitMercenaryGuild()
    return
  end
  if self.myGuildData then
    ArtifactProxy.Instance:ClearData()
    self.myGuildData:Exit()
  end
  UnionLogo.Ins():SetUnionID(nil)
  FunctionGuild.Me():ResetGuildItemQueryState()
  FunctionGuild.Me():ResetGuildEventQueryState()
  self.myGuildData = nil
  self.guildId = nil
  self:ClearGuildPackItems()
end

function GuildProxy:GetMyGuildMemberData()
  if self.myGuildData then
    local myid = Game.Myself.data.id
    return self.myGuildData:GetMemberByGuid(myid)
  end
end

function GuildProxy:GetGuildMemberDataById(guid)
  if guid and self.myGuildData then
    return self.myGuildData:GetMemberByGuid(guid)
  end
end

function GuildProxy:IsChairmanOfMyGuild(guid)
  if guid and self.myGuildData then
    return self.myGuildData:GetChairMan().id == guid
  end
  return false
end

function GuildProxy:GetMyGuildJob()
  local data = self:GetMyGuildMemberData()
  return data and data.job
end

function GuildProxy:IHaveGuild()
  return self.myGuildData ~= nil
end

function GuildProxy:IHaveClassicCity()
  if not self:IHaveGuild() then
    return false
  end
  return self.myGuildData:HasClassicModeCity()
end

function GuildProxy:ImGuildChairman()
  return self.myGuildData and self.myGuildData:GetChairMan() and self.myGuildData:GetChairMan().id == Game.Myself.data.id
end

function GuildProxy:ImGuildViceChairman()
  local list = self.myGuildData and self.myGuildData:GetViceChairmanList()
  if list ~= nil then
    local myselfid = Game.Myself.data.id
    for i = 1, #list do
      if list[i].id == myselfid then
        return true
      end
    end
  end
  return false
end

function GuildProxy:IsDismissing()
  return self.myGuildData and self.myGuildData.dismisstime > ServerTime.CurServerTime() / 1000
end

function GuildProxy:CheckIsInMyGuild(playerid)
  return self.myGuildData and self.myGuildData:GetMemberByGuid(playerid) ~= nil
end

function GuildProxy:CanJobDoAuthority(job, authorityType)
  if self.myGuildData == nil then
    return
  end
  if job and authorityType then
    local authorityType_value, authority_value
    if 32 < authorityType then
      authorityType_value = 1 << authorityType - 32 - 1
      _, authority_value = self.myGuildData:GetJobAuthValue(job)
    else
      authorityType_value = 1 << authorityType - 1
      authority_value, _ = self.myGuildData:GetJobAuthValue(job)
    end
    return 0 < authority_value & authorityType_value
  end
  return false
end

function GuildProxy:CanIDoAuthority(authorityType)
  local mygm = self:GetMyGuildMemberData()
  if mygm then
    helplog("@@@ mygm.job" .. mygm.job)
    return self:CanJobDoAuthority(mygm.job, authorityType)
  end
  helplog("@@@ mygm false")
  return false
end

function GuildProxy:CanIEditAuthority(job, authorityType)
  local mygm = self:GetMyGuildMemberData()
  if mygm then
    local myjob = mygm.job
    local jobConfig = Table_GuildJob[myjob]
    local jobEditable = jobConfig and jobConfig.EditableJob
    if jobEditable and table.ContainsValue(jobEditable, job) then
      local config = Table_GuildJob[job]
      if config then
        local configEditValue, configEditValue2 = config.DefaultAuthority, config.DefaultAuthority2
        local editvalue, edit2value = self.myGuildData:GetJobEditAuth(myjob)
        local needAuth
        if 32 < authorityType then
          needAuth = 1 << authorityType - 32 - 1
          return 0 < configEditValue2 & needAuth and 0 < edit2value & needAuth
        else
          needAuth = 1 << authorityType - 1
          return 0 < configEditValue & needAuth and 0 < editvalue & needAuth
        end
      end
    end
  end
  return false
end

function GuildProxy:GetJobEditAuthority(job)
  local config = Table_GuildJob[job]
  local editvalue, edit2value = config and config.DefaultEditAuthority, config and config.DefaultEditAuthority2 or 0
  if 0 < editvalue or 0 < edit2value then
    local result = {}
    for _, gtype in pairs(GuildAuthorityMap) do
      if 32 < gtype then
        local typevalue = 1 << gtype - 32 - 1
        if 0 < edit2value & typevalue then
          table.insert(result, gtype)
        end
      else
        local typevalue = 1 << gtype - 1
        if 0 < editvalue & typevalue then
          table.insert(result, gtype)
        end
      end
    end
    return result
  end
end

function GuildProxy:GetFaithAttri(prayType, level)
  local config = Table_Guild_Faith[prayType]
  local result = {}
  for key, value in pairs(config.BaseValue) do
    result[key] = value
  end
  for key, value in pairs(config.GrowValue) do
    if result[key] then
      result[key] = result[key] + value
    else
      result[key] = value
    end
  end
  return result
end

function GuildProxy:GetFaithCost(prayType, level)
  local config = Table_Guild_Faith[prayType]
  local result = {}
  result.sliver = config.Money * (level + 1)
  result.contribution = config.Contribution[1] * (level + 1)
  return result
end

function GuildProxy:CheckPlayerInMyGuild(playerid)
  local myGuildData = self.myGuildData
  if myGuildData then
    return myGuildData:GetMemberByGuid(playerid) ~= nil
  end
  return false
end

function GuildProxy:GetGuildMaxLevel()
  if not self.maxlevel then
    self.maxlevel = #Table_Guild
  end
  return self.maxlevel
end

function GuildProxy:SetMyGuildDonateItems(items)
  if items then
    for i = 1, #items do
      self:AddOrUpdateGuildDonateItem(items[i])
    end
  end
end

function GuildProxy:ClearGuildDonateItems()
  _TableClear(self.donateItems)
end

function GuildProxy:AddOrUpdateGuildDonateItem(serverItem)
  if serverItem then
    local key = string.format("%s_%s", serverItem.time, serverItem.configid)
    local donateItem = self.donateItems[key]
    if not donateItem then
      donateItem = {}
      donateItem.cid = key
      donateItem.configid = serverItem.configid
      donateItem.itemid = serverItem.itemid
      donateItem.itemcount = serverItem.itemcount
      donateItem.contribute = serverItem.contribute
      donateItem.medal = serverItem.medal
      donateItem.nextconfigid = serverItem.nextconfigid
      donateItem.time = serverItem.time
      self.donateItems[key] = donateItem
      FunctionDonateItem.Me():SetDetailInfo(serverItem.configid, serverItem.con, serverItem.asset)
    end
    donateItem.count = serverItem.count
  end
end

function GuildProxy:RemoveGuildDonateItem(serverItem)
  if serverItem then
    local key = string.format("%s_%s", serverItem.time, serverItem.configid)
    local item = self.donateItems[key]
    if item then
      self.donateItems[key] = nil
    end
  end
end

function GuildProxy:RefreshGuildDonateItem(SendItem, GetItem)
  local donateData = SendItem
  local nextconfigid = SendItem.nextconfigid
  local time = SendItem.time
  local configid = SendItem.configid
  local itemid = SendItem.itemid
  if GetItem.configid == 0 then
    local donateList = self:GetGuildDonateItemList()
    for i = 1, #donateList do
      local tempItem = donateList[i]
      if tempItem.itemid == itemid and tempItem.time == time then
        self:RemoveGuildDonateItem(tempItem)
      end
    end
  else
    for i = 1, 5 do
      local donateList = self:GetGuildDonateItemList()
      for i = 1, #donateList do
        local tempItem = donateList[i]
        if tempItem.configid == nextconfigid and tempItem.time == time then
          time = tempItem.time
          configid = tempItem.configid
          nextconfigid = tempItem.nextconfigid
          self:RemoveGuildDonateItem(donateData)
          donateData = tempItem
        end
        if configid == GetItem.configid then
          return
        end
      end
    end
  end
end

function GuildProxy:GetGuildDonateItemList()
  if self.donateItems then
    local result = {}
    for _, donateItem in pairs(self.donateItems) do
      table.insert(result, donateItem)
    end
    table.sort(result, GuildProxy.SortDonateItems)
    return result
  end
end

function GuildProxy:GetGuildDonateItemSingleList()
  if self.donateItems then
    local result = {}
    local tempList = {}
    for _, donateItem in pairs(self.donateItems) do
      if tempList[donateItem.time] == nil then
        tempList[donateItem.time] = donateItem
      elseif tempList[donateItem.time].time == donateItem.time then
        if tempList[donateItem.time].configid > donateItem.configid then
          tempList[donateItem.time] = donateItem
        elseif tempList[donateItem.time].configid < donateItem.configid then
        end
      end
    end
    for _, temp in pairs(tempList) do
      table.insert(result, temp)
    end
    table.sort(result, GuildProxy.SortDonateItems)
    return result
  end
end

function GuildProxy.SortDonateItems(a, b)
  if a.time ~= b.time then
    return a.time > b.time
  end
  return a.configid > b.configid
end

function GuildProxy:SetGuildPackItems(serverItems)
  if not self.myGuildData then
    return
  end
  self.myGuildData:SetGuildPackItems(serverItems)
end

function GuildProxy:RemoveGuildPackItems(dels)
  if not self.myGuildData or not dels then
    return
  end
  self.myGuildData:RemoveGuildPackItems(dels)
end

function GuildProxy:ClearGuildPackItems()
  if not self.myGuildData then
    return
  end
  self.myGuildData:ClearGuildPackItems()
end

function GuildProxy:GetGuildPackItemByItemid(itemid)
  if not self.myGuildData then
    return nil
  end
  return self.myGuildData:GetGuildPackItemByItemid(itemid)
end

function GuildProxy:GetGuildPackItemByGuid(id)
  if self.myGuildData then
    return self.myGuildData:GetGuildPackItemByGuid(id)
  end
  return nil
end

function GuildProxy:GetGuildPackItemNumByItemid(itemid)
  if not self.myGuildData then
    return 0
  end
  return self.myGuildData:GetGuildPackItemNumByItemid(itemid)
end

function GuildProxy:SetGuildGateInfo(gatedatas)
  if not gatedatas or #gatedatas < 1 then
    return
  end
  self.gateChanged = true
  local gatedata = gatedatas[1]
  local npcid = gatedata.gatenpcid
  local client_gatedata = self.sceneGuildGateMap[npcid]
  if client_gatedata == nil then
    client_gatedata = {}
    client_gatedata.gatenpcid = npcid
    self.sceneGuildGateMap[npcid] = client_gatedata
  end
  client_gatedata.killedbossnum = gatedata.killedbossnum
end

function GuildProxy:GetGuildTeamMembermateNumInRaid()
  local usernum = 0
  local myTeam = TeamProxy.Instance.myTeam
  if myTeam then
    local myMembers = myTeam:GetMembersListExceptMe()
    for i = 1, #myMembers do
      local memberData = myMembers[i]
      local memberIndex = memberData.guildraidindex
      if not memberData:IsOffline() and memberIndex and 0 ~= memberIndex and self:CheckIsInMyGuild(memberData.id) then
        usernum = usernum + 1
      end
    end
  end
  return usernum
end

function GuildProxy:GetGuildGateInfoByNpcId(roleid)
  return self.sceneGuildGateMap[roleid]
end

function GuildProxy:GetGuildGateInfoArray()
  if self.gateChanged then
    _ArrayClear(self.guildGateList)
    for k, v in pairs(self.sceneGuildGateMap) do
      self.guildGateList[#self.guildGateList + 1] = v
    end
    table.sort(self.guildGateList, function(l, r)
      if l.sortID == r.sortID then
        return l.level > r.level
      else
        return l.sortID > r.sortID
      end
    end)
    self.gateChanged = false
  end
  return self.guildGateList
end

function GuildProxy:GetGuildGateInfoMap()
  return self.sceneGuildGateMap
end

function GuildProxy:ClearGuildGateInfo()
  _TableClear(self.sceneGuildGateMap)
end

function GuildProxy:GetGuildActivityList()
  self:_InitFuncMenu()
  local result = {}
  for _, data in pairs(Table_GuildFunction) do
    if self:_CheckGuildActivityData(data) then
      if data.AssembleId then
        table.insert(result, 1, data)
      else
        table.insert(result, data)
      end
    end
  end
  return result
end

function GuildProxy:_InitFuncMenu()
  if not self.funcMenuMap then
    self.funcMenuMap = {}
    local config = GameConfig.Guild
    if config.pray and config.pray.guild_function_id then
      self.funcMenuMap[config.pray.guild_function_id] = config.pray.menu
    end
    if config.bless and config.bless.guild_function_id then
      self.funcMenuMap[config.bless.guild_function_id] = config.bless.menu
    end
    if config.holy and config.holy.guild_function_id then
      self.funcMenuMap[config.holy.guild_function_id] = config.holy.menu
    end
  end
end

function GuildProxy:ForbiddenUniqueNpc(id)
  if not Game.MapManager:IsInGuildMap() then
    return false
  end
  if not self:_CheckFunctionUnlockByUniqueID(id) then
    return true
  end
  return false
end

function GuildProxy:_CheckFunctionUnlockByUniqueID(unique_id)
  local forbiddenUniqueId = GameConfig.Guild.checkClickForbiddenUniqueId
  if not forbiddenUniqueId then
    return true
  end
  local menuID = forbiddenUniqueId[unique_id]
  if not menuID then
    return true
  end
  return FunctionUnLockFunc.Me():CheckCanOpen(menuID)
end

local GUILD_TASK_CHALLENGE_PANELID = 549
local CHECK_FUNCSTATE_GUILD_ID = {
  [234] = 4,
  [236] = 6
}
local checkTimeFunc = function(startTimeStr, endTimeStr)
  local startTimeStamp = ClientTimeUtil.GetOSDateTime(startTimeStr)
  local endTimeStamp = ClientTimeUtil.GetOSDateTime(endTimeStr)
  local curTimeStamp = ServerTime.CurServerTime() / 1000
  if startTimeStamp and endTimeStamp then
    return startTimeStamp <= curTimeStamp and endTimeStamp > curTimeStamp
  end
end

function GuildProxy:_CheckGuildActivityData(data)
  if data == nil or data.Display ~= 1 then
    return false
  end
  local menuid = self.funcMenuMap and self.funcMenuMap[data.id]
  if menuid and not FunctionUnLockFunc.Me():CheckCanOpen(menuid) then
    return false
  end
  local funcStateId = CHECK_FUNCSTATE_GUILD_ID[data.id]
  if nil ~= funcStateId and nil ~= Table_FuncState[funcStateId] and not FunctionUnLockFunc.checkFuncStateValid(funcStateId) then
    return false
  end
  if data.PanelId == GUILD_TASK_CHALLENGE_PANELID and not self.myGuildData:CheckFunctionOpen(GuildCmd_pb.EGUILDFUNCTION_BUILDING) then
    return false
  end
  if data.FinishTime == "" or data.AppearTime == "" then
    return false
  end
  local appearTimeRange = data.AppearTimeRange
  if appearTimeRange and appearTimeRange[1] then
    for _, range in pairs(appearTimeRange) do
      local startTime, endTime = range[1], range[2]
      return checkTimeFunc(startTime, endTime)
    end
  else
    return checkTimeFunc(data.AppearTime, data.FinishTime)
  end
end

function GuildProxy:Server_ResetGuildEventList(serverEventlist)
  if not self.myGuildData then
    return
  end
  self.myGuildData:Server_ResetGuildEventList(serverEventlist)
end

function GuildProxy:Server_AddGuildEventData(serverEventData)
  if not self.myGuildData then
    return
  end
  self.myGuildData:Server_AddGuildEventData(serverEventData)
end

function GuildProxy:Server_SetApprovedInfo(data)
  if not self.myGuildData then
    return
  end
  self.myGuildData:Server_SetApprovedInfo(data)
end

function GuildProxy:Server_RemoveGuildEventData(id)
  if not self.myGuildData then
    return
  end
  self.myGuildData:Server_RemoveGuildEventData(id)
end

function GuildProxy:ClearGuildEventList()
  if not self.myGuildData then
    return
  end
  self.myGuildData:ClearGuildEventList()
end

function GuildProxy:UpdateMyGuildHeadDatas(server_infos, server_dels)
  if self.myGuildData == nil then
    return
  end
  self.myGuildData:Server_SetCustomIcons(server_infos, server_dels)
end

function GuildProxy:UpdateMyGuildHeadDataState(index, state, createtime, isdelete, type)
  if self.myGuildData == nil then
    return
  end
  self.myGuildData:Server_UpdateCustomIcon(index, state, createtime, isdelete, type)
end

function GuildProxy:SetGuildWelfare(welfare)
  if not self.myGuildData then
    return
  end
  self.guildWelfare = welfare
end

function GuildProxy:HasGuildWelfare()
  if not self.myGuildData then
    return false
  end
  return self.guildWelfare == true
end

function GuildProxy:GetWelfareNpcId()
  return GameConfig.GuildBuilding and GameConfig.GuildBuilding.npcid_getwelfare or 0
end

function GuildProxy:UpdateGuildChallengeTasks(updates, dels, refreshtime)
  if self.myGuildData == nil then
    return
  end
  self.myGuildData:Server_UpdateTasks(updates, dels, refreshtime)
end

function GuildProxy:DoQueryGuildInfo(data)
  self.queryRankGuildPortrait = data.portrait
  ServiceGuildCmdProxy.Instance:CallQueryGvgGuildInfoGuildCmd(data.id)
end

function GuildProxy:GetGuildRankQueryPortrait()
  return self.queryRankGuildPortrait or 1
end

function GuildProxy:SetExitTimeTick(timetick)
  self.exit_timetick = timetick
end

function GuildProxy:ClearMemberBifrostInfo()
  if self.memberBifrostInfo then
    for i = 1, #self.memberBifrostInfo do
      ReusableTable.DestroyAndClearTable(self.memberBifrostInfo[i])
    end
    ReusableTable.DestroyAndClearArray(self.memberBifrostInfo)
    self.memberBifrostInfo = nil
  end
  self.memberBifrostScore = nil
end

function GuildProxy:HandleQueryMemberBifrostInfo(serverDatas, score)
  self:ClearMemberBifrostInfo()
  self.memberBifrostScore = score
  self.memberBifrostInfo = ReusableTable.CreateArray()
  table.sort(serverDatas, function(l, r)
    if l.totalscore == r.totalscore then
      return l.charid < r.charid
    else
      return l.totalscore > r.totalscore
    end
  end)
  for i = 1, #serverDatas do
    self.memberBifrostInfo[i] = GuildMemberBifrostInfoData.ParseServerData(ReusableTable.CreateTable(), serverDatas[i], i)
  end
end

function GuildProxy:GetMemberBifrostInfo()
  return self.memberBifrostInfo
end

function GuildProxy:ClearGuildScoreRank()
  if self.scoreRankDatas then
    for i = 1, #self.scoreRankDatas do
      ReusableTable.DestroyAndClearTable(self.scoreRankDatas[i])
    end
    ReusableTable.DestroyAndClearArray(self.scoreRankDatas)
    self.scoreRankDatas = nil
  end
  self.myGuildScore = nil
end

function GuildProxy:HandleQueryBifrostRankGuildCmd(serverDatas)
  self:ClearGuildScoreRank()
  self.scoreRankDatas = ReusableTable.CreateArray()
  for i = 1, #serverDatas do
    self.scoreRankDatas[i] = GuildScoreRankData.ParseServerData(ReusableTable.CreateTable(), serverDatas[i], i)
  end
end

local MAX = math.max

function GuildProxy:TryResetMyGuildScore(old, new)
  local delta = new - old
  if nil ~= self.scoreRankDatas and nil ~= self.guildId then
    for i = 1, #self.scoreRankDatas do
      if self.scoreRankDatas[i].guildid == self.guildId then
        self.myGuildScore = self.scoreRankDatas[i].score + delta
        self.scoreRankDatas[i].score = MAX(self.myGuildScore, self.scoreRankDatas[i].score)
        break
      end
    end
  end
end

function GuildProxy:GetGuildScoreRank()
  return self.scoreRankDatas
end

function GuildProxy:GetExitTimeTick()
  if self.exit_timetick == nil then
    return 0
  end
  local cdTime = GameConfig.Guild.enterpunishtime or 3600
  return self.exit_timetick + cdTime
end

function GuildProxy:IsInJoinCD()
  local exittimetick = self:GetExitTimeTick()
  if exittimetick == 0 then
    return false
  end
  return 0 < ServerTime.ServerDeltaSecondTime(exittimetick * 1000)
end

function GuildProxy:UpdateGuildAssemble(data)
  if data.awardid then
    if not self.guildAssembleRewardedIds then
      self.guildAssembleRewardedIds = {}
    end
    for i = 1, #data.awardid do
      self.guildAssembleRewardedIds[i] = data.awardid[i]
    end
  end
  redlog("GuildProxy:UpdateGuildAssemble status", data.status)
  self.guildAssembleState = data.status
  self.isGuildAssembleNew = data.isnew
  self.isCurCharAssembled = data.isacceptchar or false
  self.isAssembledInCurGuild = data.iscompleteguild or false
end

function GuildProxy:GetGuildAssembleCompleteNum()
  if self.myGuildData then
    return self.myGuildData.assembly_complete_num
  end
  return 0
end

function GuildProxy:GetGuildAssembleState()
  return self.guildAssembleState
end

function GuildProxy:IsAssembleRewardReceived(id)
  if self.guildAssembleRewardedIds then
    return TableUtility.ArrayFindIndex(self.guildAssembleRewardedIds, id) > 0
  end
  return false
end

function GuildProxy:IsActivityAssembleNew()
  return self.guildAssembleState == ActivityCmd_pb.EGUILDASSEMBLE_STATUS_NONE and self.isGuildAssembleNew
end

function GuildProxy:IsCurrentCharacterAssembled()
  return self.isCurCharAssembled
end

function GuildProxy:IsAssembledInCurGuild()
  return self.isAssembledInCurGuild
end

function GuildProxy:IsMercenaryGuildData(data)
  if data.members then
    for _, member in ipairs(data.members) do
      if member.charid == Game.Myself.data.id then
        if member.job == GuildCmd_pb.EGUILDJOB_MERCENARY then
          return true
        end
        break
      end
    end
  end
  return false
end

function GuildProxy:GetMyMercenaryGuildData()
  return self.myMercenaryGuild
end

function GuildProxy:InitMyMercenaryGuildData(guildData)
  local newGuidId = guildData.summary.guid
  if self.myMercenaryGuild and self.myMercenaryGuildId ~= newGuidId then
    self:ExitMercenaryGuild()
  end
  self.myMercenaryGuild = MyselfGuildData.new(guildData)
  self.myMercenaryGuildId = self.myMercenaryGuild.id
end

function GuildProxy:UpdateMyMercenaryGuildData(serverData)
  if not self.myMercenaryGuild then
    return
  end
  self.myMercenaryGuild:UpdateData(serverData)
end

function GuildProxy:ExitMercenaryGuild()
  self.myMercenaryGuild = nil
  self.myMercenaryGuildId = nil
  EventManager.Me():PassEvent(GuildEvent.ExitMercenary)
end

function GuildProxy:IsMyMercenaryGuild(guildId)
  if self.myMercenaryGuildId and self.myMercenaryGuildId == guildId then
    return true
  end
  return false
end

function GuildProxy:DoIHaveMercenaryGuild()
  if self.myMercenaryGuildId and self.myMercenaryGuildId > 0 then
    return true
  end
  return false
end

function GuildProxy:GetMyGuildGvgGroup()
  return self.myGuildData and self.myGuildData.battle_group or 0
end

function GuildProxy:GetMyMercenaryGvgGroup()
  return self.myMercenaryGuild and self.myMercenaryGuild.battle_group or 0
end

function GuildProxy:GetMyGuildClientGvgGroup()
  return GvgProxy.ClientGroupId(self:GetMyGuildGvgGroup())
end

function GuildProxy:GetMyGuildMercenaryNum()
  return self.myGuildData and self.myGuildData.mercenaryNum
end

function GuildProxy:GetMyGuildMercenaryCount()
  return self.myGuildData and self.myGuildData.curmercenary
end

function GuildProxy:IsGuildDataBattleMvp()
  if self.myGuildData then
    return self.myGuildData.datebattle_mvp == true
  end
  return false
end

function GuildProxy:IsMyGuildHaveMercenary()
  local myMercenaryNum = self:GetMyGuildMercenaryCount()
  return myMercenaryNum and 0 < myMercenaryNum
end

function GuildProxy:GetMyMercenaryGuildMercenaryNum()
  return self.myMercenaryGuild and self.myMercenaryGuild.curmercenary
end

function GuildProxy:GetMercenaryNumForGVGChatChannel()
  if self:DoIHaveMercenaryGuild() then
    return self:GetMyMercenaryGuildMercenaryNum()
  else
    return self:GetMyGuildMercenaryNum()
  end
end

function GuildProxy:IsMyGuild(guildId)
  if self.guildId and self.guildId > 0 then
    return self.guildId == guildId
  end
  return false
end

function GuildProxy:IsPlayerMyGuildMercenary(guid)
  local guildMemberData = self.myGuildData and self.myGuildData:GetMemberByGuid(guid)
  if guildMemberData and guildMemberData:IsMercenary() then
    return true
  end
  return false
end

function GuildProxy:IsPlayerMyGuildMember(guid)
  local guildMemberData = self.myGuildData and self.myGuildData:GetMemberByGuid(guid)
  if not guildMemberData or guildMemberData:IsMercenary() then
    return false
  end
  return true
end

function GuildProxy:IsPlayerMercenary(creatureData)
  if creatureData == nil then
    return false
  end
  if creatureData.id == Game.Myself.data.id then
    return self:DoIHaveMercenaryGuild()
  end
  if creatureData.IsMercenary and creatureData:IsMercenary() then
    return true
  end
  return false
end

function GuildProxy:IsPlayerInMyGuildUnion(creatureData)
  local mercenaryGuildData = creatureData and creatureData:GetMercenaryGuildData()
  if mercenaryGuildData then
    return self:IsMyGuildUnion(mercenaryGuildData.id)
  end
  local guildData = creatureData and creatureData:GetGuildData()
  if guildData then
    return self:IsMyGuildUnion(guildData.id)
  end
end

function GuildProxy:IsMyGuildUnion(guildId)
  if not Game.MapManager:IsGVG_Date() and self:DoIHaveMercenaryGuild() then
    return self:IsMyMercenaryGuild(guildId)
  end
  return self:IsMyGuild(guildId)
end

function GuildProxy:GetMyGuildUnion()
  if not Game.MapManager:IsGVG_Date() and self:DoIHaveMercenaryGuild() then
    return self.myMercenaryGuild
  end
  return self.myGuildData
end

function GuildProxy:GetMyGuildZoneId()
  return self.myGuildData and self.myGuildData.zoneid
end

function GuildProxy:GetMyGuildServerId()
  return self.myGuildData and self.myGuildData.serverid
end

function GuildProxy:GetMyGuildUnionZoneId()
  local guild_union = self:GetMyGuildUnion()
  return guild_union and guild_union.zoneid
end

function GuildProxy:GetMyGuildUnionGvgGroupID()
  local guild_union = self:GetMyGuildUnion()
  return guild_union and guild_union.battle_group
end

function GuildProxy:GetMercenaryGuildName(creatureData)
  if not self:IsPlayerMercenary(creatureData) then
    return nil
  end
  if self:IsPlayerInMyGuildUnion(creatureData) then
    return nil
  end
  if not Game.MapManager:IsInGVG() then
    return nil
  end
  return creatureData:GetMercenaryGuildName()
end

function GuildProxy:GetTaskTraceList()
  local result
  local myGuildData = self.myGuildData
  if self.myGuildData then
    result = self.myGuildData:GetChallengeTaskList()
  end
  return result
end

function GuildProxy:GetGuildID()
  return self.myMercenaryGuildId or self.guildId
end

function GuildProxy:GetOwnGuildID()
  return self.guildId
end

function GuildProxy:GetGuildUnionID()
  return self:GetGuildID()
end

function GuildProxy:GetMyGuildOccupiedCity()
  local citys = self.myGuildData and self.myGuildData:GetCitys()
  return citys and citys[1]
end

function GuildProxy:DoMyGuildHaveOccupyCity()
  local myCity = self:GetMyGuildOccupiedCity()
  return myCity and myCity ~= 0
end
