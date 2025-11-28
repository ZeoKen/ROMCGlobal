autoImport("ServantRecommendView")
autoImport("FinanceView")
autoImport("ServantImproveViewNew")
autoImport("ServantCalendarView")
ServantNewMainView = class("ServantNewMainView", ContainerView)
ServantNewMainView.ViewType = UIViewType.NormalLayer
local UI_FLITER = GameConfig.Servant.Filter or {11, 12}
local TOGGLE_BTN_UNCHOOSEN = Color(0.25882352941176473, 0.34901960784313724, 0.6705882352941176, 1)
local OUTLINE_TEXTURE = "calendar_bg"
local FIXED_TEXTURE = "calendar_bg1_picture"
local C_BG_TEXTURE = "calendar_bg1"
local L_BG_TEXTURE = "calendar_bg2"
local SEASON_TEXTURE = {
  [1] = "calendar_bg_winter",
  [2] = "calendar_bg_spring",
  [3] = "calendar_bg_summer",
  [4] = "calendar_bg_autumn"
}

function ServantNewMainView:Init()
  self:FindObjs()
  self:AddViewEvts()
  self:InitShow()
end

function ServantNewMainView:FindObjs()
  self.bgH_GO = self:FindGO("BgH")
  self.bgH = self:FindGO("BgH"):GetComponent(UITexture)
  self.bgH_L = self:FindGO("BgL", self.bgH_GO):GetComponent(UITexture)
  self.bgH_R = self:FindGO("BgR", self.bgH_GO):GetComponent(UITexture)
  self.bgS_GO = self:FindGO("BgS")
  self.bgS = self:FindGO("BgS"):GetComponent(UITexture)
  self.bgS_L = self:FindGO("BgL", self.bgS_GO):GetComponent(UITexture)
  self.bgS_R = self:FindGO("BgR", self.bgS_GO):GetComponent(UITexture)
  self.outLineTex = self:FindGO("OutLineTexture"):GetComponent(UITexture)
  self.fixedTex = self:FindGO("FixedTexture"):GetComponent(UITexture)
  self.recommendToggle = self:FindGO("RecommendBtn")
  self.financeToggle = self:FindGO("FinanceBtn")
  self.improveToggle = self:FindGO("ImproveBtn")
  self.calendarToggle = self:FindGO("CalendarBtn")
  self.funcGrid = self:FindComponent("funcGrid", UIGrid)
  local systemForbidden = GameConfig.SystemForbid and GameConfig.SystemForbid.OpenServantEquipRecommend
  local noviceServerForbidden = ServantRecommendProxy.Instance:CheckForbiddenByNoviceServer()
  if systemForbidden or noviceServerForbidden then
    self.improveToggle:SetActive(false)
  end
  self.funcGrid:Reposition()
  self.toggleBtnSprite = {
    self.recommendToggle:GetComponent(UISprite),
    self.financeToggle:GetComponent(UISprite),
    self.improveToggle:GetComponent(UISprite),
    self.calendarToggle:GetComponent(UISprite)
  }
  self.toggleBg = {}
  for i = 1, #self.toggleBtnSprite do
    self.toggleBg[i] = self:FindGO("ToggleBg" .. i)
  end
  self.recommendObj = self:FindGO("recommendView")
  self.financeObj = self:FindGO("financeView")
  self.improveObj = self:FindGO("improveView")
  self.calendarObj = self:FindGO("calendarView")
  self.seasonTexture = {}
  self.seasonPos = self:FindGO("SeasonPos")
  for i = 1, 4 do
    self.seasonTexture[i] = self:FindGO("season" .. i, self.seasonPos)
  end
end

function ServantNewMainView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.HandleEvt)
  self:AddListenEvt(ShortCut.MoveToPos, self.HandleEvt)
  self:AddListenEvt(ServantImproveEvent.FunctionListUpdate, self.UpdateFunctionList)
  self:AddListenEvt(ServantImproveEvent.ItemListUpdate, self.UpdateGroup)
  self:AddListenEvt(ServantImproveEvent.GiftProgressUpdate, self.UpdateGiftProgressNew)
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.OnSessionShopQueryShopConfigCmd)
  self:AddListenEvt(ServiceEvent.NUserUpdateShopGotItem, self.OnReceiveUpdateShopGotItem)
  self:AddListenEvt(ServiceEvent.FuBenCmdSyncPassUserInfo, self.RecSyncPassUserInfoCmd)
  self:AddListenEvt(MyselfEvent.ServantID, self.UpdateServantIcon)
  self:AddListenEvt(ServiceEvent.NUserServantStatisticsUserCmd, self.OnRecvServantStatisticsUserCmd)
  self:AddListenEvt(ServiceEvent.NUserServantStatisticsMailUserCmd, self.OnRecvServantStatisticsMailUserCmd)
