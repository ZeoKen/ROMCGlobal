local BaseCell = autoImport("BaseCell")
AdventureAppendCell = class("AdventureAppendCell", BaseCell)
autoImport("AdventureAppendView")

function AdventureAppendCell:Init()
  self:initView()
end

function AdventureAppendCell:initView()
  self.appendView = AdventureAppendView.new(self)
  self.isComplete = self:FindGO("isComplete")
  if self.isComplete then
    self:Hide(self.isComplete)
  end
  self.bg = self:FindComponent("bg", UISprite)
  self.tipBtnGO = self:FindGO("TipBtn")
  self:AddClickEvent(self.tipBtnGO, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function AdventureAppendCell:SetData(data)
  self.data = data
  self.appendView:SetData(data)
  if self.isComplete then
    if data:isCompleted() then
      self:Show(self.isComplete)
    else
      self:Hide(self.isComplete)
    end
  end
  local normalGrid = self:FindGO("normalGrid")
  local bound = NGUIMath.CalculateRelativeWidgetBounds(normalGrid.transform, true)
  local height = bound.size.y + 120
  self.bg.height = height
  if data.staticData and data.staticData.Content == "kill" then
    self.tipBtnGO:SetActive(true)
  else
    self.tipBtnGO:SetActive(false)
  end
end
