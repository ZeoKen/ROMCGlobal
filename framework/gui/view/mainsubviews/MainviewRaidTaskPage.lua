MainviewRaidTaskPage = class("MainviewRaidTaskPage", SubView)
autoImport("RaidTaskBord")

function MainviewRaidTaskPage:Init()
  self.top_right = self:FindGO("Anchor_TopRight")
  self.traceNewVer = false
  if not self.traceNewVer then
    self.taskQuestBord = self:FindGO("classicTaskBord")
  else
    self.taskQuestBord = self:FindGO("TaskQuestBord")
  end
  self:MapEvent()
end

function MainviewRaidTaskPage:DestroyRaidTaskBord()
  if self.raidTaskBord then
    self.raidTaskBord:Destroy()
  end
  self.raidTaskBord = nil
  self.taskQuestBord:SetActive(true)
end

function MainviewRaidTaskPage:UpdateRaidTask()
  local raidTaskData = QuestProxy.Instance:getTraceFubenQuestData()
  if raidTaskData then
    if not self.midMsg then
      self.midMsg = FloatingPanel.Instance:GetMidMsg()
      self.midMsg:SetLocalPos(0, 200, 0)
      self.midMsg:SetExitCall(self.MidMsgExitCall, self)
    end
    local msgData = {
      text = raidTaskData:parseTranceInfo()
    }
    self.midMsg:SetData(msgData)
  else
    if self.midMsg then
      FloatingPanel.Instance:RemoveMidMsg()
    end
    self.midMsg = nil
  end
end

function MainviewRaidTaskPage:UpdateNpcWalkTraceInfo(note)
  helplog("MainviewRaidTaskPage:UpdateNpcWalkTraceInfo", note.body.traceinfo, note.body.status)
  if not Game.MapManager:IsRaidMode() then
    return
  end
  if note.body and note.body.traceinfo ~= "" then
    local traceInfo = note.body.traceinfo
    local status = note.body.status
    if not self.midMsg then
      self.midMsg = FloatingPanel.Instance:GetMidMsg()
      self.midMsg:SetLocalPos(0, 200, 0)
      self.midMsg:SetExitCall(self.MidMsgExitCall, self)
    end
    if status == 1 then
      local msgData = {text = traceInfo}
      self.midMsg:SetData(msgData)
    elseif status == 2 then
      if self.midMsg then
        FloatingPanel.Instance:RemoveMidMsg()
      end
      self.midMsg = nil
    end
  end
end

function MainviewRaidTaskPage:MidMsgExitCall(msg)
  self.midMsg = nil
end

function MainviewRaidTaskPage:UpdateRaidScore(score)
  if score and self.raidTaskBord then
    self.raidTaskBord:SetScore(score)
  end
end

function MainviewRaidTaskPage:UpdateRaidProgress(progress)
  if progress and self.raidTaskBord then
    progress = progress / 1000
    self.raidTaskBord:SetProgress(progress)
  end
end

function MainviewRaidTaskPage:MapEvent()
  self:AddListenEvt(ServiceEvent.FuBenCmdFuBenScoreSyncCmd, self.HandleScoreChange)
  self:AddListenEvt(ServiceEvent.FuBenCmdFuBenGoalSyncCmd, self.HandleFubenGoalSync)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.HandlePlayerMapChange)
end

function MainviewRaidTaskPage:HandleScoreChange(note)
  self:UpdateRaidScore(note.body.score)
end

function MainviewRaidTaskPage:HandleFubenGoalSync(note)
  local data = note.body
  self:UpdateRaidProgress(note.body.progress)
end

function MainviewRaidTaskPage:HandlePlayerMapChange()
  if WorldMapProxy.Instance:IsCloneMap() then
    TimeTickManager.Me():ClearTick(self, 1)
    self:PlayMirrorTips()
    TimeTickManager.Me():CreateOnceDelayTick(10000, function(owner, deltaTime)
      if self.midMsg then
        FloatingPanel.Instance:RemoveMidMsg()
      end
      self.midMsg = nil
    end, self, 1)
  else
    TimeTickManager.Me():ClearTick(self, 1)
    if self.midMsg then
      FloatingPanel.Instance:RemoveMidMsg()
    end
    self.midMsg = nil
  end
end

function MainviewRaidTaskPage:PlayMirrorTips()
  if not self.midMsg then
    self.midMsg = FloatingPanel.Instance:GetMidMsg()
    self.midMsg:SetLocalPos(0, 200, 0)
  end
  local msgData = {
    text = ZhString.MainViewMiniMap_CloneMapTip
  }
  self.midMsg:SetData(msgData)
end
