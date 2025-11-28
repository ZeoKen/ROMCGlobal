autoImport("WarbandRankSubView")
autoImport("WarbandOpponentView")
WarbandModelView = class("WarbandModelView", SubView)
local view_Path = ResourcePathHelper.UIView("WarbandModelView")
local warbandProxy

function WarbandModelView:_loadSelf()
  self.root = self:FindGO("WarbandModelView")
  local obj = self:LoadPreferb_ByFullPath(view_Path, self.root, true)
  obj.name = "WarbandModelView"
  self.rankSubView = self:AddSubView("WarbandRankSubView", WarbandRankSubView)
  self.signupOpponentSubView = self:AddSubView("WarbandOpponentView", WarbandOpponentView)
  self.rankRoot = self:FindGO("WarbandRankSubView")
  self.gameRoot = self:FindGO("WarbandOpponentView")
end

function WarbandModelView:Init()
  warbandProxy = WarbandProxy.Instance
  self:FindObjs()
end

function WarbandModelView:FindObjs()
  self:_loadSelf()
  self.seasonRoot = self:FindGO("Season", self.root)
  self.seasonLab = self:FindComponent("SeasonLab", UISprite, self.seasonRoot)
  self.seasonLab2 = self:FindComponent("SeasonLab2", UISprite, self.seasonRoot)
  self.fixSp = self:FindGO("SeasonFixedSp", self.seasonRoot)
end

local fixed_combo_txt = "txt_combo_"
local tempVector3 = LuaVector3.Zero()

function WarbandModelView:UpdateScheduleStatus()
  local hasAuthority = warbandProxy:CheckBandAuthority()
  if warbandProxy:IsSeasonNoOpen() or warbandProxy:IsSeasonEnd() or warbandProxy:IsSigthupPending() then
    self.rankRoot:SetActive(true)
    self.gameRoot:SetActive(false)
    self.signupOpponentSubView:SwitchSignup(false)
  elseif warbandProxy:IsInSignupTime() then
    self.gameRoot:SetActive(true)
    self.rankRoot:SetActive(false)
    self.signupOpponentSubView:SwitchSignup(true)
  else
    self.gameRoot:SetActive(true)
    self.rankRoot:SetActive(false)
    self.signupOpponentSubView:SwitchSignup(false)
  end
  local cur = warbandProxy.curSeason
  if cur then
    self.seasonRoot:SetActive(true)
    self.fixSp:SetActive(true)
    if cur < 10 then
      self.seasonLab.spriteName = fixed_combo_txt .. cur
      self.seasonLab2.gameObject:SetActive(false)
      LuaVector3.Better_Set(tempVector3, 132.4, 169.5, 0)
      self.fixSp.transform.localPosition = LuaGeometry.GetTempVector3(12, 0, 0)
    else
      self.seasonLab.spriteName = fixed_combo_txt .. math.floor(cur / 10)
      self.seasonLab2.spriteName = fixed_combo_txt .. cur % 10
      self.seasonLab2.gameObject:SetActive(true)
      LuaVector3.Better_Set(tempVector3, 121.4, 169.5, 0)
      self.fixSp.transform.localPosition = LuaGeometry.GetTempVector3(23, 0, 0)
    end
    self.seasonRoot.transform.localPosition = tempVector3
  else
    self.seasonRoot:SetActive(false)
    self.fixSp:SetActive(false)
  end
end

function WarbandModelView:OnDestroy()
  WarbandModelView.super.OnDestroy(self)
end

function WarbandModelView:UpdateFightingTime()
  if self.signupOpponentSubView then
    self.signupOpponentSubView:UpdateFightingTime()
  end
end

function WarbandModelView:UpdateView()
  self:UpdateScheduleStatus()
end

function WarbandModelView:SetPageStatus(index)
  self.rankRoot:SetActive(index == 1)
  self.gameRoot:SetActive(index ~= 1)
end
