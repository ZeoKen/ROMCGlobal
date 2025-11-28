StealthNpcAI = class("StealthNpcAI", ReusableObject)
local _StealthConfig = GameConfig.RaidStealth

function StealthNpcAI:DoConstruct(asArray, id)
  self.id = id
  self.interestPos = LuaVector3.zero
  self.curTarPos = LuaVector3.zero
  self:InitData()
end

function StealthNpcAI:DoDeconstruct()
  self.id = nil
  if self.interestPos then
    self.interestPos:Destroy()
  end
  if self.curTarPos then
    self.curTarPos:Destroy()
  end
end

function StealthNpcAI:InitData()
  self.staticData = Table_StealthNpc[self.id]
  self.staticConfig = Table_StealthNpcConfig[self.staticData.Config]
  self.ai_DelayTime = 0
  self.alertValue = 0
  self.headRotateAnimEnabled = true
  self.isSelfSleeping = false
  self.isSelfKnockdown = false
end

function StealthNpcAI:CreateCreature(pos)
  if self.creature then
    return
  end
  local data = {}
  data.npcID = self.id
  data.id = self.id
  local posX, posY, posZ = 0, 0, 0
  if pos then
    posX = pos.x or posX
    posY = pos.y or posY
    posZ = pos.z or posZ
  end
  data.pos = {
    x = posX,
    y = posY,
    z = posZ
  }
  data.datas = {}
  data.attrs = {}
  data.mounts = {}
  local staticData = Table_Monster[self.id]
  data.staticData = staticData
  data.name = staticData.NameZh
  data.searchrange = 0
  creature = NSceneNpcProxy.Instance:Add(data, NNpc)
  if staticData then
    if staticData.ShowName then
      creature.data.userdata:Set(UDEnum.SHOWNAME, staticData.ShowName)
    end
    if staticData.Scale then
      creature:Server_SetScaleCmd(staticData.Scale, true)
    end
    if staticData.Behaviors then
      creature.data:SetBehaviourData(staticData.Behaviors)
    end
  end
  local noAccessable = creature.data:NoAccessable()
  creature.assetRole:SetColliderEnable(not noAccessable)
  self.creature = creature
  local func_OnNpcBodyLoad = function(assetRole)
    if not self.creature then
      return
    end
    local body = assetRole and assetRole:GetPartObject(Asset_Role.PartIndex.Body)
    if not body then
      return
    end
    self.com_HeadRotateAnim = body:GetComponentInChildren(AI_HeadRotateAnim)
    local com_AISensorManager = body:GetComponent(AISensorManager)
    if not com_AISensorManager then
      LogUtility.Error("Cannot Find AISensorManager From Npc: " .. tostring(self.id))
      return
    end
    
    function com_AISensorManager.onTargetChanged(guid)
      self:LockTargetChange(guid)
    end
  end
  creature.assetRole:SetCallbackOnBodyChanged(func_OnNpcBodyLoad)
  func_OnNpcBodyLoad(creature.assetRole)
end

function StealthNpcAI:RemoveCreature()
  self.creature = nil
  NSceneNpcProxy.Instance:Remove(self.id)
end

function StealthNpcAI:GetActionNameAndDuration(actionCfgName)
  local cfg = _StealthConfig and _StealthConfig.Action and _StealthConfig.Action[actionCfgName]
  if cfg then
    return cfg[1], cfg[2]
  end
end

function StealthNpcAI:GetLoopActionName(actionCfgName)
  return _StealthConfig and _StealthConfig.LoopAction and _StealthConfig.LoopAction[actionCfgName]
end

