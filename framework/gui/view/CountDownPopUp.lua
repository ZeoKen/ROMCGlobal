CountDownPopUp = class("CountDownPopUp", BaseView)
CountDownPopUp.ViewType = UIViewType.NormalLayer

function CountDownPopUp:Init()
  self:FindObjs()
  self:AddViewEvts()
  self:initData()
  self:CountDownReady()
end

function CountDownPopUp:initData()
  local viewdata = self.viewdata and self.viewdata.viewdata
  self.questData = viewdata and viewdata.questData
  if self.questData then
    self.curCountDown = self.questData.params.count or 3
  else
    self.curCountDown = 3
  end
end

function CountDownPopUp:FindObjs()
  self.countDownLabel = self:FindGO("CountDownLabel"):GetComponent(UILabel)
  self.countDownGO = self.countDownLabel.gameObject
  self.countDownTweenScale = self.countDownGO:GetComponent(TweenScale)
  self.countDownTweenScale:SetOnFinished(function()
    self.curCountDown = self.curCountDown - 1
    if self.curCountDown == 0 then
      self:QuestNotify()
      self:CloseSelf()
      return
    end
    self.countDownLabel.text = self.curCountDown
    self.countDownTweenScale:ResetToBeginning()
    self.countDownTweenScale:PlayForward()
  end)
end

function CountDownPopUp:AddViewEvts()
end

function CountDownPopUp:CountDownReady()
  self.countDownLabel.text = self.curCountDown
  self.countDownTweenScale:ResetToBeginning()
  self.countDownTweenScale:PlayForward()
end

function CountDownPopUp:QuestNotify()
  if self.questData then
    QuestProxy.Instance:notifyQuestState(self.questData.scope, self.questData.id, self.questData.staticData.FinishJump)
  end
end
