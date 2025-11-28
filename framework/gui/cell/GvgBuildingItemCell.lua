local _ColorRed = "[c][FF4637]"
local _PACKAGECHECK = GameConfig.PackageMaterialCheck.equipcompose
local _BagProxy
GvgBuildingItemCell = class("GvgBuildingItemCell", ItemCell)

function GvgBuildingItemCell:Init()
  _BagProxy = BagProxy.Instance
  local obj = self:LoadPreferb("cell/ItemCell", self.gameObject)
  obj.transform.localPosition = LuaVector3.Zero()
  GvgBuildingItemCell.super.Init(self)
  self:AddCellClickEvent()
end

function GvgBuildingItemCell:SetData(data)
  if data then
    GvgBuildingItemCell.super.SetData(self, data)
    local num = data.num
    if 1 < num then
      local ownNum = _BagProxy:GetItemNumByStaticID(data.staticData.id, _PACKAGECHECK)
      local colorStr = num <= ownNum and "" or _ColorRed
      self.numLab.text = colorStr .. ownNum .. "[-][/c]/" .. num
    end
  end
  self.data = data
end
