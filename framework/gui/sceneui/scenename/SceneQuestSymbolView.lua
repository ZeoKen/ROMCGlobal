SceneQuestSymbolView = class("SceneQuestSymbolView", SubView)

function SceneQuestSymbolView:Init()
  self:MapViewListener()
end

function SceneQuestSymbolView:UpdateSingleRoleQuset(role, isRemove)
  if not role.data then
    return false
  end
  if not role.data:IsNpc() then
    return false
  end
  local hasSymbol = false
  local hasAttention = false
  local questlst = QuestProxy.Instance:getDialogQuestListByNpcId(role.data.staticData.id, role.data.uniqueid)
  hasAttention = self:HandleAttention(role, questlst)
  hasSymbol = self:HandleSymbol(role, questlst)
  if not hasSymbol then
    local sceneUI = role:GetSceneUI()
    if sceneUI then
      sceneUI.roleTopUI:RemoveQuestEffectSymbol()
    end
  end
  if not hasAttention then
    role:DestroyGuideEffect()
  end
end

function SceneQuestSymbolView:HandleAttention(role, questlst)
  if role.data:IsNpc() and questlst and 0 < #questlst then
    local d
    for i = 1, #questlst do
      d = questlst[i]
      if d.questDataStepType == QuestDataStepType.QuestDataStepType_VISIT and d.staticData and d.staticData.Params and d.staticData.Params.attention == "guide" then
        role:PlayGuideEffect()
        return true
      end
    end
  end
  return false
end

function SceneQuestSymbolView:HandleSymbol(role, questlst)
  questlst = QuestProxy.Instance:getSymbolDQListByNpcId(role.data.staticData.id, role.data.uniqueid, questlst)
  if not questlst then
    return
  end
  local symbolType
  local playerLevel = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
  local questIn = QuestProxy.Instance
  local showSymbol
  for i = 1, #questlst do
    if questlst[i].staticData then
      showSymbol = questlst[i].staticData.Params.ShowSymbol
      showSymbol = tonumber(showSymbol)
      if showSymbol == 1 or showSymbol == 3 then
      else
        local tsymbolType
        tsymbolType = QuestSymbolCheck.GetQuestSymbolByQuest(questlst[i])
        if tsymbolType and (symbolType == nil or symbolType > tsymbolType) then
          symbolType = tsymbolType
        end
      end
    end
  end
  if not symbolType and QuestSymbolCheck.HasDailySymbol(role.data.staticData) then
    symbolType = QuestSymbolType.Daily
  end
  if symbolType then
    local sceneUI = role:GetSceneUI()
    if sceneUI then
      sceneUI.roleTopUI:PlayQuestEffectSymbol(symbolType)
    end
    return true
  end
  return false
end

function SceneQuestSymbolView:UpdateNpcWalkSymbol(role, status)
  helplog("SceneQuestSymbolView:UpdateNpcWalkSymbol,status is ", status)
  if not role.data then
    return false
  end
  if not role.data:IsNpc() then
    return false
  end
  local hasSymbol = false
  local hasAttention = false
  local sceneUI = role:GetSceneUI()
  if sceneUI then
    if status == 1 then
      sceneUI.roleTopUI:PlayQuestEffectSymbol(19)
    elseif status == 2 then
      sceneUI.roleTopUI:RemoveQuestEffectSymbol()
    end
  end
end

function SceneQuestSymbolView:UpdateGuildWelfareSymbol(role)
  if nil == role or nil == role.data then
    return
  end
  if not role.data.IsNpc or not role.data:IsNpc() then
    return
  end
  if role.data.staticData.id ~= GuildProxy.Instance:GetWelfareNpcId() then
    return
  end
  local sceneUI = role:GetSceneUI()
  if sceneUI then
    local hasWelfare = GuildProxy.Instance:HasGuildWelfare()
    if hasWelfare then
      local getEffect = GameConfig.GuildBuilding.uieffect_getwelfare or "PetGift"
      sceneUI.roleTopUI:SetTopGiftSymbol(getEffect, self.GetGuildWelfare, self)
    else
      sceneUI.roleTopUI:RemoveTopGiftSymbol()
    end
  end
