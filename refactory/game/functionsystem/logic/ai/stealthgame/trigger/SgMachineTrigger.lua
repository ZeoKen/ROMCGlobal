SgDoorGroup = class("SgDoorGroup")

function SgDoorGroup:ctor()
  self.manager = Game.GameObjectManagers[Game.GameObjectType.StealthGame]
  self.effectMap = {}
  self.doorMap = {}
end

function SgDoorGroup:SetKey(r, b, y)
  self.k_r = r
  self.k_b = b
  self.k_y = y
end

function SgDoorGroup:IsPair(r, b, y)
  return self.k_r == r and self.k_b == b and self.k_y == y
end

function SgDoorGroup:SetEffect(effect)
  if not effect then
    return
  end
  if self.effectMap[effect] then
    return
  end
  self.effectMap[effect] = 1
  self.doorMap[effect.m_sceneObjID] = 1
end

function SgDoorGroup:SwitchDoor(open)
  local ret = false
  for doorID, _ in pairs(self.doorMap) do
    if self.manager:SwitchDoor(doorID, open) then
      ret = true
    end
  end
  return ret
end

autoImport("SgBaseTrigger")
SgMachineTrigger = class("SgMachineTrigger", SgBaseTrigger)

function SgMachineTrigger:onExecute()
  SgAIManager.Me():setCurrentTrigger(self.m_uid)
  SgAIManager.Me():visitedTrigger(self:getUid())
  self:handleOptMachine()
end

function SgMachineTrigger:initData(tc, uid, historyData)
  SgMachineTrigger.super.initData(self, tc, uid, historyData)
  if historyData then
    if historyData.equipItem ~= nil then
      self.equipItem = {}
      for _, v in ipairs(historyData.equipItem) do
        if self.equipItem[v] == nil then
          self.equipItem[v] = 1
        else
          self.equipItem[v] = self.equipItem[v] + 1
        end
      end
    end
    self.machineState = historyData.m_machineState
  end
  if self.m_makeLightUpKey then
    local fireKey = self.m_objTrigger:ConvertKey(self.m_makeLightUpKey)
    self.fireKey = {
      fireKey[1],
      fireKey[2],
      fireKey[3]
    }
  end
  if self.m_makeVoiceKey then
    local voiceKey = self.m_objTrigger:ConvertKey(self.m_makeVoiceKey)
    self.voiceKey = {
      voiceKey[1],
      voiceKey[2],
      voiceKey[3]
    }
  end
  self.doorGroups = {}
  for i = 1, #self.m_unlockKey do
    local keys = self.m_objTrigger:ConvertKey(self.m_unlockKey[i])
    local doorGroup = SgDoorGroup.new()
    doorGroup:SetKey(keys[1], keys[2], keys[3])
    for k = 4, #keys do
      doorGroup:SetEffect(self.m_effectList[keys[k] + 1])
    end
    self.doorGroups[#self.doorGroups + 1] = doorGroup
  end
  self.switchEffect = self.m_effectList[1]
  self.statePlot = nil
  self.eventPlot = nil
  if self.switchEffect then
    local manager = Game.GameObjectManagers[Game.GameObjectType.StealthGame]
    manager:RegisterMachineInfo(self.switchEffect.m_sceneObjID, self)
    local switchInfo = manager:GetObject(self.switchEffect.m_sceneObjID)
    if switchInfo then
      self.statePlot = {}
      local statePlotIds = switchInfo:GetProperty(1)
      if statePlotIds then
        statePlotIds = string.split(statePlotIds, ",")
        self.statePlot.Empty = statePlotIds[1]
        self.statePlot.Equiped = statePlotIds[2]
        self.statePlot.DoEquip = statePlotIds[3]
      else
        self.statePlot.Empty = 1
        self.statePlot.Equiped = 2
        self.statePlot.DoEquip = 3
      end
      self.eventPlot = {}
      local eventPlotIds = switchInfo:GetProperty(2)
      if eventPlotIds then
        eventPlotIds = string.split(eventPlotIds, ",")
        self.eventPlot.Success = eventPlotIds[1]
        self.eventPlot.Fail = eventPlotIds[2]
        self.eventPlot.Noise = eventPlotIds[3]
        self.eventPlot.Fire = eventPlotIds[4]
      else
        self.eventPlot.Success = 1
        self.eventPlot.Fail = 2
        self.eventPlot.Noise = 3
        self.eventPlot.Fire = 4
      end
    end
  end
  self.m_plotIds = {}
  local tmp = tc.PlotIds
  if tmp ~= nil then
    for i = 1, #tmp do
      table.insert(self.m_plotIds, tmp[i])
    end
  end
  self:RefreshDisplay()
  if historyData then
    self:SetKey(historyData.m_keyR, historyData.m_keyB, historyData.m_keyY, true)
  end
end

function SgMachineTrigger:getData()
  local arg = {}
  arg.m_uid = self:getUid()
  arg.m_isGetReward = self.m_isGetReward
  arg.m_isOff = self.m_isOff
  arg.m_effectState = self.m_objTrigger:GetEffectState()
  arg.m_animState = {}
  if self.equipItem ~= nil then
    arg.equipItem = {}
    for k, v in pairs(self.equipItem) do
      table.insert(arg.equipItem, k)
    end
  end
  arg.m_keyR = self.k_r
  arg.m_keyB = self.k_b
  arg.m_keyY = self.k_y
  arg.m_machineState = self:GetMachineState()
  return arg
end

local OptMachineDialog = {
  Use = 393753,
  NoGet = 393754,
  TakeOut = 393755
}

function SgMachineTrigger:playDialog(dialogID)
  local viewdata = {
    viewname = "DialogView",
    dialoglist = {dialogID},
    callback = SgMachineTrigger.handlerDialogOption,
    callbackData = self,
    keepOpen = true
  }
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
end

function SgMachineTrigger:handlerDialogOption(optionId)
  redlog("handlerDialogOption", optionId)
  if optionId == 1 and self.machineState ~= 1 then
    self:playDialog(OptMachineDialog.NoGet)
    return false
  end
  local needRefresh
  if optionId == 1 then
    for itemId, count in pairs(self.needItem) do
      SgAIManager.Me():playerUseItem(itemId, count)
    end
    self.equipItem = self.needItem
    needRefresh = true
  elseif optionId == 2 then
  elseif optionId == 3 then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.SgMachineView,
      viewdata = {
        trigger = self,
        keys = {
          self.k_r,
          self.k_b,
          self.k_y
        }
      }
    })
  elseif optionId == 4 then
    for itemId, count in pairs(self.equipItem) do
      SgAIManager.Me():playerAddItem(itemId, count)
    end
    self.equipItem = nil
    needRefresh = true
  end
  self:RefreshMachineState()
  if needRefresh then
    self:RefreshDisplay(true)
  end
  SgAIManager.Me():recordHistoryData(nil)
  return true
