autoImport("SortMap")
autoImport("LStack")
FunctionAstrolabe = {}
FunctionAstrolabe.SearchType = {
  Path = 1,
  Gold = 2,
  Count = 3
}
FunctionAstrolabe.SearchFromType = {
  Origin = 1,
  Active = 2,
  Plan = 3
}
FunctionAstrolabe.DefaultSearchType = FunctionAstrolabe.SearchType.Gold
FunctionAstrolabe.DefaultSearchFromType = FunctionAstrolabe.SearchFromType.Active
local Infinity = math.huge
local proxyIns
local noneIdx = 0
local invaildIdx = -1
local origin = 10000
local parent
local astrolabeID = 0
local starID = 0
local id = 0
local connects = {}
local plateSData, star
local floor = math.floor
local visited = {}
local queue = {}
local stack
local contributeId, goldMedalId = AstrolabeProxy.ContributeItemId, AstrolabeProxy.GoldMedalItemId
local tableAstrolabe = Table_Astrolabe
local _tableRune
local tableRune = function()
  if not _tableRune then
    _tableRune = Table_Rune
  end
  return _tableRune
end
local isVisited = function(id)
  return visited[id] ~= nil and visited[id] ~= invaildIdx
end

function FunctionAstrolabe.BFS(fpIdx, activated, evoFliter)
  if not proxyIns then
    proxyIns = AstrolabeProxy.Instance
  end
  local CheckPlateIsUnlock = proxyIns.CheckPlateIsUnlock
  evoFliter = evoFliter or Infinity
  if activated and activated[fpIdx] then
    return nil
  end
  local AssemblePath = FunctionAstrolabe.AssemblePath
  local ReuseAllNode = FunctionAstrolabe.ReuseAllNode
  local bordData = FunctionAstrolabe.bordData
  local head = 0
  local last = 1
  queue[last] = fpIdx
  visited[fpIdx] = noneIdx
  local activedIsNotEmpty = activated ~= nil and next(activated) ~= nil
  local breakCheck = function(id)
    if activedIsNotEmpty then
      return activated[id]
    end
    return id == origin
  end
  while head < last do
    head = head + 1
    parent = queue[head]
    astrolabeID = floor(parent / origin)
    starID = parent % origin
    plateSData = tableAstrolabe[astrolabeID]
    if evoFliter >= plateSData.unlock.evo then
      star = plateSData.stars[starID]
      for i = 1, #star do
        connects = star[i]
        for k = 1, #connects do
          id = connects[k]
          if id < origin then
            id = id + astrolabeID * origin
          end
          if breakCheck(id) then
            local path = AssemblePath(visited, id, parent)
            ReuseAllNode(visited)
            return path
          end
          if not isVisited(id) and CheckPlateIsUnlock(proxyIns, floor(id / origin), bordData) then
            visited[id] = parent
            last = last + 1
            queue[last] = id
          end
        end
      end
    end
  end
  ReuseAllNode(visited)
end

local getTotalAstrolabeCostFromList = function(list)
  local costContribute, costGoldMedal = 0, 0
  for _, runeId in pairs(list) do
    for _, c in pairs(tableRune()[runeId].Cost) do
      if c[1] == contributeId then
        costContribute = costContribute + c[2]
      elseif c[1] == goldMedalId then
        costGoldMedal = costGoldMedal + c[2]
      end
    end
  end
  return costContribute, costGoldMedal
end

function FunctionAstrolabe.DFSOneKnobActive(handlePointsList, ownedContribute, ownedGoldMedal)
  if type(handlePointsList) ~= "table" then
    return
  end
  TableUtility.TableClear(handlePointsList)
  if not proxyIns then
    proxyIns = AstrolabeProxy.Instance
  end
  if stack then
    stack:BetterClear()
  else
    stack = LStack.new()
  end
  local CheckPlateIsUnlock = proxyIns.CheckPlateIsUnlock
  local bordData = FunctionAstrolabe.bordData
  local activatedMap = proxyIns:GetActivePointsMap()
  local costCheck = function()
    local costContribute, costGoldMedal = getTotalAstrolabeCostFromList(handlePointsList)
    return costContribute > ownedContribute or costGoldMedal > ownedGoldMedal
  end
  stack:Push(origin)
  while not stack:IsEmpty() do
    parent = stack:Pop()
    if not activatedMap[parent] and not isVisited(parent) then
      table.insert(handlePointsList, parent)
    end
    if costCheck() then
      table.remove(handlePointsList)
    else
      visited[parent] = 1
      astrolabeID = floor(parent / origin)
      starID = parent % origin
      plateSData = tableAstrolabe[astrolabeID]
      star = plateSData.stars[starID]
      for i = 1, #star do
        connects = star[i]
        for j = 1, #connects do
          id = connects[j]
          if id < origin then
            id = id + astrolabeID * origin
          end
          if not isVisited(id) and CheckPlateIsUnlock(proxyIns, floor(id / origin), bordData) then
            stack:Push(id)
          end
        end
      end
    end
  end
  FunctionAstrolabe.ReuseAllNode(visited)
