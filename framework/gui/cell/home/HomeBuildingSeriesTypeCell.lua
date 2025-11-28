HomeBuildingSeriesTypeCell = class("HomeBuildingSeriesTypeCell", BaseCell)

function HomeBuildingSeriesTypeCell:Init()
  HomeBuildingSeriesTypeCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
end

function HomeBuildingSeriesTypeCell:FindObjs()
  local objIcon = self:FindGO("Icon")
  self.tabIcon = {
    gameObject = objIcon,
    sprite = objIcon:GetComponent(UISprite)
  }
  self:FindGO("labName"):SetActive(false)
end

function HomeBuildingSeriesTypeCell:AddEvts()
  self:AddCellClickEvent()
end

function HomeBuildingSeriesTypeCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(data ~= nil)
  if not data then
    return
  end
  self.buildType = data.buildType
  self.seriesType = data.seriesType
  self.tipText = data.name
  local setSuc = IconManager:SetHomeBuildingIcon(self.data.icon, self.tabIcon.sprite)
  setSuc = setSuc or IconManager:SetItemIcon("item_45001", self.tabIcon.sprite)
  self.tabIcon.gameObject:SetActive(setSuc)
  if setSuc then
    self.tabIcon.sprite:MakePixelPerfect()
  end
end

function HomeBuildingSeriesTypeCell:Select(isSelect)
  if not self.data then
    return
  end
  self.isSelect = isSelect
  IconManager:SetHomeBuildingIcon(isSelect and self.data.selectIcon or self.data.icon, self.tabIcon.sprite)
end
