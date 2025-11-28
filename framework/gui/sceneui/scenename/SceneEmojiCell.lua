SceneEmojiCell = reusableClass("SceneEmojiCell")
SceneEmojiCell.PoolSize = 50

function SceneEmojiCell:Active(b)
  if not Slua.IsNull(self.gameObject) then
    self.gameObject:SetActive(b)
  end
end

function SceneEmojiCell:PlayEmoji(animationName, loopCount, endCall, endCallArgs)
  if Slua.IsNull(self.anim) then
    return
  end
  self.anim = self.gameObject:GetComponent(SkeletonAnimation)
  self.anim.AnimationName = animationName
  self.anim:Reset()
  self.anim.loop = false
  loopCount = loopCount or 1
  if not self.playFunc then
    function self.playFunc()
      loopCount = loopCount - 1
      
      if 0 < loopCount then
        self:PlayEmoji(animationName, loopCount, endCall, endCallArgs)
      elseif nil ~= endCall then
        endCall(endCallArgs)
      end
    end
  end
  SpineLuaHelper.PlayAnim(self.anim, animationName, self.playFunc)
end

function SceneEmojiCell:DoConstruct(asArray, args)
  local parent = args[1]
  if not LuaGameObject.ObjectIsNull(parent) then
    self.resPath = args[2]
    self.gameObject = Game.AssetManager_UI:CreateSceneUIAsset(self.resPath, parent.transform)
    LuaGameObject.SetLocalPositionGO(self.gameObject, 0, 0, 0)
    LuaGameObject.SetLocalRotationGO(self.gameObject, 0, 0, 0, 1)
    LuaGameObject.SetLocalScaleGO(self.gameObject, 1, 1, 1)
    UIUtil.ChangeLayer(self.gameObject, parent.gameObject.layer)
    self.anim = self.gameObject:GetComponent(SkeletonAnimation)
    local depth = args[3]
    if type(depth) == "number" then
      local uispine = self.gameObject:GetComponent(UISpine)
      if uispine then
        uispine.depth = depth
      end
    end
    self:PlayEmoji(args[4], args[5], args[6], args[7])
  end
end

function SceneEmojiCell:DoDeconstruct(asArray)
  if not LuaGameObject.ObjectIsNull(self.gameObject) then
    Game.GOLuaPoolManager:AddToSceneUIPool(self.resPath, self.gameObject)
  end
  self.playFunc = nil
  self.gameObject = nil
  self.anim = nil
  self.resPath = nil
end
