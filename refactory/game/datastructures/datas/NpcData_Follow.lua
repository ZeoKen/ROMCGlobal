function NpcData:CanGetOnCarrier()
  return self.followData and self.followData.RideVehicle and self.followData.RideVehicle == 1 or false
end

function NpcData:GetFollowEP()
  return self.followData and self.followData.FollowEP or 0
end

function NpcData:GetFollowType()
  return self.followData and self.followData.FollowType or 0
end

function NpcData:GetInnerRange()
  return self.followData and self.followData.FollowDistance_Stop or 0
end

function NpcData:GetOutterRange()
  return self.followData and self.followData.FollowDistance_Start or 0
end

function NpcData:GetOutterHeight()
  return self.followData and self.followData.FollowHighly or 0
end

function NpcData:GetDampDuration()
  return self.followData and self.followData.FollowEasingTime or 0
end
