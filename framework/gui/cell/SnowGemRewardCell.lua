autoImport("SnowGemCell")
SnowGemRewardCell = class("SnowGemRewardCell", BaseCell)
SnowGemRewardCell.CellType = {Progress = 1, Overflow = 2}

function SnowGemRewardCell:Init()
  SnowGemRewardCell.super.Init(self)
  self:AddGameObjectComp()
  self:FindObjs()
  self:AddCellClickEvent()
end

function SnowGemRewardCell:FindObjs()
  self.container = self:FindGO("Container")
  self.widget = self.container:GetComponent(UIWidget)
  local snowGemCellGO = self:FindGO("SnowGemCell", self.container)
  if snowGemCellGO then
    self.snowGemCell = SnowGemCell.new(snowGemCellGO)
  end
  self.newSymbol = self:FindGO("NewSymbol", self.container)
  if self.newSymbol then
    self.newSymbol:SetActive(false)
  end
  self.sliderGO = self:FindGO("Slider", self.container)
  if self.sliderGO then
    self.slider = self.sliderGO:GetComponent(UISlider)
  end
  self.progressLabel = self:FindComponent("ProgressLabel", UILabel, self.container)
  self.transferTarget = self:FindGO("TransferTarget", self.container)
  if self.transferTarget then
    self.arrow = self:FindGO("Arrow", self.transferTarget)
    local targetGemCellGO = self:FindGO("TargetGemCell", self.transferTarget)
    if targetGemCellGO then
      self.targetItemCell = SnowGemCell.new(targetGemCellGO)
    end
  end
end

function SnowGemRewardCell:SetData(data)
  SnowGemRewardCell.super.SetData(self, data)
  self.data = data
  if not data then
    return
  end
  local cellType = data.cellType or SnowGemRewardCell.CellType.Progress
  self:SetSnowGemCell(data)
  if cellType == SnowGemRewardCell.CellType.Progress then
    self:ShowProgressMode(data)
  elseif cellType == SnowGemRewardCell.CellType.Overflow then
    self:ShowOverflowMode(data)
  end
end

function SnowGemRewardCell:SetSnowGemCell(data)
  if not self.snowGemCell then
    return
  end
  local oldAdvlv = data.oldAdvlv or 0
  local newAdvlv = data.newAdvlv or 0
  local displayAdvlv = newAdvlv
  if oldAdvlv < newAdvlv then
    displayAdvlv = oldAdvlv
  end
  self.snowGemCell:SetData({
    id = data.stoneId,
    isUnlocked = true,
    isSelected = false,
    level = data.level or 0,
    advlv = displayAdvlv,
    advexp = data.newAdvexp or 0
  })
end

function SnowGemRewardCell:ShowProgressMode(data)
  if self.transferTarget then
    self.transferTarget:SetActive(false)
  end
  if self.progressLabel then
    self.progressLabel.gameObject:SetActive(true)
  end
  if self.newSymbol then
    self.newSymbol:SetActive(data.isNewStone == true)
  end
  self:SetProgressSlider(data)
end

function SnowGemRewardCell:ShowOverflowMode(data)
  if self.sliderGO then
    self.sliderGO:SetActive(false)
  end
  if self.progressLabel then
    self.progressLabel.gameObject:SetActive(false)
  end
  if self.transferTarget then
    self.transferTarget:SetActive(true)
  end
  if self.newSymbol then
    self.newSymbol:SetActive(false)
  end
  self:SetTransferTarget(data)
end

function SnowGemRewardCell:SetProgressSlider(data)
  if not data then
    return
  end
  local newAdvexp = data.newAdvexp or 0
  local oldAdvexp = data.oldAdvexp or 0
  local maxCount = data.maxCount or 1
  local progressDelta = data.progressDelta or 0
  local oldAdvlv = data.oldAdvlv or 0
  local newAdvlv = data.newAdvlv or 0
  local isNewStone = data.isNewStone == true
  local oldProgressValue = oldAdvexp / maxCount
  if 1 < oldProgressValue then
    oldProgressValue = 1
  end
  local newProgressValue = newAdvexp / maxCount
  if 1 < newProgressValue then
    newProgressValue = 1
  end
  local stoneAdvanceCount = GameConfig.Snow and GameConfig.Snow.StoneAdvanceCount or {}
  local isMaxLevel = stoneAdvanceCount[newAdvlv + 1] == nil
  if self.sliderGO then
    local shouldHide = isNewStone or isMaxLevel
    self.sliderGO:SetActive(not shouldHide)
  end
  if self.progressLabel then
    if oldAdvlv == 0 and newAdvexp == 0 then
      self.progressLabel.text = ""
    elseif oldAdvlv < newAdvlv then
      self.progressLabel.text = ZhString.SnowGemReward_StarUp or "星级已提升"
    else
      local deltaPercent = math.floor(progressDelta * 100 + 0.5)
      if 0 < deltaPercent then
        self.progressLabel.text = string.format(ZhString.SnowGemReward_Progress or "升星+%s%%", deltaPercent)
      else
        self.progressLabel.text = ""
      end
    end
  end
  self:PlayProgressAnimation(data, oldAdvlv, newAdvlv, oldProgressValue, newProgressValue)
