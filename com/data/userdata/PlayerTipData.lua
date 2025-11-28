autoImport("TeamInvitee")
PlayerTipData = class("PlayerTipData")

function PlayerTipData:ctor()
end

function PlayerTipData:SetByCreature(creature)
  self.id = creature.data.id
  self.level = creature.data.userdata:Get(UDEnum.ROLELEVEL)
  self.name = creature.data:GetName()
  if creature:GetCreatureType() == Creature_Type.Npc and creature.data:IsSkada() then
    local furnitureData = HomeProxy.Instance:FindFurnitureData(creature.data.furnitureID)
    if furnitureData and furnitureData.woodType == EWOODTYPE.EWOODTYPE_SPEC_MONSTER then
      local config = Table_Monster[furnitureData.woodMonsterId]
      if config then
        self.level = config.Level
        self.name = config.NameZh
      end
    end
  end
  local guildData = creature.data.guildData
  if guildData then
    self.guildid = guildData.id
    self.guildname = guildData.name
  end
  self.headData = HeadImageData.new()
  self.headData:TransByLPlayer(creature)
  self.zoneid = creature.data.userdata:Get(UDEnum.ZONEID) or MyselfProxy.Instance:GetZoneId()
  self.homeid = creature.data.userdata:Get(UDEnum.HOME_ROOMID)
  self.accid = creature.data.accid
  self.serverid = creature.serverid
  local mercenaryGuildData = creature.data.GetMercenaryGuildData and creature.data:GetMercenaryGuildData()
  self.mercenary_guildid = mercenaryGuildData and mercenaryGuildData.id or 0
end

function PlayerTipData:SetByFriendData(frienddata)
  self.id = frienddata.guid
  self.name = frienddata.name
  self.level = frienddata.level
  self.guildname = frienddata.guildname
  self.zoneid = frienddata.zoneid
  self.serverid = frienddata.serverid
  self.headData = HeadImageData.new()
  self.headData:TransByFriendData(frienddata)
  self.offlinetime = frienddata.offlinetime
  self.homeid = frienddata.roomid
  self.accid = frienddata.accid
  self.guildid = frienddata.guildid
  self.mercenary_guildid = frienddata.mercenary_guildid
end

function PlayerTipData:SetByWarband(bandMemberData)
  self.id = bandMemberData.id
  self.name = bandMemberData.name
  self.level = bandMemberData.level
  self.guildname = bandMemberData.guildName
  self.headData = HeadImageData.new()
  self.headData:TransByWarbandData(bandMemberData)
end

function PlayerTipData:SetByTeamMemberData(teamMemberData)
  self.id = teamMemberData.id
  self.name = teamMemberData.name
  if teamMemberData.cat and teamMemberData.cat ~= 0 then
    self.cat = teamMemberData.cat
    self.expiretime = teamMemberData.expiretime
  else
    self.cat = nil
    self.expiretime = nil
  end
  if teamMemberData.robot and teamMemberData.robot ~= 0 then
    self.robot = teamMemberData.robot
  else
    self.robot = nil
  end
  if teamMemberData:IsHireMember() then
    self.mastername = teamMemberData.mastername
    self.masterid = teamMemberData.masterid
  elseif teamMemberData:IsRobotMember() then
    self.guildname = ZhString.RobotNpc_Guild
  else
    self.guildname = teamMemberData.guildname
    self.guildid = teamMemberData.guildid
    self.zoneid = teamMemberData:GetZoneId()
  end
  if self.id == Game.Myself.data.id then
    self.level = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
  else
    self.level = teamMemberData.baselv
  end
  self.isDoram = teamMemberData:IsDoram()
  self.headData = HeadImageData.new()
  self.headData:TransByTeamMemberData(teamMemberData)
  self.homeid = teamMemberData.roomid
  self.accid = teamMemberData.accid
  self.serverid = teamMemberData.serverid
  self.mercenary_guildid = teamMemberData.mercenary_guildid
end

