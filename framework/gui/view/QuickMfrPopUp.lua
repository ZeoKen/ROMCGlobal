autoImport("QuickMakePopUp")
QuickMfrPopUp = class("QuickMfrPopUp", QuickMakePopUp)
QuickMfrPopUp.TipCellPfb = "EquipMfrMaterialTipCell"

function QuickMfrPopUp:InitView()
  QuickMfrPopUp.super.InitView(self)
  self.title = self:FindGO("Title"):GetComponent(UILabel)
  self.checkBtn = self:FindGO("CheckBtn"):GetComponent(UIToggle)
  self.checkBg = self:FindGO("CheckBg"):GetComponent(UISprite)
  self.checkLabel = self:FindGO("CheckLabel"):GetComponent(UILabel)
  self:AddClickEvent(self.checkBtn.gameObject, function(go)
    self:UpdateMakeInfo()
  end)
  self.itemTipContainer = self:FindGO("ItemTipContainer")
end

function QuickMfrPopUp:InitBtns()
  self.confirmButton = self:FindGO("ConfirmButton")
  self.confirmButton_BoxCollider = self.confirmButton:GetComponent(BoxCollider)
  self.confirmLabel = self:FindComponent("Label", UILabel, self.confirmButton)
  self:AddClickEvent(self.confirmButton, function()
    FunctionSecurity.Me():LevelUpEquip(function()
      self:DoConfirm()
    end)
  end)
  self:AddButtonEvent("CancelButton", function()
    self:CloseSelf()
  end)
  self.quickBuyBtn = self:FindGO("QuickBuyButton")
  self.quickBuyBtn_Label = self:FindGO("Label", self.quickBuyBtn):GetComponent(UILabel)
  self.quickBuyBtn_Label.text = ZhString.EquipUpgradePopUp_QuickBuy
  self.quickBuyBtn_BoxCollider = self.quickBuyBtn:GetComponent(BoxCollider)
  self:AddClickEvent(self.quickBuyBtn, function()
    if #self.lackItems > 0 then
      if QuickBuyProxy.Instance:TryOpenView(self.lackItems, QuickBuyProxy.QueryType.NoDamage) then
        return
      end
    else
      MsgManager.ShowMsgByID(542)
    end
  end)
end

function QuickMfrPopUp:UpdateLackItems()
  self.lackItems = self.lackItems or {}
  TableUtility.ArrayClear(self.lackItems)
  local cells, lackitemid, lacknum = self.materialCtl:GetCells()
  for i = 1, #cells do
    lackitemid, lacknum = cells[i]:GetLackMaterials()
    if lackitemid and lacknum then
      table.insert(self.lackItems, {id = lackitemid, count = lacknum})
    end
  end
  self.confirmLabel.text = ZhString.QuickMakePopUp_Make
  if #self.lackItems > 0 then
    self:SetTextureGrey(self.confirmButton)
    self.confirmButton_BoxCollider.enabled = false
  else
    self:SetTextureWhite(self.confirmButton, LuaGeometry.GetTempVector4(0.6862745098039216, 0.3764705882352941, 0.10588235294117647, 1))
    self.confirmButton_BoxCollider.enabled = true
  end
end

function QuickMfrPopUp:OnEnter()
  QuickMfrPopUp.super.super.super.OnEnter(self)
  local viewData = self.viewdata.viewdata
  local initCount
  if type(viewData) == "table" then
    self.targetItemId = viewData and viewData.id
    initCount = viewData and viewData.count
    self.viewdata.viewdata = self.targetItemId
  else
    self.targetItemId = viewData
  end
  if not self.targetItemId then
    LogUtility.Error("Cannot get target data")
    self:CloseSelf()
  end
  if self.tipLab then
    self:Hide(self.tipLab)
  end
  if initCount then
    self.countInput.value = initCount
  else
    local previewItemID = QuickBuyProxy.Instance.previewItemID
    if previewItemID and self.targetItemId == previewItemID then
      self.countInput.value = QuickBuyProxy.Instance.previewCount or 1
    else
      self.countInput.value = 1
    end
  end
  self:UpdateItemTip()
end

function QuickMfrPopUp:OnExit()
  if self.infoTipCell then
    self.infoTipCell:OnDestroy()
  end
  QuickMfrPopUp.super.OnExit(self)
  self.infoTipCell = nil
end

