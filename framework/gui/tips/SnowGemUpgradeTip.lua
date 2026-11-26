autoImport("BaseTip")
autoImport("SnowCrownCostItemCell")
autoImport("TipLabelCell")
autoImport("ItemTipBaseCell")
SnowGemUpgradeTip = class("SnowGemUpgradeTip", BaseTip)
local TextFormatNormal = "%s/%s"
local TextFormatRed = "[c][FF3B35]%s[-][/c]/%s"
local AttrIconPrefix = "{uiicon=new-com_icon_tips}"
local DefaultDescScrollCenterY, DefaultDescScrollHeight = 18, 208
local LongDescScrollCenterY, LongDescScrollHeight = -70, 384
local DefaultBottomBgY, LongBottomBgY = -75.4, -255

local function RemoveSnowGemParts(trans)
  if not trans then
    return
  end
  for i = trans.childCount - 1, 0, -1 do
    local childTrans = trans:GetChild(i)
    local childGO = childTrans.gameObject
    if childGO.name == "SnowGem" then
      GameObject.DestroyImmediate(childGO)
    else
      RemoveSnowGemParts(childTrans)
    end
  end
end

local FormatCostNum = function(num, needNum, isLack)
  return string.format(isLack and TextFormatRed or TextFormatNormal, num, needNum)
end
local GetGemName = function(gemId)
  local stoneConfig = Table_SnowStone and Table_SnowStone[gemId]
  if stoneConfig then
    return stoneConfig.NameZh or stoneConfig.Name or ""
  end
  local itemConfig = Table_Item and Table_Item[gemId]
  return itemConfig and itemConfig.NameZh or ""
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
  return 0 < count and string.format(desc, unpack(safeValues)) or desc
