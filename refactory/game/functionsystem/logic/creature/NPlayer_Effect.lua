local PeakEffectKey = "Peak_Effect"
local GRUOP_EQUIP_EFFECT_KEY = "Group_Effect"
local GetRefineInfo = function(value)
  if value ~= nil then
    return math.floor(value / 100), value % 100
  end
  return 0, 0
end

function NPlayer:PlayBaseLevelUpEffect()
  self:PlayEffect(nil, EffectMap.Maps.RoleLevelUp, 0, nil, false, true)
end

function NPlayer:PlayJobLevelUpEffect()
  self:PlayEffect(nil, EffectMap.Maps.JobLevelUp, 0, nil, false, true)
end

function NPlayer:PlayAdventureLevelUpEffect()
  AudioUtil.Play2DRandomSound(AudioMap.Maps.AdventureLevelUp)
  self:PlayEffect(NPlayer.EffectKey_PlayAdventureLevelUp, EffectMap.Maps.AdventureLv_up, 0, nil, false, true)
  if self:GetCreatureType() == Creature_Type.Me then
    TimeTickManager.Me():CreateOnceDelayTick(5000, function(owner, deltaTime)
      local body = ReusableTable.CreateTable()
      body.view = PanelConfig.AdventureRewardPanel
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, body)
      ReusableTable.DestroyAndClearTable(body)
    end, self)
  end
end

function NPlayer:PlayBaseLevelUpAudio()
  self:PlayAudio(AudioMap.Maps.RoleLevelUp, nil, false)
end

function NPlayer:PlayKilledMVPEffect()
  self:PlayEffect(nil, EffectMap.Maps.MVPKilled, RoleDefines_EP.Top, nil, false, true)
  self:PlayAudio(AudioMap.Maps.KillMvp, RoleDefines_EP.Top, false)
end

function NPlayer:PlayHpUp()
  self:PlayEffect(nil, EffectMap.Maps.HpUp, RoleDefines_EP.Chest, nil, false, true)
end

function NPlayer:PlayTeamCircle(teamEnum)
  self:RemoveEffect("TeamCircle_Effect")
  if 0 < teamEnum then
    local effectMap
    if Game.MapManager:IsGvgMode_Droiyan() then
      effectMap = EffectMap.Maps.SuperGVGTeamCircl
    elseif Game.MapManager:IsPVPMode_TeamPwsOthello() or Game.MapManager:IsPvPMode_TeamTwelve() then
      effectMap = EffectMap.Maps.OthelloTeamCircl
    else
      effectMap = EffectMap.Maps.PVPTeamCircl
    end
    self:PlayEffect("TeamCircle_Effect", effectMap[teamEnum], 0, nil, true, true)
  end
end

function NPlayer:PlayPeakEffect()
  if self:Logic_PeakEffect() then
    local effect = self:GetWeakData(PeakEffectKey)
    if effect == nil then
      self:PlayEffect(PeakEffectKey, EffectMap.Maps.Peak, 0, nil, true, true)
    end
  end
end

function NPlayer:PlayGropEquipEffect(path)
  self:PlayEffect(GRUOP_EQUIP_EFFECT_KEY, path, 0, nil, true, true)
end

function NPlayer:RemoveGroupEffect()
  self:RemoveEffect(GRUOP_EQUIP_EFFECT_KEY)
end

function NPlayer:RemovePeakEffect()
  self:RemoveEffect(PeakEffectKey)
end

function NPlayer:PlayDeathEffect()
  self:PlayEffect(nil, EffectMap.Maps.HumanDead, RoleDefines_EP.Middle, nil, false, false)
end

function NPlayer:PlayChangeJob()
  FunctionSystem.InterruptCreature(self)
  self:_PlayChangeJobBeginEffect()
end

function NPlayer:_PlayChangeJobBeginEffect()
  self._changeJobTimeFlag = UnityTime + 3
  self.assetRole:ChangeColorFromTo(LuaGeometry.Const_Col_whiteClear, LuaGeometry.Const_Col_white, 3)
  local changeJobEffect = self:PlayEffect(nil, EffectMap.Maps.JobChange, 0, nil, false, true)
  self:PlayAudio(AudioMap.Maps.JobChange, 1, false)
  return changeJobEffect
end

function NPlayer:_PlayChangeJobFireEffect()
  self:ReDress()
  FunctionSystem.InterruptCreature(self)
  self.assetRole:ChangeColorFromTo(LuaGeometry.Const_Col_white, LuaGeometry.Const_Col_whiteClear, 0.3)
  local resID = ResourcePathHelper.EffectSpine(EffectMap.Spine.JobChangeHorn)
  if self.sceneui then
    self.sceneui.roleTopUI:PlayTopSpine(resID, "animation")
  end
  self:PlayAudio(AudioMap.Maps.JobChangeHorn, 1, false)
end

function NPlayer:_UpdateEffect(time, deltaTime)
  self:_UpdateTrackEffect(time, deltaTime)
  self:UpdateContractEffect(time, deltaTime)
  if self._changeJobTimeFlag and time >= self._changeJobTimeFlag then
    self._changeJobTimeFlag = nil
    self:_PlayChangeJobFireEffect()
  end
end

function NPlayer:UpdateRefinePerformance(part, oldValue, newValue)
  if oldValue == nil and newValue == 0 then
    return
  end
  local oldItemId, oldRefineLv = GetRefineInfo(oldValue)
  local itemId, refineLv = GetRefineInfo(newValue)
  if oldItemId ~= 0 and 8 <= oldRefineLv then
    self:RemoveRefinePerformance(oldItemId, part)
  end
  if itemId == 0 then
    return
  end
  if 8 <= refineLv then
    self:AddRefinePerformance(itemId, part)
  elseif refineLv < 8 then
    self:RemoveRefinePerformance(itemId, part)
  end
end

function NPlayer:AddRefinePerformance(itemId, part)
  local equip = Table_Equip[itemId]
  if equip == nil then
    return
  end
  local performance = equip.RefinePerformance
  if performance == nil then
    return
  end
  local effect = performance.effect
  if effect ~= nil then
    Game.LogicManager_RolePart:AddRolePartEffect(self.assetRole, part, effect)
  end
  local action = performance.action
  if action ~= nil then
    Game.LogicManager_RolePart:RemoveRolePartForbidAction(self.assetRole, part)
  end
end

function NPlayer:RemoveRefinePerformance(itemId, part)
  local equip = Table_Equip[itemId]
  if equip == nil then
    return
  end
  local performance = equip.RefinePerformance
  if performance == nil then
    return
  end
  local effect = performance.effect
  if effect ~= nil then
    Game.LogicManager_RolePart:RemoveRolePartEffect(self.assetRole, part)
  end
  local action = performance.action
  if action ~= nil then
    action = Table_ActionAnime[action]
    if action ~= nil then
      Game.LogicManager_RolePart:AddRolePartForbidAction(self.assetRole, part, action.Name)
    end
  end
end