function StealthNpcAI:LockTargetChange(guid)
  if self.currentTargetGUID == guid then
    return
  end
  local curIsLockMyself = self.isLockMyself
  self.isLockMyself = false
  self.targetStealthNpc = nil
  if guid ~= 0 then
    if guid == Game.Myself.data.id then
      self.currentTarget = Game.Myself
      self.isLockMyself = true
    else
      self.targetStealthNpc = StealthAIManager.Me():GetStealthNpc(guid)
      self.currentTarget = self.targetStealthNpc and self.targetStealthNpc.creature
    end
    if com_HeadRotateAnim then
      com_HeadRotateAnim.lockTarget = self.currentTarget.assetRole:GetCPOrRoot(RoleDefines_CP.Hair)
    end
  else
    if curIsLockMyself and self:IsAlertDanger() then
      self:SetInterestPos(self.currentTarget:GetPosition())
      self:EnableHeadRotateAnim(false)
    end
    self.currentTarget = nil
    if com_HeadRotateAnim then
      com_HeadRotateAnim.lockTarget = nil
    end
  end
  self.currentTargetGUID = guid
end

function StealthNpcAI:EnableHeadRotateAnim(enable)
  if not self.com_HeadRotateAnim or self.headRotateAnimEnabled == enable then
    return
  end
  self.headRotateAnimEnabled = enable ~= false
  self.com_HeadRotateAnim.enabled = self.headRotateAnimEnabled
  if self.headRotateAnimEnabled then
    return
  end
  self.com_HeadRotateAnim:LookHorizontal()
end

function StealthNpcAI:NoiseRecieved(pos, puzzleLevel)
  local puzzleDefLv = self.staticConfig and self.staticConfig.PuzzleDefLv or 1
  if puzzleLevel < puzzleDefLv then
    return
  end
  self:SetInterestPos(pos)
  if self.staticConfig.PuzzleNoticeDis and self.staticConfig.PuzzleNoticeDis > 0 then
    local stealthNpcs = StealthAIManager.Me():FindNearNpcs(pos, self.staticConfig.PuzzleNoticeDis)
    for i = 1, #stealthNpcs do
      stealthNpcs[i]:SetInterestPos(pos, puzzleLevel)
    end
    self:CMD_RotateToInterestPos()
    self:CMD_PlayAction("Notify")
  end
end

function StealthNpcAI:SetInterestPos(pos, interestLv)
  if pos then
    if self.interestLv and interestLv < self.interestLv then
      return
    end
    self.interestPos:Better_Set(pos[1], pos[2], pos[3])
  else
    self.interestPos[1] = -10086
  end
  self.interestLv = interestLv or 0
end

function StealthNpcAI:SetSleeping(value)
  if value == self.isSelfSleeping then
    return
  end
  self.isSelfSleeping = value
  if value then
    self:CMD_PlayLoopAction("Sleep")
  else
    self:CMD_PlayAction("WakeUp")
  end
end

function StealthNpcAI:SetKnockdown(value)
  if value == self.isSelfKnockdown then
    return
  end
  self.isSelfKnockdown = value
  if value then
    self:CMD_PlayLoopAction("Knockdown")
  else
    self:CMD_PlayAction("WakeUp")
  end
end

function StealthNpcAI:IsAlertDanger()
  return self.alertValue > (_StealthConfig and _StealthConfig.AlertDangerValue or 10)
end

function StealthNpcAI:IsAlertDiscover()
  return self.alertValue > (_StealthConfig and _StealthConfig.AlertDiscoverValue or 10)
end

function StealthNpcAI:GetInterestPos()
  if self.currentTarget then
    return self.currentTarget:GetPosition()
  end
  if interestPos[1] ~= -10086 then
    return self.interestPos
  end
end

function StealthNpcAI:IsSleeping()
  return self.isSelfSleeping
end

function StealthNpcAI:IsKnockdown()
  return self.isSelfKnockdown
end

function StealthNpcAI:CMD_PlayAction(actionCfgName)
  if not self.creature then
    return
  end
  local action, duration = self:GetActionNameAndDuration(actionCfgName)
  if not action then
    return
  end
  self.creature:Server_PlayActionCmd(action)
  self:CMD_AddAIDelay(duration)
end

function StealthNpcAI:CMD_PlayLoopAction(actionCfgName)
  if not self.creature then
    return
  end
  local action = self:GetLoopActionName(actionCfgName)
  if not action then
    return
  end
  self.creature:Server_PlayActionCmd(action)
