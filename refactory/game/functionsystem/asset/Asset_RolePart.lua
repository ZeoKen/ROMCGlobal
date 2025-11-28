Asset_RolePart = class("Asset_RolePart", ReusableObject)
if not Asset_RolePart.Asset_RolePart_Inited then
  Asset_RolePart.Asset_RolePart_Inited = true
  Asset_RolePart.PoolSize = 10
  Asset_RolePart.SkinQuality = {
    Auto = 0,
    Bone1 = 1,
    Bone2 = 2,
    Bone4 = 4
  }
end
local tempArgs = {
  0,
  0,
  nil,
  LuaVector3.Zero(),
  LuaVector3.Zero(),
  LuaVector3.One(),
  nil,
  nil,
  Asset_RolePart.SkinQuality.Auto,
  nil,
  nil,
  nil,
  nil
}
local IsNull = Slua.IsNull
local ActionName = Asset_Role.ActionName

function Asset_RolePart.Create(partIndex, ID, callback, callbackArg, skinQuality, subparts, partColors, failCallback, failCallbackArg)
  tempArgs[1] = partIndex
  tempArgs[2] = ID
  tempArgs[3] = nil
  LuaVector3.Better_Set(tempArgs[4], 0, 0, 0)
  LuaVector3.Better_Set(tempArgs[5], 0, 0, 0)
  LuaVector3.Better_Set(tempArgs[6], 1, 1, 1)
  tempArgs[7] = callback
  tempArgs[8] = callbackArg
  tempArgs[9] = skinQuality or Asset_RolePart.SkinQuality.Auto
  tempArgs[10] = subparts
  tempArgs[11] = partColors
  tempArgs[12] = failCallback
  tempArgs[13] = failCallbackArg
  return ReusableObject.Create(Asset_RolePart, true, tempArgs)
end

function Asset_RolePart:ctor()
  self.args = {}
  Asset_RolePart.super.ctor(self)
end

function Asset_RolePart:SetLayer(layer)
  self.args[11] = layer
  if nil ~= self.args[9] then
    self.args[9].layer = layer
  end
  local ret, _ = pcall(function()
    return RolePart.isSubPartLayerHandled
  end)
  if not ret and self.subparts then
    for _, subpart in pairs(self.subparts) do
      if subpart then
        subpart:SetLayer(layer)
      end
    end
  end
end

function Asset_RolePart:ResetParent(parent, stay)
  self.args[3] = parent
  if stay == nil or stay ~= true then
    stay = false
  end
  if nil ~= self.args[9] then
    self.args[9].transform:SetParent(parent, stay)
    self.args[9]:RefreshLightMapColor()
  end
end

function Asset_RolePart:GetTransform()
  if nil ~= self.args[9] then
    return self.args[9].transform
  end
end

function Asset_RolePart:ResetLocalPositionXYZ(x, y, z)
  self.args[4]:Set(x, y, z)
  if nil ~= self.args[9] then
    self.args[9].transform.localPosition = self.args[4]
  end
end

function Asset_RolePart:ResetLocalPosition(p)
  self:ResetLocalPositionXYZ(p[1], p[2], p[3])
end

function Asset_RolePart:ResetLocalEulerAnglesXYZ(x, y, z)
  self.args[5]:Set(x, y, z)
  if nil ~= self.args[9] then
    self.args[9].transform.localEulerAngles = self.args[5]
  end
end

function Asset_RolePart:RotateDelta(y)
  local vector = self.args[5]
  LuaVector3.Better_Set(self.args[5], vector.x, vector.y + y, vector.z)
  if nil ~= self.args[9] then
    self.args[9].transform.localEulerAngles = self.args[5]
  end
end

function Asset_RolePart:ResetLocalEulerAngles(p)
  self:ResetLocalEulerAnglesXYZ(p[1], p[2], p[3])
end

function Asset_RolePart:ResetLocalScaleXYZ(x, y, z)
  LuaVector3.Better_Set(self.args[6], x, y, z)
  if nil ~= self.args[9] then
    self.args[9].transform.localScale = self.args[6]
  end
end

function Asset_RolePart:ResetLocalScale(p)
  self:ResetLocalScaleXYZ(p[1], p[2], p[3])
