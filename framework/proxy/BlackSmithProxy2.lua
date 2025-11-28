local ancientRandomEquipPosMap = {}

function BlackSmithProxy.GetAncientRandomEquipPosMap()
  if not next(ancientRandomEquipPosMap) then
    ancientRandomEquipPosMap = {
      [1] = 1,
      [2] = 1,
      [3] = 1,
      [4] = 1,
      [5] = 1,
      [6] = 1
    }
  end
  return ancientRandomEquipPosMap
end

function BlackSmithProxy:GetAncientRandomEquips(valid_equippos_map, includeFashion)
  local result = {}
  if includeFashion then
    local fashionEquips = BagProxy.Instance.fashionBag:GetItems()
    local equipInfo
    for i = 1, #fashionEquips do
      equipInfo = fashionEquips[i].equipInfo
      if equipInfo then
        if valid_equippos_map then
          if valid_equippos_map[equipInfo.site[1]] and equipInfo:CanAncientRandom() then
            table.insert(result, fashionEquips[i])
          end
        elseif equipInfo:CanAncientRandom() then
          table.insert(result, fashionEquips[i])
        end
      end
    end
  end
  local roleEquips = BagProxy.Instance.roleEquip:GetItems()
  local equipInfo
  for i = 1, #roleEquips do
    equipInfo = roleEquips[i].equipInfo
    if equipInfo then
      if valid_equippos_map then
        if valid_equippos_map[equipInfo.site[1]] and equipInfo:CanAncientRandom() then
          table.insert(result, roleEquips[i])
        end
      elseif equipInfo:CanAncientRandom() then
        table.insert(result, roleEquips[i])
      end
    end
  end
  local roleShadowEquips = BagProxy.Instance.shadowBagData:GetItems()
  for i = 1, #roleShadowEquips do
    equipInfo = roleShadowEquips[i].equipInfo
    if equipInfo then
      if valid_equippos_map then
        if valid_equippos_map[equipInfo.site[1]] and equipInfo:CanAncientRandom() then
          table.insert(result, roleShadowEquips[i])
        end
      elseif equipInfo:CanAncientRandom() then
        table.insert(result, roleShadowEquips[i])
      end
    end
  end
  local items = BagProxy.Instance:GetBagEquipTab():GetItems()
  for i = 1, #items do
    equipInfo = items[i].equipInfo
    if equipInfo then
      if valid_equippos_map then
        if valid_equippos_map[equipInfo.site[1]] and equipInfo:CanAncientRandom() then
          table.insert(result, items[i])
        end
      elseif equipInfo:CanAncientRandom() then
        table.insert(result, items[i])
      end
    end
  end
  BlackSmithProxy.SortEquips(result)
  return result
end

local ancientUpgradeEquipPosMap = {}

function BlackSmithProxy.GetAncientUpgradeEquipPosMap()
  if not next(ancientUpgradeEquipPosMap) then
    ancientUpgradeEquipPosMap = {
      [1] = 1,
      [2] = 1,
      [3] = 1,
      [4] = 1,
      [5] = 1,
      [6] = 1
    }
  end
  return ancientUpgradeEquipPosMap
end

