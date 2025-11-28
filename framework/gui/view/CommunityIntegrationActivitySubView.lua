CommunityIntegrationActivitySubView = class("CommunityIntegrationActivitySubView", SubView)
autoImport("ItemCell")
local viewPath = ResourcePathHelper.UIView("ActivityIntegrationPreviewSubView")
local picIns = PictureManager.Instance
local decorateTextureNameMap = {
  [1] = {
    Gift_01 = "activityintegration_bg_gift_01",
    Gift_02 = "activityintegration_bg_gift_02",
    Gift_03 = "activityintegration_bg_gift_03",
    Ornament = "activityintegration_bg_ornament",
    Bg_title = "activityintegration_bg_title",
    Bg_01 = "activityintegration_bg_01"
  },
  [2] = {
    Bg_title = "paidactivity_bg_title_02"
  },
  [4] = {
    Bg_title = "paidactivity_bg_title_02"
  }
}

function CommunityIntegrationActivitySubView:Init()
  if self.inited then
    return
  end
  self:FindObjs()
  self:AddViewEvts()
  self:AddMapEvts()
  self:InitDatas()
  self.inited = true
end

function CommunityIntegrationActivitySubView:LoadSubView()
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.container, true)
  obj.name = "CommunityIntegrationActivitySubView"
end

function CommunityIntegrationActivitySubView:LoadCellPfb(cName, parent)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cName))
  if not cellpfb then
    return
  end
  cellpfb.transform:SetParent(parent.transform, false)
  cellpfb.transform.localPosition = LuaGeometry.GetTempVector3()
  return cellpfb
end

function CommunityIntegrationActivitySubView:FindObjs()
  self:LoadSubView()
  self.gameObject = self:FindGO("CommunityIntegrationActivitySubView")
  self.showType = 1
  for i = 1, 4 do
    local targetRoot = self:FindGO("Root" .. i, self.gameObject)
    if targetRoot then
      targetRoot:SetActive(i == self.showType)
      if i == self.showType then
        self.curRoot = targetRoot
      end
    elseif i == self.showType then
      local rootGO = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIPart("ActivityIntegrationPreview_Root" .. self.showType))
      rootGO.name = "Root" .. i
      rootGO.transform:SetParent(self.gameObject.transform, false)
      rootGO:SetActive(true)
      self.curRoot = rootGO
      local upPanel = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIPanel)
      local panels = rootGO:GetComponentsInChildren(UIPanel)
      for i = 1, #panels do
        panels[i].depth = upPanel.depth + panels[i].depth
      end
    end
  end
  self.curRoot = self["Root" .. self.showType]
  self.helpBtn = self:FindGO("HelpBtn", self.curRoot)
  local titleGO = self:FindGO("TitleLabel", self.curRoot)
  if titleGO then
    self.titleLabel = titleGO:GetComponent(UILabel)
    self.titleShadowLabel = self:FindGO("TitleLabelShadow", self.curRoot):GetComponent(UILabel)
  end
  self.bgTexture = self:FindGO("BgTexture", self.curRoot):GetComponent(UITexture)
  self.timeLabel = self:FindGO("TimeLabel", self.curRoot):GetComponent(UILabel)
  local descGO = self:FindGO("DescLabel", self.curRoot)
  if descGO then
    self.descLabel = descGO:GetComponent(UILabel)
  end
  local innerBGGO = self:FindGO("DescInnerBg", self.curRoot)
  if innerBGGO then
    self.descInnerBg = innerBGGO:GetComponent(UISprite)
  end
  local descOutlineGO = self:FindGO("DescOutline", self.curRoot)
  if descOutlineGO then
    self.descOutline = descOutlineGO:GetComponent(UISprite)
  end
  self.goToBtn = self:FindGO("GoToBtn", self.curRoot)
  self.goToBtn_Label = self:FindGO("Label", self.goToBtn):GetComponent(UILabel)
  self.goToBtn_BoxCollider = self.goToBtn:GetComponent(BoxCollider)
  self.timeLabels = {}
  self.timeLabelContainer = self:FindGO("TimeLabelContainer", self.curRoot)
  if self.timeLabelContainer then
    local childCount = self.timeLabelContainer.gameObject.transform.childCount or 0
    if 0 < childCount then
      for i = 1, childCount do
        local go = self:FindGO("Label" .. i, self.timeLabelContainer)
        if go then
          local label = go:GetComponent(UILabel)
          self.timeLabels[i] = label
          self.timeLabels[i].gameObject:SetActive(false)
        end
      end
    end
  end
  if decorateTextureNameMap and decorateTextureNameMap[self.showType] then
    for objName, _ in pairs(decorateTextureNameMap[self.showType]) do
      self[objName] = self:FindComponent(objName, UITexture, self.curRoot)
    end
  end
end

function CommunityIntegrationActivitySubView:AddViewEvts()
end

function CommunityIntegrationActivitySubView:AddMapEvts()
  self:AddListenEvt(LotteryEvent.MagicPictureComplete, self.HandlePicture)
  self:AddListenEvt(ServiceEvent.ActivityEventActivityEventUserDataNtf, self.RefreshFuncBtn)
end

function CommunityIntegrationActivitySubView:InitDatas()
end

