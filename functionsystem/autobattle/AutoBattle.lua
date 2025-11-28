AutoBattle = class("AutoBattle")
local tempCreatureArray = {}
AutoBattle.ResearchTargetTime = 2000
AutoBattle.ChangeTargetTime = 100
AutoBattle.SearchTargetDistance = 10
AutoBattle.DistanceOffset = 0.5
AutoBattle.MoveDistance = 2
AutoBattle.SelectAnimTime = 350
AutoBattle.SelectScale = 1.5
AutoBattle.SearchRandomDistance = 5
AutoBattle.SquareSearchRandomDistance = 25
AutoBattle.currentCreature = nil
AutoBattle.searchPosition = nil
AutoBattle.searchRange = nil
AutoBattle.squareSearchRange = nil
AutoBattle.randomTarget = nil
AutoBattle.hatredTarget = nil
AutoBattle.hatredMinDistance = 999999999
local TargetFilter = function(targetCreature, searchTargetArgs)
  local data = targetCreature.data
  if data ~= nil then
    if data:NoAutoAttack() then
      return Game.MapManager:IsInDungeon()
    end
    return not data:GetFeature_IgnoreAutoBattle()
  end
  return true
end
AutoBattle.TargetFilter = TargetFilter
local SearchRandomTarget = function(targetCreature, skillInfo)
  local dist = VectorUtility.DistanceXZ_Square(AutoBattle.searchPosition, targetCreature:GetPosition())
  if nil ~= AutoBattle.searchRange and dist > AutoBattle.squareSearchRange then
    return false
  end
  if dist < AutoBattle.SquareSearchRandomDistance and TargetFilter(targetCreature) and skillInfo:CheckTarget(AutoBattle.currentCreature, targetCreature) then
    AutoBattle.randomTarget = targetCreature
    return RandomUtil.Range(1, 10) < 5
  end
  return false
end
local SearchHatredTarget = function(targetCreature, hatredTime, skillInfo)
  if TargetFilter(targetCreature) and skillInfo:CheckTarget(AutoBattle.currentCreature, targetCreature) then
    local dist = VectorUtility.DistanceXZ(AutoBattle.searchPosition, targetCreature:GetPosition())
    if nil ~= AutoBattle.searchRange and dist > AutoBattle.searchRange then
      return false
    end
    if dist < AutoBattle.hatredMinDistance then
      AutoBattle.hatredTarget = targetCreature
      AutoBattle.hatredMinDistance = dist
    end
  end
  return false
end

function AutoBattle.SeartTarget(creature, skillInfo)
  local teamFirst = skillInfo:TeamFirst(creature)
  local lockedTarget = creature:GetLockTarget()
  if nil ~= lockedTarget and (not teamFirst or lockedTarget:IsInMyTeam()) and skillInfo:CheckTarget(creature, lockedTarget) and TargetFilter(creature, nil) then
    return lockedTarget
  end
  local searchRange = SkillLogic_Base.DefaultSearchRange
  if creature:IsAutoBattleStanding() then
    searchRange = skillInfo:GetLaunchRange(creature)
    AutoBattle.searchRange = searchRange
    AutoBattle.squareSearchRange = searchRange * searchRange
  end
  if not teamFirst then
    AutoBattle.currentCreature = creature
    AutoBattle.searchPosition = creature:GetPosition()
    AutoBattle.randomTarget = nil
    SceneCreatureProxy.ForEachCreature(SearchRandomTarget, skillInfo)
    AutoBattle.currentCreature = nil
    AutoBattle.searchPosition = nil
    AutoBattle.searchRange = nil
    AutoBattle.squareSearchRange = nil
    if nil ~= AutoBattle.randomTarget then
      local targetCreature = AutoBattle.randomTarget
      AutoBattle.randomTarget = nil
      return targetCreature
    end
  end
  local sortComparator = teamFirst and SkillLogic_Base.SortComparator_TeamFirstDistance or SkillLogic_Base.SortComparator_Distance
  SkillLogic_Base.SearchTargetInRange(tempCreatureArray, creature:GetPosition(), searchRange, skillInfo, creature, TargetFilter, sortComparator)
  local targetCreature = tempCreatureArray[1]
  TableUtility.ArrayClear(tempCreatureArray)
  return targetCreature
end

function AutoBattle:ctor(workCheck, workCheckParam, workCall, workCallParam)
  self.workCheck = workCheck
  self.workCheckParam = workCheckParam
  self.workCall = workCall
  self.workCallParam = workCallParam
  self:Reset()
