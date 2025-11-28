SkillDynamicManager = class("SkillDynamicManager")
local Config = {
  LP_EmitEffect = 1,
  Icon = 2,
  AttackEffect = 3,
  CastEffect = 4,
  HitEffect = 5,
  LP_TrapEffect = 6,
  LP_Effect = 7,
  E_fire = 8
}
SkillDynamicManager.Config = Config
local EffectHandler = function(value)
  local paths = StringUtil.Split(value, ",")
  paths = Game.PreprocessEffectPaths(paths, "Skill/")
  return paths
end
local ConfigHandler = {
  [Config.LP_EmitEffect] = EffectHandler,
  [Config.AttackEffect] = EffectHandler,
  [Config.CastEffect] = EffectHandler,
  [Config.HitEffect] = EffectHandler,
  [Config.LP_TrapEffect] = EffectHandler,
  [Config.LP_Effect] = EffectHandler,
  [Config.E_fire] = EffectHandler
}
local Camps = {
  Friend = RoleDefines_Camp.FRIEND
}
local Props = {HP = 1}
SkillDynamicManager.Props = Props
local CampsMap = {}
local PropsMap = {}
local HPHandler = function(creature)
  local ui = creature:GetSceneUI()
  if ui then
    ui.roleBottomUI:SetHp(creature)
  end
end
local PropsHandler = {
  [Props.HP] = HPHandler
}
local UpdateDisplayProps = function(creature)
  if CampsMap[creature.data:GetCamp()] == nil then
    return
  end
  local handler
  for k, v in pairs(PropsMap) do
    handler = PropsHandler[k]
    if handler ~= nil then
      handler(creature)
    end
  end
end

function SkillDynamicManager:ctor()
  self.config = {}
  self.buffs = {}
  self.props = {}
end

function SkillDynamicManager:AddDynamicConfig(charid, skillSortID, type, value)
  local creatureConfig = self.config[charid]
  if creatureConfig == nil then
    creatureConfig = {}
    self.config[charid] = creatureConfig
  end
  local config = creatureConfig[skillSortID]
  if config == nil then
    config = {}
    creatureConfig[skillSortID] = config
  end
  local handler = ConfigHandler[type]
  if handler ~= nil then
    config[type] = handler(value)
  else
    config[type] = value
  end
end

function SkillDynamicManager:RemoveDynamicConfig(charid, skillSortID, type)
  local creatureConfig = self.config[charid]
  if creatureConfig == nil then
    return
  end
  if skillSortID == nil then
    return
  end
  local config = creatureConfig[skillSortID]
  if config == nil then
    return
  end
  config[type] = nil
end

function SkillDynamicManager:GetDynamicConfig(charid, skillid, type)
  local creatureConfig = self.config[charid]
  if creatureConfig == nil then
    return nil
  end
  local skillSortID = math.floor(skillid / 1000)
  local config = creatureConfig[skillSortID]
  if config == nil then
    return nil
  end
  return config[type]
end

function SkillDynamicManager:AddDynamicBuff(charid, buffid, buffStateID)
  local creatureConfig = self.buffs[charid]
  if creatureConfig == nil then
    creatureConfig = {}
    self.buffs[charid] = creatureConfig
  end
  creatureConfig[buffid] = buffStateID
end

function SkillDynamicManager:RemoveDynamicBuff(charid, buffid)
  local creatureConfig = self.buffs[charid]
  if creatureConfig == nil then
    return
  end
  if buffid == nil then
    return
  end
  creatureConfig[buffid] = nil
end

function SkillDynamicManager:GetDynamicBuff(charid, buffid)
  local creatureConfig = self.buffs[charid]
  if creatureConfig == nil then
    return nil
  end
  return creatureConfig[buffid]
end

function SkillDynamicManager:Clear(charid)
  self.config[charid] = nil
  self.buffs[charid] = nil
end

function SkillDynamicManager:AddDynamicEffect(charid, id)
  local data = Table_SkillDynamicEffect[id]
  if data == nil then
    return
  end
  if data.SkillID ~= nil then
    local skillEffect = data.SkillEffect
    for i = 1, #skillEffect do
      self:AddDynamicConfig(charid, data.SkillID, skillEffect[i].type, skillEffect[i].effect)
    end
  end
  if data.BuffID ~= nil then
    self:AddDynamicBuff(charid, data.BuffID, data.BuffStateID)
  end
end

function SkillDynamicManager:RemoveDynamicEffect(charid, id)
  local data = Table_SkillDynamicEffect[id]
  if data == nil then
    return
  end
  if data.SkillID ~= nil then
    local skillEffect = data.SkillEffect
    for i = 1, #skillEffect do
      self:RemoveDynamicConfig(charid, data.SkillID, skillEffect[i].type)
    end
  end
  if data.BuffID ~= nil then
    self:RemoveDynamicBuff(charid, data.BuffID)
  end
end

function SkillDynamicManager:AddDynamicProps(config)
  local camps = config.Camps
  if camps == nil then
    return
  end
  local props = self.props
  local _TableClear = TableUtility.TableClear
  _TableClear(CampsMap)
  _TableClear(PropsMap)
  local camp, prop
  for i = 1, #camps do
    camp = Camps[camps[i]]
    if camp ~= nil then
      if props[camp] == nil then
        props[camp] = {}
        self.props = props
      end
      for k, v in pairs(Props) do
        prop = config[k]
        if prop ~= nil then
          props[camp][v] = prop
          PropsMap[v] = prop
        end
      end
      CampsMap[camp] = 1
    end
  end
  self:UpdateDynamicProps()
end

function SkillDynamicManager:RemoveDynamicProps(config)
  local camps = config.Camps
  if camps == nil then
    return
  end
  local props = self.props
  local _TableClear = TableUtility.TableClear
  _TableClear(CampsMap)
  _TableClear(PropsMap)
  local camp, prop
  for i = 1, #camps do
    camp = Camps[camps[i]]
    if camp ~= nil and props[camp] ~= nil then
      for k, v in pairs(Props) do
        prop = config[k]
        if prop ~= nil then
          props[camp][v] = nil
          PropsMap[v] = prop
        end
      end
      CampsMap[camp] = 1
    end
  end
  self:UpdateDynamicProps()
end

function SkillDynamicManager:UpdateDynamicProps()
  GameFacade.Instance:sendNotification(SkillEvent.DynamicProps)
  UpdateDisplayProps(Game.Myself)
  NSceneUserProxy.Instance:ForEach(UpdateDisplayProps)
end

function SkillDynamicManager:GetDynamicProps(camp, prop)
  if camp == nil then
    return
  end
  local data = self.props[camp]
  if data == nil then
    return
  end
  return data[prop]
end
