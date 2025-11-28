autoImport("PvpRoomData")
autoImport("YoyoRoomData")
autoImport("MvpBattleTeamData")
autoImport("TeamPwsData")
autoImport("PVPStatueInfo")
autoImport("RewardEffectData")
PvpProxy = class("PvpProxy", pm.Proxy)
PvpProxy.Instance = nil
PvpProxy.NAME = "PvpProxy"
PvpProxy.Type = {
  Yoyo = MatchCCmd_pb.EPVPTYPE_LLH,
  DesertWolf = MatchCCmd_pb.EPVPTYPE_SMZL,
  GorgeousMetal = MatchCCmd_pb.EPVPTYPE_HLJS,
  PoringFight = MatchCCmd_pb.EPVPTYPE_POLLY,
  MvpFight = MatchCCmd_pb.EPVPTYPE_MVP,
  SuGVG = MatchCCmd_pb.EPVPTYPE_SUGVG,
  TutorMatch = MatchCCmd_pb.EPVPTYPE_TUTOR,
  TeamPws = MatchCCmd_pb.EPVPTYPE_TEAMPWS,
  FreeBattle = MatchCCmd_pb.EPVPTYPE_TEAMPWS_RELAX,
  ExpRaid = MatchCCmd_pb.EPVPTYPE_TEAMEXP,
  Tower = MatchCCmd_pb.EPVPTYPE_TOWER,
  PVECard = MatchCCmd_pb.EPVPTYPE_PVECARD,
  Seal = MatchCCmd_pb.EPVPTYPE_SEAL,
  Laboratory = MatchCCmd_pb.EPVPTYPE_LABORATORY,
  GroupRaid = MatchCCmd_pb.EPVPTYPE_GROUPRAID,
  Headwear = MatchCCmd_pb.EPVPTYPE_HEADWEAR,
  TransferFight = MatchCCmd_pb.EPVPTYPE_TRANSFERFIGHT,
  Einherjar = MatchCCmd_pb.EPVPTYPE_EINHERJAR,
  TwelvePVPBattle = MatchCCmd_pb.EPVPTYPE_TWELVE,
  TwelvePVPRelax = MatchCCmd_pb.EPVPTYPE_TWELVE_RELAX,
  TwelvePVPChampion = MatchCCmd_pb.EPVPTYPE_TWELVE_CHAMPION,
  TwelvePVPGM = MatchCCmd_pb.EPVPTYPE_TWELVE_GM,
  TeamPwsChampion = MatchCCmd_pb.EPVPTYPE_TEAMPWS_CHAMPION,
  Boss = MatchCCmd_pb.EPVPTYPE_BOSS,
  Element = MatchCCmd_pb.EPVPTYPE_ELEMENT,
  NormalMaterials = MatchCCmd_pb.EPVPTYPE_COMMON_MATERIALS,
  Triple = MatchCCmd_pb.EPVPTYPE_TRIPLE,
  TripleRelax = MatchCCmd_pb.EPVPTYPE_TRIPLE_RELAX,
  MemoryPalace = MatchCCmd_pb.EPVPTYPE_MEMORY_PALACE,
  MemoryRaid = MatchCCmd_pb.ERAIDTYPE_MEMORY_RAID
}
PvpProxy.PvpType2RaidType = {
  [MatchCCmd_pb.EPVPTYPE_LLH] = FuBenCmd_pb.ERAIDTYPE_PVP_LLH,
  [MatchCCmd_pb.EPVPTYPE_SMZL] = FuBenCmd_pb.ERAIDTYPE_PVP_SMZL,
  [MatchCCmd_pb.EPVPTYPE_HLJS] = FuBenCmd_pb.ERAIDTYPE_PVP_HLJS,
  [MatchCCmd_pb.EPVPTYPE_POLLY] = FuBenCmd_pb.ERAIDTYPE_PVP_POLLY,
  [MatchCCmd_pb.EPVPTYPE_MVP] = FuBenCmd_pb.ERAIDTYPE_MVPBATTLE,
  [MatchCCmd_pb.EPVPTYPE_SUGVG] = FuBenCmd_pb.ERAIDTYPE_SUPERGVG,
  [MatchCCmd_pb.EPVPTYPE_TEAMPWS] = FuBenCmd_pb.ERAIDTYPE_TEAMPWS,
  [MatchCCmd_pb.EPVPTYPE_TEAMEXP] = FuBenCmd_pb.ERAIDTYPE_TEAMEXP,
  [MatchCCmd_pb.EPVPTYPE_TRANSFERFIGHT] = FuBenCmd_pb.ERAIDTYPE_TRANSFERFIGHT,
  [MatchCCmd_pb.EPVPTYPE_TWELVE] = FuBenCmd_pb.ERAIDTYPE_TWELVE_PVP,
  [MatchCCmd_pb.EPVPTYPE_EINHERJAR] = FuBenCmd_pb.ERAIDTYPE_EINHERJAR,
  [MatchCCmd_pb.EPVPTYPE_TRIPLE] = FuBenCmd_pb.ERAIDTYPE_TRIPLE_PVP,
  [MatchCCmd_pb.EPVPTYPE_TOWER] = FuBenCmd_pb.ERAIDTYPE_TOWER,
  [MatchCCmd_pb.EPVPTYPE_SEAL] = FuBenCmd_pb.ERAIDTYPE_SEAL,
  [MatchCCmd_pb.EPVPTYPE_LABORATORY] = FuBenCmd_pb.ERAIDTYPE_LABORATORY,
  [MatchCCmd_pb.EPVPTYPE_HEADWEAR] = FuBenCmd_pb.ERAIDTYPE_HEADWEAR,
  [MatchCCmd_pb.EPVPTYPE_COMODO_TEAM_RAID] = FuBenCmd_pb.ERAIDTYPE_COMODO_TEAM_RAID,
  [MatchCCmd_pb.EPVPTYPE_PVECARD] = FuBenCmd_pb.ERAIDTYPE_PVECARD,
  [MatchCCmd_pb.EPVPTYPE_BOSS] = FuBenCmd_pb.ERAIDTYPE_BOSS,
  [MatchCCmd_pb.EPVPTYPE_ELEMENT] = FuBenCmd_pb.ERAIDTYPE_ELEMENT,
  [MatchCCmd_pb.EPVPTYPE_CRACK] = FuBenCmd_pb.ERAIDTYPE_CRACK,
  [MatchCCmd_pb.EPVPTYPE_COMMON_MATERIALS] = FuBenCmd_pb.ERAIDTYPE_COMMON_MATERIALS,
  [MatchCCmd_pb.EPVPTYPE_MEMORY_PALACE] = FuBenCmd_pb.ERAIDTYPE_MEMORY_PALACE,
  [MatchCCmd_pb.EPVPTYPE_MEMORY_RAID] = FuBenCmd_pb.ERAIDTYPE_MEMORY_RAID,
  [MatchCCmd_pb.EPVPTYPE_SPACETIME_ILLUSION] = FuBenCmd_pb.ERAIDTYPE_SPACETIME_ILLUSION
}
PvpProxy.RaidType2PvpType = {
  [FuBenCmd_pb.ERAIDTYPE_LABORATORY] = MatchCCmd_pb.EPVPTYPE_LABORATORY,
  [FuBenCmd_pb.ERAIDTYPE_COMODO_TEAM_RAID] = MatchCCmd_pb.EPVPTYPE_COMODO_TEAM_RAID,
  [FuBenCmd_pb.ERAIDTYPE_HEADWEAR] = MatchCCmd_pb.EPVPTYPE_HEADWEAR,
  [FuBenCmd_pb.ERAIDTYPE_THANATOS] = MatchCCmd_pb.EPVPTYPE_GROUPRAID,
  [FuBenCmd_pb.ERAIDTYPE_THANATOS_MID] = MatchCCmd_pb.EPVPTYPE_GROUPRAID,
  [FuBenCmd_pb.ERAIDTYPE_THANATOS_SCENE3] = MatchCCmd_pb.EPVPTYPE_GROUPRAID,
  [FuBenCmd_pb.ERAIDTYPE_THANATOS_FOURTH] = MatchCCmd_pb.EPVPTYPE_GROUPRAID,
  [FuBenCmd_pb.ERAIDTYPE_MVPBATTLE] = MatchCCmd_pb.EPVPTYPE_MVP,
  [FuBenCmd_pb.ERAIDTYPE_TEAMPWS] = MatchCCmd_pb.EPVPTYPE_TEAMPWS,
  [FuBenCmd_pb.ERAIDTYPE_TEAMEXP] = MatchCCmd_pb.EPVPTYPE_TEAMEXP,
  [FuBenCmd_pb.ERAIDTYPE_TRANSFERFIGHT] = MatchCCmd_pb.EPVPTYPE_TRANSFERFIGHT,
  [FuBenCmd_pb.ERAIDTYPE_TWELVE_PVP] = MatchCCmd_pb.EPVPTYPE_TWELVE,
  [FuBenCmd_pb.ERAIDTYPE_EINHERJAR] = MatchCCmd_pb.EPVPTYPE_EINHERJAR,
  [FuBenCmd_pb.ERAIDTYPE_TOWER] = MatchCCmd_pb.EPVPTYPE_TOWER,
  [FuBenCmd_pb.ERAIDTYPE_SEAL] = MatchCCmd_pb.EPVPTYPE_SEAL,
  [FuBenCmd_pb.ERAIDTYPE_PVECARD] = MatchCCmd_pb.EPVPTYPE_PVECARD,
  [FuBenCmd_pb.ERAIDTYPE_SUPERGVG] = MatchCCmd_pb.EPVPTYPE_SUGVG,
  [FuBenCmd_pb.ERAIDTYPE_PVP_POLLY] = MatchCCmd_pb.EPVPTYPE_POLLY,
  [FuBenCmd_pb.ERAIDTYPE_BOSS] = MatchCCmd_pb.EPVPTYPE_BOSS,
  [FuBenCmd_pb.ERAIDTYPE_CRACK] = MatchCCmd_pb.EPVPTYPE_CRACK,
  [FuBenCmd_pb.ERAIDTYPE_COMMON_MATERIALS] = MatchCCmd_pb.EPVPTYPE_COMMON_MATERIALS,
  [FuBenCmd_pb.ERAIDTYPE_MEMORY_PALACE] = MatchCCmd_pb.EPVPTYPE_MEMORY_PALACE,
  [FuBenCmd_pb.EPVPTYPE_MEMORY_RAID] = MatchCCmd_pb.ERAIDTYPE_MEMORY_RAID,
  [FuBenCmd_pb.ERAIDTYPE_SPACETIME_ILLUSION] = MatchCCmd_pb.EPVPTYPE_SPACETIME_ILLUSION
}
PvpProxy.RoomStatus = {
  WaitJoin = MatchCCmd_pb.EROOMSTATE_WAIT_JOIN,
  ReadyForFight = MatchCCmd_pb.EROOMSTATE_READY_FOR_FIGHT,
  Fighting = MatchCCmd_pb.EROOMSTATE_FIGHTING,
  Success = MatchCCmd_pb.EROOMSTATE_MATCH_SUCCESS,
  End = MatchCCmd_pb.EROOMSTATE_END
}
PvpProxy.TeamPws = {
  TeamColor = {
    Red = FuBenCmd_pb.ETEAMPWS_RED,
    Blue = FuBenCmd_pb.ETEAMPWS_BLUE
  }
}
PvpProxy.CanCancelType = {
  [PvpProxy.Type.TeamPwsChampion] = 1
}
PvpProxy.StatueType = {
  Triple = SceneMap_pb.PVP_CHAMPION_STATUE_TRIPLE,
  Teampws = SceneMap_pb.PVP_CHAMPION_STATUE_TEAMPWS,
  Twelve = SceneMap_pb.PVP_CHAMPION_STATUE_TWELVE
}

function PvpProxy.CheckCanCancel(type)
  return nil ~= PvpProxy.CanCancelType[type]
end

local RaidMaps = GameConfig.ReserveRoom.RaidMaps

function PvpProxy:ctor(proxyName, data)
  self.proxyName = proxyName or PvpProxy.NAME
  if PvpProxy.Instance == nil then
    PvpProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function PvpProxy:Init()
  self.pvpStatusMap = {}
  self.roomListMap = {}
  self.detail_roomid_map = {}
  self.server_teamPwsInfo = {}
  self.server_othelloInfo = {}
  self.fightStatInfo = {}
  self.fightStatInfo.ranks = {}
  self:ClearBosses()
  self.othelloCheckpointMap = {}
  self:InitRaidMaps()
  self.pvpMatchHeadCountInfo = {}
