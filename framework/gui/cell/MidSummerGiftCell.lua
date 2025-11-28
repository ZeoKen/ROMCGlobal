MidSummerGiftCell = class("MidSummerGiftCell", CoreView)
local actIns

function MidSummerGiftCell:ctor(obj)
  if not actIns then
    actIns = MidSummerActProxy.Instance
  end
  MidSummerGiftCell.super.ctor(self, obj)
  self.iconSp = self:FindComponent("Icon", UISprite)
  self.numLab = self:FindComponent("NumLabel", UILabel)
  self.favorite = self:FindGO("Favorite")
  local longPress = self.gameObject:GetComponent(UILongPress)
  
  function longPress.pressEvent(obj, state)
    self:PassEvent(MouseEvent.LongPress, {
      state,
      self.data
    })
  end
  
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self.data)
  end)
end

function MidSummerGiftCell:SetData(data)
  self.data = data
  local flag = data ~= nil
  self.gameObject:SetActive(flag)
  if not flag then
    return
  end
  if not IconManager:SetItemIcon(Table_Item[data].Icon, self.iconSp) then
    IconManager:SetItemIcon("item_45001", self.iconSp)
  end
  local num = BagProxy.Instance:GetItemNumByStaticID(data, GameConfig.PackageMaterialCheck.favorite_pack)
  self.numLab.text = string.format(0 < num and "%s" or "[c][ff6021]%s[-][/c]", num)
  local dData = actIns:GetDesireData()
  self.favorite:SetActive(dData.isFavoriteShow and dData.favorite == data or false)
end
