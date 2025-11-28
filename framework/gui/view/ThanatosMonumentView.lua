ThanatosMonumentView = class("ThanatosMonumentView", ContainerView)
ThanatosMonumentView.ViewType = UIViewType.NormalLayer
autoImport("ThanatosBossCell")
autoImport("ThanastosPlayerCell")
autoImport("ThanatosGuildCell")
autoImport("RaidLogData")
local TabConfig = {
  [1] = ZhString.ThanatosMonument_PlayerTab,
  [2] = ZhString.ThanatosMonument_GuildTab
}
local playerTipFunc = {
  "SendMessage",
  "AddFriend",
  "ShowDetail"
}
local RaidConfig = GameConfig.FirstKill and GameConfig.FirstKill.ThanatosRaidLogs
local ComodoRaidCfg = GameConfig.FirstKill and GameConfig.FirstKill.ComodoRaidLogs
local sevenRoyalRaidCfg = GameConfig.FirstKill and GameConfig.FirstKill.SevenRoyalRaidLogs
local RaidLogType = GameConfig.FirstKill.RaidLogType
local AllRaidConfig = {
  RaidConfig,
  ComodoRaidCfg,
  sevenRoyalRaidCfg
}
local tipOffset = {-81, 60}

function ThanatosMonumentView:OnEnter()
  ThanatosMonumentView.super.OnEnter(self)
  self.curType = 1
  self:OnTypeChanged(true)
end

function ThanatosMonumentView:OnExit()
  PictureManager.Instance:UnLoadUI("boss_hero_bg", self.bossBG)
  PictureManager.Instance:UnLoadUI("Ranking List_bg", self.contentbg)
  self:ClearPlayerTipDatas()
  ThanatosMonumentView.super.OnExit(self)
end

function ThanatosMonumentView:OnDestroy()
  if self.thanatosGuildCell then
    self.thanatosGuildCell:OnCellDestroy()
  end
  ThanatosMonumentView.super.OnDestroy(self)
end

function ThanatosMonumentView:Init()
  self.currentRaids = {}
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
  self:Init3DModel()
end

function ThanatosMonumentView:FindObjs()
  self.bg = self:FindGO("bg"):GetComponent(UIWidget)
  self.titleBg = self:FindGO("spot"):GetComponent(UIWidget)
  self.titleTexture = self:FindGO("titleTexture"):GetComponent(UITexture)
  self.title = self:FindGO("title"):GetComponent(UILabel)
  self.banner = self:FindGO("banner")
  self.bannerLabel = self:FindGO("bannerLabel"):GetComponent(UILabel)
  self.topRankBtn = self:FindGO("TopRankBtn")
  self.tipBtn = self:FindGO("tipBtn")
  self.playerTab = self:FindGO("PlayerTab"):GetComponent(UIToggle)
  local lb = self:FindGO("Label1", self.playerTab.gameObject):GetComponent(UILabel)
  lb.text = TabConfig[1]
  lb = self:FindGO("Label2", self.playerTab.gameObject):GetComponent(UILabel)
  lb.text = TabConfig[1]
  self.guildTab = self:FindGO("GuildTab"):GetComponent(UIToggle)
  lb = self:FindGO("Label1", self.guildTab.gameObject):GetComponent(UILabel)
  lb.text = TabConfig[2]
  lb = self:FindGO("Label2", self.guildTab.gameObject):GetComponent(UILabel)
  lb.text = TabConfig[2]
  self.bossEffectContainer = self:FindGO("bossEffectContainer")
  self.bossBG = self:FindGO("bossBG"):GetComponent(UITexture)
  self.bossName = self:FindGO("bossName"):GetComponent(UILabel)
  self.bossTexture = self:FindGO("bossTexture"):GetComponent(UITexture)
  self.modelRoot = self:FindGO("ModelRoot")
  self.raidGrid = self:FindGO("raidGrid"):GetComponent(UIGrid)
  self.raidCtr = UIGridListCtrl.new(self.raidGrid, ThanatosBossCell, "ThanatosBossCell")
  self.raidCtr:AddEventListener(MouseEvent.MouseClick, self.ClickRaidTab, self)
  self.playerGrid = self:FindGO("playerGrid"):GetComponent(UIGrid)
  self.playerCtr = UIGridListCtrl.new(self.playerGrid, ThanastosPlayerCell, "ThanastosPlayerCell")
  self.playerCtr:AddEventListener(MouseEvent.MouseClick, self.ClickPlayerCell, self)
  self.thanatosGuildCellGO = self:FindGO("thanatosGuildCell")
  self.thanatosGuildCell = ThanatosGuildCell.new(self.thanatosGuildCellGO)
  self.detailLoadingRoot = self:FindGO("detailLoadingRoot")
  self.emptyTip = self:FindGO("emptyTip"):GetComponent(UILabel)
  self.contentbg = self:FindGO("contentbg1"):GetComponent(UITexture)
  self.nextBtn = self:FindGO("NextBtn")
  self.preBtn = self:FindGO("PreBtn")
