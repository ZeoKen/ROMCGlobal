autoImport("BaseTip")
FloatLeftTip = class("FloatLeftTip", BaseTip)
FloatLeftTip.MaxWidth = 230

function FloatLeftTip:Init()
  self.desc = self:FindComponent("Desc", UILabel)
  self.closeComp = self:FindGO("Main"):GetComponent(CloseWhenClickOtherPlace)
  
  function self.closeComp.callBack()
    TipsView.Me():HideTip(FloatLeftTip)
  end
end

function FloatLeftTip:SetData(data, forceOpen)
  if not forceOpen and (data == nil or data == "") then
    TipsView.Me():HideTip(FloatLeftTip)
    return
  end
  self.desc.text = data
  UIUtil.FitLabelHeight(self.desc, FloatLeftTip.MaxWidth)
end

function FloatLeftTip:AddIgnoreBounds(obj)
  if self.gameObject and self.closeComp then
    self.closeComp:AddTarget(obj.transform)
  end
end

function FloatLeftTip:RemoveUpdateTick()
  if self.updateCallTick then
    TimeTickManager.Me():ClearTick(self, 1)
    self.updateCallTick = nil
  end
  self.updateCall = nil
  self.updateCallTick = nil
end

function FloatLeftTip:SetUpdateSetText(interval, updateCall, updateCallParam)
  self.updateCall = updateCall
  self.updateCallParam = updateCallParam
  if self.updateCallTick == nil then
    self.updateCallTick = TimeTickManager.Me():CreateTick(0, interval, self._TickUpdateCall, self, 1)
  end
end

function FloatLeftTip:SetCloseCall(closeCall, closeCallParam)
  self.closeCall = closeCall
  self.closeCallParam = closeCallParam
end

function FloatLeftTip:_TickUpdateCall()
  if self.updateCall then
    local needRemove, text = self.updateCall(self.updateCallParam)
    self:SetData(text)
    if needRemove then
      self:RemoveUpdateTick()
    end
  end
end

function FloatLeftTip:OnEnter()
  FloatLeftTip.super.OnEnter(self)
end

function FloatLeftTip:DestroySelf()
  if not self:ObjIsNil(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end

function FloatLeftTip:OnExit()
  self:RemoveUpdateTick()
  if self.closeCall then
    self.closeCall(self.closeCallParam)
  end
  return true
end
