SceneFilterProxy = class("SceneFilterProxy", pm.Proxy)
SceneFilterProxy.NAME = "SceneFilterProxy"
SceneFilterProxy.Instance = nil

function SceneFilterProxy:ctor(proxyName, data)
  self.proxyName = proxyName or SceneFilterProxy.NAME
  if SceneFilterProxy.Instance == nil then
    SceneFilterProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self.idMap = {}
  self.inVisibleLayer = RO.Config.Layer.INVISIBLE.Value
  self.handlerMap = {}
  self.handlerMap[SceneFilterDefine.Content.BloodBar] = self.BloodBarHandler
  self.handlerMap[SceneFilterDefine.Content.UINameTitleGuild] = self.NameTitleHandler
  self.handlerMap[SceneFilterDefine.Content.UIChatSkill] = self.ChatSkillHandler
  self.handlerMap[SceneFilterDefine.Content.Emoji] = self.EmojiHandler
  self.handlerMap[SceneFilterDefine.Content.TopFrame] = self.TopFrameHandler
  self.handlerMap[SceneFilterDefine.Content.Model] = self.ModelHandler
  self.handlerMap[SceneFilterDefine.Content.QuestUI] = self.QuestUIHandler
  self.handlerMap[SceneFilterDefine.Content.HurtNum] = self.HurtNumHandler
  self.handlerMap[SceneFilterDefine.Content.FloatRoleTop] = self.FloatRoleTopHandler
  self.handlerMap[SceneFilterDefine.Content.PetPartner] = self.PetPartnerHandler
  self.handlerMap[SceneFilterDefine.Content.PeakEffect] = self.PeakEffectHandler
  self.handlerMap[SceneFilterDefine.Content.Seat] = self.SeatHandler
  self.handlerMap[SceneFilterDefine.Content.GiftSymbol] = self.GiftSymbolHandler
  self.handlerMap[SceneFilterDefine.Content.SkillEffect] = self.SkillEffectHandler
  self.handlerMap[SceneFilterDefine.Content.LuaGameObject] = self.LuaGameObjectHandler
  self.handlerMap[SceneFilterDefine.Content.HireCat] = self.HireCatHandler
  self.handlerMap[SceneFilterDefine.Content.ModelWing] = self.ModelWingHandler
  self.handlerMap[SceneFilterDefine.Content.ModelTail] = self.ModelTailHandler
  self.handlerMap[SceneFilterDefine.Content.ExitPoint] = self.ExitPointHandler
  self.handlerMap[SceneFilterDefine.Content.QuestLightEffect] = self.QuestLightEffectHandler
  self.classifyFindHandlerMap = {}
  self.classifyFindHandlerMap[SceneFilterDefine.Classify.Character] = self.CreatureClassifyFindHandler
  self.classifyFindHandlerMap[SceneFilterDefine.Classify.LuaGO] = self.LuaGameObjectClassifyFindHandler
  self:InitConfigs()
  self.forceMaskChat = false
end

function SceneFilterProxy:InitConfigs()
  self.groupConfig = {}
  for k, v in pairs(Table_ScreenFilter) do
    local group = self.groupConfig[v.Group]
    if not group then
      group = {}
      self.groupConfig[v.Group] = group
    end
    group[v.id] = v
  end
end

function SceneFilterProxy:Clear()
  self.idMap = {}
end

function SceneFilterProxy:GetMap(id)
  local map = self.idMap[id]
  if not map then
    map = {}
    self.idMap[id] = map
  end
  return map
end

function SceneFilterProxy:RemoveCreature(id)
  for k, map in pairs(self.idMap) do
    map[id] = nil
  end
end

function SceneFilterProxy:RemoveNpc(id)
  local npc = NSceneNpcProxy.Instance:GetClientNpcByGUID(id)
  if npc ~= nil then
    return
  end
  self:RemoveCreature(id)
end

function SceneFilterProxy:SceneFilterProcessCheckById(id, counterwise)
  local map = self:GetMap(id)
  local conf = Table_ScreenFilter[id]
  local creature
  local classify = #conf.Classifys > 0 and conf.Classifys[1] or SceneFilterDefine.Classify.Character
  local targetFindHandler = self.classifyFindHandlerMap[classify]
  for k, v in pairs(map) do
    creature = targetFindHandler(self, k)
    if creature then
      self:SceneFilterUnCheck(id, creature, conf, map, counterwise)
    else
      map[k] = nil
    end
  end
