autoImport("SceneObjectProxy")
SceneCreatureProxy = class("SceneCreatureProxy", SceneObjectProxy)
SceneCreatureProxy.Instance = nil
SceneCreatureProxy.NAME = "SceneCreatureProxy"
SceneCreatureProxy.FADE_IN_OUT_DURATION = 1
SceneCreatureProxy.SampleInterval = 0
local IsNpc = function(guid)
  return guid >> 32 == 0 or guid >> 32 >= 1000
end

function SceneCreatureProxy:ctor(proxyName, data)
  self.proxyName = proxyName or SceneCreatureProxy.NAME
  self:CountClear()
  self.userMap = {}
  self.addMode = SceneObjectProxy.AddMode.Normal
  if SceneCreatureProxy.Instance == nil then
    SceneCreatureProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
end

function SceneCreatureProxy.FindCreature(guid)
  if not guid then
    redlog("找NPC找了个寂寞")
    return
  end
  if Game.IsLocalEditorGame and guid == 0 or not IsNpc(guid) then
    return NSceneUserProxy.Instance:Find(guid)
  end
  local target = NSceneNpcProxy.Instance:Find(guid)
  if target == nil then
    target = NScenePetProxy.Instance:Find(guid)
    if target == nil then
      target = SceneAINpcProxy.Instance:Find(guid)
    end
  end
  return target
end

function SceneCreatureProxy.FindOtherCreature(guid)
  local myself = Game.Myself
  if myself and myself.data and guid == myself.data.id then
    return nil
  end
  local target = NSceneUserProxy.Instance:Find(guid)
  if target == nil then
    target = NSceneNpcProxy.Instance:Find(guid)
    if target == nil then
      target = NScenePetProxy.Instance:Find(guid)
    end
  end
  return target
end

function SceneCreatureProxy.ResetPos(guid, pos, isgomap)
  if guid == 0 then
    guid = Game.Myself.data.id
  end
  if SceneCarrierProxy.Instance:CreatureIsInCarrier(guid) then
    errorLog(string.format("玩家%s已在载具中，服务器通知重设位置", guid))
  elseif guid == Game.Myself.data.id then
    MyselfProxy.Instance:ResetMyPos(pos.x, pos.y, pos.z, isgomap)
  else
    local creature = SceneCreatureProxy.FindCreature(guid)
    if creature and (not Game.MapManager:IsHomeMap(Game.MapManager:GetMapID()) or creature.ai.idleAI_Patrol == nil) then
      creature:Server_SetPosXYZCmd(pos.x, pos.y, pos.z, 1000, isgomap)
      MyselfProxy.Instance:UpdateObPosition(guid, pos.x, pos.y, pos.z, 1000)
    end
  end
end

function SceneCreatureProxy.ForEachCreature(func, args)
  if NSceneUserProxy.Instance:ForEach(func, args) then
    return
  end
  if NSceneNpcProxy.Instance:ForEach(func, args) then
    return
  end
  if nil ~= Game.Myself then
    func(Game.Myself, args)
  end
  local boki = BokiProxy.Instance:GetSceneBoki()
  if boki ~= nil then
    func(boki, args)
  end
  local p_creature = NScenePetProxy.Instance:GetMyPipipiCreature()
  if p_creature then
    func(p_creature, args)
  end
  local pippiMap = NScenePetProxy.Instance.pippiMap
  if pippiMap then
    local pCreature
    for _, petguid in pairs(pippiMap) do
      pCreature = SceneCreatureProxy.FindCreature(petguid)
      if pCreature then
        func(pCreature, args)
      end
    end
  end
end

local phasedata

function SceneCreatureProxy.ParsePhaseData(serverSkillBroadCastData)
  if phasedata == nil then
    phasedata = SkillPhaseData.Create(serverSkillBroadCastData.skillID)
  else
    phasedata:Reset(serverSkillBroadCastData.skillID)
  end
  phasedata:ParseFromServer(serverSkillBroadCastData)
end

local CheckCastEffect = GameConfig.CheckCastEffect

