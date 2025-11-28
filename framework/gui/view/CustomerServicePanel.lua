CustomerServicePanel = class("CustomerServicePanel", BaseView)
CustomerServicePanel.ViewType = UIViewType.PopUpLayer

function CustomerServicePanel:Init()
  self:InitData()
  self:AddEvt()
  self:UpdateServerList()
end

function CustomerServicePanel:InitData()
  self.title = self:FindComponent("title", UILabel)
  self.title.text = ZhString.CustomerServicePanel_Title
  self.serverlable = self:FindComponent("serverlable", UILabel)
  self.confirmBtn = self:FindGO("Confirm")
  self.cancelBtn = self:FindGO("Cancel")
  self.spHolder = self:FindComponent("SpHolder", UISprite)
  self.serverBg = self:FindGO("ServerBg")
end

function CustomerServicePanel:AddEvt()
  self:AddClickEvent(self.serverBg, function()
    if FunctionLogin.Me():getSdkEnable() then
      TipManager.Instance:ShowServerPopupList(self.spHolder, NGUIUtil.AnchorSide.Bottom, {0, -80})
    end
  end)
  self:AddClickEvent(self.confirmBtn, function()
    self:ConfirmClick()
  end)
  self:AddClickEvent(self.cancelBtn, function()
    self:CloseSelf()
  end)
  self:AddListenEvt(ServiceEvent.ChooseServer, self.HandlerSelectServer)
end

function CustomerServicePanel:HandlerSelectServer(note)
  if note ~= nil then
    self.serverData = note.body
    self:UpdateServerList()
  end
end

function CustomerServicePanel:UpdateServerList()
  if self.serverData then
    self.serverlable.text = self.serverData.name
  else
    self.serverlable.text = ZhString.StartGamePanel_NoChooseServer
  end
end

function CustomerServicePanel:ConfirmClick()
  if self.serverData and self.serverData.sid then
    helplog("serverid = ", self.serverData.serverid)
    helplog("sid = ", self.serverData.sid)
    helplog("accid = ", self.serverData.accid)
    FunctionSDK.Instance:EnterBugReport(self.serverData.sid, "NoEnter", self.serverData.accid)
  end
  self:CloseSelf()
end
