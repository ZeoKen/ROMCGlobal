TimeLimitShopProxy = class("TimeLimitShopProxy", pm.Proxy)

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
  self.newInstock = id
  xdlog("最新商品ID", id)
  TableUtility.ArrayPushFront(self.timeLimitGoods, id)
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
      if single == self.newInstock then
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.TimeLimitShopView
        })
      end
    end
  end
  self.showView = false
end

function TimeLimitShopProxy:RemoveGood(goodid)
  for i = 1, #self.timeLimitGoods do
    if self.timeLimitGoods[i] == goodid then
      table.remove(self.timeLimitGoods, i)
    end
  end
end

function TimeLimitShopProxy:RemoveAllGoods()
  TableUtility.ArrayClear(self.timeLimitGoods)
end
