autoImport("EquipMakeData")
EquipMakeProxy = class("EquipMakeProxy", pm.Proxy)
EquipMakeProxy.Instance = nil
EquipMakeProxy.NAME = "EquipMakeProxy"
local packageCheck = GameConfig.PackageMaterialCheck and GameConfig.PackageMaterialCheck.produce

function EquipMakeProxy:ctor(proxyName, data)
  self.proxyName = proxyName or EquipMakeProxy.NAME
  if EquipMakeProxy.Instance == nil then
    EquipMakeProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function EquipMakeProxy:Init()
  self.makeList = {}
  self.makeTable = {}
  self.selfProfessionMakeList = {}
  self.makeQueryList = {}
  self.lastNpcId = 0
end

function EquipMakeProxy:InitMakeList()
  TableUtility.ArrayClear(self.makeList)
  local table_compose = self:GetComposeTable()
  for k, v in pairs(table_compose) do
    local valid = true
    if v.Product then
      valid = EquipComposeProxy.CheckValid(v.Product.id)
    end
    valid = valid and EquipComposeProxy.CheckMatValid(v)
    if valid and v.Category == 1 and (not self.npcId or v.NpcId and v.NpcId == self.npcId) then
      self.makeList[#self.makeList + 1] = k
      if self.makeTable[k] == nil then
        self.makeTable[k] = EquipMakeData.new(k)
      end
    end
  end
  table.sort(self.makeList, function(l, r)
    local lData = self.makeTable[l]
    local rData = self.makeTable[r]
    if lData.sortId == rData.sortId then
      return lData.composeId < rData.composeId
    else
      return lData.sortId < rData.sortId
    end
  end)
  self.lastNpcId = self.npcId
end

function EquipMakeProxy:SetNpcId(npcId)
  self.npcId = npcId
end

function EquipMakeProxy:GetMakeList()
  self:InitMakeListByNpc()
  return self.makeList
end

function EquipMakeProxy:InitMakeListByNpc()
  if self.lastNpcId ~= self.npcId then
    self:InitMakeList()
  end
end

function EquipMakeProxy:GetMakeItemDatas()
  self:InitMakeListByNpc()
  local result = {}
  for i = 1, #self.makeList do
    local composeId = self.makeList[i]
    result[#result + 1] = self.makeTable[composeId].itemData
  end
  return result
end

function EquipMakeProxy:GetSelfProfessionMakeList()
  TableUtility.ArrayClear(self.selfProfessionMakeList)
  for i = 1, #self.makeList do
    local composeId = self.makeList[i]
    local makeData = self.makeTable[composeId]
    if makeData and makeData.itemData:CanEquip() then
      self.selfProfessionMakeList[#self.selfProfessionMakeList + 1] = composeId
    end
  end
  return self.selfProfessionMakeList
end

function EquipMakeProxy:GetMakeData(composeId)
  return self.makeTable[composeId]
end

function EquipMakeProxy:GetItemNumByStaticID(itemid)
  if itemid == 100 then
    return MyselfProxy.Instance:GetROB()
  end
  local _BagProxy = BagProxy.Instance
  local count = 0
  for i = 1, #packageCheck do
    count = count + _BagProxy:GetItemNumByStaticID(itemid, packageCheck[i])
  end
  return count
end

function EquipMakeProxy:HandleProduceDone(dtype, itemid, delay, count, num)
  if dtype ~= SceneItem_pb.EPRODUCETYPE_COMMON then
    return
  end
end

function EquipMakeProxy:_FloatMsg(itemid, count, num)
  local itemData = ItemData.new("Temp", itemid)
  itemData = BagProxy.Instance:GetNewestItemByStaticID(itemid)
  if BagProxy.CheckIs3DTypeItem(itemData.staticData.Type) then
    FloatAwardView.addItemDatasToShow({itemData})
  else
    local params = {}
    params[1] = itemid
    params[2] = itemid
    params[3] = num * count
    MsgManager.ShowMsgByIDTable(6, params)
  end
end

function EquipMakeProxy:InitStepEquipList()
  local step2List, step1List, ancientList = AdventureDataProxy.Instance:GetCommonEquip(nil, nil, true)
  self.step2List = step2List
  self.step2IdList = {}
  self.step1IdList = {}
  for _, v in pairs(self.step2List) do
    self.step2IdList[v.staticId] = 1
  end
  self.step1List = step1List
  for _, v in pairs(self.step1List) do
    self.step1IdList[v.staticId] = 1
  end
end

function EquipMakeProxy:CheckIsComposeStep1Equip(id)
  return self.step1IdList[id] ~= nil and self.makeQueryList[id] ~= nil
end

local step1LvMaxLimit = 10
local _getStep2UpgradeMakeMaterial = function(cfg, step1Lv)
  local mat, rob = {}, 0
  step1Lv = (step1Lv and math.clamp(step1Lv, 0, 3) or 0) + 1
  mat[cfg.id] = 1
  for i = step1Lv, step1LvMaxLimit do
    local m = cfg["Material_" .. i]
    if m then
      for _, v in pairs(m) do
        if v.id ~= 0 then
          mat[v.id] = (mat[v.id] or 0) + v.num
        end
      end
    end
  end
  if mat[100] then
    rob = mat[100]
    mat[100] = nil
  end
  local BeCostItem = {}
  for k, v in pairs(mat) do
    table.insert(BeCostItem, {id = k, num = v})
  end
  return BeCostItem, rob
end

function EquipMakeProxy:GetStep2UpgradeMakeMaterialByStep1Lv(step2Id, step1Lv)
  local cfg = self.step2MakeList[step2Id].oriCfg
  return _getStep2UpgradeMakeMaterial(cfg, step1Lv)
end

function EquipMakeProxy:InitStep2EquipMakeList()
  if not self.step2List then
    self:InitStepEquipList()
  end
  self.step2MakeList = {}
  local p
  for k, v in pairs(Table_EquipUpgrade) do
    p = v.Product
    if p and self.step2IdList[p] and self.step1IdList[k] then
      if not self.step2MakeList[p] then
        local mat, rob = _getStep2UpgradeMakeMaterial(v)
        self.step2MakeList[p] = {
          id = p,
          BeCostItem = mat,
          ROB = rob,
          Product = {id = p},
          Category = 1,
          Type = 2,
          oriCfg = v
        }
      else
        redlog("重复的step2装备合成", p)
      end
    end
  end
end

function EquipMakeProxy:GetComposeTable()
  if not self.step2MakeList then
    self:InitStep2EquipMakeList()
    setmetatable(self.step2MakeList, {
      __index = Table_Compose,
      __pairs = function(t)
        return function(t, k)
          local v
          local ck = rawget(t, k)
          if not ck then
            repeat
              k, v = next(Table_Compose, k)
            until rawget(t, k) == nil or k == nil
          end
          if k == nil or ck then
            k, v = next(t, k)
          end
          return k, v
        end, t, nil
      end
    })
    TableUtility.TableClear(self.makeList)
    local table_compose = self:GetComposeTable()
    for k, v in pairs(table_compose) do
      local valid = true
      if v.Product then
        valid = EquipComposeProxy.CheckValid(v.Product.id)
      end
      valid = valid and EquipComposeProxy.CheckMatValid(v)
      if valid and v.Category == 1 and self.makeQueryList[v.Product.id] == nil then
        self.makeQueryList[v.Product.id] = k
      end
    end
  end
  return self.step2MakeList
end

function EquipMakeProxy:GetBeTransformedWayTable()
  self:GetComposeTable()
  return self.makeQueryList
end

function EquipMakeProxy:GetFilteredMakeItemDatas(dataTypeFilter, professionCheck)
  self:SetNpcId(nil)
  self:InitMakeListByNpc()
  local result = {}
  for i = 1, #self.makeList do
    local composeId = self.makeList[i]
    local makeData = self.makeTable[composeId]
    if makeData then
      local itemData = makeData.itemData
      if itemData then
        local staticData = itemData.staticData
        if staticData then
          local staticid = staticData.id
          if staticid and (not (dataTypeFilter and dataTypeFilter.list) or TableUtility.ArrayFindIndex(dataTypeFilter.list, staticid) > 0) then
            if professionCheck then
              if itemData:CanEquip() then
                result[#result + 1] = makeData
              end
            else
              result[#result + 1] = makeData
            end
          end
        end
      end
    end
  end
  return result
end

local ReUniteCellData = function(datas, perRowNum)
  local newData = {}
  if datas ~= nil and 0 < #datas then
    for i = 1, #datas do
      local i1 = math.floor((i - 1) / perRowNum) + 1
      local i2 = math.floor((i - 1) % perRowNum) + 1
      newData[i1] = newData[i1] or {}
      if datas[i] == nil then
        newData[i1][i2] = nil
      else
        newData[i1][i2] = datas[i]
      end
    end
  end
  return newData
end
local GetItemType = function(itemData)
  local staticData = itemData.staticData
  if staticData then
    return staticData.Type
  end
  return 0
end

function EquipMakeProxy:GetClassifiedFilteredMakeItemDatas(dataTypeFilter, professionCheck)
  local datas = self:GetFilteredMakeItemDatas(dataTypeFilter, professionCheck)
  local result = {}
  local tabKey = {}
  local _PushArray = TableUtility.ArrayPushBack
  local COMPOSE_TYPE = GameConfig.EquipComposeType
  for k, v in pairs(COMPOSE_TYPE) do
    if nil == tabKey[k] then
      local cell = EquipComposeData.new(k)
      _PushArray(result, cell)
      tabKey[k] = 1
    end
    local cdata = {}
    for i = 1, #datas do
      if 0 ~= TableUtility.ArrayFindIndex(v.types, GetItemType(datas[i].itemData)) then
        _PushArray(cdata, datas[i])
      end
    end
    local cdata = ReUniteCellData(cdata, 5)
    for _, cc in pairs(cdata) do
      if not self.categoryMap or self.categoryMap[k] ~= false then
        local cell = EquipComposeData.new(k, cc)
        _PushArray(result, cell)
      end
    end
  end
  return result
end

function EquipMakeProxy:SetCategoryActive(c)
  if not self.categoryMap then
    self.categoryMap = {}
  end
  if self.categoryMap[c] == nil then
    self.categoryMap[c] = true
  end
  local active = not self.categoryMap[c]
  self.categoryMap[c] = active
  return active
end

function EquipMakeProxy:ResetCategoryActive()
  if not self.categoryMap then
    return
  end
  for i = 1, #self.categoryMap do
    self.categoryMap[i] = true
  end
end
