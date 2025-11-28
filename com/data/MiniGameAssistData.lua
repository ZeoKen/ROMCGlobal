MiniGameAssistData = class("MiniGameAssistData")

function MiniGameAssistData:ctor(serverdata)
  self.type = serverdata.type
  self.count = serverdata.count
  self.effect = serverdata.effect
end
