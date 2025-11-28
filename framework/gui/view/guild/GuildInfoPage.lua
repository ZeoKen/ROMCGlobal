GuildInfoPage = class("GuildInfoPage", SubView)
autoImport("GuildHeadCell")
autoImport("GuildActivityCell")
autoImport("DotCell")
autoImport("ZoneGroupCell")
autoImport("GuildCountDownCell")
GuildInfoPage.GuildAassetId = 146
GuildInfoPage.GuildItemId = 5500
local _queryInterval = 3600

function GuildInfoPage:Init()
  self:InitUI()
  self:MapEvent()
end

local tempArgs = {}

function GuildInfoPage:InitUI()
  self.guildName = self:FindComponent("GuildName", UILabel)
  self.guildIdObj = self:FindGO("GuildID")
  self:AddClickEvent(self.guildIdObj, function()
    TipManager.Instance:SetPlayerGuidTip(GuildProxy.Instance.myGuildData, nil, nil, nil, "GuildGuidTip")
  end)
  self.guildlv = self:FindComponent("GuildLv", UILabel)
  self.expSlider = self:FindComponent("ExpSlider", UISlider)
  self.chairManName = self:FindComponent("ChairManName", UILabel)
  self.chairManSex = self:FindComponent("Sex", UISprite, self.chairManName.gameObject)
  self.memberNum = self:FindComponent("MemberNum", UILabel)
  self.mercenaryNum = self:FindComponent("MerNum", UILabel)
  self.maintenance = self:FindComponent("Maintenance", UILabel)
  self.dismissTime = self:FindComponent("DismissTime", UILabel)
  self.changeZoneTime = self:FindComponent("ChangeZoneTime", UILabel)
  self.countDownTable = self:FindComponent("CountDownTable", UITable)
  self.countDownCtrl = UIGridListCtrl.new(self.countDownTable, GuildCountDownCell, "GuildCountDownCell")
  self.guildCurrentline = self:FindComponent("Guild_CurrentLine", UILabel)
  self.enterAreaButton = self:FindGO("EnterAreaButton")
  self.maintenanceFullTip = self:FindGO("MaintenanceFullTip")
  self.superGvg_Parent = self:FindGO("Tip5")
  self.superGvg = self:FindComponent("SuerGvgLv", UILabel, self.superGvg_Parent)
  self.getGvgRewardBtn = self:FindGO("RewardBtn")
  self.gvgRewardRedDot = self:FindGO("RedDot", self.superGvg_Parent)
  self.getGvgRewardBtn.gameObject:SetActive(GuildProxy.Instance:GetRewardState())
  self:AddClickEvent(self.getGvgRewardBtn, function()
    if Game.Myself:IsDead() then
      MsgManager.ShowMsgByIDTable(2500)
    elseif GuildProxy.Instance:GetRewardState() then
      ServiceGuildCmdProxy.Instance:CallGetGvgRewardGuildCmd()
    else
      helplog("No GVG reward")
    end
  end)
  self:AddClickEvent(self.enterAreaButton, function(go)
    if Game.Myself:IsDead() then
      MsgManager.ShowMsgByIDTable(2500)
    else
      local currentRaidID = SceneProxy.Instance:GetCurRaidID()
      local raidData = currentRaidID and Table_MapRaid[currentRaidID]
      if raidData and raidData.Type == 10 then
        MsgManager.ShowMsgByIDTable(2821)
        return
      end
      ServiceGuildCmdProxy.Instance:CallEnterTerritoryGuildCmd()
      self.container:CloseSelf()
    end
  end)
  local headCellObj = self:FindGO("GuildHeadContainer")
  local itemGO = self:LoadPreferb_ByFullPath(ResourcePathHelper.UICell("GuildHeadCell"), headCellObj)
  self.headCell = GuildHeadCell.new(itemGO)
  self.headCell:SetCallIndex(UnionLogo.CallerIndex.UnionList)
  self.headCell:DeleteGO("choose")
  self:AddClickEvent(itemGO, function(go)
    local myMemberData = GuildProxy.Instance:GetMyGuildMemberData()
    local canDo = GuildProxy.Instance:CanJobDoAuthority(myMemberData.job, GuildAuthorityMap.SetIcon)
    if canDo then
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.GuildHeadChoosePopUp
      })
    else
      MsgManager.ShowMsgByIDTable(2636)
    end
  end)
  self.centerOnChild = self:FindComponent("Grid", UICenterOnChild)
  self.bordInfoInput = self:FindComponent("BordInfoInput", UIInput)
  local dotGridTrans = self:FindComponent("PagePointGrid", Transform)
  self.boardDots = {}
  for i = 0, 1 do
    self.boardDots[i] = DotCell.new(dotGridTrans:GetChild(i).gameObject)
  end
  local boardTrans = self:FindGO("BoardInfo", self.centerOnChild.gameObject)
  
  function self.centerOnChild.onCenter(centeredObject)
    local index = centeredObject == boardTrans and 0 or 1
    self:ResetBoardDot(index)
  end
  
  self.bordOptButton = self:FindGO("BordInfoOption")
  if FunctionPerformanceSetting.CheckInputForbidden() then
    self.bordOptButton:SetActive(false)
  end
  self.RankingBtn = self:FindGO("RankingBtn")
  self:InitGroupZone()
  self:AddClickEvent(self.bordOptButton, function(go)
    if FunctionUnLockFunc.Me():ForbidInput(ProtoCommon_pb.EFUNCPARAM_RENAME_GUILD_BOARD) then
      return
    end
    self.bordInfoInput.isSelected = not self.bordInfoInput.isSelected
  end)
  self.upgradeButton = self:FindGO("UpgradeBtn")
  self:AddClickEvent(self.upgradeButton, function(go)
    if Game.Myself:IsDead() then
      MsgManager.ShowMsgByIDTable(2500)
    else
      local currentRaidID = SceneProxy.Instance:GetCurRaidID()
      local raidData = currentRaidID and Table_MapRaid[currentRaidID]
      if raidData and raidData.Type == 10 then
        TableUtility.TableClear(tempArgs)
        tempArgs.npcUID = 1
        local cmd = MissionCommandFactory.CreateCommand(tempArgs, MissionCommandVisitNpc)
        if cmd then
          Game.Myself:Client_SetMissionCommand(cmd)
        end
        self:PassEvent(GuildActivityCellEvent.TraceRoad)
      else
        ServiceGuildCmdProxy.Instance:CallEnterTerritoryGuildCmd()
      end
    end
  end)
  self.recruitInfoInput = self:FindComponent("RecruitInfoInput", UIInput)
  self.recruitOptButton = self:FindGO("RecruitInfoOption")
  self:AddClickEvent(self.recruitOptButton, function(go)
    if FunctionUnLockFunc.Me():ForbidInput(ProtoCommon_pb.EFUNCPARAM_RENAME_GUILD_RECRUIT) then
      return
    end
    self.recruitInfoInput.isSelected = not self.recruitInfoInput.isSelected
  end)
  local inputFunc = function(go, state)
    self:UpdateInfoBordAnim(not state)
    if not state then
      self:ChangeGuildBordInfo()
    end
  end
  SkipTranslatingInput(self.bordInfoInput)
  SkipTranslatingInput(self.recruitInfoInput)
  self.filterType = GameConfig.MaskWord.GuildDeclaration
  UIUtil.LimitInputCharacter(self.recruitInfoInput, GameConfig.System.guildrecruit_max, function(str)
    return FunctionMaskWord.Me():ReplaceMaskWord(str, self.filterType)
  end)
  UIUtil.LimitInputCharacter(self.bordInfoInput, GameConfig.System.guildboard_max, function(str)
    return FunctionMaskWord.Me():ReplaceMaskWord(str, self.filterType)
  end)
  self:AddSelectEvent(self.recruitInfoInput, inputFunc)
  self:AddSelectEvent(self.bordInfoInput, inputFunc)
  self.giScrollBg = self:FindGO("LeftDownBg")
  self:AddPressEvent(self.giScrollBg, function(go, isPress)
    self:UpdateInfoBordAnim(not isPress)
  end)
  local activityGrid = self:FindComponent("GuildActivityGrid", UIGrid)
  self.activityCtl = UIGridListCtrl.new(activityGrid, GuildActivityCell, "GuildActivityCell")
  self.activityCtl:AddEventListener(GuildActivityCellEvent.TraceRoad, self.TraceRoad, self)
  self.activityCtl:AddEventListener(GuildActivityCellEvent.ClickHelp, self.ClickHelp, self)
  self.noneTip = self:FindGO("NoneTip")
  self:UpdateInfoBordAnim()
  self:EventforGVGRanking()
