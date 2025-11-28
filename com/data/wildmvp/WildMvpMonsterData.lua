WildMvpMonsterData = class("WildMvpMonsterData")
local EmptyTable = {}
WildMvpMonsterData.SymbolType = {
  BigWorldMapStep = 1,
  BigWorldWanderElite = 2,
  BigWorldMount = 3
}

function WildMvpMonsterData:ctor(staticData)
  self:SetStaticData(staticData)
end

function WildMvpMonsterData:SetStaticData(staticData)
  self.id = staticData.id
  self.staticData = staticData
  local monsterConfig = Table_Monster[self.id]
  if monsterConfig then
    self.type = monsterConfig.Type
  end
  if self:GetSymbolType() == self.SymbolType.BigWorldWanderElite then
    self.mapSymbolDisabled = "map_icon_jingying02"
    self.mapSymbolProgress = "map_icon_jingying02"
    self.mapSymbolActive = "map_icon_jingying02"
    self.symbolSize = 23
  elseif self:GetSymbolType() == self.SymbolType.BigWorldMapStep then
    self.mapSymbolDisabled = "map_icon_jingying03"
    self.mapSymbolProgress = "map_icon_jingying03"
    self.mapSymbolActive = "map_icon_jingying03"
    self.symbolSize = 23
  elseif self:GetSymbolType() == self.SymbolType.BigWorldMount then
    self.mapSymbolDisabled = "map_icon_zuoqi"
    self.mapSymbolProgress = "map_icon_zuoqi"
    self.mapSymbolActive = "map_icon_zuoqi"
    self.symbolSize = 23
  elseif self.type == "MVP" then
    self.mapSymbolDisabled = "map_mvpcamp1"
    self.mapSymbolProgress = "map_mvpcamp2"
    self.mapSymbolActive = "map_mvpcamp3"
    self.symbolSize = 28.0
  elseif self.type == "RareElite" then
    self.mapSymbolDisabled = "map_elite1"
    self.mapSymbolProgress = "map_elite2"
    self.mapSymbolActive = "map_elite2"
    self.symbolSize = 24.0
  elseif self.type == "WorldBoss" then
    self.mapSymbolDisabled = "map_worldboss"
    self.mapSymbolProgress = "map_worldboss"
    self.mapSymbolActive = "map_worldboss"
    self.symbolSize = 24.0
  end
  self.cd = staticData and staticData.cd
  local respawnPos = staticData and staticData.RespawnPos
  if respawnPos then
    self.pos = staticData and LuaVector3.New(respawnPos[1], respawnPos[2], respawnPos[3])
  end
  if self:GetSymbolType() == self.SymbolType.BigWorldWanderElite then
    self.noPosHide = not respawnPos or not (0 < #respawnPos)
  end
  self.holdPercent = 0.8
end

function WildMvpMonsterData:SetServerData(serverData)
  if serverData and serverData.npcid == self.id then
    if not self.serverData then
      self.serverData = {}
    end
    self.serverData.status = serverData.status
    local leftTime = serverData.lefttime or 0
    self.serverData.endTime = leftTime + ServerTime.CurServerTime() / 1000
    self.serverData.posX = serverData.pos and serverData.pos.x
    self.serverData.posY = serverData.pos and serverData.pos.y
    self.serverData.posZ = serverData.pos and serverData.pos.z
    self.serverData.firstKilled = self.serverData.firstKilled or serverData.first_killed or false
    local gottenDailyReward = serverData.gotten_daily_reward or false
    self.serverData.gottenDailyReward = self.serverData.gottenDailyReward or gottenDailyReward
    if gottenDailyReward then
      self.serverData.gottenDailyRewardExpireTime = ServerTime.GetStartTimestamp() + 86400
    else
      self:GetIsGottenDailyReward()
    end
    self:_OnSetServerData()
  end
end

function WildMvpMonsterData:_OnSetServerData()
  local symbolType = self:GetSymbolType()
  if symbolType == self.SymbolType.BigWorldMapStep or symbolType == self.SymbolType.BigWorldWanderElite then
    local firstKilled = self.serverData and self.serverData.firstKilled
    if firstKilled then
      if symbolType == self.SymbolType.BigWorldWanderElite then
        self.mapSymbolDisabled = "map_icon_jingying"
        self.mapSymbolProgress = "map_icon_jingying"
        self.mapSymbolActive = "map_icon_jingying"
      elseif symbolType == self.SymbolType.BigWorldMapStep then
        self.mapSymbolDisabled = "map_icon_jingying04"
        self.mapSymbolProgress = "map_icon_jingying04"
        self.mapSymbolActive = "map_icon_jingying04"
      end
    elseif symbolType == self.SymbolType.BigWorldWanderElite then
      self.mapSymbolDisabled = "map_icon_jingying02"
      self.mapSymbolProgress = "map_icon_jingying02"
      self.mapSymbolActive = "map_icon_jingying02"
    elseif symbolType == self.SymbolType.BigWorldMapStep then
      self.mapSymbolDisabled = "map_icon_jingying03"
      self.mapSymbolProgress = "map_icon_jingying03"
      self.mapSymbolActive = "map_icon_jingying03"
    end
    self.symbolSize = 23
  end
  if symbolType == self.SymbolType.BigWorldWanderElite then
    local noServerPos = self.serverData.posX == 0 and self.serverData.posY == 0 and self.serverData.posZ == 0
    if not noServerPos then
      if self.pos then
        LuaVector3.Better_Set(self.pos, self.serverData.posX / 1000, self.serverData.posY / 1000, self.serverData.posZ / 1000)
      else
        self.pos = LuaVector3.New(self.serverData.posX / 1000, self.serverData.posY / 1000, self.serverData.posZ / 1000)
      end
      self.noPosHide = false
    end
  end
end

function WildMvpMonsterData:GetStaticMonsterData()
  return Table_Monster[self.id]
end

function WildMvpMonsterData:GetStaticData()
  return self.staticData
end

function WildMvpMonsterData:GetServerData()
  return self.serverData
end

function WildMvpMonsterData:GetTimeLeft()
  if self:IsDead() then
    return self.serverData.endTime - ServerTime.CurServerTime() / 1000
  end
end

function WildMvpMonsterData:IsCharUnLock()
  if self.staticData and FunctionUnLockFunc.Me():CheckCanOpen(self.staticData.CharacteristicMenu) then
    return true
  end
  return false
end

function WildMvpMonsterData:GetStatus()
  if self.serverData then
    return self.serverData.status
  end
  return ERAREELITESTATUS.ERAREELITESTATUS_UNKNOWN
end

function WildMvpMonsterData:IsSummoned()
  if self.serverData then
    return self.serverData.status ~= ERAREELITESTATUS.ERAREELITESTATUS_UNKNOWN
  end
  return false
end

function WildMvpMonsterData:IsAlive()
  if self.serverData then
    return self.serverData.status == ERAREELITESTATUS.ERAREELITESTATUS_ALIVE
  end
  return false
end

function WildMvpMonsterData:IsDead()
  if self.serverData then
    return self.serverData.status == ERAREELITESTATUS.ERAREELITESTATUS_DEAD
  end
  return false
end

function WildMvpMonsterData:GetElitePositionXYZ()
  if self.serverData and self.serverData.posX and self.serverData.posY and self.serverData.posZ then
    return self.serverData.posX / 1000, self.serverData.posY / 1000, self.serverData.posZ / 1000
  end
end

function WildMvpMonsterData:GetIsGottenDailyReward()
  local value = self.serverData and self.serverData.gottenDailyReward
  if value then
    local isOutDated = ServerTime.CurServerTime() / 1000 >= self.serverData.gottenDailyRewardExpireTime
    if isOutDated then
      self.serverData.gottenDailyReward = false
      value = false
    end
  end
  return value
end

function WildMvpMonsterData:GetMapID()
  if self.staticData then
    return self.staticData.MapID
  end
end

function WildMvpMonsterData:GetSkillIds()
  if self.staticData then
    return self.staticData.Skill
  end
end

function WildMvpMonsterData:GetType()
  return self.type
end

function WildMvpMonsterData:GetSymbolType()
  if self.staticData then
    return self.staticData.SymbolType
  end
end

function WildMvpMonsterData:GetDisabledMapSymbolIcon()
  return self.mapSymbolDisabled
end

function WildMvpMonsterData:GetProgressMapSymbolIcon()
  return self.mapSymbolProgress
end

function WildMvpMonsterData:GetActiveMapSymbolIcon()
  return self.mapSymbolActive
end

function WildMvpMonsterData:GetMapSymbolDepth()
  return 1
end

function WildMvpMonsterData:GetMapSymbolProgress()
  local symbolType = self:GetSymbolType()
  if symbolType == self.SymbolType.BigWorldMapStep or symbolType == self.SymbolType.BigWorldWanderElite then
    local gottenDailyReward = self.serverData and self.serverData.gottenDailyReward
    if gottenDailyReward then
      return 0, false
    else
      return 1, true
    end
  end
  local progress = 0
  local isAlive = false
  if self:IsAlive() then
    isAlive = true
    progress = 1
  elseif self:IsDead() then
    isAlive = false
    if self.cd and 0 < self.cd then
      progress = 1.0 - (self:GetTimeLeft() or 0) / self.cd
      progress = math.clamp(progress, 0, 1)
    else
      progress = 1
    end
  else
    progress = 1
    isAlive = false
  end
  return progress, isAlive
end

function WildMvpMonsterData:IsUnlocked()
  return FunctionUnLockFunc.Me():CheckCanOpen(self.staticData and self.staticData.IconShowMenu)
end

local tempRewards = {}

function WildMvpMonsterData:GetRewards()
  TableUtility.ArrayClear(tempRewards)
  if self.staticData then
    if self.serverData and self.serverData.firstKilled then
      for i, v in ipairs(self.staticData.Reward) do
        WildMvpMonsterData.TryAddReusableReward(tempRewards, v)
      end
      for i, v in ipairs(self.staticData.DropReward) do
        WildMvpMonsterData.TryAddReusableReward(tempRewards, v, true, true)
      end
    else
      for i, v in ipairs(self.staticData.DropReward) do
        WildMvpMonsterData.TryAddReusableReward(tempRewards, v, true)
      end
      for i, v in ipairs(self.staticData.Reward) do
        WildMvpMonsterData.TryAddReusableReward(tempRewards, v)
      end
    end
  end
  return tempRewards
end

function WildMvpMonsterData.TryAddReusableReward(rewardItemArr, teamId, isFirst, isGot)
  local items = teamId and ItemUtil.GetRewardItemIdsByTeamId(teamId)
  if items then
    for i, v in ipairs(items) do
      local tbl = {}
      TableUtility.TableShallowCopy(tbl, v)
      tbl.isFirst = isFirst
      tbl.isGot = isGot
      TableUtility.ArrayPushBack(rewardItemArr, tbl)
    end
  end
end

function WildMvpMonsterData:GetMapZoneID()
  local monsterListConfig = Table_MonsterList[self.id]
  if not monsterListConfig then
    return
  end
  return monsterListConfig.GroupId
end
