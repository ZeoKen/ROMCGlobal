AutoHealingProxy = class("AutoHealingProxy", pm.Proxy)
AutoHealingProxy.Instance = nil
AutoHealingProxy.NAME = "AutoHealingProxy"

function AutoHealingProxy:ctor(proxyName, data)
  self.proxyName = proxyName or AutoHealingProxy.NAME
  if AutoHealingProxy.Instance == nil then
    AutoHealingProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function AutoHealingProxy:Init()
  self.potionSetting = {}
  self.hpPotions = {}
  self.spPotions = {}
end

function AutoHealingProxy:UpdatePotionSetting(data)
  redlog("AutoHealingProxy:UpdatePotionSetting", data.hp_setting.edge, data.sp_setting.edge)
  if data.hp_setting then
    local hpSetting = self.potionSetting[1]
    if not hpSetting then
      hpSetting = {}
      hpSetting.item = {}
      self.potionSetting[1] = hpSetting
    end
    hpSetting.auto_on = data.hp_setting.auto_on
    hpSetting.edge = data.hp_setting.edge
    TableUtility.ArrayClear(hpSetting.item)
    for i = 1, #data.hp_setting.item do
      local itemId = data.hp_setting.item[i]
      hpSetting.item[i] = itemId
    end
  end
  if data.sp_setting then
    local spSetting = self.potionSetting[2]
    if not spSetting then
      spSetting = {}
      spSetting.item = {}
      self.potionSetting[2] = spSetting
    end
    spSetting.auto_on = data.sp_setting.auto_on
    spSetting.edge = data.sp_setting.edge
    TableUtility.ArrayClear(spSetting.item)
    for i = 1, #data.sp_setting.item do
      local itemId = data.sp_setting.item[i]
      spSetting.item[i] = itemId
    end
  end
end

function AutoHealingProxy:GetPotionSetting(type)
  return self.potionSetting[type]
end

function AutoHealingProxy:GetPotionItemId(type, index)
  local setting = self.potionSetting[type]
  if setting then
    return setting.item[index] or 0
  end
  return 0
end

function AutoHealingProxy:GetPotionItemIdCanUse(type)
  local setting = self.potionSetting[type]
  if setting and setting.auto_on then
    local potionNum
    for i = 1, 3 do
      local itemId = self:GetPotionItemId(type, i)
      if 0 < itemId then
        local num = BagProxy.Instance:GetItemNumByStaticID(itemId)
        if 0 < num then
          return itemId, num
        end
        potionNum = 0
      end
    end
    if potionNum == 0 then
      return 0, 0
    end
    return 0
  end
  return -1
end

function AutoHealingProxy:SetPotionItemId(type, index, itemId)
  local setting = self.potionSetting[type]
  if setting then
    setting.item[index] = itemId
  end
end

function AutoHealingProxy:GetQuickSetPotion(type, list)
  local datas = self:GetPotionItems(type)
  if datas then
    for i = 1, 3 do
      if datas[i] then
        local itemId = datas[i].id
        if BagProxy.Instance:GetItemNumByStaticID(itemId) > 0 then
          list[i] = itemId
        else
          list[i] = 0
        end
      else
        list[i] = 0
      end
    end
  end
end

function AutoHealingProxy:GetPotionUseLimit(type)
  local setting = self.potionSetting[type]
  return setting and setting.edge or 10
end

function AutoHealingProxy:SetPotionUseLimit(type, value)
  local setting = self.potionSetting[type]
  if setting then
    setting.edge = value
  end
end

function AutoHealingProxy:SetAutoHealingState(type, on)
  local setting = self.potionSetting[type]
  if setting then
    setting.auto_on = on
  end
end

function AutoHealingProxy:GetPotionItemIndex(type, itemId)
  local setting = self.potionSetting[type]
  if setting then
    return TableUtility.ArrayFindIndex(setting.item, itemId)
  end
  return 0
end

function AutoHealingProxy:IsPotionUsed(type, itemId)
  return self:GetPotionItemIndex(type, itemId) > 0
end

local potionSortFunc = function(id1, id2, oriDatas)
  local num1 = BagProxy.Instance:GetItemNumByStaticID(id1)
  local num2 = BagProxy.Instance:GetItemNumByStaticID(id2)
  local sort1 = oriDatas[id1]
  local sort2 = oriDatas[id2]
  if num1 == 0 and num2 == 0 or 0 < num1 and 0 < num2 then
    return sort1 > sort2
  else
    return num1 == 0
  end
end

function AutoHealingProxy:GetPotionItems(type)
  local oriDatas, datas
  if type == 1 then
    oriDatas = GameConfig.PotionStore.hp_potion
    datas = self.hpPotions
  elseif type == 2 then
    oriDatas = GameConfig.PotionStore.sp_potion
    datas = self.spPotions
  end
  if oriDatas then
    TableUtility.ArrayClear(datas)
    for itemId, sort in pairs(oriDatas) do
      local data = {}
      data.id = itemId
      data.type = type
      if #datas == 0 then
        table.insert(datas, data)
      else
        local inserted = false
        for i = 1, #datas do
          local id = datas[i].id
          if potionSortFunc(id, itemId, oriDatas) then
            table.insert(datas, i, data)
            inserted = true
            break
          end
        end
        if not inserted then
          table.insert(datas, data)
        end
      end
    end
  end
  return datas
end