end

function GuildInfoPage:InitGroupZone()
  self.lineGroupBtn = self:FindGO("LineGroupBtn")
  if self.lineGroupBtn then
    self.lineGroupBtn:SetActive(false)
  end
  self.groupZoneObjRoot = self:FindGO("GroupZoneRoot")
  self.fixedLineLab = self:FindComponent("LineLab", UILabel, self.groupZoneObjRoot)
  self.fixedZoneLab = self:FindComponent("ZoneLab", UILabel, self.groupZoneObjRoot)
  self.titleLab = self:FindComponent("TitleLab", UILabel, self.groupZoneObjRoot)
  self.fixedLineLab.text = ZhString.NewGVG_FixedLine
  self.fixedZoneLab.text = ZhString.NewGVG_Line
  self.titleLab.text = ZhString.NewGVG_GroupZoneTitle
  self.closeGroupZone = self:FindGO("CloseGroupZone", self.groupZoneObjRoot)
  self:AddClickEvent(self.closeGroupZone, function(go)
    self:GroupZoneHide()
  end)
  local groupZoneGrid = self:FindComponent("GroupZoneGrid", UIGrid, self.groupZoneObjRoot)
  self.groupZoneCtl = UIGridListCtrl.new(groupZoneGrid, ZoneGroupCell, "ZoneGroupCell")
  self:GroupZoneHide()
