FunctionFurnitureFunc = class("FunctionFurnitureFunc")
FurnitureFuncState = {
  Active = 1,
  InActive = 2,
  Grey = 3
}

function FunctionFurnitureFunc.Me()
  if nil == FunctionFurnitureFunc.me then
    FunctionFurnitureFunc.me = FunctionFurnitureFunc.new()
  end
  return FunctionFurnitureFunc.me
end

function FunctionFurnitureFunc:ctor()
  self.funcMap = {}
  self.checkMap = {}
  self.funcMap.UseWardrobe = FunctionFurnitureFunc.UseWardrobe
  self.funcMap.WatchTV = FunctionFurnitureFunc.WatchTV
  self.funcMap.InteractFurniture = FunctionFurnitureFunc.InteractFurniture
  self.funcMap.OpenCalendar = FunctionFurnitureFunc.OpenCalendar
  self.funcMap.StatuePray = FunctionFurnitureFunc.StatuePray
  self.funcMap.OpenPetHouse = FunctionFurnitureFunc.OpenPetHouse
  self.funcMap.OnOffFurniture = FunctionFurnitureFunc.OnOffFurniture
  self.funcMap.FirePlace = FunctionFurnitureFunc.FirePlace
  self.funcMap.Transfiguration = FunctionFurnitureFunc.Transfiguration
  self.funcMap.WorkBench = FunctionFurnitureFunc.Workbench
  self.funcMap.MagicBook = FunctionFurnitureFunc.MagicBook
  self.funcMap.Phonograph = FunctionFurnitureFunc.Phonograph
  self.funcMap.Store = FunctionFurnitureFunc.Store
  self.funcMap.OpenTransferMap = FunctionFurnitureFunc.OpenTransferMap
  self.funcMap.PhotoAlbum = FunctionFurnitureFunc.PhotoAlbum
  self.funcMap.AppForward = FunctionFurnitureFunc.AppForward
  self.funcMap.Save = FunctionFurnitureFunc.Save
  self.funcMap.MessageBoard = FunctionFurnitureFunc.MessageBoard
  self.funcMap.OpenURL = FunctionFurnitureFunc.OpenURL
  self.checkMap.UseWardrobe = FunctionFurnitureFunc.CheckUseWardrobe
  self.checkMap.WatchTV = FunctionFurnitureFunc.CheckWatchTV
  self.checkMap.Save = FunctionFurnitureFunc.CheckSave
  self.checkMap.Store = FunctionFurnitureFunc.CheckStore
end

function FunctionFurnitureFunc:DoFurnitureFunc(furnitureFunctionData, nFurniture, param)
  if not furnitureFunctionData or not nFurniture then
    return
  end
  local event = self:getFunc(furnitureFunctionData.id)
  if not event then
    return
  end
  return event(nFurniture, param, furnitureFunctionData)
end

function FunctionFurnitureFunc:GetConfigByKey(key)
  for _, config in pairs(Table_FurnitureFunction) do
    if key == config.NameEn then
      return config
    end
  end
end

function FunctionFurnitureFunc:getFunc(id)
  local config = Table_FurnitureFunction[id]
  return config and self.funcMap[config.NameEn]
end

function FunctionFurnitureFunc:CheckFuncState(key, nfurniture, param)
  if not key then
    return FurnitureFuncState.InActive
  end
  if self.checkMap[key] then
    return self.checkMap[key](nfurniture, param)
  end
  return FurnitureFuncState.Active
end

function FunctionFurnitureFunc.UseWardrobe(nfurniture, param)
  redlog("UseWardrobe")
end

function FunctionFurnitureFunc.WatchTV(nfurniture, param)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.HomeTelevisionView
  })
end

function FunctionFurnitureFunc.FirePlace(nfurniture, param)
  redlog("FirePlace")
end

function FunctionFurnitureFunc.InteractFurniture(nfurniture, param)
  local _InteractNpcManager = Game.InteractNpcManager
  if not _InteractNpcManager:TryNotifyGetOn(nfurniture.id, param) and param ~= nil and _InteractNpcManager:IsMyselfOnNpc() then
    ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeProxy.Oper.Action, nfurniture.data.id, param.ClickAction)
  end
end

function FunctionFurnitureFunc.OnOffFurniture(nfurniture, param)
  local data = nfurniture.data
  if data:IsStateOn() then
    ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeProxy.Oper.Off, data.id)
  else
    ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeProxy.Oper.On, data.id)
  end
