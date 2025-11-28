autoImport("HurtNum")
StaticHurtNum = reusableClass("StaticHurtNum", HurtNum)
StaticHurtNum.PoolSize = 20
local LODLevel = {
  High = 0,
  Mid = 1,
  Low = 2,
  Invisible = 3
}

function StaticHurtNum:InitArgs(args)
  self:SetLifeEndTime(HurtNumAliveTime.Static)
  if args then
    self.type = args[3]
    self.colorType = args[4]
    self.critType = HurtNum_CritType.None
    self.num = 0
    self.ref = 0
  end
end

local _EffectShow = function(effectHandle, owner, assetEffect)
  if effectHandle and owner then
    local effectGO = effectHandle.gameObject
    owner.FindObjects(owner, effectGO)
    owner.RefreshInfo(owner, effectGO)
  end
end

function StaticHurtNum:Show(num, pos, isFromMe, critType, isToMe)
  if not num or not pos then
    return
  end
  self.isToMe = isToMe
  if (not isFromMe or not isToMe) and not Game.MapManager:IsIgnoreSceneUIMapCellLod() and Game.LogicManager_MapCell:MapCellLodLevelByPos(pos[1], pos[3]) ~= LODLevel.High then
    self:Hide()
    return
  end
  self.num = math.floor(self.num + num)
  if self.num <= 0 then
    return
  end
  if not self.pos then
    self.pos = pos:Clone()
  else
    self.pos:Set(pos[1], pos[2], pos[3])
  end
  self.critType = critType
  if not self.effect then
    local parent = SceneUIManager.Instance:GetSceneUIContainer(SceneUIType.DamageNum)
    if not parent then
      self:Destroy()
      return
    end
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

function StaticHurtNum:ObserverDestroyed(obj)
  if obj == self.effect then
    self.effect = nil
    self:Destroy()
  end
end

local FindComponent = UIUtil.FindComponent

function StaticHurtNum:FindObjects(effectGO)
  if effectGO and self.effectGO ~= effectGO then
    self.effectGO = effectGO
    self.animator = effectGO:GetComponent(Animator)
    self.originalPos = effectGO:GetComponent(StayOriginalPosition)
    self.labelcomp = FindComponent("Label", Text, effectGO)
    self.labelcomp.gameObject.layer = effectGO.layer
    if not self.canvasGroup then
      self.canvasGroup = effectGO:GetComponent(CanvasGroup)
    end
    self.crit = FindComponent("Crit", CanvasGroup, effectGO)
    self.magicCrit = FindComponent("MagicCrit", CanvasGroup, effectGO)
  end
end

function StaticHurtNum:RefreshInfo()
  if not self.effectGO then
    return
  end
  if self.effect and HurtNum.HideLogic then
    self.effect:ResetLifeTime(0)
  end
  self:SetActive(true)
  if self.originalPos then
    self.originalPos:SetPosition(self.pos)
  end
  if self.labelcomp then
    self.labelcomp.text = self:ProcessNum(self.num)
    if self.isToMe and self.critType == HurtNum_CritType.None and self.colorType ~= HurtNumColorType.Treatment and self.colorType ~= HurtNumColorType.Treatment_Sp then
      self.labelcomp.color = HurtNumColorMap[3]
    else
      self.labelcomp.color = HurtNumColorMap[self.colorType]
    end
  end
  if self.crit then
    self.crit.alpha = self.critType == HurtNum_CritType.PAtk and 1 or 0
  end
  if self.magicCrit then
    self.magicCrit.alpha = self.critType == HurtNum_CritType.MAtk and 1 or 0
  end
  self:SetLifeEndTime(HurtNumAliveTime.Static)
  self:PlayAni(self.type)
end

function StaticHurtNum:Hide()
  if not self.effect then
    return
  end
  self:SetActive(false)
end

function StaticHurtNum:AddRef()
  self.ref = self.ref + 1
end

function StaticHurtNum:SubRef()
  self.ref = self.ref - 1
  if self.ref <= 0 then
    self:End()
  end
end

function StaticHurtNum:End()
  if not self.effect or Slua.IsNull(self.effectGO) then
    self:Hide()
    return
  end
  self:SetLifeEndTime(1)
  self:PlayAni(HurtNumType.DamageNum)
end

function StaticHurtNum:IsLifeEnd()
  if self.ref > 0 then
    return false
  end
  return StaticHurtNum.super.IsLifeEnd(self)
end

function StaticHurtNum:DoConstruct(asArray, args)
  StaticHurtNum.super.DoConstruct(self, asArray, args)
  self:InitArgs(args)
end

function StaticHurtNum:DoDeconstruct(asArray)
  if self.effect then
    local effect = self.effect
    self.effect = nil
    effect:Destroy()
  end
  if self.pos then
    self.pos:Destroy()
  end
  self.effectGO = nil
  self.animator = nil
  self.originalPos = nil
  self.labelcomp = nil
  self.canvasGroup = nil
  self.crit = nil
  self.magicCrit = nil
  self.pos = nil
  self.critType = nil
end

function StaticHurtNum:SetActive(show)
  if self.canvasGroup then
    self.canvasGroup.alpha = show and 1 or 0
  end
end
