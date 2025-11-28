AfkProxy = class("AfkProxy", pm.Proxy)
AfkProxy.Instance = nil
AfkProxy.Name = "AfkProxy"
AfkEvent = {
  SyncAfkStatus = "SyncAfkStatus"
}
BattleTimeStringFormats = {
  "[41c419]%s[-]",
  "[ffc945]%s[-]",
  "[cf1c0f]%s[-]"
}
local emptyTable = {}
local _Table_Monster
local _TableMonster = function(id)
  if not _Table_Monster then
    autoImport("Table_Monster")
    _Table_Monster = Table_Monster
  end
  return _Table_Monster[id]
end

function AfkProxy:ctor(proxyName, data)
  self.proxyName = proxyName or AfkProxy.Name
  if AfkProxy.Instance == nil then
    AfkProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function AfkProxy.ParseIsAfk(val)
  return val and val ~= 0
end

function AfkProxy:IsAfkEnabled()
  return not GameConfig.SystemForbid.Afk
end

function AfkProxy:Init()
  self.isAfk = false
end

function AfkProxy:GetAfkTimeMsg(afkTime, kill_count, left_afk_count)
  local msgConf = Table_Sysmsg[41151]
  if not ISNoviceServerType then
    return string.format(OverSea.LangManager.Instance():GetLangByKey(msgConf and msgConf.Text or ZhString.Afk_DurationMsg), afkTime or 0)
  else
    return string.format(OverSea.LangManager.Instance():GetLangByKey(msgConf and msgConf.Text or ZhString.Afk_DurationMsg), afkTime or 0, kill_count or 0, left_afk_count or 0)
  end
end

function AfkProxy:GetAfkExpMsg(baseExp, jobExp)
  local msgConf = Table_Sysmsg[41154]
  return string.format(OverSea.LangManager.Instance():GetLangByKey(msgConf and msgConf.Text or ZhString.Afk_RewardExpMsg), baseExp or 0, jobExp or 0)
end

function AfkProxy:GetAfkZenyMsg(zeny)
  local msgConf = Table_Sysmsg[41153]
  return string.format(OverSea.LangManager.Instance():GetLangByKey(msgConf and msgConf.Text or ZhString.Afk_RewardZenyMsg), zeny or 0)
end

function AfkProxy:GetAfkItemMsg(item)
  if item then
    local msgConf = Table_Sysmsg[41152]
    local itemId = item.id
    local itemConfig = Table_Item[itemId]
    if itemConfig then
      local itemName = OverSea.LangManager.Instance():GetLangByKey(itemConfig.NameZh or "")
      return string.format(OverSea.LangManager.Instance():GetLangByKey(msgConf and msgConf.Text or ZhString.Afk_RewardItemMsg), itemName, item.count or 0)
    end
  end
  return nil
end

function AfkProxy:GetAfkLastMinItemMsg(item)
  if item then
    local msgConf = Table_Sysmsg[41161]
    local itemId = item.id
    local itemConfig = Table_Item[itemId]
    if itemConfig then
      local itemName = OverSea.LangManager.Instance():GetLangByKey(itemConfig.NameZh or "")
      return string.format(OverSea.LangManager.Instance():GetLangByKey(msgConf and msgConf.Text or ZhString.Afk_LastMinRewardItemMsg), itemName, item.count or 0)
    end
  end
  return nil
end

function AfkProxy:GetAfkBeKillMsg(killInfo)
  if killInfo then
    local msgConf = Table_Sysmsg[41157]
    local monsterId = killInfo.monsterid
    local config = _TableMonster(monsterId)
    if config then
      local name = OverSea.LangManager.Instance():GetLangByKey(config.NameZh or "")
      return string.format(OverSea.LangManager.Instance():GetLangByKey(msgConf and msgConf.Text or ZhString.Afk_BeKillMsg), name)
    end
  end
  return nil
end

