AI_Myself = class("AI_Myself", AI_Base)
if not AI_Myself.AI_Myself_inited then
  AI_Myself.AI_Myself_inited = true
  AI_CMD_Myself_SetAngleY.Parallel = true
  AI_CMD_Myself_SetScale.Parallel = true
  AI_CMD_Myself_PlaceTo.Parallel = true
  AI_CMD_Myself_SetAngleY.SeatAllowed = true
  AI_CMD_Myself_SetScale.SeatAllowed = true
  AI_CMD_Myself_PlayAction.SeatAllowed = true
  AI_CMD_Myself_DirMoveEnd.SeatAllowed = true
  AI_CMD_Myself_Die.NotifyAngleY = true
  AI_CMD_Myself_PlayAction.NotifyAngleY = true
  AI_CMD_Myself_Skill.NotifyAngleY = true
  AI_CMD_Myself_Spin.NotifyAngleY = true
  AI_CMD_Myself_PlaceTo.Interrupt = {
    [AI_CMD_Myself_Skill] = 1
  }
  AI_CMD_Myself_MoveTo.Interrupt = {
    [AI_CMD_Myself_MoveTo] = 1,
    [AI_CMD_Myself_DirMove] = 1,
    [AI_CMD_Myself_Access] = 1,
    [AI_CMD_Myself_Skill] = 2,
    [AI_CMD_Myself_PlayAction] = 1,
    [AI_CMD_Myself_PlayHolyAction] = 2,
    [AI_CMD_Myself_Hit] = 2
  }
  AI_CMD_Myself_DirMove.Interrupt = {
    [AI_CMD_Myself_MoveTo] = 1,
    [AI_CMD_Myself_DirMove] = 1,
    [AI_CMD_Myself_Access] = 1,
    [AI_CMD_Myself_Skill] = 2,
    [AI_CMD_Myself_PlayAction] = 1,
    [AI_CMD_Myself_PlayHolyAction] = 2,
    [AI_CMD_Myself_Hit] = 2
  }
  AI_CMD_Myself_DirMoveEnd.Interrupt = {
    [AI_CMD_Myself_DirMove] = 1
  }
  AI_CMD_Myself_Access.Interrupt = {
    [AI_CMD_Myself_MoveTo] = 1,
    [AI_CMD_Myself_DirMove] = 1,
    [AI_CMD_Myself_Access] = 1,
    [AI_CMD_Myself_Skill] = 2,
    [AI_CMD_Myself_PlayAction] = 1,
    [AI_CMD_Myself_PlayHolyAction] = 2,
    [AI_CMD_Myself_Hit] = 2
  }
  AI_CMD_Myself_Skill.Interrupt = {
    [AI_CMD_Myself_MoveTo] = 1,
    [AI_CMD_Myself_DirMove] = 1,
    [AI_CMD_Myself_Access] = 1,
    [AI_CMD_Myself_Skill] = 2,
    [AI_CMD_Myself_PlayAction] = 1,
    [AI_CMD_Myself_PlayHolyAction] = 1,
    [AI_CMD_Myself_Hit] = 2
  }
  AI_CMD_Myself_PlayAction.Interrupt = {
    [AI_CMD_Myself_MoveTo] = 1,
    [AI_CMD_Myself_DirMove] = 1,
    [AI_CMD_Myself_Access] = 1,
    [AI_CMD_Myself_Skill] = 2,
    [AI_CMD_Myself_PlayAction] = 1,
    [AI_CMD_Myself_PlayHolyAction] = 2,
    [AI_CMD_Myself_Hit] = 2
  }
  AI_CMD_Myself_PlayHolyAction.Interrupt = {
    [AI_CMD_Myself_MoveTo] = 1,
    [AI_CMD_Myself_DirMove] = 1,
    [AI_CMD_Myself_Access] = 1,
    [AI_CMD_Myself_Skill] = 2,
    [AI_CMD_Myself_PlayAction] = 1,
    [AI_CMD_Myself_PlayHolyAction] = 2,
    [AI_CMD_Myself_Hit] = 2
  }
  AI_CMD_Myself_Hit.Interrupt = {
    [AI_CMD_Myself_PlayAction] = 1,
    [AI_CMD_Myself_PlayHolyAction] = 1,
    [AI_CMD_Myself_Hit] = 1
  }
  AI_CMD_Myself_Die.Interrupt = {
    [AI_CMD_Myself_MoveTo] = 1,
    [AI_CMD_Myself_DirMove] = 1,
    [AI_CMD_Myself_Access] = 1,
    [AI_CMD_Myself_Skill] = 1,
    [AI_CMD_Myself_PlayAction] = 1,
    [AI_CMD_Myself_PlayHolyAction] = 1,
    [AI_CMD_Myself_Hit] = 1
  }
  AI_CMD_Myself_SpinEnd.Interrupt = {
    [AI_CMD_Myself_Spin] = 1
  }
  AI_CMD_Myself_Skill.Block = {
    [AI_CMD_Myself_Hit] = 1,
    [AI_CMD_Myself_PlayAction] = 1
  }
  AI_CMD_Myself_Die.Block = {
    [AI_CMD_Myself_MoveTo] = 9,
    [AI_CMD_Myself_DirMove] = 9,
    [AI_CMD_Myself_Access] = 9,
    [AI_CMD_Myself_Skill] = 9,
    [AI_CMD_Myself_PlayAction] = 9,
    [AI_CMD_Myself_PlayHolyAction] = 9,
    [AI_CMD_Myself_Hit] = 9
  }
  AI_CMD_Myself_Hit.Insert = {
    [AI_CMD_Myself_MoveTo] = 1,
    [AI_CMD_Myself_DirMove] = 1,
    [AI_CMD_Myself_Access] = 1,
    [AI_CMD_Myself_Skill] = 2
  }
  AI_CMD_Myself_Skill.ConcurrentInterrupt = {
    [AI_CMD_Myself_MoveTo] = 1,
    [AI_CMD_Myself_Access] = 1
  }
