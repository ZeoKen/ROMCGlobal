autoImport("WildMvpBuffData")
WildMvpBuffGroupData = class("WildMvpBuffGroupData")

function WildMvpBuffGroupData:ctor(groupId, groupName)
  self.id = groupId
  self.name = groupName
  self.datas = {}
end

function WildMvpBuffGroupData:AddBuffDataSorted(staticData, serverData)
  local insertIndex, newData
  for i, v in ipairs(self.datas) do
    if staticData.id == v.id then
      newData = v
      break
    elseif staticData.id < v.id then
      insertIndex = i
      break
    end
  end
  if not newData then
    newData = WildMvpBuffData.new(staticData)
    if insertIndex then
      table.insert(self.datas, insertIndex, newData)
    else
      table.insert(self.datas, newData)
    end
  end
  if serverData then
    newData:SetServerData(serverData)
  end
  return newData
end

function WildMvpBuffGroupData:GetBuffDataById(id)
  for _, v in ipairs(self.datas) do
    if v.id == id then
      return v
    end
  end
end

function WildMvpBuffGroupData:ClearBuffChangedStatus()
  for _, v in ipairs(self.datas) do
    v:ClearBuffChangedStatus()
  end
end

function WildMvpBuffGroupData:ClearBuffDatasExcept(keepDatas)
  if not self.datas then
    return
  end
  if not keepDatas then
    TableUtility.ArrayClear(self.datas)
    return
  end
  for index = #self.datas, 1, -1 do
    local buffData = self.datas[index]
    local findIndex = 0
    for i, v in ipairs(keepDatas) do
      if v.id == buffData.id then
        findIndex = i
        break
      end
    end
    if findIndex == 0 then
      table.remove(self.datas, index)
    end
  end
end

function WildMvpBuffGroupData:IsEmpty()
  return not self.datas or #self.datas <= 0
end
