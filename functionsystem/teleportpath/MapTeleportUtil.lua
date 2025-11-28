MapTeleportUtil = class("MapTeleportUtil")
MapTeleportUtil.EstimateNpcTransCost = 100
local ChangeMapCost = 100
local table_insert = table.insert
local TblClear = function(t)
  for k, _ in pairs(t) do
    t[k] = nil
  end
end
local CheckCache = {}

function MapTeleportUtil.CanTargetTransferTo(targetMapID)
  targetMapID = targetMapID or 1
  local cache = CheckCache[targetMapID]
  if cache == nil then
    cache = {}
    CheckCache[targetMapID] = cache
  end
  if cache.FrameCount == UnityFrameCount then
    return cache.State
  end
  cache.FrameCount = UnityFrameCount
  cache.State = true
  local sConfig = Table_Map[targetMapID]
  local activeMaps = WorldMapProxy.Instance.activeMaps
  if sConfig.Type == 6 then
    if activeMaps == nil or not activeMaps[targetMapID] then
      cache.State = false
      return false
    end
  else
    if activeMaps == nil or not activeMaps[targetMapID] then
      cache.State = false
      return false
    end
    local areaData = WorldMapProxy.Instance:GetMapAreaDataByMapId(targetMapID)
    if areaData and not areaData.isactive then
      cache.State = false
      return false
    end
    if sConfig.MoneyType == 2 and not NewRechargeProxy.Ins:AmIMonthlyVIP() then
      cache.State = false
      return false
    end
  end
  if not ActivityEventProxy.Instance:IsFreeTransferMap(targetMapID, UIMapMapList.transmitType) then
    local tickNum = BagProxy.Instance:GetItemNumByStaticID(5040, BagProxy.BagType.MainBag)
    if tickNum == 0 then
      tickNum = BagProxy.Instance:GetItemNumByStaticID(5040, BagProxy.BagType.Storage)
      if tickNum == 0 then
        tickNum = BagProxy.Instance:GetItemNumByStaticID(5040, BagProxy.BagType.PersonalStorage)
      end
    end
    if tickNum == 0 and not CostUtil.CheckROB(sConfig.Money or 0) then
      cache.State = false
      return false
    end
  end
  local funcstateId = 118
  if Table_FuncState[funcstateId] and not FunctionUnLockFunc.checkFuncStateValid(funcstateId) then
    local ids = Table_FuncState[funcstateId] and Table_FuncState[funcstateId].MapID
    if ids and 0 < TableUtility.ArrayFindIndex(ids, targetMapID) then
      cache.State = false
      return false
    end
    cache.State = false
    return false
  end
  return cache.State
end

function MapTeleportUtil.GetInnerMinCost(srcID, dstID)
  local pathInfo = MapOutterTeleport[srcID] and MapOutterTeleport[srcID][dstID]
  if not pathInfo then
    return 0
  end
  if pathInfo.transitMap then
    return MapTeleportUtil.EstimateNpcTransCost
  end
  local retCost, retEp, retBp = math.huge
  for epID, info1 in pairs(pathInfo) do
    retEp = epID
    for bpID, info2 in pairs(info1) do
      if info2.totalCost and retCost > info2.totalCost then
        retCost = info2.totalCost
        retBp = bpID
      end
    end
  end
  if retBp then
    local innerInfo = MapInnerTeleport[srcID] and MapInnerTeleport[srcID].inner and MapInnerTeleport[srcID].inner[retBp] and MapInnerTeleport[srcID].inner[retBp][1]
    return innerInfo and innerInfo.totalCost or 0
  end
  return 0
end

function MapTeleportUtil.GetMinCost(srcID, dstID)
  if not MapOutterTeleport[srcID] then
    LogUtility.Error(string.format("MapOutterTeleport这张表中没有找到地图id为：【%s】 的配置", srcID))
    return 0
  end
  local pathInfo = MapOutterTeleport[srcID][dstID]
  if not pathInfo then
    return 0
  end
  if pathInfo.transitMap then
    local retEp, retBp, cost1
    if pathInfo.transitMap == srcID then
      cost1 = MapTeleportUtil.EstimateNpcTransCost
    else
      cost1, retEp, retBp = MapTeleportUtil.GetMinCost(srcID, pathInfo.transitMap)
    end
    local cost2
    if pathInfo.transitNPCToMap == dstID then
      cost2 = 0
    else
      cost2 = MapTeleportUtil.GetMinCost(pathInfo.transitNPCToMap, dstID)
    end
    return cost1 + cost2, retEp, retBp
  end
  local retCost, retEp, retBp = math.huge
  for epID, info1 in pairs(pathInfo) do
    retEp = epID
    for bpID, info2 in pairs(info1) do
      if info2.totalCost and retCost > info2.totalCost then
        retCost = info2.totalCost
        retBp = bpID
      end
    end
  end
  return retCost, retEp, retBp
