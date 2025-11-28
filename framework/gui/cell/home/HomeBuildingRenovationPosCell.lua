HomeBuildingRenovationPosCell = class("HomeBuildingRenovationPosCell", BaseCell)
local m_colorSelect = {
  0.24313725490196078,
  0.34901960784313724,
  0.6549019607843137,
  1
}
local m_colorUnselectEffect = {
  1,
  1,
  1,
  0.2
}

function HomeBuildingRenovationPosCell:Init()
  HomeBuildingRenovationPosCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
end

function HomeBuildingRenovationPosCell:FindObjs()
  local objName = self:FindGO("labName")
  objName:SetActive(true)
  self.labName = objName:GetComponent(UILabel)
  self:FindGO("Icon"):SetActive(false)
end

function HomeBuildingRenovationPosCell:AddEvts()
  self:AddClickEvent(self.gameObject, function()
    self:ChangeMaterial()
  end)
end

function HomeBuildingRenovationPosCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(data ~= nil)
  if not data then
    return
  end
  self.labName.text = data.posText
end

function HomeBuildingRenovationPosCell:SetTargetMatetialID(materialID, defaultMatID)
  self.tarMaterialID = materialID
  self.defaultMatID = defaultMatID
  self.isTargetMaterial = HomeManager.Me():IsSameMatetial(self.tarMaterialID, self.data.meshRenderer.material.name)
  self.labName.color = self.isTargetMaterial and m_colorSelect or LuaColor.white
  self.labName.effectColor = self.isTargetMaterial and LuaColor.white or m_colorUnselectEffect
end

function HomeBuildingRenovationPosCell:ChangeMaterial()
  local targetID = not (not self.tarMaterialID or self.isTargetMaterial) and self.tarMaterialID or self.defaultMatID
  if not targetID then
    LogUtility.Error("没有设置MaterialID，无法更换材质！")
    return
  end
  HomeManager.Me():Renovation(targetID, self.data.floorIndex)
  self.isTargetMaterial = not self.isTargetMaterial
  self.labName.color = self.isTargetMaterial and m_colorSelect or LuaGeometry.GetTempColor()
  self.labName.effectColor = self.isTargetMaterial and LuaGeometry.GetTempColor() or m_colorUnselectEffect
end
