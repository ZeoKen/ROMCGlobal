local baseCell = autoImport("BaseCell")
MessageBoardCell = class("MessageBoardCell", baseCell)
local TipBackgroundColor = {
  [1] = Color(1, 0.8, 0.8470588235294118, 1),
  [2] = Color(0.7137254901960784, 0.8666666666666667, 0.9568627450980393, 1),
  [3] = Color(0.9607843137254902, 0.9568627450980393, 0.7450980392156863, 1),
  [4] = Color(0.803921568627451, 0.9019607843137255, 0.7843137254901961, 1),
  [5] = Color(0.9098039215686274, 0.8431372549019608, 0.9568627450980393, 1),
  [6] = Color(0.9450980392156862, 0.7490196078431373, 0.6039215686274509, 1)
}
local TipMagnetIcon = {
  [1] = "home_message_magnet1",
  [2] = "home_message_magnet2",
  [3] = "home_message_magnet3",
  [4] = "home_message_magnet4",
  [5] = "home_message_magnet5",
  [6] = "home_message_magnet6",
  [7] = "home_message_magnet7",
  [8] = "home_message_magnet8",
  [9] = "home_message_magnet9",
  [10] = "home_message_magnet10"
}

function MessageBoardCell:Init()
  self:FindObjs()
  self:AddEvts()
end

function MessageBoardCell:FindObjs()
  self.ctrlRod = self:FindGO("CtrlRod")
  self.bg = self:FindGO("BG", self.ctrlRod):GetComponent(UISprite)
  self.magnet = self:FindGO("Magnet", self.ctrlRod):GetComponent(UISprite)
  self.checkboxNode = self:FindGO("checkBox")
  self.checkbox = self:FindComponent("checkBoxBg", UIToggle)
  self.label = self:FindComponent("Label", UILabel)
end

function MessageBoardCell:AddEvts()
  self:AddButtonEvent("checkBox", function()
    self.checkbox.value = not self.checkbox.value
  end)
  self:SetEvent(self.ctrlRod, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function MessageBoardCell:SetData(data)
  self.data = data
  self.time = data.time
  self.messages = data.items
  if #self.messages > 0 then
    local shownMsg = self.messages[#self.messages].msg
    self.label.text = shownMsg
  else
    self.label.text = ""
    redlog("这个贴纸没有items！")
  end
  local str = tostring(self.time)
  local tempColorIndex = tonumber(string.sub(str, 9, 9))
  if 6 < tempColorIndex then
    tempColorIndex = tempColorIndex - 4
  elseif tempColorIndex == 0 then
    tempColorIndex = 2
  end
  self.bg.color = TipBackgroundColor[tempColorIndex]
  local tempMagnetIndex = tonumber(string.sub(str, 10, 10))
  if tempMagnetIndex == 0 then
    tempMagnetIndex = 10
  end
  self.magnet.spriteName = TipMagnetIcon[tempMagnetIndex]
  local tempAngleJudge = tempColorIndex % 2 == 0
  local tempRotateAngle
  if tempAngleJudge then
    tempRotateAngle = tempMagnetIndex * 1
  else
    tempRotateAngle = tempMagnetIndex * -1
  end
  self.ctrlRod.transform.localRotation = Quaternion.Euler(0, 0, tempRotateAngle)
  UIUtil.WrapLabel(self.label)
end

function MessageBoardCell:SetCheckBoxShown(bool)
  self.checkboxNode.gameObject:SetActive(bool)
  self:SetToggleValue(false)
end

function MessageBoardCell:SetToggleValue(bool)
  self.checkbox.value = bool
end

function MessageBoardCell:SetIndex(index)
  self.index = index
end
