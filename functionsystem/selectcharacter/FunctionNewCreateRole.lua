autoImport("NewCreateRoleAnimationCtrlV3")
FunctionNewCreateRole = class("FunctionNewCreateRole")
FunctionNewCreateRoleEvent = {
  Enter = "FunctionNewCreateRoleEvent_Enter",
  ModelLoadCanOperation = "FunctionNewCreateRoleEvent_ModelLoadCanOperation",
  ESYSTEMMSG_ID_TEXT_ADVERTISE = "FunctionNewCreateRoleEvent_ESYSTEMMSG_ID_TEXT_ADVERTISE"
}
FunctionNewCreateRole.ProfConfig = Table_CreateCharactor or {
  [1] = {
    id = 1,
    prof = 12,
    carriagePos = "A1",
    prof_color = {
      200,
      200,
      200
    }
  },
  [2] = {
    id = 2,
    prof = 72,
    carriagePos = "A2",
    prof_color = {
      200,
      200,
      200
    }
  },
  [3] = {
    id = 3,
    prof = 22,
    carriagePos = "B1",
    prof_color = {
      200,
      200,
      200
    }
  },
  [4] = {
    id = 4,
    prof = 82,
    carriagePos = "B2",
    prof_color = {
      200,
      200,
      200
    }
  },
  [5] = {
    id = 5,
    prof = 32,
    carriagePos = "C1",
    prof_color = {
      200,
      200,
      200
    }
  },
  [6] = {
    id = 6,
    prof = 92,
    carriagePos = "C2",
    prof_color = {
      200,
      200,
      200
    }
  },
  [7] = {
    id = 7,
    prof = 42,
    carriagePos = "D1",
    prof_color = {
      200,
      200,
      200
    }
  },
  [8] = {
    id = 8,
    prof = 102,
    carriagePos = "D2",
    prof_color = {
      200,
      200,
      200
    }
  },
  [9] = {
    id = 9,
    prof = 112,
    carriagePos = "A1",
    prof_color = {
      200,
      200,
      200
    }
  },
  [10] = {
    id = 10,
    prof = 52,
    carriagePos = "A2",
    prof_color = {
      200,
      200,
      200
    }
  },
  [11] = {
    id = 11,
    prof = 122,
    carriagePos = "B1",
    prof_color = {
      200,
      200,
      200
    }
  },
  [12] = {
    id = 12,
    prof = 62,
    carriagePos = "C1",
    prof_color = {
      200,
      200,
      200
    }
  },
  [13] = {
    id = 13,
    prof = 132,
    carriagePos = "D1",
    prof_color = {
      200,
      200,
      200
    }
  },
  [14] = {
    id = 14,
    prof = 152,
    carriagePos = "D2",
    prof_color = {
      200,
      200,
      200
    }
  },
  [15] = {
    id = 15,
    prof = 163,
    carriagePos = "A1",
    prof_color = {
      200,
      200,
      200
    }
  },
  [16] = {
    id = 16,
    prof = 143,
    carriagePos = "B2",
    prof_color = {
      200,
      200,
      200
    }
  }
}
FunctionNewCreateRole.MountInfoToCarriagePos = {
  "B2",
  "B1",
  "A1",
  "A2",
  "D1",
  "D2",
  "C2",
  "C1",
  "C3"
}
local ON_SELECT_ACTION = "choose_turn"
local OFF_SELECT_ACTION = "choose_turn2"
local RANDOM_IDLE_ACTION = "choose_playshow"
local ON_SELECT_ACTION_END = "choose_wait2"
local OFF_SELECT_ACTION_END = "choose_wait"
local OFF_SELECT_ACTION_INVISIBLE = "choose_close"
local randomWaitTime = 10
local randomCooldownTime = 5
local characterMapRandomActionStatus = {}
local resetModel

function FunctionNewCreateRole.Me()
  if nil == FunctionNewCreateRole.me then
    FunctionNewCreateRole.me = FunctionNewCreateRole.new()
  end
  return FunctionNewCreateRole.me
end

