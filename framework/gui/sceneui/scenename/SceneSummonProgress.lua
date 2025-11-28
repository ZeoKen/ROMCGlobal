autoImport("LuaGameObject")
SceneSummonProgress = reusableClass("SceneSummonProgress")
SceneSummonProgress.PoolSize = 10
SceneSummonProgress.ResID = ResourcePathHelper.UIPrefab_Cell("SceneSummonProgress")

function SceneSummonProgress:SetData(progress, npcID)
  self.progress = progress or 0
  self.npcID = npcID or 0
  self:UpdateProgress()
end

function SceneSummonProgress:UpdateProgress()
  if not self.progressLabel or not self.progressBar then
    return
  end
  if self.npcID > 0 then
    self.progressLabel.text = ZhString.AbyssBoss_Summoned
  else
    self.progressLabel.text = string.format("%d%%", self.progress)
  end
  if self.progressBar then
    self.progressBar.value = self.progress / 100
  end
end

function SceneSummonProgress:SetActive(isActive)
  isActive = isActive and true or false
  if self.objActive == isActive then
    return
  end
  self.objActive = isActive
  if self.gameObject and not LuaGameObject.ObjectIsNull(self.gameObject) then
    self.gameObject:SetActive(self.objActive)
  end
end

function SceneSummonProgress:DoConstruct(asArray, args)
  local parent = args[1]
  if LuaGameObject.ObjectIsNull(parent) then
    return
  end
  self.creatureId = args[2]
  self.mapstepId = args[3]
  self.area = args[4]
  self.gameObject = Game.AssetManager_UI:CreateSceneUIAsset(SceneSummonProgress.ResID, parent.transform)
  self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(0, 30, 0)
  self.gameObject.transform.localRotation = LuaGeometry.Const_Qua_identity
  self.gameObject.transform.localScale = LuaGeometry.Const_V3_one
  self.gameObject:SetActive(true)
  self.objActive = true
  self.progressLabel = Game.GameObjectUtil:DeepFind(self.gameObject, "Progress"):GetComponent(Text)
  self.progressBar = Game.GameObjectUtil:DeepFind(self.gameObject, "Slider"):GetComponent(Slider)
  local title = Game.GameObjectUtil:DeepFind(self.gameObject, "Title"):GetComponent(Text)
  title.text = ZhString.AbyssBoss_SummonProgress
  self:InitData()
end

function SceneSummonProgress:InitData()
  local npcid, progress = AbyssLakeProxy.Instance:GetSummonProgress(self.area, self.mapstepId)
  self:SetData(progress, npcid)
end

function SceneSummonProgress:DoDeconstruct(asArray)
  if self.gameObject and not LuaGameObject.ObjectIsNull(self.gameObject) then
    Game.GOLuaPoolManager:AddToSceneUIPool(SceneSummonProgress.ResID, self.gameObject)
  end
  self.gameObject = nil
  self.progressLabel = nil
  self.progressBar = nil
  self.creatureId = nil
  self.mapstepId = nil
  self.progress = nil
end
