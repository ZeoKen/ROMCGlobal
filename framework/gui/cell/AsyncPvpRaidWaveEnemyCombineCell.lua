autoImport("AsyncPvpRaidWaveEnemyCell")
AsyncPvpRaidWaveEnemyCombineCell = class("AsyncPvpRaidWaveEnemyCombineCell", BaseCell)

function AsyncPvpRaidWaveEnemyCombineCell:Init()
  self:FindObjs()
end

function AsyncPvpRaidWaveEnemyCombineCell:FindObjs()
  self.waveLabel = self:FindComponent("Wave", UILabel)
  local grid = self:FindComponent("Grid", UIGrid)
  self.enemyListCtrl = UIGridListCtrl.new(grid, AsyncPvpRaidWaveEnemyCell, "AsyncPvpRaidWaveEnemyCell")
end

function AsyncPvpRaidWaveEnemyCombineCell:SetData(data)
  self.data = data
  if data then
    self.waveLabel.text = string.format(ZhString.AsyncPvpRaidDiffSetView_Wave, ZhString.ChinaNumber[data.wave])
    self.enemyListCtrl:ResetDatas(data.enemys)
  end
end
