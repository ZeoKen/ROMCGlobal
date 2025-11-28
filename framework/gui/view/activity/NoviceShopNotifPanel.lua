NoviceShopNotifPanel = class("NoviceShopNotifPanel", ContainerView)
NoviceShopNotifPanel.ViewType = UIViewType.NormalLayer
local picName = "xinshou_banner"

function NoviceShopNotifPanel:Init()
  self:InitObjEvents()
end

function NoviceShopNotifPanel:OnEnter()
  NoviceShopNotifPanel.super.OnEnter(self)
  self.endtime = NoviceShopProxy.Instance:GetEndDate()
  if not self.endtime then
    self:CloseSelf()
    return
  end
  self:InitData()
  LocalSaveProxy.Instance:SetNoviceShopOpened(ServerTime.CurServerTime() / 1000)
end

function NoviceShopNotifPanel:InitData()
  TimeTickManager.Me():CreateTick(0, 1000, self.updateActivityTime, self)
end

function NoviceShopNotifPanel:InitObjEvents()
  self.photo = self:FindComponent("photo", UITexture)
  PictureManager.Instance:SetActivityTexture(picName, self.photo)
  self.GoLabel = self:FindComponent("GoLabel", UILabel)
  self.GoLabel.text = ZhString.ActivityData_GoLabelText
  self.ViewDetailLabel = self:FindComponent("ViewDetailLabel", UILabel)
  self.ViewDetailLabel.text = ZhString.NoviceShop_Later
  self.countTimeLabel = self:FindComponent("countTimeLabel", UILabel)
  self.ViewDetailButtonSp = self:FindComponent("ViewDetailButton", UISprite)
  self.ViewDetailButtonCl = self:FindComponent("ViewDetailButton", BoxCollider)
  self:AddButtonEvent("GoButton", function(go)
    self:sendNotification(MainViewEvent.ClearViewSequence)
    self:GotoView()
  end)
  self:AddButtonEvent("ViewDetailButton", function(go)
    self:CloseSelf()
  end)
end

function NoviceShopNotifPanel:GotoView()
  local stype, sid = NoviceShopProxy.Instance:GetShopConfig()
  if stype and sid then
    NoviceShopProxy.Instance:CallQueryShopConfig()
  elseif NoviceShopProxy.Instance:CheckValidTime() then
    MsgManager.ShowMsgByID(40973)
  end
end

function NoviceShopNotifPanel:updateActivityTime()
  local leftTime = self.endtime - ServerTime.CurServerTime() / 1000
  local preText = ZhString.ActivityData_Finish
  if 86400 <= leftTime then
    local day = math.floor(leftTime / 86400)
    local h = math.floor((leftTime - day * 3600 * 24) / 3600)
    self.countTimeLabel.text = string.format(ZhString.ActivityData_SubActHourDes, day, h, preText)
  else
    local h = math.floor(leftTime / 3600)
    local m = math.floor((leftTime - h * 3600) / 60)
    local s = leftTime - h * 3600 - m * 60
    self.countTimeLabel.text = string.format(ZhString.ActivityData_SubActTimeLineDes, h, m, s, preText)
  end
end

function NoviceShopNotifPanel:OnExit()
  NoviceShopNotifPanel.super.OnExit(self)
  PictureManager.Instance:UnloadActivityTexture(picName, self.photo)
  TimeTickManager.Me():ClearTick(self)
end
