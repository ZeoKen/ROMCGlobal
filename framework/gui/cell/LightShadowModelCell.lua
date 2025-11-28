local BaseCell = autoImport("BaseCell")
LightShadowModelCell = class("LightShadowModelCell", BaseCell)

function LightShadowModelCell:Init()
  self:FindObjs()
end

function LightShadowModelCell:FindObjs()
  self.bg = self.gameObject:GetComponent(UISprite)
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
  self.doneObj = self:FindGO("Done"):GetComponent(UISprite)
  self.choosen = self:FindGO("Choosen"):GetComponent(UISprite)
  self:AddCellClickEvent()
end

function LightShadowModelCell:SetData(data)
  self.data = data
  IconManager:SetUIIcon(self.data.icon, self.icon)
  self.icon:MakePixelPerfect()
  self:UpdateChoose()
  self:UpdateFinished()
end

function LightShadowModelCell:SetChooseId(chooseId)
  self.chooseId = chooseId
  self:UpdateChoose()
end

function LightShadowModelCell:UpdateChoose()
  if self.chooseId and self.data and self.data.ID == self.chooseId then
    self.choosen.gameObject:SetActive(true)
  else
    self.choosen.gameObject:SetActive(false)
  end
end

function LightShadowModelCell:UpdateFinished()
  local done = self.data and self.data.done
  if done == self.done then
    return
  end
  self.done = done
  self.doneObj.gameObject:SetActive(done)
  if done then
    ColorUtil.DeepGrayUIWidget(self.bg)
    ColorUtil.DeepGrayUIWidget(self.icon)
  else
    ColorUtil.WhiteUIWidget(self.bg)
    ColorUtil.WhiteUIWidget(self.icon)
  end
end
