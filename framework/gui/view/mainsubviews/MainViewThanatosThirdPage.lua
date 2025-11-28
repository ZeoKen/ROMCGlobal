MainViewThanatosThirdPage = class("MainViewThanatosThirdPage", SubMediatorView)
autoImport("RaidBuffCell")
autoImport("MemberSelectCell")
autoImport("MissionCommandMove")
autoImport("BossHeadCell")
autoImport("FloatLeftTip")
autoImport("FloatNormalTip")
local originRaidInfo = LuaVector3(-160, 28, 0)
local originBuffInfo = LuaVector3(-186, -55, 0)
local rightBuffInfo = LuaVector3(-35, -55, 0)

function MainViewThanatosThirdPage:Show(tarObj)
  self:TryInit()
  MainViewThanatosThirdPage.super.Show(self, tarObj)
  self.isIn = true
  self.addBoss = false
  FunctionBuff.Me():AddInterest(self.ConfigThanatos.EyesInBuffID)
  FunctionBuff.Me():AddInterest(self.ConfigThanatos.EyesOutBuffID)
  if not self.buffmap then
    self.buffmap = {}
  else
    TableUtility.TableClear(self.buffmap)
  end
  for i = 1, #self.attentionBuffs do
    FunctionBuff.Me():AddInterest(self.attentionBuffs[i])
  end
  if not self.buffListDatas then
    self.buffListDatas = {}
  else
    TableUtility.ArrayClear(self.buffListDatas)
  end
  self.myguid = Game.Myself.data.id
  if not self.bossGuidMap then
    self.bossGuidMap = {}
  else
    TableUtility.TableClear(self.bossGuidMap)
  end
  self:ResetBuffData()
  self:ReParent()
  ServiceFuBenCmdProxy.Instance:CallQueryTeamGroupRaidUserInfo()
end

function MainViewThanatosThirdPage:Hide(target)
  MainViewThanatosThirdPage.super.Hide(self, target)
  self.isIn = false
  self.inited = false
  self.raidinfo.transform.parent = self.gameObject.transform
  TableUtility.TableClear(self.bossGuidMap)
  TableUtility.TableClear(self.bossCellMap)
  if self.innerTimetick then
    TimeTickManager.Me():ClearTick(self, 10)
    self.innerTimetick = nil
  end
  if self.outterTimetick then
    TimeTickManager.Me():ClearTick(self, 11)
    self.outterTimetick = nil
  end
  if self.bufflistCtrl then
    self.bufflistCtrl:RemoveAll()
  end
  self.innerEyeGuid = nil
  self.outterEyeGuid = nil
  self.dummyGuid = nil
  self.skillDummyGuid = nil
  FunctionBuff.Me():RemoveInterest(self.ConfigThanatos.EyesInBuffID)
  FunctionBuff.Me():RemoveInterest(self.ConfigThanatos.EyesOutBuffID)
  for i = 1, #self.attentionBuffs do
    FunctionBuff.Me():RemoveInterest(self.attentionBuffs[i])
  end
end

function MainViewThanatosThirdPage:Init()
  self:AddViewEvts()
end

function MainViewThanatosThirdPage:TryInit()
  if not self.loaded then
    local container = self:FindGO("MainViewThanatosPage")
    self:ReLoadPerferb("view/MainViewThanatosThirdPage")
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
  end
end

function MainViewThanatosThirdPage:InitConfig()
  self.curmapid = SceneProxy.Instance:GetCurRaidID()
  local tgConfig = Table_TeamGroupRaid[self.curmapid]
  if tgConfig then
    self.ConfigThanatos = GameConfig.Thanatos[tgConfig.Difficulty]
    self.attentionBuffs = self.ConfigThanatos.AttentionThirdBuffID
    for k, v in pairs(self.ConfigThanatos.HideUI) do
      if v == MainViewThanatosPage.HideUI.HideCystalInfo then
        self.hidecrystal = true
      elseif v == MainViewThanatosPage.HideUI.HideCountCrystal then
        self.hideCountCrystal = true
      end
    end
    self.EyesInBuffID = self.ConfigThanatos.EyesInBuffID
    self.EyesOutBuffID = self.ConfigThanatos.EyesOutBuffID
  end
