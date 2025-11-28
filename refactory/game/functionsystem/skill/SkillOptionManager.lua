SkillOptionManager = class("SkillOptionManager")
SkillOptionManager.OptionEnum = {
  AutoQueue = SceneSkill_pb.ESKILLOPTION_AUTOQUEUE,
  SummonBeing = SceneSkill_pb.ESKILLOPTION_SUMMONBEING,
  AutoArchery = SceneSkill_pb.ESKILLOPTION_AUTO_ARCHERY,
  FistsMagic = SceneSkill_pb.ESKILLOPTION_FISTS_MAGIC,
  SummonElement = SceneSkill_pb.ESKILLOPTION_SUMMON_ELEMENT,
  BuffSkillList = SceneSkill_pb.ESKILLOPTION_BUFF_SKILLLIST,
  SelectBuffs = SceneSkill_pb.ESKILLOPTION_SELECT_BUFFS,
  SelectMount = SceneSkill_pb.ESKILLOPTION_SELECT_MOUNT,
  QuickRide = SceneSkill_pb.ESKILLOPTION_QUICK_RIDE,
  FakeDead = SceneSkill_pb.ESKILLOPTION_FAKE_DEAD,
  PioneerSkillList = SceneSkill_pb.ESKILLOPTION_PIONEER_SKILLLIST,
  AutoLockMvp = SceneSkill_pb.ESKILLOPTION_AUTOLOCK_MVP,
  AutoLockMini = SceneSkill_pb.ESKILLOPTION_AUTOLOCK_MINI,
  AutoLockDeadBoss = SceneSkill_pb.ESKILLOPTION_AUTOLOCK_DEADBOSS,
  ReplaceSkillList = SceneSkill_pb.ESKILLOPTION_REPLACE_SKILLLIST,
  AutoReload = SceneSkill_pb.ESKILLOPTION_LOAD_BULLET,
  AbyssContract = SceneSkill_pb.ESKILLOPTION_ABYSS_CONTRACT,
  SwitchSkill = SceneSkill_pb.ESKILLOPTION_SKILL_SWITCH,
  SuperPositionSkill = SceneSkill_pb.ESKILLOPTION_SUPERPOSITION_SKILL,
  DelMultiTrap = SceneSkill_pb.ESKILLOPTION_DEL_MULTI_TRAP,
  Companion_Skill = SceneSkill_pb.ESKILLOPTION_COMPANION_SKILLLIST
}
local StringData = {
  [SkillOptionManager.OptionEnum.SelectMount] = 1
}
local MutexMap = GameConfig.MutexSkill

function SkillOptionManager:ctor()
  self._options = {}
  self._callBacks = {}
  self._dirtySkills = {}
  self._invalidSkills = {}
  self.switchSkills = {}
  self.extraOptions = {}
  self:AddChangeCallBack(self.OptionEnum.AutoQueue, self.HandleSkillAutoQueue)
  self:AddChangeCallBack(self.OptionEnum.AutoLockMvp, self.HandleSkillAutoLockMvp)
  self:AddChangeCallBack(self.OptionEnum.AutoLockMini, self.HandleSkillAutoLockMini)
  self:AddChangeCallBack(self.OptionEnum.AutoLockDeadBoss, self.HandleSkillAutoLockDeadBoss)
  self:AddChangeCallBack(self.OptionEnum.AutoReload, self.HandleSkillAutoReload)
end

function SkillOptionManager:AddChangeCallBack(t, func)
  self._callBacks[t] = func
end

function SkillOptionManager:GetSkillOptionByType(t)
  return self._options[t] or 0
end

function SkillOptionManager:AskSetSkillOption(t, value)
  if 0 <= value then
    local opt = SceneSkill_pb.SkillOption()
    opt.opt = t
    opt.value = value
    ServiceSkillProxy.Instance:CallSkillOptionSkillCmd(opt)
  end
end

function SkillOptionManager:AskSetMultiSkillOption(type, value, values, subvalues, datas, param1)
  local guid
  if StringData[type] then
    guid = values[1]
    TableUtility.ArrayClear(values)
  end
  if type == self.OptionEnum.DelMultiTrap and values then
    for i = 1, #values do
      values[i] = values[i] // 1000
    end
  end
  ServiceSkillProxy.Instance:CallMultiSkillOptionUpdateSkillCmd(type, value, values, guid, subvalues, datas, param1)
end

function SkillOptionManager:RecvClearSkillOption()
  TableUtility.TableClear(self._options)
  TableUtility.TableClear(self._invalidSkills)
end

function SkillOptionManager:RecvServerOpts(opts)
  if opts ~= nil and 0 < #opts then
    for i = 1, #opts do
      self:HandleOpt(opts[i].opt, opts[i].value)
    end
  end
end

