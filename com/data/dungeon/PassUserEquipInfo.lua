autoImport("PassItemData")
autoImport("PassEquipAndCardData")
autoImport("PassUserData")
PassUserEquipInfo = class("PassUserEquipInfo")

function PassUserEquipInfo:ctor(branch)
  self.branch = branch
  self.equipAndCardMap = {}
  self.equipAndCardListCache = {}
  self.viceEquipMap = {}
  self.viceEquipListCache = {}
  self.passUserInfos = {}
  local staticData = TableUtility.TableFindByPredicate(Table_EquipRecommend_New, function(k, v, args)
    return v.branch == args
  end, branch)
  local sEquips = staticData and staticData.equip
  local viceEquips = staticData and staticData.viceEquip
  local indexPosMap = GameConfig.PassUserInfo.record_equip_pos
  local viceIndexPosMap = GameConfig.PassUserInfo.record_shadow_equip_pos
  for i = 1, #sEquips do
    local pos = indexPosMap[i]
    local equipAndCardData = PassEquipAndCardData.new(pos)
    self.equipAndCardMap[pos] = equipAndCardData
    if sEquips then
      local passItemData = PassItemData.new(PassItemData.ItemType.EQUIP)
      passItemData:SetData(sEquips[i], 0)
      equipAndCardData:AddItemData(PassItemData.ItemType.EQUIP, passItemData)
    end
  end
  if viceEquips then
    for i = 1, #viceEquips do
      local pos = viceIndexPosMap[i]
      local viceEquipData = PassEquipAndCardData.new(pos)
      self.viceEquipMap[pos] = viceEquipData
      local passItemData = PassItemData.new(PassItemData.ItemType.EQUIP)
      passItemData:SetData(viceEquips[i], 0)
      viceEquipData:AddItemData(PassItemData.ItemType.EQUIP, passItemData)
    end
  end
end

function PassUserEquipInfo:SetDataFromServer(serverdata)
  if serverdata then
    for i = 1, #serverdata.equips do
      local sdata = serverdata.equips[i]
      local pos = sdata.pos
      local equipAndCardData = self.equipAndCardMap[pos]
      if equipAndCardData then
        if #sdata.equip > 0 then
          equipAndCardData:ClearItemData(PassItemData.ItemType.EQUIP)
        end
        if 0 < #sdata.card then
          equipAndCardData:ClearItemData(PassItemData.ItemType.CARD)
        end
        for j = 1, #sdata.equip do
          local equipData = PassItemData.new(PassItemData.ItemType.EQUIP, sdata.equip[j])
          equipAndCardData:AddItemData(PassItemData.ItemType.EQUIP, equipData)
        end
        for j = 1, #sdata.card do
          local cardData = PassItemData.new(PassItemData.ItemType.CARD, sdata.card[j])
          equipAndCardData:AddItemData(PassItemData.ItemType.CARD, cardData)
        end
      end
    end
    if serverdata.shadow_equips then
      for i = 1, #serverdata.shadow_equips do
        local sdata = serverdata.shadow_equips[i]
        local pos = sdata.pos
        local viceEquipData = self.viceEquipMap[pos]
        if viceEquipData then
          if #sdata.equip > 0 then
            viceEquipData:ClearItemData(PassItemData.ItemType.EQUIP)
          end
          for j = 1, #sdata.equip do
            local equipData = PassItemData.new(PassItemData.ItemType.EQUIP, sdata.equip[j])
            viceEquipData:AddItemData(PassItemData.ItemType.EQUIP, equipData)
          end
        end
      end
    end
    for i = 1, #serverdata.userinfos do
      local sdata = serverdata.userinfos[i]
      local data = PassUserData.new(sdata)
      TableUtility.ArrayPushBack(self.passUserInfos, data)
    end
  end
end

function PassUserEquipInfo:GetEquipAndCardInfos()
  local equipIndexes = GameConfig.PassUserInfo.record_equip_pos
  return self:GetListCache(self.equipAndCardListCache, self.equipAndCardMap, equipIndexes)
end

function PassUserEquipInfo:GetPassUserInfos()
  return self.passUserInfos
end

function PassUserEquipInfo:GetViceEquipInfos()
  local viceEquipIndexes = GameConfig.PassUserInfo.record_shadow_equip_pos
  return self:GetListCache(self.viceEquipListCache, self.viceEquipMap, viceEquipIndexes)
end

function PassUserEquipInfo:GetListCache(cache, map, indexes)
  if #cache == 0 then
    for i = 1, #indexes do
      local index = indexes[i]
      cache[i] = map[index]
    end
  end
  return cache
end