end

function PvpProxy:InitRaidMaps()
  if self.raidMaps then
    TableUtility.TableClear(self.raidMaps)
  else
    self.raidMaps = {}
  end
  if RaidMaps then
    for k, v in pairs(RaidMaps) do
      self.raidMaps[v.raidid] = v.name
    end
  end
end

function PvpProxy.IsPveCard(t)
  return t == PvpProxy.Type.PVECard
end

function PvpProxy.IsElememt(t)
  return t == PvpProxy.Type.Element
end

function PvpProxy:ClearBosses()
  self.bosses = {}
end

function PvpProxy:ResetMyRoomInfo()
  if self.myRoomData then
    self.myRoomData = nil
  end
end

function PvpProxy:SetMyRoomBriefInfo(type, brief_info)
  if brief_info == nil or brief_info.type == nil then
    redlog("PvpProxy-->ReSetMyRoomBriefInfo", brief_info.roomid)
    self:ResetMyRoomInfo()
  else
    local roomid = brief_info.roomid
    redlog("PvpProxy-->SetMyRoomBriefInfo", string.format("reqType:%s Roomid:%s Type:%s State:%s", type, roomid, brief_info.type, brief_info.state))
    self.myRoomData = PvpRoomData.new(roomid)
    self.myRoomData:SetData(brief_info)
    local roomlist = self:GetRoomList(type)
    if roomlist then
      local find = false
      for i = 1, #roomlist do
        if roomlist[i].guid == roomid then
          roomlist[i]:SetData(brief_info)
          find = true
          break
        end
      end
      if not find and type == PvpProxy.Type.DesertWolf then
        local myRoom = PvpRoomData.new(roomid)
        myRoom:SetData(brief_info)
        roomlist[#roomlist + 1] = myRoom
        table.sort(roomlist, function(l, r)
          return self:SortDesertRoomData(l, r)
        end)
      end
    end
  end
end

function PvpProxy:UpdateMyRoomStatus(pvp_type, roomid, state, endtime)
  if self.myRoomData and self.myRoomData.guid == roomid then
    redlog("PvpProxy-->UpdateMyRoomStatus", string.format("Type:%s Roomid:%s State:%s", pvp_type, roomid, state))
    self.myRoomData.state = state
    self.myRoomData:SetEndTime(endtime)
  end
end

function PvpProxy:GetMyRoomType()
  if self.myRoomData then
    return self.myRoomData.type
  end
end

function PvpProxy:GetMyRoomState(roomType)
  if self.myRoomData and (not roomType or self.myRoomData.type == roomType) then
    return self.myRoomData.state
  end
end

function PvpProxy:GetMyRoomGuid()
  if self.myRoomData then
    return self.myRoomData.roomid
  end
end

function PvpProxy:SetRoomList(type, room_lists)
  local detailRoomData
  local detail_roomid = self.detail_roomid_map[type]
  if detail_roomid then
    detailRoomData = self:GetRoomData(type, detail_roomid)
  end
  helplog("SetRoomList", type, detail_roomid, detailRoomData)
  local roomlist = {}
  local roomids = ""
  for i = 1, #room_lists do
    local list = room_lists[i]
    roomids = roomids .. " " .. list.roomid
    if detailRoomData and list.roomid == detailRoomData.guid then
      detailRoomData:SetData(list)
      detailRoomData:SetIndex(i)
      table.insert(roomlist, detailRoomData)
    else
      local roomdata = PvpRoomData.new(list.roomid)
      roomdata:SetData(list)
      roomdata:SetIndex(i)
      table.insert(roomlist, roomdata)
    end
  end
  if type == PvpProxy.Type.DesertWolf then
    table.sort(roomlist, function(l, r)
      return self:SortDesertRoomData(l, r)
    end)
  end
  self.roomListMap[type] = roomlist
end

function PvpProxy:SetYoyoRoomList(type, roomList)
  local yoyoRoomData = YoyoRoomData.new()
  yoyoRoomData:SetData(roomList)
  self.roomListMap[type] = yoyoRoomData:GetyoyoRoomData()
end

function PvpProxy:SortDesertRoomData(l, r)
  if l.roomid == self:GetMyRoomGuid() then
    return true
  elseif r.roomid == self:GetMyRoomGuid() then
    return false
  else
    return l.roomid < r.roomid
  end
end

function PvpProxy:GetRoomList(type)
  local roomlist = self.roomListMap[type]
  if roomlist then
    if type == PvpProxy.Type.GorgeousMetal then
      if self.gorgeousMetal_SortFunc == nil then
        function self.gorgeousMetal_SortFunc(a, b)
          local ina = false
          
          local inb = false
          if self.myRoomData ~= nil and self.myRoomData.type == type then
            ina = a.guid == self.myRoomData.guid
            inb = b.guid == self.myRoomData.guid
          end
          if ina ~= inb then
            return ina == true
          end
          return a.index < b.index
        end
      end
      table.sort(roomlist, self.gorgeousMetal_SortFunc)
    end
    return roomlist
  end
end

function PvpProxy:GetRoomData(type, guid)
  local roomlist = self.roomListMap[type]
  local roomData
  if roomlist then
    for i = 1, #roomlist do
      if roomlist[i].guid == guid then
        roomData = roomlist[i]
        break
      end
    end
  end
  return roomData
end

function PvpProxy:SetRoomDetailInfo(type, guid, detail_info)
  if type == nil then
    return
  end
  local roomData = self:GetRoomData(type, guid)
  if roomData then
    roomData:SetRoomDetailInfo(detail_info)
  else
    helplog("Not Find RoomData:" .. tostring(guid))
  end
  self.detail_roomid_map[type] = guid
end

function PvpProxy:GetFightStatInfo()
  return self.fightStatInfo
end

function PvpProxy:RecvNtfRankChangeCCmd(data)
  local ranks = data.ranks
  local rankDatas = {}
  for i = 1, #ranks do
    local tb = {}
    tb.name = ranks[i].name
    tb.apple = ranks[i].apple
    rankDatas[#rankDatas + 1] = tb
  end
  self.fightStatInfo.ranks = rankDatas
end

function PvpProxy:NtfFightStatCCmd(data)
  self.fightStatInfo.pvp_type = data.pvp_type
  self.fightStatInfo.starttime = data.starttime
  self.fightStatInfo.player_num = data.player_num
  self.fightStatInfo.score = data.score
  self.fightStatInfo.my_teamscore = data.my_teamscore
  self.fightStatInfo.enemy_teamscore = data.enemy_teamscore
  self.fightStatInfo.red_score = data.red_score
  self.fightStatInfo.blue_score = data.blue_score
  self.fightStatInfo.remain_hp = data.remain_hp
  if data.myrank == 9999 then
    self.fightStatInfo.myrank = nil
  else
    self.fightStatInfo.myrank = data.myrank
  end
  self:NotifyAddOrRemoveClassicPvpBord(true, data.pvp_type)
end

function PvpProxy:HandlePvpResult(result)
  local data = {}
  data.result = result
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.UIVictoryView,
    viewdata = data
  })
end

function PvpProxy:IsSelfInPvp()
  local mapid = Game.MapManager:GetMapID()
  if mapid then
    local mapRaid = Table_MapRaid[mapid]
    if mapRaid and (mapRaid.Type == FunctionDungen.YoyoType or mapRaid.Type == FunctionDungen.DesertWolfType or mapRaid.Type == FunctionDungen.GorgeousMetalType) then
      return true
    end
  end
  return false
end

function PvpProxy:IsSelfInGuildBase()
  return Game.MapManager:GetMapID() == 10001 or DojoProxy.Instance:IsSelfInDojo()
end

function PvpProxy:RecvSyncMvpInfoFubenCmd(initInfo)
  self:ClearBosses()
  self.usernum = initInfo.usernum
  local liveBosses = initInfo.liveboss
  local deadBosses = initInfo.dieboss
  for i = 1, #liveBosses do
    local single = liveBosses[i]
    local data = self.bosses[single]
    if not data then
      data = {live = 1, total = 1}
      self.bosses[single] = data
    else
      data.live = data.live + 1
      data.total = data.total + 1
    end
  end
  for i = 1, #deadBosses do
    local single = deadBosses[i]
    local data = self.bosses[single]
    if not data then
      data = {live = 0, total = 1}
      self.bosses[single] = data
    else
      data.total = data.total + 1
    end
  end
end

local SortMvpResult = function(l, r)
  local lMvpCount = l:GetKillMvpCount()
  local rMvpCount = r:GetKillMvpCount()
  if lMvpCount == rMvpCount then
    local lMiniCount = l:GetKillMiniCount()
    local rMiniCount = r:GetKillMiniCount()
    if lMiniCount == rMiniCount then
      return l.teamid < r.teamid
    else
      return lMiniCount > rMiniCount
    end
  else
    return lMvpCount > rMvpCount
  end
end

function PvpProxy:RecvMvpBattleReportFubenCmd(data)
  if self.mvpResultList == nil then
    self.mvpResultList = {}
  else
    TableUtility.ArrayClear(self.mvpResultList)
  end
  for i = 1, #data.datas do
    local mvpData = MvpBattleTeamData.new(data.datas[i])
    self.mvpResultList[#self.mvpResultList + 1] = mvpData
  end
  table.sort(self.mvpResultList, SortMvpResult)
  for i = 1, #self.mvpResultList do
    self.mvpResultList[i]:SetIndex(i)
  end
end

function PvpProxy:RecvUpdateUserNumFubenCmd(data)
  self.usernum = data.usernum
end

function PvpProxy:RecvBossDieFubenCmd(data)
  local data = self.bosses[data.npcid]
  if not data then
    data = {live = 0, total = 1}
    self.bosses[data.npcid] = data
  else
    local live = data.live
    if live and 0 < live then
      data.live = data.live - 1
    else
      data.live = 0
    end
  end
end

function PvpProxy:PvpTeamMemberUpdateCCmd(matchTeamMemUpdateInfo)
  if matchTeamMemUpdateInfo == nil then
    return
  end
  local roomid = matchTeamMemUpdateInfo.roomid
  local teamid = matchTeamMemUpdateInfo.teamid
  local isfirst = matchTeamMemUpdateInfo.isfirst
  local index = matchTeamMemUpdateInfo.index
  if roomid and teamid then
    local roomData = self:GetRoomData(PvpProxy.Type.GorgeousMetal, roomid)
    if roomData then
      local teamData = roomData:GetRoomTeamDataByPos(index)
      if teamData then
        teamData.id = teamid
        teamData.roomid = roomid
        local updates = matchTeamMemUpdateInfo.updates
        if updates then
          teamData:SetMembers(updates)
        end
        local deletes = matchTeamMemUpdateInfo.deletes
        if deletes then
          teamData:RemoveMembers(deletes)
        end
        local myTeam = TeamProxy.Instance.myTeam
        if myTeam == nil or myTeam.id == teamData.id and teamData.memberNum == 0 then
          self:ResetMyRoomInfo()
        end
      else
        redlog("PVP: Pos Is illegal", index, tostring(teamData))
      end
    end
  end
  local myID = Game.Myself.data.id
  local deletesId = matchTeamMemUpdateInfo.deletes
  for _, v in pairs(deletesId) do
    if v == myID then
      self:ResetMyRoomInfo()
      break
    end
  end
end

function PvpProxy:PvpMemberDataUpdate(matchTeamMemDataUpdateInfo)
  if matchTeamMemDataUpdateInfo == nil then
    return
  end
  local roomid = matchTeamMemDataUpdateInfo.roomid
  local teamid = matchTeamMemDataUpdateInfo.teamid
  local charid = matchTeamMemDataUpdateInfo.charid
  local members = matchTeamMemDataUpdateInfo.members
  if roomid and teamid and charid and members then
    local roomData = self:GetRoomData(PvpProxy.Type.GorgeousMetal, roomid)
    if roomData then
      local teamData = roomData:GetTeamByGuid(teamid)
      if teamData then
        local teamMemberData = teamData:GetMemberByGuid(charid)
        if teamMemberData then
          teamMemberData:SetMemberData(members)
        end
      end
    end
  end
end

function PvpProxy:DoKickTeamCCmd(type, roomid, zoneid, teamid)
  local roomList = self:GetRoomList(type)
  if roomList then
    for i = 1, #roomList do
      local roomData = roomList[i]
      if roomData and roomData.guid == roomid then
        roomData:RemoveTeamByGuid(teamid)
      end
    end
  end
  if self.myRoomData and self.myRoomData.guid == roomid then
    local myTeam = TeamProxy.Instance.myTeam
    if myTeam and myTeam.id == teamid then
      self:ResetMyRoomInfo()
    end
  end
  if type == PvpProxy.Type.DesertWolf then
    ServiceMatchCCmdProxy.Instance:CallReqRoomDetailCCmd(type, roomid)
  end
end

function PvpProxy:Req_Server_MyRoomMatchCCmd()
  if not self.reqMyRoom then
    self.reqMyRoom = true
    ServiceMatchCCmdProxy.Instance:CallReqMyRoomMatchCCmd()
  end
end

function PvpProxy:PoringFightResult(server_rank, server_rewards, server_apple)
  if server_rank == nil then
    return
  end
  self.poringFight_viewdata = {}
  self.poringFight_viewdata.rank = {}
  local myRank = 1
  local myCharid = Game.Myself.data.id
  local poringList = GameConfig.PoliFire and GameConfig.PoliFire.trans_buffid
  local npclist = {}
  for i = 1, #server_rank do
    local info = {}
    info.charid = server_rank[i].charid
    info.index = server_rank[i].index
    info.rank = server_rank[i].rank
    info.name = server_rank[i].name
    table.insert(self.poringFight_viewdata.rank, info)
    if info.charid == myCharid then
      myRank = info.rank
    end
    local listdata = {}
    listdata.npcid = poringList and poringList[info.index].monster or 10001
    listdata.name = info.name
    npclist[info.rank] = listdata
  end
  self.poringFight_viewdata.myRank = myRank or 1
  if server_rewards then
    self.poringFight_viewdata.rewards = {}
    for i = 1, #server_rewards do
      local reward = server_rewards[i]
      local item = ItemData.new(nil, reward.itemid)
      item.num = reward.count
      table.insert(self.poringFight_viewdata.rewards, item)
    end
  end
  self.poringFight_viewdata.apple = server_apple
  if myRank == 9999 then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PoringFightResultView
    })
  else
    Game.PlotStoryManager:Start(1, nil, nil, PlotConfig_Prefix.Anim, npclist)
  end
