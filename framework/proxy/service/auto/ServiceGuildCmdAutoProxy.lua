ServiceGuildCmdAutoProxy = class("ServiceGuildCmdAutoProxy", ServiceProxy)
ServiceGuildCmdAutoProxy.Instance = nil
ServiceGuildCmdAutoProxy.NAME = "ServiceGuildCmdAutoProxy"

function ServiceGuildCmdAutoProxy:ctor(proxyName)
  if ServiceGuildCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceGuildCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceGuildCmdAutoProxy.Instance = self
  end
end

function ServiceGuildCmdAutoProxy:Init()
end

function ServiceGuildCmdAutoProxy:onRegister()
  self:Listen(50, 1, function(data)
    self:RecvQueryGuildListGuildCmd(data)
  end)
  self:Listen(50, 2, function(data)
    self:RecvCreateGuildGuildCmd(data)
  end)
  self:Listen(50, 3, function(data)
    self:RecvEnterGuildGuildCmd(data)
  end)
  self:Listen(50, 4, function(data)
    self:RecvGuildMemberUpdateGuildCmd(data)
  end)
  self:Listen(50, 5, function(data)
    self:RecvGuildApplyUpdateGuildCmd(data)
  end)
  self:Listen(50, 6, function(data)
    self:RecvGuildDataUpdateGuildCmd(data)
  end)
  self:Listen(50, 7, function(data)
    self:RecvGuildMemberDataUpdateGuildCmd(data)
  end)
  self:Listen(50, 8, function(data)
    self:RecvApplyGuildGuildCmd(data)
  end)
  self:Listen(50, 9, function(data)
    self:RecvProcessApplyGuildCmd(data)
  end)
  self:Listen(50, 10, function(data)
    self:RecvInviteMemberGuildCmd(data)
  end)
  self:Listen(50, 11, function(data)
    self:RecvProcessInviteGuildCmd(data)
  end)
  self:Listen(50, 12, function(data)
    self:RecvSetGuildOptionGuildCmd(data)
  end)
  self:Listen(50, 13, function(data)
    self:RecvKickMemberGuildCmd(data)
  end)
  self:Listen(50, 14, function(data)
    self:RecvChangeJobGuildCmd(data)
  end)
  self:Listen(50, 15, function(data)
    self:RecvExitGuildGuildCmd(data)
  end)
  self:Listen(50, 16, function(data)
    self:RecvExchangeChairGuildCmd(data)
  end)
  self:Listen(50, 17, function(data)
    self:RecvDismissGuildCmd(data)
  end)
  self:Listen(50, 18, function(data)
    self:RecvLevelupGuildCmd(data)
  end)
  self:Listen(50, 19, function(data)
    self:RecvDonateGuildCmd(data)
  end)
  self:Listen(50, 25, function(data)
    self:RecvDonateListGuildCmd(data)
  end)
  self:Listen(50, 26, function(data)
    self:RecvUpdateDonateItemGuildCmd(data)
  end)
  self:Listen(50, 27, function(data)
    self:RecvDonateFrameGuildCmd(data)
  end)
  self:Listen(50, 20, function(data)
    self:RecvEnterTerritoryGuildCmd(data)
  end)
  self:Listen(50, 21, function(data)
    self:RecvPrayGuildCmd(data)
  end)
  self:Listen(50, 22, function(data)
    self:RecvGuildInfoNtf(data)
  end)
  self:Listen(50, 23, function(data)
    self:RecvGuildPrayNtfGuildCmd(data)
  end)
  self:Listen(50, 24, function(data)
    self:RecvLevelupEffectGuildCmd(data)
  end)
  self:Listen(50, 28, function(data)
    self:RecvQueryPackGuildCmd(data)
  end)
  self:Listen(50, 32, function(data)
    self:RecvPackUpdateGuildCmd(data)
  end)
  self:Listen(50, 29, function(data)
    self:RecvExchangeZoneGuildCmd(data)
  end)
  self:Listen(50, 30, function(data)
    self:RecvExchangeZoneNtfGuildCmd(data)
  end)
  self:Listen(50, 31, function(data)
    self:RecvExchangeZoneAnswerGuildCmd(data)
  end)
  self:Listen(50, 33, function(data)
    self:RecvQueryEventListGuildCmd(data)
  end)
  self:Listen(50, 34, function(data)
    self:RecvNewEventGuildCmd(data)
  end)
  self:Listen(50, 37, function(data)
    self:RecvFrameStatusGuildCmd(data)
  end)
  self:Listen(50, 38, function(data)
    self:RecvModifyAuthGuildCmd(data)
  end)
  self:Listen(50, 39, function(data)
    self:RecvJobUpdateGuildCmd(data)
  end)
  self:Listen(50, 40, function(data)
    self:RecvRenameQueryGuildCmd(data)
  end)
  self:Listen(50, 41, function(data)
    self:RecvQueryGuildCityInfoGuildCmd(data)
  end)
  self:Listen(50, 42, function(data)
    self:RecvCityActionGuildCmd(data)
  end)
  self:Listen(50, 43, function(data)
    self:RecvGuildIconSyncGuildCmd(data)
  end)
  self:Listen(50, 44, function(data)
    self:RecvGuildIconAddGuildCmd(data)
  end)
  self:Listen(50, 45, function(data)
    self:RecvGuildIconUploadGuildCmd(data)
  end)
  self:Listen(50, 47, function(data)
    self:RecvOpenFunctionGuildCmd(data)
  end)
  self:Listen(50, 48, function(data)
    self:RecvBuildGuildCmd(data)
  end)
  self:Listen(50, 49, function(data)
    self:RecvSubmitMaterialGuildCmd(data)
  end)
  self:Listen(50, 50, function(data)
    self:RecvBuildingNtfGuildCmd(data)
  end)
  self:Listen(50, 51, function(data)
    self:RecvBuildingSubmitCountGuildCmd(data)
  end)
  self:Listen(50, 52, function(data)
    self:RecvChallengeUpdateNtfGuildCmd(data)
  end)
  self:Listen(50, 53, function(data)
    self:RecvWelfareNtfGuildCmd(data)
  end)
  self:Listen(50, 54, function(data)
    self:RecvGetWelfareGuildCmd(data)
  end)
  self:Listen(50, 55, function(data)
    self:RecvBuildingLvupEffGuildCmd(data)
  end)
  self:Listen(50, 56, function(data)
    self:RecvArtifactUpdateNtfGuildCmd(data)
  end)
  self:Listen(50, 57, function(data)
    self:RecvArtifactProduceGuildCmd(data)
  end)
  self:Listen(50, 58, function(data)
    self:RecvArtifactOptGuildCmd(data)
  end)
  self:Listen(50, 59, function(data)
    self:RecvQueryGQuestGuildCmd(data)
  end)
  self:Listen(50, 60, function(data)
    self:RecvTreasureActionGuildCmd(data)
  end)
  self:Listen(50, 61, function(data)
    self:RecvQueryBuildingRankGuildCmd(data)
  end)
  self:Listen(50, 62, function(data)
    self:RecvQueryTreasureResultGuildCmd(data)
  end)
  self:Listen(50, 63, function(data)
    self:RecvQueryGCityShowInfoGuildCmd(data)
  end)
  self:Listen(50, 64, function(data)
    self:RecvGvgOpenFireGuildCmd(data)
  end)
  self:Listen(50, 66, function(data)
    self:RecvEnterPunishTimeNtfGuildCmd(data)
  end)
  self:Listen(50, 67, function(data)
    self:RecvQuerySuperGvgDataGuildCmd(data)
  end)
  self:Listen(50, 68, function(data)
    self:RecvQueryGvgGuildInfoGuildCmd(data)
  end)
  self:Listen(50, 69, function(data)
    self:RecvGvgRewardNtfGuildCmd(data)
  end)
  self:Listen(50, 70, function(data)
    self:RecvGetGvgRewardGuildCmd(data)
  end)
  self:Listen(50, 71, function(data)
    self:RecvQueryCheckInfoGuildCmd(data)
  end)
  self:Listen(50, 72, function(data)
    self:RecvQueryBifrostRankGuildCmd(data)
  end)
  self:Listen(50, 73, function(data)
    self:RecvQueryMemberBifrostInfoGuildCmd(data)
  end)
  self:Listen(50, 74, function(data)
    self:RecvQueryGuildInfoGuildCmd(data)
  end)
  self:Listen(50, 75, function(data)
    self:RecvQueryGvgZoneGroupGuildCCmd(data)
  end)
  self:Listen(50, 76, function(data)
    self:RecvUpdateMapCityGuildCmd(data)
  end)
  self:Listen(50, 77, function(data)
    self:RecvGvgRankInfoQueryGuildCmd(data)
  end)
  self:Listen(50, 78, function(data)
    self:RecvGvgRankInfoRetGuildCmd(data)
  end)
  self:Listen(50, 79, function(data)
    self:RecvGvgRankHistroyQueryGuildCmd(data)
  end)
  self:Listen(50, 80, function(data)
    self:RecvGvgRankHistroyRetGuildCmd(data)
  end)
  self:Listen(50, 81, function(data)
    self:RecvGvgSmallMetalCntGuildCmd(data)
  end)
  self:Listen(50, 84, function(data)
    self:RecvGvgTaskUpdateGuildCmd(data)
  end)
  self:Listen(50, 88, function(data)
    self:RecvGvgStatueSyncGuildCmd(data)
  end)
  self:Listen(50, 82, function(data)
    self:RecvGvgCookingCmd(data)
  end)
  self:Listen(50, 83, function(data)
    self:RecvGvgCookingUpdateCmd(data)
  end)
  self:Listen(50, 89, function(data)
    self:RecvGvgScoreInfoUpdateGuildCmd(data)
  end)
  self:Listen(50, 90, function(data)
    self:RecvGvgSettleReqGuildCmd(data)
  end)
  self:Listen(50, 91, function(data)
    self:RecvGvgSettleInfoGuildCmd(data)
  end)
  self:Listen(50, 92, function(data)
    self:RecvGvgSettleSelectGuildCmd(data)
  end)
  self:Listen(50, 93, function(data)
    self:RecvGvgReqEnterCityGuildCmd(data)
  end)
  self:Listen(50, 94, function(data)
    self:RecvGvgFireReportGuildCmd(data)
  end)
  self:Listen(50, 95, function(data)
    self:RecvBuildingUpdateNtfGuildCmd(data)
  end)
  self:Listen(50, 96, function(data)
    self:RecvGvgRoadblockModifyGuildCmd(data)
  end)
  self:Listen(50, 97, function(data)
    self:RecvGvgRoadblockQueryGuildCmd(data)
  end)
  self:Listen(50, 98, function(data)
    self:RecvExchangeGvgGroupGuildCmd(data)
  end)
  self:Listen(50, 112, function(data)
    self:RecvGvgDataQueryGuildCmd(data)
  end)
  self:Listen(50, 99, function(data)
    self:RecvDateBattleInfoGuildCmd(data)
  end)
  self:Listen(50, 100, function(data)
    self:RecvDateBattleTargetGuildCmd(data)
  end)
  self:Listen(50, 101, function(data)
    self:RecvDateBattleInviteGuildCmd(data)
  end)
  self:Listen(50, 102, function(data)
    self:RecvDateBattleReplyGuildCmd(data)
  end)
  self:Listen(50, 103, function(data)
    self:RecvDateBattleOpenGuildCmd(data)
  end)
  self:Listen(50, 104, function(data)
    self:RecvDateBattleEnterGuildCmd(data)
  end)
  self:Listen(50, 105, function(data)
    self:RecvDateBattleReportGuildCmd(data)
  end)
  self:Listen(50, 106, function(data)
    self:RecvDateBattleDetailGuildCmd(data)
  end)
  self:Listen(50, 107, function(data)
    self:RecvDateBattleListGuildCmd(data)
  end)
  self:Listen(50, 108, function(data)
    self:RecvDateBattleRankGuildCmd(data)
  end)
  self:Listen(50, 109, function(data)
    self:RecvRedtipOptGuildCmd(data)
  end)
  self:Listen(50, 110, function(data)
    self:RecvRedtipBrowseGuildCmd(data)
  end)
  self:Listen(50, 111, function(data)
    self:RecvDateBattleFlagGuildCmd(data)
  end)
  self:Listen(50, 113, function(data)
    self:RecvDateBattleReportUIStateCmd(data)
  end)
  self:Listen(50, 115, function(data)
    self:RecvGvgCityStatueQueryGuildCmd(data)
  end)
  self:Listen(50, 116, function(data)
    self:RecvGvgCityStatueUpdateGuildCmd(data)
  end)
  self:Listen(50, 114, function(data)
    self:RecvQuerySuperGvgStatCmd(data)
  end)
end

