ItemTabCell = class("ItemTabCell", BaseCell)
ItemTabType_MainBag_Icon = {
  [0] = {
    [0] = "bag_icon_all"
  },
  [ItemNormalList.TabType.ItemPage] = {
    [-1] = "bag_icon_like",
    [0] = "bag_icon_all",
    [1] = "bag_icon_1",
    [2] = "bag_icon_2",
    [3] = "bag_icon_3",
    [4] = "bag_icon_5",
    [5] = "bag_icon_memory"
  },
  [ItemNormalList.TabType.FashionPage] = {
    [0] = "bag_icon_all",
    [1045] = "bag_equip_2",
    [1025] = "bag_equip_7",
    [1040] = "bag_equip_8",
    [1041] = "bag_equip_9",
    [1043] = "bag_equip_10",
    [1042] = "bag_equip_11",
    [1044] = "bag_equip_12",
    [5] = "bag_equip_13",
    [1026] = "bag_equip_1",
    [1055] = "bag_equip_14"
  },
  [ItemNormalList.TabType.FoodPage] = {
    [0] = "bag_icon_all",
    [1] = "bag_icon_6",
    [2] = "bag_icon_4"
  },
  [ItemNormalList.TabType.Mercenary] = {
    [1] = "bag_equip_8",
    [2] = "bag_equip_10",
    [3] = "bag_equip_11"
  },
  [ItemNormalList.TabType.Wallet] = {
    [1] = "tab_icon_37",
    [2] = "tab_icon_20",
    [3] = "bag_icon_15"
  },
  [ItemNormalList.TabType.WalletSale] = {
    [1] = "tab_icon_20",
    [2] = "bag_icon_15"
  }
}
local AdvTabType_Fashion_Site = {
  [1045] = 2,
  [1025] = 7,
  [1040] = 8,
  [1041] = 9,
  [1043] = 10,
  [1042] = 11,
  [1044] = 12,
  [5] = 13,
  [1026] = 1,
  [1055] = 14
}
local color_white = LuaColor.White()
local color_hide = LuaColor.New(1, 1, 1, 0)
local color_gray = LuaColor.Gray()
local _RedTipMap = {
  [ItemNormalList.TabType.Wallet] = {
    [2] = SceneTip_pb.EREDSYS_WALLET,
    [3] = SceneTip_pb.EREDSYS_WALLET_TYPE_PAGE
  },
  [ItemNormalList.TabType.WalletSale] = {
    [1] = SceneTip_pb.EREDSYS_WALLET,
    [2] = SceneTip_pb.EREDSYS_WALLET_TYPE_PAGE
  }
}

function ItemTabCell:Init()
  ItemTabCell.super.Init(self)
  self.sp1 = self:FindComponent("sprite1", UISprite)
  self.select = self:FindComponent("Select", UISprite)
  self.sp2 = self:FindComponent("sprite2", UISprite)
  self.tog = self.gameObject:GetComponent(UIToggle)
  self:SetEvent(self.gameObject, function()
    self:SetTog(true)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function ItemTabCell:SetTog(v)
  if not self.tog then
    return
  end
  self.tog:Set(v)
  self.select.color = v and color_white or color_hide
end

function ItemTabCell:SetGroup(g)
  g = g or 0
  self.tog.group = g
end

function ItemTabCell:SetData(data)
  if data == nil then
    self.gameObject:SetActive(false)
    return
  end
  self.gameObject:SetActive(true)
  self.data = data
  self:UpdateTabIcon()
  self:_RegisterRedTip()
end

function ItemTabCell:_RegisterRedTip()
  local data = self.data
  local t, i = data.tabType, data.index
  if t and i then
    local reason = _RedTipMap[t] and _RedTipMap[t][i] or nil
    if reason then
      RedTipProxy.Instance:RegisterUI(reason, self.sp1, nil, {-5, 0})
    end
  end
end

function ItemTabCell:UpdateTabIcon()
  local data = self.data
  local spName
  local tabType = data.tabType
  local iconMap = tabType and ItemTabType_MainBag_Icon[tabType]
  if tabType == ItemNormalList.TabType.FashionPage then
    self.sp1.color = color_white
    local fashionEquip
    local tabConfig = data.tabConfig
    if tabConfig then
      spName = iconMap[tabConfig[2]]
      fashionEquip = BagProxy.Instance.fashionEquipBag:GetEquipBySite(AdvTabType_Fashion_Site[tabConfig[2]])
    end
    if fashionEquip then
      if fashionEquip:IsMountPet() then
        IconManager:SetPetMountIcon(fashionEquip, self.sp1)
      else
        IconManager:SetItemIcon(fashionEquip.staticData.Icon, self.sp1)
        self.sp1:MakePixelPerfect()
      end
      self.sp1.width = self.sp1.width * 0.6
      self.sp1.height = self.sp1.height * 0.6
      self.sp2.enabled = false
    else
      self.sp2.enabled = true
      iconMap = iconMap or ItemTabType_MainBag_Icon[0]
      if spName then
        local ui1 = RO.AtlasMap.GetAtlas("NewUI1")
        local getSData = ui1:GetSprite(spName)
        if getSData then
          self.sp1.atlas = ui1
          self.sp1.spriteName = spName
          self.sp2.atlas = ui1
          self.sp2.spriteName = spName
          self.sp1:MakePixelPerfect()
          self.sp2:MakePixelPerfect()
        else
          IconManager:SetUIIcon(spName, self.sp1)
          IconManager:SetUIIcon(spName, self.sp2)
          self.sp1:MakePixelPerfect()
          self.sp1.width = self.sp1.width * 0.6
          self.sp1.height = self.sp1.height * 0.6
          self.sp2:MakePixelPerfect()
          self.sp2.width = self.sp2.width * 0.6
          self.sp2.height = self.sp2.height * 0.6
        end
      end
    end
  else
    self.sp1.color = tabType ~= ItemNormalList.TabType.Mercenary and color_gray or color_white
    self.sp2.enabled = true
    iconMap = iconMap or ItemTabType_MainBag_Icon[0]
    spName = iconMap and iconMap[data.index]
    if spName then
      local ui1 = RO.AtlasMap.GetAtlas("NewUI1")
      local getSData = ui1:GetSprite(spName)
      if getSData then
        self.sp1.atlas = ui1
        self.sp1.spriteName = spName
        self.sp2.atlas = ui1
        self.sp2.spriteName = spName
        self.sp1:MakePixelPerfect()
        self.sp2:MakePixelPerfect()
      else
        IconManager:SetUIIcon(spName, self.sp1)
        IconManager:SetUIIcon(spName, self.sp2)
        self.sp1:MakePixelPerfect()
        self.sp1.width = self.sp1.width * 0.6
        self.sp1.height = self.sp1.height * 0.6
        self.sp2:MakePixelPerfect()
        self.sp2.width = self.sp2.width * 0.6
        self.sp2.height = self.sp2.height * 0.6
      end
    end
  end
end
