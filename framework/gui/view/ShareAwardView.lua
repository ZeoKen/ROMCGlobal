ShareAwardView = class("ShareAwardView", BaseView)
autoImport("PhotographResultPanel")
ShareAwardView.ViewType = UIViewType.ShareLayer
ShareAwardView.ShareType = {
  NormalShare = 1,
  SkadaShare = 2,
  RaidResultShare = 3
}

function ShareAwardView:Init()
  self:initView()
  self:initData()
end

function ShareAwardView:initView()
  self.objHolder = self:FindGO("objHolder")
  self.itemName = self:FindComponent("itemName", UILabel)
  self.Title = self:FindComponent("Title", UILabel)
  self.Container = self:FindGO("Container")
  self.SkadaContainer = self:FindGO("SkadaContainer")
  self.RaidResultContainer = self:FindGO("RaidResultContainer")
  self.objBgCt = self:FindGO("objBgCt")
  self.refineBg = self:FindGO("refineBg", self.objBgCt)
  self.closeBtn = self:FindGO("CloseButton")
  self.screenShotHelper = self.gameObject:GetComponent(ScreenShotHelper)
  self.ShareDescription = self:FindComponent("ShareDescription", UILabel)
  self.SubTitle = self:FindComponent("SubTitle", UILabel)
  self:Hide(self.SkadaContainer)
  self:GetGameObjects()
  self:RegisterButtonClickEvent()
  self.skada = {}
  self.skada.text1 = self:FindComponent("text1", UILabel, self.SkadaContainer)
  self.skada.text2 = self:FindComponent("text2", UILabel, self.SkadaContainer)
  self.skada.sum = self:FindComponent("sumvalue", UILabel, self.SkadaContainer)
  self.skada.dps = self:FindComponent("dpsvalue", UILabel, self.SkadaContainer)
  self.skada.skadainfo = self:FindComponent("skadainfo", UILabel, self.SkadaContainer)
  self.skada.name = self:FindComponent("name", UILabel, self.SkadaContainer)
  self.skada.level = self:FindComponent("level", UILabel, self.SkadaContainer)
  self.skada.profession = self:FindComponent("profession", UILabel, self.SkadaContainer)
  self.skada.skill1 = self:FindComponent("skill1", UISprite, self.SkadaContainer)
  self.skada.skill2 = self:FindComponent("skill2", UISprite, self.SkadaContainer)
  self.skada.myHeadCell = HeadIconCell.new()
  self.skada.myHeadCell:CreateSelf(self:FindGO("playerface", self.SkadaContainer))
  self.skada.objProfession = self:FindGO("professionicon", self.SkadaContainer)
  self.skada.sprProfessionIcon = self:FindComponent("Icon", UISprite, self.objProfession)
  self.skada.sprProfessionColor = self:FindComponent("Color", UISprite, self.objProfession)
  self.raidName = self:FindGO("Name", self.RaidResultContainer):GetComponent(UILabel)
  self.scoreLabel = self:FindGO("Score", self.RaidResultContainer):GetComponent(UILabel)
end

function ShareAwardView:FormatBufferStr(bufferId)
  local str = ItemUtil.getBufferDescById(bufferId)
  local result = ""
  local bufferStrs = string.split(str, "\n")
  for m = 1, #bufferStrs do
    local buffData = Table_Buffer[bufferId]
    local buffStr = ""
    if buffData then
      buffStr = string.format("{bufficon=%s} ", buffData.BuffIcon)
    end
    result = result .. buffStr .. bufferStrs[m] .. "\n"
  end
  if result ~= "" then
    result = string.sub(result, 1, -2)
  end
  return result
end

