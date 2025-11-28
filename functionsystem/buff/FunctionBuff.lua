autoImport("Buff")
autoImport("BuffState")
autoImport("BuffGroup")
FunctionBuff = class("FunctionBuff")
local STORAGE_FAKE_ID = "storage_fake_id"
local _GetQuenchByLayers = function(layers)
  if not layers or nil == next(layers) then
    return nil
  end
  local result = 0
  local site, quench
  for i = 1, #layers do
    site = layers[i].layer
    quench = layers[i].param
    if site and site > SceneUser2_pb.ELAYER_MIN and quench and 0 < quench then
      result = result + quench / 100
    end
  end
  return result
end

function FunctionBuff.Me()
  if nil == FunctionBuff.me then
    FunctionBuff.me = FunctionBuff.new()
  end
  return FunctionBuff.me
end

function FunctionBuff:ctor()
  self.cache_mybuff = {}
  self.myBuffs = {}
  self.buffListDatas = {}
  self:ResetSubject()
  self:Init_RecallBuffMap()
end

local RECALL_BUFF_REFLECT_MAP
local RECALL_BUFF_REWARD_MAP = {}
local recall_buffmap = {}

function FunctionBuff:Init_RecallBuffMap()
  RECALL_BUFF_REFLECT_MAP = GameConfig.Recall.reward_buff_reflectshow or _EmptyTable
  local ZhTip_Map = {
    seal = ZhString.MainViewInfoPage_seal,
    board = ZhString.MainViewInfoPage_board,
    laboratory = ZhString.MainViewInfoPage_laboratory,
    tower = ZhString.MainViewInfoPage_tower,
    donate = ZhString.MainViewInfoPage_donate
  }
  local reward_bufflayer = GameConfig.Recall.reward_bufflayer or _EmptyTable
  for k, v in pairs(reward_bufflayer) do
    RECALL_BUFF_REWARD_MAP[v.id] = {
      v.layer,
      ZhTip_Map[k]
    }
  end
end

function FunctionBuff:ServerSyncBuff(serverData)
  local creatureID = serverData.guid
  local creature = SceneCreatureProxy.FindCreature(creatureID)
  local isMine = self.subject == creature
  if creature then
    self.interestNotify = nil
    if isMine and serverData.all then
      self:RemoveNotExistBuffs(serverData.updates)
    end
    self:_ServerSyncAddBuff(creature, serverData.updates, isMine)
    self:_ServerSyncRemoveBuff(creature, serverData.dels, isMine)
    if isMine then
      Game.FacadeManager:Notify(MyselfEvent.SyncBuffs)
      EventManager.Me():PassEvent(MyselfEvent.BuffChange)
    end
    if self.interestNotify then
      GameFacade.Instance:sendNotification(ServiceEvent.NUserUserBuffNineSyncCmd, serverData)
    end
  end
end

function FunctionBuff:_ServerSyncAddBuff(creature, datas, isMine)
  local buff
  for i = 1, #datas do
    buff = datas[i]
    creature:AddBuff(buff.id, false, nil, buff.fromid, buff.layer, buff.level, buff.active, buff.stateid, buff.maxlayer, nil, buff.params)
    NSceneUserProxy.Instance:AddScenicBuff(creature.data.id, buff.id)
    if isMine then
      self.cache_mybuff[buff.id] = 1
      self:ParseBuffData(buff)
    end
    self:_UpdateInterestNotify(buff.id)
  end
end

function FunctionBuff:_ServerSyncRemoveBuff(creature, ids, isMine)
  for i = 1, #ids do
    if creature then
      creature:RemoveBuff(ids[i])
      if creature.data then
        NSceneUserProxy.Instance:RemoveScenicBuff(creature.data.id, ids[i])
      end
    end
    if isMine then
      self.cache_mybuff[ids[i]] = nil
      self:TryRemoveMyBuff(ids[i])
    end
    self:_UpdateInterestNotify(ids[i])
  end
end

