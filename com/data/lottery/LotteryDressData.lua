local _genderField = {
  [1] = "male",
  [2] = "female"
}
LotteryDressType = {
  Magic = 1,
  Head = 2,
  Mix = 3
}
LotteryDressData = class("LotteryDressData")

function LotteryDressData.CheckValid(lotterytype, headwearType)
  local _filter_config = GameConfig.Lottery.TypeFilter
  if not _filter_config then
    return false
  end
  local _type_field = LotteryProxy.TypeField(lotterytype)
  if not _type_field then
    return false
  end
  local _gender_field = _genderField[MyselfProxy.Instance:GetMySex()]
  local valid_type_map = _filter_config[_type_field] and _filter_config[_type_field][_gender_field] and _filter_config[_type_field][_gender_field][headwearType]
  return nil ~= valid_type_map
end

function LotteryDressData:ctor(t)
  self.type = t
  self:InitCompareFunc()
end

function LotteryDressData:InitCompareFunc()
  self.compareFunc = {}
  self.compareFunc[LotteryType.Head] = self._compareToHeadwear
  self.compareFunc[LotteryType.Magic] = self._compareToMagic
  self.compareFunc[LotteryType.MagicSec] = self._compareToMagic
  self.compareFunc[LotteryType.MagicThird] = self._compareToMagic
  self.compareFunc[LotteryType.Mixed] = self._compareToMix
  self.compareFunc[LotteryType.MixedSec] = self._compareToMix
  self.compareFunc[LotteryType.MixedThird] = self._compareToMix
  self.compareFunc[LotteryType.MixedFourth] = self._compareToMix
  self.compareFunc[LotteryType.NewMix] = self._compareToMix
end

function LotteryDressData:SetData(data)
  if not data then
    return
  end
  self:ResetData(data)
end

function LotteryDressData:ResetData(data)
  self.rate = data:GetRate()
  self.id = data:GetRealItemID()
  self.quality = Table_Item[self.id].Quality
  self.type = data.type
  self.partIndex = ItemUtil.getItemRolePartIndex(self.id)
  self.got = data:CheckGoodsGot()
  self:SetEquipID()
end

function LotteryDressData:SetEquipID()
  if self.partIndex == Asset_Role.PartIndex.Body then
    self.equipID = EquipInfo.GetDisplayBody(self.id)
  else
    self.equipID = self.id
  end
end

function LotteryDressData:CompareTo(data)
  local id = data:GetRealItemID()
  local partIndex = ItemUtil.getItemRolePartIndex(id)
  if partIndex ~= self.partIndex then
    return
  end
  local func = self.compareFunc[self.type]
  if func then
    local success = func(self, data)
    if success then
      self:ResetData(data)
    end
  end
end

function LotteryDressData:_compareToHeadwear(data)
  local id = data:GetRealItemID()
  local rate = data:GetRate()
  local quality = Table_Item[id].Quality
  if rate == self.rate then
    if quality == self.quality then
      return id < self.id
    else
      return quality > self.quality
    end
  else
    return rate < self.rate
  end
end

function LotteryDressData:_compareToMagic(data)
  return data:GetRealItemID() < self.id
end

function LotteryDressData:_compareToMix(data)
  if self.got and not data:CheckGoodsGot() then
    return true
  end
  if not data:CheckGoodsGot() then
    return data:GetRealItemID() < self.id
  end
  return false
end
