FactoryAICMD = {}
FactoryAICMD.PlaceToCmd = {
  AI_CMD_PlaceTo
}
FactoryAICMD.MoveToCmd = {
  AI_CMD_MoveTo
}
FactoryAICMD.SetScaleCmd = {
  AI_CMD_SetScale
}
FactoryAICMD.SetAngleYCmd = {
  AI_CMD_SetAngleY
}
FactoryAICMD.PlayActionCmd = {
  AI_CMD_PlayAction
}
FactoryAICMD.HitCmd = {
  AI_CMD_Hit
}
FactoryAICMD.DieCmd = {
  AI_CMD_Die
}
FactoryAICMD.ReviveCmd = {
  AI_CMD_Revive
}
FactoryAICMD.SkillCmd = {
  AI_CMD_Skill
}
FactoryAICMD.GetOnSeatCmd = {
  AI_CMD_GetOnSeat
}
FactoryAICMD.GetOffSeatCmd = {
  AI_CMD_GetOffSeat
}
FactoryAICMD.ActionMoveCmd = {
  AI_CMD_Action_Move
}
FactoryAICMD.ClientPatrolCmd = {
  AI_CMD_ClientPatrol
}
FactoryAICMD.ClientChaseTargetCmd = {
  AI_CMD_ClientChaseTarget
}
FactoryAICMD.ClientAvoidTargetCmd = {
  AI_CMD_ClientAvoidTarget
}
FactoryAICMD.DirMoveCmd = {
  AI_CMD_DirMove
}
FactoryAICMD.DirMoveEndCmd = {
  AI_CMD_DirMoveEnd
}
FactoryAICMD.SpinCmd = {
  AI_CMD_Spin
}
FactoryAICMD.SpinEndCmd = {
  AI_CMD_SpinEnd
}
FactoryAICMD.BreakdownCmd = {
  AI_CMD_Breakdown
}
FactoryAICMD.BreakdownEndCmd = {
  AI_CMD_BreakdownEnd
}
FactoryAICMD.Me_PlaceToCmd = {
  AI_CMD_Myself_PlaceTo
}
FactoryAICMD.Me_MoveToCmd = {
  AI_CMD_Myself_MoveTo
}
FactoryAICMD.Me_DirMoveCmd = {
  AI_CMD_Myself_DirMove
}
FactoryAICMD.Me_DirMoveEndCmd = {
  AI_CMD_Myself_DirMoveEnd
}
FactoryAICMD.Me_SetScaleCmd = {
  AI_CMD_Myself_SetScale
}
FactoryAICMD.Me_SetAngleYCmd = {
  AI_CMD_Myself_SetAngleY
}
FactoryAICMD.Me_AccessCmd = {
  AI_CMD_Myself_Access
}
FactoryAICMD.Me_SkillCmd = {
  AI_CMD_Myself_Skill
}
FactoryAICMD.Me_PlayActionCmd = {
  AI_CMD_Myself_PlayAction
}
FactoryAICMD.Me_PlayHolyActionCmd = {
  AI_CMD_Myself_PlayHolyAction
}
FactoryAICMD.Me_HitCmd = {
  AI_CMD_Myself_Hit
}
FactoryAICMD.Me_DieCmd = {
  AI_CMD_Myself_Die
}
FactoryAICMD.Me_SpinCmd = {
  AI_CMD_Myself_Spin
}
FactoryAICMD.Me_SpinEndCmd = {
  AI_CMD_Myself_SpinEnd
}

function FactoryAICMD.GetPlaceToCmd(pos, ignoreNavMesh)
  local cmd = FactoryAICMD.PlaceToCmd
  cmd[2] = pos
  cmd[3] = ignoreNavMesh
  return cmd
end

function FactoryAICMD.GetMoveToCmd(pos, ignoreNavMesh, endCallback, customMoveActionName)
  local cmd = FactoryAICMD.MoveToCmd
  cmd[2] = pos
  cmd[3] = ignoreNavMesh
  cmd[4] = endCallback
  cmd[5] = customMoveActionName
  return cmd
end

function FactoryAICMD.GetSetScaleCmd(scaleX, scaleY, scaleZ, noSmooth)
  local cmd = FactoryAICMD.SetScaleCmd
  cmd[2] = scaleX
  cmd[3] = scaleY
  cmd[4] = scaleZ
  cmd[5] = noSmooth
  return cmd
end

function FactoryAICMD.GetSetAngleYCmd(mode, arg, noSmooth)
  local cmd = FactoryAICMD.SetAngleYCmd
  cmd[2] = mode
  cmd[3] = arg
  cmd[4] = noSmooth
  return cmd
end

