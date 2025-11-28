local BaseCell = autoImport("BaseCell")
ImproveGiftCell = class("ImproveGiftCell", BaseCell)

function ImproveGiftCell:Init()
  ImproveGiftCell.super.Init(self)
  self:FindObjs()
  IconManager:SetUIIcon("growup2", self.giftButtonSprite)
end

function ImproveGiftCell:FindObjs()
  self.giftPoint = self:FindComponent("GiftPoint", UILabel)
  self.giftParent = self:FindGO("GiftParent")
  self.giftButton = self:FindGO("GiftButton")
  self.giftButtonSprite = self:FindComponent("GiftButtonSprite", UISprite)
  self.stick = self:FindComponent("Stick", UIWidget)
  self.giftShakeTween = self:FindComponent("GiftButton", TweenRotation)
  self:AddButtonEvent("GiftButton", function(obj)
    self:OnClickGiftBtn()
  end)
  local longPress = self.giftButton:GetComponent(UILongPress)
  
  function longPress.pressEvent(obj, state)
    self:PassEvent(MouseEvent.LongPress, {state, self})
  end
end

function ImproveGiftCell:OnClickGiftBtn()
  local staticData = self.groupData and self.groupData.groupid and Table_ServantImproveGroup[self.groupData.groupid]
  local valid = ServantRecommendProxy.CheckDateValid(staticData)
  if valid then
    if self.giftShakeTween.enabled then
      ServiceNUserProxy.Instance:CallReceiveGrowthServantUserCmd(self.groupData.groupid, self.data.value)
    end
  else
    MsgManager.ShowMsgByID(5209)
  end
end

local tempPos = LuaVector3()

function ImproveGiftCell:SetData(data)
  self.data = data
  self.giftParent.transform.localPosition = LuaVector3.Better_Set(tempPos, data.value * 5, 3.2, 0)
  self.giftPoint.text = data.value
end

function ImproveGiftCell:UpdateGiftState(groupData)
  self.groupData = groupData
  local value = self.data.value
  local isValueExist = false
  local everRewardList = groupData.everReward
  if everRewardList and 0 < #everRewardList then
    for i = 1, #everRewardList do
      if value == everRewardList[i] then
        isValueExist = true
        break
      end
    end
  end
  if isValueExist then
    IconManager:SetUIIcon("growup2", self.giftButtonSprite)
    self.giftShakeTween.enabled = false
  else
    IconManager:SetUIIcon("growup1", self.giftButtonSprite)
    if groupData.growth and value <= groupData.growth then
      self.giftShakeTween.enabled = true
    else
      self.giftShakeTween.enabled = false
    end
  end
  self.giftButtonSprite:MakePixelPerfect()
end
