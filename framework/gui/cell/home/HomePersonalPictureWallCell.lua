autoImport("PersonalPictureWallCell")
HomePersonalPictureWallCell = class("HomePersonalPictureWallCell", PersonalPictureWallCell)

function HomePersonalPictureWallCell:CheckBoxButtonEvent()
end

function HomePersonalPictureWallCell:SetDataPassEvent()
  self:PassEvent(PersonalPicturePanel.GetPersonPicThumbnail, self)
  self:PassEvent(HomePersonalPicturePanel.CheckCurPicIsShow, self)
end
