ChargeComfirmPanel = class("ChargeComfirmPanel", BaseView)
ChargeComfirmPanel.ViewType = UIViewType.PopUpLayer
ChargeComfirmPanel.left = nil

function ChargeComfirmPanel:Init()
  self.actBtn = self:FindGO("OkBtn")
  self:AddClickEvent(self.actBtn, function(go)
    EventManager.Me():PassEvent(ChargeLimitPanel.RefreshZenyCell)
    self.super.CloseSelf(self)
  end)
  self.sprActBtn = self.actBtn:GetComponent(UISprite)
  self.labActBtn = self:FindComponent("title", UILabel, self.actBtn)
  self.colActBtn = self.actBtn:GetComponent(Collider)
  self.colorActLabEffect = self.labActBtn.effectColor
  self.cancelBtn = self:FindGO("CancelBtn")
  self:AddClickEvent(self.cancelBtn, function(go)
    MsgManager.FloatMsg("", ZhString.ChargeLimitFloat)
    self:CloseSelf()
  end)
  self.content1 = self:FindGO("Content1"):GetComponent(UILabel)
  self:AddListenEvt(ServiceEvent.OverseasTaiwanCmdOverseasChargeLimitGetChargeCmd, self.ChargeLimitGetChargeCmd)
end

function ChargeComfirmPanel:OnEnter()
  self.super.OnEnter(self)
  self.colActBtn.enabled = false
  self.sprActBtn.color = LuaGeometry.GetTempColor(0.00392156862745098, 0.00784313725490196, 0.011764705882352941)
  self.labActBtn.effectColor = LuaGeometry.GetTempColor(0.615686274509804, 0.615686274509804, 0.615686274509804)
  local delayTime = GameConfig.ZenyShop and GameConfig.ZenyShop.ChargeLimitDelay or 5
  self.ltCallLimit = TimeTickManager.Me():CreateOnceDelayTick(delayTime * 1000, function(owner, deltaTime)
    self.ltCallLimit = nil
    MsgManager.ShowMsgByID(31030)
    self:CloseSelf()
  end, self)
  ServiceOverseasTaiwanCmdProxy.Instance:CallOverseasChargeLimitGetChargeCmd()
end

function ChargeComfirmPanel:OnExit()
  if self.ltCallLimit then
    self.ltCallLimit:Destroy()
    self.ltCallLimit = nil
  end
  self.super.OnExit(self)
end

function ChargeComfirmPanel:CloseSelf()
  EventManager.Me():PassEvent(ChargeLimitPanel.CloseZeny, self)
  self.super.CloseSelf(self)
end

function ChargeComfirmPanel:SetActBtnActive()
  self.colActBtn.enabled = true
  self.sprActBtn.color = LuaGeometry.GetTempColor(1, 1, 1)
  self.labActBtn.effectColor = self.colorActLabEffect
end

function ChargeComfirmPanel:ChargeLimitGetChargeCmd(note)
  if self.ltCallLimit then
    self.ltCallLimit:Destroy()
    self.ltCallLimit = nil
  end
  local Count = Table_ChargeLimit[self.viewdata.cid].Count
  helplog("ChargeComfirmPanel:ChargeLimitGetChargeCmd", note.body and note.body.charge, self.viewdata.cid, Count)
  if note.body and Count ~= nil then
    ChargeComfirmPanel.left = Table_ChargeLimit[self.viewdata.cid].Count
    self:ReduceLeft(note.body.charge)
    self.content1.text = string.format(ZhString.ChargeLimit, tostring(ChargeComfirmPanel.left))
  else
    ChargeComfirmPanel.left = nil
    self.content1.text = ZhString.ChargeUnLimit
  end
  self:SetActBtnActive()
end

function ChargeComfirmPanel:ReduceLeft(count)
  helplog("ChargeComfirmPanel:ReduceLeft", count, ChargeComfirmPanel.left)
  if ChargeComfirmPanel.left ~= nil then
    ChargeComfirmPanel.left = ChargeComfirmPanel.left - count
    ChargeComfirmPanel.left = ChargeComfirmPanel.left > 0 and ChargeComfirmPanel.left or 0
  end
end