function FunctionBuff:ClearMyBuffs()
  local temp_t = ReusableTable.CreateArray()
  for id, _ in pairs(self.cache_mybuff) do
    table.insert(temp_t, id)
  end
  if 0 < #temp_t then
    self:_ServerSyncRemoveBuff(self.subject, temp_t, true)
  end
  ReusableTable.DestroyAndClearArray(temp_t)
end

function FunctionBuff:RemoveNotExistBuffs(serverBuffs)
  local tmpTable = ReusableTable.CreateTable()
  local tmpArr = ReusableTable.CreateArray()
  for i = 1, #serverBuffs do
    if self.cache_mybuff[serverBuffs[i].id] then
      tmpTable[serverBuffs[i].id] = true
    end
  end
  for id, _ in pairs(self.cache_mybuff) do
    if not tmpTable[id] then
      table.insert(tmpArr, id)
    end
  end
  if 0 < #tmpArr then
    self:_ServerSyncRemoveBuff(self.subject, tmpArr, true)
  end
  ReusableTable.DestroyAndClearArray(tmpArr)
  ReusableTable.DestroyAndClearTable(tmpTable)
end

local OffEquip_BuffId = 106200
local ProtectEquip_BuffId = 104140
local BreakEquip_BuffId = 104160
local EquipBuffs = {}

function FunctionBuff:UpdateOffingEquipBuff()
  local offPoses = FunctionEquipPosState.Me():GetOffingEquipPoses()
  if offPoses and 0 < #offPoses then
    local maxtime
    for _, site in pairs(offPoses) do
      local stateTime = FunctionEquipPosState.Me():GetEquipPos_StateTime(site)
      if stateTime.offendtime and stateTime.offendtime ~= 0 and (maxtime == nil or maxtime < stateTime.offendtime) then
        maxtime = stateTime.offendtime
      end
    end
    if self.offEquipBuff == nil then
      self.offEquipBuff = {}
    else
      TableUtility.TableClear(self.offEquipBuff)
    end
    self.offEquipBuff.isEquipBuff = true
    self.offEquipBuff.id = OffEquip_BuffId
    if maxtime then
      self.offEquipBuff.time = maxtime * 1000
    end
    table.insert(EquipBuffs, self.offEquipBuff)
    EventManager.Me():PassEvent(MyselfEvent.AddBuffs)
    Game.FacadeManager:Notify(MyselfEvent.AddBuffs)
  else
    EventManager.Me():PassEvent(MyselfEvent.RemoveBuffs)
    Game.FacadeManager:Notify(MyselfEvent.RemoveBuffs)
  end
  TableUtility.ArrayClear(EquipBuffs)
end

function FunctionBuff:UpdateProtectEquipBuff()
  local protectPoses = FunctionEquipPosState.Me():GetProtectEquipPoses()
  if protectPoses and 0 < #protectPoses then
    local maxtime
    local protectalways = false
    for _, site in pairs(protectPoses) do
      local stateTime = FunctionEquipPosState.Me():GetEquipPos_StateTime(site)
      if stateTime.protecttime and stateTime.protecttime ~= 0 then
        if maxtime == nil or maxtime < stateTime.protecttime then
          maxtime = stateTime.protecttime
        end
        if 0 < stateTime.protectalways then
          protectalways = true
        end
      end
    end
    if self.protectEquipBuff == nil then
      self.protectEquipBuff = {}
    else
      TableUtility.TableClear(self.protectEquipBuff)
    end
    self.protectEquipBuff.isEquipBuff = true
    self.protectEquipBuff.id = ProtectEquip_BuffId
    if protectalways == true then
      self.protectEquipBuff.isalways = true
    else
      self.protectEquipBuff.isalways = false
      if maxtime then
        self.protectEquipBuff.time = maxtime * 1000
      end
    end
    table.insert(EquipBuffs, self.protectEquipBuff)
    EventManager.Me():PassEvent(MyselfEvent.AddBuffs)
    Game.FacadeManager:Notify(MyselfEvent.AddBuffs)
  else
    table.insert(EquipBuffs, ProtectEquip_BuffId)
    EventManager.Me():PassEvent(MyselfEvent.RemoveBuffs)
    Game.FacadeManager:Notify(MyselfEvent.RemoveBuffs)
  end
  TableUtility.ArrayClear(EquipBuffs)
