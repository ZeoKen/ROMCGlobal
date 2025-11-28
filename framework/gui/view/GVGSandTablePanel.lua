GVGSandTablePanel = class("GVGSandTablePanel", BaseView)
GVGSandTablePanel.ViewType = UIViewType.NormalLayer
autoImport("GVGSandTablePointCell")
autoImport("GVGSandMvpCell")
GVGSandTablePanel.TexObjTexNameMap = {
  BGTexture = "SandTable_bg",
  TitleTexture = "login_bg_title"
}
local gvgConfig = GameConfig.GVGConfig
local InputLimitMaxCount = 39

function GVGSandTablePanel:Init()
  if AppBundleConfig.GetSDKLang() == "en" or AppBundleConfig.GetSDKLang() == "pt" then
    InputLimitMaxCount = 60
  end
  self:FindObjs()
  self:AddViewEvts()
  self:AddMapEvts()
  self:InitDatas()
  self:InitShow()
  self:RegisterGuide()
end

function GVGSandTablePanel:GetMaxPointScore()
  local static_data = self.curMapID and GvgProxy.GetStrongHoldStaticData(self.curMapID)
  if not static_data then
    return
  end
  if static_data.Mode == GuildCmd_pb.EGUILDDATEBATTLEMODE_CLASSIC then
    return #static_data.Point * (static_data.Point[1].calc_ratio or 1)
  end
  return GvgProxy.Instance:GetMaxPointScore()
end

function GVGSandTablePanel:FindObjs()
  self.helpBtn = self:FindGO("HelpBtn")
  self.battleLineLabel = self:FindGO("BattleLine"):GetComponent(UILabel)
  self.totalLeftTimeLabel = self:FindGO("TotalLeftTime"):GetComponent(UILabel)
  self.anchorLeftBottom = self:FindGO("Anchor_LeftButtom")
  self.mvpAliveLab = self:FindComponent("MVPAlive", UILabel, self.anchorLeftBottom)
  self.mvpAliveLab.text = ZhString.GVGSandTable_MvpAlive
  self.battleStatusRoot = self:FindGO("BattleStatusRoot")
  self.pageSwitchPart = self:FindGO("PageSwitch", self.battleStatusRoot)
  self.statusNode_TweenPos = self:FindGO("SwitchNode"):GetComponent(TweenPosition)
  self.statusLabel = self:FindGO("StatusLabel"):GetComponent(UILabel)
  self.forceLabel = self:FindGO("ForceLabel"):GetComponent(UILabel)
  self.gvgRank = self:FindGO("GVGRank", self.battleStatusRoot)
  self.ranks = {}
  for i = 1, 3 do
    self.ranks[i] = {}
    self.ranks[i].go = self:FindGO("Rank" .. i)
    self.ranks[i].guildTexture = self:FindGO("GuildTexture", self.ranks[i].go):GetComponent(UITexture)
    self.ranks[i].guildIcon = self:FindGO("GuildIcon", self.ranks[i].go):GetComponent(UISprite)
    self.ranks[i].guildName = self:FindGO("GuildName", self.ranks[i].go):GetComponent(UILabel)
  end
  self.gvgForces = self:FindGO("GVGForces", self.battleStatusRoot)
  self.forceStateLabel = self:FindGO("StateLabel", self.gvgForces):GetComponent(UILabel)
  self.atkForceLabel = self:FindGO("AtkForceLabel", self.gvgForces):GetComponent(UILabel)
  self.defForceLabel = self:FindGO("DefForceLabel", self.gvgForces):GetComponent(UILabel)
  self.refreshBtn = self:FindGO("RefreshBtn")
  self.refreshBtn_Sprite = self.refreshBtn:GetComponent(UISprite)
  self.refreshBtn:SetActive(false)
  self.titleTexture = self:FindGO("TitleTexture"):GetComponent(UISprite)
  self.titleLabel = self:FindGO("TitleLabel"):GetComponent(UILabel)
  self.leftIndicator = self:FindGO("LeftIndicator")
  self.rightIndicator = self:FindGO("RightIndicator")
  self.timeLabel = self:FindGO("TimeLabel"):GetComponent(UILabel)
  self.sendMessagePart = self:FindGO("SendMessagePart")
  self.funcBtn = self:FindGO("FuncBtn")
  self.channelSelect = self:FindGO("ChannelSelect")
  self.channel_Tween = self.channelSelect:GetComponent(TweenScale)
  self.channel_Tween:ResetToBeginning()
  self.guildChannelBtn = self:FindGO("GuildChannel", self.channelSelect)
  self.gvgChannelBtn = self:FindGO("GVGChannel", self.channelSelect)
  for obj, _ in pairs(GVGSandTablePanel.TexObjTexNameMap) do
    self[obj] = self:FindComponent(obj, UITexture)
  end
  self.frontPanel = self:FindGO("FrontPanel")
  self.perfectDefendPart = self:FindGO("PerfectDefend")
  self.defendLabel = self:FindGO("DefendLabel", self.perfectDefendPart):GetComponent(UILabel)
  self.defendLabel.text = ZhString.GVGSandTable_PerfectDefend
  self.perfectDefendPart:SetActive(false)
  self.perfect_DefendLab = self:FindComponent("Perfect_Defend", UILabel)
  self.perfect_DefendLab.text = ZhString.GVGSandTable_PerfectDefend
  self.roadBlockBtn = self:FindGO("RoadBlockBtn")
  if self.roadBlockBtn then
    self.roadBlockBtn:SetActive(false)
  end
