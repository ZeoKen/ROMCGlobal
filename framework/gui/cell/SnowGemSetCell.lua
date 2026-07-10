SnowGemSetCell = class("SnowGemSetCell", BaseCell)
local MAX_SET_COUNT = 3
local _, LABEL_COLOR_LOCKED = ColorUtil.TryParseHexString("94AAC0")
local _, LABEL_COLOR_UNLOCKED = ColorUtil.TryParseHexString("D9F7FF")

function SnowGemSetCell:Init()
  SnowGemSetCell.super.Init(self)
  self:FindObjs()
end

function SnowGemSetCell:FindObjs()
  self.bg = self:FindGO("Bg")
  self.setNameLabel = self:FindComponent("SetName", UILabel)
  local scrollView = self:FindGO("Scroll View")
  if scrollView then
    self.gemScrollView = self:FindComponent("Scroll View", UIScrollView)
    local scrollViewPanel = scrollView:GetComponent(UIPanel)
    if scrollViewPanel then
      local parentPanel = UIUtil.GetComponentInParents(self.gameObject, UIPanel)
      if parentPanel then
        scrollViewPanel.depth = parentPanel.depth + 1
      end
    end
    local grid = self:FindComponent("Grid", UIGrid, scrollView)
    if grid then
      self.gemListCtrl = UIGridListCtrl.new(grid, SnowGemCell, "SnowGemCell")
    end
  end
  self.setBG = self:FindGO("SetBG")
  if self.setBG then
    self.allGetLabel = self:FindComponent("AllGetLabel", UILabel, self.setBG)
  end
  self.refineSet = self:FindGO("RefineSet")
  if self.refineSet then
    self.refineSetItems = {}
    local grid = self:FindGO("Grid", self.refineSet)
    if grid then
      for i = 1, MAX_SET_COUNT do
        local setGO = self:FindGO("Set" .. i, grid)
        if setGO then
          self.refineSetItems[i] = {
            gameObject = setGO,
            label = self:FindComponent("Label", UILabel, setGO),
            star = self:FindGO("Star", setGO),
            lock = self:FindGO("Lock", setGO)
          }
        end
      end
    end
  end
  self.upgradeSet = self:FindGO("UpgradeSet")
  if self.upgradeSet then
    self.upgradeSetItems = {}
    local grid = self:FindGO("Grid", self.upgradeSet)
    if grid then
      for i = 1, MAX_SET_COUNT do
        local setGO = self:FindGO("Set" .. i, grid)
        if setGO then
          self.upgradeSetItems[i] = {
            gameObject = setGO,
            label = self:FindComponent("Label", UILabel, setGO),
            star = self:FindComponent("Star", UISprite, setGO)
          }
        end
      end
    end
  end
end

function SnowGemSetCell:SetData(data)
  SnowGemSetCell.super.SetData(self, data)
  self.data = data
  if not data then
    return
  end
  local groupId = data.groupId
  self:RefreshGemList(data.gemIds)
  local groupConfig = Table_SnowStoneAttr and Table_SnowStoneAttr[groupId]
  if not groupConfig then
    return
  end
  if self.setNameLabel then
    self.setNameLabel.text = groupConfig.Name or ""
  end
  local gemLevels, gemAdvLevels, minLevel, totalAdvLevel = self:GetGroupGemData(data.gemIds)
  self:RefreshRefineSet(groupConfig.GroupAttr, minLevel)
  self:RefreshUpgradeSet(groupConfig.AdvanceLevelAttr, totalAdvLevel)
  if self.allGetLabel then
    local activeAttr = groupConfig.ActiveAttr
    if activeAttr then
      local attrText = self:FormatAttrText(activeAttr)
      self.allGetLabel.text = string.format(ZhString.CrownAccessoriesPage_GemActiveAttr, attrText)
      local isAllUnlocked = self:CheckAllGemsUnlocked(data.gemIds)
      self.allGetLabel.color = isAllUnlocked and LABEL_COLOR_UNLOCKED or LABEL_COLOR_LOCKED
    else
      self.allGetLabel.text = ""
    end
  end
end

