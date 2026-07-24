MountFashionProxy = class("MountFashionProxy", pm.Proxy)
local GetMountFashionConfigByIndex = function(mountId, index)
  local defaults = Game.MountDefaultFashion and Game.MountDefaultFashion[mountId]
  if not defaults then
    return
  end
  local categories = Game.MountFashionCategories and Game.MountFashionCategories[mountId]
  local pos = categories and categories[index]
  if pos then
    for i = 1, #defaults do
      local config = Table_MountFashion[defaults[i]]
      if config and config.Pos == pos then
        return config
      end
    end
  end
  return Table_MountFashion[defaults[index]]
end

function MountFashionProxy:ctor(proxyName, data)
  self.proxyName = proxyName or "MountFashionProxy"
  if not MountFashionProxy.Instance then
    MountFashionProxy.Instance = self
  end
  if data then
    self:setData(data)
  end
  self:Init()
end

function MountFashionProxy:Init()
  self.mountFashionMap = {}
  self.mountFashionHideMap = {}
  self.fashionList = {}
  self.fashionStateMap = {}
end

function MountFashionProxy:SyncMountFashions(serverDatas)
  local syncCount = serverDatas and #serverDatas or 0
  if syncCount == 0 then
    return
  end
  for i = 1, #serverDatas do
    local data = serverDatas[i]
    self:SyncMountFashionData(data.mount_id, data.pos_datas)
  end
  local role = ServiceUserProxy.Instance:GetRoleInfo()
  if not role then
    return
  end
  for mountId, _ in pairs(self.mountFashionMap) do
    self:SaveLocalData(mountId, role.id)
  end
end

function MountFashionProxy:SyncMountFashionData(mountId, serverDatas)
  local fashionData = self.mountFashionMap[mountId]
  if not fashionData then
    fashionData = {}
    self.mountFashionMap[mountId] = fashionData
  else
    TableUtility.TableClear(fashionData)
  end
  if self.mountFashionHideMap[mountId] then
    TableUtility.TableClear(self.mountFashionHideMap[mountId])
  end
  for i = 1, #serverDatas do
    local serverData = serverDatas[i]
    if serverData.style_id == 0 then
      self:SetMountFashionHidden(mountId, serverData.pos, true)
    elseif serverData.style_id then
      fashionData[serverData.pos] = serverData.style_id
    end
  end
end