function PlayerTipData:SetByChatMessageData(chatMessageData)
  self.id = chatMessageData:GetId()
  self.name = chatMessageData:GetName()
  local myid = Game.Myself.data.id
  if self.id == myid then
    self.level = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
  else
    self.level = chatMessageData:GetLevel()
  end
  self.guildname = chatMessageData:GetGuildname()
  self.zoneid = chatMessageData:GetZoneId()
  self.serverid = chatMessageData:GetServerId()
  self.homeid = chatMessageData:GetHomeId()
  self.accid = chatMessageData:GetAccId()
  self.portrait_frame = chatMessageData:GetPortraitFrame()
  self.headData = HeadImageData.new()
  self.headData:TransByChatMessageData(chatMessageData)
  self.str = chatMessageData:GetStr()
end

function PlayerTipData:SetByChatZoneMemberData(chatZoneMember)
  self.id = chatZoneMember.id
  self.name = chatZoneMember.name
  local myid = Game.Myself.data.id
  if self.id == myid then
    self.level = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
  else
    self.level = chatZoneMember.level
  end
  self.guildname = chatZoneMember.guildname
  self.serverid = chatZoneMember.serverid
  self.headData = HeadImageData.new()
  self.headData:TransByChatZoneMemberData(chatZoneMember)
end

function PlayerTipData:SetByGuildMemberData(guildMember)
  self.id = guildMember.id
  self.name = guildMember.name
  self.guildid = guildMember.guildData.id
  self.guildname = guildMember.guildData.name
  self.zoneid = guildMember.zoneid
  local myid = Game.Myself.data.id
  if self.id == myid then
    self.level = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
  else
    self.level = guildMember.baselevel
  end
  self.headData = HeadImageData.new()
  self.headData:TransByGuildMemberData(guildMember)
  self.parama = guildMember
  self.homeid = guildMember.roomid
  self.accid = guildMember.accid
  self.mercenary_guildid = guildMember.mercenary_guild_id
end

function PlayerTipData:SetByGuildApplyData(applyData)
  self.id = applyData.id
  self.name = applyData.name
  self.level = applyData.baselevel
  self.zoneid = applyData.zoneid
  self.accid = applyData.accid
  self.headData = HeadImageData.new()
  self.headData:TransByGuildApplyData(applyData)
end

function PlayerTipData:SetByPetInfoData(petInfoData)
  self.id = petInfoData.guid
  self.name = petInfoData.name
  self.level = petInfoData.level
  self.headData = HeadImageData.new()
  self.headData:TransByPetInfoData(petInfoData)
  self.petid = petInfoData.petid
  self.friendlv = petInfoData.friendlv
end

function PlayerTipData:SetByBeingInfoData(beingInfoData)
  self.id = beingInfoData.guid
  self.name = beingInfoData.name
  self.level = beingInfoData.lv
  self.headData = HeadImageData.new()
  self.headData:TransByBeingInfoData(beingInfoData)
  self.beingid = beingInfoData.beingid
end

function PlayerTipData:SetByBokiData(boki)
  self.id = boki.data.id
  self.name = boki.data.name
  self.level = boki.data.userdata:Get(UDEnum.ROLELEVEL) or 0
  self.headData = HeadImageData.new()
  self.headData:TransByBokiData(boki)
end

function PlayerTipData:SetQueryTeamInfo(server_data)
  if not self.invitee then
    self.invitee = TeamInvitee.new()
  end
  self.invitee:SetId(self.id, self.cat)
  self.invitee:SetTeamInfo(server_data)
end

function PlayerTipData:IsTeam()
  return self.invitee and self.invitee:IsTeam()
end

function PlayerTipData:SetByWeddingcharData(weddingcharData, colorName)
  self.id = weddingcharData.charid
  if colorName then
    self.name = string.format(ZhString.Wedding_CharNameTip, weddingcharData.name)
  else
    self.name = weddingcharData.name
  end
  self.level = weddingcharData.level
  self.guildname = weddingcharData.guildname
  self.headData = HeadImageData.new()
  self.headData:TransByWeddingCharData(weddingcharData)
end

function PlayerTipData:SetBySocialData(socialData)
  helplog("SetBySocialData", socialData.name)
  self.id = socialData.guid
  self.name = socialData.name
  self.level = socialData.level
  self.guildname = socialData.guildname
  self.headData = HeadImageData.new()
  self.headData:TransBySocialData(socialData)
  self.homeid = socialData.roomid
  self.accid = socialData.accid
  self.guildid = socialData.guildid
  self.mercenary_guildid = socialData.mercenary_guildid
