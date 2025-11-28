FunctionTrainEscort = class("FunctionTrainEscort")

function FunctionTrainEscort.Me()
  if nil == FunctionTrainEscort.me then
    FunctionTrainEscort.me = FunctionTrainEscort.new()
  end
  return FunctionTrainEscort.me
end

function FunctionTrainEscort:ctor()
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddNpcs, self.HandleAddNpc, self)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneRemoveNpcs, self.HandleRemoveNpc, self)
  EventManager.Me():AddEventListener(LoadSceneEvent.FinishLoadScene, self.HandleSceneLoaded, self)
  EventDispatcherRobust.Me():AddEventListener(CreatureEvent.OnAllPartLoaded, self.OnSceneUserAddedOrLoaded, self)
end

function FunctionTrainEscort:HandleAddNpc(note)
  if self.trainTopId == nil or self.trainTopId == 0 then
    return
  end
  local data = note
  if data then
    local npcData
    for i = 1, #data do
      npcData = data[i].data
      if npcData.id == self.trainTopId then
        if self.clientState == FunctionTrainEscort.State.EVENT_GOODS then
          self:AddTrainCollectInfoTopFuncWords()
        else
          self:RemoveTrainCollectInfoTopFuncWords()
        end
        self:PlayNPartnerGoodsEffect()
        self:UpdateNPartnerTransformInEvent()
        return
      end
    end
  end
end

function FunctionTrainEscort:HandleRemoveNpc(note)
end

function FunctionTrainEscort:SetActivityOpen(is_open)
  self.is_open = is_open
  self:UpdateMainViewExtraInfo()
end

FunctionTrainEscort.State = {
  END = 0,
  IN_PROGRESS = 1,
  WAITING = 2,
  EVENT_GOODS = 3,
  EVENT_ANGRY = 4,
  TRAIN_ARRIVE = 999
}

function FunctionTrainEscort:HandleEscortActUpdate(data)
  self.escortActData = data
  self.clientState = data.state
  if self.clientState == ActivityCmd_pb.EESCORT_EVENT then
    if data.goods_nums ~= nil and #data.goods_nums > 0 then
      self.clientState = FunctionTrainEscort.State.EVENT_GOODS
    else
      self.clientState = FunctionTrainEscort.State.EVENT_ANGRY
    end
  elseif self.clientState == ActivityCmd_pb.EESCORT_TRAIN_ARRIVE then
    self.clientState = FunctionTrainEscort.State.TRAIN_ARRIVE
  end
  if self.clientState == FunctionTrainEscort.State.END then
  elseif self.clientState == FunctionTrainEscort.State.IN_PROGRESS then
  elseif self.clientState == FunctionTrainEscort.State.WAITING then
  elseif self.clientState == FunctionTrainEscort.State.EVENT_GOODS then
  elseif self.clientState == FunctionTrainEscort.State.EVENT_ANGRY then
  end
  self.trainTopId = self.escortActData.target_guid
  if self.clientState == FunctionTrainEscort.State.EVENT_GOODS then
    self:AddTrainCollectInfoTopFuncWords()
  else
    self:RemoveTrainCollectInfoTopFuncWords()
  end
  self.escortMapId = Game.MapManager:GetMapID()
  self.is_inEscortMap = true
  self:UpdateMainViewExtraInfo()
  self:PlayNPartnerGoodsEffect()
  self:UpdateNPartnerTransformInEvent()
end

function FunctionTrainEscort:GetClientState()
  return self.clientState
end

function FunctionTrainEscort:GetIsEscortOpen()
  return self.is_open
end

function FunctionTrainEscort:GetIsEscortMap()
  return self.is_open and self.is_inEscortMap
end

function FunctionTrainEscort:HandleSceneLoaded()
  local newId = Game.MapManager:GetMapID()
  if not self.escortMapId or newId ~= self.escortMapId then
    self.is_inEscortMap = false
    self:UpdateMainViewExtraInfo()
  end
end

function FunctionTrainEscort:UpdateMainViewExtraInfo()
  if not self:GetIsEscortMap() then
    self.rolepart_pending_UpdateNPartnerTransformInEvent = nil
    self.rolepart_pending_PlayNPartnerGoodsEffect = nil
    self.rolepart_pending_nc1 = nil
    self.rolepart_pending_nc2 = nil
  end
  GameFacade.Instance:sendNotification(EscortEvent.EscortInfoChanged)
end

local _icons = {
  "Gift_1",
  "Gift_2",
  "Gift_3"
}
local _icon_npc_ids = {
  850042,
  850043,
  850044
}