function SceneCreatureProxy.HitTargetByPhaseData(data)
  if not phasedata:IsClientUse() and phasedata:BuffSkillEffect() then
    SkillLogic_Base.ShowBuffSkillEffect(phasedata, data.charid)
    return
  end
  if SkillPhase.Attack ~= phasedata:GetSkillPhase() then
    return
  end
  local creature = SceneCreatureProxy.FindCreature(data.charid)
  if phasedata:GetTargetCount() <= 0 then
    if creature and creature.skill and CheckCastEffect then
      local sortSkillID = (creature.skill:GetSkillID() or 0) // 1000
      if creature.skill:IsCastingSkill() and phasedata:GetSkillID() // 1000 == CheckCastEffect[sortSkillID] then
        local skillInfo = Game.LogicManager_Skill:GetSkillInfo(phasedata:GetSkillID())
        SkillLogic_Base.PassiveFire(creature, phasedata, skillInfo, true)
      end
    end
    return
  end
  if not phasedata:GetForceServerDamage() and SceneCreatureProxy.FindCreature(data.charid) ~= nil then
    return
  end
  SkillLogic_Base.HitTargetByPhaseData(phasedata, data.charid)
end

local listTarget = {}
local _SqrDistance = LuaVector3.Distance_Square
local searchIndex = 0

function SceneCreatureProxy.SortTargetCreature(position, distance, research)
  if research then
    searchIndex = 0
    TableUtility.TableClear(listTarget)
    local listUser = NSceneUserProxy.Instance:FindNearUsers(position, distance, function(creature)
      if not creature:IsDead() and creature:GetClickable() and creature.data:GetCamp() == RoleDefines_Camp.ENEMY then
        return true
      end
    end)
    TableUtil.InsertArray(listTarget, listUser)
    local listMonster = NSceneNpcProxy.Instance:FindNearNpcs(position, distance, function(creature)
      if not creature:IsDead() and creature:GetClickable() and creature.data:IsMonster() and creature.data:GetCamp() == RoleDefines_Camp.ENEMY then
        return true
      end
    end)
    TableUtil.InsertArray(listTarget, listMonster)
    local listPet = NScenePetProxy.Instance:FindNearPets(position, distance, function(creature)
      if not creature:IsDead() and creature:GetClickable() and (creature.data:IsMonster() or creature.data:IsPippi() or creature.data:IsPhantom()) and creature.data:GetCamp() == RoleDefines_Camp.ENEMY then
        return true
      end
    end)
    TableUtil.InsertArray(listTarget, listPet)
    local listPippi = NScenePetProxy.Instance:FindNearPippi(position, distance, function(creature)
      if not creature:IsDead() and creature:GetClickable() and creature.data:IsPippi() and creature.data:GetCamp() == RoleDefines_Camp.ENEMY then
        return true
      end
    end)
    TableUtil.InsertArray(listTarget, listPippi)
    table.sort(listTarget, function(a, b)
      if a:GetCreatureType() == b:GetCreatureType() then
        return _SqrDistance(a:GetPosition(), position) < _SqrDistance(b:GetPosition(), position)
      elseif a:GetCreatureType() ~= b:GetCreatureType() and _SqrDistance(a:GetPosition(), b:GetPosition()) < AutoBattle.DistanceOffset then
        return a:GetCreatureType() < b:GetCreatureType()
      end
    end)
  end
  searchIndex = searchIndex == #listTarget and 1 or searchIndex + 1
  return listTarget[searchIndex]
end

function SceneCreatureProxy:Add(data)
  return nil
end

function SceneCreatureProxy:SetProps(guid, attrs, update)
  local creature = self:Find(guid)
  if creature ~= nil then
    creature:SetProps(attrs, update)
  end
end