end
local NotifyServerAngleYDelay = 0.5
local CancelSkillLockTargetDelay = 1
local Move_CMD = {
  [AI_CMD_Myself_DirMove] = 1,
  [AI_CMD_Myself_DirMoveEnd] = 1,
  [AI_CMD_Myself_MoveTo] = 1,
  [AI_CMD_Myself_Access] = 1
}

function AI_Myself:ctor()
  self.cmdQueue = {}
  self.parallelCmds = {}
  self.currentCmd = nil
  self.nextCmd = nil
  self.nextCmd1 = nil
  self.dieCmd = nil
  self.moveCmd = nil
  self.skillLockTargetGUID = 0
  self.cancelSkillLockTargetGUIDTime = 0
  self.followers = {}
  self.requestBreakAll = false
  self.requestWeakBreak = false
  self.weakBreakIgnoreAction = false
  self.move = false
  self.delayInterruptCameraSmooth = 0
  AI_Myself.super.ctor(self)
end

function AI_Myself:_InitIdleAI(idleAIManager)
  self.idleAIManager:PushAI(IdleAI_FearRun.new())
  self:_InitAutoAI(idleAIManager)
  self.idleAIManager:PushAI(IdleAI_Attack.new())
end

function AI_Myself:_InitAutoAI(idleAIManager)
  self.autoAI_WorldTeleport = WorldTeleport.new()
  self.autoAI_MissionCommand = IdleAI_MissionCommand.new()
  self.idleAIManager:PushAI(self.autoAI_MissionCommand)
  self.autoAI_FakeDead = IdleAI_FakeDead.new()
  self.idleAIManager:PushAI(self.autoAI_FakeDead)
  self.autoAI_FollowLeader = IdleAI_FollowLeader.new()
  self.idleAIManager:PushAI(self.autoAI_FollowLeader)
  self.autoAI_EndlessTowerSweep = IdleAI_EndlessTowerSweep.new()
  self.idleAIManager:PushAI(self.autoAI_EndlessTowerSweep)
  self.autoAI__Reload = IdleAI_Reload.new()
  self.idleAIManager:PushAI(self.autoAI__Reload)
  self.autoAI_Battle = IdleAI_AutoBattle.new()
  self.autoAI_BattleManager = AutoBattleManager.new(self.autoAI_Battle)
  self.idleAIManager:PushAI(self.autoAI_Battle)
  self.autoAI_SkillTargetPoint = IdleAI_SkillTargetPoint.new()
  self.idleAIManager:PushAI(self.autoAI_SkillTargetPoint)
  self.autoAI_SkillOverAction = IdleAI_SkillOverAction.new()
  self.idleAIManager:PushAI(self.autoAI_SkillOverAction)
  Game.WorldTeleport = self.autoAI_WorldTeleport
  Game.AutoBattleManager = self.autoAI_BattleManager
end

function AI_Myself:HideCommands(AIClass, time, deltaTime, creature)
end

function AI_Myself:UnhideCommands(AIClass, time, deltaTime, creature)
end

function AI_Myself:_NotifyAngleY(time, deltaTime, creature)
  if NotifyServerAngleYDelay > self.idleElapsed then
    return
  end
  self:_DoNotifyAngleY(time, deltaTime, creature)
end

function AI_Myself:_DoNotifyAngleY(time, deltaTime, creature)
  creature:Client_TryNotifyServerAngleY(time)
end

function AI_Myself:_Idle(time, deltaTime, creature)
  self.move = false
  self:_NotifyAngleY(time, deltaTime, creature)
  return AI_Myself.super._Idle(self, time, deltaTime, creature)
end

function AI_Myself:_Move(time, deltaTime, creature)
  if self.move then
    return
  end
  self.move = true
end

