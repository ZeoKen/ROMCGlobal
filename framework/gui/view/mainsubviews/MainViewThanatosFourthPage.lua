MainViewThanatosFourthPage = class("MainViewThanatosFourthPage", SubMediatorView)
autoImport("MemberSelectCell")
autoImport("MissionCommandMove")
autoImport("BossHeadCell")
autoImport("PlayerInfoCell")
autoImport("PlayerInfoData")
autoImport("RaidBuffCell")
autoImport("FloatNormalTip")
local originRaidInfo = LuaVector3(-160, 28, 0)
local originBuffInfo = LuaVector3(-185, -57, 0)
local extendBuffInfo = LuaVector3(-428, -57, 0)
local shortBuffInfo = LuaVector3(-408, -57, 0)
local extendPlayerInfoBG = 235
local shortPlayerInfoBG = 215
local GroupRaidInstance, NSceneNpcInstance
local singleHeight = 25

function MainViewThanatosFourthPage:Show(tarObj)
  self:TryInit()
  MainViewThanatosFourthPage.super.Show(self, tarObj)
  self.isIn = true
  self.myguid = Game.Myself.data.id
  FunctionBuff.Me():AddInterest(self.SanityBuff)
  FunctionBuff.Me():AddInterest(self.countdownBuffID)
  FunctionBuff.Me():AddInterest(self.GoOuterCDBuff)
  self.playerListBg.gameObject:SetActive(false)
  if not self.buffListDatas then
    self.buffListDatas = {}
  else
    TableUtility.ArrayClear(self.buffListDatas)
  end
  if not self.buffmap then
    self.buffmap = {}
  else
    TableUtility.TableClear(self.buffmap)
  end
  self:ResetBuffData()
  self:ReParent()
  local bufflayer = Game.Myself and Game.Myself.data:GetBuffLayer(self.SanityBuff)
  self:UpdateMySanity(bufflayer)
  self:UpdateCountDown()
  ServiceFuBenCmdProxy.Instance:CallQueryTeamGroupRaidUserInfo()
  local uniteTeam = TeamProxy.Instance:GetGroupUniteTeamData()
  if not uniteTeam then
    ServiceSessionTeamProxy.Instance:CallQueryMemberTeamCmd(TeamProxy.Instance.myTeam.uniteteamid)
  end
  for i = 1, #self.attentionBuffs do
    FunctionBuff.Me():AddInterest(self.attentionBuffs[i])
  end
  self:InitShowData()
end

function MainViewThanatosFourthPage:Hide(target)
  MainViewThanatosFourthPage.super.Hide(self, target)
  self.isIn = false
  self.inited = false
  self.raidinfo.transform.parent = self.gameObject.transform
  FunctionBuff.Me():RemoveInterest(self.SanityBuff)
  FunctionBuff.Me():RemoveInterest(self.countdownBuffID)
  FunctionBuff.Me():RemoveInterest(self.GoOuterCDBuff)
  self:CancelLockCall()
  if self.playerListCtr then
    self.playerListCtr:RemoveAll()
  end
  if self.bufflistCtrl then
    self.bufflistCtrl:RemoveAll()
  end
  if self.playerinfodata then
    TableUtility.TableClear(self.playerinfodata)
  end
  for i = 1, #self.attentionBuffs do
    FunctionBuff.Me():RemoveInterest(self.attentionBuffs[i])
  end
  self:ClearShowData()
  self:ClearTimeTick()
end

function MainViewThanatosFourthPage:Init()
  self:AddViewEvts()
  GroupRaidInstance = GroupRaidProxy.Instance
  NSceneNpcInstance = NSceneNpcProxy.Instance
end

function MainViewThanatosFourthPage:TryInit()
  if not self.loaded then
    local container = self:FindGO("MainViewThanatosPage")
    self:ReLoadPerferb("view/MainViewThanatosFourthPage")
    self:ResetParent(container)
    self.loaded = true
  end
  if not self.inited then
    self:InitConfig()
    self:FindObjs()
    self.inited = true
  else
    self.toggleteam = false
    self.toggletopfunc = false
    self.toggleraid = false
    self.toggle = true
  end
