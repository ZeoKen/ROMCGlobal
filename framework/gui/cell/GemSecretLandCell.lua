local _DefaultIcon = "item_45001"
autoImport("GemCell")
GemSecretLandCell = class("GemSecretLandCell", CoreView)

function GemSecretLandCell:ctor(obj)
  GemSecretLandCell.super.ctor(self, obj)
  self:Init()
end

function GemSecretLandCell:Init()
  self.bgSp = self:FindComponent("Bg", UISprite)
  self.sp = self:FindComponent("Icon", UISprite)
  self.nameLabel = self:FindComponent("ItemName", UILabel)
  self.descLabel = self:FindComponent("ItemDesc", UILabel)
  self.lvLab = self:FindComponent("LvLab", UILabel)
end

function GemSecretLandCell:SetData(data)
  self.data = data and data.secretLandDatas
  local staticData = data and data.staticData
  self.gameObject:SetActive(staticData ~= nil)
  if not staticData then
    return
  end
  if self.sp then
    local success = IconManager:SetItemIcon(staticData.Icon, self.sp) or IconManager:SetItemIcon(_DefaultIcon, self.sp)
    if success then
      self.sp:MakePixelPerfect()
    end
  end
  if self.nameLabel then
    self.nameLabel.text = staticData.NameZh
    UIUtil.FitLableMaxHeight(self.nameLabel, 45)
  end
  if self.descLabel then
    self.descLabel.text = self.data.desc
  end
  if self.bgSp then
    self.bgSp.height = 40 + self.descLabel.height
  end
  if self.lvLab then
    self.lvLab.text = self.data.lv
  end
end
