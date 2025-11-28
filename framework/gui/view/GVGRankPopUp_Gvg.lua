local _ToggleConfig = {
  chooseLabColor = LuaColor.New(0.14901960784313725, 0.28627450980392155, 0.615686274509804, 1),
  unChooseLabColor = LuaColor.New(0.20392156862745098, 0.20392156862745098, 0.20392156862745098, 1)
}
local _NewGvgRankCellCell = ResourcePathHelper.UICell("NewGvgRankCell")
local _TexSeasonBg = "sign_21days_bg_title1"
local _SeasonStatusConfig = {
  [GvgProxy.ESeasonType.Leisure] = {
    Bg = "GVG_bg_02",
    HelpID = 35215,
    Content = ZhString.NewGVG_Season_Leisure,
    BgPicColor = LuaColor.New(0.5529411764705883, 0.7647058823529411, 0.41568627450980394, 1)
  },
  [GvgProxy.ESeasonType.Break] = {
    Bg = "GVG_bg_01",
    HelpID = 35216,
    Content = ZhString.NewGVG_Season_Break,
    BgPicColor = LuaColor.New(0.8156862745098039, 0.37254901960784315, 0.40784313725490196, 1)
  },
  [GvgProxy.ESeasonType.Battle] = {
    Bg = "tips_bg_bottom_01",
    BgPicColor = LuaColor.New(0.4117647058823529, 0.5411764705882353, 0.7803921568627451, 1)
  }
}
autoImport("NewGvgRankCell")
autoImport("GvgHistoryRankCell")
GVGRankPopUp_Gvg = class("GVGRankPopUp_Gvg", SubView)

function GVGRankPopUp_Gvg:Init()
  self:InitView()
  self:AddUIEvts()
  self:AddEvts()
end

