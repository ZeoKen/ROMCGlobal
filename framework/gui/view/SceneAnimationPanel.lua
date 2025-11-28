SceneAnimationPanel = class("SceneAnimationPanel", BaseView)
SceneAnimationPanel.ViewType = UIViewType.DialogLayer

function SceneAnimationPanel:Init()
  self:AddListener()
end

function SceneAnimationPanel:AddListener()
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.SceneLoadFinishHandler)
end

function SceneAnimationPanel:SceneLoadFinishHandler(note)
  if note.type == LoadSceneEvent.StartLoad then
    self:CloseSelf()
  end
end

function SceneAnimationPanel:OnEnter()
  SceneAnimationPanel.super.OnEnter(self)
  self.currentMapID = Game.MapManager:GetMapID()
  if GameConfig.SceneAnimationMoveAvailable and GameConfig.SceneAnimationMoveAvailable[self.currentMapID] and GameConfig.SceneAnimationMoveAvailable[self.currentMapID] == 1 then
  else
    Game.Myself:Client_PauseIdleAI()
  end
end

function SceneAnimationPanel:OnExit()
  SceneAnimationPanel.super.OnExit(self)
  if GameConfig.SceneAnimationMoveAvailable and GameConfig.SceneAnimationMoveAvailable[self.currentMapID] and GameConfig.SceneAnimationMoveAvailable[self.currentMapID] == 1 then
  else
    Game.Myself:Client_ResumeIdleAI()
  end
end
