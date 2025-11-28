RepositoryViewProxy = class("RepositoryViewProxy", pm.Proxy)
RepositoryViewProxy.Instance = nil
RepositoryViewProxy.NAME = "RepositoryViewProxy"

function RepositoryViewProxy:ctor(proxyName, data)
  self.proxyName = proxyName or RepositoryViewProxy.NAME
  if RepositoryViewProxy.Instance == nil then
    RepositoryViewProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

RepositoryViewProxy.Operation = {
  Default = 1,
  DepositRepositoryEvt = 2,
  WthdrawnRepositoryEvt = 3
}

function RepositoryViewProxy:Init()
end

function RepositoryViewProxy:SetViewTab(tab)
  self.viewTab = tab
end

function RepositoryViewProxy:GetViewTab()
  return self.viewTab
end

function RepositoryViewProxy:CheckItemExist(bagType, itemId)
  if bagType == nil or itemId == nil then
    return false
  end
  local bagItems
  if bagType == BagProxy.BagType.MainBag then
    bagItems = BagProxy.Instance.bagData:GetItems()
  elseif bagType == BagProxy.BagType.PersonalStorage then
    bagItems = BagProxy.Instance:GetPersonalRepositoryBagData():GetItems()
  elseif bagType == BagProxy.BagType.Storage then
    bagItems = BagProxy.Instance:GetRepositoryBagData():GetItems()
  elseif bagType == BagProxy.BagType.Home then
    bagItems = BagProxy.Instance:GetHomeRepositoryBagData():GetItems()
  end
  if bagItems then
    for i = 1, #bagItems do
      if bagItems[i].id == itemId then
        return true
      end
    end
  end
  return false
end

function RepositoryViewProxy:CanTakeOut()
  if self.viewTab == RepositoryView.Tab.CommonTab and not NewRechargeProxy.Ins:AmIMonthlyVIP() then
    return MyselfProxy.Instance:RoleLevel() >= GameConfig.Item.store_takeout_baselv_req
  end
  return true
end

function RepositoryViewProxy:CheckLockByLevel()
  return (self.viewTab == RepositoryView.Tab.CommonTab or self.viewTab == RepositoryView.Tab.HomeTab) and MyselfProxy.Instance:RoleLevel() < GameConfig.Item.store_baselv_req
end

function RepositoryViewProxy:CheckLockByStrength(data)
  return data ~= nil and data.equipInfo ~= nil and data.equipInfo.strengthlv > 0 and (self.viewTab == RepositoryView.Tab.CommonTab or self.viewTab == RepositoryView.Tab.HomeTab)
end