end

function ServantNewMainView:RecSyncPassUserInfoCmd(data)
  if self.improveView then
    self.improveView:RecSyncPassUserInfoCmd(data)
  end
end

function ServantNewMainView:UpdateFunctionList(data)
  if not self.improveView then
    return
  end
  self.improveView:UpdateFunctionList(data)
end

function ServantNewMainView:UpdateGroup(data)
  if not self.improveView then
    return
  end
  self.improveView:UpdateGroup(data)
end

function ServantNewMainView:UpdateGiftProgressNew(data)
  if not self.improveView then
    return
  end
  self.improveView:UpdateGiftProgressNew(data)
end

function ServantNewMainView:RecvQueryShopConfig(data)
  if not self.improveView then
    return
  end
  self.improveView:RecvQueryShopConfig(data)
end

function ServantNewMainView:OnReceiveUpdateShopGotItem(data)
  if not self.improveView then
    return
  end
  self.improveView:OnReceiveUpdateShopGotItem(data)
end

function ServantNewMainView:HandleEvt()
  TipsView.Me():HideCurrent()
  self:CloseSelf()
end

local SERVANT_2D_ICON_SUFFIX = "2d"

function ServantNewMainView:InitShow()
  RedTipProxy.Instance:RegisterUIByGroupID(12, self.improveToggle, 4, {-5, -5})
  self:AddTabChangeEvent(self.recommendToggle, self.recommendObj, PanelConfig.ServantRecommendView)
  self:AddTabChangeEvent(self.financeToggle, self.financeObj, PanelConfig.FinanceView)
  self:AddTabChangeEvent(self.improveToggle, self.improveObj, PanelConfig.ServantImproveViewNew)
  self:AddTabChangeEvent(self.calendarToggle, self.calendarObj, PanelConfig.ServantCalendarView)
  if self.viewdata.viewdata and self.viewdata.viewdata.tab then
    self:TabChangeHandler(self.viewdata.viewdata.tab)
  else
    self:TabChangeHandler(PanelConfig.ServantRecommendView.tab)
  end
  self.myServantIcon = self:FindGO("Stefanie"):GetComponent(UISprite)
  self:UpdateServantIcon()
  local randomVoice = GameConfig.Servant.StefanieRandomVoice
  self:AddClickEvent(self.myServantIcon.gameObject, function()
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ChooseServantView,
      viewdata = {isChange = true}
    })
  end)
  self:AddButtonEvent("CloseButton", function()
    if self.battlepassView and self.battlepassView.upgradeView and self.battlepassView.upgradeView.gameObject.activeInHierarchy then
      self.battlepassView.upgradeView:CloseSelf()
    else
      self:CloseSelf()
    end
  end)
end

function ServantNewMainView:UpdateServantIcon()
  local cfg = MyselfProxy.Instance:GetServantDialogIconCFG()
  if cfg and 1 < #cfg then
    local icon = cfg[2] .. SERVANT_2D_ICON_SUFFIX
    self.myServantIcon.gameObject:SetActive(true)
    IconManager:SetUIIcon(icon, self.myServantIcon)
    self.myServantIcon:MakePixelPerfect()
  else
    self.myServantIcon.gameObject:SetActive(false)
  end
end

function ServantNewMainView:TabChangeHandler(key)
  if self.currentKey ~= key then
    if key == PanelConfig.ServantRecommendView.tab then
      if not self.recommendView then
        self.recommendView = self:AddSubView("ServantRecommendView", ServantRecommendView)
      end
      self.recommendView:ShowTexture()
      self:SwitchBG(1)
    elseif key == PanelConfig.FinanceView.tab then
      if not self.financeView then
        self.financeView = self:AddSubView("FinanceView", FinanceView)
      end
      self:SwitchBG(2)
    elseif key == PanelConfig.ServantImproveViewNew.tab then
      if not self.improveView then
        self.improveView = self:AddSubView("ServantImproveView", ServantImproveViewNew)
      end
      self:SwitchBG(2)
    elseif key == PanelConfig.ServantCalendarView.tab then
      if not self.calendarView then
        self.calendarView = self:AddSubView("ServantCalendarView", ServantCalendarView)
        self.calendarView:OnClickWeekTog()
      end
      self:SwitchBG(2)
    end
    ServantNewMainView.super.TabChangeHandler(self, key)
    self:SetMainTexture()
    self.currentKey = key
    for i = 1, #self.toggleBtnSprite do
      self.toggleBg[i]:SetActive(i == self.currentKey)
      self.toggleBtnSprite[i].color = i == self.currentKey and ColorUtil.NGUIWhite or TOGGLE_BTN_UNCHOOSEN
    end
    local batchConfig = GameConfig.System.Gen and GameConfig.System.Gen == 2
    if batchConfig then
    end
  end
