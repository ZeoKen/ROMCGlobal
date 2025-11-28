local IsNull = Slua.IsNull
SceneComodoBuildingProduce = reusableClass("SceneComodoBuildingProduce")
SceneComodoBuildingProduce.PoolSize = 3
SceneComodoBuildingProduce.ResID = ResourcePathHelper.UIPrefab_Cell("SceneComodoBuildingProduce")
local buildingIns

function SceneComodoBuildingProduce:Update()
  local iconName = buildingIns:GetDisplayIconNameOfReservedProduce(self.buildingId)
  iconName = iconName or buildingIns:GetDisplayIconNameOfSmithing(self.npcId)
  self:SetActive(iconName ~= nil)
  if iconName then
    SpriteManager.SetUISprite("sceneuieffect", iconName, self.icon)
  end
end

function SceneComodoBuildingProduce:SetActive(isActive)
  isActive = isActive and true or false
  if self.objActive == isActive then
    return
  end
  self.objActive = isActive
  if not IsNull(self.gameObject) then
    self.gameObject:SetActive(self.objActive)
  end
end

function SceneComodoBuildingProduce:DoConstruct(asArray, args)
  local parent = args[1]
  if IsNull(parent) then
    return
  end
  self.gameObject = Game.AssetManager_UI:CreateSceneUIAsset(SceneComodoBuildingProduce.ResID, parent.transform)
  self.gameObject.transform.localPosition = LuaGeometry.Const_V3_zero
  self.gameObject.transform.localRotation = LuaGeometry.Const_Qua_identity
  self.gameObject.transform.localScale = LuaGeometry.Const_V3_one
  self.gameObject:SetActive(true)
  self.objActive = true
  self.icon = Game.GameObjectUtil:DeepFind(self.gameObject, "Icon"):GetComponent(Image)
  if not buildingIns then
    buildingIns = ComodoBuildingProxy.Instance
  end
  self.npcId = args[2]
  self.buildingId = self.npcId and GameConfig.Manor.ManorBuildNpc[self.npcId]
  TimeTickManager.Me():CreateTick(0, 1000, self.Update, self)
end

function SceneComodoBuildingProduce:DoDeconstruct(asArray)
  if not IsNull(self.gameObject) then
    Game.GOLuaPoolManager:AddToSceneUIPool(SceneComodoBuildingProduce.ResID, self.gameObject)
  end
  TimeTickManager.Me():ClearTick(self)
  self.gameObject = nil
  self.icon = nil
  self.npcId = nil
  self.buildingId = nil
end
