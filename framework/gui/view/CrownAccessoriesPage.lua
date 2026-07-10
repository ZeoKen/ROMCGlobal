autoImport("SnowCrownProxy")
autoImport("BagItemCell")
autoImport("SnowGemActiveCell")
autoImport("SnowGemCell")
autoImport("SnowGemSetCell")
autoImport("TipLabelCell")
CrownAccessoriesPage = class("CrownAccessoriesPage", SubView)
CrownAccessoriesPage.ChoosePanelType = {
  None = 0,
  Equip = 1,
  Gem = 2
}
CrownAccessoriesPage.InnerTogglePageMap = {
  EmbedTab = "EmbedPage",
  CodexTab = "CodexPage",
  CollectionTab = "CollectionPage"
}
local _InnerTabNamePrefix = "CrownAccessoriesPage_TabName_"

function CrownAccessoriesPage:Init()
  CrownAccessoriesPage.super.Init(self)
  self:ReLoadPerferb("view/CrownAccessoriesPage")
  self.trans:SetParent(self.container.pageContainer.transform, false)
  self.activeInnerPageName = nil
  self.innerToggleMap = {}
  self.innerPageMap = {}
  self.slotList = {}
  self.currentChooseType = CrownAccessoriesPage.ChoosePanelType.None
  self.currentSlotIndex = nil
  self.currentGemIndex = nil
  self.isCodexMaxPreview = false
  self:InitInnerTabs()
  self:InitInnerPages()
  self:InitEmbedPage()
  self:InitCodexPage()
  self:InitCollectionPage()
  self:InitChoosePanel()
  self:AddEvents()
end

function CrownAccessoriesPage:InitInnerTabs()
  self.innerTabs = self:FindGO("InnerTabs")
  if not self.innerTabs then
    LogUtility.Error("CrownAccessoriesPage: Cannot find InnerTabs!")
    return
  end
  self.innerTabGrid = self.innerTabs:GetComponent(UIGrid)
  for tabName, pageName in pairs(self.InnerTogglePageMap) do
    self:FindAndAddInnerToggle(tabName, pageName)
  end
  if self.innerTabGrid then
    self.innerTabGrid:Reposition()
  end
end

function CrownAccessoriesPage:FindAndAddInnerToggle(toggleName, pageName)
  local toggleGO = self:FindGO(toggleName, self.innerTabs)
  if not toggleGO then
    LogUtility.Error("CrownAccessoriesPage: Cannot find toggle " .. toggleName)
    return nil
  end
  self:AddClickEvent(toggleGO, function(go)
    self:SwitchToInnerPage(self.InnerTogglePageMap[go.name])
  end)
  local tabText = ZhString["CrownAccessoriesPage_TabName_" .. toggleName]
  if tabText then
    local labels = toggleGO:GetComponentsInChildren(UILabel, true)
    if labels then
      for i = 1, #labels do
        labels[i].text = tabText
      end
    end
  end
  local toggle = toggleGO:GetComponent(UIToggle)
  if toggle then
    self.innerToggleMap[pageName] = toggle
  end
  return toggle
end

function CrownAccessoriesPage:InitInnerPages()
  self.innerPageContainer = self:FindGO("InnerPageContainer")
  if not self.innerPageContainer then
    LogUtility.Error("CrownAccessoriesPage: Cannot find InnerPageContainer!")
    return
  end
  for tabName, pageName in pairs(self.InnerTogglePageMap) do
    local pageGO = self:FindGO(pageName, self.innerPageContainer)
    if pageGO then
      self.innerPageMap[pageName] = pageGO
      pageGO:SetActive(false)
    else
      LogUtility.Error("CrownAccessoriesPage: Cannot find page " .. pageName)
    end
  end
end

function CrownAccessoriesPage:InitEmbedPage()
  local embedPage = self.innerPageMap.EmbedPage
  if not embedPage then
    return
  end
  self.profitBtn = self:FindGO("ProfitBtn", embedPage)
  if self.profitBtn then
    self:AddClickEvent(self.profitBtn, function()
      self:OnProfitBtnClick()
    end)
  end
  self.helpBtn = self:FindGO("HelpBtn", embedPage)
  if self.helpBtn then
    self:RegistShowGeneralHelpByHelpID(32655, self.helpBtn)
  end
  for i = 1, 3 do
    local slotGO = self:FindGO("Slot" .. i, embedPage)
    if slotGO then
      local slotData = {
        gameObject = slotGO,
        slotIndex = i,
        widget = slotGO:GetComponent(UIWidget),
        equipCell = nil,
        equipChooseSymbol = nil,
        gemCells = {},
        gemChooseSymbols = {}
      }
      local equipBG = self:FindGO("EquipBG", slotGO)
      if equipBG then
        slotData.equipChooseSymbol = self:FindGO("ChooseSymbol", equipBG)
        if slotData.equipChooseSymbol then
          slotData.equipChooseSymbol:SetActive(false)
        end
        local bagItemCellGO = self:LoadPreferb("cell/BagItemCell", equipBG)
        if bagItemCellGO then
          bagItemCellGO.name = "EquipBagItemCell"
          local equipCell = BagItemCell.new(bagItemCellGO)
          slotData.equipCell = equipCell
          self:AddClickEvent(bagItemCellGO, function()
            self:OnEquipSlotClick(i)
          end)
          self:AddClickEvent(equipBG, function()
            self:OnEquipSlotClick(i)
          end)
        end
      end
      for j = 1, 2 do
        local gemBG = self:FindGO("GemBG" .. j, slotGO)
        if gemBG then
          local gemChooseSymbol = self:FindGO("ChooseSymbol", gemBG)
          if gemChooseSymbol then
            gemChooseSymbol:SetActive(false)
          end
          slotData.gemChooseSymbols[j] = gemChooseSymbol
          local gemCellGO = self:FindGO("SnowGemActiveCell", gemBG)
          if gemCellGO then
            local gemCell = SnowGemActiveCell.new(gemCellGO)
            slotData.gemCells[j] = gemCell
            self:AddClickEvent(gemBG, function()
              self:OnGemSlotClick(i, j)
            end)
          end
        end
      end
      self.slotList[i] = slotData
    end
  end
end

function CrownAccessoriesPage:InitCodexPage()
  local codexPage = self.innerPageMap.CodexPage
  if not codexPage then
    return
  end
  self.codexCategories = {}
  self.codexScrollView = self:FindComponent("Scroll View", UIScrollView, codexPage)
  local tableGO = self:FindGO("Table", codexPage)
  if tableGO then
    self.codexTable = tableGO:GetComponent(UITable)
  end
  self:InitGemCategory("ProfessionGem", codexPage)
  self:InitGemCategory("NormalGem", codexPage)
  self:InitCodexContainer(codexPage)
end

function CrownAccessoriesPage:InitGemCategory(categoryName, parentGO)
  local categoryGO = self:FindGO(categoryName, parentGO)
  if not categoryGO then
    return
  end
  local categoryData = {
    gameObject = categoryGO,
    isExpanded = true,
    arrow = nil,
    arrowSprite = nil,
    gemGrid = nil,
    grid = nil,
    listCtrl = nil
  }
  categoryData.arrow = self:FindGO("Arrow", categoryGO)
  if categoryData.arrow then
    categoryData.arrowSprite = categoryData.arrow:GetComponent(UISprite)
    self:AddClickEvent(categoryData.arrow, function()
      self:ToggleGemCategory(categoryName)
    end)
  end
  categoryData.gemGrid = self:FindGO("GemGrid", categoryGO)
  if categoryData.gemGrid then
    categoryData.grid = categoryData.gemGrid:GetComponent(UIGrid)
    if categoryData.grid then
      categoryData.listCtrl = ListCtrl.new(categoryData.grid, SnowGemCell, "SnowGemCell")
      categoryData.listCtrl:AddEventListener(MouseEvent.MouseClick, self.OnCodexGemClick, self)
    end
  end
  self.codexCategories[categoryName] = categoryData
end

function CrownAccessoriesPage:InitCodexContainer(codexPage)
  self.codexContainer = self:FindGO("Container", codexPage)
  if not self.codexContainer then
    return
  end
  self:Hide(self.codexContainer)
  self.codexGemName = self:FindComponent("GemName", UILabel, self.codexContainer)
  self.codexGemLevel = self:FindComponent("GemLevel", UILabel, self.codexContainer)
  self.codexAttrScrollView = self:FindComponent("AttrScrollView", UIScrollView, self.codexContainer)
  self:InitCodexAttrLists()
  self.codexLevelUpBtn = self:FindGO("LevelUpBtn", self.codexContainer)
  if self.codexLevelUpBtn then
    self:AddClickEvent(self.codexLevelUpBtn, function()
      self:OnCodexLevelUpClick()
    end)
  end
  self.codexCostTip = self:FindGO("CostTip", self.codexContainer)
  if self.codexCostTip then
    self.codexCostIcon = self:FindComponent("CostIcon", UISprite, self.codexCostTip)
    self.codexCostCount = self:FindComponent("CostCount", UILabel, self.codexCostTip)
  end
  self.codexStatusLabel = self:FindComponent("StatusLabel", UILabel, self.codexContainer)
  self.codexMaxPreviewBtn = self:FindGO("MaxPreviewBtn", codexPage)
  if self.codexMaxPreviewBtn then
    self.codexMaxPreviewLabel = self:FindComponent("MaxPreviewLabel", UILabel, self.codexMaxPreviewBtn)
    self:AddClickEvent(self.codexMaxPreviewBtn, function()
      self:OnCodexMaxPreviewClick()
    end)
  end
  self:RefreshCodexMaxPreviewBtn()
end

