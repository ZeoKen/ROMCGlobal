ActivityDungeonView = class("ActivityDungeonView", ContainerView)
autoImport("ActivityDungeonInfo")
autoImport("ActivityDungeonRate")
autoImport("CostInfoCell")
autoImport("RaidEnterWaitView")
ActivityDungeonView.ViewType = UIViewType.NormalLayer
local raidTypeConfig = {
  EvaRaid = GameConfig.EVA,
  HeadwearRaid = GameConfig.HeadWear,
  TransferFight = GameConfig.TransferFight,
  Einherjar = GameConfig.EinherjarRaid,
  Kumamoto = GameConfig.KumamotoBear,
  Slayers = GameConfig.KumamotoBear,
  MaidRaid = GameConfig.KumamotoBear,
  HeadWearActivity = GameConfig.HeadWearActivity
}
local raidTypeTabConfig = {
  EvaRaid = {"InfoTab", "RatingTab"},
  HeadwearRaid = {},
  TransferFight = {},
  Einherjar = {"InfoTab", "ShopTab"},
  Kumamoto = {"InfoTab", "RatingTab"},
  Slayers = {"InfoTab", "ShopTab"},
  MaidRaid = {"InfoTab", "RatingTab"},
  HeadWearActivity = {}
}
local defaultShowCoins = {100, 151}
local matchStatusShow = {
  TransferFight = PvpProxy.Type.TransferFight
}
local ratinglist

function ActivityDungeonView:Init()
  self:SetRaidConfig()
  self:AddListenEvts()
  self:InitUI()
end

function ActivityDungeonView:OnEnter()
  ActivityDungeonView.super.OnEnter(self)
  self:CameraRotateToMe()
  BattleTimeDataProxy.QueryBattleTimelenUserCmd()
  self:TabChangeHandler(1)
end

function ActivityDungeonView:SetRaidConfig()
  self.raidType = self.viewdata.viewdata.raidtype
  self.raidConfig = self.raidType and raidTypeConfig[self.raidType]
  self.raidTurnId = self.viewdata.viewdata.turnid
  if self.raidType and self.raidType == "Einherjar" then
    if self.raidConfig.EnterInfo[self.raidTurnId] then
      self.raidShopId = self.raidConfig.EnterInfo[self.raidTurnId].shopid
    else
      redlog("副本类型" .. self.raidType .. "副本批次" .. self.raidTurnId .. "缺失配置")
    end
  else
    self.raidShopId = self.raidConfig and self.raidConfig.shopid
  end
  if raidTypeTabConfig[self.raidType] and not self.raidShopId then
    TableUtility.ArrayRemove(raidTypeTabConfig[self.raidType], "ShopTab")
  end
  self.fakeTeamMatchData = {EnterLevel = 1, NoviceCanJoin = 1}
  timeRank = self.raidConfig.time_rank_desc
  killRank = self.raidConfig.kill_rank_desc
  if not timeRank and not killRank then
    return
  end
  ratinglist = timeRank or killRank
end

function ActivityDungeonView:AddListenEvts()
  self:AddListenEvt(ServiceEvent.NUserAltmanRewardUserCmd, self.UpdateRateRedtip)
  self:AddListenEvt(ServiceEvent.NUserBattleTimelenUserCmd, self.HandleBattleTimelen)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.SessionTeamEnterTeam, self.OnEnterTeam)
  self:AddListenEvt(ServiceEvent.MatchCCmdNtfMatchInfoCCmd, self.UpdateMatchInfoCmd)
  self:AddListenEvt(ServiceEvent.NUserVarUpdate, self.UpdateRateRedtip)
end

