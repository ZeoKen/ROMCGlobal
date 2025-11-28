PersonalArtifactData = class("PersonalArtifactData")
local ins, getRealValue, approximately

function PersonalArtifactData:ctor(sId, data)
  if not ins then
    ins = PersonalArtifactProxy.Instance
    getRealValue = PersonalArtifactProxy.GetRealValue
    approximately = math.Approximately
  end
  self.staticId = sId
  self.staticComposeData = Table_PersonalArtifactCompose[sId]
  if not self.staticComposeData then
    return
  end
  self.attrs = {}
  self.lockedAttrs = {}
  self.lockedAttrMap = {}
  self.serverAttrMap = {}
  self.candidateAttrs = {}
  self.serverCandidateAttrMap = {}
  self.artFragment = {}
  self.percentage = self.staticComposeData.Condition
  self:InitMinAttrData()
  self:SetData(data)
  self.isInited = true
end

local comparer = function(l, r)
  return l.id < r.id
end
local indexComparerFunc = function(l, r)
  return l.index < r.index
end
local _setElement = function(tbl, id, value, percentage, fake, index)
  tbl.id = id
  tbl.value = value
  tbl.percentage = percentage
  tbl.fake = fake
  tbl.index = index
end
local _getNewElement = function(id, value, percentage, fake, index)
  local t = {}
  _setElement(t, id, value, percentage, fake, index)
  return t
end
local _setData = function(localArr, serverArr, percentage, localMap, fake)
  serverArr = serverArr or _EmptyTable
  TableUtility.TableClear(localArr)
  TableUtility.TableClear(localMap)
  local element, id, v
  for i = 1, #serverArr do
    element, id, v = localArr[i], serverArr[i].id, serverArr[i].value
    if element then
      _setElement(element, id, v, percentage, fake, i)
    else
      localArr[i] = _getNewElement(id, v, percentage, fake, i)
    end
    localMap[id] = localArr[i]
  end
end

function PersonalArtifactData:SetData(data)
  if not data then
    LogUtility.Warning("PersonalArtifactData: data is nil")
    return
  end
  self.state = data.art_state
  _setData(self.attrs, data.attrs, self.percentage, self.serverAttrMap, false)
  _setData(self.lockedAttrs, data.noattrs, self.percentage, self.lockedAttrMap, true)
  self:AddUnlockAttr()
  table.sort(self.attrs, indexComparerFunc)
  _setData(self.candidateAttrs, data.preattrs or data.candidateAttrs, self.percentage, self.serverCandidateAttrMap, false)
  table.sort(self.candidateAttrs, comparer)
  self:SetFragment(data.art_fragment)
end

function PersonalArtifactData:AddUnlockAttr()
  local index
  for framentId, data in pairs(self.lockedAttrMap) do
    index = #self.attrs + 1
    data.index = index
    self.attrs[index] = data
  end
end

function PersonalArtifactData:SetFragment(fragments)
  if not fragments then
    return
  end
  TableUtility.TableClear(self.artFragment)
  self.fragmentCount = #fragments
  for i = 1, self.fragmentCount do
    self.artFragment[fragments[i]] = 1
  end
end

function PersonalArtifactData:GetState()
  return self.state or PersonalArtifactProxy.EArtifactState.InActivated
end

function PersonalArtifactData:CheckValid()
  return self:GetState() > PersonalArtifactProxy.EArtifactState.InActivated
end

function PersonalArtifactData:CheckInActive()
  return self:GetState() == PersonalArtifactProxy.EArtifactState.InActivated
end

function PersonalArtifactData:IsActiveArtifact()
  return self.state == PersonalArtifactProxy.EArtifactState.Activation or self.state == PersonalArtifactProxy.EArtifactState.Entery
end

function PersonalArtifactData:GetFragmentCount()
  return self.fragmentCount or 0
end

function PersonalArtifactData:CheckFragmentActive(id)
  return nil ~= self.artFragment[id]
end

function PersonalArtifactData:InitMinAttrData()
  self.minAttrMap = {}
  local fragmentId, attrSDataMap, min
  if not ins.fragmentStaticAttrDataMap then
    ins:InitStaticAttrData()
  end
  for i = 1, #self.staticComposeData.CostFlagments do
    fragmentId = self.staticComposeData.CostFlagments[i][1]
    attrSDataMap = ins.fragmentStaticAttrDataMap[fragmentId]
    min = nil
    if attrSDataMap and next(attrSDataMap) then
      for _, data in pairs(attrSDataMap) do
        if min then
          min = math.min(data.AttrBound[1], min)
        else
          min = data.AttrBound[1]
        end
      end
    end
    if min then
      self.minAttrMap[fragmentId] = _getNewElement(fragmentId, min * 1000, self.percentage, true, i)
    end
  end
end

function PersonalArtifactData:SetFakeData()
  TableUtil.HashToArray(self.minAttrMap, self.attrs)
  table.sort(self.attrs, indexComparerFunc)
end

function PersonalArtifactData:GetAttriDesc()
  local sb, element = LuaStringBuilder.CreateAsTable()
  local appendLine = function(s)
    sb:Append(ItemTipDefaultUiIconPrefix)
    sb:Append(s)
    sb:Append("\n")
  end
  local isActive
  if self.isInited then
    for i = 1, #self.attrs do
      element = self.attrs[i]
      isActive = self:CheckFragmentActive(element.id)
      appendLine(ins:GetAttrDescByIdAndValue(element.id, element.value, isActive))
    end
    local effectIds, effectDesc = self.staticComposeData.UniqueEffect
    for i = 1, #effectIds do
      effectDesc = ItemUtil.getBufferDescById(effectIds[i])
      if not StringUtil.IsEmpty(effectDesc) then
        effectDesc = string.format(ZhString.PersonalArtifact_UniqueEffectFormat, effectDesc, self.percentage)
        if not self:IsUniqueEffectAvailable() then
          effectDesc = string.format(ZhString.Gem_SkillEffectInvalidEffectFormat, effectDesc)
        end
        appendLine(effectDesc)
      end
    end
    if sb:GetCount() > 0 then
      sb:RemoveLast()
    end
  end
  local s = sb:ToString() or ""
  sb:Destroy()
  return s
