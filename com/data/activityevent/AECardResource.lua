AECardResource = class("AECardResource")

function AECardResource:ctor(data)
  self:SetData(data)
end

function AECardResource:SetData(data)
  if nil ~= data then
    self.cardtype = data.cardtype
    self.url = data.url
  end
end