function SkillOptionManager:HandleOpt(t, value)
  local callBack = self._callBacks[t]
  local oldValue = self._options[t]
  if oldValue == nil then
    oldValue = 0
  end
  self._options[t] = value
  if callBack then
    callBack(self, oldValue, value)
  end
end

function SkillOptionManager:GetSkillOption_AutoQueue()
  return self:GetSkillOptionByType(self.OptionEnum.AutoQueue)
end

function SkillOptionManager:SetSkillOption_AutoQueue(value)
  self:AskSetSkillOption(self.OptionEnum.AutoQueue, value == true and 0 or 1)
end

function SkillOptionManager:GetSkillOption(optionType)
  return optionType ~= nil and self:GetSkillOptionByType(optionType) or 0
end

function SkillOptionManager:SetSkillOption(optionType, value)
  if optionType ~= nil then
    self:AskSetSkillOption(optionType, value)
  end
end

function SkillOptionManager:HandleSkillAutoQueue(oldValue, newValue)
  if newValue == 0 then
    Game.SkillClickUseManager:Launch()
  else
    Game.SkillClickUseManager:ShutDown()
  end
end

function SkillOptionManager:HandleSkillAutoLockMvp(oldValue, newValue)
  if not newValue then
    return
  end
  local myself = Game.Myself
  if not myself then
    return
  end
  local list = ReusableTable.CreateArray()
  list = NSceneNpcProxy.Instance:PickNpcs(function(npc)
    return npc.data:IsBossType_Mvp() and npc.data:GetFeature_CanAutoLock()
  end, list)
  for i = 1, #list do
    myself:OnAddNpc(list[i])
  end
  ReusableTable.DestroyAndClearArray(list)
end

function SkillOptionManager:HandleSkillAutoLockMini(oldValue, newValue)
  if not newValue then
    return
  end
  local myself = Game.Myself
  if not myself then
    return
  end
  local list = ReusableTable.CreateArray()
  list = NSceneNpcProxy.Instance:PickNpcs(function(npc)
    return npc.data:IsBossType_Mini() and npc.data:GetFeature_CanAutoLock()
  end, list)
  for i = 1, #list do
    myself:OnAddNpc(list[i])
  end
  ReusableTable.DestroyAndClearArray(list)
end

function SkillOptionManager:HandleSkillAutoLockDeadBoss(oldValue, newValue)
  if not newValue then
    return
  end
  local myself = Game.Myself
  if not myself then
    return
  end
  local list = ReusableTable.CreateArray()
  list = NSceneNpcProxy.Instance:PickNpcs(function(npc)
    return npc.data:IsBossType_Dead() and npc.data:GetFeature_CanAutoLock()
  end, list)
  for i = 1, #list do
    myself:OnAddNpc(list[i])
  end
  ReusableTable.DestroyAndClearArray(list)
end

function SkillOptionManager:RecvMultiSkillOptionSyncSkillCmd(data)
  for i = 1, #data.opts do
    self:UpdateMultiSkillOption(data.opts[i])
  end
end

function SkillOptionManager:RecvMultiSkillOptionUpdateSkillCmd(data)
  self:UpdateMultiSkillOption(data.opt)
  if #self._dirtySkills > 0 then
    EventManager.Me():PassEvent(SkillEvent.UpdateSubSkill, self._dirtySkills)
  end
end

