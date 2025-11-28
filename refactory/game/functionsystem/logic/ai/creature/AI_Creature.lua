AI_Creature = class("AI_Creature", AI_Base)
if not AI_Creature.AI_Creature_inited then
  AI_Creature.AI_Creature_inited = true
  AI_CMD_PlaceTo.InQueue = true
  AI_CMD_GetOnSeat.InQueue = true
  AI_CMD_GetOffSeat.InQueue = true
  AI_CMD_MoveTo.InQueue = true
  AI_CMD_PlayAction.InQueue = true
  AI_CMD_Skill.InQueue = true
  AI_CMD_ClientPatrol.InQueue = true
  AI_CMD_ClientChaseTarget.InQueue = true
  AI_CMD_ClientAvoidTarget.InQueue = true
  AI_CMD_PlaceTo.BreakIdle = true
  AI_CMD_GetOnSeat.BreakIdle = true
  AI_CMD_GetOffSeat.BreakIdle = true
  AI_CMD_MoveTo.BreakIdle = true
  AI_CMD_PlayAction.BreakIdle = true
  AI_CMD_Skill.BreakIdle = true
  AI_CMD_Hit.BreakIdle = true
  AI_CMD_Die.BreakIdle = true
  AI_CMD_Spin.BreakIdle = true
  AI_CMD_Breakdown.BreakIdle = true
  AI_CMD_PlaceTo.IgnoreBreak = true
  AI_CMD_GetOnSeat.IgnoreBreak = true
  AI_CMD_GetOffSeat.IgnoreBreak = true
  AI_CMD_SetAngleY.IgnoreBreak = true
  AI_CMD_SetScale.IgnoreBreak = true
  AI_CMD_Revive.IgnoreBreak = true
  AI_CMD_PlaceTo.IsMoveCmd = true
  AI_CMD_MoveTo.IsMoveCmd = true
  AI_CMD_SetAngleY.IsMoveCmd = true
  AI_CMD_PlaceTo.ReqEatReq = {
    AI_CMD_MoveTo,
    AI_CMD_GetOnSeat
  }
  AI_CMD_MoveTo.ReqEatReq = {
    AI_CMD_PlayAction,
    AI_CMD_GetOnSeat
  }
  AI_CMD_Skill.ReqEatReq = {
    AI_CMD_Hit,
    AI_CMD_PlayAction,
    AI_CMD_GetOnSeat,
    AI_CMD_Spin
  }
  AI_CMD_Die.ReqEatReq = {
    AI_CMD_GetOnSeat
  }
  AI_CMD_Revive.ReqEatReq = {
    AI_CMD_Die,
    AI_CMD_GetOnSeat
  }
  AI_CMD_Skill.RunEatReq = {
    AI_CMD_Hit,
    AI_CMD_Spin
  }
  AI_CMD_Die.RunEatReq = {
    AI_CMD_Hit,
    AI_CMD_Spin,
    AI_CMD_Breakdown
  }
  AI_CMD_PlaceTo.Interrupts = {
    AI_CMD_MoveTo,
    AI_CMD_Skill,
    AI_CMD_PlayAction
  }
  AI_CMD_MoveTo.Interrupts = {
    AI_CMD_MoveTo,
    AI_CMD_PlayAction,
    AI_CMD_ClientPatrol,
    AI_CMD_ClientChaseTarget,
    AI_CMD_ClientAvoidTarget
  }
  AI_CMD_Skill.Interrupts = {
    AI_CMD_Skill,
    AI_CMD_PlayAction
  }
  AI_CMD_PlayAction.Interrupts = {
    AI_CMD_PlayAction,
    AI_CMD_Skill
  }
  AI_CMD_Hit.Interrupts = {
    AI_CMD_PlayAction
  }
  AI_CMD_Spin.Interrupts = {
    AI_CMD_PlayAction
  }
  AI_CMD_Die.Interrupts = {
    AI_CMD_Hit,
    AI_CMD_PlayAction,
    AI_CMD_Skill,
    AI_CMD_Spin,
    AI_CMD_Breakdown
  }
  AI_CMD_Revive.Interrupts = {
    AI_CMD_Die
  }
  AI_CMD_GetOffSeat.Interrupts = {
    AI_CMD_PlayAction
  }
  AI_CMD_DirMove.Interrupts = {
    AI_CMD_MoveTo,
    AI_CMD_PlayAction,
    AI_CMD_Skill,
    AI_CMD_Hit,
    AI_CMD_Spin
  }
  AI_CMD_DirMoveEnd.Interrupts = {
    AI_CMD_DirMove
  }
  AI_CMD_SpinEnd.Interrupts = {
    AI_CMD_Spin
  }
  AI_CMD_BreakdownEnd.Interrupts = {
    AI_CMD_Breakdown
  }
  AI_CMD_Breakdown.Interrupts = {
    AI_CMD_Skill
  }
  AI_CMD_PlaceTo.WeakInterrupts = {}
  AI_CMD_MoveTo.WeakInterrupts = {
    AI_CMD_Hit,
    AI_CMD_Skill,
    AI_CMD_Spin
  }
  AI_CMD_PlayAction.WeakInterrupts = {
    AI_CMD_Hit,
    AI_CMD_Spin
  }
  AI_CMD_Skill.WeakInterrupts = {
    AI_CMD_Hit,
    AI_CMD_Spin
  }
  AI_CMD_Die.BlockedBy = {
    AI_CMD_Hit,
    AI_CMD_Spin
  }
  AI_CMD_SetAngleY.BlockedBy = {
    AI_CMD_MoveTo,
    AI_CMD_Skill
  }
  AI_CMD_MoveTo.BlockedBy = {
    AI_CMD_Die
  }
  AI_CMD_PlayAction.BlockedBy = {
    AI_CMD_Hit,
    AI_CMD_Die,
    AI_CMD_Spin
  }
  AI_CMD_Skill.BlockedBy = {
    AI_CMD_Die
  }
  AI_CMD_Hit.BlockedBy = {
    AI_CMD_Breakdown
  }
  AI_CMD_Hit.Hides = {
    AI_CMD_MoveTo
  }
