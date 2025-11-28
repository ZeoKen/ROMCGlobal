ActionUtility = class("ActionUtility")
local nameHashMap = {}
local nameWithPrefixMap = {}
local nameWithSuffixMap = {}
local nameWithPrefixSuffixMap = {}
local NameSeparator = "_"
local tempArray = {}
local _BuildName_1 = function(name, prefix)
  local tempArray = tempArray
  tempArray[1] = prefix
  tempArray[2] = name
  return table.concat(tempArray, NameSeparator, 1, 2)
end
local _BuildName_2 = function(name, suffix)
  local tempArray = tempArray
  tempArray[1] = name
  tempArray[2] = suffix
  return table.concat(tempArray, NameSeparator, 1, 2)
end
local _BuildName_3 = function(name, prefix, suffix)
  local tempArray = tempArray
  tempArray[1] = prefix
  tempArray[2] = name
  tempArray[3] = suffix
  return table.concat(tempArray, NameSeparator, 1, 3)
end

function ActionUtility.GetNameHash(name)
  local nameHash = nameHashMap[name]
  if nil == nameHash then
    nameHash = Animator.StringToHash(name)
    nameHashMap[name] = nameHash
  end
  return nameHash
end

function ActionUtility.BuildName(name, prefix, suffix)
  if nil ~= prefix and nil ~= suffix then
    local map = nameWithPrefixSuffixMap
    local info = map[name]
    if nil ~= info then
      local subInfo = info[prefix]
      if nil ~= subInfo then
        local fullName = subInfo[suffix]
        if nil == fullName then
          fullName = _BuildName_3(name, prefix, suffix)
          subInfo[suffix] = fullName
        end
        return fullName
      else
        subInfo = {}
        local fullName = _BuildName_3(name, prefix, suffix)
        subInfo[suffix] = fullName
        info[prefix] = subInfo
        return fullName
      end
    else
      local subInfo = {}
      local fullName = _BuildName_3(name, prefix, suffix)
      subInfo[suffix] = fullName
      info = {}
      info[prefix] = subInfo
      map[name] = info
      return fullName
    end
  elseif nil ~= prefix then
    local map = nameWithPrefixMap
    local info = map[name]
    if nil ~= info then
      local fullName = info[prefix]
      if nil == fullName then
        fullName = _BuildName_1(name, prefix)
        info[prefix] = fullName
      end
      return fullName
    else
      info = {}
      local fullName = _BuildName_1(name, prefix)
      info[prefix] = fullName
      map[name] = info
      return fullName
    end
  elseif nil ~= suffix then
    local map = nameWithSuffixMap
    local info = map[name]
    if nil ~= info then
      local fullName = info[suffix]
      if nil == fullName then
        fullName = _BuildName_2(name, suffix)
        info[suffix] = fullName
      end
      return fullName
    else
      info = {}
      local fullName = _BuildName_2(name, suffix)
      info[suffix] = fullName
      map[name] = info
      return fullName
    end
  end
  return name
end
