autoImport("EquipMakeView")
ItemMakeView = class("ItemMakeView", EquipMakeView)
ItemMakeView.ViewType = UIViewType.NormalLayer

function ItemMakeView:Init()
  self.isSelfProfession = false
  ItemMakeView.super.Init(self)
  self:HideDiffGO()
end

function ItemMakeView:HideDiffGO()
  self:Hide(self.selfProfession.gameObject)
  local makeTip = self:FindGO("MakeTipBord")
  self:Hide(makeTip.gameObject)
end

function ItemMakeView:UpdateMakeList()
  local data = EquipMakeProxy.Instance:GetMakeList()
  self.itemWrapHelper:UpdateInfo(data)
  local isEmpty = #data == 0
  if isEmpty then
    self:UpdateEmpty()
  end
  self.emptyTip:SetActive(isEmpty)
  return isEmpty
end

function ItemMakeView:AddViewEvts()
  ItemMakeView.super.AddViewEvts(self)
  self:AddListenEvt(ItemEvent.FoodUpdate, self.UpdateItem)
end
