autoImport("ProtobufPool")
autoImport("BackwardCompatibilityUtil")
local m_fProtobufPoolGetCbOut = ProtobufPool.GetCbOut
local c = require("protobuf.c")
local setmetatable = setmetatable
local type = type
local table = table
local assert = assert
local pairs = pairs
local ipairs = ipairs
local string = string
local tinsert = table.insert
local M = {}
local _pattern_cache = {}
local P, GC
P = debug.getregistry().PROTOBUF_ENV
if P then
  GC = c._gc()
else
  P = c._env_new()
  GC = c._gc(P)
end
M.GC = GC

function M.lasterror()
  return c._last_error(P)
end

local decode_type_cache = {}
local _R_meta = {}

function _R_meta:__index(key)
  local fun = decode_type_cache[self._CType][key]
  if fun ~= nil then
    local v = fun(self, key)
    self[key] = v
    return v
  else
    return function()
    end
  end
  return nil
end

local _reader = {}

function _reader:real(key)
  return c._rmessage_real(self._CObj, key, 0)
end

function _reader:string(key)
  local v = c._rmessage_string(self._CObj, key, 0)
  return v
end

function _reader:enumString(key)
  local enumStr = c._rmessage_string(self._CObj, key, 0)
  local enumTable = string.split(enumStr, "_")[1]
  if enumStr and enumTable then
    local tb = _G[enumTable]
    if tb then
      return tb[enumStr]
    else
      return enumStr
    end
  else
    return key
  end
end

function _reader:enum_repeated(key)
  local cobj = self._CObj
  local n = c._rmessage_size(cobj, key)
  local ret = {}
  for i = 0, n - 1 do
    local enumStr = c._rmessage_string(cobj, key, i)
    local enumTable = string.split(enumStr, "_")[1]
    tinsert(ret, _G[enumTable][enumStr])
  end
  return ret
end

function _reader:bool(key)
  return c._rmessage_int(self._CObj, key, 0) ~= 0
end

function _reader:message(key, message_type)
  local rmessage = c._rmessage_message(self._CObj, key, 0)
  if rmessage then
    local m = {}
    m._CObj = rmessage
    m._CType = message_type
    m._Parent = self
    return setmetatable(m, _R_meta)
  end
end

function _reader:int(key)
  return c._rmessage_int(self._CObj, key, 0)
end

function _reader:real_repeated(key)
  local cobj = self._CObj
  local n = c._rmessage_size(cobj, key)
  local ret = {}
  for i = 0, n - 1 do
    tinsert(ret, c._rmessage_real(cobj, key, i))
  end
  return ret
end

function _reader:string_repeated(key)
  local cobj = self._CObj
  local n = c._rmessage_size(cobj, key)
  local ret = {}
  for i = 0, n - 1 do
    tinsert(ret, c._rmessage_string(self._CObj, key, 0))
  end
  return ret
end

function _reader:bool_repeated(key)
  local cobj = self._CObj
  local n = c._rmessage_size(cobj, key)
  local ret = {}
  for i = 0, n - 1 do
    tinsert(ret, c._rmessage_int(cobj, key, i) ~= 0)
  end
  return ret
end

function _reader:message_repeated(key, message_type)
  local cobj = self._CObj
  local n = c._rmessage_size(cobj, key)
  local ret = {}
  for i = 0, n - 1 do
    local m = {}
    m._CObj = c._rmessage_message(cobj, key, i)
    m._CType = message_type
    m._Parent = self
    tinsert(ret, setmetatable(m, _R_meta))
  end
  return ret
end

function _reader:int_repeated(key)
  local cobj = self._CObj
  local n = c._rmessage_size(cobj, key)
  local ret = {}
  for i = 0, n - 1 do
    tinsert(ret, c._rmessage_int(cobj, key, i))
  end
  return ret
end

_reader[1] = function(msg)
  return _reader.int
end
_reader[2] = function(msg)
  return _reader.real
end
_reader[3] = function(msg)
  return _reader.bool
end
_reader[4] = function(msg)
  return _reader.int
end
_reader[5] = function(msg)
  return _reader.string
end
_reader[6] = function(msg)
  local message = _reader.message
  return function(self, key)
    return message(self, key, msg)
  end
end
_reader[7] = _reader[1]
_reader[8] = _reader[1]
_reader[9] = _reader[5]
_reader[10] = _reader[7]
_reader[11] = _reader[7]
_reader[129] = function(msg)
  return _reader.int_repeated
end
_reader[130] = function(msg)
  return _reader.real_repeated
end
_reader[131] = function(msg)
  return _reader.bool_repeated
end
_reader[132] = function(msg)
  return _reader.int_repeated