end
local Index_CurCmd = 1
local Index_MoveCmd = 2
local CurCmdIndex = {Index_CurCmd, Index_MoveCmd}
local CanRunTogether_Normal = function(checkCmd, curCmd)
  if not curCmd or not checkCmd then
    return true
  end
  return curCmd.concurrent and checkCmd.AIClass.IsMoveCmd
end
local CanRunTogether_Move = function(checkCmd, curCmd)
  return not checkCmd or checkCmd.concurrent
end
local CheckCanRunTogether = {
  [Index_CurCmd] = CanRunTogether_Normal,
  [Index_MoveCmd] = CanRunTogether_Move
}

function AI_CMD_Die.AllowStart(cmd, ai, creature)
  if ai:DieBlocked() then
    return false
  end
  return true
end

local EatCommands = function(eatAIClasses, cmds)
  if nil ~= eatAIClasses then
    for i = 1, #eatAIClasses do
      local eatAIClass = eatAIClasses[i]
      local eatCmd = cmds[eatAIClass]
      if nil ~= eatCmd then
        eatCmd:Destroy()
        cmds[eatAIClass] = nil
      end
    end
  end
end
local InterruptCommands = function(checkCmd, cmds, currentCmds, time, deltaTime, creature)
  local interruptCount = 0
  local AIClass = checkCmd.AIClass
  local interrupts = AIClass.Interrupts
  if nil ~= interrupts then
    for i = 1, #interrupts do
      local interruptAIClass = interrupts[i]
      if interruptAIClass.InQueue then
        if currentCmds then
          for x = 1, #CurCmdIndex do
            local command = currentCmds[x]
            if nil ~= command and command.AIClass == interruptAIClass and not CheckCanRunTogether[x](checkCmd, command) then
              command:End(time, deltaTime, creature)
              command:Destroy()
              command = nil
              interruptCount = interruptCount + 1
            end
          end
        end
      else
        local interruptCmd = cmds[interruptAIClass]
        if nil ~= interruptCmd then
          interruptCmd:End(time, deltaTime, creature)
          interruptCmd:Destroy()
          cmds[interruptAIClass] = nil
          interruptCount = interruptCount + 1
        end
      end
    end
  end
  return interruptCount
