local BaseCell = autoImport("BaseCell")
ReturnActivityDailyRewardCell = class("ReturnActivityDailyRewardCell", BaseCell)
autoImport("RewardGridCell")

function ReturnActivityDailyRewardCell:Init()
  ReturnActivityDailyRewardCell.super.Init(self)
  self:FindObjs()
end

function ReturnActivityDailyRewardCell:FindObjs()
  self.loginCheckIcon = self:FindGO("LoginCheckIcon"):GetComponent(UIMultiSprite)
  self.loginIconLight = self:FindGO("Light")
  self.dayLabel = self:FindGO("DayLabel"):GetComponent(UILabel)
  self.rewardGrid = self:FindGO("RewardGrid"):GetComponent(UIGrid)
  self.rewardGridCtrl = UIGridListCtrl.new(self.rewardGrid, RewardGridCell, "RewardGridCell")
  self.rewardGridCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickReward, self)
  self.sliderPart = self:FindGO("SliderPart")
  self.slider = self:FindGO("Slider", self.sliderPart):GetComponent(UISlider)
  self.dotLine = self:FindGO("DotLine")
  self.finishSymbol = self:FindGO("FinishSymbol")
  self.signInBtn = self:FindGO("SignInBtn")
  self:AddClickEvent(self.signInBtn, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function ReturnActivityDailyRewardCell:SetData(data)
  self.data = data
  self.id = data.id
  if self.indexInList == 1 then
    self.sliderPart:SetActive(false)
  end
  self.dayLabel.text = self.indexInList
  self.loginCheckIcon.CurrentState = 3
  self.rewards = data.rewards
  self.rewardGridCtrl:ResetDatas(self.rewards)
  if data.hideDotLine then
    self:HideDotLine()
  end
end

function ReturnActivityDailyRewardCell:SetStatus(isReward, status)
  if status == 1 then
    self.loginCheckIcon.CurrentState = 1
    self.signInBtn:SetActive(false)
    self.dayLabel.effectColor = LuaGeometry.GetTempVector4(0.8823529411764706, 0.5490196078431373, 0.5019607843137255, 1)
  elseif status == 2 then
    self.loginCheckIcon.CurrentState = 0
    self.signInBtn:SetActive(true)
    self.dayLabel.effectColor = LuaGeometry.GetTempVector4(0.796078431372549, 0.45098039215686275, 0.403921568627451, 1)
  else
    self.loginCheckIcon.CurrentState = 2
    self.signInBtn:SetActive(false)
    self.dayLabel.effectColor = LuaGeometry.GetTempVector4(0.4627450980392157, 0.4627450980392157, 0.4627450980392157, 1)
  end
  self.isReward = isReward
  self.finishSymbol:SetActive(isReward)
end

function ReturnActivityDailyRewardCell:HandleClickReward(cellCtrl)
  self:PassEvent(ReturnActivityEvent.ClickDailyReward, cellCtrl)
end

function ReturnActivityDailyRewardCell:HideDotLine()
  self.dotLine:SetActive(false)
end