function FactoryAICMD.GetPlayActionCmd(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd, actionSpeed, spExpression, blendContext, ignoreWeapon)
  local cmd = FactoryAICMD.PlayActionCmd
  cmd[2] = name
  cmd[3] = normalizedTime
  cmd[4] = loop
  cmd[5] = fakeDead
  cmd[6] = forceDuration
  cmd[7] = freezeAtEnd
  cmd[8] = actionSpeed
  cmd[9] = spExpression
  cmd[10] = blendContext
  cmd[11] = ignoreWeapon
  return cmd
end

function FactoryAICMD.GetHitCmd(withColorEffect, action, stiff)
  local cmd = FactoryAICMD.HitCmd
  cmd[2] = withColorEffect
  cmd[3] = action
  cmd[4] = stiff
  return cmd
end

function FactoryAICMD.GetSpinCmd(duration, speed)
  local cmd = FactoryAICMD.SpinCmd
  cmd[2] = duration
  cmd[3] = speed
  return cmd
end

function FactoryAICMD.GetDieCmd(noaction)
  local cmd = FactoryAICMD.DieCmd
  cmd[2] = noaction
  return cmd
end

function FactoryAICMD.GetReviveCmd(scale)
  local cmd = FactoryAICMD.ReviveCmd
  return cmd
end

function FactoryAICMD.GetSkillCmd(phaseData, fromCreature)
  local cmd = FactoryAICMD.SkillCmd
  cmd[2] = phaseData
  cmd[3] = fromCreature
  return cmd
end

function FactoryAICMD.GetGetOnSeatCmd(seatID, fromCreature, furn_guid)
  local cmd = FactoryAICMD.GetOnSeatCmd
  cmd[2] = seatID
  cmd[3] = fromCreature
  cmd[4] = furn_guid
  return cmd
end

function FactoryAICMD.GetGetOffSeatCmd(seatID, fromCreature, furn_guid)
  local cmd = FactoryAICMD.GetOffSeatCmd
  cmd[2] = seatID
  cmd[3] = fromCreature
  cmd[4] = furn_guid
  return cmd
end

function FactoryAICMD.GetActionMoveCmd(anime, targetPosition, time, dir, ignoreNavMesh)
  local cmd = FactoryAICMD.ActionMoveCmd
  cmd[2] = dir
  cmd[3] = ignoreNavMesh
  cmd[4] = targetPosition
  cmd[5] = anime
  cmd[6] = time
  return cmd
end

function FactoryAICMD.GetClientPatrolCmd(randomRange, randomSeed, duration, pause_duration, ignoreNavMesh)
  local cmd = FactoryAICMD.ClientPatrolCmd
  cmd[2] = randomRange
  cmd[3] = randomSeed
  cmd[4] = duration
  cmd[5] = pause_duration
  cmd[6] = ignoreNavMesh
  return cmd
end

function FactoryAICMD.GetClientChaseTargetCmd(target, duration, range, moveSpeed)
  local cmd = FactoryAICMD.ClientChaseTargetCmd
  cmd[2] = target
  cmd[3] = duration
  cmd[4] = range
  cmd[5] = moveSpeed
  return cmd
end

function FactoryAICMD.GetClientAvoidTargetCmd(target, duration, range, moveSpeed, rangeRect)
  local cmd = FactoryAICMD.ClientAvoidTargetCmd
  cmd[2] = target
  cmd[3] = duration
  cmd[4] = range
  cmd[5] = moveSpeed
  cmd[6] = rangeRect
  return cmd
end

function FactoryAICMD.GetDirMoveCmd(dir, ignoreNavMesh, customMoveActionName)
  local cmd = FactoryAICMD.DirMoveCmd
  cmd[2] = dir
  cmd[3] = ignoreNavMesh
  cmd[4] = customMoveActionName
  return cmd
end

function FactoryAICMD.GetDirMoveEndCmd(customIdleAction)
  local cmd = FactoryAICMD.DirMoveEndCmd
  cmd[2] = customIdleAction
  return cmd
end

function FactoryAICMD.GetSpinEndCmd()
  local cmd = FactoryAICMD.SpinEndCmd
  return cmd
end

function FactoryAICMD.GetBreakdownCmd(duration, speed)
  local cmd = FactoryAICMD.BreakdownCmd
  cmd[2] = duration
  cmd[3] = speed
  return cmd
end

function FactoryAICMD.GetBreakdownEneCmd()
  local cmd = FactoryAICMD.BreakdownEndCmd
  return cmd
end

function FactoryAICMD.Me_GetPlaceToCmd(pos, ignoreNavMesh)
  local cmd = FactoryAICMD.Me_PlaceToCmd
  cmd[2] = pos
  cmd[3] = ignoreNavMesh
  return cmd
end

