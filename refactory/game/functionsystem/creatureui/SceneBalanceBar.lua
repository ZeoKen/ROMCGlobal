SceneBalanceBar = reusableClass("SceneBalanceBar")
SceneBalanceBar.PoolSize = 2
local PATH_PFB = "part/SceneBottomHpSpCell_Resistance"
local _gameUtilInstance = GameObjectUtil.Instance
local func_deepFind = _gameUtilInstance.DeepFind

function SceneBalanceBar:DoConstruct(asArray, args)
  local parent = args[1]
  if not LuaGameObject.ObjectIsNull(parent) then
    self.gameObject = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIV1(PATH_PFB), parent.transform)
    self.uiSliderResistance = func_deepFind(_gameUtilInstance, self.gameObject, "ResistanceSlider"):GetComponent(Slider)
    self.uiSliderFg = func_deepFind(_gameUtilInstance, self.gameObject, "Sp"):GetComponent(Image)
    self.uiSliderFgBlink = func_deepFind(_gameUtilInstance, self.gameObject, "SpBlink")
    self.uiResistanceHandle = func_deepFind(_gameUtilInstance, self.gameObject, "Handle")
    self.uiSliderResistance.value = 0
  end
end

function SceneBalanceBar:ClearBalanceTick()
  if self.balanceTick then
    TimeTickManager.Me():ClearTick(self, 1225)
    self.balanceTick = nil
  end
end

function SceneBalanceBar:SetBalance(ncreature)
  if not self.uiSliderResistance then
    return
  end
  if not self.BalanceConfig then
    self.BalanceConfig = ncreature.data:GetBalanceConfig()
  end
  if not self.BalanceConfig then
    return
  end
  self.MaxResistanceVal = self.BalanceConfig.MaxValue
  local value, speed = ncreature.data:GetBalanceValue()
  if not value or not speed then
    self:ClearBalanceTick()
    return
  end
  value = value / 1000
  self.uiSliderResistance.value = math.clamp(value / self.MaxResistanceVal, 0, 1)
  if speed < 0 or value >= self.MaxResistanceVal then
    SpriteManager.SetUISprite("sceneuicom", "mowu_line_bg3", self.uiSliderFg)
    self.uiSliderFgBlink:SetActive(true)
  else
    SpriteManager.SetUISprite("sceneuicom", "com_bg_hp_3s", self.uiSliderFg)
    self.uiSliderFgBlink:SetActive(false)
  end
  self.uiResistanceHandle:SetActive(value < self.MaxResistanceVal)
  if speed ~= 0 then
    if value >= self.MaxResistanceVal and 0 < speed or value <= 0 and speed < 0 then
      self:ClearBalanceTick()
    else
      self.balanceTick = TimeTickManager.Me():CreateTick(0, 33, function(owner, deltaTime)
        value, speed = ncreature.data:GetBalanceValue()
        value = value / 1000
        self.uiSliderResistance.value = math.clamp(value / self.MaxResistanceVal, 0, 1)
        if value >= self.MaxResistanceVal and 0 < speed or value <= 0 and speed < 0 then
          self:ClearBalanceTick()
          if value <= 0 and speed < 0 then
            self.uiResistanceHandle:SetActive(true)
            self.uiSliderFgBlink:SetActive(false)
          end
          if value >= self.MaxResistanceVal then
            SpriteManager.SetUISprite("sceneuicom", "mowu_line_bg3", self.uiSliderFg)
            self.uiResistanceHandle:SetActive(false)
            self.uiSliderFgBlink:SetActive(true)
          end
        end
      end, self, 1225)
    end
  else
    self:ClearBalanceTick()
  end
end

function SceneBalanceBar:ResetBalance()
  self:ClearBalanceTick()
  if not LuaGameObject.ObjectIsNull(self.gameObject) then
    Game.GOLuaPoolManager:AddToSceneUIPool(PATH_PFB, self.gameObject)
  end
  if self.gameObject then
    LuaGameObject.DestroyObject(self.gameObject)
    self.gameObject = nil
    self.uiSliderResistance = nil
    self.uiSliderFg = nil
    self.uiSliderFgBlink = nil
    self.uiResistanceHandle = nil
  end
  self.MaxResistanceVal = nil
  self.BalanceConfig = nil
end

function SceneBalanceBar:DoDeconstruct(asArray)
  self:ResetBalance()
end
