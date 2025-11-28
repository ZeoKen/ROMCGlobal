PhotoStandBriefData = class("PhotoStandBriefData")

function PhotoStandBriefData:ctor(idx)
  self.id = nil
  self.accid = nil
  self.idx = idx
end

function PhotoStandBriefData:Server_SetBaseData(serverData)
  self.id = serverData.id
  self.accid = serverData.accid
end

function PhotoStandBriefData:TryGetPicData()
  if not self.id or not self.accid then
    redlog("TryGetPicData", "not inited yet")
    return
  end
  return PhotoStandProxy.Instance:_GetPicData(self.id, self.accid)
end