function SnowGemSetCell:CheckAllGemsUnlocked(gemIds)
  if not gemIds or #gemIds == 0 then
    return false
  end
  local unlockedGems = {}
  if SnowCrownProxy.Instance then
    unlockedGems = SnowCrownProxy.Instance:GetUnlockedGemIds()
  end
  for _, gemId in ipairs(gemIds) do
    if unlockedGems[gemId] ~= true then
      return false
    end
  end
  return true
end

function SnowGemSetCell:RefreshGemList(gemIds)
  if not self.gemListCtrl then
    return
  end
  local gemDataList = {}
  local unlockedGems = {}
  if SnowCrownProxy.Instance then
    unlockedGems = SnowCrownProxy.Instance:GetUnlockedGemIds()
  end
  for _, gemId in ipairs(gemIds or {}) do
    local isUnlocked = unlockedGems[gemId] == true
    local level = 0
    local advlv = 0
    if isUnlocked and SnowCrownProxy.Instance then
      level = SnowCrownProxy.Instance:GetGemLevel(gemId)
      advlv = SnowCrownProxy.Instance:GetGemAdvanceLevel(gemId)
    end
    table.insert(gemDataList, {
      id = gemId,
      isUnlocked = isUnlocked,
      isSelected = false,
      level = level,
      advlv = advlv
    })
  end
  if self.gemScrollView then
    local count = gemIds and #gemIds or 0
    if 4 < count then
      self.gemScrollView.contentPivot = UIWidget.Pivot.TopLeft
    else
      self.gemScrollView.contentPivot = UIWidget.Pivot.Top
    end
    self.gemScrollView:ResetPosition()
  end
  table.sort(gemDataList, function(a, b)
    if a.isUnlocked ~= b.isUnlocked then
      return a.isUnlocked
    end
    return a.id < b.id
  end)
  self.gemListCtrl:ResetDatas(gemDataList)
end

function SnowGemSetCell:GetGroupGemData(gemIds)
  local gemLevels = {}
  local gemAdvLevels = {}
  local minLevel = 999
  local totalAdvLevel = 0
  if not gemIds or not SnowCrownProxy.Instance then
    return gemLevels, gemAdvLevels, 0, 0
  end
  for _, gemId in ipairs(gemIds) do
    local level = SnowCrownProxy.Instance:GetGemLevel(gemId) or 0
    local advLevel = SnowCrownProxy.Instance:GetGemAdvanceLevel(gemId) or 0
    gemLevels[gemId] = level
    gemAdvLevels[gemId] = advLevel
    if minLevel > level then
      minLevel = level
    end
    totalAdvLevel = totalAdvLevel + advLevel
  end
  return gemLevels, gemAdvLevels, minLevel, totalAdvLevel
end

function SnowGemSetCell:RefreshRefineSet(groupAttr, minLevel)
  if not self.refineSetItems or not groupAttr then
    return
  end
  local sortedKeys = {}
  for key, _ in pairs(groupAttr) do
    table.insert(sortedKeys, key)
  end
  table.sort(sortedKeys)
  for i = 1, MAX_SET_COUNT do
    local setItem = self.refineSetItems[i]
    if not setItem then
      break
    end
    local requiredLevel = sortedKeys[i]
    local attrData = requiredLevel and groupAttr[requiredLevel]
    if attrData then
      if setItem.gameObject then
        setItem.gameObject:SetActive(true)
      end
      local isUnlocked = minLevel >= requiredLevel
      if setItem.star then
        setItem.star:SetActive(isUnlocked)
      end
      if setItem.lock then
        setItem.lock:SetActive(not isUnlocked)
      end
      if setItem.label then
        local attrText = self:FormatAttrText(attrData)
        setItem.label.text = string.format(ZhString.CrownAccessoriesPage_ResonanceAttr, requiredLevel, attrText)
        setItem.label.color = isUnlocked and LABEL_COLOR_UNLOCKED or LABEL_COLOR_LOCKED
      end
    elseif setItem.gameObject then
      setItem.gameObject:SetActive(false)
    end
  end
end

