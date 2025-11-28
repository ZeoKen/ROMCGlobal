autoImport("BattlePassLevelView")
autoImport("BattlePassExchangeView")
autoImport("BattlePassRankView")
autoImport("BattlePassUpgradeView")
autoImport("BattlePassPreviewView")
autoImport("BattlePassBuyLevelCell")
autoImport("BattlePassTaskView")
ServantBattlePassView = class("ServantBattlePassView", ContainerView)
ServantBattlePassView.ViewType = UIViewType.NormalLayer
local BTN_BG_IMG = {
  "taskmanual_btn_1",
  "taskmanual_btn_2"
}
local BTN_BG_IMG2 = {
  "taskmanual_btn_3",
  "taskmanual_btn_3b"
}
ServantBattlePassView._ColorEffectBlue = Color(0.25882352941176473, 0.4823529411764706, 0.7568627450980392, 1)
ServantBattlePassView._ColorTitleGray = ColorUtil.TitleGray
local ColorEffectOrange = ColorUtil.ButtonLabelOrange
local ColorEffectBlue = ColorUtil.ButtonLabelBlue
local replacePosY = -16
local patternBgName = "team_bg_pattern_12"
local bgTexName = "calendar_bg"

function ServantBattlePassView:Init()
  self:InitView()
  self:AddToggleEvts()
  self:AddViewEvents()
  self:SwitchToLevelView()
  ServiceBattlePassProxy.Instance:CallBattlePassQuestInfoCmd()
end

function ServantBattlePassView:OnEnter()
  ServantBattlePassView.super.OnEnter(self)
  self:UpdateExpInfo()
  PictureManager.Instance:SetUI(patternBgName, self.pattern1Tex)
  PictureManager.Instance:SetUI(patternBgName, self.pattern2Tex)
  PictureManager.Instance:SetUI(bgTexName, self.bgTex)
  PictureManager.ReFitFullScreen(self.bgTex)
end

function ServantBattlePassView:OnExit()
  ServantBattlePassView.super.OnExit(self)
  PictureManager.Instance:UnLoadUI(patternBgName, self.pattern1Tex)
  PictureManager.Instance:UnLoadUI(patternBgName, self.pattern2Tex)
  PictureManager.Instance:UnLoadUI(bgTexName, self.bgTex)
end

function ServantBattlePassView:SwitchToLevelView()
  if not self.levelView then
    self.levelView = self:AddSubView("BattlePassLevelView", BattlePassLevelView)
  end
  self:SetToggleBtn(1)
  self.expPanel:SetActive(true)
  self.exhibitPanel:SetActive(true)
  self:UpdateExhibition()
  self:Show(self.levelPos)
  self:Hide(self.exchangePos)
  self:Hide(self.rankPos)
  self:Hide(self.upgradePos)
  self.levelView:OnEnter()
end

function ServantBattlePassView:SwitchToExchangeView()
  if not self.exchangeView then
    self.exchangeView = self:AddSubView("BattlePassExchangeView", BattlePassExchangeView)
  end
  self:SetToggleBtn(2)
  self.expPanel:SetActive(true)
  self.exhibitPanel:SetActive(true)
  self:UpdateExhibition()
  self:Hide(self.levelPos)
  self:Show(self.exchangePos)
  self:Hide(self.rankPos)
  self:Hide(self.upgradePos)
  self.exchangeView:OnEnter()
end

function ServantBattlePassView:SwitchToRankView()
  if not self.rankView then
    self.rankView = self:AddSubView("BattlePassRankView", BattlePassRankView)
  end
  self:SetToggleBtn(3)
  self.expPanel:SetActive(false)
  self.exhibitPanel:SetActive(true)
  self:UpdateExhibition()
  self:Hide(self.levelPos)
  self:Hide(self.exchangePos)
  self:Show(self.rankPos)
  self:Hide(self.upgradePos)
  self.rankView:OnEnter()
end

