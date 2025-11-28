autoImport("ItemTipBaseCell")
ShopItemInfoCell = class("ShopItemInfoCell", ItemTipBaseCell)
local DEFAULT_LIMIT = GameConfig.Shop.default_item_limit

function ShopItemInfoCell:Exit()
  ShopItemInfoCell.super.Exit(self)
  TimeTickManager.Me():ClearTick(self)
  self:CloseFashionPreview()
end

function ShopItemInfoCell:Init()
  ShopItemInfoCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
end

function ShopItemInfoCell:FindObjs()
  self.price = self:FindComponent("Price", UILabel)
  self.confirmButton = self:FindGO("ConfirmButton")
  self.confirmLabel = self:FindGO("Label", self.confirmButton):GetComponent(UILabel)
  self.cancelButton = self:FindGO("CancelButton")
  self.cancelLabel = self:FindGO("Label", self.cancelButton):GetComponent(UILabel)
  self.countInput = self:FindGO("CountBg"):GetComponent(UIInput)
  self.countPlusBg = self:FindGO("CountPlusBg"):GetComponent(UISprite)
  self.countPlus = self:FindGO("Plus", self.countPlusBg.gameObject):GetComponent(UISprite)
  self.countSubtractBg = self:FindGO("CountSubtractBg"):GetComponent(UISprite)
  self.countSubtract = self:FindGO("Subtract", self.countSubtractBg.gameObject):GetComponent(UISprite)
  self.priceIcon = self:FindComponent("PriceIcon", UISprite)
  self.totalPrice = self:FindGO("TotalPrice"):GetComponent(UILabel)
  self.totalPriceIcon = self:FindGO("TotalPriceIcon"):GetComponent(UISprite)
  self.salePrice = self:FindGO("SalePrice")
  if self.salePrice then
    self.salePriceTip = self:FindGO("Tip", self.salePrice):GetComponent(UILabel)
  end
  self.root = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIRoot)
  if not self.closecomp then
    self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
    if self.closecomp then
      function self.closecomp.callBack(go)
        if not Slua.IsNull(self.gameObject) then
          self.gameObject:SetActive(false)
        end
      end
    end
  end
  self.btnGrid = self:FindComponent("BtnGrid", UIGrid)
  self.showfpButton = self:FindGO("ShowFPreviewButton")
  self.showTpBtn = self:FindGO("ShowTPreviewButton")
  self.cardPreviewBtn = self:FindComponent("CardPreviewBtn", UISprite)
  self.gpContainer = self:FindGO("GetPathContainer")
  UIUtil.LimitInputCharacter(self.countInput, 8)
end

function ShopItemInfoCell:AddEvts()
  self:AddConfirmClickEvent()
  self:AddClickEvent(self.cancelButton.gameObject, function(g)
    self:Cancel()
  end)
  self:AddPressEvent(self.countPlusBg.gameObject, function(g, b)
    self:PlusPressCount(b)
  end)
  self:AddPressEvent(self.countSubtractBg.gameObject, function(g, b)
    self:SubtractPressCount(b)
  end)
  EventDelegate.Set(self.countInput.onChange, function()
    self:InputOnChange()
  end)
  EventDelegate.Set(self.countInput.onSubmit, function()
    self:InputOnSubmit()
  end)
  if self.showfpButton then
    self:AddClickEvent(self.showfpButton.gameObject, function(g)
      if self.itemData.itemData.equipInfo and self.itemData.itemData.equipInfo:IsMyDisplayForbid() then
        MsgManager.ShowMsgByID(40310)
        return
      end
      self:ShowFashionPreview()
    end)
  end
  self.showTpBtn = self:FindGO("ShowTPreviewButton")
  if self.showTpBtn then
    self:AddClickEvent(self.showTpBtn, function()
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.TicketPreview,
        viewdata = self.data
      })
      TipsView.Me():HideCurrent()
    end)
  end
end

