autoImport("SiteStrengthenData")
local _CostEquipStrength = CostUtil.CheckStrengthCost
local _CostMiyinStrengthZeny = CostUtil.CheckMiyinStrengthCost_Zeny
local _CostMiyinStrengthMiyin = CostUtil.CheckMiyinStrengthCost_Miyin
local ItemPB = SceneItem_pb
local T_NormalStrength = ItemPB.ESTRENGTHTYPE_NORMAL
local T_GuildStrength = ItemPB.ESTRENGTHTYPE_GUILD
local SiteIndex = {
  ItemPB.EEQUIPPOS_SHIELD,
  ItemPB.EEQUIPPOS_ARMOUR,
  ItemPB.EEQUIPPOS_ROBE,
  ItemPB.EEQUIPPOS_SHOES,
  ItemPB.EEQUIPPOS_ACCESSORY1,
  ItemPB.EEQUIPPOS_ACCESSORY2,
  ItemPB.EEQUIPPOS_WEAPON,
  ItemPB.EEQUIPPOS_HEAD,
  ItemPB.EEQUIPPOS_FACE,
  ItemPB.EEQUIPPOS_MOUTH,
  ItemPB.EEQUIPPOS_BACK,
  ItemPB.EEQUIPPOS_TAIL
}
local _miyinConfID = 5030
local _TableClear = TableUtility.TableClear
StrengthProxy = class("StrengthProxy", pm.Proxy)
StrengthProxy.Instance = nil
StrengthProxy.NAME = "StrengthProxy"
StrengthProxy.MaxPos = 12
StrengthProxy.Event_RefreshStrengthLv = "Event_RefreshStrengthLv"
local CheckEquipStrengthCost = function(site, lv)
  local _, need = _CostEquipStrength(site, lv)
  return math.floor(need)
end

function StrengthProxy.CheckEquipCost(lv, site)
  local need
  local myRob, rolelv = MyselfProxy.Instance:GetROB(), MyselfProxy.Instance:RoleLevel()
  local onNeed, maxNeed, maxLv = 0, 0, 0
  for i = 0, rolelv - lv - 1 do
    need = CheckEquipStrengthCost(site, lv + i)
    if i == 0 then
      onNeed = need
    end
    if myRob < maxNeed + need then
      break
    end
    maxNeed = maxNeed + need
    maxLv = maxLv + 1
  end
  return onNeed, maxNeed, maxLv
end

function StrengthProxy:SetPackageStrengthenShow(var)
  self.packageStrenghtenShow = var
end

function StrengthProxy:IsPackageStrengthenShow()
  return self.packageStrenghtenShow == true
end

function StrengthProxy.CheckMiyinCost(lv, site)
  local need
  local myRob, rolelv, myMiyin = MyselfProxy.Instance:GetROB(), MyselfProxy.Instance:RoleLevel(), BagProxy.Instance:GetItemNumByStaticID(_miyinConfID)
  local oneZeny, oneMiyin, maxZeny, maxMiyin, maxLv = 0, 0, 0, 0, 0
  local onZenyEnough, onNeedZeny = false, 0
  local onNeedMiyinEnough, onNeedMiyin = false, 0
  for i = 0, rolelv - lv - 1 do
    onZenyEnough, onNeedZeny = _CostMiyinStrengthZeny(site, lv + i)
    onNeedMiyin, onNeedMiyinEnough = _CostMiyinStrengthMiyin(site, lv + 1)
    if i == 0 then
      oneZeny = onNeedZeny
      oneMiyin = onNeedMiyinEnough
    end
    if not (onZenyEnough and onNeedMiyin) then
      break
    end
    maxZeny = maxZeny + onNeedZeny
    maxMiyin = maxMiyin + onNeedMiyinEnough
    maxLv = maxLv + 1
  end
  return oneZeny, oneMiyin, maxZeny, maxMiyin, maxLv
end

function StrengthProxy:IsCouldStrengthen(index)
  return nil ~= self.strengthMap[T_NormalStrength][index]
