ShopMallPreorderProxy = class("ShopMallPreorderProxy", pm.Proxy)
autoImport("PreorderItemData")
PreorderStatus = {
  Null = RecordTrade_pb.ETradePreorderStatus_Min,
  Preordering = RecordTrade_pb.ETradePreorderStatus_Preordering,
  Finished = RecordTrade_pb.ETradePreorderStatus_Finished,
  Closed = RecordTrade_pb.ETradePreorderStatus_Closed
}

function ShopMallPreorderProxy:ctor(proxyName, data)
  self.proxyName = proxyName or "ShopMallPreorderProxy"
  if not ShopMallPreorderProxy.Instance then
    ShopMallPreorderProxy.Instance = self
  end
  if data then
    self:setData(data)
  end
  self:Init()
end

local MaxCount = GameConfig.Exchange.PreorderLimitCount

function ShopMallPreorderProxy:Init()
  self.preorderList = {}
  for i = 1, MaxCount do
    local emptydata = PreorderItemData.new()
    self.preorderList[#self.preorderList + 1] = emptydata
  end
end

function ShopMallPreorderProxy:RecvPreorderQueryPriceRecordTradeCmd(data)
end

function ShopMallPreorderProxy:RecvPreorderItemRecordTradeCmd(data)
  if data.ret == 0 then
    local item = data.item
    if item then
      MsgManager.ShowMsgByID(43380)
      local guid = item.id
      for i = 1, #self.preorderList do
        if self.preorderList[i].id == 0 then
          self.preorderList[i]:SetData(item)
          self.preorderList[i].status = PreorderStatus.Preordering
          return
        end
      end
    end
  end
end

function ShopMallPreorderProxy:RecvPreorderCancelRecordTradeCmd(data)
  if data.ret == 0 then
    if data.preorderid then
      for i = 1, #self.preorderList do
        if self.preorderList[i].id == data.preorderid then
          self.preorderList[i]:ResetData()
          return
        end
      end
    end
    ServiceRecordTradeProxy.Instance:CallPreorderListRecordTradeCmd()
  end
end

function ShopMallPreorderProxy:RecvPreorderListRecordTradeCmd(data)
  if data and data.items then
    local items = data.items
    for i = 1, MaxCount do
      local preorderData = self.preorderList[i]
      if items[i] then
        preorderData:SetData(items[i])
      else
        preorderData:ResetData()
      end
    end
  end
end

function ShopMallPreorderProxy:GetPreoderList()
  return self.preorderList
end

function ShopMallPreorderProxy:IsFunctionUnlocked()
  return NewRechargeProxy.Ins:AmIMonthlyVIP()
end

function ShopMallPreorderProxy:IsFunctionUnForbidden()
  return FunctionUnLockFunc.checkFuncStateValid(169)
end

function ShopMallPreorderProxy:GetPreorderItemdata(orderid)
  if self.preorderList then
    for i = 1, #self.preorderList do
      if orderid == self.preorderList[i].id then
        return self.preorderList[i]
      end
    end
  end
end

function ShopMallPreorderProxy:CheckEmptyOrder()
  for i = 1, MaxCount do
    local preorderData = self.preorderList[i]
    if preorderData and preorderData.status == PreorderStatus.Null then
      return true
    end
  end
  return false
end
