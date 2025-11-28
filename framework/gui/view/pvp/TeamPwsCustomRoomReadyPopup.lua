autoImport("BaseView")
autoImport("TeamPwsCustomRoomReadyCell")
TeamPwsCustomRoomReadyPopup = class("TeamPwsCustomRoomReadyPopup", BaseView)
TeamPwsCustomRoomReadyPopup.ViewType = UIViewType.ConfirmLayer
local prepareTime = 30
local orange = LuaColor.New(0.6196078431372549, 0.33725490196078434, 0 / 255, 1)
local blue = LuaColor.New(0.14901960784313725, 0.24313725490196078, 0.5490196078431373, 1)
local grey = LuaColor.New(0.4235294117647059, 0.4235294117647059, 0.4235294117647059, 1)

function TeamPwsCustomRoomReadyPopup:Init()
  self.gridMyTeam = self:FindComponent("gridMyTeam", UIGrid)
  self.listMyTeam = UIGridListCtrl.new(self.gridMyTeam, TeamPwsCustomRoomReadyCell, "TeamPwsCustomRoomReadyCell")
  local gridGroupTeam = self:FindComponent("gridGroupTeam", UIGrid)
  self.listGroupTeam = UIGridListCtrl.new(gridGroupTeam, TeamPwsCustomRoomReadyCell, "TeamPwsCustomRoomReadyCell")
  self.sliderCountDown = self:FindComponent("SliderCountDown", UISlider)
  self.labCountDown = self:FindComponent("labCountDown", UILabel)
  self.cancelBtn = self:FindGO("cancelBtn"):GetComponent(UIButton)
  self:AddClickEvent(self.cancelBtn.gameObject, function()
    self:OnCancelClicked()
  end)
  self.readyBtn = self:FindGO("readyBtn"):GetComponent(UIButton)
  self:AddClickEvent(self.readyBtn.gameObject, function()
    self:OnConfirmClicked()
  end)
  self.cancelBtnLab = self:FindGO("Label", self.cancelBtn.gameObject):GetComponent(UILabel)
  self.readyBtnLab = self:FindGO("Label", self.readyBtn.gameObject):GetComponent(UILabel)
  self.labMatch = self:FindGO("labMatchSuccess"):GetComponent(UILabel)
  self.closeBtn = self:FindGO("closeBtn"):GetComponent(UIButton)
  self:AddClickEvent(self.closeBtn.gameObject, function()
    self:OnCloseClicked()
  end)
  self.minBtnGO = self:FindGO("BtnMin")
  self:AddClickEvent(self.minBtnGO, function()
    self:OnCloseClicked()
  end)
  self:AddDispatcherEvt(CustomRoomEvent.OnReadyStateUpdate, self.UpdateView)
  self:AddDispatcherEvt(CustomRoomEvent.OnReadyUpdate, self.UpdateCountDown)
  self:AddDispatcherEvt(CustomRoomEvent.OnReadyEnd, self.CloseSelf)
  self:UpdateView()
end

function TeamPwsCustomRoomReadyPopup:UpdateCountDown()
  local proxy = PvpCustomRoomProxy.Instance
  self.labCountDown.text = string.format("%ss", math.ceil(proxy.readyTimeLeft or 0))
  self.sliderCountDown.value = proxy.readyLeftTimePercent or 0
end

function TeamPwsCustomRoomReadyPopup:UpdateView()
  local proxy = PvpCustomRoomProxy.Instance
  self.listMyTeam:ResetDatas(proxy.readyHomeMembers or {})
  self.listGroupTeam:ResetDatas(proxy.readyAwayMembers or {})
  local myselfCharId = Game.Myself.data.id
  local showClose = proxy:IsOb(myselfCharId) or proxy:IsUserReady(myselfCharId) ~= nil or not proxy:IsInReadyMemberList(myselfCharId)
  self.closeBtn.gameObject:SetActive(showClose)
  self.cancelBtn.gameObject:SetActive(not showClose)
  self.readyBtn.gameObject:SetActive(not showClose)
end

function TeamPwsCustomRoomReadyPopup:OnCloseClicked()
  self:CloseSelf()
end

function TeamPwsCustomRoomReadyPopup:OnCancelClicked()
  PvpCustomRoomProxy.Instance:SendReadyResp(false, false)
end

function TeamPwsCustomRoomReadyPopup:OnConfirmClicked()
  PvpCustomRoomProxy.Instance:SendReadyResp(false, true)
end
