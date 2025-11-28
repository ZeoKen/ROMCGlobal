autoImport("PVEFactory")
autoImport("PVPFactory")
DungeonManager = class("DungeonManager")
DungeonManager.Event = {
  Launched = "DungeonManager_Launched"
}
local PVERaidConfig = {
  Pve_Card = {
    Type = 28,
    DungeonSpawner = PVEFactory.GetPveCard
  },
  AltMan = {
    Type = 31,
    DungeonSpawner = PVEFactory.GetAltMan
  },
  PVE_ExpRaid = {
    Type = 34,
    DungeonSpawner = PVEFactory.GetExpRaid
  },
  Pve_Thanatos_First = {
    Type = 35,
    DungeonSpawner = PVEFactory.GetThanatos
  },
  Pve_Thanatos_Second = {
    Type = 36,
    DungeonSpawner = PVEFactory.GetThanatos
  },
  IPRaid = {
    Type = 39,
    DungeonSpawner = PVEFactory.GetIPRaid
  },
  Pve_Thanatos_Third = {
    Type = 38,
    DungeonSpawner = PVEFactory.GetThanatos
  },
  Pve_Thanatos_Fourth = {
    Type = 40,
    DungeonSpawner = PVEFactory.GetThanatos
  },
  PVE_ThanksgivingRaid = {
    Type = 42,
    DungeonSpawner = PVEFactory.GetThanksgivingRaid
  },
  PVE_HeadwearRaid = {
    Type = 43,
    DungeonSpawner = PVEFactory.GetHeadwearRaid
  },
  PVE_Roguelike = {
    Type = 46,
    DungeonSpawner = PVEFactory.GetRoguelike
  },
  MiniGame_MonsterQA = {
    Type = FuBenCmd_pb.ERAIDTYPE_MONSTER_ANSWER,
    DungeonSpawner = PVEFactory.GetMiniGame_MonsterQA
  },
  MiniGame_MonsterShot = {
    Type = FuBenCmd_pb.ERAIDTYPE_MONSTER_PHOTO,
    DungeonSpawner = PVEFactory.GetMiniGame_MonsterShot
  },
  PVE_DeadBoss = {
    Type = FuBenCmd_pb.ERAIDTYPE_DEADBOSS,
    DungeonSpawner = PVEFactory.GetDeadBoss
  },
  PVE_Einherjar = {
    Type = FuBenCmd_pb.ERAIDTYPE_EINHERJAR,
    DungeonSpawner = PVEFactory.GetEinherjar
  },
  PVE_EndlessTowerPrivate = {
    Type = FuBenCmd_pb.ERAIDTYPE_ENDLESSTOWER_PRIVATE,
    DungeonSpawner = PVEFactory.GetEndlessTowerPrivate
  },
  PVE_ChasingScene = {
    Type = FuBenCmd_pb.ERAIDTYPE_QTE_CHASING,
    DungeonSpawner = PVEFactory.GetChasingScene
  },
  PVE_ComodoRaid = {
    Type = FuBenCmd_pb.ERAIDTYPE_COMODO_TEAM_RAID,
    DungeonSpawner = PVEFactory.GetComodoRaid
  },
  PVE_SevenRoyals = {
    Type = FuBenCmd_pb.ERAIDTYPE_SEVEN_ROYAL_TEAM_RAID,
    DungeonSpawner = PVEFactory.GetSevenRoyals
  },
  PVE_HeartLock = {
    Type = FuBenCmd_pb.ERAIDTYPE_HEART_LOCK,
    DungeonSpawner = PVEFactory.GetHeartLockRaid
  },
  PVE_HeadWearActivity = {
    Type = FuBenCmd_pb.ERAIDTYPE_HEADWEARACTIVITY,
    DungeonSpawner = PVEFactory.GetHeadwearActivityRaid
  },
  PVE_Crack = {
    Type = FuBenCmd_pb.ERAIDTYPE_CRACK,
    DungeonSpawner = PVEFactory.GetCrackRaid
  },
  PVE_Element = {
    Type = FuBenCmd_pb.ERAIDTYPE_ELEMENT,
    DungeonSpawner = PVEFactory.GetElementRaid
  },
  PVE_StarArk = {
    Type = FuBenCmd_pb.ERAIDTYPE_STAR_ARK,
    DungeonSpawner = PVEFactory.GetStarArkRaid
  },
  GVG_Lobby = {
    Type = FuBenCmd_pb.ERAIDTYPE_GVG_LOBBY,
    DungeonSpawner = PVEFactory.GetGvgLobby
  },
  GVG_Lobby_DateBattle = {
    Type = FuBenCmd_pb.ERAIDTYPE_GUILD_DATE_BATTLE_LOBBY,
    DungeonSpawner = PVEFactory.GetGvgLobbyDateBattle
  },
  PVE_BossRaid = {
    Type = FuBenCmd_pb.ERAIDTYPE_BOSS,
    DungeonSpawner = PVEFactory.GetBossRaid
  },
  PVE_EquipUp = {
    Type = FuBenCmd_pb.ERAIDTYPE_EQUIP_UP,
    DungeonSpawner = PVEFactory.GetSevenRoyals
  },
  PVE_MemoryPalace = {
    Type = FuBenCmd_pb.ERAIDTYPE_MEMORY_PALACE,
    DungeonSpawner = PVEFactory.GetSevenRoyals
  },
  PVE_AstralRaid = {
    Type = FuBenCmd_pb.ERAIDTYPE_ASTRAL,
    DungeonSpawner = PVEFactory.GetAstralRaid
  },
  PVE_MemoryRaid = {
    Type = FuBenCmd_pb.ERAIDTYPE_MEMORY_RAID,
    DungeonSpawner = PVEFactory.GetSevenRoyals
  },
  PVE_HeroJourney = {
    Type = FuBenCmd_pb.ERAIDTYPE_HERO_JOURNEY,
    DungeonSpawner = PVEFactory.GetHeroJourney
  },
  PVE_SpaceTimeIllusion = {
    Type = FuBenCmd_pb.ERAIDTYPE_SPACETIME_ILLUSION,
    DungeonSpawner = PVEFactory.GetSpaceTimeIllusion
  }
}
local PVPRaidConfig = {
  PVP_ChaosFight = {
    Type = 21,
    DungeonSpawner = PVPFactory.GetSinglePVP
  },
  PVP_TwoTeamFight = {
    Type = 22,
    DungeonSpawner = PVPFactory.GetTwoTeamPVP
  },
  PVP_TeamsFight = {
    Type = 23,
    DungeonSpawner = PVPFactory.GetTeamsPVP
  },
  PVP_PoringFight = {
    Type = 25,
    DungeonSpawner = PVPFactory.GetPoringFight
  },
  PVP_MvpFight = {
    Type = 29,
    DungeonSpawner = PVPFactory.GetMvpFight
  },
  PVP_TeamPws = {
    Type = 32,
    DungeonSpawner = PVPFactory.GetTeamPws
  },
  PVP_TeamPws_Othello = {
    Type = 44,
    DungeonSpawner = PVPFactory.GetTeamPwsOthello
  },
  PVP_TransferFight = {
    Type = 49,
    DungeonSpawner = PVPFactory.GetTransferFight
  },
  PVP_Team_Twelve = {
    Type = FuBenCmd_pb.ERAIDTYPE_TWELVE_PVP,
    DungeonSpawner = PVPFactory.GetTeamTwelve
  },
  PVP_3Teams = {
    Type = FuBenCmd_pb.ERAIDTYPE_TRIPLE_PVP,
    DungeonSpawner = PVPFactory.GetPVP3Teams
  },
  PVP_EndlessBattleField = {
    Type = FuBenCmd_pb.ERAIDTYPE_ENDLESS_BATTLE_FIELD,
    DungeonSpawner = PVPFactory.GetPVPEndlessBattleField
  }
}
local GVGRaidConfig = {
  GVG_GuildMetalFight = {
    Type = 14,
    DungeonSpawner = PVPFactory.GetGuildMetalGVG
  },
  GVG_Droiyan = {
    Type = 30,
    DungeonSpawner = PVPFactory.GetGvgDroiyan
  },
  GVG_Date_Battle = {
    Type = 77,
    DungeonSpawner = PVPFactory.GetGuildDateBattle
  }
}
local GuildArea_DungeonID = 10001
MirrorRaidConfig = {
  [1003113] = {
    Type = FuBenCmd_pb.ERAIDTYPE_MONSTER_ANSWER,
    DungeonSpawner = PVEFactory.GetMiniGame_MonsterQA
  },
  [1003114] = {
    Type = FuBenCmd_pb.ERAIDTYPE_MONSTER_PHOTO,
    DungeonSpawner = PVEFactory.GetMiniGame_MonsterShot
  }
}
DemoRaidConfig = {
  [40000] = {
    Type = 40000,
    DungeonSpawner = PVEFactory.GetDemoRaid
  },
  [41000] = {
    Type = 41000,
    DungeonSpawner = PVEFactory.GetDemoRaid
  }
}
local EndlessTowerType = FuBenCmd_pb.ERAIDTYPE_TOWER
local HeadwearRaidType = FuBenCmd_pb.ERAIDTYPE_HEADWEAR

