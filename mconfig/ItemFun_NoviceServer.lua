ItemFun = {}

function ItemFun.calcStrengthCost(type, lv)
  local cost = {}
  local Ten, Bits = 0
  local costMoneyLvRatio = {
    [1] = 0.091,
    [2] = 0.093,
    [3] = 0.095,
    [4] = 0.097,
    [5] = 0.099,
    [6] = 0.101,
    [7] = 0.103,
    [8] = 0.105,
    [9] = 0.107,
    [0] = 0.109
  }
  local costMoneyMax = {
    [10] = 26510.84,
    [20] = 42417.34571,
    [30] = 79532.52,
    [40] = 116647.6971,
    [50] = 159065.04,
    [60] = 265108.4,
    [70] = 371151.76,
    [80] = 530216.8,
    [90] = 795325.2,
    [100] = 1060433.6
  }
  local costMoneyTypeRatio = {
    [1] = 1,
    [2] = 1,
    [3] = 0.8,
    [4] = 0.8
  }
  local costMoneyRatio = {
    [10] = 1,
    [20] = 1.15,
    [30] = 1.3,
    [40] = 1.5,
    [50] = 1.7,
    [60] = 2.5,
    [70] = 3.1,
    [80] = 2.5,
    [90] = 2.8,
    [100] = 3.15
  }
  if type == 0 or lv == nil or type == nil then
    cost[100] = 99999999
    cost[5030] = 99999999
    return cost
  end
  Bits = tonumber(string.sub(lv, string.len(lv), string.len(lv)))
  if lv <= 10 then
    Ten = 10
  else
    Ten = tonumber(string.sub(lv, 1, string.len(lv) - 1))
    if Bits == 0 then
      Ten = Ten * 10
    else
      Ten = Ten * 10 + 10
    end
  end
  if costMoneyMax[Ten] == nil or costMoneyLvRatio[Bits] == nil or costMoneyTypeRatio[type] == nil or costMoneyRatio[Ten] == nil then
    cost[100] = 99999999
  else
    local MoneyMax = costMoneyMax[Ten]
    local LvRatio = costMoneyLvRatio[Bits]
    local MoneyTypeRatio = costMoneyTypeRatio[type]
    local MoneyRatio = costMoneyRatio[Ten]
    costMoney = MoneyMax * LvRatio * MoneyTypeRatio * MoneyRatio
    if 0 >= costMoney then
      cost[100] = 0
    else
      cost[100] = math.ceil(costMoney)
    end
  end
  local costItem = 0
  local costItemNum = {
    [10] = 1,
    [20] = 1.5,
    [30] = 2,
    [40] = 2.5,
    [50] = 3,
    [60] = 3.5,
    [70] = 4,
    [80] = 4.5,
    [90] = 5,
    [100] = 5.5
  }
  local costItemTypeRatio = {
    [1] = 1.5,
    [2] = 1.5,
    [3] = 1,
    [4] = 1
  }
  local costItemRatio = {
    [10] = 1,
    [20] = 1.15,
    [30] = 1.3,
    [40] = 1.5,
    [50] = 1.7,
    [60] = 2.5,
    [70] = 3.1,
    [80] = 2.5,
    [90] = 2.8,
    [100] = 3.15
  }
  if costItemNum[Ten] == nil or costItemTypeRatio[type] == nil or costItemRatio[Ten] == nil then
    cost[5030] = 99999999
  else
    local ItemNum = costItemNum[Ten]
    local ItemTypeRatio = costItemTypeRatio[type]
    local ItemRatio = costItemRatio[Ten]
    costItem = ItemNum * ItemTypeRatio * ItemRatio
    if costItem <= 0 then
      cost[5030] = 0
    else
      cost[5030] = math.floor(costItem + 0.5)
    end
  end
  return cost
end

