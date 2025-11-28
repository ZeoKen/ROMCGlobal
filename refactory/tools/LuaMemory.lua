require("ROSnapshot")
local info = ""
local snap = {}
local idx = {}
local contents = {}
local luagc = function()
  collectgarbage()
  collectgarbage()
  print(collectgarbage("count") / 1024)
end
local snapshot = function()
  local sz = collectgarbage("count")
  if ROSnapshot.snapshot() then
    return sz / 1024
  else
    return -1
  end
end
local compare = function(compareType, idxList)
  idx = {}
  snap = {}
  for v in Slua.iter(idxList) do
    idx[#idx + 1] = v + 1
    snap[#snap + 1] = ROSnapshot.getSnapshot(v + 1)
    Debug.Log(" idx = " .. v + 1)
  end
  local targetSnap = {}
  local exist = true
  local size = {}
  if compareType == 0 then
    for k, v in pairs(snap[1]) do
      size = v.size
      exist = true
      for i = 2, #snap do
        if snap[i][k] == nil then
          exist = false
          break
        end
        for idx = 1, #snap[i][k].size do
          if #size < 1 then
            size[#size + 1] = snap[i][k].size[idx]
          else
            size[#size + 1] = snap[i][k].size[idx] - size[1]
          end
        end
      end
      if exist then
        targetSnap[k] = v
        targetSnap[k].size = size
      end
    end
  else
    for k, v in pairs(snap[2]) do
      if snap[1][k] == nil then
        targetSnap[k] = v
      end
    end
  end
  ROSnapshot.insertSnapshot(targetSnap, 1)
  idx = {}
  snap = {}
  targetSnap = nil
  exist = nil
  luagc()
  return true
end
local createLeakItem = function(snap)
  return {
    level = snap and snap.level or 0,
    info = snap and snap.infos[1] or "Root",
    size = snap and table.concat(snap.size, ";") or "",
    type = snap and snap.type or "",
    count = 0,
    childList = {},
    updateData = function(snap)
      if not snap then
        return
      end
      Debug.Log("updateData")
      info = snap.infos[1]
      size = table.concat(snap.size, ";")
      count = count + 1
    end
  }
end
local IsBigger = function(size_arr)
  return true
end

local function readyJsonEncode(data)
  local child = {}
  for k, v in pairs(data.childList) do
    readyJsonEncode(v)
    child[#child + 1] = v
  end
  data.childList = child
end

local memoryMap, currentNode
local GenNode = function(k, v, parents, completeSnap)
  currentNode = memoryMap
  for i = #parents, 1, -1 do
    if not currentNode.childList[parents[i]] then
      currentNode.childList[parents[i]] = createLeakItem(completeSnap[parents[i]])
    else
      currentNode.childList[parents[i]].count = currentNode.childList[parents[i]].count + 1
    end
    currentNode = currentNode.childList[parents[i]]
  end
  if currentNode.childList[k] then
    currentNode.childList[k].info = v.infos[1]
    currentNode.childList[k].size = table.concat(v.size, ";")
    currentNode.childList[k].count = currentNode.childList[k].count + 1
  else
    currentNode.childList[k] = createLeakItem(v)
  end
end
local GenMap = function(cidx, sidx)
  Debug.Log("cidx = " .. cidx .. " sidx = " .. sidx)
  local completeSnap = ROSnapshot.getSnapshot(cidx + 1)
  local subSnap = ROSnapshot.getSnapshot(sidx + 1)
  memoryMap = createLeakItem()
  for k, v in pairs(subSnap) do
    AppendFile("./Assets/Resources/log.txt", table.concat(v.infos, ";"))
    if IsBigger(v.size) then
      local parents = {}
      local p = completeSnap[k].parent
      while completeSnap[p] do
        parents[#parents + 1] = p
        p = completeSnap[p].parent
      end
      GenNode(k, v, parents, completeSnap)
    end
  end
  readyJsonEncode(memoryMap)
  local jsonStr
  if memoryMap.childList[1] then
    jsonStr = json.encode(memoryMap.childList[1])
    WriteFile("./Assets/Resources/log.json", jsonStr)
  else
    jsonStr = nil
  end
  completeSnap = nil
  subSnap = nil
  newMap = nil
  memoryMap = createLeakItem()
  luagc()
  return jsonStr
end
local clear = function()
  ROSnapshot.clear()
end
return {
  Snapshot = snapshot,
  Compare = compare,
  Output = GenMap,
  Clear = clear,
  LuaGC = luagc
}
