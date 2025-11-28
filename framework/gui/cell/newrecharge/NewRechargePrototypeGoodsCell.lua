NewRechargePrototypeGoodsCell = class("NewRechargePrototypeGoodsCell", BaseCell)
NewRechargePrototypeGoodsCell.GoodsTypeEnum = {Deposit = 1, Shop = 2}
NewRechargePrototypeGoodsCell.goodsType = nil

function NewRechargePrototypeGoodsCell:Init()
  self:FindObjs()
  self:RegisterClickEvent()
  self:Func_AddListenEvent()
end

function NewRechargePrototypeGoodsCell:OnCellDestroy()
  if self.u_spIconTip_Label1 then
    self.u_spIconTip_Label1.onPostFill = nil
  end
  if self.u_spIconTip_Label2 then
    self.u_spIconTip_Label2.onPostFill = nil
  end
  if self.u_spIconTip_Label3 then
    self.u_spIconTip_Label3.onPostFill = nil
  end
  self:Func_RemoveListenEvent()
end

function NewRechargePrototypeGoodsCell:FindObjs()
end

function NewRechargePrototypeGoodsCell:GetGoodsType()
  return self.data.confType
end

function NewRechargePrototypeGoodsCell:IsDepositGoods()
  return self.goodsType == self.GoodsTypeEnum.Deposit
end

function NewRechargePrototypeGoodsCell:IsShopGoods()
  return self.goodsType == self.GoodsTypeEnum.Shop
end

function NewRechargePrototypeGoodsCell:SetData(data)
  if data then
    self.data = data
  end
  if not self.data then
    return
  end
  self.goodsType = self:GetGoodsType()
  if self.goodsType == self.GoodsTypeEnum.Deposit then
    self:SetData_Deposit()
  else
    self:SetData_Shop()
  end
  self:SetCell()
  self:updateItemPricePosition()
end

function NewRechargePrototypeGoodsCell:SetCell()
  if self.goodsType == self.GoodsTypeEnum.Deposit then
    self:SetCell_Deposit()
  else
    self:SetCell_Shop()
  end
end

function NewRechargePrototypeGoodsCell:Purchase()
  if self.goodsType == self.GoodsTypeEnum.Deposit then
    self:Purchase_Deposit()
  else
    self:Purchase_Shop()
  end
end

function NewRechargePrototypeGoodsCell:Func_AddListenEvent()
end

function NewRechargePrototypeGoodsCell:Func_RemoveListenEvent()
end

function NewRechargePrototypeGoodsCell:SetData_Deposit()
end

function NewRechargePrototypeGoodsCell:SetData_Shop()
end

function NewRechargePrototypeGoodsCell:SetCell_Deposit()
end

function NewRechargePrototypeGoodsCell:SetCell_Shop()
end

function NewRechargePrototypeGoodsCell:Purchase_Deposit()
end

function NewRechargePrototypeGoodsCell:Purchase_Shop()
end

function NewRechargePrototypeGoodsCell:Set_DescMark(active, desc)
  if not self.u_desMark then
    return
  end
  self.u_desMark:SetActive(active)
  self.u_desMarkText.text = desc or ""
end

function NewRechargePrototypeGoodsCell:Set_SoldOutMark(active)
  if not self.u_soldOutMark then
    return
  end
  self.u_soldOutMark:SetActive(active)
  if self.SetAlpha then
    self:SetAlpha(active and 0.5 or 1)
  end
end

function NewRechargePrototypeGoodsCell:Set_PriceAndDiscount()
end

function NewRechargePrototypeGoodsCell:Set_DiscountMark(active, oriPrice, curPrice, showDiscount, priceCurrencyPrefix)
  if not self.u_itemPrice then
    return
  end
  if not self.u_itemOriPrice then
    return
  end
  priceCurrencyPrefix = priceCurrencyPrefix or ""
  if active then
    if oriPrice then
      self.u_itemOriPrice.text = string.format(ZhString.Shop_OriginPrice, priceCurrencyPrefix .. FunctionNewRecharge.FormatMilComma(oriPrice))
    end
    if curPrice then
      self.u_itemPrice.text = priceCurrencyPrefix .. FunctionNewRecharge.FormatMilComma(curPrice)
    end
  elseif oriPrice then
    self.u_itemPrice.text = priceCurrencyPrefix .. FunctionNewRecharge.FormatMilComma(oriPrice)
  end
  self.u_itemOriPrice.gameObject:SetActive(active)
  if self.u_discountMark then
    self.u_discountMark:SetActive(showDiscount == true and active == true)
    if showDiscount and active and oriPrice and curPrice then
      local discount = math.ceil(curPrice / oriPrice * 100)
      self.u_discountValue.text = discount .. "%"
      Game.convert2OffLbl(self.u_discountValue)
    end
  end
