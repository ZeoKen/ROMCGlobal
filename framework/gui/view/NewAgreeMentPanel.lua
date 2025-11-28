NewAgreeMentPanel = class("NewAgreeMentPanel", BaseView)
NewAgreeMentPanel.ViewType = UIViewType.PopUpLayer
local privacyPolicy = GameConfig.PrivacyPolicy

function NewAgreeMentPanel:Init()
  self:InitData()
  self:AddEvt()
end

function NewAgreeMentPanel:InitData()
  local title = self:FindComponent("Title", UILabel)
  title.text = ZhString.NewAgreeMentPanel_Title
  local scrolMsg = self:FindComponent("Msg", UILabel)
  local labTitle = self:FindComponent("labTitle", UILabel)
  local agreeLable = self:FindComponent("agreeLable", UILabel)
  local childLable = self:FindComponent("serLable", UILabel)
  local priLable = self:FindComponent("priLable", UILabel)
  self.agreeBtn = self:FindGO("AgreeBut")
  self.cncelBtn = self:FindGO("CancelBut")
  labTitle.text = ZhString.NewAgreeMentPanel_TipTi
  childLable.text = ZhString.NewAgreeMentPanel_ChildInfoLable
  agreeLable.text = ZhString.NewAgreeMentPanel_AgreetmentLabel
  priLable.text = ZhString.NewAgreeMentPanel_networkPrivacyLabel
  if self.viewdata.agreeHandle then
    scrolMsg.text = ZhString.NewAgreeMentPanel_AgreetmentContent_Update
  else
    scrolMsg.text = ZhString.NewAgreeMentPanel_AgreetmentContent
  end
end

function NewAgreeMentPanel:AddEvt()
  self:AddClickEvent(self.agreeBtn, function()
    GameFacade.Instance:sendNotification(NewLoginEvent.ConfirmAgreement)
    if self.viewdata.agreeHandle then
      self.viewdata.agreeHandle()
    end
    self:CloseSelf()
  end)
  self:AddClickEvent(self.cncelBtn, function()
    if self.viewdata.refuseHandle then
      self.viewdata.refuseHandle()
    end
    self:CloseSelf()
  end)
  self:AddButtonEvent("agreeLable", function()
    if privacyPolicy and privacyPolicy.XDservice then
      self:OpenUrlView(privacyPolicy.XDservice)
    end
  end)
  self:AddButtonEvent("serLable", function()
    if privacyPolicy and privacyPolicy.ChildrenProtect then
      self:OpenUrlView(privacyPolicy.ChildrenProtect)
    end
  end)
  self:AddButtonEvent("priLable", function()
    if privacyPolicy and privacyPolicy.PrivacyProtect then
      self:OpenUrlView(privacyPolicy.PrivacyProtect)
    end
  end)
end

function NewAgreeMentPanel:OpenUrlView(url)
  Application.OpenURL(url)
end