end
_reader[133] = function(msg)
  return _reader.string_repeated
end
_reader[134] = function(msg)
  local message = _reader.message_repeated
  return function(self, key)
    return message(self, key, msg)
  end
end
_reader[135] = _reader[129]
_reader[136] = _reader[129]
_reader[137] = _reader[133]
_reader[138] = _reader[135]
_reader[139] = _reader[135]
local _decode_type_meta = {}

function _decode_type_meta:__index(key)
  local t, msg = c._env_type(P, self._CType, key)
  local reader = _reader[t]
  local func
  if reader then
    func = reader(msg)
  else
    function func()
    end
  end
  self[key] = func
  return func
end

setmetatable(decode_type_cache, {
  __index = function(self, key)
    local v = setmetatable({_CType = key}, _decode_type_meta)
    self[key] = v
    return v
  end
})
local decode_message = function(message, buffer, length)
  local rmessage = c._rmessage_new(P, message, buffer, length)
  if rmessage then
    local self = {}
    self._CObj = rmessage
    self._CType = message
    c._add_rmessage(GC, rmessage)
    return setmetatable(self, _R_meta)
  end
end
local mmtt
local ClearV = function(t)
  if type(t) == "table" then
    mmtt = getmetatable(t)
    if mmtt and mmtt.__autoNewTable then
      setmetatable(t, nil)
    end
  end
end
local encode_type_cache = {}
local encode_message = function(CObj, message_type, t)
  local type = encode_type_cache[message_type]
  for k, v in pairs(t) do
    local func = type[k]
    ClearV(v)
    func(CObj, k, v)
  end
end
local _writer = {
  real = c._wmessage_real,
  enum = c._wmessage_int,
  string = c._wmessage_string,
  int = c._wmessage_int
}

function _writer:bool(k, v)
  c._wmessage_int(self, k, v and 1 or 0)
end

function _writer:message(k, v, message_type)
  local submessage = c._wmessage_message(self, k)
  encode_message(submessage, message_type, v)
end

function _writer:real_repeated(k, v)
  for _, v in ipairs(v) do
    c._wmessage_real(self, k, v)
  end
end

function _writer:bool_repeated(k, v)
  for _, v in ipairs(v) do
    c._wmessage_int(self, k, v and 1 or 0)
  end
end

function _writer:string_repeated(k, v)
  for _, v in ipairs(v) do
    c._wmessage_string(self, k, v)
  end
end

function _writer:message_repeated(k, v, message_type)
  for _, v in ipairs(v) do
    local submessage = c._wmessage_message(self, k)
    encode_message(submessage, message_type, v)
  end
end

function _writer:int_repeated(k, v)
  for _, v in ipairs(v) do
    c._wmessage_int(self, k, v)
  end
end

function _writer:enum_repeated(k, v)
  for _, v in ipairs(v) do
    c._wmessage_int(self, k, v)
  end
end

_writer[1] = function(msg)
  return _writer.int
end
_writer[2] = function(msg)
  return _writer.real
end
_writer[3] = function(msg)
  return _writer.bool
end
_writer[4] = function(msg)
  return _writer.int
end
_writer[5] = function(msg)
  return _writer.string
end
_writer[6] = function(msg)
  local message = _writer.message
  return function(self, key, v)
    return message(self, key, v, msg)
  end
end
_writer[7] = _writer[1]
_writer[8] = _writer[1]
_writer[9] = _writer[5]
_writer[10] = _writer[7]
_writer[11] = _writer[7]
_writer[129] = function(msg)
  return _writer.int_repeated
end
_writer[130] = function(msg)
  return _writer.real_repeated
end
_writer[131] = function(msg)
  return _writer.bool_repeated
end
_writer[132] = function(msg)
  return _writer.int_repeated
end
_writer[133] = function(msg)
  return _writer.string_repeated
end
_writer[134] = function(msg)
  local message = _writer.message_repeated
  return function(self, key, v)
    return message(self, key, v, msg)
  end
end
_writer[135] = _writer[129]
_writer[136] = _writer[129]
_writer[137] = _writer[133]
_writer[138] = _writer[135]
_writer[139] = _writer[135]
local _encode_type_meta = {}

function _encode_type_meta:__index(key)
  local t, msg = c._env_type(P, self._CType, key)
  local func
  if t ~= 0 then
    func = _writer[t](msg)
    self[key] = func
    return func
  else
    return function()
    end
  end
end

setmetatable(encode_type_cache, {
  __index = function(self, key)
    local v = setmetatable({_CType = key}, _encode_type_meta)
    self[key] = v
    return v
  end
})

