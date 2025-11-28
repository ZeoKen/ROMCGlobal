autoImport("NPartner")
SkillComboHitWorker = class("SkillComboHitWorker", ReusableObject)
if not SkillComboHitWorker.SkillComboHitWorker_Inited then
  SkillComboHitWorker.SkillComboHitWorker_Inited = true
  SkillComboHitWorker.PoolSize = 200
end
local DamageType = CommonFun.DamageType
local _FindCreature = SceneCreatureProxy.FindCreature
local FindCreature = function(guid)
  local c = _FindCreature(guid)
  if c then
    return c
  end
  if NPartnerMap[guid] then
    return NPartnerMap[guid]
  end
end
local ComboInterval = 0.2
local tempComboHitArgs = {
  [1] = nil,
  [2] = DamageType.None,
  [3] = 0,
  [4] = 0,
  [5] = 0,
  [6] = false,
  [7] = nil,
  [8] = HurtNumType.DamageNum,
  [9] = HurtNumColorType.Normal,
  [10] = nil,
  [11] = nil,
  [12] = true,
  [13] = nil,
  [14] = true,
  [15] = nil,
  [16] = nil,
  [17] = nil,
  [18] = nil,
  [19] = nil,
  [20] = nil,
  [21] = nil,
  [25] = nil
}

function SkillComboHitWorker.GetArgs()
  return tempComboHitArgs
end

function SkillComboHitWorker.ClearArgs(args)
  args[1] = nil
  args[10] = nil
  args[11] = nil
  args[12] = true
  args[13] = nil
  args[14] = true
end

function SkillComboHitWorker.Create(args)
  return ReusableObject.Create(SkillComboHitWorker, true, args)
end

function SkillComboHitWorker:ctor()
  self.args = {}
  local args = self.args
  args[17] = LuaVector3.Zero()
  args[20] = LuaVector3.Zero()
  args[25] = LuaVector3.Zero()
end

function SkillComboHitWorker:Update(time, deltaTime)
  local args = self.args
  if time < args[15] then
    return
  end
  args[15] = time + ComboInterval
  local targetCreature = FindCreature(args[1])
  if nil ~= targetCreature then
    if not args[6] then
      targetCreature:Logic_Hit()
    end
    if self.args[12] then
      if args[19] ~= nil then
        local effect = Asset_Effect.PlayOneShotAt(args[19], args[20], nil, nil, nil, args[21], args[22], args[23])
        effect:ResetLocalEulerAnglesXYZ(0, args[24], 0)
      end
      if args[7] == nil and args[16] then
        args[7] = args[13]:GetHitSEPath(targetCreature, nil, nil, args[16])
      end
      if args[7] ~= nil then
        local creature = FindCreature(args[11])
        targetCreature.assetRole:PlaySEOneShotOn(args[7], nil, creature == Game.Myself)
        if args[16] then
          args[7] = nil
        end
      end
    end
  end
  if nil ~= args[10] then
    local damage = SkillLogic_Base.GetSplitDamage(args[3], args[14], args[4])
    local creature = FindCreature(args[11])
    if not Game.MapManager:IsInAllGVG() then
      SkillLogic_Base.ShowDamage_Single(args[2], damage, args[25], args[8], args[9], targetCreature, args[13], creature)
    end
    self.args[10]:Show(damage, args[17], creature == Game.Myself, self.args[18], targetCreature == Game.Myself)
  end
  if args[14] >= args[4] then
    self:Destroy()
  else
    self.args[14] = self.args[14] + 1
  end
end

function SkillComboHitWorker:DoConstruct(asArray, args)
  local creature = args[11]
  local targetCreature = args[1]
  targetCreature.ai:SetDieBlocker(self)
  TableUtility.ArrayShallowCopyWithCount(self.args, args, 13)
  self.args[1] = targetCreature.data.id
  self.args[11] = creature and creature.data.id or 0
  if args[14] then
    if nil == self.args[10] then
      self.args[18] = HurtNum_CritType.None
      if DamageType.Crit == args[2] then
        if args[13] ~= nil and args[13]:ShowMagicCrit(targetCreature) then
          self.args[18] = HurtNum_CritType.MAtk
        else
          self.args[18] = HurtNum_CritType.PAtk
        end
      end
      self.args[10] = SceneUIManager.Instance:GetStaticHurtLabelWorker()
    end
    self.args[10]:AddRef()
  else
    self.args[10] = nil
  end
  self.args[14] = 1
  self.args[15] = 0
  self.args[16] = args[15]
  local targetAssetRole = targetCreature.assetRole
  LuaVector3.Better_Set(self.args[25], targetAssetRole:GetEPOrRootPosition(args[5]))
  local posx, posy, posz = targetAssetRole:GetEPOrRootPosition(RoleDefines_EP.Top)
  LuaVector3.Better_Set(self.args[17], posx, posy + math.random(0, 20) / 100, posz)
  self.args[19] = args[16]
  if args[17] ~= nil then
    LuaVector3.Better_SetPos(self.args[20], args[17])
  end
  self.args[21] = args[18]
  self.args[22] = args[19]
  self.args[23] = args[20]
  self.args[24] = args[21]
end

function SkillComboHitWorker:DoDeconstruct(asArray)
  local args = self.args
  local targetCreature = FindCreature(args[1])
  if nil ~= targetCreature then
    targetCreature.ai:ClearDieBlocker(self)
  end
  if nil ~= args[10] then
    args[10]:SubRef()
  end
  args[10] = nil
  args[13] = nil
  args[18] = nil
end
