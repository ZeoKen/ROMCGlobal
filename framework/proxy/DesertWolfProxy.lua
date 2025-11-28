autoImport("DesertWolfReportData")
DesertWolfProxy = class("DesertWolfProxy", pm.Proxy)
DesertWolfProxy.Instance = nil
DesertWolfProxy.NAME = "DesertWolfProxy"

function DesertWolfProxy:ctor(proxyName, data)
  self.proxyName = proxyName or DesertWolfProxy.NAME
  if DesertWolfProxy.Instance == nil then
    DesertWolfProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function DesertWolfProxy:Init()
end

function DesertWolfProxy:Reset()
  self.isEnd = nil
  self.stats = nil
end

function DesertWolfProxy:GetStats()
  return self.stats or {}
end

function DesertWolfProxy:CallDesertWolfStatQuery()
  ServiceMatchCCmdProxy.Instance:CallDesertWolfStatQueryCmd(nil, nil, nil, {})
end

function DesertWolfProxy:SortStatsByKey(key)
  if not self.stats then
    return
  end
  table.sort(self.stats, function(x, y)
    return x[key] and y[key] and x[key] < y[key]
  end)
end

function DesertWolfProxy:RecvDesertWolfStatQuery(serverData)
  if self.isEnd then
    return
  end
  if not serverData then
    return
  end
  if not self.stats then
    self.stats = {}
  end
  TableUtility.ArrayClear(self.stats)
  if serverData.stats then
    for _, v in ipairs(serverData.stats) do
      local statData = {
        charid = v.charid,
        profession = v.profession,
        teamColor = v.color,
        name = v.name,
        kill = v.kill,
        death = v.death,
        assist = v.assist,
        combo = v.combo,
        heal = v.heal,
        damage = v.damage
      }
      if serverData.mvp_info then
        statData.ismvp = serverData.mvp_info.charid and serverData.mvp_info.charid > 0 and v.charid == serverData.mvp_info.charid
      else
        statData.ismvp = false
      end
      table.insert(self.stats, statData)
    end
    self:SortStatsByKey("teamColor")
  end
  if serverData.is_end then
    self.isEnd = true
  end
  self:sendNotification(DesertWolfEvent.OnStatChanged)
  if self.isEnd then
    local viewData = {
      winTeamColor = serverData.win_team,
      mvpUserInfo = serverData.mvp_info
    }
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.DesertWolfFightResultPopup,
      viewdata = viewData
    })
  end
end

function DesertWolfProxy:IsEquipForbidden(equipInfo)
  if not equipInfo then
    return false
  end
  if not Game.MapManager:IsPvpMode_DesertWolf() then
    return false
  end
  if equipInfo:IsArtifact() then
    return PvpProxy.Instance:IsArtifactForbidden()
  end
  if equipInfo:IsRelics() then
    return PvpProxy.Instance:IsRelicsForbidden()
  end
  return false
end
