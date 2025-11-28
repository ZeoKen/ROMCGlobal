PicTipPopUp = class("PicTipPopUp", BaseView)
autoImport("PicMakeCell")
PicTipPopUp.ViewType = UIViewType.PopUpLayer
PicTipPopUp.TraceNpcId = 6

function PicTipPopUp:Init()
  self.data = self.viewdata.data
  self:InitView()
  self:MapViewEvent()
end

function PicTipPopUp:InitView()
  self.destItemObj = self:FindChild("ItemCell")
  self.stick = self:FindGO("Stick"):GetComponent(UISprite)
  self:AddButtonEvent("Close", function()
    self:CloseSelf()
  end, {hideClickSound = true})
  local picCellObj = self:LoadPreferb("cell/PicMakeCell")
  self.picMakeCell = PicMakeCell.new(picCellObj)
  self.picMakeCell:SetData(self.data)
  self.picMakeCell:ActiveGoMakeButton(true)
  self.picMakeCell:AddEventListener(PicMakeCell.GoToMake, self.GoToMake, self)
  self.picMakeCell:AddEventListener(PicMakeCell.TraceMaterial, self.TraceMaterial, self)
  self.picMakeCell:AddEventListener(PicMakeCell.ClickToItem, self.ClickMaterial, self)
  self.picMakeCell:AddEventListener(PicMakeCell.ClickMaterial, self.ClickMaterial, self)
  local collider = self:FindChild("Collider")
  self:AddClickEvent(collider, function(g)
  end)
end

function PicTipPopUp:GoToMake(cellctl)
  local data = cellctl.data
  local composeID = data and data.staticData.ComposeID
  if composeID then
    local cdata = Table_Compose[composeID]
    if cdata.ROB > MyselfProxy.Instance:GetROB() then
      MsgManager.ShowMsgByID(1)
      return
    end
    local useDeduction = cellctl.checkBtn.value
    ServiceItemProxy.Instance:CallProduce(SceneItem_pb.EPRODUCETYPE_HEAD, composeID, nil, nil, 1, true, useDeduction)
  else
    LogUtility.Error("Cannot find compose ID")
  end
  self:CloseSelf()
end

function PicTipPopUp:TraceMaterial(cellctl)
  self:CloseSelf()
end

function PicTipPopUp:ClickMaterial(materialcell)
  self:ShowPicMakeItemTip(materialcell.data, materialcell.gameObject)
end

function PicTipPopUp:ShowPicMakeItemTip(data, obj)
  if data == self.chooseData then
    self.chooseData = nil
    TipManager.Instance:CloseItemTip()
  else
    self.chooseData = data
    local callback = function()
      self.chooseData = nil
      if self.itemTip and self.itemTip.bdt then
        self:CloseSelf()
      end
    end
    local tipData = {
      itemdata = data,
      funcConfig = {},
      callback = callback,
      ignoreBounds = {obj}
    }
    self.itemTip = self:ShowItemTip(tipData, self.stick, NGUIUtil.AnchorSide.Left)
  end
end

function PicTipPopUp:MapViewEvent()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.Refresh)
end

function PicTipPopUp:Refresh()
  if self.picMakeCell then
    self.picMakeCell:Refresh()
  end
end

function PicTipPopUp:OnEnter()
  PicTipPopUp.super.OnEnter(self)
  self:PlayUISound(AudioMap.UI.OpenView)
end

function PicTipPopUp:OnExit()
  self:PlayUISound(AudioMap.UI.CloseView)
  self:ShowItemTip()
  self.itemTip = nil
  if self.picMakeCell then
    self.picMakeCell:OnRemove()
    self.picMakeCell = nil
  end
  PicTipPopUp.super.OnExit(self)
end
