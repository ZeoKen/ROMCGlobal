autoImport("DisneyActivityData")
autoImport("DisneyQTEResultShowData")
DisneyStageProxy = class("DisneyStageProxy", pm.Proxy)
DisneyStageProxy.Instance = nil
DisneyStageProxy.NAME = "DisneyStageProxy"
local _ArrayPushBack = TableUtility.ArrayPushBack
local _ArrayClear = TableUtility.ArrayClear
local _TableClear = TableUtility.TableClear
local _ArrayFindIndex = TableUtility.ArrayFindIndex
local _CmdProxy
local p = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
local getSongUnlockTime = function(t)
  local y, m, d, H, M, S = t:match(p)
  return os.time({
    day = d,
    month = m,
    year = y,
    hour = H,
    min = M,
    sec = S
  })
end
local _sortGuideFunc = function(a, b)
  if nil == a or nil == b then
    return false
  end
  if a.status == b.status then
    return a.id < b.id
  else
    return a.status < b.status
  end
end
DisneyStageProxy.EMusicTeamStatus = {
  Closed = DisneyActivity_pb.EDISNEYMUSICSTATUS_CLOSE,
  Prepare = DisneyActivity_pb.EDISNEYMUSICSTATUS_PREPARE,
  Music = DisneyActivity_pb.EDISNEYMUSICSTATUS_MUSIC,
  Start = DisneyActivity_pb.EDISNEYMUSICSTATUS_START,
  Game = DisneyActivity_pb.EDISNEYMUSICSTATUS_GAME
}
DisneyStageProxy.EMickeyRewardStatus = {
  EUnfinished = 1,
  EReceived = 2,
  ECanReceive = 3
}
DisneyStageProxy.ETeamPrepareStatus = {
  ENone = 0,
  EPreparing = 1,
  EPrepared = 2,
  EError = 3
}

function DisneyStageProxy:ctor(proxyName, data)
  self.proxyName = proxyName or DisneyStageProxy.NAME
  if DisneyStageProxy.Instance == nil then
    DisneyStageProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:InitProxy()
end

function DisneyStageProxy:InitProxy()
  self.defaultSong = nil
  self.songs = {}
  self.curServerSong = nil
  self.curPlayingSong = nil
  self.selectRoleMap = {}
  self.heroHeads = {}
  self.rankList = {}
  self.rankMap = {}
  self.curOverviewActivityId = nil
  self.overviewStaticData = {}
  self.overviewStaticMap = {}
  self.overviewCfg = nil
  self.mickeyOnIds = {}
  self.mickeyRewardList = {}
  EventManager.Me():AddEventListener(LoadSceneEvent.FinishLoadScene, self.CheckEnterStageReady, self)
end

function DisneyStageProxy:LaunchDisneyMusicTeam(id)
  self.musicActId = id
  helplog("舞台剧音乐活动开启 ： ", id)
  self:InitStaticDisneyHeroHead()
  self.isrunning = true
end

function DisneyStageProxy:ShutDownDisneyMusicTeamActivity()
  self:ClientShutDownDisneyMusicTeam()
  self.isrunning = false
  helplog("舞台剧音乐活动关闭")
end

function DisneyStageProxy:ClientShutDownDisneyMusicTeam()
  self.curStatus = nil
  self.curServerSong = nil
  self.curPlayingSong = nil
  self.myHeroId = nil
  _TableClear(self.selectRoleMap)
  _ArrayClear(self.heroHeads)
  GameFacade.Instance:sendNotification(DisneyEvent.DisneyMusicStatusChanged)
end

function DisneyStageProxy:InitSongs()
  if not Table_DisneySong then
    return
  end
  _ArrayClear(self.songs)
  local curTime = ServerTime.CurServerTime() / 1000
  for k, v in pairs(Table_DisneySong) do
    if nil ~= v.UnlockTime and curTime > getSongUnlockTime(v.UnlockTime) then
      _ArrayPushBack(self.songs, v)
    end
  end
  table.sort(self.songs, function(a, b)
    return a.id < b.id
  end)
end