end

function SceneQuestSymbolView:UpdateGuildTreasureGiftSymbol(role)
  if nil == role or nil == role.data then
    return
  end
  if not role.data.IsNpc or not role.data:IsNpc() then
    return
  end
  if role.data.staticData.id ~= GuildTreasureProxy.Instance:GetTreasureNpcId() then
    return
  end
  local sceneUI = role:GetSceneUI()
  if sceneUI then
    local can = GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.Treasure)
    local show = GuildProxy.Instance.myGuildData.gvg_treasure_count == 1
    if show then
      redlog("GVG后端赋值gvg宝箱奖励")
    else
      redlog("GVG后端未赋值gvg宝箱奖励")
    end
    if show and can then
      local getEffect = GameConfig.GuildTreasure.GiftSymbol or "PetGift"
      sceneUI.roleTopUI:SetTopGiftSymbol(getEffect)
    else
      sceneUI.roleTopUI:RemoveTopGiftSymbol()
    end
  end
end

function SceneQuestSymbolView:GetGuildWelfare(creatureid)
end

function SceneQuestSymbolView:UpdateGiftNpcSymbol(role)
  if nil == role or nil == role.data then
    return
  end
  if not role.data.IsNpc or not role.data:IsNpc() then
    return
  end
  local npcid = role.data.staticData.id
  local npcData = npcid and Table_Npc[npcid]
  if not npcData then
    return
  end
  local ntype = npcData.Type
  if ntype == NpcData.NpcDetailedType.GiftNpc then
    local sceneUI = role:GetSceneUI()
    if sceneUI then
      local postcardid = role.data and role.data.postcard
      if postcardid and postcardid ~= 0 then
        local emojiID = Table_QuestPostcard[postcardid] and Table_QuestPostcard[postcardid].Emoji
        local emojiConfig = emojiID and Table_Expression[emojiID]
        local emojiName = emojiConfig and emojiConfig.NameEn
        if emojiName then
          sceneUI.roleTopUI:PlayEmoji(emojiName, nil, 9999)
        end
      else
        sceneUI.roleTopUI:RemoveTopGiftSymbol()
      end
    end
  end
end

function SceneQuestSymbolView:MapViewListener()
  self:AddListenEvt(ServiceEvent.QuestQuestUpdate, self.HandleQuestUpdate)
  self:AddListenEvt(ServiceEvent.QuestQuestStepUpdate, self.HandleQuestUpdate)
  self:AddListenEvt(ServiceEvent.NUserVarUpdate, self.HandleQuestUpdate)
  self:AddListenEvt(SystemUnLockEvent.NUserNewMenu, self.HandleQuestUpdate)
  self:AddListenEvt(ServiceEvent.QuestQuestList, self.HandleQuestUpdate)
  self:AddListenEvt(SceneUserEvent.SceneAddNpcs, self.HandleAddNpcRole)
  self:AddListenEvt(ServiceEvent.GuildCmdWelfareNtfGuildCmd, self.HandleGuildWelfareNtfCmd)
  self:AddListenEvt(ServiceEvent.GuildCmdExitGuildGuildCmd, self.HandleGuildWelfareNtfCmd)
  self:AddListenEvt(ServiceEvent.GuildCmdBuildingUpdateNtfGuildCmd, self.HandleGuildWelfareNtfCmd)
  self:AddListenEvt(ServiceEvent.GuildCmdGuildDataUpdateGuildCmd, self.HandleGuildTreasureGiftNtfCmd)
  self:AddListenEvt(ServiceEvent.FuBenCmdFubenStepSyncCmd, self.HandleQuestUpdate)
  self:AddListenEvt(ServiceEvent.MatchCCmdTriplePvpRewardStatusCmd, self.HandleTriplePwsRewardStatus)
  self:AddListenEvt(ServiceEvent.MatchCCmdChampionPvpRewardStatusCmd, self.HandleCampionPvpRewardStatus)
  self:AddListenEvt(ServiceEvent.SceneTipGameTipCmd, self.HandleSceneTipGameTipCmd)
  self:AddListenEvt(ServiceEvent.AchieveCmdNewNpcAchieveNtfAchCmd, self.HandleAchieveRewardStatus)
  self:AddListenEvt(ServiceEvent.AchieveCmdUpdateNpcAchieveAchCmd, self.HandleAchieveRewardStatus)
  self:AddListenEvt(MainViewEvent.MiniMapSettingChange, self.HandleQuestUpdate)
  self:AddListenEvt(MyselfEvent.LevelUp, self.HandleQuestUpdate)
