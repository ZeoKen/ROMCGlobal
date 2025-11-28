local BaseCell = autoImport("BaseCell")
TeamPwsCustomRoomReadyCell = class("TeamPwsCustomRoomReadyCell", BaseCell)
local readyicon = "com_icon_check"
local waitingicon = "com_icon_off"

function TeamPwsCustomRoomReadyCell:Init()
  self.playername = self:FindComponent("name", UILabel)
  self.check = self:FindGO("check"):GetComponent(UISprite)
end

function TeamPwsCustomRoomReadyCell:SetData(data)
  self.data = data
  if self.data then
    self.playername.text = self.data.name
  end
  if data.prepare == nil then
    self.check.spriteName = ""
  else
    self:SetStatus(data.prepare)
  end
end

function TeamPwsCustomRoomReadyCell:SetStatus(b)
  if b then
    self.check.spriteName = readyicon
  else
    self.check.spriteName = waitingicon
  end
end
