autoImport("TeamPwsReportPanel")
TeamPwsFightResultPopUp = class("TeamPwsFightResultPopUp", BaseView)
TeamPwsFightResultPopUp.ViewType = UIViewType.NormalLayer
TeamPwsFightResultPopUp.TexMvpName = "pvp_bg_mvp"
TeamPwsFightResultPopUp.RT_BG = "pwsFightResultBgRt"
TeamPwsFightResultPopUp.ModelBg = "pwsFightResultBg"

function TeamPwsFightResultPopUp:Init()
  self:FindObjs()
  self:InitReportPanel()
  self:AddButtonEvts()
  self:AddViewEvts()
  self:InitSocialShare()
end

function TeamPwsFightResultPopUp:FindObjs()
  self.objRoot = self:FindGO("Root")
  self.objModelInfos = self:FindGO("ModelInfos")
  self.labMvpName = self:FindComponent("labMvpName", UILabel)
  self.objModelTexture = self:FindComponent("ModelRoot", UITexture)
  self.modelRTBg = self:FindComponent("ModelTexBg", UITexture)
  self.dueGO = self:FindGO("Due", self.objRoot)
end

function TeamPwsFightResultPopUp:InitReportPanel()
  self.reportPanel = TeamPwsReportPanel.new(self:FindGO("ReportRoot"))
end

function TeamPwsFightResultPopUp:AddButtonEvts()
  self:AddClickEvent(self:FindGO("BtnClose"), function()
    self:ClickButtonLeave()
  end)
  self:AddClickEvent(self:FindGO("BtnLeave"), function()
    self:ClickButtonLeave()
  end)
end

function TeamPwsFightResultPopUp:AddViewEvts()
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.HandleLoadScene)
end

function TeamPwsFightResultPopUp:SetTexturesAndEffects()
  if self.isRedTeamWin ~= nil then
    self.effectWin = self:PlayUIEffect(self.isRedTeamWin and EffectMap.UI.TeamPws_RedWin or EffectMap.UI.TeamPws_BlueWin, self:FindGO("WinEffect"))
    self.effectWin:RegisterWeakObserver(self)
    if self.dueGO then
      self.dueGO:SetActive(false)
    end
  elseif self.dueGO then
    self.dueGO:SetActive(true)
  end
  self.effectRole = self:PlayUIEffect(EffectMap.UI.TeamPws_MvpPlayer, self:FindGO("RoleEffect"))
  self.effectRole:RegisterWeakObserver(self)
  self.texMvp = self:FindComponent("texMvp", UITexture)
  PictureManager.Instance:SetPVP(TeamPwsFightResultPopUp.TexMvpName, self.texMvp)
  PictureManager.Instance:SetPVP(TeamPwsFightResultPopUp.ModelBg, self.modelRTBg)
end

function TeamPwsFightResultPopUp:CreateMvpPlayerRole()
  self:DestroyRoleModel()
  local userdata = self.mvpUserData
  if not userdata then
    return
  end
  local parts = Asset_Role.CreatePartArray()
  local partIndex = Asset_Role.PartIndex
  local partIndexEx = Asset_Role.PartIndexEx
  local anonymous = userdata:Get(UDEnum.ANONYMOUS) or 0
  if anonymous ~= 0 then
    local classId = userdata:Get(UDEnum.PROFESSION)
    local gender = userdata:Get(UDEnum.SEX)
    FunctionAnonymous.Me():GetAnonymousModelParts(classId, gender, parts)
  else
    parts[partIndex.Body] = userdata:Get(UDEnum.BODY) or 0
    parts[partIndex.Hair] = userdata:Get(UDEnum.HAIR) or 0
    parts[partIndex.LeftWeapon] = userdata:Get(UDEnum.LEFTHAND) or 0
    parts[partIndex.RightWeapon] = userdata:Get(UDEnum.RIGHTHAND) or 0
    parts[partIndex.Head] = userdata:Get(UDEnum.HEAD) or 0
    parts[partIndex.Wing] = userdata:Get(UDEnum.BACK) or 0
    parts[partIndex.Face] = userdata:Get(UDEnum.FACE) or 0
    parts[partIndex.Tail] = userdata:Get(UDEnum.TAIL) or 0
    parts[partIndex.Eye] = userdata:Get(UDEnum.EYE) or 0
    parts[partIndex.Mount] = 0
    parts[partIndex.Mouth] = userdata:Get(UDEnum.MOUTH) or 0
    parts[partIndexEx.Gender] = userdata:Get(UDEnum.SEX) or 0
    parts[partIndexEx.HairColorIndex] = userdata:Get(UDEnum.HAIRCOLOR) or 0
    parts[partIndexEx.EyeColorIndex] = userdata:Get(UDEnum.EYECOLOR) or 0
    parts[partIndexEx.BodyColorIndex] = userdata:Get(UDEnum.CLOTHCOLOR) or 0
  end
  if self.role then
    self.role:Redress(parts)
    self:CreateMvpPlayerRoleCallBack(userdata)
  else
    self.role = UIModelUtil.Instance:SetRoleModelTexture(self.objModelTexture, parts, UIModelCameraTrans.PwsFightResult, nil, nil, nil, nil, function(obj)
      self.role = obj
      UIModelUtil.Instance:ChangeBGMeshRenderer(TeamPwsFightResultPopUp.RT_BG, self.objModelTexture)
      self:CreateMvpPlayerRoleCallBack(userdata)
    end)
  end
  local mvpName = not StringUtil.IsEmpty(self.labMvpName.text) and self.labMvpName.text or userdata:Get(UDEnum.NAME)
  self.role:SetName(mvpName)
  self.role:SetPosition(LuaGeometry.Const_V3_zero)
  self.role:SetEulerAngleY(-20)
  self.role:RegisterWeakObserver(self)
