local get_time = os.clock
local sethook = debug.sethook
local getinfo = debug.getinfo
local trace_back_map = {}
local valid_depth = 1
local call_depth = 0
local current_trace, temp_trace_back, root
local mode_index = 0
local starttime = 0
local elapsetime = 0
local create_trace_back = function(db_info)
  return {
    name = db_info and db_info.name or "anonymous",
    count = 0,
    call_time = 0,
    return_time = 0,
    total_time = 0,
    event = "",
    id = "",
    parent = nil,
    child_list = {},
    child_id = {}
  }
end
local is_root = function(trace_back)
  return trace_back and trace_back.parent == nil
end
local get_subfunc = function(trace_back, id)
  if mode_index == 0 and current_trace.child_id[id] then
    return current_trace.child_list[current_trace.child_id[id]]
  elseif mode_index == 1 and trace_back_map[id] then
    return trace_back_map[id]
  else
    return nil
  end
end
local db_info = {}
local id_arr = {"", ""}
local id = ""
local push_trace_back = function(event)
  db_info = getinfo(3, "nS")
  id_arr[1] = db_info.short_src
  id_arr[2] = db_info.linedefined
  id = table.concat(id_arr, "-")
  temp_trace_back = get_subfunc(current_trace, id) or create_trace_back(db_info)
  temp_trace_back.count = temp_trace_back.count + 1
  temp_trace_back.call_time = get_time()
  temp_trace_back.event = event
  temp_trace_back.id = id
  temp_trace_back.parent = current_trace
  if mode_index == 0 and not current_trace.child_id[id] then
    current_trace.child_list[#current_trace.child_list + 1] = temp_trace_back
    current_trace.child_id[id] = #current_trace.child_list
  elseif mode_index == 1 then
    trace_back_map[id] = temp_trace_back
  end
  current_trace = temp_trace_back
end

local function pop_trace_back(time)
  current_trace.return_time = time or get_time()
  current_trace.total_time = current_trace.total_time + (current_trace.return_time - current_trace.call_time)
  local evt = current_trace.event
  if mode_index == 0 then
    current_trace = current_trace.parent
    if not is_root(current_trace) and evt == "tail call" then
      pop_trace_back(now)
    end
  elseif mode_index == 1 then
    local parent = current_trace.parent
    current_trace.parent = nil
    current_trace = parent
    if current_trace and evt == "tail call" then
      pop_trace_back(now)
    end
  end
end

local on_hook = function(event)
  if event == "call" then
    call_depth = call_depth + 1
    if call_depth < valid_depth then
      push_trace_back(event)
    end
  elseif event == "tail call" then
    if call_depth < valid_depth then
      push_trace_back(event)
    end
  elseif event == "return" then
    call_depth = call_depth - 1
    if current_trace and current_trace.parent and call_depth < valid_depth - 1 then
      pop_trace_back()
    end
  end
end
local deviation = 1.0E-5

local function redress_time(node)
  local time = 0
  if 0 < #node.child_list then
    for i = 1, #node.child_list do
      time = time + redress_time(node.child_list[i])
    end
  end
  time = deviation * node.count + time
  node.total_time = 0 < node.total_time - time and node.total_time - time or 0
  return time
end

local test_call2 = function(i)
  i = i + i
end
local test_call1 = function(i)
  test_call2(i)
  return test_call2(i)
end
local test = function()
  local t = get_time()
  for i = 1, 3333 do
    test_call1(i)
  end
  return get_time() - t
end
local init = function()
  call_depth = 0
  if mode_index == 0 then
    root = create_trace_back()
    root.call_time = get_time()
    current_trace = root
    temp_trace_back = nil
    trace_back_map = {}
  elseif mode_index == 1 then
    elapsetime = 0
    starttime = get_time()
    temp_trace_back = nil
    trace_back_map = {}
    root = nil
    current_trace = nil
  end
end
local start = function()
  init()
  call_depth = call_depth + 2
  sethook(on_hook, "cr")
end
local ReStart = function()
  init()
  call_depth = call_depth + 2
  sethook(on_hook, "cr")
end
local pause = function()
  sethook()
  call_depth = call_depth - 2
end
local resume = function()
  sethook(on_hook, "cr")
end
local stop = function()
  sethook()
  call_depth = call_depth - 2
  root = nil
  current_trace = nil
  temp_trace_back = nil
end
local logItem = {}
local report_output_line = function(tb)
  local name = tb.name or "[anonymous]"
  local total_time = string.format("%04.3f", tb.total_time * 1000)
  local total_relative = string.format("%03.2f%%", tb.total_time / elapsetime * 100)
  local average_time = string.format("%04.3f", tb.total_time / tb.count * 1000)
  local count = string.format("%7i", tb.count)
  return string.format("| %-20s | %-70s | %-12s | %-12s | %-12s | %-12s |", name, tb.id, total_time, average_time, total_relative, count)
end
local FORMAT_LINE = "| %-20s | %-70s | %-12s | %-12s | %-12s | %-12s |"
local contents = {
  string.format(FORMAT_LINE, "Name", "Source", "Total(MS)", "Average(MS)", "Total(%)", "Called")
}
local encode = function(map)
  for i = 1, #map do
    contents[#contents + 1] = report_output_line(map[i])
  end
end
local sort_funcs = {
  TOTAL = function(a, b)
    return a.total_time > b.total_time
  end,
  AVERAGE = function(a, b)
    return a.average > b.average
  end,
  CALLED = function(a, b)
    return a.called > b.called
  end
}
local sort_log = function(sort_by, map)
  local sort_func = type(sort_by) == "function" and sort_by or sort_funcs[sort_by]
  table.sort(map, sort_func or sort_funcs.TOTAL)
end

local function ready_json_encode(node)
  node.call_time = nil
  node.return_time = nil
  node.event = nil
  node.parent = nil
  node.child_id = nil
  for i = 1, #node.child_list do
    ready_json_encode(node.child_list[i])
  end
end

local report = function()
  pause()
  root.total_time = get_time() - root.call_time
  ready_json_encode(root)
  local jsonStr = json.encode(root)
  ReStart()
  return jsonStr
end
local output = function(sort_by, path)
  pause()
  elapsetime = elapsetime + get_time() - starttime
  starttime = get_time()
  local map = {}
  for _, v in pairs(trace_back_map) do
    map[#map + 1] = v
  end
  contents = {}
  sort_log(sort_funcs.TOTAL, map)
  encode(map)
  if path then
    WriteFile(path, table.concat(contents, "\n"))
  else
    WriteFile("./Assets/Resources/log.txt", table.concat(contents, "\n"))
  end
  resume()
end
local set_deep_profiler = function(depth)
  valid_depth = depth
end
local set_mode = function(idx)
  if mode_index ~= idx then
    mode_index = idx
    ReStart()
  end
  mode_index = idx
end
return {
  start = start,
  report = report,
  stop = stop,
  output = output,
  deep = set_deep_profiler,
  setmode = set_mode
}
