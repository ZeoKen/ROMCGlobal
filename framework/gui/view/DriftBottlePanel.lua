DriftBottlePanel = class("DriftBottlePanel", ContainerView)
autoImport("DriftBottleCellType3")
DriftBottlePanel.ViewType = UIViewType.NormalLayer

function DriftBottlePanel:Init()
  self:InitView()
  self:InitDatas()
  self:AddEvts()
  self:AddMapEvts()
  self:InitShow()
end

function DriftBottlePanel:InitView()
  self.closeBtn = self:FindGO("CloseBtn")
  self.container = self:FindGO("Container")
  self.driftBottleScrollView = self:FindGO("DriftBottleScrollView"):GetComponent(UIScrollView)
  self.driftBottleTable = self:FindGO("Table", self.container):GetComponent(UITable)
  self.driftBottleCtrl = UIGridListCtrl.new(self.driftBottleTable, DriftBottleCellType3, "DriftBottleCellType3")
  self.driftBottleCtrl:AddEventListener(DriftBottleEvent.ClickAcceptBtn, self.clickAcceptBtn, self)
  self.driftBottleCtrl:AddEventListener(DriftBottleEvent.ClickAbandonBtn, self.clickAbandonBtn, self)
  self.driftBottleCtrl:AddEventListener(DriftBottleEvent.ClickShowDetail, self.clickShowDetail, self)
end

function DriftBottlePanel:InitDatas()
end

function DriftBottlePanel:AddEvts()
  self:AddClickEvent(self.closeBtn, function()
    self:CloseSelf()
  end)
end

function DriftBottlePanel:AddMapEvts()
  self:AddListenEvt(ServiceEvent.QuestBottleUpdateQuestCmd, self.InitShow)
end

function DriftBottlePanel:InitShow()
  local bottleList = DriftBottleProxy.Instance:GetAcceptBottleList()
  if not bottleList then
    MsgManager.ShowMsgByID(41494)
    self:CloseSelf()
    return
  end
  local exist = false
  for k, v in pairs(bottleList) do
    if k then
      exist = true
      break
    end
  end
  if not exist then
    MsgManager.ShowMsgByID(41494)
    self:CloseSelf()
    return
  end
  local tempList = {}
  for k, v in pairs(bottleList) do
    if v.status == 1 then
      table.insert(tempList, k)
    end
  end
  self.driftBottleCtrl:ResetDatas(tempList)
  local cells = self.driftBottleCtrl:GetCells()
  if cells then
    for i = 1, #cells do
      cells[i]:HideConfirmBtn()
    end
  end
end

function DriftBottlePanel:clickAcceptBtn(cell)
  xdlog("clickAcceptBtn")
end

function DriftBottlePanel:clickAbandonBtn(cell)
  xdlog("放弃瓶子", cell.data)
  ServiceQuestProxy.Instance:CallBottleActionQuestCmd(2, cell.data)
end

function DriftBottlePanel:clickShowDetail(cell)
end
