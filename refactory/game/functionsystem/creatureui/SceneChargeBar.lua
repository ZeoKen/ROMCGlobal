SceneChargeBar = reusableClass("SceneChargeBar")
SceneChargeBar.PoolSize = 2
SceneChargeBar.ChargeState = {
  Maintain = 0,
  Increase = 1,
  Reduce = 2
}
local PATH_PFB = "part/ChargeBar"
local TICK_ID = 1226
local _gameUtilInstance = GameObjectUtil.Instance
local func_deepFind = _gameUtilInstance.DeepFind
local ClampValue = function(value, maxValue)
  value = value or 0
  maxValue = maxValue or 1
  if maxValue == 0 then
    maxValue = 1
  end
  return math.clamp(value, 0, maxValue), maxValue
end
local FindFirstGO = function(root, names)
  for i = 1, #names do
    local go = func_deepFind(_gameUtilInstance, root, names[i])
    if go then
      return go
    end
  end
  return nil
end
local GetRectWidth = function(rect)
  if not rect then
    return 0
  end
  local width = rect.rect.width
  if width <= 0 then
    width = rect.sizeDelta.x
  end
  return width
end

function SceneChargeBar:GetSplitPartWidth()
  return GetRectWidth(self.splitRect)
end

function SceneChargeBar:GetImageLightWidth()
  return GetRectWidth(self.chargeImgRect)
end

function SceneChargeBar:GetSegmentCount()
  return self.segmentCount or 1
end

function SceneChargeBar:LayoutSplitLines()
  if not self.imageLineElements then
    return
  end
  local splitWidth = self:GetSplitPartWidth()
  if splitWidth <= 0 then
    return
  end
  local segmentWidth = splitWidth / self:GetSegmentCount()
  for i = 1, #self.imageLineElements do
    local line = self.imageLineElements[i]
    if line and not LuaGameObject.ObjectIsNull(line) then
      local lineRect = line:GetComponent(RectTransform)
      if lineRect then
        local pivot = lineRect.pivot
        lineRect.pivot = LuaGeometry.GetTempVector2(0, pivot.y)
        lineRect.anchoredPosition = LuaGeometry.GetTempVector2(segmentWidth * i, 0)
      end
      line:SetActive(true)
    end
  end
end

function SceneChargeBar:InitSplitLines()
  self.imageLineElements = {}
  self.imageLineTemplate = nil
  self.splitPart = func_deepFind(_gameUtilInstance, self.gameObject, "SplitPart")
  if not self.splitPart then
    return
  end
  self.splitRect = self.splitPart:GetComponent(RectTransform)
  self.imageLineTemplate = func_deepFind(_gameUtilInstance, self.splitPart, "ImageLine")
  if not self.imageLineTemplate then
    return
  end
  self.imageLineTemplate:SetActive(false)
  for i = 1, math.max(self:GetSegmentCount() - 1, 0) do
    local line = GameObject.Instantiate(self.imageLineTemplate)
    line.transform:SetParent(self.splitPart.transform, false)
    self.imageLineElements[i] = line
  end
  self:LayoutSplitLines()
end

function SceneChargeBar:ClearSplitLines()
  if self.imageLineElements then
    for i = 1, #self.imageLineElements do
      local line = self.imageLineElements[i]
      if line and not LuaGameObject.ObjectIsNull(line) then
        LuaGameObject.DestroyObject(line)
      end
    end
  end
  self.imageLineElements = nil
  self.imageLineTemplate = nil
  self.splitPart = nil
  self.splitRect = nil
end

function SceneChargeBar:InitChargeFill()
  if not self.chargeImg then
    return
  end
  self.chargeImg.type = Image.Type.Filled
  self.chargeImg.fillMethod = Image.FillMethod.Horizontal
  self.chargeImg.fillOrigin = 0
  self.chargeImg.fillAmount = 0
end

function SceneChargeBar:GetFillAmountForLine(lineIndex)
  local splitWidth = self:GetSplitPartWidth()
  local lightWidth = self:GetImageLightWidth()
  if not (not (splitWidth <= 0) and not (lightWidth <= 0) and self.splitRect) or not self.chargeImgRect then
    return 0
  end
  if lineIndex <= 0 then
    return 0
  end
  local segmentCount = self:GetSegmentCount()
  if lineIndex >= segmentCount then
    return 1
  end
  local lineX = splitWidth / segmentCount * lineIndex
  local splitLeftX = -splitWidth * self.splitRect.pivot.x
  local worldPos = self.splitRect:TransformPoint(LuaGeometry.GetTempVector3(splitLeftX + lineX, 0, 0))
  local localPos = self.chargeImgRect:InverseTransformPoint(worldPos)
  local lightRect = self.chargeImgRect.rect
  return math.clamp((localPos.x - lightRect.xMin) / lightWidth, 0, 1)
end

function SceneChargeBar:UpdateChargeFill(value, maxValue)
  if not self.chargeImg then
    return
  end
  value = value or 0
  maxValue = maxValue or self.maxValue or 1
  if maxValue <= 0 then
    maxValue = 1
  end
  local ratio = math.clamp(value / maxValue, 0, 1)
  local completedCount = math.floor(ratio * self:GetSegmentCount())
  self.chargeImg.fillAmount = self:GetFillAmountForLine(completedCount)
end

