autoImport("EnchantAttrInfoCell")
EnchantInfoPopup = class("EnchantInfoPopup", BaseView)
EnchantInfoPopup.ViewType = UIViewType.Lv4PopUpLayer
local bagIns, blackSmith, enchantUtil, tableClear, enchantMatPackageCheck, arrayPushBack
local enchantType = SceneItem_pb.EENCHANTTYPE_SENIOR

function EnchantInfoPopup:Init()
  self:InitView()
  self:InitData()
  self:InitShow()
end

function EnchantInfoPopup:InitView()
  self.titleLabel = self:FindGO("Title"):GetComponent(UILabel)
  self.scrollView = self:FindGO("ScrollView"):GetComponent(UIScrollView)
  self.panel = self.scrollView.panel
  self.table = self:FindGO("EnchantInfoTable"):GetComponent(UITable)
  self.enchantInfoCtl = ListCtrl.new(self.table, EnchantAttrInfoNewCell, "EnchantAttrInfoNewCell")
  self.maskBg = self:FindGO("MaskBg")
  self:AddClickEvent(self.maskBg, function()
    self:CloseSelf()
  end)
  bagIns = BagProxy.Instance
  blackSmith = BlackSmithProxy.Instance
  enchantUtil = EnchantEquipUtil.Instance
  tableClear = TableUtility.TableClear
  enchantMatPackageCheck = GameConfig.PackageMaterialCheck.enchant
  arrayPushBack = TableUtility.ArrayPushBack
end

function EnchantInfoPopup:InitData()
  local viewdata = self.viewdata and self.viewdata.viewdata
  self.curEquipType = viewdata and viewdata.equipType or nil
  self.attrMenuType = viewdata and viewdata.attriMenuType or 1
  self.advCostID = viewdata and viewdata.advCostID
  local config = Game.EnchantMustBuff[self.advCostID]
  if not config then
    self.advCostID = nil
  end
  self.enchantInfoDatas = {}
end

function EnchantInfoPopup:InitShow()
  if self.advCostID then
    self.enchantInfoCtl:ResetDatas(self:GetEnchantInfoDatasByAdvanceCostID())
  else
    self.enchantInfoCtl:ResetDatas(self:GetEnchantInfoDatas())
  end
  local cells = self.enchantInfoCtl:GetCells()
  local targetCell
  for i = 1, #cells do
    if cells[i].data.attriMenuType == self.attrMenuType then
      targetCell = cells[i]
      break
    end
  end
  if targetCell then
    local bound = NGUIMath.CalculateRelativeWidgetBounds(self.panel.cachedTransform, targetCell.gameObject.transform)
    local offset = self.panel:CalculateConstrainOffset(bound.min, bound.max)
    local posX = targetCell.gameObject.transform.localPosition[1]
    offset = Vector3(0, offset.y, 0)
    self.scrollView:MoveRelative(offset)
  end
end

function EnchantInfoPopup:GetEnchantInfoDatas()
  tableClear(self.enchantInfoDatas)
  local type = self.curEquipType
  local enchantDatas = enchantUtil:GetEnchantDatasByEnchantType(enchantType)
  local attriMenuType, pos, infoData, cbdata
  for attriType, data in pairs(enchantDatas) do
    attriMenuType, pos = enchantUtil:GetMenuType(attriType)
    infoData = self.enchantInfoDatas[attriMenuType]
    if not infoData then
      infoData = {}
      infoData.attriMenuType = attriMenuType
      infoData.attris = {}
      self.enchantInfoDatas[attriMenuType] = infoData
    end
    cbdata = {}
    cbdata.attriMenuType = attriMenuType
    cbdata.equipType = type
    cbdata.enchantData, cbdata.canGet = data:Get(type)
    if not type then
      cbdata.canGet = true
    end
    cbdata.pos = pos
    arrayPushBack(infoData.attris, cbdata)
  end
  local combineEffects = enchantUtil:GetCombineEffects(enchantType)
  if next(combineEffects) then
    infoData = {}
    infoData.attriMenuType = EnchantMenuType.CombineAttri
    infoData.attris = {}
    arrayPushBack(self.enchantInfoDatas, infoData)
    local nameKeysMap, canGet = {}
    for _, data in pairs(combineEffects) do
      if nameKeysMap[data.Name] == nil then
        cbdata = {}
        cbdata.attriMenuType = EnchantMenuType.CombineAttri
        cbdata.equipType = type
        cbdata.enchantData = data
        cbdata.pos = data.id
        if type ~= nil then
          cbdata.canGet = enchantUtil:CanGetCombineEffect(data, type)
        else
          cbdata.canGet = true
        end
        arrayPushBack(infoData.attris, cbdata)
        nameKeysMap[data.Name] = #infoData.attris
      else
        canGet = enchantUtil:CanGetCombineEffect(data, type)
        if canGet then
          cbdata = infoData.attris[nameKeysMap[data.Name]]
          cbdata.enchantData = data
          cbdata.pos = data.id
          cbdata.canGet = true
        end
      end
    end
  end
  return self.enchantInfoDatas
