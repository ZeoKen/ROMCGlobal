NewRechargeRightContentTipCell = class("NewRechargeRightContentTipCell", NewRechargeGiftTipCell)

function NewRechargeRightContentTipCell:FindObjs()
  NewRechargeRightContentTipCell.super.FindObjs(self)
  local panel = self.gameObject:GetComponent(UIPanel)
  local scrollView = self:FindGO("uiScrollView")
  local scrollViewTips = self:FindGO("ScrollView")
  if panel ~= nil then
    panel.depth = 1
  end
  panel = scrollView:GetComponent(UIPanel)
  if panel ~= nil then
    panel.depth = 2
  end
  panel = scrollViewTips:GetComponent(UIPanel)
  if panel ~= nil then
    panel.depth = 2
  end
  self.m_goodsItemTipAnchor = self:FindComponent("uiImgBgTop", UISprite)
  self.showTipSelfOffsetX = 0
  self.showTipOffset = {198, 0}
  self.cfg_noSelfClose = false
end

function NewRechargeRightContentTipCell:SetPosOffset(x, y)
  self.showTipOffset_x = x
  self.showTipOffset_y = y
end

function NewRechargeRightContentTipCell:updateLocalPostion(x)
  if self.m_uiImgMask then
    self.m_uiImgMask.transform.localPosition = LuaGeometry.GetTempVector3(-x, 0, 0)
  end
  if self.gameObject then
    self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(self.showTipOffset_x + x, self.showTipOffset_y, 0)
  end
end

function NewRechargeRightContentTipCell:setLocalPosition(x)
  self:updateLocalPostion(x)
end

function NewRechargeRightContentTipCell:onShowFashionPreview(value)
  NewRechargeRightContentTipCell.super.onShowFashionPreview(self, value)
  if self.m_fashionPreviewTip then
    self.m_fashionPreviewTip.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(410, 325, 0)
  end
end
