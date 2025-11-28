local BaseCell = autoImport("BaseCell")
NewRechargeGiftTipItemView = class("NewRechargeGiftTipItemView", BaseCell)
NewRechargeGiftTipItemView.Event = {
  ClickItem = "NewRechargeGiftTipItemView_ClickItem",
  ClickPreview = "NewRechargeGiftTipItemView_ClickPreview"
}

function NewRechargeGiftTipItemView:Init()
  self.textLb = self.gameObject:GetComponent(UILabel)
  self.m_uiRootMainItem = self:FindGO("uiRootMainItem")
  self.m_uiRootSubItem = self:FindGO("uiRootSubItem")
  self.m_uiAnchorMainItem = self:FindGO("uiRootMainItem/uiRootItem")
  self.m_uiImgMainItemGet = self:FindGO("uiRootMainItem/uiRootItem/uiImgGet")
  self.m_uiImgMainItemRate = self:FindGO("uiRootMainItem/uiRootItem/uiImgRate")
  self.m_uiAnchorSubItem1 = self:FindGO("uiRootSubItem/uiItem1")
  self.m_uiAnchorSubItem2 = self:FindGO("uiRootSubItem/uiItem2")
  self.m_uiAnchorSubItem3 = self:FindGO("uiRootSubItem/uiItem3")
  self.m_uiImgSubItemRate1 = self:FindGO("uiRootSubItem/uiItem1/uiImgRate")
  self.m_uiImgSubItemRate2 = self:FindGO("uiRootSubItem/uiItem2/uiImgRate")
  self.m_uiImgSubItemRate3 = self:FindGO("uiRootSubItem/uiItem3/uiImgRate")
  self.m_uiTxtName = self:FindGO("uiRootMainItem/uiTxtName"):GetComponent(UILabel)
  self.m_uiTxtDesc = self:FindGO("uiRootMainItem/uiTxtDesc"):GetComponent(UILabel)
  self.m_uiBtnPreview = self:FindGO("uiRootMainItem/ShowFPreviewButton")
  self:addDragScrollView(self.m_uiAnchorMainItem)
  self:addDragScrollView(self.m_uiAnchorSubItem1)
  self:addDragScrollView(self.m_uiAnchorSubItem2)
  self:addDragScrollView(self.m_uiAnchorSubItem3)
  self:AddClickEvent(self.m_uiBtnPreview, function()
    self:onClickPreview()
  end)
  self:AddClickEvent(self.m_uiAnchorMainItem, function()
    self:onClickShowItemTips(0)
  end)
  self:AddClickEvent(self.m_uiAnchorSubItem1, function()
    self:onClickShowItemTips(1)
  end)
  self:AddClickEvent(self.m_uiAnchorSubItem2, function()
    self:onClickShowItemTips(2)
  end)
  self:AddClickEvent(self.m_uiAnchorSubItem3, function()
    self:onClickShowItemTips(3)
  end)
end

function NewRechargeGiftTipItemView:SetData(data)
  self.m_data = data
  self.m_uiImgMainItemGet.gameObject:SetActive(false)
  self.m_uiImgMainItemRate.gameObject:SetActive(false)
  self.m_uiImgSubItemRate1.gameObject:SetActive(false)
  self.m_uiImgSubItemRate2.gameObject:SetActive(false)
  self.m_uiImgSubItemRate3.gameObject:SetActive(false)
  if self.m_data.show ~= nil and self.m_data.show > 0 then
    self.m_uiRootMainItem.gameObject:SetActive(true)
    self.m_uiRootSubItem.gameObject:SetActive(false)
    self.m_mainItemData = ItemData.new(nil, self.m_data.itemid)
    self.m_mainItemData.num = self.m_data.num or 1
    if self.m_mainItemData:IsEquip() and self.m_data.refinelv then
      self.m_mainItemData.equipInfo:SetRefine(self.m_data.refinelv)
    end
    self:onUpdateShowFpButton()
    self:onShowMainItemData()
  else
    self.m_uiRootMainItem.gameObject:SetActive(false)
    self.m_uiRootSubItem.gameObject:SetActive(true)
    self:onShowSubItemData()
  end