end

local protect
local connectIDs, visitedMap = {}, {}
local yt = {}
local mFindNearlyMap = function(srcMapID, checkFunc)
  local curMapID = srcMapID
  local changeMapCount = 0
  protect = protect + 1
  if 10000 < protect then
    LogUtility.Error(string.format("FindNearlyMap Error. (srcMapID:%s)", srcMapID))
    return math.huge
  end
  local retCost, retID = math.huge
  while curMapID and not retID do
    protect = protect + 1
    if 10000 < protect then
      LogUtility.Error(string.format("FindNearlyMap Error. (srcMapID:%s)", srcMapID))
      return math.huge
    end
    changeMapCount = changeMapCount + 1
    visitedMap[curMapID] = true
    local tsInfo = Game.MapManager:GetSceneInfoByMapID(curMapID)
    TblClear(yt)
    local eps = tsInfo and tsInfo.eps
    if eps then
      for _, ep in pairs(eps) do
        local nSID = ep.nextSceneID
        if nSID ~= 0 then
          if checkFunc(nSID) then
            table_insert(yt, nSID)
          elseif not visitedMap[nSID] then
            table_insert(connectIDs, nSID)
          end
        end
      end
    end
    if NpcTransferTeleport[curMapID] then
      for i1, _ in pairs(NpcTransferTeleport[curMapID]) do
        if i1 ~= 0 then
          if checkFunc(i1) then
            table_insert(yt, i1)
          elseif not visitedMap[i1] then
            table_insert(connectIDs, i1)
          end
        end
      end
    end
    if 0 < #yt then
      for _, nSID in pairs(yt) do
        local minCost = MapTeleportUtil.GetMinCost(srcMapID, nSID)
        if retCost > minCost then
          retID = nSID
          retCost = minCost
        end
      end
    end
    curMapID = table.remove(connectIDs, 1)
  end
  retCost = retCost + changeMapCount * ChangeMapCost
  TblClear(visitedMap)
  TblClear(connectIDs)
  return retID, retCost, changeMapCount
end

function MapTeleportUtil.FindNearlyMap(srcMapID, checkFunc)
  protect = 0
  return mFindNearlyMap(srcMapID, checkFunc)
end

function MapTeleportUtil.GetMinCostOutterInfo(srcMapID, dstMapID, targetBPID)
  local outterInfo, outterInfoEPID, outterInfoBPID
  local outterMinCost = 9999999999
  for k, v in pairs(MapOutterTeleport[srcMapID][dstMapID]) do
    if nil ~= targetBPID then
      local info = v[targetBPID]
      if outterMinCost > info.totalCost then
        outterMinCost = info.totalCost
        outterInfo = info
        outterInfoEPID = k
        outterInfoBPID = targetBPID
      end
    elseif type(v) == "table" then
      for bk, bv in pairs(v) do
        if outterMinCost > bv.totalCost then
          outterMinCost = bv.totalCost
          outterInfo = bv
          outterInfoEPID = k
          outterInfoBPID = bk
        end
      end
    end
  end
  return outterInfo, outterInfoEPID, outterInfoBPID, outterMinCost
end

function MapTeleportUtil.GetTransferInnerCost(srcID, transferID)
  local outter = MapOutterTeleport[srcID][transferID]
  if not outter then
    return 0
  end
  local transfer = TransferTeleport[transferID]
  transfer = transfer and transfer[4]
  if not transfer then
    return 0
  end
  local epId, bpInfo = next(outter)
  local bpId = type(bpInfo) == "table" and next(bpInfo)
  if not bpId then
    return 0
  end
  local mapName = Table_Map[transferID] and Table_Map[transferID].NameEn
  if not mapName then
    return 0
  end
  if not transfer[bpId] then
    return 0
  end
  return transfer[bpId][2]
end
