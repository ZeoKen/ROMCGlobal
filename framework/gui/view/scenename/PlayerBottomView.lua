PlayerBottomView = class("PlayerBottomView", SubView)
autoImport("GuildPictureManager")

function PlayerBottomView:Init()
  self:initData()
  self:AddViewEvents()
end

function PlayerBottomView:initData()
  self.selectedRoleId = nil
end

function PlayerBottomView:AddViewEvents()
  self:AddListenEvt(MyselfEvent.SelectTargetChange, self.HandlerSelectTargetChange)
  self:AddListenEvt(ServiceEvent.UserEventDamageNpcUserEvent, self.HandlerHit)
  self:AddListenEvt(MyselfEvent.BeHited, self.HandlerBeHit)
  self:AddListenEvt(ServiceEvent.GuildCmdGuildInfoNtf, self.HandlerPlayerFactionChange)
  self:AddListenEvt(TeamEvent.MemberEnterTeam, self.HandlerMemberDataChange)
  self:AddListenEvt(TeamEvent.MemberExitTeam, self.HandlerMemberDataChange)
  self:AddListenEvt(SetEvent.OnShowSettingUpdated, self.HandleShowSettingChanged)
  self:AddListenEvt(SceneUIEvent.SceneUIEnable, self.HandleSceneUIEnable)
  self:AddListenEvt(SceneUIEvent.SceneUIDisable, self.HandleSceneUIDisable)
  self:AddListenEvt(SceneUIEvent.RemoveMonsterNamePre, self.RemoveMonsterNamePre)
  self:AddListenEvt(SceneUIEvent.AddMonsterNamePre, self.AddMonsterNamePre)
  self:AddListenEvt(CreatureEvent.Name_Change, self.HandlerName_Change)
  self:AddListenEvt(GuildPictureManager.ThumbnailDownloadCompleteCallback, self.HandleGuildIconDownloadComplete)
  EventManager.Me():AddEventListener(BoothEvent.OpenBooth, self.BoothHandler, self)
  EventManager.Me():AddEventListener(BoothEvent.CloseBooth, self.BoothHandler, self)
end

function PlayerBottomView:AddMonsterNamePre(note)
  local questData = note.body
  local groupID = questData.params.groupId
  local npcID = questData.params.monster
  local npcUID = questData.params.uniqueid
  local targets
  if npcID then
    targets = NSceneNpcProxy.Instance:FindNpcs(npcID)
  end
  if not targets and groupID then
    targets = NSceneNpcProxy.Instance:FindNpcsByGroupID(groupID)
  end
  if not targets and npcUID then
    targets = NSceneNpcProxy.Instance:FindNpcByUniqueId(npcUID)
  end
  if not targets then
    return
  end
  for i = 1, #targets do
    local creature = targets[i]
    local sceneUI = creature:GetSceneUI()
    if sceneUI and sceneUI.roleBottomUI then
      sceneUI.roleBottomUI:SetQuestPrefixVisible(creature, true)
    end
  end
end

function PlayerBottomView:RemoveMonsterNamePre(note)
  local questData = note.body
  local groupID = questData.params.groupId
  local npcID = questData.params.monster
  local npcUID = questData.params.uniqueid
  local targets
  if npcID then
    targets = NSceneNpcProxy.Instance:FindNpcs(npcID)
  end
  if not targets and groupID then
    targets = NSceneNpcProxy.Instance:FindNpcsByGroupID(groupID)
  end
  if not targets and npcUID then
    targets = NSceneNpcProxy.Instance:FindNpcByUniqueId(npcUID)
  end
  if not targets then
    return
  end
  for i = 1, #targets do
    local creature = targets[i]
    local sceneUI = creature:GetSceneUI()
    if sceneUI and sceneUI.roleBottomUI then
      sceneUI.roleBottomUI:SetQuestPrefixVisible(creature, false)
    end
  end
end

function PlayerBottomView:HandlerSelectTargetChange(note)
  local creature = note.body
  local id = creature and creature.data.id or nil
  if self.selectedRoleId ~= nil and self.selectedRoleId ~= id then
    local creature = self:getCreature(self.selectedRoleId)
    local sceneUI = creature and creature:GetSceneUI() or nil
    if sceneUI then
      sceneUI.roleBottomUI:SetIsSelected(false, creature)
    end
    self.selectedRoleId = nil
  end
  local creature = self:getCreature(id)
  local sceneUI = creature and creature:GetSceneUI() or nil
  if sceneUI then
    sceneUI.roleBottomUI:SetIsSelected(true, creature)
    self.selectedRoleId = id
  end
