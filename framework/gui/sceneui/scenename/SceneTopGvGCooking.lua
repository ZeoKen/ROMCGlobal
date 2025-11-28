SceneTopGvGCooking = reusableClass("SceneTopGvGCooking")
SceneTopGvGCooking.resId = ResourcePathHelper.UIPrefab_Cell("SceneTopGvGCooking")

function SceneTopGvGCooking:DoDeconstruct(asArray)
  self.m_parent = nil
  self.gameObject = nil
  self.m_uiStarRoot = nil
  self.m_uiAllStar = nil
  self:removeTick()
  SceneTopGvGCooking.super.DoDeconstruct(self, asArray)
end

function SceneTopGvGCooking:DoConstruct(asArray, args)
  self.m_parent = args
  if not LuaGameObject.ObjectIsNull(self.m_parent) then
    self.gameObject = Game.AssetManager_UI:CreateSceneUIAsset(SceneTopGvGCooking.resId, self.m_parent.transform)
    self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(271, 148, 0)
    self.gameObject.transform.localRotation = LuaGeometry.Const_Qua_identity
    self.gameObject.transform.localScale = LuaGeometry.Const_V3_one
    self.gameObject:SetActive(true)
    self:onSetObj()
  end
  self._alive = true
end

function SceneTopGvGCooking:Alive()
  return self._alive
end

function SceneTopGvGCooking:Find(name)
  return GameObjectUtil.Instance:DeepFind(self.gameObject, name)
end

function SceneTopGvGCooking:onSetObj()
  self.m_uiStarRoot = self:Find("uiStarRoot")
  self.m_uiAllStar = {}
  for i = 1, 5 do
    local ui = {}
    ui.m_uiImgStar = self:Find("uiStarRoot/" .. i):GetComponent(Image)
    ui.m_uiImgLightStar = self:Find("uiStarRoot/" .. i .. "/uiImgLight"):GetComponent(Image)
    ui.m_uiImgLightStar.gameObject:SetActive(false)
    table.insert(self.m_uiAllStar, ui)
  end
end

function SceneTopGvGCooking:updateInfo()
  local curValue = GVGCookingHelper.Me():getCurValue()
  local maxValue = GVGCookingHelper.Me():getTotalValue()
  local nowSeason = GvgProxy.Instance:NowSeason()
  local config = GameConfig.GvgRimConfig.SeasonSpecial and GameConfig.GvgRimConfig.SeasonSpecial[nowSeason] or GameConfig.GvgRimConfig
  local star_point = config.star_point
  for k, v in ipairs(self.m_uiAllStar) do
    local value = star_point[k]
    if curValue >= value then
      v.m_uiImgLightStar.gameObject:SetActive(true)
    else
      v.m_uiImgLightStar.gameObject:SetActive(false)
    end
  end
end

function SceneTopGvGCooking:removeTick()
end

function SceneTopGvGCooking:isVisible(value)
  if self.gameObject ~= nil then
    self.gameObject:SetActive(value)
  end
end
