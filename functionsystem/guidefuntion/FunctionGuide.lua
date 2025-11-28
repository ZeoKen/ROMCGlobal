FunctionGuide = class("FunctionGuide", EventDispatcher)
autoImport("GuideFun")
autoImport("GuideMaskView")
autoImport("FunctionGuide_Map")

function FunctionGuide.Me()
  if nil == FunctionGuide.me then
    FunctionGuide.me = FunctionGuide.new()
  end
  return FunctionGuide.me
end

function FunctionGuide:ctor()
end

function FunctionGuide:stopGuide()
  if GuideMaskView.Instance then
    GuideMaskView.Instance:CloseSelf()
  end
end

function FunctionGuide:tryStopGuide()
  local instance = GuideMaskView.Instance
  if instance and instance:isAutoComplete() then
    instance:CloseSelf()
  end
end

function FunctionGuide:skillPointCheck(value)
  self:checkQuestGuide(3, value)
end

function FunctionGuide:buyItemCheck(value)
  self:checkQuestGuide(2, value)
end

function FunctionGuide:attrPointCheck(value)
  self:checkQuestGuide(1, value)
end

function FunctionGuide:attrPointReduceCheck(value)
  self:checkQuestGuide(4, value)
end

function FunctionGuide:checkQuestGuide(optionId, value)
  local instance = GuideMaskView.Instance
  if instance and instance.guideData then
    local sGuideData = instance.guideData.staticData
    if sGuideData and sGuideData.optionId and sGuideData.optionId == optionId then
      local optionData = Table_GuideOption[optionId]
      if optionData then
        do
          local type = optionData.content.type
          local dataValue = optionData.content.value
          local complete = false
          if type == ">" then
            if value > dataValue then
              complete = true
            end
          elseif type == "<" then
            if value < dataValue then
              complete = true
            end
          else
            if type == "==" and value == dataValue then
              complete = true
            else
            end
          end
          if complete then
            if instance.lastOption == optionId then
              return
            end
            instance.lastOption = optionId
            do
              local questData = instance.guideData.questData
              if questData then
                QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
              else
              end
            end
          else
          end
        end
      end
    else
    end
  end
end

function FunctionGuide:checkGuideStateWhenExit(singleOrList)
  local instance = GuideMaskView.Instance
  local guideData = instance and instance.guideData
  local sGuideData = guideData and instance.guideData.staticData
  if sGuideData then
    local questData = instance and instance.guideData and instance.guideData.questData
    local currentGuideId = instance.currentGuideId
    local curBtnId = instance.currentTriggerId or -1
    if type(singleOrList) == "table" then
      for i = 1, #singleOrList do
        local single = singleOrList[i]
        if currentGuideId == single.id then
          if curBtnId == sGuideData.ButtonID and sGuideData.ButtonID == 202 then
            instance:restoreParent(true)
          else
            instance:restoreParent()
          end
          if sGuideData ~= nil then
            if guideData.clientKey and guideData.closeuijump then
              if guideData.closeuijump == 0 then
                self:finishClientGuide(guideData.clientKey, false)
              else
                self:stepClientGuide(guideData.clientKey, guideData.closeuijump)
              end
              instance:CloseSelf()
              return
            end
            if curBtnId ~= sGuideData.ButtonID then
              if questData then
                QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FailJump)
              end
              instance:CloseSelf()
              return
            else
            end
          end
        end
      end
      return
    else
      if currentGuideId == singleOrList and curBtnId ~= sGuideData.ButtonID then
        if questData then
          QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FailJump)
        end
        instance:CloseSelf()
      else
      end
    end
  else
  end
end

function FunctionGuide:triggerWithTag(tag)
  local instance = GuideMaskView.Instance
  local guideData = instance and instance.guideData
  if guideData then
    local sGuideData, questData = guideData.staticData, guideData.questData
    local btnId = sGuideData.ButtonID
    if btnId and btnId == tag then
      do
        local sameButton = instance.currentTriggerId and instance.currentTriggerId == btnId or false
        local clickCauseComplete = sGuideData.press
        clickCauseComplete = clickCauseComplete and clickCauseComplete == 1
        if clickCauseComplete and not sameButton then
          instance.currentTriggerId = btnId
          if not instance:isAutoComplete() then
            if questData then
              QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
            elseif guideData.clientKey then
              self:stepClientGuide(guideData.clientKey)
            end
          end
          do
            local guideType = guideData.guideType
            if guideType == QuestDataGuideType.QuestDataGuideType_force or guideType == QuestDataGuideType.QuestDataGuideType_force_with_arrow then
              instance:restoreParent()
            end
            if not instance:HideOnClick() then
              instance:Show(instance.mask)
            end
            if instance:isAutoComplete() or instance:CloseOnClick() then
              self:stopGuide()
            else
            end
          end
        else
        end
      end
    end
  else
  end