end

function NewRechargeGiftTipItemView:onClickPreview()
  if self.m_mainItemData == nil then
    return
  end
  if self.m_mainItemData.equipInfo and self.m_mainItemData.equipInfo:IsMyDisplayForbid() then
    MsgManager.ShowMsgByID(40310)
    return
  end
  self:PassEvent(NewRechargeGiftTipItemView.Event.ClickPreview, self.m_mainItemCell)
end

function NewRechargeGiftTipItemView:onUpdateShowFpButton()
  local isActive = false
  local data = self.m_mainItemData
  if data then
    if data:IsPic() then
      local composeId = data.staticData.ComposeID
      local productId = composeId and Table_Compose[composeId] and Table_Compose[composeId].Product.id
      local product = productId and ItemData.new("Product", productId)
      isActive = product and product:CanEquip() and true or false
    elseif data:IsHomePic() then
      isActive = data:IsHomeMaterialPic()
    elseif data:EyeCanEquip() then
      isActive = true
    elseif data:HairCanEquip() then
      isActive = true
    elseif data:IsMountPet() then
      isActive = true
    elseif data:IsFurniture() then
      isActive = true
    elseif data:IsFashion() or data.equipInfo and (data.equipInfo:IsWeapon() or data.equipInfo:IsMount()) then
      if data:CanEquip(data.equipInfo:IsMount()) and not data:IsTrolley() then
        isActive = not Game.Myself.data:IsInMagicMachine() and not Game.Myself.data:IsEatBeing()
      else
        isActive = false
      end
    elseif data.equipInfo and data.equipInfo:GetEquipType() == EquipTypeEnum.Shield then
      local cfgShowShield = GameConfig.Profession.show_shield_typeBranches
      isActive = cfgShowShield ~= nil and TableUtility.ArrayFindIndex(cfgShowShield, MyselfProxy.Instance:GetMyProfessionTypeBranch()) > 0
    elseif GameConfig.BattlePass.EquipPreview and GameConfig.BattlePass.EquipPreview[data.staticData.id] then
      isActive = true
    else
      isActive = false
    end
  end
  self.m_uiBtnPreview:SetActive(isActive)
  if isActive then
    self.m_uiTxtName.width = 170
    self.m_uiTxtDesc.width = 170
  else
    self.m_uiTxtName.width = 220
    self.m_uiTxtDesc.width = 220
  end
end

function NewRechargeGiftTipItemView:onShowMainItemData()
  if self.m_mainItemCell == nil then
    local go = self:LoadPreferb("cell/ItemCell", self.m_uiAnchorMainItem)
    go.transform:SetParent(go.transform, true)
    go.transform.localPosition = LuaGeometry.Const_V3_zero
    self.m_mainItemCell = ItemCell.new(self.m_uiAnchorMainItem)
  end
  self.m_mainItemCell:SetData(self.m_mainItemData)
  self.m_mainItemCell:UpdateNumLabel(self.m_mainItemData.num)
  self.m_uiTxtName.text = self.m_mainItemData:GetName()
  if self.m_data.showgrey then
    self.m_uiImgMainItemGet.gameObject:SetActive(false)
    self.m_uiTxtDesc.text = ""
  else
    self.m_uiImgMainItemGet.gameObject:SetActive(false)
    if self.m_data.safety then
      self.m_uiTxtDesc.text = string.format(ZhString.NewRecharge_Buy_Rate, self.m_data.showcount, self.m_data.guaranteed)
    else
      self.m_uiTxtDesc.text = ""
    end
  end
  if self.m_data.probability then
    self.m_uiImgMainItemRate.gameObject:SetActive(true)
  else
    self.m_uiImgMainItemRate.gameObject:SetActive(false)
  end
end

