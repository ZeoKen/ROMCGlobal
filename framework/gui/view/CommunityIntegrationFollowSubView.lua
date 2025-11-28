CommunityIntegrationFollowSubView = class("CommunityIntegrationFollowSubView", SubView)
autoImport("ItemCell")
local viewPath = ResourcePathHelper.UIView("CommunityIntegrationFollowSubView")
local picIns = PictureManager.Instance
local bgTextureAppend = "community_bg_pic_"
local colorFormat = "[c][%s]%s[-][/c]"
local showConfig = {
  [1] = {
    BgTexture = "community_bg_pic_1",
    TitleColor = {"#E75E8B", "#BC65A7"},
    DescColor = {"#DE6EA2", "000000"},
    pos = Vector3(40.67, -4.5, 0)
  },
  [2] = {
    BgTexture = "community_bg_pic_2",
    TitleColor = {"#637DFF", "#9A70F7"},
    DescColor = {"#7D78E3", "1372F1"},
    pos = Vector3(194.52, -17.3, 0)
  },
  [3] = {
    BgTexture = "community_bg_pic_4",
    TitleColor = {"#E75E8B", "#BC65A7"},
    DescColor = {"#DE6EA2", "000000"},
    pos = Vector3(194.52, -17.3, 0)
  }
}

function CommunityIntegrationFollowSubView:Init()
  if self.inited then
    return
  end
  self:FindObjs()
  self:AddViewEvts()
  self:AddMapEvts()
  self:InitDatas()
  self.inited = true
end

function CommunityIntegrationFollowSubView:LoadSubView()
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.container, true)
  obj.name = "CommunityIntegrationFollowSubView"
end

function CommunityIntegrationFollowSubView:LoadCellPfb(cName, parent)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cName))
  if not cellpfb then
    return
  end
  cellpfb.transform:SetParent(parent.transform, false)
  cellpfb.transform.localPosition = LuaGeometry.GetTempVector3()
  return cellpfb
end

function CommunityIntegrationFollowSubView:FindObjs()
  self:LoadSubView()
  self.gameObject = self:FindGO("CommunityIntegrationFollowSubView")
  self.root = self:FindGO("Root", self.gameObject)
  self.titleLabel = self:FindGO("TitleLabel", self.root):GetComponent(UILabel)
  self.mainLabel = self:FindGO("Label1", self.root):GetComponent(UIRichLabel)
  self.mainLabel = SpriteLabel.new(self.mainLabel, nil, 20, 20, true)
  self.mainLabel.richLabel.overflowMethod = 3
  self.confirmBtn = self:FindGO("ConfirmBtn")
  self.confirmBtn_BoxCollider = self.confirmBtn:GetComponent(BoxCollider)
  self.confirmBtn_Label = self:FindGO("ConfirmLabel", self.confirmBtn):GetComponent(UILabel)
  self.itemContainer = self:FindGO("ItemContainer")
  self.itemContainer:SetActive(true)
  local itemGO = self:LoadPreferb("cell/ItemCell", self.itemContainer)
  self.itemCell = ItemCell.new(itemGO)
  self.rewardEffect = self:FindGO("RewardEffect")
  self.bgTexture = self:FindGO("Texture", self.gameObject):GetComponent(UITexture)
  self.decorate_3 = self:FindGO("Decorate_3", self.gameObject):GetComponent(UITexture)
end

function CommunityIntegrationFollowSubView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.ActivityCmdRewardInfoGlobalActivityCmd, self.RefreshFuncBtn)
end

function CommunityIntegrationFollowSubView:AddMapEvts()
end

function CommunityIntegrationFollowSubView:InitDatas()
end

function CommunityIntegrationFollowSubView:RefreshPage()
  xdlog("当前信息", self.type, self.community)
  local config = showConfig and showConfig[self.type]
  local targetPos = config and config.pos
  self.root.transform.localPosition = targetPos
  local titleColor = config and config.TitleColor
  self.titleLabel.gradientTop = LuaColor.TryParseHtmlToColor(titleColor[1])
  self.titleLabel.gradientBottom = LuaColor.TryParseHtmlToColor(titleColor[2])
  local mainColor = config and config.DescColor
  self.mainLabel.color = LuaColor.TryParseHtmlToColor(mainColor[1])
  local communityIconColor = mainColor[2]
  local communityIconName = "community_icon_" .. self.community
  local desc = self.staticData and self.staticData.Desc
  if desc then
    self.mainLabel:SetText(desc)
    self.mainLabel:SetText(desc)
  end
  self:ShowRewards()
  self:RefreshFuncBtn()
  xdlog(OverSea.LangManager.Instance().CurSysLang)