function DisneyStageProxy:GetSongs()
  return self.songs
end

function DisneyStageProxy.HasSelectSongAuthority()
  return TeamProxy.Instance:CheckIHaveLeaderAuthority()
end

function DisneyStageProxy:SetServerMusic(id)
  if DisneyStageProxy.HasSelectSongAuthority() and nil ~= id then
    _CmdProxy:CallDisneyMusicGameUpdateMusicCmd(id)
  end
end

function DisneyStageProxy:_UpdateMusicID(server_musicid)
  if server_musicid and self.curServerSong ~= server_musicid then
    self.curServerSong = server_musicid
    helplog("------------组队选曲 音乐切换： ", server_musicid)
    self.curPlayingSong = server_musicid
    GameFacade.Instance:sendNotification(DisneyEvent.DisneyMusicIdChanged)
  end
end

function DisneyStageProxy:_UpdateStatus(server_status)
  if server_status and self.curStatus ~= server_status then
    self.curStatus = server_status
    helplog("------------组队选曲 状态切换： ", server_status)
    GameFacade.Instance:sendNotification(DisneyEvent.DisneyMusicStatusChanged)
  end
end

function DisneyStageProxy:IsInMusic()
  return self.curStatus == DisneyStageProxy.EMusicTeamStatus.Music
end

function DisneyStageProxy:IsStageClosed()
  return not self.curStatus or self.curStatus == DisneyStageProxy.EMusicTeamStatus.Closed
end

function DisneyStageProxy:IsInPrepare()
  return self.curStatus == DisneyStageProxy.EMusicTeamStatus.Prepare
end

function DisneyStageProxy:IsGameStart()
  return self.curStatus and self.curStatus > DisneyStageProxy.EMusicTeamStatus.Start
end

function DisneyStageProxy:_UpdateMembers(server_members)
  if not server_members then
    return
  end
  _TableClear(self.selectRoleMap)
  local charid, heroId, prepare
  local me = Game.Myself.data.id
  for i = 1, #server_members do
    charid = server_members[i].charid
    heroId = server_members[i].heroid
    prepare = server_members[i].prepare
    local m = DisneyMusicMember.new(charid, heroId, prepare)
    self.selectRoleMap[charid] = m
    if charid == me then
      self.myHeroId = heroId
    end
  end
  if not TeamProxy.Instance:IHaveTeam() then
    redlog("没有组队，后端同步了迪斯尼角色列表")
    return
  end
  local myTeam = TeamProxy.Instance.myTeam
  local members = myTeam:GetPlayerMemberList(true, true)
  for i = 1, #members do
    members[i]:SetDisneyPrepareState()
  end
  _ArrayClear(self.heroHeads)
  local heros = self.heroStatic
  if not heros then
    return
  end
  for i = 1, #heros do
    local heroId = heros[i][1]
    local avatar = self.heroAvatar and self.heroAvatar[i] or ""
    local cellAvatar = DisneyTeamAvatar.new(heroId, avatar)
    _ArrayPushBack(self.heroHeads, cellAvatar)
  end
end

function DisneyStageProxy:GetMyDisneyHeroId()
  return self.myHeroId
end

function DisneyStageProxy:CheckSongSelected()
  return nil ~= self.curServerSong
end

function DisneyStageProxy:GetServerSong()
  return self.curServerSong
end

function DisneyStageProxy:IsNowPlayingSong(id)
  return id == self.curPlayingSong
end

function DisneyStageProxy:GetNowPlayingSong()
  return self.curPlayingSong
end

function DisneyStageProxy:SetCurplayingMusic(previewMusic)
  self.curPlayingSong = previewMusic or self.curServerSong
  local music = Table_DisneySong[self.curPlayingSong].ResourceName
  FunctionBGMCmd:Me():PlayUIBgm(music, 0)
end

function DisneyStageProxy:IsNowPlayingServerSong()
  return self.curPlayingSong == self.curServerSong
end

function DisneyStageProxy:DoPause()
  FunctionBGMCmd.Me():Pause()
end

function DisneyStageProxy:DoUnpause()
  FunctionBGMCmd.Me():UnPause()
