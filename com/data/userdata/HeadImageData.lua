HeadImageData = class("HeadImageData")
HeadImageIconType = {
  None = -1,
  Default = 0,
  Avatar = 1,
  Simple = 2
}
HeadImageData.DefaultFace = "DefaultFace"

function HeadImageData:ctor()
  self:Reset()
end

function HeadImageData:IsEmpty()
  if self.iconData == nil then
    return true
  end
  return self.iconData.type == HeadImageIconType.None
end

function HeadImageData:Reset()
  self.head = HeadImageData.DefaultFace
  if self.iconData then
    TableUtility.TableClear(self.iconData)
  else
    self.iconData = {}
  end
  self.iconData.type = HeadImageIconType.None
  self.iconData.id = nil
  self.iconData.hairID = nil
  self.iconData.haircolor = nil
  self.iconData.bodyID = nil
  self.iconData.gender = nil
  self.iconData.icon = ""
  self.iconData.eyeID = nil
  self.hide = nil
  self.level = 1
  self.profession = 1
  self.vip = 1
  self.name = "NO NAME"
  self.hp = 1
  self.sp = 1
  self.zoneid = 0
  self.iconData.portraitframe = 0
  self.iconData.isMyself = 0
  self.isMonster = false
  self.nature = nil
  self.natureLv = 1
end

function HeadImageData:TransByMyself()
  self:TransformByCreature(Game.Myself)
end

function HeadImageData:TransByLPlayer(lplayer)
  self:TransformByCreature(lplayer)
end

function HeadImageData:TransByMyselfWithCustomJob(customjob)
  self:TransformByCreatureWithCustomJob(Game.Myself, customjob)
  local currentRace = ProfessionProxy.IsDoramRace(Game.Myself.data.userdata:Get(UDEnum.PROFESSION))
  local customRace = ProfessionProxy.IsDoramRace(customjob)
  if currentRace ~= customRace then
    local raceSelfHair, raceSelfEye = ProfessionProxy.Instance:GetProfessionRaceFaceInfo(customRace and 2 or 1)
    self.iconData.hairID = raceSelfHair
    self.iconData.eyeID = raceSelfEye
    self.iconData.bodyID = self.iconData.gender == 1 and Table_Class[customjob].MaleBody or Table_Class[customjob].FemaleBody
  end
end

function HeadImageData:TransformByCreatureWithCustomJob(creature, customjob)
  if creature == nil then
    return
  end
  self.camp = creature.data:GetCamp()
  self.name = creature.data.name
  local userdata = creature.data.userdata
  if creature:GetCreatureType() == Creature_Type.Npc then
    if creature.data:IsMonster() then
      self:TransByMonsterData(creature.data.staticData, creature)
    elseif creature.data:IsNpc() then
      self:TransByNpcData(creature.data.staticData)
    end
    if userdata then
      local level = creature.data:GetBaseLv()
      if level then
        self.level = level
      end
    end
  elseif (creature:GetCreatureType() == Creature_Type.Player or creature:GetCreatureType() == Creature_Type.Me) and userdata then
    local userdata = creature.data.userdata
    local portrait = userdata:Get(UDEnum.PORTRAIT)
    local portraitData = Table_HeadImage[portrait]
    if creature.data:IsTransformed() then
      local monsterId = creature.data.props:GetPropByName("TransformID"):GetValue()
      if monsterId then
        local monsterIcon
        if Table_Monster[monsterId] then
          monsterIcon = Table_Monster[monsterId].Icon
        elseif Table_Npc[monsterId] then
          monsterIcon = Table_Npc[monsterId].Icon
        end
        if monsterIcon then
          self.iconData.type = HeadImageIconType.Simple
          self.iconData.icon = monsterIcon
        end
      end
    elseif portrait and portrait ~= 0 and portraitData and portraitData.Picture then
      self.iconData.type = HeadImageIconType.Simple
      self.iconData.icon = portraitData.Picture
      self.iconData.frameType = portraitData.Frame
    else
      self.iconData.type = HeadImageIconType.Avatar
      self.iconData.id = creature.data.id
      self.iconData.bodyID = userdata:Get(UDEnum.BODY)
      self.iconData.hairID = userdata:Get(UDEnum.HAIR)
      self.iconData.haircolor = userdata:Get(UDEnum.HAIRCOLOR)
      self.iconData.gender = userdata:Get(UDEnum.SEX)
      self.iconData.blink = creature.data:CanBlink()
      self.iconData.headID = userdata:Get(UDEnum.HEAD)
      self.iconData.faceID = userdata:Get(UDEnum.FACE)
      self.iconData.mouthID = userdata:Get(UDEnum.MOUTH)
      self.iconData.eyeID = userdata:Get(UDEnum.EYE)
    end
    if creature:GetCreatureType() == Creature_Type.Me then
      local myMemberData = TeamProxy.Instance:GetMyTeamMemberData()
      self.job = myMemberData and myMemberData.job
      self.groupTeamIndex = myMemberData and myMemberData.groupTeamIndex
      self.iconData.blink = FunctionPlayerHead.Me().blinkEnabled
    end
    self.level = creature.data:GetBaseLv()
    self.profession = customjob
  end
  local props = creature.data.props
  if props then
    local buffhp, buffmaxhp = creature.data:GetBuffHpVals()
    if buffhp then
      buffmaxhp = buffmaxhp or 1
      self.hp = buffhp / buffmaxhp
    else
      local hp = props:GetPropByName("Hp"):GetValue()
      local maxhp = props:GetPropByName("MaxHp"):GetValue()
      self.hp = hp / maxhp
    end
    local sp = props:GetPropByName("Sp"):GetValue()
    local maxSp = props:GetPropByName("MaxSp"):GetValue()
    self.sp = sp / maxSp
  end
