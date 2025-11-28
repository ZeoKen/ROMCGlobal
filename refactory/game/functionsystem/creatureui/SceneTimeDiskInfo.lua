SceneTimeDiskInfo = reusableClass("SceneTimeDiskInfo")
SceneTimeDiskInfo.PoolSize = 2
local PATH_PFB = "part/TimeDiskBar"
local _gameUtilInstance = GameObjectUtil.Instance
local func_deepFind = _gameUtilInstance.DeepFind
local tempV3 = LuaVector3()
local StartPosX = 8
local EndPosX = 108
local DeltaX = EndPosX - StartPosX
local backPosX = 77
local HighlightMap = {
  [1] = 1,
  [2] = 2,
  [3] = 3,
  [4] = 2,
  [5] = 1
}

function SceneTimeDiskInfo:DoConstruct(asArray, args)
  local parent = args[1]
  if not LuaGameObject.ObjectIsNull(parent) then
    self.gameObject = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIV1(PATH_PFB), parent.transform)
    self.sunRoot = func_deepFind(_gameUtilInstance, self.gameObject, "SunSlider")
    self.sun = func_deepFind(_gameUtilInstance, self.gameObject, "Sun")
    self.moon = func_deepFind(_gameUtilInstance, self.gameObject, "Moon")
    self.moonRoot = func_deepFind(_gameUtilInstance, self.gameObject, "MoonSlider")
    self.sunGrid, self.moonGrid = {}, {}
    for i = 1, 3 do
      local go = func_deepFind(_gameUtilInstance, self.sunRoot, "grid" .. i)
      self.sunGrid[i] = go
      go:SetActive(false)
      go = func_deepFind(_gameUtilInstance, self.moonRoot, "grid" .. i)
      self.moonGrid[i] = go
      go:SetActive(false)
    end
    local isSun = args[2]
    self.sunRoot:SetActive(isSun == true)
    self.moonRoot:SetActive(isSun ~= true)
  end
end

local curHighlight, delta, tempX = 0, 0, 0

function SceneTimeDiskInfo:UpdateRotation(isSun, now, curGrid)
  curHighlight = curGrid and HighlightMap[curGrid] or 1
  if isSun then
    if not self.sunRoot.activeSelf then
      self.sunRoot:SetActive(true)
      self.sun:SetActive(true)
      self.moonRoot:SetActive(false)
      self.moon:SetActive(false)
    end
    if now < 0.6 then
      tempX = now * DeltaX * 5 / 3 + StartPosX
    else
      tempX = backPosX - (now - 0.6) * DeltaX * 5 / 3
    end
    LuaVector3.Better_Set(tempV3, tempX, 5.6, 0)
    self.sun.transform.anchoredPosition = tempV3
    for i = 1, curHighlight do
      if self.sunGrid[i] and not self.sunGrid[i].activeSelf then
        self.sunGrid[i]:SetActive(true)
      end
    end
    for i = curHighlight + 1, 3 do
      if self.sunGrid[i] and self.sunGrid[i].activeSelf then
        self.sunGrid[i]:SetActive(false)
      end
    end
  else
    if not self.moonRoot.activeSelf then
      self.moonRoot:SetActive(true)
      self.moon:SetActive(true)
      self.sunRoot:SetActive(false)
      self.sun:SetActive(false)
    end
    now = now - 1
    if now < 0.6 then
      tempX = now * DeltaX * 5 / 3 + StartPosX
    else
      tempX = backPosX - (now - 0.6) * DeltaX * 5 / 3
    end
    LuaVector3.Better_Set(tempV3, tempX, 5.6, 0)
    self.moon.transform.anchoredPosition = tempV3
    for i = 1, curHighlight do
      if self.moonGrid[i] and not self.moonGrid[i].activeSelf then
        self.moonGrid[i]:SetActive(true)
      end
    end
    for i = curHighlight + 1, 3 do
      if self.moonGrid[i] and self.moonGrid[i].activeSelf then
        self.moonGrid[i]:SetActive(false)
      end
    end
  end
end

function SceneTimeDiskInfo:DoDeconstruct(asArray)
  if not LuaGameObject.ObjectIsNull(self.gameObject) then
    Game.GOLuaPoolManager:AddToSceneUIPool(PATH_PFB, self.gameObject)
    redlog("DoDeconstruct")
  end
  self.gameObject = nil
end