function CrownAccessoriesPage:InitCodexAttrLists()
  if not self.codexAttrScrollView then
    return
  end
  local scrollViewGO = self.codexAttrScrollView.gameObject
  local tableGO = self:FindGO("Table", scrollViewGO)
  if tableGO then
    self.codexAttrTable = tableGO:GetComponent(UITable)
  end
  local basicAttrGO = self:FindGO("BasicAttr", scrollViewGO)
  if basicAttrGO then
    self.basicAttrLabel = self:FindComponent("Label", UILabel, basicAttrGO)
    local basicAttrTable = self:FindGO("AttrTable", basicAttrGO)
    if basicAttrTable then
      self.basicAttrTable = basicAttrTable:GetComponent(UITable)
      self.baseAttrBg = self:FindComponent("BaseAttrBg", UISprite, basicAttrGO)
      self.curLvAttrGO = self:FindGO("CurLvAttr", basicAttrTable)
      self.nextLvTipGO = self:FindGO("NextLvTip", basicAttrTable)
      self.nextLvAttrGO = self:FindGO("NextLvAttr", basicAttrTable)
      if self.curLvAttrGO then
        local curLvAttrTable = self.curLvAttrGO:GetComponent(UITable)
        if curLvAttrTable then
          self.basicAttrCtrl = UIGridListCtrl.new(curLvAttrTable, TipLabelCell, "SnowTipLabelCell")
        end
      end
      if self.nextLvAttrGO then
        local nextLvAttrTable = self.nextLvAttrGO:GetComponent(UITable)
        if nextLvAttrTable then
          self.nextLvAttrCtrl = UIGridListCtrl.new(nextLvAttrTable, TipLabelCell, "SnowTipLabelCell")
        end
      end
    end
  end
  local upgradeAttrGO = self:FindGO("UpgradeAttr", scrollViewGO)
  if upgradeAttrGO then
    self.upgradeAttrLabel = self:FindComponent("Label", UILabel, upgradeAttrGO)
    local upgradeAttrTable = self:FindGO("AttrTable", upgradeAttrGO)
    if upgradeAttrTable then
      local table = upgradeAttrTable:GetComponent(UITable)
      if table then
        self.upgradeAttrCtrl = UIGridListCtrl.new(table, TipLabelCell, "SnowTipLabelCell")
      end
    end
  end
end

local ROMAN_NUMERALS = {
  [0] = "0",
  [1] = "I",
  [2] = "II",
  [3] = "III",
  [4] = "IV",
  [5] = "V"
}
local MAX_ADV_LEVEL = 5
local GetMaxStoneLevel = function()
  local maxLevel = 0
  if Table_SnowStoneLevel then
    for id, _ in pairs(Table_SnowStoneLevel) do
      if id > maxLevel then
        maxLevel = id
      end
    end
  end
  return maxLevel
end
local GetSnowGemAdvanceProgress = function(advlv, advexp)
  advlv = advlv or 0
  advexp = advexp or 0
  if advlv >= MAX_ADV_LEVEL then
    return 0, true
  end
  local stoneAdvanceCount = GameConfig.Snow and GameConfig.Snow.StoneAdvanceCount or {}
  local maxCount = stoneAdvanceCount[advlv + 1]
  if not maxCount then
    return 0, true
  end
  local progressValue = advexp / maxCount
  if 1 < progressValue then
    progressValue = 1
  end
  return math.floor(progressValue * 100 + 0.5), false
end

function CrownAccessoriesPage:RefreshCodexMaxPreviewBtn()
  if self.codexMaxPreviewLabel then
    self.codexMaxPreviewLabel.text = self.isCodexMaxPreview and (ZhString.CrownAccessoriesPage_CancelPreview or "取消预览") or ZhString.CrownAccessoriesPage_MaxPreview or "满级预览"
  end
end

function CrownAccessoriesPage:RefreshSelectedCodexGemDetail()
  if not self.selectedGemId then
    return
  end
  local isUnlocked = false
  if SnowCrownProxy.Instance then
    isUnlocked = SnowCrownProxy.Instance:IsGemUnlocked(self.selectedGemId)
  end
  self:ShowCodexGemDetail(self.selectedGemId, isUnlocked)
end

function CrownAccessoriesPage:OnCodexMaxPreviewClick()
  self.isCodexMaxPreview = not self.isCodexMaxPreview
  self:RefreshCodexMaxPreviewBtn()
  self:RefreshSelectedCodexGemDetail()
end

function CrownAccessoriesPage:RefreshCodexAttrList(gemId, level, advLevel, advexp)
  if not gemId then
    return
  end
  local stoneConfig = Table_SnowStone and Table_SnowStone[gemId]
  if not stoneConfig then
    return
  end
  level = level or 0
  advLevel = advLevel or 1
  if advLevel < 1 then
    advLevel = 1
  end
  if self.basicAttrLabel then
    local maxLevel = GetMaxStoneLevel()
    self.basicAttrLabel.text = string.format(ZhString.CrownAccessoriesPage_BasicAttr, level, maxLevel)
  end
  if self.upgradeAttrLabel then
    local currentRoman = ROMAN_NUMERALS[advLevel] or "I"
    local maxRoman = ROMAN_NUMERALS[MAX_ADV_LEVEL] or "V"
    local advProgress, isMaxAdvLevel = GetSnowGemAdvanceProgress(advLevel, advexp)
    local progressText = isMaxAdvLevel and "" or string.format(ZhString.CrownAccessoriesPage_UpgradeProgress, advProgress)
    self.upgradeAttrLabel.text = string.format(ZhString.CrownAccessoriesPage_UpgradeAttr, currentRoman, maxRoman, progressText)
  end
  self:RefreshBasicAttrList(level)
  self:RefreshUpgradeAttrList(gemId, advLevel)
  if self.codexAttrTable then
    self.codexAttrTable:Reposition()
  end
  if self.codexAttrScrollView then
    self.codexAttrScrollView:ResetPosition()
  end
end

local ATTR_ICON_PREFIX = "{uiicon=new-com_icon_tips}"
local ATTR_LABEL_COLOR = "FFFFFF"
local ATTR_LABEL_CONFIG = {
  width = 290,
  labwidth = 290,
  iconColorHexStr = "FFFFFF"
}
local BuildBasicAttrList = function(level)
  local attrList = {}
  level = level or 0
  local levelConfig = Table_SnowStoneLevel and Table_SnowStoneLevel[level]
  local storeAttr = levelConfig and levelConfig.Attr
  if storeAttr then
    local mergedGroups = ItemTipBaseCell.MergeAttrsByValue(storeAttr)
    for _, group in ipairs(mergedGroups) do
      local attrText = ItemTipBaseCell.FormatMergedAttrText(group)
      if attrText and attrText ~= "" then
        local labelText = ATTR_ICON_PREFIX .. attrText
        table.insert(attrList, {
          label = labelText,
          hideline = true,
          color = ATTR_LABEL_COLOR,
          labelConfig = ATTR_LABEL_CONFIG
        })
      end
    end
  end
  return attrList, levelConfig ~= nil
end

function CrownAccessoriesPage:UpdateBasicAttrLayout()
  if self.basicAttrTable then
    self.basicAttrTable:Reposition()
  end
  if self.baseAttrBg and self.basicAttrTable then
    local bound = NGUIMath.CalculateRelativeWidgetBounds(self.basicAttrTable.transform)
    if bound then
      self.baseAttrBg.height = math.ceil(bound.size.y) + 10
    end
  end
end

function CrownAccessoriesPage:RefreshBasicAttrList(level)
  if not self.basicAttrCtrl then
    return
  end
  local attrList = BuildBasicAttrList(level)
  self.basicAttrCtrl:ResetDatas(attrList)
  local nextLevel = (level or 0) + 1
  local nextAttrList, hasNextLevel = BuildBasicAttrList(nextLevel)
  if self.curLvAttrGO then
    self.curLvAttrGO:SetActive(true)
  end
  if self.nextLvTipGO then
    self.nextLvTipGO:SetActive(hasNextLevel)
  end
  if self.nextLvAttrGO then
    self.nextLvAttrGO:SetActive(hasNextLevel)
  end
  if self.nextLvAttrCtrl then
    self.nextLvAttrCtrl:ResetDatas(hasNextLevel and nextAttrList or {})
  end
  self:UpdateBasicAttrLayout()
end

function CrownAccessoriesPage:RefreshUpgradeAttrList(stoneId, advLevel)
  if not self.upgradeAttrCtrl then
    return
  end
  local attrList = {}
  advLevel = advLevel or 0
  local stoneConfig = Table_SnowStone and Table_SnowStone[stoneId]
  if not stoneConfig or not stoneConfig.Desc then
    self.upgradeAttrCtrl:ResetDatas(attrList)
    return
  end
  local effectConfig
  if Table_SnowStoneEffect then
    for _, config in pairs(Table_SnowStoneEffect) do
      if config.StoneID == stoneId and config.Level == advLevel then
        effectConfig = config
        break
      end
    end
  end
  local SafeFormatDesc = function(desc, values)
    if not desc then
      return ""
    end
    desc = OverSea.LangManager.Instance():GetLangByKey(desc) or desc
    if not values or #values == 0 then
      return string.gsub(desc, "%%s", "-")
    end
    local _, count = string.gsub(desc, "%%s", "")
    local safeValues = {}
    for i = 1, count do
      safeValues[i] = values[i] or "-"
    end
    if 0 < #safeValues then
      return string.format(desc, unpack(safeValues))
    end
    return desc
  end
  local descText
  if effectConfig and effectConfig.Value then
    descText = SafeFormatDesc(stoneConfig.Desc, effectConfig.Value)
  else
    descText = SafeFormatDesc(stoneConfig.Desc, nil)
  end
  local labelText = descText
  table.insert(attrList, {
    label = labelText,
    hideline = true,
    color = ATTR_LABEL_COLOR,
    labelConfig = ATTR_LABEL_CONFIG
  })
  self.upgradeAttrCtrl:ResetDatas(attrList)
end

function CrownAccessoriesPage:FormatAttrText(attrName, attrValue)
  local propMap = Game.Config_PropName
  local propConfig = propMap and propMap[attrName]
  local displayName = propConfig and OverSea.LangManager.Instance():GetLangByKey(propConfig.PropName) or attrName
  return string.format("%s +%d", displayName, attrValue)
end

function CrownAccessoriesPage:GetBuffDesc(bufferId)
  if not bufferId or bufferId <= 0 then
    return nil
  end
  local bufferConfig = Table_Buffer and Table_Buffer[bufferId]
  if bufferConfig then
    return bufferConfig.BuffName
  end
  return nil
end

function CrownAccessoriesPage:ToggleGemCategory(categoryName)
  local categoryData = self.codexCategories and self.codexCategories[categoryName]
  if not categoryData then
    return
  end
  categoryData.isExpanded = not categoryData.isExpanded
  if categoryData.gemGrid then
    categoryData.gemGrid:SetActive(categoryData.isExpanded)
  end
  if categoryData.arrowSprite then
    if categoryData.isExpanded then
      categoryData.arrowSprite.flip = 0
    else
      categoryData.arrowSprite.flip = 2
    end
  end
  if self.codexTable then
    self.codexTable:Reposition()
  end