end

function HeadImageData:TransformByCreature(creature)
  if creature == nil then
    return
  end
  self.camp = creature.data:GetCamp()
  self.name = GuildProxy.Instance:GetMercenaryGuildName(creature.data) or creature.data:GetName()
  self.isNpc = false
  self.nature = nil
  self.natureLv = 1
  self.creatureId = creature.data.id
  local userdata = creature.data.userdata
  self.prestigeLevel = userdata:Get(UDEnum.PRESTIGE_LEVEL)
  local creatureType = creature:GetCreatureType()
  if creatureType == Creature_Type.Npc then
    if creature.data:IsMonster() then
      if creature.data.isSkada then
        self:TransBySkadaData(creature)
      else
        self:TransByMonsterData(creature.data.staticData, creature)
      end
    elseif creature.data:IsNpc() then
      self.isNpc = true
      self:TransByNpcData(creature.data.staticData)
    elseif userdata then
      local level = creature.data:GetBaseLv()
      if level then
        self.level = level
      end
    end
    self.iconData.portraitframe = 0
    if creature.data:IsTripleTeamRobot() then
      self.profession = Game.TriplePvpRobotProfessionMap[creature.data.staticData.id]
    end
  elseif creature:GetCreatureType() == Creature_Type.Player or creature:GetCreatureType() == Creature_Type.Me then
    if userdata then
      local userdata = creature.data.userdata
      local portrait = userdata:Get(UDEnum.PORTRAIT)
      local portraitData = Table_HeadImage[portrait]
      if creature.data:IsTransformed() then
        local monsterId = creature.data.props:GetPropByName("TransformID"):GetValue()
        local monsterIcon = monsterId and Table_Monster[monsterId] and Table_Monster[monsterId].Icon
        if monsterIcon then
          self.iconData.type = HeadImageIconType.Simple
          self.iconData.icon = monsterIcon
        end
      elseif portrait and portrait ~= 0 and portraitData and portraitData.Picture then
        self.iconData.type = HeadImageIconType.Simple
        self.iconData.icon = portraitData.Picture
        self.iconData.frameType = portraitData.Frame
      else
        local isAnonymous = creature.data:IsAnonymous()
        self.iconData.type = HeadImageIconType.Avatar
        self.iconData.id = creature.data.id
        if isAnonymous then
          local classId = userdata:Get(UDEnum.PROFESSION)
          local gender = userdata:Get(UDEnum.SEX)
          FunctionAnonymous.Me():GetAnonymousHeadIconData(classId, gender, self.iconData)
        else
          self.iconData.bodyID = userdata:Get(UDEnum.BODY)
          self.iconData.hairID = userdata:Get(UDEnum.HAIR)
          self.iconData.haircolor = userdata:Get(UDEnum.HAIRCOLOR)
          self.iconData.gender = userdata:Get(UDEnum.SEX)
          self.iconData.blink = creature.data:CanBlink()
          self.iconData.headID = userdata:Get(UDEnum.HEAD)
          self.iconData.faceID = userdata:Get(UDEnum.FACE)
          self.iconData.mouthID = userdata:Get(UDEnum.MOUTH)
          self.iconData.eyeID = userdata:Get(UDEnum.EYE)
        end
        local monsterPortrait = userdata:Get(UDEnum.MONSTER_PORTRAIT)
        if monsterPortrait and monsterPortrait ~= 0 then
          local monsterIcon
          if Table_Monster[monsterPortrait] and Table_Monster[monsterPortrait].Icon ~= "" then
            monsterIcon = Table_Monster[monsterPortrait].Icon
          elseif Table_Npc[monsterPortrait] and Table_Npc[monsterPortrait].Icon ~= "" then
            monsterIcon = Table_Npc[monsterPortrait].Icon
          else
            self.iconData.type = HeadImageIconType.Avatar
          end
          if monsterIcon then
            self.iconData.type = HeadImageIconType.Simple
            self.iconData.icon = monsterIcon
          else
            self.iconData.type = HeadImageIconType.Simple
            self.iconData.icon = "item_12929"
          end
        end
      end
      if creature:GetCreatureType() == Creature_Type.Me then
        local myMemberData = TeamProxy.Instance:GetMyTeamMemberData()
        self.job = myMemberData and myMemberData.job
        self.groupTeamIndex = myMemberData and myMemberData.groupTeamIndex
        self.iconData.blink = FunctionPlayerHead.Me().blinkEnabled
      end
      self.level = creature.data:GetBaseLv()
      self.profession = userdata:Get(UDEnum.PROFESSION)
      self.isMonster = false
      self.iconData.portraitframe = userdata:Get(UDEnum.PORTRAIT_FRAME) or 0
    end
  elseif creature.data:IsPippi() then
    self:TransByMonsterData(creature.data.staticData, creature)
  end
  local props = creature.data.props
  if props then
    local buffhp, buffmaxhp = creature.data:GetBuffHpVals()
    if buffhp then
      buffmaxhp = buffmaxhp or 1
      self.hp = buffhp / buffmaxhp
    else
      local hp = creature.data:GetHP()
      local maxhp = props:GetPropByName("MaxHp"):GetValue()
      self.hp = hp / maxhp
    end
    local sp = props:GetPropByName("Sp"):GetValue()
    local maxSp = props:GetPropByName("MaxSp"):GetValue()
    self.sp = sp / maxSp
  end