function GVGRankPopUp_Gvg:InitView()
  self.root = self:FindGO("GvgRoot")
  self.dragScrollView = self:FindComponent("DragScrollView", UIDragScrollView, self.root)
  self.currentRoot = self:FindGO("CurrentRoot", self.root)
  self.myGuildRoot = self:FindGO("MyGuildRoot", self.currentRoot)
  local myGuildLab = self:FindComponent("Label", UILabel, self.myGuildRoot)
  myGuildLab.text = ZhString.NewGvg_MyGuildTitle
  local go = Game.AssetManager_UI:CreateAsset(_NewGvgRankCellCell, self.myGuildRoot)
  go.transform.localPosition = LuaGeometry.Const_V3_zero
  go.name = "MyGuildRank"
  self.myGuildRankCell = NewGvgRankCell.new(go)
  self.myGuildRankCell:UseText()
  self:AddClickEvent(self.myGuildRankCell.bg, function()
    self:OnClickRankCell(self.myGuildRankCell)
  end)
  self.seasonStatusLab = self:FindComponent("SeasonStatusLab", UILabel, self.currentRoot)
  self.seasonStatusHelpBtn = self:FindGO("SeasonHelpBtn", self.seasonStatusLab.gameObject)
  self.searchInput = self:FindComponent("SearchInput", UIInput, self.currentRoot)
  self.searchInput.characterLimit = GameConfig.System.guildname_max
  self.searchBtn = self:FindGO("SearchBtn", self.searchInput.gameObject)
  self.seasonLab = self:FindComponent("SeasonLab", UILabel, self.currentRoot)
  self.seasonBg = self:FindComponent("SeasonBg", UISprite, self.seasonLab.gameObject)
  self.seasonBgPic = self:FindComponent("SeasonBgPic", UISprite, self.seasonLab.gameObject)
  self.seasonBgTex = self:FindComponent("Texture", UITexture, self.seasonLab.gameObject)
  PictureManager.Instance:SetSignIn(_TexSeasonBg, self.seasonBgTex)
  self.fixedLabRoot = self:FindGO("FixedLabRoot")
  local _Fixed_Rank = self:FindComponent("Fixed_Rank", UILabel, self.fixedLabRoot)
  local _Fixed_GuildName = self:FindComponent("Fixed_GuildName", UILabel, self.fixedLabRoot)
  local _Fixed_GuildLeader = self:FindComponent("Fixed_GuildLeader", UILabel, self.fixedLabRoot)
  local _Fixed_TotalPoint = self:FindComponent("Fixed_TotalPoint", UILabel, self.fixedLabRoot)
  local _Fixed_AttackPoint = self:FindComponent("Fixed_AttackPoint", UILabel, self.fixedLabRoot)
  local _Fixed_Line = self:FindComponent("Fixed_Line", UILabel, self.fixedLabRoot)
  if _Fixed_AttackPoint then
    self:Hide(_Fixed_AttackPoint)
  end
  _Fixed_Rank.text = ZhString.NewGvg_Rank_FixedRank
  _Fixed_GuildName.text = ZhString.NewGvg_Rank_FixedGuildName
  _Fixed_GuildLeader.text = ZhString.NewGvg_Rank_FixedGuildLeader
  _Fixed_TotalPoint.text = ZhString.NewGvg_Rank_FixedTotalPoint
  if GvgProxy.Instance:HasMoreGroupZone() then
    _Fixed_Line.text = string.format(ZhString.NewGvg_Rank_FixedLineRange, GvgProxy.Instance:GetClientMaxGroup())
  else
    _Fixed_Line.text = ZhString.NewGvg_Rank_FixedLine
  end
  self.currentSeasonScrollView = self:FindComponent("ScrollView", UIScrollView, self.currentRoot)
  self.rankwrapGo = self:FindGO("Wrap", self.currentSeasonScrollView.gameObject)
  local wraps = {
    wrapObj = self.rankwrapGo,
    pfbNum = 9,
    cellName = "NewGvgRankCell",
    control = NewGvgRankCell
  }
  self.rankWrap = WrapCellHelper.new(wraps)
  self.rankWrap:AddEventListener(MouseEvent.MouseClick, self.OnClickRankCell, self)
  self.historyRoot = self:FindGO("HistoryRoot", self.root)
  self.historyScrollView = self:FindComponent("ScrollView", UIScrollView, self.historyRoot)
  self.historyTable = self:FindComponent("Table", UITable, self.historyScrollView.gameObject)
  self.historyCtl = UIGridListCtrl.new(self.historyTable, GvgHistoryRankCell, "GvgHistoryRankCell")
  self.historyCtl:AddEventListener(GvgHistoryRankCell.ClickArrow, self.ClickHistoryArrow, self)
  self.seasonToggle_currentTog = self:FindComponent("SeasonTog_Current", UIToggle, self.root)
  self.seasonToggle_currentSp = self:FindComponent("Sprite", UISprite, self.seasonToggle_currentTog.gameObject)
  self.seasonToggle_currentLab = self:FindComponent("Label", UILabel, self.seasonToggle_currentTog.gameObject)
  self.seasonToggle_historyTog = self:FindComponent("SeasonTog_History", UIToggle, self.root)
  self.seasonToggle_historySp = self:FindComponent("Sprite", UISprite, self.seasonToggle_historyTog.gameObject)
  self.seasonToggle_historyLab = self:FindComponent("Label", UILabel, self.seasonToggle_historyTog.gameObject)
  self:AddToggleChange(self.seasonToggle_currentTog, self.seasonToggle_currentLab, self.seasonToggle_currentSp, self.UpdateCurrentSeason)
  self:AddToggleChange(self.seasonToggle_historyTog, self.seasonToggle_historyLab, self.seasonToggle_historySp, self.UpdateHistoricalSeason)
end

function GVGRankPopUp_Gvg:ClickHistoryArrow()
  self.historyTable:Reposition()
end

function GVGRankPopUp_Gvg:AddToggleChange(toggle, label, sprite, handler)
  EventDelegate.Add(toggle.onChange, function()
    if toggle.value then
      label.color = _ToggleConfig.chooseLabColor
      sprite.enabled = true
      if handler then
        handler(self)
      end
    else
      label.color = _ToggleConfig.unChooseLabColor
      sprite.enabled = false
    end
  end)
end

function GVGRankPopUp_Gvg:UpdateCurrentSeason()
  self:Show(self.currentRoot)
  self:Hide(self.historyRoot)
  self.seasonLab.text = string.format(ZhString.NewGVG_Season, GvgProxy.Instance:NowSeason())
  self.seasonStatus = GvgProxy.Instance:GetSeasonStatus()
  local seasonStatusCfg = _SeasonStatusConfig[self.seasonStatus]
  TipsView.Me():TryShowGeneralHelpByHelpId(seasonStatusCfg and seasonStatusCfg.HelpID, self.seasonStatusHelpBtn)
  if nil ~= seasonStatusCfg then
    self:Show(self.seasonStatusLab)
    self.seasonBgPic.color = seasonStatusCfg.BgPicColor
    self.seasonBg.spriteName = seasonStatusCfg.Bg
    if GvgProxy.Instance:IsBattleSeason() then
      local battleCount = GvgProxy.Instance:NowBattleCount()
      self.seasonStatusLab.text = string.format(ZhString.NewGVG_Season_Battle, battleCount)
    else
      self.seasonStatusLab.text = seasonStatusCfg.Content
    end
  else
    self:Hide(self.seasonStatusLab)
  end
  self.dragScrollView.scrollView = self.currentSeasonScrollView
  self:_UpdateCurrentSeason()
