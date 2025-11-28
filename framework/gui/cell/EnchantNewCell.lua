local spriteNameMap = {
  [EnchantAttriQuality.Good] = "enchant_success"
}
EnchantNewCell = class("EnchantNewCell", CoreView)
EnchantNewCell.EnchantNewCell_LockEvent = "EnchantNewCell_LockEvent"

function EnchantNewCell:ctor(obj)
  EnchantNewCell.super.ctor(self, obj)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.chooseSymbol_Icon = self.chooseSymbol:GetComponent(UISprite)
  self.grid = self:FindComponent("Grid", UIGrid)
  self.gridTrans = self.grid.transform
  self.gridPosX = LuaGameObject.GetLocalPosition(self.gridTrans)
  self.attrGOs, self.attrNames, self.attrValues, self.attrIndicators, self.attrMaxTips, self.minRatioBg, self.attrUpValue, self.lockBtn, self.thirdAttrBg, self.attrCurProgress, self.attrNextProgress, self.attrBg, self.attrDots = {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}
  self.priorLocks = {}
  local go
  for i = 1, 3 do
    go = self:FindGO("Attr" .. i)
    self.attrGOs[i] = go
    self.attrDots[i] = go:GetComponent(UISprite)
    self.attrNames[i] = self:FindComponent("AttrName", UILabel, go)
    self.attrValues[i] = self:FindComponent("AttrValue", UILabel, go)
    self.attrIndicators[i] = self:FindComponent("AttrIndicator", UISprite, go)
    self.attrMaxTips[i] = self:FindGO("MaxTip", go)
    self.minRatioBg[i] = self:FindGO("MinRatioBg", go)
    self.attrUpValue[i] = self:FindComponent("AttrUpValueLab", UILabel, self.minRatioBg[i])
    self.attrCurProgress[i] = self:FindComponent("CurProgress", UISlider, go)
    self.attrNextProgress[i] = self:FindComponent("ExtraProgress", UISlider, go)
    self.priorLocks[i] = self:FindGO("PriorLock", go)
    self.priorLocks[i]:SetActive(false)
    self.thirdAttrBg[i] = self:FindComponent("ThirdAttrBg", UISprite, go)
    self.thirdAttrBg[i].gameObject:SetActive(false)
    self.attrBg[i] = self:FindComponent("Bg", UISprite, go)
  end
  self.combineAttr = self:FindGO("CombineAttr")
  self.combineAttrName = self:FindComponent("CombineAttrName", UILabel)
  self.combineAttrBG = self.combineAttr:GetComponent(UISprite)
  self.combineAttrPriorLock = self:FindGO("PriorLock", self.combineAttr)
  self.combineAttrPriorLock_Bg = self:FindGO("LockBg", self.combineAttr):GetComponent(UISprite)
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self.widget = self.gameObject:GetComponent(UIWidget)
  self.bg = self:FindGO("BG"):GetComponent(UISprite)
end

function EnchantNewCell:SetData(data)
  local flag = data ~= nil and data.enchantAttrList ~= nil and #data.enchantAttrList > 0
  self.thirdAttrType = data and data.thirdAttrType
  self.allAttrIsMax = data and data.allAttrIsMax
  self.gameObject:SetActive(flag)
  self.index = flag and data.index or nil
  if flag then
    self:UpdateAttrs(data.enchantAttrList, data.minRatioAttrType, data.nextAttrValue)
    self:UpdateCombine(data.combineEffectList, data.quench)
    self:_updateLockState()
    self:_updateThirdAttrBg(data.enchantAttrList)
  end
  self:UpdateChoose()
end

function EnchantNewCell:UpdateAttrs(attrs, minRatioAttrType, nextAttrValue)
  local data, quality, indicator
  TableUtility.TableClear(self.lockBtn)
  for i = 1, #self.attrGOs do
    data = attrs and attrs[i]
    self.attrGOs[i]:SetActive(data ~= nil)
    if data then
      local attr_type = data.type
      self.attrNames[i].text = data.name
      self.attrValues[i].text = string.format(data.propVO.isPercent and "+%s%%" or "+%s", data.value)
      quality, indicator = data.Quality, self.attrIndicators[i]
      if data.isMax then
        self.attrMaxTips[i]:SetActive(true)
        self:Hide(indicator)
      else
        self.attrMaxTips[i]:SetActive(false)
        if not self.hideIndicator then
          self:_SetIndicatorSp(quality, indicator)
        end
      end
      if self.attrCurProgress[i] then
        self.attrCurProgress[i].value = data.valueRatio
      end
      if minRatioAttrType and minRatioAttrType == attr_type and nextAttrValue and not self.allAttrIsMax then
        self:Show(self.minRatioBg[i])
        self.attrUpValue[i].text = string.format(data.propVO.isPercent and "+%s%%" or "+%s", nextAttrValue)
        if self.attrNextProgress[i] then
          self.attrNextProgress[i].value = nextAttrValue / data.maxAttrValue4AttrUp
        end
        self.attrBg[i].color = LuaGeometry.GetTempVector4(0.9921568627450981, 0.9803921568627451, 0.7803921568627451, 1)
        self.attrDots[i].enabled = false
        self.priorLocks[i]:SetActive(false)
      else
        self:Hide(self.minRatioBg[i])
        self.attrNextProgress[i].value = 0
        self.attrBg[i].color = LuaColor.White()
        self.attrDots[i].enabled = true
        if minRatioAttrType then
          self.priorLocks[i]:SetActive(true)
        end
      end
      self.lockBtn[attr_type] = self:FindComponent("LockAttrBtn", UISprite, self.attrGOs[i])
      self:Hide(self.lockBtn[attr_type])
      self:AddClickEvent(self.lockBtn[attr_type].gameObject, function()
        self:ReverseLock()
      end)
    end
  end
  if minRatioAttrType then
    self.combineAttrPriorLock_Bg.gameObject:SetActive(true)
    self.combineAttrPriorLock:SetActive(true)
  else
    self.combineAttrPriorLock_Bg.gameObject:SetActive(false)
    self.combineAttrPriorLock:SetActive(false)
  end
