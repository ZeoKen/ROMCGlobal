autoImport("ServiceGuildCmdAutoProxy")
ServiceGuildCmdProxy = class("ServiceGuildCmdProxy", ServiceGuildCmdAutoProxy)
ServiceGuildCmdProxy.Instance = nil
ServiceGuildCmdProxy.NAME = "ServiceGuildCmdProxy"

function ServiceGuildCmdProxy:ctor(proxyName)
  if ServiceGuildCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceGuildCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceGuildCmdProxy.Instance = self
  end
end

function ServiceGuildCmdProxy:CallQueryGuildListGuildCmd(keyword, page, conds, list)
  ServiceGuildCmdProxy.super.CallQueryGuildListGuildCmd(self, keyword, page, conds, list)
end

function ServiceGuildCmdProxy:CallCreateGuildGuildCmd(name)
  ServiceGuildCmdProxy.super.CallCreateGuildGuildCmd(self, name)
end

function ServiceGuildCmdProxy:CallApplyGuildGuildCmd(guid, job)
  ServiceGuildCmdProxy.super.CallApplyGuildGuildCmd(self, guid, job)
end

function ServiceGuildCmdProxy:CallInviteMemberGuildCmd(charid, guildid, guildname, invitename, job)
  ServiceGuildCmdProxy.super.CallInviteMemberGuildCmd(self, charid, guildid, guildname, invitename, job)
end

function ServiceGuildCmdProxy:CallProcessApplyGuildCmd(agree, charid, job)
  local opt = agree and GuildCmd_pb.EGUILDACTION_AGREE or GuildCmd_pb.EGUILDACTION_DISAGREE
  ServiceGuildCmdProxy.super.CallProcessApplyGuildCmd(self, opt, charid, job)
end

function ServiceGuildCmdProxy:CallProcessInviteGuildCmd(action, guid, job)
  ServiceGuildCmdProxy.super.CallProcessInviteGuildCmd(self, action, guid, job)
end

function ServiceGuildCmdProxy:CallKickMemberGuildCmd(charid)
  FunctionSecurity.Me():GuildControl(function()
    ServiceGuildCmdProxy.super.CallKickMemberGuildCmd(self, charid)
  end)
end

function ServiceGuildCmdProxy:CallChangeJobGuildCmd(charid, job)
  ServiceGuildCmdProxy.super.CallChangeJobGuildCmd(self, charid, job)
end

function ServiceGuildCmdProxy:CallExchangeChairGuildCmd(newcharid)
  ServiceGuildCmdProxy.super.CallExchangeChairGuildCmd(self, newcharid)
end

function ServiceGuildCmdProxy:CallLevelupGuildCmd()
  ServiceGuildCmdProxy.super.CallLevelupGuildCmd(self)
end

function ServiceGuildCmdProxy:CallDonateContributeGuildCmd(contribute)
  ServiceGuildCmdProxy.super.CallDonateContributeGuildCmd(self, contribute)
end

function ServiceGuildCmdProxy:CallEnterTerritoryGuildCmd()
  if Game.MapManager:IsPVPMode() or Game.MapManager:IsPveMode_Thanatos() then
    MsgManager.ShowMsgByIDTable(984)
  else
    ServiceGuildCmdProxy.super.CallEnterTerritoryGuildCmd(self)
  end
end

function ServiceGuildCmdProxy:CallDismissGuildCmd(set)
  ServiceGuildCmdProxy.super.CallDismissGuildCmd(self, set)
end

function ServiceGuildCmdProxy:CallExitGuildGuildCmd(guildId)
  FunctionSecurity.Me():GuildControl(function()
    ServiceGuildCmdProxy.super.CallExitGuildGuildCmd(self, guildId)
  end)
end

function ServiceGuildCmdProxy:CallPrayGuildCmd(action, pray, count, usecertificate)
  ServiceGuildCmdProxy.super.CallPrayGuildCmd(self, action, pray, count, usecertificate)
end

function ServiceGuildCmdProxy:CallQuerySuperGvgDataGuildCmd()
  ServiceGuildCmdProxy.super.CallQuerySuperGvgDataGuildCmd(self)
end

function ServiceGuildCmdProxy:CallQueryGvgGuildInfoGuildCmd(guildid)
  GvgProxy.Instance:Debug("[NewGVG] CallQueryGvgGuildInfoGuildCmd ", guildid)
  ServiceGuildCmdProxy.super.CallQueryGvgGuildInfoGuildCmd(self, guildid)
end