function ActivityDungeonView:InitUI()
  self.infoGO = self:FindGO("ActivityDungeonInfo")
  self.rateGO = self:FindGO("ActivityDungeonRate")
  self.infoPage = self:AddSubView("ActivityDungeonInfo", ActivityDungeonInfo)
  self.ratePage = self:AddSubView("ActivityDungeonRate", ActivityDungeonRate)
  local coinsGrid = self:FindComponent("TopCoins", UIGrid)
  self.coinsCtl = UIGridListCtrl.new(coinsGrid, CostInfoCell, "CoinInfoCell")
  local showCoins = self.raidShopId and Table_NpcFunction[self.raidShopId] and Table_NpcFunction[self.raidShopId].Parama.ItemID or defaultShowCoins
  self.coinsCtl:ResetDatas(showCoins)
  local infoTab = self:FindGO("InfoTab")
  self:AddTabChangeEvent(infoTab, self.infoGO, PanelConfig.ActivityDungeonInfo)
  local ratingTab = self:FindGO("RatingTab")
  self:AddTabChangeEvent(ratingTab, self.rateGO, PanelConfig.ActivityDungeonRate)
  local shopTab = self:FindGO("ShopTab")
  self:AddTabChangeEvent(shopTab, nil, 3)
  local tabList = {
    infoTab,
    ratingTab,
    shopTab
  }
  self.tabIconSpList = {}
  for _, v in pairs(tabList) do
    v:SetActive(TableUtility.ArrayFindIndex(raidTypeTabConfig[self.raidType], v.name) > 0)
    local icon = Game.GameObjectUtil:DeepFindChild(v, "Icon")
    TableUtility.ArrayPushBack(self.tabIconSpList, icon:GetComponent(UISprite))
  end
  if not ratinglist then
    ratingTab:SetActive(false)
  end
  self.matchBtn = self:FindGO("Match")
  self.matchBtn:SetActive(self.raidConfig.MatchJoin and self.raidConfig.MatchJoin == 1 or false)
  self.redtip = self:FindGO("redtip")
  ServiceNUserProxy.Instance:CallAltmanRewardUserCmd(nil, nil, 0)
  self:AddButtonEvent("Enter", function()
    ServiceLoginUserCmdProxy.Instance:CallServerTimeUserCmd()
    if self["Enter" .. self.raidType] then
      self["Enter" .. self.raidType](self)
    end
  end)
  self:AddButtonEvent("Match", function()
    ServiceLoginUserCmdProxy.Instance:CallServerTimeUserCmd()
    if self["Match" .. self.raidType] then
      self["Match" .. self.raidType](self)
    end
  end)
  self:UpdateRateRedtip()
end

function ActivityDungeonView:TabChangeHandler(key)
  if ActivityDungeonView.super.TabChangeHandler(self, key) then
    self:SetCurrentTabIconColor(self.coreTabMap[key].go)
    if key == 2 then
      ServiceNUserProxy.Instance:CallAltmanRewardUserCmd(nil, nil, 0)
    elseif key == 3 then
      local npcFunctionData = self.raidShopId and Table_NpcFunction[self.raidShopId]
      if npcFunctionData ~= nil then
        FunctionNpcFunc.Me():DoNpcFunc(npcFunctionData, Game.Myself, 1)
      end
    end
  end
end

function ActivityDungeonView:OnExit()
  UIUtil.StopEightTypeMsg()
  self:CameraReset()
  ActivityDungeonView.super.OnExit(self)
end

function ActivityDungeonView:HandleBattleTimelen(note)
  local data = note.body
  if not (data and data.timelen) or not data.totaltime then
    return
  end
  local leftTimeLen = data.totaltime - data.timelen
  self.remainingBattleTime = (data.musictime or 0) + (data.tutortime or 0) + (data.powertime or 0) + (leftTimeLen < 0 and 0 or leftTimeLen)
end

function ActivityDungeonView:SetCurrentTabIconColor(currentTabGo)
  TabNameTip.ResetColorOfTabIconList(self.tabIconSpList)
  TabNameTip.SetupIconColorOfCurrentTabObj(currentTabGo)
end

function ActivityDungeonView:Enter(pbRaidType)
  DungeonProxy.InviteTeamRaid(nil, pbRaidType, nil, function()
    self:CloseSelf()
  end)
end

function ActivityDungeonView:EnterEvaRaid()
  self:Enter(FuBenCmd_pb.ERAIDTYPE_ALTMAN)
end

function ActivityDungeonView:EnterHeadwearRaid()
  local entryLevel = self.raidConfig.Entrylevel
  if entryLevel > MyselfProxy.Instance:RoleLevel() then
    MsgManager.ShowMsgByID(7301, entryLevel)
    return
  end
  if TeamProxy.Instance:IHaveTeam() then
    local memberListExceptMe = TeamProxy.Instance.myTeam:GetMembersListExceptMe()
    for i = 1, #memberListExceptMe do
      if entryLevel > memberListExceptMe[i].baselv then
        MsgManager.ShowMsgByID(7305, entryLevel)
        return
      end
    end
  end
  if not self.remainingBattleTime then
    LogUtility.Error("Cannot get battle time of myself")
    return
  end
  if self.remainingBattleTime < self.raidConfig.battletime then
  end
  self:Enter(FuBenCmd_pb.ERAIDTYPE_HEADWEAR)
end

function ActivityDungeonView:EnterTransferFight()
  redlog("申请魔物乱斗")
  local matchStatus = PvpProxy.Instance:GetMatchState(PvpProxy.Type.TransferFight)
  if matchStatus and matchStatus.ismatch then
    MsgManager.ShowMsgByIDTable(3609)
    return
  end
  if not TeamProxy.Instance:CheckDiffServerValidByPvpType(PvpProxy.Type.TransferFight) then
    MsgManager.ShowMsgByID(42042)
    return
  end
  ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(PvpProxy.Type.TransferFight)
end

