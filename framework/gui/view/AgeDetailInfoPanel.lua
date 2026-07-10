AgeDetailInfoPanel = class("AgeDetailInfoPanel", BaseView)
AgeDetailInfoPanel.ViewType = UIViewType.PopUpLayer
local bgTextureName = "pet_bg_bg04"

function AgeDetailInfoPanel:Init()
  self:InitData()
  self:AddEvt()
end

function AgeDetailInfoPanel:InitData()
  local viewdata = not self.viewdata or self.viewdata.viewdata or self.viewdata
  local title = self:FindComponent("Title", UILabel)
  title.text = viewdata and viewdata.title or ZhString.NewAgreeMentPanel_AgeDetailTitle
  local scrolMsg = self:FindComponent("Msg", UILabel)
  local agreeText = self:FindComponent("agreeText", UILabel)
  local cancelText = self:FindComponent("cancelText", UILabel)
  self.bgTexture = self:FindComponent("BGTexture", UITexture)
  scrolMsg.text = viewdata and viewdata.msg or ZhString.NewAgreeMentPanel_AgeDetailInfo
end

function AgeDetailInfoPanel:AddEvt()
end

function AgeDetailInfoPanel:OnEnter()
  AgeDetailInfoPanel.super.OnEnter(self)
  PictureManager.Instance:SetUI(bgTextureName, self.bgTexture)
end

function AgeDetailInfoPanel:OnExit()
  AgeDetailInfoPanel.super.OnExit(self)
  PictureManager.Instance:UnLoadUI(bgTextureName, self.bgTexture)
end