end

function PvpProxy:GetPoringFight_viewdata()
  return self.poringFight_viewdata
end

function PvpProxy:NotifyAddOrRemoveClassicPvpBord(add, pvpType)
  local fightInfo = self:GetFightStatInfo()
  if fightInfo then
    local PvpTypes = PvpProxy.Type
    if pvpType == PvpTypes.Yoyo or pvpType == PvpTypes.GorgeousMetal then
      if add then
        if not self.classicPvpLaunched then
          self.classicPvpLaunched = true
          GameFacade.Instance:sendNotification(MainViewEvent.AddDungeonInfoBord, "MainViewClassicPvpFightPage")
        end
      else
        self.classicPvpLaunched = false
        GameFacade.Instance:sendNotification(MainViewEvent.RemoveDungeonInfoBord, "MainViewClassicPvpFightPage")
      end
    elseif pvpType == PvpTypes.DesertWolf then
      if add then
        if not self.classicPvpLaunched then
          self.classicPvpLaunched = true
          GameFacade.Instance:sendNotification(MainViewEvent.AddDungeonInfoBord, "MainViewDesertWolfBord")
        end
      else
        self.classicPvpLaunched = false
        GameFacade.Instance:sendNotification(MainViewEvent.RemoveDungeonInfoBord, "MainViewDesertWolfBord")
      end
    end
  end
end

function PvpProxy:NtfMatchInfo(etype, ismatch, isfighting, robot_rest_time, robot_match_time, configid, begintime)
  if etype == nil then
    return
  end
  if self.matchStateMap == nil then
    self.matchStateMap = {}
  end
  if etype == PvpProxy.Type.Boss then
    configid = PveEntranceProxy.Instance:GetMatchRaidIdByBossId(configid)
  end
  self.matchStateMap[etype] = {}
  self.matchStateMap[etype].ismatch = ismatch
  self.matchStateMap[etype].isfighting = isfighting
  self.matchStateMap[etype].startMatchTime = begintime and 0 < begintime and begintime * 1000 or ismatch and ServerTime.CurServerTime() or nil
  self.matchStateMap[etype].robot_rest_time = robot_rest_time or 0
  self.matchStateMap[etype].robot_match_time = robot_match_time or 0
  self.matchStateMap[etype].configid = configid
  redlog("robot_rest_time,robot_match_time", robot_rest_time, robot_match_time, begintime)
  self:SetPrepareFinishFlag()
  if etype == PvpProxy.Type.TeamPws or etype == PvpProxy.Type.FreeBattle then
    if not ismatch then
      self:ClearTeamPwsPreInfo()
    else
      self:ClearInviteMap()
    end
    self.matchStateMap[etype].isprepare = false
  else
    self.latestEtype = etype
    self.latestMatchInfo = self.matchStateMap[etype]
  end
end

function PvpProxy:SetGroupRaidState(var)
  if var ~= self.groupRaidState then
    self.groupRaidState = var
  end
end

function PvpProxy:GetStartMatchTime(etype)
  if self.twelveMatch then
    for k, v in pairs(self.twelveMatch) do
      if v.ismatch then
        return v.coldtime
      end
    end
  end
  if self.matchStateMap == nil then
    return nil
  end
  return self.matchStateMap[etype].startMatchTime
end

function PvpProxy:GetRobotTime(etype)
  if not self.matchStateMap or not self.matchStateMap[etype] then
    return 0, 0
  end
  return self.matchStateMap[etype].robot_rest_time, self.matchStateMap[etype].robot_match_time
end

function PvpProxy:GetMatchState(etype)
  if self.matchStateMap == nil then
    return nil
  end
  return self.matchStateMap[etype]
end

function PvpProxy:GetNowMatchInfo()
  return self.latestEtype, self.latestMatchInfo
end

function PvpProxy:Is_polly_match()
  local matchStatus = self:GetMatchState(PvpProxy.Type.PoringFight)
  if matchStatus == nil then
    return false
  end
  return matchStatus.ismatch
end

function PvpProxy:ClearMatchInfo(pvpType)
  if self.matchStateMap == nil then
    return
  end
  if pvpType and self.matchStateMap[pvpType] then
    TableUtility.TableClear(self.matchStateMap[pvpType])
  end
  TableUtility.TableClear(self.matchStateMap)
  self.latestEtype = nil
  self.latestMatchInfo = nil
end

function PvpProxy:RecvGodEndTime(endtime)
  self.godendtime = endtime
end

function PvpProxy:GetGodEndTime()
  return self.godendtime
end

function PvpProxy:GetMvpResult()
  return self.mvpResultList
end

function PvpProxy:HandleSyncMatchInfo(data)
  if not data.ismatch and self.twelveMatch then
    TableUtility.TableClear(self.twelveMatch)
    self.twelveMatch = nil
    return
  end
  if not self.twelveMatch then
    self.twelveMatch = {}
  end
  local etype = data.etype
  self.twelveMatch[etype] = {
    ismatch = data.ismatch,
    coldtime = data.coldtime,
    raidid = data.raidid
  }
end

function PvpProxy:GetWarbandNextFightTime()
  local data = self.twelveMatch and self.twelveMatch[PvpProxy.Type.TwelvePVPChampion]
  if data then
    return data.coldtime
  end
end

function PvpProxy:GetCurMatchStatus()
  if self.twelveMatch then
    for k, v in pairs(self.twelveMatch) do
      if v.ismatch then
        return v, k, v.raidid
      end
    end
  end
  if not self.matchStateMap then
    return
  end
  for etype, status in pairs(self.matchStateMap) do
    if status.ismatch == true then
      return status, etype, status.configid
    end
  end
end

local maxPrepareTime
local GetMaxPrepareTime = function(type)
  if type == PvpProxy.Type.ExpRaid then
    maxPrepareTime = GameConfig.TeamExpRaid.max_prepare_time
  elseif type == PvpProxy.Type.TeamPws or type == PvpProxy.Type.FreeBattle then
    maxPrepareTime = GameConfig.PvpTeamRaidPublic.InvitePrepareTime
  elseif TwelvePvPProxy.Instance:Is12pvp(type) then
    maxPrepareTime = GameConfig.TwelvePvp and GameConfig.TwelvePvp.MatchConfig and GameConfig.TwelvePvp.MatchConfig.maxPrepTime
  end
  return maxPrepareTime or 60
end

function PvpProxy:CheckPwsIsReady(type)
  local myCharID = Game.Myself.data.id
  local data = self.inviteMap[type]
  if data then
    return data[myCharID] and data[myCharID] == true
  end
end

function PvpProxy:CheckInviteMatchAllReady(etype)
  local inviteData = self.inviteMap and self.inviteMap[etype]
  local myTeam = MatchPreparePopUp.PrepareData and MatchPreparePopUp.PrepareData.myTeam
  if inviteData and myTeam then
    for i = 1, #myTeam do
      if not myTeam[i].charID or not inviteData[myTeam[i].charID] then
        return false
      end
    end
    return true
  end
end

function PvpProxy:HandleInviteMatchAllReady(etype)
  if self:CheckInviteMatchAllReady(etype) then
    self:ClearInviteMap()
    self:ClearTeamPwsPreInfo()
  end
end

function PvpProxy:CheckHasChooseInviteMatch(etype)
  local myCharID = Game.Myself.data.id
  local data = self.inviteMap[etype]
  if data then
    return nil ~= data[myCharID]
  end
end

function PvpProxy:ClearInviteMap()
  if nil == self.inviteMap then
    return
  end
  for _, v in pairs(self.inviteMap) do
    ReusableTable.DestroyAndClearTable(v)
  end
  ReusableTable.DestroyAndClearTable(self.inviteMap)
  self.inviteMap = nil
  GameFacade.Instance:sendNotification(PVPEvent.TeamPws_ClearInviteMatch)
  self:RemoveTimeTick()
end

function PvpProxy:RecvTeamPvpReplyMatch(serverData)
  local type = serverData.pvptype
  local charid = serverData.charid
  if nil == charid or nil == type or not self.inviteMap then
    return
  end
  if not self.inviteMap[type] then
    redlog("后端同步了未初始化的匹配邀请 协议 TeamPvpInviteMatchCmd")
    return
  end
  local inviteData = self.inviteMap[type]
  inviteData[charid] = serverData.agree
  MatchPreparePopUp.Update6v6PrepareStatus(charid, serverData.agree)
end

function PvpProxy:InviteMatchType()
  if self.inviteMap then
    return next(self.inviteMap)
  end
end

function PvpProxy:RecvTeamInviteMatch(serverData)
  local serverType = serverData.pvptype
  if nil == serverType or nil == serverData.iscancel then
    return
  end
  if serverData.iscancel then
    self:ClearInviteMap()
    return
  end
  self.inviteMap = ReusableTable.CreateTable()
  self.inviteMap[serverType] = ReusableTable.CreateTable()
  self.inviteMap[serverType][serverData.charid] = true
  self.teamPwsPreInfo = ReusableTable.CreateTable()
  self.teamPwsPreInfo.type = serverType
  self.teamPwsPreInfo.startPrepareTime = ServerTime.CurServerTime()
  self.teamPwsPreInfo.maxPrepareTime = GetMaxPrepareTime(serverType)
  self.teamPwsPreInfo.myTeam = PvpProxy.Get6v6MyTeam(serverData.charid)
  if not MatchPreparePopUp then
    autoImport("MatchPreparePopUp")
  end
  MatchPreparePopUp.SetPrepareData(self.teamPwsPreInfo)
  MatchPreparePopUp.Show(serverType)
  self:CreateTimeTick()
end

function PvpProxy:CreateTimeTick()
  if not self.inviteTimeTick then
    self.inviteTimeTick = TimeTickManager.Me():CreateTick(0, 33, self.UpdateCountDown, self, 1)
  end
end

function PvpProxy:RemoveTimeTick()
  if self.inviteTimeTick then
    TimeTickManager.Me():ClearTick(self, 1)
    self.inviteTimeTick = nil
  end
end

function PvpProxy:UpdateCountDown()
  if not (self.teamPwsPreInfo and self.teamPwsPreInfo.maxPrepareTime) or not self.teamPwsPreInfo.startPrepareTime then
    self:RemoveTimeTick()
    return
  end
  local curTime = (ServerTime.CurServerTime() - self.teamPwsPreInfo.startPrepareTime) / 1000
  local leftTime = math.max(self.teamPwsPreInfo.maxPrepareTime - curTime, 0)
  if leftTime == 0 then
    local type = self.teamPwsPreInfo.type
    local hasChoose = self:CheckHasChooseInviteMatch(type)
    if not hasChoose then
      ServiceTeamRaidCmdProxy.Instance:CallTeamPvpReplyMatchCmd(type, Game.Myself.data.id, false)
    else
      self:ClearInviteMap()
    end
  end
