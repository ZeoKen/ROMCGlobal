PersonalArtifactProxy = class("PersonalArtifactProxy", pm.Proxy)
PersonalArtifactDecomposeEvent = {
  PutIn = "PersonalArtifactDecomposeEvent_PutIn"
}
local delimiter, tempTable, arrayPushBack = "＋", {}
PersonalArtifactProxy.EArtifactState = {
  Undefined = 0,
  InActivated = 1,
  Fragments = 2,
  Activation = 3,
  Entery = 4
}
local _BagType = BagProxy.BagType.PersonalArtifact
local _EquipBagType = BagProxy.BagType.RoleEquip
PersonalArtifactFunctionState = {
  Default = 0,
  Shop = 0,
  Compose = 1,
  Refresh = 2,
  Decompose = 3,
  Exchange = 4
}

function PersonalArtifactProxy:ctor(proxyName, data)
  self.proxyName = proxyName or "PersonalArtifactProxy"
  if PersonalArtifactProxy.Instance == nil then
    PersonalArtifactProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function PersonalArtifactProxy.QueryPackage(reinit)
  if FunctionUnLockFunc.CheckForbiddenByFuncState("personal_artifact_forbidden") then
    return
  end
  ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_ARTIFACT, reinit)
  ServiceItemProxy.Instance:CallPackageItem(SceneItem_pb.EPACKTYPE_ARTIFACT_FLAGMENT, reinit)
end

function PersonalArtifactProxy:ProcessSaveData(save_type, save_id)
  self:ResetComposePreview()
  local search_result, id = SaveInfoProxy.Instance:GetPersonalArtifactId(save_id, save_type)
  if nil == search_result then
    return
  end
  if search_result then
    self.previewPersonalArtifactId = id
  else
    self.previewPersonalArtifactItemId = id
  end
end

function PersonalArtifactProxy:GetSaveArtifactId()
  return self.previewPersonalArtifactId
end

function PersonalArtifactProxy:GetSaveMissingArtifactItemId()
  return self.previewPersonalArtifactItemId
end

function PersonalArtifactProxy:GetPreviewProgress(save_type, save_id)
  local search_result, id = SaveInfoProxy.Instance:GetPersonalArtifactId(save_id, save_type)
  if search_result ~= true then
    return 0
  end
  local _bagMgr = BagProxy.Instance
  local data = _bagMgr.roleEquip:GetItemByGuid(id)
  data = data or _bagMgr.personalArtifactBagData:GetItemByGuid(id)
  local aData = data and data.personalArtifactData
  if not aData then
    return 0
  end
  return aData:GetAttrProgress()
end

function PersonalArtifactProxy:GetCurArtifactAttrProgress()
  local roleEquip = BagProxy.Instance.roleEquip
  local equipItems = roleEquip:GetItems()
  if equipItems then
    for i = 1, #equipItems do
      if equipItems[i]:IsRarePersonalArtifact() then
        local aData = equipItems[i].personalArtifactData
        return aData:GetAttrProgress()
      end
    end
  end
  return 0
end

function PersonalArtifactProxy:ResetComposePreview()
  self.previewPersonalArtifactId = nil
  self.previewPersonalArtifactItemId = nil
end

function PersonalArtifactProxy:Init()
  if not arrayPushBack then
    arrayPushBack = TableUtility.ArrayPushBack
  end
  self:InitStaticData()
end

function PersonalArtifactProxy:InitStaticData()
end

function PersonalArtifactProxy:SetPreviewFlag(var)
  self.inPreview = var
end

function PersonalArtifactProxy:IsInPreview()
  return self.inPreview == true
end

function PersonalArtifactProxy:InitStaticAttrData()
  self.fragmentAttrBoundsMap = {}
  self.fragmentStaticAttrDataMap = {}
  self.fragmentQualityItemIdsMap = {}
  local fId, attrBoundMap, sDataMap, qItemIds, q
  local _Table_Item = Table_Item
  for _, d in pairs(Table_PersonalArtifactAttr) do
    fId = d.FlagmentId
    attrBoundMap = self.fragmentAttrBoundsMap[fId] or {}
    attrBoundMap[d.id] = d.AttrBound
    self.fragmentAttrBoundsMap[fId] = attrBoundMap
    sDataMap = self.fragmentStaticAttrDataMap[fId] or {}
    sDataMap[d.id] = d
    self.fragmentStaticAttrDataMap[fId] = sDataMap
    q = _Table_Item[fId].Quality
    qItemIds = self.fragmentQualityItemIdsMap[q] or {}
    arrayPushBack(qItemIds, fId)
    self.fragmentQualityItemIdsMap[q] = qItemIds
  end
  for _, ids in pairs(self.fragmentQualityItemIdsMap) do
    TableUtility.ArrayUnique(ids)
    table.sort(ids)
  end