end

function HeadImageData:TransByNpcData(npcdata)
  if npcdata then
    if npcdata.Icon == "" then
      self.iconData.type = HeadImageIconType.Avatar
      self.iconData.bodyID = npcdata.Body
      self.iconData.hairID = npcdata.Hair
      self.iconData.haircolor = npcdata.HeadDefaultColor
      self.iconData.gender = npcdata.Gender
      self.iconData.eyeID = npcdata.Eye
      self.iconData.headID = npcdata.Head
      self.iconData.mouthID = npcdata.Mouth
      self.iconData.faceID = npcdata.Face
    else
      self.iconData.type = HeadImageIconType.Simple
      self.iconData.icon = npcdata.Icon
    end
    self.name = npcdata.NameZh
    self.profession = npcdata.Race
    self.level = npcdata.Level
    self.hide = npcdata.NoShowIcon == 1
  end
end

function HeadImageData:TransByMonsterData(monsterdata, creature)
  if monsterdata then
    self.iconData.type = HeadImageIconType.Simple
    self.iconData.icon = monsterdata.Icon
    self.name = monsterdata.NameZh
    self.profession = monsterdata.Race
    if NpcData.NpcDetailedType.PippiNpc ~= monsterdata.Type then
      if creature and creature.data then
        self.level = creature.data:GetBaseLv()
      else
        self.level = monsterdata.Level
      end
    else
      self.isPippi = true
    end
    self.nature = monsterdata.Nature
    self.natureLv = monsterdata.NatureLevel
    self.isMonster = true
    self.id = monsterdata.id
    self.hide = monsterdata.NoShowIcon == 1
  else
    self.nature = nil
    self.natureLv = nil
  end
end

function HeadImageData:TransBySkadaData(creature)
  local monsterdata = creature.data.staticData
  local isSpecMonster = false
  local furnitureData = HomeProxy.Instance:FindFurnitureData(creature.data.furnitureID)
  if furnitureData and furnitureData.woodType == EWOODTYPE.EWOODTYPE_SPEC_MONSTER then
    monsterdata = Table_Monster[furnitureData.woodMonsterId]
    isSpecMonster = true
  end
  self:TransByMonsterData(monsterdata)
  self.nature = self.nature or creature.data:GetNature()
  if isSpecMonster then
    self.natureLv = self.natureLv or 1
  else
    local dyn_nlv = creature.data:GetNatureLv()
    self.natureLv = dyn_nlv ~= 0 and dyn_nlv or 1
  end
end

function HeadImageData:TransByBokiData(boki)
  if boki then
    self.iconData.type = HeadImageIconType.Simple
    local bodyId = boki.data.userdata:Get(UDEnum.BODY)
    self.iconData.icon = bodyId and Table_Body[bodyId] and Table_Body[bodyId].Texture or ""
    self.name = boki.data.name
    self.level = boki.data.userdata:Get(UDEnum.ROLELEVEL) or 0
    self.isMonster = true
    self.id = boki.data.staticData.id
    self.nature = boki.data.staticData.Nature
    self.natureLv = boki.data.staticData.NatureLevel or 1
    self.guid = boki.data.id
  else
    self.nature = nil
    self.natureLv = 1
  end
end

