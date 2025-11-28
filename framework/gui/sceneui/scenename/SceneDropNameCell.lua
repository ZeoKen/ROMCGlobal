SceneDropNameCell = reusableClass("SceneDropNameCell")
SceneDropNameCell.PoolSize = 20
SceneDropNameCell.ResID = ResourcePathHelper.UIPrefab_Cell("SceneDropNameCell")
local Offset = LuaVector3(0, -0.17, 0)
local Vector3One = LuaGeometry.Const_V3_one
local Qua_identity = LuaGeometry.Const_Qua_identity

function SceneDropNameCell:DoConstruct(asArray, item)
  local container = SceneUIManager.Instance:GetSceneUIContainer(SceneUIType.DropItemName)
  self.gameObject = Game.AssetManager_UI:CreateSceneUIAsset(SceneDropNameCell.ResID, container)
  self.transform = self.gameObject.transform
  self.transform.localRotation = Qua_identity
  self.transform.localScale = Vector3One
  if not Slua.IsNull(item.model) then
    Game.TransformFollowManager:RegisterFollowPos(self.transform, item.model.transform, Offset, self.Destroy, self)
  end
  local namelab = Game.GameObjectUtil:DeepFind(self.gameObject, "Name"):GetComponent(Text)
  local refinelv = item.refinelv
  local sdata = item.staticData
  if sdata then
    if refinelv and 0 < refinelv then
      namelab.text = string.format("%s+%s%s[-]", ItemQualityColor[sdata.Quality], refinelv, sdata.NameZh)
    else
      namelab.text = string.format("%s%s[-]", ItemQualityColor[sdata.Quality], sdata.NameZh)
    end
  end
end

function SceneDropNameCell:DoDeconstruct(asArray)
  if not LuaGameObject.ObjectIsNull(self.gameObject) then
    Game.TransformFollowManager:UnregisterFollow(self.transform)
    Game.GOLuaPoolManager:AddToSceneUIPool(SceneDropNameCell.ResID, self.gameObject)
  end
  self.gameObject = nil
  self.transform = nil
end
