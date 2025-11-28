local BaseCell = autoImport("BaseCell")
EquipUpgradeMaterialTipCell = class("EquipUpgradeMaterialTipCell", BaseCell)

function EquipUpgradeMaterialTipCell:Init()
  self.icon = self:FindComponent("Icon", UISprite)
  self.name = self:FindComponent("Name", UILabel)
  self.count = self:FindComponent("Count", UILabel)
end

function EquipUpgradeMaterialTipCell:SetData(data)
  if not data or not data.id then
    self.gameObject:SetActive(false)
    return
  end
  self.gameObject:SetActive(true)
  local itemid, neednum = data.id, data.num
  local itemData = Table_Item[itemid]
  IconManager:SetItemIcon(itemData.Icon, self.icon)
  self.icon:MakePixelPerfect()
  self.name.text = itemData.NameZh
  if not data.hideSearch then
    local searchnum = 0
    if itemid ~= 100 then
      if ItemData.CheckIsEquip(itemid) then
        BlackSmithProxy.Instance:GetMaterialEquips_ByEquipId(itemid, nil, true, nil, data.bagTypes or EquipInfo:GetEquipCheckTypes(), function(param, itemData)
          if itemData.id == self.upgrade_equipid then
            searchnum = searchnum + (itemData.num - 1)
          else
            searchnum = searchnum + itemData.num
          end
        end)
      else
        local searchItems = BagProxy.Instance:GetMaterialItems_ByItemId(itemid, data.bagTypes or EquipInfo.GetEquipCheckTypes())
        for j = 1, #searchItems do
          if BagProxy.Instance:CheckIfFavoriteCanBeMaterial(searchItems[j]) ~= false then
            searchnum = searchnum + searchItems[j].num
          end
        end
      end
    else
      searchnum = Game.Myself.data.userdata:Get(UDEnum.SILVER)
    end
    self.count.text = string.format(ZhString.GuildBuilding_Submit_MatNum, searchnum, neednum)
    local col = neednum > searchnum and "FF6021FF" or "6FA0F9FF"
    local success, value = ColorUtil.TryParseHexString(col)
    if success then
      self.count.color = value
    end
    self.lackid = neednum > searchnum and itemid or nil
    self.lacknum = neednum > searchnum and neednum - searchnum or nil
  else
    self.count.text = neednum
  end
end

function EquipUpgradeMaterialTipCell:GetLackMaterials()
  return self.lackid, self.lacknum
end

function EquipUpgradeMaterialTipCell:SetUpgradeEquipId(upgrade_equipid)
  self.upgrade_equipid = upgrade_equipid
end