end

function NewRechargePrototypeGoodsCell:updateItemPricePosition()
  if Slua.IsNull(self.u_itemPriceIcon) then
    return
  end
  if self.u_itemPriceIcon.gameObject.activeSelf then
    local iconLen = self.u_itemPriceIcon.width * 0.6
    self.u_itemPrice.transform.localPosition = LuaGeometry.GetTempVector3(iconLen / 2, 0, 0)
  else
    self.u_itemPrice.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
  end
end

function NewRechargePrototypeGoodsCell:isShowSuperValue(value)
  if self.m_goSuperValue ~= nil then
    if value ~= nil then
      self.m_goSuperValue.gameObject:SetActive(true)
      self.m_uiTxtSuperValueNum.text = value .. "%"
    else
      self.m_goSuperValue.gameObject:SetActive(false)
    end
  end
end

function NewRechargePrototypeGoodsCell:Set_FirstDoubleMark(active)
  if not self.u_firstDoubleMark then
    return
  end
  self.u_firstDoubleMark:SetActive(active)
end

function NewRechargePrototypeGoodsCell:Set_GainMoreMark(active, gainMoreMtpCount)
  if not self.u_gainMoreMark then
    return
  end
  self.u_gainMoreMark:SetActive(active)
  self.u_gainMore.text = gainMoreMtpCount and "x" .. gainMoreMtpCount or ""
end

function NewRechargePrototypeGoodsCell:Set_FreeBonusMark(active, freeBonusCount)
  if not self.u_freeBonusMark then
    return
  end
  self.u_freeBonusMark:SetActive(false)
  self.u_freeBonus.text = string.format(ZhString.Giving, FunctionNewRecharge.FormatMilComma(freeBonusCount))
  UIUtil.FitLableMaxWidth(self.u_freeBonus, 200)
  self.u_freeBonusMark:SetActive(active)
end

function NewRechargePrototypeGoodsCell:Set_LeftTimeMark(active, left_time)
  if not self.u_leftTimeMark then
    return
  end
  self.u_leftTimeMark:SetActive(active)
  self.u_leftTime.text = left_time or ""
end

function NewRechargePrototypeGoodsCell:Set_BuyTimesMark(active, buy_times)
  if not self.u_buyTimes then
    return
  end
  self.u_buyTimes.gameObject:SetActive(active)
  self.u_buyTimes.text = buy_times or ""
end

function NewRechargePrototypeGoodsCell:Set_ContentMark(active, item_id, item_count)
  if not self.u_content then
    return
  end
  self.u_content:SetActive(active)
  if item_id and nil ~= Table_Item and nil ~= Table_Item[item_id] then
    IconManager:SetItemIcon(Table_Item[item_id].Icon, self.u_contentIcon)
  end
  if item_count then
    self.u_contentNum.text = " " .. FunctionNewRecharge.FormatMilComma(item_count) or ""
  end
  local lLen = self.u_contentIcon.gameObject.activeSelf and self.u_contentIcon.width or 0
  lLen = lLen * self.u_contentIcon.transform.localScale[1]
  local rLen = self.u_contentNum.gameObject.activeSelf and self.u_contentNum.width or 0
  self.u_contentPH.transform.localPosition = LuaGeometry.GetTempVector3(lLen / 2 - rLen / 2, 0, 0)
end

function NewRechargePrototypeGoodsCell:Set_InstMark(active)
  if not self.u_instBtn then
    return
  end
  self.u_instBtn:SetActive(active)
end

function NewRechargePrototypeGoodsCell:Set_NewMark(active)
  if not self.u_newMark then
    return
  end
  self.u_newMark:SetActive(active)
end

function NewRechargePrototypeGoodsCell:Set_LeftTimeMark(active)
  if not self.u_leftTimeMark then
    return
  end
  self.u_leftTimeMark:SetActive(active)
end

