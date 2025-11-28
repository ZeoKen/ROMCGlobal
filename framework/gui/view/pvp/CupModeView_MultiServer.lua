autoImport("CupModeView")
CupModeView_MultiServer = class("CupModeView_MultiServer", CupModeView)
autoImport("CupModeRankSubview_MultiServer")
autoImport("CupModeScheduleSubview_MultiServer")
CupModeView_MultiServer.ViewType = UIViewType.NormalLayer
CupModeView_MultiServer.CrossServer = true
local Color_Gray = LuaColor.New(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)
local Color_White = LuaColor.White()
local ViewName = "CupModeView"
local CupModeViewPath = ResourcePathHelper.UIView(ViewName)
local fixed_combo_txt = "txt_combo_"
local tempVector3 = LuaVector3.Zero()

function CupModeView_MultiServer:LoadSubViews()
  self.rootGO = self:FindGO("CupModeView_MultiServer")
  local go = self:LoadPreferb_ByFullPath(CupModeViewPath, self.rootGO, true)
  go.name = "CupModeView_MultiServer"
  local rankGO = self:FindGO("CupModeRankSubview", self.rootGO)
  rankGO.name = "CupModeRankSubview_MultiServer"
  local scheduleGO = self:FindGO("CupModeScheduleSubview", self.rootGO)
  scheduleGO.name = "CupModeScheduleSubview_MultiServer"
  self.rankSubview = self:AddSubView("CupModeRankSubview_MultiServer", CupModeRankSubview_MultiServer, self.initParams)
  self.scheduleSubview = self:AddSubView("CupModeScheduleSubview_MultiServer", CupModeScheduleSubview_MultiServer, self.initParams)
end

function CupModeView_MultiServer:FindObjs()
  self.rankGO = self:FindGO("CupModeRankSubview_MultiServer", self.rootGO)
  self.scheduleGO = self:FindGO("CupModeScheduleSubview_MultiServer", self.rootGO)
  self.seasonRootGO = self:FindGO("Season", self.rootGO)
  self.seasonLabel = self:FindComponent("SeasonLab", UISprite, self.seasonRootGO)
  self.seasonLabel2 = self:FindComponent("SeasonLab2", UISprite, self.seasonRootGO)
  self.fixSpriteGO = self:FindGO("SeasonFixedSp", self.seasonRootGO)
end

function CupModeView_MultiServer:UpdateScheduleStatus()
  local proxy = CupMode6v6Proxy_MultiServer.Instance
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