function ShareAwardView:SetSkadaInfo(data)
  if data.skillID then
    self.skada.skill1.gameObject:SetActive(true)
    self.skada.skill2.gameObject:SetActive(true)
    local skillSData = data.skillID and Table_Skill[data.skillID]
    local professionData = data.analysisData.profession and Table_Class[data.analysisData.profession]
    IconManager:SetSkillIconByProfess(skillSData and skillSData.Icon, self.skada.skill1, professionData and professionData.Type, true)
    IconManager:SetSkillIconByProfess(skillSData and skillSData.Icon, self.skada.skill2, professionData and professionData.Type, true)
    self.skada.text1.text = ZhString.ShareAwardView_SkadaSkillText1
    self.skada.text2.text = ZhString.ShareAwardView_SkadaSkillText2
  else
    self.skada.skill1.gameObject:SetActive(false)
    self.skada.skill2.gameObject:SetActive(false)
    self.skada.text1.text = ZhString.ShareAwardView_SkadaSumText1
    self.skada.text2.text = ZhString.ShareAwardView_SkadaSumText2
  end
  local myHeadData = HeadImageData.new()
  myHeadData:TransByDamageUserData(data.analysisData)
  if myHeadData.iconData.type == HeadImageIconType.Avatar then
    self.skada.myHeadCell:SetData(myHeadData.iconData)
  elseif myHeadData.iconData.type == HeadImageIconType.Simple then
    self.skada.myHeadCell:SetSimpleIcon(myHeadData.icon, myHeadData.frameType)
  end
  local proData = Table_Class[data.analysisData.profession]
  if proData then
    local setSuccess = IconManager:SetNewProfessionIcon(proData.icon, self.skada.sprProfessionIcon)
    self.skada.objProfession:SetActive(setSuccess == true)
    if setSuccess then
      self.skada.sprProfessionColor.color = ProfessionProxy.Instance:SafeGetColorFromColorUtil("CareerIconBg" .. proData.Type)
    end
  else
    self.skada.objProfession:SetActive(false)
    LogUtility.Error(string.format("Cannot find %d in Table_Class", data.profession))
  end
  self.skada.name.text = data.analysisData.name
  self.skada.level.text = "Lv." .. tostring(data.analysisData.baselevel)
  self.skada.profession.text = ProfessionProxy.GetProfessionNameFromSocialData(data.analysisData)
  self.skada.dps.text = string.format("%.1f", data.averageDamage)
  self.skada.sum.text = data.totalDamage
  local settingStr = ZhString.ShareAwardView_SkadaSettings
  if data.raceName then
    settingStr = settingStr .. string.format(ZhString.ShareAwardView_SkadaSettings1, data.raceName)
  end
  if data.natureName then
    settingStr = settingStr .. string.format(ZhString.ShareAwardView_SkadaSettings2, data.natureName)
  end
  if data.damageReduce then
    settingStr = settingStr .. string.format(ZhString.ShareAwardView_SkadaSettings3, data.damageReduce)
  end
  if data.shapeName then
    settingStr = settingStr .. string.format(ZhString.ShareAwardView_SkadaSettings4, data.shapeName)
  end
  self.skada.skadainfo.text = settingStr
end

function ShareAwardView:SetRaidResultInfo(data)
  local raidName = data.raidName
  self.raidName.text = raidName or ".."
  local score = data.score or 0
  self.scoreLabel.text = string.format(ZhString.IPRaidBord_CellScore, score)
end

function ShareAwardView:setItemProperty(data)
  local label = ""
  if data.itemData.cardInfo then
    local bufferIds = data.itemData.cardInfo.BuffEffect.buff
    for i = 1, #bufferIds do
      local str = ItemUtil.getBufferDescById(bufferIds[i])
      local bufferStrs = string.split(str, "\n")
      for j = 1, #bufferStrs do
        local cardTip = bufferStrs[j]
        label = label .. cardTip .. "\n"
      end
    end
    label = string.sub(label, 1, -2)
    self.ShareDescription.alignment = 0
  elseif data.effectFromType == FloatAwardView.EffectFromType.RefineType then
    label = ZhString.ShareAwardView_RefineProperty .. " : +" .. data.itemData.equipInfo.refinelv .. "\n"
    label = label .. data.itemData.equipInfo:RefineInfo()
    self.ShareDescription.alignment = 0
  elseif data.showType == FloatAwardView.ShowType.ItemType then
    label = ZhString.ItemTip_Desc .. tostring(data.itemData.staticData.Desc)
    self.ShareDescription.alignment = 1
  elseif data.itemData.equipInfo then
    local equipInfo = data.itemData.equipInfo
    local uniqueEffect = equipInfo:GetUniqueEffect()
    if uniqueEffect and 0 < #uniqueEffect then
      local special = {}
      special.label = {}
      for i = 1, #uniqueEffect do
        local id = uniqueEffect[i].id
        label = label .. self:FormatBufferStr(id) .. "\n"
      end
      label = string.sub(label, 1, -2)
    end
    self.ShareDescription.alignment = 0
  end
  if label ~= "" then
    self.ShareDescription.text = label
  else
    self.ShareDescription.text = ""
  end