function QuickMfrPopUp:DoConfirm()
  if #self.lackItems > 0 and QuickBuyProxy.Instance:TryOpenView(self.lackItems, QuickBuyProxy.QueryType.NoDamage) then
    return
  end
  if MyselfProxy.Instance:GetROB() < self:GetCurCostZeny() then
    MsgManager.ShowMsgByID(1)
    return
  end
  if not self.targetComposeId then
    LogUtility.ErrorFormat("Cannot find compose id when targetItemId={0}", self.targetItemId)
    return
  end
  ServiceItemProxy.Instance:CallProduce(SceneItem_pb.EPRODUCETYPE_EQUIP, self.targetComposeId, nil, nil, self:GetCurCount(), true, self.checkBtn.value)
  self:CloseSelf()
end

function QuickMfrPopUp:UpdateMakeInfo()
  local count, rob, costs, element = self:GetCurCount(), 0, ReusableTable.CreateArray()
  self.targetComposeId = nil
  local table_compose = EquipMakeProxy.Instance:GetComposeTable()
  for _, d in pairs(table_compose) do
    if d.Product and d.Product.id == self.targetItemId and d.Type == 2 and d.Category == 1 and d.BeCostItem then
      for i = 1, #d.BeCostItem do
        element = d.BeCostItem[i]
        TableUtility.ArrayPushBack(costs, {
          id = element.id,
          num = element.num * count
        })
      end
      rob = d.ROB * count
      self.targetComposeId = d.id
      break
    end
  end
  if self.checkBtn.value and 0 < #costs then
    local use, has = false, false
    costs, use, has = BlackSmithProxy.Instance:UpdateMaterialListUsingDeduction(costs)
    if not use then
      if not has then
        MsgManager.ShowMsgByID(28117)
      else
        MsgManager.ShowMsgByID(28118)
      end
      self.checkBtn.value = false
    end
  end
  self.materialCtl:ResetDatas(costs)
  if self.lastCount and count < self.lastCount then
    self.materialScrollView:ResetPosition()
  end
  self:UpdateCostZeny(rob)
  self:UpdateLackItems()
  self.lastCount = count
  ReusableTable.DestroyAndClearArray(costs)
end

function QuickMfrPopUp:UpdateItemTip()
  if not self.targetItemId then
    return
  end
  local itemData = ItemData.new("BuyItem", self.targetItemId)
  itemData.hidePath = true
  if not self.infoTipCell then
    local obj = self:FindGO("ItemTipComCell_Local", self.itemTipContainer)
    self.infoTipCell = ItemTipComCell.new(obj)
    self.infoTipCell.UpdateBgHeight = self.UpdateBgHeight
    self.infoTipCell.SetReplaceInfo = self.SetReplaceInfo
    self.infoTipCell:DisableAttrReposition()
    self.infoTipCell:SetData(itemData, nil, nil, nil, nil, false)
    self.infoTipCell:UpdateTipButtons(_EmptyTable)
    self.infoTipCell:UpdateBgHeight()
    self.infoTipCell:HideGetPath()
    self.infoTipCell:HidePreviewButton()
    self.infoTipCell:TrySetShowUpBtnActive(false)
    self.infoTipCell:TrySetShowTpBtnActive(false)
  else
    self.infoTipCell.gameObject:SetActive(true)
    self.infoTipCell.attriCtl:RemoveAll()
    self.infoTipCell:SetData(itemData, nil, nil, nil, nil, not resetPos)
    self.infoTipCell:HideGetPath()
    self.infoTipCell:HidePreviewButton()
    self.infoTipCell:TrySetShowUpBtnActive(false)
    self.infoTipCell:TrySetShowTpBtnActive(false)
  end
  self.title.text = string.format(ZhString.EquipMake_MakeCost, itemData:GetName())
end

function QuickMfrPopUp:UpdateBgHeight()
  local height = 602
  if self.refreshTip_GO and self.refreshTip_GO.activeInHierarchy then
    height = height + 22
  end
  if self.hasFunc and self.bottomBtns and self.bottomBtns.activeSelf or self.tips and self.tips.gameObject.activeInHierarchy then
    height = height + 74
  end
  self.bg.height = height
end

function QuickMfrPopUp:SetReplaceInfo(text)
  local y = 171
  if self.replaceInfo then
    local isEmpty = StringUtil.IsEmpty(text)
    self.replaceInfo:SetActive(not isEmpty)
    if not isEmpty then
      y = 148
      self.replaceLab.text = text
    end
  end
  if self.centerTop then
    self.centerTop.transform.localPosition = LuaGeometry.GetTempVector3(0, y, 0)
    if self.main then
      self.main:UpdateAnchors()
    end
  end
end