end

function StealthNpcAI:CMD_RotateToInterestPos()
  if not self.creature then
    return
  end
  local interestPos = self:GetInterestPos()
  if not interestPos then
    return
  end
  self.creature.logicTransform:RotateTo(interestPos)
end

function StealthNpcAI:CMD_AddAIDelay(delay)
  self.ai_DelayTime = self.ai_DelayTime + duration
end

function StealthNpcAI:Update(time, deltaTime)
  self:UpdateData(time, deltaTime)
  self:UpdateBehaviour(time, deltaTime)
end

function StealthNpcAI:UpdateData(time, deltaTime)
  local curIsDanger = self:IsAlertDanger()
  if self.isLockMyself then
    if not (self.staticConfig and self.creature and self.currentTarget) or self:IsAlertDiscover() then
      return
    end
    local distance = LuaVector3.Distance(self.creature:GetPosition(), self.currentTarget:GetPosition())
    local disRatio = 1 - NumberUtility.Clamp01(distance / self.staticConfig.AlertFarDis)
    local alertSpeed = disRatio * (self.staticConfig.AlertNearSpeed - self.staticConfig.AlertFarSpeed)
    self.alertValue = self.alertValue + alertSpeed * deltaTime
    if self:IsAlertDiscover() then
      self:AlertModeChange()
      return
    end
  elseif _StealthConfig and self.alertValue > 0 then
    local alertSpeed = curIsDanger and _StealthConfig.AlertReduceSpeed_Danger or _StealthConfig.AlertReduceSpeed_Normal
    self.alertValue = self.alertValue - alertSpeed * deltaTime
    if self.alertValue < 0 then
      self.alertValue = 0
      self:AlertValueClear()
    end
  end
  if curIsDanger ~= self:IsAlertDanger() then
    self:AlertModeChange()
  end
end

function StealthNpcAI:AlertModeChange()
  if not self:IsAlertDanger() then
    self:EnableHeadRotateAnim(true)
  end
end

function StealthNpcAI:AlertValueClear()
end

function StealthNpcAI:UpdateBehaviour(time, deltaTime)
  if self:IsSleeping() or self:IsKnockdown() then
    return
  end
  if self.ai_DelayTime > 0 then
    self.ai_DelayTime = self.ai_DelayTime - deltaTime
    return
  end
  if not self.creature then
    return
  end
  if self:GetInterestPos() then
    self:Behavior_MoveToInterestPos()
  elseif self:IsAlertDanger() then
  elseif 0 < self.alertValue then
  else
    self:Behavior_Patrol()
  end
end

function StealthNpcAI:Behavior_MoveToInterestPos()
  local interestPos = self:GetInterestPos()
  if LuaVector3.Distance_Square(interestPos, self.creature:GetPosition()) < 1 then
    self:MoveToArrived()
    return
  end
  if self.creature:IsMoving() and VectorUtility.AlmostEqual_3(self.curTarPos, interestPos) then
    return
  end
  self.creature:Server_MoveToCmd(interestPos)
  self.curTarPos:Better_SetPos(interestPos)
end

function StealthNpcAI:MoveToArrived()
  self.creature:Server_SetPosCmd(self.creature:GetPosition())
  if self.currentTarget then
    if self.isLockMyself then
      return
    elseif self.targetStealthNpc and self.targetStealthNpc:IsKnockdown() then
      self.targetStealthNpc:SetKnockdown(false)
      self:CMD_PlayAction("WakeOther")
    else
      AISensorManager.RemoveInterestTarget(self.currentTarget.assetRole.completeTransform)
      self:LockTargetChange(0)
      self:CMD_AddAIDelay(self.staticConfig.PuzzleWaitTime)
    end
  else
    self:EnableHeadRotateAnim(true)
    if self:IsAlertDanger() then
      self:CMD_AddAIDelay(self.staticConfig.AlertPatrolWaitTime)
    else
    end
  end
end

function StealthNpcAI:Behavior_Patrol()
end