end

function FunctionBuff:UpdateBreakEquipBuff()
  local breakInfos = BagProxy.Instance.roleEquip:GetBreakEquipSiteInfo()
  if breakInfos and 0 < #breakInfos then
    local maxtime
    for k, v in pairs(breakInfos) do
      if maxtime == nil or maxtime < v.breakendtime then
        maxtime = v.breakendtime
      end
    end
    if self.breakEquipBuff == nil then
      self.breakEquipBuff = {}
    else
      TableUtility.TableClear(self.breakEquipBuff)
    end
    self.breakEquipBuff.isEquipBuff = true
    self.breakEquipBuff.id = BreakEquip_BuffId
    self.breakEquipBuff.time = maxtime * 1000
    table.insert(EquipBuffs, self.breakEquipBuff)
    EventManager.Me():PassEvent(MyselfEvent.AddBuffs)
    Game.FacadeManager:Notify(MyselfEvent.AddBuffs)
  else
    EventManager.Me():PassEvent(MyselfEvent.RemoveBuffs)
    Game.FacadeManager:Notify(MyselfEvent.RemoveBuffs)
  end
  TableUtility.ArrayClear(EquipBuffs)
end

function FunctionBuff:AddInterest(buffid)
  self.interests = self.interests or {}
  local count = self.interests[buffid]
  if count == nil then
    count = 0
  end
  count = count + 1
  self.interests[buffid] = count
end

function FunctionBuff:RemoveInterest(buffid)
  if self.interests == nil then
    return
  end
  local count = self.interests[buffid]
  if count == nil then
    return
  end
  count = count - 1
  if count == 0 then
    count = nil
  end
  self.interests[buffid] = count
end

function FunctionBuff:_UpdateInterestNotify(buffid)
  if not self.interestNotify and self.interests ~= nil then
    local count = self.interests[buffid]
    if count ~= nil and 0 < count then
      self.interestNotify = true
    end
  end
end

function FunctionBuff:GetMyBuff(isgain)
  if not self.myBuffs then
    return
  end
  TableUtility.ArrayClear(self.buffListDatas)
  local isStaticGain
  for _, bData in pairs(self.myBuffs) do
    isStaticGain = bData.staticData and bData.staticData.BuffType.isgain
    if isgain and isStaticGain ~= 0 then
      table.insert(self.buffListDatas, bData)
    elseif not isgain and isStaticGain == 0 then
      table.insert(self.buffListDatas, bData)
    end
  end
  return self.buffListDatas
end

function FunctionBuff:GetBuffByID(id)
  return self.myBuffs and self.myBuffs[id] or false
end

function FunctionBuff:ParseBuffData(buff)
  if buff.GetActive and not buff:GetActive() then
    return
  end
  local id = buff.id
  if RECALL_BUFF_REFLECT_MAP[id] then
    self:UpdateBuffData_RecallBuffer(buff)
    return
  end
  local sData = Table_Buffer[id]
  if not sData then
    return
  end
  local betype = sData.BuffEffect.type
  if betype == "HPStorage" or betype == "SPStorage" then
    self:UpdateStorageBuffer(buff)
    return
  end
  if sData.BuffIcon == nil or sData.BuffIcon == "" then
    return
  end
  local condition = sData.Condition
  local cType = condition and condition.type
  if cType == "MapType" and not buff.active then
    self.myBuffs[id] = nil
    return
  elseif condition.type == "DateDivide" then
    local curServerTime = ServerTime.CurServerTime() / 1000
    local curDay = os.date("*t", curServerTime)
    if condition.equalzero and condition.equalzero == 1 then
      if curDay.day % condition.divisor ~= 0 then
        return
      end
    elseif curDay.day % condition.divisor == 0 then
      return
    end
  end
  local buffData = self.myBuffs[id] or {id = id, staticData = sData}
  buffData.layer = buff.layer
  buffData.fromname = buff.fromname
  buffData.active = buff.active
  buffData.isEquipBuff = buff.isEquipBuff
  buffData.isalways = buff.isalways
  if not buffData.isalways and sData.IconType and sData.IconType == 1 and buff.time and buff.time ~= 0 then
    if not buffData.endtime or buffData.endtime ~= buff.time then
      buffData.starttime = ServerTime.CurServerTime()
    end
    buffData.endtime = buff.time
  end
  buffData.quench = _GetQuenchByLayers(buff.layers)
  buffData.activeNextDay = cType == "NextDay"
  self.myBuffs[id] = buffData
