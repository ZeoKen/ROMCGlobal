autoImport("CupMode6v6Proxy")
CupMode6v6Proxy_MultiServer = class("CupMode6v6Proxy_MultiServer", CupMode6v6Proxy)
CupMode6v6Proxy_MultiServer.Instance = nil
CupMode6v6Proxy_MultiServer.Name = "CupMode6v6Proxy_MultiServer"

function CupMode6v6Proxy_MultiServer:ctor(proxyName, data)
  CupMode6v6Proxy_MultiServer.super.super.ctor(self, proxyName or CupMode6v6Proxy_MultiServer.Name, data)
  CupMode6v6Proxy_MultiServer.Instance = self
  self.CupModeType = EPVPTYPE.EPVPTYPE_TEAMPWS_CHAMPION
  self.SeasonTimeConfig = GameConfig.TeamSeasonTime
  if self.SeasonTimeConfig then
    self.MinMatchNum = self.SeasonTimeConfig.minMatchNum
  end
  local useless, pvpTeamRaidConfig = next(GameConfig.PvpTeamRaid)
  if pvpTeamRaidConfig then
    self.RequireLv = pvpTeamRaidConfig.RequireLv
  end
end

function CupMode6v6Proxy_MultiServer:CheckMatchValid()
  local results = CupMode6v6Proxy.super.CheckMatchValid(self)
  if results then
    local isMultiServer = true
    if not TeamProxy.Instance:CheckWarbandFitGroupMemberValid_CupMode6v6(isMultiServer) then
      MsgManager.ShowMsgByID(28062)
      return
    end
    local existingProfs = {}
    local mem = self.myWarband:GetMembers()
    for i = 1, #mem do
      local mwbm = TeamProxy.Instance.myTeam:GetMemberByGuid(mem[i].id)
      if mwbm then
        if TableUtility.ArrayFindIndex(existingProfs, mwbm.profession) <= 0 then
          table.insert(existingProfs, mwbm.profession)
        else
          MsgManager.ConfirmMsgByID(28107)
          return
        end
      end
    end
    return results
  end
end