function ItemFun.calcStrengthAttr(type, lv)
  local result = {}
  if lv <= 0 then
    result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 0
    return result
  end
  local hp = 6000
  local a = 10
  local b = 2
  local c = 4
  local d = 400
  local lv10 = 0
  if 1 <= lv and lv <= 10 then
    lv10 = 0
  elseif 11 <= lv and lv <= 20 then
    lv10 = 4
  elseif 21 <= lv and lv <= 30 then
    lv10 = 10
  elseif 31 <= lv and lv <= 40 then
    lv10 = 18
  elseif 41 <= lv and lv <= 50 then
    lv10 = 28
  elseif 51 <= lv and lv <= 60 then
    lv10 = 40
  elseif 61 <= lv and lv <= 70 then
    lv10 = 57.78
  end
  local adjust = 1
  if 1 <= lv and lv <= 10 then
    adjust = 1
  elseif 11 <= lv and lv <= 20 then
    adjust = 1
  elseif 21 <= lv and lv <= 30 then
    adjust = 1
  elseif 31 <= lv and lv <= 40 then
    adjust = 1
  elseif 41 <= lv and lv <= 50 then
    adjust = 1
  elseif 51 <= lv and lv <= 60 then
    adjust = 1.27
  elseif 61 <= lv and lv <= 70 then
    adjust = 1.39
  end
  local eparam = {
    [1] = 0.3,
    [2] = 0.3,
    [3] = 0.2,
    [4] = 0.2
  }
  local qvalue = 1
  local evalue = eparam[type]
  if qvalue == nil or evalue == nil then
    return result
  end
  local tmp = (lv - 1) % 10
  local tmp1 = math.floor((lv - 1) / a)
  local maxhp = math.floor(((tmp + 1) * (tmp1 * b + c) * adjust + lv10 * 10) * hp * qvalue * evalue / d)
  result[CommonFun.RoleData.EATTRTYPE_MAXHP] = maxhp
  return result
end

function ItemFun.canQuickSell(id)
  local item_cfg = Table_Item[id]
  local equip_cfg = Table_Equip[id]
  local exchange_cfg = Table_Exchange[id]
  if item_cfg == nil then
    return false
  end
  if item_cfg.Type == 96 and item_cfg.Quality ~= 5 then
    return true
  end
  if equip_cfg == nil or exchange_cfg ~= nil then
    return false
  end
  if item_cfg.Type == 65 then
    return false
  end
  if item_cfg.Quality ~= 1 then
    return false
  end
  if item_cfg.Level == nil or item_cfg.Level <= 0 then
    return false
  end
  if item_cfg.AuctionPrice == 1 then
    return false
  end
  return true
end

function ItemFun.canAutoSell(id, source)
  if source == 19 or source == 25 or source == 194 then
    return false
  end
  return ItemFun.canQuickSell(id)
end

function ItemFun.favoriteCheck(limit, itemid, itemtype)
  if itemid == 25102 or itemid == 25107 then
    return false
  end
  if limit == 1 then
    return true
  elseif limit == 2 then
    local invalid = {
      81,
      82,
      83,
      84,
      85,
      86,
      87,
      170,
      180,
      190,
      200,
      210,
      220,
      230,
      240,
      250,
      260,
      270,
      280,
      290,
      300,
      310,
      320,
      500,
      501,
      510,
      520,
      530,
      540,
      511,
      512,
      513,
      514,
      800,
      810,
      820,
      821,
      822,
      823,
      825,
      826,
      830,
      840,
      850
    }
    for k, v in pairs(invalid) do
      if itemtype == v then
        return true
      end
    end
    return false
  elseif limit == 3 then
    return true
  elseif limit == 4 then
    return true
  end
  return false
end

function ItemFun.oldItemExchange(cost_itemid, cost_count)
  if cost_itemid == 12903 then
    local getid = 12382
    return getid, math.ceil(cost_count / 200)
  end
end

local _CheckSpiritType_1or2 = function(id)
  local staticEquip = Table_Equip[id]
  if staticEquip then
    return staticEquip.SpiritType == 1 or staticEquip.SpiritType == 2
  end
  return false
end
local _CheckEquipIsNew = function(id)
  local staticEquip = Table_Equip[id]
  return nil ~= staticEquip and staticEquip.IsNew == 1
end
local _CheckEquipIsNotNew = function(id)
  local staticEquip = Table_Equip[id]
  return nil ~= staticEquip and staticEquip.IsNew ~= 1
end
local _CheckIsEquipCompose = function(id)
  return nil ~= Table_EquipCompose[id]
end

