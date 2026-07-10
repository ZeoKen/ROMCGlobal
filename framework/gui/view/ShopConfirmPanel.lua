ShopConfirmPanel = class("ShopConfirmPanel", BaseView)
ShopConfirmPanel.ViewType = UIViewType.ConfirmLayer

function ShopConfirmPanel:Init()
  self.data = self.viewdata.viewdata and self.viewdata.viewdata.data or nil
  self.callback = self.data.callback
  local panelAction = self:FindGO("pannelAction")
  local cancelBtn = self:FindGO("cancel", panelAction)
  self:AddClickEvent(cancelBtn, function(go)
    self:CloseSelf()
  end)
  local confirmBtn = self:FindGO("comfirm", panelAction)
  self:AddClickEvent(confirmBtn, function(go)
    self:dealCallback()
  end)
  local title = self:FindGO("title"):GetComponent(UILabel)
  title.text = self.data.title
  self.des = self:FindGO("des"):GetComponent(UILabel)
  self.des.text = self.data.desc
  self:RefreshDescClickUrl()
end

function ShopConfirmPanel:RefreshDescClickUrl()
  local desc = self.data and self.data.desc or ""
  if self.data and self.data.clickUrlCallback and string.match(desc, "%[url=") then
    UIUtil.TryAddClickUrlCompToGameObject(self.des.gameObject, self.data.clickUrlCallback)
  else
    UIUtil.TryRemoveClickUrlCompFromGameObject(self.des.gameObject)
  end
end

function ShopConfirmPanel:RefreshDetail()
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

function ShopConfirmPanel:dealCallback()
  if self.callback then
    self.callback()
  end
  self:CloseSelf()
end

function ShopConfirmPanel:OnEnter()
  ShopConfirmPanel.super.OnEnter(self)
  self:RefreshDetail()
end

function ShopConfirmPanel:OnExit()
  ShopConfirmPanel.super.OnExit(self)
end