end

function GVGSandTablePanel:AddViewEvts()
  self:TryOpenHelpViewById(35251, nil, self.helpBtn)
  self:AddClickEvent(self.funcBtn, function()
    xdlog("发送战报")
    if self:IsShowGVG() then
      self.channel_Tween:ResetToBeginning()
      self.channel_Tween:PlayForward()
    else
      self:SendMessage(ChatChannelEnum.Guild)
    end
  end)
  self:AddClickEvent(self.guildChannelBtn, function()
    self.channel_Tween:PlayReverse()
    self:SendMessage(ChatChannelEnum.Guild)
  end)
  self:AddClickEvent(self.gvgChannelBtn, function()
    self.channel_Tween:PlayReverse()
    self:SendMessage(ChatChannelEnum.GVG)
  end)
  self:AddClickEvent(self.leftIndicator, function()
    self:MapGoLeft()
  end)
  self:AddClickEvent(self.rightIndicator, function()
    self:MapGoRight()
  end)
  self:AddClickEvent(self.refreshBtn, function()
    if ServerTime.CurServerTime() / 1000 < self.nextRefeshValidTimeStamp then
      MsgManager.ShowMsgByID(31050)
      return
    else
      ServiceUserEventProxy.Instance:CallGvgSandTableEvent(true)
      xdlog("申请数据")
      self.nextRefeshValidTimeStamp = ServerTime.CurServerTime() / 1000 + 10
      TimeTickManager.Me():ClearTick(self, 2)
      TimeTickManager.Me():CreateTick(0, 1000, self.RefreshValidTime, self, 2)
    end
  end)
  self:AddClickEvent(self.pageSwitchPart, function()
    self.curStatusNode = not self.curStatusNode
    if not self.curStatusNode then
      self.statusNode_TweenPos:PlayForward()
      self.statusLabel.color = LuaGeometry.GetTempVector4(0.6941176470588235, 0.6470588235294118, 0.5686274509803921, 1)
      self.forceLabel.color = LuaGeometry.GetTempVector4(0.30196078431372547, 0.21568627450980393, 0.13333333333333333, 1)
    else
      self.statusNode_TweenPos:PlayReverse()
      self.statusLabel.color = LuaGeometry.GetTempVector4(0.30196078431372547, 0.21568627450980393, 0.13333333333333333, 1)
      self.forceLabel.color = LuaGeometry.GetTempVector4(0.6941176470588235, 0.6470588235294118, 0.5686274509803921, 1)
    end
    self.gvgRank:SetActive(not self.curStatusNode)
    self.gvgForces:SetActive(self.curStatusNode)
  end)
