autoImport("DailyDepositCell")
DailyDepositView = class("DailyDepositView", ContainerView)
DailyDepositView.ViewType = UIViewType.NormalLayer

function DailyDepositView:Init()
  self:InitView()
  self:AddViewEvts()
  self:UpdateView()
end

function DailyDepositView:OnEnter()
  DailyDepositView.super.OnEnter(self)
  local picManager = PictureManager.Instance
  if self.npcTexture and self.npcImageName then
    picManager:SetDailyDepositTexture(self.npcImageName, self.npcTexture)
  end
end

function DailyDepositView:OnExit()
  DailyDepositView.super.OnExit(self)
  local picManager = PictureManager.Instance
  if self.npcTexture and self.npcImageName then
    picManager:UnloadDalyDepositTexture(self.npcImageName, self.npcTexture)
  end
  TipManager.Instance:CloseTip()
end

function DailyDepositView:InitView()
  local helpBtnGO = self:FindGO("HelpBtn")
  self:TryOpenHelpViewById(PanelConfig.DailyDepositView.id, nil, helpBtnGO)
  self:AddButtonEvent("CloseButton", function()
    self:CloseSelf()
  end)
  local bgGO = self:FindGO("Bg")
  self.npcTexture = self:FindComponent("Npc", UITexture, bgGO)
  self.titleLabel = self:FindComponent("Title", UILabel, bgGO)
  self.dialogLabel = self:FindComponent("Dialog", UILabel, bgGO)
  self.timeLabel = self:FindComponent("TimeLabel", UILabel)
  self.buyGroupGO = self:FindGO("BuyGroup")
  self.buyBtnGO = self:FindGO("BuyBtn", self.buyGroupGO)
  self:AddClickEvent(self.buyBtnGO, function()
    self:OnPurchaseClicked()
  end)
  self.depositLabel = self:FindComponent("DepositLabel", UIRichLabel, self.buyGroupGO)
  self.depositLabel = SpriteLabel.new(self.depositLabel, 500, 32, 32)
  self.rewardListGO = self:FindGO("RewardList")
  self.rewardListCtrl = ListCtrl.new(self:FindComponent("Container", UIGrid, self.rewardListGO), DailyDepositCell, "DailyDepositCell")
  self.rewardListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnCellClicked, self)
end

function DailyDepositView:OnPurchaseClicked()
  FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit)
end

function DailyDepositView.OpenUI()
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.DailyDepositView
  })
end

function DailyDepositView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.SceneUser3DailyDepositInfo, self.UpdateView)
end

function DailyDepositView:UpdateLeftContent()
  local proxy = DailyDepositProxy.Instance
  local config = proxy:GetConfig()
  if config then
    self.npcImageName = config.NpcImage
    self.titleLabel.text = config.Title or ""
    self.dialogLabel.text = config.Dialog or ""
  end
end

function DailyDepositView:UpdateView()
  self:UpdateLeftContent()
  self:UpdateActivityTime()
  self:UpdateDepositInfo()
  self:UpdateCells()
end

function DailyDepositView:UpdateActivityTime()
  local proxy = DailyDepositProxy.Instance
  self.timeLabel.text = proxy:GetActivityPeriodStr()
end

function DailyDepositView:UpdateDepositInfo()
  local proxy = DailyDepositProxy.Instance
  local deposit = proxy:GetTotalDeposit() or 0
  deposit = string.format(ZhString.DailyDepositTotalInfo, 151, deposit)
  self.depositLabel:SetText(deposit)
  self.depositLabel:SetText(deposit)
end

function DailyDepositView:UpdateCells()
  local proxy = DailyDepositProxy.Instance
  self.rewardListCtrl:ResetDatas(proxy:GetRewardDatas())
end

function DailyDepositView:OnCellClicked(cell)
  if not cell or not cell.data then
    return
  end
  local proxy = DailyDepositProxy.Instance
  proxy:TakeReward(cell.data.id)
end