end

function GuildInfoPage:GroupZoneHide()
  self.groupZoneObjRoot:SetActive(false)
end

function GuildInfoPage:TraceRoad()
  self.container:CloseSelf()
end

function GuildInfoPage:ClickHelp(data)
  if data == nil then
    return
  end
  local config_helpid = data.HelpID
  if not config_helpid then
    return
  end
  if "number" == type(config_helpid) then
    self:RebuildHelpData(config_helpid)
    local helpData = Table_Help[config_helpid]
    self:OpenHelpView(helpData)
  elseif "table" == type(config_helpid) then
    for i = 1, #config_helpid do
      self:RebuildHelpData(config_helpid[i])
    end
    if 1 < #config_helpid then
      self:OpenMultiHelp(config_helpid)
    elseif #config_helpid == 1 then
      local helpData = Table_Help[config_helpid[1]]
      self:OpenHelpView(helpData)
    end
  end
end

function GuildInfoPage:RebuildHelpData(helpid)
  local helpData = Table_Help[helpid]
  if helpData and not helpData.rebuild then
    if helpid == 1630 then
      local timeStr = GvgProxy.Instance:GetGvgFinalTimeStr() or ""
      helpData.Desc = string.format(helpData.Desc, timeStr)
      helpData.rebuild = true
    elseif helpid == 35290 then
      local timeStr = GvgProxy.Instance:GetGvgTimeStr() or ""
      helpData.Desc = string.format(helpData.Desc, timeStr)
      helpData.rebuild = true
    end
  end
end

function GuildInfoPage:UpdateGuildInfo()
  local gdata = GuildProxy.Instance.myGuildData
  if gdata then
    self.guildName.text = gdata.name
    self.guildlv.text = string.format("Lv.%s", tostring(gdata.level))
    local gasset = gdata.asset
    local expValue = gasset / gdata:GetUpgradeConfig().LevelupFund
    self.expSlider.value = expValue
    local chairMan = gdata:GetChairMan()
    local myid = Game.Myself.data.id
    self.upgradeButton:SetActive(chairMan.id == myid and gasset >= gdata:GetUpgradeConfig().ReviewFund)
    self.chairManName.text = chairMan.name
    self.chairManName.text = AppendSpace2Str(chairMan.name)
    self.chairManSex.spriteName = chairMan:IsBoy() and "friend_icon_man" or "friend_icon_woman"
    self.memberNum.text = string.format("%s/%s", tostring(gdata.memberNum), tostring(gdata.maxMemberNum))
    self.mercenaryNum.text = string.format("%s/%s", tostring(gdata.mercenaryNum or 0), tostring(gdata.maxMercenaryNum or 0))
    self.maintenance.text = gasset
    local guildSData = Table_Guild[gdata.level]
    if guildSData then
      local limit = guildSData.UpperLimit or 0
      local dayGet = gdata.assettoday or 0
      if limit ~= 0 and guildSData ~= 0 and limit <= dayGet then
        self.maintenanceFullTip:SetActive(true)
      else
        self.maintenanceFullTip:SetActive(false)
      end
    end
    if gdata.staticData then
      local headId = GuildProxy.Instance.myGuildData.portrait or 1
      local headData = GuildHeadData.new()
      headData:SetBy_InfoId(headId)
      headData:SetGuildId(gdata.id)
      self.headCell:SetData(headData)
    end
    self.guildCurrentline.text = ChangeZoneProxy.Instance:ZoneNumToString(gdata.zoneid)
    self.recruitInfoInput.value = gdata.recruitinfo
    self.bordInfoInput.value = OverSea.LangManager.Instance():GetLangByKey(gdata.boardinfo)
    self:UpdateCountDownTime()
    self:UpdateAcitvityList()
    local myMemberData = GuildProxy.Instance:GetMyGuildMemberData()
    if myMemberData then
      local canEditBord = GuildProxy.Instance:CanJobDoAuthority(myMemberData.job, GuildAuthorityMap.SetBordInfo)
      self.bordOptButton:SetActive(canEditBord)
    end
    local myMemberData = GuildProxy.Instance:GetMyGuildMemberData()
    if myMemberData then
      local canEditRecruit = GuildProxy.Instance:CanJobDoAuthority(myMemberData.job, GuildAuthorityMap.SetRecruitInfo)
      self.recruitOptButton:SetActive(canEditRecruit)
    end
    self:UpdateGvgDroiyaLv()
    self:UpdateGvgRewardButton()
  end
