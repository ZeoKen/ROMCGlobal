SceneSnowmanProcess = reusableClass("SceneSnowmanProcess")
SceneSnowmanProcess.PoolSize = 10
SceneSnowmanProcess.ResID = ResourcePathHelper.UIPrefab_Cell("SceneSnowmanProcess")

function SceneSnowmanProcess:CreateGO()
  self.gameObject = Game.AssetManager_UI:CreateSceneUIAsset(SceneSnowmanProcess.ResID, self.parent)
  local processLabelGO = Game.GameObjectUtil:DeepFind(self.gameObject, "ProcessLabel")
  self.processLabel = processLabelGO and processLabelGO:GetComponent(Text)
  local processSliderGO = Game.GameObjectUtil:DeepFind(self.gameObject, "Slider")
  self.processSlider = processSliderGO and processSliderGO:GetComponent(Slider)
end

function SceneSnowmanProcess:SetData(process, totalProcess)
  if process and totalProcess then
    self.processLabel.text = process .. "/" .. totalProcess
    self.processSlider.value = process / totalProcess
  end
end

function SceneSnowmanProcess:DoConstruct(asArray, args)
  self.parent = args and args[1]
  self:CreateGO()
end

function SceneSnowmanProcess:DoDeconstruct(asArray)
  if not LuaGameObject.ObjectIsNull(self.gameObject) then
    Game.GOLuaPoolManager:AddToSceneUIPool(SceneSnowmanProcess.ResID, self.gameObject)
  end
  self.gameObject = nil
  self.parent = nil
end
