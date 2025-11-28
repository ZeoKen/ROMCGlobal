local BaseCell = autoImport("BaseCell")
MiniGameMonsterShotRecordCell = class("MiniGameMonsterShotRecordCell", BaseCell)

function MiniGameMonsterShotRecordCell:Init()
  self:FindObjs()
end

function MiniGameMonsterShotRecordCell:FindObjs()
  self.symbolR = self:FindGO("symbolR")
  self.symbolW = self:FindGO("symbolW")
end

function MiniGameMonsterShotRecordCell:SetData(data)
  self.result = data
  if self.result == 0 then
    self.symbolR:SetActive(false)
    self.symbolW:SetActive(false)
  elseif self.result > 0 then
    self.symbolR:SetActive(true)
    self.symbolW:SetActive(false)
  elseif self.result < 0 then
    self.symbolR:SetActive(false)
    self.symbolW:SetActive(true)
  end
end