end

function FunctionGuide:triggerWithoutTag()
  local instance = GuideMaskView.Instance
  local guideData = instance and instance.guideData
  if guideData then
    local sGuideData, questData = guideData.staticData, guideData.questData
    local isShowHollowMask = sGuideData.hollows and #sGuideData.hollows > 0
    if guideData.guideType == QuestDataGuideType.QuestDataGuideType_force_with_arrow and isShowHollowMask then
      instance:restoreMask()
      if not instance:isAutoComplete() then
        if questData then
          QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
        elseif guideData.clientKey then
          self:stepClientGuide(guideData.clientKey)
        end
      end
      if instance:isAutoComplete() or instance:CloseOnClick() then
        self:stopGuide()
      end
    end
  end
end

local _NotifyGuideQuest = function(questData, isEnd)
  if isEnd then
    QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FailJump)
  end
end

function FunctionGuide:showGuideByQuestData(questData)
  if not questData then
    return
  end
  if questData.params and questData.params.guidekey then
    if questData.params.endstep then
      self:startClientGuide(questData.params.guidekey, _NotifyGuideQuest, questData:cloneSelf())
    else
      self:startClientGuide(questData.params.guidekey)
    end
    return
  end
  local instance = GuideMaskView.getInstance()
  if instance and instance.forbid then
    return
  end
  instance:restoreParent()
  instance:resetData()
  local guideId = questData.params.guideID
  local guideType = questData.params.type
  local sGuideData = Table_GuideID[guideId]
  local guideAutoComplete = questData.params.autocomplete
  if guideId == 66 then
    QuestProxy.Instance:SelfDebug("showGuideByQuestData这个是背包中的东西 要十分谨慎的处理guideId:" .. guideId)
  end
  if sGuideData then
    local tag = sGuideData.ButtonID
    local moveToTag = sGuideData.ButtonID2
    if sGuideData.Preguide and sGuideData.Preguide ~= instance.currentGuideId and sGuideData.IsJump ~= 1 then
      QuestProxy.Instance:SelfDebug("当前任务的前置引导未完成需要回退  sGuideData.Preguide：" .. tostring(sGuideData.Preguide) .. "instance.currentGuideId:" .. tostring(instance.currentGuideId))
      QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FailJump)
      return
    end
    if tag and moveToTag == nil then
      local tagObj = GuideTagCollection.getGuideItemById(tag)
      local targetUI = UIManagerProxy.Instance:GetNodeByViewName(sGuideData.uiID)
      local isTargetUIVisible = true
      if targetUI then
        local uiCam = NGUIUtil:GetCameraByLayername("UI")
        local viewPos = uiCam:WorldToViewportPoint(targetUI.gameObject.transform.position)
        isTargetUIVisible = targetUI.gameObject.activeInHierarchy and viewPos.x >= 0 and 1 >= viewPos.x and 0 <= viewPos.y and 1 >= viewPos.y
      end
      if tagObj and not Game.GameObjectUtil:ObjectIsNULL(tagObj) and tagObj.gameObject.activeInHierarchy and isTargetUIVisible then
        QuestProxy.Instance:SelfDebug("instance:showGuideByQuestData(questData)")
        instance:showGuideByQuestData(questData)
        if guideAutoComplete then
          QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
        end
      elseif not tagObj and sGuideData.ServerEvent ~= "" then
        helplog("wait ServerEvent:", sGuideData.ServerEvent)
        instance:waitServerEvent(sGuideData.ServerEvent, questData)
      else
        if tagObj then
          helplog("obj activeInHierarchy:", tagObj.gameObject.activeInHierarchy)
        end
        QuestProxy.Instance:SelfDebug("can't find obj by tag:", tag, questData.staticData.FailJump)
        local FailJump = sGuideData.FailJump
        QuestProxy.Instance:SelfDebug("can't find obj by tag:1")
        if FailJump == 1 then
          if tag == 201 and BagProxy.Instance:GetItemsByStaticID(5400) ~= nil then
            QuestProxy.Instance:SelfDebug("说明这个时候在背包内但是没显示 所以要持续检查")
            FunctionGuideChecker.Me():AddGuideCheck(questData)
          else
            QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FailJump)
            QuestProxy.Instance:SelfDebug("can't find obj by tag:2")
          end
        else
          FunctionGuideChecker.Me():AddGuideCheck(questData)
          QuestProxy.Instance:SelfDebug("can't find obj by tag:3")
        end
        return
      end
    elseif guideType == QuestDataGuideType.QuestDataGuideType_showDialog then
      if self:checkGuideMap(questData.map) then
        QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FailJump)
        GameFacade.Instance:sendNotification(GuideEvent.ShowBubble, sGuideData.BubbleID)
        helplog("QuestDataGuideType_showDialog Show Bubble guide !FinishJump:", questData.staticData.FinishJump, sGuideData.BubbleID)
      else
        QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FailJump)
        helplog("QuestDataGuideType_showDialog Show Bubble guide !FailJump:", questData.staticData.FailJump, sGuideData.BubbleID)
      end
      instance:CloseSelf()
    elseif guideType == QuestDataGuideType.QuestDataGuideType_showDialog_Repeat then
      if self:checkGuideMap(questData.map) then
        local bubbleId = sGuideData.BubbleID
        if bubbleId and Table_BubbleID[bubbleId] then
          GameFacade.Instance:sendNotification(GuideEvent.ShowBubble, bubbleId)
          local bubbleData = Table_BubbleID[bubbleId]
          local delayTime = bubbleData.RepeatDeltaTime or 60
          local questId = questData.id
          local step = questData.step
          self:CheckBubbleGuideRepeat(questId, step, delayTime)
        end
      else
        QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FailJump)
      end
      instance:CloseSelf()
    elseif guideType == QuestDataGuideType.QuestDataGuideType_showDialog_Anim then
      if self:checkGuideMap(questData.map) then
        local bubbleId = sGuideData.BubbleID
        GameFacade.Instance:sendNotification(GuideEvent.MiniMapAnim, {questData = questData, bubbleId = bubbleId})
      else
        QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FailJump)
      end
      instance:CloseSelf()
    elseif guideType == QuestDataGuideType.QuestDataGuideType_force_with_arrow then
      local isShowHollowMask = sGuideData.hollows and 0 < #sGuideData.hollows
      if isShowHollowMask then
        instance:showGuideByQuestData(questData)
      end
    elseif guideType == QuestDataGuideType.QuestDataGuideType_slide then
      instance:showGuideByQuestData(questData)
    else
      QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FailJump)
      return
    end
  else
    QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FailJump)
    return
  end
