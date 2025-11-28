autoImport("ItemCell")
ExtractionCostCell = class("ExtractionCostCell", ItemCell)

function ExtractionCostCell:Init()
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(UICellEvent.OnCellClicked, self)
  end)
  self.itemContainerGO = self:FindGO("ItemContainer")
  local obj = self:LoadPreferb("cell/ItemCell", self.itemContainerGO)
  LuaGameObject.SetLocalPositionGO(obj, 0, 0, 0)
  ExtractionCostCell.super.Init(self)
  self.discountGO = self:FindGO("Discount")
  self.discountLab = self:FindComponent("Label", UILabel, self.discountGO)
  self.chooseBtnGO = self:FindGO("ChooseBtn")
  self.numLab = self:FindComponent("CostNum", UILabel)
end

function ExtractionCostCell:SetData(data)
  self.cellData = data
  if data then
    local discount = data.discount or 1
    if discount < 1 then
      self.discountGO:SetActive(true)
      self.discountLab.text = string.format(ZhString.MagicBox_Discount, 100 - discount * 100)
    else
      self.discountGO:SetActive(false)
    end
    if not self.itemData then
      self.itemData = ItemData.new("ExtractionCost", data.itemId)
    else
      self.itemData:ResetData("ExtractionCost", data.itemId)
    end
    ExtractionCostCell.super.SetData(self, self.itemData)
    self:HideNum(true)
    local cost = data.costNum or 0
    cost = math.floor(cost * discount)
    local owned = data.ownedNum or 0
    local isEquip = not not data.isEquip
    if isEquip and cost < owned then
      owned = cost
    end
    self.chooseBtnGO:SetActive(isEquip)
    if not data:IsMoney() then
      if cost > owned then
        self.numLab.text = string.format("[c][CF1C0F]%d[-][/c]/%d", owned, cost)
      else
        self.numLab.text = string.format("%d/%d", owned, cost)
      end
    elseif cost > owned then
      self.numLab.text = string.format("[c][CF1C0F]%d[-][/c]", cost)
    else
      self.numLab.text = cost
    end
  end
end
