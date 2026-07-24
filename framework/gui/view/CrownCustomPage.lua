autoImport("SnowCrownNodeCell")
autoImport("SnowCrownProxy")
autoImport("CrownTotalAttrCell")
autoImport("SnowFashionItemCell")
CrownCustomPage = class("CrownCustomPage", SubView)

function CrownCustomPage:Init()
  CrownCustomPage.super.Init(self)
  self:ReLoadPerferb("view/CrownCustomPage")
  self.trans:SetParent(self.container.pageContainer.transform, false)
  self.currentModeType = SnowCrownProxy.ModeEnum.Atk
  self.selectedNodeCell = nil
  self:InitTopLeft()
  self:InitTop()
  self:InitDown()
  self:InitDownLeft()
  self:InitLeft()
  self:InitRight()
  self:AddEvents()
  self:InitViewState()
  self:InitCloseComp()
  self:InitShow()
end

function CrownCustomPage:InitCloseComp()
  if self.level2AttrNode then
    self.closecomp = self.level2AttrNode:GetComponent(CloseWhenClickOtherPlace)
    if self.closecomp then
      function self.closecomp.callBack()
        self:OnBackButtonClick()
      end
      
      self.closecomp:AddTarget(self.level2AttrNode.transform)
      if self.level2NodeDetail then
        self.closecomp:AddTarget(self.level2NodeDetail.transform)
      end
      if self.atkMode then
        self.closecomp:AddTarget(self.atkMode.transform)
      end
      if self.defMode then
        self.closecomp:AddTarget(self.defMode.transform)
      end
      if self.elementMode then
        self.closecomp:AddTarget(self.elementMode.transform)
      end
    end
  end
  if self.level2FashionCustom then
    self.fashionClosecomp = self.level2FashionCustom:GetComponent(CloseWhenClickOtherPlace)
    if self.fashionClosecomp then
      function self.fashionClosecomp.callBack()
        self:OnBackButtonClick()
      end
      
      if self.container.modelTexture.transform then
        self.fashionClosecomp:AddTarget(self.container.modelTexture.transform)
      end
    end
  end
end

function CrownCustomPage:InitTopLeft()
  local topLeftParent = self:FindGO("TopLeft")
  if topLeftParent then
    self.backButton = self:FindGO("BackButton", topLeftParent)
    if self.backButton then
      self:AddClickEvent(self.backButton, function()
        self:OnBackButtonClick()
      end)
      self:Hide(self.backButton)
    end
  end
end

function CrownCustomPage:InitTop()
  local centerParent = self:FindGO("Center")
  self.center = centerParent
  if centerParent then
    local levelBG = self:FindGO("LevelBG", centerParent)
    self.levelBG = levelBG
    if levelBG then
      self.levelLabel = self:FindComponent("LevelLabel", UILabel, levelBG)
      self:UpdateLevelDisplay(1)
      self.levelBGTweenDuration = 0.3
      self.levelBGTweener = nil
    end
  end
end

function CrownCustomPage:InitDown()
  local downParent = self:FindGO("Down")
  if downParent then
    self.dragTip = self:FindGO("DragTip", downParent)
    if self.dragTip then
      self:Hide(self.dragTip)
    end
    self.level1LevelUp = self:FindGO("Level1_LevelUp", downParent)
    if self.level1LevelUp then
      self.levelUpBtn = self:FindGO("LevelUpBtn", self.level1LevelUp)
      if self.levelUpBtn then
        self.levelUpLabel = self:FindComponent("LevelUpLabel", UILabel, self.levelUpBtn)
        self:AddClickEvent(self.levelUpBtn, function()
          self:OnLevelUpBtnClick()
        end)
        self:AddOrRemoveGuideId(self.levelUpBtn, 555)
      end
      self.levelMaxTip = self:FindGO("MaxLv", self.level1LevelUp)
      self.costTip = self:FindGO("CostTip", self.level1LevelUp)
      if self.costTip then
        self.costBG = self:FindComponent("CostBG", UISprite, self.costTip)
        self.costLabel1 = self:FindComponent("CostLabel1", UILabel, self.costTip)
        self.costIcon = self:FindComponent("CostIcon", UISprite, self.costTip)
        self.costCount = self:FindComponent("CostCount", UILabel, self.costTip)
      end
    end
    self.level2NodeDetail = self:FindGO("Level2_NodeDetail", downParent)
    if self.level2NodeDetail then
      self.nodeDetailBG = self:FindGO("NodeDetailBG", self.level2NodeDetail)
      self.nodeName = self:FindComponent("NodeName", UILabel, self.level2NodeDetail)
      self.nodeSprite = self:FindComponent("Sprite", UISprite, self.level2NodeDetail)
      self.nodeDesc = self:FindComponent("NodeDesc", UILabel, self.level2NodeDetail)
      self.lockStatus = self:FindGO("LockStatus", self.level2NodeDetail)
      if self.lockStatus then
        self.lockStatusLabel = self:FindComponent("Label", UILabel, self.lockStatus)
      end
      self.nodeCostLabel = self:FindComponent("NodeCostLabel", UILabel, self.level2NodeDetail)
      self.activeBtn = self:FindGO("ActiveBtn", self.level2NodeDetail)
      if self.activeBtn then
        self.activeBtnLabel = self:FindComponent("Label", UILabel, self.activeBtn)
        self.activeBtnCollider = self.activeBtn:GetComponent(BoxCollider)
        self:AddClickEvent(self.activeBtn, function()
          self:OnActiveBtnClick()
        end)
        self:AddOrRemoveGuideId(self.activeBtn, 566)
      end
    end
  end
end

function CrownCustomPage:InitDownLeft()
  local downLeftParent = self:FindGO("DownLeft")
  if downLeftParent then
    self.profitBtn = self:FindGO("ProfitBtn", downLeftParent)
    if self.profitBtn then
      self:AddClickEvent(self.profitBtn, function()
        self:OnProfitBtnClick()
      end)
    end
  end
end

