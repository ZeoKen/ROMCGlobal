FunctionServerForbidTable = class("FunctionServerForbidTable")

function FunctionServerForbidTable.Me()
  if nil == FunctionServerForbidTable.me then
    FunctionServerForbidTable.me = FunctionServerForbidTable.new()
  end
  return FunctionServerForbidTable.me
end

function FunctionServerForbidTable:ctor()
  self.executed = false
end

function FunctionServerForbidTable:IsExecuted()
  return self.executed
end

function FunctionServerForbidTable:TryExecute()
  if not self.executed and ServerTime.CurServerTime() then
    ServantRaidStatProxy.Instance:PreprocessServantRaidData(true)
    FunctionServerForbidTable.DoServerForbidTable()
    self.executed = true
  end
end

function FunctionServerForbidTable:TryRestore()
  if self.executed then
    FunctionServerForbidTable.RestoreTable()
    self.executed = false
  end
end

function FunctionServerForbidTable.DoServerForbidTable()
  FunctionServerForbidTable.ServerForbid_Table("Deposit")
  FunctionServerForbidTable.ServerForbid_Table("DungeonManual")
end

function FunctionServerForbidTable.RestoreTable()
  FunctionServerForbidTable.Restore_Table("Deposit")
  FunctionServerForbidTable.Restore_Table("DungeonManual")
end

local ServerForbidCheck = function(v)
  return v and (not v.FuncState or FunctionUnLockFunc.checkFuncStateValid(v.FuncState))
end

function FunctionServerForbidTable.ServerForbid_Table(Name)
  if not Name then
    return
  end
  local Table_Name = "Table_" .. Name
  local Table = _G[Table_Name]
  if not Table then
    return
  end
  if not rawget(Table, "__ori_table") then
    local mt = {
      __index = function(t, k)
        local p = Table[k]
        if ServerForbidCheck(p) then
          return p
        end
      end,
      __new_index = function(t, k, v)
        redlog("table modification is not allowed!")
      end,
      __pairs = function(t)
        return function(t, k)
          local v
          repeat
            k, v = next(Table, k)
          until k == nil or ServerForbidCheck(v)
          return k, v
        end, t, nil
      end
    }
    _G[Table_Name] = {__ori_table = Table}
    setmetatable(_G[Table_Name], mt)
  end
end

function FunctionServerForbidTable.Restore_Table(Name)
  if not Name then
    return
  end
  local Table_Name = "Table_" .. Name
  local Table = _G[Table_Name]
  if not Table then
    return
  end
  local ori = rawget(Table, "__ori_table")
  if ori then
    _G[Table_Name] = ori
    local mt = getmetatable(Table)
    mt = nil
    Table = nil
  end
end