function AI_Myself:TryStopBaseAction(creature)
  if self.parent ~= nil and not self.forceUpdate then
    return
  end
  local creatureData = creature.data
  if creatureData:Freeze() or creatureData:NoAct() or creatureData:DeepFreeze() then
    return
  end
  creature:Logic_StopBaseAction()
end

function AI_Myself:_StopMove(time, deltaTime, creature)
  if not self.move then
    return
  end
  self.move = false
  if self.parent ~= nil and not self.forceUpdate then
    return
  end
  local creatureData = creature.data
  if creatureData:Freeze() or creatureData:NoAct() or creatureData:DeepFreeze() then
    return
  end
  if not self.currentCmd.concurrent then
    return
  end
  creature:Logic_StopBaseAction()
end

function AI_Myself:_SetNextCommand(cmd, creature)
  if AI_CMD_Myself_Skill ~= cmd.AIClass and AI_CMD_Myself_Hit ~= cmd.AIClass then
    creature:Logic_SetAttackTarget(nil)
  end
  if nil ~= self.nextCmd1 and not self:_DoAllowInsert(self.nextCmd1, cmd.AIClass, creature) then
    if self:_CmdCanBeReplaced(creature, self.nextCmd1, cmd) then
      if self.nextCmd1.AIClass == AI_CMD_Myself_DirMoveEnd then
        self.prepareStopMove = true
      end
      self.nextCmd1:Destroy()
      self.nextCmd1 = cmd
      return true
    else
      return false
    end
  end
  if nil ~= self.nextCmd then
    if self:_DoAllowInsert(self.nextCmd, cmd.AIClass, creature) then
      if nil ~= self.nextCmd1 then
        self.nextCmd1:Destroy()
      end
      self.nextCmd1 = self.nextCmd
    elseif self:_CmdCanBeReplaced(creature, self.nextCmd, cmd) then
      if self.nextCmd.AIClass == AI_CMD_Myself_DirMoveEnd then
        self.prepareStopMove = true
      end
      self.nextCmd:Destroy()
    else
      return false
    end
  end
  self.nextCmd = cmd
  return true
end

function AI_Myself:_MoveCmd(cmd)
  if cmd == nil then
    return false
  end
  if Move_CMD[cmd.AIClass] == nil then
    return false
  end
  return true
end

function AI_Myself:_AllowInterrupt(time, deltaTime, creature)
  if nil == self.nextCmd then
    return false
  end
  local currentCmd = self.currentCmd
  if nil ~= currentCmd.AIClass.AllowInterrupt and currentCmd.AIClass.AllowInterrupt(currentCmd, self.nextCmd, time, deltaTime, creature) then
    return true
  end
  local ignoreHit = self.nextCmd.args and self.nextCmd.args[14]
  return self:_DoAllowInterrupt(self.currentCmd, self.nextCmd.AIClass, creature, ignoreHit)
end

function AI_Myself:_AllowMoveInterrupt(time, deltaTime, creature)
  if not self:_MoveCmd(self.nextCmd) then
    return false
  end
  return self:_DoAllowInterrupt(self.moveCmd, self.nextCmd.AIClass, creature)
end

function AI_Myself:_DoAllowInterrupt(currentCmd, nextAIClass, creature, ignoreHit)
  local nextInterruptMap = nextAIClass.Interrupt
  if nil == nextInterruptMap then
    return false
  end
  local interruptLevel = nextInterruptMap[currentCmd.AIClass]
  if nil == interruptLevel then
    return false
  end
  if interruptLevel > currentCmd.interruptLevel then
    if currentCmd.AIClass == AI_CMD_Myself_Hit and ignoreHit then
      return true
    end
    return false
  end
  return true
end

function AI_Myself:_DoAllowConcurrentInterrupt(currentCmd, nextAIClass, creature)
  local nextInterruptMap = nextAIClass.ConcurrentInterrupt
  if nil == nextInterruptMap then
    return false
  end
  local interruptLevel = nextInterruptMap[currentCmd.AIClass]
  if nil == interruptLevel or interruptLevel > currentCmd.interruptLevel then
    return false
  end
  return true
end

function AI_Myself:_AllowInsert(time, deltaTime, creature)
  if nil == self.nextCmd then
    return false
  end
  return self:_DoAllowInsert(self.currentCmd, self.nextCmd.AIClass, creature)
end

function AI_Myself:_DoAllowInsert(currentCmd, nextAIClass, creature)
  local nextInsertMap = nextAIClass.Insert
  if nil == nextInsertMap then
    return false
  end
  local insertLevel = nextInsertMap[currentCmd.AIClass]
  if nil == insertLevel then
    return false
  end
  if insertLevel > currentCmd.interruptLevel then
    return false
  end
  return true
end

