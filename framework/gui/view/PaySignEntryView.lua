autoImport("PaySignConfig")
autoImport("PetWorkSpaceEmoji")
PaySignEntryView = class("PaySignEntryView", ContainerView)
PaySignEntryView.ViewType = UIViewType.NormalLayer
local BG_TEX = {
  "shop_bg_05",
  "sign_bg_baoxiang2",
  "com_bottom_bubble"
}
local _purchase_Interval = GameConfig.PurchaseMonthlyVIP.interval / 1000
local _rewardPath = ResourcePathHelper.UICell("PetWorkSpaceEmoji")

function PaySignEntryView:Init()
  self.actID = self.viewdata.viewdata.id
  self.actConfigData = PaySignConfig.new(self.actID)
  self:FindObjs()
  self:AddEvts()
  self:InitView()
end

function PaySignEntryView:OnEnter()
  self.super.OnEnter(self)
  PictureManager.Instance:SetRecall(self.actConfigData:GetBgTexture(), self.bgTexture)
  PictureManager.Instance:SetUI(BG_TEX[1], self.bgTexture1)
  PictureManager.Instance:SetPaySignIn(BG_TEX[2], self.bgTexture2)
  PictureManager.Instance:SetPaySignIn(BG_TEX[3], self.freeRewardTexture)
end

function PaySignEntryView:OnExit()
  self.super.OnExit(self)
  TipsView.Me():HideCurrent()
  PictureManager.Instance:UnLoadUI(BG_TEX[1], self.bgTexture1)
  PictureManager.Instance:UnLoadRecall(self.actConfigData:GetBgTexture(), self.bgTexture)
  PictureManager.Instance:UnLoadPaySignIn(BG_TEX[2], self.bgTexture2)
  PictureManager.Instance:UnLoadPaySignIn(BG_TEX[3], self.freeRewardTexture)
  ServiceSceneTipProxy.Instance:CallBrowseRedTipCmd(SceneTip_pb.EREDSYS_PAY_SIGN_BUY)
end

function PaySignEntryView:FindObjs()
  self:InitFreeReward()
  self.bgTexture = self:FindComponent("BgTexture", UITexture)
  self.bgTexture1 = self:FindComponent("BgTexture1", UITexture)
  self.bgTexture2 = self:FindComponent("BgTexture2", UITexture)
  self.descLab = self:FindComponent("DescLab", UILabel)
  self.descLab3 = self:FindComponent("DescLab3", UILabel)
  self.timeLab = self:FindComponent("TimeLab", UILabel)
  self.rewardDesc = self:FindComponent("RewardDesc", UILabel)
  self.purchaseBtn = self:FindGO("PurchaseButton")
  self.costIcon = self:FindComponent("Cost", UISprite, self.purchaseBtn)
  self.lotteryCostLab = self:FindComponent("LotteryCostLab", UILabel, self.purchaseBtn)
  if self.actConfigData:IsNoviceMode() then
    self:Hide(self.costIcon)
    self.lotteryCostLab.pivot = UIWidget.Pivot.Center
    self.lotteryCostLab.transform.localPosition = LuaGeometry.GetTempVector3(0, 4, 0)
  else
    self:Show(self.costIcon)
    local icon_name = Table_Item[self.actConfigData.rechargeItemId].Icon or {}
    IconManager:SetItemIcon(icon_name, self.costIcon)
    self.lotteryCostLab.pivot = UIWidget.Pivot.Left
    self.lotteryCostLab.transform.localPosition = LuaGeometry.GetTempVector3(14, 4, 0)
  end
  self.lotteryCostLab.text = self.actConfigData:GetLotteryCostDesc()
  self:AddClickEvent(self.purchaseBtn, function()
    self:OnPurchase()
  end)
  self.effectParent = self:FindGO("Effect")
  self:PlayUIEffect(EffectMap.UI.PaySignEntryView, self.effectParent)
end

local _Scale = 1.2

function PaySignEntryView:InitFreeReward()
  self.freeRewardTexture = self:FindComponent("FreeRewardTexture", UITexture)
  self:Hide(self.freeRewardTexture)
  local rewardGO = self:LoadPreferb_ByFullPath(_rewardPath, self.freeRewardTexture.gameObject)
  rewardGO.transform.localPosition = LuaGeometry.GetTempVector3()
  rewardGO.transform.localScale = LuaGeometry.GetTempVector3(_Scale, _Scale, _Scale)
  self.rewardEmoji = PetWorkSpaceEmoji.new(rewardGO)
  self.rewardEmoji:AddEventListener(MouseEvent.MouseClick, self.OnClickFreeReward, self)
  self.rewardEmoji:SetData("paySignReward")
end

function PaySignEntryView:OnClickFreeReward()
  ServiceNUserProxy.Instance:CallPaySignRewardUserCmd(self.actID, nil, true)
end

function PaySignEntryView:AddEvts()
  self:AddListenEvt(ServiceEvent.NUserPaySignBuyUserCmd, self.HandlePurchase)
  self:AddListenEvt(ServiceEvent.NUserPaySignRewardUserCmd, self.UpdateFreeReward)
end

local STR_FORMAT = "%s %s"

function PaySignEntryView:InitView()
  self.timeLab.text = PaySignProxy.Instance:GetLotteryTime(self.actID)
  self.descLab.text = self.actConfigData:GetEntryDesc1Concat2()
  self.descLab3.text = self.actConfigData:GetEntryRechargeDesc()
  self.rewardDesc.text = ZhString.PaySignEntryView_RewardDesc
  self:InitReward()
  self:UpdateFreeReward()
