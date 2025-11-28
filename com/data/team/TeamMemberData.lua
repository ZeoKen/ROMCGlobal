autoImport("NewbieCollegeProxy")
TeamMemberData = class("TeamMemberData")
TeamMemberData.KeyType = {}
local mapTeamMemberProp = function(enum, propName)
  if enum then
    TeamMemberData.KeyType[enum] = propName
  else
    redlog("SessionTeam 空协议: ", propName)
  end
end
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_NAME, "name")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_CAT, "cat")
mapTeamMemberProp(NewbieCollegeProxy.EMEMBERDATA_FAKE_NPC, "fake_npc")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_BASELEVEL, "baselv")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_PROFESSION, "profession")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_MAPID, "mapid")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_PORTRAIT, "portrait")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_FRAME, "frame")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_RAIDID, "raid")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_OFFLINE, "offline")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_HP, "hp")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_MAXHP, "hpmax")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_SP, "sp")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_MAXSP, "spmax")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_JOB, "job")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_TARGETID, "targetid")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_JOINHANDID, "joinhandid")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_BODY, "body")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_CLOTHCOLOR, "bodycolor")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_HAIR, "hair")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_EYE, "eye")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_HAIRCOLOR, "haircolor")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_RIGHTHAND, "rightWeapon")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_LEFTHAND, "leftWeapon")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_HEAD, "head")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_BACK, "back")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_FACE, "face")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_MOUTH, "mouth")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_TAIL, "tail")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_GUILDID, "guildid")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_GUILDNAME, "guildname")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_GENDER, "gender")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_BLINK, "blink")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_ZONEID, "zoneid")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_AUTOFOLLOW, "autofollow")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_RELIVETIME, "resttime")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_EXPIRETIME, "expiretime")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_CAT_OWNER, "masterid")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_GUILDRAIDINDEX, "guildraidindex")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_REALTIMEVOICE, "realtimevoice")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_REAL_ZONEID, "realzoneid")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_ENSEMBLESKILL, "ensembleskill")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_SCENEID, "sceneid")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_HOME_ROOMID, "roomid")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_PORTRAIT_FRAME, "portraitframe")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_BACKGROUND, "background")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_IMAGE, "image")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_AFK, "afk")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_GME_MUTE, "mute")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_FUNCTION, "role")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_ROBOT, "robot")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_TEAMNPC, "teamnpc")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_MERCENARY_GUILDID, "mercenary_guildid")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_MERCENARY_GUILDNAME, "mercenary_guildname")
mapTeamMemberProp(SessionTeam_pb.EMEMBERDATA_HIDE_NAME, "anonymous")
TeamMemberDataMapType = {ensembleskill = 1}
TeamMemberDataStringType = {name = 1, guildname = 1}

function TeamMemberData:ctor(teamMember, index)
  self.index = index
  self.pos = LuaVector3()
  self.pos_seted = false
  self:SetData(teamMember)
end

function TeamMemberData:SetData(tmdata)
  if tmdata then
    if tmdata.guid then
      self.id = tmdata.guid
    end
    if tmdata.name then
      self.name = tmdata.name
    end
    if tmdata.time then
      self.time = tmdata.time
    end
    if tmdata.accid then
      self.accid = tmdata.accid
    end
    if tmdata.datas then
      self:SetMemberData(tmdata.datas)
    end
    if tmdata.serverid then
      local isMyPet = self.masterid == Game.Myself.data.id
      self.serverid = isMyPet and MyselfProxy.Instance:GetServerId() or tmdata.serverid
    end
  end
end

function TeamMemberData:SetMemberData(memberDatas)
  for i = 1, #memberDatas do
    local data = memberDatas[i]
    local key = self.KeyType[data.type]
    if key then
      if TeamMemberDataMapType[key] then
        local value = self[key]
        if value == nil then
          value = {}
          self[key] = value
        else
          TableUtility.TableClear(value)
        end
        for j = 1, #data.values do
          local values = data.values[j]
          value[values] = values
        end
      elseif TeamMemberDataStringType[key] then
        self[key] = data.data
      else
        self[key] = data.value
      end
    end
  end
  self:UpdateHireMemberInfo()
  self:UpdateFakeNpcMemberInfo()
  self:UpdateRobotMemberInfo()
  self:UpdateTeamNpcInfo()
