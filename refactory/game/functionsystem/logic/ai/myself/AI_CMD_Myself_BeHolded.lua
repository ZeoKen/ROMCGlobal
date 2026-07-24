AI_CMD_Myself_BeHolded = {}
local HoldCP = RoleDefines_CP.RightHand
local FindCreature = SceneCreatureProxy.FindCreature

function AI_CMD_Myself_BeHolded:Construct(args)
  self.args[1] = args[2]
  return 1
end

function AI_CMD_Myself_BeHolded:Deconstruct()
  self.args[1] = nil
end

local _GetCarryDownCharid = function(creature)
  local data = creature and creature.data
  local ud = data and data.userdata
  if not ud then
    return 0
  end
  return ud:Get(UDEnum.CARRY_DOWN_CHARID) or 0
end

function AI_CMD_Myself_BeHolded:Start(time, deltaTime, creature)
  local masterGUID = self.args[1] or 0
  if masterGUID == 0 or _GetCarryDownCharid(creature) == 0 then
    return false
  end
  local master = FindCreature(masterGUID)
  if master == nil or master.assetRole == nil then
    self:SetKeepAlive(true)
    return false
  end
  local holdCPTransform = master.assetRole:GetCP(HoldCP)
  if holdCPTransform == nil then
    self:SetKeepAlive(true)
    return false
  end
  local data = creature.data
  creature:SetParent(holdCPTransform)
  if creature.assetRole ~= nil then
    creature.assetRole:SetShadowEnable(false)
    local offset = data and data:GetHoldOffset()
    if offset == nil then
      offset = LuaVector3.Zero()
    end
    creature.assetRole:SetPosition(offset)
  end
  local holdScale = master.ai and master.ai.idleAI_BeHolded and master.ai.idleAI_BeHolded.scale or data and data:GetHoldScale() or 0.5
  creature.logicTransform:ScaleTo(holdScale)
  creature.logicTransform:SetTargetAngleY(data and data:GetHoldDir() or 0)
  creature.logicTransform:SetAngleX(data and data:GetHoldDirX() or 0)
  creature:BeHolded()
  return true
end

function AI_CMD_Myself_BeHolded:Update(time, deltaTime, creature)
  if _GetCarryDownCharid(creature) == 0 or FindCreature(self.args[1]) == nil then
    self:End(time, deltaTime, creature)
    return
  end
end

function AI_CMD_Myself_BeHolded:End(time, deltaTime, creature)
  creature:Logic_SamplePosition(0)
  creature:SetParent(nil)
  if creature.assetRole ~= nil then
    creature.assetRole:SetShadowEnable(true)
  end
  creature.logicTransform:ScaleToXYZ(creature:GetScaleWithFixHW())
  creature:ClearBeHolded()
  creature.beHoldedCmdPushed = false
end

function AI_CMD_Myself_BeHolded.ToString()
  return "AI_CMD_Myself_BeHolded", AI_CMD_Myself_BeHolded
end