end

function PersonalArtifactProxy:InitStaticFormulaItemIds()
  self.formulaId = {}
  self.typeMap = {}
  local cfg, t, element = GameConfig.PersonalArtifactFilter
  local _Table_PersonalArtifactCompose = Table_PersonalArtifactCompose
  local _Table_Item = Table_Item
  for i = 1, #cfg do
    element = {
      class = cfg[i].name
    }
    for j = 1, #cfg[i].types do
      t = cfg[i].types[j]
      self.typeMap[t] = 1
      for id, _ in pairs(_Table_PersonalArtifactCompose) do
        if _Table_Item[id] and _Table_Item[id].Type == t then
          arrayPushBack(self.formulaId, id)
        end
      end
    end
  end
end

function PersonalArtifactProxy:IsPersonalArtifactByItemType(t)
  if not self.typeMap then
    self:InitStaticFormulaItemIds()
  end
  return nil ~= self.typeMap[t]
end

function PersonalArtifactProxy:GetStaticAttrDataByIdAndValue(id, value)
  value = PersonalArtifactProxy.GetRealValue(value)
  if not self.fragmentAttrBoundsMap then
    self:InitStaticAttrData()
  end
  local attrBoundMap, sId = self.fragmentAttrBoundsMap[id]
  if attrBoundMap then
    for aId, attrBound in pairs(attrBoundMap) do
      if value >= attrBound[1] and value <= attrBound[2] then
        sId = aId
        break
      end
    end
    if sId then
      local sDataMap = self.fragmentStaticAttrDataMap[id]
      if sDataMap then
        return sDataMap[sId]
      end
    end
  end
end

local _getLabelColorFormatByStaticId = function(id)
  local f = PersonalArtifactProxy.GetBoundOrderByStaticAttrId(id)
  if f == 1 then
    return "[c][3A579B]%s[-][/c]（%s～%s）"
  elseif f == 2 then
    return "[c][FFC514]%s[-][/c]（%s～%s）"
  elseif f == 3 then
    return "[c][FF7C08]%s[-][/c]（%s～%s）"
  else
    return "[c][FF0000]%s[-][/c]（%s～%s）"
  end
end

function PersonalArtifactProxy:GetAttrDescByIdAndValue(id, value, isActive)
  local sData = self:GetStaticAttrDataByIdAndValue(id, value)
  if not sData then
    return ""
  end
  value = PersonalArtifactProxy.GetRealValue(value)
  local desc, labelColorFormat, attrMin, attrMax = string.split(OverSea.LangManager.Instance():GetLangByKey(sData.Dsc), delimiter), _getLabelColorFormatByStaticId(sData.id), sData.AttrInit, sData.AttrMax
  desc = desc[1]
  if not isActive then
    labelColorFormat = "[c][A0A0A0]%s（%s～%s）[-][/c]"
    desc = "[c][A0A0A0]" .. desc .. "[-][/c]"
  end
  if StringUtil.IsEmpty(desc) then
    return ""
  end
  if sData.IsPercent > 0 then
    labelColorFormat = string.gsub(labelColorFormat, "%%s", "%%s%%%%")
    value = value * 100
    attrMin = attrMin * 100
    attrMax = attrMax * 100
  end
  local sb = LuaStringBuilder.CreateAsTable()
  sb:Append(desc)
  sb:Append(delimiter)
  sb:Append(string.format(labelColorFormat, value, attrMin, attrMax))
  local s = sb:ToString()
  sb:Destroy()
  return s
end

local _getLabelColorFormatByStaticIdForShare = function(id)
  local f = PersonalArtifactProxy.GetBoundOrderByStaticAttrId(id)
  if f == 1 then
    return "[c][7AD6ED]%s[-][/c]（%s～%s）"
  elseif f == 2 then
    return "[c][FFC514]%s[-][/c]（%s～%s）"
  elseif f == 3 then
    return "[c][FF7C08]%s[-][/c]（%s～%s）"
  else
    return "[c][FF6363]%s[-][/c]（%s～%s）"
  end
end

