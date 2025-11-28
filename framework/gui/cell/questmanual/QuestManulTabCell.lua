QuestManulTabCell = class("QuestManulTabCell", BaseCell)
local TabConfig = {
  [1] = ZhString.MountLottery_Round1,
  [2] = ZhString.MountLottery_Round2,
  [3] = ZhString.MountLottery_Round3
}
local color_blue = ColorUtil.TabColor_DeepBlue
local color_gray = ColorUtil.TitleGray

function QuestManulTabCell:Init()
  QuestManulTabCell.super.Init(self)
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

function QuestManulTabCell:SetLabel()
  if self.tog.value then
    self.toglabel.color = color_blue
  else
    self.toglabel.color = color_gray
  end
end

function QuestManulTabCell:SetTog(v)
  self.tog.value = v
end

function QuestManulTabCell:SetGroup(g)
  g = g or 0
  self.tog.group = g
end

function QuestManulTabCell:SetData(data)
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
