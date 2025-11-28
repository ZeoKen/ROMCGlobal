local baseCell = autoImport("BaseCell")
SignIn21UnlockMenuCell = class("SignIn21UnlockMenuCell", baseCell)

function SignIn21UnlockMenuCell:Init()
  self.icon = self:FindComponent("Icon", UISprite)
  self.label = self:FindComponent("Label", UILabel)
  self:AddButtonEvent("GotoBtn", function()
    if not self.data then
      return
    end
    self:PassEvent(ServantRaidStatEvent.GoToBtnClick, self.data)
  end)
end

function SignIn21UnlockMenuCell:SetData(data)
  self.data = data
  if not data then
    return
  end
  self.label.text = data.Title
  IconManager:SetUIIcon(data.Icon, self.icon)
end
