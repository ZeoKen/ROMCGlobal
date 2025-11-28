autoImport("GemProfessionCell")
GemProfessionTip = class("GemProfessionTip", BaseTip)

function GemProfessionTip:Init()
  self:FindObj()
end

function GemProfessionTip:FindObj()
  self.uiTable = self:FindComponent("Table", UITable)
  self.professionCtl = UIGridListCtrl.new(self.uiTable, GemProfessionCell, "GemProfessionCell")
  self.professionCtl:AddEventListener(GemEvent.ClickProfession, self.OnClickProfession, self)
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
end

function GemProfessionTip:OnClickProfession(classid)
  if GemProxy.Instance.startChooseTargetProfession then
    GemProxy.Instance:SetCurTargetProfession(classid)
    GameFacade.Instance:sendNotification(GemEvent.ChooseTargetProfession, classid)
    EventManager.Me():PassEvent(GemEvent.ChooseTargetProfession, classid)
  elseif GemProxy.Instance.newProfession ~= classid then
    GemProxy.Instance:SetCurNewProfessionFilterData(classid)
    EventManager.Me():PassEvent(GemEvent.ProfessionChanged, classid)
    GameFacade.Instance:sendNotification(GemEvent.ProfessionChanged, classid)
  end
  self:CloseSelf()
end

function GemProfessionTip:SetData(data)
  self.professionCtl:ResetDatas(data)
end

function GemProfessionTip:CloseSelf()
  TipsView.Me():HideCurrent()
  GemProxy.Instance:ClearTargetProChooseFlag()
end

function GemProfessionTip:DestroySelf()
  if not Slua.IsNull(self.gameObject) then
    GameObject.Destroy(self.gameObject)
    GemProxy.Instance:ClearTargetProChooseFlag()
  end
end

function GemProfessionTip:OnExit()
  self.professionCtl:RemoveAll()
  return GemProfessionTip.super.OnExit(self)
end
