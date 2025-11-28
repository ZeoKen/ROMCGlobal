autoImport("EquipsInfoSaveData")
EquipsSaveData = class("EquipsSaveData")

function EquipsSaveData:ctor(serverequipdata, storageId)
  self.storageId = storageId
  self.pacakgeType = serverequipdata.type
  self.equipsSave = {}
  if serverequipdata.datas then
    local n = #serverequipdata.datas
    for i = 1, n do
      local single = EquipsInfoSaveData.new(serverequipdata.datas[i])
      table.insert(self.equipsSave, single)
    end
  end
end

function EquipsSaveData:GetEquipInfos()
  redlog("get self.equipsSave", #self.equipsSave)
  return self.equipsSave
end

function EquipsSaveData:TryGetPersonalArtifact()
  local savedPersonalArtifactGuid, savedPersonalArtifactItemId
  for i = 1, #self.equipsSave do
    if self.equipsSave[i]:IsPersonalArtifactPos() then
      savedPersonalArtifactGuid = self.equipsSave[i].guid
      savedPersonalArtifactItemId = self.equipsSave[i].type_id
      break
    end
  end
  if not savedPersonalArtifactGuid then
    return nil
  end
  local artifactItem = BagProxy.Instance.roleEquip:GetItemByGuid(savedPersonalArtifactGuid)
  artifactItem = artifactItem or BagProxy.Instance.personalArtifactBagData:GetItemByGuid(savedPersonalArtifactGuid)
  if artifactItem then
    return true, savedPersonalArtifactGuid
  else
    return false, savedPersonalArtifactItemId
  end
end
