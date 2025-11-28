EDView2 = class("EDView2", ContainerView)
EDView2.ViewType = UIViewType.SystemOpenLayer
autoImport("Table_ED_Story")

function EDView2:Init()
  self.edStoryConfig = {}
  if Table_ED_Story then
    for _, storyData in pairs(Table_ED_Story) do
      if storyData.Chapter == 2 then
        table.insert(self.edStoryConfig, storyData)
      end
    end
    table.sort(self.edStoryConfig, function(a, b)
      return a.id < b.id
    end)
  end
  self.stroyLength = #self.edStoryConfig
  self.context = self:FindComponent("Context", UIWidget)
  self.midAnim = self:FindComponent("MidAnim", UIWidget)
  self.midContext = self:FindComponent("Context", UIWidget, self.midAnim.gameObject)
  self.midText = self:FindComponent("Text", UILabel, self.midAnim.gameObject)
  self.jumpButton = self:FindGO("JumpButton")
  self:AddClickEvent(self.jumpButton, function()
    if not self.excuteExit then
      self.excuteExit = true
      ServiceNUserProxy.Instance:ReturnToHomeCity()
    end
  end)
  self.endAnim = self:FindComponent("EndAnim", UIWidget)
  self.endContext = self:FindComponent("Context", UIWidget, self.endAnim.gameObject)
  self:MapEvent()
end

function EDView2:PlayStoryAnim()
  local index = self.stroyLength + 1 - self.count
  local storyData = self.edStoryConfig[index]
  if storyData then
    self.midText.text = storyData.Text
    self:DisPlayWidgetAnim(self.midContext, storyData.FadeinTime, storyData.StayTime, storyData.FadeOutTime, function()
      self.count = self.count - 1
      if self.count > 0 then
        self:PlayStoryAnim()
      else
        self.midAnim.alpha = 0
      end
    end)
  end
end

function EDView2:DisPlayWidgetAnim(uiWidget, showTime, stayTime, hideTime, endCall)
  self:RemoveLeanTween()
  self.lt = LeanTween.alphaNGUI(uiWidget, 0, 1, showTime):setOnComplete(function()
    self:RemoveLeanTween()
    TimeTickManager.Me():CreateOnceDelayTick(stayTime * 1000, function(owner, deltaTime)
      self.lt = LeanTween.alphaNGUI(uiWidget, 1, 0, hideTime):setOnComplete(function()
        self:RemoveLeanTween()
        if type(endCall) == "function" then
          endCall()
        end
      end)
    end, self)
  end)
end

function EDView2:RemoveLeanTween()
  if self.lt then
    self.lt:cancel()
  end
  self.lt = nil
end

function EDView2:MapEvent()
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.HandleMapChange)
end

function EDView2:HandleMapChange()
  self:CloseSelf()
end

function EDView2:OnEnter()
  EDView2.super.OnEnter(self)
  self.count = #self.edStoryConfig
  self.midAnim.alpha = 1
  self:PlayStoryAnim()
end

function EDView2:OnExit()
  EDView2.super.OnExit(self)
  self:RemoveLeanTween()
end
