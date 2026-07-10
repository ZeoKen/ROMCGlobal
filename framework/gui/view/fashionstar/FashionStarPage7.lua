local defaultActionId = 9
FashionStarPage7 = class("FashionStarPage7", SubView)

function FashionStarPage7:InitView(gender)
  if self.videos then
    return
  end
  self.videos = self.container.currentStaticData.Param and self.container.currentStaticData.Param.Video[gender]
end

function FashionStarPage7:OnShow()
  local gender = Game.Myself.data.userdata:Get(UDEnum.SEX)
  self:InitView(gender)
  self.index = 1
  self.initialVideo = self.videos and self.videos[1]
  local param = self.container.currentStaticData.Param
  local fashionId = param and param.FashionId and param.FashionId[gender]
  local headId = param and param.HeadEquipId and param.HeadEquipId[gender]
  self.container:ChangeBodyPart(fashionId, headId)
  self.container:OpenVideo(self.initialVideo)
end

function FashionStarPage7:OnHide()
  self.container:Revert2DefaultModel()
end

function FashionStarPage7:OnClickSwitch(pre)
  if pre then
    self.index = self.index - 1
    if self.index < 1 then
      self.index = #self.videos
    end
  else
    self.index = self.index + 1
    if self.index > #self.videos then
      self.index = 1
    end
  end
  local video = self.videos and self.videos[self.index]
  if video then
    self.container:HideVideo()
    self.container:OpenVideo(video)
  end
end
