SealAreaTip = class("SealAreaTip", BaseTip)

function SealAreaTip:Init()
  SealAreaTip.super.Init(self)
  self:FindObjs()
end

function SealAreaTip:FindObjs()
  self.name = self:FindGO("Name"):GetComponent(UILabel)
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
  
  self.tweenAlpha = self:FindGO("Main"):GetComponent(TweenAlpha)
end

function SealAreaTip:SetPos(pos)
  if self.gameObject ~= nil then
    local p = self.gameObject.transform.position
    pos.z = p.z
    self.gameObject.transform.position = pos
  else
    self.pos = pos
  end
end

function SealAreaTip:SetData(data)
  self.data = data
  if data then
    self.name.text = data
  end
  self.tweenAlpha:ResetToBeginning()
  self.tweenAlpha:PlayForward()
end

function SealAreaTip:CloseSelf()
  if self.callback then
    self.callback(self.callbackParam)
  end
  TipsView.Me():HideCurrent()
  self.closecomp = nil
end

function SealAreaTip:DestroySelf()
  if not Slua.IsNull(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end