function ServantBattlePassView:AddToggleEvts()
  self:RegistShowGeneralHelpByHelpID(8000002, self.helpBtn)
  self:AddClickEvent(self.levelBtn, function(go)
    self:SwitchToLevelView()
  end)
  self:AddClickEvent(self.exchangeBtn, function(go)
    self:SwitchToExchangeView()
  end)
  self:AddClickEvent(self.rankBtn, function(go)
    self:SwitchToRankView()
  end)
end

function ServantBattlePassView:SetToggleBtn(var)
  if var == 2 then
    self.rankLab.effectColor = ColorEffectBlue
    self.exchangeLab.effectColor = ColorEffectOrange
    self.levelLab.effectColor = ColorEffectBlue
    self.rankBtnImg.spriteName = BTN_BG_IMG[1]
    self.exchangeBtnImg.spriteName = BTN_BG_IMG2[2]
    self.levelBtnImg.spriteName = BTN_BG_IMG[1]
  elseif var == 3 then
    self.rankLab.effectColor = ColorEffectOrange
    self.exchangeLab.effectColor = ColorEffectBlue
    self.levelLab.effectColor = ColorEffectBlue
    self.rankBtnImg.spriteName = BTN_BG_IMG[2]
    self.exchangeBtnImg.spriteName = BTN_BG_IMG2[1]
    self.levelBtnImg.spriteName = BTN_BG_IMG[1]
  else
    self.rankLab.effectColor = ColorEffectBlue
    self.exchangeLab.effectColor = ColorEffectBlue
    self.levelLab.effectColor = ColorEffectOrange
    self.rankBtnImg.spriteName = BTN_BG_IMG[1]
    self.exchangeBtnImg.spriteName = BTN_BG_IMG2[1]
    self.levelBtnImg.spriteName = BTN_BG_IMG[2]
  end
end

