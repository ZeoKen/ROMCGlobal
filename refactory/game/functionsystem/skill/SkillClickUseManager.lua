SkillClickUseManager = class("SkillClickUseManager")
local SkillInterval = 1000
local SkillUse_Opportunity_Cannot = 0
local SkillUse_Opportunity_Now = 1
local SkillUse_Opportunity_WaitForNext = 2
local SkillUse_Opportunity_WaitForCombo = 2
local AskUseSkillData = {}
local SpeicalComboMap = {
  [2523] = 2503
}
local HeinrichNormalAtk = 2731
local SkillWaitForUse = class("SkillWaitForUse")

function SkillWaitForUse:ctor()
  self.pointPos = LuaVector3()
  self.weakHoldData = {}
  setmetatable(self.weakHoldData, {__mode = "v"})
end

function SkillWaitForUse:SetSkillItemData(skillItemData, pos)
  self.weakHoldData[1] = skillItemData
  self:SetData(skillItemData.id, skillItemData:GetID(), skillItemData:GetPosInShortCutGroup(ShortCutProxy.ShortCutEnum.ID1))
end

function SkillWaitForUse:SetData(skillIDandLevel, launchSkillID, pos)
  self.skillIDandLevel = skillIDandLevel
  self.launchSkillID = launchSkillID
  self.pos = pos
  self.isPointPosType = false
  local skillInfo = Game.LogicManager_Skill:GetSkillInfo(launchSkillID)
  if skillInfo then
    local skillTargetType = skillInfo:GetTargetType()
    if skillTargetType == SkillTargetType.Point then
      self.isPointPosType = true
    end
  end
end

function SkillWaitForUse:SetSkillPointPos(pos)
  if pos then
    self.pointPos[1], self.pointPos[2], self.pointPos[3] = pos[1], pos[2], pos[3]
  end
end

function SkillWaitForUse:SetQuickUse(val)
  self.quickuse = val
end

function SkillWaitForUse:SetAutoLock(val)
  self.autoLock = val
end

function SkillWaitForUse:IsNull()
  return self.skillIDandLevel == nil
end

function SkillWaitForUse:CanUse()
  if FunctionSkill.Me().isCasting and not self.quickuse then
    return false
  end
  return true
end

function SkillWaitForUse:Cancel()
  self.skillIDandLevel = nil
  self.weakHoldData[1] = nil
  self.quickuse = nil
end

function SkillWaitForUse:GetSkillData()
  return self.weakHoldData[1]
end

function SkillWaitForUse:IsEqual(skillItemData)
  if skillItemData.id == self.skillIDandLevel and skillItemData:GetID() == self.launchSkillID and self.pos == skillItemData:GetPosInShortCutGroup(ShortCutProxy.ShortCutEnum.ID1) then
    return true
  end
  return false
end

function SkillWaitForUse:SetWaitEnd(time)
  self.waitEndtime = time
end

function SkillWaitForUse:GetWaitEnd()
  return self.waitEndtime
end

function SkillWaitForUse:SetRollBackSkill(parentSortID)
  self.parentSkill = parentSortID
end

function SkillWaitForUse:SetRootSkill(rootSortID)
  self.rootSkill = rootSortID
end

function SkillWaitForUse:GetRootSkill()
  return self.rootSkill
end

function SkillClickUseManager:ctor()
  self._waitForUse = SkillWaitForUse.new()
  self._preWaitForUse = SkillWaitForUse.new()
  self._waitForCombo = SkillWaitForUse.new()
  self.currentSelectPhaseSkillID = 0
  EventManager.Me():AddEventListener(FunctionSkillTargetPointLauncherEvent.StateChanged, self.HandlePhaseSkillEffect, self)
end

function SkillClickUseManager:GetNextUseSkillID()
  return self._waitForUse.skillIDandLevel
end

function SkillClickUseManager:Launch()
  if self.running then
    return
  end
  self.running = true
  EventManager.Me():AddEventListener(LoadSceneEvent.BeginLoadScene, self.OnSceneBeginChanged, self)
  EventManager.Me():AddEventListener(MyselfEvent.TransformChange, self.OnTransformChangeHandler, self)
  EventManager.Me():AddEventListener(SkillEvent.SkillUpdate, self.OnSkillUpdateHandler, self)
end