end

function PvpProxy.Get6v6MyTeam(readyID)
  local datas = TeamProxy.Instance.myTeam:GetPlayerMemberList(true, true)
  local list = ReusableTable.CreateArray()
  local preData
  for i = 1, #datas do
    preData = ReusableTable.CreateTable()
    local readyEnum = 0
    if readyID == datas[i].id then
      readyEnum = 2
    end
    list[#list + 1] = TeamPwsData.ParsePrepareData(preData, datas[i].id, readyEnum)
  end
  return list
end

function PvpProxy:RecvTeamPwsPreInfoMatchCCmd(serverData)
  self:ClearTeamPwsPreInfo()
  if not self.matchStateMap then
    self.matchStateMap = {}
  end
  local serverType = serverData.etype
  if not self.matchStateMap[serverType] then
    self.matchStateMap[serverType] = {ismatch = true, isfighting = false}
  end
  self.matchStateMap[serverType].isprepare = true
  self.matchStateMap[serverType].goodMatch = serverData.goodmatch
  self.matchStateMap[serverType].robot_rest_time = 0
  self.matchStateMap[serverType].robot_match_time = 0
  self.teamPwsPreInfo = ReusableTable.CreateTable()
  self.teamPwsPreInfo.type = serverType
  if serverData.teaminfos then
    for i = 1, #serverData.teaminfos do
      local list, isMyTeam = self:ProcessPreInfo(serverData.teaminfos[i].charids)
      if isMyTeam then
        if self.teamPwsPreInfo.myTeam then
          LogUtility.Error("排位赛/休闲赛准备数据出错！")
          self:ClearTeamPwsPreInfo()
          self.teamPwsPreInfo = ReusableTable.CreateTable()
        end
        self.teamPwsPreInfo.myTeam = list
        self.teamPwsPreInfo.robotnum = serverData.teaminfos[i].robotnum
      else
        if self.teamPwsPreInfo.enemyTeam then
          LogUtility.Error("排位赛/休闲赛准备数据出错！")
          self:ClearTeamPwsPreInfo()
          self.teamPwsPreInfo = ReusableTable.CreateTable()
        end
        self.teamPwsPreInfo.enemyTeam = list
      end
    end
  end
  if TwelvePvPProxy.Instance:Is12pvp(serverType) then
    self.matchStateMap[serverType].goodMatch = true
    self.pvp12Camp = serverData.camp
    self.teamPwsPreInfo.camp = serverData.camp
    self.teamPwsPreInfo.campPlayerNum = {}
    self.teamPwsPreInfo.myPrepareFlag = false
    self.teamPwsPreInfo.campPlayerNum[FuBenCmd_pb.EGROUPCAMP_RED], self.teamPwsPreInfo.campPlayerNum[FuBenCmd_pb.EGROUPCAMP_BLUE] = 0, 0
  end
  self.teamPwsPreStartTime = ServerTime.CurServerTime()
  self.teamPwsPreInfo.startPrepareTime = self.teamPwsPreStartTime
  self.teamPwsPreInfo.maxPrepareTime = GetMaxPrepareTime(serverType)
  if not MatchPreparePopUp then
    autoImport("MatchPreparePopUp")
  end
  MatchPreparePopUp.SetPrepareData(self.teamPwsPreInfo)
  MatchPreparePopUp.Show(serverType)
end

function PvpProxy:Get12PvpMatchCamp()
  return self.pvp12Camp
end

function PvpProxy:CheckNeedProcessFake(serverType)
  return serverType == PvpProxy.Type.FreeBattle or serverType == PvpProxy.Type.TeamPws
end

function PvpProxy:ProcessPreInfo(datas)
  local isMyTeam = false
  local list = ReusableTable.CreateArray()
  local preData
  for i = 1, #datas do
    preData = ReusableTable.CreateTable()
    list[#list + 1] = TeamPwsData.ParsePrepareData(preData, datas[i])
    if preData.charID == Game.Myself.data.id then
      isMyTeam = true
    end
  end
  return list, isMyTeam
end

function PvpProxy:GetTeamPwsPreStartTime()
  return self.teamPwsPreStartTime
end

function PvpProxy:RecvUpdatePreInfoMatchCCmd(serverData)
  if not self.teamPwsPreInfo or self.teamPwsPreInfo.type ~= serverData.etype and serverData.etype ~= 0 then
    return
  end
  local charID = serverData.charid
  local datas = self.teamPwsPreInfo.myTeam
  local found = false
  for i = 1, #datas do
    if datas[i].charID == charID then
      datas[i].isReady = true
      found = true
      break
    end
  end
  if found or serverData.etype == PvpProxy.Type.GroupRaid then
    MatchPreparePopUp.UpdatePrepareStatus(charID)
  else
    datas = self.teamPwsPreInfo.enemyTeam
    for i = 1, #datas do
      if datas[i].charID == charID then
        datas[i].isReady = true
        break
      end
    end
  end
end

function PvpProxy:HandleTwelvePvpUpdatePreInfoMatchCCmd(serverData)
  if nil == self.teamPwsPreInfo or nil == self.teamPwsPreInfo.campPlayerNum or self.teamPwsPreInfo.type ~= serverData.etype then
    return
  end
  self.teamPwsPreInfo.campPlayerNum[serverData.camp] = self.teamPwsPreInfo.campPlayerNum[serverData.camp] + 1
  MatchPreparePopUp.CampPlayerNum = self.teamPwsPreInfo.campPlayerNum
  MatchPreparePopUp.Refresh12PvpPrepare(serverData.camp, serverData.charid)
end

function PvpProxy:SetPrepareFinishFlag(var)
  if var ~= self.prepareFinished then
    self.prepareFinished = var
  end
end

function PvpProxy:Reconnect()
  self:ClearMatchInfo()
  self:SetPrepareFinishFlag()
  self:ClearInviteMap()
  TwelvePvPProxy.Instance:Reconnect()
  TriplePlayerPvpProxy.Instance:Reset()
end

function PvpProxy:IsInPreparation()
  return self.prepareFinished == false
end

function PvpProxy:GetTeamPwsPreInfo()
  return self.teamPwsPreInfo
end

function PvpProxy:ClearTeamPwsPreInfo()
  if not self.teamPwsPreInfo then
    return
  end
  if self.teamPwsPreInfo.myTeam then
    for i = 1, #self.teamPwsPreInfo.myTeam do
      ReusableTable.DestroyAndClearTable(self.teamPwsPreInfo.myTeam[i])
    end
    ReusableTable.DestroyAndClearArray(self.teamPwsPreInfo.myTeam)
  end
  if self.teamPwsPreInfo.enemyTeam then
    for i = 1, #self.teamPwsPreInfo.enemyTeam do
      ReusableTable.DestroyAndClearTable(self.teamPwsPreInfo.enemyTeam[i])
    end
    ReusableTable.DestroyAndClearArray(self.teamPwsPreInfo.enemyTeam)
  end
  if self.teamPwsPreInfo.enemyFakeData then
    ReusableTable.DestroyAndClearArray(self.teamPwsPreInfo.enemyFakeData)
  end
  ReusableTable.DestroyAndClearTable(self.teamPwsPreInfo)
  self.teamPwsPreInfo = nil
end

function PvpProxy:ClearTeamPwsMatchInfo()
  if not self.matchStateMap then
    return
  end
  if self.matchStateMap[PvpProxy.Type.TeamPws] then
    TableUtility.TableClear(self.matchStateMap[PvpProxy.Type.TeamPws])
  end
  if self.matchStateMap[PvpProxy.Type.FreeBattle] then
    TableUtility.TableClear(self.matchStateMap[PvpProxy.Type.FreeBattle])
  end
end

function PvpProxy:RecvQueryTeamPwsUserInfoFubenCmd(serverData)
  self:CreateTeamPwsReportData(serverData.teaminfo)
end

function PvpProxy:RecvTeamPwsReportFubenCmd(serverData)
  self:CreateTeamPwsReportData(serverData.teaminfo, serverData.mvpuserinfo.charid)
  local data = {
    winTeamColor = serverData.winteam,
    mvpUserInfo = serverData.mvpuserinfo
  }
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.TeamPwsFightResultPopUp,
    viewdata = data
  })
end

