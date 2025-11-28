autoImport("TechTreeToyTip")
autoImport("GemContainerView")
autoImport("LevelListPopUp")
TechTreeContainerView = class("TechTreeContainerView", GemContainerView)
TechTreeContainerView.ViewType = UIViewType.NormalLayer
TechTreeContainerView.TogglePageNameMap = {
  TreeTab = "TechTreeMainPage",
  AttrTab = "TechTreeAttributePage",
  BuildingTab = "TechTreeBuildingPage",
  MonsterTab = "TechTreeMonsterPage"
}
TechTreeContainerView.TexObjTexNameMap = {
  BgViewport = "persona_pic_bottom"
}
TechTreeContainerView.TipClassMap = {
  Common = TechTreeLeafCommonTip,
  Toy = TechTreeToyTip
}

function TechTreeContainerView:Init()
  local viewData = self.viewdata.viewdata
  self.treeId = viewData and viewData.treeId or 3
  TechTreeContainerView.super.Init(self)
  for obj, _ in pairs(TechTreeContainerView.TexObjTexNameMap) do
    self[obj] = self:FindComponent(obj, UITexture)
  end
  self:InitFakeTips()
  self:InitView()
  self:InitData()
  self:RegisterGuide()
  self:AddEvts()
end

function TechTreeContainerView:AddEvts()
  self:AddListenEvt(ServiceEvent.BossCmdQueryRareEliteCmd, self.OnQuery)
  self:AddListenEvt(ServiceEvent.BossCmdQuerySpecMapRareEliteCmd, self.OnQuery)
  self:AddListenEvt(UIMenuEvent.UnlockMenu, self.OnUnlockMenu)
end

function TechTreeContainerView:OnQuery(note)
  local pageClass = self.viewMap[self.activePageName or ""]
  if pageClass and pageClass.OnQuery then
    pageClass:OnQuery(note)
  end
end

function TechTreeContainerView:OnUnlockMenu()
  local pageClass = self.viewMap[self.activePageName or ""]
  if pageClass and pageClass.OnUnlockMenu then
    pageClass:OnUnlockMenu()
  end
end

function TechTreeContainerView:InitView()
  self.levelContainer = self:FindGO("LevelContainer")
  self.itemContainer = self:FindGO("ItemContainer"):GetComponent(UIWidget)
  self.treeLevelRoot = self:FindGO("TreeLevelRoot")
  self.noGift = self:FindGO("GiftIcon")
  self.giftValid = self:FindGO("GiftValid")
  self.giftValid:SetActive(false)
  self.levelLabel = self:FindGO("LevelLabel", self.treeLevelRoot):GetComponent(UILabel)
  self.helpBtn = self:FindGO("HelpBtn")
  self:AddClickEvent(self.treeLevelRoot, function()
    self:SwitchToPage(self.TogglePageNameMap.TreeTab)
    if not self.levelListPage then
      self.levelListPage = self:AddSubView("LevelListPopUp", LevelListPopUp)
    end
    self.levelListPage:SetActive(true)
    self.levelListPage:AdjustScrollView()
    self:HideAllTips()
    TechTreeProxy.Instance:BrowseLevelQuestRedTip(self.treeId)
    self:RefreshGiftIconStatus()
  end)
  self:TryOpenHelpViewById(35220, nil, self.helpBtn)
  self.tabsContainer = self:FindGO("Tabs"):GetComponent(UIGrid)
  if GameConfig.TechTree and GameConfig.TechTree.MonsterPageMenu then
    local unlock = FunctionUnLockFunc.Me():CheckCanOpen(GameConfig.TechTree.MonsterPageMenu)
    local monsterTab = self:FindGO("MonsterTab")
    monsterTab:SetActive(unlock)
    self.tabsContainer:Reposition()
  end
end

function TechTreeContainerView:InitData()
  self.tipData = {}
  self.tipData.funcConfig = {}
  self:RefreshTechTreeLevel()
  self:RefreshGiftIconStatus()
end

function TechTreeContainerView:InitFakeTips()
  self.tipStick = self:FindComponent("TipNormalStick", UISprite)
  self.tips = {}
  for tipName, tipClass in pairs(TechTreeContainerView.TipClassMap) do
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

function TechTreeContainerView:GetDefaultPageName()
  return self.TogglePageNameMap.TreeTab
end

function TechTreeContainerView:AddEvents()
  self:AddListenEvt(ServiceEvent.TechTreeCmdTechTreeUnlockLeafCmd, self.OnLeafUnlock)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.OnItemUpdate)
  self:AddListenEvt(ServiceEvent.TechTreeCmdTechTreeLevelAwardCmd, self.OnTechTreeRewardRecv)
  self:AddListenEvt(UICellEvent.OnCellClicked, self.HandleShowItemTip)