end

function SgMachineTrigger:showEffect()
end

function SgMachineTrigger:RefreshDisplay(playAnim)
  self:RefreshDoorDisplay()
  self:RefreshSwitchStateDisplay(playAnim)
end

function SgMachineTrigger:RefreshDoorDisplay()
  self.openSuc = false
  local doorGroup
  for i = 1, #self.doorGroups do
    doorGroup = self.doorGroups[i]
    local open = doorGroup:IsPair(self.k_r, self.k_b, self.k_y)
    if doorGroup:SwitchDoor(open) then
      self.openSuc = true
    end
  end
end

function SgMachineTrigger:DisplaySwitchEvent(isNotPlayPlot)
  local eventPlotId, isLoop
  if self.eventState == 1 then
    eventPlotId = self.eventPlot.Noise
    isLoop = true
  elseif self.eventState == 2 then
    eventPlotId = self.eventPlot.Fire
    isLoop = true
  else
    self:RefreshDoorDisplay()
    if self.openSuc then
      eventPlotId = self.eventPlot.Success
      isLoop = false
    else
      eventPlotId = self.eventPlot.Fail
      isLoop = false
    end
  end
  if self.pqtlPId then
    redlog("取消播放机关事件", self.pqtlPId)
    Game.PlotStoryManager:StopFreeProgress(self.pqtlPId, true)
    self.pqtlPId = nil
  end
  redlog("播放机关事件:", eventPlotId)
  if not self.openSuc then
    if not isNotPlayPlot or nil == isNotPlayPlot then
      self.pqtlPId = Game.PlotStoryManager:Start_PQTLP(eventPlotId, function()
        self.pqtlPId = nil
      end, nil, nil, false, nil, {
        obj = {
          id = self.switchEffect.m_sceneObjID,
          type = 25
        }
      }, isLoop)
    end
  else
    self.pqtlPId = Game.PlotStoryManager:Start_PQTLP(eventPlotId, function()
      self.pqtlPId = nil
    end, nil, nil, false, nil, {
      obj = {
        id = self.switchEffect.m_sceneObjID,
        type = 25
      }
    }, isLoop)
  end
end

