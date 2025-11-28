autoImport("UseCardPopUp")
EquipMemoryPopUp = class("EquipMemoryPopUp", UseCardPopUp)

function EquipMemoryPopUp:Init()
  if self.viewdata.viewdata then
    self.memorydata = self.viewdata.viewdata.memoryData
    self.equipdatas = self.viewdata.viewdata.equipdatas
  end
  self:InitUI()
  self:MapEvent()
end

function EquipMemoryPopUp:InitUI()
  self.itemCtl = WrapListCtrl.new(self:FindGO("ItemGrid"), EquipTipCell_Memory, "EquipTipCell", 2, nil, nil, true)
  self.itemCtl:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self)
  self.titleLabel = self:FindGO("Label"):GetComponent(UILabel)
  self.titleLabel.text = ZhString.EquipMemory_Equip
  self:UpdateData()
end

function EquipMemoryPopUp:ClickItem(cellCtl)
  local data = cellCtl.data
  xdlog("直接装备", self.memorydata.id, data.id)
  ServiceItemProxy.Instance:CallMemoryEmbedItemCmd(self.memorydata.id, data.id)
  self.callServer = true
end

function EquipMemoryPopUp:UpdateData()
  if self.memorydata then
    local filterDatas = self.equipdatas
    self.itemCtl:ResetDatas(filterDatas)
    self.equipdatas = nil
  end
end
