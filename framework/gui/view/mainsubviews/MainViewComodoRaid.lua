autoImport("ComodoBossHeadCell")
autoImport("RaidBuffCell")
MainViewComodoRaid = class("MainViewComodoRaid", SubMediatorView)
local ComodeConfig = GameConfig.ComodoRaid
local OriginHideBtnPos = LuaVector3(440.5, 144.2, 0)
local ExtendHideBtnPos = LuaVector3(397, 144.2, 0)

function MainViewComodoRaid:InitShow()
  self.mainViewTrans = self.gameObject.transform.parent
  local traceInfoParent = GameObjectUtil.Instance:DeepFindChild(self.mainViewTrans.gameObject, "TraceInfoBord")
  self.trans:SetParent(traceInfoParent.transform)
  self.trans.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
end

function MainViewComodoRaid:Show()
  MainViewComodoRaid.super.Show(self)
  self.isIn = true
  FunctionBuff.Me():AddInterest(ComodeConfig.SanityBuff)
  self:ResetDatas()
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
  self:InitConfig()
  if self.attentionBuffs then
    for i = 1, #self.attentionBuffs do
      FunctionBuff.Me():AddInterest(self.attentionBuffs[i])
    end
  end
end

function MainViewComodoRaid:ResetDatas()
  self:UpdateView()
end

function MainViewComodoRaid:Init()
  self:ReLoadPerferb("view/MainViewComodoRaid")
  self.myguid = Game.Myself.data.id
  self:FindObjs()
  self:InitShow()
  self:AddViewEvents()
end

function MainViewComodoRaid:FindObjs()
  self.contentA = self:FindGO("ContentA")
  self.cellGO = self:FindGO("BossHeadCell", self.contentA)
  local single = ComodoBossHeadCell.new(self.cellGO)
  self.bossCell = single
  self.cellGO:SetActive(false)
  self:AddClickEvent(self.cellGO, function()
    single:OnClick()
  end)
  self.reviveCountA = self:FindGO("reviveCount", self.contentA):GetComponent(UILabel)
  local infoBtn = self:FindGO("infoBtn", self.contentA)
  self:AddClickEvent(infoBtn, function()
    if self.call_lock then
      return
    end
    self:LockCall()
    ServiceFuBenCmdProxy.Instance:CallQueryComodoTeamRaidStat()
  end)
  self.contentB = self:FindGO("ContentB")
  self.bossgrid = self:FindGO("bossGrid"):GetComponent(UIGrid)
  self.bossCtl = UIGridListCtrl.new(self.bossgrid, ComodoBossHeadCell, "ComodoBossHeadCell")
  self.bossCtl:AddEventListener(MouseEvent.MouseClick, self.ClickBossHead, self)
  local infoBtnb = self:FindGO("infoBtn", self.contentB)
  self.reviveCountB = self:FindGO("reviveCount", self.contentB):GetComponent(UILabel)
  self:AddClickEvent(infoBtnb, function()
    if self.call_lock then
      return
    end
    self:LockCall()
    ServiceFuBenCmdProxy.Instance:CallQueryComodoTeamRaidStat()
  end)
  self.contentEmpty = self:FindGO("ContentEmpty")
  self.reviveCountC = self:FindGO("reviveCount", self.contentEmpty):GetComponent(UILabel)
  local infoBtnC = self:FindGO("infoBtn", self.contentEmpty)
  self:AddClickEvent(infoBtnC, function()
    if self.call_lock then
      return
    end
    self:LockCall()
    ServiceFuBenCmdProxy.Instance:CallQueryComodoTeamRaidStat()
  end)
  self.buffinfo = self:FindGO("BuffInfo")
  self.bufflist = self:FindGO("BuffList"):GetComponent(UIGrid)
  self.bufflistCtrl = UIGridListCtrl.new(self.bufflist, RaidBuffCell, "RaidBuffCell")
  self.bufflistBg = self:FindGO("BuffListBg"):GetComponent(UISprite)
  self.bufflistCtrl:AddEventListener(RaidBuffCellEvent.BuffEnd, self.RemoveTimeEndBuff, self)
  self.bufflistCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickBuffEvent, self)
  self.hideBtnA = self:FindGO("HideButton", self.contentA)
  self.hideBtnB = self:FindGO("HideButton", self.contentB)
  self.hideBtnC = self:FindGO("HideButton", self.contentEmpty)
  self.contentA:SetActive(false)
  self.contentB:SetActive(false)
  self.contentEmpty:SetActive(true)
