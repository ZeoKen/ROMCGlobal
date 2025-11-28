autoImport("BaseTip")
autoImport("GiftDetailCell")
GiftDetailTip = class("GiftDetailTip", BaseTip)
GiftDetailTip.ShowPreview = "GiftDetailTip_ShowPreview"
GiftDetailTip.Close = "GiftDetailTip_Close"

function GiftDetailTip:ctor(name, parent, depth)
  self.depth = depth
  GiftDetailTip.super.ctor(self, name, parent)
end

function GiftDetailTip:Init()
  self:FindObjs()
  if not self.depth then
    local parentPanel = UIUtil.GetComponentInParents(self.gameObject, UIPanel)
    if parentPanel then
      self.panel.depth = parentPanel.depth + 1
      self.contentPanel.depth = self.panel.depth + 1
    end
  else
    self.panel.depth = self.depth
    self.contentPanel.depth = self.depth + 1
  end
  EventManager.Me():AddEventListener(ServiceEvent.SessionShopRewardSafetyQueryShopCmd, self.RefreshView, self)
end

function GiftDetailTip:FindObjs()
  self.panel = self.gameObject:GetComponent(UIPanel)
  local closeButton = self:FindGO("CloseButton")
  self:AddClickEvent(closeButton, function()
    self:CloseSelf()
  end)
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closecomp.callBack()
    self:CloseSelf()
  end
  
  self.contentPanel = self:FindComponent("contentScrollView", UIPanel)
  local grid = self:FindComponent("Grid", UIGrid)
  self.itemListCtrl = UIGridListCtrl.new(grid, GiftDetailCell, "GiftDetailCell")
  self.itemListCtrl:AddEventListener(GiftDetailTip.ShowPreview, self.ShowPreview, self)
end

function GiftDetailTip:SetData(itemId)
  self.itemId = itemId
  local configUseItem = Table_UseItem[self.itemId]
  if configUseItem and configUseItem.UseEffect and configUseItem.UseEffect.type == "selectreward" then
    local items = configUseItem.UseEffect.item
    local datas = {}
    for i = 1, #items do
      local item = items[i]
      local data = {}
      data.itemid = item[1]
      data.num = item[2]
      table.insert(datas, data)
    end
    self.itemListCtrl:ResetDatas(datas)
  else
    ServiceSessionShopProxy.Instance:CallRewardSafetyQueryShopCmd(self.itemId)
  end
end

function GiftDetailTip:RefreshView()
  if not self.itemId then
    return
  end
  local bagGiftItemShowInfos = NewRechargeProxy.Instance:GetBagGiftItemShowInfos(self.itemId)
  if bagGiftItemShowInfos then
    local datas = {}
    for i = 1, #bagGiftItemShowInfos do
      local list = bagGiftItemShowInfos[i]
      for j = 1, #list do
        local giftInfo = list[j]
        table.insert(datas, giftInfo)
      end
    end
    self.itemListCtrl:ResetDatas(datas)
  end
end

function GiftDetailTip:ShowPreview(cell)
  if cell.data then
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.GiftDetailPreview,
      viewdata = cell.data.itemid
    })
  end
end

function GiftDetailTip:SetPos(pos)
  if pos then
    self.gameObject.transform.localPosition = pos
  end
end

function GiftDetailTip:OnExit()
  EventManager.Me():RemoveEventListener(ServiceEvent.SessionShopRewardSafetyQueryShopCmd, self.RefreshView, self)
  self.itemListCtrl:Destroy()
  self.itemListCtrl = nil
  self.closecomp.callBack = nil
  self.closecomp = nil
  self:DestroySelf()
end

function GiftDetailTip:CloseSelf()
  self:PassEvent(GiftDetailTip.Close)
end

function GiftDetailTip:AddIgnoreBounds(obj)
  if self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end
