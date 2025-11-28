ProfessionCell = class("ProfessionCell", BaseCell)

function ProfessionCell:Init()
  self.root = self:FindGO("Root")
  self.iconSp = self:FindComponent("Icon", UISprite, self.root)
  self.colorSp = self:FindComponent("Color", UISprite, self.root)
  self.empty = self:FindGO("Empty")
end

function ProfessionCell:SetData(data)
  self.data = data
  if data and 0 ~= data then
    self.root:SetActive(true)
    local proData = Table_Class[data.profession]
    if proData then
      if IconManager:SetProfessionIcon(proData.icon, self.iconSp) then
        self:ShowEmpty(false)
        local colorKey = "CareerIconBg" .. proData.Type
        self.proColorSave = ProfessionProxy.Instance:SafeGetColorFromColorUtil(colorKey)
        self.colorSp.color = self.proColorSave
      else
        self:ShowEmpty(true)
      end
    else
      self:ShowEmpty(true)
    end
  else
    self:ShowEmpty(true)
  end
end

function ProfessionCell:ShowEmpty(var)
  self.empty:SetActive(var)
  self.root:SetActive(not var)
end