end

function CommunityIntegrationFollowSubView:ShowRewards()
  local config = GameConfig.Activity.FollowRewardAct
  if not config then
    redlog("未配置奖励")
    self.itemCell.gameObject:SetActive(false)
    return
  end
  self.itemCell.gameObject:SetActive(true)
  local reward = config[self.actID]
  if reward then
    local itemData = ItemData.new("Reward", reward[1])
    itemData:SetItemNum(reward[2])
    self.itemCell:SetData(itemData)
  else
    self.itemCell.gameObject:SetActive(false)
  end
end

function CommunityIntegrationFollowSubView:RefreshFuncBtn()
  local urlConfig = self.staticData and self.staticData.Url
  if not urlConfig then
    self.confirmBtn:SetActive(false)
  else
    self.confirmBtn:SetActive(true)
  end
  local isFinished = CommunityIntegrationProxy.Instance:CheckFollowIsFinished(self.actID)
  local isRewarded = CommunityIntegrationProxy.Instance:CheckFollowIsRewarded(self.actID)
  self.rewardEffect:SetActive(false)
  if not isFinished and not isRewarded then
    self.confirmBtn_Label.text = ZhString.GuildActivityCell_Go
    self:SetFuncBtnEnable(true)
    self:AddClickEvent(self.confirmBtn, function()
      self:GoToLink()
    end)
  elseif isFinished and not isRewarded then
    self.confirmBtn_Label.text = ZhString.RememberLoginView_OntimeOn
    self:SetFuncBtnEnable(true)
    self:AddClickEvent(self.confirmBtn, function()
      self:TryCallReward()
    end)
    self.rewardEffect:SetActive(true)
  elseif isFinished and isRewarded then
    self.confirmBtn_Label.text = ZhString.RememberLoginView_OntimeNo
    self:SetFuncBtnEnable(false)
  end
end

function CommunityIntegrationFollowSubView:SetFuncBtnEnable(bool)
  self.confirmBtn_BoxCollider.enabled = bool
  if bool then
    self:SetTextureWhite(self.confirmBtn, LuaColor.New(0.7686274509803922, 0.5254901960784314, 0, 1))
  else
    self:SetTextureGrey(self.confirmBtn)
  end
end

function CommunityIntegrationFollowSubView:GoToLink()
  local targetURL
  local curLang = OverSea.LangManager.Instance().CurSysLang
  local urlConfig = self.staticData.Url
  targetURL = urlConfig and urlConfig[curLang] or urlConfig.English
  xdlog("跳转链接", curLang, targetURL)
  if targetURL then
    ApplicationInfo.OpenUrl(targetURL)
  else
    LogUtility.Error("URL配置错误")
  end
  local type = ActivityCmd_pb.GACTIVITY_FOLLOW_REWARD
  ServiceActivityCmdProxy.Instance:CallFinishGlobalActivityCmd(type, self.actID)
end

function CommunityIntegrationFollowSubView:TryCallReward()
  xdlog("申请领奖")
  local type = ActivityCmd_pb.GACTIVITY_FOLLOW_REWARD
  ServiceActivityCmdProxy.Instance:CallFinishGlobalActivityCmd(type, nil, self.actID)
end

function CommunityIntegrationFollowSubView:OnEnter(data)
  local id = data.id
  local config = GameConfig.CommunityIntegration
  self.staticData = config and config[id]
  if not self.staticData then
    self.staticData = config and config.NoRewardAct and config.NoRewardAct[id]
  end
  self.actID = id
  self.type = self.staticData and self.staticData.ShowType or 1
  self.community = self.staticData and self.staticData.Community or "Facebook"
  CommunityIntegrationFollowSubView.super.OnEnter(self)
  picIns:SetUI(showConfig[self.type].BgTexture, self.bgTexture)
  picIns:SetUI("Community_bg_pic_3", self.decorate_3)
  self:RefreshPage()
end

function CommunityIntegrationFollowSubView:OnExit()
  CommunityIntegrationFollowSubView.super.OnExit(self)
  if self.type then
    picIns:UnLoadUI(showConfig[self.type].BgTexture, self.bgTexture)
  end
  picIns:UnLoadUI("Community_bg_pic_3", self.decorate_3)
end