function AI_Myself:_NextSkillCmdCanUse(creature, nextCmd)
  if nextCmd ~= nil and AI_CMD_Myself_Skill == nextCmd.AIClass then
    local skillInfo = Game.LogicManager_Skill:GetSkillInfo(nextCmd.args[1])
    if skillInfo ~= nil and creature:Logic_CheckSkillCanUseBySkillInfo(skillInfo) then
      return true
    end
  end
  return false
end

function AI_Myself:_NextMoveCmdCanUse(creature, nextCmd)
  if nil == nextCmd then
    return false
  end
  if AI_CMD_Myself_MoveTo ~= nextCmd.AIClass and AI_CMD_Myself_DirMove ~= nextCmd.AIClass and AI_CMD_Myself_DirMoveEnd ~= nextCmd.AIClass then
    return false
  end
  return creature.data:IsAttrCanMove() and not creature.data:DeepFreeze()
end

function AI_Myself:_NextSkillCmdCanBreakWeakFreeze(creature, nextCmd)
  if nil == nextCmd then
    return false
  end
  if AI_CMD_Myself_Skill ~= nextCmd.AIClass then
    return false
  end
  return creature.data:CanBreakWeakFreezeBySkillID(nextCmd.args[1])
end

function AI_Myself:_CmdCanBeReplaced(creature, cmd, replaceCmd)
  if AI_CMD_Myself_Skill == cmd.AIClass and (AI_CMD_Myself_Skill.FromServer(cmd) or self:_MoveCmd(replaceCmd)) then
    return false
  end
  if cmd.AIClass == AI_CMD_Myself_Die then
    return false
  end
  return true
end

