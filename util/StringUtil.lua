StringUtil = {}
autoImport("support_unicode")

function StringUtil.utf8_tail(n, k)
  local u, r = ""
  for i = 1, k do
    n, r = math.floor(n / 64), n % 64
    u = string.char(r + 128) .. u
  end
  return u, n
end

function StringUtil.to_utf8(a)
  local n, r, u = tonumber(a)
  if n < 128 then
    return string.char(n)
  elseif n < 2048 then
    u, n = StringUtil.utf8_tail(n, 1)
    return string.char(n + 192) .. u
  elseif n < 65536 then
    u, n = StringUtil.utf8_tail(n, 2)
    return string.char(n + 224) .. u
  elseif n < 2097152 then
    u, n = StringUtil.utf8_tail(n, 3)
    return string.char(n + 240) .. u
  elseif n < 67108864 then
    u, n = StringUtil.utf8_tail(n, 4)
    return string.char(n + 248) .. u
  else
    u, n = StringUtil.utf8_tail(n, 5)
    return string.char(n + 252) .. u
  end
end

function StringUtil.sto_utf8(s)
  return string.gsub(s, "&#(%d+);", StringUtil.to_utf8)
end

local tab = {}

function StringUtil.getTextByIndex(str, startIndex, endIndex)
  if endIndex and endIndex < startIndex then
    printRed("error!startIndex can't bigger endIndex")
    return ""
  end
  TableUtility.ArrayClear(tab)
  for uchar in string.gmatch(str, "[%z\001-\127�-�][�-�]*") do
    tab[#tab + 1] = uchar
  end
  endIndex = not (endIndex and endIndex > #tab) and endIndex or #tab
  return table.concat(tab, "", startIndex, endIndex)
end

function StringUtil.getTextLen(str)
  if str == nil then
    redlog("str is nil")
    return 0
  end
  local lenInByte = #str
  local len = 0
  local i = 1
  local curByte
  local byteCount = 1
  while lenInByte >= i do
    curByte = string.byte(str, i)
    if 0 < curByte and curByte <= 127 then
      byteCount = 1
    elseif 128 <= curByte and curByte <= 223 then
      byteCount = 2
    elseif 224 <= curByte and curByte <= 239 then
      byteCount = 3
    elseif 240 <= curByte and curByte <= 247 then
      byteCount = 4
    end
    i = i + byteCount
    len = len + 1
  end
  return len
end

function StringUtil.StringToCharArray(str, tempArray)
  tempArray = tempArray or {}
  for uchar in string.gmatch(str, "[%z\001-\127�-�][�-�]*") do
    tempArray[#tempArray + 1] = uchar
  end
  return tempArray
end

function StringUtil.SubString(str, startIndex, length)
  local maxIndex = math.max(StringUtil.ChLength(str), startIndex + length - 1)
  return StringUtil.Sub(str, startIndex, maxIndex)
end

function StringUtil.Sub(str, startIndex, endIndex)
  local dropping = string.byte(str, endIndex + 1)
  if not dropping then
    return str
  end
  if 128 <= dropping and dropping < 192 then
    return StringUtil.Sub(str, startIndex, endIndex - 1)
  end
  return string.sub(str, startIndex, endIndex)
end

function StringUtil.ChLength(str)
  return #string.gsub(str, "[�-�][�-�]", " ")
end

function StringUtil.AnalyzeDialogOptionConfig(str)
  local optionformat = "(%{([^%{%}]+)%,(%d+)%})"
  local result = {}
  for _, text, id in string.gmatch(str, optionformat) do
    local optionConfig = {}
    optionConfig.id = tonumber(id)
    optionConfig.text = text
    table.insert(result, optionConfig)
  end
  if #result == 0 then
    local optionConfig = {}
    optionConfig.text = str
    optionConfig.id = 0
    table.insert(result, optionConfig)
  end
  return result
end

function StringUtil.Split(str, delimiter)
  if str == nil or str == "" or delimiter == nil then
    return nil
  end
  local result = {}
  for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
    table.insert(result, match)
  end
  return result
end

function StringUtil.Json2Lua(str)
  local luaString = LuaUtils.JsonToLua(str)
  if nil ~= luaString then
    luaString = "return " .. luaString
    local luaFunc = loadstring(luaString)
    if nil ~= luaFunc and type(luaFunc) == "function" then
      local luaObject = luaFunc()
      return luaObject
    end
  else
  end
end

function StringUtil.Lua2Json(tTable, nTabCnt)
  nTabCnt = nTabCnt or 0
  local szJsonStr = "\n"
  assert(type(tTable) == "table", "tTable is not a table.")
  local szTab = ""
  for i = 1, nTabCnt do
    szTab = szTab .. "\t"
  end
  local szKeyType
  for key, value in pairs(tTable) do
    if szKeyType == nil then
      szKeyType = type(key)
      if szKeyType ~= "string" and szKeyType ~= "number" then
        return nil
      end
    end
    if type(key) ~= szKeyType then
      return nil
    end
    szJsonStr = szJsonStr .. "\t" .. szTab
    if szKeyType == "string" then
      szJsonStr = szJsonStr .. string.format("\"%s\" = ", EscDecode(key))
    end
    if type(value) == "table" then
      szJsonStr = szJsonStr .. StringUtil.Lua2Json(value, nTabCnt + 1) .. ",\n"
    else
      if type(value) == "string" then
        value = "\"" .. EscDecode(value) .. "\""
      end
      szJsonStr = szJsonStr .. string.format("%s,\n", value)
    end
  end
  if szJsonStr == "\n" then
    szTab = ""
    szJsonStr = ""
  end
  if szKeyType == "string" then
    return "{" .. szJsonStr .. szTab .. "}"
  else
    return "[" .. szJsonStr .. szTab .. "]"
  end
end

tJson2Lua = {
  ["true"] = {value = true},
  null = {value = nil},
  ["false"] = {value = false}
}
tStr2Esc = {
  ["\\\""] = "\"",
  ["\\f"] = "\f",
  ["\\b"] = "\b",
  ["\\/"] = "/",
  ["\\\\"] = "\\",
  ["\\n"] = "\n",
  ["\\r"] = "\r",
  ["\\t"] = "\t"
}
tEsc2Str = {
  ["\""] = "\\\"",
  ["\f"] = "\\f",
  ["\b"] = "\\b",
  ["/"] = "\\/",
  ["\n"] = "\\n",
  ["\r"] = "\\r",
  ["\t"] = "\\t"
}

function EscEncode(szString)
  for str, esc in pairs(tStr2Esc) do
    szString = string.gsub(szString, str, esc)
  end
  return szString
end

function EscDecode(szString)
  szString = string.gsub(szString, "\\", "\\\\")
  for esc, str in pairs(tEsc2Str) do
    szString = string.gsub(szString, esc, str)
  end
  return szString
end

function StringUtil.Chsize(char)
  if not char then
    return 0
  elseif 240 < char then
    return 4
  elseif 225 < char then
    return 3
  elseif 192 < char then
    return 2
  else
    return 1
  end
end

function StringUtil.Utf8len(str)
  local len = 0
  local currentIndex = 1
  while currentIndex <= #str do
    local char = string.byte(str, currentIndex)
    currentIndex = currentIndex + StringUtil.Chsize(char)
    len = len + 1
  end
  return len
end

function StringUtil.Utf8sub(str, startChar, numChars)
  local startIndex = 1
  while 1 < startChar do
    local char = string.byte(str, startIndex)
    startIndex = startIndex + StringUtil.Chsize(char)
    startChar = startChar - 1
  end
  local currentIndex = startIndex
  while 0 < numChars and currentIndex <= #str do
    local char = string.byte(str, currentIndex)
    currentIndex = currentIndex + StringUtil.Chsize(char)
    numChars = numChars - 1
  end
  return str:sub(startIndex, currentIndex - 1)
end

function StringUtil.Replace(str, searchStr, replaceStr)
  local replaceStr = string.gsub(replaceStr, "%%", "%%%%")
  return string.gsub(str, searchStr, replaceStr)
end

local ntf_tempArray = {}

function StringUtil.NumThousandFormat(num, deperator, showPoint)
  deperator = deperator or ","
  local dir, dirSymbol
  if num < 0 then
    dir = -1
    dirSymbol = "-"
  else
    dir = 1
    dirSymbol = ""
  end
  num = num * dir
  local point
  num, point = math.modf(num)
  if showPoint and 0 < point then
    point = string.format("%.2f", point):sub(2, 4)
  else
    point = ""
  end
  local result = ""
  if num == 0 then
    result = 0 .. point
  else
    while 1000 <= num do
      table.insert(ntf_tempArray, num % 1000)
      num = num // 1000
    end
    if 0 < num then
      table.insert(ntf_tempArray, num)
    end
    local len = #ntf_tempArray
    for i = #ntf_tempArray, 1, -1 do
      if i == len then
        result = ntf_tempArray[len]
      else
        result = string.format("%s%s%03d", result, deperator, ntf_tempArray[i])
      end
      ntf_tempArray[i] = nil
    end
    return dirSymbol .. result .. point
  end
  return result
end

local RomansMap = {
  {1000, "M"},
  {900, "CM"},
  {500, "D"},
  {400, "CD"},
  {100, "C"},
  {90, "XC"},
  {50, "L"},
  {40, "XL"},
  {10, "X"},
  {9, "IX"},
  {5, "V"},
  {4, "IV"},
  {1, "I"}
}

function StringUtil.IntToRoman(num)
  if not num then
    return ""
  end
  local roman, val, let = ""
  for _, v in ipairs(RomansMap) do
    val, let = v[1], v[2]
    while num >= val do
      num = num - val
      roman = roman .. let
    end
  end
  return roman
end

function StringUtil.FormatTime2TimeStamp(formatTime)
  local t = {}
  local ifs = string.split(formatTime, " ")
  local d1 = string.split(ifs[1], "-")
  t.year, t.month, t.day = tonumber(d1[1]), tonumber(d1[2]), tonumber(d1[3])
  local d2 = string.split(ifs[2], ":")
  t.hour, t.min, t.sec = tonumber(d2[1]), tonumber(d2[2]), tonumber(d2[3])
  return os.time(t)
end

local FormatTime2TimeStamp2_s = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
local FormatTime2TimeStamp2_t = {}

function StringUtil.FormatTime2TimeStamp2(formatTime)
  local year, month, day, hour, min, sec = formatTime:match(FormatTime2TimeStamp2_s)
  FormatTime2TimeStamp2_t.year = year
  FormatTime2TimeStamp2_t.month = month
  FormatTime2TimeStamp2_t.day = day
  FormatTime2TimeStamp2_t.hour = hour
  FormatTime2TimeStamp2_t.min = min
  FormatTime2TimeStamp2_t.sec = sec
  return os.time(FormatTime2TimeStamp2_t)
end

local _TimeFormat = "%d-%d-%d %d:%d:%d"

function StringUtil.FormatTimeStamp2NormalTimeStr(timeStamp)
  local t = os.date("*t", timeStamp)
  return string.format(_TimeFormat, t.year, t.month, t.day, t.hour, t.min, t.sec)
end

function StringUtil.IsEmpty(content)
  if not content or content == "" then
    return true
  end
end

function StringUtil.LastIndexOf(content, findStr)
  local found = content:reverse():find(findStr:reverse(), nil, true)
  if found then
    return content:len() - findStr:len() - found + 2
  else
    return found
  end
end

function StringUtil.GetDateData(date)
  local p = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
  return date:match(p)
end

function StringUtil.GetDateDataEx(date)
  local p = "(%d+):(%d+):(%d+)"
  return date:match(p)
end

function StringUtil.ConvertFileSize(fileSize)
  if fileSize == nil then
    return 0
  end
  local size = fileSize / 1024
  local mb_size = 1024
  local gb_size = 1048576
  local tb_size = 1073741824
  if size < mb_size then
    return string.format("%.2f", size), "KB"
  elseif size >= mb_size and size < gb_size then
    return string.format("%.2f", size / mb_size), "MB"
  elseif size >= gb_size and size < tb_size then
    return string.format("%.2f", size / gb_size), "GB"
  else
    return string.format("%.2f", size / tb_size), "TB"
  end
end

function StringUtil.ConvertFileSizeString(fileSize)
  local result, suffix = StringUtil.ConvertFileSize(fileSize)
  return result .. suffix
end

function StringUtil.GetNumberInString(text)
  local start, over = string.find(text, "[0-9]+")
  if start and over then
    return tonumber(string.sub(text, start, over))
  end
end

function StringUtil.HasItemIdToClick(str)
  return not StringUtil.IsEmpty(str) and string.match(str, "%[/itemid%]") ~= nil
end

function StringUtil.AdaptItemIdClickUrl(str, colorStr)
  if StringUtil.IsEmpty(str) then
    return
  end
  colorStr = colorStr or "[0000FF]"
  return string.gsub(str, "%[itemid%](.-)%[/itemid%]", function(str)
    local split = string.split(str, "+")
    local id = tonumber(split[1])
    if not id or not Table_Item[id] then
      return
    end
    local sb = LuaStringBuilder.CreateAsTable()
    sb:Append("[url=itemid=")
    sb:Append(id)
    if split[2] then
      sb:Append("+" .. split[2])
    end
    sb:Append("][u][c]")
    sb:Append(colorStr)
    if split[2] then
      sb:Append("+" .. split[2])
    end
    sb:Append(Table_Item[id].NameZh)
    sb:Append("[-][/c][/u][/url]")
    local s = sb:ToString()
    sb:Destroy()
    return s
  end)
end

function StringUtil.ParseItemsToClickUrl(rewards, colorStr)
  if not rewards then
    return
  end
  colorStr = colorStr or "[0000FF]"
  local sb = LuaStringBuilder.CreateAsTable()
  sb:Append(ZhString.OptionalGiftRewardView_ChooseTip)
  for i = 1, #rewards do
    local itemid = rewards[i][1]
    if Table_Item[itemid] then
      sb:Append("[url=itemid=")
      sb:Append(itemid)
      sb:Append("][u][c]")
      sb:Append(colorStr)
      sb:Append(Table_Item[itemid].NameZh)
      sb:Append("[-][/c][/u][/url]")
      sb:Append("x" .. rewards[i][2])
      if i < #rewards then
        sb:Append(ZhString.ItemTip_ChAnd)
      end
    end
  end
  local s = sb:ToString()
  sb:Destroy()
  return s
end

function StringUtil.HasBufferIdToClick(str)
  return not StringUtil.IsEmpty(str) and string.match(str, "%[/enchantbuff%]") ~= nil
end

function StringUtil.AdaptBuffIdClickUrl(str, colorStr)
  if StringUtil.IsEmpty(str) then
    return
  end
  colorStr = colorStr or "[0000FF]"
  return string.gsub(str, "%[enchantbuff%](%d+)%[/enchantbuff%]", function(id)
    id = tonumber(id)
    local bufferData = Table_Buffer[id]
    local sb = LuaStringBuilder.CreateAsTable()
    sb:Append("[url=enchantbuff=")
    sb:Append(id)
    sb:Append("][u][c]")
    sb:Append(colorStr)
    sb:Append(ZhString.EnchantAttrUp_CombineAttr)
    sb:Append("[-][/c][/u][/url]")
    if bufferData then
      sb:Append(bufferData.BuffName)
      sb:Append(":")
      sb:Append(bufferData.BuffDesc)
    end
    local s = sb:ToString()
    sb:Destroy()
    return s
  end)
end

function StringUtil.HasGotoModeToClick(str)
  return not StringUtil.IsEmpty(str) and string.match(str, "%[/gotomode%]") ~= nil
end

function StringUtil.AdaptGotoModeClickUrl(str, colorStr)
  str = OverSea.LangManager.Instance():GetLangByKey(str)
  if StringUtil.IsEmpty(str) then
    return
  end
  colorStr = colorStr or "[51DCFF]"
  return string.gsub(str, "%[gotomode=(%d+),showicon=(%d+)%]([^%[]+)%[/gotomode%]", function(gotomode, showicon, content)
    gotomode = tonumber(gotomode)
    showicon = tonumber(showicon)
    if not gotomode then
      return
    end
    local sb = LuaStringBuilder.CreateAsTable()
    if showicon and 0 < showicon then
      sb:Append("{uiicon=tips_icon_11}")
    end
    sb:Append("[url=gotomode=")
    sb:Append(gotomode)
    sb:Append("][u][c]")
    sb:Append(colorStr)
    sb:Append(content or "")
    sb:Append("[-][/c][/u][/url]")
    local s = sb:ToString()
    sb:Destroy()
    return s
  end)
end

function StringUtil.CheckTextValidForDisplay(str)
  return CheckTextValidForDisplay(str)
end

function StringUtil.HasCharacter(str, label)
  local font = label.bitmapFont.dynamicFont
  for i = 1, #str do
    local code = string.byte(str, i)
    if not font:HasCharacter(code) then
      return false
    end
  end
  return true
end

function StringUtil.ValidatePhoneNumber(phone)
  if not StringUtil.IsEmpty(phone) and string.match(phone, "^%+?%d[%d%- ]*%d$") then
    return true
  else
    return false
  end
end

function StringUtil.ValidateEmail(email)
  if not StringUtil.IsEmpty(email) and string.match(email, "^[_%w%.%-]+@[%w%.%-]+%.[%a]+%.*%a*$") then
    return true
  else
    return false
  end
end

function StringUtil.ReplaceChars(str, pos, len, symbol)
  local result = ""
  local strLen = string.len(str)
  for i = 1, strLen do
    if pos <= i and i <= pos + len - 1 then
      result = result .. symbol
    else
      result = result .. string.sub(str, i, i)
    end
  end
  return result
end

function StringUtil.ReplacePhoneOrEmail(str)
  local result = str
  if string.find(str, "@") then
    local pos = string.find(str, "@")
    if 2 < pos then
      result = StringUtil.ReplaceChars(str, 3, pos - 3, "*")
    end
  else
    result = StringUtil.ReplaceChars(str, 4, 4, "*")
  end
  return result
end

function StringUtil.AdaptItemPreviewClickUrl(str, colorStr)
  if StringUtil.IsEmpty(str) then
    return
  end
  colorStr = colorStr or "[0000FF]"
  return string.gsub(str, "%[preview%](.-)%[/preview%]", function(des)
    local sb = LuaStringBuilder.CreateAsTable()
    sb:Append("[url=preview=")
    sb:Append("][u][c]")
    sb:Append(colorStr)
    sb:Append(des)
    sb:Append("[-][/c][/u][/url]")
    local s = sb:ToString()
    sb:Destroy()
    return s
  end)
end

function StringUtil.HasPreviewToClick(str)
  return not StringUtil.IsEmpty(str) and string.match(str, "%[/preview%]") ~= nil
end

function StringUtil.FormatMillionNumToStr(num)
  if num < 100000 then
    return tostring(num)
  end
  return string.format("%sM", string.format("%.2f", num / 10000))
end