end

function CrownAccessoriesPage:OnCodexGemClick(cell)
  xdlog("OnCodexGemClick")
  if not cell or not cell.data then
    return
  end
  local gemData = cell.data
  local gemId = gemData.id
  self:UpdateCodexSelection(gemId)
  self:ShowCodexGemDetail(gemId, gemData.isUnlocked)
end

function CrownAccessoriesPage:UpdateCodexSelection(selectedGemId)
  self.selectedGemId = selectedGemId
  for categoryName, categoryData in pairs(self.codexCategories or {}) do
    if categoryData.listCtrl then
      local cells = categoryData.listCtrl:GetCells()
      if cells then
        for _, cell in pairs(cells) do
          if cell.data then
            local isSelected = cell.data.id == selectedGemId
            cell:SetSelected(isSelected)
          end
        end
      end
    end
  end
end

function CrownAccessoriesPage:ShowCodexGemDetail(gemId, isUnlocked)
  if not self.codexContainer then
    return
  end
  self:Show(self.codexContainer)
  local stoneConfig = Table_SnowStone and Table_SnowStone[gemId]
  if not stoneConfig then
    return
  end
  if self.codexGemName then
    local name = stoneConfig.NameZh or stoneConfig.Name or ""
    if name == "" then
      local itemConfig = Table_Item and Table_Item[gemId]
      if itemConfig and itemConfig.NameZh then
        name = itemConfig.NameZh
      end
    end
    self.codexGemName.text = name
  end
  local level = 0
  local advLevel = 0
  local advexp = 0
  if SnowCrownProxy.Instance then
    local bookData = SnowCrownProxy.Instance:GetStoneBookData(gemId)
    level = bookData and bookData.lv or 0
    advLevel = bookData and bookData.advlv or 0
    advexp = bookData and bookData.advexp or 0
  end
  local displayLevel = level
  local displayAdvLevel = advLevel
  local displayAdvexp = advexp
  if self.isCodexMaxPreview then
    displayLevel = GetMaxStoneLevel()
    displayAdvLevel = MAX_ADV_LEVEL
    displayAdvexp = 0
  end
  if self.codexGemLevel then
    self.codexGemLevel.text = string.format(ZhString.CrownAccessoriesPage_GemLevel, displayLevel)
  end
  self:RefreshCodexAttrList(gemId, displayLevel, displayAdvLevel, displayAdvexp)
  local nextLevel = level + 1
  local isMaxLevel = not Table_SnowStoneLevel or not Table_SnowStoneLevel[nextLevel]
  local showLevelUp = isUnlocked and not isMaxLevel and not self.isCodexMaxPreview
  xdlog("ShowLevelUp", isUnlocked, isMaxLevel, self.isCodexMaxPreview)
  if showLevelUp then
    if self.codexStatusLabel and self.codexStatusLabel.gameObject then
      self.codexStatusLabel.gameObject:SetActive(false)
    end
    if self.codexLevelUpBtn then
      self.codexLevelUpBtn:SetActive(true)
    end
    if self.codexCostTip then
      self.codexCostTip:SetActive(true)
    end
    self:RefreshCodexLevelUpCost(level)
  else
    if self.codexStatusLabel and self.codexStatusLabel.gameObject then
      self.codexStatusLabel.gameObject:SetActive(true)
      if self.isCodexMaxPreview then
        self.codexStatusLabel.text = ZhString.CrownAccessoriesPage_PreviewCantLevelUp or "预览状态无法升级"
      elseif not isUnlocked then
        self.codexStatusLabel.text = ZhString.CrownAccessoriesPage_GemLocked or "未解锁"
      else
        self.codexStatusLabel.text = ZhString.CrownAccessoriesPage_GemMaxLevel or "已满级"
      end
    end
    if self.codexLevelUpBtn then
      self.codexLevelUpBtn:SetActive(false)
    end
    if self.codexCostTip then
      self.codexCostTip:SetActive(false)
    end
  end
end

function CrownAccessoriesPage:GetCodexLevelUpCostData(level)
  local nextLevel = (level or 0) + 1
  local levelConfig = Table_SnowStoneLevel and Table_SnowStoneLevel[nextLevel]
  if not (levelConfig and levelConfig.Material) or not levelConfig.Material[1] then
    return
  end
  local costData = levelConfig.Material[1]
  local itemId = costData[1]
  local itemCount = costData[2] or 0
  local ownCount = 0
  local bagTypes = GameConfig.PackageMaterialCheck and GameConfig.PackageMaterialCheck.default
  if BagProxy.Instance and itemId then
    ownCount = BagProxy.Instance:GetItemNumByStaticID(itemId, bagTypes) or 0
  end
  return itemId, itemCount, ownCount
end

function CrownAccessoriesPage:RefreshCodexLevelUpCost(level)
  if not self.codexCostIcon or not self.codexCostCount then
    return
  end
  local nextLevel = level + 1
  local levelConfig = Table_SnowStoneLevel and Table_SnowStoneLevel[nextLevel]
  if not (levelConfig and levelConfig.Material) or not levelConfig.Material[1] then
    return
  end
  local costData = levelConfig.Material[1]
  local itemId = costData[1]
  local itemCount = costData[2]
  local itemConfig = Table_Item and Table_Item[itemId]
  if itemConfig and itemConfig.Icon then
    IconManager:SetItemIcon(itemConfig.Icon, self.codexCostIcon)
    self.codexCostIcon:MakePixelPerfect()
    self.codexCostIcon.transform.localScale = LuaVector3.New(0.5, 0.5, 0.5)
  end
  self.codexCostCount.text = tostring(itemCount)
end

function CrownAccessoriesPage:OnCodexLevelUpClick()
  if not self.selectedGemId then
    return
  end
  if self.isCodexMaxPreview then
    if self.codexStatusLabel and self.codexStatusLabel.gameObject then
      self.codexStatusLabel.gameObject:SetActive(true)
      self.codexStatusLabel.text = ZhString.CrownAccessoriesPage_PreviewCantLevelUp or "预览状态无法升级"
    end
    return
  end
  if SnowCrownProxy.Instance then
    SnowCrownProxy.Instance:RequestOperSnowStone(SnowCrownProxy.StoneOperEnum.LEVELUP, 0, 0, self.selectedGemId)
  end
  xdlog("OnCodexLevelUpClick", "gemId:", self.selectedGemId)
end

function CrownAccessoriesPage:InitChoosePanel()
  self.choosePanel = self:FindGO("ChoosePanel")
  if not self.choosePanel then
    return
  end
  self:Hide(self.choosePanel)
  self.selectedItemData = nil
  self.choosePanelTitle = self:FindComponent("ChoosePanelTitle", UILabel, self.choosePanel)
  self.chooseBg = self:FindComponent("Bg", UIWidget, self.choosePanel)
  self.noneTip = self:FindComponent("NoneTip", UILabel, self.choosePanel)
  self.chooseScrollView = self:FindComponent("ChooseScrollView", UIScrollView, self.choosePanel)
  if self.chooseScrollView then
    local gridGO = self:FindGO("Grid", self.chooseScrollView.gameObject)
    if gridGO then
      self.chooseGrid = gridGO:GetComponent(UIGrid)
      if self.chooseGrid then
        self.chooseListCtrl = ListCtrl.new(self.chooseGrid, BagItemCell, "BagItemCell")
        self.chooseListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnChooseItemClick, self)
      end
    end
  end
  self.embedBtn = self:FindGO("EmbedBtn", self.choosePanel)
  if self.embedBtn then
    self:AddClickEvent(self.embedBtn, function()
      self:OnEmbedBtnClick()
    end)
    self.embedBtnCollider = self.embedBtn:GetComponent(BoxCollider)
    self.embedBtnLabel = self:FindComponent("EmbedLabel", UILabel, self.embedBtn)
  end
  local closeBtn = self:FindGO("CloseBtn", self.choosePanel)
  if closeBtn then
    self:AddClickEvent(closeBtn, function()
      self:HideChoosePanel()
    end)
  end
end

function CrownAccessoriesPage:OnEquipSlotClick(slotIndex)
  self.currentSlotIndex = slotIndex
  self.currentGemIndex = nil
  self:ShowChoosePanel(CrownAccessoriesPage.ChoosePanelType.Equip)
end

function CrownAccessoriesPage:OnGemSlotClick(slotIndex, gemIndex)
  self.currentSlotIndex = slotIndex
  self.currentGemIndex = gemIndex
  self:ShowChoosePanel(CrownAccessoriesPage.ChoosePanelType.Gem)
end

function CrownAccessoriesPage:ShowChoosePanel(chooseType)
  if not self.choosePanel then
    return
  end
  self.currentChooseType = chooseType
  self.selectedItemData = nil
  self:Show(self.choosePanel)
  ServiceItemProxy.Instance:CallBrowsePackage(SceneItem_pb.EPACKTYPE_MAIN)
  if self.choosePanelTitle then
    if chooseType == CrownAccessoriesPage.ChoosePanelType.Equip then
      self.choosePanelTitle.text = ZhString.CrownAccessoriesPage_ChooseEquip or "选择装备"
    elseif chooseType == CrownAccessoriesPage.ChoosePanelType.Gem then
      self.choosePanelTitle.text = ZhString.CrownAccessoriesPage_ChooseGem or "选择冰珀"
    end
  end
  self:UpdateEmbedBtnLabel()
  self:UpdateSlotsAlpha(self.currentSlotIndex)
  self:UpdateChooseSymbol(self.currentSlotIndex, chooseType, self.currentGemIndex)
  self:RefreshChooseList()
end

function CrownAccessoriesPage:SetEmbedBtnEnabled(enabled)
  if not self.embedBtn then
    return
  end
  if enabled then
    self:SetTextureWhite(self.embedBtn, ColorUtil.ButtonLabelOrange)
  else
    self:SetTextureGrey(self.embedBtn)
  end
  if self.embedBtnCollider then
    self.embedBtnCollider.enabled = enabled
  end
end