function DungeonManager:ctor()
  self.dungeons = {}
  self:_InitPVEDungeons()
  self:_InitPVPDungeons()
  self:_InitMirrorDungeons()
  self:InitDemoDungeon()
  self:_Reset()
end

function DungeonManager:_InitPVEDungeons()
  self.pveType = {}
  for k, v in pairs(PVERaidConfig) do
    self.dungeons[v.Type] = v.DungeonSpawner()
    self.pveType[v.Type] = 1
  end
end

function DungeonManager:_InitPVPDungeons()
  self.pvpType = {}
  for k, v in pairs(PVPRaidConfig) do
    self.dungeons[v.Type] = v.DungeonSpawner()
    self.pvpType[v.Type] = 1
  end
  for k, v in pairs(GVGRaidConfig) do
    self.dungeons[v.Type] = v.DungeonSpawner()
    self.pvpType[v.Type] = 1
  end
end

function DungeonManager:_InitMirrorDungeons()
  for k, v in pairs(MirrorRaidConfig) do
    self.dungeons[v.Type] = v.DungeonSpawner()
  end
end

function DungeonManager:InitDemoDungeon()
  for k, v in pairs(DemoRaidConfig) do
    self.dungeons[v.Type] = v.DungeonSpawner()
  end
end

function DungeonManager:_Reset()
  self.running = false
  self.raidID = 0
  self.currentDungeon = nil
  self.isPVPRaid = false
  self.isEndlessTower = false
