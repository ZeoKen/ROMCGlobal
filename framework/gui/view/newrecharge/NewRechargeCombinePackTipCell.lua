autoImport("NewRechargeGiftTipCell")
NewRechargeCombinePackTipCell = class("NewRechargeCombinePackTipCell", NewRechargeGiftTipCell)

function NewRechargeCombinePackTipCell:FindObjs()
  NewRechargeCombinePackTipCell.super.FindObjs(self)
  self.countBg:SetActive(false)
  self.salePrice:SetActive(false)
  self.priceRoot:SetActive(false)
  self.multiplePriceRoot:SetActive(false)
  self.toLeftBtn = self:FindGO("toLeft")
  self.toRightBtn = self:FindGO("toRight")
  self.toLeftBtn:SetActive(true)
  self.toRightBtn:SetActive(true)
  self.confirmSp = self.confirmButton:GetComponent(UIMultiSprite)
  self.comfirmBc = self.confirmButton:GetComponent(BoxCollider)
end

function NewRechargeCombinePackTipCell:AddEvts()
  NewRechargeCombinePackTipCell.super.AddEvts(self)
  if self.m_uiImgTipsMask then
    self:AddClickEvent(self.m_uiImgTipsMask, function()
      self:onCloseFashionPreview()
      TipsView.Me():HideCurrent()
      self:setLocalPosition(0)
    end)
  end
end

local hideType = {hideClickSound = true, hideClickEffect = false}

function NewRechargeCombinePackTipCell:AddConfirmClickEvent()
  self:AddClickEvent(self.confirmButton.gameObject, function()
    self.oriCell.data.select = not self.oriCell.data.select
    self:UpdateConfirmBtn()
  end, hideType)
  self:AddClickEvent(self.toLeftBtn, function()
    self:SwitchCell(true)
  end, hideType)
  self:AddClickEvent(self.toRightBtn, function()
    self:SwitchCell(false)
  end, hideType)
end

function NewRechargeCombinePackTipCell:SetData(data, oriCell, oriListCtrl)
  self.oriCell = oriCell
  self.oriListCtrl = oriListCtrl
  self.m_depositBuyFunc = nil
  NewRechargeGiftTipCell.super.SetData(self, data)
  self.helpBtn2:SetActive(data and data.batch_is_Batch == true or false)
  if self.itemNameLabelCtrl then
    self.itemNameLabelCtrl:Start(false, true)
  end
  self:UpdateConfirmBtn()
end

function NewRechargeCombinePackTipCell:shopNormal(data)
  NewRechargeCombinePackTipCell.super.shopNormal(self, data)
end

function NewRechargeCombinePackTipCell:UpdateConfirmBtn()
  if self.oriCell.data.alreadyBought then
    self.comfirmBc.enabled = false
    self.confirmLab.text = ZhString.HappyShop_SoldOut
    self.confirmLab.effectColor = ColorUtil.NGUIGray
    self.confirmSp.CurrentState = 3
  else
    self.comfirmBc.enabled = true
    if self.oriCell.data.select then
      self.confirmLab.text = ZhString.NewRechargeCombinePack_SelectOff
      self.confirmLab.effectColor = Color(0.7019607843137254, 0.2549019607843137, 0.2549019607843137, 1)
      self.confirmSp.CurrentState = 1
    else
      self.confirmLab.text = ZhString.NewRechargeCombinePack_SelectOn
      self.confirmLab.effectColor = Color(0.6196078431372549, 0.33725490196078434, 0 / 255, 1)
      self.confirmSp.CurrentState = 0
    end
  end
end

function NewRechargeCombinePackTipCell:SwitchCell(left)
  local cells = self.oriListCtrl:GetCells()
  local index = 0
  for i = 1, #cells do
    if cells[i] == self.oriCell then
      index = i
      break
    end
  end
  index = index + (left and -1 or 1)
  if index < 1 then
    index = #cells
  elseif index > #cells then
    index = 1
  end
  local newCell = cells[index]
  if newCell then
    self:SetData(newCell.info.shopItemData, newCell, self.oriListCtrl)
  end
end

function NewRechargeCombinePackTipCell:Cancel()
  NewRechargeCombinePackTipCell.super.Cancel(self)
  EventManager.Me():PassEvent(NewRechargeEvent.CombinePackList_ForceRefresh, false)
end
