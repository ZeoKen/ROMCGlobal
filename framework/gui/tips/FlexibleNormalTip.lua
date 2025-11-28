autoImport("BaseTip")
FlexibleNormalTip = class("FlexibleNormalTip", BaseTip)
FlexibleNormalTip.MaxWidth = 248

function FlexibleNormalTip:Init()
  self.desc = self:FindComponent("Desc", UILabel)
  self.originDescLocalPosition = self.desc.transform.localPosition
  self.closeComp = self:FindGO("Main"):GetComponent(CloseWhenClickOtherPlace)
  
  function self.closeComp.callBack()
    TipsView.Me():HideTip(FlexibleNormalTip)
  end
end

function FlexibleNormalTip:SetData(data, forceOpen)
  if not forceOpen and (data == nil or data == "") then
    TipsView.Me():HideTip(FlexibleNormalTip)
    return
  end
  self.desc.text = data
  UIUtil.FitLabelHeight(self.desc, FlexibleNormalTip.MaxWidth)
end

function FlexibleNormalTip:AddIgnoreBounds(obj)
  if self.gameObject and self.closeComp then
    self.closeComp:AddTarget(obj.transform)
  end
end

function FlexibleNormalTip:RemoveUpdateTick()
  if self.updateCallTick then
    TimeTickManager.Me():ClearTick(self, 1)
    self.updateCallTick = nil
  end
  self.updateCall = nil
  self.updateCallTick = nil
end

function FlexibleNormalTip:SetUpdateSetText(interval, updateCall, updateCallParam)
  self.updateCall = updateCall
  self.updateCallParam = updateCallParam
  if self.updateCallTick == nil then
    self.updateCallTick = TimeTickManager.Me():CreateTick(0, interval, self._TickUpdateCall, self, 1)
  end
end

function FlexibleNormalTip:SetCloseCall(closeCall, closeCallParam)
  self.closeCall = closeCall
  self.closeCallParam = closeCallParam
end

function FlexibleNormalTip:_TickUpdateCall()
  if self.updateCall then
    local needRemove, text = self.updateCall(self.updateCallParam)
    self:SetData(text)
    if needRemove then
      self:RemoveUpdateTick()
    end
  end
end

function FlexibleNormalTip:OnEnter()
  FlexibleNormalTip.super.OnEnter(self)
end

function FlexibleNormalTip:DestroySelf()
  if not self:ObjIsNil(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end

function FlexibleNormalTip:OnExit()
  self:RemoveUpdateTick()
  if self.closeCall then
    self.closeCall(self.closeCallParam)
  end
  return true
end

function FlexibleNormalTip:SetContentPivot(pivot)
  self.desc.pivot = pivot
  LuaGameObject.SetLocalPositionGO(self.desc.gameObject, self.originDescLocalPosition[1], self.originDescLocalPosition[2], self.originDescLocalPosition[3])
end