function PvpProxy:CreateTeamPwsReportData(serverTeamInfos, mvpID)
  self:ClearTeamPwsReportData()
  self.teamPwsReportMap = ReusableTable.CreateTable()
  self.teamPwsReportMap.aveScores = ReusableTable.CreateTable()
  local reports = ReusableTable.CreateArray()
  local teamInfo, teamID, color, userInfos, data
  for i = 1, #serverTeamInfos do
    teamInfo = serverTeamInfos[i]
    teamID = teamInfo.teamid
    color = teamInfo.color
    userInfos = teamInfo.userinfos
    self.teamPwsReportMap.aveScores[color] = teamInfo.avescore
    for i = 1, #userInfos do
      data = TeamPwsData.ParseReportData(ReusableTable.CreateTable(), userInfos[i], teamID, color)
      if mvpID and mvpID == data.charID then
        data.isMvp = true
      end
      reports[#reports + 1] = data
    end
  end
  self.teamPwsReportMap.reports = reports
end

function PvpProxy:GetTeamPwsReportData()
  return self.teamPwsReportMap
end

function PvpProxy:ClearTeamPwsReportData()
  if self.teamPwsReportMap then
    for i = 1, #self.teamPwsReportMap.reports do
      ReusableTable.DestroyAndClearTable(self.teamPwsReportMap.reports[i])
    end
    ReusableTable.DestroyAndClearArray(self.teamPwsReportMap.reports)
    ReusableTable.DestroyAndClearTable(self.teamPwsReportMap.aveScores)
    ReusableTable.DestroyAndClearTable(self.teamPwsReportMap)
    self.teamPwsReportMap = nil
  end
end

function PvpProxy:RecvQueryTeamPwsRankMatchCCmd(serverData)
  if not self.teamPwsRankData then
    self.teamPwsRankData = ReusableTable.CreateArray()
  end
  local datas = serverData.rankinfo
  local rankData
  for i = 1, #datas do
    rankData = ReusableTable.CreateTable()
    self.teamPwsRankData[#self.teamPwsRankData + 1] = TeamPwsData.ParseRankData(rankData, datas[i])
  end
  local lastdatas = serverData.lastrankinfo
  local lastrankData
  if not self.lastTeamPwsRankData then
    self.lastTeamPwsRankData = ReusableTable.CreateArray()
  end
  for i = 1, #lastdatas do
    lastrankData = ReusableTable.CreateTable()
    self.lastTeamPwsRankData[#self.lastTeamPwsRankData + 1] = TeamPwsData.ParseRankData(lastrankData, lastdatas[i])
  end
  self.teamPwsDataProtect = true
  TimeTickManager.Me():CreateTick(30000, 30000, self.ClearTeamPwsRankDataProtect, self, 1)
end

function PvpProxy:GetTeamPwsRankData(last)
  self.teamPwsDataIsUsing = self.teamPwsRankData ~= nil or self.lastTeamPwsRankData ~= nil
  return last and self.lastTeamPwsRankData or self.teamPwsRankData
end

function PvpProxy:GetLastTeamPwsRankData()
  self.teamPwsDataIsUsing = self.lastTeamPwsRankData ~= nil
  return self.lastTeamPwsRankData
end

function PvpProxy:ClearTeamPwsRankDataProtect()
  TimeTickManager.Me():ClearTick(self, 1)
  self.teamPwsDataProtect = nil
  if not self.teamPwsDataIsUsing then
    self:ClearTeamPwsRankData()
  end
end

function PvpProxy:GetTeamPwsRankSearchResult(keyword, last)
  if not self.teamPwsRankSearchResult then
    self.teamPwsRankSearchResult = ReusableTable.CreateArray()
  end
  TableUtility.ArrayClear(self.teamPwsRankSearchResult)
  keyword = string.lower(keyword)
  local searchRange = last and self.lastTeamPwsRankData or self.teamPwsRankData
  for i = 1, #searchRange do
    local data = searchRange[i]
    if data.name and string.find(string.lower(data.name), keyword) then
      self.teamPwsRankSearchResult[#self.teamPwsRankSearchResult + 1] = data
    end
  end
  return self.teamPwsRankSearchResult
end

function PvpProxy:TeamPwsRankDataUseOver()
  self.teamPwsDataIsUsing = nil
  if not self.teamPwsDataProtect then
    self:ClearTeamPwsRankData()
  end
end

function PvpProxy:HandleQueryTeamPwsTeamInfo(data)
  if not data.season_begin or data.season_begin == 0 then
    self.teamPwsSeasonBegin = nil
    return
  end
  self.teamPwsSeason = data.season
  self.teamPwsInfoCount = data.count
  self.teamPwsSeasonBegin = data.season_begin
  self.teamPwsSeasonBreakBegin = data.season_breakbegin
  self.teamPwsSeasonBreakEnd = data.season_breakend
  self.seasonCount = GameConfig.PvpTeamRaid[7028].SeasonBattleTimes - 1
  self.seaonWeekDay, self.seasonHour, self.seasonMin = 0, 0, 0
  local server_act_time = data.config_time and data.config_time[1]
  if nil ~= server_act_time then
    self.seaonWeekDay, self.seasonHour, self.seasonMin = server_act_time.weekday, server_act_time.hour, server_act_time.min
  else
    self.seaonWeekDay, self.seasonHour = GameConfig.PvpTeamRaidPublic.ActivityStartTime[1].dayofweek, GameConfig.PvpTeamRaidPublic.ActivityStartTime[1].hour
  end
  self.pwsActivityDuration = GameConfig.PvpTeamRaidPublic.ActivityDuration.hour * 3600 + GameConfig.PvpTeamRaidPublic.ActivityDuration.min * 60
  local y = tonumber(os.date("%Y", self.teamPwsSeasonBegin))
  local m = tonumber(os.date("%m", self.teamPwsSeasonBegin))
  local d = tonumber(os.date("%d", self.teamPwsSeasonBegin))
  local h = tonumber(os.date("%H", self.teamPwsSeasonBegin))
  local M = tonumber(os.date("%M", self.teamPwsSeasonBegin))
  local beginweekday = ServantCalendarProxy.getWday(y, m, d)
  beginweekday = beginweekday == 7 and 0 or beginweekday
  if self.teamPwsSeasonBreakBegin and self.teamPwsSeasonBreakEnd and self.teamPwsSeasonBreakBegin ~= 0 and self.teamPwsSeasonBreakEnd ~= 0 then
    self.breakWeekInterval = math.ceil((self.teamPwsSeasonBreakEnd - self.teamPwsSeasonBreakBegin) / 604800)
  else
    self.breakWeekInterval = 0
  end
  local seasonduration = (self.seasonCount + self.breakWeekInterval) * 604800
  local intervalDay = self.seaonWeekDay - beginweekday
  local intervalSec = intervalDay * 86400 + self.seasonHour * 3600 + self.seasonMin * 60 - (h * 3600 + M * 60)
  self.teamPwsEndTime = self.teamPwsSeasonBegin + intervalSec + seasonduration + self.pwsActivityDuration
  self:ResetTeamPwsSeasonForbiddenPro(data.forbid_profession)
end

function PvpProxy:ResetTeamPwsSeasonForbiddenPro(array)
  if not self.teamPwsSeasonForbiddenProMap then
    self.teamPwsSeasonForbiddenProMap = {}
  end
  if not self.teamPwsSeasonForbiddenPro then
    self.teamPwsSeasonForbiddenPro = {}
  end
  TableUtility.TableClear(self.teamPwsSeasonForbiddenProMap)
  TableUtility.ArrayClear(self.teamPwsSeasonForbiddenPro)
  if not array then
    return
  end
  for i = 1, #array do
    self.teamPwsSeasonForbiddenProMap[array[i]] = 1
    self.teamPwsSeasonForbiddenPro[#self.teamPwsSeasonForbiddenPro + 1] = array[i]
  end
end

function PvpProxy:CheckProInvalid(pro)
  return nil ~= self.teamPwsSeasonForbiddenProMap[pro]
end

function PvpProxy:CheckHasInvalidPro()
  local _TeamProxy = TeamProxy.Instance
  if _TeamProxy:IHaveTeam() then
    local list = _TeamProxy.myTeam:GetMembersList()
    for i = 1, #list do
      if self:CheckProInvalid(list[i].profession) then
        return true
      end
    end
  end
  return false
end

function PvpProxy:GetForbiddenProStr()
  if not self.forbiddenProStr then
    self.forbiddenProStr = ""
    local _table = Table_Class
    for i = 1, #self.teamPwsSeasonForbiddenPro do
      if _table[self.teamPwsSeasonForbiddenPro[i]] then
        self.forbiddenProStr = self.forbiddenProStr .. _table[self.teamPwsSeasonForbiddenPro[i]].NameZh
        if i < #self.teamPwsSeasonForbiddenPro then
          self.forbiddenProStr = self.forbiddenProStr .. "、"
        end
      end
    end
  end
  return self.forbiddenProStr
end

function PvpProxy:IsTeamPwsOpen(stamp)
  if not self.teamPwsSeasonBegin or self.teamPwsSeasonBegin == 0 then
    return false
  end
  if self.teamPwsSeasonBreakBegin and self.teamPwsSeasonBreakBegin ~= 0 and self.teamPwsSeasonBreakEnd and self.teamPwsSeasonBreakEnd ~= 0 and stamp > self.teamPwsSeasonBreakBegin and stamp < self.teamPwsSeasonBreakEnd then
    return false
  end
  return stamp < self.teamPwsEndTime and stamp > self.teamPwsSeasonBegin
end

function PvpProxy:ClearTeamPwsRankData()
  if self.teamPwsRankData then
    for i = 1, #self.teamPwsRankData do
      ReusableTable.DestroyAndClearTable(self.teamPwsRankData[i])
    end
    ReusableTable.DestroyAndClearArray(self.teamPwsRankData)
    self.teamPwsRankData = nil
  end
  if self.teamPwsRankSearchResult then
    ReusableTable.DestroyAndClearArray(self.teamPwsRankSearchResult)
    self.teamPwsRankSearchResult = nil
  end
  self.teamPwsDataIsUsing = nil
  self.teamPwsDataProtect = nil
end

function PvpProxy:UpdateTeamPwsInfos(syncdata, sparetime, freefire)
  local mt = self.server_teamPwsInfo
  if mt == nil then
    mt = {}
    self.server_teamPwsInfo = mt
  end
  if syncdata then
    local sd, d
    local ballDirty = false
    for i = 1, #syncdata do
      sd = syncdata[i]
      d = mt[sd.color]
      if d == nil then
        d = {}
        mt[sd.color] = d
      end
      d.teamid = sd.teamid
      d.teamname = sd.teamname
      d.warbandname = sd.warband_name
      d.color = sd.color
      d.score = sd.score
      local oldballs = d.balls
      if not ballDirty and oldballs == nil then
        ballDirty = true
      end
      d.balls = {}
      for i = 1, #sd.balls do
        local id = sd.balls[i]
        d.balls[id] = 1
        if not ballDirty and not oldballs[id] then
          ballDirty = true
        end
      end
      ballDirty = ballDirty or next(oldballs) ~= nil
    end
    for i = 1, #syncdata do
      sd = syncdata[i]
      for k, v in pairs(mt) do
        if k ~= sd.color then
          v.effectcd = sd.effectcd
          v.effectid = sd.magicid
        end
      end
    end
    if ballDirty then
      GameFacade.Instance:sendNotification(PVPEvent.TeamPws_PlayerBuffBallChange)
    end
  end
  if sparetime then
    self.sparetime = sparetime
  end
  EventManager.Me():PassEvent(ServiceEvent.FuBenCmdTeamPwsInfoSyncFubenCmd, syncdata)
end

function PvpProxy:GetTeamPwsInfo(color)
  return self.server_teamPwsInfo[color]
end

function PvpProxy:GetSpareTime()
  return self.sparetime or 0
end

function PvpProxy:ClearTeamPwsInfos()
  helplog("ClearTeamPwsInfos")
  self.sparetime = nil
  self.server_teamPwsInfo = nil
end

function PvpProxy:CheckMvpMatchValid()
  local tipActID = GameConfig.MvpBattle.ActivityID or 4000000
  local running = FunctionActivity.Me():IsActivityRunning(tipActID)
  if not running then
    MsgManager.ShowMsgByIDTable(7300)
    return
  end
  if self.inviteMap then
    MsgManager.ShowMsgByID(26245)
    return
  end
  local baselv = GameConfig.MvpBattle.BaseLevel
  local rolelv = MyselfProxy.Instance:RoleLevel()
  if baselv > rolelv then
    MsgManager.ShowMsgByID(7301, baselv)
    return
  end
  if not TeamProxy.Instance:IHaveTeam() then
    MsgManager.ShowMsgByID(332)
    return
  end
  if not TeamProxy.Instance:CheckIHaveLeaderAuthority() then
    MsgManager.ShowMsgByID(7303)
    return
  end
  local mblsts = TeamProxy.Instance.myTeam:GetMembersListExceptMe()
  for i = 1, #mblsts do
    if baselv > mblsts[i].baselv then
      MsgManager.ShowMsgByID(7305, baselv)
      return
    end
  end
  local matchStatus = self:GetMatchState(PvpProxy.Type.MvpFight)
  if matchStatus and matchStatus.ismatch then
    MsgManager.ShowMsgByIDTable(3609)
    return
  end
  return true
end

function PvpProxy:CheckTripleMatchValid()
  if TriplePlayerPvpProxy.Instance:IsRelax() then
    return true
  end
  if not TeamProxy.Instance:IHaveTeam() then
    return true
  end
  local md = TeamProxy.Instance.myTeam:GetMembersList()
  local professionRefCount = {}
  for i = 1, #md do
    local pro = md[i].profession
    if pro then
      if nil ~= professionRefCount[pro] then
        MsgManager.ShowMsgByID(28113)
        return false
      else
        professionRefCount[pro] = 1
      end
    end
  end
  return true
end

local PWS_TYPE, PWS_CONFIG

function PvpProxy:CheckPwsMatchValid(isRelax, roomid)
  if self:GetCurMatchStatus() then
    MsgManager.ShowMsgByID(25917)
    return
  end
  if self.inviteMap then
    MsgManager.ShowMsgByID(26245)
    return
  end
  PWS_TYPE = isRelax and PvpProxy.Type.FreeBattle or PvpProxy.Type.TeamPws
  PWS_CONFIG = isRelax and GameConfig.PvpTeamRaid_Relax[roomid] or GameConfig.PvpTeamRaid[roomid]
  if not isRelax then
    if not FunctionActivity.Me():IsActivityRunning(PWS_CONFIG.ActivityID) then
      MsgManager.ShowMsgByID(365)
      return
    end
    local teamPwsCount = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_TEAMPWS_COUNT) or 0
    if teamPwsCount >= GameConfig.teamPVP.Maxtime then
      MsgManager.ShowMsgByID(25906)
      return
    end
  end
  if Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL) < PWS_CONFIG.RequireLv then
    MsgManager.ShowMsgByID(25900)
    return
  end
  return true
end

function PvpProxy:CheckMatchValid(type, roomid)
  if type ~= PvpProxy.Type.GroupRaid and Game.MapManager:IsPveMode_Thanatos() then
    MsgManager.ShowMsgByID(970)
    return
  end
  if self:GetCurMatchStatus() then
    MsgManager.ShowMsgByID(25917)
    return
  end
  if self.inviteMap then
    MsgManager.ShowMsgByID(26245)
    return
  end
  if type == PvpProxy.Type.MvpFight then
    return self:CheckMvpMatchValid()
  elseif type == PvpProxy.Type.TeamPws then
    return self:CheckPwsMatchValid(false, roomid)
  elseif type == PvpProxy.Type.FreeBattle then
    return self:CheckPwsMatchValid(true, roomid)
  elseif type == PvpProxy.Type.Triple then
    return self:CheckTripleMatchValid()
  end
  return true
end

function PvpProxy:ResetMidMatchCD(var)
  if var ~= self.midMatchCD then
    self.midMatchCD = var
  end
end

function PvpProxy:GetMidMatchCD()
  return self.midMatchCD
end

local typeStr, matchid, goalid

function PvpProxy:GetTypeName()
  local _, type, raidid = self:GetCurMatchStatus()
  if type == PvpProxy.Type.PoringFight then
    typeStr = ZhString.PvpTypeName_Polly
  elseif type == PvpProxy.Type.MvpFight then
    typeStr = ZhString.PvpTypeName_Mvp
  elseif type == PvpProxy.Type.TeamPws then
    typeStr = ZhString.PvpTypeName_TeamPws
  elseif type == PvpProxy.Type.FreeBattle then
    typeStr = ZhString.PvpTypeName_TeamPwsRelax
  elseif type == PvpProxy.Type.ExpRaid then
    typeStr = ZhString.PvpTypeName_TeamExp
  elseif type == PvpProxy.Type.Laboratory then
    typeStr = ZhString.PvpTypeName_Laboratory
  elseif type == PvpProxy.Type.Headwear then
    typeStr = ZhString.PvpTypeName_Headwear
  elseif type == PvpProxy.Type.TransferFight then
    typeStr = ZhString.PvpTypeName_TransferFight
  elseif type == PvpProxy.Type.TwelvePVPChampion then
    typeStr = ZhString.PvpTypeName_TwelvePVPChamption
  elseif TwelvePvPProxy.Instance:Is12pvp(type) then
    typeStr = ZhString.PvpTypeName_TwelvePVPLeisure
  elseif type == PvpProxy.Type.TeamPwsChampion then
    typeStr = raidid and self.raidMaps[raidid] or ZhString.PvpTypeName_TeamPwsPVPChampion
  elseif type == PvpProxy.Type.Triple then
    typeStr = ZhString.PvpTypeName_3v3v3
  else
    matchid = self:GetMatchID()
    goalid = Table_MatchRaid[matchid].TeamGoalID or 0
    if matchid ~= 0 and goalid ~= 0 then
      typeStr = Table_TeamGoals[goalid].NameZh
      return typeStr
    else
      typeStr = ZhString.PvpTypeName_Default
      return string.format(ZhString.PvpTypeName_Format, typeStr)
    end
  end
  return string.format(ZhString.PvpTypeName_Format, typeStr)
end

OthelloOccupyData = class("OthelloOccupyData")
OthelloOccupyData.OccupyType = {
  NULL = 0,
  RED = 1,
  BLUE = 2
}

function OthelloOccupyData:ctor(index)
  self.id = index
  self.occupycolor = 0
  self.redprogress = 0
  self.blueprogress = 0
end

function OthelloOccupyData:updata(data)
  self.id = data.pointid
  self.occupycolor = data.occupycolor
  self.redprogress = data.redprogress or 0
  self.blueprogress = data.blueprogress or 0
end

OthelloScoreData = class("OthelloScoreData")

function OthelloScoreData:ctor()
  self.teamid = 0
  self.color = 0
  self.score = 0
  self.teamname = ""
end

function OthelloScoreData:updata(data)
  self.teamid = data.teamid
  self.color = data.color
  self.score = data.score
  self.teamname = data.teamname
  self.warbandname = data.warband_name
end

function PvpProxy:UpdateOhelloInfos(syncdata, sparetime)
  local mt = self.server_othelloInfo
  if mt == nil then
    mt = {}
    self.server_othelloInfo = mt
  end
  if sparetime and sparetime ~= 0 then
    self.othelloEndtime = sparetime
  end
end

function PvpProxy:GetOhelloInfo(color)
  return self.server_othelloInfo[color]
end

function PvpProxy:GetOthelloEndtime()
  return self.othelloEndtime or 0
end

function PvpProxy:ClearOthelloInfos()
  helplog("ClearOhelloInfos")
  self.othelloEndtime = nil
  self.server_othelloInfo = nil
end

function PvpProxy:RecvOthelloInfoSyncFubenCmd(data)
  if not self.server_othelloInfo then
    self.server_othelloInfo = {}
  end
  if data then
    local teaminfo = data.teaminfo
    local single = {}
    for i = 1, #teaminfo do
      t = teaminfo[i]
      if not self.server_othelloInfo[t.color] then
        self.server_othelloInfo[t.color] = OthelloScoreData.new()
      end
      self.server_othelloInfo[t.color]:updata(t)
    end
    if data.endtime and data.endtime ~= 0 then
      self.othelloEndtime = data.endtime
    end
  end
  EventManager.Me():PassEvent(ServiceEvent.FuBenCmdOthelloInfoSyncFubenCmd, data)
end

function PvpProxy:RecvQueryOthelloUserInfoFubenCmd(data)
  self:CreateOthelloReportData(data.teaminfo)
end

function PvpProxy:RecvOthelloReportFubenCmd(data)
  self:CreateOthelloReportData(data.teaminfo, data.mvpuserinfo.charid)
  local data = {
    winTeamColor = data.winteam,
    mvpUserInfo = data.mvpuserinfo
  }
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.OthelloResultPopUp,
    viewdata = data
  })
end

function PvpProxy:CreateOthelloReportData(serverTeamInfos, mvpID)
  self:ClearTeamPwsReportData()
  self.othelloReportMap = ReusableTable.CreateTable()
  self.othelloReportMap.aveScores = ReusableTable.CreateTable()
  local reports = ReusableTable.CreateArray()
  local teamInfo, teamID, color, userInfos, data
  for i = 1, #serverTeamInfos do
    teamInfo = serverTeamInfos[i]
    teamID = teamInfo.teamid
    color = teamInfo.color
    userInfos = teamInfo.userinfos
    self.othelloReportMap.aveScores[color] = teamInfo.avescore
    for i = 1, #userInfos do
      data = TeamPwsData.ParseOthelloReportData(ReusableTable.CreateTable(), userInfos[i], teamID, color)
      if mvpID and mvpID == data.charID then
        data.isMvp = true
      end
      reports[#reports + 1] = data
    end
  end
  self.othelloReportMap.reports = reports
end

function PvpProxy:GetOthelloReportData()
  return self.othelloReportMap
end

function PvpProxy:ClearOthelloReportData()
  if self.othelloReportMap then
    for i = 1, #self.othelloReportMap.reports do
      ReusableTable.DestroyAndClearTable(self.othelloReportMap.reports[i])
    end
    ReusableTable.DestroyAndClearArray(self.othelloReportMap.reports)
    ReusableTable.DestroyAndClearTable(self.othelloReportMap.aveScores)
    ReusableTable.DestroyAndClearTable(self.othelloReportMap)
    self.othelloReportMap = nil
  end
end

function PvpProxy:LaunchAreaCheck()
  if self.running then
    return
  end
  self.running = true
end

function PvpProxy:ShutdownAreaCheck()
  if not self.running then
    return
  end
  self.running = false
end

local distanceFunc = VectorUtility.DistanceXZ_Square

function PvpProxy:UpdateAreaCheck(time, deltatime)
  if not self.running then
    return
  end
  local myselfPosition = Game.Myself:GetPosition()
  for id, trigger in pairs(self.triggers) do
    if distanceFunc(myselfPosition, trigger:GetPosition()) <= trigger.reachDis * trigger.reachDis then
      self:EnterArea(trigger)
    else
      self:ExitArea(trigger)
    end
  end
end

function PvpProxy:RecvOthelloPointOccupyPowerFubenCmd(data)
  local occupy = data.occupy
  if occupy and 0 < #occupy then
    if not self.initOthello then
      self:InitOthelloOccupyData()
    end
    for i = 1, #occupy do
      local oData = self.othelloCheckpointMap[occupy[i].pointid]
      if not oData then
        oData = OthelloOccupyData.new(occupy[i].pointid)
        self.othelloCheckpointMap[oData.id] = oData
      end
      oData:updata(occupy[i])
    end
  end
end

function PvpProxy:InitOthelloOccupyData()
  local othelloCfg = DungeonProxy.Instance:GetOthelloConfigRaid()
  if othelloCfg.points then
    local oData
    for i = 1, #othelloCfg.points do
      if not self.othelloCheckpointMap[i] then
        oData = OthelloOccupyData.new(i)
        self.othelloCheckpointMap[i] = oData
      end
    end
  end
  self.initOthello = true
end

function PvpProxy:GetOthelloOccupyData(index)
  return self.othelloCheckpointMap[index]
end

function PvpProxy:GetOthelloOccupyStatus(index)
  if self.othelloCheckpointMap[index] then
    return self.othelloCheckpointMap[index].occupycolor
  end
end

function PvpProxy:ClearOthelloOccupyStatus()
  if self.othelloCheckpointMap then
    TableUtility.TableClear(self.othelloCheckpointMap)
  end
end

function PvpProxy:TransferFightResult(serverData)
  if serverData == nil then
    return
  end
  local myName = Game.Myself.data:GetName() or "---"
  local myScore = 0
  local myRank = 30
  self.transferFight_viewdata = {}
  self.transferFight_viewdata.rank = {}
  local rankList = serverData.rank
  if rankList then
    for i = 1, #rankList do
      local info = {}
      info.name = rankList[i].name
      info.score = rankList[i].score
      info.rank = rankList[i].rank
      table.insert(self.transferFight_viewdata.rank, info)
    end
  end
  local myrank = serverData.myrank
  self.transferFight_viewdata.myScore = myrank.score
  self.transferFight_viewdata.myRank = myrank.rank
  FunctionSystem.InterruptMyself()
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.TransferFightRankPopUp
  })
