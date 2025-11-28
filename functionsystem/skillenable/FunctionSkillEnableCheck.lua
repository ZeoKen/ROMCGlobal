autoImport("SkillPrecondCheck")
autoImport("SkillReplacePrecondCheck")
FunctionSkillEnableCheck = class("FunctionSkillEnableCheck")
local mAutoSkillGroup

function FunctionSkillEnableCheck.Me()
  if nil == FunctionSkillEnableCheck.me then
    FunctionSkillEnableCheck.me = FunctionSkillEnableCheck.new()
  end
  return FunctionSkillEnableCheck.me
end

function FunctionSkillEnableCheck:ctor()
  self:SetMySelf(Game.Myself)
  self.tick = TimeTickManager.Me():CreateTick(0, 100, self.TickCheck, self, 1, true)
  self:ResetConditionCache()
  self.usedSkillPassTime = {}
  self.stateSkill = {}
  self.typeChecks = {}
  self.typeChecks[SkillPrecondCheck.PreConditionType.AfterUseSkill] = self.AfterUseSkillCheck
  self.typeChecks[SkillPrecondCheck.PreConditionType.WearEquip] = self.WearEquipCheck
  self.typeChecks[SkillPrecondCheck.PreConditionType.HpMoreThan] = self.HpMoreThanCheck
  self.typeChecks[SkillPrecondCheck.PreConditionType.MyselfState] = self.MyselfStateCheck
  self.typeChecks[SkillPrecondCheck.PreConditionType.Partner] = self.MyselfPartnerCheck
  self.typeChecks[SkillPrecondCheck.PreConditionType.Buff] = self.BuffCheck
  self.typeChecks[SkillPrecondCheck.PreConditionType.BeingState] = self.BeingStateCheck
  self.typeChecks[SkillPrecondCheck.PreConditionType.EquipTakeOff] = self.RoleEquipTakeOffCheck
  self.typeChecks[SkillPrecondCheck.PreConditionType.EquipBreak] = self.RoleEquipBreakCheck
  self.typeChecks[SkillPrecondCheck.PreConditionType.Map] = self.MapCheck
  self.typeChecks[SkillPrecondCheck.PreConditionType.BuffActive] = self.BuffActiveCheck
  self.typeChecks[SkillPrecondCheck.PreConditionType.Pet] = self.MyselfPetCheck
  self.typeChecks[SkillPrecondCheck.PreConditionType.Bullets] = self.MyBulletsCheck
  self.typeChecks[SkillPrecondCheck.PreConditionType.DressPartMount] = self.DressPartMountCheck
  self.typeChecks[SkillPrecondCheck.PreConditionType.TargetHpLessThan] = self.TargetHpLessThanCheck
  self.typeChecks[SkillPrecondCheck.PreConditionType.InterferenceValue] = self.InterferenceValueCheck
  self.typeChecks[SkillPrecondCheck.PreConditionType.IsRideOnTeammate] = self.IsRideOnTeammateCheck
  self.typeOnAdd = {}
  self.typeOnAdd[SkillPrecondCheck.PreConditionType.MyselfState] = self.OnAddStateCheckSkill
  self.typeOnRemove = {}
  self.typeOnRemove[SkillPrecondCheck.PreConditionType.MyselfState] = self.OnRemoveStateCheckSkill
  self:AddListener()
  mAutoSkillGroup = {}
  if GameConfig.AutoSkillGroup then
    for k, v in pairs(GameConfig.AutoSkillGroup) do
      for i = 1, #v do
        mAutoSkillGroup[#mAutoSkillGroup + 1] = v[i]
      end
    end
  end
end

function FunctionSkillEnableCheck:AddListener()
  EventManager.Me():AddEventListener(SkillEvent.SkillEquip, self.AddCheckSkill, self)
  EventManager.Me():AddEventListener(SkillEvent.SkillDisEquip, self.RemoveCheckSkill, self)
  EventManager.Me():AddEventListener(SkillEvent.SkillUpdate, self.SkillUpdateHandler, self)
  EventManager.Me():AddEventListener(ServiceEvent.SkillMultiSkillOptionSyncSkillCmd, self.SkillOptionSyncHandler, self)
  EventManager.Me():AddEventListener(SkillEvent.UpdateSubSkill, self.SkillOptionUpdateHandler, self)
  EventManager.Me():AddEventListener(RoleEquipEvent.TakeOn, self.RoleEquipUpdateCheck, self)
  EventManager.Me():AddEventListener(RoleEquipEvent.TakeOff, self.RoleEquipUpdateCheck, self)
  EventManager.Me():AddEventListener(MyselfEvent.UsedSkill, self.UsedSkillCheck, self)
  EventManager.Me():AddEventListener(MyselfEvent.HpChange, self.HpCheck, self)
  EventManager.Me():AddEventListener(MyselfEvent.SpChange, self.HpCheck, self)
  EventManager.Me():AddEventListener(MyselfEvent.PartnerChange, self.PartnerUpdateCheck, self)
  EventManager.Me():AddEventListener(MyselfEvent.PetChange, self.PetUpdateCheck, self)
  EventManager.Me():AddEventListener(MyselfEvent.BuffChange, self.BuffUpdateCheck, self)
  EventManager.Me():AddEventListener(PetEvent.BeingInfoData_SummonChange, self.SummonChangeCheck, self)
  EventManager.Me():AddEventListener(PetEvent.BeingInfoData_AliveChange, self.SummonChangeCheck, self)
  EventManager.Me():AddEventListener(PetEvent.Being_CountChange, self.SummonChangeCheck, self)
  EventManager.Me():AddEventListener(LoadSceneEvent.FinishLoadScene, self.MapUpdateCheck, self)
  FunctionCheck.Me():AddEventListener(MyselfEvent.MyPropChange, self.PropChangeCheck, self)
  EventManager.Me():AddEventListener(RoleEquipEvent.OffPosBegin, self.RoleEquipTakeOffBeginCheck, self)
  EventManager.Me():AddEventListener(RoleEquipEvent.AllOffPosEnd, self.RoleEquipTakeOffAllEndCheck, self)
  EventManager.Me():AddEventListener(RoleEquipEvent.BreakEquipBegin, self.RoleEquipBreakBeginCheck, self)
  EventManager.Me():AddEventListener(RoleEquipEvent.AllBreakEquipEnd, self.RoleEquipBreakAllEndCheck, self)
  EventManager.Me():AddEventListener(MyselfEvent.CurBulletsChange, self.BulletsUpdateCheck, self)
  EventManager.Me():AddEventListener(MyselfEvent.ChangeDress, self.DresspartMountUpdateCheck, self)
  EventManager.Me():AddEventListener(MyselfEvent.SelectTargetChange, self.TargetUpdateCheck, self)
  EventManager.Me():AddEventListener(MyselfEvent.SelectTarget_HpChange, self.TargetHpUpdateCheck, self)
  EventManager.Me():AddEventListener(MyselfEvent.InterferenceValueChange, self.InterferenceValueUpdateCheck, self)
  EventManager.Me():AddEventListener(MyselfEvent.RidePlayerChange, self.RidePlayerCheck, self)
  EventManager.Me():AddEventListener(MyselfEvent.AsEquipChange, self.EquipCheck, self)
end

function FunctionSkillEnableCheck:Log(arg1, arg2, arg3, arg4, arg5)
  if self.enableLog then
    helplog(arg1, arg2, arg3, arg4, arg5)
  end
end

function FunctionSkillEnableCheck:Reset()
end

function FunctionSkillEnableCheck:SetMySelf(myself)
  if myself then
    self.myself = myself
  end
end

function FunctionSkillEnableCheck:Launch()
  if self.isRunning then
    return
  end
  self.isRunning = true
end

function FunctionSkillEnableCheck:ShutDown()
  if not self.isRunning then
    return
  end
  self.isRunning = false
end

function FunctionSkillEnableCheck:SkillUpdateHandler(dirtyGUIDMap)
  if SkillProxy.Instance.equipedAutoArrayDirty then
    local skill, incheck
    local instance = SkillProxy.Instance
    for i = 1, #mAutoSkillGroup do
      skill = instance:GetLearnedSkillBySortID(mAutoSkillGroup[i])
      if skill then
        incheck = self.skillsCondition[skill.guid]
        if skill and not incheck then
          self:AddCheckSkill(skill)
        end
      end
    end
    for k, v in pairs(self.skillsCondition) do
      self:PureAddCheckSubSkill(v.skillItemData)
    end
    for k, v in pairs(self.skillsCondition) do
      skill = instance:GetLearnedSkill(v.skillItemData.id)
      if skill == nil then
        self:RemoveCheckSkill(v.skillItemData)
      end
    end
  end
  if SkillProxy.Instance:HasLearnedSkill(ReloadSkillID) then
    local instance = SkillProxy.Instance
    local skill = instance:GetLearnedSkillBySortID(math.floor(ReloadSkillID / 1000))
    self:AddCheckSkill(skill)
  end
  if dirtyGUIDMap then
    for guid, conditionCheck in pairs(self.skillsCondition) do
      if dirtyGUIDMap[guid] then
        if self:AddOrUpdateTypeCheck(conditionCheck.skillItemData, conditionCheck) then
          self:CheckSkill(conditionCheck)
        else
          conditionCheck:Reset()
          self:_SetSkillPreCondAndFireEvent(conditionCheck.skillItemData, true)
        end
      end
    end
  end
end

function FunctionSkillEnableCheck:SkillOptionSyncHandler(data)
  local opt, subSkillList, subSkill
  local BuffSkillList = SkillOptionManager.OptionEnum.BuffSkillList
  local instance = SkillProxy.Instance
  local CheckReasonSubSkill = SkillPrecondCheck.CheckReason.SubSkill
  for i = 1, #data.opts do
    opt = data.opts[i]
    if opt.opt == BuffSkillList then
      subSkillList = Game.SkillOptionManager:GetMultiSkillOption(opt.opt, opt.value)
      if subSkillList ~= nil then
        for i = 1, #subSkillList do
          subSkill = instance:GetLearnedSkill(subSkillList[i])
          if subSkill ~= nil then
            self:PureAddCheckSkill(subSkill, CheckReasonSubSkill)
          end
        end
      end
    end
  end
end

function FunctionSkillEnableCheck:SkillOptionUpdateHandler(data)
  local subSkill
  local instance = SkillProxy.Instance
  local CheckReasonSubSkill = SkillPrecondCheck.CheckReason.SubSkill
  for k, v in pairs(data) do
    subSkill = instance:GetLearnedSkill(k)
    if subSkill ~= nil then
      if v == 1 then
        self:PureAddCheckSkill(subSkill, CheckReasonSubSkill)
      elseif v == 0 then
        self:PureRemoveCheckSkill(subSkill, CheckReasonSubSkill)
      end
    end
  end
end

function FunctionSkillEnableCheck:AddCheckSkill(skillItemData, checkReason)
  self:PureAddCheckSkill(skillItemData, checkReason)
  self:PureAddCheckSubSkill(skillItemData)
end

function FunctionSkillEnableCheck:RemoveCheckSkill(skillItemData, checkReason)
  self:PureRemoveCheckSkill(skillItemData, checkReason)
  self:PureRemoveCheckSubSkill(skillItemData)
end

function FunctionSkillEnableCheck:PureAddCheckSkill(skillItemData, checkReason)
  checkReason = checkReason or SkillPrecondCheck.CheckReason.Skill
  local preCondtionCheck = self.skillsCondition[skillItemData.guid]
  if preCondtionCheck == nil then
    preCondtionCheck = SkillPrecondCheck.new(skillItemData)
    preCondtionCheck:SetCheckReason(checkReason)
    self:AddOrUpdateTypeCheck(skillItemData, preCondtionCheck)
    self.skillsCondition[skillItemData.guid] = preCondtionCheck
    self:CheckSkill(preCondtionCheck)
  else
    preCondtionCheck:SetCheckReason(checkReason)
  end
end

function FunctionSkillEnableCheck:PureRemoveCheckSkill(skillItemData, checkReason)
  checkReason = checkReason or SkillPrecondCheck.CheckReason.Skill
  local preCondtionCheck = self.skillsCondition[skillItemData.guid]
  if preCondtionCheck then
    preCondtionCheck:RemoveCheckReason(checkReason)
    if not preCondtionCheck:HasCheckReason() then
      self:OnRemoveStateCheckSkill(preCondtionCheck)
      self:RemoveTypeCheck(skillItemData)
      self.skillsCondition[skillItemData.guid] = nil
    end
  end
end

function FunctionSkillEnableCheck:PureAddCheckSubSkill(skillItemData)
  if skillItemData:HasSubSkill() then
    local subSkillList = Game.SkillOptionManager:GetMultiSkillOption(SkillOptionManager.OptionEnum.BuffSkillList, skillItemData:GetID())
    if subSkillList ~= nil then
      local subSkill, condition
      local instance = SkillProxy.Instance
      local CheckReasonSubSkill = SkillPrecondCheck.CheckReason.SubSkill
      for i = 1, #subSkillList do
        subSkill = instance:GetLearnedSkill(subSkillList[i])
        if subSkill ~= nil then
          self:PureAddCheckSkill(subSkill, CheckReasonSubSkill)
        end
      end
    end
  end
end

function FunctionSkillEnableCheck:PureRemoveCheckSubSkill(skillItemData)
  if skillItemData:HasSubSkill() then
    local subSkillList = Game.SkillOptionManager:GetMultiSkillOption(SkillOptionManager.OptionEnum.BuffSkillList, skillItemData:GetID())
    if subSkillList ~= nil then
      local subSkill, condition
      local instance = SkillProxy.Instance
      local CheckReasonSubSkill = SkillPrecondCheck.CheckReason.SubSkill
      for i = 1, #subSkillList do
        subSkill = instance:GetLearnedSkill(subSkillList[i])
        if subSkill ~= nil then
          condition = self.skillsCondition[subSkill.guid]
          if condition ~= nil then
            self:PureRemoveCheckSkill(subSkill, CheckReasonSubSkill)
          end
        end
      end
    end
  end
end

function FunctionSkillEnableCheck:OnAddStateCheckSkill(preCondtionCheck)
  local skill = preCondtionCheck.skillItemData
  local preConditions = skill:GetPreCondition()
  local prop, preCondition
  for i = 1, #preConditions do
    preCondition = preConditions[i]
    for k, v in pairs(preCondition) do
      if k ~= "type" then
        prop = k
        if prop then
          local skills = self.stateSkill[prop]
          if skills == nil then
            skills = {}
            self.stateSkill[prop] = skills
          end
          local index = TableUtil.ArrayIndexOf(skills, preCondtionCheck)
          if index == 0 then
            skills[#skills + 1] = preCondtionCheck
          end
        end
      end
    end
  end
end

function FunctionSkillEnableCheck:OnRemoveStateCheckSkill(preCondtionCheck)
  local skill = preCondtionCheck.skillItemData
  local preConditions = skill:GetPreCondition()
  local preCondition
  for i = 1, #preConditions do
    preCondition = preConditions[i]
    if preCondition.type == SkillPrecondCheck.PreConditionType.MyselfState then
      local prop
      for k, v in pairs(preCondition) do
        if k ~= "type" then
          prop = k
          if prop then
            local skills = self.stateSkill[prop]
            if skills then
              TableUtil.Remove(skills, preCondtionCheck)
            end
          end
        end
      end
    end
  end
end

local importedSkillFunc = false

function FunctionSkillEnableCheck:AddOrUpdateTypeCheck(skill, preCondtionCheck)
  self:RemoveTypeCheck(skill)
  if not importedSkillFunc then
    autoImport("SkillHelperFunc")
    importedSkillFunc = true
  end
  local preCondition = skill:GetPreCondition()
  if not preCondition then
    return false
  end
  if preCondition.ProType then
    preCondition = SkillHelperFunc.GetProRelateCheckTypes(preCondition.ProType)
  end
  if #preCondition == 0 then
    return false
  end
  local pcond, pcondType
  for i = 1, #preCondition do
    pcond = preCondition[i]
    if type(pcond) == "number" then
      pcondType = pcond
    else
      pcondType = pcond.type
    end
    local typeMap = self.skillsTypeCheck[pcondType]
    if typeMap == nil then
      typeMap = {}
      self.skillsTypeCheck[pcondType] = typeMap
    end
    local onAdd = self.typeOnAdd[pcondType]
    if onAdd then
      onAdd(self, preCondtionCheck)
    end
    typeMap[skill.guid] = preCondtionCheck
    self.skillsTypeCheck.whole[skill.guid] = preCondtionCheck
  end
  return true
end

function FunctionSkillEnableCheck:RemoveTypeCheck(skill)
  for _, typeMap in pairs(self.skillsTypeCheck) do
    typeMap[skill.guid] = nil
  end
end

function FunctionSkillEnableCheck:GetFirstNotFitPrecondition(skillItemData)
  local precondition = self.skillsTypeCheck.whole[skillItemData.guid]
  if precondition and precondition:HasReason() then
    return precondition:GetFirstReason()
  end
  return nil
end

function FunctionSkillEnableCheck:MsgNotFit(skillItemData)
  local precondition = self.skillsTypeCheck.whole[skillItemData.guid]
  if precondition then
    precondition:MsgReason()
  end
end

function FunctionSkillEnableCheck:CheckSkill(conditionCheck)
  local skill = conditionCheck.skillItemData
  local preCondition = skill:GetPreCondition()
  if not importedSkillFunc then
    autoImport("SkillHelperFunc")
    importedSkillFunc = true
  end
  if preCondition then
    if preCondition.ProType then
      local res = SkillHelperFunc.CheckPrecondtionByProType(preCondition.ProType, Game.Myself.data, skill:GetID())
      self:_SetSkillPreCondAndFireEvent(skill, res)
    elseif 0 < #preCondition then
      local pcond, pcondType
      for i = 1, #preCondition do
        pcond = preCondition[i]
        if type(pcond) == "number" then
          pcondType = pcond
        else
          pcondType = pcond.type
        end
        local check = self.typeChecks[pcondType]
        if check then
          check(self, conditionCheck)
        end
      end
    end
  end
end

function FunctionSkillEnableCheck:UpdateReason(check, state, skill, reason)
  if state then
    check:SetReason(reason and reason or skill.guid)
  else
    check:RemoveReason(reason and reason or skill.guid)
  end
  if check:IsDirty() then
    self:_SetSkillPreCondAndFireEvent(skill, check:HasReason())
  end
end

function FunctionSkillEnableCheck:_ProCheckSkillPreCond(conditionCheck)
  if not importedSkillFunc then
    autoImport("SkillHelperFunc")
    importedSkillFunc = true
  end
  local skill = conditionCheck.skillItemData
  local preCondition = skill:GetPreCondition()
  if preCondition and preCondition.ProType then
    local res = SkillHelperFunc.CheckPrecondtionByProType(preCondition.ProType, Game.Myself.data, skill:GetID())
    self:_SetSkillPreCondAndFireEvent(skill, res)
    return true
  end
  return false
end

function FunctionSkillEnableCheck:_SetSkillPreCondAndFireEvent(skill, value)
  local nowPrecond = skill:GetFitPreCond()
  if nowPrecond ~= value then
    skill:SetFitPreCond(value)
    EventManager.Me():PassEvent(SkillEvent.SkillFitPreCondtion, skill)
  end
end

function FunctionSkillEnableCheck:BuffCheck(conditionCheck)
  local skill = conditionCheck.skillItemData
  local needChecks = conditionCheck:GetPrecondtionsByType(SkillPrecondCheck.PreConditionType.Buff)
  local myself = Game.Myself
  if needChecks then
    local preCondition, layer
    for i = 1, #needChecks do
      preCondition = needChecks[i]
      layer = preCondition.layer or 1
      if layer <= myself:GetBuffLayer(preCondition.id) then
        self:UpdateReason(conditionCheck, true, skill, preCondition)
      else
        self:UpdateReason(conditionCheck, false, skill, preCondition)
      end
    end
  end
end

function FunctionSkillEnableCheck:BuffActiveCheck(conditionCheck)
  local needChecks = conditionCheck:GetPrecondtionsByType(SkillPrecondCheck.PreConditionType.BuffActive)
  if needChecks then
    local preCondition
    local myself = Game.Myself
    local skill = conditionCheck.skillItemData
    for i = 1, #needChecks do
      preCondition = needChecks[i]
      if myself:GetBuffActive(preCondition.buffid) then
        self:UpdateReason(conditionCheck, true, skill, preCondition)
      else
        self:UpdateReason(conditionCheck, false, skill, preCondition)
      end
    end
  end
end

function FunctionSkillEnableCheck:AfterUseSkillCheck(conditionCheck)
  local skill = conditionCheck.skillItemData
  local needChecks = conditionCheck:GetPrecondtionsByType(SkillPrecondCheck.PreConditionType.AfterUseSkill)
  if needChecks then
    local preCondition
    for i = 1, #needChecks do
      preCondition = needChecks[i]
      local passedTime = self.usedSkillPassTime[preCondition.skillid]
      if passedTime ~= nil and passedTime <= preCondition.time then
        self:UpdateReason(conditionCheck, true, skill, preCondition)
      else
        self:UpdateReason(conditionCheck, false, skill, preCondition)
      end
    end
  end
end

function FunctionSkillEnableCheck:WearEquipCheck(conditionCheck)
  local skill = conditionCheck.skillItemData
  local equipBag = BagProxy.Instance:GetRoleEquipBag()
  local needChecks = conditionCheck:GetPrecondtionsByType(SkillPrecondCheck.PreConditionType.WearEquip)
  if needChecks then
    local preCondition
    local equipNoneCheck = false
    for i = 1, #needChecks do
      preCondition = needChecks[i]
      if preCondition.itemtype == 0 then
        equipNoneCheck = true
      end
    end
    for i = 1, #needChecks do
      preCondition = needChecks[i]
      local itemtype = preCondition.itemtype
      local itemid = preCondition.itemid
      local equipFeature = preCondition.equipFeature
      if itemtype ~= nil then
        local num = equipBag:GetNumByItemType(itemtype)
        local weaponNum = equipBag:GetWeapon()
        local checksite = self.myself:GetAsEquipSite(itemtype)
        if checksite then
          local checkNum = equipBag:GetEquipBySite(checksite)
          if checkNum then
            num = 1
          end
        end
        if itemtype == 0 then
          if not weaponNum then
            self:UpdateReason(conditionCheck, true, skill, preCondition)
          else
            self:UpdateReason(conditionCheck, false, skill, preCondition)
          end
        elseif num and 0 < num then
          self:UpdateReason(conditionCheck, true, skill, preCondition)
        else
          self:UpdateReason(conditionCheck, false, skill, preCondition)
        end
      elseif itemid ~= nil then
        local num = equipBag:GetStaticIdMap()[itemid]
        if num ~= nil then
          self:UpdateReason(conditionCheck, true, skill, preCondition)
        else
          self:UpdateReason(conditionCheck, false, skill, preCondition)
        end
      elseif equipFeature ~= nil then
        local num = equipBag:GetNumByEquipFeature(equipFeature)
        if 0 < num then
          self:UpdateReason(conditionCheck, true, skill, preCondition)
        else
          self:UpdateReason(conditionCheck, false, skill, preCondition)
        end
      end
    end
  end
end

function FunctionSkillEnableCheck:HpMoreThanCheck(conditionCheck)
  if self.myself then
    local skill = conditionCheck.skillItemData
    local needChecks = conditionCheck:GetPrecondtionsByType(SkillPrecondCheck.PreConditionType.HpMoreThan)
    if needChecks then
      local preCondition, checkPercent, percent
      for i = 1, #needChecks do
        preCondition = needChecks[i]
        if preCondition.value then
          checkPercent = preCondition.value
          percent = self.myself.data.props:GetPropByName("Hp"):GetValue() / self.myself.data.props:GetPropByName("MaxHp"):GetValue() * 100
        elseif preCondition.spvalue then
          checkPercent = preCondition.spvalue
          percent = self.myself.data.props:GetPropByName("Sp"):GetValue() / self.myself.data.props:GetPropByName("MaxSp"):GetValue() * 100
        end
        if checkPercent < percent then
          self:UpdateReason(conditionCheck, true, skill, preCondition)
        else
          self:UpdateReason(conditionCheck, false, skill, preCondition)
        end
      end
    end
  end
end

function FunctionSkillEnableCheck:MyselfPartnerCheck(conditionCheck, partnerID)
  if self.myself then
    local skill = conditionCheck.skillItemData
    partnerID = partnerID or self.myself.data.userdata:Get(UDEnum.PET_PARTNER)
    local needChecks = conditionCheck:GetPrecondtionsByType(SkillPrecondCheck.PreConditionType.Partner)
    if needChecks then
      local preCondition
      for i = 1, #needChecks do
        preCondition = needChecks[i]
        local fitParnter = false
        for i = 1, #preCondition.id do
          if partnerID == preCondition.id[i] then
            fitParnter = true
          end
        end
        if fitParnter then
          self:UpdateReason(conditionCheck, true, skill, preCondition)
        else
          self:UpdateReason(conditionCheck, false, skill, preCondition)
        end
      end
    end
  end
end

function FunctionSkillEnableCheck:MyselfPetCheck(conditionCheck)
  if self.myself then
    local needChecks = conditionCheck:GetPrecondtionsByType(SkillPrecondCheck.PreConditionType.Pet)
    if needChecks then
      local preCondition
      local skill = conditionCheck.skillItemData
      for i = 1, #needChecks do
        preCondition = needChecks[i]
        if self.myself.data:GetPetCount(preCondition.npctype) > 0 then
          self:UpdateReason(conditionCheck, true, skill, preCondition)
        else
          self:UpdateReason(conditionCheck, false, skill, preCondition)
        end
      end
    end
  end
end

function FunctionSkillEnableCheck:GetPrecondtionProp(preCondition)
  local prop
  for k, v in pairs(preCondition) do
    if k ~= "type" then
      prop = k
      break
    end
  end
  return prop
end

function FunctionSkillEnableCheck:MyselfStateCheck(conditionCheck, prop)
  if self.myself then
    local skill = conditionCheck.skillItemData
    local preCondition = skill:GetPreCondition()
    local needChecks = conditionCheck:GetPrecondtionsByType(SkillPrecondCheck.PreConditionType.MyselfState)
    if needChecks then
      local preCondition
      if prop == nil then
        for i = 1, #needChecks do
          preCondition = needChecks[i]
          for k, v in pairs(preCondition) do
            if k ~= "type" then
              prop = k
              if prop then
                prop = self.myself.data.props[prop]
                self:PropCheck(conditionCheck, prop, skill, preCondition)
              end
            end
          end
        end
      else
        for i = 1, #needChecks do
          preCondition = needChecks[i]
          local condP = self:GetPrecondtionProp(preCondition)
          if condP and condP == prop.propVO.name then
            break
          end
        end
        self:PropCheck(conditionCheck, prop, skill, preCondition)
      end
    end
  end
end

function FunctionSkillEnableCheck:PropCheck(conditionCheck, prop, skill, preCondition)
  if prop then
    local propValue = prop:GetValue()
    if prop.propVO.name == "AttrEffect" then
      propValue = BitUtil.band(propValue, preCondition.AttrEffect - 1)
    end
    if 0 < propValue then
      self:UpdateReason(conditionCheck, true, skill, preCondition)
    else
      self:UpdateReason(conditionCheck, false, skill, preCondition)
    end
  else
    self:UpdateReason(conditionCheck, true, skill, preCondition)
  end
end

function FunctionSkillEnableCheck:UsedSkillCheck(skillIDAndLevel, passedTime)
  passedTime = passedTime or 0
  local skillID = math.floor(skillIDAndLevel / 1000)
  local preConditions = self.skillsTypeCheck[SkillPrecondCheck.PreConditionType.AfterUseSkill]
  if preConditions then
    local preCondition
    for k, v in pairs(preConditions) do
      local needChecks = v:GetPrecondtionsByType(SkillPrecondCheck.PreConditionType.AfterUseSkill)
      if needChecks then
        local preCondition
        for i = 1, #needChecks do
          preCondition = needChecks[i]
          if preCondition.skillid == skillID then
            if passedTime <= preCondition.time then
              self:UpdateReason(v, true, v.skillItemData, preCondition)
            else
              self:UpdateReason(v, false, v.skillItemData, preCondition)
            end
          end
        end
      end
    end
  end
  self.usedSkillPassTime[skillID] = passedTime
end

function FunctionSkillEnableCheck:RoleEquipUpdateCheck(item)
  local preConditions = self.skillsTypeCheck[SkillPrecondCheck.PreConditionType.WearEquip]
  if preConditions then
    local equipBag = BagProxy.Instance:GetRoleEquipBag()
    local numType = equipBag:GetNumByItemType(item.staticData.Type)
    local num = equipBag:GetStaticIdMap()[item.staticData.id]
    local weaponNum = equipBag:GetWeapon()
    local checkAsEquip = self.myself:GetAsEquip(item.index)
    if not numType or numType < 0 then
      checkAsEquip = false
    end
    for k, v in pairs(preConditions) do
      if self:_ProCheckSkillPreCond(v) == false then
        local needChecks = v:GetPrecondtionsByType(SkillPrecondCheck.PreConditionType.WearEquip)
        if needChecks then
          local preCondition
          for i = 1, #needChecks do
            preCondition = needChecks[i]
            if preCondition.itemtype == 0 then
              if not weaponNum then
                self:UpdateReason(v, true, v.skillItemData, preCondition)
              else
                self:UpdateReason(v, false, v.skillItemData, preCondition)
              end
            elseif preCondition.itemtype == item.staticData.Type or checkAsEquip then
              if numType and 0 < numType then
                self:UpdateReason(v, true, v.skillItemData, preCondition)
              else
                self:UpdateReason(v, false, v.skillItemData, preCondition)
              end
            elseif preCondition.itemid == item.staticData.id then
              if num ~= nil then
                self:UpdateReason(v, true, v.skillItemData, preCondition)
              else
                self:UpdateReason(v, false, v.skillItemData, preCondition)
              end
            elseif preCondition.equipFeature ~= nil and item.equipInfo ~= nil and item.equipInfo:HasFeature(preCondition.equipFeature) then
              if 0 < equipBag:GetNumByEquipFeature(preCondition.equipFeature) then
                self:UpdateReason(v, true, v.skillItemData, preCondition)
              else
                self:UpdateReason(v, false, v.skillItemData, preCondition)
              end
            end
          end
        end
      end
    end
  end
end

function FunctionSkillEnableCheck:BuffUpdateCheck()
  local preCondition
  local myself = Game.Myself
  local preConditions = self.skillsTypeCheck[SkillPrecondCheck.PreConditionType.Buff]
  if preConditions then
    for k, v in pairs(preConditions) do
      self:_ProCheckSkillPreCond(v)
      local needChecks = v:GetPrecondtionsByType(SkillPrecondCheck.PreConditionType.Buff)
      if needChecks then
        local layer
        for i = 1, #needChecks do
          preCondition = needChecks[i]
          layer = preCondition.layer or 1
          if layer <= myself:GetBuffLayer(preCondition.id) then
            self:UpdateReason(v, true, v.skillItemData, preCondition)
          else
            self:UpdateReason(v, false, v.skillItemData, preCondition)
          end
        end
      end
    end
  end
  preConditions = self.skillsTypeCheck[SkillPrecondCheck.PreConditionType.BuffActive]
  if preConditions then
    for k, v in pairs(preConditions) do
      self:_ProCheckSkillPreCond(v)
      local needChecks = v:GetPrecondtionsByType(SkillPrecondCheck.PreConditionType.BuffActive)
      if needChecks then
        for i = 1, #needChecks do
          preCondition = needChecks[i]
          if myself:GetBuffActive(preCondition.buffid) then
            self:UpdateReason(v, true, v.skillItemData, preCondition)
          else
            self:UpdateReason(v, false, v.skillItemData, preCondition)
          end
        end
      end
    end
  end
end

function FunctionSkillEnableCheck:HpCheck()
  local preConditions = self.skillsTypeCheck[SkillPrecondCheck.PreConditionType.HpMoreThan]
  if preConditions then
    local preCondition, checkPercent, percent
    for k, v in pairs(preConditions) do
      if self:_ProCheckSkillPreCond(v) == false then
        local needChecks = v:GetPrecondtionsByType(SkillPrecondCheck.PreConditionType.HpMoreThan)
        if needChecks then
          local preCondition
          for i = 1, #needChecks do
            preCondition = needChecks[i]
            if preCondition.value then
              checkPercent = preCondition.value
              percent = self.myself.data.props:GetPropByName("Hp"):GetValue() / self.myself.data.props:GetPropByName("MaxHp"):GetValue() * 100
            elseif preCondition.spvalue then
              checkPercent = preCondition.spvalue
              percent = self.myself.data.props:GetPropByName("Sp"):GetValue() / self.myself.data.props:GetPropByName("MaxSp"):GetValue() * 100
            end
            if checkPercent < percent then
              self:UpdateReason(v, true, v.skillItemData, preCondition)
            else
              self:UpdateReason(v, false, v.skillItemData, preCondition)
            end
          end
        end
      end
    end
  end
end

function FunctionSkillEnableCheck:PropChangeCheck(p)
  local propName = p.propVO.name
  local relativeSkills = self.stateSkill[propName]
  if relativeSkills then
    for k, v in pairs(relativeSkills) do
      self:MyselfStateCheck(v, p)
    end
  end
end

function FunctionSkillEnableCheck:PartnerUpdateCheck(id)
  local preConditions = self.skillsTypeCheck[SkillPrecondCheck.PreConditionType.Partner]
  if preConditions then
    for k, v in pairs(preConditions) do
      self:_ProCheckSkillPreCond(v)
      self:MyselfPartnerCheck(v, id)
    end
  end
end

function FunctionSkillEnableCheck:PetUpdateCheck(id)
  local preConditions = self.skillsTypeCheck[SkillPrecondCheck.PreConditionType.Pet]
  if preConditions then
    local pet = NScenePetProxy.Instance:Find(id)
    if pet ~= nil then
      for k, v in pairs(preConditions) do
        self:MyselfPetCheck(v)
      end
    end
  end
end

function FunctionSkillEnableCheck:TickCheck(deltaTime)
  for k, v in pairs(self.usedSkillPassTime) do
    v = v + deltaTime
    self.usedSkillPassTime[k] = v
  end
  local skills = self.skillsTypeCheck[SkillPrecondCheck.PreConditionType.AfterUseSkill]
  if skills then
    for k, v in pairs(skills) do
      self:AfterUseSkillCheck(v)
    end
  end
end

function FunctionSkillEnableCheck:LearnedSkillCheck(skillIDAndLevel)
  local skill = Table_Skill[skillIDAndLevel]
  if skill then
    local preConditions = skill.PreCondition
    if preConditions then
      local precond
      for i = 1, #preConditions do
        precond = preConditions[i]
        if precond ~= nil and precond.type == SkillPrecondCheck.PreConditionType.LearnedSkill then
          return SkillProxy.Instance:GetLearnedSkillBySortID(precond.skillid) ~= nil, precond.skillid
        end
      end
    end
  end
  return true
end

function FunctionSkillEnableCheck:BeingStateCheck(conditionCheck)
  local skill = conditionCheck.skillItemData
  local needChecks = conditionCheck:GetPrecondtionsByType(SkillPrecondCheck.PreConditionType.BeingState)
  if needChecks then
    local preCondition
    local _PetProxy = PetProxy.Instance
    local list = _PetProxy:GetMySummonBeingList()
    local count = MyselfProxy.Instance:GetBeingCount()
    for i = 1, #needChecks do
      preCondition = needChecks[i]
      if preCondition.not_exist then
        if count > #list then
          self:UpdateReason(conditionCheck, true, skill, preCondition)
        else
          self:UpdateReason(conditionCheck, false, skill, preCondition)
        end
      elseif preCondition.died then
        local died = false
        for i = 1, #list do
          local summoned = _PetProxy:GetMyBeingNpcInfo(list[i])
          if summoned ~= nil and not summoned:IsAlive() then
            died = true
            break
          end
        end
        if died then
          self:UpdateReason(conditionCheck, true, skill, preCondition)
        else
          self:UpdateReason(conditionCheck, false, skill, preCondition)
        end
      elseif preCondition.alive then
        local id = preCondition.alive
        local alive = false
        for i = 1, #list do
          local summoned = _PetProxy:GetMyBeingNpcInfo(list[i])
          if summoned ~= nil and summoned:IsAliveAndNotBeEaten() and (id == 1 or id == summoned.beingid) then
            alive = true
            break
          end
        end
        if alive then
          self:UpdateReason(conditionCheck, true, skill, preCondition)
        else
          self:UpdateReason(conditionCheck, false, skill, preCondition)
        end
      end
    end
  end
end

function FunctionSkillEnableCheck:SummonChangeCheck()
  local preConditions = self.skillsTypeCheck[SkillPrecondCheck.PreConditionType.BeingState]
  if preConditions then
    local preCondition
    for k, v in pairs(preConditions) do
      if self:_ProCheckSkillPreCond(v) == false then
        self:BeingStateCheck(v)
      end
    end
  end
end

function FunctionSkillEnableCheck:RoleEquipTakeOffCheck(conditionCheck)
  self:_ConditionCheckRoleEquipTakeOffHandle(conditionCheck, FunctionEquipPosState.Me():HasOffEquipPos())
end

function FunctionSkillEnableCheck:_ConditionCheckRoleEquipTakeOffHandle(conditionCheck, hasEquipTakeOff)
  local skill = conditionCheck.skillItemData
  local needChecks = conditionCheck:GetPrecondtionsByType(SkillPrecondCheck.PreConditionType.EquipTakeOff)
  if needChecks then
    local preCondition
    for i = 1, #needChecks do
      preCondition = needChecks[i]
      if preCondition.value ~= nil then
        if preCondition.value == 1 then
          self:UpdateReason(conditionCheck, hasEquipTakeOff, skill, preCondition)
        else
          self:UpdateReason(conditionCheck, not hasEquipTakeOff, skill, preCondition)
        end
      end
    end
  end
end

function FunctionSkillEnableCheck:_RoleEquipTakeOffHandle(hasEquipTakeOff)
  local preConditions = self.skillsTypeCheck[SkillPrecondCheck.PreConditionType.EquipTakeOff]
  if preConditions then
    local preCondition
    for k, v in pairs(preConditions) do
      if self:_ProCheckSkillPreCond(v) == false then
        self:_ConditionCheckRoleEquipTakeOffHandle(v, hasEquipTakeOff)
      end
    end
  end
end

function FunctionSkillEnableCheck:RoleEquipTakeOffBeginCheck()
  self:_RoleEquipTakeOffHandle(true)
end

function FunctionSkillEnableCheck:RoleEquipTakeOffAllEndCheck()
  self:_RoleEquipTakeOffHandle(false)
end

function FunctionSkillEnableCheck:RoleEquipBreakCheck(conditionCheck)
  self:_ConditionCheckRoleEquipBreakHandle(conditionCheck, BagProxy.Instance:GetRoleEquipBag():HasBreakItem())
end

function FunctionSkillEnableCheck:_ConditionCheckRoleEquipBreakHandle(conditionCheck, hasEquipBreak)
  local skill = conditionCheck.skillItemData
  local needChecks = conditionCheck:GetPrecondtionsByType(SkillPrecondCheck.PreConditionType.EquipBreak)
  if needChecks then
    local preCondition
    for i = 1, #needChecks do
      preCondition = needChecks[i]
      if preCondition.value ~= nil then
        if preCondition.value == 1 then
          self:UpdateReason(conditionCheck, hasEquipBreak, skill, preCondition)
        else
          self:UpdateReason(conditionCheck, not hasEquipBreak, skill, preCondition)
        end
      end
    end
  end
end

function FunctionSkillEnableCheck:_RoleEquipBreakHandle(hasEquipBreak)
  local preConditions = self.skillsTypeCheck[SkillPrecondCheck.PreConditionType.EquipBreak]
  if preConditions then
    local preCondition
    for k, v in pairs(preConditions) do
      if self:_ProCheckSkillPreCond(v) == false then
        self:_ConditionCheckRoleEquipBreakHandle(v, hasEquipBreak)
      end
    end
  end
end

function FunctionSkillEnableCheck:RoleEquipBreakBeginCheck()
  self:_RoleEquipBreakHandle(true)
end

function FunctionSkillEnableCheck:RoleEquipBreakAllEndCheck()
  self:_RoleEquipBreakHandle(false)
end

function FunctionSkillEnableCheck:MapCheck(conditionCheck)
  local skill = conditionCheck.skillItemData
  local needChecks = conditionCheck:GetPrecondtionsByType(SkillPrecondCheck.PreConditionType.Map)
  if needChecks then
    local preCondition
    local mapid = Game.MapManager:GetMapID()
    local serverid = MyselfProxy.Instance:GetServerId()
    for i = 1, #needChecks do
      preCondition = needChecks[i]
      if preCondition.id == mapid then
        if not preCondition.serverid or preCondition.serverid and TableUtility.ArrayFindIndex(preCondition.serverid, serverid) > 0 then
          self:UpdateReason(conditionCheck, true, skill, preCondition)
        else
          self:UpdateReason(conditionCheck, false, skill, preCondition)
        end
      else
        self:UpdateReason(conditionCheck, false, skill, preCondition)
      end
    end
  end
end

function FunctionSkillEnableCheck:MapUpdateCheck()
  local preConditions = self.skillsTypeCheck[SkillPrecondCheck.PreConditionType.Map]
  if preConditions then
    local preCondition
    local mapid = Game.MapManager:GetMapID()
    local serverid = MyselfProxy.Instance:GetServerId()
    for k, v in pairs(preConditions) do
      local needChecks = v:GetPrecondtionsByType(SkillPrecondCheck.PreConditionType.Map)
      if needChecks then
        local preCondition
        for i = 1, #needChecks do
          preCondition = needChecks[i]
          if preCondition.id == mapid then
            if not preCondition.serverid or preCondition.serverid and TableUtility.ArrayFindIndex(preCondition.serverid, serverid) > 0 then
              self:UpdateReason(v, true, v.skillItemData, preCondition)
            else
              self:UpdateReason(v, false, v.skillItemData, preCondition)
            end
          else
            self:UpdateReason(v, false, v.skillItemData, preCondition)
          end
        end
      end
    end
  end
end

function FunctionSkillEnableCheck:MyBulletsCheck(conditionCheck)
  if self.myself then
    local needChecks = conditionCheck:GetPrecondtionsByType(SkillPrecondCheck.PreConditionType.Bullets)
    local mydata = Game.Myself.data
    if needChecks then
      local preCondition
      local skill = conditionCheck.skillItemData
      local skipCheck = false
      local dynamicSkillInfo = mydata:GetDynamicSkillInfo(skill:GetID())
      if dynamicSkillInfo ~= nil then
        skipCheck = dynamicSkillInfo:GetClientIsNoItem()
      end
      for i = 1, #needChecks do
        preCondition = needChecks[i]
        if skipCheck then
          self:UpdateReason(conditionCheck, true, skill, preCondition)
        elseif (MyselfProxy.Instance:GetCurBullets() or 0) >= preCondition.num then
          self:UpdateReason(conditionCheck, true, skill, preCondition)
        else
          self:UpdateReason(conditionCheck, false, skill, preCondition)
        end
      end
    end
  end
end

function FunctionSkillEnableCheck:BulletsUpdateCheck()
  local preConditions = self.skillsTypeCheck[SkillPrecondCheck.PreConditionType.Bullets]
  if preConditions then
    for k, v in pairs(preConditions) do
      self:MyBulletsCheck(v)
    end
  end
end

function FunctionSkillEnableCheck:ResetConditionCache()
  self.skillsTypeCheck = {
    whole = {}
  }
  self.skillsCondition = {}
end

function FunctionSkillEnableCheck:DressPartMountCheck(conditionCheck)
  local skill = conditionCheck.skillItemData
  local myselfData = Game.Myself.data
  local needChecks = conditionCheck:GetPrecondtionsByType(SkillPrecondCheck.PreConditionType.DressPartMount)
  if needChecks then
    for _, preCondition in ipairs(needChecks) do
      if preCondition then
        local feature = preCondition.equipFeature
        if feature ~= nil then
          if myselfData:IsDressPartOfFeature(Asset_Role.PartIndex.Mount, feature) then
            self:UpdateReason(conditionCheck, true, skill, preCondition)
          else
            self:UpdateReason(conditionCheck, false, skill, preCondition)
          end
        end
      end
    end
  end
end

function FunctionSkillEnableCheck:DresspartMountUpdateCheck()
  local checks = self.skillsTypeCheck[SkillPrecondCheck.PreConditionType.DressPartMount]
  if checks then
    for _, v in pairs(checks) do
      self:DressPartMountCheck(v)
    end
  end
end

function FunctionSkillEnableCheck:TargetHpLessThanCheck(conditionCheck)
  if self.myself then
    local skill = conditionCheck.skillItemData
    local needChecks = conditionCheck:GetPrecondtionsByType(SkillPrecondCheck.PreConditionType.TargetHpLessThan)
    if needChecks then
      local preCondition
      local checkPercent, percent = 0, 0
      local targetCreature = self.myself:GetLockTarget()
      for i = 1, #needChecks do
        preCondition = needChecks[i]
        if not targetCreature then
          self:UpdateReason(conditionCheck, false, skill, preCondition)
          return
        else
          local skillinfo = Game.LogicManager_Skill:GetSkillInfo(skill:GetID())
          if not skillinfo:CheckTarget(self.myself, targetCreature) then
            self:UpdateReason(conditionCheck, false, skill, preCondition)
            return
          end
        end
        if preCondition.hpvalue then
          checkPercent = preCondition.hpvalue
          percent = targetCreature.data.props:GetPropByName("Hp"):GetValue() / targetCreature.data.props:GetPropByName("MaxHp"):GetValue() * 100
        end
        if checkPercent >= percent then
          self:UpdateReason(conditionCheck, true, skill, preCondition)
        else
          self:UpdateReason(conditionCheck, false, skill, preCondition)
        end
      end
    end
  end
end

function FunctionSkillEnableCheck:TargetHpUpdateCheck()
  local preConditions = self.skillsTypeCheck[SkillPrecondCheck.PreConditionType.TargetHpLessThan]
  if preConditions then
    for k, v in pairs(preConditions) do
      self:TargetHpLessThanCheck(v)
    end
  end
end

function FunctionSkillEnableCheck:InterferenceValueCheck(conditionCheck)
  if self.myself then
    local skill = conditionCheck.skillItemData
    local needChecks = conditionCheck:GetPrecondtionsByType(SkillPrecondCheck.PreConditionType.InterferenceValue)
    if needChecks then
      local preCondition
      local checkValue = 0
      local myValue = MyselfProxy.Instance:GetMyInterferenceValue()
      for i = 1, #needChecks do
        preCondition = needChecks[i]
        if preCondition.value then
          checkValue = preCondition.value
        end
        if myValue > checkValue then
          self:UpdateReason(conditionCheck, true, skill, preCondition)
        else
          self:UpdateReason(conditionCheck, false, skill, preCondition)
        end
      end
    end
  end
end

function FunctionSkillEnableCheck:InterferenceValueUpdateCheck()
  local preConditions = self.skillsTypeCheck[SkillPrecondCheck.PreConditionType.InterferenceValue]
  if preConditions then
    for k, v in pairs(preConditions) do
      self:InterferenceValueCheck(v)
    end
  end
end

function FunctionSkillEnableCheck:IsRideOnTeammateCheck(conditionCheck)
  if self.myself then
    local skill = conditionCheck.skillItemData
    local targetCreature = self.myself:GetLockTarget()
    local needChecks = conditionCheck:GetPrecondtionsByType(SkillPrecondCheck.PreConditionType.IsRideOnTeammate)
    if needChecks then
      local preCondition
      local checkValue = 0
      local myValue = Game.Myself.data:GetDownID()
      local myyUpValue = Game.Myself.data:GetUpID()
      for i = 1, #needChecks do
        preCondition = needChecks[i]
        if preCondition.value then
          checkValue = preCondition.value
        end
        local isPippi = targetCreature and targetCreature.data and targetCreature.data:IsPippi()
        local IsMyPet = false
        if isPippi then
          IsMyPet = targetCreature.data.ownerID == self.myself.data.id
        end
        local skillinfo = Game.LogicManager_Skill:GetSkillInfo(skill:GetID())
        local skillTargetType = skillinfo:GetTargetType(self.myself)
        local targetValid = true
        if targetCreature and targetCreature.data then
          targetValid = skillinfo:CheckTarget(self.myself, targetCreature)
        end
        if checkValue == 0 then
          self:UpdateReason(conditionCheck, not Game.Myself.data:IsInRide(), skill, preCondition)
        elseif checkValue == 1 then
          if myValue ~= 0 then
            if skillTargetType ~= SkillTargetType.None then
              if targetCreature and myValue ~= targetCreature.data.id and (TeamProxy.Instance:IsInMyTeam(targetCreature.data.id) or IsMyPet and isPippi) then
                self:UpdateReason(conditionCheck, true, skill, preCondition)
              else
                self:UpdateReason(conditionCheck, false, skill, preCondition)
              end
            else
              self:UpdateReason(conditionCheck, true, skill, preCondition)
            end
          else
            self:UpdateReason(conditionCheck, false, skill, preCondition)
          end
        elseif checkValue == 2 then
          if not targetCreature or not targetCreature.data then
            self:UpdateReason(conditionCheck, false, skill, preCondition)
          else
            self:UpdateReason(conditionCheck, targetCreature.data:IsPlayer() and self.myself.data:IsEnemy(targetCreature.data), skill, preCondition)
          end
        end
      end
    end
  end
end

function FunctionSkillEnableCheck:RidePlayerCheck()
  local preConditions = self.skillsTypeCheck[SkillPrecondCheck.PreConditionType.IsRideOnTeammate]
  if preConditions then
    for k, v in pairs(preConditions) do
      self:IsRideOnTeammateCheck(v)
    end
  end
end

function FunctionSkillEnableCheck:TargetUpdateCheck()
  self:TargetHpUpdateCheck()
  self:RidePlayerCheck()
end

function FunctionSkillEnableCheck:EquipCheck()
  local preConditions = self.skillsTypeCheck[SkillPrecondCheck.PreConditionType.WearEquip]
  if preConditions then
    for k, v in pairs(preConditions) do
      self:WearEquipCheck(v)
    end
  end
end
