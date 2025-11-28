autoImport("GemCell")
GemExhibitCell = class("GemExhibitCell", CoreView)
GemExhibitQualityDesc = {
  [1] = ZhString.Gem_ExhibitDesc1,
  [2] = ZhString.Gem_ExhibitDesc2,
  [3] = ZhString.Gem_ExhibitDesc3,
  [4] = ZhString.Gem_ExhibitDesc4
}

function GemExhibitCell:ctor(obj)
  GemExhibitCell.super.ctor(self, obj)
  self:Init()
end

function GemExhibitCell:Init()
  self.bgSp = self:FindComponent("Background", UISprite)
  self.sp = self:FindComponent("Icon", UISprite)
  self.simpleNameLab = self:FindComponent("SimpleNameLab", UILabel)
  self.nameLabel = self:FindComponent("ItemName", UILabel)
  self.descLabel = self:FindComponent("ItemDesc", UILabel)
  self.chooseButton = self:FindGO("ChooseButton")
  self.qualitySp = self:FindComponent("Quality", UISprite)
  self:AddClickEvent(self.chooseButton and self.chooseButton or self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function GemExhibitCell:SetData(staticData)
  self.data = staticData
  self.gameObject:SetActive(staticData ~= nil)
  if not staticData then
    return
  end
  self.staticItemData = Table_Item[staticData.id]
  if not self.staticItemData then
    LogUtility.WarningFormat("Cannot find static item data of gem whose staticId = {0}", staticData.id)
    return
  end
  if self.sp then
    local success = IconManager:SetItemIcon(self.staticItemData.Icon, self.sp) or IconManager:SetItemIcon("item_45001", self.sp)
    if success then
      self.sp:MakePixelPerfect()
    end
  end
  if self.bgSp then
    IconManager:SetUIIcon(GemCell.SkillBgSpriteNames[staticData.Quality] or GemCell.AttrBgSpriteName, self.bgSp)
  end
  if self.nameLabel then
    self.nameLabel.text = self.staticItemData.NameZh
    UIUtil.FitLableMaxHeight(self.nameLabel, 45)
  end
  if self.descLabel then
    self.descLabel.text = GemExhibitQualityDesc[staticData.Quality] or ""
  end
  if self.qualitySp then
    self.qualitySp.spriteName = GemCell.SkillQualitySpriteNames[staticData.Quality]
  end
  self:UpdateSimpleName()
end

function GemExhibitCell:UpdateSimpleName()
  if not self.simpleNameLab then
    return
  end
  if not self.staticItemData then
    self:Hide(self.simpleNameLab)
    return
  end
  self:Show(self.simpleNameLab)
  self.simpleNameLab.text = GemProxy.GetSimpleGemName(self.staticItemData)
end