end

function DisneyStageProxy:DoResume()
  if self.curPlayingSong ~= self.curServerSong then
    local music = Table_DisneySong[self.curServerSong].ResourceName
    FunctionBGMCmd:Me():PlayUIBgm(music, 0)
  else
    self:DoUnpause()
  end
end

function DisneyStageProxy:QueryDisneyMusicOpen()
  if not self.musicActId then
    return
  end
  ServiceDisneyActivityProxy.Instance:CallDisneyMusicOpenCmd(self.musicActId)
end

function DisneyStageProxy:GetHeroData()
  return self.heroHeads or _EmptyTable
end

function DisneyStageProxy:IsRoleSelected(heroid)
  for guid, musicMember in pairs(self.selectRoleMap) do
    if musicMember:IsHeroSelected(heroid) then
      return true
    end
  end
  return false
end

function DisneyStageProxy:IsPrepared(charid)
  for guid, musicMember in pairs(self.selectRoleMap) do
    if guid == charid and musicMember:IsPrepared() then
      return true
    end
  end
  return false
end

function DisneyStageProxy:HasSelected(charid)
  for guid, musicMember in pairs(self.selectRoleMap) do
    if guid == charid and musicMember:IsSelected() then
      return true
    end
  end
  return false
end

function DisneyStageProxy:GetHeroId(charid)
  local m = self.selectRoleMap[charid]
  return m and m.heroId or 0
end

function DisneyStageProxy:AllPrepared()
  for _, musicMember in pairs(self.selectRoleMap) do
    if not musicMember:IsPrepared() then
      return false
    end
  end
  return true
end

function DisneyStageProxy:GetSelectRoleMap()
  return self.selectRoleMap
end

function DisneyStageProxy:InitStaticDisneyHeroHead()
  local characters = GameConfig.DisneyMusicGame and GameConfig.DisneyMusicGame[self.musicActId].Characters
  if characters then
    self.heroStatic = characters
  end
  self.heroAvatar = GameConfig.DisneyMusicGame and GameConfig.DisneyMusicGame[self.musicActId].CharacterAvatar
end

function DisneyStageProxy:QueryMusicGameRank()
  helplog("self.musicActId: ", self.musicActId)
  if not self.musicActId then
    return
  end
  local queryMusicId = self.curPlayingSong or self.curServerSong
  helplog("CallDisneyMusicRankCmd queryMusicId: ", queryMusicId)
  if not queryMusicId then
    return
  end
  _CmdProxy:CallDisneyMusicRankCmd(self.musicActId, queryMusicId)
end

function DisneyStageProxy:HandleMusicGameRank(server_rank)
  if not server_rank then
    return
  end
  _ArrayClear(self.rankList)
  for i = 1, #server_rank do
    local rankdata = DisneyRankMemberData.new(server_rank[i], i)
    _ArrayPushBack(self.rankList, rankdata)
  end
end

function DisneyStageProxy:GetRankList()
  return self.rankList or _EmptyTable
end

function DisneyStageProxy:RecvDisneyMusicUpdateCmd(data)
  self:_UpdateMusicID(data.musicid)
  self:_UpdateStatus(data.status)
  self:_UpdateMembers(data.members)
end

function DisneyStageProxy:LaunchGlobalActivity(id)
  if not id then
    redlog("StartGlobalActCmd")
    return
  end
  helplog("launch global guide disney activity id : ", id)
  self.curOverviewActivityId = id
  self:InitDisneyGuideStaticData()
  self:CallQueryDisneyGuideInfoCmd(false)
end

function DisneyStageProxy:ShutDownGlobalActivity(id)
  helplog("Shutdown global guide disney activity id | self.curOverviewActivityId: ", id, self.curOverviewActivityId)
  _ArrayClear(self.overviewStaticData)
  _TableClear(self.overviewCfg)
  _TableClear(self.overviewStaticMap)
  _ArrayClear(self.mickeyRewardList)
  self.curOverviewActivityId = nil
  self.overviewCfg = nil
  self:ClearRedTip(true)
  GameFacade.Instance:sendNotification(DisneyEvent.DisneyGuideShutDown)
