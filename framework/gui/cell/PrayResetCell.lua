local BaseCell = autoImport("BaseCell")
PrayResetCell = class("PrayResetCell", BaseCell)
local ICON_NAME = "guild_icon_gongji_0"

function PrayResetCell:Init()
  PrayResetCell.super.Init(self)
  self:FindObjs()
  self:AddCellClickEvent()
end

function PrayResetCell:FindObjs()
  self.chooseImg = self:FindComponent("choosenImg", UISprite)
  self.typeLab = self:FindComponent("typeLab", UILabel)
  self.icon = self:FindComponent("icon", UISprite)
end

function PrayResetCell:ShowChooseImg(t)
  self.chooseImg.enabled = t == self.data.type
end

function PrayResetCell:SetData(data)
  self.data = data
  if data and 3 == #data then
    self.typeLab.text = data[1]
    self.name = data[1]
    local t = tostring(data.type)
    local atlas = RO.AtlasMap.GetAtlas("NEWUI3")
    self.icon.atlas = atlas
    self.icon.spriteName = ICON_NAME .. t
  end
  self:UpdateChoose()
end

function PrayResetCell:SetChoose(chooseId)
  self.chooseId = chooseId
  self:UpdateChoose()
end

function PrayResetCell:UpdateChoose()
  if self.data and self.data.type == self.chooseId then
    self:Show(self.chooseImg)
  else
    self:Hide(self.chooseImg)
  end
end
