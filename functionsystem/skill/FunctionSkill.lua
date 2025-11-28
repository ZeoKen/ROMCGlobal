FunctionSkill = class("FunctionSkill")
local RaidLimitedSkills = GameConfig.RaidLimitedSkills

function FunctionSkill.Me()
  if nil == FunctionSkill.me then
    FunctionSkill.me = FunctionSkill.new()
  end
  return FunctionSkill.me
end

function FunctionSkill:ctor()
  self.heatlockSkillFuncMap = {}
  self.heatlockSkillFuncMap[1] = self.HandleSkill_Insight
  local eventManager = EventManager.Me()
  eventManager:AddEventListener(SkillEvent.SkillCastBegin, self.HandleStartProcess, self)
  eventManager:AddEventListener(SkillEvent.SkillCastEnd, self.HandleStopProcess, self)
  eventManager:AddEventListener(MyselfEvent.StartToMove, self.CancelInsight, self)
end

function FunctionSkill:HandleStartProcess(data)
  local creature = data.data
  local myself = Game.Myself
  if myself ~= nil then
    if myself == creature then
      self.isCasting = true
    end
    self:HandleBreakCastBegin(creature, myself)
  end
end

function FunctionSkill:HandleStopProcess(data)
  local creature = data.data
  local myself = Game.Myself
  if myself ~= nil and myself == creature then
    self.isCasting = false
  end
  self:HandleBreakCastEnd(creature)
end

function FunctionSkill:TryUseSkill(skillIDAndLevel, target, noSearch, auto, quickuse, manual)
  if self.isCasting and not quickuse then
    return
  end
  local myself = Game.Myself
  local isHanding, handOther = myself:IsHandInHand()
  if isHanding and not handOther then
    return
  end
  local fit, requiredSkill = FunctionSkillEnableCheck.Me():LearnedSkillCheck(skillIDAndLevel)
  if fit == false and requiredSkill ~= nil then
    requiredSkill = requiredSkill * 1000 + 1
    MsgManager.ShowMsgByIDTable(355, {
      Table_Skill[requiredSkill].NameZh
    })
    return
  end
  local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillIDAndLevel)
  if RaidLimitedSkills then
    local curraidid = SceneProxy.Instance:GetCurRaidID()
    if RaidLimitedSkills[curraidid] then
      local limitconfig = RaidLimitedSkills[curraidid]
      local skillType = skillInfo:GetSkillType()
      if limitconfig[skillType] and not GroupRaidProxy.Instance:CheckCanRevive() then
        MsgManager.ShowMsgByID(25966)
        return
      end
    end
  end
  local fitSpecial, costs, needMsg = SkillProxy.Instance:HasFitSpecialCost(skillIDAndLevel)
  if not SkillProxy.Instance:HasEnoughSp(skillIDAndLevel) then
    MsgManager.ShowMsgByIDTable(1101)
  elseif not SkillProxy.Instance:HasEnoughHp(skillIDAndLevel) then
    MsgManager.ShowMsgByIDTable(609)
  elseif not fitSpecial then
    if needMsg then
      MsgManager.ShowMsgByIDTable(3052, {
        Table_Item[costs[1][1]].NameZh,
        costs[1][2]
      })
    end
  else
    local lockedTarget = myself:GetLockTarget()
    local isUseSkill = true
    if myself.data.userdata:Get(UDEnum.NORMAL_SKILL) == skillIDAndLevel or skillInfo:IsFakeNormalAtk() then
      myself:Client_UseSkill(skillIDAndLevel, lockedTarget, nil, nil, noSearch)
    else
      local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillIDAndLevel)
      local skillType = skillInfo:GetSkillType()
      local autoLaunch = skillInfo:AutoLaunch()
      if skillType == SkillType.Function then
        self:HandleFunctionSkill(skillInfo)
      else
        local skillTargetType = skillInfo:GetTargetType(myself)
        if skillTargetType ~= nil then
          if quickuse then
            if skillTargetType == SkillTargetType.Point then
              FunctionSkillTargetPointLauncher.Me():Shutdown()
              if not skillInfo:UseMarkPoint() then
                FunctionSkillTargetPointLauncher.Me():Launch(skillIDAndLevel, true)
              else
                FunctionSkillTargetPointLauncher.Me():AutoLaunch(skillIDAndLevel, SkillProxy.Instance:GetMarkPoint())
              end
            else
              isUseSkill = myself:Client_QuickUseSkill(skillIDAndLevel, target, nil, noSearch, nil, nil, manual)
            end
          elseif skillTargetType == SkillTargetType.None then
            isUseSkill = myself:Client_UseSkill(skillIDAndLevel, nil, nil, nil, noSearch, nil, nil, nil, nil, nil, manual)
          elseif skillTargetType == SkillTargetType.Creature then
            if target then
              myself:Client_UseSkill(skillIDAndLevel, target, nil, nil, noSearch, nil, nil, nil, nil, nil, manual)
            else
              myself:Client_UseSkill(skillIDAndLevel, lockedTarget, nil, nil, noSearch, nil, nil, nil, nil, nil, manual)
            end
          else
            if skillTargetType == SkillTargetType.Point or autoLaunch then
              if auto or autoLaunch then
                FunctionSkillTargetPointLauncher.Me():AutoLaunch(skillIDAndLevel)
              elseif skillInfo:UseMarkPoint() then
                FunctionSkillTargetPointLauncher.Me():AutoLaunch(skillIDAndLevel, SkillProxy.Instance:GetMarkPoint())
              else
                FunctionSkillTargetPointLauncher.Me():Shutdown()
                FunctionSkillTargetPointLauncher.Me():Launch(skillIDAndLevel)
              end
            else
            end
          end
        end
      end
    end
    if not isUseSkill then
      MsgManager.ShowMsgByID(609)
    end
  end