end

function GVGSandTablePanel:AddMapEvts()
  self:AddListenEvt(ServiceEvent.UserEventGvgSandTableEvent, self.HandleGvgSandTableUpdate)
end

function GVGSandTablePanel:InitDatas()
  self.pageIndex = {}
  self.sandTableInfo = {}
  local curMapID = Game.MapManager:GetMapID()
  local count = 0
  for k, v in pairs(Table_Guild_StrongHold) do
    self.sandTableInfo[v.id] = {
      city = v.id,
      state = 0
    }
    table.insert(self.pageIndex, v.id)
    count = count + 1
    if v.LobbyRaidID == curMapID then
      self.curMapID = k
    end
  end
  table.sort(self.pageIndex, function(l, r)
    return l < r
  end)
  self.totalPage = count
end

function GVGSandTablePanel:InitShow()
  self.curStatusNode = true
  self.gvgRank:SetActive(not self.curStatusNode)
  self.gvgForces:SetActive(self.curStatusNode)
  self:InitGuildStatus()
  self:InitPoints()
end

function GVGSandTablePanel:MapGoLeft()
  local curIndex
  for i = 1, self.totalPage do
    if self.pageIndex[i] == self.curMapID then
      curIndex = i
    end
  end
  if curIndex == 1 then
    self.curMapID = self.pageIndex[self.totalPage]
  else
    self.curMapID = self.pageIndex[curIndex - 1]
  end
  self:RefreshPage()
end

function GVGSandTablePanel:MapGoRight()
  local curIndex
  for i = 1, self.totalPage do
    if self.pageIndex[i] == self.curMapID then
      curIndex = i
    end
  end
  if curIndex == self.totalPage then
    self.curMapID = self.pageIndex[1]
  else
    self.curMapID = self.pageIndex[curIndex + 1]
  end
  self:RefreshPage()
end

function GVGSandTablePanel:InitGuildStatus()
  for i = 1, 3 do
    if self.ranks[i] then
      self.ranks[i].guildName.text = "---"
    end
  end
end

function GVGSandTablePanel:InitPoints()
  local totalPoint = 8
  local pointConfigs = GameConfig.GVGSandTable.MapConfig.NodePos
  local staticCity = GvgProxy.GetStrongHoldStaticData(self.curMapID)
  local mode = staticCity and staticCity.Model or 1
  pointConfigs = pointConfigs[mode]
  self.nodeCells = {}
  for i = 1, totalPoint do
    local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("GVGSandTablePointCell"), self.frontPanel)
    cellpfb.name = "GVGSandTablePointCell" .. i
    local singleCtrl = GVGSandTablePointCell.new(cellpfb)
    singleCtrl:SetPos(pointConfigs[i])
    singleCtrl:SetEnable(false)
    singleCtrl:SetHPSliderEnable(false)
    self.nodeCells[i] = singleCtrl
  end
  local crystalPfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("GVGSandTablePointCell"), self.frontPanel)
  crystalPfb.name = "CrystalPoint"
  self.crystalCell = GVGSandTablePointCell.new(crystalPfb)
  self.crystalCell:SetPos(pointConfigs[0])
  self.crystalCell:SetHPSliderEnable(true)
  self:TryAddMvpSandNode()
end

function GVGSandTablePanel:TryAddMvpSandNode()
  if self.mvpCell then
    return
  end
  local cell_prefab = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("GVGSandMvpCell"), self.frontPanel)
  cell_prefab.name = "GVGSandMvpCell"
  self.mvpCell = GVGSandMvpCell.new(cell_prefab)
end