end

function MainViewThanatosFourthPage:InitConfig()
  self.curmapid = SceneProxy.Instance:GetCurRaidID()
  self.tgConfig = Table_TeamGroupRaid[self.curmapid]
  self.isInnerRaid = false
  if not self.tgConfig then
    for k, v in pairs(Table_TeamGroupRaid) do
      if v.InnerRaidID and v.InnerRaidID == self.curmapid then
        self.tgConfig = v
        self.isInnerRaid = true
        break
      end
    end
  end
  if self.tgConfig then
    self.ConfigThanatos = GameConfig.Thanatos[self.tgConfig.Difficulty]
    self.SanityBuff = self.ConfigThanatos.MadBuffID
    self.countdownBuffID = self.ConfigThanatos.DeadorAliveBuffID
    self.MadBuffLimit = self.ConfigThanatos.MadBuffLimit
    self.attentionBuffs = self.ConfigThanatos.AttentionFourthBuffID
    self.GoOuterCDBuff = self.ConfigThanatos.GoOuterCDBuff
  end
end

function MainViewThanatosFourthPage:FindObjs()
  self.curmapid = SceneProxy.Instance:GetCurRaidID()
  self.bossIDList = self.tgConfig.BossID
  self.cellGO = self:FindGO("BossHeadCell")
  local single = BossHeadCell.new(self.cellGO)
  self.bossCell = single
  self.cellGO:SetActive(false)
  self:AddClickEvent(self.cellGO, function()
    single:OnClick()
  end)
  local PlayerInfoBtn = self:FindGO("PlayerInfoBtn")
  self.toggle = true
  self:AddClickEvent(PlayerInfoBtn, function()
    if self.call_lock then
      return
    end
    self:LockCall()
    ServiceFuBenCmdProxy.Instance:CallQueryGroupRaidFourthShowData(self.toggle)
    self.playerListBg.gameObject:SetActive(self.toggle)
    if not self.toggle and self.playerListCtr then
      self.playerListCtr:RemoveAll()
    end
    self.toggle = not self.toggle
    if not self.toggle then
      if self.raidStage == 2 or self.isInnerRaid then
        self.buffinfo.transform.localPosition = extendBuffInfo
      else
        self.buffinfo.transform.localPosition = shortBuffInfo
      end
    else
      self.buffinfo.transform.localPosition = originBuffInfo
    end
    self:SetUpShowdata()
  end)
  local playerList = self:FindGO("PlayerList"):GetComponent(UIGrid)
  self.playerListCtr = UIGridListCtrl.new(playerList, PlayerInfoCell, "PlayerInfoCell")
  self.playerListBg = self:FindGO("PlayerListBg"):GetComponent(UISprite)
  self.countDown = self:FindGO("CountDown")
  self.timer = self:FindGO("timer", self.countDown):GetComponent(UILabel)
  self.count = self:FindGO("Count")
  self.innerNum = self:FindGO("innerNum"):GetComponent(UILabel)
  self.outerNum = self:FindGO("outerNum"):GetComponent(UILabel)
  self.buffinfo = self:FindGO("BuffInfo")
  self.bufflist = self:FindGO("BuffList"):GetComponent(UIGrid)
  self.bufflistCtrl = UIGridListCtrl.new(self.bufflist, RaidBuffCell, "RaidBuffCell")
  self.bufflistBg = self:FindGO("BuffListBg"):GetComponent(UISprite)
  self.bufflistCtrl:AddEventListener(RaidBuffCellEvent.BuffEnd, self.RemoveTimeEndBuff, self)
  self.bufflistCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickBuffEvent, self)
  self.teleportCD = self:FindGO("TeleportCD")
  local teleportCDLabel = self:FindGO("TeleportCDLabel", self.teleportCD):GetComponent(UILabel)
  teleportCDLabel.text = ZhString.Thanatos_GoOuterCD
  self.teleportCDtimer = self:FindGO("TeleportCDtimer", self.teleportCD):GetComponent(UILabel)
  self.teleportCD:SetActive(false)
end

