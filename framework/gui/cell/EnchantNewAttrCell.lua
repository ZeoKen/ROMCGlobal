local spriteNameMap = {
  [EnchantAttriQuality.Good] = "enchant_success"
}
EnchantNewAttrCell = class("EnchantNewAttrCell", CoreView)

function EnchantNewAttrCell:ctor(obj)
  EnchantNewAttrCell.super.ctor(self, obj)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.attrName = self:FindComponent("AttrName", UILabel)
  self.attrValue = self:FindComponent("AttrValue", UILabel)
  self.attrIndicator = self:FindComponent("AttrIndicator", UISprite)
  self.attrMaxTip = self:FindGO("MaxTip")
  self.attrProgress = self:FindComponent("CurProgress", UISlider)
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function EnchantNewAttrCell:SetData(data)
  self:UpdateAttrs(data)
  self:UpdateChoose()
end

function EnchantNewAttrCell:UpdateAttrs(enchantAttri)
  local quality, indicator
  if not enchantAttri then
    return
  end
  local attr_type = enchantAttri.type
  self.attrName.text = enchantAttri.name
  self.attrValue.text = string.format(enchantAttri.propVO.isPercent and "+%s%%" or "+%s", enchantAttri.value)
  self.attrProgress.value = enchantAttri.valueRatio or 0
  if enchantAttri.isMax then
    self.attrMaxTip:SetActive(true)
    self:Hide(self.attrIndicator)
  else
    self.attrMaxTip:SetActive(false)
    self:_SetIndicatorSp(enchantAttri.Quality)
  end
  self.refreshIndex = enchantAttri.refreshIndex
end

function EnchantNewAttrCell:_SetIndicatorSp(quality)
  if not quality or not self.attrIndicator then
    return
  end
  local findQualityName = spriteNameMap[quality]
  if findQualityName then
    self:Show(self.attrIndicator)
    if findQualityName ~= self.attrIndicator.spriteName then
      self.attrIndicator.spriteName = findQualityName
    end
  else
    self:Hide(self.attrIndicator)
  end
end

function EnchantNewAttrCell:SetChooseId(chooseIndex)
  self.chooseIndex = chooseIndex
  self:UpdateChoose()
end

function EnchantNewAttrCell:UpdateChoose()
  if not self.chooseSymbol then
    return
  end
  self.chooseSymbol:SetActive(nil ~= self.chooseIndex and nil ~= self.refreshIndex and self.chooseIndex == self.refreshIndex)
end
