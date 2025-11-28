BTSystemManager = class("BTSystemManager")

function BTSystemManager:ctor(obj, config)
  self.btSystems = nil
  self:Init(obj, config)
end

function BTSystemManager:Init(obj, config)
  self.targetObject = obj
  if config.btRoots then
    self.btSystems = {}
    for _, v in pairs(config.btRoots) do
      if v then
        local btSys = BTSystem.new(obj, v)
        if btSys then
          table.insert(self.btSystems, btSys)
        end
      end
    end
  end
end

function BTSystemManager:Dispose()
  if self.btSystems then
    for _, v in pairs(self.btSystems) do
      if v then
        v:Dispose()
      end
    end
    self.btSystems = nil
  end
end

function BTSystemManager:Update(time, deltaTime)
  if self.btSystems then
    for _, v in pairs(self.btSystems) do
      v:Update(time, deltaTime)
    end
  end
end