function FunctionTrainEscort:AddTrainCollectInfoTopFuncWords()
  if self.trainTopId == nil or self.trainTopId == 0 then
    return
  end
  local role = SceneCreatureProxy.FindCreature(self.trainTopId)
  if role == nil then
    return
  end
  local goods_round = self.escortActData.finish_collect_goods_time
  if 2 <= goods_round then
    return
  end
  local nc1 = role.partner
  local nc2 = nc1 and nc1.partner
  local icons = _icons
  local texts = {
    "",
    "",
    ""
  }
  for i = 1, #self.escortActData.goods_nums do
    local info = self.escortActData.goods_nums[i]
    local index = TableUtility.ArrayFindIndex(_icon_npc_ids, info.npcid)
    if 0 < index then
      local fin = info.cur >= info.need
      texts[index] = string.format("<color=%s>%s</color>", fin and "#00FF00" or "#000000", "X" .. info.need)
    end
  end
  if goods_round == 0 then
    if nc2 then
      SceneUIManager.Instance:RemoveRoleTopFuncWords_TrainEscort(nc2)
    end
    if nc1 then
      SceneUIManager.Instance:AddRoleTopFuncWords_TrainEscort(nc1, icons, texts, nil, nil)
    end
  elseif goods_round == 1 then
    if nc1 then
      SceneUIManager.Instance:RemoveRoleTopFuncWords_TrainEscort(nc1)
    end
    if nc2 then
      SceneUIManager.Instance:AddRoleTopFuncWords_TrainEscort(nc2, icons, texts, nil, nil)
    end
  end
end

function FunctionTrainEscort:RemoveTrainCollectInfoTopFuncWords()
  if self.trainTopId == nil or self.trainTopId == 0 then
    return
  end
  local role = SceneCreatureProxy.FindCreature(self.trainTopId)
  if role == nil then
    return
  end
  local nc1 = role.partner
  local nc2 = nc1 and nc1.partner
  if nc1 then
    SceneUIManager.Instance:RemoveRoleTopFuncWords_TrainEscort(nc1)
  end
  if nc2 then
    SceneUIManager.Instance:RemoveRoleTopFuncWords_TrainEscort(nc2)
  end
end

local effKey = "effKey_NPartnerGoodsEffect"

function FunctionTrainEscort:PlayNPartnerGoodsEffect()
  if self.trainTopId == nil or self.trainTopId == 0 then
    return
  end
  local role = SceneCreatureProxy.FindCreature(self.trainTopId)
  if role == nil then
    return
  end
  local nc1 = role.partner
  local nc2 = nc1 and nc1.partner
  if not nc1 or not nc2 then
    return
  end
  self.rolepart_pending_PlayNPartnerGoodsEffect = nil
  if not nc1:HasAllPartLoaded() or not nc2:HasAllPartLoaded() then
    self.rolepart_pending_nc1 = nc1.data.id
    self.rolepart_pending_nc2 = nc2.data.id
    self.rolepart_pending_PlayNPartnerGoodsEffect = true
    return
  end
  self:_PlayNPartnerGoodsEffect(nc1, nc2)
end

function FunctionTrainEscort:_PlayNPartnerGoodsEffect(nc1, nc2)
  local effConfig = GameConfig.TrainEscort.GiftBoxCountEffect
  local full_idx = 15
  local eff_path
  local goods_round = self.escortActData.finish_collect_goods_time
  local in_goods_event = self.clientState == FunctionTrainEscort.State.EVENT_GOODS
  local cur_goods_cnt = full_idx
  if in_goods_event then
    cur_goods_cnt = 0
    for i = 1, #self.escortActData.goods_nums do
      local info = self.escortActData.goods_nums[i]
      cur_goods_cnt = cur_goods_cnt + info.cur
    end
  end
  local is_end = self.clientState == FunctionTrainEscort.State.TRAIN_ARRIVE
  if is_end then
    goods_round = 2
  end
  local ep = GameConfig.TrainEscort.GoodsEffectEp or 12
  if goods_round == 0 then
    nc1:RemoveEffect(effKey)
    if in_goods_event and 0 < cur_goods_cnt then
      eff_path = effConfig[cur_goods_cnt]
      nc1:PlayEffect(effKey, "Skill/" .. eff_path, ep, nil, true, true)
    end
    nc2:RemoveEffect(effKey)
  elseif goods_round == 1 then
    if not nc1:GetEffect(effKey) then
      eff_path = effConfig[full_idx]
      nc1:PlayEffect(effKey, "Skill/" .. eff_path, ep, nil, true, true)
    end
    nc2:RemoveEffect(effKey)
    if in_goods_event and 0 < cur_goods_cnt then
      eff_path = effConfig[cur_goods_cnt]
      nc2:PlayEffect(effKey, "Skill/" .. eff_path, ep, nil, true, true)
    end
  else
    if not nc1:GetEffect(effKey) then
      eff_path = effConfig[full_idx]
      nc1:PlayEffect(effKey, "Skill/" .. eff_path, ep, nil, true, true)
    end
    if not nc2:GetEffect(effKey) then
      eff_path = effConfig[full_idx]
      nc2:PlayEffect(effKey, "Skill/" .. eff_path, ep, nil, true, true)
    end
  end
