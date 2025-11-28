local baseCell = autoImport("BaseCell")
HomePersonalPictureItemDropCell = class("HomePersonalPictureItemDropCell", baseCell)

function HomePersonalPictureItemDropCell:Init()
  self:initView()
  self:AddCellClickEvent()
end

function HomePersonalPictureItemDropCell:initView()
  self.name = self:FindComponent("name", UILabel)
end

function HomePersonalPictureItemDropCell:SetData(data)
  self.data = data
  self.name.text = data.Name
end
