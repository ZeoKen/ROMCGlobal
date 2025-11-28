CDProxy = class("CDProxy", pm.Proxy)
CDProxy.Instance = nil
CDProxy.NAME = "CDProxy"
CDProxy.CommunalSkillCDID = -1000
CDProxy.CommunalSkillCDSortID = -1
local ClientSkillErrorCD = 0
local CDType = {
  Skill = SceneUser2_pb.CD_TYPE_SKILL,
  Item = SceneUser2_pb.CD_TYPE_ITEM,
  SkillDelay = SceneUser2_pb.CD_TYPE_SKILLDEALY,
  ItemGroup = SceneUser2_pb.CD_TYPE_ITEMGROUP,
  TrainAction = SceneUser2_pb.CD_TYPE_TRAINACTION
}

function CDProxy:ctor(proxyName, data)
  self.proxyName = proxyName or CDProxy.NAME
  if CDProxy.Instance == nil then
    CDProxy.Instance = self
  end
  self:Init()
end

function CDProxy:Init()
  self.cdMap = {}
  self.timeStampMap = {}
  FunctionCDCommand.Me()
end

function CDProxy:Update()
end

function CDProxy:GetCDMapByType(cdType)
  local map = self.cdMap[cdType]
  if map == nil then
    map = {}
    self.cdMap[cdType] = map
  end
  return map
end

function CDProxy:AddCD(cdType, id, time)
  local nowtime = ServerTime.CurServerTime()
  local cd = (time - nowtime) / 1000
  local map = self:GetCDMapByType(cdType)
  local data = map[id]
  local needRefresh = false
  if data then
    if data.cd and data.cd == 0 then
      data.cd = cd
    end
    if time < data.time then
      data.cd = math.floor((time - ServerTime.ServerTime) / 1000)
      needRefresh = true
    end
    data:SetTime(time)
  else
    local cdMax
    if cdType == CDType.Item then
      cdMax = DungeonProxy.GetRoguelikeItemCdTime(id) or Table_UseItem[id] and Table_UseItem[id].CDTime
    end
    data = CdData.new(time, cd, cdMax)
    map[id] = data
  end
  return data, needRefresh
end

local updateLeftCDTimes = function(sortID, cdData)
  local skill = SkillProxy.Instance:GetLearnedSkillBySortID(sortID)
  if not skill then
    return
  end
  local maxTimes = skill:GetMaxCDTimes(Game.Myself) or 0
  local leftTimes = skill:GetLeftCDTimes() or 0
  if maxTimes > leftTimes then
    SkillProxy.Instance:AddLeftCDTimes(sortID)
    cdData:SetCdCount(maxTimes - (leftTimes + 1))
    GameFacade.Instance:sendNotification(SkillEvent.SkillStartEvent)
  end
end

function CDProxy:Server_AddSkillCD(id, time, isall, coldtime, leftTimes, maxtimes, is_tobreak_skill)
  local sortID = math.floor(id / 1000)
  if time == 0 then
    self:RemoveSkillCD(sortID)
    if is_tobreak_skill then
      GameFacade.Instance:sendNotification(SkillEvent.BreakSkillEffect, sortID)
    end
    if SkillProxy.Instance:UpdateSkillLeftCD(sortID, leftTimes, true) then
      GameFacade.Instance:sendNotification(SkillEvent.SkillStartEvent)
    end
    return false
  end
  local map = self:GetCDMapByType(CDType.Skill)
  local data = map[sortID]
  if isall and data then
    return false
  end
  local needRefresh
  local _SkillProxy = SkillProxy.Instance
  local skill = _SkillProxy:GetLearnedSkillBySortID(sortID)
  local staticData = skill and skill.staticData or Table_Skill[id]
  local totalCD
  if staticData then
    local logicParam = staticData.Logic_Param
    if logicParam and logicParam.CdTimes then
      local cdMax = SkillInfo.GetSkillCD(Game.Myself, true, staticData)
      local cd = (time - ServerTime.ServerTime) / 1000
      if cd < 0 then
        if leftTimes < logicParam.CdTimes then
          cd = cd + cdMax
          totalCD = cd
        end
        if data then
          self:AddSkillCD(sortID, time, nil, nil, true, coldtime)
          data:SetCdCountCall(updateLeftCDTimes, sortID)
          data.cd = cd
        end
        SkillProxy.Instance:UpdateSkillLeftCD(sortID, leftTimes)
      else
        totalCD = cd
        cd = cd % cdMax
        local cdCount = math.ceil(cd / cdMax)
        local maxTimes = skill:GetMaxCDTimes(Game.Myself) or 0
        SkillProxy.Instance:UpdateSkillLeftCD(sortID, maxTimes - cdCount)
      end
      if 0.01 < cd then
        if not data then
          data, needRefresh = self:AddSkillCD(sortID, nil, cd, cdMax, true, coldtime)
        end
        data:SetCdCount(1)
        data.cd = cd
        data:SetCdCountCall(updateLeftCDTimes, sortID)
      end
      if data and totalCD then
        data.totalCD = totalCD
      end
      return true
    end
  end
  if not self:IsInCD(CDType.Skill, sortID) then
    if staticData then
      local cdMax = SkillInfo.GetSkillCD(Game.Myself, true, staticData)
      data, needRefresh = self:AddSkillCD(sortID, time, nil, cdMax, true, coldtime)
    else
      data, needRefresh = self:AddSkillCD(sortID, time, nil, nil, true, coldtime)
    end
    return needRefresh
  end
  data, needRefresh = self:AddSkillCD(sortID, time, nil, nil, true, coldtime)
  needRefresh = needRefresh or maxtimes and 0 < maxtimes
  return needRefresh
