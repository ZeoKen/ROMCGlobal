FunctionAstral = class("FunctionAstral")

function FunctionAstral.Me()
  if nil == FunctionAstral.me then
    FunctionAstral.me = FunctionAstral.new()
  end
  return FunctionAstral.me
end

function FunctionAstral:ctor()
  self.effects = {}
end

function FunctionAstral:Launch()
  local curMap = Game.MapManager:GetMapID()
  if curMap ~= 31 then
    return
  end
  EventManager.Me():AddEventListener(ServiceEvent.FuBenCmdSyncPvePassInfoFubenCmd, self.HandleSyncPvePassInfo, self)
  EventManager.Me():AddEventListener(MyselfEvent.MyProfessionChange, self.HandleChangeJob, self)
  FunctionPve.QueryPvePassInfo()
end

function FunctionAstral:Shutdown()
  EventManager.Me():RemoveEventListener(ServiceEvent.FuBenCmdSyncPvePassInfoFubenCmd, self.HandleSyncPvePassInfo, self)
  EventManager.Me():RemoveEventListener(MyselfEvent.MyProfessionChange, self.HandleChangeJob, self)
  self:DestroyPrayedEntranceEffect()
end

function FunctionAstral:HandleSyncPvePassInfo()
  self:CreatePrayedEntranceEffect()
end

function FunctionAstral:HandleChangeJob()
  self:CreatePrayedEntranceEffect()
end

function FunctionAstral:CreatePrayedEntranceEffect()
  local effects = GameConfig.Astral and GameConfig.Astral.TowerEffects
  if effects then
    for groupid, name in pairs(effects) do
      local diffs = PveEntranceProxy.Instance:GetDifficultyData(groupid)
      if diffs and diffs[1] then
        if diffs[1]:IsMyProAstralPrayed() then
          if not self.effects[groupid] then
            local path = EffectMap.Maps[name]
            self.effects[groupid] = Asset_Effect.PlayAtXYZ(path, 0, 0, 0)
          end
        elseif self.effects[groupid] then
          self.effects[groupid]:Destroy()
          self.effects[groupid] = nil
        end
      end
    end
  end
end

function FunctionAstral:DestroyPrayedEntranceEffect()
  TableUtility.TableClearByDeleter(self.effects, function(effect)
    effect:Destroy()
  end)
end
