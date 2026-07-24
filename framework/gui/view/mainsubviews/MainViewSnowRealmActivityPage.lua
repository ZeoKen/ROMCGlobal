autoImport("TaskQuestCell_JojoParty")
autoImport("AbyssDragonRankCell")
MainViewSnowRealmActivityPage = class("MainViewSnowRealmActivityPage", SubMediatorView)

function MainViewSnowRealmActivityPage:Init()
  self:InitView()
  self:FindObjs()
  self:AddListenEvts()
end

function MainViewSnowRealmActivityPage:InitView()
  local parent = self:FindGO("RaidPageRoot")
  self:ReLoadPerferb("view/MainViewSnowRealmActivityPage")
  self.trans:SetParent(parent.transform, false)
  local parentPanel = Game.GameObjectUtil:FindCompInParents(parent, UIPanel)
  if parentPanel then
    self.panel = self.gameObject:GetComponent(UIPanel)
    self.panel.depth = parentPanel.depth - 2
  end
end

function MainViewSnowRealmActivityPage:FindObjs()
  local go = self:FindGO("TaskQuestCell_JojoParty")
  self.taskQuestCell = TaskQuestCell_JojoParty.new(go)
  if self.panel then
    self.taskQuestCell:SetPanelDepth(self.panel.depth)
  end
  self.rankGO = self:FindGO("Rank")
  self.rankCells = {}
  for i = 1, 3 do
    local go = self:FindGO("RankCell" .. i)
    self.rankCells[i] = AbyssDragonRankCell.new(go)
  end
end

function MainViewSnowRealmActivityPage:AddListenEvts()
  self:AddListenEvt(ServiceEvent.FuBenCmdSnowRealmPartySyncFubenCmd, self.RefreshView)
  self:AddListenEvt(ServiceEvent.FuBenCmdSnowRealmDamageRankSyncFubenCmd, self.RefreshRank)
  self:AddListenEvt(ServiceEvent.NUserNpcDataSync, self.HandleBossNpcDataSync)
  self:AddListenEvt(SceneCreatureEvent.PropHpChange, self.HandleBossHpChange)
  self:AddListenEvt(SceneUserEvent.SceneAddNpcs, self.HandleBossNpcChange)
end

function MainViewSnowRealmActivityPage:RefreshView()
  if self.taskQuestCell then
    self.taskQuestCell:SetData(SnowRealmActivityProxy.Instance:GetActivityInfo())
  end
  self:RefreshRank()
end

function MainViewSnowRealmActivityPage:HandleBossHpChange(note)
  local creature = note.body
  if self.taskQuestCell and creature and creature.data then
    self.taskQuestCell:UpdateBossHp(creature.data.id)
  end
end

function MainViewSnowRealmActivityPage:HandleBossNpcDataSync(note)
  local data = note.body
  if self.taskQuestCell and data then
    self.taskQuestCell:UpdateBossHp(data.guid)
  end
end

function MainViewSnowRealmActivityPage:HandleBossNpcChange(note)
  local npcs = note.body
  if not self.taskQuestCell or not npcs then
    return
  end
  local bossGuid = SnowRealmActivityProxy.Instance:GetBossGuid()
  for i = 1, #npcs do
    local npc = npcs[i]
    if npc and npc.data and npc.data.id == bossGuid then
      self.taskQuestCell:UpdateBossHp(bossGuid)
      return
    end
  end
end

function MainViewSnowRealmActivityPage:RefreshRank()
  local ranks = SnowRealmActivityProxy.Instance:GetDamageRanks()
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

function MainViewSnowRealmActivityPage:OnEnter()
  MainViewSnowRealmActivityPage.super.OnEnter(self)
  self:RefreshView()
end

function MainViewSnowRealmActivityPage:OnExit()
  if self.taskQuestCell then
    self.taskQuestCell:OnExit()
    self.taskQuestCell = nil
  end
  MainViewSnowRealmActivityPage.super.OnExit(self)
end