end

function StrengthProxy:ctor(proxyName, data)
  self.proxyName = proxyName or StrengthProxy.NAME
  if StrengthProxy.Instance == nil then
    StrengthProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function StrengthProxy:Init()
  self.strengthMap = {}
  local normalStrength = {}
  for i = 1, #SiteIndex do
    normalStrength[i] = SiteStrengthenData.new(T_NormalStrength, i, 0)
  end
  self.strengthMap[T_NormalStrength] = normalStrength
  local guildStrength = {}
  for i = 1, #SiteIndex do
    guildStrength[i] = SiteStrengthenData.new(T_GuildStrength, i, 0)
  end
  self.strengthMap[T_GuildStrength] = guildStrength
  self.guildStrengthSitesBaseOnBuilding = {}
  if Table_AccumulateStrengthReward then
    self.extraAttriList = {}
    for _, data in pairs(Table_AccumulateStrengthReward) do
      local d = {}
      d.level = data.Level
      d.buffs = data.BuffReward
      if d.buffs then
        local desc = ""
        local bufflen = #d.buffs
        for i = 1, bufflen do
          local buffData = Table_Buffer[d.buffs[i]]
          if buffData then
            desc = desc .. buffData.Dsc
            if i ~= bufflen then
              desc = desc .. "\n"
            end
          end
        end
        d.buffsDesc = desc
      end
      table.insert(self.extraAttriList, d)
    end
    table.sort(self.extraAttriList, function(a, b)
      return a.level < b.level
    end)
  end
end

function StrengthProxy:SetValidGuildStrengthSite(sites)
  _TableClear(self.guildStrengthSitesBaseOnBuilding)
  for i = 1, #sites do
    self.guildStrengthSitesBaseOnBuilding[sites[i]] = 1
  end
end