function FactoryAICMD.Me_GetMoveToCmd(pos, ignoreNavMesh, callback, callbackOwner, callbackCustom, range, customMoveActionName)
  local cmd = FactoryAICMD.Me_MoveToCmd
  cmd[2] = pos
  cmd[3] = ignoreNavMesh
  cmd[4] = callback
  cmd[5] = callbackOwner
  cmd[6] = callbackCustom
  cmd[7] = range
  cmd[8] = customMoveActionName
  return cmd
end

function FactoryAICMD.Me_GetDirMoveCmd(dir, ignoreNavMesh, customMoveActionName)
  local cmd = FactoryAICMD.Me_DirMoveCmd
  cmd[2] = dir
  cmd[3] = ignoreNavMesh
  cmd[4] = customMoveActionName
  return cmd
end

function FactoryAICMD.Me_GetDirMoveEndCmd(customIdleAction)
  local cmd = FactoryAICMD.Me_DirMoveEndCmd
  cmd[2] = customIdleAction
  return cmd
end

function FactoryAICMD.Me_GetSetScaleCmd(scaleX, scaleY, scaleZ, noSmooth)
  local cmd = FactoryAICMD.Me_SetScaleCmd
  cmd[2] = scaleX
  cmd[3] = scaleY
  cmd[4] = scaleZ
  cmd[5] = noSmooth
  return cmd
end

function FactoryAICMD.Me_GetSetAngleYCmd(mode, arg, noSmooth)
  local cmd = FactoryAICMD.Me_SetAngleYCmd
  cmd[2] = mode
  cmd[3] = arg
  cmd[4] = noSmooth
  return cmd
end

function FactoryAICMD.Me_GetAccessCmd(creature, ignoreNavMesh, accessRange, custom, customDeleter, customType)
  local cmd = FactoryAICMD.Me_AccessCmd
  cmd[2] = creature
  cmd[3] = ignoreNavMesh
  cmd[4] = accessRange or -1
  cmd[5] = custom
  cmd[6] = customDeleter
  cmd[7] = customType
  return cmd
end

function FactoryAICMD.Me_GetSkillCmd(skillID, targetCreature, targetPosition, ignoreNavMesh, forceTargetCreature, allowResearch, noLimit, ignoreCast, isAttackSkill, autoInterrupt, concurrent, ignoreHit, isTriggerSkill, manual, autolock)
  local cmd = FactoryAICMD.Me_SkillCmd
  cmd[2] = skillID
  cmd[3] = targetCreature
  cmd[4] = targetPosition
  cmd[5] = ignoreNavMesh
  cmd[6] = forceTargetCreature
  cmd[7] = allowResearch
  cmd[8] = noLimit
  cmd[9] = ignoreCast
  cmd[10] = isAttackSkill
  cmd[11] = autoInterrupt
  cmd[12] = concurrent
  cmd[14] = ignoreHit
  cmd[15] = isTriggerSkill
  cmd[16] = manual
  cmd[17] = autolock
  return cmd
end

function FactoryAICMD.Me_GetPlayActionCmd(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd, actionSpeed, spExpression, blendContext, ignoreWeapon)
  local cmd = FactoryAICMD.Me_PlayActionCmd
  cmd[2] = name
  cmd[3] = normalizedTime
  cmd[4] = loop
  cmd[5] = fakeDead
  cmd[6] = forceDuration
  cmd[7] = freezeAtEnd
  cmd[8] = actionSpeed
  cmd[9] = spExpression
  cmd[10] = blendContext
  cmd[11] = ignoreWeapon
  return cmd
end

function FactoryAICMD.Me_GetPlayHolyActionCmd(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd, actionSpeed, spExpression)
  local cmd = FactoryAICMD.Me_PlayHolyActionCmd
  cmd[2] = name
  cmd[3] = normalizedTime
  cmd[4] = loop
  cmd[5] = fakeDead
  cmd[6] = forceDuration
  cmd[7] = freezeAtEnd
  cmd[8] = actionSpeed
  cmd[9] = spExpression
  return cmd
end

function FactoryAICMD.Me_GetHitCmd(withColorEffect, action, stiff)
  local cmd = FactoryAICMD.Me_HitCmd
  cmd[2] = withColorEffect
  cmd[3] = action
  cmd[4] = stiff
  return cmd
end

function FactoryAICMD.Me_GetDieCmd(noaction)
  local cmd = FactoryAICMD.Me_DieCmd
  cmd[2] = noaction
  return cmd
end

function FactoryAICMD.Me_GetSpinCmd(duration, speed)
  local cmd = FactoryAICMD.Me_SpinCmd
  cmd[2] = duration
  cmd[3] = speed
  return cmd
end

function FactoryAICMD.Me_GetSpinEndCmd()
  local cmd = FactoryAICMD.Me_SpinEndCmd
  return cmd
end
