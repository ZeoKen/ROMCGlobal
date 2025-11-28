local baseCell = autoImport("BaseCell")
TechTreeGuideCell = class("TechTreeGuideCell", baseCell)

function TechTreeGuideCell:Init()
  self.icon = self:FindComponent("Icon", UISprite)
  self.name = self:FindComponent("Name", UILabel)
  self.title = self:FindComponent("Title", UILabel)
  self:AddButtonEvent("GoButton", function()
    self:ExcuteGuide()
  end)
end

function TechTreeGuideCell:SetData(data)
  self.data = data
  IconManager:SetUIIcon(data.Icon, self.icon)
  self.name.text = string.format(ZhString.TechTreeGuideCell_NameFormat, data.Name)
  self.title.text = data.Title
end

function TechTreeGuideCell:ExcuteGuide()
  if self.data.Finish == "submit_spec_quest" then
    FuncShortCutFunc.Me():DoQuest_AccDailyWorld(5)
  elseif self.data.Finish == "crack_raid" then
    FunctionGuide.Me():startClientGuide("crackraid")
  end
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.PopUpLayer)
end
