autoImport("ItemCell")
BaseItemResultCell = class("BaseItemResultCell", ItemCell)
BaseItemResultCell.ItemCellName = "ItemCell"

function BaseItemResultCell:Init()
  local obj = self:LoadPreferb("cell/" .. self.ItemCellName, self.gameObject)
  obj.transform.localPosition = LuaGeometry.GetTempVector3()
  BaseItemResultCell.super.Init(self)
  self:HideNum()
  self:AddCellClickEvent()
end

function BaseItemResultCell:SetData(data)
  BaseItemResultCell.super.SetData(self, data)
  self:ActiveNewTag(false)
end
