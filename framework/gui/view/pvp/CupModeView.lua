autoImport("TeamPwsMemberCell")
autoImport("CupModeRankSubview")
autoImport("CupModeScheduleSubview")
CupModeView = class("CupModeView", SubView)
CupModeView.ViewType = UIViewType.NormalLayer
local Color_Gray = LuaColor.New(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)
local Color_White = LuaColor.White()
local ViewName = "CupModeView"
local CupModeViewPath = ResourcePathHelper.UIView(ViewName)
local fixed_combo_txt = "txt_combo_"
local tempVector3 = LuaVector3.Zero()

function CupModeView:Init(initParams)
  self.subType = "6v6"
  self.initParams = initParams
  if initParams and initParams.subType then
    self.subType = initParams.subType
  end
  self:LoadSubViews()
  self:FindObjs()
  self:AddViewEvts()
end

function CupModeView:LoadSubViews()
  self.rootGO = self:FindGO("CupModeView")
  local go = self:LoadPreferb_ByFullPath(CupModeViewPath, self.rootGO, true)
  go.name = ViewName
  self.rankSubview = self:AddSubView("CupModeRankSubview", CupModeRankSubview, self.initParams)
  self.scheduleSubview = self:AddSubView("CupModeScheduleSubview", CupModeScheduleSubview, self.initParams)
end

function CupModeView:FindObjs()
  self.rankGO = self:FindGO("CupModeRankSubview", self.rootGO)
  self.scheduleGO = self:FindGO("CupModeScheduleSubview", self.rootGO)
  self.seasonRootGO = self:FindGO("Season", self.rootGO)
  self.seasonLabel = self:FindComponent("SeasonLab", UISprite, self.seasonRootGO)
  self.seasonLabel2 = self:FindComponent("SeasonLab2", UISprite, self.seasonRootGO)
  self.fixSpriteGO = self:FindGO("SeasonFixedSp", self.seasonRootGO)
end

function CupModeView:AddViewEvts()
  self:AddListenEvt(CupModeEvent.ScheduleChanged_6v6, self.UpdateView)
  self:AddListenEvt(CupModeEvent.SeasonInfo_6v6, self.UpdateView)
  self:AddListenEvt(CupModeEvent.Sort_6v6, self.UpdateView)
end

function CupModeView:OnTabEnabled()
  self:UpdateView()
end

function CupModeView:OnTabDisabled()
end

function CupModeView:UpdateView()
  self:UpdateScheduleStatus()
end

function CupModeView:UpdateScheduleStatus()
  local proxy = CupMode6v6Proxy.Instance
  local hasAuthority = proxy:CheckBandAuthority()
  if proxy:IsSeasonNoOpen() or proxy:IsSeasonEnd() or proxy:IsSigthupPending() then
    self.rankGO:SetActive(true)
    self.scheduleGO:SetActive(false)
    self.scheduleSubview:SwitchSignup(false)
  elseif proxy:IsInSignupTime() then
    self.scheduleGO:SetActive(true)
    self.rankGO:SetActive(false)
    self.scheduleSubview:SwitchSignup(true)
  else
    self.scheduleGO:SetActive(true)
    self.rankGO:SetActive(false)
    self.scheduleSubview:SwitchSignup(false)
  end
  local cur = proxy.curSeason
  if cur then
    self.seasonRootGO:SetActive(true)
    self.fixSpriteGO:SetActive(true)
    if cur < 10 then
      self.seasonLabel.spriteName = fixed_combo_txt .. cur
      self.seasonLabel2.gameObject:SetActive(false)
      LuaVector3.Better_Set(tempVector3, 132.4, 169.5, 0)
      self.fixSpriteGO.transform.localPosition = LuaGeometry.GetTempVector3(12, 0, 0)
    else
      self.seasonLabel.spriteName = fixed_combo_txt .. math.floor(cur / 10)
      self.seasonLabel2.spriteName = fixed_combo_txt .. cur % 10
      self.seasonLabel2.gameObject:SetActive(true)
      LuaVector3.Better_Set(tempVector3, 121.4, 169.5, 0)
      self.fixSpriteGO.transform.localPosition = LuaGeometry.GetTempVector3(23, 0, 0)
    end
    self.seasonRootGO.transform.localPosition = tempVector3
  else
    self.seasonRootGO:SetActive(false)
    self.fixSpriteGO:SetActive(false)
  end
end

function CupModeView:SetPageStatus(index)
  self.rankGO:SetActive(index == 1)
  self.scheduleGO:SetActive(index ~= 1)
end