end
local TryInterruptCommands = function(checkCmd, cmds, currentCmds, time, deltaTime, creature)
  local interruptCount = 0
  local AIClass = checkCmd.AIClass
  local interrupts = AIClass.Interrupts
  if nil ~= interrupts then
    for x = 1, #CurCmdIndex do
      local command = currentCmds[x]
      if nil ~= command then
        for i = 1, #interrupts do
          local interruptAIClass = interrupts[i]
          if interruptAIClass.InQueue and command.AIClass == interruptAIClass and not CheckCanRunTogether[x](checkCmd, command) then
            command:End(time, deltaTime, creature)
            command:Destroy()
            command = nil
            interruptCount = interruptCount + 1
            break
          end
        end
      end
      if nil == command then
        for i = 1, #interrupts do
          local interruptAIClass = interrupts[i]
          if not interruptAIClass.InQueue then
            local interruptCmd = cmds[interruptAIClass]
            if nil ~= interruptCmd then
              interruptCmd:End(time, deltaTime, creature)
              interruptCmd:Destroy()
              cmds[interruptAIClass] = nil
              interruptCount = interruptCount + 1
            end
          end
        end
      end
    end
  end
  return interruptCount
end
local WeakInterruptCommands = function(checkCmd, cmds, currentCmds, time, deltaTime, creature)
  local interruptCount = 0
  local AIClass = checkCmd.AIClass
  local interrupts = AIClass.WeakInterrupts
  if nil ~= interrupts then
    for i = 1, #interrupts do
      local interruptAIClass = interrupts[i]
      if interruptAIClass.InQueue then
        if currentCmds then
          for x = 1, #CurCmdIndex do
            local command = currentCmds[x]
            if nil ~= command and command.AIClass == interruptAIClass and 1 < command.interruptLevel and not CheckCanRunTogether[x](checkCmd, command) then
              command:End(time, deltaTime, creature)
              command:Destroy()
              interruptCount = interruptCount + 1
            end
          end
        end
      else
        local interruptCmd = cmds[interruptAIClass]
        if nil ~= interruptCmd and 1 < interruptCmd.interruptLevel then
          interruptCmd:End(time, deltaTime, creature)
          interruptCmd:Destroy()
          cmds[interruptAIClass] = nil
          interruptCount = interruptCount + 1
        end
      end
    end
  end
  return interruptCount
end
local TryWeakInterruptCommands = function(checkCmd, cmds, currentCmds, time, deltaTime, creature)
  local interruptCount = 0
  local AIClass = checkCmd.AIClass
  local interrupts = AIClass.WeakInterrupts
  if nil ~= interrupts then
    for x = 1, #CurCmdIndex do
      local command = currentCmds[x]
      if nil ~= command and 1 < command.interruptLevel then
        for i = 1, #interrupts do
          local interruptAIClass = interrupts[i]
          if interruptAIClass.InQueue and command.AIClass == interruptAIClass and not CheckCanRunTogether[x](checkCmd, command) then
            command:End(time, deltaTime, creature)
            command:Destroy()
            command = nil
            interruptCount = interruptCount + 1
            break
          end
        end
      end
      if nil == command then
        for i = 1, #interrupts do
          local interruptAIClass = interrupts[i]
          if not interruptAIClass.InQueue then
            local interruptCmd = cmds[interruptAIClass]
            if nil ~= interruptCmd and 1 < interruptCmd.interruptLevel then
              interruptCmd:End(time, deltaTime, creature)
              interruptCmd:Destroy()
              cmds[interruptAIClass] = nil
              interruptCount = interruptCount + 1
            end
          end
        end
      end
    end
  end
  return interruptCount
end
local AllowStart = function(AIClass, cmd, ai, creature)
  local blockedBy = AIClass.BlockedBy
  if nil ~= blockedBy then
    local requestCmds = ai.requestCmds
    local runningCmds = ai.runningCmds
    for i = 1, #blockedBy do
      local blockedByAIClass = blockedBy[i]
      local blockedByCmd = requestCmds[blockedByAIClass]
      if nil ~= blockedByCmd then
        return false
      end
      blockedByCmd = runningCmds[blockedByAIClass]
      if nil ~= blockedByCmd then
        return false
      end
    end
  end
  if nil ~= AIClass.AllowStart then
    return AIClass.AllowStart(cmd, ai, creature)
  end
  return true