end

function TeamPwsFightResultPopUp:CreateMvpPlayerRoleCallBack(userdata)
  self.timeTick = TimeTickManager.Me():CreateTick(0, 33, self.ProcessLayoutWhenModelCreated, self, 1)
end

function TeamPwsFightResultPopUp:ObserverDestroyed(obj)
  if obj == self.role then
    self:ClearTick()
    self.role = nil
  elseif obj == self.effectRole then
    self.effectRole = nil
  elseif obj == self.effectWin then
    self.effectWin = nil
  end
end

function TeamPwsFightResultPopUp:ProcessLayoutWhenModelCreated()
  if not self.role then
    self:ClearTick()
    return
  end
  if not self.role.complete.body then
    return
  end
  self:ClearTick()
  local animParams = Asset_Role.GetPlayActionParams(GameConfig.teamPVP.Victoryanimation, Asset_Role.ActionName.Idle, 1)
  animParams[7] = function()
    if self.role then
      self.role:PlayAction_Simple(Asset_Role.ActionName.Idle)
    end
  end
  self.role:PlayAction(animParams)
  if not self.role.complete.body.mainSMR then
    return
  end
  local width = self.role.complete.body.mainSMR.localBounds.size.x
  local SCALE = width < 1.65 and 1 or 0.75
  self.role:SetScale(SCALE)
end

function TeamPwsFightResultPopUp:ClickButtonLeave()
  ServiceFuBenCmdProxy.Instance:CallExitMapFubenCmd()
  self:CloseSelf()
end

function TeamPwsFightResultPopUp:HandleLoadScene()
  if not Game.MapManager:IsPVPMode_TeamPws() then
    self:CloseSelf()
  end
end

function TeamPwsFightResultPopUp:DestroyRoleModel()
  if self.role then
    UIModelUtil.Instance:ResetTexture(self.objModelTexture)
    self.objModelTexture = nil
    self.role = nil
  end
end

function TeamPwsFightResultPopUp:ClearTick()
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self)
    self.timeTick = nil
  end
end

function TeamPwsFightResultPopUp:InitSocialShare()
  self:InitSocialShareData()
  self:FindSocialShareObjs()
  self:RegisterButtonClickEvent()
  self:ROOShare()
end

function TeamPwsFightResultPopUp:InitSocialShareData()
  self.screenShotWidth = -1
  self.screenShotHeight = 1080
  self.textureFormat = TextureFormat.RGB24
  self.texDepth = 24
  self.antiAliasing = ScreenShot.AntiAliasing.None
end

function TeamPwsFightResultPopUp:FindSocialShareObjs()
  self.screenShotHelper = self.gameObject:GetComponent(ScreenShotHelper)
  self.goUIViewSocialShare = self:FindGO("UIViewSocialShare")
  self.objBtnShare = self:FindGO("BtnShare")
end