function SceneChargeBar:DoConstruct(asArray, args)
  local parent = args[1]
  local config = args[2] or {}
  if LuaGameObject.ObjectIsNull(parent) then
    return
  end
  self.gameObject = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIV1(PATH_PFB), parent.transform)
  if LuaGameObject.ObjectIsNull(self.gameObject) then
    return
  end
  self.gameObject.name = "ExtraBar_Charge"
  local chargeSlider = FindFirstGO(self.gameObject, {
    "ChargeSlider",
    "ExtraSlider"
  })
  self.chargeSlider = chargeSlider and chargeSlider:GetComponent(Slider)
  self.chargeBG = FindFirstGO(self.gameObject, {"ChargeBG", "SpBG"})
  local chargeImg = FindFirstGO(self.gameObject, {"ChargeImg", "ImageLight"})
  self.chargeImg = chargeImg and chargeImg:GetComponent(Image)
  self.chargeImgRect = self.chargeImg and self.chargeImg.rectTransform
  self.blink = FindFirstGO(self.gameObject, {"Blink", "SpBlink"})
  self:InitChargeFill()
  self.curValue = 0
  self.maxValue = config.MaxValue or 1
  self.interval = config.Interval or 0
  self.segmentCount = math.max(math.floor(tonumber(config.Segment) or 1), 1)
  self:InitSplitLines()
  self.chargeSpd = 0
  self.reduceSpd = 0
  self.chargeState = SceneChargeBar.ChargeState.Maintain
  self:SetBlinkActive(false)
  self:SetVisible(true)
  self:SetCharge(0, self.maxValue)
end

function SceneChargeBar:ClearChargeTick()
  if self.chargeTick then
    TimeTickManager.Me():ClearTick(self, TICK_ID)
    self.chargeTick = nil
  end
end

function SceneChargeBar:SetBlinkActive(active)
  if self.blink then
    self.blink:SetActive(active == true)
  end
end

function SceneChargeBar:SetVisible(visible)
  if LuaGameObject.ObjectIsNull(self.gameObject) then
    return
  end
  self.gameObject:SetActive(visible ~= false)
end

function SceneChargeBar:IsVisible()
  if LuaGameObject.ObjectIsNull(self.gameObject) then
    return false
  end
  return self.gameObject.activeSelf
end

function SceneChargeBar:SetCharge(value, maxValue)
  self:ClearChargeTick()
  maxValue = maxValue or self.maxValue
  self.curValue, self.maxValue = ClampValue(value, maxValue)
  if self.chargeSlider then
    self.chargeSlider.value = math.clamp(self.curValue / self.maxValue, 0, 1)
  end
  self:UpdateChargeFill(self.curValue, self.maxValue)
end

function SceneChargeBar:SetChargeState(value, maxValue, state, chargeSpd, reduceSpd)
  maxValue = maxValue or self.maxValue
  chargeSpd = chargeSpd or self.chargeSpd
  reduceSpd = reduceSpd or self.reduceSpd
  state = state or self.chargeState
  if state ~= SceneChargeBar.ChargeState.Increase and state ~= SceneChargeBar.ChargeState.Reduce and state ~= SceneChargeBar.ChargeState.Maintain then
    state = SceneChargeBar.ChargeState.Maintain
  end
  self.chargeState = state
  local speed = 0
  if state == SceneChargeBar.ChargeState.Increase then
    speed = chargeSpd or 0
  elseif state == SceneChargeBar.ChargeState.Reduce then
    speed = -(reduceSpd or 0)
  end
  self:SetChargeSpeed(value, maxValue, speed)
end

function SceneChargeBar:SetChargeSpeed(value, maxValue, delta)
  if value == nil then
    value = self.curValue
  end
  if maxValue == nil then
    maxValue = self.maxValue
  end
  self:SetCharge(value, maxValue)
  delta = delta or 0
  local interval = self.interval or 0
  if delta == 0 or interval <= 0 then
    return
  end
  local speedPerSecond = delta / interval
  self.chargeTick = TimeTickManager.Me():CreateTick(0, 33, function(owner, deltaTime)
    owner.curValue = math.clamp(owner.curValue + speedPerSecond * deltaTime / 1000, 0, owner.maxValue)
    if owner.chargeSlider then
      owner.chargeSlider.value = math.clamp(owner.curValue / owner.maxValue, 0, 1)
    end
    owner:UpdateChargeFill(owner.curValue, owner.maxValue)
    if owner.curValue <= 0 or owner.curValue >= owner.maxValue then
      owner:ClearChargeTick()
    end
  end, self, TICK_ID)
end

function SceneChargeBar:StopCharge()
  self:ClearChargeTick()
end

function SceneChargeBar:DoDeconstruct(asArray)
  self:ClearChargeTick()
  self:ClearSplitLines()
  if not LuaGameObject.ObjectIsNull(self.gameObject) then
    Game.GOLuaPoolManager:AddToSceneUIPool(PATH_PFB, self.gameObject)
  end
  self.gameObject = nil
  self.chargeSlider = nil
  self.chargeBG = nil
  self.chargeImg = nil
  self.chargeImgRect = nil
  self.blink = nil
  self.curValue = nil
  self.maxValue = nil
  self.interval = nil
  self.segmentCount = nil
  self.chargeSpd = nil
  self.reduceSpd = nil
  self.chargeState = nil
end
