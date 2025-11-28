autoImport("TeamPwsView")
autoImport("FreeBattleView")
autoImport("ClassicBattleView")
autoImport("MultiPvpView")
autoImport("CupModeView")
autoImport("CompetiveModeView")
PvpMainView = class("PvpMainView", ContainerView)
PvpMainView.ViewType = UIViewType.NormalLayer
local TEXTURE = {
  "pvp_bg_07",
  "pvp_bg_08",
  "pvp_bg_09",
  "12pvp_bg_pic1"
}
local Color_Gray = Color(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)
local Color_White = Color(1, 1, 1, 1)

function PvpMainView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
  self:InitTex()
end

function PvpMainView:FindObjs()
  self.competiveModeToggle = self:FindGO("TeamPwsBtn")
  self.freeBattleToggle = self:FindGO("FreeBattleBtn")
  self.classicBattleToggle = self:FindGO("ClassicBattleBtn")
  self.mulitiPvpToggle = self:FindGO("MulitiPvpBtn")
  self.mulitiPvpName = self:FindComponent("Name", UILabel, self.mulitiPvpToggle)
  self.mulitiPvpName.text = ZhString.TwelvePVP_TabName
  self.competiveViewObj = self:FindGO("TeamPwsView")
  self.freeBattleViewObj = self:FindGO("FreeBattleView")
  self.classicBattleViewObj = self:FindGO("ClassicBattleView")
  self.multiPvpViewObj = self:FindGO("MultiPvpView")
  self.playerTipStick = self:FindComponent("Stick", UIWidget)
  self.competiveModeTex = self:FindComponent("TeamPwsBg", UITexture)
  self.freeBattleTex = self:FindComponent("FreeBattleBg", UITexture)
  self.classicBattleTex = self:FindComponent("ClassicBattleBg", UITexture)
  self.mulitiPvpTex = self:FindComponent("MulitiPvpBg", UITexture)
end

function PvpMainView:AddEvts()
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.HandleLoadScene)
  self:AddListenEvt(PVPEvent.PVPDungeonLaunch, self.HandleDungeonLaunch)
  self:AddListenEvt(PVPEvent.TeamPws_Launch, self.CloseSelf)
  self:AddListenEvt(PVPEvent.TeamPwsOthello_Launch, self.CloseSelf)
  self:AddListenEvt(PVPEvent.TeamTwelve_Launch, self.CloseSelf)
end

function PvpMainView:HandleDungeonLaunch(note)
  self:CloseSelf()
end

function PvpMainView:AddViewEvts()
end

function PvpMainView:InitTex()
  PictureManager.Instance:SetPVP(TEXTURE[1], self.competiveModeTex)
  PictureManager.Instance:SetPVP(TEXTURE[2], self.freeBattleTex)
  PictureManager.Instance:SetPVP(TEXTURE[3], self.classicBattleTex)
  PictureManager.Instance:SetPVP(TEXTURE[4], self.mulitiPvpTex)
end