function MainViewThanatosFourthPage:ReParent()
  local thanatosParent = self.gameObject.transform.parent
  self.raidinfo = self:FindGO("RaidInfo")
  local raidinfoParent = Game.GameObjectUtil:DeepFindChild(thanatosParent.gameObject, "RaidInfo")
  self.raidinfo.transform.parent = raidinfoParent.gameObject.transform
  self.raidinfo.transform.localPosition = originRaidInfo
end

function MainViewThanatosFourthPage:AddViewEvts()
  self:AddListenEvt(SceneUserEvent.SceneAddNpcs, self.HandleAddNpc)
  self:AddListenEvt(SceneUserEvent.SceneRemoveNpcs, self.HandleRemoveNpc)
  self:AddListenEvt(ServiceEvent.NUserNpcDataSync, self.HandleSyncNpc)
  self:AddListenEvt(ServiceEvent.NUserUserBuffNineSyncCmd, self.HandleBuff)
  self:AddListenEvt(ServiceEvent.FuBenCmdQueryGroupRaidFourthShowData, self.HandleShowdata)
  self:AddListenEvt(ServiceEvent.FuBenCmdUpdateGroupRaidFourthShowData, self.HandleShowdata)
  self:AddListenEvt(ServiceEvent.FuBenCmdRaidStageSyncFubenCmd, self.UpdateView)
end

function MainViewThanatosFourthPage:ResetParent(parent)
  if not parent then
    return
  end
  self.trans:SetParent(parent.transform, false)
end

function MainViewThanatosFourthPage:HandleAddNpc(note)
  if not self.isIn then
    return
  end
  local data = note.body
  if data then
    local npcData
    for i = 1, #data do
      npcData = data[i].data
      local staticid = npcData.staticData.id
      for i = 1, #self.bossIDList do
        if staticid == self.bossIDList[i] then
          if not self.isInnerRaid then
            self.bossCell:SetData(staticid, npcData.id)
            self.bossGuid = npcData.id
            self.cellGO:SetActive(true)
            self:UpdateHP()
          else
            self.cellGO:SetActive(false)
          end
        end
      end
      if staticid == self.ConfigThanatos.DeadBufflay then
        self.countDownNPC = npcData.id
      elseif staticid == self.ConfigThanatos.GoOuterNpcID then
        self.teleportCDNPC = npcData.id
      end
    end
  end
end

function MainViewThanatosFourthPage:HandleRemoveNpc(note)
  if not self.isIn then
    return
  end
  local data = note.body
  local flag = false
  if data then
    for i = 1, #data do
      if self.bossGuid == data[i] then
        if not self.isInnerRaid then
          self.bossCell:UpdateHP(self.bossGuid)
        end
        self.cellGO:SetActive(false)
      end
      if self.countDownNPC == data[i] then
        self.countDown:SetActive(false)
      elseif self.teleportCDNPC == data[i] then
        self.teleportCD:SetActive(false)
      end
    end
  end
end

function MainViewThanatosFourthPage:HandleSyncNpc(note)
  if not self.isIn then
    return
  end
  local data = note.body
  if data and data.guid == self.bossGuid and #data.attrs > 0 then
    self:UpdateHP()
  end
end

function MainViewThanatosFourthPage:UpdateHP()
  if self.bossCell and not self.isInnerRaid then
    self.bossCell:UpdateHP(self.bossGuid)
  end
end