end

function ShareAwardView:OnEnter()
  self:SetData(self.viewdata.viewdata)
  local manager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera]
  manager_Camera:ActiveMainCamera(false)
  self.bgTexture = self:FindComponent("refineBg", UITexture)
  if self.bgTexture then
    PictureManager.Instance:SetUI("share_meizi", self.bgTexture)
  end
  local parent = self.Container.transform
  local effectPath = ResourcePathHelper.EffectCommon("ShareAwardView")
  self.focusEffect = Game.AssetManager_UI:CreateAsset(effectPath, parent)
end

function ShareAwardView:SetData(data)
  if data.shareType then
    self.shareType = data.shareType
  else
    self.shareType = ShareAwardView.ShareType.NormalShare
  end
  self.data = data
  if self.shareType == ShareAwardView.ShareType.SkadaShare then
    self:Show(self.SkadaContainer)
    self:Hide(self.Container)
    self:Hide(self.RaidResultContainer)
    self:SetSkadaInfo(data)
  elseif self.shareType == ShareAwardView.ShareType.RaidResultShare then
    self:Hide(self.Container)
    self:Hide(self.SkadaContainer)
    self:Show(self.RaidResultContainer)
    self:SetRaidResultInfo(data)
  else
    self:Hide(self.SkadaContainer)
    self:Hide(self.RaidResultContainer)
    self:Show(self.Container)
    self.itemName.text = data.itemData.staticData.NameZh
    if data.effectFromType == FloatAwardView.EffectFromType.RefineType then
      self.Title.text = ZhString.ShareAwardView_RefineSus
      data.showType = FloatAwardView.ShowType.ItemType
      self:Show(self.objBgCt)
      self:Show(self.refineBg)
      self:Show(self.SubTitle)
      self.SubTitle.text = "+" .. data.itemData.equipInfo.refinelv
    elseif data.showType == FloatAwardView.ShowType.CardType then
      self.Title.text = ZhString.ShareAwardView_GetCard
      self:Show(self.objBgCt)
      self:Hide(self.SubTitle.gameObject)
    else
      self.Title.text = ZhString.ShareAwardView_GetItem
      data.showType = FloatAwardView.ShowType.ItemType
      self:Show(self.objBgCt)
      self:Show(self.refineBg)
      self:Hide(self.SubTitle.gameObject)
    end
    local obj = data:getModelObj(self.objHolder)
    if data.showType == FloatAwardView.ShowType.CardType and obj then
      obj.transform.localPosition = LuaGeometry.Const_V3_zero
      obj.transform.localScale = LuaGeometry.GetTempVector3(0.8, 0.8, 0.8)
    elseif data.effectFromType == FloatAwardView.EffectFromType.RefineType and obj then
      obj.transform.localPosition = LuaGeometry.Const_V3_zero
      obj.transform.localScale = LuaGeometry.GetTempVector3(1.624, 1.624, 1.624)
    elseif data.showType == FloatAwardView.ShowType.ItemType and obj then
      obj.transform.localScale = LuaGeometry.GetTempVector3(1.624, 1.624, 1.624)
    end
    self:setItemProperty(data)
  end
end

function ShareAwardView:GetGameObjects()
  self.goUIViewSocialShare = self:FindGO("UIViewSocialShare", self.gameObject)
  self.goButtonWechatMoments = self:FindGO("Wechat", self.goUIViewSocialShare)
  self.goButtonQQ = self:FindGO("QQ", self.goUIViewSocialShare)
  self.goButtonSina = self:FindGO("Sina", self.goUIViewSocialShare)
  if not BranchMgr.IsChina() then
    local sp = self:FindComponent("Sina1", UISprite, self.goButtonSina)
    sp.spriteName = "share_icon_Facebook"
    sp = self:FindComponent("Wechat222", UISprite, self.goButtonWechatMoments)
    sp.spriteName = "share_icon_LINE"
    sp = self:FindComponent("QQ1", UISprite, self.goButtonQQ)
    sp.spriteName = "share_icon_Twitter"
    self.goButtonQQ:SetActive(false)
    if not BranchMgr.IsJapan() then
      self.goButtonQQ:SetActive(false)
      self.goButtonWechatMoments:SetActive(false)
      self:FindComponent("Sina1", UISprite, self.goButtonSina).width = 42
    end
    self:FindGO("bg2ss"):SetActive(false)
  end
end