end

function PlayerTipData:SetByMatcherData(matcherdata)
  self.id = matcherdata.charid
  self.name = matcherdata.name
  self.level = matcherdata.level
  self.headData = HeadImageData.new()
  self.headData:TransByMatcherData(matcherdata)
end

function PlayerTipData:SetByBossKillerData(bossKillerData)
  local userdata = bossKillerData.userdata
  self.id = userdata.charid
  self.name = userdata.name
  self.level = userdata.baselevel
  self.guildname = userdata.guildname
  self.headData = HeadImageData.new()
  self.headData:TransByBossKillerData(bossKillerData)
end

function PlayerTipData:SetByTeamPwsRankData(teamPwsRankData)
  self.id = teamPwsRankData.charid
  self.name = teamPwsRankData.name
  self.level = teamPwsRankData.level
  self.guildname = teamPwsRankData.guildname
  self.headData = HeadImageData.new()
  self.headData:TransByTeamPwsRankData(teamPwsRankData)
end

function PlayerTipData:SetByThanatosPlayerData(thanatosPlayerData)
  self.id = thanatosPlayerData.charid
  self.name = thanatosPlayerData.name
  self.level = thanatosPlayerData.level
  self.guildname = thanatosPlayerData.guildname
  self.headData = HeadImageData.new()
  self.headData:TransByThanatosPlayerData(thanatosPlayerData)
end

function PlayerTipData:SetByDamageUserData(damageUserData)
  self.id = damageUserData.charid
  self.name = damageUserData.name
  self.level = damageUserData.baselevel
  self.guildname = damageUserData.guildname
  self.serverid = damageUserData.serverid
  self.headData = HeadImageData.new()
  self.headData:TransByDamageUserData(damageUserData)
end

function PlayerTipData:SetByGuestVisitData(guestVisitData)
  self.id = guestVisitData.charid
  self.name = guestVisitData.name
  self.level = guestVisitData.baselevel
  self.guildname = guestVisitData.guildname
  self.serverid = guestVisitData.serverid
  self.headData = HeadImageData.new()
  self.headData:TransByGuestVisitData(guestVisitData)
end

function PlayerTipData:SetByBattlePassRankShowData(data)
  self.id = data.guid
  self.name = data.name
  self.level = data.level
  self.guildname = data.guildname
  self.headData = HeadImageData.new()
  self.headData:TransByBattlePassRankShowData(data)
end

function PlayerTipData:SetByRoguelikeUserData(data)
  self.id = data.charid
  self.name = data.name
  self.level = data.level
  self.headData = HeadImageData.new()
  self.headData:TransByRoguelikeUserData(data)
end

function PlayerTipData:SetByDisneyRankMemberData(data)
  self.id = data.id
  self.name = data.name
  self.level = data.lv
  self.guildname = data.guildname
  self.headData = HeadImageData.new()
  self.headData:TransByDisneyRankMemberData(data)
end

function PlayerTipData:SetByCustomRoomMemberData(data)
  self.id = data.id
  self.name = data.name
  self.level = data.level
  self.guildname = data.guildname
  self.headData = data.portrait
end

function PlayerTipData:GetName()
  return self.name
end

function PlayerTipData:SetBySysMsgUserInfoData(data)
  self.id = data.charid
  self.name = data.name
  self.guildid = data.guildid
  self.guildname = data.guildname
  self.level = data.level
  self.homeid = data.homeid
  self.accid = data.accid
  self.headData = HeadImageData.new()
  self.headData:TransByPortraitData(data)
end

function PlayerTipData:SetByPippiData()
  local petInfo = {}
  petInfo.petid = 580400
  petInfo.guid = NScenePetProxy.Instance:GetMyPipipi()
  self.headData = HeadImageData.new()
  self.headData:TransByPippiData(petInfo)
  local monsterConfig = Table_Monster[580400]
  self.name = monsterConfig.NameZh
  self.guildname = " "
  self.level = nil
end

function PlayerTipData:SetByFairyTaleRankData(data)
  self.id = data.charId
  self.name = data.name
  self.headData = clone(data.headData)
  self.guildname = data.guildName
end