function AfkProxy:GetAfkKillMsg(killInfo)
  if killInfo then
    local msgConf = Table_Sysmsg[41158]
    local monsterId = killInfo.monsterid
    local config = _TableMonster(monsterId)
    if config then
      local name = OverSea.LangManager.Instance():GetLangByKey(config.NameZh or "")
      return string.format(OverSea.LangManager.Instance():GetLangByKey(msgConf and msgConf.Text or ZhString.Afk_KillMsg), name, killInfo.count or 0)
    end
  end
  return nil
end

function AfkProxy:GetAfkLastMinKillMsg(killInfo)
  if killInfo then
    local msgConf = Table_Sysmsg[41160]
    local monsterId = killInfo.monsterid
    local config = _TableMonster(monsterId)
    if config then
      local name = OverSea.LangManager.Instance():GetLangByKey(config.NameZh or "")
      return string.format(OverSea.LangManager.Instance():GetLangByKey(msgConf and msgConf.Text or ZhString.Afk_LastMinKillMsg), name, killInfo.count or 0)
    end
  end
  return nil
end

function AfkProxy:GetAfkStatusMsg(status)
  if status and 0 < status and GameConfig.Afk.quit_reasons then
    local fmt = GameConfig.Afk.quit_reasons[status]
    if fmt then
      local param
      if status == UserAfkCmd_pb.EAFKSTATUS_NOBATTLE_EXIT then
        param = GameConfig.Afk.no_battle_time
      end
      if param then
        return string.format(fmt, param)
      else
        return fmt
      end
    end
  end
  return nil
end

function AfkProxy:GetBattleTimeMsg(data)
  if not ISNoviceServerType and data and data.totaltime and data.totaltime > 0 then
    local timeLen = 0
    local timeTotal = 0
    local color = 1
    if data.usedtime then
      timeLen = math.floor(data.usedtime / 60)
    end
    if data.totaltime then
      timeTotal = math.floor(data.totaltime / 60)
    end
    if data.estatus then
      color = data.estatus
    end
    local str = string.format(BattleTimeStringFormats[color], timeLen)
    str = string.format(ZhString.Set_AfkGameTime, str, timeTotal)
    return str
  end
  return nil
end

function AfkProxy:GetAfkMsgArray(tb, data)
  local ArrayPushBack = TableUtility.ArrayPushBack
  local body = data and data.body or data
  if not body then
    return false
  end
  if not body.charid or body.charid == 0 then
    return false
  end
  local statdata = body.statdata or {}
  local quitAfk = statdata.estatus and 0 < statdata.estatus and true or false
  if statdata.estatus and 0 < statdata.estatus then
    local msg = self:GetAfkStatusMsg(statdata.estatus)
    if msg then
      ArrayPushBack(tb, msg)
    end
  end
  if statdata.battle_time then
    local msg = self:GetBattleTimeMsg(statdata.battle_time)
    if msg then
      ArrayPushBack(tb, msg)
    end
  end
  local afkTime = statdata.timelen and 0 < statdata.timelen and math.floor(statdata.timelen / 60) or 0
  ArrayPushBack(tb, self:GetAfkTimeMsg(afkTime, statdata.kill_count, statdata.left_afk_count))
  local baseExp = statdata.baseexp or 0
  local jobExp = statdata.jobexp or 0
  if 0 < baseExp or 0 < jobExp then
    ArrayPushBack(tb, self:GetAfkExpMsg(baseExp, jobExp))
  end
  local zeny = 0
  if statdata.moneys then
    for _, v in pairs(statdata.moneys) do
      if v.etype == ProtoCommon_pb.EMONEYTYPE_SILVER then
        zeny = v.value or 0
        break
      end
    end
  end
  if 0 < zeny then
    ArrayPushBack(tb, self:GetAfkZenyMsg(zeny))
  end
  if not quitAfk then
    if statdata.be_killinfo then
      for _, v in pairs(statdata.be_killinfo) do
        local msg = self:GetAfkBeKillMsg(v)
        if msg then
          ArrayPushBack(tb, msg)
        end
      end
    end
    if statdata.killinfo then
      for _, v in pairs(statdata.killinfo) do
        local msg = self:GetAfkLastMinKillMsg(v)
        if msg then
          ArrayPushBack(tb, msg)
        end
      end
    end
  end
  local items = statdata.items
  if items then
    for _, item in pairs(items) do
      if item and item.id ~= 100 then
        local msg = self:GetAfkLastMinItemMsg(item)
        if msg then
          ArrayPushBack(tb, msg)
        end
      end
    end
  end
  return true
