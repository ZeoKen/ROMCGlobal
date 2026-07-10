TimeLimitShopProxy = class("TimeLimitShopProxy", pm.Proxy)
TimeLimitShopProxy.DepositType = 7

function TimeLimitShopProxy:ctor(proxyName, data)
  self.proxyName = proxyName or "TimeLimitShopProxy"
  if TimeLimitShopProxy.Instance == nil then
    TimeLimitShopProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function TimeLimitShopProxy:Init()
  self.timeLimitGoods = {}
  self.showView = false
  EventManager.Me():AddEventListener(LoadSceneEvent.FinishLoadScene, self.sceneLoadFinish, self)
end

function TimeLimitShopProxy:RecvGiftTimeLimitNtfUserEvent(infos)
end

function TimeLimitShopProxy:RecvGiftTimeLimitActiveUserEvent(data)
  self.showView = true
  local id = data.id
  local type = data.type or 0
  local goodData = self:CreateGoodData(id, type)
  self.newInstock = goodData
  xdlog("最新商品ID", id)
  self:RemoveGood(id, type)
  TableUtility.ArrayPushFront(self.timeLimitGoods, goodData)
end

function TimeLimitShopProxy:sceneLoadFinish()
  local mapId = Game.MapManager:GetMapID()
  local mapData = mapId and Table_Map[mapId]
  if mapData and mapData.IsCommonline and mapData.IsCommonline == 1 then
    self:viewPopUp()
  end
end

function TimeLimitShopProxy:viewPopUp()
  if self.showView and self.timeLimitGoods and #self.timeLimitGoods > 0 then
    for i = 1, #self.timeLimitGoods do
      local single = self.timeLimitGoods[i]
      if self:IsSameGood(single, self.newInstock) then
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.TimeLimitShopView
        })
      end
    end
  end
  self.showView = false
end

function TimeLimitShopProxy:CreateGoodData(id, type)
  return {
    id = id,
    type = type or 0
  }
end

function TimeLimitShopProxy:IsSameGood(lhs, rhs, goodType)
  if lhs == nil or rhs == nil then
    return false
  end
  local lhsId = type(lhs) == "table" and lhs.id or lhs
  local lhsType = type(lhs) == "table" and (lhs.type or 0) or 0
  local rhsId = type(rhs) == "table" and rhs.id or rhs
  local rhsType = goodType ~= nil and goodType or type(rhs) == "table" and (rhs.type or 0) or 0
  return lhsId == rhsId and lhsType == rhsType
end

function TimeLimitShopProxy:RemoveGood(goodid, goodType)
  for i = 1, #self.timeLimitGoods do
    if self:IsSameGood(self.timeLimitGoods[i], goodid, goodType) then
      table.remove(self.timeLimitGoods, i)
      break
    end
  end
end

function TimeLimitShopProxy:RemoveAllGoods()
  TableUtility.ArrayClear(self.timeLimitGoods)
end
