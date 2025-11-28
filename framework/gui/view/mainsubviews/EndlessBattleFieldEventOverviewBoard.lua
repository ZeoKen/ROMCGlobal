autoImport("EndlessBattleFieldEventOverviewCell")
EndlessBattleFieldEventOverviewBoard = class("EndlessBattleFieldEventOverviewBoard", SubView)

function EndlessBattleFieldEventOverviewBoard:Init()
  self:InitView()
  self:FindObjs()
end

function EndlessBattleFieldEventOverviewBoard:InitView()
  local parent = self:FindGO("OverviewRoot")
  self:ReLoadPerferb("part/EndlessBattleFieldEventOverviewBoard")
  self.trans:SetParent(parent.transform, false)
  LuaGameObject.SetLocalPositionObj(self.gameObject, 0, 0, 0)
  local parentPanel = Game.GameObjectUtil:FindCompInParents(parent, UIPanel)
  if parentPanel then
    local panel = self.gameObject:GetComponent(UIPanel)
    panel.depth = parentPanel.depth + 1
  end
end

function EndlessBattleFieldEventOverviewBoard:FindObjs()
  local grid = self:FindComponent("Grid", UIGrid)
  self.eventListCtrl = UIGridListCtrl.new(grid, EndlessBattleFieldEventOverviewCell, "EndlessBattleFieldEventOverviewCell")
end

function EndlessBattleFieldEventOverviewBoard:RefreshView()
  local events = EndlessBattleFieldProxy.Instance:GetEventList()
  self.eventListCtrl:ResetDatas(events)
end
