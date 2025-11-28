autoImport("GVGStatView")
autoImport("GVGBlessStatCell")
autoImport("GVGStatCell")
GuildDateBattlefieldReport = class("GuildDateBattlefieldReport", GVGStatView)
GuildDateBattlefieldReport.ViewType = UIViewType.PopUpLayer
local GvgStatkeyStr = {
  [1] = ZhString.GVGStat_Kill,
  [2] = ZhString.GVGStat_Assist,
  [3] = ZhString.GVGStat_Death,
  [4] = ZhString.GVGStat_Relive,
  [5] = ZhString.GVGStat_Expel,
  [6] = ZhString.GVGStat_Damage,
  [7] = ZhString.GVGStat_Heal,
  [8] = ZhString.GVGStat_Occupy,
  [9] = ZhString.GVGStat_OccupyTime,
  [10] = ZhString.GVGStat_MetalDamage
}
local ArrowText = "↓"
local _PictureManager, _DateProxy
local _WinTextureName = "pvp_bg_win"
local _WinTextureName1 = "pvp_bg_win_blue"
local _LoseTextureName = "pvp_yuezhan_bg_lost"
local _LoseTextureName1 = "pvp_bg_lost"

function GuildDateBattlefieldReport:Init()
  _PictureManager = PictureManager.Instance
  _DateProxy = GuildDateBattleProxy.Instance
  self.isMyGuild = true
  self:AddListenEvt(ServiceEvent.GuildCmdDateBattleDetailGuildCmd, self.OnQueryStatCmd)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:InitData()
  self:FindObjs()
  self:SetDate()
  self:UpdateTitle()
  self:UpdateMyGuildOrEnemy()
end

function GuildDateBattlefieldReport:SetDate()
  local cur_time = ServerTime.CurServerTime() / 1000
  self.dateLab.text = ClientTimeUtil.FormatTimeTick(cur_time)
end

function GuildDateBattlefieldReport:QueryStat()
end

function GuildDateBattlefieldReport:FindObjs()
  GuildDateBattlefieldReport.super.FindObjs(self)
  self.winTexture = self:FindComponent("WinTexture", UITexture)
  self.winTexture1 = self:FindComponent("WinTexture_1", UITexture, self.winTexture.gameObject)
  self.winLab = self:FindComponent("WinnerLabel", UILabel, self.winTexture.gameObject)
  self.winLab1 = self:FindComponent("Label", UILabel, self.winLab.gameObject)
  self.winLab.text = ZhString.GuildDateBattle_State_Win
  self.winLab1.text = ZhString.GuildDateBattle_State_Win
  self.loseTexture = self:FindComponent("LoseTexture", UITexture)
  self.loseLabel = self:FindComponent("LoseLabel", UILabel, self.loseTexture.gameObject)
  self.loseLabel1 = self:FindComponent("Label", UILabel, self.loseLabel.gameObject)
  self.loseLabel.text = ZhString.GuildDateBattle_State_Failed
  self.loseLabel1.text = ZhString.GuildDateBattle_State_Failed
  self.loseTexture1 = self:FindComponent("LoseTexture_1", UITexture, self.loseTexture.gameObject)
  _PictureManager:SetPVP(_WinTextureName, self.winTexture)
  _PictureManager:SetPVP(_WinTextureName1, self.winTexture1)
  _PictureManager:SetPVP(_LoseTextureName, self.loseTexture)
  _PictureManager:SetPVP(_LoseTextureName1, self.loseTexture1)
  self.myselfDataBg = self:FindGO("MyselfDataBg")
  self.switchBtn = self:FindGO("SwitchBtn")
  self.titleLab = self:FindComponent("Title", UILabel)
  self:AddClickEvent(self.switchBtn, function()
    self:OnClickSwitchBtn()
  end)
end

function GuildDateBattlefieldReport:OnExit()
  GuildDateBattlefieldReport.super.OnExit(self)
  _PictureManager:UnLoadPVP(_WinTextureName, self.winTexture)
  _PictureManager:UnLoadPVP(_WinTextureName1, self.winTexture1)
  _PictureManager:UnLoadPVP(_LoseTextureName, self.loseTexture)
  _PictureManager:UnLoadPVP(_LoseTextureName1, self.loseTexture1)
end

function GuildDateBattlefieldReport:OnQueryStatCmd()
  self:HandleUpdate()
end

function GuildDateBattlefieldReport:HandleUpdate()
  self:SetDate()
  _DateProxy:SortResultByKey(GvgStatData.SortableKeys[1], nil, self.isMyGuild)
  self:RefreshView()
end

function GuildDateBattlefieldReport:GetHelpId()
  return PanelConfig.GuildDateBattlefieldReport.id
end

function GuildDateBattlefieldReport:RefreshView()
  local datas = _DateProxy:GetReportDetail(self.isMyGuild)
  datas = datas or _EmptyTable
  self.statCtrl:ResetDatas(datas)
  local array = ReusableTable.CreateArray()
  for i = 1, #datas do
    local data = clone(datas[i])
    array[#array + 1] = data
  end
  self.ownerListCtrl:ResetDatas(array)
  ReusableTable.DestroyArray(array)
  if not datas or #datas == 0 then
    self.emptyGO:SetActive(true)
    self.myselfStatData:SetColider(true)
  else
    self.emptyGO:SetActive(false)
    self.myselfStatData:SetColider(false)
  end
  self:UpdateWinOrLose()
  self:UpdateTitle()
  self:UpdateMyGuildOrEnemy()
end

function GuildDateBattlefieldReport:OnSortBtnClicked(i)
  if self.lastSelectedSortIndex ~= i then
    if self.lastSelectedSortIndex then
      self.sortTitles[self.lastSelectedSortIndex].text = GvgStatkeyStr[self.lastSelectedSortIndex]
    end
    self.lastSelectedSortIndex = i
    self.sortTitles[i].text = GvgStatkeyStr[i] .. ArrowText
    _DateProxy:SortResultByKey(GvgStatData.SortableKeys[i], nil, self.isMyGuild)
    self:RefreshView()
  end
end

function GuildDateBattlefieldReport:UpdateWinOrLose()
  if _DateProxy:IsReportOver() then
    local isWin = _DateProxy:IsReportWin()
    self.winTexture.gameObject:SetActive(isWin)
    self.loseTexture.gameObject:SetActive(not isWin)
  else
    self:Hide(self.winTexture)
    self:Hide(self.loseTexture)
  end
end

function GuildDateBattlefieldReport:OnClickSwitchBtn()
  self.isMyGuild = not self.isMyGuild
  self:RefreshView()
end

function GuildDateBattlefieldReport:UpdateTitle()
  if self.isMyGuild then
    self.titleLab.text = ZhString.GuildDateBattle_Report_Title_Self
  else
    self.titleLab.text = ZhString.GuildDateBattle_Report_Title_Enemy
  end
end

function GuildDateBattlefieldReport:UpdateMyGuildOrEnemy()
  local data = _DateProxy:GetReportMyself()
  if self.isMyGuild and data and nil ~= next(data) then
    self:Show(self.myselfStatScrollView)
    self:Show(self.myselfStatGO)
    self:Show(self.myselfDataBg)
    self.myselfStatData:SetData(data)
    self.myselfStatOwner:SetData(data)
  else
    self:Hide(self.myselfStatScrollView)
    self:Hide(self.myselfStatGO)
    self:Hide(self.myselfDataBg)
  end
end
