autoImport("LotteryView")
autoImport("LotteryDetailCombineCell")
autoImport("LotteryRecoverCombineCell")
LotteryEquipView = class("LotteryEquipView", LotteryView)
LotteryEquipView.ViewType = LotteryView.ViewType
local wrapConfig = {}

function LotteryEquipView:FindObjs()
  LotteryEquipView.super.FindObjs(self)
  self.ticket = self:FindGO("Ticket"):GetComponent(UILabel)
  self.ticketCost = self:FindGO("TicketCost"):GetComponent(UILabel)
  self.costTip = self:FindGO("CostTip")
  self.ticketBtn = self:FindGO("TicketBtn")
  if BranchMgr.IsJapan() then
    self.helpButton = self:LoadPreferb("cell/HelpButtonCell", self.detailRoot)
    self.helpButton.transform.localPosition = LuaGeometry.GetTempVector3(224, 320, 0)
    self.helpButton.transform.localScale = LuaGeometry.GetTempVector3(0.8, 0.8, 1)
    self:AddClickEvent(self:FindGO("HelpButton", self.helpButton), function(go)
      if self.rateSb == nil then
        self.rateSb = LuaStringBuilder.CreateAsTable()
      else
        self.rateSb:Clear()
      end
      local lines = string.split(ZhString.EquipLotteryHelp, "\n")
      for _, v in pairs(lines) do
        self.rateSb:AppendLine(v)
      end
      TipsView.Me():ShowGeneralHelp(self.rateSb:ToString(), "")
    end)
  end
end

function LotteryEquipView:AddEvts()
  LotteryEquipView.super.AddEvts(self)
  self:AddClickEvent(self.ticketBtn, function()
    self:Ticket()
  end)
  local recoverReturnBtn = self:FindGO("RecoverReturnBtn")
  self:AddClickEvent(recoverReturnBtn, function()
    self:ShowRecover(false)
  end)
  self:AddClickEvent(self.recoverBtn.gameObject, function()
    self:Recover()
  end)
end

function LotteryEquipView:AddViewEvts()
  LotteryEquipView.super.AddViewEvts(self)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleItemUpdate)
end

function LotteryEquipView:InitShow()
  LotteryEquipView.super.InitShow(self)
  self.lotteryType = LotteryType.Equip
  self.recoverSelect = {}
  self.isUpdateRecover = true
  local detailContainer = self:FindGO("DetailContainer")
  self.detailHelper = WrapListCtrl.new(detailContainer, LotteryDetailCell, "LotteryEquipCell", WrapListCtrl_Dir.Vertical, 3, 135)
  self.detailHelper:AddEventListener(MouseEvent.MouseClick, self.ClickDetail, self)
  local container = self:FindGO("RecoverContainer")
  TableUtility.TableClear(wrapConfig)
  wrapConfig.wrapObj = container
  wrapConfig.pfbNum = 5
  wrapConfig.cellName = "LotteryRecoverCombineCell"
  wrapConfig.control = LotteryRecoverCombineCell
  wrapConfig.dir = 1
  self.recoverHelper = WrapCellHelper.new(wrapConfig)
  self.recoverHelper:AddEventListener(MouseEvent.MouseClick, self.ClickRecover, self)
  self.recoverHelper:AddEventListener(LotteryEvent.Select, self.SelectRecover, self)
  self:InitTicket()
  self:InitRecover()
  self:UpdateTicket()
  self:UpdateTicketCost()
  self:ShowRecover(false)
  self:InitView()
end

function LotteryEquipView:Ticket()
  self:CallTicket()
end

function LotteryEquipView:CallLottery(price, year, month, times)
  local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
  if data then
    local id = 294
    if data:IsPriceIncrease(self.lotteryType) then
      local dont = LocalSaveProxy.Instance:GetDontShowAgain(id)
      if dont == nil then
        MsgManager.DontAgainConfirmMsgByID(id, function()
          LotteryEquipView.super.CallLottery(self, price, year, month, times)
        end, nil, nil, self.costValue)
        return
      end
    else
      LocalSaveProxy.Instance:RemoveDontShowAgain(id)
    end
  end
  LotteryEquipView.super.CallLottery(self, price, year, month, times)
end

function LotteryEquipView:InitView()
  LotteryEquipView.super.InitView(self)
  local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
  if data then
    self:UpdateCost()
    self.detailHelper:ResetDatas(data.items)
  end
end

function LotteryEquipView:UpdateCost()
  local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
  if data then
    self.costTip:SetActive(not BranchMgr.IsSEA() and not BranchMgr.IsEU() and data:IsPriceIncrease(self.lotteryType))
  end
  LotteryEquipView.super.UpdateCost(self)
end

function LotteryEquipView:UpdateSkip()
  local isShow = FunctionFirstTime.me:IsFirstTime(FunctionFirstTime.LotteryEquip)
  self.skipBtn.gameObject:SetActive(not isShow)
end

function LotteryEquipView:ShowRecover(isShow)
  self.isShowRecover = isShow
  self.detailRoot:SetActive(not isShow)
  self.recoverRoot:SetActive(isShow)
end

function LotteryEquipView:HandleItemUpdate(note)
  self:UpdateTicket()
  if self.isShowRecover then
    self:TryUpdateRecover()
  else
    self.isUpdateRecover = true
  end
end