function CommunityIntegrationActivitySubView:RefreshPage()
  xdlog("活动信息")
  if not self.config then
    redlog("无活动信息")
    return
  end
  self.titleLabel.text = self.config.name or "?"
  self.titleShadowLabel.text = self.config.name or "?"
  self.descLabel.text = self.config.desc or "???"
  local descStr = self.config.desc or "???"
  if descStr and descStr ~= "" then
    self.descLabel.gameObject:SetActive(true)
    self.descLabel.text = descStr
    local printedY = self.descLabel.printedSize.y
    if self.descInnerBg then
      self.descInnerBg.height = printedY + 14
    end
    if self.descOutline then
      self.descOutline.height = printedY + 16
    end
  else
    self.descLabel.gameObject:SetActive(false)
  end
  self:RefreshFuncBtn()
  local photourl = self.config.photourl
  xdlog("url", photourl)
  if photourl then
    local bytes = LotteryProxy.Instance:DownloadMagicPicFromUrl(photourl)
    if self.picUrl ~= photourl then
      self.picUrl = photourl
    end
    if bytes then
      self:UpdatePicture(bytes)
    else
      self.bgTexture.mainTexture = nil
    end
  end
  TimeTickManager.Me():ClearTick(self, 1)
  TimeTickManager.Me():CreateTick(0, 10000, self.UpdateLeftTime, self)
end

function CommunityIntegrationActivitySubView:UpdateLeftTime()
  local leftTime = self.endTime - ServerTime.CurServerTime() / 1000
  if 0 < leftTime then
    local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(leftTime)
    if 0 < day then
      timeText = string.format(ZhString.PlayerTip_ExpireTime, day)
      self.timeLabel.text = timeText .. ZhString.PlayerTip_Day
    else
      timeText = string.format("%02d:%02d:%02d", hour, min, sec)
      self.timeLabel.text = string.format(ZhString.PlayerTip_ExpireTime, timeText)
    end
  else
    TimeTickManager.Me():ClearTick(self, 1)
    self.timeLabel.text = ZhString.RememberLoginView_OntimeEnd
  end
end

function CommunityIntegrationActivitySubView:HandlePicture(note)
  local data = note.body
  if data and self.picUrl == data.picUrl then
    self:UpdatePicture(data.bytes)
  end
end

function CommunityIntegrationActivitySubView:UpdatePicture(bytes)
  xdlog("图片刷新")
  local texture = Texture2D(0, 0, TextureFormat.RGB24, false)
  local ret = ImageConversion.LoadImage(texture, bytes)
  if ret then
    self.bgTexture.mainTexture = texture
  end
end

function CommunityIntegrationActivitySubView:ShowRewards()
  if not self.rewards or #self.rewards == 0 then
    redlog("没有奖励")
    self.itemCell.gameObject:SetActive(false)
    return
  end
  self.itemCell.gameObject:SetActive(true)
  local reward = self.rewards[1]
  if reward then
    local itemData = ItemData.new("Reward", reward[1])
    itemData:SetItemNum(reward[2])
    self.itemCell:SetData(itemData)
  end
end

function CommunityIntegrationActivitySubView:RefreshFuncBtn()
  xdlog("RefreshFuncBtn  refresh")
  local isFinished = CommunityIntegrationProxy.Instance:CheckCommunityActIsFinished(self.actID)
  local isRewarded = CommunityIntegrationProxy.Instance:CheckCommunityActIsRewarded(self.actID)
  if isRewarded then
    self.goToBtn_Label.text = ZhString.GuildActivityCell_Go
    self:SetFuncBtnEnable(true)
    self:AddClickEvent(self.goToBtn, function()
      self:GoToLink(false)
    end)
  elseif not isFinished then
    self.goToBtn_Label.text = ZhString.GuildActivityCell_Go
    self:SetFuncBtnEnable(true)
    self:AddClickEvent(self.goToBtn, function()
      self:GoToLink(true)
    end)
  else
    self.goToBtn_Label.text = ZhString.RememberLoginView_OntimeOn
    self:SetFuncBtnEnable(true)
    self:AddClickEvent(self.goToBtn, function()
      self:TryCallReward()
    end)
  end
end

function CommunityIntegrationActivitySubView:SetFuncBtnEnable(bool)
  self.goToBtn_BoxCollider.enabled = bool
  if bool then
    self:SetTextureWhite(self.goToBtn, LuaColor.New(0.7686274509803922, 0.5254901960784314, 0, 1))
  else
    self:SetTextureGrey(self.goToBtn)
  end
end

function CommunityIntegrationActivitySubView:GoToLink(send)
  local targetURL = self.config.url
  xdlog("跳转链接", targetURL)
  if targetURL then
    ApplicationInfo.OpenUrl(targetURL)
  else
    LogUtility.Error("URL配置错误")
  end
  if send then
    local type = ActivityEventType.Community
    ServiceActivityEventProxy.Instance:CallFinishActivityEventCmd(type, self.actID)
    xdlog("申请完成", type, self.actID)
  end
end

function CommunityIntegrationActivitySubView:TryCallReward()
  local type = ActivityEventType.Community
  xdlog("申请领奖", type, self.actID)
  ServiceActivityEventProxy.Instance:CallFinishActivityEventCmd(type, nil, self.actID)
end

function CommunityIntegrationActivitySubView:OnEnter(data)
  self.showType = 1
  self.actID = data.id
  self.config = data.config
  self.rewards = data.rewards or {}
  self.endTime = data.endTime and KFCARCameraProxy.Instance:GetSelfCustomDate(data.endTime)
  xdlog("活动ID", self.actID)
  if self.Ornament then
    self.Ornament.gameObject:SetActive(false)
  end
  self:RefreshPage()
end

function CommunityIntegrationActivitySubView:OnExit()
  TimeTickManager.Me():ClearTick(self)
  CommunityIntegrationActivitySubView.super.OnExit(self)
  for i = 1, 1 do
    if decorateTextureNameMap[i] then
      for objName, texName in pairs(decorateTextureNameMap[i]) do
        picIns:UnLoadUI(texName, self[objName])
      end
    end
  end
end