end

function AI_Creature:ctor()
  self.requestCmds = {}
  self.runningCmds = {}
  self.currentCmd = nil
  self.currentCmds = {}
  self.cmdQueue = {}
  self.idle = false
  self.requestBreakAll = false
  self.requestCameraFlash = false
  self.idleBreaked = false
  AI_Creature.super.ctor(self)
end

function AI_Creature:Deconstruct(creature)
  AI_Creature.super.Deconstruct(self, creature)
  local cmds = self.requestCmds
  for k, v in pairs(cmds) do
    v:Destroy()
    cmds[k] = nil
  end
  self.requestCmdsCount = 0
  cmds = self.cmdQueue
  if 0 < #cmds then
    for i = #cmds, 1, -1 do
      cmds[i]:Destroy()
      table.remove(cmds, i)
    end
  end
end

function AI_Creature:_TryBreakIdle(cmd, time, deltaTime, creature)
  if cmd.AIClass.BreakIdle then
    self:_IdleBreak(time, deltaTime, creature)
  end
end

function AI_Creature:_InitIdleAI(idleAIManager)
end

function AI_Creature:HideCommands(AIClass, time, deltaTime, creature)
  local currentCmds = self.currentCmds
  local cmds = self.runningCmds
  local hides = AIClass.Hides
  if nil ~= hides then
    for i = 1, #hides do
      local hideAIClass = hides[i]
      local hideCmd = cmds[hideAIClass]
      if nil ~= hideCmd then
        hideCmd:End(time, deltaTime, creature)
        hideCmd:SetKeepAlive(true)
      end
      for x = 1, #CurCmdIndex do
        local command = currentCmds[x]
        if nil ~= command and command.AIClass == hideAIClass then
          command:End(time, deltaTime, creature)
          command:SetKeepAlive(true)
        end
      end
    end
  end
end

function AI_Creature:UnhideCommands(AIClass, time, deltaTime, creature)
  local currentCmds = self.currentCmds
  local cmds = self.runningCmds
  local hides = AIClass.Hides
  if nil ~= hides then
    for i = 1, #hides do
      local hideAIClass = hides[i]
      local hideCmd = cmds[hideAIClass]
      if nil ~= hideCmd then
        self:_TryBreakIdle(hideCmd, time, deltaTime, creature)
        hideCmd:Start(time, deltaTime, creature)
      end
      for x = 1, #CurCmdIndex do
        local command = currentCmds[x]
        if nil ~= command and command.AIClass == hideAIClass then
          self:_TryBreakIdle(command, time, deltaTime, creature)
          command:Start(time, deltaTime, creature)
        end
      end
    end
  end
end

local SetSpeedScale = Asset_Role.SetSpeedScale
local SetFastForwardSpeed = Logic_Transform.SetFastForwardSpeed