function ShopItemInfoCell:TryInitItemCell(container, pfbName, control)
  ShopItemInfoCell.super.TryInitItemCell(self, container, pfbName, control)
  if container then
    self.itemcell:ShowNum()
  end
end

function ShopItemInfoCell:AddConfirmClickEvent()
  self:AddClickEvent(self.confirmButton.gameObject, function()
    self:Confirm()
  end)
end

function ShopItemInfoCell:SetData(data)
  self.itemData = data
  self.gameObject:SetActive(data ~= nil)
  self:CloseFashionPreview()
  if data then
    self:UpdateAttriContext()
    self.data.num = self.itemData.goodsCount and self.itemData.goodsCount > 0 and self.itemData.goodsCount or self.data.num
    self:UpdateTopInfo()
    if self.maxcount == nil then
      self.maxcount = DEFAULT_LIMIT or 999
    end
    if self.moneycount == nil then
      self.moneycount = 0
      errorLog(string.format("Table_Item[%s].SellPrice == nil", tostring(self.data.staticData.id)))
    end
    self.countInput.value = 1
    self:UpdatePrice()
    self:InputOnChange()
    self:TrySetGemData(data.GetItemData and data:GetItemData())
    self:UpdateShowFpButton()
    self:UpdateCardPreviewBtn()
    self:UpdateShowTpBtn()
  end
end

function ShopItemInfoCell:Confirm()
  if not Slua.IsNull(self.gameObject) then
    self.gameObject:SetActive(false)
  end
end

function ShopItemInfoCell:Cancel()
  if not Slua.IsNull(self.gameObject) then
    self.gameObject:SetActive(false)
  end
end

function ShopItemInfoCell:PlusPressCount(isPressed)
  if isPressed then
    self.countChangeRate = 1
    TimeTickManager.Me():CreateTick(0, 150, function(owner, deltaTime)
      self:UpdateCount(1)
    end, self, 1001)
  else
    TimeTickManager.Me():ClearTick(self, 1001)
  end
end

function ShopItemInfoCell:SubtractPressCount(isPressed)
  if isPressed then
    self.countChangeRate = 1
    TimeTickManager.Me():CreateTick(0, 150, function(owner, deltaTime)
      self:UpdateCount(-1)
    end, self, 1002)
  else
    TimeTickManager.Me():ClearTick(self, 1002)
  end
end

function ShopItemInfoCell:UpdateCount(change)
  if tonumber(self.countInput.value) == nil then
    self.countInput.value = self.count
  end
  local count = tonumber(self.countInput.value) + self.countChangeRate * change
  if count < 1 then
    self.countChangeRate = 1
    return
  elseif count > self.maxcount then
    self.countChangeRate = 1
    return
  end
  self:UpdateTotalPrice(count)
  self:UpdateCurPrice(count)
  if self.countChangeRate <= 3 then
    self.countChangeRate = self.countChangeRate + 1
  end
end

function ShopItemInfoCell:UpdateCurPrice(count)
end

function ShopItemInfoCell:InputOnChange()
  local count = tonumber(self.countInput.value)
  if count == nil then
    return
  end
  if self.maxcount == 0 then
    count = 0
    self:SetCountPlus(0.5)
    self:SetCountSubtract(0.5)
  elseif count <= 1 then
    count = 1
    self:SetCountPlus(1)
    self:SetCountSubtract(0.5)
  elseif count >= self.maxcount then
    count = self.maxcount
    self:SetCountPlus(0.5)
    self:SetCountSubtract(1)
  else
    self:SetCountPlus(1)
    self:SetCountSubtract(1)
  end
  self:UpdateTotalPrice(count)
end

function ShopItemInfoCell:UpdatePrice()
  self.price.text = StringUtil.NumThousandFormat(self.moneycount)
end

function ShopItemInfoCell:UpdateTotalPrice(count)
  self.count = count
  self:CalcTotalPrice(count)
  self.totalPrice.text = StringUtil.NumThousandFormat(self.discountTotal)
  self:UpdateSale(self.discount, self.discountCount)
  if self.countInput.value ~= tostring(count) then
    self.countInput.value = count
  end