end

function FunctionBuff:UpdateStorageBuffer(recv_buffdata)
  local id, layer = recv_buffdata.id, recv_buffdata.layer or 0
  local fakeBuff = self.myBuffs[STORAGE_FAKE_ID]
  if 0 < layer then
    if fakeBuff == nil then
      fakeBuff = {
        id = STORAGE_FAKE_ID,
        storage = {}
      }
      self.myBuffs[STORAGE_FAKE_ID] = fakeBuff
    end
    local etype = Table_Buffer[id].BuffEffect.type
    local storage
    if etype == "HPStorage" then
      storage = fakeBuff.storage[1]
      if storage == nil then
        storage = {id}
        fakeBuff.storage[1] = storage
      end
    elseif etype == "SPStorage" then
      storage = fakeBuff.storage[2]
      if storage == nil then
        storage = {id}
        fakeBuff.storage[2] = storage
      end
    end
    if storage then
      storage[2] = layer
    end
  elseif fakeBuff ~= nil then
    local etype = Table_Buffer[id].BuffEffect.type
    local storage
    if etype == "HPStorage" then
      fakeBuff.storage[1] = nil
    elseif etype == "SPStorage" then
      fakeBuff.storage[2] = nil
    end
    if not next(fakeBuff.storage) then
      fakeBuff = nil
      self.myBuffs[STORAGE_FAKE_ID] = nil
    end
  end
end

function FunctionBuff:UpdateBuffData_RecallBuffer(recv_buffdata)
  local id, layer = recv_buffdata.id, recv_buffdata.layer
  local maxlayer = RECALL_BUFF_REWARD_MAP[id][1]
  if layer == 0 then
    recall_buffmap[id] = nil
  else
    recall_buffmap[id] = layer
  end
  self:UpdateBuffData_RecallBuffer_Reflect(RECALL_BUFF_REFLECT_MAP[id])
end

function FunctionBuff:UpdateBuffData_RecallBuffer_Reflect(reflectid)
  if reflectid == nil then
    return
  end
  local has_recallBuff = false
  local tk, _ = next(recall_buffmap)
  if tk ~= nil then
    has_recallBuff = true
  end
  if has_recallBuff == false then
    if self.myBuffs[reflectid] ~= nil then
      self.myBuffs[reflectid] = nil
    end
  else
    local configData = Table_Buffer[reflectid]
    if configData == nil then
      return
    end
    if self.myBuffs[reflectid] == nil then
      local reflect_buffData = {}
      reflect_buffData.id = reflectid
      reflect_buffData.staticData = configData
      reflect_buffData.isRecallBuff = true
      reflect_buffData.isalways = true
      self.myBuffs[reflectid] = reflect_buffData
    end
  end
end

function FunctionBuff:TryRemoveMyBuff(buffid)
  if not buffid then
    return
  end
  if RECALL_BUFF_REFLECT_MAP[buffid] then
    self:UpdateBuffData_RecallBuffer_Reflect(RECALL_BUFF_REFLECT_MAP[buffid])
  else
    local config = Table_Buffer[buffid]
    local betype
    if config and config.BuffEffect then
      betype = config.BuffEffect.type
    end
    if betype == "HPStorage" or betype == "SPStorage" then
      self:UpdateStorageBuffer({id = buffid, layer = 0})
    else
      self.myBuffs[buffid] = nil
    end
  end
end

function FunctionBuff:ResetSubject(subject)
  subject = subject or Game.Myself
  self.subject = subject
  TableUtility.TableClear(self.myBuffs)
  TableUtility.TableClear(self.cache_mybuff)
end
