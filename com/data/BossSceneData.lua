BossSceneData = class("BossSceneData")

function BossSceneData:ctor(data)
  self.bossid = data.bossid
  self.isAlive = data.isalive
end

function BossSceneData:UpdataState(state)
  self.isAlive = state
end