end

function ShopItemInfoCell:InputOnSubmit()
  local count = tonumber(self.countInput.value)
  if count == nil then
    self.countInput.value = self.count
  end
end

function ShopItemInfoCell:SetCountPlus(alpha)
  if self.countPlusBg.color.a ~= alpha then
    self:SetSpritAlpha(self.countPlusBg, alpha)
    self:SetSpritAlpha(self.countPlus, alpha)
  end
end

function ShopItemInfoCell:SetCountSubtract(alpha)
  if self.countSubtractBg.color.a ~= alpha then
    self:SetSpritAlpha(self.countSubtractBg, alpha)
    self:SetSpritAlpha(self.countSubtract, alpha)
  end
end

function ShopItemInfoCell:SetSpritAlpha(sprit, alpha)
  sprit.color = Color(sprit.color.r, sprit.color.g, sprit.color.b, alpha)
end

function ShopItemInfoCell:CalcTotalPrice(count)
  local totalCost = self.moneycount * count
  return totalCost
end

function ShopItemInfoCell:UpdateAttriContext()
  ShopItemInfoCell.super.UpdateAttriContext(self)
  local isInfoUpdated, itemData = false
  if self.itemData == nil then
    itemData = _EmptyTable
  elseif self.itemData.GetItemData then
    itemData = self.itemData:GetItemData()
  elseif self.itemData.staticData then
    itemData = self.itemData
  end
  if GemProxy.CheckIsGemStaticData(itemData.staticData) then
    isInfoUpdated = isInfoUpdated or self:UpdateAttributeGemInfo(itemData)
    isInfoUpdated = isInfoUpdated or self:UpdateSkillGemInfo(itemData)
    isInfoUpdated = isInfoUpdated or self:UpdateSecretLandGemInfo(itemData)
  end
  if isInfoUpdated then
    self:ResetAttriDatas()
  end
end

local tempVec3 = LuaVector3.Zero()

function ShopItemInfoCell:TrySetGemData(itemData)
  if type(itemData) ~= "table" then
    return
  end
  if GemProxy.CheckIsGemStaticData(itemData.staticData) then
    if not self.gemCell then
      local gemCellGO = self:LoadPreferb("cell/GemCell", self.cellContainer)
      gemCellGO.transform.localPosition = tempVec3
      self.gemCell = GemCell.new(gemCellGO)
    end
    GemProxy.TrySetFakeGemDataToGemCell(itemData, self.gemCell)
  elseif self.gemCell then
    GameObject.Destroy(self.gemCell.gameObject)
    self.gemCell = nil
  end
end

function ShopItemInfoCell:ShowFashionPreview()
  if not self.sfp then
    local scale = 1
    self.gpContainer.transform.localScale = LuaGeometry.GetTempVector3(scale, scale, scale)
    local x = LuaGameObject.InverseTransformPointByTransform(self.root.transform, self.gameObject.transform, Space.World)
    self.gpContainer.transform.localPosition = LuaGeometry.GetTempVector3(0 < x and -596 or 205, 272, 0)
    local data = self.itemData.itemData
    if data and data.staticData then
      self.sfp = FashionPreviewTip.new(self.gpContainer)
      self.sfp:SetAnchorPos(true)
      if data:IsPic() then
        local cid = data.staticData.ComposeID
        local composeData = cid and Table_Compose[cid]
        if composeData then
          self.sfp:SetData(composeData.Product.id)
        end
      else
        local equipPreview = GameConfig.BattlePass.EquipPreview and GameConfig.BattlePass.EquipPreview[data.staticData.id]
        local equipInfo = data.equipInfo
        local fashionGroupEquip = equipInfo and equipInfo:GetMyGroupFashionEquip()
        if equipPreview then
          local field = MyselfProxy.Instance:GetMySex() == 2 and "female" or "male"
          self.sfp:SetData(equipPreview[field])
        elseif fashionGroupEquip then
          self.sfp:SetData(fashionGroupEquip.id)
        else
          self.sfp:SetData(data.staticData.id)
        end
      end
      self.sfp:AddEventListener(ItemEvent.GoTraceItem, function()
        self:CloseSelf()
      end, self)
      self.sfp:AddIgnoreBounds(self.gameObject)
      self:AddIgnoreBounds(self.sfp.gameObject)
      self.sfp:AddEventListener(FashionPreviewEvent.Close, self.FashionPreViewCloseCall, self)
    end
    self:PassEvent(ItemTipEvent.ShowFashionPreview, self.sfp)
  else
    self:CloseFashionPreview()
  end