end

function FunctionSkill:CancelSkill(skillIDAndLevel)
  local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillIDAndLevel)
  local skillTargetType = skillInfo:GetTargetType(Game.Myself)
  if skillTargetType == nil or skillTargetType == SkillTargetType.None then
  elseif skillTargetType == SkillTargetType.Creature then
  else
    if skillTargetType == SkillTargetType.Point then
      FunctionSkillTargetPointLauncher.Me():Shutdown()
    else
    end
  end
end

function FunctionSkill:HandleFunctionSkill(skillInfo)
  local logicParam = skillInfo.logicParam
  if logicParam ~= nil then
    if logicParam.shortcutID then
      FuncShortCutFunc.Me():CallByID(logicParam.shortcutID)
    elseif logicParam.msgid then
      MsgManager.ShowMsgByIDTable(logicParam.msgid)
    elseif logicParam.house then
      HomeManager.Me():EnterEditMode()
    elseif logicParam.select_mount then
      Game.SkillOptionManager:SelectMount(skillInfo:GetSkillID())
    elseif logicParam.booth then
      BoothProxy.Instance:JumpBoothView()
    elseif logicParam.heartlock_SKILLTYPE then
      redlog("logicParam.heartlock_SKILLTYPE", logicParam.heartlock_SKILLTYPE)
      if Game.MapManager:IsPVEMode_HeartLockRaid() then
        SgAIManager.Me():Client_UseSkill(logicParam.heartlock_SKILLTYPE, skillInfo)
      else
        self:UseHeartLockSkill(logicParam.heartlock_SKILLTYPE, skillInfo)
      end
    end
  else
    helplog(skillInfo.staticData.id, "没有配Logicparam")
  end
end

function FunctionSkill:UseHeartLockSkill(skilltype, skillinfo)
  if not skilltype then
    return
  end
  local skillFunc = self.heatlockSkillFuncMap[skilltype]
  if skillFunc then
    skillFunc(self, skillinfo)
  else
    redlog("skillFunc nil")
  end
end

local OutlineIitems = GameConfig.HeartLock.OutlineIitems
local InsightColor = {
  Full = LuaColor.New(1, 1, 1, 1),
  Empty = LuaColor.New(1, 0, 0, 1)
}

