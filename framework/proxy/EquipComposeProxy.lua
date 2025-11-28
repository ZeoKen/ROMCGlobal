autoImport("Table_EquipComposeProduct")
autoImport("EquipComposeItemData")
autoImport("EquipComposeNewItemData")
EquipComposeProxy = class("EquipComposeProxy", pm.Proxy)
EquipComposeProxy.Instance = nil
EquipComposeProxy.NAME = "EquipComposeProxy"
local _PushArray = TableUtility.ArrayPushBack
local COMPOSE_TYPE = GameConfig.EquipComposeType

function EquipComposeProxy:ctor(proxyName, data)
  self.proxyName = proxyName or EquipComposeProxy.NAME
  if EquipComposeProxy.Instance == nil then
    EquipComposeProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function EquipComposeProxy:Init()
  self.composeData = {}
  self.classifiedMap = {}
  self.categoryMap = {}
  self.composeKeyList = {}
  self.inited = false
end

function EquipComposeProxy.CheckValid(id)
  local tryParse_FuncStateId = Game.Config_EquipComposeIDForbidMap[id]
  if tryParse_FuncStateId then
    return FunctionUnLockFunc.checkFuncStateValid(tryParse_FuncStateId)
  end
  return true
end

function EquipComposeProxy.CheckMatValid(composeData)
  if composeData then
    local costs = composeData.BeCostItem
    for i = 1, #costs do
      local itemID = costs[i].id
      if not Table_Item[itemID] then
        redlog("Compose表ID素材不合法 请检查", itemID)
        return false
      end
    end
    local productID = composeData.Product.id
    if productID and not Table_Item[productID] then
      redlog("Compose表Product不合法 请检查", productID)
      return false
    end
    return true
  else
    return false
  end
end

function EquipComposeProxy:InitData()
  if self.inited then
    return
  end
  if FunctionUnLockFunc.CheckForbiddenByFuncState("equip_compose_forbidden") then
    return
  end
  self.inited = true
  local tempdata = {}
  for k, v in pairs(Table_EquipCompose) do
    local valid = EquipComposeProxy.CheckValid(v.id)
    if valid then
      if Table_Equip[v.id] then
        local itemData = EquipComposeItemData.new(v)
        if itemData.composeID then
          _PushArray(tempdata, itemData)
        end
      else
        redlog("魔能灌注装备EquipCompose在Equip表中不存在，需要检查差分配置", v.id)
      end
      local mainMat = v.Material and v.Material[1]
      if mainMat then
        self.composeKeyList[mainMat.id] = {
          lv = mainMat.lv,
          composeID = k
        }
      end
    end
  end
  table.sort(tempdata, function(l, r)
    return l.composeID < r.composeID
  end)
  local id = {}
  for i = 1, #tempdata do
    if 0 == TableUtility.ArrayFindIndex(id, tempdata[i].composeID) then
      _PushArray(self.composeData, tempdata[i])
      for j = 1, #tempdata do
        if tempdata[i].VIDType == tempdata[j].VIDType and tempdata[i].VID == tempdata[j].VID and tempdata[i].composeID ~= tempdata[j].composeID then
          _PushArray(self.composeData, tempdata[j])
          id[#id + 1] = tempdata[j].composeID
          break
        end
      end
    end
  end
  for k, v in pairs(COMPOSE_TYPE) do
    for i = 1, #self.composeData do
      if 0 ~= TableUtility.ArrayFindIndex(v.types, self.composeData[i]:GetItemType()) then
        if nil == self.classifiedMap[k] then
          self.classifiedMap[k] = {}
          self.categoryMap[k] = true
        end
        _PushArray(self.classifiedMap[k], self.composeData[i])
      end
    end
  end
end

function EquipComposeProxy:SetCategoryActive(c)
  local active = not self.categoryMap[c]
  self.categoryMap[c] = active
  return active
end

function EquipComposeProxy:ResetCategoryActive()
  for i = 1, #self.categoryMap do
    self.categoryMap[i] = true
  end
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

function EquipComposeProxy:GetTypeFilterData(professionCheck)
  local data = {}
  local tabKey = {}
  for k, composeArray in pairs(self.classifiedMap) do
    if nil == tabKey[k] then
      local cell = EquipComposeData.new(k)
      _PushArray(data, cell)
      tabKey[k] = 1
    end
    local composeData = {}
    if not professionCheck then
      composeData = composeArray
    else
      for i = 1, #composeArray do
        if composeArray[i]:CheckProfessionValid() then
          composeData[#composeData + 1] = composeArray[i]
        end
      end
    end
    local composeData = ReUniteCellData(composeData, 5)
    for _, v in pairs(composeData) do
      if self.categoryMap[k] then
        local cell = EquipComposeData.new(k, v)
        _PushArray(data, cell)
      end
    end
  end
  return data
end

function EquipComposeProxy:SetCurrentData(data)
  if self.curData ~= data then
    self.curData = data
    if self.curData then
      self.curData:ResetChooseMat()
    end
  end
end

function EquipComposeProxy:SetChooseMat(index, itemData)
  if not self.curData then
    return
  end
  self.curData:SetChooseMat(index, itemData)
end

function EquipComposeProxy:GetCurData()
  return self.curData
end

function EquipComposeProxy:SetTargetID(id)
  self.targetID = id
end

function EquipComposeProxy:GetTargetID()
  return self.targetID
end

function EquipComposeProxy:ClearTargetID()
  self.targetID = nil
end

function EquipComposeProxy:GetComposeDataByMainMatID(mainMatID)
  if self.composeKeyList and self.composeKeyList[mainMatID] then
    return self.composeKeyList[mainMatID]
  end
end

function EquipComposeProxy:SetCurOperEquipGuid(guid)
  self.curOperEquipGuid = guid
end

function EquipComposeProxy:GetCurOperEquipGuid()
  return self.curOperEquipGuid
end
