PersonalArtifactRefreshAttributeCell = class("PersonalArtifactRefreshAttributeCell", CoreView)
local delimiter, sliderFullLength, ins, tickManager, strfmt, abs, round, epsilon = "＋", 352
local valueChangeDuration, valueRetainedDuration, valueJumpDuration = 0.6, 0.2, 0.2
local _getValueText = function(value, isPercent)
  local format = isPercent and "%s%%" or "%s"
  value = isPercent and value * 100 or value
  return strfmt(format, round(value * 100) / 100)
end
local availableUniqueDescColor, unavailableUniqueDescColor = LuaColor.New(0.09803921568627451, 0.09803921568627451, 0.09803921568627451), LuaColor.New(0.7333333333333333, 0.7333333333333333, 0.7333333333333333)

function PersonalArtifactRefreshAttributeCell:ctor(obj)
  if not ins then
    ins = PersonalArtifactProxy.Instance
    tickManager = TimeTickManager.Me()
    strfmt = string.format
    abs = math.abs
    round = math.round
    epsilon = math.Epsilon
  end
  PersonalArtifactRefreshAttributeCell.super.ctor(self, obj)
  self:Init()
end

function PersonalArtifactRefreshAttributeCell:Init()
  self.indexLab = self:FindComponent("IndexLab", UILabel)
  self.drag = self.gameObject:GetComponent(UIDragScrollView)
  self.label = self:FindComponent("Name", UILabel)
  self.attrLab = self:FindComponent("AttrLab", UILabel)
  self.valueLabel = self:FindComponent("Value", UILabel)
  self.indicator = self:FindComponent("Indicator", UISprite)
  self.infoBtn = self:FindGO("Info")
  self.uniqueDesc = self:FindComponent("UniqueDesc", UILabel)
  self.sliderParent = self:FindComponent("SliderBg", UISprite)
  self.foreSlider = self:FindComponent("ForeSlider", UISlider)
  self.foreSliderSp = self:FindComponent("ForeSlider", UISprite)
  self.backSlider = self:FindComponent("BackSlider", UISlider)
  self.backSliderSp = self:FindComponent("BackSlider", UISprite)
  self.conditionIndicatorTrans = self:FindGO("ConditionIndicator").transform
  self.effContainer = self:FindGO("EffectContainer")
  self:AddGameObjectComp()
  self:AddClickEvent(self.infoBtn, function()
    if not self.data then
      return
    end
    MsgManager.FloatMsg(nil, string.format(ZhString.PersonalArtifact_UniqueEffectFormatTip, self.data.personalArtifactData.percentage))
  end)
  UIUtil.HandleDragScrollForObj(self.infoBtn, self.drag)
end

function PersonalArtifactRefreshAttributeCell:SetData(data)
  tickManager:ClearTick(self)
  self.data = data
  if not data then
    LogUtility.Error("Cannot get data")
    return
  end
  local isUniqueEffect = data.isUniqueEffect == true
  self.sliderParent.gameObject:SetActive(not isUniqueEffect)
  self:UpdateCompareResult()
  self.label.gameObject:SetActive(not isUniqueEffect)
  self.attrLab.gameObject:SetActive(not isUniqueEffect)
  self.uniqueDesc.gameObject:SetActive(isUniqueEffect)
  self.infoBtn:SetActive(isUniqueEffect)
  if isUniqueEffect then
    local psData, sb = data.personalArtifactData, LuaStringBuilder.CreateAsTable()
    local eff, isAvailable = psData.staticComposeData.UniqueEffect, psData:IsUniqueEffectAvailable()
    for i = 1, #eff do
      sb:Append(OverSea.LangManager.Instance():GetLangByKey(Table_Buffer[eff[i]].Dsc))
      if i < #eff then
        sb:Append("\n")
      end
    end
    self.uniqueDesc.text = strfmt("%s", sb:ToString())
    self.uniqueDesc.color = isAvailable and availableUniqueDescColor or unavailableUniqueDescColor
    sb:Destroy()
    self:Hide(self.indexLab)
  else
    local sAttrData = ins:GetStaticAttrDataByIdAndValue(self.data.id, self.data.value or 0)
    if not sAttrData then
      LogUtility.WarningFormat("Cannot find StaticAttrData by id = {0} and value = {1}", self.data.id, self.data.value)
      return
    end
    self.isPercent, self.max, self.desc = 0 < sAttrData.IsPercent, sAttrData.AttrMax, string.split(OverSea.LangManager.Instance():GetLangByKey(sAttrData.Dsc), delimiter)[1]
    self:UpdateMainLabel()
    self.conditionIndicatorTrans.localPosition = LuaGeometry.GetTempVector3(sliderFullLength * self:GetRealPercentage() - sliderFullLength / 2)
    self:UpdateForeSlider()
    self:Show(self.indexLab)
    self.indexLab.text = StringUtil.IntToRoman(data.index)
  end
  self:SetAlpha()
end

function PersonalArtifactRefreshAttributeCell:SetAlpha()
  local alpha = self.data.fake and 0.3 or 1
  self.label.alpha = alpha
  self.sliderParent.alpha = alpha
  self.attrLab.alpha = alpha
end

