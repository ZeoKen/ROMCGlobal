PrestigeExpTip = class("PrestigeExpTip", CoreView)
PrestigeExpTip.resID = ResourcePathHelper.UITip("PrestigeExpTip")
local _PrestigeOutlineColor = {
  [1] = LuaColor.New(0.8, 0.2549019607843137, 0.24705882352941178, 1),
  [2] = LuaColor.New(0.7568627450980392, 0.17647058823529413, 0.4470588235294118, 1),
  [3] = LuaColor.New(0.3411764705882353, 0.6509803921568628, 0.5725490196078431, 1),
  [4] = LuaColor.New(0.8431372549019608, 0.5490196078431373, 0.3215686274509804, 1),
  [5] = LuaColor.New(0.41568627450980394, 0.41568627450980394, 0.41568627450980394, 1),
  [6] = LuaColor.New(0.7647058823529411, 0.27058823529411763, 0.6431372549019608, 1)
}

function PrestigeExpTip:ctor(parent)
  self.gameObject = self:CreateObj(parent)
  self:Init()
end

function PrestigeExpTip:CreateObj(parent)
  return Game.AssetManager_UI:CreateAsset(PrestigeExpTip.resID, parent)
end

function PrestigeExpTip:Init()
  self.root = self:FindGO("Root", self.gameObject)
  self.tweenAlpha = self.root:GetComponent(TweenAlpha)
  self.slider = self:FindGO("Slider", self.gameObject):GetComponent(UISlider)
  self.prestigeValue = self:FindGO("PrestigeValue", self.gameObject):GetComponent(UILabel)
  self.deltaValue = self:FindGO("DeltaValue", self.gameObject):GetComponent(UILabel)
  self.prestigeBg = self:FindGO("PrestigeBg", self.gameObject):GetComponent(UIMultiSprite)
  self.prestigeLevel = self:FindGO("PrestigeLevel", self.gameObject):GetComponent(UILabel)
  self.prestigeNoLevel = self:FindGO("PrestigeNoLevel", self.gameObject):GetComponent(UIMultiSprite)
  self.effectContainer = self:FindGO("EffectContainer")
  self.effectLabel = self:FindGO("EffectLabel", self.effectContainer):GetComponent(UILabel)
  self.effectLabel_TweenScale = self.effectLabel:GetComponent(TweenScale)
  self.effectLabel_TweenAlpha = self.effectLabel:GetComponent(TweenAlpha)
  self.foreShine = self:FindGO("ForeShine", self.gameObject)
  self.foreShine_TweenAlpha = self.foreShine:GetComponent(TweenAlpha)
  self.foreShine:SetActive(false)
end

function PrestigeExpTip:ResetView()
  self.root:SetActive(true)
  self.tweenAlpha:ResetToBeginning()
  self.tweenAlpha.enabled = false
  self.effectLabel.text = ""
  self.effectLabel.alpha = 1
  self.foreShine:SetActive(false)
  self.slider.value = 0
end

