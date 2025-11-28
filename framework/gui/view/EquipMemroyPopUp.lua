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
  EquipMemoryPopUp.super.InitUI(self)
  self.titleLabel = self:FindGO("Label"):GetComponent(UILabel)
  self.titleLabel.text = ZhString.EquipMemory_Equip
end

function EquipMemoryPopUp:ClickItem(cellCtl)
  local data = cellCtl.data
  xdlog("直接装备", self.memorydata.id, data.id)
  ServiceItemProxy.Instance:CallMemoryEmbedItemCmd(self.memorydata.id, data.id)
end

function EquipMemoryPopUp:UpdateData()
  if self.memorydata then
    local filterDatas = self.equipdatas
    self.itemCtl:ResetDatas(filterDatas)
    self.equipdatas = nil
  end
end