end
local BuildLevelAttrLabels = function(level)
  local labels = {}
  local levelConfig = Table_SnowStoneLevel and Table_SnowStoneLevel[level]
  local attrs = levelConfig and levelConfig.Attr
  if not attrs then
    return labels, false
  end
  for _, group in ipairs(ItemTipBaseCell.MergeAttrsByValue(attrs)) do
    local attrText = ItemTipBaseCell.FormatMergedAttrText(group)
    if attrText and attrText ~= "" then
      labels[#labels + 1] = AttrIconPrefix .. attrText
    end
  end
  return labels, true
end
local BuildAdvanceAttrInfo = function(gemId, advLevel, advExp)
  local stoneConfig = Table_SnowStone and Table_SnowStone[gemId]
  if not stoneConfig or not stoneConfig.Desc then
    return nil
  end
  local effectLevel = math.max(advLevel or 0, 1)
  local effectConfig
  for _, config in pairs(Table_SnowStoneEffect or {}) do
    if config.StoneID == gemId and config.Level == effectLevel then
      effectConfig = config
      break
    end
  end
  local descText = SafeFormatDesc(stoneConfig.Desc, effectConfig and effectConfig.Value)
  if descText == "" then
    return nil
  end
  local displayAdvLevel = effectLevel
  local romanNumerals = {
    [1] = "I",
    [2] = "II",
    [3] = "III",
    [4] = "IV",
    [5] = "V"
  }
  local maxAdvLevel = 5
  local advanceCount = GameConfig.Snow and GameConfig.Snow.StoneAdvanceCount or {}
  local nextAdvanceCount = advanceCount[(advLevel or 0) + 1]
  local progressText = ""
  if nextAdvanceCount then
    local progress = math.min((advExp or 0) / nextAdvanceCount, 1)
    progressText = string.format(ZhString.ItemTip_SnowGemAdvProgress, math.floor(progress * 100 + 0.5))
  end
  return {
    tiplabel = string.format(ZhString.ItemTip_SnowGemAdvAttr, romanNumerals[displayAdvLevel] or "I", romanNumerals[maxAdvLevel], progressText),
    label = {descText},
    hideline = true
  }
end

function SnowGemUpgradeTip:Init()
  self:FindObjs()
  self:AddEvents()
end

function SnowGemUpgradeTip:FindObjs()
  self.closeWhenClickOtherPlace = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  self.iconBg = self:FindGO("IconBg")
  local legacyIcon = self:FindComponent("Icon", UISprite)
  if legacyIcon then
    legacyIcon.gameObject:SetActive(false)
  end
  self:CreateIconItemCell()
  self.nameLabel = self:FindComponent("Name", UILabel)
  self.levelLabel = self:FindComponent("Level", UILabel)
  self.descScrollView = self:FindComponent("DescScrollView", UIScrollView)
  local attriTable = self:FindComponent("AttriTable", UITable)
  if attriTable then
    self.attriCtrl = UIGridListCtrl.new(attriTable, TipLabelCell, "TipLabelCell")
  end
  local grid = self:FindComponent("Grid", UIGrid)
  if grid then
    self.costListCtrl = UIGridListCtrl.new(grid, SnowCrownCostItemCell, "ItemCell")
  end
  self.upgradeBtn = self:FindGO("UpgradeBtn")
  if self.upgradeBtn then
    self:AddClickEvent(self.upgradeBtn, function()
      self:OnUpgradeBtnClick()
    end)
  end
  self.upgradeLabel = self:FindComponent("UpgradeLabel", UILabel)
  self.maxLv = self:FindGO("MaxLv")
  self.costPart = self:FindGO("CostPart")
  self.bottomBg = self:FindGO("BottomBg")
  self.checkBtn = self:FindGO("CheckBtn")
  if self.checkBtn then
    self.checkBtn:SetActive(false)
  end
end

function SnowGemUpgradeTip:CreateIconItemCell()
  if not self.iconBg then
    return
  end
  local itemCellGO
  local iconBgTrans = self.iconBg.transform
  for i = iconBgTrans.childCount - 1, 0, -1 do
    local childGO = iconBgTrans:GetChild(i).gameObject
    if childGO.name == "SnowGemUpgradeIconItemCell" or childGO.name == "ItemCell" then
      if not itemCellGO then
        itemCellGO = childGO
        itemCellGO.name = "SnowGemUpgradeIconItemCell"
      else
        GameObject.DestroyImmediate(childGO)
      end
    end
  end
  if not itemCellGO then
    itemCellGO = self:LoadPreferb("cell/ItemCell", self.iconBg)
    if itemCellGO then
      itemCellGO.name = "SnowGemUpgradeIconItemCell"
    end
  end
  if itemCellGO then
    RemoveSnowGemParts(itemCellGO.transform)
    self.iconItemCell = ItemCell.new(itemCellGO)
  end
end

function SnowGemUpgradeTip:AddEvents()
  EventManager.Me():AddEventListener(ServiceEvent.SnowCmdSnowManualUpdateSnowCmd, self.HandleStoneBookUpdate, self)
end

function SnowGemUpgradeTip:SetData(data)
  self.gemId = data and data.gemId
end

function SnowGemUpgradeTip:OnEnter()
  self.gameObject:SetActive(true)
  if self.closeWhenClickOtherPlace then
    self.closeWhenClickOtherPlace.excuteOnce = false
    
    function self.closeWhenClickOtherPlace.call()
      self:CloseTip()
    end
  end
  self:RefreshView()
end

function SnowGemUpgradeTip:HandleStoneBookUpdate()
  self:RefreshView()
end

function SnowGemUpgradeTip:RefreshView()
  local proxy = SnowCrownProxy.Instance
  if not (self.gemId and proxy and Table_SnowStone) or not Table_SnowStone[self.gemId] then
    self:CloseTip()
    return
  end
  self.isUnlocked = proxy:IsGemUnlocked(self.gemId)
  self.levelValue = proxy:GetGemLevel(self.gemId) or 0
  self.advLevel = proxy:GetGemAdvanceLevel(self.gemId) or 0
  local stoneBookData = proxy:GetStoneBookData(self.gemId)
  self.advExp = stoneBookData and stoneBookData.advexp or 0
  self.nextLevelStatic = Table_SnowStoneLevel and Table_SnowStoneLevel[self.levelValue + 1]
  self.isMax = self.isUnlocked and self.nextLevelStatic == nil
  if self.iconItemCell then
    local itemData = ItemData.new(self.gemId, self.gemId)
    itemData:SetSnowGemData({
      id = self.gemId,
      level = self.levelValue,
      advlv = self.advLevel,
      advexp = self.advExp
    })
    self.iconItemCell:SetData(itemData)
  end
  if self.nameLabel then
    self.nameLabel.text = GetGemName(self.gemId)
  end
  if self.levelLabel then
    self.levelLabel.text = self.isMax and ZhString.SnowCrown_MaxLevel or "Lv." .. self.levelValue
  end
  self:RefreshAttrList()
  local canUpgrade = self.isUnlocked and not self.isMax and self.nextLevelStatic ~= nil
  if self.maxLv then
    self.maxLv:SetActive(self.isMax)
  end
  if self.costPart then
    self.costPart:SetActive(canUpgrade)
  end
  if self.upgradeBtn then
    self.upgradeBtn:SetActive(canUpgrade)
  end
  if self.upgradeLabel then
    self.upgradeLabel.text = ZhString.EquipUpgradePopUp_Upgrade
  end
  self:RefreshDescScrollViewLayout(canUpgrade)
  self:RefreshCost()
end

function SnowGemUpgradeTip:RefreshDescScrollViewLayout(showCostPart)
  local panel = self.descScrollView and self.descScrollView.panel
  if panel then
    local clip = panel.baseClipRegion
    local centerY = showCostPart and DefaultDescScrollCenterY or LongDescScrollCenterY
    local height = showCostPart and DefaultDescScrollHeight or LongDescScrollHeight
    panel:SetRect(clip.x, centerY, clip.z, height)
  end
  if self.bottomBg then
    local x, _, z = LuaGameObject.GetLocalPositionGO(self.bottomBg)
    local y = showCostPart and DefaultBottomBgY or LongBottomBgY
    LuaGameObject.SetLocalPositionGO(self.bottomBg, x, y, z)
  end
  if self.descScrollView then
    self.descScrollView:ResetPosition()
  end
end

function SnowGemUpgradeTip:RefreshAttrList()
  if not self.attriCtrl then
    return
  end
  local attrInfos = {}
  local currentLabels = BuildLevelAttrLabels(self.levelValue)
  if 0 < #currentLabels then
    attrInfos[#attrInfos + 1] = {
      tiplabel = string.format(ZhString.ItemTip_SnowGemBasicAttr, self.levelValue),
      label = currentLabels
    }
  end
  if self.isUnlocked and not self.isMax then
    local nextLabels = BuildLevelAttrLabels(self.levelValue + 1)
    if 0 < #nextLabels then
      attrInfos[#attrInfos + 1] = {
        tiplabel = ZhString.SnowGemUpgradeTip_NextLevelEffect,
        label = nextLabels
      }
    end
  end
  local advanceInfo = BuildAdvanceAttrInfo(self.gemId, self.advLevel, self.advExp)
  if advanceInfo then
    attrInfos[#attrInfos + 1] = advanceInfo
  end
  self.attriCtrl:ResetDatas(attrInfos)
end

function SnowGemUpgradeTip:RefreshCost()
  if not self.costListCtrl then
    return
  end
  local datas = {}
  self.lack = false
  if self.isUnlocked and not self.isMax and self.nextLevelStatic and self.nextLevelStatic.Material then
    local bagTypes = GameConfig.PackageMaterialCheck and GameConfig.PackageMaterialCheck.default
    for _, cost in ipairs(self.nextLevelStatic.Material) do
      local itemId = cost[1]
      local needNum = cost[2] or 0
      local ownNum = BagProxy.Instance and BagProxy.Instance:GetItemNumByStaticID(itemId, bagTypes) or 0
      local isLack = needNum > ownNum
      local itemData = ItemData.new(itemId, itemId)
      itemData.num = FormatCostNum(ownNum, needNum, isLack)
      datas[#datas + 1] = itemData
      self.lack = self.lack or isLack
    end
  end
  self.costListCtrl:ResetDatas(datas)
end

function SnowGemUpgradeTip:OnUpgradeBtnClick()
  if not self.isUnlocked or self.isMax or not self.nextLevelStatic then
    return
  end
  if self.lack then
    MsgManager.ShowMsgByID(8)
    return
  end
  if SnowCrownProxy.Instance then
    SnowCrownProxy.Instance:RequestOperSnowStone(SnowCrownProxy.StoneOperEnum.LEVELUP, 0, 0, self.gemId)
  end
end

function SnowGemUpgradeTip:CloseTip()
  TipsView.Me():HideTip(SnowGemUpgradeTip)
end

function SnowGemUpgradeTip:OnExit()
  EventManager.Me():RemoveEventListener(ServiceEvent.SnowCmdSnowManualUpdateSnowCmd, self.HandleStoneBookUpdate, self)
  if self.closeWhenClickOtherPlace then
    self.closeWhenClickOtherPlace.call = nil
    self.closeWhenClickOtherPlace.callBack = nil
    self.closeWhenClickOtherPlace = nil
  end
  if self.attriCtrl then
    self.attriCtrl:RemoveAll()
    self.attriCtrl = nil
  end
  if self.costListCtrl then
    self.costListCtrl:RemoveAll()
    self.costListCtrl = nil
  end
  return SnowGemUpgradeTip.super.OnExit(self)
end