end

function EnchantInfoPopup:GetEnchantInfoDatasByAdvanceCostID()
  local costID = self.advCostID
  local config = Game.EnchantMustBuff[costID]
  if not config then
    redlog("高级消耗数据nil")
    return
  end
  local positions = config.Position
  tableClear(self.enchantInfoDatas)
  local enchantDatas = enchantUtil:GetEnchantDatasByEnchantType(enchantType)
  local attriMenuType, pos, infoData, cbdata
  for attriType, data in pairs(enchantDatas) do
    attriMenuType, pos = enchantUtil:GetMenuType(attriType)
    infoData = self.enchantInfoDatas[attriMenuType]
    if not infoData then
      infoData = {}
      infoData.attriMenuType = attriMenuType
      infoData.attris = {}
      self.enchantInfoDatas[attriMenuType] = infoData
    end
    cbdata = {}
    cbdata.attriMenuType = attriMenuType
    cbdata.equipType = type
    cbdata.canGet = false
    for i = 1, #positions do
      local equipType = positions[i]
      local enchantData, canGet = data:GetByEquipType(equipType)
      if not cbdata.enchantData then
        cbdata.enchantData = enchantData
      end
      if not cbdata.canGet and canGet == true then
        cbdata.canGet = true
        break
      end
    end
    cbdata.pos = pos
    arrayPushBack(infoData.attris, cbdata)
  end
  local possibleBuffs = {}
  local effects = config.Effect
  for i = 1, #effects do
    table.insert(possibleBuffs, effects[i].BuffID)
  end
  local combineEffects = enchantUtil:GetCombineEffects(enchantType)
  if next(combineEffects) then
    infoData = {}
    infoData.attriMenuType = EnchantMenuType.CombineAttri
    infoData.attris = {}
    arrayPushBack(self.enchantInfoDatas, infoData)
    local nameKeysMap, canGet = {}
    for _, data in pairs(combineEffects) do
      if nameKeysMap[data.Name] == nil then
        cbdata = {}
        cbdata.attriMenuType = EnchantMenuType.CombineAttri
        cbdata.equipType = type
        cbdata.enchantData = data
        cbdata.pos = data.id
        cbdata.canGet = self:CheckCombineEffectValid(data, possibleBuffs)
        arrayPushBack(infoData.attris, cbdata)
        nameKeysMap[data.Name] = #infoData.attris
      else
        canGet = enchantUtil:CanGetCombineEffect(data, type)
        if canGet then
          cbdata = infoData.attris[nameKeysMap[data.Name]]
          cbdata.enchantData = data
          cbdata.pos = data.id
          cbdata.canGet = self:CheckCombineEffectValid(data, possibleBuffs)
        end
      end
    end
  end
  return self.enchantInfoDatas
end

function EnchantInfoPopup:CheckCombineEffectValid(enchantData, buffIDs)
  local addAttr = enchantData and enchantData.AddAttr
  if addAttr and 0 < #addAttr then
    for i = 1, #addAttr do
      if 0 < TableUtility.ArrayFindIndex(buffIDs, addAttr[i][1]) then
        return true
      end
    end
  end
end