function AI_Creature:_TryExecuteCommands(time, deltaTime, creature)
  local runningCount = 0
  local requestCmds = self.requestCmds
  local runningCmds = self.runningCmds
  local currentCmds = self.currentCmds
  local cmdQueue = self.cmdQueue
  local isMoving = currentCmds[Index_MoveCmd] ~= nil
  for AIClass, cmd in pairs(runningCmds) do
    cmd:Update(time, deltaTime, creature)
    if cmd.running or cmd.keepAlive then
      EatCommands(AIClass.RunEatReq, requestCmds)
      runningCount = runningCount + 1
    else
      cmd:Destroy()
      runningCmds[AIClass] = nil
    end
  end
  for x = 1, #CurCmdIndex do
    local command = currentCmds[x]
    if command ~= nil then
      command:Update(time, deltaTime, creature)
      if command.running or command.keepAlive then
        runningCount = runningCount + 1
        EatCommands(command.AIClass.RunEatReq, requestCmds)
        runningCount = runningCount - InterruptCommands(command, runningCmds, nil, time, deltaTime, creature)
        runningCount = runningCount - WeakInterruptCommands(command, runningCmds, nil, time, deltaTime, creature)
      else
        command:Destroy()
        currentCmds[x] = nil
      end
    end
  end
  for AIClass, cmd in pairs(requestCmds) do
    runningCount = runningCount - InterruptCommands(cmd, runningCmds, currentCmds, time, deltaTime, creature)
    runningCount = runningCount - WeakInterruptCommands(cmd, runningCmds, currentCmds, time, deltaTime, creature)
  end
  for x = 1, #CurCmdIndex do
    local command = currentCmds[x]
    if command ~= nil and not command:Alive() then
      currentCmds[x] = nil
    end
  end
  if 0 < #cmdQueue then
    local nextCmd = cmdQueue[1]
    if currentCmds[Index_CurCmd] or currentCmds[Index_MoveCmd] then
      runningCount = runningCount - TryInterruptCommands(nextCmd, runningCmds, currentCmds, time, deltaTime, creature)
      for x = 1, #CurCmdIndex do
        local command = currentCmds[x]
        if command ~= nil and not command:Alive() then
          currentCmds[x] = nil
        end
      end
      runningCount = runningCount - TryWeakInterruptCommands(nextCmd, runningCmds, currentCmds, time, deltaTime, creature)
      for x = 1, #CurCmdIndex do
        local command = currentCmds[x]
        if command ~= nil and not command:Alive() then
          currentCmds[x] = nil
        end
      end
    end
  end
  local fastForward = false
  for AIClass, cmd in pairs(requestCmds) do
    if AllowStart(AIClass, cmd, self, creature) then
      requestCmds[AIClass] = nil
      local oldCmd = runningCmds[AIClass]
      if nil ~= oldCmd then
        if oldCmd.running then
          oldCmd:End(time, deltaTime, creature)
        elseif oldCmd.keepAlive then
          cmd:SetKeepAlive(true)
        end
        oldCmd:Destroy()
        runningCmds[AIClass] = nil
      end
      if cmd.keepAlive then
        runningCmds[AIClass] = cmd
      else
        self:_TryBreakIdle(cmd, time, deltaTime, creature)
        if cmd:Start(time, deltaTime, creature) then
          runningCmds[AIClass] = cmd
          runningCount = runningCount + 1
        else
          cmd:Destroy()
        end
      end
    else
      fastForward = true
    end
  end
  local index = 1
  local newCmd
  while index <= #cmdQueue do
    local cmd = cmdQueue[index]
    local cmdIndex = cmd.AIClass.IsMoveCmd and Index_MoveCmd or Index_CurCmd
    if currentCmds[cmdIndex] == nil then
      if cmd.AIClass.IsMoveCmd then
        if not (currentCmds[Index_CurCmd] == nil or currentCmds[Index_CurCmd].concurrent) then
          break
        end
      else
      end
      if not ((cmd.concurrent or not currentCmds[Index_MoveCmd]) and AllowStart(cmd.AIClass, cmd, self, creature)) then
        break
      end
      table.remove(cmdQueue, index)
      self:_TryBreakIdle(cmd, time, deltaTime, creature)
      if cmd:Start(time, deltaTime, creature) then
        runningCount = runningCount + 1
        currentCmds[cmdIndex] = cmd
        break
      else
        cmd:Destroy()
      end
    else
      index = index + 1
    end
  end
  self.currentCmd = currentCmds[Index_CurCmd]
  if isMoving and not currentCmds[Index_MoveCmd] and self.currentCmd and self.currentCmd.concurrent then
    creature:Logic_StopBaseAction()
  end
  if not fastForward and 0 < #cmdQueue then
    fastForward = true
  end
  if fastForward then
    SetFastForwardSpeed(creature.logicTransform, 2)
    SetSpeedScale(creature.assetRole, 2)
  else
    SetFastForwardSpeed(creature.logicTransform, 1)
    SetSpeedScale(creature.assetRole, 1)
  end
  return runningCount
end

function AI_Creature:IsDiePending()
  return nil ~= self.requestCmds[AI_CMD_Die]
end

function AI_Creature:IsPending(AIClass)
  return nil ~= self.requestCmds[AIClass]
end

function AI_Creature:IsRunning(AIClass)
  return nil ~= self.runningCmds[AIClass]
end