function CrownCustomPage:InitLeft()
  local leftParent = self:FindGO("Left")
  self.curMode = self:FindGO("CurMode", leftParent)
  if self.curMode then
    self.modeBg = self.curMode:GetComponent(UIMultiSprite)
    self.modeIcon = self:FindComponent("ModeIcon", UIMultiSprite, self.curMode)
    self.modeLabel = self:FindComponent("ModeLabel", UILabel, self.curMode)
    self:AddClickEvent(self.curMode, function()
      self:OnCurModeClick()
    end)
    self:AddOrRemoveGuideId(self.curMode, 554)
    if self.modeIcon then
      local modeIconGO = self.modeIcon.gameObject
      self:PlayUIEffect(EffectMap.UI.SnowGem_ModeBG_Atk, modeIconGO, false, function(obj, args, assetEffect)
        self.atkModeEffect = assetEffect
        if assetEffect then
          assetEffect:SetActive(self.currentModeType == SnowCrownProxy.ModeEnum.Atk)
        end
      end)
      self:PlayUIEffect(EffectMap.UI.SnowGem_ModeBG_Def, modeIconGO, false, function(obj, args, assetEffect)
        self.defModeEffect = assetEffect
        if assetEffect then
          assetEffect:SetActive(self.currentModeType == SnowCrownProxy.ModeEnum.Def)
        end
      end)
      self:PlayUIEffect(EffectMap.UI.SnowGem_ModeBG_Element, modeIconGO, false, function(obj, args, assetEffect)
        self.elementModeEffect = assetEffect
        if assetEffect then
          assetEffect:SetActive(self.currentModeType == SnowCrownProxy.ModeEnum.Ele)
        end
      end)
    end
  end
end

function CrownCustomPage:UpdateCurModeDisplay()
  if not self.curMode then
    return
  end
  local modeType = self.currentModeType or SnowCrownProxy.ModeEnum.Atk
  local spriteStatue = modeType - 1
  if self.modeIcon then
    self.modeIcon.CurrentState = spriteStatue
  end
  if self.modeBg then
    self.modeBg.CurrentState = spriteStatue
  end
  if self.modeLabel then
    local labelText = ""
    local effectColor = Color.white
    if modeType == SnowCrownProxy.ModeEnum.Atk then
      labelText = ZhString.CrownCustomPage_AtkMode or "物理模式"
      effectColor = LuaGeometry.GetTempColor(0.8313725490196079, 0.3254901960784314, 0.3843137254901961, 1)
    elseif modeType == SnowCrownProxy.ModeEnum.Def then
      labelText = ZhString.CrownCustomPage_DefMode or "防御模式"
      effectColor = LuaGeometry.GetTempColor(0.3254901960784314, 0.5450980392156862, 0.8392156862745098, 1)
    elseif modeType == SnowCrownProxy.ModeEnum.Ele then
      labelText = ZhString.CrownCustomPage_ElementMode or "魔法模式"
      effectColor = LuaGeometry.GetTempColor(0.8117647058823529, 0.6352941176470588, 0.2627450980392157, 1)
    end
    self.modeLabel.text = labelText
    self.modeLabel.effectColor = effectColor
  end
  self:UpdateModeEffectDisplay(modeType)
end

function CrownCustomPage:UpdateModeEffectDisplay(modeEnum)
  if self.atkModeEffect then
    self.atkModeEffect:SetActive(false)
  end
  if self.defModeEffect then
    self.defModeEffect:SetActive(false)
  end
  if self.elementModeEffect then
    self.elementModeEffect:SetActive(false)
  end
  if modeEnum == SnowCrownProxy.ModeEnum.Atk then
    if self.atkModeEffect then
      self.atkModeEffect:SetActive(true)
    end
  elseif modeEnum == SnowCrownProxy.ModeEnum.Def then
    if self.defModeEffect then
      self.defModeEffect:SetActive(true)
    end
  elseif modeEnum == SnowCrownProxy.ModeEnum.Ele and self.elementModeEffect then
    self.elementModeEffect:SetActive(true)
  end
end

function CrownCustomPage:OnCurModeClick()
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.SnowModePopup
  })
end

function CrownCustomPage:InitRight()
  local rightParent = self:FindGO("Right")
  if rightParent then
    self.gemTipCellGO = self:FindGO("GemTipCell", rightParent)
    if self.gemTipCellGO then
    end
    self.gemTipCellForCompareGO = self:FindGO("GemTipCellForCompare", rightParent)
    self.selectBord = self:FindGO("SelectBord", rightParent)
    self.level1Funcs = self:FindGO("Level1Funcs", rightParent)
    if self.level1Funcs then
      self.attrBtn = self:FindGO("AttrBtn", self.level1Funcs)
      if self.attrBtn then
        self.attrBtnLabel = self:FindComponent("Label", UILabel, self.attrBtn)
        self:AddClickEvent(self.attrBtn, function()
          self:OnAttrBtnClick()
        end)
        self:AddOrRemoveGuideId(self.attrBtn, 556)
      end
      self.showCustomBtn = self:FindGO("ShowCustomBtn", self.level1Funcs)
      if self.showCustomBtn then
        self.showCustomBtnLabel = self:FindComponent("Label", UILabel, self.showCustomBtn)
        self:AddClickEvent(self.showCustomBtn, function()
          self:OnShowCustomBtnClick()
        end)
        self:AddOrRemoveGuideId(self.showCustomBtn, 557)
      end
      self.sliver = self:FindGO("Silver", self.level1Funcs)
      if self.sliver then
        self.sliverSymbol = self:FindComponent("symbol", UISprite, self.sliver)
        self.sliverLabel = self:FindComponent("Label", UILabel, self.sliver)
        self:AddClickEvent(self.sliver, function()
          self:OnSliverClick()
        end)
      end
    end
    self.level2AttrNode = self:FindGO("Level2_AttrNode", rightParent)
    if self.level2AttrNode then
      self:InitLevel2AttrNode()
    end
    self.level2FashionCustom = self:FindGO("Level2_FashionCustom", rightParent)
    if self.level2FashionCustom then
      self:InitLevel2FashionCustom()
    end
    self.profitBord = self:FindGO("ProfitBord")
    if self.profitBord then
      self.profitScrollView = self:FindComponent("ProfitScrollView", UIScrollView, self.profitBord)
      self.profitGrid = self:FindComponent("ProfitGrid", UIGrid, self.profitBord)
      self.profitAttrListCtrl = UIGridListCtrl.new(self.profitGrid, CrownTotalAttrCell, "CrownTotalAttrCell")
      self:Hide(self.profitBord)
    end
    self.helpBtn = self:FindGO("HelpBtn")
    if self.helpBtn then
      self:TryOpenHelpViewById(32652, nil, self.helpBtn)
      self:Show(self.helpBtn)
    end
    self.gemPageContainer = self:FindGO("GemPageContainer", rightParent)
    self.mask = self:FindGO("Mask", rightParent)
    if self.mask then
      self:Hide(self.mask)
    end
    self.newProfitBord = self:FindGO("NewProfitBord", rightParent)
    if self.newProfitBord then
      self:Hide(self.newProfitBord)
    end
  end
