local baseCell = autoImport("BaseCell")
AppIconCell = class("AppIconCell", baseCell)

function AppIconCell:Init()
  self:FindObjs()
  self:AddButtonEvt()
end

function AppIconCell:FindObjs()
  self.icon = self.gameObject:GetComponent(UITexture)
  self.chooseSymbol = self:FindGO("chooseSymbol")
end

function AppIconCell:AddButtonEvt()
  self:AddCellClickEvent()
end

function AppIconCell:SetData(data)
  if data then
    self.data = data
    PictureManager.Instance:SetAppIcon(self.data.iconStr, self.icon)
  end
end

function AppIconCell:SetChoose(isChoose)
  self.chooseSymbol:SetActive(isChoose)
end

function AppIconCell:OnDestroy()
  if self.data then
    PictureManager.Instance:UnLoadAppIcon(self.data.iconStr, self.icon)
  end
end
