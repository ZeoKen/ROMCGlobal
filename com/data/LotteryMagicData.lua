local _ArrayPushBack = TableUtility.ArrayPushBack
local _ArrayClear = TableUtility.ArrayClear
local _CheckFilterCondition = function(condition, itemid)
  if condition == nil then
    return true
  end
  if condition == "Unlock" then
    local id = itemid
    local equip = Table_Equip[id]
    if equip and equip.GroupID then
      id = equip.GroupID
    end
    if not AdventureDataProxy.Instance:IsFashionOrMountUnlock(id) then
      return true
    end
  end
  return false
end
autoImport("LotteryData")
LotteryMagicData = class("LotteryMagicData", LotteryData)

function LotteryMagicData:ctor(data, type)
  LotteryMagicData.super.ctor(self, data, true)
  self.dressMap = FunctionLottery.SetDressData(type, self.items)
  self.filterItems = {}
end

function LotteryMagicData:FilterMagic(filter)
  _ArrayClear(self.filterItems)
  local config = filter and GameConfig.Lottery and GameConfig.Lottery.MagicFilter and GameConfig.Lottery.MagicFilter[filter]
  if config ~= nil then
    local data
    local types = config.types
    for i = 1, #self.items do
      data = self.items[i]
      if types[data.itemType] ~= nil and _CheckFilterCondition(config.condition, data.itemid) then
        _ArrayPushBack(self.filterItems, data)
      end
    end
  end
  return self.filterItems
end

function LotteryMagicData:GetInitializedDressData()
  return self.dressMap
end