end

function CrownCustomPage:InitLevel2AttrNode()
  if not self.level2AttrNode then
    return
  end
  local root = self:FindGO("AttrNodeContainer", self.level2AttrNode)
  if not root then
    return
  end
  self.leftPointLabel = self:FindComponent("LeftPointLabel", UILabel, root)
  local scrollView = self:FindGO("Scroll View", root)
  if scrollView then
    local nodeTable = self:FindGO("NodeTable", scrollView)
    if nodeTable then
      self.stageList = {}
      for i = 1, 3 do
        local stageGO = self:FindGO("Stage" .. i, nodeTable)
        if stageGO then
          local stageData = {
            gameObject = stageGO,
            label = self:FindComponent("Label", UILabel, stageGO),
            lock = self:FindGO("Lock", stageGO),
            star = self:FindGO("Star", stageGO),
            grid = self:FindComponent("Grid", UIGrid, stageGO),
            listCtrl = nil
          }
          if stageData.grid then
            stageData.listCtrl = ListCtrl.new(stageData.grid, SnowCrownNodeCell, "SnowCrownNodeCell")
            stageData.listCtrl:AddEventListener(MouseEvent.MouseClick, self.OnNodeCellClick, self)
          end
          self.stageList[i] = stageData
        end
      end
    end
  end
end

function CrownCustomPage:InitLevel2FashionCustom()
  if not self.level2FashionCustom then
    return
  end
  self.selectedFashionCells = {}
  self.currentFashionStage = self.currentFashionStage or 1
  self:InitFashionInnerTabs()
  local fashionTable = self:FindGO("FashionTable", self.level2FashionCustom)
  if fashionTable then
    self.fashionPartList = {}
    for i = 1, 3 do
      local partGO = self:FindGO("Part" .. i, fashionTable)
      if partGO then
        local partData = {
          gameObject = partGO,
          partIndex = i,
          label = self:FindComponent("Label", UILabel, partGO),
          cellScrollView = self:FindGO("CellScrollView", partGO),
          grid = nil,
          listCtrl = nil
        }
        if partData.label then
          local labelKey = "CrownCustomPage_FashionPart" .. i
          partData.label.text = ZhString[labelKey] or ""
        end
        if partData.cellScrollView then
          local gridGO = self:FindGO("Grid", partData.cellScrollView)
          if gridGO then
            partData.grid = gridGO:GetComponent(UIGrid)
            if partData.grid then
              partData.listCtrl = UIGridListCtrl.new(partData.grid, SnowFashionItemCell, "SnowFashionItemCell")
              partData.listCtrl:AddEventListener(MouseEvent.MouseClick, self.OnFashionCellClick, self)
            end
          end
        end
        self.fashionPartList[i] = partData
      end
    end
  end
  local fashionUnlockTip = self:FindGO("FashionUnlockTip", self.level2FashionCustom)
  if fashionUnlockTip then
    self.fashionUnlockTip = fashionUnlockTip
    local unlockBG = self:FindGO("UnlockBG", fashionUnlockTip)
    if unlockBG then
      self.fashionUnlockDesc = self:FindComponent("UnlockDesc", UILabel, unlockBG)
    end
    self:Hide(fashionUnlockTip)
  end
  local fashionInUse = self:FindGO("FashioInUse", self.level2FashionCustom)
  if fashionInUse then
    self.fashionInUse = fashionInUse
    local bg = self:FindGO("BG", fashionInUse)
    if bg then
      self.fashionInUseDesc = self:FindComponent("InUseDesc", UILabel, bg)
    end
    self:Hide(fashionInUse)
  end
  local doUseBtn = self:FindGO("DoUseBtn", self.level2FashionCustom)
  if doUseBtn then
    self.doUseBtn = doUseBtn
    self.doUseLabel = self:FindComponent("DoUseLabel", UILabel, doUseBtn)
    self:AddClickEvent(doUseBtn, function()
      self:OnDoUseBtnClick()
    end)
    self:Hide(doUseBtn)
  end
end

function CrownCustomPage:InitFashionInnerTabs()
  self.fashionInnerTabs = self:FindGO("InnerTabs", self.level2FashionCustom)
  if not self.fashionInnerTabs then
    return
  end
  self.fashionStageTabs = {}
  self.fashionInnerTabGrid = self.fashionInnerTabs:GetComponent(UIGrid)
  for i = 1, 3 do
    local stageGO = self:FindGO("Stage" .. i, self.fashionInnerTabs)
    if stageGO then
      local stageData = {
        gameObject = stageGO,
        stage = i,
        toggle = stageGO:GetComponent(UIToggle),
        lock = self:FindGO("Lock", stageGO)
      }
      self:AddClickEvent(stageGO, function()
        self:OnFashionStageTabClick(i)
      end)
      self.fashionStageTabs[i] = stageData
    end
  end
  if self.fashionInnerTabGrid then
    self.fashionInnerTabGrid:Reposition()
  end
end

function CrownCustomPage:IsFashionStageUnlocked(stage)
  if not stage then
    return false
  end
  if SnowCrownProxy.Instance then
    return SnowCrownProxy.Instance:IsStageUnlocked(stage)
  end
  return stage == 1