end

function MainViewThanatosThirdPage:FindObjs()
  self.buffinfo = self:FindGO("BuffInfo")
  self.bufflist = self:FindGO("BuffList"):GetComponent(UIGrid)
  self.bufflistCtrl = UIGridListCtrl.new(self.bufflist, RaidBuffCell, "RaidBuffCell")
  self.bufflistBg = self:FindGO("BuffListBg"):GetComponent(UISprite)
  self.bufflistCtrl:AddEventListener(RaidBuffCellEvent.BuffEnd, self.RemoveTimeEndBuff, self)
  self.bufflistCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickBuffEvent, self)
  self.bossCellMap = {}
  self.curmapid = SceneProxy.Instance:GetCurRaidID()
  local tgConfig = Table_TeamGroupRaid[self.curmapid]
  self.bossIDs = tgConfig.BossID
  local cellGO
  for i = 1, #self.bossIDs do
    cellGO = self:FindGO("BossHeadCell" .. i)
    local single = BossHeadCell.new(cellGO)
    self.bossCellMap[self.bossIDs[i]] = single
    self:AddClickEvent(cellGO, function()
      single:OnClick()
    end)
  end
  self.bg = self:FindGO("InfoBG"):GetComponent(UISprite)
  self.innerStatusLabel = self:FindGO("innerStatusLabel"):GetComponent(UILabel)
  self.outterStatusLabel = self:FindGO("outterStatusLabel"):GetComponent(UILabel)
  self.innerSlider = self:FindGO("innerSlider"):GetComponent(UISlider)
  self.outterSlider = self:FindGO("outterSlider"):GetComponent(UISlider)
  self.innerStatusSp = self:FindGO("InnerEyeCell"):GetComponent(UIMultiSprite)
  self.outterStatusSp = self:FindGO("OutterEyeCell"):GetComponent(UIMultiSprite)
end

function MainViewThanatosThirdPage:ReParent()
  local thanatosParent = self.gameObject.transform.parent
  self.raidinfo = self:FindGO("RaidInfo")
  local raidinfoParent = Game.GameObjectUtil:DeepFindChild(thanatosParent.gameObject, "RaidInfo")
  self.raidinfo.transform.parent = raidinfoParent.gameObject.transform
  self.raidinfo.transform.localPosition = originRaidInfo
end

function MainViewThanatosThirdPage:AddViewEvts()
  self:AddListenEvt(SceneUserEvent.SceneAddNpcs, self.HandleAddNpc)
  self:AddListenEvt(SceneUserEvent.SceneRemoveNpcs, self.HandleRemoveNpc)
  self:AddListenEvt(ServiceEvent.NUserNpcDataSync, self.HandleSyncNpc)
  self:AddListenEvt(ServiceEvent.NUserUserBuffNineSyncCmd, self.HandleBuff)
  EventManager.Me():AddEventListener(SkillEvent.SkillCastBegin, self.HandleStartProcess, self)
  EventManager.Me():AddEventListener(SkillEvent.SkillCastEnd, self.HandleStopProcess, self)
end

function MainViewThanatosThirdPage:ResetParent(parent)
  if not parent then
    return
  end
  self.trans:SetParent(parent.transform, false)
end

function MainViewThanatosThirdPage:HandleAddNpc(note)
  if not self.isIn then
    return
  end
  local data = note.body
  if data then
    local npcData
    for i = 1, #data do
      npcData = data[i].data
      local staticid = npcData.staticData.id
      if staticid == self.ConfigThanatos.EyesInID then
        self.innerEyeGuid = npcData.id
        self.innerStatusLabel.text = ZhString.Thanatos_CastDone
        self.innerSlider.value = 0
        self.innerStatusSp.CurrentState = 1
      elseif staticid == self.ConfigThanatos.EyesOutID then
        self.outterEyeGuid = npcData.id
        self.outterStatusLabel.text = ZhString.Thanatos_CastDone
        self.outterSlider.value = 0
        self.outterStatusSp.CurrentState = 1
      elseif staticid == self.ConfigThanatos.Bodybufflay then
        self.dummyGuid = npcData.id
      elseif staticid == self.ConfigThanatos.EyesSkillbody then
        self.skillDummyGuid = npcData.id
      else
        for k, v in pairs(self.bossCellMap) do
          if staticid == k then
            self.addBoss = true
            self.bossCellMap[k]:SetData(staticid, npcData.id)
            self.bossGuidMap[staticid] = npcData.id
          end
        end
        self.raidinfo:SetActive(self.addBoss)
        if self.addBoss then
          self.buffinfo.transform.localPosition = originBuffInfo
        else
          self.buffinfo.transform.localPosition = rightBuffInfo
        end
      end
    end
  end