function SkillClickUseManager:ShutDown()
  if not self.running then
    return
  end
  self.running = false
  EventManager.Me():RemoveEventListener(LoadSceneEvent.BeginLoadScene, self.OnSceneBeginChanged, self)
  EventManager.Me():RemoveEventListener(MyselfEvent.TransformChange, self.OnTransformChangeHandler, self)
  EventManager.Me():RemoveEventListener(SkillEvent.SkillUpdate, self.OnSkillUpdateHandler, self)
  self:_CancelWaitForUse()
  self:_CancelWaitForCombo()
end

function SkillClickUseManager:OnTransformChangeHandler()
  self:_CancelWaitForUse()
  self:_CancelWaitForCombo()
end

function SkillClickUseManager:OnSkillUpdateHandler()
  if self._waitForUse:IsNull() then
    return
  end
  local skillItemData = SkillProxy.Instance:GetEquipedSkillByGuid(self._waitForUse.skillIDandLevel, false)
  if skillItemData then
    if not self._waitForUse:IsEqual(skillItemData) then
      self:_CancelWaitForUse()
    end
  else
    self:_CancelWaitForUse()
  end
end

function SkillClickUseManager:OnSceneBeginChanged()
  self:_CancelWaitForUse()
  self:_CancelWaitForCombo()
end

function SkillClickUseManager:_CancelWaitForUse()
  if self._preWaitForUse:IsNull() == false then
    self._preWaitForUse:Cancel()
  end
  if self._waitForUse:IsNull() then
    return
  end
  self._waitForUse:Cancel()
  GameFacade.Instance:sendNotification(SkillEvent.SkillCancelWaitNextUse)
end

function SkillClickUseManager:_ChangeWaitForUse(skillItemData, pointPos, clampInLaunchRange, quickuse, autoLock)
  self._waitForUse:SetSkillItemData(skillItemData)
  self._waitForUse:SetSkillPointPos(pointPos)
  self._waitForUse:SetQuickUse(quickuse)
  self._waitForUse:SetAutoLock(autoLock)
  GameFacade.Instance:sendNotification(SkillEvent.SkillWaitNextUse, skillItemData:GetID())
end

function SkillClickUseManager:ClickSkill(shortcutSkillCell, auto)
  local data = shortcutSkillCell.data
  local id = data:GetID()
  if id ~= 0 then
    if Game.SkillComboManager:PushSkill(id) then
      return
    end
    self:_TryAutoOption(id)
    local _SkillProxy = SkillProxy.Instance
    local opportunity, quickuse
    if FunctionSkill.Me().isCasting then
      local info = Game.Myself.skill.info
      if info and info:GetSkillID() // 1000 == id // 1000 and info:CanClientInterrupt() then
        return Game.Myself:Client_BreakSkillLead(id, true)
      end
      local clientskill = Game.Myself.skill
      if info and info:GetSkillID() // 1000 == id // 1000 and clientskill:IsCastingMoveRunSkill() then
        clientskill:_SwitchToAttack(Game.Myself)
        Game.Myself:Logic_LookAtTargetPos()
        return
      end
      if info:CanUseOtherSkill(id, Game.Myself) then
        opportunity = self:_SkillUseOpportunity(data)
        quickuse = true
      else
        opportunity = SkillUse_Opportunity_WaitForNext
      end
    else
      opportunity = self:_SkillUseOpportunity(data)
    end
    if opportunity == SkillUse_Opportunity_Now then
      self:_CancelWaitForUse()
      if self.currentSelectPhaseSkillID == id then
        GameFacade.Instance:sendNotification(MyselfEvent.CancelAskUseSkill, id)
      else
        if HeinrichNormalAtk == id // 1000 then
          AskUseSkillData.skill = Game.Myself:GetFakeNormalAtkID()
        else
          AskUseSkillData.skill = id
        end
        AskUseSkillData.auto = auto
        AskUseSkillData.quickuse = quickuse
        local info = Game.Myself.skill.info
        if Game.Myself:IsMoving() and info and info:IsKnightSkill() then
          Game.Myself:Logic_StopMove()
          Game.Myself:Logic_PlayAction_Idle()
        end
        local skillInfo = Game.LogicManager_Skill:GetSkillInfo(id)
        local bufftype = skillInfo and skillInfo:GetCheckBufftType()
        if bufftype and Game.Myself.data:GetBuffTypes(bufftype) then
          Game.Myself:Client_QuickUseSkill(id)
          return
        end
        GameFacade.Instance:sendNotification(MyselfEvent.AskUseSkill, AskUseSkillData)
      end
    elseif self.running then
      if self._waitForUse:IsEqual(data) then
        self:_CancelWaitForUse()
      else
        local costEnough, costs = SkillProxy.Instance:HasFitSpecialCost(data)
        if not costEnough and costs then
          local cost, costData = costs[1], Table_Item[costs[1][1]]
          if costData then
            local itemIds = string.format("%s;%s", tonumber(cost[1] or "") or 0, tonumber(cost[2] or "") or 0)
            local itemNames = costData.NameZh
            for i = 2, #costs do
              cost, costData = costs[i], Table_Item[costs[i][1]]
              itemIds = itemIds .. ";" .. string.format("%s;%s", tonumber(cost[1] or "") or 0, tonumber(cost[2] or "") or 0)
              itemNames = itemNames .. "," .. costData.NameZh
            end
            MsgManager.ShowMsgByIDTable(96, {itemIds, itemNames})
            MsgManager.ShowMsgByIDTable(97, {itemNames})
            return
          end
        end
        local notFit = false
        if not _SkillProxy:IsFitPreCondition(data) and not _SkillProxy:RandomSkill(609) then
          notFit = true
          FunctionSkillEnableCheck.Me():MsgNotFit(data)
        end
        if _SkillProxy:GetRandomSkillID() ~= nil then
          return
        end
        local skillInfo = Game.LogicManager_Skill:GetSkillInfo(id)
        if skillInfo then
          local skillTargetType = skillInfo:GetTargetType()
          if skillTargetType == SkillTargetType.Point then
            if notFit and skillInfo:IsPointEffectTrack() then
              return
            end
            self._preWaitForUse:SetSkillItemData(data)
            if skillInfo:UseMarkPoint() then
              FunctionSkillTargetPointLauncher.Me():AutoLaunch(id, _SkillProxy:GetMarkPoint())
            else
              FunctionSkillTargetPointLauncher.Me():Shutdown()
              FunctionSkillTargetPointLauncher.Me():Launch(id)
            end
          else
            self:_ChangeWaitForUse(data, nil, nil, quickuse)
          end
        end
      end
    end
  else
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.CharactorProfessSkill
    })
  end
