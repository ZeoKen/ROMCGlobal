MountFashionProxy = class("MountFashionProxy", pm.Proxy)

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
  self.fashionList = {}
  self.fashionStateMap = {}
end

function MountFashionProxy:SyncMountFashions(serverDatas)
  if #serverDatas == 0 then
    local myMount = Game.Myself.data:GetMount()
    if 0 < myMount then
      self:SetMountDefaultFashion(myMount)
    end
  else
    for i = 1, #serverDatas do
      local data = serverDatas[i]
      self:SyncMountFashionData(data.mount_id, data.pos_datas)
    end
  end
  local role = ServiceUserProxy.Instance:GetRoleInfo()
  for mountId, fashionData in pairs(self.mountFashionMap) do
    local bytes = ""
    for _, styleId in pairs(fashionData) do
      bytes = bytes .. tostring(styleId) .. ";"
    end
    local oldBytes = LocalSaveProxy.Instance:GetMountFashion(role.id, mountId)
    if bytes ~= oldBytes then
      LocalSaveProxy.Instance:SetMountFashion(role.id, mountId, bytes)
    end
  end
end

function MountFashionProxy:SyncMountFashionData(mountId, serverDatas)
  local fashionData = self.mountFashionMap[mountId]
  if not fashionData then
    fashionData = {}
    self.mountFashionMap[mountId] = fashionData
  end
  for i = 1, #serverDatas do
    local serverData = serverDatas[i]
    fashionData[serverData.pos] = serverData.style_id
  end
  self:SetMountDefaultFashion(mountId)
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
  fashionData[pos] = styleId
end

function MountFashionProxy:UpdateMountFashionState(mountId, styleId, state)
  if not self.fashionStateMap[mountId] then
    self.fashionStateMap[mountId] = {}
  end
  self.fashionStateMap[mountId][styleId] = state
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
  self:SetMountDefaultFashion(mountId)
  local equipedStyleId
  for _, styleId in pairs(self.mountFashionMap[mountId]) do
    local config = Table_MountFashion[styleId]
    if config.Pos == pos then
      equipedStyleId = styleId
      break
    end
  end
  if equipedStyleId then
    local list = self:GetFashionList(mountId, pos)
    local equipedIndex = TableUtility.ArrayFindIndex(list, equipedStyleId)
    return equipedIndex
  end
end

function MountFashionProxy:IsEquipedFashion(styleId)
  local config = Table_MountFashion[styleId]
  if config then
    local mountId = config.Mount
    self:SetMountDefaultFashion(mountId)
    return TableUtility.TableFindKey(self.mountFashionMap[mountId], styleId) ~= nil
  end
  return false
end

function MountFashionProxy:SetMountSubParts(parts, mountId)
  self:SetMountDefaultFashion(mountId)
  for _, styleId in pairs(self.mountFashionMap[mountId]) do
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

function MountFashionProxy:SetMountPartColors(parts, mountId)
  self:SetMountDefaultFashion(mountId)
  for _, styleId in pairs(self.mountFashionMap[mountId]) do
    local config = Table_MountFashion[styleId]
    if config and config.Type == 1 then
      for i = 1, #config.PartIndex do
        Asset_Role.SetMountPartColor(parts, config.PartIndex[i], config.Skin[i])
      end
    end
  end
end

function MountFashionProxy:SetLocalSaveData(roleId, mountId)
  local bytes = LocalSaveProxy.Instance:GetMountFashion(roleId, mountId)
  if not StringUtil.IsEmpty(bytes) then
    local rets = string.split(bytes, ";")
    local styleId = tonumber(rets[1])
    local config = Table_MountFashion[styleId]
    if config and config.Mount == mountId then
      local fashionData = self.mountFashionMap[mountId]
      if not fashionData then
        fashionData = {}
        self.mountFashionMap[mountId] = fashionData
        fashionData[config.Pos] = styleId
        for i = 2, #rets do
          styleId = tonumber(rets[i])
          config = Table_MountFashion[styleId]
          if config then
            fashionData[config.Pos] = styleId
          end
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
