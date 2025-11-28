ScenePlayerRevive = class("ScenePlayerRevive", SubView)
ScenePlayerRevive.ExpelSkillSortId = 10151
local ReviveSkillSortIds = GameConfig.PlayerReviveSkill
local _SkillProxy
local Func_HaveReviveSkill = function()
  if _SkillProxy == nil then
    _SkillProxy = SkillProxy.Instance
  end
  for i = 1, #ReviveSkillSortIds do
    if _SkillProxy:HasLearnedSkillBySort(ReviveSkillSortIds[i]) then
      return true
    end
  end
  return false
end
local Func_GetReviveSkill = function()
  if _SkillProxy == nil then
    _SkillProxy = SkillProxy.Instance
  end
  for i = 1, #ReviveSkillSortIds do
    local skill = _SkillProxy:GetLearnedSkillBySortID(ReviveSkillSortIds[i])
    if skill then
      return skill
    end
  end
  return false
end
local FindPlayer = function(playerid)
  if playerid == BokiProxy.Instance:GetBokiGuid() then
    return NScenePetProxy.Instance:Find(playerid)
  else
    local p = NSceneUserProxy.Instance:Find(playerid)
    if p then
      return p
    end
    if TeamProxy.Instance:IsInMyTeam(playerid) then
      return NSceneNpcProxy.Instance:Find(playerid)
    end
  end
end
local _MapManager

function ScenePlayerRevive:Init()
  _MapManager = Game.MapManager
  self.deadPlayerMap = {}
  self.reviveEffectMap = {}
  self:MapListenEvent()
end

function ScenePlayerRevive:GetReviveLeafItem()
  if _MapManager:IsPVEMode_Roguelike() then
    local reviveLeafId = GameConfig.Roguelike.deathcost.id
    return reviveLeafId and DungeonProxy.Instance:GetRoguelikeItemByStaticId(reviveLeafId)
  else
    local reviveLeafId = GameConfig.PlayerRelive.deathcost[1].id
    return reviveLeafId and BagProxy.Instance:GetItemByStaticID(reviveLeafId)
  end
end

function ScenePlayerRevive:GetReviveStoneItem()
  local reviveStoneId = GameConfig.PlayerRelive.Skillcost[1].id
  return reviveStoneId and BagProxy.Instance:GetItemByStaticID(reviveStoneId)
end

function ScenePlayerRevive:GetReviveEffectId(reviveItemType)
  if reviveItemType == "Stone" then
    return EffectMap.UI.Blue_Gemstone
  elseif reviveItemType == "Leaf" then
    if _MapManager:IsPVEMode_Roguelike() then
      return EffectMap.UI.RogueYggdrasilberry
    else
      return EffectMap.UI.Yggdrasilberry
    end
  end
end

function ScenePlayerRevive:MapListenEvent()
  self:AddDispatcherEvt(CreatureEvent.Player_CampChange, self.HandlePlayerCampChange)
  self:AddListenEvt(PlayerEvent.DeathStatusChange, self.HandlePlayerStatusChange)
  self:AddListenEvt(PlayerEvent.BuffChange, self.HandlePlayerBuffChange)
  self:AddListenEvt(SceneUserEvent.SceneAddRoles, self.HandleAddRoles)
  self:AddListenEvt(SceneUserEvent.SceneRemoveRoles, self.HandleRemoveRoles)
  self:AddListenEvt(ItemEvent.ReviveItemAdd, self.UpdatePlayersReviveState)
  self:AddListenEvt(ItemEvent.ReviveItemRemove, self.UpdatePlayersReviveState)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.UpdatePlayersReviveState)
  self:AddListenEvt(ServiceEvent.RoguelikeCmdRoguelikeRaidInfoCmd, self.UpdatePlayersReviveState)
  self:AddListenEvt(MyselfEvent.BokiHidePropsChange, self.UpdatePlayersReviveState)
end

function ScenePlayerRevive:HandleAddRoles(note)
  local players = note.body
  if players then
    for _, player in pairs(players) do
      if player then
        self:UpdatePlayerReviveState(player.data.id)
      end
    end
  end
end

