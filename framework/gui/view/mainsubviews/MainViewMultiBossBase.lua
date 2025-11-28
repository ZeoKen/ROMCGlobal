autoImport("ComodoBossHeadCell")
autoImport("RaidBuffCell")
MainViewMultiBossBase = class("MainViewMultiBossBase", SubMediatorView)
local RaidConfig = GameConfig.MultiBoss.Map
local OriginHideBtnPos = LuaVector3(440.5, 144.2, 0)
local ExtendHideBtnPos = LuaVector3(397, 144.2, 0)
local CellHeight = 54

function MainViewMultiBossBase:InitShow()
  self.mainViewTrans = self.gameObject.transform.parent
  local traceInfoParent = GameObjectUtil.Instance:DeepFindChild(self.mainViewTrans.gameObject, "TraceInfoBord")
  self.trans:SetParent(traceInfoParent.transform)
  self.trans.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
end

function MainViewMultiBossBase:Show()
  MainViewMultiBossBase.super.Show(self)
  self.isIn = true
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

function MainViewMultiBossBase:ResetDatas()
  self:UpdateView()
end

function MainViewMultiBossBase:Init()
  self:ReLoadPerferb("view/MainViewMultiBossBase")
  self.myguid = Game.Myself.data.id
  self:FindObjs()
  self:InitShow()
  self:AddViewEvents()
end

function MainViewMultiBossBase:FindObjs()
  self.content = self:FindGO("Content")
  self.bossgrid = self:FindGO("bossGrid"):GetComponent(UIGrid)
  self.bossCtl = UIGridListCtrl.new(self.bossgrid, ComodoBossHeadCell, "ComodoBossHeadCell")
  self.bossCtl:AddEventListener(MouseEvent.MouseClick, self.ClickBossHead, self)
  local infoBtn = self:FindGO("infoBtn", self.content)
  self.reviveCount = self:FindGO("reviveCount", self.content):GetComponent(UILabel)
  self:AddClickEvent(infoBtn, function()
    if self.call_lock then
      return
    end
    self:LockCall()
    ServiceFuBenCmdProxy.Instance:CallQueryMultiBossRaidStat()
  end)
  self.infoBG = self:FindGO("InfoBG"):GetComponent(UISprite)
  self.contentEmpty = self:FindGO("ContentEmpty")
  self.reviveCountC = self:FindGO("reviveCount", self.contentEmpty):GetComponent(UILabel)
  local infoBtnC = self:FindGO("infoBtn", self.contentEmpty)
  self:AddClickEvent(infoBtnC, function()
    if self.call_lock then
      return
    end
    self:LockCall()
    ServiceFuBenCmdProxy.Instance:CallQueryMultiBossRaidStat()
  end)
  self.buffinfo = self:FindGO("BuffInfo")
  self.bufflist = self:FindGO("BuffList"):GetComponent(UIGrid)
  self.bufflistCtrl = UIGridListCtrl.new(self.bufflist, RaidBuffCell, "RaidBuffCell")
  self.bufflistBg = self:FindGO("BuffListBg"):GetComponent(UISprite)
  self.bufflistCtrl:AddEventListener(RaidBuffCellEvent.BuffEnd, self.RemoveTimeEndBuff, self)
  self.bufflistCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickBuffEvent, self)
  self.hideBtn = self:FindGO("HideButton", self.content)
  self.hideBtnC = self:FindGO("HideButton", self.contentEmpty)
  self.content:SetActive(false)
  self.contentEmpty:SetActive(true)
end

function MainViewMultiBossBase:AddViewEvents()
  self:AddListenEvt(SceneUserEvent.SceneAddNpcs, self.HandleAddNpc)
  self:AddListenEvt(SceneUserEvent.SceneRemoveNpcs, self.HandleRemoveNpc)
  self:AddListenEvt(ServiceEvent.NUserNpcDataSync, self.HandleSyncNpc)
  self:AddListenEvt(ServiceEvent.NUserUserBuffNineSyncCmd, self.HandleBuff)
  self:AddListenEvt(ServiceEvent.FuBenCmdMultiBossPhaseFubenCmd, self.UpdateView)
  self:AddListenEvt(ServiceEvent.FuBenCmdTeamReliveCountFubenCmd, self.UpdateRevive)
end

function MainViewMultiBossBase:UpdateBosslist(bossIndex)
  if not bossIndex then
    return
  end
  local mapid = SceneProxy.Instance:GetCurMapID()
  local StageConfig = RaidConfig[mapid] and RaidConfig[mapid].Stages
  local heroConfig = StageConfig[bossIndex]
  local heros = heroConfig and heroConfig.bossid or {}
  local boss = {}
  for i = 1, #heros do
    local single = {}
    single.staticID = heros[i]
    single.guid = self.bossMap[single.staticID]
    table.insert(boss, single)
  end
  self.bossCtl:ResetDatas(boss, true)
