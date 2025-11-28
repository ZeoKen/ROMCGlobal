ItemTipGemExhibitCell = class("ItemTipGemExhibitCell", CoreView)
local tempArr = {
  {},
  {},
  {}
}

function ItemTipGemExhibitCell:ctor(container)
  local obj = self:LoadPreferb("cell/ItemTipGemExhibitCell", container)
  if not obj then
    LogUtility.Error("Cannot load ItemTipGemExhibitCell")
    return
  end
  obj.transform.localPosition = LuaVector3.Zero()
  ItemTipGemExhibitCell.super.ctor(self, obj)
  local panel = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIPanel)
  self.tipPanel = self:FindComponent("ScrollView", UIPanel)
  self.tipPanel.depth = panel.depth + 1
  self:Init()
end

function ItemTipGemExhibitCell:Init()
  self.gemBgSp = self:FindComponent("Background", UISprite)
  self.gemIconSp = self:FindComponent("Icon", UISprite)
  self.nameLabel = self:FindComponent("ItemName", UILabel)
  local attriTable = self:FindComponent("AttriTable", UITable)
  self.attriCtrl = UIGridListCtrl.new(attriTable, TipLabelCell, "TipLabelCell")
  self.attriScrollView = self:FindComponent("ScrollView", UIScrollView)
  local tipHideFunc = function()
    self:Hide()
  end
  self:AddButtonEvent("TipCloseBtn", tipHideFunc)
  self.tipCloseComp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  self.tipCloseComp.callBack = tipHideFunc
  self:AddCloseCompTarget(self)
end

function ItemTipGemExhibitCell:AddCloseCompTarget(target)
  if not target or not target.gameObject then
    return
  end
  self.tipCloseComp:AddTarget(target.gameObject.transform)
end

function ItemTipGemExhibitCell:SetData(data)
  if type(data) ~= "table" or not data.id then
    self:Hide()
    return
  end
  local success = IconManager:SetItemIcon(Table_Item[data.id].Icon, self.gemIconSp)
  if success then
    self.gemIconSp:MakePixelPerfect()
  end
  success = IconManager:SetUIIcon(GemCell.SkillBgSpriteNames[data.Quality] or GemCell.AttrBgSpriteName, self.gemBgSp)
  if success then
    self.gemBgSp:MakePixelPerfect()
  end
  self.nameLabel.text = Table_Item[data.id].NameZh
  local index = 1
  tempArr[index].label = GemProxy.Instance:GetSkillGemExhibitEffectDescArray(data.id)
  tempArr[index].hideline = false
  index = index + 1
  local profDesc = GemProxy.GetProfessionDescFromSkillGem(data.id)
  if profDesc and profDesc ~= "" then
    tempArr[index].label = profDesc
    tempArr[index].hideline = false
    index = index + 1
  end
  local desc = Table_Item[data.id].Desc
  if desc and desc ~= "" then
    tempArr[index].label = desc
    tempArr[index].hideline = true
    index = index + 1
  end
  self.attriCtrl:ResetDatas(tempArr)
  self.attriScrollView:ResetPosition()
  self.attriScrollView.gameObject:SetActive(false)
  self.attriScrollView.gameObject:SetActive(true)
end

function ItemTipGemExhibitCell:SetActive(isActive)
  if isActive then
    self:Show()
  else
    self:Hide()
  end
end
