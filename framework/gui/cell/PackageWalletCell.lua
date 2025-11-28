PackageWalletCell = class("PackageWalletCell", ItemCell)

function PackageWalletCell:Init()
  local itemroot = self:FindGO("ItemRoot")
  local obj = self:LoadPreferb("cell/ItemCell", itemroot)
  obj.transform.localPosition = LuaGeometry.GetTempVector3()
  PackageWalletCell.super.Init(self)
  self:AddCellClickEvent()
  self:AddCellDoubleClickEvt()
  self:FindObjs()
end

function PackageWalletCell:FindObjs()
  self.walletNameLab = self:FindComponent("WalletNameLab", UILabel)
  self.walletNumLab = self:FindComponent("WalletNumLab", UILabel)
  self.choosen = self:FindGO("Choosen")
  self.cantSale = self:FindGO("cantSale")
  self.dragItem = self.gameObject:GetComponent(UIDragItem)
  self.dragDrop = DragDropCell.new(self.dragItem)
  self.bindTipStick = self:FindComponent("BindTipStick", UIWidget)
end

function PackageWalletCell.OnCursor(dragItem)
  if not (dragItem and dragItem.data) or not dragItem.data.itemdata then
    return
  end
  DragCursorPanel.Instance.ShowItemCell(dragItem)
  EventManager.Me():PassEvent(PackageEvent.ActivateSetShortCut)
end

function PackageWalletCell:SetData(data)
  self.data = data
  if not data then
    self.gameObject:SetActive(false)
    return
  end
  self.dragDrop.dragDropComponent.data = {
    itemdata = self.data
  }
  self.dragDrop.dragDropComponent.OnCursor = self.OnCursor
  self:HideNum()
  PackageWalletCell.super.SetData(self, data)
  local sName = data.staticData.NameZh
  if data.debtType == 1 then
    self.walletNameLab.text = sName .. ZhString.Charactor_Infomation_FuZhai_Acc
  elseif data.debtType == 3 then
    self.walletNameLab.text = sName .. ZhString.Charactor_Infomation_FuZhai_limited
  else
    self.walletNameLab.text = sName
  end
  self.gameObject:SetActive(true)
  self.walletNumLab.text = data.num
  local bg = self:GetBgSprite()
  if bg then
    self:Hide(bg)
  end
  self.cantSale:SetActive(data.id ~= "wallet" and not ShopSaleProxy.Instance:IsThisItemCanSale(data.id) and not data.isWallet)
  self:UpdateChoose()
  self:UpdateDragable()
  if self.functionTip then
    self.functionTip:SetActive(false)
  end
end

function PackageWalletCell:SetChooseId(chooseId)
  self.chooseId = chooseId
  self:UpdateChoose()
end

function PackageWalletCell:UpdateChoose()
  if nil ~= self.choosen then
    if self.chooseId and self.data and self.data.staticData and self.data.staticData.id == self.chooseId then
      self.choosen:SetActive(true)
    else
      self.choosen:SetActive(false)
    end
  end
end

function PackageWalletCell:UpdateDragable()
  self.dragDrop:SetDragEnable(self.data.id ~= "wallet" and self.data.isWallet == true)
end

function PackageWalletCell:OnCellDestroy()
  TableUtility.TableClear(self.dragDrop)
end
