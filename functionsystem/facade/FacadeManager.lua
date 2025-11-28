FacadeManager = class("FacadeManager")
local LimitEvent = {
  [ServiceEvent.SceneGoToUserCmd] = 1,
  [ServiceEvent.NUserUserNineSyncCmd] = 1,
  [UIMenuEvent.UnlockMenu] = 1,
  [ServiceEvent.QuestQuestList] = 1,
  [MyselfEvent.SyncBuffs] = 1,
  [MyselfEvent.AddBuffs] = 1,
  [MyselfEvent.RemoveBuffs] = 1
}

function FacadeManager:ctor()
  self.events = {}
  self.gameFacade = GameFacade.Instance
end

function FacadeManager:Update(time, deltaTime)
  for k, v in pairs(self.events) do
    self.gameFacade:sendNotification(k)
    self.events[k] = nil
  end
end

function FacadeManager:Notify(event)
  if LimitEvent[event] == nil then
    return false
  end
  self.events[event] = 1
  return true
end
