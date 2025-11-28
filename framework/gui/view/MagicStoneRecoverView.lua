autoImport("EquipChooseBord")
autoImport("EquipRecoverCell")
MagicStoneRecoverView = class("MagicStoneRecoverView", ContainerView)
MagicStoneRecoverView.ViewType = UIViewType.NormalLayer

function MagicStoneRecoverView:OnExit()
  EquipRecoverProxy.Instance:SetCurrency()
  MagicStoneRecoverView.super.OnExit(self)
end

function MagicStoneRecoverView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitView()
end

function MagicStoneRecoverView:FindObjs()
  self.addItemButton = self:FindGO("AddItemButton")
  self.targetBtn = self:FindGO("TargetCell")
  self.totalCost = self:FindGO("TotalCost"):GetComponent(UILabel)
  self.totalCostIcon = self:FindGO("Sprite", self.totalCost.gameObject):GetComponent(UISprite)
  self.effectParent = self:FindGO("RightBg")
  self:PlayUIEffect(EffectMap.UI.EquipStreng_UI_3_55, self.effectParent)
end

local cardids = {}

function MagicStoneRecoverView:AddEvts()
  local recoverButton = self:FindGO("RecoverButton")
  self:AddClickEvent(recoverButton, function()
    if self.nowdata then
      if BagProxy.Instance:GetItemNumByStaticID(self.currency) < tonumber(self.totalCost.text) then
        MsgManager.ShowMsgByID(8)
        return
      end
      local cells = self.recoverCtl:GetCells()
      local strength = false
      local enchant = false
      TableUtility.ArrayClear(cardids)
      if 0 < #cells then
        for i = 1, 2 do
          if cells[i].data ~= EquipRecoverProxy.RecoverType.EmptyCard and cells[i].toggle.value then
            TableUtility.ArrayPushBack(cardids, cells[i].data.id)
          end
        end
      end
      local cardCount = #cardids
      local bagData = BagProxy.Instance:GetBagByType(BagProxy.BagType.MainBag)
      if cardCount > bagData:GetSpaceItemNum() then
        MsgManager.ShowMsgByID(3101)
        return
      end
      if strength or 0 < cardCount or enchant then
        ServiceItemProxy.Instance:CallRestoreEquipItemCmd(self.nowdata.id, strength, cardids, enchant)
      end
    end
  end)
end

function MagicStoneRecoverView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.ItemRestoreEquipItemCmd, self.HandleRecover)
end

function MagicStoneRecoverView:InitView()
  self.currency = 12523
  local item = Table_Item[self.currency]
  if item then
    IconManager:SetItemIcon(item.Icon, self.totalCostIcon)
  end
  EquipRecoverProxy.Instance:SetCurrency(self.currency)
  local chooseContaienr = self:FindGO("ChooseContainer")
  self.chooseBord = EquipChooseBord.new(chooseContaienr, function()
    return EquipRecoverProxy.Instance:GetMagicStoneRecover()
  end)
  self.chooseBord:AddEventListener(EquipChooseBord.ChooseItem, self.ChooseItem, self)
  self.targetCell = BaseItemCell.new(self.targetBtn)
  local recoverGrid = self:FindComponent("RecoverGrid", UIGrid)
  self.recoverCtl = UIGridListCtrl.new(recoverGrid, EquipRecoverCell, "EquipRecoverCell")
  self.recoverCtl:AddEventListener(EquipRecoverEvent.Select, self.HandleSelect, self)
  self:UpdateChooseBord()
end

function MagicStoneRecoverView:ChooseItem(itemData)
  self.nowdata = itemData
  self.targetCell:SetData(itemData)
  self.recoverCtl:ResetDatas(EquipRecoverProxy.Instance:GetMagicStoneRecoverToggle(itemData))
  self.targetBtn:SetActive(itemData ~= nil)
  self.addItemButton:SetActive(itemData == nil)
end

function MagicStoneRecoverView:UpdateChooseBord()
  local equipdatas = EquipRecoverProxy.Instance:GetMagicStoneRecover()
  self.chooseBord:ResetDatas(equipdatas, true)
end

function MagicStoneRecoverView:HandleSelect(cellctl)
  local totalCost = 0
  local cells = self.recoverCtl:GetCells()
  for i = 1, #cells do
    if cells[i].toggle.value then
      totalCost = totalCost + tonumber(cells[i].cost.text)
    end
  end
  self.totalCost.text = totalCost
end

function MagicStoneRecoverView:HandleRecover()
  self:UpdateChooseBord()
  self:ChooseItem()
end
