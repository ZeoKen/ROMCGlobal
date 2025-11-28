local BaseCell = autoImport("BaseCell")
QuotaDetailCell = class("QuotaDetailCell", BaseCell)

function QuotaDetailCell:Init()
  self.date = self:FindComponent("Date", UILabel)
  self.value = self:FindComponent("value", UILabel)
  self.expireTime = self:FindComponent("expireTime", UILabel)
  self.pos = self:FindGO("pos")
end

local recruit, balance

function QuotaDetailCell:SetData(data)
  self.data = data
  if data then
    self:Show(self.pos)
    self.date.text = ClientTimeUtil.FormatTimeTick(data.time, "yyyy-MM-dd")
    recruit = StringUtil.NumThousandFormat(data.value)
    balance = StringUtil.NumThousandFormat(data.balance)
    self.value.text = string.format(ZhString.QuotaCard_Detail, recruit, balance)
    self:SetExpireTime(data.expire_time)
  else
    self:Hide(self.pos)
  end
end

function QuotaDetailCell:SetExpireTime(expireTime)
  if self.data:bUsedUp() then
    self.expireTime.text = string.format(ZhString.QuotaCard_UseUp, day)
  elseif self.data:bOverDue() then
    self.expireTime.text = ZhString.QuotaCard_Overdue
  else
    local day = math.floor((self.data.expire_time - ServerTime.CurServerTime() / 1000) / 86400)
    if 5 <= day then
      self.expireTime.text = string.format(ZhString.QuotaCard_Surplus, day)
    elseif 0 <= day and day < 5 then
      self.expireTime.text = string.format(ZhString.QuotaCard_SurplusRed, day)
    end
  end
end