function ServantBattlePassView:InitView()
  self.levelBtn = self:FindGO("LevelTog")
  self:RegisterRedTipCheck(BattlePassProxy.WholeRedTipID, self.levelBtn, 9, {-10, -4})
  self.exchangeBtn = self:FindGO("ExchangeTog")
  self.rankBtn = self:FindGO("RankTog")
  self.levelBtnImg = self.levelBtn:GetComponent(UISprite)
  self.exchangeBtnImg = self.exchangeBtn:GetComponent(UISprite)
  self.rankBtnImg = self.rankBtn:GetComponent(UISprite)
  self.levelLab = self:FindComponent("Lab", UILabel, self.levelBtn)
  self.levelLab.text = ZhString.Servant_BattlePass_LevelTogLab
  self.exchangeLab = self:FindComponent("Lab", UILabel, self.exchangeBtn)
  self.exchangeLab.text = ZhString.Servant_BattlePass_ExchangeTogLab
  self.rankLab = self:FindComponent("Lab", UILabel, self.rankBtn)
  self.rankLab.text = ZhString.Servant_BattlePass_RankTogLab
  self.levelPos = self:FindGO("levelViewPos")
  self.exchangePos = self:FindGO("exchangeViewPos")
  self.rankPos = self:FindGO("rankViewPos")
  self.upgradePos = self:FindGO("upgradeViewPos")
  self.previewPos = self:FindGO("previewViewPos")
  self.taskViewPos = self:FindGO("taskViewPos")
  self.helpBtn = self:FindGO("HelpBtn")
  self:AddButtonEvent("CloseButton", function()
    if self.upgradePos and self.upgradePos.activeSelf then
      self:SwitchToLevelView()
    else
      self:CloseSelf()
    end
  end)
  self.bgTex = self:FindComponent("BgTex", UITexture)
  self.expPanel = self:FindGO("ExpPanel")
  self.exp_levelLab = self:FindComponent("levellb", UILabel, self.expPanel)
  self.exp_expLab = self:FindComponent("explb", UILabel, self.expPanel)
  self.exp_expSlider = self:FindComponent("expslider", UISlider, self.expPanel)
  self.exp_explimitLab = self:FindComponent("explimitlb", UILabel, self.expPanel)
  self:FindComponent("text1", UILabel, self.expPanel).text = ZhString.ServantBattlePassView_text1
  self:FindComponent("text3", UILabel, self.expPanel).text = ZhString.ServantBattlePassView_text3
  self:AddClickEvent(self:FindGO("buylevelbtn"), function()
    self:ShowBuyLevel()
  end)
  local hasColl = BattlePassProxy.Instance:HasColPass()
  local pos = self.expPanel.transform.localPosition
  if hasColl then
    self.expPanel.transform.localPosition = LuaGeometry.GetTempVector3(pos[1], 0, pos[3])
  else
    self.expPanel.transform.localPosition = LuaGeometry.GetTempVector3(pos[1], replacePosY, pos[3])
  end
  self.exhibitPanel = self:FindGO("ExhibitPanel")
  self.exhibitVersionTitle = self:FindComponent("exhibitVersionTitle", UILabel, self.exhibitPanel)
  self.exhibitBg1 = self:FindGO("bg1", self.exhibitPanel)
  self.exhibitBg2 = self:FindGO("bg2", self.exhibitPanel)
  self.exhibitDefault = self:FindGO("default", self.exhibitPanel)
  self.exhibitDefaultIcon = self:FindComponent("defaultIcon", UISprite, self.exhibitPanel)
  self.exhibitDefault1 = self:FindComponent("default1", UILabel, self.exhibitPanel)
  self.exhibitDefault2 = self:FindComponent("default2", UILabel, self.exhibitPanel)
  self.exhibitShow = self:FindGO("show", self.exhibitPanel)
  self.iconHolder = self:FindGO("iconHolder", self.exhibitPanel)
  self.itemModelHolder = self:FindGO("itemModelHolder", self.exhibitPanel)
  self.itemModelTex = self.itemModelHolder:GetComponent(UITexture)
  self.charModelHolder = self:FindGO("charModelHolder", self.exhibitPanel)
  self.charModelTex = self.charModelHolder:GetComponent(UITexture)
  self.exhibitText = self:FindGO("text", self.exhibitPanel)
  self.exhibitTitle = self:FindComponent("exhibitTitle", UILabel, self.exhibitPanel)
  self.exhibitDesc = self:FindComponent("exhibitDesc", UILabel, self.exhibitPanel)
  self.exhibitDescSv = self:FindComponent("DescScrollview", UIScrollView, self.exhibitPanel)
  local taskBtn = self:FindGO("taskBtn")
  self:AddClickEvent(taskBtn, function()
    self:ShowTaskPanel()
  end)
  self.pattern1Tex = self:FindComponent("pattern1", UITexture)
  self.pattern2Tex = self:FindComponent("pattern2", UITexture)
  if BattlePassProxy.Instance:HasExchangeShop() then
    self.levelBtn.transform.localPosition = LuaGeometry.GetTempVector3(-88, 293.5, 0)
    self.exchangeBtn.transform.localPosition = LuaGeometry.GetTempVector3(-1, 293, 0)
    self.rankBtn.transform.localPosition = LuaGeometry.GetTempVector3(86, 293.5, 0)
    self.exchangeBtn:SetActive(true)
  else
    self.levelBtn.transform.localPosition = LuaGeometry.GetTempVector3(3, 293.5, 0)
    self.rankBtn.transform.localPosition = LuaGeometry.GetTempVector3(-4, 293.5, 0)
    self.exchangeBtn:SetActive(false)
  end
end