function AI_Myself:_TrySwitchCommand(time, deltaTime, creature)
  local creatureData = creature.data
  local breakWeakFreeze = false
  if creatureData:WeakFreeze() then
    local nextCmd = self.nextCmd or self.nextCmd1
    if self:_NextSkillCmdCanBreakWeakFreeze(creature, nextCmd) then
      breakWeakFreeze = true
    end
  end
  if creatureData:Freeze() or creatureData:DeepFreeze() then
    local nextCmd = self.nextCmd or self.nextCmd1
    if self:_NextSkillCmdCanUse(creature, nextCmd) == false and self:_NextMoveCmdCanUse(creature, nextCmd) == false then
      return
    end
  elseif creatureData:NoAct() or creatureData:FearRun() then
    local nextCmd = self.nextCmd or self.nextCmd1
    if nil == self.dieCmd and (nil == nextCmd or AI_CMD_Myself_Hit ~= nextCmd.AIClass or AI_CMD_Myself_Die ~= nextCmd.AIClass) and false == self:_NextSkillCmdCanUse(creature, nextCmd) and false == self:_NextMoveCmdCanUse(creature, nextCmd) then
      return
    end
  end
  if breakWeakFreeze then
    creature:Logic_BreakWeakFreeze()
  end
  if nil ~= self.dieCmd and not self:DieBlocked() and self:_SetNextCommand(self.dieCmd, creature) then
    self.dieCmd = nil
  end
  if nil == self.nextCmd and nil ~= self.nextCmd1 then
    self.nextCmd = self.nextCmd1
    self.nextCmd1 = nil
  end
  if self.prepareStopMove then
    if self.moveCmd ~= nil then
      self.moveCmd:End(time, deltaTime, creature)
      self.moveCmd:Destroy()
      self.moveCmd = nil
    end
    self.prepareStopMove = false
  end
  if nil ~= self.currentCmd then
    if nil ~= self.nextCmd and nil ~= self.nextCmd1 and self:_DoAllowInterrupt(self.nextCmd, self.nextCmd1.AIClass, creature) then
      self.nextCmd:Destroy()
      self.nextCmd = self.nextCmd1
      self.nextCmd1 = nil
    end
    if self.moveCmd ~= nil then
      if self:_AllowMoveInterrupt(time, deltaTime, creature) then
        self.moveCmd:End(time, deltaTime, creature)
        self.moveCmd:Destroy()
        self.moveCmd = self.nextCmd
        self.nextCmd = self.nextCmd1
        self.nextCmd1 = nil
      elseif nil ~= self.nextCmd and self:_DoAllowConcurrentInterrupt(self.moveCmd, self.nextCmd.AIClass, creature) then
        self.moveCmd:End(time, deltaTime, creature)
        self.moveCmd:Destroy()
        self.moveCmd = nil
      end
    elseif self:_MoveCmd(self.nextCmd) and self.currentCmd.concurrent then
      self.moveCmd = self.nextCmd
      self.nextCmd = self.nextCmd1
      self.nextCmd1 = nil
    elseif self:_AllowInterrupt(time, deltaTime, creature) then
      self.currentCmd:End(time, deltaTime, creature)
      self.currentCmd:Destroy()
      if self:_MoveCmd(self.nextCmd) then
        self.moveCmd = self.nextCmd
        self.currentCmd = nil
      else
        self.currentCmd = self.nextCmd
      end
      self.nextCmd = self.nextCmd1
      self.nextCmd1 = nil
    elseif self:_AllowInsert(time, deltaTime, creature) then
      local oldCurrentCmd = self.currentCmd
      if self:_MoveCmd(self.nextCmd) then
        self.moveCmd = self.nextCmd
        self.currentCmd = nil
      else
        self.currentCmd = self.nextCmd
      end
      oldCurrentCmd:End(time, deltaTime, creature)
      if nil ~= self.dieCmd then
        oldCurrentCmd:Destroy()
        self.nextCmd = self.nextCmd1
        self.nextCmd1 = nil
      else
        if oldCurrentCmd:IsComboSkill() then
          oldCurrentCmd:Destroy()
          oldCurrentCmd = nil
        end
        self.nextCmd = oldCurrentCmd
      end
    end
  elseif nil ~= self.nextCmd then
    if self.moveCmd ~= nil then
      if self:_MoveCmd(self.nextCmd) then
        if self:_DoAllowInterrupt(self.moveCmd, self.nextCmd.AIClass, creature) then
          self.moveCmd:End(time, deltaTime, creature)
          self.moveCmd:Destroy()
          self.moveCmd = self.nextCmd
          self.nextCmd = self.nextCmd1
          self.nextCmd1 = nil
        end
      elseif self.nextCmd.concurrent then
        if self:_DoAllowConcurrentInterrupt(self.moveCmd, self.nextCmd.AIClass, creature) then
          self.moveCmd:End(time, deltaTime, creature)
          self.moveCmd:Destroy()
          self.moveCmd = nil
        end
        self.currentCmd = self.nextCmd
        self.nextCmd = self.nextCmd1
        self.nextCmd1 = nil
      elseif self:_DoAllowInterrupt(self.moveCmd, self.nextCmd.AIClass, creature) then
        self.moveCmd:End(time, deltaTime, creature)
        self.moveCmd:Destroy()
        self.moveCmd = nil
        self.currentCmd = self.nextCmd
        self.nextCmd = self.nextCmd1
        self.nextCmd1 = nil
      elseif self:_DoAllowInsert(self.moveCmd, self.nextCmd.AIClass, creature) then
        self.currentCmd = self.nextCmd
        self.moveCmd:End(time, deltaTime, creature)
        if self.dieCmd ~= nil then
          self.moveCmd:Destroy()
          self.nextCmd = self.nextCmd1
          self.nextCmd1 = nil
        else
          self.nextCmd = self.moveCmd
        end
        self.moveCmd = nil
      end
    else
      if self:_MoveCmd(self.nextCmd) then
        self.moveCmd = self.nextCmd
      else
        self.currentCmd = self.nextCmd
      end
      self.nextCmd = self.nextCmd1
      self.nextCmd1 = nil
    end
  end
  if self.currentCmd ~= nil and self.moveCmd ~= nil and not self.currentCmd.concurrent then
    if self:_DoAllowInterrupt(self.currentCmd, self.moveCmd.AIClass, creature) then
      self.currentCmd:End(time, deltaTime, creature)
      self.currentCmd:Destroy()
      self.currentCmd = nil
    elseif self:_DoAllowInterrupt(self.moveCmd, self.currentCmd.AIClass, creature) then
      self.moveCmd:End(time, deltaTime, creature)
      self.moveCmd:Destroy()
      self.moveCmd = nil
    end
  end
end

function AI_Myself:_TryExecuteSerialCommand(time, deltaTime, creature, cmd, startFunc)
  if nil ~= cmd then
    if cmd.running then
      cmd:Update(time, deltaTime, creature)
    else
      self:_IdleBreak(time, deltaTime, creature)
      cmd:Start(time, deltaTime, creature)
      if startFunc ~= nil then
        startFunc(self, time, deltaTime, creature)
      end
    end
    if nil ~= cmd and not cmd.running and not cmd.keepAlive then
      cmd:Destroy()
      cmd = nil
    end
  end
  return cmd
end

function AI_Myself:_TryExecuteParallelCommand(time, deltaTime, creature)
  if 0 >= #self.parallelCmds then
    return
  end
  local cmds = self.parallelCmds
  local i = 1
  local index, count
  while i <= #cmds and (i ~= index or #cmds ~= count) do
    index = i
    count = #cmds
    local cmd = cmds[i]
    if cmd.running then
      cmd:Update(time, deltaTime, creature)
    else
      if nil ~= self.currentCmd and AI_Myself:_DoAllowInsert(self.currentCmd, cmd.AIClass, creature) then
        self.currentCmd:End(time, deltaTime, creature)
        self.currentCmd:Destroy()
        if self:_MoveCmd(self.nextCmd) then
          self.currentCmd = nil
        else
          self.currentCmd = self.nextCmd
          self.nextCmd = self.nextCmd1
          self.nextCmd1 = nil
        end
      end
      if nil ~= self.moveCmd and AI_Myself:_DoAllowInsert(self.moveCmd, cmd.AIClass, creature) then
        self.moveCmd:End(time, deltaTime, creature)
        self.moveCmd:Destroy()
        if not self:_MoveCmd(self.nextCmd) then
          self.moveCmd = nil
        else
          self.moveCmd = self.nextCmd
          self.nextCmd = self.nextCmd1
          self.nextCmd1 = nil
        end
      end
      cmd:Start(time, deltaTime, creature)
    end
    if not cmd.running and not cmd.keepAlive then
      table.remove(cmds, i)
      cmd:Destroy()
    else
      i = i + 1
    end
  end
  for i = #cmds, 1, -1 do
    local cmd = cmds[i]
    table.remove(cmds, i)
    cmd:Destroy()
  end
