local BaseCell = autoImport("BaseCell")
YmirTipCell = class("YmirTipCell", BaseCell)

function YmirTipCell:Init()
  self.icon = self:FindComponent("Icon", UISprite)
  self.name = self:FindComponent("SaveName", UILabel)
  self.charName = self:FindComponent("CharName", UILabel)
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self.charNameBG = self:FindComponent("CharNameBG", UISprite)
  self.iconGo = self:FindGO("IconBg")
  self.emptyIcon = self:FindComponent("EmptyIconBg", UISprite)
  self.saveBtn = self:FindComponent("SaveBtn", UISprite)
end

function YmirTipCell:SetData(data)
  self.data = data
  if data then
    if data.profession then
      self.iconGo:SetActive(true)
      self.emptyIcon.gameObject:SetActive(false)
      local profConfig = Table_Class[data.profession]
      if profConfig then
        IconManager:SetProfessionIcon(profConfig.icon, self.icon)
        self.icon:MakePixelPerfect()
        self.icon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.4, 0.4, 1)
      end
      self.name.text = AppendSpace2Str(data.recordname) or ""
      self.charName.text = data.charname or ""
    else
      self.iconGo:SetActive(false)
      self.emptyIcon.gameObject:SetActive(true)
      self.name.text = ""
      self.charName.text = ""
    end
    self:SetAlpha(data.can_load and 1 or 0.5)
  else
    self:SetAlpha(0.5)
  end
end

function YmirTipCell:SetAlpha(a)
  self.icon.alpha = a
  self.name.alpha = a
  self.charName.alpha = a
  self.charNameBG.alpha = a
  self.emptyIcon.alpha = a
  self.saveBtn.alpha = a
end

function YmirTipCell:SetInQuickSaveMode(status)
  self.saveBtn.gameObject:SetActive(status)
end