end

function Asset_RolePart:_ResetRolePart()
  local rolePart = self.args[9]
  local objTransform = rolePart.transform
  objTransform.parent = self.args[3]
  objTransform.localPosition = self.args[4]
  objTransform.localEulerAngles = self.args[5]
  objTransform.localScale = self.args[6]
  rolePart:RefreshLightMapColor()
  rolePart.layer = self.args[11]
  if self.skinQuality ~= Asset_RolePart.SkinQuality.Auto then
    rolePart:SetPartsQuality(self.skinQuality, false)
  end
end

function Asset_RolePart:_Destroy()
  self:DestroyAllSubParts()
  if nil ~= self.args[9] then
    self:ReSetEPNode()
    self:ResetSkinQuality()
    self.args[9]:ClearSubParts()
    self.assetManager:DestroyPart(self.args[1], self.args[2], self.args[9])
    self.args[9] = nil
  end
end

function Asset_RolePart:DestroyAllSubParts()
  if self.subparts then
    for partIndex, subpart in pairs(self.subparts) do
      if subpart then
        subpart:Destroy()
      end
      self.subparts[partIndex] = nil
      self.subpartIDs[partIndex] = nil
    end
  end
end

function Asset_RolePart:_CancelLoading()
  self:CancelLoadingAllSubParts()
  if nil ~= self.args[10] then
    self.assetManager:CancelCreatePart(self.args[1], self.args[2], self.args[10])
    self.args[10] = nil
  end
end

function Asset_RolePart:CancelLoadingAllSubParts()
  if self.subparts then
    for _, subpart in pairs(self.subparts) do
      if subpart then
        subpart:_CancelLoading()
      end
    end
  end
end

function Asset_RolePart:OnSubPartCreated(partIndex, subpart)
  self.loadingPartCount = self.loadingPartCount - 1
  local mainPartObj = self.args[9]
  if IsNull(mainPartObj) then
    return
  end
  local subPartIndex = Asset_Role.GetSubPartIndex(partIndex)
  local partObj = subpart.args[9]
  mainPartObj:SetSubPart(subPartIndex - 1, partObj, true)
  subpart:SetMounted(true)
  self:TryCallCreatedCallback()
end

function Asset_RolePart:HaveAllPartsLoaded()
  redlog("HaveAllPartsLoaded", tostring(self.loadingPartCount))
  return not self.loadingPartCount or self.loadingPartCount <= 0
end

function Asset_RolePart:TryMountAllSubParts()
  local mainPartObj = self.args[9]
  if IsNull(mainPartObj) then
    return
  end
  if self.subparts then
    for partIndex, subpart in pairs(self.subparts) do
      if subpart and not subpart:IsMounted() then
        local partObj = subpart.args[9]
        if not IsNull(partObj) then
          local subPartIndex = Asset_Role.GetSubPartIndex(partIndex)
          mainPartObj:SetSubPart(subPartIndex - 1, partObj, true)
          subpart:SetMounted(true)
        end
      end
    end
  end
end

function Asset_RolePart:TryCallCreatedCallback()
  if self:HaveAllPartsLoaded() and nil ~= self.args[7] then
    self.args[7](self.args[9], self.args[8], self)
    self:RemoveCreatedCallBack()
  end
end

function Asset_RolePart:OnPartCreated(tag, obj, part, ID)
  redlog("OnPartCreated", ID, tostring(obj))
  if self.args[10] ~= tag then
    self.assetManager:DestroyPart(part, ID, obj)
    return
  end
  self.loadingPartCount = self.loadingPartCount - 1
  self.args[10] = nil
  if nil == obj then
    LogUtility.WarningFormat("Load Role Part Failed: part={0}, ID={1}", part, ID)
    if self.args[12] ~= nil then
      self.args[12](self.args[13])
      self:RemoveCreateFailCallBack()
    end
    return
  end
  obj.gameObject:SetActive(true)
  if self.partColorIndex then
    obj:SwitchColor(self.partColorIndex - 1)
  end
  self.args[9] = obj
  self:_ResetRolePart()
  self:TryMountAllSubParts()
  self:TryCallCreatedCallback()
  if self.epNodesDisplay then
    self:UpdateEpNodesDisplay(obj)
  end