end

function FunctionAstrolabe.AssemblePath(visited, firstIdx, parentIdx)
  local path = {firstIdx}
  while 0 < parentIdx do
    path[#path + 1] = parentIdx
    parentIdx = visited[parentIdx]
  end
  return path
end

function FunctionAstrolabe.ReuseAllNode(visited)
  for k, _ in pairs(visited) do
    visited[k] = invaildIdx
  end
end

function FunctionAstrolabe.ClearCache()
  visited = {}
  connects = {}
  queue = {}
  star = nil
end

FunctionAstrolabe.bordData = nil

function FunctionAstrolabe.SetBordData(bordData)
  FunctionAstrolabe.bordData = bordData
end

function FunctionAstrolabe.ReSetBordData()
  FunctionAstrolabe.SetBordData(nil)
end

local calcount = 0
local dis, path
local sortMap_visited = SortMap.new()
local Relax = function(rid, func_getWeight, checkValid)
  astrolabeID = floor(rid / origin)
  starID = rid % origin
  plateSData = tableAstrolabe[astrolabeID]
  if checkValid and not checkValid(astrolabeID, starID) then
    return
  end
  star = plateSData.stars[starID]
  local cid, weight
  for i = 1, #star do
    connects = star[i]
    for k = 1, #connects do
      cid = connects[k]
      if cid < origin then
        cid = cid + astrolabeID * origin
      end
      weight = func_getWeight(cid)
      if dis[cid] > dis[rid] + weight then
        dis[cid] = dis[rid] + weight
        path[cid] = rid
        sortMap_visited:Set(cid, dis[cid])
      end
      calcount = calcount + 1
    end
  end
end
local ResetTable = function()
  dis, path = {}, {}
  sortMap_visited:Clear()
end

function FunctionAstrolabe.DijkstraSP(globalID, func_getWeight, checkValid)
  ResetTable()
  for id, _ in pairs(tableRune()) do
    dis[id] = Infinity
  end
  dis[globalID] = 0
  sortMap_visited:Set(globalID, func_getWeight(globalID))
  local minid
  while not sortMap_visited:IsEmpty() do
    minid = sortMap_visited:TakeMin()
    Relax(minid, func_getWeight, checkValid)
  end
end

function FunctionAstrolabe.GetPathByWeight(globalID, activated, func_getWeight)
  calcount = 0
  if not proxyIns then
    proxyIns = AstrolabeProxy.Instance
  end
  local CheckPlateIsUnlock = proxyIns.CheckPlateIsUnlock
  local func_checkValid = function(astrolabeID, starID)
    return CheckPlateIsUnlock(proxyIns, astrolabeID)
  end
  FunctionAstrolabe.DijkstraSP(globalID, func_getWeight, func_checkValid)
  local minid, mindis
  if activated == nil or next(activated) == nil then
    minid = origin
  else
    for id, _ in pairs(activated) do
      if minid == nil or mindis > dis[id] then
        minid, mindis = id, dis[id]
      end
    end
  end
  helplog("FunctionAstrolabe GetPathByWeight:", minid)
  if minid == nil or dis[minid] >= Infinity then
    return _EmptyTable
  end
  local gPath = {minid}
  while path[minid] ~= nil do
    table.insert(gPath, path[minid])
    minid = path[minid]
  end
  ResetTable()
  return gPath
end

function FunctionAstrolabe.GetPath(globalID, searchType, searchFromType)
  helplog("GetPath", globalID, tostring(searchType), tostring(searchFromType))
  if not proxyIns then
    proxyIns = AstrolabeProxy.Instance
  end
  searchType = searchType or FunctionAstrolabe.DefaultSearchType
  local activited
  searchFromType = searchFromType or FunctionAstrolabe.DefaultSearchFromType
  if searchFromType == FunctionAstrolabe.SearchFromType.Active then
    activited = proxyIns:GetActivePointsMap()
  elseif searchFromType == FunctionAstrolabe.SearchFromType.Plan then
    activited = proxyIns:GetPlanIdsMap()
  end
  if searchType == FunctionAstrolabe.SearchType.Path then
    return FunctionAstrolabe.BFS(globalID, activited)
  end
  if activited == nil then
    activited = {}
  end
  if searchType == FunctionAstrolabe.SearchType.Gold then
    local getPathByWeight = function(gid)
      if activited[gid] then
        return 0
      end
      local cost = tableRune()[gid].Cost
      local defaultCost = 1
      local goldCost = cost[3] and cost[3][2] * 10000 or 0
      return defaultCost + goldCost
    end
    return FunctionAstrolabe.GetPathByWeight(globalID, activited, getPathByWeight)
  end
  if searchType == FunctionAstrolabe.SearchType.Count then
    local getPathByWeight = function(gid)
      if activited[gid] then
        return 0
      end
      return tableRune()[gid].Cost[2] and tableRune()[gid].Cost[2][2] or 0
    end
    return FunctionAstrolabe.GetPathByWeight(globalID, activited, getPathByWeight)
  end
end
