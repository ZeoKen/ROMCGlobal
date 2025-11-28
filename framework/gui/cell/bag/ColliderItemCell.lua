autoImport("ItemCell")
ColliderItemCell = class("ColliderItemCell", ItemCell)
local tempVector3 = LuaVector3.One()

function ColliderItemCell:Init()
  if self.itemGO == nil then
    self.itemGO = self:LoadPreferb_ByFullPath(ResourcePathHelper.UICell("ItemCell"), self.gameObject)
  end
  self:AddCellClickEvent()
  ColliderItemCell.super.Init(self)
end

function ColliderItemCell:SetMinDepth(minDepth)
  local sps = Game.GameObjectUtil:GetAllComponentsInChildren(self.gameObject, UIWidget, true)
  for i = 1, #sps do
    sps[i].depth = minDepth + sps[i].depth
  end
end

function ColliderItemCell:AddCdCtl()
  self.cdCtrl = FunctionCDCommand.Me():GetCDProxy(BagCDRefresher)
end

function ColliderItemCell:SetData(data)
  ColliderItemCell.super.SetData(self, data)
end

function ColliderItemCell:ReScale(scale)
  LuaVector3.Better_Set(tempVector3, scale, scale, scale)
  self.itemGO.transform.localScale = tempVector3
end

function ColliderItemCell:ReScaleSelf(scale)
  LuaVector3.Better_Set(tempVector3, scale, scale, scale)
  self.gameObject.transform.localScale = tempVector3
end