end

function GuildInfoPage:UpdateGvgDroiyaLv()
  local GvgDroiyanReward_Config = GameConfig.GvgDroiyan and GameConfig.GvgDroiyan.GvgDroiyanReward
  if GvgDroiyanReward_Config == nil then
    self.superGvg_Parent.gameObject:SetActive(false)
    return
  end
  local gdata = GuildProxy.Instance.myGuildData
  if gdata.supergvg_lv == nil or gdata.supergvg_lv == 0 then
    self.superGvg_Parent.gameObject:SetActive(false)
    return
  end
  self.superGvg_Parent.gameObject:SetActive(not Table_FuncState[6] or FunctionUnLockFunc.checkFuncStateValid(6))
  self.superGvgGradeDesc = GvgDroiyanReward_Config[gdata.supergvg_lv].LvDesc
  self:UpdateCurrentGvgZone()
end

function GuildInfoPage:UpdateCurrentGvgZone()
  local superGvgGradeDesc = self.superGvgGradeDesc or ""
  local gvgGroupID = GuildProxy.Instance:GetMyGuildGvgGroup()
  if 0 < gvgGroupID then
    self.gvgGroupDesc = string.format(ZhString.NewGVG_GroupID, GuildProxy.Instance:GetMyGuildClientGvgGroup())
    self.superGvg.text = self.gvgGroupDesc .. "  " .. superGvgGradeDesc
  else
    self.superGvg.text = superGvgGradeDesc
  end
end

