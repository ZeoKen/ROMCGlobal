autoImport("BossComposeCardCell")
CardMakeRateUpCell = class("CardMakeRateUpCell", BossComposeCardCell)

function CardMakeRateUpCell:Init()
  CardMakeRateUpCell.super.Init(self)
  self.nameLabel = self:FindComponent("CardName", UILabel)
  self.upTimeLabel = self:FindComponent("UpTime", UILabel)
  self.cardCellParent = self:FindGO("BagCardCell")
  local longPress = self.cardCellParent:GetComponent(UILongPress)
  if longPress then
    function longPress.pressEvent(obj, isPress)
      if isPress then
        self:PassEvent(MouseEvent.LongPress, self)
      end
    end
  end
  self.widget = self.cardCellParent:GetComponent(UIWidget)
end

function CardMakeRateUpCell:GetItemCardCell()
  if self.cardCell == nil then
    local cardGO = self:LoadPreferb("cell/ItemCardCell", self.cardCellParent)
    self.cardCell = ItemCardCell.new(cardGO)
  end
  return self.cardCell
end

function CardMakeRateUpCell:SetData(data)
  CardMakeRateUpCell.super.SetData(self, data)
  self.nameLabel.text = data.staticData and data.staticData.NameZh or ""
  self:SetRateUpTime()
end

function CardMakeRateUpCell:SetRateUpTime()
  local upStartTime = self.data.upStartTime
  local upEndTime = self.data.upEndTime
  local upStartTimeTable = os.date("*t", upStartTime)
  local upEndTimeTable = os.date("*t", upEndTime)
  self.upTimeLabel.text = string.format(ZhString.CardMake_RateUpTime, upStartTimeTable.month, upStartTimeTable.day, upEndTimeTable.month, upEndTimeTable.day)
end
