autoImport("BaseItemResultCell")
BaseItemResultView = class("BaseItemResultView", BaseView)
BaseItemResultView.CellControl = BaseItemResultCell
BaseItemResultView.CellPrefabName = "BaseItemResultCell"
BaseItemResultView.CellWidth = 170
BaseItemResultView.PackageCheck = {
  1,
  8,
  9
}
BaseItemResultView.ViewType = UIViewType.PopUpLayer
local bagIns

function BaseItemResultView:Init()
  if not bagIns then
    bagIns = BagProxy.Instance
  end
  self:InitView()
  self:AddListenEvts()
  self:InitSnapshot()
end

function BaseItemResultView:InitView()
  self.grid = self:FindComponent("Grid", UIGrid)
  self.gridTrans = self.grid.transform
  self.normalStick = self:FindComponent("NormalStick", UIWidget)
  self.listCtrl = ListCtrl.new(self.grid, self.CellControl, self.CellPrefabName)
  self.listCtrl:AddEventListener(MouseEvent.MouseClick, self.ShowItemTip, self)
  local titleLabel = self:FindComponent("TitleLabel", UILabel)
  titleLabel.text = self.Title or ""
end

function BaseItemResultView:AddListenEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.OnItemUpdate)
end

function BaseItemResultView:InitSnapshot()
  self.initialSnapshot = {}
  self:MakeSnapshot(self.initialSnapshot)
end

function BaseItemResultView:OnItemUpdate()
  self:ResetDatas()
end

function BaseItemResultView:ResetDatas()
  local datas = self:GetResultDatas() or _EmptyTable
  self:AssignGrid(datas)
  self.listCtrl:ResetDatas(datas)
end

function BaseItemResultView:GetResultDatas()
  self.result = self.result or {}
  TableUtility.ArrayClear(self.result)
  local snapshot = ReusableTable.CreateTable()
  self:MakeSnapshot(snapshot)
  for guid, newNum in pairs(snapshot) do
    if not self.initialSnapshot[guid] or newNum > self.initialSnapshot[guid] then
      TableUtility.ArrayPushBack(self.result, guid)
    end
  end
  ReusableTable.DestroyAndClearTable(snapshot)
  table.sort(self.result)
  for i = 1, #self.result do
    self.result[i] = bagIns:GetItemByGuid(self.result[i], self.PackageCheck)
  end
  return self.result
end

local makeSnapshot = function(map, bagType)
  local bagData = bagIns.bagMap[bagType]
  if bagData then
    local items, itemData = bagData:GetItems()
    for i = 1, #items do
      itemData = items[i]
      map[itemData.id] = (map[itemData.id] or 0) + itemData.num
    end
  end
end

function BaseItemResultView:MakeSnapshot(map)
  for _, bagType in pairs(self.PackageCheck) do
    makeSnapshot(map, bagType)
  end
end

function BaseItemResultView:AssignGrid(data)
  if #data <= 5 then
    self.grid.pivot = UIWidget.Pivot.Center
    self.gridTrans.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
  else
    self.grid.pivot = UIWidget.Pivot.Left
    self.gridTrans.localPosition = LuaGeometry.GetTempVector3(-2 * self.CellWidth, 0, 0)
  end
end

function BaseItemResultView:ShowItemTip(cellCtl)
  local go = cellCtl.gameObject
  if not go then
    return
  end
  local tempV3 = LuaGeometry.GetTempVector3(LuaGameObject.GetPosition(go.transform))
  local isGoRight
  if tempV3.x == 0 then
    isGoRight = 1
  else
    isGoRight = tempV3.x / math.abs(tempV3.x)
  end
  tempV3.x = -isGoRight * 0.8 + tempV3.x
  tempV3.y = 0
  self.normalStick.gameObject.transform.position = tempV3
  self:_ShowItemTip(cellCtl.data, isGoRight)
end

function BaseItemResultView:_ShowItemTip(data, isGoRight)
  if not data then
    TipManager.CloseTip()
    return
  end
  self.tipData = self.tipData or {
    funcConfig = _EmptyTable
  }
  self.tipData.itemdata = data
  TipManager.Instance:ShowItemFloatTip(self.tipData, self.normalStick, 0 < isGoRight and NGUIUtil.AnchorSide.Left or NGUIUtil.AnchorSide.Right)
end
