GUISystemManager = class("GUISystemManager")

function GUISystemManager:ctor()
  self.tabUpdateFuncMap = {}
  self.tabLateUpdateFuncMap = {}
end

function GUISystemManager:Update(time, deltaTime)
  for owner, func in pairs(self.tabUpdateFuncMap) do
    func(owner, time, deltaTime)
  end
end

function GUISystemManager:LateUpdate(time, deltaTime)
  for owner, func in pairs(self.tabLateUpdateFuncMap) do
    func(owner, time, deltaTime)
  end
end

function GUISystemManager:AddMonoUpdateFunction(func, owner)
  if not (func and owner) or type(func) ~= "function" then
    LogUtility.Error("Add Update Function Failed!")
    return
  end
  self.tabUpdateFuncMap[owner] = func
end

function GUISystemManager:ClearMonoUpdateFunction(owner)
  self.tabUpdateFuncMap[owner] = nil
end

function GUISystemManager:AddMonoLateUpdateFunction(func, owner)
  if not (func and owner) or type(func) ~= "function" then
    LogUtility.Error("Add LateUpdate Function Failed!")
    return
  end
  self.tabLateUpdateFuncMap[owner] = func
end

function GUISystemManager:ClearMonoLateUpdateFunction(owner)
  self.tabLateUpdateFuncMap[owner] = nil
end
