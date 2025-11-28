SceneSolarEnergy = reusableClass("SceneSolarEnergy")
SceneFeatherGrid.PoolSize = 2
local PATH_PFB = "part/SolarEnergyBar"
local _gameUtilInstance = GameObjectUtil.Instance
local func_deepFind = _gameUtilInstance.DeepFind

function SceneSolarEnergy:DoConstruct(asArray, args)
  local parent = args[1]
  if not LuaGameObject.ObjectIsNull(parent) then
    self.gameObject = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIV1(PATH_PFB), parent.transform)
    self.solarEnergySlider = func_deepFind(_gameUtilInstance, self.gameObject, "SolarEnergySlider"):GetComponent(Slider)
    self.solarEnergyLayer = func_deepFind(_gameUtilInstance, self.gameObject, "SolarEnergyLayer"):GetComponent(Text)
    self.solarEnergy = func_deepFind(_gameUtilInstance, self.gameObject, "SolarEnergy")
    self.solarEnergyLayer.text = 0
    self.solarEnergySlider.value = 0
  end
end

function SceneSolarEnergy:UpdateSolarEnergy(bufflayer, maxlayer)
  local layer = bufflayer or 0
  self.solarEnergyLayer.text = layer
  if layer == 0 then
    self.solarEnergy.gameObject:SetActive(false)
  else
    if not self.solarEnergy.gameObject.activeSelf then
      self.solarEnergy.gameObject:SetActive(true)
    end
    self.solarEnergySlider.value = layer / (maxlayer ~= 0 and maxlayer or 1)
  end
end

function SceneSolarEnergy:DoDeconstruct(asArray)
  if not LuaGameObject.ObjectIsNull(self.gameObject) then
    Game.GOLuaPoolManager:AddToSceneUIPool(PATH_PFB, self.gameObject)
  end
  self.gameObject = nil
  self.solarEnergyLayer = nil
  self.solarEnergySlider = nil
end