function SgMachineTrigger:RefreshSwitchStateDisplay(playAnim)
  if not self.switchEffect then
    return
  end
  if self.pqtlPId then
    redlog("取消播放机关事件", self.pqtlPId)
    Game.PlotStoryManager:StopFreeProgress(self.pqtlPId, true)
    self.pqtlPId = nil
  end
  if self.machineState == 2 then
    if playAnim then
      Game.PlotStoryManager:Start_PQTLP(self.statePlot.DoEquip, nil, nil, nil, false, nil, {
        obj = {
          id = self.switchEffect.m_sceneObjID,
          type = 25
        }
      }, false)
      redlog("播放机关 装备道具", self.statePlot.DoEquip, self.switchEffect.m_sceneObjID)
    else
      Game.PlotStoryManager:Start_PQTLP(self.statePlot.Equiped, nil, nil, nil, false, nil, {
        obj = {
          id = self.switchEffect.m_sceneObjID,
          type = 25
        }
      }, false)
      redlog("播放机关 有道具状态", self.statePlot.Equiped, self.switchEffect.m_sceneObjID)
    end
  else
    Game.PlotStoryManager:Start_PQTLP(self.statePlot.Empty, nil, nil, nil, false, nil, {
      obj = {
        id = self.switchEffect.m_sceneObjID,
        type = 25
      }
    }, false)
    redlog("播放机关 无道具状态", self.statePlot.Empty, self.switchEffect.m_sceneObjID)
  end
end

function SgMachineTrigger:handleOptMachine()
  if not self.needItem then
    local unLockItems = self:getUnLockItem()
    if unLockItems then
      self.needItem = {}
      local itemId
      for i = 1, #unLockItems do
        itemId = unLockItems[i]
        if not self.needItem[itemId] then
          self.needItem[itemId] = 1
        else
          self.needItem[itemId] = self.needItem[itemId] + 1
        end
      end
    end
  end
  if not self.needItem then
    return
  end
  self:RefreshMachineState()
  if self.machineState == 2 then
    self:playDialog(OptMachineDialog.TakeOut)
  else
    self:playDialog(OptMachineDialog.Use)
  end
end

function SgMachineTrigger:openMachine()
  redlog("打开机器")
  self.m_isOff = true
  self:showEffect(true)
end

function SgMachineTrigger:closeMachine()
  redlog("关闭机器")
  self.m_isOff = false
  self:showEffect(false)
  self:SetKey(0, 0, 0)
end

function SgMachineTrigger:TriggerEvent(eventState)
  if eventState == 1 then
    for _, npc in ipairs(SgAIManager.Me():getAllNpcs()) do
      if npc:isDead() == false then
        local pos = npc:getPosition()
        if self:inVoiceRange(pos[1], pos[2], pos[3]) then
          npc:onWakeUpByTrigger(self.m_uid)
        end
      end
    end
  elseif eventState == 2 then
    for _, npc in ipairs(SgAIManager.Me():getAllNpcs()) do
      if npc:isDead() == false then
        local pos = npc:getPosition()
        if self:inLightUpRange(pos[1], pos[2], pos[3]) and npc:inView(LuaGameObject.GetPosition(npc:getAITransform())) then
          npc:onFindLight(self.m_uid)
        end
      end
    end
  end
end

function SgMachineTrigger:SetKey(r, b, y, isNotPlayPlot)
  self.k_r = r
  self.k_b = b
  self.k_y = y
  if self.voiceKey and self.voiceKey[1] == r and self.voiceKey[2] == b and self.voiceKey[3] == y then
    self.eventState = 1
  elseif self.fireKey and self.fireKey[1] == r and self.fireKey[2] == b and self.fireKey[3] == y then
    self.eventState = 2
  else
    self.eventState = 0
  end
  self:TriggerEvent(self.eventState)
  self:RefreshDoorDisplay()
  self:DisplaySwitchEvent(isNotPlayPlot)
end

function SgMachineTrigger:RefreshMachineState()
  if self.equipItem then
    self.machineState = 2
  else
    local geted = true
    if self.needItem then
      for itemID, count in pairs(self.needItem) do
        local hasCount = SgAIManager.Me():getItemById(itemID) or 0
        if count > hasCount then
          geted = false
          break
        end
      end
    end
    if geted then
      self.machineState = 1
    else
      self.machineState = 0
    end
  end
end

function SgMachineTrigger:GetMachineState()
  return self.machineState
end

function SgMachineTrigger:SetEventState(eventState)
  self.eventState = eventState
  self:DisplaySwitchEvent()
  self:RefreshDisplay()
end

function SgMachineTrigger:DoDeconstruct()
  SgMachineTrigger.super.DoDeconstruct(self)
  self.needItem = nil
  self.equipItem = nil
  self.machineState = nil
  self.eventState = nil
  if self.switchEffect then
    local manager = Game.GameObjectManagers[Game.GameObjectType.StealthGame]
    manager:UnRegisterMachineInfo(self.switchEffect.m_sceneObjID)
    self.switchEffect = nil
  end
  self.doorGroups = nil
  self.voiceKey = nil
  self.fireKey = nil
  self.k_r = nil
  self.k_b = nil
  self.k_y = nil
end