function HeadImageData:TransByTeamMemberData(mdata, includeMyself)
  if not includeMyself and mdata.id == Game.Myself.data.id then
    self:TransByMyself()
    return
  end
  local headData = mdata.portrait and Table_HeadImage[mdata.portrait]
  if headData then
    self.iconData.type = HeadImageIconType.Simple
    self.iconData.icon = headData.Picture
    self.iconData.frameType = headData.Frame
  elseif mdata.catdata then
    local monsterID = mdata.catdata.MonsterID
    self:TransByNpcData(monsterID and Table_Monster[monsterID])
  elseif mdata.fakeNpcdata then
    local monsterID = mdata.fakeNpcdata.id
    self:TransByNpcData(monsterID and Table_Npc[monsterID])
  elseif mdata.robotData then
    local monsterID = mdata.robotData.MonsterID
    self:TransByNpcData(monsterID and Table_Monster[monsterID])
  elseif mdata.teamnpc and mdata.teamnpc then
    local monsterID = mdata.teamnpc
    self:TransByNpcData(monsterID and Table_Monster[monsterID])
    self.isMonster = true
  else
    self.iconData.type = HeadImageIconType.Avatar
    self.iconData.id = mdata.id
    if mdata:IsAnonymous() then
      local classId = mdata.profession
      local gender = mdata.gender
      FunctionAnonymous.Me():GetAnonymousHeadIconData(classId, gender, self.iconData)
    else
      self.iconData.bodyID = mdata.body
      self.iconData.hairID = mdata.hair
      self.iconData.haircolor = mdata.haircolor
      self.iconData.gender = mdata.gender
      self.iconData.blink = mdata:CanBlink()
      self.iconData.eyeID = mdata.eye
      self.iconData.headID = mdata.head
      self.iconData.faceID = mdata.face
      self.iconData.mouthID = mdata.mouth
    end
  end
  self.name = mdata:GetName()
  self.profession = mdata.profession
  self.level = mdata.baselv
  self.offline = mdata:IsOffline()
  self:ResetTeamHp(mdata)
  self:ResetTeamMp(mdata)
  self.job = mdata.job
  self.zoneid = mdata.zoneid
  self.groupTeamIndex = mdata.groupTeamIndex
  self.canExpire = mdata.expiretime and mdata.expiretime ~= 0
  self.iconData.portraitframe = mdata.portraitframe
  self.iconData.afk = mdata.afk
end

function HeadImageData:ResetTeamHp(mdata)
  if mdata.hp and mdata.hpmax then
    local hp = not self.offline and Game.SkillDynamicManager:GetDynamicProps(RoleDefines_Camp.FRIEND, SkillDynamicManager.Props.HP)
    hp = hp or mdata.hp
    self.hp = hp / mdata.hpmax
  else
    self.hp = 1
  end
end

function HeadImageData:ResetTeamMp(mdata)
  if mdata.sp and mdata.spmax then
    self.mp = mdata.sp / mdata.spmax
  else
    self.mp = 1
  end
end

function HeadImageData:TransByChatMessageData(cdata)
  local portrait = cdata:GetPortrait()
  local portraitData = Table_HeadImage[portrait]
  if portrait ~= 0 and portraitData and portraitData.Picture then
    self.iconData.type = HeadImageIconType.Simple
    self.iconData.icon = portraitData.Picture
    self.iconData.frameType = portraitData.Frame
  else
    self.iconData.type = HeadImageIconType.Avatar
    self.iconData.bodyID = cdata:GetBody()
    self.iconData.hairID = cdata:GetHair()
    self.iconData.haircolor = cdata:GetHaircolor()
    self.iconData.headID = cdata:GetHead()
    self.iconData.faceID = cdata:GetFace()
    self.iconData.mouthID = cdata:GetMouth()
    self.iconData.eyeID = cdata:GetEye()
    self.iconData.gender = cdata:GetGender()
    self.iconData.blink = cdata:GetBlink()
  end
  self.iconData.id = cdata:GetId()
  self.name = cdata:GetName()
  self.profession = cdata:GetProfession()
  self.level = cdata:GetLevel()
  self.iconData.portraitframe = cdata:GetPortraitFrame()
end

function HeadImageData:TransByChatZoneMemberData(cdata)
  local portraitData = Table_HeadImage[cdata.portrait]
  if cdata.portrait ~= 0 and portraitData and portraitData.Picture then
    self.iconData.type = HeadImageIconType.Simple
    self.iconData.icon = portraitData.Picture
    self.iconData.frameType = portraitData.Frame
  else
    self.iconData.type = HeadImageIconType.Avatar
    self.iconData.bodyID = cdata.bodyID
    self.iconData.hairID = cdata.hairID
    self.iconData.haircolor = cdata.haircolor
    self.iconData.gender = cdata.gender
    self.iconData.blink = cdata.blink
    self.iconData.eyeID = cdata.eyeID
  end
  self.iconData.id = cdata.id
  self.name = cdata.name
  self.profession = cdata.rolejob
  self.level = cdata.level
  self.iconData.portraitframe = cdata.portraitframe
end

function HeadImageData:TransByFriendData(frienddata)
  local portraitData = Table_HeadImage[frienddata.portrait]
  if frienddata.portrait ~= 0 and portraitData and portraitData.Picture then
    self.iconData.type = HeadImageIconType.Simple
    self.iconData.icon = portraitData.Picture
    self.iconData.frameType = portraitData.Frame
  else
    self.iconData.type = HeadImageIconType.Avatar
    self.iconData.bodyID = frienddata.bodyID
    self.iconData.hairID = frienddata.hairID
    self.iconData.headID = frienddata.headID
    self.iconData.faceID = frienddata.faceID
    self.iconData.mouthID = frienddata.mouthID
    self.iconData.eyeID = frienddata.eyeID
    self.iconData.haircolor = frienddata.haircolor
    self.iconData.gender = frienddata.gender
    self.iconData.blink = frienddata.blink
    self.iconData.portraitframe = frienddata.portraitframe
  end
  self.iconData.id = frienddata.id
  self.name = frienddata.name
  self.profession = frienddata.profession
  self.level = frienddata.level
end

