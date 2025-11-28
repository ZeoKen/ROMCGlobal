AI_CMD_PlayAction = {}
local addSpEffectData = {
  id = 4,
  guid = 1,
  entity = nil
}
local removeSpEffectData = {
  id = 4,
  guid = 1,
  entity = nil
}
local waitForActionCmdArray = {}
local CmdFindPredicate = function(cmd, cmdInstanceID)
  return cmd.instanceID == cmdInstanceID
end
local OnActionFinished = function(creatureGUID, cmdInstanceID)
  local cmd, i = TableUtility.ArrayFindByPredicate(waitForActionCmdArray, CmdFindPredicate, cmdInstanceID)
  if nil ~= cmd then
    if cmd.args[6] == true then
      local params = Asset_Role.GetPlayActionParams(cmd.args[1], nil, 0)
      params[4] = 1
      params[6] = true
      params[12] = true
      local creature = SceneCreatureProxy.FindCreature(creatureGUID) or cmd.creature
      if creature then
        creature:Logic_PlayAction(params)
      else
        redlog("freeze to current action end", "creature not found", creatureGUID)
        cmd.args[10] = false
      end
    else
      cmd.args[10] = false
    end
  end
end

function AI_CMD_PlayAction:ResetArgs(args)
  self.args[1] = args[2]
  self.args[2] = args[3]
  self.args[3] = args[4]
  self.args[4] = args[5]
  self.args[5] = args[6]
  self.args[6] = args[7]
  self.args[7] = args[8]
  self.args[8] = args[9]
  self.args[9] = args[10]
  self.args[14] = args[11]
end

function AI_CMD_PlayAction:Construct(args)
  self.args[1] = args[2]
  self.args[2] = args[3]
  self.args[3] = args[4]
  self.args[4] = args[5]
  self.args[5] = args[6]
  self.args[6] = args[7]
  self.args[7] = args[8]
  self.args[8] = args[9]
  self.args[9] = args[10]
  self.args[14] = args[11]
  return 10
end

function AI_CMD_PlayAction:Deconstruct()
  self.creature = nil
end

function AI_CMD_PlayAction:Start(time, deltaTime, creature)
  if self.args[1] == nil then
    return
  end
  if creature.data:NoAction() then
    return
  end
  self.args[11] = nil
  self.args[12] = nil
  self.args[13] = nil
  self.creature = creature
  local assetRole = creature.assetRole
  local hasAction = assetRole:HasActionRaw(self.args[1])
  hasAction = hasAction or assetRole:_IsLoading() or not creature:IsDressed()
  local params = Asset_Role.GetPlayActionParams(self.args[1])
  if self.args[7] then
    params[3] = self.args[7]
  end
  if nil ~= self.args[2] then
    params[4] = self.args[2]
  end
  if nil ~= self.args[3] then
    params[5] = self.args[3]
  end
  if self.args[5] and self.args[5] > 0 then
    params[11] = self.args[5]
  end
  if self.args[8] ~= nil then
    params[12] = self.args[8]
  end
  if self.args[9] ~= nil then
    params[15] = self.args[9]
  end
  params[18] = self.args[14]
  if (nil == self.args[2] or 1 > self.args[2]) and not self.args[3] then
    params[6] = true
    if hasAction then
      params[7] = OnActionFinished
      params[8] = self.instanceID
      self.args[10] = creature:Logic_PlayAction(params)
      if self.args[10] then
        TableUtility.ArrayPushBack(waitForActionCmdArray, self)
      end
    else
      creature:Logic_PlayAction(params)
    end
  else
    creature:Logic_PlayAction(params, self.args[4])
    if Game.Config_Action[self.args[1]] and 1 == Game.Config_Action[self.args[1]].Condition then
      self.args[11] = true
    end
  end
  Asset_Role.ClearPlayActionParams(params)
  if "sit_down" == self.args[1] and creature:AllowSpEffect_OnFloor() then
    self.args[12] = self.instanceID
    addSpEffectData.guid = self.instanceID
    creature:Server_AddSpEffect(addSpEffectData)
  end
  if self.args[5] and self.args[5] > 0 then
    self.args[13] = 0
    return true
  end
  return hasAction or self.args[3] or self.args[4] or self.args[11]
end

function AI_CMD_PlayAction:End(time, deltaTime, creature)
  if not self.args[3] then
    TableUtility.ArrayRemove(waitForActionCmdArray, self)
  end
  if nil ~= self.args[12] then
    removeSpEffectData.guid = self.args[12]
    creature:Server_RemoveSpEffect(removeSpEffectData)
    self.args[12] = nil
  end
end

function AI_CMD_PlayAction:Update(time, deltaTime, creature)
  local args = self.args
  if nil ~= args[5] and args[5] > 0 then
    args[13] = args[13] + deltaTime
    if args[13] > args[5] then
      self:End(time, deltaTime, creature)
    end
  elseif (nil == args[2] or args[2] < 1) and not args[3] and not args[10] then
    self:End(time, deltaTime, creature)
  elseif args[4] and not creature:IsFakeDead() then
    self:End(time, deltaTime, creature)
  elseif args[11] and not creature:IsOnSceneSeat() then
    self:End(time, deltaTime, creature)
  end
end

function AI_CMD_PlayAction.ToString()
  return "AI_CMD_PlayAction", AI_CMD_PlayAction
end
