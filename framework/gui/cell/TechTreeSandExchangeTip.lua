autoImport("BaseTip")
autoImport("TechTreeSandExchangeCell")
TechTreeSandExchangeTip = class("TechTreeSandExchangeTip", BaseTip)

function TechTreeSandExchangeTip:Init()
  self:FindObjs()
  self:AddEvents()
  self:InitData()
  self:InitTip()
end

function TechTreeSandExchangeTip:FindObjs()
  self.grid = self:FindComponent("Grid", UIGrid)
  local sandItem = self:FindGO("SandItem")
  self.sandSp = self:FindComponent("Sprite", UISprite, sandItem)
  self.sandLabel = self:FindComponent("Label", UILabel, sandItem)
end

function TechTreeSandExchangeTip:AddEvents()
  self:AddButtonEvent("ExchangeBtn", function()
    local sand = tonumber(self.sandLabel.text)
    if not sand or sand <= 0 then
      return
    end
    TechTreeProxy.CallSandExchange(self.materialItems)
  end)
end

function TechTreeSandExchangeTip:InitData()
  local matIds = ReusableTable.CreateArray()
  for id, _ in pairs(GameConfig.Item.item_to_sand) do
    TableUtility.ArrayPushBack(matIds, id)
  end
  table.sort(matIds)
  self.materialItems = {}
  local matId, matData
  for i = 1, #matIds do
    matId = matIds[i]
    matData = ItemData.new("SandExchange", matId)
    TableUtility.ArrayPushBack(self.materialItems, matData)
  end
  ReusableTable.DestroyAndClearArray(matIds)
end

function TechTreeSandExchangeTip:InitTip()
  self.listCtrl = UIGridListCtrl.new(self.grid, TechTreeSandExchangeCell, "TechTreeSandExchangeCell")
  self.listCtrl:AddEventListener(TechTreeSandExchangeCell.InputChange, self.OnInputChange, self)
  self.listCtrl:AddEventListener(TechTreeSandExchangeCell.InputSubmit, self.OnInputSubmit, self)
  IconManager:SetItemIcon(Table_Item[GameConfig.Item.SandOfTime].Icon, self.sandSp)
  self.closeComp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closeComp.callBack()
    TipsView.Me():HideCurrent()
  end
  
  self.closeComp:AddTarget(self.gameObject.transform)
end

local tempSum = 0
local calculateSum = function(cell, exchangeCfg)
  if not cell.data then
    return
  end
  tempSum = math.tointeger(tempSum + cell:GetCurSelectCount() * (exchangeCfg and exchangeCfg[cell.data.staticData.id] or 0) / 1000)
end

function TechTreeSandExchangeTip:UpdateSandLabel()
  tempSum = 0
  self:_ForEachCell(calculateSum, GameConfig.Item.item_to_sand)
  self.sandLabel.text = tostring(tempSum)
end

function TechTreeSandExchangeTip:SetData(data)
  self:OnEnter()
end

function TechTreeSandExchangeTip:SetPos(pos)
  TechTreeSandExchangeTip.super.SetPos(self, pos)
  self.listCtrl:Layout()
end

function TechTreeSandExchangeTip:SetCloseCall(closeCall, closeCallParam)
  self.closeCall = closeCall
  self.closeCallParam = closeCallParam
end

function TechTreeSandExchangeTip:AddIgnoreBounds(obj)
  if self.gameObject and self.closeComp then
    self.closeComp:AddTarget(obj.transform)
  end
end

function TechTreeSandExchangeTip:OnInputChange(cellCtl)
  if not cellCtl or not cellCtl.data then
    return
  end
  cellCtl:UpdateInputByRestCount(cellCtl.data.neednum - cellCtl:GetCurSelectCount())
  cellCtl.data.num = cellCtl:GetCurSelectCount()
  cellCtl:UpdateItemNum()
  self:UpdateSandLabel()
end

function TechTreeSandExchangeTip:OnInputSubmit(cellCtl)
  if not cellCtl or not cellCtl.data then
    return
  end
  local step = cellCtl.step or 1
  cellCtl.countInput.value = math.floor(cellCtl:GetCurSelectCount() / step) * step
end

function TechTreeSandExchangeTip:OnItemUpdate()
  for _, data in pairs(self.materialItems) do
    data.num = 0
    data.neednum = BagProxy.Instance:GetItemNumByStaticID(data.staticData.id)
  end
  self.listCtrl:ResetDatas(self.materialItems)
  local cells = self.listCtrl:GetCells()
  for _, cell in pairs(cells) do
    self:OnInputChange(cell)
  end
end

function TechTreeSandExchangeTip:OnEnter()
  EventManager.Me():AddEventListener(ItemEvent.ItemUpdate, self.OnItemUpdate, self)
  self:OnItemUpdate()
end

function TechTreeSandExchangeTip:OnExit()
  self.closeComp = nil
  if self.closeCall then
    self.closeCall(self.closeCallParam)
  end
  EventManager.Me():RemoveEventListener(ItemEvent.ItemUpdate, self.OnItemUpdate, self)
  return true
end

function TechTreeSandExchangeTip:DestroySelf()
  if not Slua.IsNull(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end

function TechTreeSandExchangeTip:_ForEachCell(action, ...)
  local cells = self.listCtrl:GetCells()
  for _, cell in pairs(cells) do
    if cell.data then
      action(cell, ...)
    end
  end
end
