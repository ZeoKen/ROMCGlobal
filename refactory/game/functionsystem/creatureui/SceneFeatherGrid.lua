SceneFeatherGrid = reusableClass("SceneFeatherGrid")
SceneFeatherGrid.PoolSize = 2
local PATH_PFB = "part/FeatherGrid"
local _gameUtilInstance = GameObjectUtil.Instance
local func_deepFind = _gameUtilInstance.DeepFind

function SceneFeatherGrid:DoConstruct(asArray, args)
  local parent = args[1]
  if not LuaGameObject.ObjectIsNull(parent) then
    self.gameObject = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIV1(PATH_PFB), parent.transform)
    self.stars = {}
    for i = 1, 4 do
      local go = func_deepFind(_gameUtilInstance, self.gameObject, "grid" .. i)
      self.stars[i] = go
      self.stars[i]:SetActive(false)
    end
  end
end

function SceneFeatherGrid:UpdateFeather(bufflayer)
  if self.stars then
    for i = 1, bufflayer do
      self.stars[i]:SetActive(true)
    end
    if bufflayer <= 4 then
      for i = bufflayer + 1, 4 do
        self.stars[i]:SetActive(false)
      end
    end
  end
end

function SceneFeatherGrid:DoDeconstruct(asArray)
  if not LuaGameObject.ObjectIsNull(self.gameObject) then
    Game.GOLuaPoolManager:AddToSceneUIPool(PATH_PFB, self.gameObject)
  end
  self.gameObject = nil
  for i = #self.stars, 1, -1 do
    self.stars[i] = nil
  end
end