end

function TeamMemberData:UpdatePos(pos, dead)
  self.pos_seted = true
  LuaVector3.Better_Set(self.pos, pos.x / 1000, pos.y / 1000, pos.z / 1000)
  self.dead = dead
end

function TeamMemberData:IsAfk()
  return self.afk and self.afk ~= 0
end

function TeamMemberData:IsOffline()
  if self.offline and self.offline == 1 then
    return true
  end
  return false
end

function TeamMemberData:IsSameline()
  if self:IsHireMember() then
    return true
  end
  if self:IsRobotMember() then
    return true
  end
  local fmodID = ChangeZoneProxy.Instance:GetSimpleZoneId(MyselfProxy.Instance:GetZoneId())
  return self:GetZoneId() == fmodID
end

function TeamMemberData:GetServerId()
  return self.serverid
end

function TeamMemberData:IsSameServer()
  if self:IsHireMember() then
    return true
  end
  if self:IsRobotMember() then
    return true
  end
  if not self.serverid then
    return true
  end
  return MyselfProxy.Instance:IsSameServer(self.serverid)
end

function TeamMemberData:IsSameMap()
  if self:IsHireMember() then
    return true
  end
  if self:IsRobotMember() then
    return true
  end
  return self.mapid == Game.MapManager:GetMapID()
end

function TeamMemberData:IsInCommonlineMap()
  if self.mapid == nil then
    return false
  end
  local mapSData = Table_Map[self.mapid]
  if mapSData == nil then
    return false
  end
  return mapSData.IsCommonline == 1
end

function TeamMemberData:CanBlink()
  return self.blink == 1 or self.blink == true
end

function TeamMemberData:IsHireMember()
  if self.cat == nil then
    return false
  end
  return self.cat ~= 0
end

function TeamMemberData:IsDoram()
  local profData = self.profession and Table_Class[self.profession]
  return profData ~= nil and profData.Race == 2
end

function TeamMemberData:UpdateHireMemberInfo()
  if self.cat ~= nil then
    self.catdata = Table_MercenaryCat[self.cat]
    if self.catdata then
      local MonsterID = self.catdata.MonsterID
      local monsterData = MonsterID and Table_Monster[MonsterID]
      if monsterData then
        self.name = OverSea.LangManager.Instance():GetLangByKey(monsterData.NameZh)
        self.profession = nil
        self.body = monsterData.Body
        self.hair = monsterData.Hair
        self.eye = monsterData.Eye
        self.rightWeapon = monsterData.RightHand
        self.leftWeapon = monsterData.LeftHand
        self.head = monsterData.Head
        self.back = monsterData.Wing
        self.face = monsterData.Face
        self.mouth = monsterData.Mount
        self.tail = monsterData.tail
      end
    end
  else
    self.catdata = nil
  end
end

function TeamMemberData:UpdateFakeNpcMemberInfo()
  if self.fake_npc ~= nil then
    local MonsterID = self.fake_npc
    local monsterData = MonsterID and Table_Npc[MonsterID]
    if monsterData then
      self.name = OverSea.LangManager.Instance():GetLangByKey(monsterData.NameZh)
      self.body = monsterData.Body
      self.hair = monsterData.Hair
      self.eye = monsterData.Eye
      self.rightWeapon = monsterData.RightHand
      self.leftWeapon = monsterData.LeftHand
      self.head = monsterData.Head
      self.back = monsterData.Wing
      self.face = monsterData.Face
      self.mouth = monsterData.Mount
      self.tail = monsterData.tail
    end
    self.fakeNpcdata = monsterData
  else
    self.fakeNpcdata = nil
  end
end

function TeamMemberData:GetRealTimeVoice()
  return self.realtimevoice or 1
end

function TeamMemberData:SetMasterName(mastername)
  self.mastername = mastername
end

