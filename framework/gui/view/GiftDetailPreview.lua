autoImport("TicketPreview")
GiftDetailPreview = class("GiftDetailPreview", TicketPreview)
GiftDetailPreview.ViewType = UIViewType.Lv4PopUpLayer

function GiftDetailPreview:InitData()
  self.chooseId = self.viewdata.viewdata
  self.products = {}
end

function GiftDetailPreview:InitView()
  self.listCtrl = UIGridListCtrl.new(self.grid, TicketPreviewCell, "RecipeCell")
  self:AddDragEvent(self.roleTex.gameObject, function(go, delta)
    self:RotateRoleEvt(go, delta)
  end)
end

function GiftDetailPreview:ListProducts()
  TableUtility.ArrayClear(self.products)
  if self.chooseId then
    local itemData = ItemData.new(nil, self.chooseId)
    self.products = {itemData}
    self.listCtrl:ResetDatas(self.products)
    local cells = self.listCtrl:GetCells()
    for _, cell in pairs(cells) do
      cell:SetChoose(self.chooseId)
    end
  end
end

local addDepth = 20

function GiftDetailPreview:AdjustDepth()
  if self.adjustDepth then
    return
  end
  self.adjustDepth = true
  local panels = self:FindComponents(UIPanel)
  for i = 1, #panels do
    panels[i].depth = panels[i].depth + addDepth
  end
end
