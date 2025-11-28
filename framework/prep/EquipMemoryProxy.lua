EquipMemoryProxy = class("EquipMemoryProxy", pm.Proxy)
EquipMemoryProxy.Instance = nil
EquipMemoryProxy.NAME = "EquipMemoryProxy"
autoImport("EquipMemoryData")
EquipMemoryProxy.SortValue = {
  attack = 1,
  defence = 2,
  special = 3
}
EquipMemoryProxy.EquipPosGroup = nil
EquipMemoryProxy.PosEnumItemID = {
  [1] = 4703,
  [2] = 4706,
  [3] = 4709,
  [4] = 4714
}

function EquipMemoryProxy.GetEquipPosGroupEnum(equipPos)
  if Game and Game.GetEquipPosGroupEnum then
    return Game.GetEquipPosGroupEnum(equipPos)
  end
  return nil
end

function EquipMemoryProxy.GetSpecialEffectIds(equipPos)
  if Game and Game.GetSpecialEffectIds then
    return Game.GetSpecialEffectIds(equipPos)
  end
  return {}
end

function EquipMemoryProxy.GetSpecialEffectIdsByEnum(groupEnum)
  if Game and Game.GetSpecialEffectIdsByEnum then
    return Game.GetSpecialEffectIdsByEnum(groupEnum)
  end
  return {}
end

function EquipMemoryProxy.InitEnumReferences()
  if Game and Game.EquipPosGroup then
    EquipMemoryProxy.EquipPosGroup = Game.EquipPosGroup
  end
end

function EquipMemoryProxy:ctor(proxyName, data)
  self.proxyName = proxyName or EquipMemoryProxy.NAME
  if EquipMemoryProxy.Instance == nil then
    EquipMemoryProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function EquipMemoryProxy:Init()
  self.equipPosData = {}
  EquipMemoryProxy.InitEnumReferences()
  self.balanceMemorys = {}
end

function EquipMemoryProxy:RecvUpdateMemoryPosItemCmd(data)
  local pos = data.pos
  TableUtility.TableClear(self.equipPosData)
  if pos and 0 < #pos then
    for i = 1, #pos do
      local single = pos[i]
      local _equipPos = single.pos
      local itemid = single.memory.itemid
      if itemid and itemid ~= 0 then
        local memoryData = EquipMemoryData.new(_equipPos)
        memoryData:SetMyServerData(single.memory)
        self.equipPosData[_equipPos] = memoryData
      end
    end
  end
end

function EquipMemoryProxy:GetTotalEquipMemoryLevels(fullfire)
  local memoryLevels = {}
  local addMemoryLevel = function(attrid)
    if attrid and attrid ~= 0 then
      memoryLevels[attrid] = (memoryLevels[attrid] or 0) + 1
    end
  end
  local processMemoryAttrs = function(posData)
    if posData then
      local attrs = posData.memoryAttrs or {}
      for i = 1, #attrs do
        addMemoryLevel(attrs[i].id)
      end
    end
  end
  if fullfire then
    for i = 1, 12 do
      local roleEquip = BagProxy.Instance:GetEquipBySite(i)
      local posData = self:GetPosData(i, true)
      if roleEquip and posData then
        processMemoryAttrs(posData)
      else
        local posEnum = EquipMemoryProxy.GetEquipPosGroupEnum(i)
        local balanceMemory = self:GetBalanceMemory(posEnum)
        addMemoryLevel(balanceMemory)
      end
    end
  else
    for _pos, _memoryData in pairs(self.equipPosData) do
      local roleEquip = BagProxy.Instance:GetEquipBySite(_pos)
      if roleEquip then
        processMemoryAttrs(self:GetPosData(_pos, false))
      end
    end
  end
  return memoryLevels
end

function EquipMemoryProxy:GetPosData(pos, fullFire)
  if self.equipPosData and self.equipPosData[pos] then
    if fullFire then
      local baseMemoryData = self.equipPosData[pos]:Clone()
      baseMemoryData.level = baseMemoryData.maxLevel
      local posEnum = EquipMemoryProxy.GetEquipPosGroupEnum(pos)
      local balanceMemory = self:GetBalanceMemory(posEnum)
      if balanceMemory and balanceMemory ~= 0 then
        local memoryAttrs = baseMemoryData.memoryAttrs
        if memoryAttrs then
          if #memoryAttrs < 3 then
            table.insert(memoryAttrs, {id = balanceMemory, level = 1})
          else
            memoryAttrs[3].id = balanceMemory
            memoryAttrs[3].level = 1
          end
        else
          baseMemoryData.memoryAttrs = {
            {id = balanceMemory, level = 1}
          }
        end
      end
      return baseMemoryData
    end
    return self.equipPosData[pos]:Clone()
  end
end

function EquipMemoryProxy.DebugPrintSpecialEffectMap()
  if not (Game and Game.EquipMemorySpecialEffectMap) or not Game.EquipPosGroup then
    print("=== 特殊效果映射表未初始化 ===")
    return
  end
  print("=== 特殊效果映射表 ===")
  local enumNames = {
    [Game.EquipPosGroup.WEAPON] = "WEAPON{5,6,7}",
    [Game.EquipPosGroup.ARMOR] = "ARMOR{2,3,4}",
    [Game.EquipPosGroup.ACCESSORY] = "ACCESSORY{8,9,10}",
    [Game.EquipPosGroup.SPECIAL] = "SPECIAL{1,11,12}"
  }
  for groupEnum, memoryIds in pairs(Game.EquipMemorySpecialEffectMap) do
    local groupName = enumNames[groupEnum] or "未知组(" .. groupEnum .. ")"
    print(string.format("装备位置组 [%s] 的特殊效果ID: %s", groupName, table.concat(memoryIds, ",")))
  end
end

function EquipMemoryProxy:RecvBalanceModeMemoryUpdateItemCmd(data)
  local balanceMemorys = data.balance_memory
  if balanceMemorys and 0 < #balanceMemorys then
    for i = 1, #balanceMemorys do
      local balanceMemory = balanceMemorys[i]
      local pos = balanceMemory.pos
      local effects = balanceMemory.effects
      local posEnum = EquipMemoryProxy.GetEquipPosGroupEnum(pos)
      if not self.balanceMemorys[posEnum] then
        self.balanceMemorys[posEnum] = {}
      end
      for j = 1, #effects do
        local index = effects[j].index
        local effectid = effects[j].effect_id
        if index == 2 then
          self.balanceMemorys[posEnum] = effectid
        end
      end
    end
  end
end

function EquipMemoryProxy:GetBalanceMemory(posEnum)
  if self.balanceMemorys and self.balanceMemorys[posEnum] then
    return self.balanceMemorys[posEnum]
  end
end