end

function DisneyStageProxy:HandleRecvGuideInfo(server_data)
  if self.curOverviewActivityId ~= server_data.global_activity_id then
    return
  end
  self.mickeyNum = server_data.mickey_got_num
  self.sliderMickeyRewards = server_data.received_rewards
  self:SetMickeySlider()
  self:SetServerMickeyLight(server_data.mickey_on_ids)
  self:InitReceiveGuideReward(server_data.mickey_reward_ids)
  self:SetServerGetitemsForType1(server_data.get_items)
end

function DisneyStageProxy:InitReceiveGuideReward(ids)
  if not ids then
    return
  end
  for i = 1, #ids do
    if nil ~= self.overviewStaticMap[ids[i]] then
      self.overviewStaticMap[ids[i]]:SetGetRewardFlag()
    end
  end
end

function DisneyStageProxy:UpdateGuideReward(data)
  if self.curOverviewActivityId ~= data.global_activity_id then
    return
  end
  local guideId = data.mickey_reward_id
  if self.overviewStaticMap and nil ~= self.overviewStaticMap[guideId] then
    self.overviewStaticMap[guideId]:SetGetRewardFlag()
  end
end

function DisneyStageProxy:HandleRecvSliderReward(data)
  if not self:IsGuideActRunning() then
    return
  end
  if self.curOverviewActivityId ~= data.global_activity_id then
    return
  end
  self.sliderMickeyRewards[#self.sliderMickeyRewards + 1] = data.mickey_num
  self:SetMickeySlider()
end

function DisneyStageProxy:DoReceiveMickeyReward(num)
  if not self:IsGuideActRunning() then
    return
  end
  _CmdProxy:CallReceiveMickeyRewardCmd(self.curOverviewActivityId, num)
end

function DisneyStageProxy:GetMickeyNum()
  return self.mickeyNum or 0
end

function DisneyStageProxy:GetAllMickeyNum()
  return self.totalMickeyNum or 0
end

function DisneyStageProxy:SetServerMickeyLight(on_ids)
  if not on_ids then
    return
  end
  for i = 1, #on_ids do
    if nil ~= self.overviewStaticMap[on_ids[i]] then
      self.overviewStaticMap[on_ids[i]]:SetActiveFlag()
    end
  end
end

function DisneyStageProxy:CallReceiveGuideReward(data)
  if not self:IsGuideActRunning() then
    return
  end
  if not data:CheckCanGetReward() then
    return
  end
  _CmdProxy:CallReceiveGuideRewardCmd(self.curOverviewActivityId, data.id)
end

function DisneyStageProxy:SetServerGetitemsForType1(items)
  if items and 0 < #items then
    self.getItems = self.getItems or {}
    for i = 1, #items do
      self.getItems[items[i].itemid] = items[i].count
    end
  else
  end
end

function DisneyStageProxy:CheckGoModelCanShow(data)
  if not data:IsRunning() then
    return false
  end
  local staticData = data.staticData
  if not staticData.GotoMode or #staticData.GotoMode < 1 then
    return false
  end
  if not staticData.Param or #staticData.Param < 2 then
    return true
  end
  if staticData.Type == 1 then
    local condition = staticData.Param
    if not self.getItems or nil == self.getItems[condition[1]] or self.getItems[condition[1]] < condition[2] then
      return true
    end
  end
  return true
end

function DisneyStageProxy:SetMickeySlider()
  if not self.overviewCfg then
    return
  end
  local mickeyCollection = self.overviewCfg.MickeyCollection
  if mickeyCollection then
    _ArrayClear(self.mickeyRewardList)
    for needNum, rewards in pairs(mickeyCollection) do
      local statusEnum
      if 0 == _ArrayFindIndex(self.sliderMickeyRewards, needNum) then
        statusEnum = needNum > self.mickeyNum and DisneyStageProxy.EMickeyRewardStatus.EUnfinished or DisneyStageProxy.EMickeyRewardStatus.ECanReceive
      else
        statusEnum = DisneyStageProxy.EMickeyRewardStatus.EReceived
      end
      local rc = {num = needNum, status = statusEnum}
      _ArrayPushBack(self.mickeyRewardList, rc)
    end
    table.sort(self.mickeyRewardList, function(a, b)
      return a.num < b.num
    end)
  end
end

function DisneyStageProxy:ClearRedTip(force)
  if force then
    ServiceSceneTipProxy.Instance:CallBrowseRedTipCmd(SceneTip_pb.EREDSYS_DISNEY_GUIDE)
    return
  end
  local sliderRewards = self.mickeyRewardList
  if sliderRewards then
    for i = 1, #sliderRewards do
      if sliderRewards[i].status == DisneyStageProxy.EMickeyRewardStatus.ECanReceive then
        return
      end
    end
  end
  local dataMap = self.overviewStaticMap
  if dataMap then
    for _, data in pairs(dataMap) do
      if data:CheckCanGetReward() then
        return
      end
    end
  end
  ServiceSceneTipProxy.Instance:CallBrowseRedTipCmd(SceneTip_pb.EREDSYS_DISNEY_GUIDE)
end

function DisneyStageProxy:CallQueryDisneyGuideInfoCmd(open)
  if not self:IsGuideActRunning() then
    return
  end
  _CmdProxy:CallQueryDisneyGuideInfoCmd(self.curOverviewActivityId, open)
end

function DisneyStageProxy:GetIntervalDays()
  return self.overviewCfg and self.overviewCfg.DifferenceDays
end

function DisneyStageProxy:GetMickyRewardTipDesc()
  return self.overviewCfg and self.overviewCfg.MickeyRewardDesc or "%s"
end

function DisneyStageProxy:GetDisneyTitle()
  return self.overviewCfg and self.overviewCfg.activityName or ""
end

function DisneyStageProxy:GetDisneyGuideRewardSp()
  return self.overviewCfg and self.overviewCfg.rewardSpriteName
end

local _tempMickeyIcon = {
  Active = "disneyactivity_icon_01",
  InActive = "disneyactivity_icon_04"
}

function DisneyStageProxy:GetDisneyGuideStatusSp()
  return self.overviewCfg and self.overviewCfg.statusSprite or _tempMickeyIcon
end

function DisneyStageProxy:InitDisneyGuideStaticData()
  if not self:IsGuideActRunning() then
    return
  end
  _CmdProxy = ServiceDisneyActivityProxy.Instance
  self.overviewCfg = GameConfig.DisneyActivityGuide and GameConfig.DisneyActivityGuide[self.curOverviewActivityId]
  if nil == self.overviewCfg then
    redlog("GameConfig.DisneyActivityGuide 迪斯尼总览ID 未取到,索引ID ： ", self.curOverviewActivityId)
    return
  end
  self.mickeyRewardsCfg = {}
  local rewardsCfg = self.overviewCfg.MickeyCollection
  for k, v in pairs(rewardsCfg) do
    local rewards = {}
    for i = 1, #v do
      local tempItem = ItemData.new("sliderReward", v[i].reward_item_id)
      tempItem:SetItemNum(v[i].reward_item_num)
      rewards[#rewards + 1] = tempItem
    end
    self.mickeyRewardsCfg[k] = rewards
  end
  _TableClear(self.overviewStaticMap)
  local cellData
  self.totalMickeyNum = 0
  for k, v in pairs(Table_DisneyActivityGuide) do
    if v.GlobalActivityId == self.curOverviewActivityId then
      cellData = DisneyActivityData.new(v)
      if cellData:HasMickey() then
        self.totalMickeyNum = self.totalMickeyNum + 1
      end
      self.overviewStaticMap[k] = cellData
    end
  end
end

function DisneyStageProxy:GetGuildeConfig()
  return self.overviewCfg
end

function DisneyStageProxy:GetMickeyRewardList(index)
  return self.mickeyRewardList and self.mickeyRewardList[index]
end

function DisneyStageProxy:GetOverviewActivity()
  TableUtility.ArrayClear(self.overviewStaticData)
  for _, v in pairs(self.overviewStaticMap) do
    v:ResetStatus()
    if v:CheckCanShow() then
      self.overviewStaticData[#self.overviewStaticData + 1] = v
    end
  end
  table.sort(self.overviewStaticData, _sortGuideFunc)
  return self.overviewStaticData
end

function DisneyStageProxy:CallReceiveMickeyReward(num)
  if not self:IsGuideActRunning() then
    return
  end
  if num < self.mickeyNum then
    return
  end
  _CmdProxy:CallReceiveRewardCmd(self.curOverviewActivityId, num)
end

function DisneyStageProxy:IsGuideActRunning()
  return nil ~= self.curOverviewActivityId
end

DisneyRankMemberData = class("DisneyRankMemberData")

function DisneyRankMemberData:ctor(data, rank)
  self.rank = rank
  self.id = data.charid
  self.serverid = data.serverid
  self.point = data.point
  local showdata = data.showdata
  if showdata then
    self.name = showdata.name
    self.lv = showdata.level
    self.guildid = showdata.guildid
    self.guildname = showdata.guildname
    self.portrait = showdata.portrait
    self.profession = showdata.profession
    self.bodyID = showdata.body
    self.hairID = showdata.hair
    self.haircolor = showdata.haircolor
    self.headID = showdata.head
    self.faceID = showdata.face
    self.mouthID = showdata.mouth
    self.eyeID = showdata.eye
    self.gender = showdata.gender
  end
end

local onStageReadyExtraDelay = 2000

function DisneyStageProxy:CheckEnterStageReady()
  if SceneProxy.Instance:IsNeedWaitCutScene_NoDelayClose() then
    TimeTickManager.Me():CreateOnceDelayTick(onStageReadyExtraDelay, function(owner, deltaTime)
      ServiceDisneyActivityProxy.Instance:CallDisneyMusicClientPrepareCmd()
    end, self)
  end
end

function DisneyStageProxy:ResetQTEStat()
  if not self.clientScoreStat then
    self.clientScoreStat = {}
  else
    TableUtility.TableClear(self.clientScoreStat)
  end
end

local minComboEntry = 3
local rankFactor = {
  0,
  1,
  3
}
local comboMulFactor = {
  1,
  2,
  3,
  4,
  5
}

function DisneyStageProxy:ClientCountingQTEScore(charid, baseScore, rank)
  if not self.clientScoreStat[charid] then
    self.clientScoreStat[charid] = {
      score = 0,
      maxCombo = 0,
      curCombo = 0
    }
  end
  local stat = self.clientScoreStat[charid]
  stat.curCombo = 1 < rank and stat.curCombo + 1 or 0
  stat.maxCombo = math.max(stat.maxCombo, stat.curCombo)
  local calcCombo = math.max(0, stat.curCombo - minComboEntry)
  local mulFactor = 0 < calcCombo and (calcCombo > #comboMulFactor and comboMulFactor[#comboMulFactor] or comboMulFactor[calcCombo]) or 1
  local rankFactor = rank > #rankFactor and rankFactor[#rankFactor] or rankFactor[rank]
  stat.score = stat.score + baseScore * rankFactor * mulFactor
end

function DisneyStageProxy:GetMyselfCurCombo()
  local stat = self.clientScoreStat[Game.Myself.data.id]
  return stat and stat.curCombo and math.max(0, stat.curCombo) or 0
end

function DisneyStageProxy:Handle_RecvDisneyMusicStartCmd(data)
  self:ResetQTEStat()
  self:fxxkTrySetPlayerDir()
  self.currentSong = self:GetServerSong()
  self.currentSong_qteFile = Table_DisneySong and Table_DisneySong[self.currentSong] and Table_DisneySong[self.currentSong].TimelineID
  Game.PlotStoryManager:Launch()
  local result = Game.PlotStoryManager:Start_SEQ_PQTLP(tostring(self.currentSong_qteFile), function(nullParam, isPlayEnd)
    self:Call_DisneyMusicFinishCmd(isPlayEnd)
  end, nil, nil, canSkip, nil, nil, nil, nil, function()
    TimeTickManager.Me():CreateOnceDelayTick(10, function(owner, deltaTime)
      if SceneProxy.Instance:IsNeedWaitCutScene() then
        SceneProxy.Instance:ClearNeedWaitCutScene()
        GameFacade.Instance:sendNotification(LoadSceneEvent.CloseLoadView)
      end
    end, self)
  end, nil)
end

local tempPos = LuaVector3.Zero()
local _SqrDistance = LuaVector3.Distance_Square

function DisneyStageProxy:fxxkTrySetPlayerDir()
  if not GameConfig.DisneyMusicGame then
    return
  end
  local initposdirs
  for _, v in pairs(GameConfig.DisneyMusicGame) do
    if not v.initpos then
      return
    end
    initposdirs = v.initpos
    break
  end
  for k, _ in pairs(self.selectRoleMap) do
    local player = SceneCreatureProxy.FindCreature(k)
    if player then
      local pos = player:GetPosition()
      local kkkk, cccc, ssss, dir
      for i = 1, #initposdirs do
        kkkk = initposdirs[i]
        LuaVector3.Better_Set(tempPos, kkkk[1], kkkk[2], kkkk[3])
        ssss = _SqrDistance(pos, tempPos)
        if not cccc or cccc > ssss then
          cccc = ssss
          dir = kkkk[4]
        end
      end
      if dir then
        player:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, dir, true)
      end
    else
      redlog("DisneyStageProxy", "TrySetPlayerDir", k, "not created.")
    end
  end
end

function DisneyStageProxy:Call_DisneyMusicFinishCmd(isPlayEnd)
  if isPlayEnd then
    local myClientStat = self.clientScoreStat and self.clientScoreStat[Game.Myself.data.id]
    ServiceDisneyActivityProxy.Instance:CallDisneyMusicFinishCmd(self.currentSong, myClientStat and myClientStat.score or 0, myClientStat and myClientStat.maxCombo or 0)
    self.currentSong = nil
    self.currentSong_qteFile = nil
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.DisneyQTEResultView,
      viewdata = {pending = true}
    })
  end
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, DisneyQTEView.ViewType)
end