end

function DungeonManager:IsPVPRaidMode()
  return self.currentDungeon ~= nil and self.isPVPRaid
end

function DungeonManager:IsGVG_Detailed()
  return self:IsGVGMetal() or self:IsGVG_DateBattle()
end

function DungeonManager:IsGVGMetal()
  return self.currentDungeon ~= nil and self.currentDungeon.isGVG
end

function DungeonManager:IsGVG_DateBattle()
  return self.currentDungeon ~= nil and self.currentDungeon.isGuildDateBattle
end

function DungeonManager:IsGVG_Lobby()
  return self:GetRaidType() == FuBenCmd_pb.ERAIDTYPE_GVG_LOBBY
end

function DungeonManager:GVG_Lobby_Transfer(isMyCity)
  if not self.currentDungeon or not self.currentDungeon.TryMoveToCity then
    return
  end
  self.currentDungeon:TryMoveToCity(true, isMyCity)
end

function DungeonManager:GetLobbyMode()
  return self.currentDungeon and self.currentDungeon.GetMode and self.currentDungeon:GetMode() or 1
end

function DungeonManager:IsGVG_Lobby_Date_Battle()
  return self:GetRaidType() == FuBenCmd_pb.ERAIDTYPE_GUILD_DATE_BATTLE_LOBBY
end

function DungeonManager:IsPVPMode_PoringFight()
  return self.currentDungeon ~= nil and self.currentDungeon.isPoringFight or false
end

function DungeonManager:IsPVPMode_MvpFight()
  return self.currentDungeon ~= nil and self.currentDungeon.isMvpFight or false
end

function DungeonManager:IsPVPMode_TeamPwsExcludeOthello()
  return self.currentDungeon ~= nil and self.currentDungeon.isTeamPws or false
end

function DungeonManager:IsPVPMode_TeamPws()
  return self.currentDungeon ~= nil and (self.currentDungeon.isTeamPws or self.currentDungeon.isTeamPwsOthello) or false