function CrownAccessoriesPage:GetEquipSites(itemData)
  if not itemData or not itemData.equipInfo then
    return nil
  end
  local equipType = itemData.equipInfo:GetEquipType()
  if not equipType then
    return nil
  end
  local equipTypeConfig = GameConfig.EquipType and GameConfig.EquipType[equipType]
  return equipTypeConfig and equipTypeConfig.site
end

function CrownAccessoriesPage:GetRoleSnowEquipSites()
  local siteMap = {}
  if not BagProxy.Instance or not BagProxy.Instance.roleEquip then
    return siteMap
  end
  local items = BagProxy.Instance.roleEquip:GetItems()
  if not items then
    return siteMap
  end
  for i = 1, #items do
    local itemData = items[i]
    if itemData and itemData.equipInfo and itemData.equipInfo:IsSnowEquip() then
      local sites = self:GetEquipSites(itemData)
      if sites then
        for _, site in ipairs(sites) do
          siteMap[site] = true
        end
      end
    end
  end
  return siteMap
end

function CrownAccessoriesPage:CheckEquipSiteOccupied(itemData, occupiedSites)
  if not occupiedSites then
    return false
  end
  local sites = self:GetEquipSites(itemData)
  if not sites then
    return false
  end
  for _, site in ipairs(sites) do
    if occupiedSites[site] then
      return true
    end
  end
  return false
end

function CrownAccessoriesPage:UpdateEmbedBtnLabel()
  if not self.embedBtnLabel then
    return
  end
  local isEquipped = false
  if self.selectedItemData then
    if self.currentChooseType == CrownAccessoriesPage.ChoosePanelType.Equip then
      isEquipped = self:IsSelectedEquipEquipped(self.currentSlotIndex, self.selectedItemData)
    elseif self.currentChooseType == CrownAccessoriesPage.ChoosePanelType.Gem then
      isEquipped = self:IsSelectedGemEquipped(self.currentSlotIndex, self.currentGemIndex, self.selectedItemData)
    end
  end
  if isEquipped then
    self.embedBtnLabel.text = ZhString.CrownAccessoriesPage_Takeout or "卸下"
  else
    self.embedBtnLabel.text = ZhString.CrownAccessoriesPage_Embed or "镶嵌"
  end
  local enabled = true
  if self.currentChooseType == CrownAccessoriesPage.ChoosePanelType.Equip then
    enabled = isEquipped or not self.selectedItemData or self.selectedItemData.snowInvalid ~= true
  elseif self.currentChooseType == CrownAccessoriesPage.ChoosePanelType.Gem then
    enabled = isEquipped or not self.selectedItemData or self.selectedItemData.snowInvalid ~= true
  end
  self:SetEmbedBtnEnabled(enabled)
end

function CrownAccessoriesPage:HideChoosePanel()
  if self.choosePanel then
    self:Hide(self.choosePanel)
  end
  self:ShowItemTip()
  self:UpdateSlotsAlpha(nil)
  self:UpdateChooseSymbol(nil, nil, nil)
  self.currentChooseType = CrownAccessoriesPage.ChoosePanelType.None
  self.currentSlotIndex = nil
  self.currentGemIndex = nil
  self.selectedItemData = nil
end

function CrownAccessoriesPage:UpdateChooseSymbol(selectedSlotIndex, chooseType, gemIndex)
  if not self.slotList then
    return
  end
  for i = 1, 3 do
    local slotData = self.slotList[i]
    if slotData then
      if slotData.equipChooseSymbol then
        local isEquipSelected = selectedSlotIndex == i and chooseType == CrownAccessoriesPage.ChoosePanelType.Equip
        slotData.equipChooseSymbol:SetActive(isEquipSelected)
      end
      for j = 1, 2 do
        local gemChooseSymbol = slotData.gemChooseSymbols[j]
        if gemChooseSymbol then
          local isGemSelected = selectedSlotIndex == i and chooseType == CrownAccessoriesPage.ChoosePanelType.Gem and gemIndex == j
          gemChooseSymbol:SetActive(isGemSelected)
        end
      end
    end
  end
end

function CrownAccessoriesPage:UpdateSlotsAlpha(selectedSlotIndex)
  if not self.slotList then
    return
  end
  for i = 1, 3 do
    local slotData = self.slotList[i]
    if slotData and slotData.widget then
      if selectedSlotIndex then
        if i == selectedSlotIndex then
          slotData.widget.alpha = 1
        else
          slotData.widget.alpha = 0.5
        end
      else
        slotData.widget.alpha = 1
      end
    end
  end
end

function CrownAccessoriesPage:RefreshChooseList()
  if not self.chooseListCtrl then
    return
  end
  local itemList = {}
  if self.currentChooseType == CrownAccessoriesPage.ChoosePanelType.Equip then
    itemList = self:GetSnowEquipList()
    table.sort(itemList, function(a, b)
      local idA = a.staticData and a.staticData.id or 0
      local idB = b.staticData and b.staticData.id or 0
      if idA ~= idB then
        return idA < idB
      end
      local refinelvA = a.equipInfo and a.equipInfo.refinelv or 0
      local refinelvB = b.equipInfo and b.equipInfo.refinelv or 0
      return refinelvA > refinelvB
    end)
  elseif self.currentChooseType == CrownAccessoriesPage.ChoosePanelType.Gem then
    itemList = self:GetSnowGemList()
    table.sort(itemList, function(a, b)
      local invalidA = a.snowInvalid == true
      local invalidB = b.snowInvalid == true
      if invalidA ~= invalidB then
        return not invalidA
      end
      local recommendA = a.isRecommend == true
      local recommendB = b.isRecommend == true
      if recommendA ~= recommendB then
        return recommendA
      end
      local advlvA = a.snowGemData and a.snowGemData.advlv or 0
      local advlvB = b.snowGemData and b.snowGemData.advlv or 0
      if advlvA ~= advlvB then
        return advlvA > advlvB
      end
      local lvA = a.snowGemData and a.snowGemData.level or 0
      local lvB = b.snowGemData and b.snowGemData.level or 0
      if lvA ~= lvB then
        return lvA > lvB
      end
      local idA = a.staticData and a.staticData.id or 0
      local idB = b.staticData and b.staticData.id or 0
      return idA < idB
    end)
  end
  self.chooseListCtrl:ResetDatas(itemList)
  self:TrySelectCurrentGemInChooseList(itemList)
  if self.currentChooseType == CrownAccessoriesPage.ChoosePanelType.Equip or self.currentChooseType == CrownAccessoriesPage.ChoosePanelType.Gem then
    self:UpdateChooseListInvalidState()
  end
  local isEmpty = #itemList == 0
  if self.noneTip then
    self.noneTip.gameObject:SetActive(isEmpty)
    if isEmpty then
      if self.currentChooseType == CrownAccessoriesPage.ChoosePanelType.Equip then
        self.noneTip.text = ZhString.CrownAccessoriesPage_NoEquipTip or "暂无可存入的雪花装备"
      elseif self.currentChooseType == CrownAccessoriesPage.ChoosePanelType.Gem then
        self.noneTip.text = ZhString.CrownAccessoriesPage_NoGemTip or "暂无可存入的冰珀"
      end
    end
  end
  if self.embedBtn then
    self.embedBtn:SetActive(not isEmpty)
  end
  self:UpdateEmbedBtnLabel()
  if self.chooseScrollView then
    self.chooseScrollView:ResetPosition()
  end
end

function CrownAccessoriesPage:TrySelectCurrentGemInChooseList(itemList)
  if self.currentChooseType ~= CrownAccessoriesPage.ChoosePanelType.Gem then
    return
  end
  if not self.chooseListCtrl or not SnowCrownProxy.Instance then
    return
  end
  if not self.currentSlotIndex or not self.currentGemIndex then
    return
  end
  if not itemList or #itemList == 0 then
    return
  end
  local slotGemData = SnowCrownProxy.Instance:GetSlotGemData(self.currentSlotIndex, self.currentGemIndex)
  local currentGemId = slotGemData and slotGemData.id
  local selectedData
  if currentGemId then
    for i = 1, #itemList do
      local itemData = itemList[i]
      local itemId = itemData and itemData.staticData and itemData.staticData.id
      if itemId == currentGemId then
        selectedData = itemData
        break
      end
    end
  else
    selectedData = itemList[1]
  end
  if not selectedData then
    return
  end
  self.selectedItemData = selectedData
  local selectedGemId = selectedData.staticData and selectedData.staticData.id
  local selectedCell
  local cells = self.chooseListCtrl:GetCells()
  if cells then
    for _, cell in pairs(cells) do
      local itemData = cell and cell.data
      local itemId = itemData and itemData.staticData and itemData.staticData.id
      if itemData == selectedData or itemId == selectedGemId then
        selectedCell = cell
        break
      end
    end
  end
  if selectedCell then
    self:UpdateChooseListSelection(selectedCell)
  end
end

function CrownAccessoriesPage:GetSnowEquipList()
  local equipList = {}
  local bagTypes = GameConfig.PackageMaterialCheck and GameConfig.PackageMaterialCheck.default
  if not bagTypes or not BagProxy.Instance then
    return equipList
  end
  local validEquipPos
  if self.currentSlotIndex and Table_SnowEquip and Table_SnowEquip[self.currentSlotIndex] then
    validEquipPos = Table_SnowEquip[self.currentSlotIndex].ValidEquipPos
  end
  local equippedStaticIds = self:GetRoleEquippedStaticIds()
  local occupiedSites = self:GetRoleSnowEquipSites()
  local currentEquippedId
  if self.currentSlotIndex and SnowCrownProxy.Instance then
    local slotEquipData = SnowCrownProxy.Instance:GetSlotEquipData(self.currentSlotIndex)
    if slotEquipData then
      slotEquipData.isactive = true
      table.insert(equipList, slotEquipData)
      currentEquippedId = slotEquipData.id
    end
  end
  for i = 1, #bagTypes do
    local bagData = BagProxy.Instance:GetBagByType(bagTypes[i])
    if bagData then
      local items = bagData:GetItems()
      if items then
        for j = 1, #items do
          local itemData = items[j]
          if not (itemData and itemData.equipInfo and itemData.staticData) or currentEquippedId and itemData.id == currentEquippedId then
          else
            local equipId = itemData.staticData.id
            if Table_Equip and Table_Equip[equipId] then
              local equipConfig = Table_Equip[equipId]
              if equipConfig.IsNew == 2 and self:CheckEquipPosValid(itemData, validEquipPos) then
                itemData.snowInvalid = self:CheckEquipSiteOccupied(itemData, occupiedSites) or equippedStaticIds[equipId] == true
                table.insert(equipList, itemData)
              end
            end
          end
        end
      end
    end
  end
  return equipList
