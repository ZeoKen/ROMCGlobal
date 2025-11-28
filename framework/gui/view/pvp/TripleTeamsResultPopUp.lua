autoImport("TeamPwsFightResultPopUp")
autoImport("TripleTeamReportCell")
TripleTeamsResultPopUp = class("TripleTeamsResultPopUp", TeamPwsFightResultPopUp)
TripleTeamsResultPopUp.ViewType = UIViewType.NormalLayer
local SortType = {
  Name = 1,
  Kill = 2,
  Death = 3,
  Help = 4,
  Damage = 5,
  Heal = 6,
  BeDamaged = 7
}
local TexWin = "pvp_bg_win"
local TexMvpName = "pvp_bg_mvp"
local ModelBg = "pwsFightResultBg"
local WinCampConf = {
  [ETRIPLECAMP.ETRIPLE_CAMP_MIN] = {
    tex = "pvp_bg_lost"
  },
  [ETRIPLECAMP.ETRIPLE_CAMP_RED] = {
    tex = "pvp_bg_win_red"
  },
  [ETRIPLECAMP.ETRIPLE_CAMP_YELLOW] = {
    tex = "pvp_bg_win_yellow"
  },
  [ETRIPLECAMP.ETRIPLE_CAMP_BLUE] = {
    tex = "pvp_bg_win_blue"
  },
  [ETRIPLECAMP.ETRIPLE_CAMP_GREEN] = {
    tex = "pvp_bg_win_green"
  }
}

function TripleTeamsResultPopUp:Init()
  self:FindObjs()
  self:AddButtonEvts()
  self:AddViewEvts()
end

function TripleTeamsResultPopUp:FindObjs()
  TripleTeamsResultPopUp.super.FindObjs(self)
  self.texMvp = self:FindComponent("texMvp", UITexture)
  self.winBg = self:FindComponent("pvp_bg_win", UITexture)
  self.winText = self:FindComponent("pvp_bg_win_text", UILabel)
  self.winTextBottom = self:FindComponent("pvp_bg_win_text_bottom", UILabel)
  self.winBanner = self:FindComponent("pvp_bg_win_banner", UITexture)
  self.objLoading = self:FindGO("LoadingRoot")
  self.objEmptyList = self:FindGO("EmptyList")
  self.roleEffect = self:FindGO("RoleEffect")
  self:InitReportList()
end

function TripleTeamsResultPopUp:InitReportList()
  local gridReport = self:FindComponent("reportContainer", UIGrid)
  self.listReports = UIGridListCtrl.new(gridReport, TripleTeamReportCell, "TripleTeamReportCell")
end

function TripleTeamsResultPopUp:AddButtonEvts()
  TripleTeamsResultPopUp.super.AddButtonEvts(self)
  local parent = self:FindGO("ReportTitles")
  local objButton = self:FindGO("labName", parent)
  self:AddClickEvent(objButton, function()
    self:SortByName()
  end)
  objButton = self:FindGO("labKill", parent)
  self:AddClickEvent(objButton, function()
    self:SortByKill()
  end)
  objButton = self:FindGO("labDeath", parent)
  self:AddClickEvent(objButton, function()
    self:SortByDeath()
  end)
  objButton = self:FindGO("labHelp", parent)
  self:AddClickEvent(objButton, function()
    self:SortByHelp()
  end)
  objButton = self:FindGO("labDamage", parent)
  self:AddClickEvent(objButton, function()
    self:SortByDamage()
  end)
  objButton = self:FindGO("labHeal", parent)
  self:AddClickEvent(objButton, function()
    self:SortByHeal()
  end)
  objButton = self:FindGO("labBeDamaged", parent)
  self:AddClickEvent(objButton, function()
    self:SortByBeDamaged()
  end)
end

function TripleTeamsResultPopUp:SetTexturesAndEffects()
  self.effectRole = self:PlayUIEffect(EffectMap.UI.TeamPws_MvpPlayer, self.roleEffect)
  self.effectRole:RegisterWeakObserver(self)
  PictureManager.Instance:SetPVP(TexWin, self.winBg)
  PictureManager.Instance:SetPVP(TexMvpName, self.texMvp)
  PictureManager.Instance:SetPVP(ModelBg, self.modelRTBg)
  local config = WinCampConf[self.winCamp]
  if config then
    PictureManager.Instance:SetPVP(config.tex, self.winBanner)
    self.winBanner.flip = self.winCamp > 0 and 0 or 2
  end
  if self.winCamp > 0 then
    local name = GameConfig.Triple.CampName[self.winCamp]
    self.winText.text = string.format(ZhString.Triple_Camp_Win, name)
    self.winTextBottom.text = string.format(ZhString.Triple_Camp_Win, name)
  else
    self.winText.text = ZhString.Triple_Draw
    self.winTextBottom.text = ZhString.Triple_Draw
  end
end

function TripleTeamsResultPopUp:HandleLoadScene()
  if not Game.MapManager:IsPVPMode_3Teams() then
    self:CloseSelf()
  end
end

