TopicTargetData = class("TopicTargetData")
TopicTargetData.EState = {
  Go = SceneUser2_pb.ENOVICE_TARGET_GO,
  Finish = SceneUser2_pb.ENOVICE_TARGET_FINISH,
  Rewarded = SceneUser2_pb.ENOVICE_TARGET_REWARDED
}
local _ESort = {
  Finish = 1,
  Go = 2,
  Rewarded = 3
}

function TopicTargetData:ctor(id)
  self.id = id
  self.staticData = Table_ServantChallenge[id]
  self.progress = 0
  self.state = TopicTargetData.EState.Go
  self.targetNum = self.staticData.TargetNum or 1
  self.titleDesc = self.staticData.Title
  self:ResetSortId()
end

function TopicTargetData:Update(server_data)
  if not server_data then
    return
  end
  if server_data.progress and self.progress ~= server_data.progress then
    self.progress = server_data.progress
  end
  if server_data.state and self.state ~= server_data.state then
    self.state = server_data.state
    self:ResetSortId()
  end
end

function TopicTargetData:ResetSortId()
  if self:IsFinished() then
    self.sort = _ESort.Finish
  elseif self:IsGoing() then
    self.sort = _ESort.Go
  else
    self.sort = _ESort.Rewarded
  end
end

function TopicTargetData:GetProgressValue()
  return self.progress / self.targetNum
end

function TopicTargetData:IsGoing()
  return self.state == TopicTargetData.EState.Go
end

function TopicTargetData:IsRewarded()
  return self.state == TopicTargetData.EState.Rewarded
end

function TopicTargetData:IsFinished()
  return self.state == TopicTargetData.EState.Finish
end