end

function SceneQuestSymbolView:HandleQuestUpdate(note)
  local nowNpcs = NSceneNpcProxy.Instance.npcMap
  for npcid, npcList in pairs(nowNpcs) do
    for k, role in pairs(npcList) do
      if role.data:IsNpc() then
        self:UpdateSingleRoleQuset(role)
        self:UpdateGuildWelfareSymbol(role)
      end
    end
  end
end

function SceneQuestSymbolView:HandleNpcWalkSymbol(note)
  local nowNpcs = NSceneNpcProxy.Instance.npcMap
  for npcid, npcList in pairs(nowNpcs) do
    for k, role in pairs(npcList) do
      if role.data:IsNpc() and role.data.staticData.id == note.body.npcid then
        self:UpdateNpcWalkSymbol(role, note.body.status)
      end
    end
  end
end

function SceneQuestSymbolView:HandleAddNpcRole(note)
  local npcs = note.body
  for _, role in pairs(npcs) do
    self:UpdateSingleRoleQuset(role)
    self:UpdateGuildWelfareSymbol(role)
    self:UpdateGuildTreasureGiftSymbol(role)
    self:UpdateGiftNpcSymbol(role)
    self:UpdateTriplePwsRewardSymbol(role)
    self:HandleCampionPvpRewardStatus()
    self:UpdateAchieveRewardSymbol(role)
  end
end

function SceneQuestSymbolView:HandleGuildWelfareNtfCmd(note)
  if not Game.MapManager:IsRaidMode() then
    return
  end
  local roles_welfare = NSceneNpcProxy.Instance:FindNpcs(GuildProxy.Instance:GetWelfareNpcId())
  if roles_welfare == nil or #roles_welfare == 0 then
    return
  end
  self:UpdateGuildWelfareSymbol(roles_welfare[1])
end

function SceneQuestSymbolView:HandleGuildTreasureGiftNtfCmd(note)
  local roles_welfare = NSceneNpcProxy.Instance:FindNpcs(GuildTreasureProxy.Instance:GetTreasureNpcId())
  if roles_welfare == nil or #roles_welfare == 0 then
    return
  end
  self:UpdateGuildTreasureGiftSymbol(roles_welfare[1])
end

function SceneQuestSymbolView:HandleTriplePwsRewardStatus(note)
  local npcId = 11025
  local npcs = NSceneNpcProxy.Instance:FindNpcs(npcId)
  if npcs and npcs[1] then
    local npc = npcs[1]
    self:UpdateTriplePwsRewardSymbol(npc)
  end
end

function SceneQuestSymbolView:UpdateTriplePwsRewardSymbol(role)
  if not (role and role.data) or not role.data.staticData then
    return
  end
  if role.data.staticData.id ~= 11025 then
    return
  end
  local sceneUI = role:GetSceneUI()
  if sceneUI then
    local targetRewardStatus = PvpProxy.Instance:IsTriplePwsTargetRewardCanReceive()
    local rankRewardStatus = PvpProxy.Instance:IsTriplePwsRankRewardCanReceive()
    if targetRewardStatus or rankRewardStatus then
      sceneUI.roleTopUI:SetTopGiftSymbol(GameConfig.GuildBuilding.uieffect_getwelfare)
    else
      sceneUI.roleTopUI:RemoveTopGiftSymbol()
    end
  end
end

