EquipRecoverProxy = class("EquipRecoverProxy", pm.Proxy)
EquipRecoverProxy.Instance = nil
EquipRecoverProxy.NAME = "EquipRecoverProxy"
EquipRecoverProxy.RecoverType = {
  Card = "Card",
  EmptyCard = "EmptyCard",
  EmptyEnchant = "EmptyEnchant",
  Enchant = "Enchant",
  Upgrade = "Upgrade",
  EmptyUpgrade = "EmptyUpgrade",
  Quench = "Quench",
  EmptyQuench = "EmptyQuench",
  Refine = "Refine",
  EmptyRefine = "EmptyRefine",
  EquipMemory = "EquipMemory"
}
local packageCheck = GameConfig.PackageMaterialCheck and GameConfig.PackageMaterialCheck.restore

function EquipRecoverProxy:ctor(proxyName, data)
  self.proxyName = proxyName or EquipRecoverProxy.NAME
  if EquipRecoverProxy.Instance == nil then
    EquipRecoverProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function EquipRecoverProxy:Init()
  self.recoverList = {}
  self.recoverToggleList = {}
end

function EquipRecoverProxy:GetRecoverEquips()
  local _BagProxy = BagProxy.Instance
  TableUtility.ArrayClear(self.recoverList)
  for i = 1, #packageCheck do
    local items = _BagProxy:GetBagByType(packageCheck[i]):GetItems()
    for j = 1, #items do
      local equip = items[j]
      if equip and equip.equipInfo and EquipRecoverProxy.IsEquipNeedRecover(equip) then
        TableUtility.ArrayPushBack(self.recoverList, equip)
      end
    end
  end
  return self.recoverList
end

function EquipRecoverProxy:GetMagicStoneRecover()
  TableUtility.ArrayClear(self.recoverList)
  local equipDatas = BagProxy.Instance:GetBagEquipItems()
  for i = 1, #equipDatas do
    local equip = equipDatas[i]
    if equip and EquipRecoverProxy.IsEquipNeedMagicStoneRecover(equip) then
      TableUtility.ArrayPushBack(self.recoverList, equip)
    end
  end
  return self.recoverList
end

function EquipRecoverProxy.IsEquipNeedRecover(itemData)
  local equipInfo = itemData.equipInfo
  if equipInfo and equipInfo.strengthlv > 0 then
    return true
  elseif equipInfo and 0 < equipInfo.strengthlv2 then
    return true
  elseif itemData:HasEquipedCard() then
    return true
  elseif itemData.enchantInfo and 0 < #itemData.enchantInfo:GetEnchantAttrs() then
    return true
  elseif equipInfo and 0 < equipInfo.equiplv and not ItemUtil.IsGVGSeasonEquip(itemData.staticData.id) then
    return true
  elseif equipInfo and equipInfo.quench_per and 0 < equipInfo.quench_per then
    return true
  elseif itemData.equipMemoryData then
    return true
  end
  return false
end

function EquipRecoverProxy.IsEquipNeedMagicStoneRecover(itemData)
  local equipInfo = itemData.equipInfo
  if itemData:GetEquipedCardNum() > 0 then
    return true
  end
  return false
end

local HideUpgradePredicate = function(item)
  if item and item.equipInfo and item.equipInfo:IsNextGen() then
    return true
  end
  return false
end
local HideQuenchPredicate = function(item)
  if FunctionUnLockFunc.CheckForbiddenByFuncState("recover_shadow_equip_forbidden") then
    return true
  end
  if item and item.equipInfo and item.equipInfo:CanQuench_ByStaticData() then
    return false
  end
  return true
end
local HideRefineRecover = function(item)
  if not GameConfig.EquipRecover.Refine then
    return true
  end
  if item and item.equipInfo and item.equipInfo.refinelv then
    return item.equipInfo.refinelv == 0
  end
  return true
end
local HideEquipMemoryRecover = function(item)
  if not GameConfig.EquipRecover.Memory then
    return true
  end
  if item and item.equipMemoryData then
    return false
  end
end

function EquipRecoverProxy:GetRecoverToggle(item)
  TableUtility.ArrayClear(self.recoverToggleList)
  for i = 1, 2 do
    if item and item.equipedCardInfo and item.equipedCardInfo[i] then
      TableUtility.ArrayPushBack(self.recoverToggleList, item.equipedCardInfo[i])
    else
      TableUtility.ArrayPushBack(self.recoverToggleList, self.RecoverType.EmptyCard)
    end
  end
  if item and item.enchantInfo and #item.enchantInfo:GetEnchantAttrs() > 0 then
    TableUtility.ArrayPushBack(self.recoverToggleList, self.RecoverType.Enchant)
  else
    TableUtility.ArrayPushBack(self.recoverToggleList, self.RecoverType.EmptyEnchant)
  end
  if not HideUpgradePredicate(item) then
    if item and item.equipInfo and 0 < item.equipInfo.equiplv then
      TableUtility.ArrayPushBack(self.recoverToggleList, item.equipInfo.equiplv)
    else
      TableUtility.ArrayPushBack(self.recoverToggleList, self.RecoverType.EmptyUpgrade)
    end
  end
  if not HideQuenchPredicate(item) then
    if item and item.equipInfo and item.equipInfo.quench_per and 0 < item.equipInfo.quench_per then
      TableUtility.ArrayPushBack(self.recoverToggleList, self.RecoverType.Quench)
    else
      TableUtility.ArrayPushBack(self.recoverToggleList, self.RecoverType.EmptyQuench)
    end
  end
  if not HideRefineRecover(item) then
    TableUtility.ArrayPushBack(self.recoverToggleList, self.RecoverType.Refine)
  end
  return self.recoverToggleList
end

function EquipRecoverProxy:GetMagicStoneRecoverToggle(item)
  TableUtility.ArrayClear(self.recoverToggleList)
  for i = 1, 2 do
    if item and item.equipedCardInfo and item.equipedCardInfo[i] then
      TableUtility.ArrayPushBack(self.recoverToggleList, item.equipedCardInfo[i])
    else
      TableUtility.ArrayPushBack(self.recoverToggleList, self.RecoverType.EmptyCard)
    end
  end
  return self.recoverToggleList
end

function EquipRecoverProxy:SetCurrency(currency)
  self.currency = currency
end

function EquipRecoverProxy:GetCurrency()
  return self.currency or GameConfig.MoneyId.Zeny
end