end

function PvpProxy:GetTransferFightResult()
  return self.transferFight_viewdata
end

function PvpProxy:ClearTransferFightResult()
  self.fightStatInfo = {}
end

function PvpProxy:TransferFightMonsterChooseView()
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.TransferFightMonsterChooseView
  })
end

function PvpProxy:SetTransferFightMonsterChooseCountDown(data)
  local countDownTime = data.coldtime
  if countDownTime and countDownTime >= ServerTime.CurServerTime() then
    self.transferFightMonsterChooseCountDown = countDownTime
  end
end

function PvpProxy:GetTransferFightMonsterChooseCountDown()
  if self.transferFightMonsterChooseCountDown and self.transferFightMonsterChooseCountDown >= ServerTime.CurServerTime() then
    return self.transferFightMonsterChooseCountDown
  else
    local chooseTime = GameConfig.TransferFight.chooseTime
    return ServerTime.CurServerTime() / 1000 + chooseTime
  end
end

function PvpProxy:RemoveTransferFightMonsterChooseCountDown()
  self.transferFightMonsterChooseCountDown = nil
end

function PvpProxy:RecvNtfTransferFightRankFubenCmd(data)
  self.fightStatInfo.score = data.myscore
  self.fightStatInfo.coldtime = data.coldtime
  local rankDatas = ReusableTable.CreateTable()
  if data.rank and #data.rank > 0 then
    for i = 1, #data.rank do
      local single = data.rank[i]
      local rankData = ReusableTable.CreateTable()
      rankData.name = single.name
      rankData.score = single.score
      rankData.rank = single.rank
      rankDatas[#rankDatas + 1] = rankData
    end
  end
  self.fightStatInfo.ranks = rankDatas
end

function PvpProxy:Is12PvpInMatch()
  local matchStatus, etype = PvpProxy.Instance:GetCurMatchStatus()
  local is12pvp = etype == PvpProxy.Type.TwelvePVPBattle or etype == PvpProxy.Type.TwelvePVPRelax or etype == PvpProxy.Type.TwelvePVPGM
  if matchStatus and is12pvp and matchStatus.isprepare then
    return true
  end
  return false
end

function PvpProxy:TryInitPolly3v3v3StaticData()
  if not self.polly3v3v3ColorMap then
    self.polly3v3v3ColorMap = {
      [1] = LuaColor.New(1, 0, 0, 1),
      [2] = LuaColor.New(0, 1, 0, 1),
      [3] = LuaColor.New(0, 0, 1, 1)
    }
  end
  local cfg = GameConfig.teamMixPVPPolly
  if not cfg then
    return
  end
  if not self.polly3v3v3RoleMonsterIdMap then
    self.polly3v3v3RoleMonsterIdMap, self.polly3v3v3TransformBuffIdMap = {}, {}
    local buffEff
    for tId, buffs in pairs(cfg.transferSet) do
      for _, buff in pairs(buffs) do
        buffEff = Table_Buffer[buff] and Table_Buffer[buff].BuffEffect
        if buffEff and buffEff.type == "Transform" then
          self.polly3v3v3RoleMonsterIdMap[tId] = buffEff.TransformID
          self.polly3v3v3TransformBuffIdMap[buff] = true
          break
        end
      end
    end
  end
  if not self.polly3v3v3ColorBaseCoordinateMap then
    self.polly3v3v3ColorBaseCoordinateMap, self.polly3v3v3ColorBaseRangeMap = {}, {}
    for _, data in pairs(cfg.bornPoint) do
      self.polly3v3v3ColorBaseCoordinateMap[data.color] = data.centre
      self.polly3v3v3ColorBaseRangeMap[data.color] = data.range
    end
  end
end

function PvpProxy:RecvPolly3v3v3RoleSelect(pools, endTime)
  if pools and 0 < #pools then
    self.polly3v3v3RoleCandidates = self.polly3v3v3RoleCandidates or {}
    TableUtility.TableClear(self.polly3v3v3RoleCandidates)
    for i = 1, #pools do
      self.polly3v3v3RoleCandidates[i] = pools[i]
    end
    self:TryInitPolly3v3v3StaticData()
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.Polly3v3v3RoleSelectView,
      viewdata = endTime
    })
  end
