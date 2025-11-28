autoImport("BaseCell")
EquipIntegrateTogCell = class("EquipIntegrateTogCell", BaseCell)

function EquipIntegrateTogCell:Init()
  self.checkMark = self:FindGO("CheckMark")
  self.label = self:FindGO("Label"):GetComponent(UILabel)
end

function EquipIntegrateTogCell:SetData(data)
  self.data = data
  self.label.text = data and data.Name
end

function EquipIntegrateTogCell:SetChoose(bool)
  self.label.color = bool and LuaColor.White() or LuaGeometry.GetTempVector4(0.23137254901960785, 0.3176470588235294, 0.6274509803921569, 1)
  self.checkMark:SetActive(bool)
end
