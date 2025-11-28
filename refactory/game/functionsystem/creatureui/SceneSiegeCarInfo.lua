SceneSiegeCarInfo = reusableClass("SceneSiegeCarInfo")
SceneSiegeCarInfo.PoolSize = 2
local PATH_PFB = ResourcePathHelper.UIPrefab_Cell("SceneSiegeCarInfo")
local playerSymbol = "12pvp_bg_12"
local defaultSymbol = "persona_bg_hair1"
local _gameUtilInstance = GameObjectUtil.Instance
local func_deepFind = _gameUtilInstance.DeepFind
local MaxSpdAddition = GameConfig.TwelvePvp.SiegeCar.MaxSpdAddition
local ReverseV3 = LuaVector3(0, 0, -180)

function SceneSiegeCarInfo:UpdateCarPoint(speed)
  if _gameUtilInstance:ObjectIsNULL(self.siegeCarSpeed) then
    return
  end
  if 0 < speed then
    self.siegeCarSpeed.value = speed / MaxSpdAddition
    for i = 1, 2 do
      self.arrows[i].transform.localRotation.eulerAngles = LuaGeometry.GetTempVector3(0, 0, 0)
    end
  else
    self.siegeCarSpeed.value = 0
    for i = 1, 2 do
      self.arrows[i].transform.localRotation.eulerAngles = ReverseV3
    end
  end
end

function SceneSiegeCarInfo:UpdatePushNum(count)
  for i = 1, 4 do
    if i <= count then
      SpriteManager.SetUISprite("sceneui", playerSymbol, self.counts[i])
    else
      SpriteManager.SetUISprite("sceneui", defaultSymbol, self.counts[i])
    end
  end
end

function SceneSiegeCarInfo:DoConstruct(asArray, args)
  local parent = args[1]
  if not LuaGameObject.ObjectIsNull(parent) then
    self.gameObject = Game.AssetManager_UI:CreateSceneUIAsset(PATH_PFB, parent.transform)
    self.gameObject.transform.localPosition = LuaGeometry.Const_V3_zero
    self.gameObject.transform.localRotation = LuaGeometry.Const_Qua_identity
    self.gameObject.transform.localScale = LuaGeometry.Const_V3_one
    self.siegeCarSpeed = func_deepFind(_gameUtilInstance, self.gameObject, "siegeCarInfo"):GetComponent(Slider)
    self.counts = {}
    for i = 1, 4 do
      self.counts[i] = func_deepFind(_gameUtilInstance, self.gameObject, "count" .. i):GetComponent(Image)
      SpriteManager.SetUISprite("sceneui", defaultSymbol, self.counts[i])
    end
    self.arrows = {}
    for i = 1, 2 do
      self.arrows[i] = func_deepFind(_gameUtilInstance, self.gameObject, "arrow" .. i)
    end
  end
end

function SceneSiegeCarInfo:DoDeconstruct(asArray)
  if not LuaGameObject.ObjectIsNull(self.gameObject) then
    Game.GOLuaPoolManager:AddToSceneUIPool(PATH_PFB, self.gameObject)
  end
  self.gameObject = nil
  self.counts = nil
  self.arrows = nil
  self.siegeCarSpeed = nil
end
