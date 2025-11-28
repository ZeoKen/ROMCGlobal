autoImport("WeeklyTaskCell")
TwelvePVPWeeklyTaskPopUp = class("TwelvePVPWeeklyTaskPopUp", BaseView)
TwelvePVPWeeklyTaskPopUp.ViewType = UIViewType.PopUpLayer

function TwelvePVPWeeklyTaskPopUp:Init()
  self:FindObjs()
  self:InitList()
  self:AddViewEvts()
  self:AddButtonEvts()
end

function TwelvePVPWeeklyTaskPopUp:FindObjs()
  local title = self:FindComponent("Title", UILabel)
  title.text = ZhString.TwelvePVP_WeeklyTask
end

function TwelvePVPWeeklyTaskPopUp:InitList()
  self.listRewards = UIGridListCtrl.new(self:FindComponent("rewardContainer", UIGrid), WeeklyTaskCell, "WeeklyTaskCell")
  self.listRewards:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self)
end

function TwelvePVPWeeklyTaskPopUp:AddViewEvts()
end

function TwelvePVPWeeklyTaskPopUp:AddButtonEvts()
  self:AddCloseButtonEvent()
  local helpBtn = self:FindGO("helpBtn")
  local helpId = PanelConfig.TwelvePVPWeeklyTaskPopUp.id
  self:RegistShowGeneralHelpByHelpID(helpId, helpBtn)
end

function TwelvePVPWeeklyTaskPopUp:UpdateView(note)
  local list = TwelvePvPProxy.Instance:GetTaskDatas()
  self.listRewards:ResetDatas(list)
end

function TwelvePVPWeeklyTaskPopUp:ClickItem(item)
  local data = {
    itemdata = item.data,
    funcConfig = {},
    noSelfClose = false,
    hideGetPath = false
  }
  self:ShowItemTip(data, item.icon, NGUIUtil.AnchorSide.Left, {-168, -28})
end

function TwelvePVPWeeklyTaskPopUp:OnEnter()
  TwelvePVPWeeklyTaskPopUp.super.OnEnter(self)
  self:UpdateView()
end
