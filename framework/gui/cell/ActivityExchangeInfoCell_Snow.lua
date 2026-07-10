autoImport("ActivityExchangeInfoCell")
ActivityExchangeInfoCell_Snow = class("ActivityExchangeInfoCell_Snow", ActivityExchangeInfoCell)

function ActivityExchangeInfoCell_Snow:FindObjs()
  self.widget = self.gameObject:GetComponent(UIWidget)
  self.itemPanel = self:FindComponent("ItemPanel", UIPanel)
  self.grid = self:FindComponent("Grid", UIGrid)
  self.materialListCtrl = UIGridListCtrl.new(self.grid, ActivityExchangeMaterialCell, "ActivityExchangeMaterialCell_Snow")
  self.materialListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnItemClick, self)
  self.exchangeBtn = self:FindGO("ExchangeBtn")
  self.exchangeBtnCollider = self.exchangeBtn:GetComponent(BoxCollider)
  self:AddClickEvent(self.exchangeBtn, function()
    self:OnExchangeBtnClick()
  end)
  self.remainNumLabel = self:FindComponent("RemainNum", UILabel)
  self.check = self:FindGO("Check")
end

function ActivityExchangeInfoCell_Snow:SetData(data)
  self.data = data
  if data then
    local exchangeItemData = data.exchangeItem
    local datas = ReusableTable.CreateArray()
    local materials = exchangeItemData.cost
    local matNum = #materials
    for i = 1, matNum do
      local mat = materials[i]
      local itemId = mat[1]
      local num = mat[2]
      local itemData = ItemData.new("material", itemId)
      itemData.num = num
      datas[#datas + 1] = itemData
    end
    self.materialListCtrl:ResetDatas(datas, nil, false)
    ReusableTable.DestroyArray(datas)
    if not self.exchangeItemCell then
      local go = self:LoadPrefab("ActivityExchangeItemCell_Snow", self.grid)
      self.exchangeItemCell = ActivityExchangeItemCell.new(go)
      self.exchangeItemCell:AddEventListener(MouseEvent.MouseClick, self.OnItemClick, self)
    end
    local item = exchangeItemData.item
    local itemData = ItemData.new("item", item[1])
    itemData.num = item[2]
    self.exchangeItemCell:SetData(itemData)
    local childCount = self.grid.transform.childCount
    self.exchangeItemCell.trans:SetSiblingIndex(childCount - 1)
    self.materialListCtrl:ResetPosition()
    local totalExchangeNum = exchangeItemData.exchange_count
    local exchangedNum = ActivityExchangeProxy.Instance:GetExchangedCount(data.act_id, data.index)
    if totalExchangeNum and 0 < totalExchangeNum then
      local remainNum = totalExchangeNum - exchangedNum
      self.remainNumLabel.text = string.format(ZhString.ActivityExchange_RemainNum, remainNum, totalExchangeNum)
    end
    self.remainNumLabel.gameObject:SetActive(totalExchangeNum and totalExchangeNum > exchangedNum or false)
    self:SetState(not totalExchangeNum or totalExchangeNum > exchangedNum)
    local canExchange = ActivityExchangeProxy.Instance:CheckItemCanExchange(data.act_id, data.index)
    self:SetExchangeBtnState(canExchange)
  end
end
