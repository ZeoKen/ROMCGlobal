autoImport("TaskQuestCell_SpaceDragon")
MainViewAbyssDragonPage = class("MainViewAbyssDragonPage", SubView)

function MainViewAbyssDragonPage:Init()
  self:InitView()
  self:FindObjs()
  self:AddListenEvts()
end

function MainViewAbyssDragonPage:InitView()
  local parent = self:FindGO("RaidPageRoot")
  local traceInfoBoard = self:FindGO("TraceInfoBord")
  traceInfoBoard:SetActive(false)
  self:ReLoadPerferb("view/MainViewAbyssDragonRaidPage")
  self.trans:SetParent(parent.transform, false)
  local parentPanel = Game.GameObjectUtil:FindCompInParents(parent, UIPanel)
  if parentPanel then
    local panel = self.gameObject:GetComponent(UIPanel)
    panel.depth = parentPanel.depth + 1
  end
end

function MainViewAbyssDragonPage:FindObjs()
  local go = self:FindGO("TaskQuestCell_SpaceDragon")
  self.spaceDragonCell = TaskQuestCell_SpaceDragon.new(go)
end

function MainViewAbyssDragonPage:AddListenEvts()
  self:AddListenEvt(ServiceEvent.RaidCmdAbyssDragonHpUpdateRaidCmd, self.RefreshHp)
  self:AddListenEvt(ServiceEvent.NUserVarUpdate, self.HandleVarUpdate)
end

function MainViewAbyssDragonPage:RefreshView()
  local data = AbyssFakeDragonProxy.Instance:GetDragonInfos()
  self.spaceDragonCell:SetData(data)
end

function MainViewAbyssDragonPage:RefreshHp()
  if self.spaceDragonCell then
    self.spaceDragonCell:UpdateHp()
  end
end

function MainViewAbyssDragonPage:HandleVarUpdate()
  if self.spaceDragonCell then
    self.spaceDragonCell:SetRewardGrid()
  end
end

function MainViewAbyssDragonPage:OnExit()
  if self.spaceDragonCell then
    self.spaceDragonCell:OnExit()
    self.spaceDragonCell = nil
  end
end
