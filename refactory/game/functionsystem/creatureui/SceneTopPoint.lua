SceneTopPoint = reusableClass("SceneTopPoint")
SceneTopPoint.PoolSize = 10
local PATH_PFB = ResourcePathHelper.UIPrefab_Cell("SceneTopPoint")
local PREFIX_COLOR
local COLOR_CONFIG = {"#90ff69", "#ff6b6b"}

function SceneTopPoint:UpdatePoint()
  if not self.label then
    return
  end
  if self.text == nil then
    return
  end
  PREFIX_COLOR = self.text > 0 and COLOR_CONFIG[1] .. ">" .. "+" or COLOR_CONFIG[2] .. ">"
  self.label.text = "<color=" .. PREFIX_COLOR .. tostring(self.text) .. "</color>"
end

function SceneTopPoint:ResetText(text)
  self.text = text
  self:UpdatePoint()
end

function SceneTopPoint:DoConstruct(asArray, args)
  local parent = args[1]
  if not LuaGameObject.ObjectIsNull(parent) then
    self.gameObject = Game.AssetManager_UI:CreateSceneUIAsset(PATH_PFB, parent.transform)
    self.gameObject.transform.localPosition = LuaGeometry.Const_V3_zero
    self.gameObject.transform.localRotation = LuaGeometry.Const_Qua_identity
    self.gameObject.transform.localScale = LuaGeometry.Const_V3_one
    self.label = Game.GameObjectUtil:DeepFind(self.gameObject, "Label"):GetComponent(Text)
    self.text = args[2]
    self:UpdatePoint()
  end
end

function SceneTopPoint:DoDeconstruct(asArray)
  if not LuaGameObject.ObjectIsNull(self.gameObject) then
    Game.GOLuaPoolManager:AddToSceneUIPool(PATH_PFB, self.gameObject)
  end
  self.gameObject = nil
  self.label = nil
  self.text = nil
end
