autoImport("BaseCombineCell")
HomePersonalPictureCombineItemCell = class("HomePersonalPictureCombineItemCell", BaseCombineCell)
autoImport("HomePersonalPictureWallCell")

function HomePersonalPictureCombineItemCell:Init()
  self:InitCells(1, "PersonalPictureWallCell", HomePersonalPictureWallCell)
end