end

local AllMyself_AI_CMD = {
  AI_CMD_Myself_SetAngleY,
  AI_CMD_Myself_PlaceTo,
  AI_CMD_Myself_SetScale,
  AI_CMD_Myself_MoveTo,
  AI_CMD_Myself_PlayAction,
  AI_CMD_Myself_DirMove,
  AI_CMD_Myself_DirMoveEnd,
  AI_CMD_Myself_Access,
  AI_CMD_Myself_Skill,
  AI_CMD_Myself_Hit,
  AI_CMD_Myself_Die
}

function AI_Myself:GetCurrentCommand(creature)
  return self.currentCmd
end

function AI_Myself:PushCommand(args, creature)
  if args[1] == AI_CMD_Myself_MoveTo then
  end
  if args[1].Parallel then
    TableUtility.ArrayPushBack(self.parallelCmds, AI_CMD.Create(args))
  else
    if AI_CMD_Myself_Die == args[1] then
      if nil ~= self.dieCmd then
        self.dieCmd:Destroy()
      end
      self.dieCmd = AI_CMD.Create(args)
      return
    elseif nil ~= self.dieCmd and AI_CMD_Myself_Hit ~= args[1] then
      return
    end
    if nil ~= self.currentCmd then
      if self.currentCmd.AIClass == args[1] and self.currentCmd:TryRestart(args, creature) then
        return
      end
      local block = self.currentCmd.AIClass.Block
      if nil ~= block then
        local blockLevel = block[args[1]]
        if not (nil ~= blockLevel and blockLevel >= self.currentCmd.interruptLevel) or AI_CMD_Myself_Hit == args[1] and self.currentCmd.args[14] then
        else
          return
        end
      end
    end
    if self.moveCmd ~= nil and self.moveCmd.AIClass == args[1] and self.moveCmd:TryRestart(args, creature) then
      return
    end
    local cmd = AI_CMD.Create(args)
    if not self:_SetNextCommand(cmd, creature) then
      if args[1] == AI_CMD_Myself_DirMoveEnd then
        self.prepareStopMove = true
      end
      cmd:Destroy()
    end
  end
  if not args[1].SeatAllowed then
    Game.SceneSeatManager:MyselfManualGetOffSeat(creature)
    Game.Myself:Client_GetOffSeat()
    Game.InteractNpcManager:MyselfManualGetOff()
  end
end

function AI_Myself:GetFollowLeaderID(creature)
  return self.autoAI_FollowLeader.leaderID
end

function AI_Myself:IsFollowHandInHand(creature)
  return 0 ~= self:GetFollowLeaderID(creature) and self.autoAI_FollowLeader:IsHandInHand()
end

function AI_Myself:SetFollower(followerID, followType, creature)
  if 0 == followerID then
    return
  end
  if 5 == followType then
    self.followers[followerID] = nil
  else
    self.followers[followerID] = followType or 0
  end
end

function AI_Myself:ClearFollower(creature)
  TableUtility.TableClear(self.followers)
end

function AI_Myself:GetAllFollowers(creature)
  return self.followers
end

function AI_Myself:GetHandInHandFollower(creature)
  for k, v in pairs(self.followers) do
    if 1 == v then
      return k
    end
  end
  return 0
end

function AI_Myself:GetCurrentMissionCommand()
  return self.autoAI_MissionCommand.currentCommand
end

function AI_Myself:GetAutoBattleLockIDs(creature)
  return self.autoAI_Battle.lockIDs
end

function AI_Myself:GetAutoBattleLockTarget(creature, skillInfo)
  local lockIDs = self.autoAI_Battle.lockIDs
  if not next(lockIDs) then
    return nil
  end
  return self.autoAI_Battle:GetLockTarget(creature, skillInfo), lockIDs
end

function AI_Myself:SearchAutoBattleLockTarget(creature, skillInfo)
  local lockIDs = self.autoAI_Battle.lockIDs
  if not next(lockIDs) then
    return nil
  end
  return self.autoAI_Battle:SearchLockTarget(creature, skillInfo), lockIDs
