EquipMemoryAttrGroupSingleCell = class("EquipMemoryAttrGroupSingleCell", BaseCell)

function EquipMemoryAttrGroupSingleCell:Init()
  self.text = self.gameObject:GetComponent(UILabel)
end

function EquipMemoryAttrGroupSingleCell:SetData(data)
  self.data = data
  local attrConfig = Game.ItemMemoryEffect[data]
  if attrConfig then
    local buffDesc
    local staticId = attrConfig.level and attrConfig.level[1]
    local staticData = staticId and Table_ItemMemoryEffect[staticId]
    if staticData then
      local buffid = staticData.BuffID
      if buffid and buffid ~= _EmptyTable then
        self.text.width = 180
      end
      local waxBuffid = staticData.WaxBuffID
      if waxBuffid and 0 < #waxBuffid then
        self.text.width = 420
      end
      self.text.text = staticData and staticData.WaxDesc
    end
  end
end

function EquipMemoryAttrGroupSingleCell:SetValid(bool)
  self.text.color = bool and LuaGeometry.GetTempVector4(0.28627450980392155, 0.48627450980392156, 0.7607843137254902, 1) or LuaGeometry.GetTempVector4(0.4235294117647059, 0.4235294117647059, 0.4235294117647059, 1)
end
