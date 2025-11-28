GuildFun = {}

function GuildFun.calcGuildPrayCon(prayid, praylv)
  local cfg = Table_Guild_Faith[prayid]
  if cfg == nil then
    return 0
  end
  if praylv <= 10 then
    return math.floor(34)
  elseif praylv <= 20 and 10 < praylv then
    return math.floor(36)
  elseif praylv <= 30 and 20 < praylv then
    return math.floor(42)
  elseif praylv <= 40 and 30 < praylv then
    return math.floor(80)
  elseif praylv <= 50 and 40 < praylv then
    return math.floor(152)
  elseif praylv <= 60 and 50 < praylv then
    return math.floor(284)
  elseif praylv <= 70 and 60 < praylv then
    return math.floor(450)
  elseif praylv <= 80 and 70 < praylv then
    return math.floor(588)
  elseif praylv <= 150 and 80 < praylv then
    return math.floor(728)
  else
    return math.floor(1000)
  end
end

function GuildFun.calcGuildPrayMon(prayid, praylv)
  local cfg = Table_Guild_Faith[prayid]
  if cfg == nil then
    return 0
  end
  local a1 = praylv % 10
  local b1 = GameConfig.GuildPray.Remainder[a1]
  local a2 = math.floor(praylv / 10)
  local b2 = GameConfig.GuildPray.Quotient[a2]
  local result = GameConfig.GuildPray.BaseCost * b1 * b2
  result = result - result % 10
  return result
end

