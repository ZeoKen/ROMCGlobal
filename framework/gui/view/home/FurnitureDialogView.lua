FurnitureDialogView = class("FurnitureDialogView", BaseView)
FurnitureDialogView.ViewType = UIViewType.DialogLayer
autoImport("FurnitureFunctionCell")

function FurnitureDialogView:Init()
  self:InitView()
  self:InitViewEvents()
end

function FurnitureDialogView:InitView()
  self.objContent = self:FindGO("Content")
  self.labTip = self:FindComponent("labTip", UILabel, self.objContent)
  self.menu = self:FindGO("Menu", self.objContent)
  self.menuSprite = self.menu:GetComponent(UISprite)
  self.menuCtl = UIGridListCtrl.new(self:FindComponent("MenuGrid", UIGrid, self.menu), FurnitureFunctionCell, "FurnitureFunctionCell")
  self.menuCtl:AddEventListener(MouseEvent.MouseClick, self.ClickMenuEvent, self)
  self:AddClickEvent(self:FindGO("CloseCollider"), function()
    self:CloseSelf(true)
  end)
end

function FurnitureDialogView:InitViewEvents()
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
end

function FurnitureDialogView:OnEnter()
  FurnitureDialogView.super.OnEnter(self)
  local viewdata = self.viewdata and self.viewdata.viewdata
  self.nFurniture = viewdata and viewdata.nFurniture
  self.listFunctionDatas = viewdata and viewdata.functions
  if not self.nFurniture or not self.listFunctionDatas then
    LogUtility.Error("No NFurniture Data!")
    self:CloseSelf()
    return
  end
  self:UpdateMenuCtl()
  self:ClearLTInitView()
  self.objContent:SetActive(false)
  self:CameraFocusOnNpc(self.nFurniture.trans, nil, nil, function()
    self:ClearLTInitView()
    if LuaGameObject.ObjectIsNull(self.objContent) then
      return
    end
    self.objContent:SetActive(true)
  end)
  self.nFurniture:AccessStart()
  self.ltInitView = TimeTickManager.Me():CreateOnceDelayTick(5000, function(owner, deltaTime)
    self.ltInitView = nil
    if LuaGameObject.ObjectIsNull(self.objContent) then
      self:CloseSelf()
      return
    end
    self.objContent:SetActive(true)
  end, self)
end

function FurnitureDialogView:UpdateMenuCtl()
  if not self.listFunctionDatas then
    return
  end
  self.menuCtl:ResetDatas(self.listFunctionDatas)
  self.menuCtl.layoutCtrl.repositionNow = true
  self.menuSprite.height = 60 + #self.listFunctionDatas * 70
end

function FurnitureDialogView:ClickMenuEvent(cellCtl)
  if not cellCtl.data then
    return
  end
  local stay = FunctionFurnitureFunc.Me():DoFurnitureFunc(cellCtl.data.functionStaticData, self.nFurniture, cellCtl.data.param)
  if not stay then
    self:CloseSelf()
  end
end

function FurnitureDialogView:ClearLTInitView()
  if not self.ltInitView then
    return
  end
  self.ltInitView:Destroy()
  self.ltInitView = nil
end

function FurnitureDialogView:CloseSelf(isAccessOver)
  if isAccessOver then
    self.nFurniture:AccessOver()
    self:CameraReset(HomeManager.Me():GetMyselfDistanceToFurniture(self.nFurniture) > 8 and 0 or nil)
  end
  FurnitureDialogView.super.CloseSelf(self)
end

function FurnitureDialogView:OnExit()
  self:ClearLTInitView()
  self:CameraReset()
  HomeManager.Me():ClearFurnitureFuncList()
  FurnitureDialogView.super.OnExit(self)
end
