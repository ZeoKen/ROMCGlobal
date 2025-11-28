autoImport("EndlessBattleFieldEventBoardCell")
EndlessBattleFieldEventBoard = class("EndlessBattleFieldEventBoard", SubView)
EndlessBattleFieldEventBoard.MAXCOUNT = 6

function EndlessBattleFieldEventBoard:Init()
  self:InitView()
  self:FindObjs()
end

function EndlessBattleFieldEventBoard:InitView()
  local parent = self:FindGO("MapBord")
  self:ReLoadPerferb("part/EndlessBattleFieldEventBoard")
  self.trans:SetParent(parent.transform, false)
  LuaGameObject.SetLocalPositionObj(self.gameObject, -443, 0, 0)
  local parentPanel = Game.GameObjectUtil:FindCompInParents(parent, UIPanel)
  if parentPanel then
    local panel = self.gameObject:GetComponent(UIPanel)
    panel.depth = parentPanel.depth + 1
    local eventPanel = self:FindComponent("EventPanel", UIPanel)
    eventPanel.depth = panel.depth + 1
  end
end

function EndlessBattleFieldEventBoard:FindObjs()
  local grid = self:FindComponent("Grid", UIGrid)
  self.eventListCtrl = UIGridListCtrl.new(grid, EndlessBattleFieldEventBoardCell, "EndlessBattleFieldEventBoardCell")
  self.eventListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickEventCell, self)
end

function EndlessBattleFieldEventBoard:OnClickEventCell(cell)
  local event_id = cell.data and cell.data.eventData and cell.data.eventData.staticData and cell.data.eventData.staticData.id
  if not event_id then
    return
  end
  EndlessBattleGameProxy.Instance:TryTraceEvent(event_id)
end

function EndlessBattleFieldEventBoard:OnShow()
  TimeTickManager.Me():CreateTick(0, 1000, function()
    self:RefreshView()
  end, self)
end

function EndlessBattleFieldEventBoard:OnHide()
  TimeTickManager.Me():ClearTick(self)
end

function EndlessBattleFieldEventBoard:OnExit()
  TimeTickManager.Me():ClearTick(self)
end

function EndlessBattleFieldEventBoard:RefreshView()
  local events = EndlessBattleFieldProxy.Instance:GetEventList()
  local datas = {}
  local isNextEvent = false
  for i = 1, EndlessBattleFieldEventBoard.MAXCOUNT do
    local data = {
      eventData = events[i]
    }
    data.index = i
    if not events[i] and not isNextEvent then
      isNextEvent = true
      local nextEventTime = EndlessBattleFieldProxy.Instance:GetNextEventTime()
      local nextEventId = EndlessBattleFieldProxy.Instance:GetNextEventId()
      local countdown = math.max(nextEventTime - math.floor(ServerTime.CurServerTime() / 1000), 0)
      data.countdown = countdown
      data.nextEventId = nextEventId
    end
    datas[i] = data
  end
  self.eventListCtrl:ResetDatas(datas)
end