end

function AutoBattle:Reset()
  self.skillIndex = nil
  if nil ~= self.skillStatus then
    TableUtility.TableClear(self.skillStatus)
  else
    self.skillStatus = {}
  end
end

function AutoBattle:Update(creature, skillFilter, onlyNoTargetAutoCast, allowResearch)
  if self.workCheck then
    if self.workCheck(self.workCheckParam, creature, skillFilter, onlyNoTargetAutoCast, allowResearch) then
      self:Attack(creature, nil, skillFilter, onlyNoTargetAutoCast, allowResearch)
    end
  else
    self:Attack(creature, nil, skillFilter, onlyNoTargetAutoCast, allowResearch)
  end
end

function AutoBattle:Attack(creature, targetCreature, skillFilter, onlyNoTargetAutoCast, allowResearch)
  local creaturePosition = creature:GetPosition()
  if nil == creaturePosition then
    return false
  end
  if creature.data:NoAttack() then
    return false
  end
  local ret, skillIDAndLevel, noTarget, forceLockCreature, skillInfo = self:Attack_Step1(creature, skillFilter, onlyNoTargetAutoCast)
  if not ret then
    return false
  end
  return self:Attack_Step2(creature, targetCreature, skillIDAndLevel, noTarget, forceLockCreature, skillInfo, onlyNoTargetAutoCast, allowResearch)
end

function AutoBattle:Attack_Step1(creature, skillFilter, onlyNoTargetAutoCast)
  local skillIDAndLevel, noTarget, forceLockCreature = self:SelectSkill(creature, skillFilter, onlyNoTargetAutoCast)
  if nil == skillIDAndLevel then
    return false
  end
  local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillIDAndLevel)
  return true, skillIDAndLevel, noTarget, forceLockCreature, skillInfo
end

function AutoBattle:Attack_Step2(creature, targetCreature, skillIDAndLevel, noTarget, forceLockCreature, skillInfo, onlyNoTargetAutoCast, allowResearch)
  local noSearch = false
  if onlyNoTargetAutoCast or nil ~= targetCreature then
    noSearch = true
  end
  if nil == forceLockCreature then
    forceLockCreature = targetCreature
    local hatredFirst = creature:IsAutoBattleProtectingTeam()
    if hatredFirst and skillInfo:TargetEnemy(creature) then
      AutoBattle.currentCreature = creature
      AutoBattle.searchPosition = creature:GetPosition()
      AutoBattle.searchRange = creature:IsAutoBattleStanding() and skillInfo:GetLaunchRange(creature) or nil
      AutoBattle.squareSearchRange = AutoBattle.searchRange and AutoBattle.searchRange * AutoBattle.searchRange
      AutoBattle.hatredTarget = nil
      AutoBattle.hatredMinDistance = 999999999
      Game.LogicManager_Hatred:ForEach(SearchHatredTarget, skillInfo)
      AutoBattle.currentCreature = nil
      AutoBattle.searchPosition = nil
      AutoBattle.searchRange = nil
      AutoBattle.squareSearchRange = nil
      AutoBattle.hatredMinDistance = 999999999
      if nil ~= AutoBattle.hatredTarget then
        forceLockCreature = AutoBattle.hatredTarget
        AutoBattle.hatredTarget = nil
        noSearch = true
      end
    end
  end
  local forceTargetCreature = false
  local targetPosition
  local skillTargetType = skillInfo:GetTargetType(creature)
  if SkillTargetType.Point == skillTargetType then
    if (noTarget or skillInfo:NoTargetAutoCast()) and nil == forceLockCreature then
      targetPosition = creature:GetPosition()
    else
      forceTargetCreature = true
    end
  elseif SkillTargetType.None == skillTargetType and not noTarget then
    forceTargetCreature = true
  end
  if forceTargetCreature and nil == forceLockCreature then
    if noSearch then
      return false
    end
    forceLockCreature = AutoBattle.SeartTarget(creature, skillInfo)
    if nil == forceLockCreature then
      return false
    end
  end
  if nil ~= forceLockCreature and (SkillTargetType.Creature == skillTargetType or forceTargetCreature) and noSearch and forceLockCreature == targetCreature and not skillInfo:CheckTarget(creature, forceLockCreature) then
    return false
  end
  if skillInfo:GetSkillType() == SkillType.Function then
    return false
  end
  if nil == targetPosition and nil ~= forceLockCreature then
    targetPosition = forceLockCreature:GetPosition()
  end
  if self.workCall then
    self.workCall(self.workCallParam, creature, skillIDAndLevel, forceLockCreature, targetPosition, forceTargetCreature, noSearch, TargetFilter, allowResearch)
  else
    creature:Client_UseSkill(skillIDAndLevel, forceLockCreature, targetPosition, forceTargetCreature, noSearch, TargetFilter, allowResearch, nil, nil, true, true)
  end
  local skillStatus = self.skillStatus[skillIDAndLevel]
  if nil == skillStatus then
    skillStatus = {}
    self.skillStatus[skillIDAndLevel] = skillStatus
  end
  skillStatus.lastLaunchTime = ServerTime.CurServerTime() / 1000
  return true