function SceneCreatureProxy:PureAddSome(datas)
  local roles = {}
  for i = 1, #datas do
    if datas[i] ~= nil then
      local role = self:Add(datas[i])
      if role ~= nil then
        roles[#roles + 1] = role
      end
    end
  end
  return roles
end

function SceneCreatureProxy:SyncServerSkill(data)
  if SkillPhase.Hit == phasedata:GetSkillPhase() then
    local skillInfo = Game.LogicManager_Skill:GetSkillInfo(phasedata:GetSkillID())
    SkillLogic_Base.HitTargetByPhaseData(phasedata, data.charid, skillInfo:FireAttackEffect())
    if not phasedata:IsClientUse() and phasedata:BuffSkillEffect() then
      SkillLogic_Base.ShowBuffSkillEffect(phasedata, data.charid)
    end
    return true
  else
    local role = self:Find(data.charid)
    if nil ~= role then
      if Game.Myself ~= role then
        role:Server_SyncSkill(phasedata)
        if phasedata:GetForceServerDamage() then
          SkillLogic_Base.HitTargetByPhaseData(phasedata, data.charid)
        end
        return true
      else
        role.skill:SyncDirMoveFromServer(role, phasedata)
        local phase = phasedata:GetSkillPhase()
        local skillid = data.skillID
        if SkillPhase.LeadComplete == phase then
          if not phasedata:IsSkipBreak() then
            role:Server_BreakSkill(skillid)
          end
        elseif SkillPhase.Cast == phase then
          role:Server_SyncShiftPoint(skillid, data.data and data.data.pos)
        elseif SkillPhase.None == phase then
          local oldPhase = role.skill.phaseData:GetSkillPhase(phase)
          if oldPhase == SkillPhase.Cast and role.skill.info:CanClientInterrupt() then
            role:Server_BreakSkill(skillid)
          end
        end
      end
    end
  end
  return false
end

function SceneCreatureProxy:NotifyUseSkill(data)
  local creature = self:Find(data.charid)
  if nil ~= creature and creature == Game.Myself and nil ~= data.petid and data.petid < 0 then
    if SkillPhase.None == data.data.number then
      creature:Server_BreakSkill(data.skillID)
      return true
    end
    local phaseDataCustom = data.data
    local targetID, targetCreature, targetPosition
    if phaseDataCustom.hitedTargets and 0 < #phaseDataCustom.hitedTargets then
      targetID = phaseDataCustom.hitedTargets[1].charid
      targetCreature = SceneCreatureProxy.FindCreature(targetID)
    else
      targetPosition = ProtolUtility.S2C_Vector3(phaseDataCustom.pos)
    end
    creature:Server_UseSkill(data.skillID, targetCreature, targetPosition)
    if targetPosition then
      targetPosition:Destroy()
    end
    return true
  end
  return false
end

function SceneCreatureProxy:SyncServerPetSkill(data)
  local role = self:Find(data.charid)
  if nil ~= role and nil ~= role.partner then
    role.partner:Server_SyncSkill(phasedata)
    return true
  end
  return false
end

function SceneCreatureProxy:Die(guid, creature)
  local role = creature
  if nil == creature then
    role = self:Find(guid)
  end
  if role ~= nil then
    if Creature_Type.Me == role.creatureType then
      role.roleAgent:Die()
    else
      RoleControllerInterface.ServerDie(role.roleAgent)
    end
  end
  return role
end

function SceneCreatureProxy:DieWithoutAction(guid, creature)
  local role = creature
  if nil == creature then
    role = self:Find(guid)
  end
  if role ~= nil then
    if Creature_Type.Me == role.creatureType then
      role.roleAgent:DieWithoutAction()
    else
      RoleControllerInterface.ServerDieWithoutAction(role.roleAgent)
    end
  end
  return role
end

function SceneCreatureProxy:reLive(guid)
  local role = self:Find(guid)
  if role ~= nil then
    if Creature_Type.Me == role.creatureType then
      role.roleAgent:Revive()
    else
      RoleControllerInterface.ServerRevive(role.roleAgent)
    end
  end
end

function SceneCreatureProxy:Remove(guid, fade)
  local targetguid = MyselfProxy.Instance:GetTargetAndPos()
  if targetguid and targetguid == guid then
    return
  end
  local creature = self.userMap[guid]
  if creature ~= nil then
    self.userMap[guid] = nil
    creature:Destroy()
    self:CountMinus()
    EventManager.Me():DispatchEvent(SceneCreatureEvent.CreatureRemove, guid)
    return true
  end
  return false
end

function SceneCreatureProxy:Clear()
  self.removeSomes = self.removeSomes and self.removeSomes or {}
  TableUtility.ArrayClear(self.removeSomes)
  self:ChangeAddMode(SceneCreatureProxy.AddMode.Normal)
  for id, o in pairs(self.userMap) do
    EventManager.Me():DispatchEvent(SceneCreatureEvent.CreatureRemove, id)
    self.removeSomes[#self.removeSomes + 1] = id
    self.userMap[id] = nil
    o:Destroy()
  end
  return self.removeSomes
end

function SceneCreatureProxy:CountPlus(num)
  num = num and num or 1
  self.currentCount = self.currentCount + num
  self:OnCountChanged()
end

function SceneCreatureProxy:CountMinus(num)
  num = num and num or 1
  self.currentCount = math.max(0, self.currentCount - num)
  self:OnCountChanged()
end

function SceneCreatureProxy:CountClear()
  self.currentCount = 0
  self:OnCountChanged()
end

function SceneCreatureProxy:GetCount()
  return self.currentCount
end

function SceneCreatureProxy:OnCountChanged()
end

function SceneCreatureProxy:ForEach(func, args)
  if nil ~= self.userMap then
    for k, v in pairs(self.userMap) do
      if func(v, args) then
        return true
      end
    end
  end
  return false
end
