autoImport("GemContainerView")
autoImport("LevelListPopUp")
autoImport("NewbieTechtreeLeafTip")
NewbieTechTreeContainerView = class("NewbieTechTreeContainerView", GemContainerView)
NewbieTechTreeContainerView.ViewType = UIViewType.NormalLayer
NewbieTechTreeContainerView.TogglePageNameMap = {
  HeartTab = "NewbieTechTreeHeartPage",
  AttrTab = "TechTreeAttributePage"
}
NewbieTechTreeContainerView.TexObjTexNameMap = {
  BgViewport = "persona_pic_bottom",
  ChooseSymbol1 = "tree_heart_01",
  ChooseSymbol2 = "tree_heart_02",
  ChooseSymbol3 = "tree_heart_03",
  ChooseSymbol4 = "tree_heart_04",
  ChooseSymbol5 = "tree_heart_05"
}
NewbieTechTreeContainerView.TipClassMap = {
  AttrList = NewbieTechtreeLeafTip
}

function NewbieTechTreeContainerView:Init()
  local viewData = self.viewdata.viewdata
  self.treeId = viewData and viewData.treeId or 4
  NewbieTechTreeContainerView.super.Init(self)
  for obj, _ in pairs(NewbieTechTreeContainerView.TexObjTexNameMap) do
    self[obj] = self:FindComponent(obj, UITexture)
  end
  self:InitFakeTips()
  self:InitView()
  self:InitData()
  self:RegisterGuide()
end

function NewbieTechTreeContainerView:InitView()
  self.levelContainer = self:FindGO("LevelContainer")
  self.itemContainer = self:FindGO("ItemContainer"):GetComponent(UIWidget)
  self.treeLevelRoot = self:FindGO("TreeLevelRoot")
  self.noGift = self:FindGO("GiftIcon")
  self.giftValid = self:FindGO("GiftValid")
  self.giftValid:SetActive(false)
  self.levelLabel = self:FindGO("LevelLabel", self.treeLevelRoot):GetComponent(UILabel)
  self.helpBtn = self:FindGO("HelpBtn")
  self:AddClickEvent(self.treeLevelRoot, function()
    self:SwitchToPage(self.TogglePageNameMap.HeartTab)
    if not self.levelListPage then
      self.levelListPage = self:AddSubView("LevelListPopUp", LevelListPopUp)
    end
    self.levelListPage:SetActive(true)
    self.levelListPage:AdjustScrollView()
    self:HideAllTips()
    TechTreeProxy.Instance:BrowseLevelQuestRedTip(self.treeId)
    self:RefreshGiftIconStatus()
  end)
  self:TryOpenHelpViewById(35244, nil, self.helpBtn)
end

function NewbieTechTreeContainerView:InitData()
  self.tipData = {}
  self.tipData.funcConfig = {}
  self:RefreshTechTreeLevel()
  self:RefreshGiftIconStatus()
end

function NewbieTechTreeContainerView:InitFakeTips()
  self.tipStick = self:FindComponent("TipNormalStick", UISprite)
  self.tips = {}
  for tipName, tipClass in pairs(NewbieTechTreeContainerView.TipClassMap) do
    self.tips[tipName] = tipClass.new(self:FindGO(tipName), self.tipStick)
  end
  self:AddButtonEvent("BgViewport2", function()
    self:HideAllTips()
    for _, page in pairs(self.viewMap) do
      if page.OnBgClick then
        page:OnBgClick()
      end
    end
  end)
end

function NewbieTechTreeContainerView:AddEvents()
  self:AddListenEvt(ServiceEvent.TechTreeCmdTechTreeUnlockLeafCmd, self.OnLeafUnlock)
  self:AddListenEvt(ServiceEvent.TechTreeCmdTechTreeLevelAwardCmd, self.OnTechTreeRewardRecv)
  self:AddListenEvt(UICellEvent.OnCellClicked, self.HandleShowItemTip)
end

function NewbieTechTreeContainerView:OnItemUpdate()
  for _, tip in pairs(self.tips) do
    if tip.gameObject.activeSelf then
      tip:OnItemUpdate()
    end
  end
end

function NewbieTechTreeContainerView:OnTechTreeRewardRecv()
  if self.levelListPage then
    self.levelListPage:RefreshPage()
  end
  self:RefreshGiftIconStatus()
end

function NewbieTechTreeContainerView:HandleShowItemTip(note)
  local data = note.body
  local itemid = data.itemid
  if itemid then
    self.tipData.itemdata = ItemData.new("Reward", itemid)
    self:ShowItemTip(self.tipData, self.itemContainer, NGUIUtil.AnchorSide.Center, {0, 0})
  end
end

function NewbieTechTreeContainerView:OnLeafUnlock()
  self:RefreshTechTreeLevel()
  self:RefreshGiftIconStatus()
  if self.levelListPage then
    self.levelListPage:RefreshPage()
  end
end

function NewbieTechTreeContainerView:RefreshTechTreeLevelInfos()
  local treeInfo = TechTreeProxy.Instance:GetTreeLevelInfo(self.treeId)
  local nodeinfo = treeInfo and treeInfo.nodeinfo
  if not nodeinfo then
    return
  end
  return nodeinfo
end

function NewbieTechTreeContainerView:RefreshTechTreeLevel()
  xdlog("等级更新")
  local treeLevelInfo = TechTreeProxy.Instance:GetTechTreeLevelInfo(self.treeId)
  local curLevel = treeLevelInfo and treeLevelInfo.treeLevel or 0
  local maxLevel = treeLevelInfo and treeLevelInfo.maxLevel
  self.levelLabel.text = string.format("Lv.%s/%s", curLevel, maxLevel)
end

function NewbieTechTreeContainerView:RefreshGiftIconStatus()
  local rewardValid = TechTreeProxy.Instance:IsTechTreeLevelRewardValid(self.treeId)
  self.giftValid:SetActive(rewardValid)
  self.noGift:SetActive(not rewardValid)
end

function NewbieTechTreeContainerView:ShowBranchTip(branchId)
  self:HideAllTips()
  if not branchId then
    return
  end
  self.tips.AttrList:Show()
  self.tips.AttrList:SetData(branchId, self.treeId)
end

function NewbieTechTreeContainerView:HideAllTips()
  for _, tip in pairs(self.tips) do
    tip:Hide()
  end
end

function NewbieTechTreeContainerView:GetDefaultPageName()
  return self.TogglePageNameMap.HeartTab
end

function NewbieTechTreeContainerView:SwitchToPage(targetPageName)
  NewbieTechTreeContainerView.super.SwitchToPage(self, targetPageName)
  self:HideAllTips()
end

function NewbieTechTreeContainerView:OnEnter()
  NewbieTechTreeContainerView.super.OnEnter(self)
  for obj, texName in pairs(NewbieTechTreeContainerView.TexObjTexNameMap) do
    if self[obj] then
      PictureManager.Instance:SetUI(texName, self[obj])
    end
  end
  self:sendNotification(UIEvent.CloseUI, UIViewType.DialogLayer)
  PictureManager.ReFitFullScreen(self.BgViewport, 1)
end

function NewbieTechTreeContainerView:OnExit()
  for obj, texName in pairs(NewbieTechTreeContainerView.TexObjTexNameMap) do
    if self[obj] then
      PictureManager.Instance:UnLoadUI(texName, self[obj])
    end
  end
  NewbieTechTreeContainerView.super.OnExit(self)
end

function NewbieTechTreeContainerView:RegisterGuide()
  self:AddOrRemoveGuideId(self.treeLevelRoot, 481)
  self:AddOrRemoveGuideId("CloseButton", 483)
end
