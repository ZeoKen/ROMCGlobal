BTService = class("BTService", BTNode)

function BTService:ctor(config)
  BTService.super.ctor(self, config)
  self.domain = config.domain
  self.name = config and (config.name or config.type) or "BTService"
  self.dirty = false
end

function BTService:Dispose()
end
