ProfileRecordTimeConsuming = {}
local IsEnable = true
local EnableRecordMem = false
local recordList = {}
local lastFrameTime = -1
local firstFrameCount = 0

function ProfileRecordTimeConsuming.EndSample(name)
  if not IsEnable or not UnityFrameCount then
    return
  end
  local frame = UnityFrameCount
  local endTime = os.clock() * 1000
  if recordList[frame] and recordList[frame][name] then
    recordList[frame][name].count = recordList[frame][name].count + 1
    recordList[frame][name].totaltime = RenderingManager.Instance:StopSystemWatch(name)
    if EnableRecordMem then
      collectgarbage("collect")
      local mem = collectgarbage("count")
      local startm = recordList[frame][name].startmem
      local originm = recordList[frame][name].totalmem
      recordList[frame][name].totalmem = (originm + mem - startm) / 1024.0
    end
  end
end

function ProfileRecordTimeConsuming.StartSample(name)
  if not IsEnable or not UnityFrameCount then
    return
  end
  local frame = UnityFrameCount
  if frame ~= lastFrameTime and recordList[frame] == nil then
    recordList[frame] = {}
  end
  lastFrameTime = frame
  if recordList[frame][name] == nil then
    recordList[frame][name] = {}
    recordList[frame][name].count = 0
    recordList[frame][name].totaltime = 0
    if EnableRecordMem then
      recordList[frame][name].totalmem = 0
    end
  end
  if EnableRecordMem then
    collectgarbage("collect")
    local mem = collectgarbage("count")
    recordList[frame][name].startmem = mem
  end
  local now = os.clock() * 1000
  recordList[frame][name].starttime = now
  RenderingManager.Instance:StartSystemWatch()
end

local saveDir

function ProfileRecordTimeConsuming.SatrtRecord()
  saveDir = ApplicationHelper.persistentDataPath
  local savepath = saveDir .. "/" .. tostring(UnityFrameCount) .. "frameCount.txt"
  local writef = assert(io.open(savepath, "w"))
  local tbContent = ProfileRecordTimeConsuming.WriteTableToLocal(recordList)
  writef:write(tbContent)
  writef:close()
  ProfileRecordTimeConsuming.Analysis()
  recordList = {}
end

function ProfileRecordTimeConsuming.SetIsEnable(_bool)
  IsEnable = _bool
end