function PvpMainView:InitShow()
  self.leftBtnScrollView = self:FindComponent("LeftBtnScrollView", UIScrollView)
  self.tabGrid = self:FindComponent("TypeGrid", UIGrid, self.leftBtnScrollView.gameObject)
  self.competiveModeView = self:AddSubView("CompetiveModeView", CompetiveModeView)
  self.freeBattleView = self:AddSubView("FreeBattleView", FreeBattleView)
  self.classicBattleView = self:AddSubView("ClassicBattleView", ClassicBattleView)
  self.multiPvpView = self:AddSubView("MultiPvpView", MultiPvpView)
  self:AddTabChangeEvent(self.competiveModeToggle, self.competiveViewObj, PanelConfig.CompetiveModeView)
  self:AddTabChangeEvent(self.freeBattleToggle, self.freeBattleViewObj, PanelConfig.FreeBattleView)
  self:AddTabChangeEvent(self.classicBattleToggle, self.classicBattleViewObj, PanelConfig.ClassicBattleView)
  self:AddTabChangeEvent(self.mulitiPvpToggle, self.multiPvpViewObj, PanelConfig.MultiPvpView)
  local teamPwsOpen = not GameConfig.SystemForbid.TeamPws and not FunctionNpcFunc.Me():CheckSingleFuncForbidState(7)
  self.competiveModeToggle:GetComponent(Collider).enabled = teamPwsOpen
  self:FindGO("NotOpenMask", self.competiveModeToggle):SetActive(not teamPwsOpen)
  self.competiveModeTex.color = teamPwsOpen and Color_White or Color_Gray
  local teamPwsFunstateValid = not Table_FuncState[7] or FunctionUnLockFunc.checkFuncStateValid(7)
  self.competiveModeToggle:SetActive(teamPwsFunstateValid)
  local pvp12Open = not GameConfig.SystemForbid.TwelvePvpForbid
  local twelveValid = false
  if ISNoviceServerType then
    twelveValid = not FunctionUnLockFunc.CheckForbiddenByFuncState("TwelvePvp") and not GameConfig.SystemForbid.pvp12
  else
    twelveValid = (not Table_FuncState[123] or FunctionUnLockFunc.checkFuncStateValid(123)) and not GameConfig.SystemForbid.pvp12
  end
  if twelveValid and (BranchMgr.IsJapan() or BranchMgr.IsEU()) then
    twelveValid = pvp12Open
  end
  self.mulitiPvpToggle:SetActive(twelveValid)
  if twelveValid then
    self.mulitiPvpToggle:GetComponent(Collider).enabled = pvp12Open
    self:FindGO("NotOpenMask", self.mulitiPvpToggle):SetActive(not pvp12Open)
    self.mulitiPvpTex.color = pvp12Open and Color_White or Color_Gray
  end
  local teamRelaxOpen = not GameConfig.SystemForbid.TeamRelax
  self.freeBattleToggle:GetComponent(Collider).enabled = teamRelaxOpen
  self:FindGO("NotOpenMask", self.freeBattleToggle):SetActive(not teamRelaxOpen)
  self.freeBattleTex.color = teamRelaxOpen and Color_White or Color_Gray
  self.tabGrid.repositionNow = true
  local defaultTab = PanelConfig.ClassicBattleView.tab
  if teamPwsOpen and teamPwsFunstateValid then
    defaultTab = PanelConfig.CompetiveModeView.tab
  elseif twelveValid then
    defaultTab = PanelConfig.MultiPvpView.tab
  elseif teamRelaxOpen then
    defaultTab = PanelConfig.FreeBattleView.tab
  end
  if self.viewdata.view and self.viewdata.view.tab then
    local tab = self.viewdata.view.tab
    if key == PanelConfig.YoyoViewPage.tab or key == PanelConfig.DesertWolfView.tab or key == PanelConfig.GorgeousMetalView.tab then
      self:TabChangeHandler(PanelConfig.ClassicBattleView.tab)
      self.classicBattleView:TabChangeHandlerWithPanelID(tab)
    else
      self:TabChangeHandler(tab)
    end
  else
    self:TabChangeHandler(defaultTab)
  end
end

function PvpMainView:TabChangeHandler(key)
  if self.currentKey ~= key then
    PvpMainView.super.TabChangeHandler(self, key)
    if key == PanelConfig.CompetiveModeView.tab then
      self.competiveModeView:UpdateView()
    elseif key == PanelConfig.FreeBattleView.tab then
      self.freeBattleView:UpdateView()
    elseif key == PanelConfig.ClassicBattleView.tab then
      self.classicBattleView:UpdateView()
    elseif key == PanelConfig.MultiPvpView.tab then
      self.multiPvpView:UpdateView()
    end
    self.currentKey = key
  end
end

function PvpMainView:OnEnter()
  PvpMainView.super.OnEnter(self)
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.ChitchatLayer)
  self:PreQuerySome()
end

function PvpMainView:PreQuerySome()
  ServiceMatchCCmdProxy.Instance:CallQueryTwelveSeasonInfoMatchCCmd(PvpProxy.Type.TwelvePVPChampion)
  ServiceMatchCCmdProxy.Instance:CallQueryTwelveSeasonInfoMatchCCmd(PvpProxy.Type.TwelvePVPBattle)
  WarbandProxy.Instance:DoQuerySeasonRank()
  ServiceMatchCCmdProxy.Instance:CallQueryTwelveSeasonInfoMatchCCmd(PvpProxy.Type.TeamPwsChampion)
  CupMode6v6Proxy.Instance:DoQuerySeasonRank()
end

function PvpMainView:OnExit()
  PictureManager.Instance:UnLoadPVP(TEXTURE[1], self.competiveModeTex)
  PictureManager.Instance:UnLoadPVP(TEXTURE[2], self.freeBattleTex)
  PictureManager.Instance:UnLoadPVP(TEXTURE[3], self.classicBattleTex)
  PictureManager.Instance:UnLoadPVP(TEXTURE[4], self.mulitiPvpTex)
  PvpMainView.super.OnExit(self)
end

function PvpMainView:HandleLoadScene()
  if PvpProxy.Instance:IsSelfInGuildBase() then
    self:CloseSelf()
  end
end
