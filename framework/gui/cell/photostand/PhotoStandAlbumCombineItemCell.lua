autoImport("BaseCombineCell")
autoImport("PhotoStandAlbumCell")
PhotoStandAlbumCombineItemCell = class("PhotoStandAlbumCombineItemCell", BaseCombineCell)

function PhotoStandAlbumCombineItemCell:Init()
  self:InitCells(3, "PhotoStandAlbumCell", PhotoStandAlbumCell)
end