end

function TechTreeContainerView:SwitchToPage(targetPageName)
  TechTreeContainerView.super.SwitchToPage(self, targetPageName)
  self:HideAllTips()
end

function TechTreeContainerView:OnEnter()
  TechTreeContainerView.super.OnEnter(self)
  for obj, texName in pairs(TechTreeContainerView.TexObjTexNameMap) do
    if self[obj] then
      PictureManager.Instance:SetUI(texName, self[obj])
    end
  end
  PictureManager.ReFitFullScreen(self.BgViewport, 1)
end

function TechTreeContainerView:TipsOnExit()
  if not self.tips then
    return
  end
  for _, tip in pairs(self.tips) do
    if tip.OnExit then
      tip:OnExit()
    end
  end
end

function TechTreeContainerView:OnExit()
  for obj, texName in pairs(TechTreeContainerView.TexObjTexNameMap) do
    if self[obj] then
      PictureManager.Instance:UnLoadUI(texName, self[obj])
    end
  end
  self:TipsOnExit()
  TechTreeContainerView.super.OnExit(self)
end

function TechTreeContainerView:OnLeafUnlock()
  if self.tips.Common.gameObject.activeSelf then
    self.tips.Common:OnLeafUnlock()
  else
    self:HideAllTips()
  end
  self:RefreshTechTreeLevel()
  self:RefreshGiftIconStatus()
  if self.levelListPage then
    self.levelListPage:RefreshPage()
  end
end

function TechTreeContainerView:OnItemUpdate()
  for _, tip in pairs(self.tips) do
    if tip.gameObject.activeSelf then
      tip:OnItemUpdate()
    end
  end
end

function TechTreeContainerView:OnTechTreeRewardRecv()
  if self.levelListPage then
    self.levelListPage:RefreshPage()
  end
  self:RefreshGiftIconStatus()
end

function TechTreeContainerView:ShowLeafTip(leafId, treeId)
  self:HideAllTips()
  if not leafId then
    return
  end
  local proxyIns = TechTreeProxy.Instance
  local isUnlocked = proxyIns:IsLeafUnlocked(leafId, self.treeId)
  local isToy, drawingId = proxyIns:IsToyLeaf(leafId)
  if isUnlocked and isToy then
    self:ShowToyTip(drawingId)
    self.tips.Toy:SetTipCloseBtnActive(false)
  else
    if isUnlocked then
      local effects, eff = proxyIns:GetEffectsOfLeaf(leafId)
      if effects then
        for i = 1, #effects do
          eff = effects[i]
          if eff.Type == "unlock_menu" and eff.Params.menuid == 10002 then
            TipManager.Instance:ShowSandExchangeTip(self.tipStick, nil, {210, 0})
            return
          end
        end
      end
    end
    self.tips.Common:SetData(leafId, treeId)
    self.tips.Common:Show()
  end
end

function TechTreeContainerView:ShowToyTip(drawingId)
  self:HideAllTips()
  if not drawingId then
    return
  end
  self.tips.Toy:SetData(drawingId)
  self.tips.Toy:Show()
end

function TechTreeContainerView:HideAllTips()
  for _, tip in pairs(self.tips) do
    tip:Hide()
  end
end

function TechTreeContainerView:HandleShowItemTip(note)
  local data = note.body
  local itemid = data.itemid
  if itemid then
    self.tipData.itemdata = ItemData.new("Reward", itemid)
    self:ShowItemTip(self.tipData, self.itemContainer, NGUIUtil.AnchorSide.Center, {0, 0})
  end
end

function TechTreeContainerView:RefreshTechTreeLevelInfos()
  local treeInfo = TechTreeProxy.Instance:GetTreeLevelInfo(self.treeId)
  local nodeinfo = treeInfo and treeInfo.nodeinfo
  if not nodeinfo then
    return
  end
  return nodeinfo
end

function TechTreeContainerView:RefreshTechTreeLevel()
  xdlog("等级更新")
  local treeLevelInfo = TechTreeProxy.Instance:GetTechTreeLevelInfo(self.treeId)
  local curLevel = treeLevelInfo and treeLevelInfo.treeLevel or 0
  local maxLevel = treeLevelInfo and treeLevelInfo.maxLevel
  self.levelLabel.text = string.format("Lv.%s/%s", curLevel, maxLevel)
end

function TechTreeContainerView:RefreshGiftIconStatus()
  local rewardValid = TechTreeProxy.Instance:IsTechTreeLevelRewardValid(self.treeId)
  self.giftValid:SetActive(rewardValid)
  self.noGift:SetActive(not rewardValid)
end

function TechTreeContainerView:RegisterGuide()
  self:AddOrRemoveGuideId(self.treeLevelRoot, 507)
end
