BattleResultView = class("BattleResultView", BaseView)
BattleResultView.ViewType = UIViewType.NormalLayer

function BattleResultView:Init()
end

function BattleResultView:FindObjs()
end

function BattleResultView:OnEnter()
  self.super.OnEnter(self)
  local boss = self:GetBossRole() or Game.Myself
  self:WinCameraMove(boss, function()
    self:CloseSelf()
  end)
end

function BattleResultView:GetBossRole()
  local mapid = SceneProxy.Instance.currentScene
  if mapid and Table_MapRaid[mapid] then
    local bossid = Table_MapRaid[mapid].Boss
    if bossid then
      return NSceneNpcProxy.Instance:FindNearestNpc(Game.Myself:GetPosition(), bossid)
    end
  end
end

function BattleResultView:WinCameraMove(role, callback)
  if role then
    self:CameraRotateToMe()
    TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
      local actionName = Table_ActionAnime[39].Name
      Game.Myself:Client_PlayAction(actionName, nil, false)
      if callback then
        callback()
      end
    end, self)
  elseif callback then
    callback()
  end
end

function BattleResultView:OnExit()
  if self.viewdata.callback then
    self.viewdata.callback()
  end
  self:CameraReset()
  self.super.OnExit(self)
end
