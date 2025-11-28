local LoadSceneLoadedCommand = class("LoadSceneLoadedCommand", pm.SimpleCommand)

function LoadSceneLoadedCommand:execute(note)
  self:UnLoadStartUI()
  self:TryLoadNextScene()
end

function LoadSceneLoadedCommand:TryLoadNextScene()
  if self.gclt then
    TimeTickManager.Me():ClearTick(self, 526)
    self.gclt = nil
  end
  self.gclt = TimeTickManager.Me():CreateOnceDelayTick(500, function()
    self.gclt = nil
    FunctionChangeScene.Me():GC()
    self:StartLoadNextScene()
  end, self, 526)
end

function LoadSceneLoadedCommand:StartLoadNextScene()
  if self.lt then
    TimeTickManager.Me():ClearTick(self, 1225)
    self.lt = nil
  end
  self.lt = TimeTickManager.Me():CreateOnceDelayTick(500, function()
    SceneProxy.Instance:ASyncLoad()
  end, self, 1225)
end

function LoadSceneLoadedCommand:UnLoadStartUI()
  ResourceManager.Instance:SUnLoad(ResourcePathHelper.UIView("StartGamePanel"), false)
  ResourceManager.Instance:SUnLoad(ResourcePathHelper.UIView("CreateRoleViewV2"), false)
end

return LoadSceneLoadedCommand