function TeamPwsFightResultPopUp:RegisterButtonClickEvent()
  self:AddClickEvent(self:FindGO("WechatMoments", self.goUIViewSocialShare), function()
    self:OnClickForButtonWechatMoments()
  end)
  self:AddClickEvent(self:FindGO("Wechat", self.goUIViewSocialShare), function()
    self:OnClickForButtonWechat()
  end)
  self:AddClickEvent(self:FindGO("QQ", self.goUIViewSocialShare), function()
    self:OnClickForButtonQQ()
  end)
  self:AddClickEvent(self:FindGO("Sina", self.goUIViewSocialShare), function()
    self:OnClickForButtonSina()
  end)
  self:AddClickEvent(self.objBtnShare, function()
    if ApplicationInfo.IsRunOnWindowns() then
      MsgManager.ShowMsgByID(43486)
      return
    end
    self:Show(self.goUIViewSocialShare)
  end)
  self:AddClickEvent(self:FindGO("closeShare", self.goUIViewSocialShare), function()
    self:Hide(self.goUIViewSocialShare)
  end)
end

function TeamPwsFightResultPopUp:ROOShare()
  if BranchMgr.IsChina() then
    return
  end
  self.goButtonWechatMoments = self:FindGO("WechatMoments", self.goUIViewSocialShare)
  self.goButtonWechat = self:FindGO("Wechat", self.goUIViewSocialShare)
  self.goButtonQQ = self:FindGO("QQ", self.goUIViewSocialShare)
  self.goButtonSina = self:FindGO("Sina", self.goUIViewSocialShare)
  local sp = self.goButtonQQ:GetComponent(UISprite)
  IconManager:SetUIIcon("Facebook", sp)
  sp = self.goButtonWechat:GetComponent(UISprite)
  IconManager:SetUIIcon("Twitter", sp)
  sp = self.goButtonWechatMoments:GetComponent(UISprite)
  IconManager:SetUIIcon("line", sp)
  self:AddClickEvent(self.goButtonWechatMoments, function()
    self:sharePicture("line", "", "")
  end)
  self:AddClickEvent(self.goButtonWechat, function()
    self:sharePicture("twitter", "", "")
  end)
  self:AddClickEvent(self.goButtonQQ, function()
    self:sharePicture("Facebook", "", "")
  end)
  local lbl = self:FindGO("Label", self.goButtonWechatMoments):GetComponent(UILabel)
  lbl.text = "LINE"
  lbl = self:FindGO("Label", self.goButtonWechat):GetComponent(UILabel)
  lbl.text = "Twitter"
  lbl = self:FindGO("Label", self.goButtonQQ):GetComponent(UILabel)
  lbl.text = "Facebook"
  self.goButtonSina:SetActive(false)
  if not BranchMgr.IsJapan() then
    self.goButtonWechat:SetActive(false)
    self.goButtonWechatMoments:SetActive(false)
  end
end

function TeamPwsFightResultPopUp:OnClickForButtonWechatMoments()
  if SocialShare.Instance:IsClientValid(E_PlatformType.WechatMoments) then
    self:sharePicture(E_PlatformType.WechatMoments, "", "")
  else
    MsgManager.ShowMsgByIDTable(561)
  end
end

function TeamPwsFightResultPopUp:OnClickForButtonWechat()
  if SocialShare.Instance:IsClientValid(E_PlatformType.Wechat) then
    self:sharePicture(E_PlatformType.Wechat, "", "")
  else
    MsgManager.ShowMsgByIDTable(561)
  end
end

function TeamPwsFightResultPopUp:OnClickForButtonQQ()
  if SocialShare.Instance:IsClientValid(E_PlatformType.QQ) then
    self:sharePicture(E_PlatformType.QQ, "", "")
  else
    MsgManager.ShowMsgByIDTable(562)
  end
end

function TeamPwsFightResultPopUp:OnClickForButtonSina()
  if SocialShare.Instance:IsClientValid(E_PlatformType.Sina) then
    local contentBody = GameConfig.PhotographResultPanel_ShareDescription
    if contentBody == nil or #contentBody <= 0 then
      contentBody = "RO"
    end
    self:sharePicture(E_PlatformType.Sina, "", contentBody)
  else
    MsgManager.ShowMsgByIDTable(563)
  end
end