function HeadImageData:TransByGuildApplyData(applyData)
  local portraitData = Table_HeadImage[applyData.portrait]
  if applyData.portrait ~= 0 and portraitData and portraitData.Picture then
    self.iconData.type = HeadImageIconType.Simple
    self.iconData.icon = portraitData.Picture
    self.iconData.frameType = portraitData.Frame
  else
    self.iconData.type = HeadImageIconType.Avatar
    self.iconData.bodyID = applyData.body
    self.iconData.hairID = applyData.hair
    self.iconData.headID = applyData.head
    self.iconData.faceID = applyData.face
    self.iconData.mouthID = applyData.mouth
    self.iconData.eyeID = applyData.eye
    self.iconData.haircolor = applyData.haircolor
    self.iconData.gender = applyData.gender
    self.iconData.portraitframe = applyData.portrait
  end
  self.iconData.id = applyData.id
  self.name = applyData.name
  self.profession = applyData.profession
  self.level = applyData.baselevel
end

function HeadImageData:TransByGuildMemberData(guildMember)
  local portraitData = guildMember.portrait and Table_HeadImage[guildMember.portrait]
  if portraitData then
    self.iconData.type = HeadImageIconType.Simple
    self.iconData.icon = portraitData.Picture
    self.iconData.frameType = portraitData.Frame
  else
    self.iconData.type = HeadImageIconType.Avatar
    self.iconData.id = guildMember.id
    self.iconData.bodyID = guildMember.body
    self.iconData.hairID = guildMember.hair
    self.iconData.haircolor = guildMember.haircolor
    self.iconData.headID = guildMember.head
    self.iconData.faceID = guildMember.face
    self.iconData.mouthID = guildMember.mouth
    self.iconData.eyeID = guildMember:GetEyeID()
    self.iconData.gender = guildMember.gender
    self.iconData.portraitframe = guildMember.portrait_frame
  end
  self.name = guildMember.name
  self.profession = guildMember.profession
  self.level = guildMember.baselevel
end

function HeadImageData:TransByClassData(clasData)
  self.iconData.type = HeadImageIconType.Avatar
  local userData = Game.Myself.data.userdata
  if userData then
    local gender = userData:Get(UDEnum.SEX)
    self.iconData.gender = gender
    if gender == ProtoCommon_pb.EGENDER_FEMALE then
      self.iconData.bodyID = clasData.FemaleBody
    else
      self.iconData.bodyID = clasData.MaleBody
    end
    self.profession = clasData.id
    self.iconData.hairID = userData:Get(UDEnum.HAIR)
    self.iconData.haircolor = userData:Get(UDEnum.HAIRCOLOR)
    local headID = userData:Get(UDEnum.HEAD) or nil
    local faceID = userData:Get(UDEnum.FACE) or nil
    local mouthID = userData:Get(UDEnum.MOUTH) or nil
    local eye = userData:Get(UDEnum.EYE) or nil
    self.iconData.headID = headID
    self.iconData.faceID = faceID
    self.iconData.mouthID = mouthID
    self.iconData.eyeID = eye
  end
end

function HeadImageData:TransByPetInfoData(petInfoData)
  if petInfoData == nil then
    return
  end
  local petid = petInfoData.petid
  if petid then
    self:TransByMonsterData(Table_Monster[petid])
  end
  self.iconData.type = HeadImageIconType.Simple
  self.iconData.icon = petInfoData:GetHeadIcon()
  self.name = petInfoData.name
  self.level = petInfoData.lv
  self.guid = petInfoData.guid
  self.creatureId = self.guid
end

function HeadImageData:TransByBeingInfoData(beingInfoData)
  if beingInfoData == nil then
    self:Reset()
    return
  end
  self.guid = beingInfoData.guid
  self.creatureId = self.guid
  self.beingid = beingInfoData.beingid
  self:TransByMonsterData(beingInfoData.staticData)
  self.iconData.type = HeadImageIconType.Simple
  self.iconData.icon = beingInfoData:GetHeadIcon()
  self.name = beingInfoData.name
  self.level = beingInfoData.lv
end

function HeadImageData:TransByPetEggData(petEggData)
  if not petEggData then
    return
  end
  local petid = petEggData.petid
  if petid then
    self:TransByMonsterData(Table_Monster[petid])
  end
  self.iconData.type = HeadImageIconType.Simple
  self.iconData.icon = petEggData:GetHeadIcon()
  self.name = petEggData.name
  self.level = petEggData.lv
end

function HeadImageData:TransByObserverPlayerData(observerPlayerInfo)
  local portrait_data = observerPlayerInfo.portrait_data
  if portrait_data then
    local portraitData = portrait_data.portrait and Table_HeadImage[portrait_data.portrait]
    if portraitData then
      self.iconData.type = HeadImageIconType.Simple
      self.iconData.icon = portraitData.Picture
      self.iconData.frameType = portraitData.Frame
    else
      self.iconData.type = HeadImageIconType.Avatar
      self.iconData.bodyID = portrait_data.body
      self.iconData.hairID = portrait_data.hair
      self.iconData.haircolor = portrait_data.haircolor
      self.iconData.headID = portrait_data.head
      self.iconData.faceID = portrait_data.face
      self.iconData.mouthID = portrait_data.mouth
      self.iconData.eyeID = portrait_data.eye
      self.iconData.gender = portrait_data.gender
    end
  end
  self.playerid = observerPlayerInfo.charid
  self.profession = observerPlayerInfo.profession
  self.level = observerPlayerInfo.level
  self.camp = observerPlayerInfo.camp
  self.name = observerPlayerInfo.name
  self.offline = not observerPlayerInfo.online
  self:ResetObserverHpSp(observerPlayerInfo.hpper, observerPlayerInfo.spper)
