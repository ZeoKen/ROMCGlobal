ActivityCalendarView = class("ActivityCalendarView", ContainerView)
ActivityCalendarView.ViewType = UIViewType.NormalLayer
autoImport("ServantCalendarView")
local SEASON_TEXTURE = {
  [1] = "calendar_bg_winter",
  [2] = "calendar_bg_spring",
  [3] = "calendar_bg_summer",
  [4] = "calendar_bg_autumn"
}
local OUTLINE_TEXTURE = "calendar_bg"
local FIXED_TEXTURE = "calendar_bg1_picture"
local C_BG_TEXTURE = "calendar_bg1"
local L_BG_TEXTURE = "calendar_bg2"

function ActivityCalendarView:Init()
  self:InitView()
end

function ActivityCalendarView:InitView()
  self.outLineTex = self:FindGO("OutLineTexture"):GetComponent(UITexture)
  self.fixedTex = self:FindGO("FixedTexture"):GetComponent(UITexture)
  self.seasonTexture = {}
  self.seasonPos = self:FindGO("SeasonPos")
  for i = 1, 4 do
    self.seasonTexture[i] = self:FindGO("season" .. i, self.seasonPos)
  end
  self.bgS_GO = self:FindGO("BgS")
  self.bgS = self:FindGO("BgS"):GetComponent(UITexture)
  self.bgS_L = self:FindGO("BgL", self.bgS_GO):GetComponent(UITexture)
  self.bgS_R = self:FindGO("BgR", self.bgS_GO):GetComponent(UITexture)
  self.calendarPageObj = self:FindGO("calendarPage")
  self.calendarView = self:AddSubView("ServantCalendarView", ServantCalendarView)
  self.calendarView:OnClickWeekTog()
end

function ActivityCalendarView:SetSeasonTexture(month)
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

function ActivityCalendarView:OnEnter()
  PictureManager.Instance:SetUI(FIXED_TEXTURE, self.fixedTex)
  PictureManager.Instance:SetUI(C_BG_TEXTURE, self.bgS)
  PictureManager.Instance:SetUI(L_BG_TEXTURE, self.bgS_L)
  PictureManager.Instance:SetUI(L_BG_TEXTURE, self.bgS_R)
  FunctionSceneFilter.Me():StartFilter(UI_FLITER)
  ServiceMatchCCmdProxy.Instance:CallQueryTeamPwsTeamInfoMatchCCmd()
  ServantNewMainView.super.OnEnter(self)
end

function ActivityCalendarView:OnExit()
  if self.season ~= nil then
    PictureManager.Instance:UnLoadUI(SEASON_TEXTURE[self.season], self.outLineTex)
  end
  PictureManager.Instance:UnLoadUI(FIXED_TEXTURE, self.fixedTex)
  PictureManager.Instance:UnLoadUI(C_BG_TEXTURE, self.bgS)
  PictureManager.Instance:UnLoadUI(L_BG_TEXTURE, self.bgS_L)
  PictureManager.Instance:UnLoadUI(L_BG_TEXTURE, self.bgS_R)
  ActivityCalendarView.super.OnExit(self)
end