end

function CrownAccessoriesPage:GetRoleEquippedStaticIds()
  local staticIds = {}
  if not BagProxy.Instance or not BagProxy.Instance.roleEquip then
    return staticIds
  end
  local items = BagProxy.Instance.roleEquip:GetItems()
  if items then
    for i = 1, #items do
      local itemData = items[i]
      if itemData and itemData.staticData then
        local staticId = itemData.staticData.id
        if staticId then
          staticIds[staticId] = true
        end
      end
    end
  end
  return staticIds
end

function CrownAccessoriesPage:UpdateChooseListInvalidState()
  if not self.chooseListCtrl then
    return
  end
  local cells = self.chooseListCtrl:GetCells()
  if not cells then
    return
  end
  for i = 1, #cells do
    local cell = cells[i]
    if cell and cell.data then
      local isInvalid = cell.data.snowInvalid == true
      if cell.SetInvalid then
        cell:SetInvalid(isInvalid)
      elseif cell.itemCell and cell.itemCell.SetInvalid then
        cell.itemCell:SetInvalid(isInvalid)
      end
    end
  end
end

function CrownAccessoriesPage:CheckEquipPosValid(itemData, validEquipPos)
  if not validEquipPos then
    return true
  end
  local equipType = itemData.equipInfo:GetEquipType()
  if not equipType then
    return false
  end
  local equipTypeConfig = GameConfig.EquipType and GameConfig.EquipType[equipType]
  if not equipTypeConfig or not equipTypeConfig.site then
    return false
  end
  local sites = equipTypeConfig.site
  for _, site in ipairs(sites) do
    for _, validPos in ipairs(validEquipPos) do
      if site == validPos then
        return true
      end
    end
  end
  return false
end

function CrownAccessoriesPage:IsMyProfessionGem(gemId)
  local stoneConfig = Table_SnowStone and Table_SnowStone[gemId]
  if not (stoneConfig and stoneConfig.ClassID) or #stoneConfig.ClassID == 0 then
    return false
  end
  local myClass = MyselfProxy.Instance and MyselfProxy.Instance:GetMyProfession() or 0
  if not myClass or myClass == 0 then
    return false
  end
  return 0 < TableUtility.ArrayFindIndex(stoneConfig.ClassID, myClass)
end

function CrownAccessoriesPage:IsSnowGemProfessionValid(gemId)
  local stoneConfig = Table_SnowStone and Table_SnowStone[gemId]
  if not (stoneConfig and stoneConfig.ClassID) or #stoneConfig.ClassID == 0 then
    return true
  end
  return self:IsMyProfessionGem(gemId)
end

function CrownAccessoriesPage:GetSnowGemList()
  local gemList = {}
  if not SnowCrownProxy.Instance then
    return gemList
  end
  local snowManualData = SnowCrownProxy.Instance.snowManualData
  if not snowManualData or not snowManualData.stoneBook then
    return gemList
  end
  local currentEquippedGemId
  if self.currentSlotIndex and self.currentGemIndex then
    local slotGemData = SnowCrownProxy.Instance:GetSlotGemData(self.currentSlotIndex, self.currentGemIndex)
    if slotGemData then
      currentEquippedGemId = slotGemData.id
    end
  end
  local equippedStoneIds = {}
  if snowManualData.positions then
    for posIndex, posData in pairs(snowManualData.positions) do
      if posData.stoneids then
        for gemIdx, stoneId in ipairs(posData.stoneids) do
          if stoneId and 0 < stoneId and (posIndex ~= self.currentSlotIndex or gemIdx ~= self.currentGemIndex) then
            equippedStoneIds[stoneId] = true
          end
        end
      end
    end
  end
  if currentEquippedGemId and snowManualData.stoneBook[currentEquippedGemId] then
    local bookData = snowManualData.stoneBook[currentEquippedGemId]
    local itemData = ItemData.new(currentEquippedGemId, currentEquippedGemId)
    itemData:SetSnowGemData({
      id = currentEquippedGemId,
      level = bookData.lv or 0,
      advlv = bookData.advlv or 0,
      advexp = bookData.advexp or 0
    })
    itemData.isRecommend = self:IsMyProfessionGem(currentEquippedGemId)
    itemData.snowInvalid = not self:IsSnowGemProfessionValid(currentEquippedGemId)
    itemData.isactive = true
    table.insert(gemList, itemData)
  end
  for stoneId, bookData in pairs(snowManualData.stoneBook) do
    if not equippedStoneIds[stoneId] and stoneId ~= currentEquippedGemId then
      local itemData = ItemData.new(stoneId, stoneId)
      itemData:SetSnowGemData({
        id = stoneId,
        level = bookData.lv or 0,
        advlv = bookData.advlv or 0,
        advexp = bookData.advexp or 0
      })
      itemData.isRecommend = self:IsMyProfessionGem(stoneId)
      itemData.snowInvalid = not self:IsSnowGemProfessionValid(stoneId)
      table.insert(gemList, itemData)
    end
  end
  return gemList
end

function CrownAccessoriesPage:OnChooseItemClick(cell)
  if not cell or not cell.data then
    return
  end
  self.selectedItemData = cell.data
  self:UpdateChooseListSelection(cell)
  self:UpdateEmbedBtnLabel()
  if not self.tipData then
    self.tipData = {}
  end
  local clonedData = cell.data:Clone()
  if cell.data.snowGemData and clonedData.SetSnowGemData then
    clonedData:SetSnowGemData(cell.data.snowGemData)
  end
  clonedData.snowInvalid = cell.data.snowInvalid
  clonedData.snowStoreMode = true
  self.tipData.itemdata = clonedData
  TipManager.Instance:CloseItemTip()
  self:ShowItemTip(self.tipData, self.chooseBg, NGUIUtil.AnchorSide.Left, {-200, 0})
  xdlog("OnChooseItemClick | type:", self.currentChooseType, "| itemId:", cell.data.staticData and cell.data.staticData.id)
end

function CrownAccessoriesPage:UpdateChooseListSelection(selectedCell)
  if not self.chooseListCtrl then
    return
  end
  local cells = self.chooseListCtrl:GetCells()
  if cells then
    for _, cell in pairs(cells) do
      local isSelected = cell == selectedCell
      if cell.SetSelected then
        cell:SetSelected(isSelected)
      end
      if cell.chooseSymbol then
        cell.chooseSymbol:SetActive(isSelected)
      end
    end
  end
end

function CrownAccessoriesPage:OnEmbedBtnClick()
  if not self.selectedItemData then
    xdlog("OnEmbedBtnClick | no item selected")
    return
  end
  if self.currentChooseType == CrownAccessoriesPage.ChoosePanelType.Equip then
    if self.selectedItemData.snowInvalid == true and not self:IsSelectedEquipEquipped(self.currentSlotIndex, self.selectedItemData) then
      return
    end
    if self:IsSelectedEquipEquipped(self.currentSlotIndex, self.selectedItemData) then
      self:RequestTakeoutEquip()
    else
      self:RequestStoreEquip(self.selectedItemData)
    end
  elseif self.currentChooseType == CrownAccessoriesPage.ChoosePanelType.Gem then
    if self.selectedItemData.snowInvalid == true and not self:IsSelectedGemEquipped(self.currentSlotIndex, self.currentGemIndex, self.selectedItemData) then
      return
    end
    if self:IsSelectedGemEquipped(self.currentSlotIndex, self.currentGemIndex, self.selectedItemData) then
      self:RequestTakeoutStone()
    else
      self:RequestStoreStone(self.selectedItemData)
    end
  end
  self:HideChoosePanel()
end

function CrownAccessoriesPage:IsSelectedEquipEquipped(slotIndex, selectedItemData)
  if not SnowCrownProxy.Instance or not selectedItemData then
    return false
  end
  local slotEquipData = SnowCrownProxy.Instance:GetSlotEquipData(slotIndex)
  if not slotEquipData then
    return false
  end
  return slotEquipData.id == selectedItemData.id
end

function CrownAccessoriesPage:IsSelectedGemEquipped(slotIndex, gemIndex, selectedItemData)
  if not SnowCrownProxy.Instance or not selectedItemData then
    return false
  end
  local slotGemData = SnowCrownProxy.Instance:GetSlotGemData(slotIndex, gemIndex)
  if not slotGemData then
    return false
  end
  local selectedGemId = selectedItemData.staticData and selectedItemData.staticData.id
  return slotGemData.id == selectedGemId
end

function CrownAccessoriesPage:HasSlotEquip(slotIndex)
  if not SnowCrownProxy.Instance then
    return false
  end
  return SnowCrownProxy.Instance:GetSlotEquipData(slotIndex) ~= nil
end

function CrownAccessoriesPage:HasSlotGem(slotIndex, gemIndex)
  if not SnowCrownProxy.Instance then
    return false
  end
  return SnowCrownProxy.Instance:GetSlotGemData(slotIndex, gemIndex) ~= nil
end

function CrownAccessoriesPage:RequestStoreEquip(itemData)
  if not self.currentSlotIndex or not itemData then
    return
  end
  local equipGuid = itemData.id
  xdlog("RequestStoreEquip | slotIndex:", self.currentSlotIndex, "| guid:", equipGuid)
  if SnowCrownProxy.Instance then
    SnowCrownProxy.Instance:RequestOperSnowEquip(SnowCmd_pb.ESNOW_EQUIP_OPER_STORE, self.currentSlotIndex, equipGuid)
  end
end

function CrownAccessoriesPage:RequestTakeoutEquip()
  if not self.currentSlotIndex then
    return
  end
  xdlog("RequestTakeoutEquip | slotIndex:", self.currentSlotIndex)
  if SnowCrownProxy.Instance then
    SnowCrownProxy.Instance:RequestOperSnowEquip(SnowCmd_pb.ESNOW_EQUIP_OPER_TAKEOUT, self.currentSlotIndex, 0)
  end
end

