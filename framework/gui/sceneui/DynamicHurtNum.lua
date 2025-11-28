autoImport("HurtNum")
DynamicHurtNum = reusableClass("DynamicHurtNum", HurtNum)
DynamicHurtNum.PoolSize = 50

function DynamicHurtNum:InitArgs(args)
  self:SetLifeEndTime(HurtNumAliveTime.Normal)
  self.canShow = true
  if self.pos == nil then
    self.pos = args[1]:Clone()
  else
    self.pos:Set(args[1][1], args[1][2], args[1][3])
  end
  self.num = args[2]
  self.type = args[3]
  self.colorType = args[4]
  self.critType = args[5]
  self.isMyself = args[6]
end

local _EffectShow = function(effectHandle, owner, assetEffect)
  if not owner then
    return
  end
  owner.FindObjects(owner, effectHandle.gameObject)
  owner.RefreshInfo(owner, effectHandle)
end

function DynamicHurtNum:Show()
  if not self.canShow then
    return
  end
  self.canShow = false
  local parent = SceneUIManager.Instance:GetSceneUIContainer(SceneUIType.DamageNum)
  if not parent then
    self:Destroy()
    return
  end
  if not self.effect then
    if HurtNum.HideLogic then
      self.effect = Asset_Effect.PlayOn(EffectMap.Maps.N_HurtNum, parent.transform, _EffectShow, self)
    else
      self.effect = Asset_Effect.PlayOneShotOn(EffectMap.Maps.N_HurtNum, parent.transform, _EffectShow, self)
    end
    self.effect:RegisterWeakObserver(self)
  else
    self:RefreshInfo()
  end
end

function DynamicHurtNum:ObserverDestroyed(obj)
  if obj == self.effect then
    self.effect = nil
    if self:Alive() then
      self:Destroy()
    end
  end
end

local FindComponent = UIUtil.FindComponent

function DynamicHurtNum:FindObjects(effectGO)
  if effectGO and self.effectGO ~= effectGO then
    self.effectGO = effectGO
    self.animator = effectGO:GetComponent(Animator)
    self.labelComp = FindComponent("Label", Text, effectGO)
    self.crit = FindComponent("Crit", CanvasGroup, effectGO)
    self.magicCrit = FindComponent("MagicCrit", CanvasGroup, effectGO)
    self.posSetHelper = effectGO:GetComponent(StayOriginalPosition)
    if not self.canvasGroup then
      self.canvasGroup = effectGO:GetComponent(CanvasGroup)
    end
  end
end

function DynamicHurtNum:RefreshInfo()
  if not self.effect or not self.effectGO then
    self:Destroy()
    return
  end
  if self.HideLogic then
    self.effect:ResetLifeTime(0)
  end
  self:SetActive(true)
  self.posSetHelper:SetPosition(self.pos)
  local num = tonumber(self.num)
  if num and num ~= 0 then
    num = math.floor(num)
  end
  self.labelComp.text = self:ProcessNum(num)
  if self.colorType and HurtNumColorMap[self.colorType] then
    self.labelComp.color = HurtNumColorMap[self.colorType]
  end
  if self.crit then
    self.crit.alpha = self.critType == HurtNum_CritType.PAtk and 1 or 0
  end
  if self.magicCrit then
    self.magicCrit.alpha = self.critType == HurtNum_CritType.MAtk and 1 or 0
  end
  self:SetLifeEndTime(HurtNumAliveTime.Normal)
  self:PlayAni(self.type)
end

function DynamicHurtNum:DoConstruct(asArray, args)
  DynamicHurtNum.super.DoConstruct(self, asArray, args)
  self:InitArgs(args)
end

function DynamicHurtNum:DoDeconstruct(asArray)
  if self.effect then
    local effect = self.effect
    self.effect = nil
    effect:Destroy()
  end
  self.canShow = nil
  self.effectGO = nil
  self.animator = nil
  self.labelComp = nil
  self.crit = nil
  self.magicCrit = nil
  self.posSetHelper = nil
  self.canvasGroup = nil
  self.num = nil
  self.critType = nil
end

function DynamicHurtNum:Hide()
  if not self.effect then
    return
  end
  self:SetActive(false)
end

function DynamicHurtNum:SetActive(show)
  if self.canvasGroup then
    self.canvasGroup.alpha = show and 1 or 0
  end
end