function ActivityDungeonView:EnterEinherjar()
  local matchStatus = PvpProxy.Instance:GetCurMatchStatus()
  if matchStatus then
    MsgManager.ShowMsgByID(25917)
    return
  end
  if not TeamProxy.Instance:CheckMatchValid(self.fakeTeamMatchData) then
    return
  end
  local enterInfo = self.raidConfig.EnterInfo
  if enterInfo and enterInfo[self.raidTurnId] then
    local raidid = enterInfo[self.raidTurnId].mapraid
    local _teamPy = TeamProxy.Instance
    if _teamPy:ForbiddenByRaidID(raidid) then
      MsgManager.ShowMsgByID(42042)
      return
    end
    ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(PvpProxy.Type.Einherjar, raidid, nil, true)
  else
    redlog("当前副本未配置EnterInfo信息")
  end
end

function ActivityDungeonView:EnterKumamoto()
  ServiceFuBenCmdProxy.Instance:CallKumamotoOperFubenCmd(FuBenCmd_pb.EKUMAMOTOOPER_CREATE)
end

function ActivityDungeonView:EnterSlayers()
  return self:EnterKumamoto()
end

function ActivityDungeonView:EnterMaidRaid()
  return self:EnterKumamoto()
end

function ActivityDungeonView:EnterHeadWearActivity()
  local entryLevel = self.raidConfig.Entrylevel
  if entryLevel > MyselfProxy.Instance:RoleLevel() then
    MsgManager.ShowMsgByID(7301, entryLevel)
    return
  end
  if TeamProxy.Instance:IHaveTeam() then
    local memberListExceptMe = TeamProxy.Instance.myTeam:GetMembersListExceptMe()
    for i = 1, #memberListExceptMe do
      if entryLevel > memberListExceptMe[i].baselv then
        MsgManager.ShowMsgByID(7305, entryLevel)
        return
      end
    end
  end
  if not self.remainingBattleTime then
    LogUtility.Error("Cannot get battle time of myself")
    return
  end
  if self.remainingBattleTime < self.raidConfig.battletime then
  end
  self:Enter(FuBenCmd_pb.ERAIDTYPE_HEADWEARACTIVITY)
end

function ActivityDungeonView:UpdateRedtip()
  self.redtip:SetActive(DungeonProxy.Instance:CheckRedtip())
end

function ActivityDungeonView:GetMyRate()
  if self.raidType == "Kumamoto" or self.raidType == "MaidRaid" then
    local myscore = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_KUMAMOTO_SCORE) or 0
    if ratinglist and 0 < #ratinglist then
      for i = 1, #ratinglist do
        local single = ratinglist[i]
        if myscore >= single.score then
          return single.id
        end
      end
    end
    return 0
  else
    return DungeonProxy.Instance:GetMyRate()
  end
end

function ActivityDungeonView:UpdateRateRedtip()
  xdlog("UpdateRateRedtip")
  if self["UpdateRedTip" .. self.raidType] then
    self["UpdateRedTip" .. self.raidType](self)
  else
    self:UpdateRedtip()
  end
end

function ActivityDungeonView:UpdateRedTipKumamoto()
  local myreward = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_KUMAMOTO_REWARD) or 0
  local redtip = false
  for i = 1, 4 do
    local status = BitUtil.band(myreward, i)
    if self:GetMyRate() ~= 0 and i >= self:GetMyRate() and status == 0 then
      redtip = true
      break
    end
  end
  self.redtip:SetActive(redtip)
end

function ActivityDungeonView:UpdateRedTipSlayers()
  self:UpdateRedTipKumamoto()
end

function ActivityDungeonView:UpdateRedTipMaidRaid()
  self:UpdateRedTipKumamoto()
end

function ActivityDungeonView:OnEnterTeam()
  local ins = DungeonProxy.Instance
  if ins.createSingleTeamRequested == nil then
    return
  end
  DungeonProxy.InviteTeamRaid(nil, ins.createSingleTeamRequested, nil, function()
    self:CloseSelf()
  end)
end

function ActivityDungeonView:UpdateMatchInfoCmd(note)
  local status, etype = PvpProxy.Instance:GetCurMatchStatus()
  for name, dungeontype in pairs(matchStatusShow) do
    if etype and etype == dungeontype and status.ismatch then
      TeamPwsMatchPopUp.Show(etype)
    end
  end
end

function ActivityDungeonView:MatchEinherjar()
  local matchStatus = PvpProxy.Instance:GetCurMatchStatus()
  if matchStatus then
    MsgManager.ShowMsgByID(25917)
    return
  end
  if not TeamProxy.Instance:CheckMatchValid(self.fakeTeamMatchData) then
    return
  end
  local enterInfo = self.raidConfig.EnterInfo
  if enterInfo and enterInfo[self.raidTurnId] then
    local raidid = enterInfo[self.raidTurnId].mapraid
    local _teamPy = TeamProxy.Instance
    if _teamPy:ForbiddenByRaidID(raidid) then
      MsgManager.ShowMsgByID(42042)
      return
    end
    ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(PvpProxy.Type.Einherjar, raidid)
  end
end