function CrownAccessoriesPage:RequestStoreStone(itemData)
  if not (self.currentSlotIndex and self.currentGemIndex) or not itemData then
    return
  end
  if itemData.snowInvalid == true then
    return
  end
  local stoneId = itemData.staticData and itemData.staticData.id
  xdlog("RequestStoreStone | slotIndex:", self.currentSlotIndex, "| gemIndex:", self.currentGemIndex, "| stoneId:", stoneId)
  if SnowCrownProxy.Instance then
    SnowCrownProxy.Instance:RequestOperSnowStone(SnowCmd_pb.ESNOW_STONE_OPER_STORE, self.currentSlotIndex, self.currentGemIndex - 1, stoneId)
  end
end

function CrownAccessoriesPage:RequestTakeoutStone()
  if not self.currentSlotIndex or not self.currentGemIndex then
    return
  end
  xdlog("RequestTakeoutStone | slotIndex:", self.currentSlotIndex, "| gemIndex:", self.currentGemIndex)
  if SnowCrownProxy.Instance then
    SnowCrownProxy.Instance:RequestOperSnowStone(SnowCmd_pb.ESNOW_STONE_OPER_TAKEOUT, self.currentSlotIndex, self.currentGemIndex - 1, 0)
  end
end

function CrownAccessoriesPage:SwitchToInnerPage(pageName)
  if not pageName then
    return
  end
  local toggle = self.innerToggleMap[pageName]
  if toggle then
    toggle.value = true
  end
  local isActive
  for name, pageGO in pairs(self.innerPageMap) do
    isActive = name == pageName
    pageGO:SetActive(isActive)
    if isActive then
      self.activeInnerPageName = name
      self:OnInnerPageActivate(name)
    else
      self:OnInnerPageDeactivate(name)
    end
  end
end

function CrownAccessoriesPage:OnInnerPageActivate(pageName)
  if pageName == "EmbedPage" then
    self:RefreshEmbedPage()
  elseif pageName == "CodexPage" then
    self:RefreshCodexPage()
  elseif pageName == "CollectionPage" then
    self:RefreshCollectionPage()
  end
end

function CrownAccessoriesPage:OnInnerPageDeactivate(pageName)
end

function CrownAccessoriesPage:RefreshEmbedPage()
  if not self.slotList then
    return
  end
  for i = 1, 3 do
    local slotData = self.slotList[i]
    if slotData then
      self:RefreshSlotEquip(slotData, i)
      self:RefreshSlotGems(slotData, i)
    end
  end
end

function CrownAccessoriesPage:RefreshSlotEquip(slotData, slotIndex)
  if not slotData or not slotData.equipCell then
    return
  end
  local equipData
  if SnowCrownProxy.Instance then
    equipData = SnowCrownProxy.Instance:GetSlotEquipData(slotIndex)
  end
  if equipData then
    if slotData.equipCell.gameObject then
      slotData.equipCell.gameObject:SetActive(true)
    end
    slotData.equipCell:SetData(equipData)
  elseif slotData.equipCell.gameObject then
    slotData.equipCell.gameObject:SetActive(false)
  end
end

function CrownAccessoriesPage:RefreshSlotGems(slotData, slotIndex)
  if not slotData or not slotData.gemCells then
    return
  end
  local equipRefineLv = 0
  local hasEquip = false
  if SnowCrownProxy.Instance then
    local equipData = SnowCrownProxy.Instance:GetSlotEquipData(slotIndex)
    if equipData then
      hasEquip = true
      if equipData.equipInfo then
        equipRefineLv = equipData.equipInfo.refinelv or 0
      end
    end
  end
  for j = 1, 2 do
    local gemCell = slotData.gemCells[j]
    if gemCell then
      local gemData
      if SnowCrownProxy.Instance then
        gemData = SnowCrownProxy.Instance:GetSlotGemData(slotIndex, j)
      end
      gemCell:SetData(gemData)
      gemCell:SetEquipRefineLv(equipRefineLv, hasEquip)
    end
  end
end

function CrownAccessoriesPage:RefreshCodexPage()
  if not self.selectedGemId then
    self.selectedGemId = self:GetDefaultCodexGemId()
  end
  self:RefreshGemCategory("ProfessionGem")
  self:RefreshGemCategory("NormalGem")
  if self.codexContainer then
    self:Show(self.codexContainer)
  end
  if self.selectedGemId then
    self:UpdateCodexSelection(self.selectedGemId)
    local isUnlocked = false
    if SnowCrownProxy.Instance then
      isUnlocked = SnowCrownProxy.Instance:IsGemUnlocked(self.selectedGemId)
    end
    self:ShowCodexGemDetail(self.selectedGemId, isUnlocked)
  end
end

function CrownAccessoriesPage:RefreshGemCategory(categoryName)
  local categoryData = self.codexCategories and self.codexCategories[categoryName]
  if not categoryData or not categoryData.listCtrl then
    return
  end
  local gemList = self:GetGemListByCategory(categoryName)
  categoryData.listCtrl:ResetDatas(gemList)
  if self.selectedGemId then
    self:UpdateCodexSelection(self.selectedGemId)
  end
  if categoryData.grid then
    categoryData.grid:Reposition()
  end
end

function CrownAccessoriesPage:GetGemListByCategory(categoryName)
  local gemList = {}
  local unlockedGems = {}
  if SnowCrownProxy.Instance then
    unlockedGems = SnowCrownProxy.Instance:GetUnlockedGemIds()
  end
  local myClass = MyselfProxy.Instance:GetMyProfession() or 0
  local IsProfessionGem = function(config)
    return config.ClassID and #config.ClassID > 0
  end
  if categoryName == "ProfessionGem" then
    for id, config in pairs(Table_SnowStone or {}) do
      if IsProfessionGem(config) then
        local isUnlocked = unlockedGems[id] == true
        local level = 0
        local advlv = 0
        if isUnlocked and SnowCrownProxy.Instance then
          level = SnowCrownProxy.Instance:GetGemLevel(id)
          advlv = SnowCrownProxy.Instance:GetGemAdvanceLevel(id)
        end
        local isRecommend = 0 < TableUtility.ArrayFindIndex(config.ClassID, myClass)
        table.insert(gemList, {
          id = id,
          isUnlocked = isUnlocked,
          isSelected = self.selectedGemId == id,
          level = level,
          advlv = advlv,
          isRecommend = isRecommend
        })
      end
    end
  elseif categoryName == "NormalGem" then
    for id, config in pairs(Table_SnowStone or {}) do
      if not IsProfessionGem(config) then
        local isUnlocked = unlockedGems[id] == true
        local level = 0
        local advlv = 0
        if isUnlocked and SnowCrownProxy.Instance then
          level = SnowCrownProxy.Instance:GetGemLevel(id)
          advlv = SnowCrownProxy.Instance:GetGemAdvanceLevel(id)
        end
        table.insert(gemList, {
          id = id,
          isUnlocked = isUnlocked,
          isSelected = self.selectedGemId == id,
          level = level,
          advlv = advlv,
          isRecommend = false
        })
      end
    end
  end
  table.sort(gemList, function(a, b)
    if a.isRecommend ~= b.isRecommend then
      return a.isRecommend == true
    end
    if a.isUnlocked ~= b.isUnlocked then
      return a.isUnlocked
    end
    return a.id < b.id
  end)
  return gemList
end

function CrownAccessoriesPage:GetDefaultCodexGemId()
  local professionGems = self:GetGemListByCategory("ProfessionGem")
  if professionGems and 0 < #professionGems then
    return professionGems[1].id
  end
  local normalGems = self:GetGemListByCategory("NormalGem")
  if normalGems and 0 < #normalGems then
    return normalGems[1].id
  end
end

function CrownAccessoriesPage:ClearCodexSelection()
  self.selectedGemId = nil
  self:SelectDefaultGem()
end

function CrownAccessoriesPage:SelectDefaultGem()
  local firstGemId = self:GetDefaultCodexGemId()
  if firstGemId then
    local isUnlocked = false
    if SnowCrownProxy.Instance then
      isUnlocked = SnowCrownProxy.Instance:IsGemUnlocked(firstGemId)
    end
    self:UpdateCodexSelection(firstGemId)
    self:ShowCodexGemDetail(firstGemId, isUnlocked)
  end
end

local COLLECTION_CELL_WIDTH = 634
local COLLECTION_VIEW_WIDTH = 1070

function CrownAccessoriesPage:InitCollectionPage()
  local collectionPage = self.innerPageMap.CollectionPage
  if not collectionPage then
    return
  end
  local scrollView = self:FindComponent("Scroll View", UIScrollView, collectionPage)
  local setGrid = self:FindComponent("SetGrid", UIGrid, collectionPage)
  if setGrid then
    self.collectionListCtrl = UIGridListCtrl.new(setGrid, SnowGemSetCell, "SnowGemSetCell")
    self.collectionGrid = setGrid
  end
  self.showAttrBtn = self:FindGO("ShowAttrBtn", collectionPage)
  if self.showAttrBtn then
    self:AddClickEvent(self.showAttrBtn, function()
      self:OnShowAttrBtnClick()
    end)
  end
  self.collectionScrollView = scrollView
  self.collectionCurrentIndex = 1
  self.collectionTotalCount = 0
  self.collectLeftBtn = self:FindGO("LeftBtn", collectionPage)
  self.collectRightBtn = self:FindGO("RightBtn", collectionPage)
  if self.collectLeftBtn then
    self.collectLeftBtnSprite = self.collectLeftBtn:GetComponent(UISprite)
  end
  if self.collectRightBtn then
    self.collectRightBtnSprite = self.collectRightBtn:GetComponent(UISprite)
  end
  self:AddClickEvent(self.collectLeftBtn, function()
    self:OnCollectLeftBtnClick()
  end)
  self:AddClickEvent(self.collectRightBtn, function()
    self:OnCollectRightBtnClick()
  end)
end

function CrownAccessoriesPage:RefreshCollectionPage()
  if not self.collectionListCtrl then
    return
  end
  local groupDataList = self:GetAllGroupData()
  self.collectionListCtrl:ResetDatas(groupDataList)
  self.collectionTotalCount = #groupDataList
  self.collectionCurrentIndex = 1
  if self.collectionScrollView then
    self.collectionScrollView:ResetPosition()
    TimeTickManager.Me():CreateOnceDelayTick(50, function()
      self:ScrollToCollectionCell(self.collectionCurrentIndex, true)
    end, self)
  end
  self:UpdateCollectionArrowState()
end

