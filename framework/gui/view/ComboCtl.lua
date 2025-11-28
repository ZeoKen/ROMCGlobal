autoImport("UICombo")
ComboCtl = class("ComboCtl")

function ComboCtl:ctor()
  if nil == ComboCtl.Instance then
    ComboCtl.Instance = self
  end
end

function ComboCtl:ShowCombo(num, anchorObjName)
  self.ComboNum = num
  local anchorDown = FloatingPanel.Instance:FindGO(anchorObjName or "Anchor_LeftTop")
  if nil == self.ComboEffect then
    UICombo:PlayUIEffect(EffectMap.UI.PVPCombo, anchorDown, false, ComboCtl.ComboEffectHandle, self)
  else
    self.UICombo:PlayAni(self.ComboNum)
  end
end

function ComboCtl.ComboEffectHandle(effectHandle, owner, assetEffect)
  if owner then
    owner.ComboEffect = assetEffect
    local effectGO = effectHandle.gameObject
    effectGO.transform.localPosition = LuaGeometry.Const_V3_zero
    ComboCtl.Instance.UICombo = UICombo.new(effectGO)
    if ComboCtl.Instance.ComboNum then
      ComboCtl.Instance.UICombo:PlayAni(ComboCtl.Instance.ComboNum)
    end
  end
end

function ComboCtl:Clear()
  if self.ComboEffect then
    self.ComboEffect:Destroy()
    self.ComboEffect = nil
  end
  self.ComboNum = nil
  if nil ~= self.UICombo then
    self.UICombo = nil
  end
end