end

function AI_Myself:IsAutoBattleProtectingTeam(creature)
  return self.autoAI_Battle:IsProtectingTeam(creature)
end

function AI_Myself:IsAutoBattleStanding(creature)
  return self.autoAI_Battle:IsStanding(creature)
end

function AI_Myself:SetSkillLockTarget(lockTargetGUID, creature)
end

function AI_Myself:ClearAuto_BattleCurrentTarget(creature)
  self.autoAI_Battle:Request_ClearCurrentTarget()
end

function AI_Myself:SetAuto_BattleLockID(lockID, creature)
  self.autoAI_Battle:Request_SetLockID(lockID)
end

function AI_Myself:UnSetAuto_BattleLockID(lockID, creature)
  self.autoAI_Battle:Request_UnSetLockID(lockID)
end

function AI_Myself:AutoBattleLost()
  self.autoAI_Battle:AutoBattleLost()
end

function AI_Myself:SetAuto_BattleProtectTeam(on, creature)
  self.autoAI_Battle:Request_SetProtectTeam(on)
end

function AI_Myself:SetAuto_BattleStanding(on, creature)
  self.autoAI_Battle:Request_SetStanding(on)
end

function AI_Myself:SetAuto_Battle(on, creature)
  if on then
    local ignoreAction = false
    if creature:IsFakeDead() and self.currentCmd ~= nil and self.currentCmd.AIClass == AI_CMD_Myself_PlayAction and self.currentCmd.args[4] and self.autoAI_FakeDead.on then
      ignoreAction = true
    end
    self:WeakBreak(UnityTime, UnityDeltaTime, creature, ignoreAction)
    self:SetAuto_FollowLeader(0, creature)
  end
  self:SetAuto_MissionCommand(nil, creature)
  self.autoAI_Battle:Request_Set(on)
end

function AI_Myself:SetAutoFakeDead(skillID, creature)
  self.autoAI_FakeDead:Set_AutoFakeDead(skillID)
end

function AI_Myself:SetAuto_MissionCommand(newCmd, creature)
  if nil ~= newCmd then
    self:WeakBreak(UnityTime, UnityDeltaTime, creature)
  end
  self.autoAI_MissionCommand:Request_Set(newCmd)
end

function AI_Myself:SetAuto_FollowLeader(leaderID, followType, creature, ignoreNotifyServer)
  if 0 ~= leaderID then
    if 1 == followType then
      self.autoAI_FollowLeader:Request_SetHandInHand(true)
    elseif 6 == followType then
      self.autoAI_FollowLeader:Request_SetDoubleAction(true)
    else
      self.autoAI_FollowLeader:Request_SetDoubleAction(false)
      self.autoAI_FollowLeader:Request_SetHandInHand(false)
    end
    if self:GetFollowLeaderID(creature) ~= leaderID then
      self:WeakBreak(UnityTime, UnityDeltaTime, creature)
      self:SetAuto_MissionCommand(nil, creature)
    end
  else
    self.autoAI_FollowLeader:Request_SetDoubleAction(false)
    self.autoAI_FollowLeader:Request_SetHandInHand(false)
  end
  self.autoAI_FollowLeader:Request_Set(leaderID, ignoreNotifyServer)
end

function AI_Myself:SetAuto_FollowLeaderMoveToMap(mapID, pos)
  self.autoAI_FollowLeader:Request_MoveToMap(mapID, pos)
end

function AI_Myself:SetAuto_FollowHandInHandState(running, creature)
  self.autoAI_FollowLeader:Request_SetHandInHandState(running)
end

function AI_Myself:SetAuto_FollowLeaderTarget(guid, time)
  self.autoAI_FollowLeader:Request_RefreshLeaderTarget(guid, time)
end

function AI_Myself:SetAuto_FollowLeaderDelay()
  self.autoAI_FollowLeader:Request_Delay()
end

function AI_Myself:SetAuto_EndlessTowerSweep(on)
  self.autoAI_EndlessTowerSweep:Request_Set(on)
end

function AI_Myself:GetAuto_EndlessTowerSweep()
  return self.autoAI_EndlessTowerSweep.on
end

function AI_Myself:SetAuto_SkillTargetPoint(on)
  self.autoAI_SkillTargetPoint:Request_Set(on)
end

function AI_Myself:SetAuto_SkillOverAction(endAction)
  self.autoAI_SkillOverAction:Request_Set(endAction)
end

function AI_Myself:TryBreakAll(time, deltaTime, creature, ignoreSkill, ignoreMove)
  self:BreakAll(time, deltaTime, creature)
  self.ignoreSkill = ignoreSkill
  self.ignoreMove = ignoreMove
  return true
end

function AI_Myself:BreakAll(time, deltaTime, creature)
  self.requestBreakAll = true
  if nil ~= self.nextCmd then
    self.nextCmd:Destroy()
    self.nextCmd = nil
  end
  if nil ~= self.nextCmd1 then
    self.nextCmd1:Destroy()
    self.nextCmd1 = nil
  end