end

function MainViewMultiBossBase:InitConfig()
  if not self.bossMap then
    self.bossMap = {}
  else
    TableUtility.TableClear(self.bossMap)
  end
  local mapid = SceneProxy.Instance:GetCurMapID()
  local StageConfig = RaidConfig[mapid] and RaidConfig[mapid].Stages
  if StageConfig then
    self.bossMap[0] = 0
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
end

function MainViewMultiBossBase:HandleAddNpc(note)
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
    end
  end
end

function MainViewMultiBossBase:HandleRemoveNpc(note)
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
    end
  end
end

function MainViewMultiBossBase:HandleSyncNpc(note)
  if not self.isIn then
    return
  end
  local data = note.body
  if data and #data.attrs > 0 then
    self:UpdateHP(data.guid)
  end
end

function MainViewMultiBossBase:UpdateHP(guid)
  if self.currentPhase ~= 0 then
    local cells = self.bossCtl:GetCells()
    for i = 1, #cells do
      cells[i]:UpdateHP(guid)
    end
  end
end

function MainViewMultiBossBase:UpdateView(note)
  if not self.isIn then
    return
  end
  self.currentPhase = GroupRaidProxy.Instance:GetMultiBossRaidPhase()
  if not self.currentPhase or self.currentPhase == 0 then
    self.content:SetActive(false)
    self.contentEmpty:SetActive(true)
  else
    self.content:SetActive(true)
    self.contentEmpty:SetActive(false)
    self:UpdateBosslist(self.currentPhase)
  end
end

function MainViewMultiBossBase:LockCall()
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

function MainViewMultiBossBase:CancelLockCall()
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

function MainViewMultiBossBase:UpdateRevive(note)
  local data = note and note.body
  if data then
    revive = data.count
    maxRevive = data.maxcount
    GroupRaidProxy.Instance:SaveCanRevive(0 < maxRevive - revive)
    self.reviveCount.text = string.format("%d/%d", maxRevive - revive, maxRevive)
    self.reviveCountC.text = string.format("%d/%d", maxRevive - revive, maxRevive)
  else
    self.reviveCount.text = "0/0"
    self.reviveCountC.text = "0/0"
  end
end

function MainViewMultiBossBase:HandleBuff(note)
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
            if single.endtime == 0 then
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
      if data.guid == self.myguid then
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

function MainViewMultiBossBase:ClickBossHead(cellctl)
  if cellctl then
    cellctl:OnClick()
  end
end

function MainViewMultiBossBase:Hide(target)
  MainViewMultiBossBase.super.Hide(self)
  self.isIn = false
  if self.attentionBuffs then
    for i = 1, #self.attentionBuffs do
      FunctionBuff.Me():RemoveInterest(self.attentionBuffs[i])
    end
  end
end

function MainViewMultiBossBase:ResetBuffData()
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
  TimeTickManager.Me():CreateOnceDelayTick(33, function(self)
    self.bufflist:Reposition()
    self.bufflist.repositionNow = true
  end, self)
  if #self.buffListDatas ~= 0 then
    self.hideBtn.transform.localPosition = ExtendHideBtnPos
    self.hideBtnC.transform.localPosition = ExtendHideBtnPos
  else
    self.hideBtn.transform.localPosition = OriginHideBtnPos
    self.hideBtnC.transform.localPosition = OriginHideBtnPos
  end
end

local STORAGE_FAKE_ID = "storage_fake_id"

function MainViewMultiBossBase:_SortBuffData(a, b)
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

function MainViewMultiBossBase:RemoveTimeEndBuff(buffdata)
  local id = buffdata.id
  for k, v in pairs(self.attentionBuffs) do
    if id == v then
      self.buffmap[v] = nil
    end
  end
  self:ResetBuffData()
end

function MainViewMultiBossBase:ClickBuffEvent(cellCtl)
  local data = cellCtl.data
  if data then
    local staticData = data and data.staticData
    local oriDec = staticData and staticData.BuffDesc or ""
    TipsView.Me():ShowStickTip(FloatNormalTip, oriDec, NGUIUtil.AnchorSide.DownRight, cellCtl.icon, {30, 0})
    TipsView.Me().currentTip:SetUpdateSetText(1000, MainViewInfoPage.UpdateBuffTip, data)
  end
end