end

function CrownCustomPage:GetDefaultFashionStage()
  local proxy = SnowCrownProxy.Instance
  if proxy then
    local currentGroup = proxy:GetCurrentFashionGroup()
    if currentGroup and self:IsFashionStageUnlocked(currentGroup) then
      return currentGroup
    end
  end
  for i = 1, 3 do
    if self:IsFashionStageUnlocked(i) then
      return i
    end
  end
  return 1
end

function CrownCustomPage:EnsureCurrentFashionStage()
  if not self.currentFashionStage or not self:IsFashionStageUnlocked(self.currentFashionStage) then
    self.currentFashionStage = self:GetDefaultFashionStage()
  end
  return self.currentFashionStage or 1
end

function CrownCustomPage:RefreshFashionStageTabs()
  if not self.fashionStageTabs then
    return
  end
  local currentStage = self:EnsureCurrentFashionStage()
  for i = 1, 3 do
    local stageData = self.fashionStageTabs[i]
    if stageData then
      local isUnlocked = self:IsFashionStageUnlocked(i)
      if stageData.lock then
        stageData.lock:SetActive(not isUnlocked)
      end
      if stageData.toggle then
        stageData.toggle.value = i == currentStage
      end
    end
  end
end

function CrownCustomPage:HideFashionStatus()
  if self.fashionUnlockTip then
    self:Hide(self.fashionUnlockTip)
  end
  if self.fashionInUse then
    self:Hide(self.fashionInUse)
  end
  if self.doUseBtn then
    self:Hide(self.doUseBtn)
  end
end

function CrownCustomPage:OnFashionStageTabClick(stage)
  if not self:IsFashionStageUnlocked(stage) then
    self:RefreshFashionStageTabs()
    return
  end
  if self.currentFashionStage == stage then
    return
  end
  self.currentFashionStage = stage
  self:ClearFashionCellSelection()
  self:HideFashionStatus()
  self:RefreshFashionStageTabs()
  self:RefreshFashionCustom()
end

function CrownCustomPage:InitViewState()
  if self.level1LevelUp then
    self:Show(self.level1LevelUp)
  end
  if self.level2AttrNode then
    self:Hide(self.level2AttrNode)
  end
  if self.level2NodeDetail then
    self:Hide(self.level2NodeDetail)
  end
  if self.level2FashionCustom then
    self:Hide(self.level2FashionCustom)
  end
  if self.helpBtn then
    self:Show(self.helpBtn)
  end
  if self.backButton then
    self:Hide(self.backButton)
  end
end

function CrownCustomPage:RefreshAllDisplay()
  if not SnowCrownProxy.Instance then
    return
  end
  local currentLevel = SnowCrownProxy.Instance:GetCurrentLevel()
  if not self.lastKnownLevel then
    self.lastKnownLevel = currentLevel
  end
  local isInFashionCustom = self.level2FashionCustom and self.level2FashionCustom.activeInHierarchy
  if isInFashionCustom then
    self:RefreshFashionCustom()
    return
  end
  self:UpdateLevelDisplay(currentLevel)
  local isMaxLevel = self:IsMaxLevel(currentLevel)
  if self.level1LevelUp then
    local isLevel2Showing = (not self.level2AttrNode or not self.level2AttrNode.activeInHierarchy) and self.level2NodeDetail and self.level2NodeDetail.activeInHierarchy
    if not isLevel2Showing then
      self:Show(self.level1LevelUp)
      if isMaxLevel then
        if self.costTip then
          self:Hide(self.costTip)
        end
        if self.levelUpBtn then
          self:Hide(self.levelUpBtn)
        end
        if self.levelMaxTip then
          self:Show(self.levelMaxTip)
        end
        self:UpdateLevelUpCost(currentLevel)
      else
        if self.costTip then
          self:Show(self.costTip)
        end
        if self.levelUpBtn then
          self:Show(self.levelUpBtn)
        end
        if self.levelMaxTip then
          self:Hide(self.levelMaxTip)
        end
        self:UpdateLevelUpCost(currentLevel)
      end
    end
  end
  local useMode = SnowCrownProxy.Instance:GetCurrentUseMode()
  self.currentModeType = useMode
  self:UpdateCurModeDisplay()
  if self.level2AttrNode and self.level2AttrNode.activeInHierarchy then
    self:RefreshLevel2AttrNode()
  end
  if self.profitBord and self.profitBord.activeInHierarchy then
    self:RefreshProfitAttrs()
  end
end

function CrownCustomPage:UpdateLevelDisplay(level)
  if self.levelLabel then
    local levelText = ZhString.CrownCustomPage_LevelDisplay or "等级：%s"
    self.levelLabel.text = string.format(levelText, tostring(level or 0))
  end
end

function CrownCustomPage:IsMaxLevel(currentLevel)
  if not currentLevel or currentLevel < 1 then
    return false
  end
  local currentBatch = SnowCrownProxy.Instance and SnowCrownProxy.Instance:GetCurrentBatch() or 1
  if GameConfig.Snow and GameConfig.Snow.BatchInfo and GameConfig.Snow.BatchInfo[currentBatch] then
    local levelLimit = GameConfig.Snow.BatchInfo[currentBatch].level_limit
    if levelLimit and currentLevel >= levelLimit then
      return true
    end
  end
  local nextLevel = currentLevel + 1
  if GameConfig.Snow and GameConfig.Snow.LevelUpCost then
    local nextLevelCost = GameConfig.Snow.LevelUpCost[nextLevel]
    if not nextLevelCost or #nextLevelCost == 0 then
      return true
    end
  end
  return false
end

function CrownCustomPage:AddEvents()
  self:AddListenEvt(ServiceEvent.SnowCmdSnowHeadQuerySnowCmd, self.HandleSnowDataUpdate)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleItemUpdate)
end

function CrownCustomPage:HandleSnowDataUpdate(note)
  local newLevel = SnowCrownProxy.Instance and SnowCrownProxy.Instance:GetCurrentLevel() or 0
  if self.lastKnownLevel and newLevel > self.lastKnownLevel then
    self:PlayLevelUpEffect()
  end
  self.lastKnownLevel = newLevel
  if self.container and self.container.SetModelByEquippedFashion then
    self.container:SetModelByEquippedFashion()
  end
  self:RefreshAllDisplay()
