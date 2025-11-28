ChangeHeadData = class("ChangeHeadData")
ChangeHeadData.HeadCellType = {
  OFF = 0,
  Avatar = 1,
  Portrait = 2,
  Frame = 3,
  ChatFrame = 4
}

function ChangeHeadData:ctor(data)
  self:SetData(data)
end

function ChangeHeadData:SetData(data)
  self.id = data
  self.isChoose = false
end

function ChangeHeadData:SetChoose(isChoose)
  self.isChoose = isChoose
end

function ChangeHeadData:SetType(type)
  self.type = type
end

function ChangeHeadData:SetEndTime(endTime)
  self.endTime = endTime
end