function SnowGemSetCell:RefreshUpgradeSet(advanceLevelAttr, totalAdvLevel)
  if not self.upgradeSetItems or not advanceLevelAttr then
    return
  end
  local sortedKeys = {}
  for key, _ in pairs(advanceLevelAttr) do
    table.insert(sortedKeys, key)
  end
  table.sort(sortedKeys)
  for i = 1, MAX_SET_COUNT do
    local setItem = self.upgradeSetItems[i]
    if not setItem then
      break
    end
    local requiredAdvLevel = sortedKeys[i]
    local attrData = requiredAdvLevel and advanceLevelAttr[requiredAdvLevel]
    if attrData then
      if setItem.gameObject then
        setItem.gameObject:SetActive(true)
      end
      local isUnlocked = totalAdvLevel >= requiredAdvLevel
      if setItem.star then
        if isUnlocked then
          setItem.star.color = Color.white
        else
          setItem.star.color = ColorUtil.NGUILightShaderGray
        end
        setItem.star.gameObject:SetActive(true)
      end
      if setItem.label then
        local attrText = self:FormatAttrText(attrData)
        setItem.label.text = string.format("*%d：%s", requiredAdvLevel, attrText)
        setItem.label.color = isUnlocked and LABEL_COLOR_UNLOCKED or LABEL_COLOR_LOCKED
      end
    elseif setItem.gameObject then
      setItem.gameObject:SetActive(false)
    end
  end
end

function SnowGemSetCell:FormatAttrText(attrData)
  if not attrData then
    return ""
  end
  local attrTexts = {}
  for attrName, attrValue in pairs(attrData) do
    local propConfig = Game.Config_PropName and Game.Config_PropName[attrName]
    local displayName = propConfig and propConfig.PropName or attrName
    if (attrName == "MaxHP" or attrName == "MaxHp") and ZhString.EquipMemory_MaxHp then
      displayName = ZhString.EquipMemory_MaxHp
    end
    local isPercent = propConfig and (propConfig.IsPercent == 1 or propConfig.IsClientPercent == 1)
    if isPercent and string.sub(attrName, -3) == "Per" then
      local baseAttrName = string.sub(attrName, 1, -4)
      local basePropConfig = Game.Config_PropName and Game.Config_PropName[baseAttrName]
      if basePropConfig and basePropConfig.PropName then
        displayName = basePropConfig.PropName
      end
      if (baseAttrName == "MaxHP" or baseAttrName == "MaxHp") and ZhString.EquipMemory_MaxHp then
        displayName = ZhString.EquipMemory_MaxHp
      end
    end
    local valueText
    if isPercent then
      local percentValue = attrValue * 100
      if percentValue == math.floor(percentValue) then
        valueText = string.format("+%d%%", percentValue)
      else
        valueText = string.format("+%.1f%%", percentValue)
      end
    elseif attrValue == math.floor(attrValue) then
      valueText = string.format("+%d", attrValue)
    else
      valueText = string.format("+%.1f", attrValue)
    end
    table.insert(attrTexts, displayName .. valueText)
  end
  return table.concat(attrTexts, ", ")
end

function SnowGemSetCell:GetUnlockedAttrs()
  if not self.data then
    return {}
  end
  local unlockedAttrs = {}
  local groupId = self.data.groupId
  local groupConfig = Table_SnowStoneAttr and Table_SnowStoneAttr[groupId]
  if not groupConfig then
    return unlockedAttrs
  end
  local _, _, minLevel, totalAdvLevel = self:GetGroupGemData(self.data.gemIds)
  if groupConfig.GroupAttr then
    for requiredLevel, attrData in pairs(groupConfig.GroupAttr) do
      if requiredLevel <= minLevel then
        for attrName, attrValue in pairs(attrData) do
          unlockedAttrs[attrName] = (unlockedAttrs[attrName] or 0) + attrValue
        end
      end
    end
  end
  if groupConfig.AdvanceLevelAttr then
    for requiredAdvLevel, attrData in pairs(groupConfig.AdvanceLevelAttr) do
      if requiredAdvLevel <= totalAdvLevel then
        for attrName, attrValue in pairs(attrData) do
          unlockedAttrs[attrName] = (unlockedAttrs[attrName] or 0) + attrValue
        end
      end
    end
  end
  return unlockedAttrs
end

function SnowGemSetCell:GetData()
  return self.data
end
