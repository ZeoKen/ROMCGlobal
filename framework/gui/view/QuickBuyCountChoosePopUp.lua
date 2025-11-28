QuickBuyCountChoosePopUp = class("QuickBuyCountChoosePopUp", BaseView)
autoImport("EquipUpgradeMaterialTipCell")
QuickBuyCountChoosePopUp.ViewType = UIViewType.PopUpLayer
local DefaultSearchBagTypes = {
  BagProxy.BagType.MainBag
}

function QuickBuyCountChoosePopUp:InitData()
  local goods = self.viewdata.viewdata and self.viewdata.viewdata.goods or 0
  local bagTypes = self.viewdata.viewdata and self.viewdata.viewdata.bagTypes or DefaultSearchBagTypes
  self.data = {}
  for i = 1, #goods do
    local buyData = {
      id = goods[i].id,
      neednum = goods[i].neednum,
      hideSearch = true,
      bagTypes = bagTypes
    }
    table.insert(self.data, buyData)
  end
end

function QuickBuyCountChoosePopUp:Init()
  self:InitData()
  self.countlabel = self:FindComponent("Count", UILabel)
  self.countInput = self:FindComponent("CountCtrl", UIInput)
  self.countInput.value = 1
  EventDelegate.Set(self.countInput.onChange, function()
    self:OnInputChange()
  end)
  self.countSubtract = self:FindGO("CountSubtract")
  self.countPlus = self:FindGO("CountPlus")
  self:AddClickEvent(self.countSubtract, function()
    self:OnClickCountSubtract()
  end)
  self:AddClickEvent(self.countPlus, function()
    self:OnClickCountPlus()
  end)
  self.confirmButton = self:FindGO("ConfirmButton")
  self:AddClickEvent(self.confirmButton, function()
    self:DoConfirm()
  end)
  self.cancelButton = self:FindGO("CancelButton")
  self:AddClickEvent(self.cancelButton, function()
    self:CloseSelf()
  end)
  local matGrid = self:FindComponent("MaterialGrid", UIGrid)
  self.matCtrl = UIGridListCtrl.new(matGrid, EquipUpgradeMaterialTipCell, "EquipUpgradeMaterialTipCell")
end

function QuickBuyCountChoosePopUp:GetCurCount()
  return math.floor(tonumber(self.countInput.value) or 0)
end

function QuickBuyCountChoosePopUp:OnInputChange()
  self:Refresh()
end

function QuickBuyCountChoosePopUp:OnClickCountSubtract()
  self.countInput.value = math.max(self:GetCurCount() - 1, 1)
end

function QuickBuyCountChoosePopUp:OnClickCountPlus()
  self.countInput.value = self:GetCurCount() + 1
end

function QuickBuyCountChoosePopUp:DoConfirm()
  local lackItem = {}
  for i = 1, #self.data do
    table.insert(lackItem, {
      id = self.data[i].id,
      count = self.data[i].num
    })
  end
  self:CloseSelf()
  QuickBuyProxy.Instance:TryOpenView(lackItem)
end

function QuickBuyCountChoosePopUp:Refresh()
  local curCount = self:GetCurCount()
  for i = 1, #self.data do
    self.data[i].num = self.data[i].neednum * curCount
  end
  self.matCtrl:ResetDatas(self.data)
end

function QuickBuyCountChoosePopUp:OnEnter()
  QuickBuyCountChoosePopUp.super.OnEnter(self)
  self:Refresh()
end

function QuickBuyCountChoosePopUp:OnExit()
end
