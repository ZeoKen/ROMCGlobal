NewShopConfirmPanel = class("NewShopConfirmPanel", BaseView)
NewShopConfirmPanel.ViewType = UIViewType.Lv4PopUpLayer

function NewShopConfirmPanel:Init()
  self.data = self.viewdata.viewdata and self.viewdata.viewdata.data or nil
  self.callback = self.data.callback
  self.cancelCallback = self.data.cancelcallback
  self.bg = self:FindGO("bg")
  self.bg_sp = self.bg:GetComponent(UISprite)
  self.panelAction = self:FindGO("pannelAction")
  local cancelBtn = self:FindGO("cancel", self.panelAction)
  self:AddClickEvent(cancelBtn, function(go)
    self:dealCancelCallBack()
  end)
  self.cancelLabel = self:FindComponent("Title", UILabel, cancelBtn)
  local confirmBtn = self:FindGO("comfirm", self.panelAction)
  self:AddClickEvent(confirmBtn, function(go)
    self:dealCallback()
  end)
  self.confirmLabel = self:FindComponent("Title", UILabel, confirmBtn)
  self.contentDownBg = self:FindGO("scrollviewbgdown")
  self.desRoot = self:FindGO("desroot")
  self.desRootTrans = self.desRoot.transform
  self.title = self:FindGO("title"):GetComponent(UILabel)
  self.des = self:FindGO("des"):GetComponent(UILabel)
  
  function self.des.onPostFill(widget)
    self:ResizeView(widget)
  end
end

function NewShopConfirmPanel:ResizeView(deslab)
  local titleHeight = self.showTitle and 40 or 0
  if deslab.height > 255 then
    self.des.alignment = 1
    self.bg_sp.height = 411 + titleHeight
    LuaGameObject.SetLocalPositionGO(self.contentDownBg, 0, -135, 0)
    LuaGameObject.SetLocalPositionGO(self.panelAction, 0, -180, 0)
  else
    self.des.alignment = 1
    local bounds = self.des:CalculateBounds(self.desRootTrans)
    local content_UpY, content_DownY = bounds.max[2], bounds.min[2]
    LuaGameObject.SetLocalPositionGO(self.contentDownBg, 0, content_DownY, 0)
    LuaGameObject.SetLocalPositionGO(self.panelAction, 0, content_DownY - 52, 0)
    self.bg_sp.height = 157 - (content_DownY - 52 - 72) + titleHeight
  end
end

function NewShopConfirmPanel:RefreshView()
  if self.data.title and self.data.title ~= "" then
    self.title.text = self.data.title
    self.showTitle = true
    LuaGameObject.SetLocalPositionGO(self.desRoot, 0, 10, 0)
  else
    self.title.text = ""
    self.showTitle = false
    LuaGameObject.SetLocalPositionGO(self.desRoot, 0, 50, 0)
  end
  self.des.text = self.data.desc
  if self.data.button and self.data.button ~= "" then
    self.confirmLabel.text = self.data.button
  else
    self.confirmLabel.text = ZhString.GuestSecurityConfirm
  end
  if self.data.buttonF and self.data.buttonF ~= "" then
    self.cancelLabel.text = self.data.buttonF
  else
    self.cancelLabel.text = ZhString.GuestSecurityCancel
  end
end

function NewShopConfirmPanel:RefreshDetail()
  local des1 = self:FindGO("des_add"):GetComponent(UILabel)
  local detailBtn = self:FindGO("detailBtn")
  local detailBtnTxt = detailBtn:GetComponent(UILabel)
  if BranchMgr.IsKorea() or BranchMgr.IsSEA() or BranchMgr.IsNA() or BranchMgr.IsEU() then
    des1.text = ZhString.ShopConfirmDes1
    detailBtnTxt.text = ZhString.ShopConfirmBtnTxt
    detailBtn:SetActive(true)
    local ScrollView = self:FindGO("ScrollView"):GetComponent(UIScrollView)
    local detailTxt = self:FindGO("Text", ScrollView.gameObject):GetComponent(UILabel)
    detailTxt.text = ZhString.ShopConfirmDesTxT
    local detailTxtContainer = self:FindGO("detailTxtContainer")
    self:AddClickEvent(detailBtn, function(go)
      detailTxtContainer:SetActive(true)
      ScrollView:ResetPosition()
    end)
    local detailConfirmBtn = self:FindGO("detailConfirm", detailTxtContainer)
    self:AddClickEvent(detailConfirmBtn, function(go)
      detailTxtContainer:SetActive(false)
    end)
  else
    des1.text = nil
    detailBtnTxt.text = nil
    detailBtn:SetActive(false)
  end
end

function NewShopConfirmPanel:dealCancelCallBack()
  if self.cancelCallback then
    self.cancelCallback()
  end
  self:CloseSelf()
end

function NewShopConfirmPanel:dealCallback()
  if self.callback then
    self.callback()
  end
  self:CloseSelf()
end

function NewShopConfirmPanel:OnEnter()
  NewShopConfirmPanel.super.OnEnter(self)
  EventManager.Me():AddEventListener("XDEChangeZ", self.OnCHangeZ, self)
  self:RefreshView()
  self:RefreshDetail()
end

function NewShopConfirmPanel:OnExit()
  NewShopConfirmPanel.super.OnExit(self)
  EventManager.Me():RemoveEventListener("XDEChangeZ", self.OnCHangeZ, self)
end

function NewShopConfirmPanel:OnCHangeZ(data)
  local uipanels = Game.GameObjectUtil:GetAllComponentsInChildren(self.gameObject, UIPanel, true)
  for i = 1, #uipanels do
    local oriDepth = uipanels[i].depth
    oriDepth = oriDepth % 10
    uipanels[i].depth = data.depth + oriDepth
  end
end
