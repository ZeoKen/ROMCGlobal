autoImport("UIEmojiCell")
ChatEmojiPage = class("ChatEmojiPage", SubView)

function ChatEmojiPage:Init()
  self:FindObjs()
  self:InitShow()
end

function ChatEmojiPage:FindObjs()
  self.contentScrollView = self:FindGO("EmojiScrollView", self.container.PopUpWindow):GetComponent(UIScrollView)
end

function ChatEmojiPage:InitShow()
  local container = self:FindGO("Emoji_Container", self.container.PopUpWindow)
  local childNum = math.floor(Screen.width / Screen.height * 720 / 1280 * 9)
  self.emojiCtl = WrapListCtrl.new(container, UIEmojiCell, "UIEmojiCell", WrapListCtrl_Dir.Vertical, childNum, 134)
  self.emojiCtl:AddEventListener(MouseEvent.MouseClick, self.ClickEmoji, self)
  self:UpdateView()
end

function ChatEmojiPage:UpdateView()
  local data = ChatRoomProxy.Instance:GetEmojiExpressions()
  self.emojiCtl:ResetDatas(data)
end

function ChatEmojiPage:ClickEmoji(cell)
  if self.cellClickDisabled then
    return
  end
  self:SetCellClickCD()
  local id = cell.id
  if id then
    local channel = self.container:GetCurrentChannel()
    local msgId = ChatRoomProxy.Instance:GetRandomExpressionTextId(ChatRoomProxy.ExpressionType.Emoji, id, channel == ChatChannelEnum.Private and Game.SocialManager:Find(ChatRoomProxy.Instance:GetCurrentPrivateChatId()))
    local expression = ReusableTable.CreateTable()
    expression.type = ChatRoomProxy.ExpressionType.Emoji
    expression.id = id
    self.container:SafeSend(msgId and Table_ExpressionText[msgId].Msg or "", nil, nil, nil, expression)
    ReusableTable.DestroyAndClearTable(expression)
  end
end

function ChatEmojiPage:SetCellClickCD()
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