end

function HeadImageData:ResetObserverHpSp(hpper, spper)
  self.hp, self.mp = hpper, spper
end

function HeadImageData:SetObserverOfflineFlag()
  self.offline = true
end

function HeadImageData:TransByWeddingCharData(weddingCharData)
  local portraitData = weddingCharData.portrait and Table_HeadImage[weddingCharData.portrait]
  if portraitData then
    self.iconData.type = HeadImageIconType.Simple
    self.iconData.icon = portraitData.Picture
    self.iconData.frameType = portraitData.Frame
  else
    self.iconData.type = HeadImageIconType.Avatar
    self.iconData.id = weddingCharData.charid
    self.iconData.bodyID = weddingCharData.bodyID
    self.iconData.hairID = weddingCharData.hairID
    self.iconData.haircolor = weddingCharData.haircolor
    self.iconData.headID = weddingCharData.headID
    self.iconData.faceID = weddingCharData.faceID
    self.iconData.mouthID = weddingCharData.mouthID
    self.iconData.eyeID = weddingCharData.eyeID
    self.iconData.gender = weddingCharData.gender
  end
  self.name = weddingCharData.name
  self.profession = weddingCharData.profession
  self.level = weddingCharData.level
end

function HeadImageData:TransBySocialData(socialData)
  local portraitData = Table_HeadImage[socialData.portrait]
  if socialData.portrait ~= 0 and portraitData and portraitData.Picture then
    self.iconData.type = HeadImageIconType.Simple
    self.iconData.icon = portraitData.Picture
    self.iconData.frameType = portraitData.Frame
  else
    self.iconData.type = HeadImageIconType.Avatar
    self.iconData.bodyID = socialData.body
    self.iconData.hairID = socialData.hair
    self.iconData.haircolor = socialData.haircolor
    self.iconData.gender = socialData.gender
    self.iconData.blink = socialData.blink
    self.iconData.eyeID = socialData.eye
  end
  self.iconData.id = socialData.guid
  self.name = socialData.name
  self.profession = socialData.profession
  self.level = socialData.level
  self.iconData.afk = socialData.afk
end

function HeadImageData:TransByMatcherData(matcherdata)
  local portraitData = Table_HeadImage[matcherdata.portrait]
  if matcherdata.portrait ~= 0 and portraitData and portraitData.Picture then
    self.iconData.type = HeadImageIconType.Simple
    self.iconData.icon = portraitData.Picture
    self.iconData.frameType = portraitData.Frame
  else
    self.iconData.type = HeadImageIconType.Avatar
    self.iconData.bodyID = matcherdata.bodyID
    self.iconData.hairID = matcherdata.hairID
    self.iconData.headID = matcherdata.headID
    self.iconData.faceID = matcherdata.faceID
    self.iconData.mouthID = matcherdata.mouthID
    self.iconData.eyeID = matcherdata.eyeID
    self.iconData.haircolor = matcherdata.haircolor
    self.iconData.gender = matcherdata.gender
  end
  self.iconData.id = matcherdata.id
  self.name = matcherdata.name
  self.profession = matcherdata.profession
  self.level = matcherdata.level
end

function HeadImageData:TransByBossKillerData(bossKillerData)
  local userdata = bossKillerData.userdata
  local portraitData = Table_HeadImage[userdata.portrait]
  if userdata.portrait ~= 0 and portraitData and portraitData.Picture then
    self.iconData.type = HeadImageIconType.Simple
    self.iconData.icon = portraitData.Picture
    self.iconData.frameType = portraitData.Frame
  else
    self.iconData.type = HeadImageIconType.Avatar
    self.iconData.bodyID = userdata.body
    self.iconData.hairID = userdata.hair
    self.iconData.headID = userdata.head
    self.iconData.faceID = userdata.face
    self.iconData.mouthID = userdata.mouth
    self.iconData.eyeID = userdata.eye
    self.iconData.haircolor = userdata.haircolor
    self.iconData.gender = userdata.gender
    self.iconData.blink = userdata.blink
  end
  self.iconData.id = userdata.charid
  self.name = userdata.name
  self.profession = userdata.profession
  self.level = userdata.baselevel
end

