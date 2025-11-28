EndlessBattleFieldEventProgressCell = class("EndlessBattleFieldEventProgressCell", BaseCell)

function EndlessBattleFieldEventProgressCell:ctor(parent)
  local go = self:LoadPrefab(parent)
  EndlessBattleFieldEventProgressCell.super.ctor(self, go)
end

function EndlessBattleFieldEventProgressCell:Init()
  self:FindObjs()
  self:Refresh()
end

function EndlessBattleFieldEventProgressCell:LoadPrefab(parent)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("EndlessBattleFieldEventProgressCell"))
  if not cellpfb then
    error("can not find EndlessBattleFieldEventProgressCell")
    return
  end
  cellpfb.transform:SetParent(parent.transform, false)
  LuaGameObject.SetLocalPositionObj(cellpfb, 0, 0, 0)
  return cellpfb
end

function EndlessBattleFieldEventProgressCell:FindObjs()
  self.countdownLabel = self.gameObject:GetComponent(UILabel)
end

function EndlessBattleFieldEventProgressCell:Refresh()
  local nextEventTime = EndlessBattleFieldProxy.Instance:GetNextEventTime()
  if self.nextEventTime ~= nextEventTime then
    self.nextEventTime = nextEventTime
    self:ClearTimeTick()
    local events = EndlessBattleFieldProxy.Instance:GetEventList()
    self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, function()
      local nextEventId = EndlessBattleFieldProxy.Instance:GetNextEventId()
      local config = Table_EndlessBattleFieldEvent[nextEventId]
      local eventName = config and config.Name
      local countdown = math.max(nextEventTime - math.floor(ServerTime.CurServerTime() / 1000), 0)
      if eventName then
        self.countdownLabel.text = string.format(ZhString.EndlessBattleEvent_StartEventCountdown, countdown, eventName, math.min(#events + 1, 6), 6)
      else
        self.countdownLabel.text = string.format(ZhString.EndlessBattleEvent_StartEventCountdownSimple, countdown, math.min(#events + 1, 6), 6)
      end
      if countdown == 0 then
        self:Refresh()
      end
    end, self)
  end
end

function EndlessBattleFieldEventProgressCell:ClearTimeTick()
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self)
    self.timeTick = nil
  end
end

function EndlessBattleFieldEventProgressCell:Destroy()
  self:ClearTimeTick()
end