function NewRechargePrototypeGoodsCell:FindIconTip()
  local iconGO = self:FindGO("IconTip")
  self.u_spIconTip_Label1GO = self:FindGO("Label1", iconGO)
  self.u_spIconTip_Label1 = self.u_spIconTip_Label1GO:GetComponent(UILabel)
  self.u_spIconTip_Label1Sp = self:FindComponent("Bg", UISprite, self.u_spIconTip_Label1GO)
  
  function self.u_spIconTip_Label1.onPostFill()
    self.u_spIconTip_Label1Sp.height = self.u_spIconTip_Label1.height + 4
    self.u_spIconTip_Label1Sp.width = self.u_spIconTip_Label1.width + 30
  end
  
  self.u_spIconTip_Label2GO = self:FindGO("Label2", iconGO)
  self.u_spIconTip_Label2 = self.u_spIconTip_Label2GO:GetComponent(UILabel)
  self.u_spIconTip_Label2Sp = self:FindComponent("Bg", UISprite, self.u_spIconTip_Label2GO)
  
  function self.u_spIconTip_Label2.onPostFill()
    self.u_spIconTip_Label2Sp.height = self.u_spIconTip_Label2.height + 4
    self.u_spIconTip_Label2Sp.width = self.u_spIconTip_Label2.width + 30
  end
  
  self.u_spIconTip_Label3GO = self:FindGO("Label3", iconGO)
  self.u_spIconTip_Label3 = self.u_spIconTip_Label3GO:GetComponent(UILabel)
  self.u_spIconTip_Label3Sp = self:FindComponent("Bg", UISprite, self.u_spIconTip_Label3GO)
  
  function self.u_spIconTip_Label3.onPostFill()
    self.u_spIconTip_Label3Sp.height = self.u_spIconTip_Label3.height + 4
    self.u_spIconTip_Label3Sp.width = self.u_spIconTip_Label3.width + 30
  end
  
  self.u_spIconTip_extra = self:FindGO("Extra", iconGO)
  self.u_spIconTip_or = self:FindGO("TipOr", iconGO)
  self.iconTipFinded = not Slua.IsNull(self.u_spIconTip_Label1GO)
end

function NewRechargePrototypeGoodsCell:UpdateIconTip(iconTipData)
  if not self.iconTipFinded then
    return
  end
  if not iconTipData then
    self.u_spIconTip_Label1GO:SetActive(false)
    self.u_spIconTip_Label2GO:SetActive(false)
    self.u_spIconTip_Label3GO:SetActive(false)
    self.u_spIconTip_extra:SetActive(false)
    self.u_spIconTip_or:SetActive(false)
    return
  end
  if iconTipData.text1 then
    self.u_spIconTip_Label1GO:SetActive(true)
    self.u_spIconTip_Label1.text = tostring(iconTipData.text1[1])
    LuaGameObject.SetLocalPositionGO(self.u_spIconTip_Label1GO, iconTipData.text1[2], iconTipData.text1[3], iconTipData.text1[4])
  else
    self.u_spIconTip_Label1GO:SetActive(false)
  end
  if iconTipData.text2 then
    self.u_spIconTip_Label2GO:SetActive(true)
    self.u_spIconTip_Label2.text = tostring(iconTipData.text2[1])
    LuaGameObject.SetLocalPositionGO(self.u_spIconTip_Label2GO, iconTipData.text2[2], iconTipData.text2[3], iconTipData.text2[4])
  else
    self.u_spIconTip_Label2GO:SetActive(false)
    self.u_spIconTip_Label2.text = ""
  end
  if iconTipData.text3 then
    self.u_spIconTip_Label3GO:SetActive(true)
    self.u_spIconTip_Label3.text = tostring(iconTipData.text3[1])
    LuaGameObject.SetLocalPositionGO(self.u_spIconTip_Label3GO, iconTipData.text3[2], iconTipData.text3[3], iconTipData.text3[4])
  else
    self.u_spIconTip_Label3GO:SetActive(false)
    self.u_spIconTip_Label3.text = ""
  end
  if iconTipData.sp_extra then
    self.u_spIconTip_extra:SetActive(true)
    LuaGameObject.SetLocalPositionGO(self.u_spIconTip_extra, iconTipData.sp_extra[1], iconTipData.sp_extra[2], iconTipData.sp_extra[3])
  else
    self.u_spIconTip_extra:SetActive(false)
  end
  if iconTipData.sp_or then
    self.u_spIconTip_or:SetActive(true)
    LuaGameObject.SetLocalPositionGO(self.u_spIconTip_or, iconTipData.sp_or[1], iconTipData.sp_or[2], iconTipData.sp_or[3])
  else
    self.u_spIconTip_or:SetActive(false)
  end
end