function GuildFun.calcGuildPrayAttr(prayid, praylv)
  local result = {}
  if 0 <= praylv and praylv <= 10 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 10 * praylv
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 0.4 * praylv
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 0.4 * praylv
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 0.2 * praylv
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 20 * praylv
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 0.2 * praylv
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 20 * praylv
    end
  elseif 11 <= praylv and praylv <= 20 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 100 + 18 * (praylv - 10)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 4 + 0.7 * (praylv - 10)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 4 + 0.7 * (praylv - 10)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 2 + 0.4 * (praylv - 10)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 200 + 40 * (praylv - 10)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 2 + 0.4 * (praylv - 10)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 200 + 40 * (praylv - 10)
    end
  elseif 21 <= praylv and praylv <= 30 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 280 + 28 * (praylv - 20)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 11 + 1.1 * (praylv - 20)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 11 + 1.1 * (praylv - 20)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 6 + 0.5 * (praylv - 20)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 600 + 50 * (praylv - 20)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 6 + 0.5 * (praylv - 20)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 600 + 50 * (praylv - 20)
    end
  elseif 31 <= praylv and praylv <= 40 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 560 + 38 * (praylv - 30)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 22 + 1.5 * (praylv - 30)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 22 + 1.5 * (praylv - 30)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 11 + 0.7 * (praylv - 30)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 1100 + 70 * (praylv - 30)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 11 + 0.7 * (praylv - 30)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 1100 + 70 * (praylv - 30)
    end
  elseif 41 <= praylv and praylv <= 50 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 940 + 45 * (praylv - 40)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 37 + 1.8 * (praylv - 40)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 37 + 1.8 * (praylv - 40)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 18 + 0.9 * (praylv - 40)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 1800 + 90 * (praylv - 40)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 18 + 0.9 * (praylv - 40)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 1800 + 90 * (praylv - 40)
    end
  elseif 51 <= praylv and praylv <= 60 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 1390 + 55 * (praylv - 50)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 55 + 2.2 * (praylv - 50)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 55 + 2.2 * (praylv - 50)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 27 + 1.1 * (praylv - 50)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 2700 + 110 * (praylv - 50)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 27 + 1.1 * (praylv - 50)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 2700 + 110 * (praylv - 50)
    end
  elseif 61 <= praylv and praylv <= 70 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 1940 + 63 * (praylv - 60)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 77 + 2.5 * (praylv - 60)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 77 + 2.5 * (praylv - 60)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 38 + 1.3 * (praylv - 60)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 3800 + 130 * (praylv - 60)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 38 + 1.3 * (praylv - 60)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 3800 + 130 * (praylv - 60)
    end
  elseif 71 <= praylv and praylv <= 80 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 2570 + 73 * (praylv - 70)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 102 + 2.9 * (praylv - 70)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 102 + 2.9 * (praylv - 70)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 51 + 1.5 * (praylv - 70)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 5100 + 150 * (praylv - 70)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 51 + 1.5 * (praylv - 70)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 5100 + 150 * (praylv - 70)
    end
  elseif 81 <= praylv and praylv <= 90 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 3300 + 83 * (praylv - 80)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 131 + 3.3 * (praylv - 80)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 131 + 3.3 * (praylv - 80)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 66 + 1.6 * (praylv - 80)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 6600 + 160 * (praylv - 80)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 66 + 1.6 * (praylv - 80)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 6600 + 160 * (praylv - 80)
    end
  elseif 91 <= praylv and praylv <= 100 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 4130 + 90 * (praylv - 90)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 164 + 3.6 * (praylv - 90)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 164 + 3.6 * (praylv - 90)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 82 + 1.8 * (praylv - 90)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 8200 + 180 * (praylv - 90)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 82 + 1.8 * (praylv - 90)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 8200 + 180 * (praylv - 90)
    end
  elseif 101 <= praylv and praylv <= 110 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 5030 + 100 * (praylv - 100)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 200 + 4 * (praylv - 100)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 200 + 4 * (praylv - 100)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 100 + 2 * (praylv - 100)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 10000 + 200 * (praylv - 100)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 100 + 2 * (praylv - 100)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 10000 + 200 * (praylv - 100)
    end
  elseif 111 <= praylv and praylv <= 120 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 6030 + 112 * (praylv - 110)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 240 + 4.5 * (praylv - 110)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 240 + 4.5 * (praylv - 110)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 120 + 2.2 * (praylv - 110)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 12000 + 220 * (praylv - 110)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 120 + 2.2 * (praylv - 110)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 12000 + 220 * (praylv - 110)
    end
  elseif 121 <= praylv and praylv <= 130 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 7150 + 125 * (praylv - 120)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 285 + 5 * (praylv - 120)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 285 + 5 * (praylv - 120)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 142 + 2.5 * (praylv - 120)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 14200 + 250 * (praylv - 120)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 142 + 2.5 * (praylv - 120)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 14200 + 250 * (praylv - 120)
    end
  elseif 131 <= praylv and praylv <= 140 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 8400 + 138 * (praylv - 130)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 335 + 5.5 * (praylv - 130)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 335 + 5.5 * (praylv - 130)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 167 + 2.8 * (praylv - 130)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 16700 + 280 * (praylv - 130)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 167 + 2.8 * (praylv - 130)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 16700 + 280 * (praylv - 130)
    end
  elseif 141 <= praylv and praylv <= 150 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 9780 + 150 * (praylv - 140)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 390 + 6 * (praylv - 140)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 390 + 6 * (praylv - 140)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 195 + 3 * (praylv - 140)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 19500 + 300 * (praylv - 140)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 195 + 3 * (praylv - 140)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 19500 + 300 * (praylv - 140)
    end
  elseif 151 <= praylv and praylv <= 160 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 11280 + 175 * (praylv - 150)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 450 + 7 * (praylv - 150)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 450 + 7 * (praylv - 150)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 225 + 3.5 * (praylv - 150)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 22500 + 350 * (praylv - 150)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 225 + 3.5 * (praylv - 150)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 22500 + 350 * (praylv - 150)
    end
  elseif 161 <= praylv and praylv <= 170 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 13030 + 187.5 * (praylv - 160)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 520 + 7.5 * (praylv - 160)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 520 + 7.5 * (praylv - 160)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 260 + 3.8 * (praylv - 160)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 26000 + 380 * (praylv - 160)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 260 + 3.8 * (praylv - 160)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 26000 + 380 * (praylv - 160)
    end
  elseif 171 <= praylv and praylv <= 180 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 14905 + 200 * (praylv - 170)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 595 + 8 * (praylv - 170)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 595 + 8 * (praylv - 170)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 298 + 4 * (praylv - 170)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 29800 + 400 * (praylv - 170)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 298 + 4 * (praylv - 170)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 29800 + 400 * (praylv - 170)
    end
  elseif 181 <= praylv and praylv <= 190 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 16905 + 212.5 * (praylv - 180)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 675 + 8.5 * (praylv - 180)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 675 + 8.5 * (praylv - 180)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 338 + 4.2 * (praylv - 180)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 33800 + 420 * (praylv - 180)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 338 + 4.2 * (praylv - 180)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 33800 + 420 * (praylv - 180)
    end
  elseif 191 <= praylv and praylv <= 200 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 19030 + 225 * (praylv - 190)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 760 + 9 * (praylv - 190)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 760 + 9 * (praylv - 190)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 380 + 4.5 * (praylv - 190)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 38000 + 450 * (praylv - 190)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 380 + 4.5 * (praylv - 190)
      result[CommonFun.RoleData.EATTRTYPE_BASEHP] = 38000 + 450 * (praylv - 190)
    end
  end
  return result
end