function SkillOptionManager:UpdateMultiSkillOption(skillOption)
  local skillMap = self._options[skillOption.opt]
  if skillMap == nil then
    skillMap = {}
    self._options[skillOption.opt] = skillMap
  end
  local invalidMap = self._invalidSkills[skillOption.opt]
  if not invalidMap then
    invalidMap = {}
    self._invalidSkills[skillOption.opt] = invalidMap
  end
  TableUtility.TableClear(self._dirtySkills)
  local subSkillList = skillMap[skillOption.value]
  if subSkillList == nil then
    subSkillList = {}
    skillMap[skillOption.value] = subSkillList
  else
    for i = #subSkillList, 1, -1 do
      self._dirtySkills[subSkillList[i]] = 0
      subSkillList[i] = nil
    end
  end
  local value
  for i = 1, #skillOption.values do
    value = skillOption.values[i]
    if self._dirtySkills[value] == nil then
      self._dirtySkills[value] = 1
    else
      self._dirtySkills[value] = nil
    end
    subSkillList[#subSkillList + 1] = value
  end
  if (skillOption.opt == self.OptionEnum.SuperPositionSkill or skillOption.opt == self.OptionEnum.DelMultiTrap) and skillOption.values and #skillOption.values == 0 then
    for i = 1, #subSkillList do
      self._dirtySkills[subSkillList[i]] = 1
    end
    TableUtility.TableClear(self._options[skillOption.opt])
  end
  if StringData[skillOption.opt] and skillOption.guid ~= "" then
    TableUtility.ArrayClear(subSkillList)
    subSkillList[#subSkillList + 1] = skillOption.guid
  end
  local subSkillInvalidList = invalidMap[skillOption.value]
  if subSkillInvalidList == nil then
    subSkillInvalidList = {}
    invalidMap[skillOption.value] = subSkillInvalidList
  else
    for i = #subSkillInvalidList, 1, -1 do
      self._dirtySkills[subSkillInvalidList[i]] = 0
      subSkillInvalidList[i] = nil
    end
  end
  for i = 1, #skillOption.subvalues do
    value = skillOption.subvalues[i]
    if self._dirtySkills[value] == nil then
      self._dirtySkills[value] = 1
    else
      self._dirtySkills[value] = nil
    end
    subSkillInvalidList[#subSkillInvalidList + 1] = value
  end
  local data, skillid, flag
  if not self.switchSkills then
    self.switchSkills = {}
  end
  for i = 1, #skillOption.datas do
    data = skillOption.datas[i]
    skillid = data.skillid
    flag = data.flag
    if skillid then
      if self._dirtySkills[skillid] == nil then
        self._dirtySkills[skillid] = 1
      else
        self._dirtySkills[skillid] = nil
      end
      self.switchSkills[data.skillid] = flag
    end
  end
  if skillOption.param1 then
    self.extraOptions[skillOption.value] = skillOption.param1
  end
end

function SkillOptionManager:GetMultiSkillOption(optionType, skillid)
  local skillMap = self._options[optionType]
  if skillMap == nil then
    return
  end
  return skillMap[skillid]
end

function SkillOptionManager:IsInSkillOption(optionType, skillid, subSkillid)
  local skillList = self:GetMultiSkillOption(optionType, skillid)
  if skillList ~= nil then
    for i = 1, #skillList do
      if skillList[i] == subSkillid then
        return true
      end
    end
  end
  local invalidlist = self:GetMultiSkillInvalidOption(optionType, skillid)
  if invalidlist ~= nil then
    for i = 1, #invalidlist do
      if invalidlist[i] == subSkillid then
        return true
      end
    end
  end
  return false
end

function SkillOptionManager:GetMultiSkillInvalidOption(optionType, skillid)
  local skillMap = self._invalidSkills[optionType]
  if skillMap == nil then
    return
  end
  return skillMap[skillid]
end

function SkillOptionManager:SelectMount(skillid)
  local _BagProxy = BagProxy.Instance
  local equip = _BagProxy.roleEquip:GetMount()
  if equip then
    FunctionItemFunc.OffEquip_Equip(equip)
  else
    local itemData
    local skillList = self:GetMultiSkillOption(self.OptionEnum.SelectMount, skillid)
    if skillList then
      itemData = _BagProxy:GetItemByGuid(skillList[1])
    end
    if not itemData then
      local mountItems = _BagProxy:GetBagItemsByType(90)
      while 0 < #mountItems do
        local index = math.random(1, #mountItems)
        itemData = table.remove(mountItems, index)
        if itemData:CanEquip() then
          break
        end
      end
    end
    if itemData == nil or itemData.staticData.Type ~= 101 and not itemData:CanEquip() then
      return
    end
    FunctionItemFunc.EquipEvt(itemData)
  end
end

function SkillOptionManager:GetSkillOption_AutoReload()
  return self:GetSkillOptionByType(self.OptionEnum.AutoReload)
end

function SkillOptionManager:HandleSkillAutoReload(oldValue, newValue)
  if not newValue then
    return
  end
  local myself = Game.Myself
  if not myself then
    return
  end
  myself:RefreshAutoReloadStatus()
end

function SkillOptionManager:GetSkillOption_Switch(skillid)
  if not skillid then
    return false
  end
  return self.switchSkills[skillid] == true
end

local MutextID = 0

function SkillOptionManager:SetSkillOption_Switch(skillid, flag)
  self.switchSkills[skillid] = flag
  if flag then
    MutextID = MutexMap[skillid]
    if MutextID then
      self.switchSkills[MutextID] = not flag
    end
  end
  self:AskSetMultiSkillOption_Switch()
end

function SkillOptionManager:AskSetMultiSkillOption_Switch()
  local datas = {}
  for skillid, flag in pairs(self.switchSkills) do
    local single = {}
    single.skillid = skillid
    single.flag = flag
    table.insert(datas, single)
  end
  self:AskSetMultiSkillOption(self.OptionEnum.SwitchSkill, nil, nil, nil, datas)
end

function SkillOptionManager:GetSuperPositionSkillList()
  return self._options[self.OptionEnum.SuperPositionSkill]
end

function SkillOptionManager:GetExtraOptions(skillid)
  return self.extraOptions[skillid]
end