function TeamPwsFightResultPopUp:sharePicture(platform_type, content_title, content_body)
  self:startCaptureScreen(platform_type, content_title, content_body)
end

function TeamPwsFightResultPopUp:startCaptureScreen(platform_type, content_title, content_body)
  local ui = NGUIUtil:GetCameraByLayername("UI")
  local default = NGUIUtil:GetCameraByLayername("Default")
  self:changeUIState(true)
  self.screenShotHelper:Setting(self.screenShotWidth, self.screenShotHeight, self.textureFormat, self.texDepth, self.antiAliasing)
  self.screenShotHelper:GetScreenShot(function(texture)
    self:changeUIState(false)
    self:startSharePicture(texture, platform_type, content_title, content_body)
  end, ui, default)
end

function TeamPwsFightResultPopUp:changeUIState(isStart)
  if isStart then
    self:Hide(self.goUIViewSocialShare)
    self:Hide(self.objBtnShare)
  else
    self:Show(self.goUIViewSocialShare)
    self:Show(self.objBtnShare)
  end
end

function TeamPwsFightResultPopUp:startSharePicture(texture, platform_type, content_title, content_body)
  local picName = string.format("Ro_%s", tostring(os.time()))
  local path = string.format("%s/%s", PathUtil.GetSavePath(PathConfig.PhotographPath), picName)
  ScreenShot.SaveJPG(texture, path, 100)
  path = string.format("%s%s", path, ".jpg")
  self:Log("TeamPwsFightResultPopUp sharePicture pic path:", path)
  if not BranchMgr.IsChina() then
    local overseasManager = OverSeas_TW.OverSeasManager.GetInstance()
    if platform_type ~= "Facebook" then
      overseasManager:ShareImgWithChannel(path, content_title, OverseaHostHelper.Share_URL, content_body, platform_type, function(msg)
        redlog("msg" .. msg)
        ROFileUtils.FileDelete(path)
        if msg == "1" then
          Debug.Log("success")
        else
          MsgManager.FloatMsgTableParam(nil, ZhString.LineNotInstalled)
        end
      end)
      return
    end
    xdlog("startSharePicture", "fb 分享图片")
    overseasManager:ShareImg(path, content_title, OverseaHostHelper.Share_URL, content_body, function(msg)
      ROFileUtils.FileDelete(path)
      if msg == "1" then
        MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookShareSuccess)
      else
        MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookShareFailed)
      end
    end)
    return
  end
  SocialShare.Instance:ShareImage(path, content_title, content_body, platform_type, function(succMsg)
    self:Log("SocialShare.Instance:Share success")
    ROFileUtils.FileDelete(path)
    if platform_type == E_PlatformType.Sina then
      MsgManager.ShowMsgByIDTable(566)
    end
  end, function(failCode, failMsg)
    self:Log("SocialShare.Instance:Share failure")
    ROFileUtils.FileDelete(path)
    local errorMessage = failMsg or "error"
    if failCode then
      errorMessage = string.format("%s, %s", failCode, errorMessage)
    end
    MsgManager.ShowMsg("", errorMessage, 0)
  end, function()
    self:Log("SocialShare.Instance:Share cancel")
    ROFileUtils.FileDelete(path)
  end)
end

function TeamPwsFightResultPopUp:OnEnter()
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
      self.labMvpName.text = mvpName or ""
    end
    if viewdata.winTeamColor == PvpProxy.TeamPws.TeamColor.Red then
      self.isRedTeamWin = true
    elseif viewdata.winTeamColor == PvpProxy.TeamPws.TeamColor.Blue then
      self.isRedTeamWin = false
    else
      self.isRedTeamWin = nil
    end
  end
  self:CreateMvpPlayerRole()
  if self.reportPanel.InitData then
    self.reportPanel:InitData()
  elseif self.reportPanel.UpdateView then
    self.reportPanel:UpdateView()
  end
  self:SetTexturesAndEffects()
end

function TeamPwsFightResultPopUp:OnExit()
  PictureManager.Instance:UnLoadPVP(TeamPwsFightResultPopUp.TexMvpName, self.texMvp)
  PictureManager.Instance:UnLoadPVP(TeamPwsFightResultPopUp.ModelBg, self.modelRTBg)
  self:ClearTick()
  self:DestroyRoleModel()
  PvpProxy.Instance:ClearTeamPwsReportData()
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
