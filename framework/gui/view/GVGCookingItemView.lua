local BaseCell = autoImport("BaseCell")
GVGCookingItemView = class("GVGCookingItemView", BaseCell)

function GVGCookingItemView:Init()
  self.m_uiTxtDesc = self:FindGO("uiImgDesc"):GetComponent(UILabel)
end

function GVGCookingItemView:OnExit()
end

function GVGCookingItemView:SetData(value)
  self.m_uiTxtDesc.text = value
end
