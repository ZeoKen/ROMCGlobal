autoImport("FastClassChangeGetGemCell")
autoImport("GemCell")
FastClassChangeGetGemPopUp = class("FastClassChangeGetGemPopUp", ContainerView)
FastClassChangeGetGemPopUp.ViewType = UIViewType.NormalLayer

function FastClassChangeGetGemPopUp:Init()
  self:InitData()
  self:InitView()
end

function FastClassChangeGetGemPopUp:InitData()
  local myProfession = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
  local S_Quality = 3
  self.gems = {}
  for id, data in pairs(Table_GemRate) do
    if data.Quality == S_Quality and TableUtility.ArrayFindIndex(data.ClassType, myProfession) > 0 then
      TableUtility.ArrayPushBack(self.gems, ItemData.new(tostring(id), id))
    end
  end
  table.sort(self.gems, function(l, r)
    return l.id < r.id
  end)
end

function FastClassChangeGetGemPopUp:InitView()
  self:FindComponent("title", UILabel).text = ZhString.FastClassChangeGetGem_Title
  self:FindComponent("btntext", UILabel).text = ZhString.FloatAwardView_Confirm
  self.gemlistsv = self:FindComponent("ItemScrollView", ROUIScrollView)
  local wrapCfg = {
    wrapObj = self:FindGO("ItemContainer"),
    pfbNum = 7,
    cellName = "GemCell",
    control = FastClassChangeGetGemCell,
    dir = 2,
    disableDragIfFit = true
  }
  self.itemWrapHelper = WrapCellHelper.new(wrapCfg)
  self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandlerGemItemClick, self)
  self.itemWrapHelper:ResetDatas(self.gems)
  self.itemWrapHelper:ResetPosition()
  self.listCells = self.itemWrapHelper:GetCellCtls()
  self.ConfirmButton = self:FindGO("ConfirmButton")
  self.ConfirmBC = self.ConfirmButton:GetComponent(BoxCollider)
  self:AddClickEvent(self.ConfirmButton, function()
    self:SendGetGem()
  end)
  self.tipCloseComp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function self.tipCloseComp.callBack()
    self:CloseSelf()
  end
  
  self.tipCloseComp:AddTarget(self.gameObject.transform)
  self.ConfirmBC.enabled = false
  self:SetTextureGrey(self.ConfirmButton)
end

function FastClassChangeGetGemPopUp:HandlerGemItemClick(cellctl)
  local selectId = cellctl and cellctl.data and cellctl.data.id
  if selectId then
    for _, cell in pairs(self.listCells) do
      cell:SetChoose(selectId)
    end
    if self.selectId == selectId then
      GemCell.ShowGemTip(cellctl.gameObject, cellctl.data)
    end
    self.selectId = selectId
    self.ConfirmBC.enabled = true
    self:SetTextureWhite(self.ConfirmButton, ColorUtil.ButtonLabelBlue)
  end
end

function FastClassChangeGetGemPopUp:SendGetGem()
  if self.selectId then
    ServiceNUserProxy.Instance:CallFastTransGemGetUserCmd(self.selectId)
    self:CloseSelf()
  end
end
