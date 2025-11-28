MsgParserProxy = class("MsgParserProxy", pm.Proxy)
MsgParserProxy.Instance = nil
MsgParserProxy.NAME = "MsgParserProxy"

function MsgParserProxy:ctor(proxyName, data)
  self.proxyName = proxyName or MsgParserProxy.NAME
  if MsgParserProxy.Instance == nil then
    MsgParserProxy.Instance = self
  end
  self:InitPatterns()
end

function MsgParserProxy:InitPatterns()
  self.myName = "%[PlayerName%]"
  self.upAdvLvCost = "%[UpAdvLvCost%]"
  self.itemPattern = "({item=(%d+)(,-)(%d-)})"
  self.npcPattern = "({npc=(%d+)(,-)(%d-)})"
  self.mapPattern = "({map=(%d+)})"
  self.questPattern = "({quest=(%d+)})"
  self.countDownPattern = "({countDown=(%d+)(,-)(%d-)})"
  self.iconPattern = "({(%w+)icon=(%w+)(_-)(%w-)})"
  self.singleIconPattern = "(%w+)=(%w+_*%w*)"
  self.ilItemPattern = "({ilitem=(%d+)(,-)(%x-)})"
  self.equipPosPattern = "({equippos=(%d+)(,-)(%d-)})"
  self.cardPattern = "({card=(%d+)(,-)(%d+)(,-)(%d+)})"
  self.msgHandler = {
    [24000] = self.OpenUserCenter
  }
end

function MsgParserProxy:ParseIlItemInfo(text, urlColor)
  return string.gsub(text, "{%g-}", function(s)
    local found, itemId, _, color = string.match(s, self.ilItemPattern)
    if found and itemId then
      local itemConfig = Table_Item[tonumber(itemId)]
      if itemConfig then
        if not urlColor then
          if color ~= nil and color ~= "" then
            urlColor = color
          else
            urlColor = "1F74BF"
          end
        end
        return string.format(ChatRoomProxy.ItemColorLabel, urlColor, "configitem;" .. itemId, itemConfig.NameZh)
      end
    end
    return s
  end)
end

function MsgParserProxy:GetIconInfo(text)
  return string.match(text, self.singleIconPattern)
end

function MsgParserProxy:ReplaceIconInfo(text, replace)
  replace = replace or ""
  return string.gsub(text, self.iconPattern, replace)
end

function MsgParserProxy:TryParse(text, ...)
  text = OverSea.LangManager.Instance():GetLangByKey(text)
  local params
  text, params = self:ParseMultiItemPattern(text, ...)
  local isError
  text, isError = self:ReplaceDynamicParams(text, unpack(params))
  return self:DoParse(text), isError
end

local function GetMatchPatternTimes(text, pattern, index)
  local s, e = string.find(text, pattern, index)
  if e then
    return GetMatchPatternTimes(text, pattern, e) + 1
  end
  return 0
end

function MsgParserProxy:ReplaceDynamicParams(text, ...)
  local textNum = GetMatchPatternTimes(text, "%%s+", 1)
  if (...) ~= nil and textNum ~= 0 then
    local argLength = select("#", ...)
    if argLength == textNum then
      return string.format(text, ...)
    else
      printRed(string.format("MsgParserProxy ReplaceDynamicParams : text = %s , textNum = %s , #arg = %s", tostring(text), tostring(textNum), tostring(argLength)))
      local argStr = {}
      local isError
      for k, v in ipairs({
        ...
      }) do
        table.insert(argStr, v)
      end
      if textNum < argLength then
        for i = argLength, textNum + 1, -1 do
          table.remove(argStr, i)
        end
      elseif textNum > argLength then
        for i = 1, textNum - argLength do
          table.insert(argStr, argLength + i, "(缺少参数)")
        end
        isError = true
      end
      return string.format(text, unpack(argStr)), isError
    end
  else
    return text
  end
end