function AI_Creature:PushCommand(args, creature)
  local requestCmds = self.requestCmds
  local AIClass = args[1]
  local cmd = requestCmds[AIClass]
  if nil ~= cmd then
    cmd:ResetArgs(args)
  elseif AIClass.InQueue then
    local cmdQueue = self.cmdQueue
    local cmdCount = #cmdQueue
    if cmdCount <= 0 then
      cmdQueue[1] = AI_CMD.Create(args)
    else
      local lastCmd = cmdQueue[cmdCount]
      if lastCmd.AIClass == AIClass then
        lastCmd:ResetArgs(args)
      else
        local eatAIClasses = AIClass.ReqEatReq
        if nil ~= eatAIClasses and 0 < TableUtility.ArrayFindIndex(eatAIClasses, lastCmd.AIClass) then
          lastCmd:Destroy()
          cmdQueue[cmdCount] = AI_CMD.Create(args)
        else
          cmdQueue[cmdCount + 1] = AI_CMD.Create(args)
        end
      end
    end
  else
    EatCommands(AIClass.ReqEatReq, requestCmds)
    requestCmds[AIClass] = AI_CMD.Create(args)
  end
end

function AI_Creature:BreakAll(time, deltaTime, creature)
  self.requestBreakAll = true
  local cmds = self.requestCmds
  for k, v in pairs(cmds) do
    if not k.IgnoreBreak then
      v:Destroy()
      cmds[k] = nil
    end
  end
  cmds = self.cmdQueue
  if 0 < #cmds then
    for i = #cmds, 1, -1 do
      if not cmds[i].AIClass.IgnoreBreak then
        cmds[i]:Destroy()
        table.remove(cmds, i)
      end
    end
  end
end

function AI_Creature:CameraFlash(time, deltaTime, creature)
  self.requestCameraFlash = true
end

function AI_Creature:HandInHand(masterGUID, creature)
  if self.idleAI_HandInHand == nil then
    self.idleAI_HandInHand = IdleAI_HandInHand.new()
    self.idleAIManager:PushAI_Sort(self.idleAI_HandInHand)
  end
  self.idleAI_HandInHand:Request_Set(masterGUID)
end

function AI_Creature:BeHolded(masterGUID, creature)
  if self.idleAI_BeHolded == nil then
    self.idleAI_BeHolded = IdleAI_BeHolded.new()
    self.idleAIManager:PushAI_Sort(self.idleAI_BeHolded)
  end
  if nil ~= creature.data then
    self.idleAI_BeHolded:Request_Set(masterGUID, creature.data:GetHoldScale(), creature.data:GetHoldDir(), creature.data:GetHoldOffset(), creature.data:GetHoldDirX())
  else
    self.idleAI_BeHolded:Request_Set(masterGUID)
  end
end

function AI_Creature:DoDoubleAction(masterGUID, creature)
  if self.idleAI_DoubleAction == nil then
    self.idleAI_DoubleAction = IdleAI_DoubleAction.new()
    self.idleAIManager:PushAI_Sort(self.idleAI_DoubleAction)
  end
  self.idleAI_DoubleAction:Request_Set(masterGUID)
end

function AI_Creature:SetAuto_SkillOverAction(endAction)
  if self.idleAI_SkillOverAction == nil then
    self.idleAI_SkillOverAction = IdleAI_SkillOverAction.new()
    self.idleAIManager:PushAI_Sort(self.idleAI_SkillOverAction)
  end
  self.idleAI_SkillOverAction:Request_Set(endAction)
end

function AI_Creature:_CameraFlash(time, deltaTime, creature)
  if self.idleAI_Photographer == nil then
    self.idleAI_Photographer = IdleAI_Photographer.new()
    self.idleAIManager:PushAI_Sort(self.idleAI_Photographer)
  end
  self.requestCameraFlash = false
  self.idleAI_Photographer:Flash(time, deltaTime, creature)
end

