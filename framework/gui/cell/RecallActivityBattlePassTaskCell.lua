autoImport("ActivityBattlePassTaskCell")
RecallActivityBattlePassTaskCell = class("RecallActivityBattlePassTaskCell", ActivityBattlePassTaskCell)

function RecallActivityBattlePassTaskCell:SetData(data)
  self.data = data
  if data then
    local staticData = data.staticData
    if staticData then
      self.descLabel.text = staticData.Desc
      self.extraDescLabel.text = staticData.Title
      local targetNum = staticData.TargetNum
      local progress = data.process
      self.progressLabel.text = progress .. "/" .. targetNum
      local datas = ReusableTable.CreateArray()
      if staticData.Exp then
        local expItem = 10000351
        local itemData = ItemData.new("Reward", expItem)
        if itemData then
          itemData:SetItemNum(staticData.Exp)
        end
        datas[#datas + 1] = itemData
      end
      self.rewardList:ResetDatas(datas)
      ReusableTable.DestroyAndClearArray(datas)
      self.gotoBtn:SetActive(state == RecallActivityBattlePassTaskData.TaskState.PROCESS and staticData.Goto and #staticData.Goto > 0)
      self.receivedCheck:SetActive(data.state == RecallActivityBattlePassTaskData.TaskState.FINISH)
      self.locker:SetActive(false)
    end
  end
end