function FunctionNewCreateRole.SetRoleVisibility(role, visibility)
  if nil == role then
    return
  end
  if visibility then
    FunctionNewCreateRole.RoleModelPlayAction(role, OFF_SELECT_ACTION_END)
  else
    FunctionNewCreateRole.RoleModelPlayAction(role, OFF_SELECT_ACTION_INVISIBLE)
  end
  role:SetInvisible(not visibility)
end

function FunctionNewCreateRole:ctor()
  self.characterMap = {}
  self.ProfConfigProfIdx = {}
  for k, v in pairs(self.ProfConfig) do
    self.ProfConfigProfIdx[v.prof] = k
  end
  if not self.AnimCtrl then
    self.AnimCtrl = NewCreateRoleAnimationCtrlV3.new()
  end
  self:Reset()
  self.clickSound = false
  self.isFadeAnim = false
  self.modelLoadCount = 0
  self.modelTotalCount = 0
end

function FunctionNewCreateRole:Reset()
  self.running = false
  self:ResetLocalCustomStash()
  self.phase = nil
  TableUtility.TableClear(self.characterMap)
end

function FunctionNewCreateRole:ClearAnimationModel()
  self.currentSelectRoleModel = nil
  resetModel = nil
end

function FunctionNewCreateRole:CurrentModelRedressHair(hair)
  if self.currentSelectRoleModel then
    local idx = self.ProfConfigProfIdx[self.currentSelectProf]
    local hairlist = self.currentSelectGender == EGENDER.EGENDER_MALE and self.ProfConfig[idx].hair_list_m or self.ProfConfig[idx].hair_list_f
    self.currentSelectRoleModel:RedressPart(Asset_Role.PartIndex.Hair, hairlist[hair])
  end
end

function FunctionNewCreateRole:CurrentModelRedressHairColor(haircolor)
  if self.currentSelectRoleModel then
    local idx = self.ProfConfigProfIdx[self.currentSelectProf]
    local haircolorlist = self.ProfConfig[idx].haircolor_list
    self.currentSelectRoleModel:SetHairColor(haircolorlist[haircolor])
  end
end

function FunctionNewCreateRole:SwitchRoleShowInSamePoint(prof)
  local gender, hair, haircolor = self:GetLocalCustomStash(prof)
  self:SelectShowProfRoleModel(prof, gender)
  self:CurrentModelRedressHair(hair)
  self:CurrentModelRedressHairColor(haircolor)
end

function FunctionNewCreateRole:SwitchGender(prof, gender)
  self:StashGender(prof, gender)
  local gender, hair, haircolor = self:GetLocalCustomStash(prof)
  self:SelectShowProfRoleModel(prof, gender, true)
  self:CurrentModelRedressHair(hair)
  self:CurrentModelRedressHairColor(haircolor)
  self:ShowSelectCurrentRoleModel()
end

function FunctionNewCreateRole:SwitchHair(prof, gender, hair, dontChangeModel)
  self:StashHair(prof, gender, hair)
  if dontChangeModel then
    return
  end
  local gender, hair, haircolor = self:GetLocalCustomStash(prof)
  self:SelectShowProfRoleModel(prof, gender)
  self:CurrentModelRedressHair(hair)
  self:CurrentModelRedressHairColor(haircolor)
end

function FunctionNewCreateRole:SwitchHairColor(prof, gender, haircolor, dontChangeModel)
  self:StashHairColor(prof, gender, haircolor)
  if dontChangeModel then
    return
  end
  local gender, hair, haircolor = self:GetLocalCustomStash(prof)
  self:SelectShowProfRoleModel(prof, gender)
  self:CurrentModelRedressHair(hair)
  self:CurrentModelRedressHairColor(haircolor)
end

function FunctionNewCreateRole:GetStashGender(prof)
  return self.LocalCustomStash[prof].gender
end

function FunctionNewCreateRole:GetStashHair(prof, gender)
  return self.LocalCustomStash[prof].gendercfg[gender].hair
end

function FunctionNewCreateRole:GetStashHairColor(prof, gender)
  return self.LocalCustomStash[prof].gendercfg[gender].haircolor
end