end

function PlayerBottomView:HandlerPlayerFactionChange(note)
  local data = note.body
  if data then
    local id = data.charid
    local creature = self:getCreature(id)
    local sceneUI = creature and creature:GetSceneUI() or nil
    if sceneUI then
      local bottomUI = sceneUI.roleBottomUI
      bottomUI:HandlerPlayerFactionChange(creature)
      bottomUI:HandleChangeTitle(creature)
    end
  end
end

function PlayerBottomView:HandlerName_Change(note)
  local creature = note.body
  if creature then
    local sceneUI = creature:GetSceneUI() or nil
    if sceneUI then
      sceneUI.roleBottomUI:HandleChangeTitle(creature)
    end
  end
end

function PlayerBottomView:HandleOtherPlayerSettingMask()
  SceneCreatureProxy.ForEachCreature(self.HandleSettingMaskCreature)
end

function PlayerBottomView:HandleShowSettingChanged(note)
  TableUtil.Print(note)
  local updateTypes = note.body
  SceneCreatureProxy.ForEachCreature(function(creature)
    local creatureType = creature:GetCreatureType()
    if updateTypes and creatureType and updateTypes[creatureType] == true then
      creature:HandleSettingMask()
    end
  end)
end

function PlayerBottomView.HandleSettingMaskCreature(creature)
  if creature and creature:GetCreatureType() == Creature_Type.Player then
    creature:HandleSettingMask()
  end
end

function PlayerBottomView:HandlerMemberDataChange(note)
  local data = note.body
  if data then
    local id = data and data.id or nil
    local creature = self:getCreature(id)
    local sceneUI = creature and creature:GetSceneUI() or nil
    if sceneUI then
      sceneUI.roleBottomUI:HandlerMemberDataChange(creature)
    end
  end
end

function PlayerBottomView:HandlerBeHit(note)
  if LowBloodBlinkView.Instance then
    LowBloodBlinkView.ShowLowBloodBlinkWhenHit()
  end
end

function PlayerBottomView:HandlerHit(note)
  local data = note.body
  local id = data.npcguid
  local userid = data.userid
  local creature = self:getCreature(id)
  local sceneUI = creature and creature:GetSceneUI() or nil
  if sceneUI then
    sceneUI.roleBottomUI:SetIsBeHit(true, creature)
  end
end

function PlayerBottomView:getCreature(guid)
  if not guid then
    return
  end
  return SceneCreatureProxy.FindCreature(guid)
end

function PlayerBottomView:HandleSceneUIEnable()
  local uiCm = NGUIUtil:GetCameraByLayername("SceneUI")
  uiCm.enabled = true
end

function PlayerBottomView:HandleSceneUIDisable()
  local uiCm = NGUIUtil:GetCameraByLayername("SceneUI")
  uiCm.enabled = false
end

local tempArray = {}

function PlayerBottomView:HandleGuildIconDownloadComplete(note)
  local data = note.body
  local guild = data.guild
  local index = data.index
  local time = data.time
  NSceneUserProxy.Instance:FindCreateByGuild(guild, tempArray)
  GuildPictureManager.Instance():log("PlayerBottomView HandleGuildIconDownloadComplete", guild, index, time)
  if tempArray and 0 < #tempArray then
    for i = 1, #tempArray do
      local creature = tempArray[i]
      local sceneUI = creature and creature:GetSceneUI() or nil
      if sceneUI then
        sceneUI.roleBottomUI:HandlerPlayerFactionChange(creature)
      end
    end
  end
  TableUtility.ArrayClear(tempArray)
end

function PlayerBottomView:OnExit()
  EventManager.Me():RemoveEventListener(BoothEvent.OpenBooth, self.BoothHandler, self)
  EventManager.Me():RemoveEventListener(BoothEvent.CloseBooth, self.BoothHandler, self)
end

function PlayerBottomView:BoothHandler(note)
  local creature = note.data
  if creature ~= nil then
    local sceneUI = creature and creature:GetSceneUI() or nil
    if sceneUI then
      sceneUI.roleBottomUI:BoothStateChange(creature)
    end
  end
end
