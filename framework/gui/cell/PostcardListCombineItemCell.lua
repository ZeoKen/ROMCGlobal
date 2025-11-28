autoImport("BaseCombineCell")
PostcardListCombineItemCell = class("PostcardListCombineItemCell", BaseCombineCell)
autoImport("PostcardListCell")

function PostcardListCombineItemCell:Init()
  self:InitCells(4, "PersonalPictureCell", PostcardListCell)
end
