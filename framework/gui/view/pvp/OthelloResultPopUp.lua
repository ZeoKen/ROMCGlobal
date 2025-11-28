autoImport("OthelloReportPanel")
autoImport("TeamPwsFightResultPopUp")
OthelloResultPopUp = class("OthelloResultPopUp", TeamPwsFightResultPopUp)
OthelloResultPopUp.ViewType = UIViewType.NormalLayer
OthelloResultPopUp.TexMvpName = "pvp_bg_mvp"
local WinEffectMap = {
  [1] = {
    "6v6_victory_White-crystal",
    "pvp_bg_win_red"
  },
  [2] = {
    "6v6_victory_black-crystal",
    "pvp_bg_win_blue"
  }
}
local WinBG = "pvp_bg_win"

function OthelloResultPopUp:Init()
  OthelloResultPopUp.super.Init(self)
end

function OthelloResultPopUp:InitReportPanel()
  redlog("InitReportPanel")
  self.reportPanel = OthelloReportPanel.new(self:FindGO("ReportRoot"))
end

function OthelloResultPopUp:SetTexturesAndEffects()
  if self:ObjIsNil(self.winContainer) then
    self.winContainer = self:LoadPreferb("part/6V6Win_white", self:FindGO("WinEffect"))
    self.winBg = self:FindChild("pvp_bg_win", self.winContainer):GetComponent(UITexture)
    self.winText = self:FindChild("pvp_bg_win_text", self.winContainer):GetComponent(UITexture)
    self.winBanner = self:FindChild("pvp_bg_win_banner", self.winContainer):GetComponent(UITexture)
    self.effectRole = self:PlayUIEffect(EffectMap.UI.TeamPws_MvpPlayer, self:FindGO("RoleEffect"))
    self.effectRole:RegisterWeakObserver(self)
    local index = self.isRedTeamWin and 1 or 2
    redlog("index = self.isRedTeamWin", index, self.isRedTeamWin)
    PictureManager.Instance:SetPVP(TeamPwsFightResultPopUp.TexMvpName, self:FindComponent("texMvp", UITexture))
    PictureManager.Instance:SetPVP(WinBG, self.winBg)
    PictureManager.Instance:SetPVP(WinEffectMap[index][1], self.winText)
    PictureManager.Instance:SetPVP(WinEffectMap[index][2], self.winBanner)
    PictureManager.Instance:SetPVP(TeamPwsFightResultPopUp.ModelBg, self.modelRTBg)
  end
end

function OthelloResultPopUp:OnExit()
  if not self:ObjIsNil(self.winContainer) then
    GameObject.Destroy(self.winContainer)
    self.winContainer = nil
  end
  PvpProxy.Instance:ClearOthelloReportData()
  OthelloResultPopUp.super.OnExit(self)
end