function ServiceGuildCmdProxy:CallGetGvgRewardGuildCmd()
  ServiceGuildCmdProxy.super.CallGetGvgRewardGuildCmd(self)
end

function ServiceGuildCmdProxy:CallGvgCookingCmd(opt, eat)
  ServiceGuildCmdProxy.super.CallGvgCookingCmd(self, opt, eat)
end

function ServiceGuildCmdProxy:CallGvgCookingUpdateCmd(info, log)
  ServiceGuildCmdProxy.super.CallGvgCookingUpdateCmd(self, info, log)
end

function ServiceGuildCmdProxy:RecvQueryGuildListGuildCmd(data)
  GuildProxy.Instance:UpdateGuildList(data.list)
  self:Notify(ServiceEvent.GuildCmdQueryGuildListGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvEnterGuildGuildCmd(data)
  helplog("RecvEnterGuildGuildCmd")
  FunctionGuild.Me():ResetGuildItemQueryState()
  FunctionGuild.Me():ResetGuildEventQueryState()
  GuildProxy.Instance:InitMyGuildData(data.data)
  if data.data and GuildProxy.Instance:IsMercenaryGuildData(data.data) then
    self:Notify(GuildEvent.EnterMercenary, data)
  else
    self:Notify(ServiceEvent.GuildCmdEnterGuildGuildCmd, data)
  end
end

function ServiceGuildCmdProxy:RecvGuildDataUpdateGuildCmd(data)
  GuildProxy.Instance:UpdateMyGuildData(data)
  self:Notify(ServiceEvent.GuildCmdGuildDataUpdateGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvGuildMemberUpdateGuildCmd(data)
  helplog("========================================语音消息同步===================================")
  GuildProxy.Instance:UpdateMyMembers(data.updates, data.dels)
  self:Notify(ServiceEvent.GuildCmdGuildMemberUpdateGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvGuildMemberDataUpdateGuildCmd(data)
  if data.type == GuildCmd_pb.EGUILDLIST_MEMBER then
    helplog("========================================语音消息同步===================1================")
    GuildProxy.Instance:UpdateMyGuildMemberData(data.charid, data.updates)
  elseif data.type == GuildCmd_pb.EGUILDLIST_APPLY then
    helplog("========================================语音消息同步===================2================")
    GuildProxy.Instance:UpdateMyGuildApplyData(data.charid, data.updates)
  end
  GVoiceProxy.Instance:RecvGuildMemberDataUpdateGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdGuildMemberDataUpdateGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvGuildApplyUpdateGuildCmd(data)
  GuildProxy.Instance:UpdateMyApplys(data.updates, data.dels, data.delmercenarys)
  self:Notify(ServiceEvent.GuildCmdGuildApplyUpdateGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvInviteMemberGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdInviteMemberGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvExitGuildGuildCmd(data)
  helplog("RecvExitGuildGuildCmd")
  local isExitMercenaryGuild = data.guildid and GuildProxy.Instance:IsMyMercenaryGuild(data.guildid) or false
  GuildProxy.Instance:ExitGuild(data.guildid)
  if isExitMercenaryGuild then
    self:Notify(GuildEvent.ExitMercenary, data)
  else
    self:Notify(ServiceEvent.GuildCmdExitGuildGuildCmd, data)
  end
end

local tempArray = {}

function ServiceGuildCmdProxy:RecvGuildInfoNtf(data)
  local player = NSceneUserProxy.Instance:Find(data.charid)
  if player then
    TableUtility.ArrayClear(tempArray)
    tempArray[1] = data.id
    tempArray[2] = data.name
    tempArray[3] = data.icon
    tempArray[4] = data.job
    player.data:SetGuildData(tempArray)
    local mercenary_guild = data.mercenary_guild
    if mercenary_guild then
      tempArray[1] = mercenary_guild.id
      tempArray[2] = mercenary_guild.name
      tempArray[3] = mercenary_guild.icon
      tempArray[4] = mercenary_guild.job
      tempArray[5] = mercenary_guild.mercenary_name
      player.data:SetMercenaryGuildData(tempArray)
    end
    local myselfData = Game.Myself.data
    local myId = myselfData.id
    if data.charid == myId then
      if GuildProxy.Instance:QueryGuildData(data.id) then
        local myGuildData = GuildProxy.Instance.myGuildData
        if myGuildData then
          local myGuildMemberData = myGuildData:GetMemberByGuid(myId)
          if myGuildMemberData and myGuildMemberData:GetJobName() ~= data.job then
            local old, new = myGuildMemberData.job
            local jobMap = myGuildData:GetJobMap()
            for id, jdata in pairs(jobMap) do
              if jdata.name == data.job then
                new = id
                break
              end
            end
            FunctionGuild.Me():MyGuildJobChange(old, new)
          end
        end
      end
    else
      local isInGVG = Game.MapManager:IsInGVG()
      local guildData = isInGVG and player.data:GetMercenaryGuildData() or player.data:GetGuildData()
      local myselfGuildData = isInGVG and myselfData:GetMercenaryGuildData() or myselfData:GetGuildData()
      if myselfGuildData ~= nil and guildData ~= nil then
        player.data:Camp_SetIsInMyGuild(myselfGuildData.id == guildData.id)
      else
        player.data:Camp_SetIsInMyGuild(false)
      end
    end
  end
  self:Notify(ServiceEvent.GuildCmdGuildInfoNtf, data)
end

function ServiceGuildCmdProxy:RecvGuildPrayNtfGuildCmd(data)
  GuildPrayProxy.Instance:HandleServerNtf(data.prays)
  GuildPrayProxy.Instance:UpdateGuildPraySchedule(data.pray_schedule)
  self:Notify(ServiceEvent.GuildCmdGuildPrayNtfGuildCmd, data)
end

function ServiceGuildCmdProxy:CallDonateListGuildCmd(items)
  GuildProxy.Instance:ClearGuildDonateItems()
  ServiceGuildCmdProxy.super.CallDonateListGuildCmd(self, items)
end

function ServiceGuildCmdProxy:RecvDonateListGuildCmd(data)
  local items = data.items
  local num = items and #items or 0
  GuildProxy.Instance:SetMyGuildDonateItems(items)
  helplog("num of donatelist is", #items)
  self:Notify(ServiceEvent.GuildCmdDonateListGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvNewDonateItemGuildCmd(data)
  local donateItem = data.item
  GuildProxy.Instance:AddOrUpdateGuildDonateItem(donateItem)
  self:Notify(ServiceEvent.GuildCmdNewDonateItemGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvUpdateDonateItemGuildCmd(data)
  helplog("recv-->RecvUpdateDonateItemGuildCmd")
  helplog(data.del.configid, "item's configid", data.item.configid, "item's count", data.item.itemid)
  GuildProxy.Instance:RefreshGuildDonateItem(data.del, data.item)
  self:Notify(ServiceEvent.GuildCmdUpdateDonateItemGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvBuildingNtfGuildCmd(data)
  GuildBuildingProxy.Instance:SetBuildingData(data.buildings)
  GuildBuildingProxy.Instance:PlayUpdateEffect()
  self:Notify(ServiceEvent.GuildCmdBuildingNtfGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvBuildingSubmitCountGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdBuildingSubmitCountGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvQueryBuildingRankGuildCmd(data)
  GuildBuildingProxy.Instance:SetBuildingRank(data)
  self:Notify(ServiceEvent.GuildCmdQueryBuildingRankGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvQueryPackGuildCmd(data)
  GuildProxy.Instance:SetGuildPackItems(data.items)
  self:Notify(ServiceEvent.GuildCmdQueryPackGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvPackUpdateGuildCmd(data)
  GuildProxy.Instance:SetGuildPackItems(data.updates)
  GuildProxy.Instance:RemoveGuildPackItems(data.dels)
  self:Notify(ServiceEvent.GuildCmdPackUpdateGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvBuildingLvupEffGuildCmd(data)
  GuildBuildingProxy.Instance:PlayBuildingLvupEff(data.effects)
  self:Notify(ServiceEvent.GuildCmdBuildingLvupEffGuildCmd, data)
end

function ServiceGuildCmdProxy:CallQueryEventListGuildCmd()
  ServiceGuildCmdProxy.super.CallQueryEventListGuildCmd(self)
end

function ServiceGuildCmdProxy:RecvQueryEventListGuildCmd(data)
  GuildProxy.Instance:Server_ResetGuildEventList(data.events)
  self:Notify(ServiceEvent.GuildCmdQueryEventListGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvNewEventGuildCmd(data)
  local isdel = data.del
  if isdel then
    local id = data.event and data.event.guid
    GuildProxy.Instance:Server_RemoveGuildEventData(id)
  else
    GuildProxy.Instance:Server_AddGuildEventData(data.event)
  end
  self:Notify(ServiceEvent.GuildCmdNewEventGuildCmd, data)
end

function ServiceGuildCmdProxy:CallApplyRewardConGuildCmd(configid)
  ServiceGuildCmdProxy.super.CallApplyRewardConGuildCmd(self, configid)
end

function ServiceGuildCmdProxy:RecvApplyRewardConGuildCmd(data)
  FunctionDonateItem.Me():SetDetailInfo(data.configid, data.con, data.asset)
  self:Notify(ServiceEvent.GuildCmdApplyRewardConGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvJobUpdateGuildCmd(data)
  GuildProxy.Instance:UpdateMyGuildJob(data.job)
  self:Notify(ServiceEvent.GuildCmdJobUpdateGuildCmd, data)
end

function ServiceGuildCmdProxy:CallSetGuildOptionGuildCmd(board, recruit, portrait, jobs, needlevel, applied, checked, mercenary, no_attack_metal)
  local pbJobs = {}
  if jobs then
    for i = 1, #jobs do
      local temp = GuildCmd_pb.GuildJob()
      temp.job = jobs[i].job
      temp.name = jobs[i].name
      table.insert(pbJobs, temp)
    end
  end
  if type(portrait) == "number" then
    portrait = tostring(portrait)
  end
  ServiceGuildCmdProxy.super.CallSetGuildOptionGuildCmd(self, board, recruit, portrait, pbJobs, needlevel, applied, checked, mercenary, no_attack_metal)
end

function ServiceGuildCmdProxy:CallModifyAuthGuildCmd(add, modify, job, auth)
  ServiceGuildCmdProxy.super.CallModifyAuthGuildCmd(self, add, modify, job, auth)
end

function ServiceGuildCmdProxy:CallGuildIconAddGuildCmd(index, state, createtime, isdelete, type)
  ServiceGuildCmdProxy.super.CallGuildIconAddGuildCmd(self, index, state, createtime, isdelete, type)
end

function ServiceGuildCmdProxy:RecvGuildIconAddGuildCmd(data)
  GuildProxy.Instance:UpdateMyGuildHeadDataState(data.index, data.state, data.createtime, data.isdelete, data.type)
  self:Notify(ServiceEvent.GuildCmdGuildIconAddGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvGuildIconUploadGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdGuildIconUploadGuildCmd, data)
  EventManager.Me():PassEvent(ServiceEvent.GuildCmdGuildIconUploadGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvGuildIconSyncGuildCmd(data)
  GuildProxy.Instance:UpdateMyGuildHeadDatas(data.infos, data.dels)
  self:Notify(ServiceEvent.GuildCmdGuildIconSyncGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvWelfareNtfGuildCmd(data)
  helplog("Recv-->WelfareNtfGuildCmd", data.welfare)
  GuildProxy.Instance:SetGuildWelfare(data.welfare)
  self:Notify(ServiceEvent.GuildCmdWelfareNtfGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvChallengeUpdateNtfGuildCmd(data)
  GuildProxy.Instance:UpdateGuildChallengeTasks(data.updates, data.dels, data.refreshtime)
  self:Notify(ServiceEvent.GuildCmdChallengeUpdateNtfGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvArtifactUpdateNtfGuildCmd(data)
  ArtifactProxy.Instance:SetArtifactData(data)
  self:Notify(ServiceEvent.GuildCmdArtifactUpdateNtfGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvTreasureActionGuildCmd(data)
  helplog("Recv-->RecvTreasureActionGuildCmd")
  if GuildTreasureProxy.ViewType.TreasurePreview == GuildTreasureProxy.Instance:GetViewType() then
    return
  end
  local isMyself = data.charid == Game.Myself.data.id
  GuildTreasureProxy.Instance:SetTreasure(data)
  if isMyself then
    GuildTreasureProxy.Instance:ShowGuildTreasurePanel(data)
  end
  GuildTreasureProxy.Instance:PlayOpenBox(data, isMyself)
  if isMyself then
    self:Notify(ServiceEvent.GuildCmdTreasureActionGuildCmd, data)
  end
end

function ServiceGuildCmdProxy:RecvQueryTreasureResultGuildCmd(data)
  GuildTreasureProxy.Instance:SetTreasureResult(data.result)
  self:Notify(ServiceEvent.GuildCmdQueryTreasureResultGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvGvgScoreInfoUpdateGuildCmd(data)
  GvgProxy.Instance:HandleRecvGvgScoreInfoUpdateGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdGvgScoreInfoUpdateGuildCmd, data)
  EventManager.Me():PassEvent(ServiceEvent.GuildCmdGvgScoreInfoUpdateGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvQueryGCityShowInfoGuildCmd(data)
  GvgProxy.Instance:Debug("[Debug 旗帜] RecvQueryGCityShowInfoGuildCmd 查询战线id| 数组长度: ", data.groupid, #data.infos)
  GvgProxy.Print(data)
  GvgProxy.Instance:Update_GLandStatusInfos(data.infos, data.groupid)
  self:Notify(ServiceEvent.GuildCmdQueryGCityShowInfoGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvGvgCityStatueQueryGuildCmd(data)
  GvgProxy.Instance:HandleCityStatue(data)
  self:Notify(ServiceEvent.GuildCmdGvgCityStatueQueryGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvGvgCityStatueUpdateGuildCmd(data)
  GvgProxy.Instance:HandleCityStatueUpdate(data)
  self:Notify(ServiceEvent.GuildCmdGvgCityStatueUpdateGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvUpdateMapCityGuildCmd(data)
  helplog("[Debug 旗帜] Recv--> UpdateMapCityGuildCmd")
  TableUtil.Print(data)
  GvgProxy.Instance:UpdateLobbyMapCityGuild(data)
  self:Notify(ServiceEvent.GuildCmdUpdateMapCityGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvGvgOpenFireGuildCmd(data)
  GvgProxy.Instance:SetGvgOpenFireState(data)
  self:Notify(ServiceEvent.GuildCmdGvgOpenFireGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvEnterPunishTimeNtfGuildCmd(data)
  helplog("Recv-->EnterPunishTimeNtfGuildCmd", os.date(DATA_FORMAT, data.exittime))
  GuildProxy.Instance:SetExitTimeTick(data.exittime)
  self:Notify(ServiceEvent.GuildCmdEnterPunishTimeNtfGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvOpenRealtimeVoiceGuildCmd(data)
  helplog("delete---RecvOpenRealtimeVoiceGuildCmd")
  GVoiceProxy.Instance:RecvOpenRealtimeVoiceGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdOpenRealtimeVoiceGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvQuerySuperGvgDataGuildCmd(data)
  helplog("RecvQuerySuperGvgDataGuildCmd", #data.datas, data.end_flag)
  SuperGvgProxy.Instance:HandleSuperGvgRankData(data.datas, data.end_flag)
  if data.end_flag then
    self:Notify(ServiceEvent.GuildCmdQuerySuperGvgDataGuildCmd, data)
  end
end

function ServiceGuildCmdProxy:RecvQueryGvgGuildInfoGuildCmd(data)
  helplog("RecvQueryGvgGuildInfoGuildCmd")
  GvgProxy.Instance:HandleQueryGuildInfo(data)
  self:Notify(ServiceEvent.GuildCmdQueryGvgGuildInfoGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvGvgRewardNtfGuildCmd(data)
  helplog("recv-->RecvGvgRewardGuildCmd", data.has)
  GuildProxy.Instance:UpdateRewardState(data)
  self:Notify(ServiceEvent.GuildCmdGvgRewardNtfGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvGetGvgRewardGuildCmd(data)
  helplog("recv-->RecvGvgRewardGuildCmd")
  self:Notify(ServiceEvent.GuildCmdGetGvgRewardGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvQueryCheckInfoGuildCmd(data)
  GuildProxy.Instance:Server_SetApprovedInfo(data)
  self:Notify(ServiceEvent.GuildCmdQueryCheckInfoGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvQueryBifrostRankGuildCmd(data)
  GuildProxy.Instance:HandleQueryBifrostRankGuildCmd(data.info)
  self:Notify(ServiceEvent.GuildCmdQueryBifrostRankGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvQueryMemberBifrostInfoGuildCmd(data)
  GuildProxy.Instance:HandleQueryMemberBifrostInfo(data.infos, data.score)
  self:Notify(ServiceEvent.GuildCmdQueryMemberBifrostInfoGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvQueryGvgZoneGroupGuildCCmd(data)
  GvgProxy.Instance:RecvQueryGvgZoneGroupGuildCCmd(data)
  self:Notify(ServiceEvent.GuildCmdQueryGvgZoneGroupGuildCCmd, data)
end

function ServiceGuildCmdProxy:RecvGvgRankInfoRetGuildCmd(data)
  GvgProxy.Instance:HandleNewGvgRankInfo(data)
  self:Notify(ServiceEvent.GuildCmdGvgRankInfoRetGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvGvgRankHistroyRetGuildCmd(data)
  GvgProxy.Instance:HandleQueryHistoryGvgRank(data)
  self:Notify(ServiceEvent.GuildCmdGvgRankHistroyRetGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvGvgSmallMetalCntGuildCmd(data)
  GvgProxy.Instance:HandleSmallMetalCnt(data.guildid, data.count)
  self:Notify(ServiceEvent.GuildCmdGvgSmallMetalCntGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvGvgSettleInfoGuildCmd(data)
  GvgProxy.Instance:HandleSettleInfo(data.info)
  self:Notify(ServiceEvent.GuildCmdGvgSettleInfoGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvGvgCookingCmd(data)
  helplog("RecvGvgCookingCmd data length : ", #data)
  self:Notify(ServiceEvent.GuildCmdGvgCookingCmd, data)
end

function ServiceGuildCmdProxy:RecvGvgCookingUpdateCmd(data)
  GvgProxy.Instance:updateCookingInfo(data)
  self:Notify(ServiceEvent.GuildCmdGvgCookingUpdateCmd, data)
end

function ServiceGuildCmdProxy:RecvGvgTaskUpdateGuildCmd(data)
  GvgProxy.Instance:RecvGvgTaskUpdateGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdGvgTaskUpdateGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvGvgStatueSyncGuildCmd(data)
  GvgProxy.Instance:SetStatueInfo(data)
end

function ServiceGuildCmdProxy:RecvGvgFireReportGuildCmd(data)
  SuperGvgProxy.Instance:RecvLastGvgStats(data)
  self:Notify(ServiceEvent.GuildCmdGvgFireReportGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvBuildingUpdateNtfGuildCmd(data)
  GuildBuildingProxy.Instance:HandleRecvBuildingTaskUpdate(data.updates)
  self:Notify(ServiceEvent.GuildCmdBuildingUpdateNtfGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvGvgRoadblockQueryGuildCmd(data)
  GvgProxy.Instance:UpdateMyGuildRoadBlock(data.roadblock)
  self:Notify(ServiceEvent.GuildCmdGvgRoadblockQueryGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvQuerySuperGvgStatCmd(data)
  SuperGvgProxy.Instance:HandleRecvQuerySuperGvgStatCmd(data)
  local isEnd = data.is_end
  if isEnd then
    self:Notify(ServiceEvent.GuildCmdQuerySuperGvgStatCmd, data)
  end
end

function ServiceGuildCmdProxy:RecvDateBattleInfoGuildCmd(data)
  GuildDateBattleProxy.Instance:UpdateRecords(data.datas, data.id)
  self:Notify(ServiceEvent.GuildCmdDateBattleInfoGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvDateBattleInviteGuildCmd(data)
  GuildDateBattleProxy.Instance:UpdateRecords(data.datas, nil, data.guildid)
  self:Notify(ServiceEvent.GuildCmdDateBattleInviteGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvDateBattleReplyGuildCmd(data)
  GuildDateBattleProxy.Instance:UpdateRecords(data.datas)
  self:Notify(ServiceEvent.GuildCmdDateBattleReplyGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvDateBattleListGuildCmd(data)
  GuildDateBattleProxy.Instance:HandleQueryAllRecords(data.datas, data.type)
  self:Notify(ServiceEvent.GuildCmdDateBattleListGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvDateBattleRankGuildCmd(data)
  GuildDateBattleProxy.Instance:HandleQueryRank(data.datas, data.mydata)
  self:Notify(ServiceEvent.GuildCmdDateBattleRankGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvDateBattleTargetGuildCmd(data)
  GuildDateBattleProxy.Instance:HandleTargetGuildDateData(data.guildid, data.datas)
  self:Notify(ServiceEvent.GuildCmdDateBattleTargetGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvDateBattleOpenGuildCmd(data)
  GuildDateBattleProxy.Instance:HandleDateBattleOpen(data)
  self:Notify(ServiceEvent.GuildCmdDateBattleOpenGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvDateBattleReportGuildCmd(data)
  GuildDateBattleProxy.Instance:HandleSetEntranceData(data)
  self:Notify(ServiceEvent.GuildCmdDateBattleReportGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvDateBattleDetailGuildCmd(data)
  GuildDateBattleProxy.Instance:HandleGuildDateReportDetail(data)
  self:Notify(ServiceEvent.GuildCmdDateBattleDetailGuildCmd, data)
end

function ServiceGuildCmdProxy:RecvRedtipOptGuildCmd(data)
  GuildDateBattleProxy.Instance:HandleRedtip(data)
end

function ServiceGuildCmdProxy:RecvDateBattleFlagGuildCmd(data)
end
