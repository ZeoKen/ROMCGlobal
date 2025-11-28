DateUtil = {}

function DateUtil.ParseHHMMSSBySeconds(seconds)
  local hh = ""
  local mm = ""
  local ss = ""
  local hours = math.floor(seconds / 3600)
  if 0 < hours then
    seconds = seconds - hours * 3600
    hh = string.format("%02d:", hours)
  end
  local minutes = math.floor(seconds / 60)
  if 0 < minutes then
    seconds = seconds - minutes * 60
    mm = string.format("%02d:", minutes)
  end
  ss = string.format("%02d", seconds)
  return hh .. mm .. ss
end

function DateUtil.ParseHHMMSSBySecondsV2(seconds)
  local hours = math.floor(seconds / 3600)
  seconds = seconds - hours * 3600
  local minutes = math.floor(seconds / 60)
  seconds = seconds - minutes * 60
  return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

function DateUtil.GetConstellation(month, day)
  if month == 2 and 19 <= day or month == 3 and day <= 20 then
    return 1
  elseif month == 3 and 21 <= day or month == 4 and day <= 19 then
    return 2
  elseif month == 4 and 20 <= day or month == 5 and day <= 20 then
    return 3
  elseif month == 5 and 21 <= day or month == 6 and day <= 21 then
    return 4
  elseif month == 6 and 22 <= day or month == 7 and day <= 22 then
    return 5
  elseif month == 7 and 23 <= day or month == 8 and day <= 22 then
    return 6
  elseif month == 8 and 23 <= day or month == 9 and day <= 22 then
    return 7
  elseif month == 9 and 23 <= day or month == 10 and day <= 23 then
    return 8
  elseif month == 10 and 24 <= day or month == 11 and day <= 22 then
    return 9
  elseif month == 11 and 23 <= day or month == 12 and day <= 21 then
    return 10
  elseif month == 12 and 22 <= day or month == 1 and day <= 19 then
    return 11
  elseif month == 1 and 20 <= day or month == 2 and day <= 18 then
    return 12
  end
end