end

function SkillClickUseManager:_SkillUseOpportunity(skillItemData)
  if skillItemData ~= nil then
    if not skillItemData.shadow then
      if not SkillProxy.Instance:SkillCanBeUsed(skillItemData) then
        return SkillUse_Opportunity_WaitForNext
      else
        if Game.Myself.data:GetAttackSkillIDAndLevel() ~= skillItemData.staticData.id then
          local _CDProxy = CDProxy.Instance
          local timeStamp = _CDProxy:GetTimeStampMapById(CDProxy.CommunalSkillCDSortID)
          local lefttime = skillItemData:GetLeftCDTimes() or -1
          if timeStamp ~= nil and ServerTime.ServerTime - timeStamp <= SkillInterval then
            local skillStaticdata = skillItemData.staticData
            local specialType = skillStaticdata.Logic_Param and skillStaticdata.Logic_Param.special_type
            if specialType and specialType == "knight" then
              return SkillUse_Opportunity_Now
            end
            if 0 < lefttime then
              return SkillUse_Opportunity_Now
            elseif lefttime == 0 then
              return SkillUse_Opportunity_Cannot
            end
            return SkillUse_Opportunity_WaitForNext
          end
        end
        return SkillUse_Opportunity_Now
      end
    end
    return SkillUse_Opportunity_Cannot
  end
  return SkillUse_Opportunity_Cannot
end

function SkillClickUseManager:HandlePhaseSkillEffect(evt)
  local funcSkill = FunctionSkillTargetPointLauncher.Me()
  local skill = funcSkill.skillIDAndLevel
  if funcSkill.running then
    self.currentSelectPhaseSkillID = skill
  elseif not skill or skill == self.currentSelectPhaseSkillID then
    self.currentSelectPhaseSkillID = 0
  end
  GameFacade.Instance:sendNotification(SkillEvent.SkillSelectPhaseStateChange)
end

function SkillClickUseManager:TryLaunchPointTargetTypeSkill(skillIDAndLevel, point, autoLock, quickuse)
  if self._preWaitForUse:IsNull() then
    local ret, msg
    if not quickuse then
      ret, msg = Game.Myself:Client_UseSkill(skillIDAndLevel, nil, point, nil, nil, nil, nil, nil, nil, nil, true, autoLock)
    else
      ret, msg = Game.Myself:Client_QuickUseSkill(skillIDAndLevel, nil, point)
    end
    if msg ~= nil then
      MsgManager.ShowMsgByID(msg)
    end
  elseif self._preWaitForUse.launchSkillID == skillIDAndLevel then
    self:_ChangeWaitForUse(self._preWaitForUse:GetSkillData(), point, nil, quickuse, autoLock)
    self._preWaitForUse:Cancel()
  end
