local BaseCell = autoImport("BaseCell")
Anniversary2023SigninCell = class("Anniversary2023SigninCell", BaseCell)
autoImport("Anniversary2023ItemCell")

function Anniversary2023SigninCell:Init()
  self:FindObjs()
end

function Anniversary2023SigninCell:FindObjs()
  self.luckyNumLab = self:FindComponent("LuckyNum", UILabel)
  self.itemGrid = self:FindComponent("ItemGrid", UIGrid)
  self.item1Ctrl = Anniversary2023ItemCell.new(self:FindGO("Item_1", self.itemGrid.gameObject))
  self.item2Ctrl = Anniversary2023ItemCell.new(self:FindGO("Item_2", self.itemGrid.gameObject))
  self.funcBtnGO = self:FindGO("FuncBtn")
  self.funcLab = self:FindComponent("FuncLab", UILabel, self.funcBtnGO)
  self:AddClickEvent(self.funcBtnGO, function()
    self:PassEvent(UICellEvent.OnRightBtnClicked, self)
  end)
  self.dayGO = self:FindGO("DayBG")
  self.dayLab = self:FindComponent("DayLab", UILabel, self.dayGO)
end

function Anniversary2023SigninCell:SetData(data)
  self.cellData = data
  if data then
    if data.luckyNum and data.luckyNum ~= 0 and data.luckyNum ~= "" then
      self.luckyNumLab.text = data.luckyNum
    else
      self.luckyNumLab.text = "? ? ? ? ? ?"
    end
    if data.isShare then
      self.dayGO:SetActive(false)
      self.funcBtnGO:SetActive(true)
      if data:CanTakeReward() then
        self.funcLab.text = ZhString.ReturnActivityPanel_GetReward
      else
        self.funcLab.text = ZhString.ReturnActivityPanel_Share
      end
    else
      self.dayLab.text = string.format(ZhString.PlayerRefluxView_Day, ZhString.ChinaNumber[data.day or 1])
      self.funcLab.text = ZhString.ReturnActivityPanel_GetReward
      if data:CanTakeReward() then
        self.funcBtnGO:SetActive(true)
        self.dayGO:SetActive(false)
      else
        self.funcBtnGO:SetActive(false)
        self.dayGO:SetActive(true)
      end
    end
    self:UpdateRewardCell(self.item1Ctrl, data:GetRewardData(1))
    self:UpdateRewardCell(self.item2Ctrl, data:GetRewardData(2))
  end
end

function Anniversary2023SigninCell:UpdateRewardCell(cellCtrl, rewardData)
  if rewardData then
    self:Show(cellCtrl)
    cellCtrl:SetData(rewardData)
  else
    self:Hide(cellCtrl)
  end
end
