local BaseCell = autoImport("BaseCell")
ActivityPuzzleGiftCell = class("ActivityPuzzleGiftCell", BaseCell)

function ActivityPuzzleGiftCell:Init()
  ActivityPuzzleGiftCell.super.Init(self)
  self:FindObjs()
end

function ActivityPuzzleGiftCell:FindObjs()
  self.giftPoint = self:FindComponent("GiftPoint", UILabel)
  self.giftParent = self:FindGO("GiftParent")
  self.giftButton = self:FindGO("GiftButton")
  self.giftButtonSprite = self:FindComponent("GiftButtonSprite", UISprite)
  self.lightsp = self:FindComponent("LightSprite", UISprite)
  self.stick = self:FindComponent("Stick", UIWidget)
  self.giftShakeTween = self:FindComponent("GiftButton", TweenRotation)
  self:AddButtonEvent("GiftButton", function(obj)
    if self.giftShakeTween.enabled then
      if ActivityPuzzleProxy.Instance:CheckUpdateRedtip(self.data.ActivityID) then
        ServiceSceneTipProxy.Instance:CallBrowseRedTipCmd(SceneTip_pb.EREDSYS_PUZZLE, self.data.ActivityID)
      end
      ServicePuzzleCmdProxy.Instance:CallActivePuzzleCmd(self.data.ActivityID, self.data.PuzzleID)
    else
      self:PassEvent(MouseEvent.MouseClick, self)
    end
  end)
end

function ActivityPuzzleGiftCell:SetData(data)
  self.data = data
  local list = ItemUtil.GetRewardItemIdsByTeamId(self.data.RewardID)
  local itemID
  if list then
    itemID = list[1].id
    if 1 >= list[1].num then
      self.giftPoint.text = ""
    else
      self.giftPoint.text = list[1].num
    end
  end
  local item = Table_Item[itemID]
  if item then
    IconManager:SetItemIcon(item.Icon, self.giftButtonSprite)
  end
end

local tempPos = LuaVector3()
local tempScale = LuaVector3.One()

function ActivityPuzzleGiftCell:UpdateGiftState(currentProgress, unitWidth)
  LuaVector3.Better_Set(tempPos, self.data.UnlockTime * unitWidth, 3.2, 0)
  self.giftParent.transform.localPosition = tempPos
  local itemData = ActivityPuzzleProxy.Instance:GetActivityPuzzleItemData(self.data.ActivityID, self.data.PuzzleID)
  if itemData then
    if itemData.PuzzleState == PuzzleCmd_pb.EPUZZLESTATE_ACTIVE then
      self.lightsp.gameObject:SetActive(true)
      self.giftShakeTween.enabled = false
    elseif itemData.PuzzleState == PuzzleCmd_pb.EPUZZLESTATE_CANACTIVE then
      self.lightsp.gameObject:SetActive(false)
      self.giftShakeTween.enabled = true
    elseif itemData.PuzzleState == PuzzleCmd_pb.EPUZZLESTATE_UNACTIVE then
      self.lightsp.gameObject:SetActive(false)
      self.giftShakeTween.enabled = false
    end
  else
    self.giftShakeTween.enabled = false
  end
  LuaVector3.Better_Set(tempScale, 1, 1, 1)
  LuaVector3.Mul(tempScale, 0.7)
  self.giftButtonSprite.gameObject.transform.localScale = tempScale
end
