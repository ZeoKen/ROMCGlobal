autoImport("BaseTip")
autoImport("AdventureAppendTipCell")
AdventureAppendTip = class("AdventureAppendTip", BaseTip)

function AdventureAppendTip:Init()
  self.desc = self:FindComponent("Desc", UILabel)
  self.closeComp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closeComp.callBack()
    TipsView.Me():HideTip(AdventureAppendTip)
  end
  
  self.itemTable = self:FindComponent("ItemTable", UITable)
  self.itemList = ListCtrl.new(self.itemTable, AdventureAppendTipCell, "AdventureAppendTipCell")
end

function AdventureAppendTip:OnEnter()
  AdventureAppendTip.super.OnEnter(self)
end

function AdventureAppendTip:OnExit()
  AdventureAppendTip.super.OnExit(self)
  self.closeComp = nil
  return true
end

function AdventureAppendTip:SetData(data, forceOpen)
  if not forceOpen and (data == nil or data == "") then
    TipsView.Me():HideTip(AdventureAppendTip)
    return
  end
  self.data = data
  if data then
    self.itemList:ResetDatas(data.datas)
  end
end

function AdventureAppendTip:AddIgnoreBounds(obj)
  if self.gameObject and self.closeComp then
    self.closeComp:AddTarget(obj.transform)
  end
end

function AdventureAppendTip:SetCloseCall(closeCall, closeCallParam)
  self.closeCall = closeCall
  self.closeCallParam = closeCallParam
end

function AdventureAppendTip:DestroySelf()
  if not self:ObjIsNil(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end