end

function AI_Myself:WeakBreak(time, deltaTime, creature, ignoreAction)
  self.requestWeakBreak = true
  self.weakBreakIgnoreAction = ignoreAction or false
end

function AI_Myself:DelayInterruptCameraSmooth(delayFrameCount)
  self.delayInterruptCameraSmooth = delayFrameCount
end

function AI_Myself:_BreakAll(time, deltaTime, creature)
  self.requestBreakAll = false
  self:_IdleBreak(time, deltaTime, creature)
  if nil ~= self.currentCmd and (not self.ignoreSkill or AI_CMD_Myself_Skill ~= self.currentCmd.AIClass) then
    self.currentCmd:End(time, deltaTime, creature)
    self.currentCmd:Destroy()
    self.currentCmd = nil
  end
  if self.moveCmd ~= nil and not self.ignoreMove then
    self.moveCmd:End(time, deltaTime, creature)
    self.moveCmd:Destroy()
    self.moveCmd = nil
  end
  self.ignoreSkill = nil
  self.ignoreMove = nil
end

function AI_Myself:_WeakBreak(time, deltaTime, creature)
  local ignoreAction = self.weakBreakIgnoreAction
  self.requestWeakBreak = false
  self.weakBreakIgnoreAction = false
  self:_IdleBreak(time, deltaTime, creature)
  if nil ~= self.currentCmd then
    local interruptLevel = AI_CMD_Myself_MoveTo.Interrupt[self.currentCmd.AIClass]
    if nil ~= interruptLevel and interruptLevel <= self.currentCmd.interruptLevel and (not ignoreAction or AI_CMD_Myself_PlayAction ~= self.currentCmd.AIClass) then
      self.currentCmd:End(time, deltaTime, creature)
      self.currentCmd:Destroy()
      self.currentCmd = nil
    end
  end
end

function AI_Myself:Set_AutoReload(skillID, creature)
  self.autoAI__Reload:Set_AutoReload(skillID)
end

function AI_Myself:SetConcurrent(v)
  local cmd = self.currentCmd
  if cmd ~= nil and cmd.AIClass == AI_CMD_Myself_Skill then
    cmd:SetConcurrent(v)
  end
end

function AI_Myself:_Clear(time, deltaTime, creature)
  self:_BreakAll(time, deltaTime, creature)
  AI_Myself.super._Clear(self, time, deltaTime, creature)
  self.autoAI_MissionCommand = nil
  self.autoAI_FakeDead = nil
  self.autoAI_FollowLeader = nil
  self.autoAI_EndlessTowerSweep = nil
  self.autoAI__Reload = nil
  self.autoAI_Battle = nil
  self.autoAI_SkillTargetPoint = nil
  self.autoAI_SkillOverAction = nil
end

function AI_Myself:_DoUpdate(time, deltaTime, creature)
  if 0 < self.delayInterruptCameraSmooth then
    self.delayInterruptCameraSmooth = self.delayInterruptCameraSmooth - 1
    if 0 == self.delayInterruptCameraSmooth and nil ~= CameraController.singletonInstance then
      CameraController.singletonInstance:InterruptSmoothTo()
    end
  end
  local currentCmdCocurrent = self.currentCmd and self.currentCmd.concurrent
  self:_TrySwitchCommand(time, deltaTime, creature)
  self:_TryExecuteParallelCommand(time, deltaTime, creature)
  self.currentCmd = self:_TryExecuteSerialCommand(time, deltaTime, creature, self.currentCmd)
  self.moveCmd = self:_TryExecuteSerialCommand(time, deltaTime, creature, self.moveCmd, self._Move)
  if nil == self.currentCmd and nil == self.nextCmd and nil == self.nextCmd1 and self.moveCmd == nil then
    if currentCmdCocurrent and "none" == self.idleAction then
      self:TryStopBaseAction(creature)
    end
    self:_Idle(time, deltaTime, creature)
    if 0 >= #self.parallelCmds then
      AI_Myself.super._DoUpdate(self, time, deltaTime, creature)
      return
    end
  elseif nil ~= self.currentCmd then
    if self.currentCmd.AIClass.NotifyAngleY then
      self:_DoNotifyAngleY(time, deltaTime, creature)
    end
    if self.moveCmd == nil then
      self:_StopMove(time, deltaTime, creature)
    end
  end
  AI_Myself.super._DoUpdate(self, time, deltaTime, creature)
end

function AI_Myself:_DoRequest(time, deltaTime, creature)
  AI_Myself.super._DoRequest(self, time, deltaTime, creature)
  if self.requestWeakBreak then
    self:_WeakBreak(time, deltaTime, creature)
  end
  if self.requestBreakAll then
    self:_BreakAll(time, deltaTime, creature)
  end
end