end

function AutoBattle:SelectSkill(creature, filter, onlyNoTargetAutoCast)
  local skillProxy = SkillProxy.Instance
  if nil ~= skillProxy then
    local skillItems = skillProxy:GetAutoBattleSkillsWithCombo()
    local startIndex = 1
    if nil ~= self.skillIndex then
      startIndex = self.skillIndex + 1
    end
    local skillItem, skillIndex, noTarget, forceLockCreature = self:LoopGetValidSkill(creature, skillItems, startIndex, filter, onlyNoTargetAutoCast)
    if nil ~= skillItem then
      if nil ~= skillIndex then
        self.skillIndex = skillIndex
      end
      return skillItem:GetID(), noTarget, forceLockCreature
    end
  end
  return nil
end

function AutoBattle:IsSkillAutoBattleValid(creature, skillIDAndLevel, autoBattleParams, skillInfo)
  local forceLockCreature
  if nil ~= autoBattleParams then
    if 1 == autoBattleParams.type then
      local skillStatus = self.skillStatus[skillIDAndLevel]
      if nil ~= skillStatus and nil ~= skillStatus.lastLaunchTime and ServerTime.CurServerTime() / 1000 < skillStatus.lastLaunchTime + autoBattleParams.time then
        return false
      end
    elseif 2 == autoBattleParams.type then
      return false
    elseif 3 == autoBattleParams.type then
      local props = creature.data.props
      if nil ~= props then
        local maxHP = props:GetPropByName("MaxHp"):GetValue()
        local HP = props:GetPropByName("Hp"):GetValue()
        if HP >= autoBattleParams.value / 100.0 * maxHP then
          return false
        end
      end
    elseif 5 == autoBattleParams.type then
      local myTeam = TeamProxy.Instance.myTeam
      if nil == myTeam then
        return false
      end
      local members = myTeam:GetMembersList()
      if nil == members then
        return false
      end
      local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillIDAndLevel)
      local skillLaunchRange = skillInfo:GetLaunchRange(creature)
      local squareSkillLaunchRange = skillLaunchRange * skillLaunchRange
      local rolePosition = creature:GetPosition()
      local minHPPercent = 1
      local minHPCreature
      local checkDragonContract, dragonContract = autoBattleParams.checkDragonContract
      if checkDragonContract then
        dragonContract = Game.Myself:GetDragonContract()
        if dragonContract then
          local memberCreature = SceneCreatureProxy.FindCreature(dragonContract)
          local m = myTeam:GetMemberByGuid(dragonContract)
          if nil ~= memberCreature and not memberCreature:IsDead() then
            if not (squareSkillLaunchRange < VectorUtility.DistanceXZ_Square(rolePosition, memberCreature:GetPosition())) and nil ~= m.hpmax and nil ~= m.hp then
              local maxHP = m.hpmax
              local HP = m.hp
              local HPPercent = HP / maxHP
              if (nil == minHPCreature or minHPPercent > HPPercent) and skillInfo:CheckTarget(creature, memberCreature) then
                minHPPercent = HPPercent
                minHPCreature = memberCreature
              end
            else
              return false
            end
          else
            return false
          end
        else
          for i = 1, #members do
            local m = members[i]
            local memberCreature = SceneCreatureProxy.FindCreature(m.id)
            if nil ~= memberCreature and not memberCreature:IsDead() then
              local hasRelation = memberCreature.data:HasRelation()
              if hasRelation and not (squareSkillLaunchRange < VectorUtility.DistanceXZ_Square(rolePosition, memberCreature:GetPosition())) and nil ~= m.hpmax and nil ~= m.hp then
                local maxHP = m.hpmax
                local HP = m.hp
                local HPPercent = HP / maxHP
                if (nil == minHPCreature or minHPPercent > HPPercent) and skillInfo:CheckTarget(creature, memberCreature) then
                  minHPPercent = HPPercent
                  minHPCreature = memberCreature
                end
              end
            end
          end
        end
      else
        for i = 1, #members do
          local m = members[i]
          local memberCreature = SceneCreatureProxy.FindCreature(m.id)
          if nil ~= memberCreature and not memberCreature:IsDead() then
            local targetNoBuffId = autoBattleParams.target_noBuff
            local targetHasNoBuff = true
            if targetNoBuffId ~= nil then
              targetHasNoBuff = not memberCreature.data:HasBuffID(targetNoBuffId)
            end
            if targetHasNoBuff and not (squareSkillLaunchRange < VectorUtility.DistanceXZ_Square(rolePosition, memberCreature:GetPosition())) and nil ~= m.hpmax and nil ~= m.hp then
              local maxHP = m.hpmax
              local HP = m.hp
              local HPPercent = HP / maxHP
              if (nil == minHPCreature or minHPPercent > HPPercent) and skillInfo:CheckTarget(creature, memberCreature) then
                minHPPercent = HPPercent
                minHPCreature = memberCreature
              end
            end
          end
        end
      end
      if nil == minHPCreature or minHPPercent >= autoBattleParams.teamvalue / 100.0 then
        return false
      end
      forceLockCreature = minHPCreature
    elseif 7 == autoBattleParams.type then
      local myTeam = TeamProxy.Instance.myTeam
      if nil == myTeam then
        return false
      end
      local members = myTeam:GetPlayerMemberList(true, true)
      if nil == members then
        return false
      end
      local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillIDAndLevel)
      local buffs = skillInfo:GetTeamBuffs(creature)
      if nil == buffs or #buffs <= 0 then
        return false
      end
      local onlyLockTarget
      if 1 == autoBattleParams.only_lock_target then
        onlyLockTarget = creature:GetLockTarget()
      end
      local followTargetID
      if autoBattleParams.follow_target == 1 then
        local followid = Game.Myself:Client_GetFollowLeaderID()
        if followid ~= 0 then
          followTargetID = followid
        end
      end
      local skillLaunchRange = skillInfo:GetLaunchRange(creature)
      local squareSkillLaunchRange = skillLaunchRange * skillLaunchRange
      local rolePosition = creature:GetPosition()
      for i = 1, #members do
        local m = members[i]
        local memberCreature = SceneCreatureProxy.FindCreature(m.id)
        if nil ~= memberCreature and not memberCreature:IsDead() then
          local isMatchLock
          if followTargetID ~= nil then
            isMatchLock = followTargetID == m.id
          else
            isMatchLock = nil == onlyLockTarget or onlyLockTarget == memberCreature
          end
          if not (squareSkillLaunchRange < VectorUtility.DistanceXZ_Square(rolePosition, memberCreature:GetPosition())) and not memberCreature:HasBuffs(buffs) and skillInfo:CheckTarget(creature, memberCreature) and isMatchLock then
            forceLockCreature = memberCreature
            break
          end
        end
      end
      if nil == forceLockCreature then
        return false
      end
    elseif 8 == autoBattleParams.type then
      local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillIDAndLevel)
      local buffs = skillInfo:GetSelfBuffs(creature)
      if buffs ~= nil and creature:HasBuffs(buffs) then
        return false
      end
      buffs = skillInfo:GetSelectBuffs(creature)
      if buffs ~= nil and creature:HasBuffs(buffs) then
        return false
      end
    elseif 9 == autoBattleParams.type then
      local myTeam = TeamProxy.Instance.myTeam
      if nil == myTeam then
        return false
      end
      local members = myTeam:GetMembersList()
      if nil == members then
        return false
      end
      local buffStateEffects = autoBattleParams.state_effect
      if nil == buffStateEffects or #buffStateEffects <= 0 then
        return false
      end
      local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillIDAndLevel)
      local skillLaunchRange = skillInfo:GetLaunchRange(creature)
      local squareSkillLaunchRange = skillLaunchRange * skillLaunchRange
      local rolePosition = creature:GetPosition()
      for i = 1, #members do
        local m = members[i]
        local memberCreature = SceneCreatureProxy.FindCreature(m.id)
        if nil ~= memberCreature and not memberCreature:IsDead() and not (squareSkillLaunchRange < VectorUtility.DistanceXZ_Square(rolePosition, memberCreature:GetPosition())) and memberCreature:HasBuffStates(buffStateEffects) and skillInfo:CheckTarget(creature, memberCreature) then
          forceLockCreature = memberCreature
          break
        end
      end
      if nil == forceLockCreature then
        return false
      end
    elseif 10 == autoBattleParams.type then
      local myTeam = TeamProxy.Instance.myTeam
      if nil == myTeam then
        return false
      end
      local members = myTeam:GetMembersList()
      if nil == members then
        return false
      end
      local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillIDAndLevel)
      local skillLaunchRange = skillInfo:GetLaunchRange(creature)
      local squareSkillLaunchRange = skillLaunchRange * skillLaunchRange
      local rolePosition = creature:GetPosition()
      for i = 1, #members do
        local m = members[i]
        local memberCreature = SceneCreatureProxy.FindCreature(m.id)
        if nil ~= memberCreature and memberCreature:IsDead() and not (squareSkillLaunchRange < VectorUtility.DistanceXZ_Square(rolePosition, memberCreature:GetPosition())) and skillInfo:CheckTarget(creature, memberCreature) then
          forceLockCreature = memberCreature
          break
        end
      end
      if nil == forceLockCreature then
        return false
      end
    elseif 11 == autoBattleParams.type then
      local props = creature.data.props
      if nil ~= props then
        local maxHP = props:GetPropByName("MaxHp"):GetValue()
        local HP = props:GetPropByName("Hp"):GetValue()
        if HP <= autoBattleParams.value / 100.0 * maxHP then
          return false
        end
      end
    elseif 12 == autoBattleParams.type then
      if creature:HasBuff(autoBattleParams.buffid) and creature:GetBuffLayer(autoBattleParams.buffid) >= autoBattleParams.num then
        return false
      end
    elseif 13 == autoBattleParams.type then
      local myTeam = TeamProxy.Instance.myTeam
      if nil == myTeam then
        return false
      end
      local members = myTeam:GetMembersList()
      if nil == members then
        return false
      end
      local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillIDAndLevel)
      local onlyLockTarget
      if 1 == autoBattleParams.only_lock_target then
        onlyLockTarget = creature:GetLockTarget()
      end
      local skillLaunchRange = skillInfo:GetLaunchRange(creature)
      local squareSkillLaunchRange = skillLaunchRange * skillLaunchRange
      local rolePosition = creature:GetPosition()
      for i = 1, #members do
        local m = members[i]
        local memberCreature = SceneCreatureProxy.FindCreature(m.id)
        if nil ~= memberCreature and not memberCreature:IsDead() and not (squareSkillLaunchRange < VectorUtility.DistanceXZ_Square(rolePosition, memberCreature:GetPosition())) and memberCreature:GetBuffLayer(autoBattleParams.buffid) < autoBattleParams.num and skillInfo:CheckTarget(creature, memberCreature) and (nil == onlyLockTarget or onlyLockTarget == memberCreature) then
          forceLockCreature = memberCreature
          break
        end
      end
      if nil == forceLockCreature then
        return false
      end
    elseif 14 == autoBattleParams.type then
      local _LogicManagerSkill = Game.LogicManager_Skill
      local subSkillList = Game.SkillOptionManager:GetMultiSkillOption(SkillOptionManager.OptionEnum.BuffSkillList, skillIDAndLevel)
      if subSkillList ~= nil then
        local isValid = false
        for i = 1, #subSkillList do
          local skillInfo = _LogicManagerSkill:GetSkillInfo(subSkillList[i])
          if not creature:HasBuffs(skillInfo:GetSelfBuffs(creature)) and not creature:HasBuffs(skillInfo:GetSelectBuffs(creature)) and not CDProxy.Instance:SkillIsInCD(math.floor(subSkillList[i] / 1000)) then
            isValid = true
            break
          end
        end
        if isValid == false then
          return isValid
        end
      end
    elseif 15 == autoBattleParams.type then
      local props = creature.data.props
      if nil ~= props then
        local maxSP = props:GetPropByName("MaxSp"):GetValue()
        local SP = props:GetPropByName("Sp"):GetValue()
        if SP >= autoBattleParams.value / 100.0 * maxSP then
          return false
        end
      end
    end
  end
  return true, forceLockCreature
