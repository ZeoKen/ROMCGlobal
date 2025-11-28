autoImport("EquipUpgradePopUp")
QuickMakePopUp = class("QuickMakePopUp", EquipUpgradePopUp)
QuickMakePopUp.ViewType = UIViewType.PopUpLayer

function QuickMakePopUp:InitView()
  QuickMakePopUp.super.InitView(self)
  self.zenyCtrlLabel.text = ZhString.QuickMakePopUp_ZenyCtrlLabel
  self.countLabel.text = ZhString.QuickMakePopUp_CountLabel
  self.maxCount = 99
end

function QuickMakePopUp:OnEnter()
  QuickMakePopUp.super.super.OnEnter(self)
  self.targetItemId = self.viewdata.viewdata
  if not self.targetItemId then
    LogUtility.Error("Cannot get target data")
    self:CloseSelf()
  end
  if self.tipLab then
    self:Hide(self.tipLab)
  end
  local previewItemID = QuickBuyProxy.Instance.previewItemID
  if previewItemID and self.targetItemId == previewItemID then
    self.countInput.value = QuickBuyProxy.Instance.previewCount or 1
  else
    self.countInput.value = 1
  end
end

function QuickMakePopUp:OnExit()
  QuickMakePopUp.super.super.OnEnter(self)
  QuickBuyProxy.Instance:SetPreviewInfo(self.targetItemId, self:GetCurCount())
end

function QuickMakePopUp:OnClickCountPlus()
  self.countInput.value = self:GetCurCount() + 1
end

function QuickMakePopUp:AddCellFunc(cell)
end

function QuickMakePopUp:DoConfirm()
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
  ServiceItemProxy.Instance:CallProduce(SceneItem_pb.EPRODUCETYPE_EQUIP, self.targetComposeId, nil, nil, self:GetCurCount(), true)
end

function QuickMakePopUp:UpdateMakeInfo()
  local count, rob, costs, element = self:GetCurCount(), 0, ReusableTable.CreateArray()
  self.targetComposeId = nil
  for _, d in pairs(Table_Compose) do
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
  self.materialCtl:ResetDatas(costs)
  if self.lastCount and count < self.lastCount then
    self.materialScrollView:ResetPosition()
  end
  self:UpdateCostZeny(rob)
  self:UpdateLackItems()
  self.lastCount = count
  ReusableTable.DestroyAndClearArray(costs)
end

function QuickMakePopUp:UpdateLackItems()
  QuickMakePopUp.super.UpdateLackItems(self)
  self.confirmLabel.text = #self.lackItems > 0 and ZhString.EquipUpgradePopUp_QuickBuy or ZhString.QuickMakePopUp_Make
end

function QuickMakePopUp:OnInputChange()
  local count = self:GetCurCount()
  if not count then
    return
  end
  if count < 1 then
    self.countInput.value = 1
  elseif count > self.maxCount then
    self.countInput.value = self.maxCount
  end
  count = self:GetCurCount()
  if not count then
    return
  end
  if count <= 1 then
    self:SetCountPlus(1)
    self:SetCountSubtract(0.5)
  elseif count >= self.maxCount then
    self:SetCountPlus(0.5)
    self:SetCountSubtract(1)
  else
    self:SetCountPlus(1)
    self:SetCountSubtract(1)
  end
  self:UpdateMakeInfo()
end