function M.encode(message, t, func, ...)
  local encoder = c._wmessage_new(P, message)
  assert(encoder, message)
  encode_message(encoder, message, t)
  if func then
    local buffer, len = c._wmessage_buffer(encoder)
    local ret = func(buffer, len, ...)
    c._wmessage_delete(encoder)
    return ret
  else
    local s = c._wmessage_buffer_string(encoder)
    c._wmessage_delete(encoder)
    return s
  end
end

local _pattern_type = {
  [1] = {"%d", "i"},
  [2] = {"%F", "r"},
  [3] = {"%d", "b"},
  [5] = {"%s", "s"},
  [6] = {"%s", "m"},
  [7] = {"%D", "d"},
  [129] = {"%a", "I"},
  [130] = {"%a", "R"},
  [131] = {"%a", "B"},
  [133] = {"%a", "S"},
  [134] = {"%a", "M"},
  [135] = {"%a", "D"}
}
_pattern_type[4] = _pattern_type[1]
_pattern_type[8] = _pattern_type[1]
_pattern_type[9] = _pattern_type[5]
_pattern_type[10] = _pattern_type[7]
_pattern_type[11] = _pattern_type[7]
_pattern_type[132] = _pattern_type[129]
_pattern_type[136] = _pattern_type[129]
_pattern_type[137] = _pattern_type[133]
_pattern_type[138] = _pattern_type[135]
_pattern_type[139] = _pattern_type[135]
local _pattern_create = function(pattern)
  local iter = string.gmatch(pattern, "[^ ]+")
  local message = iter()
  local cpat = {}
  local lua = {}
  for v in iter, nil, nil do
    local tidx = c._env_type(P, message, v)
    local t = _pattern_type[tidx]
    assert(t, tidx)
    tinsert(cpat, v .. " " .. t[1])
    tinsert(lua, t[2])
  end
  local cobj = c._pattern_new(P, message, "@" .. table.concat(cpat, " "))
  if cobj == nil then
    return
  end
  c._add_pattern(GC, cobj)
  local pat = {
    CObj = cobj,
    format = table.concat(lua),
    size = 0
  }
  pat.size = c._pattern_size(pat.format)
  return pat
end
setmetatable(_pattern_cache, {
  __index = function(t, key)
    local v = _pattern_create(key)
    t[key] = v
    return v
  end
})

function M.unpack(pattern, buffer, length)
  local pat = _pattern_cache[pattern]
  return c._pattern_unpack(pat.CObj, pat.format, pat.size, buffer, length)
end

function M.pack(pattern, ...)
  local pat = _pattern_cache[pattern]
  return c._pattern_pack(pat.CObj, pat.format, pat.size, ...)
end

function M.check(typename, field)
  if field == nil then
    return c._env_type(P, typename)
  else
    return c._env_type(P, typename, field) ~= 0
  end
end

local default_cache = {}
local default_table = function(typename)
  local v = default_cache[typename]
  if v then
    return v
  end
  v = {
    __index = assert(decode_message(typename, ""))
  }
  default_cache[typename] = v
  return v
end
local decode_gettable = function(typename)
  local t = m_fProtobufPoolGetCbOut()
  if not typename then
    return t
  else
    return setmetatable(t, default_table(typename))
  end
end

function M.decodePB(typename, buffer, out_table, length)
  local ok = c._decode(P, decode_gettable, out_table, typename, buffer, length)
  if ok then
    return setmetatable(out_table, default_table(typename))
  else
    return false, c._last_error(P)
  end
end

function M.decodePB2(typename, address, offset, len, out_table)
  local ok = c._decode(P, decode_gettable, out_table, typename, address, offset, len)
  if ok then
    return setmetatable(out_table, default_table(typename))
  else
    return false, c._last_error(P)
  end
end

local function set_default(typename, tbl)
  for k, v in pairs(tbl) do
    if type(v) == "table" then
      local t, msg = c._env_type(P, typename, k)
      if t == 6 then
        set_default(msg, v)
      elseif t == 134 then
        for _, v in ipairs(v) do
          set_default(msg, v)
        end
      end
    end
  end
  return setmetatable(tbl, default_table(typename))
end

function M.register(buffer)
  c._env_register(P, buffer)
end

M.default = set_default
local create_default_table = function(typename)
  return {
    __index = assert(decode_message(typename, ""))
  }
end

function M.debug_create_message(typename, buffer, length)
  local out_table = {}
  local ok = c._decode(P, function()
    return setmetatable({}, create_default_table(typename))
  end, out_table, typename, buffer, length)
  if ok then
    return setmetatable(out_table, create_default_table(typename))
  else
    return false, c._last_error(P)
  end
end

function M.debug_create_message2(typename)
  return setmetatable({}, create_default_table(typename))
end

return M