function BlackSmithProxy:GetAncientUpgradeEquips(valid_equippos_map, includeFashion)
  local result = {}
  if includeFashion then
    local fashionEquips = BagProxy.Instance.fashionBag:GetItems()
    local equipInfo
    for i = 1, #fashionEquips do
      equipInfo = fashionEquips[i].equipInfo
      if equipInfo then
        if valid_equippos_map then
          if valid_equippos_map[equipInfo.site[1]] and equipInfo:CanAncientUpgrade() then
            table.insert(result, fashionEquips[i])
          end
        elseif equipInfo:CanAncientUpgrade() then
          table.insert(result, fashionEquips[i])
        end
      end
    end
  end
  local roleEquips = BagProxy.Instance.roleEquip:GetItems()
  local equipInfo
  for i = 1, #roleEquips do
    equipInfo = roleEquips[i].equipInfo
    if equipInfo then
      if valid_equippos_map then
        if valid_equippos_map[equipInfo.site[1]] and equipInfo:CanAncientUpgrade() then
          table.insert(result, roleEquips[i])
        end
      elseif equipInfo:CanAncientUpgrade() then
        table.insert(result, roleEquips[i])
      end
    end
  end
  local roleShadowEquips = BagProxy.Instance.shadowBagData:GetItems()
  for i = 1, #roleShadowEquips do
    equipInfo = roleShadowEquips[i].equipInfo
    if equipInfo then
      if valid_equippos_map then
        if valid_equippos_map[equipInfo.site[1]] and equipInfo:CanAncientUpgrade() then
          table.insert(result, roleShadowEquips[i])
        end
      elseif equipInfo:CanAncientUpgrade() then
        table.insert(result, roleShadowEquips[i])
      end
    end
  end
  local items = BagProxy.Instance:GetBagEquipTab():GetItems()
  for i = 1, #items do
    equipInfo = items[i].equipInfo
    if equipInfo then
      if valid_equippos_map then
        if valid_equippos_map[equipInfo.site[1]] and equipInfo:CanAncientUpgrade() then
          table.insert(result, items[i])
        end
      elseif equipInfo:CanAncientUpgrade() then
        table.insert(result, items[i])
      end
    end
  end
  BlackSmithProxy.SortEquips(result)
  return result
end

function BlackSmithProxy:GenerateDeductionMaterialInfo()
  if self.deductionMaterialInfo then
    return
  end
  self.deductionMaterialInfo = {}
  autoImport("Table_DeductionMaterial")
  for _, v in pairs(Table_DeductionMaterial) do
    for _, v2 in pairs(v.TargetItem) do
      if not self.deductionMaterialInfo[v2] then
        self.deductionMaterialInfo[v2] = {}
        table.insert(self.deductionMaterialInfo[v2], v.Deduction)
        table.insert(self.deductionMaterialInfo[v2], v.CostNum)
        table.insert(self.deductionMaterialInfo[v2], v.TargetNum)
      end
    end
  end
end

function BlackSmithProxy:TryGetDeductionMaterialInfo(targetItemId)
  self:GenerateDeductionMaterialInfo()
  local info = self.deductionMaterialInfo[targetItemId]
  if info then
    return unpack(info)
  end
end

function BlackSmithProxy:UpdateMaterialListUsingDeduction(mat_list, mat_bag_type)
  local new_mat_list = {}
  local dm_cnt_list = {}
  local dm_use_list = {}
  local dm_mat_ok = true
  for i = 1, #mat_list do
    local mat = {
      id = mat_list[i].id,
      num = mat_list[i].num
    }
    local skip_types = ItemData.CheckIsEquip(mat.id)
    local deduction, costNum, targetNum = self:TryGetDeductionMaterialInfo(mat.id)
    if not skip_types and deduction then
      if not dm_cnt_list[deduction] then
        dm_cnt_list[deduction] = BagProxy.Instance:GetItemNumByStaticID(deduction, mat_bag_type) or 0
        dm_use_list[deduction] = 0
      end
      local has_num = BagProxy.Instance:GetItemNumByStaticID(mat.id, mat_bag_type) or 0
      local need_dm_num = mat.num - has_num
      local avail_num = dm_cnt_list[deduction] - dm_use_list[deduction]
      if 0 < need_dm_num then
        if 0 < avail_num then
          local avail_times = math.floor(avail_num / costNum)
          local need_times = math.ceil(need_dm_num / targetNum)
          if 0 < avail_times then
            local real_times = math.min(avail_times, need_times)
            mat.ori_num = mat.num
            mat.deduction = deduction
            if avail_times >= need_times then
              mat.num = has_num
            else
              mat.num = mat.num - real_times * targetNum
              dm_mat_ok = false
            end
            mat.exchangenum = has_num + real_times * targetNum
            dm_use_list[deduction] = dm_use_list[deduction] + real_times * costNum
          else
            dm_mat_ok = false
          end
        else
          dm_mat_ok = false
        end
      end
    end
    table.insert(new_mat_list, mat)
  end
  local use_dm = false
  for k, v in pairs(dm_use_list) do
    if 0 < v then
      local mat = {id = k, num = v}
      table.insert(new_mat_list, mat)
      use_dm = true
    end
  end
  return new_mat_list, use_dm, dm_mat_ok, dm_use_list
end