function MountFashionProxy:GetLocalSaveBytes(mountId)
  local categories = Game.MountFashionCategories and Game.MountFashionCategories[mountId]
  if categories then
    local values = {}
    for i = 1, #categories do
      local pos = categories[i]
      if self:IsMountFashionExplicitHidden(mountId, pos) then
        values[#values + 1] = "0"
      else
        values[#values + 1] = tostring(self:GetEquipedFashionId(mountId, pos) or 0)
      end
    end
    return table.concat(values, ";") .. ";"
  end
  local bytes = ""
  local fashionData = self.mountFashionMap[mountId]
  if fashionData then
    for _, styleId in pairs(fashionData) do
      bytes = bytes .. tostring(styleId) .. ";"
    end
  end
  return bytes
end

function MountFashionProxy:IsLocalSaveBytesValid(mountId, bytes)
  if StringUtil.IsEmpty(bytes) then
    return false
  end
  local rets = string.split(bytes, ";")
  local categories = Game.MountFashionCategories and Game.MountFashionCategories[mountId]
  for i = 1, #rets do
    local styleId = tonumber(rets[i])
    if styleId == 0 and categories and categories[i] then
      return true
    end
    local config = Table_MountFashion[styleId]
    if config and config.Mount == mountId then
      return true
    end
  end
  return false
end

function MountFashionProxy:SaveLocalData(mountId, roleId)
  local role = roleId and {id = roleId} or ServiceUserProxy.Instance:GetRoleInfo()
  if not role then
    return
  end
  local bytes = self:GetLocalSaveBytes(mountId)
  local oldBytes = LocalSaveProxy.Instance:GetMountFashion(role.id, mountId)
  if bytes ~= oldBytes then
    LocalSaveProxy.Instance:SetMountFashion(role.id, mountId, bytes)
  end
end

function MountFashionProxy:SetMountDefaultFashion(mountId)
  local fashionData = self.mountFashionMap[mountId]
  if not fashionData then
    fashionData = {}
    self.mountFashionMap[mountId] = fashionData
  end
  local defaults = Game.MountDefaultFashion and Game.MountDefaultFashion[mountId]
  if defaults then
    for i = 1, #defaults do
      local id = defaults[i]
      local config = Table_MountFashion[id]
      if config and not fashionData[config.Pos] then
        fashionData[config.Pos] = id
      end
    end
  end
end

function MountFashionProxy:UpdateMountFashionData(mountId, pos, styleId)
  local fashionData = self.mountFashionMap[mountId]
  if not fashionData then
    fashionData = {}
    self.mountFashionMap[mountId] = fashionData
  end
  self:ClearMountFashionDataByPos(fashionData, pos)
  if styleId and styleId ~= 0 then
    self:SetMountFashionHidden(mountId, pos, false)
    fashionData[pos] = styleId
  elseif styleId == 0 then
    self:SetMountFashionHidden(mountId, pos, true)
  end
  self:SaveLocalData(mountId)
end

function MountFashionProxy:SetMountFashionHidden(mountId, pos, hidden)
  if not mountId or not pos then
    return
  end
  local hideData = self.mountFashionHideMap[mountId]
  if not hideData then
    hideData = {}
    self.mountFashionHideMap[mountId] = hideData
  end
  hideData[pos] = hidden and true or nil
end

function MountFashionProxy:IsMountFashionExplicitHidden(mountId, pos)
  local hideData = self.mountFashionHideMap[mountId]
  return hideData and hideData[pos] == true or false
end

function MountFashionProxy:ClearMountFashionDataByPos(fashionData, pos)
  for dataPos, styleId in pairs(fashionData) do
    local config = Table_MountFashion[styleId]
    if dataPos == pos or config and config.Pos == pos then
      fashionData[dataPos] = nil
    end
  end
end

function MountFashionProxy:UpdateMountFashionState(mountId, styleId, state)
  if not self.fashionStateMap[mountId] then
    self.fashionStateMap[mountId] = {}
  end
  self.fashionStateMap[mountId][styleId] = state
end

function MountFashionProxy:GetDefaultFashionId(mountId, pos)
  local defaults = Game.MountDefaultFashion and Game.MountDefaultFashion[mountId]
  if defaults then
    for i = 1, #defaults do
      local id = defaults[i]
      local config = Table_MountFashion[id]
      if config and config.Pos == pos then
        return id
      end
    end
  end
end

function MountFashionProxy:IsDefaultFashionHide(mountId, pos)
  local defaultId = self:GetDefaultFashionId(mountId, pos)
  local config = defaultId and Table_MountFashion[defaultId]
  return config and config.Hide == 1 or false
end

function MountFashionProxy:GetFashionType(mountId, pos)
  local defaultId = self:GetDefaultFashionId(mountId, pos)
  local config = defaultId and Table_MountFashion[defaultId]
  if config then
    return config.Type
  end
  local list = self:GetFashionList(mountId, pos)
  config = list and Table_MountFashion[list[1]]
  return config and config.Type
end

function MountFashionProxy:GetFashionList(mountId, pos)
  if not self.fashionList[mountId] then
    self.fashionList[mountId] = {}
  end
  local list = self.fashionList[mountId][pos]
  if not list then
    list = {}
    self.fashionList[mountId][pos] = list
    for id, v in pairs(Table_MountFashion) do
      if v.Mount == mountId and v.Pos == pos then
        list[#list + 1] = id
      end
    end
    self:SortFashionList(list)
  end
  return list
end

local SortFunc = function(l, r)
  local staticl = Table_MountFashion[l]
  local staticr = Table_MountFashion[r]
  local isOpenl = FunctionUnLockFunc.Me():CheckCanOpen(staticl.MenuID)
  local isOpenr = FunctionUnLockFunc.Me():CheckCanOpen(staticr.MenuID)
  local _this = MountFashionProxy.Instance
  local isActivedl, isActivedr
  if not staticl.ActiveMaterial or staticl.ActiveMaterial == _EmptyTable then
    isActivedl = true
  else
    isActivedl = _this.fashionStateMap[staticl.Mount] and _this.fashionStateMap[staticl.Mount][l] ~= nil and _this.fashionStateMap[staticl.Mount][l] or false
  end
  if not staticr.ActiveMaterial or staticr.ActiveMaterial == _EmptyTable then
    isActivedr = true
  else
    isActivedr = _this.fashionStateMap[staticl.Mount] and _this.fashionStateMap[staticl.Mount][r] ~= nil and _this.fashionStateMap[staticl.Mount][r] or false
  end
  if isOpenl == isOpenr then
    if isActivedl == isActivedr then
      return staticl.Sort < staticr.Sort
    else
      return isActivedl
    end
  end
  return isOpenl
end

function MountFashionProxy:SortFashionList(list)
  table.sort(list, SortFunc)
end

function MountFashionProxy:GetEquipedIndex(mountId, pos)
  if self:IsMountFashionExplicitHidden(mountId, pos) then
    return 1
  end
  local equipedStyleId = self:GetEquipedFashionId(mountId, pos)
  if equipedStyleId then
    local list = self:GetFashionList(mountId, pos)
    for i = 1, #list do
      local styleId = list[i]
      if styleId == equipedStyleId then
        return i + 1
      end
    end
  end
  return 1
end

function MountFashionProxy:GetEquipedFashionId(mountId, pos)
  if self:IsMountFashionExplicitHidden(mountId, pos) then
    return
  end
  local fashionData = self.mountFashionMap[mountId]
  if fashionData then
    for _, styleId in pairs(fashionData) do
      local config = Table_MountFashion[styleId]
      if config and config.Pos == pos then
        return styleId
      end
    end
  end
  return self:GetDefaultFashionId(mountId, pos)
end

function MountFashionProxy:IsEquipedFashion(styleId)
  local config = Table_MountFashion[styleId]
  if config then
    local mountId = config.Mount
    if self:IsMountFashionExplicitHidden(mountId, config.Pos) then
      return false
    end
    return self:GetEquipedFashionId(mountId, config.Pos) == styleId
  end
  return false
end

function MountFashionProxy:IsMountFashionHidden(mountId, pos)
  return self:IsMountFashionExplicitHidden(mountId, pos) or self:GetEquipedFashionId(mountId, pos) == nil
end

function MountFashionProxy:IsDefaultFashionEquiped(mountId, pos)
  local defaultId = self:GetDefaultFashionId(mountId, pos)
  return defaultId and self:IsEquipedFashion(defaultId) or false
end

function MountFashionProxy:SetMountSubParts(parts, mountId)
  local categories = Game.MountFashionCategories and Game.MountFashionCategories[mountId]
  if categories then
    for i = 1, #categories do
      local styleId = self:GetEquipedFashionId(mountId, categories[i])
      local config = styleId and Table_MountFashion[styleId]
      if config and config.Type == 2 then
        for j = 1, #config.PartIndex do
          Asset_Role.SetMountSubPart(parts, config.PartIndex[j], config.PartID[j])
          if config.Skin and config.Skin ~= _EmptyTable then
            Asset_Role.SetMountPartColor(parts, config.PartIndex[j], config.Skin[j])
          end
        end
      end
    end
    return
  end
  local fashionData = self.mountFashionMap[mountId]
  if not fashionData then
    return
  end
  for _, styleId in pairs(fashionData) do
    local config = Table_MountFashion[styleId]
    if config and config.Type == 2 then
      for i = 1, #config.PartIndex do
        Asset_Role.SetMountSubPart(parts, config.PartIndex[i], config.PartID[i])
        if config.Skin and config.Skin ~= _EmptyTable then
          Asset_Role.SetMountPartColor(parts, config.PartIndex[i], config.Skin[i])
        end
      end
    end
  end
end

local SetMountPartColorByConfig = function(parts, config)
  if not config or not config.Skin then
    return
  end
  for i = 1, #config.PartIndex do
    Asset_Role.SetMountPartColor(parts, config.PartIndex[i], config.Skin[i])
  end
end

function MountFashionProxy:SetMountPartColors(parts, mountId)
  local categories = Game.MountFashionCategories and Game.MountFashionCategories[mountId]
  if categories then
    for i = 1, #categories do
      local pos = categories[i]
      local styleId = self:GetEquipedFashionId(mountId, pos)
      local config = styleId and Table_MountFashion[styleId]
      if not config and self:IsMountFashionExplicitHidden(mountId, pos) then
        local defaultStyleId = self:GetDefaultFashionId(mountId, pos)
        config = defaultStyleId and Table_MountFashion[defaultStyleId]
      end
      if config and config.Type == 1 then
        SetMountPartColorByConfig(parts, config)
      end
    end
    return
  end
  local fashionData = self.mountFashionMap[mountId]
  local coloredPosMap = ReusableTable.CreateTable()
  if fashionData then
    for _, styleId in pairs(fashionData) do
      local config = Table_MountFashion[styleId]
      if config and config.Type == 1 then
        SetMountPartColorByConfig(parts, config)
        coloredPosMap[config.Pos] = true
      end
    end
  end
  local defaults = Game.MountDefaultFashion and Game.MountDefaultFashion[mountId]
  if defaults then
    for i = 1, #defaults do
      local styleId = defaults[i]
      local config = Table_MountFashion[styleId]
      if config and config.Type == 1 and not coloredPosMap[config.Pos] then
        SetMountPartColorByConfig(parts, config)
      end
    end
  end
  ReusableTable.DestroyAndClearTable(coloredPosMap)
end

function MountFashionProxy:SetLocalSaveData(roleId, mountId)
  local fashionData = self.mountFashionMap[mountId]
  if not fashionData then
    fashionData = {}
    self.mountFashionMap[mountId] = fashionData
  else
    TableUtility.TableClear(fashionData)
  end
  if self.mountFashionHideMap[mountId] then
    TableUtility.TableClear(self.mountFashionHideMap[mountId])
  end
  local bytes = LocalSaveProxy.Instance:GetMountFashion(roleId, mountId)
  if StringUtil.IsEmpty(bytes) then
    self:SetMountDefaultFashion(mountId)
  else
    local rets = string.split(bytes, ";")
    local categories = Game.MountFashionCategories and Game.MountFashionCategories[mountId]
    for i = 1, #rets do
      local styleId = tonumber(rets[i])
      local config = Table_MountFashion[styleId]
      if styleId == 0 and categories and categories[i] then
        self:SetMountFashionHidden(mountId, categories[i], true)
      elseif config and config.Mount == mountId then
        self:SetMountFashionHidden(mountId, config.Pos, false)
        fashionData[config.Pos] = styleId
      elseif styleId == 0 then
        local defaultConfig = GetMountFashionConfigByIndex(mountId, i)
        if defaultConfig then
          self:SetMountFashionHidden(mountId, defaultConfig.Pos, true)
        end
      end
    end
  end
end

function MountFashionProxy:IsFashionActived(styleId)
  local config = Table_MountFashion[styleId]
  if config then
    local mountId = config.Mount
    if not config.ActiveMaterial or config.ActiveMaterial == _EmptyTable then
      return true
    end
    return self.fashionStateMap[mountId] and self.fashionStateMap[mountId][styleId] ~= nil and self.fashionStateMap[mountId][styleId] or false
  end
  return false
end

function MountFashionProxy:IsFashionCanActive(styleId)
  if not self:IsFashionActived(styleId) then
    local config = Table_MountFashion[styleId]
    if config then
      if not config.ActiveMaterial or config.ActiveMaterial == _EmptyTable then
        return false
      end
      local _bagProxy = BagProxy.Instance
      for i = 1, #config.ActiveMaterial do
        local data = config.ActiveMaterial[i]
        local myNum = _bagProxy:GetAllItemNumByStaticID(data[1])
        if myNum < data[2] then
          return false
        end
      end
      return true
    end
  end
  return false
end

function MountFashionProxy:IsFashionNeedCostMaterial(styleId)
  local config = Table_MountFashion[styleId]
  if config then
    return config.ActiveMaterial and config.ActiveMaterial ~= _EmptyTable
  end
  return false
end