function ShareAwardView:RegisterButtonClickEvent()
  if not BranchMgr.IsChina() then
    self:AddClickEvent(self.goButtonWechatMoments, function()
      self:sharePicture("line", "", "")
    end)
    self:AddClickEvent(self.goButtonQQ, function()
      self:sharePicture("twitter", OverseaHostHelper.TWITTER_MSG, "")
    end)
    if BranchMgr.IsJapan() then
      self:Hide(self.goButtonQQ)
    end
    self:AddClickEvent(self.goButtonSina, function()
      self:sharePicture("fb", "", "")
    end)
    return
  end
  self:AddClickEvent(self.goButtonWechatMoments, function()
    self:OnClickForButtonWechatMoments()
  end)
  self:AddClickEvent(self.goButtonQQ, function()
    self:OnClickForButtonQQ()
  end)
  self:AddClickEvent(self.goButtonSina, function()
    self:OnClickForButtonSina()
  end)
end

function ShareAwardView:OnClickForButtonWechatMoments()
  if SocialShare.Instance:IsClientValid(E_PlatformType.WechatMoments) then
    self:sharePicture(E_PlatformType.WechatMoments, "", "")
  else
    MsgManager.ShowMsgByIDTable(561)
  end
end

function ShareAwardView:OnClickForButtonQQ()
  if SocialShare.Instance:IsClientValid(E_PlatformType.QQ) then
    self:sharePicture(E_PlatformType.QQ, "", "")
  else
    MsgManager.ShowMsgByIDTable(562)
  end
end

function ShareAwardView:OnClickForButtonSina()
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

function ShareAwardView:startSharePicture(texture, platform_type, content_title, content_body)
  local picName = PhotographResultPanel.picNameName .. tostring(os.time())
  local path = PathUtil.GetSavePath(PathConfig.PhotographPath) .. "/" .. picName
  ScreenShot.SaveJPG(texture, path, 100)
  path = path .. ".jpg"
  self:Log("ShareAwardView sharePicture pic path:", path)
  if BranchMgr.IsChina() then
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
      if failCode ~= nil then
        errorMessage = failCode .. ", " .. errorMessage
      end
      MsgManager.ShowMsg("", errorMessage, 0)
    end, function()
      self:Log("SocialShare.Instance:Share cancel")
      ROFileUtils.FileDelete(path)
    end)
    return
  end
  local overseasManager = OverSeas_TW.OverSeasManager.GetInstance()
  if platform_type ~= "fb" then
    xdlog("startSharePicture", platform_type .. "分享")
    overseasManager:ShareImgWithChannel(path, content_title, OverseaHostHelper.Share_URL, content_body, platform_type, function(msg)
      redlog("msg" .. msg)
      ROFileUtils.FileDelete(path)
      if msg == "1" then
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
end

function ShareAwardView:sharePicture(platform_type, content_title, content_body)
  self:startCaptureScreen(platform_type, content_title, content_body)
end

function ShareAwardView:startCaptureScreen(platform_type, content_title, content_body)
  local ui = NGUIUtil:GetCameraByLayername("UI")
  self:changeUIState(true)
  self.screenShotHelper:Setting(self.screenShotWidth, self.screenShotHeight, self.textureFormat, self.texDepth, self.antiAliasing)
  self.screenShotHelper:GetScreenShot(function(texture)
    self:changeUIState(false)
    self:startSharePicture(texture, platform_type, content_title, content_body)
  end, ui)
end

function ShareAwardView:changeUIState(isStart)
  if isStart then
    self:Hide(self.goUIViewSocialShare)
    self:Hide(self.closeBtn)
  else
    self:Show(self.goUIViewSocialShare)
    self:Show(self.closeBtn)
  end
end

function ShareAwardView:initData()
  self.screenShotWidth = -1
  self.screenShotHeight = 1080
  self.textureFormat = TextureFormat.RGB24
  self.texDepth = 24
  self.antiAliasing = ScreenShot.AntiAliasing.None
end

function ShareAwardView:OnExit()
  if self.shareType ~= ShareAwardView.ShareType.SkadaShare and self.shareType ~= ShareAwardView.ShareType.RaidResultShare and self.data then
    self.data:Exit()
  end
  local manager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera]
  manager_Camera:ActiveMainCamera(true)
  if self.bgTexture then
    PictureManager.Instance:UnLoadUI("share_meizi", self.bgTexture)
  end
end
