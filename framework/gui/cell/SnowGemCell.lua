SnowGemCell = class("SnowGemCell", BaseCell)

function SnowGemCell:Init()
  SnowGemCell.super.Init(self)
  self:FindObjs()
  self:AddCellClickEvent()
end

function SnowGemCell:FindObjs()
  self.nameLabel = self:FindComponent("Name", UILabel)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  if self.chooseSymbol then
    self.chooseSymbol:SetActive(false)
  end
  self.bg = self:FindGO("Bg")
  self.lock = self:FindGO("Lock")
  self.recommend = self:FindGO("Recommend")
  self.itemContainer = self:FindGO("ItemContainer")
  self:CreateItemCell()
end

function SnowGemCell:CreateItemCell()
  if not self.itemContainer then
    return
  end
  local itemCellGO = self:CreateObj(ResourcePathHelper.UICell("ItemCell"), self.itemContainer)
  if itemCellGO then
    self.itemCell = ItemCell.new(itemCellGO)
  end
end

function SnowGemCell:SetData(data)
  SnowGemCell.super.SetData(self, data)
  self.data = data
  if not data then
    return
  end
  local gemId = data.id
  local isUnlocked = data.isUnlocked
  local isSelected = data.isSelected
  self:SetName(gemId)
  self:SetLockState(not isUnlocked)
  self:SetSelected(isSelected)
  self:SetRecommend(data.isRecommend)
  self:SetItemCellData(data)
end

function SnowGemCell:SetItemCellData(data)
  if not (self.itemCell and data) or not data.id then
    return
  end
  local itemData = ItemData.new(data.id, data.id)
  itemData:SetSnowGemData({
    id = data.id,
    level = data.level or 0,
    advlv = data.advlv or 0
  })
  if data.count and 0 < data.count then
    itemData.num = data.count
  end
  self.itemCell:SetData(itemData)
end

function SnowGemCell:SetName(gemId)
  if not self.nameLabel or not gemId then
    return
  end
  local stoneConfig = Table_SnowStone and Table_SnowStone[gemId]
  if stoneConfig and stoneConfig.Name then
    self.nameLabel.text = stoneConfig.Name
  else
    local itemConfig = Table_Item and Table_Item[gemId]
    if itemConfig and itemConfig.NameZh then
      self.nameLabel.text = itemConfig.NameZh
    else
      self.nameLabel.text = ""
    end
  end
end

function SnowGemCell:SetLockState(isLocked)
  if self.lock then
    self.lock:SetActive(isLocked == true)
  end
end

function SnowGemCell:SetSelected(isSelected)
  self.isSelected = isSelected
  if self.chooseSymbol then
    self.chooseSymbol:SetActive(isSelected == true)
  end
end

function SnowGemCell:IsSelected()
  return self.isSelected
end

function SnowGemCell:GetData()
  return self.data
end

function SnowGemCell:GetGemId()
  return self.data and self.data.id
end

function SnowGemCell:IsUnlocked()
  return self.data and self.data.isUnlocked
end

function SnowGemCell:SetRecommend(isRecommend)
  if self.recommend then
    self.recommend:SetActive(isRecommend == true)
  end
end

function SnowGemCell:PlayStarUpEffect(oldAdvLv, newAdvLv, onComplete)
  if not self.itemCell or not self.itemCell.snowGemAdvStarSprites then
    if onComplete then
      onComplete()
    end
    return
  end
  oldAdvLv = oldAdvLv or 0
  newAdvLv = newAdvLv or 0
  if oldAdvLv >= newAdvLv then
    self.itemCell:SetSnowGemStarsAlpha(newAdvLv)
    if onComplete then
      onComplete()
    end
    return
  end
  self.itemCell:SetSnowGemStarsAlpha(oldAdvLv)
  local starsToUnlock = {}
  for i = oldAdvLv + 1, newAdvLv do
    if i <= 5 then
      table.insert(starsToUnlock, i)
    end
  end
  self:PlayStarUnlockSequence(starsToUnlock, 1, onComplete)
end

function SnowGemCell:PlayStarUnlockSequence(starsToUnlock, index, onComplete)
  if index > #starsToUnlock then
    self:ClearStarUnlockTick()
    if onComplete then
      onComplete()
    end
    return
  end
  local starIndex = starsToUnlock[index]
  local starGO = self.itemCell and self.itemCell.snowGemAdvStars and self.itemCell.snowGemAdvStars[starIndex]
  local starSprite = self.itemCell and self.itemCell.snowGemAdvStarSprites and self.itemCell.snowGemAdvStarSprites[starIndex]
  if starGO and starSprite then
    starSprite.alpha = 0
    LeanTween.value(starGO, function(v)
      starSprite.alpha = v
    end, 0, 1, 0.15)
    self:PlayUIEffect(EffectMap.UI.SnowGem_StarLevelUp, starGO, true)
    self:ClearStarUnlockTick()
    self.starUnlockTickId = self:GetStarUnlockTickId()
    TimeTickManager.Me():CreateTick(200, 0, function()
      self:PlayStarUnlockSequence(starsToUnlock, index + 1, onComplete)
    end, self, self.starUnlockTickId)
  else
    self:PlayStarUnlockSequence(starsToUnlock, index + 1, onComplete)
  end
end

function SnowGemCell:GetStarUnlockTickId()
  return "SnowGemCell_StarUnlock_" .. tostring(math.random(100000, 999999))
end

function SnowGemCell:ClearStarUnlockTick()
  if self.starUnlockTickId then
    TimeTickManager.Me():ClearTick(self.starUnlockTickId)
    self.starUnlockTickId = nil
  end
end