function MsgParserProxy:ParseMultiItemPattern(text, ...)
  local params = {
    ...
  }
  local i1, i2 = string.find(text, "{multiitemnum=%d}", 1, true)
  if i1 and i2 then
    local subStr = string.sub(text, 1, i1 - 1)
    if not StringUtil.IsEmpty(subStr) then
      local patternNum = GetMatchPatternTimes(subStr, "%%%l+", 1)
      local multiItemNumParam = tonumber(table.remove(params, patternNum + 1))
      text = string.gsub(text, "{ilitem=%%s}%*%%s", function(s)
        local str = ""
        for i = 1, multiItemNumParam do
          str = str .. s
          if i < multiItemNumParam then
            str = str .. ","
          end
        end
        return str
      end)
      text = string.gsub(text, "{multiitemnum=%%d}", "")
    end
  end
  return text, params
end

local str, id, split, num, replaceStr

function MsgParserProxy:_ReplaceItemPattern(text)
  str, id, split, num = string.match(text, self.itemPattern)
  if str then
    replaceStr = self:GetItemNameWithQuality(id, num)
    if replaceStr ~= nil then
      text = string.gsub(text, str, replaceStr)
      return self:_ReplaceItemPattern(text)
    end
  end
  return text
end

function MsgParserProxy:_ReplaceNpcPattern(text)
  str, id, split, num = string.match(text, self.npcPattern)
  if str then
    replaceStr = self:GetNpcNameWithQuality(id, num)
    if replaceStr ~= nil then
      text = string.gsub(text, str, replaceStr)
      return self:_ReplaceNpcPattern(text)
    end
  end
  return text
end

function MsgParserProxy:_ReplaceMapPattern(text)
  str, id = string.match(text, self.mapPattern)
  if str then
    replaceStr = self:GetMapName(id)
    if replaceStr ~= nil then
      text = string.gsub(text, str, replaceStr)
      return self:_ReplaceMapPattern(text)
    end
  end
  return text
end

function MsgParserProxy:_ReplaceQuestPattern(text)
  str, id, split, num = string.match(text, self.questPattern)
  if str then
    replaceStr = self:GetQuestName(id)
    if replaceStr ~= nil then
      text = string.gsub(text, str, replaceStr)
      return self:_ReplaceQuestPattern(text)
    end
  end
  return text
end

function MsgParserProxy:_ReplaceEquipPosPattern(text)
  str, id = string.match(text, self.equipPosPattern)
  if str then
    replaceStr = self:GetEquipPosStr(id, num)
    if replaceStr ~= nil then
      text = string.gsub(text, str, replaceStr)
      return self:_ReplaceEquipPosPattern(text)
    end
  end
  return text
end

function MsgParserProxy:_ReplaceCardPattern(text)
  local str, itemId, _, count, _, level = string.match(text, self.cardPattern)
  if str then
    replaceStr = self:GetCardNameWithQuality(itemId, count, level)
    if replaceStr ~= nil then
      text = string.gsub(text, str, replaceStr)
      return self:_ReplaceCardPattern(text)
    end
  end
  return text
end

local _ReplaceItemPattern = MsgParserProxy._ReplaceItemPattern
local _ReplaceNpcPattern = MsgParserProxy._ReplaceNpcPattern
local _ReplaceMapPattern = MsgParserProxy._ReplaceMapPattern
local _ReplaceQuestPattern = MsgParserProxy._ReplaceQuestPattern
local _ReplaceEquipPosPattern = MsgParserProxy._ReplaceEquipPosPattern
local _ReplaceCardPattern = MsgParserProxy._ReplaceCardPattern

function MsgParserProxy:DoParse(text)
  text = _ReplaceItemPattern(self, text)
  text = _ReplaceNpcPattern(self, text)
  text = _ReplaceMapPattern(self, text)
  text = _ReplaceQuestPattern(self, text)
  text = _ReplaceEquipPosPattern(self, text)
  text = _ReplaceCardPattern(self, text)
  text = StringUtil.Replace(text, self.myName, self:GetMyName())
  text = StringUtil.Replace(text, self.upAdvLvCost, self:GetUpAdvLvCostStr())
  return text