end

function FunctionGuide:setGuideUIActive(tag, bRet)
  local instance = GuideMaskView.Instance
  if instance and instance.guideData then
    repeat
      local sGuideData = instance.guideData.staticData
      local btnId = sGuideData.ButtonID
      if btnId and btnId == tag then
        instance:setGuideUIActive(bRet)
      else
      end
      break -- pseudo-goto
    until true
  else
  end
end

function FunctionGuide:checkGuideMap(map)
  local currentMapID = Game.MapManager:GetMapID()
  if currentMapID == map then
    return true
  else
    return false
  end
end

function FunctionGuide:CanRemoveGuideInDialog()
  local instance = GuideMaskView.Instance
  local guideData = instance and instance.guideData
  if not guideData then
    return
  end
  local sGuideData, questData = guideData.staticData, guideData.questData
  if guideData.uiID ~= "DialogView" and questData then
    QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FailJump)
    self:stopGuide()
  end
end

function FunctionGuide:CheckBubbleGuideRepeat(questId, step, delayTime)
  TimeTickManager.Me():CreateOnceDelayTick(delayTime * 1000, function(owner, deltaTime)
    local data = QuestProxy.Instance:getQuestDataByIdAndType(questId)
    local count = QuestProxy.Instance:GetTraceCellCount()
    local noTraceCells = not count or count <= 0
    if data and data.step == step and noTraceCells then
      QuestProxy.Instance:notifyQuestState(data.scope, questId, data.staticData.FailJump)
    elseif data then
      QuestProxy.Instance:notifyQuestState(data.scope, questId, data.staticData.FinishJump)
    end
  end, self)
end

function FunctionGuide:checkHasGuide(questId)
  local questData = QuestProxy.Instance:getQuestDataByIdAndType(questId)
  if questData ~= nil then
    return questData
  end
  return nil
end

function FunctionGuide:finishedSlideGuide()
  if GuideMaskView.Instance ~= nil then
    GuideMaskView.Instance:finishedSlideGuide()
  end
end