end

function CDProxy:Client_AddSkillCD(id, time, cd, cdMax)
  local sortID = id // 1000
  local skillData = SkillProxy.Instance:GetLearnedSkillBySortID(sortID)
  local maxTimes = skillData and skillData:GetMaxCDTimes(Game.Myself)
  if maxTimes and 1 < maxTimes then
    local leftTimes = skillData:GetLeftCDTimes() or 0
    local cdCount = math.max(maxTimes - leftTimes, 0)
    local cdData = self:GetSkillInCD(sortID)
    if not cdData then
      cdData = self:AddSkillCD(sortID, time, cd, cdMax)
      cdData:SetCdCountCall(updateLeftCDTimes, sortID)
    end
    cdData:SetCdCount(cdCount)
    return cdData
  end
  return self:AddSkillCD(sortID, time, cd, cdMax)
end

function CDProxy:AddSkillCD(sortID, time, cd, cdMax, isFromServer, coldtime)
  local needRefresh = false
  local serverTime = ServerTime.ServerTime
  local map = self:GetCDMapByType(CDType.Skill)
  local data = map[sortID]
  if data then
    if isFromServer then
      if 0 < time and time < data.time or data.time == 0 then
        needRefresh = true
        cd = (time - serverTime) / 1000
      else
        needRefresh = false
      end
    else
      needRefresh = true
    end
    if needRefresh then
      data.cd = cd + ClientSkillErrorCD
      if cdMax then
        data.cdMax = math.max(cdMax, data.cdMax) + ClientSkillErrorCD
      end
    end
    data:SetTime(time)
    if coldtime and 0 < coldtime then
      data.cd = math.floor((time - coldtime) / 1000)
      data:SetColdTime(coldtime)
    end
  else
    needRefresh = true
    if not cd and time and 0 < time then
      cd = (time - serverTime) / 1000
    end
    cdMax = cdMax or cd
    data = SkillCdData.new(time, cd + ClientSkillErrorCD, cdMax + ClientSkillErrorCD)
    map[sortID] = data
  end
  self.timeStampMap[sortID] = serverTime
  return data, needRefresh
end

function CDProxy:Server_AddSkillDelayCD(id, time)
  if time ~= 0 then
    return
  end
  id = id // 1000
  local cd = (time - ServerTime.ServerTime) / 1000
  local map = self:GetCDMapByType(CDType.SkillDelay)
  local data = map[id]
  if data then
    if data.cd == 0 or time < data.time then
      data.cd = cd
    end
    data:SetTime(time)
  else
    map[id] = CdData.new(time, cd, cd)
  end
end

function CDProxy:Client_AddSkillDelayCD(id, time, cd, cdMax)
  local sort = math.floor(id / 1000)
  local data = self:GetSkillInCD(sort)
  if data ~= nil then
    local value = math.max(data.cd, cdMax)
    data.cd = value + ClientSkillErrorCD
    data.cdMax = value + ClientSkillErrorCD
    self:ClearSkillDelayCD()
    return
  end
  self:AddSkillCD(sort, time, cd, cdMax)