end

function CrownCustomPage:PlayLevelUpEffect()
  if self.levelBG then
    self:PlayUIEffect(EffectMap.UI.SnowGem_LevelUP, self.levelBG, true)
  end
end

function CrownCustomPage:HandleItemUpdate(note)
  if self.levelUpCostItemId and self.costCount and BagProxy.Instance then
    local checkPackage = GameConfig.PackageMaterialCheck.snow_levelup
    local bagItemNum = BagProxy.Instance:GetItemNumByStaticID(self.levelUpCostItemId, checkPackage)
    local count = self.levelUpCostCount or 0
    if bagItemNum < count then
      self.costCount.color = ColorUtil.Red
    else
      self.costCount.color = ColorUtil.NGUIWhite
    end
  end
  self:UpdateSliverDisplay()
end

function CrownCustomPage:TweenLevelBGPosition(targetX, duration)
  if not self.levelBG then
    return
  end
  if self.levelBGTweener then
    self.levelBGTweener.enabled = false
    self.levelBGTweener = nil
  end
  local tweenDuration = duration or self.levelBGTweenDuration or 0.3
  local currentPos = self.levelBG.transform.localPosition
  local targetPos = LuaGeometry.GetTempVector3(targetX, currentPos.y, currentPos.z)
  self.levelBGTweener = TweenPosition.Begin(self.levelBG, tweenDuration, targetPos)
  if self.levelBGTweener then
    self.levelBGTweener.method = 2
  end
end

function CrownCustomPage:OnBackButtonClick()
  if self.level2AttrNode then
    self:Hide(self.level2AttrNode)
  end
  if self.level2NodeDetail then
    self:Hide(self.level2NodeDetail)
  end
  local isFromFashionCustom = self.level2FashionCustom and self.level2FashionCustom.activeInHierarchy
  if self.level2FashionCustom then
    self:Hide(self.level2FashionCustom)
  end
  if isFromFashionCustom then
    self:RestoreModelToEquippedFashion()
  end
  if self.container and self.container.TweenModelTexturePosition then
    self.container:TweenModelTexturePosition(SnowCrownContainerView.ModelPosition.Default)
  end
  self:TweenLevelBGPosition(0)
  if isFromFashionCustom and self.center then
    self:Show(self.center)
  end
  if self.modeTabs then
    self:Show(self.modeTabs)
  end
  if self.profitBtn then
    self:Show(self.profitBtn)
  end
  if self.level1Funcs then
    self:Show(self.level1Funcs)
  end
  if self.level1LevelUp then
    local currentLevel = SnowCrownProxy.Instance and SnowCrownProxy.Instance:GetCurrentLevel() or 0
    local isMaxLevel = self:IsMaxLevel(currentLevel)
    self:Show(self.level1LevelUp)
    if isMaxLevel then
      if self.costTip then
        self:Hide(self.costTip)
      end
      if self.levelUpBtn then
        self:Hide(self.levelUpBtn)
      end
      if self.levelMaxTip then
        self:Show(self.levelMaxTip)
      end
    else
      if self.costTip then
        self:Show(self.costTip)
      end
      if self.levelUpBtn then
        self:Show(self.levelUpBtn)
      end
      if self.levelMaxTip then
        self:Hide(self.levelMaxTip)
      end
    end
  end
  if self.helpBtn then
    self:Show(self.helpBtn)
  end
  if self.backButton then
    self:Hide(self.backButton)
  end
  self:ClearNodeCellSelection()
  if self.ClearFashionCellSelection then
    self:ClearFashionCellSelection()
  end
end

function CrownCustomPage:OnActiveBtnClick()
  if self.selectedNodeId and SnowCrownProxy.Instance then
    SnowCrownProxy.Instance:RequestActive(self.selectedNodeId)
  end
end

function CrownCustomPage:OnLevelUpBtnClick()
  if not SnowCrownProxy.Instance then
    return
  end
  local currentLevel = SnowCrownProxy.Instance:GetCurrentLevel()
  local nextLevel = (currentLevel or 0) + 1
  local costConfig = GameConfig.Snow.LevelUpCost[nextLevel]
  if not (costConfig and costConfig[1]) or #costConfig[1] < 2 then
    SnowCrownProxy.Instance:RequestLevelUp()
    return
  end
  local itemId = costConfig[1][1]
  local needCount = costConfig[1][2]
  if BagProxy.Instance then
    local checkPackage = GameConfig.PackageMaterialCheck.snow_levelup
    local bagItemNum = BagProxy.Instance:GetItemNumByStaticID(itemId, checkPackage)
    if needCount > bagItemNum then
      MsgManager.ShowMsgByID(8)
      return
    end
  end
  SnowCrownProxy.Instance:RequestLevelUp()
end

function CrownCustomPage:UpdateLevelUpCost(currentLevel)
  local nextLevel = (currentLevel or 0) + 1
  local costConfig = GameConfig.Snow.LevelUpCost[nextLevel]
  costConfig = costConfig or GameConfig.Snow.LevelUpCost[currentLevel or 2]
  if not (costConfig and self.costIcon) or not self.costCount then
    return
  end
  if costConfig[1] and #costConfig[1] >= 2 then
    local itemId = costConfig[1][1]
    local count = costConfig[1][2]
    self.levelUpCostItemId = itemId
    self.levelUpCostCount = count
    IconManager:SetItemIconById(itemId, self.costIcon)
    self.costIcon:MakePixelPerfect()
    self.costIcon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.5, 0.5, 0.5)
    if self.costCount then
      self.costCount.text = tostring(count)
      if BagProxy.Instance then
        local checkPackage = GameConfig.PackageMaterialCheck.snow_levelup
        local bagItemNum = BagProxy.Instance:GetItemNumByStaticID(itemId, checkPackage)
        if count > bagItemNum then
          self.costCount.color = ColorUtil.Red
        else
          self.costCount.color = ColorUtil.NGUIWhite
        end
      end
    end
    self:UpdateSliverDisplay(itemId)
  end