end

function ServantNewMainView:SetMainTexture()
  PictureManager.Instance:SetUI(OUTLINE_TEXTURE, self.outLineTex)
  self.seasonPos:SetActive(false)
end

function ServantNewMainView:SwitchBG(type)
  if type == 1 then
    self.bgH_GO:SetActive(true)
    self.bgS_GO:SetActive(false)
  else
    self.bgS_GO:SetActive(true)
    self.bgH_GO:SetActive(false)
  end
end

function ServantNewMainView:SetSeasonTexture(month)
  if self.season ~= nil and self.season ~= ServantCalendarProxy.GetSeason(month) then
    PictureManager.Instance:UnLoadUI(SEASON_TEXTURE[self.season], self.outLineTex)
  end
  self.season = ServantCalendarProxy.GetSeason(month)
  PictureManager.Instance:SetUI(SEASON_TEXTURE[self.season], self.outLineTex)
  self.seasonPos:SetActive(true)
  for i = 1, 4 do
    self.seasonTexture[i]:SetActive(i == self.season)
  end
end

function ServantNewMainView:OnEnter()
  PictureManager.Instance:SetUI(FIXED_TEXTURE, self.fixedTex)
  PictureManager.Instance:SetUI(C_BG_TEXTURE, self.bgH)
  PictureManager.Instance:SetUI(L_BG_TEXTURE, self.bgH_L)
  PictureManager.Instance:SetUI(L_BG_TEXTURE, self.bgH_R)
  PictureManager.Instance:SetUI(C_BG_TEXTURE, self.bgS)
  PictureManager.Instance:SetUI(L_BG_TEXTURE, self.bgS_L)
  PictureManager.Instance:SetUI(L_BG_TEXTURE, self.bgS_R)
  FunctionSceneFilter.Me():StartFilter(UI_FLITER)
  ServiceMatchCCmdProxy.Instance:CallQueryTeamPwsTeamInfoMatchCCmd()
  ServantNewMainView.super.OnEnter(self)
end

function ServantNewMainView:OnExit()
  PictureManager.Instance:UnLoadUI(OUTLINE_TEXTURE, self.outLineTex)
  PictureManager.Instance:UnLoadUI(FIXED_TEXTURE, self.fixedTex)
  PictureManager.Instance:UnLoadUI(C_BG_TEXTURE, self.bgH)
  PictureManager.Instance:UnLoadUI(L_BG_TEXTURE, self.bgH_L)
  PictureManager.Instance:UnLoadUI(L_BG_TEXTURE, self.bgH_R)
  PictureManager.Instance:UnLoadUI(C_BG_TEXTURE, self.bgS)
  PictureManager.Instance:UnLoadUI(L_BG_TEXTURE, self.bgS_L)
  PictureManager.Instance:UnLoadUI(L_BG_TEXTURE, self.bgS_R)
  if self.season ~= nil then
    PictureManager.Instance:UnLoadUI(SEASON_TEXTURE[self.season], self.outLineTex)
  end
  FunctionSceneFilter.Me():EndFilter(UI_FLITER)
  RedTipProxy.Instance:UnRegisterUIByGroupID(11, self.recommendToggle)
  RedTipProxy.Instance:UnRegisterUIByGroupID(12, self.improveToggle)
  ServantNewMainView.super.OnExit(self)
end

function ServantNewMainView:OnSessionShopQueryShopConfigCmd(data)
  self:RecvQueryShopConfig(data)
end

function ServantNewMainView:OnRecvServantStatisticsUserCmd(data)
  if self.recommendView and self.recommendView.raidstatView then
    self.recommendView.raidstatView:RecvServantStatisticsUserCmd()
  end
end

function ServantNewMainView:OnRecvServantStatisticsMailUserCmd(data)
  if self.recommendView and self.recommendView.raidstatView then
    self.recommendView.raidstatView:RecvServantStatisticsMailUserCmd()
  end
end