end

function ShopItemInfoCell:UpdateShowFpButton()
  local data = self.itemData.itemData
  if not data then
    if self.showfpButton then
      self.showfpButton:SetActive(false)
    end
    return
  end
  if self.showfpButton then
    if data:IsPic() then
      local composeId = data.staticData.ComposeID
      local productId = composeId and Table_Compose[composeId] and Table_Compose[composeId].Product.id
      local product = productId and ItemData.new("Product", productId)
      self.showfpButton:SetActive(product and product:CanEquip() and true or false)
    elseif data:IsHomePic() then
      self.showfpButton:SetActive(not data:IsHomeMaterialPic())
    elseif data:EyeCanEquip() then
      self.showfpButton:SetActive(true)
    elseif data:HairCanEquip() then
      self.showfpButton:SetActive(true)
    elseif data:IsMountPet() then
      self.showfpButton:SetActive(true)
    elseif data:IsFurniture() then
      self.showfpButton:SetActive(true)
    elseif self.data:IsPortraitFrame() or self.data:IsBackground() then
      self.showfpButton:SetActive(false)
    elseif data:IsFashion() or data.equipInfo and (data.equipInfo:IsWeapon() or data.equipInfo:IsMount()) then
      if data:CanEquip(data.equipInfo:IsMount()) and not data:IsTrolley() then
        local myselfData = Game.Myself.data
        self.showfpButton:SetActive(not myselfData:IsInMagicMachine() and not myselfData:IsEatBeing())
      else
        self.showfpButton:SetActive(false)
      end
    elseif data.equipInfo and data.equipInfo:GetEquipType() == EquipTypeEnum.Shield then
      local cfgShowShield = GameConfig.Profession.show_shield_typeBranches
      self.showfpButton:SetActive(cfgShowShield ~= nil and TableUtility.ArrayFindIndex(cfgShowShield, MyselfProxy.Instance:GetMyProfessionTypeBranch()) > 0)
    elseif GameConfig.BattlePass.EquipPreview and GameConfig.BattlePass.EquipPreview[data.staticData.id] then
      self.showfpButton:SetActive(true)
    else
      self.showfpButton:SetActive(false)
    end
  end
end

function ShopItemInfoCell:FashionPreViewCloseCall()
  if self.gameObject and self.closecomp then
    self.closecomp:ReCalculateBound()
  end
  self.sfp = nil
  self:PassEvent(FashionPreviewEvent.Close)
end

function ShopItemInfoCell:CloseFashionPreview()
  if self.sfp then
    self.sfp:OnExit()
    self.sfp = nil
  end
end

function ShopItemInfoCell:AddIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end

function ShopItemInfoCell:UpdateShowTpBtn()
  local id = self.data and self.data.staticData.id
  self:TrySetShowTpBtnActive(TicketPreview.IsTicket(id))
end

function ShopItemInfoCell:TrySetShowTpBtnActive(isActive)
  if not self.showTpBtn then
    return
  end
  self.showTpBtn:SetActive(isActive and true or false)
  self:TryResetBtnGrid()
end

function ShopItemInfoCell:TryResetBtnGrid()
  if self.btnGrid then
    self.btnGrid:Reposition()
  end
end
