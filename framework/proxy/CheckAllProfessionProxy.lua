CheckAllProfessionProxy = class("CheckAllProfessionProxy", pm.Proxy)
CheckAllProfessionProxy.Instance = nil
CheckAllProfessionProxy.NAME = "CheckAllProfessionProxy"
local tempTable = {}

function CheckAllProfessionProxy:ctor(proxyName, data)
  self.proxyName = proxyName or CheckAllProfessionProxy.NAME
  if CheckAllProfessionProxy.Instance == nil then
    CheckAllProfessionProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
  self:AddEvts()
end

function CheckAllProfessionProxy:Init()
end

function CheckAllProfessionProxy:AddEvts()
end

function CheckAllProfessionProxy:GetCellFirstRowTable(heroInclude)
  tempTable = {}
  for k, v in pairs(Table_Class) do
    if ProfessionProxy.GetJobDepth(v.id) == 1 then
      table.insert(tempTable, v)
    end
  end
  local spJob
  for i = 1, #ProfessionProxy.specialJobs do
    spJob = ProfessionProxy.specialJobs[i]
    if heroInclude or Table_Class[spJob] and not Table_Class[spJob].FeatureSkill then
      table.insert(tempTable, Table_Class[spJob])
    else
      helplog("当前class表中没有", spJob)
    end
  end
  local forbidProf = ProfessionProxy.GetBannedProfessions()
  if forbidProf then
    for i = #tempTable, 1, -1 do
      if tempTable[i] and nil ~= forbidProf[tempTable[i].id] then
        table.remove(tempTable, i)
      end
    end
  end
  local S_data = ProfessionProxy.Instance:GetProfessionQueryUserTable()
  local checkCanOpen = function(menuId)
    if not FunctionUnLockFunc.Me():CheckCanOpen(menuId) then
      local menuData = Table_Menu[menuId]
      if menuData and menuData.event and menuData.event.type == "unlockprofession" then
        forbidProf = menuData.event.param
      end
      if forbidProf then
        for i = #tempTable, 1, -1 do
          local typeBranch = tempTable[i].TypeBranch
          if not S_data[typeBranch] and tempTable[i] and TableUtility.ArrayFindIndex(forbidProf, tempTable[i].id) > 0 then
            table.remove(tempTable, i)
          end
        end
      end
    end
  end
  for _, menuId in pairs(GameConfig.MenuUnlockProfession or {}) do
    checkCanOpen(menuId)
  end
  if ProfessionProxy.IsDoramForbidden() then
    for i = #tempTable, 1, -1 do
      if tempTable[i] and tempTable[i].Race == ECHARRACE.ECHARRACE_CAT then
        table.remove(tempTable, i)
      end
    end
  end
  table.sort(tempTable, function(a, b)
    local ax = a.Type - (ProfessionProxy.IsDoramRace(a.id) and 10000 or 0)
    local bx = b.Type - (ProfessionProxy.IsDoramRace(b.id) and 10000 or 0)
    return ax < bx
  end)
  return tempTable
end