end

function CDProxy:RemoveCD(cdType, id)
  if cdType == CDType.Skill then
    self:RemoveSkillCD(id)
    return
  end
  local map = self:GetCDMapByType(cdType)
  map[id] = nil
end

function CDProxy:RemoveSkillCD(id)
  local map = self.cdMap[CDType.Skill]
  local cdData = map[id]
  if cdData then
    cdData:SetCdCount(0)
    if cdData:TryEnd() then
      map[id] = nil
    end
  end
end

function CDProxy:RemoveItemCD(id)
  self:RemoveCD(CDType.Item, id)
end

function CDProxy:RemoveItemGroupCD(groupid)
  self:RemoveCD(CDType.ItemGroup, groupid)
end

function CDProxy:ClearSkillCD()
  local map = self.cdMap[CDType.Skill]
  if map ~= nil then
    TableUtility.TableClear(map)
  end
end

function CDProxy:ClearSkillDelayCD()
  local map = self.cdMap[CDType.SkillDelay]
  if map ~= nil then
    TableUtility.TableClear(map)
  end
end

function CDProxy:UpdateCDData(skillitemdata)
  local cdData = self:GetSkillInCD(skillitemdata.sortID)
  if cdData ~= nil then
    local time = cdData.time
    if time and 0 < time then
      self:Client_AddSkillCD(skillitemdata.id, time, math.floor((time - ServerTime.ServerTime) / 1000), skillitemdata.staticData.CD)
      GameFacade.Instance:sendNotification(SkillEvent.SkillStartEvent)
    end
  end
end

function CDProxy:IsInCD(cdType, id)
  local map = self:GetCDMapByType(cdType)
  local data = map[id]
  if data == nil then
    return false
  else
    return data:GetCd() > 0
  end
end

function CDProxy:SkillIsInCD(id)
  if self:IsInCD(CDType.Skill, id) then
    return true
  end
  return self:SkillInCommualCD(id)
end

function CDProxy:SkillInCommualCD(id)
  local skillInfo = Game.LogicManager_Skill:GetSkillInfo(id * 1000 + 1)
  if skillInfo and skillInfo:IsKnightSkill() then
    return false
  end
  local data = self:GetCD(CDType.SkillDelay, id)
  if data ~= nil then
    return data:GetCd() > 0
  else
    return self:IsInCD(CDType.Skill, CDProxy.CommunalSkillCDSortID)
  end
end

function CDProxy:ItemIsInCD(id)
  return self:IsInCD(CDType.Item, id)
end

function CDProxy:GetCD(cdType, id)
  local map = self:GetCDMapByType(cdType)
  return map[id]
end

function CDProxy:GetSkillInCD(id)
  return self:GetCD(CDType.Skill, id)
end

function CDProxy:GetSkillDelayInCD(id)
  return self:GetCD(CDType.SkillDelay, id)
end

function CDProxy:HasItemInCD()
  local map = self:GetCDMapByType(CDType.Item)
  if map and next(map) then
    return true
  end
  map = self:GetCDMapByType(CDType.ItemGroup or 3)
  if map and next(map) then
    return true
  end
  return false
end

function CDProxy:GetItemInCD(id)
  return self:GetCD(CDType.Item, id)
end

function CDProxy:GetItemGroupInCD(id)
  return self:GetCD(CDType.ItemGroup or 3, id)
end

