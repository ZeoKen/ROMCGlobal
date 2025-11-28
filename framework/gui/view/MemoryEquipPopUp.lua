MemoryEquipPopUp = class("MemoryEquipPopUp", BaseView)
MemoryEquipPopUp.ViewType = UIViewType.PopUpLayer
autoImport("MemoryEquipCell")
local _ValidSites = {
  1,
  2,
  3,
  4,
  5,
  6
}
local _targetEquipCheck = {
  1,
  2,
  20
}
local _EquipMemoryProxy

function MemoryEquipPopUp:Init()
  self:AddGameObjectComp()
  if self.viewdata.viewdata then
    self.itemdata = self.viewdata.viewdata.itemdata
  end
  _EquipMemoryProxy = EquipMemoryProxy.Instance
  self:MapEvent()
  self:InitUI()
  self:InitShow()
end

function MemoryEquipPopUp:InitUI()
  self.title = self:FindGO("Title"):GetComponent(UILabel)
  self.scrollView = self:FindGO("ScrollView"):GetComponent(UIScrollView)
  self.grid = self:FindGO("Grid"):GetComponent(UIGrid)
  self.siteCtrl = UIGridListCtrl.new(self.grid, MemoryEquipCell, "MemoryEquipCell")
  self.siteCtrl:AddEventListener(UICellEvent.OnCellClicked, self.handleDoEquip, self)
  self.siteCtrl:AddEventListener(UICellEvent.OnRightBtnClicked, self.handleShowItemTip, self)
end

function MemoryEquipPopUp:InitShow()
  if not self.validEquipPos then
    self.validEquipPos = {}
    local staticData = Table_ItemMemory[self.itemdata.staticData.id]
    local equipPoses = staticData.CanEquip and staticData.CanEquip.EquipPos
    for i = 1, #equipPoses do
      if not self.validEquipPos[equipPoses[i]] then
        self.validEquipPos[equipPoses[i]] = 1
      end
    end
  end
  local result = {}
  for _pos, _ in pairs(self.validEquipPos) do
    local posData = _EquipMemoryProxy:GetPosData(_pos)
    if posData then
      local itemData = ItemData.new("MemoryData", posData.staticId)
      itemData.equipMemoryData = posData:Clone()
      local _tempData = {itemdata = itemData, site = _pos}
      table.insert(result, _tempData)
    else
      local _tempData = {site = _pos}
      table.insert(result, _tempData)
    end
  end
  if 5 < #result then
    self.scrollView.contentPivot = UIWidget.Pivot.Left
  else
    self.scrollView.contentPivot = UIWidget.Pivot.Center
  end
  self.siteCtrl:ResetDatas(result)
  self.scrollView:ResetPosition()
end

function MemoryEquipPopUp:MapEvent()
  self:AddListenEvt(ItemEvent.MemoryUpdate, self.CloseSelf)
end

function MemoryEquipPopUp:handleDoEquip(cellCtrl)
  local data = cellCtrl.data
  local site = data.site
  local itemGuid = self.itemdata.id
  if itemGuid and site then
    ServiceItemProxy.Instance:CallMemoryEmbedItemCmd(itemGuid, site)
  end
end

function MemoryEquipPopUp:handleShowItemTip(cellCtrl)
  local data = cellCtrl.data
  local itemdata = data and data.itemdata
  if itemdata == nil then
    return
  end
  local sdata = {
    itemdata = itemdata,
    funcConfig = {}
  }
  self:ShowItemTip(sdata, cellCtrl.widget, nil, {-190, 0})
end
