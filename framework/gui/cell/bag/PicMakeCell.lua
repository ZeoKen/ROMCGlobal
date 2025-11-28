local BaseCell = autoImport("BaseCell")
PicMakeCell = class("PicMakeCell", BaseCell)
autoImport("MaterialNCell")
PicMakeCell.ClickToItem = "PicMakeCell_ClickToItem"
PicMakeCell.ClickMaterial = "PicMakeCell_ClickMaterial"
PicMakeCell.GoToMake = "PicMakeCell_GoToMake"
PicMakeCell.TraceMaterial = "PicMakeCell_TraceMaterial"
local _tempVec3 = LuaVector3()
PicMakeCell.GuidePicIds = {14176, 14175}
local DefaultQuanGridCellWidth = 117
local QuanGridCellWidth = {
  [5] = 88,
  [6] = 75
}
local DefaultMaterialGridCellWidth = 115
local MaterialGridCellWidth = {
  [5] = 85,
  [6] = 75
}
local DefaultLineWidth = 109
local LineWidth = {
  [5] = 78,
  [6] = 59
}
local DefaultLineGridCellWidth = 117
local LineGridCellWidth = {
  [5] = 88,
  [6] = 75
}

function PicMakeCell:Init()
  if not BagType_SymbolMap then
    BagType_SymbolMap = {
      [BagProxy.BagType.PersonalStorage] = "com_icon_Corner_warehouse",
      [BagProxy.BagType.Barrow] = "com_icon_Corner_wheelbarrow",
      [BagProxy.BagType.Temp] = "com_icon_Corner_temporarybag"
    }
  end
  PicMakeCell.super.Init()
  self.combine_lacMats = {}
  self.cache_sortingOrder = {}
  self:InitCell()
end

function PicMakeCell:InitCell()
  self.roblab = self:FindComponent("ROGold", UILabel)
  local l_zenyIcon = self:FindComponent("Symbol", UISprite, self.roblab.gameObject)
  IconManager:SetItemIcon(Table_Item[100].Icon, l_zenyIcon)
  self.cost = self:FindGO("Cost")
  self.costGold = self:FindComponent("CostGold", UILabel)
  self.destItemObj = self:FindGO("ItemCell")
  self.fashionName = self:FindComponent("FashionName", UILabel)
  self.makeTip = self:FindComponent("MakeTip", UILabel)
  self.materialGrid = self:FindComponent("MaterialGrid", UIGrid)
  self.materialCtl = UIGridListCtrl.new(self.materialGrid, MaterialNCell, "MaterialNCell")
  self.materialCtl:AddEventListener(MouseEvent.MouseClick, self.ClickMaterial, self)
  self.modelTexture = self:FindComponent("ModelContainer", UITexture)
  local effectContainer = self:FindGO("EffectContainer")
  self:LoadPreferb_ByFullPath(ResourcePathHelper.Effect("UI/14itemShine"), effectContainer)
  local toItemGO = self:FindGO("ToItem")
  self:AddClickEvent(toItemGO, function(go)
    self:PassEvent(PicMakeCell.ClickToItem, {
      gameObject = go,
      data = self.toItem
    })
  end)
  self.traceBtn = self:FindGO("TrackButton")
  if self.traceBtn then
    self.traceBtn:SetActive(false)
  end
  self.quickBuyButton = self:FindGO("QuickBuyButton")
  LuaVector3.Better_Set(_tempVec3, 0, -250, 0)
  self.quickBuyButton.transform.localPosition = _tempVec3
  self:AddClickEvent(self.quickBuyButton, function(go)
    if #self.combine_lacMats > 0 then
      PicMakeCell.useDeduction = self.checkBtn.value
      if QuickBuyProxy.Instance:TryOpenView(self.combine_lacMats) then
        return
      end
    end
  end)
  self.goMakeButton = self:FindGO("GoMakeButton")
  self.goMakeButton.transform.localPosition = _tempVec3
  self:AddClickEvent(self.goMakeButton, function(go)
    self:PassEvent(PicMakeCell.GoToMake, self)
  end)
  self.makeBtn = self:FindGO("MakeButton")
  self:AddClickEvent(self.makeBtn, function(go)
    if #self.combine_lacMats > 0 then
      PicMakeCell.useDeduction = self.checkBtn.value
      if QuickBuyProxy.Instance:TryOpenView(self.combine_lacMats) then
        return
      end
    end
    if self.canCompose then
      self:PassEvent(MouseEvent.MouseClick, self)
    else
      MsgManager.ShowMsgByIDTable(8)
    end
  end)
  local helpBtn = self:FindGO("helpBtn")
  local penelID = PanelConfig.PicTipPopUp.id
  self:RegistShowGeneralHelpByHelpID(penelID, helpBtn)
  self.checkBtn = self:FindComponent("CheckBtn", UIToggle)
  self:AddClickEvent(self.checkBtn.gameObject, function()
    self:UpdateCostMaterial()
    self:UpdateButtons()
  end)
  self.checkBtn.value = PicMakeCell.useDeduction or false
  PicMakeCell.useDeduction = nil
