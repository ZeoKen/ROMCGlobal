autoImport("HurtNum")
DynamicMissNum = reusableClass("DynamicMissNum", HurtNum)
DynamicMissNum.PoolSize = 50

function DynamicMissNum:InitArgs(args)
  self:SetLifeEndTime(HurtNumAliveTime.Normal)
  self.canShow = true
  if args then
    if self.pos == nil then
      self.pos = args[1]:Clone()
    else
      self.pos:Set(args[1][1], args[1][2], args[1][3])
    end
    self.type = args[3]
  end
end

local _EffectShow = function(effectHandle, owner, assetEffect)
  if not owner then
    return
  end
  owner.FindObjects(owner, effectHandle.gameObject)
  owner.RefreshInfo(owner)
end

function DynamicMissNum:Show()
  if not self.canShow then
    return
  end
  self.canShow = false
  local parent = SceneUIManager.Instance:GetSceneUIContainer(SceneUIType.DamageNum)
  if not self.pos then
    self:Destroy()
    return
  end
  if not self.effect then
    if HurtNum.HideLogic then
      self.effect = Asset_Effect.PlayOn(EffectMap.Maps.N_HurtNumMiss, parent.transform, _EffectShow, self)
    else
      self.effect = Asset_Effect.PlayOneShotOn(EffectMap.Maps.N_HurtNumMiss, parent.transform, _EffectShow, self)
    end
    self.effect:RegisterWeakObserver(self)
  else
    self:RefreshInfo()
  end
end

function DynamicMissNum:ObserverDestroyed(obj)
  if obj == self.effect then
    self.effect = nil
    self:Destroy()
  end
end

local FindGO = UIUtil.FindGO

function DynamicMissNum:FindObjects(effectGO)
  self.effectGO = effectGO
  if effectGO then
    self.animator = effectGO:GetComponent(Animator)
  else
    self.animator = nil
  end
  self.posSetHelper = effectGO:GetComponent(StayOriginalPosition)
  if not self.canvasGroup then
    self.canvasGroup = effectGO:GetComponent(CanvasGroup)
  end
end

function DynamicMissNum:RefreshInfo()
  if not self.effectGO then
    return
  end
  if self.effect and HurtNum.HideLogic then
    self.effect:ResetLifeTime(0)
  end
  self:SetActive(true)
  self.posSetHelper:SetPosition(self.pos)
  self:SetLifeEndTime(HurtNumAliveTime.Normal)
  self:PlayAni(self.type)
end

function DynamicMissNum:DoConstruct(asArray, args)
  DynamicMissNum.super.DoConstruct(self, asArray, args)
  self:InitArgs(args)
end

function DynamicMissNum:DoDeconstruct(asArray)
  self.canShow = false
  if self.effect then
    local effect = self.effect
    self.effect = nil
    effect:Destroy()
  end
  self.effectGO = nil
  self.animator = nil
  self.posSetHelper = nil
  self.canvasGroup = nil
end

function DynamicMissNum:Hide()
  if not self.effect then
    return
  end
  self:SetActive(false)
end

function DynamicMissNum:SetActive(show)
  self.hide = not show
  if self.canvasGroup then
    self.canvasGroup.alpha = show and 1 or 0
  end
end