end

function PvpProxy:RecvPolly3v3v3RankSync(teamRanks, showReward)
  self.polly3v3v3TeamRanks = self.polly3v3v3TeamRanks or {}
  local rank, remoteRewards, rewards, rewardItemIds, index
  for i = 1, #teamRanks do
    rank = self.polly3v3v3TeamRanks[i] or {}
    rank.color = teamRanks[i].color
    rank.rank = teamRanks[i].rank
    rank.appleNum = teamRanks[i].applenum
    rank.baseLv = teamRanks[i].baselv
    rewards, remoteRewards, index = rank.rewards or {}, teamRanks[i].rewards, 1
    for j = 1, #remoteRewards do
      rewardItemIds = ItemUtil.GetRewardItemIdsByTeamId(remoteRewards[j])
      if rewardItemIds then
        for _, data in pairs(rewardItemIds) do
          if rewards[index] then
            rewards[index]:ResetData("Reward", data.id)
          else
            rewards[index] = ItemData.new("Reward", data.id)
          end
          rewards[index].num = data.num
          index = index + 1
        end
      end
    end
    for j = index + 1, #rewards do
      rewards[j] = nil
    end
    rank.rewards = rewards
    self.polly3v3v3TeamRanks[i] = rank
  end
  if showReward then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PoringFightResultView
    })
  end
end

local getMaxFromTable = function(t)
  if not t or not next(t) then
    return
  end
  local max, key = -math.huge
  for k, v in pairs(t) do
    if v > max then
      key = k
      max = v
    end
  end
  return key, max
end

function PvpProxy:ShowPolly3v3v3Result()
  local pollyD = Game.DungeonManager.currentDungeon
  local creatureIdTopUiMap, creature, creatureData, colorId = pollyD and pollyD.creatureIdTopUiMap
  if not creatureIdTopUiMap or not next(creatureIdTopUiMap) then
    LogUtility.Warning("Cannot find creatureIdTopUiMap of current dungeon!!!")
    return
  end
  self.polly3v3v3ResultNpcList = self.polly3v3v3ResultNpcList or {}
  TableUtility.TableClear(self.polly3v3v3ResultNpcList)
  local getNpcListElement = function(data)
    if not data then
      return
    end
    local mId = self:GetMonsterIdFromPolly3v3v3PlayerData(data)
    return mId and {
      npcid = mId,
      name = data:GetName()
    }
  end
  local championCreatureIdAppleNumMap = ReusableTable.CreateTable()
  for creatureId, _ in pairs(pollyD.creatureIdTopUiMap) do
    creature = SceneCreatureProxy.FindCreature(creatureId)
    creatureData = creature and creature.data
    if creatureData then
      colorId = creatureData.userdata:Get(UDEnum.TEAMMIX_COLOR)
      for _, rankData in pairs(self.polly3v3v3TeamRanks) do
        if rankData.color == colorId then
          if rankData.rank > 1 then
            TableUtility.ArrayPushBack(self.polly3v3v3ResultNpcList, getNpcListElement(creatureData))
            break
          end
          championCreatureIdAppleNumMap[creatureId] = creatureData.userdata:Get(UDEnum.TEAMMIX_APPLES)
          break
        end
      end
    end
  end
  local index, id, max = 1
  while next(championCreatureIdAppleNumMap) do
    id, max = getMaxFromTable(championCreatureIdAppleNumMap)
    if id then
      table.insert(self.polly3v3v3ResultNpcList, index, getNpcListElement(SceneCreatureProxy.FindCreature(id)))
      index = index + 1
      championCreatureIdAppleNumMap[id] = nil
    else
      break
    end
  end
  Game.PlotStoryManager:Start(2, nil, nil, PlotConfig_Prefix.Anim, self.polly3v3v3ResultNpcList)
  ReusableTable.DestroyAndClearTable(championCreatureIdAppleNumMap)
end

function PvpProxy:GetMonsterIdFromPolly3v3v3PlayerData(data)
  if not data or not data.GetBuffListByType then
    return
  end
  local list = data:GetBuffListByType("Transform")
  if list then
    for _, buff in pairs(list) do
      if self.polly3v3v3TransformBuffIdMap[buff] then
        return Table_Buffer[buff].BuffEffect.TransformID
      end
    end
  end
end

function PvpProxy:GetPolly3v3v3ColorFromColorId(colorId)
  return self.polly3v3v3ColorMap and self.polly3v3v3ColorMap[colorId] or ColorUtil.NGUIWhite
end

function PvpProxy:GetPolly3v3v3ColorOfMyTeam()
  return self:GetPolly3v3v3ColorFromColorId(self:GetPolly3v3v3ColorIdOfMyTeam())
end

function PvpProxy:GetPolly3v3v3ColorIdOfMyTeam()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.TEAMMIX_COLOR)
end

function PvpProxy:GetPolly3v3v3DataOfMyTeam()
  if not self.polly3v3v3TeamRanks then
    return
  end
  local myColorId = self:GetPolly3v3v3ColorIdOfMyTeam()
  if myColorId then
    for _, d in pairs(self.polly3v3v3TeamRanks) do
      if d.color == myColorId then
        return d
      end
    end
  end
end

function PvpProxy:UpdateFreeFire(b)
  if nil == b then
    return
  end
  if b == self.freefire then
    return
  end
  self.freefire = b
  EventManager.Me():PassEvent(PVPEvent.OnFreeFireStateChanged, b)
end

function PvpProxy:IsFreeFire()
  return self.freefire == true
end

function PvpProxy:GetMatchID()
  local _, type, configid = self:GetCurMatchStatus()
  return Game.MatchGoals[type][configid] or 0
end

function PvpProxy:IsFoodForbidden()
  return not not self.isFoodForbidden
end

function PvpProxy:IsRelicsForbidden()
  return not not self.isRelicsForbidden
end

function PvpProxy:IsArtifactForbidden()
  return not not self.isArtifactForbidden
end

function PvpProxy:RecvDesertWolfRuleSync(data)
  self.isFoodForbidden = data.ban_pvp_potion
  self.isRelicsForbidden = data.ban_personal_art
  self.isArtifactForbidden = data.ban_artifact
  GameFacade.Instance:sendNotification(DesertWolfEvent.OnRuleUpdated, true)
end

function PvpProxy:ResetDesertWolfRule()
  self.isFoodForbidden = nil
  self.isRelicsForbidden = nil
  self.isArtifactForbidden = nil
  GameFacade.Instance:sendNotification(DesertWolfEvent.OnRuleUpdated, false)
end

function PvpProxy.isNormalMaterials(t)
  return t == PvpProxy.Type.NormalMaterials
end

function PvpProxy:UpdatePvpMatchHeadCountInfo(data)
  local etype = data.etype
  local info = self.pvpMatchHeadCountInfo[etype]
  if not info then
    info = {}
    self.pvpMatchHeadCountInfo[etype] = info
  end
  info.curCount = data.nowcount
  info.needCount = data.needcount
end

function PvpProxy:GetPvpMatchCurHeadCount(type)
  return self.pvpMatchHeadCountInfo[type] and self.pvpMatchHeadCountInfo[type].curCount or 0
end

function PvpProxy:GetPvpMatchNeedHeadCount(type)
  return self.pvpMatchHeadCountInfo[type] and self.pvpMatchHeadCountInfo[type].needCount or 0
end