function TripleTeamsResultPopUp:OnEnter()
  TeamPwsFightResultPopUp.super.OnEnter(self)
  local viewdata = self.viewdata and self.viewdata.viewdata
  if viewdata then
    if viewdata.mvpUserInfo then
      self.mvpUserData = UserData.CreateAsTable()
      local serverdata = viewdata.mvpUserInfo.datas
      local sdata
      for i = 1, #serverdata do
        sdata = serverdata[i]
        if sdata then
          self.mvpUserData:SetByID(sdata.type, sdata.value, sdata.data)
        end
      end
      local mvpName = viewdata.mvpUserInfo.name
      local anonymous = self.mvpUserData:Get(UDEnum.ANONYMOUS) or 0
      if anonymous ~= 0 then
        local pro = self.mvpUserData:Get(UDEnum.PROFESSION)
        mvpName = FunctionAnonymous.Me():GetAnonymousName(pro)
      end
      self.labMvpName.text = mvpName
    end
    self.winCamp = viewdata.winCamp
  end
  self:CreateMvpPlayerRole()
  self:SetTexturesAndEffects()
  local maxScore = 0
  local maxScoreIndex = 0
  local camps = PvpProxy.Instance:GetTripleCampInfos()
  for i = 1, #camps do
    local data = camps[i]
    if maxScore < data.score then
      maxScoreIndex = i
      maxScore = data.score
    end
  end
  if 0 < maxScoreIndex then
    local maxScoreCamp = table.remove(camps, maxScoreIndex)
    table.insert(camps, 1, maxScoreCamp)
  end
  self.players = {}
  for i = 1, #camps do
    for j = 1, #camps[i].users do
      local charid = camps[i].users[j]
      local user = PvpProxy.Instance:GetTripleUserInfo(charid)
      if charid == viewdata.mvpUserInfo.charid then
        user.isMvp = true
      end
      self.players[#self.players + 1] = user
    end
  end
  self:UpdateReportList()
end

function TripleTeamsResultPopUp:OnExit()
  PictureManager.Instance:UnLoadPVP(TexWin, self.winBg)
  PictureManager.Instance:UnLoadPVP(TexMvpName, self.texMvp)
  PictureManager.Instance:UnLoadPVP(ModelBg, self.modelRTBg)
  PictureManager.Instance:UnLoadPVP(WinCampConf[self.winCamp], self.winBanner)
  self:ClearTick()
  self:DestroyRoleModel()
  if self.mvpUserData then
    self.mvpUserData:Destroy()
  end
  if self.effectWin and self.effectWin:Alive() then
    self.effectWin:Destroy()
  end
  if self.effectRole and self.effectRole:Alive() then
    self.effectRole:Destroy()
  end
  TeamPwsFightResultPopUp.super.OnExit(self)
end

function TripleTeamsResultPopUp:UpdateReportList()
  self.listReports:ResetDatas(self.players)
  self.objLoading:SetActive(false)
  self.objEmptyList:SetActive(#self.players == 0)
  if self.curLastCell then
    self.curLastCell:SetLineActive(true)
  end
  if #self.players > 0 then
    local cells = self.listReports:GetCells()
    self.curLastCell = cells[#cells]
    self.curLastCell:SetLineActive(false)
  end
end

function TripleTeamsResultPopUp:SortByName()
  if self.sortType == SortType.Name then
    return
  end
  table.sort(self.players, function(x, y)
    return x.username < y.username
  end)
  self.sortType = SortType.Name
  self:UpdateReportList()
end

function TripleTeamsResultPopUp:SortByKill()
  if self.sortType == SortType.Kill then
    return
  end
  table.sort(self.players, function(x, y)
    return x.kill > y.kill
  end)
  self.sortType = SortType.Kill
  self:UpdateReportList()
end

function TripleTeamsResultPopUp:SortByDeath()
  if self.sortType == SortType.Death then
    return
  end
  table.sort(self.players, function(x, y)
    return x.death > y.death
  end)
  self.sortType = SortType.Death
  self:UpdateReportList()
end

function TripleTeamsResultPopUp:SortByHelp()
  if self.sortType == SortType.Help then
    return
  end
  table.sort(self.players, function(x, y)
    return x.help > y.help
  end)
  self.sortType = SortType.Help
  self:UpdateReportList()
end

function TripleTeamsResultPopUp:SortByDamage()
  if self.sortType == SortType.Damage then
    return
  end
  table.sort(self.players, function(x, y)
    return x.damage > y.damage
  end)
  self.sortType = SortType.Damage
  self:UpdateReportList()
end

function TripleTeamsResultPopUp:SortByHeal()
  if self.sortType == SortType.Heal then
    return
  end
  table.sort(self.players, function(x, y)
    return x.heal > y.heal
  end)
  self.sortType = SortType.Heal
  self:UpdateReportList()
end

function TripleTeamsResultPopUp:SortByBeDamaged()
  if self.sortType == SortType.BeDamaged then
    return
  end
  table.sort(self.players, function(x, y)
    return x.bedamaged > y.bedamaged
  end)
  self.sortType = SortType.BeDamaged
  self:UpdateReportList()
end