function ServantBattlePassView:AddViewEvents()
  self:AddDispatcherEvt(BattlePassEvent.ShowUpgrade, self.ShowUpgrade)
  self:AddDispatcherEvt(BattlePassEvent.ShowRewardPreview, self.ShowRewardPreview)
  self:AddDispatcherEvt(BattlePassEvent.UpdateExhibition, self.UpdateExhibition)
  self:AddDispatcherEvt(BattlePassEvent.BackToLevelView, self.SwitchToLevelView)
  self:AddDispatcherEvt(BattlePassEvent.HideRewardPreview, self.HideRewardPreview)
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.OnSessionShopQueryShopConfigCmd)
  self:AddListenEvt(MyselfEvent.BattlePassLevelChange, self.OnBattlePassLevelChange)
  self:AddListenEvt(MyselfEvent.BattlePassExpChange, self.BattlePassUpdateExpInfo)
  self:AddListenEvt(ServiceEvent.BattlePassSyncInfoBattlePassCmd, self.OnBattlePassSyncInfo)
  EventManager.Me():AddEventListener(BattlePassEvent.VersionChange, self.OnBattlePassVersionChange, self)
  self:AddListenEvt(ServiceEvent.UserEventQueryChargeCnt, self.BattlePassLevelObtainUpgradeStatus)
  self:AddListenEvt(ServiceEvent.BattlePassAdvanceBattlePassCmd, self.BattlePassLevelUpdateLevelView)
  self:AddListenEvt(ServiceEvent.BattlePassUpdateRewardBattlePassCmd, self.BattlePassLevelUpdateLevelView)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.BattlePassExchangeUpdateCoinInfo)
  self:AddListenEvt(MyselfEvent.BattlePassCoinChange, self.BattlePassExchangeUpdateCoinInfo)
  self:AddListenEvt(ServiceEvent.SessionShopBuyShopItem, self.BattlePassExchangeRecvBuyShopItem)
  self:AddListenEvt(ServiceEvent.MatchCCmdQueryBattlePassRankMatchCCmd, self.BattlePassRankUpdateByAllRank)
  self:AddListenEvt(ServiceEvent.SessionSocialityQuerySocialData, self.BattlePassRankUpdateByFriendRank)
  self:AddListenEvt(ServiceEvent.SessionSocialitySocialDataUpdate, self.BattlePassRankUpdateByFriendRank)
end

function ServantBattlePassView:ShowBuyLevel()
  if BattlePassProxy.BPLevel() >= BattlePassProxy.Instance.maxBpLevel then
    MsgManager.FloatMsg("", ZhString.BattlePassBuyLevelCell_ReachMax)
    return
  end
  if not self.buylevelCell then
    local go = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("BattlePassBuyLevelCell"))
    go.transform:SetParent(self.gameObject.transform, false)
    self.buylevelCell = BattlePassBuyLevelCell.new(go)
  end
  self.buylevelCell.gameObject:SetActive(true)
  self.buylevelCell:SetData()
end

function ServantBattlePassView:ShowUpgrade()
  if not self.upgradeView then
    self.upgradeView = self:AddSubView("BattlePassUpgradeView", BattlePassUpgradeView)
  end
  self.expPanel:SetActive(false)
  self.exhibitPanel:SetActive(false)
  self:Hide(self.levelPos)
  self:Hide(self.exchangePos)
  self:Hide(self.rankPos)
  self:Show(self.upgradePos)
  self.upgradeView:OnEnter()
end

function ServantBattlePassView:ShowRewardPreview()
  if not self.previewView then
    self.previewView = self:AddSubView("BattlePassPreviewView", BattlePassPreviewView)
  end
  self:Show(self.previewPos)
  self.previewView:OnEnter()
end

function ServantBattlePassView:HideRewardPreview()
  self:Hide(self.previewPos)
end

