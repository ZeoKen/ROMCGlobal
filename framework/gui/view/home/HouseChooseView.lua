autoImport("HouseChooseCell")
HouseChooseView = class("HouseChooseView", BaseView)
HouseChooseView.ViewType = UIViewType.PopUpLayer

function HouseChooseView:Init()
  self.houseDatas = {}
  self:InitUI()
  self:AddEvts()
  self:AddViewEvts()
end

function HouseChooseView:InitUI()
  self.objNoneTip = self:FindGO("NoneTip")
  self.listHouses = WrapListCtrl.new(self:FindGO("wrapHouse"), HouseChooseCell, "HouseChooseCell", WrapListCtrl_Dir.Vertical, 3, 227)
end

function HouseChooseView:AddEvts()
  self.listHouses:AddEventListener(MouseEvent.MouseClick, self.ClickHouseCell, self)
  self:AddClickEvent(self:FindGO("CloseButton"), function()
    self:CloseSelf()
  end)
  self:AddClickEvent(self:FindGO("BtnHelp"), function()
  end)
  self.gameObject:GetComponent(CallBackWhenClickOtherPlace).call = function()
    self:CloseSelf()
  end
end

function HouseChooseView:AddViewEvts()
end

function HouseChooseView:ReloadHouses()
  TableUtility.TableClear(self.houseDatas)
  if Table_GardenHouseType then
    for id, data in pairs(Table_GardenHouseType) do
      if FunctionUnLockFunc.Me():CheckCanOpen(data.MenuID) then
        self.houseDatas[#self.houseDatas + 1] = data
      end
    end
  end
  local myHouseData = HomeProxy.Instance:GetMyHouseData()
  HouseChooseCell.SetSelectID(myHouseData and myHouseData:GetGardenHouseID() or 1)
  self.listHouses:ResetDatas(self.houseDatas)
  self.objNoneTip:SetActive(#self.houseDatas < 1)
end

function HouseChooseView:RefreshSelectStatus()
  local cells = self.listHouses:GetCells()
  for i = 1, #cells do
    cells[i]:RefreshSelect()
  end
end

function HouseChooseView:ClickHouseCell(cell)
  local id = cell.data and cell.data.id
  if not id or id == HouseChooseCell.CurSelectID then
    return
  end
  if self.ltForbidClick then
    MsgManager.ShowMsgByID(49)
    return
  end
  ServiceHomeCmdProxy.Instance:CallOptUpdateHomeCmd(nil, HouseData.HouseOptType.GardenHouse, id)
  self.ltForbidClick = TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
    self.ltForbidClick = nil
  end, self)
  HouseChooseCell.SetSelectID(id)
  self:RefreshSelectStatus()
end

function HouseChooseView:OnEnter()
  HouseChooseView.super.OnEnter(self)
  self:ReloadHouses()
end

function HouseChooseView:OnExit()
  TimeTickManager.Me():ClearTick(self)
  if self.ltForbidClick then
    self.ltForbidClick:Destroy()
    self.ltForbidClick = nil
  end
  HouseChooseCell.SetSelectID(nil)
  HouseChooseView.super.OnExit(self)
end

function HouseChooseView:OnDestroy()
  self.listHouses:Destroy()
  HouseChooseView.super.OnDestroy(self)
end