end

function GVGRankPopUp_Gvg:_UpdateCurrentSeason()
  local data = GvgProxy.Instance:GetGvgCurrentSeasonRankData()
  self.rankWrap:ResetDatas(data, true)
  self.container.emptyRoot:SetActive(#data == 0)
  self.fixedLabRoot:SetActive(0 < #data)
  local myGuildRankData = GvgProxy.Instance:GetMyGuildRank()
  if myGuildRankData then
    self:Show(self.myGuildRoot)
    self.myGuildRankCell:SetData(myGuildRankData)
    self:Hide(self.myGuildRankCell.bg)
  else
    self:Hide(self.myGuildRoot)
  end
end

function GVGRankPopUp_Gvg:UpdateHistoricalSeason()
  self:Hide(self.currentRoot)
  self:Show(self.historyRoot)
  self.dragScrollView.scrollView = self.historyScrollView
  if GvgProxy.Instance:HasHistoryGvgRank() then
    self:_UpdateHistoryData()
  else
    GvgProxy.Instance:DoQueryHistoryGvgRank()
  end
end

function GVGRankPopUp_Gvg:AddUIEvts()
  self:AddClickEvent(self.searchBtn, function()
    local inputValue = self.searchInput.value
    if not StringUtil.IsEmpty(inputValue) then
      GvgProxy.Instance:DoSearchGuildInRankList(inputValue)
    else
      local data = GvgProxy.Instance:GetGvgCurrentSeasonRankData()
      self.rankWrap:ResetDatas(data, true)
      self.container.emptyRoot:SetActive(#data == 0)
      self.fixedLabRoot:SetActive(0 < #data)
    end
  end)
end

function GVGRankPopUp_Gvg:AddEvts()
  self:AddListenEvt(GVGEvent.GVG_SearchGuild, self.HandleSearchGuild)
  self:AddListenEvt(GVGEvent.GVG_SearchGuildTimeOut, self.HandleSearchTimeOut)
  self:AddListenEvt(ServiceEvent.GuildCmdGvgRankHistroyRetGuildCmd, self._UpdateHistoryData)
  self:AddListenEvt(ServiceEvent.GuildCmdGvgRankInfoRetGuildCmd, self._UpdateCurrentSeason)
end

function GVGRankPopUp_Gvg:HandleSearchGuild(note)
  local data = note.body
  if data then
    self.rankWrap:ResetDatas(data, true)
    self.container.emptyRoot:SetActive(#data == 0)
    self.fixedLabRoot:SetActive(0 < #data)
  end
end

function GVGRankPopUp_Gvg:Unload()
  PictureManager.Instance:UnLoadSignIn(_TexSeasonBg, self.seasonBgTex)
end

function GVGRankPopUp_Gvg:HandleSearchTimeOut()
  self.rankWrap:ResetDatas(_EmptyTable)
  self.container.emptyRoot:SetActive(true)
  self.fixedLabRoot:SetActive(false)
end

function GVGRankPopUp_Gvg:OnClickRankCell(cell)
  local data = cell.data
  if data:NoDetailData() then
    return
  end
  local viewdata = {
    view = PanelConfig.GVGWeeklyPointPopUp,
    viewdata = {
      rankData = cell.data
    }
  }
  self:sendNotification(UIEvent.JumpPanel, viewdata)
end

function GVGRankPopUp_Gvg:_UpdateHistoryData()
  self:Show(self.historyCtl)
  local data = GvgProxy.Instance:GetGvgHistoryRankData()
  self.historyCtl:ResetDatas(data, nil, true)
  self.container.emptyRoot:SetActive(#data == 0)
  self.fixedLabRoot:SetActive(0 < #data)
  self.historyScrollView:ResetPosition()
  self.historyTable:Reposition()
end

function GVGRankPopUp_Gvg:OnTabView()
  if self.seasonToggle_currentTog.value then
    self.container.emptyRoot:SetActive(#self.rankWrap:GetDatas() == 0)
  else
    self.container.emptyRoot:SetActive(#GvgProxy.Instance:GetGvgHistoryRankData() == 0)
  end
end