end

function FunctionTrainEscort:UpdateNPartnerTransformInEvent()
  local posIndex = self.escortActData.cur_pos_index
  local transformInfo = GameConfig.TrainEscort and GameConfig.TrainEscort.EventPartnerLocation
  transformInfo = transformInfo and transformInfo[posIndex]
  if not transformInfo then
    return
  end
  if self.trainTopId == nil or self.trainTopId == 0 then
    return
  end
  local role = SceneCreatureProxy.FindCreature(self.trainTopId)
  if role == nil then
    return
  end
  local nc1 = role.partner
  local nc2 = nc1 and nc1.partner
  if not nc1 or not nc2 then
    return
  end
  self.rolepart_pending_UpdateNPartnerTransformInEvent = nil
  if not nc1:HasAllPartLoaded() or not nc2:HasAllPartLoaded() then
    self.rolepart_pending_nc1 = nc1.data.id
    self.rolepart_pending_nc2 = nc2.data.id
    self.rolepart_pending_UpdateNPartnerTransformInEvent = true
    return
  end
  self:_UpdateNPartnerTransformInEvent(nc1, nc2, transformInfo)
end

function FunctionTrainEscort:_UpdateNPartnerTransformInEvent(nc1, nc2, transformInfo)
  if self.clientState ~= FunctionTrainEscort.State.EVENT_GOODS and self.clientState ~= FunctionTrainEscort.State.EVENT_ANGRY then
    nc1:SetPauseAI(false)
    nc2:SetPauseAI(false)
    return
  end
  local info
  if nc1 then
    nc1:SetPauseAI(true)
    info = transformInfo[1]
    nc1:Logic_PlayAction_Idle()
    nc1:Logic_NavMeshPlaceXYZTo(info.pos[1], info.pos[2], info.pos[3])
    nc1:Server_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, info.dir)
  end
  if nc2 then
    nc2:SetPauseAI(true)
    info = transformInfo[2]
    nc2:Logic_PlayAction_Idle()
    nc2:Logic_NavMeshPlaceXYZTo(info.pos[1], info.pos[2], info.pos[3])
    nc2:Server_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, info.dir)
  end
end

function FunctionTrainEscort:OnSceneUserAddedOrLoaded(ncreature)
  if not self.rolepart_pending_UpdateNPartnerTransformInEvent and not self.rolepart_pending_PlayNPartnerGoodsEffect then
    return
  end
  local guid = ncreature and ncreature.data.id
  if guid ~= self.rolepart_pending_nc1 and guid ~= self.rolepart_pending_nc2 then
    return
  end
  if self.trainTopId == nil or self.trainTopId == 0 then
    return
  end
  local role = SceneCreatureProxy.FindCreature(self.trainTopId)
  if role == nil then
    return
  end
  local nc1 = role.partner
  local nc2 = nc1 and nc1.partner
  if not nc1 or not nc2 then
    return
  end
  if not nc1:HasAllPartLoaded() or not nc2:HasAllPartLoaded() then
    return
  end
  if self.rolepart_pending_PlayNPartnerGoodsEffect then
    self.rolepart_pending_PlayNPartnerGoodsEffect = nil
    self:_PlayNPartnerGoodsEffect(nc1, nc2)
  end
  if self.rolepart_pending_UpdateNPartnerTransformInEvent then
    self.rolepart_pending_UpdateNPartnerTransformInEvent = nil
    if self.clientState ~= FunctionTrainEscort.State.EVENT_GOODS and self.clientState ~= FunctionTrainEscort.State.EVENT_GOODS then
      return
    end
    local posIndex = self.escortActData.cur_pos_index
    local transformInfo = GameConfig.TrainEscort and GameConfig.TrainEscort.EventPartnerLocation
    transformInfo = transformInfo and transformInfo[posIndex]
    if not transformInfo then
      return
    end
    self:_UpdateNPartnerTransformInEvent(nc1, nc2, transformInfo)
  end
end
