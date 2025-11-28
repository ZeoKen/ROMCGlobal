PhotoStandMakeSponsorCell = class("PhotoStandMakeSponsorCell", ShopItemInfoCell)

function PhotoStandMakeSponsorCell:Exit()
  self.countInput.value = 1
  PhotoStandMakeSponsorCell.super.Exit(self)
end

function PhotoStandMakeSponsorCell:FindObjs()
  PhotoStandMakeSponsorCell.super.FindObjs(self)
  self.sponsor_desc_lb = SpriteLabel.new(self:FindGO("TotalPriceTitle2"), nil, nil, nil, true)
  self.sponsor_left_lb = self:FindComponent("TotalPriceTitle1", UILabel)
  self:AddClickEvent(self:FindGO("uiImgBtnMax", self.sponsor_trans), function()
    self.countInput.value = self.maxcount
    self:UpdatePrice()
    self:InputOnChange()
  end)
  self.changeCostTip = self:FindGO("ChangeCostTip", self.sponsor_trans)
  self:TryOpenHelpViewById(35263, 20, self.changeCostTip)
  self.confirmButton_BC = self.confirmButton:GetComponent(BoxCollider)
  self.fullnow = self:FindGO("fullnow")
end

function PhotoStandMakeSponsorCell:SetData(data)
  self.data = data
  self.moneycount = 1
  self.countInput.value = 1
  local maxcan = GameConfig.PhotoBoard and GameConfig.PhotoBoard.AwardDailyLimit or 100
  local icansponsor = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_PHOTO_BOARD_AWARD) or 0
  icansponsor = maxcan - icansponsor
  self.maxcount = icansponsor
  IconManager:SetItemIcon("item_151", self.priceIcon)
  IconManager:SetItemIcon("item_151", self.totalPriceIcon)
  self.sponsor_desc_lb:Reset()
  local sss = GameConfig.PhotoBoard and GameConfig.PhotoBoard.AwardRate or 1000000
  self.sponsor_desc_lb:SetText(string.format(ZhString.PhotoStand_MakeSponsor_Desc, sss))
  self.sponsor_left_lb.text = string.format(ZhString.PhotoStand_MakeSponsor_Desc2, icansponsor, maxcan)
  self:UpdatePrice()
  self:InputOnChange()
  if 0 < self.maxcount then
    self.confirmButton_BC.enabled = true
    self:SetTextureWhite(self.confirmButton)
    self.confirmLabel.color = LuaColor(1, 1, 1)
    self.confirmLabel.effectColor = LuaColor(0.6196078431372549, 0.33725490196078434, 0)
    self.fullnow:SetActive(false)
  else
    self.confirmButton_BC.enabled = false
    self:SetTextureGrey(self.confirmButton)
    self.confirmLabel.color = LuaColor(0.5019607843137255, 0.5019607843137255, 0.5019607843137255)
    self.confirmLabel.effectColor = LuaColor(0.5019607843137255, 0.5019607843137255, 0.5019607843137255)
    self.fullnow:SetActive(true)
  end
end

function PhotoStandMakeSponsorCell:UpdateTotalPrice(count)
  self.count = count
  self.totalPrice.text = self.count
  if self.countInput.value ~= tostring(count) then
    self.countInput.value = count
  end
end

function PhotoStandMakeSponsorCell:AddConfirmClickEvent()
  self:AddClickEvent(self.confirmButton.gameObject, function()
    self:Confirm()
    local my_gold = MyselfProxy.Instance:GetLottery()
    if my_gold < self.count then
      MsgManager.ConfirmMsgByID(3551, function()
        FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit, FunctionNewRecharge.InnerTab.Deposit_ROB)
      end)
    else
      MsgManager.ConfirmMsgByID(43274, function()
        PhotoStandProxy.Instance:ServerCall_BoardAwardPhotoCmd(self.data.id, self.data.accid, self.count)
        MsgManager.ShowMsgByID(43275)
      end, nil, nil, self.countInput.value)
    end
  end)
end