function MainViewThanatosFourthPage:HandleBuff(note)
  if not self.isIn then
    return
  end
  local data = note.body
  if data then
    local flag = false
    local buffs = data.updates or {}
    local deleteBuffs = data.dels or {}
    local updateFlag = false
    for i = 1, #buffs do
      if buffs[i].id == self.SanityBuff then
        if data.guid == self.myguid then
          self:UpdateMySanity(buffs[i].layer)
        end
        updateFlag = updateFlag or true
        self:UpdateBuffLayerByScene(data.guid, buffs[i].layer)
      elseif buffs[i].id == self.countdownBuffID then
        if data.guid == self.countDownNPC then
          self:UpdateCountDown(buffs[i].layer)
        end
      elseif buffs[i].id == self.GoOuterCDBuff then
        if data.guid == self.teleportCDNPC then
          self:StartTeleportCD(buffs[i].time)
        end
      elseif data.guid == self.myguid then
        for k, v in pairs(self.attentionBuffs) do
          if buffs[i].id == v then
            flag = flag or true
            local single = {
              id = v,
              staticData = Table_Buffer[v],
              starttime = ServerTime.CurServerTime(),
              endtime = buffs[i].time
            }
            if single.endtime == 0 then
              single.endtime = nil
            end
            self.buffmap[v] = single
          end
        end
        if flag then
          self:ResetBuffData()
        end
      end
    end
    for i = 1, #deleteBuffs do
      flag = false
      if deleteBuffs[i] == self.SanityBuff then
        updateFlag = updateFlag or true
        if data.guid == self.myguid then
          self:UpdateMySanity(0)
        end
        self:UpdateBuffLayerByScene(data.guid, 0)
      elseif deleteBuffs[i] == self.countdownBuffID then
        if data.guid == self.countDownNPC then
          self:UpdateCountDown(0)
        end
      elseif deleteBuffs[i] == self.GoOuterCDBuff then
        if data.guid == self.GoOuterNpcID then
          self:ClearTimeTick()
        end
      elseif data.guid == self.myguid then
        for k, v in pairs(self.attentionBuffs) do
          if deleteBuffs[i] == v then
            flag = flag or true
            self.buffmap[v] = nil
          end
        end
        if flag then
          self:ResetBuffData()
        end
      end
    end
    if updateFlag and not self.toggle then
      self:PlayerListResetDatas()
    end
  end
end

