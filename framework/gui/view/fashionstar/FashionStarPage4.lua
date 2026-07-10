FashionStarPage4 = class("FashionStarPage4", SubView)

function FashionStarPage4:Init()
end

function FashionStarPage4:OnShow()
  local gender = Game.Myself.data.userdata:Get(UDEnum.SEX)
  local param = self.container.currentStaticData and self.container.currentStaticData.Param
  local fashionId = param and param.FashionId and param.FashionId[gender]
  if fashionId then
    local headId = param and param.HeadEquipId and param.HeadEquipId[gender]
    self.container:ChangeBodyPart(fashionId, headId)
  end
end

function FashionStarPage4:OnHide()
  self.container:Revert2DefaultModel()
end