function FunctionNewCreateRole:GetHairList(id, gender)
  local pcfg = self.ProfConfig[id]
  if not pcfg then
    return
  end
  return gender == ProtoCommon_pb.EGENDER_MALE and pcfg.hair_list_m or pcfg.hair_list_f
end

function FunctionNewCreateRole:GetHairColorList(id, gender)
  local pcfg = self.ProfConfig[id]
  if not pcfg then
    return
  end
  return pcfg.haircolor_list
end

function FunctionNewCreateRole:StashGender(prof, gender)
  self.LocalCustomStash[prof].gender = gender
end

function FunctionNewCreateRole:StashHair(prof, gender, hair)
  self.LocalCustomStash[prof].gendercfg[gender].hair = hair
end

function FunctionNewCreateRole:StashHairColor(prof, gender, haircolor)
  self.LocalCustomStash[prof].gendercfg[gender].haircolor = haircolor
end

function FunctionNewCreateRole:GetLocalCustomStash(prof)
  if not self.LocalCustomStash[prof] then
    return nil, nil, nil
  end
  local cfg = self.LocalCustomStash[prof]
  local gcfg = cfg.gendercfg[cfg.gender]
  return cfg.gender, gcfg.hair, gcfg.haircolor
end

function FunctionNewCreateRole:ResetLocalCustomStash()
  if not self.LocalCustomStash then
    self.LocalCustomStash = {}
  end
  local pcfg
  for i = 1, #self.ProfConfig do
    pcfg = self.ProfConfig[i]
    local cfg = {}
    cfg.gender = pcfg.gender
    cfg.gendercfg = {}
    if pcfg.maleID then
      local h = {}
      local cfgFromNpc = Table_Npc and Table_Npc[pcfg.maleID]
      local hairFromNpc = cfgFromNpc and cfgFromNpc.Hair or 0
      local haircolorFromNpc = cfgFromNpc and cfgFromNpc.HeadDefaultColor or 0
      h.haircolor = pcfg.haircolor_list and TableUtility.ArrayFindIndex(pcfg.haircolor_list, haircolorFromNpc) or 0
      h.hair = pcfg.hair_list_m and TableUtility.ArrayFindIndex(pcfg.hair_list_m, hairFromNpc) or 0
      cfg.gendercfg[ProtoCommon_pb.EGENDER_MALE] = h
    end
    if pcfg.femaleID then
      local h = {}
      local cfgFromNpc = Table_Npc and Table_Npc[pcfg.femaleID]
      local hairFromNpc = cfgFromNpc and cfgFromNpc.Hair or 0
      local haircolorFromNpc = cfgFromNpc and cfgFromNpc.HeadDefaultColor or 0
      h.haircolor = pcfg.haircolor_list and TableUtility.ArrayFindIndex(pcfg.haircolor_list, haircolorFromNpc) or 0
      h.hair = pcfg.hair_list_f and TableUtility.ArrayFindIndex(pcfg.hair_list_f, hairFromNpc) or 0
      cfg.gendercfg[ProtoCommon_pb.EGENDER_FEMALE] = h
    end
    self.LocalCustomStash[pcfg.prof] = cfg
  end
end

local tempAssetRoleMap = {}

function FunctionNewCreateRole:InitCharacterMap()
  local GameObjectType = Game.GameObjectType
  local gameObjectManagers = Game.GameObjectManagers
  local localNPCManager = gameObjectManagers[GameObjectType.LocalNPC]
  for k, v in pairs(localNPCManager.npcs) do
    tempAssetRoleMap[v:GetNPCID()] = v.assetRole or v
  end
  for k, v in ipairs(self.ProfConfig) do
    local characterInfo = {}
    characterInfo.maleRole = tempAssetRoleMap[v.maleID]
    characterInfo.femaleRole = tempAssetRoleMap[v.femaleID]
    if nil ~= v.petID then
      characterInfo.petRole = tempAssetRoleMap[v.petID]
    end
    characterInfo.prof = v.prof
    characterInfo.EP = v.MountInfo
    characterInfo.semiPos = self.MountInfoToCarriagePos[v.MountInfo]
    characterInfo.randomActionTimer = 0
    characterInfo.randomActionPhase = 0
    self.characterMap[v.prof] = characterInfo
  end
  self:ProcessDeferredNpcRole()