end

function ThanatosMonumentView:SetChooseNpc(id)
  local cells = self.raidCtr:GetCells()
  for _, cell in pairs(cells) do
    cell:SetChoose(id)
  end
end

function ThanatosMonumentView:AddEvts()
  self:AddClickEvent(self.nextBtn, function()
    self:OnChooseNextRaid()
  end)
  self:AddClickEvent(self.preBtn, function()
    self:OnChoosePreRaid()
  end)
  self:AddClickEvent(self.playerTab.gameObject, function()
    if self.call_lock then
      return
    end
    self.currentTab = 1
    ServiceTeamGroupRaidProxy.Instance:CallQueryGroupRaidKillUserInfo(self.currentRaids)
    self:LockCall()
    self:UpdateView()
    self.topRankBtn:SetActive(false)
    self.thanatosGuildCellGO:SetActive(false)
  end)
  self:AddClickEvent(self.guildTab.gameObject, function()
    if self.call_lock then
      return
    end
    self.currentTab = 2
    ServiceTeamGroupRaidProxy.Instance:CallQueryGroupRaidKillGuildInfo(self.currentRaids)
    self:UpdateView()
    self.topRankBtn:SetActive(true)
  end)
  self:AddClickEvent(self.topRankBtn, function()
    local users = {}
    local datas = self.guildtable and self.guildtable[self.currentRaid]
    if datas then
      users = datas:GetGuildList()
    end
    if users then
      table.sort(users, function(l, r)
        return l.rank < r.rank
      end)
    end
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ThanatosGuildRankView,
      viewdata = {
        users[1],
        users[2],
        users[3]
      }
    })
  end)
  self:RegistShowGeneralHelpByHelpID(7000001, self.tipBtn)
end

function ThanatosMonumentView:LockCall()
  if self.call_lock then
    return
  end
  self.call_lock = true
  if self.lock_lt == nil then
    self.lock_lt = TimeTickManager.Me():CreateOnceDelayTick(500, function(owner, deltaTime)
      self.lock_lt = nil
      self.call_lock = false
    end, self)
  end
end

function ThanatosMonumentView:CancelLockCall()
  if not self.call_lock then
    return
  end
  self.call_lock = false
  if self.lock_lt then
    self.lock_lt:Destroy()
    self.lock_lt = nil
  end
end

function ThanatosMonumentView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.TeamGroupRaidQueryGroupRaidKillUserInfo, self.HandleGroupRaidKillUserInfo)
  self:AddListenEvt(ServiceEvent.TeamGroupRaidQueryGroupRaidKillGuildInfo, self.HandleGroupRaidKillGuildInfo)
  self:AddListenEvt(ServiceEvent.TeamGroupRaidQueryGroupRaidKillUserShowData, self.OnRecvQueryGroupRaidKillUserShowData)
end

function ThanatosMonumentView:OnChooseNextRaid()
  if self.curType >= #RaidLogType then
    self.curType = 1
  else
    self.curType = self.curType + 1
  end
  self:OnTypeChanged()
end

function ThanatosMonumentView:OnChoosePreRaid()
  if self.curType <= 1 then
    self.curType = #RaidLogType
  else
    self.curType = self.curType - 1
  end
  self:OnTypeChanged()
end