end

function AutoBattle:IsSkillItemValid(creature, skillItem, filter, onlyNoTargetAutoCast)
  if nil == skillItem then
    return false
  end
  local skillIDAndLevel = skillItem:GetID()
  local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillIDAndLevel)
  local nowSkillInfo = creature.skill.info
  if nowSkillInfo and nowSkillInfo:GetChant_can_use_skill(Game.Myself) and creature.skill:IsCastSkill(creature.skill.phaseData:GetSkillPhase()) then
    local nowPhaseData = creature.skill.phaseData
    if nowPhaseData and creature.skill:IsCastSkill(nowPhaseData:GetSkillPhase()) and nowSkillInfo:CanUseOtherSkill(skillIDAndLevel, Game.Myself) then
    else
      return false
    end
  end
  local noTarget = false
  local forceLockCreature
  local autoBattlePriority = 0
  local autoBattleParams = skillInfo:GetAutoCondition(creature)
  if nil ~= autoBattleParams and 0 < #autoBattleParams then
    local autoBattleValid = false
    for i = 1, #autoBattleParams do
      local p = autoBattleParams[i]
      local valid, targetCreature = self:IsSkillAutoBattleValid(creature, skillIDAndLevel, p, skillInfo)
      if valid then
        autoBattleValid = true
        noTarget = 1 == p.no_target
        if p.Replace_ForceTarget == 1 then
          local myself = Game.Myself
          local followid = myself:Client_GetFollowLeaderID()
          forceLockCreature = SceneCreatureProxy.FindCreature(followid) or myself
        else
          forceLockCreature = targetCreature
        end
        if nil ~= p.priority then
          autoBattlePriority = p.priority
        end
        break
      end
    end
    if not autoBattleValid then
      return false
    end
  end
  if skillItem:IsAutoShortCutLocked() then
    return false
  end
  if not SkillProxy.Instance:SkillCanBeUsed(skillItem) then
    return false
  end
  if 0 < SkillProxy.Instance:SkillInForgetTime(skillIDAndLevel // 1000) then
    return false
  end
  if nil ~= filter and not filter(skillIDAndLevel) then
    return false
  end
  if nil == forceLockCreature and onlyNoTargetAutoCast and not skillInfo:NoTargetAutoCast(creature) then
    return false
  end
  return true, noTarget, forceLockCreature, autoBattlePriority
end

function AutoBattle:LoopGetValidSkill(creature, skillItems, startIndex, filter, onlyNoTargetAutoCast)
  local attackSkillIDAndLevel = creature.data:GetAttackSkillIDAndLevel()
  local attackSkillItem, attackSkillIndex
  local attackSkillNoTarget = false
  local attackSkillForceLockCreature, selectedSkillItem, selectedIndex
  local selectedNoTarget = false
  local selectedForceLockCreature
  local selectedPriority = -1
  if nil ~= skillItems and 0 < #skillItems then
    local skillItemCount = #skillItems
    if startIndex <= skillItemCount then
      for i = startIndex, skillItemCount do
        local skillItem = skillItems[i]
        local skillID = skillItem:GetID()
        local valid, noTarget, forceLockCreature, priority = self:IsSkillItemValid(creature, skillItem, filter, onlyNoTargetAutoCast)
        if valid then
          if attackSkillIDAndLevel ~= skillID then
            if not creature.data:NoSkill() and not creature:Logic_IsFreeCast() and selectedPriority < priority then
              selectedSkillItem = skillItem
              selectedIndex = i
              selectedNoTarget = noTarget
              selectedForceLockCreature = forceLockCreature
              selectedPriority = priority
            end
          else
            attackSkillItem = skillItem
            attackSkillIndex = i
            attackSkillNoTarget = noTarget
            attackSkillForceLockCreature = forceLockCreature
          end
        end
      end
    end
    local endIndex = math.min(startIndex, skillItemCount)
    if 0 < endIndex and 1 < startIndex then
      for i = 1, endIndex do
        local skillItem = skillItems[i]
        local skillID = skillItem:GetID()
        local valid, noTarget, forceLockCreature, priority = self:IsSkillItemValid(creature, skillItem, filter, onlyNoTargetAutoCast)
        if valid then
          if attackSkillIDAndLevel ~= skillID then
            if not creature.data:NoSkill() and not creature:Logic_IsFreeCast() and selectedPriority < priority then
              selectedSkillItem = skillItem
              selectedIndex = i
              selectedNoTarget = noTarget
              selectedForceLockCreature = forceLockCreature
              selectedPriority = priority
            end
          else
            attackSkillItem = skillItem
            attackSkillIndex = i
            attackSkillNoTarget = noTarget
            attackSkillForceLockCreature = forceLockCreature
          end
        end
      end
    end
  end
  if nil ~= selectedSkillItem then
    return selectedSkillItem, selectedIndex, selectedNoTarget, selectedForceLockCreature
  end
  return attackSkillItem, nil, attackSkillNoTarget, forceLockCreature
end
