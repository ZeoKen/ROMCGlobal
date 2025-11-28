SimplePrayData = class("SimplePrayData")

function SimplePrayData:ctor(staticData)
  self.staticData = staticData
  self.id = staticData.id
  self.type = staticData.Type
  self.level = 0
end

function SimplePrayData:UpdateLv(v)
  self.level = v
  self.cost_money = math.floor(GuildFun.calcGuildPrayMon(self.id, self.level))
  self.cost_contribution = GuildFun.calcGuildPrayCon(self.id, self.level)
end

function SimplePrayData:IsMax()
  local uplv, base_lv, next_uplv = GuildPrayProxy.Instance:GetMaxConfigPrayLv(GuildCmd_pb.EPRAYTYPE_GODDESS)
  if uplv and uplv <= self.level then
    return true, base_lv, next_uplv
  end
  return false
end

local _GuildConfig = GameConfig.Guild
local _GuildCertificateZenyRate = _GuildConfig.praydeduction[2]
local _CalcGuildPrayAttr = GuildFun.calcGuildPrayAttr
local _CalcGuildPrayMon = GuildFun.calcGuildPrayMon
local _CalcGuildPrayCon = GuildFun.calcGuildPrayCon
local _Max_PrayCount = _GuildConfig.max_pray_count or 20
local _LangMgr = OverSea.LangManager.Instance()
local _Table_RoleData = Table_RoleData

function SimplePrayData:CalcMaxLv(useCertificate, useCostNum)
  local sData = self.staticData
  local nowLv, nextLv
  local nowBindContribute = MyselfProxy.Instance:GetBindContribution()
  local contribution = MyselfProxy.Instance:GetContribution()
  local ownContribute = contribution + nowBindContribute
  local ownSliver = MyselfProxy.Instance:GetROB()
  local attrNames = string.split(_LangMgr:GetLangByKey(sData.AttrName), ",")
  local args = {}
  args[1] = nil
  args[2] = {}
  args[3] = 0
  args[4] = 0
  args[5] = 0
  args[6] = 0
  args[7] = {}
  local upLv = GuildPrayProxy.Instance:GetMaxConfigPrayLv(GuildCmd_pb.EPRAYTYPE_GODDESS)
  local max_pray_count = math.min(upLv - self.level, _Max_PrayCount)
  for i = 1, max_pray_count do
    nowLv = self.level + i - 1
    nextLv = nowLv + 1
    local localArg1 = nextLv - self.level
    if i == 1 then
      args[5] = math.floor(_CalcGuildPrayMon(sData.id, nowLv))
      args[6] = _CalcGuildPrayCon(sData.id, nowLv)
    end
    local nowValueMap = _CalcGuildPrayAttr(sData.id, nowLv)
    local nextValueMap = _CalcGuildPrayAttr(sData.id, nextLv)
    local hasNext, _ = next(nextValueMap)
    if hasNext then
      if sData.AttrIds and sData.AttrName then
        for j = 1, #sData.AttrIds do
          local attrId = sData.AttrIds[j]
          local attrikey = _Table_RoleData[attrId].VarName
          local attriPro = UserProxy.Instance:GetPropVO(attrikey)
          local nextValue = nextValueMap[attrId] or 0
          local nowValue = nowValueMap[attrId] or 0
          local addvalue = nextValue - nowValue
          if attriPro.isPercent then
            addvalue = string.format("%s%%", addvalue * 100)
          end
          if i == 1 then
            args[7][attrNames[j]] = addvalue
          end
        end
      end
    else
      return args
    end
    local localArg3 = args[3] + math.floor(_CalcGuildPrayMon(sData.id, nowLv))
    local localArg4 = args[4] + _CalcGuildPrayCon(sData.id, nowLv)
    if ownContribute < localArg4 then
      return args
    end
    if useCertificate then
      if ownSliver < localArg3 - _GuildCertificateZenyRate * useCostNum then
        return args
      end
    elseif ownSliver < localArg3 then
      return args
    end
    args[1] = localArg1
    args[3] = localArg3
    args[4] = localArg4
    if sData.AttrIds and sData.AttrName then
      for j = 1, #sData.AttrIds do
        local attrId = sData.AttrIds[j]
        local attrikey = _Table_RoleData[attrId].VarName
        local attriPro = UserProxy.Instance:GetPropVO(attrikey)
        local nextValue = nextValueMap[attrId] or 0
        local nowValue = nowValueMap[attrId] or 0
        local addvalue = nextValue - nowValue
        if attriPro.isPercent then
          addvalue = string.format("%s%%", addvalue * 100)
        end
        local mapAddvalue = args[2][attrNames[j]]
        if not mapAddvalue then
          mapAddvalue = addvalue
          args[2][attrNames[j]] = mapAddvalue
        else
          args[2][attrNames[j]] = mapAddvalue + addvalue
        end
      end
    end
  end
  return args
end
