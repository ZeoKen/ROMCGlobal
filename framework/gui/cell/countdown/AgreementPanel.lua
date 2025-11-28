autoImport("AdventureIndicatorCell")
AgreementPanel = class("AgreementPanel", BaseView)
AgreementPanel.ViewType = UIViewType.PopUpLayer

function AgreementPanel:Init()
  self.title = self:FindComponent("Title", UILabel)
  self.text = self:FindComponent("Text", UILabel)
  self.button = self:FindGO("Button")
  self.agreeBtn = self:FindGO("AgreeBtn")
  self.agreeBtnLabel = self:FindGO("Label", self.agreeBtn):GetComponent(UILabel)
  self.disAgreeBtn = self:FindGO("DisAgreeBtn")
  self.dragCollider = self:FindGO("Collier")
  self.indicatorCt = self:FindGO("indicatorCt")
  local grid = self:FindComponent("indicatorGrid", UIGrid)
  self.indicatorGrid = UIGridListCtrl.new(grid, AdventureIndicatorCell, "AdventureIndicatorCell")
  self.buttonlab = self:FindComponent("Label", UILabel, self.button)
  self.content = self.viewdata.content
  if self.content == 1 then
    self.button.gameObject:SetActive(true)
    self.agreeBtn.gameObject:SetActive(false)
    self.disAgreeBtn.gameObject:SetActive(false)
    self.title.text = ZhString.StartGamePanel_AgreetmentTitle
    self.buttonlab.text = ZhString.ServiceErrorUserCmdProxy_Confirm
    self.text.text = ZhString.StartGamePanel_AgreetmentContent
  elseif self.content == 2 then
    self.button.gameObject:SetActive(true)
    self.agreeBtn.gameObject:SetActive(false)
    self.disAgreeBtn.gameObject:SetActive(false)
    self.title.text = ZhString.StartGamePanel_networkPrivactTitle
    self.buttonlab.text = ZhString.ServiceErrorUserCmdProxy_Confirm
    self.text.text = ZhString.StartGamePanel_networkPrivacyContent
  elseif self.content == 3 then
    self.button.gameObject:SetActive(false)
    self.agreeBtn.gameObject:SetActive(true)
    self.disAgreeBtn.gameObject:SetActive(true)
    self.title.text = ZhString.StartGamePanel_AgreeAndPrivacyTitle
    self.buttonlab.text = ZhString.ServiceErrorUserCmdProxy_Confirm
    self.text.text = ZhString.StartGamePanel_AgreetmentContent
  end
  self.delta = 0
  self.curShowIndex = 1
  self:AddDragEvent(self.dragCollider, function(obj, delta)
    if math.abs(delta.x) > 40 then
      self.delta = delta.x
    end
  end)
  UIEventListener.Get(self.dragCollider).onDragEnd = function(obj)
    if math.abs(self.delta) > 40 then
      self:hangDrag(self.delta)
    end
  end
  self:AddClickEvent(self.button, function()
    self:CloseSelf()
  end)
  self:AddClickEvent(self.agreeBtn, function()
    GameFacade.Instance:sendNotification(NewLoginEvent.ConfirmAgreement)
    self:CloseSelf()
  end)
  self:AddClickEvent(self.disAgreeBtn, function()
    self:CloseSelf()
  end)
  self:InitShow()
end

function AgreementPanel:InitShow()
  self:UpdateIndicator()
end

function AgreementPanel:UpdateIndicator()
  if self.content == 3 then
    self.indicatorCt.gameObject:SetActive(true)
    local list = {}
    for i = 1, 2 do
      local data = {}
      if i == self.curShowIndex then
        data.cur = true
      end
      table.insert(list, data)
      self.indicatorGrid:ResetDatas(list)
    end
  else
    self.indicatorCt.gameObject:SetActive(false)
  end
end

function AgreementPanel:hangDrag(delta)
  if delta < 0 then
    self:goRight()
  elseif 0 < delta then
    self:goLeft()
  end
end

function AgreementPanel:goLeft()
  if self.curShowIndex > 1 then
    self.curShowIndex = self.curShowIndex - 1
    self:RefreshText()
    self:UpdateIndicator()
  end
end

function AgreementPanel:goRight()
  if self.curShowIndex < 2 then
    self.curShowIndex = self.curShowIndex + 1
    self:RefreshText()
    self:UpdateIndicator()
  end
end

function AgreementPanel:RefreshText()
  if self.curShowIndex == 1 then
    self.title.text = ZhString.StartGamePanel_AgreetmentTitle
    self.text.text = ZhString.StartGamePanel_AgreetmentContent
  elseif self.curShowIndex == 2 then
    self.title.text = ZhString.StartGamePanel_networkPrivactTitle
    self.text.text = ZhString.StartGamePanel_networkPrivacyContent
  end
  if self.agreeBtnLabel.text ~= ZhString.InviteConfirmView_Agree then
    self.agreeBtnLabel.text = ZhString.InviteConfirmView_Agree
  end
end
