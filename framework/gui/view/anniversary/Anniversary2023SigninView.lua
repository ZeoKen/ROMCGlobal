autoImport("Anniversary2023SigninCell")
autoImport("ListCtrl")
Anniversary2023SigninView = class("Anniversary2023SigninView", BaseView)
Anniversary2023SigninView.ViewType = UIViewType.NormalLayer
local BgTextureName = "anniversary_bg_01"

function Anniversary2023SigninView:Init()
  self:FindObjs()
  self:AddEvts()
  self:UpdateView()
end

function Anniversary2023SigninView:FindObjs()
  local closeBtnGO = self:FindGO("CloseButton")
  self:AddClickEvent(closeBtnGO, function()
    self:CloseSelf()
  end)
  self.bgTex = self:FindComponent("BgTex", UITexture)
  self.subTitleLab_1 = self:FindComponent("SubTitle_1", UILabel)
  self.subTitleGroupTable = self:FindComponent("SubTitleGroup", UITable)
  local subTitleGroupGO = self.subTitleGroupTable.gameObject
  self.subTitleLab_2_1 = self:FindComponent("SubTitle_2_1", UILabel, subTitleGroupGO)
  self.subTitleLab_2_2 = self:FindComponent("SubTitle_2_2", UILabel, subTitleGroupGO)
  self.subTitleLab_2_3 = self:FindComponent("SubTitle_2_3", UILabel, subTitleGroupGO)
  local activityLinkGO = self:FindGO("ActivityLinkLab")
  self:AddClickEvent(activityLinkGO, function()
    local config = Anniversary2023Proxy.Instance:GetConfig()
    if not config or not config.ActivityUrl then
      return
    end
    Application.OpenURL(config.ActivityUrl)
  end)
  self.activityTimeLab = self:FindComponent("TimeLabel", UILabel)
  local helpBtnGO = self:FindGO("HelpBtn")
  self:RegistShowGeneralHelpByHelpID(35270, helpBtnGO)
  local ShareCellGO = self:FindGO("ShareCell")
  self.shareCell = Anniversary2023SigninCell.new(ShareCellGO)
  self.shareCell:AddEventListener(UICellEvent.OnRightBtnClicked, self.OnCellFuncClicked, self)
  self.contentListCtrl = ListCtrl.new(self:FindComponent("ContentGrid", UIGrid), Anniversary2023SigninCell, "Anniversary/Anniversary2023SigninCell")
  self.contentListCtrl:AddEventListener(UICellEvent.OnRightBtnClicked, self.OnCellFuncClicked, self)
end

function Anniversary2023SigninView:AddEvts()
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.ActivityCmdAnniversaryInfoSync, self.OnSyncInfo)
  self:AddDispatcherEvt(AnniversaryLive.OnActivityStart, self.UpdateView)
  self:AddDispatcherEvt(AnniversaryLive.OnActivityEnd, self.CloseSelf)
end

function Anniversary2023SigninView:OnEnter()
  Anniversary2023SigninView.super.OnEnter(self)
  PictureManager.Instance:SetActivityTexture(BgTextureName, self.bgTex)
  ServiceActivityCmdProxy.Instance:CallAnniversaryInfoSync()
end

function Anniversary2023SigninView:OnExit()
  Anniversary2023SigninView.super.OnExit(self)
  PictureManager.Instance:UnloadActivityTexture(BgTextureName, self.bgTex)
end

function Anniversary2023SigninView:OnSyncInfo()
  self:UpdateDynamicContents(true)
end

function Anniversary2023SigninView:UpdateView()
  self:UpdateStaticContents()
  self:UpdateDynamicContents(true)
end

function Anniversary2023SigninView:UpdateStaticContents()
  local actData = Anniversary2023Proxy.Instance:GetActData()
  if not actData then
    return
  end
  local config = actData:GetConfig()
  if not config then
    return
  end
  local params = config.Params
  self.subTitleLab_1.text = params.SubTitle_1 or ""
  if params.SubTitle_2_1 then
    self.subTitleLab_2_1.text = params.SubTitle_2_1
  end
  if params.SubTitle_2_2 then
    self.subTitleLab_2_2.text = params.SubTitle_2_2
  end
  if params.SubTitle_2_3 then
    self.subTitleLab_2_3.text = params.SubTitle_2_3
  end
  self.activityTimeLab.text = actData:GetSigninPeriodStr()
end

function Anniversary2023SigninView:UpdateDynamicContents(scrollToActive)
  local actData = Anniversary2023Proxy.Instance:GetActData()
  if not actData then
    return
  end
  if actData.extraData then
    self.shareCell:SetData(actData.extraData)
  end
  self.contentListCtrl:ResetDatas(actData.dataList or {})
  if scrollToActive then
    self.contentListCtrl:ScrollToIndex(actData.scrollToIndex)
  end
end

function Anniversary2023SigninView:OnCellFuncClicked(cell)
  if ApplicationInfo.IsRunOnWindowns() then
    MsgManager.ShowMsgByID(43486)
    return
  end
  local cellData = cell.cellData
  if not cellData then
    return
  end
  if cellData.isShare and not cellData:CanTakeReward() then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.Anniversary2023ShareView,
      viewdata = {}
    })
  else
    Anniversary2023Proxy.Instance:TakeReward(cellData)
  end
end