end

local deferredLoadOrder_SemiPos = {
  "A1",
  "A2",
  "B2",
  "C1",
  "C3",
  "C2",
  "B1",
  "D1",
  "D2"
}

function FunctionNewCreateRole:ProcessDeferredNpcRole()
  local occupiedEP, pcfg, k, cinfo = {}
  local dict1st, dict2nd, list3rd = {}, {}, {}
  local defaultShowSortedConfig = {}
  for i = 1, #self.ProfConfig do
    pcfg = self.ProfConfig[i]
    if pcfg.default_show == 1 then
      TableUtility.ArrayPushBack(defaultShowSortedConfig, pcfg)
    end
  end
  for i = 1, #self.ProfConfig do
    pcfg = self.ProfConfig[i]
    if pcfg.default_show ~= 1 then
      TableUtility.ArrayPushBack(defaultShowSortedConfig, pcfg)
    end
  end
  for i = 1, #defaultShowSortedConfig do
    pcfg = defaultShowSortedConfig[i]
    k = pcfg.prof
    cinfo = self.characterMap[k]
    if TableUtility.ArrayFindIndex(occupiedEP, cinfo.EP) > 0 then
      if cinfo.maleRole then
        if cinfo.maleRole.deferred then
          TableUtility.ArrayPushBack(list3rd, cinfo.maleRole)
        else
          FunctionNewCreateRole.SetRoleVisibility(cinfo.maleRole, false)
        end
      end
      if cinfo.femaleRole then
        if cinfo.femaleRole.deferred then
          TableUtility.ArrayPushBack(list3rd, cinfo.femaleRole)
        else
          FunctionNewCreateRole.SetRoleVisibility(cinfo.femaleRole, false)
        end
      end
    else
      TableUtility.ArrayPushBack(occupiedEP, cinfo.EP)
      if pcfg.gender == ProtoCommon_pb.EGENDER_MALE then
        if cinfo.maleRole and cinfo.maleRole.deferred then
          dict1st[cinfo.semiPos] = cinfo.maleRole
        end
        if cinfo.femaleRole then
          if cinfo.femaleRole.deferred then
            dict2nd[cinfo.semiPos] = cinfo.femaleRole
          else
            FunctionNewCreateRole.SetRoleVisibility(cinfo.femaleRole, false)
          end
        end
      else
        if cinfo.femaleRole and cinfo.femaleRole.deferred then
          dict1st[cinfo.semiPos] = cinfo.femaleRole
        end
        if cinfo.maleRole then
          if cinfo.maleRole.deferred then
            dict2nd[cinfo.semiPos] = cinfo.maleRole
          else
            FunctionNewCreateRole.SetRoleVisibility(cinfo.maleRole, false)
          end
        end
      end
    end
  end
  self.modelDict1Count = TableUtility.Count(dict1st)
  self.modelTotalCount = self.modelDict1Count + TableUtility.Count(dict2nd) + TableUtility.Count(list3rd)
  for i = 1, #deferredLoadOrder_SemiPos do
    dict1st[deferredLoadOrder_SemiPos[i]]:RealDoConstruct(nil, function()
      self.modelLoadCount = self.modelLoadCount + 1
    end)
  end
  for i = 1, #deferredLoadOrder_SemiPos do
    cinfo = dict2nd[deferredLoadOrder_SemiPos[i]]
    if cinfo then
      cinfo:RealDoConstruct(false, function()
        self.modelLoadCount = self.modelLoadCount + 1
      end)
    end
  end
  for i = 1, #list3rd do
    list3rd[i]:RealDoConstruct(false, function()
      self.modelLoadCount = self.modelLoadCount + 1
    end)
  end
  for _, v in pairs(self.characterMap) do
    if v.maleRole and v.maleRole.deferred ~= nil then
      v.maleRole = v.maleRole.assetRole
    end
    if v.femaleRole and v.femaleRole.deferred ~= nil then
      v.femaleRole = v.femaleRole.assetRole
    end
  end
