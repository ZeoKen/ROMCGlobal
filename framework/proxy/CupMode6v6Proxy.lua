autoImport("CupModeProxy")
CupMode6v6Proxy = class("CupMode6v6Proxy", CupModeProxy)
CupMode6v6Proxy.Instance = nil
CupMode6v6Proxy.Name = "CupMode6v6Proxy"

function CupMode6v6Proxy:ctor(proxyName, data)
  CupMode6v6Proxy.super.ctor(self, proxyName or CupMode6v6Proxy.Name, data)
  CupMode6v6Proxy.Instance = self
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

function CupMode6v6Proxy:OnDestroy()
  CupMode6v6Proxy.super.OnDestroy(self)
end

function CupMode6v6Proxy:GetMinSignupMemberCount()
  return self.SeasonTimeConfig and self.SeasonTimeConfig.warbandMemberNum or 6
end

function CupMode6v6Proxy:CheckMatchValid()
  local results = CupMode6v6Proxy.super.CheckMatchValid(self)
  if results then
    if not TeamProxy.Instance:CheckWarbandFitGroupMemberValid_CupMode6v6() then
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

function CupMode6v6Proxy:CheckHasPreRound()
  return true
end