function ServantBattlePassView:UpdateExhibition(data)
  if data and data.data then
    self.exhibitDefault:SetActive(false)
    self.exhibitShow:SetActive(true)
    data = data.data
    if data.type and data.type == "item" and data.data.itemid then
      self.exhibitBg1:SetActive(true)
      self.exhibitBg2:SetActive(false)
      self.iconHolder:SetActive(true)
      self.itemModelHolder:SetActive(false)
      self.charModelHolder:SetActive(false)
      if not self.exhibitIcon then
        self.exhibitIcon = BagItemCell.new(self.iconHolder)
        self:FindGO("Background", self.exhibitIcon.gameObject):SetActive(false)
        self.exhibitIcon:AddClickEvent(self.exhibitIcon.gameObject, function()
          self:ClickRewardItemHandler(self.exhibitIcon)
        end)
      end
      local itemData = ItemData.new("", data.data.itemid)
      itemData:SetItemNum(1)
      self.exhibitIcon:SetData(itemData)
      self.exhibitText.transform.localPosition = LuaGeometry.Const_V3_zero
      self.exhibitTitle.text = itemData.staticData.NameZh
      self:SetExhibitDesc(itemData.staticData.Desc, itemData.staticData.id)
      return
    elseif data.type and data.type == "char" and data.data.showData then
      self.exhibitBg1:SetActive(false)
      self.exhibitBg2:SetActive(true)
      self.iconHolder:SetActive(false)
      self.itemModelHolder:SetActive(false)
      self.charModelHolder:SetActive(true)
      self:ShowPlayerModel(data.data.showData)
      self.exhibitText.transform.localPosition = LuaGeometry.GetTempVector3(0, -140, 0)
      self.exhibitTitle.text = data.data.showData.name
      self:SetExhibitDesc(data.data.showData.guildname and string.format(ZhString.ServantBattlePassView_text9, data.data.showData.guildname))
      return
    end
  end
  self.exhibitDefault:SetActive(true)
  self.exhibitShow:SetActive(false)
  self.exhibitBg1:SetActive(true)
  self.exhibitBg2:SetActive(false)
  UIModelUtil.Instance:ResetTexture(self.charModelTex)
  local versionTitle = ZhString.Servant_BattlePass_LevelTogLab
  local curVersion = BattlePassProxy.Instance.CurrentBPConfig
  self.exhibitVersionTitle.text = versionTitle
  local endTime = BattlePassProxy.Instance:GetCurVersionBPEndTime() or ""
  if FunctionLogin.Me():IsNoviceServer() then
    local verEndTimeStamp = ClientTimeUtil.GetOSDateTime(endTime)
    local curTime = math.floor(ServerTime.CurServerTime() / 1000)
    local date = os.date("*t", curTime)
    local year, month, day, hour = date.year, date.month, date.day, date.hour
    year = month < 12 and year or year + 1
    month = day == 1 and hour < 5 and month or month % 12 + 1
    date.year = year
    date.month = month
    date.day = 1
    date.hour = 5
    date.min = 0
    date.sec = 0
    local subVerEndTimeStamp = os.time(date)
    endTime = os.date("%Y-%m-%d", math.min(verEndTimeStamp, subVerEndTimeStamp))
  else
    endTime = ClientTimeUtil.ConvertTimeToDateFormat(endTime)
  end
  self.exhibitDefault1.text = string.format(ZhString.ServantBattlePassView_text7, endTime)
  self.exhibitDefault2.text = string.format(ZhString.ServantBattlePassView_text8, versionTitle)
  IconManager:SetZenyShopItem(curVersion.BattlePass_Icon, self.exhibitDefaultIcon)
  self.exhibitDescSv:ResetPosition()
end

