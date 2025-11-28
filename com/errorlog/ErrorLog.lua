function errorLog(...)
end

function errorLogTest(...)
end

local parseArgs = function(...)
  local args = {
    ...
  }
  if 0 < #args then
    local str = ""
    for i = 1, #args do
      if str ~= "" then
        str = str .. "\t"
      end
      if type(args[i]) == "table" then
        str = str .. string.format("%s:<color=red>%s</color>", i, innerString(args[i]))
      else
        str = str .. string.format("%s:<color=red>%s</color>", i, tostring(args[i]))
      end
    end
    return str
  end
  return "No Error Info."
end

function roerr(...)
  LogUtility.Error(parseArgs(...))
end

function rogoerr(go, ...)
  LogUtility.DebugError(go, parseArgs(...))
end