function CrownAccessoriesPage:OnCollectLeftBtnClick()
  if self.collectionCurrentIndex <= 1 then
    return
  end
  self.collectionCurrentIndex = self.collectionCurrentIndex - 1
  self:ScrollToCollectionCell(self.collectionCurrentIndex, false)
  self:UpdateCollectionArrowState()
end

function CrownAccessoriesPage:OnCollectRightBtnClick()
  if self.collectionCurrentIndex >= self.collectionTotalCount then
    return
  end
  self.collectionCurrentIndex = self.collectionCurrentIndex + 1
  self:ScrollToCollectionCell(self.collectionCurrentIndex, false)
  self:UpdateCollectionArrowState()
end

function CrownAccessoriesPage:ScrollToCollectionCell(cellIndex, instant)
  if not self.collectionScrollView or not self.collectionListCtrl then
    return
  end
  if cellIndex < 1 or cellIndex > self.collectionTotalCount then
    return
  end
  local cells = self.collectionListCtrl:GetCells()
  if not cells or not cells[cellIndex] then
    return
  end
  local targetCell = cells[cellIndex]
  if not targetCell or not targetCell.gameObject then
    return
  end
  local cellLocalX = targetCell.gameObject.transform.localPosition.x
  local targetOffsetX = self:CalculateCollectionCellOffset(cellIndex, cellLocalX)
  local panel = self.collectionScrollView.panel
  if not panel then
    return
  end
  local currentY = panel.transform.localPosition.y
  local currentZ = panel.transform.localPosition.z
  local currentClipY = panel.clipOffset.y
  local targetPos = LuaVector3.New(-targetOffsetX, currentY, currentZ)
  if instant then
    panel.transform.localPosition = targetPos
    panel.clipOffset = LuaVector2.New(targetOffsetX, currentClipY)
  else
    SpringPanel.Begin(self.collectionScrollView.gameObject, targetPos, 8)
  end
end

function CrownAccessoriesPage:CalculateCollectionCellOffset(cellIndex, cellLocalX)
  local margin = (COLLECTION_VIEW_WIDTH - COLLECTION_CELL_WIDTH) / 2
  if cellIndex == 1 then
    return cellLocalX + margin
  elseif cellIndex == self.collectionTotalCount then
    return cellLocalX - margin
  else
    return cellLocalX
  end
end

function CrownAccessoriesPage:UpdateCollectionArrowState()
  local isFirst = self.collectionCurrentIndex <= 1
  local isLast = self.collectionCurrentIndex >= self.collectionTotalCount
  if self.collectLeftBtnSprite then
    if isFirst then
      self.collectLeftBtnSprite.color = UnityEngine.Color(0.5, 0.5, 0.5, 1)
    else
      self.collectLeftBtnSprite.color = UnityEngine.Color(1, 1, 1, 1)
    end
  end
  if self.collectRightBtnSprite then
    if isLast then
      self.collectRightBtnSprite.color = UnityEngine.Color(0.5, 0.5, 0.5, 1)
    else
      self.collectRightBtnSprite.color = UnityEngine.Color(1, 1, 1, 1)
    end
  end
end

function CrownAccessoriesPage:GetAllGroupData()
  local groupDataList = {}
  if not Table_SnowStoneAttr then
    return groupDataList
  end
  local sortedIds = {}
  for id, _ in pairs(Table_SnowStoneAttr) do
    table.insert(sortedIds, id)
  end
  table.sort(sortedIds)
  for _, id in ipairs(sortedIds) do
    local attrConfig = Table_SnowStoneAttr[id]
    local stoneIDGroup = attrConfig.StoneIDGroup
    if stoneIDGroup and #stoneIDGroup ~= 0 then
      local validGemIds = {}
      for _, gemId in ipairs(stoneIDGroup) do
        if Table_SnowStone and Table_SnowStone[gemId] then
          table.insert(validGemIds, gemId)
        end
      end
      if #validGemIds ~= 0 then
        local groupData = {
          groupId = id,
          groupName = attrConfig.Name or string.format("组合%d", id),
          gemIds = validGemIds
        }
        table.insert(groupDataList, groupData)
      end
    end
  end
  return groupDataList
end

function CrownAccessoriesPage:OnShowAttrBtnClick()
  local attrList = self:GetFormattedUnlockedAttrList()
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.SnowCrownCollectAttrPopup,
    viewdata = {attrList = attrList}
  })
end

function CrownAccessoriesPage:GetAllUnlockedAttrs()
  local totalAttrs = {}
  if not self.collectionListCtrl then
    return totalAttrs
  end
  local unlockedGems = {}
  if SnowCrownProxy.Instance then
    unlockedGems = SnowCrownProxy.Instance:GetUnlockedGemIds()
  end
  local groupDataList = self:GetAllGroupData()
  for _, groupData in ipairs(groupDataList) do
    local groupId = groupData.groupId
    local groupConfig = Table_SnowStoneAttr and Table_SnowStoneAttr[groupId]
    if groupConfig then
      local minLevel, totalAdvLevel = self:GetGroupMinLevelAndTotalAdvLevel(groupData.gemIds)
      if groupConfig.GroupAttr then
        for requiredLevel, attrData in pairs(groupConfig.GroupAttr) do
          if requiredLevel <= minLevel then
            for attrName, attrValue in pairs(attrData) do
              totalAttrs[attrName] = (totalAttrs[attrName] or 0) + attrValue
            end
          end
        end
      end
      if groupConfig.ActiveAttr then
        local isAllUnlocked = true
        for _, gemId in ipairs(groupData.gemIds or EmptyTable) do
          if unlockedGems[gemId] ~= true then
            isAllUnlocked = false
            break
          end
        end
        if isAllUnlocked then
          for attrName, attrValue in pairs(groupConfig.ActiveAttr) do
            totalAttrs[attrName] = (totalAttrs[attrName] or 0) + attrValue
          end
        end
      end
      if groupConfig.AdvanceLevelAttr then
        for requiredAdvLevel, attrData in pairs(groupConfig.AdvanceLevelAttr) do
          if totalAdvLevel >= requiredAdvLevel then
            for attrName, attrValue in pairs(attrData) do
              totalAttrs[attrName] = (totalAttrs[attrName] or 0) + attrValue
            end
          end
        end
      end
    end
  end
  return totalAttrs
end

function CrownAccessoriesPage:GetGroupMinLevelAndTotalAdvLevel(gemIds)
  local minLevel = 999
  local totalAdvLevel = 0
  if not gemIds or not SnowCrownProxy.Instance then
    return 0, 0
  end
  for _, gemId in ipairs(gemIds) do
    local level = SnowCrownProxy.Instance:GetGemLevel(gemId) or 0
    local advLevel = SnowCrownProxy.Instance:GetGemAdvanceLevel(gemId) or 0
    if minLevel > level then
      minLevel = level
    end
    totalAdvLevel = totalAdvLevel + advLevel
  end
  if minLevel == 999 then
    minLevel = 0
  end
  return minLevel, totalAdvLevel
end

function CrownAccessoriesPage:GetFormattedUnlockedAttrList()
  local totalAttrs = self:GetAllUnlockedAttrs()
  local attrList = {}
  for attrName, attrValue in pairs(totalAttrs) do
    local propConfig = Game.Config_PropName and Game.Config_PropName[attrName]
    local displayName = propConfig and propConfig.PropName or attrName
    table.insert(attrList, {
      name = attrName,
      displayName = displayName,
      value = attrValue
    })
  end
  table.sort(attrList, function(a, b)
    local configA = Game.Config_PropName and Game.Config_PropName[a.name]
    local configB = Game.Config_PropName and Game.Config_PropName[b.name]
    local idA = configA and configA.id or 9999
    local idB = configB and configB.id or 9999
    return idA < idB
  end)
  return attrList
end

function CrownAccessoriesPage:GetDefaultInnerPageName()
  return self.InnerTogglePageMap.EmbedTab
end

function CrownAccessoriesPage:AddEvents()
  self:AddListenEvt(ServiceEvent.SnowCmdSnowHeadQuerySnowCmd, self.HandleSnowDataUpdate)
  self:AddListenEvt(ServiceEvent.SnowCmdQuerySnowManualSnowCmd, self.HandleSnowManualQuery)
  self:AddListenEvt(ServiceEvent.SnowCmdSnowManualUpdateSnowCmd, self.HandleStoneBookUpdate)
  self:AddListenEvt(ServiceEvent.SnowCmdSnowManualEquipUpdateSnowCmd, self.HandleEquipUpdate)
  self:AddListenEvt(ServiceEvent.SnowCmdSnowManualStoneUpdateSnowCmd, self.HandleStoneUpdate)
end

function CrownAccessoriesPage:HandleSnowDataUpdate(note)
  if self.activeInnerPageName then
    self:OnInnerPageActivate(self.activeInnerPageName)
  end
end

function CrownAccessoriesPage:HandleSnowManualQuery(note)
  if self.activeInnerPageName then
    self:OnInnerPageActivate(self.activeInnerPageName)
  end
end

function CrownAccessoriesPage:HandleStoneBookUpdate(note)
  if self.activeInnerPageName == "CodexPage" then
    self:RefreshCodexPage()
  end
end

function CrownAccessoriesPage:HandleEquipUpdate(note)
  if self.activeInnerPageName == "EmbedPage" then
    self:RefreshEmbedPage()
  end
end

function CrownAccessoriesPage:HandleStoneUpdate(note)
  xdlog("HandleStoneUpdtae")
  if self.activeInnerPageName == "EmbedPage" then
    self:RefreshEmbedPage()
  end
end

function CrownAccessoriesPage:OnActivate()
  self:ReRegisterContainerMediator()
  if SnowCrownProxy.Instance then
    SnowCrownProxy.Instance:RequestQuerySnowManual()
  end
  local defaultPage = self:GetDefaultInnerPageName()
  self:SwitchToInnerPage(defaultPage)
end

function CrownAccessoriesPage:ReRegisterContainerMediator()
  if not self.container then
    return
  end
  local uiMediator = self.container.uiMediator
  if uiMediator then
    local mediatorName = uiMediator.mediatorName or self.container.__cname
    GameFacade.Instance:removeMediator(mediatorName)
    uiMediator:SetView(self.container)
    GameFacade.Instance:registerMediator(uiMediator)
  end
end

