autoImport("SgBaseTrigger")
SgPlayThePianoGameTrigger = class("SgPlayThePianoGameTrigger", SgBaseTrigger)

function SgPlayThePianoGameTrigger:DoDeconstruct()
  SgPlayThePianoGameTrigger.super.DoDeconstruct(self)
  local data = {}
  data.type = QuickUseProxy.Type.StealthGame_Item
  data.closeUi = true
  GameFacade.Instance:sendNotification(StealthGameEvent.Item_UseTip, data)
end

function SgPlayThePianoGameTrigger:initData(tc, uid, historyData)
  SgPlayThePianoGameTrigger.super.initData(self, tc, uid, historyData)
  self.m_pianoItemId = 54922
  self.m_msgInfos = {}
  local tmp = tc:GetMemoryDialogs()
  if tmp ~= nil then
    for i = 1, #tmp do
      local id = math.modf(tonumber(tmp[i]))
      table.insert(self.m_msgInfos, id)
    end
  end
  self.m_plotIds = {}
  tmp = tc.PlotIds
  if tmp ~= nil then
    for i = 1, #tmp do
      table.insert(self.m_plotIds, tmp[i])
    end
  end
  self:rePlayPlotOrAnimation()
end

function SgBaseTrigger:getMemoryDialog()
  return {}
end

function SgPlayThePianoGameTrigger:onExecute()
  if SgAIManager.Me():triggerIsVisited(self:getUid()) then
    return
  end
  if SgAIManager.Me():isPossessed() then
    MsgManager.ShowMsgByID(42136)
    return
  end
  local checkHasItem = function()
    for _, v in pairs(self.m_unLockItem) do
      if SgAIManager.Me():getItemById(v) == nil then
        return v
      end
    end
    return nil
  end
  if SgAIManager.Me():getItemById(self.m_pianoItemId) == nil then
    if checkHasItem() ~= nil then
      if #self.m_plotIds > 2 then
        Game.PlotStoryManager:Start_PQTLP(self.m_plotIds[3], nil, nil, nil, false, nil, false)
      end
      if 2 < #self.m_msgInfos then
        MsgManager.ShowMsgByID(self.m_msgInfos[3])
      end
    else
      if #self.m_plotIds > 0 then
        Game.PlotStoryManager:Start_PQTLP(self.m_plotIds[1], nil, nil, nil, false, nil, false)
      end
      if #self.m_msgInfos > 0 then
        MsgManager.ShowMsgByID(self.m_msgInfos[1])
      end
    end
    return
  else
    local needItem = checkHasItem()
    if needItem ~= nil then
      if #self.m_plotIds > 1 then
        Game.PlotStoryManager:Start_PQTLP(self.m_plotIds[1], nil, nil, nil, false, nil, false)
      end
      if #self.m_msgInfos > 1 then
        MsgManager.ShowMsgByID(self.m_msgInfos[2])
      end
      return
    end
  end
  local data = {}
  data.type = QuickUseProxy.Type.StealthGame_Item
  data.data = {}
  data.data.uid = self.m_uid
  data.data.staticData = Table_Item[self.m_pianoItemId]
  GameFacade.Instance:sendNotification(StealthGameEvent.Item_UseTip, data)
end

function SgPlayThePianoGameTrigger:onUseItem()
  local _, angle, _ = LuaGameObject.GetEulerAngles(self:getTransform())
  Game.Myself.assetRole:SetEulerAngleY(angle)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.MusicGamePanel,
    viewdata = {
      scoreID = tonumber(self.m_makeVoiceKey),
      triggerId = self.m_uid
    }
  })
end

function SgPlayThePianoGameTrigger:exit()
  SgPlayThePianoGameTrigger.super.exit(self)
  local data = {}
  data.type = QuickUseProxy.Type.StealthGame_Item
  data.closeUi = true
  GameFacade.Instance:sendNotification(StealthGameEvent.Item_UseTip, data)
end

function SgPlayThePianoGameTrigger:onPlaySuccess()
  SgAIManager.Me():visitedTrigger(self:getUid())
  if 0 ~= self.m_plotID and "" ~= self.m_plotID and self.m_plotID ~= nil then
    self.m_playPlotId = Game.PlotStoryManager:Start_PQTLP(self.m_plotID, self.onPlayPlotEnd, self, nil, false, nil, false)
    redlog("播放剧情" .. self.m_plotID)
  end
  for _, v in ipairs(self.m_effectList) do
    if not v:PlayAnimationByIndex(0) then
      redlog("触发器 -> " .. self:getUid() .. " play enter animation index = 0 失败")
    end
  end
end

function SgPlayThePianoGameTrigger:rePlayPlotOrAnimation()
  if not SgAIManager.Me():triggerIsVisited(self:getUid()) then
    return
  end
  self:onPlaySuccess()
end

function SgPlayThePianoGameTrigger:onPlayPlotEnd()
  self.m_playPlotId = nil
end
