InteractLocalSimple = class("InteractLocalSimple", InteractBase)
local updateInterval = 1
local VectorDistanceXZ = VectorUtility.DistanceXZ_Square
local VectorDistanceXYZ = VectorUtility.DistanceXYZ_Square
local TableClear = TableUtility.TableClear

function InteractLocalSimple.Create(data, id)
  local args = InteractBase.GetArgs(data, id)
  return ReusableObject.Create(InteractLocalSimple, false, args)
end

function InteractLocalSimple:DoConstruct(asArray, data)
  InteractLocalSimple.super.DoConstruct(self, asArray, data)
  self.interactTimes = 0
  self.nextUpdateTime = 0
  self.needCheckTrigger = not self:IsAuto()
  if self.needCheckTrigger then
    self.triggerCheckRange = self.staticData.Range
  end
end

function InteractLocalSimple:DoDeconstruct(asArray)
  InteractLocalSimple.super.DoDeconstruct(self, asArray)
  self.npc = nil
  self.isInTrigger = nil
  self.interactPrompt = nil
  self.noInteractGroup = nil
  self.actionInstanceId = nil
  self:UnbindGroup()
end

function InteractLocalSimple:CheckPosition(npc)
  local npc_pos = npc and npc:GetPosition()
  return npc_pos ~= nil and InteractNpcManager.CheckMyselfInNpcInteractArea(self.staticData.id) and VectorDistanceXZ(npc_pos, Game.Myself:GetPosition()) < self.triggerCheckRange * self.triggerCheckRange
end

function InteractLocalSimple:Update(time, deltaTime)
  self.isInTrigger = self:_Update(time, deltaTime)
  return self.isInTrigger
end

function InteractLocalSimple:_Update(time, deltaTime)
  if not self.id then
    return false
  end
  if self:CheckLockCondition() == false then
    return false
  end
  if not self.noInteractGroup and (self.interactGroup == nil or not self.interactGroup:IsActive()) then
    return false
  end
  if self.groupConfig and self.groupConfig.max_interact_times and self.interactTimes >= self.groupConfig.max_interact_times then
    return false
  end
  local npc
  if time < self.nextUpdateTime then
    return self.isInTrigger
  end
  self.nextUpdateTime = time + updateInterval
  if self.needCheckTrigger == false then
    return false
  end
  if not self.triggerCheckRange then
    return false
  end
  npc = self:GetNpc()
  if npc == nil then
    return false
  end
  return self:CheckPosition(npc)
end

function InteractLocalSimple:BindGroup(group)
  self.interactGroup = group
  self.groupAction = group.config
  self.groupConfig = group.config
end

function InteractLocalSimple:UnbindGroup()
  self.interactGroup = nil
  self.groupAction = nil
  self.groupConfig = nil
end

function InteractLocalSimple:GetNpc()
  if not (self.npc and self.npc.data) or self.npc.data.staticData.id ~= self.staticData.id or self.npc.data.id ~= self.id and self.npc.data.uniqueid ~= self.id then
  else
    return self.npc
  end
  self.npc = NSceneNpcProxy.Instance:Find(self.id)
  if not self.npc then
    self.npc = NSceneNpcProxy.Instance:FindNpc(self.staticData.id, self.id)
  end
  return self.npc
end

function InteractLocalSimple:RequestGetOffAll()
end

function InteractLocalSimple:StartInteract()
  local interact_freeplot = self.groupAction and self.groupAction.on_act
  if interact_freeplot then
    self:PlayFreePlot(interact_freeplot, self.OnInteractPlotEnd, self)
  else
    self:OnInteractPlotEnd()
  end
end

function InteractLocalSimple:OnInteractPlotEnd()
  self.interactTimes = self.interactTimes + 1
  InteractLocalManager.Me():EndInteract()
end

function InteractLocalSimple:GetDir()
  local npc = self:GetNpc()
  if npc then
    return npc:GetAngleY()
  end
  return 0
end

function InteractLocalSimple:GetIdInGroup()
  return self.id % 100
end

function InteractLocalSimple:PlayFreePlot(plot_id, end_cb, end_cb_args)
  if plot_id then
    local anchorPos, anchorDir = self.interactGroup:_GetPlotAnchorSetting()
    Game.PlotStoryManager:Launch()
    self.actionInstanceId = Game.PlotStoryManager:Start_PQTLP(plot_id, function()
      if end_cb then
        end_cb(end_cb_args)
      end
      self.actionInstanceId = nil
    end, nil, nil, false, nil, {
      myself = self.id,
      player = Game.Myself.data.id
    }, nil, nil, nil, nil, nil, nil, anchorPos, anchorDir)
  end
end

function InteractLocalSimple:ResetInteract()
  self.interactTimes = 0
  local interact_freeplot = self.groupAction and self.groupAction.off_act
  if interact_freeplot then
    self:PlayFreePlot(interact_freeplot)
  end
end

function InteractLocalSimple:GetInteractPrompt()
  if self.interactPrompt then
    return self.interactPrompt
  end
  self.interactPrompt = self.staticData.InteractPrompt
  if self.interactPrompt == nil then
    if self.groupConfig and self.groupConfig.type == "dir" then
      self.interactPrompt = ZhString.InteractLocal_SimpleSpin
    else
      self.interactPrompt = ZhString.InteractLocal_Simple
    end
  end
  return self.interactPrompt
end

function InteractLocalSimple:GetInteractIcon()
end

InteractLocalServerSimple = class("InteractLocalServerSimple", InteractLocalSimple)

function InteractLocalServerSimple:CheckPosition(npc)
  local npc_pos = npc and npc:GetPosition()
  return npc_pos ~= nil and InteractNpcManager.CheckMyselfInNpcInteractArea(self.staticData.id) and VectorDistanceXYZ(npc_pos, Game.Myself:GetPosition()) < self.triggerCheckRange * self.triggerCheckRange
end