end

function SceneFilterProxy:GetTargetID(target)
  if not target then
    return
  end
  if target.type and target.ID then
    return target.type * 100000000 + target.ID
  end
  if target.data and target.data.id then
    return target.data.id
  end
end

function SceneFilterProxy:CreatureClassifyFindHandler(targetID)
  return SceneCreatureProxy.FindCreature(targetID)
end

function SceneFilterProxy:LuaGameObjectClassifyFindHandler(targetID)
  local type = math.floor(targetID / 100000000)
  local ID = targetID - type * 100000000
  local luagoMgr = Game.GameObjectManagers[type]
  if luagoMgr and luagoMgr.FindLuaGO then
    return luagoMgr:FindLuaGO(ID)
  end
end

function SceneFilterProxy:SceneFilterCheck(id, creature, counterwise)
  if not creature then
    return
  end
  local tid = self:GetTargetID(creature)
  if not tid then
    redlog("SceneFilterProxy:SceneFilterCheck", "fail to get target id", id, creature)
    return
  end
  local c, rid = true, id
  if counterwise then
    c = false
    rid = FunctionSceneFilter.Me().applyDefaultSceneFilterId or id
  end
  local conf = Table_ScreenFilter[id]
  if conf then
    local map = self:GetMap(id)
    map[tid] = tid
    for i = 1, #conf.Content do
      self.handlerMap[conf.Content[i]](self, creature, rid, c)
    end
  end
end

function SceneFilterProxy:SceneFilterUnCheck(id, creature, conf, map, counterwise)
  if not creature then
    return
  end
  local tid = self:GetTargetID(creature)
  if not tid then
    redlog("SceneFilterProxy:SceneFilterCheck", "fail to get target id", id, creature)
    return
  end
  local c, rid = false, id
  if counterwise then
    c = true
    rid = FunctionSceneFilter.Me().applyDefaultSceneFilterId or id
  end
  conf = conf or Table_ScreenFilter[id]
  if conf then
    map = map or self:GetMap(id)
    map[tid] = nil
    for i = 1, #conf.Content do
      self.handlerMap[conf.Content[i]](self, creature, rid, c)
    end
  end
end

function SceneFilterProxy:SceneFilterCheckWithContents(id, contents, creature, counterwise)
  if not creature then
    return
  end
  local c, rid = true, id
  if counterwise then
    c = false
    rid = FunctionSceneFilter.Me().applyDefaultSceneFilterId or id
  end
  for i = 1, #contents do
    self.handlerMap[contents[i]](self, creature, rid, c)
  end
end

function SceneFilterProxy:SceneFilterUnCheckWithContents(id, contents, creature, counterwise)
  if not creature then
    return
  end
  local c, rid = false, id
  if counterwise then
    c = true
    rid = FunctionSceneFilter.Me().applyDefaultSceneFilterId or id
  end
  for i = 1, #contents do
    self.handlerMap[contents[i]](self, creature, rid, c)
  end
end

function SceneFilterProxy:BloodBarHandler(creature, reason, check)
  if check then
    FunctionPlayerUI.Me():MaskBloodBar(creature, reason)
  else
    FunctionPlayerUI.Me():UnMaskBloodBar(creature, reason)
  end
end

function SceneFilterProxy:NameTitleHandler(creature, reason, check)
  if check then
    FunctionPlayerUI.Me():MaskNameHonorFactionType(creature, reason)
  else
    FunctionPlayerUI.Me():UnMaskNameHonorFactionType(creature, reason)
  end
end

function SceneFilterProxy:ChatSkillHandler(creature, reason, check)
  if check then
    self.forceMaskChat = true
    FunctionPlayerUI.Me():MaskChatSkill(creature, reason)
  else
    self.forceMaskChat = false
    FunctionPlayerUI.Me():UnMaskChatSkill(creature, reason)
  end
end

function SceneFilterProxy:IsForceMaskChat()
  return self.forceMaskChat