end

local curTime = 0

function SkillClickUseManager:Update(time, deltaTime)
  if self._waitForCombo:IsNull() == false then
    local waitEndtime = self._waitForCombo:GetWaitEnd()
    curTime = ServerTime.CurServerTime() / 1000
    if waitEndtime < curTime then
      self:_CancelWaitForCombo()
    end
  end
  if not self.running then
    return
  end
  if self._waitForUse:IsNull() == false and self._waitForUse:CanUse() then
    local skillItemData = self._waitForUse:GetSkillData()
    if skillItemData then
      if self:_SkillUseOpportunity(skillItemData) == SkillUse_Opportunity_Now then
        local id = self._waitForUse.launchSkillID
        local skillInfo = Game.LogicManager_Skill:GetSkillInfo(id)
        if skillInfo then
          local skillTargetType = skillInfo:GetTargetType()
          if skillTargetType == SkillTargetType.Point then
            if self._waitForUse.quickuse then
              Game.Myself:Client_QuickUseSkill(id, nil, self._waitForUse.pointPos)
              self:_CancelWaitForUse()
              return
            end
            Game.Myself:Client_UseSkill(id, nil, self._waitForUse.pointPos, nil, nil, nil, nil, nil, nil, nil, true, self._waitForUse.autoLock)
          elseif self._waitForUse.quickuse then
            AskUseSkillData.skill = id
            AskUseSkillData.auto = nil
            AskUseSkillData.quickuse = self._waitForUse.quickuse
            GameFacade.Instance:sendNotification(MyselfEvent.AskUseSkill, AskUseSkillData)
          else
            GameFacade.Instance:sendNotification(MyselfEvent.AskUseSkill, id)
          end
        end
        self:_CancelWaitForUse()
      end
    else
      self:_CancelWaitForUse()
    end
  end
end

function SkillClickUseManager:_TryInitAutoOption()
  if self.autoOptionMap == nil then
    self.autoOptionMap = {}
    local autoOptionID = GameConfig.SkillAutoOptionID
    local staticData, id, logicParam
    for i = 1, #autoOptionID do
      id = autoOptionID[i]
      staticData = Table_Skill[id]
      if staticData ~= nil then
        logicParam = staticData.Logic_Param
        self:_TryInsertAutoOption(logicParam.skill_opt_ids, id)
        self:_TryInsertAutoOption(logicParam.skill_opt_learn, id)
      end
    end
  end
end