end

local DEFAULT_MATERIAL_SEARCH_BAGTYPES, PRODUCE_MATERIAL_SEARCH_BAGTYPES
local pacakgeCheck = GameConfig.PackageMaterialCheck
DEFAULT_MATERIAL_SEARCH_BAGTYPES = pacakgeCheck and pacakgeCheck.default or {1, 9}
PRODUCE_MATERIAL_SEARCH_BAGTYPES = pacakgeCheck and pacakgeCheck.produce or DEFAULT_MATERIAL_SEARCH_BAGTYPES

function PicMakeCell:GetItemNum(itemid)
  local items = BagProxy.Instance:GetMaterialItems_ByItemId(itemid, PRODUCE_MATERIAL_SEARCH_BAGTYPES)
  local searchNum = 0
  for i = 1, #items do
    if self:CheckCanMake(items[i]) then
      searchNum = searchNum + items[i].num
    end
  end
  return searchNum
end

function PicMakeCell:ClickMaterial(cellctl)
  self:PassEvent(PicMakeCell.ClickMaterial, cellctl)
end

function PicMakeCell:ActiveGoMakeButton(b)
  self.gotoMake_active = b
  self:UpdateButtons()
end

function PicMakeCell:Refresh()
  self:SetData(self.data)
end

function PicMakeCell:SetData(data)
  self.data = data
  if not self.data then
    return
  end
  local composeID = data.staticData.ComposeID
  if not composeID then
    return
  end
  if not Table_Compose[composeID] then
    return
  end
  local cdata = Table_Compose[composeID]
  self.toItem = ItemData.new(0, cdata.Product.id)
  local toSdata = self.toItem.staticData
  self.fashionName.text = toSdata.NameZh
  self:UpdateFashionModel(self.toItem)
  self.materialsData = {}
  local failIndexMap = {}
  if cdata.FailStayItem then
    for i = 1, #cdata.FailStayItem do
      local index = cdata.FailStayItem[i]
      if index then
        failIndexMap[index] = 1
      end
    end
  end
  for i = 1, #cdata.BeCostItem do
    local v = cdata.BeCostItem[i]
    if v and not failIndexMap[i] then
      local tempData = ItemData.new("Material", v.id)
      tempData.num = self:GetItemNum(v.id)
      tempData.neednum = v.num
      if tempData.staticData.Type ~= 50 then
        table.insert(self.materialsData, tempData)
      end
    end
  end
  self:UpdateCostMaterial()
  local rob = cdata.ROB
  if 0 < rob then
    self.roblab.gameObject:SetActive(true)
    if cdata.ROB > MyselfProxy.Instance:GetROB() then
      self.roblab.text = CustomStrColor.BanRed .. tostring(rob) .. "[-]"
    else
      self.roblab.text = tostring(rob)
    end
  else
    self.roblab.gameObject:SetActive(false)
  end
  self:UpdateButtons()
  self:UpdateBagType()
end

function PicMakeCell:UpdateLackMaterials(srcDatas)
  srcDatas = srcDatas or self.materialsData
  self.canCompose = true
  local cdata = Table_Compose[self.data.staticData.ComposeID]
  TableUtility.ArrayClear(self.combine_lacMats)
  for i = 1, #srcDatas do
    local data = srcDatas[i]
    if data.num < data.neednum then
      local lackItem = {
        id = data.staticData.id,
        count = data.neednum - data.num
      }
      table.insert(self.combine_lacMats, lackItem)
      self.canCompose = false
    end
  end
  for i = 1, #cdata.BeCostItem do
    local v = cdata.BeCostItem[i]
    local config = Table_Item[v.id]
    if config.Type == 50 then
      local num = self:GetItemNum(v.id)
      if num < v.num then
        local lackItem = {
          id = v.id,
          count = v.num - num
        }
        table.insert(self.combine_lacMats, lackItem)
        self.canCompose = false
      end
    end
  end
end

local BagType_SymbolMap

function PicMakeCell:UpdateBagType()
  if not self.init_bagtype then
    self.init_bagtype = true
    self.bagTypes = self:FindGO("BagTypes")
    self.bagTypes_Sp = self.bagTypes and self.bagTypes:GetComponent(UISprite)
  end
  if self.bagTypes == nil then
    return
  end
  local data = self.data
  if data and data.bagtype then
    if BagType_SymbolMap and BagType_SymbolMap[data.bagtype] then
      self.bagTypes:SetActive(true)
      self.bagTypes_Sp.spriteName = BagType_SymbolMap[data.bagtype]
    else
      self.bagTypes:SetActive(false)
    end
  else
    self.bagTypes:SetActive(false)
  end
