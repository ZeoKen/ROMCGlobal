LowBloodBlinkView = class("LowBloodBlinkView", BaseView)
LowBloodBlinkView.ViewType = UIViewType.UIScreenEffectLayer

function LowBloodBlinkView:Init()
  self.gameObject.name = "LowBloodBlinkView"
  LowBloodBlinkView.Instance = self
  self:addListEventListener()
end

function LowBloodBlinkView:OnEnter()
  LowBloodBlinkView.super.OnEnter(self)
  self:ShowLowBloodBlink()
end

function LowBloodBlinkView:addListEventListener()
end

function LowBloodBlinkView.ShowLowBloodBlink()
  local instance = LowBloodBlinkView.getInstance()
  if instance.bloodBlinkAnim == nil then
    instance.bloodBlinkAnim = instance:PlayUIEffect(EffectMap.UI.LowBlood, instance.gameObject, nil, function(go)
      local texture = instance:FindChild("pic_lvjing01"):GetComponent(UITexture)
      local l, t, r, b = UIManagerProxy.Instance:GetMyMobileScreenAdaptionOffsets()
      if l then
        local absoluteLR = math.max(l, r)
        texture:SetAnchor(go.gameObject, -absoluteLR, texture.bottomAnchor.absolute, absoluteLR, texture.topAnchor.absolute)
      end
      instance.animtor = go:GetComponent(Animator)
      instance.animtor:Play("7danger")
    end)
  elseif instance.animtor ~= nil then
    instance.animtor:Play("7danger")
  end
end

function LowBloodBlinkView.ShowLowBloodBlinkWhenHit()
  local instance = LowBloodBlinkView.getInstance()
  if instance.bloodBlinkAnim == nil then
    instance.bloodBlinkAnim = instance:PlayUIEffect(EffectMap.UI.LowBlood, instance.gameObject, nil, function(go)
      instance.animtor = go:GetComponent(Animator)
      instance.animtor:Play("7dangerhit", -1, 0)
    end)
  elseif instance.animtor ~= nil then
    instance.animtor:Play("7dangerhit", -1, 0)
  end
end

function LowBloodBlinkView:OnExit()
  LowBloodBlinkView.super.OnExit(self)
  LowBloodBlinkView.Instance = nil
end

function LowBloodBlinkView.getInstance()
  if LowBloodBlinkView.Instance == nil then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.LowBloodBlinkView
    })
  end
  return LowBloodBlinkView.Instance
end

function LowBloodBlinkView.closeBloodBlink()
  if LowBloodBlinkView.Instance ~= nil then
    LowBloodBlinkView.Instance:CloseSelf()
  end
end