end

function SnowGemRewardCell:PlayProgressAnimation(data, oldAdvlv, newAdvlv, oldProgress, newProgress)
  self:CancelProgressTween()
  local animDuration = 0.5
  local sliderActive = self.slider and not self:ObjIsNil(self.sliderGO) and self.sliderGO.activeSelf
  local isLevelUp = oldAdvlv < newAdvlv
  if not isLevelUp then
    if sliderActive then
      self.slider.value = oldProgress
      self:TweenSliderValue(oldProgress, newProgress, animDuration)
    end
  else
    self:UpdateSnowGemCellAdvlv(data, oldAdvlv)
    if sliderActive then
      self.slider.value = oldProgress
      self:TweenSliderValue(oldProgress, 1, animDuration, function()
        self:PlayStarUpEffectAndUpdate(data, oldAdvlv, newAdvlv, function()
          if self.slider and not self:ObjIsNil(self.sliderGO) then
            self.slider.value = 0
            self:TweenSliderValue(0, newProgress, animDuration)
          end
        end)
      end)
    else
      self:PlayStarUpEffectAndUpdate(data, oldAdvlv, newAdvlv, nil)
    end
  end
end

function SnowGemRewardCell:TweenSliderValue(fromValue, toValue, duration, onComplete)
  if not self.slider or self:ObjIsNil(self.sliderGO) then
    return
  end
  if onComplete then
    LeanTween.value(self.sliderGO, function(v)
      if self.slider and not self:ObjIsNil(self.sliderGO) then
        self.slider.value = v
      end
    end, fromValue, toValue, duration):setOnComplete(onComplete)
  else
    LeanTween.value(self.sliderGO, function(v)
      if self.slider and not self:ObjIsNil(self.sliderGO) then
        self.slider.value = v
      end
    end, fromValue, toValue, duration)
  end
end

function SnowGemRewardCell:CancelProgressTween()
  if not self:ObjIsNil(self.sliderGO) then
    LeanTween.cancel(self.sliderGO)
  end
end

function SnowGemRewardCell:UpdateSnowGemCellAdvlv(data, advlv)
  if not self.snowGemCell or not self.snowGemCell.itemCell then
    return
  end
  self.snowGemCell.itemCell:SetSnowGemStarsAlpha(advlv)
end

function SnowGemRewardCell:PlayStarUpEffectAndUpdate(data, oldAdvlv, newAdvlv, onComplete)
  if not self.snowGemCell then
    if onComplete then
      onComplete()
    end
    return
  end
  self.snowGemCell:PlayStarUpEffect(oldAdvlv, newAdvlv, onComplete)
end

function SnowGemRewardCell:SetTransferTarget(data)
  if not self.transferTarget or not data then
    return
  end
  local quality = data.quality or 1
  local stoneToMaterial = GameConfig.Snow and GameConfig.Snow.StoneToMaterial
  local materials = stoneToMaterial and stoneToMaterial[quality]
  if materials and 0 < #materials then
    local materialData = materials[1]
    local itemId = materialData[1]
    local baseCount = materialData[2] or 1
    local totalCount = baseCount * data.overflow
    if self.targetItemCell then
      self.targetItemCell:SetData({
        id = itemId,
        isUnlocked = true,
        isSelected = false,
        count = totalCount
      })
    end
  end
end

function SnowGemRewardCell:GetData()
  return self.data
end

function SnowGemRewardCell:OnDestroy()
  self:CancelProgressTween()
  SnowGemRewardCell.super.OnDestroy(self)
end