end

function MainViewThanatosThirdPage:HandleRemoveNpc(note)
  if not self.isIn then
    return
  end
  local data = note.body
  local flag = false
  if data then
    for i = 1, #data do
      for k, v in pairs(self.bossGuidMap) do
        if v == data[i] then
          self.bossCellMap[k]:UpdateHP(data[i])
          self.addBoss = false
        end
      end
      self.raidinfo:SetActive(self.addBoss)
    end
  end
end

function MainViewThanatosThirdPage:HandleSyncNpc(note)
  if not self.isIn then
    return
  end
  local data = note.body
  if data then
    for k, v in pairs(self.bossGuidMap) do
      if data.guid == v and #data.attrs > 0 then
        self:UpdateHP(k, v)
      end
    end
  end
end

function MainViewThanatosThirdPage:UpdateHP(bossid, bossguid)
  if self.bossCellMap[bossid] then
    self.bossCellMap[bossid]:UpdateHP(bossguid)
  end
end

function MainViewThanatosThirdPage:HandleBuff(note)
  if not self.isIn then
    return
  end
  local data = note.body
  if data then
    local buffs = data.updates or {}
    local deleteBuffs = data.dels or {}
    if data.guid == Game.Myself.data.id then
      for i = 1, #buffs do
        for k, v in pairs(self.attentionBuffs) do
          if buffs[i].id == v then
            if not flag then
              flag = true
            end
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
      for i = 1, #deleteBuffs do
        for k, v in pairs(self.attentionBuffs) do
          if deleteBuffs[i] == v then
            self.buffmap[v] = nil
          end
          self:ResetBuffData()
        end
      end
    elseif data.guid == self.dummyGuid then
      for i = 1, #buffs do
        if buffs[i].id == self.EyesInBuffID or buffs[i].id == self.EyesOutBuffID then
          self:UpdateEyeStatus(buffs[i].id, false)
        end
      end
      for i = 1, #deleteBuffs do
        if deleteBuffs[i] == self.EyesInBuffID or deleteBuffs[i] == self.EyesOutBuffID then
          self:UpdateEyeStatus(deleteBuffs[i], true)
        end
      end
    end
  end
end

function MainViewThanatosThirdPage:UpdateEyeStatus(buffid, isDelete)
  if buffid == self.EyesInBuffID then
    if isDelete then
      self.innerStatusLabel.text = ZhString.Thanatos_CastDone
      self.innerSlider.value = 0
      self.innerStatusSp.CurrentState = 1
    else
      self.innerStatusLabel.text = ZhString.Thanatos_Casting
      self.innerStatusSp.CurrentState = 2
    end
  elseif buffid == self.EyesOutBuffID then
    if isDelete then
      self.outterStatusLabel.text = ZhString.Thanatos_CastDone
      self.outterSlider.value = 0
      self.outterStatusSp.CurrentState = 1
    else
      self.outterStatusLabel.text = ZhString.Thanatos_Casting
      self.outterStatusSp.CurrentState = 2
    end
  end
end

function MainViewThanatosThirdPage:ClickBuffEvent(cellCtl)
  local data = cellCtl.data
  if data then
    local staticData = data and data.staticData
    local oriDec = staticData and staticData.BuffDesc or ""
    if self.addBoss then
      TipsView.Me():ShowStickTip(FloatNormalTip, oriDec, NGUIUtil.AnchorSide.DownLeft, cellCtl.icon, {30, 0})
    else
      TipsView.Me():ShowStickTip(FloatLeftTip, oriDec, NGUIUtil.AnchorSide.Left, cellCtl.icon, {30, 0})
    end
    TipsView.Me().currentTip:SetUpdateSetText(1000, MainViewInfoPage.UpdateBuffTip, data)
  end