function AI_Creature:DOPatrol(creature)
  if self.idleAI_Patrol == nil then
    local npcStaticData = creature.data.staticData.NpcAI
    if npcStaticData ~= nil and 0 < #npcStaticData then
      local aiData = Table_HomeNpcAI[npcStaticData[math.random(#npcStaticData)]]
      self.idleAI_Patrol = IdleAI_Patrol.new(aiData.IsLoop, aiData.Content, aiData.FollowAI)
      self.idleAIManager:PushAI_Sort(self.idleAI_Patrol)
    end
  end
end

function AI_Creature:RemovePatrol()
  if self.idleAI_Patrol ~= nil then
    self.idleAIManager:RemoveAI(self.idleAI_Patrol)
    self.idleAI_Patrol = nil
  end
end

function AI_Creature:_BreakAll(time, deltaTime, creature)
  self.requestBreakAll = false
  self:_IdleBreak(time, deltaTime, creature)
  local cmds = self.runningCmds
  for k, v in pairs(cmds) do
    v:Destroy()
    cmds[k] = nil
  end
  for x = 1, #CurCmdIndex do
    local command = self.currentCmds[x]
    if nil ~= command then
      command:End(time, deltaTime, creature)
      command:Destroy()
      self.currentCmds[x] = nil
    end
  end
  self.currentCmd = nil
end

function AI_Creature:PlayShowCombo(creature, combolist)
  if self.idleAI_PlayShowCombo == nil then
    self.idleAI_PlayShowCombo = IdleAI_PlayShowCombo.new(combolist)
    self.idleAIManager:PushAI_Sort(self.idleAI_PlayShowCombo)
  end
  self.idleAI_PlayShowCombo:Request_Set(masterGUID)
end

function AI_Creature:SetConcurrent(v)
  local cmd = self.currentCmds[Index_CurCmd]
  if cmd ~= nil and cmd.AIClass == AI_CMD_Skill then
    cmd:SetConcurrent(v)
  end
end

local selfBreakAll1 = AI_Creature.BreakAll
local selfBreakAll2 = AI_Creature._BreakAll
local superClear = AI_Creature.super._Clear

function AI_Creature:_Clear(time, deltaTime, creature)
  selfBreakAll1(self, time, deltaTime, creature)
  selfBreakAll2(self, time, deltaTime, creature)
  superClear(self, time, deltaTime, creature)
  self.idleAI_HandInHand = nil
  self.idleAI_BeHolded = nil
  self.idleAI_DoubleAction = nil
  self.idleAI_SkillOverAction = nil
  self.idleAI_Photographer = nil
  self.idleAI_Patrol = nil
  self.idleAI_PlayShowCombo = nil
end

local UpdateCurrentAI = IdleAIManager.UpdateCurrentAI
local selfTryExecuteCommands = AI_Creature._TryExecuteCommands
local superDoUpdate = AI_Creature.super._DoUpdate
local superIdle = AI_Creature.super._Idle
local superIdleBreak = AI_Creature.super._IdleBreak

function AI_Creature:_DoUpdate(time, deltaTime, creature)
  self.idleBreaked = false
  local runningCount = selfTryExecuteCommands(self, time, deltaTime, creature)
  if runningCount <= 0 then
    if nil ~= self.parent and self.idleAIManager.currentAI == self.idleAI_BeHolded then
      superDoUpdate(self, time, deltaTime, creature)
      UpdateCurrentAI(self.idleAIManager, self.idleElapsed, time, deltaTime, creature)
      return false
    end
    local isIdle = superIdle(self, time, deltaTime, creature)
    superDoUpdate(self, time, deltaTime, creature)
    return isIdle
  else
    superDoUpdate(self, time, deltaTime, creature)
    self:_IdleBreak(time, deltaTime, creature)
  end
  self.idleBreaked = false
end

local selfCameraFlash = AI_Creature._CameraFlash
local superDoRequest = AI_Creature.super._DoRequest

function AI_Creature:_DoRequest(time, deltaTime, creature)
  superDoRequest(self, time, deltaTime, creature)
  if self.requestBreakAll then
    selfBreakAll2(self, time, deltaTime, creature)
  end
  if self.requestCameraFlash then
    selfCameraFlash(self, time, deltaTime, creature)
  end
end

function AI_Creature:_IdleBreak(time, deltaTime, creature)
  if self.idleBreaked then
    return
  end
  self.idleBreaked = true
  superIdleBreak(self, time, deltaTime, creature)
end

function AI_Creature:_Idle(time, deltaTime, creature)
  if nil ~= self.parent and self.idleAIManager.currentAI == self.idleAI_BeHolded then
    UpdateCurrentAI(self.idleAIManager, self.idleElapsed, time, deltaTime, creature)
    return false
  end
  return superIdle(self, time, deltaTime, creature)
end