end

function Asset_RolePart:_IsLoading()
  return self.args and self.args[10] ~= nil
end

function Asset_RolePart:SetCreatedCallBack(callback, callbackArg)
  self.args[7] = callback
  self.args[8] = callbackArg
end

function Asset_RolePart:RemoveCreatedCallBack()
  self.args[7] = nil
  self.args[8] = nil
end

function Asset_RolePart:RemoveCreateFailCallBack()
  self.args[12] = nil
  self.args[13] = nil
end

function Asset_RolePart:SetEpNodesDisplay(display)
  if self.epNodesDisplay == display then
    return
  end
  self.epNodesDisplay = display
  self:UpdateEpNodesDisplay()
end

function Asset_RolePart:UpdateEpNodesDisplay(PartObj)
  PartObj = PartObj or self.args[9]
  if not PartObj then
    return
  end
  if not IsNull(self.EpNodesObj) then
    local _LODLevel = PerformanceManager.LODLevel
    self.EpNodesObj.level = self.epNodesDisplay and _LODLevel.High or _LODLevel.Mid
  else
    self.EpNodesObj = RoleUtil.UpdateEPNodesDisplay(PartObj, self.epNodesDisplay)
  end
end

function Asset_RolePart:ReSetEPNode()
  if not IsNull(self.EpNodesObj) then
    self.EpNodesObj.level = PerformanceManager.LODLevel.Mid
  end
  self.EpNodesObj = nil
end

function Asset_RolePart:ResetSkinQuality()
  if self.skinQuality ~= Asset_RolePart.SkinQuality.Auto then
    self.skinQuality = Asset_RolePart.SkinQuality.Auto
    self.args[9]:SetPartsQuality(self.skinQuality, false)
  end
end

function Asset_RolePart:IsMounted()
  return self.isMounted
end

function Asset_RolePart:SetMounted(val)
  self.isMounted = val
end

function Asset_RolePart:ResetPartColor(partIndex, n)
  local _, subPartIndex = Asset_Role.DecodeSubPartIndex(partIndex)
  if subPartIndex == 0 then
    if self.args[9] then
      self.args[9]:SwitchColor(n - 1)
    end
  else
    local subpart = self.subparts[partIndex]
    if subpart then
      local partObj = subpart.args[9]
      partObj:SwitchColor(n - 1)
    end
  end
end

function Asset_RolePart:ResetSubPart(partIndex, partID, n)
  if Asset_Role.IsSubPartIndex(partIndex) and partID and partID ~= 0 then
    local subpart = self.subparts[partIndex]
    local oldID = self.subpartIDs[partIndex]
    if oldID == partID then
      if subpart and not subpart:_IsLoading() and n and 0 < n then
        local partObj = subpart.args[9]
        partObj:SwitchColor(n - 1)
      end
      return
    end
    if subpart then
      if subpart:_IsLoading() then
        subpart:_CancelLoading()
      else
        subpart:Destroy()
      end
      self.subparts[partIndex] = nil
    end
    self.loadingPartCount = self.loadingPartCount + 1
    self.subpartIDs[partIndex] = partID
    self.subparts[partIndex] = Asset_RolePart.Create(partIndex, partID, function(partObj, args, assetRolePart)
      self:OnSubPartCreated(partIndex, assetRolePart)
      if n and 0 < n then
        partObj:SwitchColor(n - 1)
      end
    end, nil, self.skinQuality, nil, self.partColors)
  end
end

function Asset_RolePart:PlayAction(name, defaultName, speed, normalizedTime, callback, callbackArg)
  local rolePart = self.args[9]
  if not rolePart or not rolePart.partAction then
    return
  end
  local nameHash = ActionUtility.GetNameHash(name)
  if not self:HasAction(rolePart, nameHash) then
    name = ActionName.Idle
    defaultName = ActionName.Idle
  end
  defaultName = defaultName or ActionName.Idle
  nameHash = ActionUtility.GetNameHash(name)
  local defaultNameHash = ActionUtility.GetNameHash(defaultName)
  rolePart:PlayAction(nameHash, defaultNameHash, speed or 1, normalizedTime or 0, callback, callbackArg)