end

function MainViewComodoRaid:AddViewEvents()
  self:AddListenEvt(SceneUserEvent.SceneAddNpcs, self.HandleAddNpc)
  self:AddListenEvt(SceneUserEvent.SceneRemoveNpcs, self.HandleRemoveNpc)
  self:AddListenEvt(ServiceEvent.NUserNpcDataSync, self.HandleSyncNpc)
  self:AddListenEvt(ServiceEvent.NUserUserBuffNineSyncCmd, self.HandleBuff)
  self:AddListenEvt(ServiceEvent.FuBenCmdComodoPhaseFubenCmd, self.UpdateView)
  self:AddListenEvt(ServiceEvent.FuBenCmdTeamReliveCountFubenCmd, self.UpdateRevive)
end

function MainViewComodoRaid:UpdateBosslist()
  local mapid = SceneProxy.Instance:GetCurMapID()
  local StageConfig = ComodeConfig[mapid] and ComodeConfig[mapid].Stages
  local heroConfig = StageConfig[FuBenCmd_pb.ECOMODO_PHASE_HERO]
  local heros = heroConfig and heroConfig.bossid or {}
  local boss = {}
  for i = 1, #heros do
    local single = {}
    single.staticID = heros[i]
    single.guid = self.bossMap[single.staticID]
    single.class = heroConfig.bossClass[heros[i]]
    single.phase = FuBenCmd_pb.ECOMODO_PHASE_HERO
    table.insert(boss, single)
  end
  self.bossCtl:ResetDatas(boss, true)
end