function SkillClickUseManager:_TryInsertAutoOption(skill, autoOptionID)
  if skill == nil then
    return
  end
  local autoOptionSkill
  for i = 1, #skill do
    autoOptionSkill = self.autoOptionMap[skill[i]]
    if autoOptionSkill == nil then
      autoOptionSkill = {}
      self.autoOptionMap[skill[i]] = autoOptionSkill
    end
    autoOptionSkill[#autoOptionSkill + 1] = autoOptionID
  end
end

function SkillClickUseManager:_TryAutoOption(id)
  self:_TryInitAutoOption()
  local sortID = math.floor(id / 1000)
  local autoOptionID = self.autoOptionMap[sortID]
  if autoOptionID ~= nil then
    for i = 1, #autoOptionID do
      local staticData = Table_Skill[autoOptionID[i]]
      if staticData ~= nil then
        local optionType = staticData.Logic_Param.skill_opt_type
        if optionType ~= nil then
          local _SkillOptionManager = Game.SkillOptionManager
          if _SkillOptionManager:GetSkillOption(optionType) ~= sortID then
            _SkillOptionManager:SetSkillOption(optionType, sortID)
          end
        end
      end
    end
  end
end

function SkillClickUseManager:_CancelWaitForCombo()
  if self._waitForCombo:IsNull() then
    return
  end
  local rootID = self._waitForCombo:GetRootSkill()
  local skillID = self._waitForCombo.skillIDandLevel
  if rootID then
    local rootSkilldata = SkillProxy.Instance:GetLearnedSkillBySortID(rootID)
    local originalReplaceID = rootSkilldata and rootSkilldata:GetOriginalReplaceID()
    local rollbackID = originalReplaceID and originalReplaceID ~= 0 and originalReplaceID // 1000 or rootID
    local skilldata = SkillProxy.Instance:GetLearnedSkillBySortID(rollbackID)
    if skilldata then
      Game.SkillComboManager:SetReplaceSkill(rollbackID)
      GameFacade.Instance:sendNotification(SkillEvent.SkillCancelWaitNextCombo, {parentID = rootID, skillItemData = skilldata})
    else
      local skilldata = SkillProxy.Instance:GetLearnedSkillBySortID(rollbackID)
      if skilldata then
        Game.SkillComboManager:SetReplaceSkill(rollbackID)
        GameFacade.Instance:sendNotification(SkillEvent.SkillCancelWaitNextCombo, {parentID = rootID, skillItemData = skilldata})
      else
        local newRollBack = SpeicalComboMap[rollbackID] or nil
        if newRollBack then
          local rollbackSkilldata = SkillProxy.Instance:GetLearnedSkillBySortID(newRollBack)
          if rollbackSkilldata then
            local lv = rollbackSkilldata:getLevel() or 1
            local newSkillid = rollbackSkilldata:GetOriginalReplaceID()
            local replaceSkilldata = SkillItemData.new(newSkillid, 0, 0, 0, 0)
            replaceSkilldata.learned = true
            Game.SkillComboManager:SetReplaceSkill(newRollBack, newSkillid)
            GameFacade.Instance:sendNotification(SkillEvent.SkillCancelWaitNextCombo, {parentID = rootID, skillItemData = replaceSkilldata})
          end
        end
      end
    end
  end
  self._waitForCombo:Cancel()
  Game.SkillComboManager:OnEnd(skillID)
  FunctionSkillTargetPointLauncher.Me():Shutdown()
end

function SkillClickUseManager:_SetWaitForCombo(skillItemData, parentID, rootID)
  self._waitForCombo:SetSkillItemData(skillItemData)
  local skilldata = SkillProxy.Instance:GetLearnedSkillBySortID(parentID)
  if not skilldata then
    parentID = parentID * 1000 + 1
  else
    parentID = skilldata:GetID()
  end
  self._waitForCombo:SetRollBackSkill(parentID)
  self._waitForCombo:SetRootSkill(rootID)
  local curTime = ServerTime.CurServerTime() / 1000
  self._waitForCombo:SetWaitEnd(curTime + skillItemData:GetWaitComboTime())
  FunctionSkillTargetPointLauncher.Me():Shutdown()
  Game.SkillComboManager:SetReplaceSkill(SpeicalComboMap[rootID] or rootID, skillItemData:GetID())
  GameFacade.Instance:sendNotification(SkillEvent.SkillWaitNextCombo, {parentID = rootID, skillItemData = skillItemData})
end

function SkillClickUseManager:SetWaitForCombo(skillid)
  local staticData = skillid and Table_Skill[skillid]
  if not staticData then
    return
  end
  local nextComboID = staticData.Logic_Param.nextComboID
  local finishComboID, finishReplaceComboID
  if not nextComboID then
    nextComboID = staticData.Logic_Param.finishComboID
    finishComboID = nextComboID
    if not nextComboID then
      nextComboID = staticData.Logic_Param.finishReplaceComboID
      finishReplaceComboID = nextComboID
    end
  end
  local rollbackComboID = staticData.Logic_Param.rollbackComboID
  local comboConditionID = staticData.Logic_Param.comboConditionSkill
  local _SkillProxy = SkillProxy.Instance
  if nextComboID then
    if comboConditionID then
      local skilldata = _SkillProxy:GetLearnedSkillBySortID(comboConditionID)
      if skilldata then
        local skill = _SkillProxy:GetLearnedSkillBySortID(nextComboID)
        if not skill then
          skill = SkillItemData.new(nextComboID * 1000 + 1, 0, 0, 0, 0)
          skill.learned = true
        end
        self:_SetWaitForCombo(skill, staticData.id // 1000, rollbackComboID)
      else
        self:_CancelWaitForCombo()
      end
    else
      self:_CancelWaitForCombo()
    end
  end
end

function SkillClickUseManager:GetWaitForCombo()
  if not self._waitForCombo or self._waitForCombo:IsNull() then
    return nil
  end
  return self._waitForCombo:GetRootSkill(), self._waitForCombo.skillIDandLevel
end
