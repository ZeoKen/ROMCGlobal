autoImport("ItemNewCell")
DyeMakeMaterialCell = class("DyeMakeMaterialCell", ItemNewCell)

function DyeMakeMaterialCell:Init()
  local obj = self:LoadPreferb("cell/ItemNewCell", self.gameObject)
  obj.transform.localPosition = LuaVector3.Zero()
  DyeMakeMaterialCell.super.Init(self)
  self:FindObjs()
  self:AddCellClickEvent()
end

function DyeMakeMaterialCell:FindObjs()
  self.countDesc = self:FindGO("CountLab"):GetComponent(UILabel)
end

function DyeMakeMaterialCell:SetData(data)
  if data then
    DyeMakeMaterialCell.super.SetData(self, data)
    if self.numLab then
      self.numLab.text = ""
    end
    local itemid = data.staticData.id
    local own = EquipMakeProxy.Instance:GetItemNumByStaticID(itemid)
    if own >= data.num then
      self.lackItems = nil
      self.countDesc.text = tostring(own) .. "/" .. tostring(data.num)
    else
      self.lackItems = self.lackItems or {}
      self.lackItems.id = itemid
      self.lackItems.count = data.num - own
      self.countDesc.text = string.format("[c][FF6021FF]%s[-][/c]/%s", tostring(own), tostring(data.num))
    end
  end
  self.data = data
end

function DyeMakeMaterialCell:GetLackItems()
  return self.lackItems
end

function DyeMakeMaterialCell:IsEnough()
  return nil == self.lackItems
end