function HeadImageData:TransByTeamPwsRankData(rankData)
  local portraitData = Table_HeadImage[rankData.portrait]
  if rankData.portrait ~= 0 and portraitData and portraitData.Picture then
    self.iconData.type = HeadImageIconType.Simple
    self.iconData.icon = portraitData.Picture
    self.iconData.frameType = portraitData.Frame
  else
    self.iconData.type = HeadImageIconType.Avatar
    self.iconData.bodyID = rankData.body
    self.iconData.hairID = rankData.hair
    self.iconData.headID = rankData.head
    self.iconData.faceID = rankData.face
    self.iconData.mouthID = rankData.mouth
    self.iconData.eyeID = rankData.eye
    self.iconData.haircolor = rankData.haircolor
    self.iconData.gender = rankData.gender
  end
  self.iconData.portraitframe = rankData.portrait_frame
  self.name = rankData.name
  self.profession = rankData.profession
end

function HeadImageData:TransByThanatosPlayerData(thanatosPlayerData)
  local userdata = thanatosPlayerData.portrait
  local portraitData = Table_HeadImage[userdata.portrait]
  if userdata.portrait ~= 0 and portraitData and portraitData.Picture then
    self.iconData.type = HeadImageIconType.Simple
    self.iconData.icon = portraitData.Picture
    self.iconData.frameType = portraitData.Frame
  else
    self.iconData.type = HeadImageIconType.Avatar
    self.iconData.bodyID = userdata.body
    self.iconData.hairID = userdata.hair
    self.iconData.headID = userdata.head
    self.iconData.faceID = userdata.face
    self.iconData.mouthID = userdata.mouth
    self.iconData.eyeID = userdata.eye
    self.iconData.haircolor = userdata.haircolor
    self.iconData.gender = userdata.gender
  end
  self.profession = thanatosPlayerData.profession
end

function HeadImageData:TransByDamageUserData(damageUserData)
  local portraitData = damageUserData.portrait and Table_HeadImage[damageUserData.portrait]
  if damageUserData.portrait ~= 0 and portraitData and portraitData.Picture then
    self.iconData.type = HeadImageIconType.Simple
    self.iconData.icon = portraitData.Picture
    self.iconData.frameType = portraitData.Frame
  else
    self.iconData.type = HeadImageIconType.Avatar
    self.iconData.bodyID = damageUserData.body
    self.iconData.hairID = damageUserData.hair
    self.iconData.eyeID = damageUserData.eye
    self.iconData.haircolor = damageUserData.haircolor
    self.iconData.gender = damageUserData.gender
    self.iconData.blink = damageUserData.blink
  end
  self.iconData.id = damageUserData.charid
  self.name = damageUserData.name
  self.profession = damageUserData.profession
  self.level = damageUserData.baselevel
end

function HeadImageData:TransByGuestVisitData(GuestData)
  local portraitData = GuestData.portrait and Table_HeadImage[GuestData.portrait]
  if GuestData.portrait ~= 0 and portraitData and portraitData.Picture then
    self.iconData.type = HeadImageIconType.Simple
    self.iconData.icon = portraitData.Picture
    self.iconData.frameType = portraitData.Frame
  else
    self.iconData.type = HeadImageIconType.Avatar
    self.iconData.bodyID = GuestData.body
    self.iconData.hairID = GuestData.hair
    self.iconData.headID = GuestData.head
    self.iconData.faceID = GuestData.face
    self.iconData.mouthID = GuestData.mouth
    self.iconData.eyeID = GuestData.eye
    self.iconData.haircolor = GuestData.haircolor
    self.iconData.gender = GuestData.gender
    self.iconData.blink = GuestData.blink
  end
  self.iconData.id = GuestData.charid
  self.name = GuestData.name
  self.profession = GuestData.profession
  self.level = GuestData.baselevel
  self.serverid = GuestData.serverid
end

function HeadImageData:TransByBattlePassRankShowData(socialData)
  local portraitData = Table_HeadImage[socialData.portrait]
  if socialData.portrait ~= 0 and portraitData and portraitData.Picture then
    self.iconData.type = HeadImageIconType.Simple
    self.iconData.icon = portraitData.Picture
    self.iconData.frameType = portraitData.Frame
  else
    self.iconData.type = HeadImageIconType.Avatar
    self.iconData.bodyID = socialData.bodyID
    self.iconData.hairID = socialData.hairID
    self.iconData.haircolor = socialData.haircolor
    self.iconData.gender = socialData.gender
    self.iconData.blink = socialData.blink
    self.iconData.eyeID = socialData.eyeID
    self.iconData.headID = socialData.headID
    self.iconData.faceID = socialData.faceID
    self.iconData.mouthID = socialData.mouthID
  end
  self.iconData.id = socialData.guid
  self.name = socialData.name
  self.profession = socialData.profession
  self.level = socialData.level
end

function HeadImageData:TransByRoguelikeRobotData(data)
  local robot_staticdata = data.robotid and Table_RobotNpc[data.robotid]
  local robot_monsterId = robot_staticdata and robot_staticdata.MonsterID
  local robot_monsterdata = robot_monsterId and Table_Monster[robot_monsterId]
  self:TransByMonsterData(robot_monsterdata)
  if robot_monsterdata then
    self.id = robot_staticdata.id
    self.name = robot_staticdata.RobotName
    self.profession = robot_staticdata.Profession
  end
  self.level = data.level
end

