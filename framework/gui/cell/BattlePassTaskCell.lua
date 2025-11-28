autoImport("NoviceBattlePassTaskCell")
BattlePassTaskCell = class("BattlePassTaskCell", NoviceBattlePassTaskCell)

function BattlePassTaskCell:FindObjs()
  BattlePassTaskCell.super.FindObjs(self)
  self.titleLabel = self:FindComponent("title", UILabel)
end

function BattlePassTaskCell:SetData(data)
  if data then
    self.id = data
    local staticData = Table_BattlePassTask[self.id]
    local info = BattlePassProxy.Instance:GetBattlePassTask(self.id)
    self:SetCellData(info, staticData, 184)
  end
end

function BattlePassTaskCell:SetCellData(info, staticData, itemId)
  BattlePassTaskCell.super.SetCellData(self, info, staticData, itemId)
  self.titleLabel.text = staticData.Title
end

function BattlePassTaskCell:SetTaskState(state)
  self.receiveBtn:SetActive(false)
  if state == SceneUser2_pb.ENOVICE_TARGET_FINISH then
    self.gotoBtn:SetActive(false)
    self.receivedCheck:SetActive(true)
  elseif state == SceneUser2_pb.ENOVICE_TARGET_GO then
    self.gotoBtn:SetActive(true)
    self.receivedCheck:SetActive(false)
  end
end