end

function PersonalArtifactData:GetAttriDescForShare()
  local sb, element = LuaStringBuilder.CreateAsTable()
  local appendLine = function(s)
    sb:Append(s)
    sb:Append("\n")
  end
  if self.isInited then
    for i = 1, #self.attrs do
      element = self.attrs[i]
      appendLine(ins:GetAttrDescByIdAndValueForShare(element.id, element.value))
    end
    local effectIds, effectDesc = self.staticComposeData.UniqueEffect
    for i = 1, #effectIds do
      effectDesc = ItemUtil.getBufferDescById(effectIds[i])
      if not StringUtil.IsEmpty(effectDesc) then
        effectDesc = string.format(ZhString.PersonalArtifact_UniqueEffectFormat, effectDesc, self.percentage)
        if not self:IsUniqueEffectAvailable() then
          effectDesc = string.format(ZhString.Gem_SkillEffectInvalidEffectFormat, effectDesc)
        end
        appendLine(effectDesc)
      end
    end
    if sb:GetCount() > 0 then
      sb:RemoveLast()
    end
  end
  local s = sb:ToString() or ""
  sb:Destroy()
  return s
end

function PersonalArtifactData:GetAttriDescUniqueEffectForShare()
  local sb, element = LuaStringBuilder.CreateAsTable()
  local appendLine = function(s)
    sb:Append(s)
    sb:Append("\n")
  end
  if self.isInited then
    for i = 1, #self.attrs do
      element = self.attrs[i]
      appendLine(ins:GetAttrDescByIdAndValueForShare(element.id, element.value))
    end
    local effectIds, effectDesc = self.staticComposeData.UniqueEffect
    for i = 1, #effectIds do
      effectDesc = ItemUtil.getBufferDescById(effectIds[i])
      if not StringUtil.IsEmpty(effectDesc) then
        effectDesc = string.format(ZhString.PersonalArtifact_UniqueEffectFormat, effectDesc, self.percentage)
        if not self:IsUniqueEffectAvailable() then
          effectDesc = string.format(ZhString.PersonalArtifact_UniqueEffectFormat, effectDesc)
        end
        appendLine(effectDesc)
      end
    end
    if sb:GetCount() > 0 then
      sb:RemoveLast()
    end
  end
  local s = sb:ToString() or ""
  sb:Destroy()
  return s
end

function PersonalArtifactData:IsUniqueEffectAvailable()
  if not self.percentage then
    return false
  end
  if nil ~= next(self.lockedAttrs) then
    return false
  end
  return self:GetAdvancedAttrCount(self.percentage) == #self.attrs
end

function PersonalArtifactData:HasBetterAttrToSave()
  if next(self.candidateAttrs) then
    for _, pair in pairs(self.attrs) do
      for _, rPair in pairs(self.candidateAttrs) do
        if pair.id == rPair.id and pair.value < rPair.value then
          return true
        end
      end
    end
  end
  return false
end

function PersonalArtifactData:AreAttrsAllMax()
  if not next(self.attrs) then
    return false
  end
  local rslt, sData = true
  for _, pair in pairs(self.attrs) do
    sData = ins:GetStaticAttrDataByIdAndValue(pair.id, pair.value)
    if sData then
      rslt = rslt and approximately(getRealValue(pair.value), sData.AttrMax)
    else
      return false
    end
  end
  return rslt
end

function PersonalArtifactData:GetAttrProgress()
  local unlockAttrs = self.attrs
  local cnt = #unlockAttrs + #self.lockedAttrs
  local sData
  local unlockProgressValue = 0
  for i = 1, #unlockAttrs do
    sData = ins:GetStaticAttrDataByIdAndValue(unlockAttrs[i].id, unlockAttrs[i].value)
    if sData then
      unlockProgressValue = unlockProgressValue + getRealValue(unlockAttrs[i].value) / sData.AttrMax
    end
  end
  return unlockProgressValue / cnt
end

function PersonalArtifactData:IsRefreshed()
  local sData
  for _, pair in pairs(self.attrs) do
    sData = ins:GetStaticAttrDataByIdAndValue(pair.id, pair.value)
    if sData and not approximately(getRealValue(pair.value), sData.AttrInit) then
      return true
    end
  end
  return false
end

function PersonalArtifactData:GetAdvancedAttrCount(percentagePoint)
  local count = 0
  for i = 1, #self.attrs do
    if PersonalArtifactData.IsAttrAdvanced(self.attrs[i].id, self.attrs[i].value, percentagePoint) then
      count = count + 1
    end
  end
  return count
end

function PersonalArtifactData:Clone()
  local data = PersonalArtifactData.new(self.staticId, self)
  data.state = self.state
  data.fragmentCount = self:GetFragmentCount()
  return data
end

function PersonalArtifactData.IsAttrAdvanced(id, value, percentagePoint)
  local sData = ins:GetStaticAttrDataByIdAndValue(id, value)
  return sData ~= nil and getRealValue(value) >= sData.AttrMax * percentagePoint / 100
end