end

function PaySignEntryView:UpdateFreeReward()
  local var = PaySignProxy.Instance:HasFreeReward(self.actID)
  self.freeRewardTexture.gameObject:SetActive(var)
end

function PaySignEntryView:InitReward()
  PaySignProxy.Instance:PreprocessPaySign()
  local lastDayObj = self:LoadPreferb("cell/PaySignItemCell", self:FindGO("LastDayReward"))
  self.lastDayReward = BaseItemCell.new(lastDayObj)
  local data = PaySignProxy.Instance:GetConfig_PaySign(self.actID)
  self.lastDayReward:SetData(data[#data])
  self.lastDayReward:AddEventListener(MouseEvent.MouseClick, self.OnClickRewardItem, self)
  local bg = self.lastDayReward:GetBgSprite()
  if bg then
    bg.gameObject:SetActive(false)
  end
  local grid = self:FindGO("RewardGrid"):GetComponent(UIGrid)
  self.rewardCtl = UIGridListCtrl.new(grid, BaseItemCell, "PaySignItemCell")
  self.rewardCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickRewardItem, self)
  local result = {}
  for i = 1, #data - 1 do
    result[#result + 1] = data[i]
  end
  self.rewardCtl:ResetDatas(result)
end

function PaySignEntryView:OnClickRewardItem(cellctl)
  if cellctl and cellctl ~= self.chooseItem then
    local data = cellctl.data
    local stick = cellctl.gameObject:GetComponent(UIWidget)
    if data then
      local callback = function()
        self:CancelChoose()
      end
      local sdata = {
        itemdata = data,
        funcConfig = {},
        callback = callback,
        ignoreBounds = {
          cellctl.gameObject
        }
      }
      TipManager.Instance:ShowItemFloatTip(sdata, stick, NGUIUtil.AnchorSide.Left, {-220, 0})
    end
    self.chooseItem = cellctl
  else
    self:CancelChoose()
  end
end

function PaySignEntryView:CancelChoose()
  self.chooseItem = nil
  self:ShowItemTip()
end

function PaySignEntryView:OnPurchase()
  if not PaySignProxy.Instance:IsLotteryTimeValid(self.actID) then
    MsgManager.ShowMsgByID(41105)
    return
  end
  if self.actConfigData:IsNoviceMode() then
    self:DoPurchase()
    return
  end
  if MyselfProxy.Instance:GetLottery() < self.actConfigData.rechargeNum then
    MsgManager.ConfirmMsgByID(3551, function()
      FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit)
    end)
  else
    local callback = function()
      ServiceNUserProxy.Instance:CallPaySignBuyUserCmd(self.actID)
      NewRechargeProxy.Instance:readyTriggerEventId(115)
    end
    local lottery_str = self.actConfigData:GetLotteryCostDesc()
    if OverseaHostHelper:UseOverseaConfirm() then
      OverseaHostHelper:GachaUseComfirm(lottery_str, callback)
    else
      MsgManager.ConfirmMsgByID(41357, function()
        callback()
      end, nil, nil, lottery_str)
    end
  end
end

function PaySignEntryView:DoPurchase()
  if PaySignProxy.Instance:IsNoviceModePurchased() then
    MsgManager.ShowMsgByID(89)
    return
  end
  if not self.actConfigData then
    return
  end
  local productID = self.actConfigData.depositConfig and self.actConfigData.depositConfig.ProductID
  if not productID then
    return
  end
  if ApplicationInfo.IsPcWebPay() then
    if productConf.PcEnable == 1 then
      MsgManager.ConfirmMsgByID(43467, function()
        ApplicationInfo.OpenPCRechargeUrl()
      end, nil, nil, nil)
    else
      MsgManager.ShowMsgByID(43466)
    end
    return
  end
  if PurchaseDeltaTimeLimit.Instance():IsEnd(productID) then
    local callbacks = {}
    callbacks[1] = function(result)
      local strResult = result or "nil"
      LogUtility.Info("PaySignEntryView:PaySuccess, " .. strResult)
      PaySignProxy.Instance.novicePurchased = true
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[2] = function(result)
      local strResult = result or "nil"
      LogUtility.Info("PaySignEntryView:PayFail, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[3] = function(result)
      local strResult = result or "nil"
      LogUtility.Info("PaySignEntryView:PayTimeout, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[4] = function(result)
      local strResult = result or "nil"
      LogUtility.Info("PaySignEntryView:PayCancel, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[5] = function(result)
      local strResult = result or "nil"
      LogUtility.Info("PaySignEntryView:PayIllegal, " .. strResult)
      PurchaseDeltaTimeLimit.Instance():End(productID)
    end
    callbacks[6] = function(result)
      local strResult = result or "nil"
      LogUtility.Info("PaySignEntryView:Paying, " .. strResult)
    end
    FuncPurchase.Instance():Purchase(self.actConfigData.depositConfig.id, callbacks)
    PurchaseDeltaTimeLimit.Instance():Start(productID, _purchase_Interval)
  else
    MsgManager.ShowMsgByID(49)
  end
end

function PaySignEntryView:HandlePurchase()
  local actId = self.actID
  self:CloseSelf()
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.PaySignRewardView,
    viewdata = {id = actId}
  })
end