function PvpProxy:InitTripleCampInfo(data)
  if not self.tripleCampInfo then
    self.tripleCampInfo = {}
  end
  if not self.tripleCampUserInfo then
    self.tripleCampUserInfo = {}
  end
  self.firstScore = 0
  self.firstCamp = nil
  if data.camps and 0 < #data.camps then
    TableUtility.TableClear(self.tripleCampInfo)
    TableUtility.TableClear(self.tripleCampUserInfo)
    for i = 1, #data.camps do
      local info = {}
      local serverdata = data.camps[i]
      info.camp = serverdata.ecamp
      info.score = serverdata.score or 0
      if self.firstScore < info.score then
        self.firstScore = info.score
        self.firstCamp = info.camp
      end
      info.users = {}
      for j = 1, #serverdata.users do
        local serveruser = serverdata.users[j]
        local charid = serveruser.charid
        self:UpdateTripleCampUserInfo(serveruser, info.camp)
        info.users[#info.users + 1] = charid
        if charid == Game.Myself.data.id then
          self.myselfCamp = info.camp
        end
      end
      self.tripleCampInfo[info.camp] = info
    end
  end
  self.tripleEndTime = data.endtime or 0
end

function PvpProxy:UpdateTripleCampInfo(camps)
  self.firstScore = self.firstScore or 0
  for i = 1, #camps do
    local camp = camps[i].ecamp
    local data = self.tripleCampInfo[camp]
    if camps[i].score and camps[i].score ~= 0 then
      data.score = camps[i].score
      if self.firstScore < data.score then
        self.firstScore = data.score
        self.firstCamp = camp
      end
    end
    if camps[i].users then
      for j = 1, #camps[i].users do
        self:UpdateTripleCampUserInfo(camps[i].users[j], camp)
      end
    end
  end
end

function PvpProxy:UpdateTripleCampUserInfo(serveruser, camp)
  local charid = serveruser.charid
  local user = self.tripleCampUserInfo[charid]
  if not user then
    user = {}
    self.tripleCampUserInfo[charid] = user
    user.charid = serveruser.charid
    user.camp = camp
  end
  user.username = serveruser.username
  user.profession = serveruser.profession
  user.kill = serveruser.killnum or 0
  user.death = serveruser.dienum or 0
  user.help = serveruser.helpnum or 0
  user.damage = serveruser.damage or 0
  user.bedamaged = serveruser.bedamage or 0
  user.heal = serveruser.heal or 0
  user.score = serveruser.addscore or 0
  user.seasonScore = serveruser.score or 0
  user.hideName = serveruser.hidename
end

local campSortFunc = function(l, r)
  return l.camp > r.camp
end

function PvpProxy:GetTripleCampInfos(sortFunc)
  local datas = {}
  sortFunc = sortFunc or campSortFunc
  if self.tripleCampInfo then
    for _, data in pairs(self.tripleCampInfo) do
      TableUtility.InsertSort(datas, data, sortFunc)
    end
  end
  return datas
end

function PvpProxy:GetTripleEndTime()
  return self.tripleEndTime
end

function PvpProxy:GetTripleUserInfo(charid)
  return self.tripleCampUserInfo and self.tripleCampUserInfo[charid]
end

function PvpProxy:IsScoreFirstCamp(camp)
  return self.firstCamp == camp
end

function PvpProxy:UpdateTriplePwsRankData(data)
  self.triplePwsRankInfoOutOfDate = false
  if data then
    local rankInfo = data.rankinfo
    if rankInfo then
      for i = 1, #rankInfo do
        local serverdata = rankInfo[i]
        local info = ReusableTable.CreateTable()
        info.name = serverdata.name
        local portrait = serverdata.portrait
        if portrait then
          info.portrait = portrait.portrait
          info.body = portrait.body
          info.hair = portrait.hair
          info.haircolor = portrait.haircolor
          info.gender = portrait.gender
          info.head = portrait.head
          info.face = portrait.face
          info.mouth = portrait.mouth
          info.eye = portrait.eye
          info.portrait_frame = portrait.portrait_frame
        end
        info.rank = serverdata.myrank
        info.score = serverdata.score
        info.erank = serverdata.erank
        info.profession = serverdata.profession
        info.charid = serverdata.charid
        info.level = serverdata.level
        info.guildname = serverdata.guildname
        self.triplePwsRankInfo[#self.triplePwsRankInfo + 1] = info
      end
    end
    self.triplePwsScoreLimit = data.limitscore
    self.triplePwsBestRank = data.bestrank
    local lastrankinfo = data.lastrankinfo
    if lastrankinfo then
      for i = 1, #lastrankinfo do
        local serverdata = lastrankinfo[i]
        local info = ReusableTable.CreateTable()
        info.name = serverdata.name
        local portrait = serverdata.portrait
        if portrait then
          info.portrait = portrait.portrait
          info.body = portrait.body
          info.hair = portrait.hair
          info.haircolor = portrait.haircolor
          info.gender = portrait.gender
          info.head = portrait.head
          info.face = portrait.face
          info.mouth = portrait.mouth
          info.eye = portrait.eye
          info.portrait_frame = portrait.portrait_frame
        end
        info.rank = serverdata.myrank
        info.score = serverdata.score
        info.erank = serverdata.erank
        info.profession = serverdata.profession
        info.charid = serverdata.charid
        info.level = serverdata.level
        info.guildname = serverdata.guildname
        self.lastTriplePwsRankInfo[#self.lastTriplePwsRankInfo + 1] = info
      end
    end
  end
  TimeTickManager.Me():CreateOnceDelayTick(30000, function()
    self.triplePwsRankInfoOutOfDate = true
  end, self)
end

function PvpProxy:QueryTriplePwsRankData()
  if not self.triplePwsRankInfo then
    self.triplePwsRankInfo = {}
  end
  TableUtility.ArrayClear(self.triplePwsRankInfo)
  if not self.lastTriplePwsRankInfo then
    self.lastTriplePwsRankInfo = {}
  end
  TableUtility.ArrayClear(self.lastTriplePwsRankInfo)
  ServiceMatchCCmdProxy.Instance:CallQueryTriplePwsRankMatchCCmd()
end

function PvpProxy:GetTriplePwsRankData(last)
  if not self.triplePwsRankInfoOutOfDate then
    return last and self.lastTriplePwsRankInfo or self.triplePwsRankInfo
  end
end

function PvpProxy:GetTriplePwsRankSearchResult(keyword, last)
  local result = self.triplePwsRankSearchResult
  if not result then
    result = ReusableTable.CreateArray()
    self.triplePwsRankSearchResult = result
  end
  TableUtility.ArrayClear(result)
  keyword = string.lower(keyword)
  local searchRange = last and self.lastTriplePwsRankInfo or self.triplePwsRankInfo
  for i = 1, #searchRange do
    local info = searchRange[i]
    if info.name and string.find(string.lower(info.name), keyword) then
      result[#result + 1] = info
    end
  end
  return result
end

function PvpProxy:GetTriplePwsScoreLimit()
  return self.triplePwsScoreLimit
end

function PvpProxy:GetTriplePwsBestRank()
  return self.triplePwsBestRank
end

function PvpProxy:UpdateTriplePwsTeamInfo(data)
  if not self.triplePwsTeamUserInfo then
    self.triplePwsTeamUserInfo = {}
  end
  if data.userinfos then
    for i = 1, #data.userinfos do
      local serverdata = data.userinfos[i]
      local userInfo = self.triplePwsTeamUserInfo[serverdata.charid]
      if not userInfo then
        userInfo = ReusableTable.CreateTable()
        userInfo.charid = serverdata.charid
        self.triplePwsTeamUserInfo[userInfo.charid] = userInfo
      end
      userInfo.score = serverdata.score or 0
      userInfo.erank = math.max(serverdata.erank or 0, 1)
      userInfo.rank = serverdata.myrank or 0
      userInfo.starnum = serverdata.starnum or 0
      userInfo.winstatus = serverdata.winstatus or 0
    end
  end
  self.tripleTeamPwsForbidProfession = data.forbid_profession
  self.isTripleTeamPwsMatchOpen = data.open
  if not self.tripleTeamPwsOpenTimeInfo then
    self.tripleTeamPwsOpenTimeInfo = {}
  end
  self.tripleTeamPwsOpenTimeInfo.count = data.count
  self.tripleTeamPwsOpenTimeInfo.openTime = data.opentime
  self.tripleTeamPwsOpenTimeInfo.seasonBegin = data.season_begin
  self.tripleTeamPwsOpenTimeInfo.seasonBreakBegin = data.season_breakbegin
  self.tripleTeamPwsOpenTimeInfo.seasonBreakEnd = data.season_breakend
end

function PvpProxy:GetTriplePwsTeamUserInfo(charid)
  return self.triplePwsTeamUserInfo and self.triplePwsTeamUserInfo[charid]
end

function PvpProxy:UpdateTripleTeamPwsTargetProgress(datas)
  if not self.triplePwsTargetInfo then
    self.triplePwsTargetInfo = {}
  end
  if datas then
    for i = 1, #datas do
      local data = datas[i]
      local info = self.triplePwsTargetInfo[data.tasktype]
      if not info then
        info = {}
        self.triplePwsTargetInfo[data.tasktype] = info
      end
      info.progress = data.progress
      info.reward_progress = data.reward_progress
    end
  end
end

function PvpProxy:GetTripleTeamPwsTargetProgressByType(type)
  return self.triplePwsTargetInfo[type] and self.triplePwsTargetInfo[type].progress
end

function PvpProxy:GetTripleTeamPwsTargetRewardProgressByType(type)
  return self.triplePwsTargetInfo[type] and self.triplePwsTargetInfo[type].reward_progress
end

function PvpProxy:IsTripleTeamPwsMatchOpen()
  return self.isTripleTeamPwsMatchOpen
end

function PvpProxy:GetTripleTeamPwsOpenTimeInfo()
  return self.tripleTeamPwsOpenTimeInfo
end

function PvpProxy:IsTripleTeamPwsMatchInOpenTime()
  local dayTime = GameConfig.Triple and GameConfig.Triple.DayTime
  if dayTime and 0 < #dayTime and self.tripleTeamPwsOpenTimeInfo then
    local curTime = ServerTime.CurServerTime() / 1000
    local beginTime = self.tripleTeamPwsOpenTimeInfo.seasonBegin
    local breakBeginTime = self.tripleTeamPwsOpenTimeInfo.seasonBreakBegin
    local breakEndTime = self.tripleTeamPwsOpenTimeInfo.seasonBreakEnd
    local openedCount = self.tripleTeamPwsOpenTimeInfo.count
    local totalOpenCount = GameConfig.Triple and GameConfig.Triple.MatchCount or 4
    local wday, startTime, endTime = dayTime[1].wday, dayTime[1].begintime, dayTime[1].endtime
    if 0 < beginTime and curTime >= beginTime and openedCount < totalOpenCount and (breakBeginTime == 0 or curTime < breakBeginTime or 0 < breakEndTime and curTime > breakEndTime) then
      local hour, min, sec = ClientTimeUtil.GetHMSByTimeFormat(startTime)
      local startTimeStamp = ClientTimeUtil.GetTimeStampByWeekday(wday, hour, min, sec)
      hour, min, sec = ClientTimeUtil.GetHMSByTimeFormat(endTime)
      local endTimeStamp = ClientTimeUtil.GetTimeStampByWeekday(wday, hour, min, sec)
      return curTime >= startTimeStamp and curTime < endTimeStamp
    end
  end
  return false
end

function PvpProxy:GetTripleTeamPwsMatchSeasonEndTime(beginTime, matchWday, endTimeFormat, matchCount)
  local beginTimeDate = os.date("*t", beginTime)
  local beginWday = (beginTimeDate.wday - 1) % 7
  beginWday = 0 < beginWday and beginWday or 7
  local deltaDay = matchWday - beginWday
  deltaDay = 0 <= deltaDay and deltaDay or deltaDay + 7
  local hour, min, sec = ClientTimeUtil.GetHMSByTimeFormat(endTimeFormat)
  local endTime = os.time({
    year = beginTimeDate.year,
    month = beginTimeDate.month,
    day = beginTimeDate.day + deltaDay + (matchCount - 1) * 7,
    hour = hour,
    min = min,
    sec = sec
  })
  return endTime
end

function PvpProxy:IsTripleTeamPwsSeasonOpen()
  local dayTime = GameConfig.Triple and GameConfig.Triple.DayTime
  if dayTime and 0 < #dayTime and self.tripleTeamPwsOpenTimeInfo then
    local curTime = ServerTime.CurServerTime() / 1000
    local beginTime = self.tripleTeamPwsOpenTimeInfo.seasonBegin
    local wday, endTime = dayTime[1].wday, dayTime[1].endtime
    local openedCount = self.tripleTeamPwsOpenTimeInfo.count
    local totalOpenCount = GameConfig.Triple and GameConfig.Triple.MatchCount or 4
    return 0 < beginTime and curTime >= beginTime and openedCount < totalOpenCount
  end
  return false
end

function PvpProxy:GetTriplePwsMatchCurHeadCount()
  return self:GetPvpMatchCurHeadCount(PvpProxy.Type.Triple)
end

function PvpProxy:GetTriplePwsMatchNeedHeadCount()
  return self:GetPvpMatchNeedHeadCount(PvpProxy.Type.Triple)
end

function PvpProxy:UpdateTriplePwsRewardStatus(data)
  self.targetRewardStatus = data.goal_reward_status
  self.rankRewardStatus = data.rank_reward_status
end

function PvpProxy:IsTriplePwsTargetRewardCanReceive()
  return self.targetRewardStatus
end

function PvpProxy:IsTriplePwsRankRewardCanReceive()
  return self.rankRewardStatus
end

function PvpProxy:SetStatueInfo(sType, statueInfo)
  self.statueInfos = self.statueInfos or {}
  if statueInfo then
    self.statueInfos[sType] = PVPStatueInfo.new(sType, statueInfo)
  else
    self.statueInfos[sType] = nil
  end
end

function PvpProxy:GetStatueInfo(sType)
  return self.statueInfos and self.statueInfos[sType]
end

function PvpProxy:UpdateStatueInfo(sType, statueInfo)
  local myserverID = ChangeZoneProxy.Instance:GetMyselfServerId()
  if statueInfo.serverid == myserverID then
    self:SetStatueInfo(sType, statueInfo)
  end
end

function PvpProxy:RecvEffectInfoSyncUserCmd(data)
  if data.datas then
    self.rewardEffects = {}
    local typedata
    for i = 1, #data.datas do
      typedata = data.datas[i]
      local eType = typedata.type
      local single = {}
      for i = 1, #typedata.datas do
        local entry = RewardEffectData.new(typedata.datas[i])
        single[typedata.datas[i].id] = entry
      end
      self.rewardEffects[eType] = single
    end
  end
end

function PvpProxy:RecvEffectInfoUpdateUserCmd(data)
  if not self.rewardEffects then
    return
  end
  local etype = data.type
  local datas = data.datas
  if not self.rewardEffects[etype] then
    self.rewardEffects[etype] = {}
  end
  if not data.del then
    for i = 1, #datas do
      self.rewardEffects[etype][datas[i].id] = RewardEffectData.new(datas[i])
    end
  else
    for i = 1, #datas do
      self.rewardEffects[etype][datas[i].id] = nil
    end
  end
end

function PvpProxy:GetEffectList(eType)
  local result = {}
  result[1] = {id = 0, tabType = eType}
  local temp = self.rewardEffects and self.rewardEffects[eType] or {}
  for k, v in pairs(temp) do
    result[#result + 1] = v
  end
  return result
end

function PvpProxy:GetEffectInUse(eType)
  local temp = self.rewardEffects and self.rewardEffects[eType] or {}
  for k, v in pairs(temp) do
    if v.isused then
      return v
    end
  end
  return nil
end

function PvpProxy:CanOptStatue(sType)
  local statueInfo = self:GetStatueInfo(sType)
  if statueInfo == nil then
    return false
  end
  return statueInfo.charid == Game.Myself.data.id
end

function PvpProxy:GetStatueType(npcID)
  local PvpStatueConfig = GameConfig.PvpStatue
  if not PvpStatueConfig then
    return 0
  end
  if npcID == PvpStatueConfig.TriplePedestalNpcID or npcID == PvpStatueConfig.TripleNpcID then
    return 1
  elseif npcID == PvpStatueConfig.TeampwsPedestalNpcID or npcID == PvpStatueConfig.TeampwsNpcID then
    return 2
  elseif npcID == PvpStatueConfig.TwelvePedestalNpcID or npcID == PvpStatueConfig.TwelveNpcID then
    return 3
  end
  return 0
end

function PvpProxy:UpdateChampionPvpRewardStatusCmd(data)
  if data.rewards then
    if not self.pvpRewardStatusMap then
      self.pvpRewardStatusMap = {}
    end
    for i = 1, #data.rewards do
      local rewardtype = data.rewards[i].etype
      self.pvpRewardStatusMap[rewardtype] = data.rewards[i].status
    end
  end
end

function PvpProxy:CheckChampionPvpRewardStatusCmd(rewardtype)
  if not self.pvpRewardStatusMap then
    return false
  end
  return self.pvpRewardStatusMap[rewardtype]
end
