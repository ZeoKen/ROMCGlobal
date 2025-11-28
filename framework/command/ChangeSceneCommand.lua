local ChangeSceneCommand = class("ChangeSceneCommand", pm.SimpleCommand)

function DeepCopy(object)
  local SearchTable = {}
  
  local function Func(object)
    if type(object) ~= "table" then
      return object
    end
    local NewTable = {}
    SearchTable[object] = NewTable
    for k, v in pairs(object) do
      NewTable[Func(k)] = Func(v)
    end
    return setmetatable(NewTable, getmetatable(object))
  end
  
  return Func(object)
end

function ChangeSceneCommand:execute(note)
  local data = DeepCopy(note.body)
  local imageid = ServicePlayerProxy.Instance:GetCurMapImageId()
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, {
    view = PanelConfig.DialogMaskView
  })
  FunctionCameraEffect.Me():ClearSomeWhenChangeScene()
  if note.type == LoadSceneEvent.StartLoad then
    if imageid and MirrorRaidConfig[imageid] then
      Game.DungeonManager:Shutdown()
    end
    FunctionChangeScene.Me():TryLoadScene(data)
    if note.name == ServiceEvent.PlayerMapChange then
      self:ClearPendingMapAnime(note)
    end
    local isRoguelike = type(note.body) == "table" and note.body.isRoguelike
    if isRoguelike then
    elseif Game.Myself then
      Game.Myself:ResetDefaultUseData()
    end
  else
    FunctionChangeScene.Me():LoadedScene(data)
  end
end

function ChangeSceneCommand:ClearPendingMapAnime(note)
  Game.GameObjectManagers[Game.GameObjectType.SceneBossAnime]:ClearPendingAnimID()
end

return ChangeSceneCommand
