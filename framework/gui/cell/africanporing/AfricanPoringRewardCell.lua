autoImport("ItemCell")
AfricanPoringRewardCell = class("AfricanPoringRewardCell", ItemCell)

function AfricanPoringRewardCell:Init()
  self.itemContainerGO = self:FindGO("ItemContainer")
  self:AddClickEvent(self.itemContainerGO, function()
    self:PassEvent(UICellEvent.OnLeftBtnClicked, self)
  end)
  local obj = self:LoadPreferb("cell/ItemCell", self.itemContainerGO)
  LuaGameObject.SetLocalPositionGO(obj, 0, 0, 0)
  AfricanPoringRewardCell.super.Init(self)
  self:SetDefaultBgSprite(RO.AtlasMap.GetAtlas("UI_Lottery"), "mall_twistedegg_bg_09")
  self.name = self:FindComponent("Name", UILabel)
  self.desc = self:FindComponent("Desc", UILabel)
  self.ownedIconGO = self:FindGO("OwnedIcon")
end

function AfricanPoringRewardCell:SetData(data)
  self.cellData = data
  if data then
    local itemData = data:GetItemData()
    local itemConfig = data:GetItemConfig()
    self.name.text = itemConfig and itemConfig.NameZh or ""
    self.desc.text = string.format(ZhString.AfricanPoring_Probability, (data.probability or 0) * 100)
    self.ownedIconGO:SetActive(not not data:IsOwned())
    AfricanPoringRewardCell.super.SetData(self, itemData)
  end
end