end

function EnchantNewCell:ReverseLock()
  self.attrLocked = not self.attrLocked
  self:_playLockTween()
  self:PassEvent(EnchantNewCell.EnchantNewCell_LockEvent, self.attrLocked)
end

function EnchantNewCell:ResetAttrLocked()
  self.attrLocked = nil
end

function EnchantNewCell:_playLockTween()
  local lockIcon = self:FindGO("LockIcon", self.lockBtn[self.thirdAttrType].gameObject)
  local unLockIcon = self:FindGO("UnLockIcon", self.lockBtn[self.thirdAttrType].gameObject)
  if nil == self.attrLocked then
    self:Show(unLockIcon)
    self:Hide(lockIcon)
  elseif self.attrLocked then
    self:Hide(unLockIcon)
    self:Show(lockIcon)
  else
    self:Show(unLockIcon)
    self:Hide(lockIcon)
  end
end

function EnchantNewCell:_SetIndicatorSp(quality, indicator)
  if not quality or not indicator then
    return
  end
  local findQualityName = spriteNameMap[quality]
  if findQualityName then
    self:Show(indicator)
    if findQualityName ~= indicator.spriteName then
      indicator.spriteName = findQualityName
    end
  else
    self:Hide(indicator)
  end
end

function EnchantNewCell:UpdateThirdAttrBg(thirdAttrShowCondition)
  self.thirdAttrShowCondition = thirdAttrShowCondition
end

function EnchantNewCell:_updateThirdAttrBg(attrs)
  if nil == self.thirdAttrType then
    return
  end
  if not attrs then
    return
  end
  if self.thirdAttrShowCondition and not self.allAttrIsMax then
    for i = 1, 3 do
      local data = attrs[i]
      local attr_type = data.type
      if attr_type == self.thirdAttrType then
        self.attrBg[i].color = LuaGeometry.GetTempVector4(0.9921568627450981, 0.9803921568627451, 0.7803921568627451, 1)
        self.thirdAttrBg[i].gameObject:SetActive(true)
        self.attrDots[i].enabled = false
        self.priorLocks[i]:SetActive(false)
      else
        self.attrBg[i].color = LuaColor.White()
        self.thirdAttrBg[i].gameObject:SetActive(false)
        self.attrDots[i].enabled = true
        self.priorLocks[i]:SetActive(true)
      end
    end
    self.combineAttrPriorLock_Bg.gameObject:SetActive(true)
    self.combineAttrPriorLock:SetActive(true)
  end
end

function EnchantNewCell:UpdateLockTog(lockShowCondition)
  if lockShowCondition == self.lockShowCondition then
    return
  end
  self.lockShowCondition = lockShowCondition
  self:_updateLockState()
end

function EnchantNewCell:CheckLockActiveValid()
  return nil ~= self.thirdAttrType and self.lockShowCondition == true
end

function EnchantNewCell:_updateLockState()
  for t, lockSp in pairs(self.lockBtn) do
    if self.thirdAttrType and t == self.thirdAttrType and self.lockShowCondition then
      self:Show(lockSp)
      self:_playLockTween()
    else
      self:Hide(lockSp)
    end
  end
end

function EnchantNewCell:UpdateCombine(combineEffs, quench)
  local hasCombine, buffData = false
  if combineEffs then
    for i = 1, #combineEffs do
      buffData = combineEffs[i] and combineEffs[i].buffData
      if buffData then
        hasCombine = true
        local buffDesc = ItemUtil.GetBuffDesc(buffData.BuffDesc, quench)
        self.combineAttrName.text = string.format("%s:%s", ZhString.EnchantAttrUp_CombineAttr .. OverSea.LangManager.Instance():GetLangByKey(buffData.BuffName), buffDesc)
      end
    end
  end
  self.gridTrans.localPosition = LuaGeometry.GetTempVector3(self.gridPosX, hasCombine and -23.75 or -23.75)
  self.grid.cellHeight = hasCombine and 38.2 or 38.2
  self.grid:Reposition()
  self.combineAttr:SetActive(hasCombine)
  self.hasCombine = hasCombine
  local combineAttrHeight = self.combineAttrName.printedSize.y
  self.combineAttrBG.height = combineAttrHeight + 10
  self.combineAttrPriorLock_Bg.height = combineAttrHeight + 10
  if self.bg then
    self.bg.height = hasCombine and 140 + combineAttrHeight or 121
  end
  self.widget.height = hasCombine and 146 + combineAttrHeight or 127
  self.chooseSymbol_Icon.height = hasCombine and 144 + combineAttrHeight or 125
end

function EnchantNewCell:SetChooseId(chooseId)
  self.chooseId = chooseId
  self:UpdateChoose()
end

function EnchantNewCell:UpdateChoose()
  if not self.chooseSymbol then
    return
  end
  self.chooseSymbol:SetActive(self.chooseId ~= nil and self.index ~= nil and self.chooseId == self.index)
end

function EnchantNewCell:HideBG()
  if self.bg then
    self.bg.enabled = false
  end
  self.hideIndicator = true
end
