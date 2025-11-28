SceneCoinCell = reusableClass("SceneCoinCell")
SceneCoinCell.PoolSize = 10
SceneCoinCell.ResID = ResourcePathHelper.UIPrefab_Cell("SceneCoinCell")

function SceneCoinCell:CreateGO()
  self.gameObject = Game.AssetManager_UI:CreateSceneUIAsset(SceneCoinCell.ResID, self.parent)
  local coin = Game.GameObjectUtil:DeepFind(self.gameObject, "Coin")
  self.coinLabel = coin and coin:GetComponent(Text)
  local image = Game.GameObjectUtil:DeepFind(self.gameObject, "Image")
  self.icon = image and image:GetComponent(Image)
  SpriteManager.SetUISprite("sceneui", "main_icon_kuangshi", self.icon)
end

function SceneCoinCell:SetData(data)
  self.coinLabel.text = data
end

function SceneCoinCell:SetActive(active)
  self.gameObject:SetActive(active)
end

function SceneCoinCell:DoConstruct(asArray, args)
  self.parent = args
  self:CreateGO()
end

function SceneCoinCell:DoDeconstruct(asArray)
  if not LuaGameObject.ObjectIsNull(self.gameObject) then
    Game.GOLuaPoolManager:AddToSceneUIPool(SceneCoinCell.ResID, self.gameObject)
  end
  self.gameObject = nil
  self.parent = nil
  self.coinLabel = nil
end
