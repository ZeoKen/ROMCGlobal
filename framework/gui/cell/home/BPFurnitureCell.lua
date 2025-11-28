BPFurnitureCell = class("BPFurnitureCell", BaseCell)

function BPFurnitureCell:Init()
  BPFurnitureCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
end

function BPFurnitureCell:FindObjs()
  self.objIcon = self:FindGO("sprIcon")
  self.sprIcon = self.objIcon:GetComponent(UISprite)
  self.labProgress = self:FindComponent("labProgress", UILabel)
  self.objSelect = self:FindGO("objSelect")
end

function BPFurnitureCell:AddEvts()
  self:AddCellClickEvent()
end

function BPFurnitureCell:SetData(data)
  self.data = data
  local haveData = data ~= nil
  self:Select(self.data and self.data.isSelect)
  if self.isActive ~= haveData then
    self.gameObject:SetActive(haveData)
    self.isActive = haveData
  end
  if not haveData then
    return
  end
  local itemSData = Table_Item[data.staticData.id]
  local setSuc = IconManager:SetItemIcon(itemSData and itemSData.Icon or "item_45001", self.sprIcon)
  self.objIcon:SetActive(setSuc)
  if setSuc then
    self.sprIcon:MakePixelPerfect()
  end
  self.labProgress.text = string.format("%d/%d", data.haveNum, data.needNum)
end

function BPFurnitureCell:Select(isSelect)
  if self.isSelect ~= isSelect then
    self.isSelect = isSelect
    self.objSelect:SetActive(isSelect == true)
    if self.data then
      self.data.isSelect = isSelect
    end
  end
end
