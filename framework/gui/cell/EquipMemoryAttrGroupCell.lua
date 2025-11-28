EquipMemoryAttrGroupCell = class("EquipMemoryAttrGroupCell", BaseCell)
autoImport("EquipMemoryAttrGroupSingleCell")

function EquipMemoryAttrGroupCell:Init()
  self.bg = self.gameObject:GetComponent(UISprite)
  self.tipLabel = self:FindGO("TIPLabel"):GetComponent(UILabel)
  self.listPart = self:FindGO("ListPart")
  self.listBg = self:FindGO("Bg", self.listPart):GetComponent(UISprite)
  self.listTable = self:FindGO("ListTable"):GetComponent(UITable)
  self.singleAttrCtrl = UIGridListCtrl.new(self.listTable, EquipMemoryAttrGroupSingleCell, "EquipMemoryAttrGroupSingleCell")
  self.arrow = self:FindGO("Arrow")
  self:AddCellClickEvent()
end

function EquipMemoryAttrGroupCell:SetData(data)
  self.data = data
  local color = data.color
  self.tipLabel.text = data.name
  if color == "special" then
    self.listTable.columns = 1
  else
    self.listTable.columns = 2
  end
  local list = data.list or {}
  self.singleAttrCtrl:ResetDatas(list)
  local validGroups = data.validgroup or {}
  local cells = self.singleAttrCtrl:GetCells()
  for i = 1, #cells do
    local _attrid = cells[i].data
    local _attrGroups = Game.ItemMemoryEffect[_attrid] and Game.ItemMemoryEffect[_attrid].Group
    local valid = false
    for j = 1, #validGroups do
      if _attrGroups[validGroups[j]] then
        valid = true
      end
    end
    cells[i]:SetValid(valid)
  end
  self.folderState = true
  self.arrow.transform.localRotation = Quaternion.Euler(0, 0, self.folderState and -90 or 90)
  self.listPart:SetActive(self.folderState)
  local size = NGUIMath.CalculateRelativeWidgetBounds(self.listTable.transform)
  self.listBg.height = size.size.y + 40
end

function EquipMemoryAttrGroupCell:SwitchFolderState()
  self.folderState = not self.folderState
  self.listPart:SetActive(self.folderState)
  self.arrow.transform.localRotation = Quaternion.Euler(0, 0, self.folderState and -90 or 90)
  if self.folderState then
    local size = NGUIMath.CalculateRelativeWidgetBounds(self.listTable.transform)
    self.listBg.height = size.size.y + 40
  end
end

function EquipMemoryAttrGroupCell:GetChildCells()
  return self.singleAttrCtrl:GetCells()
end
