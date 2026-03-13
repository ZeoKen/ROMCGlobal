autoImport("TaskQuestCell_SpaceDragon")
autoImport("AbyssDragonRankCell")
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
    panel.depth = parentPanel.depth - 1
  end
end

function MainViewAbyssDragonPage:FindObjs()
  local go = self:FindGO("TaskQuestCell_SpaceDragon")
  self.spaceDragonCell = TaskQuestCell_SpaceDragon.new(go)
  self.rankGO = self:FindGO("AbyssDragonRank")
  self.rankCells = {}
  for i = 1, 3 do
    local go = self:FindGO("AbyssDragonRankCell" .. i)
    self.rankCells[i] = AbyssDragonRankCell.new(go)
  end
end

function MainViewAbyssDragonPage:AddListenEvts()
  self:AddListenEvt(ServiceEvent.RaidCmdAbyssDragonHpUpdateRaidCmd, self.RefreshHp)
  self:AddListenEvt(ServiceEvent.NUserVarUpdate, self.HandleVarUpdate)
  self:AddListenEvt(ServiceEvent.RaidCmdAbyssDragonDamageRankRaidCmd, self.RefreshRank)
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

function MainViewAbyssDragonPage:RefreshRank()
  local ranks = AbyssFakeDragonProxy.Instance:GetDamageRank()
  self.rankGO:SetActive(ranks and 0 < #ranks or false)
  if ranks then
    for i = 1, #self.rankCells do
      local cell = self.rankCells[i]
      if ranks[i] then
        cell:Show()
        cell:SetData(ranks[i])
      else
        cell:Hide()
      end
    end
  end
end

function MainViewAbyssDragonPage:HandleVarUpdate()
  if self.spaceDragonCell then
    self.spaceDragonCell:SetRewardGrid()
  end
end

function MainViewAbyssDragonPage:OnEnter()
  self:RefreshRank()
end

function MainViewAbyssDragonPage:OnExit()
  if self.spaceDragonCell then
    self.spaceDragonCell:OnExit()
    self.spaceDragonCell = nil
  end
end
