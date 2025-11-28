autoImport("AIBaseBehaviour")
AIDead = class("AIDead", AIBaseBehaviour)

function AIStand:ctor(aiNpc)
  AIDead.super.ctor(self, aiNpc)
end

function AIDead:getType()
  return AIBehaviourType.eDead
end

function AIDead:onEnter(...)
  AIDead.super.onEnter(self, ...)
  self.m_ai.m_npc.IsDead = true
  local changePlayer = function()
    self.m_ai:getStateMachine():switchByType(AIBehaviourType.eEmpty)
    self.m_ai:removeNpc()
    SgAIManager.Me():onPlayerPossessedSuccess(self.m_ai.m_id, self.m_ai:getControlTime(), self.m_ai:getWalkLimit())
  end
  local attachedId = self.m_ai:getAttachedSuccessPlotId()
  if nil ~= attachedId then
    Game.PlotStoryManager:Start_PQTLP(attachedId, nil, nil, nil, false, nil, {
      myself = Game.Myself.data.id
    }, false)
  end
  Game.PlotStoryManager:Start_PQTLP("3037", changePlayer, nil, nil, false, nil, {
    myself = self.m_ai:getUid()
  }, false)
  local sceneUI = Game.Myself:GetSceneUI() or nil
  local tbMsg = Table_Sysmsg[self.m_ai:getDeadSpeak()]
  if sceneUI and tbMsg ~= nil then
    sceneUI.roleTopUI:Speak(tbMsg.Text, Game.Myself)
  end
end

function AIDead:onExit()
  AIDead.super.onExit(self)
end

function AIDead:getData()
  self.m_data.m_type = self:getType()
  return self.m_data
end