end

FunctionNewCreateRole.currentSelectRoleModel = nil
FunctionNewCreateRole.currentSelectProf = nil
FunctionNewCreateRole.currentSelectGender = nil

function FunctionNewCreateRole:SelectShowProfRoleModel(prof, gender, showSwitchEffect)
  local sameProfGender = self.currentSelectProf == prof and self.currentSelectGender == gender
  if self.currentSelectRoleModel ~= nil and (self.currentSelectProf ~= prof or self.currentSelectGender ~= gender) then
    if showSwitchEffect then
      FunctionNewCreateRole.Me():ResetSelectCurrentRoleModelEnd()
    else
      self.RoleModelPlayAction(self.currentSelectRoleModel, OFF_SELECT_ACTION, true, function()
        FunctionNewCreateRole.Me():ResetSelectCurrentRoleModelEnd()
      end)
    end
  end
  self.currentSelectProf = prof
  self.currentSelectGender = gender
  if self.currentSelectProf == nil or self.currentSelectGender == nil then
    return
  end
  local cinfo = self.characterMap[prof]
  if not cinfo then
    return
  end
  self.currentSelectRoleModel = gender == ProtoCommon_pb.EGENDER_MALE and cinfo.maleRole or cinfo.femaleRole
  if not self.currentSelectRoleModel then
    return
  end
  if sameProfGender then
    return
  end
  FunctionNewCreateRole.SetRoleVisibility(self.currentSelectRoleModel, true)
  FunctionNewCreateRole.ClearModelActionStatus(prof)
  if showSwitchEffect then
    self:PlaySwitchRoleModelEffect()
  end
  self:HandleOthersVisibility()
end

function FunctionNewCreateRole:ShowSelectCurrentRoleModel()
  if self.currentSelectRoleModel ~= nil then
    resetModel = nil
    self.StopActionEventSE(self.currentSelectRoleModel)
    self.RoleModelPlayAction(self.currentSelectRoleModel, ON_SELECT_ACTION, true, function()
      FunctionNewCreateRole.Me():ShowSelectCurrentRoleModelEnd()
    end)
  end
end

function FunctionNewCreateRole:ShowSelectCurrentRoleModelEnd()
  if self.currentSelectRoleModel ~= nil then
    self.RoleModelPlayAction(self.currentSelectRoleModel, ON_SELECT_ACTION_END)
  end
end

function FunctionNewCreateRole:ResetSelectCurrentRoleModel()
  if self.currentSelectRoleModel ~= nil then
    resetModel = self.currentSelectRoleModel
    self.StopActionEventSE(self.currentSelectRoleModel)
    self.RoleModelPlayAction(self.currentSelectRoleModel, OFF_SELECT_ACTION, true, function()
      FunctionNewCreateRole.Me():ResetSelectCurrentRoleModelEnd()
    end)
    self.currentSelectRoleModel = nil
  end
end

function FunctionNewCreateRole:ResetSelectCurrentRoleModelEnd()
  if resetModel ~= nil then
    self.RoleModelPlayAction(resetModel, OFF_SELECT_ACTION_END, true, function()
      resetModel = nil
    end)
  end
end

local switchEffect = "Skill/Eff_choose_turn_qianhuan"

function FunctionNewCreateRole:PlaySwitchRoleModelEffect()
  if not self.currentSelectRoleModel then
    return
  end
  local effect = Asset_Effect.PlayOneShotOn(switchEffect, self.currentSelectRoleModel.completeTransform.parent.parent)
  effect:ResetLocalPosition(LuaGeometry.Const_V3_zero)
end

function FunctionNewCreateRole:HandleOthersVisibility()
  local curEP = self.characterMap[self.currentSelectProf].EP
  for k, v in pairs(self.characterMap) do
    if v.EP == curEP then
      if k ~= self.currentSelectProf then
        FunctionNewCreateRole.SetRoleVisibility(v.femaleRole, false)
        FunctionNewCreateRole.SetRoleVisibility(v.maleRole, false)
      elseif self.currentSelectGender == ProtoCommon_pb.EGENDER_MALE then
        FunctionNewCreateRole.SetRoleVisibility(v.femaleRole, false)
      else
        FunctionNewCreateRole.SetRoleVisibility(v.maleRole, false)
      end
    end
  end