function FunctionGuide:startClientGuide(guideKey, finishCall, finishCallParam)
  if not GuideFun or not GuideFun[guideKey] then
    return
  end
  self:stopGuide()
  if not self.clientGuideData then
    self.clientGuideData = {}
  end
  local info = self.clientGuideData[guideKey]
  if not info then
    info = {}
    self.clientGuideData[guideKey] = info
  end
  info.finishCall = finishCall
  info.finishCallParam = finishCallParam
  info.step = 0
  self:clearCustomGuideParam(guideKey)
  self:stepClientGuide(guideKey)
end

function FunctionGuide:stepClientGuide(guideKey, step)
  local info = self.clientGuideData and self.clientGuideData[guideKey]
  if not info then
    return
  end
  local instance = GuideMaskView.Instance
  if instance then
    instance:restoreParent()
    instance:ResetGirlHintCt()
  end
  if info.config and info.config.params.finish then
    self:finishClientGuide(guideKey, true)
    return
  end
  if step then
    info.step = step
  else
    info.step = info.step + 1
  end
  info.config = GuideFun[guideKey][info.step]
  if not info.config then
    self:finishClientGuide(guideKey, true)
  else
    self:excuteClientGuide(guideKey, info.config)
  end
end

local guideClientFunc = {
  guide = function(config, key)
    local instance = GuideMaskView.getInstance()
    if instance and instance.forbid then
      return
    end
    instance:SetClientGuideData(config, key)
    local serverEvent = instance.guideData.staticData.ServerEvent
    if not instance:showGuide() then
      if type(serverEvent) == "string" and serverEvent ~= "" then
        instance:clientWaitGuide(instance.guideData)
      end
      if config.params and config.params.waitbuttonenable then
        instance:waitButtonEnable()
      end
    end
  end,
  check_techtreefull = function(config, key)
    local costItem = GameConfig.NoviceTechTree.CostItem or 6927
    local bagNum = HappyShopProxy.Instance:GetItemNum(costItem)
    if 0 < bagNum then
      return 1
    end
    return 0
  end,
  trace_crackraid = function(config, key)
    FunctionGuide.Me():setCustomGuideParam(key, "trace_crackraid", config.params)
    return 1
  end,
  fake_crackraid = function(config, key)
    FunctionGuide.Me():setCustomGuideParam(key, "fake_crackraid", config.params)
    return 1
  end
}
local guideClientDelay = {guide = 33}

function FunctionGuide:excuteClientGuide(guideKey, config)
  local func = guideClientFunc[config.type]
  if func then
    local delay = guideClientDelay[config.type]
    if delay then
      TimeTickManager.Me():CreateOnceDelayTick(delay, function(owner, deltaTime)
        local retBranch = func(config, guideKey)
        if retBranch then
          local retStep = config.branch and config.branch[retBranch]
          self:stepClientGuide(guideKey, retStep)
        end
      end, self)
    else
      local retBranch = func(config, guideKey)
      if retBranch then
        local retStep = config.branch and config.branch[retBranch]
        self:stepClientGuide(guideKey, retStep)
      end
    end
  end
end

function FunctionGuide:finishClientGuide(guideKey, isEnd)
  redlog("client引导结束", guideKey)
  local info = self.clientGuideData and self.clientGuideData[guideKey]
  if info then
    if info.finishCall then
      info.finishCall(info.finishCallParam, isEnd)
    end
    self.clientGuideData[guideKey] = nil
  end
end

function FunctionGuide:setCustomGuideParam(guideKey, paramKey, params)
  if not self.customGuideParam then
    self.customGuideParam = {}
  end
  if not self.customGuideParam[guideKey] then
    self.customGuideParam[guideKey] = {}
  end
  self.customGuideParam[guideKey][paramKey] = params
end

function FunctionGuide:tryTakeCustomGuideParam(guideKey, paramKey)
  if not self.customGuideParam then
    return nil
  end
  local ret
  if guideKey == nil then
    for key, guideParam in pairs(self.customGuideParam) do
      if guideParam[paramKey] then
        ret = guideParam[paramKey]
        guideParam[paramKey] = nil
        break
      end
    end
  elseif self.customGuideParam[guideKey] and self.customGuideParam[guideKey][paramKey] then
    ret = self.customGuideParam[guideKey][paramKey]
    self.customGuideParam[guideKey][paramKey] = nil
  end
  return ret
end

function FunctionGuide:clearCustomGuideParam(guideKey)
  if self.customGuideParam then
    self.customGuideParam[guideKey] = nil
  end
end

function FunctionGuide:checkClientGuide()
  local canHire = FunctionUnLockFunc.Me():CheckCanOpen(3050)
  local noServant = MyselfProxy.Instance:GetMyServantID() == 0
  if canHire and noServant then
    FunctionClientGuide.Me():StartGuide("hireservant")
  end
end