function PersonalArtifactRefreshAttributeCell:UpdateMainLabel(v)
  v = v or self.data and self.data.value
  if not v then
    LogUtility.Warning("PersonalArtifactRefreshAttributeCell: update main label failed.")
    self.label.text = ""
    self.attrLab.text = ""
    return
  end
  self.label.text = self.desc or ""
  self.attrLab.text = _getValueText(PersonalArtifactProxy.GetRealValue(v), self.isPercent) .. "/" .. _getValueText(self.max, self.isPercent)
end

function PersonalArtifactRefreshAttributeCell:UpdateValueLabel(v, flag)
  if not v or flag == nil then
    self.valueLabel.text = ""
    return
  end
  local _, valueColor = ColorUtil.TryParseHexString(flag and "EA5654FF" or "397FC3FF")
  self.valueLabel.color = valueColor
  self.valueLabel.text = strfmt(flag and "+%s" or "-%s", _getValueText(PersonalArtifactProxy.GetRealValue(v), self.isPercent))
end

function PersonalArtifactRefreshAttributeCell:UpdateForeSlider(v)
  v = v or self.data and self.data.value or 0
  local realV = PersonalArtifactProxy.GetRealValue(v)
  local ratio = realV / self.max
  local _, valueColor = ColorUtil.TryParseHexString(0.8 <= ratio + epsilon and "A3F46D" or "F4D86D")
  self.foreSliderSp.color = valueColor
  self.foreSlider.value = ratio
end

function PersonalArtifactRefreshAttributeCell:UpdateBackSlider(v, flag)
  if not v or flag == nil then
    self.backSlider.value = 0
    return
  end
  local _, backSliderColor = ColorUtil.TryParseHexString(flag and "FBC6DEFF" or "C6DDFBFF")
  self.backSliderSp.color = backSliderColor
  local ratio = PersonalArtifactProxy.GetRealValue(v) / self.max
  if flag then
    self.backSlider.value = ratio
  else
    self.backSlider.value = self.foreSlider.value
    self.foreSlider.value = ratio
  end
end

function PersonalArtifactRefreshAttributeCell:UpdateCompareResult(curValue, targetValue)
  if curValue then
    self:UpdateMainLabel(curValue)
    self:UpdateForeSlider(curValue)
  end
  local flag = curValue and targetValue and 0 < targetValue - curValue
  if curValue == targetValue then
    flag = nil
  end
  local hasFlag = flag ~= nil
  self.indicator.gameObject:SetActive(hasFlag)
  self.backSlider.gameObject:SetActive(hasFlag)
  if not hasFlag then
    return
  end
  self.indicator.spriteName = strfmt("magicbox_icon_boli%s", flag and "up" or "down")
  self:UpdateValueLabel(abs(targetValue - curValue), flag)
  self:UpdateBackSlider(targetValue, flag)
end

function PersonalArtifactRefreshAttributeCell:GetRealPercentage()
  return (self.data and self.data.percentage or 0) / 100
end

function PersonalArtifactRefreshAttributeCell:TryCompareAttributes(candidateAttrs)
  if not self.data or self.data.isUniqueEffect then
    return
  end
  local candidateValue
  if self.data and type(candidateAttrs) == "table" then
    for i = 1, #candidateAttrs do
      if self.data.id == candidateAttrs[i].id then
        candidateValue = candidateAttrs[i].value
        break
      end
    end
  end
  self:UpdateCompareResult(self.data.value, candidateValue)
end

function PersonalArtifactRefreshAttributeCell:TryShowRefreshAnim(cachedAttrMap, onFinished, onFinishedArg)
  local data = self.data
  if not data or data.isUniqueEffect or type(cachedAttrMap) ~= "table" then
    return
  end
  local cachedValue = cachedAttrMap[data.id]
  if cachedValue and cachedValue ~= data.value then
    self:UpdateCompareResult(cachedValue, data.value)
    self.animValue, self.animDelta, self.animInterval = cachedValue, data.value - cachedValue, 0.033
    self.animOnFinished, self.animOnFinishedArg, self.exValueRemained = onFinished, onFinishedArg, 0
    tickManager:CreateTick(0, self.animInterval * 1000, self._RefreshAnimUpdate, self, 1, true)
  else
    onFinished(onFinishedArg)
  end
end

function PersonalArtifactRefreshAttributeCell:_RefreshAnimUpdate(interval)
  self.animValue = self.animValue + self.animDelta * interval / valueChangeDuration
  local valueRemained = self.data.value - self.animValue
  if self.exValueRemained ~= 0 and valueRemained * self.exValueRemained <= 0 then
    self:UpdateCompareResult(self.data.value)
    self.indicator.gameObject:SetActive(true)
    self:UpdateValueLabel(0, self.animDelta > 0)
    tickManager:ClearTick(self, 1)
    tickManager:CreateOnceDelayTick(valueRetainedDuration * 1000, function(self)
      if not self then
        return
      end
      if self.indicator then
        self.indicator.gameObject:SetActive(false)
      end
      if self.animOnFinished then
        self.animOnFinished(self.animOnFinishedArg)
      end
    end, self, 2)
  else
    self.exValueRemained = valueRemained
    self:UpdateCompareResult(self.animValue, self.data.value)
  end
  self:UpdateValueLabel()
end

function PersonalArtifactRefreshAttributeCell:OnDestroy()
  tickManager:ClearTick(self)
end
