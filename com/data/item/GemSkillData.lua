local _ArrayPushBack = TableUtility.ArrayPushBack
local _TableClear = TableUtility.TableClear
local _ArrayClear = TableUtility.ArrayClear
local _ArrayFindByPredicate = TableUtility.ArrayFindByPredicate
GemSkillData = class("GemSkillData")

function GemSkillData:ctor(guid, skillData)
  self.itemGuid = guid or nil
  self.buffs = {}
  self.buffParamMap = {}
  self.buffParam2BuffIdMap = {}
  self.sculptures = {}
  self:SetData(skillData)
end

function GemSkillData:SetData(data)
  if type(data) ~= "table" or not next(data) then
    LogUtility.Warning("Cannot set GemAttrData when data is nil or non-table!")
    return
  end
  self.id = data.id
  self.pos = data.pos
  self.charId = data.charid or data.charId
  if data.issame ~= nil then
    self.isComGetEffectDescArrayposed = data.issame
  else
    self.isComposed = data.isComposed
  end
  if data.isforbid ~= nil then
    self.available = not data.isforbid
  else
    self.available = data.available
  end
  self.isFull = data.isfull
  _ArrayClear(self.buffs)
  _TableClear(self.buffParamMap)
  _TableClear(self.buffParam2BuffIdMap)
  for i = 1, #data.buffs do
    _ArrayPushBack(self.buffs, GemBuffData.new(data.buffs[i]))
  end
  for _, buff in pairs(self.buffs) do
    for paramId, paramValue in pairs(buff.paramMap) do
      self.buffParamMap[paramId] = paramValue
      self.buffParam2BuffIdMap[paramId] = buff.id
    end
  end
  TableUtility.ArrayClear(self.sculptures)
  local sculpt = data.carves or data.sculptures
  if sculpt then
    for i = 1, #sculpt do
      _ArrayPushBack(self.sculptures, GemSculptData.new(sculpt[i]))
    end
  end
  local staticData = Table_GemRate[data.id]
  self.effectStaticDatas = GemProxy.Instance:GetEffectStaticDatasOfSkillGem(self.id)
  self.quality = staticData and staticData.Quality
  self.needAttributeGemTypes = staticData and staticData.NeedGem
end

function GemSkillData:GetAddedHeroLvBuff()
  local addHeroLv = 0
  local sData, sBufferID
  for i = 1, #self.effectStaticDatas do
    sData = self.effectStaticDatas[i]
    sBufferID = sData.BufferID
    if not next(sData.ParamsID) then
      for i = 1, #self.buffs do
        if self.buffs[i].id == sBufferID then
          local addLv = Table_Buffer[sBufferID] and Table_Buffer[sBufferID].BuffEffect and Table_Buffer[sBufferID].BuffEffect.FeatureLevel
          if addLv then
            addHeroLv = addHeroLv + addLv
            break
          end
        end
      end
    end
  end
  return addHeroLv
end

local tempParamDescArr = {}

function GemSkillData:GetEffectDescArray(isWithInvalidEffect, useMax)
  local tempDescArr = {}
  local sData, paramId, paramValue, paramStaticData, paramDescFormat, paramDesc, foundBuff, desc
  for i = 1, #self.effectStaticDatas do
    sData = self.effectStaticDatas[i]
    if next(sData.ParamsID) then
      TableUtility.ArrayClear(tempParamDescArr)
      for j = 1, #sData.ParamsID do
        paramId = sData.ParamsID[j]
        paramValue = self.buffParamMap[paramId] or 0
        paramValue = paramValue / 1000
        if GemProxy.ToInteger(paramValue) then
          paramValue = GemProxy.ToInteger(paramValue)
        end
        paramStaticData = GemProxy.Instance:GetStaticDataOfSkillGemParam(paramId)
        if paramStaticData then
          paramDescFormat = paramStaticData.isPercent and ZhString.Gem_SkillEffectParamWithPercentFormat or ZhString.Gem_SkillEffectParamFormat
          paramDesc = string.format(paramDescFormat, useMax and paramStaticData.max or paramValue, paramStaticData.min, paramStaticData.max)
        else
          paramDesc = tostring(paramValue)
        end
        _ArrayPushBack(tempParamDescArr, paramDesc)
      end
      _ArrayPushBack(tempDescArr, string.format(sData.Desc, unpack(tempParamDescArr)))
    else
      foundBuff = _ArrayFindByPredicate(self.buffs, function(buff)
        return buff.id == sData.BufferID
      end)
      desc = nil
      if foundBuff then
        desc = sData.Desc
      elseif isWithInvalidEffect then
        desc = useMax and sData.Desc or string.format(ZhString.Gem_SkillEffectInvalidEffectFormat, sData.Desc)
      end
      if desc then
        _ArrayPushBack(tempDescArr, desc)
      end
    end
  end
  return tempDescArr
