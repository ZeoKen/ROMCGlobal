local _TabTitle = {
  [1] = ZhString.GuildDateBattle_NpcView_TogTitle1,
  [2] = ZhString.GuildDateBattle_NpcView_TogTitle2,
  [3] = ZhString.GuildDateBattle_NpcView_TogTitle3
}
local EmptyTextureName = "new_taskmanual_bg_bottom02"
GuildDateBattleOverview = class("GuildDateBattleOverview", ContainerView)
GuildDateBattleOverview.ViewType = UIViewType.NormalLayer
autoImport("GuildDateBattle_Overview_Result")
autoImport("GuildDateBattle_Overview_Going")
autoImport("GuildDateBattle_Overview_Rank")

function GuildDateBattleOverview:InitToggle()
  local toggleRoot = self:FindGO("ToggleRoot")
  self.togGrid = toggleRoot:GetComponent(UIGrid)
  self.toggles = {}
  for i = 1, 3 do
    local toggleName = "Toggle" .. i
    local toggleObj = self:FindGO(toggleName, toggleRoot)
    self.toggles[#self.toggles + 1] = toggleObj
  end
  self:Hide(self.toggles[3])
end

function GuildDateBattleOverview:Init()
  self:InitToggle()
  self.emptyGO = self:FindGO("EmptyIcon")
  self.emptyTex = self:FindComponent("EmptyTex", UITexture, self.emptyGO)
  PictureManager.Instance:SetUI(EmptyTextureName, self.emptyTex)
  self.emptyLab = self:FindComponent("EmptyLab", UILabel, self.emptyGO)
  self.emptyLab.text = ZhString.Common_Empty
  self.titleTable = self:FindComponent("TitleTable", UITable)
  self.title = self:FindComponent("TitleLab", UILabel, self.titleTable.gameObject)
  local finishedBord = self:FindGO("FinishedBord")
  local goingBord = self:FindGO("GoingBord")
  local rankBord = self:FindGO("RankBord")
  self:AddTabChangeEvent(self.toggles[1], finishedBord, PanelConfig.GuildDateBattle_Overview_Result)
  self:AddTabChangeEvent(self.toggles[2], goingBord, PanelConfig.GuildDateBattle_Overview_Going)
  self:AddTabChangeEvent(self.toggles[3], rankBord, PanelConfig.GuildDateBattle_Overview_Rank)
  self:TabChangeHandler(1)
  self:AddListenEvt(ServiceEvent.GuildCmdDateBattleRankGuildCmd, self.UpdateRank)
end

function GuildDateBattleOverview:OnExit()
  GuildDateBattleOverview.super.OnExit(self)
  PictureManager.Instance:UnLoadUI(EmptyTextureName, self.emptyTex)
end

function GuildDateBattleOverview:TabChangeHandler(key)
  if not GuildDateBattleOverview.super.TabChangeHandler(self, key) then
    return
  end
  local str = _TabTitle[key] or ""
  self.title.text = str
  self.titleTable:Reposition()
  if key == PanelConfig.GuildDateBattle_Overview_Result.tab then
    if not self.resultView then
      self.resultView = self:AddSubView("GuildDateBattle_Overview_Result", GuildDateBattle_Overview_Result)
    end
    self.resultView:UpdateView()
  elseif key == PanelConfig.GuildDateBattle_Overview_Going.tab then
    if not self.goingView then
      self.goingView = self:AddSubView("GuildDateBattle_Overview_Going", GuildDateBattle_Overview_Going)
    end
    self.goingView:UpdateView()
  elseif key == PanelConfig.GuildDateBattle_Overview_Rank.tab then
    if not self.rankView then
      self.rankView = self:AddSubView("GuildDateBattle_Overview_Rank", GuildDateBattle_Overview_Rank)
    end
    self.rankView:UpdateView()
  end
end

function GuildDateBattleOverview:UpdateRank()
  if self.rankView then
    self.rankView:UpdateView()
  end
end