function FunctionSkill:HandleSkill_Insight(skillinfo)
  local isInHeartLockRaid = Game.MapManager:IsPVEMode_HeartLockRaid()
  if not skillinfo or self.isInsight then
    return
  end
  local skillid = skillinfo.staticData.id
  local skilldata = SevenRoyalFamiliesProxy.Instance:GetSkillInfo(skillid // 1000)
  local skilllv = 1
  if skilldata and isInHeartLockRaid then
    skilllv = skilldata.lv <= 0 and 1 or skilldata.lv
  else
    skilllv = skillinfo.staticData.Level
  end
  local dis = skillinfo.staticData.Launch_Range
  local myPos = Game.Myself:GetPosition()
  self.insightlist = {}
  local GOManager = Game.GameObjectManagers
  local objManager = GOManager[Game.GameObjectType.InsightGO]
  objManager:ShowNormalNPCOutline(dis)
  for i = 1, skilllv do
    local objects = objManager:GetObjByLv(i)
    local outlines = objManager:GetOutlineByLv(i)
    if objects then
      for objID, obj in pairs(objects) do
        local objPos = LuaGeometry.TempGetPosition(obj.transform)
        if dis >= LuaVector3.Distance(myPos, objPos) then
          local id = i * 1000 + objID
          local single = OutlineIitems and OutlineIitems[id]
          local flag = true
          if single and isInHeartLockRaid then
            if single.itemid then
              local itemNum = SgAIManager.Me():getItemById(id)
              if not itemNum or itemNum <= 0 then
                flag = false
              end
            end
            if single.skililld then
              local skilldata = SevenRoyalFamiliesProxy.Instance:GetSkillInfo(skillid // 1000)
              if not skilldata then
                flag = false
              end
            end
            if flag then
              outlines[objID % 1000].OutlineColor = InsightColor.Empty
            else
              outlines[objID % 1000].OutlineColor = InsightColor.Full
            end
          end
          outlines[objID % 1000].enabled = true
          self.insightlist[#self.insightlist + 1] = id
        else
          outlines[objID % 1000].enabled = false
          redlog("not closer")
        end
      end
    end
  end
  if isInHeartLockRaid then
    local diff = SevenRoyalFamiliesProxy.Instance:GetSkillInfo(4602)
    objManager = GOManager[Game.GameObjectType.StealthGame]
    objManager:ShowDoorOutline(dis, diff and diff.lv and diff.lv > 0)
    Game.PlotStoryManager:Start_PQTLP("11098")
    SgAIManager.Me():SetisInsight(true)
  end
  PostprocessManager.Instance:SetEffect("GreyOutlinePP")
  local data = {}
  data.effect = EffectMap.Maps.Insight_FullScreenEff or ""
  AudioUtility.PlayOneShot2D_Path(AudioMap.StealthGame.Insight_Start)
  if not self.insighBg then
    self.insighBg = AudioUtility.PlayLoop_At(AudioMap.StealthGame.Insight_Ongoing, 0, 0, 0, AudioSourceType.UI)
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.FullScreenEffectView,
    viewdata = data
  })
  self.isInsight = true
end

function FunctionSkill:CancelInsight()
  if self.isInsight then
    local isInHeartLockRaid = Game.MapManager:IsPVEMode_HeartLockRaid()
    self.isInsight = false
    local num = #self.insightlist
    local lv, id = 0, 0
    local GOManager = Game.GameObjectManagers
    local objManager = GOManager[Game.GameObjectType.InsightGO]
    objManager:HideNormalNPCOutline()
    for i = 1, num do
      local single = self.insightlist[i]
      lv = single // 1000
      id = single % 1000
      local outlines = objManager:GetOutlineByLv(lv)
      if outlines and outlines[id] then
        outlines[id].enabled = false
      else
        redlog("outline nil")
      end
    end
    if isInHeartLockRaid then
      objManager = GOManager[Game.GameObjectType.StealthGame]
      objManager:HideDoorOutline()
      SgAIManager.Me():SetisInsight(false)
    end
    EventManager.Me():DispatchEvent(UIEvent.RemoveFullScreenEffect)
    GameFacade.Instance:sendNotification(UIEvent.RemoveFullScreenEffect)
    if self.insighBg ~= nil then
      self.insighBg:Stop()
      self.insighBg = nil
    end
    PostprocessManager.Instance:ClearEffect()
  end
end

function FunctionSkill:HandleBreakCastBegin(creature, myself)
  if creature == nil then
    return
  end
  local skillInfo = creature.skill.info
  if skillInfo == nil then
    return
  end
  local skills = skillInfo:BokiBreakCast(creature)
  if skills == nil then
    return
  end
  local distance = skillInfo:BreakDistance(creature)
  if distance ~= nil then
    if myself == nil then
      return
    end
    if VectorUtility.DistanceXZ_Square(creature:GetPosition(), myself:GetPosition()) > distance * distance then
      return
    end
  end
  local skill
  local _BokiProxy = BokiProxy.Instance
  local _boki = _BokiProxy:GetSceneBoki()
  if nil == _boki then
    return
  end
  local _bokiAlive = not _boki:IsDead()
  for i = 1, #skills do
    skill = skills[i]
    if _BokiProxy:HasLearnSkill(skill) and _bokiAlive then
      GameFacade.Instance:sendNotification(SkillEvent.BreakCastBegin, creature.data.id)
      return
    end
  end
end

function FunctionSkill:HandleBreakCastEnd(creature)
  if creature == nil then
    return
  end
  local skillInfo = creature.skill.info
  if skillInfo == nil then
    return
  end
  local skill = skillInfo:BokiBreakCast(creature)
  if skill == nil then
    return
  end
  GameFacade.Instance:sendNotification(SkillEvent.BreakCastEnd)
end

function FunctionSkill:Shutdown()
  self:CancelInsight()
end
