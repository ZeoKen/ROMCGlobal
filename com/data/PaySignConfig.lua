local STR_FORMAT = "%s %s"
PaySignConfig = class("PaySignConfig")

function PaySignConfig:ctor(id)
  self.actID = id
  self.actGameConfig = GameConfig.PaySign[id]
  if self:IsNoviceMode() then
    local depositID = self.actGameConfig.depositID
    self.depositConfig = depositID and Table_Deposit[depositID]
    if not self.depositConfig then
      redlog("付费签到七日活动入口购买depositID 配置错误，activityID : ", id)
    end
    local currency = self.depositConfig.Rmb or 0
    self.costStr = self.depositConfig.priceStr or self.depositConfig.CurrencyType .. " " .. FuncZenyShop.FormatMilComma(currency)
  else
    if self.actGameConfig.rechargeItem and #self.actGameConfig.rechargeItem == 2 then
      self.rechargeItemId = self.actGameConfig.rechargeItem[1]
      self.rechargeNum = self.actGameConfig.rechargeItem[2]
    else
      redlog("付费签到七日活动入口购买 rechargeItem 配置错误，activityID： ", id)
    end
    self.costStr = tostring(self.rechargeNum)
  end
  self.entryRechargeDesc = string.format(self.actGameConfig.entryDesc3, self.costStr)
  self.entryDesc1ConcatDesc2 = string.format(STR_FORMAT, self.actGameConfig.entryDesc1, self.actGameConfig.entryDesc2)
end

function PaySignConfig:GetBgTexture()
  return self.actGameConfig.entryBgTexture
end

function PaySignConfig:GetEntryDesc()
  return self.actGameConfig.entryDesc1
end

function PaySignConfig:GetEntryDesc1Concat2()
  return self.entryDesc1ConcatDesc2
end

function PaySignConfig:GetEntryRechargeDesc()
  return self.entryRechargeDesc
end

function PaySignConfig:GetLotteryCostDesc()
  return self.costStr
end

function PaySignConfig:IsNoviceMode()
  return self.actGameConfig.noviceMode == true
end
