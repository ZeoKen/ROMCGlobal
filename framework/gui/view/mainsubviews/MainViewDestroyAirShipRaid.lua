autoImport("MainViewMultiBossBase")
MainViewDestroyAirShipRaid = class("MainViewDestroyAirShipRaid", MainViewMultiBossBase)
local RaidConfig = GameConfig.MultiBoss.Map

function MainViewDestroyAirShipRaid:UpdateBosslist(bossIndex)
  if not bossIndex then
    return
  end
  local mapid = SceneProxy.Instance:GetCurMapID()
  local StageConfig = RaidConfig[mapid] and RaidConfig[mapid].Stages
  local BossCfg = StageConfig[bossIndex]
  local bossList = BossCfg and BossCfg.bossid or {}
  local boss = {}
  local targetBossId = 0
  for i = 1, #bossList do
    local bossGuid = self.bossMap[bossList[i]]
    if bossGuid and 0 < bossGuid then
      targetBossId = i
      break
    end
  end
  local single = {}
  single.staticID = bossList[targetBossId]
  single.guid = self.bossMap[single.staticID]
  table.insert(boss, single)
  self.bossCtl:ResetDatas(boss, true)
end
