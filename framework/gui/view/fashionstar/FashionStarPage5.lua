FashionStarPage5 = class("FashionStarPage5", SubView)

function FashionStarPage5:OnShow()
  local gender = Game.Myself.data.userdata:Get(UDEnum.SEX)
  local param = self.container.currentStaticData and self.container.currentStaticData.Param
  local fashionId = param and param.FashionId and param.FashionId[gender]
  if fashionId then
    local headId = param and param.HeadEquipId and param.HeadEquipId[gender]
    self.container:ChangeBodyPart(fashionId, headId)
  end
end
