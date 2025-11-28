autoImport("QuestMiniGame3HeadIconCell")
QuestMiniGame3Panel = class("QuestMiniGame3Panel", ContainerView)
QuestMiniGame3Panel.ViewType = UIViewType.ToolsLayer

function QuestMiniGame3Panel:Init()
  self:InitView()
  self:AddViewEvts()
end

function QuestMiniGame3Panel:InitView()
  self.monstergrid = self:FindComponent("monsters", UIGrid)
  self.monsterList = UIGridListCtrl.new(self.monstergrid, QuestMiniGame3HeadIconCell, "HeadIconCell")
end

function QuestMiniGame3Panel:OnEnter()
  QuestMiniGame3Panel.super.OnEnter(self)
  self:ShowUI()
end

function QuestMiniGame3Panel:OnExit()
  QuestMiniGame3Panel.super.OnExit(self)
end

function QuestMiniGame3Panel:AddViewEvts()
  self:AddListenEvt(ServiceEvent.FuBenCmdFuBenProgressSyncCmd, self.TryUpdateFuBenProgress)
  self:AddListenEvt(ServiceEvent.FuBenCmdFubenStepSyncCmd, self.TryUpdateFuBenStep)
  self:AddListenEvt(QuestEvent.QuestDelete, self.OnRecvQuestDelete)
  self:AddListenEvt(ServiceEvent.QuestQuestStepUpdate, self.OnRecvQuestStepUpdate)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.HandleMapChange)
end

function QuestMiniGame3Panel:ShowUI()
  local questData = self.viewdata.viewdata
  self.questScope = questData.scope
  self.questStep = questData.step
  self.questId = questData.id
  self:SetProgress(questData.process)
  self.Params = questData.params
  if self.Params then
    self:ShowProgressPanel()
  end
end

function QuestMiniGame3Panel:SetProgress(prog)
  if self.questProgress and prog <= self.questProgress then
    self.progressFail = true
  end
  self.questProgress = prog
end

function QuestMiniGame3Panel:TryUpdateFuBenProgress(data)
  if self.questScope == QuestDataScopeType.QuestDataScopeType_FUBEN and self.questId == data.body.starid then
    self:SetProgress(data.body.progress)
    self:UpdateKillList()
  end
end

function QuestMiniGame3Panel:TryUpdateFuBenStep(data)
  if self.questScope == QuestDataScopeType.QuestDataScopeType_FUBEN and data.body.del == true and self.questId == data.body.id then
    self:Fin()
  end
end

function QuestMiniGame3Panel:OnRecvQuestDelete(note)
  local data = note.body
  for i = 1, #data do
    local single = data[i]
    if self.questId == single.id then
      self:Fin()
      return
    end
  end
end

function QuestMiniGame3Panel:OnRecvQuestStepUpdate(note)
  local data = note.body
  if data.id == self.questId and data.step and data.step ~= self.questStep then
    self:Fin()
  end
end

function QuestMiniGame3Panel:ShowProgressPanel()
  self.monsters = self.Params.ids
  self.monsterList:ResetDatas(self.monsters)
  self:UpdateKillList()
end

function QuestMiniGame3Panel:UpdateKillList()
  local progress = self.questProgress or 0
  local cells = self.monsterList:GetCells()
  for i = 1, #cells do
    cells[i]:SetBeat(i <= progress)
    cells[i]:SetNext(progress + 1 == i)
  end
  if progress >= #self.monsters then
    self:Fin()
  end
  if self.progressFail then
    self:PlayUISound("Common/AnswerWrong")
  else
    self:PlayUISound("Common/AnswerCorrect")
  end
  self.progressFail = nil
end

function QuestMiniGame3Panel:Fin()
  local c = coroutine.create(function()
    Yield(WaitForSeconds(0.1))
    self:CloseSelf()
  end)
  coroutine.resume(c)
end

function QuestMiniGame3Panel:HandleMapChange()
  self:Fin()
end