end

function CrownCustomPage:UpdateSliverDisplay(itemId)
  if not self.sliverSymbol or not self.sliverLabel then
    return
  end
  if not itemId then
    local currentLevel = SnowCrownProxy.Instance and SnowCrownProxy.Instance:GetCurrentLevel() or 0
    local nextLevel = currentLevel + 1
    local costConfig = GameConfig.Snow.LevelUpCost[nextLevel]
    if costConfig and costConfig[1] and #costConfig[1] >= 2 then
      itemId = costConfig[1][1]
    end
  end
  if not itemId then
    return
  end
  IconManager:SetItemIconById(itemId, self.sliverSymbol)
  self.sliverSymbol:MakePixelPerfect()
  self.sliverSymbol.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.5, 0.5, 0.5)
  if self.sliverLabel and BagProxy.Instance then
    local checkPackage = GameConfig.PackageMaterialCheck.snow_levelup
    local bagItemNum = BagProxy.Instance:GetItemNumByStaticID(itemId, checkPackage)
    self.sliverLabel.text = tostring(bagItemNum)
  end
  self.currentSliverItemId = itemId
end

function CrownCustomPage:OnSliverClick()
  if not self.currentSliverItemId or not self.sliver then
    return
  end
  local itemData = ItemData.new("Reward", self.currentSliverItemId)
  if not itemData then
    return
  end
  if not self.tipData then
    self.tipData = {}
  end
  self.tipData.itemdata = itemData
  self:ShowItemTip(self.tipData, self.sliverSymbol, NGUIUtil.AnchorSide.Left, {-200, 0})
end

function CrownCustomPage:OnProfitBtnClick()
  xdlog("OnProfitBtnClick")
  if self.profitBord then
    local isShow = not self.profitBord.activeInHierarchy
    self.profitBord:SetActive(isShow)
    xdlog("刷新总属性显示", isShow)
    if isShow then
      self:RefreshProfitAttrs()
    end
  end
end

function CrownCustomPage:RefreshProfitAttrs()
  if not self.profitAttrListCtrl or not SnowCrownProxy.Instance then
    return
  end
  local totalAttrs = SnowCrownProxy.Instance:GetTotalAttrsByMode(self.currentModeType)
  self.profitAttrListCtrl:ResetDatas(totalAttrs)
end

function CrownCustomPage:RefreshLevel2AttrNode()
  if not self.stageList or not SnowCrownProxy.Instance then
    return
  end
  self:ClearNodeCellSelection()
  self:UpdateLeftPointLabel()
  for i = 1, #self.stageList do
    local stageData = self.stageList[i]
    if stageData and stageData.listCtrl then
      local nodeDatas = SnowCrownProxy.Instance:GetNodeDatasByBatchAndMode(i, self.currentModeType)
      stageData.listCtrl:ResetDatas(nodeDatas)
      if stageData.label then
        stageData.label.text = SnowCrownProxy.Instance:GetStageLabelText(i)
      end
      local isLocked = not SnowCrownProxy.Instance:IsStageUnlocked(i)
      self:UpdateStageLockState(stageData, isLocked)
    end
  end
  self:SelectFirstUnlockedNode()
end

function CrownCustomPage:SelectFirstUnlockedNode()
  if not self.stageList then
    return
  end
  for i = 1, #self.stageList do
    local stageData = self.stageList[i]
    if stageData and stageData.listCtrl and stageData.listCtrl.cells then
      local isStageUnlocked = SnowCrownProxy.Instance and SnowCrownProxy.Instance:IsStageUnlocked(i) or false
      if isStageUnlocked then
        for j = 1, #stageData.listCtrl.cells do
          local cell = stageData.listCtrl.cells[j]
          if cell and cell.data then
            local isNodeUnlocked = cell.data.isUnlocked or cell.data.isActivated or false
            if not isNodeUnlocked then
              self:OnNodeCellClick(cell)
              return
            end
          end
        end
      end
    end
  end
  local firstStageData = self.stageList[1]
  if firstStageData and firstStageData.listCtrl and firstStageData.listCtrl.cells then
    local firstCell = firstStageData.listCtrl.cells[1]
    if firstCell then
      self:OnNodeCellClick(firstCell)
    end
  end
end

function CrownCustomPage:ClearNodeCellSelection()
  if self.stageList then
    for i = 1, #self.stageList do
      local stageData = self.stageList[i]
      if stageData and stageData.listCtrl and stageData.listCtrl.cells then
        for _, cell in pairs(stageData.listCtrl.cells) do
          if cell and cell.SetSelected then
            cell:SetSelected(false)
          end
        end
      end
    end
  end
  self.selectedNodeCell = nil
end

function CrownCustomPage:UpdateLeftPointLabel()
  if not self.leftPointLabel or not SnowCrownProxy.Instance then
    return
  end
  local currentLevel = SnowCrownProxy.Instance:GetCurrentLevel()
  local activatedIds = SnowCrownProxy.Instance:GetActivatedIdsByMode(self.currentModeType)
  local activatedCount = activatedIds and #activatedIds or 0
  local leftPoints = currentLevel - activatedCount
  if leftPoints < 0 then
    leftPoints = 0
  end
  local leftPointText = ZhString.CrownCustomPage_LeftPoint or "剩余点数：%s点"
  self.leftPointLabel.text = string.format(leftPointText, tostring(leftPoints))
  self:UpdateActiveBtnState(leftPoints)
end

function CrownCustomPage:UpdateActiveBtnState(leftPoints)
  if not self.activeBtn or not self.activeBtn.activeInHierarchy then
    return
  end
  if not leftPoints then
    if not SnowCrownProxy.Instance then
      return
    end
    local currentLevel = SnowCrownProxy.Instance:GetCurrentLevel()
    local activatedIds = SnowCrownProxy.Instance:GetActivatedIdsByMode(self.currentModeType)
    local activatedCount = activatedIds and #activatedIds or 0
    leftPoints = currentLevel - activatedCount
    if leftPoints < 0 then
      leftPoints = 0
    end
  end
  if leftPoints <= 0 then
    self:SetTextureGrey(self.activeBtn)
    if self.activeBtnCollider then
      self.activeBtnCollider.enabled = false
    end
  else
    self:SetTextureWhite(self.activeBtn, ColorUtil.ButtonLabelOrange)
    if self.activeBtnCollider then
      self.activeBtnCollider.enabled = true
    end
  end