function StrengthProxy:GetFakeGuildStrengthItems()
  local guildStrengthData = self.strengthMap[T_GuildStrength]
  if not guildStrengthData then
    return
  end
  local fakeItems = {}
  for site, _ in pairs(self.guildStrengthSitesBaseOnBuilding) do
    local item = ItemData.new("guildStrengthItem" .. tostring(site), 100)
    item.site = site
    fakeItems[#fakeItems + 1] = item
  end
  return fakeItems
end

local sType, ePos, lv

function StrengthProxy:HandleSyncPosStrength(strengthDatas)
  for i = 1, #strengthDatas do
    sType = strengthDatas[i].type
    for j = 1, #strengthDatas[i].pos_data do
      ePos = strengthDatas[i].pos_data[j].epos
      lv = strengthDatas[i].pos_data[j].lv
      if ePos and lv and self.strengthMap[sType] and self.strengthMap[sType][ePos] then
        self.strengthMap[sType][ePos]:UpdateLv(lv)
      end
    end
  end
  if self.serverStrengthInited then
    GameFacade.Instance:sendNotification(ItemEvent.StrengthLvReinit)
  end
  self.serverStrengthInited = true
  self:RefreshMaxLevel()
end

function StrengthProxy:InitRoleBag()
  if self.roleBagInited then
    return
  end
  self.roleBagInited = true
  local _bagProxy = BagProxy.Instance
  local siteDatas = self.strengthMap[T_NormalStrength]
  for site, data in pairs(siteDatas) do
    _bagProxy.roleEquip:UpdateStrengthLv(T_NormalStrength, site, data.lv)
  end
end

function StrengthProxy:ResetStrengthType(t)
  if t ~= self.curType then
    self.curType = t
  end
end

function StrengthProxy:DoStrenghten(pos, destcount)
  local t = self.curType
  if not t then
    return
  end
  if not destcount then
    return
  end
  ServiceItemProxy.Instance:CallPosStrengthItemCmd(pos, t, destcount)
end

function StrengthProxy:HandleUpdatePosStrength(data)
  TableUtil.Print(data)
  local t, p, lv = data.type, data.epos, data.newlv
  if not (t and p) or not lv then
    return
  end
  if not self.strengthMap[t] then
    return
  end
  local oldSite = self.strengthMap[t][p]
  if not oldSite then
    return
  end
  local success = lv > oldSite.lv
  if success then
    oldSite:UpdateLv(lv)
    BagProxy.Instance.roleEquip:UpdateStrengthLv(t, p, lv)
  else
    redlog("强化失败，类型 ： ", t)
  end
  self:RefreshMaxLevel()
end

function StrengthProxy:MaxStrengthLevel(t)
  if t == T_NormalStrength or t == nil then
    return MyselfProxy.Instance:RoleLevel()
  elseif t == T_GuildStrength then
    return GuildBuildingProxy.Instance:GetStrengthMaxLvl()
  end
end

function StrengthProxy:GetStrengthenData(t, p)
  return t and p and self.strengthMap[t] and self.strengthMap[t][p] or nil
end

function StrengthProxy:GetStrengthLvByPos(t, p)
  local data = self:GetStrengthenData(t, p)
  if data then
    return data:GetLv()
  end
  return 0
end

function StrengthProxy:GetEquipStrengthInfoByPlayer(playerId, itemData, newLineChar)
  if itemData then
    local sData = self:GetStrengthenData(T_NormalStrength, itemData.index)
    if sData then
      playerId = playerId or Game.Myself.data.id
      local player = SceneCreatureProxy.FindCreature(playerId)
      if player then
        local withLimitBuffUpLv, withoutLimitBuffUpLv = itemData:GetStrengthBuffUpLevel(playerId)
        local newLv, maxLv = BlackSmithProxy.CalculateBuffUpLevel(itemData.equipInfo.strengthlv, player.data.userdata:Get(UDEnum.ROLELEVEL), withLimitBuffUpLv, withoutLimitBuffUpLv)
        return StrengthProxy.GetEquipStrengthInfo(sData, itemData.staticData.id, newLv, maxLv, newLineChar), newLv, maxLv
      end
    end
  end
end

function StrengthProxy.GetEquipStrengthInfo(strengthenData, equipId, newLv, newMaxLv, newLineChar)
  if not strengthenData then
    return ""
  end
  local effectAdd = Table_Equip[equipId] and Table_Equip[equipId].EffectAdd
  local result = ReusableTable.CreateArray()
  if effectAdd then
    newMaxLv = newMaxLv or 0
    newLv = math.min(newLv or 0, newMaxLv)
    if 0 < newLv or 0 < newMaxLv then
      strengthenData = strengthenData:Clone()
      if 0 < newMaxLv then
        strengthenData:SetMaxLevel(newMaxLv)
      end
      if 0 < newLv then
        strengthenData:UpdateLv(newLv)
      end
    end
    local siteAttrsMap = strengthenData.attrsMap
    if siteAttrsMap then
      local _roleDataCfg = Table_RoleData
      for roleDataID, value in pairs(siteAttrsMap) do
        local varName = _roleDataCfg[roleDataID] and _roleDataCfg[roleDataID].VarName
        if varName and effectAdd[varName] then
          table.insert(result, {name = varName, value = value})
        end
      end
    end
  end
  local s = PropUtil.FormatEffects(result, 1, " +", newLineChar)
  ReusableTable.DestroyAndClearArray(result)
  StrengthProxy.Instance:RefreshMaxLevel()
  return s
end

function StrengthProxy:RefreshMaxLevel()
  self.maxLv = 0
  for _, d in pairs(self.strengthMap[T_NormalStrength]) do
    if d.lv then
      self.maxLv = self.maxLv + d.lv
    end
  end
  EventManager.Me():DispatchEvent(StrengthProxy.Event_RefreshStrengthLv)
end

function StrengthProxy:GetMaxLevel()
  return self.maxLv
end

function StrengthProxy:GetExtraAttriList()
  return self.extraAttriList
end