function DisneyStageProxy:Handle_RecvDisneyMusicResultCmd(data)
  if self.currentSong_qteFile then
    Game.PlotStoryManager:StopProgressById(self.currentSong_qteFile)
    self.currentSong = nil
    self.currentSong_qteFile = nil
  end
  local pass_score, self_score, rankinAll
  for _, v in pairs(GameConfig.DisneyMusicGame) do
    if not v.initpos then
      return
    end
    pass_score = v.reward_least_point
    break
  end
  if self.teamRankInfo then
    TableUtility.ArrayClear(self.teamRankInfo)
  else
    self.teamRankInfo = {}
  end
  table.sort(data.datas, function(a, b)
    return a.point > b.point
  end)
  for i = 1, #data.datas do
    local rawData = data.datas[i]
    local resultData = DisneyQTEResultShowData.new(0, rawData, i)
    TableUtility.ArrayPushBack(self.teamRankInfo, resultData)
    if rawData.charid == Game.Myself.data.id then
      self_score = rawData.point
      rankinAll = i
    end
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.DisneyQTEResultView,
    viewdata = {
      is_win = pass_score <= self_score,
      rankInfo = self.teamRankInfo
    }
  })
end

DisneyMusicMember = class("DisneyMusicMember")

function DisneyMusicMember:ctor(charid, heroid, prepared)
  self.guid = charid
  self.heroId = heroid
  self.prepared = prepared
end

function DisneyMusicMember:IsSelected()
  return self.heroId and self.heroId ~= 0
end

function DisneyMusicMember:IsHeroSelected(heroid)
  return self.heroId == heroid
end

function DisneyMusicMember:IsPrepared()
  return self.prepared == true
end

DisneyTeamAvatar = class("DisneyTeamAvatar")

function DisneyTeamAvatar:ctor(id, avatar)
  self.id = id
  self.avatar = avatar
  self.isSelected = DisneyStageProxy.Instance:IsRoleSelected(id)
end
