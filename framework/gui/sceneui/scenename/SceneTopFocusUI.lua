local BaseCell = autoImport("BaseCell")
SceneTopFocusUI = reusableClass("SceneTopFocusUI", BaseCell)
SceneTopFocusUI.resId = ResourcePathHelper.EffectUI("25focus")
SceneTopFocusUI.FocusType = {Creature = 1, SceneObject = 2}
SceneTopFocusUI.PoolSize = 10
local tempVector3 = LuaVector3.Zero()

function SceneTopFocusUI:Construct(asArray, args)
  self:DoConstruct(asArray, args)
end

function SceneTopFocusUI:Finalize()
end

function SceneTopFocusUI:DoConstruct(asArray, args)
  local focusType = args[1]
  if focusType == SceneTopFocusUI.FocusType.Creature then
    local target = args[2]
    self.gameObject = Game.AssetManager_UI:CreateSceneUIAsset(SceneTopFocusUI.resId, target)
    if args[3] then
      self.creatureId = args[3]
    end
  elseif focusType == SceneTopFocusUI.FocusType.SceneObject then
    self.followTarget = GameObject("SceneTopFocusUIObj")
    local uicontainer = SceneUIManager.Instance:GetSceneUIContainer(SceneUIType.PhotoFocus)
    self.gameObject = Game.AssetManager_UI:CreateSceneUIAsset(SceneTopFocusUI.resId, uicontainer)
    self:setFollowTarget()
  end
  if self.gameObject then
    local transform = self.gameObject.transform
    transform.localPosition = LuaGeometry.Const_V3_zero
    transform.localRotation = LuaGeometry.Const_Qua_identity
    transform.localScale = LuaGeometry.Const_V3_one
    self.animator = self.gameObject:GetComponent(Animator)
    self.withinImage = Game.GameObjectUtil:DeepFind(self.gameObject, "photo_icon_within"):GetComponent(Image)
  end
  self._alive = true
end

function SceneTopFocusUI:Deconstruct(asArray)
  if not LuaGameObject.ObjectIsNull(self.gameObject) then
    Game.GOLuaPoolManager:AddToSceneUIPool(SceneTopFocusUI.resId, self.gameObject)
  end
  if not self:ObjIsNil(self.followTarget) then
    Game.TransformFollowManager:UnregisterFollow(self.gameObject.transform)
    GameObject.DestroyImmediate(self.followTarget)
  end
  self.gameObject = nil
  self.followTarget = nil
  self.animator = nil
  self.withinImage = nil
  self._alive = false
end

function SceneTopFocusUI:playFocusAnim()
  self.animator:Play("focus2", -1, 0)
  TimeTickManager.Me():CreateTick(0, 16, self.checkIsPlayIngAnim, self, PhotographPanel.TickType.CheckAnim)
end

function SceneTopFocusUI:PlayFocusAnimOnceLite()
  if self:ObjIsNil(self.animator) then
    return
  end
  if self.animator then
    local animState = self.animator:GetCurrentAnimatorStateInfo(0)
    local complete = animState.normalizedTime >= 1
    local isPlaying2 = animState:IsName("focus2")
    local isPlaying3 = animState:IsName("focus3")
    if isPlaying3 then
    elseif isPlaying2 then
      if complete then
        self.animator:Play("focus3", -1, 0)
      end
    else
      self.animator:Play("focus2", -1, 0)
    end
  end
end

function SceneTopFocusUI:playLostFocusAnim()
  self.animator:Play("focus1", -1, 0)
  TimeTickManager.Me():ClearTick(self, PhotographPanel.TickType.CheckAnim)
end

function SceneTopFocusUI:playStopFocusAnim()
  self.animator:Play("focus3", -1, 0)
end

function SceneTopFocusUI:reSetFollowPos(pos)
  if not self:ObjIsNil(self.followTarget) then
    self.followTarget.transform.position = pos
  end
end

function SceneTopFocusUI:setFollowTarget()
  if not self:ObjIsNil(self.followTarget) then
    Game.TransformFollowManager:RegisterFollowPos(self.gameObject.transform, self.followTarget.transform, LuaGeometry.Const_V3_zero, SceneTopFocusUI.lostCallback, self)
  end
end

function SceneTopFocusUI:setWithinImage(name)
  name = name or "photo_icon_within"
  if not LuaGameObject.ObjectIsNull(self.withinImage) then
    SpriteManager.SetUISprite("sceneuieffect", name, self.withinImage)
  end
end

function SceneTopFocusUI.lostCallback(owner)
  owner:Deconstruct()
end

function SceneTopFocusUI:getPosition()
  LuaVector3.Better_Set(tempVector3, LuaGameObject.GetPosition(self.gameObject.transform))
  return tempVector3
end

function SceneTopFocusUI:getTarPosition()
  if self.followTarget then
    LuaVector3.Better_Set(tempVector3, LuaGameObject.GetPosition(self.followTarget.transform))
    return tempVector3
  else
    return self:getPosition()
  end
end

function SceneTopFocusUI:checkIsPlayIngAnim()
  if self:ObjIsNil(self.animator) then
    return
  end
  if self.animator then
    local animState = self.animator:GetCurrentAnimatorStateInfo(0)
    local complete = animState.normalizedTime >= 1
    local isPlaying = animState:IsName("focus2")
    if not complete and isPlaying then
      return
    end
  end
  if self.sound and not self:ObjIsNil(self.sound) then
    self.sound:Stop()
  end
  self.sound = self:PlayUISound(AudioMap.UI.Focus)
  self:playStopFocusAnim()
  TimeTickManager.Me():ClearTick(self, PhotographPanel.TickType.CheckAnim)
end

function SceneTopFocusUI:Alive()
  return self._alive
end
