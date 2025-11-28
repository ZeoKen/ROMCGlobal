autoImport("InVisibleObjCmd")
SkillInVisiblePlayerCmd = class("SkillInVisiblePlayerCmd", InVisibleObjCmd)

function SkillInVisiblePlayerCmd:ctor()
  self.invisibleLayerID = RO.Config.Layer.INVISIBLE.Value
  self:Reset()
end

function SkillInVisiblePlayerCmd:Reset()
  self.isRunning = false
  self.invisibles = {}
end

function SkillInVisiblePlayerCmd:IsInVisible(player)
  return player and self.invisibles[player.id] ~= nil or false
end

function SkillInVisiblePlayerCmd:End()
  EventManager.Me():RemoveEventListener(TeamEvent.MemberEnterTeam, self.AddTeamHandler, self)
  EventManager.Me():RemoveEventListener(TeamEvent.MemberExitTeam, self.ExitTeamHandler, self)
  EventManager.Me():RemoveEventListener(TeamEvent.ExitTeam, self.MeExitTeamHandler, self)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneRemoveNpcs, self.RemoveCreaturesHandler, self)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneRemoveRoles, self.RemoveCreaturesHandler, self)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneRemovePets, self.RemoveCreaturesHandler, self)
end

function SkillInVisiblePlayerCmd:Start()
  EventManager.Me():AddEventListener(TeamEvent.MemberEnterTeam, self.AddTeamHandler, self)
  EventManager.Me():AddEventListener(TeamEvent.MemberExitTeam, self.ExitTeamHandler, self)
  EventManager.Me():AddEventListener(TeamEvent.ExitTeam, self.MeExitTeamHandler, self)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneRemoveNpcs, self.RemoveCreaturesHandler, self)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneRemoveRoles, self.RemoveCreaturesHandler, self)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneRemovePets, self.RemoveCreaturesHandler, self)
end

function SkillInVisiblePlayerCmd:ShowPlayer(player)
  if player then
    self.invisibles[player.data.id] = nil
    player:SetStealth(false)
    player:SetVisible(true, LayerChangeReason.HidingSkill)
    FunctionPlayerUI.Me():UnMaskAllUI(player, PUIVisibleReason.HidingSkill)
  end
end

function SkillInVisiblePlayerCmd:HidePlayer(player)
  if player then
    local playerId = player.data.id
    self.invisibles[playerId] = playerId
    local id = player.data.id
    local isPet = player:GetCreatureType() == Creature_Type.Pet
    local isBoki = player.data.staticData and player.data.staticData.Type == NpcData.NpcDetailedType.Boki
    if not (not TeamProxy.Instance:IsInMyTeam(playerId) and not PvpObserveProxy.Instance:IsRunning() and (player.data.ownerID ~= Game.Myself.data.id or isBoki)) or isPet and not isBoki and TeamProxy.Instance:IsInMyTeam(player.data.ownerID) then
      self:HalfHide(player)
    else
      self:TotallyHide(player)
    end
    local petIDs = player.data.petIDs
    if petIDs then
      for i = 1, #petIDs do
        self:HidePet(SceneCreatureProxy.FindCreature(petIDs[i]))
      end
    end
  end
end

function SkillInVisiblePlayerCmd:HidePet(pet)
  if pet.data:IsCopyNpc_Detail() then
    return
  end
  if pet.data:IsPhantom() then
    return
  end
  self:HidePlayer(pet)
end

function SkillInVisiblePlayerCmd:TotallyHide(player)
  player:SetVisible(false, LayerChangeReason.HidingSkill)
  FunctionPlayerUI.Me():MaskAllUI(player, PUIVisibleReason.HidingSkill)
end

function SkillInVisiblePlayerCmd:HalfHide(player)
  player:SetStealth(true)
end

function SkillInVisiblePlayerCmd:RemoveCreaturesHandler(creaturesID)
  for k, pID in pairs(creaturesID) do
    self.invisibles[pID] = nil
  end
end

function SkillInVisiblePlayerCmd:AddTeamHandler(evt)
  local playerId = evt.data.id
  local player = NSceneUserProxy.Instance:FindOtherRole(playerId)
  if player and self.invisibles[playerId] then
    self:_ReHide(player, playerId)
    local petIDs = player.data.petIDs
    if petIDs then
      for i = 1, #petIDs do
        self:_ReHide(SceneCreatureProxy.FindCreature(petIDs[i]), petIDs[i])
      end
    end
  end
end

function SkillInVisiblePlayerCmd:ExitTeamHandler(evt)
  local playerId = evt.data.id
  local player = NSceneUserProxy.Instance:FindOtherRole(playerId)
  if player and self.invisibles[playerId] then
    self:_ReHide(player, playerId)
    local petIDs = player.data.petIDs
    if petIDs then
      for i = 1, #petIDs do
        self:_ReHide(SceneCreatureProxy.FindCreature(petIDs[i]), petIDs[i])
      end
    end
  end
end

function SkillInVisiblePlayerCmd:_ReHide(player, playerId)
  if player and self.invisibles[playerId] then
    self:ShowPlayer(player)
    self:HidePlayer(player)
  end
end

function SkillInVisiblePlayerCmd:MeExitTeamHandler(evt)
  local instance = NSceneUserProxy.Instance
  local player
  for k, pID in pairs(self.invisibles) do
    player = instance:FindOtherRole(pID)
    if player then
      player:SetStealth(false)
      self:TotallyHide(player)
      local petIDs = player.data.petIDs
      if petIDs then
        for i = 1, #petIDs do
          if self.invisibles[petIDs[i]] then
            player = SceneCreatureProxy.FindCreature(petIDs[i])
            if player then
              player:SetStealth(false)
              self:TotallyHide(player)
            end
          end
        end
      end
    end
  end
end