end

function CrownCustomPage:UpdateStageLockState(stageData, isLocked)
  if not stageData then
    return
  end
  if isLocked then
    if stageData.lock then
      self:Show(stageData.lock)
    end
    if stageData.star then
      self:Hide(stageData.star)
    end
  else
    if stageData.lock then
      self:Hide(stageData.lock)
    end
    if stageData.star then
      self:Show(stageData.star)
    end
  end
end

function CrownCustomPage:OnAttrBtnClick()
  if self.level1LevelUp then
    self:Hide(self.level1LevelUp)
  end
  if self.level1Funcs then
    self:Hide(self.level1Funcs)
  end
  if self.level2NodeDetail then
    self:Show(self.level2NodeDetail)
  end
  if self.level2AttrNode then
    self:Show(self.level2AttrNode)
    self:RefreshLevel2AttrNode()
  end
  if self.container and self.container.TweenModelTexturePosition then
    self.container:TweenModelTexturePosition(SnowCrownContainerView.ModelPosition.NodeDetail)
  end
  self:TweenLevelBGPosition(-80)
  if self.helpBtn then
    self:Hide(self.helpBtn)
  end
  if self.backButton then
    self:Show(self.backButton)
  end
end

function CrownCustomPage:OnNodeCellClick(cell)
  xdlog("OnNodeCellClick")
  if not cell or not cell.data then
    return
  end
  if self.selectedNodeCell and self.selectedNodeCell ~= cell and self.selectedNodeCell.SetSelected then
    self.selectedNodeCell:SetSelected(false)
  end
  if cell.SetSelected then
    cell:SetSelected(true)
  end
  self.selectedNodeCell = cell
  self.selectedNodeId = cell.data.id
  if self.level2NodeDetail then
    self:Show(self.level2NodeDetail)
    if cell.data.config then
      local config = cell.data.config
      if self.nodeName then
        self.nodeName.text = config.Name or ""
      end
      if self.nodeDesc then
        local nodeId = cell.data.id
        if nodeId and Table_SnowMode[nodeId] then
          self.nodeDesc.text = Table_SnowMode[nodeId].Desc or ""
        else
          self.nodeDesc.text = ""
        end
      end
      if self.nodeSprite and config.Icon then
        IconManager:SetItemIcon(config.Icon, self.nodeSprite)
      end
      local batch = config.Batch or 1
      local isStageUnlocked = SnowCrownProxy.Instance and SnowCrownProxy.Instance:IsStageUnlocked(batch) or false
      if isStageUnlocked then
        if self.lockStatus then
          self:Hide(self.lockStatus)
        end
        local isNodeUnlocked = cell.data.isUnlocked or cell.data.isActivated or false
        if self.nodeCostLabel then
          if isNodeUnlocked then
            self:Hide(self.nodeCostLabel)
          else
            self:Show(self.nodeCostLabel)
            local costText = ZhString.CrownCustomPage_NodeCost or "消耗：%s点"
            local costPoint = 1
            self.nodeCostLabel.text = string.format(costText, tostring(costPoint))
          end
        end
        if self.activeBtn then
          if cell.data.isActivated then
            self:Hide(self.activeBtn)
          else
            self:Show(self.activeBtn)
            self:UpdateActiveBtnState()
          end
        end
      else
        if self.lockStatus then
          self:Show(self.lockStatus)
        end
        if self.nodeCostLabel then
          self:Hide(self.nodeCostLabel)
        end
        if self.activeBtn then
          self:Hide(self.activeBtn)
        end
      end
    end
  end
end

function CrownCustomPage:OnShowCustomBtnClick()
  if self.level1LevelUp then
    self:Hide(self.level1LevelUp)
  end
  if self.level1Funcs then
    self:Hide(self.level1Funcs)
  end
  if self.center then
    self:Hide(self.center)
  end
  if self.modeTabs then
    self:Hide(self.modeTabs)
  end
  if self.profitBtn then
    self:Hide(self.profitBtn)
  end
  if self.level2FashionCustom then
    self:Show(self.level2FashionCustom)
    self.currentFashionStage = self:GetDefaultFashionStage()
    self:ClearFashionCellSelection()
    self:HideFashionStatus()
    self:RefreshFashionCustom()
  end
  if self.container and self.container.TweenModelTexturePosition then
    self.container:TweenModelTexturePosition(SnowCrownContainerView.ModelPosition.FashionCustom)
  end
  if self.helpBtn then
    self:Hide(self.helpBtn)
  end
  if self.backButton then
    self:Show(self.backButton)
  end
end

function CrownCustomPage:InitShow()
  local guid = self.viewdata and self.viewdata.guid
  SnowCrownProxy.Instance:RequestQuery()
  self:RefreshAllDisplay()
end

function CrownCustomPage:OnExit()
  self.lastKnownLevel = nil
  CrownCustomPage.super.OnExit(self)
end

function CrownCustomPage:OnActivate()
  self:ResetToInitialState()
  self:RefreshAllDisplay()
end

function CrownCustomPage:OnDeactivate()
  self:RestoreModelToEquippedFashion()
end

function CrownCustomPage:RestoreModelToEquippedFashion()
  if self.container and self.container.SetModelByEquippedFashion then
    self.container:SetModelByEquippedFashion()
  end
end

