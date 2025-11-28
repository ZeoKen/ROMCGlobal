local RaidPuzzleChooseBuffView = class("RaidPuzzleChooseBuffView", ContainerView)
RaidPuzzleChooseBuffView.ViewType = UIViewType.NormalLayer
autoImport("RaidPuzzleChooseBuffItemCell")

function RaidPuzzleChooseBuffView:Init()
  self:FindObjs()
  self:AddEvents()
  self:InitData()
end

function RaidPuzzleChooseBuffView:FindObjs()
  self.confirmButton = self:FindGO("ConfirmButton")
  self.gainGrid = self:FindComponent("Grid", "UIGrid")
  self.gainGridList = UIGridListCtrl.new(self.gainGrid, RaidPuzzleChooseBuffItemCell, "RaidPuzzleChooseBuffItemCell")
  self.gainGridList:AddEventListener(MouseEvent.MouseClick, self.BuffCellClick, self)
end

function RaidPuzzleChooseBuffView:AddEvents()
  self:AddClickEvent(self.confirmButton, function(go)
    self:ConfirmButtonClick()
  end)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
end

function RaidPuzzleChooseBuffView:InitData()
  self.selectBuff = nil
  self.data = self.viewdata.viewdata
  if self.data then
    local param = self.data.params
    self.gainGridList:ResetDatas({
      param.buff1,
      param.buff2,
      param.buff3
    })
    self:InitBuffSelect()
  else
    redlog("have no data")
  end
end

function RaidPuzzleChooseBuffView:InitBuffSelect()
  local cells = self.gainGridList:GetCells()
  local len = #cells
  if 1 < len then
    self:BuffCellClick(cells[len - 1])
  else
    self:BuffCellClick(cells[len])
  end
end

function RaidPuzzleChooseBuffView:CloseButtonClick()
  self.gainGridList:Destroy()
  self:CloseSelf()
end

function RaidPuzzleChooseBuffView:ConfirmButtonClick()
  if self.selectBuff and self.data then
    redlog("call seivece id ", self.selectBuff.buffId)
    QuestProxy.Instance:notifyQuestState(self.data.scope, self.data.id, self.selectBuff.buffId)
    self.gainGridList:Destroy()
    self:CloseSelf()
  else
    redlog("have no selectBuff")
  end
end

function RaidPuzzleChooseBuffView:BuffCellClick(cellCtl)
  local cells = self.gainGridList:GetCells()
  for k, v in pairs(cells) do
    v:HideSelectBg()
  end
  cellCtl:SelectSelf()
  self.selectBuff = cellCtl
end

function RaidPuzzleChooseBuffView:OnEnter()
  RaidPuzzleChooseBuffView.super.OnEnter(self)
  UIManagerProxy.Instance:NeedEnableAndroidKey(false, function()
    self:CloseSelf()
  end)
end

function RaidPuzzleChooseBuffView:OnExit()
  RaidPuzzleChooseBuffView.super.OnExit(self)
  UIManagerProxy.Instance:NeedEnableAndroidKey(true, UIManagerProxy.GetDefaultNeedEnableAndroidKeyCallback())
end

return RaidPuzzleChooseBuffView
