MissionCommandMove = class("MissionCommandMove", MissionCommand)
MissionCommandMove.CallbackEvent = {
  TeleportFailed = MissionCommand.CallbackEvent.Custom + 1
}

function MissionCommandMove:Log()
  local args = self.args
  LogUtility.InfoFormat("MissionCommandMove: {0}", LogUtility.StringFormat("targetMapID={0}, targetBPID={1}, targetPos={2}", LogUtility.ToString(args.targetMapID), LogUtility.ToString(args.targetBPID), LogUtility.ToString(args.targetPos)))
end

function MissionCommandMove:DoLaunch()
  local args = self.args
  if not self.teleport:Launch(args.targetMapID, args.targetBPID, args.targetPos, args.showClickGround, args.allowExitPoint, args.customMoveAction) then
    LogUtility.InfoFormat("<color=red>MissionCommandMove: </color>teleport failed, {0}", LogUtility.StringFormat("targetMapID={0}, targetBPID={1}, targetPos={2}", LogUtility.ToString(args.targetMapID), LogUtility.ToString(args.targetBPID), LogUtility.ToString(args.targetPos)))
    if nil ~= args.callback then
      args.callback(self, MissionCommandMove.CallbackEvent.TeleportFailed)
    end
  end
end

function MissionCommandMove:DoShutdown()
  self.teleport:Shutdown()
  Game.Myself:Logic_PlayAction_Idle()
end

function MissionCommandMove:DoUpdate(time, deltaTime)
  local args = self.args
  if nil ~= args.distance then
    local currentMapID = Game.MapManager:GetMapID()
    if currentMapID == args.targetMapID then
      if nil == args.targetPos then
        self:DoShutdown()
        return false
      end
      if self.teleport.running then
        local squareDistance = VectorUtility.DistanceXZ_Square(Game.Myself:GetPosition(), args.targetPos)
        local squareArgsDistance = args.distance * args.distance
        if squareDistance < squareArgsDistance then
          self:DoShutdown()
          return false
        end
      end
    end
  end
  if nil ~= args.shutDownWhenChangeMap then
    local currentMapID = Game.MapManager:GetMapID()
    if currentMapID ~= args.targetMapID then
      self:DoShutdown()
      return false
    end
  end
  if self:_MyselfNoMove() then
    if not self.teleport.pausing then
      self.teleport:Pause()
      Game.Myself:Logic_StopMove()
      Game.Myself:Logic_PlayAction_Idle()
    end
    return true
  elseif self.teleport.pausing then
    self.teleport:Resume()
  end
  self.teleport:Update()
  if not self.teleport.running then
    Game.Myself:Logic_PlayAction_Idle()
    return false
  end
  return true
end

function MissionCommandMove:ResetTargetPos(targetMapID, targetPos)
  if targetMapID then
    self.args.targetMapID = targetMapID
  end
  if targetPos then
    self.args.targetPos = targetPos:Clone()
  end
end

function MissionCommandMove:DoConstruct(asArray, args)
  MissionCommandMove.super.DoConstruct(self, asArray, args)
  if nil == self.args.targetMapID then
    self.args.targetMapID = Game.MapManager:GetMapID()
  end
  if nil ~= self.args.targetPos then
    self.args.targetPos = self.args.targetPos:Clone()
  end
  if nil ~= args.endcallback then
    self.args.endcallback = args.endcallback
  end
  self.teleport = Game.WorldTeleport
end

function MissionCommandMove:DoDeconstruct(asArray)
  if nil ~= self.args.targetPos then
    self.args.targetPos:Destroy()
  end
  if nil ~= self.args.endcallback then
    self.args.endcallback(self)
  end
  MissionCommandMove.super.DoDeconstruct(self, asArray)
  self.teleport = nil
end