function CrownCustomPage:ResetToInitialState()
  if self.level2AttrNode then
    self:Hide(self.level2AttrNode)
  end
  if self.level2NodeDetail then
    self:Hide(self.level2NodeDetail)
  end
  if self.level2FashionCustom then
    self:Hide(self.level2FashionCustom)
  end
  if self.level1Funcs then
    self:Show(self.level1Funcs)
  end
  if self.modeTabs then
    self:Show(self.modeTabs)
  end
  if self.profitBtn then
    self:Show(self.profitBtn)
  end
  if self.center then
    self:Show(self.center)
  end
  if self.helpBtn then
    self:Show(self.helpBtn)
  end
  if self.backButton then
    self:Hide(self.backButton)
  end
  self:TweenLevelBGPosition(0)
  self:ClearNodeCellSelection()
  if self.ClearFashionCellSelection then
    self:ClearFashionCellSelection()
  end
end

function CrownCustomPage:RefreshFashionCustom()
  if not self.fashionPartList then
    redlog("RefreshFashionCustom not self.fashionPartList")
    return
  end
  if not SnowCrownProxy.Instance then
    return
  end
  local fashionGroup
  if self.fashionStageTabs and next(self.fashionStageTabs) then
    fashionGroup = self:EnsureCurrentFashionStage()
    self:RefreshFashionStageTabs()
  end
  for partIndex = 1, 3 do
    local partData = self.fashionPartList[partIndex]
    if partData and partData.listCtrl then
      local fashionList = SnowCrownProxy.Instance:GetFashionDataListByPos(partIndex, fashionGroup)
      local itemDataList = {}
      for i = 1, #fashionList do
        local fashionData = fashionList[i]
        local tempItemData = ItemData.new()
        tempItemData:ResetData(fashionData.itemId, fashionData.itemId)
        table.insert(itemDataList, {itemData = tempItemData, fashionData = fashionData})
      end
      partData.listCtrl:ResetDatas(itemDataList)
    end
  end
  if self.container and self.container.SetModelByEquippedFashion then
    self.container:SetModelByEquippedFashion()
  end
end

function CrownCustomPage:OnFashionCellClick(cell)
  if not cell or not cell.data then
    return
  end
  self:ClearFashionCellSelection()
  local partIndex
  for i = 1, 3 do
    local partData = self.fashionPartList[i]
    if partData and partData.listCtrl then
      local cells = partData.listCtrl:GetCells()
      if cells then
        for j = 1, #cells do
          local c = cells[j]
          if c == cell then
            partIndex = i
            break
          end
        end
      end
      if partIndex then
        break
      end
    end
  end
  if not partIndex then
    return
  end
  self.selectedFashionCells[partIndex] = cell
  if cell.chooseSymbol then
    cell.chooseSymbol:SetActive(true)
  end
  local fashionData = cell.fashionData
  if fashionData then
    self.selectedFashionId = fashionData.id
    self:UpdateFashionCellStatus(cell, partIndex, fashionData)
    if not fashionData.isUnlocked then
      return
    end
    if self.container and self.container.SetModelBody then
      local previewIndexes = SnowCrownProxy.Instance and SnowCrownProxy.Instance:GetCompatibleFashionIndexes(partIndex, fashionData.index, true)
      self.selectedFashionUseIndexes = previewIndexes
      local previewBodyId = previewIndexes and SnowCrownProxy.ResolveFashionBody(previewIndexes[1], previewIndexes[2])
      local previewEffectPath = previewIndexes and SnowCrownProxy.ResolveFashionEffect(previewIndexes[3], true)
      if previewBodyId then
        self.container:SetModelBody(previewBodyId, previewEffectPath)
      end
    end
  end
end

function CrownCustomPage:UpdateFashionCellStatus(cell, partIndex, fashionData)
  if not cell or not fashionData then
    return
  end
  if self.fashionUnlockTip then
    self:Hide(self.fashionUnlockTip)
  end
  if self.fashionInUse then
    self:Hide(self.fashionInUse)
  end
  if self.doUseBtn then
    self:Hide(self.doUseBtn)
  end
  if not fashionData.isUnlocked then
    if self.fashionUnlockTip then
      self:Show(self.fashionUnlockTip)
      if self.fashionUnlockDesc then
        self.fashionUnlockDesc.text = fashionData.unlockDesc or ""
      end
    end
  else
    local isEquipped = fashionData.isEquipped or false
    if isEquipped then
      if self.fashionInUse then
        self:Show(self.fashionInUse)
      end
    else
      local canUse = SnowCrownProxy.Instance and SnowCrownProxy.Instance:GetCompatibleFashionIndexes(partIndex, fashionData.index, true) ~= nil
      if self.doUseBtn then
        if canUse then
          self:Show(self.doUseBtn)
        else
          self:Hide(self.doUseBtn)
        end
      end
    end
  end
end

function CrownCustomPage:ClearFashionCellSelection()
  if self.selectedFashionCells then
    for partIndex, cell in pairs(self.selectedFashionCells) do
      if cell and cell.chooseSymbol then
        cell.chooseSymbol:SetActive(false)
      end
    end
  end
  self.selectedFashionCells = {}
  self.selectedFashionId = nil
  self.selectedFashionUseIndexes = nil
end

function CrownCustomPage:OnDoUseBtnClick()
  local partIndex, fashionData
  for i = 1, 3 do
    local cell = self.selectedFashionCells[i]
    if cell then
      partIndex = i
      fashionData = cell.fashionData
      break
    end
  end
  if not partIndex or not fashionData then
    return
  end
  local index = fashionData.index
  if not index then
    helplog("CrownCustomPage:OnDoUseBtnClick | 未找到Index")
    return
  end
  local proxy = SnowCrownProxy.Instance
  local guid = self.viewdata and self.viewdata.guid
  if (not guid or guid == "") and proxy then
    guid = proxy.currentGuid or proxy:GetSnowCrownGuidFromBag()
    proxy.currentGuid = guid
  end
  if not guid or not ServiceSnowCmdProxy.Instance then
    return
  end
  local ops = proxy and proxy:GetCompatibleFashionUseOps(partIndex, index, true)
  if not ops or #ops == 0 then
    return
  end
  for i = 1, #ops do
    local op = ops[i]
    xdlog("CrownCustomPage:OnDoUseBtnClick | guid:", guid, "| pos:", op.pos, "| index:", op.index)
    ServiceSnowCmdProxy.Instance:CallSnowHeadFashionSelectSnowCmd(guid, op.pos, op.index)
  end
end
