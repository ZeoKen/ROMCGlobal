autoImport("ServantCalendarView")
CalendarView = class("CalendarView", ContainerView)
CalendarView.ViewType = UIViewType.NormalLayer
local Prefab_Path = ResourcePathHelper.UIView("ServantCalendarView")
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

function CalendarView:Init()
  self:FindObj()
  if not self.calendarView then
    self.calendarView = self:AddSubView("ServantCalendarView", ServantCalendarView)
  end
  self.calendarView:OnClickWeekTog()
end

function CalendarView:FindObj()
  self.bg = self:FindGO("Bg"):GetComponent(UITexture)
  self.bgL = self:FindGO("BgL"):GetComponent(UITexture)
  self.bgR = self:FindGO("BgR"):GetComponent(UITexture)
  self.outLineTex = self:FindGO("OutLineTexture"):GetComponent(UITexture)
  self.fixedTex = self:FindGO("FixedTexture"):GetComponent(UITexture)
  self.seasonTexture = {}
  self.seasonPos = self:FindGO("SeasonPos")
  for i = 1, 4 do
    self.seasonTexture[i] = self:FindGO("season" .. i, self.seasonPos)
  end
end

function CalendarView:SetSeasonTexture(month)
  local season = ServantCalendarProxy.GetSeason(month)
  redlog("month: ", month, season, self.outLineTex)
  PictureManager.Instance:SetUI(SEASON_TEXTURE[season], self.outLineTex)
  self.seasonPos:SetActive(true)
  for i = 1, 4 do
    self.seasonTexture[i]:SetActive(i == season)
  end
end

function CalendarView:OnEnter()
  PictureManager.Instance:SetUI(FIXED_TEXTURE, self.fixedTex)
  PictureManager.Instance:SetUI(C_BG_TEXTURE, self.bg)
  PictureManager.Instance:SetUI(L_BG_TEXTURE, self.bgL)
  PictureManager.Instance:SetUI(L_BG_TEXTURE, self.bgR)
  PictureManager.Instance:SetUI(OUTLINE_TEXTURE, self.outLineTex)
  CalendarView.super.OnEnter(self)
end

function CalendarView:OnExit()
  PictureManager.Instance:UnLoadUI()
  CalendarView.super.OnExit(self)
end