function MainViewComodoRaid:InitConfig()
  if not self.bossMap then
    self.bossMap = {}
  else
    TableUtility.TableClear(self.bossMap)
  end
  local mapid = SceneProxy.Instance:GetCurMapID()
  local StageConfig = ComodeConfig[mapid] and ComodeConfig[mapid].Stages
  if StageConfig then
    self.bossMap[FuBenCmd_pb.ECOMODO_PHASE_MIN] = 0
    self.attentionBuffs = {}
    for i = 1, #StageConfig do
      local single = {}
      local bossid = 0
      for j = 1, #StageConfig[i].bossid do
        bossid = StageConfig[i].bossid[j]
        self.bossMap[bossid] = 0
      end
      if StageConfig[i].buffs then
        local buffs = StageConfig[i].buffs
        for j = 1, #buffs do
          self.attentionBuffs[#self.attentionBuffs + 1] = buffs[j]
        end
      end
    end
  end
  self.sanityNpc = ComodeConfig.SanityNpc
  self.sanityBuff = ComodeConfig.SanityBuff
  local buffdata = Table_Buffer[self.sanityBuff or 0]
  self.maxLayer = buffdata and buffdata.BuffEffect.limit_layer or 100
end

function MainViewComodoRaid:HandleAddNpc(note)
  if not self.isIn then
    return
  end
  local data = note.body
  if data then
    local npcData
    for i = 1, #data do
      npcData = data[i].data
      local staticid = npcData.staticData.id
      if self.bossMap[staticid] then
        self.bossMap[staticid] = npcData.id
      end
      if self.sanityNpc == staticid then
        self.sanityNpcGuid = npcData.id
      end
    end
  end
end

function MainViewComodoRaid:HandleRemoveNpc(note)
  if not self.isIn then
    return
  end
  local data = note.body
  if data then
    for i = 1, #data do
      for k, v in pairs(self.bossMap) do
        if v == data[i] then
          self.bossMap[k] = 0
        end
      end
      if self.sanityNpcGuid == data[i] then
        self.sanityNpcGuid = 0
      end
    end
  end
end

function MainViewComodoRaid:HandleSyncNpc(note)
  if not self.isIn then
    return
  end
  local data = note.body
  if data and #data.attrs > 0 then
    self:UpdateHP(data.guid)
  end
end

function MainViewComodoRaid:UpdateHP(guid)
  if self.bossCell then
    if self.currentPhase == FuBenCmd_pb.ECOMODO_PHASE_DRAGON or self.currentPhase == FuBenCmd_pb.ECOMODO_PHASE_CHESS then
      self.bossCell:UpdateHP(guid)
    elseif self.currentPhase == FuBenCmd_pb.ECOMODO_PHASE_HERO then
      local cells = self.bossCtl:GetCells()
      for i = 1, #cells do
        cells[i]:UpdateHP(guid)
      end
    end
  end
end

function MainViewComodoRaid:UpdateView(note)
  if not self.isIn then
    return
  end
  self.currentPhase = GroupRaidProxy.Instance:GetComodoRaidPhase()
  if self.currentPhase == FuBenCmd_pb.ECOMODO_PHASE_MIN then
    self.contentA:SetActive(false)
    self.contentB:SetActive(false)
    self.contentEmpty:SetActive(true)
    self:ClearSanity()
  elseif self.currentPhase == FuBenCmd_pb.ECOMODO_PHASE_DRAGON or self.currentPhase == FuBenCmd_pb.ECOMODO_PHASE_CHESS or self.currentPhase == FuBenCmd_pb.ECOMODO_PHASE_SAVE_NPC then
    self.contentA:SetActive(true)
    self.contentB:SetActive(false)
    self.contentEmpty:SetActive(false)
  elseif self.currentPhase == FuBenCmd_pb.ECOMODO_PHASE_HERO then
    self.contentA:SetActive(false)
    self.contentB:SetActive(true)
    self.contentEmpty:SetActive(false)
  end
  self:UpdateContent()
end

local bossid = 0

function MainViewComodoRaid:UpdateContent()
  if self.currentPhase == FuBenCmd_pb.ECOMODO_PHASE_DRAGON or self.currentPhase == FuBenCmd_pb.ECOMODO_PHASE_CHESS or self.currentPhase == FuBenCmd_pb.ECOMODO_PHASE_SAVE_NPC then
    local mapid = SceneProxy.Instance:GetCurMapID()
    local StageConfig = ComodeConfig[mapid] and ComodeConfig[mapid].Stages
    bossid = StageConfig[self.currentPhase].bossid[1]
    self.bossCell:SetData({
      staticID = bossid,
      guid = self.bossMap[bossid],
      phase = self.currentPhase,
      maxLayer = self.maxLayer
    })
    self:UpdateSanity(0.001)
  elseif self.currentPhase == FuBenCmd_pb.ECOMODO_PHASE_HERO then
    self:UpdateBosslist()
  end
end

function MainViewComodoRaid:LockCall()
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

function MainViewComodoRaid:CancelLockCall()
  if not self.call_lock then
    return
  end
  self.call_lock = false
  if self.lock_lt then
    self.lock_lt:Destroy()
    self.lock_lt = nil
  end
end

local revive = 0
local maxRevive = 0

function MainViewComodoRaid:UpdateRevive(note)
  local data = note and note.body
  if data then
    revive = data.count
    maxRevive = data.maxcount
    GroupRaidProxy.Instance:SaveCanRevive(0 < maxRevive - revive)
    self.reviveCountA.text = string.format("%d/%d", maxRevive - revive, maxRevive)
    self.reviveCountB.text = string.format("%d/%d", maxRevive - revive, maxRevive)
    self.reviveCountC.text = string.format("%d/%d", maxRevive - revive, maxRevive)
  else
    self.reviveCountA.text = "0/0"
    self.reviveCountB.text = "0/0"
    self.reviveCountC.text = "0/0"
  end
end

function MainViewComodoRaid:HandleBuff(note)
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
      if buffs[i].id == self.sanityBuff and self.sanityNpcGuid and data.guid == self.sanityNpcGuid then
        self:UpdateSanity(buffs[i].layer)
      end
      if self.myguid == data.guid then
        for k, v in pairs(self.attentionBuffs) do
          if buffs[i].id == v then
            flag = flag or true
            local single = {
              id = v,
              staticData = Table_Buffer[v],
              starttime = ServerTime.CurServerTime(),
              endtime = buffs[i].time,
              layer = buffs[i].layer
            }
            if single.endtime then
              single.endtime = nil
              single.isalways = true
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
      if deleteBuffs[i] == self.sanityBuff then
        if self.sanityNpcGuid and data.guid == self.sanityNpcGuid then
          self:UpdateSanity(0)
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
  end
end

function MainViewComodoRaid:UpdateSanity(bufflayer)
  if self.bossCell and self.currentPhase and self.currentPhase == FuBenCmd_pb.ECOMODO_PHASE_SAVE_NPC then
    self.bossCell:UpdateBuff(bufflayer)
  end
  local bossCreature = NSceneNpcProxy.Instance:Find(self.sanityNpcGuid)
  if bossCreature then
    local sceneUI = bossCreature:GetSceneUI() or nil
    if sceneUI then
      if not bufflayer or self.maxLayer <= 0 then
        return
      end
      local value = bufflayer / self.maxLayer
      sceneUI.roleBottomUI:UpdateSanity(bossCreature, value)
    end
  end
end

function MainViewComodoRaid:ClearSanity()
  local bossCreature = NSceneNpcProxy.Instance:Find(self.sanityNpcGuid or 0)
  if bossCreature then
    local sceneUI = bossCreature:GetSceneUI() or nil
    if sceneUI then
      sceneUI.roleBottomUI:ClearSanity()
    end
  end
end

function MainViewComodoRaid:ClickBossHead(cellctl)
  if cellctl then
    cellctl:OnClick()
  end
end

function MainViewComodoRaid:Hide(target)
  MainViewComodoRaid.super.Hide(self)
  self.isIn = false
  FunctionBuff.Me():RemoveInterest(self.sanityBuff)
  if self.attentionBuffs then
    for i = 1, #self.attentionBuffs do
      FunctionBuff.Me():RemoveInterest(self.attentionBuffs[i])
    end
  end
end

function MainViewComodoRaid:OnExit()
end

function MainViewComodoRaid:ResetBuffData()
  TableUtility.ArrayClear(self.buffListDatas)
  for _, bData in pairs(self.buffmap) do
    table.insert(self.buffListDatas, bData)
  end
  table.sort(self.buffListDatas, function(a, b)
    self:_SortBuffData(a, b)
  end)
  self.bufflistCtrl:ResetDatas(self.buffListDatas)
  self.bufflistBg.gameObject:SetActive(#self.buffListDatas ~= 0)
  self.bufflistBg.height = 10 + 46 * #self.buffListDatas
  self.bufflist:Reposition()
  if #self.buffListDatas ~= 0 then
    self.hideBtnA.transform.localPosition = ExtendHideBtnPos
    self.hideBtnB.transform.localPosition = ExtendHideBtnPos
    self.hideBtnC.transform.localPosition = ExtendHideBtnPos
  else
    self.hideBtnA.transform.localPosition = OriginHideBtnPos
    self.hideBtnB.transform.localPosition = OriginHideBtnPos
    self.hideBtnC.transform.localPosition = OriginHideBtnPos
  end
end

local STORAGE_FAKE_ID = "storage_fake_id"

function MainViewComodoRaid:_SortBuffData(a, b)
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

function MainViewComodoRaid:RemoveTimeEndBuff(buffdata)
  local id = buffdata.id
  for k, v in pairs(self.attentionBuffs) do
    if id == v then
      self.buffmap[v] = nil
    end
  end
  self:ResetBuffData()
end

function MainViewComodoRaid:ClickBuffEvent(cellCtl)
  local data = cellCtl.data
  if data then
    local staticData = data and data.staticData
    local oriDec = staticData and staticData.BuffDesc or ""
    TipsView.Me():ShowStickTip(FloatNormalTip, oriDec, NGUIUtil.AnchorSide.DownRight, cellCtl.icon, {30, 0})
    TipsView.Me().currentTip:SetUpdateSetText(1000, MainViewInfoPage.UpdateBuffTip, data)
  end
end