function GuildInfoPage:UpdateAcitvityList()
  local activitylst = GuildProxy.Instance:GetGuildActivityList()
  self.activityCtl:ResetDatas(activitylst)
  self.noneTip:SetActive(#activitylst == 0)
end

function GuildInfoPage:UpdateDismissTime(time)
  local gdata = GuildProxy.Instance.myGuildData
  self:UpdateCountDownTime(gdata.dismisstime, self.dismissTime, ZhString.GuildInfoPage_DismissGuildTip)
end

function GuildInfoPage:UpdateChangeZoneTime(time)
  local gdata = GuildProxy.Instance.myGuildData
  local tip = ""
  if gdata.nextzone and gdata.nextzone ~= 0 then
    tip = ChangeZoneProxy.Instance:ZoneNumToString(gdata.nextzone, ZhString.GuildInfoPage_GuildChangeline)
  end
  self:UpdateCountDownTime(gdata.zonetime, self.changeZoneTime, tip)
end

function GuildInfoPage:UpdateCountDownTime()
  local gdata = GuildProxy.Instance.myGuildData
  local nowServerTime = ServerTime.CurServerTime() / 1000
  local list = {}
  local dismissTime = gdata.dismisstime
  local zoneTime = gdata.zonetime
  local gvglineTime = gdata.change_group_time
  if dismissTime and nowServerTime < dismissTime then
    local tempData = {
      tip = ZhString.GuildInfoPage_DismissGuildTip,
      timeStamp = dismissTime
    }
    table.insert(list, tempData)
  end
  if zoneTime and nowServerTime < zoneTime then
    local tempData = {
      tip = ZhString.GuildInfoPage_GuildChangeline,
      timeStamp = zoneTime,
      target = ChangeZoneProxy.Instance:ZoneNumToString(gdata.nextzone)
    }
    table.insert(list, tempData)
  end
  if gvglineTime and nowServerTime < gvglineTime then
    xdlog("切换战线", gdata.next_battle_group)
    local tempData = {
      tip = ZhString.GuildInfoPage_GuildGvgline,
      timeStamp = gvglineTime,
      target = GvgProxy.ClientGroupId(gdata.next_battle_group)
    }
    table.insert(list, tempData)
  end
  self.countDownCtrl:ResetDatas(list)
end

function GuildInfoPage:ChangeGuildBordInfo()
  local myGuildData = GuildProxy.Instance.myGuildData
  if myGuildData then
    local board, recruit
    if self.bordInfoInput.value ~= myGuildData.boardinfo then
      board = self.bordInfoInput.value
    end
    if self.recruitInfoInput.value ~= myGuildData.recruitinfo then
      recruit = self.recruitInfoInput.value
    end
    if board or recruit then
      board = board == "" and "null" or board
      recruit = recruit == "" and "null" or recruit
      ServiceGuildCmdProxy.Instance:CallSetGuildOptionGuildCmd(board, recruit)
    end
  end
end

function GuildInfoPage:UpdateInfoBordAnim(isTween)
  TimeTickManager.Me():ClearTick(self, 2)
  if nil == isTween then
    isTween = not self.bordInfoInput.isSelected and not self.recruitInfoInput.isSelected
  end
  if not isTween then
    return
  end
  TimeTickManager.Me():CreateTick(6000, 6000, function()
    local childlist, cTrans = {}, self.centerOnChild.transform
    local centerIndex = 0
    for i = 0, cTrans.childCount - 1 do
      childlist[i] = cTrans:GetChild(i)
      if childlist[i].gameObject == self.centerOnChild.centeredObject then
        centerIndex = i
      end
    end
    if 0 < #childlist then
      local index = (centerIndex + 1) % (#childlist + 1)
      local centerTrans = childlist[index]
      self.centerOnChild:CenterOn(centerTrans)
    end
  end, self, 2)
end

function GuildInfoPage:ResetBoardDot(targetIndex)
  for k, v in pairs(self.boardDots) do
    v:SetChoose(k == targetIndex)
  end
end

function GuildInfoPage:MapEvent()
  self:AddListenEvt(ServiceEvent.GuildCmdGuildMemberUpdateGuildCmd, self.HandleGuildDataUpdate)
  self:AddListenEvt(ServiceEvent.GuildCmdGuildDataUpdateGuildCmd, self.HandleGuildDataUpdate)
  self:AddListenEvt(ServiceEvent.GuildCmdQueryPackGuildCmd, self.HandleGuildDataUpdate)
  self:AddListenEvt(ServiceEvent.GuildCmdGuildMemberDataUpdateGuildCmd, self.HandleGuildDataUpdate)
  self:AddListenEvt(ServiceEvent.GuildCmdQueryPackGuildCmd, self.UpdateGuildInfo)
  self:AddListenEvt(ServiceEvent.GuildCmdPackUpdateGuildCmd, self.UpdateGuildInfo)
  self:AddListenEvt(ServiceEvent.GuildCmdGvgRewardNtfGuildCmd, self.UpdateGvgRewardButton)
  self:AddListenEvt(ServiceEvent.GuildCmdQueryGvgZoneGroupGuildCCmd, self.UpdateCurrentGvgZone)
  self:AddListenEvt(ServiceEvent.ActivityCmdGuildAssembleSyncCmd, self.UpdateAcitvityList)
  self:AddListenEvt(ServiceEvent.ActivityCmdGuildAssembleAcceptCmd, self.OnGuildAssembleAccept)
end

function GuildInfoPage:HandleGuildDataUpdate(note)
  self:UpdateGuildInfo()
end

function GuildInfoPage:EventforGVGRanking()
  self:AddClickEvent(self.RankingBtn, function(go)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.GVGRankPopUp,
      viewdata = {}
    })
  end)
end

function GuildInfoPage:UpdateGvgRewardButton()
  if GuildProxy.Instance:GetRewardState() then
    self.getGvgRewardBtn.gameObject:SetActive(true)
  else
    self.getGvgRewardBtn.gameObject:SetActive(false)
  end
end

function GuildInfoPage:OnEnter()
  GuildInfoPage.super.OnEnter(self)
  self:ResetGuildID()
  self:UpdateGuildInfo()
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_GUILD_ICON, self.headCell.bg.gameObject, 42)
end

function GuildInfoPage:ResetGuildID()
  local myGuildData = GuildProxy.Instance.myGuildData
  self.myGuildId = myGuildData and myGuildData.id
end

function GuildInfoPage:OnExit()
  GuildInfoPage.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
  FunctionGuild.Me():ClearCustomPicCache(self.myGuildId)
  local cells = self.activityCtl:GetCells()
  for i = 1, #cells do
    cells[i]:OnRemove()
  end
end

function GuildInfoPage:OnGuildAssembleAccept(note)
  redlog("GuildInfoPage:OnGuildAssembleAccept")
  local success = note.body and note.body.success
  if success then
    local cells = self.activityCtl:GetCells()
    local cell = cells[1]
    if cell.data.AssembleId then
      cell:OnGuildAssembleAccept()
    end
  end
end
