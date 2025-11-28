BigWorldData = reusableClass("BigWorldData")
BigWorldData.PoolSize = 5

function BigWorldData:ctor()
  BigWorldData.super.ctor(self)
  self.position = LuaVector3()
end

function BigWorldData:SetServerData(serverdata)
  self.guid = serverdata.guid
  self.ID = serverdata.npcid
  self.uniqueID = serverdata.uniqueid
  self.position = ProtolUtility.Better_S2C_Vector3(serverdata.pos, self.position)
  self.cellIndex = BigWorld.BigWorldManager.ConvertPositionToMonsterCellIndex(self.position)
  self.dir = serverdata.dir / 1000
  self.waitaction = serverdata.waitaction
end

function BigWorldData:SetSceneInfo(sceneinfo)
  self.ID = sceneinfo.ID
  self.uniqueID = sceneinfo.uniqueID
  local position = sceneinfo.position
  self.position:Set(position[1], position[2], position[3])
  self.cellIndex = BigWorld.BigWorldManager.ConvertPositionToMonsterCellIndex(self.position)
  self.dir = sceneinfo.dir
  self.waitaction = sceneinfo.waitaction
end

function BigWorldData:DoConstruct(asArray)
  BigWorldData.super.DoConstruct(self, asArray)
end

function BigWorldData:DoDeconstruct(asArray)
  self.guid = nil
  self.ID = nil
  self.uniqueID = nil
  self.cellIndex = nil
  self.dir = nil
  self.waitaction = nil
  BigWorldData.super.DoDeconstruct(self, asArray)
end
