WaitEnterBord = class("WaitEnterBord", CoreView)
local EFFECT_PATH = "WaitEnter"

function WaitEnterBord:ctor(parent)
  self.gameObject = self:LoadPreferb("part/WaitEnterBord", parent, true)
  self.effectBg = self:FindComponent("EffectContainer", ChangeRqByTex)
  self:PlayUIEffect(EFFECT_PATH, self.effectBg, false, function(obj, args, assetEffect)
    self.effect = assetEffect
    self.effectBg.excute = false
  end)
  self:Active(false)
end

function WaitEnterBord:OnDestroy()
  if self.effect then
    self.effect:Destroy()
    self.effect = nil
  end
end

function WaitEnterBord:Active(b)
  self.gameObject:SetActive(b)
end