end

function Asset_RolePart:PlayAction_Idle()
  self:PlayAction(ActionName.Idle)
end

function Asset_RolePart:HasAction(rolePart, nameHash)
  if not rolePart then
    return false
  end
  local animator = rolePart.animators[1]
  if not animator then
    return false
  end
  return animator:HasState(0, nameHash)
end

function Asset_RolePart:SetPartAction(isPartAction)
  if self.args[9] then
    self.args[9].partAction = isPartAction
  end
end

function Asset_RolePart:GetPartAction()
  if self.args[9] then
    return self.args[9].partAction
  end
  return false
end

function Asset_RolePart:DoConstruct(asArray, args)
  self.assetManager = Game.AssetManager_Role
  self.args[1] = args[1]
  self.args[2] = args[2]
  self.args[3] = args[3]
  self.args[4] = LuaVector3.Better_Clone(args[4])
  self.args[5] = LuaVector3.Better_Clone(args[5])
  self.args[6] = LuaVector3.Better_Clone(args[6])
  self.args[7] = args[7]
  args[7] = nil
  self.args[8] = args[8]
  self.args[9] = nil
  self.args[10] = nil
  self.args[11] = 0
  self.args[12] = args[12]
  args[12] = nil
  self.args[13] = args[13]
  self.skinQuality = args[9] or Asset_RolePart.SkinQuality.Auto
  self.epNodesDisplay = false
  self.EpNodesObj = nil
  self.loadingPartCount = 1
  self.isMounted = false
  local partColors = args[11]
  self.partColors = partColors
  local partColorIndex
  if Asset_Role.IsMainPartIndex(self.args[1]) then
    partColorIndex = Asset_Role.EncodePartColorIndex(self.args[1], 0)
  elseif Asset_Role.IsSubPartIndex(self.args[1]) then
    local mainPartIndex, subPartIndex = Asset_Role.DecodeSubPartIndex(self.args[1])
    partColorIndex = Asset_Role.EncodePartColorIndex(mainPartIndex, subPartIndex)
  end
  self.partColorIndex = partColorIndex and partColors and partColors[partColorIndex]
  local subpartMap = args[10]
  local hasSubpart = false
  if subpartMap then
    for partIndex, resId in pairs(subpartMap) do
      redlog("subpartMap", partIndex, tostring(resId))
      if Asset_Role.IsSubPartIndex(partIndex) and resId and resId ~= 0 then
        self.loadingPartCount = self.loadingPartCount + 1
      end
    end
  end
  if 1 < self.loadingPartCount then
    hasSubpart = true
  end
  local loadTag = self.assetManager:CreatePart(args[1], args[2], self.OnPartCreated, self, nil, nil, true)
  self.args[10] = loadTag
  if hasSubpart then
    self.subparts = ReusableTable.CreateTable()
    self.subpartIDs = {}
    for partIndex, resId in pairs(subpartMap) do
      if Asset_Role.IsSubPartIndex(partIndex) and resId and resId ~= 0 then
        self.subpartIDs[partIndex] = resId
        self.subparts[partIndex] = Asset_RolePart.Create(partIndex, resId, function(partObj, args, assetRolePart)
          self:OnSubPartCreated(partIndex, assetRolePart)
        end, nil, self.skinQuality, nil, partColors)
      end
    end
  end
end

function Asset_RolePart:DoDeconstruct(asArray)
  self:_CancelLoading()
  self:_Destroy()
  self.args[3] = nil
  LuaVector3.Destroy(self.args[4])
  LuaVector3.Destroy(self.args[5])
  LuaVector3.Destroy(self.args[6])
  self:RemoveCreatedCallBack()
  self:RemoveCreateFailCallBack()
  self.epNodesDisplay = false
  self.EpNodesObj = nil
  if self.subparts then
    ReusableTable.DestroyAndClearTable(self.subparts)
    self.subparts = nil
  end
  self.subpartIDs = nil
  self.isMounted = nil
  self.loadingPartCount = nil
  self.partColorIndex = nil
  self.partColors = nil
end