function ThanatosMonumentView:OnTypeChanged(isFirst)
  if not self.curType then
    return
  end
  self.title.text = RaidLogType[self.curType]
  self.curRaidCfg = AllRaidConfig[self.curType]
  if not self.curRaidCfg then
    return
  end
  self.currentTab = 1
  self:ReInitRaidList()
  self.currentRaid = self.raidList[1] and self.raidList[1].raidid
  ServiceTeamGroupRaidProxy.Instance:CallQueryGroupRaidKillUserInfo(self.currentRaids)
  local cell = {}
  cell.data = self.raidList[1]
  self:ClickRaidTab(cell)
  self.playerTab:Set(true)
  self.guildTab:Set(false)
  self.topRankBtn:SetActive(false)
  self.thanatosGuildCellGO:SetActive(false)
end

function ThanatosMonumentView:InitShow()
  self.bannerLabel.text = ZhString.ThanatosMonument_PlayerTitle
  PictureManager.Instance:SetUI("boss_hero_bg", self.bossBG)
  PictureManager.Instance:SetUI("Ranking List_bg", self.contentbg)
  self:RefitBgResolution()
end

function ThanatosMonumentView:ReInitRaidList()
  local curRaidCfg = self.curRaidCfg
  if not curRaidCfg then
    return
  end
  if not self.raidList then
    self.raidList = {}
  else
    TableUtility.ArrayClear(self.raidList)
  end
  TableUtility.ArrayClear(self.currentRaids)
  for i = 1, #curRaidCfg do
    local entry = RaidLogData.new()
    entry:SetData(curRaidCfg[i])
    table.insert(self.raidList, entry)
    self.currentRaids[#self.currentRaids + 1] = curRaidCfg[i].raidid
  end
  self.raidCtr:ResetDatas(self.raidList, true, true)
end

function ThanatosMonumentView:RefitBgResolution()
  self:RefitFullScreenWidgetSize(self.bg)
  self:RefitFullScreenWidgetSize(self.titleBg, true)
end

function ThanatosMonumentView:UpdateRaidList()
  if not self.raidList then
    return
  end
  local raidid = 0
  for i = 1, #self.raidList do
    raidid = self.raidList[i].raidid
    local isCleared, time, datas
    if self.currentTab == 1 then
      datas = self.playertable and self.playertable[raidid]
    elseif self.currentTab == 2 then
      datas = self.guildtable and self.guildtable[raidid]
    end
    isCleared = datas and datas ~= {}
    if datas then
      time = datas:CheckClearTime()
    end
    self.raidList[i]:UpdateRecord(isCleared, time)
  end
  self.raidCtr:ResetDatas(self.raidList)
end

function ThanatosMonumentView:ClickRaidTab(cell)
  local data = cell.data
  if data == nil then
    return
  end
  self.raidCfg = data
  self.currentRaid = data.raidid
  self:SetChooseNpc(data.npcid)
  if self.currentTab == 1 then
    self:SetPlayerList()
  else
    self:SetGuildList()
  end
  self:SetModel()
  self:UpdateView()
end

function ThanatosMonumentView:SetPlayerList()
  local datas = {}
  local users = {}
  datas = self.playertable and self.playertable[self.currentRaid]
  if datas then
    users = datas:GetUsersList()
  end
  self.playerCtr:ResetDatas(users)
  local cells = self.playerCtr:GetCells()
  for i = 1, #cells do
    cells[i]:SetView(self)
  end
  if not users or #users == 0 then
    self.emptyTip.text = ZhString.ThanatosMonument_EmptyTip
  else
    self.emptyTip.text = ""
  end
end

function ThanatosMonumentView:SetGuildList()
  local datas = {}
  local users = {}
  local guilds = {}
  datas = self.guildtable and self.guildtable[self.currentRaid]
  if datas then
    users = datas:GetUsersList() or {}
    guilds = datas:GetGuildList() or {}
  end
  self.thanatosGuildCellGO:SetActive(#guilds ~= 0)
  self.thanatosGuildCell:SetData(guilds[1])
  self.playerCtr:ResetDatas(users)
  local cells = self.playerCtr:GetCells()
  for i = 1, #cells do
    cells[i]:SetView(self)
  end
  if not users or #users == 0 then
    self.emptyTip.text = ZhString.ThanatosMonument_EmptyTip
  else
    self.emptyTip.text = ""
  end
end

function ThanatosMonumentView:HandleGroupRaidKillUserInfo(note)
  if note and note.body then
    self.datas1 = note.body[1]
    if not self.playertable then
      self.playertable = {}
    else
      TableUtility.TableClear(self.playertable)
    end
    TableUtility.TableShallowCopy(self.playertable, self.datas1)
    self:UpdateRaidList()
    self:SetPlayerList()
    self:CancelLockCall()
  end
end

function ThanatosMonumentView:HandleGroupRaidKillGuildInfo(note)
  if note and note.body then
    self.datas2 = note.body[1]
    if not self.guildtable then
      self.guildtable = {}
    else
      TableUtility.TableClear(self.guildtable)
    end
    TableUtility.TableShallowCopy(self.guildtable, self.datas2)
    self:SetGuildList()
    self:UpdateRaidList()
    self:CancelLockCall()
  end
end

function ThanatosMonumentView:Init3DModel()
  self.modelContainer = GameObject("ModelContainer")
  self.modelContainer.transform.parent = self.modelRoot.transform
  self.modelContainer.transform.localPosition = LuaGeometry.GetTempVector3()
  self.modelContainer.transform.localEulerAngles = LuaGeometry.GetTempVector3()
  self.modelContainer.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
  self.modelContainer.layer = self.modelRoot.layer
end

function ThanatosMonumentView:SetModel()
  local monsterid = self.raidCfg and self.raidCfg.npcid or 0
  local mconfig = Table_Monster[monsterid]
  if not mconfig then
    return
  end
  self.bossName.text = mconfig.NameZh
  if not self.isload then
    self:PlayUIEffect(EffectMap.UI.Eff_boss_hero_bg_ui, self.bossEffectContainer)
    self.isload = true
  end
  self.bossEffectContainer:SetActive(true)
  UIModelUtil.Instance:SetMonsterModelTexture(self.bossTexture, monsterid, nil, nil, function(obj)
    self.model = obj
    UIModelUtil.Instance:SetCellTransparent(self.bossTexture)
    local showPos = mconfig.LoadShowPose
    if showPos and #showPos == 3 then
      self.model:SetPosition(LuaGeometry.GetTempVector3(showPos[1], showPos[2], showPos[3]))
    end
    if mconfig.LoadShowRotate then
      self.model:SetEulerAngleY(mconfig.LoadShowRotate)
    end
    local otherScale = self.raidCfg and self.raidCfg.scale or 1
    self.model:SetScale(otherScale)
  end)
end

function ThanatosMonumentView:UpdateView()
  if self.currentTab == 1 then
    self.banner:SetActive(true)
  else
    self.banner:SetActive(false)
  end
end

function ThanatosMonumentView:OnClickPlayerCell(cell)
  FunctionPlayerTip.Me():CloseTip()
  local charid = cell.data.charid
  if not charid or 0 == charid then
    return
  end
  if charid == Game.Myself.data.id then
    return
  end
  self.queryCell = cell
  if not self.playerTipData then
    self.playerTipData = {}
  end
  self.detailLoadingRoot:SetActive(true)
  local param = {}
  ServiceTeamGroupRaidProxy.Instance:CallQueryGroupRaidKillUserShowData(charid, param)
  self.detailLt = TimeTickManager.Me():CreateOnceDelayTick(10000, function(owner, deltaTime)
    self.detailLt = nil
    if not Slua.IsNull(self.detailLoadingRoot) then
      self.detailLoadingRoot:SetActive(false)
    end
  end, self)
end

function ThanatosMonumentView:OnRecvQueryGroupRaidKillUserShowData(note)
  if self.detailLt then
    self.detailLt:Destroy()
    self.detailLt = nil
  end
  self.detailLoadingRoot:SetActive(false)
  local id = note.body and note.body.charid
  if not id or id == 0 then
    MsgManager.ShowMsgByID(5030)
    return
  end
  local player = PlayerTipData.new()
  local showdata = note.body.showdata
  player:SetByThanatosPlayerData(showdata)
  local tipData = ReusableTable.CreateTable()
  tipData.playerData = player
  tipData.funckeys = playerTipFunc
  self.playerTipData[id] = tipData
  self:ShowPlayerTip(tipData)
end

function ThanatosMonumentView:ShowPlayerTip(data)
  FunctionPlayerTip.Me():GetPlayerTip(self.queryCell.name, NGUIUtil.AnchorSide.Right, tipOffset, data)
end

function ThanatosMonumentView:ClearPlayerTipDatas()
  if self.playerTipData then
    for k, v in pairs(self.playerTipData) do
      if v then
        ReusableTable.DestroyAndClearTable(v)
      end
    end
  end
end