end

function DungeonManager:IsTeamPwsFire()
  if self:IsPVPMode_TeamPws() then
    return self.currentDungeon:CheckIsFire()
  end
  return false
end

function DungeonManager:IsPVPMode_TeamPwsOthello()
  return self.currentDungeon ~= nil and self.currentDungeon.isTeamPwsOthello or false
end

function DungeonManager:IsPVPMode_TransferFight()
  return self.currentDungeon ~= nil and self.currentDungeon.isTransferFight or false
end

function DungeonManager:IsPVPMode_3Teams()
  return self.currentDungeon and self.currentDungeon.isPVP3Teams or false
end

function DungeonManager:IsPveMode_PveCard()
  return self.currentDungeon ~= nil and self.currentDungeon.isPveCard or false
end

function DungeonManager:IsHeroJournery()
  return nil ~= self.currentDungeon and self.currentDungeon.isHeroJourney or false
end

function DungeonManager:IsGvgMode_Droiyan()
  return self.currentDungeon ~= nil and self.currentDungeon.isGvgDroiyan or false
end

function DungeonManager:IsPveMode_AltMan()
  return self.currentDungeon ~= nil and self.currentDungeon.isAltman or false
end

function DungeonManager:IsPVEMode_ExpRaid()
  return self.currentDungeon ~= nil and self.currentDungeon.isExpRaid or false
end

function DungeonManager:IsPVEMode_HeadwearRaid()
  return self.currentDungeon ~= nil and self.currentDungeon.isHeadwearRaid or false
end

function DungeonManager:IsPVEMode_Roguelike()
  return self.currentDungeon ~= nil and self.currentDungeon.isRoguelike or false
end

function DungeonManager:IsPVEMode_MonsterQA()
  return self.currentDungeon ~= nil and self.currentDungeon.isMiniGame_MonsterQA or false
end

function DungeonManager:IsPVEMode_MonsterShot()
  return self.currentDungeon ~= nil and self.currentDungeon.isMonsterShot or false
end

function DungeonManager:IsPVEMode_DeadBoss()
  return self.currentDungeon ~= nil and self.currentDungeon.isDeadBoss or false
end

function DungeonManager:IsPVEMode_Einherjar()
  return self.currentDungeon ~= nil and self.currentDungeon.isEinherjar or false
end

function DungeonManager:IsPVEMode_EndlessTowerPrivate()
  return self.currentDungeon ~= nil and self.currentDungeon.isEndlessTowerPrivate or false
end

function DungeonManager:IsPVEMode_ChasingScene()
  return self.currentDungeon ~= nil and self.currentDungeon.isChasingScene or false
end

function DungeonManager:IsPVEMode_SpaceTimeIllusion()
  return self.currentDungeon ~= nil and self.currentDungeon.isSpaceTimeIllusionRaid or false
end

function DungeonManager:IsPveMode_Arena()
  local currentDungeon = self.currentDungeon
  if currentDungeon ~= nil then
    return currentDungeon.isSinglePVP or currentDungeon.isTwoTeamPVP or currentDungeon.isTeamsPVP
  end
  return false
end

function DungeonManager:IsPvpMode_DesertWolf()
  return self.currentDungeon ~= nil and self.currentDungeon.isTwoTeamPVP or false
end

function DungeonManager:IsPveMode_Thanatos()
  return self.currentDungeon ~= nil and self.currentDungeon.isThanatos or false
end

function DungeonManager:IsPVEMode_ThanksgivingRaid()
  return self.currentDungeon ~= nil and self.currentDungeon.isThanksgivingRaid or false
end

function DungeonManager:IsNoSelectTarget()
  return self.isPVPRaid
end

function DungeonManager:IsEndlessTower()
  return self.isEndlessTower
end

function DungeonManager:IsPveMode_IPRaid()
  return self.currentDungeon ~= nil and self.currentDungeon.isIPRaid or false
end

function DungeonManager:IsPvPMode_TeamTwelve()
  return self.currentDungeon ~= nil and self.currentDungeon.isTeamTwelve or false
end

function DungeonManager:IsPVEMode_ComodoRaid()
  return self.currentDungeon ~= nil and self.currentDungeon.isComodoRaid or false
end

