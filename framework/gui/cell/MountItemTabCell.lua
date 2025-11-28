MountItemTabCell = class("MountItemTabCell", BaseCell)
local TabConfig = {
  [1] = ZhString.MountLottery_Round1,
  [2] = ZhString.MountLottery_Round2,
  [3] = ZhString.MountLottery_Round3
}
local color_blue = ColorUtil.TabColor_DeepBlue
local color_gray = ColorUtil.TitleGray
local fontStyle_bold = 1
local fontStyle_normal = 0

function MountItemTabCell:Init()
  MountItemTabCell.super.Init(self)
  self.toglabel = self.gameObject:GetComponent(UILabel)
  self.line = self:FindGO("Line"):GetComponent(UISprite)
  self.tog = self.gameObject:GetComponent(UIToggle)
  self:SetEvent(self.gameObject, function()
    self:SetTog(true)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  EventDelegate.Add(self.tog.onChange, function()
    self:SetLabel()
  end)
end

function MountItemTabCell:SetLabel()
  if self.tog.value then
    self.toglabel.color = color_blue
    self.toglabel.fontStyle = fontStyle_normal
  elseif self.data.index == MountLotteryProxy.Instance:GetCurrentRound() then
    ColorUtil.BlackLabel(self.toglabel)
    self.toglabel.fontStyle = fontStyle_bold
  else
    self.toglabel.color = color_gray
    self.toglabel.fontStyle = fontStyle_normal
  end
end

function MountItemTabCell:SetTog(v)
  self.tog.value = v
end

function MountItemTabCell:SetGroup(g)
  g = g or 0
  self.tog.group = g
end

function MountItemTabCell:SetData(data)
  if not data then
    self.gameObject:SetActive(false)
    return
  end
  self.gameObject:SetActive(true)
  self.data = data
  if data.index then
    self.toglabel.text = TabConfig[data.index]
    self.toglabel.color = color_gray
  end
end