function ServantBattlePassView:UpdateExpInfo()
  local curLv = BattlePassProxy.BPLevel()
  self.exp_levelLab.text = curLv
  local nextLv = curLv + 1
  local curLvExp = BattlePassProxy.Instance:LevelConfig(curLv)
  curLvExp = curLvExp and curLvExp.NeedExp or 0
  local nextLvExp = BattlePassProxy.Instance:LevelConfig(nextLv)
  nextLvExp = nextLvExp and nextLvExp.NeedExp or 0
  local bpExp = Game.Myself.data.userdata:Get(UDEnum.BATTLEPASS_EXP) or 0
  if nextLvExp > bpExp then
    local nextExp = nextLvExp - curLvExp
    local curExp = bpExp - curLvExp
    self.exp_expLab.text = curExp .. "/" .. nextExp
    self.exp_expSlider.value = curExp / nextExp
  else
    self.exp_expLab.text = "MAX"
    self.exp_expSlider.value = 1
  end
  local weekExp = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_WEEK_BATTLEPASS_EXP) or 0
  local weekExpLimit = Game.Myself.data.userdata:Get(UDEnum.BATTLEPASS_MAXEXP) or 0
  self.exp_explimitLab.text = string.format(ZhString.ServantBattlePassView_explimit, weekExp, weekExpLimit)
end

local tipData = {}
tipData.funcConfig = {}

function ServantBattlePassView:ClickRewardItemHandler(cellctl)
  if cellctl.data then
    tipData.itemdata = cellctl.data
    self:ShowItemTip(tipData, nil, NGUIUtil.AnchorSide.Up)
  end
end

function ServantBattlePassView:ShowPlayerModel(rankShowData)
  if rankShowData then
    local parts = Asset_Role.CreatePartArray()
    local partIndex = Asset_Role.PartIndex
    local partIndexEx = Asset_Role.PartIndexEx
    parts[partIndex.Body] = rankShowData.bodyID or 0
    parts[partIndex.Hair] = rankShowData.hairID or 0
    parts[partIndex.LeftWeapon] = rankShowData.lefthand or 0
    parts[partIndex.RightWeapon] = rankShowData.righthand or 0
    parts[partIndex.Head] = rankShowData.headID or 0
    parts[partIndex.Wing] = rankShowData.back or 0
    parts[partIndex.Face] = rankShowData.faceID or 0
    parts[partIndex.Tail] = rankShowData.tail or 0
    parts[partIndex.Eye] = rankShowData.eyeID or 0
    parts[partIndex.Mount] = rankShowData.mount or 0
    parts[partIndex.Mouth] = rankShowData.mouthID or 0
    parts[partIndexEx.Gender] = rankShowData.gender or 0
    parts[partIndexEx.HairColorIndex] = rankShowData.haircolor or 0
    parts[partIndexEx.EyeColorIndex] = rankShowData.eyecolor or 0
    parts[partIndexEx.BodyColorIndex] = rankShowData.clothcolor or 0
    UIModelUtil.Instance:ChangeBGMeshRenderer("calendar_Advanced-version_bg3", self.charModelTex)
    UIModelUtil.Instance:SetRoleModelTexture(self.charModelTex, parts, UIModelCameraTrans.BattlePassRank)
    Asset_Role.DestroyPartArray(parts)
  end
end

local itemClickUrlTipData = {}

function ServantBattlePassView:SetExhibitDesc(text, itemId)
  if type(text) ~= "string" then
    text = ""
  end
  local labObj, hasItemId = self.exhibitDesc.gameObject, StringUtil.HasItemIdToClick(text)
  if hasItemId then
    UIUtil.TryAddClickUrlCompToGameObject(labObj, function(url)
      if string.sub(url, 1, 6) ~= "itemid" then
        return
      end
      local itemId = tonumber(string.sub(url, 8))
      if itemId then
        if not next(itemClickUrlTipData) then
          itemClickUrlTipData.itemdata = ItemData.new()
        end
        itemClickUrlTipData.itemdata:ResetData("itemClickUrl", itemId)
        
        function itemClickUrlTipData.clickItemUrlCallback(tip, itemid)
          TipManager.Instance:CloseTip()
          itemClickUrlTipData.itemdata:ResetData("itemClickUrl", itemid)
          self:ShowClickItemUrlTip(itemClickUrlTipData)
        end
        
        self:ShowClickItemUrlTip(itemClickUrlTipData)
      end
    end)
    self.exhibitDesc.text = StringUtil.AdaptItemIdClickUrl(text)
  elseif StringUtil.HasBufferIdToClick(text) then
    UIUtil.TryAddClickUrlCompToGameObject(labObj, function(url)
      if string.sub(url, 1, 11) ~= "enchantbuff" then
        return
      end
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.EnchantInfoPopup,
        viewdata = {attriMenuType = 4, advCostID = itemId}
      })
    end)
    self.exhibitDesc.text = StringUtil.AdaptBuffIdClickUrl(text)
  elseif StringUtil.HasPreviewToClick(text) then
    UIUtil.TryAddClickUrlCompToGameObject(labObj, function(url)
      local tipData = {}
      tipData.itemdata = ItemData.new("", itemId)
      local tip = self:ShowClickItemUrlTip(tipData)
      if tip then
        local itemTipCell = tip:GetCell(1)
        itemTipCell:OnClickPreview()
      end
    end)
    self.exhibitDesc.text = StringUtil.AdaptItemPreviewClickUrl(text)
  else
    UIUtil.TryRemoveClickUrlCompFromGameObject(labObj)
    self.exhibitDesc.text = text
  end
  self.exhibitDescSv:ResetPosition()