function ServiceGuildCmdAutoProxy:CallQueryGuildListGuildCmd(keyword, page, conds, list)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.QueryGuildListGuildCmd()
    if keyword ~= nil then
      msg.keyword = keyword
    end
    if page ~= nil then
      msg.page = page
    end
    if conds ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.conds == nil then
        msg.conds = {}
      end
      for i = 1, #conds do
        table.insert(msg.conds, conds[i])
      end
    end
    if list ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.list == nil then
        msg.list = {}
      end
      for i = 1, #list do
        table.insert(msg.list, list[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryGuildListGuildCmd.id
    local msgParam = {}
    if keyword ~= nil then
      msgParam.keyword = keyword
    end
    if page ~= nil then
      msgParam.page = page
    end
    if conds ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.conds == nil then
        msgParam.conds = {}
      end
      for i = 1, #conds do
        table.insert(msgParam.conds, conds[i])
      end
    end
    if list ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.list == nil then
        msgParam.list = {}
      end
      for i = 1, #list do
        table.insert(msgParam.list, list[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallCreateGuildGuildCmd(name)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.CreateGuildGuildCmd()
    if name ~= nil then
      msg.name = name
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CreateGuildGuildCmd.id
    local msgParam = {}
    if name ~= nil then
      msgParam.name = name
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallEnterGuildGuildCmd(data)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.EnterGuildGuildCmd()
    if data.summary ~= nil and data.summary.guid ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.summary == nil then
        msg.data.summary = {}
      end
      msg.data.summary.guid = data.summary.guid
    end
    if data.summary ~= nil and data.summary.level ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.summary == nil then
        msg.data.summary = {}
      end
      msg.data.summary.level = data.summary.level
    end
    if data.summary ~= nil and data.summary.zoneid ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.summary == nil then
        msg.data.summary = {}
      end
      msg.data.summary.zoneid = data.summary.zoneid
    end
    if data.summary ~= nil and data.summary.serverid ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.summary == nil then
        msg.data.summary = {}
      end
      msg.data.summary.serverid = data.summary.serverid
    end
    if data.summary ~= nil and data.summary.curmember ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.summary == nil then
        msg.data.summary = {}
      end
      msg.data.summary.curmember = data.summary.curmember
    end
    if data.summary ~= nil and data.summary.maxmember ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.summary == nil then
        msg.data.summary = {}
      end
      msg.data.summary.maxmember = data.summary.maxmember
    end
    if data.summary ~= nil and data.summary.curmercenary ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.summary == nil then
        msg.data.summary = {}
      end
      msg.data.summary.curmercenary = data.summary.curmercenary
    end
    if data ~= nil and data.summary.cityid ~= nil then
      if msg.data.summary == nil then
        msg.data.summary = {}
      end
      if msg.data.summary.cityid == nil then
        msg.data.summary.cityid = {}
      end
      for i = 1, #data.summary.cityid do
        table.insert(msg.data.summary.cityid, data.summary.cityid[i])
      end
    end
    if data.summary ~= nil and data.summary.occupy_city ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.summary == nil then
        msg.data.summary = {}
      end
      msg.data.summary.occupy_city = data.summary.occupy_city
    end
    if data.summary ~= nil and data.summary.battle_group ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.summary == nil then
        msg.data.summary = {}
      end
      msg.data.summary.battle_group = data.summary.battle_group
    end
    if data.summary ~= nil and data.summary.next_battle_group ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.summary == nil then
        msg.data.summary = {}
      end
      msg.data.summary.next_battle_group = data.summary.next_battle_group
    end
    if data.summary ~= nil and data.summary.chairmangender ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.summary == nil then
        msg.data.summary = {}
      end
      msg.data.summary.chairmangender = data.summary.chairmangender
    end
    if data.summary ~= nil and data.summary.chairmanname ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.summary == nil then
        msg.data.summary = {}
      end
      msg.data.summary.chairmanname = data.summary.chairmanname
    end
    if data.summary ~= nil and data.summary.guildname ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.summary == nil then
        msg.data.summary = {}
      end
      msg.data.summary.guildname = data.summary.guildname
    end
    if data.summary ~= nil and data.summary.recruitinfo ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.summary == nil then
        msg.data.summary = {}
      end
      msg.data.summary.recruitinfo = data.summary.recruitinfo
    end
    if data.summary ~= nil and data.summary.portrait ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.summary == nil then
        msg.data.summary = {}
      end
      msg.data.summary.portrait = data.summary.portrait
    end
    if data.summary ~= nil and data.summary.chairmanportrait ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.summary == nil then
        msg.data.summary = {}
      end
      msg.data.summary.chairmanportrait = data.summary.chairmanportrait
    end
    if data.summary ~= nil and data.summary.gvglevel ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.summary == nil then
        msg.data.summary = {}
      end
      msg.data.summary.gvglevel = data.summary.gvglevel
    end
    if data.summary ~= nil and data.summary.needlevel ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.summary == nil then
        msg.data.summary = {}
      end
      msg.data.summary.needlevel = data.summary.needlevel
    end
    if data.summary ~= nil and data.summary.nextzoneid ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.summary == nil then
        msg.data.summary = {}
      end
      msg.data.summary.nextzoneid = data.summary.nextzoneid
    end
    if data.summary ~= nil and data.summary.no_attack_metal ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.summary == nil then
        msg.data.summary = {}
      end
      msg.data.summary.no_attack_metal = data.summary.no_attack_metal
    end
    if data.summary ~= nil and data.summary.applied ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.summary == nil then
        msg.data.summary = {}
      end
      msg.data.summary.applied = data.summary.applied
    end
    if data.summary ~= nil and data.summary.mercenary ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.summary == nil then
        msg.data.summary = {}
      end
      msg.data.summary.mercenary = data.summary.mercenary
    end
    if data.summary ~= nil and data.summary.chairmanid ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.summary == nil then
        msg.data.summary = {}
      end
      msg.data.summary.chairmanid = data.summary.chairmanid
    end
    if data ~= nil and data.questresettime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.questresettime = data.questresettime
    end
    if data ~= nil and data.asset ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.asset = data.asset
    end
    if data ~= nil and data.dismisstime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.dismisstime = data.dismisstime
    end
    if data ~= nil and data.zonetime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.zonetime = data.zonetime
    end
    if data ~= nil and data.createtime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.createtime = data.createtime
    end
    if data ~= nil and data.nextzone ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.nextzone = data.nextzone
    end
    if data ~= nil and data.donatetime1 ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.donatetime1 = data.donatetime1
    end
    if data ~= nil and data.donatetime2 ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.donatetime2 = data.donatetime2
    end
    if data ~= nil and data.name ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.name = data.name
    end
    if data ~= nil and data.boardinfo ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.boardinfo = data.boardinfo
    end
    if data ~= nil and data.recruitinfo ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.recruitinfo = data.recruitinfo
    end
    if data ~= nil and data.members ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.members == nil then
        msg.data.members = {}
      end
      for i = 1, #data.members do
        table.insert(msg.data.members, data.members[i])
      end
    end
    if data ~= nil and data.applys ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.applys == nil then
        msg.data.applys = {}
      end
      for i = 1, #data.applys do
        table.insert(msg.data.applys, data.applys[i])
      end
    end
    if data ~= nil and data.jobs ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.jobs == nil then
        msg.data.jobs = {}
      end
      for i = 1, #data.jobs do
        table.insert(msg.data.jobs, data.jobs[i])
      end
    end
    if data ~= nil and data.assettoday ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.assettoday = data.assettoday
    end
    if data ~= nil and data.citygiveuptime ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.citygiveuptime == nil then
        msg.data.citygiveuptime = {}
      end
      for i = 1, #data.citygiveuptime do
        table.insert(msg.data.citygiveuptime, data.citygiveuptime[i])
      end
    end
    if data ~= nil and data.openfunction ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.openfunction = data.openfunction
    end
    if data ~= nil and data.challenges ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.challenges == nil then
        msg.data.challenges = {}
      end
      for i = 1, #data.challenges do
        table.insert(msg.data.challenges, data.challenges[i])
      end
    end
    if data ~= nil and data.gvg_treasure_count ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.gvg_treasure_count = data.gvg_treasure_count
    end
    if data ~= nil and data.guild_treasure_count ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.guild_treasure_count = data.guild_treasure_count
    end
    if data ~= nil and data.bcoin_treasure_count ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.bcoin_treasure_count = data.bcoin_treasure_count
    end
    if data ~= nil and data.insupergvg ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.insupergvg = data.insupergvg
    end
    if data ~= nil and data.supergvg_lv ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.supergvg_lv = data.supergvg_lv
    end
    if data ~= nil and data.material_machine_count ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.material_machine_count = data.material_machine_count
    end
    if data ~= nil and data.assembly_complete_num ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.assembly_complete_num = data.assembly_complete_num
    end
    if data ~= nil and data.change_group_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.change_group_time = data.change_group_time
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EnterGuildGuildCmd.id
    local msgParam = {}
    if data.summary ~= nil and data.summary.guid ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.summary == nil then
        msgParam.data.summary = {}
      end
      msgParam.data.summary.guid = data.summary.guid
    end
    if data.summary ~= nil and data.summary.level ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.summary == nil then
        msgParam.data.summary = {}
      end
      msgParam.data.summary.level = data.summary.level
    end
    if data.summary ~= nil and data.summary.zoneid ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.summary == nil then
        msgParam.data.summary = {}
      end
      msgParam.data.summary.zoneid = data.summary.zoneid
    end
    if data.summary ~= nil and data.summary.serverid ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.summary == nil then
        msgParam.data.summary = {}
      end
      msgParam.data.summary.serverid = data.summary.serverid
    end
    if data.summary ~= nil and data.summary.curmember ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.summary == nil then
        msgParam.data.summary = {}
      end
      msgParam.data.summary.curmember = data.summary.curmember
    end
    if data.summary ~= nil and data.summary.maxmember ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.summary == nil then
        msgParam.data.summary = {}
      end
      msgParam.data.summary.maxmember = data.summary.maxmember
    end
    if data.summary ~= nil and data.summary.curmercenary ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.summary == nil then
        msgParam.data.summary = {}
      end
      msgParam.data.summary.curmercenary = data.summary.curmercenary
    end
    if data ~= nil and data.summary.cityid ~= nil then
      if msgParam.data.summary == nil then
        msgParam.data.summary = {}
      end
      if msgParam.data.summary.cityid == nil then
        msgParam.data.summary.cityid = {}
      end
      for i = 1, #data.summary.cityid do
        table.insert(msgParam.data.summary.cityid, data.summary.cityid[i])
      end
    end
    if data.summary ~= nil and data.summary.occupy_city ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.summary == nil then
        msgParam.data.summary = {}
      end
      msgParam.data.summary.occupy_city = data.summary.occupy_city
    end
    if data.summary ~= nil and data.summary.battle_group ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.summary == nil then
        msgParam.data.summary = {}
      end
      msgParam.data.summary.battle_group = data.summary.battle_group
    end
    if data.summary ~= nil and data.summary.next_battle_group ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.summary == nil then
        msgParam.data.summary = {}
      end
      msgParam.data.summary.next_battle_group = data.summary.next_battle_group
    end
    if data.summary ~= nil and data.summary.chairmangender ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.summary == nil then
        msgParam.data.summary = {}
      end
      msgParam.data.summary.chairmangender = data.summary.chairmangender
    end
    if data.summary ~= nil and data.summary.chairmanname ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.summary == nil then
        msgParam.data.summary = {}
      end
      msgParam.data.summary.chairmanname = data.summary.chairmanname
    end
    if data.summary ~= nil and data.summary.guildname ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.summary == nil then
        msgParam.data.summary = {}
      end
      msgParam.data.summary.guildname = data.summary.guildname
    end
    if data.summary ~= nil and data.summary.recruitinfo ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.summary == nil then
        msgParam.data.summary = {}
      end
      msgParam.data.summary.recruitinfo = data.summary.recruitinfo
    end
    if data.summary ~= nil and data.summary.portrait ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.summary == nil then
        msgParam.data.summary = {}
      end
      msgParam.data.summary.portrait = data.summary.portrait
    end
    if data.summary ~= nil and data.summary.chairmanportrait ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.summary == nil then
        msgParam.data.summary = {}
      end
      msgParam.data.summary.chairmanportrait = data.summary.chairmanportrait
    end
    if data.summary ~= nil and data.summary.gvglevel ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.summary == nil then
        msgParam.data.summary = {}
      end
      msgParam.data.summary.gvglevel = data.summary.gvglevel
    end
    if data.summary ~= nil and data.summary.needlevel ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.summary == nil then
        msgParam.data.summary = {}
      end
      msgParam.data.summary.needlevel = data.summary.needlevel
    end
    if data.summary ~= nil and data.summary.nextzoneid ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.summary == nil then
        msgParam.data.summary = {}
      end
      msgParam.data.summary.nextzoneid = data.summary.nextzoneid
    end
    if data.summary ~= nil and data.summary.no_attack_metal ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.summary == nil then
        msgParam.data.summary = {}
      end
      msgParam.data.summary.no_attack_metal = data.summary.no_attack_metal
    end
    if data.summary ~= nil and data.summary.applied ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.summary == nil then
        msgParam.data.summary = {}
      end
      msgParam.data.summary.applied = data.summary.applied
    end
    if data.summary ~= nil and data.summary.mercenary ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.summary == nil then
        msgParam.data.summary = {}
      end
      msgParam.data.summary.mercenary = data.summary.mercenary
    end
    if data.summary ~= nil and data.summary.chairmanid ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.summary == nil then
        msgParam.data.summary = {}
      end
      msgParam.data.summary.chairmanid = data.summary.chairmanid
    end
    if data ~= nil and data.questresettime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.questresettime = data.questresettime
    end
    if data ~= nil and data.asset ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.asset = data.asset
    end
    if data ~= nil and data.dismisstime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.dismisstime = data.dismisstime
    end
    if data ~= nil and data.zonetime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.zonetime = data.zonetime
    end
    if data ~= nil and data.createtime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.createtime = data.createtime
    end
    if data ~= nil and data.nextzone ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.nextzone = data.nextzone
    end
    if data ~= nil and data.donatetime1 ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.donatetime1 = data.donatetime1
    end
    if data ~= nil and data.donatetime2 ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.donatetime2 = data.donatetime2
    end
    if data ~= nil and data.name ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.name = data.name
    end
    if data ~= nil and data.boardinfo ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.boardinfo = data.boardinfo
    end
    if data ~= nil and data.recruitinfo ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.recruitinfo = data.recruitinfo
    end
    if data ~= nil and data.members ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.members == nil then
        msgParam.data.members = {}
      end
      for i = 1, #data.members do
        table.insert(msgParam.data.members, data.members[i])
      end
    end
    if data ~= nil and data.applys ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.applys == nil then
        msgParam.data.applys = {}
      end
      for i = 1, #data.applys do
        table.insert(msgParam.data.applys, data.applys[i])
      end
    end
    if data ~= nil and data.jobs ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.jobs == nil then
        msgParam.data.jobs = {}
      end
      for i = 1, #data.jobs do
        table.insert(msgParam.data.jobs, data.jobs[i])
      end
    end
    if data ~= nil and data.assettoday ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.assettoday = data.assettoday
    end
    if data ~= nil and data.citygiveuptime ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.citygiveuptime == nil then
        msgParam.data.citygiveuptime = {}
      end
      for i = 1, #data.citygiveuptime do
        table.insert(msgParam.data.citygiveuptime, data.citygiveuptime[i])
      end
    end
    if data ~= nil and data.openfunction ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.openfunction = data.openfunction
    end
    if data ~= nil and data.challenges ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.challenges == nil then
        msgParam.data.challenges = {}
      end
      for i = 1, #data.challenges do
        table.insert(msgParam.data.challenges, data.challenges[i])
      end
    end
    if data ~= nil and data.gvg_treasure_count ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.gvg_treasure_count = data.gvg_treasure_count
    end
    if data ~= nil and data.guild_treasure_count ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.guild_treasure_count = data.guild_treasure_count
    end
    if data ~= nil and data.bcoin_treasure_count ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.bcoin_treasure_count = data.bcoin_treasure_count
    end
    if data ~= nil and data.insupergvg ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.insupergvg = data.insupergvg
    end
    if data ~= nil and data.supergvg_lv ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.supergvg_lv = data.supergvg_lv
    end
    if data ~= nil and data.material_machine_count ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.material_machine_count = data.material_machine_count
    end
    if data ~= nil and data.assembly_complete_num ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.assembly_complete_num = data.assembly_complete_num
    end
    if data ~= nil and data.change_group_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.change_group_time = data.change_group_time
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallGuildMemberUpdateGuildCmd(updates, dels)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.GuildMemberUpdateGuildCmd()
    if updates ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.updates == nil then
        msg.updates = {}
      end
      for i = 1, #updates do
        table.insert(msg.updates, updates[i])
      end
    end
    if dels ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.dels == nil then
        msg.dels = {}
      end
      for i = 1, #dels do
        table.insert(msg.dels, dels[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GuildMemberUpdateGuildCmd.id
    local msgParam = {}
    if updates ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.updates == nil then
        msgParam.updates = {}
      end
      for i = 1, #updates do
        table.insert(msgParam.updates, updates[i])
      end
    end
    if dels ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.dels == nil then
        msgParam.dels = {}
      end
      for i = 1, #dels do
        table.insert(msgParam.dels, dels[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallGuildApplyUpdateGuildCmd(updates, dels, delmercenarys)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.GuildApplyUpdateGuildCmd()
    if updates ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.updates == nil then
        msg.updates = {}
      end
      for i = 1, #updates do
        table.insert(msg.updates, updates[i])
      end
    end
    if dels ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.dels == nil then
        msg.dels = {}
      end
      for i = 1, #dels do
        table.insert(msg.dels, dels[i])
      end
    end
    if delmercenarys ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.delmercenarys == nil then
        msg.delmercenarys = {}
      end
      for i = 1, #delmercenarys do
        table.insert(msg.delmercenarys, delmercenarys[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GuildApplyUpdateGuildCmd.id
    local msgParam = {}
    if updates ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.updates == nil then
        msgParam.updates = {}
      end
      for i = 1, #updates do
        table.insert(msgParam.updates, updates[i])
      end
    end
    if dels ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.dels == nil then
        msgParam.dels = {}
      end
      for i = 1, #dels do
        table.insert(msgParam.dels, dels[i])
      end
    end
    if delmercenarys ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.delmercenarys == nil then
        msgParam.delmercenarys = {}
      end
      for i = 1, #delmercenarys do
        table.insert(msgParam.delmercenarys, delmercenarys[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallGuildDataUpdateGuildCmd(updates, guildid)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.GuildDataUpdateGuildCmd()
    if updates ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.updates == nil then
        msg.updates = {}
      end
      for i = 1, #updates do
        table.insert(msg.updates, updates[i])
      end
    end
    if guildid ~= nil then
      msg.guildid = guildid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GuildDataUpdateGuildCmd.id
    local msgParam = {}
    if updates ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.updates == nil then
        msgParam.updates = {}
      end
      for i = 1, #updates do
        table.insert(msgParam.updates, updates[i])
      end
    end
    if guildid ~= nil then
      msgParam.guildid = guildid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallGuildMemberDataUpdateGuildCmd(type, charid, updates)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.GuildMemberDataUpdateGuildCmd()
    if type ~= nil then
      msg.type = type
    end
    if charid ~= nil then
      msg.charid = charid
    end
    if updates ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.updates == nil then
        msg.updates = {}
      end
      for i = 1, #updates do
        table.insert(msg.updates, updates[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GuildMemberDataUpdateGuildCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    if updates ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.updates == nil then
        msgParam.updates = {}
      end
      for i = 1, #updates do
        table.insert(msgParam.updates, updates[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallApplyGuildGuildCmd(guid, job, datas, attrs)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.ApplyGuildGuildCmd()
    if guid ~= nil then
      msg.guid = guid
    end
    if job ~= nil then
      msg.job = job
    end
    if datas ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.datas == nil then
        msg.datas = {}
      end
      for i = 1, #datas do
        table.insert(msg.datas, datas[i])
      end
    end
    if attrs ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.attrs == nil then
        msg.attrs = {}
      end
      for i = 1, #attrs do
        table.insert(msg.attrs, attrs[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ApplyGuildGuildCmd.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    if job ~= nil then
      msgParam.job = job
    end
    if datas ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.datas == nil then
        msgParam.datas = {}
      end
      for i = 1, #datas do
        table.insert(msgParam.datas, datas[i])
      end
    end
    if attrs ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.attrs == nil then
        msgParam.attrs = {}
      end
      for i = 1, #attrs do
        table.insert(msgParam.attrs, attrs[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallProcessApplyGuildCmd(action, charid, job)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.ProcessApplyGuildCmd()
    if action ~= nil then
      msg.action = action
    end
    if charid ~= nil then
      msg.charid = charid
    end
    if job ~= nil then
      msg.job = job
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ProcessApplyGuildCmd.id
    local msgParam = {}
    if action ~= nil then
      msgParam.action = action
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    if job ~= nil then
      msgParam.job = job
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallInviteMemberGuildCmd(charid, guildid, guildname, invitename, job)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.InviteMemberGuildCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    if guildid ~= nil then
      msg.guildid = guildid
    end
    if guildname ~= nil then
      msg.guildname = guildname
    end
    if invitename ~= nil then
      msg.invitename = invitename
    end
    if job ~= nil then
      msg.job = job
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.InviteMemberGuildCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if guildid ~= nil then
      msgParam.guildid = guildid
    end
    if guildname ~= nil then
      msgParam.guildname = guildname
    end
    if invitename ~= nil then
      msgParam.invitename = invitename
    end
    if job ~= nil then
      msgParam.job = job
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallProcessInviteGuildCmd(action, guid, job)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.ProcessInviteGuildCmd()
    if action ~= nil then
      msg.action = action
    end
    if guid ~= nil then
      msg.guid = guid
    end
    if job ~= nil then
      msg.job = job
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ProcessInviteGuildCmd.id
    local msgParam = {}
    if action ~= nil then
      msgParam.action = action
    end
    if guid ~= nil then
      msgParam.guid = guid
    end
    if job ~= nil then
      msgParam.job = job
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallSetGuildOptionGuildCmd(board, recruit, portrait, jobs, needlevel, applied, checked, mercenary, no_attack_metal)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.SetGuildOptionGuildCmd()
    if board ~= nil then
      msg.board = board
    end
    if recruit ~= nil then
      msg.recruit = recruit
    end
    if portrait ~= nil then
      msg.portrait = portrait
    end
    if jobs ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.jobs == nil then
        msg.jobs = {}
      end
      for i = 1, #jobs do
        table.insert(msg.jobs, jobs[i])
      end
    end
    if needlevel ~= nil then
      msg.needlevel = needlevel
    end
    if applied ~= nil then
      msg.applied = applied
    end
    if checked ~= nil then
      msg.checked = checked
    end
    if mercenary ~= nil then
      msg.mercenary = mercenary
    end
    if no_attack_metal ~= nil then
      msg.no_attack_metal = no_attack_metal
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SetGuildOptionGuildCmd.id
    local msgParam = {}
    if board ~= nil then
      msgParam.board = board
    end
    if recruit ~= nil then
      msgParam.recruit = recruit
    end
    if portrait ~= nil then
      msgParam.portrait = portrait
    end
    if jobs ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.jobs == nil then
        msgParam.jobs = {}
      end
      for i = 1, #jobs do
        table.insert(msgParam.jobs, jobs[i])
      end
    end
    if needlevel ~= nil then
      msgParam.needlevel = needlevel
    end
    if applied ~= nil then
      msgParam.applied = applied
    end
    if checked ~= nil then
      msgParam.checked = checked
    end
    if mercenary ~= nil then
      msgParam.mercenary = mercenary
    end
    if no_attack_metal ~= nil then
      msgParam.no_attack_metal = no_attack_metal
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallKickMemberGuildCmd(charid)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.KickMemberGuildCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.KickMemberGuildCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallChangeJobGuildCmd(charid, job)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.ChangeJobGuildCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    if job ~= nil then
      msg.job = job
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ChangeJobGuildCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if job ~= nil then
      msgParam.job = job
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallExitGuildGuildCmd(guildid)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.ExitGuildGuildCmd()
    if guildid ~= nil then
      msg.guildid = guildid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ExitGuildGuildCmd.id
    local msgParam = {}
    if guildid ~= nil then
      msgParam.guildid = guildid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallExchangeChairGuildCmd(newcharid)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.ExchangeChairGuildCmd()
    if newcharid ~= nil then
      msg.newcharid = newcharid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ExchangeChairGuildCmd.id
    local msgParam = {}
    if newcharid ~= nil then
      msgParam.newcharid = newcharid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallDismissGuildCmd(set)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.DismissGuildCmd()
    if set ~= nil then
      msg.set = set
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DismissGuildCmd.id
    local msgParam = {}
    if set ~= nil then
      msgParam.set = set
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallLevelupGuildCmd()
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.LevelupGuildCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.LevelupGuildCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallDonateGuildCmd(configid, time, count)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.DonateGuildCmd()
    if configid ~= nil then
      msg.configid = configid
    end
    if time ~= nil then
      msg.time = time
    end
    if count ~= nil then
      msg.count = count
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DonateGuildCmd.id
    local msgParam = {}
    if configid ~= nil then
      msgParam.configid = configid
    end
    if time ~= nil then
      msgParam.time = time
    end
    if count ~= nil then
      msgParam.count = count
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallDonateListGuildCmd(items)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.DonateListGuildCmd()
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DonateListGuildCmd.id
    local msgParam = {}
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallUpdateDonateItemGuildCmd(item, del)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.UpdateDonateItemGuildCmd()
    if item ~= nil and item.configid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.configid = item.configid
    end
    if item ~= nil and item.count ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.count = item.count
    end
    if item ~= nil and item.time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.time = item.time
    end
    if item ~= nil and item.itemid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.itemid = item.itemid
    end
    if item ~= nil and item.itemcount ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.itemcount = item.itemcount
    end
    if item ~= nil and item.contribute ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.contribute = item.contribute
    end
    if item ~= nil and item.medal ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.medal = item.medal
    end
    if item ~= nil and item.nextconfigid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.item == nil then
        msg.item = {}
      end
      msg.item.nextconfigid = item.nextconfigid
    end
    if item ~= nil and item.con ~= nil then
      if msg.item == nil then
        msg.item = {}
      end
      if msg.item.con == nil then
        msg.item.con = {}
      end
      for i = 1, #item.con do
        table.insert(msg.item.con, item.con[i])
      end
    end
    if item ~= nil and item.asset ~= nil then
      if msg.item == nil then
        msg.item = {}
      end
      if msg.item.asset == nil then
        msg.item.asset = {}
      end
      for i = 1, #item.asset do
        table.insert(msg.item.asset, item.asset[i])
      end
    end
    if del ~= nil and del.configid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.del == nil then
        msg.del = {}
      end
      msg.del.configid = del.configid
    end
    if del ~= nil and del.count ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.del == nil then
        msg.del = {}
      end
      msg.del.count = del.count
    end
    if del ~= nil and del.time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.del == nil then
        msg.del = {}
      end
      msg.del.time = del.time
    end
    if del ~= nil and del.itemid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.del == nil then
        msg.del = {}
      end
      msg.del.itemid = del.itemid
    end
    if del ~= nil and del.itemcount ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.del == nil then
        msg.del = {}
      end
      msg.del.itemcount = del.itemcount
    end
    if del ~= nil and del.contribute ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.del == nil then
        msg.del = {}
      end
      msg.del.contribute = del.contribute
    end
    if del ~= nil and del.medal ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.del == nil then
        msg.del = {}
      end
      msg.del.medal = del.medal
    end
    if del ~= nil and del.nextconfigid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.del == nil then
        msg.del = {}
      end
      msg.del.nextconfigid = del.nextconfigid
    end
    if del ~= nil and del.con ~= nil then
      if msg.del == nil then
        msg.del = {}
      end
      if msg.del.con == nil then
        msg.del.con = {}
      end
      for i = 1, #del.con do
        table.insert(msg.del.con, del.con[i])
      end
    end
    if del ~= nil and del.asset ~= nil then
      if msg.del == nil then
        msg.del = {}
      end
      if msg.del.asset == nil then
        msg.del.asset = {}
      end
      for i = 1, #del.asset do
        table.insert(msg.del.asset, del.asset[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateDonateItemGuildCmd.id
    local msgParam = {}
    if item ~= nil and item.configid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.configid = item.configid
    end
    if item ~= nil and item.count ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.count = item.count
    end
    if item ~= nil and item.time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.time = item.time
    end
    if item ~= nil and item.itemid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.itemid = item.itemid
    end
    if item ~= nil and item.itemcount ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.itemcount = item.itemcount
    end
    if item ~= nil and item.contribute ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.contribute = item.contribute
    end
    if item ~= nil and item.medal ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.medal = item.medal
    end
    if item ~= nil and item.nextconfigid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.item == nil then
        msgParam.item = {}
      end
      msgParam.item.nextconfigid = item.nextconfigid
    end
    if item ~= nil and item.con ~= nil then
      if msgParam.item == nil then
        msgParam.item = {}
      end
      if msgParam.item.con == nil then
        msgParam.item.con = {}
      end
      for i = 1, #item.con do
        table.insert(msgParam.item.con, item.con[i])
      end
    end
    if item ~= nil and item.asset ~= nil then
      if msgParam.item == nil then
        msgParam.item = {}
      end
      if msgParam.item.asset == nil then
        msgParam.item.asset = {}
      end
      for i = 1, #item.asset do
        table.insert(msgParam.item.asset, item.asset[i])
      end
    end
    if del ~= nil and del.configid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.del == nil then
        msgParam.del = {}
      end
      msgParam.del.configid = del.configid
    end
    if del ~= nil and del.count ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.del == nil then
        msgParam.del = {}
      end
      msgParam.del.count = del.count
    end
    if del ~= nil and del.time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.del == nil then
        msgParam.del = {}
      end
      msgParam.del.time = del.time
    end
    if del ~= nil and del.itemid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.del == nil then
        msgParam.del = {}
      end
      msgParam.del.itemid = del.itemid
    end
    if del ~= nil and del.itemcount ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.del == nil then
        msgParam.del = {}
      end
      msgParam.del.itemcount = del.itemcount
    end
    if del ~= nil and del.contribute ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.del == nil then
        msgParam.del = {}
      end
      msgParam.del.contribute = del.contribute
    end
    if del ~= nil and del.medal ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.del == nil then
        msgParam.del = {}
      end
      msgParam.del.medal = del.medal
    end
    if del ~= nil and del.nextconfigid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.del == nil then
        msgParam.del = {}
      end
      msgParam.del.nextconfigid = del.nextconfigid
    end
    if del ~= nil and del.con ~= nil then
      if msgParam.del == nil then
        msgParam.del = {}
      end
      if msgParam.del.con == nil then
        msgParam.del.con = {}
      end
      for i = 1, #del.con do
        table.insert(msgParam.del.con, del.con[i])
      end
    end
    if del ~= nil and del.asset ~= nil then
      if msgParam.del == nil then
        msgParam.del = {}
      end
      if msgParam.del.asset == nil then
        msgParam.del.asset = {}
      end
      for i = 1, #del.asset do
        table.insert(msgParam.del.asset, del.asset[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallDonateFrameGuildCmd(open)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.DonateFrameGuildCmd()
    if open ~= nil then
      msg.open = open
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DonateFrameGuildCmd.id
    local msgParam = {}
    if open ~= nil then
      msgParam.open = open
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallEnterTerritoryGuildCmd(handid)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.EnterTerritoryGuildCmd()
    if handid ~= nil then
      msg.handid = handid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EnterTerritoryGuildCmd.id
    local msgParam = {}
    if handid ~= nil then
      msgParam.handid = handid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallPrayGuildCmd(action, pray, count, usecertificate)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.PrayGuildCmd()
    if action ~= nil then
      msg.action = action
    end
    if pray ~= nil then
      msg.pray = pray
    end
    if count ~= nil then
      msg.count = count
    end
    if usecertificate ~= nil then
      msg.usecertificate = usecertificate
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PrayGuildCmd.id
    local msgParam = {}
    if action ~= nil then
      msgParam.action = action
    end
    if pray ~= nil then
      msgParam.pray = pray
    end
    if count ~= nil then
      msgParam.count = count
    end
    if usecertificate ~= nil then
      msgParam.usecertificate = usecertificate
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallGuildInfoNtf(charid, id, name, icon, job, ismvp, mercenary_guild)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.GuildInfoNtf()
    if charid ~= nil then
      msg.charid = charid
    end
    if id ~= nil then
      msg.id = id
    end
    if name ~= nil then
      msg.name = name
    end
    if icon ~= nil then
      msg.icon = icon
    end
    if job ~= nil then
      msg.job = job
    end
    if ismvp ~= nil then
      msg.ismvp = ismvp
    end
    if mercenary_guild ~= nil and mercenary_guild.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mercenary_guild == nil then
        msg.mercenary_guild = {}
      end
      msg.mercenary_guild.id = mercenary_guild.id
    end
    if mercenary_guild ~= nil and mercenary_guild.name ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mercenary_guild == nil then
        msg.mercenary_guild = {}
      end
      msg.mercenary_guild.name = mercenary_guild.name
    end
    if mercenary_guild ~= nil and mercenary_guild.icon ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mercenary_guild == nil then
        msg.mercenary_guild = {}
      end
      msg.mercenary_guild.icon = mercenary_guild.icon
    end
    if mercenary_guild ~= nil and mercenary_guild.job ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mercenary_guild == nil then
        msg.mercenary_guild = {}
      end
      msg.mercenary_guild.job = mercenary_guild.job
    end
    if mercenary_guild ~= nil and mercenary_guild.mercenary_name ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mercenary_guild == nil then
        msg.mercenary_guild = {}
      end
      msg.mercenary_guild.mercenary_name = mercenary_guild.mercenary_name
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GuildInfoNtf.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if id ~= nil then
      msgParam.id = id
    end
    if name ~= nil then
      msgParam.name = name
    end
    if icon ~= nil then
      msgParam.icon = icon
    end
    if job ~= nil then
      msgParam.job = job
    end
    if ismvp ~= nil then
      msgParam.ismvp = ismvp
    end
    if mercenary_guild ~= nil and mercenary_guild.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mercenary_guild == nil then
        msgParam.mercenary_guild = {}
      end
      msgParam.mercenary_guild.id = mercenary_guild.id
    end
    if mercenary_guild ~= nil and mercenary_guild.name ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mercenary_guild == nil then
        msgParam.mercenary_guild = {}
      end
      msgParam.mercenary_guild.name = mercenary_guild.name
    end
    if mercenary_guild ~= nil and mercenary_guild.icon ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mercenary_guild == nil then
        msgParam.mercenary_guild = {}
      end
      msgParam.mercenary_guild.icon = mercenary_guild.icon
    end
    if mercenary_guild ~= nil and mercenary_guild.job ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mercenary_guild == nil then
        msgParam.mercenary_guild = {}
      end
      msgParam.mercenary_guild.job = mercenary_guild.job
    end
    if mercenary_guild ~= nil and mercenary_guild.mercenary_name ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mercenary_guild == nil then
        msgParam.mercenary_guild = {}
      end
      msgParam.mercenary_guild.mercenary_name = mercenary_guild.mercenary_name
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallGuildPrayNtfGuildCmd(prays, pray_schedule)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.GuildPrayNtfGuildCmd()
    if prays ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.prays == nil then
        msg.prays = {}
      end
      for i = 1, #prays do
        table.insert(msg.prays, prays[i])
      end
    end
    if pray_schedule ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.pray_schedule == nil then
        msg.pray_schedule = {}
      end
      for i = 1, #pray_schedule do
        table.insert(msg.pray_schedule, pray_schedule[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GuildPrayNtfGuildCmd.id
    local msgParam = {}
    if prays ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.prays == nil then
        msgParam.prays = {}
      end
      for i = 1, #prays do
        table.insert(msgParam.prays, prays[i])
      end
    end
    if pray_schedule ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.pray_schedule == nil then
        msgParam.pray_schedule = {}
      end
      for i = 1, #pray_schedule do
        table.insert(msgParam.pray_schedule, pray_schedule[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallLevelupEffectGuildCmd()
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.LevelupEffectGuildCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.LevelupEffectGuildCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallQueryPackGuildCmd(items)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.QueryPackGuildCmd()
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryPackGuildCmd.id
    local msgParam = {}
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallPackUpdateGuildCmd(updates, dels)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.PackUpdateGuildCmd()
    if updates ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.updates == nil then
        msg.updates = {}
      end
      for i = 1, #updates do
        table.insert(msg.updates, updates[i])
      end
    end
    if dels ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.dels == nil then
        msg.dels = {}
      end
      for i = 1, #dels do
        table.insert(msg.dels, dels[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PackUpdateGuildCmd.id
    local msgParam = {}
    if updates ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.updates == nil then
        msgParam.updates = {}
      end
      for i = 1, #updates do
        table.insert(msgParam.updates, updates[i])
      end
    end
    if dels ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.dels == nil then
        msgParam.dels = {}
      end
      for i = 1, #dels do
        table.insert(msgParam.dels, dels[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallExchangeZoneGuildCmd(zoneid, set)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.ExchangeZoneGuildCmd()
    if zoneid ~= nil then
      msg.zoneid = zoneid
    end
    if set ~= nil then
      msg.set = set
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ExchangeZoneGuildCmd.id
    local msgParam = {}
    if zoneid ~= nil then
      msgParam.zoneid = zoneid
    end
    if set ~= nil then
      msgParam.set = set
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallExchangeZoneNtfGuildCmd(nextzoneid, curzoneid)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.ExchangeZoneNtfGuildCmd()
    if nextzoneid ~= nil then
      msg.nextzoneid = nextzoneid
    end
    if curzoneid ~= nil then
      msg.curzoneid = curzoneid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ExchangeZoneNtfGuildCmd.id
    local msgParam = {}
    if nextzoneid ~= nil then
      msgParam.nextzoneid = nextzoneid
    end
    if curzoneid ~= nil then
      msgParam.curzoneid = curzoneid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallExchangeZoneAnswerGuildCmd(agree)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.ExchangeZoneAnswerGuildCmd()
    if agree ~= nil then
      msg.agree = agree
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ExchangeZoneAnswerGuildCmd.id
    local msgParam = {}
    if agree ~= nil then
      msgParam.agree = agree
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallQueryEventListGuildCmd(events)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.QueryEventListGuildCmd()
    if events ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.events == nil then
        msg.events = {}
      end
      for i = 1, #events do
        table.insert(msg.events, events[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryEventListGuildCmd.id
    local msgParam = {}
    if events ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.events == nil then
        msgParam.events = {}
      end
      for i = 1, #events do
        table.insert(msgParam.events, events[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallNewEventGuildCmd(del, event)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.NewEventGuildCmd()
    if del ~= nil then
      msg.del = del
    end
    if event ~= nil and event.guid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.event == nil then
        msg.event = {}
      end
      msg.event.guid = event.guid
    end
    if event ~= nil and event.eventid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.event == nil then
        msg.event = {}
      end
      msg.event.eventid = event.eventid
    end
    if event ~= nil and event.time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.event == nil then
        msg.event = {}
      end
      msg.event.time = event.time
    end
    if event ~= nil and event.param ~= nil then
      if msg.event == nil then
        msg.event = {}
      end
      if msg.event.param == nil then
        msg.event.param = {}
      end
      for i = 1, #event.param do
        table.insert(msg.event.param, event.param[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NewEventGuildCmd.id
    local msgParam = {}
    if del ~= nil then
      msgParam.del = del
    end
    if event ~= nil and event.guid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.event == nil then
        msgParam.event = {}
      end
      msgParam.event.guid = event.guid
    end
    if event ~= nil and event.eventid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.event == nil then
        msgParam.event = {}
      end
      msgParam.event.eventid = event.eventid
    end
    if event ~= nil and event.time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.event == nil then
        msgParam.event = {}
      end
      msgParam.event.time = event.time
    end
    if event ~= nil and event.param ~= nil then
      if msgParam.event == nil then
        msgParam.event = {}
      end
      if msgParam.event.param == nil then
        msgParam.event.param = {}
      end
      for i = 1, #event.param do
        table.insert(msgParam.event.param, event.param[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallFrameStatusGuildCmd(open)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.FrameStatusGuildCmd()
    if open ~= nil then
      msg.open = open
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FrameStatusGuildCmd.id
    local msgParam = {}
    if open ~= nil then
      msgParam.open = open
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallModifyAuthGuildCmd(add, modify, job, auth)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.ModifyAuthGuildCmd()
    if add ~= nil then
      msg.add = add
    end
    if modify ~= nil then
      msg.modify = modify
    end
    if job ~= nil then
      msg.job = job
    end
    if auth ~= nil then
      msg.auth = auth
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ModifyAuthGuildCmd.id
    local msgParam = {}
    if add ~= nil then
      msgParam.add = add
    end
    if modify ~= nil then
      msgParam.modify = modify
    end
    if job ~= nil then
      msgParam.job = job
    end
    if auth ~= nil then
      msgParam.auth = auth
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallJobUpdateGuildCmd(job)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.JobUpdateGuildCmd()
    if job ~= nil and job.job ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.job == nil then
        msg.job = {}
      end
      msg.job.job = job.job
    end
    if job ~= nil and job.name ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.job == nil then
        msg.job = {}
      end
      msg.job.name = job.name
    end
    if job ~= nil and job.auth ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.job == nil then
        msg.job = {}
      end
      msg.job.auth = job.auth
    end
    if job ~= nil and job.editauth ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.job == nil then
        msg.job = {}
      end
      msg.job.editauth = job.editauth
    end
    if job ~= nil and job.auth2 ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.job == nil then
        msg.job = {}
      end
      msg.job.auth2 = job.auth2
    end
    if job ~= nil and job.editauth2 ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.job == nil then
        msg.job = {}
      end
      msg.job.editauth2 = job.editauth2
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.JobUpdateGuildCmd.id
    local msgParam = {}
    if job ~= nil and job.job ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.job == nil then
        msgParam.job = {}
      end
      msgParam.job.job = job.job
    end
    if job ~= nil and job.name ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.job == nil then
        msgParam.job = {}
      end
      msgParam.job.name = job.name
    end
    if job ~= nil and job.auth ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.job == nil then
        msgParam.job = {}
      end
      msgParam.job.auth = job.auth
    end
    if job ~= nil and job.editauth ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.job == nil then
        msgParam.job = {}
      end
      msgParam.job.editauth = job.editauth
    end
    if job ~= nil and job.auth2 ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.job == nil then
        msgParam.job = {}
      end
      msgParam.job.auth2 = job.auth2
    end
    if job ~= nil and job.editauth2 ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.job == nil then
        msgParam.job = {}
      end
      msgParam.job.editauth2 = job.editauth2
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallRenameQueryGuildCmd(name, code)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.RenameQueryGuildCmd()
    if name ~= nil then
      msg.name = name
    end
    if code ~= nil then
      msg.code = code
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RenameQueryGuildCmd.id
    local msgParam = {}
    if name ~= nil then
      msgParam.name = name
    end
    if code ~= nil then
      msgParam.code = code
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallQueryGuildCityInfoGuildCmd(infos)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.QueryGuildCityInfoGuildCmd()
    if infos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.infos == nil then
        msg.infos = {}
      end
      for i = 1, #infos do
        table.insert(msg.infos, infos[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryGuildCityInfoGuildCmd.id
    local msgParam = {}
    if infos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.infos == nil then
        msgParam.infos = {}
      end
      for i = 1, #infos do
        table.insert(msgParam.infos, infos[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallCityActionGuildCmd(action, cityid)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.CityActionGuildCmd()
    if action ~= nil then
      msg.action = action
    end
    if cityid ~= nil then
      msg.cityid = cityid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CityActionGuildCmd.id
    local msgParam = {}
    if action ~= nil then
      msgParam.action = action
    end
    if cityid ~= nil then
      msgParam.cityid = cityid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallGuildIconSyncGuildCmd(infos, dels)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.GuildIconSyncGuildCmd()
    if infos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.infos == nil then
        msg.infos = {}
      end
      for i = 1, #infos do
        table.insert(msg.infos, infos[i])
      end
    end
    if dels ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.dels == nil then
        msg.dels = {}
      end
      for i = 1, #dels do
        table.insert(msg.dels, dels[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GuildIconSyncGuildCmd.id
    local msgParam = {}
    if infos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.infos == nil then
        msgParam.infos = {}
      end
      for i = 1, #infos do
        table.insert(msgParam.infos, infos[i])
      end
    end
    if dels ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.dels == nil then
        msgParam.dels = {}
      end
      for i = 1, #dels do
        table.insert(msgParam.dels, dels[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallGuildIconAddGuildCmd(index, state, createtime, isdelete, type)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.GuildIconAddGuildCmd()
    if index ~= nil then
      msg.index = index
    end
    if state ~= nil then
      msg.state = state
    end
    if createtime ~= nil then
      msg.createtime = createtime
    end
    if isdelete ~= nil then
      msg.isdelete = isdelete
    end
    if type ~= nil then
      msg.type = type
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GuildIconAddGuildCmd.id
    local msgParam = {}
    if index ~= nil then
      msgParam.index = index
    end
    if state ~= nil then
      msgParam.state = state
    end
    if createtime ~= nil then
      msgParam.createtime = createtime
    end
    if isdelete ~= nil then
      msgParam.isdelete = isdelete
    end
    if type ~= nil then
      msgParam.type = type
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallGuildIconUploadGuildCmd(index, policy, signature, type)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.GuildIconUploadGuildCmd()
    if index ~= nil then
      msg.index = index
    end
    if policy ~= nil then
      msg.policy = policy
    end
    if signature ~= nil then
      msg.signature = signature
    end
    if type ~= nil then
      msg.type = type
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GuildIconUploadGuildCmd.id
    local msgParam = {}
    if index ~= nil then
      msgParam.index = index
    end
    if policy ~= nil then
      msgParam.policy = policy
    end
    if signature ~= nil then
      msgParam.signature = signature
    end
    if type ~= nil then
      msgParam.type = type
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallOpenFunctionGuildCmd(func)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.OpenFunctionGuildCmd()
    if func ~= nil then
      msg.func = func
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.OpenFunctionGuildCmd.id
    local msgParam = {}
    if func ~= nil then
      msgParam.func = func
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallBuildGuildCmd(building)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.BuildGuildCmd()
    if building ~= nil then
      msg.building = building
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BuildGuildCmd.id
    local msgParam = {}
    if building ~= nil then
      msgParam.building = building
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallSubmitMaterialGuildCmd(building, materialid, materials)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.SubmitMaterialGuildCmd()
    if building ~= nil then
      msg.building = building
    end
    if materialid ~= nil then
      msg.materialid = materialid
    end
    if materials ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.materials == nil then
        msg.materials = {}
      end
      for i = 1, #materials do
        table.insert(msg.materials, materials[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SubmitMaterialGuildCmd.id
    local msgParam = {}
    if building ~= nil then
      msgParam.building = building
    end
    if materialid ~= nil then
      msgParam.materialid = materialid
    end
    if materials ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.materials == nil then
        msgParam.materials = {}
      end
      for i = 1, #materials do
        table.insert(msgParam.materials, materials[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallBuildingNtfGuildCmd(buildings)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.BuildingNtfGuildCmd()
    if buildings ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.buildings == nil then
        msg.buildings = {}
      end
      for i = 1, #buildings do
        table.insert(msg.buildings, buildings[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BuildingNtfGuildCmd.id
    local msgParam = {}
    if buildings ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.buildings == nil then
        msgParam.buildings = {}
      end
      for i = 1, #buildings do
        table.insert(msgParam.buildings, buildings[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallBuildingSubmitCountGuildCmd(type, count)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.BuildingSubmitCountGuildCmd()
    if type ~= nil then
      msg.type = type
    end
    if count ~= nil then
      msg.count = count
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BuildingSubmitCountGuildCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if count ~= nil then
      msgParam.count = count
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallChallengeUpdateNtfGuildCmd(updates, dels, refreshtime)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.ChallengeUpdateNtfGuildCmd()
    if updates ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.updates == nil then
        msg.updates = {}
      end
      for i = 1, #updates do
        table.insert(msg.updates, updates[i])
      end
    end
    if dels ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.dels == nil then
        msg.dels = {}
      end
      for i = 1, #dels do
        table.insert(msg.dels, dels[i])
      end
    end
    if refreshtime ~= nil then
      msg.refreshtime = refreshtime
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ChallengeUpdateNtfGuildCmd.id
    local msgParam = {}
    if updates ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.updates == nil then
        msgParam.updates = {}
      end
      for i = 1, #updates do
        table.insert(msgParam.updates, updates[i])
      end
    end
    if dels ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.dels == nil then
        msgParam.dels = {}
      end
      for i = 1, #dels do
        table.insert(msgParam.dels, dels[i])
      end
    end
    if refreshtime ~= nil then
      msgParam.refreshtime = refreshtime
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallWelfareNtfGuildCmd(welfare)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.WelfareNtfGuildCmd()
    if welfare ~= nil then
      msg.welfare = welfare
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.WelfareNtfGuildCmd.id
    local msgParam = {}
    if welfare ~= nil then
      msgParam.welfare = welfare
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallGetWelfareGuildCmd()
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.GetWelfareGuildCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GetWelfareGuildCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallBuildingLvupEffGuildCmd(effects)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.BuildingLvupEffGuildCmd()
    if effects ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.effects == nil then
        msg.effects = {}
      end
      for i = 1, #effects do
        table.insert(msg.effects, effects[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BuildingLvupEffGuildCmd.id
    local msgParam = {}
    if effects ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.effects == nil then
        msgParam.effects = {}
      end
      for i = 1, #effects do
        table.insert(msgParam.effects, effects[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallArtifactUpdateNtfGuildCmd(itemupdates, itemdels, dataupdates, guild_id)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.ArtifactUpdateNtfGuildCmd()
    if itemupdates ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemupdates == nil then
        msg.itemupdates = {}
      end
      for i = 1, #itemupdates do
        table.insert(msg.itemupdates, itemupdates[i])
      end
    end
    if itemdels ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.itemdels == nil then
        msg.itemdels = {}
      end
      for i = 1, #itemdels do
        table.insert(msg.itemdels, itemdels[i])
      end
    end
    if dataupdates ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.dataupdates == nil then
        msg.dataupdates = {}
      end
      for i = 1, #dataupdates do
        table.insert(msg.dataupdates, dataupdates[i])
      end
    end
    if guild_id ~= nil then
      msg.guild_id = guild_id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ArtifactUpdateNtfGuildCmd.id
    local msgParam = {}
    if itemupdates ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemupdates == nil then
        msgParam.itemupdates = {}
      end
      for i = 1, #itemupdates do
        table.insert(msgParam.itemupdates, itemupdates[i])
      end
    end
    if itemdels ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.itemdels == nil then
        msgParam.itemdels = {}
      end
      for i = 1, #itemdels do
        table.insert(msgParam.itemdels, itemdels[i])
      end
    end
    if dataupdates ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.dataupdates == nil then
        msgParam.dataupdates = {}
      end
      for i = 1, #dataupdates do
        table.insert(msgParam.dataupdates, dataupdates[i])
      end
    end
    if guild_id ~= nil then
      msgParam.guild_id = guild_id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallArtifactProduceGuildCmd(id)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.ArtifactProduceGuildCmd()
    if id ~= nil then
      msg.id = id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ArtifactProduceGuildCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallArtifactOptGuildCmd(opt, guid, charid, mercenary_queried, is_mercenary)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.ArtifactOptGuildCmd()
    if opt ~= nil then
      msg.opt = opt
    end
    if guid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.guid == nil then
        msg.guid = {}
      end
      for i = 1, #guid do
        table.insert(msg.guid, guid[i])
      end
    end
    if charid ~= nil then
      msg.charid = charid
    end
    if mercenary_queried ~= nil then
      msg.mercenary_queried = mercenary_queried
    end
    if is_mercenary ~= nil then
      msg.is_mercenary = is_mercenary
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ArtifactOptGuildCmd.id
    local msgParam = {}
    if opt ~= nil then
      msgParam.opt = opt
    end
    if guid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.guid == nil then
        msgParam.guid = {}
      end
      for i = 1, #guid do
        table.insert(msgParam.guid, guid[i])
      end
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    if mercenary_queried ~= nil then
      msgParam.mercenary_queried = mercenary_queried
    end
    if is_mercenary ~= nil then
      msgParam.is_mercenary = is_mercenary
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallQueryGQuestGuildCmd(submit_quests)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.QueryGQuestGuildCmd()
    if submit_quests ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.submit_quests == nil then
        msg.submit_quests = {}
      end
      for i = 1, #submit_quests do
        table.insert(msg.submit_quests, submit_quests[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryGQuestGuildCmd.id
    local msgParam = {}
    if submit_quests ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.submit_quests == nil then
        msgParam.submit_quests = {}
      end
      for i = 1, #submit_quests do
        table.insert(msgParam.submit_quests, submit_quests[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallTreasureActionGuildCmd(charid, guild_treasure_count, bcoin_treasure_count, action, point, treasure)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.TreasureActionGuildCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    if guild_treasure_count ~= nil then
      msg.guild_treasure_count = guild_treasure_count
    end
    if bcoin_treasure_count ~= nil then
      msg.bcoin_treasure_count = bcoin_treasure_count
    end
    if action ~= nil then
      msg.action = action
    end
    if point ~= nil then
      msg.point = point
    end
    if treasure ~= nil and treasure.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.treasure == nil then
        msg.treasure = {}
      end
      msg.treasure.id = treasure.id
    end
    if treasure ~= nil and treasure.count ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.treasure == nil then
        msg.treasure = {}
      end
      msg.treasure.count = treasure.count
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TreasureActionGuildCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if guild_treasure_count ~= nil then
      msgParam.guild_treasure_count = guild_treasure_count
    end
    if bcoin_treasure_count ~= nil then
      msgParam.bcoin_treasure_count = bcoin_treasure_count
    end
    if action ~= nil then
      msgParam.action = action
    end
    if point ~= nil then
      msgParam.point = point
    end
    if treasure ~= nil and treasure.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.treasure == nil then
        msgParam.treasure = {}
      end
      msgParam.treasure.id = treasure.id
    end
    if treasure ~= nil and treasure.count ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.treasure == nil then
        msgParam.treasure = {}
      end
      msgParam.treasure.count = treasure.count
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallQueryBuildingRankGuildCmd(type, items)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.QueryBuildingRankGuildCmd()
    if type ~= nil then
      msg.type = type
    end
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryBuildingRankGuildCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallQueryTreasureResultGuildCmd(eventguid, result)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.QueryTreasureResultGuildCmd()
    if eventguid ~= nil then
      msg.eventguid = eventguid
    end
    if result ~= nil and result.ownerid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.result == nil then
        msg.result = {}
      end
      msg.result.ownerid = result.ownerid
    end
    if result ~= nil and result.eventguid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.result == nil then
        msg.result = {}
      end
      msg.result.eventguid = result.eventguid
    end
    if result ~= nil and result.treasureid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.result == nil then
        msg.result = {}
      end
      msg.result.treasureid = result.treasureid
    end
    if result ~= nil and result.totalmember ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.result == nil then
        msg.result = {}
      end
      msg.result.totalmember = result.totalmember
    end
    if result ~= nil and result.state ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.result == nil then
        msg.result = {}
      end
      msg.result.state = result.state
    end
    if result ~= nil and result.items ~= nil then
      if msg.result == nil then
        msg.result = {}
      end
      if msg.result.items == nil then
        msg.result.items = {}
      end
      for i = 1, #result.items do
        table.insert(msg.result.items, result.items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryTreasureResultGuildCmd.id
    local msgParam = {}
    if eventguid ~= nil then
      msgParam.eventguid = eventguid
    end
    if result ~= nil and result.ownerid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.result == nil then
        msgParam.result = {}
      end
      msgParam.result.ownerid = result.ownerid
    end
    if result ~= nil and result.eventguid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.result == nil then
        msgParam.result = {}
      end
      msgParam.result.eventguid = result.eventguid
    end
    if result ~= nil and result.treasureid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.result == nil then
        msgParam.result = {}
      end
      msgParam.result.treasureid = result.treasureid
    end
    if result ~= nil and result.totalmember ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.result == nil then
        msgParam.result = {}
      end
      msgParam.result.totalmember = result.totalmember
    end
    if result ~= nil and result.state ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.result == nil then
        msgParam.result = {}
      end
      msgParam.result.state = result.state
    end
    if result ~= nil and result.items ~= nil then
      if msgParam.result == nil then
        msgParam.result = {}
      end
      if msgParam.result.items == nil then
        msgParam.result.items = {}
      end
      for i = 1, #result.items do
        table.insert(msgParam.result.items, result.items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallQueryGCityShowInfoGuildCmd(infos, groupid, query_type, friend_info)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.QueryGCityShowInfoGuildCmd()
    if infos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.infos == nil then
        msg.infos = {}
      end
      for i = 1, #infos do
        table.insert(msg.infos, infos[i])
      end
    end
    if groupid ~= nil then
      msg.groupid = groupid
    end
    if query_type ~= nil then
      msg.query_type = query_type
    end
    if friend_info ~= nil and friend_info.teamid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.friend_info == nil then
        msg.friend_info = {}
      end
      msg.friend_info.teamid = friend_info.teamid
    end
    if friend_info ~= nil and friend_info.is_team_leader ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.friend_info == nil then
        msg.friend_info = {}
      end
      msg.friend_info.is_team_leader = friend_info.is_team_leader
    end
    if friend_info ~= nil and friend_info.groupid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.friend_info == nil then
        msg.friend_info = {}
      end
      msg.friend_info.groupid = friend_info.groupid
    end
    if friend_info ~= nil and friend_info.is_group_leader ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.friend_info == nil then
        msg.friend_info = {}
      end
      msg.friend_info.is_group_leader = friend_info.is_group_leader
    end
    if friend_info ~= nil and friend_info.guildid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.friend_info == nil then
        msg.friend_info = {}
      end
      msg.friend_info.guildid = friend_info.guildid
    end
    if friend_info ~= nil and friend_info.is_guild_chairman ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.friend_info == nil then
        msg.friend_info = {}
      end
      msg.friend_info.is_guild_chairman = friend_info.is_guild_chairman
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryGCityShowInfoGuildCmd.id
    local msgParam = {}
    if infos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.infos == nil then
        msgParam.infos = {}
      end
      for i = 1, #infos do
        table.insert(msgParam.infos, infos[i])
      end
    end
    if groupid ~= nil then
      msgParam.groupid = groupid
    end
    if query_type ~= nil then
      msgParam.query_type = query_type
    end
    if friend_info ~= nil and friend_info.teamid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.friend_info == nil then
        msgParam.friend_info = {}
      end
      msgParam.friend_info.teamid = friend_info.teamid
    end
    if friend_info ~= nil and friend_info.is_team_leader ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.friend_info == nil then
        msgParam.friend_info = {}
      end
      msgParam.friend_info.is_team_leader = friend_info.is_team_leader
    end
    if friend_info ~= nil and friend_info.groupid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.friend_info == nil then
        msgParam.friend_info = {}
      end
      msgParam.friend_info.groupid = friend_info.groupid
    end
    if friend_info ~= nil and friend_info.is_group_leader ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.friend_info == nil then
        msgParam.friend_info = {}
      end
      msgParam.friend_info.is_group_leader = friend_info.is_group_leader
    end
    if friend_info ~= nil and friend_info.guildid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.friend_info == nil then
        msgParam.friend_info = {}
      end
      msgParam.friend_info.guildid = friend_info.guildid
    end
    if friend_info ~= nil and friend_info.is_guild_chairman ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.friend_info == nil then
        msgParam.friend_info = {}
      end
      msgParam.friend_info.is_guild_chairman = friend_info.is_guild_chairman
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallGvgOpenFireGuildCmd(fire, settle_time, start_time)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.GvgOpenFireGuildCmd()
    if fire ~= nil then
      msg.fire = fire
    end
    if settle_time ~= nil then
      msg.settle_time = settle_time
    end
    if start_time ~= nil then
      msg.start_time = start_time
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgOpenFireGuildCmd.id
    local msgParam = {}
    if fire ~= nil then
      msgParam.fire = fire
    end
    if settle_time ~= nil then
      msgParam.settle_time = settle_time
    end
    if start_time ~= nil then
      msgParam.start_time = start_time
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallEnterPunishTimeNtfGuildCmd(exittime)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.EnterPunishTimeNtfGuildCmd()
    if exittime ~= nil then
      msg.exittime = exittime
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EnterPunishTimeNtfGuildCmd.id
    local msgParam = {}
    if exittime ~= nil then
      msgParam.exittime = exittime
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallQuerySuperGvgDataGuildCmd(datas, end_flag)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.QuerySuperGvgDataGuildCmd()
    if datas ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.datas == nil then
        msg.datas = {}
      end
      for i = 1, #datas do
        table.insert(msg.datas, datas[i])
      end
    end
    if end_flag ~= nil then
      msg.end_flag = end_flag
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QuerySuperGvgDataGuildCmd.id
    local msgParam = {}
    if datas ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.datas == nil then
        msgParam.datas = {}
      end
      for i = 1, #datas do
        table.insert(msgParam.datas, datas[i])
      end
    end
    if end_flag ~= nil then
      msgParam.end_flag = end_flag
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallQueryGvgGuildInfoGuildCmd(guildid, level, memnum, guildname, leadername)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.QueryGvgGuildInfoGuildCmd()
    if msg == nil then
      msg = {}
    end
    msg.guildid = guildid
    if level ~= nil then
      msg.level = level
    end
    if memnum ~= nil then
      msg.memnum = memnum
    end
    if guildname ~= nil then
      msg.guildname = guildname
    end
    if leadername ~= nil then
      msg.leadername = leadername
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryGvgGuildInfoGuildCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.guildid = guildid
    if level ~= nil then
      msgParam.level = level
    end
    if memnum ~= nil then
      msgParam.memnum = memnum
    end
    if guildname ~= nil then
      msgParam.guildname = guildname
    end
    if leadername ~= nil then
      msgParam.leadername = leadername
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallGvgRewardNtfGuildCmd(has)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.GvgRewardNtfGuildCmd()
    if has ~= nil then
      msg.has = has
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgRewardNtfGuildCmd.id
    local msgParam = {}
    if has ~= nil then
      msgParam.has = has
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallGetGvgRewardGuildCmd()
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.GetGvgRewardGuildCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GetGvgRewardGuildCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallQueryCheckInfoGuildCmd(needlevel, recruit, applied, checked, mercenary)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.QueryCheckInfoGuildCmd()
    if needlevel ~= nil then
      msg.needlevel = needlevel
    end
    if recruit ~= nil then
      msg.recruit = recruit
    end
    if applied ~= nil then
      msg.applied = applied
    end
    if checked ~= nil then
      msg.checked = checked
    end
    if mercenary ~= nil then
      msg.mercenary = mercenary
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryCheckInfoGuildCmd.id
    local msgParam = {}
    if needlevel ~= nil then
      msgParam.needlevel = needlevel
    end
    if recruit ~= nil then
      msgParam.recruit = recruit
    end
    if applied ~= nil then
      msgParam.applied = applied
    end
    if checked ~= nil then
      msgParam.checked = checked
    end
    if mercenary ~= nil then
      msgParam.mercenary = mercenary
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallQueryBifrostRankGuildCmd(info)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.QueryBifrostRankGuildCmd()
    if info ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      for i = 1, #info do
        table.insert(msg.info, info[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryBifrostRankGuildCmd.id
    local msgParam = {}
    if info ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      for i = 1, #info do
        table.insert(msgParam.info, info[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallQueryMemberBifrostInfoGuildCmd(score, infos)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.QueryMemberBifrostInfoGuildCmd()
    if score ~= nil then
      msg.score = score
    end
    if infos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.infos == nil then
        msg.infos = {}
      end
      for i = 1, #infos do
        table.insert(msg.infos, infos[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryMemberBifrostInfoGuildCmd.id
    local msgParam = {}
    if score ~= nil then
      msgParam.score = score
    end
    if infos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.infos == nil then
        msgParam.infos = {}
      end
      for i = 1, #infos do
        table.insert(msgParam.infos, infos[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallQueryGuildInfoGuildCmd(guildid)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.QueryGuildInfoGuildCmd()
    if guildid ~= nil then
      msg.guildid = guildid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryGuildInfoGuildCmd.id
    local msgParam = {}
    if guildid ~= nil then
      msgParam.guildid = guildid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallQueryGvgZoneGroupGuildCCmd(season, begintime, count, infos, next_begintime, break_begintime, break_endtime)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.QueryGvgZoneGroupGuildCCmd()
    if season ~= nil then
      msg.season = season
    end
    if begintime ~= nil then
      msg.begintime = begintime
    end
    if count ~= nil then
      msg.count = count
    end
    if infos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.infos == nil then
        msg.infos = {}
      end
      for i = 1, #infos do
        table.insert(msg.infos, infos[i])
      end
    end
    if next_begintime ~= nil then
      msg.next_begintime = next_begintime
    end
    if break_begintime ~= nil then
      msg.break_begintime = break_begintime
    end
    if break_endtime ~= nil then
      msg.break_endtime = break_endtime
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryGvgZoneGroupGuildCCmd.id
    local msgParam = {}
    if season ~= nil then
      msgParam.season = season
    end
    if begintime ~= nil then
      msgParam.begintime = begintime
    end
    if count ~= nil then
      msgParam.count = count
    end
    if infos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.infos == nil then
        msgParam.infos = {}
      end
      for i = 1, #infos do
        table.insert(msgParam.infos, infos[i])
      end
    end
    if next_begintime ~= nil then
      msgParam.next_begintime = next_begintime
    end
    if break_begintime ~= nil then
      msgParam.break_begintime = break_begintime
    end
    if break_endtime ~= nil then
      msgParam.break_endtime = break_endtime
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallUpdateMapCityGuildCmd(infos, groupid)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.UpdateMapCityGuildCmd()
    if infos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.infos == nil then
        msg.infos = {}
      end
      for i = 1, #infos do
        table.insert(msg.infos, infos[i])
      end
    end
    if groupid ~= nil then
      msg.groupid = groupid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.UpdateMapCityGuildCmd.id
    local msgParam = {}
    if infos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.infos == nil then
        msgParam.infos = {}
      end
      for i = 1, #infos do
        table.insert(msgParam.infos, infos[i])
      end
    end
    if groupid ~= nil then
      msgParam.groupid = groupid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallGvgRankInfoQueryGuildCmd(page, selfguild)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.GvgRankInfoQueryGuildCmd()
    if page ~= nil then
      msg.page = page
    end
    if selfguild ~= nil then
      msg.selfguild = selfguild
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgRankInfoQueryGuildCmd.id
    local msgParam = {}
    if page ~= nil then
      msgParam.page = page
    end
    if selfguild ~= nil then
      msgParam.selfguild = selfguild
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallGvgRankInfoRetGuildCmd(page, infos, selfinfo)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.GvgRankInfoRetGuildCmd()
    if page ~= nil then
      msg.page = page
    end
    if infos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.infos == nil then
        msg.infos = {}
      end
      for i = 1, #infos do
        table.insert(msg.infos, infos[i])
      end
    end
    if selfinfo ~= nil and selfinfo.guildid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.selfinfo == nil then
        msg.selfinfo = {}
      end
      msg.selfinfo.guildid = selfinfo.guildid
    end
    if selfinfo ~= nil and selfinfo.rank ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.selfinfo == nil then
        msg.selfinfo = {}
      end
      msg.selfinfo.rank = selfinfo.rank
    end
    if selfinfo.guildinfo ~= nil and selfinfo.guildinfo.guildid ~= nil then
      if msg.selfinfo == nil then
        msg.selfinfo = {}
      end
      if msg.selfinfo.guildinfo == nil then
        msg.selfinfo.guildinfo = {}
      end
      msg.selfinfo.guildinfo.guildid = selfinfo.guildinfo.guildid
    end
    if selfinfo.guildinfo ~= nil and selfinfo.guildinfo.name ~= nil then
      if msg.selfinfo == nil then
        msg.selfinfo = {}
      end
      if msg.selfinfo.guildinfo == nil then
        msg.selfinfo.guildinfo = {}
      end
      msg.selfinfo.guildinfo.name = selfinfo.guildinfo.name
    end
    if selfinfo.guildinfo ~= nil and selfinfo.guildinfo.portrait ~= nil then
      if msg.selfinfo == nil then
        msg.selfinfo = {}
      end
      if msg.selfinfo.guildinfo == nil then
        msg.selfinfo.guildinfo = {}
      end
      msg.selfinfo.guildinfo.portrait = selfinfo.guildinfo.portrait
    end
    if selfinfo.guildinfo ~= nil and selfinfo.guildinfo.leaderid ~= nil then
      if msg.selfinfo == nil then
        msg.selfinfo = {}
      end
      if msg.selfinfo.guildinfo == nil then
        msg.selfinfo.guildinfo = {}
      end
      msg.selfinfo.guildinfo.leaderid = selfinfo.guildinfo.leaderid
    end
    if selfinfo.guildinfo ~= nil and selfinfo.guildinfo.leadername ~= nil then
      if msg.selfinfo == nil then
        msg.selfinfo = {}
      end
      if msg.selfinfo.guildinfo == nil then
        msg.selfinfo.guildinfo = {}
      end
      msg.selfinfo.guildinfo.leadername = selfinfo.guildinfo.leadername
    end
    if selfinfo.guildinfo ~= nil and selfinfo.guildinfo.zoneid ~= nil then
      if msg.selfinfo == nil then
        msg.selfinfo = {}
      end
      if msg.selfinfo.guildinfo == nil then
        msg.selfinfo.guildinfo = {}
      end
      msg.selfinfo.guildinfo.zoneid = selfinfo.guildinfo.zoneid
    end
    if selfinfo.guildinfo ~= nil and selfinfo.guildinfo.gvg_group ~= nil then
      if msg.selfinfo == nil then
        msg.selfinfo = {}
      end
      if msg.selfinfo.guildinfo == nil then
        msg.selfinfo.guildinfo = {}
      end
      msg.selfinfo.guildinfo.gvg_group = selfinfo.guildinfo.gvg_group
    end
    if selfinfo.guildinfo ~= nil and selfinfo.guildinfo.serverid ~= nil then
      if msg.selfinfo == nil then
        msg.selfinfo = {}
      end
      if msg.selfinfo.guildinfo == nil then
        msg.selfinfo.guildinfo = {}
      end
      msg.selfinfo.guildinfo.serverid = selfinfo.guildinfo.serverid
    end
    if selfinfo ~= nil and selfinfo.details ~= nil then
      if msg.selfinfo == nil then
        msg.selfinfo = {}
      end
      if msg.selfinfo.details == nil then
        msg.selfinfo.details = {}
      end
      for i = 1, #selfinfo.details do
        table.insert(msg.selfinfo.details, selfinfo.details[i])
      end
    end
    if selfinfo ~= nil and selfinfo.score ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.selfinfo == nil then
        msg.selfinfo = {}
      end
      msg.selfinfo.score = selfinfo.score
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgRankInfoRetGuildCmd.id
    local msgParam = {}
    if page ~= nil then
      msgParam.page = page
    end
    if infos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.infos == nil then
        msgParam.infos = {}
      end
      for i = 1, #infos do
        table.insert(msgParam.infos, infos[i])
      end
    end
    if selfinfo ~= nil and selfinfo.guildid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.selfinfo == nil then
        msgParam.selfinfo = {}
      end
      msgParam.selfinfo.guildid = selfinfo.guildid
    end
    if selfinfo ~= nil and selfinfo.rank ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.selfinfo == nil then
        msgParam.selfinfo = {}
      end
      msgParam.selfinfo.rank = selfinfo.rank
    end
    if selfinfo.guildinfo ~= nil and selfinfo.guildinfo.guildid ~= nil then
      if msgParam.selfinfo == nil then
        msgParam.selfinfo = {}
      end
      if msgParam.selfinfo.guildinfo == nil then
        msgParam.selfinfo.guildinfo = {}
      end
      msgParam.selfinfo.guildinfo.guildid = selfinfo.guildinfo.guildid
    end
    if selfinfo.guildinfo ~= nil and selfinfo.guildinfo.name ~= nil then
      if msgParam.selfinfo == nil then
        msgParam.selfinfo = {}
      end
      if msgParam.selfinfo.guildinfo == nil then
        msgParam.selfinfo.guildinfo = {}
      end
      msgParam.selfinfo.guildinfo.name = selfinfo.guildinfo.name
    end
    if selfinfo.guildinfo ~= nil and selfinfo.guildinfo.portrait ~= nil then
      if msgParam.selfinfo == nil then
        msgParam.selfinfo = {}
      end
      if msgParam.selfinfo.guildinfo == nil then
        msgParam.selfinfo.guildinfo = {}
      end
      msgParam.selfinfo.guildinfo.portrait = selfinfo.guildinfo.portrait
    end
    if selfinfo.guildinfo ~= nil and selfinfo.guildinfo.leaderid ~= nil then
      if msgParam.selfinfo == nil then
        msgParam.selfinfo = {}
      end
      if msgParam.selfinfo.guildinfo == nil then
        msgParam.selfinfo.guildinfo = {}
      end
      msgParam.selfinfo.guildinfo.leaderid = selfinfo.guildinfo.leaderid
    end
    if selfinfo.guildinfo ~= nil and selfinfo.guildinfo.leadername ~= nil then
      if msgParam.selfinfo == nil then
        msgParam.selfinfo = {}
      end
      if msgParam.selfinfo.guildinfo == nil then
        msgParam.selfinfo.guildinfo = {}
      end
      msgParam.selfinfo.guildinfo.leadername = selfinfo.guildinfo.leadername
    end
    if selfinfo.guildinfo ~= nil and selfinfo.guildinfo.zoneid ~= nil then
      if msgParam.selfinfo == nil then
        msgParam.selfinfo = {}
      end
      if msgParam.selfinfo.guildinfo == nil then
        msgParam.selfinfo.guildinfo = {}
      end
      msgParam.selfinfo.guildinfo.zoneid = selfinfo.guildinfo.zoneid
    end
    if selfinfo.guildinfo ~= nil and selfinfo.guildinfo.gvg_group ~= nil then
      if msgParam.selfinfo == nil then
        msgParam.selfinfo = {}
      end
      if msgParam.selfinfo.guildinfo == nil then
        msgParam.selfinfo.guildinfo = {}
      end
      msgParam.selfinfo.guildinfo.gvg_group = selfinfo.guildinfo.gvg_group
    end
    if selfinfo.guildinfo ~= nil and selfinfo.guildinfo.serverid ~= nil then
      if msgParam.selfinfo == nil then
        msgParam.selfinfo = {}
      end
      if msgParam.selfinfo.guildinfo == nil then
        msgParam.selfinfo.guildinfo = {}
      end
      msgParam.selfinfo.guildinfo.serverid = selfinfo.guildinfo.serverid
    end
    if selfinfo ~= nil and selfinfo.details ~= nil then
      if msgParam.selfinfo == nil then
        msgParam.selfinfo = {}
      end
      if msgParam.selfinfo.details == nil then
        msgParam.selfinfo.details = {}
      end
      for i = 1, #selfinfo.details do
        table.insert(msgParam.selfinfo.details, selfinfo.details[i])
      end
    end
    if selfinfo ~= nil and selfinfo.score ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.selfinfo == nil then
        msgParam.selfinfo = {}
      end
      msgParam.selfinfo.score = selfinfo.score
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallGvgRankHistroyQueryGuildCmd()
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.GvgRankHistroyQueryGuildCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgRankHistroyQueryGuildCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallGvgRankHistroyRetGuildCmd(history_infos)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.GvgRankHistroyRetGuildCmd()
    if history_infos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.history_infos == nil then
        msg.history_infos = {}
      end
      for i = 1, #history_infos do
        table.insert(msg.history_infos, history_infos[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgRankHistroyRetGuildCmd.id
    local msgParam = {}
    if history_infos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.history_infos == nil then
        msgParam.history_infos = {}
      end
      for i = 1, #history_infos do
        table.insert(msgParam.history_infos, history_infos[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallGvgSmallMetalCntGuildCmd(guildid, count)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.GvgSmallMetalCntGuildCmd()
    if guildid ~= nil then
      msg.guildid = guildid
    end
    if count ~= nil then
      msg.count = count
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgSmallMetalCntGuildCmd.id
    local msgParam = {}
    if guildid ~= nil then
      msgParam.guildid = guildid
    end
    if count ~= nil then
      msgParam.count = count
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallGvgTaskUpdateGuildCmd(tasks, guildid)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.GvgTaskUpdateGuildCmd()
    if tasks ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.tasks == nil then
        msg.tasks = {}
      end
      for i = 1, #tasks do
        table.insert(msg.tasks, tasks[i])
      end
    end
    if guildid ~= nil then
      msg.guildid = guildid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgTaskUpdateGuildCmd.id
    local msgParam = {}
    if tasks ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.tasks == nil then
        msgParam.tasks = {}
      end
      for i = 1, #tasks do
        table.insert(msgParam.tasks, tasks[i])
      end
    end
    if guildid ~= nil then
      msgParam.guildid = guildid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallGvgStatueSyncGuildCmd(appearance, pose, season, serverid, prefire)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.GvgStatueSyncGuildCmd()
    if appearance ~= nil and appearance.body ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.appearance == nil then
        msg.appearance = {}
      end
      msg.appearance.body = appearance.body
    end
    if appearance ~= nil and appearance.hair ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.appearance == nil then
        msg.appearance = {}
      end
      msg.appearance.hair = appearance.hair
    end
    if appearance ~= nil and appearance.head ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.appearance == nil then
        msg.appearance = {}
      end
      msg.appearance.head = appearance.head
    end
    if appearance ~= nil and appearance.face ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.appearance == nil then
        msg.appearance = {}
      end
      msg.appearance.face = appearance.face
    end
    if appearance ~= nil and appearance.eye ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.appearance == nil then
        msg.appearance = {}
      end
      msg.appearance.eye = appearance.eye
    end
    if appearance ~= nil and appearance.mouth ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.appearance == nil then
        msg.appearance = {}
      end
      msg.appearance.mouth = appearance.mouth
    end
    if appearance ~= nil and appearance.guildname ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.appearance == nil then
        msg.appearance = {}
      end
      msg.appearance.guildname = appearance.guildname
    end
    if appearance ~= nil and appearance.leadername ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.appearance == nil then
        msg.appearance = {}
      end
      msg.appearance.leadername = appearance.leadername
    end
    if appearance ~= nil and appearance.leaderid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.appearance == nil then
        msg.appearance = {}
      end
      msg.appearance.leaderid = appearance.leaderid
    end
    if appearance ~= nil and appearance.back ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.appearance == nil then
        msg.appearance = {}
      end
      msg.appearance.back = appearance.back
    end
    if appearance ~= nil and appearance.tail ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.appearance == nil then
        msg.appearance = {}
      end
      msg.appearance.tail = appearance.tail
    end
    if appearance ~= nil and appearance.pose ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.appearance == nil then
        msg.appearance = {}
      end
      msg.appearance.pose = appearance.pose
    end
    if pose ~= nil then
      msg.pose = pose
    end
    if season ~= nil then
      msg.season = season
    end
    if serverid ~= nil then
      msg.serverid = serverid
    end
    if prefire ~= nil then
      msg.prefire = prefire
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgStatueSyncGuildCmd.id
    local msgParam = {}
    if appearance ~= nil and appearance.body ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.appearance == nil then
        msgParam.appearance = {}
      end
      msgParam.appearance.body = appearance.body
    end
    if appearance ~= nil and appearance.hair ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.appearance == nil then
        msgParam.appearance = {}
      end
      msgParam.appearance.hair = appearance.hair
    end
    if appearance ~= nil and appearance.head ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.appearance == nil then
        msgParam.appearance = {}
      end
      msgParam.appearance.head = appearance.head
    end
    if appearance ~= nil and appearance.face ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.appearance == nil then
        msgParam.appearance = {}
      end
      msgParam.appearance.face = appearance.face
    end
    if appearance ~= nil and appearance.eye ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.appearance == nil then
        msgParam.appearance = {}
      end
      msgParam.appearance.eye = appearance.eye
    end
    if appearance ~= nil and appearance.mouth ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.appearance == nil then
        msgParam.appearance = {}
      end
      msgParam.appearance.mouth = appearance.mouth
    end
    if appearance ~= nil and appearance.guildname ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.appearance == nil then
        msgParam.appearance = {}
      end
      msgParam.appearance.guildname = appearance.guildname
    end
    if appearance ~= nil and appearance.leadername ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.appearance == nil then
        msgParam.appearance = {}
      end
      msgParam.appearance.leadername = appearance.leadername
    end
    if appearance ~= nil and appearance.leaderid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.appearance == nil then
        msgParam.appearance = {}
      end
      msgParam.appearance.leaderid = appearance.leaderid
    end
    if appearance ~= nil and appearance.back ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.appearance == nil then
        msgParam.appearance = {}
      end
      msgParam.appearance.back = appearance.back
    end
    if appearance ~= nil and appearance.tail ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.appearance == nil then
        msgParam.appearance = {}
      end
      msgParam.appearance.tail = appearance.tail
    end
    if appearance ~= nil and appearance.pose ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.appearance == nil then
        msgParam.appearance = {}
      end
      msgParam.appearance.pose = appearance.pose
    end
    if pose ~= nil then
      msgParam.pose = pose
    end
    if season ~= nil then
      msgParam.season = season
    end
    if serverid ~= nil then
      msgParam.serverid = serverid
    end
    if prefire ~= nil then
      msgParam.prefire = prefire
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallGvgCookingCmd(opt, eat)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.GvgCookingCmd()
    if opt ~= nil then
      msg.opt = opt
    end
    if eat ~= nil then
      msg.eat = eat
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgCookingCmd.id
    local msgParam = {}
    if opt ~= nil then
      msgParam.opt = opt
    end
    if eat ~= nil then
      msgParam.eat = eat
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallGvgCookingUpdateCmd(info, log)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.GvgCookingUpdateCmd()
    if info ~= nil and info.ingredients ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.ingredients = info.ingredients
    end
    if info ~= nil and info.heat ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.heat = info.heat
    end
    if info ~= nil and info.seasoning ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.seasoning = info.seasoning
    end
    if info ~= nil and info.ingreditem ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.ingreditem = info.ingreditem
    end
    if info ~= nil and info.maxstar ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.maxstar = info.maxstar
    end
    if log ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.log == nil then
        msg.log = {}
      end
      for i = 1, #log do
        table.insert(msg.log, log[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgCookingUpdateCmd.id
    local msgParam = {}
    if info ~= nil and info.ingredients ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.ingredients = info.ingredients
    end
    if info ~= nil and info.heat ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.heat = info.heat
    end
    if info ~= nil and info.seasoning ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.seasoning = info.seasoning
    end
    if info ~= nil and info.ingreditem ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.ingreditem = info.ingreditem
    end
    if info ~= nil and info.maxstar ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.maxstar = info.maxstar
    end
    if log ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.log == nil then
        msgParam.log = {}
      end
      for i = 1, #log do
        table.insert(msgParam.log, log[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallGvgScoreInfoUpdateGuildCmd(info)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.GvgScoreInfoUpdateGuildCmd()
    if info ~= nil and info.precityid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.precityid = info.precityid
    end
    if info ~= nil and info.defense_score ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.defense_score = info.defense_score
    end
    if info ~= nil and info.attack_score ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.attack_score = info.attack_score
    end
    if info ~= nil and info.perfect_score ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.perfect_score = info.perfect_score
    end
    if info ~= nil and info.defensecitys ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.defensecitys == nil then
        msg.info.defensecitys = {}
      end
      for i = 1, #info.defensecitys do
        table.insert(msg.info.defensecitys, info.defensecitys[i])
      end
    end
    if info ~= nil and info.lose_points ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.lose_points == nil then
        msg.info.lose_points = {}
      end
      for i = 1, #info.lose_points do
        table.insert(msg.info.lose_points, info.lose_points[i])
      end
    end
    if info ~= nil and info.mvp_score ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.mvp_score = info.mvp_score
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgScoreInfoUpdateGuildCmd.id
    local msgParam = {}
    if info ~= nil and info.precityid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.precityid = info.precityid
    end
    if info ~= nil and info.defense_score ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.defense_score = info.defense_score
    end
    if info ~= nil and info.attack_score ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.attack_score = info.attack_score
    end
    if info ~= nil and info.perfect_score ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.perfect_score = info.perfect_score
    end
    if info ~= nil and info.defensecitys ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.defensecitys == nil then
        msgParam.info.defensecitys = {}
      end
      for i = 1, #info.defensecitys do
        table.insert(msgParam.info.defensecitys, info.defensecitys[i])
      end
    end
    if info ~= nil and info.lose_points ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.lose_points == nil then
        msgParam.info.lose_points = {}
      end
      for i = 1, #info.lose_points do
        table.insert(msgParam.info.lose_points, info.lose_points[i])
      end
    end
    if info ~= nil and info.mvp_score ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.mvp_score = info.mvp_score
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallGvgSettleReqGuildCmd(guildinfo)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.GvgSettleReqGuildCmd()
    if guildinfo ~= nil and guildinfo.guildid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.guildinfo == nil then
        msg.guildinfo = {}
      end
      msg.guildinfo.guildid = guildinfo.guildid
    end
    if guildinfo ~= nil and guildinfo.guildzone ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.guildinfo == nil then
        msg.guildinfo = {}
      end
      msg.guildinfo.guildzone = guildinfo.guildzone
    end
    if guildinfo ~= nil and guildinfo.groupid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.guildinfo == nil then
        msg.guildinfo = {}
      end
      msg.guildinfo.groupid = guildinfo.groupid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgSettleReqGuildCmd.id
    local msgParam = {}
    if guildinfo ~= nil and guildinfo.guildid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.guildinfo == nil then
        msgParam.guildinfo = {}
      end
      msgParam.guildinfo.guildid = guildinfo.guildid
    end
    if guildinfo ~= nil and guildinfo.guildzone ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.guildinfo == nil then
        msgParam.guildinfo = {}
      end
      msgParam.guildinfo.guildzone = guildinfo.guildzone
    end
    if guildinfo ~= nil and guildinfo.groupid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.guildinfo == nil then
        msgParam.guildinfo = {}
      end
      msgParam.guildinfo.groupid = guildinfo.groupid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallGvgSettleInfoGuildCmd(info)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.GvgSettleInfoGuildCmd()
    if info ~= nil and info.finish ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.finish = info.finish
    end
    if info ~= nil and info.wait_select_citys ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.wait_select_citys == nil then
        msg.info.wait_select_citys = {}
      end
      for i = 1, #info.wait_select_citys do
        table.insert(msg.info.wait_select_citys, info.wait_select_citys[i])
      end
    end
    if info ~= nil and info.wait_option_city ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.wait_option_city = info.wait_option_city
    end
    if info ~= nil and info.last_city ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.last_city = info.last_city
    end
    if info.last_city_owner ~= nil and info.last_city_owner.guildid ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.last_city_owner == nil then
        msg.info.last_city_owner = {}
      end
      msg.info.last_city_owner.guildid = info.last_city_owner.guildid
    end
    if info.last_city_owner ~= nil and info.last_city_owner.name ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.last_city_owner == nil then
        msg.info.last_city_owner = {}
      end
      msg.info.last_city_owner.name = info.last_city_owner.name
    end
    if info.last_city_owner ~= nil and info.last_city_owner.portrait ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.last_city_owner == nil then
        msg.info.last_city_owner = {}
      end
      msg.info.last_city_owner.portrait = info.last_city_owner.portrait
    end
    if info.last_city_owner ~= nil and info.last_city_owner.leaderid ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.last_city_owner == nil then
        msg.info.last_city_owner = {}
      end
      msg.info.last_city_owner.leaderid = info.last_city_owner.leaderid
    end
    if info.last_city_owner ~= nil and info.last_city_owner.leadername ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.last_city_owner == nil then
        msg.info.last_city_owner = {}
      end
      msg.info.last_city_owner.leadername = info.last_city_owner.leadername
    end
    if info.last_city_owner ~= nil and info.last_city_owner.zoneid ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.last_city_owner == nil then
        msg.info.last_city_owner = {}
      end
      msg.info.last_city_owner.zoneid = info.last_city_owner.zoneid
    end
    if info.last_city_owner ~= nil and info.last_city_owner.gvg_group ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.last_city_owner == nil then
        msg.info.last_city_owner = {}
      end
      msg.info.last_city_owner.gvg_group = info.last_city_owner.gvg_group
    end
    if info.last_city_owner ~= nil and info.last_city_owner.serverid ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.last_city_owner == nil then
        msg.info.last_city_owner = {}
      end
      msg.info.last_city_owner.serverid = info.last_city_owner.serverid
    end
    if info ~= nil and info.prepare_citys ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.prepare_citys == nil then
        msg.info.prepare_citys = {}
      end
      for i = 1, #info.prepare_citys do
        table.insert(msg.info.prepare_citys, info.prepare_citys[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgSettleInfoGuildCmd.id
    local msgParam = {}
    if info ~= nil and info.finish ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.finish = info.finish
    end
    if info ~= nil and info.wait_select_citys ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.wait_select_citys == nil then
        msgParam.info.wait_select_citys = {}
      end
      for i = 1, #info.wait_select_citys do
        table.insert(msgParam.info.wait_select_citys, info.wait_select_citys[i])
      end
    end
    if info ~= nil and info.wait_option_city ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.wait_option_city = info.wait_option_city
    end
    if info ~= nil and info.last_city ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.last_city = info.last_city
    end
    if info.last_city_owner ~= nil and info.last_city_owner.guildid ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.last_city_owner == nil then
        msgParam.info.last_city_owner = {}
      end
      msgParam.info.last_city_owner.guildid = info.last_city_owner.guildid
    end
    if info.last_city_owner ~= nil and info.last_city_owner.name ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.last_city_owner == nil then
        msgParam.info.last_city_owner = {}
      end
      msgParam.info.last_city_owner.name = info.last_city_owner.name
    end
    if info.last_city_owner ~= nil and info.last_city_owner.portrait ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.last_city_owner == nil then
        msgParam.info.last_city_owner = {}
      end
      msgParam.info.last_city_owner.portrait = info.last_city_owner.portrait
    end
    if info.last_city_owner ~= nil and info.last_city_owner.leaderid ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.last_city_owner == nil then
        msgParam.info.last_city_owner = {}
      end
      msgParam.info.last_city_owner.leaderid = info.last_city_owner.leaderid
    end
    if info.last_city_owner ~= nil and info.last_city_owner.leadername ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.last_city_owner == nil then
        msgParam.info.last_city_owner = {}
      end
      msgParam.info.last_city_owner.leadername = info.last_city_owner.leadername
    end
    if info.last_city_owner ~= nil and info.last_city_owner.zoneid ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.last_city_owner == nil then
        msgParam.info.last_city_owner = {}
      end
      msgParam.info.last_city_owner.zoneid = info.last_city_owner.zoneid
    end
    if info.last_city_owner ~= nil and info.last_city_owner.gvg_group ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.last_city_owner == nil then
        msgParam.info.last_city_owner = {}
      end
      msgParam.info.last_city_owner.gvg_group = info.last_city_owner.gvg_group
    end
    if info.last_city_owner ~= nil and info.last_city_owner.serverid ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.last_city_owner == nil then
        msgParam.info.last_city_owner = {}
      end
      msgParam.info.last_city_owner.serverid = info.last_city_owner.serverid
    end
    if info ~= nil and info.prepare_citys ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.prepare_citys == nil then
        msgParam.info.prepare_citys = {}
      end
      for i = 1, #info.prepare_citys do
        table.insert(msgParam.info.prepare_citys, info.prepare_citys[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallGvgSettleSelectGuildCmd(wait_option_city, occupy_city, guildinfo)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.GvgSettleSelectGuildCmd()
    if wait_option_city ~= nil then
      msg.wait_option_city = wait_option_city
    end
    if occupy_city ~= nil then
      msg.occupy_city = occupy_city
    end
    if guildinfo ~= nil and guildinfo.guildid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.guildinfo == nil then
        msg.guildinfo = {}
      end
      msg.guildinfo.guildid = guildinfo.guildid
    end
    if guildinfo ~= nil and guildinfo.guildzone ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.guildinfo == nil then
        msg.guildinfo = {}
      end
      msg.guildinfo.guildzone = guildinfo.guildzone
    end
    if guildinfo ~= nil and guildinfo.groupid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.guildinfo == nil then
        msg.guildinfo = {}
      end
      msg.guildinfo.groupid = guildinfo.groupid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgSettleSelectGuildCmd.id
    local msgParam = {}
    if wait_option_city ~= nil then
      msgParam.wait_option_city = wait_option_city
    end
    if occupy_city ~= nil then
      msgParam.occupy_city = occupy_city
    end
    if guildinfo ~= nil and guildinfo.guildid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.guildinfo == nil then
        msgParam.guildinfo = {}
      end
      msgParam.guildinfo.guildid = guildinfo.guildid
    end
    if guildinfo ~= nil and guildinfo.guildzone ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.guildinfo == nil then
        msgParam.guildinfo = {}
      end
      msgParam.guildinfo.guildzone = guildinfo.guildzone
    end
    if guildinfo ~= nil and guildinfo.groupid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.guildinfo == nil then
        msgParam.guildinfo = {}
      end
      msgParam.guildinfo.groupid = guildinfo.groupid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallGvgReqEnterCityGuildCmd(groupid, cityid)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.GvgReqEnterCityGuildCmd()
    if groupid ~= nil then
      msg.groupid = groupid
    end
    if cityid ~= nil then
      msg.cityid = cityid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgReqEnterCityGuildCmd.id
    local msgParam = {}
    if groupid ~= nil then
      msgParam.groupid = groupid
    end
    if cityid ~= nil then
      msgParam.cityid = cityid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallGvgFireReportGuildCmd(firetime, datas, mydata)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.GvgFireReportGuildCmd()
    if firetime ~= nil then
      msg.firetime = firetime
    end
    if datas ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.datas == nil then
        msg.datas = {}
      end
      for i = 1, #datas do
        table.insert(msg.datas, datas[i])
      end
    end
    if mydata ~= nil and mydata.charid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mydata == nil then
        msg.mydata = {}
      end
      msg.mydata.charid = mydata.charid
    end
    if mydata ~= nil and mydata.username ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mydata == nil then
        msg.mydata = {}
      end
      msg.mydata.username = mydata.username
    end
    if mydata ~= nil and mydata.profession ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mydata == nil then
        msg.mydata = {}
      end
      msg.mydata.profession = mydata.profession
    end
    if mydata ~= nil and mydata.killusernum ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mydata == nil then
        msg.mydata = {}
      end
      msg.mydata.killusernum = mydata.killusernum
    end
    if mydata ~= nil and mydata.dienum ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mydata == nil then
        msg.mydata = {}
      end
      msg.mydata.dienum = mydata.dienum
    end
    if mydata ~= nil and mydata.pointnum ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mydata == nil then
        msg.mydata = {}
      end
      msg.mydata.pointnum = mydata.pointnum
    end
    if mydata ~= nil and mydata.pointtime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mydata == nil then
        msg.mydata = {}
      end
      msg.mydata.pointtime = mydata.pointtime
    end
    if mydata ~= nil and mydata.healhp ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mydata == nil then
        msg.mydata = {}
      end
      msg.mydata.healhp = mydata.healhp
    end
    if mydata ~= nil and mydata.relivenum ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mydata == nil then
        msg.mydata = {}
      end
      msg.mydata.relivenum = mydata.relivenum
    end
    if mydata ~= nil and mydata.metaldamage ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mydata == nil then
        msg.mydata = {}
      end
      msg.mydata.metaldamage = mydata.metaldamage
    end
    if mydata ~= nil and mydata.helpnum ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mydata == nil then
        msg.mydata = {}
      end
      msg.mydata.helpnum = mydata.helpnum
    end
    if mydata ~= nil and mydata.expelnum ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mydata == nil then
        msg.mydata = {}
      end
      msg.mydata.expelnum = mydata.expelnum
    end
    if mydata ~= nil and mydata.damage ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mydata == nil then
        msg.mydata = {}
      end
      msg.mydata.damage = mydata.damage
    end
    if mydata ~= nil and mydata.mvp_damage ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mydata == nil then
        msg.mydata = {}
      end
      msg.mydata.mvp_damage = mydata.mvp_damage
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgFireReportGuildCmd.id
    local msgParam = {}
    if firetime ~= nil then
      msgParam.firetime = firetime
    end
    if datas ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.datas == nil then
        msgParam.datas = {}
      end
      for i = 1, #datas do
        table.insert(msgParam.datas, datas[i])
      end
    end
    if mydata ~= nil and mydata.charid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mydata == nil then
        msgParam.mydata = {}
      end
      msgParam.mydata.charid = mydata.charid
    end
    if mydata ~= nil and mydata.username ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mydata == nil then
        msgParam.mydata = {}
      end
      msgParam.mydata.username = mydata.username
    end
    if mydata ~= nil and mydata.profession ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mydata == nil then
        msgParam.mydata = {}
      end
      msgParam.mydata.profession = mydata.profession
    end
    if mydata ~= nil and mydata.killusernum ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mydata == nil then
        msgParam.mydata = {}
      end
      msgParam.mydata.killusernum = mydata.killusernum
    end
    if mydata ~= nil and mydata.dienum ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mydata == nil then
        msgParam.mydata = {}
      end
      msgParam.mydata.dienum = mydata.dienum
    end
    if mydata ~= nil and mydata.pointnum ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mydata == nil then
        msgParam.mydata = {}
      end
      msgParam.mydata.pointnum = mydata.pointnum
    end
    if mydata ~= nil and mydata.pointtime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mydata == nil then
        msgParam.mydata = {}
      end
      msgParam.mydata.pointtime = mydata.pointtime
    end
    if mydata ~= nil and mydata.healhp ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mydata == nil then
        msgParam.mydata = {}
      end
      msgParam.mydata.healhp = mydata.healhp
    end
    if mydata ~= nil and mydata.relivenum ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mydata == nil then
        msgParam.mydata = {}
      end
      msgParam.mydata.relivenum = mydata.relivenum
    end
    if mydata ~= nil and mydata.metaldamage ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mydata == nil then
        msgParam.mydata = {}
      end
      msgParam.mydata.metaldamage = mydata.metaldamage
    end
    if mydata ~= nil and mydata.helpnum ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mydata == nil then
        msgParam.mydata = {}
      end
      msgParam.mydata.helpnum = mydata.helpnum
    end
    if mydata ~= nil and mydata.expelnum ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mydata == nil then
        msgParam.mydata = {}
      end
      msgParam.mydata.expelnum = mydata.expelnum
    end
    if mydata ~= nil and mydata.damage ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mydata == nil then
        msgParam.mydata = {}
      end
      msgParam.mydata.damage = mydata.damage
    end
    if mydata ~= nil and mydata.mvp_damage ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mydata == nil then
        msgParam.mydata = {}
      end
      msgParam.mydata.mvp_damage = mydata.mvp_damage
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallBuildingUpdateNtfGuildCmd(updates)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.BuildingUpdateNtfGuildCmd()
    if updates ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.updates == nil then
        msg.updates = {}
      end
      for i = 1, #updates do
        table.insert(msg.updates, updates[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BuildingUpdateNtfGuildCmd.id
    local msgParam = {}
    if updates ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.updates == nil then
        msgParam.updates = {}
      end
      for i = 1, #updates do
        table.insert(msgParam.updates, updates[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallGvgRoadblockModifyGuildCmd(roadblock, ret, guildid)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.GvgRoadblockModifyGuildCmd()
    if roadblock ~= nil then
      msg.roadblock = roadblock
    end
    if ret ~= nil then
      msg.ret = ret
    end
    if guildid ~= nil then
      msg.guildid = guildid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgRoadblockModifyGuildCmd.id
    local msgParam = {}
    if roadblock ~= nil then
      msgParam.roadblock = roadblock
    end
    if ret ~= nil then
      msgParam.ret = ret
    end
    if guildid ~= nil then
      msgParam.guildid = guildid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallGvgRoadblockQueryGuildCmd(roadblock, guildid)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.GvgRoadblockQueryGuildCmd()
    if roadblock ~= nil then
      msg.roadblock = roadblock
    end
    if guildid ~= nil then
      msg.guildid = guildid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgRoadblockQueryGuildCmd.id
    local msgParam = {}
    if roadblock ~= nil then
      msgParam.roadblock = roadblock
    end
    if guildid ~= nil then
      msgParam.guildid = guildid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallExchangeGvgGroupGuildCmd(gvg_group, cancel)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.ExchangeGvgGroupGuildCmd()
    if gvg_group ~= nil then
      msg.gvg_group = gvg_group
    end
    if cancel ~= nil then
      msg.cancel = cancel
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ExchangeGvgGroupGuildCmd.id
    local msgParam = {}
    if gvg_group ~= nil then
      msgParam.gvg_group = gvg_group
    end
    if cancel ~= nil then
      msgParam.cancel = cancel
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallGvgDataQueryGuildCmd()
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.GvgDataQueryGuildCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgDataQueryGuildCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallDateBattleInfoGuildCmd(id, datas)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.DateBattleInfoGuildCmd()
    if id ~= nil then
      msg.id = id
    end
    if datas ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.datas == nil then
        msg.datas = {}
      end
      for i = 1, #datas do
        table.insert(msg.datas, datas[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DateBattleInfoGuildCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if datas ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.datas == nil then
        msgParam.datas = {}
      end
      for i = 1, #datas do
        table.insert(msgParam.datas, datas[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallDateBattleTargetGuildCmd(guildid, datas)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.DateBattleTargetGuildCmd()
    if guildid ~= nil then
      msg.guildid = guildid
    end
    if datas ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.datas == nil then
        msg.datas = {}
      end
      for i = 1, #datas do
        table.insert(msg.datas, datas[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DateBattleTargetGuildCmd.id
    local msgParam = {}
    if guildid ~= nil then
      msgParam.guildid = guildid
    end
    if datas ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.datas == nil then
        msgParam.datas = {}
      end
      for i = 1, #datas do
        table.insert(msgParam.datas, datas[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallDateBattleInviteGuildCmd(guildid, starttime, mode, datas, info)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.DateBattleInviteGuildCmd()
    if guildid ~= nil then
      msg.guildid = guildid
    end
    if starttime ~= nil then
      msg.starttime = starttime
    end
    if mode ~= nil then
      msg.mode = mode
    end
    if datas ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.datas == nil then
        msg.datas = {}
      end
      for i = 1, #datas do
        table.insert(msg.datas, datas[i])
      end
    end
    if info ~= nil and info.type ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.type = info.type
    end
    if info ~= nil and info.target_num ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.target_num = info.target_num
    end
    if info ~= nil and info.cardids ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.cardids == nil then
        msg.info.cardids = {}
      end
      for i = 1, #info.cardids do
        table.insert(msg.info.cardids, info.cardids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DateBattleInviteGuildCmd.id
    local msgParam = {}
    if guildid ~= nil then
      msgParam.guildid = guildid
    end
    if starttime ~= nil then
      msgParam.starttime = starttime
    end
    if mode ~= nil then
      msgParam.mode = mode
    end
    if datas ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.datas == nil then
        msgParam.datas = {}
      end
      for i = 1, #datas do
        table.insert(msgParam.datas, datas[i])
      end
    end
    if info ~= nil and info.type ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.type = info.type
    end
    if info ~= nil and info.target_num ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.target_num = info.target_num
    end
    if info ~= nil and info.cardids ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.cardids == nil then
        msgParam.info.cardids = {}
      end
      for i = 1, #info.cardids do
        table.insert(msgParam.info.cardids, info.cardids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallDateBattleReplyGuildCmd(id, isagree, datas)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.DateBattleReplyGuildCmd()
    if id ~= nil then
      msg.id = id
    end
    if isagree ~= nil then
      msg.isagree = isagree
    end
    if datas ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.datas == nil then
        msg.datas = {}
      end
      for i = 1, #datas do
        table.insert(msg.datas, datas[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DateBattleReplyGuildCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if isagree ~= nil then
      msgParam.isagree = isagree
    end
    if datas ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.datas == nil then
        msgParam.datas = {}
      end
      for i = 1, #datas do
        table.insert(msgParam.datas, datas[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallDateBattleOpenGuildCmd(state, data)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.DateBattleOpenGuildCmd()
    if state ~= nil then
      msg.state = state
    end
    if data ~= nil and data.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.id = data.id
    end
    if data ~= nil and data.atk_guildid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.atk_guildid = data.atk_guildid
    end
    if data ~= nil and data.atk_guildname ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.atk_guildname = data.atk_guildname
    end
    if data ~= nil and data.atk_guildportrait ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.atk_guildportrait = data.atk_guildportrait
    end
    if data ~= nil and data.atk_serverid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.atk_serverid = data.atk_serverid
    end
    if data ~= nil and data.atk_chairmanid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.atk_chairmanid = data.atk_chairmanid
    end
    if data ~= nil and data.def_guildid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.def_guildid = data.def_guildid
    end
    if data ~= nil and data.def_guildname ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.def_guildname = data.def_guildname
    end
    if data ~= nil and data.def_guildportrait ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.def_guildportrait = data.def_guildportrait
    end
    if data ~= nil and data.def_serverid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.def_serverid = data.def_serverid
    end
    if data ~= nil and data.def_chairmanid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.def_chairmanid = data.def_chairmanid
    end
    if data ~= nil and data.battle_starttime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.battle_starttime = data.battle_starttime
    end
    if data ~= nil and data.invite_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.invite_time = data.invite_time
    end
    if data ~= nil and data.mode ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.mode = data.mode
    end
    if data ~= nil and data.state ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.state = data.state
    end
    if data ~= nil and data.winner_guildid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      msg.data.winner_guildid = data.winner_guildid
    end
    if data.info ~= nil and data.info.type ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.info == nil then
        msg.data.info = {}
      end
      msg.data.info.type = data.info.type
    end
    if data.info ~= nil and data.info.target_num ~= nil then
      if msg.data == nil then
        msg.data = {}
      end
      if msg.data.info == nil then
        msg.data.info = {}
      end
      msg.data.info.target_num = data.info.target_num
    end
    if data ~= nil and data.info.cardids ~= nil then
      if msg.data.info == nil then
        msg.data.info = {}
      end
      if msg.data.info.cardids == nil then
        msg.data.info.cardids = {}
      end
      for i = 1, #data.info.cardids do
        table.insert(msg.data.info.cardids, data.info.cardids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DateBattleOpenGuildCmd.id
    local msgParam = {}
    if state ~= nil then
      msgParam.state = state
    end
    if data ~= nil and data.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.id = data.id
    end
    if data ~= nil and data.atk_guildid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.atk_guildid = data.atk_guildid
    end
    if data ~= nil and data.atk_guildname ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.atk_guildname = data.atk_guildname
    end
    if data ~= nil and data.atk_guildportrait ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.atk_guildportrait = data.atk_guildportrait
    end
    if data ~= nil and data.atk_serverid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.atk_serverid = data.atk_serverid
    end
    if data ~= nil and data.atk_chairmanid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.atk_chairmanid = data.atk_chairmanid
    end
    if data ~= nil and data.def_guildid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.def_guildid = data.def_guildid
    end
    if data ~= nil and data.def_guildname ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.def_guildname = data.def_guildname
    end
    if data ~= nil and data.def_guildportrait ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.def_guildportrait = data.def_guildportrait
    end
    if data ~= nil and data.def_serverid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.def_serverid = data.def_serverid
    end
    if data ~= nil and data.def_chairmanid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.def_chairmanid = data.def_chairmanid
    end
    if data ~= nil and data.battle_starttime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.battle_starttime = data.battle_starttime
    end
    if data ~= nil and data.invite_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.invite_time = data.invite_time
    end
    if data ~= nil and data.mode ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.mode = data.mode
    end
    if data ~= nil and data.state ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.state = data.state
    end
    if data ~= nil and data.winner_guildid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      msgParam.data.winner_guildid = data.winner_guildid
    end
    if data.info ~= nil and data.info.type ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.info == nil then
        msgParam.data.info = {}
      end
      msgParam.data.info.type = data.info.type
    end
    if data.info ~= nil and data.info.target_num ~= nil then
      if msgParam.data == nil then
        msgParam.data = {}
      end
      if msgParam.data.info == nil then
        msgParam.data.info = {}
      end
      msgParam.data.info.target_num = data.info.target_num
    end
    if data ~= nil and data.info.cardids ~= nil then
      if msgParam.data.info == nil then
        msgParam.data.info = {}
      end
      if msgParam.data.info.cardids == nil then
        msgParam.data.info.cardids = {}
      end
      for i = 1, #data.info.cardids do
        table.insert(msgParam.data.info.cardids, data.info.cardids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallDateBattleEnterGuildCmd(id)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.DateBattleEnterGuildCmd()
    if id ~= nil then
      msg.id = id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DateBattleEnterGuildCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallDateBattleReportGuildCmd(atk_member_count, def_member_count, boss_hp, perfect_time, death_count, atk_kill_count, def_kill_count)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.DateBattleReportGuildCmd()
    if atk_member_count ~= nil then
      msg.atk_member_count = atk_member_count
    end
    if def_member_count ~= nil then
      msg.def_member_count = def_member_count
    end
    if boss_hp ~= nil then
      msg.boss_hp = boss_hp
    end
    if perfect_time ~= nil and perfect_time.pause ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.perfect_time == nil then
        msg.perfect_time = {}
      end
      msg.perfect_time.pause = perfect_time.pause
    end
    if perfect_time ~= nil and perfect_time.time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.perfect_time == nil then
        msg.perfect_time = {}
      end
      msg.perfect_time.time = perfect_time.time
    end
    if death_count ~= nil then
      msg.death_count = death_count
    end
    if atk_kill_count ~= nil then
      msg.atk_kill_count = atk_kill_count
    end
    if def_kill_count ~= nil then
      msg.def_kill_count = def_kill_count
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DateBattleReportGuildCmd.id
    local msgParam = {}
    if atk_member_count ~= nil then
      msgParam.atk_member_count = atk_member_count
    end
    if def_member_count ~= nil then
      msgParam.def_member_count = def_member_count
    end
    if boss_hp ~= nil then
      msgParam.boss_hp = boss_hp
    end
    if perfect_time ~= nil and perfect_time.pause ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.perfect_time == nil then
        msgParam.perfect_time = {}
      end
      msgParam.perfect_time.pause = perfect_time.pause
    end
    if perfect_time ~= nil and perfect_time.time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.perfect_time == nil then
        msgParam.perfect_time = {}
      end
      msgParam.perfect_time.time = perfect_time.time
    end
    if death_count ~= nil then
      msgParam.death_count = death_count
    end
    if atk_kill_count ~= nil then
      msgParam.atk_kill_count = atk_kill_count
    end
    if def_kill_count ~= nil then
      msgParam.def_kill_count = def_kill_count
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallDateBattleDetailGuildCmd(reports, isover, winner_guildid)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.DateBattleDetailGuildCmd()
    if reports ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.reports == nil then
        msg.reports = {}
      end
      for i = 1, #reports do
        table.insert(msg.reports, reports[i])
      end
    end
    if isover ~= nil then
      msg.isover = isover
    end
    if winner_guildid ~= nil then
      msg.winner_guildid = winner_guildid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DateBattleDetailGuildCmd.id
    local msgParam = {}
    if reports ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.reports == nil then
        msgParam.reports = {}
      end
      for i = 1, #reports do
        table.insert(msgParam.reports, reports[i])
      end
    end
    if isover ~= nil then
      msgParam.isover = isover
    end
    if winner_guildid ~= nil then
      msgParam.winner_guildid = winner_guildid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallDateBattleListGuildCmd(type, datas)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.DateBattleListGuildCmd()
    if type ~= nil then
      msg.type = type
    end
    if datas ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.datas == nil then
        msg.datas = {}
      end
      for i = 1, #datas do
        table.insert(msg.datas, datas[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DateBattleListGuildCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if datas ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.datas == nil then
        msgParam.datas = {}
      end
      for i = 1, #datas do
        table.insert(msgParam.datas, datas[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallDateBattleRankGuildCmd(mydata, datas)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.DateBattleRankGuildCmd()
    if mydata ~= nil and mydata.guildid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mydata == nil then
        msg.mydata = {}
      end
      msg.mydata.guildid = mydata.guildid
    end
    if mydata ~= nil and mydata.guildname ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mydata == nil then
        msg.mydata = {}
      end
      msg.mydata.guildname = mydata.guildname
    end
    if mydata ~= nil and mydata.guildportrait ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mydata == nil then
        msg.mydata = {}
      end
      msg.mydata.guildportrait = mydata.guildportrait
    end
    if mydata ~= nil and mydata.serverid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mydata == nil then
        msg.mydata = {}
      end
      msg.mydata.serverid = mydata.serverid
    end
    if mydata ~= nil and mydata.chairmanname ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mydata == nil then
        msg.mydata = {}
      end
      msg.mydata.chairmanname = mydata.chairmanname
    end
    if mydata ~= nil and mydata.wintimes ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.mydata == nil then
        msg.mydata = {}
      end
      msg.mydata.wintimes = mydata.wintimes
    end
    if datas ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.datas == nil then
        msg.datas = {}
      end
      for i = 1, #datas do
        table.insert(msg.datas, datas[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DateBattleRankGuildCmd.id
    local msgParam = {}
    if mydata ~= nil and mydata.guildid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mydata == nil then
        msgParam.mydata = {}
      end
      msgParam.mydata.guildid = mydata.guildid
    end
    if mydata ~= nil and mydata.guildname ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mydata == nil then
        msgParam.mydata = {}
      end
      msgParam.mydata.guildname = mydata.guildname
    end
    if mydata ~= nil and mydata.guildportrait ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mydata == nil then
        msgParam.mydata = {}
      end
      msgParam.mydata.guildportrait = mydata.guildportrait
    end
    if mydata ~= nil and mydata.serverid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mydata == nil then
        msgParam.mydata = {}
      end
      msgParam.mydata.serverid = mydata.serverid
    end
    if mydata ~= nil and mydata.chairmanname ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mydata == nil then
        msgParam.mydata = {}
      end
      msgParam.mydata.chairmanname = mydata.chairmanname
    end
    if mydata ~= nil and mydata.wintimes ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.mydata == nil then
        msgParam.mydata = {}
      end
      msgParam.mydata.wintimes = mydata.wintimes
    end
    if datas ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.datas == nil then
        msgParam.datas = {}
      end
      for i = 1, #datas do
        table.insert(msgParam.datas, datas[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallRedtipOptGuildCmd(redtips)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.RedtipOptGuildCmd()
    if redtips ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.redtips == nil then
        msg.redtips = {}
      end
      for i = 1, #redtips do
        table.insert(msg.redtips, redtips[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RedtipOptGuildCmd.id
    local msgParam = {}
    if redtips ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.redtips == nil then
        msgParam.redtips = {}
      end
      for i = 1, #redtips do
        table.insert(msgParam.redtips, redtips[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallRedtipBrowseGuildCmd(red, tipid)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.RedtipBrowseGuildCmd()
    if red ~= nil then
      msg.red = red
    end
    if tipid ~= nil then
      msg.tipid = tipid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RedtipBrowseGuildCmd.id
    local msgParam = {}
    if red ~= nil then
      msgParam.red = red
    end
    if tipid ~= nil then
      msgParam.tipid = tipid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallDateBattleFlagGuildCmd(mapid, datas)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.DateBattleFlagGuildCmd()
    if mapid ~= nil then
      msg.mapid = mapid
    end
    if datas ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.datas == nil then
        msg.datas = {}
      end
      for i = 1, #datas do
        table.insert(msg.datas, datas[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DateBattleFlagGuildCmd.id
    local msgParam = {}
    if mapid ~= nil then
      msgParam.mapid = mapid
    end
    if datas ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.datas == nil then
        msgParam.datas = {}
      end
      for i = 1, #datas do
        table.insert(msgParam.datas, datas[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallDateBattleReportUIStateCmd(open)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.DateBattleReportUIStateCmd()
    if open ~= nil then
      msg.open = open
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DateBattleReportUIStateCmd.id
    local msgParam = {}
    if open ~= nil then
      msgParam.open = open
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallGvgCityStatueQueryGuildCmd(groupid, cityid, infos)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.GvgCityStatueQueryGuildCmd()
    if groupid ~= nil then
      msg.groupid = groupid
    end
    if cityid ~= nil then
      msg.cityid = cityid
    end
    if infos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.infos == nil then
        msg.infos = {}
      end
      for i = 1, #infos do
        table.insert(msg.infos, infos[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgCityStatueQueryGuildCmd.id
    local msgParam = {}
    if groupid ~= nil then
      msgParam.groupid = groupid
    end
    if cityid ~= nil then
      msgParam.cityid = cityid
    end
    if infos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.infos == nil then
        msgParam.infos = {}
      end
      for i = 1, #infos do
        table.insert(msgParam.infos, infos[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallGvgCityStatueUpdateGuildCmd(groupid, cityid, exterior, info)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.GvgCityStatueUpdateGuildCmd()
    if groupid ~= nil then
      msg.groupid = groupid
    end
    if cityid ~= nil then
      msg.cityid = cityid
    end
    if exterior ~= nil then
      msg.exterior = exterior
    end
    if info ~= nil and info.cityid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.info == nil then
        msg.info = {}
      end
      msg.info.cityid = info.cityid
    end
    if info.info ~= nil and info.info.body ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.info == nil then
        msg.info.info = {}
      end
      msg.info.info.body = info.info.body
    end
    if info.info ~= nil and info.info.hair ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.info == nil then
        msg.info.info = {}
      end
      msg.info.info.hair = info.info.hair
    end
    if info.info ~= nil and info.info.head ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.info == nil then
        msg.info.info = {}
      end
      msg.info.info.head = info.info.head
    end
    if info.info ~= nil and info.info.face ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.info == nil then
        msg.info.info = {}
      end
      msg.info.info.face = info.info.face
    end
    if info.info ~= nil and info.info.eye ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.info == nil then
        msg.info.info = {}
      end
      msg.info.info.eye = info.info.eye
    end
    if info.info ~= nil and info.info.mouth ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.info == nil then
        msg.info.info = {}
      end
      msg.info.info.mouth = info.info.mouth
    end
    if info.info ~= nil and info.info.guildname ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.info == nil then
        msg.info.info = {}
      end
      msg.info.info.guildname = info.info.guildname
    end
    if info.info ~= nil and info.info.leadername ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.info == nil then
        msg.info.info = {}
      end
      msg.info.info.leadername = info.info.leadername
    end
    if info.info ~= nil and info.info.leaderid ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.info == nil then
        msg.info.info = {}
      end
      msg.info.info.leaderid = info.info.leaderid
    end
    if info.info ~= nil and info.info.back ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.info == nil then
        msg.info.info = {}
      end
      msg.info.info.back = info.info.back
    end
    if info.info ~= nil and info.info.tail ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.info == nil then
        msg.info.info = {}
      end
      msg.info.info.tail = info.info.tail
    end
    if info.info ~= nil and info.info.pose ~= nil then
      if msg.info == nil then
        msg.info = {}
      end
      if msg.info.info == nil then
        msg.info.info = {}
      end
      msg.info.info.pose = info.info.pose
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GvgCityStatueUpdateGuildCmd.id
    local msgParam = {}
    if groupid ~= nil then
      msgParam.groupid = groupid
    end
    if cityid ~= nil then
      msgParam.cityid = cityid
    end
    if exterior ~= nil then
      msgParam.exterior = exterior
    end
    if info ~= nil and info.cityid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.info == nil then
        msgParam.info = {}
      end
      msgParam.info.cityid = info.cityid
    end
    if info.info ~= nil and info.info.body ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.info == nil then
        msgParam.info.info = {}
      end
      msgParam.info.info.body = info.info.body
    end
    if info.info ~= nil and info.info.hair ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.info == nil then
        msgParam.info.info = {}
      end
      msgParam.info.info.hair = info.info.hair
    end
    if info.info ~= nil and info.info.head ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.info == nil then
        msgParam.info.info = {}
      end
      msgParam.info.info.head = info.info.head
    end
    if info.info ~= nil and info.info.face ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.info == nil then
        msgParam.info.info = {}
      end
      msgParam.info.info.face = info.info.face
    end
    if info.info ~= nil and info.info.eye ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.info == nil then
        msgParam.info.info = {}
      end
      msgParam.info.info.eye = info.info.eye
    end
    if info.info ~= nil and info.info.mouth ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.info == nil then
        msgParam.info.info = {}
      end
      msgParam.info.info.mouth = info.info.mouth
    end
    if info.info ~= nil and info.info.guildname ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.info == nil then
        msgParam.info.info = {}
      end
      msgParam.info.info.guildname = info.info.guildname
    end
    if info.info ~= nil and info.info.leadername ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.info == nil then
        msgParam.info.info = {}
      end
      msgParam.info.info.leadername = info.info.leadername
    end
    if info.info ~= nil and info.info.leaderid ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.info == nil then
        msgParam.info.info = {}
      end
      msgParam.info.info.leaderid = info.info.leaderid
    end
    if info.info ~= nil and info.info.back ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.info == nil then
        msgParam.info.info = {}
      end
      msgParam.info.info.back = info.info.back
    end
    if info.info ~= nil and info.info.tail ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.info == nil then
        msgParam.info.info = {}
      end
      msgParam.info.info.tail = info.info.tail
    end
    if info.info ~= nil and info.info.pose ~= nil then
      if msgParam.info == nil then
        msgParam.info = {}
      end
      if msgParam.info.info == nil then
        msgParam.info.info = {}
      end
      msgParam.info.info.pose = info.info.pose
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:CallQuerySuperGvgStatCmd(datas, is_end)
  if not NetConfig.PBC then
    local msg = GuildCmd_pb.QuerySuperGvgStatCmd()
    if datas ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.datas == nil then
        msg.datas = {}
      end
      for i = 1, #datas do
        table.insert(msg.datas, datas[i])
      end
    end
    if is_end ~= nil then
      msg.is_end = is_end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QuerySuperGvgStatCmd.id
    local msgParam = {}
    if datas ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.datas == nil then
        msgParam.datas = {}
      end
      for i = 1, #datas do
        table.insert(msgParam.datas, datas[i])
      end
    end
    if is_end ~= nil then
      msgParam.is_end = is_end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceGuildCmdAutoProxy:RecvQueryGuildListGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdQueryGuildListGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvCreateGuildGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdCreateGuildGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvEnterGuildGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdEnterGuildGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGuildMemberUpdateGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdGuildMemberUpdateGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGuildApplyUpdateGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdGuildApplyUpdateGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGuildDataUpdateGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdGuildDataUpdateGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGuildMemberDataUpdateGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdGuildMemberDataUpdateGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvApplyGuildGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdApplyGuildGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvProcessApplyGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdProcessApplyGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvInviteMemberGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdInviteMemberGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvProcessInviteGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdProcessInviteGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvSetGuildOptionGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdSetGuildOptionGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvKickMemberGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdKickMemberGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvChangeJobGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdChangeJobGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvExitGuildGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdExitGuildGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvExchangeChairGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdExchangeChairGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvDismissGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdDismissGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvLevelupGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdLevelupGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvDonateGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdDonateGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvDonateListGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdDonateListGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvUpdateDonateItemGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdUpdateDonateItemGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvDonateFrameGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdDonateFrameGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvEnterTerritoryGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdEnterTerritoryGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvPrayGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdPrayGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGuildInfoNtf(data)
  self:Notify(ServiceEvent.GuildCmdGuildInfoNtf, data)
end

function ServiceGuildCmdAutoProxy:RecvGuildPrayNtfGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdGuildPrayNtfGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvLevelupEffectGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdLevelupEffectGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvQueryPackGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdQueryPackGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvPackUpdateGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdPackUpdateGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvExchangeZoneGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdExchangeZoneGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvExchangeZoneNtfGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdExchangeZoneNtfGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvExchangeZoneAnswerGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdExchangeZoneAnswerGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvQueryEventListGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdQueryEventListGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvNewEventGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdNewEventGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvFrameStatusGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdFrameStatusGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvModifyAuthGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdModifyAuthGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvJobUpdateGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdJobUpdateGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvRenameQueryGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdRenameQueryGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvQueryGuildCityInfoGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdQueryGuildCityInfoGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvCityActionGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdCityActionGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGuildIconSyncGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdGuildIconSyncGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGuildIconAddGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdGuildIconAddGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGuildIconUploadGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdGuildIconUploadGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvOpenFunctionGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdOpenFunctionGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvBuildGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdBuildGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvSubmitMaterialGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdSubmitMaterialGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvBuildingNtfGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdBuildingNtfGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvBuildingSubmitCountGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdBuildingSubmitCountGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvChallengeUpdateNtfGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdChallengeUpdateNtfGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvWelfareNtfGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdWelfareNtfGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGetWelfareGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdGetWelfareGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvBuildingLvupEffGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdBuildingLvupEffGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvArtifactUpdateNtfGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdArtifactUpdateNtfGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvArtifactProduceGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdArtifactProduceGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvArtifactOptGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdArtifactOptGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvQueryGQuestGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdQueryGQuestGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvTreasureActionGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdTreasureActionGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvQueryBuildingRankGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdQueryBuildingRankGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvQueryTreasureResultGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdQueryTreasureResultGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvQueryGCityShowInfoGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdQueryGCityShowInfoGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGvgOpenFireGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdGvgOpenFireGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvEnterPunishTimeNtfGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdEnterPunishTimeNtfGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvQuerySuperGvgDataGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdQuerySuperGvgDataGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvQueryGvgGuildInfoGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdQueryGvgGuildInfoGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGvgRewardNtfGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdGvgRewardNtfGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGetGvgRewardGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdGetGvgRewardGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvQueryCheckInfoGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdQueryCheckInfoGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvQueryBifrostRankGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdQueryBifrostRankGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvQueryMemberBifrostInfoGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdQueryMemberBifrostInfoGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvQueryGuildInfoGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdQueryGuildInfoGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvQueryGvgZoneGroupGuildCCmd(data)
  self:Notify(ServiceEvent.GuildCmdQueryGvgZoneGroupGuildCCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvUpdateMapCityGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdUpdateMapCityGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGvgRankInfoQueryGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdGvgRankInfoQueryGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGvgRankInfoRetGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdGvgRankInfoRetGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGvgRankHistroyQueryGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdGvgRankHistroyQueryGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGvgRankHistroyRetGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdGvgRankHistroyRetGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGvgSmallMetalCntGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdGvgSmallMetalCntGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGvgTaskUpdateGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdGvgTaskUpdateGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGvgStatueSyncGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdGvgStatueSyncGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGvgCookingCmd(data)
  self:Notify(ServiceEvent.GuildCmdGvgCookingCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGvgCookingUpdateCmd(data)
  self:Notify(ServiceEvent.GuildCmdGvgCookingUpdateCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGvgScoreInfoUpdateGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdGvgScoreInfoUpdateGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGvgSettleReqGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdGvgSettleReqGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGvgSettleInfoGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdGvgSettleInfoGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGvgSettleSelectGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdGvgSettleSelectGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGvgReqEnterCityGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdGvgReqEnterCityGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGvgFireReportGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdGvgFireReportGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvBuildingUpdateNtfGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdBuildingUpdateNtfGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGvgRoadblockModifyGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdGvgRoadblockModifyGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGvgRoadblockQueryGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdGvgRoadblockQueryGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvExchangeGvgGroupGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdExchangeGvgGroupGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGvgDataQueryGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdGvgDataQueryGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvDateBattleInfoGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdDateBattleInfoGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvDateBattleTargetGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdDateBattleTargetGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvDateBattleInviteGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdDateBattleInviteGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvDateBattleReplyGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdDateBattleReplyGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvDateBattleOpenGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdDateBattleOpenGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvDateBattleEnterGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdDateBattleEnterGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvDateBattleReportGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdDateBattleReportGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvDateBattleDetailGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdDateBattleDetailGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvDateBattleListGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdDateBattleListGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvDateBattleRankGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdDateBattleRankGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvRedtipOptGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdRedtipOptGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvRedtipBrowseGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdRedtipBrowseGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvDateBattleFlagGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdDateBattleFlagGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvDateBattleReportUIStateCmd(data)
  self:Notify(ServiceEvent.GuildCmdDateBattleReportUIStateCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGvgCityStatueQueryGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdGvgCityStatueQueryGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvGvgCityStatueUpdateGuildCmd(data)
  self:Notify(ServiceEvent.GuildCmdGvgCityStatueUpdateGuildCmd, data)
end

function ServiceGuildCmdAutoProxy:RecvQuerySuperGvgStatCmd(data)
  self:Notify(ServiceEvent.GuildCmdQuerySuperGvgStatCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.GuildCmdQueryGuildListGuildCmd = "ServiceEvent_GuildCmdQueryGuildListGuildCmd"
ServiceEvent.GuildCmdCreateGuildGuildCmd = "ServiceEvent_GuildCmdCreateGuildGuildCmd"
ServiceEvent.GuildCmdEnterGuildGuildCmd = "ServiceEvent_GuildCmdEnterGuildGuildCmd"
ServiceEvent.GuildCmdGuildMemberUpdateGuildCmd = "ServiceEvent_GuildCmdGuildMemberUpdateGuildCmd"
ServiceEvent.GuildCmdGuildApplyUpdateGuildCmd = "ServiceEvent_GuildCmdGuildApplyUpdateGuildCmd"
ServiceEvent.GuildCmdGuildDataUpdateGuildCmd = "ServiceEvent_GuildCmdGuildDataUpdateGuildCmd"
ServiceEvent.GuildCmdGuildMemberDataUpdateGuildCmd = "ServiceEvent_GuildCmdGuildMemberDataUpdateGuildCmd"
ServiceEvent.GuildCmdApplyGuildGuildCmd = "ServiceEvent_GuildCmdApplyGuildGuildCmd"
ServiceEvent.GuildCmdProcessApplyGuildCmd = "ServiceEvent_GuildCmdProcessApplyGuildCmd"
ServiceEvent.GuildCmdInviteMemberGuildCmd = "ServiceEvent_GuildCmdInviteMemberGuildCmd"
ServiceEvent.GuildCmdProcessInviteGuildCmd = "ServiceEvent_GuildCmdProcessInviteGuildCmd"
ServiceEvent.GuildCmdSetGuildOptionGuildCmd = "ServiceEvent_GuildCmdSetGuildOptionGuildCmd"
ServiceEvent.GuildCmdKickMemberGuildCmd = "ServiceEvent_GuildCmdKickMemberGuildCmd"
ServiceEvent.GuildCmdChangeJobGuildCmd = "ServiceEvent_GuildCmdChangeJobGuildCmd"
ServiceEvent.GuildCmdExitGuildGuildCmd = "ServiceEvent_GuildCmdExitGuildGuildCmd"
ServiceEvent.GuildCmdExchangeChairGuildCmd = "ServiceEvent_GuildCmdExchangeChairGuildCmd"
ServiceEvent.GuildCmdDismissGuildCmd = "ServiceEvent_GuildCmdDismissGuildCmd"
ServiceEvent.GuildCmdLevelupGuildCmd = "ServiceEvent_GuildCmdLevelupGuildCmd"
ServiceEvent.GuildCmdDonateGuildCmd = "ServiceEvent_GuildCmdDonateGuildCmd"
ServiceEvent.GuildCmdDonateListGuildCmd = "ServiceEvent_GuildCmdDonateListGuildCmd"
ServiceEvent.GuildCmdUpdateDonateItemGuildCmd = "ServiceEvent_GuildCmdUpdateDonateItemGuildCmd"
ServiceEvent.GuildCmdDonateFrameGuildCmd = "ServiceEvent_GuildCmdDonateFrameGuildCmd"
ServiceEvent.GuildCmdEnterTerritoryGuildCmd = "ServiceEvent_GuildCmdEnterTerritoryGuildCmd"
ServiceEvent.GuildCmdPrayGuildCmd = "ServiceEvent_GuildCmdPrayGuildCmd"
ServiceEvent.GuildCmdGuildInfoNtf = "ServiceEvent_GuildCmdGuildInfoNtf"
ServiceEvent.GuildCmdGuildPrayNtfGuildCmd = "ServiceEvent_GuildCmdGuildPrayNtfGuildCmd"
ServiceEvent.GuildCmdLevelupEffectGuildCmd = "ServiceEvent_GuildCmdLevelupEffectGuildCmd"
ServiceEvent.GuildCmdQueryPackGuildCmd = "ServiceEvent_GuildCmdQueryPackGuildCmd"
ServiceEvent.GuildCmdPackUpdateGuildCmd = "ServiceEvent_GuildCmdPackUpdateGuildCmd"
ServiceEvent.GuildCmdExchangeZoneGuildCmd = "ServiceEvent_GuildCmdExchangeZoneGuildCmd"
ServiceEvent.GuildCmdExchangeZoneNtfGuildCmd = "ServiceEvent_GuildCmdExchangeZoneNtfGuildCmd"
ServiceEvent.GuildCmdExchangeZoneAnswerGuildCmd = "ServiceEvent_GuildCmdExchangeZoneAnswerGuildCmd"
ServiceEvent.GuildCmdQueryEventListGuildCmd = "ServiceEvent_GuildCmdQueryEventListGuildCmd"
ServiceEvent.GuildCmdNewEventGuildCmd = "ServiceEvent_GuildCmdNewEventGuildCmd"
ServiceEvent.GuildCmdFrameStatusGuildCmd = "ServiceEvent_GuildCmdFrameStatusGuildCmd"
ServiceEvent.GuildCmdModifyAuthGuildCmd = "ServiceEvent_GuildCmdModifyAuthGuildCmd"
ServiceEvent.GuildCmdJobUpdateGuildCmd = "ServiceEvent_GuildCmdJobUpdateGuildCmd"
ServiceEvent.GuildCmdRenameQueryGuildCmd = "ServiceEvent_GuildCmdRenameQueryGuildCmd"
ServiceEvent.GuildCmdQueryGuildCityInfoGuildCmd = "ServiceEvent_GuildCmdQueryGuildCityInfoGuildCmd"
ServiceEvent.GuildCmdCityActionGuildCmd = "ServiceEvent_GuildCmdCityActionGuildCmd"
ServiceEvent.GuildCmdGuildIconSyncGuildCmd = "ServiceEvent_GuildCmdGuildIconSyncGuildCmd"
ServiceEvent.GuildCmdGuildIconAddGuildCmd = "ServiceEvent_GuildCmdGuildIconAddGuildCmd"
ServiceEvent.GuildCmdGuildIconUploadGuildCmd = "ServiceEvent_GuildCmdGuildIconUploadGuildCmd"
ServiceEvent.GuildCmdOpenFunctionGuildCmd = "ServiceEvent_GuildCmdOpenFunctionGuildCmd"
ServiceEvent.GuildCmdBuildGuildCmd = "ServiceEvent_GuildCmdBuildGuildCmd"
ServiceEvent.GuildCmdSubmitMaterialGuildCmd = "ServiceEvent_GuildCmdSubmitMaterialGuildCmd"
ServiceEvent.GuildCmdBuildingNtfGuildCmd = "ServiceEvent_GuildCmdBuildingNtfGuildCmd"
ServiceEvent.GuildCmdBuildingSubmitCountGuildCmd = "ServiceEvent_GuildCmdBuildingSubmitCountGuildCmd"
ServiceEvent.GuildCmdChallengeUpdateNtfGuildCmd = "ServiceEvent_GuildCmdChallengeUpdateNtfGuildCmd"
ServiceEvent.GuildCmdWelfareNtfGuildCmd = "ServiceEvent_GuildCmdWelfareNtfGuildCmd"
ServiceEvent.GuildCmdGetWelfareGuildCmd = "ServiceEvent_GuildCmdGetWelfareGuildCmd"
ServiceEvent.GuildCmdBuildingLvupEffGuildCmd = "ServiceEvent_GuildCmdBuildingLvupEffGuildCmd"
ServiceEvent.GuildCmdArtifactUpdateNtfGuildCmd = "ServiceEvent_GuildCmdArtifactUpdateNtfGuildCmd"
ServiceEvent.GuildCmdArtifactProduceGuildCmd = "ServiceEvent_GuildCmdArtifactProduceGuildCmd"
ServiceEvent.GuildCmdArtifactOptGuildCmd = "ServiceEvent_GuildCmdArtifactOptGuildCmd"
ServiceEvent.GuildCmdQueryGQuestGuildCmd = "ServiceEvent_GuildCmdQueryGQuestGuildCmd"
ServiceEvent.GuildCmdTreasureActionGuildCmd = "ServiceEvent_GuildCmdTreasureActionGuildCmd"
ServiceEvent.GuildCmdQueryBuildingRankGuildCmd = "ServiceEvent_GuildCmdQueryBuildingRankGuildCmd"
ServiceEvent.GuildCmdQueryTreasureResultGuildCmd = "ServiceEvent_GuildCmdQueryTreasureResultGuildCmd"
ServiceEvent.GuildCmdQueryGCityShowInfoGuildCmd = "ServiceEvent_GuildCmdQueryGCityShowInfoGuildCmd"
ServiceEvent.GuildCmdGvgOpenFireGuildCmd = "ServiceEvent_GuildCmdGvgOpenFireGuildCmd"
ServiceEvent.GuildCmdEnterPunishTimeNtfGuildCmd = "ServiceEvent_GuildCmdEnterPunishTimeNtfGuildCmd"
ServiceEvent.GuildCmdQuerySuperGvgDataGuildCmd = "ServiceEvent_GuildCmdQuerySuperGvgDataGuildCmd"
ServiceEvent.GuildCmdQueryGvgGuildInfoGuildCmd = "ServiceEvent_GuildCmdQueryGvgGuildInfoGuildCmd"
ServiceEvent.GuildCmdGvgRewardNtfGuildCmd = "ServiceEvent_GuildCmdGvgRewardNtfGuildCmd"
ServiceEvent.GuildCmdGetGvgRewardGuildCmd = "ServiceEvent_GuildCmdGetGvgRewardGuildCmd"
ServiceEvent.GuildCmdQueryCheckInfoGuildCmd = "ServiceEvent_GuildCmdQueryCheckInfoGuildCmd"
ServiceEvent.GuildCmdQueryBifrostRankGuildCmd = "ServiceEvent_GuildCmdQueryBifrostRankGuildCmd"
ServiceEvent.GuildCmdQueryMemberBifrostInfoGuildCmd = "ServiceEvent_GuildCmdQueryMemberBifrostInfoGuildCmd"
ServiceEvent.GuildCmdQueryGuildInfoGuildCmd = "ServiceEvent_GuildCmdQueryGuildInfoGuildCmd"
ServiceEvent.GuildCmdQueryGvgZoneGroupGuildCCmd = "ServiceEvent_GuildCmdQueryGvgZoneGroupGuildCCmd"
ServiceEvent.GuildCmdUpdateMapCityGuildCmd = "ServiceEvent_GuildCmdUpdateMapCityGuildCmd"
ServiceEvent.GuildCmdGvgRankInfoQueryGuildCmd = "ServiceEvent_GuildCmdGvgRankInfoQueryGuildCmd"
ServiceEvent.GuildCmdGvgRankInfoRetGuildCmd = "ServiceEvent_GuildCmdGvgRankInfoRetGuildCmd"
ServiceEvent.GuildCmdGvgRankHistroyQueryGuildCmd = "ServiceEvent_GuildCmdGvgRankHistroyQueryGuildCmd"
ServiceEvent.GuildCmdGvgRankHistroyRetGuildCmd = "ServiceEvent_GuildCmdGvgRankHistroyRetGuildCmd"
ServiceEvent.GuildCmdGvgSmallMetalCntGuildCmd = "ServiceEvent_GuildCmdGvgSmallMetalCntGuildCmd"
ServiceEvent.GuildCmdGvgTaskUpdateGuildCmd = "ServiceEvent_GuildCmdGvgTaskUpdateGuildCmd"
ServiceEvent.GuildCmdGvgStatueSyncGuildCmd = "ServiceEvent_GuildCmdGvgStatueSyncGuildCmd"
ServiceEvent.GuildCmdGvgCookingCmd = "ServiceEvent_GuildCmdGvgCookingCmd"
ServiceEvent.GuildCmdGvgCookingUpdateCmd = "ServiceEvent_GuildCmdGvgCookingUpdateCmd"
ServiceEvent.GuildCmdGvgScoreInfoUpdateGuildCmd = "ServiceEvent_GuildCmdGvgScoreInfoUpdateGuildCmd"
ServiceEvent.GuildCmdGvgSettleReqGuildCmd = "ServiceEvent_GuildCmdGvgSettleReqGuildCmd"
ServiceEvent.GuildCmdGvgSettleInfoGuildCmd = "ServiceEvent_GuildCmdGvgSettleInfoGuildCmd"
ServiceEvent.GuildCmdGvgSettleSelectGuildCmd = "ServiceEvent_GuildCmdGvgSettleSelectGuildCmd"
ServiceEvent.GuildCmdGvgReqEnterCityGuildCmd = "ServiceEvent_GuildCmdGvgReqEnterCityGuildCmd"
ServiceEvent.GuildCmdGvgFireReportGuildCmd = "ServiceEvent_GuildCmdGvgFireReportGuildCmd"
ServiceEvent.GuildCmdBuildingUpdateNtfGuildCmd = "ServiceEvent_GuildCmdBuildingUpdateNtfGuildCmd"
ServiceEvent.GuildCmdGvgRoadblockModifyGuildCmd = "ServiceEvent_GuildCmdGvgRoadblockModifyGuildCmd"
ServiceEvent.GuildCmdGvgRoadblockQueryGuildCmd = "ServiceEvent_GuildCmdGvgRoadblockQueryGuildCmd"
ServiceEvent.GuildCmdExchangeGvgGroupGuildCmd = "ServiceEvent_GuildCmdExchangeGvgGroupGuildCmd"
ServiceEvent.GuildCmdGvgDataQueryGuildCmd = "ServiceEvent_GuildCmdGvgDataQueryGuildCmd"
ServiceEvent.GuildCmdDateBattleInfoGuildCmd = "ServiceEvent_GuildCmdDateBattleInfoGuildCmd"
ServiceEvent.GuildCmdDateBattleTargetGuildCmd = "ServiceEvent_GuildCmdDateBattleTargetGuildCmd"
ServiceEvent.GuildCmdDateBattleInviteGuildCmd = "ServiceEvent_GuildCmdDateBattleInviteGuildCmd"
ServiceEvent.GuildCmdDateBattleReplyGuildCmd = "ServiceEvent_GuildCmdDateBattleReplyGuildCmd"
ServiceEvent.GuildCmdDateBattleOpenGuildCmd = "ServiceEvent_GuildCmdDateBattleOpenGuildCmd"
ServiceEvent.GuildCmdDateBattleEnterGuildCmd = "ServiceEvent_GuildCmdDateBattleEnterGuildCmd"
ServiceEvent.GuildCmdDateBattleReportGuildCmd = "ServiceEvent_GuildCmdDateBattleReportGuildCmd"
ServiceEvent.GuildCmdDateBattleDetailGuildCmd = "ServiceEvent_GuildCmdDateBattleDetailGuildCmd"
ServiceEvent.GuildCmdDateBattleListGuildCmd = "ServiceEvent_GuildCmdDateBattleListGuildCmd"
ServiceEvent.GuildCmdDateBattleRankGuildCmd = "ServiceEvent_GuildCmdDateBattleRankGuildCmd"
ServiceEvent.GuildCmdRedtipOptGuildCmd = "ServiceEvent_GuildCmdRedtipOptGuildCmd"
ServiceEvent.GuildCmdRedtipBrowseGuildCmd = "ServiceEvent_GuildCmdRedtipBrowseGuildCmd"
ServiceEvent.GuildCmdDateBattleFlagGuildCmd = "ServiceEvent_GuildCmdDateBattleFlagGuildCmd"
ServiceEvent.GuildCmdDateBattleReportUIStateCmd = "ServiceEvent_GuildCmdDateBattleReportUIStateCmd"
ServiceEvent.GuildCmdGvgCityStatueQueryGuildCmd = "ServiceEvent_GuildCmdGvgCityStatueQueryGuildCmd"
ServiceEvent.GuildCmdGvgCityStatueUpdateGuildCmd = "ServiceEvent_GuildCmdGvgCityStatueUpdateGuildCmd"
ServiceEvent.GuildCmdQuerySuperGvgStatCmd = "ServiceEvent_GuildCmdQuerySuperGvgStatCmd"