end

function FunctionNewCreateRole.RoleModelPlayAction(roleModel, action, reset, callBack)
  if not roleModel then
    return
  end
  reset = reset or true
  local params = Asset_Role.GetPlayActionParams(action)
  params[6] = reset
  params[7] = callBack
  roleModel:PlayAction(params)
end

function FunctionNewCreateRole.StopActionEventSE(roleModel)
  if roleModel and roleModel.completeTransform then
    local audioSources = roleModel.completeTransform:GetComponentsInChildren(AudioSource)
    for i = 1, #audioSources do
      audioSources[i]:Stop()
    end
  end
end

function FunctionNewCreateRole:Launch()
  characterMapRandomActionStatus = {}
  self.AnimCtrl:Init("NewCreateRoleCameraPoints")
  self.AnimCtrl:OnStart()
  Game.AssetManager_Role.SetLoadInterval(0)
  Game.GUISystemManager:AddMonoUpdateFunction(self.MonoUpdate, self)
  self:Notify(FunctionNewCreateRoleEvent.Enter)
  self:InitCharacterMap()
end

function FunctionNewCreateRole:Shutdown()
  self.AnimCtrl:OnDestroy()
  Game.GUISystemManager:ClearMonoUpdateFunction(self)
  characterMapRandomActionStatus = nil
  Game.AssetManager_Role.ResetLoadInterval()
  self.modelLoadCanOperation = nil
  self.modelLoadComplete = nil
end

function FunctionNewCreateRole:Notify(event, data)
  if nil == GameFacade then
    return
  end
  GameFacade.Instance:sendNotification(event, data)
end

function FunctionNewCreateRole:SetAnimDestPoint(point)
  point = FunctionNewCreateRole.MountInfoToCarriagePos[point]
  self.AnimCtrl:SetDesPoint(point)
end

function FunctionNewCreateRole:SetAnimDestPointToOri()
  self.AnimCtrl:SetDesPointToOri()
end

function FunctionNewCreateRole:MonoUpdate(time, deltaTime)
  self:UpdateRandomAction(time, deltaTime)
  if not self.modelLoadCanOperation and self:ModelLoadCanOperation() then
    self.modelLoadCanOperation = true
    Game.AssetManager_Role.ResetLoadInterval()
    self:Notify(FunctionNewCreateRoleEvent.ModelLoadCanOperation)
  end
  if not self.modelLoadComplete and self:ModelLoadComplete() then
    self.modelLoadComplete = true
    Game.AssetManager_Role.ResetLoadInterval()
  end
end

function FunctionNewCreateRole:UpdateRandomAction(time, deltaTime)
  if not self.currentSelectProf or not self.characterMap[self.currentSelectProf] then
    return
  end
  local curEP = self.currentSelectProf and self.characterMap[self.currentSelectProf].EP
  for k, v in pairs(self.characterMap) do
    if not characterMapRandomActionStatus[k] then
      characterMapRandomActionStatus[k] = {}
      characterMapRandomActionStatus[k].randomActionTimer = 0
      characterMapRandomActionStatus[k].randomActionPhase = 0
    end
    local stat = characterMapRandomActionStatus[k]
    if v.EP == curEP then
      if k ~= self.currentSelectProf then
        FunctionNewCreateRole.ClearModelActionStatus(k)
      elseif self.currentSelectGender ~= stat.gender then
        FunctionNewCreateRole.ClearModelActionStatus(k)
        local model = self.currentSelectGender == ProtoCommon_pb.EGENDER_MALE and v.maleRole or v.femaleRole
        FunctionNewCreateRole.SetModelActionParam(k, self.currentSelectGender, model)
      end
    elseif stat.randomActionPhase == 0 then
      local isMale = v.maleRole and not v.maleRole:GetInvisible()
      local isFemale = v.femaleRole and not v.femaleRole:GetInvisible()
      local gender = not (not isMale or isFemale) and ProtoCommon_pb.EGENDER_MALE or ProtoCommon_pb.EGENDER_FEMALE
      local model = isMale and v.maleRole or v.femaleRole
      FunctionNewCreateRole.SetModelActionParam(k, gender, model)
      FunctionNewCreateRole.StartModelActionStatus(k)
    end
  end
  for k, _ in pairs(characterMapRandomActionStatus) do
    FunctionNewCreateRole.UpdateModelActionStatus(k, deltaTime, self.currentSelectRoleModel)
  end