function ItemFun.CheckPutOnEquip(main_equip_id, shadow_equip_id)
  shadow_equip_id = shadow_equip_id or 0
  if shadow_equip_id == 0 then
    return 0
  end
  if _CheckIsEquipCompose(shadow_equip_id) then
    if _CheckEquipIsNew(main_equip_id) then
      return 0
    else
      return 43357
    end
  end
  if _CheckSpiritType_1or2(shadow_equip_id) then
    if _CheckEquipIsNotNew(main_equip_id) then
      return 0
    else
      return 43358
    end
  end
end

function ItemFun.CheckPutOnViceEquip(shadow_equip_id, main_equip_id)
  main_equip_id = main_equip_id or 0
  if main_equip_id == 0 then
    if _CheckIsEquipCompose(shadow_equip_id) or _CheckSpiritType_1or2(shadow_equip_id) then
      return 0
    else
      return 43359
    end
  end
  if _CheckEquipIsNew(main_equip_id) then
    if _CheckIsEquipCompose(shadow_equip_id) then
      return 0
    else
      return 43360
    end
  elseif _CheckSpiritType_1or2(shadow_equip_id) then
    return 0
  else
    return 43361
  end
end

ItemFun.checkFuncByPackageType = {
  [CommonFun.PackType.EPACKTYPE_EQUIP] = ItemFun.CheckPutOnEquip,
  [CommonFun.PackType.EPACKTYPE_SHADOWEQUIP] = ItemFun.CheckPutOnViceEquip
}

function ItemFun.CheckMappingEquipValid(package_type, id, mapping_id)
  local func = ItemFun.checkFuncByPackageType[package_type]
  if func then
    return func(id, mapping_id)
  end
  return -1
end

ItemFun.max_refine_lv = 15

function ItemFun.calcRealShadowRefineLv(equip_refinelv, shadow_refinelv, shadow_quench)
  if equip_refinelv > ItemFun.max_refine_lv then
    equip_refinelv = ItemFun.max_refine_lv
  end
  if shadow_refinelv > ItemFun.max_refine_lv then
    shadow_refinelv = ItemFun.max_refine_lv
  end
  if 100 < shadow_quench then
    shadow_quench = 100
  end
  local total_refinelv = equip_refinelv + shadow_refinelv * shadow_quench / 100
  if total_refinelv < ItemFun.max_refine_lv then
    return shadow_refinelv
  end
  return ItemFun.max_refine_lv - equip_refinelv
end

function ItemFun.calcExtraRefineLvToBaseHp(pos, equip_refinelv, shadow_refinelv, shadow_quench)
  if pos ~= CommonFun.EquipPos.EEQUIPPOS_SHIELD and pos ~= CommonFun.EquipPos.EEQUIPPOS_ARMOUR and pos ~= CommonFun.EquipPos.EEQUIPPOS_ROBE and pos ~= CommonFun.EquipPos.EEQUIPPOS_SHOES then
    return 0.0
  end
  local real_shadow_refinelv = ItemFun.calcRealShadowRefineLv(equip_refinelv, shadow_refinelv, shadow_quench)
  if shadow_refinelv <= real_shadow_refinelv then
    return 0.0
  end
  local extra_shadow_refinelv = shadow_refinelv - real_shadow_refinelv
  local refinelv_to_basehp = 4000
  return extra_shadow_refinelv * refinelv_to_basehp
end

function ItemFun.calcMvpCardDecomposeExtraCrystalCountAndRate(cardid, lv)
  if Table_Card == nil or Table_CardLevel == nil then
    return 0, 0
  end
  local cardcfg = Table_Card[cardid]
  if not cardcfg or not cardcfg.MVPCardDecompose then
    return 0, 0
  end
  local CRYSTAL_ID = 52838
  local card_count = cardcfg.MVPCardDecompose
  local stat_count = 0
  for _, cfg in pairs(Table_CardLevel) do
    if cfg.CardID and cfg.CardID == cardid and (not cfg.Level or not (lv < cfg.Level)) and cfg.Cost then
      for _, item in pairs(cfg.Cost) do
        if item[1] ~= nil and item[2] ~= nil and item[1] == cardid then
          stat_count = stat_count + card_count * item[2]
        end
        if item[1] ~= nil and item[2] ~= nil and item[1] == CRYSTAL_ID then
          stat_count = stat_count + item[2]
        end
      end
    end
  end
  local integer = math.floor(stat_count / 4)
  local decimal = math.floor((stat_count / 4 - integer) * 100)
  return card_count + integer, decimal
end
