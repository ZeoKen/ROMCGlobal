autoImport("NSceneEffect")
ClientSceneEffect = reusableClass("ClientSceneEffect", NSceneEffect)
ClientSceneEffect.PoolSize = 10

function ClientSceneEffect:Start(pos, effect, oneShot, endCallback, context, dir, scale, createCallBack)
  if self.running then
    return
  end
  self.running = true
  self.endCallback = endCallback
  self.context = context
  local assetEffect = ClientSceneEffect.PlayEffect(pos, effect, oneShot, createCallBack)
  if dir then
    assetEffect:ResetLocalEulerAngles(dir)
  end
  if scale then
    assetEffect:ResetLocalScaleXYZ(scale, scale, scale)
  end
  self:SetWeakData(NSceneEffect.AssetEffect, assetEffect)
  return assetEffect
end

function ClientSceneEffect.PlayEffect(pos, effect, oneShot, cb)
  if oneShot then
    return Asset_Effect.PlayOneShotAt(effect, pos, cb)
  else
    return Asset_Effect.PlayAt(effect, pos, cb)
  end
end

function ClientSceneEffect:DoConstruct(asArray, data)
  self._alive = true
  self:CreateWeakData()
end

function ClientSceneEffect:OnObserverDestroyed(k, obj)
end
