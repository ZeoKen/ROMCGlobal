FunctionSniperMode = class("FunctionSniperMode")

function FunctionSniperMode.Me()
  if nil == FunctionSniperMode.me then
    FunctionSniperMode.me = FunctionSniperMode.new()
  end
  return FunctionSniperMode.me
end

function FunctionSniperMode:Launch(buffeffect)
  if not self.isWorking then
    Game.InputManager.disableMove = Game.InputManager.disableMove + 1
    Game.Myself:Client_NoMove(true)
    Game.Myself:Client_SetAutoBattleStanding(true)
    GameFacade.Instance:sendNotification(MyselfEvent.EnterSniperMode)
  end
  if self.ViewInstance then
    self.ViewInstance:RefreshBuffEffect(buffeffect)
  else
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.SniperView,
      viewdata = buffeffect
    })
  end
  self.isWorking = true
end

function FunctionSniperMode:Shutdown()
  if self.isWorking then
    self.isWorking = nil
    Game.InputManager.disableMove = Game.InputManager.disableMove - 1
    Game.Myself:Client_NoMove(false)
    Game.Myself:Client_SetAutoBattleStanding(false)
    GameFacade.Instance:sendNotification(MyselfEvent.ExitSniperMode)
  end
  if self.ViewInstance then
    self.ViewInstance:CloseSelf()
  end
end

function FunctionSniperMode:EnterScene()
  if self.isWorking and not self.ViewInstance then
    FunctionUtility.Me():DelayCall(function()
      if not self.isWorking then
        return
      end
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.SniperView
      })
    end, 1, self)
  end
end

function FunctionSniperMode:LeaveScene()
  if self.ViewInstance then
    self.ViewInstance:CloseSelf()
  end
end

function FunctionSniperMode:IsWorking()
  return self.isWorking == true
end

function FunctionSniperMode:SetSniperViewInstance(view)
  self.ViewInstance = view
end

function FunctionSniperMode:GetCenterPosition()
  if self:IsWorking() and self.ViewInstance then
    return self.ViewInstance.vecCurCameraPos
  end
end

function FunctionSniperMode:SetExtraInputPosition(position)
  local prevHaveExPos = self.exInputPosition ~= nil
  self.exInputPosition = position
  if self.ViewInstance then
    local curHaveExPos = position ~= nil
    if prevHaveExPos ~= curHaveExPos then
      self.ViewInstance:OnExInputStatusChange(curHaveExPos)
    end
  end
end

function FunctionSniperMode:GetExtraInputPosition()
  return self.exInputPosition
end

function FunctionSniperMode:SetCurMaxAttackRange(distance)
  self.curMaxAtkDistance = distance
end

function FunctionSniperMode:GetCurMaxAttackRange()
  return self.curMaxAtkDistance or 0
end
