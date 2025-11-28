autoImport("WildMvpAffixData")
WildMvpAffixGroupData = class("WildMvpAffixGroupData")

function WildMvpAffixGroupData:ctor(groupId, groupName)
  self.id = groupId
  self.name = groupName
  self.datas = {}
end

function WildMvpAffixGroupData:GetDatas()
  return self.datas
end

function WildMvpAffixGroupData:AddDataSorted(staticData)
  local insertIndex
  for i, v in ipairs(self.datas) do
    if staticData.id < v.id then
      insertIndex = i
      break
    end
  end
  local newData = WildMvpAffixData.new(staticData)
  if insertIndex then
    table.insert(self.datas, insertIndex, newData)
  else
    table.insert(self.datas, newData)
  end
  return newData
end

function WildMvpAffixGroupData:GetAffixDataById(affixId)
  for _, v in ipairs(self.datas) do
    if v.id == affixId then
      return v
    end
  end
end
