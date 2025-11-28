autoImport("AutoAimMonsterData")
FunctionMonster = class("FunctionMonster")
FunctionMonster.Priority = {
  MVP = 1,
  MINI = 2,
  Monster = 3,
  RareElite = 4,
  WorldBoss = 5,
  PushMinion = 6,
  SiegeCar = 7,
  DefenseTower = 8,
  TwelveBase = 9,
  TwelveBarrack = 10,
  EBF_Robot = 11
}
local tempV3 = LuaVector3.New()

function FunctionMonster.Me()
  if nil == FunctionMonster.me then
    FunctionMonster.me = FunctionMonster.new()
  end
  return FunctionMonster.me
end

function FunctionMonster:ctor()
  self.monsterList = {}
  self.monsterStaticInfoMap = {}
  self.monsterStaticInfoList = {}
  EventManager.Me():AddEventListener(LoadSceneEvent.BeginLoadScene, self.OnBeginLoadScene, self)
  EventManager.Me():AddEventListener(LoadSceneEvent.FinishLoadScene, self.OnFinishLoadScene, self)
  self:InitIgnoreList()
end

function FunctionMonster:InitIgnoreList()
  if not self.monsterIgnoreList then
    self.monsterIgnoreList = {}
    if GameConfig.ObjectNpc then
      for i = 1, #GameConfig.ObjectNpc do
        self.monsterIgnoreList[GameConfig.ObjectNpc[i]] = true
      end
    end
  end
end

function FunctionMonster:FilterMonster(ignoreSkill)
  TableUtility.ArrayClear(self.monsterList)
  local userMap = NSceneNpcProxy.Instance.userMap
  local hasLearnMvp, hasLearnMini = true, true
  if ignoreSkill ~= true then
    hasLearnMvp = SkillProxy.Instance:HasLearnedSkill(GameConfig.Expression_SearchSkill.searchmvpskill)
    hasLearnMini = SkillProxy.Instance:HasLearnedSkill(GameConfig.Expression_SearchSkill.searchminiskill)
  end
  for _, monster in pairs(userMap) do
    if monster.data and monster.data:IsMonster() then
      local hideValue = monster.data.props:GetPropByName("Hiding"):GetValue()
      if hideValue and hideValue == 2 then
      elseif monster.data.staticData.Type == "MVP" then
        if hasLearnMvp then
          table.insert(self.monsterList, monster)
        end
      elseif monster.data.staticData.Type == "MINI" then
        if hasLearnMini then
          table.insert(self.monsterList, monster)
        end
      elseif not self.monsterIgnoreList[monster.data.staticData.id] then
        table.insert(self.monsterList, monster)
      end
    end
  end
  return self.monsterList
end

function FunctionMonster:FilterMonsterStaticInfo()
  TableUtility.TableClear(self.monsterStaticInfoMap)
  local npcMap = NSceneNpcProxy.Instance.npcMap
  local config = GameConfig.AutoAimMonster.IgnoreMvpMiniSkill
  local raidType = Game.DungeonManager:GetRaidType()
  local ignoreSkill = raidType and TableUtility.ArrayFindIndex(config.RaidType, raidType) > 0 or 0 < TableUtility.ArrayFindIndex(config.MapID, Game.MapManager:GetMapID())
  local hasLearnMvp = ignoreSkill or SkillProxy.Instance:HasLearnedSkill(GameConfig.Expression_SearchSkill.searchmvpskill)
  local hasLearnMini = ignoreSkill or SkillProxy.Instance:HasLearnedSkill(GameConfig.Expression_SearchSkill.searchminiskill)
  local hasMvpOrMini = false
  local exkey = "option"
  for npcID, npcList in pairs(npcMap) do
    if npcList then
      for i = 1, #npcList do
        local monster = npcList[i]
        local hideValue = monster.data.props:GetPropByName("Hiding"):GetValue()
        if hideValue and hideValue == 2 then
        elseif monster.data and monster.data:IsMonster() and self:CanSearchMonster(monster, hasLearnMvp, hasLearnMini) and monster.data:GetCamp() ~= RoleDefines_Camp.FRIEND then
          local opValue = monster.data.userdata:Get(UDEnum.OPTION)
          if self.monsterStaticInfoMap[npcID] == nil then
            do
              local data = AutoAimMonsterData.new()
              data:SetId(npcID)
              data:SetLevel(monster.data:GetBaseLv())
              data:SetBossType(monster:GetBossType())
              data[exkey] = opValue
              self.monsterStaticInfoMap[npcID] = data
              if monster.data:IsBoss() or monster.data:IsMini() then
                hasMvpOrMini = true
              end
            end
            break
          end
          if opValue ~= 1 then
            self.monsterStaticInfoMap[npcID][exkey] = nil
          end
          break
        end
      end
    end
  end
  return self.monsterStaticInfoMap, hasMvpOrMini
end

function FunctionMonster:SortMonsterStaticInfo()
  local exkey = "option"
  TableUtility.ArrayClear(self.monsterStaticInfoList)
  for k, v in pairs(self.monsterStaticInfoMap) do
    table.insert(self.monsterStaticInfoList, v)
  end
  table.sort(self.monsterStaticInfoList, function(l, r)
    if l[exkey] == 1 then
      return false
    end
    if r[exkey] == 1 then
      return true
    end
    local ldata = Table_Monster[l:GetId()]
    local rdata = Table_Monster[r:GetId()]
    if ldata and rdata then
      if ldata.Type ~= rdata.Type then
        return self.Priority[ldata.Type] < self.Priority[rdata.Type]
      else
        return l:GetLevel() < r:GetLevel()
      end
    else
      return false
    end
  end)
  return self.monsterStaticInfoList