end

function SceneFilterProxy:TopFrameHandler(creature, reason, check)
  if check then
    FunctionPlayerUI.Me():MaskTopFrame(creature, reason)
  else
    FunctionPlayerUI.Me():UnMaskTopFrame(creature, reason)
  end
end

function SceneFilterProxy:EmojiHandler(creature, reason, check)
  if check then
    FunctionPlayerUI.Me():MaskEmoji(creature, reason)
  else
    FunctionPlayerUI.Me():UnMaskEmoji(creature, reason)
  end
end

function SceneFilterProxy:ModelHandler(creature, reason, check)
  creature:SetVisible(not check, reason)
end

function SceneFilterProxy:QuestUIHandler(creature, reason, check)
  if check then
    FunctionPlayerUI.Me():MaskQuestUI(creature, reason)
  else
    FunctionPlayerUI.Me():UnMaskQuestUI(creature, reason)
  end
end

function SceneFilterProxy:HurtNumHandler(creature, reason, check)
  if check then
    FunctionPlayerUI.Me():MaskHurtNum(creature, reason)
  else
    FunctionPlayerUI.Me():UnMaskHurtNum(creature, reason)
  end
end

function SceneFilterProxy:FloatRoleTopHandler(creature, reason, check)
  if check then
    FunctionPlayerUI.Me():MaskFloatRoleTop(creature, reason)
  else
    FunctionPlayerUI.Me():UnMaskFloatRoleTop(creature, reason)
  end
end

function SceneFilterProxy:FloatRoleTopHandler(creature, reason, check)
  if check then
    FunctionPlayerUI.Me():MaskFloatRoleTop(creature, reason)
  else
    FunctionPlayerUI.Me():UnMaskFloatRoleTop(creature, reason)
  end
end

function SceneFilterProxy:GiftSymbolHandler(creature, reason, check)
  if check then
    FunctionPlayerUI.Me():MaskGiftSymbol(creature, reason)
  else
    FunctionPlayerUI.Me():UnMaskGiftSymbol(creature, reason)
  end
end

function SceneFilterProxy:SkillEffectHandler(creature, reason, check)
  if check then
    self.maskSkillEffect = true
  else
    self.maskSkillEffect = false
  end
end

function SceneFilterProxy:LuaGameObjectHandler(luago, reason, check)
  if not luago or LuaGameObject.ObjectIsNull(luago) then
    return
  end
  if check then
    NGUITools.SetLayer(luago.gameObject, Game.ELayer.InVisible)
  else
    NGUITools.SetLayer(luago.gameObject, Game.ELayer.Default)
  end
end

function SceneFilterProxy:MaskSkillEffect()
  return self.maskSkillEffect
end

function SceneFilterProxy:PetPartnerHandler(creature, reason, check)
  if creature and creature:HasPetPartner() then
    creature:SetPartnerVisible(not check, reason)
  end
end

function SceneFilterProxy:PeakEffectHandler(creature, reason, check)
  if creature:GetCreatureType() == Creature_Type.Player then
    creature:SetPeakEffectVisible(not check, reason)
  end
end

function SceneFilterProxy:SeatHandler(creature, reason, check)
  Game.SceneSeatManager:SetDisplay(not check, reason)
end

function SceneFilterProxy:HireCatHandler(creature, reason, check)
  if creature and creature.data and creature.data.detailedType == NpcData.NpcDetailedType.WeaponPet then
    creature:SetVisible(not check, reason)
  end
end

function SceneFilterProxy:ModelWingHandler(creature, reason, check)
  if creature and creature.assetRole then
    creature.assetRole:SetWingDisplay(not check)
  end
end

function SceneFilterProxy:ModelTailHandler(creature, reason, check)
  if creature and creature.assetRole then
    creature.assetRole:SetTailDisplay(not check)
  end
end

function SceneFilterProxy:ExitPointHandler(creature, reason, check)
  Game.AreaTrigger_ExitPoint:SetFilterEnable(check)
end

function SceneFilterProxy:QuestLightEffectHandler(creature, reason, check)
  Game.QuestMiniMapEffectManager:SetFilterEnable(check)
end