function TeamMemberData:GetZoneId()
  local changeZoneProxy = ChangeZoneProxy.Instance
  return changeZoneProxy:GetSimpleZoneId(changeZoneProxy:GetZoneId(self.zoneid, self.realzoneid))
end

function TeamMemberData:SetRestTime(time)
  self.resttime = time or 0
end

function TeamMemberData:SetGroupTeamIndex(groupTeamIndex)
  self.groupTeamIndex = groupTeamIndex
end

function TeamMemberData:SetDisneyPrepareState()
  local isPrepared = DisneyStageProxy.Instance:IsPrepared(self.id)
  self.disneyPreparedState = isPrepared and DisneyStageProxy.ETeamPrepareStatus.EPrepared or DisneyStageProxy.ETeamPrepareStatus.EPreparing
end

function TeamMemberData:GetDisneyPrepareState()
  return self.disneyPreparedState or DisneyStageProxy.ETeamPrepareStatus.EError
end

function TeamMemberData:GetRole()
  return self.role
end

function TeamMemberData:IsRobotMember()
  if not self.robot then
    return false
  end
  return self.robot ~= 0
end

function TeamMemberData:UpdateRobotMemberInfo()
  if self.robot ~= nil then
    self.robotData = Table_RobotNpc[self.robot]
    if self.robotData then
      local MonsterID = self.robotData.MonsterID
      local monsterData = MonsterID and Table_Monster[MonsterID]
      if monsterData then
        self.name = OverSea.LangManager.Instance():GetLangByKey(monsterData.NameZh)
        self.profession = self.robotData.Profession
        self.body = monsterData.Body
        self.hair = monsterData.Hair
        self.eye = monsterData.Eye
        self.rightWeapon = monsterData.RightHand
        self.leftWeapon = monsterData.LeftHand
        self.head = monsterData.Head
        self.back = monsterData.Wing
        self.face = monsterData.Face
        self.mouth = monsterData.Mount
        self.tail = monsterData.tail
      end
    end
  else
    self.robot = nil
  end
end

function TeamMemberData:GetPos()
  return self.pos
end

function TeamMemberData:Exit()
  LuaVector3.Destroy(self.pos)
  self.pos = nil
  self.pos_seted = false
end

function TeamMemberData:IsValidForAutoLock()
  if not TeamProxy.Instance:IHaveTeam() then
    return false
  end
  if self:IsHireMember() then
    return false
  end
  if self:IsRobotMember() then
    return true
  end
  local myTeam = TeamProxy.Instance.myTeam
  local myGuid = Game.Myself.data.id
  local nowMapid = Game.MapManager:GetMapID()
  local mymData = myTeam:GetMemberByGuid(myGuid)
  if self.mapid ~= nowMapid and self.raid ~= nowMapid or self.offline == 1 or mymData and mymData.sceneid ~= self.sceneid then
    return false
  end
  return true
end

function TeamMemberData:IsTeamNpc()
  if not self.teamnpc then
    return false
  end
  return self.teamnpc ~= 0
end

function TeamMemberData:UpdateTeamNpcInfo()
  if self.teamnpc ~= nil then
    local MonsterID = self.teamnpc
    local monsterData = MonsterID and Table_Monster[MonsterID]
    if monsterData then
      self.name = OverSea.LangManager.Instance():GetLangByKey(monsterData.NameZh)
      self.body = monsterData.Body
      self.hair = monsterData.Hair
      self.eye = monsterData.Eye
      self.haircolor = monsterData.HeadDefaultColor
      self.rightWeapon = 0
      self.leftWeapon = 0
      self.head = monsterData.Head
      self.back = monsterData.Wing
      self.face = monsterData.Face
      self.mouth = monsterData.Mount
      self.tail = monsterData.tail
    end
  else
    self.teamnpc = nil
  end
end

function TeamMemberData:IsAnonymous()
  return self.anonymous and self.anonymous ~= 0 or false
end

function TeamMemberData:GetName()
  if self:IsAnonymous() then
    return FunctionAnonymous.Me():GetAnonymousName(self.profession)
  end
  return self.name
end
