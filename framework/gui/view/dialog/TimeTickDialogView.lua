TimeTickDialogView = class("TimeTickDialogView", SubView)

function TimeTickDialogView:OnEnter()
  self:FindObjs()
  if self.subViewData then
    self:ResetData(self.subViewData[1], self.subViewData[2])
  end
end

function TimeTickDialogView:OnExit()
  self:ClearData()
end

function TimeTickDialogView:ResetData(time, timeOutSubgroup)
  self.timeTickGo:SetActive(true)
  self:ClearTick()
  self.menuCtrl:ResetDatas(self.container.menuData)
  self.time = time
  self.timeOutSubgroup = timeOutSubgroup
  if self.time then
    self.tick = TimeTickManager.Me():CreateTick(0, 1000, function()
      self:UpdateTime()
    end, self)
  end
end

function TimeTickDialogView:ClearData()
  self:ClearTick()
  self.menuCtrl:RemoveAll()
  self.timeTickGo:SetActive(false)
  self.time = nil
  self.timeOutSubgroup = nil
end

function TimeTickDialogView:FindObjs()
  self.timeTickGo = self:FindGO("TimeTick")
  self.timeLabel = self:FindComponent("time", UILabel, self.timeTickGo)
  self.grid = self:FindComponent("Grid", UIGrid, self.timeTickGo)
  self.menuCtrl = UIGridListCtrl.new(self.grid, NpcMenuBtnCell, "NpcMenuBtnCell")
  self.menuCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickMenuEvent, self)
end

function TimeTickDialogView:UpdateTime()
  self.timeLabel.text = self.time
  if self.time <= 0 then
    self.container.optionid = self.timeOutSubgroup
    self.container.dialogend = true
    self.container:CloseSelf()
    return
  end
  self.time = self.time - 1
end

function TimeTickDialogView:ClearTick()
  if self.tick then
    TimeTickManager.Me():ClearTick(self)
    self.tick = nil
  end
end

function TimeTickDialogView:ClickMenuEvent(cellCtrl)
  self.container:ClickMenuEvent(cellCtrl)
end