function GVGSandTablePanel:RefreshTimeCountDown()
  local leftDay, leftHour, leftMin, leftSec = ClientTimeUtil.GetFormatRefreshTimeStr(self.endTimeStamp)
  if leftDay <= 0 and leftHour <= 0 and leftMin <= 0 and leftSec <= 0 then
    TimeTickManager.Me():ClearTick(self, 1)
    self.totalLeftTimeLabel.gameObject:SetActive(false)
    MsgManager.ShowMsgByID(31043)
    self:CloseSelf()
  else
    self.totalLeftTimeLabel.text = string.format(ZhString.GVGSandTable_TimeLeft, leftMin, leftSec)
  end
end

function GVGSandTablePanel:RefreshPerfectCountDown()
  if not self.perfectTimeInfo then
    self:Hide(self.timeLabel)
    return
  end
  self:Show(self.timeLabel)
  local left_time
  if self.perfectTimeInfo.pause then
    left_time = self.perfectTimeInfo.time
  else
    left_time = self.perfectTimeInfo.time - ServerTime.CurServerTime() / 1000
  end
  local leftMin, leftSec = ClientTimeUtil.GetFormatSecTimeStr(left_time)
  if leftMin and 0 < leftMin then
    self:Show(self.timeLabel)
    self.timeLabel.text = string.format(ZhString.GVGSandTable_PerfectSpareTimeLeft, leftMin)
  else
    self:Hide(self.timeLabel)
  end
end

function GVGSandTablePanel:RefreshValidTime()
  if ServerTime.CurServerTime() / 1000 >= self.nextRefeshValidTimeStamp then
    ServiceUserEventProxy.Instance:CallGvgSandTableEvent(true)
    self.nextRefeshValidTimeStamp = ServerTime.CurServerTime() / 1000 + 10
  end
end

function GVGSandTablePanel:RefreshPage()
  local staticCity = GvgProxy.GetStrongHoldStaticData(self.curMapID)
  self.titleLabel.text = staticCity and staticCity.Name or "???"
  local curMapInfo = GvgProxy.Instance:GetSandTableInfoByID(self.curMapID)
  if not curMapInfo then
    redlog("无数据")
    for i = 1, 8 do
      self.nodeCells[i]:SetEnable(false)
    end
    local mainCrystalData = {has_occupied = true, id = 0}
    self.crystalCell:SetData(mainCrystalData)
    self.crystalCell:SetColor(0)
    self.crystalCell:SetMainCrystalHP(100)
    self.anchorLeftBottom:SetActive(false)
    self.sendMessagePart:SetActive(false)
    self.timeLabel.gameObject:SetActive(false)
    return
  end
  local hasPointScore
  local metalHP = curMapInfo.metalhp or 100
  local defGuild = curMapInfo.defguild
  local mainCrystalData = {
    guildData = defGuild,
    has_occupied = metalHP ~= 0,
    id = 0
  }
  self.crystalCell:SetData(mainCrystalData, defGuild)
  self.crystalCell:SetMainCrystalHP(metalHP)
  if self.mvpCell then
    self.mvpCell:SetData(curMapInfo)
  end
  local noMoreMetal = GvgProxy.Instance:noMoreMetal()
  local pointInfos = curMapInfo.points
  local static_data = GvgProxy.GetStrongHoldStaticData(self.curMapID)
  local pointConfig = static_data.Point
  local pointConfigs = GameConfig.GVGSandTable.MapConfig.NodePos[static_data.Mode]
  for i = 1, 8 do
    if pointConfig and pointConfig[i] then
      self.nodeCells[i]:SetEnable(true)
      self.nodeCells[i]:SetPos(pointConfigs[i])
      if pointInfos[i] then
        self.nodeCells[i]:SetData(pointInfos[i], defGuild, noMoreMetal, hasPointScore)
      else
        self.nodeCells[i]:SetEmpty(noMoreMetal)
      end
    else
      self.nodeCells[i]:SetEnable(false)
    end
  end
  local state = curMapInfo.cityState or 6
  local city_state_perfect = state == GuildCmd_pb.EGCITYSTATE_PERFECT
  self.perfect_DefendLab.gameObject:SetActive(city_state_perfect)
  self.forceStateLabel.text = gvgConfig.gvg_sandtable_status_desc and gvgConfig.gvg_sandtable_status_desc[state] or ""
  self.atkForceLabel.text = string.format(ZhString.GVGSandTable_AtkForce, curMapInfo.attacknum or "-")
  self.defForceLabel.text = string.format(ZhString.GVGSandTable_DefForce, curMapInfo.defensenum or "-")
  local topGuilds = curMapInfo.topGuilds
  if topGuilds and 0 < #topGuilds then
    for i = 1, #topGuilds do
      local guildInfo = topGuilds[i]
      self.ranks[i].guildName.text = guildInfo.name
      local guildportrait = tonumber(guildInfo.image) or 1
      guildportrait = Table_Guild_Icon[guildportrait] and Table_Guild_Icon[guildportrait].Icon or ""
      IconManager:SetGuildIcon(guildportrait, self.ranks[i].guildIcon)
    end
  end
  local raidStatus = curMapInfo.raidstate
  local is_perfect = raidStatus == FuBenCmd_pb.EGVGRAIDSTATE_PERFECT
  self.perfectTimeInfo = curMapInfo.perfectTimeInfo
  redlog("打印perfectTimeInfo")
  TableUtil.Print(self.perfectTimeInfo)
  if is_perfect then
    self.timeLabel.gameObject:SetActive(false)
    self:SetPerfectSpareStatus(true)
  elseif raidStatus == FuBenCmd_pb.EGVGRAIDSTATE_CALM then
    self.timeLabel.gameObject:SetActive(false)
  else
    self:SetPerfectSpareStatus(false)
    self:RefreshPerfectCountDown()
  end
  self:SetPerfectPart(city_state_perfect, curMapInfo)
  self.mvpAliveLab.gameObject:SetActive(nil ~= curMapInfo.MvpAlive and curMapInfo:MvpAlive() and city_state_perfect)
