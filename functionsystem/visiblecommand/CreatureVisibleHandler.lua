CreatureVisibleHandler = reusableClass("CreatureVisibleHandler")
CreatureVisibleHandler.PoolSize = 100
LayerChangeReason = {
  HidingSkill = 999999,
  CJ = 999998,
  CarrierWaiting = 999997,
  SceneSeat = 999996,
  DoubleAction = 999995,
  OnStageWaitting = 999994,
  Plot = 999993,
  InteractNpc = 999992,
  Mount = 999991,
  Lock = 999990,
  LowFPS = 999989,
  GmObserver = 999988,
  HideBodyOnly = 999987
}

function CreatureVisibleHandler:ctor()
  CreatureVisibleHandler.super.ctor(self)
  self.reason = {}
end

function CreatureVisibleHandler:HasReason()
  for k, v in pairs(self.reason) do
    return true
  end
  return false
end

function CreatureVisibleHandler:Visible(creature, v, reason)
  if v then
    self.reason[reason] = nil
    if not self:HasReason() then
      if reason == LayerChangeReason.HideBodyOnly then
        creature.assetRole:SetHideBodyOnly(false)
      end
      creature.assetRole:SetInvisible(false)
      if creature.data and not creature.data:ForbidClientClient() then
        creature:SetClickable(true)
      end
    end
  else
    self.reason[reason] = reason
    if reason == LayerChangeReason.HideBodyOnly then
      creature.assetRole:SetHideBodyOnly(true)
    end
    creature.assetRole:SetInvisible(true)
    if creature.data then
      creature:SetClickable(false)
    end
  end
end

function CreatureVisibleHandler:DoConstruct(asArray, creatureID)
end

function CreatureVisibleHandler:DoDeconstruct(asArray)
  TableUtility.TableClear(self.reason)
end