end

function MsgParserProxy:TryParseCountDown(text, isHideTime)
  local data
  for str, time, split, num in string.gmatch(text, self.countDownPattern) do
    if isHideTime then
      text = string.gsub(text, str, "")
    else
      text = string.gsub(text, str, "%%s")
    end
    data = {
      time = tonumber(time),
      decimal = num ~= nil and tonumber(num) or 0,
      isHideTime = isHideTime
    }
  end
  return text, data
end

function MsgParserProxy:GetQuestName(id)
  local data = QuestProxy.Instance:getStaticDataById(id)
  if data ~= nil then
    return data.Name
  end
  return nil
end

function MsgParserProxy:GetMapName(id)
  local data = Table_Map[tonumber(id)]
  if data ~= nil then
    return data.NameZh
  end
  return nil
end

function MsgParserProxy:GetCachedItemNameWithQuality(id)
  local data = Table_Item[tonumber(id)]
  if data ~= nil then
    if data.customColorName == nil then
      data.customColorName = ItemQualityColor[data.Quality] .. data.NameZh .. "[-]"
    end
    return data.customColorName
  end
  return nil
end

function MsgParserProxy:GetItemNameWithQuality(id, num)
  local data = Table_Item[tonumber(id)]
  if data ~= nil then
    local numStr = ""
    if num ~= nil and num ~= "" then
      numStr = "×" .. num
    end
    if data.Quality == 1 then
      return ItemQualityColor[data.Quality] .. data.NameZh .. numStr .. "[-]"
    end
    return "[c]" .. ItemQualityColor[data.Quality] .. data.NameZh .. numStr .. "[-][/c]"
  end
  return nil
end

function MsgParserProxy:GetNpcNameWithQuality(id, num)
  local data = Table_Npc[tonumber(id)]
  if data ~= nil then
    local numStr = ""
    if num ~= nil and num ~= "" then
      numStr = "×" .. num
    end
    return data.NameZh .. numStr
  end
  return nil
end

function MsgParserProxy:GetMyName()
  if self.myself == nil then
    self.myself = Game.Myself
  end
  if self.myself and self.myself.data then
    return self.myself.data:GetName()
  end
  return "我"
end

function MsgParserProxy:GetUpAdvLvCostStr()
  local result = ""
  if self.myself == nil then
    self.myself = Game.Myself
  end
  if self.myself then
    local nowAdvlv = AdventureDataProxy.Instance:getManualLevel()
    local cost = nowAdvlv and Table_AdventureLevel[nowAdvlv] and Table_AdventureLevel[nowAdvlv].Item
    if cost then
      local id = cost.id
      local num = cost.num
      if Table_Item[id] and num then
        result = num .. Table_Item[id].NameZh
      end
    end
  end
  return result
end

function MsgParserProxy:GetEquipPosStr(id, num)
  local nameConfig = GameConfig.EquipPosName
  local str = nameConfig and nameConfig[tonumber(id)] or "?"
  return str
end

function MsgParserProxy:GetCardNameWithQuality(itemId, count, level)
  local data = Table_Item[tonumber(itemId)]
  if data ~= nil then
    local countStr = ""
    if count ~= nil and count ~= "" then
      countStr = "×" .. count
    end
    local levelStr = ""
    if level ~= nil and level ~= "" and tonumber(level) > 0 then
      levelStr = "+" .. level
    end
    local quality = not StringUtil.IsEmpty(level) and tonumber(level) >= 5 and 5 or data.Quality
    if quality == 1 then
      return ItemQualityColor[quality] .. levelStr .. data.NameZh .. countStr .. "[-]"
    end
    return "[c]" .. ItemQualityColor[quality] .. levelStr .. data.NameZh .. countStr .. "[-][/c]"
  end
  return nil
end

function MsgParserProxy:GetMsgHandler(id)
  return self.msgHandler[id]
end

function MsgParserProxy:OpenUserCenter()
  FunctionSecurity.Me():TryDoRealNameCentify()
end
