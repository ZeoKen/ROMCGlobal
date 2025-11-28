local baseCell = autoImport("BaseCell")
RaidMapBtnCell = class("AuctionEventCell", baseCell)
local orangeOutline = LuaColor.New(0.6196078431372549, 0.27450980392156865, 0)
local blueOutline = LuaColor.New(0.11372549019607843, 0.17647058823529413, 0.4627450980392157)

function RaidMapBtnCell:Init()
  self:FindObjs()
  self:AddEvts()
end

function RaidMapBtnCell:FindObjs()
  self.btnSp = self.gameObject:GetComponent(UIMultiSprite)
  self.label = self:FindGO("Label"):GetComponent(UILabel)
  self.label.effectStyle = UILabel.Effect.Outline
end

function RaidMapBtnCell:AddEvts()
  self:SetEvent(self.gameObject, function()
    self:SetTog(true)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function RaidMapBtnCell:SetData(data)
  self.data = data
  if data then
    self.gameObject:SetActive(true)
    self.label.text = data.name
  else
    self.gameObject:SetActive(false)
  end
end

function RaidMapBtnCell:SetTog(b)
  if b then
    self.label.effectColor = orangeOutline
    self.btnSp.CurrentState = 1
  else
    self.label.effectColor = blueOutline
    self.btnSp.CurrentState = 0
  end
end