function ScenePlayerRevive:HandleRemoveRoles(note)
  local playerids = note.body
  if playerids then
    for _, playerid in pairs(playerids) do
      local effect = self.reviveEffectMap[playerid]
      if effect then
        effect:Destroy()
      end
      self.reviveEffectMap[playerid] = nil
    end
  end
end

function ScenePlayerRevive:HandlePlayerCampChange(player)
  if player then
    self:UpdatePlayerReviveState(player.data.id)
  end
end

function ScenePlayerRevive:HandlePlayerStatusChange(note)
  local player = note.body
  if player then
    self:UpdatePlayerReviveState(player.data.id)
  end
end

function ScenePlayerRevive:HandlePlayerBuffChange(note)
  local playerid = note.body
  if playerid then
    self:UpdatePlayerReviveState(playerid)
  end
end

function ScenePlayerRevive:UpdatePlayersReviveState()
  for playerid, effect in pairs(self.deadPlayerMap) do
    self:UpdatePlayerReviveState(playerid)
  end
end

function ScenePlayerRevive._ReviveBySkill(playerid, reviveItem)
  if _MapManager:IsPVEMode_Roguelike() and not DungeonProxy.Instance:CheckRoguelikeCanRevive(_MapManager) and playerid ~= BokiProxy.Instance:GetBokiGuid() then
    MsgManager.ShowMsgByID(25966)
    return
  end
  if (_MapManager:IsPveMode_Thanatos() or _MapManager:IsPVEMode_ComodoRaid() or _MapManager:IsPVEMode_MultiBossRaid() or _MapManager:IsPVEMode_Element()) and not GroupRaidProxy.Instance:CheckCanRevive() then
    MsgManager.ShowMsgByID(25966)
    return
  end
  local player = FindPlayer(playerid)
  if not player then
    return
  end
  if player and player:IsDead() then
    local skill = Func_GetReviveSkill()
    local range
    local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skill.id)
    if skillInfo then
      range = skillInfo:GetLaunchRange(player)
    end
    Game.Myself:Client_AccessTarget(player, skill.id, nil, AccessCustomType.ReviveBySkill, range)
  end
end

function ScenePlayerRevive._ReviveByLeaf(playerid, reviveItem)
  local player = FindPlayer(playerid)
  if not player then
    return
  end
  local isBoki = playerid == BokiProxy.Instance:GetBokiGuid()
  if isBoki then
    local p = NScenePetProxy.Instance:Find(playerid)
    if p and p:IsDead() then
      Game.Myself:Client_AccessTarget(p, reviveItem, nil, AccessCustomType.UseItem)
    end
  else
    if (_MapManager:IsPveMode_Thanatos() or _MapManager:IsPVEMode_ComodoRaid() or _MapManager:IsPVEMode_MultiBossRaid() or _MapManager:IsPVEMode_Element() or _MapManager:IsPVEMode_SpaceTimeIllusion()) and not GroupRaidProxy.Instance:CheckCanRevive() then
      MsgManager.ShowMsgByID(25966)
      return
    end
    if _MapManager:IsPVEMode_Roguelike() and not DungeonProxy.Instance:CheckRoguelikeCanRevive(_MapManager) then
      MsgManager.ShowMsgByID(25966)
      return
    end
    MsgManager.ConfirmMsgByID(_MapManager:IsPVEMode_Roguelike() and 40712 or 2508, function()
      local p = NSceneUserProxy.Instance:Find(playerid)
      if not p and TeamProxy.Instance:IsInMyTeam(playerid) then
        p = NSceneNpcProxy.Instance:Find(playerid)
      end
      if p and p:IsDead() then
        Game.Myself:Client_AccessTarget(p, reviveItem, nil, AccessCustomType.UseItem)
      end
    end, nil, nil, player.data.name)
  end
end

function ScenePlayerRevive._DoExpel(playerid)
  local player = NSceneUserProxy.Instance:Find(playerid)
  if not player then
    return
  end
  if player and player:IsDead() then
    local skillId
    if _MapManager:IsGvgMode_Droiyan() then
      skillId = GameConfig.GvgDroiyan.ExpelSkill
    else
      skillId = GameConfig.GVGConfig.expel_skill
    end
    Game.Myself:Client_AccessTarget(player, skillId, nil, AccessCustomType.UseSkill, 1)
  end