function CrownAccessoriesPage:OnProfitBtnClick()
  local attrList = self:GetAllSlotActivatedAttrList()
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.SnowCrownCollectAttrPopup,
    viewdata = {
      attrList = attrList,
      title = ZhString.CrownAccessoriesPage_ProfitTitle
    }
  })
end

function CrownAccessoriesPage:CalcSnowStoreBuffAttrValue(attrEffect)
  if not attrEffect or not attrEffect.type then
    return 0
  end
  local buffType = attrEffect.type
  local a = attrEffect.a or 0
  local b = attrEffect.b or 0
  local c = attrEffect.c or 0
  local d = attrEffect.d or 0
  local funcName = "calcBuff_" .. buffType
  local calcFunc = CommonFun[funcName]
  if calcFunc then
    local myselfData = Game.Myself and Game.Myself.data
    if myselfData then
      return calcFunc(myselfData, myselfData, a, b, c, d, 0) or 0
    end
  end
  return 0
end

function CrownAccessoriesPage:AddAttrChangeBuffToAttrSum(buffId, attrSum)
  if not (buffId and attrSum and Table_Buffer) or not Table_Buffer[buffId] then
    return false
  end
  local buffData = Table_Buffer[buffId]
  local buffEffect = buffData.BuffEffect
  if not buffEffect or buffEffect.type ~= "AttrChange" then
    return false
  end
  local propMap = Game.Config_PropName or {}
  local handled = false
  for attrName, attrEffect in pairs(buffEffect) do
    if attrName ~= "type" and propMap[attrName] then
      local attrValue
      if type(attrEffect) == "number" then
        attrValue = attrEffect
      elseif type(attrEffect) == "table" and attrEffect.type then
        attrValue = self:CalcSnowStoreBuffAttrValue(attrEffect)
      end
      if attrValue and attrValue ~= 0 then
        attrSum[attrName] = (attrSum[attrName] or 0) + attrValue
        handled = true
      end
    end
  end
  return handled
end

local CalcSnowShadowBuffRate = function(refineLv)
  local rate = refineLv * 0.5
  if 15 <= refineLv then
    rate = rate + 2.5
  end
  return rate
end

function CrownAccessoriesPage:GetAllSlotActivatedAttrList()
  local attrList = {}
  if not SnowCrownProxy.Instance then
    return attrList
  end
  local storeAttrSum = {}
  local advanceAttrList = {}
  local snowStoreBuffAttrSum = {}
  local specialBuffList = {}
  local hasDoubleShadow = false
  local hasShadowGuard = false
  for slotIndex = 1, 3 do
    local equipRefineLv = 0
    local equipData = SnowCrownProxy.Instance:GetSlotEquipData(slotIndex)
    local equipId
    if equipData then
      if equipData.equipInfo then
        equipRefineLv = equipData.equipInfo.refinelv or 0
      end
      if equipData.staticData then
        equipId = equipData.staticData.id
      end
    end
    if equipId and Table_Equip and Table_Equip[equipId] then
      local equipConfig = Table_Equip[equipId]
      local snowStoreBuffs = equipConfig.SnowStoreBuff
      if snowStoreBuffs and 0 < #snowStoreBuffs then
        for _, buffId in ipairs(snowStoreBuffs) do
          if buffId == 800250 and not hasDoubleShadow then
            local rate = CalcSnowShadowBuffRate(equipRefineLv)
            if 0 < rate then
              table.insert(specialBuffList, {
                name = string.format(ZhString.CrownAccessoriesPage_DoubleShadow, rate)
              })
              hasDoubleShadow = true
            end
          elseif buffId == 800260 and not hasShadowGuard then
            local rate = CalcSnowShadowBuffRate(equipRefineLv)
            if 0 < rate then
              table.insert(specialBuffList, {
                name = string.format(ZhString.CrownAccessoriesPage_ShadowGuard, rate)
              })
              hasShadowGuard = true
            end
          elseif Table_Buffer and Table_Buffer[buffId] then
            local buffData = Table_Buffer[buffId]
            local buffEffect = buffData.BuffEffect
            if buffEffect and buffEffect.type == "AttrChange" then
              for attrName, attrEffect in pairs(buffEffect) do
                if attrName ~= "type" and type(attrEffect) == "table" then
                  local attrValue = self:CalcSnowStoreBuffAttrValue(attrEffect)
                  if 0 < attrValue then
                    snowStoreBuffAttrSum[attrName] = (snowStoreBuffAttrSum[attrName] or 0) + attrValue
                  end
                end
              end
            end
          end
        end
      end
    end
    if equipData then
      for gemIndex = 1, 2 do
        local gemData = SnowCrownProxy.Instance:GetSlotGemData(slotIndex, gemIndex)
        if gemData and gemData.id then
          local stoneConfig = Table_SnowStone and Table_SnowStone[gemData.id]
          if stoneConfig then
            local gemLevel = gemData.level or 0
            local advLevel = gemData.starLevel or 0
            local levelConfig = Table_SnowStoneLevel and Table_SnowStoneLevel[gemLevel]
            if levelConfig and levelConfig.Attr then
              for attrName, attrValue in pairs(levelConfig.Attr) do
                storeAttrSum[attrName] = (storeAttrSum[attrName] or 0) + attrValue
              end
            end
            if 0 < advLevel then
              local effectConfig
              if Table_SnowStoneEffect then
                for _, config in pairs(Table_SnowStoneEffect) do
                  if config.StoneID == gemData.id and config.Level == advLevel then
                    effectConfig = config
                    break
                  end
                end
              end
              local SafeFormatDesc = function(desc, values)
                if not desc then
                  return ""
                end
                desc = OverSea.LangManager.Instance():GetLangByKey(desc) or desc
                if not values or #values == 0 then
                  return string.gsub(desc, "%%s", "-")
                end
                local _, count = string.gsub(desc, "%%s", "")
                local safeValues = {}
                for i = 1, count do
                  safeValues[i] = values[i] or "-"
                end
                if 0 < #safeValues then
                  return string.format(desc, unpack(safeValues))
                end
                return desc
              end
              local effectBuffHandled = false
              if effectConfig and effectConfig.Buff then
                for _, buffId in ipairs(effectConfig.Buff) do
                  if self:AddAttrChangeBuffToAttrSum(buffId, storeAttrSum) then
                    effectBuffHandled = true
                  end
                end
              end
              local descText
              if effectConfig and effectConfig.Value then
                descText = SafeFormatDesc(stoneConfig.Desc, effectConfig.Value)
              else
                descText = SafeFormatDesc(stoneConfig.Desc, nil)
              end
              if effectBuffHandled then
                descText = nil
              end
              if descText and descText ~= "" then
                table.insert(advanceAttrList, {name = descText})
              end
            end
          end
        end
      end
    end
  end
  for attrName, attrValue in pairs(storeAttrSum) do
    table.insert(attrList, {name = attrName, value = attrValue})
  end
  for attrName, attrValue in pairs(snowStoreBuffAttrSum) do
    table.insert(attrList, {name = attrName, value = attrValue})
  end
  for _, specialBuff in ipairs(specialBuffList) do
    table.insert(attrList, specialBuff)
  end
  for _, advAttr in ipairs(advanceAttrList) do
    table.insert(attrList, advAttr)
  end
  return attrList
end

function CrownAccessoriesPage:OnDeactivate()
  self:HideChoosePanel()
end

function CrownAccessoriesPage:OnExit()
  CrownAccessoriesPage.super.OnExit(self)
end

function CrownAccessoriesPage:GetCodexLevelUpCostData(level)
  local nextLevel = (level or 0) + 1
  local levelConfig = Table_SnowStoneLevel and Table_SnowStoneLevel[nextLevel]
  if not (levelConfig and levelConfig.Material) or not levelConfig.Material[1] then
    return
  end
  local costData = levelConfig.Material[1]
  local itemId = costData[1]
  local itemCount = costData[2] or 0
  local ownCount = 0
  local bagTypes = GameConfig.PackageMaterialCheck and GameConfig.PackageMaterialCheck.default
  if BagProxy.Instance and itemId then
    ownCount = BagProxy.Instance:GetItemNumByStaticID(itemId, bagTypes) or 0
  end
  return itemId, itemCount, ownCount
end

function CrownAccessoriesPage:RefreshCodexLevelUpCost(level)
  if not self.codexCostIcon or not self.codexCostCount then
    return
  end
  local itemId, itemCount, ownCount = self:GetCodexLevelUpCostData(level)
  if not itemId then
    self.codexCostCount.text = ""
    ColorUtil.WhiteUIWidget(self.codexCostCount)
    return
  end
  local itemConfig = Table_Item and Table_Item[itemId]
  if itemConfig and itemConfig.Icon then
    IconManager:SetItemIcon(itemConfig.Icon, self.codexCostIcon)
    self.codexCostIcon:MakePixelPerfect()
    self.codexCostIcon.transform.localScale = LuaVector3.New(0.5, 0.5, 0.5)
  end
  local ownColor = ownCount < itemCount and "FF3B0D" or "FFFFFF"
  self.codexCostCount.text = string.format("[c][%s]%s[-][/c]/%s", ownColor, tostring(ownCount), tostring(itemCount))
  ColorUtil.WhiteUIWidget(self.codexCostCount)
end

function CrownAccessoriesPage:OnCodexLevelUpClick()
  if not self.selectedGemId then
    return
  end
  if self.isCodexMaxPreview then
    if self.codexStatusLabel and self.codexStatusLabel.gameObject then
      self.codexStatusLabel.gameObject:SetActive(true)
      self.codexStatusLabel.text = ZhString.CrownAccessoriesPage_PreviewCantLevelUp or "预览状态无法升级"
    end
    return
  end
  local gemLevel = SnowCrownProxy.Instance and SnowCrownProxy.Instance:GetGemLevel(self.selectedGemId) or 0
  local itemId, itemCount, ownCount = self:GetCodexLevelUpCostData(gemLevel)
  if itemId and ownCount < itemCount then
    MsgManager.ShowMsgByID(8)
    return
  end
  if SnowCrownProxy.Instance then
    SnowCrownProxy.Instance:RequestOperSnowStone(SnowCrownProxy.StoneOperEnum.LEVELUP, 0, 0, self.selectedGemId)
  end
  xdlog("OnCodexLevelUpClick", "gemId:", self.selectedGemId)
end