function MainViewThanatosFourthPage:ResetBuffData()
  TableUtility.ArrayClear(self.buffListDatas)
  for _, bData in pairs(self.buffmap) do
    table.insert(self.buffListDatas, bData)
  end
  table.sort(self.buffListDatas, function(a, b)
    self:_SortBuffData(a, b)
  end)
  self.bufflistCtrl:ResetDatas(self.buffListDatas)
  self.bufflistBg.gameObject:SetActive(#self.buffListDatas ~= 0)
  self.bufflistBg.height = 10 + 60 * #self.buffListDatas
  self.bufflist:Reposition()
  if #self.buffListDatas ~= 0 then
    if not self.toggle then
      if self.raidStage == 2 or self.isInnerRaid then
        self.buffinfo.transform.localPosition = extendBuffInfo
      else
        self.buffinfo.transform.localPosition = shortBuffInfo
      end
    else
      self.buffinfo.transform.localPosition = originBuffInfo
    end
  end
end

local STORAGE_FAKE_ID = "storage_fake_id"

function MainViewThanatosFourthPage:_SortBuffData(a, b)
  if a.isalways ~= nil or b.isalways ~= nil then
    return a.isalways == true
  end
  if a.id == STORAGE_FAKE_ID or b.id == STORAGE_FAKE_ID then
    return a.id == STORAGE_FAKE_ID
  end
  local aBuffCfg = Table_Buffer[a.id]
  local bBuffCfg = Table_Buffer[b.id]
  if aBuffCfg and bBuffCfg then
    local aIsDeBuff = aBuffCfg.BuffType.isgain == 0
    local bIsDeBuff = bBuffCfg.BuffType.isgain == 0
    if aIsDeBuff ~= bIsDeBuff then
      return aIsDeBuff
    end
    if aBuffCfg.IconType and bBuffCfg.IconType then
      if aBuffCfg.IconType ~= bBuffCfg.IconType then
        return aBuffCfg.IconType > bBuffCfg.IconType
      end
      if aBuffCfg.IconType == 1 and bBuffCfg.IconType == 1 and a.endtime and b.endtime and a.endtime and b.endtime then
        return a.starttime < b.starttime
      end
    end
  end
  return a.id < b.id
end

function MainViewThanatosFourthPage:RemoveTimeEndBuff(buffdata)
  local id = buffdata.id
  for k, v in pairs(self.attentionBuffs) do
    if id == v then
      self.buffmap[v] = nil
    end
  end
  self:ResetBuffData()
end

function MainViewThanatosFourthPage:ClickBuffEvent(cellCtl)
  local data = cellCtl.data
  if data then
    local staticData = data and data.staticData
    local oriDec = staticData and staticData.BuffDesc or ""
    TipsView.Me():ShowStickTip(FloatNormalTip, oriDec, NGUIUtil.AnchorSide.DownRight, cellCtl.icon, {30, 0})
    TipsView.Me().currentTip:SetUpdateSetText(1000, MainViewInfoPage.UpdateBuffTip, data)
  end
end

function MainViewThanatosFourthPage:UpdateMySanity(bufflayer)
  local value = bufflayer / (self.MadBuffLimit or 100)
  local sceneUI = Game.Myself:GetSceneUI() or nil
  if sceneUI then
    sceneUI.roleBottomUI:UpdateSanity(ncreature, value)
  end
end

function MainViewThanatosFourthPage:UpdateCountDown(bufflayer)
  if not bufflayer or bufflayer == 0 then
    self.countDown:SetActive(false)
    return
  elseif not self.countDown.activeInHierarchy then
    self.countDown:SetActive(true)
  end
  self.timer.text = string.format("%ds", bufflayer)
end

function MainViewThanatosFourthPage:LockCall()
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

function MainViewThanatosFourthPage:CancelLockCall()
  if not self.call_lock then
    return
  end
  self.call_lock = false
  if self.lock_lt then
    self.lock_lt:Destroy()
    self.lock_lt = nil
  end
end

function MainViewThanatosFourthPage:SetUpShowdata()
  if not self.isIn then
    return
  end
  local myTeam = TeamProxy.Instance.myTeam
  local uniteTeam = TeamProxy.Instance:GetGroupUniteTeamData()
  if self.playerinfodata then
    TableUtility.TableClear(self.playerinfodata)
  end
  if myTeam then
    self:BuildMembers(myTeam)
  end
  if uniteTeam then
    self:BuildMembers(uniteTeam)
  end
  if not self.toggle then
    self:PlayerListResetDatas()
  end
end

function MainViewThanatosFourthPage:BuildMembers(teamdata)
  if not self.playerinfodata then
    return
  end
  local mem = {}
  mem = teamdata:GetPlayerMemberList(true, true)
  if not mem then
    return
  end
  local memberData
  for i = 1, #mem do
    local single = {}
    memberData = mem[i]
    single.charid = memberData.id
    if self.playerinfodata[single.charid] then
      self.playerinfodata[single.charid]:UpdateData(memberData.profession, memberData.name)
    else
      single.profession = memberData and memberData.profession or 0
      single.name = memberData and memberData.name or ""
      local newEntry = PlayerInfoData.new()
      newEntry:SetData(single)
      self.playerinfodata[single.charid] = newEntry
    end
  end
end

function MainViewThanatosFourthPage:PlayerListResetDatas()
  local memberlist = {}
  for k, v in pairs(self.playerinfodata) do
    table.insert(memberlist, self.playerinfodata[k])
  end
  self.playerListCtr:ResetDatas(memberlist)
  self.playerListBg.height = singleHeight * (#memberlist or 0)
  if self.raidStage == 2 or self.isInnerRaid then
    self.playerListBg.width = extendPlayerInfoBG
  else
    self.playerListBg.width = shortPlayerInfoBG
  end
end

local tempValue = 0

function MainViewThanatosFourthPage:UpdateBuffLayerByScene(guid, bufflayer)
  if not self.isIn then
    return
  end
  if self.playerinfodata and self.playerinfodata[guid] then
    tempValue = bufflayer / self.MadBuffLimit
    self.playerinfodata[guid]:UpdateBuffLayer(tempValue)
  end
end

function MainViewThanatosFourthPage:UpdateInnerOuter(guid, IO)
  if not self.isIn then
    return
  end
  if self.playerinfodata and self.playerinfodata[guid] then
    self.playerinfodata[guid]:UpdateInnerOuterStatus(IO)
  end
end

function MainViewThanatosFourthPage:InitShowData()
  self.showdatas = ReusableTable.CreateArray()
  self.innerdatas = ReusableTable.CreateArray()
  self.outerdatas = ReusableTable.CreateArray()
  self.playerinfodata = ReusableTable.CreateTable()
end

function MainViewThanatosFourthPage:ClearShowData()
  if self.innerdatas then
    ReusableTable.DestroyAndClearArray(self.innerdatas)
  end
  if self.outerdatas then
    ReusableTable.DestroyAndClearArray(self.outerdatas)
  end
  if self.showdatas then
    ReusableTable.DestroyAndClearArray(self.showdatas)
  end
  if self.playerinfodata then
    ReusableTable.DestroyAndClearArray(self.playerinfodata)
  end
end

function MainViewThanatosFourthPage:HandleShowdata(note)
  if not self.isIn then
    return
  end
  if self.raidStage ~= 2 then
    return
  end
  if note and note.body then
    if self.showdatas then
      TableUtility.ArrayClear(self.showdatas)
    end
    TableUtility.ArrayShallowCopy(self.showdatas, note.body)
    if self.innerdatas then
      TableUtility.ArrayClear(self.innerdatas)
    end
    if self.outerdatas then
      TableUtility.ArrayClear(self.outerdatas)
    end
    if note.body.inner then
      TableUtility.ArrayShallowCopy(self.innerdatas, note.body.inner)
      self.innerCount = #self.innerdatas
      for i = 1, #self.innerdatas do
        local charid = self.innerdatas[i].charid
        self:UpdateBuffLayerByScene(charid, self.innerdatas[i].layer)
        self:UpdateInnerOuter(self.innerdatas[i].charid, 0)
      end
    end
    if note.body.outer then
      TableUtility.ArrayShallowCopy(self.outerdatas, note.body.outer)
      self.outerCount = #self.outerdatas
      for i = 1, #self.outerdatas do
        local charid = self.outerdatas[i].charid
        self:UpdateBuffLayerByScene(charid, self.outerdatas[i].layer)
        self:UpdateInnerOuter(charid, 1)
      end
    end
  end
  if not self.toggle then
    self:PlayerListResetDatas()
  end
  self:UpdateCount()
end

function MainViewThanatosFourthPage:UpdateView(note)
  redlog("UpdateView", self.isIn)
  if not self.isIn then
    return
  end
  if note and note.body then
    self.raidStage = note.body.stage
    self.count:SetActive(self.raidStage == 2 or self.isInnerRaid)
    self.innerNum.text = self.innerCount or "0"
    self.outerNum.text = self.outerCount or "0"
    redlog("self.innerCount", self.innerCount)
    if self.raidStage ~= 2 then
      self:ClearStatus()
    end
  end
end

function MainViewThanatosFourthPage:ClearStatus()
  if self.playerinfodata then
    for k, v in pairs(self.playerinfodata) do
      self.playerinfodata[k]:UpdateInnerOuterStatus()
    end
  end
  if not self.toggle then
    self:PlayerListResetDatas()
  end
end

function MainViewThanatosFourthPage:UpdateCount()
  self.innerNum.text = self.innerCount or "0"
  self.outerNum.text = self.outerCount or "0"
end

function MainViewThanatosFourthPage:StartTeleportCD(endtime)
  if endtime then
    self.endTime = endtime
    self.teleportCD:SetActive(true)
    self.timetick = TimeTickManager.Me():CreateTick(0, 33, self.UpdateTeleportCD, self, 20)
  else
    self.teleportCD:SetActive(false)
  end
end

local leftTime = 0

function MainViewThanatosFourthPage:UpdateTeleportCD()
  leftTime = math.max((self.endTime - ServerTime.CurServerTime()) / 1000, 0)
  self.teleportCDtimer.text = string.format("%ss", math.ceil(leftTime))
  if leftTime <= 0 then
    self:ClearTimeTick()
  end
end

function MainViewThanatosFourthPage:ClearTimeTick()
  if self.timetick then
    TimeTickManager.Me():ClearTick(self, 20)
    self.timetick = nil
    self.teleportCD:SetActive(false)
  end
end