end

function FunctionFurnitureFunc.OpenCalendar(nFurniture, param)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.CalendarView
  })
end

function FunctionFurnitureFunc.StatuePray(nFurniture, param)
  local statueGuid = nFurniture.data and nFurniture.data.id
  ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeProxy.Oper.Pray, statueGuid)
end

function FunctionFurnitureFunc.OpenPetHouse(nFurniture, param)
  if HomeManager.Me():IsAtMyselfHome() then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PetHouseView,
      viewdata = nFurniture.data
    })
  end
end

function FunctionFurnitureFunc.PhotoAlbum(nFurniture, param)
  redlog("PhotoAlbum")
  local viewData = {
    view = PanelConfig.HomePersonalPicturePanel,
    viewdata = {
      id = nFurniture.data.id,
      photo = nFurniture.data.photo
    }
  }
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, viewData)
end

function FunctionFurnitureFunc.MessageBoard(nFurniture, param)
  local viewData = {
    view = PanelConfig.MessageBoardView,
    viewdata = {furniture = nFurniture}
  }
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, viewData)
end

function FunctionFurnitureFunc.Transfiguration(nFurniture, param)
  local statueGuid = nFurniture.data and nFurniture.data.id
  nFurniture:PlayActionByID(param and param.OnAction, true)
  ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeProxy.Oper.Mirror, statueGuid)
  nFurniture:AccessOver(true)
end

function FunctionFurnitureFunc.Workbench(nFurniture, param)
  local isStrengthenOpen = FunctionUnLockFunc.Me():CheckCanOpen(7)
  if not isStrengthenOpen then
    MsgManager.ShowMsgByID(803)
    return
  end
  local action, actionName = param.OnAction
  if action then
    actionName = Table_ActionAnime[action] and Table_ActionAnime[action].Name
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.HomeWorkbenchView,
    viewdata = {furniture = nFurniture, actionName = actionName}
  })
end

function FunctionFurnitureFunc.MagicBook(nFurniture, param)
  local layer = UIManagerProxy.Instance:GetLayerByType(UIViewType.NormalLayer)
  if layer and #layer.nodes > 0 then
    return
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.HomeAtmosphereSelectView,
    viewdata = {furniture = nFurniture}
  })
end

function FunctionFurnitureFunc.Phonograph(nFurniture, param)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.SoundBoxView,
    viewdata = {furniture = nFurniture}
  })
end

function FunctionFurnitureFunc.Store(nFurniture, param)
  if FunctionUnLockFunc.Me():CheckCanOpenByPanelId(PanelConfig.RepositoryView.id) then
    local viewCfg = FunctionUnLockFunc.Me():GetPanelConfigById(PanelConfig.RepositoryView.id)
    if viewCfg then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = viewCfg,
        viewdata = {furniture = nFurniture}
      })
    end
  end
end

function FunctionFurnitureFunc.OpenTransferMap(nFurniture, param)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.WorldMapView,
    viewdata = {isFromFurniture = true}
  })
end

function FunctionFurnitureFunc.AppForward(nFurniture, param)
  helplog("AppForward")
  if param and param.id then
    if not param.exparam then
      FunctionAppForward.Me():AppForwardByID(param.id)
    elseif "table" == type(param.exparam) then
      FunctionAppForward.Me():AppForwardByID(param.id, unpack(param.exparam))
    else
      FunctionAppForward.Me():AppForwardByID(param.id, param.exparam)
    end
  end
end

function FunctionFurnitureFunc.Save(nFurniture, param)
  ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeCmd_pb.EFURNITUREOPER_SAVEMAP, nFurniture.data.id)
end

function FunctionFurnitureFunc.OpenURL(nFurniture, param)
  if not param or not param.url then
    return
  end
  ApplicationInfo.OpenUrl(param.url)
end

function FunctionFurnitureFunc.CheckUseWardrobe(nfurniture, param)
  return FurnitureFuncState.Active
end

function FunctionFurnitureFunc.CheckPhotoAlbum(nfurniture, param)
  helplog("CheckPhotoAlbum Table_FurnitureFunction")
  return FurnitureFuncState.Active
end

function FunctionFurnitureFunc.CheckSave(nfurniture, param)
  return HomeManager.Me():IsAtMyselfHome() and FurnitureFuncState.Active or FurnitureFuncState.InActive
end

function FunctionFurnitureFunc.CheckStore(nfurniture, param)
  return FurnitureFuncState.Active
end
