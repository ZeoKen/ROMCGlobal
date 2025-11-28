HomeBuildingTypeCell = class("HomeBuildingTypeCell", BaseCell)
local m_colorSelect = LuaColor(0.12156862745098039, 0.4549019607843137, 0.7490196078431373, 1)

function HomeBuildingTypeCell:Init()
  HomeBuildingTypeCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
end

function HomeBuildingTypeCell:FindObjs()
  local objIcon = self:FindGO("Icon")
  self.tabIcon = {
    gameObject = objIcon,
    sprite = objIcon:GetComponent(UISprite)
  }
end

function HomeBuildingTypeCell:AddEvts()
  self:AddCellClickEvent()
end

function HomeBuildingTypeCell:SetData(data)
  self.dataType = data
  self.staticData = Table_FurnitureType[self.dataType]
  self.gameObject:SetActive(self.staticData ~= nil)
  if not self.staticData then
    return
  end
  self.tipText = self.staticData.NameZh
  local setSuc = IconManager:SetHomeBuildingIcon(self.staticData.IconName, self.tabIcon.sprite)
  setSuc = setSuc or IconManager:SetItemIcon("item_45001", self.tabIcon.sprite)
  self.tabIcon.gameObject:SetActive(setSuc)
  if setSuc then
    self.tabIcon.sprite:MakePixelPerfect()
  end
  self:Select(false)
end

function HomeBuildingTypeCell:Select(isSelect)
  if self.isSelect == isSelect then
    return
  end
  self.isSelect = isSelect
  self.tabIcon.sprite.color = isSelect and m_colorSelect or LuaGeometry.GetTempColor()
end
