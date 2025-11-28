local BaseCell = autoImport("BaseCell")
KnightPrestigeLevelCell = class("KnightPrestigeLevelCell", BaseCell)
local _PrestigeOutlineColor = {
  [1] = LuaColor.New(0.8, 0.2549019607843137, 0.24705882352941178, 1),
  [2] = LuaColor.New(0.7568627450980392, 0.17647058823529413, 0.4470588235294118, 1),
  [3] = LuaColor.New(0.3411764705882353, 0.6509803921568628, 0.5725490196078431, 1),
  [4] = LuaColor.New(0.8431372549019608, 0.5490196078431373, 0.3215686274509804, 1),
  [5] = LuaColor.New(0.41568627450980394, 0.41568627450980394, 0.41568627450980394, 1),
  [6] = LuaColor.New(0.7647058823529411, 0.27058823529411763, 0.6431372549019608, 1)
}

function KnightPrestigeLevelCell:Init()
  self.icon = self.gameObject:GetComponent(UIMultiSprite)
  self.label = self:FindGO("Label"):GetComponent(UILabel)
  self.slider = self:FindGO("ExpSlider"):GetComponent(UISlider)
  self.sliderBg = self:FindGO("ExpSlider"):GetComponent(UISprite)
  self.sliderForeground = self:FindGO("Foreground"):GetComponent(GradientUISprite)
  self.sliderForeground2 = self:FindGO("Foreground2"):GetComponent(UISprite)
  self.bg = self:FindGO("Bg"):GetComponent(UIMultiSprite)
  self.bgInvalid = self:FindGO("InvalidIcon"):GetComponent(UIMultiSprite)
  self.bgMask = self:FindGO("BgMask")
  self.value = self:FindGO("Value"):GetComponent(UILabel)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.chooseSymbol:SetActive(false)
  self.targetSymbol = self:FindGO("TargetSymbol")
  self.targetSymbol:SetActive(false)
  self.redtip = self:FindGO("RecvSymbol")
  self.redtip:SetActive(false)
  self:AddCellClickEvent()
end

function KnightPrestigeLevelCell:SetData(data)
  self.data = data
end

function KnightPrestigeLevelCell:SetStatus(status, value)
  self.targetSymbol:SetActive(false)
  if status == 1 then
    self.bg.gameObject:SetActive(true)
    self.bgInvalid.gameObject:SetActive(false)
    self.bgMask:SetActive(true)
    self.label.color = LuaGeometry.GetTempVector4(0.9921568627450981, 0.996078431372549, 0.7843137254901961, 1)
  elseif status == 2 then
    self.bg.gameObject:SetActive(true)
    self.bgInvalid.gameObject:SetActive(false)
    self.bgMask:SetActive(false)
    self.label.color = LuaGeometry.GetTempVector4(0.9921568627450981, 0.996078431372549, 0.7843137254901961, 1)
  elseif status == 3 then
    self.bg.gameObject:SetActive(false)
    self.bgInvalid.gameObject:SetActive(true)
    self.bgMask:SetActive(false)
    self.label.color = LuaColor.White()
    self.label.effectColor = LuaGeometry.GetTempVector4(0.5803921568627451, 0.5803921568627451, 0.5803921568627451, 1)
  end
end

function KnightPrestigeLevelCell:SetVersion(version)
  self.label.effectColor = _PrestigeOutlineColor[version]
  self.bg.CurrentState = version - 1
  self.bgInvalid.CurrentState = version - 1
  self.bg.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.8, 0.8, 0.8)
  self.bgInvalid.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.8, 0.8, 0.8)
end

function KnightPrestigeLevelCell:SetLevelText(level, value)
  local level = level or 0
  self.level = level
  self.label.text = level
  self.value.text = value
end

function KnightPrestigeLevelCell:SetTargetSymbol(bool)
  if self.level == 1 then
    self.targetSymbol:SetActive(false)
  else
    self.targetSymbol:SetActive(bool)
  end
end

function KnightPrestigeLevelCell:ActiveSlider(bool)
  self.slider.gameObject:SetActive(bool)
end

function KnightPrestigeLevelCell:SetChooseStatus(bool)
  self.chooseSymbol:SetActive(bool)
end

function KnightPrestigeLevelCell:SetSliderLength(type)
  if type == 1 then
    self.sliderBg.width = 38
    self.sliderForeground.width = 38
    self.sliderForeground2.width = 38
  else
    self.sliderBg.width = 122
    self.sliderForeground.width = 122
    self.sliderForeground2.width = 122
  end
end

function KnightPrestigeLevelCell:SetSliderColor(curLv, maxLv, topColor, bottomColor)
  local startPer = (curLv - 1) / maxLv
  local endPer = curLv / maxLv
  local topColorTable = {}
  local endColorTable = {}
  for i = 1, 3 do
    topColorTable[i] = topColor[i] + startPer * (bottomColor[i] - topColor[i])
    endColorTable[i] = topColor[i] + endPer * (bottomColor[i] - topColor[i])
  end
  self.sliderForeground.gradientTop = LuaGeometry.GetTempVector4(topColorTable[1] / 255, topColorTable[2] / 255, topColorTable[3] / 255, 1)
  self.sliderForeground.gradientBottom = LuaGeometry.GetTempVector4(endColorTable[1] / 255, endColorTable[2] / 255, endColorTable[3] / 255, 1)
end

function KnightPrestigeLevelCell:SetRedTip(bool)
  self.redtip:SetActive(bool)
end
