autoImport("ActivityExchangeMaterialCell")
ActivityExchangeInfoCell = class("ActivityExchangeInfoCell", BaseCell)

function ActivityExchangeInfoCell:Init()
  self:FindObjs()
  local panel = UIUtil.GetComponentInParents(self.gameObject, UIPanel)
  if panel then
    self.itemPanel.depth = panel.depth + 1
  end
  self.tipData = {}
  self.tipData.funcConfig = {}
end

function ActivityExchangeInfoCell:LoadPrefab(prefabName, parent)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(prefabName))
  if not cellpfb then
    error("can not find pfb" .. tostring(prefabName))
    return
  end
  cellpfb.transform:SetParent(parent.transform, false)
  LuaGameObject.SetLocalPositionObj(cellpfb, 0, 0, 0)
  return cellpfb
end

function ActivityExchangeInfoCell:FindObjs()
  self.widget = self.gameObject:GetComponent(UIWidget)
  self.itemPanel = self:FindComponent("ItemPanel", UIPanel)
  self.grid = self:FindComponent("Grid", UIGrid)
  self.materialListCtrl = UIGridListCtrl.new(self.grid, ActivityExchangeMaterialCell, "ActivityExchangeMaterialCell")
  self.materialListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnItemClick, self)
  self.exchangeBtn = self:FindGO("ExchangeBtn")
  self.exchangeBtnCollider = self.exchangeBtn:GetComponent(BoxCollider)
  self:AddClickEvent(self.exchangeBtn, function()
    self:OnExchangeBtnClick()
  end)
  self.remainNumLabel = self:FindComponent("RemainNum", UILabel)
  self.check = self:FindGO("Check")
end

function ActivityExchangeInfoCell:SetData(data)
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
      local go = self:LoadPrefab("ActivityExchangeItemCell", self.grid)
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

function ActivityExchangeInfoCell:SetState(state)
  self.widget.alpha = state and 1 or 0.5
  self.check:SetActive(not state)
  self.exchangeBtn:SetActive(state)
end

function ActivityExchangeInfoCell:SetExchangeBtnState(state)
  if state then
    self:SetTextureWhite(self.exchangeBtn, LuaGeometry.GetTempVector4(0.6666666666666666, 0.3764705882352941, 0.00784313725490196, 1))
    self.exchangeBtnCollider.enabled = true
  else
    self:SetTextureGrey(self.exchangeBtn)
    self.exchangeBtnCollider.enabled = false
  end
end

function ActivityExchangeInfoCell:OnExchangeBtnClick()
  if self.data then
    local materials = self.data.exchangeItem.cost
    local matNum = #materials
    local params = {matNum}
    for i = 1, matNum do
      local mat = materials[i]
      params[#params + 1] = mat[1]
      params[#params + 1] = mat[2]
    end
    local target = self.data.exchangeItem.item[1]
    local config = Table_Item[target]
    local name = config and config.NameZh or ""
    params[#params + 1] = name
    MsgManager.DontAgainConfirmMsgByID(43519, function()
      ServiceActivityCmdProxy.Instance:CallActExchangeItemCmd(self.data.act_id, self.data.index)
    end, nil, nil, unpack(params))
  end
end

function ActivityExchangeInfoCell:OnItemClick(cell)
  self.tipData.itemdata = cell.data
  self:ShowItemTip(self.tipData, cell.bg, NGUIUtil.AnchorSide.Right, {200, 0})
end