function DungeonManager:IsPVEMode_MultiBossRaid()
  return self.currentDungeon ~= nil and self.currentDungeon.isMultiBossRaid or false
end

function DungeonManager:IsPVEMode_HeartLockRaid()
  return self.currentDungeon ~= nil and self.currentDungeon.isHeartLockRaid or false
end

function DungeonManager:IsPVEMode_CrackRaid()
  return self.currentDungeon ~= nil and self.currentDungeon.isCrackRaid or false
end

function DungeonManager:IsPVEMode_DemoRaid()
  return self.currentDungeon ~= nil and self.currentDungeon.isDemoRaid or false
end

function DungeonManager:IsPVEMode_BossScene()
  return self.currentDungeon ~= nil and self.currentDungeon.isBossRaid or false
end

function DungeonManager:IsPVEMode_Element()
  return self.currentDungeon ~= nil and self.currentDungeon.isElementRaid or false
end

function DungeonManager:IsPVEMode_StarArk()
  return self.currentDungeon ~= nil and self.currentDungeon.isStarArkRaid or false
end

function DungeonManager:IsPVPMode_EndlessBattleField()
  return self.currentDungeon and self.currentDungeon.isPVPEBF or false
end

function DungeonManager:IsPVEMode_AstralRaid()
  return self.currentDungeon and self.currentDungeon.isAstralRaid or false
end

function DungeonManager:GetRaidType()
  local data = Table_MapRaid[self.raidID]
  if data then
    return data.Type
  end
  return nil
end

function DungeonManager:SetRaidID(raidID)
  Debug_AssertFormat(not self.running, "Dungeon is running: SetRaidID({0})", raidID)
  local raidInfo = Table_MapRaid[raidID]
  if not raidInfo then
    redlog("Cannot find raidID", raidID)
    return
  end
  local raidType = raidInfo.Type
  if DemoRaidConfig[raidID] then
    raidType = raidID
  end
  self.raidID = raidID
  redlog("DungeonManager:SetRaidID raidType: ", raidType)
  self.currentDungeon = self.dungeons[raidType]
  self.isPVPRaid = self.pvpType[raidType] and true or false
  self.isFromNewPveEntrance = PveEntranceProxy.Instance:IsNewEntrancePveByRaidType(raidType)
  self.isEndlessTower = raidType == FuBenCmd_pb.ERAIDTYPE_TOWER
  self.isHeadwearRaid = raidType == FuBenCmd_pb.ERAIDTYPE_HEADWEAR or raidType == FuBenCmd_pb.ERAIDTYPE_HEADWEARACTIVITY
end

function DungeonManager:Launch()
  if self.running then
    return
  end
  self.running = true
  if self.raidID and self.raidID == 60702 then
    self:CameraDisable({0})
    self:CameraEnable({1})
  end
  if nil ~= self.currentDungeon then
    self.currentDungeon:Launch(self.raidID)
  else
    redlog("self.currentDungeon Launch failed .raidID: ", self.raidID)
  end
  if self.isFromNewPveEntrance then
    FunctionPve.Me():TryReset()
  end
  EventManager.Me():PassEvent(DungeonManager.Event.Launched)
end

function DungeonManager:Shutdown()
  if not self.running then
    return
  end
  self.running = false
  if nil ~= self.currentDungeon then
    self.currentDungeon:Shutdown()
  end
  if self.raidID == GuildArea_DungeonID then
    GuildProxy.Instance:ClearGuildGateInfo()
  end
  self:_Reset()
end

function DungeonManager:Update(time, deltaTime)
  if not self.running then
    return
  end
  if nil ~= self.currentDungeon then
    self.currentDungeon:Update(time, deltaTime)
  end
end

function DungeonManager:CameraEnable(grp)
  if grp then
    local cameraPointManager = CameraPointManager.Instance
    for i = 1, #grp do
      cameraPointManager:EnableGroup(grp[i])
    end
  end
end

function DungeonManager:CameraDisable(grp)
  if grp then
    local cameraPointManager = CameraPointManager.Instance
    for i = 1, #grp do
      cameraPointManager:DisableGroup(grp[i])
    end
  end
end

function DungeonManager:IsInGuildArea()
  return self.raidID == GuildArea_DungeonID
end

function DungeonManager:IsRunning()
  return self.running
end