function PrestigeExpTip:ShowInfo(data)
  TimeTickManager.Me():ClearTick(self)
  self:ResetView()
  local version = data.type
  self.version = version or 1
  local staticPrestigeInfo = VersionPrestigeProxy.Instance:GetStaticPrestigeInfo(version)
  local prestigeValue = staticPrestigeInfo and staticPrestigeInfo.PrestigeValue
  local previousLevel = data.origin_level
  local curLevel = data.new_level
  local previousValue = data.origin_value
  local curValue = data.new_value
  self.effectLabel.effectColor = _PrestigeOutlineColor[version]
  self.prestigeLevel.effectColor = _PrestigeOutlineColor[version]
  if previousValue == 0 and curValue == 0 and previousLevel < curLevel then
    self.root:SetActive(false)
    self:PlayLevelUp(curLevel)
    return
  end
  xdlog(string.format("PrestigeExpTip:ShowInfo  type:%s, origin_level:%s, new_level:%s, origin_value:%s, new_value:%s", version, previousLevel, curLevel, previousValue, curValue))
  local titleConfig = GameConfig.Prestige and GameConfig.Prestige.PrestigeTitle
  local prestigeName = titleConfig and titleConfig[version] and titleConfig[version].prestige_name or "???"
  self.prestigeValue.text = string.format("%s:%s", prestigeName, previousValue)
  self.prestigeLevel.text = previousLevel
  self.deltaValue.text = "+" .. curValue - previousValue
  if previousLevel == 0 then
    self.prestigeNoLevel.gameObject:SetActive(true)
    self.prestigeBg.gameObject:SetActive(false)
    self.prestigeNoLevel.CurrentState = version - 1
    self.prestigeLevel.text = ""
  else
    self.prestigeNoLevel.gameObject:SetActive(false)
    self.prestigeBg.gameObject:SetActive(true)
    self.prestigeBg.CurrentState = version - 1
  end
  self:SetLevel(previousLevel, version)
  local basePrestige, targetPrestige
  if previousLevel == 0 then
    local index = VersionPrestigeProxy.Instance:ParseLevelToIndex(version, 1)
    basePrestige = 0
    targetPrestige = prestigeValue and prestigeValue[index]
  else
    local index = VersionPrestigeProxy.Instance:ParseLevelToIndex(version, previousLevel)
    basePrestige = prestigeValue and prestigeValue[index] or 0
    targetPrestige = prestigeValue and prestigeValue[index + 1]
  end
  local levelUp = previousLevel ~= curLevel
  if levelUp then
    local startPer = (previousValue - basePrestige) / (targetPrestige - basePrestige)
    self.slider.value = startPer
    local endPer = 1
    self:PlayUISound(AudioMap.UI.Prestige_Progress)
    TimeTickManager.Me():CreateTickFromTo(0, startPer, endPer, 1500, function(owner, deltaTime, curValue)
      self.slider.value = curValue
    end, self, 1)
    local startPer2 = 0
    TimeTickManager.Me():CreateOnceDelayTick(1800, function()
      self.tweenAlpha:PlayForward()
      self:PlayLevelUp(curLevel)
    end, self, 4)
    TimeTickManager.Me():CreateOnceDelayTick(1500, function()
      self.foreShine:SetActive(true)
      self.foreShine_TweenAlpha:ResetToBeginning()
      self.foreShine_TweenAlpha:PlayForward()
    end, self, 3)
    local startValue = previousValue - basePrestige
    local targetValue = targetPrestige - basePrestige
    TimeTickManager.Me():CreateTickFromTo(0, startValue, targetValue, 1500, function(owner, deltaTime, curValue)
      local maxValue = targetValue
      self.prestigeValue.text = string.format("%s:%s/%s", prestigeName, math.floor(curValue), maxValue)
    end, self, 2)
    if curValue > targetPrestige then
      do
        local index = VersionPrestigeProxy.Instance:ParseLevelToIndex(version, curLevel + 1)
        local nextPrestigeValue = prestigeValue and prestigeValue[index]
        local pre_index = VersionPrestigeProxy.Instance:ParseLevelToIndex(version, curLevel)
        local pre_prestigeValue = prestigeValue and prestigeValue[pre_index]
        if index and nextPrestigeValue then
          do
            local endPer2 = (curValue - pre_prestigeValue) / (nextPrestigeValue - pre_prestigeValue)
            TimeTickManager.Me():CreateOnceDelayTick(4000, function()
              self:PlayUISound(AudioMap.UI.Prestige_Progress)
              self:ResetView()
              self.prestigeLevel.text = curLevel
              TimeTickManager.Me():CreateTickFromTo(0, 0, endPer2, 1000, function(owner, deltaTime, curValue)
                self.slider.value = curValue
              end, self, 1)
              local startValue2 = 0
              local targetValue2 = curValue - pre_prestigeValue
              local maxValue2 = nextPrestigeValue - pre_prestigeValue
              TimeTickManager.Me():CreateTickFromTo(0, startValue2, targetValue2, 1000, function(owner, deltaTime, curValue)
                self.prestigeValue.text = string.format("%s:%s/%s", prestigeName, math.floor(curValue), maxValue2)
              end, self, 2)
            end, self, 5)
            TimeTickManager.Me():CreateOnceDelayTick(5500, function()
              self.tweenAlpha:PlayForward()
            end, self, 6)
          end
        end
      end
    end
  else
    self:PlayUISound(AudioMap.UI.Prestige_Progress)
    local startPer = (previousValue - basePrestige) / (targetPrestige - basePrestige)
    self.slider.value = startPer
    local endPer = (curValue - basePrestige) / (targetPrestige - basePrestige)
    TimeTickManager.Me():CreateTickFromTo(0, startPer, endPer, 1500, function(owner, deltaTime, curValue)
      self.slider.value = curValue
    end, self, 1)
    local startValue = previousValue - basePrestige
    local targetValue = curValue - basePrestige
    TimeTickManager.Me():CreateTickFromTo(0, startValue, targetValue, 1500, function(owner, deltaTime, curValue)
      local maxValue = targetPrestige - basePrestige
      self.prestigeValue.text = string.format("%s:%s/%s", prestigeName, math.floor(curValue), maxValue)
    end, self, 2)
    TimeTickManager.Me():CreateOnceDelayTick(2250, function()
      self.tweenAlpha:PlayForward()
    end, self, 5)
  end
end

function PrestigeExpTip:SetLevel(level, version)
  if level == 0 then
    self.prestigeNoLevel.gameObject:SetActive(true)
    self.prestigeBg.gameObject:SetActive(false)
    self.prestigeNoLevel.CurrentState = version - 1
    self.prestigeLevel.text = ""
    self.prestigeNoLevel:MakePixelPerfect()
  else
    self.prestigeNoLevel.gameObject:SetActive(false)
    self.prestigeBg.gameObject:SetActive(true)
    self.prestigeBg.CurrentState = version - 1
    self.prestigeBg:MakePixelPerfect()
    self.prestigeLevel.text = level
  end
end

function PrestigeExpTip:PlayLevelUp(level)
  self.effectLabel.text = level
  self.effectLabel_TweenScale:ResetToBeginning()
  self.effectLabel_TweenScale:PlayForward()
  self.effectLabel_TweenAlpha:ResetToBeginning()
  self.effectLabel_TweenAlpha:PlayForward()
  xdlog("Str", "Prestige_LevelUp" .. (self.version == 1 and "" or self.version))
  self:PlayUIEffect(EffectMap.UI["Prestige_LevelUp" .. (self.version ~= 1 and self.version or "")], self.effectContainer)
  self:PlayUISound(AudioMap.UI.Prestige_LevelUp)
end

function PrestigeExpTip:DestroySelf()
  TimeTickManager.Me():ClearTick(self)
  if self.gameObject ~= nil then
    GameObject.Destroy(self.gameObject)
  end
  self.gameObject = nil
end
