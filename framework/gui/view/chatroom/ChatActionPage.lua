autoImport("UIEmojiCell")
ChatActionPage = class("ChatActionPage", SubView)

function ChatActionPage:Init()
  self:FindObjs()
  self:InitShow()
end

function ChatActionPage:FindObjs()
  self.contentScrollView = self:FindGO("ActionScrollView", self.container.PopUpWindow):GetComponent(UIScrollView)
end

function ChatActionPage:InitShow()
  local container = self:FindGO("Action_Container", self.container.PopUpWindow)
  local childNum = math.floor(Screen.width / Screen.height * 720 / 1280 * 9)
  self.emojiCtl = WrapListCtrl.new(container, UIEmojiCell, "UIEmojiCell", WrapListCtrl_Dir.Vertical, childNum, 134)
  self.emojiCtl:AddEventListener(MouseEvent.MouseClick, self.ClickAction, self)
  self:UpdateView()
end

function ChatActionPage:UpdateView()
  local data = ChatRoomProxy.Instance:GetActionExpressions()
  self.emojiCtl:ResetDatas(data)
end

function ChatActionPage:ClickAction(cell)
  if self.cellClickDisabled then
    return
  end
  self:SetCellClickCD()
  if cell.id then
    FunctionSecurity.Me():TryDoRealNameCentify(function()
      local channel = self.container:GetCurrentChannel()
      ChatRoomProxy.Instance:CallExpressionChatCmd(channel, ChatRoomProxy.ExpressionType.Action, cell.id, channel == ChatChannelEnum.Private and Game.SocialManager:Find(ChatRoomProxy.Instance:GetCurrentPrivateChatId()))
    end)
  end
end

function ChatActionPage:SetCellClickCD()
  if self.cellClickDisabledTwId then
    self.cellClickDisabledTwId:Destroy()
    self.cellClickDisabledTwId = nil
  end
  self.cellClickDisabled = true
  self.cellClickDisabledTwId = TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
    self.cellClickDisabled = false
    self.cellClickDisabledTwId = nil
  end, self)
end