end

function GemSkillData:GetEffectDescData()
  local tempDescArr = {}
  local sData, paramId, paramValue, paramStaticData, paramDescFormat, paramDesc, foundBuff, desc, paramBuffID
  for i = 1, #self.effectStaticDatas do
    sData = self.effectStaticDatas[i]
    if next(sData.ParamsID) then
      _ArrayClear(tempParamDescArr)
      local maxStarSign = 0
      for j = 1, #sData.ParamsID do
        local minGoldValue
        paramId = sData.ParamsID[j]
        paramValue = self.buffParamMap[paramId] or 0
        paramBuffID = self.buffParam2BuffIdMap[paramId] or 0
        paramValue = paramValue / 1000
        if GemProxy.ToInteger(paramValue) then
          paramValue = GemProxy.ToInteger(paramValue)
        end
        paramStaticData = GemProxy.Instance:GetStaticDataOfSkillGemParam(paramId)
        if paramStaticData then
          if paramStaticData.list and next(paramStaticData.list) then
            if paramValue == paramStaticData.max then
              maxStarSign = paramStaticData.list[#paramStaticData.list].StarSign
            else
              for i = 1, #paramStaticData.list do
                local d = paramStaticData.list[i]
                if (paramValue >= d.Nor_Min and paramValue < d.Nor_Max or paramValue > d.Nor_Max and paramValue <= d.Nor_Min) and d.StarSign and maxStarSign < d.StarSign then
                  maxStarSign = d.StarSign
                end
                if d.StarSign == 2 and not minGoldValue then
                  minGoldValue = d.Nor_Min
                end
              end
            end
          end
          if minGoldValue and maxStarSign < 2 then
            local delta
            delta = minGoldValue - paramValue
            if paramStaticData.isPercent then
              paramDescFormat = 0 < delta and ZhString.Gem_SkillEffectParamWithPercentFormat_MinGoldValue or ZhString.Gem_SkillEffectParamWithPercentFormat_MinGoldValue_Minus
            else
              paramDescFormat = 0 < delta and ZhString.Gem_SkillEffectParamFormat_MinGoldValue or ZhString.Gem_SkillEffectParamFormat_MinGoldValue_Minus
            end
            paramDesc = string.format(paramDescFormat, paramValue, string.format("%.2f", math.abs(delta)), paramStaticData.min, paramStaticData.max)
          else
            paramDescFormat = paramStaticData.isPercent and ZhString.Gem_SkillEffectParamWithPercentFormat or ZhString.Gem_SkillEffectParamFormat
            paramDesc = string.format(paramDescFormat, paramValue, paramStaticData.min, paramStaticData.max)
          end
        else
          paramDesc = tostring(paramValue)
        end
        _ArrayPushBack(tempParamDescArr, paramDesc)
      end
      _ArrayPushBack(tempDescArr, {
        desc = string.format(sData.Desc, unpack(tempParamDescArr)),
        buffId = paramBuffID,
        goldStarCount = maxStarSign == 2 and 1 or 0,
        paramId = paramId
      })
    else
      local sBuffId = sData.BufferID
      foundBuff = _ArrayFindByPredicate(self.buffs, function(buff)
        return buff.id == sBuffId
      end)
      desc = nil
      if foundBuff then
        desc = sData.Desc
        _ArrayPushBack(tempDescArr, {
          desc = desc,
          buffId = sBuffId,
          goldStarCount = 1,
          paramId = 0
        })
      else
        desc = string.format(ZhString.Gem_SkillEffectInvalidEffectFormat, sData.Desc)
        _ArrayPushBack(tempDescArr, {
          desc = desc,
          buffId = sBuffId,
          goldStarCount = 0,
          paramId = 0
        })
      end
    end
  end
  return tempDescArr
end

function GemSkillData:GetStarCounts()
  local goldStarCount, silverStarCount = 0, 0
  if next(self.buffs) then
    local sData, paramId, paramValue, paramStaticData, maxStarSign, foundBuff
    for i = 1, #self.effectStaticDatas do
      sData = self.effectStaticDatas[i]
      if next(sData.ParamsID) then
        maxStarSign = 0
        for j = 1, #sData.ParamsID do
          paramId = sData.ParamsID[j]
          paramValue = self.buffParamMap[paramId] or 0
          paramValue = paramValue / 1000
          paramStaticData = GemProxy.Instance:GetStaticDataOfSkillGemParam(paramId)
          if paramStaticData and paramStaticData.list and next(paramStaticData.list) then
            if paramValue == paramStaticData.max then
              maxStarSign = paramStaticData.list[#paramStaticData.list].StarSign
            else
              for _, d in pairs(paramStaticData.list) do
                if (paramValue >= d.Nor_Min and paramValue < d.Nor_Max or paramValue > d.Nor_Max and paramValue <= d.Nor_Min) and d.StarSign and maxStarSign < d.StarSign then
                  maxStarSign = d.StarSign
                end
              end
            end
          end
        end
        if maxStarSign == 1 then
          silverStarCount = silverStarCount + 1
        elseif maxStarSign == 2 then
          goldStarCount = goldStarCount + 1
        end
      else
        foundBuff = _ArrayFindByPredicate(self.buffs, function(buff)
          return buff.id == sData.BufferID
        end)
        if foundBuff then
          goldStarCount = goldStarCount + 1
        end
      end
    end
  end
  return goldStarCount, silverStarCount
end

function GemSkillData:GetSculptData()
  return self.sculptures
end

function GemSkillData:IsFull()
  return self.isFull == true
end

function GemSkillData:Clone()
  return GemSkillData.new(self.itemGuid, self)
end

BuffParamData = class("BuffParamData")

function BuffParamData:ctor(paramData)
  self:SetData(paramData)
end

function BuffParamData:SetData(data)
  self.id = data.paramid or data.id
  self.per1 = data.paramper1 or data.per1
  self.per2 = data.paramper2 or data.per2
  self.value = data.paramvalue or data.value
end

function BuffParamData:Clone()
  return BuffParamData.new(self)
end

GemBuffData = class("GemBuffData")

function GemBuffData:ctor(buffData)
  self.buffParams = {}
  self.paramMap = {}
  self:SetData(buffData)
end

function GemBuffData:SetData(data)
  self.id = data.buffid or data.id
  local params = data.params or data.buffParams
  TableUtility.ArrayClear(self.buffParams)
  TableUtility.TableClear(self.paramMap)
  for i = 1, #params do
    TableUtility.ArrayPushBack(self.buffParams, BuffParamData.new(params[i]))
  end
  for _, param in pairs(self.buffParams) do
    self.paramMap[param.id] = param.value
  end
end

function GemBuffData:Clone()
  return GemBuffData.new(self)
end

GemSculptData = class("GemSculptData")

function GemSculptData:ctor(data)
  self:SetData(data)
end

function GemSculptData:SetData(data)
  self.type = data.type
  self.pos = data.pos
end

function GemSculptData:Clone()
  return GemSculptData.new(self)
end