end

function GVGSandTablePanel:SetPerfectSpareStatus(bool)
  self.anchorLeftBottom:SetActive(not bool)
  self.sendMessagePart:SetActive(not bool)
end

function GVGSandTablePanel:SetPerfectPart(is_perfect, data)
  local no_mvp = self:CheckMvpNone(data)
  if no_mvp and is_perfect then
    self:Show(self.perfectDefendPart)
  else
    self:Hide(self.perfectDefendPart)
  end
end

function GVGSandTablePanel:CheckMvpNone(gvgSandTableData)
  local config = GameConfig.GvgNewConfig.city_type_to_mvp
  if not gvgSandTableData.mvp or not config then
    return true
  end
  local city_type = gvgSandTableData.staticData and gvgSandTableData.staticData.CityType
  if city_type and config[city_type] then
    return gvgSandTableData.mvp.mvp_state == GvgProxy.EMvpState.Die
  else
    return true
  end
end

function GVGSandTablePanel:HandleGvgSandTableUpdate()
  local sandTableInfo = GvgProxy.Instance.GvgSandTableInfo
  local gvgGroup = sandTableInfo.group and GvgProxy.ClientGroupId(sandTableInfo.group)
  self.battleLineLabel.text = string.format(ZhString.GVGSandTable_GVGGroup, gvgGroup)
  self.endTimeStamp = sandTableInfo.endtime
  TimeTickManager.Me():ClearTick(self, 1)
  TimeTickManager.Me():CreateTick(0, 1000, self.RefreshTimeCountDown, self, 1)
  self:RefreshPage()
end