function PersonalArtifactProxy:GetAttrDescByIdAndValueForShare(id, value)
  local sData = self:GetStaticAttrDataByIdAndValue(id, value)
  if not sData then
    return ""
  end
  value = PersonalArtifactProxy.GetRealValue(value)
  local desc, labelColorFormat, attrMin, attrMax = string.split(OverSea.LangManager.Instance():GetLangByKey(sData.Dsc), delimiter), _getLabelColorFormatByStaticIdForShare(sData.id), sData.AttrInit, sData.AttrMax
  desc = desc[1]
  if StringUtil.IsEmpty(desc) then
    return ""
  end
  if sData.IsPercent > 0 then
    labelColorFormat = string.gsub(labelColorFormat, "%%s", "%%s%%%%")
    value = value * 100
    attrMin = attrMin * 100
    attrMax = attrMax * 100
  end
  local sb = LuaStringBuilder.CreateAsTable()
  sb:Append(desc)
  sb:Append(delimiter)
  sb:Append(string.format(labelColorFormat, value, attrMin, attrMax))
  local s = sb:ToString()
  sb:Destroy()
  return s
end

function PersonalArtifactProxy:GetCurEquipedPersonalArtifactGuid()
  return self.equipedPersonalArtifactGuid
end

function PersonalArtifactProxy:GetAllFormulaItems()
  if not self.formulaId then
    self:InitStaticFormulaItemIds()
  end
  local formulaData = {}
  local IDs = self.formulaId
  for i = 1, #IDs do
    local bagItems = self:TryGetPersonalArtifactItems(IDs[i])
    if nil ~= next(bagItems) then
      for i = 1, #bagItems do
        formulaData[#formulaData + 1] = bagItems[i]
        if bagItems[i].bagtype == BagProxy.BagType.RoleEquip then
          self.equipedPersonalArtifactGuid = bagItems[i].id
        end
      end
    else
      local fakeItemdata = ItemData.new("personalArtifactFormula" .. tostring(i), IDs[i])
      fakeItemdata.personalArtifactData = PersonalArtifactData.new(fakeItemdata.staticData.id)
      fakeItemdata.personalArtifactData:SetFakeData()
      formulaData[#formulaData + 1] = fakeItemdata
    end
  end
  table.sort(formulaData, function(a, b)
    local aState = a:GetPersonalArtifactState()
    local bState = b:GetPersonalArtifactState()
    if aState == bState then
      if a.staticData.id == b.staticData.id then
        return a.id < b.id
      else
        return a.staticData.id < b.staticData.id
      end
    else
      return aState > bState
    end
  end)
  return formulaData
end

function PersonalArtifactProxy:GetFragmentItemIdsByQuality(quality)
  if not self.fragmentQualityItemIdsMap then
    self:InitStaticAttrData()
  end
  return quality and self.fragmentQualityItemIdsMap[quality]
end

function PersonalArtifactProxy.TryParseDataFromServerItemData(localItemData, serverItemData)
  localItemData.personalArtifactData = nil
  if serverItemData.artifact then
    local data = PersonalArtifactData.new(serverItemData.base.id, serverItemData.artifact)
    if data.isInited then
      localItemData.personalArtifactData = data
    end
  end
end

function PersonalArtifactProxy.GetFragmentItemDatasByStaticId(sId, includeFavorite)
  TableUtility.TableClear(tempTable)
  local bagIns, bagType = BagProxy.Instance, BagProxy.BagType.PersonalArtifactFragment
  local mats = bagIns:GetItemsByStaticID(sId, bagType)
  if mats then
    for i = 1, #mats do
      if includeFavorite or not bagIns:CheckIsFavorite(mats[i], bagType) then
        arrayPushBack(tempTable, mats[i])
      end
    end
  end
  return tempTable
end

function PersonalArtifactProxy.GetFragmentItemNumByStaticId(sId, includeFavorite)
  local datas = PersonalArtifactProxy.GetFragmentItemDatasByStaticId(sId, includeFavorite)
  local sum = 0
  local guid = ""
  for i = 1, #datas do
    guid = datas[i].id
    sum = sum + (datas[i].num or 0)
  end
  return sum, guid
end

function PersonalArtifactProxy.GetBoundOrderByStaticAttrId(id)
  if type(id) ~= "number" then
    id = 0
  end
  return math.fmod(id, 4)
end

function PersonalArtifactProxy.GetRealValue(v)
  return v / 1000
end

function PersonalArtifactProxy.CallExchange(targetId, materials)
  if not targetId or type(materials) ~= "table" then
    return
  end
  local itemNumMap, mat = ReusableTable.CreateTable()
  for i = 1, #materials do
    mat = materials[i]
    itemNumMap[mat.staticData.id] = (itemNumMap[mat.staticData.id] or 0) + mat.num
  end
  local mats, items, targetNum, sitem = ReusableTable.CreateArray()
  for sId, num in pairs(itemNumMap) do
    if 0 < num then
      items = PersonalArtifactProxy.GetFragmentItemDatasByStaticId(sId)
      targetNum = num
      for i = 1, #items do
        sitem = NetConfig.PBC and {} or SceneItem_pb.SItem()
        sitem.guid, sitem.count = items[i].id, math.min(items[i].num, targetNum)
        table.insert(mats, sitem)
        targetNum = targetNum - sitem.count
        if targetNum <= 0 then
          break
        end
      end
    end
  end
  ServiceItemProxy.Instance:CallPersonalArtifactExchangeItemCmd(targetId, mats)
  ReusableTable.DestroyArray(mats)
  ReusableTable.DestroyTable(itemNumMap)
end

function PersonalArtifactProxy.CallDecompose(chooseEquipMap)
  if type(chooseEquipMap) ~= "table" then
    return
  end
  local items, sitem = ReusableTable.CreateArray()
  for guid, data in pairs(chooseEquipMap) do
    if data.num > 0 then
      sitem = NetConfig.PBC and {} or SceneItem_pb.SItem()
      sitem.guid, sitem.count = guid, data.num
      table.insert(items, sitem)
    end
  end
  ServiceItemProxy.Instance:CallPersonalArtifactDecomposeItemCmd(items)
  ReusableTable.DestroyArray(items)
end

function PersonalArtifactProxy.CallCompose(targetId, materials)
  if not targetId or type(materials) ~= "table" then
    return
  end
  local items, sitem = ReusableTable.CreateArray()
  for i = 1, #materials do
    sitem = NetConfig.PBC and {} or SceneItem_pb.SItem()
    sitem.guid, sitem.count = materials[i].id, materials[i].num or 0
    table.insert(items, sitem)
  end
  ServiceItemProxy.Instance:CallPersonalArtifactComposeItemCmd(targetId, items)
  ReusableTable.DestroyArray(items)
end

function PersonalArtifactProxy:SetTargetArtifact(itemdata)
  self.curArtifact = itemdata
  self.curArtifactId = itemdata.staticData.id
  self.curArtifactguid = itemdata.id
  self.curArtifactComposeStatic = Table_PersonalArtifactCompose[self.curArtifactId]
end

function PersonalArtifactProxy:CheckFragmentActive(fragmentid)
  if not self.curArtifact then
    return
  end
  return self.curArtifact:CheckFragmentActive(fragmentid)
end

function PersonalArtifactProxy:GetRealTargetGuid()
  if string.match(self.curArtifactguid, "personalArtifactFormula") then
    return nil
  end
  return self.curArtifactguid
end

function PersonalArtifactProxy:GetCurArtifactID()
  return self.curArtifactId
end

function PersonalArtifactProxy:GetCostNumByIndex(index)
  return self.curArtifactComposeStatic.CostFlagments[index][2]
end

function PersonalArtifactProxy:TryGetPersonalArtifactItem(id)
  local bagIns = BagProxy.Instance
  local bag = bagIns:GetBagByType(_BagType)
  local bagItems, item = bag and bag:GetItems()
  if bagItems then
    for i = 1, #bagItems do
      item = bagItems[i]
      if item.id == id and item:IsRarePersonalArtifact() then
        return item
      end
    end
  end
  local roleEquip = bagIns.roleEquip
  local equipItems = roleEquip:GetItems()
  if equipItems then
    for i = 1, #equipItems do
      if equipItems[i].id == id and equipItems[i]:IsRarePersonalArtifact() then
        return equipItems[i]
      end
    end
  end
end

function PersonalArtifactProxy:TryGetPersonalArtifactItems(id, firstActive)
  local bagIns = BagProxy.Instance
  local bag = bagIns:GetBagByType(_BagType)
  local bagItems, item = bag and bag:GetItems()
  local result = {}
  if bagItems then
    for i = 1, #bagItems do
      item = bagItems[i]
      if item.staticData.id == id and item:IsRarePersonalArtifact() then
        if firstActive then
          return item
        else
          result[#result + 1] = item
        end
      end
    end
  end
  local roleEquip = bagIns.roleEquip
  local equipItems = roleEquip:GetItems()
  if equipItems then
    for i = 1, #equipItems do
      if equipItems[i].staticData.id == id and equipItems[i]:IsRarePersonalArtifact() then
        if firstActive then
          return equipItems[i]
        else
          result[#result + 1] = equipItems[i]
        end
      end
    end
  end
  return result
end
