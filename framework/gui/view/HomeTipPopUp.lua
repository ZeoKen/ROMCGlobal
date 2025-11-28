HomeTipPopUp = class("HomeTipPopUp", BaseView)
autoImport("HomeMakeCell")
HomeTipPopUp.ViewType = UIViewType.PopUpLayer
HomeTipPopUp.TraceNpcId = 6

function HomeTipPopUp:Init()
  self.data = self.viewdata
  if type(self.data.viewdata) == "table" then
    if self.data and self.data.staticData and self.data.staticData.ComposeID then
      self.composeData = Table_Compose[self.data.staticData.ComposeID]
      self.composeId = self.data.staticData.ComposeID
    end
  elseif type(self.data.viewdata) == "number" then
    local itemData = Table_Item[self.data.viewdata]
    local composeID = itemData and itemData.ComposeID
    self.composeId = composeID
    self.composeData = Table_Compose[composeID]
  end
  self:InitView()
  self:MapViewEvent()
end

function HomeTipPopUp:InitView()
  self.destItemObj = self:FindChild("ItemCell")
  self.stick = self:FindGO("Stick"):GetComponent(UISprite)
  self:AddButtonEvent("Close", function()
    self:CloseSelf()
  end, {hideClickSound = true})
  local homeCellObj = self:LoadPreferb("cell/HomeMakeCell")
  self.homeMakeCell = HomeMakeCell.new(homeCellObj)
  self.homeMakeCell:SetData(self.data)
  self.homeMakeCell:ActiveGoMakeButton(true)
  self.homeMakeCell:AddEventListener(HomeMakeCell.GoToMake, self.GoToMake, self)
  self.homeMakeCell:AddEventListener(HomeMakeCell.TraceMaterial, self.TraceMaterial, self)
  self.homeMakeCell:AddEventListener(HomeMakeCell.ClickToItem, self.ClickMaterial, self)
  self.homeMakeCell:AddEventListener(HomeMakeCell.ClickMaterial, self.ClickMaterial, self)
  local collider = self:FindChild("Collider")
  self:AddClickEvent(collider, function(g)
  end)
end

function HomeTipPopUp:GoToMake(cellctl)
  if self.validStamp and ServerTime.CurServerTime() / 1000 < self.validStamp then
    return
  end
  self.validStamp = ServerTime.CurServerTime() / 1000 + 0.5
  local data = cellctl.data
  if data.lackMoney then
    MsgManager.ShowMsgByID(1)
  else
    local useDeduction = cellctl.checkBtn.value
    ServiceItemProxy.Instance:CallProduce(SceneItem_pb.EPRODUCETYPE_FURNITURE, data.composeId, nil, nil, data.composeCount, true, useDeduction)
  end
  self:CloseSelf()
end

function HomeTipPopUp:TraceMaterial(cellctl)
  self:CloseSelf()
end

function HomeTipPopUp:ClickMaterial(materialcell)
  self:ShowHomeMakeItemTip(materialcell.data, materialcell.gameObject)
end

function HomeTipPopUp:ShowHomeMakeItemTip(data, obj)
  if data == self.chooseData then
    self.chooseData = nil
    TipManager.Instance:CloseItemTip()
  else
    self.chooseData = data
    local callback = function()
      self.chooseData = nil
    end
    local tipData = {
      itemdata = data,
      funcConfig = {},
      callback = callback,
      ignoreBounds = {obj}
    }
    self:ShowItemTip(tipData, self.stick, NGUIUtil.AnchorSide.Left)
  end
end

function HomeTipPopUp:MapViewEvent()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.Refresh)
end

function HomeTipPopUp:Refresh()
  if self.homeMakeCell then
    self.homeMakeCell:Refresh()
  end
end

function HomeTipPopUp:OnEnter()
  HomeTipPopUp.super.OnEnter(self)
  self:PlayUISound(AudioMap.UI.OpenView)
end

function HomeTipPopUp:OnExit()
  self:PlayUISound(AudioMap.UI.CloseView)
  self:ShowItemTip()
  self.homeMakeCell:OnRemove()
  HomeTipPopUp.super.OnExit(self)
end
