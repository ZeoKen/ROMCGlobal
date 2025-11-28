autoImport("DressingPage")
autoImport("WrapCellHelper")
autoImport("EyeLensesCombineItemCell")
autoImport("EyeDyeCell")
EyePage = class("EyePage", DressingPage)

function EyePage:InitPageView()
  self.shopType = ShopDressingProxy.Instance.shopType2
  self.shopID = ShopDressingProxy.Instance.shopID2
  ShopDressingProxy.Instance:ResetData(self.shopType, self.shopID)
  if self.itemWrapHelper == nil then
    local wrapConfig = {
      wrapObj = self.itemRoot,
      pfbNum = 5,
      cellName = "EyeLensesCombineItemCell",
      control = EyeLensesCombineItemCell,
      dir = 1
    }
    self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
    self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.OnClickEyeItem, self)
  end
  if self.itemWrapHelper2 == nil then
    local eyeDyeWrap = self:FindGO("EyeDyeWrap")
    local wrapConfig = {
      wrapObj = eyeDyeWrap,
      pfbNum = 8,
      cellName = "EyeDyeNewCell",
      control = EyeDyeCell,
      dir = 2
    }
    self.itemWrapHelper2 = WrapCellHelper.new(wrapConfig)
    self.itemWrapHelper2:AddEventListener(MouseEvent.MouseClick, self.OnClickEyeColorCell, self)
  end
  local staticData = ShopDressingProxy.Instance.staticData
  local eyeData = staticData and staticData[ShopDressingProxy.DressingType.EYE]
  if not eyeData then
    return
  end
  self.dataMap = {}
  self.styleData = {}
  for i = 1, #eyeData do
    local eyeID = eyeData[i].goodsID
    local styleID = Table_Eye[eyeID].StyleID
    if styleID == eyeID then
      self.styleData[#self.styleData + 1] = eyeData[i]
    end
    local info = self.dataMap[styleID]
    if nil == info then
      info = {}
      self.dataMap[styleID] = info
    end
    info[#info + 1] = eyeData[i]
  end
  local newData = ShopDressingProxy.Instance:ReUniteCellData(self.styleData, 5)
  if newData then
    self.itemWrapHelper:UpdateInfo(newData, true, true)
  end
  self:SelectOriginalEye()
end

function EyePage:SelectOriginalEye()
  local originalEye = ShopDressingProxy.Instance.originalEye
  local originalEyeStyleID = Table_Eye[originalEye].StyleID
  local cells = self.itemWrapHelper:GetCellCtls()
  for i = 1, #cells do
    local childrenObjs = cells[i].childrenObjs
    for j = 1, #childrenObjs do
      if childrenObjs[j].styleID == originalEyeStyleID then
        self:OnClickEyeItem(childrenObjs[j], originalEye)
        return
      end
    end
  end
end

function EyePage:OnClickEyeColorCell(cellctl, originalEye)
  self:OnClickEyeItem(cellctl, originalEye, true)
end

local args = {}

function EyePage:OnClickEyeItem(cellctl, originalEye, clickColor)
  if cellctl and cellctl.data and (nil == self.chooseId or cellctl.data.id ~= self.chooseId) then
    self.chooseId = cellctl.data.id
    local data = cellctl.data
    if data then
      local eyeID = data.goodsID
      local styleID = Table_Eye[eyeID].StyleID
      args[1] = eyeID
      args[2] = data.id
      ShopDressingProxy.Instance:SetEyerQueryArgs(args)
      self:SetMenuDes(data, ShopDressingProxy.DressingType.EYE)
      self.container:RefreshSelectedROB(2, nil, nil, eyeID)
      self.container:RefreshModel()
      local colorData = self.dataMap[styleID]
      local clickParent = styleID == eyeID
      if 1 < #colorData then
        if clickParent and not clickColor then
          self.itemWrapHelper2:UpdateInfo(colorData, true)
        end
      else
        self.itemWrapHelper2:UpdateInfo(_EmptyTable)
      end
      self:SetChoose(eyeID)
      self:SetDyeChoose(originalEye or eyeID)
    else
      self.container:DisableState()
    end
  end
end