end

function FunctionNewCreateRole.UpdateModelActionStatus(prof, deltaTime, currentModel)
  if not characterMapRandomActionStatus[prof] then
    characterMapRandomActionStatus[prof] = {}
    characterMapRandomActionStatus[prof].randomActionTimer = 0
    characterMapRandomActionStatus[prof].randomActionPhase = 0
    return
  end
  local stat = characterMapRandomActionStatus[prof]
  if stat.randomActionPhase == 0 or stat.roleModel == nil or stat.roleModel == resetModel then
    return
  end
  if stat.randomActionPhase == 1 then
    stat.randomActionTimer = stat.randomActionTimer - deltaTime
    if stat.randomActionTimer < 0 then
      stat.randomActionTimer = 0
      stat.randomActionPhase = 2
      FunctionNewCreateRole.RoleModelPlayAction(stat.roleModel, RANDOM_IDLE_ACTION)
    end
  elseif stat.randomActionPhase == 2 then
    if FunctionNewCreateRole.IsModelRandomActionEnd(stat) and stat.roleModel ~= currentModel then
      stat.isModelRandomActionEnd = nil
      FunctionNewCreateRole.RoleModelPlayAction(stat.roleModel, OFF_SELECT_ACTION_END, nil, function()
        stat.isModelRandomActionEnd = true
      end)
      stat.randomActionTimer = randomCooldownTime
      stat.randomActionPhase = 3
    end
  elseif stat.randomActionPhase == 3 then
    stat.randomActionTimer = stat.randomActionTimer - deltaTime
    if stat.randomActionTimer < 0 then
      stat.randomActionTimer = math.random(randomWaitTime)
      stat.randomActionPhase = 1
    end
  end
end

function FunctionNewCreateRole.SetModelActionParam(prof, gender, model)
  if not characterMapRandomActionStatus[prof] then
    characterMapRandomActionStatus[prof] = {}
  end
  local stat = characterMapRandomActionStatus[prof]
  stat.gender = gender
  stat.roleModel = model
end

function FunctionNewCreateRole.StartModelActionStatus(prof)
  if not characterMapRandomActionStatus[prof] then
    characterMapRandomActionStatus[prof] = {}
  end
  local stat = characterMapRandomActionStatus[prof]
  stat.randomActionTimer = math.random(randomWaitTime)
  stat.randomActionPhase = 1
end

function FunctionNewCreateRole.ClearModelActionStatus(prof)
  if not characterMapRandomActionStatus[prof] then
    characterMapRandomActionStatus[prof] = {}
    characterMapRandomActionStatus[prof].randomActionTimer = 0
    characterMapRandomActionStatus[prof].randomActionPhase = 0
    return
  end
  local stat = characterMapRandomActionStatus[prof]
  stat.randomActionTimer = 0
  stat.randomActionPhase = 0
  stat.roleModel = nil
  stat.roleAC = nil
end

function FunctionNewCreateRole:ClearInitStatus()
  self.clickSound = false
  self.isFadeAnim = false
  self.modelLoadCount = 0
  self.modelTotalCount = 0
end

function FunctionNewCreateRole.IsModelRandomActionEnd(stat)
  if not stat.roleModel then
    return true
  end
  return stat.isModelRandomActionEnd
end

function FunctionNewCreateRole:ModelLoadCanOperation()
  return self.modelLoadCount >= self.modelDict1Count
end

function FunctionNewCreateRole:ModelLoadComplete()
  return self.modelLoadCount >= self.modelTotalCount
end
