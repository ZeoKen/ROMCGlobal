autoImport("GuildTaskCell")
GuildChallengeTaskPopUp = class("GuildChallengeTaskPopUp", ContainerView)
GuildChallengeTaskPopUp.ViewType = UIViewType.PopUpLayer
local emptyList = {}
local btnState = {"com_btn_1", "com_btn_13"}

function GuildChallengeTaskPopUp:Init()
  self:FindObj()
  self:AddButtonEvt()
  self:AddViewEvt()
  self:InitShow()
end

function GuildChallengeTaskPopUp:FindObj()
  self.empty = self:FindGO("Empty")
  local emptyLab = self:FindComponent("Label", UILabel, self.empty)
  emptyLab.text = ZhString.GuildChallenge_Empty
  self.goBtn = self:FindComponent("GoBtn", UISprite)
  self.goBtnLabel = self:FindComponent("Label", UILabel, self.goBtn.gameObject)
  self.goBtnLabel.text = ZhString.GuildChallenge_Go
end

function GuildChallengeTaskPopUp:AddButtonEvt()
  self:AddClickEvent(self.goBtn.gameObject, function()
    if not self.canReward then
      return
    end
    FuncShortCutFunc.Me():CallByID(1000)
    self:CloseSelf()
    GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
  end)
end

function GuildChallengeTaskPopUp:RefreshGoBtn(canReward)
  if self.canReward == canReward then
    return
  end
  self.canReward = canReward
  self.goBtn.spriteName = canReward and btnState[1] or btnState[2]
  self.goBtnLabel.effectStyle = canReward and UILabel.Effect.Outline or UILabel.Effect.None
end

function GuildChallengeTaskPopUp:AddViewEvt()
  self:AddListenEvt(ServiceEvent.GuildCmdBuildingUpdateNtfGuildCmd, self.UpdateView)
  self:AddListenEvt(ServiceEvent.GuildCmdChallengeUpdateNtfGuildCmd, self.UpdateView)
end

function GuildChallengeTaskPopUp:InitShow()
  local container = self:FindGO("Container")
  local wrapConfig = {
    wrapObj = container,
    pfbNum = 4,
    cellName = "GuildTaskCell",
    control = GuildTaskCell,
    dir = 1
  }
  self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
  self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.OnClickReward, self)
  self:UpdateView()
end

function GuildChallengeTaskPopUp:OnClickReward(taskCell)
  if taskCell and taskCell ~= self.chooseTask then
    local data = taskCell.data
    local stick = taskCell.gameObject:GetComponent(UIWidget)
    if data then
      local callback = function()
        self:CancelChooseReward()
      end
      local sdata = {
        itemdata = data.reward_item,
        funcConfig = {},
        callback = callback,
        ignoreBounds = {
          taskCell.gameObject
        }
      }
      TipManager.Instance:ShowItemFloatTip(sdata, stick, NGUIUtil.AnchorSide.Left, {240, 0})
    end
    self.chooseTask = taskCell
  else
    self:CancelChooseReward()
  end
end

function GuildChallengeTaskPopUp:CancelChooseReward()
  self.chooseTask = nil
  self:ShowItemTip()
end

function GuildChallengeTaskPopUp:UpdateView()
  local data = GuildProxy.Instance:GetTaskTraceList()
  self.itemWrapHelper:UpdateInfo(data)
  self.empty:SetActive(#data == 0)
  local canReward = GuildProxy.Instance:HasGuildWelfare()
  self:RefreshGoBtn(canReward)
end

function GuildChallengeTaskPopUp:OnExit()
  GuildChallengeTaskPopUp.super.OnExit(self)
  self.itemWrapHelper:Destroy()
end