end

function ServantBattlePassView:ShowClickItemUrlTip(data)
  local tip = self:ShowItemTip(data, nil, NGUIUtil.AnchorSide.Up)
  if tip then
    tip:AddIgnoreBounds(self.exhibitDesc.gameObject)
  end
  return tip
end

function ServantBattlePassView:ShowTaskPanel()
  if not self.taskSubView then
    self.taskSubView = self:AddSubView("BattlePassTaskView", BattlePassTaskView)
  else
    self.taskSubView:OnEnter()
  end
  self.taskViewPos:SetActive(true)
end

function ServantBattlePassView:HideTaskPanel()
  if self.taskSubView then
    self.taskSubView:OnExit()
  end
  self.taskViewPos:SetActive(false)
end

function ServantBattlePassView:OnBattlePassVersionChange(data)
  MsgManager.ShowMsgByID(40953)
  self:CloseSelf()
end

function ServantBattlePassView:OnSessionShopQueryShopConfigCmd(data)
  self:BattlePassExchangeUpdateExchangeShop(data)
end

function ServantBattlePassView:OnBattlePassLevelChange(data)
  self:BattlePassUpdateExpInfo(data)
  self:BattlePassLevelUpdateLevelView(data)
end

function ServantBattlePassView:BattlePassUpdateExpInfo(data)
  self:UpdateExpInfo(data)
end

function ServantBattlePassView:OnBattlePassSyncInfo(data)
  MsgManager.ShowMsgByID(34004)
  self:CloseSelf()
end

function ServantBattlePassView:BattlePassLevelObtainUpgradeStatus(data)
  if self.levelView then
    self.levelView:ObtainUpgradeStatus(data)
  end
end

function ServantBattlePassView:BattlePassLevelUpdateLevelView(data)
  if self.levelView then
    self.levelView:UpdateLevelView(data)
  end
  if self.upgradeView then
    self.upgradeView:UpdateView()
  end
end

function ServantBattlePassView:BattlePassExchangeUpdateExchangeShop(data)
  if self.exchangeView then
    self.exchangeView:UpdateExchangeShop(data)
  end
end

function ServantBattlePassView:BattlePassExchangeRecvBuyShopItem(data)
  if self.exchangeView then
    self.exchangeView:UpdateExchangeShop(data)
  end
end

function ServantBattlePassView:BattlePassExchangeUpdateCoinInfo(data)
  if self.exchangeView then
    self.exchangeView:UpdateCoinInfo(data)
  end
end

function ServantBattlePassView:BattlePassRankUpdateByAllRank(data)
  if self.rankView then
    self.rankView:UpdateByAllRank(data)
  end
end

function ServantBattlePassView:BattlePassRankUpdateByFriendRank(data)
  if self.rankView then
    self.rankView:UpdateByFriendRank(data)
  end
end