function ProfileRecordTimeConsuming.WriteTableToLocal(_table)
  local sortList = {}
  for k, v in pairs(_table) do
    sortList[#sortList + 1] = {key = k, value = v}
  end
  table.sort(sortList, function(a, b)
    return a.key < b.key
  end)
  local wirtList = {}
  table.insert(wirtList, "FrameCount = ")
  table.insert(wirtList, "{ \n")
  for i = 1, #sortList do
    local info = sortList[i]
    local k = info.key
    local val = info.value
    table.insert(wirtList, "[")
    table.insert(wirtList, k)
    table.insert(wirtList, "] = {\n")
    for _k, _v in pairs(val) do
      table.insert(wirtList, "\t" .. _k .. " = {\n")
      if EnableRecordMem then
        table.insert(wirtList, "\t\tcount = " .. _v.count .. "," .. "totaltime = " .. _v.totaltime .. ",totalmem = " .. _v.totalmem)
      else
        table.insert(wirtList, "\t\tcount = " .. _v.count .. "," .. "totaltime = " .. _v.totaltime)
      end
      table.insert(wirtList, "},\n")
    end
    table.insert(wirtList, "},\n")
  end
  table.insert(wirtList, "}")
  return table.concat(wirtList)
end

function ProfileRecordTimeConsuming.RecordManagerTime()
  local savepath = Application.dataPath
  savepath = string.gsub(savepath, "Assets", "") .. "RecordProblemFolder/allManagerList.txt"
  local writef = assert(io.open(savepath, "w"))
  local sortList = {}
  for k, v in pairs(allManagerList) do
    sortList[#sortList + 1] = {key = k, value = v}
  end
  table.sort(sortList, function(a, b)
    return a.key < b.key
  end)
  local wirtList = {}
  table.insert(wirtList, "AllManagerList = ")
  table.insert(wirtList, "{\n")
  for i = 1, #sortList do
    local info = sortList[i]
    local k = info.key
    local val = info.value
    table.insert(wirtList, "[")
    table.insert(wirtList, k)
    table.insert(wirtList, "] = {\n")
    for _k, v in pairs(val) do
      table.insert(wirtList, "\t\t{")
      table.insert(wirtList, "name =" .. "\"" .. _k .. "\"" .. " , " .. "time = " .. v.time)
      table.insert(wirtList, "},\n")
    end
    table.insert(wirtList, "},\n")
  end
  table.insert(wirtList, "}")
  local strContent = "%s\n\nfunction tongji()\n\tlocal savePath = 'AllManagerList1.txt'\n\tlocal _tab =_G[\"AllManagerList\"]\n\tlocal saveTable = {}\n\tlocal count = 0\n\tfor _,val in pairs(_tab) do\n\t\tfor k,value in pairs(val)do\n\t\t\tif(saveTable[value.name] == nil)then\n\t\t\t\tsaveTable[value.name] = {}\n\t\t\t\tsaveTable[value.name].time = value.time\n\t\t\telse\n\t\t\t\tsaveTable[value.name].time = saveTable[value.name].time +value.time\n\t\t\tend\n\t\tend\n\t\tcount = count + 1\n\tend\n\n\tlocal sortList = {}\n\tfor k,v in pairs(saveTable) do\n\t\tsortList[#sortList + 1] = {key=k, value=v};\n\tend\n\ttable.sort(sortList,function(a,b)return (a.value.time> b.value.time) end)\n\tlocal result = WriteTable(sortList,count)\n\tWriteFile(savePath,result)\nend\n\nfunction WriteTable(sortList,count)\n\tlocal writelist = {}\n\ttable.insert(writelist,\"{\\n\")\n\tfor i=1,#sortList do\n\t\tlocal info = sortList[i]\n\t\tlocal k = info.key\n\t\tlocal v = info.value\n\t\ttable.insert(writelist,\"\\t{\")\n\t\ttable.insert(writelist,'name = \\\"'..k..\"\\\" \"..'time = '..v.time..', average = '..(v.time/count))\n\t\ttable.insert(writelist,'},\\n')\n\tend\n\ttable.insert(writelist,\"}\\n\")\n\treturn table.concat(writelist)\nend\n\nfunction WriteFile(filename, info)\n\tlocal wfile = io.open(filename, \"w+\")\n\tif(wfile == nil)then\n\t\terror('not find file: '..filename);\n\tend\n\twfile:write(info)\n\twfile:close()\n\n\tprint(\"导出文件：\", filename)\nend\n\ntongji()\n"
  local result = string.format(strContent, table.concat(wirtList))
  writef:write(result)
  writef:close()
  allManagerList = {}
end

function ProfileRecordTimeConsuming.Analysis()
  local savePath = tostring(UnityFrameCount) .. "profile_cpu_count.txt"
  local savePath1 = tostring(UnityFrameCount) .. "profile_cpu_totalTime.txt"
  local savePath2 = tostring(UnityFrameCount) .. "profile_cpu_average.txt"
  local saveTable = {}
  local temptable = {}
  for k, v in pairs(recordList) do
    temptable[#temptable + 1] = {key = k, value = v}
  end
  table.sort(temptable, function(a, b)
    return a.key < b.key
  end)
  for _, val in pairs(temptable) do
    for k_, v_ in pairs(val) do
      if type(v_) == "table" then
        for k, v in pairs(v_) do
          if saveTable[k] == nil then
            saveTable[k] = {}
            saveTable[k].count = v.count
            saveTable[k].totaltime = 0
          else
            saveTable[k].count = saveTable[k].count + v.count
            saveTable[k].totaltime = saveTable[k].totaltime + v.totaltime
          end
        end
      end
    end
  end
  for k, v in pairs(saveTable) do
    v.average = v.totaltime / v.count
  end
  local sortList = {}
  for k, v in pairs(saveTable) do
    sortList[#sortList + 1] = {key = k, value = v}
  end
  table.sort(sortList, function(a, b)
    return a.value.count > b.value.count
  end)
  local result = ProfileRecordTimeConsuming.WriteTable(sortList)
  ProfileRecordTimeConsuming.WriteFile(savePath, result)
  table.sort(sortList, function(a, b)
    return a.value.totaltime > b.value.totaltime
  end)
  result = ProfileRecordTimeConsuming.WriteTable(sortList)
  ProfileRecordTimeConsuming.WriteFile(savePath1, result)
  table.sort(sortList, function(a, b)
    return a.value.average > b.value.average
  end)
  result = ProfileRecordTimeConsuming.WriteTable(sortList)
  ProfileRecordTimeConsuming.WriteFile(savePath2, result)
end

function ProfileRecordTimeConsuming.WriteTable(sortList)
  local wirtList = {}
  table.insert(wirtList, "{ \n")
  for i = 1, #sortList do
    local info = sortList[i]
    local k = info.key
    local val = info.value
    table.insert(wirtList, "[")
    table.insert(wirtList, k)
    table.insert(wirtList, "] = { ")
    local average = string.format("%f", val.average)
    table.insert(wirtList, "count = " .. val.count .. "," .. "totaltime = " .. val.totaltime .. "," .. "average = " .. average)
    table.insert(wirtList, "},\n")
  end
  table.insert(wirtList, "}")
  return table.concat(wirtList)
end

function ProfileRecordTimeConsuming.WriteFile(filename, info)
  filename = saveDir .. "/" .. filename
  local wfile = io.open(filename, "w+")
  if wfile == nil then
    error("not find file: " .. filename)
  end
  wfile:write(info)
  wfile:close()
  print("导出文件：", filename)
end