end

function AfkProxy:ShowAfkMsgInSystemChat(data)
  local body = data and data.body or data
  if not body or not body.statdata then
    return false
  end
  local statdata = body.statdata
  local baseExp = statdata.baseexp or 0
  local jobExp = statdata.jobexp or 0
  if 0 < baseExp or 0 < jobExp then
    MsgManager.ShowMsgByIDTable(41154, {baseExp, jobExp})
  end
  local zeny = 0
  if statdata.moneys then
    for _, v in pairs(statdata.moneys) do
      if v.etype == ProtoCommon_pb.EMONEYTYPE_SILVER then
        zeny = v.value or 0
        break
      end
    end
  end
  if 0 < zeny then
    MsgManager.ShowMsgByIDTable(41153, {zeny})
  end
  local beKillInfo = statdata.be_killinfo
  if beKillInfo then
    for _, info in pairs(beKillInfo) do
      if info.monsterid then
        local config = _TableMonster(info.monsterid)
        if config then
          local name = OverSea.LangManager.Instance():GetLangByKey(config.NameZh or "")
          MsgManager.ShowMsgByIDTable(41157, {name})
        end
      end
    end
  end
  local killInfo = statdata.killInfo
  if killInfo then
    for _, info in pairs(killInfo) do
      if info.monsterid then
        local config = _TableMonster(info.monsterid)
        if config then
          local name = OverSea.LangManager.Instance():GetLangByKey(config.NameZh or "")
          MsgManager.ShowMsgByIDTable(41158, {
            name,
            info.count or 0
          })
        end
      end
    end
  end
  local items = statdata.items
  if items then
    for _, item in ipairs(items) do
      if item.id and item.id ~= 100 then
        local itemConfig = Table_Item[item.id]
        if itemConfig then
          local itemName = OverSea.LangManager.Instance():GetLangByKey(itemConfig.NameZh or "")
          MsgManager.ShowMsgByIDTable(41152, {
            itemName,
            item.count or 0
          })
        end
      end
    end
  end
  return true
end

function AfkProxy:SyncAfkStatus(data)
  if not (data and data.charid) or data.charid == 0 then
    self:SetAfk(false)
  else
    self:SetAfk(true)
    self.charId = data.charid
    if data.statdata and data.statdata.estatus == UserAfkCmd_pb.EAFKSTATUS_OPEN then
      self.hasQuitAfk = false
    else
      self.hasQuitAfk = true
      self:StopQueryAfkStatus()
    end
  end
  self.lastAfkRewardData = data
  self:sendNotification(AfkEvent.SyncAfkStatus, data)
end

function AfkProxy:StartQueryAfkStatus(interval)
  if not self.queryAfkDataTicker then
    interval = interval or 60000
    self.queryAfkDataTicker = TimeTickManager.Me():CreateTick(0, interval, self.QueryAfkData, self, 2)
  end
end

function AfkProxy:StopQueryAfkStatus()
  if self.queryAfkDataTicker then
    TimeTickManager.Me():ClearTick(self, 2)
    self.queryAfkDataTicker = nil
  end
end

function AfkProxy:QueryAfkData()
  ServiceLoginUserCmdProxy.Instance:CallQueryAfkStatUserCmd(nil, nil, emptyTable)
end

function AfkProxy:SetAfk(val)
  self.isAfk = val
  if not val then
    self:StopQueryAfkStatus()
    self.lastAfkRewardData = nil
    self.charId = nil
    self.hasQuitAfk = nil
  end
end