end

function PicMakeCell:UpdateButtons()
  local canMake = #self.combine_lacMats <= 0
  self.makeTip.gameObject:SetActive(not canMake)
  self.cost:SetActive(canMake)
  if canMake then
    self.quickBuyButton:SetActive(false)
    self.makeBtn:SetActive(self.gotoMake_active ~= true)
    self.goMakeButton:SetActive(self.gotoMake_active == true)
    if TableUtil.HasValue(PicMakeCell.GuidePicIds, self.data.staticData.id) then
      if self.gotoMake_active then
        self:AddOrRemoveGuideId(self.goMakeButton)
        self:AddOrRemoveGuideId(self.goMakeButton, 20)
      else
        self:AddOrRemoveGuideId(self.makeBtn)
        self:AddOrRemoveGuideId(self.makeBtn, 20)
      end
    end
  else
    self.quickBuyButton:SetActive(true)
    self.makeBtn:SetActive(false)
    self.goMakeButton:SetActive(false)
  end
end

function PicMakeCell:DrawLine(num)
  if not self.line then
    local lineObj = self:FindGO("MaterialLines")
    self.line = {}
    self.line.quan = {}
    self.line.quanCellLine = {}
    self.line.dline = {}
    self.line.dlineSp = {}
    self.line.quanGrid = self:FindComponent("QuanGrid", UIGrid, lineObj)
    self.line.dlineGrid = self:FindComponent("LineGrid", UIGrid, lineObj)
    for i = 1, 6 do
      self.line.quan[i] = self:FindGO("quan" .. i, lineObj)
      self.line.quanCellLine[i] = self:FindComponent("Cellline", UISprite, self.line.quan[i])
    end
    for i = 1, 5 do
      self.line.dline[i] = self:FindGO("dline" .. i, lineObj)
      self.line.dlineSp[i] = self.line.dline[i]:GetComponent(UISprite)
    end
    self.line.mid = self:FindComponent("MidLine", UISprite, lineObj)
  end
  self.line.mid.width = num % 2 == 1 and 15 or 22
  for i = 1, 6 do
    if self.line.quan[i] then
      self.line.quan[i]:SetActive(num >= i)
      if num < 5 then
        self.line.quanCellLine[i].width = 22
      else
        self.line.quanCellLine[i].width = 31
      end
    end
    if self.line.dline[i] then
      self.line.dline[i]:SetActive(i <= num - 1)
      if num < 5 then
        self.line.dlineSp[i].width = DefaultLineWidth
      elseif num <= 6 then
        self.line.dlineSp[i].width = LineWidth[num]
      end
    end
  end
  if num < 5 then
    self.line.quanGrid.cellWidth = DefaultQuanGridCellWidth
    self.line.dlineGrid.cellWidth = DefaultLineGridCellWidth
  elseif num <= 6 then
    self.line.quanGrid.cellWidth = QuanGridCellWidth[num]
    self.line.dlineGrid.cellWidth = LineGridCellWidth[num]
  end
  self.line.quanGrid:Reposition()
  self.line.dlineGrid:Reposition()
end

local tempQA = LuaQuaternion()
local rotVec = LuaVector3()

function PicMakeCell:UpdateFashionModel(fashionData)
  local isPetPic = fashionData.staticData.Type == 52
  local staticID = fashionData.staticData.id
  local sid = isPetPic and Table_UseItem[staticID] and Table_UseItem[staticID].UseEffect.itemid or staticID
  if self.modelId and self.modelId == sid then
    return
  end
  self:RemoveModel()
  self.modelId = sid
  local partIndex = ItemUtil.getItemRolePartIndex(sid)
  UIModelUtil.Instance:ChangeBGMeshRenderer("Bg_Fusionbg", self.modelTexture)
  UIModelUtil.Instance:SetPicMakeModelTexture(self.modelTexture, partIndex, sid, nil, function(obj, args, assetRolePart)
    self.model = assetRolePart
    if self.model then
      self.model:RegisterWeakObserver(self)
      local container = UIModelUtil.Instance:GetContainerObj(self.modelTexture)
      if container then
        container.transform.localPosition = LuaGeometry.Const_V3_zero
        container.transform.localScale = LuaGeometry.Const_V3_one
        local tr = container.gameObject:GetComponent(TweenRotation)
        if not tr then
          tr = container.gameObject:AddComponent(TweenRotation)
          tr.from = LuaGeometry.GetTempVector3(0, -180, 0)
          tr.to = LuaGeometry.GetTempVector3(0, 180, 0)
          tr.duration = 5
          tr.style = 1
        end
      end
      local itemModelName = isPetPic and Table_Equip[sid].Model or fashionData.equipInfo.equipData.Model
      if itemModelName and ModelShowConfig[itemModelName] then
        local position = ModelShowConfig[itemModelName].localPosition
        self.model:ResetLocalPositionXYZ(position[1], position[2], position[3])
        local rotation = ModelShowConfig[itemModelName].localRotation
        LuaQuaternion.Better_Set(tempQA, rotation[1], rotation[2], rotation[3], rotation[4])
        LuaQuaternion.Better_GetEulerAngles(tempQA, rotVec)
        self.model:ResetLocalEulerAngles(rotVec)
        local scale = ModelShowConfig[itemModelName].localScale
        self.model:ResetLocalScaleXYZ(scale[1], scale[2], scale[3])
      end
    end
  end)
  local cell = UIModelUtil.Instance:GetUIModelCell(self.modelTexture)
  if cell then
    cell:EnablePostProcessing(false)
  end
