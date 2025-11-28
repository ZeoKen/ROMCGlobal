SceneEnergyGrid = reusableClass("SceneEnergyGrid")
SceneEnergyGrid.PoolSize = 2
local PATH_PFB = "part/EnergyGrid"
local _gameUtilInstance = GameObjectUtil.Instance
local func_deepFind = _gameUtilInstance.DeepFind

function SceneEnergyGrid:DoConstruct(asArray, args)
  local parent = args[1]
  if not LuaGameObject.ObjectIsNull(parent) then
    self.gameObject = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIV1(PATH_PFB), parent.transform)
    self.stars = {}
    for i = 1, 10 do
      local go = func_deepFind(_gameUtilInstance, self.gameObject, "layer" .. i)
      self.stars[i] = go
      self.stars[i]:SetActive(false)
    end
    local path = ResourcePathHelper.EffectUI(EffectMap.UI.FullEngergyEffect)
    self.fullEffectGO = Game.AssetManager_UI:CreateSceneUIAsset(path, self.gameObject)
    if self.fullEffectGO then
      self.fullEffectGO:SetActive(false)
      self.fullEffectGO.transform.localPosition = LuaGeometry.GetTempVector3(-41.6, -0.1, -0.9)
      self.fullEffectGO.transform.localRotation = LuaGeometry.Const_Qua_identity
      self.fullEffectGO.transform.localScale = LuaGeometry.Const_V3_one
    end
  end
end

function SceneEnergyGrid:UpdateEnergy(bufflayer)
  if self.stars then
    for i = 1, bufflayer do
      self.stars[i]:SetActive(true)
    end
    if bufflayer <= 10 then
      for i = bufflayer + 1, 10 do
        self.stars[i]:SetActive(false)
      end
    end
    if 10 <= bufflayer and self.fullEffectGO then
      self.fullEffectGO:SetActive(true)
    end
  end
end

function SceneEnergyGrid:DoDeconstruct(asArray)
  if self.fullEffectGO and not LuaGameObject.ObjectIsNull(self.fullEffectGO) then
    GameObject.Destroy(self.fullEffectGO)
    self.fullEffectGO = nil
  end
  if not LuaGameObject.ObjectIsNull(self.gameObject) then
    Game.GOLuaPoolManager:AddToSceneUIPool(PATH_PFB, self.gameObject)
  end
  self.gameObject = nil
  for i = #self.stars, 1, -1 do
    self.stars[i] = nil
  end
end