function NewRechargeGiftTipItemView:onShowSubItemData()
  if #self.m_data > 0 then
    self.m_uiAnchorSubItem1.gameObject:SetActive(true)
    local data = self.m_data[1]
    local itemData = ItemData.new(nil, data.itemid)
    if data.refinelv and itemData:IsEquip() then
      itemData.equipInfo:SetRefine(data.refinelv)
    end
    if self.m_subItemCell1 == nil then
      local go = self:LoadPreferb("cell/ItemCell", self.m_uiAnchorSubItem1)
      go.transform:SetParent(go.transform, true)
      go.transform.localPosition = LuaGeometry.Const_V3_zero
      self.m_subItemCell1 = ItemCell.new(self.m_uiAnchorSubItem1)
    end
    self.m_subItemCell1:SetData(itemData)
    self.m_subItemCell1:UpdateNumLabel(data.num)
    if data.probability then
      self.m_uiImgSubItemRate1.gameObject:SetActive(true)
    end
  else
    self.m_uiAnchorSubItem1.gameObject:SetActive(false)
  end
  if #self.m_data > 1 then
    self.m_uiAnchorSubItem2.gameObject:SetActive(true)
    local data = self.m_data[2]
    local itemData = ItemData.new(nil, data.itemid)
    if data.refinelv and itemData:IsEquip() then
      itemData.equipInfo:SetRefine(data.refinelv)
    end
    if self.m_subItemCell2 == nil then
      local go = self:LoadPreferb("cell/ItemCell", self.m_uiAnchorSubItem2)
      go.transform:SetParent(go.transform, true)
      go.transform.localPosition = LuaGeometry.Const_V3_zero
      self.m_subItemCell2 = ItemCell.new(self.m_uiAnchorSubItem2)
    end
    self.m_subItemCell2:SetData(itemData)
    self.m_subItemCell2:UpdateNumLabel(data.num)
    if data.probability then
      self.m_uiImgSubItemRate2.gameObject:SetActive(true)
    end
  else
    self.m_uiAnchorSubItem2.gameObject:SetActive(false)
  end
  if #self.m_data > 2 then
    self.m_uiAnchorSubItem3.gameObject:SetActive(true)
    local data = self.m_data[3]
    local itemData = ItemData.new(nil, data.itemid)
    if data.refinelv and itemData:IsEquip() then
      itemData.equipInfo:SetRefine(data.refinelv)
    end
    if self.m_subItemCell3 == nil then
      local go = self:LoadPreferb("cell/ItemCell", self.m_uiAnchorSubItem3)
      go.transform:SetParent(go.transform, true)
      go.transform.localPosition = LuaGeometry.Const_V3_zero
      self.m_subItemCell3 = ItemCell.new(self.m_uiAnchorSubItem3)
    end
    self.m_subItemCell3:SetData(itemData)
    self.m_subItemCell3:UpdateNumLabel(data.num)
    if data.probability then
      self.m_uiImgSubItemRate3.gameObject:SetActive(true)
    end
  else
    self.m_uiAnchorSubItem3.gameObject:SetActive(false)
  end
end

function NewRechargeGiftTipItemView:onClickShowItemTips(index)
  if index == 0 then
    self:PassEvent(NewRechargeGiftTipItemView.Event.ClickItem, self.m_mainItemCell)
  elseif index == 1 then
    self:PassEvent(NewRechargeGiftTipItemView.Event.ClickItem, self.m_subItemCell1)
  elseif index == 2 then
    self:PassEvent(NewRechargeGiftTipItemView.Event.ClickItem, self.m_subItemCell2)
  elseif index == 3 then
    self:PassEvent(NewRechargeGiftTipItemView.Event.ClickItem, self.m_subItemCell3)
  end
end

function NewRechargeGiftTipItemView:addDragScrollView(value)
  local uidrag = value.gameObject:GetComponent(UIDragScrollView)
  if uidrag == nil then
    value.gameObject:AddComponent(UIDragScrollView)
  end
end

function NewRechargeGiftTipItemView:CloseSelf()
  NewRechargeGiftTipItemView.super.CloseSelf(self)
end
