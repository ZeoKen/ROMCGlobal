autoImport("PlotStoryView")
autoImport("NormalButtonCell")
StoryView = class("StoryView", PlotStoryView)

function StoryView:Init()
  self.collider = self:FindGO("Collider")
  self.collider:SetActive(false)
  self:FindObj_Subtitle()
  self:FindObj_Narrator()
  self.buttonMap = {}
  self:MapEvent()
end