end

function ScenePlayerRevive._CreateReviveEffect(effectHandle, args, assetEffect)
  if not effectHandle then
    return
  end
  local self = args[1]
  local playerid = args[2]
  local reviveFunc = args[3]
  local reviveItem = args[4]
  ReusableTable.DestroyAndClearArray(args)
  local obj = effectHandle.gameObject
  local spObj = UIUtil.GetAllComponentInChildren(obj, Image)
  if spObj ~= nil then
    UIUtil.AddUGUIClickEvent(spObj.gameObject, function(go)
      reviveFunc(playerid, reviveItem)
    end)
  else
    redlog("not find image.")
  end
end

function ScenePlayerRevive:UpdatePlayerReviveState(playerid)
  if playerid == Game.Myself.data.id then
    return
  end
  if MyselfProxy.Instance:InOb() then
    return
  end
  local reviveEffectId, reviveFunc, reviveItem
  if Func_HaveReviveSkill() then
    local reviveStone = self:GetReviveStoneItem()
    if reviveStone and reviveStone.num > 0 then
      reviveEffectId = self:GetReviveEffectId("Stone")
      reviveFunc = ScenePlayerRevive._ReviveBySkill
      reviveItem = reviveStone
    end
  end
  if reviveItem == nil then
    local reviveLeaf = self:GetReviveLeafItem()
    if reviveLeaf and reviveLeaf.num > 0 then
      reviveEffectId = self:GetReviveEffectId("Leaf")
      reviveFunc = ScenePlayerRevive._ReviveByLeaf
      reviveItem = reviveLeaf
    end
  end
  local player = FindPlayer(playerid)
  local _bokiProxy = BokiProxy.Instance
  if not player or playerid == _bokiProxy:GetBokiGuid() and _bokiProxy:BokiHiding() then
    self:RemoveReviveEffect(playerid)
    return false
  end
  if player.data:NoRelive() then
    return false
  end
  if player:IsDead() then
    self.deadPlayerMap[playerid] = 1
  else
    self.deadPlayerMap[playerid] = nil
  end
  local hasEvent = false
  if self.deadPlayerMap[playerid] then
    if player.data:GetCamp() == RoleDefines_Camp.FRIEND then
      if reviveItem and not player:IsInRevive() then
        hasEvent = true
        self:RemoveReviveEffect(playerid)
        local args = ReusableTable.CreateArray()
        args[1] = self
        args[2] = playerid
        args[3] = reviveFunc
        args[4] = reviveItem
        local effect = SceneUIManager.Instance:PlayUIEffectOnRoleTop(reviveEffectId, playerid, false, false, ScenePlayerRevive._CreateReviveEffect, args)
        effect:RegisterWeakObserver(self)
        self.reviveEffectMap[playerid] = effect
      end
    elseif player.data:GetCamp() == RoleDefines_Camp.ENEMY and _MapManager:IsPVPMode() and (_MapManager:IsPVPMode_GVGDetailed() or _MapManager:IsGvgMode_Droiyan()) then
      hasEvent = true
      self:RemoveReviveEffect(playerid)
      local args = ReusableTable.CreateArray()
      args[1] = self
      args[2] = playerid
      args[3] = ScenePlayerRevive._DoExpel
      local effect = SceneUIManager.Instance:PlayUIEffectOnRoleTop(EffectMap.UI.Expel, playerid, false, false, ScenePlayerRevive._CreateReviveEffect, args)
      effect:RegisterWeakObserver(self)
      self.reviveEffectMap[playerid] = effect
    end
  end
  if hasEvent then
    return true
  end
  self:RemoveReviveEffect(playerid)
  return false
end

function ScenePlayerRevive:RemoveReviveEffect(playerid)
  if self.reviveEffectMap[playerid] then
    self.reviveEffectMap[playerid]:Destroy()
  end
  self.reviveEffectMap[playerid] = nil
end

function ScenePlayerRevive:ObserverDestroyed(obj)
  for playerid, effect in pairs(self.reviveEffectMap) do
    if effect == obj then
      self.reviveEffectMap[playerid] = nil
      break
    end
  end
end