end

function FunctionMonster:CanSearchMonster(monster, hasLearnMvp, hasLearnMini)
  if monster:IsDead() then
    return false
  end
  local data = monster.data
  if data:GetFeature_IgnoreAutoBattle() then
    return false
  end
  local sdata = data.staticData
  local can = false
  if sdata.Type == "MVP" then
    if hasLearnMvp then
      can = true
    end
  elseif sdata.Type == "MINI" then
    if hasLearnMini then
      can = true
    end
  elseif sdata.Body == nil then
    can = false
  else
    can = true
  end
  return can
end

function FunctionMonster:FilterTwelvePVPMonsterStaticInfo(filterRange)
  TableUtility.TableClear(self.monsterStaticInfoMap)
  local npcMap = NSceneNpcProxy.Instance.npcMap
  local exkey = "option"
  local myPosition = Game.Myself:GetPosition()
  for npcID, npcList in pairs(npcMap) do
    if npcList then
      for i = 1, #npcList do
        local monster = npcList[i]
        if monster.data and monster.data:IsMonster() and self:CanSearchMonster(monster, true, true) and monster.data:GetCamp() ~= RoleDefines_Camp.FRIEND and self:CheckRange(monster:GetPosition(), filterRange, myPosition) then
          local opValue = monster.data.userdata:Get(UDEnum.OPTION)
          if self.monsterStaticInfoMap[npcID] == nil then
            do
              local data = AutoAimMonsterData.new()
              data:SetId(npcID)
              data:SetLevel(monster.data:GetBaseLv())
              data:SetBossType(monster:GetBossType())
              data[exkey] = opValue
              self.monsterStaticInfoMap[npcID] = data
            end
            break
          end
          if opValue ~= 1 then
            self.monsterStaticInfoMap[npcID][exkey] = nil
          end
          break
        end
      end
    end
  end
  return self.monsterStaticInfoMap
end

function FunctionMonster:CheckRange(targetPos, range, myPosition)
  if not range then
    return true
  end
  local dist = VectorUtility.DistanceXZ(targetPos, myPosition)
  return range > dist
end

function FunctionMonster:GotoRareEliteMonster(monsterId, posX, posY, posZ)
  local sData = monsterId and Table_MonsterList[monsterId]
  if not sData then
    return
  end
  FunctionSystem.InterruptMyMissionCommand()
  local cmdArgs = ReusableTable.CreateTable()
  cmdArgs.targetMapID = sData.MapID
  if posX and posY and posZ then
    LuaVector3.Better_Set(tempV3, posX, posY, posZ)
    cmdArgs.targetPos = tempV3
  else
    self.workingRareEliteTarget = monsterId
    cmdArgs.targetMapID = sData.MapID
    
    function cmdArgs.callback(cmd, event)
      if event == MissionCommand.CallbackEvent.Shutdown and not self.isLoadingScene then
        self.workingRareEliteTarget = nil
      end
    end
  end
  local cmd = MissionCommandFactory.CreateCommand(cmdArgs, MissionCommandMove)
  if cmd then
    Game.Myself:Client_SetMissionCommand(cmd)
  end
  ReusableTable.DestroyAndClearTable(cmdArgs)
end

function FunctionMonster:OnBeginLoadScene()
  TimeTickManager.Me():ClearTick(self)
  self.isLoadingScene = true
end

function FunctionMonster:OnFinishLoadScene()
  if not self.workingRareEliteTarget then
    return
  end
  if SceneProxy.Instance:GetCurMapID() == Table_MonsterList[self.workingRareEliteTarget].MapID then
    ServiceBossCmdProxy.Instance:CallQueryRareEliteCmd()
    TimeTickManager.Me():CreateOnceDelayTick(2500, self.ClearLoadSceneFlag, self)
  else
    self:ClearLoadSceneFlag()
  end
end

function FunctionMonster:ClearLoadSceneFlag()
  self.isLoadingScene = nil
end

function FunctionMonster:RecvQueryRareElite(datas)
  if not datas or not self.workingRareEliteTarget then
    return
  end
  self:ClearLoadSceneFlag()
  local data
  for i = 1, #datas do
    data = datas[i]
    if data.npcid == self.workingRareEliteTarget then
      self:GotoRareEliteMonster(self.workingRareEliteTarget, data.pos.x / 1000, data.pos.y / 1000, data.pos.z / 1000)
      self.workingRareEliteTarget = nil
      return
    end
  end
  LogUtility.WarningFormat("Cannot find rare elite {0}", self.workingRareEliteTarget)
end

local MonsterType = {
  "shenyu_ka_icon_mvp",
  "shenyu_ka_icon_mini"
}

function FunctionMonster:SetMonsterFlag(sprite, id)
  local staticData = id and Table_Monster[id]
  if staticData then
    if staticData.Type == "MVP" then
      sprite.gameObject:SetActive(true)
      sprite.spriteName = MonsterType[1]
    elseif staticData.Type == "MINI" then
      sprite.gameObject:SetActive(true)
      sprite.spriteName = MonsterType[2]
    else
      sprite.gameObject:SetActive(false)
    end
  else
    sprite.gameObject:SetActive(false)
  end
end
