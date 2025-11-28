autoImport("MountFashionActiveMaterialTipCell")
MountFashionActiveCostPopUp = class("MountFashionActiveCostPopUp", BaseView)
MountFashionActiveCostPopUp.ViewType = UIViewType.PopUpLayer

function MountFashionActiveCostPopUp:Init()
  self.materials = {}
  self.lackMats = {}
  self:FindObjs()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.OnItemUpdate)
end

function MountFashionActiveCostPopUp:FindObjs()
  local grid = self:FindComponent("MaterialGrid", UIGrid)
  self.materialCtl = UIGridListCtrl.new(grid, MountFashionActiveMaterialTipCell, "EquipUpgradeMaterialTipCell")
  self.materialScrollView = self:FindComponent("ScrollView", UIScrollView)
  self.costZeny = self:FindComponent("CostZeny", UILabel)
  self.zenyCtrlSp = self:FindComponent("ZenyCtrl", UISprite)
  local confirmButton = self:FindGO("ConfirmButton")
  self.confirmLabel = self:FindComponent("Label", UILabel, confirmButton)
  self:AddClickEvent(confirmButton, function()
    self:OnConfirmBtnClick()
  end)
  self:AddButtonEvent("CancelButton", function()
    self:CloseSelf()
  end)
end

function MountFashionActiveCostPopUp:OnEnter()
  self.mountId = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.mountId
  self.styleId = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.styleId
  local config = Table_MountFashion[self.styleId]
  if config then
    local materials = config.ActiveMaterial
    self.costItemId = config.ActiveMoneyId or 100
    self.cost = config.ActiveMoney or 0
    if materials then
      for i = 1, #materials do
        local ret = materials[i]
        local data = {}
        data.itemId = ret[1]
        data.num = ret[2]
        self.materials[#self.materials + 1] = data
      end
    end
    IconManager:SetItemIconById(self.costItemId, self.zenyCtrlSp)
    self.costZeny.text = self.cost
    self:RefreshView()
  end
end

function MountFashionActiveCostPopUp:OnExit()
end

function MountFashionActiveCostPopUp:OnItemUpdate()
  self:RefreshView()
end

function MountFashionActiveCostPopUp:RefreshView()
  self.materialCtl:ResetDatas(self.materials)
  local _bagProxy = BagProxy.Instance
  TableUtility.ArrayClear(self.lackMats)
  for i = 1, #self.materials do
    local data = self.materials[i]
    local myNum = _bagProxy:GetItemNumByStaticID(data.itemId)
    if myNum < data.num then
      self.lackMats[#self.lackMats + 1] = {
        id = data.itemId,
        count = data.num - myNum
      }
      break
    end
  end
  self.confirmLabel.text = #self.lackMats > 0 and ZhString.EquipUpgradePopUp_QuickBuy or ZhString.AstrolabeView_Active
end

function MountFashionActiveCostPopUp:OnConfirmBtnClick()
  if #self.lackMats > 0 then
    QuickBuyProxy.Instance:TryOpenView(self.lackMats)
  else
    local myMoney = BagProxy.Instance:GetAllItemNumByStaticIDIncludeMoney(self.costItemId)
    if myMoney < self.cost then
      MsgManager.ShowMsgByID(40803)
    else
      local config = Table_MountFashion[self.styleId]
      if config then
        ServiceItemProxy.Instance:CallMountFashionActiveCmd(self.mountId, config.Pos, self.styleId)
        self:CloseSelf()
      end
    end
  end
end