function SceneQuestSymbolView:HandleCampionPvpRewardStatus(note)
  local npcIdTeamPws = 1374
  local npcs = NSceneNpcProxy.Instance:FindNpcs(npcIdTeamPws)
  if npcs and npcs[1] then
    local npc = npcs[1]
    self:UpdatePVPRewardSymbol(npc, npcIdTeamPws, MatchCCmd_pb.CHAMPION_REWARD_TEAMPWS, MatchCCmd_pb.CHAMPION_REWARD_TEAMPWS_CROSS)
  end
  local npcIdTeam12 = 851012
  local npcs2 = NSceneNpcProxy.Instance:FindNpcs(npcIdTeam12)
  if npcs2 and npcs2[1] then
    local npc = npcs2[1]
    self:UpdatePVPRewardSymbol(npc, npcIdTeam12, MatchCCmd_pb.CHAMPION_REWARD_TWELVE, MatchCCmd_pb.CHAMPION_REWARD_TWELVE_CROSS)
  end
end

function SceneQuestSymbolView:UpdatePVPRewardSymbol(role, npcid, rewardType, rewardTypeMix)
  if not (role and role.data) or not role.data.staticData then
    return
  end
  if role.data.staticData.id ~= npcid then
    return
  end
  local sceneUI = role:GetSceneUI()
  if sceneUI then
    local targetRewardStatus = PvpProxy.Instance:CheckChampionPvpRewardStatusCmd(rewardType)
    local rankRewardStatus = PvpProxy.Instance:CheckChampionPvpRewardStatusCmd(rewardTypeMix)
    if targetRewardStatus or rankRewardStatus then
      sceneUI.roleTopUI:SetTopGiftSymbol(GameConfig.GuildBuilding.uieffect_getwelfare)
    else
      sceneUI.roleTopUI:RemoveTopGiftSymbol()
    end
  end
end

function SceneQuestSymbolView:HandleSceneTipGameTipCmd(note)
  local data = note.body
  for i = 1, #data.redtip do
    local redtip = data.redtip[i]
    if redtip.redsys == SceneTip_pb.EREDSYS_SHOP_COUPON then
      local npcId = 1239
      local npcs = NSceneNpcProxy.Instance:FindNpcs(npcId)
      if npcs and npcs[1] then
        local npc = npcs[1]
        local sceneUI = npc:GetSceneUI()
        if sceneUI then
          if data.opt == SceneTip_pb.ETIPOPT_UPDATE then
            sceneUI.roleTopUI:SetTopGiftSymbol(GameConfig.GuildBuilding.uieffect_getwelfare)
            break
          end
          if data.opt == SceneTip_pb.ETIPOPT_DELETE then
            sceneUI.roleTopUI:RemoveTopGiftSymbol()
          end
        end
      end
      break
    end
  end
end

function SceneQuestSymbolView:HandleAchieveRewardStatus()
  local npcs = NSceneNpcProxy.Instance:PickNpcs(function(npc)
    local npcfunction = npc.data.staticData.NpcFunction
    if not npcfunction or #npcfunction == 0 then
      return false
    end
    for i = 1, #npcfunction do
      local npcFuncData = npcfunction[i]
      if npcFuncData.type and npcFuncData.type == 12015 then
        return true
      end
    end
  end)
  if npcs and 0 < #npcs then
    for i = 1, #npcs do
      self:UpdateAchieveRewardSymbol(npcs[i])
    end
  end
end

function SceneQuestSymbolView:UpdateAchieveRewardSymbol(role)
  if not (role and role.data) or not role.data.staticData then
    return
  end
  local npcfunction = role.data.staticData.NpcFunction
  if not npcfunction or #npcfunction == 0 then
    return
  end
  local groupid
  for i = 1, #npcfunction do
    local npcFuncData = npcfunction[i]
    if npcFuncData.type and npcFuncData.type == 12015 then
      groupid = npcFuncData.param
      break
    end
  end
  if not groupid then
    return
  end
  local sceneUI = role:GetSceneUI()
  if sceneUI then
    local targetRewardStatus = AchieveRewardProxy.Instance:CheckAchieveRewardStatusCmd(groupid)
    xdlog("UpdateAchieveRewardSymbol", groupid, targetRewardStatus)
    if targetRewardStatus then
      sceneUI.roleTopUI:SetTopGiftSymbol("PetGift")
    else
      sceneUI.roleTopUI:RemoveTopGiftSymbol()
    end
  end
end