function HeadImageData:TransByRoguelikeUserData(data)
  local pData = data.portrait
  local portraitData = Table_HeadImage[pData.portrait]
  if pData.portrait ~= 0 and portraitData and portraitData.Picture then
    self.iconData.type = HeadImageIconType.Simple
    self.iconData.icon = portraitData.Picture
    self.iconData.frameType = portraitData.Frame
  else
    self.iconData.type = HeadImageIconType.Avatar
    self.iconData.bodyID = pData.body
    self.iconData.hairID = pData.hair
    self.iconData.headID = pData.head
    self.iconData.faceID = pData.face
    self.iconData.mouthID = pData.mouth
    self.iconData.eyeID = pData.eye
    self.iconData.haircolor = pData.haircolor
    self.iconData.gender = pData.gender
  end
  self.iconData.portraitframe = pData.portrait_frame
  self.iconData.id = data.charid
  self.name = data.name
  self.profession = data.profession
  self.level = data.level
end

function HeadImageData:TransByMiniGameRankData(rankData)
  local userdata = rankData.portrait
  local portraitData = Table_HeadImage[userdata.portrait]
  if userdata.portrait ~= 0 and portraitData and portraitData.Picture then
    self.iconData.type = HeadImageIconType.Simple
    self.iconData.icon = portraitData.Picture
    self.iconData.frameType = portraitData.Frame
  else
    self.iconData.type = HeadImageIconType.Avatar
    self.iconData.bodyID = userdata.body
    self.iconData.hairID = userdata.hair
    self.iconData.headID = userdata.head
    self.iconData.faceID = userdata.face
    self.iconData.mouthID = userdata.mouth
    self.iconData.eyeID = userdata.eye
    self.iconData.haircolor = userdata.haircolor
    self.iconData.gender = userdata.gender
  end
  self.iconData.portraitframe = userdata.portrait_frame
  self.name = rankData.name
  self.profession = rankData.profession
end

function HeadImageData:TransByWarbandData(warbandMemberData)
  local portraitData = warbandMemberData.portrait and Table_HeadImage[warbandMemberData.portrait]
  if portraitData then
    self.iconData.type = HeadImageIconType.Simple
    self.iconData.icon = portraitData.Picture
    self.iconData.frameType = portraitData.Frame
  else
    self.iconData.type = HeadImageIconType.Avatar
    self.iconData.id = warbandMemberData.id
    self.iconData.bodyID = warbandMemberData.bodyID
    self.iconData.hairID = warbandMemberData.hairID
    self.iconData.haircolor = warbandMemberData.haircolor
    self.iconData.headID = warbandMemberData.headID
    self.iconData.faceID = warbandMemberData.faceID
    self.iconData.mouthID = warbandMemberData.mouthID
    self.iconData.eyeID = warbandMemberData.eyeID
    self.iconData.gender = warbandMemberData.gender
  end
  self.name = warbandMemberData.name
  self.profession = warbandMemberData.profession
  self.level = warbandMemberData.level
end

function HeadImageData:TransByDisneyRankMemberData(disneyRankMember)
  self.name = disneyRankMember.name
  self.profession = disneyRankMember.profession
  self.level = disneyRankMember.level
  self.iconData.type = HeadImageIconType.Avatar
  self.iconData.id = disneyRankMember.id
  self.iconData.bodyID = disneyRankMember.bodyID
  self.iconData.hairID = disneyRankMember.hairID
  self.iconData.haircolor = disneyRankMember.haircolor
  self.iconData.headID = disneyRankMember.headID
  self.iconData.faceID = disneyRankMember.faceID
  self.iconData.mouthID = disneyRankMember.mouthID
  self.iconData.eyeID = disneyRankMember.eyeID
  self.iconData.gender = disneyRankMember.gender
end

function HeadImageData:TransByPortraitData(data)
  if not data then
    return
  end
  self.profession = data.profession
  local portraitData = data.portrait and Table_HeadImage[data.portrait]
  if portraitData then
    self.iconData.type = HeadImageIconType.Simple
    self.iconData.icon = portraitData.Picture
    self.iconData.frameType = portraitData.Frame
  else
    self.iconData.type = HeadImageIconType.Avatar
    self.iconData.bodyID = data.body
    self.iconData.hairID = data.hair
    self.iconData.haircolor = data.haircolor
    self.iconData.gender = data.gender
    self.iconData.headID = data.head
    self.iconData.faceID = data.face
    self.iconData.mouthID = data.mouth
    self.iconData.eyeID = data.eye
    self.iconData.portraitframe = data.portrait_frame
  end
end

function HeadImageData:SetCustomParam(key, value)
  if self._customParam == nil then
    self._customParam = {}
  end
  self._customParam[key] = value
end

function HeadImageData:GetCustomParam(key)
  if self._customParam == nil then
    return
  end
  return self._customParam[key]
end

function HeadImageData:TransByPippiData(pippi)
  if pippi == nil then
    return
  end
  local petid = pippi.petid
  if petid then
    self:TransByMonsterData(Table_Monster[petid])
  end
  self.iconData.type = HeadImageIconType.Simple
  self.guid = pippi.guid
  self.creatureId = self.guid
  self.level = nil
  self.isPippi = true
end