function GVGSandTablePanel:SendMessage(Channel)
  if self.nextMessageValidTime and ServerTime.CurServerTime() / 1000 < self.nextMessageValidTime then
    MsgManager.ShowMsgByID(31046)
    return
  end
  local curMapInfo = GvgProxy.Instance:GetSandTableInfoByID(self.curMapID)
  local state = curMapInfo.cityState or 6
  local stateStr = gvgConfig.gvg_sandtable_status_desc and gvgConfig.gvg_sandtable_status_desc[state] or ""
  local staticCity = GvgProxy.GetStrongHoldStaticData(self.curMapID)
  local message1 = string.format(ZhString.GVGSandTable_Report1, staticCity.Name, stateStr, curMapInfo.attacknum, curMapInfo.defensenum)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.ChatRoomPage,
    viewdata = {key = "Channel", channel = Channel}
  })
  self:FuncSendMsg(message1)
  if state ~= 6 or state ~= 7 then
    local topGuilds = curMapInfo.topGuilds
    if topGuilds and 0 < #topGuilds then
      local str = ""
      for i = 1, #topGuilds do
        str = str .. topGuilds[i].name
        if i < #topGuilds then
          str = str .. ZhString.ItemTip_ChAnd
        end
      end
      local message2 = string.format(ZhString.GVGSandTable_Report2, str)
      self:FuncSendMsg(message2)
    end
  end
  self.nextMessageValidTime = ServerTime.CurServerTime() / 1000 + 10
end

function GVGSandTablePanel:FuncSendMsg(text)
  local length = StringUtil.Utf8len(text)
  if length < InputLimitMaxCount then
    GameFacade.Instance:sendNotification(ChatRoomEvent.AutoSendMessageEvent, text)
  else
    local loopCount = 0
    local leftStr = text
    while StringUtil.Utf8len(leftStr) > 0 do
      if 5 < loopCount then
        redlog("超5次了 咋回事啊")
        break
      end
      if StringUtil.Utf8len(leftStr) > InputLimitMaxCount then
        local partText = StringUtil.getTextByIndex(leftStr, loopCount * InputLimitMaxCount + 1, (loopCount + 1) * InputLimitMaxCount)
        GameFacade.Instance:sendNotification(ChatRoomEvent.AutoSendMessageEvent, partText)
        leftStr = StringUtil.getTextByIndex(leftStr, (loopCount + 1) * InputLimitMaxCount + 1)
      else
        GameFacade.Instance:sendNotification(ChatRoomEvent.AutoSendMessageEvent, leftStr)
        leftStr = ""
      end
      loopCount = loopCount + 1
    end
  end
end

function GVGSandTablePanel:IsShowGVG()
  local _GuildProxy = GuildProxy.Instance
  if _GuildProxy:DoIHaveMercenaryGuild() then
    return true
  end
  local num = _GuildProxy:GetMyGuildMercenaryNum()
  if num ~= nil and 0 < num then
    return true
  end
  return false
end

function GVGSandTablePanel:OnEnter()
  GVGSandTablePanel.super.OnEnter(self)
  GvgProxy.Instance:QueryCityInfo()
  for obj, texName in pairs(GVGSandTablePanel.TexObjTexNameMap) do
    if self[obj] then
      PictureManager.Instance:SetUI(texName, self[obj])
    end
  end
  self:sendNotification(UIEvent.CloseUI, UIViewType.DialogLayer)
  xdlog("申请沙盘")
  ServiceUserEventProxy.Instance:CallGvgSandTableEvent(true)
  self.nextRefeshValidTimeStamp = ServerTime.CurServerTime() / 1000 + 10
  TimeTickManager.Me():ClearTick(self, 2)
  TimeTickManager.Me():CreateTick(0, 1000, self.RefreshValidTime, self, 2)
end

function GVGSandTablePanel:OnExit()
  if self.mvpCell then
    self.mvpCell:ClearTick()
  end
  TimeTickManager.Me():ClearTick(self)
  for obj, texName in pairs(GVGSandTablePanel.TexObjTexNameMap) do
    if self[obj] then
      PictureManager.Instance:UnLoadUI(texName, self[obj])
    end
  end
  GVGSandTablePanel.super.OnExit(self)
end

function GVGSandTablePanel:RegisterGuide()
end