function CDProxy:GetSkillItemDataCD(skillitemdata)
  if skillitemdata == nil or not skillitemdata.staticData then
    return 0, 1, 0
  end
  if skillitemdata:GetID() == Game.Myself.data:GetAttackSkillIDAndLevel() then
    return 0, 1, 0
  end
  local cdData, sortID
  local replaceID = skillitemdata:GetReplaceID()
  if replaceID and 0 < replaceID then
    cdData = self:GetSkillInCD(replaceID // 1000)
    if cdData then
      sortID = replaceID // 1000
    else
      local replacedata = Table_Skill[replaceID]
      if replacedata and replacedata.Logic_Param.useSelfCD then
        return 0, 1, 0
      end
    end
  end
  if not sortID then
    sortID = skillitemdata.sortID
    cdData = self:GetSkillInCD(sortID)
  end
  local cd = cdData and cdData:GetCd() or 0
  local cdCount = cdData and cdData:GetCdCount() or 0
  local comCdData = self:GetSkillDelayInCD(sortID) or self:GetSkillInCD(CDProxy.CommunalSkillCDSortID)
  local comCd = comCdData and comCdData:GetCd() or 0
  local staticData = skillitemdata.staticData
  local specialType = staticData.Logic_Param and staticData.Logic_Param.special_type
  if cd < comCd and 0 < comCd then
    if specialType and specialType == "knight" then
      return 0, 1, 0
    end
    return comCd, comCdData:GetCdMax(), cdCount
  end
  if cdData then
    return cd, cdData:GetCdMax(), cdCount
  end
  return 0, 1, cdCount
end

function CDProxy:GetTimeStampMapById(id)
  return self.timeStampMap[id]
end

function CDProxy:GetSkillPaused(skillitemdata)
  if not skillitemdata then
    return false
  end
  local sortID = skillitemdata:GetSortID()
  local cdData = self:GetSkillInCD(sortID)
  if not cdData then
    return false
  end
  local pausedTime = cdData:GetColdTime()
  if pausedTime <= 0 then
    return false
  end
  local nowtime = ServerTime.CurServerTime()
  return pausedTime > nowtime
end

function CDProxy:CheckAutoSkillFree()
  local hasSkillFree = false
  local shortCutAuto = ShortCutProxy.Instance:GetCurrentAuto()
  local skillList = SkillProxy.Instance:GetEquipedAutoSkillData(false, shortCutAuto)
  if skillList then
    for i = 1, #skillList do
      local sortID = skillList[i]:GetID() // 1000
      local map = self:GetCDMapByType(CDType.Skill)
      local data = map[sortID]
      if not self:IsInCD(CDType.Skill, sortID) then
        hasSkillFree = true
        break
      end
    end
  end
  return hasSkillFree
end

CdData = class("CdData")

function CdData:ctor(time, cd, cdMax, coldtime)
  self.time = time or 0
  self.cd = cd or 0
  self.cdMax = cdMax
  self.timeStamp = 0
  self.coldtime = coldtime or 0
end

function CdData:CalCd(delta)
  if self.cd == nil then
    self.cd = 0
  end
  self.cd = self.cd + delta
end

function CdData:SetTime(time)
  if time ~= nil then
    self.time = time
  end
end

function CdData:GetCd()
  return self.cd or 0
end

function CdData:GetCdMax()
  return self.cdMax or 1
end

SkillCdData = class("SkillCdData", CdData)

function SkillCdData:ctor(time, cd, cdMax)
  SkillCdData.super.ctor(self, time, cd, cdMax)
  self.timeStamp = ServerTime.ServerTime
end

function SkillCdData:CalCd(delta)
  if self.cd == nil then
    self.cd = 0
  end
  if (self:GetColdTime() or 0) >= ServerTime.CurServerTime() then
    return
  end
  self.cd = self.cd + delta
  if self.cdCount and 0 < self.cdCount and self.cd <= 0 then
    self.cdCount = self.cdCount - 1
    if self.call then
      self.call(self.callParam, self)
    end
    if 0 < self.cdCount and self.totalCD then
      if self.cdCount ~= math.ceil(self.totalCD / self.cdMax) then
        self.cd = self.cdMax
      else
        self.cd = self.totalCD % self.cdMax
      end
    end
  end
end

function SkillCdData:ResetTimeStamp(newTimeStamp)
  local delta = (newTimeStamp - self.timeStamp) / 1000
  self.cd = self.cd + delta
  self.timeStamp = newTimeStamp
end

function SkillCdData:SetCdCount(cdCount)
  self.cdCount = cdCount
end

function SkillCdData:SetCdCountCall(call, callParam)
  self.call = call
  self.callParam = callParam
end

function SkillCdData:GetCdCount()
  return self.cdCount or 0
end

function SkillCdData:SetColdTime(val)
  self.coldtime = val
end

function SkillCdData:GetColdTime()
  return self.coldtime
end

function SkillCdData:TryEnd()
  return self.cdCount == nil or self.cdCount == 0
end
