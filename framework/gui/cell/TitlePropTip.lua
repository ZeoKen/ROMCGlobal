autoImport("BaseTip")
autoImport("GAstrolabeAttriCell")
TitlePropTip = class("TitlePropTip", BaseTip)

function TitlePropTip:Init()
  local propGrid = self:FindComponent("propGrid", UIGrid)
  self.propCtl = UIGridListCtrl.new(propGrid, GAstrolabeAttriCell, "TitlelabeAttriCell")
  self.noneTip = self:FindGO("NoneTip")
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closecomp.callBack(go)
    TipsView.Me():HideCurrent()
  end
  
  TitlePropTip.super.Init(self)
end

function TitlePropTip:SetData()
  local props = TitleProxy.Instance:GetAllTitleProp()
  local data = {}
  for k, v in pairs(props) do
    local cdata = {k, v}
    table.insert(data, cdata)
  end
  self.propCtl:ResetDatas(data)
  self.noneTip:SetActive(#data == 0)
end

function TitlePropTip:AddIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end

function TitlePropTip:CloseSelf()
  if not self:ObjIsNil(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end

function TitlePropTip:DestroySelf()
  if not Slua.IsNull(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end