end

function MainViewThanatosThirdPage:ResetBuffData()
  TableUtility.ArrayClear(self.buffListDatas)
  for _, bData in pairs(self.buffmap) do
    table.insert(self.buffListDatas, bData)
  end
  table.sort(self.buffListDatas, function(a, b)
    self:_SortBuffData(a, b)
  end)
  self.bufflistCtrl:ResetDatas(self.buffListDatas)
  self.bufflistBg.gameObject:SetActive(#self.buffListDatas ~= 0)
  self.bufflistBg.height = 10 + 40 * #self.buffListDatas
  self.bufflist:Reposition()
end

local STORAGE_FAKE_ID = "storage_fake_id"

function MainViewThanatosThirdPage:_SortBuffData(a, b)
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

function MainViewThanatosThirdPage:HandleStartProcess(note)
  if not self.isIn then
    return
  end
  local creature = note.data
  if not creature then
    return
  end
  local id = creature.data.id
  if self.skillDummyGuid == id then
    local skill = creature.skill
    local skillId = skill and skill:GetSkillID()
    if self.ConfigThanatos.EyesInSkillID == skillId or self.ConfigThanatos.EyesOutSkillID == skillId then
      local castTime = skill and skill:GetCastTime(creature) or 0
      if 0 < castTime then
        if self.ConfigThanatos.EyesInSkillID == skillId then
          self.innerCasttime = castTime
          self.innerStarttime = ServerTime.CurServerTime()
          self.innerStatusSp.CurrentState = 0
          self.innerTimetick = TimeTickManager.Me():CreateTick(0, 33, self.UpdateInnerTick, self, 10)
        elseif self.ConfigThanatos.EyesOutSkillID == skillId then
          self.outterCasttime = castTime
          self.outterStarttime = ServerTime.CurServerTime()
          self.outterStatusSp.CurrentState = 0
          self.outterTimetick = TimeTickManager.Me():CreateTick(0, 33, self.UpdateOutterTick, self, 11)
        end
      end
    end
  end
  return
end

function MainViewThanatosThirdPage:UpdateInnerTick()
  local passTime = (ServerTime.CurServerTime() - self.innerStarttime) / 1000
  local lefttime = self.innerCasttime - passTime
  if lefttime < 0 then
    self.innerTimetick = nil
    TimeTickManager.Me():ClearTick(self, 10)
    self.innerSlider.value = 0
    self.innerStatusLabel.text = "0s"
  else
    self.innerSlider.value = lefttime / self.innerCasttime
    self.innerStatusLabel.text = string.format("%ss", math.ceil(lefttime))
    self.innerStatusSp.CurrentState = 0
  end
end

function MainViewThanatosThirdPage:UpdateOutterTick()
  local passTime = (ServerTime.CurServerTime() - self.outterStarttime) / 1000
  local lefttime = self.outterCasttime - passTime
  if lefttime < 0 then
    self.outterSlider.value = 0
    self.outterStatusLabel.text = "0s"
    self.outterTimetick = nil
    TimeTickManager.Me():ClearTick(self, 11)
  else
    self.outterSlider.value = lefttime / self.outterCasttime
    self.outterStatusLabel.text = string.format("%ss", math.ceil(lefttime))
    self.outterStatusSp.CurrentState = 0
  end
end

function MainViewThanatosThirdPage:HandleStopProcess(note)
  if not self.isIn then
    return
  end
  local creature = note.data
  if not creature then
    return
  end
  if creature.data then
    local id = creature.data.id
    if self.skillDummyGuid == id then
      local skill = creature.skill
      local skillId = skill and skill:GetSkillID()
      if self.ConfigThanatos.EyesInSkillID == skillId then
        self.innerTimetick = nil
        TimeTickManager.Me():ClearTick(self, 10)
        self.innerStatusLabel.text = "0s"
        self.innerSlider.value = 0
      elseif self.ConfigThanatos.EyesOutSkillID == skillId then
        self.outterTimetick = nil
        TimeTickManager.Me():ClearTick(self, 11)
        self.outterStatusLabel.text = "0s"
        self.outterSlider.value = 0
      end
    end
  end
end
