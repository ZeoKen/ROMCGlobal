PopUpItemView = class("PopUpItemView", BaseView)
PopUpItemView.ViewType = UIViewType.Popup10Layer

function PopUpItemView:Init()
  self.content = self:FindComponent("Content", UILabel)
  self.itemGrid = self:FindComponent("ItemGrid", UIGrid)
  self.ctl = UIGridListCtrl.new(self.itemGrid, ItemCell, "ItemCell")
  self.icon = self:FindComponent("TitleIcon", UISprite)
  self.bgClick = self:FindGO("BgClick")
  self:AddClickEvent(self.bgClick, function(go)
    self:CloseSelf()
  end)
  self.effectMap = {}
  local tPath = ResourcePathHelper.Effect(ResourcePathHelper.UIEffect("TitleEffect"))
  local parent = self:FindGO("TitleEffect")
  self.effectMap[1] = self:LoadPreferb_ByFullPath(tPath, parent)
  self.effectMap[2] = self:LoadPreferb_ByFullPath(tPath, parent)
end

function PopUpItemView:OnEnter()
  PopUpItemView.super.OnEnter(self)
  self.gameObject:SetActive(true)
  local viewdata = self.viewdata.viewdata
  if viewdata then
    local icon, datas, effectIndex, content = viewdata.icon, viewdata.datas, viewdata.effectIndex, viewdata.content
    self:UpdateData(icon, datas, effectIndex, content)
  end
end

function PopUpItemView:UpdateData(icon, datas, effectIndex, content)
  self.icon.spriteName = tostring(icon)
  self.icon:MakePixelPerfect()
  if content then
    self.itemGrid.gameObject:SetActive(false)
    self.content.gameObject:SetActive(true)
    self.content.text = content
  else
    self.itemGrid.gameObject:SetActive(true)
    self.content.gameObject:SetActive(false)
    self.ctl:ResetDatas(datas)
  end
  effectIndex = effectIndex or 1
  for i = 1, #self.effectMap do
    self.effectMap[i]:SetActive(i == effectIndex)
  end
end

function PopUpItemView:OnExit()
  PopUpItemView.super.OnExit(self)
  self.gameObject:SetActive(false)
end
