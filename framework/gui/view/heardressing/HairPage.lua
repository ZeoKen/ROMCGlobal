autoImport("DressingPage")
autoImport("WrapCellHelper")
autoImport("CutHairCombineItemCell")
autoImport("HairDyeCell")
HairPage = class("HairPage", DressingPage)

function HairPage:InitPageView()
  self.shopType = ShopDressingProxy.Instance.shopType
  self.shopID = ShopDressingProxy.Instance.shopID
  ShopDressingProxy.Instance:ResetData(self.shopType, self.shopID)
  if self.itemWrapHelper == nil then
    local cutWrap = self:FindGO("HairCutWrap")
    local wrapConfig = {
      wrapObj = cutWrap,
      pfbNum = 5,
      cellName = "CutHairCombineItemCell",
      control = CutHairCombineItemCell
    }
    self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
    self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.OnClickCutItem, self)
  end
  if self.itemWrapHelper2 == nil then
    self.hairDyeWrap = self:FindGO("HairDyeWrap")
    local wrapConfig = {
      wrapObj = self.hairDyeWrap,
      pfbNum = 8,
      cellName = "HairDyeNewCell",
      control = HairDyeCell,
      dir = 2
    }
    self.itemWrapHelper2 = WrapCellHelper.new(wrapConfig)
    self.itemWrapHelper2:AddEventListener(MouseEvent.MouseClick, self.OnClickDyeItem, self)
  end
  local staticData = ShopDressingProxy.Instance.staticData
  local hairData = staticData and staticData[ShopDressingProxy.DressingType.HAIR]
  local unitedData
  if hairData then
    unitedData = ShopDressingProxy.Instance:ReUniteCellData(hairData, 5)
    self.itemWrapHelper:UpdateInfo(unitedData, true, true)
  end
  local hairColorData = staticData and staticData[ShopDressingProxy.DressingType.HAIRCOLOR]
  if hairColorData then
    self.itemWrapHelper2:UpdateInfo(hairColorData, true, true)
  end
  self:SelectOriginalHair()
  self:SelectOriginalHairColor()
end

function HairPage:SelectOriginalHair()
  local originalHair = ShopDressingProxy.Instance.originalHair
  local cells = self.itemWrapHelper:GetCellCtls()
  for i = 1, #cells do
    local childrenObjs = cells[i].childrenObjs
    for j = 1, #childrenObjs do
      if childrenObjs[j].hairstyleID == originalHair then
        self:OnClickCutItem(childrenObjs[j])
        return
      end
    end
  end
end

function HairPage:SelectOriginalHairColor()
  local originalColor = ShopDressingProxy.Instance.originalHairColor
  local cells = self.itemWrapHelper2:GetCellCtls()
  for i = 1, #cells do
    if cells[i].colorId == originalColor then
      self:OnClickDyeItem(cells[i])
      break
    end
  end
end

local args = {}

function HairPage:OnClickCutItem(cellctl)
  if cellctl and cellctl.data and (nil == self.chooseId or cellctl.data.id ~= self.chooseId) then
    self.chooseId = cellctl.data.id
    local data = cellctl.data
    if nil ~= data then
      local hairStyleItemId = data.goodsID
      local hairStyleId = ShopDressingProxy.Instance:GetHairStyleIDByItemID(hairStyleItemId)
      local precost = data.PreCost
      args[1] = hairStyleId
      args[2] = hairStyleItemId
      args[3] = data.id
      ShopDressingProxy.Instance:SetHairCutQueryArgs(args)
      self:SetMenuDes(data, ShopDressingProxy.DressingType.HAIR)
      self.container:RefreshModel()
      self.container:RefreshSelectedROB(1, precost, hairStyleId, nil)
      self:SetChoose(data.id)
      self.hairDyeWrap:SetActive(nil == GameConfig.HairColor[hairStyleId])
    else
      self.container:DisableState()
    end
  end
end

function HairPage:OnClickDyeItem(cellctl)
  if cellctl and cellctl.data and cellctl ~= self.chooseCtl then
    self.chooseCtl = cellctl
    local data = self.chooseCtl.data
    if data then
      local precost = data.PreCost
      args[1] = data.hairColorID
      args[2] = data.id
      ShopDressingProxy.Instance:SetHairColorQueryArgs(args)
      self.container:RefreshModel()
      self.container:RefreshSelectedROB(1, precost, nil, nil)
      self:SetDyeChoose(data.id)
    else
      self.container:DisableState()
    end
  end
end
