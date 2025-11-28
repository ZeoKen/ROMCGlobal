autoImport("PetEggInfo")
PetHouseData = class("PetHouseData")

function PetHouseData:ctor(server_data)
  self.staticData = GameConfig.Home.PetFurniture or {
    Pos = {
      {100, 0},
      {100, 0},
      {100, 2000}
    },
    ExtraExp = 20,
    ExtraFriendlyExp = 20,
    Interval = 3600
  }
  self:Server_SetData(server_data)
end

function PetHouseData:Server_SetData(serviceData)
  self.index = serviceData.index + 1
  self.unlock = serviceData.unlock
  if nil ~= serviceData.pet and not StringUtil.IsEmpty(serviceData.pet.name) then
    self.petEgg = PetEggInfo.new()
    self.petEgg:Server_SetData(serviceData.pet)
    if not self.petCreature then
      local myPos = Game.Myself:GetPosition()
      local mStaticData = Table_Monster[self.petEgg.petid]
      local bodyID = mStaticData.Body
      local modelScale = mStaticData.Scale and mStaticData.Scale * 100 or 100
      local fakeData = {}
      fakeData.id = self.index
      fakeData.name = self.petEgg.name
      fakeData.pos = {
        x = 0,
        y = 0,
        z = 0
      }
      fakeData.datas = {
        {
          type = ProtoCommon_pb.EUSERDATATYPE_BODY,
          value = bodyID
        },
        {
          type = ProtoCommon_pb.EUSERDATATYPE_BODYSCALE,
          value = modelScale
        }
      }
      fakeData.attrs = {}
      fakeData.mounts = {}
      fakeData.npcID = self.petEgg.petid
      self.petCreature = NPet.CreateAsTable(fakeData)
      self.petCreature:_ReDress()
      local fakeParts = self.petEgg:GetFakeParts()
      if self.petCreature.assetRole then
        self.petCreature.assetRole:Redress(fakeParts)
      else
        self.petCreature.assetRole = Asset_Role.Create(fakeParts)
      end
      self.petCreature.assetRole:SetPosition(myPos)
      self.petCreature.assetRole:SetScale(modelScale)
      self.petCreature.ai:DOPatrol(self.petCreature)
      Asset_Role.DestroyPartArray(fakeParts)
    end
  else
    self:ClearPetRole()
    self.petEgg = nil
  end
  self:SetCost()
end

function PetHouseData:ClearPetRole()
  if self.petCreature then
    self.petCreature:DoDeconstruct()
    self.petCreature = nil
  end
end

function PetHouseData:GetPetName()
  return self.petEgg and self.petEgg.name
end

function PetHouseData:GetCurPetGuid()
  return self.petEgg and self.petEgg.guid
end

function PetHouseData:GetPetLv()
  return self.petEgg and self.petEgg.lv
end

function PetHouseData:GetPetFriendlyLv()
  return self.petEgg and self.petEgg.friendlv
end

function PetHouseData:SetCost()
  if not (self.staticData and self.staticData.Pos and self.index) or self.index <= 0 or self.index > #self.staticData.Pos then
    return
  end
  local costArray = self.staticData.Pos[self.index]
  if #costArray ~= 2 then
    return
  end
  self.cost = costArray[1]
  self.costNum = costArray[2]
end