end

function PicMakeCell:ObserverDestroyed(obj)
  if Slua.IsNull(obj) then
    return
  end
  if obj ~= self.model then
    return
  end
  if self.model then
    self.model:UnregisterWeakObserver(self)
  end
end

function PicMakeCell:RemoveModel()
  if self.model then
    self.modelId = nil
    self.model = nil
  end
end

function PicMakeCell:OnRemove()
  self:RemoveModel()
  self.modelTexture = nil
  local list = GuideProxy.Instance:getGuideListByViewName(self.__cname)
  if list then
    FunctionGuide.Me():checkGuideStateWhenExit(list)
  end
end

function PicMakeCell:CheckCanMake(itemdata)
  if not itemdata then
    return false
  end
  if itemdata and not itemdata:IsEquip() then
    return true
  end
  local equipInfo = itemdata.equipInfo
  if equipInfo.strengthlv and equipInfo.strengthlv > 0 then
    return false
  end
  if equipInfo.strengthlv2 and 0 < equipInfo.strengthlv2 then
    return false
  end
  if equipInfo.refinelv and 0 < equipInfo.refinelv then
    return false
  end
  if itemdata.enchantInfo and 0 < #itemdata.enchantInfo:GetEnchantAttrs() then
    return false
  end
  if BagProxy.Instance:CheckIsFavorite(itemdata) then
    return false
  end
  if itemdata:HasEquipedCard() then
    return false
  end
  return true
end

function PicMakeCell:UpdateCostMaterial()
  if self.checkBtn.value then
    local mats = {}
    for i = 1, #self.materialsData do
      local matData = self.materialsData[i]
      local mat = {
        id = matData.staticData.id,
        num = matData.neednum
      }
      mats[i] = mat
    end
    local result, use, has, deductions = BlackSmithProxy.Instance:UpdateMaterialListUsingDeduction(mats, PRODUCE_MATERIAL_SEARCH_BAGTYPES)
    if not use then
      if not has then
        MsgManager.ShowMsgByID(28117)
      else
        MsgManager.ShowMsgByID(28118)
      end
      self.checkBtn.value = false
    else
      local datas = ReusableTable.CreateArray()
      for id, num in pairs(deductions) do
        if 0 < num then
          local data = ItemData.new("Deduction", id)
          data.num = BagProxy.Instance:GetItemNumByStaticID(id, PRODUCE_MATERIAL_SEARCH_BAGTYPES) or 0
          data.neednum = num
          table.insert(datas, data)
        end
      end
      for i = 1, #self.materialsData do
        local data = clone(self.materialsData[i])
        local newData = TableUtility.ArrayFindByPredicate(result, function(v, args)
          return v.id == args
        end, data.staticData.id)
        if newData and newData.deduction then
          data.num = newData.exchangenum
          data.deduction = newData.deduction
        end
        table.insert(datas, data)
      end
      self:RefreshMaterialList(datas)
      self:UpdateLackMaterials(datas)
      ReusableTable.DestroyArray(datas)
    end
  else
    self:RefreshMaterialList(self.materialsData)
    self:UpdateLackMaterials()
  end
end

function PicMakeCell:RefreshMaterialList(datas)
  local num = #datas
  if num < 5 then
    self.materialGrid.cellWidth = DefaultMaterialGridCellWidth
  elseif num <= 6 then
    self.materialGrid.cellWidth = MaterialGridCellWidth[num]
  end
  self.materialCtl:ResetDatas(datas)
  local cells = self.materialCtl:GetCells()
  for i = 1, #cells do
    if 5 <= num then
      cells[i]:SetNumLabelWidth(89)
      cells[i]:SetScale(0.8)
    else
      cells[i]:SetNumLabelWidth(107)
      cells[i]:SetScale(1)
    end
  end
  self:DrawLine(num)
end
